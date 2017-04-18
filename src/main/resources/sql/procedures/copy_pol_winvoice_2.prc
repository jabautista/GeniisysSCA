CREATE OR REPLACE PROCEDURE CPI.copy_pol_winvoice_2(
    p_old_pol_id     IN  gipi_invoice.policy_id%TYPE,
    p_iss_ri         IN  VARCHAR2,
    p_proc_iss_cd    IN  VARCHAR2,
    p_new_policy_id  IN  giri_inpolbas.policy_id%TYPE,
    p_proc_line_cd   IN  giex_dep_perl.line_cd%TYPE,
    p_user           IN  gipi_invoice.user_id%TYPE,
    p_pack_sw        IN  VARCHAR2,
    p_msg           OUT  VARCHAR2
)
IS
  p_exist            NUMBER;
  prem_seq           NUMBER; 
  
  v_on_incept_tag    giis_payterm.on_incept_tag%TYPE;
  v_no_of_days       giis_payterm.no_of_days%TYPE; 
  v_eff_date         gipi_polbasic.eff_date%TYPE;
  v_assd_no          gipi_polbasic.assd_no%TYPE;
  
  v_line_cd          gipi_polbasic.line_cd%TYPE;  
  v_subline_cd       gipi_polbasic.subline_cd%TYPE;
  v_iss_cd           gipi_polbasic.iss_cd%TYPE;
  v_issue_yy         gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no         gipi_polbasic.renew_no%TYPE;
  v_property         gipi_winvoice.property%TYPE;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_tsi_amt          gipi_itmperil.tsi_amt%TYPE;
  v_prem_amt         gipi_winvoice.prem_amt%TYPE;
  perl_tsi_amt       gipi_itmperil.tsi_amt%TYPE;
  perl_prem_amt      gipi_itmperil.prem_amt%TYPE;
  
  v_due_date         gipi_polbasic.eff_date%TYPE;
  v_diff_days        NUMBER;
  v_prem_seq_no      giis_prem_seq.prem_seq_no%TYPE;
  
  CURSOR invoice_cur IS SELECT item_grp, property, prem_amt,
                               tax_amt, payt_terms, insured, due_date, currency_cd,
                               currency_rt, remarks, other_charges, ri_comm_amt,
                               ref_inv_no, notarial_fee, policy_currency,      
                               bond_rate, bond_tsi_amt,
                               /*nathan*/
                               card_name, card_no, pay_type,approval_cd, prem_seq_no
                          FROM gipi_invoice
                         WHERE policy_id = p_old_pol_id;
                         
                       
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_winvoice program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Bill info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  IF p_iss_ri = p_proc_iss_cd THEN
    FOR A IN (
       SELECT   '1'
         FROM   GIRI_INPOLBAS
        WHERE   policy_id = p_new_policy_id) 
    LOOP
      p_exist  :=  1;
      EXIT;
    END LOOP;
    IF p_exist IS NULL THEN
       p_msg := 'Please enter the initial acceptance.';
       --CLEAR_MESSAGE;
       --MESSAGE('Please enter the initial acceptance.',NO_ACKNOWLEDGE);
       --SYNCHRONIZE;
       --RAISE FORM_TRIGGER_FAILURE;
    END IF;
  END IF;
  FOR B IN ( SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
               FROM gipi_polbasic
              WHERE policy_id = p_new_policy_id ) 
  LOOP
      v_line_cd    := b.line_cd;
      v_subline_cd := b.subline_cd;
      v_iss_cd     := b.iss_cd;
      v_issue_yy   := b.issue_yy;
      v_pol_seq_no := b.pol_seq_no;
      v_renew_no   := b.renew_no;
      v_eff_date   := b.eff_date;      
      EXIT;
  END LOOP;
  FOR C IN ( SELECT policy_id, endt_type
               FROM gipi_polbasic
              WHERE line_cd     = v_line_cd
                AND subline_cd  = v_subline_cd
                AND iss_cd      = v_iss_cd
                AND issue_yy    = v_issue_yy
                AND pol_seq_no  = v_pol_seq_no
                AND renew_no    = v_renew_no
                AND endt_seq_no > 0  ) 
  LOOP            
    v_policy_id := c.policy_id;
    IF c.endt_type = 'A' THEN
       FOR D IN ( SELECT '1'
                    FROM gipi_item
                   WHERE policy_id = v_policy_id 
                     AND rec_flag = 'A' ) 
       LOOP
           v_property := 'VARIOUS';
           EXIT; 
       END LOOP;
    END IF;                 
  END LOOP;    
  FOR invoice_cur_rec IN invoice_cur 
  LOOP
      v_tsi_amt := 0;  --grace 07.16.2010
      v_prem_amt := 0; --grace 07.16.2010
      FOR A IN (SELECT nvl(on_incept_tag,'Y') on_incept_tag, NO_OF_DAYS no_payt_days
                  FROM giis_payterm
                 WHERE payt_terms = invoice_cur_rec.payt_terms) 
      LOOP
        v_on_incept_tag := a.on_incept_tag;
        v_no_of_days    := nvl(a.no_payt_days,0);
        EXIT;
      END LOOP;
      IF v_on_incept_tag = 'Y' THEN
           v_due_date  := v_eff_date;
      ELSE  
           v_due_date  := v_eff_date + nvl(v_no_of_days,0);     
      END IF;
      v_diff_days := v_due_date - invoice_cur_rec.due_date;
    /*commented by aivhie 111601*/
    BEGIN
      FOR A IN (
            SELECT prem_seq_no
                FROM giis_prem_seq
             WHERE iss_cd = p_proc_iss_cd) 
      LOOP
          prem_seq := A.prem_seq_no+1;
          EXIT;
      END LOOP;
             
      -- grace 07.15.2010 to be use for the application of the computation of depreciation
   
      FOR x IN (
              SELECT A.peril_cd, NVL(A.prem_amt,0) prem_amt,
                     NVL(A.tsi_amt,0) tsi_amt, a.prem_rt,
                     A.item_no, A.line_cd --benjo 11.24.2016 SR-5621
                FROM GIPI_ITMPERIL A, GIPI_ITEM b
               WHERE A.policy_id   = p_old_pol_id
                 AND A.policy_id   = b.policy_id
                 AND A.item_no     = b.item_no
                 AND b.item_grp    = invoice_cur_rec.item_grp)
      LOOP        
        /*FOR z IN (       
                SELECT rate                
                      FROM giex_dep_perl b
                     WHERE b.line_cd  = p_proc_line_cd
                       AND b.peril_cd = x.peril_cd
                       AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
          LOOP            
              perl_tsi_amt  := x.tsi_amt - (x.tsi_amt * z.rate);             
              perl_prem_amt := ROUND((perl_tsi_amt * (x.prem_rt/100)),2);
          END LOOP;*/ --benjo 11.24.2016 SR-5621 comment out
          
            /* benjo 11.24.2016 SR-5278 */
            perl_tsi_amt := x.tsi_amt;
            compute_depreciation_amounts (p_old_pol_id, x.item_no, x.line_cd, x.peril_cd, perl_tsi_amt);
            perl_prem_amt := perl_tsi_amt * (x.prem_rt/100);
            /* end SR-5621 */
          
            v_tsi_amt     := v_tsi_amt + nvl(perl_tsi_amt, x.tsi_amt) ;
            v_prem_amt    := v_prem_amt + nvl(perl_prem_amt, x.prem_amt);
            perl_tsi_amt  := NULL;             
            perl_prem_amt := NULL;             
          END LOOP;  
      
      INSERT INTO gipi_invoice
                 (iss_cd,                          policy_id, 
                  item_grp,                        property, 
                  prem_amt,                        tax_amt, 
                  payt_terms,                      insured, 
                  user_id,                         last_upd_date,               due_date,                  ri_comm_amt, 
                  currency_cd,                     prem_seq_no,                 ref_inv_no,
                  currency_rt,                     remarks,                     other_charges,             notarial_fee, 
                  policy_currency,                 bond_rate,                   bond_tsi_amt,
                  /*nathan*/
                  card_name,                       card_no, 
                  pay_type,                        approval_cd)
           VALUES(p_proc_iss_cd,                   p_new_policy_id,
                  invoice_cur_rec.item_grp,        nvl(v_property,invoice_cur_rec.property),
                  v_prem_amt,                      invoice_cur_rec.tax_amt,
                  invoice_cur_rec.payt_terms,      invoice_cur_rec.insured,
                  p_user,                          SYSDATE,                     v_due_date,      invoice_cur_rec.ri_comm_amt,
                  invoice_cur_rec.currency_cd,     nvl(prem_seq,1),             invoice_cur_rec.ref_inv_no,
                  invoice_cur_rec.currency_rt,     invoice_cur_rec.remarks,     invoice_cur_rec.other_charges, invoice_cur_rec.notarial_fee, 
                  invoice_cur_rec.policy_currency, invoice_cur_rec.bond_rate,   invoice_cur_rec.bond_tsi_amt,
                  invoice_cur_rec.card_name,       invoice_cur_rec.card_no, 
                  invoice_cur_rec.pay_type,        invoice_cur_rec.approval_cd);
        /* This statement has been revised since the GIIS_GIISSEQ table
        ** has already been replaced by several parameter tables such
        ** as the giis_prem_seq which would generate the prem_seq_no
        ** to be used by this procedure.
        */
        FOR A IN (
            SELECT prem_seq_no
              FROM giis_prem_seq
             WHERE iss_cd = p_proc_iss_cd) 
        LOOP
          v_prem_seq_no := A.prem_seq_no;
          EXIT;
        END LOOP;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             p_msg := 'Duplicate record on GIPI_INVOICE with ISS_CD = '||p_proc_iss_cd||
                       ' and PREM_SEQ_NO = '||to_char(prem_seq)||'.';
    END;
        copy_pol_winvperl_2(invoice_cur_rec.item_grp, invoice_cur_rec.prem_seq_no, p_proc_iss_cd, p_proc_line_cd, p_old_pol_id, v_prem_seq_no);
        copy_pol_winstallment_2(invoice_cur_rec.item_grp, invoice_cur_rec.prem_seq_no, v_prem_amt, v_diff_days, p_proc_iss_cd, v_prem_seq_no);
        --copy_pol_winv_tax_2(invoice_cur_rec.item_grp, invoice_cur_rec.prem_seq_no, p_proc_iss_cd, v_prem_seq_no);  giex_invtax does not exist 
    IF p_pack_sw = 'Y' THEN
      copy_pol_wpackage_inv_tax_2(invoice_cur_rec.item_grp, p_new_policy_id, p_proc_iss_cd, v_prem_seq_no, p_old_pol_id);
    END IF;
  END LOOP;
  copy_pol_wcomm_invoices_2(p_new_policy_id, p_old_pol_id); -- beth 10-02-98 uncomment the calling of copy_pol_wcomm_invoices
END;
/


