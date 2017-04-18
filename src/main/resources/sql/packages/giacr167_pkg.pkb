CREATE OR REPLACE PACKAGE BODY CPI.GIACR167_PKG
AS
    FUNCTION get_off_receipt_reg_posted (
        p_date          DATE,
        p_date2         DATE,
        p_branch_code   VARCHAR2,
        p_user_id       VARCHAR2
        --p_posted        VARCHAR2
    )
    RETURN giacr167_off_receipt_reg_tab PIPELINED
    IS
    v_giacr167_tab              giacr167_off_receipt_reg_type;
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
  
        v_giacr167_tab.company_name     := UPPER(v_company_name);
        v_giacr167_tab.company_address  := UPPER(v_company_address);
        v_giacr167_tab.posted           := 'Posted Official Receipts';
        v_giacr167_tab.top_date         := v_top_date;
        
        FOR i IN (SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",    
                           a.or_pref_suf,
                           a.or_no,
                           a.or_flag,
                           a.particulars,
                           a.last_update,
                           a.or_pref_suf||'-'||LPAD(A.OR_NO,9,'0') "OR NO", 
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
                           decode(a.or_pref_suf,null,'Z',substr(a.or_pref_suf,1,1)) as or_type
                    FROM GIAC_ORDER_OF_PAYTS A,
                         GIAC_ACCTRANS B,
                         GIAC_COLLECTION_DTL C,
                         GIIS_CURRENCY D,
                         GIAC_BRANCHES F
                    WHERE A.GACC_TRAN_ID = B.TRAN_ID
                    AND A.GIBR_GFUN_FUND_CD = B.GFUN_FUND_CD
                    AND A.GIBR_BRANCH_CD = B.GIBR_BRANCH_CD
                    AND B.TRAN_ID = C.GACC_TRAN_ID
                    AND B.GIBR_BRANCH_CD = F.BRANCH_CD 
                    AND A.GIBR_BRANCH_CD = F.BRANCH_CD
                    AND B.GFUN_FUND_CD = F.GFUN_FUND_CD
                    AND A.GIBR_GFUN_FUND_CD = F.GFUN_FUND_CD
                    AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD
                    AND check_user_per_iss_cd_acctg2(NULL, A.GIBR_BRANCH_CD, 'GIACS160', p_user_id) = 1
                    AND TRUNC(a.or_DATE) BETWEEN  P_DATE AND P_DATE2 --truncate added by Jayson 08.23.2011
                    AND f.branch_cd = DECODE(P_BRANCH_CODE, NULL, f.branch_cd, P_BRANCH_CODE)
                    AND TRAN_FLAG = 'P'
                    AND OR_FLAG !='N'
                    AND (((TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no = a.cancel_dcb_no))
                         OR ((TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no = a.cancel_dcb_no))
                         OR ((TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no <> a.cancel_dcb_no))
                         OR (a.cancel_date IS NULL)
                         OR ((TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no <> a.cancel_dcb_no)))
                     AND((a.or_flag NOT IN ( 'C', 'R' ))
                              OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no =a.cancel_dcb_no))
                              OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) <> TRUNC(b.tran_date)) AND (a.dcb_no<> a.cancel_dcb_no))
                              OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no = a.cancel_dcb_no))
                              OR ((a.or_flag IN ('C', 'R')) AND (TRUNC(NVL(a.cancel_date,b.tran_date)) = TRUNC(b.tran_date)) AND (a.dcb_no <> a.cancel_dcb_no)))   
                    GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                           a.or_pref_suf,
                           a.or_no,
                           a.or_flag,
                           a.particulars,
                           a.last_update,
                           a.or_pref_suf||'-'||LPAD(A.OR_NO,9,'0'),
                           a.or_date,
                           a.cancel_date, 
                           A.DCB_NO, A.CANCEL_DCB_NO,
                           B.TRAN_DATE,
                           b.posting_date,
                           DECODE(a.or_flag,'C','CANCELLED', 'R', 'REPLACED' , A.PAYOR),
                           d.Short_name,
                           decode(a.or_pref_suf,null,'Z',substr(a.or_pref_suf,1,1))
                    ORDER BY 1, 18, 2, 3  -- order by added by shan 10.15.2012
                    /*
                    UNION
                    SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",
                           e.or_pref,
                           e.or_no,
                           '',
                           '',
                          SYSDATE,
                           e.or_pref||'-'||LPAD(E.OR_NO,9,'0') "OR NO",
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
                           decode(e.or_pref,null,'Z',substr(e.or_pref,1,1))
                    FROM  GIAC_ACCTRANS B,
                         GIAC_COLLECTION_DTL C,
                         GIIS_CURRENCY D,
                         giac_spoiled_or e,
                         GIAC_BRANCHES F
                    WHERE E.TRAN_ID = B.TRAN_ID
                    AND B.TRAN_ID = C.GACC_TRAN_ID
                    AND B.GIBR_BRANCH_CD = F.BRANCH_CD
                    AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD
                    AND E.or_DATE BETWEEN  P_DATE AND P_DATE2
                    AND f.branch_cd = DECODE(:BRANCH_CODE, NULL, f.branch_cd, :BRANCH_CODE)
                    GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                           E.OR_PREF,
                           E.OR_NO,
                           E.OR_PREF||'-'||LPAD (E.OR_NO,9,'0'),
                           E.OR_DATE,
                           B.TRAN_DATE,
                           B.POSTING_DATE,
                           'SPOILED',
                           decode(e.or_pref,null,'Z',substr(e.or_pref,1,1))
                    UNION
                    SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",
                           E.OR_PREF,
                           E.OR_NO,
                           '',
                           '',
                          SYSDATE,
                           E.OR_PREF||'-'||LPAD(E.OR_NO,9,'0') "OR NO",
                           E.OR_DATE "OR DATE",
                          SYSDATE,
                           '      ',
                           '',
                           TO_DATE(NULL) "TRAN DATE",
                           TO_DATE(NULL) "POSTING DATE",
                           'SPOILED' "PAYOR",
                           TO_NUMBER(NULL) "AMOUNT",
                           NULL "CURRENCY",
                           TO_NUMBER(NULL) "FOREIGN CURRENCY",
                           decode(e.or_pref,null,'Z',substr(e.or_pref,1,1))
                    FROM GIAC_SPOILED_OR E,
                         GIAC_BRANCHES F
                    WHERE E.FUND_CD=F.GFUN_FUND_CD
                    AND E.BRANCH_CD=F.BRANCH_CD
                    AND DECODE(E.OR_DATE,NULL,E.SPOIL_DATE,E.OR_DATE) BETWEEN  P_DATE AND P_DATE2
                    AND F.BRANCH_CD = DECODE(:BRANCH_CODE, NULL, F.BRANCH_CD, :BRANCH_CODE)
                    AND E.TRAN_ID IS NULL
                    GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                           E.OR_PREF,
                           E.OR_NO,
                           E.OR_PREF||'-'||LPAD(E.OR_NO,9,'0'),
                           E.OR_DATE,
                           'SPOILED',
                           decode(e.or_pref,null,'Z',substr(e.or_pref,1,1))
                    ORDER BY 2, 3*/ -- removed by Jayson 5/28/2011 so that report would not include spoiled ORs
                    )
        LOOP
        
            IF i."CANCEL DATE" IS NOT NULL AND i."PAYOR" <> 'SPOILED' AND i."PAYOR" <> 'REPLACED' THEN
                IF TRUNC(i."CANCEL DATE") <> TRUNC(i."OR DATE") THEN
                   v_payor := i."PAYOR" ||' ON '||TO_CHAR(i."CANCEL DATE",'MM-DD-RRRR') ||' WITH DCB NO. '|| i."CANCEL DCB NO.";
                ELSIF  TRUNC(i."CANCEL DATE") = TRUNC(i."OR DATE") AND i."DCB NO." <> i."CANCEL DCB NO." THEN
                   v_payor := i."PAYOR" ||' ON '||TO_CHAR(i."CANCEL DATE",'MM-DD-RRRR') ||' WITH DCB NO. '|| i."CANCEL DCB NO.";   
                ELSE
                   v_payor := i."PAYOR";
                END IF;
            ELSIF i."CANCEL DATE" IS NOT NULL AND i."PAYOR" <> 'SPOILED' AND i."PAYOR" = 'REPLACED' THEN
                   v_payor :=  i."PAYOR" ||' ON '|| TO_CHAR(i."LAST_UPDATE",'MM-DD-RRRR') ||' WITH OR DATE '|| TO_CHAR(i."OR DATE",'MM-DD-RRRR');
                  -- v_payor :=  :particulars ||' ON '|| to_char(:last_update,'MM-DD-RRRR') ||' WITH OR DATE '|| to_char(:or_date,'MM-DD-RRRR')  ||' AND PAYOR '|| :payor;  
            ELSE
                   v_payor := i."PAYOR";
            END IF;
 
            if i."PAYOR" in ('CANCELLED', 'REPLACED') then
                if i."PAYOR" in ('CANCELLED', 'REPLACED') and trunc(i."OR DATE") <> trunc(i."CANCEL DATE") then
                   v_amt_received := i."AMOUNT";
                elsif i."PAYOR" in ('CANCELLED', 'REPLACED') and (trunc(i."OR DATE") = trunc(i."CANCEL DATE")) and (i."DCB NO." <> i."CANCEL DCB NO.") then
                   v_amt_received := i."AMOUNT";
                elsif i."PAYOR" in ('CANCELLED', 'REPLACED') and (trunc(i."OR DATE") = trunc(i."CANCEL DATE")) and (i."DCB NO." = i."CANCEL DCB NO.") then
                   v_amt_received := 0;
                elsif i."PAYOR" in ('CANCELLED', 'REPLACED') and (trunc(i."OR DATE") = trunc(i."CANCEL DATE")) then
                   v_amt_received := 0;
                else
                   v_amt_received := i."AMOUNT";
                end if;  
            else
                 v_amt_received := i."AMOUNT";
            end if;
  
            v_giacr167_tab.branch           := i.branch;
            v_giacr167_tab.or_type          := i.or_type;
            v_giacr167_tab.or_no            := i."OR NO";
            v_giacr167_tab.or_date          := TRUNC(i."OR DATE");
            v_giacr167_tab.tran_date        := i."TRAN DATE";
            v_giacr167_tab.posting_date     := i."POSTING DATE";
            v_giacr167_tab.payor            := v_payor;
            v_giacr167_tab.amt_received     := v_amt_received;
            v_giacr167_tab.currency         := i."CURRENCY";
            v_giacr167_tab.foreign_curr_amt := i."FOREIGN CURRENCY";
            
            v_giacr167_tab.cancel_date      := TRUNC(i."CANCEL DATE");
            v_giacr167_tab.dcb_no           := i."DCB NO.";
            v_giacr167_tab.cancel_dcb_no    := i."CANCEL DCB NO.";
            
            PIPE ROW(v_giacr167_tab);
        END LOOP;
        
        PIPE ROW(v_giacr167_tab);
    END;  --end of block
END; -- end of GIACR167_PKG body
/


