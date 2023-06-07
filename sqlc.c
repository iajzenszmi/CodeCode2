
#include <stdio.h>
#include <stdlib.h>
#include "sqlite3.h"

int main(int argc, char *argv[]) {
  // Open the database connection.
  sqlite3 *db;
  int rc = sqlite3_open("mydatabase2.db", &db);
  if (rc != SQLITE_OK) {
    fprintf(stderr, "Error opening database: %s\n", sqlite3_errmsg(db));
    exit(1);
  }

  // Create a table.
  char *sql = "CREATE TABLE mytable (id INTEGER PRIMARY KEY, name TEXT, age INTEGER);";
  rc = sqlite3_exec(db, sql, NULL, NULL, NULL);
  if (rc != SQLITE_OK) {
    fprintf(stderr, "Error creating table: %s\n", sqlite3_errmsg(db));
    exit(1);
  }

  // Insert a row into the table.
  sql = "INSERT INTO mytable (name, age) VALUES ('John Doe', 30);";
  rc = sqlite3_exec(db, sql, NULL, NULL, NULL);
  if (rc != SQLITE_OK) {
    fprintf(stderr, "Error inserting row: %s\n", sqlite3_errmsg(db));
    exit(1);
  }

  // Select a row from the table.
  sql = "SELECT * FROM mytable;";
  sqlite3_stmt *stmt;
  rc = sqlite3_prepare(db, sql, -1, &stmt, NULL);
  if (rc != SQLITE_OK) {
    fprintf(stderr, "Error preparing statement: %s\n", sqlite3_errmsg(db));
    exit(1);
  }

  // Bind the results of the query to variables.
  int id;
  char *name;
  int age;
  sqlite3_bind_int(stmt, 1, &id);
  sqlite3_bind_text(stmt, 2, name, -1, SQLITE_TRANSIENT);
  sqlite3_bind_int(stmt, 3, &age);

  // Execute the query.
  rc = sqlite3_step(stmt);
  if (rc != SQLITE_ROW) {
    fprintf(stderr, "Error executing query: %s\n", sqlite3_errmsg(db));
    exit(1);
  }

  // Print the results of the query.
  printf("ID: %d\n", id);
  printf("Name: %s\n", name);
  printf("Age: %d\n", age);

  // Close the database connection.
  sqlite3_finalize(stmt);
  sqlite3_close(db);

  return 0;
}

