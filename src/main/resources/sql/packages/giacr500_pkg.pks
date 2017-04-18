CREATE OR REPLACE PACKAGE CPI.giacr500_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 07.19.2013
** Reference By : GIACR500
** Description  : Trial Balance */
   TYPE giacr500_record_type IS RECORD (
      test1             VARCHAR2 (2),
      test2             VARCHAR2 (3),
      test3             VARCHAR2 (2),
      gl_acct_no        VARCHAR2 (72),
      acct_name         VARCHAR2 (100),
      branch_name       VARCHAR2 (50),
      YEAR              NUMBER (4),
      MONTH             NUMBER (2),
      debit             NUMBER (16, 2),
      credit            NUMBER (16, 2),
      cf_company_name   VARCHAR2 (300),
      cf_company_add    VARCHAR2 (350),
      cf_date           VARCHAR2 (50),
      p_month           NUMBER (2),
      p_year            NUMBER (4),
      cname             VARCHAR (1)
   );

   TYPE giacr500_record_tab IS TABLE OF giacr500_record_type;

   FUNCTION get_giacr500_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500_record_tab PIPELINED;
END;
/


