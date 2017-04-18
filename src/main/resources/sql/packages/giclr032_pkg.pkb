CREATE OR REPLACE PACKAGE BODY CPI.GICLR032_PKG
IS
/*
** Created By: Belle Bebing
** Date Created: 04.10.2012
** Reference By: GICLR032
** Description: Final Claim Settlement Request
**
** Modified By: Aliza G
** Date Modified : 10.27,2014
** Description: To resolve SR 0017193, erroneous output when loss/exp recprds tagged on advise have diff final and ex gratia switch
**
** Modified By Kenneth L
** Date Modified : 05.19..2015
** Description: Modified handling of Loss Expense code for Depreciation since codes does not consider line. For FGIC-19123
*/
FUNCTION populate_giclr032(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE
    )
  RETURN giclr032_tab PIPELINED IS
  
  rep           giclr032_type;
  v_line_cd        gicl_claims.line_cd%TYPE;
  v_subline_cd    gicl_claims.subline_cd%TYPE;
  v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
  v_issue_yy    gicl_claims.issue_yy%TYPE;
  v_pol_seq_no    gicl_claims.pol_seq_no%TYPE;
  v_renew_no    gicl_claims.renew_no%TYPE;
  v_loss_date    gicl_claims.loss_date%TYPE;
  v_count       NUMBER(2):= 0;
  
 BEGIN
    FOR i IN(SELECT a.assd_name2, a.assd_no, a.acct_of_cd, 
                    a.line_cd ||'-'||a.subline_cd||'-'||a.pol_iss_cd ||'-'||LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'||LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'||LPAD(TO_CHAR(a.renew_no),2,'0') POLICY, 
                    a.assured_name, --a.dsp_loss_date, replaced by: Nica 09.15.2012
                    TO_CHAR (a.dsp_loss_date, 'fmMonth dd, yyyy') dsp_loss_date,
                    a.line_cd ||'-'||a.subline_cd ||'-'||a.iss_cd ||'-'|| LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'||LPAD(TO_CHAR(a.clm_seq_no),7,'0') claims, 
                    DECODE(d.payee_first_name,NULL, d.payee_last_name, d.payee_first_name ||' '|| d.payee_middle_name||' '|| d.payee_last_name) NAME,
                    c.claim_id, c.advice_id, c.payee_class_cd, c.payee_cd, 
                    NVL(c.final_tag,'N') final_tag, 
                    c.ex_gratia_sw, e.line_cd,
                    SUM(DECODE(c.payee_type,'L', c.net_amt,0.00) * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) loss_amt,
                    SUM(DECODE(c.payee_type,'E', c.net_amt,0.00) * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) exp_amt,
                    SUM(c.advise_amt * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) advise_amt, 
                    SUM(c.net_amt * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) net_amt,
                    SUM(c.paid_amt * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) paid_amt,
                    SUM(e.net_ret * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) net_ret,
                    SUM(e.facul * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) facul,
                    SUM(e.treaty * DECODE(c.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd,1,NVL(b.orig_curr_rate,b.convert_rate))) treaty,
                    b.convert_rate, a.pol_iss_cd, a.iss_cd, DECODE(b.remarks,NULL,b.remarks,'***'||b.remarks) remarks, b.currency_cd  
              FROM gicl_claims a, gicl_advice b, gicl_clm_loss_exp c, giis_payees d,
                   (SELECT a.claim_id, a.clm_loss_id, a.line_cd,
                           SUM(DECODE (a.grp_seq_no, 1, a.shr_le_adv_amt, 0.00 )) net_ret,
                           SUM(DECODE (a.grp_seq_no, 999, a.shr_le_adv_amt, 0.00)) facul,
                           SUM(DECODE (a.grp_seq_no, 1, 0.00, 999, 0.00, a.shr_le_adv_amt)) treaty
                      FROM gicl_loss_exp_ds a 
                     WHERE (a.negate_tag = 'N' OR a.negate_tag IS NULL)
                     GROUP BY a.claim_id, a.clm_loss_id, a.line_cd) e
             WHERE a.claim_id = b.claim_id 
               AND b.claim_id = c.claim_id
               AND b.advice_id = c.advice_id 
               AND c.payee_class_cd = d.payee_class_cd 
               AND c.payee_cd = d.payee_no
               AND c.claim_id = e.claim_id
               AND c.clm_loss_id = e.clm_loss_id
               AND c.claim_id = p_claim_id
               AND c.advice_id = p_advice_id
             GROUP BY a.assd_name2, a.assd_no, a.acct_of_cd, 
                      a.line_cd ||'-'||a.subline_cd||'-'||a.pol_iss_cd ||'-'||LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'||LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'||        LPAD(TO_CHAR(a.renew_no),2,'0'), a.assured_name, a.dsp_loss_date,
                      a.line_cd ||'-'||a.subline_cd ||'-'||a.iss_cd ||'-'|| LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'||LPAD(TO_CHAR(a.clm_seq_no),7,'0'),
                      DECODE(d.payee_first_name,NULL, d.payee_last_name, d.payee_first_name ||' '|| d.payee_middle_name||' '|| d.payee_last_name),
                      c.claim_id, c.advice_id, c.payee_class_cd, c.payee_cd, 
                      NVL(c.final_tag,'N'), c.ex_gratia_sw, e.line_cd,b.convert_rate, a.pol_iss_cd, a.iss_cd, 
                      DECODE(b.remarks,NULL,b.remarks,'***'||b.remarks), b.currency_cd )
    LOOP
        rep.claim_id         := i.claim_id; 
        rep.advice_id        := i.advice_id;      
        rep.policy_no        := i.policy;
        rep.claim_no         := i.claims;
        rep.assd_no          := i.assd_no;
        rep.assured_name     := i.assured_name;
        rep.assd_name2       := i.assd_name2;
        rep.name             := i.name;
        rep.payee_class_cd   := i.payee_class_cd;
        rep.payee_cd         := i.payee_cd;
        rep.acct_of_cd       := i.acct_of_cd;
        rep.line_cd          := i.line_cd;
        rep.dsp_loss_date    := i.dsp_loss_date;
        rep.currency_cd      := i.currency_cd;
       -- rep.convert_rate     := i.convert_rate;
        rep.final_tag        := i.final_tag;       
        rep.ex_gratia_sw     := i.ex_gratia_sw;
        rep.loss_amt         := i.loss_amt;    
        rep.exp_amt          := i.exp_amt;
        rep.advise_amt       := i.advise_amt;
        rep.net_amt          := i.net_amt;
        rep.paid_amt         := i.paid_amt;
        rep.net_ret          := i.net_ret;
        rep.facul            := i.facul;
        rep.treaty           := i.treaty;
        rep.remarks          := i.remarks;
        rep.iss_cd           := i.iss_cd;
        
        rep.cf_v_sp          := giclr032_pkg.cf_v_spformula(i.claim_id,i.advice_id,i.name,i.ex_gratia_sw,     
                                                            i.currency_cd,i.paid_amt,i.final_tag,i.payee_class_cd,i.payee_cd);
        rep.term             := giclr032_pkg.cf_termformula(i.claim_id); 
        rep.intm             := giclr032_pkg.cf_intmformula(i.claim_id);  
        rep.loss_ctgry       := giclr032_pkg.cf_loss_ctgryFormula(i.claim_id, i.advice_id);  
        rep.csr_no           := giclr032_pkg.cf_csr_noFormula(i.iss_cd, i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd);
        --rep.tax_input        := giclr032_pkg.get_tax_input(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd); comment out by aliza 10/27/2014                                            
        --rep.tax_others       := giclr032_pkg.get_tax_others(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd); comment out by aliza
        --rep.tax_in_adv       := giclr032_pkg.get_tax_in_adv(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd);  comment out by aliza 10/27/2014
        --rep.tax_oth_adv      := giclr032_pkg.get_tax_oth_adv(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd);comment out by aliza 10/27/2014
        rep.tax_input        := giclr032_pkg.get_tax_input(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd,i.final_tag,i.ex_gratia_sw); --added by aliza 10/27/2014
        rep.tax_others       := giclr032_pkg.get_tax_others(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd,i.final_tag,i.ex_gratia_sw); --added by aliza 10/27/2014            
        rep.tax_in_adv       := giclr032_pkg.get_tax_in_adv(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd,i.final_tag,i.ex_gratia_sw); --added by aliza 10/27/2014
        rep.tax_oth_adv      := giclr032_pkg.get_tax_oth_adv(i.claim_id, i.advice_id, i.payee_class_cd, i.payee_cd,i.final_tag,i.ex_gratia_sw); --added by aliza 10/27/2014
        rep.cf_final         := giclr032_pkg.CF_finalFormula (i.claim_id,i.advice_id,i.name,i.ex_gratia_sw,i.final_tag);
        rep.show_dist        := giclr032_pkg.show_dist(i.line_cd);
        rep.show_peril       := giclr032_pkg.show_peril(i.line_cd);
        rep.signatory_sw     := giacp.v('CSR_PREPARED_BY'); -- andrew - 04.18.2012    
        rep.sum_loss         := NVL(rep.net_amt,0) + NVL(rep.tax_input,0) + NVL(rep.tax_others,0); -- bonok :: 11.28.2012
            
        SELECT short_name
          INTO rep.cf_curr
          FROM giis_currency
         WHERE main_currency_cd = i.currency_cd;  
        
         SELECT param_value_v
          INTO rep.title
          FROM giac_parameters
         WHERE param_name = 'FINAL_CSR_TITLE';
         
        BEGIN
            SELECT param_value_v
              INTO rep.attention
              FROM giac_parameters
             WHERE param_name = 'CSR_ATTN';

        EXCEPTION WHEN NO_DATA_FOUND THEN
            rep.attention := '';
        END;  
               
        FOR assd IN(SELECT assd_name||' '||assd_name2 assured
                      FROM giis_assured 
                     WHERE assd_no = i.acct_of_cd)
        LOOP
            rep.acct_of := assd.assured;
        EXIT;
        END LOOP;
        
        BEGIN
            SELECT nvl(giisp.v('VAT_TITLE'),'Input VAT') 
              INTO rep.vat_label
              FROM dual;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              rep.vat_label := 'Input VAT';  
        END;
        
        -- bonok :: 12.07.2012
        SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, loss_date
          INTO v_line_cd, v_subline_cd, v_pol_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_loss_date
          FROM gicl_claims
         WHERE claim_id = p_claim_id;
        
        rep.label_tag := giclr032_pkg.get_label_tag(v_line_cd, v_subline_cd, v_pol_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_loss_date);
         
        PIPE ROW(rep);
    END LOOP;
 END;  
 
FUNCTION CF_v_spFormula (
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_advice_id        GICL_ADVICE.advice_id%TYPE,
     p_name             VARCHAR2,
     p_ex_gratia_sw     GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
     p_currency_cd      GICL_CLM_LOSS_EXP.currency_cd%TYPE,
     p_paid_amt         GICL_CLM_LOSS_EXP.paid_amt%TYPE,    
     p_final_tag        GICL_CLM_LOSS_EXP.final_tag%TYPE,
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE
    )
   RETURN VARCHAR2 IS
  currency           VARCHAR2(100) := NULL;
  var_v_sp           VARCHAR2(2000);
  var_instr          NUMBER;
  var_lgt_payt       NUMBER;
  var_paid_amt1      NUMBER;
  var_paid_amt1t     NUMBER := 0;
  var_paid_amt1m     NUMBER := 0;
  var_paid_amt1b     NUMBER := 0;
  var_paid_amt2      NUMBER := 0;
  var_spaid_amt1     VARCHAR2(200);
  var_spaid_amt1t    VARCHAR2(200);
  var_spaid_amt1m    VARCHAR2(200);
  var_spaid_amt1b    VARCHAR2(200);
  var_spaid_amt2     VARCHAR2(200);
  var_length         NUMBER := 0;
  var_length1        NUMBER := 0;
  var_length2        NUMBER := 0;
  var_amt            NUMBER := 0;
  var_currency       VARCHAR2(20);
  var_currency_sn    VARCHAR2(3);            
  v_final            VARCHAR2(50);   
  v_param_value_v    giis_parameters.param_value_v%TYPE;
  v_hist_seq_no      gicl_clm_loss_exp.hist_seq_no%TYPE;
  v_remarks          gicl_clm_loss_exp.remarks%TYPE;    
  v_payee_type       VARCHAR2(20); 
  v_ctr                 NUMBER(5) := 0; 
     
 BEGIN   
    v_param_value_v := giisp.v('FINAL_CSR_BEG_TEXT');
    
    IF v_param_value_v IS NOT NULL THEN
         
       RETURN(v_param_value_v);
    ELSE
       FOR i IN (SELECT DISTINCT(payee_type) payee_type
                   FROM gicl_clm_loss_exp a
                  WHERE NVL(dist_sw, 'N') = 'Y'     
                    AND claim_id = p_claim_id
                    AND advice_id = p_advice_id
                    /*comment out by MAC 11/22/2013.
                    AND payee_class_cd IN (SELECT payee_class_cd
                                             FROM giis_payees
                                            WHERE DECODE(payee_first_name,NULL, payee_last_name, payee_first_name||' '|| payee_middle_name||' '|| payee_last_name) = p_name)*/
                    --used payee_class_cd and payee_cd in retrieving distinct payee type by MAC 11/22/2013
                   AND EXISTS ( SELECT 1
                                FROM giis_payees b
                               WHERE DECODE (payee_first_name,
                                             NULL, payee_last_name,
                                                payee_first_name
                                             || ' '
                                             || payee_middle_name
                                             || ' '
                                             || payee_last_name
                                            ) = p_name
                                 AND a.payee_class_cd = b.payee_class_cd
                                 AND a.payee_cd = b.payee_no)
                   AND a.payee_class_cd = p_payee_class_cd
                   AND a.payee_cd = p_payee_cd) 
        LOOP
            IF v_ctr = 0 AND i.payee_type = 'L' THEN --this is for payee type 'L'
                v_ctr := 1;
                v_payee_type := ' loss ';
            ELSIF v_ctr = 0 AND i.payee_type = 'E' THEN --this is for payee type 'E'
                v_ctr := 1;
                v_payee_type := ' expense ';
            ELSIF v_ctr = 1 THEN --this is for more than 1 payee type
                v_payee_type := ' loss/expense ';
            END IF;
        END LOOP;
             
        IF p_ex_gratia_sw = 'Y' THEN
            v_final := ' as Ex Gratia settlement of the'||v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011   
        ELSIF (p_ex_gratia_sw = 'N' OR p_ex_gratia_sw IS NULL) THEN
            IF (p_final_tag = 'N' OR p_final_tag IS NULL) THEN
               v_final := ' as partial settlement of the'||v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011 
            ELSIF p_final_tag = 'Y' THEN
               v_final := 'as full and final settlement of the'||v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011 
            END IF;
        END IF;

        SELECT currency_desc, short_name
          INTO var_currency, var_currency_sn
          FROM giis_currency 
         WHERE main_currency_cd = p_currency_cd;
                     
        SELECT instr(to_char(p_paid_amt), '.', 1)    
          INTO var_instr
          FROM dual;

        var_length := LENGTH(to_char(p_paid_amt * 100 ));
        
        IF var_instr = 0 THEN
            var_paid_amt1 := p_paid_amt;  
        ELSE
            SELECT substr(to_char(p_paid_amt), 1, var_instr - 1)
              INTO var_paid_amt1
              FROM dual;
         
             SELECT substr(to_char(p_paid_amt), var_instr + 1, length(to_char(p_paid_amt)))
               INTO var_paid_amt2
               FROM dual;
        END IF;

        SELECT length(to_char(var_paid_amt1))
          INTO var_lgt_payt
          FROM dual;

        IF var_lgt_payt <= 6  THEN
            var_paid_amt1t  :=  var_paid_amt1;
            var_length1     := LENGTH(to_char(var_paid_amt1t));
                
        ELSIF var_lgt_payt in (9,8,7)  THEN
                
            SELECT substr(to_char(var_paid_amt1), var_lgt_payt - 5, var_lgt_payt)
              INTO var_paid_amt1t
              FROM dual;

            var_length1    := LENGTH(to_char(var_paid_amt1t));
            var_paid_amt1m := var_paid_amt1 - var_paid_amt1t;

            SELECT substr(to_char(var_paid_amt1),0,var_lgt_payt - var_length1)
              INTO var_paid_amt1m 
              FROM dual;

        ELSIF var_lgt_payt IN (10,11,12)  THEN

            SELECT substr(to_char(var_paid_amt1), var_lgt_payt - 5, var_lgt_payt)
              INTO var_paid_amt1t
              FROM dual;
                    
            var_length1 := length(to_char(var_paid_amt1t));

            SELECT substr(to_char(var_paid_amt1), var_lgt_payt - 8, 3)
              INTO var_paid_amt1m
              FROM dual;
                    
            var_length2 := length(to_char(var_paid_amt1m));
            var_paid_amt1b := var_paid_amt1 - var_paid_amt1t - (var_paid_amt1m * 1000000);
                    
            SELECT substr(to_char(var_paid_amt1),0,var_lgt_payt - var_length2-var_length1)
              INTO var_paid_amt1b
              FROM dual;
         END IF;

        IF var_length = 2 THEN
            var_amt := p_paid_amt * 100;
        END IF;
        
        BEGIN
            SELECT MAX(hist_seq_no)
              INTO v_hist_seq_no
              FROM gicl_clm_loss_exp b
             WHERE 1=1
               AND b.claim_id = p_claim_id
               AND b.advice_id = p_advice_id
               AND b.payee_class_cd = p_payee_class_cd
               AND b.payee_cd = p_payee_cd
             GROUP BY b.claim_id, b.advice_id, b.payee_class_cd, b.payee_cd;
        EXCEPTION     
           WHEN NO_DATA_FOUND THEN
                v_hist_seq_no := NULL;
        END;      
  
        BEGIN
            SELECT payee_remarks 
              INTO v_remarks
              FROM gicl_advice
             WHERE 1=1
               AND claim_id = p_claim_id
               AND advice_id = p_advice_id;
        EXCEPTION     
            WHEN NO_DATA_FOUND THEN
                v_remarks := NULL;
        END;

        IF v_remarks IS NOT NULL THEN
           var_v_sp := '       Please issue a check in favor of '||p_name||' '||v_remarks||
                       ' in '||var_currency||' : '||dh_util.check_protect(p_paid_amt,currency,TRUE)||' only (' ||var_currency_sn || 
                       ' ' ||ltrim(to_char(p_paid_amt,'999,999,999,999.00')) ||'), '|| v_final || 'under the following :';
        ELSE
           var_v_sp := '       Please issue a check in favor of '||p_name||
                       ' in '||var_currency||' : '||dh_util.check_protect(p_paid_amt,currency,TRUE)||' only (' ||var_currency_sn|| 
                       ' ' ||ltrim(to_char(p_paid_amt,'999,999,999,999.00')) ||'), '|| v_final || 'under the following :';
        END IF;
     RETURN(var_v_sp);
    END IF;
 END; 
 
FUNCTION CF_termFormula ( p_claim_id      GICL_CLAIMS.claim_id%TYPE)
    RETURN VARCHAR2 IS
  v_eff_date        varchar2(100);
  v_exp_date        varchar2(100);
  v_date            varchar2(100); 
  v_message         varchar2(100);  
 BEGIN
  BEGIN
    SELECT TO_CHAR(MIN(pol_eff_date),'fmMonth dd, yyyy') 
      INTO v_eff_date
      FROM gicl_claims
     WHERE claim_id = p_claim_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_message := 'Claim ID not in GICL_CLM_POLBAS';
  END;

  BEGIN
    SELECT TO_CHAR(MAX(expiry_date),'fmMonth dd, yyyy') 
      INTO v_exp_date
      FROM gicl_claims
     WHERE claim_id = p_claim_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_message := 'Claim ID not in GICL_CLM_POLBAS';
  END;
  
  v_date := v_eff_date||' - '||v_exp_date;

  RETURN(v_date);
 END;
 
FUNCTION CF_intmFormula (p_claim_id     GICL_CLAIMS.claim_id%TYPE)
    RETURN VARCHAR2 IS
  v_intm           varchar2(250);
  v_print_name giac_parameters.param_value_v%TYPE;
  
 BEGIN
    v_intm := null;
    
    BEGIN
        SELECT param_value_v
          INTO v_print_name
          FROM giac_parameters
         WHERE param_name = 'PRINT_INTM_NAME';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_print_name := 'N';
    END;
    
    IF v_print_name = 'N' THEN
        FOR i IN (SELECT distinct to_char(c.intm_no)||' / '||UPPER(nvl(c.ref_intm_cd,' '))INTM
                    FROM gicl_claims a, gicl_intm_itmperil b, giis_intermediary c
                   WHERE a.claim_id = b.claim_id 
                     AND b.intm_no = c.intm_no
                     AND a.claim_id = p_claim_id) 
        LOOP
            IF v_intm IS NULL THEN
                v_intm := i.INTM;
            ELSIF v_intm IS NOT NULL THEN
                v_intm := v_intm ||chr(10)||i.INTM;    
            END IF;
        END LOOP;
  
    ELSE  
        FOR j IN (SELECT distinct to_char(c.intm_no)||' / '||UPPER(nvl(c.ref_intm_cd,' '))||' / '||c.intm_name INTM
                    FROM gicl_claims a, gicl_intm_itmperil b, giis_intermediary c
                   WHERE a.claim_id = b.claim_id 
                     AND b.intm_no = c.intm_no
                     AND a.claim_id = p_claim_id) 
        LOOP
            IF v_intm IS NULL THEN
               v_intm := j.INTM;
            ELSIF v_intm IS NOT NULL THEN
               v_intm := v_intm ||chr(10)||j.INTM;    
            END IF;
        END LOOP;

    END IF;

  RETURN(v_intm);
 END; 

FUNCTION CF_loss_ctgryFormula(
    p_claim_id    GICL_CLAIMS.claim_id%TYPE,
    p_advice_id   GICL_ADVICE.advice_id%TYPE
) 
    RETURN VARCHAR2 IS
  v_loss_cat_des    varchar2(100);
BEGIN
  v_loss_cat_des := NULL;

  FOR i IN (SELECT DISTINCT c.loss_cat_des
              FROM gicl_item_peril a, gicl_clm_loss_exp b,
                   giis_loss_ctgry c
             WHERE a.claim_id = b.claim_id
               AND a.item_no = b.item_no  
               AND a.peril_cd = b.peril_cd
               AND a.line_cd = c.line_cd
               AND a.loss_cat_cd = c.loss_cat_cd
               AND b.claim_id = p_claim_id
               AND b.advice_id = p_advice_id)
  LOOP
    IF v_loss_cat_des IS NULL THEN
       v_loss_cat_des := i.loss_cat_des;
    ELSIF v_loss_cat_des IS NOT NULL THEN
       v_loss_cat_des := v_loss_cat_des ||'/'||i.loss_cat_des;    
    END IF;
  END LOOP;

  RETURN (v_loss_cat_des);
END;

FUNCTION CF_csr_noFormula (
    p_iss_cd            GICL_CLAIMS.iss_cd%TYPE,
    p_claim_id          GICL_CLM_LOSS_EXP.claim_id%TYPE,
    p_advice_id         GICL_CLM_LOSS_EXP.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE       
)
 RETURN VARCHAR2 IS
   v_csr_no      VARCHAR2(50);
    BEGIN
        IF p_iss_cd = 'RI' THEN
            FOR a IN (SELECT c.document_cd ||'-'||c.branch_cd||'-'||c.line_cd||'-'||
                             TO_CHAR(c.doc_year)||'-'||TO_CHAR(c.doc_mm)||'-'||
                             LPAD(TO_CHAR(c.doc_seq_no),6,'0') document 
                        FROM gicl_clm_loss_exp a, giac_inw_claim_payts d,
                             giac_payt_requests_dtl b, giac_payt_requests c
                       WHERE a.claim_id = d.claim_id
                         AND a.advice_id = d.advice_id
                         AND a.clm_loss_id = d.clm_loss_id
                         AND d.gacc_tran_id = b.tran_id
                         AND b.gprq_ref_id = c.ref_id
                         AND b.payt_req_flag <> 'X'
                         AND a.claim_id = p_claim_id
                         AND a.advice_id = p_advice_id
                         AND a.payee_class_cd = p_payee_class_cd
                         AND a.payee_cd = p_payee_cd
                    GROUP BY c.document_cd ||'-'||c.branch_cd||'-'||c.line_cd||'-'||
                             TO_CHAR(c.doc_year)||'-'||TO_CHAR(c.doc_mm)||'-'||LPAD(TO_CHAR(c.doc_seq_no),6,'0')) 
             LOOP
               v_csr_no := a.document;
             END LOOP;
              
        ELSIF p_iss_cd <> 'RI' THEN     
            FOR a IN (SELECT c.document_cd ||'-'||c.branch_cd||'-'||c.line_cd||'-'||
                             TO_CHAR(c.doc_year)||'-'||TO_CHAR(c.doc_mm)||'-'||
                             LPAD(TO_CHAR(c.doc_seq_no),6,'0') document 
                        FROM gicl_clm_loss_exp a, giac_direct_claim_payts d,
                             giac_payt_requests_dtl b, giac_payt_requests c
                       WHERE a.claim_id = d.claim_id
                         AND a.advice_id = d.advice_id
                         AND a.clm_loss_id = d.clm_loss_id
                         AND d.gacc_tran_id = b.tran_id
                         AND b.gprq_ref_id = c.ref_id
                         AND b.payt_req_flag <> 'X'
                         AND a.claim_id = p_claim_id
                         AND a.advice_id = p_advice_id
                         AND a.payee_class_cd = p_payee_class_cd
                         AND a.payee_cd =p_payee_cd
                    GROUP BY c.document_cd ||'-'||c.branch_cd||'-'||c.line_cd||'-'||
                             TO_CHAR(c.doc_year)||'-'||TO_CHAR(c.doc_mm)||'-'||LPAD(TO_CHAR(c.doc_seq_no),6,'0')) 
             LOOP   
                v_csr_no := a.document;
             END LOOP;
             
          --RETURN (v_csr_no); bonok :: 11.19.2012
        END IF;   
        RETURN (v_csr_no); 
    END;
    
FUNCTION get_clm_loss_exp_desc(
    p_claim_id          GICL_CLAIMS.claim_id%TYPE,
    p_advice_id         GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE
)
 RETURN  giclr032_tab PIPELINED IS
    rep     giclr032_type;
 BEGIN
    FOR i IN(SELECT a.claim_id, a.payee_class_cd, a.payee_cd,
                    b.loss_exp_cd, 
                    --SUM( DECODE (b.loss_exp_cd, 'DP', ABS(b.dtl_amt) * -1, b.dtl_amt) * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt,
                    -- bonok :: 01.15.2012 start
                    SUM( b.dtl_amt + NVL( (SELECT SUM ( 
                                     DECODE ( e.tax_type,
                                            --if tax_type is equal to W, multiply its value by -1 
                                            'W', (-1 * ( DECODE ( e.loss_exp_cd,
                                                                --if loss_exp_cd is equal to 0, get the corresponding tax amount for each loss ( (dtl_amt - NVL(ded_amt,0) * tax_pct/100 )
                                                                '0', ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS( f.ded_amt ) * -1 )
                                                                                         FROM GICL_LOSS_EXP_DED_DTL f
                                                                                        WHERE f.claim_id = a.claim_id
                                                                                          AND f.clm_loss_id = a.clm_loss_id
                                                                                          AND f.ded_cd = b.loss_exp_cd ), 0 ) ) * ( e.tax_pct/100 ), 2),
                                                                --if loss_exp_cd is equal to 0-NI, get the corresponding tax amount for each loss ( (dtl_amt - NVL(ded_amt,0 - input_vat) * tax_pct/100 )                                   
                                                                '0-NI', ROUND( ( ( b.dtl_amt + NVL( ( SELECT SUM ( ABS( f.ded_amt ) * -1)
                                                                                                        FROM GICL_LOSS_EXP_DED_DTL f
                                                                                                       WHERE f.claim_id = a.claim_id
                                                                                                         AND f.clm_loss_id = a.clm_loss_id
                                                                                                         AND f.ded_cd = b.loss_exp_cd), 0 ) )
                                                                                             --get input vat 
                                                                                             - NVL( ( SELECT SUM ( DECODE ( g.loss_exp_cd,
                                                                                                                           --if loss_exp_cd is equal to 0, compute for individual tax amount depending on the value of w_tax
                                                                                                                           '0', DECODE ( g.w_tax, 
                                                                                                                                       --if w_tax is equal to Y, get tax amount using this formula : ( (dtl_amt - NVL(ded_amt,0)) / (1+tax_pct/100) * tax_pct/100 )
                                                                                                                                       'Y', ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS(f.ded_amt ) * -1)
                                                                                                                                                                         FROM GICL_LOSS_EXP_DED_DTL f
                                                                                                                                                                        WHERE f.claim_id = a.claim_id
                                                                                                                                                                          AND f.clm_loss_id = a.clm_loss_id
                                                                                                                                                                          AND f.ded_cd = b.loss_exp_cd), 0 ) ) /(1 + g.tax_pct/100) * (g.tax_pct/100), 2), 
                                                                                                                                        --if w_tax is not equal to Y, get tax amount using this formula : ( (dtl_amt - NVL(ded_amt,0)) * tax_pct/100 )    
                                                                                                                                            ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS(f.ded_amt ) * -1)
                                                                                                                                                                         FROM GICL_LOSS_EXP_DED_DTL f
                                                                                                                                                                        WHERE f.claim_id = a.claim_id
                                                                                                                                                                          AND f.clm_loss_id = a.clm_loss_id
                                                                                                                                                                          AND f.ded_cd = b.loss_exp_cd), 0 ) ) * (g.tax_pct/100), 2)), 
                                                                                                                            --if loss_exp_cd is not equal to 0, compute for tax amount based on the value of base_amt
                                                                                                                            DECODE ( g.w_tax,
                                                                                                                                   --if w_tax is equal to Y, get tax amount using this formula : ( (base_amt / (1+tax_pct/100) * tax_pct/100 ) 
                                                                                                                                   'Y', ROUND( g.base_amt /(1 + g.tax_pct/100) * (g.tax_pct/100), 2), 
                                                                                                                                   --if w_tax is not equal to Y, get tax amount using this formula : ( (base_amt * tax_pct/100 ) 
                                                                                                                                   ROUND( g.base_amt * (g.tax_pct/100), 2) )                                               
                                                                                                                            ) 
                                                                                                                    ) 
                                                                                                         FROM gicl_loss_exp_tax g
                                                                                                        WHERE g.claim_id = a.claim_id
                                                                                                          AND g.clm_loss_id = a.clm_loss_id
                                                                                                          AND g.tax_type = 'I'
                                                                                                          AND DECODE(REPLACE(g.loss_exp_cd, '0-'), b.loss_exp_cd, 1, '0', 1, 0) = 1 ), 0) ) 
                                                                              * (e.tax_pct/100), 2 ),
                                                                   --if loss_exp_cd is not equal to 0 and 0-NI, get tax amount using this formula ( base-amt * tax_pct/100 )
                                                                   ROUND( e.base_amt * ( e.tax_pct/100 ), 2 ) )
                                                        )
                                                   ),
                                            --if tax_type is not equal to W
                                            DECODE ( b.w_tax, 
                                                   --if w_tax is equal to Y then return 0
                                                   'Y', 0,
                                                   --if w_tax is not equal to Y,
                                                    DECODE ( e.loss_exp_cd,
                                                           --if loss_exp_cd is equal to 0, get the corresponding tax amount for each loss ( (dtl_amt - NVL(ded_amt,0)) * tax_pct/100 )  
                                                           '0', ROUND( ( b.dtl_amt + NVL( (SELECT SUM ( ABS(f.ded_amt) * -1)
                                                                                             FROM GICL_LOSS_EXP_DED_DTL f
                                                                                            WHERE f.claim_id = a.claim_id
                                                                                              AND f.clm_loss_id = a.clm_loss_id
                                                                                              AND f.ded_cd = b.loss_exp_cd), 0 ) ) * (e.tax_pct/100), 2),
                                                            --if loss_exp_cd is not equal to 0, compute tax amount using this formula : ( base_amt * tax_pct/100 )
                                                           ROUND(e.base_amt * (e.tax_pct/100), 2)                                               
                                                           )
                                                   )    
                                            ) 
                                         )
                               FROM gicl_loss_exp_tax e
                              WHERE e.claim_id = a.claim_id
                                AND e.clm_loss_id = a.clm_loss_id
                                AND DECODE( e.loss_exp_cd, b.loss_exp_cd, 1, '0', 1, '0-NI', 1,
                                    DECODE ( b.loss_exp_cd, REPLACE(e.loss_exp_cd, '0-'), 1, REPLACE(e.loss_exp_cd, '-NI'), 1,
                                    REPLACE(e.loss_exp_cd, '-DI'), 1, 0 ) ) = 1
                              ),                
                         0 ) 
                  * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))
                  ) sum_b_dtl_amt,
                  -- bonok :: 01.15.2012 end
                    c.loss_exp_desc, a.advice_id,                             
                    DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                    d.convert_rate,d.currency_cd
               FROM gicl_clm_loss_exp a, gicl_loss_exp_dtl b,
                    giis_loss_exp c, gicl_advice d
              WHERE a.claim_id = b.claim_id
                AND a.clm_loss_id = b.clm_loss_id
                AND a.payee_type = c.loss_exp_type
                AND b.line_cd = c.line_cd
                AND NVL(b.subline_cd,'XX') = NVL(c.subline_cd,'XX')
                AND b.loss_exp_cd = c.loss_exp_cd
                AND a.claim_id = d.claim_id
                AND a.advice_id = d.advice_id
                AND (b.dtl_amt > 0 OR b.dtl_amt = 0)
                AND d.claim_id = p_claim_id
                AND d.advice_id = p_advice_id 
                AND a.payee_class_cd = p_payee_class_cd
                AND a.payee_cd = p_payee_cd
           GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd,
                    b.loss_exp_cd, c.loss_exp_desc, a.advice_id,                                    
                    DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no), 
                    a.currency_cd, d.currency_cd ,d.convert_rate
           ORDER BY SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))))
    LOOP
        rep.claim_id        := i.claim_id;
        rep.payee_class_cd  := i.payee_class_cd;
        rep.payee_cd        := i.payee_cd;
        rep.loss_exp_cd     := i.loss_exp_cd;
        rep.sum_b_dtl_amt   := i.sum_b_dtl_amt;
        rep.loss_exp_Desc   := i.loss_exp_desc;
        rep.advice_id       := i.advice_id;
        rep.clm_clmnt_no    := i.clm_clmnt_no;
        rep.convert_rate    := i.convert_rate;
        
        SELECT short_name
          INTO rep.cf_curr
          FROM giis_currency
         WHERE main_currency_cd = i.currency_cd;  
        
        PIPE ROW(rep);
    END LOOP;
 END;
 
FUNCTION get_clm_loss_exp_desc2(
    p_claim_id          GICL_CLAIMS.claim_id%TYPE,
    p_advice_id         GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_final_tag          gicl_clm_loss_exp.final_tag%TYPE, --added by aliza 10/27/2014
    p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE  --added by aliza 10/27/2014
)
 RETURN  giclr032_tab PIPELINED IS
    rep     giclr032_type;
    v_menu_line_cd   VARCHAR2(2); --kenneth 05192015
 BEGIN
    FOR i IN(SELECT a.claim_id, a.payee_class_cd, a.payee_cd,
                    b.loss_exp_cd, 
/*                  SUM( DECODE (b.loss_exp_cd, giisp.v('MC_DEPRECIATION_CD'), ABS(b.dtl_amt) * -1, b.dtl_amt) * DECODE(a.currency_cd,GIACP.N
('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt, comment out by kenneth 05192015 for FGIC-19123 replaced by code below*/
                    SUM( b.dtl_amt * DECODE(a.currency_cd,GIACP.N
('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt, 
--end of code added by kenneth 05192015
                    c.loss_exp_desc, a.advice_id,   
                    DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                    d.convert_rate,d.currency_cd
               FROM gicl_clm_loss_exp a, gicl_loss_exp_dtl b,
                    giis_loss_exp c, gicl_advice d
              WHERE a.claim_id = b.claim_id
                AND a.clm_loss_id = b.clm_loss_id
                AND a.payee_type = c.loss_exp_type
                AND b.line_cd = c.line_cd
                AND NVL(b.subline_cd,'XX') = NVL(c.subline_cd,'XX')
                AND b.loss_exp_cd = c.loss_exp_cd
                AND a.claim_id = d.claim_id
                AND a.advice_id = d.advice_id
                AND (b.dtl_amt > 0 OR b.dtl_amt = 0)
                AND d.claim_id = p_claim_id
                AND d.advice_id = p_advice_id 
                AND a.payee_class_cd = p_payee_class_cd
                AND a.payee_cd = p_payee_cd
                AND NVL(a.final_tag,'N') = NVL(p_final_tag,'N') --added by aliza 10/27/2014
                AND NVL(a.ex_gratia_sw,'N') = NVL(p_ex_gratia_sw,'N') --added by aliza 10/27/2014
           GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd,
                    b.loss_exp_cd, c.loss_exp_desc, a.advice_id,                                    
                    DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no), 
                    a.currency_cd, d.currency_cd ,d.convert_rate
           ORDER BY SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))))
    LOOP
        rep.claim_id        := i.claim_id;
        rep.payee_class_cd  := i.payee_class_cd;
        rep.payee_cd        := i.payee_cd;
        rep.loss_exp_cd     := i.loss_exp_cd;
        --added by replaced by kenneth 05192015
        BEGIN
           SELECT nvl(menu_line_cd, line_cd)
             INTO v_menu_line_cd
             FROM giis_line
            WHERE line_cd = (SELECT DISTINCT line_cd
                                         FROM gicl_claims
                                        WHERE claim_id = i.claim_id);
        END;
       
        IF i.loss_exp_cd = giisp.v('MC_DEPRECIATION_CD') AND (v_menu_line_cd = giisp.v('LINE_CODE_MC'))
        THEN
          rep.sum_b_dtl_amt := ABS(i.sum_b_dtl_amt) * -1;
        ELSE
          rep.sum_b_dtl_amt := i.sum_b_dtl_amt;
        END IF;
        --end of code added by replaced by kenneth 05192015   
    
        --rep.sum_b_dtl_amt   := i.sum_b_dtl_amt; -- replaced by kenneth 05192015
        rep.loss_exp_Desc   := i.loss_exp_desc;
        rep.advice_id       := i.advice_id;
        rep.clm_clmnt_no    := i.clm_clmnt_no;
        rep.convert_rate    := i.convert_rate;
        
        SELECT short_name
          INTO rep.cf_curr
          FROM giis_currency
         WHERE main_currency_cd = i.currency_cd;  
        
        PIPE ROW(rep);
    END LOOP;
 END;    

FUNCTION get_clm_deductibles(
    p_claim_id          GICL_CLAIMS.claim_id%TYPE,
    p_advice_id         GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd    GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd          GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,                --added by aliza 10/27/2014
    p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE        --added by aliza 10/27/2014    
)
 RETURN  giclr032_tab PIPELINED IS
    rep     giclr032_type;
 BEGIN
    FOR i IN(SELECT a.claim_id, a.payee_class_cd, a.payee_cd,
                    b.loss_exp_cd, 
                    SUM( DECODE (b.loss_exp_cd, 'DP', ABS(b.dtl_amt) * -1, b.dtl_amt) * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))) sum_b_dtl_amt,
                    c.loss_exp_desc, a.advice_id,                             
                    DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                    d.convert_rate
               FROM gicl_clm_loss_exp a, gicl_loss_exp_dtl b,
                    giis_loss_exp c, gicl_advice d
              WHERE a.claim_id = b.claim_id
                AND a.clm_loss_id = b.clm_loss_id
                AND a.payee_type = c.loss_exp_type
                AND b.line_cd = c.line_cd
                AND NVL(b.subline_cd,'XX') = NVL(c.subline_cd,'XX')
                AND b.loss_exp_cd = c.loss_exp_cd
                AND a.claim_id = d.claim_id
                AND a.advice_id = d.advice_id
                AND b.dtl_amt < 0 
                AND d.claim_id = p_claim_id
                AND d.advice_id = p_advice_id 
                AND a.payee_class_cd = p_payee_class_cd
                AND a.payee_cd = p_payee_cd
                AND NVL(a.final_tag,'N') = NVL(p_final_tag,'N') --added by aliza 10/27/2014
                AND NVL(a.ex_gratia_sw,'N') = NVL(p_ex_gratia_sw,'N') --added by aliza 10/27/2014
           GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd,
                    b.loss_exp_cd, c.loss_exp_desc, a.advice_id,                                    
                    DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no), 
                    a.currency_cd,d.convert_rate
          ORDER BY SUM(b.dtl_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,d.currency_cd,1,NVL(d.orig_curr_rate,d.convert_rate))))
    LOOP
        rep.claim_id        := i.claim_id;
        rep.payee_class_cd  := i.payee_class_cd;
        rep.payee_cd        := i.payee_cd;
        rep.loss_exp_cd     := i.loss_exp_cd;
        rep.sum_b_dtl_amt   := i.sum_b_dtl_amt;
        rep.loss_exp_Desc   := i.loss_exp_desc;
        rep.advice_id       := i.advice_id;
        rep.clm_clmnt_no    := i.clm_clmnt_no;
        rep.convert_rate    := i.convert_rate;
        
        PIPE ROW(rep);
    END LOOP;
 END;         

FUNCTION get_tax_input(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,        --added by aliza 10/27/2014
    p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE        --added by aliza 10/27/2014
    )
 RETURN NUMBER IS
    
    v_tax_input     GICL_LOSS_EXP_TAX.tax_amt%TYPE; 
    
    BEGIN
        FOR i IN(SELECT a.claim_id claim_id, a.payee_class_cd payee_class_cd, a.payee_cd payee_cd, a.advice_id advice_id,
                        DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                        SUM(a.sum_tax_amt) sum_sum_tax_amt, SUM(a.sum_b_tax_amt) sum_sum_b_tax_amt
                   FROM (SELECT a.claim_id claim_id, a.payee_class_cd payee_class_cd, a.payee_cd payee_cd, a.advice_id advice_id, b.w_tax w_tax,
                                DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                                DECODE(b.w_tax,'Y',0,(SUM(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd, 1,nvl(c.orig_curr_rate,c.convert_rate))))) sum_tax_amt,
                                SUM(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1, nvl(c.orig_curr_rate,c.convert_rate))) sum_b_tax_amt, c.convert_rate convert_rate
                           FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b, gicl_advice c
                          WHERE a.claim_id = b.claim_id
                            AND a.clm_loss_id = b.clm_loss_id
                            AND a.claim_id = c.claim_id
                            AND a.advice_id = c.advice_id
                            AND b.tax_type = 'I'
                            AND a.claim_id = p_claim_id
                            AND a.advice_id = p_advice_id
                            AND a.payee_class_cd = p_payee_class_cd
                            AND a.payee_cd = p_payee_cd
                            AND NVL(a.final_tag,'N') = p_final_tag --added by aliza 10/27/2014
                            AND a.ex_gratia_sw = p_ex_gratia_sw  --added by aliza 10/27/2014
                       GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id, b.w_tax,
                                DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no),
                                DECODE(b.w_tax,'N',(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd, nvl(c.orig_curr_rate,c.convert_rate))),NULL,(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd, nvl(c.orig_curr_rate,c.convert_rate))),'Y',0), 
                            a.currency_cd, c.convert_rate) a
                 GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id,DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) ) 
         LOOP
            v_tax_input   := i.sum_sum_b_tax_amt;   
         END LOOP;
     RETURN(v_tax_input);
    END; 
    
FUNCTION get_tax_others(
    p_claim_id         GICL_CLAIMS.claim_id%TYPE,
    p_advice_id        GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,    --added by aliza 10/27/2014
    p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE    --added by aliza 10/27/2014
    )
 RETURN NUMBER IS
    
    v_tax_others     GICL_LOSS_EXP_TAX.tax_amt%TYPE; 
    
    BEGIN
        FOR i IN(SELECT SUM(a.sum_a_tax_amt) sum_sum_a_tax_amt
                   FROM (SELECT a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id,
                                DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                                DECODE(b.net_tag,'N',(SUM(b.tax_amt * DECODE(a.currency_cd,giacp.n('CURRENCY_CD'),1,c.currency_cd, 1,nvl(c.orig_curr_rate,c.convert_rate)))),
                                -(SUM(b.tax_amt* DECODE(a.currency_cd,giacp.n('CURRENCY_CD'),1,c.currency_cd, 1,nvl(c.orig_curr_rate,c.convert_rate)))))sum_a_tax_amt
                           FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b,
                                gicl_advice c
                          WHERE a.claim_id = b.claim_id
                            AND a.clm_loss_id = b.clm_loss_id
                            AND a.claim_id = c.claim_id
                            AND a.advice_id = c.advice_id
                            AND b.tax_type IN ('O','W')
                            AND c.claim_id = p_claim_id
                            AND c.advice_id = p_advice_id
                            AND a.payee_class_cd = p_payee_class_cd
                            AND a.payee_cd = p_payee_cd
                            AND NVL(a.final_tag,'N') = NVL(p_final_tag,'N') --added by aliza 10/27/2014
                            AND NVL(a.ex_gratia_sw,'N') = NVL(p_ex_gratia_sw,'N') --added by aliza 10/27/2014
                       GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id, DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no), 
                                a.currency_cd,  b.net_tag) a )
         LOOP
            v_tax_others   := i.sum_sum_a_tax_amt;   
         END LOOP;
     RETURN(v_tax_others);
    END;  

FUNCTION get_tax_oth_adv(
    p_claim_id         GICL_CLAIMS.claim_id%TYPE,
    p_advice_id        GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,     --added by aliza 10/27/2014                                              
    p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE    --added by aliza 10/27/2014 
    )
 RETURN NUMBER IS
    
     v_tax_oth_adv     GICL_LOSS_EXP_TAX.tax_amt%TYPE;  
    
    BEGIN
        FOR i IN(SELECT a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id,
                        DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                        -(SUM(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1, nvl(c.orig_curr_rate,c.convert_rate))))  sum_d_tax_amt
                   FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b,
                        gicl_advice c
                  WHERE a.claim_id = b.claim_id
                    AND a.clm_loss_id = b.clm_loss_id
                    AND a.claim_id = c.claim_id
                    AND a.advice_id = c.advice_id
                    AND b.tax_type IN ('O','W')
                    AND b.adv_tag = 'Y'
                    AND c.claim_id = p_claim_id
                    AND c.advice_id = p_advice_id
                    AND a.payee_class_cd = p_payee_class_cd
                    AND a.payee_cd = p_payee_cd
                    AND NVL(a.final_tag,'N') = NVL(p_final_tag,'N') --added by aliza 10/27/2014
                    AND NVL(a.ex_gratia_sw,'N') = NVL(p_ex_gratia_sw,'N') --added by aliza 10/27/2014                    
               GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id,                         
                        DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no), a.currency_cd )
         LOOP
            v_tax_oth_adv   := i.sum_d_tax_amt; 
         END LOOP;
       RETURN (v_tax_oth_adv);
    END;    

FUNCTION get_tax_in_adv(
    p_claim_id         GICL_CLAIMS.claim_id%TYPE,
    p_advice_id        GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
    p_payee_cd         GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,      --added by aliza 10/27/2014
    p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE      --added by aliza 10/27/2014    
    )
 RETURN NUMBER IS
    
    v_tax_in_adv    GICL_LOSS_EXP_TAX.tax_amt%TYPE; 
    
    BEGIN
        FOR i IN(SELECT a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id,
                        DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no) clm_clmnt_no,
                        -(SUM(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd, 1,nvl(c.orig_curr_rate,c.convert_rate)))) sum_c_tax_amt
                   FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b,
                        gicl_advice c
                  WHERE a.claim_id = b.claim_id
                    AND a.clm_loss_id = b.clm_loss_id
                    AND a.claim_id = c.claim_id
                    AND a.advice_id = c.advice_id
                    AND b.tax_type = 'I'
                    AND b.adv_tag = 'Y'
                    AND c.claim_id = p_claim_id
                    AND c.advice_id = p_advice_id
                    AND a.payee_class_cd = p_payee_class_cd
                    AND a.payee_cd = p_payee_cd
                    AND NVL(a.final_tag,'N') = NVL(p_final_tag,'N') --added by aliza 10/27/2014
                    AND NVL(a.ex_gratia_sw,'N') = NVL(p_ex_gratia_sw,'N') --added by aliza 10/27/2014                    
               GROUP BY a.claim_id, a.payee_class_cd, a.payee_cd, a.advice_id, 
                         DECODE(a.clm_clmnt_no,NULL,0,a.clm_clmnt_no), a.currency_cd, c.convert_rate )
        LOOP
            v_tax_in_adv   := i.sum_c_tax_amt;  
        END LOOP;
       RETURN(v_tax_in_adv);
    END; 

FUNCTION CF_finalFormula (
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_name          VARCHAR2,
    p_ex_gratia_sw  GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
    p_final_tag     GICL_CLM_LOSS_EXP.final_tag%TYPE
)
 RETURN VARCHAR2 IS
    v_payee_type         VARCHAR2(20); 
    v_ctr                NUMBER(5) := 0; 
    v_final              VARCHAR2(200);
    BEGIN
        FOR i IN (SELECT DISTINCT(payee_type) payee_type
                    FROM gicl_clm_loss_exp a
                   WHERE NVL(dist_sw, 'N') = 'Y'     
                     AND claim_id = p_claim_id
                     AND advice_id = p_advice_id
                     /*comment out by MAC 11/22/2013.
                     AND payee_class_cd IN (SELECT payee_class_cd
                                              FROM giis_payees
                                             WHERE DECODE(payee_first_name,NULL, payee_last_name, payee_first_name||' '|| 
                                                          payee_middle_name||' '|| payee_last_name) = p_name) )*/
                     --used payee_class_cd and payee_cd in retrieving distinct payee type by MAC 11/22/2013
                     AND EXISTS ( SELECT 1
                                    FROM giis_payees b
                                   WHERE DECODE (payee_first_name,
                                                 NULL, payee_last_name,
                                                    payee_first_name
                                                 || ' '
                                                 || payee_middle_name
                                                 || ' '
                                                 || payee_last_name
                                                ) = p_name
                                     AND a.payee_class_cd = b.payee_class_cd
                                     AND a.payee_cd = b.payee_no))
        LOOP
            IF v_ctr = 0 AND i.payee_type = 'L' THEN --this is for payee type 'L'
                v_ctr := 1;
                v_payee_type := ' loss.';
            ELSIF v_ctr = 0 AND i.payee_type = 'E' THEN --this is for payee type 'E'
                v_ctr := 1;
                v_payee_type := ' expense.';
            ELSIF v_ctr = 1 THEN --this is for more than 1 payee type
                v_payee_type := ' loss/expense.';
            END IF;
        END LOOP;
        
        IF p_ex_gratia_sw = 'Y' then
            v_final := 'As Ex Gratia settlement of the above'||v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011   
        ELSIF (p_ex_gratia_sw = 'N' or p_ex_gratia_sw is null) then
            IF (p_final_tag is null) or (p_final_tag = 'N') then
               v_final := 'As partial settlement of the above'||v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011 
            ELSIF p_final_tag = 'Y' then
               v_final := 'As full and final settlement of the above'||v_payee_type; --modified static 'loss' to variable v_payee_type by MAC 10/19/2011 
            END IF;
        END IF;
     RETURN (v_final); 
    END;       

FUNCTION get_clm_perils(
    p_claim_id      GICL_CLAIMS.claim_id%TYPE,
    p_advice_id     GICL_ADVICE.advice_id%TYPE,
    p_line_cd       GICL_ADVICE.line_cd%TYPE
)
  RETURN giclr032_tab PIPELINED IS
    rep       giclr032_type;
    BEGIN
        FOR i IN (SELECT a.claim_id, a.advice_id, a.peril_cd, a.payee_class_cd, a.payee_cd, 
                         SUM(a.paid_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,b.currency_cd, 1,nvl(b.orig_curr_rate,b.convert_rate))) peril_paid_amt
                    FROM gicl_clm_loss_exp a, gicl_advice b
                   WHERE a.claim_id = b.claim_id
                     AND a.advice_id = b.advice_id
                     AND a.claim_id = p_claim_id
                     AND a.advice_id = p_advice_id 
                GROUP BY a.claim_id, a.advice_id, a.peril_cd, a.payee_class_cd, a.payee_cd, a.currency_cd )
        LOOP
            rep.peril_paid_amt  := i.peril_paid_amt;
            
            BEGIN
                SELECT peril_sname
                  INTO rep.peril_sname
                  FROM giis_peril
                 WHERE line_cd = p_line_cd
                   AND peril_cd = i.peril_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                    rep.peril_sname := '';
            END;

            PIPE ROW(rep);   
        END LOOP;                      
    END;

FUNCTION get_payment_dtls(
    p_claim_id           GICL_CLAIMS.claim_id%TYPE,
    p_advice_id          GICL_ADVICE.advice_id%TYPE,
    p_payee_class_cd     GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd           GICL_CLM_LOSS_EXP.payee_cd%TYPE
)
  RETURN giclr032_tab PIPELINED IS
  rep               giclr032_type;
  v_doc_type_desc   VARCHAR2(100);
    BEGIN
        FOR i IN (SELECT a.class_desc, b.doc_number,b.doc_type, b.claim_id, d.advice_id,d.payee_class_cd,d.payee_cd,
                         b.claim_loss_id,  
                         c.payee_last_name||' '||c.payee_first_name||' '||c.payee_middle_name payee_name
                    FROM giis_payee_class a,  gicl_loss_exp_bill b, giis_payees c, gicl_clm_loss_exp d
                   WHERE a.payee_class_cd=b.payee_class_cd
                     AND a.payee_class_cd=c.payee_class_cd
                     AND b.payee_cd=c.payee_no
                     AND b.claim_id=d.claim_id
                     AND b.claim_loss_id=d.clm_loss_id
                     AND d.claim_id = p_claim_id
                     AND d.advice_id = p_advice_id
                     AND d.payee_class_cd = p_payee_class_cd
                     AND d.payee_cd = p_payee_cd)
        LOOP        
            SELECT rv_meaning 
              INTO v_doc_type_desc
              from cg_ref_codes
             where rv_domain='GICL_LOSS_EXP_BILL.DOC_TYPE'
               and rv_low_value = i.doc_type;
            
            rep.doc_type_desc := v_doc_type_desc || ' Number';  
            rep.payment_for   := i.class_desc||' '||i.payee_name;
            rep.doc_no        := i.doc_number;
           
            PIPE ROW (rep); 
        END LOOP;              
    END;

FUNCTION get_clm_signatory(
    p_line_cd       GIIS_LINE.line_cd%TYPE,
    p_branch_cd     GICL_CLAIMS.iss_cd%TYPE,
    p_user          GIIS_USERS.user_id%TYPE
)
  RETURN giclr032_tab PIPELINED IS
  rep             giclr032_type;
  v_cnt           NUMBER := 0;
    BEGIN
        
        SELECT COUNT( * ) 
          INTO v_cnt
          FROM giac_documents a, giac_rep_signatory b
         WHERE a.report_no = b.report_no
           AND a.report_id = b.report_id
           AND a.report_id = 'GICLR032'
           AND a.line_cd   = p_line_cd
           AND NVL(a.branch_cd, p_branch_cd) = p_branch_cd;    
    
        FOr i IN(SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation
                  FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND a.report_id = b.report_id
                   AND a.report_id = 'GICLR032'
                   AND NVL (a.line_cd, NVL (p_line_cd, '@')) = NVL (p_line_cd, '@')
                   AND NVL (a.branch_cd, NVL (p_branch_cd, '@')) = NVL (p_branch_cd, '@')
                   AND b.signatory_id = c.signatory_id
                MINUS
                SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation
                  FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND a.report_id = b.report_id
                   AND a.report_id = 'GICLR032'
                   AND (a.line_cd IS NULL OR a.branch_cd IS NULL)
                   AND EXISTS (SELECT 1
                                 FROM giac_documents
                                WHERE report_id = 'GICLR032' 
                                  AND line_cd = p_line_cd 
                                  AND branch_cd = p_branch_cd)
                   AND b.signatory_id = c.signatory_id
                MINUS
                SELECT DECODE (v_cnt, 0, a.report_no, b.report_no) report_no, DECODE (v_cnt, 0, a.item_no, b.item_no) item_no,
                       DECODE (v_cnt, 0, a.label, b.label) label, DECODE (v_cnt, 0, a.signatory, b.signatory) signatory,
                       DECODE (v_cnt, 0, a.designation, b.designation) designation
                  FROM (SELECT a.report_id, a.report_no, b.item_no, b.label, c.signatory, c.designation
                          FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                         WHERE a.report_no = b.report_no
                           AND a.report_id = b.report_id
                           AND a.report_id = 'GICLR032'
                           AND (a.line_cd IS NULL AND a.branch_cd IS NULL)
                           AND EXISTS (SELECT 1
                                         FROM giac_documents
                                        WHERE report_id = 'GICLR032' 
                                          AND line_cd = p_line_cd 
                                          AND branch_cd = p_branch_cd)
                           AND b.signatory_id = c.signatory_id) a,
                       (SELECT a.report_id, a.report_no, b.item_no, b.label, c.signatory, c.designation
                          FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                         WHERE a.report_no = b.report_no
                           AND a.report_id = b.report_id
                           AND a.report_id = 'GICLR032'
                           AND (a.line_cd IS NULL AND a.branch_cd IS NULL)
                           AND b.signatory_id = c.signatory_id) b
                 WHERE a.report_id(+) = b.report_id AND a.report_no(+) = b.report_no)
        LOOP
            rep.label       := i.label;
            rep.signatory   := i.signatory;
            rep.designation := i.designation; 
            
            PIPE ROW(rep);
        END LOOP;
    END; 

FUNCTION show_dist(p_line_cd     GICL_CLAIMS.line_cd%TYPE)
  RETURN VARCHAR2 IS
  v_csr_dist_display        varchar2(1):= 'Y';
BEGIN
  IF p_line_cd = 'MC' THEN
      SELECT param_value_v
        INTO v_csr_dist_display
        FROM giac_parameters
       WHERE param_name = 'CSR_DIST_DISPLAY';
  END IF;
  RETURN (v_csr_dist_display);
END;

FUNCTION show_peril(p_line_cd     GICL_CLAIMS.line_cd%TYPE)
  RETURN VARCHAR2 IS
    v_show_csr_peril      varchar2(1);
    v_show                varchar2(1);
BEGIN
  BEGIN
      SELECT param_value_v
        INTO v_show_csr_peril
        FROM giis_parameters
       WHERE param_name = 'SHOW_CSR_PERIL';  
  END;    
  
  IF p_line_cd = 'SU' OR NVL(v_show_csr_peril,'N') <> 'Y' THEN
     v_show := 'N' ;
  ELSE
     v_show := 'Y' ;
  END IF;
  RETURN (v_show);
END;
    

/**
** Modified by: Andrew Robes
** Date : 11.28.2012
** Modification : Check if there are maintained signatory for line_cd and branch_cd, if none the signatory maintained for all lines and branches will be used
*/
    FUNCTION get_clm_signatory2 (
       p_line_cd     giis_line.line_cd%TYPE,
       p_branch_cd   gicl_claims.iss_cd%TYPE,
       p_user        giis_users.user_id%TYPE
    )
       RETURN giclr032_tab PIPELINED
    IS
       rep     giclr032_type;
       v_cnt   NUMBER        := 0;
    BEGIN
       FOR i IN (SELECT   a.report_no, b.item_no, b.label, c.signatory, c.designation
                    FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = b.report_id
                     AND a.report_id = 'GICLR032'
                     --AND NVL (a.line_cd, '@') = NVL (p_line_cd, '@')--  Comment out by bonok :: 7.13.2015 :: UCPB Fullweb
                     --AND NVL (a.branch_cd, '@') = NVL (p_branch_cd, '@')
                     AND NVL (a.line_cd, p_line_cd) = p_line_cd 
                     AND NVL (a.branch_cd, p_branch_cd) = p_branch_cd -- Modified by Jerome Bautista 08.12.2015 SR 19877 / 19828
                     AND b.signatory_id = c.signatory_id
                UNION
                SELECT   1 rep_no, 1 item_no, 'Prepared By :' lbel, user_name, ' ' designation
                    FROM giis_users
                   WHERE user_id = p_user
                ORDER BY 2)
       LOOP
          rep.label := i.label;
          rep.signatory := i.signatory;
          rep.designation := i.designation;
          
          PIPE ROW (rep);
       END LOOP;
    END;
    
    FUNCTION get_label_tag(
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,   
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE,
        p_loss_date             GIPI_POLBASIC.eff_date%TYPE
    )
        RETURN VARCHAR2 
    IS
        v_label_tag                VARCHAR2(1);
        v_max_eff_date1         gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of backward endt with update
          v_max_eff_date2         gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of endt with no update
          v_max_eff_date          gipi_wpolbas.eff_date%TYPE;   --store eff_date to be use to retrieve assured
          v_eff_date              gipi_wpolbas.eff_date%TYPE;   --store policy's eff_date
          v_policy_id             gipi_polbasic.policy_id%TYPE; --store policy's policy_id
          v_max_endt_seq_no       gipi_wpolbas.endt_seq_no%TYPE;--store the maximum endt_seq_no for all endt
          v_max_endt_seq_no1      gipi_wpolbas.endt_seq_no%TYPE;--store the maximum endt_seq_no for backward endt. with back_stat = '2'
        v_expiry_date2            GIPI_POLBASIC.expiry_date%TYPE;
        v_expiry_date            VARCHAR2(100);
    BEGIN
        
        extract_expiry4(p_line_cd, p_subline_cd, p_pol_iss_cd,
                  p_issue_yy, p_pol_seq_no, p_renew_no, p_loss_date, v_expiry_date, v_expiry_date2);
                  
        --Gipi_Polbasic_Pkg.get_eff_date_policy_id
        --get policy id and effectivity of policy 
        FOR x IN (SELECT b2501.eff_date eff_date, b2501.policy_id
                    FROM gipi_polbasic b2501
                   WHERE b2501.line_cd = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd = p_pol_iss_cd
                     AND b2501.issue_yy = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no = p_renew_no
                     AND b2501.pol_flag IN ('1', '2', '3', 'X')
                     AND b2501.endt_seq_no = 0)
          LOOP
            v_eff_date := x.eff_date;
          END LOOP;
        
        --search_for_assured3
        --get the maximum endt_seq_no from all endt. of the policy
          FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
                      FROM gipi_polbasic b2501
                    WHERE b2501.line_cd    = p_line_cd
                        AND b2501.subline_cd = p_subline_cd
                        AND b2501.iss_cd     = p_pol_iss_cd
                        AND b2501.issue_yy   = p_issue_yy
                        AND b2501.pol_seq_no = p_pol_seq_no
                        AND b2501.renew_no   = p_renew_no
                        AND b2501.pol_flag   IN ('1','2','3','X')
                        AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                     AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         v_expiry_date2, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                        AND b2501.assd_no IS NOT NULL ) 
          LOOP
            v_max_endt_seq_no := w.endt_seq_no;  
            EXIT;
          END LOOP;
        
        --if maximum endt_seq_no is greater than 0 then check if latest
          --assured should be from latest backward endt with update or  
          -- from the latest endt that is not backward 
          IF v_max_endt_seq_no > 0 THEN
             --get maximum endt_seq_no for backward endt. with updates
             FOR G IN (SELECT MAX(b2501.endt_seq_no) endt_seq_no
                        FROM gipi_polbasic b2501
                       WHERE b2501.line_cd    = p_line_cd
                           AND b2501.subline_cd = p_subline_cd
                           AND b2501.iss_cd     = p_pol_iss_cd
                           AND b2501.issue_yy   = p_issue_yy
                           AND b2501.pol_seq_no = p_pol_seq_no
                           AND b2501.renew_no   = p_renew_no
                           AND b2501.pol_flag   IN ('1','2','3','X')
                           AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                           AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                             v_expiry_date2, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                           AND b2501.assd_no IS NOT NULL 
                           AND nvl(b2501.back_stat,5) = 2) 
             LOOP
                   v_max_endt_seq_no1 := g.endt_seq_no;
               EXIT;
             END LOOP;
             --if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
             --backward endt. with update then get max. eff_date for both condition
             IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
            --get max. eff_date for backward endt with updates
                FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                            FROM gipi_polbasic b2501
                              WHERE b2501.line_cd    = p_line_cd
                              AND b2501.subline_cd = p_subline_cd
                               AND b2501.iss_cd     = p_pol_iss_cd
                              AND b2501.issue_yy   = p_issue_yy
                              AND b2501.pol_seq_no = p_pol_seq_no
                              AND b2501.renew_no   = p_renew_no
                              AND b2501.pol_flag   IN ('1','2','3','X')
                              AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                              AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                                  v_expiry_date2, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                              AND nvl(b2501.back_stat,5) = 2
                              AND b2501.assd_no IS NOT NULL 
                              AND b2501.endt_seq_no = v_max_endt_seq_no1)
                LOOP
                      v_max_eff_date1 := z.eff_date;
                  EXIT;
                END LOOP;                                 
                --get max eff_date for endt 
                FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
                            FROM gipi_polbasic b2501
                              WHERE b2501.line_cd    = p_line_cd
                              AND b2501.subline_cd = p_subline_cd
                              AND b2501.iss_cd     = p_pol_iss_cd
                              AND b2501.issue_yy   = p_issue_yy
                              AND b2501.pol_seq_no = p_pol_seq_no
                              AND b2501.renew_no   = p_renew_no
                              AND b2501.endt_seq_no != 0
                              AND b2501.pol_flag   IN ('1','2','3','X')
                              AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                              AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                                    v_expiry_date2, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                              AND nvl(b2501.back_stat,5)!= 2
                              AND b2501.assd_no IS NOT NULL ) 
                LOOP
                      v_max_eff_date2 := y.eff_date;
                  EXIT;
                END LOOP;               
                    v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
             ELSE
                --assd_no should be from the latest backward endt. with updates
                FOR C IN (SELECT MAX(b2501.eff_date) eff_date
                             FROM gipi_polbasic b2501
                              WHERE b2501.line_cd    = p_line_cd
                               AND b2501.subline_cd = p_subline_cd
                               AND b2501.iss_cd     = p_pol_iss_cd
                               AND b2501.issue_yy   = p_issue_yy
                               AND b2501.pol_seq_no = p_pol_seq_no
                               AND b2501.renew_no   = p_renew_no
                               AND b2501.pol_flag   IN ('1','2','3','X')
                               AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                               AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                                    v_expiry_date2, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                               AND nvl(b2501.back_stat,5) = 2
                               AND b2501.endt_seq_no = v_max_endt_seq_no1
                               AND b2501.assd_no IS NOT NULL ) 
                LOOP
                      v_max_eff_date := c.eff_date;
                  EXIT;
                END LOOP;                      
             END IF;
          ELSE
             --eff_date should be from policy for records with no endt or 
             --no valid endt. that meets the conditions set
             v_max_eff_date := v_eff_date;                
          END IF;
        
        --get assured from records with eff_date equal to the derived eff_date
        FOR A1 IN (SELECT b2501.label_tag
                        FROM gipi_polbasic b2501
                      WHERE b2501.line_cd    = p_line_cd
                      AND b2501.subline_cd = p_subline_cd
                      AND b2501.iss_cd     = p_pol_iss_cd
                      AND b2501.issue_yy   = p_issue_yy
                      AND b2501.pol_seq_no = p_pol_seq_no
                      AND b2501.renew_no   = p_renew_no
                      AND b2501.pol_flag   IN ('1','2','3','X') 
                      AND TRUNC(b2501.eff_date)   = TRUNC(v_max_eff_date)
                       ORDER BY b2501.endt_seq_no DESC)
        LOOP
            v_label_tag := a1.label_tag;            
        EXIT;
          END LOOP;
        
        RETURN v_label_tag;
    END;    
END;
/
