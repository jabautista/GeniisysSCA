DROP PROCEDURE CPI.IMPORT_TABLE;

CREATE OR REPLACE PROCEDURE CPI.import_table (v_user_name 	VARCHAR2,
	   			 			   v_password	VARCHAR2,
							   v_from_dbase	VARCHAR2,
							   v_target_tab	VARCHAR2) IS

BEGIN

Do_Ddl('TRUNCATE TABLE V_TARGET_TAB');

--
copy FROM v_user_name/v_password@v_from_dbase -
INSERT v_target_tab -
 USING -
SELECT * -
  FROM v_target_tab;

END;
/

DROP PROCEDURE CPI.IMPORT_TABLE;


