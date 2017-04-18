CREATE OR REPLACE PACKAGE BODY CPI.giac_check_status_pkg
AS
   /*
   **  Created by        : Steven Ramirez
   **  Date Created      : 04.25.2013
   **  Reference By      : GIACS047 - UPDATE CHECK STATUS
   */
   FUNCTION get_bank_info (p_branch_cd giac_bank_accounts.branch_cd%TYPE)
      RETURN giac_bank_tab PIPELINED
   AS
      v_rec   giac_bank_type;
   BEGIN
      IF p_branch_cd IS NULL
      THEN
         RETURN;
      ELSE
         FOR i IN (SELECT   a.bank_name, a.bank_cd, b.bank_acct_no,
                            b.bank_acct_cd
                       FROM giac_banks a, giac_bank_accounts b
                      WHERE a.bank_cd = b.bank_cd
                        AND b.bank_account_flag = 'A'
                        --added by steven 05.09.2014
                        AND (b.branch_cd = p_branch_cd OR b.branch_cd IS NULL
                            )                     --added by steven 05.02.2014
                   ORDER BY TO_NUMBER (bank_acct_cd))
         LOOP
            v_rec.bank_name := i.bank_name;
            v_rec.bank_cd := i.bank_cd;
            v_rec.bank_acct_no := i.bank_acct_no;
            v_rec.bank_acct_cd := i.bank_acct_cd;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END;

   FUNCTION get_chk_disbursement (
      p_bank_cd        giac_banks.bank_cd%TYPE,
      p_bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE,
      p_branch_cd      VARCHAR2,        -- shan 11.10.2014
      p_from_date      DATE,
      p_to_date        DATE,
      p_status         NUMBER
   )
      RETURN giac_disbursement_tab PIPELINED
   IS
      v_rec   giac_disbursement_type;

      CURSOR c1
      IS
         SELECT *
           FROM giac_chk_disbursement gcd
          WHERE check_stat <> 3
            AND TRUNC (check_date) <= p_to_date
            AND bank_cd = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd;

      CURSOR c2
      IS
         SELECT *
           FROM giac_chk_disbursement gcd
          WHERE check_stat <> 3
            AND bank_cd = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd
            AND EXISTS (
                   SELECT 1
                     FROM giac_chk_release_info
                    WHERE gacc_tran_id = gcd.gacc_tran_id
                      AND item_no = gcd.item_no
                      AND (    TRUNC (check_release_date) >= p_from_date
                           AND TRUNC (check_release_date) <= p_to_date
                          ));

      CURSOR c3
      IS
         SELECT *
           FROM giac_chk_disbursement gcd
          WHERE check_stat <> 3
            AND TRUNC (check_date) <= p_to_date
            AND bank_cd = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd
            AND (   NOT EXISTS (
                       SELECT 1
                         FROM giac_chk_release_info
                        WHERE gacc_tran_id = gcd.gacc_tran_id
                          AND item_no = gcd.item_no)
                 OR EXISTS (
                       SELECT 1
                         FROM giac_chk_release_info
                        WHERE gacc_tran_id = gcd.gacc_tran_id
                          AND item_no = gcd.item_no
                          AND TRUNC (check_release_date) > p_to_date)
                );

      CURSOR c4
      IS
         SELECT *
           FROM giac_chk_disbursement gcd
          WHERE check_stat <> 3
            AND TRUNC (check_date) <= p_to_date
            AND bank_cd = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd
            AND EXISTS (
                   SELECT 1
                     FROM giac_chk_release_info
                    WHERE gacc_tran_id = gcd.gacc_tran_id
                      AND item_no = gcd.item_no
                      AND (   (    TRUNC (check_release_date) <= p_to_date
                               AND clearing_date IS NULL
                              )
                           OR (    TRUNC (clearing_date) > p_to_date
                               AND TRUNC (check_release_date) <= p_to_date
                              )
                          ));

      CURSOR c5
      IS
         SELECT *
           FROM giac_chk_disbursement gcd
          WHERE check_stat <> 3
            AND bank_cd = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd
            AND TRUNC (check_date) <= p_to_date
            AND EXISTS (
                   SELECT 1
                     FROM giac_chk_release_info
                    WHERE gacc_tran_id = gcd.gacc_tran_id
                      AND item_no = gcd.item_no
                      AND (    TRUNC (clearing_date) <= p_to_date
                           AND TRUNC (clearing_date) >= p_from_date
                          ));
   BEGIN
      IF p_status = 1
      THEN                                                            /*ALL*/
         FOR i IN c1
         LOOP
            v_rec.gacc_tran_id := i.gacc_tran_id;
            v_rec.item_no := i.item_no;
            v_rec.bank_cd := i.bank_cd;
            v_rec.bank_acct_cd := i.bank_acct_cd;
            v_rec.check_pref_suf := i.check_pref_suf;
            v_rec.check_no := i.check_no;
            v_rec.check_date := TO_CHAR (i.check_date, 'MM-DD-YYYY');
            v_rec.payee := i.payee;
            v_rec.amount := i.amount;
            v_rec.check_release_date := NULL;
            v_rec.clearing_date := NULL;
            v_rec.gibr_branch_cd := NULL;
            v_rec.branch_name := NULL;
            giac_check_status_pkg.get_branch (i.gacc_tran_id,
                                              v_rec.gibr_branch_cd,
                                              v_rec.branch_name
                                             );

            FOR a IN (SELECT check_release_date, clearing_date
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_rec.check_release_date := TO_CHAR (a.check_release_date, 'MM-DD-YYYY');
               v_rec.clearing_date := TO_CHAR (a.clearing_date, 'MM-DD-YYYY');
            END LOOP;
            
            IF UPPER(p_branch_cd) = v_rec.gibr_branch_cd THEN
                PIPE ROW (v_rec);
            END IF;
         END LOOP;
      ELSIF p_status = 2
      THEN                                                        /*RELEASED*/
         FOR i IN c2
         LOOP
            v_rec.gacc_tran_id := i.gacc_tran_id;
            v_rec.item_no := i.item_no;
            v_rec.bank_cd := i.bank_cd;
            v_rec.bank_acct_cd := i.bank_acct_cd;
            v_rec.check_pref_suf := i.check_pref_suf;
            v_rec.check_no := i.check_no;
            v_rec.check_date := TO_CHAR (i.check_date, 'MM-DD-YYYY');
            v_rec.payee := i.payee;
            v_rec.amount := i.amount;
            v_rec.check_release_date := NULL;
            v_rec.clearing_date := NULL;
            v_rec.gibr_branch_cd := NULL;
            v_rec.branch_name := NULL;
            giac_check_status_pkg.get_branch (i.gacc_tran_id,
                                              v_rec.gibr_branch_cd,
                                              v_rec.branch_name
                                             );

            FOR a IN (SELECT check_release_date, clearing_date
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_rec.check_release_date := TO_CHAR (a.check_release_date, 'MM-DD-YYYY');
               v_rec.clearing_date := TO_CHAR (a.clearing_date, 'MM-DD-YYYY');
            END LOOP;

            IF UPPER(p_branch_cd) = v_rec.gibr_branch_cd THEN
                PIPE ROW (v_rec);
            END IF;
         END LOOP;
      ELSIF p_status = 3
      THEN                                                      /*UNRELEASED*/
         FOR i IN c3
         LOOP
            v_rec.gacc_tran_id := i.gacc_tran_id;
            v_rec.item_no := i.item_no;
            v_rec.bank_cd := i.bank_cd;
            v_rec.bank_acct_cd := i.bank_acct_cd;
            v_rec.check_pref_suf := i.check_pref_suf;
            v_rec.check_no := i.check_no;
            v_rec.check_date := TO_CHAR (i.check_date, 'MM-DD-YYYY');
            v_rec.payee := i.payee;
            v_rec.amount := i.amount;
            v_rec.check_release_date := NULL;
            v_rec.clearing_date := NULL;
            v_rec.gibr_branch_cd := NULL;
            v_rec.branch_name := NULL;
            giac_check_status_pkg.get_branch (i.gacc_tran_id,
                                              v_rec.gibr_branch_cd,
                                              v_rec.branch_name
                                             );

            FOR a IN (SELECT check_release_date, clearing_date
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_rec.check_release_date := TO_CHAR (a.check_release_date, 'MM-DD-YYYY');
               v_rec.clearing_date := TO_CHAR (a.clearing_date, 'MM-DD-YYYY');
            END LOOP;

            IF UPPER(p_branch_cd) = v_rec.gibr_branch_cd THEN
                PIPE ROW (v_rec);
            END IF;
         END LOOP;
      ELSIF p_status = 4
      THEN                                                     /*OUTSTANDING*/
         FOR i IN c4
         LOOP
            v_rec.gacc_tran_id := i.gacc_tran_id;
            v_rec.item_no := i.item_no;
            v_rec.bank_cd := i.bank_cd;
            v_rec.bank_acct_cd := i.bank_acct_cd;
            v_rec.check_pref_suf := i.check_pref_suf;
            v_rec.check_no := i.check_no;
            v_rec.check_date := TO_CHAR (i.check_date, 'MM-DD-YYYY');
            v_rec.payee := i.payee;
            v_rec.amount := i.amount;
            v_rec.check_release_date := NULL;
            v_rec.clearing_date := NULL;
            v_rec.gibr_branch_cd := NULL;
            v_rec.branch_name := NULL;
            giac_check_status_pkg.get_branch (i.gacc_tran_id,
                                              v_rec.gibr_branch_cd,
                                              v_rec.branch_name
                                             );

            FOR a IN (SELECT check_release_date, clearing_date
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_rec.check_release_date := TO_CHAR (a.check_release_date, 'MM-DD-YYYY');
               v_rec.clearing_date := TO_CHAR (a.clearing_date, 'MM-DD-YYYY');
            END LOOP;

            IF UPPER(p_branch_cd) = v_rec.gibr_branch_cd THEN
                PIPE ROW (v_rec);
            END IF;
         END LOOP;
      ELSIF p_status = 5
      THEN                                                         /*CLEARED*/
         FOR i IN c5
         LOOP
            v_rec.gacc_tran_id := i.gacc_tran_id;
            v_rec.item_no := i.item_no;
            v_rec.bank_cd := i.bank_cd;
            v_rec.bank_acct_cd := i.bank_acct_cd;
            v_rec.check_pref_suf := i.check_pref_suf;
            v_rec.check_no := i.check_no;
            v_rec.check_date := TO_CHAR (i.check_date, 'MM-DD-YYYY');
            v_rec.payee := i.payee;
            v_rec.amount := i.amount;
            v_rec.check_release_date := NULL;
            v_rec.clearing_date := NULL;
            v_rec.gibr_branch_cd := NULL;
            v_rec.branch_name := NULL;
            giac_check_status_pkg.get_branch (i.gacc_tran_id,
                                              v_rec.gibr_branch_cd,
                                              v_rec.branch_name
                                             );

            FOR a IN (SELECT check_release_date, clearing_date
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_rec.check_release_date := TO_CHAR (a.check_release_date, 'MM-DD-YYYY');
               v_rec.clearing_date := TO_CHAR (a.clearing_date, 'MM-DD-YYYY');
            END LOOP;

            IF UPPER(p_branch_cd) = v_rec.gibr_branch_cd THEN
                PIPE ROW (v_rec);
            END IF;
         END LOOP;
      END IF;
   END;

   PROCEDURE get_branch (
      p_tran_id       IN       giac_chk_disbursement.gacc_tran_id%TYPE,
      p_branch_cd     OUT      VARCHAR2,
      p_branch_name   OUT      VARCHAR2
   )
   IS
   BEGIN
      FOR a IN (SELECT gibr_branch_cd
                  FROM giac_disb_vouchers
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         p_branch_cd := a.gibr_branch_cd;

         FOR i IN (SELECT branch_name
                     FROM giac_branches
                    WHERE branch_cd = a.gibr_branch_cd)
         LOOP
            p_branch_name := i.branch_name;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE update_date (
      p_clearing_date        IN   giac_chk_release_info.clearing_date%TYPE,
      p_check_release_date   IN   giac_chk_release_info.check_release_date%TYPE,
      p_gacc_tran_id         IN   giac_chk_release_info.gacc_tran_id%TYPE,
      p_user_id              IN   giis_users.user_id%TYPE
   )
   IS
      v_clearing_date   DATE;
   BEGIN
      FOR a IN (SELECT clearing_date
                  FROM giac_chk_release_info
                 WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         v_clearing_date := a.clearing_date;
         EXIT;
      END LOOP;

      IF v_clearing_date IS NULL
      THEN
         IF p_check_release_date IS NOT NULL
         THEN
            IF p_clearing_date IS NOT NULL
            THEN
               UPDATE giac_chk_release_info
                  SET clearing_date = p_clearing_date,
                      user_id = p_user_id,
                      last_update = SYSDATE
                WHERE gacc_tran_id = p_gacc_tran_id;
            ELSE
               raise_application_error
                                  (-20001,
                                   'Geniisys Exception#I#No changes to save.'
                                  );
            END IF;
         ELSE
            raise_application_error
                         (-20001,
                          'Geniisys Exception#E#Cannot update clearing date.'
                         );
         END IF;
      ELSE
         raise_application_error (-20001,
                                  'Geniisys Exception#I#No changes to save.'
                                 );
      END IF;
   END;
END;
/


