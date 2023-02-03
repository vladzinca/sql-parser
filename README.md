# SQL Parser

## 🤖 What is it?

This program uses [Flex](https://en.wikipedia.org/wiki/Flex_(lexical_analyser_generator)) (fast lexical analyzer generator) to iterate through an SQL code example, store certain information about it and print it when required.

In order to work as intended, the SQL excerpt needs to be valid and only contain the following commands: `CREATE TABLE`, `DROP TABLE`, `INSERT INTO`, `DESCRIBE` and `ALTER TABLE`.

It is purely conceptual and illustrates what can be done with pure text processing.

I received it as homework for my Formal Languages and Automata Theory class, and worked on it briefly in January 2023.

## 🔗 How to run it?

1.  Clone this repository.
2.  Compile it using `make`.
3.  Run any pre-made tests found in `test1.in` - `test4.in` using `make run1` - `make run4`. I personally wrote tests 3 and 4. The results will be printed in the console and should match those found in `test1.ref` - `test4.ref`.
4.  If you want, you can make your own test by creating another file, writing it there, and then running `make`, followed by `./tema <input_file>`, where `<input_file>` is the name of the file you just created.
5.  Enjoy!

## 🔭 How does it work?

What the program does is that it basically parses through the given input and looks for matches to certain patterns of text.

When they are matched, say we were looking for the text "CREATE TABLE" and it came up in the input, it uses something called "states" and switches to another state that looks for the continuation of said command, in this case the name of the table we want to create.

What's more, when it finds itself in certain states, it know how to save certain matched information (for example, the table name) to some buffer variables, and when the instruction is verified as complete, it stores that information to the "permanent memory" of the program.

### Command structure

#### `CREATE TABLE`:

```sql
CREATE TABLE table_name (
    column_1 data_type column_constraint,
    column_2 data_type column_constraint,
    ...
    table_constraint
);
```

#### `DROP TABLE`:

```sql
DROP TABLE table_name;
```

#### `INSERT INTO`:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
```

or

```sql
INSERT INTO table_name
VALUES (value1, value2, value3, ...);
```

#### `DESCRIBE`:

```sql
DESCRIBE table_name;
```

#### `ALTER TABLE`:

```sql
ALTER TABLE table_name
ADD column_name datatype;
```

or

```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```

## 🎓 What did I learn?

When I started to work on this project, the main problem I encountered was that both the documentation of Flex I could find on the Internet, as well as the documentation I received from my teacher, was very, very limited.

This being the case, I spent a few hours just reinventing the wheel, trying to understand the basics of Flex, what states are and how I can use them to parse through complex text patterns.

In the end, working with software for which there is limited documentation available was the most important lesson I got from this experience, and I am extremely enthusiastic to have done it.

## 🤔 Did you know?

The transition between states is pretty complicated, with more than 50 states and more than 100 transitions. Imagine how many a complete SQL parser, for every available command, could have. 🤯
