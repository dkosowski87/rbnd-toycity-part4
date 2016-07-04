class Module
  def create_finder_methods(*attributes)
  	attributes.each do |attribute_name|
  		instance_eval(<<-DEFINING_METHODS, __FILE__, __LINE__ + 1)
  			def find_by_#{attribute_name}(attribute_value)
  				data = get_data
  				column_number = data.first.index(:#{attribute_name})
  				attribute_values = data.find { |row| row[column_number] == attribute_value }	
					create_object(data.first, attribute_values) if attribute_values
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
