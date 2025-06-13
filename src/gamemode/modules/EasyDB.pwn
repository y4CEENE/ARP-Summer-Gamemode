/// @file      EasyDB.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-05-08 10:15:19 +0200
/// @copyright Copyright (c) 2022


#define EASYDB_PORT 3306
#define EASYDB_AUTO_RECONNECT true
#define EASYDB_POOL_SIZE      4

#define calldb::%0(%1) \
    db_%0(%1)

static MySQL:DB_ConnectionID;
static DB_QueryBuffer[4096];

stock GetDBQueryBuffer()
{
    return DB_QueryBuffer;
}

stock GetDBConnectionID()
{
    return DB_ConnectionID;
}

stock SetDBConnectionID(MySQL:id)
{
    DB_ConnectionID = id;
}

stock GetNbPendingDBQueries()
{
    return mysql_unprocessed_queries(DB_ConnectionID);
}

stock GetDBInsertID()
{
    return cache_insert_id();
}

stock GetDBNumRows()
{
    new row_count;
    cache_get_row_count(row_count);
    return row_count;
}

stock GetDBNumFields()
{
    new field_count;
    cache_get_field_count(field_count);
    return field_count;
}

stock GetDBNumResults()
{
    new result_count;
    cache_get_result_count(result_count);
    return result_count;
}

stock GetDBNumAffectedRows()
{
    return cache_affected_rows();
}

stock DBEscape(const string[])
{
    new result[512];
    mysql_escape_string(string, result);
    return result;
}

stock DBRealEscape(const string[])
{
    new result[512];
    mysql_real_escape_string(string, result, DB_ConnectionID);
    return result;
}

stock DBConnect(hostname[], username[], password[], database[], port = 3306, poolSize = 4, autoReconnect = true)
{
    new MySQLOpt:options = mysql_init_options();

    mysql_set_option(options, MULTI_STATEMENTS, true);
    mysql_set_option(options, AUTO_RECONNECT,   autoReconnect);
    mysql_set_option(options, POOL_SIZE,        poolSize);
    mysql_set_option(options, SERVER_PORT,      port);

    DB_ConnectionID = mysql_connect(hostname, username, password, database, options);
    new errorid = mysql_errno(DB_ConnectionID);
    if (errorid)
    {
        new error[256];
        mysql_error(error, sizeof(error), DB_ConnectionID);
        printf("[ERROR %d] - Unable to establish a connection with the MySQL server...", errorid);
        printf("  - mysql_hostname: '%s'", hostname);
        printf("  - mysql_username: '%s'", username);
        printf("  - mysql_database: '%s'", database);
        printf("  - mysql_password: '%s'", password);
        printf("  - error_message : '%s'", error);
        return 0;
    }
    return 1;
}

stock IsDBConnected()
{
    return (mysql_errno(DB_ConnectionID) == 0);
}

stock DBDisconnect()
{
    mysql_close(DB_ConnectionID);
}

stock DBQueryWithCallback(sql[], callback[], text[] = "", {Float, _}:...)
{
    static args, sizeArgsInBytes, dbCallback[64];

    if (isnull(sql))
    {
        return 0;
    }
    strcpy(DB_QueryBuffer, sql, sizeof(DB_QueryBuffer));
    if (isnull(callback))
    {
        dbCallback[0] = EOS;
    }
    else
    {
        format(dbCallback, sizeof(dbCallback), "db_%s", callback);
    }

    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) <= 3)
    {
        mysql_pquery(DB_ConnectionID, DB_QueryBuffer, dbCallback, text);
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 3)
        {
            #emit LCTRL 5        //  PRI reg is set to the current value of 5=FRM (Stack Frame Pointer)
            #emit LOAD.alt args  //  ALT = [args]
            #emit SHL.C.alt 2    //  ALT = ALT << 2 (.C means const)
            #emit ADD.C 12       //  PRI = PRI + 12
            #emit ADD            //  PRI = PRI + ALT
            #emit LOAD.I         //  PRI = [PRI]
            #emit PUSH.pri       //  [STK] = PRI, STK = STK − cell_size
            // [STK] = [STK + 12 + args * 2]
        }
        #emit PUSH.S text           // Type: ARRAY => [STK] = [FRM + text]     , STK = STK − cell_size
        #emit PUSH.C dbCallback     // Type: ARRAY => [STK] = dbCallback       , STK = STK − cell_size
        #emit PUSH.C DB_QueryBuffer // Type: ARRAY => [STK] = DB_QueryBuffer   , STK = STK − cell_size
        #emit PUSH DB_ConnectionID  // Type: INT   => [STK] = [DB_ConnectionID], STK = STK − cell_size
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH sizeArgsInBytes  // Type: INT   => [STK] = [sizeArgsInBytes], STK = STK − cell_size
        #emit SYSREQ.C mysql_pquery
        #emit LCTRL 5
        #emit SCTRL 4
        // None
        #emit RETN
    }
    return 1;
}

stock DBQuery(sql[], {Float, _}:...)
{
    static args, sizeArgsInBytes;

    if (isnull(sql))
    {
        return 0;
    }
    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) <= 1)
    {
        mysql_format(DB_ConnectionID, DB_QueryBuffer, sizeof(DB_QueryBuffer), sql);
        mysql_pquery(DB_ConnectionID, DB_QueryBuffer);
    }
    else
    {
        sizeArgsInBytes = (3 + args) * 4;
        while (--args >= 1)
        {
            #emit LCTRL 5        //  PRI reg is set to the current value of 5=FRM (Stack Frame Pointer)
            #emit LOAD.alt args  //  ALT = [args]
            #emit SHL.C.alt 2    //  ALT = ALT << 2 (.C means const)
            #emit ADD.C 12       //  PRI = PRI + 12
            #emit ADD            //  PRI = PRI + ALT
            #emit LOAD.I         //  PRI = [PRI]
            #emit PUSH.pri       //  [STK] = PRI, STK = STK − cell_size
            // [STK] = [STK + 12 + args * 2]
        }
        #emit PUSH.S sql             // Type: ARRAY => [STK] = [FRM + sql]      , STK = STK − cell_size
        #emit PUSH.C 4096            // Type: CONST => [STK] = 4096             , STK = STK − cell_size
        #emit PUSH.C DB_QueryBuffer  // Type: ARRAY => [STK] = DB_QueryBuffer   , STK = STK − cell_size
        #emit PUSH DB_ConnectionID   // Type: INT   => [STK] = [DB_ConnectionID], STK = STK − cell_size
        #emit PUSH sizeArgsInBytes   // Type: CONST => [STK] = [sizeArgsInBytes], STK = STK − cell_size
        #emit SYSREQ.C mysql_format
        #emit LCTRL 5                //  PRI reg is set to the current value of 5=FRM (stack frame pointer)
        #emit SCTRL 4                //   set 4=STK (Stack index) to the value in PRI
        mysql_pquery(DB_ConnectionID, DB_QueryBuffer);

        #emit RETN
    }
    return 1;
}

stock DBFormat(sql[], {Float, _}:...)
{
    static args, sizeArgsInBytes;

    if (isnull(sql))
    {
        DB_QueryBuffer[0] = EOS;
        return 1;
    }
    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) <= 1)
    {
        mysql_format(DB_ConnectionID, DB_QueryBuffer, sizeof(DB_QueryBuffer), sql);
    }
    else
    {
        sizeArgsInBytes = (3 + args) * 4;
        while (--args >= 1)
        {
            #emit LCTRL 5        //  PRI reg is set to the current value of 5=FRM (Stack Frame Pointer)
            #emit LOAD.alt args  //  ALT = [args]
            #emit SHL.C.alt 2    //  ALT = ALT << 2 (.C means const)
            #emit ADD.C 12       //  PRI = PRI + 12
            #emit ADD            //  PRI = PRI + ALT
            #emit LOAD.I         //  PRI = [PRI]
            #emit PUSH.pri       //  [STK] = PRI, STK = STK − cell_size
            // [STK] = [STK + 12 + args * 2]
        }
        #emit PUSH.S sql             // Type: ARRAY => [STK] = [FRM + sql]       , STK = STK − cell_size
        #emit PUSH.C 4096            // Type: INT   => [STK] = 4096              , STK = STK − cell_size
        #emit PUSH.C DB_QueryBuffer  // Type: ARRAY => [STK] = DB_QueryBuffer    , STK = STK − cell_size
        #emit PUSH DB_ConnectionID   // Type: INT   => [STK] = [DB_ConnectionID] , STK = STK − cell_size
        #emit PUSH sizeArgsInBytes   // Type: INT   => [STK] = [sizeArgsInBytes] , STK = STK − cell_size
        #emit SYSREQ.C mysql_format
        #emit LCTRL 5
        #emit SCTRL 4
        // None
        #emit RETN
    }
    return 1;
}

stock DBContinueFormat(sql[], {Float, _}:...)
{
    static args, sizeArgsInBytes;
    static tmpData[4096];

    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) <= 1)
    {
        strcat(DB_QueryBuffer, sql, sizeof(DB_QueryBuffer));
    }
    else
    {
        sizeArgsInBytes = (3 + args) * 4;
        while (--args >= 1)
        {
            #emit LCTRL 5        //  PRI reg is set to the current value of 5=FRM (Stack Frame Pointer)
            #emit LOAD.alt args  //  ALT = [args]
            #emit SHL.C.alt 2    //  ALT = ALT << 2 (.C means const)
            #emit ADD.C 12       //  PRI = PRI + 12
            #emit ADD            //  PRI = PRI + ALT
            #emit LOAD.I         //  PRI = [PRI]
            #emit PUSH.pri       //  [STK] = PRI, STK = STK − cell_size
            // [STK] = [STK + 12 + args * 2]
        }
        #emit PUSH.S sql             // Type: ARRAY => [STK] = [FRM + sql]       , STK = STK − cell_size
        #emit PUSH.C 4096            // Type: INT   => [STK] = 4096              , STK = STK − cell_size
        #emit PUSH.C tmpData         // Type: ARRAY => [STK] = DB_QueryBuffer    , STK = STK − cell_size
        #emit PUSH DB_ConnectionID   // Type: INT   => [STK] = [DB_ConnectionID] , STK = STK − cell_size
        #emit PUSH sizeArgsInBytes   // Type: INT   => [STK] = [sizeArgsInBytes] , STK = STK − cell_size
        #emit SYSREQ.C mysql_format
        #emit LCTRL 5
        #emit SCTRL 4
        strcat(DB_QueryBuffer, tmpData, sizeof(DB_QueryBuffer));
        #emit RETN
    }
    return 1;
}

stock DBExecute(callback[] = "", text[] = "", {Float, _}:...)
{
    static args, sizeArgsInBytes, dbCallback[64];

    if (isnull(DB_QueryBuffer))
    {
        return 0;
    }
    if (isnull(callback))
    {
        dbCallback[0] = EOS;
    }
    else
    {
        format(dbCallback, sizeof(dbCallback), "db_%s", callback);
    }
    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) <= 2)
    {
        mysql_pquery(DB_ConnectionID, DB_QueryBuffer, dbCallback, text);
    }
    else
    {
        sizeArgsInBytes = (2 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL 5        //  PRI reg is set to the current value of 5=FRM (Stack Frame Pointer)
            #emit LOAD.alt args  //  ALT = [args]
            #emit SHL.C.alt 2    //  ALT = ALT << 2 (.C means const)
            #emit ADD.C 12       //  PRI = PRI + 12
            #emit ADD            //  PRI = PRI + ALT
            #emit LOAD.I         //  PRI = [PRI]
            #emit PUSH.pri       //  [STK] = PRI, STK = STK − cell_size
            // [STK] = [STK + 12 + args * 2]
        }
        #emit PUSH.S text           // Type: ARRAY => [STK] = [FRM + text]     , STK = STK − cell_size
        #emit PUSH.C dbCallback     // Type: ARRAY => [STK] = callback         , STK = STK − cell_size
        #emit PUSH.C DB_QueryBuffer // Type: ARRAY => [STK] = DB_QueryBuffer   , STK = STK − cell_size
        #emit PUSH DB_ConnectionID  // Type: INT   => [STK] = [DB_ConnectionID], STK = STK − cell_size
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH sizeArgsInBytes  // Type: INT   => [STK] = [sizeArgsInBytes], STK = STK − cell_size
        #emit SYSREQ.C mysql_pquery
        #emit LCTRL 5
        #emit SCTRL 4
        // None
        #emit RETN
    }
    return 1;
}

forward OnQueryExecuted(us, const query[], const callback[], const callback2[], MySQL:handle);
public OnQueryExecuted(us, const query[], const callback[], const callback2[], MySQL:handle)
{
    static string[4096];

    format(string, sizeof(string),
        "SQL_WARN "\
        "[Duration: %i.%03ims]"\
        "[Callback: %s]"\
        "[Query: %s]",
        us / 1000,
        us % 1000,
        callback,
        query);

    printf(string);
    Log("logs/mysql_warning.log", string);
    return 1;
}

hook OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
    static string[4096];
    if (isnull(callback))
    {
        format(string, sizeof(string),
            "SQL_ERROR [ErrorID=%i][Error=%s][Query=%s]",
            errorid, error, query);
    }
    else
    {
        format(string, sizeof(string),
            "SQL_ERROR [ErrorID=%i][Error=%s][Callback=%s][Query=%s]",
            errorid, error, callback, query);
    }
    printf(string);
    Log("logs/mysql_error.log", string);
    return 1;
}

stock GetDBStringField(row_idx, const column_name[], destination[], max_len = sizeof(destination))
{
    cache_get_value_name(row_idx, column_name, destination, max_len);
}

stock GetDBIntField(row_idx, const column_name[])
{
    new destination;
    cache_get_value_name_int(row_idx, column_name, destination);
    return destination;
}

stock Float:GetDBFloatField(row_idx, const column_name[])
{
    new Float:destination;
    cache_get_value_name_float(row_idx, column_name, destination);
    return destination;
}

stock bool:GetDBBoolField(row_idx, const column_name[])
{
    new bool:destination;
    cache_get_value_name_bool(row_idx, column_name, destination);
    return destination;
}

stock bool:IsDBFieldNull(row_idx, const column_name[])
{
    new bool:destination;
    cache_is_value_name_null(row_idx, column_name, destination);
    return destination;
}

// indexes

stock GetDBStringFieldFromIndex(row_idx, column_idx, destination[], max_len = sizeof(destination))
{
    cache_get_value_index(row_idx, column_idx, destination, max_len);
}

stock GetDBIntFieldFromIndex(row_idx, column_idx)
{
    new destination;
    cache_get_value_index_int(row_idx, column_idx, destination);
    return destination;
}

stock Float:GetDBFloatFieldFromIndex(row_idx, column_idx)
{
    new Float:destination;
    cache_get_value_index_float(row_idx, column_idx, destination);
    return destination;
}

stock bool:GetDBBoolFieldFromIndex(row_idx, column_idx)
{
    new bool:destination;
    cache_get_value_index_bool(row_idx, column_idx, destination);
    return destination;
}

stock bool:IsDBFieldFromIndexNull(row_idx, column_idx)
{
    new bool:destination;
    cache_is_value_index_null(row_idx, column_idx, destination);
    return destination;
}
