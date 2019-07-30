class Animal
  attr_accessor :name, :type, :admitted, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @type = attributes.fetch(:type)
    @admitted = Time.now
    @id = attributes.fetch(:id)
  end

  def self.all
    returned = DB.exec("SELECT * FROM animals ORDER BY name;")
    animals = []
    returned.each() do |animal|
      name = animal.fetch("name")
      type = animal.fetch("type")
      admitted = animal.fetch("admitted")
      id = animal.fetch("id").to_i
      animals.push(Animal.new({:name => name, :type => type, :admitted => admitted, :id => id}))
    end
    animals
  end

  def self.clear
    DB.exec("DELETE FROM animals *;")
  end

  def self.find(id)
    animal = DB.exec("SELECT * FROM animals WHERE id = #{id};").first
    if animal
      name = animal.fetch("name")
      type = animal.fetch("type")
      admitted = animal.fetch("admitted")
      id = animal.fetch("id").to_i
      Animal.new({:name => name, :type => type, :admitted => admitted, :id => id})
    else
      nil
    end
  end

  def delete
    DB.exec("DELETE FROM animals WHERE id = #{@id};")
  end

  def save
    result = DB.exec("INSERT INTO animals (name, type, admitted) VALUES ('#{@name}', '#{@type}', '#{@admitted}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end
end
