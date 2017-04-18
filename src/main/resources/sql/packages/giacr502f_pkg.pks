CREATE OR REPLACE PACKAGE CPI.GIACR502F_PKG
AS
/*
**Created by: Benedict G. Castillo
**Date Created : 07/25/2013
**Description: GIACR502F :TRIAL BALANCE REPORT
*/
   TYPE giacr502f_type IS RECORD (
      flag              VARCHAR2 (2),
      company_name      VARCHAR2 (300),
      company_address   VARCHAR2 (500),
      as_of             VARCHAR2 (50),
      acct_no           VARCHAR2 (50),
      acct_name         giac_chart_of_accts.gl_acct_name%TYPE,
      beg_debit         NUMBER (18, 2),
      beg_credit        NUMBER (18, 2),
      trans_debit       NUMBER (18, 2),
      trans_credit      NUMBER (18, 2),
      end_debit         NUMBER (18, 2),
      end_credit        NUMBER (18, 2),
      balance           NUMBER (18, 2)
   );

   TYPE giacr502f_tab IS TABLE OF giacr502f_type;

   FUNCTION populate_giacr502f (
      p_tran_mm   VARCHAR2,
      p_tran_yr   VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN giacr502f_tab PIPELINED;
END GIACR502F_PKG;
/


