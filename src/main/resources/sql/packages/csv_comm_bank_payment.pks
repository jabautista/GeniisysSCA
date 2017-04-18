CREATE OR REPLACE PACKAGE CPI.CSV_COMM_BANK_PAYMENT AS
   TYPE giacs158_record IS RECORD(intm_name    giis_intermediary.intm_name%TYPE,
                                  bank_acct_no giis_payees.bank_acct_no%TYPE,
                                  amount       giac_bank_comm_payt_dtl_ext.commission_due%TYPE,
                                  hash_total   giac_bank_comm_payt_dtl_ext.commission_due%TYPE);
   
   TYPE giacs158_table IS TABLE OF giacs158_record;
   
   FUNCTION giacs158(v_bank_file_no giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE) RETURN giacs158_table pipelined;
   
END;
/


