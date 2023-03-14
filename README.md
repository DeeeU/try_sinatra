# try_sinatra

git clone した後に以下のコマンドを実行してください

ディレクトリの移動

```bash
$cd try_sinatra
```

gem の導入

```bash
$bundle install
```

DB(db_sinatra)の作成

```db
$psql -U postgres

postgres=# create database db_sinatra;

postgres=# exit;
```

table(memos)の作成

```table
$ruby database/data.rb
```

立ち上げ方

```bash
$bundle exec ruby app.rb
```
