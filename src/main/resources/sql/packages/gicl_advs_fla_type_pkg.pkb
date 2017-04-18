CREATE OR REPLACE PACKAGE BODY CPI.GICL_ADVS_FLA_TYPE_PKG AS

    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 02, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Populates table GICL_ADVS_FLA_TYPE
    */
    PROCEDURE populate_advs_fla_type(
        p_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE
    )
    AS
    BEGIN
        IF p_adv_fla_id IS NOT NULL THEN
            INSERT INTO GICL_ADVS_FLA_TYPE(claim_id, grp_seq_no, fla_id, payee_type, loss_shr_amt, exp_shr_amt)
            SELECT e.claim_id, e.grp_seq_no, e.fla_id, c.payee_type,
                   SUM(DECODE(c.payee_type,'L', a.shr_le_ri_adv_amt,0)) loss_shr_amt, 
                   SUM(DECODE(c.payee_type,'E', a.shr_le_ri_adv_amt,0)) exp_shr_amt                   
              FROM GICL_LOSS_EXP_RIDS a,
                   GICL_LOSS_EXP_DS b,
                   GICL_CLM_LOSS_EXP c, 
                   GICL_ADVICE d,
                   GICL_ADVS_FLA e 
             WHERE 1=1 
               AND a.claim_id       = b.claim_id 
               AND a.clm_loss_id    = b.clm_loss_id 
               AND a.clm_dist_no    = b.clm_dist_no 
               AND a.grp_seq_no     = b.grp_seq_no 
               AND a.ri_cd          = e.ri_cd
               AND b.claim_id       = c.claim_id 
               AND b.clm_loss_id    = c.clm_loss_id 
               AND NVL(b.negate_tag,'N')  <> 'Y' 
               AND c.claim_id       = d.claim_id 
               AND c.advice_id      = d.advice_id 
               AND d.claim_id       = e.claim_id 
               AND d.adv_fla_id     = e.adv_fla_id 
               AND e.adv_fla_id     = p_adv_fla_id
               AND e.grp_seq_no     = b.grp_seq_no
             GROUP BY e.claim_id, e.grp_seq_no, e.fla_id, c.payee_type;
        END IF;
    END;

END GICL_ADVS_FLA_TYPE_PKG;
/


