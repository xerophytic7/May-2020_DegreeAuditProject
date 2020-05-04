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


# set :bind , '192.168.0.117'

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
  
  # Create a Category Given MainCategory, CategoryNum, Name, CatalogYear, ReqHours, and AdvHours(0 if none required)
  post '/add/Category' do
    api_authenticate!
    if current_user.admin
      params['MainCategory'] ? (maincat = params['MainCategory']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['CategoryNum'] ? (catnum = params['CategoryNum']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['Name'] ? (catname = params['Name']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['CatalogYear'] ? (catyr = params['CatalogYear']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['ReqHours'] ? (reqhrs = params['ReqHours']) : (halt 400, {"message": "Missing paramaters"}.to_json)
      params['AdvHours'] ? (advhrs = params['AdvHours']) : (halt 400, {"message": "Missing paramaters"}.to_json)

      if !is_number?(reqhrs) || !is_number?(advhrs)
        halt 400, {"message": "ReqHours and AdvHours paramaters have to be integers"}.to_json
      end
      
      if maincat != '' && catnum != '' && catname != '' && reqhrs !='' && catyr != '' && advhrs != ''
        category = Categories.new
        category.MainCategory = maincat
        category.CategoryNum = catnum
        category.CategoryName = catname
        category.CatalogYear = catyr
        category.ReqHours = reqhrs
        category.AdvHours = advhrs
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

      if !AllCourses.get(courseid)
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
  # (Mainly add to Categories Table: MainCategory, CategoryNum, CategoryName, CatalogYear, ReqHours and AdvHours. 
  post '/create/degreePlan' do
    api_authenticate!
    if current_user.admin
      params.each do |i|
        halt 400, {'message': 'Missing Categories paramater or possible typo'}.to_json if !i[0]['Categories']
      end
      cats = params[:Categories]
      
      cats.each do |i|
        if !i[1]['MainCategory'] || !i[1]['CategoryNum'] || !i[1]['CategoryName'] || 
          !i[1]['CatalogYear'] || !i[1]['ReqHours'] || !i[1]['AdvHours']

          halt 400, {'message': 'Missing paramaters, or possible typo'}.to_json
        end
        if !is_number?(i[1]['ReqHours']) || !is_number?(i[1]['AdvHours'])
          halt 400, {'message': 'ReqHours and AdvHours have to be integers'}.to_json
        end
        if i[1]['MainCategory'] == '' || i[1]['CategoryNum'] == '' || i[1]['CategoryName'] == '' || i[1]['ReqHours'] == ''
          halt 400, {'message': 'Paramaters can\'t be empty strings'}.to_json
        end
        #***********      DUPLICATE ENTRY CHECK        *********************
        if Categories.first(MainCategory: i[1]['MainCategory'], CategoryNum: i[1]['CategoryNum'], 
          CategoryName: i[1]['CategoryName'], CatalogYear: i[1]['CatalogYear'])
          halt 409, {'message': 'Duplicate entry'}.to_json 
        end
        
      end
      cats.each do |i|
        c = Categories.new
        c.MainCategory = i[1]['MainCategory']
        c.CategoryNum = i[1]['CategoryNum']
        c.CategoryName = i[1]['CategoryName']
        c.CatalogYear = i[1]['CatalogYear']
        c.ReqHours = i[1]['ReqHours']
        c.AdvHours =i[1]['AdvHours']
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
    
   # list = [current_user.FirstName, current_user.LastName, current_user.Email,
   #   current_user.GPA, current_user.CatalogYear, current_user.Classification,
   # current_user.Hours, current_user.AdvancedHours, current_user.Advanced_CS_Hours]
    
    halt 200, {
      'FirstName'       => current_user.FirstName,
      'LastName'        => current_user.LastName,
      'Email'           => current_user.Email,
      'GPA'             => current_user.GPA,
      'CatalogYear'     => current_user.CatalogYear,
      'Classification'  => current_user.Classification,
      'Hours'           => current_user.Hours,
      'AdvancedCsHours' => current_user.Advanced_CS_Hours,
      'AdvancedHours'   => current_user.AdvancedHours
    }.to_json
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
  
  
    # Returns current users courses from StudentCourses
    get '/myCourses' do
      api_authenticate!
  
      courses = StudentCourses.all(UserID: current_user.id)
      table = Array.new {Hash.new}
      courses.each do |i|
        
        #We already have the CourseID, but this Will also get the dept, num, and name
        course = AllCourses.first(CourseID: i.CourseID)
  
        if course
          table << {
            'CourseID'    => course.CourseID,
            'CourseDept'  => course.CourseDept,
            'CourseNum'   => course.CourseNum,
            'Name'        => course.Name,
            'Semester'    => i.Semester,
            'Grade'       => i.Grade,
            'Institution' => course.Institution,
          }
        end
      end
      halt 200, table.to_json if table.size != 0
      halt 400, {'message': 'User has no courses'}.to_json
    end



  # Read current users courses (AND the category the course falls in) from StudentCourses and Categories table.
  # Essentially, returns current_user.CatalogYear, {CourseDept, CourseNum, Name} from AllCourses
  # AND {MainCategory, CategoryNum, CategoryName} from Categories
  # Will calculate user GPA, Classification, Hours, AdvancedHours, and adv_cs_hours
  get '/myDegreeProgress' do
    api_authenticate!
    #use current_user.id for current users id

    #Get all courses: courses = StudentCourses.all(UserID: current_user.id)
    courses = StudentCourses.all(UserID: current_user.id)
    #Create a table to return each course with their category info.
    table = Array.new {Hash.new}
    #Search, in a loop, for each course in AllCourses, Cross reference with
    #CourseCategories to get CategoryID(s): catIDs = CourseCategories.all(CourseID: CourseID)
    #Search, in a loop, Categories.first(CategoryID: )
    courses.each do |i|
      puts i.UserID
      puts i.CourseID
      #We already have the CourseID, but this Will also get the dept, num, and name
      course = AllCourses.first(CourseID: i.CourseID)
      puts course.Name
      #Get all the categories course may belong to
      if course
        catIDs = CourseCategories.all(CourseID: course.CourseID)
        #loop through catIDs, get cat = Categories.first(CategoryID: catIDs.CategoryID)
        #Then check i.f cat.CatalogYear == current_user.CatalogYear. If it is, store
        #MainCategory, CategoryNum, and CategoryName
        catIDs.each do |j|
          cat = Categories.first(CategoryID: j.CategoryID)
          puts cat.CategoryName
          puts cat.CatalogYear
          puts current_user.CatalogYear
          if cat.CatalogYear == current_user.CatalogYear
            table << {
            'CatalogYear'   => current_user.CatalogYear,
            'CourseDept'    => course.CourseDept,
            'CourseNum'     => course.CourseNum,
            'Name'          => course.Name,
            'MainCategory'  => cat.MainCategory,
            'CategoryNum'   => cat.CategoryNum,
            'CategoryName'  => cat.CategoryName}
            ###############################################################################################  
            ################FINISH CALCULATING GPA, CLASSIFICATION, HRS, ADVHRS, ADV CS HRS################
            ###############################################################################################
          else
            table << {
              'CatalogYear'   => 'mismatch',
              'CourseDept'    => course.CourseDept,
              'CourseNum'     => course.CourseNum,
              'Name'          => course.Name,
              'MainCategory'  => cat.MainCategory,
              'CategoryNum'   => cat.CategoryNum,
              'CategoryName'  => cat.CategoryName}
          
          end
        end
      end
    end
    if table.size != 0
      halt 200, table.to_json
    else
      halt 400, {'message': 'User has no courses'}.to_json
    end
  end

  
  # Read a students PlannedFutureCourses given an Email or student ID and semester(s)
  get '/usersPlannedCourses' do
    api_authenticate!
    email = params['Email'] if params['Email']
    userid = params['StudentID'] if params['StudentID']
    params['semester'] ? (semester = params['semester']) : (halt 400, {'message': 'Missing paramaters'}.to_json)

    if userid
      u = PlannedFutureCourses.all(UserID: userid, Semester: semester) 
      u ? (halt 200, u.to_json) : (halt 400, {'message': 'User has no planned courses for selected semester'}.to_json)

    elsif email
      u = User.first(Email: email)
      if u
        list = PlannedFutureCourses.all(UserID: u.id, Semester: semester)
        list ? (halt 200, list.to_json) : (halt 400, {'message': 'User has no planned courses for selected semester'}.to_json)
      
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
      halt 200, pfc.to_json
      
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
    halt 200, AllCourses.all.to_json
    
  end
  
  
  # Read course pre requisites given a CourseID.
  # Returns CoursePreREQ entries that match given CourseID and all it's PreReqs 
  get '/course/preReq' do
    api_authenticate!
    params['CourseID'] ? (cid = params['CourseID']) : (halt 400, {'message': 'Missing Paramater'}.to_json)
    
    preReqs = CoursePreREQ.all(CourseID: cid)

    halt 200, preReqs.to_json if preReqs != []
    
    halt 400, {'message': 'No courses found'}.to_json
    
  end

  # Read a courses info, given its CourseID
  get '/course' do
    api_authenticate!
    params['CourseID'] ? (cid = params['CourseID']) : (halt 400, {'message': 'Missing Paramater'}.to_json)

    course = AllCourses.first(CourseID: cid)
    halt 200, course.to_json if course

    halt 400, {'message': 'Course not found'}.to_json
  end


  # Read all entries in CoursePreREQ table
  get '/all/PreReqTable' do
    api_authenticate!
  #  cp = CoursePreREQ.all
  #  cp.destroy
  #  cp.save
    halt 200, CoursePreREQ.all.to_json
    
  end
  
  
  # Read StudentCourses requiring approval, and their notes
  get '/notApproved/andNotes' do
    api_authenticate!
    if current_user.admin 
      sc = StudentCourses.all(Approved: false)
      halt 200, sc.to_json if sc != []
      halt 400, {'message': 'No Courses need approval'}.to_json
    else
      halt 401, {'message': 'Unauthorized User'}.to_json
    end
  end
  
  
  # Read existing catalog years
  #(Possibly need new table to list catalog years quicker, for drop down menus)
  

  #TEST READ ALL USERS
  get '/all/Users' do
    api_authenticate!
    if current_user.admin
      halt 200, User.all.to_json
    else
      halt 400, {'message': 'Unauthorized User'}.to_json
    end

  end
  ######################################################### HUGOO #######################################################################
  ############## UPDATE ################
  post '/update/user_info' do #checked
    
    api_authenticate!

    email = params['Email']
    firstName = params['FirstName']
    lastName = params['LastName']
    password = params['Password']
  
   u = User.first(id: current_user.id)
   if u
       if email != nil || firstName != nil || lastName != nil 

      	if email != nil
        	 u.update(Email: email)
       	end
       	if firstName != nil
       	  u.update(FirstName: firstName)
       	end
      	if lastName != nil
       	  u.update(LastName: lastName)
       	end
        	 halt 200, {"message": "Updated Successfully"}.to_json
      elsif password != nil
          u.update(Password: password)
       	  halt 200, {"message": "Updated Successfully"}.to_json
      else
           halt 400, {"message": "Missing Paramaters"}.to_json
      end
   else
      halt 404, {"message": "User Not Found"}.to_json
   end
  end

  

  # Update a users course in StudenCourses table
  post '/update/Student_Courses' do #checked
      api_authenticate!
    #CourseID is a must, if not flag
    params['CourseID'] ? courseID = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
    #retrieve parameters to be altered 
     semester = params['Semester'] 
     grade = params['Grade'] 
     notes = params['Notes'] 
    # retrieve the current user's course
    target = StudentCourses.first(UserID: current_user.id, CourseID: courseID)
    if target
      if semester != nil || grade != nil || notes != nil
        if semester != nil
         target.update(Semester: semester) 
        end
        if grade != nil
          target.update(Grade: grade)
        end
        if notes != nil
        	target.update(Notes: notes)
        end

        halt 200, {"message": "Course Updated Successfully"}.to_json
      else 
          halt 400, {"message": "Missing Parameters"}.to_json
      end
   else
      halt 404, {"message": "Object Not Found"}.to_json
   end

  end

  #Just allows to change semester to which they plan to take the course.
  post '/update/PlannedFutureCourses' do
      api_authenticate!
      #CourseID is a must, if not flag
      params['CourseID'] ? courseID = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
      semester = params['Semester']
      
      #retrieve course
      target = PlannedFutureCourses.first(UserID: current_user.id, CourseID: courseID)
      if target
         if semester != nil
          target.update(Semester: semester)
          halt 200, {"message": "Course Updated Successfully"}
         else
          halt 400, {"message": "Missing Parameters"}.to_json
         end
      else
         halt 404, {"message": "Object Not Found"}.to_json
      end
   end
  ############## ADMIN UPDATERS ###########
   post '/update/AllCourses' do #checked
      api_authenticate!
      if current_user.admin
         params['CourseID'] ? courseID = params['CourseID'] : (halt 400, {"message": "Missing Parameters"}.to_json)
         courseDept = params['CourseDept']
         courseNum = params['CourseNum']  
         name_ = params['Name'] 

         target = AllCourses.first(CourseID: courseID)

         #target = nil
         if target

            if courseDept != nil || courseNum != nil || name_ != nil
               if courseDept != nil
                target.update(CourseDept: courseDept)
               end
               if courseNum != nil
                target.update(CourseNum: courseNum)
               end
               if name_ != nil
                target.update(Name: name_)
               end
                
               halt 200, {"message": "Course Updated Successfully"}.to_json
            else
             halt 400, {"message": "Missing Parameters"}.to_json
            end
         else
            halt 404, {"message": "Object Not Found"}.to_json
         end
      else
         halt 401, {"message": "Unauthorized User"}.to_json
      end
   end
   post '/update/Categories' do #checked
      api_authenticate!
      if current_user.admin
         params['CategoryID'] ? categoryID = params["CategoryID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
         maincat = params['MainCategory']
         num = params['CategoryNum'] 
         name = params['CategoryName']
         year = params['CatalogYear'] 
         hours = params['ReqHours'] 
         advhours = params['AdvHours']
         target = Categories.first(CategoryID: categoryID)
         if target 
            if num != nil || name != nil || year != nil || hours != nil || maincat != nil || advhours != nil
               if num != nil
                  target.update(CategoryNum: num)
               end
               if name != nil
                  target.update(CategoryName: name)
               end
               if year != nil
                  target.update(CatalogYear: year)
               end
               if hours != nil
                  target.update(ReqHours: hours)
               end
               if maincat != nil
               	target.update(MainCategory: maincat)
               end
               if advhours != nil
               	target.update(AdvHours: advhours)
               end
                return target.to_json 
               halt 200, {"message": "Category Updated Successfully"}.to_json
            else
              halt 400, {"message": "Missing Parameters"}.to_json 
            end
         else
             halt 404, {"message": "Object Not Found"}.to_json
         end
      else
         halt 401, {"message": "Unauthorized User"}.to_json
      end
   end
post '/update/recategorizeCourse' do #checked
	api_authenticate!
	params['CourseID'] ? courseID = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
	params['CategoryID'] ? categoryID = params["CategoryID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
	target = CourseCategories.first(CourseID: courseID)
	if target
		if current_user.admin
			if Categories.first(CategoryID: categoryID)
				if categoryID != nil
					target.update(CategoryID: categoryID)
				end
				halt 200, {"message": "Category Updated Successfully"}.to_json
			else
				halt 404, {"message": "New Category does not exist in table"}.to_json
			end
		else
			 halt 401, {"message": "Unauthorized User"}.to_json
		end
	else 
		halt 404, {"message": "Object Not Found"}.to_json
	end
end


  ############## DESTROY ###############
  post "/remove/StudentCourse" do
  	api_authenticate!
  	params["CourseID"] ? id = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)

  	 target = StudentCourses.first(UserID: current_user.id, CourseID: id)
    if target
      target.destroy
      halt 200, {"message": "Deleted Successfully"}.to_json
    else
      halt 404, {"message": "Object Not Found"}.to_json
    end
   end

  post "/remove/planned_course" do
    api_authenticate!
    params["CourseID"] ? id = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
   # Query for the course
    target = PlannedFutureCourses.first(UserID: current_user.id, CourseID: id)
    if target
      target.destroy
      halt 200, {"message": "Deleted Successfully"}.to_json
    else
      halt 404, {"message": "Object Not Found"}.to_json
    end
   end

   post '/remove/StudentCourse' do
      api_authenticate!
      params["CourseID"] ? id = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)

      target = StudentCourses.first(UserID: current_user.id, CourseID: id)
      if target
         target.destroy
         halt 200, {"message": "Deleted Successfully"}.to_json
      else
         halt 404, {"message": "Object Not Found"}.to_json
    end
   end
   ################## ADMIN DESTROY #############

  post '/remove/student' do
    api_authenticate!
    if current_user.admin
        params["id"] ? id = params["id"] : (halt 400, {"message": "Missing Parameters"}.to_json)
        u = User.get(id)
        if u
            u.destroy
            halt 200, {"message": "Deleted Successfully"}.to_json
        else
         halt 404, {"message": "Object Not Found"}.to_json
        end
   else
        halt 401, {"message": "Unauthorized user"}.to_json
   end
  end

  post '/remove/CoursePreREQ' do #checked
   api_authenticate!
   if current_user.admin
      params["CourseID"] ? id = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
      params["PreReqID"] ? preID = params["PreReqID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
      target = CoursePreREQ.first(CourseID: id, PreReqID: preID)
      if target
         target.destroy
         halt 200, {"message": "Deleted Successfully"}.to_json
      else
         halt 404, {"message": "Object Not Found"}.to_json
      end         

   else
      halt 401, {"message": "Unauthorized user"}.to_json
   end
  end

  post '/remove/Course' do #checked
   api_authenticate!
   if current_user.admin
      params["CourseID"] ? id = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
      target = AllCourses.first(CourseID: id)
      if target
         #target.destroy
         halt 200, {"message": "Deleted Successfully"}.to_json
      else
         halt 404, {"message": "Object Not Found"}.to_json
      end
   else
      halt 401, {"message": "Unauthorized user"}.to_json
   end
  end

  post '/remove/CourseFromCategory' do #checked
   api_authenticate!
   if current_user.admin
      params["CourseID"] ? id = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
      params['CategoryID'] ? categoryID = params["CategoryID"] : (halt 400, {"message": "Missing Parameters"}.to_json)
      target = CourseCategories.first(CourseID: id, CategoryID: categoryID)
      if target
         #target.destroy
         halt 200, {"message": "Deleted Successfully"}.to_json
      else
         halt 404, {"message": "Object Not Found"}.to_json
      end
   else
      halt 401, {"message": "Unauthorized user"}.to_json
   end
 end


###MMARIO######
 get '/isAdmin' do
  api_authenticate!
  halt 200, {"message" => "true"}.to_json if current_user.admin
  halt 401, {"message" => "false"}.to_json
  # halt 200, {"admin" => "#{current_user.admin}",
  #             "mode" => "#{current_user.mode}"}.to_json

end
####

#########################################################################################################################################
###MMARIO######
# get '/isAdmin' do
#   api_authenticate!  
#   halt 200, {"admin" => "#{current_user.admin}",
#               "mode" => "#{current_user.mode}"}.to_json

# end
####

#GEt User INformation
  get '/userInfo' do
    api_authenticate!

    if current_user.admin
      email = params['Email'].downcase if params['Email']
      userid = params['StudentID'] if params['StudentID']

      if userid

        u = User.first(userid)
        uc = StudentCourses.all(UserID: userid)
        pfc = PlannedFutureCourses.all(UserID: userid)
        if u
          halt 200,{
            'FirstName'       => u.FirstName,
            'LastName'        => u.LastName,
            'Email'           => u.Email,
            'GPA'             => u.GPA,
            'CatalogYear'     => u.CatalogYear,
            'Classification'  => u.Classification,
            'Hours'           => u.Hours,
            'AdvancedCsHours' => u.Advanced_CS_Hours,
            'AdvancedHours'   => u.AdvancedHours
          }.to_json

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
          halt 200,{
            'FirstName'       => u.FirstName,
            'LastName'        => u.LastName,
            'Email'           => u.Email,
            'GPA'             => u.GPA,
            'CatalogYear'     => u.CatalogYear,
            'Classification'  => u.Classification,
            'Hours'           => u.Hours,
            'AdvancedCsHours' => u.Advanced_CS_Hours,
            'AdvancedHours'   => u.AdvancedHours
          }.to_json

         # return list.to_json
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

  get '/usersPlannedCoursesW/oSemester' do
    api_authenticate!
    email = params['Email'] if params['Email']
    userid = params['StudentID'] if params['StudentID']
    #params['semester'] ? (semester = params['semester']) : (halt 400, {'message': 'Missing paramaters'}.to_json)

    if userid
      u = PlannedFutureCourses.all(UserID: userid)
      u.size > 0 ? (halt 200, u.to_json) : (halt 400, {'message': 'User has no planned courses for selected semester'}.to_json)

    elsif email
      u = User.first(Email: email)
      ac = AllCourses.all
      results = Array.new {Hash.new}

      ac.each do |i|
        pnf = PlannedFutureCourses.first(UserID: u.id, CourseID: i.CourseID)
        if pnf
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'PlannedCoarse' => 'pc',
          }
        # else
        #   results << {
        #     'CourseID'      => i.CourseID,
        #     'CourseDept'    => i.CourseDept,
        #     'CourseNum'     => i.CourseNum,
        #     'Name'          => i.Name,
        #     'PlannedCourse' => 'n',
        #   }
        # end
      end
    end
      halt 200, results.to_json
      if u
        list = PlannedFutureCourses.all(UserID: u.id)
        list.size > 0 ? (halt 200, list.to_json) : (halt 400, {'message': 'User has no planned courses for selected semester'}.to_json)
      
      else
        halt 400, {'message': 'User not found'}.to_json
      end
    else
      halt 400, {'message': 'Missing paramaters'}.to_json
    end
  end

  ### Function I need
  get '/myPlannedCoursesW/oSemester' do
    api_authenticate!

     # u = User.first(id: current_user.id)
      ac = AllCourses.all
      results = Array.new {Hash.new}

      ac.each do |i|
        pnf = PlannedFutureCourses.first(UserID: current_user.id, CourseID: i.CourseID)
        if pnf
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'PlannedCoarse' => 'pc',
          }
        end
      end
      halt 200, results.to_json
  end




        # MERGE myCourses with AllCourses, remove ones with grades. Admin and student usable.
  # params: StudentID or Email will be for admin
  # no params, will return current_user courses.
  get '/MyAndAllCourses' do
    api_authenticate!

    email = params['Email'] if params['Email']
    userid = params['StudentID'] if params['StudentID']

    results = Array.new {Hash.new}

    if email
      halt 401, {'message': 'Unauthorized User'}.to_json if !current_user.admin 

      student = User.first(Email: email)
      halt 400, {'message': 'User not found'}.to_json if !student
      ac = AllCourses.all

      ac.each do |i|
        sc = StudentCourses.first(UserID: student.id, CourseID: i.CourseID)
        if sc 
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'Institution'   => i.Institution,
            'Semester'      => sc.Semester,
            'Grade'         => sc.Grade,
          }
        else
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'Institution'   => i.Institution,
            'Semester'      => 'n',
            'Grade'         => 'n',
          }
        end
      end
      halt 200, results.to_json
    elsif userid
      halt 401, {'message': 'Unauthorized User'}.to_json if !current_user.admin

      student = User.first(id: userid)
      halt 400, {'message': 'User not found'}.to_json if !student
      ac = AllCourses.all

      ac.each do |i|
        sc = StudentCourses.first(UserID: student.id, CourseID: i.CourseID)
        if sc 
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'Institution'   => i.Institution,
            'Semester'      => sc.Semester,
            'Grade'         => sc.Grade,
          }
        else
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'Institution'   => i.Institution,
            'Semester'      => 'n',
            'Grade'         => 'n',
          }
        end
      end
      halt 200, results.to_json

    else
      #s_courses = StudentCourses.all(UserID: current_user.id)
      ac = AllCourses.all

      ac.each do |i|
        sc = StudentCourses.first(UserID: current_user.id, CourseID: i.CourseID)
        if sc
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'Institution'   => i.Institution,
            'Semester'      => sc.Semester,
            'Grade'         => sc.Grade,
          }
        else
          results << {
            'CourseID'      => i.CourseID,
            'CourseDept'    => i.CourseDept,
            'CourseNum'     => i.CourseNum,
            'Name'          => i.Name,
            'Institution'   => i.Institution,
            'Semester'      => 'n',
            'Grade'         => 'n',
          }
        end
      end

      halt 200, results.to_json


    end
  end
#### Wink Wink my doods
  post '/selfadd/StudentCourses' do
    
    api_authenticate!
    if !(params["CourseNum"] or params["CourseDept"] or params["CourseName"])
      userid = current_user.id
      params["CourseID"] ? (courseid = params['CourseID']): (halt 400, {"message": "Missing CourseID paramater"}.to_json)
      params["Semester"] ? (semester = params['Semester']): (halt 400, {"message": "Missing Semester paramater"}.to_json)
      params["Grade"] ? (grade = params['Grade']): (halt 400, {"message": "Missing Grade paramater"}.to_json)
      notes = params['Notes']
    elsif !params["CourseID"]
      
      #params["CourseNum"] ? (courseNum = params['CourseID']): (halt 400, {"message": "Missing CourseID paramater"}.to_json)
      #params["CourseNum"] ? (courseDept = params['CourseID']): (halt 400, {"message": "Missing CourseID paramater"}.to_json)
      
      c = AllCourses.first(Name: params["CourseName"])
      courseid = c.CourseID
      #halt 200, c.to_json
      #property :CourseDept, String
      #property :CourseNum, Integer

      params["Semester"] ? (semester = params['Semester']): (halt 400, {"message": "Missing Semester paramater"}.to_json)
      params["Grade"] ? (grade = params['Grade']): (halt 400, {"message": "Missing Grade paramater"}.to_json)
      notes = params['Notes']
    end





    if !is_number?(courseid)
      halt 400, {'message': 'CourseID param not an integer'}.to_json
    end

    if courseid != '' && semester != '' && grade != ''
      if userid
        #if current_user.admin

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
        #else
         # halt 401, {"message": "Unauthorized user"}.to_json
        #end
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
  ##A student should be able to remove their own course - mario
  delete '/remove/StudentCourse' do
    api_authenticate!
    params["CourseID"] ? ID = params["CourseID"] : (halt 400, {"message": "Missing Parameters"}.to_json)

    Target = StudentCourses.first(UserID: current_user.id, CourseID: ID)
    if Target
       Target.destroy
       halt 200, {"message": "Deleted Successfully"}.to_json
    else
       halt 404, {"message": "Object Not Found"}
  end
 end
#the flutter guy


## Courses by Dept Hug0


get "/Allcourses/ByDept" do
    api_authenticate!
    params["CourseDept"] ? dept = params["CourseDept"] : (halt 400, {"message": "Missing Parameters"}.to_json)
    halt 200, AllCourses.all(CourseDept: dept).to_json
  end

  get "/usercourses/ByDept" do #checked
  api_authenticate!
  userid = params["id"] if params["id"]
  params["CourseDept"] ? dept = params["CourseDept"] : (halt 400, {"message": "Missing Parameters"}.to_json)
  if userid 
  	if current_user.admin
      sc = StudentCourses.all(UserID: userid)
      courses = Array.new {Hash.new}
      sc.each do |i|
        
        course = AllCourses.first(CourseID: i.CourseID, CourseDept: dept)
  
        if course
          courses << course
        end
      end
      halt 200, courses.to_json if courses.size != 0
      halt 400, {'message': 'User has no courses in this department'}.to_json
  else
  	halt 401, {'message': 'Not Authorized'}.to_json
  end
  else
     sc = StudentCourses.all(UserID: current_user.id)
      courses = Array.new {Hash.new}
      sc.each do |i|
        
        course = AllCourses.first(CourseID: i.CourseID, CourseDept: dept)
  
        if course
          courses << course
        end
      end
      halt 200, courses.to_json if courses.size != 0
      halt 400, {'message': 'User has no courses in this department'}.to_json
  end
end

 get "/plannedUsercourses/ByDept" do #checked
  api_authenticate!
  userid = params["id"] if params["id"]
  params["CourseDept"] ? dept = params["CourseDept"] : (halt 400, {"message": "Missing Parameters"}.to_json)
  if userID && current_user.admin
      pfc = PlannedFutureCourses.all(UserID: userid)
      courses = Array.new {Hash.new}
      pfc.each do |i|
        
        
        course = AllCourses.first(CourseID: i.CourseID, CourseDept: dept)
  
        if course
          courses << course
        end
      end
      halt 200, courses.to_json if courses.size != 0
      halt 400, {'message': 'User has no courses in this department'}.to_json
  else
     pfc = PlannedFutureCourses.all(UserID: current_user.id)
      courses = Array.new {Hash.new}
      pfc.each do |i|
        
        course = AllCourses.first(CourseID: i.CourseID, CourseDept: dept)
  
        if course
          courses << course
        end
      end
      halt 200, courses.to_json if courses.size != 0
      halt 400, {'message': 'User has no courses in this department'}.to_json
  end
end
