// CVICU App: connection to MySQL database

// Node packages
var app = require('express')();
var db = require('mysql');
var bodyParser = require('body-parser');
var multer = require('multer');

// Database information
var connectionInfo = {
    host : "localhost",
    user : "root",
    password : "mysql",
    port : 3306
}

// Configure app
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));
app.use(multer());

// app.get('/', function(req, res) {
//     res.send('Hello World!');
// });

app.post('/', function(req, res) {
    var request = req.body;
    if (request["Target Action"] == "check FIN") {
        var connection = db.createConnection(connectionInfo);
        connection.connect();

        var query = "USE cvicu; SELECT * from "
        connection.query("USE cvicu");

    }
});

app.listen(3000, function() {
    console.log('Server running at port 3000.');
});
