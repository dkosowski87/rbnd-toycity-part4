require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	DATA_FILE = File.dirname(__FILE__) + "/../data/data.csv"

	#MAIN METHODS

	def self.create(attributes={})
		new_record?(attributes) ? save(attributes) : find(attributes[:id])
	end

	def self.all
		data = get_data
		convert_to_objects data.delete_at(0), data
	end	

	def self.first(n=1)
		data = get_data
		data = convert_to_objects data.delete_at(0), data.first(n)
		n == 1 ? data.first : data
	end

	def self.last(n=1)
		data = get_data
		data = convert_to_objects data.delete_at(0), data.last(n)
		n == 1 ? data.first : data		
	end

	def self.find(id)
		data = get_data
		attribute_values = data.find { |row| row[0] == id }
		raise StandardError if attribute_values.nil?
		create_object data.delete_at(0), attribute_values
	end

	def self.destroy(id)
		data = get_data
		attribute_values = data.delete(data.find { |row| row[0] == id })
		write_to_database(data)
		create_object data.delete_at(0), attribute_values
	end

	def self.where(attributes={})
		data = get_data
		headers = data.delete_at(0)
		attributes.each do |attribute_name, attribute_value|
			column_number = headers.index(attribute_name)
			data.keep_if { |row| row[column_number] == attribute_value }
		end 
		convert_to_objects headers, data
	end

	def update(attributes={})
		data = Udacidata.send(:get_data)
		row_number = data.index(data.find { |row| row[0] == id })
		attributes.each do |attribute_name, attribute_value|
			column_number = data.first.index(attribute_name)
			data[row_number][column_number] = attribute_value
		end
		Udacidata.send(:write_to_database, data)
		self.class.create_object data.first, data[row_number] 
	end

	#INTERNAL HELPER METHODS

	def self.new_record?(attributes)
		!find(attributes[:id]) rescue true
	end

	def self.save(attributes)
		new_object, data = new(attributes), get_data
		data << data.first.map { |field| new_object.send(field) }
		write_to_database(data)
		new_object
	end

	def self.convert_to_objects(attribute_names, data)
		data.map { |attribute_values| create_object(attribute_names, attribute_values) }
	end

	def self.create_object(attribute_names, attribute_values)
		new attribute_names.zip(attribute_values).to_h
	end

	#DATABASE API

	def self.get_data
		modify_headers(read_from_database)
	end

	def self.modify_headers(data)
		headers = data.delete_at(0)
		object_name_index = headers.index(to_s.downcase)
		headers[object_name_index] = 'name' if object_name_index
		data.unshift headers.map(&:to_sym)
	end

	def self.read_from_database
		CSV.read(DATA_FILE, {converters: :numeric})
	end

	def self.write_to_database(data)
		CSV.open(DATA_FILE, 'wb') do |csv|
			data.each { |row| csv << row }
		end
	end

	private_class_method :get_data, :modify_headers, :read_from_database, :write_to_database

end
