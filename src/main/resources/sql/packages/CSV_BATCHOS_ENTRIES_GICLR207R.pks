CREATE OR REPLACE PACKAGE CPI.CSV_BATCHOS_ENTRIES_GICLR207R 
AS
/*
**Created by : Carlo Rubenecia
**Date Created : 04/25/2016
**Description : CSV for giclr207R 
*/
   TYPE giclr207r_record_type IS RECORD (
      gl_account     VARCHAR2 (200),
      gl_account_name   VARCHAR2 (100),
      debit_amount      VARCHAR2(50),
      credit_amount     VARCHAR2(50)
   );

   TYPE giclr207r_record_tab IS TABLE OF giclr207r_record_type;

   FUNCTION csv_giclr207r(
      p_tran_id   VARCHAR2
   )
      RETURN giclr207r_record_tab PIPELINED;
END;
/
