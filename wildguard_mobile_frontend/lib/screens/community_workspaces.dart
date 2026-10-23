import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/community_alert_post.dart';
import '../models/community_conflict_report.dart';
import '../viewmodels/auth_manager.dart';
import '../viewmodels/community_conflict_manager.dart';
import 'login_screen.dart';

Future<void> _editProfile(BuildContext context) async {
  final auth = context.read<AuthManager>();
  final u = auth.currentUser;
  if (u == null) return;
  final name = TextEditingController(text: u.fullName), email = TextEditingController(text: u.email), phone = TextEditingController(text: u.phoneNumber ?? ''), park = TextEditingController(text: u.assignedPark ?? '');
  final messenger = ScaffoldMessenger.of(context);
  await showDialog<void>(context: context, builder: (d) => AlertDialog(title: const Text('Edit profile'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')), TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')), TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone')), if (u.role == 'ROLE_LIAISON' || u.role == 'ROLE_RANGER') TextField(controller: park, decoration: const InputDecoration(labelText: 'Assigned area / park'))])), actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')), ElevatedButton(onPressed: () async { try { await auth.updateProfile(fullName: name.text, email: email.text, phoneNumber: phone.text, assignedPark: u.role == 'ROLE_LIAISON' || u.role == 'ROLE_RANGER' ? park.text : null); if (d.mounted) Navigator.pop(d); messenger.showSnackBar(const SnackBar(content: Text('Profile updated'))); } catch (e) { messenger.showSnackBar(SnackBar(content: Text(e.toString()))); } }, child: const Text('Save'))]));
  name.dispose(); email.dispose(); phone.dispose(); park.dispose();
}

void _logout(BuildContext context) {
  context.read<AuthManager>().logout();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (_) => false,
  );
}

void _profile(BuildContext context) {
  final a = context.read<AuthManager>();
  showDialog(
    context: context,
    builder: (d) => AlertDialog(
      title: const Text('WildGuard Profile'),
      content: Text(
        'Name: ${a.rangerDisplayName}\nRole: ${a.currentUser?.role ?? 'Offline'}\nEmail: ${a.currentUser?.email ?? ''}',
      ),
      actions: [
        TextButton.icon(onPressed: () { Navigator.pop(d); _editProfile(context); }, icon: const Icon(Icons.edit), label: const Text('Edit details')),
        TextButton(
          onPressed: () => Navigator.pop(d),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    ),
  );
}

void _snackFrom(ScaffoldMessengerState messenger, String message) =>
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
Widget _card({required Widget child}) => Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    side: const BorderSide(color: AppColors.cardBorder),
  ),
  child: Padding(
    padding: const EdgeInsets.all(AppConstants.standardPadding),
    child: child,
  ),
);

class VillagerCommunityDashboard extends StatefulWidget {
  const VillagerCommunityDashboard({super.key});
  @override
  State<VillagerCommunityDashboard> createState() =>
      _VillagerCommunityDashboardState();
}

class _VillagerCommunityDashboardState
    extends State<VillagerCommunityDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CommunityConflictManager>().refresh(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = context.watch<CommunityConflictManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Safety'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: m.isLoading ? null : () => m.refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh alerts and reports',
          ),
          IconButton(
            onPressed: () => _profile(context),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile and logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: m.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'OFFICIAL COMMUNITY ALERTS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (m.alerts.isEmpty)
              _card(
                child: const Text(
                  'No published safety alerts. Pull down to refresh.',
                ),
              ),
            ...m.alerts.map((a) => _AlertCard(alert: a)),
            const SizedBox(height: 20),
            const Text(
              'MY SUBMITTED INCIDENT REPORTS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (m.reports.isEmpty)
              _card(
                child: const Text(
                  'Your incident reports and their status will appear here.',
                ),
              ),
            ...m.reports.map((r) => _ReportCard(report: r, villager: true)),
          ],
        ),
      ),
    );
  }
}

class LiaisonOfficerDashboardScreen extends StatefulWidget {
  const LiaisonOfficerDashboardScreen({super.key});
  @override
  State<LiaisonOfficerDashboardScreen> createState() =>
      _LiaisonOfficerDashboardScreenState();
}

class _LiaisonOfficerDashboardScreenState
    extends State<LiaisonOfficerDashboardScreen> {
  String filter = 'All';
  final filters = [
    'All',
    'Unverified',
    'Verified',
    'In Progress',
    'Critical',
    'Resolved',
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CommunityConflictManager>().refresh(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = context.watch<CommunityConflictManager>();
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final open = m.reports.where((r) => r.status != ConflictReportStatus.resolved && r.status != ConflictReportStatus.rejected).length;
    final evidenced = m.reports.where((r) => (r.photoBase64 ?? '').isNotEmpty).length;
    final critical = m.reports.where((r) => r.severity == ThreatSeverity.critical).length;
    final rows = m.reports
        .where(
          (r) => switch (filter) {
            'Unverified' =>
              r.status == ConflictReportStatus.unverified ||
                  r.status == ConflictReportStatus.pendingSync,
            'Verified' => r.status == ConflictReportStatus.verified,
            'In Progress' => r.status == ConflictReportStatus.inProgress,
            'Critical' => r.severity == ThreatSeverity.critical,
            'Resolved' => r.status == ConflictReportStatus.resolved,
            _ => true,
          },
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Report Triage'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: m.refresh, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () => _profile(context),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1500), child: ListView(
        padding: EdgeInsets.symmetric(horizontal: wide ? 28 : 16, vertical: 16),
        children: [
          Text('COMMUNITY OPERATIONS OVERVIEW', style: TextStyle(fontSize: wide ? 13 : 12, letterSpacing: 1.1, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10, runSpacing: 8,
            children: [
              _Kpi(title: 'Submitted reports', value: '${m.reports.length}'),
              _Kpi(
                title: 'Unverified',
                value:
                    '${m.reports.where((r) => r.status == ConflictReportStatus.unverified || r.status == ConflictReportStatus.pendingSync).length}',
              ),
              _Kpi(
                title: 'Critical',
                value:
                    '${m.reports.where((r) => r.severity == ThreatSeverity.critical).length}',
              ),
              _Kpi(
                title: 'Dispatched',
                value:
                    '${m.reports.where((r) => r.status == ConflictReportStatus.inProgress).length}',
              ),
              _Kpi(title: 'Open cases', value: '$open'),
              _Kpi(title: 'With evidence', value: '$evidenced'),
            ],
          ),
          const SizedBox(height: 14),
          if (wide) Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 3, child: _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Reports by status', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 16), SizedBox(height: 160, child: _StatusChart(reports: m.reports)), const SizedBox(height: 12), const Text('Reports by severity', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 110, child: _SeverityChart(reports: m.reports)), const SizedBox(height: 8), Text('$critical critical reports · $evidenced reports include public evidence', style: const TextStyle(color: AppColors.textSecondary))]))),
            const SizedBox(width: 12),
            Expanded(flex: 4, child: _ReportMap(reports: m.reports)),
          ]) else Column(children: [
            _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Reports by status', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 150, child: _StatusChart(reports: m.reports)), const Text('Reports by severity', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 110, child: _SeverityChart(reports: m.reports)), Text('$critical critical · $evidenced with evidence', style: const TextStyle(color: AppColors.textSecondary))])),
            const SizedBox(height: 8), _ReportMap(reports: m.reports),
          ]),
          const SizedBox(height: 16),
          Text('REPORT QUEUE · ${rows.length} SHOWN', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          const SizedBox(height: 14),
          Align(alignment: Alignment.centerLeft, child: OutlinedButton.icon(onPressed: () => _showSmsDemo(context), icon: const Icon(Icons.sms_outlined), label: const Text('Demonstrate incoming SMS report'))),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: filter == f,
                        onSelected: (_) => setState(() => filter = f),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          if (rows.isEmpty)
            _card(child: const Text('No reports in this queue yet.')),
          ...rows.map(
            (r) => _ReportCard(
              report: r,
              villager: false,
              onTap: () => _review(context, r),
            ),
          ),
        ],
      ))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newBroadcast(context),
        icon: const Icon(Icons.campaign),
        label: const Text('Broadcast alert'),
      ),
    );
  }

  Future<void> _showSmsDemo(BuildContext context) async {
    final phone = TextEditingController();
    final body = TextEditingController(text: 'WILDLIFE | North village | Elephant seen near the school');
    final messenger = ScaffoldMessenger.of(context);
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('Incoming SMS report demo'), content: SizedBox(width: 460, child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Simulates a public SMS gateway. Format: TYPE | ZONE | MESSAGE. The CLO receives it as an unverified report for review.'), const SizedBox(height: 12), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Sender phone number')), TextField(controller: body, maxLines: 3, decoration: const InputDecoration(labelText: 'SMS message'))])), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), ElevatedButton.icon(onPressed: () async { try { await context.read<AuthManager>().apiService.submitSmsReport(senderPhone: phone.text, message: body.text); await context.read<CommunityConflictManager>().refresh(); if (dialogContext.mounted) Navigator.pop(dialogContext); messenger.showSnackBar(const SnackBar(content: Text('SMS report received in the CLO review queue.'))); } catch (e) { messenger.showSnackBar(SnackBar(content: Text(e.toString()))); } }, icon: const Icon(Icons.send), label: const Text('Send SMS'))]));
    phone.dispose();
    body.dispose();
  }

  Future<void> _review(BuildContext context, CommunityConflictReport r) async {
    final manager = context.read<CommunityConflictManager>();
    final messenger = ScaffoldMessenger.of(context);
    final notes = TextEditingController(text: r.cloNotes ?? '');
    final instructions = TextEditingController(
      text: r.dispatchInstructions ?? '',
    );
    String? unit = r.rangerUnit;
    String? priority = r.dispatchPriority;
    ConflictReportStatus status = r.status;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.viewInsetsOf(ctx).bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Review ${r.id}',
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                if ((r.photoBase64 ?? '').isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('Villager submitted evidence', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.memory(base64Decode(r.photoBase64!.contains(',') ? r.photoBase64!.split(',').last : r.photoBase64!), height: 210, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(height: 80, child: Center(child: Text('Evidence image could not be displayed'))))),
                ] else const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('No photo evidence was attached to this report.')),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Report status'),
                  items: ConflictReportStatus.values
                      .where((s) => s != ConflictReportStatus.pendingSync)
                      .map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                      )
                      .toList(),
                  onChanged: (v) => set(() => status = v ?? status),
                ),
                DropdownButtonFormField<String>(
                  initialValue: unit,
                  decoration: const InputDecoration(
                    labelText: 'Ranger unit (for dispatch)',
                  ),
                  items:
                      const [
                            'Alpha Unit - Rapid Response',
                            'Bravo Unit - Corridor Patrol',
                            'Charlie Unit - Veterinary & Dart',
                          ]
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                  onChanged: (v) => set(() => unit = v),
                ),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  decoration: const InputDecoration(
                    labelText: 'Dispatch priority',
                  ),
                  items: const ['P1 - Immediate', 'P2 - Urgent', 'P3 - Routine']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => set(() => priority = v),
                ),
                TextField(
                  controller: instructions,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Tactical field instructions',
                  ),
                ),
                TextField(
                  controller: notes,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'CLO notes / safety advisory',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await manager.updateStatus(
                        r,
                        status,
                        notes: notes.text,
                        unit: unit,
                        priority: priority,
                        instructions: instructions.text,
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                      _snackFrom(
                        messenger,
                        'Report updated. Published alert is visible to villagers.',
                      );
                    } catch (e) {
                      _snackFrom(messenger, e.toString());
                    }
                  },
                  child: const Text('SAVE REVIEW / DISPATCH'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    notes.dispose();
    instructions.dispose();
  }

  Future<void> _newBroadcast(BuildContext context) async {
    final manager = context.read<CommunityConflictManager>();
    final messenger = ScaffoldMessenger.of(context);
    final title = TextEditingController(),
        zone = TextEditingController(),
        advice = TextEditingController();
    ThreatSeverity severity = ThreatSeverity.high;
    await showDialog(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (d, set) => AlertDialog(
          title: const Text('Emergency community broadcast'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Alert title / conflict type',
                  ),
                ),
                TextField(
                  controller: zone,
                  decoration: const InputDecoration(
                    labelText: 'Village zone / sector',
                  ),
                ),
                TextField(
                  controller: advice,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Safety advisory',
                  ),
                ),
                DropdownButton<ThreatSeverity>(
                  value: severity,
                  items: ThreatSeverity.values
                      .map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.code)),
                      )
                      .toList(),
                  onChanged: (v) => set(() => severity = v ?? severity),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await manager.createBroadcast(
                    title: title.text,
                    zone: zone.text,
                    advisory: advice.text,
                    severity: severity,
                  );
                  if (d.mounted) Navigator.pop(d);
                  _snackFrom(messenger, 'Community alert published.');
                } catch (e) {
                  _snackFrom(messenger, e.toString());
                }
              },
              child: const Text('PUBLISH'),
            ),
          ],
        ),
      ),
    );
    title.dispose();
    zone.dispose();
    advice.dispose();
  }
}

class LiaisonAlertsManagementScreen extends StatelessWidget {
  const LiaisonAlertsManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final m = context.watch<CommunityConflictManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Published Alerts'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: m.refresh, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () => _profile(context),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: m.alerts.isEmpty
          ? const Center(child: Text('No active broadcasts'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: m.alerts
                  .map(
                    (a) => _AlertCard(
                      alert: a,
                      canResolve: true,
                      onResolve: () => m.resolveAlert(a),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String title, value;
  const _Kpi({required this.title, required this.value});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.sizeOf(context).width >= 900 ? 190 : MediaQuery.sizeOf(context).width / 2 - 24,
    child: _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(title),
        ],
      ),
    ),
  );
}

class _ReportMap extends StatelessWidget {
  final List<CommunityConflictReport> reports;
  const _ReportMap({required this.reports});
  @override
  Widget build(BuildContext context) {
    final located = reports.where((r) => r.latitude.abs() > .001 && r.longitude.abs() > .001).toList();
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Submitted report locations', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 10), SizedBox(height: 250, child: FlutterMap(options: MapOptions(initialCenter: located.isEmpty ? const LatLng(7.8, 80.7) : LatLng(located.first.latitude, located.first.longitude), initialZoom: 7), children: [TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.wildguard.app'), MarkerLayer(markers: located.map((r) => Marker(point: LatLng(r.latitude, r.longitude), width: 42, height: 42, child: Tooltip(message: '${r.type} · ${r.zone}', child: Icon(Icons.location_on, size: 38, color: r.severity == ThreatSeverity.critical ? Colors.red : AppColors.primary)))).toList())])), if (located.isEmpty) const Text('No reports have map coordinates yet.', style: TextStyle(color: AppColors.textSecondary))]));
  }
}

class _StatusChart extends StatelessWidget {
  final List<CommunityConflictReport> reports;
  const _StatusChart({required this.reports});

  @override
  Widget build(BuildContext context) {
    final labels = ['Unverified', 'Verified', 'In progress', 'Resolved'];
    final statuses = [
      ConflictReportStatus.unverified,
      ConflictReportStatus.verified,
      ConflictReportStatus.inProgress,
      ConflictReportStatus.resolved,
    ];
    final values = statuses
        .map((s) => reports
            .where((r) =>
                r.status == s ||
                (s == ConflictReportStatus.unverified &&
                    r.status == ConflictReportStatus.pendingSync))
            .length)
        .toList();
    final maxV = values.fold<int>(1, (a, b) => a > b ? a : b);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        labels.length,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${values[i]}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 92 * values[i] / maxV + 4,
                  decoration: BoxDecoration(
                    color: [
                      AppColors.pendingAmber,
                      AppColors.primary,
                      Colors.blue,
                      AppColors.syncedGreen,
                    ][i],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeverityChart extends StatelessWidget {
  final List<CommunityConflictReport> reports;
  const _SeverityChart({required this.reports});

  @override
  Widget build(BuildContext context) {
    final levels = ThreatSeverity.values;
    final counts = levels
        .map((s) => reports.where((r) => r.severity == s).length)
        .toList();
    final maxCount = counts.fold<int>(1, (a, b) => a > b ? a : b);
    const colors = [
      AppColors.primary,
      AppColors.pendingAmber,
      Colors.deepOrange,
      AppColors.failedRed,
    ];
    
    return Row(
      children: List.generate(
        levels.length,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    levels[i].code,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: counts[i] / maxCount,
                      minHeight: 10,
                      color: colors[i],
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text('${counts[i]}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final CommunityConflictReport report;
  final bool villager;
  final VoidCallback? onTap;
  const _ReportCard({required this.report, required this.villager, this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      side: const BorderSide(color: AppColors.cardBorder),
    ),
    child: ListTile(
      onTap: onTap,
      leading: Icon(
        Icons.pets,
        color: report.severity == ThreatSeverity.critical
            ? AppColors.failedRed
            : AppColors.primary,
      ),
      title: Text(
        '${report.type} • ${report.id}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${report.channel}  ·  ${report.zone}\n${report.reporterName}${report.reporterPhone == null ? '' : ' · ${report.reporterPhone}'}\n${report.description}\n${report.latitude.toStringAsFixed(4)}, ${report.longitude.toStringAsFixed(4)}${report.rangerUnit == null ? '' : '\n${report.rangerUnit} dispatched'}${report.cloNotes == null ? '' : '\nCLO: ${report.cloNotes}'}',
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            report.severity.code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: report.severity == ThreatSeverity.critical
                  ? AppColors.failedRed
                  : AppColors.pendingAmber,
            ),
          ),
          Text(report.status.label, style: const TextStyle(fontSize: 10)),
          Icon((report.photoBase64 ?? '').isNotEmpty ? Icons.image : Icons.image_not_supported_outlined, size: 16, color: AppColors.textSecondary),
        ],
      ),
    ),
  );
}

class _AlertCard extends StatelessWidget {
  final CommunityAlertPost alert;
  final bool canResolve;
  final VoidCallback? onResolve;
  const _AlertCard({
    required this.alert,
    this.canResolve = false,
    this.onResolve,
  });
  @override
  Widget build(BuildContext context) => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                alert.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              alert.resolved ? 'ALL CLEAR' : alert.severity,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: alert.resolved
                    ? AppColors.syncedGreen
                    : AppColors.failedRed,
              ),
            ),
          ],
        ),
        Text('Zone: ${alert.zone}'),
        const SizedBox(height: 8),
        Text(alert.advisory),
        const SizedBox(height: 8),
        Text(
          '${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}  ·  ${alert.publishedAt.toLocal()}',
        ),
        if (alert.rangerEnRoute)
          const Text(
            'Ranger unit en route',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (canResolve && !alert.resolved)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onResolve,
              child: const Text('MARK ALL CLEAR'),
            ),
          ),
      ],
    ),
  );
}
