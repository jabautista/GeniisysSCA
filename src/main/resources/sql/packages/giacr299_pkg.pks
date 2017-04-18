CREATE OR REPLACE PACKAGE CPI.GIACR299_PKG
AS
   TYPE giacr299_type IS RECORD(
      policy_no               VARCHAR2(50),
      binder_no               VARCHAR2(15),
      reinsurer               giis_reinsurer.ri_name%TYPE,
      ref_no                  giac_premium_colln_v.ref_no%TYPE,
      tran_date               giac_premium_colln_v.tran_date%TYPE,
      iss_name                giis_issource.iss_name%TYPE,
      line_name               giis_line.line_name%TYPE,
      company_name            giac_parameters.param_value_v%TYPE,
      company_address         giac_parameters.param_value_v%TYPE,
      cut_off_param           VARCHAR2(16),
      date_label              VARCHAR2(100)
   );
    
   TYPE giacr299_tab IS TABLE OF giacr299_type;
   
   FUNCTION get_giacr299_details(
      p_line_cd               giis_line.line_cd%TYPE,
      p_bop                   NUMBER,
      p_branch_cd             giis_issource.iss_cd%TYPE,
      p_cut_off_param         NUMBER,
      p_from_date             VARCHAR2,
      p_to_date               VARCHAR2,
      p_tran_flag             giac_acctrans.tran_flag%TYPE, --Added by Jerome Bautista 10.16.2015 SR 3892
      p_user_id               giis_users.user_id%TYPE
   ) RETURN giacr299_tab PIPELINED;
   
END GIACR299_PKG;
/


