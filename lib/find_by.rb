class Module
  def create_finder_methods(*attributes)
  	attributes.each do |attr_name|
  		instance_eval(<<-DEFINING_METHODS, __FILE__, __LINE__ + 1)
  			def find_by_#{attr_name}(attr_value)
  				data = read_from_database
  				value_index = attributes(data.first).index(:#{attr_name})
  				values = data.drop(1).find { |row| row[value_index] == attr_value }	
					create_object(data.first, values)			
  			end
  		DEFINING_METHODS
  	end
  end

  def attr_reader(*attributes)
    create_finder_methods *attributes
    attributes.each do |attribute|
      class_eval "def #{attribute}; @#{attribute}; end"
    end
  end
end
