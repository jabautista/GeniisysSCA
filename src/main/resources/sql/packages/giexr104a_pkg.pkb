CREATE OR REPLACE PACKAGE BODY CPI.giexr104A_pkg
AS
   FUNCTION get_details (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2,  -- bonok :: 01.24.2013
      p_user_id         VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      details       get_details_type;
      v_intm_no     VARCHAR2 (2000);
      v_intm_no2    VARCHAR2 (2000);
      v_intm_name   VARCHAR2 (240);
      item_desc     VARCHAR2 (500);
      makeformula   VARCHAR2 (500);
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN
         (SELECT   b.pack_policy_id, --adpascual 07.31.2012 -- applied by bonok :: 01.24.2013
                   b.intm_no, b.iss_cd, b.line_cd, b.subline_cd,
                      b.line_cd
                   || '-'
                   || RTRIM (b.subline_cd)
                   || '-'
                   || RTRIM (b.iss_cd)
                   || '-'
                   || LTRIM (TO_CHAR (b.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                   b.issue_yy, b.pol_seq_no, b.renew_no, b.iss_cd iss_cd2,
                   b.line_cd line_cd2, b.subline_cd subline_cd2, b.tsi_amt,
                   b.ren_tsi_amt, b.prem_amt, b.ren_prem_amt, b.tax_amt,
                   b.expiry_date, d.line_name, e.subline_name, b.policy_id,
                   DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                   DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag 
              --FROM giex_expiries_v b, giis_line d, giis_subline e -- bonok :: 01.24.2013
              FROM giex_expiry b, giis_line d, giis_subline e
             WHERE 1 = 1
               AND b.line_cd = d.line_cd
               AND b.subline_cd = e.subline_cd
               AND d.line_cd = e.line_cd
               AND b.renew_flag = '2'
               AND NVL (b.post_flag, 'N') = 'N'
               AND b.policy_id = NVL (p_policy_id, b.policy_id)
               AND b.assd_no = NVL (p_assd_no, b.assd_no)
               AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
               AND UPPER (b.subline_cd) = NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
               AND UPPER (b.line_cd) = NVL (UPPER (p_line_cd), UPPER (b.line_cd))
               AND TRUNC (b.expiry_date) <=
                      TRUNC (NVL (TO_DATE (p_ending_date, 'dd-mon-yyyy'),
                                  NVL (TO_DATE (p_starting_date, 'dd-mon-yyyy'),
                                       b.expiry_date
                                      )
                                 )
                            )
               AND TRUNC (b.expiry_date) >=
                      DECODE (TO_DATE (p_ending_date, 'dd-mon-yyyy'),
                              NULL, TRUNC (b.expiry_date),
                              TRUNC (NVL (TO_DATE (p_starting_date, 'dd-mon-yyyy'),
                                          b.expiry_date
                                         )
                                    )
                             )
               --AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) = 0 -- bonok :: 01.24.2013
               AND NVL (b.claim_flag, 'N') LIKE
                      NVL (p_claims_flag,
                           DECODE (p_balance_flag, 'Y', 'N', '%')
                          )
               AND NVL (b.balance_flag, 'N') LIKE
                      NVL (p_balance_flag,
                           DECODE (p_claims_flag, 'Y', 'N', '%')
                          )
               -- bonok start :: 01.24.2013                              
--               AND (check_user_per_iss_cd(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1  
--                    OR check_user_per_line(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1)
               AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GIEXS006', p_user_id) = 1 --apollo cruz 03.04.2015
               AND NVL(p_is_package, 'N')  = 'N'
             UNION ALL
            SELECT DISTINCT b.pack_policy_id pack_policy_id, --added to consider package policy adpascual 
                   c.intm_no, b.iss_cd,
                   b.line_cd,
                   b.subline_cd,
                   b.line_cd||'-'||
                   RTRIM(b.subline_cd)||'-'||
                   RTRIM(b.iss_cd)||'-'||
                   LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                   LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||
                   LTRIM(TO_CHAR(b.renew_no,'09')) policy_no,
                   b.issue_yy,
                   b.pol_seq_no,       
                   b.renew_no,
                   b.iss_cd iss_cd2,
                   b.line_cd line_cd2,
                   b.subline_cd subline_cd2,       
                   b.tsi_amt ,
                   b.ren_tsi_amt, 
                   b.prem_amt,
                   b.ren_prem_amt,
                   b.tax_amt,
                   b.expiry_date,
                   d.line_name,
                   e.subline_name,
                   0 policy_id,
                   DECODE(b.balance_flag,'Y','*',NULL) balance_flag,
                   DECODE(b.claim_flag,'Y','*',NULL) claim_flag
              FROM --gipi_polbasic a,
                   giex_pack_expiry b,
                   giex_expiry c,
                   giis_line d,
                   giis_subline e
             WHERE 1 = 1 --b.policy_id = a.policy_id
               AND b.line_cd = d.line_cd
               AND b. subline_cd = e.subline_cd
               AND d.line_cd = e.line_cd 
               AND b.pack_policy_id = c.pack_policy_id 
               AND b.renew_flag = '2'
               AND NVL(b.post_flag, 'N') = 'N'
               AND b.pack_policy_id = NVL(p_policy_id, b.pack_policy_id)
               AND b.assd_no = NVL(p_assd_no, b.assd_no)
               AND UPPER(b.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(b.iss_cd))
               AND UPPER(b.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(b.subline_cd))
               AND UPPER(b.line_cd) = NVL(UPPER(p_line_cd),UPPER(b.line_cd))
               AND TRUNC (b.expiry_date) <=
                      TRUNC (NVL (TO_DATE (p_ending_date, 'dd-mon-yyyy'),
                                  NVL (TO_DATE (p_starting_date, 'dd-mon-yyyy'),
                                       b.expiry_date
                                      )
                                 )
                            )
               AND TRUNC (b.expiry_date) >=
                      DECODE (TO_DATE (p_ending_date, 'dd-mon-yyyy'),
                              NULL, TRUNC (b.expiry_date),
                              TRUNC (NVL (TO_DATE (p_starting_date, 'dd-mon-yyyy'),
                                          b.expiry_date
                                         )
                                    )
                             ) 
               --codes below added by gmi... either include package main policies or not.. ung view sa from clause, nahahandle na niang nde ksama ang sub-policies ng package
               AND DECODE(p_include_pack, 'N', b.pack_policy_id, 0) = 0 
               -- end gmi
               AND NVL(b.claim_flag,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
               AND NVL(b.balance_flag,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
--			   AND (check_user_per_iss_cd(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1 
--                    OR check_user_per_line(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1)
               AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GIEXS006', p_user_id) = 1 --apollo cruz 03.04.2015
               AND NVL(p_is_package, 'Y') = 'Y'
             ORDER BY 2, 3, 4, 5, 6)
               -- bonok end :: 01.24.2013    
             --ORDER BY b.iss_cd, b.line_cd, b.subline_cd, policy_no)
      LOOP
         details.iss_cd := i.iss_cd;
         details.line_cd := i.line_cd;
         details.subline_cd := i.subline_cd;
         details.issue_yy := i.issue_yy;
         details.pol_seq_no := i.pol_seq_no;
         details.renew_no := i.renew_no;
         details.iss_cd2 := i.iss_cd2;
         details.line_cd2 := i.line_cd2;
         details.subline_cd2 := i.subline_cd2;
         details.policy_no := i.policy_no;
         details.tsi_amt := i.tsi_amt;
         details.prem_amt := i.prem_amt;
         details.tax_amt := NVL(i.tax_amt, 0);
         details.expiry_date := i.expiry_date;
         details.line_name := i.line_name;
         details.subline_name := i.subline_name;
         details.policy_id := i.policy_id;
         details.intm_no := i.intm_no;
         --details.intm_name := i.intm_name;
         --  details.PLATE_NO            := i.PLATE_NO;
         -- details.MODEL_YEAR          := i.MODEL_YEAR;
         --  details.COLOR               := i.COLOR;
         --  details.SERIALNO            := i.SERIALNO;
          -- details.MAKE                := i.MAKE;
          -- details.MOTOR_NO            := i.MOTOR_NO;
          -- details.ITEM_TITLE          := i.ITEM_TITLE;
         details.balance_flag := i.balance_flag;
         details.claim_flag := i.claim_flag;
         details.ren_tsi_amt := NVL(i.ren_tsi_amt, 0);
         details.ren_prem_amt := NVL(i.ren_prem_amt, 0);
            
         IF details.company_name IS NULL THEN
            details.company_name := giisp.v('COMPANY_NAME');
            details.company_address := giisp.v('COMPANY_ADDRESS');
         END IF;
                 
           FOR A IN(SELECT '*' marker
                      FROM giuw_pol_dist a, 
                               giuw_policyds_dtl b, 
                               giex_expiry c
                   WHERE c.renew_flag = '2'
                         AND a.policy_id = c.policy_id                                                              
                         AND a.dist_no = b.dist_no
                         AND b.share_cd = '999'
                         AND c.policy_id = i.policy_id)
                  LOOP
                        details.mark := A.marker;
                  END LOOP;
                  
            BEGIN
                   FOR j IN (SELECT a.assd_name
                               FROM giis_assured a, giex_expiry b
                              WHERE a.assd_no = b.assd_no AND b.policy_id = i.policy_id)
                   LOOP
                      v_assd_name := j.assd_name;
                   END LOOP;

                   IF v_assd_name IS NULL
                   THEN
                      FOR c2 IN (SELECT a.assd_name
                                   FROM giis_assured a, gipi_polbasic b
                                  WHERE a.assd_no = b.assd_no
                                    AND b.line_cd = i.line_cd
                                    AND b.subline_cd = i.subline_cd
                                    AND b.iss_cd = i.iss_cd
                                    AND b.issue_yy = i.issue_yy
                                    AND b.pol_seq_no = i.pol_seq_no
                                    AND b.renew_no = i.renew_no)
                      LOOP
                         v_assd_name := c2.assd_name;
                      END LOOP;
                   END IF;

                   details.assd_name := v_assd_name;
            END;
            
           FOR c IN (SELECT a.ref_pol_no ref_pol_no
                       FROM gipi_polbasic a
                      WHERE a.policy_id = i.policy_id)
           LOOP
              details.ref_pol_no := c.ref_pol_no;
           END LOOP;
            
           BEGIN
                   /*FOR k IN (SELECT   a.intm_name intm_name
                                 FROM giis_intermediary a,
                                      gipi_polbasic b,
                                      gipi_invoice c,
                                      gipi_comm_invoice d
                                WHERE b.policy_id = c.policy_id
                                  AND c.iss_cd = d.iss_cd
                                  AND c.prem_seq_no = d.prem_seq_no
                                  AND c.policy_id = d.policy_id
                                  AND b.line_cd = i.line_cd
                                  AND b.subline_cd = i.subline_cd
                                  AND b.iss_cd = i.iss_cd
                                  AND b.issue_yy = i.issue_yy
                                  AND b.pol_seq_no = i.pol_seq_no
                                  AND b.renew_no = i.renew_no
                                  AND
                                      --B.POL_FLAG IN ('1','2','3') AND
                                      a.intm_no = d.intrmdry_intm_no
                             ORDER BY a.intm_no)*/ -- Dren 10.15.2015 SR 002060 : Comment out to query the correct Intermediary Name.
                             
                   FOR k IN (SELECT a.intm_name intm_name -- Dren 10.15.2015 SR 002060 : Revised Query to display the correct Intermediary Name - Start 
                               FROM giis_intermediary a 
                              WHERE INTM_NO = NVL(i.intm_no,'')  
                           ORDER BY a.intm_no) -- Dren 10.15.2015 SR 002060 : Revised Query to display the correct Intermediary Name - End
                           
                   LOOP
                        v_intm_name := k.intm_name;
                   END LOOP;

                       details.intm_name:= v_intm_name;
           END;
           
           -- bonok start :: 01.26.2013
           SELECT iss_name
             INTO details.iss_name
             FROM giis_issource
            WHERE iss_cd = i.iss_cd;
            
           IF i.pack_policy_id IS NULL OR i.pack_policy_id = 0 OR i.pack_policy_id = '' THEN
              SELECT SUM(DISTINCT NVL(b.tax_amt,a.tax_amt)) tax_amt
                INTO details.tax_amt
                FROM giex_old_group_tax a, giex_new_group_tax b
               WHERE a.policy_id = b.policy_id(+)
                 AND a.line_cd = b.line_cd(+)
                 AND a.iss_cd= b.iss_cd(+) 
                 AND a.iss_cd = i.iss_cd2
                 AND a.policy_id = i.policy_id;
           ELSE
              SELECT SUM(DISTINCT NVL(b.tax_amt,a.tax_amt)) tax_amt
                INTO details.tax_amt
                FROM giex_old_group_tax a, giex_new_group_tax b, giex_expiry c
               WHERE a.policy_id = b.policy_id(+) 
                 AND a.line_cd = b.line_cd(+)
                 AND a.iss_cd = b.iss_cd(+)
                 AND a.iss_cd = c.iss_cd(+)
                 AND a.policy_id = c.policy_id
                 AND c.pack_policy_id = i.pack_policy_id;
           END IF;
           
           --apollo cruz 03.04.2015
           IF details.tax_amt IS NULL THEN
              details.tax_amt := 0;
           END IF;
                  
           details.starting_date := TO_DATE(p_starting_date, 'dd-mon-yyyy');
           details.ending_date   := TO_DATE(p_ending_date, 'dd-mon-yyyy');
           -- bonok end :: 01.26.2013 
           
           FOR t IN (SELECT DISTINCT a.intm_no,
                                        TO_CHAR (a.intm_no)
                                     || '/'
                                     || ref_intm_cd v_intm_no
                                FROM giis_intermediary a,
                                     gipi_polbasic b,
                                     gipi_invoice c,
                                     gipi_comm_invoice d
                               WHERE b.policy_id = c.policy_id
                                 AND c.iss_cd = d.iss_cd
                                 AND c.prem_seq_no = d.prem_seq_no
                                 AND c.policy_id = d.policy_id
                                 AND b.line_cd = i.line_cd
                                 AND b.subline_cd = i.subline_cd
                                 AND b.iss_cd = i.iss_cd
                                 AND b.issue_yy = i.issue_yy
                                 AND b.pol_seq_no = i.pol_seq_no
                                 AND b.renew_no = i.renew_no
                                 AND
                                     a.intm_no = d.intrmdry_intm_no
                            ORDER BY a.intm_no)
           LOOP
              details.agent := t.v_intm_no;
           END LOOP;
           
         PIPE ROW (details);
      END LOOP;
      
      --added by apollo cruz 03.17.2015
      IF details.company_name IS NULL THEN
         details.company_name := giisp.v('COMPANY_NAME');
         details.company_address := giisp.v('COMPANY_ADDRESS');
         
         details.starting_date := TO_DATE(p_starting_date, 'dd-mon-yyyy');
         details.ending_date   := TO_DATE(p_ending_date, 'dd-mon-yyyy');
         
         PIPE ROW (details);
      END IF;
      
   END;
END giexr104A_pkg;
/


