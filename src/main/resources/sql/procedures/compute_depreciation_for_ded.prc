DROP PROCEDURE CPI.COMPUTE_DEPRECIATION_FOR_DED;

CREATE OR REPLACE PROCEDURE CPI.compute_depreciation_for_ded
(p_claim_subline_cd     IN      GICL_CLAIMS.subline_cd%TYPE,
 p_claim_id             IN      GICL_ITEM_PERIL.claim_id%TYPE,
 p_clm_loss_id          IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_line_cd              IN      GICL_LOSS_EXP_DTL.line_cd%TYPE,
 p_subline_cd           IN      GICL_LOSS_EXP_DTL.subline_cd%TYPE,
 p_loss_exp_type        IN      GICL_LOSS_EXP_DTL.loss_exp_type%TYPE, 
 p_item_no              IN      GICL_ITEM_PERIL.item_no%TYPE,
 p_user_id              IN      GIIS_USERS.user_id%TYPE,
 p_msg_alert            OUT     VARCHAR2 ) AS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 03.07.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Compute depreciation for line MC 
**                  for deductible canvas in GICLS030
*/
  
  v_max_fix_age              NUMBER; -- store the max age for all part
  v_max_special_age          NUMBER; -- store the max age for all part
  v_max_fix_rate             GICL_MC_DEPRECIATION.rate%TYPE; -- store the rate of depreciation for all part (for maximum age)    
  v_max_special_rate         GICL_MC_DEPRECIATION.rate%TYPE; -- store the rate of depreciation per part (for maximum age)
  v_fix_rate                 GICL_MC_DEPRECIATION.rate%TYPE; -- store the rate of depreciation for all part    
  v_special_rate             GICL_MC_DEPRECIATION.rate%TYPE; -- store the rate of depreciation per part
  v_age                      NUMBER; -- store the computed age of vehicle based on the model year
  v_insert_sw                VARCHAR2(1) := 'N'; -- toggle switch that will indicate if there are records inserted
  v_depreciation_cd          VARCHAR2(500) := GIISP.V('MC_DEPRECIATION_CD');

BEGIN
  
  -- get rate for maximum age for all parts
  FOR get_max_age IN (
    SELECT mc_year_fr, rate
      FROM GICL_MC_DEPRECIATION
     WHERE subline_cd =  p_claim_subline_cd
       AND special_part_cd IS NULL
     ORDER BY mc_year_fr DESC)
  LOOP
    v_max_fix_age  := get_max_age.mc_year_fr;
    v_max_fix_rate := get_max_age.rate;
    EXIT;
  END LOOP;
  
  -- compute age of vehicle  
  FOR get_age IN(
    SELECT model_year, ( TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(model_year)) vehicle_age
      FROM GICL_MOTOR_CAR_DTL
     WHERE claim_id = p_claim_id
       AND item_no  = p_item_no)
  LOOP
    -- if item model year is null disallow computation 
    
    IF get_age.model_year IS NULL THEN
       p_msg_alert := 'Depreciation cannot be computed if item model year is null.';
       RETURN;
    ELSE
       v_age := get_age.vehicle_age;
    END IF;
    
    IF v_age <= v_max_fix_age THEN
       
       -- retrieve depreciation rate for all part(depends on vehicle age and subline)
       
       FOR get_fix_rate IN (
         SELECT rate
           FROM GICL_MC_DEPRECIATION
          WHERE subline_cd =  p_claim_subline_cd
            AND mc_year_fr >= v_age
            AND special_part_cd IS NULL
          ORDER BY mc_year_fr ASC)
       LOOP
         v_fix_rate := get_fix_rate.rate;
         EXIT;
       END LOOP;
       
    ELSE
       v_fix_rate := v_max_fix_rate;
    END IF;
    
    -- retrieve amount anf los_exp_cd of original part(s)
    
    FOR get_orig IN (
      SELECT loss_exp_cd, dtl_amt
        FROM GICL_LOSS_EXP_DTL
       WHERE claim_id          = p_claim_id  
         AND clm_loss_id       = p_clm_loss_id
         AND NVL(original_sw, 'N') = 'Y')
    LOOP 
      v_max_special_rate := NULL;
      v_max_special_age  := NULL;

      FOR get_max_special IN (
        SELECT mc_year_fr, rate
          FROM GICL_MC_DEPRECIATION
         WHERE subline_cd =  p_claim_subline_cd
           AND special_part_cd = get_orig.loss_exp_cd
        ORDER BY mc_year_fr DESC)
      LOOP
        v_max_special_rate := NULL;
        v_max_special_age  := NULL;
        EXIT;
      END LOOP;
      
      IF NVL(v_max_special_age,0) <= v_age  THEN
         -- check if part has a special rate
         v_special_rate := NULL;
         
         FOR get_special_rate IN (
           
           SELECT rate
             FROM GICL_MC_DEPRECIATION
            WHERE subline_cd =  p_claim_subline_cd
              AND mc_year_fr <= v_age
              AND special_part_cd = get_orig.loss_exp_cd
           ORDER BY mc_year_fr ASC)
        LOOP
          v_special_rate := get_special_rate.rate;
          EXIT;
        END LOOP;
      
      ELSIF v_max_special_age IS NOT NULL THEN
         v_special_rate := v_max_special_rate;
      END IF;
      
      -- if depreciation rate > 0 then insert detail information for depreciation
      
      IF NVL(v_special_rate,NVL(v_fix_rate,0)) > 0 THEN
           
           INSERT INTO GICL_LOSS_EXP_DED_DTL
          (claim_id,               clm_loss_id,            line_cd, 
           subline_cd,             loss_exp_type,          ded_cd,
           loss_exp_cd,            loss_amt,               ded_rate,               
           user_id,                last_update, 
           ded_amt)
           VALUES
          (p_claim_id,             p_clm_loss_id,          p_line_cd,
           p_subline_cd,           p_loss_exp_type,        v_depreciation_cd,
           get_orig.loss_exp_cd,   get_orig.dtl_amt,       NVL(v_special_rate,v_fix_rate),
           p_user_id,              SYSDATE,
           get_orig.dtl_amt *( NVL(v_special_rate,v_fix_rate)/100));
       
        --update insert_sw to indicate that record had been inserted
        v_insert_sw := 'Y';
      END IF;
      
      END LOOP;

    -- if no record(s) had been inserted then advice the user
    IF v_insert_sw = 'N' THEN
       p_msg_alert := 'There is no available depreciation rate for the parts tagged as original.';
       RETURN;
    END IF;
    
    -- if insert of detail record(s)is performed then create record to the main table
    FOR insert_main IN(
      SELECT SUM(NVL(loss_amt,0)) loss, SUM(NVL(ded_amt,0)) ded_amt
        FROM GICL_LOSS_EXP_DED_DTL
       WHERE claim_id = p_claim_id
         AND clm_loss_id = p_clm_loss_id
         AND ded_cd = v_depreciation_cd)     
    LOOP        
      INSERT INTO GICL_LOSS_EXP_DTL
        (claim_id,               clm_loss_id,          line_cd, 
         loss_exp_type,          loss_exp_cd,          dtl_amt,               
         ded_base_amt,           no_of_units,          ded_loss_exp_cd,
         ded_rate)
      VALUES
        (p_claim_id,             p_clm_loss_id,        p_line_cd,
         p_loss_exp_type,    v_depreciation_cd,    -insert_main.ded_amt,
         insert_main.loss,       1,                    'ORIG%',
         (insert_main.ded_amt/insert_main.loss)* 100); 
    END LOOP;
    
    -- update corresponding field  
    GICL_CLM_LOSS_EXP_PKG.upd_clm_loss_exp_amts_with_tax(p_claim_id, p_clm_loss_id, p_user_id);

  END LOOP;
   
END;
/


