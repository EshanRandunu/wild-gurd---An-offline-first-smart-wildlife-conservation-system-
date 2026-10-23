package com.wildguard.backend.modules.teammates.uc03_community;

import com.wildguard.backend.common.exception.ValidationException;
import com.wildguard.backend.modules.incident.model.IncidentSeverity;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@DisplayName("Community report rules unit tests")
class CommunityReportRulesTest {

    private CommunityConflictReport validReport() {
        return new CommunityConflictReport(
                "report-1", "Nimal Perera", "+94771234567", "Elephant near homes",
                "Elephant seen beside the school road.", "North sector", "MOBILE_APP",
                6.3721, 81.4012, IncidentSeverity.HIGH, CommunityReportStatus.UNVERIFIED,
                Instant.now(), null, null, null, null);
    }

    private CommunityConflictReport with(
            String id, String reporter, String title, String description, String zone,
            String channel, Double latitude, Double longitude, IncidentSeverity severity,
            CommunityReportStatus status, Instant timestamp) {
        return new CommunityConflictReport(id, reporter, null, title, description, zone,
                channel, latitude, longitude, severity, status, timestamp, null, null, null, null);
    }

    @Nested
    @DisplayName("Report submission validation")
    class SubmissionValidation {
        @Test void acceptsACompleteMobileAppReport() {
            assertDoesNotThrow(() -> CommunityReportRules.validateSubmission(validReport()));
        }

        @Test void acceptsSmsAsAReportChannel() {
            CommunityConflictReport sms = new CommunityConflictReport("sms-1", "Resident", null,
                    "Wildlife sighting", "Elephant by the road", "North", "SMS", 6.3, 81.4,
                    IncidentSeverity.MEDIUM, CommunityReportStatus.UNVERIFIED, Instant.now(),
                    null, null, null, null);
            assertDoesNotThrow(() -> CommunityReportRules.validateSubmission(sms));
        }

        @Test void acceptsChannelIgnoringLetterCase() {
            var r = with("r1", "Resident", "Title", "Description", "Zone", "mobile_app", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertDoesNotThrow(() -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsANullReport() {
            ValidationException ex = assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateSubmission(null));
            assertEquals("Community report is required.", ex.getMessage());
        }

        @Test void rejectsBlankReportId() {
            var r = with(" ", "Resident", "Title", "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsMissingReporterName() {
            var r = with("r1", " ", "Title", "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsMissingConflictTitle() {
            var r = with("r1", "Resident", null, "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsBlankDescription() {
            var r = with("r1", "Resident", "Title", "  ", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsMissingVillageZone() {
            var r = with("r1", "Resident", "Title", "Description", "", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsUnsupportedChannel() {
            var r = with("r1", "Resident", "Title", "Description", "Zone", "EMAIL", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsNullLatitude() {
            assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateCoordinates(null, 81.4));
        }

        @Test void rejectsLatitudeOutsideTheGlobe() {
            assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateCoordinates(90.01, 81.4));
        }

        @Test void rejectsInfiniteLatitude() {
            assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateCoordinates(Double.POSITIVE_INFINITY, 81.4));
        }

        @Test void rejectsNullLongitude() {
            assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateCoordinates(6.3, null));
        }

        @Test void rejectsLongitudeOutsideTheGlobe() {
            assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateCoordinates(6.3, -180.01));
        }

        @Test void rejectsNanLongitude() {
            assertThrows(ValidationException.class,
                    () -> CommunityReportRules.validateCoordinates(6.3, Double.NaN));
        }

        @Test void acceptsCoordinateBoundaryValues() {
            assertDoesNotThrow(() -> CommunityReportRules.validateCoordinates(-90.0, 180.0));
        }

        @Test void rejectsMissingSeverity() {
            var r = with("r1", "Resident", "Title", "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    null, CommunityReportStatus.UNVERIFIED, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsMissingStatus() {
            var r = with("r1", "Resident", "Title", "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, null, Instant.now());
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsMissingTimestamp() {
            var r = with("r1", "Resident", "Title", "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, null);
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }

        @Test void rejectsFutureTimestamp() {
            var r = with("r1", "Resident", "Title", "Description", "Zone", "MOBILE_APP", 6.3, 81.4,
                    IncidentSeverity.LOW, CommunityReportStatus.UNVERIFIED, Instant.now().plusSeconds(60));
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateSubmission(r));
        }
    }

    @Nested
    @DisplayName("Report lifecycle and dispatch rules")
    class LifecycleRules {
        @Test void allowsPendingReportToBecomeUnverified() {
            assertDoesNotThrow(() -> CommunityReportRules.validateTransition(
                    CommunityReportStatus.PENDING_SYNC, CommunityReportStatus.UNVERIFIED));
        }

        @Test void allowsUnverifiedReportToBecomeVerified() {
            assertDoesNotThrow(() -> CommunityReportRules.validateTransition(
                    CommunityReportStatus.UNVERIFIED, CommunityReportStatus.VERIFIED));
        }

        @Test void allowsVerifiedReportToBeDispatched() {
            assertDoesNotThrow(() -> CommunityReportRules.validateTransition(
                    CommunityReportStatus.VERIFIED, CommunityReportStatus.IN_PROGRESS));
        }

        @Test void allowsDispatchedReportToBeResolved() {
            assertDoesNotThrow(() -> CommunityReportRules.validateTransition(
                    CommunityReportStatus.IN_PROGRESS, CommunityReportStatus.RESOLVED));
        }

        @Test void preventsChangesAfterResolution() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateTransition(
                    CommunityReportStatus.RESOLVED, CommunityReportStatus.VERIFIED));
        }

        @Test void acceptsAnUnchangedStatus() {
            assertDoesNotThrow(() -> CommunityReportRules.validateTransition(
                    CommunityReportStatus.VERIFIED, CommunityReportStatus.VERIFIED));
        }

        @Test void requiresNotesToRejectAReport() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateClosureNotes(
                    CommunityReportStatus.REJECTED, " "));
        }

        @Test void requiresNotesToMarkADuplicate() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateClosureNotes(
                    CommunityReportStatus.DUPLICATE, null));
        }

        @Test void acceptsValidDispatchAssignment() {
            assertDoesNotThrow(() -> CommunityReportRules.validateDispatch(
                    "Alpha Unit - Rapid Response", "P1 - Immediate", "Approach from the west."));
        }

        @Test void rejectsUnknownRangerUnit() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateDispatch(
                    "Delta Unit", "P2 - Urgent", "Approach from the west."));
        }

        @Test void rejectsUnknownDispatchPriority() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateDispatch(
                    "Bravo Unit - Corridor Patrol", "P4", "Keep residents back."));
        }

        @Test void requiresTacticalInstructions() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateDispatch(
                    "Charlie Unit - Veterinary & Dart", "P3 - Routine", " "));
        }

        @Test void validatesPublishedAlertFieldsAndCoordinates() {
            assertDoesNotThrow(() -> CommunityReportRules.validateAlert(
                    "Elephant on road", "North sector", "Avoid the school route.",
                    IncidentSeverity.CRITICAL, 6.3, 81.4));
        }

        @Test void rejectsAlertWithoutSafetyAdvisory() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateAlert(
                    "Elephant on road", "North sector", " ", IncidentSeverity.HIGH, 6.3, 81.4));
        }

        @Test void rejectsAlertWithoutSeverity() {
            assertThrows(ValidationException.class, () -> CommunityReportRules.validateAlert(
                    "Elephant on road", "North sector", "Avoid this route.", null, 6.3, 81.4));
        }
    }
}
