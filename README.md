# How to use neo4j
## install

```
bundle install
bundle exec rake neo4j:install
DB_NAME=target_db_name
```

## start server

```
bundle exec rake neo4j:start
```

open `localhost:7474`

## stop server

```
bundle exec rake neo4j:stop
```