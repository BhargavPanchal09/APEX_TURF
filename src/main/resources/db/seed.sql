USE apex_turf;

INSERT INTO sports (name, active) SELECT 'Football', 1
WHERE NOT EXISTS (SELECT 1 FROM sports WHERE name = 'Football');
INSERT INTO sports (name, active) SELECT 'Cricket', 1
WHERE NOT EXISTS (SELECT 1 FROM sports WHERE name = 'Cricket');
INSERT INTO sports (name, active) SELECT 'Badminton', 1
WHERE NOT EXISTS (SELECT 1 FROM sports WHERE name = 'Badminton');
UPDATE sports SET active = 1 WHERE name IN ('Football', 'Cricket', 'Badminton');

INSERT INTO turfs (name, location, active, hourly_rate)
SELECT 'Apex Arena', 'Ahmedabad, Gujarat', 1, 1500.00
WHERE NOT EXISTS (SELECT 1 FROM turfs WHERE name = 'Apex Arena');

INSERT INTO turfs (name, location, active, hourly_rate)
SELECT 'Greenfield Sports Hub', 'Gandhinagar, Gujarat', 1, 1200.00
WHERE NOT EXISTS (SELECT 1 FROM turfs WHERE name = 'Greenfield Sports Hub');

UPDATE turfs SET hourly_rate = 1500.00 WHERE name = 'Apex Arena' AND hourly_rate = 0.00;
UPDATE turfs SET hourly_rate = 1200.00 WHERE name = 'Greenfield Sports Hub' AND hourly_rate = 0.00;

INSERT IGNORE INTO turf_sports (turf_id, sport_id)
SELECT t.id, s.id FROM turfs t JOIN sports s
WHERE (t.name = 'Apex Arena' AND s.name IN ('Football', 'Cricket'))
   OR (t.name = 'Greenfield Sports Hub' AND s.name IN ('Football', 'Badminton'));
