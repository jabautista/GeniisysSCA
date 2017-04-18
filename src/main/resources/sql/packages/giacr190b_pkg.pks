CREATE OR REPLACE PACKAGE CPI.GIACR190b_PKG AS 

  TYPE giacr190b1_type IS RECORD (
    incept_date VARCHAR2(20), --gipi_polbasic.incept_date%TYPE,
    expiry_date VARCHAR2(20), --gipi_polbasic.expiry_date%TYPE,
    policy_no VARCHAR2(40), --number,
    v_date DATE,
    v_invoice VARCHAR2(40),
    v_property1 gipi_invoice.property%TYPE,
    v_signatory1 VARCHAR (100),
    v_designation1 VARCHAR (100),
    v_intm_no1 NUMBER (20),
    v_user1   VARCHAR2 (50),
    v_intm_name1 VARCHAR2 (100),
    v_intm_address1 VARCHAR2 (100),
    v_intm_address2 VARCHAR2 (100),
    v_intm_address3 VARCHAR2 (100),
    v_intermediary_name VARCHAR2 (100),
    v_intermediary_no NUMBER(20),
    v_policy VARCHAR2 (50),
    v_policy_no VARCHAR2 (50),
    v_endt_no VARCHAR2(50),
    v_iss_cd VARCHAR2 (2),
    v_prem_seq_no NUMBER,
    v_prem_bal_due NUMBER,
    v_tax_bal_due NUMBER,
    v_balance_amt_due NUMBER,
    v_inst_no NUMBER
  );

  TYPE giacr190b1_tab IS TABLE OF giacr190b1_type;
  
  FUNCTION populate_giacr190b1(
        p_intm_no       giac_soa_rep_ext.intm_no%TYPE,
        p_aging_id      giac_soa_rep_ext.aging_id%TYPE,
        p_user_id       giac_soa_rep_ext.user_id%TYPE,
        p_selected_aging_id VARCHAR2
   )
    RETURN giacr190b1_tab PIPELINED;
END GIACR190b_PKG;
/


