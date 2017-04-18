CREATE OR REPLACE PACKAGE CPI.giacs116_pkg
AS
   TYPE amla_dtl_type IS RECORD (
      seq_no             NUMBER (12),
      branch_cd          giac_branches.branch_cd%TYPE,
      tran_date          VARCHAR2 (8),
      tran_type          VARCHAR2 (5),
      ref_no             VARCHAR2 (20),
      client_type        VARCHAR2 (1),
      local_amt          NUMBER (18, 2),
      foreign_amt        NUMBER (15, 2),
      currency_sname     giis_currency.short_name%TYPE,
      payor_type         VARCHAR2 (1),
      corporate_name     VARCHAR2 (90),
      last_name          VARCHAR2 (30),
      first_name         VARCHAR2 (30),
      middle_name        VARCHAR2 (30),
      address1           VARCHAR2 (50),		--(30), --modified by Mark C. 07142015, from 30 to 50
      address2           VARCHAR2 (50),		--(30), --modified by Mark C. 07142015, from 30 to 50
      address3           VARCHAR2 (30),
      birthdate          VARCHAR2 (8),
         
      policy_no			 VARCHAR2 (40),
      eff_date			 VARCHAR2 (8),
      expiry_date		 VARCHAR2 (8), 		-- added by Mark C. 07132015
      tsi_amt            NUMBER (12), --added by gab 04.08.2016 SR 21922
      fc_tsi_amt        NUMBER (12) --added by gab 04.26.2016 SR 21922
   );

   TYPE amla_dtl_tab IS TABLE OF amla_dtl_type;

   FUNCTION get_amla_details (
      p_from_date    giac_acctrans.tran_date%TYPE,
      p_to_date      giac_acctrans.tran_date%TYPE--,
      --p_tran_class   giac_acctrans.tran_class%TYPE
   )
      RETURN amla_dtl_tab PIPELINED;
   PROCEDURE get_payor_dtl (
   	  p_assd_no             IN      gipi_polbasic.assd_no%TYPE,
      --p_payor               IN      giac_order_of_payts.payor%TYPE,
      --p_address             IN      VARCHAR2,
      --p_class_cd            IN      giac_payt_requests_dtl.payee_class_cd%TYPE,
      --p_payee_cd            IN      giac_payt_requests_dtl.payee_cd%TYPE,
      p_payor_type          OUT     VARCHAR2,
      p_corporate_name      OUT     VARCHAR2,
      p_last_name           OUT     VARCHAR2,
      p_first_name          OUT     VARCHAR2,
      p_middle_name         OUT     VARCHAR2,
      p_address1            OUT     VARCHAR2,
      p_address2            OUT     VARCHAR2,
      p_address3            OUT     VARCHAR2,
      p_birthdate           OUT     VARCHAR2
   );
   
   PROCEDURE insert_amla_ext(
      p_from_date       IN    giac_acctrans.tran_date%TYPE,
      p_to_date         IN    giac_acctrans.tran_date%TYPE,
      --p_tran_class      IN    giac_acctrans.tran_class%TYPE,
      p_user_id         IN    giis_users.user_id%TYPE, --added by gab 04.18.2016 SR 21922
      p_count           OUT   NUMBER,
      p_sum_amount      OUT   NUMBER
   );

-- Mark C. 07142015, add procedure specs use to retrieve various policy info
   PROCEDURE get_pol_dtl (
      p_line_cd       IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      IN       gipi_polbasic.renew_no%TYPE,
      p_eff_date      OUT      VARCHAR2,
      p_expiry_date   OUT      VARCHAR2,
      p_loc_prem      OUT      NUMBER,
      p_for_prem      OUT      NUMBER,
      p_loc_tsi       OUT      NUMBER, --added by gab 05.02.2016 SR 21922
      p_for_tsi       OUT      NUMBER --added by gab 05.02.2016 SR 21922
   );

-- Mark C. 07142015, added function specs use to get premium of policy and endts.
   FUNCTION get_prem_amt (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER;   
END;
/


