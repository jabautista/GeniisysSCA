CREATE OR REPLACE PACKAGE BODY CPI.giexr105A_pkg
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
      p_is_package      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      details        get_details_type;
      v_intm_no      VARCHAR2 (2000);
      v_intm_no2     VARCHAR2 (2000);
      v_intm_name    VARCHAR2 (240);
      item_desc      VARCHAR2 (500);
      makeformula    VARCHAR2 (500);
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN (SELECT B.PACK_POLICY_ID,
                       b.intm_no,
                       B.ISS_CD,
                       B.LINE_CD,
                       B.SUBLINE_CD,
                       B.LINE_CD||'-'||
                       RTRIM(B.SUBLINE_CD)||'-'||
                       RTRIM(B.ISS_CD)||'-'||
                       LTRIM(TO_CHAR(B.ISSUE_YY,'09'))||'-'||
                       LTRIM(TO_CHAR(B.POL_SEQ_NO,'0999999'))||'-'||
                       LTRIM(TO_CHAR(B.RENEW_NO,'09')) POLICY_NO,
                       B.ISSUE_YY,
                       B.POL_SEQ_NO,       
                       B.RENEW_NO,
                       B.ISS_CD ISS_CD2,
                       B.LINE_CD LINE_CD2,
                       B.SUBLINE_CD SUBLINE_CD2,       
                       B.TSI_AMT ,
                       B.REN_TSI_AMT, 
                       B.PREM_AMT,
                       B.REN_PREM_AMT,
                       B.TAX_AMT,
                       B.EXPIRY_DATE,
                       D.LINE_NAME,
                       E.SUBLINE_NAME,
                       B.POLICY_ID,
                       DECODE(B.BALANCE_FLAG,'Y','*',NULL) BALANCE_FLAG,
                       DECODE(B.CLAIM_FLAG,'Y','*',NULL) CLAIM_FLAG
                  FROM --GIPI_POLBASIC                     A,
                       GIEX_EXPIRY B,
                       GIIS_LINE D,
                       GIIS_SUBLINE E
                 WHERE 1 = 1 --B.POLICY_ID           = A.POLICY_ID
                   AND B.LINE_CD = D.LINE_CD
                   AND B. SUBLINE_CD = E.SUBLINE_CD
                   AND D.LINE_CD = E.LINE_CD  
                   AND B.RENEW_FLAG = '1'
                   AND NVL(B.POST_FLAG, 'N') = 'N'
                   AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)
                   AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
                   AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                   AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
                   AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                   AND TRUNC(b.expiry_date) <= TRUNC(NVL(TO_DATE(p_ending_date, 'dd-mon-yyyy'),NVL(TO_DATE(p_starting_date, 'dd-mon-yyyy'),b.expiry_date)))
                   AND TRUNC(b.expiry_date) >= DECODE(TO_DATE(p_ending_date, 'dd-mon-yyyy'),NULL,TRUNC(b.expiry_date),TRUNC(NVL(TO_DATE(p_starting_date, 'dd-mon-yyyy'),b.expiry_date)))
                   -- AND DECODE(:p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
                   -- end gmi
                   AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                   AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
--                   AND (check_user_per_iss_cd(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)), 'GIEXS006') = 1
--                        OR check_user_per_line(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)), 'GIEXS006') = 1)
                   AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GIEXS006', p_user_id) = 1 --apollo cruz 03.04.2015
                   AND NVL(P_IS_PACKAGE, 'N')  = 'N'    
             UNION ALL
                SELECT DISTINCT B.PACK_POLICY_ID PACK_POLICY_ID, --added to consider package policy adpascual 
                       b.intm_no,
                       B.ISS_CD,
                       B.LINE_CD,
                       B.SUBLINE_CD,
                       B.LINE_CD||'-'||
                       RTRIM(B.SUBLINE_CD)||'-'||
                       RTRIM(B.ISS_CD)||'-'||
                       LTRIM(TO_CHAR(B.ISSUE_YY,'09'))||'-'||
                       LTRIM(TO_CHAR(B.POL_SEQ_NO,'0999999'))||'-'||
                       LTRIM(TO_CHAR(B.RENEW_NO,'09')) POLICY_NO,
                       B.ISSUE_YY,
                       B.POL_SEQ_NO,       
                       B.RENEW_NO,
                       B.ISS_CD ISS_CD2,
                       B.LINE_CD LINE_CD2,
                       B.SUBLINE_CD SUBLINE_CD2,       
                       B.TSI_AMT,
                       B.REN_TSI_AMT, 
                       B.PREM_AMT,
                       B.REN_PREM_AMT,
                       B.TAX_AMT,
                       B.EXPIRY_DATE,
                       D.LINE_NAME,
                       E.SUBLINE_NAME,
                       0 POLICY_ID,
                       DECODE(B.BALANCE_FLAG,'Y','*',NULL) BALANCE_FLAG,
                       DECODE(B.CLAIM_FLAG,'Y','*',NULL) CLAIM_FLAG
                  FROM --GIPI_POLBASIC                     A,
                       GIEX_PACK_EXPIRY B,
                       GIEX_EXPIRY C,
                       GIIS_LINE D,
                       GIIS_SUBLINE E
                 WHERE 1 = 1 --B.POLICY_ID           = A.POLICY_ID
                   AND B.LINE_CD = D.LINE_CD
                   AND B.SUBLINE_CD = E.SUBLINE_CD
                   AND D.LINE_CD = E.LINE_CD 
                   AND B.PACK_POLICY_ID = C.PACK_POLICY_ID 
                   AND B.RENEW_FLAG = '1'
                   AND NVL(B.POST_FLAG, 'N') = 'N'
                   AND B.PACK_POLICY_ID = NVL(P_POLICY_ID, B.PACK_POLICY_ID)
                   AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
                   AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                   AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
                   AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                   AND TRUNC(b.expiry_date) <= TRUNC(NVL(TO_DATE(p_ending_date, 'dd-mon-yyyy'),NVL(TO_DATE(p_starting_date, 'dd-mon-yyyy'),b.expiry_date)))
                   AND TRUNC(b.expiry_date) >= DECODE(TO_DATE(p_ending_date, 'dd-mon-yyyy'),NULL,TRUNC(b.expiry_date),TRUNC(NVL(TO_DATE(p_starting_date, 'dd-mon-yyyy'),b.expiry_date))) 
                   --codes below added by gmi... either include package main policies or not.. ung view sa from clause, nahahandle na niang nde ksama ang sub-policies ng package
                   AND DECODE(p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
                   -- end gmi
                   AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                   AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
--                   AND (check_user_per_iss_cd(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)),'GIEXS006') = 1
--                        OR check_user_per_line(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)),'GIEXS006') = 1)
                   AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GIEXS006', p_user_id) = 1 --apollo cruz 03.04.2015
                   AND NVL(P_IS_PACKAGE, 'Y')  = 'Y'
                 ORDER BY 2, 3, 4, 5)
         /*(SELECT   b.iss_cd, b.line_cd, b.subline_cd,
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
                   b.prem_amt, NVL (b.tax_amt, 0) tax_amt, b.expiry_date,
                   d.line_name, e.subline_name, b.policy_id,
                   DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                   DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag,
                   b.ren_prem_amt, b.ren_tsi_amt
              FROM giex_expiries_v b, giis_line d, giis_subline e
             WHERE 1 = 1
               AND b.line_cd = d.line_cd
               AND b.subline_cd = e.subline_cd
               AND d.line_cd = e.line_cd
               AND b.renew_flag = '1'
               AND b.policy_id = NVL (p_policy_id, b.policy_id)
               AND b.assd_no = NVL (p_assd_no, b.assd_no)
               AND NVL (b.post_flag, 'N') = 'N'
               AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
               AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
               AND UPPER (b.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
               AND UPPER (b.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (b.line_cd))
               AND TRUNC (b.expiry_date) <=
                      TRUNC (NVL (TO_DATE(p_ending_date),
                                  NVL (TO_DATE (p_starting_date),
                                       b.expiry_date
                                      )
                                 )
                            )
               AND TRUNC (b.expiry_date) >=
                      DECODE (TO_DATE (p_ending_date),
                              NULL, TRUNC (b.expiry_date),
                              TRUNC (NVL (TO_DATE (p_starting_date),
                                          b.expiry_date
                                         )
                                    )
                             )
               AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) = 0
               AND NVL (b.claim_flag, 'N') LIKE
                      NVL (p_claims_flag,
                           DECODE (p_balance_flag, 'Y', 'N', '%')
                          )
               AND NVL (b.balance_flag, 'N') LIKE
                      NVL (p_balance_flag,
                           DECODE (p_claims_flag, 'Y', 'N', '%')
                          )
			   AND (check_user_per_iss_cd(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1 -- bonok :: 01.25.2013 
                    OR check_user_per_line(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1) -- bonok :: 01.25.2013
          ORDER BY b.iss_cd, b.line_cd, b.subline_cd, policy_no)*/
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
         details.grp_intm_no := i.intm_no;
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
         
         IF details.company_name IS NULL THEN
            details.company_name := giisp.v('COMPANY_NAME');
            details.company_address := giisp.v('COMPANY_ADDRESS');
         END IF;
             
           FOR p IN (SELECT a.ref_pol_no ref_pol_no
                       FROM gipi_polbasic a
                      WHERE a.policy_id = i.policy_id)
           LOOP
              details.ref_pol_no := p.ref_pol_no;
           END LOOP;
   
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
--              IF t.v_intm_no = NULL
--              THEN
--                 details.intm_no := RTRIM (t.v_intm_no, '/');
--              ELSE
--                 details.intm_no := v_intm_no || ', ' || RTRIM (t.v_intm_no, '/');
--              END IF;
              details.intm_no := t.v_intm_no;
           END LOOP;
         
         -- bonok start :: 01.25.2013  
		 SELECT iss_name
      	   INTO details.iss_name
           FROM giis_issource
          WHERE iss_cd = i.iss_cd;
		 
		 SELECT a.assd_name
		   INTO details.assd_name
           FROM giis_assured a, giex_expiry b
          WHERE a.assd_no = b.assd_no 
		    AND b.policy_id = i.policy_id;                    
           
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
                  
         details.starting_date := TO_DATE(p_starting_date, 'dd-mon-yyyy');
         details.ending_date   := TO_DATE(p_ending_date, 'dd-mon-yyyy');
         -- bonok end :: 01.25.2013
         
         BEGIN
            SELECT intm_name
              INTO details.intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            details.intm_name := NULL;
         END;
         		 
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
END giexr105A_pkg;
/


