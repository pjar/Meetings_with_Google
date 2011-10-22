s = GCal4Ruby::Service.new
s.authenticate( GOOGLE_ACCOUNT, GOOGLE_ACCOUNT_PASSWORD )
cal = s.calendars.first
event = cal.events.first
event.update(:title=> "Dupka")
event.save

p event.title
