--Q1
CREATE VIEW Pilots AS
SELECT *
FROM employees
WHERE empid IN (SELECT DISTINCT(empid) FROM certified)

CREATE VIEW NotPilots AS
SELECT *
FROM employees
WHERE empid NOT IN (SELECT DISTINCT(empid) FROM certified)

SELECT SUM(salary)
FROM Pilots

SELECT SUM(salary)
FROM NotPilots

SELECT *
FROM NotPilots
WHERE salary > (SELECT AVG(salary) FROM Pilots)

--Q2
CREATE VIEW AircraftFlightsInfo AS
SELECT aname, fno, fromCity, toCity
FROM flights
CROSS JOIN aircrafts
WHERE crange >= distance

SELECT aname, COUNT(fno) AS NrOfFlights
FROM AircraftFlightsInfo
GROUP BY aname

--Q3
CREATE PROCEDURE Price_Check
	@fno VARCHAR(4),
	@cost VARCHAR(100) OUT
	AS
	DECLARE @price INT
	SET @price = 0
	SELECT @price = price FROM flights WHERE fno = @fno
	BEGIN
		IF (@price = 0)
			SELECT @cost = 'Incorrect flight number'
		ELSE
			IF (@price <= 500)
				SELECT @cost = 'Η πτήση ' + @fno + ' είναι φθηνή.'
			ELSE 
				IF(@price <= 1000)
					SELECT @cost = 'Η πτήση ' + @fno + ' είναι κανονικού κόστους.'
				ELSE
					SELECT @cost = 'Η πτήση ' + @fno + ' είναι ακριβή.'

	SELECT @cost
	END

--Q4
CREATE PROCEDURE Pilot_Certification
	@empid INT,
	@firstname VARCHAR(30),
	@lastname VARCHAR(30),
	@aname VARCHAR (50),
	@message VARCHAR(100) OUT
	AS
	DECLARE @aid VARCHAR(4)
	SELECT @aid = aid FROM aircrafts WHERE @aname = aname
	DECLARE @firstLetter CHAR(1)
	SELECT @firstLetter = LEFT(@aname, 1)
	BEGIN
		IF ((SELECT COUNT(*) FROM employees WHERE empid = @empid) > 0)
			BEGIN
				IF ((SELECT COUNT(*) FROM aircrafts WHERE aname = @aname) > 0) 
					BEGIN
						IF ((SELECT COUNT(*) FROM certified WHERE empid = @empid) > 0)
							SELECT @message = @firstname + ' ' + @lastname + ' is already certified for aircraft: '
						ELSE
							INSERT INTO certified VALUES (@empid,@aid)
							SELECT @message = 'Values inserted'
					END
				ELSE
					SELECT @aid = @firstLetter + RIGHT('000' + CAST((SELECT COUNT(*) FROM aircrafts WHERE  aname LIKE @firstLetter + '%') + 1 AS VARCHAR(3)), 3)
					INSERT INTO aircrafts VALUES (@aid, @aname, 0)
					INSERT INTO certified VALUES (@empid, @aid)
					SELECT @message = 'Values inserted'
			END
		ELSE
			IF ((SELECT COUNT(*) FROM aircrafts WHERE aname = @aname) > 0)
				BEGIN
					INSERT INTO employees VALUES (@empid, @lastname, @firstname, 0)
					INSERT INTO certified VALUES (@empid, @aid)
					SELECT @message = 'Values inserted'
				END
			ELSE
				INSERT INTO employees VALUES (@empid, @lastname, @firstname, 0)
				SELECT @aid = @firstLetter + RIGHT('000' + CAST((SELECT COUNT(*) FROM aircrafts WHERE  aname LIKE @firstLetter + '%') + 1 AS VARCHAR(3)), 3)
				INSERT INTO aircrafts VALUES (@aid, @aname, 0)
				INSERT INTO certified VALUES (@empid, @aid)
				SELECT @message = 'Values inserted'
		SELECT @message
	END
	

--Q5
CREATE TRIGGER PilotNewCertification ON certified
AFTER INSERT AS
BEGIN
	IF ((SELECT COUNT(*) FROM certified WHERE empid IN (SELECT empid FROM inserted)) = 3)
		UPDATE employees SET salary = 1.1 * salary WHERE empid IN (SELECT empid FROM insterted)
END

--Q6
CREATE TRIGGER FlightPriceChange ON flight_history
AFTER UPDATE AS
BEGIN
	DECLARE @fno VARCHAR(4), @priceBefore INT, @priceAfter INT, @userName VARCHAR(50)
	SET @fno = (SELECT fno FROM inserted) --Αυτό θα λειτουργεί επειδή θα υπάρχει πυροδότηση σε κάθε μια αλλαγή ή θα μπορούν να γίνονται και πολλές;
	SET @priceBefore = (SELECT price FROM deleted) 
	SET @priceAfter = (SELECT price FROM inserted)
	SET @userName = USER_NAME()
	INSERT INTO flight_history (fno, username, flight_date, price_before, price_after) VALUES (@fno, @userName, GETDATE(), @priceBefore, @priceAfter)
END	