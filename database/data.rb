# frozen_string_literal: true

require 'pg'

begin
  # Initialize connection variables.
  host = String('localhost')
  database = String('db_sinatra')

  # Initialize connection object.
  connection = PG::Connection.new(host: host, dbname: database, port: 5432)
  puts 'Successfully created connection to database'

  # Drop previous table of same name if one exists
  connection.exec('DROP TABLE IF EXISTS memoes;')
  puts 'Finished dropping table (if existed).'

  # exists uuid-ossp
  connection.exec('CREATE EXTENSION IF NOT EXISTS "uuid-ossp";')

  # Drop previous table of same name if one exists.
  connection.exec('CREATE TABLE memos (
    id uuid DEFAULT uuid_generate_v4(),
    title text NOT NULL,
    text text NOT NULL,
    time timestamp default CURRENT_TIMESTAMP
  );')
  puts 'Finished creating table.'

  # Insert some data into table.
  connection.exec("INSERT INTO memos (title, text) VALUES ('東京', '東京ラーメン')")
  connection.exec("INSERT INTO memos (title, text) VALUES ('八王子', '八王子ラーメン')")
  connection.exec("INSERT INTO memos (title, text) VALUES ('札幌', '札幌ラーメン')")
  connection.exec("INSERT INTO memos (title, text) VALUES ('九州', '豚骨ラーメン')")
  puts 'Inserted 4 rows of data.'
rescue PG::Error => e
  puts e.message
ensure
  connection.close if connection
end
