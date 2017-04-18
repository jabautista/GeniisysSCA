CREATE OR REPLACE PACKAGE CPI.CSV_BATCHOS_ENTRIES_GICLR207
AS
/*
**Created by : Carlo Rubenecia
**Date Created : 04/26/2016
**Description : CSV for giclr207 
*/
   TYPE giclr207_type IS RECORD (
      gl_account           VARCHAR2 (100),
      gl_account_name      giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amount         VARCHAR2(50),
      credit_amount        VARCHAR2(50)

   );

   TYPE giclr207_tab IS TABLE OF giclr207_type;
   
   TYPE tran_id_array IS TABLE OF VARCHAR2(5000) INDEX BY BINARY_INTEGER;

   FUNCTION csv_giclr207 (
      p_tran_id   VARCHAR2
   )
      RETURN giclr207_tab PIPELINED;
      
   FUNCTION tran_id_to_array (
      p_tran_id VARCHAR2, 
      p_ref VARCHAR2
   ) 
      RETURN tran_id_array;
END CSV_BATCHOS_ENTRIES_GICLR207;
/
