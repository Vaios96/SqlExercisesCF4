--Q1
SELECT *
FROM flights
WHERE toCity = 'Τορόντο' AND depDate = '2018-05-01';

--Q2
SELECT *
FROM flights
WHERE distance BETWEEN 900 AND 1500
ORDER BY distance;

--Q3
SELECT toCity, COUNT(fno) AS Nr_Of_Flights
FROM flights
WHERE depDate BETWEEN '2018-05-01' AND '2018-05-30'
GROUP BY toCity;

--Q4
SELECT toCity, COUNT(fno) AS Nr_Of_Flights
FROM flights
GROUP BY toCity
HAVING COUNT(fno) >= 3;

--Q5
SELECT lastname, firstname
FROM employees
WHERE empid IN
(SELECT empid
FROM certified
GROUP BY empid
HAVING COUNT(aid) >=3);

--Q6
SELECT SUM(salary) FROM employees;

--Q7
SELECT SUM(salary)
FROM employees
WHERE empid IN (SELECT DISTINCT(empid) FROM certified);

--Q8
SELECT SUM(salary)
FROM employees
WHERE empid NOT IN (SELECT DISTINCT(empid) FROM certified);

--Q9
SELECT aname
FROM aircrafts
WHERE crange >= (SELECT AVG(distance)
FROM flights
WHERE ((fromCity = 'Αθήνα' AND toCity
= 'Μελβούρνη') OR (fromCity = 'Μελβούρνη' AND toCity = 'Αθήνα'))
);

--Q10
SELECT DISTINCT(employees.empid), firstname, lastname
FROM employees INNER JOIN certified ON employees.empid = certified.empid
INNER JOIN aircrafts ON aircrafts.aid =
certified.aid
WHERE aircrafts.aname LIKE 'Boeing%';

--Q11
SELECT DISTINCT(employees.empid), firstname, lastname
FROM employees INNER JOIN certified ON employees.empid = certified.empid
INNER JOIN aircrafts ON aircrafts.aid = certified.aid
WHERE ((aircrafts.crange >= 3000) AND employees.empid NOT IN (SELECT DISTINCT(employees.empid)
FROM employees INNER JOIN certified ON employees.empid = certified.empid
INNER JOIN aircrafts ON aircrafts.aid = certified.aid
WHERE aircrafts.aname LIKE 'Boeing%'));

--Q12
SELECT firstname, lastname
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

--Q13
SELECT firstname, lastname
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees
WHERE salary <
(SELECT MAX(salary) FROM employees));

--Q14
SELECT aname
FROM aircrafts
WHERE aid IN (SELECT aid
FROM certified
INNER JOIN employees ON certified.empid = employees.empid
WHERE employees.salary >= 6000)
AND aid NOT IN (SELECT aid
FROM certified
INNER JOIN employees ON certified.empid = employees.empid
WHERE employees.salary < 6000);

--Q15
SELECT certified.empid, MAX(aircrafts.crange) AS max_crange
FROM certified
INNER JOIN aircrafts ON certified.aid = aircrafts.aid
GROUP BY certified.empid;

--Q16
SELECT firstname, lastname
FROM employees
WHERE salary < (SELECT MIN(price)
FROM flights
WHERE toCity = 'Μελβούρνη');

--Q17
SELECT firstname, lastname, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
FROM employees
INNER JOIN certified ON employees.empid = certified.empid)
AND
empid NOT IN (SELECT DISTINCT(empid) FROM certified);