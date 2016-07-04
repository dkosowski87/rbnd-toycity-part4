module Analyzable
  def average_price(data)
  	(data.inject(0) { |sum, item| sum + item.price } / data.size).round(2)
  end

  def count_by_brand(data)
  	data.group_by { |product| product.brand }.
  	map {|brand, items| [brand, items.size] }.to_h
  end

  def count_by_name(data)
  	data.group_by { |product| product.name }.
  	map {|name, items| [name, items.size] }.to_h
  end

  def print_report(data)
		report = "Average Price: $#{average_price(data)}\n"
  	report << "Inventory by Brand:\n"
  	count_by_brand(data).each { |brand, stock| report << "- #{brand}: #{stock}\n" }
  	report << "Inventory by Name:\n"
  	count_by_name(data).each { |name, stock| report << "- #{name}: #{stock}\n" }
  	report
  end
end