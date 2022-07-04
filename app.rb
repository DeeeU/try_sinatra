# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

enable :method_override

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

DATABASE_PATH = 'database/data.csv'
# csv = CSV.read(DATABASE_PATH)

get '/memos' do
  @page_name = 'Top'
  @memos_data = CSV.read(DATABASE_PATH, headers: true)
  erb :index
end

get '/new' do
  @page_name = 'Create'
  erb :create
end

get '/memos/:id' do
  @page_name = 'Detail'
  @memos_data = CSV.read(DATABASE_PATH, headers: true)
  @memos_data.each {|row|
    if row['id'] == params[:id]
      @title = row['title']
      @text = row['text']
      @id = row['id']
    end
  }
  erb :detail
end

# 入力したデータがjsonファイル(database/data.csv)にプッシュされるはず....
post '/new' do
  CSV.open(DATABASE_PATH, 'a') do |data|
    data.puts [SecureRandom.uuid, params[:title], params[:text], Time.now]
  end
  redirect to('/memos')
end

delete '/memos/:id' do
  csv_table = CSV.table(DATABASE_PATH)
  csv_table.delete_if { |row| row[0] == params[:id] }
  File.open(DATABASE_PATH, 'w', headers: true) do |data|
    data.write(csv_table.to_csv)
  end
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @page_name = 'Edit'
  CSV.foreach(DATABASE_PATH, headers: true) do |row|
    if row['ID'] == params[:id]
      @title = row['Title']
      @text = row['Text']
      @id = row['ID']
    end
  end
  erb :edit
end

patch '/memos/:id/edit' do
  # table作る（メモリー上で使えるように）
  # 行を見つける(id使え)
  # csv1.puts [params[:id], params[:title], params[:text], Time.now]みたいなやつで書き換え
  # 保存する

  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(DATABASE_PATH, 'w') do |data|
    csv.each do |array|
      data << array
    end
  end
  CSV.open(DATABASE_PATH, 'a') do |csv1|
  end
  redirect to('/memos')
end
