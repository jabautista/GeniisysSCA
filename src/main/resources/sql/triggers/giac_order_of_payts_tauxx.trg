DROP TRIGGER CPI.GIAC_ORDER_OF_PAYTS_TAUXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_ORDER_OF_PAYTS_TAUXX
/* comment out by nieko 6/4/2013
WHEN (
OLD.or_tag IS NULL AND OLD.or_no IS NULL
      )
*/
BEFORE UPDATE OF or_no ON CPI.GIAC_ORDER_OF_PAYTS FOR EACH ROW
BEGIN
--IF :OLD.or_tag IS NULL AND :OLD.or_no IS NULL THEN --modify by nieko 6/4/2013 commented and changed below by reymon 08152013
IF :NEW.OR_FLAG = 'P' THEN
  BEGIN
    UPDATE GIAC_DIRECT_PREM_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_PREM_DEPOSIT
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_LOSS_RECOVERIES
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_DIRECT_CLAIM_PAYTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_COMM_PAYTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_INPUT_VAT
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_INWFACUL_PREM_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_LOSS_RI_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_INW_OBLIG_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_INW_CLAIM_PAYTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_OUTFACUL_PREM_PAYTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_OUTWARD_OBLIG_PAYTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_BANK_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_OTH_FUND_OFF_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_UNIDENTIFIED_COLLNS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_TAX_PAYMENTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_TAXES_WHELD
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_OTHER_COLLECTIONS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GIAC_OVRIDE_COMM_PAYTS
       SET or_print_tag = 'Y'
     WHERE gacc_tran_id = :NEW.gacc_tran_id;
  END;
  BEGIN
    UPDATE GICL_RECOVERY_PAYT
       SET stat_sw = 'Y'
     WHERE acct_tran_id = :NEW.gacc_tran_id;
  END;
 END IF;
 
 --added by nieko 6/4/2013, allow deletion of transactions under a spoiled OR 
 IF :NEW.OR_FLAG = 'N' THEN
    BEGIN
      BEGIN
        UPDATE GIAC_DIRECT_PREM_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_PREM_DEPOSIT
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_LOSS_RECOVERIES
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_DIRECT_CLAIM_PAYTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_COMM_PAYTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_INPUT_VAT
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_INWFACUL_PREM_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_LOSS_RI_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_INW_OBLIG_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_INW_CLAIM_PAYTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_OUTFACUL_PREM_PAYTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_OUTWARD_OBLIG_PAYTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_BANK_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_OTH_FUND_OFF_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_UNIDENTIFIED_COLLNS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_TAX_PAYMENTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_TAXES_WHELD
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_OTHER_COLLECTIONS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GIAC_OVRIDE_COMM_PAYTS
           SET or_print_tag = 'N'
         WHERE gacc_tran_id = :NEW.gacc_tran_id;
      END;
      BEGIN
        UPDATE GICL_RECOVERY_PAYT
           SET stat_sw = 'N'
         WHERE acct_tran_id = :NEW.gacc_tran_id;
      END;
    END;
   END IF; --nieko end 6/4/2013
END;
/


