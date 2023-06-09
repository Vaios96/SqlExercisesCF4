--Q1
SELECT lname, fname 
FROM actors
WHERE lname LIKE ('Κ%')
ORDER BY lname

--Q2
SELECT title, pyear
FROM movies
WHERE pyear BETWEEN 1990 AND 2007
ORDER BY pyear DESC

--Q3
SELECT title, lname, fname
FROM movies INNER JOIN directors ON movies.did = directors.did
WHERE pcountry = 'GRC'
ORDER BY lname

--Q4
SELECT title, pyear
FROM movies INNER JOIN directors ON movies.did = directors.did
WHERE lname = 'Σακελλάριος'

--Q5
SELECT title, pyear
FROM movies INNER JOIN movie_actor ON movies.mid = movie_actor.mid
		    INNER JOIN actors ON movie_actor.actid = actors.actid
WHERE actors.lname = 'Eastwood'

--Q6
SELECT lname, fname
FROM actors
WHERE actid IN 
	(SELECT actid 
	FROM movie_actor
	WHERE mid IN
		(SELECT mid
		FROM movies
		WHERE title = 'Amelie')
	)

--Q7
SELECT COUNT(*) AS MOVIES_WITH_DVD
FROM  movies, copies
WHERE movies.mid = copies.mid AND cmedium = 'DVD'

--Q8
SELECT COUNT(*) AS DVD_AMOUNT
FROM copies
WHERE cmedium = 'DVD'

--Q9
SELECT MAX(price) AS EXPENSIVE_DVD
FROM copies
WHERE cmedium = 'DVD'

--Q10
SELECT SUM(price) AS SUM_BLURAY
FROM copies
WHERE cmedium = 'BLU RAY'

--Q11
SELECT lname, fname, COUNT(*)
FROM directors INNER JOIN movies ON directors.did = movies.did
GROUP BY lname, fname

--Q12
SELECT COUNT(*)
FROM movie_actor INNER JOIN actors ON movie_actor.actid = actors.actid
WHERE lname = 'Παπαγιαννόπουλος'

--Q13
SELECT lname, fname
FROM actors
WHERE actid IN (SELECT actid FROM movie_actor WHERE mid IN
				(SELECT mid FROM movies WHERE pcountry NOT IN ('GRC'))
				)

--Q14
SELECT title
FROM movies
WHERE mid IN (SELECT mid FROM movie_actor WHERE actid IN
					(SELECT actid FROM actors WHERE lname = 'Κούρκουλος')
				INTERSECT
				SELECT mid FROM movie_actor WHERE actid IN
					(SELECT actid FROM actors WHERE lname = 'Καρέζη')
				)
--Q15
SELECT title
FROM movies
WHERE mid IN (SELECT mid FROM movie_actor WHERE actid IN
					(SELECT actid FROM actors WHERE lname = 'Καρέζη')
				EXCEPT
				SELECT mid FROM movie_actor WHERE actid IN
					(SELECT actid FROM actors WHERE lname = 'Κούρκουλος')
			)

--Q16
SELECT title
FROM movies
WHERE mid IN (SELECT mid
				FROM movie_cat
				WHERE catid IN (SELECT catid
								FROM categories
								WHERE category = 'Κωμωδία')

				INTERSECT				

				SELECT mid
				FROM movie_cat
				WHERE catid IN	(SELECT catid
								FROM categories
								WHERE category = 'Αισθηματική')
			)


--Q17
SELECT category, COUNT(*)
FROM categories INNER JOIN movie_cat ON categories.catid = movie_cat.catid
GROUP BY category
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC

--Q18
SELECT lname,fname, COUNT(title)
FROM directors FULL JOIN movies ON directors.did = movies.did
GROUP BY lname, fname
ORDER BY COUNT(title)

--Q19
DELETE FROM categories
WHERE category = 'Βιογραφία'

--Q20
UPDATE copies
SET price = 70
WHERE cmedium = 'DVD' AND mid IN (SELECT mid FROM movies WHERE title = 'Amelie')