/* Zinca Vlad-Alexandru, 333CC */
%{
    #include <stdio.h>
    #include <string.h>

    #define MAX_NUMBER 64

    /* variables that temporarily save values from an SQL command */
    char table_name[MAX_NUMBER];
    char primary_key[MAX_NUMBER];
    char potential_key_name[MAX_NUMBER];
    int column_count;
    int insert_into_column_count;
    int insert_into_value_count;
    int alter_table_column_count;

    /* take into consideration to not add "\n" on the first output line */
    int is_first = 1;

    /* data we permanently store about SQL tables */
    typedef struct SQLTable
    {
        char table_name[MAX_NUMBER];
        char primary_key[MAX_NUMBER];
        int column_count;
        int record_count;
        int is_dropped;
    } SQLTable;

    /* the array of SQL tables we permanently store data in */
    SQLTable SQL_table_array[MAX_NUMBER];
    int SQL_table_count = 0;

    /* check whether a table name and its associated data has been
       permanently stored */
    int check_table(char* table_name)
    {
        for (int i = 0; i < SQL_table_count; i++)
            if ((strcmp(SQL_table_array[i].table_name, table_name) == 0)
                && (SQL_table_array[i].is_dropped == 0))
                return i;
        return -1;
    }

    /* create and permanently store a table with the temporarily saved values */
    void create_table(char* table_name, char* primary_key, int column_count)
    {
        int pos = check_table(table_name);
        if (pos != -1)
        {
            if (is_first)
            {
                is_first = 0;
                printf("Invalid command.\n");
            }
            else
            {
                printf("\nInvalid command.\n");
            }
        }
        else
        {
            strcpy(SQL_table_array[SQL_table_count].table_name, table_name);
            strcpy(SQL_table_array[SQL_table_count].primary_key, primary_key);
            SQL_table_array[SQL_table_count].column_count = column_count;
            SQL_table_array[SQL_table_count].record_count = 0;
            SQL_table_array[SQL_table_count].is_dropped = 0;
            SQL_table_count++;
        }
    }

    /* remove a table from our collection; simply turn is_dropped flag on */
    void drop_table(char* table_name)
    {
        int pos = check_table(table_name);
        if (pos == -1)
        {
            if (is_first)
            {
                is_first = 0;
                printf("Invalid command.\n");
            }
            else
            {
                printf("\nInvalid command.\n");
            }
        }
        else
        {
            SQL_table_array[pos].is_dropped = 1;
        }
    }

    /* insert into a table */
    void insert_into(char* table_name, int insert_into_column_count,
                     int insert_into_value_count)
    {
        int pos = check_table(table_name);
        if (pos == -1)
        {
            if (is_first)
            {
                is_first = 0;
                printf("Invalid command.\n");
            }
            else
            {
                printf("\nInvalid command.\n");
            }
        }
        else
        {
            /* the case with columns, nothing to store here; just check
               whether command is invalid */
            if (insert_into_column_count != 0)
            {
                if ((insert_into_column_count > SQL_table_array[pos].column_count)
                    || (insert_into_column_count != insert_into_value_count))
                {
                    if (is_first)
                    {
                        is_first = 0;
                        printf("Invalid command.\n");
                    }
                    else
                    {
                        printf("\nInvalid command.\n");
                    }
                }
            }
            /* the case without columns, if there is a value for every column
               just add a record */
            else
            {
                if (insert_into_value_count != SQL_table_array[pos].column_count)
                {
                    if (is_first)
                    {
                        is_first = 0;
                        printf("Invalid command.\n");
                    }
                    else
                    {
                        printf("\nInvalid command.\n");
                    }
                }
                else
                {
                    SQL_table_array[pos].record_count++;
                }
            }
        }
    }

    /* print the information we permanently stored about a table */
    void describe(char* table_name)
    {
        /* check whether the table exists */
        int pos = check_table(table_name);
        if (pos == -1)
        {
            if (is_first)
            {
                is_first = 0;
                printf("Invalid command.\n");
            }
            else
            {
                printf("\nInvalid command.\n");
            }
        }
        else
        {
            /* if its the first line printed, do not print "\n" */
            if (is_first)
            {
                is_first = 0;
                printf("Table Name: %s\n", SQL_table_array[pos].table_name);
                printf("Primary Key: %s\n", SQL_table_array[pos].primary_key);
                printf("Number of columns: %d\n", SQL_table_array[pos].column_count);
                printf("Number of records: %d\n", SQL_table_array[pos].record_count);
            }
            else
            {
                printf("\nTable Name: %s\n", SQL_table_array[pos].table_name);
                printf("Primary Key: %s\n", SQL_table_array[pos].primary_key);
                printf("Number of columns: %d\n", SQL_table_array[pos].column_count);
                printf("Number of records: %d\n", SQL_table_array[pos].record_count);
            }
        }
    }

    /* alter the table by either adding or droping a column */
    void alter_table(char* table_name, int alter_table_column_count)
    {
        /* check whether the table we want to alter exists */
        int pos = check_table(table_name);
        if (pos == -1)
        {
            if (is_first)
            {
                is_first = 0;
                printf("Invalid command.\n");
            }
            else
            {
                printf("\nInvalid command.\n");
            }
        }
        else
        {
            /* alter (add or drop) columns */
            SQL_table_array[pos].column_count += alter_table_column_count;
        }
    }
%}

/* declare the states our program will use */
%s CREATE_TABLE_TABLE_NAME CREATE_TABLE_CONTENT_START CREATE_TABLE_COLUMN_NAME
%s CREATE_TABLE_COLUMN_TYPE CREATE_TABLE_COLUMN_TYPE_LENGTH
%s CREATE_TABLE_COLUMN_CONSTRAINT CREATE_TABLE_COLUMN_END CREATE_TABLE_CONSTRAINT
%s CREATE_TABLE_CONSTRAINT_PRIMARY_KEY CREATE_TABLE_CONSTRAINT_PRIMARY_KEY_CONTENT
%s CREATE_TABLE_CONTENT_END DROP_TABLE INSERT_INTO INSERT_INTO_COLUMN_START
%s INSERT_INTO_COLUMN_ELEMENT INSERT_INTO_VALUE_START INSERT_INTO_VALUE_ELEMENT
%s INSERT_INTO_VALUE_END DESCRIBE ALTER_TABLE ALTER_TABLE_FUNCTION
%s ALTER_TABLE_ADD_NAME ALTER_TABLE_ADD_TYPE ALTER_TABLE_ADD_TYPE_LENGTH
%s ALTER_TABLE_END ALTER_TABLE_DROP_COLUMN COMMENT1 COMMENT2 COMMENT3 COMMENT4
%s COMMENT5 COMMENT6 COMMENT7 COMMENT8 COMMENT9 COMMENT10 COMMENT11 COMMENT12
%s COMMENT13 COMMENT14 COMMENT15 COMMENT16 COMMENT17 COMMENT18 COMMENT19 COMMENT20
%s COMMENT21 COMMENT22 COMMENT23 COMMENT24 COMMENT25 COMMENT26 COMMENT27

%%
<INITIAL>"--"                                                   {
/* for every existent state, check for "--" marking a comment, and if it is
   found send it to COMMENTX state and ignore everything else until "\n", then
   send it back to the state it was comming from. See test4.in */
                                                                    BEGIN(COMMENT1);
                                                                }
<COMMENT1>"\n"                                                  {
                                                                    BEGIN(INITIAL);
                                                                }
<CREATE_TABLE_TABLE_NAME>"--"                                   {
                                                                    BEGIN(COMMENT2);
                                                                }
<COMMENT2>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_TABLE_NAME);
                                                                }
<CREATE_TABLE_CONTENT_START>"--"                                {
                                                                    BEGIN(COMMENT3);
                                                                }
<COMMENT3>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_CONTENT_START);
                                                                }
<CREATE_TABLE_COLUMN_NAME>"--"                                  {
                                                                    BEGIN(COMMENT4);
                                                                }
<COMMENT4>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_COLUMN_NAME);
                                                                }
<CREATE_TABLE_COLUMN_TYPE>"--"                                  {
                                                                    BEGIN(COMMENT5);
                                                                }
<COMMENT5>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_COLUMN_TYPE);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>"--"                           {
                                                                    BEGIN(COMMENT6);
                                                                }
<COMMENT6>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_COLUMN_TYPE_LENGTH);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>"--"                            {
                                                                    BEGIN(COMMENT7);
                                                                }
<COMMENT7>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_COLUMN_CONSTRAINT);
                                                                }
<CREATE_TABLE_COLUMN_END>"--"                                   {
                                                                    BEGIN(COMMENT8);
                                                                }
<COMMENT8>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_CONSTRAINT>"--"                                   {
                                                                    BEGIN(COMMENT9);
                                                                }
<COMMENT9>"\n"                                                  {
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT);
                                                                }
<CREATE_TABLE_CONSTRAINT_PRIMARY_KEY>"--"                       {
                                                                    BEGIN(COMMENT10);
                                                                }
<COMMENT10>"\n"                                                 {
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT_PRIMARY_KEY);
                                                                }
<CREATE_TABLE_CONSTRAINT_PRIMARY_KEY_CONTENT>"--"               {
                                                                    BEGIN(COMMENT11);
                                                                }
<COMMENT11>"\n"                                                 {
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT_PRIMARY_KEY_CONTENT);
                                                                }
<CREATE_TABLE_CONTENT_END>"--"                                  {
                                                                    BEGIN(COMMENT12);
                                                                }
<COMMENT12>"\n"                                                 {
                                                                    BEGIN(CREATE_TABLE_CONTENT_END);
                                                                }
<DROP_TABLE>"--"                                                {
                                                                    BEGIN(COMMENT13);
                                                                }
<COMMENT13>"\n"                                                 {
                                                                    BEGIN(DROP_TABLE);
                                                                }
<INSERT_INTO>"--"                                               {
                                                                    BEGIN(COMMENT14);
                                                                }
<COMMENT14>"\n"                                                 {
                                                                    BEGIN(INSERT_INTO);
                                                                }
<INSERT_INTO_COLUMN_START>"--"                                  {
                                                                    BEGIN(COMMENT15);
                                                                }
<COMMENT15>"\n"                                                 {
                                                                    BEGIN(INSERT_INTO_COLUMN_START);
                                                                }
<INSERT_INTO_COLUMN_ELEMENT>"--"                                {
                                                                    BEGIN(COMMENT16);
                                                                }
<COMMENT16>"\n"                                                 {
                                                                    BEGIN(INSERT_INTO_COLUMN_ELEMENT);
                                                                }
<INSERT_INTO_VALUE_START>"--"                                   {
                                                                    BEGIN(COMMENT17);
                                                                }
<COMMENT17>"\n"                                                 {
                                                                    BEGIN(INSERT_INTO_VALUE_START);
                                                                }
<INSERT_INTO_VALUE_ELEMENT>"--"                                 {
                                                                    BEGIN(COMMENT18);
                                                                }
<COMMENT18>"\n"                                                 {
                                                                    BEGIN(INSERT_INTO_VALUE_ELEMENT);
                                                                }
<INSERT_INTO_VALUE_END>"--"                                     {
                                                                    BEGIN(COMMENT19);
                                                                }
<COMMENT19>"\n"                                                 {
                                                                    BEGIN(INSERT_INTO_VALUE_END);
                                                                }
<DESCRIBE>"--"                                                  {
                                                                    BEGIN(COMMENT20);
                                                                }
<COMMENT20>"\n"                                                 {
                                                                    BEGIN(DESCRIBE);
                                                                }
<ALTER_TABLE>"--"                                               {
                                                                    BEGIN(COMMENT21);
                                                                }
<COMMENT21>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE);
                                                                }
<ALTER_TABLE_FUNCTION>"--"                                      {
                                                                    BEGIN(COMMENT22);
                                                                }
<COMMENT22>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE_FUNCTION);
                                                                }
<ALTER_TABLE_ADD_NAME>"--"                                      {
                                                                    BEGIN(COMMENT23);
                                                                }
<COMMENT23>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE_ADD_NAME);
                                                                }
<ALTER_TABLE_ADD_TYPE>"--"                                      {
                                                                    BEGIN(COMMENT24);
                                                                }
<COMMENT24>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE_ADD_TYPE);
                                                                }
<ALTER_TABLE_ADD_TYPE_LENGTH>"--"                               {
                                                                    BEGIN(COMMENT25);
                                                                }
<COMMENT25>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE_ADD_TYPE_LENGTH);
                                                                }
<ALTER_TABLE_END>"--"                                           {
                                                                    BEGIN(COMMENT26);
                                                                }
<COMMENT26>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE_END);
                                                                }
<ALTER_TABLE_DROP_COLUMN>"--"                                   {
                                                                    BEGIN(COMMENT27);
                                                                }
<COMMENT27>"\n"                                                 {
                                                                    BEGIN(ALTER_TABLE_DROP_COLUMN);
                                                                }
<INITIAL>"CREATE TABLE"                                         {
/* detected CREATE TABLE command, reinitialize temporarily saved
   values and go look for name */
                                                                    strcpy(primary_key, "\0");
                                                                    column_count = 0;
                                                                    BEGIN(CREATE_TABLE_TABLE_NAME);
                                                                }
<INITIAL>"DROP TABLE"                                           {
/* detected DROP TABLE command, go look for table name */
                                                                    BEGIN(DROP_TABLE);
                                                                }
<DROP_TABLE>[a-zA-Z0-9]*                                        {
/* remove the table whose name is in yytext, go back to INITIAL state */
                                                                    drop_table(yytext);
                                                                    BEGIN(INITIAL);
                                                                }
<INITIAL>"INSERT INTO"                                          {
/* detected INSERT INTO command */
                                                                    BEGIN(INSERT_INTO);
                                                                }
<INSERT_INTO>[a-zA-Z0-9]*                                       {
                                                                    strcpy(table_name, yytext);
                                                                    insert_into_column_count = 0;
                                                                    insert_into_value_count = 0;
                                                                    BEGIN(INSERT_INTO_COLUMN_START);
                                                                }
<INSERT_INTO_COLUMN_START>"VALUES"                              {
/* this sends it directly to the VALUES states if there
   are no columns in the command */
                                                                    BEGIN(INSERT_INTO_VALUE_START);
                                                                }
<INSERT_INTO_COLUMN_START>[(,]                                  {
/* look for the columns */
                                                                    BEGIN(INSERT_INTO_COLUMN_ELEMENT);
                                                                }
<INSERT_INTO_COLUMN_START>")"                                   {
/* columns ended, look for VALUES */
                                                                    BEGIN(INSERT_INTO_VALUE_START);
                                                                }
<INSERT_INTO_COLUMN_ELEMENT>[a-zA-Z0-9_]*                       {
                                                                    insert_into_column_count++;
                                                                    BEGIN(INSERT_INTO_COLUMN_START);
                                                                }
<INSERT_INTO_VALUE_START>"VALUES"                               {
                                                                    BEGIN(INSERT_INTO_VALUE_START);
                                                                }
<INSERT_INTO_VALUE_START>[(,]                                   {
                                                                    BEGIN(INSERT_INTO_VALUE_ELEMENT);
                                                                }
<INSERT_INTO_VALUE_START>")"                                    {
                                                                    BEGIN(INSERT_INTO_VALUE_END);
                                                                }
<INSERT_INTO_VALUE_ELEMENT>[a-zA-Z0-9_]*                        {
                                                                    insert_into_value_count++;
                                                                    BEGIN(INSERT_INTO_VALUE_START);
                                                                }
<INSERT_INTO_VALUE_END>";"                                      {
/* both columns and values counted. If there were no columns then
   insert_into_column_count must be 0. Apply INSERT INTO */
                                                                    insert_into(table_name, insert_into_column_count, insert_into_value_count);
                                                                    BEGIN(INITIAL);
                                                                }
<INITIAL>"DESCRIBE"                                             {
/* detected DESCRIBE command */
                                                                    BEGIN(DESCRIBE);
                                                                }
<DESCRIBE>[a-zA-Z0-9]*                                          {
/* describe the table whose name is in yytext */
                                                                    describe(yytext);
                                                                    BEGIN(INITIAL);
                                                                }
<INITIAL>"ALTER TABLE"                                          {
/* detected ALTER TABLE command */
                                                                    BEGIN(ALTER_TABLE);
                                                                }
<ALTER_TABLE>[a-zA-Z0-9]*                                       {
                                                                    strcpy(table_name, yytext);
                                                                    alter_table_column_count = 0;
                                                                    BEGIN(ALTER_TABLE_FUNCTION);
                                                                }
<ALTER_TABLE_FUNCTION>"ADD"                                     {
/* ALTER TABLE command version where we add a column */
                                                                    alter_table_column_count++;
                                                                    BEGIN(ALTER_TABLE_ADD_NAME);
                                                                }
<ALTER_TABLE_FUNCTION>"DROP COLUMN"                             {
/* ALTER TABLE command version where we remove a column */
                                                                    alter_table_column_count--;
                                                                    BEGIN(ALTER_TABLE_DROP_COLUMN);
                                                                }
<ALTER_TABLE_ADD_NAME>[a-zA-Z0-9_]*                             {
                                                                    BEGIN(ALTER_TABLE_ADD_TYPE);
                                                                }
<ALTER_TABLE_ADD_TYPE>[a-zA-Z0-9_]*                             {
                                                                    BEGIN(ALTER_TABLE_ADD_TYPE_LENGTH);
                                                                }
<ALTER_TABLE_ADD_TYPE_LENGTH>"("[0-9]*")"                       {
/* ALTER TABLE ADD can either add a type with length e.g. "number(10)"
   or it can add a type without a length e.g. "int". For both cases,
   add the column and go back to INITIAL state */
                                                                    BEGIN(ALTER_TABLE_END);
                                                                }
<ALTER_TABLE_ADD_TYPE_LENGTH>";"                                {
                                                                    alter_table(table_name, alter_table_column_count);
                                                                    BEGIN(INITIAL);
                                                                }
<ALTER_TABLE_END>";"                                            {
                                                                    alter_table(table_name, alter_table_column_count);
                                                                    BEGIN(INITIAL);
                                                                }
<ALTER_TABLE_DROP_COLUMN>[a-zA-Z0-9_]*                          {
                                                                    BEGIN(ALTER_TABLE_END);
                                                                }
<CREATE_TABLE_TABLE_NAME>[a-zA-Z0-9]*                           {
/* temporarily save the name of the table we want to create in table_name */
                                                                    strcpy(table_name, yytext);
                                                                    BEGIN(CREATE_TABLE_CONTENT_START);
                                                                }
<CREATE_TABLE_CONTENT_START>"("                                 {
/* the table content starts at "(", move to read a column that has
   name, type and can have type length and NOT NULL PRIMARY KEY or not */
                                                                    BEGIN(CREATE_TABLE_COLUMN_NAME);
                                                                }
<CREATE_TABLE_COLUMN_NAME>[a-zA-Z0-9_]*                         {
                                                                    strcpy(potential_key_name, yytext);
                                                                    BEGIN(CREATE_TABLE_COLUMN_TYPE);
                                                                }
<CREATE_TABLE_COLUMN_TYPE>[a-zA-Z0-9_]*                         {
                                                                    BEGIN(CREATE_TABLE_COLUMN_TYPE_LENGTH);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>");"                           {
                                                                    column_count++;
                                                                    create_table(table_name, primary_key, column_count);
                                                                    BEGIN(INITIAL);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>","                            {
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>"NOT NULL"                     {
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>"NOT NULL PRIMARY KEY"         {
                                                                    strcpy(primary_key, potential_key_name);
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>"NOT NULL,"                    {
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>"NOT NULL PRIMARY KEY,"        {
                                                                    strcpy(primary_key, potential_key_name);
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_TYPE_LENGTH>"("[0-9]*")"                   {
                                                                    BEGIN(CREATE_TABLE_COLUMN_CONSTRAINT);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>","                             {
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>"NOT NULL"                      {
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>"NOT NULL PRIMARY KEY"          {
                                                                    strcpy(primary_key, potential_key_name);
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>"NOT NULL,"                     {
                                                                    column_count++;
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>"NOT NULL PRIMARY KEY,"         {
                                                                    column_count++;
                                                                    strcpy(primary_key, potential_key_name);
                                                                    BEGIN(CREATE_TABLE_COLUMN_END);
                                                                }
<CREATE_TABLE_COLUMN_CONSTRAINT>");"                            {
/* table ended without CONSTRAINT line at the end, permanently add table */
                                                                    column_count++;
                                                                    create_table(table_name, primary_key, column_count);
                                                                    BEGIN(INITIAL);
                                                                }
<CREATE_TABLE_COLUMN_END>"CONSTRAINT"                           {
/* columns ended, look for constraint line and read it */
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT);
                                                                }
<CREATE_TABLE_COLUMN_END>"PRIMARY KEY"                          {
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT_PRIMARY_KEY_CONTENT);
                                                                }
<CREATE_TABLE_COLUMN_END>[a-zA-Z0-9_]*                          {
                                                                    BEGIN(CREATE_TABLE_COLUMN_TYPE);
                                                                }
<CREATE_TABLE_COLUMN_END>");"                                   {
                                                                    create_table(table_name, primary_key, column_count);
                                                                    BEGIN(INITIAL);
                                                                }
<CREATE_TABLE_CONSTRAINT>[a-zA-Z0-9_]*                          {
/* save the constraint value as primary key if it exists */
                                                                    strcat(primary_key, yytext);
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT_PRIMARY_KEY);
                                                                }
<CREATE_TABLE_CONSTRAINT_PRIMARY_KEY>"PRIMARY KEY"              {
                                                                    BEGIN(CREATE_TABLE_CONSTRAINT_PRIMARY_KEY_CONTENT);
                                                                }
<CREATE_TABLE_CONSTRAINT_PRIMARY_KEY_CONTENT>([a-zA-Z0-9_])*    {
/* save the primary key value as primary key, or concatenate it
   at the end of the current primary key in (). Final form:
   constraint(primary_key) as required */
                                                                    if (strcmp(primary_key, "\0") != 0)
                                                                    {
                                                                        strcat(primary_key, "(");
                                                                        strcat(primary_key, yytext);
                                                                        strcat(primary_key, ")");
                                                                    }
                                                                    else
                                                                        strcat(primary_key, yytext);
                                                                    BEGIN(CREATE_TABLE_CONTENT_END);
                                                                }
<CREATE_TABLE_CONTENT_END>");"                                  {
/* after saving primary key from constraint line, create table */
                                                                    create_table(table_name, primary_key, column_count);
                                                                    BEGIN(INITIAL);
                                                                }
.                                                               ;
"\n"                                                            ;
%%

/* reached EOF, do nothing */
int yywrap(){}

int main(int argc, char **argv)
{
    /* open file named at first argument and read from it */
    yyin = fopen(argv[1], "r");
    /* start lexical analyzer */
    yylex();
    return 0;
}
