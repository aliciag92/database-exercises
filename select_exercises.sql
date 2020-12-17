Exercises
Create a new file called select_exercises.sql. 
Do your work for this exercise in that file.
Use the albums_db database.
Explore the structure of the albums table.

Write queries to find the following information.
# Contents: id, artist, name, release_date, sales, genre

The name of all albums by Pink Floyd
   SELECT * FROM albums WHERE artist = "Pink Floyd"

or

   SELECT * 
    FROM albums 
    WHERE artist = "Pink Floyd";

The year Sgt. Pepper's Lonely Hearts Club Band was released
    SELECT release_date from albums WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';

or

    SELECT release_date, name 
    from albums 
    WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';

The genre for the album Nevermind
    SELECT genre from albums WHERE name = "Nevermind";

or

    SELECT genre, name 
    from albums 
    WHERE name = "Nevermind";

Which albums were released in the 1990s
    SELECT name FROM albums WHERE release_date BETWEEN 1990 and 1999;

or

    SELECT name, release_date 
    FROM albums 
    WHERE release_date BETWEEN 1990 and 1999;

Which albums had less than 20 million certified sales
    SELECT name FROM albums WHERE sales < 20000000;

or

    SELECT name, sales
    FROM albums 
    WHERE sales < 20.0;


All the albums with a genre of "Rock". Why do these query results 
not include albums with a genre of "Hard rock" or "Progressive rock"?
    SELECT * FROM albums WHERE genre = "Rock"

or

    SELECT * 
    FROM albums 
    WHERE genre = "Rock"
