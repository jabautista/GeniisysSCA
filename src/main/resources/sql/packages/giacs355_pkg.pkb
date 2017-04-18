CREATE OR REPLACE PACKAGE BODY CPI.giacs355_pkg
AS
   FUNCTION get_rec_list (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE,
      p_or_type         giac_or_pref.or_type%TYPE,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2
   )  RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.fund_cd, a.branch_cd, a.or_pref_suf, a.or_type,
                       a.remarks, a.user_id, a.last_update
                  FROM giac_or_pref a
                 WHERE UPPER(a.fund_cd) LIKE UPPER (NVL (p_fund_cd, '%'))
                   AND UPPER (a.branch_cd) LIKE UPPER (NVL (p_branch_cd, '%'))
                   AND UPPER (a.or_pref_suf) LIKE UPPER (NVL (p_or_pref_suf, '%'))
                   AND UPPER (a.or_type) LIKE UPPER (NVL (p_or_type, '%'))
                   AND Check_user_per_iss_cd_acctg2(NULL, a.branch_cd, p_module_id, p_user_id) = 1
                 ORDER BY a.fund_cd, a.branch_cd, A.OR_PREF_SUF
                   )                   
      LOOP
         v_rec.fund_cd := i.fund_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.or_pref_suf := i.or_pref_suf;
         v_rec.or_type := i.or_type;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         BEGIN
             SELECT branch_name
               INTO v_rec.branch_name
               FROM giac_branches
              WHERE branch_cd = i.branch_cd
                AND gfun_fund_cd = i.fund_cd;
         EXCEPTION
            WHEN no_data_found THEN
                v_rec.branch_name := NULL;
         END;
         
         BEGIN
             SELECT rv_meaning
               INTO v_rec.or_type_mean
               FROM cg_ref_codes
              WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                AND (i.or_type IN (rv_low_value, rv_abbreviation)
                            OR i.or_type BETWEEN  RV_LOW_VALUE AND RV_HIGH_VALUE);
         EXCEPTION
            WHEN no_data_found THEN
                v_rec.or_type_mean := NULL;
         END;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_or_pref%ROWTYPE)
   IS
        v_fund_cd       GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
   BEGIN
   
      IF p_rec.fund_cd IS NULL THEN
        v_fund_cd := giacp.v('FUND_CD');
      ELSE
        v_fund_Cd := p_rec.fund_Cd;        
      END IF;
   
      MERGE INTO giac_or_pref
         USING DUAL
         ON (fund_cd = v_fund_cd
                AND branch_cd = p_rec.branch_cd
                AND or_pref_suf = p_rec.or_pref_suf)
         WHEN NOT MATCHED THEN
            INSERT (fund_cd, branch_cd, or_pref_suf, or_type, remarks, user_id, last_update)
            VALUES (v_fund_cd, p_rec.branch_cd, p_rec.or_pref_suf, p_rec.or_type, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET or_type = p_rec.or_type,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
        p_fund_cd       giac_or_pref.fund_cd%TYPE,
        p_branch_cd     giac_or_pref.branch_cd%TYPE,
        p_or_pref_suf   giac_or_pref.or_pref_suf%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_or_pref
            WHERE fund_cd = p_fund_cd
              AND branch_cd = p_branch_cd
              AND or_pref_suf = p_or_pref_suf;
   END;

   PROCEDURE val_del_rec (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      NULL;
   END;

   PROCEDURE val_add_rec (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE
   )
   AS
      v_exists      VARCHAR2 (1);
      v_fund_cd     GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
   BEGIN
   
      IF p_fund_cd IS NULL THEN
        v_fund_cd := giacp.v('FUND_CD');
      ELSE
        v_fund_cd := p_fund_cd;        
      END IF;
      
      FOR i IN (SELECT '1'
                  FROM giac_or_pref a
                 WHERE a.fund_cd = v_fund_cd
                   AND a.branch_cd = p_branch_cd
                   AND a.or_pref_suf = p_or_pref_suf)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Row already exists with same fund_cd, branch_cd, and or_pref_suf.'
                                 );
      END IF;
   END;
END;
/


