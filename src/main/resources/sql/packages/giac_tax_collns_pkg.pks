CREATE OR REPLACE PACKAGE CPI.giac_tax_collns_pkg
AS
   TYPE giac_tax_collns_type IS RECORD (
      gacc_tran_id       giac_tax_collns.gacc_tran_id%TYPE,
      transaction_type   giac_tax_collns.transaction_type%TYPE,
      b160_iss_cd        giac_tax_collns.b160_iss_cd%TYPE,
      b160_prem_seq_no   giac_tax_collns.b160_prem_seq_no%TYPE,
      b160_tax_cd        giac_tax_collns.b160_tax_cd%TYPE,
      tax_name           giac_taxes.tax_name%TYPE,
      inst_no            giac_tax_collns.inst_no%TYPE,
      fund_cd            giac_tax_collns.fund_cd%TYPE,
      tax_amt            giac_tax_collns.tax_amt%TYPE
   );

   TYPE giac_tax_collns_tab IS TABLE OF giac_tax_collns_type;

   FUNCTION get_tax_collns_listing (
      p_gacc_tran_id   giac_tax_collns.gacc_tran_id%TYPE
   )
      RETURN giac_tax_collns_tab PIPELINED;

   TYPE giac_tax_collns_type_cols IS RECORD (
      gacc_tran_id       giac_tax_collns.gacc_tran_id%TYPE,
      transaction_type   giac_tax_collns.transaction_type%TYPE,
      b160_iss_cd        giac_tax_collns.b160_iss_cd%TYPE,
      b160_prem_seq_no   giac_tax_collns.b160_prem_seq_no%TYPE,
      b160_tax_cd        giac_tax_collns.b160_tax_cd%TYPE,
      inst_no            giac_tax_collns.inst_no%TYPE,
      fund_cd            giac_tax_collns.fund_cd%TYPE,
      tax_amt            giac_tax_collns.tax_amt%TYPE,
      tax_name           giac_taxes.tax_name%TYPE
   );

   TYPE rc_giac_tax_collns_cur IS REF CURSOR
      RETURN giac_tax_collns_type_cols;
      
   PROCEDURE delete_giac_tax_collns_rec 
      (p_gacc_tran_id giac_acctrans.tran_id%TYPE,
       p_b160_iss_cd  giac_tax_collns.b160_iss_cd%TYPE,
       p_b160_prem_seq_no giac_tax_collns.b160_prem_seq_no%TYPE,
       p_inst_no giac_tax_collns.inst_no%TYPE); 
       
   FUNCTION get_tax_collns_listing2 (
       p_gacc_tran_id       giac_tax_collns.gacc_tran_id%TYPE,
       p_b160_iss_cd        giac_tax_collns.b160_iss_cd%TYPE,
       p_b160_prem_seq_no   giac_tax_collns.b160_prem_seq_no%TYPE,
       p_inst_no            giac_tax_collns.inst_no%TYPE
    )
   RETURN giac_tax_collns_tab PIPELINED;
   
END;
/


