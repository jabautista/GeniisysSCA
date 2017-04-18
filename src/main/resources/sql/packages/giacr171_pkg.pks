CREATE OR REPLACE PACKAGE CPI.GIACR171_PKG AS 

  TYPE giacr171_record_type IS RECORD (
    company_name    giis_parameters.param_value_v%TYPE,
    company_address giis_parameters.param_value_v%TYPE,
    period          VARCHAR2(60),
    line_cd         giac_assumed_ri_ext.line_cd%TYPE,
    ri_cd           giac_assumed_ri_ext.ri_cd%TYPE,
    ri_name         giac_assumed_ri_ext.ri_name%TYPE, 
    amt_insured     giac_assumed_ri_ext.amt_insured%TYPE,
    gross_prem_amt  giac_assumed_ri_ext.gross_prem_amt%TYPE,
    ri_comm_exp     giac_assumed_ri_ext.ri_comm_exp%TYPE,
    net_premium     giac_assumed_ri_ext.net_premium%TYPE,
    prem_vat        giac_assumed_ri_ext.prem_vat%TYPE,
    comm_vat        giac_assumed_ri_ext.comm_vat%TYPE,
    line_name       giis_line.line_name%TYPE
  );

  TYPE giacr171_record_tab IS TABLE OF giacr171_record_type;
  
  FUNCTION populate_giacr171_records (
      p_date_from         VARCHAR2,
      p_date_to           VARCHAR2,
      p_line_cd           VARCHAR2,
      p_ri_cd             VARCHAR2,
      p_user_id           VARCHAR2
    )
    RETURN giacr171_record_tab PIPELINED;

END GIACR171_PKG;
/


