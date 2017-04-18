CREATE OR REPLACE PACKAGE CPI.giac_upload_prem_dtl_pkg
AS
   PROCEDURE upload_excel_type1 (
      p_payor             IN   VARCHAR2,
      p_policy_no         IN   VARCHAR2,
      p_fcollection_amt   IN   VARCHAR2,
      p_pay_mode          IN   VARCHAR2,
      p_check_class       IN   VARCHAR2,
      p_check_no          IN   VARCHAR2,
      p_check_date        IN   VARCHAR2,
      p_bank              IN   VARCHAR2,
      p_payment_date      IN   VARCHAR2,
      p_currency_cd       IN   VARCHAR2,
      p_convert_rate      IN   VARCHAR2
   );

   PROCEDURE chk_pol_no (
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_endt_iss_cd   VARCHAR2
   );
   
   PROCEDURE chk_pay_mode (
      p_pay_mode	  giac_upload_prem_dtl.pay_mode%TYPE,
      p_bank          giac_upload_prem_dtl.bank%TYPE,
      p_check_class   giac_upload_prem_dtl.check_class%TYPE,
      p_check_no      giac_upload_prem_dtl.check_no%TYPE,
      p_check_date    giac_upload_prem_dtl.check_date%TYPE
   );
   
END;
/


