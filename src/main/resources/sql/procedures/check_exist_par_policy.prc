DROP PROCEDURE CPI.CHECK_EXIST_PAR_POLICY;

CREATE OR REPLACE PROCEDURE CPI.Check_Exist_Par_Policy(
                       p_par_id            IN  GIPI_PARLIST.par_id%TYPE,        
                       p_msg_alert        IN OUT VARCHAR2,
                       p_par_policy         IN  VARCHAR2,
                  p_no                 IN  VARCHAR2,
                  p_value             IN  VARCHAR2) IS         
  v_par_no          VARCHAR2(32767);  --issa@cic04.02.2007, increased value to 32767 to prevent error in posting
  v_policy_no          VARCHAR2(32767); --issa@cic04.02.2007, increased value to 32767 to prevent error in posting
  v_countc           NUMBER; --issa@cic04.03.2007 to store count for POLICY COC_SERIAL_NO to prevent error in posting
  v_countb            NUMBER; --issa04.10.2007 to store count for POLICY MOTOR_NO
  v_counta            NUMBER; --issa04.10.2007 to store count for POLICY PLATE_NO
  v_countd            NUMBER; --issa04.10.2007 to store count for POLICY SERIAL_NO
  v_countw            NUMBER; --issa04.10.2007 to store count for PAR PLATE_NO
  v_countx            NUMBER; --issa04.10.2007 to store count for PAR SERIAL_NO
  v_county            NUMBER; --issa04.10.2007 to store count for PAR MOTOR_NO
  v_countz            NUMBER; --issa04.10.2007 to store count for PAR COC_SERIAL_NO
  v_coc_type          GIPI_WVEHICLE.coc_type%TYPE; --robert 12.15.14 
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Check_Exist_Par_Policy program unit
  */
    --message('p_no='||p_no);message('p_no='||p_no);
    --message('p_par_policy='||p_par_policy);message('p_par_policy='||p_par_policy);
    --message('par_id='||:b240.par_id);message('par_id='||:b240.par_id);
    --message('p_value='||p_value);message('p_value='||p_value);
    IF p_no = 'COC_SERIAL_NO'-- robert 12.15.14
    THEN
       BEGIN 
          SELECT DISTINCT coc_type -- grace 02.04.2015 Added 'Distinct' for PARs with  multiple items and
                                   -- NULL or 0 COC_SERIAL_NO like endts
            INTO v_coc_type
            FROM gipi_wvehicle
           WHERE par_id = p_par_id AND coc_serial_no = p_value;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             NULL;
       END;
    END IF;
    
    IF p_par_policy = 'PAR' THEN
        v_par_no := NULL;
    IF p_no = 'PLATE_NO' THEN
          --issa04.10.2007 to prevent error if character count exceeds 32767
            BEGIN 
             SELECT COUNT(*) countw
               INTO v_countw
                 FROM GIPI_PARLIST c,
                      GIPI_WPOLBAS b, 
                      GIPI_WVEHICLE a 
                WHERE 1=1 
                  AND c.par_id = b.par_id
                  AND b.par_id = a.par_id 
                  AND a.plate_no = p_value
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
             EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                     NULL;
             END; 
          --issa04.10.2007
          --IF v_countw > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_countw > 1 THEN
            --p_msg_alert := 'Plate Number - '' '||p_value||' '' already exist in VARIOUS PARs.'; --commented out and replace by the line below by adpascual 05112012
            IF p_msg_alert IS NOT NULL
            THEN
               p_msg_alert := p_msg_alert || CHR (10) || p_value;
            ELSE
               p_msg_alert :=
                     'The following Plate Number(s) already exist in VARIOUS PARs.'
                  || CHR (10)
                  || p_value;
            END IF;
          --i--
          ELSE
              FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
                                     FROM GIPI_PARLIST c,
                                          GIPI_WPOLBAS b, 
                                          GIPI_WVEHICLE a 
                                    WHERE 1=1 
                                      AND c.par_id = b.par_id
                                      AND b.par_id = a.par_id 
                                      AND a.plate_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
          LOOP
              IF v_par_no IS NULL THEN
                v_par_no := c1.par_no;      
              ELSE
                v_par_no := v_par_no||', '||c1.par_no;
              END IF;    
          END LOOP;
          
              p_msg_alert := 'Plate Number - '' '||p_value||' '' already exist in PAR No. '||v_par_no;        
          END IF;
    ELSIF p_no = 'SERIAL_NO' THEN        
          --issa04.10.2007 to prevent error if character count exceeds 32767
            BEGIN 
             SELECT COUNT(*) countx
               INTO v_countx
                 FROM GIPI_PARLIST c,
                      GIPI_WPOLBAS b, 
                      GIPI_WVEHICLE a 
                WHERE 1=1 
                  AND c.par_id = b.par_id
                  AND b.par_id = a.par_id 
                  AND a.serial_no = p_value
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
             EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                     NULL;
             END;
          
          --IF v_countx > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_countx > 1 THEN
            --p_msg_alert := 'Serial Number - '' '||p_value||' '' already exist in VARIOUS PARs.'; commented out and replace by the lines below. by adpascual 05112012
            IF p_msg_alert IS NOT NULL
            THEN
               p_msg_alert := p_msg_alert || CHR (10) || p_value;
            ELSE
               p_msg_alert :=
                     'The following Serial Number(s) already exist in VARIOUS PARs.'
                  || CHR (10)
                  || p_value;
            END IF;
          --i--
          ELSE
              FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
                                     FROM GIPI_PARLIST c,
                                          GIPI_WPOLBAS b, 
                                          GIPI_WVEHICLE a 
                                    WHERE 1=1 
                                      AND c.par_id = b.par_id
                                      AND b.par_id = a.par_id 
                                      AND a.serial_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
              LOOP
                  IF v_par_no IS NULL THEN
                    v_par_no := c1.par_no;      
                  ELSE
                    v_par_no := v_par_no||','||c1.par_no;
                  END IF;    
              END LOOP;
              
                  p_msg_alert := 'Serial Number - '' '||p_value||' '' already exist in PAR No. '||v_par_no;        
              END IF;
    ELSIF p_no = 'MOTOR_NO' THEN        
          --issa04.10.2007 to prevent error if character count exceeds 32767
            BEGIN 
             SELECT COUNT(*) county
               INTO v_county
                 FROM GIPI_PARLIST c,
                      GIPI_WPOLBAS b, 
                      GIPI_WVEHICLE a 
                WHERE 1=1 
                  AND c.par_id = b.par_id
                  AND b.par_id = a.par_id 
                  AND a.motor_no = p_value
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
             EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                     NULL;
             END;
             
          --IF v_county > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_county > 1 THEN 
            --p_msg_alert := 'Motor Number - '' '||p_value||' '' already exist in VARIOUS PARs.';--commented out and replace by the line below by adpascual 05112012
            IF p_msg_alert IS NOT NULL
            THEN
               p_msg_alert := p_msg_alert || CHR (10) || p_value;
            ELSE
               p_msg_alert :=
                     'The following Motor Number(s) already exist in VARIOUS PARs.'
                  || CHR (10)
                  || p_value;
            END IF;
          --i--
          ELSE
              FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
                                     FROM GIPI_PARLIST c,
                                          GIPI_WPOLBAS b, 
                                          GIPI_WVEHICLE a 
                                    WHERE 1=1 
                                      AND c.par_id = b.par_id
                                      AND b.par_id = a.par_id 
                                      AND a.motor_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
          LOOP
              IF v_par_no IS NULL THEN
                v_par_no := c1.par_no;      
              ELSE
                v_par_no := v_par_no||','||c1.par_no;
              END IF;    
          END LOOP;
              p_msg_alert := 'Motor Number - '' '||p_value||' '' already exist in PAR No. '||v_par_no;            
          END IF;
    ELSIF p_no = 'COC_SERIAL_NO' THEN            
          --issa04.10.2007 to prevent error if character count exceeds 32767
            BEGIN 
             SELECT COUNT(*) countz
               INTO v_countz
                 FROM GIPI_PARLIST c,
                      GIPI_WPOLBAS b, 
                      GIPI_WVEHICLE a 
                WHERE 1=1 
                  AND c.par_id = b.par_id
                  AND b.par_id = a.par_id 
                  AND a.coc_serial_no = p_value
                  AND a.coc_type = v_coc_type -- robert 12.15.14
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         --AND z.pol_seq_no = b.pol_seq_no -- robert 12.15.14
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
             EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                     NULL;
             END;
                 
          --IF v_countz > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_countz > 1 THEN 
              p_msg_alert := 'COC Serial Number - '' '||p_value||' '' already exist in VARIOUS PARs.';
          --i--
          --ELSE
          ELSIF v_countz = 1 THEN
              FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
                         FROM GIPI_PARLIST c,
                              GIPI_WPOLBAS b, 
                              GIPI_WVEHICLE a 
                        WHERE 1=1 
                          AND c.par_id = b.par_id
                          AND b.par_id = a.par_id 
                          AND a.coc_serial_no = p_value
                          AND a.coc_type = v_coc_type -- robert 12.15.14
                          AND NOT EXISTS (SELECT 1 
                                            FROM GIPI_WPOLBAS z 
                                                 WHERE z.line_cd = b.line_cd 
                                                   AND z.subline_cd = b.subline_cd 
                                                                 AND z.iss_cd = b.iss_cd 
                                                                 AND z.issue_yy = b.issue_yy 
                                                                -- AND z.pol_seq_no = b.pol_seq_no -- robert 12.15.14
                                                                 AND z.renew_no = b.renew_no 
                                                                 AND z.par_id = p_par_id))
                LOOP
                    IF v_par_no IS NULL THEN
                      v_par_no := c1.par_no;      
                    ELSE
                      v_par_no := v_par_no||','||c1.par_no;
                    END IF;    
                END LOOP;

              p_msg_alert := 'COC Serial Number - '' '||p_value||' '' already exist in PAR No. '||v_par_no;        
          END IF;
    END IF;    
    ELSIF p_par_policy = 'POLICY' THEN
        v_policy_no := NULL;
    IF p_no = 'PLATE_NO' THEN
            --issa04.10.2007 to prevent error if character count exceeds 32767
            BEGIN 
             SELECT COUNT(*) counta
               INTO v_counta
                 FROM GIPI_POLBASIC b, 
                      GIPI_VEHICLE a 
                WHERE 1=1 
                  AND b.policy_id = a.policy_id 
                  AND a.plate_no = p_value
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
             EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                     NULL;
             END;
             
          --issa04.10.2007
          --IF v_counta > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_counta > 1 THEN
            --p_msg_alert := 'Plate Number - '' '||p_value||' '' already exist in VARIOUS POLICIES.'; --commented out and replace by the line below by adpascual 05112012
            IF p_msg_alert IS NOT NULL
            THEN
               p_msg_alert := p_msg_alert || CHR (10) || p_value;
            ELSE
               p_msg_alert :=
                     'The following Plate Number(s) already exist in VARIOUS POLICIES.'
                  || CHR (10)
                  || p_value;
            END IF;
          --i--
          ELSE
              FOR c1 IN (SELECT DISTINCT Get_Policy_No(b.policy_id) policy_no
                                     FROM GIPI_POLBASIC b, 
                                          GIPI_VEHICLE a 
                                    WHERE 1=1 
                                      AND b.policy_id = a.policy_id 
                                      AND a.plate_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
          LOOP
              IF v_policy_no IS NULL THEN
                v_policy_no := c1.policy_no;      
              ELSE
                v_policy_no := v_policy_no||','||c1.policy_no;
              END IF;    
          END LOOP;
          
              p_msg_alert := 'Plate Number - '' '||p_value||' '' already exist in Policy No. '||v_policy_no;
          END IF;
    ELSIF p_no = 'SERIAL_NO' THEN        
          --issa04.10.2007 to prevent error if character count exceeds 32767
            BEGIN 
             SELECT COUNT(*) countd
               INTO v_countd
                 FROM GIPI_POLBASIC b, 
                      GIPI_VEHICLE a 
                WHERE 1=1 
                  AND b.policy_id = a.policy_id 
                  AND a.serial_no = p_value
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
             EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                     NULL;
             END;
                 
          --message('countd='||v_countd);message('countd='||v_countd);
          --issa04.10.2007
          --IF v_countd > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_countd > 1 THEN
            --p_msg_alert := 'Serial Number - '' '||p_value||' '' already exist in VARIOUS POLICIES.';--commented out and replace by the line below by adpascual 05112012
            IF p_msg_alert IS NOT NULL
            THEN
               p_msg_alert := p_msg_alert || CHR (10) || p_value;
            ELSE
               p_msg_alert :=
                     'The following Serial Number(s) already exist in VARIOUS POLICIES.'
                  || CHR (10)
                  || p_value;
            END IF;
          --i--
          ELSE
              FOR c1 IN (SELECT DISTINCT Get_Policy_No(b.policy_id) policy_no
                                     FROM GIPI_POLBASIC b, 
                                          GIPI_VEHICLE a 
                                    WHERE 1=1 
                                      AND b.policy_id = a.policy_id 
                                      AND a.serial_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
          LOOP
              IF v_policy_no IS NULL THEN
                v_policy_no := c1.policy_no;      
              ELSE
                v_policy_no := v_policy_no||','||c1.policy_no;
              END IF;    
          END LOOP;
          
              p_msg_alert := 'Serial Number - '' '||p_value||' '' already exist in Policy No. '||v_policy_no;
          END IF;
    ELSIF p_no = 'MOTOR_NO' THEN        
          --issa04.10.2007 to prevent error if character count exceeds 32767
          BEGIN 
           SELECT COUNT(*) countb
             INTO v_countb
                 FROM GIPI_POLBASIC b, 
                      GIPI_VEHICLE a 
                WHERE 1=1 
                  AND b.policy_id = a.policy_id 
                  AND a.motor_no = p_value
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
           EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                   NULL;
           END;
          --message('countb='||v_countb);message('countb='||v_countb);
          --issa04.10.2007
          --IF v_countb > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_countb > 1 THEN
            --p_msg_alert := 'Motor Number - '' '||p_value||' '' already exist in VARIOUS POLICIES.';--commented out and replace by the line below by adpascual 05112012
            IF p_msg_alert IS NOT NULL
            THEN
               p_msg_alert := p_msg_alert || CHR (10) || p_value;
            ELSE
               p_msg_alert :=
                     'The following Motor Number(s) already exist in VARIOUS POLICIES.'
                  || CHR (10)
                  || p_value;
            END IF;
         --i--
          --i--
          ELSE
              FOR c1 IN (SELECT DISTINCT Get_Policy_No(b.policy_id) policy_no
                                     FROM GIPI_POLBASIC b, 
                                          GIPI_VEHICLE a 
                                    WHERE 1=1 
                                      AND b.policy_id = a.policy_id 
                                      AND a.motor_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
          LOOP
              IF v_policy_no IS NULL THEN
                v_policy_no := c1.policy_no;      
              ELSE
                v_policy_no := v_policy_no||','||c1.policy_no;
              END IF;    
          END LOOP;
              
              p_msg_alert := 'Motor Number - '' '||p_value||' '' already exist in Policy No. '||v_policy_no;
          END IF;
          
    ELSIF p_no = 'COC_SERIAL_NO' THEN            
          --issa@cic04.02.2007 to prevent error if character count exceeds 32767
          BEGIN 
           SELECT COUNT(*) countc
             INTO v_countc
                 FROM GIPI_POLBASIC b, 
                      GIPI_VEHICLE a 
                WHERE 1=1 
                  AND b.policy_id = a.policy_id 
                  AND a.coc_serial_no = p_value
                  AND a.coc_type = v_coc_type -- robert 12.15.14
                  AND NOT EXISTS (SELECT 1 
                                    FROM GIPI_WPOLBAS z 
                                         WHERE z.line_cd = b.line_cd 
                                           AND z.subline_cd = b.subline_cd 
                                                         AND z.iss_cd = b.iss_cd 
                                                         AND z.issue_yy = b.issue_yy 
                                                         AND z.pol_seq_no = b.pol_seq_no 
                                                         AND z.renew_no = b.renew_no 
                                                         AND z.par_id = p_par_id);
           EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                   NULL;
           END;
                       
        
          --message('count='||v_countc);message('count='||v_countc);
          --issa@cic04.03.2007 
          --IF v_countc > 1200 THEN -- approx. 1200*26chars=31200 -- commented mark jm 10.11.2011 replace by code below
        IF v_countc > 1 THEN
              p_msg_alert := 'COC Serial Number - '' '||p_value||' '' already exist in VARIOUS POLICIES.';
          --i--
          --ELSE
        ELSIF v_countc = 1 THEN
                  --message('issa='||v_countc);message('issa='||v_countc);
          FOR c1 IN (SELECT DISTINCT Get_Policy_No(b.policy_id) policy_no
                                     FROM GIPI_POLBASIC b, 
                                          GIPI_VEHICLE a 
                                    WHERE 1=1 
                                      AND b.policy_id = a.policy_id 
                                      AND a.coc_serial_no = p_value
                                      AND NOT EXISTS (SELECT 1 
                                                        FROM GIPI_WPOLBAS z 
                                                             WHERE z.line_cd = b.line_cd 
                                                               AND z.subline_cd = b.subline_cd 
                                                                             AND z.iss_cd = b.iss_cd 
                                                                             AND z.issue_yy = b.issue_yy 
                                                                             AND z.pol_seq_no = b.pol_seq_no 
                                                                             AND z.renew_no = b.renew_no 
                                                                             AND z.par_id = p_par_id))
          LOOP
              IF v_policy_no IS NULL THEN
                v_policy_no := c1.policy_no;      
              ELSE
                v_policy_no := v_policy_no||','||c1.policy_no;
              END IF;    
          END LOOP;
          
              p_msg_alert := 'COC Serial Number - '' '||p_value||' ''already exist in Policy No. '||v_policy_no;
          END IF;
    END IF;    
    END IF;    
END;
/


