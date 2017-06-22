# Configuring Presto with Azure Data Services

[![Azure CosmosDB with MongoDB API, Azure SQL Database, Azure MySQL, Azure PostgreSQL](images/presto-azure-data-services-play.png)](https://youtu.be/XDfCK6Ejz-A)

## Azure CosmosDB with MongoDB API

Create sample data using mongo.exe command line client

```
mongo.exe YOURAZURECOSMOSDBACCOUNT.documents.azure.com:10255 -u USERNAME -p PASSWORD --ssl --sslAllowInvalidCertificates
```

```
db.movies.insert({"id":100, "name": "The Shawshank Redemption", "year": 1994, "length": 120, "contentRating": "R"})
db.movies.insert({"id":200, "name": "The Godfather", "year": 1972, "length": 175, "contentRating": "R"})
db.movies.insert({"id":300, "name": "The Dark Knight", "year": 2008, "length": 120, "contentRating": "PG-13"})

db.movies.find()
```

## Azure SQL Database

Create sample data using Azure SQL Database Query Editor (preview) in portal.azure.com (under Azure SQL Database Tools)

```
sp_tables;
create table users (userid bigint, name varchar(255));
insert into users (userid, name) values (1, 'John');
insert into users (userid, name) values (2, 'Mary');
insert into users (userid, name) values (3, 'John');
insert into users (userid, name) values (4, 'Mike');
insert into users (userid, name) values (5, 'Kate');
insert into users (userid, name) values (7, 'Elizabeth');
select * from users;
```

## Azure MySQL Database

Create sample data using mysql command line client

```
mysql -h YOURAZUREMYSQLACCOUNT.mysql.database.azure.com -D DATABASE -u USERNAME -p --ssl-mode Preferred
```

```
create table tickets (userid bigint, movieid bigint, price decimal, purchase_date date);
insert into tickets (userid, movieid, price, purchase_date) values (1, 100, 8.00, STR_TO_DATE('2016-06-01', '%Y-%m-%d'));
insert into tickets (userid, movieid, price, purchase_date) values (1, 200, 9.00, STR_TO_DATE('2016-06-02', '%Y-%m-%d'));
insert into tickets (userid, movieid, price, purchase_date) values (2, 100, 12.00, STR_TO_DATE('2016-06-03', '%Y-%m-%d'));
insert into tickets (userid, movieid, price, purchase_date) values (2, 200, 9.00, STR_TO_DATE('2016-06-02', '%Y-%m-%d'));
select * from tickets;
```

## Azure PostgreSQL Database

Create sample data using pgsql command line client

```
psql -h YOURAZUREPOSTGRESQLACCOUNT.postgres.database.azure.com -d postgres -U USERNAME "sslmode=require dbname=DATABASE"
```

```
create table user_movie_ratings (userid bigint, movieid bigint, rating int);
insert into user_movie_ratings (userid, movieid, rating) values (1, 100, 5);
insert into user_movie_ratings (userid, movieid, rating) values (1, 200, 3);
insert into user_movie_ratings (userid, movieid, rating) values (2, 100, 2);
insert into user_movie_ratings (userid, movieid, rating) values (2, 200, 4);
select * from user_movie_ratings;
```

## Create Hive table located on WASB

Use Hive CLI from within the container

```
hive --hiveconf hive.metastore.uris=thrift://localhost:9083
```

```
create table user_movie_rating_ticket (userid bigint, user_name varchar(255), rating int, price decimal, purchase_date date, movie_name varchar(255), year bigint, length bigint, content_rating varchar(255))
row format delimited fields terminated by ',' stored as textfile location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/user_movie_rating_ticket';
```

## Presto Queries

Using Presto CLI from within the container

```
./presto --server localhost:8080
```

```
select * from cosmosdb.mydb1.movies;
select * from azuresql.dbo.users;
select * from mysql.mydb1.tickets;
select * from postgresql.public.user_movie_ratings;
```

Join data from Azure CosmosDB with Azure SQL Server, Azure MySQL, and Azure PostgreSQL

```
select u.userid, u.name, r.rating, t.price, t.purchase_date, m.name, m.year, m.length, m.contentRating from azuresql.dbo.users u inner join mysql.mydb1.tickets t on u.userid = t.userid inner join cosmosdb.mydb1.movies m on m.id = t.movieid
inner join postgresql.public.user_movie_ratings r on r.movieid = t.movieid and r.userid = u.userid order by u.userid, m.id;
```

Insert results into WASB table

```
insert into hive.default.user_movie_rating_ticket
select u.userid, u.name, r.rating, cast(t.price as decimal(10,0)), t.purchase_date, cast(m.name as varchar(255)), m.year, m.length, cast(m.contentRating as varchar(255)) from azuresql.dbo.users u inner join mysql.mydb1.tickets t on u.userid = t.userid inner join cosmosdb.mydb1.movies m on m.id = t.movieid
inner join postgresql.public.user_movie_ratings r on r.movieid = t.movieid and r.userid = u.userid order by u.userid, m.id;
```

```
select * from hive.default.user_movie_rating_ticket;
```
