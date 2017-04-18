DROP PROCEDURE CPI.GET_DFLT_BANK_ACCT;

CREATE OR REPLACE PROCEDURE CPI.get_dflt_bank_acct (
   p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_bank_cd        OUT   giac_dcb_users.bank_cd%TYPE,
   p_bank_acct_cd   OUT   giac_dcb_users.bank_acct_cd%TYPE,
   p_bank_name      OUT   giac_banks.bank_name%TYPE,
   p_bank_acct_no   OUT   giac_bank_accounts.bank_acct_no%TYPE,
   p_message        OUT   VARCHAR2
)
IS
BEGIN
   FOR a IN (SELECT bank_cd, bank_acct_cd
               FROM giac_dcb_users
              WHERE gibr_fund_cd = p_fund_cd
                AND gibr_branch_cd = p_branch_cd
                AND dcb_user_id = NVL(giis_users_pkg.app_user, USER))
   LOOP
      p_bank_cd := a.bank_cd;
      p_bank_acct_cd := a.bank_acct_cd;

      IF a.bank_cd IS NULL
      THEN
         FOR b IN (SELECT bank_cd, bank_acct_cd
                     FROM giac_branches
                    WHERE gfun_fund_cd = p_fund_cd
                          AND branch_cd = p_branch_cd)
         LOOP
            p_bank_cd := b.bank_cd;
            p_bank_acct_cd := b.bank_acct_cd;
         END LOOP;
      END IF;
   END LOOP;

   IF p_bank_cd IS NOT NULL
   THEN
      FOR rec1 IN (SELECT bank_name
                     FROM giac_banks
                    WHERE bank_cd = p_bank_cd)
      LOOP
         p_bank_name := rec1.bank_name;
      END LOOP;

      FOR rec2 IN (SELECT bank_acct_no
                     FROM giac_bank_accounts
                    WHERE bank_cd = p_bank_cd
                          AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         p_bank_acct_no := rec2.bank_acct_no;
      END LOOP;
   END IF;

   IF (p_bank_name IS NULL OR p_bank_acct_no IS NULL)
   THEN
      p_message :=
         'Invalid value for bank account. Please check default value in giac_branches/giac_dcb_users.';
   END IF;
END get_dflt_bank_acct;
/


