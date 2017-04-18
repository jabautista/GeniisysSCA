CREATE OR REPLACE PACKAGE BODY CPI.GIEXR103B_PKG
AS

FUNCTION get_details(p_policy_id            number,
                     p_assd_no              number,
                     p_intm_no              number,
                     p_iss_cd               varchar2,
                     p_subline_cd           varchar2,
                     p_line_cd              varchar2,
                     p_ending_date          varchar2,
                     p_starting_date        varchar2,
                     p_include_pack         varchar2,
                     p_claims_flag          varchar2,
                     p_balance_flag         varchar2,
                     p_is_package           varchar2,
                     p_user_id              varchar2)
         RETURN get_details_tab PIPELINED
          IS details get_details_type;
            v_intm_no   VARCHAR2 (2000);
            v_intm_no2   VARCHAR2 (2000);
            item_desc       varchar2(2000);
            makeformula     varchar2(500);
    BEGIN 
           FOR i IN(SELECT B.ISS_CD,
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
                              LTRIM(TO_CHAR(B.RENEW_NO,'09'))                        POLICY_NO,
                           B.TSI_AMT , 
                           B.PREM_AMT,
                           --B.TAX_AMT,
                           H.TAX_AMT,
                           B.EXPIRY_DATE,
                           D.LINE_NAME,
                           E.SUBLINE_NAME,
                           B.POLICY_ID,
                           I.INTM_NO,
                           I.INTM_NAME,
                           DECODE(B.BALANCE_FLAG,'Y','*',NULL) BALANCE_FLAG,
                           DECODE(B.CLAIM_FLAG,'Y','*',NULL) CLAIM_FLAG,
                           --NVL( B. REN_PREM_AMT,0) REN_PREM_AMT, --added by april as of 09/21/2007
                           --NVL(B. REN_TSI_AMT,0) REN_TSI_AMT--added by april as of 09/21/2007
                           G.REN_PREM_AMT REN_PREM_AMT,
                           G.REN_TSI_AMT REN_TSI_AMT,
                           B.IS_PACKAGE
                      FROM --GIPI_POLBASIC A, commented by gmi.. walang gamit ata ang polbasic d2 since, sa extraction, kuha na lahat ng giex_expiry tables ang values needed here
                           GIEX_EXPIRIES_V B,
                           GIIS_LINE D,
                           GIIS_SUBLINE E,
                           (SELECT policy_id, iss_cd, prem_seq_no, 'N' is_package
                              FROM gipi_invoice
                            UNION ALL
                            SELECT policy_id, iss_cd, prem_seq_no, 'Y' is_package
                              FROM gipi_pack_invoice) F,
                           (SELECT a.intm_no, a.intm_name, b.iss_cd, b.prem_seq_no
                              FROM giis_intermediary a, gipi_comm_invoice b
                             WHERE a.intm_no = b.intrmdry_intm_no
                           ) I,
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
                     WHERE 1=1 --B.POLICY_ID           = A.POLICY_ID
                       AND B.POLICY_ID = G.POLICY_ID
                       AND B.IS_PACKAGE = G.IS_PACKAGE
                       AND B.POLICY_ID = H.POLICY_ID
                       AND B.IS_PACKAGE = H.IS_PACKAGE
                       AND B.LINE_CD = D.LINE_CD
                       AND B. SUBLINE_CD = E.SUBLINE_CD
                       AND D.LINE_CD = E.LINE_CD  
                       AND B.POLICY_ID = F.POLICY_ID
                       AND F.IS_PACKAGE = B.IS_PACKAGE
                       AND F.ISS_CD = I.ISS_CD
                       AND F.PREM_SEQ_NO = I.PREM_SEQ_NO      
                       AND NVL(B.POST_FLAG, 'N') = 'N'
                       AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)
                       AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
                       AND NVL(B.INTM_NO,0) = NVL(P_INTM_NO,NVL(B.INTM_NO,0))
                       AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                       AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
                       AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                       AND TRUNC (b.expiry_date) <=
                               TRUNC (NVL (TO_DATE(p_ending_date, 'DD-MON-YYYY'), NVL (TO_DATE(p_starting_date, 'DD-MON-YYYY'), b.expiry_date))) --Added date format to prevent invalid date exception by CarloR 08.19.2016 SR-22852  -start
                       AND TRUNC (b.expiry_date) >=
                               DECODE (TO_DATE(p_ending_date, 'DD-MON-YYYY'),
                                      NULL, TRUNC (b.expiry_date),
                                      TRUNC (NVL (TO_DATE(p_starting_date, 'DD-MON-YYYY'), b.expiry_date)) --end
                                     ) 
                       --codes below added by gmi... either include package main policies or not.. ung view sa from clause, nahahandle na niang nde ksama ang sub-policies ng package
                       AND DECODE(p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
                       -- end gmi
                       AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                       AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                       AND NVL(P_IS_PACKAGE, B.IS_PACKAGE) = B.IS_PACKAGE
                       AND 1= check_user_per_iss_cd2(B.LINE_CD, B.ISS_CD, 'GIEXS006', p_user_id)
                       ORDER BY intm_no, iss_cd, line_cd, subline_cd, policy_no)
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
                           e.subline_name, b.policy_id, e.intm_no, e.intm_name,
                           DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                           DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag,
                           NVL (b.ren_prem_amt, 0) ren_prem_amt, 
                           NVL (b.ren_tsi_amt, 0) ren_tsi_amt    
                      FROM
                           giex_expiries_v b,
                           giis_line d,
                           giis_subline e,
                           gipi_comm_invoice f,
                           giis_intermediary e
                     WHERE 1 = 1                             
                       AND b.line_cd = d.line_cd
                       AND b.subline_cd = e.subline_cd
                       AND d.line_cd = e.line_cd
                       AND b.policy_id = f.policy_id
                       AND f.intrmdry_intm_no = e.intm_no
                       AND NVL (b.post_flag, 'N') = 'N'
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
                                 (p_balance_flag, DECODE (p_claims_flag, 'Y', 'N', '%'))*/
         LOOP
                    details.ISS_CD              := i.ISS_CD;
                    details.LINE_CD             := i.LINE_CD;
                    details.SUBLINE_CD          := i.SUBLINE_CD;
                    details.ISSUE_YY            := i.ISSUE_YY;
                    details.POL_SEQ_NO          := i.POL_SEQ_NO;
                    details.RENEW_NO            := i.RENEW_NO;
                    details.ISS_CD2             := i.ISS_CD2;
                    details.LINE_CD2            := i.LINE_CD2;
                    details.SUBLINE_CD2         := i.SUBLINE_CD2;
                    details.POLICY_NO           := i.POLICY_NO;
                    details.TSI_AMT             := i.TSI_AMT;
                    details.PREM_AMT            := i.PREM_AMT;
                    details.TAX_AMT             := i.TAX_AMT;
                    details.EXPIRY_DATE         := i.EXPIRY_DATE;
                    details.LINE_NAME           := i.LINE_NAME;
                    details.SUBLINE_NAME        := i.SUBLINE_NAME;
                    details.POLICY_ID           := i.POLICY_ID;
                    details.INTM_NO             := i.INTM_NO;
                    details.INTM_NAME           := i.INTM_NAME;
                    details.BALANCE_FLAG        := i.BALANCE_FLAG;
                    details.CLAIM_FLAG          := i.CLAIM_FLAG;
                    details.REN_TSI_AMT         := i.REN_TSI_AMT;
                    details.REN_PREM_AMT        := i.REN_PREM_AMT;
                    details.total_due           := NVL(i.ren_prem_amt,0) + NVL(i.tax_amt,0);
                    
                      FOR c IN (SELECT param_value_v
                                  FROM giis_parameters
                                 WHERE param_name = 'COMPANY_NAME')
                      LOOP
                        details.company_name := c.param_value_v;
                      END LOOP;
                      
                       FOR com IN (SELECT param_value_v
                                     FROM giis_parameters
                                    WHERE param_name = 'COMPANY_ADDRESS')
                       LOOP
                            details.company_address := com.param_value_v;
                       END LOOP;
                      
                    SELECT iss_name
                      INTO details.iss_name
                      FROM giis_issource
                     WHERE iss_cd = i.iss_cd;
                      
                    details.starting_date := TO_DATE(p_starting_date, 'DD-MON-YYYY'); --CarloR 08.19.2016 SR-22852 -start
                    details.ending_date := TO_DATE(p_ending_date, 'DD-MON-YYYY');  --end
                    
                    IF i.is_package = 'Y' THEN
                       SELECT a.assd_name
                         INTO details.assd_name 
				         FROM giis_assured a, giex_pack_expiry b
			            WHERE a.assd_no = b.assd_no
                          AND b.pack_policy_id = i.policy_id;
					ELSIF i.is_package = 'N' THEN					
					   SELECT a.assd_name
                         INTO details.assd_name 
				         FROM giis_assured a, giex_expiry b
			            WHERE a.assd_no = b.assd_no
                          AND b.policy_id = i.policy_id;
				    END IF;                                             
                    
                    IF i.is_package = 'Y' THEN
                        SELECT ref_pol_no
                          INTO details.ref_pol_no
                          FROM gipi_pack_polbasic
                         WHERE pack_policy_id = i.policy_id;
                    ELSE
                        SELECT ref_pol_no
                          INTO details.ref_pol_no
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id;
                    END IF;                              
                    
                    PIPE ROW(details);
         END LOOP;
    END;

END GIEXR103B_PKG;
/


