CREATE OR REPLACE PACKAGE CPI.AMLA_COVERED_TRANSACTION_PKG
AS
   TYPE transaction_detail_type IS RECORD (
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE
   );

   TYPE transaction_detail_tab IS TABLE OF transaction_detail_type;

   TYPE amla_dtl_type IS RECORD (
      seq_no           NUMBER (12),
      branch_cd        giac_branches.branch_cd%TYPE,
      tran_date        VARCHAR2 (8),
      tran_type        VARCHAR2 (5),
      ref_no           VARCHAR2 (20),
      client_type      VARCHAR2 (1),
      local_amt        NUMBER (18, 2),
      foreign_amt      NUMBER (15, 2),
      currency_sname   giis_currency.short_name%TYPE,
      payor_type       VARCHAR2 (1),
      corporate_name   VARCHAR2 (90),
      last_name        VARCHAR2 (30),
      first_name       VARCHAR2 (30),
      middle_name      VARCHAR2 (30),
      address1         VARCHAR2 (50),           --(30), --modified by Mark C. 07142015, from 30 to 50
      address2         VARCHAR2 (50),           --(30), --modified by Mark C. 07142015, from 30 to 50
      address3         VARCHAR2 (30),
      birthdate        VARCHAR2 (8),
      
      policy_no		   VARCHAR2 (40),
      expiry_date	   VARCHAR2 (8),
      eff_date		   VARCHAR2 (8),  --added by Mark C. 07132015
      tsi_amt          NUMBER (12), --added by gab 04.08.2016 SR 21922
      fc_tsi_amt        NUMBER (12) --added by gab 04.26.2016 SR 21922
   );

   TYPE amla_dtl_tab IS TABLE OF amla_dtl_type;

   FUNCTION get_amla_details (
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE
   )
      RETURN amla_dtl_tab PIPELINED;

   PROCEDURE delete_amla_ext (p_user_id IN giis_users.user_id%TYPE);

   PROCEDURE insert_amla_ext (
      p_from_date    IN       VARCHAR2,
      p_to_date      IN       VARCHAR2,
      --p_tran_class   IN       giac_acctrans.tran_class%TYPE,
      p_user_id      IN       giis_users.user_id%TYPE,
      p_count        OUT      NUMBER,
      p_sum_amount   OUT      NUMBER  
   );
END AMLA_COVERED_TRANSACTION_PKG;
/


