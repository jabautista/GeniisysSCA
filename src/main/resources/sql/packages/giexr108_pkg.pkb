CREATE OR REPLACE PACKAGE BODY CPI.GIEXR108_PKG
AS
   /*
   **  Created by    : Jerome Cris Bautista
   **  Date Created  : 06.29.2015
   **  Reference By  : GIEXR108
   **  Description   : GIEXR108 Report
   */
    FUNCTION get_details(p_date_from        DATE,
                     p_date_to              DATE,
                     p_iss_cd               VARCHAR2,
                     p_cred_cd              VARCHAR2,
                     p_intm_no              NUMBER,
                     p_line_cd              VARCHAR2,
                     p_user_id              giis_users.user_id%TYPE) 
    RETURN get_details_tab PIPELINED
        IS
        
    details get_details_type;
    v_report_title giis_reports.report_title%TYPE;
    v_new_pol_id VARCHAR2(50):=NULL;--jen
    v_flag BOOLEAN := FALSE;
    v_pack_policy_id VARCHAR2(500);
    
    BEGIN
    details.v_flag := 'N';
    
    BEGIN
         SELECT report_title
           INTO v_report_title
           FROM giis_reports
          WHERE report_id = 'GIEXR108';
    EXCEPTION WHEN NO_DATA_FOUND THEN
         v_report_title := NULL;        
    END;
      
    details.company_name     := giexr108_pkg.get_company_name;
    details.company_address  := giexr108_pkg.get_comp_address;
    details.report_title     := v_report_title;
    details.date_range       := giexr108_pkg.date_formula(p_date_from,p_date_to);
    
    FOR i IN (SELECT DISTINCT h.iss_name iss_name, f.line_name line_name,
                g.subline_name subline_name,
                TO_CHAR (a.intm_no, '099999999999') intm_number,
                a.assd_no assured_no, b.assd_name assured_name,
                TO_CHAR (c.expiry_date, 'MM/DD/RRRR') expiry_date,
                c.policy_id,
                   c.line_cd
                || '-'
                || c.subline_cd
                || '-'
                || c.iss_cd
                || '-'
                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                || '-'
                || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                a.prem_amt premium_amt,
                DECODE (a.renewal_tag,
                        'Y', a.prem_renew_amt,
                        0
                       ) premium_renew_amt,
                DECODE (a.renewal_tag,
                        'Y', c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                         || '-'
                         || LTRIM (TO_CHAR (c.renew_no, '09'))
                       ) renewal_policy,
                DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks, c.ref_pol_no
           FROM giex_ren_ratio_dtl a,
                gipi_polbasic c,
                giis_assured b,
                giis_line f,
                giis_subline g,
                giis_issource h
          WHERE 1 = 1
            AND h.iss_cd = a.iss_cd
            AND f.line_cd = a.line_cd
            AND g.subline_cd = a.subline_cd
            AND g.line_cd = a.line_cd
            AND b.assd_no = a.assd_no
            AND c.policy_id = a.policy_id
            -- AND a.YEAR  IN ( SELECT MAX(YEAR)  comment out by czie, 10212008 -to get the correct output of data inputted with diff year
                                            --  FROM giex_ren_ratio_dtl
                                         --  WHERE user_id = USER)
            AND a.user_id = p_user_id --rcd 03.21.2013 re-enable to avoid duplicate entries
            AND TRUNC (c.expiry_date) BETWEEN TRUNC (p_date_from)
                                          --added by jomardiago 02142012
                                      AND TRUNC (p_date_to)
            --addeb by jomardiago 02142012
            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
            AND c.cred_branch = NVL (p_cred_cd, c.cred_branch) -- added by jomardiago 03142012
            AND a.intm_no = NVL (p_intm_no, a.intm_no) --added by jomardiago 03142012
            AND a.line_cd = NVL (p_line_cd, a.line_cd)
            AND a.pack_policy_id = 0
         UNION
         SELECT DISTINCT h.iss_name iss_name, f.line_name line_name,
                g.subline_name subline_name,
                TO_CHAR (a.intm_no, '099999999999') intm_number,
                a.assd_no assured_no, b.assd_name assured_name,
                TO_CHAR (c.expiry_date, 'MM/DD/RRRR') expiry_date,
                c.pack_policy_id policy_id,
                   c.line_cd
                || '-'
                || c.subline_cd
                || '-'
                || c.iss_cd
                || '-'
                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                || '-'
                || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                a.prem_amt premium_amt,
                DECODE (a.renewal_tag,
                        'Y', a.prem_renew_amt,
                        0
                       ) premium_renew_amt,
                DECODE (a.renewal_tag,
                        'Y', c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                         || '-'
                         || LTRIM (TO_CHAR (c.renew_no, '09'))
                       ) renewal_policy,
                DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks, c.ref_pol_no
           FROM giex_ren_ratio_dtl a,
                gipi_pack_polbasic c,
                giis_assured b,
                giis_line f,
                giis_subline g,
                giis_issource h
          WHERE 1 = 1
            AND h.iss_cd = a.iss_cd
            AND f.line_cd = a.line_cd
            AND g.subline_cd = a.subline_cd
            AND g.line_cd = a.line_cd
            AND b.assd_no = a.assd_no
            AND c.pack_policy_id = a.pack_policy_id
            AND a.pack_policy_id = a.policy_id
            --AND a.YEAR  IN ( SELECT MAX(YEAR)  comment out by czie, 10212008 -to get the correct output of data inputted with diff year
                                             --FROM giex_ren_ratio_dtl
                                          --WHERE user_id = USER)
            AND a.user_id = p_user_id --RCD 03.21.2013 re-enabled to avoid duplicate entries
            AND TRUNC (c.expiry_date) BETWEEN TRUNC (p_date_from) --added by jomardiago 02142012
                                      AND TRUNC (p_date_to) --added by jomardiago 02142012
            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
            AND c.cred_branch = NVL (p_cred_cd, c.cred_branch) --added by jomardiago 02142012
            AND a.intm_no = NVL (p_intm_no, a.intm_no) --added by jomardiago 03142012
            AND a.line_cd = NVL (p_line_cd, a.line_cd)
       ORDER BY intm_number)
              
           LOOP
                    BEGIN
                        BEGIN
                            FOR a in (SELECT pack_policy_id
                                      FROM giex_ren_ratio_dtl
                                      WHERE policy_id = i.policy_id)
                            LOOP
                                v_pack_policy_id := a.pack_policy_id;
                            END LOOP;
                        END;
                        
                       IF i.remarks = 'RENEWED' THEN
                          IF v_pack_policy_id = 0 THEN
                              FOR c1 IN (SELECT get_policy_no(new_policy_id) renewal_policy,new_policy_id
                                              FROM gipi_polnrep a
                                             WHERE old_policy_id =i.policy_id)
                              LOOP
                               v_new_pol_id:=c1.new_policy_id;--jen
                              END LOOP;
                          ELSE
                              FOR c1 IN (SELECT get_pack_policy_no(new_pack_policy_id) renewal_policy,new_pack_policy_id
                                              FROM gipi_pack_polnrep a
                                             WHERE old_pack_policy_id =i.policy_id)
                              LOOP
                               v_new_pol_id:=c1.new_pack_policy_id;--jen
                              END LOOP;
                          END IF;    
                       END IF;
                    END;
                   
--                   FOR a in (SELECT * FROM (SELECT get_policy_no (b.new_policy_id) policy_no, policy_id, new_policy_id
--                                      FROM gipi_polbasic a, gipi_polnrep b
--                                     WHERE a.policy_id = b.old_policy_id
--                                       AND b.ren_rep_sw = 1
--                                       AND EXISTS (
--                                              SELECT '1'
--                                                FROM gipi_polbasic c
--                                               WHERE c.policy_id = b.new_policy_id
--                                                 AND c.pol_flag IN ('1', '2', '3','X'))
--                                    UNION
--                                    SELECT get_policy_no (a.new_policy_id) policy_no, b.old_policy_id policy_id,
--                                           a.new_policy_id
--                                      FROM gipi_polnrep a,
--                                           (SELECT new_policy_id, old_policy_id
--                                              FROM gipi_polnrep b
--                                             WHERE EXISTS (
--                                                          SELECT '1'
--                                                            FROM gipi_polbasic c
--                                                           WHERE c.policy_id = b.new_policy_id
--                                                                 AND c.pol_flag = '5')) b
--                                     WHERE a.old_policy_id = b.new_policy_id AND a.ren_rep_sw = 2 )WHERE policy_id = i.policy_id)
--                     LOOP
--                        details.policy_id          := a.policy_id;
--                     END LOOP;
                   
                   v_flag                   := TRUE;
                   details.v_flag           := 'Y';
                   details.iss_name         := i.iss_name;
                   details.line_name        := i.line_name;
                   details.subline_name     := i.subline_name;
                   details.intm_no          := i.intm_number;
                   details.assd_no          := i.assured_no;
                   details.assd_name        := i.assured_name;
                   details.expiry_date      := giexr108_pkg.expiry_date(i.policy_id); 
                   details.prem_amt         := i.premium_amt;
                   details.prem_renew_amt   := i.premium_renew_amt;
                   details.policy_no        := i.policy_no;
                   details.ref_pol_no       := i.ref_pol_no;
                   details.remarks          := i.remarks;
                   details.renewal_policy   := giexr108_pkg.renewal_policy_formula(i.remarks,i.policy_id);
                   details.intm_name        := giexr108_pkg.intm_name_formula(i.intm_number);
                   details.ref_ren_pol      := giexr108_pkg.ref_ren_pol(v_new_pol_id);
                   details.ren_prem_amt     := giexr108_pkg.ren_prem_amt(i.remarks,i.policy_id);
                   details.ref_ren_pol2     := giexr108_pkg.ref_ren_pol2(v_new_pol_id);
                   
           PIPE ROW(details);
           END LOOP;
           
           IF v_flag = FALSE 
           THEN
           PIPE ROW(details);
           END IF;
    END;
    
    FUNCTION get_company_name 
    RETURN VARCHAR2 
    IS
        v_company_name    VARCHAR2(500);
    
    BEGIN
       SELECT param_value_v
         INTO v_company_name
         FROM giis_parameters
        WHERE UPPER(param_name) = 'COMPANY_NAME';
    RETURN (v_company_name);
    END;
    
    FUNCTION get_comp_address 
    RETURN VARCHAR2 
    IS
        v_company_address    VARCHAR2(500);
    
    BEGIN
       SELECT param_value_v
         INTO v_company_address
         FROM giis_parameters
        WHERE UPPER(param_name) = 'COMPANY_ADDRESS';
    RETURN (v_company_address);
    END;
        
     FUNCTION date_formula (p_date_from         DATE,
                            p_date_to           DATE) 
     RETURN VARCHAR2 
     IS
     
     BEGIN
        RETURN('FOR THE PERIOD '||TO_CHAR(p_date_from,'FMMONTH DD, YYYY')||' TO '||TO_CHAR(p_date_to,'FMMONTH DD, YYYY'));
     END;

    FUNCTION intm_name_formula (p_intm_no   giex_ren_ratio_dtl.intm_no%TYPE)
    RETURN VARCHAR2 
    IS
    v_intm_name giis_intermediary.intm_name%type;
    
    BEGIN
      FOR a in (SELECT intm_name
                  FROM   giis_intermediary
                 WHERE  intm_no = p_intm_no)
      LOOP
          v_intm_name := a.intm_name;
      END LOOP;
      
    RETURN (v_intm_name);
    END;
    
    FUNCTION renewal_policy_formula(p_remarks      VARCHAR2,
                                    p_policy_id    gipi_polbasic.policy_id%TYPE)
    RETURN VARCHAR2
    IS
        v_renewal_policy VARCHAR2(500) := NULL;
        v_new_pol_id VARCHAR2(50) := NULL;--jen
        v_pack_policy_id VARCHAR(500) := NULL;
        
     BEGIN
       BEGIN
         FOR a in (SELECT pack_policy_id
                FROM giex_ren_ratio_dtl
                WHERE policy_id = p_policy_id)
         LOOP
         v_pack_policy_id := a.pack_policy_id;
         END LOOP;
       END;
     
         IF p_remarks = 'RENEWED' THEN
            IF v_pack_policy_id = 0 THEN
             FOR c1 IN (SELECT DISTINCT(get_policy_no(new_policy_id)) renewal_policy, new_policy_id
                               FROM gipi_polnrep a, gipi_polbasic b
                               WHERE old_policy_id = p_policy_id
                               AND ren_rep_sw = 1
                               AND EXISTS (SELECT '1'
                                             FROM gipi_polbasic c
                                             WHERE c.policy_id = a.new_policy_id
                                             AND c.pol_flag IN ('1','2','3','X')))
                                    
             LOOP
                 FOR c2 IN (SELECT DISTINCT (get_policy_no(new_policy_id)) renewal_policy,new_policy_id
                                   FROM gipi_polnrep a, gipi_polbasic b
                                   WHERE old_policy_id  = c1.new_policy_id
                                   AND ren_rep_sw = 1
                                   AND EXISTS (SELECT '1'
                                                 FROM gipi_polbasic c
                                                 WHERE c.policy_id = a.new_policy_id
                                                 AND c.pol_flag IN ('1','2','3','X')))
                                    
                 LOOP
                      v_renewal_policy := v_renewal_policy || CHR(10) || c2.renewal_policy;
                      v_new_pol_id := v_new_pol_id || CHR(10) || c2.new_policy_id;
                 END LOOP;
               
             v_renewal_policy := v_renewal_policy || CHR(10)|| c1.renewal_policy;
             v_new_pol_id:= v_new_pol_id || CHR(10) || c1.new_policy_id;--jen
             END LOOP;
             ELSE
             FOR c1 IN (SELECT DISTINCT(get_pack_policy_no(new_pack_policy_id)) renewal_policy, new_pack_policy_id
                               FROM gipi_pack_polnrep a, gipi_pack_polbasic b
                               WHERE old_pack_policy_id = p_policy_id
                               AND ren_rep_sw = 1
                               AND EXISTS (SELECT '1'
                                             FROM gipi_polbasic c
                                             WHERE c.pack_policy_id = a.new_pack_policy_id
                                             AND c.pol_flag IN ('1','2','3','X')))
                                    
             LOOP
                 FOR c2 IN (SELECT DISTINCT(get_pack_policy_no(new_pack_policy_id)) renewal_policy, new_pack_policy_id
                               FROM gipi_pack_polnrep a, gipi_pack_polbasic b
                               WHERE old_pack_policy_id = c1.new_pack_policy_id
                               AND ren_rep_sw = 1
                               AND EXISTS (SELECT '1'
                                             FROM gipi_polbasic c
                                             WHERE c.pack_policy_id = a.new_pack_policy_id
                                             AND c.pol_flag IN ('1','2','3','X')))
                                    
                 LOOP
                      v_renewal_policy := v_renewal_policy || CHR(10) || c2.renewal_policy;
                      v_new_pol_id := v_new_pol_id || CHR(10) || c2.new_pack_policy_id;
                 END LOOP;
               
             v_renewal_policy := v_renewal_policy || CHR(10)|| c1.renewal_policy;
             v_new_pol_id:= v_new_pol_id || CHR(10) || c1.new_pack_policy_id;--jen
             END LOOP;
            END IF;
         END IF;
         RETURN LTRIM(v_renewal_policy,CHR(10));
     END;
     
    FUNCTION ref_ren_pol(p_cp_1         NUMBER)
    RETURN VARCHAR2
    IS
    v_ref_ren_pol varchar2(30);
    v_pack_policy_id VARCHAR2(500);
    
    BEGIN
       BEGIN
         FOR a in (SELECT pack_policy_id
                     FROM giex_ren_ratio_dtl
                    WHERE policy_id = p_cp_1)
         LOOP
           v_pack_policy_id := a.pack_policy_id;
         END LOOP;
       END;
       IF v_pack_policy_id = 0 THEN
       FOR i IN (SELECT ref_pol_no
                   FROM GIPI_POLBASIC
                  WHERE policy_id=p_cp_1)
       LOOP
            v_ref_ren_pol:=i.ref_pol_no;
       END LOOP;
       ELSE
         FOR i IN (SELECT ref_pol_no
                     FROM GIPI_PACK_POLBASIC
                    WHERE pack_policy_id=p_cp_1)
         LOOP
            v_ref_ren_pol:=i.ref_pol_no;
         END LOOP;
         
       END IF;
       
    RETURN(v_ref_ren_pol);
    END;
    
    FUNCTION ren_prem_amt(p_remarks       VARCHAR2,
                          p_policy_id     gipi_polbasic.policy_id%TYPE)
    RETURN VARCHAR2 
    IS
    v_ren_prem_amt          NUMBER := 0;
    c1_prem_amt             NUMBER;
    c2_prem_amt             NUMBER;
    v_pack_policy_id        VARCHAR2(5000);

    BEGIN
        
       BEGIN
          FOR a in (SELECT pack_policy_id
                      FROM giex_ren_ratio_dtl
                     WHERE policy_id = p_policy_id)
          LOOP
              v_pack_policy_id := a.pack_policy_id;
          END LOOP;
       END;
            
       IF p_remarks = 'RENEWED' THEN
           IF v_pack_policy_id = 0 THEN
             FOR c1 IN ( SELECT prem_amt, new_policy_id
                           FROM gipi_polbasic a, gipi_polnrep b
                          WHERE a.policy_id IN ( SELECT new_policy_id new_pol_id
                                                   FROM gipi_polnrep
                                                  WHERE old_policy_id = p_policy_id ))
             LOOP
             
              FOR c2 IN ( SELECT prem_amt
                            FROM gipi_polbasic
                           WHERE policy_id IN ( SELECT new_policy_id new_pol_id
                                                  FROM gipi_polnrep
                                                 WHERE old_policy_id = c1.new_policy_id ))
                                               
              LOOP
                  c1_prem_amt := c1.prem_amt;
                  c2_prem_amt := c2.prem_amt;
                  v_ren_prem_amt := v_ren_prem_amt + c2_prem_amt;
                
              END LOOP; 
                 v_ren_prem_amt := v_ren_prem_amt + c1_prem_amt;
             END LOOP;
             ELSE
             FOR c1 IN ( SELECT prem_amt, new_pack_policy_id
                           FROM gipi_pack_polbasic a, gipi_pack_polnrep b
                          WHERE a.pack_policy_id IN ( SELECT new_pack_policy_id new_pol_id
                                                 FROM gipi_pack_polnrep
                                                WHERE old_pack_policy_id = v_pack_policy_id ))
             LOOP
               FOR c2 IN ( SELECT prem_amt
                           FROM gipi_pack_polbasic
                          WHERE pack_policy_id IN ( SELECT new_pack_policy_id new_pol_id
                                                 FROM gipi_pack_polnrep
                                                WHERE old_pack_policy_id = c1.new_pack_policy_id ))
                                               
              LOOP
                  c1_prem_amt := c1.prem_amt;
                  c2_prem_amt := c2.prem_amt;
                  v_ren_prem_amt := v_ren_prem_amt + c2_prem_amt;
                
              END LOOP; 
                  v_ren_prem_amt := v_ren_prem_amt + c1_prem_amt;
             END LOOP;
             
           END IF;    
       END IF;
          
    RETURN v_ren_prem_amt;
    END;
    FUNCTION expiry_date(p_policy_id            gipi_polbasic.policy_id%TYPE)
    RETURN DATE
    IS
        v_expiry_date DATE;
        v_pack_policy_id VARCHAR2(500);
        
     BEGIN
        
        BEGIN
           FOR a in (SELECT pack_policy_id
                       FROM giex_ren_ratio_dtl
                      WHERE policy_id = p_policy_id)
           LOOP
               v_pack_policy_id := a.pack_policy_id;
           END LOOP;
        END;
      IF v_pack_policy_id = 0 THEN
           FOR a IN ( SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                        FROM gipi_polbasic
                       WHERE policy_id = p_policy_id)
           LOOP
              FOR b IN ( SELECT expiry_date
                           FROM gipi_polbasic            
                          WHERE line_cd = a.line_cd
                            AND subline_cd = a.subline_cd
                            AND iss_cd = a.iss_cd
                            AND issue_yy = a.issue_yy
                            AND pol_seq_no = a.pol_seq_no
                            AND renew_no = a.renew_no
                       ORDER BY endt_seq_no DESC)
               LOOP
                    v_expiry_date := b.expiry_date;
                    EXIT;
               END LOOP;
           END LOOP;
      ELSE
           FOR a IN ( SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                        FROM gipi_pack_polbasic
                       WHERE pack_policy_id = p_policy_id)
           LOOP
                FOR b IN ( SELECT expiry_date
                             FROM gipi_pack_polbasic            
                            WHERE line_cd = a.line_cd
                              AND subline_cd = a.subline_cd
                              AND iss_cd = a.iss_cd
                              AND issue_yy = a.issue_yy
                              AND pol_seq_no = a.pol_seq_no
                              AND renew_no = a.renew_no
                            ORDER BY endt_seq_no DESC)
                LOOP
                    v_expiry_date := b.expiry_date;
                    EXIT;
                END LOOP;
           END LOOP;
      END IF;
      
     RETURN(v_expiry_date);
     END;
     FUNCTION ref_ren_pol2(p_cp_1         NUMBER)
     RETURN VARCHAR2
     IS
     v_ref_ren_pol varchar2(30);
     v_pack_policy_id VARCHAR2(500);
     
     BEGIN
          BEGIN
             FOR a in (SELECT pack_policy_id
                         FROM giex_ren_ratio_dtl
                        WHERE policy_id = p_cp_1)
             LOOP
                v_pack_policy_id := a.pack_policy_id;
             END LOOP;
          END;
                
          IF v_pack_policy_id = 0 THEN
            FOR i IN (SELECT ref_pol_no
                        FROM GIPI_POLBASIC
                       WHERE policy_id=p_cp_1)
            LOOP
               v_ref_ren_pol:=i.ref_pol_no;
            END LOOP;
          ELSE
            FOR i IN (SELECT ref_pol_no
                        FROM GIPI_PACK_POLBASIC
                       WHERE pack_policy_id=p_cp_1)
            LOOP
               v_ref_ren_pol:=i.ref_pol_no;
            END LOOP;
          END IF;
          
     RETURN(v_ref_ren_pol);
     END;       
END GIEXR108_PKG;
/


