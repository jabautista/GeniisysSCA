DROP PROCEDURE CPI.GET_SETTLING_AGENT;

CREATE OR REPLACE PROCEDURE CPI.get_settling_agent(
    p_line_cd                    IN     GIPI_POLBASIC.line_cd%TYPE,  
    p_subline_cd                 IN     GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd                 IN     GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy                   IN     GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no                 IN     GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no                   IN     GIPI_POLBASIC.renew_no%TYPE,
    p_loss_date                  IN     GICL_CLAIMS.dsp_loss_date%TYPE,
    p_expiry_date                IN     GIPI_POLBASIC.expiry_date%TYPE,
    p_settling_agent_cd          OUT    GIPI_POLBASIC.settling_agent_cd%TYPE
    ) IS
  v_max_eff_date1           gipi_wpolbas.eff_date%TYPE;                   --stores max. eff_date of backward endt with update
  v_max_eff_date2           gipi_wpolbas.eff_date%TYPE;                   --stores max. eff_date of endt with no update
  v_max_eff_date            gipi_wpolbas.eff_date%TYPE;                   --stores eff_date used to retrieve settling agent
  v_eff_date                gipi_wpolbas.eff_date%TYPE;                   --stores eff_date
  v_policy_id               gipi_polbasic.policy_id%TYPE;                 --stores policy_id
  v_max_endt_seq_no         gipi_wpolbas.endt_seq_no%TYPE;                --stores the maximum endt_seq_no for all endt
  v_max_endt_seq_no1        gipi_wpolbas.endt_seq_no%TYPE;                --stores the maximum endt_seq_no for backward endt. with back_stat = '2'
BEGIN
/* jen.082306
/* Retrieve settling agent cd based on the specified loss date*/
  --get policy id and effectivity of policy 
  FOR x IN (SELECT a.eff_date eff_date, a.policy_id policy_id
              FROM gipi_polbasic a
             WHERE a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd     = p_pol_iss_cd
               AND a.issue_yy   = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no   = p_renew_no
               AND a.pol_flag   IN ('1','2','3','X')
               AND a.endt_seq_no = 0) 
  LOOP
    v_eff_date := x.eff_date;
    v_policy_id := x.policy_id;
    EXIT;
  END LOOP;                 
  
  --get the maximum endt_seq_no from all endt. of the policy
  FOR w IN (SELECT MAX(endt_seq_no) endt_seq_no 
              FROM gipi_polbasic a
             WHERE a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd     = p_pol_iss_cd
               AND a.issue_yy   = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no   = p_renew_no
               AND a.pol_flag   IN ('1','2','3','X')
               AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)
               AND TRUNC(DECODE(nvl(a.endt_expiry_date,a.expiry_date),a.expiry_date,
                         p_expiry_date, a.endt_expiry_date )) >= TRUNC(p_loss_date)
               AND a.settling_agent_cd IS NOT NULL ) 
  LOOP
    v_max_endt_seq_no := w.endt_seq_no;  
    EXIT;
  END LOOP;
  
  --if maximum endt_seq_no is greater than 0 then check if latest
  --settling_agent_cd should be from latest backward endt with update or  
  -- from the latest endt that is not backward 
  IF v_max_endt_seq_no > 0 THEN
     --get maximum endt_seq_no for backward endt. with updates
     FOR G IN (SELECT MAX(a.endt_seq_no) endt_seq_no
                 FROM gipi_polbasic a
                WHERE a.line_cd    = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd     = p_pol_iss_cd
                  AND a.issue_yy   = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no   = p_renew_no
                  AND a.pol_flag   IN ('1','2','3','X')
                  AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)
                  AND TRUNC(DECODE(nvl(a.endt_expiry_date,a.expiry_date),a.expiry_date,
                            p_expiry_date, a.endt_expiry_date )) >= TRUNC(p_loss_date)
                  AND a.settling_agent_cd IS NOT NULL 
                  AND nvl(a.back_stat,5) = 2) 
     LOOP
       v_max_endt_seq_no1 := g.endt_seq_no;
       EXIT;
     END LOOP;
     --if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
     --backward endt. with update then get max. eff_date for both condition
     IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
        --get max. eff_date for backward endt with updates
        FOR Z IN (SELECT MAX(a.eff_date) eff_date
                    FROM gipi_polbasic a
                   WHERE a.line_cd    = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd     = p_pol_iss_cd
                     AND a.issue_yy   = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no   = p_renew_no
                     AND a.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)
                     AND TRUNC(DECODE(nvl(a.endt_expiry_date,a.expiry_date),a.expiry_date,
                         p_expiry_date, a.endt_expiry_date )) >= TRUNC(p_loss_date)
                     AND nvl(a.back_stat,5) = 2
                     AND a.settling_agent_cd IS NOT NULL 
                     AND a.endt_seq_no = v_max_endt_seq_no1)
        LOOP
          v_max_eff_date1 := z.eff_date;
          EXIT;
        END LOOP;                                 
        --get max eff_date for endt 
        FOR Y IN (SELECT MAX(a.eff_date) eff_date
                    FROM gipi_polbasic a
                   WHERE a.line_cd    = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd     = p_pol_iss_cd
                     AND a.issue_yy   = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no   = p_renew_no
                     AND a.endt_seq_no != 0
                     AND a.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)
                     AND TRUNC(DECODE(nvl(a.endt_expiry_date,a.expiry_date),a.expiry_date,
                               p_expiry_date, a.endt_expiry_date )) >= TRUNC(p_loss_date)
                     AND nvl(a.back_stat,5)!= 2
                     AND a.settling_agent_cd IS NOT NULL ) 
        LOOP
          v_max_eff_date2 := y.eff_date;
          EXIT;
        END LOOP;               
        v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
     ELSE
        --settling_agent_cd should be from the latest backward endt. with updates
        FOR C IN (SELECT MAX(a.eff_date) eff_date
                    FROM gipi_polbasic a
                   WHERE a.line_cd    = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd     = p_pol_iss_cd
                     AND a.issue_yy   = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no   = p_renew_no
                     AND a.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)
                     AND TRUNC(DECODE(nvl(a.endt_expiry_date,a.expiry_date),a.expiry_date,
                               p_expiry_date, a.endt_expiry_date )) >= TRUNC(p_loss_date)
                     AND nvl(a.back_stat,5) = 2
                     AND a.endt_seq_no = v_max_endt_seq_no1
                     AND a.settling_agent_cd IS NOT NULL ) 
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
  --get settling_agent_cd from records with eff_date equal to the derrived eff_date
  FOR A1 IN (SELECT b2501.settling_agent_cd settling_agent_cd
               FROM gipi_polbasic b2501
              WHERE b2501.line_cd    = p_line_cd
                AND b2501.subline_cd = p_subline_cd
                AND b2501.iss_cd     = p_pol_iss_cd
                AND b2501.issue_yy   = p_issue_yy
                AND b2501.pol_seq_no = p_pol_seq_no
                AND b2501.renew_no   = p_renew_no
                AND b2501.pol_flag   IN ('1','2','3','X') 
                AND TRUNC(b2501.eff_date)   = TRUNC(v_max_eff_date)
                AND b2501.settling_agent_cd IS NOT NULL
           ORDER BY b2501.endt_seq_no  DESC )
  LOOP
    p_settling_agent_cd := a1.settling_agent_cd;
    EXIT;
  END LOOP;
END;
/


