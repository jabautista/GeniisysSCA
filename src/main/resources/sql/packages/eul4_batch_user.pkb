CREATE OR REPLACE PACKAGE BODY CPI.EUL4_BATCH_USER AS

-- Global Batch States
BATCH_STATE_SUBMITTED        NUMBER(1) := 1;
BATCH_STATE_IN_PROGRESS      NUMBER(1) := 2;
BATCH_STATE_SUBMISSION_ERROR NUMBER(1) := 3;
BATCH_STATE_RUN_ERROR        NUMBER(1) := 4;
BATCH_STATE_REPORT_DELETED   NUMBER(1) := 5;
BATCH_STATE_EUL_CHANGED      NUMBER(1) := 6;
BATCH_STATE_EXPIRED          NUMBER(1) := 7;
BATCH_STATE_ROW_LIMIT        NUMBER(1) := 8;
BATCH_STATE_READY            NUMBER(1) := 9;

-- =====================================================================
-- PROCEDURE: DynamicExecute
-- DESCRIPTION: Dynamically executes a SQL statement.
PROCEDURE DynamicExecute(sqlStatement IN VARCHAR2) IS
    cur    INTEGER;
    ignore INTEGER;
BEGIN
    -- NOTE: The return value for EXECUTE is only valid for insert,
    --       update and delete. For DDL statements it should be ignored.
    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    ignore := DBMS_SQL.EXECUTE(cur);
    DBMS_SQL.CLOSE_CURSOR(cur);
END;

-- =====================================================================
-- PROCEDURE: ReplaceEULSchema()
-- DESCRIPTION:  Replaces occurences of <EUL_SCHEMA> with schema name.
PROCEDURE ReplaceEULSchema(eulSchemaName IN VARCHAR2,
                           sqlStatement IN OUT VARCHAR2,
                           bError       IN BOOLEAN := FALSE) IS
BEGIN

    sqlStatement := REPLACE(sqlStatement, '<EUL_SCHEMA>', eulSchemaName);

END ReplaceEULSchema;


-- =====================================================================
-- PROCEDURE: SetStatusExpired()
-- DESCRIPTION:  Set the status of a Batch Report Run to Expired
-- TRANSACTIONS: Transaction block around the SetstatusExpired.
PROCEDURE SetStatusExpired(eulSchemaName IN VARCHAR2,
                           batchReportRunId IN NUMBER) IS

    sqlStatement VARCHAR2(2000);
BEGIN
    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'          || chr(10) ||
                    'SET brr_state = ' || to_char(BATCH_STATE_EXPIRED)   || chr(10) ||
                    'WHERE brr_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    DynamicExecute(sqlStatement);

    -- EXCEPTIONS PROPOGATE UPWARDS

END SetStatusExpired;

-- =====================================================================
-- PROCEDURE: SetStatusSubmissionError()
-- DESCRIPTION:  Set the status of a Batch Report Run to Submission Error
PROCEDURE SetStatusSubmissionError(eulSchemaName IN VARCHAR2,
                                   batchReportRunId IN NUMBER) IS

    sqlStatement VARCHAR2(2000);
BEGIN

    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'                 || chr(10) ||
                    'SET brr_state = ' || to_char(BATCH_STATE_SUBMISSION_ERROR) || chr(10) ||
                    'WHERE brr_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    DynamicExecute(sqlStatement);

EXCEPTION
    WHEN OTHERS THEN
        RETURN;

END SetStatusSubmissionError;

-- =====================================================================
-- PROCEDURE: SetBatchReportCompletionInfo()
-- DESCRIPTION: Sets the elapsed time, next run date and job number.
PROCEDURE SetBatchReportCompletionInfo(eulSchemaName    IN VARCHAR2,
                                       batchReportId    IN NUMBER,
                                       batchReportRunId IN NUMBER,
                                       startDate        IN DATE,
                                       throwException   IN BOOLEAN := FALSE,
                                       nextRunDate      IN DATE := NULL,
                                       jobNo            IN NUMBER := NULL) IS

    cur          INTEGER;
    ignore       INTEGER;
    sqlStatement VARCHAR2(2000);
BEGIN

    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'                                          || chr(10) ||
                    'SET brr_act_elap_time = round(to_number((SYSDATE - :startDate) * 86400), 0)'  || chr(10) ||
                    'WHERE brr_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    DBMS_SQL.BIND_VARIABLE(cur, 'startDate', startDate);
    ignore := DBMS_SQL.EXECUTE(cur);

    COMMIT;

    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_batch_reports'    || chr(10) ||
                    'SET br_next_run_date = :nextRunDate,'     || chr(10) ||
                    '    br_job_id = ' || to_char(jobNo)       || chr(10) ||
                    'WHERE br_id = ' || to_char(batchReportId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    DBMS_SQL.BIND_VARIABLE(cur, 'nextRunDate', nextRunDate);
    ignore := DBMS_SQL.EXECUTE(cur);
    DBMS_SQL.CLOSE_CURSOR(cur);

    IF (throwException = FALSE) THEN
        COMMIT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF (throwException = TRUE) THEN
            RAISE;
        END IF;

END SetBatchReportCompletionInfo;

-- =====================================================================
-- PROCEDURE: SetStatusReady()
-- DESCRIPTION: Update the status to Ready
--              ready, elapsed time and job no.
--              If an error then updates the elapsed time.
PROCEDURE SetStatusReady(eulSchemaName    IN VARCHAR2,
                         batchReportRunId IN NUMBER) IS

    sqlStatement VARCHAR2(2000);
BEGIN

    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'      || chr(10) ||
                    'SET brr_state = ' || to_char(BATCH_STATE_READY) || chr(10) ||
                    'WHERE brr_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    DynamicExecute(sqlStatement);

EXCEPTION
    WHEN OTHERS THEN
        RETURN;

END SetStatusReady;

-- =====================================================================
-- PROCEDURE: SetExpiredRuns()
-- DESCRIPTION:  Sets the status of the expired Batch Report Runs for
--               the current user. Only set Batch Report Runs to expired
--               if they are ready. All error status' are kept in tact
--               ready for viewing.
-- TRANSACTIONS: Transaction block around the SetStatusExpired.
PROCEDURE SetExpiredRuns(eulSchemaName IN VARCHAR2,
                         userName      IN VARCHAR2) IS

    cur              INTEGER;
    ignore           INTEGER;
    sqlStatement     VARCHAR2(2000);
    batchReportRunId NUMBER(22);
    noRows           NUMBER := 1;

BEGIN

    sqlStatement := 'SELECT brr.brr_id'                                                      || chr(10) ||
                    'FROM <EUL_SCHEMA>.eul4_br_runs brr,'                           || chr(10) ||
                    '<EUL_SCHEMA>.eul4_batch_reports br, <EUL_SCHEMA>.eul4_eul_users eu'       || chr(10) ||
                    'WHERE eu.eu_username = ''' || userName || ''''                          || chr(10) ||
                    'AND eu.eu_id = br.br_eu_id'                                             || chr(10) ||
                    'AND br.br_id = brr.brr_br_id'                                           || chr(10) ||
                    'AND brr.brr_state = ' || to_char(BATCH_STATE_READY)                     || chr(10) ||
                    'AND brr.brr_run_date + br.br_expiry < SYSDATE';

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(cur, 1, batchReportRunId);
    ignore := DBMS_SQL.EXECUTE(cur);

    LOOP
        IF DBMS_SQL.FETCH_ROWS(cur) > 0 THEN
            DBMS_SQL.COLUMN_VALUE(cur, 1, batchReportRunId);
            BEGIN
                SetStatusExpired(eulSchemaName, batchReportRunId);
                noRows := noRows + 1;
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                -- Rollback and attempt the next expiry update
                ROLLBACK;
            END;
        ELSE
            EXIT;
        END IF;
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR(cur);

END SetExpiredRuns;

-- =====================================================================
-- PROCEDURE: DropTable()
-- DESCRIPTION: Generic drop table routine.
PROCEDURE DropTable(tableName IN VARCHAR2) IS

    tableSQL VARCHAR2(50);

BEGIN
    tableSQL := 'DROP TABLE ' || tableName;
    DynamicExecute(tableSQL);

END DropTable;

-- =====================================================================
-- PROCEDURE: DeleteBatchQueryEntries()
-- DESCRIPTION: Delete the Batch Query row ans associated result set
--              table.
PROCEDURE DeleteBatchQueryEntries(eulSchemaName IN VARCHAR2,
                                  batchReportRunId IN NUMBER) IS

    curSelect           INTEGER;
    curDelete           INTEGER;
    ignore              INTEGER;
    sqlSelect           VARCHAR2(2000);
    sqlDelete           VARCHAR2(2000);
    batchQueryTableId   NUMBER(22);
    batchQueryTableName VARCHAR2(128);

BEGIN

    sqlSelect := 'SELECT bqt_id, bqt_table_name'              || chr(10) ||
                 'FROM <EUL_SCHEMA>.eul4_bq_tables'   || chr(10) ||
                 'WHERE bqt_brr_id = ' || to_char(batchReportRunId);

    sqlDelete := 'DELETE FROM <EUL_SCHEMA>.eul4_bq_tables' || chr(10) ||
                 'WHERE bqt_id = :batchQueryTableId';

    ReplaceEULSchema(eulSchemaName, sqlSelect);
    ReplaceEULSchema(eulSchemaName, sqlDelete);

    curSelect := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(curSelect, sqlSelect, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(curSelect, 1, batchQueryTableId);
    DBMS_SQL.DEFINE_COLUMN(curSelect, 2, batchQueryTableName, 128);
    ignore := DBMS_SQL.EXECUTE(curSelect);

    curDelete := DBMS_SQL.OPEN_CURSOR;

    DBMS_SQL.PARSE(curDelete, sqlDelete, DBMS_SQL.V7);

    LOOP
        IF DBMS_SQL.FETCH_ROWS(curSelect) > 0 THEN
            DBMS_SQL.COLUMN_VALUE(curSelect, 1, batchQueryTableId);
            DBMS_SQL.COLUMN_VALUE(curSelect, 2, batchQueryTableName);

            BEGIN
                -- Delete the entry in Batch Query Table
                DBMS_SQL.BIND_VARIABLE(curDelete, 'batchQueryTableId', batchQueryTableId);
                ignore := DBMS_SQL.EXECUTE(curDelete);

                -- Drop the associated table
                -- DDL - Implicit COMMIT or ROLLBACK
                dropTable(batchQueryTableName);
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;   -- Dummy rollback - Not necessary
            END;
        ELSE
            EXIT;
        END IF;
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR(curSelect);
    DBMS_SQL.CLOSE_CURSOR(curDelete);

END DeleteBatchQueryEntries;

-- =====================================================================
-- PROCEDURE: SetStatusRowLimit()
-- DESCRIPTION: Set the status of Report Run to Row Limit Exceeded
-- TRANSACTIONS: Ignore all exceptions
PROCEDURE SetStatusRowLimit(eulSchemaName IN VARCHAR2,
                            batchReportRunId IN NUMBER) IS

    sqlStatement VARCHAR2(2000);

BEGIN

    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'             || chr(10) ||
                    'SET brr_state = ' || to_char(BATCH_STATE_ROW_LIMIT)    || chr(10) ||
                    'WHERE brr_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);
    DynamicExecute(sqlStatement);

    COMMIT;

    DeleteBatchQueryEntries(eulSchemaName, batchReportRunId);

    EXCEPTION
        WHEN OTHERS THEN
            RETURN;

END SetStatusRowLimit;

-- =====================================================================
-- PROCEDURE: SetStatusRunError()
-- DESCRIPTION: Set the status of a Batch Report Run to Run Error
-- TRANSACTIONS: Ignore all exceptions
PROCEDURE SetStatusRunError(eulSchemaName    IN VARCHAR2,
                            batchReportRunId IN NUMBER,
                            sqlCode          IN NUMBER,
                            sqlErrm          IN VARCHAR2) IS

    sqlStatement VARCHAR2(32767);
    cur          INTEGER;
    ignore       INTEGER;

BEGIN
    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'             || chr(10) ||
                    'SET brr_state = ' || BATCH_STATE_RUN_ERROR || ','      || chr(10) ||
                    '   brr_svr_err_code = ' || to_char(sqlCode) ||
                    ',   brr_svr_err_text = :sqlErrm'                  || chr(10) ||
                    'WHERE brr_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    DBMS_SQL.BIND_VARIABLE(cur, 'sqlErrm', sqlErrm);
    ignore := DBMS_SQL.EXECUTE(cur);
    DBMS_SQL.CLOSE_CURSOR(cur);

    COMMIT;

    DeleteBatchQueryEntries(eulSchemaName, batchReportRunId);

    EXCEPTION
        WHEN OTHERS THEN
            RETURN;

END SetStatusRunError;

-- =====================================================================
-- PROCEDURE: SetStatusReady()
-- DESCRIPTION: Update the status to Ready
--              ready, elapsed time and job no.
--              If an error then updates the elapsed time.
PROCEDURE InitializeJobNextRun(eulSchemaName    IN VARCHAR2,
                               batchReportRunId IN NUMBER) IS

    sqlStatement VARCHAR2(2000);

BEGIN

    sqlStatement := 'UPDATE <EUL_SCHEMA>.eul4_batch_reports'  || chr(10) ||
                    'SET br_job_id = NULL,'                  || chr(10) ||
                    '    br_next_run_date = NULL'            || chr(10) ||
                    'WHERE br_id = ' || to_char(batchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);
    DynamicExecute(sqlStatement);

    COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

END InitializeJobNextRun;

-- =====================================================================
-- FUNCTION: IsReportValid()
-- DESCRIPTION: Checks Batch Report Run to ensure that the state of the
--              EUL has not changed. Checks that Batch Report has not
--              been set to deleted.

FUNCTION IsReportValid(eulSchemaName IN VARCHAR2,
                       batchReportId IN NUMBER) RETURN BOOLEAN IS

    cur             INTEGER;
    sqlEULChanged   VARCHAR2(2000);
    sqlRunDeleted   VARCHAR2(2000);
    sqlTotalRuns    VARCHAR2(2000);
    ignore          INTEGER;
    countEULChanged NUMBER;
    countRunDeleted NUMBER;
    countTotalRuns  NUMBER;
    reportValid     BOOLEAN := TRUE;

BEGIN
    cur := DBMS_SQL.OPEN_CURSOR;

    sqlEULChanged := 'SELECT count(*)'                                          || chr(10) ||
                     'FROM <EUL_SCHEMA>.eul4_batch_reports br,'                  || chr(10) ||
                     '     <EUL_SCHEMA>.eul4_br_runs brr'              || chr(10) ||
                     'WHERE br.br_id = ' || to_char(batchReportId)              ||
                     ' AND br.br_id = brr.brr_br_id'                             || chr(10) ||
                     'AND brr.brr_state = ' || to_char(BATCH_STATE_EUL_CHANGED);

    sqlRunDeleted := 'SELECT count(*)'                                          || chr(10) ||
                     'FROM <EUL_SCHEMA>.eul4_br_runs'                  || chr(10) ||
                     'WHERE brr_state = ' || to_char(BATCH_STATE_REPORT_DELETED);

    sqlTotalRuns := 'SELECT count(*)'                                           || chr(10) ||
                    'FROM <EUL_SCHEMA>.eul4_br_runs';

    ReplaceEULSchema(eulSchemaName, sqlEULChanged);
    ReplaceEULSchema(eulSchemaName, sqlRunDeleted);
    ReplaceEULSchema(eulSchemaName, sqlTotalRuns);

    DBMS_SQL.PARSE(cur, sqlEULChanged, DBMS_SQL.V7);

    DBMS_SQL.DEFINE_COLUMN(cur, 1, countEULChanged);
    ignore := DBMS_SQL.EXECUTE(cur);
    ignore := DBMS_SQL.FETCH_ROWS(cur);
    DBMS_SQL.COLUMN_VALUE(cur, 1, countEULChanged);

    IF (countEULChanged > 0) THEN
        reportValid := FALSE;
    ELSE
        -- Check that the report has not been deleted
        -- Total the number of runs deleted
        DBMS_SQL.PARSE(cur, sqlRunDeleted, DBMS_SQL.V7);
        DBMS_SQL.DEFINE_COLUMN(cur, 1, countRunDeleted);
        ignore := DBMS_SQL.EXECUTE(cur);
        ignore := DBMS_SQL.FETCH_ROWS(cur);
        DBMS_SQL.COLUMN_VALUE(cur, 1, countRunDeleted);

        -- Total the number of runs
        DBMS_SQL.PARSE(cur, sqlTotalRuns, DBMS_SQL.V7);
        DBMS_SQL.DEFINE_COLUMN(cur, 1, countTotalRuns);
        ignore := DBMS_SQL.EXECUTE(cur);
        ignore := DBMS_SQL.FETCH_ROWS(cur);
        DBMS_SQL.COLUMN_VALUE(cur, 1, countTotalRuns);

        IF (countRunDeleted = countTotalRuns) THEN
            reportValid := FALSE;
        END IF;
    END IF;

    DBMS_SQL.CLOSE_CURSOR(cur);

    IF (reportValid = FALSE) THEN
        InitializeJobNextRun(eulSchemaName, batchReportId);
        RETURN FALSE;
    END IF;

    RETURN TRUE;

END IsReportValid;

-- =====================================================================
-- PROCEDURE: GetUserLimits
-- DESCRIPTION: Retrieve the commit size and the row limit.
--              Report Id can be used to retrieve the user name.
PROCEDURE GetUserLimits(eulSchemaName IN VARCHAR2,
                        batchReportId IN NUMBER,
                        userName      OUT VARCHAR2,
                        commitSize    OUT NUMBER,
                        rowFetchLimit OUT NUMBER) IS

    cur              INTEGER;
    ignore           INTEGER;
    sqlStatement     VARCHAR2(2000);
    tmpCommitSize    NUMBER(22);
    tmpRowFetchLimit NUMBER(22);
    tmpUserName      VARCHAR2(128);

BEGIN

    cur := DBMS_SQL.OPEN_CURSOR;

    sqlStatement := 'SELECT eu.eu_batch_cmt_sz, eu.eu_row_fetch_lmt, eu.eu_username' || chr(10) ||
                    'FROM <EUL_SCHEMA>.eul4_eul_users eu, <EUL_SCHEMA>.eul4_batch_reports br' || chr(10) ||
                    'WHERE br.br_id = ' || batchReportId                                    || chr(10) ||
                    'AND br.br_eu_id = eu.eu_id';

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(cur, 1, tmpCommitSize);
    DBMS_SQL.DEFINE_COLUMN(cur, 2, tmpRowFetchLimit);
    DBMS_SQL.DEFINE_COLUMN(cur, 3, tmpUserName, 128);

    ignore := DBMS_SQL.EXECUTE(cur);
    ignore := DBMS_SQL.FETCH_ROWS(cur);
    DBMS_SQL.COLUMN_VALUE(cur, 1, tmpCommitSize);
    DBMS_SQL.COLUMN_VALUE(cur, 2, tmpRowFetchLimit);
    DBMS_SQL.COLUMN_VALUE(cur, 3, tmpUserName);

    DBMS_SQL.CLOSE_CURSOR(cur);

    userName := tmpUserName;
    commitSize := tmpCommitSize;
    rowFetchLimit := tmpRowFetchLimit;

END GetUserLimits;

-- =====================================================================
-- PROCEDURE: setBatchReportRunInProgress
-- DESCRIPTION: Set the status to 'In Progress' and update the Run Date.
-- TRANSACTIONS:
PROCEDURE SetBatchReportRunInProgress(eulSchemaName    IN VARCHAR2,
                                      batchReportId    IN NUMBER,
                                      batchReportRunNo OUT NUMBER,
                                      batchReportRunId OUT NUMBER) IS

    cur                 INTEGER;
    ignore              INTEGER;
    sqlSelect           VARCHAR2(2000);
    sqlUpdate           VARCHAR2(2000);
    locBatchReportRunId NUMBER(22);
    locBatchReportRunNo NUMBER(22);

BEGIN
    cur := DBMS_SQL.OPEN_CURSOR;

    sqlSelect := 'SELECT brr_id, brr_run_number'                 || chr(10) ||
                 'FROM <EUL_SCHEMA>.eul4_br_runs'       || chr(10) ||
                 'WHERE brr_br_id = ' || to_char(batchReportId)  || chr(10) ||
                 'ORDER BY brr_run_number DESC';

    ReplaceEULSchema(eulSchemaName, sqlSelect);

    DBMS_SQL.PARSE(cur, sqlSelect, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(cur, 1, locBatchReportRunId);
    DBMS_SQL.DEFINE_COLUMN(cur, 2, locBatchReportRunNo);
    ignore := DBMS_SQL.EXECUTE(cur);
    ignore := DBMS_SQL.FETCH_ROWS(cur);
    DBMS_SQL.COLUMN_VALUE(cur, 1, locBatchReportRunId);
    DBMS_SQL.COLUMN_VALUE(cur, 2, locBatchReportRunNo);

    sqlUpdate := 'UPDATE <EUL_SCHEMA>.eul4_br_runs'                   || chr(10) ||
                 'SET brr_state = ' || to_char(BATCH_STATE_IN_PROGRESS) || ',' || chr(10) ||
                 '    brr_run_date = SYSDATE'                                  || chr(10) ||
                 '    WHERE brr_id = ' || to_char(locBatchReportRunId);

    ReplaceEULSchema(eulSchemaName, sqlUpdate);

    DBMS_SQL.PARSE(cur, sqlUpdate, DBMS_SQL.V7);
    ignore := DBMS_SQL.EXECUTE(cur);
    DBMS_SQL.CLOSE_CURSOR(cur);

    COMMIT;

    batchReportRunNo := locBatchReportRunNo;
    batchReportRunId := locBatchReportRunId;

    EXCEPTION
        WHEN OTHERS THEN
            -- Attempt to set the status of the Batch Report Run to Run Error
            SetStatusRunError(eulSchemaName, locBatchReportRunId, SQLCODE, SUBSTR(SQLERRM, 1, 240));
            -- Raise to be caught in the client and skip query execution
            RAISE;

END SetBatchReportRunInProgress;

-- =====================================================================
-- FUNCTION: CreateObjectPrefix
-- DESCRIPTION: Create the Object prefix string:
--              EUL4_BYYMMDDHHMISSQQQQQQQ
--                                123456
FUNCTION CreateObjectPrefix(timeStamp    IN VARCHAR2,
                            batchQueryNo IN NUMBER) RETURN VARCHAR2 IS

BEGIN

    RETURN 'EUL4_B' || timeStamp || 'Q' || batchQueryNo;

END CreateObjectPrefix;

-- =====================================================================
-- FUNCTION: CreateTableName()
-- DESCRIPTION: Create the table name from the formula:
--              EUL4_BATCH <BQ_ID> RUN <BRR_RUN>.
FUNCTION CreateTableName(timeStamp        IN VARCHAR2,
                         batchQueryNo     IN NUMBER,
                         batchReportRunNo IN NUMBER) RETURN VARCHAR2 IS

    tableName VARCHAR2(30);

BEGIN
    tableName := CreateObjectPrefix(timeStamp, batchQueryNo);

    tableName := tableName || 'R' || to_char(batchReportRunNo);

    RETURN tableName;

END CreateTableName;

-- =====================================================================
-- PROCEDURE: CreateTableSQL()
-- DESCRIPTION: Create the result set table from the formula:
PROCEDURE CreateTableSQL(timeStamp        IN VARCHAR2,
                         batchQueryNo     IN NUMBER,
                         batchReportRunNo IN NUMBER,
                         createTableCols  IN VARCHAR2,
                         tableName        OUT VARCHAR2,
                         createTableSQL   OUT VARCHAR2) IS

    locTableName      VARCHAR2(30);
    locCreateTableSQL VARCHAR2(32767);

BEGIN

    locTableName := CreateTableName(timeStamp, batchQueryNo, batchReportRunNo);

    locCreateTableSQL := 'CREATE TABLE ' || locTableName || ' (' || createTableCols || ')';

    tableName := locTableName;
    createTableSQL := locCreateTableSQL;

END CreateTableSQL;

-- =====================================================================
-- PROCEDURE: InsertBatchQueryTable()
-- DESCRIPTION: Insert a new row into Batch Query Table and create the
--              Result Set table
FUNCTION InsertBatchQueryTable(eulSchemaName    IN VARCHAR2,
                               timeStamp        IN VARCHAR2,
                               userName         IN VARCHAR2,
                               batchReportRunId IN NUMBER,
                               batchReportRunNo IN NUMBER,
                               batchQueryId     IN NUMBER,
                               batchQueryNo     IN NUMBER,
                               createTableCols  IN VARCHAR2) RETURN VARCHAR2 IS

    locTableName      VARCHAR2(30);
    locCreateTableSQL VARCHAR2(32767);
    sqlInsert         VARCHAR2(2000);

BEGIN
    -- Create the table SQL
    CreateTableSQL(timeStamp, batchQueryNo, batchReportRunNo, createTableCols, locTableName, locCreateTableSQL);

    -- Add a row into Batch Query Table
    sqlInsert := 'INSERT INTO <EUL_SCHEMA>.eul4_bq_tables(bqt_id, bqt_bq_id, bqt_brr_id, bqt_table_name, bqt_element_state, bqt_created_by, bqt_created_date)' || chr(10) ||
                 'VALUES (<EUL_SCHEMA>.eul4_id_seq.nextval, ' || to_char(batchQueryId) || ', ' || to_char(batchReportRunId) || ', '''
                 || locTableName || ''', 0, USER, SYSDATE)';

    ReplaceEULSchema(eulSchemaName, sqlInsert);

    DynamicExecute(sqlInsert);

    -- DDL - Implicit commit or rollback
    DynamicExecute(locCreateTableSQL);

    RETURN locTableName;

    EXCEPTION
        WHEN OTHERS THEN
            -- No rollback because if create table fails we have an implicit rollback.
            -- If the insert fails we have a statement level rollback.
            SetStatusRunError(eulSchemaName, batchReportRunId, SQLCODE, SUBSTR(SQLERRM, 1, 240));
            -- Raise an exception to be caught by client and skip query execution
            RAISE;

END InsertBatchQueryTable;

-- =====================================================================
-- PROCEDURE: GetViewName()
-- DESCRIPTION: Build the view string based on:
--              EUL4_BATCH <Batch Query Id> VIEW <BSE>/<SUM>
--              The Batch Query Id is unique across the EUL.
FUNCTION GetViewName(timeStamp    IN VARCHAR2,
                     batchQueryNo IN NUMBER,
                     base         IN BOOLEAN) RETURN VARCHAR2 IS

    viewName VARCHAR2(30);

BEGIN
    viewName := CreateObjectPrefix(timeStamp, batchQueryNo);

    IF (base = TRUE) THEN
        viewName := viewName || 'V1';
    ELSE
        viewName := viewName || 'V2';
    END IF;

    RETURN viewName;

END GetViewName;

-- =====================================================================
-- FUNCTION: GetSummaryState()
-- DESCRIPTION: Retrieves the state of the Summary used.
--              If an error occurs, ie the Summary has been deleted an
--              exception will be produced. The failed state (4) is
--              returned.
FUNCTION GetSummaryState(eulSchemaName    IN VARCHAR2,
                         sumoId IN number) RETURN NUMBER IS

    cur    INTEGER;
    ignore INTEGER;

    retState     NUMBER;
    sqlStatement VARCHAR2(2000);

BEGIN
    cur := DBMS_SQL.OPEN_CURSOR;

    sqlStatement := 'SELECT sdo_state'                      || chr(10) ||
                    'FROM <EUL_SCHEMA>.eul4_summary_objs' || chr(10) ||
                    'WHERE sumo_id = ' || to_char(sumoId);

    ReplaceEULSchema(eulSchemaName, sqlStatement);

    DBMS_SQL.PARSE(cur, sqlStatement, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(cur, 1, retState);
    ignore := DBMS_SQL.EXECUTE(cur);
    ignore := DBMS_SQL.FETCH_ROWS(cur);
    DBMS_SQL.COLUMN_VALUE(cur, 1, retState);
    DBMS_SQL.CLOSE_CURSOR(cur);

    RETURN retState;

    -- The row may not exist
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 4;

END GetSummaryState;

-- =====================================================================
-- FUNCTION: UseSummary()
-- DESCRIPTION: If the sumoId is not NULL then we can attempt to execute
--              against a Summary.
--              If an error occurs, ie the Summary has been deleted an
--              exception will be produced. The failed state (4) is
--              returned.
FUNCTION UseSummary(eulSchemaName IN VARCHAR2,
                    sumoId IN NUMBER) RETURN BOOLEAN IS

    summState NUMBER;
BEGIN
    IF sumoId IS NOT NULL THEN
        summState := GetSummaryState(eulSchemaName, sumoId);

        IF (summState = 3) OR (summState = 6) THEN
            RETURN TRUE;
        END IF;
    END IF;

    RETURN FALSE;

END UseSummary;

-- =====================================================================
-- PROCEDURE: TryExecuteQuery()
-- DESCRIPTION: Attempts to execute the query. If a summary can be used
--              then the state is checked. If not valid then goes against
--              base data.
--              If a summary fails then attempts against the base.
-- TRANSACTIONS: Exceptions trapped, and if against base then error status
--               updated and exception raised. If against summary then
--               base data attempted.
PROCEDURE TryExecuteQuery (eulSchemaName      IN VARCHAR2,
                           timeStamp          IN VARCHAR2,
                           batchReportRunId   IN NUMBER,
                           batchQueryId       IN NUMBER,
                           batchQueryNo       IN NUMBER,
                           resultSetTableName IN VARCHAR2,
                           insertStatement    IN VARCHAR2,
                           commitSize         IN NUMBER,
                           rowFetchLimit      IN NUMBER,
                           sumoId             IN NUMBER,
                           summaryUsed        IN BOOLEAN DEFAULT TRUE) IS

    ExceededRow EXCEPTION;
    PRAGMA EXCEPTION_INIT (ExceededRow, -20001);

    querySQL VARCHAR2(32767);

    usedSummary BOOLEAN := summaryUsed;

BEGIN
    querySQL  :=  'DECLARE'                                                                                     || chr(10) ||
                  '   Rows_Processed INTEGER := 0;'                                                             || chr(10) ||
                  '   Exceeded_Row   EXCEPTION;'                                                                || chr(10) ||
                  '   PRAGMA EXCEPTION_INIT (Exceeded_Row, -20001);'                                            || chr(10) ||
                  '   CURSOR c1 IS'                                                                             || chr(10) ||
                  '   SELECT * FROM ';

    IF (usedSummary = TRUE) AND (UseSummary(eulSchemaName, sumoId)) THEN
        -- Attempt to use the Summary
        querySQL := querySQL || GetViewName(timeStamp, batchQueryNo, FALSE);
    ELSE
        usedSummary := FALSE;
        querySQL := querySQL || GetViewName(timeStamp, batchQueryNo, TRUE);
    END IF;

    querySQL := querySQL || ';' || chr(10) ||
                      'BEGIN'                                                                                       || chr(10) ||
                      '   FOR batch_rec IN c1 LOOP'                                                                 || chr(10) ||
                      '       INSERT INTO ' || resultSetTableName || ' VALUES(' || insertStatement ||');'           || chr(10);
    IF (commitSize IS NOT NULL) AND (commitSize > 0) THEN
        querySQL := querySQL ||
                      '       IF MOD(Rows_Processed, ' || to_char(commitSize) || ') = 0 THEN'                       || chr(10) ||
                      '           COMMIT;'                                                                          || chr(10) ||
                      '       END IF;'                                                                              || chr(10);
    END IF;
    IF (rowFetchLimit IS NOT NULL) AND (rowFetchLimit > 0) THEN
        querySQL := querySQL ||
                      '       Rows_Processed := Rows_Processed + 1;'                                             || chr(10) ||
                      '       IF Rows_Processed = ' || to_char(rowFetchLimit) || ' THEN'                         || chr(10) ||
                      '           RAISE Exceeded_Row;'                                                           || chr(10) ||
                      '       END IF;'                                                                           || chr(10);
    END IF;
    querySQL := querySQL ||
                      '   END LOOP;'                                                                                || chr(10) ||
                      '   COMMIT;'                                                                                  || chr(10) ||
                      '   EXCEPTION'                                                                                || chr(10) ||
                      '       WHEN Exceeded_Row THEN'                                                               || chr(10) ||
                      '           ROLLBACK;'                                                                        || chr(10) ||
                      '           RAISE;'                                                                           || chr(10) ||
                      '       WHEN OTHERS THEN'                                                                     || chr(10) ||
                      '           ROLLBACK;'                                                                        || chr(10) ||
                      '           RAISE;'                                                                           || chr(10) ||
                      'END;';

    DynamicExecute(querySQL);
    -- dynamic_execute('BEGIN TST_PROC; END;');

    EXCEPTION
        WHEN ExceededRow THEN
            ROLLBACK;
            SetStatusRowLimit(eulSchemaName, batchReportRunId);
            -- RAISE THE EXCEPTION TO BE CAUGHT IN THE CLIENT
            RAISE;
        WHEN OTHERS THEN
            ROLLBACK;
            IF usedSummary = TRUE THEN
                -- Attempt against the base data
                TryExecuteQuery(eulSchemaName,
                                timeStamp,
                                batchReportRunId,
                                batchQueryId,
                                batchQueryNo,
                                resultSetTableName,
                                insertStatement,
                                commitSize,
                                rowFetchLimit,
                                sumoId,
                                FALSE);
            ELSE
                SetStatusRunError(eulSchemaName, batchReportRunId, SQLCODE, SUBSTR(SQLERRM, 1, 240));
                RAISE;
            END IF;

END TryExecuteQuery;

-- =====================================================================
-- PROCEDURE: ExecuteQuery()
-- DESCRIPTION: This procedure is overloaded. The parameter sumoId defaults
--              to NULL. The procedure will therefore operate against the
--              base object or the Summary Derived object.
PROCEDURE ExecuteQuery(eulSchemaName     IN VARCHAR2,
                       timeStamp         IN VARCHAR2,
                       batchReportRunId  IN NUMBER,
                       batchReportRunNo  IN NUMBER,
                       userName          IN VARCHAR2,
                       batchQueryId      IN NUMBER,
                       batchQueryNo      IN NUMBER,
                       createTableCols   IN VARCHAR2,
                       insertStatement   IN varchar2,
                       commitSize        IN NUMBER,
                       rowFetchLimit     IN NUMBER,
                       sumoId            IN NUMBER := NULL) IS

    resultSetTableName VARCHAR2(30);

BEGIN
    -- Create the table and insert row into the Batch Query Table
    -- One transaction - Exceptions handled within batch_query_table

    resultSetTableName := InsertBatchQueryTable(eulSchemaName,
                                                timeStamp,
                                                userName,
                                                batchReportRunId,
                                                batchReportRunNo,
                                                batchQueryId,
                                                batchQueryNo,
                                                createTableCols);

    -- Try to execute the query
    TryExecuteQuery (eulSchemaName,
                     timeStamp,
                     batchReportRunId,
                     batchQueryId,
                     batchQueryNo,
                     resultSetTableName,
                     insertStatement,
                     commitSize,
                     rowFetchLimit,
                     sumoId);

END ExecuteQuery;

-- =====================================================================
-- FUNCTION: IsRescheduled()
-- DESCRIPTION: Retrieves the schedule information and returns whether
--              the Report is rescheduled.
FUNCTION IsRescheduled(eulSchemaName        IN VARCHAR2,
                       batchReportId        IN NUMBER,
                       refreshFrequencyUnit IN OUT VARCHAR2,
                       numFrequencyUnits    OUT NUMBER,
                       nextRunDate          IN OUT DATE) RETURN BOOLEAN IS

    sqlSelect            VARCHAR2(2000);
    tmpNumFreqUnits      NUMBER(22);
    automaticRefreshFlag NUMBER(1);
    cur                  INTEGER;
    ignore               INTEGER;

BEGIN
    sqlSelect := 'SELECT br.br_num_freq_units, rfu.rfu_sql_expression, br.br_next_run_date,'       || chr(10) ||
		     'br.br_auto_refresh'										  || chr(10) ||
                 'FROM <EUL_SCHEMA>.eul4_batch_reports br, <EUL_SCHEMA>.eul4_freq_units rfu' || chr(10) ||
                 'WHERE br.br_id = ' || to_char(batchReportId)                                          || chr(10) ||
                 'AND br.br_rfu_id = rfu.rfu_id';

    ReplaceEULSchema(eulSchemaName, sqlSelect);

    cur := DBMS_SQL.OPEN_CURSOR;

    DBMS_SQL.PARSE(cur, sqlSelect, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(cur, 1, tmpNumFreqUnits);
    DBMS_SQL.DEFINE_COLUMN(cur, 2, refreshFrequencyUnit, 240);
    DBMS_SQL.DEFINE_COLUMN(cur, 3, nextRunDate);
    DBMS_SQL.DEFINE_COLUMN(cur, 4, automaticRefreshFlag);
    ignore := DBMS_SQL.EXECUTE(cur);
    ignore := DBMS_SQL.FETCH_ROWS(cur);
    DBMS_SQL.COLUMN_VALUE(cur, 1, tmpNumFreqUnits);
    DBMS_SQL.COLUMN_VALUE(cur, 2, refreshFrequencyUnit);
    DBMS_SQL.COLUMN_VALUE(cur, 3, nextRunDate);
    DBMS_SQL.COLUMN_VALUE(cur, 4, automaticRefreshFlag);

    DBMS_SQL.CLOSE_CURSOR(cur);

    numFrequencyUnits := tmpNumFreqUnits;

    refreshFrequencyUnit := REPLACE(refreshFrequencyUnit, '''''', '?');
    refreshFrequencyUnit := REPLACE(refreshFrequencyUnit, '''', '');
    refreshFrequencyUnit := REPLACE(refreshFrequencyUnit, '?', '''');
    refreshFrequencyUnit := REPLACE(refreshFrequencyUnit, '&', ':');

    IF automaticRefreshFlag = 0 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;

END IsRescheduled;

-- =====================================================================
-- PROCEDURE: CalculateNextRunDate()
-- DESCRIPTION: Calculate the next run date based on the refresh
--              frequency unit and the num of units.
--              Time slippage is removed.
PROCEDURE CalculateNextRunDate(refreshFrequencyUnit IN VARCHAR2,
                               numFrequencyUnits    IN NUMBER,
                               calcRunDate          IN OUT DATE) IS

    dateExpression VARCHAR2(2000);
    curDate        INTEGER;
    ignore         INTEGER;
    noRows         INTEGER;

BEGIN

    dateExpression := 'SELECT ' || refreshFrequencyUnit || ' FROM DUAL';

    curDate := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(curDate, dateExpression, DBMS_SQL.V7);
    DBMS_SQL.DEFINE_COLUMN(curDate, 1, calcRunDate);

    LOOP
        DBMS_SQL.BIND_VARIABLE(curDate, 'bind_num_units', numFrequencyUnits);
        DBMS_SQL.BIND_VARIABLE(curDate, 'bind_date', calcRunDate);
        ignore := DBMS_SQL.EXECUTE(curDate);

        noRows := DBMS_SQL.FETCH_ROWS(curDate);
        DBMS_SQL.COLUMN_VALUE(curDate, 1, calcRunDate);

        IF (calcRunDate > SYSDATE) THEN
            EXIT;
        END IF;
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR(curDate);

END CalculateNextRunDate;

-- =====================================================================
-- PROCEDURE: InsertBatchReportRunSubmitted()
-- DESCRIPTION: Inserts a new batch report run and set status to Submitted.
PROCEDURE InsertBatchReportRunSubmitted(eulSchemaName IN VARCHAR2,
                                        batchReportId IN NUMBER,
                                        currentbatchReportRunNo IN NUMBER) IS

    batchReportRunId     NUMBER(22);
    nextBatchReportRunNo NUMBER;
    sqlInsert            VARCHAR2(2000);

BEGIN
    nextBatchReportRunNo := currentbatchReportRunNo + 1;

    sqlInsert := 'INSERT INTO <EUL_SCHEMA>.eul4_br_runs'      || chr(10) ||
                 '(brr_id, brr_br_id, brr_run_number, brr_state, brr_element_state, brr_created_by, brr_created_date)'      || chr(10) ||
                 'VALUES(<EUL_SCHEMA>.eul4_id_seq.nextval,'                          || chr(10) ||
                         batchReportId || ','                          || chr(10) ||
                         nextBatchReportRunNo || ','                   || chr(10) ||
                         BATCH_STATE_SUBMITTED || ',0,USER,SYSDATE)';

    ReplaceEULSchema(eulSchemaName, sqlInsert);

    DynamicExecute(sqlInsert);

END;

-- =====================================================================
-- PROCEDURE: SubmitJob()
-- DESCRIPTION: Submit the package to the job queue.
--              If client is calling this then the job no will have to
--              be updated.
PROCEDURE SubmitJob(jobNo         OUT NUMBER,
                    timeStamp     IN VARCHAR2,
                    runDate       IN DATE) IS

    packageSQL    VARCHAR2(50);

    newDate DATE;
BEGIN
    -- Create the package string - EUL4_BATCH_PACKAGE <Batch Report Id>.EXECUTE;
    packageSQL := 'EUL4_BATCH_PACKAGE' || timeStamp || '.RUN;';

    -- Submit the Job
    DBMS_JOB.SUBMIT(jobNo,
                    packageSQL,
                    runDate);

END SubmitJob;

-- =====================================================================
-- PROCEDURE: RemoveJob()
-- DESCRIPTION: Remove the associated job from the job queue.
--              Client will have to remove job no from the Batch Report.
--              Exceptions to be trapped in the client
PROCEDURE RemoveJob(jobNo            IN NUMBER,
                    handleExceptions IN BOOLEAN := FALSE) IS

BEGIN

    -- Remove the job
    DBMS_JOB.REMOVE(jobNo);

EXCEPTION
    WHEN OTHERS THEN
        IF (handleExceptions = TRUE) THEN
            RETURN;
        END IF;

        RAISE;

END RemoveJob;

-- =====================================================================
-- PROCEDURE: SetNextDate()
-- DESCRIPTION: Change the next run date of a job.
PROCEDURE SetNextDate(jobNo    IN NUMBER,
                      nextDate IN DATE) IS
BEGIN

    DBMS_JOB.NEXT_DATE(jobNo, nextDate);

END SetNextDate;

-- =====================================================================
-- PROCEDURE: ScheduleRun()
-- DESCRIPTION: Schedule the next run.
PROCEDURE ScheduleRun(eulSchemaName    IN VARCHAR2,
                      timeStamp        IN VARCHAR2,
                      batchReportId    IN NUMBER,
                      batchReportRunId IN NUMBER,
                      batchReportRunNo IN NUMBER,
                      error            IN BOOLEAN,
                      startDate        IN DATE) IS

    numFrequencyUnits    NUMBER(22);
    refreshFrequencyUnit VARCHAR2(240);
    nextRunDate          DATE;
    jobNo                NUMBER(22);

BEGIN

    IF (IsRescheduled(eulSchemaName, batchReportId, refreshFrequencyUnit, numFrequencyUnits, nextRunDate)
        = FALSE) THEN
        IF (error = FALSE) THEN
            SetStatusReady(eulSchemaName, batchReportRunId);
            COMMIT;
        END IF;

        SetBatchReportCompletionInfo(eulSchemaName,
                                     batchReportId,
                                     batchReportRunId,
                                     StartDate);
        -- Do not resubmit - END OF PROCESSING
        RETURN;
    END IF;

    -- Scheduled report

    -- Calc the next run date

    CalculateNextRunDate(refreshFrequencyUnit, numFrequencyUnits, nextRunDate);

    -- TRANSACTION - On error delete the job from Job Queue
    BEGIN
        -- Submit the package for reschedule

        SubmitJob(jobNo, timeStamp, nextRunDate);

        -- Insert a new Batch Report Run with status of Submitted
        InsertBatchReportRunSubmitted(eulSchemaName, batchReportId, batchReportRunNo);

        IF (error = FALSE) THEN
            SetStatusReady(eulSchemaName, batchReportRunId);
        END IF;

        -- Set the Job No
        -- Exception handling flag set to TRUE
        SetBatchReportCompletionInfo(eulSchemaName,
                                     batchReportId,
                                     batchReportRunId,
                                     startDate,
                                     TRUE,
                                     nextRunDate,
                                     jobNo);

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            -- Remove the Job from the job queue and handle exceptions
            RemoveJob(jobNo, TRUE);

            -- Attempt to update the completion information
            SetBatchReportCompletionInfo(eulSchemaName,
                                         batchReportId,
                                         batchReportRunId,
                                         StartDate);
            -- Set to submission error
            SetStatusSubmissionError(eulSchemaName, batchReportRunId);
    END;

END ScheduleRun;

-- =====================================================================
-- PROCEDURE: GetVersion()
-- DESCRIPTION: Returns the current version of the package for upgrade
--              purposes.
PROCEDURE GetVersion(version OUT NUMBER) IS
BEGIN

    version := 312;

END GetVersion;

END EUL4_BATCH_USER;
/


