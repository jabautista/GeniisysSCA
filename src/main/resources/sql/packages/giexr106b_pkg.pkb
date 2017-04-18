CREATE OR REPLACE PACKAGE BODY CPI.giexr106B_pkg
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
      p_is_package      VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      details        get_details_type;
      v_intm_no      VARCHAR2 (32000); -- bonok :: 09.06.2012 temp solution for ORA-06502 
      v_intm_no2     VARCHAR2 (2000);
      v_acct_of_cd   VARCHAR2 (550);
      v_intm_name    VARCHAR2 (240);
      item_desc      VARCHAR2 (500);
      makeformula    VARCHAR2 (500);
      v_ref_pol_no   VARCHAR2 (50);
      v_iss_name   giis_issource.iss_name%TYPE;
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN
           (SELECT B.ISS_CD,
                   B.LINE_CD,
                   B.SUBLINE_CD,
                   B.ISSUE_YY,
                   B.POL_SEQ_NO,       
                   B.RENEW_NO,
                   B.ISS_CD ISS_CD2,
                   B.LINE_CD LINE_CD2,
                   B.SUBLINE_CD SUBLINE_CD2,       
                   B.LINE_CD||'-'||
                      RTRIM(B.SUBLINE_CD)||'-'||
                      RTRIM(B.ISS_CD)||'-'||
                      LTRIM(TO_CHAR(B.ISSUE_YY,'09'))||'-'||
                      LTRIM(TO_CHAR(B.POL_SEQ_NO,'0999999'))||'-'||
                      LTRIM(TO_CHAR(B.RENEW_NO,'09')) POLICY_NO,
                   B.TSI_AMT , 
                   B.PREM_AMT,
                   H.TAX_AMT,
                   B.EXPIRY_DATE,
                   D.LINE_NAME,
                   E.SUBLINE_NAME,
                   B.POLICY_ID,
                   DECODE(B.BALANCE_FLAG,'Y','*',NULL) BALANCE_FLAG,
                   DECODE(B.CLAIM_FLAG,'Y','*',NULL) CLAIM_FLAG,
                   G.REN_TSI_AMT,
                   G.REN_PREM_AMT,
                   A.ACCT_OF_CD ACCT_OF_CD,  --added by reymon 02022011
                   DECODE(A.LABEL_TAG,'Y','Leased to :','In acct of :') Label_Tag,    --added by reymon 02022011
                   B.IS_PACKAGE
              FROM --GIPI_POLBASIC A,
                   (SELECT policy_id, acct_of_cd, label_tag, 'N' is_package
                      FROM gipi_polbasic
                    UNION ALL
                    SELECT pack_policy_id policy_id, acct_of_cd, label_tag, 'Y' is_package
                      FROM gipi_pack_polbasic) A,
                   GIEX_EXPIRIES_V B,
                   GIIS_LINE D,
                   GIIS_SUBLINE E,
                   (SELECT a.policy_id, SUM (a.prem_amt) ren_prem_amt, SUM (DECODE(b.peril_type, 'B', a.tsi_amt, 0)) ren_tsi_amt, 'N' is_package
                      FROM (SELECT policy_id, line_cd, peril_cd, tsi_amt, prem_amt
                              FROM giex_old_group_peril a
                             WHERE NOT EXISTS (SELECT 1 FROM giex_new_group_peril WHERE policy_id = a.policy_id)
                            UNION ALL
                            SELECT policy_id, line_cd, peril_cd, tsi_amt, prem_amt
                              FROM giex_new_group_peril) a, 
                           giis_peril b
                     WHERE a.line_cd = b.line_cd
                       AND a.peril_cd = b.peril_cd
                       AND a.policy_id IN (
                        SELECT policy_id
                          FROM giex_expiry
                         WHERE pack_policy_id IS NULL)
                     GROUP BY a.policy_id
                    UNION ALL
                    SELECT a.pack_policy_id policy_id, SUM (b.prem_amt) ren_prem_amt, SUM (DECODE(c.peril_type, 'B', b.tsi_amt, 0)) ren_tsi_amt, 'Y' is_package
                      FROM giex_pack_expiry a,
                           (SELECT policy_id, line_cd, peril_cd, tsi_amt, prem_amt
                              FROM giex_old_group_peril a
                             WHERE NOT EXISTS (SELECT 1 FROM GIEX_NEW_GROUP_PERIL WHERE policy_id = a.policy_id)
                            UNION ALL
                            SELECT policy_id, line_cd, peril_cd, tsi_amt, prem_amt
                              FROM giex_new_group_peril) b,
                           giis_peril c
                     WHERE b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                       AND b.policy_id IN (
                        SELECT policy_id
                          FROM giex_expiry
                         WHERE pack_policy_id = a.pack_policy_id)
                    GROUP BY a.pack_policy_id) G,
                    (SELECT a.policy_id, SUM (a.tax_amt) tax_amt, 'N' is_package
                      FROM (SELECT policy_id, tax_amt
                              FROM giex_old_group_tax a
                             WHERE NOT EXISTS (SELECT 1 FROM giex_new_group_tax WHERE policy_id = a.policy_id)
                            UNION ALL
                            SELECT policy_id, tax_amt
                              FROM giex_new_group_tax) a
                     WHERE a.policy_id IN (
                        SELECT policy_id
                          FROM giex_expiry
                         WHERE pack_policy_id IS NULL)
                     GROUP BY a.policy_id
                     UNION
                     SELECT a.pack_policy_id policy_id, SUM (b.tax_amt) tax_amt, 'Y' is_package
                       FROM giex_pack_expiry a,
                            (SELECT policy_id, tax_amt
                               FROM giex_old_group_tax a
                              WHERE NOT EXISTS (SELECT 1 FROM giex_new_group_tax WHERE policy_id = a.policy_id)
                             UNION ALL
                             SELECT policy_id, tax_amt
                               FROM giex_new_group_tax) b
                      WHERE b.policy_id IN (
                         SELECT policy_id
                           FROM giex_expiry
                          WHERE pack_policy_id = a.pack_policy_id)
                     GROUP BY a.pack_policy_id) H
             WHERE B.POLICY_ID = A.POLICY_ID
               AND A.IS_PACKAGE = B.IS_PACKAGE
               AND B.POLICY_ID = G.POLICY_ID
               AND B.IS_PACKAGE = G.IS_PACKAGE
               AND B.POLICY_ID = H.POLICY_ID
               AND B.IS_PACKAGE = H.IS_PACKAGE
               AND NVL(B.POST_FLAG, 'N') = 'N'
               AND B.LINE_CD = D.LINE_CD
               AND B.SUBLINE_CD = E.SUBLINE_CD
               AND D.LINE_CD = E.LINE_CD  
               AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)
               AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
               AND NVL(B.INTM_NO,0) = NVL(P_INTM_NO,NVL(B.INTM_NO,0))
               AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
               AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
               AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
               AND TRUNC (b.expiry_date) <=
                        TRUNC (NVL (TO_DATE(p_ending_date, 'dd-mon-yyyy'), NVL (TO_DATE(p_starting_date, 'dd-mon-yyyy'), b.expiry_date)))
                 AND TRUNC (b.expiry_date) >=
                        DECODE (TO_DATE(p_ending_date, 'dd-mon-yyyy'),
                                NULL, TRUNC (b.expiry_date),
                                TRUNC (NVL (TO_DATE(p_starting_date, 'dd-mon-yyyy'), b.expiry_date))
                               ) 
               --codes below added by gmi... either include package main policies or not.. ung view sa from clause, nahahandle na niang nde ksama ang sub-policies ng package
               AND DECODE(p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
               -- end gmi
               AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
               AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
               AND NVL(P_IS_PACKAGE, B.IS_PACKAGE) = B.IS_PACKAGE
--               AND 1= check_user_per_iss_cd(B.LINE_CD, B.ISS_CD, 'GIEXS006')
             ORDER BY b.expiry_date, POLICY_NO)
                     /*b.iss_cd, b.line_cd, b.subline_cd, b.issue_yy, b.pol_seq_no,
                     b.renew_no, b.iss_cd iss_cd2, b.line_cd line_cd2,
                     b.subline_cd subline_cd2,
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
                     b.tsi_amt, b.prem_amt, b.tax_amt, b.expiry_date, d.line_name,
                     e.subline_name, b.policy_id,
                     DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                     DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag, b.ren_tsi_amt,
                     NVL (b.ren_prem_amt, 0) ren_prem_amt, a.acct_of_cd acct_of_cd,
                     DECODE (a.label_tag, 'Y', 'Leased to :', 'In acct of :') label_tag
                FROM gipi_polbasic a, giex_expiries_v b, giis_line d, giis_subline e
               WHERE b.policy_id = a.policy_id
                 AND NVL (b.post_flag, 'N') = 'N'
                 AND b.line_cd = d.line_cd
                 AND b.subline_cd = e.subline_cd
                 AND d.line_cd = e.line_cd
                 AND b.policy_id = NVL (p_policy_id, b.policy_id)
                 AND b.assd_no = NVL (p_assd_no, b.assd_no)
                 AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
                 AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
                 AND UPPER (b.subline_cd) =
                                         NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
                 AND UPPER (b.line_cd) = NVL (UPPER (p_line_cd), UPPER (b.line_cd))
                 AND TRUNC (b.expiry_date) <=
                        TRUNC (NVL (TO_DATE(p_ending_date), NVL (TO_DATE(p_starting_date), b.expiry_date)))
                 AND TRUNC (b.expiry_date) >=
                        DECODE (TO_DATE(p_ending_date),
                                NULL, TRUNC (b.expiry_date),
                                TRUNC (NVL (TO_DATE(p_starting_date), b.expiry_date))
                               )
                 AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) = 0
                 AND NVL (b.claim_flag, 'N') LIKE
                        NVL
                           (p_claims_flag, DECODE (p_balance_flag, 'Y', 'N', '%'))
                 AND NVL (b.balance_flag, 'N') LIKE
                        NVL
                           (p_balance_flag, DECODE (p_claims_flag, 'Y', 'N', '%'))
              --AND (check_user_per_iss_cd(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1 -- bonok :: 01.25.2013 
                      --OR check_user_per_line(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1) -- bonok :: 01.25.2013
            ORDER BY b.expiry_date, policy_no)*/
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
         details.tax_amt := i.tax_amt;
         details.expiry_date := i.expiry_date;
         details.line_name := i.line_name;
         details.subline_name := i.subline_name;
         details.policy_id := i.policy_id;
         --details.intm_no := i.intm_no;
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
         details.ren_tsi_amt := i.ren_tsi_amt;
         details.ren_prem_amt := i.ren_prem_amt;
         
           FOR c IN (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'COMPANY_NAME')
           LOOP
              details.company_name := c.param_value_v;
           END LOOP;
           
           FOR ad IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'COMPANY_ADDRESS')
           LOOP
              details.company_address   := ad.param_value_v;
           END LOOP;
           
           BEGIN
               FOR c IN (SELECT a.assd_name
                           FROM giis_assured a, giex_expiry b
                          WHERE a.assd_no = b.assd_no AND b.policy_id = i.policy_id)
               LOOP
                  v_assd_name := c.assd_name;
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
               details.assd_name        := v_assd_name;
           END;
           
           FOR c IN (SELECT a.ref_pol_no ref_pol_no
                       FROM gipi_polbasic a
                      WHERE a.policy_id = i.policy_id)
           LOOP
              details.ref_pol_no := c.ref_pol_no;
           END LOOP;
           
--           BEGIN
--               FOR l IN (SELECT DISTINCT a.intm_no,
--                                            TO_CHAR (a.intm_no)
--                                         || '/'
--                                         || ref_intm_cd v_intm_no
--                                    FROM giis_intermediary a,
--                                         gipi_polbasic b,
--                                         gipi_invoice c,
--                                         gipi_comm_invoice d
--                                   WHERE b.policy_id = c.policy_id
--                                     AND c.iss_cd = d.iss_cd
--                                     AND c.prem_seq_no = d.prem_seq_no
--                                     AND c.policy_id = d.policy_id
--                                     AND b.line_cd = i.line_cd
--                                     AND b.subline_cd = i.subline_cd
--                                     AND b.iss_cd = i.iss_cd
--                                     AND b.issue_yy = i.issue_yy
--                                     AND b.pol_seq_no = i.pol_seq_no
--                                     AND b.renew_no = i.renew_no
--                                     AND a.intm_no = d.intrmdry_intm_no
--                                ORDER BY a.intm_no)
--               LOOP
--                  IF v_intm_no IS NULL
--                  THEN
--                     v_intm_no := RTRIM (l.v_intm_no, '/');
--                  ELSE
--                     v_intm_no := v_intm_no || ', ' || RTRIM (l.v_intm_no, '/');
--                  END IF;
--               END LOOP;

--               details.intm_no  := v_intm_no;
--           END;
           
           BEGIN
               BEGIN
                  SELECT iss_name
                    INTO v_iss_name
                    FROM giis_issource
                   WHERE iss_cd = i.iss_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_iss_name := ' ';
               END;

               details.iss_name     := v_iss_name;
           END;
           
           BEGIN
               FOR c IN (SELECT a.assd_name
                           FROM giis_assured a, giex_expiry b
                          WHERE a.assd_no = b.assd_no AND b.policy_id = i.policy_id)
               LOOP
                  v_assd_name := c.assd_name;
                  EXIT;
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

               details.assd_name    := v_assd_name;
           END;
           
           
           BEGIN
               FOR k IN (SELECT i.label_tag || ' ' || a.assd_name assd_name
                           FROM giis_assured a, gixx_polbasic b
                          WHERE b.acct_of_cd > 0
                            AND b.acct_of_cd = i.acct_of_cd
                            AND a.assd_no = b.acct_of_cd)
               LOOP
                  v_acct_of_cd := k.assd_name;
               END LOOP;

               details.acct_of_cd       := v_acct_of_cd;
           END;
           
           BEGIN
               FOR j IN (SELECT a.ref_pol_no ref_pol_no
                           FROM gipi_polbasic a
                          WHERE a.policy_id = i.policy_id)
               LOOP
                  v_ref_pol_no := j.ref_pol_no;
                  EXIT;
               END LOOP;

               details.ref_pol_no       := v_ref_pol_no;
           END;
           
           
           BEGIN
                   FOR c IN (SELECT DISTINCT a.intm_no,
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
                                         AND a.intm_no = d.intrmdry_intm_no
                                    ORDER BY a.intm_no)
                   LOOP
                      IF v_intm_no IS NULL
                      THEN
                         v_intm_no := RTRIM (c.v_intm_no, '/');
                      ELSE
                         v_intm_no := v_intm_no || ', ' || RTRIM (c.v_intm_no, '/');
                      END IF;
                   END LOOP;
            IF v_intm_no IS NULL THEN
               details.intm_no := '';
            ELSE
               details.intm_no := v_intm_no;
            END IF;
         END;
           
           details.starting_date := TO_DATE(p_starting_date, 'dd-mon-yyyy');
           details.ending_date := TO_DATE(p_ending_date, 'dd-mon-yyyy');
           v_intm_no := NULL;
         PIPE ROW (details);
      END LOOP;
   END;
    
   

END giexr106B_pkg;
/


