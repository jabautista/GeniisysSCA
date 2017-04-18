DROP PROCEDURE CPI.GET_PACK_POL_NO;

CREATE OR REPLACE PROCEDURE CPI.get_pack_pol_no (p_pack_par_id IN NUMBER)
/* Created by: PETERMKAW 04272010
** Parameter:  p_pack_par_id (the par_id of the package to be used)
**
** This procedure will update the pol_seq_no or the endt_seq_no depending
** on the PAR if it is an endorsement or an policy. This procedure was
** created to allow other users (specifically underwriters) to post PAR's
** even if a package policy is currently being posted by another user.
** This procedure is first utilized in GIPIS055A (package pol/endt posting).
** This procedure is derived from the trigger POLBASIC_TBXIU from the table
** GIPI_POLBASIC.
** PETERMKAW 06222010 NVL (c1.endt_iss_cd, c1.iss_cd) for iss_cd of endorsements
*/
IS
  v_remarks       VARCHAR2 (2000);
  v_par_type      gipi_parlist.par_type%TYPE;
  v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
  v_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE;
  same_sw         VARCHAR2 (1);
  p_exist         VARCHAR2 (1);
  p_exist1        VARCHAR2 (1);
  p_pol_seq_no    NUMBER                           := 9999999;
BEGIN
  /* First, sub-policies of the package policy to be posted are selected.
  */
  FOR c1 IN (SELECT   pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                      renew_no, endt_iss_cd, endt_yy, endt_seq_no
                 FROM gipi_wpolbas
                WHERE pack_par_id = p_pack_par_id
             ORDER BY par_id ASC)
  LOOP
    same_sw := 'N';
    p_exist := 'N';
    p_exist1 := 'N';
    v_par_type := 'P';

    /* The sub-policies of the package will be checked if it is an
    ** endorsement or a policy.
    */
    BEGIN
      SELECT par_type
        INTO v_par_type
        FROM gipi_parlist
       WHERE par_id = c1.par_id;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        v_par_type := 'P';
    END;

    /* Initialization of v_pol_seq_no and v_endt_seq_no is done. This is
    ** to preserve the POL_SEQ_NO if the par_type is an endorsement 'E' and
    ** ENDT_SEQ_NO if the par_type is a policy 'P'.
    */
    v_pol_seq_no := c1.pol_seq_no;
    v_endt_seq_no := c1.endt_seq_no;

    /* If the PAR is a policy, then v_pol_seq_no will be updated depending
    ** on it's conditions and v_endt_seq_no will remain the same.
    */
    IF v_par_type = 'P'
    THEN
      --BETH 102299 for renewal which will use same policy no
      --            by pass extract and update of pol_seq_no
      FOR renew IN (SELECT pol_seq_no
                      FROM gipi_wpolbas
                     WHERE par_id = c1.par_id
                       AND NVL (same_polno_sw, 'N') = 'Y'
                       AND NVL (pol_flag, '1') IN ('2', '3'))
      LOOP
        same_sw := 'Y';
        /*
        FOR old IN (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                                pol_seq_no, renew_no, actual_renew_no,
                                manual_renew_no
                           FROM gipi_polbasic
                          WHERE policy_id = renew.ID)
        LOOP
           -- for policy that will use same no. copy pol_seq_no and issue_yy
           -- from the old policy
           IF renew.same_sw = 'Y'
           THEN
              v_issue_yy := old_data.issue_yy;
              v_pol_seq_no := old_data.pol_seq_no;
           END IF;
        END LOOP;
        */ --what will be the value of v_pol_seq_no...?
        EXIT;
      END LOOP;

      IF same_sw = 'N'
      THEN
        FOR a1 IN (SELECT        pol_seq_no, ROWID
                            FROM giis_pol_seq
                           WHERE line_cd = c1.line_cd
                             AND subline_cd = c1.subline_cd
                             AND iss_cd = c1.iss_cd
                             AND issue_yy = c1.issue_yy
                        -- removed 02/09/2001 by rbd
                   -- AND renew_no   =  :NEW.renew_no
                   FOR UPDATE OF pol_seq_no)
        LOOP
          IF a1.pol_seq_no < p_pol_seq_no
          THEN   --dadagdag ng and :new.pack_par_id is null
            v_pol_seq_no := a1.pol_seq_no + 1;

            UPDATE giis_pol_seq
               SET pol_seq_no = v_pol_seq_no,
                   user_id = NVL(giis_users_pkg.app_user, USER),
                   last_update = SYSDATE
             WHERE ROWID = a1.ROWID;

            p_exist := 'Y';
          ELSE
            v_pol_seq_no := 1;

            UPDATE giis_pol_seq
               SET pol_seq_no = 1,
                   user_id = NVL(giis_users_pkg.app_user, USER),
                   last_update = SYSDATE
             WHERE ROWID = a1.ROWID;

            p_exist := 'Y';
          END IF;
        END LOOP;

        IF p_exist = 'N'
        THEN
          v_pol_seq_no := 1;

          INSERT INTO giis_pol_seq
                      (line_cd, iss_cd, issue_yy, subline_cd, pol_seq_no,
                       renew_no, user_id, last_update
                      )
               VALUES (c1.line_cd, c1.iss_cd, c1.issue_yy, c1.subline_cd, v_pol_seq_no,
                       c1.renew_no, NVL(giis_users_pkg.app_user, USER), SYSDATE
                      );
        END IF;
      END IF;

      /* After the v_pol_seq_no and endt_seq_no are validated (along with
      ** it's respective updates on the sequence tables 'GIIS_POL_SEQ' and
      ** 'GIIS_ENDT_SEQ'), insertion of data to the temporary table is
      ** inserted. This temporary table will serve as a reference for the
      ** table GIPI_POLBASIC when the sub-policies are successfully inserted.
      ** The specific column to be referenced by this temporary table are the
      ** sequence numbers 'POL_SEQ_NO' and 'ENDT_SEQ_NO' for the sequence is
      ** no longer being updated by the trigger polbasic_tbxiu if the policy
      ** is a package policy.
      */
      INSERT INTO giis_pack_pol_seq_temp
                  (pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy,
                   pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                   endt_seq_no, user_id, last_update, remarks
                  )
           VALUES (c1.pack_par_id, c1.par_id, c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy,
                   v_pol_seq_no, c1.renew_no, NVL (c1.endt_iss_cd, c1.iss_cd), c1.endt_yy,
                   v_endt_seq_no, NVL(giis_users_pkg.app_user, USER), SYSDATE, v_remarks
                  );
    /* If the PAR is an endorsement, then v_endt_seq_no will be updated
    ** depending on it's conditions and v_pol_seq_no will remain the same.
    */
    ELSIF v_par_type = 'E'
    THEN
      FOR a1 IN (SELECT MAX (endt_seq_no) endt_seq_no
                   FROM giis_endt_seq
                  WHERE line_cd = c1.line_cd
                    AND subline_cd = c1.subline_cd
                    AND iss_cd = c1.iss_cd
                    AND issue_yy = c1.issue_yy
                    AND pol_seq_no = c1.pol_seq_no
                    AND renew_no = c1.renew_no
                    AND endt_iss_cd = c1.endt_iss_cd)
      LOOP
        FOR a2 IN (SELECT        endt_seq_no, ROWID
                            FROM giis_endt_seq
                           WHERE line_cd = c1.line_cd
                             AND subline_cd = c1.subline_cd
                             AND iss_cd = c1.iss_cd
                             AND issue_yy = c1.issue_yy
                             AND pol_seq_no = c1.pol_seq_no
                             AND renew_no = c1.renew_no
                             AND endt_iss_cd = c1.endt_iss_cd
                             AND endt_yy = c1.issue_yy
                   FOR UPDATE OF endt_seq_no)
        --c1.issue_yy instead of c1.endt_yy for endorsements
        LOOP
          v_endt_seq_no := a1.endt_seq_no + 1;

          UPDATE giis_endt_seq
             SET endt_seq_no = v_endt_seq_no,
                 user_id = NVL(giis_users_pkg.app_user, USER),
                 last_update = SYSDATE
           WHERE ROWID = a2.ROWID;

          p_exist1 := 'Y';
          EXIT;
        END LOOP;

        IF p_exist1 = 'N'
        THEN
          v_endt_seq_no := 1;

          INSERT INTO giis_endt_seq
                      (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                       user_id, last_update
                      )
               VALUES (c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy, c1.pol_seq_no,
                       c1.renew_no, NVL (c1.endt_iss_cd, c1.iss_cd), c1.issue_yy, v_endt_seq_no,
                       NVL(giis_users_pkg.app_user, USER), SYSDATE
                      );

          --c1.issue_yy instead of c1.endt_yy for endorsements
          p_exist1 := 'Y';
        END IF;

        EXIT;
      END LOOP;

      IF p_exist1 = 'N'
      THEN
        v_endt_seq_no := 1;

        INSERT INTO giis_endt_seq
                    (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                     renew_no, endt_iss_cd, endt_yy, endt_seq_no, user_id, last_update
                    )
             VALUES (c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy, c1.pol_seq_no,
                     c1.renew_no, NVL (c1.endt_iss_cd, c1.iss_cd), c1.issue_yy, 1, NVL(giis_users_pkg.app_user, USER), SYSDATE
                    );
      --c1.issue_yy instead of c1.endt_yy for endorsements
      END IF;

      /* After the v_pol_seq_no and endt_seq_no are validated (along with
      ** it's respective updates on the sequence tables 'GIIS_POL_SEQ' and
      ** 'GIIS_ENDT_SEQ'), insertion of data to the temporary table is
      ** inserted. This temporary table will serve as a reference for the
      ** table GIPI_POLBASIC when the sub-policies are successfully inserted.
      ** The specific column to be referenced by this temporary table are the
      ** sequence numbers 'POL_SEQ_NO' and 'ENDT_SEQ_NO' for the sequence is
      ** no longer being updated by the trigger polbasic_tbxiu if the policy
      ** is a package policy.
      */
      INSERT INTO giis_pack_pol_seq_temp
                  (pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy,
                   pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                   endt_seq_no, user_id, last_update, remarks
                  )
           VALUES (c1.pack_par_id, c1.par_id, c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy,
                   v_pol_seq_no, c1.renew_no, NVL (c1.endt_iss_cd, c1.iss_cd), c1.issue_yy,
                   v_endt_seq_no, NVL(giis_users_pkg.app_user, USER), SYSDATE, v_remarks
                  );
    --c1.issue_yy instead of c1.endt_yy for endorsements
    END IF;
  END LOOP;
END;
/


