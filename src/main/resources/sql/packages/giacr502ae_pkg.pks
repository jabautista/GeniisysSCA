CREATE OR REPLACE PACKAGE CPI.GIACR502AE_PKG             
AS
/*
**Created by: Benedict G. Castillo 
**Date Created: 07/24/2013
**Description: GIACR502AE : TRIAL BALANCE REPORT
*/
   TYPE giacr502ae_type IS RECORD (  
      company_name        VARCHAR2 (300),
      company_address     VARCHAR2 (500),
      flag                VARCHAR2 (2), 
      as_of               VARCHAR2 (200),
      acct_no             VARCHAR2 (30),
      acct_name           giac_chart_of_accts.gl_acct_name%TYPE,
      beg_debit           NUMBER (18, 2),
      beg_credit          NUMBER (18, 2),
      trans_debit         NUMBER (18, 2),
      trans_credit        NUMBER (18, 2),
      unadjusted_debit    NUMBER (18, 2),
      unadjusted_credit   NUMBER (18, 2),
      adjust_debit        NUMBER (18, 2),
      adjust_credit       NUMBER (18, 2),
      end_debit           NUMBER (18, 2),
      end_credit          NUMBER (18, 2),
      branch_name         giac_branches.branch_name%TYPE
   );

   TYPE giacr502ae_tab IS TABLE OF giacr502ae_type;

   FUNCTION populate_giacr502ae (
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_tran_yr     VARCHAR2
   )
      RETURN giacr502ae_tab PIPELINED;
END GIACR502AE_PKG;
/


