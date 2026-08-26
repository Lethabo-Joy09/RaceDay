# RaceDay API Endpoint Plan

## Authentication Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| POST | `/api/auth/register` | Register a new user account | None/Public | `{ "email": "string", "password": "string", "fullName": "string", "role": "string", "companyName?": "string", "contactPhone?": "string", "dateOfBirth?": "date", "emergencyContact?": "string", "emergencyPhone?": "string" }` | 201 Created - User details with token<br>400 Bad Request - Validation errors<br>409 Conflict - Email already exists |
| POST | `/api/auth/login` | Authenticate user and return JWT token | None/Public | `{ "email": "string", "password": "string" }` | 200 OK - Token and user details<br>401 Unauthorized - Invalid credentials |

## User Profile Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/users/profile` | Get current user profile | Any logged-in user | None | 200 OK - User profile details<br>401 Unauthorized - Not authenticated |
| PUT | `/api/users/profile` | Update current user profile | Any logged-in user | `{ "fullName": "string", "email": "string", "password?": "string" }` | 200 OK - Updated user details<br>400 Bad Request - Validation errors<br>409 Conflict - Email already exists |

## Event Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/events` | Get all events with optional filters | Any logged-in user | None (query params: status, date) | 200 OK - List of events<br>401 Unauthorized - Not authenticated |
| GET | `/api/events/{eventId}` | Get specific event details | Any logged-in user | None | 200 OK - Event details with categories<br>404 Not Found - Event not found |
| POST | `/api/events` | Create a new event | Organiser | `{ "eventName": "string", "description": "string", "eventDate": "datetime", "location": "string", "status": "string", "categories": [ { "categoryId": int, "price": decimal, "maxParticipants": int } ] }` | 201 Created - New event details<br>400 Bad Request - Validation errors<br>403 Forbidden - Not an organiser |
| PUT | `/api/events/{eventId}` | Update an existing event | Organiser | `{ "eventName": "string", "description": "string", "eventDate": "datetime", "location": "string", "status": "string" }` | 200 OK - Updated event details<br>403 Forbidden - Not the event organiser<br>404 Not Found - Event not found |
| DELETE | `/api/events/{eventId}` | Delete an event | Organiser | None | 204 No Content - Successfully deleted<br>403 Forbidden - Not the event organiser<br>404 Not Found - Event not found |

## Category Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/categories` | Get all categories | Any logged-in user | None | 200 OK - List of categories<br>401 Unauthorized - Not authenticated |
| POST | `/api/categories` | Create a new category | Organiser | `{ "categoryName": "string", "description": "string", "distanceKM": decimal }` | 201 Created - New category details<br>400 Bad Request - Validation errors<br>409 Conflict - Category already exists |
| PUT | `/api/categories/{categoryId}` | Update an existing category | Organiser | `{ "categoryName": "string", "description": "string", "distanceKM": decimal }` | 200 OK - Updated category details<br>404 Not Found - Category not found |
| DELETE | `/api/categories/{categoryId}` | Delete a category | Organiser | None | 204 No Content - Successfully deleted<br>404 Not Found - Category not found |

## Event Categories Management Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/events/{eventId}/categories` | Get all categories for a specific event | Any logged-in user | None | 200 OK - List of event categories<br>404 Not Found - Event not found |
| POST | `/api/events/{eventId}/categories` | Add a category to an event | Organiser | `{ "categoryId": int, "price": decimal, "maxParticipants": int }` | 201 Created - Event category details<br>400 Bad Request - Validation errors<br>403 Forbidden - Not the event organiser<br>404 Not Found - Event or category not found<br>409 Conflict - Category already added |
| PUT | `/api/events/{eventId}/categories/{eventCategoryId}` | Update event category details | Organiser | `{ "price": decimal, "maxParticipants": int }` | 200 OK - Updated event category details<br>403 Forbidden - Not the event organiser<br>404 Not Found - Event category not found |
| DELETE | `/api/events/{eventId}/categories/{eventCategoryId}` | Remove a category from an event | Organiser | None | 204 No Content - Successfully removed<br>403 Forbidden - Not the event organiser<br>404 Not Found - Event category not found |

## Enrolment Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/enrolments` | Get all enrolments (organiser view) | Organiser | None (query params: eventId, status) | 200 OK - List of enrolments with details<br>403 Forbidden - Not an organiser |
| GET | `/api/enrolments/my` | Get current user's enrolments | Participant | None | 200 OK - List of user's enrolments<br>401 Unauthorized - Not authenticated<br>403 Forbidden - Not a participant |
| GET | `/api/enrolments/{enrolmentId}` | Get specific enrolment details | Any logged-in user | None | 200 OK - Enrolment details<br>403 Forbidden - Not the participant or organiser<br>404 Not Found - Enrolment not found |
| POST | `/api/enrolments` | Create a new enrolment | Participant | `{ "eventCategoryId": int }` | 201 Created - Enrolment details<br>400 Bad Request - Validation errors<br>403 Forbidden - Not a participant<br>404 Not Found - Event category not found<br>409 Conflict - Already enrolled |
| PUT | `/api/enrolments/{enrolmentId}` | Update enrolment status | Organiser | `{ "status": "Pending/Confirmed/Withdrawn/Completed" }` | 200 OK - Updated enrolment details<br>400 Bad Request - Validation errors<br>403 Forbidden - Not an organiser<br>404 Not Found - Enrolment not found |
| DELETE | `/api/enrolments/{enrolmentId}` | Withdraw an enrolment | Participant/Organiser | None | 204 No Content - Successfully withdrawn<br>403 Forbidden - Not the participant or organiser<br>404 Not Found - Enrolment not found |

## Results Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/events/{eventId}/results` | Get results for a specific event | Any logged-in user | None | 200 OK - List of results with participant details<br>404 Not Found - Event not found |
| GET | `/api/results/my` | Get current user's results | Participant | None | 200 OK - List of user's results<br>401 Unauthorized - Not authenticated<br>403 Forbidden - Not a participant |
| GET | `/api/enrolments/{enrolmentId}/result` | Get result for a specific enrolment | Any logged-in user | None | 200 OK - Result details<br>403 Forbidden - Not the participant or organiser<br>404 Not Found - Enrolment or result not found |
| POST | `/api/enrolments/{enrolmentId}/result` | Capture or update result for an enrolment | Organiser | `{ "finishTime": "time", "position": int, "status": "Completed/Disqualified/DidNotFinish" }` | 201 Created - Result details<br>400 Bad Request - Validation errors<br>403 Forbidden - Not an organiser<br>404 Not Found - Enrolment not found |
| PUT | `/api/results/{resultId}` | Update an existing result | Organiser | `{ "finishTime": "time", "position": int, "status": "Completed/Disqualified/DidNotFinish" }` | 200 OK - Updated result details<br>400 Bad Request - Validation errors<br>403 Forbidden - Not an organiser<br>404 Not Found - Result not found |

## Additional System Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/events/{eventId}/enrolments` | Get all enrolments for a specific event | Organiser | None | 200 OK - List of enrolments with participant details<br>403 Forbidden - Not an organiser<br>404 Not Found - Event not found |
| GET | `/api/events/{eventId}/summary` | Get event summary with statistics | Any logged-in user | None | 200 OK - Event summary with participant count, category breakdown<br>404 Not Found - Event not found |
| GET | `/api/dashboard/organiser` | Get organiser dashboard data | Organiser | None | 200 OK - Dashboard statistics (events, enrolments, participants)<br>403 Forbidden - Not an organiser |
| GET | `/api/dashboard/participant` | Get participant dashboard data | Participant | None | 200 OK - Dashboard statistics (upcoming events, past enrolments, results)<br>403 Forbidden - Not a participant |
