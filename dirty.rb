include ActiveModel::Dirty
m = Meeting.find(30)

arr = []

arr = Meeting.accessible_attributes.inject([]) do |res, val|
  res << val
  end

arr.each do |el|
  puts m[el].changed?
  end
  
