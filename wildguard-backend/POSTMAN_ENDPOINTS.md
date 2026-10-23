# WildGuard backend endpoints

Base URL: `http://localhost:8080`. URLs below are complete examples. For a deployed backend replace the host and port. Protected endpoints use `Authorization: Bearer {{token}}`; login with the relevant role, then copy `token` from the response into the Postman collection variable. Role names are `ROLE_MANAGER`, `ROLE_LIAISON`, `ROLE_VILLAGER`, and `ROLE_RANGER`.

## Authentication

| Method | Complete URL | Access | Body / query |
|---|---|---|---|
| POST | `http://localhost:8080/api/auth/register` | Public | `{"username":"villager1","email":"villager@example.com","password":"secret123","fullName":"Example Villager","phoneNumber":"+94000000000","role":"VILLAGER"}`. Required fields: username, email, password, fullName. |
| POST | `http://localhost:8080/api/auth/login` | Public | `{"username":"villager1","password":"secret123"}`. Response contains `token`, `tokenType`, `userId`, username, email, fullName, role, and profile fields. |
| GET | `http://localhost:8080/api/auth/next-badge?role=RANGER` | Public | Role query is optional (default RANGER); response: `{"badgeNumber":"..."}`. |

## Profiles

| Method | Complete URL | Access | Body / response |
|---|---|---|---|
| GET | `http://localhost:8080/api/rangers/me` | RANGER | Returns the ranger profile. |
| GET | `http://localhost:8080/api/rangers/profile` | Any authenticated role | Returns the signed-in user's profile. |
| PUT | `http://localhost:8080/api/rangers/profile` | Any authenticated role | `{"fullName":"Updated Name","email":"updated@example.com","phoneNumber":"+94000000000","assignedPark":"North Reserve"}`. `assignedPark` is accepted for LIAISON/RANGER. Username, role and password cannot be changed here. |

## Community reports and alerts

| Method | Complete URL | Access | Body / query |
|---|---|---|---|
| GET | `http://localhost:8080/api/v1/community-reports` | LIAISON, VILLAGER | Liaison receives all reports; villager receives own reports. Bearer token required. |
| POST | `http://localhost:8080/api/v1/community-reports` | LIAISON, VILLAGER | `{"id":"report-001","reporterName":"Example Villager","reporterPhone":"+94000000000","type":"ELEPHANT","description":"Elephant near homes","zone":"North village","channel":"MOBILE_APP","latitude":7.95,"longitude":80.75,"severity":"HIGH","status":"UNVERIFIED","createdAt":"2026-10-11T08:00:00Z","photoBase64":null}`. Bearer token required. |
| POST | `http://localhost:8080/api/v1/community-reports/sms` | Public (no token) | SMS gateway/demo ingress: `{"senderPhone":"+94000000000","message":"WILDLIFE | North village | Elephant seen near the school"}`. Message format is `TYPE | ZONE | MESSAGE`; any sender can submit. Creates an `SMS`/`UNVERIFIED` report for CLO review. A plain text message is also accepted. |
| PATCH | `http://localhost:8080/api/v1/community-reports/{id}/status` | LIAISON | Replace `{id}` with report ID. Body: `{"status":"VERIFIED","cloNotes":"Checked with village contact"}`. Bearer token required. |
| PUT | `http://localhost:8080/api/v1/community-reports/{id}/dispatch` | LIAISON | Body: `{"rangerUnit":"Alpha Unit - Rapid Response","dispatchPriority":"P1 - Immediate","dispatchInstructions":"Check north village edge"}`; server sets status to `IN_PROGRESS`. Bearer token required. |
| POST | `http://localhost:8080/api/v1/community-reports/{id}/publish-alert` | LIAISON | Body: `{"title":"Wildlife nearby","severity":"HIGH","zone":"North village","advisory":"Keep a safe distance","latitude":7.95,"longitude":80.75}`. Bearer token required. |
| GET | `http://localhost:8080/api/v1/community-reports/alerts` | LIAISON, VILLAGER | List published alerts. Bearer token required. |
| POST | `http://localhost:8080/api/v1/community-reports/alerts` | LIAISON | `{"id":"alert-001","title":"Community safety alert","severity":"HIGH","zone":"North village","advisory":"Keep a safe distance","latitude":7.95,"longitude":80.75}`. Bearer token required. |

## Ranger / villager incidents

| Method | Complete URL | Access | Body / query |
|---|---|---|---|
| POST | `http://localhost:8080/api/incidents/sync` | RANGER, VILLAGER | `{"localIncidentId":"local-001","type":"SNARE","severity":"HIGH","description":"Snare found near trail","latitude":7.95,"longitude":80.75,"photoBase64":null,"timestamp":"2026-10-11T08:00:00Z"}`. Bearer token required. |
| POST | `http://localhost:8080/api/incidents/sync/batch` | RANGER, VILLAGER | `{"incidents":[{"localIncidentId":"local-001","type":"SNARE","severity":"HIGH","description":"Snare found","latitude":7.95,"longitude":80.75,"timestamp":"2026-10-11T08:00:00Z"}]}`. Bearer token required. |
| GET | `http://localhost:8080/api/incidents/my-history` | RANGER, VILLAGER | Authenticated user's incidents. Bearer token required. |

## Manager analytics

| Method | Complete URL | Access | Body / query |
|---|---|---|---|
| GET | `http://localhost:8080/api/analytics/dashboard?from=2026-10-01&to=2026-10-11&tz=Asia%2FColombo` | MANAGER | Optional query: from/to (YYYY-MM-DD), tz (default UTC), type, severity, ranger. Bearer token required. |
| GET | `http://localhost:8080/api/analytics/export?from=2026-10-01&to=2026-10-11&tz=Asia%2FColombo` | MANAGER | Same query as dashboard; returns CSV attachment. Bearer token required. |

## Postman notes

- Set `baseUrl` to `http://localhost:8080` and `token` to the JWT returned from login.
- For protected requests set `Authorization: Bearer {{token}}` and `Content-Type: application/json` when sending JSON.
- Community report and alert handlers use flexible map payloads. Consult the Flutter model fields above; `photoBase64` is a base64 encoded image string.
- `/api/rangers/profile` was added for self-service profile reads and edits. Email uniqueness is enforced by the user collection index.
- SMS ingress is a demonstration endpoint for a gateway/webhook: it accepts unauthenticated JSON and queues an unverified report. It does not connect to a telecom provider.
- This reference covers the request mappings present in the backend controllers. Static resources and framework error responses are not API endpoints.
