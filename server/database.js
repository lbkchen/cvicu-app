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
            // Remove tables that are not actually complications by 'date' column
            for (key in complicationTables) {
                if (complicationTables[key]["columnNames"].indexOf("date") < 0) {
                    delete complicationTables[key];
                }
            }
            console.log(complicationTables);
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

        // Helper functions for requestLogs
        function queryComplication(comp) {
            var query = "SELECT " + mainDate[comp] + " from ?? where FIN = ?;";
            connection.query("USE cvicu;");
            connection.query(query, [comp, request["FIN"]], function(err, results) {
                if (err) {
                    console.error("Error in requesting " + comp + ": " + err.stack);
                } else {
                    var lastLog = {
                        table : comp,
                        dates : results.map(function(obj) {return obj[mainDate[comp]];})
                    }
                    toClient.push(lastLog);
                    lock--;
                    if (lock == 0) finishRequest();
                }
            });
        }

        function finishRequest() {
            toClient = JSON.stringify(toClient);
            res.write(toClient);
            res.end();
        }


        // All queries requesting logs
        if (request["targetAction"] == "requestLogs") {
            var toClient = [];
            var lock = Object.keys(complicationTables).length;
            var connection = db.createConnection(connectionInfo);
            connection.connect();

            for (comp in complicationTables) {
                queryComplication(comp);
            }
        }


        // All queries inserting into logs
        if (request["targetAction"] == "addLog") {
            // Create connection and get table name
            var connection = db.createConnection(connectionInfo);
            connection.connect();
            var thisComplication = request["Table"];

            console.log("Start: adding to " + thisComplication);

            // Create an object patientLog that represents a row of values in the SQL table
            var patientLog = {};
            var columnNames = complicationTables[thisComplication]["columnNames"];
            // for (column in columnNames) {
            //     patientLog[column] = request[column];
            // }
            for (var i = 0; i < columnNames.length; i++) {
                var thisColumn = columnNames[i];
                patientLog[thisColumn] = request[thisColumn];
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


        // All queries checking concurrent log conflicts
        if (request["targetAction"] == "checkConflicts") {
            var toClient = [];
            var table = request["Table"];
            var date = request["dateToCheck"];
            var connection = db.createConnection(connectionInfo);
            connection.connect();

            var query = "SELECT " + mainDate[table] + " as datime FROM ?? WHERE FIN = ? GROUP BY datime HAVING DATEDIFF(STR_TO_DATE('" + date + "', '%m/%d/%Y %H:%i'), STR_TO_DATE(" + mainDate[table] + ", '%m/%d/%Y %H:%i')) = 0;";
            connection.query("USE cvicu;");
            connection.query(query, [table, request["FIN"]], function(err, results) {
                results = results.map(function(obj) {return obj["datime"];});
                toClient.push(results);
                toClient = JSON.stringify(toClient);
                res.write(toClient);
                res.end();
            });

            connection.end();
        }
    });

    app.listen(3000, function() {
        console.log('Server running at port 3000.');
    });
}

// Miscellaneous

var mainDate = {
        "arrhythmialog" : "date_1",
        "cprlog" : "startDate",
        "dsclog" : "date_1",
        "ididlog" : "date_1",
        "infeclog" : "date", // FIXME: No "most recent date option"
        "lcoslog" : "date_1",
        "lhtlog" : "date_1",
        "mcslog" : "date_1",
        "odlog" : "date", // FIXME: No "most recent date option"
        "perdlog" : "date_1",
        "phlog" : "date_1",
        "pvolog" : "date_1",
        "rblog" : "date_1",
        "reslog" : "date", // FIXME: No "most recent date option"
        "svolog" : "date_1",
        "uoplog" : "date_1",
        "urcclog" : "date_1",
        "urhlog" : "date_1"
};
