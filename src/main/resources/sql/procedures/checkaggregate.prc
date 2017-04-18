DROP PROCEDURE CPI.CHECKAGGREGATE;

CREATE OR REPLACE PROCEDURE CPI.CHECKAGGREGATE
(p_loss_exp_cd     IN     GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
 p_line_cd         IN     GICL_CLAIMS.line_cd%TYPE,
 p_subline_cd      IN     GICL_CLAIMS.subline_cd%TYPE,
 p_pol_iss_cd      IN     GICL_CLAIMS.pol_iss_cd%TYPE,
 p_issue_yy        IN     GICL_CLAIMS.issue_yy%TYPE,
 p_pol_seq_no      IN     GICL_CLAIMS.pol_seq_no%TYPE,
 p_renew_no        IN     GICL_CLAIMS.renew_no%TYPE,
 p_nbt_ded_agg_sw  IN     VARCHAR2,
 p_agg_sw          IN     VARCHAR2,
 p_v_sumDedA       OUT    GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
 p_msg_alert       OUT    VARCHAR2) 

IS

/*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.27.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes CHECKAGGREGATE Program unit in GICLS030
 **                  
 */
    
  v_pd BOOLEAN := TRUE;
  v_claimNo VARCHAR2(30);
  
BEGIN
    
  IF NVL(p_nbt_ded_agg_sw,'N') = 'Y' OR NVL(p_agg_sw,'N') = 'Y'THEN

     FOR i IN (SELECT Get_Claim_Number(b.claim_id) claim_no
                 FROM GICL_LOSS_EXP_DTL A,
                      GICL_CLAIMS b
                 WHERE loss_exp_cd  = p_loss_exp_cd
                   AND b.line_cd    = p_line_cd
                   AND b.subline_cd = p_subline_cd
                   AND b.pol_iss_cd = p_pol_iss_cd
                   AND b.issue_yy   = p_issue_yy
                   AND b.pol_seq_no = p_pol_seq_no
                   AND b.renew_no   = p_renew_no
                   AND b.claim_id   = a.claim_id
                   AND EXISTS (SELECT 1
                                 FROM GICL_CLM_LOSS_EXP
                                WHERE claim_id = a.claim_id
                                  AND NVL(dist_sw,'N') = 'Y' 
                                  AND clm_loss_id = a.clm_loss_id
                                  AND NVL(cancel_sw,'N') = 'N'
                                  AND tran_id IS NULL))
     LOOP
         v_pd := FALSE;
         v_claimNo := i.claim_no;
         EXIT;
     END LOOP;
         
     IF NOT v_pd THEN
          /*clear_record; -- aaron 060809
          IF variables.v_fromchekd = 'Y' THEN
            go_block('c011');
          END IF;*/
          p_msg_alert := 'Aggregate deductible is currently used in '||v_claimNo||'. Please settle the claim first.';
         
     ELSIF v_pd THEN
          FOR x IN (SELECT SUM(ABS(dtl_amt)) ded_amt
                       FROM GICL_LOSS_EXP_DTL A,
                            GICL_CLAIMS b
                      WHERE loss_exp_cd  = p_loss_exp_cd
                        AND b.line_cd    = p_line_cd
                        AND b.subline_cd = p_subline_cd
                        AND b.pol_iss_cd = p_pol_iss_cd
                        AND b.issue_yy   = p_issue_yy
                        AND b.pol_seq_no = p_pol_seq_no
                        AND b.renew_no   = p_renew_no
                        AND b.claim_id   = a.claim_id
                        AND EXISTS (SELECT 1
                                      FROM GICL_CLM_LOSS_EXP
                                     WHERE claim_id = a.claim_id
                                       AND clm_loss_id = a.clm_loss_id
                                       AND tran_id IS NOT NULL))
          LOOP
            p_v_sumDedA := NVL(x.ded_amt,0);
          END LOOP;
     END IF;
  END IF;
  
END checkAggregate;
/


