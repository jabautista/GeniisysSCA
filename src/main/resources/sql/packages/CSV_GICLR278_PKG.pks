CREATE OR REPLACE PACKAGE CPI.CSV_GICLR278_PKG
AS
   TYPE giclr278_type IS RECORD (
      policy_no         VARCHAR2(30),
      assured_name      VARCHAR2(500),
      claim_no          VARCHAR2(30),
      enrollee          VARCHAR2(200),
      loss_date         VARCHAR2(30),
      claim_file_date   VARCHAR2(30),
      loss_reserve      VARCHAR2(30),
      expense_reserve   VARCHAR2(30),
      loss_paid         VARCHAR2(30),
      expense_paid      VARCHAR2(30)
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
END;
/
