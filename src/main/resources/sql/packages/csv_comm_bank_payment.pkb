CREATE OR REPLACE PACKAGE BODY CPI.CSV_COMM_BANK_PAYMENT AS
   FUNCTION giacs158(v_bank_file_no giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE) RETURN giacs158_table pipelined
   IS
     CURSOR a
     IS
     /*SELECT parent_intm_no, sum(commission_due) commission_due,
            sum(wholding_tax_due) wholding_tax_due, sum(input_vat_due) input_vat_due
       FROM giac_bank_comm_payt_dtl_ext
      WHERE bank_file_no = v_bank_file_no
      GROUP BY parent_intm_no;*/ --commented by alfie 07192010
      SELECT a.parent_intm_no,   --added by alfie 07192010 :start
             b.commission_due
        FROM (SELECT parent_intm_no, 
                     SUM(commission_due) comm_amt,
                     SUM(wholding_tax_due) wtax_amt,
                     SUM(input_vat_due) input_vat
                FROM giac_bank_comm_payt_dtl_ext
                  WHERE bank_file_no = v_bank_file_no
                    GROUP BY parent_intm_no) a, 
             (SELECT intm_no, 
                     SUM(NVL(comm_payable,0) - NVL(comm_paid,0)) commission_due
                FROM giac_comm_voucher_v
                  WHERE (inv_prem_amt = prem_amt OR inv_prem_amt-prem_amt = .01)
                    AND ROUND(comm_payable,2) <> ROUND(get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                      GROUP BY intm_no) b
          WHERE b.intm_no = a.parent_intm_no; --:end, changed the source of commission due
 
     v_rec          giacs158_record;
     v_hash_total   giac_bank_comm_payt_dtl_ext.commission_due%TYPE;
     v_decimal      NUMBER;
     v_length       NUMBER;
     v_bank_acct_no giis_payees.bank_acct_no%TYPE;
     v_intm_name    giis_intermediary.intm_name%TYPE;
     
   BEGIN
     SELECT abs(sum(commission_due - wholding_tax_due + input_vat_due))
       INTO v_hash_total
       FROM giac_bank_comm_payt_dtl_ext
      WHERE bank_file_no = v_bank_file_no;
      
     SELECT INSTR(to_char(v_hash_total),'.')
       INTO v_decimal
       FROM dual;
       
     IF (length(to_char(v_hash_total)) - v_decimal = 1) THEN
       v_hash_total := v_hash_total * 10;
     ELSIF (length(to_char(v_hash_total)) - v_decimal = 2) THEN
       v_hash_total := v_hash_total * 100;
     END IF;
      
     FOR i IN a
       LOOP
         -- get bank_acct_no
         SELECT bank_acct_no
           INTO v_bank_acct_no
           FROM giis_payees
          WHERE payee_no = i.parent_intm_no
            AND payee_class_cd = giacp.v('INTM_CLASS_CD');
            
         SELECT intm_name
           INTO v_intm_name
           FROM giis_intermediary
          WHERE intm_no = i.parent_intm_no;
          
         v_rec.intm_name    := v_intm_name;
         v_rec.bank_acct_no := v_bank_acct_no;
         v_rec.amount       := i.commission_due /*- i.wholding_tax_due + i.input_vat_due*/; --modified by alfie 07192010
         v_rec.hash_total   := v_hash_total;
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;

END;
/


