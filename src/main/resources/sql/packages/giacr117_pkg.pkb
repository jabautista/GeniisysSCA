CREATE OR REPLACE PACKAGE BODY CPI.giacr117_PKG
AS
    FUNCTION get_cr_reg_details (
        p_date                  DATE,
        p_date2                 DATE,
        p_post_tran_toggle      VARCHAR2,
        --p_fund                  VARCHAR2,
        p_branch                GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
        p_tran_class            VARCHAR2,
        p_per_branch            VARCHAR2,
        p_user_id               VARCHAR2
        --p_module_id             GIIS_MODULES_TRAN.MODULE_ID%TYPE
    )
        RETURN giacr117_cash_receipt_reg_tab PIPELINED
    IS
        v_giacr117_details          giacr117_cash_receipt_reg_type;
        
        --margin
         --formula columns
        v_company_name              VARCHAR2(100) := '';
        v_company_address           giac_parameters.param_value_v%type;
        v_posting_tran              VARCHAR2(70) := '';
        v_post                      VARCHAR2(20) := '';
        v_top_date                  VARCHAR2(70) := '';
        
         --Q1
        v_gibr_branch_cd            GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE;
        v_branch_name               GIAC_BRANCHES.BRANCH_NAME%TYPE;
        v_or_no                     VARCHAR2(70) := '';
        v_tran_id                   GIAC_ACCTRANS.TRAN_ID%TYPE;
        v_dcb_no                    GIAC_ORDER_OF_PAYTS.DCB_NO%TYPE;
        v_or_date                   GIAC_ORDER_OF_PAYTS.OR_DATE%TYPE;
        v_posting_date              GIAC_ACCTRANS.POSTING_DATE%TYPE;
        v_intm_no                   VARCHAR2(50);
        v_payor                     GIAC_ORDER_OF_PAYTS.PAYOR%TYPE;
        v_tin                       GIAC_ORDER_OF_PAYTS.TIN%TYPE;
        v_collection_amt            GIAC_ORDER_OF_PAYTS.COLLECTION_AMT%TYPE;
        v_particulars               GIAC_ACCTRANS.PARTICULARS%TYPE;
        v_gl_account                VARCHAR2(72) := '';
        v_gl_acct_name              GIAC_CHART_OF_ACCTS.GL_ACCT_NAME%TYPE;
        v_sl_cd                     GIAC_ACCT_ENTRIES.SL_CD%TYPE ;
        v_debit_amt                 GIAC_ACCT_ENTRIES.DEBIT_AMT%TYPE;
        v_credit_amt                GIAC_ACCT_ENTRIES.CREDIT_AMT%TYPE;
        
        --summary fields
         --**per payor
        --v_r_db                      NUMBER(12,2) := 0;
        --v_r_cd                      NUMBER(12,2) := 0;
                
         --**per branch
        --v_branch_db                 NUMBER(12,2) := 0;
        --v_branch_cd                 NUMBER(12,2) := 0;
        v_branch_collection_amt     NUMBER(12,2) := 0;
        v_or_vat_amt                NUMBER(12,2) := 0;
        v_or_nonvat_amt             NUMBER(12,2) := 0;        
                
        v_foreign_amt               NUMBER(12,2) := 0; 
        v_currency_cd               GIAC_ORDER_OF_PAYTS.CURRENCY_CD%TYPE;
        v_gacc_tran_id              GIAC_ORDER_OF_PAYTS.GACC_TRAN_ID%TYPE;
        v_dist_or_tran_id           NUMBER(12)   :=1;
        /*v_gfun_fund_cd              GIAC_ACCTRANS.GFUN_FUND_CD%TYPE;
        v_tran_class                GIAC_ACCTRANS.TRAN_CLASS%TYPE;
        v_or_pref_suf               GIAC_ORDER_OF_PAYTS.OR_PREF_SUF%TYPE;
        v_tran_class_no             GIAC_ACCTRANS.TRAN_CLASS_NO%TYPE;
        v_gl_control_acct           GIAC_ACCT_ENTRIES.GL_CONTROL_ACCT%TYPE;
        v_gl_acct_category          GIAC_ACCT_ENTRIES.GL_ACCT_CATEGORY%TYPE;
        v_tran_date                 GIAC_ACCTRANS.TRAN_DATE%TYPE;
        v_or_flag                   GIAC_ORDER_OF_PAYTS.OR_FLAG%TYPE;
        v_gross_amt                 GIAC_ORDER_OF_PAYTS.GROSS_AMT%TYPE;
        v_short_name                GIIS_CURRENCY.SHORT_NAME%TYPE;
        v_param_value_n             GIAC_PARAMETERS.PARAM_VALUE_N%TYPE;
        v_gl_sub_acct_1             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_1%TYPE;
        v_gl_sub_acct_2             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_2%TYPE;
        v_gl_sub_acct_3             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_3%TYPE;
        v_gl_sub_acct_4             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_4%TYPE;
        v_gl_sub_acct_5             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_5%TYPE;
        v_gl_sub_acct_6             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_6%TYPE;
        v_gl_sub_acct_7             GIAC_ACCT_ENTRIES.GL_SUB_ACCT_7%TYPE;
        v_or_pref                   GIAC_SPOILED_OR.OR_PREF%TYPE;
        v_or_type                   GIAC_OR_PREF.OR_TYPE%TYPE;
        --Q3
        v_currency_desc             GIIS_CURRENCY.CURRENCY_DESC%TYPE;*/
        
        v_same_or                   BOOLEAN := FALSE; 
        v_same_payor                BOOLEAN := FALSE;  
        
        cp_date_format              VARCHAR2(20);   
        v_rec_exists                BOOLEAN := FALSE;
        
    BEGIN
        
        SELECT param_value_v
          INTO v_giacr117_details.company_name
          FROM giis_parameters
         WHERE param_name='COMPANY_NAME';
         
        SELECT param_value_v
          INTO v_giacr117_details.company_address
          FROM giac_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
         
        v_giacr117_details.company_tin := 'VAT REG TIN ' || giisp.v ('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5964
        v_giacr117_details.gen_version := giisp.v('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5964
     
        SELECT GET_REP_DATE_FORMAT
          INTO cp_date_format
          FROM giis_parameters
         WHERE param_name like '%REP_DATE_FORMAT%';        
        
         
        v_giacr117_details.rundate := TO_CHAR(SYSDATE, cp_date_format);
        
     
        if p_post_tran_toggle = 'P' then
            v_post := 'Date Posted';
        else
            v_post := 'Transaction Date';
        end if;
             
        v_giacr117_details.posting_tran := 'Based on '|| v_post;
        
        v_giacr117_details.top_date := 'From '||to_char(p_date, 'fmMonth DD, YYYY')||' to '||to_char(p_date2,'fmMonth DD, YYYY'); 
       
    
        ---******* 1st query ********---
        FOR i IN (SELECT   d.intm_no, b.gfun_fund_cd, b.gibr_branch_cd, gb.branch_name,                             
                    --decode(d.or_pref_suf,NULL,NULL,d.or_pref_suf||'-')||d.or_no or_no,
                             DECODE (b.tran_class,
                                     'COL', DECODE (d.or_pref_suf,
                                                    NULL, NULL,
                                                    d.or_pref_suf || '-'
                                                   )
                                      || LPAD (d.or_no, 10, 0),
                                     'CDC', DECODE (b.tran_class,
                                                    NULL, NULL,
                                                    b.tran_class || '-'
                                                   )
                                      || LPAD (b.tran_class_no, 10, 0)
                                    ) or_no,
                             d.or_pref_suf, b.tran_class, d.or_no "OR", TO_CHAR (b.tran_class_no) tran_class_no, --added alias [shan, 9.27.12] 
                             a.gl_control_acct gl_control_acct, a.gl_acct_category,
                             
                    --d.or_date OR_DATE,
                             DECODE (b.tran_class, 'COL', d.or_date, 'CDC', b.tran_date) or_date,
                             TO_CHAR (d.dcb_no) "dcb_no", b.posting_date,
                             
                    --decode(b.tran_class, 'COL', decode(d.or_flag,'P',d.payor,'C','CANCELLED'), 'CDC',  decode(b.tran_flag, 'C', 'CANCELLED')) "payor",
                             /*DECODE (d.or_flag, 'P', d.payor, 'C', 'CANCELLED') "payor",
                             DECODE (b.tran_class,
                                     'COL', DECODE (d.or_flag, 'P', d.particulars, 'C', NULL),
                                     'CDC', b.particulars
                                    ) particulars,
                    --decode(d.or_flag,'P',d.particulars,'C',NULL) PARTICULARS,
                             d.gross_amt "Gross Amt", d.currency_cd, gc.short_name,
                             DECODE (d.currency_cd,
                                     gp.param_value_n, 0,
                                     d.collection_amt
                                    ) foreign_amt,
                             DECODE (d.or_flag, 'C', 0, d.collection_amt) "Collection Amt",*/ --commented out by mikel 04.16.2012; replaced by codes below
                             DECODE (d.or_flag, 'C', 'CANCELLED', d.payor) "payor",
                             DECODE (b.tran_class,
                                     'COL', DECODE (d.or_flag, 'C', NULL, d.particulars),
                                     'CDC', b.particulars
                                    ) particulars,
                             DECODE (d.or_flag,
                                     NULL, (d.gross_amt * -1),
                                     d.gross_amt
                                    ) "Gross Amt", d.currency_cd, gc.short_name,
                             DECODE (d.or_flag,
                                     NULL, 0,
                                     DECODE (d.currency_cd,
                                             gp.param_value_n, 0,
                                             d.collection_amt
                                            )
                                    ) foreign_amt,
                             DECODE (d.or_flag,
                                     NULL, (d.collection_amt * -1),
                                     'C', 0,
                                     d.collection_amt
                                    ) "Collection Amt",
                             
                                --end mikel 04.16.2012
                                LTRIM (TO_CHAR (a.gl_acct_category))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) "GL Account",
                             c.gl_acct_name "GL Account Name",
                                                              /*DECODE (d.or_flag, 'C', 0, NVL (a.debit_amt, 0)) debit_amt,
                                                              DECODE (d.or_flag, 'C', 0, NVL (a.credit_amt, 0)) credit_amt,*/  --commented out by mikel 04.16.2012, replaced by codes below
                                                              NVL (a.debit_amt, 0) debit_amt,
                             NVL (a.credit_amt, 0) credit_amt,
                             
                             --end mikel 04.16.2012
                             LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                                                                       --ADDED LEADING ZEROS BY APRIL 11042011
                                                                       a.sl_cd, e.or_type,
                             d.tin,                                -- added by mjmcustodio 10/04/11
                             b.tran_flag, d.or_flag -- Added by Jerome Bautista 03.09.2016 SR 21536
                        FROM giac_acct_entries a,
                             giac_acctrans b,
                             giac_chart_of_accts c,
                             giac_order_of_payts d,
                             giac_or_pref e,
                             giac_branches gb,
                             giis_currency gc,
                             giac_parameters gp
                       WHERE gc.main_currency_cd(+) = d.currency_cd
                         AND b.gfun_fund_cd = gb.gfun_fund_cd
                         AND b.gibr_branch_cd = gb.branch_cd
                    --  and d.gibr_gfun_fund_cd=gb.gfun_fund_cd(+)
                    --  and d.gibr_branch_cd=gb.branch_cd (+)
                         AND b.tran_id >= 1
                         AND a.gacc_tran_id = b.tran_id
                         AND b.tran_id = d.gacc_tran_id(+)
                         AND a.gl_acct_category = c.gl_acct_category
                         AND a.gl_control_acct = c.gl_control_acct
                         AND a.gl_sub_acct_1 = c.gl_sub_acct_1
                         AND a.gl_sub_acct_2 = c.gl_sub_acct_2
                         AND a.gl_sub_acct_3 = c.gl_sub_acct_3
                         AND a.gl_sub_acct_4 = c.gl_sub_acct_4
                         AND a.gl_sub_acct_5 = c.gl_sub_acct_5
                         AND a.gl_sub_acct_6 = c.gl_sub_acct_6
                         AND a.gl_sub_acct_7 = c.gl_sub_acct_7
                         ---and b.gfun_fund_cd = e.fund_cd
                         --- and b.gibr_branch_cd = e.branch_cd
                         AND d.gibr_gfun_fund_cd = e.fund_cd(+)
                         AND d.gibr_branch_cd = e.branch_cd(+)
                         AND d.or_pref_suf = e.or_pref_suf(+)
                         AND (   (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') = 'Y'
                                  AND b.tran_class IN ('CDC', 'COL')
                                 )
                              OR (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') = 'N'
                                  AND b.tran_class = 'COL'
                                 )
                             )
                         AND 
                    --  and  b.tran_class in ('COL', 'CDC') and
                             (       (TRUNC (d.or_date) BETWEEN p_date AND p_date2)
                                 AND (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                                      AND p_post_tran_toggle = 'P'
                                      AND (d.or_flag IN ('C', 'P') OR d.or_cancel_tag = 'Y')
                                     ---mikel 04.16.2012; added OR d.or_cancel_tag to include reversing entries
                                     )
                              OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                                  AND p_post_tran_toggle = 'P'
                                  AND b.tran_flag IN ('C', 'P')
                                  AND d.or_flag IN ('C', 'P')
                                 )
                              OR (    TRUNC (tran_date) BETWEEN p_date AND p_date2
                                  AND p_post_tran_toggle = 'T'
                                 )
                              OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                                  AND tran_flag IN ('C', 'P')
                                  AND p_post_tran_toggle = 'P'
                                  AND b.tran_class = 'CDC'
                                 )
                             )
                         AND (   (tran_flag IN ('C', 'P') AND p_post_tran_toggle = 'P')
                              OR (    b.tran_flag IN ('C', 'P')
                                  AND b.tran_class = 'CDC'
                                  AND p_post_tran_toggle = 'T'
                                 )
                              OR (    b.tran_flag IN ('C', 'P')
                                  AND d.or_flag IN ('C', 'P')
                                  AND p_post_tran_toggle = 'T'
                                 )
                              OR (    b.tran_flag IN ('C', 'D') -- Added by Jerome Bautista 03.09.2016 SR 21536
                                  AND d.or_flag IN ('C','P')
                                  AND p_post_tran_toggle = 'T'
                                 )
                             )
                    /*AND ((tran_flag IN ('C','P','D','O') AND p_post_tran_toggle='P')
                            OR (b.tran_flag IN ('C','P','D','O') AND b.tran_class = 'CDC' AND p_post_tran_toggle='T')
                            OR (b.tran_flag IN ('C','P','D','O') AND d.or_flag IN ('C','P') AND p_post_tran_toggle='T')) */---and b.gibr_branch_cd=nvl(p_BRANCH, NVL(d.gibr_branch_cd,b.gibr_branch_cd ))
                         AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
                         AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_iss_cd b2,
                                         giis_modules_tran c,
                                         giis_user_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = b.gibr_branch_cd
                                     AND c.module_id = 'GIACS117'
                                     AND a.user_id = b2.userid
                                     AND d.userid = a.user_id
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id)
                            OR EXISTS (
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_grp_dtl b2,
                                         giis_modules_tran c,
                                         giis_user_grp_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = b.gibr_branch_cd
                                     AND c.module_id = 'GIACS117'
                                     AND a.user_grp = b2.user_grp
                                     AND d.user_grp = a.user_grp
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id)
                           )
                         --AND check_user_per_iss_cd_acctg2 (NULL, b.gibr_branch_cd, 'GIACS117', p_user_id) = 1  
                         --added by reymon 06142012
                         AND param_name = 'CURRENCY_CD'
                    --BY JAYR 090303
                    --to include cancelled OR's in the report
                    /*((TRUNC(posting_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='P'
                          AND d.or_flag IN ('C','P'))
                      OR (TRUNC(posting_date) BETWEEN p_date AND p_date2
                           AND p_post_tran_toggle='P' AND
                           b.tran_flag IN ('C','P') AND d.or_flag IN ('C','P'))
                      OR (TRUNC(tran_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='T')
                      OR (TRUNC(posting_date) BETWEEN p_date AND p_date2 AND tran_flag IN ('C','P') AND p_post_tran_toggle='P' AND b.tran_class='CDC'))
                    AND ((tran_flag IN ('C','P') AND p_post_tran_toggle='P')
                            OR (b.tran_flag IN ('C','P') AND b.tran_class = 'CDC' AND p_post_tran_toggle='T')
                            OR (b.tran_flag IN ('C','P') AND d.or_flag IN ('C','P') AND p_post_tran_toggle='T'))
                      ---and b.gibr_branch_cd=nvl(p_BRANCH, NVL(d.gibr_branch_cd,b.gibr_branch_cd ))
                        and b.gibr_branch_cd=nvl(p_BRANCH, b.gibr_branch_cd)
                    and param_name='CURRENCY_CD'
                    */
                    UNION ALL
                    SELECT   d.intm_no, b.gfun_fund_cd, b.gibr_branch_cd, gb.branch_name,
                                DECODE (gso.or_pref, NULL, NULL, gso.or_pref || '-')
                             || LPAD (gso.or_no, 10, 0) or_no,
                             gso.or_pref, '', gso.or_no "OR", '',
                             a.gl_control_acct gl_control_acct, a.gl_acct_category,
                             gso.or_date or_date, '', b.posting_date, 'SPOILED' "payor",
                             'SPOILED' particulars, d.gross_amt "Gross Amt", 0, NULL, 0,
                             0 "Collection Amt",
                                LTRIM (TO_CHAR (a.gl_acct_category))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) "GL Account",
                             c.gl_acct_name "GL Account Name", 0 debit_amt, 0 credit_amt,
                             LPAD (NVL (gso.tran_id, NULL), 12, 0) gacc_tran_id,
                                                           --ADDED LEADING ZEROS BY APRIL 11042011
                    --  nvl(gso.tran_id,null),
                                                                                a.sl_cd,
                             e.or_type, d.tin,                     -- added by mjmcustodio 10/04/11
                             b.tran_flag, d.or_flag -- Added by Jerome Bautista 03.09.2016 SR 21536
                        FROM giac_acct_entries a,
                             giac_acctrans b,
                             giac_chart_of_accts c,
                             giac_order_of_payts d,
                             giac_or_pref e,
                             giac_branches gb,
                             giac_spoiled_or gso
                       WHERE (   (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') = 'Y'
                                  AND b.tran_class IN ('CDC', 'COL')
                                 )
                              OR (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') = 'N'
                                  AND b.tran_class = 'COL'
                                 )
                             )
                         AND TRUNC (spoil_date) BETWEEN p_date AND p_date2
                         AND b.gfun_fund_cd = gb.gfun_fund_cd
                         AND b.gibr_branch_cd = gb.branch_cd
                         AND d.gibr_gfun_fund_cd = gb.gfun_fund_cd(+)
                         AND d.gibr_branch_cd = gb.branch_cd(+)
                         AND a.gacc_tran_id = b.tran_id
                         AND gso.tran_id(+) = d.gacc_tran_id
                         AND b.tran_id = d.gacc_tran_id(+)
                         AND a.gl_acct_category = c.gl_acct_category
                         AND a.gl_control_acct = c.gl_control_acct
                         AND a.gl_sub_acct_1 = c.gl_sub_acct_1
                         AND a.gl_sub_acct_2 = c.gl_sub_acct_2
                         AND a.gl_sub_acct_3 = c.gl_sub_acct_3
                         AND a.gl_sub_acct_4 = c.gl_sub_acct_4
                         AND a.gl_sub_acct_5 = c.gl_sub_acct_5
                         AND a.gl_sub_acct_6 = c.gl_sub_acct_6
                         AND a.gl_sub_acct_7 = c.gl_sub_acct_7
                    ----and b.gfun_fund_cd = e.fund_cd
                     ---and b.gibr_branch_cd = e.branch_cd
                         AND d.gibr_gfun_fund_cd = e.fund_cd(+)
                         AND d.gibr_branch_cd = e.branch_cd(+)
                         AND d.or_pref_suf = e.or_pref_suf(+)
                         -- and  b.tran_class in ('COL', 'CDC')
                         AND TRUNC (gso.or_date) BETWEEN p_date AND p_date2
                         ---and b.gibr_branch_cd=nvl(p_BRANCH, NVL(d.gibr_branch_cd,b.gibr_branch_cd ))
                         AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
                         AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_iss_cd b2,
                                         giis_modules_tran c,
                                         giis_user_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = b.gibr_branch_cd
                                     AND c.module_id = 'GIACS117'
                                     AND a.user_id = b2.userid
                                     AND d.userid = a.user_id
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id)
                            OR EXISTS (
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_grp_dtl b2,
                                         giis_modules_tran c,
                                         giis_user_grp_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = b.gibr_branch_cd
                                     AND c.module_id = 'GIACS117'
                                     AND a.user_grp = b2.user_grp
                                     AND d.user_grp = a.user_grp
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id)
                           )
                         --AND check_user_per_iss_cd_acctg2 (NULL, b.gibr_branch_cd,'GIACS117', p_user_id) = 1  
                    --added by reymon 06142012
                    ORDER BY gibr_branch_cd, 5, 6, 7, 8, 9, 10, 11)        -- gibr_branch_cd added by shan 09.28.12        
        LOOP                         
            /* foreign _amt */
            SELECT PARAM_VALUE_N
              INTO v_currency_cd
              FROM GIAC_PARAMETERS
             WHERE PARAM_NAME='CURRENCY_CD';
              
            IF v_currency_cd = i.currency_cd THEN
               v_foreign_amt := 0;
            ELSE
               v_foreign_amt := i."Collection Amt";
            END IF;
  
            /* collection_amt */
            IF v_foreign_amt IS NULL OR v_foreign_amt = 0 THEN
                v_collection_amt := i."Collection Amt";
            ELSE
                BEGIN
                    SELECT SUM(AMOUNT)
                      INTO v_collection_amt
                      FROM GIAC_COLLECTION_DTL
                     WHERE GACC_TRAN_ID = i.gacc_tran_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;
            END IF;
                                  
                        
            /* computes for the following (per or_no) */
            IF v_or_no = i.or_no OR NVL(i.or_no, 'N') = 'N' THEN
                v_same_or                   := true;
                
                IF v_payor = i."payor" THEN
                    v_same_payor            := TRUE;          
                    v_dist_or_tran_id       := 0;     
                    v_branch_collection_amt := 0;     
                ELSE
                    v_same_payor            := FALSE;                    
                    v_payor                 := i."payor";
                    v_dist_or_tran_id       := 1;
                    v_branch_collection_amt := v_branch_collection_amt + v_collection_amt; 
                END IF;
                
                v_or_vat_amt                := 0;
                v_or_nonvat_amt             := 0; 
                --v_branch_collection_amt     := 0; 
                
            ELSE
                v_same_or       := false;
                v_same_payor    := FALSE;
                v_or_no         := i.or_no;
                v_payor         := i."payor"; 
                v_dist_or_tran_id := 1;
                
                /*IF NVL(i.or_no, 'N') = 'N' THEN
                    v_dist_or_tran_id := 0;   
                    v_branch_collection_amt := 0;                                            
                ELSE
                    v_dist_or_tran_id := 1; 
                    v_branch_collection_amt := v_branch_collection_amt + v_collection_amt; 
                END IF;        */
                
                
                 /* vat_amt */
                IF i.or_type = 'V' THEN
                    v_or_vat_amt := v_or_vat_amt + i."Collection Amt";
                ELSE
                    v_or_vat_amt := 0;
                END IF;
                
                 /* nonvat_amt */
                IF i.or_type = 'N' THEN
                    v_or_nonvat_amt := v_or_nonvat_amt + i."Collection Amt";
                ELSE
                    v_or_nonvat_amt := 0;
                END IF;                            
                
                /* branch_collection_amt */
                v_branch_collection_amt := v_branch_collection_amt + v_collection_amt; 
            END IF;       
                     
            /*            
            v_tran_class                            :=  i.tran_class;
            v_tran_class_no                         :=  i.tran_class_no;
            v_gl_control_acct                       :=  i.gl_control_acct;
            v_gl_acct_category                      :=  i.gl_acct_category;
            v_gross_amt                             :=  i."Gross Amt";
            v_currency_cd                           :=  i.currency_cd;
            v_short_name                            :=  i.short_name;
            v_or_type                               :=  i.or_type;
             */
                              
            v_rec_exists                                := TRUE;
            v_giacr117_details.print_details            := 'Y';
            v_giacr117_details.intm_no                  :=  i.intm_no;          
            v_giacr117_details.gibr_branch_cd           :=  i.gibr_branch_cd;
            v_giacr117_details.branch_name              :=  i.branch_name;
            v_giacr117_details.or_no                    :=  i.or_no;               
            v_giacr117_details.tran_id                  :=  i.gacc_tran_id; 
            v_giacr117_details.or_date                  :=  TO_CHAR(i.or_date, cp_date_format);
            v_giacr117_details.dcb_no                   :=  i."dcb_no";
            v_giacr117_details.posting_date             :=  TO_CHAR(i.posting_date, cp_date_format);
            v_giacr117_details.prev_payor_value         :=  v_giacr117_details.payor;
            v_giacr117_details.payor                    :=  i."payor";
            v_giacr117_details.particulars              :=  i.particulars;            
            v_giacr117_details.collection_amt           :=  v_collection_amt;
            v_giacr117_details.gl_account               :=  i."GL Account";
            v_giacr117_details.gl_acct_name             :=  i."GL Account Name";
            v_giacr117_details.debit_amt                :=  i.debit_amt;
            v_giacr117_details.credit_amt               :=  i.credit_amt;
            v_giacr117_details.sl_cd                    :=  i.sl_cd;
            v_giacr117_details.tin                      :=  i.tin; 
            --v_giacr117_details.r_db                   :=  v_r_db;
            --v_giacr117_details.r_cd                   :=  v_r_cd;
            v_giacr117_details.or_vat_amt               :=  v_or_vat_amt;
            v_giacr117_details.or_nonvat_amt            :=  v_or_nonvat_amt;
            v_giacr117_details.branch_collection_amt    :=  v_branch_collection_amt;  
            v_giacr117_details.dist_or_tran_id          :=  v_dist_or_tran_id;
            v_giacr117_details.or_flag                  :=  i.or_flag; -- Added by Jerome Bautista 03.09.2016 SR 21536
            v_giacr117_details.tran_flag                :=  i.tran_flag; -- Added by Jerome Bautista 03.09.2016 SR 21536          
             
            /* intm_no */
            IF i.intm_no IS NOT NULL then
                SELECT intm_no || decode(ref_intm_cd, NULL, ' ', '/' || ref_intm_cd)
                  INTO v_giacr117_details.intm_no
                  FROM GIIS_INTERMEDIARY
                 WHERE intm_no = i.intm_no; 
            ELSE
                v_giacr117_details.intm_no  := i.intm_no;
            END IF;
            
        --  IF v_same_or = true THEN
        --      v_giacr117_details.total_or_trans   := v_total_or_trans;
        --  END IF;       
                   PIPE ROW (v_giacr117_details);
--            IF (v_same_or = true AND (v_giacr117_details.payor NOT IN ('SPOILED','CANCELLED') OR v_same_payor = false)) -- Commented out by Jerome Bautista 07.12.2016 SR 21536
--                --OR (v_same_or = true AND v_same_payor = false)
--                OR v_same_or = false THEN
--                PIPE ROW (v_giacr117_details);
--            END IF;
            
        END LOOP;
        
        IF v_rec_exists = FALSE THEN            -- added by shan 12.10.2013
            v_giacr117_details.print_details := 'N';
            PIPE ROW(v_giacr117_details);
        END IF;
                 
        RETURN;       
       
    END get_cr_reg_details;  
    
    
    
    FUNCTION get_cr_reg_dets_smmary (
        p_date                  DATE,
        p_date2                 DATE,
        p_post_tran_toggle      VARCHAR2,
        p_branch                GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
        --p_module_id             GIIS_MODULES_TRAN.MODULE_ID%TYPE,
        p_per_branch            VARCHAR2,
        p_user_id               VARCHAR2
    )
        RETURN giacr117_cr_reg_smmary_tab PIPELINED
        
    IS
        v_cr_reg_details_smmary     giacr117_cr_reg_smmary_type;
        
         ---grand total             
        v_smmary_gfun_fund_cd       GIAC_ACCTRANS.GFUN_FUND_CD%TYPE;
        v_smmary_branch_cd          GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE; 
        v_smmary_branch_name        GIAC_BRANCHES.BRANCH_NAME%TYPE;
        v_smmary_gl_acct_no         VARCHAR2(72) := '';
        v_smmary_gl_acct_name       GIAC_CHART_OF_ACCTS.GL_ACCT_NAME%TYPE;
        v_smmary_db_amt             NUMBER(12,2) := 0;
        v_smmary_cd_amt             NUMBER(12,2) := 0;
        v_smmary_bal_amt            NUMBER(12,2) := 0;
        /*v_smmary_total_db_amt       NUMBER(12,2) := 0;
        v_smmary_total_cd_amt       NUMBER(12,2) := 0;
        v_smmary_total_bal_amt      NUMBER(12,2) := 0;
        v_smmary_grand_db_amt       NUMBER(12,2) := 0;
        v_smmary_grand_cd_amt       NUMBER(12,2) := 0;
        v_smmary_grand_bal_amt      NUMBER(12,2) := 0;   */      

    BEGIN
        IF p_per_branch = 'N' THEN
            FOR i IN    (SELECT b.gfun_fund_cd acct_gibr_gfun_fund_cd, 
                                --b.gibr_branch_cd acct_gibr_branch_cd,
                                --gb.branch_name acct_branch_name,
                                LTRIM(TO_CHAR(A.GL_ACCT_CATEGORY))||'-'||  
                                       LTRIM(TO_CHAR(A.GL_CONTROL_ACCT, '09'))||'-'||               
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_1, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_2, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_3, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_4, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_5, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_6, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_7, '09'))  "GL ACCT NO.",
                                       C.GL_ACCT_NAME "ACCT NAME",
                                  sum(decode(d.or_flag,'C',0,NVL(a.debit_amt,0))) "DB AMT",
                                  sum(decode(d.or_flag,'C',0,NVL(a.credit_amt,0))) "CD AMT",
                                  sum(decode(d.or_flag,'C',0,NVL(a.debit_amt,0)-NVL(a.credit_amt,0))) "BAL_AMT"
                                --  sum(a.debit_amt) "DB_AMT"
                                -- ,sum(a.credit_amt) "CD_AMT"
                           FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts c,  
                                    giac_order_of_payts d,
                                    giac_branches gb,
                                    giis_currency gc,
                                    giac_parameters gp
                          WHERE
                                    gc.main_currency_cd(+)=d.currency_cd
                                      and b.gfun_fund_cd = gb.gfun_fund_cd
                                      and b.gibr_branch_cd = gb.branch_cd
                                    --  and d.gibr_gfun_fund_cd=gb.gfun_fund_cd(+)
                                    --  and d.gibr_branch_cd=gb.branch_cd (+)
                                      and  a.gacc_tran_id = b.tran_id
                                      and b.tran_id = d.gacc_tran_id(+)
                                      and a.gl_acct_category = c.gl_acct_category
                                      and a.gl_control_acct=c.gl_control_acct
                                      and a.gl_sub_acct_1 = c.gl_sub_acct_1
                                      and a.gl_sub_acct_2=c.gl_sub_acct_2
                                      and a.gl_sub_acct_3=c.gl_sub_acct_3
                                      and a.gl_sub_acct_4=c.gl_sub_acct_4
                                      and a.gl_sub_acct_5=c.gl_sub_acct_5
                                      and a.gl_sub_acct_6=c.gl_sub_acct_6
                                      and a.gl_sub_acct_7=c.gl_sub_acct_7
                                      and  b.tran_class in ('COL', 'CDC')and
                                    ((TRUNC(posting_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='P' 
                                          AND d.or_flag IN ('C','P'))
                                      OR (TRUNC(posting_date) BETWEEN p_date AND p_date2 
                                           AND p_post_tran_toggle='P' AND 
                                           b.tran_flag IN ('C','P') AND d.or_flag IN ('C','P'))
                                      OR (TRUNC(tran_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='T')
                                      OR (TRUNC(posting_date) BETWEEN p_date AND p_date2 AND tran_flag IN ('C','P') AND p_post_tran_toggle='P' AND b.tran_class='CDC'))
                                    AND ((tran_flag IN ('C','P') AND p_post_tran_toggle='P')
                                            OR (b.tran_flag IN ('C','P') AND b.tran_class = 'CDC' AND p_post_tran_toggle='T')
                                            OR (b.tran_flag IN ('C','P') AND d.or_flag IN ('C','P') AND p_post_tran_toggle='T'))
                                    /*((trunc(posting_date) between p_date and p_date2 and p_post_tran_toggle='P')
                                    or
                                    (trunc(tran_date) between p_date and p_date2 and p_post_tran_toggle='T'))
                                    and
                                    ((tran_flag in ('C','P') and p_post_tran_toggle='P')
                                    or
                                    (tran_flag in ('C','P') and p_post_tran_toggle='T'))*/
                                    and b.gibr_branch_cd=nvl(p_BRANCH,NVL(d.gibr_branch_cd,b.gibr_branch_cd))
                                    AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                                          SELECT d.access_tag
                                            FROM giis_users a,
                                                 giis_user_iss_cd b2,
                                                 giis_modules_tran c,
                                                 giis_user_modules d
                                           WHERE a.user_id = p_user_id
                                             AND b2.iss_cd = NVL(d.gibr_branch_cd,b.gibr_branch_cd)
                                             AND c.module_id = 'GIACS117'
                                             AND a.user_id = b2.userid
                                             AND d.userid = a.user_id
                                             AND b2.tran_cd = c.tran_cd
                                             AND d.tran_cd = c.tran_cd
                                             AND d.module_id = c.module_id)
                                    OR EXISTS (
                                          SELECT d.access_tag
                                            FROM giis_users a,
                                                 giis_user_grp_dtl b2,
                                                 giis_modules_tran c,
                                                 giis_user_grp_modules d
                                           WHERE a.user_id = p_user_id
                                             AND b2.iss_cd = NVL(d.gibr_branch_cd,b.gibr_branch_cd)
                                             AND c.module_id = 'GIACS117'
                                             AND a.user_grp = b2.user_grp
                                             AND d.user_grp = a.user_grp
                                             AND b2.tran_cd = c.tran_cd
                                             AND d.tran_cd = c.tran_cd
                                             AND d.module_id = c.module_id)
                                   )
                                    --AND check_user_per_iss_cd_acctg2 (NULL, NVL(d.gibr_branch_cd,b.gibr_branch_cd), 'GIACS117', p_user_id) = 1  --added by reymon 06142012  
                                    and param_name='CURRENCY_CD'
                          GROUP BY
                                       b.gfun_fund_cd,
                                     --  b.gibr_branch_cd,
                                      -- gb.branch_name,
                                       LTRIM(TO_CHAR(A.GL_ACCT_CATEGORY))||'-'||  
                                       LTRIM(TO_CHAR(A.GL_CONTROL_ACCT, '09'))||'-'||               
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_1, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_2, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_3, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_4, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_5, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_6, '09'))||'-'||          
                                       LTRIM(TO_CHAR(A.GL_SUB_ACCT_7, '09')) ,
                                       C.GL_ACCT_NAME 
                              ORDER BY 1 )
                LOOP
                    v_cr_reg_details_smmary.smmary_gfun_fund_cd      :=  i.acct_gibr_gfun_fund_cd;
                    v_cr_reg_details_smmary.smmary_gl_acct_no        :=  i."GL ACCT NO.";
                    v_cr_reg_details_smmary.smmary_gl_acct_name      :=  i."ACCT NAME";
                    v_cr_reg_details_smmary.smmary_db_amt            :=  i."DB AMT";
                    v_cr_reg_details_smmary.smmary_cd_amt            :=  i."CD AMT";
                    v_cr_reg_details_smmary.smmary_bal_amt           :=  i."BAL_AMT";
                    PIPE ROW (v_cr_reg_details_smmary);
                END LOOP;
                    
            ELSIF p_per_branch = 'Y' OR p_per_branch = '' THEN   
                
                FOR i IN    (SELECT   b.gfun_fund_cd acct_gibr_gfun_fund_cd,
                                     b.gibr_branch_cd acct_gibr_branch_cd,
                                     gb.branch_name acct_branch_name,
                                        LTRIM (TO_CHAR (a.gl_acct_category))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) "GL ACCT NO.",
                                     c.gl_acct_name "ACCT NAME",
                                                                /*SUM (DECODE (d.or_flag, 'C', 0, NVL (a.debit_amt, 0))) "DB AMT",
                                                                SUM (DECODE (d.or_flag, 'C', 0, NVL (a.credit_amt, 0))) "CD AMT",
                                                                SUM (DECODE (d.or_flag,
                                                                             'C', 0,
                                                                             NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)
                                                                            )
                                                                    ) " BAL_AMT"*/--commented out by mikel 04.16.2012, replaced by codes below
                                                                SUM (NVL (a.debit_amt, 0)) "DB AMT",
                                     SUM (NVL (a.credit_amt, 0)) "CD AMT",
                                     SUM (NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)) "BAL_AMT"
                                     --end mikel
                            --  sum(a.debit_amt) "DB_AMT"
                            -- ,sum(a.credit_amt) "CD_AMT"
                            FROM     giac_acct_entries a,
                                     giac_acctrans b,
                                     giac_chart_of_accts c,
                                     giac_order_of_payts d,
                                     giac_branches gb,
                                     giis_currency gc,
                                     giac_parameters gp
                               WHERE gc.main_currency_cd(+) = d.currency_cd
                                 AND b.gfun_fund_cd = gb.gfun_fund_cd
                                 AND b.gibr_branch_cd = gb.branch_cd
                            --  and d.gibr_gfun_fund_cd=gb.gfun_fund_cd(+)
                            --  and d.gibr_branch_cd=gb.branch_cd (+)
                                 AND a.gacc_tran_id = b.tran_id
                                 AND b.tran_id = d.gacc_tran_id(+)
                                 AND a.gl_acct_category = c.gl_acct_category
                                 AND a.gl_control_acct = c.gl_control_acct
                                 AND a.gl_sub_acct_1 = c.gl_sub_acct_1
                                 AND a.gl_sub_acct_2 = c.gl_sub_acct_2
                                 AND a.gl_sub_acct_3 = c.gl_sub_acct_3
                                 AND a.gl_sub_acct_4 = c.gl_sub_acct_4
                                 AND a.gl_sub_acct_5 = c.gl_sub_acct_5
                                 AND a.gl_sub_acct_6 = c.gl_sub_acct_6
                                 AND a.gl_sub_acct_7 = c.gl_sub_acct_7
                                 AND b.tran_class IN ('COL', 'CDC')
                                 AND (   (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                                          AND p_post_tran_toggle = 'P'
                                          AND (d.or_flag IN ('C', 'P') OR d.or_cancel_tag = 'Y')
                                         ---mikel 04.16.2012; added OR d.or_cancel_tag to include reversing entries
                                         )
                                      OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                                          AND p_post_tran_toggle = 'P'
                                          AND b.tran_flag IN ('C', 'P')
                                          AND d.or_flag IN ('C', 'P')
                                         )
                                      OR (    TRUNC (tran_date) BETWEEN p_date AND p_date2
                                          AND p_post_tran_toggle = 'T'
                                         )
                                      OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                                          AND tran_flag IN ('C', 'P')
                                          AND p_post_tran_toggle = 'P'
                                          AND b.tran_class = 'CDC'
                                         )
                                     )
                                 AND (   (tran_flag IN ('C', 'P') AND p_post_tran_toggle = 'P')
                                      OR (    b.tran_flag IN ('C', 'P')
                                          AND b.tran_class = 'CDC'
                                          AND p_post_tran_toggle = 'T'
                                         )
                                      OR (    b.tran_flag IN ('C', 'P')
                                          AND d.or_flag IN ('C', 'P')
                                          AND p_post_tran_toggle = 'T'
                                         )
                                     )
                            /*((trunc(posting_date) between p_date and p_date2 and p_post_tran_toggle='P')
                            or
                            (trunc(tran_date) between p_date and p_date2 and p_post_tran_toggle='T'))
                            and
                            ((tran_flag in ('C','P') and p_post_tran_toggle='P')
                            or
                            (tran_flag in ('C','P') and p_post_tran_toggle='T'))*/
                                 AND b.gibr_branch_cd =
                                                 NVL (p_branch, NVL (d.gibr_branch_cd, b.gibr_branch_cd))
                                 AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                                          SELECT d.access_tag
                                            FROM giis_users a,
                                                 giis_user_iss_cd b2,
                                                 giis_modules_tran c,
                                                 giis_user_modules d
                                           WHERE a.user_id = p_user_id
                                             AND b2.iss_cd = NVL (d.gibr_branch_cd, b.gibr_branch_cd)
                                             AND c.module_id = 'GIACS117'
                                             AND a.user_id = b2.userid
                                             AND d.userid = a.user_id
                                             AND b2.tran_cd = c.tran_cd
                                             AND d.tran_cd = c.tran_cd
                                             AND d.module_id = c.module_id)
                                    OR EXISTS (
                                          SELECT d.access_tag
                                            FROM giis_users a,
                                                 giis_user_grp_dtl b2,
                                                 giis_modules_tran c,
                                                 giis_user_grp_modules d
                                           WHERE a.user_id = p_user_id
                                             AND b2.iss_cd = NVL (d.gibr_branch_cd, b.gibr_branch_cd)
                                             AND c.module_id = 'GIACS117'
                                             AND a.user_grp = b2.user_grp
                                             AND d.user_grp = a.user_grp
                                             AND b2.tran_cd = c.tran_cd
                                             AND d.tran_cd = c.tran_cd
                                             AND d.module_id = c.module_id)
                                   )
                                 --AND check_user_per_iss_cd_acctg2 (NULL,NVL (d.gibr_branch_cd, b.gibr_branch_cd),'GIACS117',p_user_id) = 1          --added by reymon 06142012*/
                                 AND param_name = 'CURRENCY_CD'
                            GROUP BY b.gfun_fund_cd,
                                     b.gibr_branch_cd,
                                     gb.branch_name,
                                        LTRIM (TO_CHAR (a.gl_acct_category))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')),
                                     c.gl_acct_name
                            ORDER BY 1)
            LOOP                
                v_cr_reg_details_smmary.smmary_gfun_fund_cd      :=  i.acct_gibr_gfun_fund_cd;
                v_cr_reg_details_smmary.smmary_branch_cd         :=  i.acct_gibr_branch_cd;
                v_cr_reg_details_smmary.smmary_branch_name       :=  i.acct_branch_name;
                v_cr_reg_details_smmary.smmary_gl_acct_no        :=  i."GL ACCT NO.";
                v_cr_reg_details_smmary.smmary_gl_acct_name      :=  i."ACCT NAME";
                v_cr_reg_details_smmary.smmary_db_amt            :=  i."DB AMT";
                v_cr_reg_details_smmary.smmary_cd_amt            :=  i."CD AMT";
                v_cr_reg_details_smmary.smmary_bal_amt           :=  i."BAL_AMT";
                
                PIPE ROW (v_cr_reg_details_smmary);
            END LOOP;  
        END IF;          
                  
        RETURN;
        
    END get_cr_reg_dets_smmary;
    
    
END giacr117_PKG;
/


