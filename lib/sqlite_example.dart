import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dog_model.dart';

class SQLiteController {

  late Future<Database> database;

  Future<void> initializeDatabase() async {

    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );



    // xu ly voi database

    // Create a Dog and add it to the dogs table
    // var fido = const Dog(
    //   id: 0,
    //   name: 'Fido',
    //   age: 35,
    // );
    //
    // await insertDog(fido);
    //
    // // Now, use the method above to retrieve all the dogs.
    // print(await dogs()); // Prints a list that include Fido.
    //
    // // Update Fido's age and save it to the database.
    // fido = Dog(
    //   id: fido.id,
    //   name: fido.name,
    //   age: fido.age + 7,
    // );
    // await updateDog(fido);
    //
    // // Print the updated results.
    // print(await dogs()); // Prints Fido with age 42.
    //
    // // Delete Fido from the database.
    // await deleteDog(fido.id);
    //
    // // Print the list of dogs (empty).
    // print(await dogs());

  }

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    // await db.insert(
    //   'dogs',
    //   dog.toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );

    await db.rawInsert('INSERT INTO dogs (NAME,AGE) VALUES(\'${dog.name}\',${dog.age})');
  }

  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    //db.rawQuery(sql)

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    //db.rawUpdate(sql)

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(String name) async {
    // Get a reference to the database.
    final db = await database;

    //db.rawDelete(sql)

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'name = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}



