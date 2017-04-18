DROP TRIGGER CPI.GIAC_ACCTRANS_TAUXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_ACCTRANS_TAUXX
   AFTER UPDATE OF TRAN_FLAG ON CPI.GIAC_ACCTRANS    FOR EACH ROW
WHEN (
NEW.TRAN_FLAG IN ('C','O', 'D')
      )
DECLARE
     ws_iss_cd        GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE;
     ws_prem_seq_no   GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE;
     ws_inst_no       GIAC_DIRECT_PREM_COLLNS.inst_no%TYPE;
     ws_print_tag     GIAC_DIRECT_PREM_COLLNS.or_print_tag%TYPE;
     ws_prem_amt      GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE;
     ws_tax_amt       GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE;
     ws_colln_amt     GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
     ws_or_tag        GIAC_ORDER_OF_PAYTS.OR_TAG%TYPE;
     ws_or_no         GIAC_ORDER_OF_PAYTS.OR_NO%TYPE;
     ws_a180_ri_cd    GIAC_INWFACUL_PREM_COLLNS.a180_ri_cd%TYPE;
     ws_wtax_amt      GIAC_INWFACUL_PREM_COLLNS.wholding_tax%TYPE;
     ws_comm_amt      GIAC_INWFACUL_PREM_COLLNS.comm_amt%TYPE;
  ws_comm_vat      GIAC_INWFACUL_PREM_COLLNS.comm_vat%TYPE;   --jeremy 112509
     ws_tax_amount    GIAC_INWFACUL_PREM_COLLNS.tax_amount%TYPE;
BEGIN
    IF :OLD.tran_class='COL' THEN
      SELECT OR_TAG,OR_NO
   INTO WS_OR_TAG,WS_OR_NO
          FROM GIAC_ORDER_OF_PAYTS
         WHERE GACC_TRAN_ID = :NEW.TRAN_ID;
    END IF;
  -------------for direct premiums---------
     FOR C IN (SELECT B140_ISS_CD, B140_PREM_SEQ_NO, INST_NO,
                      OR_PRINT_TAG, NVL(COLLECTION_AMT, 0) COLLN_AMT,
                      NVL(PREMIUM_AMT, 0) PREM_AMT, NVL(TAX_AMT, 0) TAX_AMT
                 FROM GIAC_DIRECT_PREM_COLLNS
                WHERE GACC_TRAN_ID = :NEW.TRAN_ID) LOOP
     ws_iss_cd      := C.b140_iss_cd;
  ws_prem_seq_no := C.b140_prem_seq_no;
  ws_inst_no     := C.inst_no;
  ws_print_tag   := C.or_print_tag;
  ws_prem_amt    := C.prem_amt;
  ws_colln_amt   := C.colln_amt;
  ws_tax_amt     := C.tax_amt;
   --------------------0--------------------0------------------0-------------------
 IF :OLD.tran_class='COL' THEN
   IF :OLD.TRAN_FLAG ='O' THEN
     IF ( :NEW.tran_flag = 'C'  AND WS_OR_NO IS NOT NULL)   THEN
       IF WS_PRINT_TAG = 'N'   THEN
         UPDATE GIAC_AGING_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
          WHERE ISS_CD      = WS_ISS_CD
            AND PREM_SEQ_NO = WS_PREM_SEQ_NO
            AND INST_NO     = WS_INST_NO;
        END IF;
     ELSIF (:NEW.tran_flag='D' AND WS_OR_NO IS NOT NULL) THEN
        IF WS_PRINT_TAG='N'  THEN
            UPDATE GIAC_AGING_SOA_DETAILS
               SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
             WHERE ISS_CD      = WS_ISS_CD
               AND PREM_SEQ_NO = WS_PREM_SEQ_NO
               AND INST_NO     = WS_INST_NO;
        END IF;
     END IF;
   ELSIF :OLD.TRAN_FLAG='C' THEN
     IF (:NEW.tran_flag='O') THEN
        IF WS_PRINT_TAG='N' THEN
         UPDATE GIAC_AGING_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) + NVL(WS_COLLN_AMT, 0)
          WHERE ISS_CD      = WS_ISS_CD
            AND PREM_SEQ_NO = WS_PREM_SEQ_NO
            AND INST_NO     = WS_INST_NO;
        END IF;
     END IF;
   END IF; --:OLD.TRAN_FLAG ='O'
 ELSIF :OLD.tran_class='DV' THEN
       IF :OLD.TRAN_FLAG ='O' THEN
         IF  :NEW.tran_flag = 'C'   THEN
           UPDATE GIAC_AGING_SOA_DETAILS
              SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
            WHERE ISS_CD      = WS_ISS_CD
              AND PREM_SEQ_NO = WS_PREM_SEQ_NO
              AND INST_NO     = WS_INST_NO;
         ELSIF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_SOA_DETAILS
               SET TOTAL_PAYMENTS = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                   TEMP_PAYMENTS  = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                   PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                   TAX_BALANCE_DUE  = NVL(TAX_BALANCE_DUE, 0) + NVL(WS_TAX_AMT, 0),
                   BALANCE_AMT_DUE  = NVL(BALANCE_AMT_DUE, 0) + NVL(WS_COLLN_AMT, 0)
             WHERE ISS_CD      = WS_ISS_CD
               AND PREM_SEQ_NO = WS_PREM_SEQ_NO
               AND INST_NO     = WS_INST_NO;
         END IF;  --:NEW.tran_flag = 'C'
       ELSIF :OLD.TRAN_FLAG ='C' THEN
         IF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_SOA_DETAILS
               SET TOTAL_PAYMENTS = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                   PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                   TAX_BALANCE_DUE  = NVL(TAX_BALANCE_DUE, 0) + NVL(WS_TAX_AMT, 0),
                   BALANCE_AMT_DUE  = NVL(BALANCE_AMT_DUE, 0) + NVL(WS_COLLN_AMT, 0)
             WHERE ISS_CD      = WS_ISS_CD
               AND PREM_SEQ_NO = WS_PREM_SEQ_NO
               AND INST_NO     = WS_INST_NO;
         ELSIF :NEW.tran_flag='O' THEN
           UPDATE GIAC_AGING_SOA_DETAILS
              SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) + NVL(WS_COLLN_AMT, 0)
            WHERE ISS_CD      = WS_ISS_CD
              AND PREM_SEQ_NO = WS_PREM_SEQ_NO
              AND INST_NO     = WS_INST_NO;
         END IF;
       END IF;
 ELSIF :OLD.tran_class IN ('JV','PDC','CM','DM') THEN --Vincent 070405: added 'CM','DM'
       IF :OLD.TRAN_FLAG ='O' THEN
         IF  :NEW.tran_flag = 'C'   THEN
           UPDATE GIAC_AGING_SOA_DETAILS
              SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
            WHERE ISS_CD      = WS_ISS_CD
              AND PREM_SEQ_NO = WS_PREM_SEQ_NO
              AND INST_NO     = WS_INST_NO;
          ELSIF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_SOA_DETAILS
               SET TOTAL_PAYMENTS = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                   TEMP_PAYMENTS  = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                   PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                   TAX_BALANCE_DUE  = NVL(TAX_BALANCE_DUE, 0) + NVL(WS_TAX_AMT, 0),
                   BALANCE_AMT_DUE  = NVL(BALANCE_AMT_DUE, 0) + NVL(WS_COLLN_AMT, 0)
             WHERE ISS_CD      = WS_ISS_CD
               AND PREM_SEQ_NO = WS_PREM_SEQ_NO
               AND INST_NO     = WS_INST_NO;
          END IF;
       ELSIF :OLD.TRAN_FLAG ='C' THEN
         IF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_SOA_DETAILS
               SET TOTAL_PAYMENTS = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                   PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                   TAX_BALANCE_DUE  = NVL(TAX_BALANCE_DUE, 0) + NVL(WS_TAX_AMT, 0),
                   BALANCE_AMT_DUE  = NVL(BALANCE_AMT_DUE, 0) + NVL(WS_COLLN_AMT, 0)
             WHERE ISS_CD      = WS_ISS_CD
               AND PREM_SEQ_NO = WS_PREM_SEQ_NO
               AND INST_NO     = WS_INST_NO;
          ELSIF :NEW.tran_flag='O' THEN
           UPDATE GIAC_AGING_SOA_DETAILS
              SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) + NVL(WS_COLLN_AMT, 0)
            WHERE ISS_CD      = WS_ISS_CD
              AND PREM_SEQ_NO = WS_PREM_SEQ_NO
              AND INST_NO     = WS_INST_NO;
          END IF;
       END IF;
END IF;
END LOOP;
------------for reinsurance-----------------
     FOR C IN (SELECT A180_RI_CD,
                      B140_ISS_CD,
                      B140_PREM_SEQ_NO,
                      INST_NO,
                      OR_PRINT_TAG,
                      NVL(COLLECTION_AMT, 0) COLLN_AMT,
                      NVL(PREMIUM_AMT, 0) PREM_AMT,
                      NVL(TAX_AMOUNT,0) TAX_AMOUNT,
                      NVL(WHOLDING_TAX, 0) WTAX_AMT,
                      NVL(COMM_AMT,0) COMM_AMT,
       NVL(COMM_VAT,0) COMM_VAT   --jeremy 112509
                 FROM GIAC_INWFACUL_PREM_COLLNS
                WHERE GACC_TRAN_ID = :NEW.TRAN_ID) LOOP
         ws_iss_cd       := C.b140_iss_cd;
         ws_a180_ri_cd   := c.a180_ri_cd;
  ws_prem_seq_no  := C.b140_prem_seq_no;
  ws_inst_no      := C.inst_no;
  ws_print_tag    := C.or_print_tag;
  ws_prem_amt     := C.prem_amt;
         ws_tax_amount   := C.tax_amount;
  ws_colln_amt    := C.colln_amt;
  ws_wtax_amt     := C.wtax_amt;
         ws_comm_amt     := c.comm_amt;
         ws_comm_vat     := c.comm_vat;
 IF :OLD.tran_class='COL' THEN
   IF :OLD.TRAN_FLAG ='O' THEN
     IF ( :NEW.tran_flag = 'C'  AND WS_OR_NO IS NOT NULL)   THEN
       IF WS_PRINT_TAG = 'N'   THEN
         UPDATE GIAC_AGING_RI_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
          WHERE A180_RI_CD    = WS_A180_RI_CD
            AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
            AND INST_NO       = WS_INST_NO;
        END IF;
     ELSIF (:NEW.tran_flag='D' AND WS_OR_NO IS NOT NULL) THEN
        IF WS_PRINT_TAG='N'  THEN
            UPDATE GIAC_AGING_RI_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
          WHERE A180_RI_CD    = WS_A180_RI_CD
            AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
            AND INST_NO       = WS_INST_NO;
        END IF;
     END IF;
   ELSIF :OLD.TRAN_FLAG='C' THEN
     IF (:NEW.tran_flag='O') THEN
        IF WS_PRINT_TAG='N' THEN
         UPDATE GIAC_AGING_RI_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) + NVL(WS_COLLN_AMT, 0)
          WHERE A180_RI_CD    = WS_A180_RI_CD
            AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
            AND INST_NO       = WS_INST_NO;
        END IF;
     END IF;
   END IF; --:OLD.TRAN_FLAG ='O'
 ELSIF :OLD.tran_class='DV' THEN
       IF :OLD.TRAN_FLAG ='O' THEN
         IF  :NEW.tran_flag = 'C'   THEN
           UPDATE GIAC_AGING_RI_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
          WHERE A180_RI_CD    = WS_A180_RI_CD
            AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
            AND INST_NO       = WS_INST_NO;
         ELSIF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_RI_SOA_DETAILS
             SET TOTAL_PAYMENTS   = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                 TEMP_PAYMENTS    = NVL(TEMP_PAYMENTS, 0) -  NVL(WS_COLLN_AMT, 0),
                 PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                 TAX_AMOUNT       = NVL(TAX_AMOUNT,0) + NVL(WS_TAX_AMOUNT,0),
                 WHOLDING_TAX_BAL = NVL(WHOLDING_TAX_BAL, 0) + NVL(WS_WTAX_AMT, 0),
                 BALANCE_DUE      = NVL(BALANCE_DUE, 0) + NVL(WS_COLLN_AMT, 0),
                 COMM_BALANCE_DUE = NVL(COMM_BALANCE_DUE,0) + NVL(WS_COMM_AMT,0),
     COMM_VAT    = NVL(COMM_VAT,0) + NVL(WS_COMM_VAT,0)   --jeremy 112509
           WHERE A180_RI_CD      = WS_A180_RI_CD
             AND PREM_SEQ_NO = WS_PREM_SEQ_NO
             AND INST_NO     = WS_INST_NO;
         END IF;  --:NEW.tran_flag = 'C'
       ELSIF :OLD.TRAN_FLAG ='C' THEN
         IF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_RI_SOA_DETAILS
             SET TOTAL_PAYMENTS   = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                 PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                 TAX_AMOUNT       = NVL(TAX_AMOUNT,0) + NVL(WS_TAX_AMOUNT,0),
                 WHOLDING_TAX_BAL = NVL(WHOLDING_TAX_BAL, 0) + NVL(WS_WTAX_AMT, 0),
                 BALANCE_DUE      = NVL(BALANCE_DUE, 0) + NVL(WS_COLLN_AMT, 0),
                 COMM_BALANCE_DUE = NVL(COMM_BALANCE_DUE,0) + NVL(WS_COMM_AMT,0),
      COMM_VAT    = NVL(COMM_VAT,0) + NVL(WS_COMM_VAT,0)   --jeremy 112509
           WHERE A180_RI_CD      = WS_A180_RI_CD
             AND PREM_SEQ_NO = WS_PREM_SEQ_NO
             AND INST_NO     = WS_INST_NO;
          ELSIF :NEW.tran_flag='O' THEN
              UPDATE GIAC_AGING_RI_SOA_DETAILS
                 SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) + NVL(WS_COLLN_AMT, 0)
               WHERE A180_RI_CD    = WS_A180_RI_CD
                 AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
                AND INST_NO       = WS_INST_NO;
          END IF;
       END IF;
 ELSIF :OLD.tran_class IN ('JV','PDC','CM','DM') THEN --Vincent 070405: added 'CM','DM'
IF :OLD.TRAN_FLAG ='O' THEN
         IF  :NEW.tran_flag = 'C'   THEN
           UPDATE GIAC_AGING_RI_SOA_DETAILS
            SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0)
          WHERE A180_RI_CD    = WS_A180_RI_CD
            AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
            AND INST_NO       = WS_INST_NO;
         ELSIF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_RI_SOA_DETAILS
             SET TOTAL_PAYMENTS   = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                 TEMP_PAYMENTS    = NVL(TEMP_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                 PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                 TAX_AMOUNT       = NVL(TAX_AMOUNT,0) + NVL(WS_TAX_AMOUNT,0),
                 WHOLDING_TAX_BAL = NVL(WHOLDING_TAX_BAL, 0) + NVL(WS_WTAX_AMT, 0),
                 BALANCE_DUE      = NVL(BALANCE_DUE, 0) + NVL(WS_COLLN_AMT, 0),
                 COMM_BALANCE_DUE = NVL(COMM_BALANCE_DUE,0) + NVL(WS_COMM_AMT,0),
     COMM_VAT    = NVL(COMM_VAT,0) + NVL(WS_COMM_VAT,0)   --jeremy 112509
           WHERE A180_RI_CD      = WS_A180_RI_CD
             AND PREM_SEQ_NO = WS_PREM_SEQ_NO
             AND INST_NO     = WS_INST_NO;
         END IF;  --:NEW.tran_flag = 'C'
       ELSIF :OLD.TRAN_FLAG ='C' THEN
         IF :NEW.tran_flag ='D' THEN
            UPDATE GIAC_AGING_RI_SOA_DETAILS
             SET TOTAL_PAYMENTS   = NVL(TOTAL_PAYMENTS, 0) - NVL(WS_COLLN_AMT, 0),
                 PREM_BALANCE_DUE = NVL(PREM_BALANCE_DUE, 0) + NVL(WS_PREM_AMT, 0),
                 TAX_AMOUNT       = NVL(TAX_AMOUNT,0) + NVL(WS_TAX_AMOUNT,0),
                 WHOLDING_TAX_BAL = NVL(WHOLDING_TAX_BAL, 0) + NVL(WS_WTAX_AMT, 0),
                 BALANCE_DUE      = NVL(BALANCE_DUE, 0) + NVL(WS_COLLN_AMT, 0),
                 COMM_BALANCE_DUE = NVL(COMM_BALANCE_DUE,0) + NVL(WS_COMM_AMT,0),
     COMM_VAT    = NVL(COMM_VAT,0) + NVL(WS_COMM_VAT,0)   --jeremy 112509
           WHERE A180_RI_CD      = WS_A180_RI_CD
             AND PREM_SEQ_NO = WS_PREM_SEQ_NO
             AND INST_NO     = WS_INST_NO;
        ELSIF :NEW.tran_flag='O' THEN
              UPDATE GIAC_AGING_RI_SOA_DETAILS
                 SET TEMP_PAYMENTS = NVL(TEMP_PAYMENTS, 0) + NVL(WS_COLLN_AMT, 0)
               WHERE A180_RI_CD    = WS_A180_RI_CD
                 AND PREM_SEQ_NO   = WS_PREM_SEQ_NO
                AND INST_NO       = WS_INST_NO;
        END IF;
       END IF;
END IF;
END LOOP;
END;
/


