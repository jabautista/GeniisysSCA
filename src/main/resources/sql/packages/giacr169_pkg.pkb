CREATE OR REPLACE PACKAGE BODY CPI.GIACR169_PKG
AS
    /*
    Created by: John Carlo M. Brigino
    October 17, 2012
    */
    FUNCTION get_GIACR169_details(
        p_branch_cd             GIAC_COLLN_BATCH.BRANCH_CD%TYPE,
        p_date                  GIAC_COLLN_BATCH.TRAN_DATE%TYPE,
        p_date2                 GIAC_COLLN_BATCH.TRAN_DATE%TYPE,
        p_user_id               VARCHAR2      
    )
    RETURN GIACR169_daily_coll_rep_tab PIPELINED
    IS
        v_GIACR169             GIACR169_daily_coll_rep_type;
        v_iss_cd               VARCHAR(2000);
        v_same_from_to         VARCHAR(2000);
        v_from_to              VARCHAR(2000);        
        
    BEGIN
           SELECT PARAM_VALUE_V
             INTO v_GIACR169.company_name
             FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'COMPANY_NAME';
            
            SELECT UPPER(PARAM_VALUE_V)
              INTO v_GIACR169.company_address
              FROM GIIS_PARAMETERS
             WHERE PARAM_NAME = 'COMPANY_ADDRESS';
             
             if p_date=p_date2 then
                 v_GIACR169.top_date:=to_char(p_date,'fmMonth DD, YYYY');
             else
                 v_GIACR169.top_date := 'From '||to_char(p_date, 'fmMonth DD, YYYY')||' to '||to_char(p_date2,'fmMonth DD, YYYY'); 
             end if;                              
        
                        
        FOR x IN (SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",    
                           --F.BRANCH_CD,
                           a.or_pref_suf,
                           a.or_no,
                           a.or_flag,
                           a.particulars,
                           a.last_update,
                           a.or_pref_suf||'-'||LPAD (A.OR_NO,9,'0') "OR NO",
                           --DECODE(a.or_pref_suf, NULL, ' ', DECODE(A.OR_NO, NULL, ' ', LPAD( a.or_pref_suf,2,' ') ||'-'|| LPAD(A.OR_NO,10,'0'))) "OR NO.",
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
                         GIAC_OR_PREF G
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
                    AND a.or_DATE BETWEEN  P_DATE AND P_DATE2
                    AND f.branch_cd = DECODE(p_BRANCH_cd, NULL, f.branch_cd, p_BRANCH_cd)
                    AND check_user_per_iss_cd_acctg2(null, f.branch_cd, 'GIACS160', p_user_id) = 1
                    AND TRAN_FLAG != 'P'
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
                    GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                           --F.BRANCH_CD,
                           a.or_pref_suf,
                           a.or_no,
                           a.or_flag,
                           a.particulars,
                           a.last_update,
                           a.or_pref_suf||'-'||LPAD (A.OR_NO,9,'0'),
                           --DECODE(a.or_pref_suf, NULL, ' ', DECODE(A.OR_NO, NULL, ' ', LPAD(a.or_pref_suf,2,' ') ||'-'|| LPAD(A.OR_NO,10,'0'))),
                           a.or_date,
                           a.cancel_date, 
                           A.DCB_NO, A.CANCEL_DCB_NO,
                           B.TRAN_DATE,
                           b.posting_date,
                           DECODE(a.or_flag,'C','CANCELLED', 'R', 'REPLACED' , A.PAYOR),
                           --DECODE(OR_FLAG,'C',NULL,d.short_name)
                           d.Short_name,
                           decode(g.or_type,null, 'Z', g.or_type)
                    UNION
                    SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",
                           --F.BRANCH_CD,
                           e.or_pref,
                           e.or_no,
                           '',
                           '',
                          SYSDATE,
                           e.or_pref||'-'||LPAD (E.OR_NO,9,'0')  "OR NO",
                           --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ', LPAD( E.or_pref,2,' ') ||'-'|| LPAD(E.OR_NO,10,'0') )) "OR NO.",
                           e.or_date "OR DATE",
                          SYSDATE,
                           '      ',
                           '',
                           B.TRAN_DATE "TRAN DATE",
                           b.posting_date "POSTING DATE",
                           'SPOILED' "PAYOR",
                           TO_NUMBER(NULL) "AMOUNT",
                           NULL "CURRENCY",
                           TO_NUMBER(NULL) "FOREIGN CURRENCY",
                           decode(g.or_type,null, 'Z', g.or_type) or_type
                    FROM  GIAC_ACCTRANS B,
                         GIAC_COLLECTION_DTL C,
                         GIIS_CURRENCY D,
                         giac_spoiled_or e,
                         GIAC_BRANCHES F,
                         GIAC_OR_PREF G
                    WHERE E.TRAN_ID = B.TRAN_ID
                    AND B.TRAN_ID = C.GACC_TRAN_ID
                    AND B.GIBR_BRANCH_CD = F.BRANCH_CD
                    AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD
                    AND e.branch_cd = g.branch_cd(+)
                    AND e.or_pref = g.or_pref_suf(+)
                    AND E.or_DATE BETWEEN  P_DATE AND P_DATE2
                    AND f.branch_cd = DECODE(p_BRANCH_cd, NULL, f.branch_cd, p_BRANCH_cd)
                    AND check_user_per_iss_cd_acctg2(null, f.branch_cd, 'GIACS160', p_user_id) = 1
                    GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                           --F.BRANCH_CD,
                           e.or_pref,
                           e.or_no,
                           E.or_pref||'-'||LPAD (E.OR_NO,9,'0') ,
                           --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ', LPAD( E.or_pref,2,' ' ) ||'-'|| LPAD(E.OR_NO,10,'0') )),
                           E.or_date,
                           B.TRAN_DATE,
                           b.posting_date,
                           'SPOILED',
                           decode(g.or_type,null, 'Z', g.or_type) 
                    --ORDER BY 2, 3
                    UNION
                    SELECT F.BRANCH_CD ||' - '|| F.BRANCH_NAME "BRANCH",
                           --F.BRANCH_CD,
                           e.or_pref,
                           e.or_no,
                           '',
                           '',
                          SYSDATE,
                           e.or_pref||'-'||LPAD (E.OR_NO,9,'0') "OR NO",
                           --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ', LPAD( E.or_pref,2,' ' ) ||'-'|| LPAD(E.OR_NO,10,'0') )) "OR NO.",
                           e.or_date "OR DATE",
                          SYSDATE,
                           '      ',
                           '',
                    --       B.TRAN_DATE "TRAN DATE",
                           TO_DATE(NULL) "TRAN DATE",
                    --       b.posting_date "POSTING DATE",
                           TO_DATE(NULL) "POSTING DATE",	 
                           'SPOILED' "PAYOR",
                           TO_NUMBER(NULL) "AMOUNT",
                           NULL "CURRENCY",
                           TO_NUMBER(NULL) "FOREIGN CURRENCY",
                         --GIAC_ACCTRANS B,
                         --GIAC_COLLECTION_DTL C,
                         --GIIS_CURRENCY D,
                         decode(g.or_type,null, 'Z', g.or_type) or_type
                    FROM giac_spoiled_or e,
                         GIAC_BRANCHES F,
                         GIAC_OR_PREF G
                    WHERE E.FUND_CD=F.GFUN_FUND_CD
                    AND E.BRANCH_CD=F.BRANCH_CD
                    AND E.TRAN_ID IS NULL
                    --E.TRAN_ID = B.TRAN_ID
                    --AND B.TRAN_ID = C.GACC_TRAN_ID
                    --AND B.GIBR_BRANCH_CD = F.BRANCH_CD
                    --AND C.CURRENCY_CD = D.MAIN_CURRENCY_CD
                    AND e.branch_cd = g.branch_cd(+)
                    AND e.or_pref = g.or_pref_suf(+)
                    AND DECODE(E.OR_DATE,NULL,E.SPOIL_DATE,E.OR_DATE) BETWEEN  P_DATE AND P_DATE2
                    AND f.branch_cd = DECODE(p_BRANCH_cd, NULL, f.branch_cd, p_BRANCH_cd)
                    AND check_user_per_iss_cd_acctg2(null, f.branch_cd, 'GIACS160', p_user_id) = 1
                    GROUP BY F.BRANCH_CD ||' - '|| F.BRANCH_NAME,
                           --F.BRANCH_CD,
                           e.or_pref,
                           e.or_no,
                           E.or_pref||'-'||LPAD (E.OR_NO,9,'0'),
                           --DECODE(E.or_pref, NULL, ' ', DECODE(E.OR_NO, NULL, ' ',  LPAD(E.or_pref,2,' ') ||'-'|| LPAD(E.OR_NO,10,'0'))),
                           E.or_date,
                    --       B.TRAN_DATE,
                    --       b.posting_date,
                           'SPOILED',
                           decode(g.or_type,null, 'Z', g.or_type) 
                    ORDER BY 18, 2, 3 ) -- added order by 1 -- jc, 10172012
          LOOP     
                      
            
            IF x."CANCEL DATE" IS NOT NULL AND
                x.payor <> 'SPOILED' AND x.payor <> 'REPLACED' THEN
                IF TRUNC(x."CANCEL DATE") <> TRUNC(x."OR DATE") THEN
                   v_GIACR169.payor := x.payor ||' ON '||TO_CHAR(x."CANCEL DATE",'MM-DD-RRRR') ||' WITH DCB NO. '|| x."CANCEL DCB NO.";
                ELSIF TRUNC(x."CANCEL DATE") = TRUNC(x."OR DATE") 
                   AND x."DCB NO." <> x."CANCEL DCB NO." THEN
                   v_GIACR169.payor := x.payor||' ON '||TO_CHAR(x."CANCEL DATE",'MM-DD-RRRR') ||' WITH DCB NO. '|| x."CANCEL DCB NO.";   
                ELSE
                   v_GIACR169.payor := x.payor;
                END IF;
            ELSIF x."CANCEL DATE" IS NOT NULL AND x.payor <> 'SPOILED' AND x.payor = 'REPLACED' THEN
                   v_GIACR169.payor :=  x.payor ||' ON '|| TO_CHAR(x.last_update,'MM-DD-RRRR') ||' WITH OR DATE '|| TO_CHAR(x."OR DATE",'MM-DD-RRRR');
                  -- v_payor :=  :particulars ||' ON '|| to_char(:last_update,'MM-DD-RRRR') ||' WITH OR DATE '|| to_char(:or_date,'MM-DD-RRRR')  ||' AND PAYOR '|| :payor;  
            ELSE
                   v_GIACR169.payor := x.payor;
            END IF; 
            
            if x.payor in ('CANCELLED', 'REPLACED') then
                if x.payor in ('CANCELLED', 'REPLACED') and trunc(x."OR DATE") <> trunc(x."CANCEL DATE") then
                   v_GIACR169.amt_received := x.amount;
                elsif x.payor in ('CANCELLED', 'REPLACED') and (trunc(x."OR DATE") = trunc(x."CANCEL DATE")) and (x."DCB NO." <> x."CANCEL DCB NO.") then
                   v_GIACR169.amt_received := x.amount;
                elsif x.payor in ('CANCELLED', 'REPLACED') and (trunc(x."OR DATE") = trunc(x."CANCEL DATE")) and (x."DCB NO." = x."CANCEL DCB NO.") then
                   v_GIACR169.amt_received := 0;
                elsif x.payor in ('CANCELLED', 'REPLACED') and (trunc(x."OR DATE") = trunc(x."CANCEL DATE")) then
                   v_GIACR169.amt_received := 0;
                else
                   v_GIACR169.amt_received := x.amount;
                end if;  
            else
                 v_GIACR169.amt_received := x.amount;
            end if;
            v_GIACR169.posted           :=  'Unposted Official Receipts';
            v_GIACR169.branch           :=  x.branch;   
            v_GIACR169.or_no            :=  x."OR NO";
            v_GIACR169.or_type          :=  x.or_type;
            v_GIACR169.or_date          :=  trunc(x."OR DATE");
            v_GIACR169.cancel_date      :=  trunc(x."CANCEL DATE");
            v_GIACR169.tran_date        :=  x."TRAN DATE";
            v_GIACR169.posting_date     :=  x."POSTING DATE";            
            v_GIACR169.currency         :=  x."CURRENCY";
            v_GIACR169.foreign_curr_amt :=  x."FOREIGN CURRENCY";         
                    
            PIPE ROW (v_GIACR169);            
          END LOOP;   
          PIPE ROW (v_GIACR169);                 
    RETURN;
   END;
  END;
/


