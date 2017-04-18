DROP PROCEDURE CPI.CHECK_REINSURANCE_PAYMENT2;

CREATE OR REPLACE PROCEDURE CPI.check_reinsurance_payment2(p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
                                                       p_line_cd        IN     GIPI_POLBASIC.line_cd%TYPE,
                                                       p_policy_status     OUT VARCHAR2)
IS
  /*
  **  Created by   : Emman
  **  Date Created : 08/15/2011
  **  Reference By : (GIUTS021 - Redistribution)
  **  Description  : Check if policy has FACUL share and if there are existing payments
  **                 from FACUL Reinsurers to consider the value of "ALLOW_NEG_DIST" 
  **                 parameter in displaying the message that there are collections from facul insurers
  */
  v_param_value_n      giis_parameters.param_value_n%TYPE;
  v_param_value_v2    giis_parameters.param_value_v%TYPE;
BEGIN
  -- used for checking
  p_policy_status := 'OK';
  
  FOR A1 IN (
    SELECT param_value_n
      FROM giis_parameters 
     WHERE param_name = 'FACULTATIVE') LOOP
    v_param_value_n  :=  A1.param_value_n;
    EXIT;
  END LOOP;
  FOR A5 IN (
    SELECT param_value_v
      FROM giis_parameters 
     WHERE param_name = 'ALLOW_NEG_DIST') LOOP
    v_param_value_v2  :=  A5.param_value_v;
    EXIT;
  END LOOP;
  IF v_param_value_n IS NOT NULL THEN
       FOR A2 IN (SELECT a.dist_no      dist_no,
                       a.dist_seq_no  dist_seq_no,
                       a.line_cd      line_cd,
                       a.share_cd     share_cd
                  FROM giuw_pol_dist c ,giuw_policyds_dtl a,giuw_policyds b
                 WHERE c.policy_id   = p_policy_id 
                   AND c.dist_no     = b.dist_no
                   AND c.negate_date IS NULL
                   AND a.dist_no     = b.dist_no
                   AND a.dist_seq_no = b.dist_seq_no
                   AND a.line_cd     = p_line_cd
                   AND a.share_cd    = v_param_value_n) 
     LOOP
       FOR A3 IN (SELECT c.fnl_binder_id, b.ri_cd
                    FROM giri_distfrps a, giri_frps_ri b, giri_binder c
                   WHERE a.dist_no       = a2.dist_no
                     AND a.dist_seq_no   = a2.dist_seq_no
                     AND a.frps_yy       = b.frps_yy
                     AND a.frps_seq_no   = b.frps_seq_no 
                     AND b.line_cd       = a2.line_cd
                     AND b.fnl_binder_id = c.fnl_binder_id
                     AND c.reverse_date IS NULL)
       LOOP
         FOR A4 IN (SELECT SUM(NVL(a.disbursement_amt,0)) amt
                      FROM giac_outfacul_prem_payts a, 
                           giac_acctrans b
                     WHERE a.a180_ri_cd         =  a3.ri_cd
                       AND a.d010_fnl_binder_id =  a3.fnl_binder_id
                       AND a.gacc_tran_id       =  b.tran_id
                       AND b.tran_flag          <> 'D'        
                       AND NOT EXISTS (SELECT '1'
                                         FROM giac_reversals c, 
                                              giac_acctrans d
                                        WHERE a.gacc_tran_id = c.gacc_tran_id
                                          AND c.reversing_tran_id =  d.tran_id
                                          AND d.tran_flag         <> 'D'))
         LOOP
              IF a4.amt <> 0 THEN                    
                    IF v_param_value_v2 = 'Y' THEN
                       --msg_alert('This policy has collections from FACUL Reinsurers', 'I',FALSE);
                       p_policy_status := 'HAS_COLLECTIONS';
                    ELSE
                       --:v370.nbt_rdate := NULL;
                       --msg_alert('This policy has collections from FACUL Reinsurers, Cannot redistribute policy/endorsement', 'I',TRUE);
                       p_policy_status := 'NO_REDIST';    
                   END IF;
                 EXIT;
              END IF;                 
         END LOOP;                                          
       END LOOP;   
     END LOOP;   
  END IF;
END;
/


