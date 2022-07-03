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
    if row['ID'] == params[:id]
      @title = row['Title']
      @text = row['Text']
      @id = row['ID']
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
  # 前の
  # csv.delete_if { |row| row[0] == params[:id] }
  # CSV.open(DATABASE_PATH, 'w') do |data|
  #   csv.each do |array|
  #     data << array
  #   end
  # 現在
  @memos_data = CSV.open(DATABASE_PATH, headers: true) do |data|

    # @memos_data.delete_if { |row| row['ID'] == params[:id].to_s }
    redirect to('/memos')
  end
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
