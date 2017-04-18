CREATE OR REPLACE PACKAGE CPI.GIACR502B_PKG
AS
   /*
      **  Created by   :  Melvin John O. Ostia
      **  Date Created : 07.024.2013
      **  Reference By : GIACR502B_PKG - TRIAL BALANCE REPORT
      */
   TYPE giacr502b_type IS RECORD (
      gl_acct_name   VARCHAR2 (100),
      gl_acct_id     NUMBER (12, 2),
      gl_no          VARCHAR2 (100),
      debit          NUMBER (16, 2),--Modified by pjsantos 12/08/2016, GENQA 5870
      credit         NUMBER (16, 2),--Modified by pjsantos 12/08/2016, GENQA 5870
      comp_name      VARCHAR2 (300),
      comp_add       VARCHAR2 (300),
      mm             VARCHAR2 (100),
      as_of          VARCHAR2 (100),
      balance        NUMBER
   );

   TYPE giacr502b_tab IS TABLE OF giacr502b_type;

   FUNCTION get_giacr502b_record (p_tran_mm NUMBER, p_tran_yr NUMBER)
      RETURN giacr502b_tab PIPELINED;
END;
/


