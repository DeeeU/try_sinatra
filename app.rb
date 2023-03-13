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
  def self.create(title: title(), text: text())
    query = 'INSERT INTO memoes(title, text) VALUES ($1, $2)'
    params = [title, text]
    excute(query, params)
  end

  def self.delete(id: id())
    query = 'DELETE FROM  memoes where id = ($1)'
    params = [id]
    excute(query, params)
  end

  def self.patch(id: id(), title: title(), text: text())
    query = 'UPDATE memoes SET (title, text) = ($1, $2) where id = ($3)'
    params = [title, text, id]
    excute(query, params)
  end

  def self.excute(query, params)
    connection = PG::Connection.new(dbname: 'postgres')
    connection.exec_params(query, params)
  end
end

def find_memo(data)
  @memo = {
    'title' => '',
    'text' => '',
    'id' => ''
  }
  @memo = data.find{ |row| row['id'] == params[:id] }
  @memo
end

conn = PG.connect(dbname: 'postgres')
result = conn.exec('SELECT * FROM memoes')
conn.close

get '/memos' do
  @page_name = 'Top'
  conn = PG::Connection.new(host: :localhost, dbname: :postgres, port: :'5432')
  result = conn.exec('SELECT * FROM memoes')
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
  find_memo(result)
  erb :detail
end

post '/memos' do
  Memo.create(title: params[:title], text: params[:text])
  redirect to('/memos')
end

delete '/memos/:id' do
  find_memo(result)
  Memo.delete(id: params[:id])
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @page_name = 'Edit'
  find_memo(result)
  erb :edit
end

patch '/memos/:id' do
  find_memo(result)
  Memo.patch(id: params[:id], title: params[:title], text: params[:text])
  redirect to('/memos')
end
