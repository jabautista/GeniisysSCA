DROP PROCEDURE CPI.VALIDATE_DED;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_DED 
(p_dtl_amt              IN OUT  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
 p_ded_base_amt         IN OUT  GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
 p_no_of_units          IN      GICL_LOSS_EXP_DTL.no_of_units%TYPE,
 p_nbt_deductible_type  IN      GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
 p_ded_rate             IN OUT  GIIS_DEDUCTIBLE_DESC.deductible_rt%TYPE,
 p_nbt_min_amt          IN      GIIS_DEDUCTIBLE_DESC.min_amt%TYPE,
 p_nbt_max_amt          IN      GIIS_DEDUCTIBLE_DESC.max_amt%TYPE,
 p_nbt_range_sw         IN      GIIS_DEDUCTIBLE_DESC.range_sw%TYPE,
 p_nbt_ded_aggregate_sw IN      GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
 p_nbt_ceiling_sw       IN      GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
 p_ded_loss_exp_cd      IN      GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,  
 p_item_no              IN      GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd             IN      GICL_ITEM_PERIL.peril_cd%TYPE,
 p_payee_type           IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
 p_line_cd              IN      GICL_CLAIMS.line_cd%TYPE,
 p_subline_cd           IN      GICL_CLAIMS.subline_cd%TYPE,
 p_pol_iss_cd           IN      GICL_CLAIMS.pol_iss_cd%TYPE,
 p_issue_yy             IN      GICL_CLAIMS.issue_yy%TYPE,
 p_pol_seq_no           IN      GICL_CLAIMS.pol_seq_no%TYPE,
 p_renew_no             IN      GICL_CLAIMS.renew_no%TYPE,
 p_loss_date            IN      GICL_CLAIMS.loss_date%TYPE,
 p_pol_eff_date         IN      GICL_CLAIMS.pol_eff_date%TYPE,
 p_expiry_date          IN      GICL_CLAIMS.expiry_date%TYPE,
 p_v_sumDedA            IN      NUMBER,
 p_v_sumDedc            IN      NUMBER) IS
 
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 03.19.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes VALIDATE_DED Program unit in GICLS030
 **                  
 */ 
  
  v_dtl_amt            NUMBER := 0;
  v_dtl_amt2           NUMBER := 0;
  v_tsi_amt            GIRI_BASIC_INFO_ITEM_SUM_V.tsi_amt%TYPE;
  v_dist_flag          GIIS_PARAMETERS.param_value_v%TYPE;


BEGIN

  IF p_nbt_deductible_type IS NULL AND (p_ded_rate = 0 OR p_ded_rate > 0) THEN
       
     IF NVL(p_ded_rate, 0) != 0 THEN
        p_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))* p_no_of_units *(-1);
     ELSE
        p_dtl_amt := p_no_of_units * p_ded_base_amt * (-1);
     END IF;
       
  ELSIF p_nbt_deductible_type IS NOT NULL THEN
     FOR rec IN
      (SELECT param_value_v
         FROM GIIS_PARAMETERS
        WHERE param_name = 'DISTRIBUTED')
     LOOP
      v_dist_flag := rec.param_value_v;
     END LOOP;
        
     BEGIN
      SELECT SUM(T1.TSI_AMT) TSI_AMT 
        INTO v_tsi_amt
        FROM GIPI_POLBASIC T2, GIPI_ITEM T3, GIPI_ITMPERIL T1,
             GIUW_POL_DIST T4
       WHERE T2.policy_id = T3.policy_id
         AND T3.policy_id = T1.policy_id 
         AND T3.item_no   = T1.item_no
         AND T2.policy_id = T4.policy_id
         AND TRUNC(DECODE(TRUNC(t4.eff_date), TRUNC(t2.eff_date),
             DECODE(TRUNC(t2.eff_date), TRUNC(t2.incept_date), p_pol_eff_date, t2.eff_date ), t4.eff_date)) 
             <= TRUNC(p_loss_date)
         AND TRUNC(DECODE(TRUNC(t4.expiry_date), TRUNC(t2.expiry_date),
             DECODE(NVL(t2.endt_expiry_date, t2.expiry_date),
             t2.expiry_date, p_expiry_date, t2.endt_expiry_date), t4.expiry_date))
             >= TRUNC(p_loss_date)
         AND T1.item_no    = p_item_no 
         AND T1.peril_cd   = p_peril_cd
         AND T2.line_cd    = p_line_cd
         AND T2.subline_cd = p_subline_cd
         AND T2.iss_cd     = p_pol_iss_cd
         AND T2.issue_yy   = p_issue_yy
         AND T2.pol_seq_no = p_pol_seq_no
         AND T2.renew_no   = p_renew_no
         AND t2.pol_flag   IN ('1','2','3','X')
         AND T4.dist_flag  = v_dist_flag; 
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,'The TSI for this policy is Zero...');
     END;
                 
     IF p_nbt_deductible_type = 'F' THEN--Fixed Amount
              
          p_ded_rate     := 0;
                  
          IF NVL(p_nbt_ded_aggregate_sw,'N') = 'Y' THEN
            p_ded_base_amt := p_dtl_amt - NVL(p_v_sumdedA,0);  
                  
          ELSIF NVL(p_nbt_ceiling_sw,'N') = 'Y' THEN
            p_ded_base_amt := p_dtl_amt - NVL(p_v_sumDedC,0);
                  
          ELSE
            p_ded_base_amt := p_dtl_amt;
          END IF;
                  
          p_dtl_amt      := p_ded_base_amt*p_no_of_units * (-1);

     ELSIF p_nbt_deductible_type = 'L' THEN--% of Loss Amount
                 
          IF p_ded_loss_exp_cd IS NULL THEN
            p_dtl_amt := 0;
                 
          ELSIF p_ded_loss_exp_cd IS NOT NULL THEN
             IF NVL(p_ded_rate, 0) != 0 THEN
                v_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))*p_no_of_units;
                     
             ELSE
                v_dtl_amt := p_ded_base_amt*p_no_of_units;
                        
             END IF;
                     
             IF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NOT NULL THEN
                        
                IF p_nbt_range_sw = 'H' THEN --Range: Higher 
                   v_dtl_amt2   := GREATEST(ABS(v_dtl_amt), ABS(p_nbt_min_amt));
                   p_dtl_amt    := LEAST(ABS(v_dtl_amt2), ABS(p_nbt_max_amt)) * (-1);
                ELSIF p_nbt_range_sw = 'L' THEN --Range: Lower
                   v_dtl_amt2   := LEAST(ABS(v_dtl_amt), ABS(p_nbt_min_amt));
                   p_dtl_amt    := LEAST(ABS(v_dtl_amt2),ABS(p_nbt_max_amt)) * (-1);
                ELSE--Range: No Range
                   p_dtl_amt    := p_nbt_max_amt * (-1);
                END IF;
                        
             ELSIF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NULL THEN
                p_dtl_amt := GREATEST(ABS(v_dtl_amt), ABS(p_nbt_min_amt)) * (-1);
                        
             ELSIF p_nbt_max_amt IS NOT NULL AND p_nbt_min_amt IS NULL THEN
                p_dtl_amt := LEAST(ABS(v_dtl_amt), ABS(p_nbt_max_amt)) * (-1);
                        
             ELSIF p_nbt_min_amt IS NULL AND p_nbt_max_amt IS NULL THEN
                p_dtl_amt := v_dtl_amt * (-1);
             END IF;
          END IF;
         
     ELSIF p_nbt_deductible_type = 'T' THEN--% of TSI Amount
         p_ded_base_amt := v_tsi_amt;
        -- :parameter.p_ded_tsi_amt := v_tsi_amt;
         p_dtl_amt := p_dtl_amt * p_no_of_units * (-1);
         
     ELSIF p_nbt_deductible_type = 'I' THEN--% of the insured value at the time of loss
         p_ded_base_amt := v_tsi_amt;
         --:parameter.p_ded_tsi_amt := v_tsi_amt;
         IF NVL(p_ded_rate, 0) != 0 THEN
            v_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))*p_no_of_units * (-1);
                
         ELSE
            v_dtl_amt := p_ded_base_amt*p_no_of_units * (-1);
         END IF;
             
         v_dtl_amt := v_dtl_amt * -1;
             
         IF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NOT NULL THEN
             
           IF p_nbt_range_sw = 'H' THEN--Range: Higher 
              v_dtl_amt2    := GREATEST(ABS(v_dtl_amt), ABS(p_nbt_min_amt));
              p_dtl_amt     := LEAST(ABS(v_dtl_amt2), ABS(p_nbt_max_amt)) * (-1);
               
           ELSIF p_nbt_range_sw = 'L' THEN--Range: Lower
              v_dtl_amt2    := LEAST(ABS(v_dtl_amt), ABS(p_nbt_min_amt));
              p_dtl_amt     := LEAST(abs(v_dtl_amt2),ABS(p_nbt_max_amt)) * (-1);
           ELSE--Range: No Range
              p_dtl_amt     := p_nbt_max_amt * (-1);
           END IF;
             
         ELSIF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NULL THEN
           p_dtl_amt := GREATEST(ABS(v_dtl_amt), ABS(p_nbt_min_amt)) * (-1);
             
         ELSIF p_nbt_max_amt IS NOT NULL AND p_nbt_min_amt IS NULL THEN
           p_dtl_amt := LEAST(ABS(v_dtl_amt), ABS(p_nbt_max_amt)) * (-1);
             
         ELSIF p_nbt_min_amt IS NULL AND p_nbt_max_amt IS NULL THEN
           p_dtl_amt := v_dtl_amt * (-1);
         END IF;
     END IF;
  END IF;

  /*IF NVL(p_dtl_amt, 0) != NVL(p_cur_ded_dtl_amt, 0) THEN
     p_tot_loss_amt := NVL(p_tot_loss_amt, 0) + NVL(p_dtl_amt, 0) - NVL(p_cur_ded_dtl_amt, 0);
  END IF; */ 
END;
/


