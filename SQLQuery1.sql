-- ============================================
-- RACEDAY DATABASE SCHEMA 
-- Programming 2B - PROG6212
-- ============================================

-- Drop tables in correct order (reverse of creation)
IF OBJECT_ID('Results', 'U') IS NOT NULL DROP TABLE Results;
IF OBJECT_ID('Enrolments', 'U') IS NOT NULL DROP TABLE Enrolments;
IF OBJECT_ID('EventCategories', 'U') IS NOT NULL DROP TABLE EventCategories;
IF OBJECT_ID('Events', 'U') IS NOT NULL DROP TABLE Events;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Organisers', 'U') IS NOT NULL DROP TABLE Organisers;
IF OBJECT_ID('Participants', 'U') IS NOT NULL DROP TABLE Participants;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- ============================================
-- CREATE TABLES 
-- ============================================

-- 1. USERS Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. ORGANISERS Table
CREATE TABLE Organisers (
    OrganiserID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    CompanyName NVARCHAR(100),
    ContactPhone NVARCHAR(20),
    CONSTRAINT FK_Organisers_Users FOREIGN KEY (UserID) 
        REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- 3. PARTICIPANTS Table
CREATE TABLE Participants (
    ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    DateOfBirth DATE,
    EmergencyContact NVARCHAR(100),
    EmergencyPhone NVARCHAR(20),
    CONSTRAINT FK_Participants_Users FOREIGN KEY (UserID) 
        REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- 4. CATEGORIES Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(200),
    DistanceKM DECIMAL(5,2) NOT NULL
);
GO

-- 5. EVENTS Table
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    EventDate DATETIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Open' CHECK (Status IN ('Open', 'Closed', 'Cancelled')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organisers FOREIGN KEY (OrganiserID) 
        REFERENCES Organisers(OrganiserID) ON DELETE CASCADE
);
GO

-- 6. EVENTCATEGORIES Table (Junction Table)
CREATE TABLE EventCategories (
    EventCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    MaxParticipants INT,
    CONSTRAINT FK_EventCategories_Events FOREIGN KEY (EventID) 
        REFERENCES Events(EventID) ON DELETE CASCADE,
    CONSTRAINT FK_EventCategories_Categories FOREIGN KEY (CategoryID) 
        REFERENCES Categories(CategoryID) ON DELETE CASCADE,
    CONSTRAINT UQ_EventCategory UNIQUE (EventID, CategoryID)
);
GO

-- 7. ENROLMENTS Table
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventCategoryID INT NOT NULL,
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Withdrawn', 'Completed')),
    CONSTRAINT FK_Enrolments_Participants FOREIGN KEY (ParticipantID) 
        REFERENCES Participants(ParticipantID),
    CONSTRAINT FK_Enrolments_EventCategories FOREIGN KEY (EventCategoryID) 
        REFERENCES EventCategories(EventCategoryID),
    CONSTRAINT UQ_Enrolment UNIQUE (ParticipantID, EventCategoryID)
);
GO

-- 8. RESULTS Table
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    Position INT,
    Status NVARCHAR(20) DEFAULT 'Completed' CHECK (Status IN ('Completed', 'Disqualified', 'DidNotFinish')),
    RecordedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID) 
        REFERENCES Enrolments(EnrolmentID)
);
GO

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- 1. Insert Users
INSERT INTO Users (Email, PasswordHash, FullName, Role) VALUES
('john.organiser@raceday.com', 'hashed_password_123', 'John Smith', 'Organiser'),
('sarah.organiser@raceday.com', 'hashed_password_456', 'Sarah Johnson', 'Organiser'),
('mike.runner@email.com', 'hashed_password_789', 'Michael Brown', 'Participant'),
('emily.athlete@email.com', 'hashed_password_abc', 'Emily Davis', 'Participant');
GO

-- 2. Insert Organisers
INSERT INTO Organisers (UserID, CompanyName, ContactPhone) VALUES
(1, 'City Runners Events', '+27 82 123 4567'),
(2, 'Trail Blazers SA', '+27 83 765 4321');
GO

-- 3. Insert Participants
INSERT INTO Participants (UserID, DateOfBirth, EmergencyContact, EmergencyPhone) VALUES
(3, '1990-05-15', 'Jane Brown', '+27 82 111 2222'),
(4, '1988-11-22', 'Robert Davis', '+27 83 333 4444');
GO

-- 4. Insert Categories
INSERT INTO Categories (CategoryName, Description, DistanceKM) VALUES
('5km Fun Run', 'Family-friendly 5km run', 5.00),
('10km Challenge', 'Intermediate 10km race', 10.00),
('21km Half-Marathon', 'Competitive half-marathon', 21.10),
('42km Marathon', 'Full marathon for experienced runners', 42.20);
GO

-- 5. Insert Events
INSERT INTO Events (OrganiserID, EventName, Description, EventDate, Location, Status) VALUES
(1, 'City Park Run 2026', 'Annual city park running event', '2026-03-15 07:00:00', 'Central Park, Cape Town', 'Open'),
(1, 'Sunset Beach Run', 'Evening run along the coast', '2026-04-20 17:00:00', 'Clifton Beach, Cape Town', 'Open'),
(2, 'Table Mountain Trail', 'Challenging trail run', '2026-05-10 06:00:00', 'Table Mountain, Cape Town', 'Open');
GO

-- 6. Insert EventCategories
INSERT INTO EventCategories (EventID, CategoryID, Price, MaxParticipants) VALUES
(1, 1, 150.00, 200),
(1, 2, 250.00, 150),
(1, 3, 350.00, 100),
(2, 1, 200.00, 100),
(2, 2, 300.00, 80),
(3, 2, 400.00, 50),
(3, 3, 550.00, 30),
(3, 4, 700.00, 20);
GO

-- 7. Insert Enrolments
INSERT INTO Enrolments (ParticipantID, EventCategoryID, Status) VALUES
(1, 1, 'Confirmed'),
(1, 5, 'Pending'),
(2, 2, 'Confirmed'),
(2, 8, 'Pending');
GO

-- 8. Insert Results
INSERT INTO Results (EnrolmentID, FinishTime, Position, Status) VALUES
(1, '00:22:34', 5, 'Completed'),
(3, '00:48:12', 8, 'Completed');
GO

-- ============================================
-- VERIFY DATA
-- ============================================

SELECT '=== USERS ===' AS 'Info';
SELECT * FROM Users;

SELECT '=== ORGANISERS ===' AS 'Info';
SELECT * FROM Organisers;

SELECT '=== PARTICIPANTS ===' AS 'Info';
SELECT * FROM Participants;

SELECT '=== CATEGORIES ===' AS 'Info';
SELECT * FROM Categories;

SELECT '=== EVENTS ===' AS 'Info';
SELECT * FROM Events;

SELECT '=== EVENTCATEGORIES ===' AS 'Info';
SELECT * FROM EventCategories;

SELECT '=== ENROLMENTS ===' AS 'Info';
SELECT * FROM Enrolments;

SELECT '=== RESULTS ===' AS 'Info';
SELECT * FROM Results;
GO

-- View enrolments with details
SELECT 
    e.EnrolmentID,
    u.FullName AS Participant,
    ev.EventName,
    c.CategoryName,
    c.DistanceKM,
    ec.Price,
    e.Status AS EnrolmentStatus
FROM Enrolments e
JOIN Participants p ON e.ParticipantID = p.ParticipantID
JOIN Users u ON p.UserID = u.UserID
JOIN EventCategories ec ON e.EventCategoryID = ec.EventCategoryID
JOIN Events ev ON ec.EventID = ev.EventID
JOIN Categories c ON ec.CategoryID = c.CategoryID
ORDER BY e.EnrolmentDate DESC;
GO

-- View results with details
SELECT 
    r.ResultID,
    u.FullName AS Participant,
    ev.EventName,
    c.CategoryName,
    r.FinishTime,
    r.Position,
    r.Status AS ResultStatus
FROM Results r
JOIN Enrolments e ON r.EnrolmentID = e.EnrolmentID
JOIN Participants p ON e.ParticipantID = p.ParticipantID
JOIN Users u ON p.UserID = u.UserID
JOIN EventCategories ec ON e.EventCategoryID = ec.EventCategoryID
JOIN Events ev ON ec.EventID = ev.EventID
JOIN Categories c ON ec.CategoryID = c.CategoryID
ORDER BY ev.EventName, r.Position;
GO