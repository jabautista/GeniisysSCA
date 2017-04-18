DROP PROCEDURE CPI.AEG_DELETE_ENTRIES_REV;

CREATE OR REPLACE PROCEDURE CPI.AEG_Delete_Entries_Rev (
	   	  		  p_acc_tran_id    giac_acctrans.tran_id%TYPE,
	   	  		  p_gen_type   giac_modules.generation_type%TYPE
)
IS

  dummy  VARCHAR2(1);
  CURSOR AE IS
    SELECT '1'
      FROM giac_acct_entries
     WHERE gacc_tran_id    = p_acc_tran_id
       AND generation_type = p_gen_type;

BEGIN

  OPEN ae;
  FETCH ae INTO dummy;
  IF dummy IS NOT NULL THEN
     DELETE FROM giac_acct_entries
           WHERE gacc_tran_id    = p_acc_tran_id
             AND generation_type = p_gen_type;
     --FORMS_DDL('COMMIT');       
  END IF;

END;
/


