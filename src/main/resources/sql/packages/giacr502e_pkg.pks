CREATE OR REPLACE PACKAGE CPI.GIACR502E_PKG
AS
   /*
      **  Created by   :  Melvin John O. Ostia
      **  Date Created : 07.024.2013
      **  Reference By : GIACR502E_PKG - TRIAL BALANCE REPORT
      */
   TYPE giacr502e_type IS RECORD (
      fund_cd              VARCHAR2 (3),
      branch_cd            VARCHAR2 (2),
      gl_no                VARCHAR2 (100),
      gl_acct_name         VARCHAR2 (100),
      beg_debit            NUMBER (16, 2),
      beg_credit           NUMBER (16, 2),
      trans_debit          NUMBER (16, 2),
      trans_credit         NUMBER (16, 2),
      end_debit            NUMBER (16, 2),
      end_credit           NUMBER (16, 2),
      balance              NUMBER (16, 2),
      company_name         VARCHAR2 (200),
      address              VARCHAR2 (200),
      mm                   VARCHAR2 (100),
      as_of                VARCHAR2 (100),
      branch_name          VARCHAR2 (100),
      detail_branch_name   VARCHAR2 (100),
      text                 VARCHAR2 (100),
      v_not_exist          VARCHAR2 (10)
   );

   TYPE giacr502e_tab IS TABLE OF giacr502e_type;

   FUNCTION get_giacr502e_record (
      p_tran_yr     VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr502e_tab PIPELINED;
END;
/


