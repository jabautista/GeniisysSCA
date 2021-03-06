DROP PROCEDURE CPI.SEARCH_FOR_ACCT_CD;

CREATE OR REPLACE PROCEDURE CPI.search_for_acct_cd(
    p_acct_of_cd     IN OUT GICL_CLAIMS.acct_of_cd%TYPE,
    p_line_cd               GIPI_POLBASIC.line_cd%TYPE,   
    p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no              GIPI_POLBASIC.renew_no%TYPE,
    p_loss_date             GIPI_POLBASIC.eff_date%TYPE,
    p_expiry_date           GIPI_POLBASIC.expiry_date%TYPE
    ) IS
  v_max_eff_date1           gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of backward endt with update
  v_max_eff_date2           gipi_wpolbas.eff_date%TYPE;   --store max. eff_date of endt with no update
  v_max_eff_date            gipi_wpolbas.eff_date%TYPE;   --store eff_date to be use to retrieve assured
  v_eff_date                gipi_wpolbas.eff_date%TYPE;   --store policy's eff_date
  v_policy_id               gipi_polbasic.policy_id%TYPE; --store policy's policy_id
  v_max_endt_seq_no         gipi_wpolbas.endt_seq_no%TYPE;--store the maximum endt_seq_no for all endt
  v_max_endt_seq_no1        gipi_wpolbas.endt_seq_no%TYPE;--store the maximum endt_seq_no for backward endt. with back_stat = '2'
BEGIN
  --get policy id and effectivity of policy
    Gipi_Polbasic_Pkg.get_eff_date_policy_id(p_line_cd, p_subline_cd, p_pol_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date, v_policy_id);
            
  --get the maximum endt_seq_no from all endt. of the policy
  FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
              FROM gipi_polbasic b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_pol_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
               AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         p_expiry_date, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
               AND b2501.assd_no IS NOT NULL ) 
  LOOP
    v_max_endt_seq_no := w.endt_seq_no;  
    EXIT;
  END LOOP;

  --if maximum endt_seq_no is greater than 0 then check if latest
  --assured should be from latest backward endt with update or  
  -- from the latest endt that is not backward 
  IF v_max_endt_seq_no > 0 THEN
     --get maximum endt_seq_no for backward endt. with updates
     FOR G IN (SELECT MAX(b2501.endt_seq_no) endt_seq_no
                 FROM gipi_polbasic b2501
                WHERE b2501.line_cd    = p_line_cd
                  AND b2501.subline_cd = p_subline_cd
                  AND b2501.iss_cd     = p_pol_iss_cd
                  AND b2501.issue_yy   = p_issue_yy
                  AND b2501.pol_seq_no = p_pol_seq_no
                  AND b2501.renew_no   = p_renew_no
                  AND b2501.pol_flag   IN ('1','2','3','X')
                  AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                  AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                            p_expiry_date, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                  AND b2501.assd_no IS NOT NULL 
                  AND nvl(b2501.back_stat,5) = 2) 
     LOOP
       v_max_endt_seq_no1 := g.endt_seq_no;
       EXIT;
     END LOOP;
     --if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
     --backward endt. with update then get max. eff_date for both condition
     IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
        --get max. eff_date for backward endt with updates
        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_polbasic b2501
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_pol_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                     AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                         p_expiry_date, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                     AND nvl(b2501.back_stat,5) = 2
                     AND b2501.assd_no IS NOT NULL 
                     AND b2501.endt_seq_no = v_max_endt_seq_no1)
        LOOP
          v_max_eff_date1 := z.eff_date;
          EXIT;
        END LOOP;                                 
        --get max eff_date for endt 
        FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_polbasic b2501
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_pol_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.endt_seq_no != 0
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                     AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                               p_expiry_date, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                     AND nvl(b2501.back_stat,5)!= 2
                     AND b2501.assd_no IS NOT NULL ) 
        LOOP
          v_max_eff_date2 := y.eff_date;
          EXIT;
        END LOOP;               
        v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
     ELSE
        --assd_no should be from the latest backward endt. with updates
        FOR C IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_polbasic b2501
                   WHERE b2501.line_cd    = p_line_cd
                      AND b2501.subline_cd = p_subline_cd
                      AND b2501.iss_cd     = p_pol_iss_cd
                      AND b2501.issue_yy   = p_issue_yy
                      AND b2501.pol_seq_no = p_pol_seq_no
                      AND b2501.renew_no   = p_renew_no
                      AND b2501.pol_flag   IN ('1','2','3','X')
                      AND TRUNC(b2501.eff_date) <= TRUNC(NVL(p_loss_date,SYSDATE))
                      AND TRUNC(DECODE(nvl(b2501.endt_expiry_date,b2501.expiry_date),b2501.expiry_date,
                               p_expiry_date, b2501.endt_expiry_date )) >= TRUNC(NVL(p_loss_date,SYSDATE))
                      AND nvl(b2501.back_stat,5) = 2
                      AND b2501.endt_seq_no = v_max_endt_seq_no1
                      AND b2501.assd_no IS NOT NULL ) 
        LOOP
          v_max_eff_date := c.eff_date;
          EXIT;
        END LOOP;                      
     END IF;
  ELSE
     --eff_date should be from policy for records with no endt or 
     --no valid endt. that meets the conditions set
     v_max_eff_date := v_eff_date;                
  END IF;
  --get assured from records with eff_date equal to the derived eff_date
  FOR A1 IN (SELECT b2501.acct_of_cd 
               FROM gipi_polbasic b2501, giis_assured a020
              WHERE b2501.line_cd    = p_line_cd
                AND b2501.subline_cd = p_subline_cd
                AND b2501.iss_cd     = p_pol_iss_cd
                AND b2501.issue_yy   = p_issue_yy
                AND b2501.pol_seq_no = p_pol_seq_no
                AND b2501.renew_no   = p_renew_no
                AND b2501.pol_flag   IN ('1','2','3','X') 
                AND TRUNC(b2501.eff_date)   = TRUNC(v_max_eff_date)
                AND b2501.assd_no IS NOT NULL
                AND b2501.assd_no    = a020.assd_no
           ORDER BY b2501.endt_seq_no  DESC )
  LOOP
    p_acct_of_cd := a1.acct_of_cd;
    EXIT;
  END LOOP;
END;
/


