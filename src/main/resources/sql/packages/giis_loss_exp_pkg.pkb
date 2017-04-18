CREATE OR REPLACE PACKAGE BODY CPI.GIIS_LOSS_EXP_PKG AS

    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 01.27.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Get records from giis_loss_exp
    **                  
    */  
   FUNCTION get_giis_loss_exp_list
        ( p_claim_id        IN    GICL_CLM_LOSS_EXP.claim_id%TYPE,    
          p_clm_loss_id     IN    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
          p_item_no         IN    GICL_ITEM_PERIL.item_no%TYPE,
          p_peril_cd        IN    GICL_ITEM_PERIL.peril_cd%TYPE,
          p_payee_type      IN    GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
          p_line_cd         IN    GICL_CLAIMS.line_cd%TYPE,
          p_subline_cd      IN    GICL_CLAIMS.subline_cd%TYPE,
          p_pol_iss_cd      IN    GICL_CLAIMS.pol_iss_cd%TYPE,
          p_issue_yy        IN    GICL_CLAIMS.issue_yy%TYPE,
          p_pol_seq_no      IN    GICL_CLAIMS.pol_seq_no%TYPE,
          p_renew_no        IN    GICL_CLAIMS.renew_no%TYPE,
          p_loss_date       IN    GICL_CLAIMS.loss_date%TYPE )
   
   RETURN giis_loss_exp_tab PIPELINED AS
   
   giis_le          giis_loss_exp_type;
   
   BEGIN
        FOR i IN (SELECT a.loss_exp_cd, a.loss_exp_desc, 0 amount,
                       a.subline_cd, deductible_rate, NVL(a.comp_sw, '+') comp_sw,
                       NVL(a.part_sw, 'N') part_sw
                  FROM GIIS_LOSS_EXP a
                 WHERE NVL(a.peril_cd, p_peril_cd) = p_peril_cd 
                   AND a.loss_exp_type = p_payee_type
                   AND a.line_cd = p_line_cd
                   AND a.subline_cd IS NULL
                   AND NVL(a.comp_sw, '+') = '+'
                   AND NOT EXISTS (SELECT '1'
                                     FROM GICL_LOSS_EXP_DTL b
                                    WHERE b.claim_id = p_claim_id
                                      AND b.clm_loss_id = p_clm_loss_id
                                      AND b.loss_exp_cd = a.loss_exp_cd
                                      AND NVL(b.subline_cd, 'XXX') = NVL(a.subline_cd, 'XXX'))
                 UNION
                SELECT a.loss_exp_cd, a.loss_exp_desc, -SUM(b.deductible_amt) amount,
                       a.subline_cd, b.deductible_rt deductible_rate,
                       NVL(a.comp_sw, '-') comp_sw, NVL(a.part_sw, 'N') part_sw
                  FROM GIIS_LOSS_EXP a, 
                       GIPI_DEDUCTIBLES b, 
                       GIPI_POLBASIC c
                 WHERE NVL(a.peril_cd, p_peril_cd) = p_peril_cd 
                   AND a.line_cd = c.line_cd
                   AND a.line_cd = b.ded_line_cd
                   AND a.subline_cd = b.ded_subline_cd
                   AND a.loss_exp_cd = b.ded_deductible_cd
                   AND a.loss_exp_type = p_payee_type
                   AND a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND b.policy_id = c.policy_id
                   AND c.line_cd = p_line_cd
                   AND c.subline_cd = p_subline_cd
                   AND c.iss_cd = p_pol_iss_cd
                   AND c.issue_yy = p_issue_yy
                   AND c.pol_seq_no = p_pol_seq_no
                   AND c.renew_no = p_renew_no
                   AND c.expiry_date >= p_loss_date
                   AND c.dist_flag = '3'
                   AND c.pol_flag IN ('1','2','3','X')
                   AND b.item_no = p_item_no
                   AND b.peril_cd IN (p_peril_cd, 0)
                   AND NVL(b.deductible_amt,0) > 0
                   AND a.comp_sw = '+'
                   AND NOT EXISTS (SELECT '1'
                                     FROM GICL_LOSS_EXP_DTL d
                                    WHERE d.claim_id = p_claim_id
                                      AND d.clm_loss_id = p_clm_loss_id
                                      AND d.loss_exp_cd = a.loss_exp_cd
                                      AND NVL(d.subline_cd, 'XXX') = NVL(d.subline_cd, 'XXX'))
                 GROUP BY a.subline_cd , a.loss_exp_cd, a.loss_exp_desc,
                          b.deductible_rt, NVL(a.comp_sw, '-'), NVL(a.part_sw, 'N'))
                          
      LOOP
          giis_le.loss_exp_cd       := i.loss_exp_cd;
          giis_le.loss_exp_desc     := i.loss_exp_desc;
          giis_le.sum_ded_amt       := i.amount;
          giis_le.subline_cd        := i.subline_cd;
          giis_le.deductible_rate   := i.deductible_rate;
          giis_le.comp_sw           := i.comp_sw;
          giis_le.part_sw           := i.part_sw;
          PIPE ROW(giis_le);  
      END LOOP;
   
   END get_giis_loss_exp_list;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Get list records from giis_loss_exp for
    **                  the LOV of Loss Expense Deductibles
    */  

    FUNCTION get_giis_loss_exp_lov_for_ded
        (p_claim_id      IN    GICL_CLAIMS.claim_id%TYPE,
         p_clm_loss_id   IN    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE, 
         p_item_no       IN    GICL_ITEM_PERIL.item_no%TYPE,
         p_peril_cd      IN    GICL_ITEM_PERIL.peril_cd%TYPE,
         p_payee_type    IN    GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
         p_line_cd       IN    GICL_CLAIMS.line_cd%TYPE,
         p_subline_cd    IN    GICL_CLAIMS.subline_cd%TYPE,
         p_pol_iss_cd    IN    GICL_CLAIMS.pol_iss_cd%TYPE,
         p_issue_yy      IN    GICL_CLAIMS.issue_yy%TYPE,
         p_pol_seq_no    IN    GICL_CLAIMS.pol_seq_no%TYPE,
         p_renew_no      IN    GICL_CLAIMS.renew_no%TYPE,
         p_loss_date     IN    GICL_CLAIMS.loss_date%TYPE,
         p_pol_eff_date  IN    GICL_CLAIMS.pol_eff_date%TYPE,
         p_expiry_date   IN    GICL_CLAIMS.expiry_date%TYPE) 
     
     RETURN giis_loss_exp_for_ded_tab PIPELINED AS
     
     v_ded_list     giis_loss_exp_for_ded_type;
     
    BEGIN
        FOR i IN (SELECT a.loss_exp_cd ded_cd, a.loss_exp_desc ded_title, NULL ded_type,
                         NVL(a.deductible_rate, 0) ded_rate, 0 ded_amount, NULL ded_text,
                         a.subline_cd ded_subline_cd, NVL(a.comp_sw, '+') comp_sw,
                         NULL aggregate_sw, NULL ceiling_sw, NULL min_amt, NULL max_amt, 
                         NULL range_sw, NULL deductible_type, 0 ded_amt
                  FROM GIIS_LOSS_EXP a 
                  WHERE a.loss_exp_type = p_payee_type 
                  AND a.line_cd = p_line_cd 
                  AND a.subline_cd IS NULL 
                  AND a.comp_sw = '-' 
                  AND NOT EXISTS(SELECT '1' FROM GICL_LOSS_EXP_DTL b 
                                  WHERE b.claim_id = p_claim_id 
                                  AND b.clm_loss_id = p_clm_loss_id 
                                  AND b.loss_exp_cd = a.loss_exp_cd 
                                  AND NVL(b.subline_cd, 'XXX') = NVL(a.subline_cd, 'XXX')) 
                UNION
                SELECT a.ded_deductible_cd ded_cd, b.deductible_title ded_title, f.rv_meaning ded_type,
                       NVL(a.deductible_rt, 0) ded_rate, NVL(a.deductible_amt, 0) ded_amount, a.deductible_text ded_text, 
                       a.ded_subline_cd ded_subline_cd, NULL comp_sw,
                       a.aggregate_sw aggregate_sw, a.ceiling_sw ceiling_sw, a.min_amt min_amt, a.max_amt max_amt, 
                       a.range_sw range_sw, b.ded_type deductible_type, NVL(a.deductible_amt, 0) ded_amt
                  FROM GIPI_DEDUCTIBLES a, 
                       GIIS_DEDUCTIBLE_DESC b, 
                       GIPI_POLBASIC c, 
                       GIIS_LOSS_EXP e, 
                       CG_REF_CODES f
                 WHERE a.ded_line_cd = b.line_cd
                   AND a.ded_subline_cd = b.subline_cd
                   AND a.ded_deductible_cd = b.deductible_cd
                   AND a.ded_line_cd = c.line_cd 
                   AND a.ded_subline_cd = c.subline_cd 
                   AND a.policy_id = c.policy_id 
                   AND e.line_cd = c.line_cd 
                   AND e.line_cd = a.ded_line_cd 
                   AND e.subline_cd = a.ded_subline_cd 
                   AND e.loss_exp_cd = a.ded_deductible_cd 
                   AND e.loss_exp_type = p_payee_type
                   AND a.ded_line_cd = p_line_cd
                   AND a.ded_subline_cd = p_subline_cd
                   AND c.iss_cd = p_pol_iss_cd
                   AND c.issue_yy = p_issue_yy
                   AND c.pol_seq_no = p_pol_seq_no
                   AND c.renew_no = p_renew_no
                   AND c.expiry_date >= p_loss_date
                   AND c.pol_flag IN ('1','2','3','X')
                   AND a.item_no IN (p_item_no,0) 
                   AND a.peril_cd IN (p_peril_cd, 0)
                   AND f.rv_domain = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
                   AND f.rv_low_value = b.ded_type
                   AND TRUNC(DECODE(TRUNC(c.eff_date), TRUNC(c.incept_date),
                                    p_pol_eff_date, c.eff_date )) <= TRUNC(p_loss_date)
                   AND TRUNC(DECODE(NVL(c.endt_expiry_date,c.expiry_date),c.expiry_date,
                                    p_expiry_date,c.endt_expiry_date)) >= TRUNC(p_loss_date)
                   AND EXISTS (SELECT 'X' FROM GIIS_LOSS_EXP d
                                WHERE d.loss_exp_cd = a.ded_deductible_cd
                                  AND d.line_cd = b.line_cd
                                  AND d.subline_cd = a.ded_subline_cd)
                   AND NOT EXISTS(SELECT '1' FROM GICL_LOSS_EXP_DTL g 
                                   WHERE g.claim_id = p_claim_id 
                                     AND g.clm_loss_id = p_clm_loss_id 
                                     AND g.loss_exp_cd = e.loss_exp_cd 
                                     AND NVL(g.subline_cd, 'XXX') = NVL(e.subline_cd, 'XXX')))
        
        LOOP
           v_ded_list.ded_cd            := i.ded_cd;
           v_ded_list.ded_title         := i.ded_title;
           v_ded_list.ded_type          := i.ded_type;
           v_ded_list.ded_rate          := i.ded_rate;
           v_ded_list.ded_amount        := i.ded_amount;
           v_ded_list.ded_text          := i.ded_text;
           v_ded_list.ded_subline_cd    := i.ded_subline_cd;
           v_ded_list.comp_sw           := i.comp_sw;
           v_ded_list.aggregate_sw      := i.aggregate_sw;
           v_ded_list.ceiling_sw        := i.ceiling_sw;
           v_ded_list.min_amt           := i.min_amt;
           v_ded_list.max_amt           := i.max_amt;
           v_ded_list.range_sw          := i.range_sw;
           v_ded_list.deductible_type   := i.deductible_type;
           v_ded_list.ded_amt           := i.ded_amt;
           
           PIPE ROW(v_ded_list);
           
        END LOOP; 
    END get_giis_loss_exp_lov_for_ded;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.11.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Get list of deductible records for 
    **                  MC Evaluation Deductibles
    */  

    FUNCTION get_deduct_list_for_mc_eval
    (p_claim_id         IN   GICL_CLAIMS.claim_id%TYPE,
     p_pol_line_cd      IN   GICL_CLAIMS.line_cd%TYPE,
     p_pol_subline_cd   IN   GICL_CLAIMS.subline_cd%TYPE,
     p_pol_iss_cd       IN   GICL_CLAIMS.pol_iss_cd%TYPE,
     p_pol_issue_yy     IN   GICL_CLAIMS.issue_yy%TYPE,
     p_pol_seq_no       IN   GICL_CLAIMS.pol_seq_no%TYPE,
     p_pol_renew_no     IN   GICL_CLAIMS.renew_no%TYPE,
     p_loss_date        IN   GICL_CLAIMS.loss_date%TYPE,
     p_item_no          IN   GICL_MC_EVALUATION.item_no%TYPE,
     p_peril_cd         IN   GICL_MC_EVALUATION.peril_cd%TYPE)
     
     RETURN mc_eval_deductible_tab PIPELINED AS
     
     deductible     mc_eval_deductible_type;
     
    BEGIN
          FOR i IN (SELECT a.loss_exp_cd, a.loss_exp_desc, 0 amount, a.subline_cd, 
                           NVL(a.deductible_rate, 0) deductible_rate, 
                           NVL(a.comp_sw, '+') comp_sw 
                      FROM GIIS_LOSS_EXP a 
                     WHERE a.loss_exp_type = 'L'
                       AND a.line_cd = NVL(p_pol_line_cd, 'MC') 
                       AND a.subline_cd IS NULL 
                       AND a.comp_sw = '-' 
                       AND a.loss_exp_cd <> GIISP.v('MC_DEPRECIATION_CD')
                    UNION
                    /*policy deductibles amt*/
                    SELECT a.loss_exp_cd, a.loss_exp_desc, -SUM(b.deductible_amt) amount, 
                           a.subline_cd, 0 deductible_rate, NVL(a.comp_sw, '-') comp_sw
                      FROM GIIS_LOSS_EXP a, GIPI_DEDUCTIBLES b, GIPI_POLBASIC c 
                     WHERE a.line_cd        = c.line_cd 
                       AND a.line_cd        = b.ded_line_cd 
                       AND a.subline_cd     = b.ded_subline_cd 
                       AND a.loss_exp_cd    = b.ded_deductible_cd 
                       AND a.loss_exp_type  = 'L' 
                       AND a.line_cd        = NVL(p_pol_line_cd, 'MC')
                       AND a.subline_cd     = p_pol_subline_cd 
                       AND b.policy_id      = c.policy_id 
                       AND c.line_cd        = NVL(p_pol_line_cd, 'MC') 
                       AND c.subline_cd     = p_pol_subline_cd 
                       AND c.iss_cd         = p_pol_iss_cd 
                       AND c.issue_yy       = p_pol_issue_yy 
                       AND c.pol_seq_no     = p_pol_seq_no 
                       AND c.renew_no       = p_pol_renew_no 
                       AND c.expiry_date   >= p_loss_date 
                       AND c.pol_flag IN ('1','2','3','X') 
                       AND b.item_no        = p_item_no 
                       AND b.peril_cd IN (p_peril_cd, 0)
                       AND NVL(b.deductible_amt,0) <> 0  
                    GROUP BY a.subline_cd , a.loss_exp_cd, a.loss_exp_desc, NVL(a.comp_sw, '-')
                    UNION
                    /*policy deductibles rate*/
                    SELECT a.loss_exp_cd, a.loss_exp_desc,  d.ann_tsi_amt amount,
                           a.subline_cd, NVL(b.deductible_rt, 0) deductible_rate, NVL(a.comp_sw, '-') comp_sw
                      FROM GIIS_LOSS_EXP a, GIPI_DEDUCTIBLES b, GIPI_POLBASIC c, GICL_ITEM_PERIL d
                     WHERE a.line_cd       = c.line_cd 
                       AND a.line_cd       = b.ded_line_cd 
                       AND a.subline_cd    = b.ded_subline_cd 
                       AND a.loss_exp_cd   = b.ded_deductible_cd 
                       AND a.loss_exp_type = 'L' 
                       AND a.line_cd       = NVL(p_pol_line_cd, 'MC')
                       AND d.item_no       = p_item_no
                       AND d.claim_id      = p_claim_id
                       AND d.peril_cd      = p_peril_cd
                       AND a.subline_cd    = p_pol_subline_cd 
                       AND b.policy_id     = c.policy_id 
                       AND c.line_cd       = NVL(p_pol_line_cd, 'MC') 
                       AND c.subline_cd    = p_pol_subline_cd 
                       AND c.iss_cd        = p_pol_iss_cd 
                       AND c.issue_yy      = p_pol_issue_yy 
                       AND c.pol_seq_no    = p_pol_seq_no 
                       AND c.renew_no      = p_pol_renew_no 
                       AND c.expiry_date  >= p_loss_date 
                       AND c.pol_flag IN ('1','2','3','X') 
                       AND b.item_no       = p_item_no 
                       AND b.peril_cd IN (p_peril_cd, 0)
                       AND NVL(b.deductible_rt,0) > 0)
          
          LOOP
                deductible.loss_exp_cd      := i.loss_exp_cd;
                deductible.loss_exp_desc    := i.loss_exp_desc;
                deductible.amount           := i.amount;
                deductible.subline_cd       := i.subline_cd;
                deductible.ded_rate         := i.deductible_rate;
                deductible.comp_sw          := i.comp_sw;
                deductible.ded_text         := NULL;
                
                FOR txt IN (SELECT b.deductible_text
                              FROM GIPI_DEDUCTIBLES b, 
                                   GIPI_POLBASIC c 
                             WHERE b.ded_line_cd  = p_pol_line_cd 
                               AND b.ded_subline_cd = p_pol_subline_cd 
                               AND b.ded_deductible_cd  = i.loss_exp_cd
                               AND b.policy_id     = c.policy_id 
                               AND c.line_cd       = NVL(p_pol_line_cd, 'MC') 
                               AND c.subline_cd    = p_pol_subline_cd 
                               AND c.iss_cd        = p_pol_iss_cd 
                               AND c.issue_yy      = p_pol_issue_yy 
                               AND c.pol_seq_no    = p_pol_seq_no 
                               AND c.renew_no      = p_pol_renew_no 
                               AND c.expiry_date  >= p_loss_date                          
                               AND c.pol_flag      IN ('1','2','3','X') 
                               AND b.item_no       = p_item_no 
                               AND b.peril_cd      IN (p_peril_cd,0)
                               AND b.deductible_text IS NOT NULL)
                LOOP
                    deductible.ded_text := txt.deductible_text;
                END LOOP;
                
                PIPE ROW(deductible);
          END LOOP;             
                    
    END get_deduct_list_for_mc_eval;
    
	/*
    **  Created by    : Kenneth Labrador
    **  Date Created  : 06.11.2015
    **  Reference By  : GICLS030 - Loss Expense History
    **  Description   : Get original surplus amount
    **                  
    */ 
   PROCEDURE get_orig_surplus_amt (
      p_claim_id        IN    gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no         IN    gicl_motor_car_dtl.item_no%TYPE,
      p_loss_exp_cd     IN    gicl_mc_part_cost.loss_exp_cd%TYPE,
      p_tag             IN    VARCHAR2,
      p_amount          OUT   gicl_mc_part_cost.orig_amt%TYPE
   )
   IS
   BEGIN
      FOR h IN (SELECT motcar_comp_cd, make_cd, model_year
                  FROM gicl_motor_car_dtl
                 WHERE claim_id = p_claim_id AND item_no = p_item_no)
      LOOP
         FOR i IN (SELECT orig_amt, surp_amt
                     FROM gicl_mc_part_cost
                    WHERE car_company_cd = h.motcar_comp_cd AND make_cd = h.make_cd AND model_year = h.model_year AND loss_exp_cd = p_loss_exp_cd)
         LOOP
            IF p_tag = 'Y' THEN
               p_amount := i.orig_amt;
            ELSE
               p_amount := i.surp_amt;
            END IF;
         END LOOP;
      END LOOP;
   END;
END;
/


