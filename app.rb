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

database_path = 'database/data.csv'
csv = CSV.read(database_path)

get '/' do
  @memoes = []
  CSV.foreach(database_path, headers: true) do |row|
    @memoes.push(row)
  end
  erb :index
end

get '/create' do
  erb :create
end

get '/memoes/:id' do
  CSV.foreach(database_path, headers: true) do |row|
    if row['ID'] == params[:id]
      @title = row['Title']
      @text = row['Text']
      @id = row['ID']
    end
  end
  erb :detail
end

# 入力したデータがjsonファイル(database/data.csv)にプッシュされるはず....
post '/create' do
  @title = params[:title]
  @text = params[:text]
  CSV.open(database_path, 'a') do |csv0|
    csv0.puts [SecureRandom.uuid, @title, @text, Time.now]
  end
  redirect to('/')
end

delete '/memoes/:id' do
  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(database_path, 'w') do |data|
    csv.each do |array|
      data << array
    end
  end
  redirect to('/')
end

get '/memoes/:id/edit' do
  CSV.foreach(database_path, headers: true) do |row|
    if row['ID'] == params[:id]
      @title = row['Title']
      @text = row['Text']
      @id = row['ID']
    end
  end
  erb :edit
end

patch '/memoes/:id/edit' do
  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(database_path, 'w') do |data|
    csv.each do |array|
      data << array
    end
  end
  CSV.open(database_path, 'a') do |csv1|
    csv1.puts [params[:id], params[:title], params[:text], Time.now]
  end
  redirect to('/')
end
