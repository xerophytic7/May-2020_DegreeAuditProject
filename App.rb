require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"


#If there is no admin account, make one.
if User.all(Admin: true).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.Admin = true
  u.save
end