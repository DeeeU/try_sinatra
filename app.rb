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
    query = 'INSERT INTO memos(title, text) VALUES ($1, $2)'
    params = [title, text]
    excute(query, params)
  end

  def self.delete(id: id())
    query = 'DELETE FROM  memos where id = ($1)'
    params = [id]
    excute(query, params)
  end

  def self.patch(id: id(), title: title(), text: text())
    query = 'UPDATE memos SET (title, text) = ($1, $2) where id = ($3)'
    params = [title, text, id]
    excute(query, params)
  end

  def self.excute(query, params)
    conn.exec_params(query, params)
  end

  def self.conn
    @conn ||= PG.connect(dbname: 'memo_db')
  end

  def self.read_memos
    conn.exec('SELECT * FROM memos')
  end

  def self.find_memo(id: id())
    query = 'SELECT * FROM memos WHERE id = ($1)'
    params = [id]
    excute(query, params)
  end
end

get '/memos' do
  @page_name = 'Top'
  @memos = Memo.read_memos
  erb :index
end

get '/memos/new' do
  @page_name = 'Create'
  erb :create
end

get '/memos/:id' do
  @page_name = 'Detail'
  @memos = Memo.find_memo(id: params[:id])
  erb :detail
end

post '/memos' do
  Memo.create(title: params[:title], text: params[:text])
  redirect to('/memos')
end

delete '/memos/:id' do
  Memo.delete(id: params[:id])
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @page_name = 'Edit'
  @memos = Memo.find_memo(id: params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.patch(id: params[:id], title: params[:title], text: params[:text])
  redirect to('/memos')
end
