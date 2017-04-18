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
SPOOL C:\GENIISYS_WEB\record_backup\giuw_pol_dist-takeup_seq_no-5662-&sysdate

SELECT *
  FROM giuw_pol_dist
 WHERE takeup_seq_no IS NULL;

SPOOL OFF;

----------------------------------------------------------------------------

BEGIN
  UPDATE giuw_pol_dist
     SET takeup_seq_no = 1
   WHERE takeup_seq_no IS NULL;
   
  COMMIT;   
END;
/