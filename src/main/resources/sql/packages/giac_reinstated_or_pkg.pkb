CREATE OR REPLACE PACKAGE BODY CPI.giac_reinstated_or_pkg
AS
/*
   Created by Anthony Santos
   April 25, 2011
   GIAC037
 */
   PROCEDURE reinstate_or (
      p_or_pref                giac_reinstated_or.or_pref%TYPE,
      p_or_no                  giac_reinstated_or.or_no%TYPE,
      p_fund_cd                giac_reinstated_or.fund_cd%TYPE,
      p_branch_cd              giac_reinstated_or.branch_cd%TYPE,
      p_reinstate_date         giac_reinstated_or.reinstate_date%TYPE,
      p_spoil_date             giac_reinstated_or.spoil_date%TYPE,
      p_prev_or_date           giac_reinstated_or.prev_or_date%TYPE,
      p_prev_tran_id           giac_reinstated_or.prev_tran_id%TYPE,
      p_module_id              giis_modules_tran.module_id%TYPE,
      p_message          OUT   VARCHAR2
   )
   IS
      v_allow_delete   VARCHAR2 (5);
   BEGIN
      IF check_user_per_iss_cd_acctg (NULL, p_branch_cd, p_module_id) = 0
      THEN
         p_message :=
              'You are not allowed to reinstate spoiled O.R. for this branch';
         RETURN;
      END IF;

      v_allow_delete := giac_validate_user_fn (NVL (giis_users_pkg.app_user, USER), 'RO', 'GIACS037');

      IF v_allow_delete = 'TRUE'
      THEN
	  
	  	 DELETE_WORKFLOW_REC('REINSTATE OR', 'GIACS037', NVL (giis_users_pkg.app_user, USER), p_or_pref ||'-'|| p_or_no);
		 
         insert_reinstated_or (p_or_pref,
                               p_or_no,
                               p_fund_cd,
                               p_branch_cd,
                               p_spoil_date,
                               p_prev_or_date,
                               p_prev_tran_id,
                               p_message
                              );

         DELETE FROM giac_spoiled_or
               WHERE or_pref = p_or_pref
                 AND or_no = p_or_no
                 AND fund_cd = p_fund_cd
                 AND branch_cd = p_branch_cd;
      ELSE
         p_message :=
               'You are not allowed to reinstate spoiled O.R. No. '
            || p_or_pref
            || '-'
            || TO_CHAR (p_or_no, '0999999999');
      END IF;
   END reinstate_or;

/*
   Created by Anthony Santos
   April 25, 2011
   GIAC037
 */
   PROCEDURE insert_reinstated_or (
      p_or_pref              giac_reinstated_or.or_pref%TYPE,
      p_or_no                giac_reinstated_or.or_no%TYPE,
      p_fund_cd              giac_reinstated_or.fund_cd%TYPE,
      p_branch_cd            giac_reinstated_or.branch_cd%TYPE,
      p_spoil_date           giac_reinstated_or.spoil_date%TYPE,
      p_prev_or_date         giac_reinstated_or.prev_or_date%TYPE,
      p_prev_tran_id         giac_reinstated_or.prev_tran_id%TYPE,
      p_message        OUT   VARCHAR2
   )
   IS
   BEGIN
      INSERT INTO giac_reinstated_or
                  (or_pref, or_no, fund_cd, branch_cd, reinstate_date,
                   spoil_date, prev_or_date, prev_tran_id,
                   user_id, last_update
                  )
           VALUES (p_or_pref, p_or_no, p_fund_cd, p_branch_cd, SYSDATE,
                   p_spoil_date, p_prev_or_date, p_prev_tran_id,
                   NVL (giis_users_pkg.app_user, USER), SYSDATE
                  );

      IF SQL%NOTFOUND
      THEN
         p_message := 'Unable to insert into Giac_Reinstated_OR. ';
      END IF;
   END insert_reinstated_or;
END giac_reinstated_or_pkg;
/


