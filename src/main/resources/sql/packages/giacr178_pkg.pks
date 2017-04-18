CREATE OR REPLACE PACKAGE CPI.GIACR178_PKG
AS

   TYPE giacr178_type IS RECORD( 
      line_cd           giis_line.line_cd%TYPE,
      line              VARCHAR2 (200),
      gibr_branch_cd    giac_branches.branch_cd%TYPE,
      branch            VARCHAR2 (200), 
      tran_date         DATE,
      tran_date2        VARCHAR2 (100),
      posting_date      DATE,
      posint_date2      VARCHAR2 (100),
      tran_flag         giac_acctrans.tran_flag%TYPE,
      tran_class        giac_acctrans.tran_class%TYPE,
      ref_no            VARCHAR2 (100),
      ref_no_used       VARCHAR2 (2),
      tran_id           giac_acctrans.tran_id%TYPE,
      prem_recv         NUMBER(16, 2),
      prem_dep          NUMBER(16, 2),
      ae_prem_recv      NUMBER(16, 2),
      ae_prem_dep       NUMBER(16, 2),
      discrepancy_pr    NUMBER(16, 2),
      discrepancy_pd    NUMBER(16, 2),
      company_name      VARCHAR2 (1000),
      company_address   VARCHAR2 (1000),
      from_date         VARCHAR2 (200),
      to_date           VARCHAR2 (100)
   );
   
   TYPE giacr178_tab IS TABLE OF giacr178_type;
   
   FUNCTION get_giacr178 (
      P_FROM_DATE   VARCHAR2,
      P_TO_DATE     VARCHAR2,
      P_TRAN_POST   VARCHAR2,
      P_LINE_CD     VARCHAR2,
      P_BRANCH_CD   VARCHAR2,
      P_MODULE_ID   VARCHAR2,
      P_USER_ID     VARCHAR2
   )
      RETURN giacr178_tab PIPELINED;

   TYPE ae_amounts_type IS RECORD (
      ae_prem_recv    NUMBER(16, 2),
      ae_prem_dep     NUMBER(16, 2)
   );
   
   TYPE ae_amounts_tab IS TABLE OF ae_amounts_type;

    PROCEDURE get_ae_amounts(
      p_line_cd         IN VARCHAR2,
      p_branch_cd       IN VARCHAR2,
      p_module_id       IN VARCHAR2,
      p_user_id         IN VARCHAR2,
      p_tran_date       IN DATE,
      p_posting_date    IN DATE,
      p_tran_flag       IN VARCHAR2,
      p_tran_class      IN VARCHAR2,
      p_ref_no          IN VARCHAR2,
      p_ref_used        IN VARCHAR2,
      p_ae_prem_recv    OUT NUMBER,
      p_ae_prem_dep     OUT NUMBER,
      p_tran_id         OUT NUMBER
   );
   
   TYPE bill_no_grp_type IS RECORD(
      bill_no       VARCHAR2(100),
      booking_mth   gipi_polbasic.booking_mth%TYPE,
      booking_year  gipi_polbasic.booking_year%TYPE,
      create_date   DATE, 
      acct_ent_date DATE,
      batch_date    DATE
   );
   
   TYPE bill_no_grp_tab IS TABLE OF bill_no_grp_type;
   
   FUNCTION get_bill_no_grp (
      p_line_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_tran_date       VARCHAR2,
      p_posting_date    VARCHAR2,
      p_tran_flag       VARCHAR2,
      p_tran_class      VARCHAR2,
      p_ref_no          VARCHAR2,
      p_ref_used        VARCHAR2
   )
      RETURN bill_no_grp_tab PIPELINED;
      
END;
/


