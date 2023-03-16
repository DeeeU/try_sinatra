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

DB(memo_db)の作成

```db
$psql -U postgres

postgres=# create database memo_db;

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
