// Export as a module to be included by database.js

// Dependencies
var db = require('mysql');

// Database information
var connectionInfo = {
    host : "localhost",
    user : "root",
    password : "mysql",
    port : 3306
};

// Creating a connection
var connection = db.createConnection(connectionInfo);
connection.connect(function(err) {
    if (err) {
        console.error("Error connecting: " + err.stack);
        return;
    }
    console.log('Connected as id ' + connection.threadId);
});

// Complication object
var Complication = function(table, columns) {
    this.tableName = table;
    this.columnNames = columns;
};

// Getting an array of all tables in the database
var tables = [];
var query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'cvicu';";

exports.yoda = connection.query(query, function(err, results) {
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
    var complicationTables = {};
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
            exports.loaded = complicationTables;
            // console.log(complicationTables);
        }
    });
}
