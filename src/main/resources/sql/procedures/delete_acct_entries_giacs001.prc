DROP PROCEDURE CPI.DELETE_ACCT_ENTRIES_GIACS001;

CREATE OR REPLACE PROCEDURE CPI.delete_acct_entries_giacs001 (
   p_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
   p_gen_type       giac_modules.generation_type%TYPE
)
IS
   dummy   VARCHAR2 (1);

   CURSOR ae
   IS
      SELECT '1'
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_gacc_tran_id AND generation_type = p_gen_type;
BEGIN
   OPEN ae;

   FETCH ae
    INTO dummy;

   IF SQL%FOUND
   THEN
   
    /**************************************************************************
    *                                                                         *
    * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
    * tran_id as :GLOBAL.cg$giop_gacc_tran_id.                                *
    *                                                                         *
    **************************************************************************/
      DELETE FROM giac_acct_entries
            WHERE gacc_tran_id = p_gacc_tran_id
              AND generation_type = p_gen_type;
   END IF;
END;
/


