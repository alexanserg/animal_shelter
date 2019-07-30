require('sinatra')
require('sinatra/reloader')
require('./lib/animal')
require('./lib/person')
require('pry')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "animal_shelter"})

get ('/') do
  @people = Person.all
  @animals = Animal.all
  erb(:index)
end

get ('/new_animal') do
  erb(:new_animal)
end

get ('/new_person') do
  erb(:new_person)
end

post ('/animals') do
  name = params[:name]
  type = params[:type]
  animal = Animal.new({:name => name, :type => type, :admitted => nil, id => nil})
  animal.save
  redirect to('/')
end

post ('/people') do
  name = params[:name]
  type = params[:type]
  number = params[:number].to_i
  person = Person.new({:name => name, :type => type, :number => number, :id => nil})
  person.save
  redirect to ('/')
end
