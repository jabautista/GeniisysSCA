CREATE OR REPLACE PACKAGE CPI.giclr207_pkg
AS
/*
**Created by : Benedict G. Castillo
**Date Created : 07/25/2013
**Description : giclr207 : Outsanding Loss
*/
   TYPE giclr207_type IS RECORD (
      flag              VARCHAR2 (2),
      company_name      VARCHAR2 (300),
      company_address   VARCHAR2 (500),
      title             VARCHAR2 (300),
      as_of             VARCHAR2 (100),
      gl_acct           VARCHAR2 (100),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amt         NUMBER (18, 2),
      credit_amt        NUMBER (18, 2),
      tran_id           giac_acct_entries.GACC_TRAN_ID%TypE,   
      iss_cd            giis_issource.iss_cd%TYPE
   );

   TYPE giclr207_tab IS TABLE OF giclr207_type;
   
   TYPE tran_id_array IS TABLE OF VARCHAR2(5000) INDEX BY BINARY_INTEGER;

   FUNCTION populate_giclr207 (
      p_year      VARCHAR2,
      p_month     VARCHAR2,
      p_tran_id   VARCHAR2
   )
      RETURN giclr207_tab PIPELINED;
      
   FUNCTION tran_id_to_array (
      p_tran_id VARCHAR2, 
      p_ref VARCHAR2
   ) 
      RETURN tran_id_array;
END giclr207_pkg;
/


