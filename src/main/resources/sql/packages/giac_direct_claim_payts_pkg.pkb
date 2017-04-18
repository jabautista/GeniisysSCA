CREATE OR REPLACE PACKAGE BODY CPI.giac_direct_claim_payts_pkg AS
   
/****************************************************************
 * PACKAGE NAME : GIAC_DIRECT_CLAIM_PAYTS_PKG
 * MODULE NAME  : GIACS017
 * CREATED BY   : RENCELA
 * DATE CREATED : 2010-09-16
 * MODIFICATIONS-------------------------------------------------
 * MODIFIED BY  | DATE      | REMARKS 
 * RENCELA        20100916    MODULE CREATED 
 * RENCELA          20101006      ADDED ADVICE_SEQ TYPE AND GETTERS
*****************************************************************/
   FUNCTION get_clm_loss_id(
            p_line_cd        GIIS_PERIL.line_cd%TYPE,
            p_advice_id        VARCHAR2,
            p_claim_id        VARCHAR2,
            p_tran_type      VARCHAR2
            --p_advice_id        GICL_CLM_LOSS_EXP.advice_id%TYPE,
            --p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE
   )RETURN clm_loss_id_tab PIPELINED IS
             v_clm_loss_id                   clm_loss_id_type;
   BEGIN
       IF p_tran_type = '1' THEN
        FOR i IN (
              SELECT a.clm_loss_id,                  a.payee_type, 
                    decode(a.payee_type,'L','Loss','E','Expense') p_type, 
                    a.payee_class_cd,             a.payee_cd, 
                     decode(b.payee_first_name, NULL, b.payee_last_name, b.payee_last_name||','||b.payee_first_name||' '||b.payee_middle_name) payee, 
                     a.peril_cd,                 c.peril_sname, 
                    (a.net_amt * nvl(d.convert_rate,1)) net_amt, 
                    a.paid_amt,                 a.advise_amt
              FROM gicl_clm_loss_exp a, giis_payees b, giis_peril c, gicl_advice d 
             WHERE a.payee_cd = b.payee_no 
               AND a.payee_class_cd = b.payee_class_cd 
               AND a.claim_id = d.claim_id 
               AND a.advice_id = d.advice_id 
    --           AND c.line_cd like '%' || p_line_cd || '%'
               AND c.line_cd = p_line_cd 
               AND a.peril_cd = c.peril_cd
    --           AND a.claim_id like '%' || TO_NUMBER(p_claim_id)  || '%'
    --           AND a.advice_id like '%' || TO_NUMBER(p_advice_id)  || '%'
               AND a.claim_id = TO_NUMBER(p_claim_id) 
               AND a.advice_id = TO_NUMBER(p_advice_id) 
               AND a.advice_id IS NOT NULL 
               AND a.tran_id IS NULL) 
         LOOP
            v_clm_loss_id.claim_loss_id       := i.clm_loss_id;
            v_clm_loss_id.payee_type       := i.payee_type;
            v_clm_loss_id.payee_type_desc  := i.p_type;
            v_clm_loss_id.payee_class_cd   := i.payee_class_cd;
            v_clm_loss_id.payee_cd           := i.payee_cd;
            v_clm_loss_id.payee               := i.payee;
            v_clm_loss_id.peril_cd           := i.peril_cd;
            v_clm_loss_id.peril_sname       := i.peril_sname;
            v_clm_loss_id.net_amt           := i.net_amt;
            v_clm_loss_id.paid_amt           := i.paid_amt;
            v_clm_loss_id.advice_amt       := i.advise_amt;
            
            PIPE ROW(v_clm_loss_id);
         END LOOP;
       ELSIF p_tran_type = '2' THEN
        FOR i IN (
              SELECT a.clm_loss_id, 
                     a.payee_type, decode(a.payee_type,'L','Loss','E','Expense') p_type, 
                    a.payee_class_cd, 
                    a.payee_cd, 
                     decode(b.payee_first_name, NULL, b.payee_last_name, b.payee_last_name||','||b.payee_first_name||' '||b.payee_middle_name) payee, 
                    a.peril_cd, c.peril_sname, (a.net_amt * nvl(d.convert_rate,1) * -1) net_amt, 
                    (a.paid_amt) paid_amt, (a.advise_amt) advise_amt 
               FROM gicl_clm_loss_exp a, giis_payees b, giis_peril c, gicl_advice d 
              WHERE a.payee_cd = b.payee_no 
                AND a.payee_class_cd = b.payee_class_cd 
                AND a.claim_id = d.claim_id 
                AND a.advice_id = d.advice_id 
                AND c.line_cd = p_line_cd 
                AND a.peril_cd = c.peril_cd 
                AND a.claim_id = TO_NUMBER(p_claim_id) 
                AND a.advice_id = TO_NUMBER(p_advice_id)
                AND a.advice_id IS NOT NULL) 
         LOOP
            v_clm_loss_id.claim_loss_id       := i.clm_loss_id;
            v_clm_loss_id.payee_type       := i.payee_type;
            v_clm_loss_id.payee_type_desc  := i.p_type;
            v_clm_loss_id.payee_class_cd   := i.payee_class_cd;
            v_clm_loss_id.payee_cd           := i.payee_cd;
            v_clm_loss_id.payee               := i.payee;
            v_clm_loss_id.peril_cd           := i.peril_cd;
            v_clm_loss_id.peril_sname       := i.peril_sname;
            v_clm_loss_id.net_amt           := i.net_amt;
            v_clm_loss_id.paid_amt           := i.paid_amt;
            v_clm_loss_id.advice_amt       := i.advise_amt;
            
            PIPE ROW(v_clm_loss_id);
         END LOOP;
       END IF;
  END get_clm_loss_id;       


  FUNCTION get_advice_isscd(
        p_module           VARCHAR2
  )RETURN advice_iss_cd_tab PIPELINED IS
    ad      advice_iss_cd_type;
  BEGIN
      FOR i IN(
        SELECT DISTINCT a.iss_cd, b.iss_name 
                        FROM gicl_advice a, giis_issource b 
                  WHERE b.iss_cd = a.iss_cd 
                     AND a.advice_flag = 'Y' 
                        --AND a.iss_cd != p_iss_cd
                        AND check_user_per_iss_cd_acctg(NULL,a.iss_cd,p_module)=1
    )LOOP
       ad.iss_cd     :=     i.iss_cd;
       ad.iss_name     :=  i.iss_name;
       PIPE ROW(ad);
    END LOOP;   
  END get_advice_isscd;
  
  
  FUNCTION get_advice_isscd2(
       p_module           VARCHAR2
  )RETURN advice_iss_cd_tab PIPELINED IS
    ad      advice_iss_cd_type;
  BEGIN
      FOR i IN(
        SELECT DISTINCT a.iss_cd, c.iss_name 
                     FROM gicl_advice a, gicl_clm_loss_exp b, giis_issource c 
                  WHERE a.claim_id = b.claim_id 
                    AND a.advice_id = b.advice_id 
                       AND a.iss_cd = c.iss_cd 
                       AND b.tran_id IS NOT NULL 
                    --AND a.iss_cd != p_iss_cd
                       AND check_user_per_iss_cd_acctg(NULL,a.iss_cd,p_module)=1
    )LOOP
       ad.iss_cd     :=     i.iss_cd;
       ad.iss_name     :=  i.iss_name;
       PIPE ROW(ad);
    END LOOP;   
  END get_advice_isscd2;
  
   FUNCTION get_advice_seq(
           p_module           VARCHAR2,    
           p_line_cd           GIIS_PERIL.line_cd%TYPE,
        p_iss_cd           GIIS_ISSOURCE.iss_cd%TYPE,
        p_advice_year       VARCHAR2  
   ) RETURN advice_seq_tab PIPELINED IS
        v_adv_type               advice_seq_type;
   BEGIN
           FOR i IN (    SELECT advice_seq_no, 
                                 line_cd||'-'||iss_cd||'-'||ltrim(to_char(advice_year,'0999'))||'-'||ltrim(to_char(advice_seq_no,'099999')) advice_no, 
                              line_cd,   iss_cd,   advice_year,   advice_id,   claim_id
                      FROM gicl_advice 
                     WHERE advice_flag = 'Y' 
                       AND nvl(apprvd_tag,'N') = 'N' 
                       AND line_cd = nvl(p_line_cd, line_cd)
                       AND iss_cd = DECODE(check_user_per_iss_cd_acctg(NULL,iss_cd,p_module),1,iss_cd,NULL)
                       AND iss_cd = p_iss_cd 
                       AND advice_year = nvl(TO_NUMBER(p_advice_year), advice_year)
                     ORDER BY line_cd, iss_cd, advice_year, advice_seq_no)
        LOOP
            v_adv_type.advice_seq_no    := i.advice_seq_no;
            v_adv_type.advice_no        := i.advice_no;
            v_adv_type.line_cd            := i.line_cd;
            v_adv_type.iss_cd            := i.iss_cd;
            v_adv_type.advice_year        := i.advice_year;
            v_adv_type.advice_id        := i.advice_id;
            v_adv_type.claim_id            := i.claim_id;
            /*v_adv_type.convert_rate        := i.convert_rate;
            v_adv_type.cpi_branch_cd    := i.cpi_branch_cd;
            v_adv_type.cpi_rec_no        := i.cpi_rec_no;*/
            PIPE ROW(v_adv_type);
        END LOOP;        
   END get_advice_seq;     
 
   FUNCTION get_advice_seq2(
           p_module           VARCHAR2,    
           p_line_cd           GIIS_PERIL.line_cd%TYPE,
        p_iss_cd           GIIS_ISSOURCE.iss_cd%TYPE,
        p_advice_year       VARCHAR2       
   ) RETURN advice_seq_tab PIPELINED IS
        v_adv_type               advice_seq_type;
   BEGIN
           FOR i IN (    SELECT a.advice_seq_no, 
                              a.line_cd||'-'||a.iss_cd||'-'||ltrim(to_char(a.advice_year,'0999'))||'-'|| ltrim(to_char(a.advice_seq_no,'099999')) advice_no, 
                           a.line_cd, a.iss_cd, a.advice_year, a.advice_id, a.claim_id 
                      FROM gicl_advice a, gicl_clm_loss_exp b 
                     WHERE a.claim_id = b.claim_id 
                       AND a.advice_id = b.advice_id 
                       AND NOT EXISTS (     SELECT x.gacc_tran_id 
                                                    FROM giac_reversals x, giac_acctrans y 
                                         WHERE x.reversing_tran_id = y.tran_id 
                                                    AND y.tran_flag <> 'D' 
                                         AND x.gacc_tran_id = b.tran_id) 
                       AND a.line_cd = nvl(p_line_cd, a.line_cd) 
                       AND a.iss_cd = DECODE(check_user_per_iss_cd_acctg(NULL,a.iss_cd,p_module),1,a.iss_cd,NULL) 
                       AND a.iss_cd = p_iss_cd 
                       AND a.advice_year = nvl(TO_NUMBER(p_advice_year), a.advice_year) 
                     ORDER BY a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no)
        LOOP
            v_adv_type.advice_seq_no    := i.advice_seq_no;
            v_adv_type.advice_no        := i.advice_no;
            v_adv_type.line_cd            := i.line_cd;
            v_adv_type.iss_cd            := i.iss_cd;
            v_adv_type.advice_year        := i.advice_year;
            v_adv_type.advice_id        := i.advice_id;
            v_adv_type.claim_id            := i.claim_id;
            PIPE ROW (v_adv_type);
        END LOOP;
   END get_advice_seq2;
   
   FUNCTION get_advice_sequence_listing(
           p_module           VARCHAR2,
        p_keyword           VARCHAR2
   ) RETURN advice_seq_tab PIPELINED IS
        v_adv_type               advice_seq_type;
   BEGIN
     FOR i IN (    SELECT a.advice_seq_no, 
                          a.line_cd||'-'||a.iss_cd||'-'||ltrim(to_char(a.advice_year,'0999'))||'-'|| ltrim(to_char(a.advice_seq_no,'099999')) advice_no, 
                       a.line_cd, a.iss_cd, a.advice_year, a.advice_id, a.claim_id, a.convert_rate, a.cpi_branch_cd, a.cpi_rec_no, a.currency_cd, c.currency_desc 
                      FROM gicl_advice a, gicl_clm_loss_exp b, giis_currency c 
                     WHERE a.claim_id = b.claim_id 
                       AND a.currency_cd = c.main_currency_cd       
                       AND a.advice_id = b.advice_id 
                       AND NOT EXISTS (     SELECT x.gacc_tran_id 
                                                      FROM giac_reversals x, giac_acctrans y 
                                          WHERE x.reversing_tran_id = y.tran_id 
                                                       AND y.tran_flag <> 'D' 
                                            AND x.gacc_tran_id = b.tran_id) 
                       AND a.iss_cd = DECODE(check_user_per_iss_cd_acctg(NULL,a.iss_cd,p_module),1,a.iss_cd,NULL) 
                       AND (     UPPER(a.line_cd) LIKE UPPER ('%' || p_keyword || '%')
                                 OR UPPER(a.iss_cd)  LIKE UPPER ('%' || p_keyword || '%') 
                                 OR UPPER(a.advice_year) LIKE UPPER ('%' || p_keyword  || '%')) 
                     ORDER BY a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no)
        LOOP
            v_adv_type.advice_seq_no    := i.advice_seq_no;
            v_adv_type.advice_no        := i.advice_no;
            v_adv_type.line_cd            := i.line_cd;
            v_adv_type.iss_cd            := i.iss_cd;
            v_adv_type.advice_year        := i.advice_year;
            v_adv_type.advice_id        := i.advice_id;
            v_adv_type.claim_id            := i.claim_id;
            v_adv_type.convert_rate        := i.convert_rate;
            v_adv_type.cpi_branch_cd    := i.cpi_branch_cd;
            v_adv_type.cpi_rec_no        := i.cpi_rec_no;
            v_adv_type.currency_cd        := i.currency_cd;
            v_adv_type.currency_desc    := i.currency_desc;
            PIPE ROW (v_adv_type);
        END LOOP;
   END get_advice_sequence_listing;   
   
   PROCEDURE compute_advice_default_amount(
           p_v_check            IN OUT NUMBER,
        p_trans_type        IN NUMBER,
        p_gioc_gacc_tran_id IN GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_claim_id            IN GIAC_DIRECT_CLAIM_PAYTS.claim_id%TYPE,
        p_clm_loss_id        IN GIAC_DIRECT_CLAIM_PAYTS.clm_loss_id%TYPE,
        p_advice_id            IN GIAC_DIRECT_CLAIM_PAYTS.advice_id%TYPE,
        p_input_vat_amt        OUT GIAC_DIRECT_CLAIM_PAYTS.input_vat_amt%TYPE,
        p_wholding_tax_amt  OUT GICL_LOSS_EXP_TAX.tax_amt%TYPE,
        p_net_disb_amt        OUT GICL_CLM_LOSS_EXP.paid_amt%TYPE
    ) IS
        v_exist    VARCHAR2(1) := null;
    BEGIN
      IF p_v_check = 0 then
         /*BEGIN           
           SELECT DISTINCT 'x' 
             INTO v_exist
             FROM giac_direct_claim_payts
            WHERE gacc_tran_id = p_gioc_gacc_tran_id
              AND claim_id = p_claim_id
              AND clm_loss_id = p_clm_loss_id
              AND advice_id = p_advice_id;
              
         EXCEPTION
           WHEN NO_DATA_FOUND THEN*/
    
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
               WHEN NO_DATA_FOUND THEN
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
    
             BEGIN
               SELECT sum(NVL(paid_amt,0) * NVL(currency_rate, 1))--added conversion to pesos reymon 04242013
                 INTO p_net_disb_amt    --:gdcp.dsp_net_amt
                 FROM gicl_clm_loss_exp
                WHERE claim_id = p_claim_id  
                  AND advice_id = p_advice_id
                  AND clm_loss_id = p_clm_loss_id;
                  
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 p_net_disb_amt := 0;   --:gdcp.dsp_net_amt := 0;
             END;
    
             IF p_trans_type = 2 
             THEN
                p_input_vat_amt    := p_input_vat_amt * -1;                              
                p_wholding_tax_amt := p_wholding_tax_amt * -1;
                p_net_disb_amt        := p_net_disb_amt * -1;
                
             END IF;
             p_v_check := 1;
--         END;
         NULL;
      END IF;
    END compute_advice_default_amount;
   
   PROCEDURE save_direct_claim_payt(
        p_advice_id         IN giac_direct_claim_payts.advice_id%TYPE,
        p_claim_id          IN giac_direct_claim_payts.claim_id%TYPE,
        p_clm_loss_id       IN giac_direct_claim_payts.clm_loss_id%TYPE,             
        p_convert_rate      IN giac_direct_claim_payts.convert_rate%TYPE,
        p_cpi_branch_cd     IN giac_direct_claim_payts.cpi_branch_cd%TYPE,
        p_cpi_rec_no        IN giac_direct_claim_payts.cpi_rec_no%TYPE,
        p_currency_cd       IN giac_direct_claim_payts.currency_cd%TYPE,
        p_disbursement_amt  IN giac_direct_claim_payts.disbursement_amt%TYPE,
        p_foreign_curr_amt  IN giac_direct_claim_payts.foreign_curr_amt%TYPE,
        p_gacc_tran_id      IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_input_vat_amt     IN giac_direct_claim_payts.input_vat_amt%TYPE,
        p_net_disb_amt      IN giac_direct_claim_payts.net_disb_amt%TYPE,
        p_orig_curr_cd      IN giac_direct_claim_payts.orig_curr_cd%TYPE,
        p_orig_curr_rate    IN giac_direct_claim_payts.orig_curr_rate%TYPE,
        p_or_print_tag      IN giac_direct_claim_payts.or_print_tag%TYPE,
        p_payee_cd          IN giac_direct_claim_payts.payee_cd%TYPE,
        p_payee_class_cd    IN giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_type        IN giac_direct_claim_payts.payee_type%TYPE,
       -- p_peril_cd          IN giac_direct_claim_payts.peril_cd%TYPE,
        p_remarks           IN giac_direct_claim_payts.remarks%TYPE,
        p_transaction_type  IN giac_direct_claim_payts.transaction_type%TYPE,
        p_user_id           IN giac_direct_claim_payts.user_id%TYPE,
        p_wholding_tax_amt  IN giac_direct_claim_payts.wholding_tax_amt%TYPE
   ) IS
   BEGIN
           --INSERT INTO ROY_TEST_TBL(string_col, date_col) VALUES ('start!', SYSDATE);
           
        INSERT INTO GIAC_DIRECT_CLAIM_PAYTS(
               advice_id,        claim_id,       clm_loss_id,        convert_rate,       cpi_branch_cd,
               cpi_rec_no,       currency_cd,    disbursement_amt,   foreign_curr_amt,   gacc_tran_id,
               input_vat_amt,    net_disb_amt,   orig_curr_cd,       orig_curr_rate,     or_print_tag,       
               payee_cd,         payee_class_cd, payee_type,         remarks,            transaction_type,   
               /*peril_cd,*/         user_id,        wholding_tax_amt,   last_update)
        VALUES (
               p_advice_id,      p_claim_id,     p_clm_loss_id,      p_convert_rate,     p_cpi_branch_cd,
               p_cpi_rec_no,     p_currency_cd,  p_disbursement_amt, p_foreign_curr_amt, p_gacc_tran_id,
               p_input_vat_amt,  p_net_disb_amt, p_orig_curr_cd,     p_orig_curr_rate,   p_or_print_tag,     
               p_payee_cd,       p_payee_class_cd, p_payee_type,     p_remarks,          p_transaction_type, 
               /*p_peril_cd,*/       p_user_id,      p_wholding_tax_amt,SYSDATE);
        /*EXCEPTION 
           WHEN OTHERS THEN 
                 INSERT INTO ROY_TEST_TBL(string_col, date_col) VALUES ('END!', SYSDATE);*/
        --message('Error: This Payee Class Cd,Payee Cd does not exist');
        --END;        */
   END save_direct_claim_payt;
        
   PROCEDURE set_direct_claim_payt(
        p_dcp   IN giac_direct_claim_payts%ROWTYPE
   ) IS
   BEGIN
        MERGE INTO giac_direct_claim_payts
        USING dual ON (     gacc_tran_id    = p_dcp.gacc_tran_id
                        AND claim_id        = p_dcp.claim_id
                        AND clm_loss_id     = p_dcp.clm_loss_id
        )WHEN NOT MATCHED THEN
            INSERT(
               advice_id,        claim_id,       clm_loss_id,        convert_rate,       cpi_branch_cd,
               cpi_rec_no,       currency_cd,    disbursement_amt,   foreign_curr_amt,   gacc_tran_id,
               input_vat_amt,    net_disb_amt,   orig_curr_cd,       orig_curr_rate,     or_print_tag,       
               payee_cd,         payee_class_cd, payee_type,         remarks,            transaction_type,   
               user_id,          wholding_tax_amt, last_update
            )VALUES(
               p_dcp.advice_id,  p_dcp.claim_id,     p_dcp.clm_loss_id,      p_dcp.convert_rate,     p_dcp.cpi_branch_cd,
               p_dcp.cpi_rec_no, p_dcp.currency_cd,  p_dcp.disbursement_amt, p_dcp.foreign_curr_amt, p_dcp.gacc_tran_id,
               p_dcp.input_vat_amt, p_dcp.net_disb_amt, p_dcp.orig_curr_cd, p_dcp.orig_curr_rate, p_dcp.or_print_tag,     
               p_dcp.payee_cd,   p_dcp.payee_class_cd, p_dcp.payee_type,     p_dcp.remarks, p_dcp.transaction_type, 
               p_dcp.user_id,    p_dcp.wholding_tax_amt,SYSDATE
            )
        WHEN MATCHED THEN 
            UPDATE SET    
               /*advice_id    = p_dcp.advice_id,
               convert_rate = p_dcp.convert_rate,
               cpi_branch_cd= p_dcp.cpi_branch_cd,
               cpi_rec_no   = p_dcp.cpi_rec_no,
               currency_cd  = p_dcp.currency_cd,
               disbursement_amt = p_dcp.disbursement_amt,
               foreign_curr_amt = p_dcp.foreign_curr_amt,
               input_vat_amt    = p_dcp.input_vat_amt,
               net_disb_amt     = p_dcp.net_disb_amt,
               orig_curr_cd     = p_dcp.orig_curr_cd,
               orig_curr_rate   = p_dcp.orig_curr_rate,
               or_print_tag     = p_dcp.or_print_tag,
               payee_cd         = p_dcp.payee_cd,
               payee_class_cd   = p_dcp.payee_class_cd,
               payee_type       = p_dcp.payee_type,*/
               remarks          = p_dcp.remarks,
               --transaction_type = p_dcp.transaction_type,
               user_id          = p_dcp.user_id,
               --wholding_tax_amt = p_dcp.wholding_tax_amt,
               last_update      = SYSDATE;
   END set_direct_claim_payt;
   
   
   PROCEDURE aeg_delete_acct_entries(
        p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_generation_type IN giac_acct_entries.generation_type%TYPE
   ) IS
         dummy  VARCHAR2(1);
      CURSOR AE IS
        SELECT '1'
          FROM giac_acct_entries
         WHERE gacc_tran_id    = p_gacc_tran_id
           AND generation_type = p_generation_type;
    BEGIN
      OPEN ae;
      FETCH ae INTO dummy;
      IF sql%found THEN
    
       DELETE FROM giac_acct_entries
             WHERE gacc_tran_id    = p_gacc_tran_id
               AND generation_type = p_generation_type;
      END IF;
   
   END aeg_delete_acct_entries;
    
    PROCEDURE aeg_insert_update_acct_entries(
           p_gacc_tran_id              IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_gacc_fund_cd             IN giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_branch_cd         IN giac_acct_entries.gacc_gibr_branch_cd%TYPE,     
           iuae_gl_acct_category  IN giac_acct_entries.gl_acct_category%TYPE,
         iuae_gl_control_acct   IN giac_acct_entries.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     IN giac_acct_entries.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     IN giac_acct_entries.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     IN giac_acct_entries.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     IN giac_acct_entries.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     IN giac_acct_entries.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     IN giac_acct_entries.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     IN giac_acct_entries.gl_sub_acct_7%TYPE,
         iuae_sl_cd             IN giac_acct_entries.sl_cd%TYPE,
         iuae_generation_type   IN giac_acct_entries.generation_type%TYPE,
         iuae_gl_acct_id        IN giac_chart_of_accts.gl_acct_id%TYPE,
         iuae_debit_amt         IN giac_acct_entries.debit_amt%TYPE,
         iuae_credit_amt        IN giac_acct_entries.credit_amt%TYPE,
         iuae_sl_type_cd           IN giac_sl_types.sl_type_cd%TYPE,
         iuae_clm_loss_id       IN gicl_acct_entries.clm_loss_id%TYPE
   )IS
        iuae_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
    BEGIN
        SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
            INTO iuae_acct_entry_id
            FROM giac_acct_entries
           WHERE gl_acct_category    = iuae_gl_acct_category
             AND gl_control_acct     = iuae_gl_control_acct
             AND gl_sub_acct_1       = iuae_gl_sub_acct_1
             AND gl_sub_acct_2       = iuae_gl_sub_acct_2
             AND gl_sub_acct_3       = iuae_gl_sub_acct_3
             AND gl_sub_acct_4       = iuae_gl_sub_acct_4
             AND gl_sub_acct_5       = iuae_gl_sub_acct_5
             AND gl_sub_acct_6       = iuae_gl_sub_acct_6
             AND gl_sub_acct_7       = iuae_gl_sub_acct_7
             AND sl_cd               = iuae_sl_cd
             AND generation_type     = iuae_generation_type 
             AND gacc_gibr_branch_cd = p_gacc_branch_cd
             AND gacc_gfun_fund_cd   = p_gacc_fund_cd
             AND gacc_tran_id        = p_gacc_tran_id;
 
      IF NVL(iuae_acct_entry_id,0) = 0 THEN
        iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;

        INSERT into GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                      gacc_gibr_branch_cd, acct_entry_id    ,
                                      gl_acct_id         , gl_acct_category ,
                                      gl_control_acct    , gl_sub_acct_1    ,
                                      gl_sub_acct_2      , gl_sub_acct_3    ,
                                      gl_sub_acct_4      , gl_sub_acct_5    ,
                                      gl_sub_acct_6      , gl_sub_acct_7    ,
                                      sl_cd              , debit_amt        ,
                                      credit_amt         , generation_type  ,
                                      user_id            , last_update)
           VALUES (p_gacc_tran_id  , p_gacc_fund_cd,
                   p_gacc_branch_cd, iuae_acct_entry_id          ,
                   iuae_gl_acct_id               , iuae_gl_acct_category       ,
                   iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                   iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                   iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                   iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                   iuae_sl_cd                    , iuae_debit_amt              ,
                   iuae_credit_amt               , iuae_generation_type        ,
                   USER                          , SYSDATE);
      ELSE
      UPDATE giac_acct_entries
         SET debit_amt  = debit_amt  + iuae_debit_amt,
               credit_amt = credit_amt + iuae_credit_amt
       WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
         AND sl_cd               = iuae_sl_cd
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = p_gacc_branch_cd
         AND gacc_gfun_fund_cd   = p_gacc_fund_cd
         AND gacc_tran_id        = p_gacc_tran_id;
      END IF;
    END aeg_insert_update_acct_entries;
     
    PROCEDURE aeg_ins_upd_giac_acct_entries(
           p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_gacc_fund_cd      IN giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_branch_cd  IN giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_generation_type IN giac_acct_entries.generation_type%TYPE,
           p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE,
        p_payee_class_cd  IN giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_cd        IN giac_direct_claim_payts.payee_cd%TYPE
   )IS 
        CURSOR cur_acct_entries IS
       SELECT generation_type, gl_acct_id, gl_acct_category, gl_control_acct,
              gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
              gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
              sl_type_cd, SL_CD, sl_source_cd,
              SUM(debit_amt) debit_amt, SUM(credit_amt) credit_amt, 
              advice_id, claim_id,
              payee_class_cd, payee_cd
         FROM gicl_acct_entries
        WHERE claim_id = p_claim_id
                 AND advice_id = p_advice_id
              AND payee_class_cd = p_payee_class_cd
              AND payee_cd = p_payee_cd   
        GROUP BY generation_type, gl_acct_id, gl_acct_category, gl_control_acct,
               gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
               gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
               sl_type_cd, sl_cd, sl_source_cd, 
               advice_id, claim_id,
               payee_class_cd, payee_cd;
     v_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
   BEGIN   
      BEGIN
        SELECT MAX(acct_entry_id) 
          INTO v_acct_entry_id
          FROM giac_acct_entries
         WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_acct_entry_id := 0;
      END;    

      FOR al IN cur_acct_entries LOOP
        v_acct_entry_id := v_acct_entry_id + 1;
    
        FOR t IN (SELECT DISTINCT transaction_type
                    FROM giac_direct_claim_payts
                   WHERE gacc_tran_id = p_gacc_tran_id
                     AND claim_id = al.claim_id
                     AND advice_id = al.advice_id
                     AND payee_class_cd = al.payee_class_cd
                     AND payee_cd = al.payee_cd)
        LOOP
          IF t.transaction_type = 1 THEN
             INSERT INTO giac_acct_entries(gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,            
                                           acct_entry_id, gl_acct_id, gl_acct_category,              
                                           gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,                  
                                           gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,                  
                                           gl_sub_acct_6, gl_sub_acct_7, sl_type_cd, sl_cd, 
                                           sl_source_cd,
                                           debit_amt, credit_amt, generation_type,                
                                           user_id, last_update)
                                    VALUES(p_gacc_tran_id, p_gacc_fund_cd, p_gacc_branch_cd, 
                                           v_acct_entry_id, al.gl_acct_id, al.gl_acct_category,
                                           al.gl_control_acct, al.gl_sub_acct_1, al.gl_sub_acct_2,
                                           al.gl_sub_acct_3, al.gl_sub_acct_4, al.gl_sub_acct_5,
                                           al.gl_sub_acct_6, al.gl_sub_acct_7, al.sl_type_cd, al.sl_cd,
                                           al.sl_source_cd,
                                           al.debit_amt, al.credit_amt, 
                                           p_generation_type,
                                           USER, SYSDATE);
          ELSIF t.transaction_type = 2 THEN
             INSERT INTO giac_acct_entries(gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,            
                                           acct_entry_id, gl_acct_id, gl_acct_category,              
                                           gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,                  
                                           gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,                  
                                           gl_sub_acct_6, gl_sub_acct_7, sl_type_cd, sl_cd, 
                                           sl_source_cd,
                                           debit_amt, credit_amt, generation_type,                
                                           user_id, last_update)
                                    VALUES(p_gacc_tran_id, p_gacc_fund_cd, p_gacc_branch_cd, 
                                           v_acct_entry_id, al.gl_acct_id, al.gl_acct_category,
                                           al.gl_control_acct, al.gl_sub_acct_1, al.gl_sub_acct_2,
                                           al.gl_sub_acct_3, al.gl_sub_acct_4, al.gl_sub_acct_5,
                                           al.gl_sub_acct_6, al.gl_sub_acct_7, al.sl_type_cd, al.sl_cd,
                                           al.sl_source_cd,
                                           al.credit_amt, al.debit_amt, 
                                           p_generation_type,
                                           USER, SYSDATE);
          END IF;
        END LOOP;
      END LOOP;
   END aeg_ins_upd_giac_acct_entries; 
   
   PROCEDURE chk_gdcp_a1280_fk(
           p_field_level      IN BOOLEAN,
        p_payee_class_cd IN GIIS_PAYEES.payee_class_cd%TYPE,
        p_payee_no           IN GIIS_PAYEES.payee_no%TYPE, 
        p_dummy             OUT VARCHAR2
   ) IS 
         CURSOR C IS
              SELECT '1'
              FROM   GIIS_PAYEES 
              WHERE  PAYEE_CLASS_CD = p_payee_class_cd
              AND    PAYEE_NO         = p_payee_no;
   BEGIN
         OPEN C;
      FETCH C
      INTO    p_dummy;
      IF C%NOTFOUND THEN
        RAISE NO_DATA_FOUND;
      END IF;
      CLOSE C;
    EXCEPTION
      WHEN OTHERS THEN
        p_dummy := 'x';
     END chk_gdcp_a1280_fk;

   PROCEDURE insert_into_giac_taxes_wheld(
        p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_convert_rate      IN NUMBER,
        p_item_no         IN OUT giac_module_entries.item_no%TYPE, -- := 1;
        p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE,
        p_iss_cd          IN giis_issource.iss_cd%TYPE,     
        p_payee_class_cd  IN giac_taxes_wheld.payee_class_cd%TYPE,
        p_payee_cd        IN giac_taxes_wheld.payee_cd%TYPE
   )IS
         v_module_name    giac_modules.module_name%TYPE;
         gen_type        VARCHAR2(1);
      v_whtax        giac_taxes_wheld.gwtx_whtax_id%type;
      v_tax_amt     giac_taxes_wheld.wholding_tax_amt%type default 0;
      total_whtax   NUMBER(16,2) default 0;
      income_amt    NUMBER(16,2) default 0;
    
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
    
      CURSOR t_amt IS
        SELECT b.tax_cd whtax, sum(nvl(b.tax_amt,0)) tax_amount,
               nvl(sum(b.base_amt),a.net_amt) base_amt
          FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
         WHERE a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.payee_cd = p_payee_cd
           AND a.payee_class_cd = p_payee_class_cd
           AND a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id
           AND b.tax_type = 'W'
           AND b.tax_cd  = v_whtax
      GROUP BY tax_cd, a.net_amt;
   BEGIN
           IF p_iss_cd = 'RI' THEN          
           v_module_name := 'GIACS018';
        ELSE
           v_module_name := 'GIACS017';
        END IF;
        BEGIN
          SELECT generation_type
            INTO gen_type
            FROM giac_modules
           WHERE module_name = v_module_name; 
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          null;
         --   lapse;               *********************
            --msg_alert('Insertion not completed. Generation type does not exist!','E',true);
        END;
    --    income_amt := p_income_amount;
     
        FOR whtax IN cur_whtax LOOP
          v_whtax := whtax.whtax; 
    
          FOR al IN t_amt LOOP
            total_whtax := total_whtax + al.tax_amount;
            income_amt := income_amt + al.base_amt;   
    --      income_amt := income_amt + total_whtax;
     
            INSERT INTO giac_taxes_wheld
                       (gacc_tran_id, gen_type,         payee_class_cd, 
                        item_no,      payee_cd,         gwtx_whtax_id, 
                        income_amt,   wholding_tax_amt, user_id,        last_update)
                 VALUES(p_gacc_tran_id, gen_type,   p_payee_class_cd, 
                        p_item_no,  p_payee_cd, v_whtax,
                        (income_amt * nvl(p_convert_rate,1)), 
                        (total_whtax * nvl(p_convert_rate,1)), USER, SYSDATE);
            p_item_no := p_item_no + 1;
          END LOOP;
        END LOOP;
   END insert_into_giac_taxes_wheld;
   
   PROCEDURE update_giac_op_text(
           p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_module_name      IN giac_modules.module_name%TYPE
   )IS
             ws_seq_no      NUMBER(2);
        ws_gen_type    VARCHAR2(1); 
        CURSOR C IS
            SELECT     A.gacc_tran_id,    A.user_id,    A.last_update, B.line_cd, (A.disbursement_amt * -1) item_amt, 
                   'CLAIM NUMBER : ' || B.line_cd || '-' || B.subline_cd || '-' || B.iss_cd || '-' || TO_CHAR(B.clm_yy,'99') || '-' || TO_CHAR(B.clm_seq_no,'099999') ||
                   ' / POLICY NUMBER : ' || C.line_cd || '-' || C.subline_cd || '-' || C.iss_cd||'-'|| TO_CHAR(C.issue_yy,'99') || '-' || TO_CHAR(C.pol_seq_no,'0999999') 
                || '-' || TO_CHAR(C.renew_no,'09') || ' / LOSS DATE : ' || TO_CHAR(B.loss_date,'MON DD, YYYY') || ' -- '|| D.exp_desc text, A.currency_cd, A.foreign_curr_amt        
              FROM GIAC_DIRECT_CLAIM_PAYTS A,
                   GICL_CLAIMS B,
                   GIPI_POLBASIC C,
                   GIIS_EXPENSE D
             WHERE A.GACC_TRAN_ID  = p_gacc_tran_id 
               AND A.CLAIM_ID = B.CLAIM_ID;
    BEGIN
      WS_SEQ_NO := 0;
      SELECT generation_type
        INTO ws_gen_type
        FROM giac_modules
       WHERE module_id = (SELECT module_id
                            FROM giac_modules
                           WHERE module_name = p_module_name);
      DELETE FROM giac_op_text
       WHERE gacc_tran_id  = p_gacc_tran_id
         AND item_gen_type = ws_gen_type;
      FOR C_REC IN C LOOP
        INSERT INTO giac_op_text
           (gacc_tran_id, item_seq_no, item_gen_type, item_text,
            item_amt, user_id, last_update, line, print_seq_no,currency_cd,foreign_curr_amt)
           VALUES(C_REC.gacc_tran_id, ws_seq_no, ws_gen_type, C_REC.text,
            C_REC.item_amt, C_REC.user_id, C_REC.last_update, C_REC.line_cd,
            ws_seq_no, C_REC.currency_cd, C_REC.foreign_curr_amt);
        ws_seq_no := ws_seq_no + 1;
      END LOOP;
    END update_giac_op_text;
   
   PROCEDURE update_workflow_switch(
           p_event_desc IN VARCHAR2,
        p_module_id  IN VARCHAR2,
        p_user       IN VARCHAR2
   )IS
        v_commit  BOOLEAN := FALSE;                                 
   BEGIN
      FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd 
                         FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                       WHERE 1=1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       AND b.userid = p_user
                       AND a.module_id = p_module_id
                       AND a.event_cd = d.event_cd
                       AND UPPER(d.event_desc) = UPPER(NVL(p_event_desc,d.event_desc)) )
      LOOP
        FOR B_REC IN ( SELECT b.col_value, b.tran_id , b.event_col_cd, b.event_user_mod, b.switch 
                           FROM gipi_user_events b 
                          WHERE b.event_user_mod = a_rec.event_user_mod 
                          AND b.event_col_cd = a_rec.event_col_cd )
          LOOP
            IF b_rec.switch = 'N' THEN
                UPDATE gipi_user_events
                   SET switch = 'Y'
                 WHERE event_user_mod = b_rec.event_user_mod
                   AND event_col_cd = b_rec.event_col_cd
                   AND tran_id = b_rec.tran_id;
                v_commit := TRUE;  
              END IF;  
          END LOOP;
      END LOOP;
        IF v_commit = TRUE THEN
           COMMIT;
        END IF;  
    END update_workflow_switch;
   
   PROCEDURE dcp_post_forms_commit(
           p_gacc_tran_id       IN giac_direct_claim_payts.gacc_tran_id%TYPE,
        p_trans_source      IN VARCHAR2,
        p_or_flag          IN VARCHAR2,
        p_gacc_fund_cd      IN giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_gacc_branch_cd  IN giac_acct_entries.gacc_gibr_branch_cd%TYPE,
           p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE,
        p_payee_class_cd  IN giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_cd        IN giac_direct_claim_payts.payee_cd%TYPE,
        p_convert_rate      IN NUMBER,
        p_iss_cd          IN giis_issource.iss_cd%TYPE,
        p_module_name      IN giac_modules.module_name%TYPE,
        p_generation_type IN OUT giac_acct_entries.generation_type%TYPE,
        p_item_no         IN OUT giac_module_entries.item_no%TYPE,
        p_module_id            IN OUT giac_modules.module_id%TYPE
   ) IS
   BEGIN 
            IF p_trans_source = 'OP' THEN
           IF p_or_flag = 'P' THEN
              NULL;
           ELSE
              UPDATE_GIAC_OP_TEXT(p_gacc_tran_id,p_module_name);
           END IF;
        END IF;
        --CLEAR_MESSAGE;
        
        BEGIN    
            BEGIN   
               SELECT module_id,
                      generation_type
                 INTO p_module_id,
                      p_generation_type
                 FROM giac_modules
                WHERE module_name  = p_module_name;
             EXCEPTION
               WHEN no_data_found THEN
                 NULL; --Msg_Alert('No data found in GIAC MODULES.', 'I', TRUE);
            END;
             
            aeg_delete_acct_entries(p_gacc_tran_id,p_generation_type);
            
            DELETE FROM giac_taxes_wheld
                  WHERE gacc_tran_id = p_gacc_tran_id;
            
            p_item_no := 1;
            
            FOR c IN (SELECT DISTINCT claim_id, advice_id, 
                                      payee_class_cd, payee_cd
                                 FROM giac_direct_claim_payts
                                WHERE gacc_tran_id = p_gacc_tran_id)
            LOOP
                aeg_ins_upd_giac_acct_entries(p_gacc_tran_id,p_gacc_fund_cd,p_gacc_branch_cd,
                            p_generation_type,c.claim_id,c.advice_id,c.payee_class_cd,c.payee_cd);
                insert_into_giac_taxes_wheld(p_gacc_tran_id,p_convert_rate,p_item_no,c.claim_id,
                               c.advice_id,p_iss_cd,c.payee_class_cd,c.payee_cd);                       
            END LOOP;  
             
        END;
        
   END dcp_post_forms_commit;
   
   PROCEDURE dcp_post_insert(
           p_trans_type      IN NUMBER,     
           p_claim_id        IN giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       IN giac_direct_claim_payts.advice_id%TYPE
   )IS
   BEGIN
      IF p_trans_type = 1 THEN
         UPDATE gicl_advice
            SET apprvd_tag = 'Y'
          WHERE claim_id = p_claim_id
            AND advice_id = p_advice_id;
      ELSIF p_trans_type = 2 THEN
         UPDATE gicl_advice
            SET apprvd_tag = 'N'
          WHERE claim_id = p_claim_id
            AND advice_id = p_advice_id;        
      END IF; 
   END dcp_post_insert;
   
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.03.2012
   **  Reference By : GIACS017 - Direct Trans - Direct Claim Payts
   **  Description  :  retrieves advice seq no LOV
   */
    FUNCTION get_advice_seq_listing(
        p_module_id        VARCHAR2,
        p_user_id          VARCHAR2,
        p_viss_cd          gicl_advice.iss_cd%TYPE, 
        p_tran_type        GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE, 
        p_line_cd          gicl_advice.line_cd%TYPE,
        p_iss_cd           gicl_advice.iss_cd%TYPE,
        p_advice_year      gicl_advice.advice_year%TYPE,
        p_advice_seq_no    gicl_advice.advice_seq_no%TYPE
   ) RETURN adv_seq_listing_tab PIPELINED IS
        v_adv_type         adv_seq_listing_type;
        v_iss_cd           gicl_advice.iss_cd%TYPE := p_viss_cd; 
   BEGIN
     IF v_iss_cd IS NULL THEN
        v_iss_cd := giacp.v('RI_ISS_CD');
     END IF;
     
     IF p_tran_type = 1 THEN
        FOR i IN (
            select  a.advice_seq_no, 
                    a.line_cd||'-'||a.iss_cd||'-'||ltrim(to_char(a.advice_year,'0999'))||'-'||ltrim(to_char(a.advice_seq_no,'0099999')) advice_no, 
                    a.line_cd,  a.iss_cd, a.advice_year, a.advice_id, 
                    a.convert_rate, a.claim_id, a.currency_cd, c.currency_desc
              from gicl_advice a, giis_currency c
             where advice_flag = 'Y' 
               and nvl(apprvd_tag,'N') = 'N' 
               --and batch_csr_id IS NULL --added by reymon 04262013 --comment out by john 12.4.2014
               --and batch_dv_id IS NULL --added by reymon 04262013 --comment out by john 12.4.2014
               and line_cd = nvl(p_line_cd, line_cd)
--               and iss_cd = DECODE(check_user_per_iss_cd_acctg2(null,iss_cd,p_module_id, p_user_id),1,iss_cd,NULL)
               --replaced by john 3.11.2015
               AND ((SELECT access_tag
                          FROM giis_user_modules
                         WHERE userid = NVL (p_user_id, USER)   
                           AND module_id = 'GIACS017'
                           AND tran_cd IN (
                                  SELECT b.tran_cd         
                                    FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                   WHERE a.user_id = b.userid
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = a.iss_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS017')) = 1
                 OR (SELECT access_tag
                          FROM giis_user_grp_modules
                         WHERE module_id = 'GIACS017'
                           AND (user_grp, tran_cd) IN (
                                  SELECT a.user_grp, b.tran_cd
                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                   WHERE a.user_grp = b.user_grp
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = a.iss_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS017')) = 1
               )
               and iss_cd != v_iss_cd 
               and advice_year = nvl(p_advice_year, advice_year) 
               and advice_seq_no = nvl(p_advice_seq_no, advice_seq_no)
               and a.currency_cd = c.main_currency_cd
               and a.claim_id IN (
                                SELECT claim_id
                                  FROM gicl_clm_loss_exp
                                 WHERE tran_id IS NULL 
                                   AND advice_id IS NOT NULL)
             order by line_cd, iss_cd, advice_year, advice_seq_no
        ) LOOP
            v_adv_type.advice_seq_no    := i.advice_seq_no;
            v_adv_type.advice_no        := i.advice_no;
            v_adv_type.line_cd          := i.line_cd;
            v_adv_type.iss_cd           := i.iss_cd;
            v_adv_type.advice_year      := i.advice_year;
            v_adv_type.advice_id        := i.advice_id;
            v_adv_type.claim_id         := i.claim_id;
            v_adv_type.convert_rate     := i.convert_rate;
            v_adv_type.currency_cd      := i.currency_cd;
            v_adv_type.currency_desc    := i.currency_desc;
            BEGIN
                SELECT     line_cd||'-'||subline_cd||'-'||iss_cd||'-'|| TO_CHAR(clm_yy, '09')
                        ||'-'||TO_CHAR(clm_seq_no, '0000009') claim_no,
                        line_cd||'-'||subline_cd||'-'||pol_iss_cd||'-'||TO_CHAR(issue_yy, '09')
                        ||'-'||TO_CHAR(pol_seq_no, '0000009')||'-'||TO_CHAR(renew_no, '09') policy_no,
                        assured_name
                  INTO  v_adv_type.dsp_claim_no, v_adv_type.dsp_policy_no, v_adv_type.assured_name  
                  FROM     gicl_claims
                 WHERE     claim_id = i.claim_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            PIPE ROW (v_adv_type);
        END LOOP;
     ELSIF p_tran_type = 2 THEN
        FOR i IN (
--            select a.advice_seq_no, 
--                   a.line_cd||'-'||a.iss_cd||'-'||ltrim(to_char(a.advice_year,'0999'))||'-'|| ltrim(to_char(a.advice_seq_no,'099999')) advice_no, 
--                   a.line_cd, 
--                   a.iss_cd, 
--                   a.advice_year, 
--                   a.advice_id, 
--                   a.claim_id,
--                   a.currency_cd,
--                   a.convert_rate,
--                   c.currency_desc
--              from gicl_advice a, gicl_clm_loss_exp b, giis_currency c
--             where a.claim_id = b.claim_id 
--               and a.advice_id = b.advice_id 
--               and a.currency_cd = c.main_currency_cd
--               --and batch_csr_id IS NULL --added by reymon 04262013 --comment out by john 12.4.2014
--               --and batch_dv_id IS NULL --added by reymon 04262013 --comment out by john 12.4.2014
--               and not exists (select x.gacc_tran_id from giac_reversals x, giac_acctrans y where x.reversing_tran_id = y.tran_id and y.tran_flag <> 'D' and x.gacc_tran_id = b.tran_id) 
--               and a.line_cd = nvl(p_line_cd, a.line_cd) 
--               and a.iss_cd = DECODE(check_user_per_iss_cd_acctg2(null,a.iss_cd,p_module_id,p_user_id),1,a.iss_cd,NULL) 
--               and a.iss_cd != v_iss_cd 
--               and a.advice_year = nvl(p_advice_year, a.advice_year) 
--             order by a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no
            --replaced by john 3.9.2015
            SELECT   a.advice_seq_no,
                        a.line_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (a.advice_year, '0999'))
                     || '-'
                     || LTRIM (TO_CHAR (a.advice_seq_no, '099999')) advice_no,
                     a.line_cd, a.iss_cd, a.advice_year, a.advice_id, a.claim_id,
                     a.currency_cd, a.convert_rate, c.currency_desc
                FROM gicl_advice a, giis_currency c
               WHERE a.currency_cd = c.main_currency_cd
                 AND (a.claim_id, a.advice_id) IN (SELECT b.claim_id, b.advice_id
                                                     FROM gicl_clm_loss_exp b
                                                    WHERE NOT EXISTS (
                                                        SELECT 1
                                                          FROM giac_reversals x, giac_acctrans y
                                                         WHERE x.reversing_tran_id = y.tran_id
                                                           AND y.tran_flag <> 'D'
                                                           AND x.gacc_tran_id = b.tran_id)
                                                     )
                 AND a.line_cd = a.line_cd
                 AND a.iss_cd != v_iss_cd
                 AND a.advice_year = a.advice_year
                 and a.line_cd = nvl(p_line_cd, a.line_cd) 
                 AND ((SELECT access_tag
                          FROM giis_user_modules
                         WHERE userid = NVL (p_user_id, USER)   
                           AND module_id = 'GIACS017'
                           AND tran_cd IN (
                                  SELECT b.tran_cd         
                                    FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                   WHERE a.user_id = b.userid
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = a.iss_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS017')) = 1
                 OR (SELECT access_tag
                          FROM giis_user_grp_modules
                         WHERE module_id = 'GIACS017'
                           AND (user_grp, tran_cd) IN (
                                  SELECT a.user_grp, b.tran_cd
                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                   WHERE a.user_grp = b.user_grp
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = a.iss_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS017')) = 1
               )
                 and a.iss_cd != v_iss_cd 
                 and a.advice_year = nvl(p_advice_year, a.advice_year) 
            ORDER BY a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no
        ) LOOP
            v_adv_type.advice_seq_no    := i.advice_seq_no;
            v_adv_type.advice_no        := i.advice_no;
            v_adv_type.line_cd          := i.line_cd;
            v_adv_type.iss_cd           := i.iss_cd;
            v_adv_type.advice_year      := i.advice_year;
            v_adv_type.advice_id        := i.advice_id;
            v_adv_type.claim_id         := i.claim_id;
            v_adv_type.convert_rate     := i.convert_rate;
            v_adv_type.currency_cd      := i.currency_cd;
            v_adv_type.currency_desc    := i.currency_desc;
            BEGIN
                SELECT     line_cd||'-'||subline_cd||'-'||iss_cd||'-'|| TO_CHAR(clm_yy, '09')
                        ||'-'||TO_CHAR(clm_seq_no, '0000009') claim_no,
                        line_cd||'-'||subline_cd||'-'||pol_iss_cd||'-'||TO_CHAR(issue_yy, '09')
                        ||'-'||TO_CHAR(pol_seq_no, '0000009')||'-'||TO_CHAR(renew_no, '09') policy_no,
                        assured_name
                  INTO  v_adv_type.dsp_claim_no, v_adv_type.dsp_policy_no, v_adv_type.assured_name  
                  FROM     gicl_claims
                 WHERE     claim_id = i.claim_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            PIPE ROW (v_adv_type);
        END LOOP;
     END IF;
   END get_advice_seq_listing;
   
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 04.02.2012
   **  Reference By : GIACS017 - Direct Trans - Direct Claim Payts
   **  Description  :  retrieves giac_direct_claim_payts record list
   */
   FUNCTION get_direct_claim_payts_list (
       p_gacc_tran_id           GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE
   ) RETURN gdcp_list_tab PIPELINED IS
       v_gdcp       gdcp_list_type;
   BEGIN
       FOR i IN (
           SELECT gdcp.*, gc.currency_desc 
             FROM giac_direct_claim_payts gdcp, giis_currency gc 
            WHERE gacc_tran_id = p_gacc_tran_id
              AND gdcp.currency_cd = gc.main_currency_cd
       ) LOOP
            v_gdcp.gacc_tran_id            := i.gacc_tran_id;
            v_gdcp.transaction_type        := i.transaction_type;
            v_gdcp.claim_id                := i.claim_id;
            v_gdcp.clm_loss_id             := i.clm_loss_id;
            v_gdcp.advice_id               := i.advice_id;
            v_gdcp.payee_cd                := i.payee_cd;
            v_gdcp.payee_class_cd          := i.payee_class_cd;
            v_gdcp.payee_type              := i.payee_type;
            v_gdcp.disbursement_amt        := i.disbursement_amt;
            v_gdcp.currency_cd             := i.currency_cd;
            v_gdcp.convert_rate            := i.convert_rate;
            v_gdcp.foreign_curr_amt        := i.foreign_curr_amt;
            v_gdcp.or_print_tag            := i.or_print_tag;
            v_gdcp.remarks                 := i.remarks;
            v_gdcp.input_vat_amt           := i.input_vat_amt;
            v_gdcp.wholding_tax_amt        := i.wholding_tax_amt;
            v_gdcp.net_disb_amt            := i.net_disb_amt;
            v_gdcp.orig_curr_cd            := i.orig_curr_cd;
            v_gdcp.orig_curr_rate          := i.orig_curr_rate;
            --v_gdcp.peril_cd                := i.peril_cd;
                    
            v_gdcp.currency_desc           := i.currency_desc;
            
            BEGIN
                SELECT iss_cd, line_cd, advice_year, advice_seq_no,
                       (line_cd ||'-'||iss_cd||'-'||advice_year||'-'
                       ||TO_CHAR(advice_seq_no, '0000009')) dsp_advice_no,
                       batch_csr_id--added by reymon 04262013
                  INTO v_gdcp.dsp_iss_cd, v_gdcp.dsp_line_cd,
                       v_gdcp.dsp_advice_year, v_gdcp.dsp_advice_seq_no,
                       v_gdcp.dsp_advice_no,
                       v_gdcp.batch_csr_id--added by reymon 04262013
                  FROM gicl_advice
                 WHERE claim_id = i.claim_id
                   AND advice_id = i.advice_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  NULL;
            END;
            
            IF i.payee_type = 'L' THEN
                v_gdcp.dsp_payee_desc := 'Loss';
            ELSIF i.payee_type = 'E' THEN
                v_gdcp.dsp_payee_desc := 'Expense';
            END IF;
            
            BEGIN
                SELECT a.peril_sname
                  INTO v_gdcp.dsp_peril_name
                  FROM giis_peril a, gicl_clm_loss_exp b
                 WHERE a.peril_cd = b.peril_cd
                   AND b.claim_id = i.claim_id
                   AND b.clm_loss_id = i.clm_loss_id
                   AND b.advice_id = i.advice_id
                   AND a.line_cd = v_gdcp.dsp_line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  NULL;
            END;

            BEGIN
                SELECT DECODE (payee_first_name,null,payee_last_name,
                                            payee_last_name
                                            ||', '||payee_first_name
                                            ||' '||payee_middle_name
                                            ) payee
                  INTO v_gdcp.dsp_payee_name
                  FROM giis_payees
                 WHERE payee_class_cd = i.payee_class_cd
                   AND payee_no = i.payee_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  NULL;
            END;
            
            BEGIN
              SELECT B.LINE_CD,
                     B.SUBLINE_CD,
                     B.POL_ISS_CD,
                     B.ISSUE_YY,
                     B.POL_SEQ_NO,
                     B.RENEW_NO,
                     B.ISS_CD,
                     B.CLM_YY,
                     B.CLM_SEQ_NO,
                     B.ASSURED_NAME
                INTO v_gdcp.dsp_line_cd2,
                     v_gdcp.dsp_subline_cd,
                     v_gdcp.dsp_iss_cd3,
                     v_gdcp.dsp_issue_yy,
                     v_gdcp.dsp_pol_seq_no,
                     v_gdcp.dsp_renew_no,
                     v_gdcp.dsp_iss_cd2,
                     v_gdcp.dsp_clm_yy,
                     v_gdcp.dsp_clm_seq_no,
                     v_gdcp.dsp_assured_name
                FROM GICL_CLAIMS B
               WHERE B.CLAIM_ID = i.claim_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            PIPE ROW(v_gdcp);

       END LOOP;
   END get_direct_claim_payts_list;
   
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 04.04.2012
   **  Reference By : GIACS017 - Direct Trans - Direct Claim Payts
   **  Description  :  retrieves sum of amount per gacc_tran_id
   */
   PROCEDURE get_gdcp_amount_sums (
      p_gacc_tran_id    IN  GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
      p_sum_disbmt_amt  OUT NUMBER,
      p_sum_input_vat   OUT NUMBER,
      p_sum_wholding    OUT NUMBER,
      p_sum_dsp_net_amt OUT NUMBER
   ) IS
   BEGIN
        BEGIN
            SELECT NVL(SUM(disbursement_amt),0)
              INTO p_sum_disbmt_amt
              FROM giac_direct_claim_payts
            WHERE gacc_tran_id = p_gacc_tran_id; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_sum_disbmt_amt := 0;
        END;
        
        BEGIN
            SELECT NVL(SUM(input_vat_amt),0)
              INTO p_sum_input_vat
              FROM giac_direct_claim_payts
             WHERE gacc_tran_id = p_gacc_tran_id; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_sum_input_vat := 0;  
        END;
        
        BEGIN
            SELECT NVL(SUM(wholding_tax_amt),0)
              INTO p_sum_wholding
              FROM giac_direct_claim_payts
             WHERE gacc_tran_id = p_gacc_tran_id; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_sum_wholding := 0;
        END;
        
        BEGIN
            SELECT NVL(SUM(net_disb_amt),0)        
              INTO p_sum_dsp_net_amt
              FROM giac_direct_claim_payts
             WHERE gacc_tran_id = p_gacc_tran_id; 
    
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_sum_dsp_net_amt := 0;
        END;
   END get_gdcp_amount_sums;
   
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 04.04.2012
   **  Reference By : GIACS017 - Direct Trans - Direct Claim Payts
   **  Description  :  generates GDCP record from selected advice
   */
   FUNCTION get_dcp_from_advice(
        p_gacc_tran_id          GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_tran_type             GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
        p_line_cd               GICL_ADVICE.iss_cd%TYPE,
        p_iss_cd                GICL_ADVICE.line_cd%TYPE,
        p_advice_year           GICL_ADVICE.advice_year%TYPE,
        p_advice_seq_no         GICL_ADVICE.advice_seq_no%TYPE,
        p_payee_cd              GIAC_DIRECT_CLAIM_PAYTS.payee_cd%TYPE,
        p_claim_id              GIAC_DIRECT_CLAIM_PAYTS.claim_id%TYPE,
        p_clm_loss_id           GIAC_DIRECT_CLAIM_PAYTS.clm_loss_id%TYPE,
        p_ri_iss_cd             GICL_ADVICE.iss_cd%TYPE,
        p_module_id             GIIS_MODULES.module_id%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
   ) RETURN gdcp_list_tab PIPELINED IS
        v_gdcp       gdcp_list_type;  
        v_check      NUMBER(1) := 0;
        v_iss_cd     GIAC_PARAMETERS.param_value_v%TYPE := nvl(p_ri_iss_cd, GIACP.v('RI_ISS_CD'));
   BEGIN
        FOR i IN (
            SELECT * FROM 
                TABLE(GIAC_DIRECT_CLAIM_PAYTS_PKG.get_advice_seq_listing(p_module_id, p_user_id, v_iss_cd, 
                            p_tran_type, p_line_cd, p_iss_cd, p_advice_year, p_advice_seq_no))
             WHERE claim_id = p_claim_id
        ) LOOP
             --advice_seq_no, advice_no, line_cd, iss_cd, advice_year, advice_id, claim_id, convert_rate, currency_cd, currency_desc
            v_gdcp.gacc_tran_id            := p_gacc_tran_id;
            v_gdcp.transaction_type        := p_tran_type;
            v_gdcp.claim_id                := i.claim_id;
            v_gdcp.dsp_line_cd                 := i.line_cd;
            v_gdcp.dsp_iss_cd                  := i.iss_cd;
            v_gdcp.dsp_advice_year             := i.advice_year;
            v_gdcp.dsp_advice_seq_no           := i.advice_seq_no;
            v_gdcp.advice_id               := i.advice_id;
            v_gdcp.currency_cd             := i.currency_cd;
            v_gdcp.convert_rate            := i.convert_rate;
            v_gdcp.dsp_advice_no           := i.advice_no;
            
            FOR j IN (
                SELECT * FROM TABLE (GIAC_DIRECT_CLAIM_PAYTS_PKG.get_clm_loss_id(p_line_cd,i.advice_id,i.claim_id,p_tran_type))
                  WHERE claim_loss_id = NVL(p_clm_loss_id, claim_loss_id) AND
                        payee_cd = NVL(p_payee_cd, payee_cd)
            ) LOOP
                --claim_loss_id, payee_type, payee_type_desc, payee_class_cd, payee_cd, payee, peril_cd, peril_sname, net_amt, paid_amt, advice_amt
                v_gdcp.clm_loss_id          := j.claim_loss_id;               
                v_gdcp.payee_type           := j.payee_type;
                v_gdcp.dsp_payee_desc       := j.payee_type_desc;
                v_gdcp.payee_class_cd       := j.payee_class_cd;
                v_gdcp.payee_cd             := j.payee_cd;
                v_gdcp.dsp_payee_name       := j.payee;
                v_gdcp.dsp_peril_name       := j.peril_sname;
                
                v_gdcp.disbursement_amt     := j.net_amt;
                v_gdcp.foreign_curr_amt     := j.net_amt/i.convert_rate;--changed to division reymon 04262013
                
               GIAC_DIRECT_CLAIM_PAYTS_PKG.compute_advice_default_amount(
                   v_check, p_tran_type, p_gacc_tran_id, i.claim_id, j.claim_loss_id,
                   i.advice_id, v_gdcp.input_vat_amt, v_gdcp.wholding_tax_amt,
                   v_gdcp.net_disb_amt);
                   
                EXIT;
            END LOOP;
            
            BEGIN
              SELECT B.LINE_CD,
                     B.SUBLINE_CD,
                     B.POL_ISS_CD,
                     B.ISSUE_YY,
                     B.POL_SEQ_NO,
                     B.RENEW_NO,
                     B.ISS_CD,
                     B.CLM_YY,
                     B.CLM_SEQ_NO,
                     B.ASSURED_NAME
                INTO v_gdcp.dsp_line_cd2,
                     v_gdcp.dsp_subline_cd,
                     v_gdcp.dsp_iss_cd3,
                     v_gdcp.dsp_issue_yy,
                     v_gdcp.dsp_pol_seq_no,
                     v_gdcp.dsp_renew_no,
                     v_gdcp.dsp_iss_cd2,
                     v_gdcp.dsp_clm_yy,
                     v_gdcp.dsp_clm_seq_no,
                     v_gdcp.dsp_assured_name
                FROM GICL_CLAIMS B
               WHERE B.CLAIM_ID = i.claim_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            PIPE ROW(v_gdcp);
        END LOOP;
   END get_dcp_from_advice;
   
   
   FUNCTION get_dcp_from_batch (
        p_gacc_tran_id          GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_tran_type             GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,       
        p_batch_csr_id          GICL_BATCH_CSR.batch_csr_id%TYPE,
        p_ri_iss_cd             GICL_ADVICE.iss_cd%TYPE,
        p_module_id             GIIS_MODULES.module_id%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
    ) RETURN gdcp_list_tab PIPELINED IS 
        v_gdcp       gdcp_list_type; 
        v_check      NUMBER(1) := 0;
    BEGIN
    
        FOR i IN(
            SELECT  DISTINCT B.advice_id
                        ,A.fund_cd 
                        ,A.batch_seq_no 
                        ,B.line_cd
                        ,A.batch_csr_id
                        ,A.iss_cd iss 
                        ,B.advice_year
                        ,B.advice_seq_no
                        ,A.paid_amt 
                        ,E.payee_type
                        ,LTRIM(C.payee_last_name)||' '||LTRIM(C.payee_first_name)||' '||LTRIM(C.payee_middle_name) payee_name
                        ,decode(E.payee_type,'L','Loss','E','Expense') p_type
                        ,E.payee_class_cd , E.PAYEE_CD 
                        ,F.peril_sname 
                        ,(E.net_amt * nvl(B.convert_rate,1)) net_amt 
                        ,(NVL(E.paid_amt,0) * nvl(B.convert_rate,1)) net_disb_amt--added conversion to pesos reymon 04292013
                        ,E.CLM_LOSS_ID
                        ,B.claim_id 
                        ,B.currency_cd
                        ,B.convert_rate
                        ,B.line_cd||'-'||B.iss_cd||'-'||ltrim(to_char(B.advice_year,'0999'))
                           ||'-'||ltrim(to_char(B.advice_seq_no,'099999')) advice_no
                FROM gicl_batch_csr A,
                        gicl_advice  B,
                        giis_payees C,
                        gicl_clm_loss_exp E,
                        giis_peril F     
                WHERE A.batch_csr_id = B.batch_csr_id    
                    AND A.payee_class_cd = C.payee_class_cd
                    AND A.payee_cd = C.payee_no 
                    AND A.batch_csr_id = p_batch_csr_id
                    AND B.advice_flag = 'Y' 
                    AND B.advice_id = E.advice_id
                    AND E.peril_cd = F.peril_cd 
                    AND F.line_cd = B.line_cd
                ORDER BY B.advice_id) 
         LOOP
            v_gdcp.gacc_tran_id            := p_gacc_tran_id;
            v_gdcp.transaction_type        := p_tran_type;
            v_gdcp.dsp_line_cd             := i.line_cd;
            v_gdcp.dsp_iss_cd              := i.iss;
            v_gdcp.dsp_advice_year         := i.advice_year;
            v_gdcp.dsp_advice_seq_no       := i.advice_seq_no;
            v_gdcp.payee_class_cd          := i.payee_class_cd;
            v_gdcp.dsp_peril_name          := i.peril_sname;
            
            v_gdcp.dsp_payee_name          := i.payee_name;
            v_gdcp.payee_cd                := i.payee_cd;
            v_gdcp.clm_loss_id             := i.clm_loss_id;
            v_gdcp.payee_type              := i.payee_type;
            v_gdcp.advice_id               := i.advice_id;
            v_gdcp.claim_id                := i.claim_id;
            v_gdcp.currency_cd             := i.currency_cd;
            v_gdcp.convert_rate            := i.convert_rate;
            v_gdcp.dsp_advice_no           := i.advice_no;
            
            GIAC_DIRECT_CLAIM_PAYTS_PKG.compute_advice_default_amount(
                   v_check, p_tran_type, p_gacc_tran_id, i.claim_id, i.clm_loss_id, 
                   i.advice_id, v_gdcp.input_vat_amt, v_gdcp.wholding_tax_amt,
                   v_gdcp.net_disb_amt);
                   
            v_gdcp.input_vat_amt           := NVL(v_gdcp.input_vat_amt, 0);
            v_gdcp.wholding_tax_amt        := NVL(v_gdcp.wholding_tax_amt, 0);
            v_gdcp.disbursement_amt        := i.net_amt;
            v_gdcp.net_disb_amt            := i.net_disb_amt;
            v_gdcp.foreign_curr_amt        := i.net_amt/i.convert_rate;--changed to division reymon 04292013
            v_gdcp.batch_csr_id            := i.batch_csr_id;--added by reymon 04292013

            IF i.payee_type = 'L' THEN
                v_gdcp.dsp_payee_desc := 'Loss';
            ELSIF i.payee_type = 'E' THEN
                v_gdcp.dsp_payee_desc := 'Expense';
            END IF;

            BEGIN
              SELECT line_cd,
                     subline_cd,
                     pol_iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     iss_cd,
                     clm_yy,
                     clm_seq_no,
                     assured_name
                INTO v_gdcp.dsp_line_cd2,
                     v_gdcp.dsp_subline_cd,
                     v_gdcp.dsp_iss_cd3,
                     v_gdcp.dsp_issue_yy,
                     v_gdcp.dsp_pol_seq_no,
                     v_gdcp.dsp_renew_no,
                     v_gdcp.dsp_iss_cd2,
                     v_gdcp.dsp_clm_yy,
                     v_gdcp.dsp_clm_seq_no,
                     v_gdcp.dsp_assured_name
              FROM gicl_claims 
             WHERE claim_id = v_gdcp.claim_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            BEGIN
                SELECT currency_desc INTO v_gdcp.currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            PIPE ROW(v_gdcp);
         END LOOP;       			   
    
    END get_dcp_from_batch;
   
   
   PROCEDURE giacs017_post_forms_commit (
        p_gacc_tran_id          IN      GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_gacc_branch_cd        IN      GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        p_gacc_fund_cd          IN      GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        p_tran_source           IN      VARCHAR2,
        p_or_flag               IN      VARCHAR2,
        p_module_name           IN OUT  GIAC_MODULES.module_name%TYPE, --module_id
        p_user_id               IN      GIIS_USERS.user_id%TYPE,
        p_var_gen_type          IN OUT  GIAC_MODULES.generation_type%TYPE,
        p_message               OUT     VARCHAR2
    ) IS
        v_module_id             GIAC_MODULES.module_id%TYPE;
        v_acct_entry            VARCHAR2(1);
        var_v_item_no           GIAC_MODULE_ENTRIES.item_no%TYPE := 1;
    BEGIN
        IF p_tran_source = 'OP' THEN
            IF p_or_flag = 'P' THEN
                NULL;
            ELSE
                GIAC_OP_TEXT_PKG.update_giac_op_text_giacs017(p_gacc_tran_id, p_module_name);
            END IF;
        END IF;
        
        BEGIN   -- judyann 03302009; transfered from Aeg_Ins_Updt_Giac_Acct_Entries
            SELECT module_id,
                   generation_type
            INTO v_module_id,
                 p_var_gen_type
            FROM giac_modules
            WHERE module_name  = p_module_name;
        EXCEPTION
            WHEN no_data_found THEN
            p_message := 'No data found in GIAC MODULES.';
        END;
        
        --AEG_Delete_Acct_Entries
        FOR i IN (
            SELECT '1'
              FROM giac_acct_entries
             WHERE gacc_tran_id    = p_gacc_tran_id
               AND generation_type = p_var_gen_type
        ) LOOP
            v_acct_entry := '1';
            EXIT;
        END LOOP;
        
        IF v_acct_entry = '1' THEN
            DELETE FROM giac_acct_entries
             WHERE gacc_tran_id    = p_gacc_tran_id
               AND generation_type = p_var_gen_type;
        END IF;
        -- end of AEG_Delete_Acct_Entries
        
        DELETE FROM giac_taxes_wheld
            WHERE gacc_tran_id = p_gacc_tran_id;
            
        var_v_item_no := 1;    
            
        FOR c IN (SELECT DISTINCT a.claim_id, a.advice_id, a.convert_rate,
                         a.payee_class_cd, a.payee_cd, d.iss_cd dsp_iss_cd,
                         a.transaction_type                                 --benjo 02.29.2016 SR-5303
                    FROM giac_direct_claim_payts a, gicl_advice d
                   WHERE gacc_tran_id = p_gacc_tran_id
                     AND d.claim_id = a.claim_id
                      AND d.advice_id = a.advice_id)
        LOOP
            giac_acct_entries_pkg.ins_updt_acct_entries_giacs017(
                p_gacc_tran_id, p_gacc_branch_cd, p_gacc_fund_cd, 
                c.claim_id, c.advice_id, c.payee_class_cd, c.payee_cd,
                p_var_gen_type, p_user_id);
            
            GIAC_INW_CLAIM_PAYTS_PKG.insert_into_giac_taxes_wheld(c.claim_id, c.advice_id,
                                       c.payee_class_cd, c.payee_cd,
                                       p_gacc_tran_id, c.dsp_iss_cd,
                                       c.convert_rate, c.transaction_type, p_module_name, --benjo 02.29.2016 SR-5303
                                       var_v_item_no, p_message);
        END LOOP;
    END giacs017_post_forms_commit;
END giac_direct_claim_payts_pkg;
/


