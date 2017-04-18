CREATE OR REPLACE PACKAGE BODY CPI.GIAC_INW_CLAIM_PAYTS_PKG
AS

  /*
  **  Created by   :  Emman
  **  Date Created :  10.26.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Gets GIAC Inw Claim Payts details of specified transaction Id 
  */ 
  FUNCTION get_giac_inw_claim_payts (p_gacc_tran_id        GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE)
     RETURN giac_inw_claim_payts_tab PIPELINED
  IS
      v_inw_claim_payts                 giac_inw_claim_payts_type;
    v_dummy                             VARCHAR2(60) := '';
  BEGIN
      FOR i IN (SELECT a.gacc_tran_id, a.claim_id, a.clm_loss_id, a.or_print_tag, a.transaction_type, a.advice_id,
                     a.payee_type, DECODE(a.payee_type, 'L', 'Loss', 'E', 'Expense', 'N/A') dsp_payee_desc,
                     DECODE (b.payee_first_name, null, b.payee_last_name, b.payee_last_name ||', '|| b.payee_first_name ||' '|| b.payee_middle_name) dsp_payee_name,
                     a.payee_class_cd, a.payee_cd, a.disbursement_amt, a.input_vat_amt, a.wholding_tax_amt, a.net_disb_amt,
                     a.remarks, a.user_id, a.last_update, a.currency_cd, c.currency_desc, a.convert_rate, a.foreign_curr_amt,
                     d.iss_cd dsp_iss_cd, d.line_cd dsp_line_cd, d.advice_year dsp_advice_year, d.advice_seq_no dsp_advice_seq_no
                FROM GIAC_INW_CLAIM_PAYTS a, GIIS_PAYEES b, GIIS_CURRENCY c, GICL_ADVICE d
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND b.payee_class_cd = a.payee_class_cd
                    AND b.payee_no = a.payee_cd
                 AND c.main_currency_cd = a.currency_cd (+)
                 AND d.claim_id = a.claim_id
                 AND d.advice_id = a.advice_id)
    LOOP
        v_inw_claim_payts.gacc_tran_id                       := i.gacc_tran_id;
        v_inw_claim_payts.claim_id                        := i.claim_id;
        v_inw_claim_payts.clm_loss_id                    := i.clm_loss_id;
        v_inw_claim_payts.or_print_tag                    := i.or_print_tag;
        v_inw_claim_payts.transaction_type                := i.transaction_type;
        v_inw_claim_payts.advice_id                        := i.advice_id;
        v_inw_claim_payts.payee_type                    := i.payee_type;
        v_inw_claim_payts.dsp_payee_desc                := i.dsp_payee_desc;
        v_inw_claim_payts.dsp_payee_name                := i.dsp_payee_name;
        v_inw_claim_payts.payee_class_cd                := i.payee_class_cd;
        v_inw_claim_payts.payee_cd                        := i.payee_cd;
        v_inw_claim_payts.dsp_payee_name                := i.dsp_payee_name;
        v_inw_claim_payts.disbursement_amt                := i.disbursement_amt;
        v_inw_claim_payts.input_vat_amt                    := i.input_vat_amt;
        v_inw_claim_payts.wholding_tax_amt                := i.wholding_tax_amt;
        v_inw_claim_payts.net_disb_amt                    := i.net_disb_amt;
        v_inw_claim_payts.remarks                        := i.remarks;
        v_inw_claim_payts.user_id                        := i.user_id;
        v_inw_claim_payts.last_update                    := i.last_update;
        v_inw_claim_payts.currency_cd                    := i.currency_cd;
        v_inw_claim_payts.curr_desc                        := i.currency_desc;
        v_inw_claim_payts.convert_rate                    := i.convert_rate;
        v_inw_claim_payts.foreign_curr_amt                := i.foreign_curr_amt;
        v_inw_claim_payts.dsp_iss_cd                    := i.dsp_iss_cd;
        v_inw_claim_payts.dsp_line_cd                    := i.dsp_line_cd;
        v_inw_claim_payts.dsp_advice_year                := i.dsp_advice_year;
        v_inw_claim_payts.dsp_advice_seq_no                := i.dsp_advice_seq_no;
        v_inw_claim_payts.v_check                        := 0;
        
        BEGIN
            SELECT a.peril_sname, a.peril_name
              INTO v_inw_claim_payts.dsp_peril_sname, v_inw_claim_payts.dsp_peril_name
              FROM giis_peril a, gicl_clm_loss_exp b
             WHERE a.peril_cd = b.peril_cd
               AND b.claim_id = i.claim_id
               AND b.clm_loss_id = i.clm_loss_id
               AND b.advice_id = i.advice_id
               AND a.line_cd = i.dsp_line_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
        
        GIAC_INW_CLAIM_PAYTS_PKG.get_claim_policy_and_assured(i.claim_id, v_inw_claim_payts.dsp_claim_no, 
                                                                          v_inw_claim_payts.dsp_policy_no,
                                                                          v_inw_claim_payts.dsp_assured_name,
                                                                          v_dummy);
        
        PIPE ROW(v_inw_claim_payts);
    END LOOP;
  END;
  
  /*
    **  Created by   :  Emman
    **  Date Created :  10.28.2010
    **  Reference By : (GIACS018 - Facul Claim Payts)
    **  Description  :  Save (Insert/Update) GIAC Inw Claim Payts record
    */ 
  PROCEDURE set_giac_inw_claim_payts (p_gacc_tran_id        GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
                                          p_claim_id                GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                     p_clm_loss_id            GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE,
                                     p_transaction_type        GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                     p_advice_id            GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
                                     p_payee_cd                GIAC_INW_CLAIM_PAYTS.payee_cd%TYPE,
                                     p_payee_class_cd        GIAC_INW_CLAIM_PAYTS.payee_class_cd%TYPE,
                                     p_payee_type            GIAC_INW_CLAIM_PAYTS.payee_type%TYPE,
                                     p_disbursement_amt        GIAC_INW_CLAIM_PAYTS.disbursement_amt%TYPE,
                                     p_currency_cd            GIAC_INW_CLAIM_PAYTS.currency_cd%TYPE,
                                     p_convert_rate            GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE,
                                     p_foreign_curr_amt        GIAC_INW_CLAIM_PAYTS.foreign_curr_amt%TYPE,
                                     p_or_print_tag            GIAC_INW_CLAIM_PAYTS.or_print_tag%TYPE,
                                     p_last_update            GIAC_INW_CLAIM_PAYTS.last_update%TYPE,
                                     p_user_id                GIAC_INW_CLAIM_PAYTS.user_id%TYPE,
                                     p_remarks                GIAC_INW_CLAIM_PAYTS.remarks%TYPE,
                                     p_input_vat_amt        GIAC_INW_CLAIM_PAYTS.input_vat_amt%TYPE,
                                     p_wholding_tax_amt        GIAC_INW_CLAIM_PAYTS.wholding_tax_amt%TYPE,
                                     p_net_disb_amt            GIAC_INW_CLAIM_PAYTS.net_disb_amt%TYPE)
  IS
  BEGIN
         MERGE INTO GIAC_INW_CLAIM_PAYTS
       USING DUAL ON (gacc_tran_id = p_gacc_tran_id
                      AND claim_id       = p_claim_id
                  AND clm_loss_id  = p_clm_loss_id)
       WHEN NOT MATCHED THEN
               INSERT (gacc_tran_id, claim_id, clm_loss_id, transaction_type, advice_id, payee_cd,
                    payee_class_cd, payee_type, disbursement_amt, currency_cd, convert_rate, foreign_curr_amt,
                    or_print_tag, last_update, user_id, remarks, input_vat_amt, wholding_tax_amt, net_disb_amt)
            VALUES (p_gacc_tran_id, p_claim_id, p_clm_loss_id, p_transaction_type, p_advice_id, p_payee_cd,
                    p_payee_class_cd, p_payee_type, p_disbursement_amt, p_currency_cd, p_convert_rate, p_foreign_curr_amt,
                    p_or_print_tag, p_last_update, p_user_id, p_remarks, p_input_vat_amt, p_wholding_tax_amt, p_net_disb_amt)
       WHEN MATCHED THEN
           UPDATE SET transaction_type        = p_transaction_type,
                      advice_id            = p_advice_id,
                   payee_cd                = p_payee_cd,
                   payee_class_cd        = p_payee_class_cd,
                   payee_type            = p_payee_type,
                   disbursement_amt         = p_disbursement_amt,
                   currency_cd            = p_currency_cd,
                   convert_rate            = p_convert_rate,
                   foreign_curr_amt        = p_foreign_curr_amt,
                   or_print_tag            = p_or_print_tag,
                   last_update            = p_last_update,
                   user_id                = p_user_id,
                   remarks                = p_remarks,
                   input_vat_amt        = p_input_vat_amt,
                   wholding_tax_amt        = p_wholding_tax_amt,
                   net_disb_amt            = p_net_disb_amt;
  END set_giac_inw_claim_payts;
  
  /*
    **  Created by   :  Emman
    **  Date Created :  10.28.2010
    **  Reference By : (GIACS018 - Facul Claim Payts)
    **  Description  : Deletes GIAC Inw Claim Payts record
    */
  PROCEDURE del_giac_inw_claim_payts (p_gacc_tran_id        GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
                                           p_claim_id            GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                      p_clm_loss_id            GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE)
  IS
  BEGIN
         DELETE
           FROM GIAC_INW_CLAIM_PAYTS
          WHERE gacc_tran_id = p_gacc_tran_id
            AND claim_id     = p_claim_id
            AND clm_loss_id     = p_clm_loss_id;
  END del_giac_inw_claim_payts;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.27.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Gets list of advice_year
  */
  FUNCTION get_advice_year_listing (p_tran_type            GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                         p_line_cd            GICL_ADVICE.line_cd%TYPE,
                                    p_iss_cd            GICL_ADVICE.iss_cd%TYPE,
                                    p_module_name        GIAC_MODULES.module_name%TYPE,
                                    p_user_id           giis_users.user_id%TYPE)
    RETURN advice_year_tab PIPELINED
  IS
      v_advice_year           advice_year_type;
  BEGIN
      IF p_tran_type = 1 THEN
          FOR i IN (SELECT DISTINCT (advice_year) 
                    FROM gicl_advice 
                   WHERE advice_flag = 'Y' 
                     AND iss_cd = p_iss_cd 
                     AND line_cd = nvl(p_line_cd,line_cd) 
                     AND iss_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(NULL,iss_cd, p_module_name, p_user_id),1,iss_cd,NULL))
        LOOP
            v_advice_year.advice_year        := i.advice_year;
            
            PIPE ROW(v_advice_year);
        END LOOP;
    ELSE
        FOR i IN (SELECT DISTINCT (a.advice_year) 
                    FROM gicl_advice a, gicl_clm_loss_exp b 
                   WHERE a.claim_id = b.claim_id 
                     AND a.advice_id = b.advice_id 
                        AND b.tran_id IS NOT NULL
                        AND NOT EXISTS (SELECT x.gacc_tran_id 
                                                FROM giac_reversals x, giac_acctrans y 
                                      WHERE x.reversing_tran_id = y.tran_id 
                                        AND y.tran_flag <> 'D' 
                                          AND x.gacc_tran_id = b.tran_id) 
                     AND a.iss_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(NULL,a.iss_cd,p_module_name, p_user_id),1,a.iss_cd,NULL)  
                        AND a.iss_cd = p_iss_cd 
                        AND a.line_cd = nvl(p_line_cd,a.line_cd))
        LOOP
            v_advice_year.advice_year        := i.advice_year;
            
            PIPE ROW(v_advice_year);
        END LOOP;
    END IF;
  END get_advice_year_listing;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.27.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Gets list of advice_seq_no
  */
  FUNCTION get_advice_seq_no_listing (p_tran_type        GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                           p_line_cd            GICL_ADVICE.line_cd%TYPE,
                                      p_iss_cd            GICL_ADVICE.iss_cd%TYPE,
                                      p_advice_year        GICL_ADVICE.advice_year%TYPE,
                                      p_module_name        GIAC_MODULES.module_name%TYPE,
                                      p_user_id         giis_users.user_id%TYPE)
    RETURN advice_seq_no_tab PIPELINED
  IS
      v_advice_seq_no           advice_seq_no_type;
  BEGIN
      IF p_tran_type = 1 THEN
          FOR i IN (SELECT advice_seq_no, claim_id, advice_id
                    FROM gicl_advice 
                   WHERE advice_flag = 'Y' 
                     AND nvl(apprvd_tag,'N') = 'N' 
                        AND line_cd = nvl(p_line_cd, line_cd)
                        AND iss_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(NULL,iss_cd,p_module_name, p_user_id),1,iss_cd,NULL) 
                        AND iss_cd = p_iss_cd 
                        AND advice_year = nvl(p_advice_year, advice_year) 
                ORDER BY line_cd, iss_cd, advice_year, advice_seq_no)
        LOOP
            v_advice_seq_no.advice_seq_no        := i.advice_seq_no;
            v_advice_seq_no.claim_id            := i.claim_id;
            v_advice_seq_no.advice_id            := i.advice_id;
            
            PIPE ROW(v_advice_seq_no);
        END LOOP;
    ELSE
        FOR i IN (SELECT a.advice_seq_no, a.claim_id, a.advice_id
                    FROM gicl_advice a, gicl_clm_loss_exp b 
                   WHERE a.claim_id = b.claim_id 
                        AND a.advice_id = b.advice_id 
                     AND b.tran_id IS NOT NULL
                     AND NOT EXISTS (SELECT x.gacc_tran_id 
                                                FROM giac_reversals x, giac_acctrans y 
                                      WHERE x.reversing_tran_id = y.tran_id 
                                        AND y.tran_flag <> 'D' 
                                        AND x.gacc_tran_id = b.tran_id) 
                     AND a.line_cd = nvl(p_line_cd, a.line_cd) 
                        AND a.iss_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(p_line_cd,a.iss_cd,p_module_name, p_user_id),1,a.iss_cd,NULL) 
                        AND a.iss_cd = p_iss_cd 
                        AND a.advice_year = nvl(p_advice_year, a.advice_year) 
                ORDER BY a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no)
        LOOP
            v_advice_seq_no.advice_seq_no        := i.advice_seq_no;
            v_advice_seq_no.claim_id            := i.claim_id;
            v_advice_seq_no.advice_id            := i.advice_id;
            
            PIPE ROW(v_advice_seq_no);
        END LOOP;
    END IF;
  END get_advice_seq_no_listing;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.27.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Gets the claim no, policy no, and assured name based on specified claim id
  */
  PROCEDURE get_claim_policy_and_assured (p_claim_id       IN  GICL_CLAIMS.claim_id%TYPE,
                                            p_claim_no       OUT VARCHAR2,
                                          p_policy_no       OUT VARCHAR2,
                                          p_assured_name   OUT GICL_CLAIMS.assured_name%TYPE,
                                          p_message           OUT VARCHAR2)
  IS
  BEGIN
         p_message := 'SUCCESS';
       
         SELECT B.LINE_CD||'-'||B.SUBLINE_CD||'-'||B.POL_ISS_CD||'-'||TO_CHAR(B.ISSUE_YY,'09')||'-'||TO_CHAR(B.POL_SEQ_NO,'0999999')||'-'||TO_CHAR(B.RENEW_NO,'09') dsp_policy_no,
                B.LINE_CD||'-'||B.SUBLINE_CD||'-'||B.ISS_CD||'-'||TO_CHAR(B.CLM_YY,'09')||'-'||TO_CHAR(B.CLM_SEQ_NO,'0999999') dsp_claim_no,
               B.ASSURED_NAME
          INTO p_policy_no,
               p_claim_no,
               p_assured_name
          FROM GICL_CLAIMS B
         WHERE B.CLAIM_ID = p_claim_id;
  EXCEPTION
         WHEN NO_DATA_FOUND THEN
               p_message := 'No existing record for claim id '||to_char(p_claim_id)||'.';
  END get_claim_policy_and_assured;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.27.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Gets list of records for CLM_LOSS_ID_LOV
  */
  FUNCTION get_clm_loss_id_lov_listing (p_tran_type        GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                             p_line_cd        GICL_ADVICE.line_cd%TYPE,
                                        p_claim_id        GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                        p_advice_id        GIAC_INW_CLAIM_PAYTS.advice_id%TYPE)
    RETURN clm_loss_id_lov_tab PIPELINED
  IS
      v_clm_loss_id               clm_loss_id_lov_type;
  BEGIN
      IF p_tran_type = 1 THEN
        FOR i IN (SELECT a.clm_loss_id, a.payee_type, decode(a.payee_type,'L','Loss','E','Expense') dsp_payee_desc,
                            a.payee_class_cd, a.payee_cd, 
                         decode(b.payee_first_name, NULL, b.payee_last_name, b.payee_last_name||','||b.payee_first_name||' '||b.payee_middle_name) dsp_payee_name,
                         a.peril_cd, c.peril_name dsp_peril_name, c.peril_sname dsp_peril_sname,
                         (a.net_amt * nvl(d.convert_rate,1)) net_amt,
                         a.paid_amt, a.advise_amt
                    FROM gicl_clm_loss_exp a, giis_payees b, giis_peril c, gicl_advice d
                   WHERE a.payee_cd = b.payee_no 
                     AND a.payee_class_cd = b.payee_class_cd 
                        AND a.claim_id = d.claim_id 
                        AND a.advice_id = d.advice_id 
                        AND c.line_cd = p_line_cd 
                        AND a.peril_cd = c.peril_cd
                        AND a.claim_id = p_claim_id 
                        AND a.advice_id = p_advice_id 
                        AND a.advice_id IS NOT NULL
                        AND a.tran_id IS NULL)
        LOOP
            v_clm_loss_id.clm_loss_id                                := i.clm_loss_id;
            v_clm_loss_id.payee_type                         := i.payee_type;
            v_clm_loss_id.dsp_payee_desc                     := i.dsp_payee_desc;
            v_clm_loss_id.payee_class_cd                     := i.payee_class_cd;
            v_clm_loss_id.payee_cd                             := i.payee_cd;
            v_clm_loss_id.dsp_payee_name                     := i.dsp_payee_name;
            v_clm_loss_id.peril_cd                             := i.peril_cd;
            v_clm_loss_id.dsp_peril_name                     := i.dsp_peril_name;
            v_clm_loss_id.dsp_peril_sname                     := i.dsp_peril_sname;
            v_clm_loss_id.net_amt                             := i.net_amt;
            v_clm_loss_id.paid_amt                             := i.paid_amt;
            v_clm_loss_id.advise_amt                         := i.advise_amt;
            
            PIPE ROW(v_clm_loss_id);
        END LOOP;
    ELSE
        FOR i IN (SELECT a.clm_loss_id, a.payee_type, decode(a.payee_type,'L','Loss','E','Expense') dsp_payee_desc,
                            a.payee_class_cd, a.payee_cd,
                         decode(b.payee_first_name, NULL, b.payee_last_name, b.payee_last_name||','||b.payee_first_name||' '||b.payee_middle_name) dsp_payee_name,
                         a.peril_cd, c.peril_sname dsp_peril_name, c.peril_sname dsp_peril_sname,
                         (a.net_amt * nvl(d.convert_rate,1) * -1) net_amt,
                         a.paid_amt, a.advise_amt 
                    FROM gicl_clm_loss_exp a, giis_payees b, giis_peril c, gicl_advice d
                   WHERE a.payee_cd = b.payee_no 
                     AND a.payee_class_cd = b.payee_class_cd 
                        AND a.claim_id = d.claim_id 
                        AND a.advice_id = d.advice_id 
                        AND c.line_cd = p_line_cd 
                        AND a.peril_cd = c.peril_cd 
                        AND a.claim_id = p_claim_id 
                        AND a.advice_id = p_advice_id 
                        AND a.advice_id IS NOT NULL)
        LOOP
            v_clm_loss_id.clm_loss_id                                := i.clm_loss_id;
            v_clm_loss_id.payee_type                         := i.payee_type;
            v_clm_loss_id.dsp_payee_desc                     := i.dsp_payee_desc;
            v_clm_loss_id.payee_class_cd                     := i.payee_class_cd;
            v_clm_loss_id.payee_cd                             := i.payee_cd;
            v_clm_loss_id.dsp_payee_name                     := i.dsp_payee_name;
            v_clm_loss_id.peril_cd                             := i.peril_cd;
            v_clm_loss_id.dsp_peril_name                     := i.dsp_peril_name;
            v_clm_loss_id.dsp_peril_sname                     := i.dsp_peril_sname;
            v_clm_loss_id.net_amt                             := i.net_amt;
            v_clm_loss_id.paid_amt                             := i.paid_amt;
            v_clm_loss_id.advise_amt                         := i.advise_amt;
            
            PIPE ROW(v_clm_loss_id);
        END LOOP;
    END IF;
  END get_clm_loss_id_lov_listing;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.28.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Executes the POST-TEXT-ITEM trigger of DSP_PAYEE_DESC
  */
  PROCEDURE validate_giacs018_payee(p_gacc_tran_id            IN     GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
                                      p_transaction_type        IN       GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                        p_claim_id                IN       GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                      p_clm_loss_id            IN       GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE,
                                      p_advice_id                IN       GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
                                      p_input_vat_amt            IN OUT GIAC_INW_CLAIM_PAYTS.input_vat_amt%TYPE,
                                      p_wholding_tax_amt        IN OUT GIAC_INW_CLAIM_PAYTS.wholding_tax_amt%TYPE,
                                      p_net_disb_amt            IN OUT GIAC_INW_CLAIM_PAYTS.net_disb_amt%TYPE,
                                      p_v_check                   OUT NUMBER)
  IS
      v_exist    varchar2(1) := null;
  BEGIN
    p_v_check := 0;
    
    BEGIN
       SELECT DISTINCT 'x' 
         INTO v_exist
         FROM giac_inw_claim_payts
        WHERE gacc_tran_id = p_gacc_tran_id
          AND claim_id = p_claim_id
          AND clm_loss_id = p_clm_loss_id
          AND advice_id = p_advice_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        /* benjo 02.29.2016 SR-5303 */
         BEGIN
           SELECT NVL (SUM (a.tax_amt * NVL (c.orig_curr_rate, c.convert_rate)), 0)
             INTO p_input_vat_amt
             FROM gicl_loss_exp_tax a, gicl_clm_loss_exp b, gicl_advice c
            WHERE a.claim_id = p_claim_id
              AND a.clm_loss_id = p_clm_loss_id
              AND a.claim_id = b.claim_id
              AND a.clm_loss_id = b.clm_loss_id
              AND b.claim_id = c.claim_id
              AND b.advice_id = c.advice_id
              AND a.tax_type = 'I';
         EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              p_input_vat_amt := 0;
         END;

         /* benjo 02.29.2016 SR-5303 */
         BEGIN
           SELECT NVL (SUM (a.tax_amt * NVL (c.orig_curr_rate, c.convert_rate)), 0)
             INTO p_wholding_tax_amt
             FROM gicl_loss_exp_tax a, gicl_clm_loss_exp b, gicl_advice c
            WHERE a.claim_id = p_claim_id
              AND a.clm_loss_id = p_clm_loss_id
              AND a.claim_id = b.claim_id
              AND a.clm_loss_id = b.clm_loss_id
              AND b.claim_id = c.claim_id
              AND b.advice_id = c.advice_id
              AND a.tax_type = 'W';
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             p_wholding_tax_amt := 0;
         END;

         /* benjo 02.29.2016 SR-5303 */
         BEGIN
           SELECT NVL(SUM(a.paid_amt * NVL (b.orig_curr_rate, b.convert_rate)), 0)
             INTO p_net_disb_amt
             FROM gicl_clm_loss_exp a, gicl_advice b
            WHERE a.claim_id = p_claim_id  
              AND a.advice_id = p_advice_id
              AND a.clm_loss_id = p_clm_loss_id
              AND a.claim_id = b.claim_id
              AND a.advice_id = b.advice_id;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             p_net_disb_amt := 0;
         END;

         IF p_transaction_type = 2 THEN
            p_input_vat_amt := p_input_vat_amt * -1;                              
            p_wholding_tax_amt := p_wholding_tax_amt * -1;
            p_net_disb_amt := p_net_disb_amt * -1;
         END IF;

         p_v_check := 1;
    END;
  END validate_giacs018_payee;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.29.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Executes the KEY-DEL-REC trigger of GICP block
  */
  PROCEDURE execute_giacs018_key_delrec(p_gacc_tran_id            GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
                                          p_transaction_type        GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                        p_claim_id                GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                        p_advice_id                GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
                                        p_var_gen_type            GIAC_MODULES.generation_type%TYPE)
  IS
        V_DISBMT        GIAC_INW_CLAIM_PAYTS.DISBURSEMENT_AMT%TYPE;
  BEGIN
      IF p_transaction_type = 1 THEN  
          UPDATE gicl_advice
             SET apprvd_tag = NULL
           WHERE claim_id = p_claim_id
             AND advice_id = p_advice_id;
      END IF;
    
      GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries(p_gacc_tran_id, p_var_gen_type);
    
      DELETE FROM giac_taxes_wheld
              WHERE gacc_tran_id = p_gacc_tran_id;
  END execute_giacs018_key_delrec;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.29.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Executes the PRE-INSERT trigger of GICP block
  */
  PROCEDURE execute_giacs018_pre_insert(p_payee_class_cd        IN     GIAC_INW_CLAIM_PAYTS.payee_class_cd%TYPE,
                                          p_payee_cd                IN       GIAC_INW_CLAIM_PAYTS.payee_cd%TYPE,
                                        p_transaction_type        IN       GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                        p_claim_id                IN       GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                        p_advice_id                IN       GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
                                        p_currency_cd            IN OUT GIAC_INW_CLAIM_PAYTS.currency_cd%TYPE,
                                        p_convert_rate            IN OUT GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE,
                                        p_foreign_curr_amt        IN OUT GIAC_INW_CLAIM_PAYTS.foreign_curr_amt%TYPE,
                                        p_message                   OUT VARCHAR2)
  IS
      v_exist           VARCHAR2(1) := 'N';
  BEGIN
    p_message := 'SUCCESS';
    
    FOR i IN (SELECT  1
                FROM  GIIS_PAYEES 
               WHERE  PAYEE_CLASS_CD = p_payee_class_cd
                 AND  PAYEE_NO = p_payee_cd)
    LOOP
        v_exist := 'Y';
        EXIT;
    END LOOP;
    
    IF v_exist = 'N' THEN
       p_message := 'Error: This Payee Class Cd,Payee Cd does not exist';
       RETURN;
    END IF;
    
    BEGIN
      SELECT currency_cd, convert_rate,
             DECODE(p_transaction_type,1,NVL(paid_amt,0) * convert_rate,
                                           2,NVL(paid_amt,0) * convert_rate * -1) foreign_curr_amt
        INTO p_currency_cd, p_convert_rate,
             p_foreign_curr_amt 
        FROM gicl_advice
       WHERE claim_id = p_claim_id
         AND advice_id = p_advice_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_message := 'No currency code and convert rate found in table.';
    END;   
  END execute_giacs018_pre_insert;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.29.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Executes the POST-INSERT trigger of GICP block
  */
  PROCEDURE execute_giacs018_post_insert(p_transaction_type        GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
                                         p_claim_id                GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
                                         p_advice_id            GIAC_INW_CLAIM_PAYTS.advice_id%TYPE)
  IS
  BEGIN
      IF p_transaction_type = 1 THEN
         UPDATE gicl_advice
            SET apprvd_tag = 'Y'
          WHERE claim_id = p_claim_id
            AND advice_id = p_advice_id;
      ELSIF p_transaction_type = 2 THEN
         UPDATE gicl_advice
            SET apprvd_tag = 'N'
          WHERE claim_id = p_claim_id
            AND advice_id = p_advice_id;        
      END IF; 
  END;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.29.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Executes the POST-FORMS-COMMIT trigger in GIACS018
  */
  PROCEDURE giacs018_post_forms_commit(p_gacc_tran_id            IN     GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
                                         p_gacc_branch_cd         IN       GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                                       p_gacc_fund_cd              IN       GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                                         p_tran_source            IN       VARCHAR2,
                                       p_or_flag                IN       VARCHAR2,
                                       p_var_module_name        IN OUT GIAC_MODULES.module_name%TYPE,
                                       p_var_gen_type            IN OUT GIAC_MODULES.generation_type%TYPE,
                                       p_message                   OUT VARCHAR2)
  IS
      var_v_item_no GIAC_MODULE_ENTRIES.item_no%TYPE := 1;
  BEGIN
      p_message := 'SUCCESS';
      IF p_tran_source = 'OP' THEN
        IF p_or_flag = 'P' THEN
           NULL;
        ELSE
           GIAC_OP_TEXT_PKG.update_giac_op_text_giacs018(p_gacc_tran_id, p_var_module_name);
        END IF;
      END IF;
    
      /* Creation of accounting entries...*/
      BEGIN
        GIAC_ACCT_ENTRIES_PKG.aeg_ins_updt_acct_ent_giacs018(p_gacc_tran_id, p_gacc_branch_cd,
                                                              p_gacc_fund_cd, p_var_module_name,
                                                              p_var_gen_type, p_message);
    
        DELETE FROM giac_taxes_wheld
              WHERE gacc_tran_id = p_gacc_tran_id;
       
        var_v_item_no := 1;
    
        FOR c IN (SELECT a.claim_id, a.advice_id, a.convert_rate,
                         a.payee_class_cd, a.payee_cd, d.iss_cd dsp_iss_cd,
                         a.transaction_type                                 --benjo 02.29.2016 SR-5303
                    FROM giac_inw_claim_payts a, gicl_advice d
                   WHERE gacc_tran_id = p_gacc_tran_id
                     AND d.claim_id = a.claim_id
                      AND d.advice_id = a.advice_id)
        LOOP
          GIAC_INW_CLAIM_PAYTS_PKG.insert_into_giac_taxes_wheld(c.claim_id, c.advice_id,
                                       c.payee_class_cd, c.payee_cd,
                                       p_gacc_tran_id, c.dsp_iss_cd,
                                       c.convert_rate, c.transaction_type, p_var_module_name, --benjo 02.29.2016 SR-5303
                                       var_v_item_no, p_message);
        END LOOP;  
      END;
  END giacs018_post_forms_commit;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.29.2010
  **  Reference By : (GIACS018 - Facultative Claim Payts)
  **  Description  : Executes the Procedure INSERT_INTO_GIAC_TAXES_WHELD on GIACS018
  */
  PROCEDURE insert_into_giac_taxes_wheld
           (p_claim_id          IN     giac_inw_claim_payts.claim_id%TYPE,
            p_advice_id         IN       giac_inw_claim_payts.advice_id%TYPE,     
            p_payee_class_cd    IN       giac_taxes_wheld.payee_class_cd%TYPE, 
            p_payee_cd          IN       giac_taxes_wheld.payee_cd%TYPE,
            p_gacc_tran_id        IN       GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
            p_dsp_iss_cd        IN       GICL_ADVICE.iss_cd%TYPE,
            p_convert_rate        IN       GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE,
            p_transaction_type	 IN	    GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE, --benjo 02.29.2016 SR-5303
            p_var_module_name    IN OUT GIAC_MODULES.module_name%TYPE,
            p_var_item_no        IN OUT NUMBER,
            p_message               OUT VARCHAR2)
  IS
      gen_type    varchar2(1);
      v_whtax    giac_taxes_wheld.gwtx_whtax_id%type;
      v_tax_amt     giac_taxes_wheld.wholding_tax_amt%type default 0;
      total_whtax   number(16,2) default 0;
      income_amt    number(16,2) default 0;
      v_multiplier  number := 1; --benjo 02.29.2016 SR-5303
    
      CURSOR cur_whtax IS
        SELECT DISTINCT b.tax_cd whtax
          FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
         WHERE a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.payee_cd = p_payee_cd
           AND a.payee_class_cd = p_payee_class_cd
           AND a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id
           AND b.tax_type = 'W';
    
      /* benjo 02.29.2016 SR-5303 */
      CURSOR t_amt IS
        SELECT b.tax_cd whtax, sum(nvl(b.tax_amt,0)) tax_amount,
               nvl(sum(b.base_amt),a.net_amt) base_amt,
               b.sl_cd, b.sl_type_cd
          FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
         WHERE a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.payee_cd = p_payee_cd
           AND a.payee_class_cd = p_payee_class_cd
           AND a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id
           AND b.tax_type = 'W'
           AND b.tax_cd  = v_whtax
      GROUP BY tax_cd, a.net_amt, b.sl_cd, b.sl_type_cd;
    
    BEGIN
        p_message := 'SUCCESS';
        
        IF p_dsp_iss_cd = 'RI' THEN          
           p_var_module_name := 'GIACS018';
        ELSE
           p_var_module_name := 'GIACS017';
        END IF;
        BEGIN
          SELECT generation_type
            INTO gen_type
            FROM giac_modules
           WHERE module_name = p_var_module_name; 
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ROLLBACK;             
            p_message := 'Insertion not completed. Generation type does not exist!';
            RETURN;
        END;
    
        /* benjo 02.29.2016 SR-5303 */
        IF NVL(p_transaction_type, 1) = 2 THEN
            v_multiplier := -1;
        ELSE
            v_multiplier := 1;
        END IF;
     
        FOR whtax IN cur_whtax LOOP
          v_whtax := whtax.whtax; 
    
          FOR al IN t_amt LOOP
            /* benjo 02.29.2016 SR-5303 */
            --total_whtax := total_whtax + al.tax_amount;
            --income_amt := income_amt + al.base_amt;
            total_whtax := al.tax_amount * v_multiplier;
            income_amt := al.base_amt * v_multiplier;
     
            INSERT INTO giac_taxes_wheld
                       (gacc_tran_id, gen_type,         payee_class_cd, 
                        item_no,      payee_cd,         gwtx_whtax_id, 
                        income_amt,   wholding_tax_amt, user_id,        last_update,
                        sl_cd,        sl_type_cd,       claim_id,       advice_id) --benjo 02.29.2016 SR-5303
                 VALUES(p_gacc_tran_id, gen_type,   p_payee_class_cd, 
                        p_var_item_no,  p_payee_cd, v_whtax , 
                        (income_amt * nvl(p_convert_rate,1)), 
                        (total_whtax * nvl(p_convert_rate,1)), 
                        nvl(giis_users_pkg.app_user, USER), SYSDATE,
                        al.sl_cd, al.sl_type_cd, p_claim_id, p_advice_id); --benjo 02.29.2016 SR-5303
            p_var_item_no := p_var_item_no + 1;
          END LOOP;
        END LOOP;
  END insert_into_giac_taxes_wheld;

END GIAC_INW_CLAIM_PAYTS_PKG;
/


