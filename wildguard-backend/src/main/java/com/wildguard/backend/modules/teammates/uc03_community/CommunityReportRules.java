package com.wildguard.backend.modules.teammates.uc03_community;

import com.wildguard.backend.common.exception.ValidationException;
import com.wildguard.backend.modules.incident.model.IncidentSeverity;
import java.time.Instant;
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Map;
import java.util.Locale;
import java.util.Set;

/** Pure validation and lifecycle rules shared by future UC03 service endpoints. */
public final class CommunityReportRules {
    private static final Map<CommunityReportStatus, Set<CommunityReportStatus>> TRANSITIONS = transitions();
    private static final Set<String> CHANNELS = Set.of("MOBILE_APP", "SMS");
    private static final Set<String> RANGER_UNITS = Set.of(
            "Alpha Unit - Rapid Response",
            "Bravo Unit - Corridor Patrol",
            "Charlie Unit - Veterinary & Dart");
    private static final Set<String> PRIORITIES = Set.of("P1 - Immediate", "P2 - Urgent", "P3 - Routine");

    private CommunityReportRules() {}

    public static void validateSubmission(CommunityConflictReport report) {
        if (report == null) throw new ValidationException("Community report is required.");
        requireText(report.id(), "Report ID");
        requireText(report.reporterName(), "Reporter name");
        requireText(report.title(), "Conflict title");
        requireText(report.description(), "Description");
        requireText(report.villageZone(), "Village zone");
        requireText(report.channel(), "Report channel");
        if (!CHANNELS.contains(report.channel().trim().toUpperCase(Locale.ROOT))) {
            throw new ValidationException("Report channel must be MOBILE_APP or SMS.");
        }
        validateCoordinates(report.latitude(), report.longitude());
        if (report.severity() == null) throw new ValidationException("Threat severity is required.");
        if (report.status() == null) throw new ValidationException("Report status is required.");
        if (report.createdAt() == null) throw new ValidationException("Report timestamp is required.");
        if (report.createdAt().isAfter(Instant.now())) {
            throw new ValidationException("Report timestamp cannot be in the future.");
        }
    }

    public static void validateCoordinates(Double latitude, Double longitude) {
        if (latitude == null || !Double.isFinite(latitude) || latitude < -90 || latitude > 90) {
            throw new ValidationException("Latitude must be a finite value from -90 through 90.");
        }
        if (longitude == null || !Double.isFinite(longitude) || longitude < -180 || longitude > 180) {
            throw new ValidationException("Longitude must be a finite value from -180 through 180.");
        }
    }

    public static void validateTransition(CommunityReportStatus current, CommunityReportStatus next) {
        if (current == null || next == null) throw new ValidationException("Current and next report statuses are required.");
        if (current == next) return;
        if (!TRANSITIONS.get(current).contains(next)) {
            throw new ValidationException("Report cannot move from " + current + " to " + next + ".");
        }
    }

    public static void validateClosureNotes(CommunityReportStatus status, String notes) {
        if ((status == CommunityReportStatus.REJECTED || status == CommunityReportStatus.DUPLICATE)
                && (notes == null || notes.isBlank())) {
            throw new ValidationException("CLO notes are required for rejected or duplicate reports.");
        }
    }

    public static void validateDispatch(String rangerUnit, String priority, String instructions) {
        if (rangerUnit == null || !RANGER_UNITS.contains(rangerUnit.trim())) {
            throw new ValidationException("A valid ranger unit is required for dispatch.");
        }
        if (priority == null || !PRIORITIES.contains(priority.trim())) {
            throw new ValidationException("A valid dispatch priority is required.");
        }
        requireText(instructions, "Tactical field instructions");
    }

    public static void validateAlert(String title, String zone, String advisory,
                                     IncidentSeverity severity, Double latitude, Double longitude) {
        requireText(title, "Alert title");
        requireText(zone, "Alert zone");
        requireText(advisory, "Safety advisory");
        if (severity == null) throw new ValidationException("Alert severity is required.");
        validateCoordinates(latitude, longitude);
    }

    private static void requireText(String value, String field) {
        if (value == null || value.isBlank()) throw new ValidationException(field + " is required.");
    }

    private static Map<CommunityReportStatus, Set<CommunityReportStatus>> transitions() {
        EnumMap<CommunityReportStatus, Set<CommunityReportStatus>> map = new EnumMap<>(CommunityReportStatus.class);
        map.put(CommunityReportStatus.PENDING_SYNC, EnumSet.of(CommunityReportStatus.UNVERIFIED));
        map.put(CommunityReportStatus.UNVERIFIED, EnumSet.of(CommunityReportStatus.VERIFIED,
                CommunityReportStatus.DUPLICATE, CommunityReportStatus.REJECTED));
        map.put(CommunityReportStatus.VERIFIED, EnumSet.of(CommunityReportStatus.IN_PROGRESS,
                CommunityReportStatus.RESOLVED, CommunityReportStatus.DUPLICATE, CommunityReportStatus.REJECTED));
        map.put(CommunityReportStatus.IN_PROGRESS, EnumSet.of(CommunityReportStatus.VERIFIED, CommunityReportStatus.RESOLVED));
        map.put(CommunityReportStatus.RESOLVED, EnumSet.noneOf(CommunityReportStatus.class));
        map.put(CommunityReportStatus.DUPLICATE, EnumSet.noneOf(CommunityReportStatus.class));
        map.put(CommunityReportStatus.REJECTED, EnumSet.noneOf(CommunityReportStatus.class));
        return Map.copyOf(map);
    }
}
