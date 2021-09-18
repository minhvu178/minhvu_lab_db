/*
    Lab 03: Movie ratings
    CSC 362 Database Systems
    Minh Vu

    This script is going to create a database to rate movies 
*/

/* Create the database (dropping the previous version if necessary */

DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;

/* Create the Movies table */
CREATE TABLE Movies (
    PRIMARY KEY     (MovieID),
    MovieID         INT AUTO_INCREMENT,
    MovieTitle      VARCHAR(50),
    ReleaseDate     DATE,
    Genre           VARCHAR(100)
);

/* Create the Consumers table */
CREATE TABLE Consumers (
    PRIMARY KEY     (ConsumerID),
    ConsumerID      INT AUTO_INCREMENT,
    FirstName       VARCHAR(20),
    LastName        VARCHAR(20),
    Address         VARCHAR(100),
    City            VARCHAR(30),
    State           CHAR(2),
    Zip             VARCHAR(16)
);

/* Create the Ratings table */
CREATE TABLE Ratings (
    FOREIGN KEY     (ConsumerID) REFERENCES     Consumers(ConsumerID),
    FOREIGN KEY     (MovieID)    REFERENCES     Movies(MovieID),
    MovieID         INT NOT NULL,
    ConsumerID      INT NOT NULL,
    WhenRated       DATETIME(2),
    NumberStars     INT
);

/* Populate the tables with sample data */
INSERT INTO Movies(MovieTitle, ReleaseDate, Genre)
VALUES  ('The Hunt for Red October', '1990-03-02', 'Action, Adventure, Thriller'),
        ('Lady Bird',                '2017-12-01', 'Comedy, Drama'),
        ('Inception',                '2010-08-16', 'Action, Adventure, Sci-fi');


INSERT INTO Consumers(FirstName, LastName, Address, City, State, Zip)
VALUES  ('Toru',    'Okada',     '800 Glenridge Ave', 'Hobart',     'IN', '46342'),
        ('Kumiko',  'Okada',     '864 NW Bohemia St', 'Vincentown', 'NJ', '08088'),
        ('Noboru',  'Wataya',    '342 Joy Ridge St',  'Hermitage',  'TN', '37075'),
        ('May',     'Kasahara',  '5 Kent Rd',         'East Haven', 'CT', '06512');


INSERT INTO Ratings(MovieID, ConsumerID, WhenRated, NumberStars)
VALUES  (1, 1, '2010-09-02 10:54:19', 4),
        (1, 3, '2012-08-05 15:00:01', 3),
        (1, 4, '2016-10-02 23:58:12', 1),
        (2, 3, '2017-03-27 00:12:48', 2),
        (2, 4, '2018-08-02 00:54:42', 4);

/* Select all information from all tables */
SELECT * FROM Movies;
SELECT * FROM Consumers;
SELECT * FROM Ratings;

/* Generate a report */
SELECT FirstName, LastName, MovieTitle, NumberStars
  FROM Movies
       NATURAL JOIN Ratings
       NATURAL JOIN Consumers;

/* The rating table still needs to have an ID for every single rating */

/* STEP 6 */
/* Create the database (dropping the previous version if necessary */

DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;

/* Create the Movies table */
CREATE TABLE Movies (
    PRIMARY KEY     (MovieID),
    MovieID         INT AUTO_INCREMENT,
    MovieTitle      VARCHAR(50),
    ReleaseDate     DATE,
    Genre           VARCHAR(100)
);

/* Create the Consumers table */
CREATE TABLE Consumers (
    PRIMARY KEY     (ConsumerID),
    ConsumerID      INT AUTO_INCREMENT,
    FirstName       VARCHAR(20),
    LastName        VARCHAR(20),
    Address         VARCHAR(100),
    City            VARCHAR(30),
    State           CHAR(2),
    Zip             VARCHAR(16)
);

/* Create the Ratings table */
CREATE TABLE Ratings (
    PRIMARY KEY     (RatingID),
    FOREIGN KEY     (ConsumerID) REFERENCES     Consumers(ConsumerID),
    FOREIGN KEY     (MovieID)    REFERENCES     Movies(MovieID),
    RatingID        INT AUTO_INCREMENT,
    MovieID         INT NOT NULL,
    ConsumerID      INT NOT NULL,
    WhenRated       DATETIME(2),
    NumberStars     INT
);

/* Populate the tables with sample data */
INSERT INTO Movies(MovieTitle, ReleaseDate, Genre)
VALUES  ('The Hunt for Red October', '1990-03-02', 'Action, Adventure, Thriller'),
        ('Lady Bird',                '2017-12-01', 'Comedy, Drama'),
        ('Inception',                '2010-08-16', 'Action, Adventure, Sci-fi');


INSERT INTO Consumers(FirstName, LastName, Address, City, State, Zip)
VALUES  ('Toru',    'Okada',     '800 Glenridge Ave', 'Hobart',     'IN', '46342'),
        ('Kumiko',  'Okada',     '864 NW Bohemia St', 'Vincentown', 'NJ', '08088'),
        ('Noboru',  'Wataya',    '342 Joy Ridge St',  'Hermitage',  'TN', '37075'),
        ('May',     'Kasahara',  '5 Kent Rd',         'East Haven', 'CT', '06512');


INSERT INTO Ratings(MovieID, ConsumerID, WhenRated, NumberStars)
VALUES  (1, 1, '2010-09-02 10:54:19', 4),
        (1, 3, '2012-08-05 15:00:01', 3),
        (1, 4, '2016-10-02 23:58:12', 1),
        (2, 3, '2017-03-27 00:12:48', 2),
        (2, 4, '2018-08-02 00:54:42', 4);

/* Select information for a rating table */
SELECT RatingID, FirstName, LastName, MovieTitle, NumberStars
  FROM Movies
       NATURAL JOIN Ratings
       NATURAL JOIN Consumers;