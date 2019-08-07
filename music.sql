CREATE TABLE artist(
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR
);

CREATE TABLE album(
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR,
	artist_id INTEGER REFERENCES artist(id),
	release_year TIMESTAMP
);

CREATE TABLE song(
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR,
	song_genre VARCHAR,
	album_id INTEGER REFERENCES album(id),
	song_writer_id INTEGER REFERENCES song_writer(id),
	duration TIME
);

CREATE TABLE song_writer(
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR
);

INSERT INTO artist VALUES
(DEFAULT, 'Beetles'),
(DEFAULT, 'Elvis'),
(DEFAULT, 'MJ'),
(DEFAULT, 'Madonna'),
(DEFAULT, 'Elton'),
(DEFAULT, 'Led Zeppelin'),
(DEFAULT, 'Rihanna');

INSERT INTO album VALUES
(DEFAULT, 'Abbey Road', 1, TO_TIMESTAMP('1969','YYYY')),
(DEFAULT, 'Let it be', 1, TO_TIMESTAMP('1970','YYYY')),
(DEFAULT, 'Yellow Submarine', 1, TO_TIMESTAMP('1969','YYYY')),
(DEFAULT, 'Java is Lava', 2, TO_TIMESTAMP('2019','YYYY')),
(DEFAULT, 'Tap the Keyboard', 1, TO_TIMESTAMP('2017','YYYY')),
(DEFAULT, 'What does MJ Want?', 3, TO_TIMESTAMP('1982','YYYY')),
(DEFAULT, 'American Life', 4, TO_TIMESTAMP('2003','YYYY')),
(DEFAULT, 'Yellow Brick Road', 5, TO_TIMESTAMP('1975','YYYY')),
(DEFAULT, 'Cabala', 6, TO_TIMESTAMP('1995','YYYY')),
(DEFAULT, 'Rihanna: Covers', 7, TO_TIMESTAMP('2020','YYYY'));

INSERT INTO song_writer VALUES
(DEFAULT, 'Beetles'),
(DEFAULT, 'Elvis'),
(DEFAULT, 'MJ'),
(DEFAULT, 'Madonna'),
(DEFAULT, 'Elton'),
(DEFAULT, 'Led Zeppelin'),
(DEFAULT, 'Rihanna'),
(DEFAULT, 'Jon Joe'),
(DEFAULT, 'Ian');

INSERT INTO song VALUES
(DEFAULT, 'Hey Jude', 'rock', 1, 1, '00:04:37'),
(DEFAULT, 'Here Comes the Sun', 'rock', 1, 1, '00:02:16'),
(DEFAULT, 'Let It Be', 'rock', 2, 1, '00:01:22'),
(DEFAULT, 'Yellow Submarine', 'rock', 3, 1, '00:06:48'),
(DEFAULT, 'Python Rocks', 'rap', 4, 9, '00:03:26'),
(DEFAULT, 'Qwerty', 'rap', 5, 8, '00:03:41'),
(DEFAULT, 'Thriller', 'pop', 6, 3, '00:04:43'),
(DEFAULT, 'Hey Jude', 'rap', 7, 4, '00:04:31'),
(DEFAULT, 'Like a Virgin', 'pop', 7, 4, '00:01:50'),
(DEFAULT, 'Rocket Man', 'rock', 8, 5, '00:02:01'),
(DEFAULT, 'Stairway to Heaven', 'rock', 9, 6, '00:00:55'),
(DEFAULT, 'Hey Jude', 'pop', 10, 7, '00:02:01'),
(DEFAULT, 'Rocket Man', 'country', 10, 7, '00:02:01');

SELECT * from artist;
SELECT * from album;
SELECT * from song;
SELECT * from song_writer;

--1. What are tracks for a given album (Abbey Road)?  
SELECT song.name
	FROM song, album
	WHERE song.album_id = album.id
		AND album.name = 'Abbey Road';
--2. What are the albums produced by a given artist (Beetles)?
SELECT album.name
	FROM song, artist, album
	WHERE song.album_id = album.id
		AND artist.id = album.artist_id
		AND artist.name = 'Beetles'
	GROUP BY album.id;
--3. What is the track with the longest duration?
SELECT *
	FROM song
	ORDER BY song.duration DESC
	LIMIT 1;
--4. What are the albums released in the 60s?
SELECT *
	FROM album
	WHERE release_year > '1959-12-31'
		AND release_year < '1970-01-01';
--5. How many albums did a given artist produce in the 90s? (Led Zeppelin)
SELECT count(album.id)
	FROM artist, album
	WHERE artist.id = album.artist_id
		AND release_year > '1989-12-31'
		AND release_year < '2000-01-01';
--6. When is each artist's latest album?
SELECT artist.name, max(album.release_year)
	FROM artist, album
	WHERE artist.id = album.artist_id
	GROUP BY artist.id;	
--7. List all albums along with its total duration based on summing the duration of its tracks.
SELECT album.name, sum(song.duration)
	FROM album, song
	WHERE album.id = song.album_id
	GROUP BY album.id;
--8. What is the album with the longest duration?
SELECT album.name, sum(song.duration)
	FROM album, song
	WHERE album.id = song.album_id
	GROUP BY album.id
	ORDER BY sum(song.duration) DESC
	LIMIT 1;
--9. Who are the 5 most prolific artists based on the number of albums they have recorded?
SELECT artist.name, count(album.id)
	FROM artist, album
	WHERE artist.id = album.artist_id
	GROUP BY artist.id
	ORDER BY count(album.id) DESC
	LIMIT 5;
--10. What are all the tracks a given artist has recorded? (Beetles)
SELECT song.name
	FROM artist, album, song
	WHERE artist.id = album.artist_id
		AND album.id = song.album_id
		AND artist.name = 'Beetles';
--11. What are the top 5 most often recorded songs?
SELECT song.name, count(song.id) 
	FROM song
	GROUP BY song.name
	ORDER BY count(song.id) DESC
	LIMIT 5;
--12. Who are the top 5 song writers whose songs have been most often recorded?
SELECT song_writer.name, count(song.id)
	FROM song, song_writer
	WHERE song.song_writer_id = song_writer.id
	GROUP BY song_writer.id
	ORDER BY count(song.id) DESC
	LIMIT 5;
--13. Who is the most prolific song writer based on the number of songs he has written?
SELECT song_writer.name, count(song.id)
	FROM song, song_writer
	WHERE song.song_writer_id = song_writer.id
	GROUP BY song_writer.id
	ORDER BY count(song.id) DESC
	LIMIT 1;
--14. What songs has a given artist recorded? (Rihanna)
SELECT song.name, artist.name
	FROM artist, album, song
	WHERE artist.id = album.artist_id
		AND album.id = song.album_id
		AND artist.name = 'Rihanna'; 
--15. Who are the song writers whose songs a given artist has recorded? (Beeltes)
SELECT song_writer.name, count(song.id)
	FROM song_writer, song, album, artist
	WHERE song_writer.id = song.song_writer_id
		AND song.album_id = album.id
		AND artist.id = album.artist_id
		AND artist.name = 'Beetles'
	GROUP BY song_writer.id;
--16. Who are the artists who have recorded a given song writer's songs? (Jon Joe)
SELECT artist.name, count(song.id)
	FROM song_writer, song, album, artist
	WHERE song_writer.id = song.song_writer_id
		AND song.album_id = album.id
		AND artist.id = album.artist_id
		AND song_writer.name = 'Jon Joe'
	GROUP BY artist.id;