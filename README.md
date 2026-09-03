# RaceDay API - Programming 2B (PROG6212)

## System Description

The RaceDay system is a comprehensive race event management platform designed to connect event organisers with participants. The system allows organisers to create and manage running events, define event categories with different distances and prices, manage participant enrolments, and capture race results. Participants can browse upcoming events, enrol in events of their choice, and track their personal race results

## User Roles

### Organiser
Organisers are event creators and managers who can:
- Create, edit, and delete events
- Manage event categories and pricing
- View all event enrolments
- Capture and manage participant results
- Monitor event statistics and participant counts

### Participant
Participants are race entrants who can:
- Create an account and manage their profile
- Browse and search for upcoming events
- Enrol in events by selecting a category
- View their own enrolment history
- Track their personal race results
- View their race positions and times

## Database Design

The database consists of 8 interconnected tables:

| Table | Description |
|-------|-------------|
| Users | Stores user credentials and role information |
| Organisers | Organiser-specific details linked to Users |
| Participants | Participant-specific details linked to Users |
| Categories | Race categories with distance information |
| Events | Event details created by organisers |
| EventCategories | Junction table linking events to categories with pricing |
| Enrolments | Participant enrolments in specific event categories |
| Results | Race results linked to enrolments |


### Relationships Summary

| From Table | To Table | Cardinality | Type |
|------------|----------|-------------|------|
| Users | Organisers | 1 → 0..1 | One-to-One |
| Users | Participants | 1 → 0..1 | One-to-One |
| Organisers | Events | 1 → 1..* | One-to-Many |
| Events | EventCategories | 1 → 1..* | One-to-Many |
| Categories | EventCategories | 1 → 1..* | One-to-Many |
| Participants | Enrolments | 1 → 1..* | One-to-Many |
| EventCategories | Enrolments | 1 → 1..* | One-to-Many |
| Enrolments | Results | 1 → 0..1 | One-to-One |

## API Endpoints

The API provides RESTful endpoints for all system functionality. Below is a summary of the available endpoints:

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login and receive JWT token

### Users
- `GET /api/users/profile` - Get current user profile
- `PUT /api/users/profile` - Update user profile

### Events
- `GET /api/events` - Get all events
- `GET /api/events/{id}` - Get specific event
- `POST /api/events` - Create event (Organiser only)
- `PUT /api/events/{id}` - Update event (Organiser only)
- `DELETE /api/events/{id}` - Delete event (Organiser only)

### Categories
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create category (Organiser only)
- `PUT /api/categories/{id}` - Update category (Organiser only)
- `DELETE /api/categories/{id}` - Delete category (Organiser only)

### Enrolments
- `GET /api/enrolments` - Get all enrolments (Organiser only)
- `GET /api/enrolments/my` - Get my enrolments (Participant only)
- `POST /api/enrolments` - Create enrolment (Participant only)
- `PUT /api/enrolments/{id}` - Update enrolment (Organiser only)
- `DELETE /api/enrolments/{id}` - Withdraw enrolment

### Results
- `GET /api/events/{id}/results` - Get event results
- `GET /api/results/my` - Get my results (Participant only)
- `POST /api/enrolments/{id}/result` - Add result (Organiser only)
- `PUT /api/results/{id}` - Update result (Organiser only)

For complete endpoint details including request bodies and responses, see the [API Endpoint Plan](docs/API-ENDPOINT-PLAN.md).

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration. The workflow validates:

- Repository structure
- Presence of all required documents in the /docs folder
- Minimum of 20 meaningful commits
- All planning documents are complete


## Video Walkthrough

[Watch the Part 1 Walkthrough Video] - https://youtu.be/DW-S8ZoYOZU

The video covers:
- ERD design decisions and relationships
- API endpoint planning and choices
- SQL database script demonstration in SSMS
- Database structure and sample data explanation

## Repository Structure
RaceDayApi/
├── docs/
│   ├── ERD.png                    # Entity Relationship Diagram
│   ├── API-ENDPOINT-PLAN.md       # Complete API endpoint specifications
│   └── RaceDayDB-Schema.sql       # SQL database script with sample data
├── .github/
│   └── workflows/
│       └── ci.yml                 # GitHub Actions CI/CD workflow
├── README.md                      # Project documentation
└── build-success.png              # CI/CD build success screenshot



