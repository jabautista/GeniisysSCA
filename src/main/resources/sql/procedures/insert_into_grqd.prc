DROP PROCEDURE CPI.INSERT_INTO_GRQD;

CREATE OR REPLACE PROCEDURE CPI.INSERT_INTO_GRQD(
  p_payee_cd         IN      GIAC_PAYT_REQUESTS_DTL.payee_cd%TYPE, 
  p_payee_class_cd   IN      GIAC_PAYT_REQUESTS_DTL.payee_class_cd%TYPE, 
  p_payee_amount     IN      GIAC_PAYT_REQUESTS_DTL.payt_amt%TYPE,
  p_currency_cd      IN      GIAC_PAYT_REQUESTS_DTL.currency_cd%TYPE,
  p_convert_rate     IN      GICL_BATCH_CSR.convert_rate%TYPE,
  p_batch_csr_id     IN      GICL_BATCH_CSR.batch_csr_id%TYPE,
  p_particulars      IN OUT  GICL_BATCH_CSR.particulars%TYPE,
  p_req_dtl_no       IN OUT  GICL_BATCH_CSR.req_dtl_no%TYPE,
  p_loss_amt         IN      GICL_BATCH_CSR.paid_amt%TYPE,
  p_ref_id           IN      GICL_BATCH_CSR.ref_id%TYPE,
  p_tran_id          IN      GICL_BATCH_CSR.tran_id%TYPE,
  p_user_id          IN      GIIS_USERS.user_id%TYPE,
  p_msg_alert        OUT     VARCHAR2) IS
  
  /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes INSERT_INTO_GRQD program unit in GICLS043
   **                 
   */

  v_payee            GIAC_PAYT_REQUESTS_DTL.payee%TYPE;
  v_payt_req_flag    GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE DEFAULT 'N';
 
  v_particulars1     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE;
  v_particulars2     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE;
  v_particulars3     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE;
  v_particulars4     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE;

  v_particulars5     VARCHAR2(5000);
  v_claim_id         GICL_CLAIMS.claim_id%TYPE;
  v_length           NUMBER; -- stores length of particulars
  v_print_dtl        GICL_BATCH_CSR.clm_dtl_sw%TYPE; -- Y = char length of details > 2000, 
                                                     -- print report for details (GICLR044B)
                                                     -- N - char length of details < 2000, 
                                                     -- :c024.particulars := v_particulars 
  v_item_curr_cd     GICL_CLM_LOSS_EXP.currency_cd%TYPE;
  v_conv_rt          GIAC_PAYT_REQUESTS_DTL.currency_rt%TYPE;
  v_fcurr_amt        GIAC_PAYT_REQUESTS_DTL.dv_fcurrency_amt%TYPE;
  v_bcsr_limit       GIAC_PARAMETERS.param_value_n%TYPE := 0; -- gets # of (claim) records to be saved in particulars. Pia, 08.27.04
  v_bcsr_limit_recs  GIAC_PAYT_REQUESTS_DTL.particulars%TYPE; -- claim records w/c will be copied to particulars. Pia, 08.27.04
  v_bcsr_cnt         NUMBER := 0; -- # of records approved. Pia, 08.27.04
  
  v_length2          NUMBER; -- length of characters of records approved. Pia, 08.27.04
  v_attach           NUMBER := 0; -- checks existence of the string ' (SEE ATTACHED DETAILS)',
                                  -- for bcsrs that have been cancelled and to be approved again. Pia, 08.27.04
  v_clm              NUMBER := 0; -- checks existence of of the string 'Claim Number',
                                  -- for bcsrs that have been cancelled and to be approved again. Pia, 08.27.04 
  v_particulars6     VARCHAR2(5000); --extend length from 500 to 5000 to handle ora-06502, jess 07.29.2009
  v_payee_class      VARCHAR2(100);
  v_payee_part       VARCHAR2(100);
  v_doc_number       GICL_LOSS_EXP_BILL.doc_number%TYPE;
  v_doc_type         VARCHAR2(100);
  v_all6             VARCHAR2(300);
  v_count2           NUMBER;
  v_currency_rt      GIIS_CURRENCY.currency_rt%TYPE;
BEGIN
 
  FOR l IN
    (SELECT payee_first_name||' '||payee_middle_name||' '||payee_last_name payee
       FROM GIIS_PAYEES
      WHERE payee_no       = p_payee_cd
        AND payee_class_cd = p_payee_class_cd)
  LOOP
    v_payee := l.payee;
    EXIT;
  END LOOP;

  IF v_payee IS NULL THEN              
     p_msg_alert := 'Payee name is not found in Giis_payees table.';
  END IF;

  
  FOR a IN
    (SELECT currency_rt 
       FROM GIIS_CURRENCY
      WHERE main_currency_cd = p_currency_cd)
  LOOP
    v_currency_rt := a.currency_rt;
    EXIT;
  END LOOP;

  IF v_currency_rt IS NULL THEN
     p_msg_alert := 'Currency_cd has no equivalent convert_rate in GIIS_CURRENCY table.';
  END IF;


  p_req_dtl_no := 1;

  v_bcsr_limit := GIACP.n('BCSR_PARTICULARS_LIMIT');
  
  v_particulars1 := p_particulars;

  v_attach := INSTR(p_particulars, ' (SEE ATTACHED DETAILS)');

  IF v_attach != 0 THEN
     v_particulars1 := SUBSTR(v_particulars1, 1, INSTR(v_particulars1, ' (SEE ATTACHED DETAILS)') - 1);
  END IF;
  
  
  v_clm := INSTR(v_particulars1, 'Claim Number');
 
  IF v_clm != 0 THEN
     v_particulars1 := SUBSTR(v_particulars1, 1, INSTR(v_particulars1, CHR(10)||CHR(10)||'Claim Number') - 1);
  END IF;

  v_particulars3 := NULL;
  v_particulars5 := NULL;
  v_particulars4 := NULL;

  FOR clm IN
    (SELECT a.claim_id ID, 
            RPAD(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd
            ||'-'||LPAD(TO_CHAR(a.clm_yy),2,'0')
            ||'-'||LPAD(TO_CHAR(a.clm_seq_no),7,'0'),20,' ')
            ||'  '||RPAD(a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||
            LPAD(TO_CHAR(a.issue_yy),2,'0')
            ||'-'||LPAD(TO_CHAR(a.pol_seq_no),7,'0')
            ||'-'||LPAD(TO_CHAR(a.renew_no),2,'0'),25,' ')||RPAD(a.assured_name,25)PRT
       FROM GICL_CLAIMS a, GICL_ADVICE b, GICL_BATCH_CSR c
      WHERE a.claim_id     = b.claim_id
        AND c.batch_csr_id = p_batch_csr_id
        AND b.batch_csr_id = c.batch_csr_id)
  LOOP
    v_claim_id := clm.ID;
    v_particulars3 := clm.PRT;
    -- abcs 11/16/01
    FOR abc IN
      (SELECT DISTINCT TO_CHAR(c.intm_no) INTM_NO, UPPER(NVL(c.ref_intm_cd,' ')) REF_CD
         FROM GICL_CLAIMS a, GICL_INTM_ITMPERIL b, GIIS_INTERMEDIARY c
        WHERE a.claim_id = b.claim_id 
          AND b.intm_no  = c.intm_no
          AND a.claim_id = v_claim_id)
    LOOP
      IF abc.ref_cd = ' ' THEN 
         v_particulars4 := abc.INTM_no;
      ELSE 
         v_particulars4 := abc.INTM_no||'/'||abc.ref_cd;
      END IF;
    EXIT;
    END LOOP;
    v_particulars5 := v_particulars3||'  '||v_particulars4||CHR(10)||v_particulars5;
    
    --jason 3/7/2008: added to exit the loop when the length of particulars is greater than 2000
    IF LENGTH(v_particulars5) > 2000 THEN
        EXIT;
    END IF;
    
    -- count number of records to be approved. Piua, 09.01.04
    v_bcsr_cnt := v_bcsr_cnt + 1;
    IF v_bcsr_limit != 0 THEN
        -- get claim records if # of claim records <= bcsr particulars limit. Pia, 09.01.04
       IF v_bcsr_cnt <= v_bcsr_limit THEN
            v_bcsr_limit_recs := v_particulars5;
       END IF;
    ELSE
       v_bcsr_limit_recs := v_particulars5;
    END IF;
  END LOOP;
  -- added by gmi.. 08/02/2005 
    BEGIN
       v_count2 := 0;
       FOR c IN(SELECT a.class_desc class_desc,b.payee_last_name last_name,c.doc_number doc_num,DECODE(c.doc_type, 1, 'INVOICE', 2, 'BILL') doc_type
             FROM GIIS_PAYEE_CLASS a, GIIS_PAYEES b, GICL_LOSS_EXP_BILL c, GICL_CLM_LOSS_EXP d, GICL_ADVICE e, GICL_CLAIMS f, GICL_BATCH_CSR g 
            WHERE c.claim_loss_id = d.clm_loss_id      
              AND a.payee_class_cd = b.payee_class_cd 
              AND a.payee_class_cd = g.payee_class_cd
              AND b.payee_no = c.payee_cd
              AND e.advice_id = d.advice_id
              AND f.claim_id    = e.claim_id
              AND e.claim_id = d.claim_id
              AND e.claim_id = c.claim_id
              AND e.batch_csr_id = g.batch_csr_id
              AND g.batch_csr_id = p_batch_csr_id) 
    LOOP        
       v_count2 := v_count2+1;
       v_payee_class := c.class_desc;
       v_payee_part  := c.last_name;
       v_doc_number  := c.doc_num;
       v_doc_type    := c.doc_type;
       v_all6        := v_payee_class||'-'||v_payee_part||'/'||v_doc_type||'-'||v_doc_number;
    /*added by: jen.082409: check first if value is less than 2000
    ** before assigning to the variable to avoid ora-06502*/
    IF LENGTH(v_particulars6||chr(10)||
              '                 '||v_all6) < 2000 THEN 
       IF v_count2 = 1 THEN
             v_particulars6 := 'PAYMENT FOR     :'||v_all6;
         ELSIF v_count2 > 1 THEN
              v_particulars6 := v_particulars6||CHR(10)||
                         '                 '||v_all6; 
         END IF;
    ELSE -- else exit the loop
       EXIT;    
      END IF;
    END LOOP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          NULL;
    END;  
  v_particulars2 := 'Claim Number          Policy Number            Assured                    Intermediary No.';
  
  v_length2 := NVL(LENGTH(v_particulars1||CHR(10)||CHR(10)||
                          v_particulars2||CHR(10)||v_bcsr_limit_recs
                          ||CHR(10)||v_particulars6), 0);
     
   IF v_bcsr_cnt <= v_bcsr_limit THEN
          IF v_length2 > 2000 THEN
                p_particulars := v_particulars1||' (SEE ATTACHED DETAILS)'||CHR(10)||CHR(10)||
                                 v_particulars2||CHR(10)||v_bcsr_limit_recs||CHR(10)||
                                 v_particulars6;
            v_print_dtl := 'Y';
          ELSIF v_length2 <= 2000 THEN
                p_particulars := v_particulars1||CHR(10)||CHR(10)||
                                 v_particulars2||CHR(10)||v_bcsr_limit_recs
                                 ||CHR(10)||v_particulars6;
            v_print_dtl := 'N';
          END IF;
     ELSE
        p_particulars := v_particulars1||' (SEE ATTACHED DETAILS)';
        v_print_dtl := 'Y';
   END IF;

--added by vcm 02.04.2009
  IF p_currency_cd = GIACP.n('CURRENCY_CD') THEN
     v_conv_rt := 1;
     v_fcurr_amt := NVL(p_loss_amt,0); -- conversion will be handled once the advice is selected.
  ELSE
     v_conv_rt := p_convert_rate;
     v_fcurr_amt := NVL(p_loss_amt,0) / v_conv_rt; -- conversion will be handled once the advice is selected.
  END IF;
  
 
  INSERT INTO GIAC_PAYT_REQUESTS_DTL(req_dtl_no, gprq_ref_id, tran_id, payee_class_cd, 
                                     payt_req_flag, payee_cd, payee, particulars, 
                                     currency_cd, payt_amt, user_id, last_update,
                                     dv_fcurrency_amt, currency_rt)
                                     --clm_dtl_sw) -- added by Pia, 06.11.02

       VALUES (p_req_dtl_no, p_ref_id, p_tran_id, 
                  p_payee_class_cd, v_payt_req_flag, p_payee_cd, 
                 v_payee, p_particulars, p_currency_cd, --variables.currency_cd,
               --(p_payee_amount * :c024.convert_rate) , USER, SYSDATE, comment out by Marlo 08032010 changed to:
               (p_payee_amount) , p_user_id, SYSDATE, --conversion will be handled once the advice is selected.
               v_fcurr_amt, v_conv_rt);
               

  UPDATE GICL_BATCH_CSR
     SET clm_dtl_sw   = v_print_dtl
   WHERE batch_csr_id = p_batch_csr_id;

  IF SQL%NOTFOUND THEN               
     p_msg_alert := 'Cannot insert into GIAC_PAYT_REQUESTS_DTL table. ' ||
                    'Please contact your system administrator.';      
  END IF;

END;
/


