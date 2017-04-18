DROP PROCEDURE CPI.SPOIL_OR;

CREATE OR REPLACE PROCEDURE CPI.spoil_or (
   p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
   p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
   p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
   p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
   p_or_date                      varchar2,
   p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
   p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE,
   p_message             OUT      VARCHAR2
)
IS
   v_tran_flag   giac_acctrans.tran_flag%TYPE;
BEGIN
   FOR t IN (SELECT tran_flag
               FROM giac_acctrans
              WHERE tran_id = p_gacc_tran_id)
   LOOP
      v_tran_flag := t.tran_flag;
   END LOOP;

   IF v_tran_flag IN ('O', 'C')
   THEN
      DECLARE
         v_dcb_flag   giac_colln_batch.dcb_flag%TYPE;
      BEGIN
         BEGIN
            SELECT dcb_flag
              INTO v_dcb_flag
              FROM giac_colln_batch
             WHERE fund_cd = p_gibr_gfun_fund_cd
               AND branch_cd = p_gibr_branch_cd
               AND dcb_year = TO_NUMBER (TO_CHAR (to_date(p_or_date, 'mm-dd-yyyy'), 'YYYY'))
               AND dcb_no = p_dcb_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dcb_flag := 'O';
         END;

         IF v_dcb_flag IN ('O', 'X')
         THEN
            BEGIN
               --/*A.R.C. 08.29.2005*/--
               -- to delete workflow records of accounting
               delete_workflow_rec ('SPOIL OR',
                                    'GIACS001',
                                    NVL(giis_users_pkg.app_user, USER),
                                    p_gacc_tran_id
                                   );

               --/*08.29.2005*/--
               INSERT INTO giac_spoiled_or
                           (or_pref, or_no, fund_cd,
                            branch_cd, spoil_date, spoil_tag, tran_id,
                            user_id, last_update, or_date
                           )
                    VALUES (p_or_pref_suf, p_or_no, p_gibr_gfun_fund_cd,
                            p_gibr_branch_cd, SYSDATE, 'S', p_gacc_tran_id,
                            NVL(giis_users_pkg.app_user, USER), SYSDATE, to_date(p_or_date, 'mm-dd-yyyy')
                           );

               IF SQL%FOUND
               THEN
                  p_or_pref_suf := null;
                  p_or_no := null;
                  p_or_flag := 'N';

                  --p_user_id := NVL(giis_users_pkg.app_user, USER);
                  --p_last_update := SYSDATE;
                  IF v_tran_flag = 'C'
                  THEN
                     UPDATE giac_acctrans
                        SET tran_flag = 'O'
                      WHERE tran_id = p_gacc_tran_id;

                     IF SQL%NOTFOUND
                     THEN
                        ROLLBACK;
                        p_message := 'Spoil OR: Unable to update acctrans.';
                     END IF;
                  END IF;
               /*
                  IF nvl(giacp.v('UPLOAD_IMPLEMENTATION_SW'),'N') = 'Y' THEN --Vincent 05092006
                     exec_immediate('BEGIN upload_dpc.upd_guf('||:gior.gacc_tran_id||'); END;');--Vincent 08222006
                     forms_ddl('COMMIT');--Vincent 08222006
                  END IF;
               */
               ELSE
                  p_message := 'Spoil OR: Unable to insert into spoiled_or.';
               END IF;
            END;
         ELSIF v_dcb_flag IN ('T', 'C')
         THEN
            p_message :=
                  'Spoiling not allowed. The DCB No. has '
               || 'already been closed/temporarily closed. You '
               || 'may cancel this O.R. instead.';
         END IF;
      END;
   ELSIF v_tran_flag = 'D'
   THEN
      p_message := 'Spoiling not allowed. This is a deleted transaction.';
   ELSIF v_tran_flag = 'P'
   THEN
      p_message := 'Spoiling not allowed. This is a posted transaction.';
   END IF;
END;
/


