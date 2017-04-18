CREATE OR REPLACE PACKAGE CPI.GICLR278_PKG
AS
   TYPE giclr278_type IS RECORD (
      claim_no          VARCHAR2(30),
      policy_no         VARCHAR2(30),
      assured_name      VARCHAR2(500),
      loss_date         DATE,
      claim_file_date   DATE,
      loss_res_amt      NUMBER(16,2),
      exp_res_amt       NUMBER(16,2),
      loss_pd_amt       NUMBER(16,2),
      exp_pd_amt        NUMBER(16,2),
      enrollee          VARCHAR2(200)
   );
   
   TYPE giclr278_tab IS TABLE OF giclr278_type;
   
   FUNCTION populate_giclr278(
        p_dt_basis      VARCHAR2,    
        p_from_date     DATE,
        p_to_date       DATE,
        p_line_cd       GICL_CLAIMS.line_cd%TYPE,    
        p_subline_cd    GICL_CLAIMS.subline_cd%TYPE,       
        p_pol_iss_cd    GICL_CLAIMS.pol_iss_cd%TYPE,     
        p_issue_yy      GICL_CLAIMS.issue_yy%TYPE,
        p_pol_seq_no    GICL_CLAIMS.pol_seq_no%TYPE,
        p_renew_no      GICL_CLAIMS.renew_no%TYPE,
        p_user_id       VARCHAR2,
        p_as_of         DATE  
   )
    RETURN giclr278_tab PIPELINED;
   
   TYPE giclr278_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250)
    );
    
   TYPE giclr278_header_tab IS TABLE OF giclr278_header_type;
    
   FUNCTION get_giclr278_header
        RETURN giclr278_header_tab PIPELINED;

END;
/


