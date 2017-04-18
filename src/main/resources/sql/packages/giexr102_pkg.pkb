CREATE OR REPLACE PACKAGE BODY CPI.GIEXR102_PKG
AS
/**
* Rey Jadlocon
* 02-29-2012
**/
FUNCTION get_details(P_POLICY_ID            GIEX_EXPIRIES_V.POLICY_ID%TYPE,
                     P_ASSD_NO              GIEX_EXPIRIES_V.ASSD_NO%TYPE,
                     P_ISS_CD               GIEX_EXPIRIES_V.ISS_CD%TYPE,
                     P_SUBLINE_CD           GIEX_EXPIRIES_V.SUBLINE_CD%TYPE,
                     P_LINE_CD              GIEX_EXPIRIES_V.LINE_CD%TYPE,
                     P_STARTING_DATE        VARCHAR2, 
                     P_ENDING_DATE          VARCHAR2,
                     P_INCLUDE_PACK         VARCHAR2,
                     P_CLAIMS_FLAG          VARCHAR2,
                     P_BALANCE_FLAG         VARCHAR2,
                     p_is_package           VARCHAR2,
                     p_user_id              VARCHAR2) -- marco - 04.29.2013 - added parameter)                     
        RETURN get_details_tab PIPELINED
        IS 
            details get_details_type;
            v_intm_no   VARCHAR2(2000);
            v_intm_name   VARCHAR2(240);
            v_intm_name2  VARCHAR(240);
            v_prev_pol  VARCHAR2(100) := ' ';
   BEGIN
         FOR i IN(SELECT DISTINCT B.POLICY_ID,
                                  B.ISS_CD,
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
                                  B.TAX_AMT,
                                  B.EXPIRY_DATE,
                                  D.LINE_NAME,
                                  E.SUBLINE_NAME,
                                  B.PACK_POLICY_ID, --added to consider package policy adpascual 07.19.2012 
                                  DECODE(G.PERIL_CD, NULL, F.PERIL_CD, G.PERIL_CD) PERIL_CD,
                                  DECODE(G.PREM_AMT, NULL, F.PREM_AMT, G.PREM_AMT) PREM_AMT2,
                                  DECODE(G.TSI_AMT, NULL, F.TSI_AMT, G.TSI_AMT) TSI_AMT2
                             FROM GIEX_EXPIRY B, 
                                  GIIS_LINE D,
                                  GIIS_SUBLINE E,
                                  GIEX_OLD_GROUP_PERIL F,
                                  GIEX_NEW_GROUP_PERIL G
                            WHERE 1=1 
                              AND B.LINE_CD = D.LINE_CD
                              AND B.SUBLINE_CD = E.SUBLINE_CD
                              AND D.LINE_CD = E.LINE_CD  
                              AND B.POLICY_ID = F.POLICY_ID
                              AND F.POLICY_ID = G.POLICY_ID(+)
                              AND NVL(B.POST_FLAG, 'N') = 'N'
                              AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)
                              AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
                              AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                              AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
                              AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                              AND TRUNC(B.EXPIRY_DATE) <= DECODE(TO_DATE(P_STARTING_DATE), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_ENDING_DATE), B.EXPIRY_DATE))) 
                              AND TRUNC(B.EXPIRY_DATE) >= DECODE(TO_DATE(P_ENDING_DATE), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_STARTING_DATE), B.EXPIRY_DATE)))  
                              --AND DECODE(p_include_pack, 'Y', B.PACK_POLICY_ID, 0)  = 0 -- marco - 04.29.2013 
                              AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) 
                              AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) 
                              AND (check_user_per_iss_cd2(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)), 'GIEXS006', p_user_id) = 1 -- marco - 04.29.2013 - changed to check_user_per_iss_cd2 and check_user_per_line2
                                   OR check_user_per_line2(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)), 'GIEXS006', p_user_id) = 1)-- adpascual 07.20.2012 to consider user accessibility
                              AND NVL(P_IS_PACKAGE, 'N')  = 'N'
                         UNION ALL
                         SELECT DISTINCT C.POLICY_ID,
                                         B.ISS_CD,
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
                                         B.TAX_AMT,
                                         B.EXPIRY_DATE,
                                         D.LINE_NAME,
                                         E.SUBLINE_NAME,
                                         B.PACK_POLICY_ID, 
                                         DECODE(G.PERIL_CD, NULL, F.PERIL_CD, G.PERIL_CD) PERIL_CD,
                                         DECODE(G.PREM_AMT, NULL, F.PREM_AMT, G.PREM_AMT) PREM_AMT2,
                                         DECODE(G.TSI_AMT, NULL, F.TSI_AMT, G.TSI_AMT) TSI_AMT2
                                    FROM GIEX_PACK_EXPIRY B,  
                                         GIEX_EXPIRY C,
                                         GIIS_LINE D,
                                         GIIS_SUBLINE E,
                                         GIEX_OLD_GROUP_PERIL F,
                                         GIEX_NEW_GROUP_PERIL G
                                   WHERE 1=1 
                                     AND B.LINE_CD = D.LINE_CD 
                                     AND B.SUBLINE_CD = E.SUBLINE_CD
                                     AND D.LINE_CD = E.LINE_CD  
                                     AND B.PACK_POLICY_ID = C.PACK_POLICY_ID
                                     AND C.POLICY_ID = F.POLICY_ID
                                     AND F.POLICY_ID = G.POLICY_ID(+)
                                     AND NVL(B.POST_FLAG, 'N') = 'N'
                                     AND B.PACK_POLICY_ID = NVL(P_POLICY_ID, B.PACK_POLICY_ID)
                                     AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
                                     AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                                     AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
                                     AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                                     AND TRUNC(B.EXPIRY_DATE) <= DECODE(TO_DATE(P_STARTING_DATE), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_ENDING_DATE), B.EXPIRY_DATE))) 
                                     AND TRUNC(B.EXPIRY_DATE) >= DECODE(TO_DATE(P_ENDING_DATE), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_STARTING_DATE), B.EXPIRY_DATE)))  
                                     AND DECODE(p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
                                     AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%'))
                                     AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) 
                                     AND (check_user_per_iss_cd2(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)), 'GIEXS006', p_user_id) = 1 -- marco - 04.29.2013 - changed to check_user_per_iss_cd2 and check_user_per_line2
                                          OR check_user_per_line2(NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD)),NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD)), 'GIEXS006', p_user_id) = 1)-- adpascual 07.20.2012 to consider user accessibility
                                     AND NVL(P_IS_PACKAGE, 'Y')  = 'Y'
                                     ORDER BY ISS_CD,LINE_CD,SUBLINE_CD,POLICY_NO)
                         /*B.ISS_CD,
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
                         B.TAX_AMT,
                         B.EXPIRY_DATE,
                         D.LINE_NAME,
                         E.SUBLINE_NAME,
                         B.POLICY_ID,
                         F.PERIL_CD,
                         F.PREM_AMT PREM_AMT2,
                         F.TSI_AMT TSI_AMT2
                    FROM
                         GIEX_EXPIRIES_V B,
                         GIIS_LINE D,
                         GIIS_SUBLINE E,
                         GIEX_OLD_GROUP_PERIL F
                   WHERE 1=1 
                     AND B.LINE_CD = D.LINE_CD
                     AND B.SUBLINE_CD = E.SUBLINE_CD
                     AND D.LINE_CD = E.LINE_CD  
                     AND  B.POLICY_ID = F.POLICY_ID
                     AND NVL(B.POST_FLAG, 'N') = 'N'
                     AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)
                     AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)    
                     AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                     AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))     
                     AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))   
                     AND TRUNC(B.EXPIRY_DATE) <= DECODE(TO_DATE(P_STARTING_DATE), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_ENDING_DATE), B.EXPIRY_DATE))) 
                     AND TRUNC(B.EXPIRY_DATE) >= DECODE(TO_DATE(P_ENDING_DATE), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_STARTING_DATE), B.EXPIRY_DATE))) 
                     AND DECODE(p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
                     AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) 
                     AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%'))*/
        LOOP
                    details.ISS_CD          := i.ISS_CD;
                    details.LINE_CD         := i.LINE_CD;
                    details.SUBLINE_CD      := i.SUBLINE_CD;
                    details.ISSUE_YY        := i.ISSUE_YY;
                    details.POL_SEQ_NO      := i.POL_SEQ_NO;
                    details.RENEW_NO        := i.RENEW_NO;
                    details.ISS_CD2         := i.ISS_CD2;
                    details.LINE_CD2        := i.LINE_CD2;
                    details.SUBLINE_CD2     := i.SUBLINE_CD2;
                    details.POLICY_NO       := i.POLICY_NO;
                    details.TSI_AMT         := i.TSI_AMT;
                    details.PREM_AMT        := i.PREM_AMT;
                    details.TAX_AMT         := i.TAX_AMT;
                    details.EXPIRY_DATE     := i.EXPIRY_DATE;
                    details.LINE_NAME       := i.LINE_NAME;
                    details.SUBLINE_NAME    := i.SUBLINE_NAME;
                    details.POLICY_ID       := i.POLICY_ID;
                    details.PERIL_CD        := i.PERIL_CD;
                    details.PREM_AMT2       := i.PREM_AMT2;
                    details.TSI_AMT2        := i.TSI_AMT2;
                    details.starting_date   := TO_CHAR(TO_DATE(P_STARTING_DATE,'dd-MM-RRRR'),'Month dd, RRRR');
                    details.ending_date     := TO_CHAR(TO_DATE(P_ENDING_DATE,'dd-MM-RRRR'),'Month dd, RRRR');
                    
                    FOR c IN (SELECT param_value_v
                                FROM giis_parameters
                               WHERE param_name = 'COMPANY_NAME')
                    LOOP
                           details.company_name := c.param_value_v;
                    END LOOP;
                    
                    FOR m IN (select param_value_v
                        from giis_parameters 
                       where param_name = 'COMPANY_ADDRESS')
                    LOOP
                        details.company_address := m.param_value_v;
                    END LOOP;
                    
                    FOR n IN (SELECT iss_name
                              FROM giis_issource
                             WHERE iss_cd = i.iss_cd)
                    LOOP
                        details.iss_name    := n.iss_name;
                    END LOOP;
                    
                    details.assd_name      := CF_ASSURED(i.line_cd,i.subline_cd,i.iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no,i.policy_id);
                
                    FOR l IN(SELECT A.REF_POL_NO REF_POL_NO
                                   FROM GIPI_POLBASIC A
                                  WHERE A.POLICY_ID = i.POLICY_ID )
                      LOOP
                                details.REF_POL_NO := l.REF_POL_NO;
                      END LOOP;
                    
                    /*FOR q IN(select distinct A.INTM_NO, to_char(A.INTM_NO)||'/'||ref_intm_cd v_intm_no
                               from giis_intermediary a,
                                    gipi_polbasic b,
                                    gipi_invoice c,
                                    gipi_comm_invoice d
                              where b.policy_id = c.policy_id 
                                and c.iss_cd = d.iss_cd 
                                and c.prem_seq_no = d.prem_seq_no 
                                and c.policy_id = d.policy_id 
                                and B.LINE_CD = i.line_cd    
                                AND B.SUBLINE_CD = i.subline_cd 
                                AND B.ISS_CD = i.iss_cd 
                                AND B.ISSUE_YY = i.issue_yy 
                                AND B.POL_SEQ_NO = i.pol_seq_no 
                                AND B.RENEW_NO  = i.RENEW_NO 
                                AND a.intm_no = d.INTRMDRY_INTM_NO 
                              order by a.intm_no)
                        LOOP
                            IF v_intm_no IS NULL THEN
                               v_intm_no := rtrim(q.v_intm_no,'/');
                            ELSE
                               v_INTM_NO := rtrim(q.v_intm_no,'/');
                            END IF;
                        END LOOP;
                          
                          FOR r IN(select distinct A.INTM_NO, A.intm_name v_intm_name
                                     from giis_intermediary a,
                                          gipi_polbasic b,
                                          gipi_invoice c,
                                          gipi_comm_invoice d
                                    where b.policy_id = c.policy_id 
                                      and c.iss_cd = d.iss_cd 
                                      and c.prem_seq_no = d.prem_seq_no 
                                      and c.policy_id = d.policy_id 
                                      and B.LINE_CD = i.line_cd    
                                      AND B.SUBLINE_CD = i.subline_cd 
                                      AND B.ISS_CD = i.iss_cd 
                                      AND B.ISSUE_YY = i.issue_yy 
                                      AND B.POL_SEQ_NO = i.pol_seq_no 
                                      AND B.RENEW_NO  = i.RENEW_NO 
                                      AND a.intm_no = d.INTRMDRY_INTM_NO)
                          LOOP
                            IF v_intm_name IS NULL THEN
                               v_intm_name := r.v_intm_name;
                            ELSE
                               v_intm_name := v_intm_name2||', '||r.v_intm_name;
                            END IF;
                          END LOOP;    
                          
                          details.intm_name     := v_intm_name;
                          details.intm_no       := v_intm_no;*/
                          
                          FOR b IN (SELECT peril_name,line_cd
                                      FROM giis_peril
                                     WHERE peril_cd = i.peril_cd
                                       AND line_cd = i.line_cd )
                          LOOP
                              details.peril := b.peril_name;                             
                          END LOOP;
                          
                          for prem in (select prem_amt
                                        from giex_old_group_peril
                                        where peril_cd = i.peril_cd
                                        and policy_id = i.policy_id)
                              loop
                                  details.prem := prem.prem_amt;
                              end loop;
                              
                          for tsi in (select tsi_amt
                                      from giex_old_group_peril
                                     where peril_cd  = i.peril_cd
                                       and policy_id = i.policy_id)
                          loop
                              details.tsi := tsi.tsi_amt;
                          end loop;
                          
                          --details.total_due     := cf_total_dueformula(i.prem_amt,i.tax_amt);
                          
                          SELECT sum(NVL (b.tax_amt, a.tax_amt)) tax_amt
                            INTO details.tax_amt
                            FROM giex_old_group_tax a, giex_new_group_tax b
                           WHERE a.policy_id = b.policy_id(+)
                             AND a.line_cd = b.line_cd(+)
                             AND a.tax_cd = b.tax_cd(+)
                             AND a.iss_cd = b.iss_cd(+)
                             AND a.iss_cd = i.iss_cd
                             AND a.policy_id = i.policy_id;
                          
                          FOR C IN(SELECT DISTINCT a.intm_no, TO_CHAR(a.intm_no)||'/'||ref_intm_cd v_intm_no,
                                          a.ref_intm_cd
                                     FROM giis_intermediary a,
                                          gipi_polbasic b,
                                          gipi_invoice c,
                                          gipi_comm_invoice d
                                    WHERE b.policy_id = c.policy_id 
                                      AND c.iss_cd = d.iss_cd 
                                      AND c.prem_seq_no = d.prem_seq_no
                                      AND c.policy_id = d.policy_id
                                      AND b.policy_id = i.policy_id
                                      AND a.intm_no = d.intrmdry_intm_no 
                                    ORDER BY a.intm_no)
                          LOOP
                             IF c.ref_intm_cd IS NULL THEN
                                details.intm_no := rtrim(c.v_intm_no,'/');
                             ELSE
                                details.intm_no := TO_CHAR(c.intm_no)||'/'||c.ref_intm_cd;
                             END IF;
                          END LOOP;
                          
                          FOR ii IN (SELECT line_cd
                                       FROM gipi_polbasic
                                      WHERE policy_id = i.policy_id)
                          LOOP
                               FOR c IN (SELECT peril_name,line_cd
                                         FROM giis_peril
                                        WHERE peril_cd = i.peril_cd
                                          AND line_cd = ii.line_cd )
                               LOOP
                                details.peril := c.peril_name;
                             END LOOP;
                          END LOOP;
                IF v_prev_pol = i.policy_no -- Start: SR-5318 added to eliminate repeated tax amount per policy
                THEN
                    details.tax_amt := 0.00;
                END IF;
                v_prev_pol := i.policy_no;
                details.total_due := NVL(i.prem_amt2,0) + NVL(details.tax_amt,0); -- End: SR-5318
                PIPE ROW(details);                    
        END LOOP;
   END;
   
   function CF_ASSURED(p_line_cd       varchar2,
                    p_subline_cd    varchar2,
                    p_iss_cd        varchar2,
                    p_issue_yy      number,
                    p_pol_seq_no    number,
                    p_renew_no      number,
                    p_policy_id     number)
             RETURN varchar2
             is
        v_assd_name varchar2(500);
        v_assd_name2 varchar2(500);
        BEGIN

        FOR C IN (select a.assd_name
                       from giis_assured a,
                            giex_expiry  b
                  where a.assd_no = b.assd_no
                   and  b.policy_id    = p_policy_id)
        LOOP                
                 V_ASSD_NAME := C.ASSD_NAME;
        END LOOP;

        IF V_ASSD_NAME IS NULL THEN

           FOR C2 IN (select a.assd_name
                       from giis_assured a,
                            gipi_polbasic b
                  where a.assd_no = b.assd_no
                   and  b.line_cd    = p_line_cd
                   and  b.subline_cd = p_subline_cd 
                   and  b.iss_cd     = p_iss_cd
                   and  b.issue_yy   = p_issue_yy
                   and  b.pol_seq_no = p_pol_seq_no
                   and  b.renew_no   = p_renew_no)
           LOOP                
                 V_ASSD_NAME := C2.ASSD_NAME;
           EXIT;
           END LOOP;
        END IF;
        RETURN (V_ASSD_NAME);
        END;
   
   FUNCTION cf_total_dueformula (p_prem_amt NUMBER, p_tax_amt NUMBER)
   RETURN NUMBER
    IS
       v_inv_total_due   NUMBER;
    BEGIN
       v_inv_total_due := p_prem_amt + p_tax_amt;
       RETURN NVL (v_inv_total_due, 0);
    END;
   
   
END GIEXR102_PKG;
/
