CREATE OR REPLACE PACKAGE BODY validate_recapsvi_pkg
AS
/* Created by   : Benjo Brito
** Date Created : 06.01.2015
** Remarks      : Additional package; validation to address GENQA AFPGEN_IMPLEM SR 4150
*/
   PROCEDURE check_records_recapsvi (
      p_user_id     IN       giis_users.user_id%TYPE,
      p_from_date   IN       VARCHAR2,
      p_to_date     IN       VARCHAR2,
      p_error       OUT      VARCHAR2,
      p_message     OUT      VARCHAR2
   )
   IS
      v_cnt         NUMBER := 0;
      v_from_date   DATE   := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_to_date     DATE   := TO_DATE (p_to_date, 'MM-DD-RRRR');
   BEGIN
      SELECT COUNT (*)
        INTO v_cnt
        FROM (SELECT   b.policy_id
                  FROM gipi_polbasic a, gipi_item b
                 WHERE 1 = 1
                   AND a.policy_id = b.policy_id
                   AND a.iss_cd != giisp.v ('ISS_CD_RI')
                   AND a.cred_branch != giisp.v ('ISS_CD_RI')
                   AND EXISTS (
                          SELECT 'X'
                            FROM TABLE
                                    (security_access.get_branch_line
                                                                  ('UW',
                                                                   'GIPIS203',
                                                                   p_user_id
                                                                  )
                                    )
                           WHERE branch_cd = NVL (a.cred_branch, a.iss_cd)
                             AND line_cd = a.line_cd)
                   AND (   (    TRUNC (a.acct_ent_date) >= v_from_date
                            AND TRUNC (a.acct_ent_date) <= v_to_date
                           )
                        OR (    TRUNC (NVL (a.spld_acct_ent_date,
                                            a.acct_ent_date
                                           )
                                      ) >= v_from_date
                            AND TRUNC (NVL (a.spld_acct_ent_date,
                                            a.acct_ent_date
                                           )
                                      ) <= v_to_date
                           )
                       )
                   AND NVL (a.endt_type, 'A') = 'A'
                   AND b.prem_amt IS NULL
              GROUP BY b.policy_id);

      IF v_cnt = 0
      THEN
         p_error := 'N';
      ELSE
         p_error := 'Y';
         p_message :=
            'There is/are policy/ies with null premium amount in gipi_item. Cannot proceed extraction.';
      END IF;
   END check_records_recapsvi;
END validate_recapsvi_pkg;
/

CREATE OR REPLACE PUBLIC SYNONYM validate_recapsvi_pkg FOR cpi.validate_recapsvi_pkg;