CREATE OR REPLACE PACKAGE CPI.giacr329_pkg
AS
   TYPE giacr329_type IS RECORD (
      iss_cd            VARCHAR2 (20),
      iss_name          giis_issource.iss_name%TYPE,   
      col_header1       giac_soa_title.col_title%TYPE,
      col_header2       giac_soa_title.col_title%TYPE,  
      col_header3       giac_soa_title.col_title%TYPE, 
      col_header4       giac_soa_title.col_title%TYPE,
      col_header5       giac_soa_title.col_title%TYPE, 
      col_header6       giac_soa_title.col_title%TYPE,
      col_header7       giac_soa_title.col_title%TYPE,
      col_header8       giac_soa_title.col_title%TYPE,
      sum_col_header1   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header2   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header3   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header4   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header5   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header6   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header7   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_col_header8   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      agent_code        VARCHAR2 (100),
      intm_name         giac_aging_prem_rep_ext.intm_name%TYPE,
      afterdate_coll    giac_aging_prem_rep_ext.afterdate_coll%TYPE,
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      date_title        VARCHAR2 (100)
   );

   TYPE giacr329_tab IS TABLE OF giacr329_type;

   FUNCTION get_giacr329_details (
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_intm_type    giac_aging_prem_rep_ext.intm_type%TYPE,
      p_intm_no      giac_aging_prem_rep_ext.intm_no%TYPE,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE
   )
      RETURN giacr329_tab PIPELINED;
      
   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_datesformula (
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE
   )
      RETURN VARCHAR2;
   
   FUNCTION get_afterdate_coll (
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_agent_code   VARCHAR2,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE
   ) 
      RETURN NUMBER;
      
   TYPE main_type IS RECORD(
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      date_title        VARCHAR2 (100)
   );
   TYPE main_tab IS TABLE OF main_type;      

   TYPE column_type IS RECORD(
      col_no         giac_soa_title.col_no%TYPE,
      col_title      giac_soa_title.col_title%TYPE
   );
   TYPE column_tab IS TABLE OF column_type;
   
   TYPE header_type IS RECORD(
      dummy          NUMBER,
      col_no1        giac_soa_title.col_no%TYPE,
      col_title1     giac_soa_title.col_title%TYPE,
      col_no2        giac_soa_title.col_no%TYPE,
      col_title2     giac_soa_title.col_title%TYPE,
      col_no3        giac_soa_title.col_no%TYPE,
      col_title3     giac_soa_title.col_title%TYPE,
      col_no4        giac_soa_title.col_no%TYPE,
      col_title4     giac_soa_title.col_title%TYPE,
      col_no5        giac_soa_title.col_no%TYPE,
      col_title5     giac_soa_title.col_title%TYPE,
      col_no6        giac_soa_title.col_no%TYPE,
      col_title6     giac_soa_title.col_title%TYPE,
      col_no7        giac_soa_title.col_no%TYPE,
      col_title7     giac_soa_title.col_title%TYPE,
      col_no8        giac_soa_title.col_no%TYPE,
      col_title8     giac_soa_title.col_title%TYPE
   );
   TYPE header_tab IS TABLE OF header_type;
   
   TYPE rec_type IS RECORD (
      iss_cd            VARCHAR2 (20),
      iss_name          giis_issource.iss_name%TYPE, --Dren 05.20.2016 SR-5359
      intm_type         giac_aging_prem_rep_ext.intm_type%TYPE, --Dren 05.20.2016 SR-5359
      intm_no           giac_aging_prem_rep_ext.intm_no%TYPE, --Dren 05.20.2016 SR-5359
      sum_balance1      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance2      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance3      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance4      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance5      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance6      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance7      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      sum_balance8      giac_aging_prem_rep_ext.balance_amt_due%TYPE,
      col_title1        giac_soa_title.col_title%TYPE,
      col_title2        giac_soa_title.col_title%TYPE,
      col_title3        giac_soa_title.col_title%TYPE,
      col_title4        giac_soa_title.col_title%TYPE,
      col_title5        giac_soa_title.col_title%TYPE,
      col_title6        giac_soa_title.col_title%TYPE,
      col_title7        giac_soa_title.col_title%TYPE,
      col_title8        giac_soa_title.col_title%TYPE,
      agent_code        VARCHAR2 (100),
      intm_name         giac_aging_prem_rep_ext.intm_name%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;
   
   FUNCTION get_giacr329_main(
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE
   )
     RETURN main_tab PIPELINED;
   
   FUNCTION get_giacr329_header
     RETURN header_tab PIPELINED;
     
   FUNCTION get_giacr329_detail(
      p_dummy        NUMBER,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_intm_type    giac_aging_prem_rep_ext.intm_type%TYPE,
      p_intm_no      giac_aging_prem_rep_ext.intm_no%TYPE,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE
   )
     RETURN rec_tab PIPELINED;
     
   FUNCTION get_sum_balance(
      p_col_no       giac_soa_title.col_no%TYPE,
      p_col_title    giac_soa_title.col_title%TYPE,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_intm_no      giac_aging_prem_rep_ext.intm_no%TYPE
   )
     RETURN NUMBER;
     
   FUNCTION get_totals(
      p_dummy        NUMBER,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE
   )
     RETURN rec_tab PIPELINED;
   
END;
/


