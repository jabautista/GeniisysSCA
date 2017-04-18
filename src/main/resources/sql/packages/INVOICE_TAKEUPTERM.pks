/* Formatted on 2/10/2016 3:29:11 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE PACKAGE CPI.INVOICE_TAKEUPTERM
AS
   TYPE incept_exp_list_type IS RECORD
   (
      incept_date   gipi_polbasic.incept_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      
      --mikel 06.09.2016; UCPBGEN 22527
      eff_date           gipi_polbasic.incept_date%TYPE,
      endt_exp_date      gipi_polbasic.endt_expiry_date%TYPE,
      prev_incept_date   gipi_polbasic.incept_date%TYPE,
      prev_expiry_date   gipi_polbasic.expiry_date%TYPE 
   );

   TYPE incept_exp_list_tab IS TABLE OF incept_exp_list_type;

   FUNCTION latest_incept_expiry_date (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.line_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_ext_mm_yy     VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN incept_exp_list_tab
      PIPELINED;

   FUNCTION get_eff_date (p_policy_id        gipi_invoice.policy_id%TYPE,
                          p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
                          p_ext_mm_yy        VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN DATE;

   FUNCTION get_exp_date (p_policy_id        gipi_invoice.policy_id%TYPE,
                          p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
                          p_ext_mm_yy        VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN DATE;
   
   --mikel 06.09.2016; UCPBGEN 22527
   FUNCTION get_inc_date (p_policy_id        gipi_invoice.policy_id%TYPE,
                          p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
                          p_ext_mm_yy        VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN DATE;   
END;
/