CREATE OR REPLACE PACKAGE BODY CPI.GIACS241_PKG
AS
   /*
   **  Modified by  :  Maria Gzelle Ison
   **  Date Created : 09.20.2013
   **  Reference By : GIACS241
   **  Remarks      : VIEW CHECKS PAID PER DEPARTMENT
   */
   
    FUNCTION get_fund_list
        RETURN fund_tab PIPELINED
    IS
        v_list  fund_type;
    BEGIN
        FOR i IN(SELECT fund_cd, fund_desc 
                   FROM giis_funds)
        LOOP
            v_list.fund_cd   := i.fund_cd;
            v_list.fund_desc := i.fund_desc;
            PIPE ROW(v_list);
        END LOOP;
    
    END get_fund_list;
    
    FUNCTION get_branch_list(
        p_fund_cd   giis_funds.fund_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED
    IS
        v_list  branch_type;
    BEGIN
        FOR i IN(SELECT branch_cd, branch_name 
                   FROM giac_branches 
                  WHERE gfun_fund_cd = NVL(p_fund_cd, gfun_fund_cd)
                    AND check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS241', p_user_id) = 1)
        LOOP
            v_list.branch_cd   := i.branch_cd;
            v_list.branch_name := i.branch_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_branch_list;
    
    FUNCTION get_ouc_list
        RETURN ouc_tab PIPELINED
    IS
        v_list  ouc_type;
    BEGIN
        FOR i IN(SELECT ouc_id, ouc_name 
                   FROM giac_oucs)
        LOOP
            v_list.ouc_id   := i.ouc_id;
            v_list.ouc_name := i.ouc_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_ouc_list;

    FUNCTION get_checks_paid_list(
        p_user_id   giis_users.user_id%TYPE,
        p_fund_cd   giis_funds.fund_cd%TYPE,
        p_branch_cd giac_branches.branch_cd%TYPE,
        p_ouc_id    giac_oucs.ouc_id%TYPE,
        p_from_date VARCHAR2,
        p_to_date   VARCHAR2
    )
        RETURN checks_paid_list_tab PIPELINED
    IS
        v_list  checks_paid_list_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM giac_pd_checks_v
                  WHERE branch_cd IN (SELECT iss_cd FROM giis_issource
                                       WHERE iss_cd = decode(check_user_per_iss_cd_acctg2(null,iss_cd,'GIACS241',p_user_id),1,iss_cd,NULL))
                    AND fund_cd = UPPER(p_fund_cd)
                    AND ouc_id = p_ouc_id
                    AND branch_cd = UPPER(p_branch_cd)
                    AND TRUNC(check_date) >= NVL(TO_DATE(p_from_date,'MM-DD-YYYY'), check_date) 
                    AND TRUNC(check_date) <= NVL(TO_DATE(p_to_date,'MM-DD-YYYY'), check_date)
               ORDER BY ouc_id,payee_class_cd,payee_last_name,payee_first_name,payee_middle_name)
        
        LOOP
            v_list.fund_cd          := i.fund_cd;
            v_list.fund_desc        := i.fund_desc;
            v_list.branch_cd        := i.branch_cd;
            v_list.branch_name      := i.branch_name;
            v_list.ouc_id           := i.ouc_id;
            v_list.ouc_name         := i.ouc_name;
            v_list.payee_class_cd   := i.payee_class_cd;
            v_list.class_desc       := i.class_desc;
            v_list.payee_no         := i.payee_no;
            v_list.payee_name       := i.payee_last_name||' '||i.payee_first_name||' '||i.payee_middle_name;
            v_list.check_no         := i.check_no;
            v_list.check_date       := i.check_date;
            v_list.dv_amount        := i.dv_amt;
            v_list.particulars      := i.particulars;
            v_list.bank_name        := i.bank_name;
            v_list.bank_acct_no     := i.bank_acct_no;
            v_list.user_id          := i.user_id;
            v_list.last_update      := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW(v_list);
        END LOOP;
    END get_checks_paid_list;    
END GIACS241_PKG;
/


