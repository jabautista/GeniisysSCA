CREATE OR REPLACE PACKAGE CPI.CSV_AC_GL_REPORTS
AS
   TYPE giacr072_type IS RECORD (
      branch_code           giac_cm_dm.branch_cd%TYPE,
      branch_name           giac_branches.branch_name%TYPE,      
      cm_no                 VARCHAR2 (200),
      transaction_date      giac_acctrans.tran_date%TYPE,
      posting_date          giac_acctrans.posting_date%TYPE,
      recipient             giac_cm_dm.recipient%TYPE,
      particulars           giac_cm_dm.particulars%TYPE,
      amount                giac_cm_dm.local_amt%TYPE,
      or_no                 VARCHAR2 (500), 
      or_date               giac_order_of_payts.or_date%TYPE,
      or_particulars        giac_order_of_payts.particulars%TYPE,
      or_amount             giac_collection_dtl.amount%TYPE
   );   
   TYPE giacr072_tab IS TABLE OF giacr072_type; 
     
   FUNCTION csv_giacr072 (
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2,
      p_memo_type   VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_date_opt    VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_cutoff_date VARCHAR2
   )
      RETURN giacr072_tab PIPELINED;   
END;
/


