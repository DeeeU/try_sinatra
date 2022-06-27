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

get '/Top' do
  @page_name = 'Top'
  @memoes_data = []
  CSV.foreach(DATABASE_PATH, headers: true) do |row|
    @memoes_data.push(row)
  end
  erb :index
end

get '/memoes' do
  @page_name = 'Create'
  erb :create
end

get '/memoes/:id' do
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
post '/memoes' do
  @title = params[:title]
  @text = params[:text]
  CSV.open(DATABASE_PATH, 'a') do |csv0|
    csv0.puts [SecureRandom.uuid, h(@title), h(@text), Time.now]
  end
  redirect to('/Top')
end

delete '/memoes/:id' do
  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(DATABASE_PATH, 'w') do |data|
    csv.each do |array|
      data << array
    end
  end
  redirect to('/Top')
end

get '/memoes/:id/edit' do
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

patch '/memoes/:id/edit' do
  csv.delete_if { |row| row[0] == params[:id] }
  CSV.open(DATABASE_PATH, 'w') do |data|
    csv.each do |array|
      data << array
    end
  end
  CSV.open(DATABASE_PATH, 'a') do |csv1|
    csv1.puts [params[:id], h(params[:title]), h(params[:text]), Time.now]
  end
  redirect to('/Top')
end
