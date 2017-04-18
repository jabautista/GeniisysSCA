CREATE OR REPLACE PACKAGE CPI.giac_batch_dv_dtl_pkg
AS
/******************************************************************************
   NAME:       giac_batch_dv_dtl_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/26/2011  Irwin Tabisora           1. Created this package.
******************************************************************************/
   PROCEDURE set_giac_batch_dv_dtl (
      P_batch_dv_id   giac_batch_dv_dtl.batch_dv_id%TYPE,
      P_claim_id      giac_batch_dv_dtl.claim_id%TYPE,
      P_advice_id     giac_batch_dv_dtl.advice_id%TYPE,
      P_branch_cd     giac_batch_dv_dtl.branch_cd%TYPE,
      P_paid_amt      giac_batch_dv_dtl.paid_amt%TYPE,
      P_clm_loss_id   giac_batch_dv_dtl.clm_loss_id%TYPE
   );
END giac_batch_dv_dtl_pkg;
/


