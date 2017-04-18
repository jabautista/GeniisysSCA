CREATE OR REPLACE PACKAGE BODY CPI.GIACS230_PKG
AS
     
    FUNCTION get_gl_acct_tran_list(
        p_gl_acct_id        giac_chart_of_accts.GL_ACCT_ID%type,
        p_gl_acct_type      VARCHAR2,
        p_gl_acct_cat       giac_chart_of_accts.GL_ACCT_CATEGORY%type,
        p_gl_ctrl_acct      giac_chart_of_accts.GL_CONTROL_ACCT%type,
        p_gfun_fund_cd      GIAC_BRANCHES.GFUN_FUND_CD%type,
        p_branch_cd         GIAC_BRANCHES.BRANCH_CD%type,
        p_dt_basis          NUMBER,
        p_from_date         DATE,
        p_to_date           DATE,
        p_tran_open_flag    VARCHAR2,
        p_module_id         GIIS_MODULES.module_id%TYPE,
        p_user              GIIS_USERS.USER_ID%type
    ) RETURN gl_transaction_list_tab PIPELINED
    AS
        rep     gl_transaction_list_type;
    BEGIN
        IF p_tran_open_flag = 'N' THEN
            FOR i IN (SELECT a.* 
                        FROM GIAC_GL_INQUIRY_V a, 
                             GIAC_BRANCHES b
                       WHERE b.BRANCH_CD = p_branch_cd
                         AND b.GFUN_FUND_CD = p_gfun_fund_cd
                         AND a.FUND_CD = b.GFUN_FUND_CD
                         AND a.BRANCH_CD = b.BRANCH_CD
                         AND b.BRANCH_CD IN (SELECT ISS_CD 
                                               FROM GIIS_ISSOURCE 
                                              WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(null, iss_cd, p_module_id, p_user),
                                                                    1, iss_cd,
                                                                    NULL))
                         AND a.GL_ACCT_ID IN (SELECT DISTINCT DECODE(p_gl_acct_type,
                                                                     ''||'M'||'', gl_acct_id,
                                                                     ''||'C'||'', p_gl_acct_id) 
  	   			  		                        FROM giac_chart_of_accts 
    				                           WHERE gl_acct_category = p_gl_acct_cat
					                             AND gl_control_acct = p_gl_ctrl_acct) 
                         AND (DECODE(p_dt_basis, 
                                     1, TRUNC(tran_date),
                                     2, TRUNC(dt_posted)) 
                              BETWEEN p_from_date AND p_to_date))
            LOOP
                rep.tran_no         := i.tran_no;    
                rep.tran_class      := i.tran_class;
                rep.ref_no          := i.ref_no;
                rep.tran_flag       := i.tran_flag;
                rep.tran_date       := i.tran_date;
                rep.dt_posted       := i.dt_posted;
                rep.debit_amt       := i.debit_amt;
                rep.credit_amt      := i.credit_amt;
                rep.sl_cd           := i.sl_cd;
                rep.sl_type_cd      := i.sl_type_cd;
                rep.sl_source_cd    := i.sl_source_cd;
                rep.gl_acct_id      := i.gl_acct_id;
                rep.gacc_tran_id    := i.gacc_tran_id;
                rep.fund_cd         := i.fund_cd;
                rep.branch_cd       := i.branch_cd;
                rep.remarks         := i.remarks;
                rep.user_id         := i.user_id;
                rep.last_update     := TO_CHAR (i.last_update, 'MM-dd-yyyy HH:MI:ss AM');
                
                IF i.sl_cd IS NOT NULL THEN 
                    rep.sl_name     := get_sl_name(i.sl_cd, i.sl_type_cd, i.sl_source_cd);
                ELSE
                    rep.sl_name     := NULL;
                END IF;
                
                PIPE ROW(rep);     
            END LOOP;
        ELSIF p_tran_open_flag = 'Y' THEN
            FOR i IN (SELECT a.* 
                        FROM GIAC_GL_INQUIRY_V a, 
                             GIAC_BRANCHES b
                       WHERE b.BRANCH_CD = p_branch_cd
                         AND b.GFUN_FUND_CD = p_gfun_fund_cd
                         AND a.FUND_CD = b.GFUN_FUND_CD
                         AND a.BRANCH_CD = b.BRANCH_CD
                         AND b.BRANCH_CD IN (SELECT ISS_CD 
                                               FROM GIIS_ISSOURCE 
                                              WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(null, iss_cd, p_module_id, p_user),
                                                                    1, iss_cd,
                                                                    NULL))
                         AND a.GL_ACCT_ID IN (SELECT DISTINCT DECODE(p_gl_acct_type,
                                                                     ''||'M'||'', gl_acct_id,
                                                                     ''||'C'||'', p_gl_acct_id) 
  	   			  	    	                    FROM giac_chart_of_accts 
    				                           WHERE gl_acct_category = p_gl_acct_cat
					                             AND gl_control_acct = p_gl_ctrl_acct) 
                         AND (DECODE(p_dt_basis, 
                                     1, TRUNC(tran_date),
                                     2, TRUNC(dt_posted)) 
                              BETWEEN p_from_date  AND p_to_date) AND tran_flag <>''||'O'||'')
            LOOP
                rep.tran_no         := i.tran_no;    
                rep.tran_class      := i.tran_class;
                rep.ref_no          := i.ref_no;
                rep.tran_flag       := i.tran_flag;
                rep.tran_date       := i.tran_date;
                rep.dt_posted       := i.dt_posted;
                rep.debit_amt       := i.debit_amt;
                rep.credit_amt      := i.credit_amt;
                rep.sl_cd           := i.sl_cd;
                rep.sl_type_cd      := i.sl_type_cd;
                rep.sl_source_cd    := i.sl_source_cd;
                rep.gl_acct_id      := i.gl_acct_id;
                rep.gacc_tran_id    := i.gacc_tran_id;
                rep.fund_cd         := i.fund_cd;
                rep.branch_cd       := i.branch_cd;
                rep.remarks         := i.remarks;
                rep.user_id         := i.user_id;
                rep.last_update     := TO_CHAR (i.last_update, 'MM-dd-yyyy HH:MI:ss AM');
                
                IF i.sl_cd IS NOT NULL THEN 
                    rep.sl_name     := get_sl_name(i.sl_cd, i.sl_type_cd, i.sl_source_cd);
                ELSE
                    rep.sl_name     := NULL;
                END IF;
                
                PIPE ROW(rep);   
            END LOOP;
        END IF;
        
    END get_gl_acct_tran_list;
        
    
    FUNCTION get_sl_summary(
        p_gacc_tran_id  GIAC_GL_INQUIRY_V.GACC_TRAN_ID%type,
        p_fund_cd       GIAC_GL_INQUIRY_V.FUND_CD%type,
        p_branch_cd     GIAC_GL_INQUIRY_V.BRANCH_CD%type,
        p_sl_cd         GIAC_GL_INQUIRY_V.SL_CD%type,
        p_debit_amt     GIAC_GL_INQUIRY_V.DEBIT_AMT%type,
        p_credit_amt    GIAC_GL_INQUIRY_V.CREDIT_AMT%type
    ) RETURN gl_transaction_list_tab PIPELINED
    AS
        rep     gl_transaction_list_type;
    BEGIN
        FOR i IN (SELECT distinct fund_cd, branch_cd, sl_cd, sl_type_cd, sl_source_cd, debit_amt, credit_amt 
                    FROM GIAC_GL_INQUIRY_V
                   WHERE gacc_tran_id = p_gacc_tran_id
                     AND UPPER(fund_cd) = UPPER(p_fund_cd)
                     AND UPPER(branch_cd) = UPPER(p_branch_cd)
                     AND sl_cd = p_sl_cd
                     --AND UPPER(get_sl_name(sl_cd, sl_type_cd, sl_source_cd)) = UPPER(p_sl_name)
                     AND debit_amt = p_debit_amt
                     AND credit_amt = p_credit_amt)
        LOOP
            rep.fund_cd     := i.fund_cd;
            rep.branch_cd   := i.branch_cd;
            rep.sl_cd       := i.sl_cd;
            rep.sl_name     := get_sl_name(i.sl_cd, i.sl_type_cd, i.sl_source_cd);
            rep.debit_amt   := i.debit_amt;
            rep.credit_amt  := i.credit_amt;
            
            PIPE ROW(rep);
        END LOOP;
    END get_sl_summary;
    

END GIACS230_PKG;
/


