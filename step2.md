<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Full Query Logging</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:aleksandr.volochnev@datastax.com">email</a> or <a href="https://dtsx.io/aleks">LinkedIn</a>.</span> 
  </div>
</div>

<!-- NAVIGATION -->
<div id="navigation-top" class="navigation-top">
 <a href='command:katapod.loadPage?[{"step":"step1"}]'
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 2 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"step3"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Create schema and perform queries</div>

In this step, you will connect using `cqlsh` and create a keyspace and table, perform some queries, and verify that full query logs are being created.

✅ Start the CQL Shell (`cqlsh`) so you can issue CQL commands:
```
cqlsh
```

✅ Create the `ks_full_query_logging` keyspace:
```
CREATE KEYSPACE ks_full_query_logging
WITH replication = {
  'class': 'NetworkTopologyStrategy', 
  'DC-Houston': 1 };

USE ks_full_query_logging;
```

✅ Create the `movie_metadata` table:
```
CREATE TABLE movie_metadata(
  imdb_id        text,
  overview       text,
  release_date   text,
  title          text,
  average_rating float,
  PRIMARY KEY(imdb_id));
```

✅ Insert a row into the `movie_metadata` table:
```
INSERT INTO movie_metadata (imdb_id, overview, release_date, title, average_rating) 
VALUES('tt0114709', 'Led by Woody, Andy''s toys live happily in his room until Andy''s birthday brings Buzz Lightyear onto the scene. Afraid of losing his place in Andy''s heart, Woody plots against Buzz. But when circumstances separate Buzz and Woody from their owner, the duo eventually learns to put aside their differences.', '10/30/95', 'Toy Story', 7.7);
```

✅ Now let's do a `SELECT`:
```
SELECT * FROM movie_metadata WHERE imdb_id = 'tt0114709';
```

You should see the row you just inserted.

✅ Type `exit` to close `cqlsh`:
```
exit
```

✅ Now, let's check the contents of our log directory to see if anything has been created:
```
ls /tmp/fqllogs
```

You'll see two files, a file with a date timestamp in the name, and another file which provides a directory of all the dated files that have been written. You can try opening these files if you wish, but the contents won't make a lot of sense since they are binary data. Don't worry, Cassandra has a way to read this data.

In this step, you have created the `ks_full_query_logging` keyspace and the `movie_metadata` table, and performed some queries, and verified that full query logs were created.

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step1"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
