CREATE TABLE movies
(
   id INT PRIMARY KEY     NOT NULL,
   title           TEXT   NOT NULL,
   year            INT    NOT NULL,
   director        TEXT   NOT NULL,
   banner_url      TEXT   NOT NULL,
   trailer_url     TEXT   NOT NULL
);

CREATE TABLE stars
(
   id INT PRIMARY KEY     NOT NULL,
   first_name       TEXT   NOT NULL,
   last_name        TEXT   NOT NULL,
   dob              date,
   photo_url        TEXT   NOT NULL
);

CREATE TABLE stars_in_movies
(
   star_id       int   NOT NULL,
   movie_id        int   NOT NULL,
   FOREIGN KEY (star_id) REFERENCES stars(id),
   FOREIGN KEY (movie_id) REFERENCES movies(id)
);
