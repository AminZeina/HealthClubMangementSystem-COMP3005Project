INSERT INTO UserAccount (email, password, first_name, last_name, account_type)
VALUES ('john.doe@email.com', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'John', 'Doe', 'member');

INSERT INTO Member (email, birthdate, height, weight)
VALUES ('john.doe@email.com', '1999-01-01', 180, 60);

INSERT INTO ExerciseRoutine (member_id, start_datetime, end_datetime, name, calories_burned, notes)
VALUES (1, '2023-12-01 08:00', '2023-12-01 09:30', 'friday morning routine', '275', 'hit a new PR');

INSERT INTO UserAccount (email, password, first_name, last_name, account_type)
VALUES ('bob.smith@healthclub.com', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Bob', 'Smith', 'trainer');

INSERT INTO Trainer (trainer_id, email, specialty)
VALUES (1001, 'bob.smith@healthclub.com', 'Injury recovery');

INSERT INTO TrainingSession (trainer_id, member_id, start_datetime, end_datetime)
VALUES (1001, 1, '2023-12-02 17:00', '2023-12-02 18:00');

INSERT INTO Room (room_number, max_capacity)
VALUES (101, 75);

INSERT INTO Equipment (equipment_number, room_number, equipment_type, purchase_date)
VALUES (1, 101, 'treadmill', '2023-01-01');

INSERT INTO Equipment (equipment_number, room_number, equipment_type, purchase_date)
VALUES (97, 101, 'bike', '2023-12-01');

INSERT INTO MaintenanceRecord (equipment_number, maintenance_date, details)
VALUES (1, '2023-07-01', 'Standard maintenance; no issues.');

INSERT INTO Events (room_number, event_type, start_datetime, end_datetime, details)
VALUES (101, 'class', '2023-12-03 9:00', '2023-12-03 10:00', 'cardio class');

INSERT INTO Events (room_number, event_type, start_datetime, end_datetime, details)
VALUES (101, 'class', '2023-12-03 10:00', '2023-12-03 12:00', 'strength training class');

INSERT INTO Events (room_number, event_type, start_datetime, end_datetime, details)
VALUES (101, 'class', '2023-12-10 9:00', '2023-12-03 10:00', 'cardio class');

INSERT INTO EventRegistration (member_id, event_id)
VALUES (1, 1);

/* Get all members and their account information*/
SELECT * 
FROM UserAccount NATURAL JOIN Member; 

/* create a membership renewal transaction for member 1*/
INSERT INTO Transactions (member_id, transaction_type, transaction_date, amount)
VALUES (1, 'membership renewal', '2023-12-01', 50);

SELECT * FROM Transactions;

/* check member 1's loyalty points and membership expiry (should be updated from trigger) */
SELECT member_id, email, membership_expiry, loyalty_points
FROM Member
WHERE member_id=1;

/* create a training session fee transaction for member 1 */
INSERT INTO Transactions (member_id, transaction_type, transaction_date, amount)
VALUES (1, 'training session', '2023-12-15', 35);

SELECT * FROM Transactions;

/* check member 1's loyalty points (should be updated from trigger) */
SELECT member_id, email, membership_expiry, loyalty_points
FROM Member
WHERE member_id=1;

/* update weight of member 1 */
UPDATE Member
SET weight = 62
WHERE member_id = 1;

SELECT * 
FROM Member
WHERE member_id=1;

/* add trainer notes to training session */
UPDATE TrainingSession
SET progress_notes = 'Good session! will try higher weights next session.'
WHERE trainer_id=1001 AND member_id=1 AND start_datetime='2023-12-02 17:00' AND end_datetime='2023-12-02 18:00';

/* get all training sessions for member 1 */
SELECT * FROM TrainingSession
WHERE member_id=1;

/* add goal to member 1 */
INSERT INTO MemberGoals (member_id, goal) 
VALUES (1, 'gain 5 kg this year');

SELECT member_id, email, goal FROM 
Member NATURAL JOIN MemberGoals
WHERE member_id = 1;

/* add achievement to member 1 */
INSERT INTO MemberAchievements (member_id, achievement) 
VALUES (1, 'Work out 3 times a week for 1 year straight');

SELECT member_id, email, achievement FROM 
Member NATURAL JOIN MemberAchievements
WHERE member_id = 1;

/* get all exercise routines for member 1 */
SELECT * FROM ExerciseRoutine
WHERE member_id=1;

/* get all events member 1 is registered in */
SELECT * 
FROM EventRegistration NATURAL JOIN Events
WHERE member_id = 1;


/* get all events in room 101 on 2023-12-03 */
SELECT * FROM Events
WHERE room_number=101 AND start_datetime::date = '2023-12-03';

/* get all equipment and maintance records */
SELECT * 
FROM Equipment NATURAL JOIN MaintenanceRecord;
