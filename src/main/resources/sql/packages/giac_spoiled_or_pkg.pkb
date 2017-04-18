CREATE OR REPLACE PACKAGE BODY CPI.giac_spoiled_or_pkg
AS
   FUNCTION get_giac_spoiled_or_listing (
      p_fund_cd     giac_spoiled_or.fund_cd%TYPE,
      p_branch_cd   giac_spoiled_or.fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_or_pref     giac_spoiled_or.or_pref%TYPE,
      p_or_no       giac_spoiled_or.or_no%TYPE,
      p_or_date     giac_spoiled_or.or_date%TYPE
   )
      RETURN giac_spoiled_or_tab PIPELINED
   IS
      v_spoiled_or   giac_spoiled_or_type;
   BEGIN
      FOR i IN
         (SELECT   a.or_pref, a.or_no, a.fund_cd, a.branch_cd, a.spoil_date,
                   a.spoil_tag, a.tran_id, a.or_date, a.remarks,
                   a.spoil_tag || ' - ' || b.rv_meaning spoil_tag_desc,
                   a.or_pref || '-' || a.or_no or_pref_no
              FROM giac_spoiled_or a, cg_ref_codes b
             WHERE a.fund_cd = p_fund_cd
               AND a.branch_cd = p_branch_cd
               AND a.branch_cd =
                      DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                            a.branch_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ),
                              1, a.branch_cd,
                              NULL
                             )
               AND b.rv_domain = 'GIAC_SPOILED_OR.SPOIL_TAG'
               AND b.rv_low_value = a.spoil_tag
               AND a.or_no = NVL (p_or_no, a.or_no)
               AND a.or_pref = NVL (p_or_pref, a.or_pref)
               AND a.or_date = NVL (p_or_date, a.or_date)
          ORDER BY a.or_pref, a.or_no, a.spoil_date)
      LOOP
         v_spoiled_or.or_pref := i.or_pref;
         v_spoiled_or.or_no := i.or_no;
         v_spoiled_or.fund_cd := i.fund_cd;
         v_spoiled_or.branch_cd := i.branch_cd;
         v_spoiled_or.spoil_date := i.spoil_date;
         v_spoiled_or.spoil_tag := i.spoil_tag;
         v_spoiled_or.tran_id := i.tran_id;
         v_spoiled_or.or_date := i.or_date;
         v_spoiled_or.remarks := i.remarks;
         v_spoiled_or.spoil_tag_desc := i.spoil_tag_desc;
         v_spoiled_or.or_pref_no := i.or_pref_no;
         v_spoiled_or.orig_or_pref := i.or_pref;
         v_spoiled_or.orig_or_no := i.or_no;
         PIPE ROW (v_spoiled_or);
      END LOOP;

      RETURN;
   END get_giac_spoiled_or_listing;

   PROCEDURE save_spoiled_or_dtls (
      p_or_pref       giac_spoiled_or.or_pref%TYPE,
      p_or_no         giac_spoiled_or.or_no%TYPE,
      p_old_or_pref   giac_spoiled_or.or_pref%TYPE,
      p_old_or_no     giac_spoiled_or.or_no%TYPE,
      p_fund_cd       giac_spoiled_or.fund_cd%TYPE,
      p_branch_cd     giac_spoiled_or.branch_cd%TYPE,
      p_spoil_date    giac_spoiled_or.spoil_date%TYPE,
      p_spoil_tag     giac_spoiled_or.spoil_tag%TYPE,
      p_or_date       giac_spoiled_or.or_date%TYPE
   )
   IS
      v_temp   VARCHAR2 (5);
   BEGIN
      /* BEGIN
          SELECT 1
            INTO v_temp
            FROM giac_spoiled_or
           WHERE or_pref = p_old_or_pref
             AND or_no = p_old_or_no
             AND fund_cd = p_fund_cd
             AND branch_cd = p_branch_cd;

          IF SQL%FOUND
          THEN
             UPDATE giac_spoiled_or
                SET or_pref = p_or_pref,
                    or_no = p_or_no,
                    spoil_date = p_spoil_date,
                    spoil_tag = p_spoil_tag,
                    or_date = p_or_date
              WHERE or_pref = p_old_or_pref
                AND or_no = p_old_or_no
                AND fund_cd = p_fund_cd
                AND branch_cd = p_branch_cd;
          END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             INSERT INTO giac_spoiled_or
                         (or_pref, or_no, fund_cd, branch_cd,
                          spoil_date, spoil_tag, or_date,
                          user_id, last_update
                         )
                  VALUES (p_or_pref, p_or_no, p_fund_cd, p_branch_cd,
                          p_spoil_date, p_spoil_tag, p_or_date,
                          NVL (giis_users_pkg.app_user, USER), SYSDATE
                         );
       END;*/
      UPDATE giac_spoiled_or
         SET or_pref = p_or_pref,
             or_no = p_or_no,
             spoil_date = p_spoil_date,
             spoil_tag = p_spoil_tag,
             or_date = p_or_date
       WHERE or_pref = NVL (p_old_or_pref, p_or_pref)
         AND or_no = NVL (p_old_or_no, p_or_no)
         AND fund_cd = p_fund_cd
         AND branch_cd = p_branch_cd;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO giac_spoiled_or
                     (or_pref, or_no, fund_cd, branch_cd,
                      spoil_date, spoil_tag, or_date,
                      user_id, last_update
                     )
              VALUES (p_or_pref, p_or_no, p_fund_cd, p_branch_cd,
                      p_spoil_date, p_spoil_tag, p_or_date,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      END IF;
   END save_spoiled_or_dtls;

   FUNCTION validate_or_no (
      p_or_pref     giac_spoiled_or.or_pref%TYPE,
      p_or_no       giac_spoiled_or.or_no%TYPE,
      p_fund_cd     giac_spoiled_or.fund_cd%TYPE,
      p_branch_cd   giac_spoiled_or.branch_cd%TYPE
   )
      RETURN VARCHAR2
   IS
    V_EXIST1		VARCHAR2(1);
    V_EXIST2		VARCHAR2(1);
	V_MESSAGE  		VARCHAR2(5000);
	
   	 CURSOR C1 is SELECT 1 ONE
                    FROM GIAC_ORDER_OF_PAYTS
                   WHERE GIBR_GFUN_FUND_CD	= p_fund_cd
                     AND GIBR_BRANCH_CD    	= p_branch_cd
                     AND OR_PREF_SUF	    = p_or_pref
                     AND OR_NO             	= p_or_no;

    CURSOR C2 is SELECT 1 TWO
                    FROM GIAC_SPOILED_OR
                   WHERE FUND_CD      = p_fund_cd
                     AND BRANCH_CD    = p_branch_cd
                     AND OR_PREF      = p_or_pref
                     AND OR_NO        = p_or_no;
   BEGIN
      OPEN C1;
      FETCH C1 INTO V_EXIST1;
	  IF  C1%FOUND THEN
	  	  V_MESSAGE:= p_or_pref ||'-'||to_char(p_or_no,'0999999999') ||' has already been printed.';
	  END IF;
	  
	  OPEN C2;
      FETCH C2 INTO V_EXIST2;
	  IF  C2%FOUND THEN
	  	  V_MESSAGE:= p_or_pref ||'-'||to_char(p_or_no,'0999999999') ||' has already been spoiled.';
	  END IF;
	  
	  RETURN V_MESSAGE;
   END;
END giac_spoiled_or_pkg;
/


