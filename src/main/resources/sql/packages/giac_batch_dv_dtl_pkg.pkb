CREATE OR REPLACE PACKAGE BODY CPI.giac_batch_dv_dtl_pkg
AS
/******************************************************************************
   NAME:       giac_batch_dv_dtl_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/26/2011   Irwin Tabisora          1. Created this package.
******************************************************************************/
   PROCEDURE set_giac_batch_dv_dtl (
      p_batch_dv_id   giac_batch_dv_dtl.batch_dv_id%TYPE,
      p_claim_id      giac_batch_dv_dtl.claim_id%TYPE,
      p_advice_id     giac_batch_dv_dtl.advice_id%TYPE,
      p_branch_cd     giac_batch_dv_dtl.branch_cd%TYPE,
      p_paid_amt      giac_batch_dv_dtl.paid_amt%TYPE,
      p_clm_loss_id   giac_batch_dv_dtl.clm_loss_id%TYPE
   )
   IS
   BEGIN
      INSERT INTO giac_batch_dv_dtl
                  (batch_dv_id, claim_id, advice_id, branch_cd,
                   paid_amt, clm_loss_id
                  )
           VALUES (p_batch_dv_id, p_claim_id, p_advice_id, p_branch_cd,
                   p_paid_amt, p_clm_loss_id
                  );
   END;
END giac_batch_dv_dtl_pkg;
/


