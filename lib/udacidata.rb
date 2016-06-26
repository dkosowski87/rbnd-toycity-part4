require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	DATA_FILE = File.dirname(__FILE__) + "/../data/data.csv"

	def self.create(options={})
		ud_object = new(options)
		ud_object.send(:set_attributes, options)
		ud_object.send(:save)
	end

	private
	def set_attributes(attributes)
		if attributes[:name]
			attributes[:"#{self.class.to_s.downcase}"] = attributes.delete(:name)
		end
		@attributes = attributes.merge(id: id)
	end

	def save
		CSV.open(DATA_FILE, 'a+b') do |csv|
			csv << csv.first.map { |field| @attributes[field.to_sym] }
		end
		return self
	end

end
