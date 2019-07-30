class Person
  attr_accessor :name, :type, :number, :id
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @type = attributes.fetch(:type)
    @number = attributes.fetch(:number).to_i
    @id = attributes.fetch(:id)
  end

  def self.all
    returned = DB.exec("SELECT * FROM people ORDER BY name;")
    people = []
    returned.each() do |person|
      name = person.fetch("name")
      type = person.fetch("type")
      number = person.fetch("number").to_i
      id = person.fetch("id").to_i
      people.push(Person.new({:name => name, :type => type, :number => number, :id => id}))
    end
    people
  end

  def self.clear
    DB.exec("DELETE FROM people *;")
  end

  def self.find(id)
    person = DB.exec("SELECT * FROM people WHERE id = #{id};").first
    if person
      name = person.fetch("name")
      type = person.fetch("type")
      number = person.fetch("number").to_i
      id = person.fetch("id").to_i
      Person.new({:name => name, :type => type, :number => number, :id => id})
    else
      nil
    end
  end

  def delete
    DB.exec("DELETE FROM people WHERE id = #{@id};")
  end

  def save
    result = DB.exec("INSERT INTO people (name, type, number) VALUES ('#{@name}', '#{@type}', #{@number}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end
end
