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

DB(memoes)の作成
```db
$psql -f database/data.sql -d memoes
```

立ち上げ方

```bash
$bundle exec ruby app.rb
```
