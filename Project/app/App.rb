require "sinatra"
require 'sinatra/flash'
require_relative "Authentication.rb"


#If there is no admin account, make one.
if User.all(admin: true).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.admin = true
  u.save
end