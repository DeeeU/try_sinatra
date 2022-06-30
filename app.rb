# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

DATABASE_PATH = 'database/data.csv'
csv = CSV.read(DATABASE_PATH)

get '/memos' do
  @page_name = 'Top'
  @memoes_data = []
  CSV.foreach(DATABASE_PATH, headers: true) do |row|
    @memoes_data.push(row)
  end
  erb :index
end

get '/new' do
  @page_name = 'Create'
  erb :create
end

get '/memos/:id' do
  @page_name = 'Detail'
  CSV.foreach(DATABASE_PATH, headers: true) do |row|
    if row['ID'] == params[:id]
      @title = row['Title']
      @text = row['Text']
      @id = row['ID']
    end
  end
  erb :detail
end

# 入力したデータがjsonファイル(database/data.csv)にプッシュされるはず....
post '/new' do
  @title = params[:title]
  @text = params[:text]
  CSV.open(DATABASE_PATH, 'a') do |csv0|
    csv0.puts [SecureRandom.uuid, @title, @text, Time.now]
  end
  redirect to('/memos')
end

delete '/memos/:id' do
  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(DATABASE_PATH, 'w') do |data|
    csv.each do |array|
      data << array
    end
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
  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(DATABASE_PATH, 'w') do |data|
    csv.each do |array|
      data << array
    end
  end
  CSV.open(DATABASE_PATH, 'a') do |csv1|
    csv1.puts [params[:id], params[:title], params[:text], Time.now]
  end
  redirect to('/memos')
end
