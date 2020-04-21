require "sinatra"
require "sinatra/namespace"
require "json"
require 'net/http'


set :port, 8000

# get '/home' do
#   halt 200, "honme"

# end

set :public_folder, 'views'

get "/" do
  
  erb :index

end


post '/register' do
  
  redirect "/home"
  response = Net::HTTP.post('localhost:4567', '/api/register#{dsadsa}#{}')
  response.body
  redirect "/"

end

get "/dashboard" do
  
	erb :dashboard
end

post '/home' do
  return kindadumb
	redirect "/home"
  end

get '/home' do
	erb :home
  end

post '/advising' do
	redirect "/advising"
  end

get '/advising' do
	erb :advising
  end

post '/future_courses' do
	redirect "/future_courses"
  end

get '/future_courses' do
	erb :future_courses
  end

post '/notifications' do
	redirect "/notifications"
  end

get '/notifications' do
	erb :notifications
  end

post '/user_profile' do
	redirect "/user_profile"
  end

get '/user_profile' do
	erb :user_profile
  end

get '/classes' do
	c = File.read("views/js/classes.json")
	#halt 200, c.to_json
	#puts JSON.pretty_generate(c)
	#erb :"songs/index", :locals => { :song_list => songs }
	#JSON.parse(c)
	erb :home, :locals =>{c => c.to_json }
end


post '/register' do
  redirect "/register"
end

get '/register' do
	erb :register
end