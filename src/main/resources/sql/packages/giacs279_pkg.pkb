CREATE OR REPLACE PACKAGE BODY CPI.GIACS279_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   07.04.2013
     ** Referenced By:  GAICS279 - Statament of Account - Losses Recoverable
     **/
    
    PROCEDURE get_initial_values(
        p_user          IN OUT  giac_lossrec_soa_ext_param.USER_ID%type,
        p_extract_date  OUT     giac_lossrec_soa_ext_param.EXTRACT_DATE%type,
        p_as_of_date    OUT     VARCHAR2,
        p_cut_off_date  OUT     VARCHAR2,
        p_ri_cd         OUT     giac_lossrec_soa_ext_param.RI_CD%type,
        p_line_cd       OUT     giac_lossrec_soa_ext_param.LINE_CD%type,
        p_clm_payt_tag  OUT     giac_lossrec_soa_ext_param.CLM_PAYT_TAG%type,
        p_ri_name       OUT     giis_reinsurer.RI_NAME%type,
        p_line_name     OUT     giis_line.LINE_NAME%type
    )
    AS
    BEGIN
        FOR i IN (SELECT user_id, extract_date,
                         as_of_date, cut_off_date, 
                         ri_cd, line_cd, 
                         clm_payt_tag              
                    FROM giac_lossrec_soa_ext_param
                   WHERE user_id = P_USER)
        LOOP
            p_user          := i.user_id;
            p_extract_date  := i.extract_date;
            p_as_of_date    := TO_CHAR(i.as_of_date, 'MM-DD-RRRR');
            p_cut_off_date  := TO_CHAR(i.cut_off_date, 'MM-DD-RRRR');
            p_ri_cd         := i.ri_cd;
            p_line_cd       := i.line_cd;
            p_clm_payt_tag  := i.clm_payt_tag;
        END LOOP;
        
        FOR d IN (SELECT ri_name
                    FROM giis_reinsurer
                   WHERE 1=1
                     AND ri_cd = p_ri_cd)
        LOOP
            p_ri_name := d.ri_name;	
        END LOOP;

        FOR e IN (SELECT line_name
                    FROM giis_line
                   WHERE 1=1
                     AND line_cd = p_line_cd)
        LOOP
            p_line_name := e.line_name;	
        END LOOP;
        
    END get_initial_values;   
    
    
    PROCEDURE check_dates(
        p_user          IN  giac_loss_rec_soa_ext.USER_ID%type,
        p_btn           IN  VARCHAR2,
        p_as_of_date    OUT VARCHAR2,
        p_cut_off_date  OUT VARCHAR2
    )
    AS
    BEGIN
        IF p_btn = 'extract' THEN
            FOR dates IN(SELECT as_of_date, cut_off_date
                           FROM giac_lossrec_soa_ext_param
                          WHERE 1=1
                            AND user_id = P_USER)
            LOOP
                p_as_of_date    := TO_CHAR(dates.as_of_date, 'MM-DD-RRRR');
                p_cut_off_date  := TO_CHAR(dates.cut_off_date, 'MM-DD-RRRR');
            END LOOP;	
        ELSIF p_btn = 'print' THEN
            FOR dates IN(SELECT as_of_date, cut_off_date
                           FROM giac_loss_rec_soa_ext
                          WHERE 1=1
                            AND user_id = P_USER
                            AND amount_due <> 0)
            LOOP
                p_as_of_date    := TO_CHAR(dates.as_of_date, 'MM-DD-RRRR');
                p_cut_off_date  := TO_CHAR(dates.cut_off_date, 'MM-DD-RRRR');
            END LOOP;	
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_as_of_date    := null;
            p_cut_off_date  := null;
    END check_dates;


    /** Description: get values from different tables
     **              then store it in giac_loss_rec_soa_ext
     */

    PROCEDURE extract_table_old( --benjo 12.03.2015 UCPBGEN-SR-20083 replaced from EXTRACT_TABLE -> EXTRACT_TABLE_OLD
        p_as_of_date        IN  gicl_advs_fla.FLA_DATE%type,
        p_cut_off_date      IN  giac_acctrans.TRAN_DATE%type,
        p_ri_cd             IN  giis_reinsurer.RI_CD%type,
        p_line_cd           IN  giis_line.LINE_CD%type,
        p_payee_type        IN  gicl_advs_fla_type.PAYEE_TYPE%type,
        p_chk_claims        IN  VARCHAR2,
        p_chk_aging         IN  VARCHAR2,
        p_user              IN  giac_loss_rec_soa_ext.USER_ID%type,
        p_msg               OUT VARCHAR2
    )
    IS
        v_count             NUMBER;
        v_loss_shr_amt      gicl_advs_fla_type.loss_shr_amt%TYPE; 
        v_exp_shr_amt       gicl_advs_fla_type.exp_shr_amt%TYPE;
        v_collection_amt    giac_loss_ri_collns.collection_amt%TYPE;
        v_amount_due        giac_loss_rec_soa_ext.amount_due%TYPE;
        v_days              NUMBER;
        v_column_no         NUMBER;
        v_currency_cd       giac_loss_rec_soa_ext.currency_cd%TYPE;
        v_convert_rate      giac_loss_rec_soa_ext.convert_rate%TYPE;
        v_orig_curr_cd      giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
        v_orig_curr_rate    giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
        --v_amt_convert      giac_loss_rec_soa_ext.amount_due%TYPE;
        v_payee_type1       VARCHAR2(1) ;
        v_payee_type2       VARCHAR2(1) ;
    BEGIN    
        
        DELETE FROM giac_loss_rec_soa_ext
         WHERE user_id = P_USER;

        DELETE FROM giac_lossrec_soa_ext_param 
         WHERE user_id = P_USER;

        --FORMS_DDL('commit');

        IF P_PAYEE_TYPE = 'B' THEN --NESTOR
            v_payee_type1 := 'L';
            v_payee_type2 := 'E';
        END IF;              


        /*--with_claim_payments checked--*/
        IF p_chk_claims = 'Y' THEN  
            FOR v IN (SELECT a3.ri_cd, a3.ri_name, 
                             a4.line_cd, a4.line_name, 
                             a1.claim_id, a1.adv_fla_id,
                             a5.line_cd||'-'||a5.subline_cd||'-'||a5.iss_cd||'-'||ltrim(to_char(a5.clm_yy, '09'))||'-'||ltrim(to_char(a5.clm_seq_no, '0999999')) claim_no, 
                             a1.fla_id, 
                             a1.line_cd||'-'||ltrim(to_char(a1.la_yy, '09'))||'-'||ltrim(to_char(a1.fla_seq_no, '0999999')) fla_no,
                             a5.line_cd||'-'||a5.subline_cd||'-'||a5.pol_iss_cd||'-'||ltrim(to_char(a5.issue_yy, '09'))||'-'||ltrim(to_char(a5.pol_seq_no, '0999999'))||'-'||ltrim(to_char(a5.renew_no, '09')) policy_no,   
                             a5.assd_no, a5.assured_name,
                             a1.fla_date, a2.payee_type,  
                             a2.loss_shr_amt, a2.exp_shr_amt, 
                             a1.line_cd a1_line_cd, a1.la_yy, 
                             a1.fla_seq_no        
                        FROM gicl_advs_fla a1, 
                             gicl_advs_fla_type a2,
                             giis_reinsurer a3,
                             giis_line a4, 
                             gicl_claims a5        
                       WHERE 1=1
                         AND a1.claim_id   = a2.claim_id
                         AND a1.grp_seq_no = a2.grp_seq_no
                         AND a1.fla_id     = a2.fla_id
                         AND a1.share_type = 3
                         AND nvl(a1.cancel_tag, 'N') = 'N'
                         AND a1.ri_cd      = a3.ri_cd
                         AND a1.line_cd    = a4.line_cd
                         AND a1.claim_id   = a5.claim_id
                         AND trunc(a1.fla_date) <= trunc(p_as_of_date) 
                         AND a3.ri_cd      = nvl(p_ri_cd, a3.ri_cd)
                         AND a4.line_cd    = nvl(p_line_cd, a4.line_cd)
                         AND ((a2.payee_type = p_PAYEE_TYPE) OR --NESTOR
                              (a2.payee_type = v_payee_type1) OR
                              (a2.payee_type = v_payee_type2)) 
                         AND NOT EXISTS (SELECT 1
                                           FROM gicl_advice 
                                          WHERE 1=1
                                            AND gicl_advice.claim_id = a1.claim_id
                                            AND gicl_advice.adv_fla_id = a1.adv_fla_id
                                            AND NVL(gicl_advice.advice_flag, 'N') = 'N')
                         AND (EXISTS (SELECT 1
                                        FROM giac_direct_claim_payts c1, 
                                             gicl_advice c2, 
                                             giac_acctrans c3
                                       WHERE 1=1
                                         AND c1.claim_id     = a1.claim_id
                                         AND c1.advice_id    = c2.advice_id
                                         AND c2.adv_fla_id   = a1.adv_fla_id
                                         AND c1.gacc_tran_id = c3.tran_id
                                         AND c3.tran_flag NOT IN ('D','O')
                                         AND trunc(c3.tran_date) <= trunc(p_cut_off_date) 
                         AND NOT EXISTS (SELECT 1 
                                           FROM giac_acctrans x,
                                                giac_reversals y
                                          WHERE 1=1
                                            AND x.tran_id = y.reversing_tran_id
                                            AND y.gacc_tran_id = c1.gacc_tran_id
                                            AND x.tran_flag <> 'D'))
                          OR EXISTS (SELECT 1
                                       FROM giac_inw_claim_payts c1, 
                                            gicl_advice c2, 
                                            giac_acctrans c3
                                      WHERE 1=1
                                        AND c1.claim_id = a1.claim_id
                                        AND c1.advice_id = c2.advice_id
                                        AND c2.adv_fla_id = a1.adv_fla_id
                                        AND c1.gacc_tran_id = c3.tran_id
                                        AND c3.tran_flag NOT IN ('D','O')
                                        AND trunc(c3.tran_date) <= trunc(p_cut_off_date)
                                        AND NOT EXISTS (SELECT 1 
                                                          FROM giac_acctrans x,
                                                               giac_reversals y
                                                         WHERE 1=1
                                                           AND x.tran_id = y.reversing_tran_id
                                                           AND y.gacc_tran_id = c1.gacc_tran_id
                                                           AND x.tran_flag <> 'D')))
                         AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)
            LOOP       
                --Check the currency; conversion will be done if currency_cd <> 1 (PHP)
                --cherrie 05232012
                FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate, u.orig_curr_cd
                               FROM gicl_advice u
                              WHERE 1 = 1
                                AND u.claim_id = v.claim_id
                                AND u.adv_fla_id = v.adv_fla_id)
                LOOP
                    v_currency_cd := curr.currency_cd;
                    v_convert_rate := curr.convert_rate;
                    v_orig_curr_rate := curr.orig_curr_rate;
                    v_orig_curr_cd := curr.orig_curr_cd;
                        
                    --conversion of loss_shr_amt and exp_shr_amt
                    IF curr.currency_cd <> giacp.n('CURRENCY_CD') THEN
                        v_loss_shr_amt := ROUND(NVL(v.loss_shr_amt, 0) * nvl(curr.convert_rate, 1), 2);   
                        v_exp_shr_amt  := ROUND(NVL(v.exp_shr_amt, 0) * nvl(curr.convert_rate, 1), 2);   
                    ELSE
                       v_loss_shr_amt := v.loss_shr_amt;    
                        v_exp_shr_amt  := v.exp_shr_amt;
                    END IF;
                END LOOP;   
                --end cherrie
                
                /*-----check data exist in giac_loss_ri_collns-----*/
                FOR exist IN(SELECT sum(b1.collection_amt) collection_amt
                               FROM giac_loss_ri_collns b1,
                                    giac_acctrans b2
                              WHERE 1=1
                                AND b1.claim_id    = v.claim_id
                                AND b1.a180_ri_cd  = v.ri_cd
                                AND b1.e150_line_cd= v.a1_line_cd
                                AND b1.share_type     = 3                                        
                                AND b1.e150_la_yy  = v.la_yy
                                AND b1.e150_fla_seq_no = v.fla_seq_no
                                AND b1.payee_type  = v.payee_type      
                                AND b1.gacc_tran_id= b2.tran_id
                                AND b2.tran_flag      <> 'D'        
                                AND trunc(b2.tran_date) <= trunc(p_cut_off_date)    
                                AND NOT EXISTS (SELECT 1
                                                  FROM giac_acctrans x, giac_reversals y
                                                 WHERE 1=1
                                                   AND x.tran_id = y.reversing_tran_id
                                                   AND y.gacc_tran_id = b1.gacc_tran_id
                                                   AND x.tran_flag <> 'D'))
                LOOP
                    v_collection_amt := exist.collection_amt; 
                    /*-----end check loop-----*/
                        
                    IF v_collection_amt IS NOT NULL THEN   
                        /*-----return amount_due = loss/exp - colletion_amt  
                        **if data exist in giac_loss_ri_collns-----*/           
                        IF v.payee_type = 'L' THEN 
                            v_amount_due := ((v_loss_shr_amt) - (v_collection_amt)); --change v.loss_shr_amt to v_shr_amt| cherrie | 05242012    
                        ELSIF v.payee_type = 'E' THEN 
                            v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));  --change v.exp_shr_amt to v_shr_amt| cherrie | 05242012
                        END IF; --end if        
                          
                    ELSE
                        /*-----return amount_due = loss or exp  
                        **if data not exist in giac_loss_ri_collns-----*/  
                        IF v.payee_type = 'L' THEN 
                            v_amount_due   := v_loss_shr_amt; --change v.loss_shr_amt to v_shr_amt| cherrie | 05242012
                        ELSIF v.payee_type = 'E' THEN 
                            v_amount_due   := v_exp_shr_amt;  --change v.exp_shr_amt to v_shr_amt| cherrie | 05242012
                        END IF; --end if                      
                    END IF; --end if v_collection_amt = null/not null  
                  
                END LOOP; --end loop data exist im giac_loss_ri_collns   
                 
                 --comment out by cherrie | 05232012
                 --moved this code before FOR exist LOOp
                 --081406 rochelle
                 --start: get currency from gicl_advice
                  /*FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate, u.orig_curr_cd
                              FROM gicl_advice u
                              WHERE 1 = 1
                              AND u.claim_id = v.claim_id
                              AND u.adv_fla_id = v.adv_fla_id)
                  LOOP
                      v_currency_cd := curr.currency_cd;
                      v_convert_rate := curr.convert_rate;
                      v_orig_curr_rate := curr.orig_curr_rate;
                      v_orig_curr_cd := curr.orig_curr_cd;
                  END LOOP;*/
                  --end: currency
                  --end cherrie 05232012
                 
                 /* --comment start
                 -----start:convert v_amount_due depending on its currency----- 
                  FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate
                              FROM gicl_advice u
                              WHERE 1 = 1
                              AND u.claim_id = v.claim_id
                              AND u.adv_fla_id = v.adv_fla_id)
                  LOOP
                      v_currency_cd := curr.currency_cd;
                      v_convert_rate := curr.convert_rate;
                      v_orig_curr_rate := curr.orig_curr_rate;
                     
                     -----start:if currency_cd = giacp.n('CURRENCY_CD')-----
                       IF v_currency_cd = giacp.n('CURRENCY_CD') THEN 
                           v_amt_convert := v_amount_due * nvl(v_orig_curr_rate, 1);                       
                       ELSIF v_currency_cd <> giacp.n('CURRENCY_CD') THEN 
                           v_amt_convert := v_amount_due * nvl(v_convert_rate, 1);
                       END IF;
                     -----end if:currency_cd = giacp.n('CURRENCY_CD')-----         
                                 
                  END LOOP;           
                 -----end loop:convert v_amount_due depending on its currency-----
                 */ --comment end
                 /* --comment 0814 monday
                 --start CONVERT RATE
                 IF v.orig_curr_rate = giacp.n('CURRENCY_CD') THEN 
                       v_convert_rate := v.orig_curr_rate;
                       
                 ELSIF v.orig_curr_rate <> giacp.n('CURRENCY_CD') THEN 
                    v_convert_rate := v.convert_rate;
                 END IF;
                   
                 --end CONVERT RATE
                 */
                /*-----convert into # of days difference
                ** of fla_date and p_cut_off_date-----*/     
                v_days := trunc(v.fla_date) - trunc(p_cut_off_date);  
                 
                /*-----get value of column_no from giis_report_aging-----*/           
                SELECT column_no
                  INTO v_column_no
                  FROM giis_report_aging
                 WHERE report_id = 'GIACR279A'
                   AND min_days <= abs(v_days)
                   AND max_days >= abs(v_days)
                   AND ROWNUM = 1; --benjo 11.05.2015 GENQA-SR-5133
                                      
                /*-----insert values in giac_loss_rec_soa_ext-----*/ 
                INSERT INTO giac_loss_rec_soa_ext (ri_cd, ri_name, 
                                                   line_cd, line_name, 
                                                   claim_id, claim_no, 
                                                   fla_id, fla_no, 
                                                   policy_no, 
                                                   assd_no, assd_name,
                                                   fla_date, as_of_date, cut_off_date,
                                                   payee_type, amount_due, column_no, 
                                                   user_id, extract_date, 
                                                   currency_cd, convert_rate, 
                                                   orig_curr_cd, orig_curr_rate)                                                                                                                                                         
                                            VALUES (v.ri_cd, v.ri_name, 
                                                    v.line_cd, v.line_name, 
                                                    v.claim_id, v.claim_no, 
                                                    v.fla_id, v.fla_no,
                                                    v.policy_no, 
                                                    v.assd_no, v.assured_name,
                                                    v.fla_date, p_as_of_date, p_cut_off_date, 
                                                    v.payee_type, v_amount_due, v_column_no,
                                                    P_USER, SYSDATE, 
                                                    nvl(v_currency_cd, 1), nvl(v_convert_rate, 1), 
                                                    nvl(v_orig_curr_cd, 1), nvl(v_orig_curr_rate, 1));
                                                                  
                                                                  
            END LOOP; --end loop with_claim_payments checked

        /*--with_claim_payments unchecked--*/                  
        ELSIF p_chk_claims = 'N' THEN 
            FOR v IN (SELECT a3.ri_cd, a3.ri_name, 
                             a4.line_cd, a4.line_name, 
                             a1.claim_id, a1.adv_fla_id, 
                             a5.line_cd||'-'||a5.subline_cd||'-'||a5.iss_cd||'-'||ltrim(to_char(a5.clm_yy, '09'))||'-'||ltrim(to_char(a5.clm_seq_no, '0999999')) claim_no, 
                             a1.fla_id, 
                             a1.line_cd||'-'||ltrim(to_char(a1.la_yy, '09'))||'-'||ltrim(to_char(a1.fla_seq_no, '0999999')) fla_no,
                             a5.line_cd||'-'||a5.subline_cd||'-'||a5.pol_iss_cd||'-'||ltrim(to_char(a5.issue_yy, '09'))||'-'||ltrim(to_char(a5.pol_seq_no, '0999999'))||'-'||ltrim(to_char(a5.renew_no, '09')) policy_no,   
                             a5.assd_no, a5.assured_name,
                             a1.fla_date, a2.payee_type,  
                             a2.loss_shr_amt, a2.exp_shr_amt, 
                             a1.line_cd a1_line_cd, a1.la_yy, 
                             a1.fla_seq_no
                        FROM gicl_advs_fla a1, 
                             gicl_advs_fla_type a2,
                             giis_reinsurer a3,
                             giis_line a4, 
                             gicl_claims a5         
                       WHERE 1=1
                         AND a1.claim_id   = a2.claim_id
                         AND a1.grp_seq_no = a2.grp_seq_no
                         AND a1.fla_id     = a2.fla_id
                         AND a1.share_type = 3
                         AND nvl(a1.cancel_tag, 'N') = 'N'
                         AND a1.ri_cd      = a3.ri_cd
                         AND a1.line_cd    = a4.line_cd
                         AND a1.claim_id   = a5.claim_id
                         AND trunc(a1.fla_date) <= trunc(p_as_of_date) 
                         AND a3.ri_cd      = nvl(p_ri_cd, a3.ri_cd)
                         AND a4.line_cd    = nvl(p_line_cd, a4.line_cd)
                         AND ((a2.payee_type = p_PAYEE_TYPE) OR --NESTOR
                              (a2.payee_type = v_payee_type1) OR
                              (a2.payee_type = v_payee_type2))
                         AND NOT EXISTS (SELECT 1
                                           FROM gicl_advice 
                                          WHERE 1=1
                                            AND gicl_advice.claim_id = a1.claim_id
                                            AND gicl_advice.adv_fla_id = a1.adv_fla_id
                                            AND nvl(gicl_advice.advice_flag, 'N') = 'N')
                         AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)       
            LOOP       
                --Check the currency; conversion will be done if currency_cd <> 1 (PHP)
                --cherrie 05232012
                FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate, u.orig_curr_cd
                               FROM gicl_advice u
                              WHERE 1 = 1
                                AND u.claim_id = v.claim_id
                                AND u.adv_fla_id = v.adv_fla_id)
                LOOP
                    v_currency_cd := curr.currency_cd;
                    v_convert_rate := curr.convert_rate;
                    v_orig_curr_rate := curr.orig_curr_rate;
                    v_orig_curr_cd := curr.orig_curr_cd;
                        
                    IF curr.currency_cd <> giacp.n('CURRENCY_CD') THEN
                        v_loss_shr_amt := ROUND(NVL(v.loss_shr_amt, 0) * nvl(curr.convert_rate, 1), 2);   
                        v_exp_shr_amt  := ROUND(NVL(v.exp_shr_amt, 0) * nvl(curr.convert_rate, 1), 2);           
                    ELSE
                        v_loss_shr_amt := v.loss_shr_amt;    
                        v_exp_shr_amt  := v.exp_shr_amt;
                    END IF;        
                END LOOP;   
                --end cherrie
                    
                /*-----check data exist in giac_loss_ri_collns-----*/
                FOR exist IN(SELECT sum(b1.collection_amt) collection_amt
                               FROM giac_loss_ri_collns b1,
                                    giac_acctrans b2
                              WHERE 1=1
                                AND b1.claim_id    = v.claim_id
                                AND b1.a180_ri_cd  = v.ri_cd
                                AND b1.e150_line_cd= v.a1_line_cd
                                AND b1.share_type  = 3                                        
                                AND b1.e150_la_yy  = v.la_yy
                                AND b1.e150_fla_seq_no = v.fla_seq_no
                                AND b1.payee_type   = v.payee_type      
                                AND b1.gacc_tran_id = b2.tran_id
                                AND b2.tran_flag    <> 'D'        
                                AND trunc(b2.tran_date) <= trunc(p_cut_off_date)    
                                AND NOT EXISTS (SELECT 1
                                                  FROM giac_acctrans x, giac_reversals y
                                                 WHERE 1=1
                                                   AND x.tran_id = y.reversing_tran_id
                                                   AND y.gacc_tran_id = b1.gacc_tran_id
                                                   AND x.tran_flag <> 'D'))
                LOOP
                    v_collection_amt := exist.collection_amt; 
                         /*-----end check loop-----*/
                            
                    IF v_collection_amt IS NOT NULL THEN   
                        /*-----return amount_due = loss/exp - colletion_amt  
                        **if data exist in giac_loss_ri_collns-----*/           
                        IF v.payee_type = 'L' THEN 
                            v_amount_due := ((v_loss_shr_amt) - (v_collection_amt)); --change v.loss_shr_amt to v_shr_amt| cherrie | 05242012    
                        ELSIF v.payee_type = 'E' THEN 
                            v_amount_due := ((v_exp_shr_amt) - (v_collection_amt)); --change v.exp_shr_amt to v_shr_amt| cherrie | 05242012
                        END IF; --end if              
                    ELSE
                        /*-----return amount_due = loss or exp  
                        **if data not exist in giac_loss_ri_collns-----*/  
                        IF v.payee_type = 'L' THEN 
                            v_amount_due   := v_loss_shr_amt;  --change v.loss_shr_amt to v_shr_amt| cherrie | 05242012 -- changed from v_exp_shr_amt : shan 11.21.2014
                        ELSIF v.payee_type = 'E' THEN 
                            v_amount_due   := v_exp_shr_amt;  --change v.exp_shr_amt to v_shr_amt| cherrie | 05242012
                        END IF; --end if
                    END IF; --end if v_collection_amt = null/not null 
                END LOOP; --end loop data exist in giac_loss_ri_collns   
                      
                  --commented out by cherrie | 05232012
                  --moved this code before FOR exist LOOp 
                  --081406 rochelle                    
                  --start: get currency from gicl_advice
                  /*FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate, u.orig_curr_cd
                               FROM gicl_advice u
                               WHERE 1 = 1
                               AND u.claim_id = v.claim_id
                               AND u.adv_fla_id = v.adv_fla_id)
                  LOOP
                      v_currency_cd := curr.currency_cd;
                      v_convert_rate := curr.convert_rate;
                      v_orig_curr_rate := curr.orig_curr_rate;
                      v_orig_curr_cd := curr.orig_curr_cd;
                  END LOOP;*/
                  --end: currency
                  --end cherrie 05232012
            
                  /* --comment start
                 -----start:convert v_amount_due depending on its currency----- 
                  FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate
                              FROM gicl_advice u
                              WHERE 1 = 1
                              AND u.claim_id = v.claim_id
                              AND u.adv_fla_id = v.adv_fla_id)
                  LOOP
                      v_currency_cd := curr.currency_cd;
                      v_convert_rate := curr.convert_rate;
                      v_orig_curr_rate := curr.orig_curr_rate;
                         
                     -----start:if currency_cd = giacp.n('CURRENCY_CD')-----
                       IF v_currency_cd = giacp.n('CURRENCY_CD') THEN 
                           v_amt_convert := v_amount_due * nvl(v_orig_curr_rate, 1);                       
                       ELSIF v_currency_cd <> giacp.n('CURRENCY_CD') THEN 
                           v_amt_convert := v_amount_due * nvl(v_convert_rate, 1);
                       END IF;
                     -----end if:currency_cd = giacp.n('CURRENCY_CD')-----         
                                     
                  END LOOP;           
                 -----end loop:convert v_amount_due depending on its currency-----
                 */ --comment end
                 /* --comment 0814
                 --start CONVERT RATE
                 IF v.orig_curr_rate = giacp.n('CURRENCY_CD') THEN 
                       v_convert_rate := v.orig_curr_rate;
                           
                 ELSIF v.orig_curr_rate <> giacp.n('CURRENCY_CD') THEN 
                    v_convert_rate := v.convert_rate;
                 END IF;
                       
                --end CONVERT RATE
                */
                                                           
                /*-----convert into # of days difference
                ** of fla_date and p_cut_off_date-----*/     
                v_days := trunc(v.fla_date) - trunc(p_cut_off_date);  
                     
                /*-----get value of column_no from giis_report_aging-----*/           
                SELECT column_no
                  INTO v_column_no
                  FROM giis_report_aging
                 WHERE report_id = 'GIACR279A'
                   AND min_days <= abs(v_days)
                   AND max_days >= abs(v_days)
                   AND ROWNUM = 1; --benjo 11.05.2015 GENQA-SR-5133

                /*-----insert values in giac_loss_rec_soa_ext-----*/ 
                     
                INSERT INTO giac_loss_rec_soa_ext (ri_cd, ri_name, 
                                                   line_cd, line_name, 
                                                   claim_id, claim_no, 
                                                   fla_id, fla_no, 
                                                   policy_no, 
                                                   assd_no, assd_name,
                                                   fla_date, as_of_date, cut_off_date,
                                                   payee_type, amount_due, column_no, 
                                                   user_id, extract_date,
                                                   currency_cd, convert_rate, 
                                                   orig_curr_cd, orig_curr_rate)                                                                                                                                                                      
                                            VALUES (nvl(v.ri_cd,0), nvl(v.ri_name,' '), 
                                                    nvl(v.line_cd,' '),nvl(v.line_name, ' '),
                                                    nvl(v.claim_id,0),nvl( v.claim_no, ' '),
                                                    nvl(v.fla_id, 0),nvl(v.fla_no,' '),
                                                    nvl(v.policy_no, ' '),
                                                    nvl(v.assd_no,0 ), nvl(v.assured_name,' '),
                                                    v.fla_date, p_as_of_date, p_cut_off_date, 
                                                    v.payee_type, nvl(v_amount_due,0),nvl( v_column_no,0),
                                                    P_USER, SYSDATE, 
                                                    nvl(v_currency_cd, 1), nvl(v_convert_rate, 1), 
                                                    nvl(v_orig_curr_cd, 1), nvl(v_orig_curr_rate, 1));
                                                                                                          
            END LOOP; --end loop with_claim_payments unchecked
              
        END IF; --end main if

        /*PARAM_TABLE; /*call param_table procedure
                      **to insert parameters 
                      **in giac_lossrec_soa_ext_param*/ 
        
        -- ** =========== PARAM_TABLE =============== ** -- 
        INSERT INTO giac_lossrec_soa_ext_param (user_id, extract_date, 
	                        					as_of_date, cut_off_date, 
	        									ri_cd, line_cd,										
	        				    				clm_payt_tag)
                                        VALUES (P_USER, SYSDATE, 
                                                p_as_of_date, p_cut_off_date, 
                                                p_ri_cd, p_line_cd,
                                                p_chk_claims);
        -- ** ======================================= ** --
        
                                        
        --FORMS_DDL('commit');

        /*-----count extracted records including with 
        **-----amount_due = 0 for current user
        **-----but in reports(giacr279, giacr279a)
        **-----return only records with amount_due <> 0-----*/
        SELECT count(*) 
          INTO v_count
          FROM giac_loss_rec_soa_ext
         WHERE as_of_date = p_as_of_date
           AND cut_off_date = p_cut_off_date
           AND user_id = P_USER;
          --AND amount_due <> 0;
         
        /* IF v_count = 0 THEN
            p_msg := 'Extraction finished. No records extracted.';     

        ELSE   
            IF v_count <= 1 THEN 
                p_msg := 'Extraction finished. '||v_count||''||' record extracted.';
            ELSE
                p_msg := 'Extraction finished. '||v_count||''||' records extracted.';
            END IF;
        END IF;   
        */
      
        p_msg := 'Extraction finished. '||v_count||''||' record extracted.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF p_chk_aging = 1 THEN 
                p_msg := 'No records found in GIIS_REPORT_AGING for report ID GIACR279A.';                      
            ELSIF p_chk_aging = 0 THEN       
                p_msg := 'No records found in GIIS_REPORT_AGING for report ID GIACR279.';
            END IF;    
                 
        --clear_message;
        
    END EXTRACT_TABLE_OLD;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table (
       p_as_of_date     IN       gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   IN       giac_acctrans.tran_date%TYPE,
       p_ri_cd          IN       giis_reinsurer.ri_cd%TYPE,
       p_line_cd        IN       giis_line.line_cd%TYPE,
       p_payee_type     IN       gicl_advs_fla_type.payee_type%TYPE,
       p_chk_claims     IN       VARCHAR2,
       p_chk_aging      IN       VARCHAR2,
       p_fc_param       IN       VARCHAR2,
       p_tp_param       IN       VARCHAR2,
       p_user           IN       giac_loss_rec_soa_ext.user_id%TYPE,
       p_msg            OUT      VARCHAR2
    )
    IS
       v_count   NUMBER;
    BEGIN
       DELETE FROM giac_loss_rec_soa_ext
             WHERE user_id = p_user;

       DELETE FROM giac_lossrec_soa_ext_param
             WHERE user_id = p_user;

       IF p_chk_claims = 'Y'
       THEN
          IF p_fc_param = 'F'
          THEN
             IF p_tp_param = 'T'
             THEN
                giacs279_pkg.extract_table_ft (p_as_of_date, p_cut_off_date, p_ri_cd, p_line_cd, p_payee_type, p_user);
             ELSIF p_tp_param = 'P'
             THEN
                giacs279_pkg.extract_table_fp (p_as_of_date, p_cut_off_date, p_ri_cd, p_line_cd, p_payee_type, p_user);
             END IF;
          ELSIF p_fc_param = 'C'
          THEN
             IF p_tp_param = 'T'
             THEN
                giacs279_pkg.extract_table_ct (p_as_of_date, p_cut_off_date, p_ri_cd, p_line_cd, p_payee_type, p_user);
             ELSIF p_tp_param = 'P'
             THEN
                giacs279_pkg.extract_table_cp (p_as_of_date, p_cut_off_date, p_ri_cd, p_line_cd, p_payee_type, p_user);
             END IF;
          END IF;
       ELSIF p_chk_claims = 'N'
       THEN
          IF p_tp_param = 'T'
          THEN
             giacs279_pkg.extract_table_ft_nc (p_as_of_date, p_cut_off_date, p_ri_cd, p_line_cd, p_payee_type, p_user);
          ELSIF p_tp_param = 'P'
          THEN
             giacs279_pkg.extract_table_fp_nc (p_as_of_date, p_cut_off_date, p_ri_cd, p_line_cd, p_payee_type, p_user);
          END IF;
       END IF;

       INSERT INTO giac_lossrec_soa_ext_param
                   (user_id, extract_date, as_of_date, cut_off_date, ri_cd,
                    line_cd, clm_payt_tag
                   )
            VALUES (p_user, SYSDATE, p_as_of_date, p_cut_off_date, p_ri_cd,
                    p_line_cd, p_chk_claims
                   );

       COMMIT;

       SELECT COUNT (*)
         INTO v_count
         FROM giac_loss_rec_soa_ext
        WHERE as_of_date = p_as_of_date
          AND cut_off_date = p_cut_off_date
          AND user_id = p_user;

       IF v_count = 0
       THEN
          p_msg := 'No records extracted.';
       ELSE
          IF v_count <= 1
          THEN
             p_msg := 'Extraction finished! ' || v_count || ' record extracted.';
          ELSE
             p_msg := 'Extraction finished! ' || v_count || ' records extracted.';
          END IF;
       END IF;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          IF p_chk_aging = 1
          THEN
             p_msg :=
                'No records found in GIIS _REPORT_AGING for report ID GIACR279A.';
          ELSIF p_chk_aging = 0
          THEN
             p_msg :=
                  'No records found in GIIS_REPORT_AGING for report ID GIACR279.';
          END IF;
    END;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_ft (
       p_as_of_date     gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   giac_acctrans.tran_date%TYPE,
       p_ri_cd          giis_reinsurer.ri_cd%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_payee_type     gicl_advs_fla_type.payee_type%TYPE,
       p_user           giac_loss_rec_soa_ext.user_id%TYPE
    )
    IS
       v_loss_shr_amt     gicl_advs_fla_type.loss_shr_amt%TYPE;
       v_exp_shr_amt      gicl_advs_fla_type.exp_shr_amt%TYPE;
       v_collection_amt   giac_loss_ri_collns.collection_amt%TYPE;
       v_amount_due       giac_loss_rec_soa_ext.amount_due%TYPE;
       v_days             NUMBER;
       v_column_no        NUMBER;
       v_payee_type1      VARCHAR2 (1);
       v_payee_type2      VARCHAR2 (1);
       v_currency_cd      giac_loss_rec_soa_ext.currency_cd%TYPE;
       v_convert_rate     giac_loss_rec_soa_ext.convert_rate%TYPE;
       v_orig_curr_cd     giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
       v_orig_curr_rate   giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
    BEGIN
       IF p_payee_type = 'B'
       THEN
          v_payee_type1 := 'L';
          v_payee_type2 := 'E';
       END IF;

       FOR v IN
          (SELECT a3.ri_cd, a3.ri_name, a4.line_cd, a4.line_name, a1.claim_id,
                  a1.adv_fla_id,
                     a5.line_cd
                  || '-'
                  || a5.subline_cd
                  || '-'
                  || a5.iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')) claim_no,
                  a1.fla_id,
                     a1.line_cd
                  || '-'
                  || LTRIM (TO_CHAR (a1.la_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')) fla_no,
                     a5.line_cd
                  || '-'
                  || a5.subline_cd
                  || '-'
                  || a5.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.renew_no, '09')) policy_no,
                  a5.assd_no, a5.assured_name, a1.fla_date, a2.payee_type,
                  a2.loss_shr_amt, a2.exp_shr_amt, a1.line_cd a1_line_cd,
                  a1.la_yy, a1.fla_seq_no
             FROM gicl_advs_fla a1,
                  gicl_advs_fla_type a2,
                  giis_reinsurer a3,
                  giis_line a4,
                  gicl_claims a5
            WHERE 1 = 1
              AND a1.claim_id = a2.claim_id
              AND a1.grp_seq_no = a2.grp_seq_no
              AND a1.fla_id = a2.fla_id
              AND a1.share_type = 3
              AND NVL (a1.cancel_tag, 'N') = 'N'
              AND a1.ri_cd = a3.ri_cd
              AND a1.line_cd = a4.line_cd
              AND a1.claim_id = a5.claim_id
              AND TRUNC (a1.fla_date) <= TRUNC (p_as_of_date)
              AND a3.ri_cd = NVL (p_ri_cd, a3.ri_cd)
              AND a4.line_cd = NVL (p_line_cd, a4.line_cd)
              AND (   (a2.payee_type = p_payee_type)
                   OR (a2.payee_type = v_payee_type1)
                   OR (a2.payee_type = v_payee_type2)
                  )
              AND NOT EXISTS (
                     SELECT 1
                       FROM gicl_advice
                      WHERE 1 = 1
                        AND gicl_advice.claim_id = a1.claim_id
                        AND gicl_advice.adv_fla_id = a1.adv_fla_id
                        AND NVL (gicl_advice.advice_flag, 'N') = 'N')
              AND (   EXISTS (
                         SELECT 1
                           FROM giac_direct_claim_payts c1,
                                gicl_advice c2,
                                giac_acctrans c3
                          WHERE 1 = 1
                            AND c1.claim_id = a1.claim_id
                            AND c1.advice_id = c2.advice_id
                            AND c2.adv_fla_id = a1.adv_fla_id
                            AND c1.gacc_tran_id = c3.tran_id
                            AND c3.tran_flag NOT IN ('D', 'O')
                            AND TRUNC (c3.tran_date) <= TRUNC (p_cut_off_date)
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE 1 = 1
                                      AND x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = c1.gacc_tran_id
                                      AND x.tran_flag <> 'D'))
                   OR EXISTS (
                         SELECT 1
                           FROM giac_inw_claim_payts c1,
                                gicl_advice c2,
                                giac_acctrans c3
                          WHERE 1 = 1
                            AND c1.claim_id = a1.claim_id
                            AND c1.advice_id = c2.advice_id
                            AND c2.adv_fla_id = a1.adv_fla_id
                            AND c1.gacc_tran_id = c3.tran_id
                            AND c3.tran_flag NOT IN ('D', 'O')
                            AND TRUNC (c3.tran_date) <= TRUNC (p_cut_off_date)
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE 1 = 1
                                      AND x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = c1.gacc_tran_id
                                      AND x.tran_flag <> 'D'))
                  )
                  AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)
       LOOP
          FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate,
                              u.orig_curr_cd
                         FROM gicl_advice u
                        WHERE 1 = 1
                          AND u.claim_id = v.claim_id
                          AND u.adv_fla_id = v.adv_fla_id)
          LOOP
             v_currency_cd := curr.currency_cd;
             v_convert_rate := curr.convert_rate;
             v_orig_curr_rate := curr.orig_curr_rate;
             v_orig_curr_cd := curr.orig_curr_cd;

             IF curr.currency_cd <> giacp.n ('CURRENCY_CD')
             THEN
                v_loss_shr_amt :=
                   ROUND (NVL (v.loss_shr_amt, 0) * NVL (curr.convert_rate, 1),
                          2);
                v_exp_shr_amt :=
                    ROUND (NVL (v.exp_shr_amt, 0) * NVL (curr.convert_rate, 1),
                           2);
             ELSE
                v_loss_shr_amt := v.loss_shr_amt;
                v_exp_shr_amt := v.exp_shr_amt;
             END IF;
          END LOOP;

          FOR exist IN (SELECT SUM (b1.collection_amt) collection_amt
                          FROM giac_loss_ri_collns b1, giac_acctrans b2
                         WHERE 1 = 1
                           AND b1.claim_id = v.claim_id
                           AND b1.a180_ri_cd = v.ri_cd
                           AND b1.e150_line_cd = v.a1_line_cd
                           AND b1.share_type = 3
                           AND b1.e150_la_yy = v.la_yy
                           AND b1.e150_fla_seq_no = v.fla_seq_no
                           AND b1.payee_type = v.payee_type
                           AND b1.gacc_tran_id = b2.tran_id
                           AND b2.tran_flag <> 'D'
                           AND TRUNC (b2.tran_date) <= TRUNC (p_cut_off_date)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giac_acctrans x, giac_reversals y
                                   WHERE 1 = 1
                                     AND x.tran_id = y.reversing_tran_id
                                     AND y.gacc_tran_id = b1.gacc_tran_id
                                     AND x.tran_flag <> 'D'))
          LOOP
             v_collection_amt := exist.collection_amt;

             IF v_collection_amt IS NOT NULL
             THEN
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := ((v_loss_shr_amt) - (v_collection_amt));
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));
                END IF;
             ELSE
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := v_loss_shr_amt;
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := v_exp_shr_amt;
                END IF;
             END IF;

             v_days := TRUNC (v.fla_date) - TRUNC (p_cut_off_date);

             SELECT column_no
               INTO v_column_no
               FROM giis_report_aging
              WHERE report_id = 'GIACR279A'
                AND min_days <= ABS (v_days)
                AND max_days >= ABS (v_days)
                AND branch_cd IN (
                              SELECT b.grp_iss_cd
                                FROM giis_users a, giis_user_grp_hdr b
                               WHERE a.user_grp = b.user_grp
                                     AND a.user_id = p_user);

             IF NVL (v_amount_due, 0) <> 0
             THEN
                INSERT INTO giac_loss_rec_soa_ext
                            (ri_cd, ri_name, line_cd, line_name,
                             claim_id, claim_no, fla_id, fla_no,
                             policy_no, assd_no, assd_name, fla_date,
                             as_of_date, cut_off_date, payee_type,
                             amount_due, column_no, user_id, extract_date,
                             currency_cd, convert_rate,
                             orig_curr_cd, orig_curr_rate
                            )
                     VALUES (v.ri_cd, v.ri_name, v.line_cd, v.line_name,
                             v.claim_id, v.claim_no, v.fla_id, v.fla_no,
                             v.policy_no, v.assd_no, v.assured_name, v.fla_date,
                             p_as_of_date, p_cut_off_date, v.payee_type,
                             v_amount_due, v_column_no, p_user, SYSDATE,
                             NVL (v_currency_cd, 1), NVL (v_convert_rate, 1),
                             NVL (v_orig_curr_cd, 1), NVL (v_orig_curr_rate, 1)
                            );
             END IF;
          END LOOP;
       END LOOP;
    END;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_fp (
       p_as_of_date     gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   giac_acctrans.tran_date%TYPE,
       p_ri_cd          giis_reinsurer.ri_cd%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_payee_type     gicl_advs_fla_type.payee_type%TYPE,
       p_user           giac_loss_rec_soa_ext.user_id%TYPE
    )
    IS
       v_loss_shr_amt     gicl_advs_fla_type.loss_shr_amt%TYPE;
       v_exp_shr_amt      gicl_advs_fla_type.exp_shr_amt%TYPE;
       v_collection_amt   giac_loss_ri_collns.collection_amt%TYPE;
       v_amount_due       giac_loss_rec_soa_ext.amount_due%TYPE;
       v_days             NUMBER;
       v_column_no        NUMBER;
       v_payee_type1      VARCHAR2 (1);
       v_payee_type2      VARCHAR2 (1);
       v_currency_cd      giac_loss_rec_soa_ext.currency_cd%TYPE;
       v_convert_rate     giac_loss_rec_soa_ext.convert_rate%TYPE;
       v_orig_curr_cd     giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
       v_orig_curr_rate   giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
    BEGIN
       IF p_payee_type = 'B'
       THEN
          v_payee_type1 := 'L';
          v_payee_type2 := 'E';
       END IF;

       FOR v IN
          (SELECT a3.ri_cd, a3.ri_name, a4.line_cd, a4.line_name, a1.claim_id,
                  a1.adv_fla_id,
                     a5.line_cd
                  || '-'
                  || a5.subline_cd
                  || '-'
                  || a5.iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')) claim_no,
                  a1.fla_id,
                     a1.line_cd
                  || '-'
                  || LTRIM (TO_CHAR (a1.la_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')) fla_no,
                     a5.line_cd
                  || '-'
                  || a5.subline_cd
                  || '-'
                  || a5.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.renew_no, '09')) policy_no,
                  a5.assd_no, a5.assured_name, a1.fla_date, a2.payee_type,
                  a2.loss_shr_amt, a2.exp_shr_amt, a1.line_cd a1_line_cd,
                  a1.la_yy, a1.fla_seq_no
             FROM gicl_advs_fla a1,
                  gicl_advs_fla_type a2,
                  giis_reinsurer a3,
                  giis_line a4,
                  gicl_claims a5
            WHERE 1 = 1
              AND a1.claim_id = a2.claim_id
              AND a1.grp_seq_no = a2.grp_seq_no
              AND a1.fla_id = a2.fla_id
              AND a1.share_type = 3
              AND NVL (a1.cancel_tag, 'N') = 'N'
              AND a1.ri_cd = a3.ri_cd
              AND a1.line_cd = a4.line_cd
              AND a1.claim_id = a5.claim_id
              AND TRUNC (a1.fla_date) <= TRUNC (p_as_of_date)
              AND a3.ri_cd = NVL (p_ri_cd, a3.ri_cd)
              AND a4.line_cd = NVL (p_line_cd, a4.line_cd)
              AND (   (a2.payee_type = p_payee_type)
                   OR (a2.payee_type = v_payee_type1)
                   OR (a2.payee_type = v_payee_type2)
                  )
              AND NOT EXISTS (
                     SELECT 1
                       FROM gicl_advice
                      WHERE 1 = 1
                        AND gicl_advice.claim_id = a1.claim_id
                        AND gicl_advice.adv_fla_id = a1.adv_fla_id
                        AND NVL (gicl_advice.advice_flag, 'N') = 'N')
              AND (   EXISTS (
                         SELECT 1
                           FROM giac_direct_claim_payts c1,
                                gicl_advice c2,
                                giac_acctrans c3
                          WHERE 1 = 1
                            AND c1.claim_id = a1.claim_id
                            AND c1.advice_id = c2.advice_id
                            AND c2.adv_fla_id = a1.adv_fla_id
                            AND c1.gacc_tran_id = c3.tran_id
                            AND c3.tran_flag NOT IN ('D', 'O')
                            AND TRUNC (c3.posting_date) <= TRUNC (p_cut_off_date)
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE 1 = 1
                                      AND x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = c1.gacc_tran_id
                                      AND x.tran_flag <> 'D'))
                   OR EXISTS (
                         SELECT 1
                           FROM giac_inw_claim_payts c1,
                                gicl_advice c2,
                                giac_acctrans c3
                          WHERE 1 = 1
                            AND c1.claim_id = a1.claim_id
                            AND c1.advice_id = c2.advice_id
                            AND c2.adv_fla_id = a1.adv_fla_id
                            AND c1.gacc_tran_id = c3.tran_id
                            AND c3.tran_flag NOT IN ('D', 'O')
                            AND TRUNC (c3.posting_date) <= TRUNC (p_cut_off_date)
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE 1 = 1
                                      AND x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = c1.gacc_tran_id
                                      AND x.tran_flag <> 'D'))
                  )
                  AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)
       LOOP
          FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate,
                              u.orig_curr_cd
                         FROM gicl_advice u
                        WHERE 1 = 1
                          AND u.claim_id = v.claim_id
                          AND u.adv_fla_id = v.adv_fla_id)
          LOOP
             v_currency_cd := curr.currency_cd;
             v_convert_rate := curr.convert_rate;
             v_orig_curr_rate := curr.orig_curr_rate;
             v_orig_curr_cd := curr.orig_curr_cd;

             IF curr.currency_cd <> giacp.n ('CURRENCY_CD')
             THEN
                v_loss_shr_amt :=
                   ROUND (NVL (v.loss_shr_amt, 0) * NVL (curr.convert_rate, 1),
                          2);
                v_exp_shr_amt :=
                    ROUND (NVL (v.exp_shr_amt, 0) * NVL (curr.convert_rate, 1),
                           2);
             ELSE
                v_loss_shr_amt := v.loss_shr_amt;
                v_exp_shr_amt := v.exp_shr_amt;
             END IF;
          END LOOP;

          FOR exist IN (SELECT SUM (b1.collection_amt) collection_amt
                          FROM giac_loss_ri_collns b1, giac_acctrans b2
                         WHERE 1 = 1
                           AND b1.claim_id = v.claim_id
                           AND b1.a180_ri_cd = v.ri_cd
                           AND b1.e150_line_cd = v.a1_line_cd
                           AND b1.share_type = 3
                           AND b1.e150_la_yy = v.la_yy
                           AND b1.e150_fla_seq_no = v.fla_seq_no
                           AND b1.payee_type = v.payee_type
                           AND b1.gacc_tran_id = b2.tran_id
                           AND b2.tran_flag <> 'D'
                           AND TRUNC (b2.posting_date) <= TRUNC (p_cut_off_date)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giac_acctrans x, giac_reversals y
                                   WHERE 1 = 1
                                     AND x.tran_id = y.reversing_tran_id
                                     AND y.gacc_tran_id = b1.gacc_tran_id
                                     AND x.tran_flag <> 'D'))
          LOOP
             v_collection_amt := exist.collection_amt;

             IF v_collection_amt IS NOT NULL
             THEN
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := ((v_loss_shr_amt) - (v_collection_amt));
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));
                END IF;
             ELSE
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := v_loss_shr_amt;
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := v_exp_shr_amt;
                END IF;
             END IF;

             v_days := TRUNC (v.fla_date) - TRUNC (p_cut_off_date);

             SELECT column_no
               INTO v_column_no
               FROM giis_report_aging
              WHERE report_id = 'GIACR279A'
                AND min_days <= ABS (v_days)
                AND max_days >= ABS (v_days)
                AND branch_cd IN (
                              SELECT b.grp_iss_cd
                                FROM giis_users a, giis_user_grp_hdr b
                               WHERE a.user_grp = b.user_grp
                                     AND a.user_id = p_user);

             IF NVL (v_amount_due, 0) <> 0
             THEN
                INSERT INTO giac_loss_rec_soa_ext
                            (ri_cd, ri_name, line_cd, line_name,
                             claim_id, claim_no, fla_id, fla_no,
                             policy_no, assd_no, assd_name, fla_date,
                             as_of_date, cut_off_date, payee_type,
                             amount_due, column_no, user_id, extract_date,
                             currency_cd, convert_rate,
                             orig_curr_cd, orig_curr_rate
                            )
                     VALUES (v.ri_cd, v.ri_name, v.line_cd, v.line_name,
                             v.claim_id, v.claim_no, v.fla_id, v.fla_no,
                             v.policy_no, v.assd_no, v.assured_name, v.fla_date,
                             p_as_of_date, p_cut_off_date, v.payee_type,
                             v_amount_due, v_column_no, p_user, SYSDATE,
                             NVL (v_currency_cd, 1), NVL (v_convert_rate, 1),
                             NVL (v_orig_curr_cd, 1), NVL (v_orig_curr_rate, 1)
                            );
             END IF;
          END LOOP;
       END LOOP;
    END;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_ct (
       p_as_of_date     gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   giac_acctrans.tran_date%TYPE,
       p_ri_cd          giis_reinsurer.ri_cd%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_payee_type     gicl_advs_fla_type.payee_type%TYPE,
       p_user           giac_loss_rec_soa_ext.user_id%TYPE
    )
    IS
       v_loss_shr_amt     gicl_advs_fla_type.loss_shr_amt%TYPE;
       v_exp_shr_amt      gicl_advs_fla_type.exp_shr_amt%TYPE;
       v_collection_amt   giac_loss_ri_collns.collection_amt%TYPE;
       v_amount_due       giac_loss_rec_soa_ext.amount_due%TYPE;
       v_days             NUMBER;
       v_column_no        NUMBER;
       v_payee_type1      VARCHAR2 (1);
       v_payee_type2      VARCHAR2 (1);
       v_currency_cd      giac_loss_rec_soa_ext.currency_cd%TYPE;
       v_convert_rate     giac_loss_rec_soa_ext.convert_rate%TYPE;
       v_orig_curr_cd     giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
       v_orig_curr_rate   giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
    BEGIN
       IF p_payee_type = 'B'
       THEN
          v_payee_type1 := 'L';
          v_payee_type2 := 'E';
       END IF;

       FOR v IN
          (SELECT DISTINCT a3.ri_cd, a3.ri_name, a4.line_cd, a4.line_name, a1.claim_id, --modified by John Daniel Marasigan SR-22609 07.04.2016
                  a1.adv_fla_id,
                     a5.line_cd
                  || '-'
                  || a5.subline_cd
                  || '-'
                  || a5.iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')) claim_no,
                  a1.fla_id,
                     a1.line_cd
                  || '-'
                  || LTRIM (TO_CHAR (a1.la_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')) fla_no,
                     a5.line_cd
                  || '-'
                  || a5.subline_cd
                  || '-'
                  || a5.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a5.renew_no, '09')) policy_no,
                  a5.assd_no, a5.assured_name, a1.fla_date, a2.payee_type,
                  a2.loss_shr_amt, a2.exp_shr_amt, a1.line_cd a1_line_cd,
                  a1.la_yy, a1.fla_seq_no
             FROM gicl_advs_fla a1,
                  gicl_advs_fla_type a2,
                  giis_reinsurer a3,
                  giis_line a4,
                  gicl_claims a5,
                  gicl_advice a6,
                  gicl_clm_loss_exp a7
            WHERE 1 = 1
              AND a1.claim_id = a2.claim_id
              AND a1.grp_seq_no = a2.grp_seq_no
              AND a1.fla_id = a2.fla_id
              AND a1.share_type = 3
              AND NVL (a1.cancel_tag, 'N') = 'N'
              AND a1.ri_cd = a3.ri_cd
              AND a1.line_cd = a4.line_cd
              AND a1.claim_id = a5.claim_id
              AND a6.claim_id = a1.claim_id
              AND a6.adv_fla_id = a1.adv_fla_id
              AND a7.advice_id = a6.advice_id
              AND a7.claim_id = a6.claim_id
              AND a7.claim_id = a5.claim_id
              AND TRUNC (a7.tran_date) <= TRUNC (p_as_of_date)
              AND a3.ri_cd = NVL (p_ri_cd, a3.ri_cd)
              AND a4.line_cd = NVL (p_line_cd, a4.line_cd)
              AND (   (a2.payee_type = p_payee_type)
                   OR (a2.payee_type = v_payee_type1)
                   OR (a2.payee_type = v_payee_type2)
                  )
              AND a2.payee_type = a7.payee_type -- added by John Daniel Marasigan SR-22609 07.04.2016
              AND NOT EXISTS (
                     SELECT 1
                       FROM gicl_advice
                      WHERE 1 = 1
                        AND gicl_advice.claim_id = a1.claim_id
                        AND gicl_advice.adv_fla_id = a1.adv_fla_id
                        AND NVL (gicl_advice.advice_flag, 'N') = 'N')
              AND (   EXISTS (
                         SELECT 1
                           FROM giac_direct_claim_payts c1,
                                gicl_advice c2,
                                giac_acctrans c3
                          WHERE 1 = 1
                            AND c1.claim_id = a1.claim_id
                            AND c1.advice_id = c2.advice_id
                            AND c2.adv_fla_id = a1.adv_fla_id
                            AND c1.gacc_tran_id = c3.tran_id
                            AND c3.tran_flag NOT IN ('D', 'O')
                            AND TRUNC (c3.tran_date) <= TRUNC (p_cut_off_date)
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE 1 = 1
                                      AND x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = c1.gacc_tran_id
                                      AND x.tran_flag <> 'D'))
                   OR EXISTS (
                         SELECT 1
                           FROM giac_inw_claim_payts c1,
                                gicl_advice c2,
                                giac_acctrans c3
                          WHERE 1 = 1
                            AND c1.claim_id = a1.claim_id
                            AND c1.advice_id = c2.advice_id
                            AND c2.adv_fla_id = a1.adv_fla_id
                            AND c1.gacc_tran_id = c3.tran_id
                            AND c3.tran_flag NOT IN ('D', 'O')
                            AND TRUNC (c3.tran_date) <= TRUNC (p_cut_off_date)
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE 1 = 1
                                      AND x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = c1.gacc_tran_id
                                      AND x.tran_flag <> 'D'))
                  )
                  AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)
       LOOP
          FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate,
                              u.orig_curr_cd
                         FROM gicl_advice u
                        WHERE 1 = 1
                          AND u.claim_id = v.claim_id
                          AND u.adv_fla_id = v.adv_fla_id)
          LOOP
             v_currency_cd := curr.currency_cd;
             v_convert_rate := curr.convert_rate;
             v_orig_curr_rate := curr.orig_curr_rate;
             v_orig_curr_cd := curr.orig_curr_cd;

             IF curr.currency_cd <> giacp.n ('CURRENCY_CD')
             THEN
                v_loss_shr_amt :=
                   ROUND (NVL (v.loss_shr_amt, 0) * NVL (curr.convert_rate, 1),
                          2);
                v_exp_shr_amt :=
                    ROUND (NVL (v.exp_shr_amt, 0) * NVL (curr.convert_rate, 1),
                           2);
             ELSE
                v_loss_shr_amt := v.loss_shr_amt;
                v_exp_shr_amt := v.exp_shr_amt;
             END IF;
          END LOOP;

          FOR exist IN (SELECT SUM (b1.collection_amt) collection_amt
                          FROM giac_loss_ri_collns b1, giac_acctrans b2
                         WHERE 1 = 1
                           AND b1.claim_id = v.claim_id
                           AND b1.a180_ri_cd = v.ri_cd
                           AND b1.e150_line_cd = v.a1_line_cd
                           AND b1.share_type = 3
                           AND b1.e150_la_yy = v.la_yy
                           AND b1.e150_fla_seq_no = v.fla_seq_no
                           AND b1.payee_type = v.payee_type
                           AND b1.gacc_tran_id = b2.tran_id
                           AND b2.tran_flag <> 'D'
                           AND TRUNC (b2.tran_date) <= TRUNC (p_cut_off_date)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giac_acctrans x, giac_reversals y
                                   WHERE 1 = 1
                                     AND x.tran_id = y.reversing_tran_id
                                     AND y.gacc_tran_id = b1.gacc_tran_id
                                     AND x.tran_flag <> 'D'))
          LOOP
             v_collection_amt := exist.collection_amt;

             IF v_collection_amt IS NOT NULL
             THEN
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := ((v_loss_shr_amt) - (v_collection_amt));
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));
                END IF;
             ELSE
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := v_loss_shr_amt;
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := v_exp_shr_amt;
                END IF;
             END IF;

             v_days := TRUNC (v.fla_date) - TRUNC (p_cut_off_date);

             SELECT column_no
               INTO v_column_no
               FROM giis_report_aging
              WHERE report_id = 'GIACR279A'
                AND min_days <= ABS (v_days)
                AND max_days >= ABS (v_days)
                AND branch_cd IN (
                              SELECT b.grp_iss_cd
                                FROM giis_users a, giis_user_grp_hdr b
                               WHERE a.user_grp = b.user_grp
                                     AND a.user_id = p_user);

             IF NVL (v_amount_due, 0) <> 0
             THEN
                INSERT INTO giac_loss_rec_soa_ext
                            (ri_cd, ri_name, line_cd, line_name,
                             claim_id, claim_no, fla_id, fla_no,
                             policy_no, assd_no, assd_name, fla_date,
                             as_of_date, cut_off_date, payee_type,
                             amount_due, column_no, user_id, extract_date,
                             currency_cd, convert_rate,
                             orig_curr_cd, orig_curr_rate
                            )
                     VALUES (v.ri_cd, v.ri_name, v.line_cd, v.line_name,
                             v.claim_id, v.claim_no, v.fla_id, v.fla_no,
                             v.policy_no, v.assd_no, v.assured_name, v.fla_date,
                             p_as_of_date, p_cut_off_date, v.payee_type,
                             v_amount_due, v_column_no, p_user, SYSDATE,
                             NVL (v_currency_cd, 1), NVL (v_convert_rate, 1),
                             NVL (v_orig_curr_cd, 1), NVL (v_orig_curr_rate, 1)
                            );
             END IF;
          END LOOP;
       END LOOP;
    END;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_cp (
       p_as_of_date     gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   giac_acctrans.tran_date%TYPE,
       p_ri_cd          giis_reinsurer.ri_cd%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_payee_type     gicl_advs_fla_type.payee_type%TYPE,
       p_user           giac_loss_rec_soa_ext.user_id%TYPE
    )
    IS
       v_loss_shr_amt     gicl_advs_fla_type.loss_shr_amt%TYPE;
       v_exp_shr_amt      gicl_advs_fla_type.exp_shr_amt%TYPE;
       v_collection_amt   giac_loss_ri_collns.collection_amt%TYPE;
       v_amount_due       giac_loss_rec_soa_ext.amount_due%TYPE;
       v_days             NUMBER;
       v_column_no        NUMBER;
       v_payee_type1      VARCHAR2 (1);
       v_payee_type2      VARCHAR2 (1);
       v_currency_cd      giac_loss_rec_soa_ext.currency_cd%TYPE;
       v_convert_rate     giac_loss_rec_soa_ext.convert_rate%TYPE;
       v_orig_curr_cd     giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
       v_orig_curr_rate   giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
    BEGIN
       IF p_payee_type = 'B'
       THEN
          v_payee_type1 := 'L';
          v_payee_type2 := 'E';
       END IF;

       FOR v IN
          (SELECT   a3.ri_cd, a3.ri_name, a4.line_cd, a4.line_name, a1.claim_id,
                    a1.adv_fla_id,
                       a5.line_cd
                    || '-'
                    || a5.subline_cd
                    || '-'
                    || a5.iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')) claim_no,
                    a1.fla_id,
                       a1.line_cd
                    || '-'
                    || LTRIM (TO_CHAR (a1.la_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')) fla_no,
                       a5.line_cd
                    || '-'
                    || a5.subline_cd
                    || '-'
                    || a5.pol_iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a5.renew_no, '09')) policy_no,
                    a5.assd_no, a5.assured_name, a1.fla_date, a2.payee_type,
                    SUM(a2.loss_shr_amt) loss_shr_amt, SUM(a2.exp_shr_amt) exp_shr_amt, a1.line_cd a1_line_cd,
                    a1.la_yy, a1.fla_seq_no,
                    a7.currency_cd, SUM(a9.shr_le_ri_net_amt) shr_le_ri_net_amt
               FROM gicl_advs_fla a1,
                    gicl_advs_fla_type a2,
                    giis_reinsurer a3,
                    giis_line a4,
                    gicl_claims a5,
                    gicl_advice a6,
                    gicl_clm_loss_exp a7,
                    gicl_loss_exp_ds a8,
                    gicl_loss_exp_rids a9
              WHERE 1 = 1
                AND a1.claim_id = a2.claim_id
                AND a1.grp_seq_no = a2.grp_seq_no
                AND a1.fla_id = a2.fla_id
                AND a1.share_type = 3
                AND NVL (a1.cancel_tag, 'N') = 'N'
                AND a1.ri_cd = a3.ri_cd
                AND a1.line_cd = a4.line_cd
                AND a1.claim_id = a5.claim_id
                AND a6.claim_id = a1.claim_id
                AND a6.adv_fla_id = a1.adv_fla_id
                AND a7.advice_id = a6.advice_id
                AND a7.claim_id = a6.claim_id
                AND a7.claim_id = a5.claim_id
                AND a7.claim_id = a8.claim_id
                AND a7.clm_loss_id = a8.clm_loss_id
                AND a7.item_no = a8.item_no
                AND a7.peril_cd = a8.peril_cd
                AND a7.grouped_item_no = a8.grouped_item_no
                AND nvl(a8.negate_tag, 'N') = 'N'
                AND a2.payee_type = a7.payee_type
                AND a8.claim_id = a9.claim_id
                AND a8.clm_loss_id = a9.clm_loss_id
                AND a8.clm_dist_no = a9.clm_dist_no
                AND a8.item_no = a9.item_no
                AND a8.peril_cd = a9.peril_cd
                AND NVL(a8.grouped_item_no,0) =  NVL(a9.grouped_item_no,0)
                AND a8.grp_seq_no = a9.grp_seq_no
                AND a1.ri_cd = a9.ri_cd
                AND a1.share_type = a9.share_type
                AND a9.share_type = a8.share_type
                AND TRUNC (a7.tran_date) <= TRUNC (p_as_of_date)
                AND a3.ri_cd = NVL (p_ri_cd, a3.ri_cd)
                AND a4.line_cd = NVL (p_line_cd, a4.line_cd)
                AND (   (a2.payee_type = p_payee_type)
                     OR (a2.payee_type = v_payee_type1)
                     OR (a2.payee_type = v_payee_type2)
                    )
                AND NOT EXISTS (
                       SELECT 1
                         FROM gicl_advice
                        WHERE 1 = 1
                          AND gicl_advice.claim_id = a1.claim_id
                          AND gicl_advice.adv_fla_id = a1.adv_fla_id
                          AND NVL (gicl_advice.advice_flag, 'N') = 'N'
                          AND advice_id = a6.advice_id)
                AND (   EXISTS (
                           SELECT 1
                             FROM giac_direct_claim_payts c1,
                                  gicl_advice c2,
                                  giac_acctrans c3
                            WHERE 1 = 1
                              AND c1.claim_id = a1.claim_id
                              AND c1.advice_id = c2.advice_id
                              AND c2.adv_fla_id = a1.adv_fla_id
                              AND c1.gacc_tran_id = c3.tran_id
                              AND c3.tran_flag NOT IN ('D', 'O')
                              AND TRUNC (c3.posting_date) <=
                                                            TRUNC (p_cut_off_date)
                              AND NOT EXISTS (
                                     SELECT 1
                                       FROM giac_acctrans x, giac_reversals y
                                      WHERE 1 = 1
                                        AND x.tran_id = y.reversing_tran_id
                                        AND y.gacc_tran_id = c1.gacc_tran_id
                                        AND x.tran_flag <> 'D'
                                        AND x.posting_date <= p_cut_off_date)
                              HAVING SUM (disbursement_amt) != 0)
                     OR     EXISTS (
                               SELECT 1
                                 FROM giac_inw_claim_payts c1,
                                      gicl_advice c2,
                                      giac_acctrans c3
                                WHERE 1 = 1
                                  AND c1.claim_id = a1.claim_id
                                  AND c1.advice_id = c2.advice_id
                                  AND c2.adv_fla_id = a1.adv_fla_id
                                  AND c1.gacc_tran_id = c3.tran_id
                                  AND c3.tran_flag NOT IN ('D', 'O')
                                  AND TRUNC (c3.posting_date) <=
                                                            TRUNC (p_cut_off_date)
                                  AND NOT EXISTS (
                                         SELECT 1
                                           FROM giac_acctrans x, giac_reversals y
                                          WHERE 1 = 1
                                            AND x.tran_id = y.reversing_tran_id
                                            AND y.gacc_tran_id = c1.gacc_tran_id
                                            AND x.tran_flag <> 'D'))
                        AND check_user_per_iss_cd_acctg2(NULL, a5.iss_cd, 'GIACS279', p_user) = 1)
           GROUP BY a3.ri_cd,
                    a3.ri_name,
                    a4.line_cd,
                    a4.line_name,
                    a1.claim_id,
                    a1.adv_fla_id,
                       a5.line_cd
                    || '-'
                    || a5.subline_cd
                    || '-'
                    || a5.iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')),
                    a1.fla_id,
                       a1.line_cd
                    || '-'
                    || LTRIM (TO_CHAR (a1.la_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')),
                       a5.line_cd
                    || '-'
                    || a5.subline_cd
                    || '-'
                    || a5.pol_iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a5.renew_no, '09')),
                    a5.assd_no,
                    a5.assured_name,
                    a1.fla_date,
                    a2.payee_type,
                    a1.line_cd,
                    a1.la_yy,
                    a1.fla_seq_no,
                    a7.currency_cd)
       LOOP
          FOR curr IN (SELECT u.currency_cd, u.convert_rate, NVL (u.orig_curr_rate, u.convert_rate) orig_curr_rate,
                              u.orig_curr_cd
                         FROM gicl_advice u
                        WHERE 1 = 1
                          AND u.claim_id = v.claim_id
                          AND u.adv_fla_id = v.adv_fla_id)
          LOOP
             v_currency_cd := curr.currency_cd;
             v_convert_rate := curr.convert_rate;
             v_orig_curr_rate := curr.orig_curr_rate;
             v_orig_curr_cd := curr.orig_curr_cd;

             IF v.currency_cd <> giacp.n ('CURRENCY_CD')
             THEN
                 IF v.payee_type = 'L' then
                    v_loss_shr_amt :=
                       ROUND (NVL (v.shr_le_ri_net_amt, 0) * NVL (curr.orig_curr_rate, 1),
                              2);
                    v_exp_shr_amt := 0;
                 ELSE          
                    v_loss_shr_amt := 0;
                    v_exp_shr_amt :=
                    ROUND (NVL (v.shr_le_ri_net_amt, 0) * NVL (curr.orig_curr_rate, 1), 2);
                 END IF;
             ELSE
                 IF v.payee_type = 'L' THEN
                    v_loss_shr_amt := v.shr_le_ri_net_amt;
                    
                    v_exp_shr_amt := 0;
                 ELSE   
                    v_loss_shr_amt := 0;
                    v_exp_shr_amt := v.shr_le_ri_net_amt; 
                 END IF;
             END IF;
          END LOOP;

          FOR exist IN (SELECT SUM (b1.collection_amt) collection_amt
                          FROM giac_loss_ri_collns b1, giac_acctrans b2
                         WHERE 1 = 1
                           AND b1.claim_id = v.claim_id
                           AND b1.a180_ri_cd = v.ri_cd
                           AND b1.e150_line_cd = v.a1_line_cd
                           AND b1.share_type = 3
                           AND b1.e150_la_yy = v.la_yy
                           AND b1.e150_fla_seq_no = v.fla_seq_no
                           AND b1.payee_type = v.payee_type
                           AND b1.gacc_tran_id = b2.tran_id
                           AND b2.tran_flag <> 'D'
                           AND TRUNC (b2.posting_date) <= TRUNC (p_cut_off_date)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giac_acctrans x, giac_reversals y
                                   WHERE 1 = 1
                                     AND x.tran_id = y.reversing_tran_id
                                     AND y.gacc_tran_id = b1.gacc_tran_id
                                     AND x.tran_flag <> 'D'))
          LOOP
             v_collection_amt := exist.collection_amt;

             IF v_collection_amt IS NOT NULL
             THEN
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := ((v_loss_shr_amt) - (v_collection_amt));
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));
                END IF;
             ELSE
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := v_loss_shr_amt;
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := v_exp_shr_amt;
                END IF;
             END IF;

             v_days := TRUNC (v.fla_date) - TRUNC (p_cut_off_date);

             SELECT column_no
               INTO v_column_no
               FROM giis_report_aging
              WHERE report_id = 'GIACR279A'
                AND min_days <= ABS (v_days)
                AND max_days >= ABS (v_days)
                AND branch_cd IN (
                              SELECT b.grp_iss_cd
                                FROM giis_users a, giis_user_grp_hdr b
                               WHERE a.user_grp = b.user_grp
                                     AND a.user_id = p_user);

                INSERT INTO giac_loss_rec_soa_ext
                            (ri_cd, ri_name, line_cd, line_name,
                             claim_id, claim_no, fla_id, fla_no,
                             policy_no, assd_no, assd_name, fla_date,
                             as_of_date, cut_off_date, payee_type,
                             amount_due, column_no, user_id, extract_date,
                             currency_cd, convert_rate,
                             orig_curr_cd, orig_curr_rate
                            )
                     VALUES (v.ri_cd, v.ri_name, v.line_cd, v.line_name,
                             v.claim_id, v.claim_no, v.fla_id, v.fla_no,
                             v.policy_no, v.assd_no, v.assured_name, v.fla_date,
                             p_as_of_date, p_cut_off_date, v.payee_type,
                             v_amount_due, v_column_no, p_user, SYSDATE,
                             NVL (v_currency_cd, 1), NVL (v_convert_rate, 1),
                             NVL (v_orig_curr_cd, 1), NVL (v_orig_curr_rate, 1)
                            );
          END LOOP;
       END LOOP;
    END;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_ft_nc (
       p_as_of_date     gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   giac_acctrans.tran_date%TYPE,
       p_ri_cd          giis_reinsurer.ri_cd%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_payee_type     gicl_advs_fla_type.payee_type%TYPE,
       p_user           giac_loss_rec_soa_ext.user_id%TYPE
    )
    IS
       v_loss_shr_amt     gicl_advs_fla_type.loss_shr_amt%TYPE;
       v_exp_shr_amt      gicl_advs_fla_type.exp_shr_amt%TYPE;
       v_collection_amt   giac_loss_ri_collns.collection_amt%TYPE;
       v_amount_due       giac_loss_rec_soa_ext.amount_due%TYPE;
       v_days             NUMBER;
       v_column_no        NUMBER;
       v_payee_type1      VARCHAR2 (1);
       v_payee_type2      VARCHAR2 (1);
       v_currency_cd      giac_loss_rec_soa_ext.currency_cd%TYPE;
       v_convert_rate     giac_loss_rec_soa_ext.convert_rate%TYPE;
       v_orig_curr_cd     giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
       v_orig_curr_rate   giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
    BEGIN
       IF p_payee_type = 'B'
       THEN
          v_payee_type1 := 'L';
          v_payee_type2 := 'E';
       END IF;

       FOR v IN (SELECT a3.ri_cd, a3.ri_name, a4.line_cd, a4.line_name,
                        a1.claim_id, a1.adv_fla_id,
                           a5.line_cd
                        || '-'
                        || a5.subline_cd
                        || '-'
                        || a5.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')) claim_no,
                        a1.fla_id,
                           a1.line_cd
                        || '-'
                        || LTRIM (TO_CHAR (a1.la_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')) fla_no,
                           a5.line_cd
                        || '-'
                        || a5.subline_cd
                        || '-'
                        || a5.pol_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (a5.renew_no, '09')) policy_no,
                        a5.assd_no, a5.assured_name, a1.fla_date, a2.payee_type,
                        a2.loss_shr_amt, a2.exp_shr_amt, a1.line_cd a1_line_cd,
                        a1.la_yy, a1.fla_seq_no
                   FROM gicl_advs_fla a1,
                        gicl_advs_fla_type a2,
                        giis_reinsurer a3,
                        giis_line a4,
                        gicl_claims a5
                  WHERE 1 = 1
                    AND a1.claim_id = a2.claim_id
                    AND a1.grp_seq_no = a2.grp_seq_no
                    AND a1.fla_id = a2.fla_id
                    AND a1.share_type = 3
                    AND NVL (a1.cancel_tag, 'N') = 'N'
                    AND a1.ri_cd = a3.ri_cd
                    AND a1.line_cd = a4.line_cd
                    AND a1.claim_id = a5.claim_id
                    AND TRUNC (a1.fla_date) <= TRUNC (p_as_of_date)
                    AND a3.ri_cd = NVL (p_ri_cd, a3.ri_cd)
                    AND a4.line_cd = NVL (p_line_cd, a4.line_cd)
                    AND (   (a2.payee_type = p_payee_type)
                         OR (a2.payee_type = v_payee_type1)
                         OR (a2.payee_type = v_payee_type2)
                        )
                    AND NOT EXISTS (
                           SELECT 1
                             FROM gicl_advice
                            WHERE 1 = 1
                              AND gicl_advice.claim_id = a1.claim_id
                              AND gicl_advice.adv_fla_id = a1.adv_fla_id
                              AND NVL (gicl_advice.advice_flag, 'N') = 'N')
                    AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)
       LOOP
          FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate,
                              u.orig_curr_cd
                         FROM gicl_advice u
                        WHERE 1 = 1
                          AND u.claim_id = v.claim_id
                          AND u.adv_fla_id = v.adv_fla_id)
          LOOP
             v_currency_cd := curr.currency_cd;
             v_convert_rate := curr.convert_rate;
             v_orig_curr_rate := curr.orig_curr_rate;
             v_orig_curr_cd := curr.orig_curr_cd;

             IF curr.currency_cd <> giacp.n ('CURRENCY_CD')
             THEN
                v_loss_shr_amt :=
                   ROUND (NVL (v.loss_shr_amt, 0) * NVL (curr.convert_rate, 1),
                          2);
                v_exp_shr_amt :=
                    ROUND (NVL (v.exp_shr_amt, 0) * NVL (curr.convert_rate, 1),
                           2);
             ELSE
                v_loss_shr_amt := v.loss_shr_amt;
                v_exp_shr_amt := v.exp_shr_amt;
             END IF;
          END LOOP;

          FOR exist IN (SELECT SUM (b1.collection_amt) collection_amt
                          FROM giac_loss_ri_collns b1, giac_acctrans b2
                         WHERE 1 = 1
                           AND b1.claim_id = v.claim_id
                           AND b1.a180_ri_cd = v.ri_cd
                           AND b1.e150_line_cd = v.a1_line_cd
                           AND b1.share_type = 3
                           AND b1.e150_la_yy = v.la_yy
                           AND b1.e150_fla_seq_no = v.fla_seq_no
                           AND b1.payee_type = v.payee_type
                           AND b1.gacc_tran_id = b2.tran_id
                           AND b2.tran_flag <> 'D'
                           AND TRUNC (b2.tran_date) <= TRUNC (p_cut_off_date)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giac_acctrans x, giac_reversals y
                                   WHERE 1 = 1
                                     AND x.tran_id = y.reversing_tran_id
                                     AND y.gacc_tran_id = b1.gacc_tran_id
                                     AND x.tran_flag <> 'D'))
          LOOP
             v_collection_amt := exist.collection_amt;

             IF v_collection_amt IS NOT NULL
             THEN
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := ((v_loss_shr_amt) - (v_collection_amt));
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));
                END IF;
             ELSE
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := v_exp_shr_amt;
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := v_exp_shr_amt;
                END IF;
             END IF;
          END LOOP;

          v_days := TRUNC (v.fla_date) - TRUNC (p_cut_off_date);

          SELECT column_no
            INTO v_column_no
            FROM giis_report_aging
           WHERE report_id = 'GIACR279A'
             AND min_days <= ABS (v_days)
             AND max_days >= ABS (v_days)
             AND branch_cd IN (
                              SELECT b.grp_iss_cd
                                FROM giis_users a, giis_user_grp_hdr b
                               WHERE a.user_grp = b.user_grp
                                     AND a.user_id = p_user);

          IF NVL (v_amount_due, 0) <> 0
          THEN
             INSERT INTO giac_loss_rec_soa_ext
                         (ri_cd, ri_name,
                          line_cd, line_name,
                          claim_id, claim_no,
                          fla_id, fla_no,
                          policy_no, assd_no,
                          assd_name, fla_date, as_of_date,
                          cut_off_date, payee_type, amount_due,
                          column_no, user_id, extract_date,
                          currency_cd, convert_rate,
                          orig_curr_cd, orig_curr_rate
                         )
                  VALUES (NVL (v.ri_cd, 0), NVL (v.ri_name, ' '),
                          NVL (v.line_cd, ' '), NVL (v.line_name, ' '),
                          NVL (v.claim_id, 0), NVL (v.claim_no, ' '),
                          NVL (v.fla_id, 0), NVL (v.fla_no, ' '),
                          NVL (v.policy_no, ' '), NVL (v.assd_no, 0),
                          NVL (v.assured_name, ' '), v.fla_date, p_as_of_date,
                          p_cut_off_date, v.payee_type, NVL (v_amount_due, 0),
                          NVL (v_column_no, 0), p_user, SYSDATE,
                          NVL (v_currency_cd, 1), NVL (v_convert_rate, 1),
                          NVL (v_orig_curr_cd, 1), NVL (v_orig_curr_rate, 1)
                         );
          END IF;
       END LOOP;
    END;
    
    /* benjo 12.04.2015 UCPBGEN-SR-20083 */
    PROCEDURE extract_table_fp_nc (
       p_as_of_date     gicl_advs_fla.fla_date%TYPE,
       p_cut_off_date   giac_acctrans.tran_date%TYPE,
       p_ri_cd          giis_reinsurer.ri_cd%TYPE,
       p_line_cd        giis_line.line_cd%TYPE,
       p_payee_type     gicl_advs_fla_type.payee_type%TYPE,
       p_user           giac_loss_rec_soa_ext.user_id%TYPE
    )
    IS
       v_loss_shr_amt     gicl_advs_fla_type.loss_shr_amt%TYPE;
       v_exp_shr_amt      gicl_advs_fla_type.exp_shr_amt%TYPE;
       v_collection_amt   giac_loss_ri_collns.collection_amt%TYPE;
       v_amount_due       giac_loss_rec_soa_ext.amount_due%TYPE;
       v_days             NUMBER;
       v_column_no        NUMBER;
       v_payee_type1      VARCHAR2 (1);
       v_payee_type2      VARCHAR2 (1);
       v_currency_cd      giac_loss_rec_soa_ext.currency_cd%TYPE;
       v_convert_rate     giac_loss_rec_soa_ext.convert_rate%TYPE;
       v_orig_curr_cd     giac_loss_rec_soa_ext.orig_curr_cd%TYPE;
       v_orig_curr_rate   giac_loss_rec_soa_ext.orig_curr_rate%TYPE;
    BEGIN
       IF p_payee_type = 'B'
       THEN
          v_payee_type1 := 'L';
          v_payee_type2 := 'E';
       END IF;

       FOR v IN (SELECT a3.ri_cd, a3.ri_name, a4.line_cd, a4.line_name,
                        a1.claim_id, a1.adv_fla_id,
                           a5.line_cd
                        || '-'
                        || a5.subline_cd
                        || '-'
                        || a5.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a5.clm_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a5.clm_seq_no, '0999999')) claim_no,
                        a1.fla_id,
                           a1.line_cd
                        || '-'
                        || LTRIM (TO_CHAR (a1.la_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a1.fla_seq_no, '0999999')) fla_no,
                           a5.line_cd
                        || '-'
                        || a5.subline_cd
                        || '-'
                        || a5.pol_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a5.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a5.pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (a5.renew_no, '09')) policy_no,
                        a5.assd_no, a5.assured_name, a1.fla_date, a2.payee_type,
                        a2.loss_shr_amt, a2.exp_shr_amt, a1.line_cd a1_line_cd,
                        a1.la_yy, a1.fla_seq_no
                   FROM gicl_advs_fla a1,
                        gicl_advs_fla_type a2,
                        giis_reinsurer a3,
                        giis_line a4,
                        gicl_claims a5
                  WHERE 1 = 1
                    AND a1.claim_id = a2.claim_id
                    AND a1.grp_seq_no = a2.grp_seq_no
                    AND a1.fla_id = a2.fla_id
                    AND a1.share_type = 3
                    AND NVL (a1.cancel_tag, 'N') = 'N'
                    AND a1.ri_cd = a3.ri_cd
                    AND a1.line_cd = a4.line_cd
                    AND a1.claim_id = a5.claim_id
                    AND TRUNC (a1.fla_date) <= TRUNC (p_as_of_date)
                    AND a3.ri_cd = NVL (p_ri_cd, a3.ri_cd)
                    AND a4.line_cd = NVL (p_line_cd, a4.line_cd)
                    AND (   (a2.payee_type = p_payee_type)
                         OR (a2.payee_type = v_payee_type1)
                         OR (a2.payee_type = v_payee_type2)
                        )
                    AND NOT EXISTS (
                           SELECT 1
                             FROM gicl_advice
                            WHERE 1 = 1
                              AND gicl_advice.claim_id = a1.claim_id
                              AND gicl_advice.adv_fla_id = a1.adv_fla_id
                              AND NVL (gicl_advice.advice_flag, 'N') = 'N')
                    AND check_user_per_iss_cd_acctg2(NULL, a5.ISS_CD, 'GIACS279', p_user) = 1)
       LOOP
          FOR curr IN (SELECT u.currency_cd, u.convert_rate, u.orig_curr_rate,
                              u.orig_curr_cd
                         FROM gicl_advice u
                        WHERE 1 = 1
                          AND u.claim_id = v.claim_id
                          AND u.adv_fla_id = v.adv_fla_id)
          LOOP
             v_currency_cd := curr.currency_cd;
             v_convert_rate := curr.convert_rate;
             v_orig_curr_rate := curr.orig_curr_rate;
             v_orig_curr_cd := curr.orig_curr_cd;

             IF curr.currency_cd <> giacp.n ('CURRENCY_CD')
             THEN
                v_loss_shr_amt :=
                   ROUND (NVL (v.loss_shr_amt, 0) * NVL (curr.convert_rate, 1),
                          2);
                v_exp_shr_amt :=
                    ROUND (NVL (v.exp_shr_amt, 0) * NVL (curr.convert_rate, 1),
                           2);
             ELSE
                v_loss_shr_amt := v.loss_shr_amt;
                v_exp_shr_amt := v.exp_shr_amt;
             END IF;
          END LOOP;

          FOR exist IN (SELECT SUM (b1.collection_amt) collection_amt
                          FROM giac_loss_ri_collns b1, giac_acctrans b2
                         WHERE 1 = 1
                           AND b1.claim_id = v.claim_id
                           AND b1.a180_ri_cd = v.ri_cd
                           AND b1.e150_line_cd = v.a1_line_cd
                           AND b1.share_type = 3
                           AND b1.e150_la_yy = v.la_yy
                           AND b1.e150_fla_seq_no = v.fla_seq_no
                           AND b1.payee_type = v.payee_type
                           AND b1.gacc_tran_id = b2.tran_id
                           AND b2.tran_flag <> 'D'
                           AND TRUNC (b2.posting_date) <= TRUNC (p_cut_off_date)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giac_acctrans x, giac_reversals y
                                   WHERE 1 = 1
                                     AND x.tran_id = y.reversing_tran_id
                                     AND y.gacc_tran_id = b1.gacc_tran_id
                                     AND x.tran_flag <> 'D'))
          LOOP
             v_collection_amt := exist.collection_amt;

             IF v_collection_amt IS NOT NULL
             THEN
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := ((v_loss_shr_amt) - (v_collection_amt));
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := ((v_exp_shr_amt) - (v_collection_amt));
                END IF;
             ELSE
                IF v.payee_type = 'L'
                THEN
                   v_amount_due := v_exp_shr_amt;
                ELSIF v.payee_type = 'E'
                THEN
                   v_amount_due := v_exp_shr_amt;
                END IF;
             END IF;
          END LOOP;

          v_days := TRUNC (v.fla_date) - TRUNC (p_cut_off_date);

          SELECT column_no
            INTO v_column_no
            FROM giis_report_aging
           WHERE report_id = 'GIACR279A'
             AND min_days <= ABS (v_days)
             AND max_days >= ABS (v_days)
             AND branch_cd IN (
                              SELECT b.grp_iss_cd
                                FROM giis_users a, giis_user_grp_hdr b
                               WHERE a.user_grp = b.user_grp
                                     AND a.user_id = p_user);

          IF NVL (v_amount_due, 0) <> 0
          THEN
             INSERT INTO giac_loss_rec_soa_ext
                         (ri_cd, ri_name,
                          line_cd, line_name,
                          claim_id, claim_no,
                          fla_id, fla_no,
                          policy_no, assd_no,
                          assd_name, fla_date, as_of_date,
                          cut_off_date, payee_type, amount_due,
                          column_no, user_id, extract_date,
                          currency_cd, convert_rate,
                          orig_curr_cd, orig_curr_rate
                         )
                  VALUES (NVL (v.ri_cd, 0), NVL (v.ri_name, ' '),
                          NVL (v.line_cd, ' '), NVL (v.line_name, ' '),
                          NVL (v.claim_id, 0), NVL (v.claim_no, ' '),
                          NVL (v.fla_id, 0), NVL (v.fla_no, ' '),
                          NVL (v.policy_no, ' '), NVL (v.assd_no, 0),
                          NVL (v.assured_name, ' '), v.fla_date, p_as_of_date,
                          p_cut_off_date, v.payee_type, NVL (v_amount_due, 0),
                          NVL (v_column_no, 0), p_user, SYSDATE,
                          NVL (v_currency_cd, 1), NVL (v_convert_rate, 1),
                          NVL (v_orig_curr_cd, 1), NVL (v_orig_curr_rate, 1)
                         );
          END IF;
       END LOOP;
    END;
END GIACS279_PKG;
/


