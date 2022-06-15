require 'sinatra'
require 'sinatra/reloader'
require 'json'

class Memo
  def initialize()
    @id = null
    @title = null
    @text = null
  end
end
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
  File.open("database/data.json", "a") do |w|
    data = {"ID" => 1, "title" => @title, "text" => @text}
    w.write(data.to_json)
  end
  redirect to('/')
end

#　editの時に使うpatch処理
# patch "/edit/*" do

# end
