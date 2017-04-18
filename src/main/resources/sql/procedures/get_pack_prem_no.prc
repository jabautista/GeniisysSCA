DROP PROCEDURE CPI.GET_PACK_PREM_NO;

CREATE OR REPLACE PROCEDURE CPI.get_pack_prem_no (p_pack_par_id IN NUMBER)
/* Created by: PETERMKAW 05072010
** Parameter:  p_pack_par_id (the par_id of the package to be used)
**
** This procedure will update the prem_seq_no in giis_prem_seq. This procedure
** was created to allow other users (specifically underwriters) to post PAR's
** even if a package policy is currently being posted by another user.
** This procedure is first utilized in GIPIS055A (package pol/endt posting).
** This procedure is derived from the trigger INVOICE_TBXIX from the table
** GIPI_INVOICE.
*/
IS
   v_prem_seq_no   gipi_invoice.prem_seq_no%TYPE;
BEGIN
   /* First, invoice records of the package policy to be posted are selected.
   */
   FOR c1 IN (SELECT   a.par_id, a.item_grp, b.pack_par_id, b.iss_cd
                  FROM gipi_winvoice a, gipi_wpolbas b
                 WHERE b.pack_par_id = p_pack_par_id AND a.par_id = b.par_id
              ORDER BY a.par_id ASC, a.item_grp ASC)
   LOOP
      v_prem_seq_no := NULL;

      /* A prem_seq_no will be selected based on the issue code.
      */
      FOR a IN (SELECT        prem_seq_no, ROWID
                         FROM giis_prem_seq
                        WHERE iss_cd = c1.iss_cd
                FOR UPDATE OF prem_seq_no)
      LOOP
         /* if a value is acquired, then the prem_seq_no will be updated
         ** in the table giis_prem_seq.
         */
         v_prem_seq_no := NVL (a.prem_seq_no, 0) + 1;

         BEGIN
            UPDATE giis_prem_seq
               SET prem_seq_no = v_prem_seq_no
             WHERE ROWID = a.ROWID;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               raise_application_error
                                  (-200001,
                                   'Duplicate record in GIIS_PREM_SEQ found.'
                                  );
         END;

         EXIT;
      END LOOP;

      /* If the issue code is new, then the v_prem_seq_no will remain null
      ** which will give a new value for the prem_seq_no. This new value will
      ** be inserted in the table GIIS_PREM_SEQ.
      */
      IF v_prem_seq_no IS NULL
      THEN
         BEGIN
            INSERT INTO giis_prem_seq
                        (iss_cd, prem_seq_no
                        )
                 VALUES (c1.iss_cd, 1
                        );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               raise_application_error
                                  (-200001,
                                   'Duplicate record in GIIS_PREM_SEQ found.'
                                  );
         END;
      END IF;

      /* After the v_prem_seq_no is validated, insertion of data to the
      ** temporary table is executed. This temporary table will serve as a
      ** reference for the table GIPI_INVOICE when the records to be inserted
      ** are a part of a package policy. The specific column to be referenced
      ** by this temporary table is the 'PREM_SEQ_NO' for the sequence is
      ** no longer being updated by the trigger invoice_tbxix if the record
      ** to be inserted is part of a package policy.
      */
      INSERT INTO giis_pack_prem_seq_temp
                  (pack_par_id, par_id, item_grp, iss_cd,
                   prem_seq_no, user_id, last_update, remarks
                  )
           VALUES (c1.pack_par_id, c1.par_id, c1.item_grp, c1.iss_cd,
                   v_prem_seq_no, NVL(giis_users_pkg.app_user, USER), SYSDATE, NULL
                  );
   END LOOP;

   COMMIT;
END;
/


