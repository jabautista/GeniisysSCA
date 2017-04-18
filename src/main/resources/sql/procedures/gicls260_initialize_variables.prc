DROP PROCEDURE CPI.GICLS260_INITIALIZE_VARIABLES;

CREATE OR REPLACE PROCEDURE CPI.GICLS260_INITIALIZE_VARIABLES (
    p_claim_id            IN   GICL_CLAIMS.claim_id%TYPE,
    p_clm_reserve_exist   OUT  VARCHAR2,
    p_loss_exp_exist      OUT  VARCHAR2,
    p_payees_exist        OUT  VARCHAR2,
    p_loss_recovery_exist OUT  VARCHAR2,
    p_giisp_line_cd       OUT  giis_parameters.param_value_v%TYPE) AS
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.20.2013
    **  Reference By  : GICLS260 - Claim Information
    **  Description   : Gets values needed during initialization of GICLS260
    */

    v_clm_reserve_exist     VARCHAR2(1):= 'N';
    v_loss_exp_exist        VARCHAR2(1):= 'N';
    v_payees_exist          VARCHAR2(1):= 'N';
    v_loss_recovery_exist   VARCHAR2(1):= 'N';
    v_giisp_line_cd         giis_parameters.param_value_v%TYPE := giisp.v('MARINE CARGO LINE CODE');

  BEGIN
        FOR rec IN(SELECT NVL(recovery_sw,'N') recovery_sw
                     FROM GICL_CLAIMS
                   WHERE claim_id = p_claim_id)
        LOOP
            v_loss_recovery_exist := rec.recovery_sw;
            EXIT;
        END LOOP;
                
        /* check if there is/are record/s existing in gicl_clm_claimant  */
        FOR chk_l IN(SELECT claim_id
                     FROM GICL_CLM_CLAIMANT
                    WHERE claim_id = p_claim_id)
        LOOP
           v_payees_exist := 'Y';
           EXIT; 
        END LOOP;
                
        IF NVL(v_payees_exist, 'N') != 'Y' THEN
           
           FOR chk_e IN(SELECT claim_id
                          FROM GICL_EXP_PAYEES
                         WHERE claim_id = p_claim_id)
           LOOP
             v_payees_exist := 'Y';
             EXIT;
           END LOOP;
           
        END IF;
            
        /* check if there is/are detail/s of the claim in gicl_clm_reserve.*/
        FOR res IN(SELECT claim_id
                     FROM GICL_CLM_RESERVE
                    WHERE claim_id = p_claim_id) 
        LOOP
           v_clm_reserve_exist := 'Y';
           EXIT;
        END LOOP;
            
        /* check existence of claim in gicl_clm_loss_exp */
        FOR chk IN(SELECT claim_id
                     FROM GICL_CLM_LOSS_EXP
                    WHERE claim_id = p_claim_id)
        LOOP
           v_loss_exp_exist := 'Y';
           EXIT;
        END LOOP;
            
        p_clm_reserve_exist    := v_clm_reserve_exist;  
        p_loss_exp_exist       := v_loss_exp_exist;     
        p_payees_exist         := v_payees_exist;       
        p_loss_recovery_exist  := v_loss_recovery_exist;
        p_giisp_line_cd        := v_giisp_line_cd; -- bonok :: 10.25.2013
       
  END GICLS260_INITIALIZE_VARIABLES;
/


