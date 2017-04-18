CREATE OR REPLACE PACKAGE BODY CPI.GIEXR101B_PKG
AS
/**
* Rey Jadlocon
* 02-22-2012
**/
FUNCTION get_details(P_POLICY_ID        INTEGER,
                     P_ASSD_NO          INTEGER,
                     P_INTM_NO          VARCHAR2,
                     P_ISS_CD           VARCHAR2,
                     P_SUBLINE_CD       VARCHAR2,
                     P_LINE_CD          VARCHAR2,
                     P_ENDING_DATE      VARCHAR2,
                     P_STARTING_DATE    VARCHAR2,
                     p_include_pack     VARCHAR2,
                     p_claims_flag      VARCHAR2,
                     p_balance_flag     VARCHAR2,
                     p_user_id          VARCHAR2) -- marco - 04.29.2013 - added parameter
        RETURN get_details_tab PIPELINED
        IS 
                details get_details_type;
                v_intm_no number;
                v_intm_name varchar2(300);
    BEGIN 
             FOR det IN(SELECT b.iss_cd, b.line_cd, b.subline_cd, b.issue_yy, b.pol_seq_no,
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
                               b.tsi_amt, b.prem_amt,
                               b.expiry_date, d.line_name, e.subline_name, b.policy_id,
                               b.pack_policy_id,                  --sjm 07.20.2012 uw-specs-2012-056
                               DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                               DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag,
                               --NVL (b.ren_tsi_amt, 0) "REN_TSI_AMT", --commented out by sjm 07.25.2012
                               --NVL (b.ren_prem_amt, 0) "REN_PREM_AMT", --commented out by sjm 07.25.2012
                               H.TAX_AMT,
                               G.REN_PREM_AMT,
                               G.REN_TSI_AMT
                          FROM
                               --GIPI_POLBASIC A, commented by gmi.. walang gamit ata ang polbasic d2 since, sa extraction, kuha na lahat ng giex_expiry tables ang values needed here
                               giex_expiries_v b,
                               giis_line d,
                               giis_subline e,
                               (SELECT   NVL (b.policy_id, a.policy_id) policy_id,
                                         SUM (NVL (b.prem_amt, a.prem_amt)) ren_prem_amt,
                                         SUM (NVL (DECODE (d.peril_type, 'B', b.tsi_amt, 0),
                                                   DECODE (d.peril_type, 'B', a.tsi_amt, 0)
                                                  )
                                             ) ren_tsi_amt,
                                         'N' is_package
                                    FROM giex_old_group_peril a,
                                         giex_new_group_peril b,
                                         giis_peril d
                                   WHERE a.policy_id = b.policy_id(+)
                                     AND a.peril_cd = b.peril_cd(+)
                                     AND a.line_cd = d.line_cd
                                     AND a.peril_cd = d.peril_cd
                                     AND a.policy_id IN (SELECT policy_id
                                                           FROM giex_expiry
                                                          WHERE pack_policy_id IS NULL)
                                GROUP BY b.policy_id, a.policy_id
                                UNION
                                SELECT   c.pack_policy_id policy_id,
                                         SUM (NVL (b.prem_amt, a.prem_amt)) ren_prem_amt,
                                         SUM (NVL (DECODE (d.peril_type, 'B', b.tsi_amt, 0),
                                                   DECODE (d.peril_type, 'B', a.tsi_amt, 0)
                                                  )
                                             ) ren_tsi_amt,
                                         'Y' is_package
                                    FROM giex_pack_expiry c,
                                         giex_old_group_peril a,
                                         giex_new_group_peril b,
                                         giis_peril d
                                   WHERE a.policy_id = b.policy_id(+)
                                     AND a.peril_cd = b.peril_cd(+)
                                     AND a.line_cd = d.line_cd
                                     AND a.peril_cd = d.peril_cd
                                     AND a.policy_id IN (SELECT policy_id
                                                           FROM giex_expiry
                                                          WHERE pack_policy_id = c.pack_policy_id)
                                GROUP BY c.pack_policy_id) G,
                             (SELECT NVL (b.policy_id, a.policy_id) policy_id,
                                     SUM (NVL (b.tax_amt, a.tax_amt)) tax_amt,
                                     'N' is_package
                                FROM giex_old_group_tax a, giex_new_group_tax b
                               WHERE a.policy_id = b.policy_id(+)
                                 AND a.line_cd = b.line_cd(+)
                                 AND a.iss_cd = b.iss_cd(+)
                                 AND a.tax_cd = b.tax_cd(+)
                                 AND a.tax_id = b.tax_id(+)
                                 AND a.policy_id IN (
                                  SELECT policy_id
                                    FROM giex_expiry
                                   WHERE pack_policy_id IS NULL)
                               GROUP BY b.policy_id, a.policy_id
                              UNION
                              SELECT c.pack_policy_id policy_id,
                                     SUM (NVL (b.tax_amt, a.tax_amt)) tax_amt,
                                     'Y' is_package
                                FROM giex_old_group_tax a, giex_new_group_tax b, giex_pack_expiry c
                               WHERE a.policy_id = b.policy_id(+)
                                 AND a.line_cd = b.line_cd(+)
                                 AND a.iss_cd = b.iss_cd(+)
                                 AND a.tax_cd = b.tax_cd(+)
                                 AND a.tax_id = b.tax_id(+)
                                 AND a.policy_id IN (
                                  SELECT policy_id
                                    FROM giex_expiry
                                   WHERE pack_policy_id = c.pack_policy_id)
                              GROUP BY c.pack_policy_id) H
                         WHERE 1 = 1                          -- B.POLICY_ID           = A.POLICY_ID
                         AND B.POLICY_ID = G.POLICY_ID
                           AND B.IS_PACKAGE = G.IS_PACKAGE
                           AND B.POLICY_ID = H.POLICY_ID
                           AND B.IS_PACKAGE = H.IS_PACKAGE
                           AND b.line_cd = d.line_cd
                           AND b.subline_cd = e.subline_cd
                           AND d.line_cd = e.line_cd
                           AND NVL (b.post_flag, 'N') = 'N'
                           AND b.policy_id = NVL (p_policy_id, b.policy_id)
                           AND b.assd_no = NVL (p_assd_no, b.assd_no)
                           AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
                           AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
                           AND UPPER (b.subline_cd) =
                                                   NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
                           AND UPPER (b.line_cd) = NVL (UPPER (p_line_cd), UPPER (b.line_cd))
                           AND TRUNC (b.expiry_date) <=
                                     TRUNC (NVL (TO_DATE(p_ending_date, 'DD-MON-YYYY'), NVL (TO_DATE(p_starting_date, 'DD-MON-YYYY'), b.expiry_date)))  --Add date format to avoid exception by CarloR 08.03.2016 SR 22854
                             AND TRUNC (b.expiry_date) >=
                                    DECODE (p_ending_date,
                                            NULL, TRUNC (b.expiry_date),
                                            TRUNC (NVL (TO_DATE(p_starting_date, 'DD-MON-YYYY'), b.expiry_date))  --Add date format to avoid exception by CarloR 08.03.2016 SR 22854
                                           )
                           --codes below added by gmi... either include package main policies or not.. ung view sa from clause, nahahandle na niang nde ksama ang sub-policies ng package
                           AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) = 0
                           -- end gmi
                           AND NVL (b.claim_flag, 'N') LIKE
                                  NVL
                                     (p_claims_flag, DECODE (p_balance_flag, 'Y', 'N', '%'))
                                  /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                           AND NVL (b.balance_flag, 'N') LIKE
                                  NVL
                                     (p_balance_flag, DECODE (p_claims_flag, 'Y', 'N', '%'))
                                  /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                           AND (   (/*b.line_cd = 'MC' AND */b.is_package <> 'Y') -- marco - 04.29.2013 - removed line_cd condition for non-package
                                OR (b.line_cd = giisp.v ('LINE_CODE_PK') AND b.is_package = 'Y')
                               )
                           AND (   check_user_per_iss_cd2 (NVL (UPPER (p_line_cd),
                                                               UPPER (b.line_cd)),
                                                          NVL (UPPER (p_iss_cd), UPPER (b.iss_cd)),
                                                          'GIEXS006',
                                                          p_user_id
                                                         ) = 1 -- marco - 04.29.2013 - changed to check_user_per_iss_cd2
                                OR check_user_per_line2 (NVL (UPPER (p_line_cd), UPPER (b.line_cd)),
                                                        NVL (UPPER (p_iss_cd), UPPER (b.iss_cd)),
                                                        'GIEXS006',
                                                        p_user_id
                                                       ) = 1 -- marco - 04.29.2013 - changed to check_user_per_line2
                               )                 --sjm 07.20.2012 uw-specs-2012-056, for user access
                      ORDER BY b.iss_cd, b.line_cd, b.subline_cd, policy_no)
       LOOP
                    details.iss_cd                  := det.iss_cd;
                    details.line_cd                 := det.line_cd;
                    details.subline_cd              := det.subline_cd;
                    details.issue_yy                := det.issue_yy;
                    details.pol_seq_no              := det.pol_seq_no;
                    details.renew_no                := det.renew_no;
                    details.iss_cd2                 := det.iss_cd2;
                    details.line_cd2                := det.line_cd2;
                    details.subline_cd2             := det.subline_cd2;
                    details.policy_no               := det.policy_no;
                    details.tsi_amt                 := det.tsi_amt;
                    details.prem_amt                := det.prem_amt;
                    details.tax_amt                 := det.tax_amt;
                    details.expiry_date             := det.expiry_date;
                    details.line_name               := det.line_name;
                    details.subline_name            := det.subline_name;
                    details.policy_id               := det.policy_id;
                    details.balance_flag            := det.balance_flag;
                    details.claim_flag              := det.claim_flag;
                    details.ren_tsi_amt             := det.ren_tsi_amt;
                    details.ren_prem_amt            := det.ren_prem_amt; 
                    details.starting_date           := TO_CHAR(TO_DATE(P_STARTING_DATE,'DD-MON-RRRR'),'Month dd, RRRR');
                    details.ending_date             := TO_CHAR(TO_DATE(P_ENDING_DATE,'DD-MON-RRRR'),'Month dd, RRRR');            
                    
                    FOR c IN (SELECT param_value_v
                                FROM giis_parameters
                               WHERE param_name = 'COMPANY_NAME')
                    LOOP
                            details.company_name := c.param_value_v;
                    END LOOP;
                    
                    FOR d IN (select param_value_v
                                from giis_parameters 
                               where param_name = 'COMPANY_ADDRESS')
                    LOOP
                            details.company_address := d.param_value_v;
                    END LOOP;
                    
                    FOR A IN (SELECT text
  					  FROM giis_document
  					 WHERE title = 'PRINT_AMOUNTS'
  					   AND report_id = 'GIEXR101B') 
                   LOOP
                         details.text := A.text;
                   END LOOP;
                   
                   FOR n IN(SELECT iss_name
                           FROM giis_issource
                          WHERE iss_cd = det.iss_cd)
                   LOOP
                        details.iss_name    := n.iss_name;
                   END LOOP;
                   
                   FOR C2 IN (select a.assd_name
                                from giis_assured a,
                                     gipi_polbasic b
                               where a.assd_no = b.assd_no
                                 and  b.line_cd    = det.line_cd
                                 and  b.subline_cd = det.subline_cd 
                                 and  b.iss_cd     = det.iss_cd
                                 and  b.issue_yy   = det.issue_yy
                                 and  b.pol_seq_no = det.pol_seq_no
                                 and  b.renew_no   = det.renew_no)
                   LOOP                
                         details.ASSD_NAME := C2.ASSD_NAME;
                   END LOOP;
                   
                   FOR i IN(SELECT A.REF_POL_NO REF_POL_NO
                              FROM GIPI_POLBASIC A
                              WHERE A.POLICY_ID = det.POLICY_ID)
                   LOOP
                            details.REF_POL_NO := i.REF_POL_NO;
                   END LOOP;
                   
                    FOR C IN(select distinct A.INTM_NO, to_char(A.INTM_NO)||'/'||ref_intm_cd v_intm_no
                               from giis_intermediary a,
                                    gipi_polbasic b,
                                    gipi_invoice c,
                                    gipi_comm_invoice d
                               where b.policy_id = c.policy_id and
                                     c.iss_cd = d.iss_cd and
                                     c.prem_seq_no = d.prem_seq_no and
                                     c.policy_id = d.policy_id and
                                     B.LINE_CD = det.line_cd    AND
                                     B.SUBLINE_CD = det.subline_cd AND
                                     B.ISS_CD = det.iss_cd AND
                                     B.ISSUE_YY = det.issue_yy AND
                                     B.POL_SEQ_NO = det.pol_seq_no AND
                                     B.RENEW_NO  = det.RENEW_NO AND  
                                     --B.POL_FLAG IN ('1','2','3') 
                                     a.intm_no = d.INTRMDRY_INTM_NO 
                                     order by a.intm_no)
                          LOOP
                            IF v_intm_no IS NULL THEN
                               details.intm_no := rtrim(c.v_intm_no,'/');
                            ELSE
                               details.INTM_NO :=v_intm_no||', '||rtrim(C.v_intm_no,'/');
                            END IF;
                          END LOOP;
                          
                        FOR C IN(select distinct A.INTM_NO, A.intm_name v_intm_name
                                   from giis_intermediary a,
                                        gipi_polbasic b,
                                        gipi_invoice c,
                                        gipi_comm_invoice d
                                  where b.policy_id = c.policy_id and
                                        c.iss_cd = d.iss_cd and
                                        c.prem_seq_no = d.prem_seq_no and
                                        c.policy_id = d.policy_id and
                                        B.LINE_CD = det.line_cd    AND
                                        B.SUBLINE_CD = det.subline_cd AND
                                        B.ISS_CD = det.iss_cd AND
                                        B.ISSUE_YY = det.issue_yy AND
                                        B.POL_SEQ_NO = det.pol_seq_no AND
                                        B.RENEW_NO  = det.RENEW_NO AND  
                                        --B.POL_FLAG IN ('1','2','3') AND
                                        a.intm_no = d.INTRMDRY_INTM_NO 
                                        --order by a.intm_no
                                        )
                          LOOP
                            IF v_intm_name IS NULL THEN
                               details.intm_name := c.v_intm_name;
                            ELSE
                               details.INTM_Name :=v_intm_name||', '||C.v_intm_name;
                            END IF;
                          END LOOP;
                          
                    
             PIPE ROW(details);      
       END LOOP;
       
    END;

END GIEXR101B_PKG;
/


