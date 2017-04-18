DROP PROCEDURE CPI.AEG_DELETE_ACCT_ENT_GIACS019;

CREATE OR REPLACE PROCEDURE CPI.AEG_Delete_Acct_Ent_GIACS019(
	   	  		  p_gacc_tran_id  			giac_order_of_payts.gacc_tran_id%TYPE,
				  p_gen_type			 giac_modules.generation_type%TYPE					
)
 IS
  dummy  VARCHAR2(1);
  cursor AE is
    SELECT '1'
      FROM giac_acct_entries
     WHERE gacc_tran_id    = p_gacc_tran_id
       AND generation_type = p_gen_type;
BEGIN
  OPEN ae;
  FETCH ae INTO dummy;
  IF sql%found THEN

    delete FROM giac_acct_entries
          WHERE gacc_tran_id    = p_gacc_tran_id
            AND generation_type = p_gen_type;
  END IF;
END;
/


