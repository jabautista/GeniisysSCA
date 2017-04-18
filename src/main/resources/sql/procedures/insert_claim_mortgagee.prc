DROP PROCEDURE CPI.INSERT_CLAIM_MORTGAGEE;

CREATE OR REPLACE PROCEDURE CPI.Insert_Claim_Mortgagee
(
  p_item_no      IN gipi_mortgagee.item_no%TYPE,      --determines if the mortgagee is item or policy level  
  p_claim_id     IN gicl_claims.claim_id%TYPE,        
  p_line_cd      IN gipi_polbasic.line_cd%TYPE,       --to get the policy_id 
  p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
  p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
  p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
  p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
  p_renew_no     IN gipi_polbasic.renew_no%TYPE,
  p_loss_date    IN gicl_claims.loss_date%TYPE,
  p_pol_eff_date IN gicl_claims.pol_eff_date%TYPE,
  p_expiry_date  IN gicl_claims.expiry_date%TYPE 
)
IS
  v_endt_seq_no gipi_polbasic.endt_seq_no%TYPE;
  v_mortg_cd   gipi_mortgagee.mortg_cd%TYPE;
  v_iss_cd      gipi_mortgagee.iss_cd%TYPE;
  v_amount     gipi_mortgagee.amount%TYPE; 
  v_delete_sw   gipi_mortgagee.delete_sw%TYPE;
BEGIN
  /*Created by: jen.113005  
  **This procedure will insert records in gicl_mortgagee */
  
  --get the mortgagees of the policy number-- 
  FOR i IN (SELECT DISTINCT gm.mortg_cd mortg_cd, gm.iss_cd iss_cd
              FROM gipi_mortgagee gm, gipi_polbasic gp
       WHERE gm.policy_id  = gp.policy_id
         AND gp.line_cd    = p_line_cd
         AND gp.subline_cd = p_subline_cd
         AND gp.iss_cd     = p_iss_cd
         AND gp.issue_yy   = p_issue_yy
         AND gp.pol_seq_no = p_pol_seq_no
         AND gp.renew_no   = p_renew_no
         AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),p_pol_eff_date,eff_date)) <= p_loss_date
         AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,p_expiry_date,endt_expiry_date)) >= p_loss_date
         AND gm.item_no    = p_item_no)
  LOOP
    --get the latest mortgagee--
    FOR j IN (SELECT gm.mortg_cd mortg_cd, gm.iss_cd iss_cd, gm.amount amount, 
                   gp.endt_seq_no endt_seq_no, NVL(gm.delete_sw,'N') delete_sw 
            FROM gipi_mortgagee gm, gipi_polbasic gp
         WHERE gm.policy_id  = gp.policy_id
           AND gp.line_cd    = p_line_cd
         AND gp.subline_cd = p_subline_cd
                 AND gp.iss_cd     = p_iss_cd
                 AND gp.issue_yy   = p_issue_yy
         AND gp.pol_seq_no = p_pol_seq_no
         AND gp.renew_no   = p_renew_no
         AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),p_pol_eff_date,eff_date)) <= p_loss_date
         AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,p_expiry_date,endt_expiry_date)) >= p_loss_date
         AND gm.item_no    = p_item_no
         AND gm.mortg_cd   = i.mortg_cd
                 AND gm.iss_cd     = i.iss_cd
               ORDER BY eff_date DESC)
  LOOP
    v_delete_sw   := j.delete_sw; 
    v_endt_seq_no := j.endt_seq_no;
    v_mortg_cd    := j.mortg_cd;
    v_iss_cd      := j.iss_cd;
    v_amount      := j.amount;
    EXIT;
  END LOOP;
  
  --backward endt--
  FOR x IN (SELECT gm.mortg_cd mortg_cd, gm.iss_cd iss_cd, gm.amount amount, NVL(gm.delete_sw,'N') delete_sw 
            FROM gipi_mortgagee gm, gipi_polbasic gp
         WHERE gm.policy_id  = gp.policy_id
           AND gp.line_cd    = p_line_cd
         AND gp.subline_cd = p_subline_cd
                 AND gp.iss_cd     = p_iss_cd
                 AND gp.issue_yy   = p_issue_yy
         AND gp.pol_seq_no = p_pol_seq_no
         AND gp.renew_no   = p_renew_no
         AND NVL(gp.back_stat,5) = 2
         AND endt_seq_no > v_endt_seq_no
         AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),p_pol_eff_date,eff_date)) <= p_loss_date
         AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,p_expiry_date,endt_expiry_date)) >= p_loss_date
         AND gm.item_no    = p_item_no
         AND gm.mortg_cd   = v_mortg_cd
                 AND gm.iss_cd     = v_iss_cd
               ORDER BY endt_seq_no DESC)
  LOOP
    v_delete_sw := x.delete_sw;
    v_mortg_cd  := x.mortg_cd;
    v_iss_cd    := x.iss_cd;
    v_amount    := x.amount;
    EXIT;
  END LOOP;
  
  IF v_delete_sw <> 'Y' THEN --insert rec if delete switch is no--
     INSERT INTO GICL_MORTGAGEE(claim_id,item_no,mortg_cd,amount,iss_cd)
     VALUES(p_claim_id,p_item_no,v_mortg_cd,v_amount,v_iss_cd);
  END IF;
  END LOOP;
  COMMIT;
END;
/


