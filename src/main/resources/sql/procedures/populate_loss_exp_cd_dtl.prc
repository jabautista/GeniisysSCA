DROP PROCEDURE CPI.POPULATE_LOSS_EXP_CD_DTL;

CREATE OR REPLACE PROCEDURE CPI.populate_loss_exp_cd_dtl
   (p_dtl_subline_cd    IN     GICL_LOSS_EXP_DTL.subline_cd%TYPE,
    p_claim_id          IN     GICL_CLAIMS.claim_id%TYPE,
    p_clm_loss_id       IN     GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
    p_loss_exp_cd       IN     GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
    p_line_cd           IN     GICL_CLAIMS.line_cd%TYPE,
    p_subline_cd        IN     GICL_CLAIMS.subline_cd%TYPE,
    p_pol_iss_cd        IN     GICL_CLAIMS.pol_iss_cd%TYPE,
    p_issue_yy          IN     GICL_CLAIMS.issue_yy%TYPE,
    p_pol_seq_no        IN     GICL_CLAIMS.pol_seq_no%TYPE,
    p_renew_no          IN     GICL_CLAIMS.renew_no%TYPE,
    p_loss_date         IN     GICL_CLAIMS.loss_date%TYPE,
    p_item_no           IN     GICL_ITEM_PERIL.item_no%TYPE,
    p_peril_cd          IN     GICL_ITEM_PERIL.peril_cd%TYPE,  
    p_payee_type        IN     GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
    p_depreciation_sw   IN     VARCHAR2,
    p_nbt_car_comp_cd   IN     GICL_MC_PART_COST.car_company_cd%TYPE,
    p_nbt_make_cd       IN     GICL_MC_PART_COST.make_cd%TYPE,
    p_nbt_model_year    IN     GICL_MC_PART_COST.model_year%TYPE,
    p_loss_exp_class    IN OUT GICL_LOSS_EXP_DTL.loss_exp_class%TYPE,
    p_no_of_units       IN OUT GICL_LOSS_EXP_DTL.no_of_units%TYPE,
    p_dsp_exp_desc      OUT    GIIS_LOSS_EXP.loss_exp_desc%TYPE,
    p_nbt_comp_sw       OUT    GIIS_LOSS_EXP.comp_sw%TYPE,
    p_original_sw       OUT    GICL_LOSS_EXP_DTL.original_sw%TYPE,
    p_ded_base_amt      OUT    GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
    p_dtl_amt           OUT    GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
    p_msg_alert         OUT    VARCHAR2) 
 
AS

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.17.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Executes WHEN-VALIDATE-ITEM trigger in
   **                  LOSS_EXP_CD field IN Block C013 
   */ 
   
    v_dsp_exp_desc      GIIS_LOSS_EXP.loss_exp_desc%TYPE;
    v_nbt_comp_sw       GIIS_LOSS_EXP.comp_sw%TYPE;
    v_original_sw       GICL_LOSS_EXP_DTL.original_sw%TYPE;
    v_ded_base_amt      GICL_LOSS_EXP_DTL.ded_base_amt%TYPE;
    v_dtl_amt           GICL_LOSS_EXP_DTL.dtl_amt%TYPE;
    valid_sw            VARCHAR2(1) := 'N';
    v_line_mc           GIIS_LINE.line_cd%TYPE;
    v_cnt_class         NUMBER := 0;

BEGIN

    IF p_dtl_subline_cd IS NULL THEN

      FOR A IN
        (SELECT loss_exp_desc, NVL(comp_sw, '+') comp_sw 
           FROM GIIS_LOSS_EXP
          WHERE loss_exp_type = p_payee_type
            AND line_cd       = p_line_cd
            AND loss_exp_cd   = p_loss_exp_cd
            AND subline_cd IS NULL)
      LOOP
        v_dsp_exp_desc := a.loss_exp_desc;
        v_nbt_comp_sw  := a.comp_sw;
        valid_sw := 'Y';
        EXIT;
      END LOOP;
      
      FOR get_mc_param IN
        (SELECT param_value_v 
           FROM GIIS_PARAMETERS
          WHERE param_name = 'LINE_CODE_MC')
      LOOP 
        v_line_mc := get_mc_param.param_value_v;
      END LOOP;
          
      IF v_nbt_comp_sw = '+' AND p_line_cd = v_line_mc THEN
         FOR chk_class IN
           (SELECT loss_exp_class
              FROM GICL_LOSS_EXP_DTL
             WHERE claim_id       = p_claim_id
               AND clm_loss_id    = p_clm_loss_id
               AND loss_exp_cd    = p_loss_exp_cd
               AND subline_cd     IS NULL
               AND loss_exp_type  = 'L'
               AND loss_exp_class IS NOT NULL
             ORDER BY loss_exp_class)
         LOOP
            v_cnt_class  := v_cnt_class + 1;
         END LOOP;
                
         IF v_cnt_class = 2 THEN
            p_msg_alert := 'Cannot add another loss expense class. '||
                           'There are already existing loss expense classes.';
            RETURN;
         END IF;

         IF p_loss_exp_class IS NULL THEN
            FOR p IN
              (SELECT NVL(a.part_sw, 'N') part_sw
                 FROM GIIS_LOSS_EXP a
                WHERE a.loss_exp_type     = p_payee_type
                  AND a.line_cd           = p_line_cd
                  AND a.subline_cd        IS NULL
                  AND a.loss_exp_cd       = p_loss_exp_cd
                  AND NVL(a.comp_sw, '+') = '+'
                  AND NOT EXISTS(SELECT '1'
                                   FROM GICL_LOSS_EXP_DTL b
                                  WHERE b.claim_id    = p_claim_id
                                    AND b.clm_loss_id = p_clm_loss_id
                                    AND b.loss_exp_cd = a.loss_exp_cd
                                    AND NVL(b.subline_cd, 'XXX') = NVL(a.subline_cd, 'XXX'))
                UNION
               SELECT NVL(a.part_sw, 'N') part_sw
                 FROM GIIS_LOSS_EXP a, GIPI_DEDUCTIBLES b, GIPI_POLBASIC c
                WHERE a.line_cd       = c.line_cd
                  AND a.line_cd       = b.ded_line_cd
                  AND a.loss_exp_cd   = p_loss_exp_cd
                  AND a.subline_cd    = b.ded_subline_cd
                  AND a.loss_exp_cd   = b.ded_deductible_cd
                  AND a.loss_exp_type = p_payee_type
                  AND a.line_cd       = p_line_cd
                  AND a.subline_cd    = p_subline_cd
                  AND b.policy_id     = c.policy_id
                  AND c.line_cd       = p_line_cd
                  AND c.subline_cd    = p_subline_cd
                  AND c.iss_cd        = p_pol_iss_cd
                  AND c.issue_yy      = p_issue_yy
                  AND c.pol_seq_no    = p_pol_seq_no
                  AND c.renew_no      = p_renew_no
                  AND c.expiry_date   >= p_loss_date
                  --AND c.dist_flag     = '3'
                  AND c.pol_flag      IN ('1','2','3','X')
                  AND b.item_no       = p_item_no
                  AND b.peril_cd      IN (p_peril_cd, 0)
                  AND nvl(b.deductible_amt,0) > 0
                  AND a.comp_sw       = '+'
                  AND NOT EXISTS(SELECT '1'
                                   FROM GICL_LOSS_EXP_DTL d
                                  WHERE d.claim_id    = p_claim_id
                                    AND d.clm_loss_id = p_clm_loss_id
                                    AND d.loss_exp_cd = a.loss_exp_cd
                                    AND nvl(d.subline_cd, 'XXX') = NVL(d.subline_cd, 'XXX')))
            LOOP
            
              IF p.part_sw = 'Y' THEN
                   p_loss_exp_class := 'P';
              END IF;
              
            END LOOP;
            
         END IF;
            
         IF NVL(p_no_of_units, 0) = 0 THEN
               p_no_of_units := 1;
         END IF;

         IF p_depreciation_sw = 'N' AND p_loss_exp_class = 'P' THEN
            v_original_sw := 'Y';
         ELSE
            v_original_sw := 'N'; 
         END IF;

         IF NVL(v_original_sw, 'N') = 'Y' THEN

            FOR get_default_amt IN
              (SELECT orig_amt
                 FROM GICL_MC_PART_COST
                WHERE car_company_cd = p_nbt_car_comp_cd
                  AND make_cd        = p_nbt_make_cd
                  AND model_year     = p_nbt_model_year
                  AND loss_exp_cd    = p_loss_exp_cd)
            LOOP
              v_ded_base_amt  := get_default_amt.orig_amt;
              v_dtl_amt       := get_default_amt.orig_amt * p_no_of_units;  
            END LOOP;
                    
         ELSE
            FOR get_default_amt IN
              (SELECT surp_amt 
                 FROM GICL_MC_PART_COST
                WHERE car_company_cd = p_nbt_car_comp_cd
                  AND make_cd        = p_nbt_make_cd
                  AND model_year     = p_nbt_model_year
                  AND loss_exp_cd    = p_loss_exp_cd)
            LOOP
              v_ded_base_amt  := get_default_amt.surp_amt;
              v_dtl_amt       := get_default_amt.surp_amt * p_no_of_units;  
            END LOOP;
         END IF;
      END IF;
    ELSE
      FOR B IN
        (SELECT a.loss_exp_desc, -SUM(b.deductible_amt) amount,
                NVL(b.deductible_rt,0), NVL(a.comp_sw, '-') comp_sw ,
                b.deductible_rt ded_rate
           FROM GIIS_LOSS_EXP a, GIPI_DEDUCTIBLES b, 
                GIPI_POLBASIC c 
          WHERE a.line_cd       = c.line_cd 
            AND a.line_cd       = b.ded_line_cd 
            AND a.subline_cd    = b.ded_subline_cd 
            AND a.loss_exp_cd   = b.ded_deductible_cd 
            AND a.loss_exp_cd   = p_loss_exp_cd
            AND a.loss_exp_type = p_payee_type 
            AND a.line_cd       = p_line_cd 
            AND a.subline_cd    = p_subline_cd 
            AND b.policy_id     = c.policy_id 
            AND c.line_cd       = p_line_cd 
            AND c.subline_cd    = p_subline_cd 
            AND c.iss_cd        = p_pol_iss_cd 
            AND c.issue_yy      = p_issue_yy 
            AND c.pol_seq_no    = p_pol_seq_no 
            AND c.renew_no      = p_renew_no 
            AND c.expiry_date  >= p_loss_date 
            --AND c.dist_flag     = '3' 
            AND c.pol_flag      IN ('1','2','3','X') 
            AND b.item_no       = p_item_no 
            AND b.peril_cd      IN (p_peril_cd,0) 
            AND nvl(b.deductible_amt,0) > 0 
          GROUP BY a.loss_exp_desc, NVL(b.deductible_rt,0), 
                   NVL(a.comp_sw, '-'), b.deductible_rt) 
      LOOP
        v_dtl_amt      := b.amount;
        v_nbt_comp_sw  := b.comp_sw; 
        v_dsp_exp_desc := b.loss_exp_desc;
        valid_sw := 'Y';
        EXIT;
      END LOOP;
       
      IF valid_sw = 'N' THEN 
         p_msg_alert := 'Invalid Loss Expense code.';
      END IF;
      
    END IF;
  
    p_dsp_exp_desc   := v_dsp_exp_desc;
    p_nbt_comp_sw    := v_nbt_comp_sw;
    p_original_sw    := v_original_sw;
    p_ded_base_amt   := v_ded_base_amt;
    p_dtl_amt        := v_dtl_amt;
      
    RETURN;
  
END populate_loss_exp_cd_dtl;
/


