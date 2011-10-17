Factory.define :user do |user|
  user.name       "Jarek Plonski"
  user.email      "jarek@gmail.com"
end

Factory.sequence :email do |n|
  "person-#{n}@gmail.com"
end
Factory.sequence :name do |n|
  "Person #{n}"
end

Factory.define  :meeting do |meeting|
  meeting.starts_at     "2011-10-13 20:00:00 +0200"
  meeting.ends_at       "2011-10-13 21:00:00 +0200"
  meeting.title         "Evening meeting"
  meeting.description   "First meeting"
  meeting.place         "Test room"
  meeting.total_places  "5"
end