require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

database_path = 'database/data.csv'
csv = CSV.read(database_path)

get "/" do
  erb :index
end

get"/create" do
  erb :create
end

get "/memoes/:id" do |name|
  memo
  erb :detail
end

# 入力したデータがjsonファイル(database/data.json)にプッシュされるはず....
post "/confirm" do
  @title = params[:title]
  @text = params[:text]
  CSV.open(database_path, "a") do |csv|
    csv.puts [SecureRandom.uuid,@title,@text,Time.now]
  end
  redirect to('/')
end

#　editの時に使うpatch処理
# patch "/edit/*" do

# end
