DROP PROCEDURE CPI.EXTRACT_LATEST_ASSURED;

CREATE OR REPLACE PROCEDURE CPI.EXTRACT_LATEST_ASSURED  (p_incept_date         gicl_claims.pol_eff_date%TYPE,
                                                         p_expiry_date         gicl_claims.expiry_date%TYPE,
                                                         p_loss_date           gicl_claims.loss_date%TYPE,
                                                         p_clm_endt_seq_no     gicl_claims.max_endt_seq_no%TYPE,
                                                         p_line_cd             gicl_claims.line_cd%TYPE,
                                                         p_subline_cd          gicl_claims.subline_cd%TYPE,
                                                         p_pol_iss_cd          gicl_claims.pol_iss_cd%TYPE,
                                                         p_issue_yy            gicl_claims.issue_yy%TYPE,
                                                         p_pol_seq_no          gicl_claims.pol_seq_no%TYPE,
                                                         p_renew_no            gicl_claims.renew_no%TYPE,
                                                         p_claim_id            gicl_claims.claim_id%TYPE,
                                                         p_assd_no             gicl_claims.assd_no%TYPE,
                                                         p_acct_of_cd          gicl_claims.acct_of_cd%TYPE,
                                                         p_assured_name        gicl_claims.assured_name%TYPE,
                                                         p_assd_name2          gicl_claims.assd_name2%TYPE
                                                         )
IS
    
  /*
  **  Created by      : Christian Santos
  **  Date Created    : 10.25.2012
  **  Reference By    : (GICLS039 - Batch Claim Closing)      
  */
    
  v_max_endt_seq_no  gipi_wpolbas.endt_seq_no%TYPE;
  v_assd_name        gicl_claims.assured_name%TYPE;
  v_assd_no          gicl_claims.assd_no%TYPE;
  v_acct_of_cd       gicl_claims.acct_of_cd%TYPE;
BEGIN
  --get latest assd_no
  FOR W IN (SELECT assd_no, endt_seq_no
              FROM gipi_polbasic b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_pol_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND trunc(DECODE(TRUNC(b2501.eff_date),TRUNC(b2501.incept_date), 
                         nvl(p_incept_date,b2501.eff_date), b2501.eff_date)) <= p_loss_date 
               AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         NVL(p_expiry_date,b2501.expiry_date) , b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
               AND b2501.assd_no IS NOT NULL 
               AND b2501.endt_seq_no > p_clm_endt_seq_no
             ORDER BY eff_date DESC) 
  LOOP
    v_max_endt_seq_no := w.endt_seq_no;  
    v_assd_no := w.assd_no;
    EXIT;
  END LOOP;
  FOR G IN (SELECT assd_no 
              FROM gipi_polbasic b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_pol_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND trunc(DECODE(TRUNC(b2501.eff_date),TRUNC(b2501.incept_date), 
                         p_incept_date, b2501.eff_date )) <= p_loss_date 
               AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         p_expiry_date, b2501.endt_expiry_date )) = TRUNC(NVL(p_loss_date,SYSDATE))
               AND b2501.assd_no IS NOT NULL 
               AND b2501.endt_seq_no > v_max_endt_seq_no
               AND nvl(b2501.back_stat,5) = 2) 
  LOOP
    v_assd_no := g.assd_no;
    EXIT;
  END LOOP;
  --get latest acct_of_cd
  v_max_endt_seq_no := 0;  
  FOR W IN (SELECT acct_of_cd, endt_seq_no 
              FROM gipi_polbasic b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_pol_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND trunc(DECODE(TRUNC(b2501.eff_date),TRUNC(b2501.incept_date), 
                         nvl(p_incept_date,b2501.eff_date), b2501.eff_date )) <= p_loss_date 
               AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         NVL(p_expiry_date,b2501.expiry_date) , b2501.endt_expiry_date )) >=                        TRUNC(NVL(p_loss_date,SYSDATE))
               AND b2501.acct_of_cd IS NOT NULL 
               AND b2501.endt_seq_no > p_clm_endt_seq_no
             ORDER BY eff_date DESC ) 
  LOOP
    v_max_endt_seq_no := w.endt_seq_no;  
    v_acct_of_cd := w.acct_of_cd;
    EXIT;
  END LOOP;
  FOR G IN (SELECT acct_of_cd
              FROM gipi_polbasic b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_pol_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND trunc(DECODE(TRUNC(b2501.eff_date),TRUNC(b2501.incept_date), 
                         p_incept_date, b2501.eff_date )) <= p_loss_date 
               AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         p_expiry_date, b2501.endt_expiry_date )) >=                                                TRUNC(NVL(p_loss_date,SYSDATE))
               AND b2501.acct_of_cd IS NOT NULL 
               AND b2501.endt_seq_no > v_max_endt_seq_no
               AND nvl(b2501.back_stat,5) = 2) 
  LOOP
    v_acct_of_cd := g.acct_of_cd;
    EXIT;
  END LOOP;
  
  
  
  FOR assd IN (SELECT assd_name, assd_name2
                 FROM giis_assured
                WHERE assd_no = v_assd_no)
  LOOP              
      
      UPDATE gicl_claims
         SET assd_no = NVL(v_assd_no,p_assd_no),
             acct_of_cd = NVL(v_acct_of_cd,p_acct_of_cd),
             assured_name = NVL(assd.assd_name,p_assured_name),
             assd_name2 = NVL(assd.assd_name2,p_assd_name2)
       WHERE claim_id = p_claim_id;      

  END LOOP;
  
  
END;
/


