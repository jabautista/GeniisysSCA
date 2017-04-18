DROP PROCEDURE CPI.SEARCH_FOR_ASSURED2_1;

CREATE OR REPLACE PROCEDURE CPI.SEARCH_FOR_ASSURED2_1
(p_assd_no      IN OUT GIPI_WPOLBAS.assd_no%TYPE,
 p_eff_date     IN GIPI_WPOLBAS.eff_date%TYPE,
 p_line_cd      IN GIPI_WPOLBAS.line_cd%TYPE,
 p_subline_cd   IN GIPI_WPOLBAS.subline_cd%TYPE,
 p_iss_cd       IN GIPI_WPOLBAS.iss_cd%TYPE,
 p_issue_yy     IN GIPI_WPOLBAS.issue_yy%TYPE,
 p_pol_seq_no   IN GIPI_WPOLBAS.pol_seq_no%TYPE,
 p_renew_no     IN GIPI_WPOLBAS.renew_no%TYPE) IS
 
 /*
 **  Created by	    : Veronica V. Raymundo
 **  Date Created 	: 08.24.2012
 **  Reference By 	: (GIPIS031 - Endt Basic Information)
 **  Description 	: Based on SEARCH_ASSURED2 Program Unit of GIPIS031.
 **                   Retrieve assured based on the new specified 
 **                   effectivity date. Fires only when the entered effectivity date 
 **                   is changed and if endt is a backward endt or if the change in 
 **                   effectivity will make it a backward endorsement	
 */
    
  v_max_eff_date1           GIPI_WPOLBAS.eff_date%TYPE;   --store max. eff_date of backward endt with update
  v_max_eff_date2           GIPI_WPOLBAS.eff_date%TYPE;   --store max. eff_date of endt with no update
  v_max_eff_date            GIPI_WPOLBAS.eff_date%TYPE;   --store eff_date to be use to retrieve assured
  v_eff_date                GIPI_WPOLBAS.eff_date%TYPE;   --store policy's eff_date
  v_policy_id               GIPI_POLBASIC.policy_id%TYPE; --store policy's policy_id
  v_max_endt_seq_no         GIPI_WPOLBAS.endt_seq_no%TYPE;--store the maximum endt_seq_no for all endt
  v_max_endt_seq_no1        GIPI_WPOLBAS.endt_seq_no%TYPE;--store the maximum endt_seq_no for backward endt. with back_stat = '2'

BEGIN
  --get policy id and effectivity of policy 
  FOR X IN (SELECT b2501.eff_date eff_date, b2501.policy_id
              FROM GIPI_POLBASIC b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND b2501.endt_seq_no = 0) 
  LOOP
    v_eff_date := x.eff_date;
    v_policy_id := x.policy_id;
    EXIT;
  END LOOP;
                   
  --get the maximum endt_seq_no from all endt. of the policy
  FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
              FROM GIPI_POLBASIC b2501
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND TRUNC(b2501.eff_date) <= NVL(p_eff_date,SYSDATE)
               AND TRUNC(NVL(b2501.endt_expiry_date, b2501.expiry_date)) >= TRUNC(p_eff_date)
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
                 FROM GIPI_POLBASIC b2501
                WHERE b2501.line_cd    = p_line_cd
                  AND b2501.subline_cd = p_subline_cd
                  AND b2501.iss_cd     = p_iss_cd
                  AND b2501.issue_yy   = p_issue_yy
                  AND b2501.pol_seq_no = p_pol_seq_no
                  AND b2501.renew_no   = p_renew_no
                  AND b2501.pol_flag   IN ('1','2','3','X')
                  AND b2501.eff_date <= p_eff_date
                  AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
                  AND b2501.assd_no IS NOT NULL 
                  AND NVL(b2501.back_stat,5) = 2) 
     LOOP
       v_max_endt_seq_no1 := g.endt_seq_no;
       EXIT;
     END LOOP;
     --if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
     --backward endt. with update then get max. eff_date for both condition
     IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
        --get max. eff_date for backward endt with updates
        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM GIPI_POLBASIC b2501
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND b2501.eff_date   <= p_eff_date
                     AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
                     AND NVL(b2501.back_stat,5) = 2
                     AND b2501.assd_no IS NOT NULL 
                     AND b2501.endt_seq_no = v_max_endt_seq_no1)
        LOOP
          v_max_eff_date1 := z.eff_date;
          EXIT;
        END LOOP;                                 
        --get max eff_date for endt 
        FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM GIPI_POLBASIC b2501
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND b2501.endt_seq_no != 0
                     AND b2501.eff_date <= p_eff_date
                     AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
                     AND NVL(b2501.back_stat,5)!= 2
                     AND b2501.assd_no IS NOT NULL ) 
        LOOP
          v_max_eff_date2 := y.eff_date;
          EXIT;
        END LOOP;               
        v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);                         
     ELSE
        --assd_no should be from the latest backward endt. with updates
        FOR C IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM GIPI_POLBASIC b2501
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND b2501.eff_date   <= p_eff_date
                     AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
                     AND NVL(b2501.back_stat,5) = 2
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
  FOR A1 IN (SELECT b2501.assd_no
               FROM GIPI_POLBASIC b2501
              WHERE b2501.line_cd    = p_line_cd
                AND b2501.subline_cd = p_subline_cd
                AND b2501.iss_cd     = p_iss_cd
                AND b2501.issue_yy   = p_issue_yy
                AND b2501.pol_seq_no = p_pol_seq_no
                AND b2501.renew_no   = p_renew_no
                AND b2501.pol_flag   IN ('1','2','3','X') 
                AND TRUNC(b2501.eff_date) = TRUNC(v_max_eff_date)
                AND b2501.assd_no IS NOT NULL
           ORDER BY b2501.endt_seq_no  DESC )
  LOOP
    p_assd_no := a1.assd_no;
    EXIT;
  END LOOP;
  
END;
/


