# 🐘 WildGuard — Smart Wildlife Conservation & Anti-Poaching Monitoring System

> **Smart monitoring, faster response, and data-driven wildlife conservation.**

WildGuard is a wildlife conservation and anti-poaching monitoring platform designed to help conservation teams monitor field activities, detect potential wildlife threats, process community conflict reports, and make data-driven operational decisions.

The platform connects **field rangers, community members, conservation officers, and park management** through a combination of mobile and web-based workflows.

The system is designed around real-world conservation challenges such as:

- Large geographic areas with limited staff
- Human-wildlife conflict around villages and farmland
- Illegal poaching and snaring
- Limited network connectivity in remote areas
- Delayed incident reporting
- Difficulty coordinating ranger responses
- Lack of centralized conservation intelligence

---

## 📌 Overview

WildGuard provides four major operational capabilities:

| Module | Purpose |
|---|---|
| 🥾 **Field Patrol & Incident Management** | Allows rangers to conduct patrols, track routes, and record wildlife incidents |
| 📡 **Animal & Sensor Monitoring** | Processes wildlife telemetry and detects high-risk geofence breaches |
| 🏘️ **Community Conflict Reporting** | Receives and processes human-wildlife conflict reports from communities |
| 📊 **Conservation Analytics** | Helps management analyze incidents, patrol coverage, hotspots, and trends |

The platform combines these workflows into a single conservation ecosystem.

---

# 🎯 Key Features

## 🥾 1. Field Patrol & Incident Management

Rangers can use the mobile application while conducting patrols in national parks.

### Features

- View assigned patrol routes
- Start and end patrol sessions
- Track ranger movement using GPS
- Record patrol waypoints
- Log wildlife and conservation incidents
- Capture incident photographs
- Record incident descriptions
- Select incident types and severity
- Work without network connectivity
- Store incident information locally
- Synchronize data when connectivity is restored
- View pending synchronization status

### Example incidents

- Poaching snares
- Animal carcasses
- Illegal campsites
- Wildlife sightings
- Other field incidents

The system follows an **offline-first approach**, allowing critical field information to be recorded even when the ranger has no cellular connection.

---

# 📡 2. Animal & Sensor Monitoring

WildGuard can process telemetry from wildlife tracking systems and detect animals entering predefined high-risk areas.

### Workflow

```text
GPS Collar
    ↓
Telemetry Reception
    ↓
Data Validation
    ↓
Location Processing
    ↓
Geofence Evaluation
    ↓
Threat Assessment
    ↓
Alert Generation
    ↓
Nearest Ranger Identification
    ↓
Ranger Notification
    ↓
Response Tracking
```

### Features

- Receive GPS telemetry
- Validate sensor data
- Track animal locations
- Maintain animal tracking history
- Configure high-risk zones
- Perform geofence checks
- Detect potential zone breaches
- Assess threat levels
- Generate alerts
- Identify available nearby rangers
- Notify responsible officers
- Track alert acknowledgement
- Track dispatch and response
- Handle connectivity limitations
- Synchronize queued updates

---

# 🏘️ 3. Community Conflict Reporting

Community members can report human-wildlife conflicts through supported reporting channels such as SMS or a mobile application.

The system processes the report before making it available to a Community Liaison Officer (CLO).

### Reporting workflow

```text
Community Member
       ↓
Submit Report
       ↓
SMS / Mobile App
       ↓
Report Validation
       ↓
Location Validation
       ↓
Duplicate Detection
       ↓
Incident Classification
       ↓
Threat Assessment
       ↓
CLO Review
       ↓
┌──────────────┬───────────────────┬───────────────┐
│              │                   │
Verified   More Information     Rejected
│              │                   │
↓              ↓                   ↓
Response     Review Again       REJECTED
Workflow                         + Reason
│
↓
Ranger Dispatch
```

### Features

- Receive community reports
- Support multiple reporting channels
- Validate report information
- Validate incident location
- Detect duplicate reports
- Classify incidents
- Assess threat levels
- Review reports through the CLO workflow
- Request additional information
- Verify valid reports
- Reject false or unverifiable reports
- Record rejection reasons
- Maintain report history
- Prevent rejected reports from entering ranger dispatch

---

# 🔎 Report Verification & Rejection

An important improvement in the community reporting workflow is the explicit handling of reports that cannot be verified.

Previously, a report could reach the officer review stage without a clearly defined outcome for a false, invalid, or unverifiable report.

WildGuard introduces a clearer decision lifecycle:

```text
                CLO Review
                    │
        ┌───────────┼───────────┐
        ↓           ↓           ↓
    VERIFIED    MORE INFO    REJECTED
        │           │           │
        ↓           ↓           ↓
   Continue      Request      Record
   Response      Details      Reason
        │           │           │
        ↓           ↓           ↓
   Dispatch     Review Again   No Dispatch
```


# 📊 4. Conservation Analytics

WildGuard provides conservation analytics to support operational and strategic decision-making.

Management and research users can analyze collected conservation data to identify patterns and high-risk areas.

### Analytics capabilities

- Incident analysis
- Incident categorization
- Incident trends
- Incident distribution
- Location-based analysis
- Wildlife incident hotspots
- High-risk areas
- Patrol coverage analysis
- Historical conservation data
- Report generation
- PDF/CSV export where supported

### Example analytical workflow

```text
Collected System Data
        ↓
Select Park / Area
        ↓
Select Date Range
        ↓
Select Analysis Type
        ↓
Data Processing
        ↓
┌───────────────┬───────────────┐
↓               ↓
Incident       Patrol
Analysis       Analysis
↓               ↓
Trends         Coverage
Hotspots       Gaps
Distribution   Activity
        ↓
Conservation Report
```

---

# 🗺️ Location & Mapping

Location information is an important part of the platform.

WildGuard uses location data to support:

- Ranger tracking
- Patrol routes
- Incident locations
- Community conflict locations
- Wildlife locations
- Geofence boundaries
- High-risk areas
- Ranger assignment
- Conservation hotspot analysis

The platform is designed to work with location information even in challenging field environments.

---

# 📱 Offline-First Field Operations

One of the key design goals of WildGuard is supporting rangers working in areas with unreliable or unavailable network connectivity.

Instead of requiring continuous internet connectivity:

```text
             Ranger
                ↓
        Mobile Application
                ↓
       Local Device Storage
                ↓
        Pending Sync Queue
                ↓
       Network Available?
          ↙          ↘
        NO            YES
        ↓              ↓
     Remain         Upload Data
     Pending            ↓
                       ↓
                    Server
                       ↓
                    SYNCED
```

This allows a ranger to continue performing critical tasks without waiting for a network connection.

---

# 👥 User Roles

## 🥾 Ranger

Field operator responsible for:

- Conducting patrols
- Following assigned routes
- Recording incidents
- Capturing field evidence
- Responding to alerts
- Updating response status

---

## 🏘️ Community Member

Community users can:

- Report human-wildlife conflicts
- Provide incident information
- Submit locations
- Provide additional information when requested

---

## 👮 Community Liaison Officer

Responsible for community report processing.

The CLO can:

- Review community reports
- Check report details
- Review locations
- Assess available information
- Verify reports
- Request additional information
- Reject invalid or unverifiable reports
- Record rejection reasons
- Process the report through the appropriate response workflow

---

## 🧑‍💼 Park Manager

Responsible for operational oversight.

The Park Manager can use system information to:

- Monitor conservation operations
- Review incidents
- Monitor patrol activity
- Analyze operational data
- Identify high-risk areas
- Support resource allocation
- Review conservation analytics

---

## 🔬 Conservation Researcher

Uses historical conservation information for:

- Long-term analysis
- Conservation research
- Incident trend analysis
- Hotspot analysis
- Report generation

---

# 🔗 External Systems

The platform can interact with external systems such as:

- GPS / location services
- Wildlife GPS collar systems
- Camera sensor systems
- SMS gateway
- Notification services

These integrations allow WildGuard to combine community intelligence, ranger field data, and automated sensor information.

---

# 🏗️ System Architecture

WildGuard follows a layered architecture so that user interfaces, business logic, and data persistence remain separated.

Conceptually:

```text
┌─────────────────────────────────────────┐
│              User Interfaces            │
│                                         │
│   Ranger Mobile App   Operations UI     │
│   Community Reporting   CLO Dashboard   │
└───────────────────┬─────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────┐
│             API / Controllers           │
└───────────────────┬─────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────┐
│             Service Layer               │
│                                         │
│ Report Processing                       │
│ Patrol Management                       │
│ Alert Management                        │
│ Threat Assessment                       │
│ Dispatch Coordination                   │
│ Analytics                               │
│ Synchronization                         │
└───────────────────┬─────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────┐
│         Repository / Persistence         │
└───────────────────┬─────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────┐
│               Database                  │
└─────────────────────────────────────────┘
```


---

# 🧩 Main System Components

The system is organized around several major domains.

### Field Operations

Handles:

- Rangers
- Patrols
- Patrol routes
- Waypoints
- Field incidents
- Photos
- Offline synchronization

### Wildlife Monitoring

Handles:

- Animals
- GPS collars
- Telemetry
- Geofence zones
- Alerts
- Threat levels

### Community Reporting

Handles:

- Villagers
- Community reports
- Report validation
- Duplicate detection
- Report classification
- CLO review
- Verification
- Rejection
- Response workflow

### Analytics

Handles:

- Incidents
- Patrol information
- Conservation reports
- Trends
- Hotspots
- Coverage analysis

---

# 🔄 Core Data Relationships

At a high level, the system connects the major entities like this:

```text
Park
 ├── Patrol Routes
 │      └── Patrol
 │             ├── Waypoints
 │             └── Incidents
 │                    └── Photos
 │
 ├── High-Risk Zones
 │
 └── Wildlife
        └── GPS Collar
               └── Telemetry
                      ↓
                    Alert
                      ↓
                   Ranger
```

Community reporting is connected through:

```text
Villager
   ↓
Community Report
   ↓
Validation
   ↓
Classification
   ↓
Threat Assessment
   ↓
CLO Review
   ↓
Response / Rejection
```

---

# 🧠 Threat Assessment

The system uses incident information and contextual information to determine an appropriate threat level.

Threat assessment can consider factors such as:

- Incident type
- Location
- Wildlife information
- Potential danger
- Proximity to communities
- Reported circumstances

The resulting threat level can influence whether an incident requires immediate response or monitoring.

---

# 🚨 Alert & Dispatch Lifecycle

For alerts requiring ranger intervention, the system follows a controlled response lifecycle.

```text
ALERT GENERATED
       ↓
NOTIFIED
       ↓
ACKNOWLEDGED
       ↓
DISPATCHED
       ↓
ON SCENE
       ↓
RESOLVED
```

Where appropriate, the system can also handle exceptional outcomes such as:

- Unable to respond
- No ranger available
- Notification failure
- Communication failure
- False alarm


---

# 🔐 Security & Reliability

The system is designed with reliability and controlled access in mind.

Important engineering considerations include:

- Authentication
- Role-based authorization
- Input validation
- Error handling
- Data persistence
- Offline data handling
- Synchronization
- Duplicate detection
- State management
- Controlled status transitions

Sensitive configuration values such as:

```text
DATABASE_URL
JWT_SECRET
API_KEYS
PASSWORDS
```

should be stored through environment configuration and **must not be committed to the repository**.

---

# 🧪 Testing

Testing is used to validate the system's business rules and critical functionality.

The project includes testing across important backend and frontend areas where implemented.

### Backend testing

The backend testing setup includes:

- JUnit 5
- Mockito
- AssertJ
- Maven
- JaCoCo

Testing areas include business logic such as:

- Report processing
- Validation
- Threat assessment
- Geofence calculations
- Dispatch coordination
- Alert lifecycle
- Synchronization
- Persistence-related behavior

### Frontend testing

Where implemented, the mobile application testing uses Flutter's testing tools and covers areas such as:

- Domain models
- JSON serialization
- Local storage behavior
- Synchronization
- Widget behavior
- Form validation
- UI interaction

The final project documentation records successful automated test execution for several system components. For example, the UC02 test execution includes tests for geofence processing, threat assessment, dispatch coordination, alert management, telemetry ingestion, re-entry evaluation, and synchronization.

---

# 📈 Code Quality

The project aims to follow maintainable software engineering practices rather than placing all functionality into a single layer.

Key practices include:

- Separation of concerns
- Single Responsibility Principle
- Dependency management
- Service-layer business logic
- Repository-based persistence
- Reusable components
- Meaningful naming
- Input validation
- Exception handling
- Unit testing
- Avoidance of unnecessary duplication
- Maintainable UI components

The project design also considers SOLID principles where appropriate.

For example, business rules should remain in service/domain layers rather than being embedded directly inside UI components.

---

# 📂 Project Structure

The exact structure may vary according to the current repository, but the project is organized around frontend/mobile and backend components.

A typical structure is:

```text
WildGuard/
│
├── wildguard-backend/
│   ├── src/
│   │   ├── main/
│   │   │   └── java/
│   │   └── test/
│   │
│   ├── pom.xml
│   └── ...
│
├── wildguard-frontend/
│   ├── lib/
│   │   ├── features/
│   │   ├── models/
│   │   ├── services/
│   │   ├── providers/
│   │   └── ...
│   │
│   ├── test/
│   └── pubspec.yaml
│
└── README.md
```



---

# 🚀 Getting Started

## Prerequisites

Install the tools required by the current project:

- Git
- Java / JDK version required by the backend
- Maven or Maven Wrapper
- Flutter SDK if using the mobile application
- Android SDK / supported mobile development environment
- Database required by the backend
- IDE such as IntelliJ IDEA or VS Code

---

## 1. Clone the Repository

```bash
git clone <YOUR-REPOSITORY-URL>
```

```bash
cd <REPOSITORY-FOLDER>
```

---

# ⚙️ Backend Setup

Navigate to the backend:

```bash
cd wildguard-backend
```

Install/build dependencies:

```bash
./mvnw clean install
```

On Windows, use:

```powershell
.\mvnw.cmd clean install
```

Configure the required environment/application properties before starting the server.

Run the backend:

```bash
./mvnw spring-boot:run
```

On Windows:

```powershell
.\mvnw.cmd spring-boot:run
```

The actual server port and database configuration should be taken from the repository configuration.

---

# 📱 Mobile Application Setup

If the repository contains the Flutter mobile application:

```bash
cd <FLUTTER-PROJECT>
```

Get dependencies:

```bash
flutter pub get
```

Check the Flutter environment:

```bash
flutter doctor
```

Run the application:

```bash
flutter run
```

For a connected Android device:

```bash
flutter devices
```

Then select the appropriate device and run the application.

---

# 🧪 Running Tests

## Backend

Run all backend tests:

```bash
./mvnw test
```

Windows:

```powershell
.\mvnw.cmd test
```

Run a specific test class:

```bash
./mvnw test -Dtest=CommunityReportRulesTest
```

Generate the JaCoCo coverage report if configured:

```bash
./mvnw test jacoco:report
```

The generated report can normally be found under:

```text
target/site/jacoco/index.html
```

---

## Flutter

Run Flutter tests:

```bash
flutter test
```

Run a specific feature's tests:

```bash
flutter test test/features/
```

Use the actual test directories available in the repository.

---

# 🏛️ System Workflow

The complete system connects the four major workflows:

```text
                    ┌───────────────────┐
                    │  Community Users  │
                    └─────────┬─────────┘
                              │
                              ↓
                    Community Conflict
                         Reporting
                              │
                              ↓
                    ┌─────────────────┐
                    │       CLO       │
                    │ Review / Triage │
                    └────────┬────────┘
                             │
                   ┌─────────┴─────────┐
                   ↓                   ↓
               Verified             Rejected
                   │                   │
                   ↓                   ↓
             Ranger Response       History
                   │
                   ↓
              Field Ranger
                   │
                   ↓
            Incident Reports
                   │
                   ↓
        ┌─────────────────────┐
        │ Central Data Layer  │
        └──────────┬──────────┘
                   ↑
                   │
          Wildlife Sensors
                   │
                   ↓
            GPS / Telemetry
                   │
                   ↓
              Alert Engine
                   │
                   ↓
            Ranger Response

                   ↓
          ┌─────────────────┐
          │    Analytics    │
          └────────┬────────┘
                   ↓
       Conservation Intelligence
```

---

# 🌍 Real-World Use Cases

WildGuard is designed to support situations such as:

### Human-Wildlife Conflict

A villager reports an elephant entering farmland.

```text
Villager
   ↓
Conflict Report
   ↓
Location + Incident Details
   ↓
Validation
   ↓
Threat Assessment
   ↓
CLO Review
   ↓
Ranger Response
```

### Wildlife Threat Detection

A GPS collar reports that an elephant has entered a predefined high-risk zone.

```text
GPS Collar
   ↓
Telemetry
   ↓
Geofence Check
   ↓
Threat Assessment
   ↓
Alert
   ↓
Nearest Ranger
   ↓
Response
```

### Anti-Poaching Patrol

A ranger discovers an illegal snare while conducting a patrol.

```text
Ranger
   ↓
Active Patrol
   ↓
GPS Location
   ↓
Capture Evidence
   ↓
Log Incident
   ↓
Offline Storage
   ↓
Automatic Synchronization
```

### Conservation Analysis

Management wants to understand where wildlife incidents are concentrated.

```text
Historical Data
      ↓
Analytics
      ↓
Incident Trends
      ↓
Hotspot Identification
      ↓
Patrol Planning
      ↓
Better Resource Allocation
```

---

# 💡 Engineering Highlights

The project focuses not only on implementing screens, but also on solving real operational problems.

### Offline-first field operations

Rangers can continue recording important information in areas with poor connectivity.

### Event-driven alert processing

Sensor telemetry can trigger automated threat evaluation and alerts.

### Geospatial processing

Location information is used for:

- Geofencing
- Ranger proximity
- Incident locations
- Patrol routes
- Hotspot analysis

### Structured report lifecycle

Community reports have a defined processing lifecycle instead of being treated as simple database records.

### Business-rule validation

Important decisions such as report verification, rejection, threat assessment, and dispatch are controlled through application-level business rules.

### Testable architecture

Business logic is separated from UI and persistence responsibilities where appropriate, making important components easier to test.

---

# 🛠️ Technology Stack

The repository should list the technologies actually present in the source code.

The system includes technologies/components around:

### Backend

- Java
- Spring Boot
- Maven
- JUnit 5
- Mockito
- AssertJ
- JaCoCo
- MongoDB

### Mobile / Frontend

- Flutter
- Dart
- Provider architecture
- Local SQLite-based persistence where implemented
- Flutter testing framework
- Mocktail where implemented

### Development & Collaboration

- Git
- GitHub
- Draw.io
- Agile/Scrum workflow

> Keep this section synchronized with the actual `pom.xml`, `pubspec.yaml`, source code, and configuration files in the repository.

---

# 🔌 API & Integration

The backend provides application services for the different system modules.

Major API areas include concepts such as:

```text
Community Reports
Patrols
Incidents
Alerts
Rangers
Animals
Telemetry
Dispatch
Analytics
Synchronization
```


---

# 🧪 Quality Assurance

The project uses automated testing to validate important business behavior.

Testing focuses on:

```text
Unit Tests
    ↓
Business Rules
    ↓
Validation
    ↓
State Transitions
    ↓
Persistence
    ↓
Error Handling
    ↓
Regression Protection
```

For example, the UC03 testing work includes report validation and lifecycle/dispatch rules, with tests executed through Maven and JUnit. The project documentation records successful execution of the focused UC03 suite and broader backend tests.

---

# 📈 Project Status

| Area | Status |
|---|---|
| Field Patrol Management | ✅ Implemented / integrated according to project scope |
| Field Incident Reporting | ✅ Implemented / integrated according to project scope |
| Offline Data Handling | ✅ Implemented / designed as offline-first |
| Sensor Monitoring | ✅ Implemented / integrated according to project scope |
| Geofence Alerts | ✅ Implemented / integrated according to project scope |
| Ranger Notification | ✅ Implemented / integrated according to project scope |
| Community Reporting | ✅ Implemented / integrated according to project scope |
| Report Verification | ✅ Implemented |
| Report Rejection | ✅ Implemented |
| Rejection Reason | ✅ Implemented |
| Ranger Dispatch Prevention for Rejected Reports | ✅ Implemented |
| Conservation Analytics | ✅ Implemented / integrated according to project scope |
| Automated Testing | ✅ Implemented for key components |
| Documentation | ✅ Included |



---

# 🔮 Future Improvements

Potential future improvements include:

- Real-time GIS mapping improvements
- More advanced wildlife behavior prediction
- Machine-learning-based threat prediction
- Image-based wildlife/incident classification
- Improved SMS integration
- Push notification optimization
- More advanced conservation analytics
- Role-specific dashboards
- Expanded offline synchronization
- Improved audit and activity history
- Cloud deployment and monitoring
- Production-grade observability

---

# 🤝 Team

The project was developed collaboratively by four team members.

| Member | Main Area |
|---|---|
| **E.A.D.T.M. Edirisinghe** | UC01 – Field Patrol & Incident Management |
| **Manmith A.G.L** | UC02 – Animal & Sensor Alerts |
| **N.W.D.E Randunu** | UC03 – Community Conflict Reports |
| **Anjana I.M.A.A** | UC04 – Conservation Analytics |

Each member focused on a major functional area while contributing to the overall system design and integration.

---

# 📌 Repository Purpose

This repository contains the implementation of a smart wildlife conservation platform developed as a collaborative software engineering project.

The project demonstrates practical implementation of:

- Full-stack application development
- Mobile application development
- RESTful backend services
- Database persistence
- Offline-first application design
- GPS and geospatial functionality
- Sensor-driven event processing
- Business rule implementation
- Role-based workflows
- Automated testing
- Software architecture
- UI/UX design
- Git-based collaborative development

---

## ⭐ Project Goal

> **Help conservation teams move from reactive wildlife incident management to proactive, connected, and data-driven conservation operations.**

---

## 📄 License

This project is intended for educational and demonstration purposes.
