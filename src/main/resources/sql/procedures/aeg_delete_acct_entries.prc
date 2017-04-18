DROP PROCEDURE CPI.AEG_DELETE_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.aeg_delete_acct_entries (
   p_tran_id     IN   giac_acctrans.tran_id%TYPE,
   p_branch_cd   IN   giac_acctrans.gibr_branch_cd%TYPE,
   p_gen_type         giac_modules.generation_type%TYPE
)
IS
/*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  12.26.2011
   **  Reference By : (GICLS086 - Special Claim Settlement Request)
   **  Description  : Executes aeg_delete_acct_entries
   **                program unit in GICLS086
   **
   */
   dummy   VARCHAR2 (1);

   CURSOR ae
   IS
      SELECT '1'
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_tran_id
         AND gacc_gibr_branch_cd = p_branch_cd
         AND generation_type = p_gen_type;
BEGIN
   OPEN ae;

   FETCH ae
    INTO dummy;

   IF SQL%FOUND
   THEN
--message('AEG_Delete_Acct_Entries...');
    /**************************************************************************
    *                                                                         *
    * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
    * tran_id as p_tran_id.                                                   *
    *                                                                         *
    **************************************************************************/
      DELETE FROM giac_acct_entries
            WHERE gacc_tran_id = p_tran_id
              AND gacc_gibr_branch_cd = p_branch_cd
              AND generation_type = p_gen_type;
   END IF;
END;
/


