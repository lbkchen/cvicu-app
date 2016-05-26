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


    // Checking FIN patient MRN number
    if (request["Target Action"] == "check FIN") {
        var connection = db.createConnection(connectionInfo);
        connection.connect(function(err) {
            if (err) {
                console.error("Error connecting: " + err.stack);
                return;
            }
            console.log('Connected as id ' + connection.threadId);
        });

        var fin = request["FIN"];
        var table = request["Table"];
        var query = "USE cvicu; SELECT * from ? where FIN = ?";
        console.log(sql);
        connection.query(query, [table, fin], function(err, results) {
            if (err) {
                console.error("Error in query: " + err.stack);
                return;
            } else if (isEmpty(results)) {
                // No such user exists
                console.log("FIN and complication not found!");
                res.write("NO");
                res.end();
            } else {
                // User found
                console.log("FIN and complication found!");
                res.write(results[results.length - 1]["date"]);
                res.end();
            }
        });
        connection.end();
    }


    // All queries requesting logs
    if (request["Target Action"] == "requestLogs") {
        var backMessage = [];
        var connection = db.createConnection(connectionInfo);
        connection.connect();

        connection.query() //TODO: Figure out why logs are nested within each other (mistake?). Also, how do we get the particular complication from the connection before query? Use multiple dictionaries to make modular code?
    }

    // All queries inserting into logs
});

app.listen(3000, function() {
    console.log('Server running at port 3000.');
});
