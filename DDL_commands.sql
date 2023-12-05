CREATE TABLE IF NOT EXISTS UserAccount (
    email VARCHAR(320) PRIMARY KEY,
    password CHAR(64) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    account_type VARCHAR(64) NOT NULL
    CONSTRAINT check_type CHECK (account_type IN ('member', 'trainer', 'staff'))
);

CREATE TABLE IF NOT EXISTS Staff (
    staff_id SMALLINT PRIMARY KEY,
    email VARCHAR(320) REFERENCES UserAccount(email),
    start_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS Trainer (
    trainer_id INT PRIMARY KEY,
    email VARCHAR(320) REFERENCES UserAccount(email),
    specialty TEXT
);

CREATE TABLE IF NOT EXISTS Member (
    member_id SERIAL PRIMARY KEY,
    email VARCHAR(320) REFERENCES UserAccount(email),
    birthdate DATE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE,
    membership_expiry DATE,
    loyalty_points INT DEFAULT 0,
    height SMALLINT,
    weight NUMERIC(4,1)
);

CREATE TABLE IF NOT EXISTS MemberGoals (
    member_id INT REFERENCES Member(member_id),
    goal TEXT UNIQUE NOT NULL,
    PRIMARY KEY (member_id, goal)
);

CREATE TABLE IF NOT EXISTS MemberAchievements (
    member_id INT REFERENCES Member(member_id),
    achievement TEXT NOT NULL,
    PRIMARY KEY (member_id, achievement)
);

CREATE TABLE IF NOT EXISTS ExerciseRoutine (
    member_id INT REFERENCES Member(member_id),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    name VARCHAR(255) NOT NULL,
    calories_burned SMALLINT,
    notes TEXT,
    PRIMARY KEY (member_id, start_datetime, end_datetime)
);

CREATE TABLE IF NOT EXISTS TrainingSession (
    trainer_id INT REFERENCES Trainer(trainer_id),
    member_id INT REFERENCES Member(member_id),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    progress_notes TEXT,
    PRIMARY KEY (trainer_id, member_id)
);

CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id SERIAL PRIMARY KEY,
    member_id INT REFERENCES Member(member_id),
    transaction_type VARCHAR(64),
    transaction_date DATE DEFAULT CURRENT_DATE,
    amount NUMERIC(6,2) NOT NULL,
    CONSTRAINT check_type CHECK (transaction_type IN ('membership renewal','training session','event fee','misc. fees'))
);


CREATE TABLE IF NOT EXISTS Room (
    room_number INT PRIMARY KEY,
    max_capacity SMALLINT
);

CREATE TABLE IF NOT EXISTS Events (
    event_id SERIAL PRIMARY KEY,
    room_number INT REFERENCES Room(room_number),
    event_type VARCHAR(64),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    details TEXT NOT NULL,
    CONSTRAINT check_type CHECK (event_type IN ('class', 'workshop', 'misc. event'))
);

CREATE TABLE IF NOT EXISTS EventRegistration (
    member_id INT REFERENCES Member(member_id),
    event_id INT REFERENCES Events(event_id),
    PRIMARY KEY (member_id, event_id)
);


CREATE TABLE IF NOT EXISTS Equipment (
    equipment_number INT PRIMARY KEY,
    room_number INT REFERENCES Room(room_number),
    equipment_type VARCHAR(255),
    purchase_date DATE
);

CREATE TABLE IF NOT EXISTS MaintenanceRecord (
    equipment_number INT REFERENCES Equipment(equipment_number),
    maintenance_date DATE NOT NULL,
    details TEXT,
    PRIMARY KEY (equipment_number, maintenance_date)
);