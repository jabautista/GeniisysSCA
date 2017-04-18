CREATE OR REPLACE TRIGGER CPI.GIAC_ACCTRANS_TBUXX
BEFORE UPDATE OF posting_date, tran_flag ON CPI.GIAC_ACCTRANS
FOR EACH ROW
BEGIN
   IF :OLD.posting_date IS NOT NULL
   THEN
      :NEW.posting_date := :OLD.posting_date;
   END IF;

   IF :OLD.tran_flag = 'P'
   THEN
      :NEW.tran_flag := :OLD.tran_flag;
   END IF;

   IF :NEW.tran_class = 'DV' AND :NEW.tran_flag = 'C' AND :OLD.tran_flag = 'O'
   THEN
      DECLARE
         v_print_tag   NUMBER (1);
      BEGIN
         SELECT print_tag
           INTO v_print_tag
           FROM giac_disb_vouchers
          WHERE gacc_tran_id = :OLD.tran_id;

         IF v_print_tag <> 6
         THEN
            :NEW.tran_flag := 'O';
         END IF;
      END;
   END IF;
END;