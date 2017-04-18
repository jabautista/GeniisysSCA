CREATE OR REPLACE PACKAGE CPI.GIACR502G_PKG
AS
   TYPE giacr502g_record_type IS RECORD (
      fund_cd         VARCHAR2 (3),
      branch_cd       VARCHAR2 (2),
      gl_no           VARCHAR2 (100),
      gl_acct_name    VARCHAR2 (100),
      beg_debit       NUMBER (16, 2),
      beg_credit      NUMBER (16, 2),
      trans_debit     NUMBER (16, 2),
      trans_credit    NUMBER (16, 2),
      end_debit       NUMBER (16, 2),
      end_credit      NUMBER (16, 2),
      comp_name       VARCHAR2 (100),
      comp_address    VARCHAR2 (500),
      as_of_date      VARCHAR2 (100),
      branch_name2    VARCHAR2 (100),
      branch          VARCHAR2 (25),
      branch_totals   VARCHAR2 (50),
      balance         NUMBER (16, 2),
      flag            VARCHAR2 (50)
   );

   TYPE giacr502g_record_tab IS TABLE OF giacr502g_record_type;

   FUNCTION get_giacr502g_records (
      p_branch_cd   VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_tran_yr     VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr502g_record_tab PIPELINED;
END;
/


