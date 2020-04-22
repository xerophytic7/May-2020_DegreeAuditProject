

const express = require('express');
const path = require('path');
var hbs = require( 'express-handlebars');

app = express();
app.set('port', 3002);

// setup handlebars and the view engine for res.render calls
// (more standard to use an extension like 'hbs' rather than
//  'html', but the Universiry server doesn't like other extensions)
app.set('view engine', 'html');
app.engine( 'html', hbs( {
  extname: 'html',
  defaultView: 'default',
  layoutsDir: __dirname + '/views/layouts/',
  partialsDir: __dirname + '/views/partials/'
}));

// setup static file service
app.use(express.static(path.join(__dirname, 'static')));


//get home page
app.get('/home', (req, res) => {
    res.render("home",{active: { home: true },page: "Home"});
});

//get login page
app.get('/login', (req, res) => {
    res.render("login");
});

//get register page
app.get('/register', (req, res) => {
    res.render("register");
});

//get advising page
app.get('/advising', (req, res) => {
    res.render("advising",{active: { advising: true },page: "Advising"});
});

//get future_courses page
app.get('/future_courses', (req, res) => {
    res.render("future_courses",{active: { future_courses: true },page: "Future Courses"});
});

//get notifications page
app.get('/notifications', (req, res) => {
    res.render("notifications",{active: { notifications: true },page: "Notifications"});
});

//get user_profile page
app.get('/user_profile', (req, res) => {
    res.render("user_profile",{active: { user_profile: true },page: "User Profile"});
});

// // basic view route
// app.get('/home', function(req, res, next) {
//   res.render('home');
// });



var server = app.listen(app.get('port'), function() {
	console.log("Server started...")
});