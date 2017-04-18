CREATE OR REPLACE PACKAGE CPI.GIACR197A_PKG
AS
/*
**  Created by   : Dwight See
**  Date Created : June 6 2013
**  Description  : For Module GIACR197A
*/

    TYPE populate_giacr197a_type IS RECORD(
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      report_title      VARCHAR2 (200),
      date_label        VARCHAR2 (100),
      report_date       DATE,
      branch_cd         GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
      assd_name         GIAC_SOA_REP_EXT.assd_name%TYPE,
      assd_no           GIAC_SOA_REP_EXT.assd_no%TYPE,
      column_title      GIAC_SOA_REP_EXT.column_title%TYPE,
      policy_no         GIAC_SOA_REP_EXT.policy_no%TYPE,
      inst_no           GIAC_SOA_REP_EXT.inst_no%TYPE,
      bill_no           VARCHAR2(200),
      due_date          GIAC_SOA_REP_EXT.due_date%TYPE,
      incept_date       GIAC_SOA_REP_EXT.incept_date%TYPE,
      no_of_days        GIAC_SOA_REP_EXT.no_of_days%TYPE,
      ref_pol_no        GIAC_SOA_REP_EXT.ref_pol_no%TYPE,
      intm_type         GIAC_SOA_REP_EXT.intm_type%TYPE,
      col_no            GIAC_SOA_TITLE.col_no%TYPE,
      prem_bal_due      GIAC_SOA_REP_EXT.prem_bal_due%TYPE,
      tax_bal_due       GIAC_SOA_REP_EXT.tax_bal_due%TYPE,
      balance_amt_due   GIAC_SOA_REP_EXT.balance_amt_due%TYPE,
      doc_stamps        GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      lgt               GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      fst               GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      ptax_evat         GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      other_tax         GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      system_date       DATE,
      assd_add          VARCHAR2(250),
      dsp_name          VARCHAR2(300),
      dsp_name2         VARCHAR2(300),
      cf_label          VARCHAR2(300),
      cf_signatory      VARCHAR2(300),
      cf_designation    VARCHAR2(300),
      print_signatory   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE	-- SR-3985 : shan 06.19.2015
    );
    
    TYPE populate_giacr197a_tab IS TABLE OF populate_giacr197a_type;
    
    FUNCTION populate_giacr197a(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_ASSD_NO         NUMBER,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_TYPE       VARCHAR2,
     P_USER            VARCHAR2
    )
     RETURN populate_giacr197a_tab PIPELINED;
END;
/
