hash = Meeting.places.inject({}) do | result, array_value |
	key_from_array_value = array_value.downcase.gsub(/\s+/, "_").to_sym
	if result.has_key?( key_from_array_value )
	  result[ key_from_array_value ] += 1 
	else
	  result[ key_from_array_value ] = 1
	end
	result
end

puts hash


hash.sort.inject([]) do |result, element| result << element.first.to_s
  
