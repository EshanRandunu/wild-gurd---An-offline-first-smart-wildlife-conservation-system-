package com.wildguard.backend.modules.teammates.uc03_community;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CommunityReportServiceImpl implements CommunityReportService {
    private final CommunityRecordRepository repository;
    @Override public List<Map<String,Object>> reports(String username, boolean liaison) {
        var records = liaison ? repository.findByKindOrderByIdDesc("REPORT") : repository.findByKindAndReporterUsernameOrderByIdDesc("REPORT", username);
        return records.stream().map(CommunityRecord::getPayload).toList();
    }
    @Override public List<Map<String,Object>> alerts() { return repository.findByKindOrderByIdDesc("ALERT").stream().map(CommunityRecord::getPayload).toList(); }
    @Override public Map<String,Object> saveReport(Map<String,Object> payload, String username) {
        String id = String.valueOf(payload.getOrDefault("id", ""));
        if(id.isBlank()) throw new IllegalArgumentException("Report id is required");
        var record = repository.findById(id).orElseGet(CommunityRecord::new);
        if (record.getPayload() != null) {
            var mergedPayload = new HashMap<>(record.getPayload());
            mergedPayload.putAll(payload);
            payload = mergedPayload;
        }
        record.setId(id); record.setKind("REPORT");
        boolean newReport = record.getReporterUsername() == null;
        if (newReport) record.setReporterUsername(username);
        if ("PENDING_SYNC".equals(payload.get("status"))) payload.put("status", "UNVERIFIED");
        record.setPayload(payload);
        return repository.save(record).getPayload();
    }
    @Override public Map<String,Object> saveAlert(Map<String,Object> payload) {
        String id = String.valueOf(payload.getOrDefault("id", ""));
        if(id.isBlank()) throw new IllegalArgumentException("Alert id is required");
        var record = repository.findById(id).orElseGet(CommunityRecord::new);
        record.setId(id); record.setKind("ALERT"); record.setPayload(payload);
        return repository.save(record).getPayload();
    }

    @Override public Map<String,Object> receiveSms(String senderPhone, String message) {
        if (senderPhone == null || senderPhone.isBlank() || message == null || message.isBlank()) {
            throw new IllegalArgumentException("senderPhone and message are required");
        }
        var payload = new HashMap<String,Object>();
        payload.put("id", "sms-" + UUID.randomUUID());
        payload.put("reporterName", "SMS sender");
        payload.put("reporterPhone", senderPhone.trim());
        String[] parts = message.trim().split("\\|", 3);
        payload.put("type", parts.length == 3 ? parts[0].trim() : "COMMUNITY_SMS");
        payload.put("zone", parts.length == 3 ? parts[1].trim() : "Location not parsed from SMS");
        payload.put("description", parts.length == 3 ? parts[2].trim() : message.trim());
        payload.put("channel", "SMS");
        payload.put("severity", "MEDIUM");
        payload.put("status", "UNVERIFIED");
        payload.put("createdAt", java.time.Instant.now().toString());
        return saveReport(payload, "sms:" + senderPhone.trim());
    }
}
