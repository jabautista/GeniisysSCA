CREATE OR REPLACE TRIGGER cpi.giac_acctrans_apar_tauxx
   BEFORE UPDATE OF tran_flag
   ON cpi.giac_acctrans
   FOR EACH ROW
DECLARE
   v_max_seq_no        giac_gl_acct_ref_no.acct_seq_no%TYPE;
   v_new_acct_ref_no   giac_acct_entries.acct_ref_no%TYPE;
   v_exist             VARCHAR2 (1);
BEGIN
   FOR a IN (SELECT DISTINCT a.gl_acct_id, a.acct_entry_id, a.sl_cd,
                             a.acct_ref_no, b.ledger_cd, b.subledger_cd,
                             b.transaction_cd, NVL (b.spoil_sw, 'N')
                                                                    spoil_sw,
                             b.acct_seq_no, b.acct_tran_type
                        FROM giac_acct_entries a, giac_gl_acct_ref_no b
                       WHERE a.gacc_tran_id = :OLD.tran_id
                         AND a.acct_ref_no IS NOT NULL
                         AND a.gacc_tran_id = b.gacc_tran_id
                         AND a.sl_cd = b.sl_cd
                         AND a.gl_acct_id = b.gl_acct_id
                         AND a.acct_ref_no =
                                   b.ledger_cd
                                || ' - '
                                || b.subledger_cd
                                || ' - '
                                || b.transaction_cd
                                || ' - '
                                || b.sl_cd
                                || ' - '
                                || b.acct_seq_no
                         AND a.acct_tran_type = 'S'
                    ORDER BY acct_entry_id)
   LOOP
      IF :OLD.tran_flag = 'O' AND :NEW.tran_flag = 'C' AND a.spoil_sw <> 'Y'
      THEN
         /*increment sequence no*/
         BEGIN
            SELECT 'Y' exist
              INTO v_exist
              FROM giac_gl_acct_ref_no
             WHERE ledger_cd = a.ledger_cd
               AND subledger_cd = a.subledger_cd
               AND transaction_cd = a.transaction_cd
               AND sl_cd = a.sl_cd
               AND gacc_tran_id = :OLD.tran_id
               AND NVL(spoil_sw,'N') <> 'Y';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_max_seq_no := 0;
         END;

         IF v_exist = 'Y'
         THEN
            BEGIN
               SELECT MAX (acct_seq_no)
                 INTO v_max_seq_no
                 FROM giac_gl_acct_ref_no
                WHERE ledger_cd = a.ledger_cd
                  AND subledger_cd = a.subledger_cd
                  AND transaction_cd = a.transaction_cd
                  AND sl_cd = a.sl_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_max_seq_no := 0;
            END;

            v_max_seq_no := v_max_seq_no + 1;
            v_new_acct_ref_no :=
                  a.ledger_cd
               || ' - '
               || a.subledger_cd
               || ' - '
               || a.transaction_cd
               || ' - '
               || a.sl_cd
               || ' - '
               || v_max_seq_no;

            UPDATE giac_gl_acct_ref_no
               SET acct_seq_no = v_max_seq_no
             WHERE ledger_cd = a.ledger_cd
               AND subledger_cd = a.subledger_cd
               AND transaction_cd = a.transaction_cd
               AND sl_cd = a.sl_cd
               AND gacc_tran_id = :OLD.tran_id;

            UPDATE giac_acct_entries
               SET acct_ref_no = v_new_acct_ref_no
             WHERE gacc_tran_id = :OLD.tran_id
               AND acct_entry_id = a.acct_entry_id;
         END IF;
      ELSIF :OLD.tran_flag = 'C' AND :NEW.tran_flag = 'O'
      THEN
         /*set spoil_sw to Y*/
         UPDATE giac_gl_acct_ref_no
            SET spoil_sw = 'Y'
          WHERE ledger_cd = a.ledger_cd
            AND subledger_cd = a.subledger_cd
            AND transaction_cd = a.transaction_cd
            AND sl_cd = a.sl_cd
            AND acct_seq_no = a.acct_seq_no
            AND gacc_tran_id = :OLD.tran_id;
      ELSIF :OLD.tran_flag = 'O' AND :NEW.tran_flag = 'C' AND a.spoil_sw = 'Y'
      THEN
         /*insert new record in giac_gl_acct_ref_no and increment seq no*/
         BEGIN
            SELECT MAX (acct_seq_no)
              INTO v_max_seq_no
              FROM giac_gl_acct_ref_no
             WHERE ledger_cd = a.ledger_cd
               AND subledger_cd = a.subledger_cd
               AND transaction_cd = a.transaction_cd
               AND sl_cd = a.sl_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_max_seq_no := 0;
         END;

         v_max_seq_no := v_max_seq_no + 1;
         v_new_acct_ref_no :=
                  a.ledger_cd
               || ' - '
               || a.subledger_cd
               || ' - '
               || a.transaction_cd
               || ' - '
               || a.sl_cd
               || ' - '
               || v_max_seq_no;

         INSERT INTO giac_gl_acct_ref_no
                     (gacc_tran_id, gl_acct_id, ledger_cd,
                      subledger_cd, transaction_cd, sl_cd,
                      acct_seq_no, acct_tran_type
                     )
              VALUES (:OLD.tran_id, a.gl_acct_id, a.ledger_cd,
                      a.subledger_cd, a.transaction_cd, a.sl_cd,
                      v_max_seq_no, a.acct_tran_type
                     );

            UPDATE giac_acct_entries
               SET acct_ref_no = v_new_acct_ref_no
             WHERE gacc_tran_id = :OLD.tran_id
               AND acct_entry_id = a.acct_entry_id;                     
      END IF;
   END LOOP;
END;