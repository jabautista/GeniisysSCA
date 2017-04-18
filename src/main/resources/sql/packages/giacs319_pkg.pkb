CREATE OR REPLACE PACKAGE BODY CPI.GIACS319_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.06.2013
     ** Referenced By:  GIACS319 - Maintain DCB Users
     **/
    
    FUNCTION get_company_lov(
        p_user_id       VARCHAR2
    ) RETURN company_tab PIPELINED
    AS
        lov     company_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_BRANCHES
                    WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2(null, branch_cd, 'GIACS319', p_user_id), 1, branch_cd, NULL) )
        LOOP
            lov.gfun_fund_cd    := i.gfun_fund_cd;
            lov.branch_cd       := i.branch_cd;
            lov.branch_name     := i.branch_name;
            
            BEGIN
                SELECT FUND_DESC
                  INTO lov.fund_desc
                  FROM GIIS_FUNDS
                 WHERE  FUND_CD = i.GFUN_FUND_CD;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    lov.fund_desc   := null;
            END;
            PIPE ROW(lov);
        END LOOP;
        
    END get_company_lov;
    
    
    FUNCTION get_dcb_user_lov   
        RETURN dcb_user_tab PIPELINED
    AS
        lov     dcb_user_type;
    BEGIN
        FOR a IN (SELECT user_id, user_name
                    FROM giac_users
                ORDER BY user_name)
        LOOP
            lov.dcb_user_id        := a.user_id;
            lov.dcb_user_name      := a.user_name;
         
            PIPE ROW (lov);
        END LOOP;
    END get_dcb_user_lov;
    
    
    
    FUNCTION get_bank_lov   
        RETURN bank_tab PIPELINED
    AS
        lov     bank_type;
    BEGIN
        FOR i IN (SELECT DISTINCT gbac.bank_cd, gban.bank_name 
                    FROM giac_bank_accounts gbac, 
                         giac_banks gban 
                   WHERE gbac.bank_cd = gban.bank_cd 
                     AND gbac.bank_account_flag = 'A' 
                     AND gbac.opening_date < SYSDATE
                     AND NVL(gbac.closing_date,SYSDATE+1) > SYSDATE
                   ORDER BY 2)
        LOOP
            lov.bank_cd     := i.bank_cd;
            lov.bank_name   := i.bank_name;
            
            PIPE ROW(lov);        
        END LOOP;        
    END get_bank_lov;
     
     
    FUNCTION get_bank_acct_lov (
        p_bank_cd       GIAC_BANK_ACCOUNTS.BANK_CD%type
    ) RETURN bank_acct_tab PIPELINED
    AS
        lov     bank_acct_type;
    BEGIN
        FOR i IN (SELECT gbac.bank_acct_cd, gbac.bank_acct_no, 
                         gbac.bank_acct_type, gbac.branch_cd 
                    FROM giac_bank_accounts gbac 
                   WHERE gbac.bank_account_flag = 'A' 
                     AND gbac.bank_cd = p_bank_cd 
                     AND gbac.opening_date < SYSDATE 
                     AND NVL(gbac.closing_date,SYSDATE + 1) > SYSDATE 
                   ORDER BY 1)
        LOOP
            lov.bank_acct_cd    := i.bank_acct_cd;
            lov.bank_acct_no    := i.bank_acct_no;
            lov.bank_acct_type  := i.bank_acct_type;
            lov.branch_cd       := i.branch_cd;
            
            PIPE ROW(lov);
        END LOOP;
    END get_bank_acct_lov; 
    
    
    FUNCTION get_rec_list(
        p_gfun_fund_cd    GIAC_BRANCHES.GFUN_FUND_CD%type,
        p_branch_cd       GIAC_BRANCHES.BRANCH_CD%type
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR i IN (SELECT a.*, DECODE(valid_tag, 'Y', 'Yes', 'No') active
                    FROM GIAC_DCB_USERS a
                   WHERE gibr_fund_cd = p_gfun_fund_cd
                     AND gibr_branch_cd = p_branch_cd
                   ORDER BY cashier_cd)
        LOOP
            rec.gibr_fund_cd        := i.gibr_fund_cd;
            rec.gibr_branch_cd      := i.gibr_branch_cd;
            rec.cashier_cd          := i.cashier_cd;
            rec.dcb_user_id         := i.dcb_user_id;
            rec.print_name          := i.print_name;
            rec.effectivity_dt      := i.effectivity_dt;
            rec.expiry_dt           := i.expiry_dt;
            rec.valid_tag           := i.active;
            rec.bank_cd             := i.bank_cd;
            rec.bank_acct_cd        := i.bank_acct_cd;
            rec.remarks             := i.remarks;
            rec.user_id             := i.user_id;
            rec.last_update         := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
            
            rec.bank_name           := null;
            rec.bank_acct_no        := null;
            
            BEGIN
                SELECT USER_NAME
                  INTO rec.dcb_user_name
                  FROM GIAC_USERS 
                 WHERE USER_ID = i.DCB_USER_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.dcb_user_name   := null;
            END;
            
            FOR c IN (SELECT bank_name
                        FROM giac_banks
                      WHERE bank_cd = i.bank_cd) 
            LOOP
                rec.bank_name := c.bank_name;
                EXIT;
            END LOOP;

            FOR d IN (SELECT bank_acct_no
                        FROM giac_bank_accounts
                       WHERE bank_cd = i.bank_cd
                         AND bank_acct_cd = i.bank_acct_cd) 
            LOOP
                rec.bank_acct_no := d.bank_acct_no;
                EXIT;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_rec_list;
    
    PROCEDURE set_rec (p_rec GIAC_DCB_USERS%ROWTYPE)
    IS
    BEGIN
        MERGE INTO GIAC_DCB_USERS
        USING DUAL
           ON (gibr_fund_cd = p_rec.gibr_fund_cd
               AND gibr_branch_cd = p_rec.gibr_branch_cd
               AND cashier_cd = p_rec.cashier_cd
               AND dcb_user_id = p_rec.dcb_user_id)
         WHEN NOT MATCHED THEN
            INSERT (gibr_fund_cd, gibr_branch_cd, cashier_cd, dcb_user_id, print_name, effectivity_dt, 
                    expiry_dt, valid_tag, bank_cd, bank_acct_cd, remarks, user_id, last_update)
            VALUES (p_rec.gibr_fund_cd, p_rec.gibr_branch_cd, p_rec.cashier_cd, p_rec.dcb_user_id, p_rec.print_name, p_rec.effectivity_dt, 
                    p_rec.expiry_dt, p_rec.valid_tag, p_rec.bank_cd, p_rec.bank_acct_cd, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET  print_name          = p_rec.print_name,
                    effectivity_dt      = p_rec.effectivity_dt,
                    expiry_dt           = p_rec.expiry_dt,
                    valid_tag           = p_rec.valid_tag,
                    bank_cd             = p_rec.bank_cd,
                    bank_acct_cd        = p_rec.bank_acct_cd,
                    remarks             = p_rec.remarks,
                    last_update = SYSDATE
            ;
    END;

    PROCEDURE del_rec (
        p_gibr_fund_cd      GIAC_DCB_USERS.GIBR_FUND_CD%type,
        p_gibr_branch_cd    GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        p_cashier_cd        GIAC_DCB_USERS.CASHIER_CD%type,
        p_dcb_user_id       GIAC_DCB_USERS.DCB_USER_ID%type
    )
    AS
    BEGIN
        DELETE FROM GIAC_DCB_USERS
         WHERE gibr_fund_cd = p_gibr_fund_cd
           AND gibr_branch_cd = p_gibr_branch_cd
           AND cashier_cd = p_cashier_cd
           AND dcb_user_id = p_dcb_user_id;
    END;


    PROCEDURE val_del_rec (
        p_gibr_fund_cd      GIAC_DCB_USERS.GIBR_FUND_CD%type,
        p_gibr_branch_cd    GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        p_cashier_cd        GIAC_DCB_USERS.CASHIER_CD%type,
        p_dcb_user_id       GIAC_DCB_USERS.DCB_USER_ID%type
    )
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
        NULL;
    END;

    PROCEDURE val_add_rec (
        p_gibr_fund_cd      GIAC_DCB_USERS.GIBR_FUND_CD%type,
        p_gibr_branch_cd    GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        p_cashier_cd        GIAC_DCB_USERS.CASHIER_CD%type,
        p_dcb_user_id       GIAC_DCB_USERS.DCB_USER_ID%type
    )
    AS
        v_id       VARCHAR2(1) := 'N';
        v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIAC_USERS
                   WHERE user_id = p_dcb_user_id)
        LOOP
            v_id := 'Y';
            EXIT;        
        END LOOP;
        
        IF v_id != 'Y' THEN  -- to prevent integrity constraint (GDCU_GUSE_FK) error
            raise_application_error (-20001,
                                  'Geniisys Exception#E#This DCB User ID does not exist.'
                                 );
        END IF;
        
        FOR i IN (SELECT '1'
                  FROM GIAC_DCB_USERS
                 WHERE gibr_fund_cd = p_gibr_fund_cd
                   AND gibr_branch_cd = p_gibr_branch_cd
                   AND cashier_cd = p_cashier_cd)
                   --AND dcb_user_id = p_dcb_user_id) --koks 9.1.15 
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same cashier_cd and/or dcb_user_id.'
                                 );
        END IF;
    END;

END GIACS319_PKG;
/