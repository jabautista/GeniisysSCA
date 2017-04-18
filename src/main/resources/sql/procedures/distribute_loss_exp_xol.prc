DROP PROCEDURE CPI.DISTRIBUTE_LOSS_EXP_XOL;

CREATE OR REPLACE PROCEDURE CPI.DISTRIBUTE_LOSS_EXP_XOL 
 (v1_claim_id        IN     GICL_CLM_RES_HIST.claim_id%TYPE,
  v1_clm_loss_id     IN     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
  v1_hist_seq_no     IN     GICL_CLM_RES_HIST.hist_seq_no%TYPE,                              
  v1_item_no         IN     GICL_CLM_RES_HIST.item_no%TYPE,
  v1_peril_cd        IN     GICL_CLM_RES_HIST.peril_cd%TYPE,
  p_claim_id         IN     GICL_CLAIMS.claim_id%TYPE,
  p_line_cd          IN     GICL_CLAIMS.line_cd%TYPE,
  p_loss_date        IN     GICL_CLAIMS.loss_date%TYPE,
  p_catastrophic_cd  IN     GICL_CLAIMS.catastrophic_cd%TYPE,
  p_payee_cd         IN     GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
  p_clm_dist_no      IN OUT GICL_LOSS_EXP_DS.clm_dist_no%TYPE) IS
  
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.27.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes DISTRIBUTE_LOSS_EXP_XOL Program unit in GICLS030
 **                  
 */
                                   
  v_retention                GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_retention_orig           GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_running_retention        GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_total_retention          GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_allowed_retention        GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_total_xol_share          GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_overall_xol_share        GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_overall_allowed_share    GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_old_xol_share            GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;        
  v_allowed_ret              GICL_RESERVE_DS.shr_loss_res_amt%TYPE := 0;
  v_shr_pct                  GICL_RESERVE_DS.shr_pct%TYPE;

  v_net_ret_shr_pct          GICL_LOSS_EXP_DS.shr_loss_exp_pct%TYPE := 0;

  --Cursor for peril distribution in treaty table.
   CURSOR cur_trty(v_share_cd GIIS_DIST_SHARE.share_cd%type,
                   v_trty_yy  GIIS_DIST_SHARE.trty_yy%type) IS
   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
     FROM GIIS_TRTY_PANEL
    WHERE line_cd     = p_line_cd
      AND trty_yy     = v_trty_yy
      AND trty_seq_no = v_share_cd;  
   
  BEGIN

    FOR net_shr IN (SELECT a.dist_year, a.payee_cd, a.item_no, a.grouped_item_no,
                           a.peril_cd,  a.shr_le_pd_amt paid_amt, a.shr_le_net_amt net_amt, 
                           a.shr_le_adv_amt adv_amt2, a.shr_loss_exp_pct shr_pct,
                           (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) adv_amt
                      FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
                     WHERE a.claim_id    = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND a.claim_id    = v1_claim_id
                       AND a.clm_loss_id = v1_clm_loss_id
                       AND a.clm_dist_no = p_clm_dist_no
                       AND a.share_type  = 1)
    LOOP
          v_retention       := NVL(net_shr.adv_amt,0);
          v_retention_orig  := NVL(net_shr.adv_amt,0);
          v_total_retention := v_retention ;

       IF p_catastrophic_cd IS NULL THEN

           FOR TOT_NET IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                          FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
                         WHERE a.claim_id      = b.claim_id
                           AND a.clm_loss_id   = b.clm_loss_id
                           AND a.claim_id      = v1_claim_id
                           AND a.share_type    = 1
                           AND NVL(b.cancel_sw, 'N')  = 'N'
                           AND NVL(a.negate_tag, 'N') = 'N'
                           AND a.clm_loss_id <> v1_clm_loss_id)
           LOOP
            v_total_retention := v_total_retention + NVL(tot_net.ret_amt,0); --jen.12212007 
           END LOOP;          
           
           FOR CHK_XOL IN (SELECT a.share_cd,        acct_trty_type,       xol_allowed_amount,
                                  xol_base_amount,   xol_allocated_amount, trty_yy,
                                  xol_aggregate_sum, a.line_cd,            a.share_type,
                                  nvl(reinstatement_limit, 0) + 1 reinstatement_limit  --nieko 01252017, SR 23709
                             FROM GIIS_DIST_SHARE a, GIIS_TRTY_PERIL b
                            WHERE a.line_cd    = b.line_cd
                              AND a.share_cd   = b.trty_seq_no
                              AND a.share_type = '4'
                              AND TRUNC(a.eff_date)  <= TRUNC(p_loss_date)
                              AND TRUNC(a.expiry_date) >= TRUNC(p_loss_date)
                              AND b.peril_cd   = v1_peril_cd             
                              AND a.line_cd    = p_line_cd                
                           ORDER BY xol_base_amount ASC)
           LOOP
             v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;

             IF v_allowed_retention < 1 THEN             
              EXIT;
             END IF;
            
             --v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum, 0);  --nieko 01252017, SR 23709
             v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum, (chk_xol.reinstatement_limit * chk_xol.xol_allowed_amount)); --nieko 01252017, SR 23709
             
             FOR get_all_xol IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                   FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
                                  WHERE a.claim_id    = b.claim_id
                                    AND a.clm_loss_id = b.clm_loss_id
                                    AND NVL(b.cancel_sw, 'N')  = 'N'
                                    AND NVL(a.negate_tag, 'N') = 'N'
                                    AND grp_seq_no    = chk_xol.share_cd
                                    AND line_cd       = chk_xol.line_cd)
             LOOP     
            
                v_overall_xol_share := v_overall_xol_share - NVL(get_all_xol.ret_amt,0);   -- adrel 010610         
             END LOOP;     
             
             IF v_allowed_retention > v_overall_xol_share THEN
                v_allowed_retention := v_overall_xol_share;
             END IF;
                        
             IF v_allowed_retention > v_retention THEN
                v_allowed_retention := v_retention;     
             END IF;
                  
             v_total_xol_share := 0;
             v_old_xol_share := 0;
             
             FOR TOTAL_XOL IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                 FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
                                WHERE a.claim_id      = v1_claim_id
                                  AND a.claim_id      = b.claim_id
                                  AND a.clm_loss_id   = b.clm_loss_id
                                  AND NVL(b.cancel_sw, 'N')  = 'N'
                                  AND NVL(a.negate_tag, 'N') = 'N'
                                  AND grp_seq_no      = chk_xol.share_cd)
             LOOP
                v_total_xol_share := NVL(total_xol.ret_amt,0);
                v_old_xol_share   := NVL(total_xol.ret_amt,0);              
             END LOOP;
             
             IF v_total_xol_share <= chk_xol.xol_allowed_amount THEN
                v_total_xol_share := chk_xol.xol_allowed_amount - v_total_xol_share;
             END IF;
                  
             IF v_total_xol_share >= v_allowed_retention THEN
                v_total_xol_share := v_allowed_retention;         
             END IF;                    

             IF v_total_xol_share <> 0 THEN
                v_shr_pct           := v_total_xol_share/v_retention_orig;
                v_running_retention := v_running_retention + v_total_xol_share;      

                INSERT INTO GICL_LOSS_EXP_DS(
                    claim_id,                    dist_year,                     clm_loss_id,
                    clm_dist_no,                 item_no,                       peril_cd,
                    payee_cd,                    grp_seq_no,                    share_type,
                    shr_loss_exp_pct,            shr_le_pd_amt,                 shr_le_adv_amt,
                    shr_le_net_amt,              line_cd,                       acct_trty_type,
                    grouped_item_no)
                VALUES (
                    v1_claim_id,                 net_shr.dist_year,             v1_clm_loss_id,
                    p_clm_dist_no,               net_shr.item_no,               net_shr.peril_cd,
                    p_payee_cd,                  chk_xol.share_cd,              chk_xol.share_type,
                    net_shr.shr_pct * v_shr_pct, net_shr.paid_amt * v_shr_pct,  net_shr.adv_amt2 * v_shr_pct,
                    net_shr.net_amt * v_shr_pct, p_line_cd,                     chk_xol.acct_trty_type,
                    net_shr.grouped_item_no);
                
                FOR update_xol_trty IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                          FROM GICL_LOSS_EXP_DS a,  GICL_CLM_LOSS_EXP b
                                         WHERE a.claim_id             = b.claim_id
                                           AND a.clm_loss_id          = b.clm_loss_id
                                           AND NVL(b.cancel_sw, 'N')  = 'N'
                                           AND NVL(a.negate_tag, 'N') = 'N'
                                           AND grp_seq_no             = chk_xol.share_cd
                                           AND a.line_cd              = chk_xol.line_cd)
                LOOP     
                   UPDATE GIIS_DIST_SHARE 
                      SET xol_allocated_amount = update_xol_trty.ret_amt
                    WHERE share_cd = chk_xol.share_cd
                      AND line_cd  = chk_xol.line_cd;
                END LOOP;
                             
                FOR xol_trty IN
                    cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
                LOOP
                    INSERT INTO GICL_LOSS_EXP_RIDS
                        (claim_id,              dist_year,               clm_loss_id,
                         clm_dist_no,           item_no,                 peril_cd, 
                         payee_cd,              grp_seq_no,              share_type,
                         ri_cd,                 shr_loss_exp_ri_pct,     shr_le_ri_pd_amt,
                         shr_le_ri_adv_amt,     shr_le_ri_net_amt,       line_cd,         
                         acct_trty_type,        prnt_ri_cd,              grouped_item_no)
                    VALUES
                        (p_claim_id,            TO_CHAR(SYSDATE,'YYYY'), v1_clm_loss_id,
                         p_clm_dist_no,         net_shr.item_no,         net_shr.peril_cd,
                         p_payee_cd,            chk_xol.share_cd,        chk_xol.share_type,    
                         xol_trty.ri_cd,        ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                         ((net_shr.paid_amt * v_shr_pct) * (xol_trty.trty_shr_pct/100)),
                         ((net_shr.adv_amt2 * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), 
                         ((net_shr.net_amt * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), p_line_cd,     
                          chk_xol.acct_trty_type, xol_trty.prnt_ri_cd,   net_shr.grouped_item_no);
                END LOOP;    
             END IF;         
             v_retention := v_retention - v_total_xol_share;
             v_total_retention := v_total_retention +  v_old_xol_share;        
          END LOOP;
                    
       ELSE -- under catastrophic event
          FOR TOT_NET IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                           FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b, GICL_CLAIMS c
                          WHERE a.claim_id             = b.claim_id
                            AND a.clm_loss_id          = b.clm_loss_id
                            AND a.claim_id             = c.claim_id
                            AND c.catastrophic_cd      = p_catastrophic_cd
                            AND a.share_type           = 1
                            AND a.line_cd = p_line_cd
                            AND NVL(b.cancel_sw, 'N')  = 'N'
                            AND NVL(a.negate_tag, 'N') = 'N'
                            AND (a.claim_id <> v1_claim_id OR a.clm_loss_id <> v1_clm_loss_id))
           LOOP
            v_total_retention := v_total_retention + NVL(tot_net.ret_amt,0);    -- adrel 010610
           END LOOP;          
           
           FOR CHK_XOL IN (SELECT a.share_cd,        acct_trty_type,       xol_allowed_amount,
                                  xol_base_amount,   xol_allocated_amount, trty_yy,
                                  xol_aggregate_sum, a.line_cd,            a.share_type
                             FROM GIIS_DIST_SHARE a, GIIS_TRTY_PERIL b
                            WHERE a.line_cd             = b.line_cd
                              AND a.share_cd            = b.trty_seq_no
                              AND a.share_type          = '4'
                              AND TRUNC(a.eff_date)    <= TRUNC(p_loss_date)
                              AND TRUNC(a.expiry_date) >= TRUNC(p_loss_date)
                              AND b.peril_cd            = v1_peril_cd             
                              AND a.line_cd             = p_line_cd                
                         ORDER BY xol_base_amount ASC)
          LOOP
                v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
              
             IF v_allowed_retention < 1 THEN             
                EXIT;
             END IF;
             
             v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum,0);
             
             FOR get_all_xol IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                   FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
                                  WHERE a.claim_id             = b.claim_id
                                    AND a.clm_loss_id          = b.clm_loss_id
                                    AND NVL(b.cancel_sw, 'N')  = 'N'
                                    AND NVL(a.negate_tag, 'N') = 'N'
                                    AND grp_seq_no             = chk_xol.share_cd
                                    AND line_cd                = chk_xol.line_cd)
             LOOP
               v_overall_xol_share := v_overall_xol_share - NVL(get_all_xol.ret_amt,0);  -- adrel 010610             
             END LOOP;
                  
             IF v_allowed_retention > v_overall_xol_share THEN
               v_allowed_retention := v_overall_xol_share;
             END IF;
                        
             IF v_allowed_retention > v_retention THEN
               v_allowed_retention := v_retention;     
             END IF;
                  
             v_total_xol_share := 0;
             v_old_xol_share   := 0;
             
             FOR TOTAL_XOL IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                 FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
                                WHERE a.claim_id             = v1_claim_id
                                  AND a.claim_id             = b.claim_id
                                  AND a.clm_loss_id          = b.clm_loss_id
                                  AND NVL(b.cancel_sw, 'N')  = 'N'
                                  AND NVL(a.negate_tag, 'N') = 'N'
                                  AND grp_seq_no             = chk_xol.share_cd)
             LOOP
               v_total_xol_share := NVL(total_xol.ret_amt,0);
               v_old_xol_share   := NVL(total_xol.ret_amt,0);              
             END LOOP;
             
             IF v_total_xol_share <= chk_xol.xol_allowed_amount THEN
                v_total_xol_share := chk_xol.xol_allowed_amount - v_total_xol_share;
             END IF;
                  
             IF v_total_xol_share >= v_allowed_retention THEN
                v_total_xol_share := v_allowed_retention;         
             END IF;
                                 
             IF v_total_xol_share <> 0 THEN
                v_shr_pct := v_total_xol_share/v_retention_orig;
                v_running_retention := v_running_retention + v_total_xol_share;      
            
                INSERT INTO GICL_LOSS_EXP_DS(
                    claim_id,                    dist_year,                   clm_loss_id,
                    clm_dist_no,                 item_no,                     peril_cd,
                    payee_cd,                    grp_seq_no,                  share_type,
                    shr_loss_exp_pct,            shr_le_pd_amt,               shr_le_adv_amt,
                    shr_le_net_amt,              line_cd,                     acct_trty_type,
                    grouped_item_no)
                VALUES (
                    v1_claim_id,                 net_shr.dist_year,            v1_clm_loss_id,
                    p_clm_dist_no,               net_shr.item_no,              net_shr.peril_cd,
                    p_payee_cd,                  chk_xol.share_cd,             chk_xol.share_type,
                    net_shr.shr_pct * v_shr_pct, net_shr.paid_amt * v_shr_pct, net_shr.adv_amt2 * v_shr_pct,
                    net_shr.net_amt * v_shr_pct, p_line_cd,                    chk_xol.acct_trty_type,
                    net_shr.grouped_item_no);
                    
                FOR update_xol_trty IN (SELECT (NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt
                                          FROM GICL_LOSS_EXP_DS a,  GICL_CLM_LOSS_EXP b
                                         WHERE a.claim_id             = b.claim_id
                                           AND a.clm_loss_id          = b.clm_loss_id
                                           AND NVL(b.cancel_sw, 'N')  = 'N'
                                           AND NVL(a.negate_tag, 'N') = 'N'
                                           AND grp_seq_no             = chk_xol.share_cd
                                           AND a.line_cd              = chk_xol.line_cd)
                LOOP     
                    UPDATE GIIS_DIST_SHARE 
                       SET xol_allocated_amount = update_xol_trty.ret_amt
                    WHERE share_cd = chk_xol.share_cd
                      AND line_cd = chk_xol.line_cd;
                END LOOP;             
            
                FOR xol_trty IN cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
                LOOP
                    INSERT INTO GICL_LOSS_EXP_RIDS
                        (claim_id,                  dist_year,                  clm_loss_id,
                        clm_dist_no,                item_no,                    peril_cd, 
                        payee_cd,                   grp_seq_no,                 share_type,
                        ri_cd,                      shr_loss_exp_ri_pct,        shr_le_ri_pd_amt,
                        shr_le_ri_adv_amt,          shr_le_ri_net_amt,          line_cd,         
                        acct_trty_type,             prnt_ri_cd,                 grouped_item_no)
                    VALUES
                        (p_claim_id,                TO_CHAR(SYSDATE,'YYYY'),    v1_clm_loss_id,
                         p_clm_dist_no,             net_shr.item_no,            net_shr.peril_cd,
                         p_payee_cd,                chk_xol.share_cd,           chk_xol.share_type,    
                         xol_trty.ri_cd,            ((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)),
                         ((net_shr.paid_amt * v_shr_pct) * (xol_trty.trty_shr_pct/100)),
                         ((net_shr.adv_amt2 * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), 
                         ((net_shr.net_amt * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), p_line_cd,     
                         chk_xol.acct_trty_type,    xol_trty.prnt_ri_cd,        net_shr.grouped_item_no);
                END LOOP;
             END IF;    
             v_retention := v_retention - v_total_xol_share;
             v_total_retention := v_total_retention +  v_old_xol_share;        
          END LOOP; --CHK_XOL              
       END IF;    -- end catastrophic event condition     
    END LOOP; -- NET_SHR    

    IF v_retention = 0 THEN
        DELETE FROM GICL_LOSS_EXP_DS
         WHERE claim_id    = v1_claim_id
           AND clm_loss_id = v1_clm_loss_id
           AND clm_dist_no = p_clm_dist_no
           AND share_type  = 1;
    
    ELSIF v_retention <> v_retention_orig THEN          
         UPDATE GICL_LOSS_EXP_DS
            SET shr_loss_exp_pct = shr_loss_exp_pct * (v_retention_orig-v_running_retention)/v_retention_orig,
                shr_le_pd_amt    = shr_le_pd_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
                shr_le_adv_amt   =  shr_le_adv_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
                shr_le_net_amt   =  shr_le_net_amt * (v_retention_orig-v_running_retention)/v_retention_orig
          WHERE claim_id    = v1_claim_id
            AND clm_loss_id = v1_clm_loss_id
            AND clm_dist_no = p_clm_dist_no
            AND share_type  = 1;
    END IF;  

    FOR s IN (SELECT SUM(shr_loss_exp_pct) shr_pct
                FROM GICL_LOSS_EXP_DS
               WHERE claim_id    = v1_claim_id
                 AND clm_loss_id = v1_clm_loss_id
                 AND clm_dist_no = p_clm_dist_no)
    LOOP
        IF s.shr_pct != 100 THEN
            v_net_ret_shr_pct := 100 - s.shr_pct;
        END IF;
        
        FOR upd IN (SELECT paid_amt, net_amt, advise_amt 
                      FROM GICL_CLM_LOSS_EXP
                     WHERE claim_id    = v1_claim_id
                       AND clm_loss_id = v1_clm_loss_id)
        LOOP
          UPDATE GICL_LOSS_EXP_DS
             SET shr_loss_exp_pct = shr_loss_exp_pct + v_net_ret_shr_pct,
                 shr_le_pd_amt    = upd.paid_amt * (shr_loss_exp_pct + v_net_ret_shr_pct)/100,
                 shr_le_adv_amt   = upd.advise_amt * (shr_loss_exp_pct + v_net_ret_shr_pct)/100,
                 shr_le_net_amt   = upd.net_amt * (shr_loss_exp_pct + v_net_ret_shr_pct)/100
            WHERE claim_id    = v1_claim_id
              AND clm_dist_no = p_clm_dist_no
              AND clm_loss_id = v1_clm_loss_id
              AND share_type  = 1;
       
        END LOOP;
    END LOOP;
    
    GICLS030_OFFSET_AMT(p_clm_dist_no, v1_claim_id, v1_clm_loss_id);
  
  END;
/


