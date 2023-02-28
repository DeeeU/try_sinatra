# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'csv'
require 'securerandom'

enable :method_override

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end


class Memo

  def self.create(title: memo_title, text: memot_text)
    connection = PG.connect( dbname: 'db_sinatra' )
    connection.exec( "INSERT INTO memoes(title, text) VALUES ('#{title}', '#{text}')" )
  end

  def self.delete(id: memo_id)
    connection = PG.connect( dbname: 'db_sinatra' )
    connection.exec( " DELETE FROM  memoes where id = '#{id}'" )
  end

  def self.patch(id: memo_id, title: memo_title, text: memot_text)
    connection = PG.connect( dbname: 'db_sinatra')
    connection.exec( "UPDATE memoes SET (title, text) = ('#{title}', '#{text}') where id = '#{id}'" )
  end
end

conn = PG.connect( dbname: 'db_sinatra' )
result = conn.exec("SELECT * FROM memoes")
conn.close


get '/memos' do
  @page_name = 'Top'
  conn = PG::Connection.new(:host => 'localhost',  :dbname => 'db_sinatra', :port => '5432')
  result = conn.exec("SELECT * FROM memoes")
  conn.close
  @memos = result
  erb :index
end

get '/memos/new' do
  @page_name = 'Create'
  erb :create
end

get '/memos/:id' do
  @page_name = 'Detail'
  @memo = {
    'title' => '',
    'text' => '',
    'id' => ''
  }
  memo_col = result.find{|row| row['id'] == params[:id]}
  @memo['title'] = memo_col['title']
  @memo['text'] = memo_col['text']
  @memo['id'] = memo_col['id']
  erb :detail
end

post '/memos' do
  Memo.create(title: params[:title], text: params[:text])
  redirect to('/memos')
end

delete '/memos/:id' do
  memo_col = result.find{|row| row['id'] == params[:id]}
  Memo.delete(id: params[:id])
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @page_name = 'Edit'
  @memo = {
    'title' => '',
    'text' => '',
    'id' => ''
  }
  memo_col = result.find{|row| row['id'] == params[:id]}
  @memo['title'] = memo_col['title']
  @memo['text'] = memo_col['text']
  @memo['id'] = memo_col['id']

  erb :edit
end

patch '/memos/:id' do
  memo_col = result.find{|row| row['id'] == params[:id]}
  Memo.patch(id: params[:id], title: params[:title], text: params[:text])
  redirect to('/memos')
end
