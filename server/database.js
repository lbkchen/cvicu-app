// CVICU App: connection to MySQL database

// Node packages
var app = require('express')();
var db = require('mysql');
var bodyParser = require('body-parser');
var multer = require('multer');

// Configure app
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));
app.use(multer({dest:'./uploads/'}).single('singleInputFileName'));

// Database information
var connectionInfo = {
    host : "localhost",
    user : "root",
    password : "mysql",
    port : 3306
};

// Complication object
var Complication = function(table, columns) {
    this.tableName = table;
    this.columnNames = columns;
};

// Getting an array of all tables in the database
var connection = db.createConnection(connectionInfo);
connection.connect(function(err) {
    if (err) {
        console.error("Error connecting: " + err.stack);
        return;
    }
    console.log('Connected as id ' + connection.threadId);
});

// Getting an array of all tables in the database
var tables = [];
var complicationTables = {};
var query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'cvicu';";

connection.query(query, function(err, results) {
    if (err) {
        console.error("Error in accessing schema: " + err.stack);
        return;
    } else {
        for (var i = 0; i < results.length; i++) {
            tables.push(results[i]["TABLE_NAME"]);
        }
        // Generating Complication objects from all MySQL tables
        createComplications(tables);
    }
});

// Function to create the object with all complication tables and their columns
function createComplications(tables) {
    var query = "SELECT `COLUMN_NAME` as `column`, `TABLE_NAME` as `table` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA` = 'cvicu';"
    connection.query(query, function(err, results) {
        if (err) {
            console.error("Error in retrieving tables: " + err.stack);
            return;
        } else {
            for (var i = 0; i < results.length; i++) {
                var columnName = results[i]["column"];
                var tableName = results[i]["table"];
                if (tableName in complicationTables) {
                    complicationTables[tableName]["columnNames"].push(columnName);
                } else {
                    complicationTables[tableName] = new Complication(tableName, [columnName]);
                }
            }
            main();
        }
    });
}

// Helper Functions
function isEmpty(obj) { // check if object is empty
    return !Object.keys(obj).length;
}

// Main body
function main() {
    app.post('/', function(req, res) {
        var request = req.body;


        // Checking FIN patient MRN number
        if (request["targetAction"] == "checkFIN") {
            var connection = db.createConnection(connectionInfo);
            connection.connect();

            var fin = request["FIN"];
            var table = request["Table"];
            var query = "SELECT * from ?? WHERE FIN = ?;";

            connection.query("USE cvicu;");
            connection.query(query, [table, fin], function(err, results) {
                if (err) {
                    console.error("Error in FIN query: " + err.stack);
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
        if (request["targetAction"] == "requestLogs") {
            var toClient = [];
            var connection = db.createConnection(connectionInfo);
            connection.connect();

            for (comp in complicationTables) {
                var query = "SELECT date FROM ?? WHERE FIN = ?;";
                connection.query("USE cvicu;");
                connection.query(query, [comp, request["FIN"]], function(err, results) {
                    if (err) {
                        console.error("Error in requesting " + comp + ": " + err.stack);
                        return;
                    } else if (!isEmpty(results)) {
                        var lastLog = {
                            table : comp,
                            date : results[results.length - 1]["date"]
                        };
                    } else {
                        var lastLog = {
                            table : "null"
                        };
                    }
                });
                toClient.push(lastLog);
            }
        }


        // All queries inserting into logs
        if (request["targetAction"] == "addLog") {
            // Create connection and get table name
            var connection = db.createConnection(connectionInfo);
            connection.connect();
            var thisComplication = request["Table"];

            console.log ("Start: adding to " + thisComplication);

            // Create an object patientLog that represents a row of values in the SQL table
            var patientLog = {};
            var columnNames = complicationTables[thisComplication]["columnNames"];
            for (column in columnNames) {
                patientLog[column] = request[column];
            }

            // Generate query
            var query = "INSERT INTO ?? SET ?;";
            connection.query("USE cvicu");
            connection.query(query, [thisComplication, patientLog], function(err, results) {
                if (err) {
                    console.error("Error in " + thisComplication + " insertion: " + err.stack);
                    var toClient = {
                        BackMsg : "add back",
                        Result : "false"
                    };
                    toClient = JSON.stringify(toClient);
                    res.write(toClient);
                    res.end();
                    return;
                } else {
                    var toClient = {
                        BackMsg : "add back",
                        Result : "true"
                    };
                    toClient = JSON.stringify(toClient);
                    res.write(toClient);
                    res.end();
                }
            });
            connection.end();
            console.log("End: adding to " + thisComplication);
        }
    });

    app.listen(3000, function() {
        console.log('Server running at port 3000.');
    });
}
