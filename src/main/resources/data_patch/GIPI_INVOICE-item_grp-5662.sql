SET DEFINE ON
SET colsep ','
SET echo off
SET feedback off
SET linesize 10000
SET sqlprompt ''
SET trimspool on
SET headsep off
COLUMN dcol new_value SYSDATE noprint
SELECT TO_CHAR (SYSDATE, 'mmddyyyyhhmm') dcol
  FROM DUAL;
SPOOL C:\GENIISYS_WEB\record_backup\gipi_invoice-item_grp-5662-&sysdate

SELECT *
  FROM gipi_invoice
 WHERE item_grp IS NULL;

SPOOL OFF;

----------------------------------------------------------------------------

BEGIN
  UPDATE gipi_invoice
     SET item_grp = 1
   WHERE item_grp IS NULL;
   
  COMMIT;   
END;
/