require "sinatra"
require "sinatra/namespace"
require_relative "api_authentication.rb"
require "json"
require File.expand_path("../models/AllCourses.rb", __FILE__)
require File.expand_path("../models/User.rb", __FILE__)
require File.expand_path("../models/Categories.rb", __FILE__)
require File.expand_path("../models/CourseALT.rb", __FILE__)
require File.expand_path("../models/CourseCategories.rb", __FILE__)
require File.expand_path("../models/CoursePreREQ.rb", __FILE__)
require File.expand_path("../models/PlannedFutureCourses.rb", __FILE__)
require File.expand_path("../models/StudentCourses.rb", __FILE__)

#require_relative 'models/User.rb'
#require_relative 'models/Categories.rb'
#require_relative 'models/CourseALT.rb'
#require_relative 'models/CourseCategories.rb'
#require_relative 'models/CoursePreREQ.rb'
#require_relative 'models/PlannedFutureCourses.rb'
#require_relative 'models/StudentCourses.rb'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost//mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

DataMapper.finalize

User.auto_upgrade!
PlannedFutureCourses.auto_upgrade!
CourseALT.auto_upgrade!
CourseCategories.auto_upgrade!
CoursePreREQ.auto_upgrade!
StudentCourses.auto_upgrade!
AllCourses.auto_upgrade!
Categories.auto_upgrade!

=begin
#If there is no admin account, make one.
#************* TEST ******************
post '/createAdmin' do

  if User.all(admin: true).count == 0
    u = User.new
    u.id = 1337
    u.Email = "admin@admin.com"
    u.Password = "admin"
    u.admin = true
    u.save
    return u.to_json
    halt 200, {"message": "Admin account created"}.to_json
  else
  halt 422, {"message": "Admin account already exists"}.to_json
  end
end


# TEST # Create user with custom serial id
post '/customid' do
  username = params["username"]
  password = params["password"]
  fn = params["firstName"]
  ln = params["lastName"]
  id = params["id"]
  if username && password
    user = User.first(Email: username.downcase)
 
    if(user)
      halt 422, {"message": "Username already in use"}.to_json
    else
      if fn && ln && id
        u = User.new
        u.FirstName = fn
        u.LastName = ln
        u.Email = username.downcase
        u.Password = password
        u.id = id
        u.save
        halt 201, {"message": "Account successfully registered"}.to_json
      else
        message = "Missing First or Last Name or ID"
        halt 400, {"message": message}.to_json
      end
    end
  else
      message = "Missing username or password"
      halt 400, {"message": message}.to_json
  end
end
    
#test add 10 regular users if there's less than 3 users
get '/test' do
  api_authenticate!
  
  if User.count < 3
    
    i = 1
    last = 11
      
    while i < last do
      u = User.new
      u.id = i + 9999
      u.Email = "email#{i}@email.com"
      u.FirstName = "user#{i}"
      u.Password = "pw#{i}"
      u.save
      i += 1 
    end
      
    return "Created 10 users"
  end
  
  return "Current Users: #{User.count}"
    
end

#test delete all non admin users
delete '/allUsers' do
  u = User.all(admin: false)
  u.destroy

  if User.count == 1
    halt 200, {message: "All Users Successfully deleted"}.to_json
  else
    halt 400, {message: "Unable to delete all users"}.to_json
  end
end
  
#Test user authentication
get '/test_authentication' do
  api_authenticate!
  
  halt 200, {message: "User Authentication passed."}.to_json
end  
=end

#CHECKS IF GIVEN COURSEID CATALOG YEAR MATCHES GIVEN USERID CATALOG YEAR
#RETURNS TRUE IF MATCH, OR IF COURSE HAS NO CATALOG YEAR
#RETURNS FALSE IF COURSE IS PART OF DIFFERENT CATALOG YEAR
def same_catalog_year courseid, userid
  cats = CourseCategories.all(CourseID: courseid)
  if cats
    cats.each do |i|
    yrs << Categories.get(i.CategoryID)
    end
    if yrs
      u = User.get(userid)
      yrs.each do |i|
        u.CatalogYear == i.CatalogYear ? (return true) : next
      end
      return false
    end
  else
    return true
  end
end
#IN CASE WE NEED TO CHECK IF GIVEN SEMESTER IS VALID
semesters = ["fall", "spring", "summer i", "summer ii"]
def valid_semester semester
  semester.split
  if semester.length !=2
    return false
  end
  if semesters.count semester[0].downcase != 1
    return false
  end
  if semester[1].to_i < 1927 && semester[1].to_i > Time.new.year
    return false
  end
  return true
end

def is_number? string
  true if Integer(string) rescue false
end


############## CREATE ################

  # Create Courses given params CourseDept, CourseNum, Name, and Institution
  post '/add/Course' do
    api_authenticate!
    if !current_user.admin
      halt 401, {"message": "Unauthorized user"}.to_json
    end
    params["CourseDept"] ? (CourseDept = params["CourseDept"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)
    params["CourseNum"] ? (CourseNum = params["CourseNum"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)
    params["Name"] ? (name = params["Name"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)
    params["Institution"] ? (Institution = params["Institution"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)

    #*********** DUPLICATE CHECK ***************
    halt 409, {'message': 'Duplicate Entry'}.to_json if AllCourses.first(CourseDept: CourseDept, 
      CourseNum: CourseNum, Name: name, Institution: Institution)

    if !is_number?(CourseNum)
      halt 400, {'message': 'Course Number must be an integer'}.to_json
    end
    if CourseDept != '' && CourseNum != '' && name != '' && Institution != ''
      c = AllCourses.new
      c.CourseDept = CourseDept
      c.CourseNum = CourseNum
      c.Name = name
      c.Institution = Institution
      c.save

      halt 200, {"message": "Successfully added course to AllCourses Table"}.to_json
    else
      halt 400, {"message": "Paramaters can't be empty strings"}.to_json
    end

  end
  
  # Create Users Given Email, FirstName, LastName, Password, and admin (true/false).
  #******************ALREADY IMPLEMENTED IN api_authentication.rb******************
  

  
  # Create entry to StudentCourses using current UserID
  # (Depending on params given)
  post '/add/StudentCourses' do
    
    api_authenticate!
    userid = params['UserID']
    params["CourseID"] ? (courseid = params['CourseID']): (halt 400, {"message": "Missing CourseID paramater"}.to_json)
    params["Semester"] ? (semester = params['Semester']): (halt 400, {"message": "Missing Semester paramater"}.to_json)
    params["Grade"] ? (grade = params['Grade']): (halt 400, {"message": "Missing Grade paramater"}.to_json)
    notes = params['Notes']

    if !is_number?(courseid)
      halt 400, {'message': 'CourseID param not an integer'}.to_json
    end

    if courseid != '' && semester != '' && grade != ''
      if userid
        if current_user.admin

          #*************** DUPLICATE CHECK *************
          halt 409, {'message': 'Duplicate Entry'}.to_json if StudentCourses.first(UserID: userid, CourseID: courseid)
          #************************************************

          # I COULD CHECK IF COURSE CATALOG YEAR MATCHES USER CATALOG YEAR
          # i.f same_catalog_year(courseid, userid)    
          # BUT NOT SURE WHY WE'D NEED THIS CHECK HERE
          c = StudentCourses.new
          userid != '' ? (c.UserID = userid) : (halt 400, {"message": "Missing UserID paramater"}.to_json)
          c.CourseID = courseid
          c.Semester = semester
          c.Grade = grade
          if notes != nil
            c.Notes = notes 
          end
          c.save
          halt 201, {"message": "Course added successfully"}.to_json
        else
          halt 401, {"message": "Unauthorized user"}.to_json
        end
      else
         #*************** DUPLICATE CHECK *************
         halt 409, {'message': 'Duplicate Entry'}.to_json if StudentCourses.first(UserID: current_user.id, CourseID: courseid)
         #************************************************

        # I COULD CHECK IF COURSE CATALOG YEAR MATCHES USER CATALOG YEAR
        # i.f same_catalog_year(courseid, current_user.id)
        # BUT NOT SURE WHY WE'D NEED THIS CHECK HERE
        c = StudentCourses.new
        c.UserID = current_user.id
        c.CourseID = courseid
        c.Semester = semester
        c.Grade = grade
        if notes != nil
          c.Notes = notes
        end
        c.save
        halt 201, {"message": "Course added successfully"}.to_json
      end
    else
      halt 400, {"message": "CourseID, Semester, or Grade paramaters can't be empty strings"}.to_json
    end
  end
  
  # Create entries to PlannedFutureCourses given JSON list of courses, 
  # list of courses should have CourseID and Semester. 
  post '/add/PlannedCourses' do
    api_authenticate!
    params.each do |i|
      halt 400, {"message": "Missing paramaters, or possible typo."}.to_json if !i[0]['Courses']
    end
    plannedCourses = params[:Courses]
    x = 1
    plannedCourses.each do |i|
      if !i[1]["courseID"] || !i[1]["semester"]
        halt 400, {"message": "Missing paramaters, or possible typo"}.to_json
      end
      if !AllCourses.get(i[1]["courseID"])
        halt 404, {'message': "Course number #{x} on your list was not found, no courses were added to planned courses"}.to_json
      end
      # DUPLICATE ENTRY CHECK
      if PlannedFutureCourses.first(UserID: current_user.id, CourseID: i[1]["courseID"], Semester: i[1]["semester"])
        halt 409, {'message': 'Duplicate Entry'}.to_json
      end

      if is_number?(i[1]["courseID"]) && i[1]["semester"] != ''
        # i.f valid_semester(i[1]['semester'])    Checks semester matches spring, fall, summer i, or summer ii
        x = x + 1
        next
      else
        halt 400, {"message": "CourseID has to be integer, and neither paramater can be an empty string"}.to_json
      end

      #counter update
      x = x + 1 
    end
    plannedCourses.each do |i|
      #puts i[1]["courseID"]    #puts i[1]["semester"]
      p = PlannedFutureCourses.new
      p.UserID = current_user.id
      p.CourseID = i[1]["courseID"]
      p.Semester = i[1]["semester"]
      p.save
    end
      halt 201, {"message": "Courses added to Planned courses successfully"}.to_json
   
  end
  
  # Create a Category Given CategoryNum, Name, CatalogYear, and ReqHours
  post '/add/Category' do
    api_authenticate!
    if current_user.admin
      params['CategoryNum'] ? (catnum = params['CategoryNum']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['Name'] ? (catname = params['Name']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['CatalogYear'] ? (catyr = params['CatalogYear']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['ReqHours'] ? (reqhrs = params['ReqHours']) : (halt 400, {"message": "Missing paramaters"}.to_json)

      if !is_number?(reqhrs) || !is_number?(catyr) || !is_number?(catnum)
        halt 400, {"message": "ReqHours, CatalogYear, and CategoryNum paramaters have to be integers"}.to_json
      end
      
      if catnum != '' && catname != '' && reqhrs !='' && catyr != ''
        category = Categories.new
        category.CategoryNum = catnum
        category.CategoryName = catname
        category.CatalogYear = catyr
        category.ReqHours = reqhrs
        category.save

        halt 201, {'message': 'Category created successfully'}.to_json
      else
        halt 400, {"message": "Paramaters can't be empty strings"}.to_json
      end
    else
      halt 401, {"message": "Unauthorized user"}.to_json
    end
  end
  
  # Assign a given CourseID and CategoryID to CourseCategories Table
  post '/assign/Category' do
    api_authenticate!
    if current_user.admin
      params['CourseID'] ? (courseid = params['CourseID']) : (halt 400, {'message': 'Missing paramaters'}.to_json)
      params['CategoryID'] ? (catid = params['CategoryID']) : (halt 400, {'message': 'Missing paramaters'}.to_json)

      if !is_number?(courseid) || !is_number?(catid)
        halt 400, {"message": "Paramaters need to be integers"}.to_json
      end

      if !AllCourse.get(courseid)
        halt 400, {"message": "CourseID not found in AllCourses Table"}.to_json
      end
      if !Categories.get(catid)
        halt 400, {"message": "CategoryID not found in Categories Table"}.to_json
      end
      if courseid != '' && catid != ''
        if CourseCategories.first(CourseID: courseid, CategoryID: catid)
          halt 409, {'message': 'Duplicate Entry'}.to_json
        end
        cc = CourseCategories.new
        cc.CourseID = courseid
        cc.CategoryID = catid
        cc.save

        halt 201, {'message': 'Course assigned a category successfully'}.to_json
      else
        halt 400, {'message': 'Missing paramaters'}.to_json
      end
    else
      halt 401, {"message": "Unauthorized user"}.to_json
    end
  end
  
  # Create Course prerequisites Given a CourseID and PreReqID
  post '/add/prereq' do
    api_authenticate!
    if current_user.admin
      params['CourseID'] ? (courseid = params['CourseID']) : (halt 400, {'message': 'Missing paramaters'}.to_json)
      params['PreReqID'] ? (prereqid = params['PreReqID']) : (halt 400, {'message': 'Missing paramaters'}.to_json)

      if !AllCourses.get(courseid)
        halt 400, {"message": "CourseID not found in AllCourses Table"}.to_json
      end
      if !AllCourses.get(prereqid)
        halt 400, {"message": "PreReqID not found in AllCourses Table"}.to_json
      end

      if courseid != '' && prereqid != '' && courseid != prereqid
        #***********      DUPLICATE ENTRY CHECK        *********************
        halt 409, {'message': 'Duplicate entry'}.to_json if CoursePreREQ.first(CourseID: courseid, PreReqID: prereqid)
        
        cp = CoursePreREQ.new
        cp.CourseID = courseid
        cp.PreReqID = prereqid
        cp.save

        halt 201, {'message': 'Course matched with prerequisite successfully'}.to_json
      else
        halt 400, {'message': 'Missing paramaters or parameters are both identical'}.to_json
      end
    else
      halt 401, {"message": "Unauthorized user"}.to_json
    end
  end
  
  # Create Course alternatives Given a CourseID and AltID
  # **************************IGNORE FOR NOW, AS PER FIGUEROA******************************
  
  
  # Takes in json list of all categories for a catalog year. Creates new degree plan 
  # (Mainly add to Categories Table: CategoryNum, CategoryName, CatalogYear, and ReqHours. 
  post '/create/degreePlan' do
    api_authenticate!
    if current_user.admin
      params.each do |i|
        halt 400, {'message': 'Missing Categories paramater or possible typo'}.to_json if !i[0]['Categories']
      end
      cats = params[:Categories]
      
      cats.each do |i|
        if !i[1]['CategoryNum'] || !i[1]['CategoryName'] || !i[1]['CatalogYear'] || !i[1]['ReqHours']
          halt 400, {'message': 'Missing paramaters, or possible typo'}.to_json
        end
        if !is_number?(i[1]['ReqHours'])
          halt 400, {'message': 'ReqHours has to be an integer'}.to_json
        end
        if i[1]['CategoryNum'] == '' || i[1]['CategoryName'] == '' || i[1]['ReqHours'] == ''
          halt 400, {'message': 'Paramaters can\'t be empty strings'}.to_json
        end
        #***********      DUPLICATE ENTRY CHECK        *********************
        if categories.first(CategoryNum: i[1]['CategoryNum'], CategoryName: i[1]['CategoryName'], CatalogYear: i[1]['CatalogYear'])
          halt 409, {'message': 'Duplicate entry'}.to_json 
        end
        
      end
      cats.each do |i|
        c = Categories.new
        c.CategoryNum = i[1]['CategoryNum']
        c.CategoryName = i[1]['CategoryName']
        c.CatalogYear = i[1]['CatalogYear']
        c.ReqHours = i[1]['ReqHours']
        c.save

      end

      halt 201, {'message': 'Catalog year with categories created'}.to_json
    else
      halt 401, {"message": "Unauthorized user"}.to_json
    end
  end
  # Matching json List of CourseIDs to a CatagoryID
  # with a CourseID and adding that to CourseCategories table.)
  
  
  ############## READ ##################
  
  # Read current users FirstName, LastName, Email, GPA, CatalogYear, 
  # Classification, Hours, AdvancedHours, & Advanced_CS_Hours from User Table
  get '/MyInfo' do
    api_authenticate!

    halt 200, {
      "FirstName"       => "#{current_user.FirstName}",
      "LastName"        => "#{current_user.LastName}",
      "Email"           => "#{current_user.Email}",
      "GPA"             => "#{current_user.GPA}",
      "CatalogYear"     => "#{current_user.CatalogYear}",
      "Classification"  => "#{current_user.Classification}",
      "Hours"           => "#{current_user.Hours}",
      "AdvancedCsHours" => "#{current_user.Advanced_CS_Hours}",
      "AdvancedHours"   => "#{current_user.AdvancedHours}",
    }.to_json
    
    list = [current_user.FirstName, current_user.LastName, current_user.Email,
      current_user.GPA, current_user.CatalogYear, current_user.Classification,
    current_user.Hours, current_user.AdvancedHours, current_user.Advanced_CS_Hours]
    
    return list.to_json
  end
  
  
  # Given an email (or student ID if we add that), Read a users FirstName, 
  # LastName, Email, GPA, CatalogYear, Classification, Hours, AdvancedHours,
  # & Advanced_CS_Hours from User Table
  # Also read their taken courses, their planned future courses
  get '/user' do
    api_authenticate!

    if current_user.admin
      email = params['Email'].downcase if params['Email']
      userid = params['StudentID'] if params['StudentID']

      if userid

        u = User.first(userid)
        uc = StudentCourses.all(UserID: userid)
        pfc = PlannedFutureCourses.all(UserID: userid)
        if u
          list = [u.id, u.FirstName, u.LastName, u.Email,
            u.GPA, u.CatalogYear, u.Classification,
          u.Hours, u.AdvancedHours, u.Advanced_CS_Hours, uc, pfc]

          return list.to_json
        else
          halt 400, {'message': 'User not found'}.to_json
        end
      elsif email
        puts "Got to email"
        u = User.first(Email: email)
        uc = StudentCourses.all(UserID: u.id)
        pfc = PlannedFutureCourses.all(UserID: u.id)
        
        if u
          list = [u.id, u.FirstName, u.LastName, u.Email,
            u.GPA, u.CatalogYear, u.Classification,
          u.Hours, u.AdvancedHours, u.Advanced_CS_Hours, uc, pfc]

          return list.to_json
        else
          halt 400, {'message': 'User not found'}.to_json
        end
      else
        halt 400, {'message': 'Missing paramaters'}.to_json
      end

    else
      halt 401, {"message": "Unauthorized user"}.to_json
    end
  end
  
  
  # Read current users courses from StudentCourses table.
  # Maybe calculate user GPA, Classification, Hours, AdvancedHours,
  # and Advanced_CS_Hours while we're at it.
  
  
  # Read a students PlannedFutureCourses given an Email or student ID and semester(s)
  get '/usersPlannedCourses' do
    api_authenticate!
    email = params['Email'] if params['Email']
    userid = params['StudentID'] if params['StudentID']
    params['semester'] ? (semester = params['semester']) : (halt 400, {'message': 'Missing paramaters'}.to_json)

    if userid
      u = PlannedFutureCourses.first(userid) 
      
      if u
        list = [u.FirstName, u.LastName, u.Email,
          u.GPA, u.CatalogYear, u.Classification,
        u.Hours, u.AdvancedHours, u.Advanced_CS_Hours]

        return list.to_json
      else
        halt 400, {'message': 'User not found'}.to_json
      end

    elsif email
      u = User.first(Email: email)
      if u
        list = [u.FirstName, u.LastName, u.Email,
          u.GPA, u.CatalogYear, u.Classification,
        u.Hours, u.AdvancedHours, u.Advanced_CS_Hours]
      
      else
        halt 400, {'message': 'User not found'}.to_json
      end
    else
      halt 400, {'message': 'Missing paramaters'}.to_json
    end
  end
  
  
  # Read from PlannedFutureCourses table given a semester  
  get '/PlannedCourses' do
    api_authenticate!
    params['semester'] ? (semester = params['semester']) : (halt 400, {'message': 'Missing paramaters'}.to_json)
    if current_user.admin
      pfc = PlannedFutureCourses.all(Semester: semester)
      return pfc.to_json
    else
      halt 401, {'message': 'Unauthorized User'}.to_json
    end
  end
  
  # Read ALL PlannedFutureCourses 
  # (Return Summer I, II, and Fall if in spring semester. 
  # Return Summer II, and Fall if in Summer I semester. 
  # Return Fall if in Summer II semester.
  # Return Spring if in Fall semester.)
  
  
  
  # Read all courses from AllCourses Table
  get '/all/Courses' do
    api_authenticate!
    
    if current_user.admin
      return AllCourses.all.to_json
    else
      halt 400, {'message': "Unauthorized User"}.to_json
    end
  end
  
  
  # Read course pre requisites given a CourseID


  # Read all entries in CoursePreREQ table
  get '/all/PreReqTable' do
    api_authenticate!
  #  cp = CoursePreREQ.all
  #  cp.destroy
  #  cp.save
    return CoursePreREQ.all.to_json
  end
  
  
  # Read Courses requiring approval, and their notes
  
  
  # Read existing catalog years
  #(Possibly need new table to list catalog years quicker, for drop down menus)
  

  #TEST READ ALL USERS
  get '/all/Users' do
    api_authenticate!
    if current_user.admin
      return User.all.to_json
    else
      halt 400, {'message': 'Unauthorized User'}.to_json
    end

  end
  
  ############## UPDATE ################
  
  # Update all User attributes from User Table, except UserID (Use params passed)
  
  
  # Update a users course in StudentCourses table
  
  
  # Update
  
  
  # Update
  
  
  
  ############## DESTROY ###############



  ###MMARIO######
  get '/isAdmin' do
    api_authenticate!  
    halt 200, {"admin" => "#{current_user.admin}",
                "mode" => "#{current_user.mode}"}.to_json

  end
  ####