CREATE OR REPLACE PACKAGE BODY CPI.GIACR168_PKG 
AS
    FUNCTION get_off_receipt_reg_all_or (
        p_date          DATE,
        p_date2         DATE,
        p_branch_code   VARCHAR2,
        p_user_id       VARCHAR2
    )
        RETURN giacr168_off_receipt_reg_tab PIPELINED
    IS
    v_giacr168_tab              giacr168_off_receipt_reg_type;
    v_company_name              GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    v_company_address           GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
    v_posted                    VARCHAR2(70) := '';
    v_top_date                  VARCHAR2(70) := '';
    
    v_payor                     GIAC_ORDER_OF_PAYTS.PAYOR%TYPE;
    v_amt_received              GIAC_COLLECTION_DTL.AMOUNT%TYPE;
    v_short_name                GIIS_CURRENCY.SHORT_NAME%TYPE;  
    
    BEGIN
        SELECT param_value_v
          INTO v_company_name
          FROM GIIS_PARAMETERS
        WHERE param_name = 'COMPANY_NAME';
        
        SELECT param_value_v
          INTO v_company_address
          FROM GIIS_PARAMETERS 
        WHERE param_name = 'COMPANY_ADDRESS';
        
        IF p_date = p_date2 THEN
           v_top_date := TO_CHAR(p_date, 'fmMonth DD, YYYY');
        ELSE
           v_top_date := 'From ' || TO_CHAR(p_date, 'fmMonth DD, YYYY') || ' to ' || TO_CHAR(p_date2, 'fmMonth DD, YYYY'); 
        END IF;
  
        v_giacr168_tab.company_name     := UPPER(v_company_name);
        v_giacr168_tab.company_address  := UPPER(v_company_address);
        v_giacr168_tab.posted           := 'All Posted and Unposted Official Receipts';
        v_giacr168_tab.top_date         := v_top_date;
        
        FOR i IN    ( SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",   
                               --F.BRANCH_CD,
                               trim(a.or_pref_suf) or_pref_suf ,  -- jhing 12.17.2015 added trim GENQA 5216
                               a.or_no,
                               a.or_flag,
                               a.particulars,
                               a.last_update,
                               rpad(trim(a.or_pref_suf),5)||'-'||LPAD(A.OR_NO,10,'0') "OR NO",  /*modified by ging: changed a.or_pref_suf to  rpad(a.or_pref_suf,5)  */ -- jhing GENQA 5216 added trim  
                               --DECODE(a.or_pref_suf, NULL, ' ', DECODE(A.OR_NO, NULL, ' ', lpad(a.or_pref_suf,2,' ' )||'-'|| lpad(A.OR_NO,10,'0'))) "OR NO.",
                               a.or_date "OR DATE",
                               a.cancel_date "CANCEL DATE",
                               TO_CHAR(A.DCB_NO) "DCB NO.", 
                               TO_CHAR(A.CANCEL_DCB_NO) "CANCEL DCB NO.", 
                               B.TRAN_DATE "TRAN DATE",
                               b.posting_date "POSTING DATE",
                               DECODE(a.or_flag,'C','CANCELLED',  'R', 'REPLACED', A.PAYOR) "PAYOR",
                               SUM(C.AMOUNT)"AMOUNT",
                               d.Short_name "CURRENCY",
                               SUM(DECODE(C.CURRENCY_cd,1,NULL,C.FCURRENCY_AMT)) "FOREIGN CURRENCY",
                               decode(g.or_type,null, 'Z', g.or_type) or_type
                        FROM GIAC_ORDER_OF_PAYTS A,
                             GIAC_ACCTRANS B,
                             GIAC_COLLECTION_DTL C,
                             GIIS_CURRENCY D,
                             --giac_spoiled_or e,
                             GIAC_BRANCHES F,
                             giac_or_pref G
                        WHERE A.GACC_TRAN_ID = B.TRAN_ID
                            AND A.GIBR_GFUN_FUND_CD = B.GFUN_FUND_CD
                            AND A.GIBR_BRANCH_CD = B.GIBR_BRANCH_CD
                            AND B.TRAN_ID = C.GACC_TRAN_ID
                            --and a.gacc_tran_id = e.tran_id(+)
                            AND B.GIBR_BRANCH_CD = F.BRANCH_CD 
                            AND A.GIBR_BRANCH_CD = F.BRANCH_CD
                            AND B.GFUN_FUND_CD = F.GFUN_FUND_CD
                            AND A.GIBR_GFUN_FUND_CD = F.GFUN_FUND_CD
                            AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD
                            AND a.gibr_branch_cd = g.branch_cd(+)
                            AND a.or_pref_suf = g.or_pref_suf(+)
                            AND TRUNC(a.or_DATE) BETWEEN  p_DATE AND p_DATE2
                            --AND f.branch_cd = p_branch_code
                            AND f.branch_cd = DECODE(p_branch_code, NULL, f.branch_cd, p_branch_code)
                            AND check_user_per_iss_cd_acctg2 (NULL, f.branch_cd, 'GIACS160', p_user_id) = 1
                            AND OR_FLAG !='N'
                            AND (((TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no = a.cancel_dcb_no))
                                 OR ((TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no = a.cancel_dcb_no))
                                 OR ((TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no <> a.cancel_dcb_no))
                                 OR (a.cancel_date IS NULL)
                                 OR ((TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no <> a.cancel_dcb_no)))
                             AND((a.or_flag NOT IN ( 'C', 'R' ))
                                      --or (nvl(a.or_flag, 'C') != 'C')
                                      --or ((a.or_flag =  'R') and (trunc(nvl(a.cancel_date,a.or_date)) = trunc(a.or_date)) and (a.dcb_no = a.cancel_dcb_no))
                                      OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no =a.cancel_dcb_no))
                                      OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no<> a.cancel_dcb_no))
                                      OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no = a.cancel_dcb_no))
                                      OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no <> a.cancel_dcb_no)))
                            --AND DECODE(g.or_type,null, 'Z', g.or_type) <> DECODE(giacp.v('ISSUE_NONVAT_OAR'), 'Y', 'N', '1') --Dean 10.12.2011  modified by reymon 05152012  /* commented out by shan 10.17.2012 */
                        GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                               --F.BRANCH_CD,
                               trim(a.or_pref_suf), -- jhing 12.17.2015 added trim GENQA 5216
                               a.or_no,
                               a.or_flag,
                               a.particulars,
                               a.last_update,
                               trim(a.or_pref_suf)||'-'||LPAD(A.OR_NO,10,'0') , --Dean 10.12.2011 lpad value changed from 9 to 10  -- jhing 12.17.2015 added trim GENQA 5216
                               --DECODE(a.or_pref_suf, NULL, ' ', DECODE(A.OR_NO, NULL, ' ', lpad( a.or_pref_suf,2,' ') ||'-'|| lpad(A.OR_NO,10,'0') )),
                               a.or_date,
                               a.cancel_date, 
                               A.DCB_NO, A.CANCEL_DCB_NO,
                               B.TRAN_DATE,
                               b.posting_date,
                               DECODE(a.or_flag,'C','CANCELLED', 'R', 'REPLACED' , A.PAYOR),
                               decode(g.or_type,null, 'Z', g.or_type),
                               --DECODE(OR_FLAG,'C',NULL,d.short_name)
                               d.Short_name
                        UNION
                        SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",
                               --F.BRANCH_CD,
                               trim(e.or_pref) or_pref , -- jhing 12.17.2015 added trim GENQA 5216
                               e.or_no,
                               '',
                               '',
                              SYSDATE,
                                rpad(TRIM(e.or_pref),5) ||'-'||LPAD(E.OR_NO,10,'0') "OR NO", --Dean 10.12.2011 lpad value changed from 9 to 10 -- jhing GENQA 5216 added trim/rpad and removed extra space in ' - '
                               --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ',lpad( E.or_pref,2,' ') ||'-'|| lpad(E.OR_NO,10,'0') )) "OR NO.",
                               e.or_date "OR DATE",
                              SYSDATE,
                               '',
                               '',
                               B.TRAN_DATE "TRAN DATE",
                               b.posting_date "POSTING DATE",
                               'SPOILED' "PAYOR",
                               TO_NUMBER(NULL) "AMOUNT",
                               NULL "CURRENCY",
                               TO_NUMBER(NULL) "FOREIGN CURRENCY",
                               decode(g.or_type,null, 'Z', g.or_type) or_type
                        FROM  GIAC_ACCTRANS B,
                             --GIAC_COLLECTION_DTL C, --Commented out by Jerome 11.09.2016 SR 23223
                             --GIIS_CURRENCY D, --Commented out by Jerome 11.09.2016 SR 23223
                             giac_spoiled_or e,
                             GIAC_BRANCHES F,
                             giac_or_pref G
                        WHERE B.TRAN_ID = E.TRAN_ID
                            --AND B.TRAN_ID = C.GACC_TRAN_ID --Commented out by Jerome 11.09.2016 SR 23223
                            AND B.GIBR_BRANCH_CD = F.BRANCH_CD
                            --AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD --Commented out by Jerome 11.09.2016 SR 23223
                            AND e.branch_cd = g.branch_cd(+)
                            AND e.or_pref = g.or_pref_suf(+)
                            AND TRUNC(E.or_DATE) BETWEEN  p_DATE AND p_DATE2
                            AND f.branch_cd = DECODE(p_branch_code, NULL, f.branch_cd, p_branch_code)
                            AND check_user_per_iss_cd_acctg2 (NULL, f.branch_cd, 'GIACS160', p_user_id) = 1
                            --AND DECODE(g.or_type,null, 'Z', g.or_type) <> DECODE(giacp.v('ISSUE_NONVAT_OAR'), 'Y', 'N', '1') --Dean 10.12.2011  modified by reymon 05152012  /* commented out by shan 10.17.2012 */
                        GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                               --F.BRANCH_CD,
                               trim(e.or_pref),-- jhing 12.17.2015 added trim GENQA 5216
                               e.or_no,
                               trim(E.or_pref) ||' -'||LPAD(E.OR_NO,10,'0'), --Dean 10.12.2011 lpad value changed from 9 to 10
                               --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ',lpad( E.or_pref,2,' ') ||'-'|| lpad(E.OR_NO,10,'0'))),-- jhing 12.17.2015 added trim GENQA 5216
                               E.or_date,
                               B.TRAN_DATE,
                               b.posting_date,
                               'SPOILED',
                               decode(g.or_type,null, 'Z', g.or_type) 
                        --ORDER BY 2, 3
                        UNION
                        SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",
                               --F.BRANCH_CD,
                               trim(e.or_pref) or_pref , -- jhing 12.17.2015 added trim GENQA 5216
                               e.or_no,
                               '',
                               '',
                              SYSDATE,
                                rpad(trim(e.or_pref),5) ||'-'||LPAD(E.OR_NO,10,'0') "OR NO", --Dean 10.12.2011 lpad value changed from 9 to 10 -- jhing 12.17.2015 added trim/rpad and remove extra space in ' - ' GENQA 5216
                               --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ', lpad( E.or_pref,2,' ') ||'-'|| lpad(E.OR_NO,10,'0'))) "OR NO.",
                               e.or_date "OR DATE",
                              SYSDATE,
                               '',
                               '',
                               --B.TRAN_DATE "TRAN DATE",
                               TO_DATE(NULL) "TRAN DATE",
                               --b.posting_date "POSTING DATE",
                               TO_DATE(NULL) "POSTING DATE",
                               'SPOILED' "PAYOR",
                               TO_NUMBER(NULL) "AMOUNT",
                               NULL "CURRENCY",
                               TO_NUMBER(NULL) "FOREIGN CURRENCY",
                               decode(g.or_type,null, 'Z', g.or_type) or_type
                        FROM  --GIAC_ACCTRANS B,
                             --GIAC_COLLECTION_DTL C,
                             --GIIS_CURRENCY D,
                             giac_spoiled_or e,
                             GIAC_BRANCHES F,
                             giac_or_pref G
                        WHERE E.FUND_CD=F.GFUN_FUND_CD
                            AND E.BRANCH_CD=F.BRANCH_CD
                            AND e.branch_cd = g.branch_cd(+)
                            AND e.or_pref = g.or_pref_suf(+)
                            AND E.TRAN_ID IS NULL
                            --B.TRAN_ID = E.TRAN_ID 
                            --AND B.TRAN_ID = C.GACC_TRAN_ID
                            --AND B.GIBR_BRANCH_CD = F.BRANCH_CD
                            --AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD
                            AND DECODE(E.OR_DATE,NULL,E.SPOIL_DATE,E.OR_DATE) BETWEEN  p_DATE AND p_DATE2
                            AND f.branch_cd = DECODE(p_branch_code, NULL, f.branch_cd, p_branch_code)
                            AND check_user_per_iss_cd_acctg2 (NULL, f.branch_cd, 'GIACS160', p_user_id) = 1
                            --AND DECODE(g.or_type,null, 'Z', g.or_type) <> DECODE(giacp.v('ISSUE_NONVAT_OAR'), 'Y', 'N', '1') --Dean 10.12.2011  modified by reymon 05152012  /* commented out by shan 10.17.2012 */
                        GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                               --F.BRANCH_CD,
                               trim(e.or_pref) , -- jhing 12.17.2015 added trim GENQA 5216
                               e.or_no,
                               trim(E.or_pref)||' -'||LPAD(E.OR_NO,10,'0'), --Dean 10.12.2011 lpad value changed from 9 to 10  -- jhing 12.17.2015 added trim GENQA 5216
                               --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ', lpad(E.or_pref,2,' ') ||'-'|| lpad(E.OR_NO,10,'0') )),
                               E.or_date,
                               --B.TRAN_DATE,
                               --b.posting_date,
                               'SPOILED',
                               decode(g.or_type,null, 'Z', g.or_type) 
                        ORDER BY 1, 18, 2, 3) -- order by 18 added by shan 10.17.2012
        LOOP
            IF i."CANCEL DATE" IS NOT NULL AND i."PAYOR" <> 'SPOILED' AND i."PAYOR"<> 'REPLACED' THEN
                IF TRUNC(i."CANCEL DATE") <> TRUNC(i."OR DATE") THEN
                   v_payor := i."PAYOR" ||' ON '||TO_CHAR(i."CANCEL DATE",'MM-DD-RRRR') ||' WITH DCB NO. '|| i."CANCEL DCB NO.";
                ELSIF  TRUNC(i."CANCEL DATE") = TRUNC(i."OR DATE") AND i."DCB NO." <> i."CANCEL DCB NO." THEN
                   v_payor := i."PAYOR"||' ON '||TO_CHAR(i."CANCEL DATE",'MM-DD-RRRR') ||' WITH DCB NO. '|| i."CANCEL DCB NO.";   
                ELSE
                   v_payor := i."PAYOR";
                END IF;
            ELSIF i."CANCEL DATE" IS NOT NULL AND i."PAYOR" <> 'SPOILED' AND i."PAYOR" = 'REPLACED' THEN
                v_payor :=  i."PAYOR" ||' ON '|| TO_CHAR(i.last_update,'MM-DD-RRRR') ||' WITH OR DATE '|| TO_CHAR(i."OR DATE",'MM-DD-RRRR');
              -- v_payor :=  :particulars ||' ON '|| to_char(:last_update,'MM-DD-RRRR') ||' WITH OR DATE '|| to_char(:or_date,'MM-DD-RRRR')  ||' AND PAYOR '|| :payor;  
            ELSE
                v_payor := i."PAYOR";
            END IF;
       
            IF i."PAYOR" IN ('CANCELLED', 'REPLACED') THEN
                IF i."PAYOR" IN ('CANCELLED', 'REPLACED') AND TRUNC(i."OR DATE") <> TRUNC(i."CANCEL DATE") THEN
                    v_amt_received := i."AMOUNT";
                ELSIF i."PAYOR" IN ('CANCELLED', 'REPLACED') AND (TRUNC(i."OR DATE") = TRUNC(i."CANCEL DATE")) AND (i."DCB NO." <> i."CANCEL DCB NO.") then
                    v_amt_received := i."AMOUNT";
                ELSIF i."PAYOR" IN ('CANCELLED', 'REPLACED') AND (TRUNC(i."OR DATE") = TRUNC(i."CANCEL DATE")) AND (i."DCB NO." = i."CANCEL DCB NO.") then
                    v_amt_received := 0;
                ELSIF i."PAYOR" IN ('CANCELLED', 'REPLACED') AND (TRUNC(i."OR DATE") = TRUNC(i."CANCEL DATE")) THEN
                    v_amt_received := 0;
                ELSE
                    v_amt_received := i."AMOUNT";
                END IF;  
            ELSE
                v_amt_received := i."AMOUNT";
            END IF;
            
            
            v_giacr168_tab.branch           := i.branch;
            v_giacr168_tab.or_type          := i.or_type;
            v_giacr168_tab.or_no            := i."OR NO";
            v_giacr168_tab.or_date          := TRUNC(i."OR DATE");
            v_giacr168_tab.tran_date        := i."TRAN DATE";
            v_giacr168_tab.posting_date     := i."POSTING DATE";
            v_giacr168_tab.payor            := v_payor;
            v_giacr168_tab.amt_received     := v_amt_received;
            v_giacr168_tab.currency         := i."CURRENCY";
            v_giacr168_tab.foreign_curr_amt := i."FOREIGN CURRENCY";
            
--            if TRUNC(i."OR DATE") <> TRUNC(i."CANCEL DATE") then 
--                v_giacr168_tab.cancel_date      := TRUNC(i."CANCEL DATE");
--            else
--                v_giacr168_tab.cancel_date      := '';
--            end if;
            v_giacr168_tab.cancel_date      := TRUNC(i."CANCEL DATE");
            v_giacr168_tab.dcb_no           := i."DCB NO.";
            v_giacr168_tab.cancel_dcb_no    := i."CANCEL DCB NO.";
            
            PIPE ROW(v_giacr168_tab);
        END LOOP;
        
        PIPE ROW(v_giacr168_tab);
    END;    --end of block

END;    -- end of GIACR168_PKG body
/


