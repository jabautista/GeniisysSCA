CREATE OR REPLACE PACKAGE CPI.GIACR171B_PKG AS 

  TYPE giacr171b_record_type IS RECORD (
    company_name    giis_parameters.param_value_v%TYPE,
    company_address giis_parameters.param_value_v%TYPE,
    from_date       VARCHAR2(100),
    fmto_date       VARCHAR2(100),
    assd_no         giac_assumed_ri_ext.assd_no%TYPE,
    assd_name       giac_assumed_ri_ext.assd_name%TYPE,
    line_cd         giac_assumed_ri_ext.line_cd%TYPE,
    fund_cd         giac_assumed_ri_ext.fund_cd%TYPE,
    branch_cd       giac_assumed_ri_ext.branch_cd%TYPE,
    ri_cd           giac_assumed_ri_ext.ri_cd%TYPE,
    ri_name         giac_assumed_ri_ext.ri_name%TYPE, 
    amt_insured     giac_assumed_ri_ext.amt_insured%TYPE,
    policy_no       giac_assumed_ri_ext.policy_no%TYPE,
    gross_prem_amt  giac_assumed_ri_ext.gross_prem_amt%TYPE,
    ri_comm_exp     giac_assumed_ri_ext.ri_comm_exp%TYPE,
    booking_date    giac_assumed_ri_ext.booking_date%TYPE,
    net_premium     giac_assumed_ri_ext.net_premium%TYPE,
    prem_vat        giac_assumed_ri_ext.prem_vat%TYPE,
    comm_vat        giac_assumed_ri_ext.comm_vat%TYPE,
    line_name       giis_line.line_name%TYPE
  );

  TYPE giacr171b_record_tab IS TABLE OF giacr171b_record_type;
  
  FUNCTION populate_giacr171b_records (
      p_line_cd   VARCHAR2,
      p_ri_cd     VARCHAR2,
      p_user_id   VARCHAR2
    )
    RETURN giacr171b_record_tab PIPELINED;

END GIACR171B_PKG;
/


