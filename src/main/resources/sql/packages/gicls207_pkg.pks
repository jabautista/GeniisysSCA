CREATE OR REPLACE PACKAGE CPI.gicls207_pkg
AS
   TYPE batch_os_type IS RECORD (
      tran_date        VARCHAR2(20),
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      tran_id          giac_acctrans.tran_id%TYPE,
      tran_class       giac_acctrans.tran_class%TYPE
   );

   TYPE batch_os_tab IS TABLE OF batch_os_type;

   TYPE loss_exp_type IS RECORD (
      tran_id           giac_acctrans.tran_id%TYPE,
      extract_tran_id   giac_acctrans.tran_id%TYPE,
      tag               VARCHAR2 (1),
      msg               VARCHAR2 (100)
   );

   TYPE loss_exp_tab IS TABLE OF loss_exp_type;

   FUNCTION get_batch_os_records (p_user_id giis_users.user_id%TYPE)
      RETURN batch_os_tab PIPELINED;

   FUNCTION validate_loss_exp (
      p_user_id   giis_users.user_id%TYPE,
      p_tran_id   gicl_clm_res_hist.tran_id%TYPE
   )
      RETURN loss_exp_tab PIPELINED;

   PROCEDURE extract_os_detail (p_tran_id gicl_clm_res_hist.tran_id%TYPE);
END;
/


