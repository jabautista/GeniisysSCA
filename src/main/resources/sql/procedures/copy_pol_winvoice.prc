DROP PROCEDURE CPI.COPY_POL_WINVOICE;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winvoice(
                       p_par_id            IN  GIPI_PARLIST.par_id%TYPE,
                  p_policy_id        IN  GIPI_POLBASIC.policy_id%TYPE, 
                  p_iss_cd            IN  GIPI_WPOLBAS.iss_cd%TYPE,
                  p_user_id            IN  VARCHAR2,
                  p_pack            IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,
                  p_prem_seq_no     OUT VARCHAR2,
                  p_msg_alert        OUT VARCHAR2
                  )
         IS  
  p_exist         NUMBER;
  prem_seq        NUMBER;
  v_prem_seq_no   NUMBER;
  v_issue_ri      GIIS_PARAMETERS.param_value_v%TYPE :=  Giisp.v('ISS_CD_RI');
  CURSOR invoice_cur IS SELECT item_grp,property,prem_amt,
                               tax_amt,payt_terms,insured,due_date,currency_cd,
                               currency_rt,remarks,other_charges,ri_comm_amt,
                               ref_inv_no,notarial_fee,policy_currency,      
                               bond_rate,bond_tsi_amt,ri_comm_vat,
                               ---------------------- LONGTERM by gmi------------------
                               MULTI_BOOKING_MM, MULTI_BOOKING_YY, NO_OF_TAKEUP, DIST_FLAG, CHANGED_TAG, TAKEUP_SEQ_NO
                          FROM GIPI_WINVOICE
                         WHERE par_id = p_par_id;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_winvoice program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Bill info..';
  ELSE
    :gauge.FILE := 'passing copy policy WINVOICE';
  END IF;
  vbx_counter;  */
  IF v_issue_ri = p_iss_cd THEN
    FOR A IN (
       SELECT   '1'
         FROM   GIRI_INPOLBAS
        WHERE   policy_id = p_policy_id) LOOP
      p_exist  :=  1;
      EXIT;
    END LOOP;
    IF p_exist IS NULL THEN
        p_msg_alert := 'Please enter the initial acceptance.';
        --:gauge.FILE := 'Please enter the initial acceptance.';
        --RAISE FORM_TRIGGER_FAILURE;
        GOTO RAISE_FORM_TRIGGER_FAILURE; -- added by: Nica 08.15.2012 to prevent proceeding to the 
                                         -- next transactions when error is encountered
    END IF;
  END IF;
  FOR invoice_cur_rec IN invoice_cur LOOP
    BEGIN
    
        IF p_pack <> 'Y' THEN
            FOR A IN (
                SELECT prem_seq_no
              FROM GIIS_PREM_SEQ
                 WHERE iss_cd = p_iss_cd) LOOP
              v_prem_seq_no := A.prem_seq_no+1;
              EXIT;
            END LOOP;
        ELSE
            FOR y IN (SELECT   prem_seq_no
                        FROM giis_pack_prem_seq_temp
                       WHERE par_id = p_par_id
                          AND item_grp = invoice_cur_rec.item_grp
                          AND iss_cd = p_iss_cd
                       ORDER BY prem_seq_no DESC)
            LOOP
                v_prem_seq_no := y.prem_seq_no;
                p_prem_seq_no := y.prem_seq_no;
                EXIT;
            END LOOP;
        END IF; 
         
      INSERT INTO GIPI_INVOICE
                 (iss_cd,policy_id,item_grp,property,prem_amt,tax_amt,payt_terms,
                  insured,user_id,last_upd_date,due_date,ri_comm_amt,currency_cd,
                  prem_seq_no,ref_inv_no,  -- beth 
                  currency_rt,remarks,other_charges,notarial_fee,policy_currency,
                  bond_rate,bond_tsi_amt,ri_comm_vat,
                  ---------------------- LONGTERM by gmi------------------
                  MULTI_BOOKING_MM, MULTI_BOOKING_YY, NO_OF_TAKEUP, DIST_FLAG, CHANGED_TAG, TAKEUP_SEQ_NO)
           VALUES(p_iss_cd,p_policy_id,
          invoice_cur_rec.item_grp,invoice_cur_rec.property,
          invoice_cur_rec.prem_amt,invoice_cur_rec.tax_amt,
          invoice_cur_rec.payt_terms,invoice_cur_rec.insured,
          p_user_id,SYSDATE,invoice_cur_rec.due_date,invoice_cur_rec.ri_comm_amt,
                  invoice_cur_rec.currency_cd,
                  NVL(v_prem_seq_no,1), invoice_cur_rec.ref_inv_no,
                  invoice_cur_rec.currency_rt,
                  invoice_cur_rec.remarks,invoice_cur_rec.other_charges,
                  invoice_cur_rec.notarial_fee,invoice_cur_rec.policy_currency,
                  invoice_cur_rec.bond_rate, invoice_cur_rec.bond_tsi_amt,
                  invoice_cur_rec.ri_comm_vat,
                  ---------------------- LONGTERM by gmi------------------
                  invoice_cur_rec.MULTI_BOOKING_MM, invoice_cur_rec.MULTI_BOOKING_YY, 
                  invoice_cur_rec.NO_OF_TAKEUP, invoice_cur_rec.DIST_FLAG, invoice_cur_rec.CHANGED_TAG, invoice_cur_rec.TAKEUP_SEQ_NO);
        /* This statement has been revised since the GIIS_GIISSEQ table
        ** has already been replaced by several parameter tables such
        ** as the giis_prem_seq which would generate the prem_seq_no
        ** to be used by this procedure.
        */
        
        IF p_pack <> 'Y' THEN
            FOR A IN (
                SELECT prem_seq_no
              FROM GIIS_PREM_SEQ
                 WHERE iss_cd = p_iss_cd) LOOP
              v_prem_seq_no := A.prem_seq_no;
              EXIT;
            END LOOP;
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             p_MSG_ALERT := 'Duplicate record on GIPI_INVOICE with ISS_CD = '||p_iss_cd||
                       ' and PREM_SEQ_NO = '||TO_CHAR(prem_seq)||'.';
             GOTO RAISE_FORM_TRIGGER_FAILURE; -- added by: Nica 08.15.2012 to prevent proceeding to the 
                                              -- next transactions when error is encountered
    END;
        copy_pol_winvperl(invoice_cur_rec.item_grp,invoice_cur_rec.takeup_seq_no,
                          p_par_id,p_iss_cd,v_prem_seq_no);
        copy_pol_winstallment(invoice_cur_rec.item_grp,invoice_cur_rec.takeup_seq_no,
                          p_par_id,p_iss_cd,v_prem_seq_no);
        copy_pol_winv_tax(invoice_cur_rec.item_grp,invoice_cur_rec.takeup_seq_no,
                          p_par_id,v_prem_seq_no);
        IF p_pack = 'Y' THEN
          copy_pol_wpackage_inv_tax(invoice_cur_rec.item_grp,
                          p_par_id,p_iss_cd,v_prem_seq_no,p_policy_id);
        END IF;
END LOOP;
  copy_pol_wcomm_invoices(p_par_id,p_policy_id); -- beth 10-02-98 uncomment the calling of copy_pol_wcomm_invoices

  <<RAISE_FORM_TRIGGER_FAILURE>> -- added by: Nica 08.15.2012
    NULL;

END;
/


