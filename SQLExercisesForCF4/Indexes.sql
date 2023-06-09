--Used for testing 
checkpoint
dbcc dropcleanbuffers


--Q1.1

select title from movies where pyear between 1995 and 2005

CREATE INDEX movies_year ON movies(pyear)  


--Q1.2

select pyear, title from movies where pyear between 1995 and 2005

CREATE INDEX movies_year ON movies(pyear) INCLUDE(title)


--Q1.3

select title, pyear from movies where pyear between 1995 and 2005
order by pyear, title

CREATE INDEX movies_year_title ON movies(pyear, title) 


--Q2.1

SELECT title, pyear FROM movies WHERE mid IN (SELECT mid FROM movie_directors WHERE did IN (SELECT did FROM directors WHERE lastname = 'Zygadlo'))

CREATE INDEX director_names ON directors(lastname)


--Q2.2

SELECT title, pyear, mrank FROM movies WHERE mrank >= 7.0 AND mid IN (SELECT mid FROM movies_genre WHERE genre = 'Comedy')

CREATE INDEX genre_index ON movies_genre(genre) INCLUDE(mid)


--Q2.3

SELECT title, mrank FROM movies WHERE pyear = 2000 AND mrank > 5.0

CREATE INDEX year_rank ON movies(pyear, mrank) INCLUDE(title)


--Q3

SELECT title 
FROM movies 
WHERE mid IN (SELECT mid FROM roles WHERE aid IN (SELECT aid FROM actors WHERE gender = 'M'))
		AND mid NOT IN (SELECT mid FROM roles WHERE aid IN (SELECT aid FROM actors WHERE gender = 'F'))

CREATE INDEX genders_index ON actors(gender) INCLUDE (aid)
CREATE INDEX actors_per_movie ON roles(mid, aid) 


--Q4.1

--Εμφανίστε έναν κατάλογο με τον τίτλο, την χρονιά παραγωγής και την βαθμολογία από  τις 100 ταινίες που έχουν την υψηλότερη βαθμολογία στην κατηγορία 'Comedy'

SELECT TOP 100 title, pyear, mrank FROM movies 
WHERE mid IN (SELECT mid FROM movies_genre WHERE genre = 'Comedy')
ORDER BY mrank DESC

CREATE INDEX top_movies ON movies(mrank, mid)
CREATE INDEX genres_sorted ON movies_genre(genre, mid) 


--Q4.2

SELECT title, pyear, mrank FROM movies 
WHERE mid IN (SELECT mid FROM movie_directors WHERE did IN (SELECT did FROM directors WHERE firstName = 'Steven' AND lastname = 'Spielberg'))
ORDER BY mrank DESC


CREATE INDEX dir_names ON directors(lastname, firstname, did)
CREATE INDEX dir_movie ON movie_directors(did, mid)