CREATE OR REPLACE PACKAGE CPI.EUL4_BATCH_USER AS

FUNCTION IsReportValid(eulSchemaName IN VARCHAR2,
                       batchReportId IN NUMBER) RETURN BOOLEAN;

PROCEDURE GetUserLimits(eulSchemaName IN VARCHAR2,
                        batchReportId IN NUMBER,
                        userName      OUT VARCHAR2,
                        commitSize    OUT NUMBER,
                        rowFetchLimit OUT NUMBER);

PROCEDURE SetExpiredRuns(eulSchemaName IN VARCHAR2,
                         userName      IN VARCHAR2);

PROCEDURE SetBatchReportRunInProgress(eulSchemaName    IN VARCHAR2,
                                      batchReportId    IN NUMBER,
                                      batchReportRunNo OUT NUMBER,
                                      batchReportRunId OUT NUMBER);

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
                       sumoId            IN NUMBER := NULL);

PROCEDURE ScheduleRun(eulSchemaName    IN VARCHAR2,
                      timeStamp        IN VARCHAR2,
                      batchReportId    IN NUMBER,
                      batchReportRunId IN NUMBER,
                      batchReportRunNo IN NUMBER,
                      error            IN BOOLEAN,
                      startDate        IN DATE);

-- A D M I N I S T R A T O R   M E T H O D S
PROCEDURE SubmitJob(jobNo         OUT NUMBER,
                    timeStamp     IN VARCHAR2,
                    runDate       IN DATE);

PROCEDURE RemoveJob(jobNo            IN NUMBER,
                    handleExceptions IN BOOLEAN := FALSE);

PROCEDURE SetNextDate(jobNo    IN NUMBER,
                      nextDate IN DATE);

PROCEDURE GetVersion(version OUT NUMBER);

END EUL4_BATCH_USER;
/


