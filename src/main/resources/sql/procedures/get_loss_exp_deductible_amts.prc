DROP PROCEDURE CPI.GET_LOSS_EXP_DEDUCTIBLE_AMTS;

CREATE OR REPLACE PROCEDURE CPI.GET_LOSS_EXP_DEDUCTIBLE_AMTS
(p_claim_id             IN      GICL_CLAIMS.claim_id%TYPE,
 p_loss_exp_cd          IN      GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
 p_dtl_amt              IN OUT  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
 p_ded_base_amt         IN OUT  GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
 p_no_of_units          IN      GICL_LOSS_EXP_DTL.no_of_units%TYPE,
 p_nbt_deductible_type  IN      GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
 p_ded_rate             IN OUT  GIIS_DEDUCTIBLE_DESC.deductible_rt%TYPE,
 p_nbt_min_amt          IN      GIIS_DEDUCTIBLE_DESC.min_amt%TYPE,
 p_nbt_max_amt          IN      GIIS_DEDUCTIBLE_DESC.max_amt%TYPE,
 p_nbt_range_sw         IN      GIIS_DEDUCTIBLE_DESC.range_sw%TYPE,
 p_nbt_ded_aggregate_sw IN      GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
 p_nbt_ceiling_sw       IN      GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
 p_param_ded_amt        IN      GIPI_DEDUCTIBLES.deductible_amt%TYPE,
 p_ded_loss_exp_cd      IN      GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,  
 p_item_no              IN      GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd             IN      GICL_ITEM_PERIL.peril_cd%TYPE,
 p_grouped_item_no      IN      GICL_ITEM_PERIL.grouped_item_no%TYPE,
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
 p_msg_alert            OUT     VARCHAR2) IS
 
 
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 03.30.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes WHEN_VALIDATE_ITEM trigger of NO_OF_UNITS, 
 **                 DED_RATE, DED_BASE_AMT fields in C013_D Block of GICLS030
 **                  
 */ 
 
 
 v_sumDedA              NUMBER;
 v_sumDedC              NUMBER;
 v_cur_deductible_amt   NUMBER;
 v_allowable_ded        NUMBER;
 v_exhaust              VARCHAR2(5);
 
BEGIN
    -------check aggregate----
     IF NVL(p_nbt_ded_aggregate_sw,'N') = 'Y' THEN
       CHECKAGGREGATE(p_loss_exp_cd, p_line_cd, p_subline_cd, p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                      p_renew_no,    p_nbt_ded_aggregate_sw,  p_nbt_ded_aggregate_sw, v_sumDedA, p_msg_alert);
     END IF;
     
     -------check ceiling-----
     IF NVL(p_nbt_ceiling_sw,'N') = 'Y' THEN
       CHECKCEILING(p_nbt_ceiling_sw,   p_claim_id,          p_loss_exp_cd,    p_item_no,       
                    p_peril_cd,         p_grouped_item_no,   p_param_ded_amt,  v_sumDedC,        
                    v_allowable_ded,    v_exhaust,           p_msg_alert);
     END IF;
     
     v_cur_deductible_amt := p_dtl_amt;
     
     VALIDATE_DED2(p_dtl_amt,         p_ded_base_amt, p_no_of_units,  p_nbt_deductible_type,  p_ded_rate,
                   p_nbt_min_amt,     p_nbt_max_amt,  p_nbt_range_sw, p_nbt_ded_aggregate_sw, p_nbt_ceiling_sw,
                   p_ded_loss_exp_cd, p_item_no,      p_peril_cd,     p_payee_type,           p_line_cd,
                   p_subline_cd,      p_pol_iss_cd,   p_issue_yy,     p_pol_seq_no,           p_renew_no,
                   p_loss_date,       p_pol_eff_date, p_expiry_date,  v_sumDedA,              v_sumDedc,  v_cur_deductible_amt);
                   
     IF p_nbt_deductible_type = 'F' AND (NVL(p_nbt_ded_aggregate_sw, 'N') = 'Y' OR NVL(p_nbt_ceiling_sw, 'N') = 'Y') THEN
        
        IF NVL(v_exhaust,'N') = 'Y' THEN
           p_msg_alert := 'You cannot use this deductible.  This deductible has been exhausted/used up.';   

        END IF;	  
        
        IF ABS(p_dtl_amt) > ABS(v_allowable_ded) THEN
            p_msg_alert := 'This deductible has exceeded the allowable amount.';
        END IF;
        
     END IF;
     
END get_loss_exp_deductible_amts;
/


