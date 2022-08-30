test:
	rspec

b:
	bundle install

seed:
	rails db:truncate_all db:setup