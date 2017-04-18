DROP PROCEDURE CPI.AEG_DELETE_ACCT_ENTRIES_N;

CREATE OR REPLACE PROCEDURE CPI.aeg_delete_acct_entries_n (
   p_gen_type            giac_modules.generation_type%TYPE,
   p_giop_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE
)
IS
BEGIN
---- message('AEG_Delete_Acct_Entries...N');

   /**************************************************************************
   *                                                                         *
   * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
   * tran_id as :GLOBAL.cg$giop_gacc_tran_id.                                *
   *                                                                         *
   **************************************************************************/
   FOR ae IN (SELECT 'x'
                FROM giac_acct_entries
               WHERE ROWNUM <= 1          -- at least one rec should be check
                 AND generation_type = p_gen_type
                 AND gacc_tran_id = p_giop_gacc_tran_id)
   LOOP
      DELETE FROM giac_acct_entries
            WHERE gacc_tran_id = p_giop_gacc_tran_id
              AND generation_type = p_gen_type;

      EXIT;
   END LOOP;
END;
/


