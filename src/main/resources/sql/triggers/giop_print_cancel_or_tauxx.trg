DROP TRIGGER CPI.GIOP_PRINT_CANCEL_OR_TAUXX;

CREATE OR REPLACE TRIGGER CPI.GIOP_PRINT_CANCEL_OR_TAUXX
   AFTER UPDATE OF or_no, or_flag ON CPI.GIAC_ORDER_OF_PAYTS    FOR EACH ROW
DECLARE
     ws_tran_flag     giac_acctrans.tran_flag%TYPE;
     ws_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE;
     ws_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE;
     ws_inst_no       giac_direct_prem_collns.inst_no%TYPE;
     ws_print_tag     giac_direct_prem_collns.or_print_tag%TYPE;
     ws_prem_amt      giac_direct_prem_collns.premium_amt%TYPE;
     ws_tax_amt       giac_direct_prem_collns.tax_amt%TYPE;
     ws_colln_amt     giac_direct_prem_collns.collection_amt%TYPE;
     ws_a180_ri_cd    giac_inwfacul_prem_collns.a180_ri_cd%TYPE;
     ws_wtax_amt      giac_inwfacul_prem_collns.wholding_tax%TYPE;
     ws_comm_amt      giac_inwfacul_prem_collns.comm_amt%TYPE;
     ws_comm_vat      giac_inwfacul_prem_collns.comm_vat%TYPE;
     ws_tax_amount    giac_inwfacul_prem_collns.tax_amount%TYPE;
     v_exists         VARCHAR2(1) := 'N';
BEGIN
     --
     -- Check whether the transaction is closed or deleted...
     --
     SELECT tran_flag
       INTO ws_tran_flag
       FROM giac_acctrans
      WHERE tran_id = :NEW.gacc_tran_id;
     --
     --Check whether the collection for the bill is through PDC
     --lina 11/03/2006
     FOR c IN (SELECT 'X'
                 FROM giac_pdc_checks
                WHERE gacc_tran_id = :NEW.gacc_tran_id
                  AND gacc_tran_id_new IS NOT NULL)
        LOOP
           v_exists := 'Y';
        EXIT;
        END LOOP;
     --
     -- Populate the amounts in premium collections...
     --
IF v_exists = 'N' THEN     --lina 11/03/2006
     FOR c IN (SELECT b140_iss_cd, b140_prem_seq_no, inst_no,
                      or_print_tag, NVL(collection_amt, 0) colln_amt,
                      NVL(premium_amt, 0) prem_amt, NVL(tax_amt, 0) tax_amt
                 FROM giac_direct_prem_collns
                WHERE gacc_tran_id = :NEW.gacc_tran_id) LOOP
     ws_iss_cd      := c.b140_iss_cd;
     ws_prem_seq_no := c.b140_prem_seq_no;
     ws_inst_no     := c.inst_no;
     ws_print_tag   := c.or_print_tag;
     ws_prem_amt    := c.prem_amt;
     ws_colln_amt   := c.colln_amt;
     ws_tax_amt     := c.tax_amt;
   --------------------0--------------------0------------------0----------
----print or --
   IF :NEW.or_flag<>'C' THEN
     IF (:NEW.or_tag IS NULL AND :NEW.or_no IS NOT NULL AND :NEW.or_flag = 'P') THEN
       IF ws_print_tag = 'Y' THEN
         UPDATE giac_aging_soa_details
            SET temp_payments = NVL(temp_payments, 0) - NVL(ws_colln_amt, 0)
          WHERE iss_cd      = ws_iss_cd
            AND prem_seq_no = ws_prem_seq_no
            AND inst_no     = ws_inst_no;
       END IF;
    --restore or spoil or
    ELSIF (:NEW.or_tag IS NULL AND :NEW.or_no IS NULL ) THEN
       IF ws_print_tag='Y' THEN
         UPDATE giac_aging_soa_details
            SET temp_payments = NVL(temp_payments, 0) +                  NVL(ws_colln_amt, 0)
          WHERE iss_cd      = ws_iss_cd
            AND prem_seq_no = ws_prem_seq_no
            AND inst_no     = ws_inst_no;
       END IF;
    END IF;
  -------------------O---------------------O-------------------O---------------------
 ELSIF :NEW.or_flag= 'C'  THEN
    --cancel printed or
    IF :OLD.or_flag='P' AND ws_tran_flag <> 'P' THEN --added tran flag by albert 04.16.2015, update should only be done by REVERSALS_TBXIX for posted OR's
         UPDATE giac_aging_soa_details
          SET total_payments   = NVL(total_payments, 0)   -                                  NVL(ws_colln_amt, 0),
              prem_balance_due = NVL(prem_balance_due, 0) +                                  NVL(ws_prem_amt, 0),
              tax_balance_due  = NVL(tax_balance_due, 0)  +                                  NVL(ws_tax_amt, 0),
              balance_amt_due  = NVL(balance_amt_due, 0)  +                                  NVL(ws_colln_amt, 0)
        WHERE iss_cd      = ws_iss_cd
          AND prem_seq_no = ws_prem_seq_no
          AND inst_no     = ws_inst_no;
     ---cancel unprinted or
     ELSIF :OLD.or_flag='N'  THEN
         UPDATE giac_aging_soa_details
          SET total_payments   = NVL(total_payments, 0)   -                                  NVL(ws_colln_amt, 0),
              temp_payments    = NVL(temp_payments, 0)   -                                              NVL(ws_colln_amt, 0),
              prem_balance_due = NVL(prem_balance_due, 0) +                                  NVL(ws_prem_amt, 0),
              tax_balance_due  = NVL(tax_balance_due, 0)  +                                  NVL(ws_tax_amt, 0),
              balance_amt_due  = NVL(balance_amt_due, 0)  +                                  NVL(ws_colln_amt, 0)
        WHERE iss_cd      = ws_iss_cd
          AND prem_seq_no = ws_prem_seq_no
          AND inst_no     = ws_inst_no;
    END IF;
 END IF; --:NEW.OR_FLAG<>'C'
END LOOP; --direct prem
ELSE----------------lina 11/03/06 if PDC exist--------------------------------
FOR a IN (SELECT gacc_tran_id_new
            FROM giac_pdc_checks
           WHERE gacc_tran_id =:NEW.gacc_tran_id)
LOOP
     FOR c IN (SELECT b140_iss_cd, b140_prem_seq_no, inst_no,
                      or_print_tag, NVL(collection_amt, 0) colln_amt,
                      NVL(premium_amt, 0) prem_amt, NVL(tax_amt, 0) tax_amt
                 FROM giac_direct_prem_collns
                WHERE gacc_tran_id = a.gacc_tran_id_new
                   ) LOOP
     ws_iss_cd      := c.b140_iss_cd;
     ws_prem_seq_no := c.b140_prem_seq_no;
     ws_inst_no     := c.inst_no;
     ws_print_tag   := c.or_print_tag;
     ws_prem_amt    := c.prem_amt;
     ws_colln_amt   := c.colln_amt;
     ws_tax_amt     := c.tax_amt;
   --------------------0--------------------0------------------0----------
----print or --
   IF :NEW.or_flag<>'C' THEN
     IF (:NEW.or_tag IS NULL AND :NEW.or_no IS NOT NULL AND :NEW.or_flag = 'P') THEN
       IF ws_print_tag = 'Y' THEN
         UPDATE giac_aging_soa_details
            SET temp_payments = NVL(temp_payments, 0) - NVL(ws_colln_amt, 0)
          WHERE iss_cd      = ws_iss_cd
            AND prem_seq_no = ws_prem_seq_no
            AND inst_no     = ws_inst_no;
       END IF;
    --restore or spoil or
    ELSIF (:NEW.or_tag IS NULL AND :NEW.or_no IS NULL ) THEN
       IF ws_print_tag='Y' THEN
         UPDATE giac_aging_soa_details
            SET temp_payments = NVL(temp_payments, 0) +                  NVL(ws_colln_amt, 0)
          WHERE iss_cd      = ws_iss_cd
            AND prem_seq_no = ws_prem_seq_no
            AND inst_no     = ws_inst_no;
       END IF;
    END IF;
  -------------------O---------------------O-------------------O---------------------
 ELSIF :NEW.or_flag= 'C'  THEN
    --cancel printed or
    IF :OLD.or_flag='P' THEN
         UPDATE giac_aging_soa_details
          SET total_payments   = NVL(total_payments, 0)   -                                  NVL(ws_colln_amt, 0),
              prem_balance_due = NVL(prem_balance_due, 0) +                                  NVL(ws_prem_amt, 0),
              tax_balance_due  = NVL(tax_balance_due, 0)  +                                  NVL(ws_tax_amt, 0),
              balance_amt_due  = NVL(balance_amt_due, 0)  +                                  NVL(ws_colln_amt, 0),
              temp_payments    = NVL(temp_payments, 0)   -                                   NVL(ws_colln_amt, 0)
        WHERE iss_cd      = ws_iss_cd
          AND prem_seq_no = ws_prem_seq_no
          AND inst_no     = ws_inst_no;
     ---cancel unprinted or
     ELSIF :OLD.or_flag='N'  THEN
         UPDATE giac_aging_soa_details
          SET total_payments   = NVL(total_payments, 0)   -                                  NVL(ws_colln_amt, 0),
              temp_payments    = NVL(temp_payments, 0)   -                                   NVL(ws_colln_amt, 0),
              prem_balance_due = NVL(prem_balance_due, 0) +                                  NVL(ws_prem_amt, 0),
              tax_balance_due  = NVL(tax_balance_due, 0)  +                                  NVL(ws_tax_amt, 0),
              balance_amt_due  = NVL(balance_amt_due, 0)  +                                  NVL(ws_colln_amt, 0)
        WHERE iss_cd      = ws_iss_cd
          AND prem_seq_no = ws_prem_seq_no
          AND inst_no     = ws_inst_no;
    END IF;
 END IF; --:NEW.OR_FLAG<>'C'
END LOOP; --direct prem
END LOOP; --for pdc exists
END IF; --LINA
 ---------------------------------For Re-Insurance --------------------
     FOR c IN (SELECT a180_ri_cd,
                      b140_iss_cd,
                      b140_prem_seq_no,
                      inst_no,
                      or_print_tag,
                      NVL(collection_amt, 0) colln_amt,
                      NVL(premium_amt, 0) prem_amt,
                      NVL(tax_amount,0) tax_amount,
                      NVL(wholding_tax, 0) wtax_amt,
                      NVL(comm_amt,0) comm_amt,
                      NVL(comm_vat, 0) comm_vat
                 FROM giac_inwfacul_prem_collns
                WHERE gacc_tran_id = :NEW.gacc_tran_id) LOOP
         ws_iss_cd       := c.b140_iss_cd;
         ws_a180_ri_cd   := c.a180_ri_cd;
     ws_prem_seq_no  := c.b140_prem_seq_no;
     ws_inst_no      := c.inst_no;
     ws_print_tag    := c.or_print_tag;
     ws_prem_amt     := c.prem_amt;
         ws_tax_amount   := c.tax_amount;
     ws_colln_amt    := c.colln_amt;
     ws_wtax_amt     := c.wtax_amt;
         ws_comm_amt     := c.comm_amt;
         ws_comm_vat := c.comm_vat;
   IF :NEW.or_flag<>'C' THEN
     IF (:NEW.or_tag IS NULL AND :NEW.or_no IS NOT NULL AND                         :NEW.or_flag = 'P') THEN
       IF ws_print_tag = 'Y' THEN
         UPDATE giac_aging_ri_soa_details
            SET temp_payments = NVL(temp_payments, 0) -                                 NVL(ws_colln_amt, 0)
          WHERE a180_ri_cd    = ws_a180_ri_cd
            AND prem_seq_no   = ws_prem_seq_no
            AND inst_no       = ws_inst_no;
       END IF;
    --restore or spoil or
    ELSIF (:NEW.or_tag IS NULL AND :NEW.or_no IS NULL ) THEN
       IF ws_print_tag='Y' THEN
         UPDATE giac_aging_ri_soa_details
            SET temp_payments = NVL(temp_payments, 0) +                                                NVL(ws_colln_amt, 0)
          WHERE a180_ri_cd    = ws_a180_ri_cd
            AND prem_seq_no   = ws_prem_seq_no
            AND inst_no       = ws_inst_no;
       END IF;
    END IF;
  -------------------O---------------------O-------------------O---------------------
 ELSIF :NEW.or_flag= 'C'  THEN
    --cancel printed or
    IF :OLD.or_flag='P' THEN
          UPDATE giac_aging_ri_soa_details
             SET total_payments   = NVL(total_payments, 0)   -                                     NVL(ws_colln_amt, 0),
                 prem_balance_due = NVL(prem_balance_due, 0) +                                             NVL(ws_prem_amt, 0),
                 tax_amount       = NVL(tax_amount,0) +                                     NVL(ws_tax_amount,0),
                 wholding_tax_bal = NVL(wholding_tax_bal, 0)  +                                     NVL(ws_wtax_amt, 0),
                 balance_due      = NVL(balance_due, 0)  +                                     NVL(ws_colln_amt, 0),
                 comm_balance_due = NVL(comm_balance_due,0) +                                     NVL(ws_comm_amt,0),
                 temp_payments    = NVL(temp_payments, 0)   -                                              NVL(ws_colln_amt, 0),
                 comm_vat         = ws_comm_vat -- SR-23610 JET JAN-25-2017
           WHERE a180_ri_cd      = ws_a180_ri_cd
             AND prem_seq_no = ws_prem_seq_no
             AND inst_no     = ws_inst_no;
       ---cancel unprinted or
     ELSIF :OLD.or_flag='N'  THEN
          UPDATE giac_aging_ri_soa_details
             SET total_payments   = NVL(total_payments, 0)   -                                             NVL(ws_colln_amt, 0),
                 temp_payments    = NVL(temp_payments, 0)   -                                              NVL(ws_colln_amt, 0),
                 prem_balance_due = NVL(prem_balance_due, 0) +                                             NVL(ws_prem_amt, 0),
                 tax_amount       = NVL(tax_amount,0) +                                                    NVL(ws_tax_amount,0),
                 wholding_tax_bal = NVL(wholding_tax_bal, 0)  +                                            NVL(ws_wtax_amt, 0),
                 balance_due      = NVL(balance_due, 0)  +                                                 NVL(ws_colln_amt, 0),
                 comm_balance_due = NVL(comm_balance_due,0) +                                              NVL(ws_comm_amt,0),
                 comm_vat         = ws_comm_vat -- SR-23610 JET JAN-25-2017
           WHERE a180_ri_cd      = ws_a180_ri_cd
             AND prem_seq_no = ws_prem_seq_no
             AND inst_no     = ws_inst_no;
    END IF;
 END IF; --:NEW.OR_FLAG<>'C'
END LOOP;
END;
/


