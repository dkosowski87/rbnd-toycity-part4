require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	DATA_FILE = File.dirname(__FILE__) + "/../data/data.csv"

	def self.create(options={})
		new_object = new(options)
		data = read_from_database
		data << attributes(data.first).map { |field| new_object.send(field) }
		write_to_database(data)
		return new_object
	end

	def self.all
		data = read_from_database
		data.drop(1).map { |values| create_object(data.first, values) }
	end	

	def self.first(n=1)
		data = read_from_database
		ud_data = data.drop(1).first(n).map { |values| create_object(data.first, values) }
		n == 1 ? ud_data.first : ud_data
	end

	def self.last(n=1)
		data = read_from_database
		ud_data = data.drop(1).last(n).map { |values| create_object(data.first, values) }
		n == 1 ? ud_data.first : ud_data		
	end

	def self.find(id)
		data = read_from_database
		new attributes(data.first).zip(data.find { |row| row[0] == id }).to_h
	end

	#Internal:

	def self.read_from_database
		CSV.read(DATA_FILE, {converters: :float})
	end

	def self.create_object(headers, values)
		new attributes(headers).zip(values).to_h
	end

	def self.write_to_database(data)
		CSV.open(DATA_FILE, 'wb') do |csv|
			data.each { |row| csv << row }
		end
	end

	def self.attributes(headers)
		object_name_index = headers.index(to_s.downcase)
		headers[object_name_index] = 'name' if object_name_index
		headers.map(&:to_sym)
	end

	private_class_method :read_from_database, :write_to_database, :attributes

end
