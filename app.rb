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

get '/memos/new' do
  @page_name = 'Create'
  erb :create
end

get '/memos/:id' do
  @page_name = 'Detail'
  memos_data = CSV.read(DATABASE_PATH, headers: true)
  memos_data.each {|row|
    if row['id'] == params[:id]
      @title = row['title']
      @text = row['text']
      @id = row['id']
    end
  }
  erb :detail
end

# 入力したデータがjsonファイル(database/data.csv)にプッシュされるはず....
post '/memos/new' do
  CSV.open(DATABASE_PATH, 'a') do |data|
    data.puts [SecureRandom.uuid, params[:title], params[:text], Time.now]
  end
  redirect to('/memos')
end

delete '/memos/:id' do
  csv_table = CSV.table(DATABASE_PATH)
  csv_table.delete_if { |row| row[0] == params[:id] }
  File.open(DATABASE_PATH, 'w') do |data|
    data.write(csv_table.to_csv)
  end
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @page_name = 'Edit'
  CSV.foreach(DATABASE_PATH, headers: true) do |row|
    if row['id'] == params[:id]
      @title = row['title']
      @text = row['text']
      @id = row['id']
    end
  end
  erb :edit
end

patch '/memos/:id/edit' do
  csv_table = CSV.table(DATABASE_PATH)
  change_col = csv_table.find{|row| row[0] == params[:id]}
  change_col[:title] = params[:title]
  change_col[:text] = params[:text]
  File.open(DATABASE_PATH, 'w') do |data|
    data.write(csv_table.to_csv)
  end
  redirect to('/memos')
end
