/*
**  Created By   : Benjo Brito
**  Date Created : 08.08.2016
**  Description  : RSIC-SR-22839
*/
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
SPOOL C:\GENIISYS_WEB\record_backup\GIIS_PAYEES_22839-&sysdate

SELECT *
  FROM giis_payees
 WHERE payee_no IN (SELECT ri_cd
                      FROM giis_reinsurer
                     WHERE ri_tin IS NOT NULL)
   AND payee_class_cd = giacp.v ('RI_CLASS_CD');

SPOOL OFF;

----------------------------------------------------------------------------

BEGIN
   FOR i IN (SELECT ri_cd, ri_name, ri_tin
               FROM giis_reinsurer
              WHERE ri_tin IS NOT NULL)
   LOOP
      UPDATE giis_payees
         SET tin = i.ri_tin
       WHERE payee_class_cd = giacp.v ('RI_CLASS_CD') AND payee_no = i.ri_cd;
   END LOOP;

   COMMIT;
END;