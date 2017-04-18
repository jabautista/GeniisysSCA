CREATE OR REPLACE PACKAGE CPI.CSV_24TH_METHOD
AS
    --Added by Carlo Rubenecia 04.07.2016 SR-5490 -START
   TYPE detailed_list_type IS RECORD
   (
      company_name         giis_parameters.param_value_v%TYPE,
      company_address      giis_parameters.param_value_v%TYPE,
      cf_date              VARCHAR2(100),
      branch               VARCHAR2(30),
      line_name            VARCHAR2(30),
      extract_year         giac_deferred_gross_prem_pol.extract_year%TYPE,
      extract_mm           giac_deferred_gross_prem_pol.extract_mm%TYPE,
      iss_cd               giac_deferred_gross_prem_pol.iss_cd%TYPE,
      line_cd              giac_deferred_gross_prem_pol.line_cd%TYPE,
      policy_no            giac_deferred_gross_prem_pol.policy_no%TYPE,
      eff_date             giac_deferred_gross_prem_pol.eff_date%TYPE,
      expiry_date          giac_deferred_gross_prem_pol.expiry_date%TYPE,
      amount               giac_deferred_gross_prem_pol.prem_amt%TYPE,
      numerator_factor     giac_deferred_gross_prem_pol.numerator_factor%TYPE,
      denominator_factor   giac_deferred_gross_prem_pol.denominator_factor%TYPE,
      deferred_amount      giac_deferred_gross_prem_pol.def_prem_amt%TYPE
   );

   TYPE detailed_list_tab IS TABLE OF detailed_list_type;
   FUNCTION GIACR045 (p_report_type    VARCHAR2,
                      p_extract_year    giac_deferred_extract.year%TYPE,
                      p_extract_mm      giac_deferred_extract.mm%TYPE)
      RETURN detailed_list_tab
      PIPELINED;
      
   TYPE csv_giacr045_type IS RECORD
   (
      extract_year         giac_deferred_gross_prem_pol.extract_year%TYPE,
      extract_mm           giac_deferred_gross_prem_pol.extract_mm%TYPE,
      iss_cd               giac_deferred_gross_prem_pol.iss_cd%TYPE,
      line_cd              giac_deferred_gross_prem_pol.line_cd%TYPE,
      policy_no            giac_deferred_gross_prem_pol.policy_no%TYPE,
      eff_date             VARCHAR2(30),
      expiry_date          VARCHAR2(30),
      amount               VARCHAR2(50),
      numerator_factor     giac_deferred_gross_prem_pol.numerator_factor%TYPE,
      denominator_factor   giac_deferred_gross_prem_pol.denominator_factor%TYPE,
      deferred_amount      VARCHAR2(50)
   );
   
   TYPE csv_giacr045_tab IS TABLE OF csv_giacr045_type;  
   FUNCTION CSV_GIACR045 (p_report_type    VARCHAR2,
                      p_extract_year    giac_deferred_extract.year%TYPE,
                      p_extract_mm      giac_deferred_extract.mm%TYPE)
      RETURN csv_giacr045_tab
      PIPELINED;
 --Added by Carlo Rubenecia 04.07.2016 SR-5490 -END

   PROCEDURE pop_dynamic_obj (p_report_type       IN     VARCHAR2,
                              p_dtl_table         IN OUT VARCHAR2,
                              p_amount            IN OUT VARCHAR2,
                              p_deferred_amount   IN OUT VARCHAR2);
    
--Added by Carlo de guzman 03.10.20169 SR-5344 -Start                                    
    TYPE giacr044r_record_type IS RECORD (
        transaction_class        VARCHAR2(500),
        gl_account_no             VARCHAR2(100),
        gl_account_name        giac_chart_of_accts.gl_acct_name%TYPE,
        debit_amount           VARCHAR2(50),
        credit_amount          VARCHAR2(50)
    );

    TYPE giacr044r_record_tab IS TABLE OF giacr044r_record_type;      
    FUNCTION csv_giacr044R(
        p_mm          NUMBER,
        p_year        NUMBER,
        p_branch_cd   VARCHAR2
    )
    RETURN giacr044r_record_tab PIPELINED; 
--Added by Carlo de guzman 03.10.20169 SR-5344 -End

--Added by Carlo de guzman 03.10.20169 SR-5343 -Start                   
    TYPE giacr044_record_type IS RECORD (
        transaction_class         VARCHAR2(500),
        gl_account_no              VARCHAR2(100),
        gl_account_name         giac_chart_of_accts.gl_acct_name%TYPE,
        debit_amount            VARCHAR2(50),
        credit_amount           VARCHAR2(50),
        balance_amount          VARCHAR2(50)
    );

    TYPE giacr044_record_tab IS TABLE OF giacr044_record_type;      
    FUNCTION csv_giacr044 (
        p_mm          NUMBER,
        p_year        NUMBER,
        p_branch_cd   VARCHAR2)
        
    RETURN giacr044_record_tab PIPELINED;
--Added by Carlo de guzman 03.10.20169 SR-5343 -End     
                           
END;
/
