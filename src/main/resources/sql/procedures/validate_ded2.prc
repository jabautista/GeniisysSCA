DROP PROCEDURE CPI.VALIDATE_DED2;

CREATE OR REPLACE PROCEDURE CPI.validate_ded2
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
 p_v_sumDedc            IN      NUMBER,
 p_cur_deductible_amt   IN      NUMBER) IS

/*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 03.19.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes VALIDATE_DED2 Program unit in GICLS030
 **                  
 */ 

  v_dtl_amt            NUMBER := 0;
  v_dtl_amt2           NUMBER := 0;

BEGIN

  IF SIGN(p_dtl_amt) != -1 AND p_nbt_deductible_type IS NOT NULL THEN 
     VALIDATE_DED(p_dtl_amt,         p_ded_base_amt,    p_no_of_units,    p_nbt_deductible_type,  p_ded_rate, 
                  p_nbt_min_amt,     p_nbt_max_amt,     p_nbt_range_sw,   p_nbt_ded_aggregate_sw, p_nbt_ceiling_sw,
                  p_ded_loss_exp_cd, p_item_no,         p_peril_cd,       p_payee_type,           p_line_cd,              
                  p_subline_cd,      p_pol_iss_cd,      p_issue_yy,       p_pol_seq_no,           p_renew_no,             
                  p_loss_date,       p_pol_eff_date,    p_expiry_date,    p_v_sumDedA,            p_v_sumDedc);
                  
  ELSIF p_nbt_deductible_type IS NULL AND (p_ded_rate = 0 OR p_ded_rate > 0) THEN 
       IF NVL(p_ded_rate, 0) != 0 THEN
          p_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))*p_no_of_units *(-1);
       ELSE
          p_dtl_amt := p_no_of_units * p_ded_base_amt * (-1);
       END IF;
       
       /*IF NVL(p_dtl_amt, 0) != NVL(p_cur_ded_dtl_amt, 0) THEN
          p_tot_loss_amt := NVL(p_tot_loss_amt, 0) + NVL(p_dtl_amt, 0) - NVL(p_cur_ded_dtl_amt, 0);
       END IF;*/
         
  ELSIF (SIGN(p_dtl_amt) = -1 OR p_dtl_amt IS NULL) AND p_nbt_deductible_type IS NOT NULL THEN
         
     IF p_nbt_deductible_type = 'F' THEN--Fixed Amount
              
          p_dtl_amt      := p_ded_base_amt*p_no_of_units * (-1);
               
     ELSIF p_nbt_deductible_type = 'L' THEN--% of Loss Amount
            
        IF NVL(p_ded_rate, 0) != 0 THEN
           v_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))* p_no_of_units * (-1);
        ELSE
           IF SIGN(p_dtl_amt) != -1 THEN
                 v_dtl_amt := p_no_of_units * p_ded_base_amt * (-1);
           ELSIF SIGN(p_dtl_amt) = -1 THEN
                 v_dtl_amt := p_no_of_units * p_ded_base_amt;
           END IF;
        END IF;
              
          v_dtl_amt := v_dtl_amt * (-1);
          p_dtl_amt := p_dtl_amt * (-1);
              
        IF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NOT NULL THEN
               
           IF p_nbt_range_sw = 'H' THEN--Range: Higher 
              v_dtl_amt2      := GREATEST(ABS(v_dtl_amt),ABS(p_nbt_min_amt));
              p_dtl_amt       := LEAST(ABS(v_dtl_amt2),ABS(p_nbt_max_amt)) * (-1);
           ELSIF p_nbt_range_sw = 'L' THEN--Range: Lower
              v_dtl_amt2      := LEAST(ABS(v_dtl_amt),ABS(p_nbt_min_amt));
              p_dtl_amt       := LEAST(ABS(v_dtl_amt2),ABS(p_nbt_max_amt)) * (-1);
           ELSE--Range: No Range
              p_dtl_amt       := p_nbt_max_amt * (-1);
           END IF;
            
        ELSIF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NULL THEN
           p_dtl_amt := GREATEST(ABS(v_dtl_amt),ABS(p_nbt_min_amt)) * (-1);
                  
        ELSIF p_nbt_max_amt IS NOT NULL AND p_nbt_min_amt IS NULL THEN
           p_dtl_amt := LEAST(ABS(v_dtl_amt),ABS(p_nbt_max_amt)) * (-1);
               
        ELSIF p_nbt_min_amt IS NULL AND p_nbt_max_amt IS NULL THEN
           p_dtl_amt := v_dtl_amt * (-1);
        END IF;
            
     ELSIF p_nbt_deductible_type = 'T' THEN--% of TSI Amount
            
        IF SIGN(p_dtl_amt) != -1 THEN
           p_dtl_amt := p_cur_deductible_amt * p_no_of_units * (-1);
        ELSIF SIGN(p_dtl_amt) = -1 THEN
           p_dtl_amt := p_cur_deductible_amt * p_no_of_units;
        END IF;
            
     ELSIF p_nbt_deductible_type = 'I' THEN--% of the insured value at the time of loss
        IF NVL(p_ded_rate, 0) != 0 THEN
            IF SIGN(p_dtl_amt) != -1 THEN
               v_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))* p_no_of_units * (-1);
                
            ELSIF SIGN(p_dtl_amt) = -1 THEN
               v_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))* p_no_of_units;
                
            ELSIF p_dtl_amt IS NULL THEN
                  v_dtl_amt := (p_ded_base_amt*(NVL(p_ded_rate,0)/100))* p_no_of_units;
            END IF;
        ELSE
             v_dtl_amt := p_cur_deductible_amt*p_no_of_units;
        END IF;
            
        v_dtl_amt := v_dtl_amt * (-1);
        
        IF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NOT NULL THEN
             
             IF p_nbt_range_sw = 'H' THEN--Range: Higher 
                v_dtl_amt2      := GREATEST(ABS(v_dtl_amt),ABS(p_nbt_min_amt));
                p_dtl_amt       := LEAST(ABS(v_dtl_amt2),ABS(p_nbt_max_amt)) * (-1);
             
             ELSIF p_nbt_range_sw = 'L' THEN--Range: Lower
                v_dtl_amt2      := LEAST(ABS(v_dtl_amt), ABS(p_nbt_min_amt));
                p_dtl_amt       := LEAST(ABS(v_dtl_amt2),ABS(p_nbt_max_amt)) * (-1);
             
             ELSE--Range: No Range
                p_dtl_amt       := p_nbt_max_amt * (-1);
             END IF;
             
        ELSIF p_nbt_min_amt IS NOT NULL AND p_nbt_max_amt IS NULL THEN
             p_dtl_amt := GREATEST(ABS(v_dtl_amt), ABS(p_nbt_min_amt)) * (-1);
                 
        ELSIF p_nbt_max_amt IS NOT NULL AND p_nbt_min_amt IS NULL THEN
        
             p_dtl_amt := LEAST(ABS(v_dtl_amt),ABS(p_nbt_max_amt)) * (-1);
                 
        ELSIF p_nbt_min_amt IS NULL AND p_nbt_max_amt IS NULL THEN
             p_dtl_amt := v_dtl_amt * (-1);
             
        END IF;
     END IF;
         
     IF SIGN(p_dtl_amt) != -1 THEN
        p_dtl_amt := p_dtl_amt * (-1);
     END IF;
       
     /*IF NVL(p_dtl_amt, 0) != NVL(p_cur_ded_dtl_amt, 0) THEN
       p_tot_loss_amt := NVL(p_tot_loss_amt, 0) + NVL(p_dtl_amt, 0) - NVL(p_cur_ded_dtl_amt, 0);
     END IF;*/
  END IF;

END;
/


