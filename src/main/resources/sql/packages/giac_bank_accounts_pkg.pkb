CREATE OR REPLACE PACKAGE BODY CPI.giac_bank_accounts_pkg
AS
   FUNCTION get_bank_account_no(p_keyword  VARCHAR2)
      RETURN giac_bank_accounts_tab PIPELINED
   IS
      v_bank   giac_bank_accounts_type;
   BEGIN
      FOR i IN (SELECT   gbac.bank_cd, gban.bank_name, gbac.bank_acct_cd,
                                gbac.bank_acct_no, gbac.bank_acct_type, gbac.branch_cd
                    FROM giac_bank_accounts gbac, giac_banks gban
                   WHERE gbac.bank_cd = gban.bank_cd
                     AND gbac.bank_account_flag = 'A'
                     AND gbac.opening_date < SYSDATE
                     AND NVL (gbac.closing_date, SYSDATE + 1) > SYSDATE
                     AND (gbac.bank_cd LIKE '%' || p_keyword || '%'
                       OR UPPER(gban.bank_name) LIKE '%' || UPPER(p_keyword) || '%'
                       OR gbac.bank_acct_type LIKE '%' || p_keyword || '%'
                       OR gbac.bank_acct_no LIKE '%' || p_keyword || '%'
                       OR gbac.branch_cd LIKE '%' || p_keyword || '%')
                ORDER BY gban.bank_name, gbac.bank_acct_no ASC)
      LOOP
         v_bank.bank_acct_cd := i.bank_acct_cd;
         v_bank.bank_name     := i.bank_name;
         v_bank.bank_acct_no := i.bank_acct_no;
         v_bank.bank_acct_type := i.bank_acct_type;
         v_bank.branch_cd := i.branch_cd;
         v_bank.bank_cd := i.bank_cd;
         PIPE ROW (v_bank);
      END LOOP;

      RETURN;
   END get_bank_account_no;
   
   
   /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.23.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : Validate foreign key value/query lookup data.
  **                 Executes the CGFK$CHK_GCDB_GCDB_GBAC_FK Program Unit in GIACS002
  */
  PROCEDURE check_bank (
        p_bank_cd           IN  giac_bank_accounts.bank_cd%TYPE,
        p_bank_acct_cd      IN  giac_bank_accounts.bank_acct_cd%TYPE,
        p_bank_acct_no      OUT giac_bank_accounts.bank_acct_no%TYPE,
        p_bank_sname        OUT GIAC_BANKS.BANK_SNAME%TYPE
  )
   IS
        CURSOR C IS
          SELECT GBAC.BANK_ACCT_NO
                ,GBAN.BANK_SNAME
          FROM   GIAC_BANK_ACCOUNTS GBAC
                ,GIAC_BANKS GBAN
          WHERE  GBAC.BANK_CD = p_bank_cd
          AND    GBAC.BANK_ACCT_CD = p_bank_acct_cd
          AND    GBAN.BANK_CD = GBAC.BANK_CD;
          
       v_bank   giac_bank_accounts_type;
   BEGIN
        OPEN C;
        FETCH C
         INTO p_bank_acct_no  --:GCDB.DSP_BANK_ACCT_NO
              ,p_bank_sname;   --:GCDB.DSP_BANK_SNAME;--
        
        IF C%NOTFOUND THEN
          RAISE NO_DATA_FOUND;
        END IF;
        
        CLOSE C;
   EXCEPTION
        WHEN OTHERS THEN NULL;
   END check_bank;
   
   
   FUNCTION get_giacs002_bank_list(
        p_branch_cd         GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giac_disb_vouchers.user_id%TYPE,
        p_mir_branch_cd     GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE
   ) RETURN giac_bank_accounts_tab PIPELINED
   IS
        v_bank          giac_bank_accounts_type;
   BEGIN
        FOR i IN (SELECT gbac.bank_cd bank_cd /* cg$fk */, gbac.bank_acct_cd bank_acct_cd,
                         gban.bank_sname dsp_bank_sname, gbac.bank_acct_no dsp_bank_acct_no,
                         LPAD (gbac.bank_cd, 3, '*') || LPAD (gbac.bank_acct_cd, 4, '*') pk_dummy
                    FROM giac_bank_accounts gbac, giac_banks gban
                   WHERE gban.bank_cd = gbac.bank_cd
                     AND (   gbac.branch_cd =
                            DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                 gbac.branch_cd, --p_branch_cd,
                                                                 p_module_id,
                                                                 p_user_id),
                                    1, gbac.branch_cd, p_mir_branch_cd)
--                                    NULL)
                            OR gbac.branch_cd IS NULL)
                     AND gbac.bank_account_flag = 'A'                      --Edison 06.13.2012
                   ORDER BY 3)
        LOOP
            v_bank.bank_cd := i.bank_cd;
            v_bank.bank_acct_cd := i.bank_acct_cd;
            v_bank.bank_acct_no := i.dsp_bank_acct_no;
            v_bank.bank_name := i.dsp_bank_sname;
            v_bank.pk_dummy := i.pk_dummy;
        
            PIPE ROW(v_bank);
        END LOOP;
    --Modified by Edison
    --06.13.2012
    --added condition of bank_account_flag to show only the active
    --bank accounts
   END get_giacs002_bank_list;
   
   
   -- added by Kris 06.28.2013 for GIACS118
   FUNCTION get_bank_acct_no_list(
        p_branch_cd     giac_branches.branch_cd%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
   ) RETURN giac_bank_accounts_tab PIPELINED
   IS
        v_bank_acct     giac_bank_accounts_type;
   BEGIN
        FOR rec IN (SELECT a.bank_cd, a.bank_sname, b.bank_acct_no,
                           b.branch_bank, b.branch_cd
                      FROM giac_banks a, giac_bank_accounts b
                     WHERE a.bank_cd = b.bank_cd
                       AND check_user_per_iss_cd_acctg2(null, b.branch_cd, p_module_id, p_user_id) = 1
                       AND b.branch_cd = nvl(p_branch_cd, b.branch_cd)
                     ORDER BY 1)
        LOOP
            v_bank_acct.bank_cd         := rec.bank_cd;
            v_bank_acct.bank_name       := rec.bank_sname;
            v_bank_acct.bank_acct_no    := rec.bank_acct_no;
            v_bank_acct.branch_bank     := rec.branch_bank;
            v_bank_acct.branch_cd       := rec.branch_cd;
            
            PIPE ROW(v_bank_acct);
        END LOOP;  
   
   END get_bank_acct_no_list;
   
    -- marco - 08.29.2013
    FUNCTION get_giacs054_bank_lov(
        p_fund_cd       giis_funds.fund_cd%TYPE,
        p_branch_cd     giac_bank_accounts.branch_cd%TYPE
        
    )
      RETURN giac_bank_accounts_tab PIPELINED
    IS
        v_row           giac_bank_accounts_type;
    BEGIN
        FOR i IN(SELECT a.bank_cd, a.bank_acct_cd, b.bank_sname, a.bank_acct_no
                   FROM giac_bank_accounts a,
                        giac_banks b,
                        giac_chk_disbursement c,
                        giac_disb_vouchers d
                  WHERE a.bank_cd = b.bank_cd
                    AND a.bank_cd = c.bank_cd
                    AND a.bank_acct_cd = c.bank_acct_cd
                    AND c.check_stat = 1
                    AND (c.disb_mode = 'C' OR c.disb_mode IS NULL)
                    AND c.gacc_tran_id = d.gacc_tran_id
                    AND d.gibr_gfun_fund_cd = p_fund_cd
                    AND d.gibr_branch_cd = p_branch_cd
                    AND dv_flag in ('A','P') 
                    AND print_tag not in (3,6)
                  GROUP BY a.bank_cd, a.bank_acct_cd, b.bank_sname, a.bank_acct_no)
        LOOP
            v_row.bank_cd := i.bank_cd;
            v_row.bank_acct_cd := i.bank_acct_cd;
            v_row.bank_acct_no := i.bank_acct_no;
            v_row.pk_dummy := i.bank_sname;
            PIPE ROW(v_row);
        END LOOP;
    END;
   FUNCTION GET_GIACS035_BANK_ACCOUNT_LOV( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_ACCOUNT_LOV - Start
        P_SEARCH              VARCHAR2,
        P_BANK_CD             GIAC_BANK_ACCOUNTS.BANK_CD%TYPE
   ) 
      RETURN GIACS035_BANK_ACCOUNT_LOV_TAB PIPELINED
   IS
      V_LIST GIACS035_BANK_ACCOUNT_LOV_TYPE;
   BEGIN
        FOR I IN (SELECT BANK_ACCT_CD, BANK_ACCT_NO, BANK_ACCT_TYPE, BRANCH_CD 
                    FROM GIAC_BANK_ACCOUNTS
                   WHERE BANK_ACCOUNT_FLAG = 'A' 
                     AND BANK_CD = P_BANK_CD
                     AND OPENING_DATE < SYSDATE 
                     AND NVL(CLOSING_DATE,SYSDATE + 1) > SYSDATE 
                     AND BANK_ACCT_NO LIKE (P_SEARCH)
                ORDER BY 1
        )
        LOOP
            V_LIST.BANK_ACCT_CD             := I.BANK_ACCT_CD;
            V_LIST.BANK_ACCT_NO             := I.BANK_ACCT_NO; 
            V_LIST.BANK_ACCT_TYPE           := I.BANK_ACCT_TYPE; 
            V_LIST.BRANCH_CD                := I.BRANCH_CD;        
        
            PIPE ROW(V_LIST);
        END LOOP;        
        RETURN;   
   END; -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_ACCOUNT_LOV - End  
          
   --Deo [01.12.2017]: add start (SR-22489)
   FUNCTION get_bank_acct_dtls (p_keyword VARCHAR2)
      RETURN giac_bank_accounts_tab PIPELINED
   IS
      v_bank   giac_bank_accounts_type;
   BEGIN
      FOR i IN (SELECT   gbac.bank_cd, gban.bank_name, gbac.bank_acct_cd,
                         gbac.bank_acct_no, gbac.bank_acct_type,
                         gbac.branch_cd
                    FROM giac_bank_accounts gbac, giac_banks gban
                   WHERE gbac.bank_cd = gban.bank_cd
                     AND (   gbac.bank_cd LIKE '%' || p_keyword || '%'
                          OR UPPER (gban.bank_name) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR gbac.bank_acct_type LIKE '%' || p_keyword || '%'
                          OR gbac.bank_acct_no LIKE '%' || p_keyword || '%'
                          OR gbac.branch_cd LIKE '%' || p_keyword || '%'
                         )
                ORDER BY gban.bank_name, gbac.bank_acct_no ASC)
      LOOP
         v_bank.bank_acct_cd := i.bank_acct_cd;
         v_bank.bank_name := i.bank_name;
         v_bank.bank_acct_no := i.bank_acct_no;
         v_bank.bank_acct_type := i.bank_acct_type;
         v_bank.branch_cd := i.branch_cd;
         v_bank.bank_cd := i.bank_cd;
         PIPE ROW (v_bank);
      END LOOP;

      RETURN;
   END get_bank_acct_dtls;
   --Deo [01.12.2017]: add ends (SR-22489)
END;
/


