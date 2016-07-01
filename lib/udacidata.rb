require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	DATA_FILE = File.dirname(__FILE__) + "/../data/data.csv"

	def self.create(options={})
		save new(options)
	end

	def self.all
		data = CSV.read(DATA_FILE, {converters: :float})
		attributes = convert_attributes(data.delete_at(0))
		data.map! { |values| new(attributes.zip(values).to_h) }
	end

	#Internal:

	def self.save(udacidata_object)
		CSV.open(DATA_FILE, 'a+b') do |csv|
			attributes = convert_attributes(csv.first)
			csv << attributes.map { |field| udacidata_object.send(field) }
		end and return udacidata_object
	end

	def self.convert_attributes(attributes)
		object_name_index = attributes.index(to_s.downcase)
		attributes[object_name_index] = 'name' if object_name_index
		attributes.map(&:to_sym)
	end

	private_class_method :save, :convert_attributes

end
