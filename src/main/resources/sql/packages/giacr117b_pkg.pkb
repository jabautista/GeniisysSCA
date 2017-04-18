CREATE OR REPLACE PACKAGE BODY CPI.giacr117b_pkg
AS 
FUNCTION get_cash_rcpt_rgstr_smmry(
         p_date                 DATE,
         p_date2                DATE,
         p_tran_class           GIAC_ACCTRANS.TRAN_CLASS%TYPE,
         p_post_tran_toggle     GIAC_ACCTRANS.TRAN_CLASS%TYPE,
         p_branch               GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
         p_per_branch           VARCHAR2,
         p_user_id              GIAC_ACCTRANS.USER_ID%type      --added by shan 12.18.2013
     )
     
     RETURN get_giacr117b_tab PIPELINED
     IS    
            v_list      get_giacr117b_type;
            v_print     boolean := false;   
    BEGIN
        select param_value_v company_address
          into v_list.company_address
          from giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
            
        SELECT  param_value_v as company_name
          INTO  v_list.company_name  
          FROM  GIIS_PARAMETERS
         WHERE param_name like 'COMPANY_NAME';

		  v_list.company_tin := 'VAT REG TIN ' || giisp.v ('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5964
        v_list.gen_version := giisp.v('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5964
                
        v_list.header_date := 'From '||TO_CHAR(p_date,'fmMonth DD, RRRR')||' to '||TO_CHAR(p_date2,'fmMonth DD, RRRR');  
          
        FOR i IN ( SELECT   b.gfun_fund_cd acct_gibr_gfun_fund_cd,
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
                     || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) as GL_ACCT_NO,
                     c.gl_acct_name as GL_ACCT_NAME,
                     SUM (NVL (a.debit_amt, 0)) as debit_amt,
                     SUM (NVL (a.credit_amt, 0)) as credit_amt,
                     SUM (NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)) as bal_amt
            FROM     giac_acct_entries a,
                     giac_acctrans b,
                     giac_chart_of_accts c,
                     giac_order_of_payts d,
                     giac_branches gb,
                     giis_currency gc,
                     giac_parameters gp
               WHERE
                     gc.main_currency_cd(+) = d.currency_cd
                 AND b.gfun_fund_cd = gb.gfun_fund_cd
                 AND b.gibr_branch_cd = gb.branch_cd
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
                 AND (   (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') = 'Y'
                          AND b.tran_class IN ('CDC', 'COL')
                         )
                      OR (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') = 'N'
                          AND b.tran_class = 'COL'
                         )
                     )
                 AND (       (TRUNC (d.or_date) BETWEEN p_date AND p_date2)
                         AND (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                              AND p_post_tran_toggle = 'P'
                              AND (d.or_flag IN ('C', 'P') OR d.or_cancel_tag = 'Y')
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
                          AND tran_flag IN ('C', 'P' /*,'O','D'*/)
                          AND p_post_tran_toggle = 'P'
                          AND b.tran_class = 'CDC'
                         )
                     )
                 AND (   (tran_flag IN ('C', 'P' /*,'D'*/) AND p_post_tran_toggle = 'P')
                      OR (    b.tran_flag IN ('C', 'P' /*,'D'*/)
                          AND b.tran_class = 'CDC'
                          AND p_post_tran_toggle = 'T'
                         )
                      OR (    b.tran_flag IN ('C', 'P' /*,'D'*/)
                          AND d.or_flag IN ('C', 'P')
                          AND p_post_tran_toggle = 'T'
                         )
                     )
                 AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
                 AND param_name = 'CURRENCY_CD'
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
            ORDER BY 1
             )
             
            LOOP
                    v_print                     := TRUE;
                    v_list.print_details        := 'Y';       
                    v_list.acct_gfun_fund_cd    :=  i.acct_gibr_gfun_fund_cd;
                    v_list.gl_acct_number       :=  i.GL_ACCT_NO;
                    v_list.gl_acct_name         :=  i.gl_acct_name;
                    v_list.debit_amt            :=  i.debit_amt;
                    v_list.credit_amt           :=  i.credit_amt;
                    v_list.balance_amt          :=  i.bal_amt; 
                    
                if (p_per_branch = 'Y') then
                    v_list.acct_branch_name     :=  i.acct_gibr_branch_cd||' - '||i.acct_branch_name;
                    
                else
                    v_list.acct_branch_name     :=  'ALL BRANCHES';
                end if;                       
                    
                    
             /* moved above : shan 12.18.2013
             select param_value_v company_address
             into v_list.company_address
               from giis_parameters
              WHERE param_name = 'COMPANY_ADDRESS';
            
                SELECT  param_value_v as company_name
                INTO  v_list.company_name  
                FROM  GIIS_PARAMETERS
                WHERE param_name like 'COMPANY_NAME';
                
                
                v_list.header_date := 'From '||TO_CHAR(p_date,'fmMonth DD, RRRR')||' to '||TO_CHAR(p_date2,'fmMonth DD, RRRR'); */
                
                                                
                    PIPE ROW (v_list);        
             END LOOP;  
         
        IF v_print = FALSE THEN
            v_list.print_details := 'N';
            PIPE ROW(v_list);
        END IF;
                    
        RETURN;        
    END;
END;
/


