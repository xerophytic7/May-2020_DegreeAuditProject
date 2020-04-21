var express = require('express')
var path = require('path')

app = express()

app.set('port', 3002)

app.use(express.static(path.join(__dirname, 'static')))

var server = app.listen(app.get('port'), function() {
	console.log("Server started...")
})
