package com.wildguard.backend.modules.teammates.uc03_community;

import com.wildguard.backend.modules.incident.model.IncidentSeverity;
import java.time.Instant;

/** Domain data for one community reported human-wildlife conflict. */
public record CommunityConflictReport(
        String id,
        String reporterName,
        String reporterPhone,
        String title,
        String description,
        String villageZone,
        String channel,
        Double latitude,
        Double longitude,
        IncidentSeverity severity,
        CommunityReportStatus status,
        Instant createdAt,
        String cloNotes,
        String rangerUnit,
        String dispatchPriority,
        String dispatchInstructions) {
}
