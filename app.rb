require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'




# Routen /
get('/') do

  db=SQLite3::Database.new('db/todos.db')
  db.results_as_hash = true
  @databastodos = db.execute("SELECT * FROM todos WHERE done = 0")
  @databastodosdone = db.execute("SELECT * FROM todos WHERE done = 1")
  p @databastodos
  slim(:"index")

end



post('/:id/delete') do

  id = params[:id].to_i
#koppla till databasen
  db = SQLite3::Database.new('db/todos.db')
  db.execute("DELETE FROM todos WHERE id = ?", id)
  
  redirect('/')
end
post('/new')do

  new_todo = params[:new_todo]
  description = params[:description]
  
  db = SQLite3::Database.new('db/todos.db')
  db.execute("INSERT INTO todos (name, description) VALUES (?,?)", [new_todo, description])
  redirect('/')

end

get('/todos/:id/edit')do
  db = SQLite3::Database.new('db/todos.db')
  db.results_as_hash = true
  id = params[:id].to_i
  @special_todos = db.execute("SELECT * FROM todos WHERE id = ?",id).first
  #visa formulär för att uppdatera
  slim(:'/edit')

end

post('/:id/update')do

 #plocka upp id
  id = params[:id].to_i
  name = params[:name]
  description = params[:description]

  #kopla till databas
  db = SQLite3::Database.new('db/todos.db')
  db.execute("UPDATE todos SET name=?, description=? WHERE id=?",[name, description, id])
  redirect('/')

end

post('/:id/done') do

  id = params[:id].to_i
#koppla till databasen
  db = SQLite3::Database.new('db/todos.db')
  db.results_as_hash = true
  db.execute("UPDATE todos SET done = 1 WHERE id = ?",id)

  
  redirect('/')
end

post('/:id/undone') do

  id = params[:id].to_i
#koppla till databasen
  db = SQLite3::Database.new('db/todos.db')
  db.results_as_hash = true
  db.execute("UPDATE todos SET done = 0 WHERE id = ?",id)

  
  redirect('/')
end