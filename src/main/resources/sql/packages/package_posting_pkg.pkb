CREATE OR REPLACE PACKAGE BODY CPI.package_posting_pkg
/* Author: Peter M. Kaw
** Description: This package prevents all table locks during package posting.
**              All locks for sequence updating will be done before package
**              posting process. This package is used by only one module which
**              is GIPIS055a. Other locks encountered (Accounting tables particularly
**              GIAC_AGING_SOA_DETAILS
** History: This package was created to resolve PRF #2266 optimization.
*/
AS
   PROCEDURE get_pkg_pol_seq (p_par_id IN NUMBER)
/* Created by: PETERMKAW 04272010
** Parameter:  p_par_id (the par_id of the sub policy in the package to be used)
**
** This procedure will update the pol_seq_no or the endt_seq_no depending
** on the PAR if it is an endorsement or an policy. This procedure was
** created to allow other users (specifically underwriters) to post PAR's
** even if a package policy is currently being posted by another user.
** This procedure is first utilized in GIPIS055A (package pol/endt posting).
** This procedure is derived from the trigger POLBASIC_TBXIU from the table
** GIPI_POLBASIC.
*/
   IS
      v_remarks         VARCHAR2 (2000);
      v_par_type        gipi_parlist.par_type%TYPE;
      v_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
      v_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE;
      v_pack_par_id     gipi_parlist.pack_par_id%TYPE;
      same_sw           VARCHAR2 (1);
      p_exist           VARCHAR2 (1);
      p_exist1          VARCHAR2 (1);
      p_pol_seq_no      NUMBER                           := 9999999;
      v_line_cd_sw      VARCHAR2 (1)                     := 'Y';
      v_subline_cd_sw   VARCHAR2 (1)                     := 'Y';
      v_iss_cd_sw       VARCHAR2 (1)                     := 'Y';
      v_issue_yy_sw     VARCHAR2 (1)                     := 'Y';
   BEGIN
      /* first, the values of the row in giis_company_seq is derived to
         know when the policy sequence number will be reset.
      */
      BEGIN
         SELECT line_cd, subline_cd, iss_cd, issue_yy
           INTO v_line_cd_sw, v_subline_cd_sw, v_iss_cd_sw, v_issue_yy_sw
           FROM giis_company_seq
          WHERE pol_clm_seq = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /* First, sub-policies of the package policy to be posted are selected.
      */
      FOR c1 IN (SELECT   pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                          endt_seq_no
                     FROM gipi_wpolbas
                    WHERE par_id = p_par_id
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

         BEGIN
            SELECT pack_par_id
              INTO v_pack_par_id
              FROM gipi_parlist
             WHERE par_id = c1.par_id;
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
                           WHERE par_id = c1.par_id AND NVL (same_polno_sw, 'N') = 'Y' AND NVL (pol_flag, '1') IN ('2', '3'))
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
               IF v_line_cd_sw = 'Y' AND v_subline_cd_sw = 'Y' AND v_iss_cd_sw = 'Y' AND v_issue_yy_sw = 'Y'
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
                     THEN                                                              --dadagdag ng and :new.pack_par_id is null
                        v_pol_seq_no := a1.pol_seq_no + 1;

                        UPDATE giis_pol_seq
                           SET pol_seq_no = v_pol_seq_no,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     ELSE
                        v_pol_seq_no := 1;

                        UPDATE giis_pol_seq
                           SET pol_seq_no = 1,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     END IF;
                  END LOOP;
               ELSE
                  FOR a1 IN (SELECT        pol_seq_no, ROWID
                                      FROM giis_pol_seq
                                     WHERE line_cd = DECODE (v_line_cd_sw, 'Y', c1.line_cd, line_cd)
                                       AND subline_cd = DECODE (v_subline_cd_sw, 'Y', c1.subline_cd, subline_cd)
                                       AND iss_cd = DECODE (v_iss_cd_sw, 'Y', c1.iss_cd, iss_cd)
                                       AND issue_yy = DECODE (v_issue_yy_sw, 'Y', c1.issue_yy, issue_yy)
                                  -- removed 02/09/2001 by rbd
                             -- AND renew_no   =  :NEW.renew_no
                             FOR UPDATE OF pol_seq_no)
                  LOOP
                     IF a1.pol_seq_no < p_pol_seq_no
                     THEN                                                              --dadagdag ng and :new.pack_par_id is null
                        v_pol_seq_no := a1.pol_seq_no + 1;

                        UPDATE giis_pol_seq
                           SET pol_seq_no = v_pol_seq_no,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     ELSE
                        v_pol_seq_no := 1;

                        UPDATE giis_pol_seq
                           SET pol_seq_no = 1,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     END IF;
                  END LOOP;
               END IF;

               IF p_exist = 'N'
               THEN
                  v_pol_seq_no := 1;

                  INSERT INTO giis_pol_seq
                              (line_cd, iss_cd, issue_yy, subline_cd, pol_seq_no, renew_no,
                               user_id, last_update
                              )
                       VALUES (c1.line_cd, c1.iss_cd, c1.issue_yy, c1.subline_cd, v_pol_seq_no, c1.renew_no,
                               NVL (giis_users_pkg.app_user, USER), SYSDATE
                              );
               END IF;

               /* After the v_pol_seq_no and endt_seq_no are validated (along with
               ** it's respective updates on the sequence tables 'GIIS_POL_SEQ' and
               ** 'GIIS_ENDT_SEQ'), insertion of data to the temporary table is
               ** inserted. This temporary table will serve as a reference for the
               ** table GIPI_POLBASIC when the sub-policies are successfully inserted.
               ** The specific column to be referenced by this temporary table are the
               ** sequence numbers 'POL_SEQ_NO' and 'ENDT_SEQ_NO' for the sequence is
               ** no longer being updated by the trigger polbasic_tbxiu if the policy
               ** is a package policy. Will insert only IF same_sw = 'N'!!!
               */
               DELETE FROM giis_pack_pol_seq_temp
                     WHERE pack_par_id = v_pack_par_id AND par_id = c1.par_id;

               INSERT INTO giis_pack_pol_seq_temp
                           (pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                            renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                            user_id, last_update, remarks
                           )
                    VALUES (v_pack_par_id, c1.par_id, c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy, v_pol_seq_no,
                            c1.renew_no, NVL (c1.endt_iss_cd, c1.iss_cd), c1.endt_yy, v_endt_seq_no,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE, v_remarks
                           );
            END IF;
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
                         user_id = NVL (giis_users_pkg.app_user, USER),
                         last_update = SYSDATE
                   WHERE ROWID = a2.ROWID;

                  p_exist1 := 'Y';
                  EXIT;
               END LOOP;

               IF p_exist1 = 'N'
               THEN
                  v_endt_seq_no := 1;

                  INSERT INTO giis_endt_seq
                              (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd,
                               endt_yy, endt_seq_no, user_id, last_update
                              )
                       VALUES (c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy, c1.pol_seq_no, c1.renew_no, c1.endt_iss_cd,
                               c1.issue_yy, v_endt_seq_no, NVL (giis_users_pkg.app_user, USER), SYSDATE
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
                           (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd,
                            endt_yy, endt_seq_no, user_id, last_update
                           )
                    VALUES (c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy, c1.pol_seq_no, c1.renew_no, c1.endt_iss_cd,
                            c1.issue_yy, 1, NVL (giis_users_pkg.app_user, USER), SYSDATE
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
            DELETE FROM giis_pack_pol_seq_temp
                  WHERE pack_par_id = v_pack_par_id AND par_id = c1.par_id;

            INSERT INTO giis_pack_pol_seq_temp
                        (pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                         endt_iss_cd, endt_yy, endt_seq_no, user_id, last_update, remarks
                        )
                 VALUES (v_pack_par_id, c1.par_id, c1.line_cd, c1.subline_cd, c1.iss_cd, c1.issue_yy, v_pol_seq_no, c1.renew_no,
                         c1.endt_iss_cd, c1.issue_yy, v_endt_seq_no, NVL (giis_users_pkg.app_user, USER), SYSDATE, v_remarks
                        );
         --c1.issue_yy instead of c1.endt_yy for endorsements
         END IF;
      END LOOP;
   --COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20202, 'CPI.PACKAGE_POSTING_PKG.GET_PKG_POL_SEQ(' || p_par_id || ')' || CHR (10) || SQLERRM);
   END get_pkg_pol_seq;

   PROCEDURE get_pkg_prem_seq (p_par_id IN NUMBER)
/* Created by: PETERMKAW 05072010
** Parameter:  p_pack_par_id (the par_id of the package to be used)
**
** This procedure will update the prem_seq_no in giis_prem_seq. This procedure
** was created to allow other users (specifically underwriters) to post PAR's
** even if a package policy is currently being posted by another NVL (giis_users_pkg.app_user, USER).
** This procedure is first utilized in GIPIS055A (package pol/endt posting).
** This procedure is derived from the trigger INVOICE_TBXIX from the table
** GIPI_INVOICE.
**
** Modified by Udel 12062012
** Revised code to handle long-term package policies.
** Plan is to delete first records of supplied p_par_id from table GIIS_PACK_PREM_SEQ_TEMP
**      before going into insert loop, then column TAKEUP_SEQ_NO is added on records to be
**      inserted into the said table.
*/
   IS
      v_pack_par_id   gipi_parlist.pack_par_id%TYPE;
      v_prem_seq_no   gipi_invoice.prem_seq_no%TYPE;
   BEGIN
      
      BEGIN
        SELECT pack_par_id
          INTO v_pack_par_id
          FROM gipi_parlist
         WHERE par_id = p_par_id;
      END;   
   
      DELETE FROM giis_pack_prem_seq_temp -- Udel 12062012 moved from inside the loop
               WHERE pack_par_id = v_pack_par_id
               and par_id = p_par_id;
      
      /* First, invoice records of the package policy to be posted are selected.
      */
      FOR c1 IN (SELECT   a.par_id, a.item_grp, b.pack_par_id, b.iss_cd, a.takeup_seq_no
                     FROM gipi_winvoice a, gipi_wpolbas b
                    WHERE b.par_id = p_par_id AND a.par_id = b.par_id
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
                  raise_application_error (-200001, 'Duplicate record in GIIS_PREM_SEQ found.');
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
                           
				v_prem_seq_no := 1; -- bonok :: 9.4.2015 :: SR 20295
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  raise_application_error (-200001, 'Duplicate record in GIIS_PREM_SEQ found.');
            END;
         END IF;

         BEGIN
            SELECT pack_par_id
              INTO v_pack_par_id
              FROM gipi_parlist
             WHERE par_id = p_par_id;
         END;

         /* After the v_prem_seq_no is validated, insertion of data to the
         ** temporary table is executed. This temporary table will serve as a
         ** reference for the table GIPI_INVOICE when the records to be inserted
         ** are a part of a package policy. The specific column to be referenced
         ** by this temporary table is the 'PREM_SEQ_NO' for the sequence is
         ** no longer being updated by the trigger invoice_tbxix if the record
         ** to be inserted is part of a package policy.
         */
         DELETE FROM giis_pack_prem_seq_temp
               WHERE pack_par_id = v_pack_par_id 
                        AND par_id = c1.par_id
                        AND item_grp = c1.item_grp; --added by steven 06.14.2013;so that it will not delete the previous inserted record,this scenario will happen if you have multiple item groups.  

         INSERT INTO giis_pack_prem_seq_temp
                     (pack_par_id, par_id, item_grp, iss_cd, prem_seq_no, user_id,
                      last_update, remarks, takeup_seq_no
                     )
              VALUES (v_pack_par_id, c1.par_id, c1.item_grp, c1.iss_cd, v_prem_seq_no, NVL (giis_users_pkg.app_user, USER),
                      SYSDATE, NULL, c1.takeup_seq_no
                     );
      END LOOP;
   --COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20202, 'CPI.PACKAGE_POSTING_PKG.GET_PKG_PREM_SEQ(' || p_par_id || ')' || CHR (10) || SQLERRM);
   END get_pkg_prem_seq;

   PROCEDURE get_pkg_pack_pol_seq (p_pack_par_id NUMBER)
/* Created by: PETERMKAW 02012011
** Parameter:  p_pack_par_id (the par_id of the package policy to be used)
**
** This procedure will update the pol_seq_no or the endt_seq_no depending
** on the PAR if it is an endorsement or an policy. This procedure was
** created to allow other users (specifically underwriters) to post PAR's
** even if a package policy is currently being posted by another user.
** This procedure is first utilized in GIPIS055A (package pol/endt posting).
** This procedure is derived from the trigger PACK_POLBASIC_TBXIU from the table
** GIPI_PACK_POLBASIC.
*/
   IS
      v_par_type        gipi_parlist.par_type%TYPE;
      same_sw           VARCHAR2 (1)                          := 'N';
      p_exist           VARCHAR2 (1)                          := 'N';
      -- for policy
      p_exist1          VARCHAR2 (1)                          := 'N';
      -- for endorsement
      p_pol_seq_no      NUMBER                                := 9999999;
      p_endt_seq_no     NUMBER                                := 999999;
      v_pol_seq_no      gipi_pack_polbasic.pol_seq_no%TYPE;                                                                --ppmk
      v_endt_seq_no     gipi_pack_polbasic.endt_seq_no%TYPE;                                                               --ppmk
      v_line_cd_sw      VARCHAR2 (1)                          := 'Y';
      v_subline_cd_sw   VARCHAR2 (1)                          := 'Y';
      v_iss_cd_sw       VARCHAR2 (1)                          := 'Y';
      v_issue_yy_sw     VARCHAR2 (1)                          := 'Y';
      v_remarks         VARCHAR2 (2000);
   BEGIN
      /* first, the values of the row in giis_company_seq is derived to
         know when the policy sequence number will be reset.
      */
      BEGIN
         SELECT line_cd, subline_cd, iss_cd, issue_yy
           INTO v_line_cd_sw, v_subline_cd_sw, v_iss_cd_sw, v_issue_yy_sw
           FROM giis_company_seq
          WHERE pol_clm_seq = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      p_exist := 'N';
      p_exist1 := 'N';
      same_sw := 'N';

      FOR a IN (SELECT par_type
                  FROM gipi_pack_parlist
                 WHERE pack_par_id = p_pack_par_id)
      LOOP
         v_par_type := a.par_type;
         EXIT;
      END LOOP;

      FOR pack IN (SELECT pack_par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                          endt_seq_no
                     FROM gipi_pack_wpolbas
                    WHERE pack_par_id = p_pack_par_id)
      LOOP
         /* Initialization of v_pol_seq_no and v_endt_seq_no is done. This is
         ** to preserve the POL_SEQ_NO if the par_type is an endorsement 'E' and
         ** ENDT_SEQ_NO if the par_type is a policy 'P'.
         */
         v_pol_seq_no := pack.pol_seq_no;
         v_endt_seq_no := pack.endt_seq_no;

         IF v_par_type = 'P'
         THEN
            --BETH 102299 for renewal which will use same policy no
            --            by pass extract and update of pol_seq_no
            FOR renew IN (SELECT '1'
                            FROM gipi_pack_wpolbas
                           WHERE pack_par_id = p_pack_par_id AND NVL (same_polno_sw, 'N') = 'Y'
                                 AND NVL (pol_flag, '1') IN ('2', '3'))
            LOOP
               same_sw := 'Y';
               EXIT;
            END LOOP;

            IF same_sw = 'N'
            THEN
               IF v_line_cd_sw = 'Y' AND v_subline_cd_sw = 'Y' AND v_iss_cd_sw = 'Y' AND v_issue_yy_sw = 'Y'
               THEN
                  FOR a1 IN (SELECT        pol_seq_no, ROWID
                                      FROM giis_pack_pol_seq
                                     WHERE line_cd = pack.line_cd
                                       AND subline_cd = pack.subline_cd
                                       AND iss_cd = pack.iss_cd
                                       AND issue_yy = pack.issue_yy
                             -- removed 02/09/2001 by rbd
                                     -- AND renew_no   =  :NEW.renew_no
                             FOR UPDATE OF pol_seq_no)
                  LOOP
                     IF a1.pol_seq_no < p_pol_seq_no
                     THEN
                        v_pol_seq_no := a1.pol_seq_no + 1;

                        UPDATE giis_pack_pol_seq
                           SET pol_seq_no = v_pol_seq_no,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     ELSE
                        v_pol_seq_no := 1;

                        UPDATE giis_pack_pol_seq
                           SET pol_seq_no = 1,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     END IF;
                  END LOOP;
               ELSE
                  FOR a1 IN (SELECT        pol_seq_no, ROWID
                                      FROM giis_pack_pol_seq
                                     WHERE line_cd = DECODE (v_line_cd_sw, 'Y', pack.line_cd, line_cd)
                                       AND subline_cd = DECODE (v_subline_cd_sw, 'Y', pack.subline_cd, subline_cd)
                                       AND iss_cd = DECODE (v_iss_cd_sw, 'Y', pack.iss_cd, iss_cd)
                                       AND issue_yy = DECODE (v_issue_yy_sw, 'Y', pack.issue_yy, issue_yy)
                             -- removed 02/09/2001 by rbd
                                     -- AND renew_no   =  :NEW.renew_no
                             FOR UPDATE OF pol_seq_no)
                  LOOP
                     IF a1.pol_seq_no < p_pol_seq_no
                     THEN
                        v_pol_seq_no := a1.pol_seq_no + 1;

                        UPDATE giis_pack_pol_seq
                           SET pol_seq_no = v_pol_seq_no,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     ELSE
                        v_pol_seq_no := 1;

                        UPDATE giis_pack_pol_seq
                           SET pol_seq_no = 1,
                               user_id = NVL (giis_users_pkg.app_user, USER),
                               last_update = SYSDATE
                         WHERE ROWID = a1.ROWID;

                        p_exist := 'Y';
                     END IF;
                  END LOOP;
               END IF;

               IF p_exist = 'N'
               THEN
                  v_pol_seq_no := 1;

                  INSERT INTO giis_pack_pol_seq
                              (line_cd, iss_cd, issue_yy, subline_cd, pol_seq_no, renew_no,
                               user_id, last_update
                              )
                       VALUES (pack.line_cd, pack.iss_cd, pack.issue_yy, pack.subline_cd, v_pol_seq_no, pack.renew_no,
                               NVL (giis_users_pkg.app_user, USER), SYSDATE
                              );
               END IF;

               /* After the v_pol_seq_no and endt_seq_no are validated (along with
               ** it's respective updates on the sequence tables 'GIIS_POL_SEQ' and
               ** 'GIIS_ENDT_SEQ'), insertion of data to the temporary table is
               ** inserted. This temporary table will serve as a reference for the
               ** table GIPI_POLBASIC when the sub-policies are successfully inserted.
               ** The specific column to be referenced by this temporary table are the
               ** sequence numbers 'POL_SEQ_NO' and 'ENDT_SEQ_NO' for the sequence is
               ** no longer being updated by the trigger polbasic_tbxiu if the policy
               ** is a package policy. Will insert only IF same_sw = 'N'!!!
               */
               DELETE FROM giis_pack_pol_seq_temp
                     WHERE pack_par_id = pack.pack_par_id AND par_id = 0;

               INSERT INTO giis_pack_pol_seq_temp
                           (pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                            renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                            user_id, last_update, remarks
                           )
                    VALUES (pack.pack_par_id, 0, pack.line_cd, pack.subline_cd, pack.iss_cd, pack.issue_yy, v_pol_seq_no,
                            pack.renew_no, NVL (pack.endt_iss_cd, pack.iss_cd), pack.endt_yy, v_endt_seq_no,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE, v_remarks
                           );
            END IF;
         ELSIF v_par_type = 'E'
         THEN
            FOR a1 IN (SELECT MAX (endt_seq_no) endt_seq_no
                         FROM giis_endt_seq
                        WHERE line_cd = pack.line_cd
                          AND subline_cd = pack.subline_cd
                          AND iss_cd = pack.iss_cd
                          AND issue_yy = pack.issue_yy
                          AND pol_seq_no = pack.pol_seq_no
                          AND renew_no = pack.renew_no
                          AND endt_iss_cd = pack.endt_iss_cd)
            LOOP
               FOR a2 IN (SELECT        endt_seq_no, ROWID
                                   FROM giis_endt_seq
                                  WHERE line_cd = pack.line_cd
                                    AND subline_cd = pack.subline_cd
                                    AND iss_cd = pack.iss_cd
                                    AND issue_yy = pack.issue_yy
                                    AND pol_seq_no = pack.pol_seq_no
                                    AND renew_no = pack.renew_no
                                    AND endt_iss_cd = pack.endt_iss_cd
                                    AND endt_yy = pack.endt_yy
                          FOR UPDATE OF endt_seq_no)
               LOOP
--       IF A2.ENDT_SEQ_NO < p_endt_seq_no THEN
                  v_endt_seq_no := a1.endt_seq_no + 1;

                  UPDATE giis_endt_seq
                     SET endt_seq_no = v_endt_seq_no,
                         user_id = NVL (giis_users_pkg.app_user, USER),
                         last_update = SYSDATE
                   WHERE ROWID = a2.ROWID;

                  p_exist1 := 'Y';
--        ELSE
--          :NEW.endt_seq_no  := A1.endt_seq_no + 1;
--          UPDATE giis_endt_seq
--             SET endt_seq_no  = :NEW.endt_seq_no,
--                 user_id      = :NEW.user_id,
--                 last_update  = :NEW.last_upd_date
--           WHERE rowid        =  A2.rowid;
--          p_exist1 := 'Y';
--        END IF;
                  EXIT;
               END LOOP;

               IF p_exist1 = 'N'
               THEN
                  v_endt_seq_no := NVL (a1.endt_seq_no, 0) + 1;

                  INSERT INTO giis_endt_seq
                              (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                               endt_iss_cd, endt_yy, endt_seq_no, user_id, last_update
                              )
                       VALUES (pack.line_cd, pack.subline_cd, pack.iss_cd, pack.issue_yy, pack.pol_seq_no, pack.renew_no,
                               pack.endt_iss_cd, pack.issue_yy, v_endt_seq_no, NVL (giis_users_pkg.app_user, USER), SYSDATE
                              );

                  --pack.issue_yy instead of pack.endt_yy for endorsements
                  p_exist1 := 'Y';
               END IF;

               EXIT;
            END LOOP;

            IF p_exist1 = 'N'
            THEN
               v_endt_seq_no := 1;

               INSERT INTO giis_endt_seq
                           (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                            endt_iss_cd, endt_yy, endt_seq_no, user_id, last_update
                           )
                    VALUES (pack.line_cd, pack.subline_cd, pack.iss_cd, pack.issue_yy, pack.pol_seq_no, pack.renew_no,
                            pack.endt_iss_cd, pack.issue_yy, 1, NVL (giis_users_pkg.app_user, USER), SYSDATE
                           );
            --pack.issue_yy instead of pack.endt_yy for endorsements
            END IF;

            /* After the v_pol_seq_no and endt_seq_no are validated (along with
            ** it's respective updates on the sequence tables 'GIIS_POL_SEQ' and
            ** 'GIIS_ENDT_SEQ'), insertion of data to the temporary table is
            ** inserted. This temporary table will serve as a reference for the
            ** table GIPI_POLBASIC when the sub-policies are successfully inserted.
            ** The specific column to be referenced by this temporary table are the
            ** sequence numbers 'POL_SEQ_NO' and 'ENDT_SEQ_NO' for the sequence is
            ** no longer being updated by the trigger polbasic_tbxiu if the policy
            ** is a package policy. Will insert only IF same_sw = 'N'!!!
            */
            DELETE FROM giis_pack_pol_seq_temp
                  WHERE pack_par_id = pack.pack_par_id AND par_id = 0;

            INSERT INTO giis_pack_pol_seq_temp
                        (pack_par_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                         user_id, last_update, remarks
                        )
                 VALUES (pack.pack_par_id, 0, pack.line_cd, pack.subline_cd, pack.iss_cd, pack.issue_yy, v_pol_seq_no,
                         pack.renew_no, NVL (pack.endt_iss_cd, pack.iss_cd), pack.issue_yy, v_endt_seq_no,
                         NVL (giis_users_pkg.app_user, USER), SYSDATE, v_remarks
                        );
         END IF;

         EXIT;
      END LOOP;
   --COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20202,
                                  'CPI.PACKAGE_POSTING_PKG.GET_PKG_PACK_POL_SEQ(' || p_pack_par_id || ')' || CHR (10) || SQLERRM
                                 );
   END get_pkg_pack_pol_seq;

   PROCEDURE get_company_pol_seq (
      p_pol_clm_seq           VARCHAR2,
      p_line_cd               VARCHAR2,
      p_subline_cd            VARCHAR2,
      p_iss_cd                VARCHAR2,
      p_issue_yy              NUMBER,
      p_user_id               VARCHAR2,
      p_last_upd_date         DATE,
      p_pol_seq_no      OUT   NUMBER,
      p_exist           OUT   VARCHAR2
   )
/* Created by: PETERMKAW  03/24/2011
   This procedure assigns a pol_seq_no for a policy that is being posted and
   references the table GIIS_COMPANY_SEQ to determine where the pol_seq_no
   will be based. This procedure is utilized and derived from the
   trigger POLBASIC_TBXIU from the table GIPI_POLBASIC.
   OUT Parameters:
   p_pol_seq_no: this will be the :NEW.pol_seq_no of the policy to be posted.
   p_exist     : this is used by polbasic_tbxiu. this states whether the
                 sequence number is present or not. if not, then the pol_seq_no
                 will be reset, equating it to 1.
*/
   IS
      v_line_cd_sw      VARCHAR2 (1) := 'Y';
      v_subline_cd_sw   VARCHAR2 (1) := 'Y';
      v_iss_cd_sw       VARCHAR2 (1) := 'Y';
      v_issue_yy_sw     VARCHAR2 (1) := 'Y';
      v_pol_seq_no      NUMBER       := 9999999;
   BEGIN
      p_exist := 'N';

/* first, the values of the row in giis_company_seq is derived to
   know when the policy sequence number will be reset.
*/
      BEGIN
         SELECT line_cd, subline_cd, iss_cd, issue_yy
           INTO v_line_cd_sw, v_subline_cd_sw, v_iss_cd_sw, v_issue_yy_sw
           FROM giis_company_seq
          WHERE pol_clm_seq = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --if statement # 1: pol_seq_no resets per line, subline, iss_cd and year
      IF v_line_cd_sw = 'Y' AND v_subline_cd_sw = 'Y' AND v_iss_cd_sw = 'Y' AND v_issue_yy_sw = 'Y'
      THEN
         /* for loop 1
            linecd    = Y
            sublinecd = Y
            isscd     = Y
            issueyy   = Y */
         FOR a1 IN (SELECT        pol_seq_no, ROWID
                             FROM giis_pol_seq
                            WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd AND iss_cd = p_iss_cd
                                  AND issue_yy = p_issue_yy
                    -- removed 02/09/2001 by rbd
                    -- AND renew_no   =  :NEW.renew_no
                    FOR UPDATE OF pol_seq_no)
         LOOP
            IF a1.pol_seq_no < v_pol_seq_no
            THEN
               p_pol_seq_no := a1.pol_seq_no + 1;

               UPDATE giis_pol_seq
                  SET pol_seq_no = p_pol_seq_no,
                      user_id = p_user_id,
                      last_update = p_last_upd_date
                WHERE ROWID = a1.ROWID;

               p_exist := 'Y';
            ELSE
               p_pol_seq_no := 1;

               UPDATE giis_pol_seq
                  SET pol_seq_no = 1,
                      user_id = p_user_id,
                      last_update = p_last_upd_date
                WHERE ROWID = a1.ROWID;

               p_exist := 'Y';
            END IF;
         END LOOP;
/* end for loop 1
   linecd    = Y
   sublinecd = Y
   isscd     = Y
   issueyy   = Y */

      --if statement # 2: pol_seq_no resets depending on giis_company_seq
      ELSE
         FOR a1 IN (SELECT        pol_seq_no, ROWID
                             FROM giis_pol_seq
                            WHERE line_cd = DECODE (v_line_cd_sw, 'Y', p_line_cd, line_cd)
                              AND subline_cd = DECODE (v_subline_cd_sw, 'Y', p_subline_cd, subline_cd)
                              AND iss_cd = DECODE (v_iss_cd_sw, 'Y', p_iss_cd, iss_cd)
                              AND issue_yy = DECODE (v_issue_yy_sw, 'Y', p_issue_yy, issue_yy)
                    -- removed 02/09/2001 by rbd
                    -- AND renew_no   =  :NEW.renew_no
                    FOR UPDATE OF pol_seq_no)
         LOOP
            IF a1.pol_seq_no < v_pol_seq_no
            THEN
               p_pol_seq_no := a1.pol_seq_no + 1;

               UPDATE giis_pol_seq
                  SET pol_seq_no = p_pol_seq_no,
                      user_id = p_user_id,
                      last_update = p_last_upd_date
                WHERE ROWID = a1.ROWID;

               p_exist := 'Y';
            ELSE
               p_pol_seq_no := 1;

               UPDATE giis_pol_seq
                  SET pol_seq_no = 1,
                      user_id = p_user_id,
                      last_update = p_last_upd_date
                WHERE ROWID = a1.ROWID;

               p_exist := 'Y';
            END IF;
         END LOOP;
/* end for loop 1
   linecd    = Y
   sublinecd = Y
   isscd     = Y
   issueyy   = Y */
      END IF;
   END get_company_pol_seq;

/*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : WHEN-BUTTON-PRESSED trigger in post_button part 1
  */
   PROCEDURE post_package_par (p_pack_par_id IN gipi_parlist.pack_par_id%TYPE, p_msg_alert OUT VARCHAR2)
   IS
      v_ora2010_sw       VARCHAR2 (1);
      v_require_ref_no   VARCHAR2 (1);
      v_notready         NUMBER                                := 0;
      v_par              VARCHAR2 (32000)                      := NULL;
      v_bank_ref_no      gipi_pack_wpolbas.bank_ref_no%TYPE;
      v_bank_ref_no2     gipi_pack_polbasic.bank_ref_no%TYPE;
      v_pack_par_type    gipi_pack_parlist.par_type%TYPE;
   BEGIN
      BEGIN
         SELECT NVL (giisp.v ('ORA2010_SW'), 'N'), NVL (giisp.v ('REQUIRE_REF_NO'), 'N')
           INTO v_ora2010_sw, v_require_ref_no
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ora2010_sw := 'N';
            v_require_ref_no := 'N';
      END;

      FOR c1 IN (SELECT    line_cd
                        || '-'
                        || iss_cd
                        || '-'
                        || TO_CHAR (par_yy, '09')
                        || '-'
                        || TO_CHAR (par_seq_no, '099999')
                        || '-'
                        || TO_CHAR (quote_seq_no, '09') par_no
                   FROM gipi_parlist
                  WHERE pack_par_id = p_pack_par_id AND par_status NOT IN (6, 98, 99) AND par_type = 'P')
      LOOP
         v_notready := 1;

         IF v_par IS NULL
         THEN
            v_par := c1.par_no;
         ELSE
            v_par := v_par || CHR (13) || c1.par_no;
         END IF;
      END LOOP;

      IF v_notready = 1
      THEN
         p_msg_alert := 'The following PAR are not ready for posting: ' || CHR (13) || v_par;
         RETURN;
      END IF;

      /*Endorsements with null bank_ref_no can be posted
      if the original policy being endorsed has no bank_ref_no. */
      BEGIN
         SELECT bank_ref_no
           INTO v_bank_ref_no
           FROM gipi_pack_wpolbas
          WHERE pack_par_id = p_pack_par_id;

         SELECT par_type
           INTO v_pack_par_type
           FROM gipi_pack_parlist
          WHERE pack_par_id = p_pack_par_id;

         IF v_ora2010_sw = 'Y' AND v_require_ref_no = 'Y'
         THEN
            IF v_pack_par_type = 'P' AND v_bank_ref_no IS NULL
            THEN
               p_msg_alert := 'Please provide a bank reference number for this package PAR before proceeding.';
               RETURN;
            ELSIF v_pack_par_type = 'E'
            THEN
               FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                           FROM gipi_pack_wpolbas
                          WHERE pack_par_id = p_pack_par_id)
               LOOP
                  SELECT bank_ref_no
                    INTO v_bank_ref_no2
                    FROM gipi_pack_polbasic
                   WHERE line_cd = a.line_cd
                     AND subline_cd = a.subline_cd
                     AND iss_cd = a.iss_cd
                     AND issue_yy = a.issue_yy
                     AND pol_seq_no = a.pol_seq_no
                     AND renew_no = a.renew_no
                     AND endt_seq_no = 0;
               END LOOP;

               IF v_bank_ref_no2 IS NOT NULL AND v_bank_ref_no IS NULL
               THEN
                  p_msg_alert := 'Please provide a bank reference number for this PAR before posting the policy.';
                  RETURN;
               END IF;
            END IF;
         END IF;
      END;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-12-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : WHEN-BUTTON-PRESSED trigger in post_button part 2
   */
   PROCEDURE post_package_per_par (
      p_pack_par_id        IN       gipi_parlist.pack_par_id%TYPE,
      p_line_cd            IN       gipi_parlist.line_cd%TYPE,
      p_iss_cd             IN       gipi_parlist.iss_cd%TYPE,
      p_msg_alert          OUT      VARCHAR2,
      p_msg_alert2         OUT      VARCHAR2,
      p_msg_type           OUT      VARCHAR2,                                                      -- added by andrew - 08/08/2011
      p_cred_branch_conf   IN       VARCHAR2,                                                       -- added by andrew - 08/08/2011
      p_chk_dflt_intm_sw   IN       VARCHAR2, --benjo 09.07.2016 SR-5604
      p_user_id            IN       VARCHAR2 --added by cherrie 02.14.2014
   )
   IS
      v_underwriter       gipi_pack_parlist.underwriter%TYPE;
      v_post_limit        giis_posting_limit.post_limit%TYPE;
      v_all_amt_sw        giis_posting_limit.all_amt_sw%TYPE;
      v_ann_tsi_amt       gipi_polbasic.ann_tsi_amt%TYPE;
      v_eff_date          DATE;
      v_peril_name        giis_peril.peril_name%TYPE;
      v_line_cd           gipi_polbasic.line_cd%TYPE;
      v_subline_cd        gipi_polbasic.subline_cd%TYPE;
      v_iss_cd            gipi_polbasic.iss_cd%TYPE;
      v_issue_yy          gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no          gipi_polbasic.renew_no%TYPE;
      v_pol_flag          gipi_polbasic.pol_flag%TYPE;
      v_policy_no         VARCHAR2 (250);
      v_endt_type         gipi_polbasic.endt_type%TYPE;
      v_booking_year      gipi_polbasic.booking_year%TYPE;
      v_booking_mth       gipi_polbasic.booking_mth%TYPE;
      v_dist              giuw_pol_dist.auto_dist%TYPE;
      v_allow             giis_parameters.param_value_v%TYPE    := 'Y';
      v_op_switch         VARCHAR2 (1)                          := 'N';
      v_exist             VARCHAR2 (1)                          := 'N';
      v_par_type          gipi_parlist.par_type%TYPE;
      v_req_deduct        giis_parameters.param_value_v%TYPE;
      v_ver_flag          NUMBER;
      v_ver_flag1         NUMBER                                := 0;
      v_deduct_msg        VARCHAR2 (2000);
      v_update            giis_parameters.param_value_v%TYPE;
      v_booked_tag        giis_booking_month.booked_tag%TYPE;
      v_bank_ref_no       gipi_pack_wpolbas.bank_ref_no%TYPE;
      v_ora2010_sw        VARCHAR2 (1);
      v_require_ref_no    VARCHAR2 (1);
      v_bank_ref_no2      gipi_pack_polbasic.bank_ref_no%TYPE;
      v_msg_alert         VARCHAR2 (32000);
      v_msg_icon          VARCHAR2 (1);
      v_get_pack_pol_no   VARCHAR2 (1);
      err_sql             EXCEPTION;
      PRAGMA EXCEPTION_INIT (err_sql, -20202);
      v_takeup_term       gipi_wpolbas.takeup_term%TYPE;
      v_val_post_limit        NUMBER := 1; --cherrie 02.14.2014
      v_perl_exist            VARCHAR2(1):= 'N'; --cherrie 02.14.2014
   BEGIN
      BEGIN
         SELECT NVL (giisp.v ('ORA2010_SW'), 'N'), NVL (giisp.v ('REQUIRE_REF_NO'), 'N')
           INTO v_ora2010_sw, v_require_ref_no
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ora2010_sw := 'N';
            v_require_ref_no := 'N';
      END;

      FOR c1 IN (SELECT par_id, line_cd, iss_cd, par_type
                   FROM gipi_parlist
                  WHERE pack_par_id = p_pack_par_id AND par_status NOT IN (98, 99))
      LOOP
         IF NVL (v_get_pack_pol_no, 'Y') = 'Y'
         THEN                                            --this makes sure that the policy sequence assignment only happens once.
            FOR c2 IN (SELECT par_id, line_cd, iss_cd, pack_par_id
                         FROM gipi_parlist
                        WHERE pack_par_id = p_pack_par_id AND par_status NOT IN (98, 99))
            LOOP
               BEGIN
                  package_posting_pkg.get_correct_iss_yy(p_pack_par_id); --added by John Daniel; 06.29.2016; SR-5539; this makes sure that the pol_seq_no obtained is correct
                  package_posting_pkg.get_pkg_pol_seq (c2.par_id);
                  package_posting_pkg.get_pkg_prem_seq (c2.par_id);

                  IF NVL (v_get_pack_pol_no, 'Y') = 'Y'
                  THEN
                     v_get_pack_pol_no := 'N';
                     package_posting_pkg.get_pkg_pack_pol_seq (c2.pack_par_id);
                  END IF;
               EXCEPTION
                  WHEN err_sql
                  THEN
                     --msg_alert (SQLERRM, 'E', FALSE);
                     p_msg_alert := 'Error in sequence initialization! Now exiting posting module GIPIS055a.';
                     RETURN;
               END;
            END LOOP;
         END IF;

         --A.R.C. 11.22.2006
         --to check if co-insurer exists
         IF NVL (giisp.v ('CHECK_CO_INSURER'), 'N') = 'Y'
         THEN
            FOR c2 IN (SELECT 1
                         FROM gipi_wpolbas a
                        WHERE 1 = 1 AND co_insurance_sw <> 1 AND par_id = c1.par_id AND NOT EXISTS (SELECT 1
                                                                                                      FROM gipi_main_co_ins z
                                                                                                     WHERE z.par_id = a.par_id))
            LOOP
               p_msg_alert := 'The PAR ' || gipi_parlist_pkg.get_par_no (c1.par_id) || ' has no Co-insurance.';
               RETURN;
            END LOOP;
         END IF;

         /**
         * Validation for crediting branch
         * Added by : Andrew Robes
         * Date : 08-08-2011
         */
         BEGIN
            FOR i IN (SELECT cred_branch
                        FROM gipi_wpolbas
                       WHERE par_id = c1.par_id)
            LOOP
               IF NVL (giisp.v ('MANDATORY_CRED_BRANCH'), 'N') = 'N' AND i.cred_branch IS NULL AND p_cred_branch_conf <> 'Y'
               THEN
                  p_msg_type := 'confirm';
                  p_msg_alert :=
                        'The PAR '
                     || gipi_parlist_pkg.get_par_no (c1.par_id)
                     || ' has no Crediting Branch. Do you want to continue posting?';
                  RETURN;
               ELSIF NVL (giisp.v ('MANDATORY_CRED_BRANCH'), 'N') = 'Y' AND i.cred_branch IS NULL
               THEN
                  p_msg_alert := 'The PAR ' || gipi_parlist_pkg.get_par_no (c1.par_id) || ' has no Crediting Branch.';
                  RETURN;
               END IF;
            END LOOP;
         END;
         
         /* benjo 09.07.2016 SR-5604 */
         IF NVL (giisp.v ('REQUIRE_DEFAULT_INTM_PER_ASSURED'), 'N') = 'Y' AND p_chk_dflt_intm_sw <> 'Y' THEN
            FOR i IN (SELECT pack_par_id, assd_no, line_cd
                        FROM gipi_pack_parlist
                       WHERE pack_par_id = p_pack_par_id)
            LOOP
               FOR x IN (SELECT intm_no
                           FROM giis_assured_intm
                          WHERE assd_no = i.assd_no AND line_cd = i.line_cd)
               LOOP
                  FOR y IN (SELECT intrmdry_intm_no
                              FROM gipi_wcomm_invoices
                             WHERE par_id = c1.par_id)
                  LOOP
                     IF x.intm_no <> y.intrmdry_intm_no THEN
                        p_msg_type := 'confirm';
                        p_msg_alert := 'Default Intermediary for the assured has been changed. Would you like to continue?';
                        RETURN;
                     END IF;
                  END LOOP;
               END LOOP;
            END LOOP;
         END IF;
         
         /* benjo 01.10.2017 SR-5749 */
         IF NVL(giisp.v('REQUIRE_LAT_LONG'),'N') = 'Y' THEN
            FOR i IN (SELECT latitude, longitude
                        FROM gipi_wfireitm
                       WHERE par_id = c1.par_id)
            LOOP
                IF i.latitude IS NULL OR i.longitude IS NULL THEN
                   p_msg_alert := 'Cannot post Par. Latitude and Longitude are required.';
                END IF;
            END LOOP;
         END IF;

         /* Modified by        : aaron
         ** Date Modified    : 060507
         ** Remarks                : validate if user = gipi_parlist.underwriter, before posting...
         */
         FOR x IN (SELECT underwriter
                     FROM gipi_pack_parlist
                    WHERE pack_par_id = p_pack_par_id)
         LOOP
            v_underwriter := x.underwriter;
         END LOOP;

         IF v_underwriter <> NVL (giis_users_pkg.app_user, USER)
         THEN
            p_msg_alert := 'Unable to post PAR. The PAR should be re-assigned to you before you could continue with the posting.';
            RETURN;
         END IF;

----------------------------------

         /*
         ** Modified by     : Connie
         ** Date Modified : 09/22/2006
         ** Modifications : validate if user is allowed to post a policy
         */
         /* commented out by cherrie 02.14.2014
         BEGIN
            SELECT post_limit, all_amt_sw
              INTO v_post_limit, v_all_amt_sw
              FROM giis_posting_limit
             --WHERE line_cd = c1.line_cd   --modified by Connie 01/09/2007
             --  AND iss_cd  = c1.iss_cd
            WHERE  line_cd = p_line_cd AND iss_cd = p_iss_cd                                                                 --*--
                   AND UPPER (posting_user) = giis_users_pkg.app_user;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert :=
                     'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user '
                  || giis_users_pkg.app_user
                  || '.';
               RETURN;
         END;

         IF v_all_amt_sw IS NULL OR v_all_amt_sw = 'N'
         THEN                                                                                                   --unchecked or 'N'
            IF v_post_limit IS NULL OR v_post_limit = 0
            THEN
               p_msg_alert :=
                     'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user '
                  || giis_users_pkg.app_user
                  || '.';
               RETURN;
            ELSIF v_post_limit IS NOT NULL OR v_post_limit <> 0
            THEN
               --A.R.C. 11.23.2006
               --FOR p1 IN (SELECT item_no, (ann_tsi_amt*currency_rt) ann_tsi_amt
               FOR p1 IN (SELECT SUM (ann_tsi_amt * currency_rt) ann_tsi_amt
                            FROM gipi_witem
                           WHERE par_id = c1.par_id)
               LOOP
                  --v_item_no := p1.item_no;
                  v_ann_tsi_amt := p1.ann_tsi_amt;

                  IF NVL (v_ann_tsi_amt, 0) > NVL (v_post_limit, 0)
                  THEN
                     p_msg_alert :=
                           'Total TSI amount exceeds the allowable TSI amount of the user '
                        || giis_users_pkg.app_user
                        || '. Reassign the PAR to another user with higher authority.';
                     RETURN;
                  END IF;
               END LOOP;
            END IF;
         END IF;
         */--cherrie 02142014

         --added by iris bordey (09.20.2002)
         --Validation for posting policy with pending claims on particular item and peril(s).
         --Disallow posting if there are pending claims on specified item and peril(s).
         FOR dt IN (SELECT TRUNC (eff_date) eff_date, line_cd, subline_cd, iss_cd, pol_seq_no, issue_yy, renew_no, pol_flag,
                           ann_tsi_amt, endt_type, booking_year, booking_mth,                             -- added by kim 01/05/05
                                                                             NVL (takeup_term, 'ST') takeup_term  /*vjp 08032011*/
                      FROM gipi_wpolbas
                     WHERE par_id = c1.par_id)
         LOOP
            v_eff_date := dt.eff_date;
            v_line_cd := dt.line_cd;
            v_subline_cd := dt.subline_cd;
            v_iss_cd := dt.iss_cd;
            v_issue_yy := dt.issue_yy;
            v_pol_seq_no := dt.pol_seq_no;
            v_renew_no := dt.renew_no;
            v_pol_flag := dt.pol_flag;
            v_ann_tsi_amt := dt.ann_tsi_amt;
            v_endt_type := dt.endt_type;
            v_booking_year := dt.booking_year;
            v_booking_mth := dt.booking_mth;
            v_policy_no :=
                  v_line_cd
               || '-'
               || v_subline_cd
               || '-'
               || v_iss_cd
               || '-'
               || TO_CHAR (v_issue_yy, '09')
               || '-'
               || TO_CHAR (v_pol_seq_no, '0999999')
               || '-'
               || TO_CHAR (v_renew_no, '09');
            v_takeup_term := dt.takeup_term;                                                                      /*vjp 08032011*/
            EXIT;
         END LOOP;

         -- Added by gracey 061604
           -- check if posting is allowed for undistributed policies
         FOR a IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'ALLOW_POSTING_OF_UNDIST')
         LOOP
            v_allow := a.param_value_v;
            EXIT;
         END LOOP;

         FOR b IN (SELECT auto_dist
                     FROM giuw_pol_dist
                    WHERE par_id = c1.par_id)
         LOOP
            v_dist := b.auto_dist;
            EXIT;
         END LOOP;

         FOR d IN (SELECT a.par_type par_type, c.op_flag op_flag
                     FROM gipi_parlist a, gipi_wpolbas b, giis_subline c
                    WHERE a.par_id = b.par_id AND b.subline_cd = c.subline_cd AND b.line_cd = c.line_cd AND a.par_id = c1.par_id)
         LOOP
            v_par_type := d.par_type;
            v_op_switch := d.op_flag;
            EXIT;
         END LOOP;
         
         --added by cherrie 02.14.2014 | changes were base on the latest CS version (gipis055 v. 1.16.2014 11:24am)
         v_ann_tsi_amt := 0;

         FOR p1 IN (SELECT SUM (ann_tsi_amt * currency_rt) ann_tsi_amt
                      FROM gipi_witem
                     WHERE par_id IN (
                              SELECT par_id
                                FROM gipi_parlist
                               WHERE pack_par_id = p_pack_par_id--c1.par_id --change by koks 7.1.15
                                 AND par_status NOT IN (98, 99)))
         LOOP
            v_ann_tsi_amt := v_ann_tsi_amt + p1.ann_tsi_amt;
         END LOOP;

         IF v_par_type = 'P' --POLICY
         THEN
            v_val_post_limit :=
               validate_posting_limit (p_user_id,  
                                       p_iss_cd,
                                       p_line_cd,
                                       v_par_type,
                                       v_ann_tsi_amt
                                      );
         ELSIF v_par_type = 'E' --ENDORSEMENT
         THEN                                            
            FOR itmperl IN (SELECT 1
                              FROM gipi_witmperl
                             WHERE par_id = c1.par_id)
            LOOP
               v_perl_exist := 'Y';
            END LOOP;

            IF v_perl_exist = 'Y'
            THEN
               v_val_post_limit :=
                  validate_posting_limit (p_user_id,
                                          p_iss_cd,
                                          p_line_cd,
                                          v_par_type,
                                          v_ann_tsi_amt
                                         );
            ELSE
               NULL;
            END IF;
         END IF;

         IF (v_val_post_limit = 1)
         THEN
            NULL; -- do nothing
         ELSIF (v_val_post_limit = 0) --benjo 10.08.2015 GENQA-SR-4992
         THEN
            p_msg_alert := 'Total TSI amount exceeds the allowable TSI amount of the user ' || p_user_id || '. Reassign the PAR to another user with higher authority.';
            RETURN;
         ELSIF (v_val_post_limit = 3) --benjo 10.08.2015 GENQA-SR-4992
         THEN
            p_msg_alert := 'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user.';
            RETURN;
         END IF;

         -- end of added codes | cherrie 02.14.2014

         FOR d IN (SELECT 1
                     FROM gipi_witmperl
                    WHERE par_id = c1.par_id)
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;

         --**-- gmi 09/26/05 --**--
         FOR d1 IN (SELECT 1
                      FROM gipi_witmperl_grouped
                     WHERE par_id = c1.par_id)
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;

         --** --gmi-- **--

         /*Modified by : John Oliver Mendoza
         **    date    : 062020006
         **Modification: this validates if all the items of the given PAR have at least 1 record
                                       in GIPI_DEDUCTIBLES, if not posting will not continue.
         */

         -- ohwver start 062006--
         FOR ver_rec1 IN (SELECT param_value_v
                            FROM giis_parameters
                           WHERE param_name = 'REQUIRE_DEDUCTIBLES')
         LOOP
            v_req_deduct := ver_rec1.param_value_v;
         END LOOP;

         IF v_par_type = 'P'
         THEN
            IF NVL (v_req_deduct, 'N') = 'Y'
            THEN
               FOR ver_rec2 IN (SELECT item_no
                                  FROM gipi_witem
                                 WHERE par_id = c1.par_id)
               LOOP
                  FOR ver_rec3 IN (SELECT 'VER'
                                     FROM gipi_wdeductibles
                                    WHERE par_id = c1.par_id AND item_no = ver_rec2.item_no)
                  LOOP
                     v_ver_flag := 1;
                  END LOOP;

                  IF v_ver_flag = 1
                  THEN
                     v_ver_flag := 0;
                  ELSE
                     v_deduct_msg := v_deduct_msg || ver_rec2.item_no || ', ';
                     v_ver_flag := 0;
                     v_ver_flag1 := v_ver_flag1 + 1;
                  END IF;
               END LOOP;

               IF v_ver_flag1 > 0
               THEN
                  --SUBSTR('VEROLIVER',1,INSTR('VEROLIVER','VER',-1)-1)--
                  v_deduct_msg := SUBSTR (v_deduct_msg, 1, INSTR (v_deduct_msg, ', ', -1) - 1);
                  p_msg_alert := 'Item no(s) ' || v_deduct_msg || ' must have at least 1 deductible.';
                  RETURN;
               END IF;                                                                                    --end if v_ver_flag1 > 0
            END IF;                                                                           --end if nvl(v_req_deduct,'N') = 'Y'
         ELSIF v_par_type = 'E'
         THEN
            IF NVL (v_req_deduct, 'N') = 'Y'
            THEN
               FOR ver_rec2 IN (SELECT item_no
                                  FROM gipi_witem
                                 WHERE par_id = c1.par_id AND rec_flag = 'A')
               LOOP
                  FOR ver_rec3 IN (SELECT 'VER'
                                     FROM gipi_wdeductibles
                                    WHERE par_id = c1.par_id AND item_no = ver_rec2.item_no)
                  LOOP
                     v_ver_flag := 1;
                  END LOOP;

                  IF v_ver_flag = 1
                  THEN
                     v_ver_flag := 0;
                  ELSE
                     v_deduct_msg := v_deduct_msg || ver_rec2.item_no || ', ';
                     v_ver_flag := 0;
                     v_ver_flag1 := v_ver_flag1 + 1;
                  END IF;
               END LOOP;

               IF v_ver_flag1 > 0
               THEN
                  v_deduct_msg := SUBSTR (v_deduct_msg, 1, INSTR (v_deduct_msg, ', ', -1) - 1);
                  p_msg_alert := 'Item no(s) ' || v_deduct_msg || ' must have at least 1 deductible.';
                  RETURN;
               END IF;                                                                                    --end if v_ver_flag1 > 0
            END IF;                                                                           --end if nvl(v_req_deduct,'N') = 'Y'
         END IF;                                                                                               --end if v_par_type

         --ohwver end--
         IF v_par_type = 'P'
         THEN
            IF NVL (v_allow, 'Y') = 'N' AND NVL (v_dist, 'N') = 'N' AND v_op_switch = 'N'
            THEN
               p_msg_alert := 'Distribute the PAR ' || gipi_parlist_pkg.get_par_no (c1.par_id) || ' before posting the policy.';
               RETURN;
            END IF;
         ELSIF v_par_type = 'E' AND v_exist = 'Y'
         THEN
            IF NVL (v_allow, 'Y') = 'N' AND NVL (v_dist, 'N') = 'N' AND v_op_switch = 'N'
            THEN
               p_msg_alert := 'Distribute the PAR ' || gipi_parlist_pkg.get_par_no (c1.par_id) || ' before posting the policy.';
               RETURN;
            END IF;
         END IF;

         -- Added by kim 01/05/05
           -- checks if update booking is allowed
         FOR a IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'UPDATE_BOOKING')
         LOOP
            v_update := a.param_value_v;
            EXIT;
         END LOOP;

         -- Added by kim 01/05/05
         -- checks if the value of the booked tag of the PAR
         FOR a IN (SELECT booked_tag
                     FROM giis_booking_month
                    WHERE booking_year = v_booking_year AND booking_mth = v_booking_mth)
         LOOP
            v_booked_tag := a.booked_tag;
            EXIT;
         END LOOP;

         /* petermkaw 07022010
         ** added validation of bank_ref_no depending on the parameters
         **/
         BEGIN
            --v_bank_ref_no := null;
            -- added exception by robert 05.07.2013 sr 12794
            BEGIN
               SELECT bank_ref_no
                 INTO v_bank_ref_no
                 FROM gipi_wpolbas
                WHERE par_id = c1.par_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;


            -- modified by analyn 07/26/2010
            IF v_ora2010_sw = 'Y' AND v_require_ref_no = 'Y'
            THEN
               IF v_par_type = 'P' AND v_bank_ref_no IS NULL
               THEN                                                        -- analyn 07/26/2010 added v_par_type in the condition
                  p_msg_alert :=
                        'Please provide a bank reference number for the PAR '
                     || gipi_parlist_pkg.get_par_no (c1.par_id)
                     || ' before proceeding.';
                  RETURN;
               ELSIF v_par_type = 'E'
               THEN                                                                                           -- analyn 07/26/2010
                  FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                              FROM gipi_wpolbas
                             WHERE par_id = c1.par_id)
                  LOOP
                     SELECT bank_ref_no
                       INTO v_bank_ref_no2
                       FROM gipi_polbasic
                      WHERE line_cd = a.line_cd
                        AND subline_cd = a.subline_cd
                        AND iss_cd = a.iss_cd
                        AND issue_yy = a.issue_yy
                        AND pol_seq_no = a.pol_seq_no
                        AND renew_no = a.renew_no
                        AND endt_seq_no = 0;
                  END LOOP;

                  IF v_bank_ref_no2 IS NOT NULL AND v_bank_ref_no IS NULL
                  THEN
                     UPDATE gipi_wpolbas
                        SET bank_ref_no = v_bank_ref_no2
                      WHERE par_id = c1.par_id;
                  END IF;
               END IF;
            END IF;
         /*EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
           THEN
             IF variables.v_ora2010_sw = 'Y' AND variables.v_require_ref_no = 'Y'
             THEN
               msg_alert('Please provide a bank reference number for the PAR '||GET_PAR(c1.par_id)||' before proceeding.','E',false);
               exit_form;
             END IF;*/
         END;

         /* -- end ppmk -- */

         /* added by petermkaw 04282010
         ** 2 conditions are added to execute the database procedures cpi.GET_PACK_POL_NO.
         ** and cpi.GET_PACK_PREM_NO. These procedures will only be ran once each time
         ** the module GIPIS055A is called. The condition is placed here because a commit
         ** is performed inside the procedure. All statements before these two conditions
         ** line have no inserts or updates executed to prevent committing even upon error
         ** (no chance of rollback for committed changes).
         */

         --cpi.GET_PACK_POL_NO added on 04281010
         /*IF NVL(v_get_pack_pol_no,'Y') = 'Y' THEN
           cpi.get_pack_pol_no (p_pack_par_id); --04282010
           cpi.get_pack_prem_no (p_pack_par_id); --05072010
           v_get_pack_pol_no := 'N';
         END IF;*/

         -- added by kim 01/05/05
           -- if the value of the parameter update_booking is set to Y
           -- and the booked_tag of the booking date is set to Y
           -- then it updates the booking date to the next available booking date
         IF v_update = 'Y' AND v_booked_tag = 'Y'
         THEN
            FOR c IN (SELECT   booking_year, TO_CHAR (TO_DATE ('01-' || SUBSTR (booking_mth, 1, 3) || booking_year), 'MM'),
                               booking_mth
                          FROM giis_booking_month
                         WHERE (NVL (booked_tag, 'N') != 'Y')
                           AND (   booking_year > v_booking_year
                                OR (    booking_year = v_booking_year
                                    AND TO_NUMBER (TO_CHAR (TO_DATE ('01-' || SUBSTR (booking_mth, 1, 3) || booking_year), 'MM')) >=
                                           TO_NUMBER (TO_CHAR (TO_DATE ('01-' || SUBSTR (v_booking_mth, 1, 3) || v_booking_year),
                                                               'MM'
                                                              )
                                                     )
                                   )
                               )
                      ORDER BY 1, 2)
            LOOP
               v_booking_year := TO_NUMBER (c.booking_year);
               v_booking_mth := c.booking_mth;
               EXIT;
            END LOOP;

            p_msg_alert2 := 'Booking date has been closed. Will now update the booking date to the next available booking month.';

            UPDATE gipi_wpolbas
               SET booking_mth = v_booking_mth,
                   booking_year = v_booking_year
             WHERE par_id = c1.par_id;

            /*niknok 11042011*/
            IF p_pack_par_id IS NOT NULL
            THEN
               UPDATE gipi_pack_wpolbas
                  SET booking_mth = v_booking_mth,
                      booking_year = v_booking_year
                WHERE pack_par_id = p_pack_par_id;
            END IF;

            /*vjp 08032011*/
            IF v_takeup_term = 'ST'
            THEN
               UPDATE gipi_winvoice
                  SET multi_booking_mm = v_booking_mth,
                      multi_booking_yy = v_booking_year
                WHERE par_id = c1.par_id;
            END IF;

            COMMIT;
         END IF;

         /*added by dannel 10162006
             validation for plate_no,serial_no and motor_no    */
         IF c1.line_cd = 'MC'
         THEN
            IF v_msg_alert IS NULL
            THEN
               validate_carnap (c1.par_id, v_msg_alert);

               IF v_msg_alert IS NOT NULL
               THEN
                  p_msg_alert := v_msg_alert;
                  RETURN;
               END IF;
            END IF;

            IF v_msg_alert IS NULL
            THEN
               validate_plate_no (c1.par_id, v_msg_alert, v_msg_icon, c1.par_type);

               IF v_msg_icon = 'E'
               THEN
                  p_msg_alert := v_msg_alert;
                  RETURN;
               END IF;
            END IF;

            IF v_msg_alert IS NULL
            THEN
               validate_serial_motor (c1.par_id, v_msg_alert);

               IF v_msg_alert IS NOT NULL
               THEN
                  p_msg_alert := v_msg_alert;
                  RETURN;
               END IF;
            END IF;

            IF v_msg_alert IS NULL
            THEN
               validate_serial_no (c1.par_id, v_msg_alert, c1.par_type);
            END IF;

            IF v_msg_alert IS NULL
            THEN
               validate_motor_no (c1.par_id, v_msg_alert, c1.par_type);
            END IF;

            IF v_msg_alert IS NULL
            THEN
               validate_coc_serial_no (c1.par_id, v_msg_alert, c1.par_type);
            END IF;
         END IF;
      --validation of cancellation '' is on check_cancel_pack_par_posting
      END LOOP;                                                                                                               --c1
   END;

   PROCEDURE read_into_postpar (p_msg_alert OUT VARCHAR2)
   IS
      v_dummy   giis_parameters.param_value_v%TYPE;
   BEGIN
      --add ko nalang ito for checking lang if lahat may value --nok
      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_AC';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_AV';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_CA';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_EN';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_FI';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MC';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MH';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MN';

      SELECT param_value_v
        INTO v_dummy
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_SU';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert := 'No parameter record found. Please report error to CSD';
         RETURN;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-12-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : INITIALIZE_GLOBAL program unit
   */
   PROCEDURE post_package (
      p_pack_par_id      IN       gipi_parlist.pack_par_id%TYPE,
      p_pack_policy_id   IN       VARCHAR2,
      p_back_endt        IN       VARCHAR2,
      p_msg_alert        OUT      VARCHAR2
   )
   IS
      v_exist            VARCHAR2 (1)                         := 'N';
      v_param            giis_parameters.param_value_v%TYPE;
      v_par_seq_no       gipi_parlist.par_seq_no%TYPE;
      v_par_yy           gipi_parlist.par_yy%TYPE;
      v_par_id           gipi_parlist.par_id%TYPE;
      v_line_cd          gipi_parlist.line_cd%TYPE;
      v_par_type         gipi_parlist.par_type%TYPE;
      v_quote_seq_no     gipi_parlist.quote_seq_no%TYPE;
      v_subline_cd       gipi_wpolbas.subline_cd%TYPE;
      v_pol_stat         gipi_wpolbas.pol_flag%TYPE;
      v_iss_cd           gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy         gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no       gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no         gipi_wpolbas.renew_no%TYPE;
      v_ann_tsi_amt      gipi_wpolbas.ann_tsi_amt%TYPE;
      v_eff_date         gipi_wpolbas.eff_date%TYPE;
      v_open_flag        giis_subline.op_flag%TYPE;
      v_open_policy_sw   giis_subline.open_policy_sw%TYPE;
      v_issue_ri         giis_parameters.param_value_v%TYPE;
      v_pack             gipi_wpolbas.pack_pol_flag%TYPE;
      v_affecting        VARCHAR2 (2000);
      v_policy_id        VARCHAR2 (2000);
      v_user_id          VARCHAR2 (2000);
      v_change_stat      VARCHAR2 (2000);
      v_dist_no          giuw_pol_dist.dist_no%TYPE;
      v_workflow_msg     VARCHAR2 (32000);
      v_prem_seq_no      VARCHAR2 (32000);
      v_dumm_var    VARCHAR2 (32000);
   BEGIN
      FOR c1 IN (SELECT par_id
                   FROM gipi_parlist
                  WHERE pack_par_id = p_pack_par_id AND par_status NOT IN (98, 99))
      LOOP
         v_affecting := '';                                                     -- to reset endt_type when looping subpolicies...

         SELECT par_seq_no, par_yy, par_id, line_cd, par_type, quote_seq_no
           INTO v_par_seq_no, v_par_yy, v_par_id, v_line_cd, v_par_type, v_quote_seq_no
           FROM gipi_parlist
          WHERE par_id = c1.par_id;

         SELECT subline_cd, pol_flag, iss_cd, issue_yy, pol_seq_no, renew_no, ann_tsi_amt, eff_date
           INTO v_subline_cd, v_pol_stat, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_ann_tsi_amt, v_eff_date
           FROM gipi_wpolbas
          WHERE par_id = c1.par_id;

         SELECT op_flag, open_policy_sw
           INTO v_open_flag, v_open_policy_sw
           FROM giis_subline
          WHERE line_cd = v_line_cd AND subline_cd = v_subline_cd;

         FOR a IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'ISS_CD_RI')
         LOOP
            v_issue_ri := a.param_value_v;
            EXIT;
         END LOOP;

         --DETERMINE_PACKAGE;
         FOR a IN (SELECT pack_pol_flag
                     FROM gipi_wpolbas
                    WHERE par_id = c1.par_id)
         LOOP
            v_pack := a.pack_pol_flag;
            EXIT;
         END LOOP;

         --POSTING_PACK_PROCESS;
         read_into_postpar (p_msg_alert);

         IF p_msg_alert IS NOT NULL
         THEN
            RETURN;
         END IF;

         IF v_par_type = 'E'
         THEN
            BEGIN
               IF v_pol_stat = '4' OR v_ann_tsi_amt = 0
               THEN
                  FOR a2 IN (SELECT claim_id
                               FROM gicl_claims
                              WHERE line_cd = v_line_cd
                                AND subline_cd = v_subline_cd
                                --AND iss_cd = :postpar.iss_cd   --bdarusin, jan312003
                                AND pol_iss_cd = v_iss_cd                                                    --bdarusin, jan312003
                                AND issue_yy = v_issue_yy
                                AND pol_seq_no = v_pol_seq_no
                                AND renew_no = v_renew_no
                                AND clm_stat_cd NOT IN ('CC', 'WD', 'DN', 'CD'))
                  LOOP
                     p_msg_alert := 'The policy has pending claims, cannot cancel policy.';
                     RETURN;
                  END LOOP;
               END IF;
            END;

            BEGIN
               FOR s IN (SELECT spld_flag
                           FROM gipi_polbasic
                          WHERE line_cd = v_line_cd
                            AND subline_cd = v_subline_cd
                            AND iss_cd = v_iss_cd
                            AND issue_yy = v_issue_yy
                            AND pol_seq_no = v_pol_seq_no
                            AND renew_no = v_renew_no
                            AND endt_seq_no = 0)
               LOOP
                  IF s.spld_flag = 2
                  THEN
                     p_msg_alert := 'Policy has been tagged for spoilage, cannot post endorsement.';
                     RETURN;
                  END IF;
               END LOOP;
            END;

            BEGIN
               FOR a IN (SELECT 1
                           FROM gipi_winvoice
                          WHERE par_id = c1.par_id)
               LOOP
                  v_affecting := 'A';
               END LOOP;

               IF v_affecting IS NULL
               THEN
                  v_affecting := 'N';
               END IF;
            END;

            IF v_affecting = 'A'
            THEN
               validate_par (v_par_id,
                             v_line_cd,
                             v_subline_cd,
                             v_iss_cd,
                             v_par_seq_no,
                             v_par_yy,
                             v_pack,
                             v_par_type,
                             v_pol_stat,
                             v_affecting,
                             p_msg_alert
                            );

               IF p_msg_alert IS NOT NULL
               THEN
                  RETURN;
               END IF;
            ELSIF v_affecting = 'N'
            THEN
               validate_in_wpolbas (v_par_id, p_msg_alert);

               IF p_msg_alert IS NOT NULL
               THEN
                  RETURN;
               END IF;

               IF v_line_cd = giisp.v ('LINE_CODE_SU')
               THEN
                  validate_wbond_basic (v_par_id, v_affecting, p_msg_alert);

                  IF p_msg_alert IS NOT NULL
                  THEN
                     RETURN;
                  END IF;
               END IF;
            END IF;
         ELSE                                                                                           -- :postpar.par_type = 'P'
            validate_par (v_par_id,
                          v_line_cd,
                          v_subline_cd,
                          v_iss_cd,
                          v_par_seq_no,
                          v_par_yy,
                          v_pack,
                          v_par_type,
                          v_pol_stat,
                          v_affecting,
                          p_msg_alert
                         );

            IF p_msg_alert IS NOT NULL
            THEN
               RETURN;
            END IF;
         END IF;
      END LOOP;

      -- added by andrew 09.12.2012 validation of renewal/replacement in gipi_pack_wpolnrep
      FOR i IN (SELECT pol_flag
                  FROM gipi_pack_wpolbas
                 WHERE pack_par_id = p_pack_par_id)
      LOOP
         IF i.pol_flag = '2'
         THEN
            --validate_renewal;
            BEGIN
               SELECT pack_par_id
                 INTO v_dumm_var
                 FROM gipi_pack_wpolnrep
                WHERE pack_par_id = p_pack_par_id AND ren_rep_sw = '1';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_msg_alert := 'Package PAR should have at least one policy being renewed.';
               WHEN TOO_MANY_ROWS
               THEN
                  NULL;
            END;
         ELSIF i.pol_flag = '3'
         THEN
            --validate_replcment;
            BEGIN
               SELECT rec_flag
                 INTO v_dumm_var
                 FROM gipi_pack_wpolnrep
                WHERE pack_par_id = p_pack_par_id AND ren_rep_sw = '2';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_msg_alert := 'Package PAR should have at least one policy being replaced.';
               WHEN TOO_MANY_ROWS
               THEN
                  NULL;
            END;
         END IF;
      END LOOP;

      IF p_msg_alert IS NOT NULL
      THEN
         RETURN;
      END IF;
      -- end andrew 09.12.2012
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-12-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : INITIALIZE_GLOBAL program unit
   */
   PROCEDURE post_par_package (
      p_pack_par_id      IN       gipi_parlist.pack_par_id%TYPE,
      p_pack_policy_id   IN       VARCHAR2,
      p_back_endt        IN       VARCHAR2,
      p_msg_alert        OUT      VARCHAR2,
      p_change_stat      IN       VARCHAR2
   )
   IS
      v_exist            VARCHAR2 (1)                         := 'N';
      v_param            giis_parameters.param_value_v%TYPE;
      v_par_seq_no       gipi_parlist.par_seq_no%TYPE;
      v_par_yy           gipi_parlist.par_yy%TYPE;
      v_par_id           gipi_parlist.par_id%TYPE;
      v_line_cd          gipi_parlist.line_cd%TYPE;
      v_par_type         gipi_parlist.par_type%TYPE;
      v_quote_seq_no     gipi_parlist.quote_seq_no%TYPE;
      v_subline_cd       gipi_wpolbas.subline_cd%TYPE;
      v_pol_stat         gipi_wpolbas.pol_flag%TYPE;
      v_iss_cd           gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy         gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no       gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no         gipi_wpolbas.renew_no%TYPE;
      v_ann_tsi_amt      gipi_wpolbas.ann_tsi_amt%TYPE;
      v_eff_date         gipi_wpolbas.eff_date%TYPE;
      v_open_flag        giis_subline.op_flag%TYPE;
      v_open_policy_sw   giis_subline.open_policy_sw%TYPE;
      v_issue_ri         giis_parameters.param_value_v%TYPE;
      v_pack             gipi_wpolbas.pack_pol_flag%TYPE;
      v_affecting        VARCHAR2 (2000);
      v_policy_id        VARCHAR2 (2000);
      v_user_id          VARCHAR2 (2000);
      v_change_stat      VARCHAR2 (2000)                      := p_change_stat;
      v_dist_no          giuw_pol_dist.dist_no%TYPE;
      v_workflow_msg     VARCHAR2 (32000);
      v_prem_seq_no      VARCHAR2 (32000);
   BEGIN
      FOR c1 IN (SELECT par_id
                   FROM gipi_parlist
                  WHERE pack_par_id = p_pack_par_id AND par_status NOT IN (98, 99))
      LOOP
         v_affecting := '';                                                     -- to reset endt_type when looping subpolicies...

         SELECT par_seq_no, par_yy,                                                                                      --iss_cd,
                                   par_id, line_cd, par_type, quote_seq_no
           INTO v_par_seq_no, v_par_yy,                                                                         --:postpar.iss_cd,
                                       v_par_id, v_line_cd, v_par_type, v_quote_seq_no
           FROM gipi_parlist
          WHERE par_id = c1.par_id;

         SELECT subline_cd, pol_flag, iss_cd, issue_yy, pol_seq_no, renew_no, ann_tsi_amt, eff_date
           INTO v_subline_cd, v_pol_stat, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_ann_tsi_amt, v_eff_date
           FROM gipi_wpolbas
          WHERE par_id = c1.par_id;

         SELECT op_flag, open_policy_sw
           INTO v_open_flag, v_open_policy_sw
           FROM giis_subline
          WHERE line_cd = v_line_cd AND subline_cd = v_subline_cd;

         FOR a IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'ISS_CD_RI')
         LOOP
            v_issue_ri := a.param_value_v;
            EXIT;
         END LOOP;

         --DETERMINE_PACKAGE;
         FOR a IN (SELECT pack_pol_flag
                     FROM gipi_wpolbas
                    WHERE par_id = c1.par_id)
         LOOP
            v_pack := a.pack_pol_flag;
            EXIT;
         END LOOP;

         --posting_process
         read_into_postpar (p_msg_alert);

         IF p_msg_alert IS NOT NULL
         THEN
            RETURN;
         END IF;

         IF v_par_type = 'E'
         THEN
            BEGIN
               IF v_pol_stat = '4' OR v_ann_tsi_amt = 0
               THEN
                  FOR a2 IN (SELECT claim_id
                               FROM gicl_claims
                              WHERE line_cd = v_line_cd
                                AND subline_cd = v_subline_cd
                                --AND iss_cd = :postpar.iss_cd   --bdarusin, jan312003
                                AND pol_iss_cd = v_iss_cd                                                    --bdarusin, jan312003
                                AND issue_yy = v_issue_yy
                                AND pol_seq_no = v_pol_seq_no
                                AND renew_no = v_renew_no
                                AND clm_stat_cd NOT IN ('CC', 'WD', 'DN', 'CD'))
                  LOOP
                     p_msg_alert := 'The policy has pending claims, cannot cancel policy.';
                     RETURN;
                  END LOOP;
               END IF;
            END;

            update_pending_claims (v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date);

            BEGIN
               FOR s IN (SELECT spld_flag
                           FROM gipi_polbasic
                          WHERE line_cd = v_line_cd
                            AND subline_cd = v_subline_cd
                            AND iss_cd = v_iss_cd
                            AND issue_yy = v_issue_yy
                            AND pol_seq_no = v_pol_seq_no
                            AND renew_no = v_renew_no
                            AND endt_seq_no = 0)
               LOOP
                  IF s.spld_flag = 2
                  THEN
                     p_msg_alert := 'Policy has been tagged for spoilage, cannot post endorsement.';
                     RETURN;
                  END IF;
               END LOOP;
            END;

            BEGIN
               FOR a IN (SELECT 1
                           FROM gipi_winvoice
                          WHERE par_id = c1.par_id)
               LOOP
                  v_affecting := 'A';
               END LOOP;

               IF v_affecting IS NULL
               THEN
                  v_affecting := 'N';
               END IF;
            END;

            IF v_affecting = 'A'
            THEN
               validate_par (v_par_id,
                             v_line_cd,
                             v_subline_cd,
                             v_iss_cd,
                             v_par_seq_no,
                             v_par_yy,
                             v_pack,
                             v_par_type,
                             v_pol_stat,
                             v_affecting,
                             p_msg_alert
                            );

               IF p_msg_alert IS NOT NULL
               THEN
                  RETURN;
               END IF;
            ELSIF v_affecting = 'N'
            THEN
               validate_in_wpolbas (v_par_id, p_msg_alert);

               IF p_msg_alert IS NOT NULL
               THEN
                  RETURN;
               END IF;

               IF v_line_cd = giisp.v ('LINE_CODE_SU')
               THEN
                  validate_wbond_basic (v_par_id, v_affecting, p_msg_alert);

                  IF p_msg_alert IS NOT NULL
                  THEN
                     RETURN;
                  END IF;
               END IF;
            END IF;
         ELSE                                                                                           -- :postpar.par_type = 'P'
            validate_par (v_par_id,
                          v_line_cd,
                          v_subline_cd,
                          v_iss_cd,
                          v_par_seq_no,
                          v_par_yy,
                          v_pack,
                          v_par_type,
                          v_pol_stat,
                          v_affecting,
                          p_msg_alert
                         );

            IF p_msg_alert IS NOT NULL
            THEN
               RETURN;
            END IF;
         END IF;

         v_change_stat := p_change_stat;
         post_pol_par (v_par_id,
                       v_line_cd,
                       v_iss_cd,
                       giis_users_pkg.app_user,
                       v_change_stat,
                       v_policy_id,
                       p_pack_policy_id,
                       p_msg_alert,
                       v_user_id,
                       v_prem_seq_no
                      );

         IF p_msg_alert IS NOT NULL
         THEN
            RETURN;
         END IF;

         IF v_par_type = 'E'
         THEN
            IF p_back_endt = 'Y'
            THEN
               upd_back_endt (v_par_id, p_msg_alert);

               IF p_msg_alert IS NOT NULL
               THEN
                  RETURN;
               END IF;
            END IF;
         END IF;

         insert_parhist (v_par_id, giis_users_pkg.app_user);

         --update_par_status(v_par_id);
         --comment '' code above - niknok 10.27.11
         FOR a IN (SELECT        par_id, par_status
                            FROM gipi_parlist
                           WHERE par_id = v_par_id
                   FOR UPDATE OF par_id, par_status)
         LOOP
            UPDATE gipi_parlist
               SET par_status = 10
             WHERE par_id = v_par_id;

            EXIT;
         END LOOP;

         posting_process_c (v_par_id, v_line_cd, v_iss_cd, v_policy_id, giis_users_pkg.app_user, v_dist_no, p_msg_alert);

         IF p_msg_alert IS NOT NULL
         THEN
            RETURN;
         END IF;

         update_quote (v_par_id, giis_users_pkg.app_user);
         delete_par (v_par_id, v_line_cd, v_iss_cd);
         posting_process_e (v_par_id, giis_users_pkg.app_user, p_msg_alert, v_workflow_msg);

         IF v_workflow_msg IS NOT NULL
         THEN
            v_workflow_msg := v_workflow_msg || '-*|@geniisys@|*-' || v_workflow_msg;
         END IF;

         IF p_msg_alert IS NOT NULL
         THEN
            RETURN;
         END IF;

         IF p_back_endt = 'Y'
         THEN
            UPDATE gipi_polbasic
               SET back_stat = 2
             WHERE par_id = v_par_id;
         ELSIF p_back_endt = 'N'
         THEN
            UPDATE gipi_polbasic
               SET back_stat = 1
             WHERE par_id = v_par_id;
         END IF;
      END LOOP;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-12-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : COPY_PACK_POL_WINVOICE program unit
   */
   PROCEDURE copy_pack_pol_winvoice (
      p_pack_par_id      IN       gipi_parlist.pack_par_id%TYPE,
      p_iss_cd           IN       gipi_parlist.iss_cd%TYPE,
      p_pack_policy_id   IN       VARCHAR2,
      p_msg_alert        OUT      VARCHAR2
   )
   IS
      p_exist              NUMBER;
      prem_seq             NUMBER;
      v_pack               gipi_wpolbas.pack_pol_flag%TYPE;
      v_pack_prem_seq_no   gipi_invoice.prem_seq_no%TYPE;

      CURSOR invoice_cur
      IS
         SELECT item_grp, property, prem_amt, tax_amt, payt_terms, insured, due_date, currency_cd, currency_rt, remarks,
                other_charges, ri_comm_amt, ref_inv_no, notarial_fee, policy_currency, bond_rate, bond_tsi_amt, ri_comm_vat
           FROM gipi_pack_winvoice
          WHERE pack_par_id = p_pack_par_id;
   BEGIN
      IF giisp.v ('ISS_CD_RI') = p_iss_cd
      THEN
         FOR a IN (SELECT '1'
                     FROM giri_inpolbas
                    WHERE EXISTS (SELECT 1
                                    FROM gipi_polbasic z
                                   WHERE z.policy_id = giri_inpolbas.policy_id AND z.pack_policy_id = p_pack_policy_id))
         LOOP
            p_exist := 1;
            EXIT;
         END LOOP;

         IF p_exist IS NULL
         THEN
            p_msg_alert := 'Please enter the initial acceptance.';
            RETURN;
         END IF;
      END IF;

      FOR invoice_cur_rec IN invoice_cur
      LOOP
         BEGIN
            --A.R.C. 01.16.2007
            --replaced by the code below
            --prem_seq_no of package should be the 1st prem_seq_no of the child
            /*FOR A IN (
                SELECT prem_seq_no
              FROM giis_prem_seq
                 WHERE iss_cd = :b240.iss_cd) LOOP
              prem_seq := A.prem_seq_no+1;
              EXIT;
            END LOOP;*/
            FOR a IN (SELECT MIN (prem_seq_no) prem_seq_no
                        FROM gipi_invoice a
                       WHERE EXISTS (SELECT 1
                                       FROM gipi_polbasic z
                                      WHERE z.policy_id = a.policy_id AND z.pack_policy_id = p_pack_policy_id))
            LOOP
               v_pack_prem_seq_no := a.prem_seq_no;
               EXIT;
            END LOOP;

            INSERT INTO gipi_pack_invoice
                        (iss_cd, policy_id, item_grp, property,
                         prem_amt, tax_amt, payt_terms, insured,
                         user_id, last_upd_date, due_date, ri_comm_amt,
                         currency_cd, prem_seq_no, ref_inv_no,                                                             -- beth
                         currency_rt, remarks, other_charges,
                         notarial_fee, policy_currency, bond_rate,
                         bond_tsi_amt, ri_comm_vat
                        )
                 VALUES (p_iss_cd, p_pack_policy_id, invoice_cur_rec.item_grp, invoice_cur_rec.property,
                         invoice_cur_rec.prem_amt, invoice_cur_rec.tax_amt, invoice_cur_rec.payt_terms, invoice_cur_rec.insured,
                         NVL (giis_users_pkg.app_user, USER), SYSDATE, invoice_cur_rec.due_date, invoice_cur_rec.ri_comm_amt,
                         invoice_cur_rec.currency_cd,
                                                     /*nvl(prem_seq,1)*/
                                                     v_pack_prem_seq_no, invoice_cur_rec.ref_inv_no,           --A.R.C. 01.16.2007
                         invoice_cur_rec.currency_rt, invoice_cur_rec.remarks, invoice_cur_rec.other_charges,
                         invoice_cur_rec.notarial_fee, invoice_cur_rec.policy_currency, invoice_cur_rec.bond_rate,
                         invoice_cur_rec.bond_tsi_amt, invoice_cur_rec.ri_comm_vat
                        );
         /* This statement has been revised since the GIIS_GIISSEQ table
         ** has already been replaced by several parameter tables such
         ** as the giis_prem_seq which would generate the prem_seq_no
         ** to be used by this procedure.
         */
         --A.R.C. 01.16.2007
         /*FOR A IN (
             SELECT prem_seq_no
           FROM giis_prem_seq
              WHERE iss_cd = :b240.iss_cd) LOOP
           variables.pack_prem_seq_no := a.prem_seq_no+1;
           EXIT;
         END LOOP;*/
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               p_msg_alert :=
                     'Duplicate record on GIPI_PACK_INVOICE with ISS_CD = '
                  || p_iss_cd
                  || ' and PREM_SEQ_NO = '
                  || TO_CHAR (prem_seq)
                  || '.';
         END;

         gipi_pack_winvperl_pkg.copy_pack_pol_winvperl (invoice_cur_rec.item_grp, p_pack_par_id, p_iss_cd, v_pack_prem_seq_no);
         gipi_pack_winstallment_pkg.copy_pack_pol_winstallment (invoice_cur_rec.item_grp,
                                                                p_pack_par_id,
                                                                p_iss_cd,
                                                                v_pack_prem_seq_no
                                                               );
         gipi_pack_winv_tax_pkg.copy_pack_pol_winv_tax (invoice_cur_rec.item_grp, p_pack_par_id, v_pack_prem_seq_no);

         --di ko sure kung tama ito eh dapat kasi mag loop sa mga par - nok :D
         FOR inv IN (SELECT a.par_id, a.iss_cd, a.pack_pol_flag, b.policy_id
                       FROM gipi_wpolbas a, gipi_polbasic b
                      WHERE a.pack_par_id = p_pack_par_id AND a.par_id = b.par_id)
         LOOP
            FOR prem IN (SELECT prem_seq_no
                           FROM gipi_invoice a
                          WHERE EXISTS (
                                   SELECT 1
                                     FROM gipi_polbasic z
                                    WHERE z.policy_id = a.policy_id
                                      AND z.pack_policy_id = p_pack_policy_id
                                      AND z.par_id = inv.par_id))
            LOOP
               IF inv.pack_pol_flag = 'Y'
               THEN
                  copy_pol_wpackage_inv_tax (invoice_cur_rec.item_grp, inv.par_id, inv.iss_cd, prem.prem_seq_no, inv.policy_id);
               END IF;

               EXIT;
            END LOOP;
         END LOOP;
      END LOOP;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-13-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : DELETE_PACK program unit
   */
   PROCEDURE delete_pack (p_pack_par_id gipi_parlist.pack_par_id%TYPE, p_par_type gipi_parlist.par_type%TYPE)
   IS
   BEGIN
      gipi_pack_wpolnrep_pkg.del_gipi_pack_wpolnreps (p_pack_par_id);
      gipi_pack_winvperl_pkg.del_gipi_pack_winvperl (p_pack_par_id);
      gipi_pack_winv_tax_pkg.del_gipi_pack_winv_tax (p_pack_par_id);
      gipi_pack_winstallment_pkg.del_gipi_pack_winstallment (p_pack_par_id);
      gipi_pack_winvoice_pkg.del_gipi_pack_winvoice (p_pack_par_id);
      gipi_pack_wpolwc_pkg.del_gipi_pack_wpolwc (p_pack_par_id);
      giri_pack_winpolbas_pkg.del_giri_pack_winpolbas (p_pack_par_id);
      gipi_pack_wendttext_pkg.del_gipi_pack_wendttext (p_pack_par_id);
      gipi_pack_wpolgenin_pkg.del_gipi_pack_wpolgenin (p_pack_par_id);
      gipi_wpack_line_subline_pkg.del_gipi_wpack_line_subline (p_pack_par_id);
      gipi_pack_wpolbas_pkg.del_gipi_pack_wpolbas (p_pack_par_id);

      IF p_par_type = 'P'
      THEN
         delete_workflow_rec ('Package Policy - Ready for Posting', 'GIPIS085', giis_users_pkg.app_user, p_pack_par_id);
         delete_other_workflow_rec ('Package Policy - Ready for Posting', 'GIPIS085', giis_users_pkg.app_user, p_pack_par_id);
      ELSIF p_par_type = 'E'
      THEN
         delete_workflow_rec ('Package Endorsement - Ready for Posting', 'GIPIS085', giis_users_pkg.app_user, p_pack_par_id);
         delete_other_workflow_rec ('Package Endorsement - Ready for Posting', 'GIPIS085', giis_users_pkg.app_user,
                                    p_pack_par_id);
      END IF;
   --FORMS_DDL('COMMIT');
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-13-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : check if it is backward endt.
   */
   FUNCTION check_back_endt_pack (p_pack_par_id gipi_parlist.pack_par_id%TYPE)
      RETURN VARCHAR2
   IS
      v_back_endt   VARCHAR2 (1) := 'N';
   BEGIN
      FOR pol IN (SELECT   '1'
                      FROM gipi_pack_polbasic b250, gipi_pack_wpolbas b540
                     WHERE b250.line_cd = b540.line_cd
                       AND b250.subline_cd = b540.subline_cd
                       AND b250.iss_cd = b540.iss_cd
                       AND b250.issue_yy = b540.issue_yy
                       AND b250.pol_seq_no = b540.pol_seq_no
                       AND b250.renew_no = b540.renew_no
                       AND TRUNC (b250.eff_date) > TRUNC (b540.eff_date)
                       AND b250.pol_flag IN ('1', '2', '3')
                       AND NVL (b250.endt_expiry_date, b250.expiry_date) >= b540.eff_date
                       AND b540.pack_par_id = p_pack_par_id
                       AND b540.pol_flag IN ('1', '2', '3')
                  ORDER BY b250.eff_date DESC)
      LOOP
         v_back_endt := 'Y';
         EXIT;
      END LOOP;

      RETURN v_back_endt;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 08-04-2011
   **  Reference By : (GIPIS055 - POST  PAR)
   **  Description  : calling CANCEL_ALERT '' alert
   */
   FUNCTION check_cancel_par_posting (p_par_id gipi_wpolbas.par_id%TYPE)
      RETURN cancel_msg_tab PIPELINED
   IS
      v_par_type      gipi_parlist.par_type%TYPE;
      v_line_cd       gipi_polbasic.line_cd%TYPE;
      v_subline_cd    gipi_polbasic.subline_cd%TYPE;
      v_iss_cd        gipi_polbasic.iss_cd%TYPE;
      v_issue_yy      gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no      gipi_polbasic.renew_no%TYPE;
      v_pol_flag      gipi_polbasic.pol_flag%TYPE;
      v_ann_tsi_amt   gipi_polbasic.ann_tsi_amt%TYPE;
      v_endt_type     gipi_polbasic.endt_type%TYPE;
      v_msg_list      cancel_msg_type;
   BEGIN
      FOR a IN (SELECT par_type
                  FROM gipi_parlist
                 WHERE par_id = p_par_id)
      LOOP
         v_par_type := a.par_type;
      END LOOP;

      FOR dt IN (SELECT line_cd, subline_cd, iss_cd, pol_seq_no, issue_yy, renew_no, pol_flag, ann_tsi_amt, endt_type
                   FROM gipi_wpolbas
                  WHERE par_id = p_par_id)
      LOOP
         v_line_cd := dt.line_cd;
         v_subline_cd := dt.subline_cd;
         v_iss_cd := dt.iss_cd;
         v_issue_yy := dt.issue_yy;
         v_pol_seq_no := dt.pol_seq_no;
         v_renew_no := dt.renew_no;
         v_pol_flag := dt.pol_flag;
         v_ann_tsi_amt := dt.ann_tsi_amt;
         v_endt_type := dt.endt_type;
         EXIT;
      END LOOP;

      -- for SOA
      BEGIN
         SELECT DISTINCT 'A'
                    INTO v_endt_type
                    FROM gipi_winvoice
                   WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_endt_type := 'N';
      END;

      --end SOA
      IF v_pol_flag <> '4' AND v_ann_tsi_amt = 0 AND v_par_type = 'E' AND v_endt_type <> 'N'
      THEN
         v_msg_list.msg_alert :=
            'Effectve TSI for this policy is zero. This will cause to change your policy status as cancellation endorsement.  Continue?';
         PIPE ROW (v_msg_list);
      END IF;

      IF v_pol_flag = '4' AND v_ann_tsi_amt = 0 AND v_par_type = 'E' AND v_endt_type <> 'N'
      THEN
         FOR a IN (SELECT SUM (c.total_payments) paid_amt
                     FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
                    WHERE a.line_cd = v_line_cd
                      AND a.subline_cd = v_subline_cd
                      AND a.iss_cd = v_iss_cd
                      AND a.issue_yy = v_issue_yy
                      AND a.pol_seq_no = v_pol_seq_no
                      AND a.renew_no = v_renew_no
                      AND a.pol_flag IN ('1', '2', '3')
                      AND a.policy_id = b.policy_id
                      AND b.iss_cd = c.iss_cd
                      AND b.prem_seq_no = c.prem_seq_no)
         LOOP
            IF a.paid_amt <> 0
            THEN
               v_msg_list.msg_alert := 'Payments have been made to the policy to be cancelled. Continue?';
               PIPE ROW (v_msg_list);
            END IF;
         END LOOP;
      END IF;

      RETURN;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 11-15-2011
   **  Reference By : (GIPIS055a - POST PACK PAR)
   **  Description  : calling CANCEL_ALERT '' alert
   */
   FUNCTION check_cancel_pack_par_posting (p_pack_par_id gipi_parlist.pack_par_id%TYPE)
      RETURN cancel_msg_tab PIPELINED
   IS
      v_par_type      gipi_parlist.par_type%TYPE;
      v_line_cd       gipi_polbasic.line_cd%TYPE;
      v_subline_cd    gipi_polbasic.subline_cd%TYPE;
      v_iss_cd        gipi_polbasic.iss_cd%TYPE;
      v_issue_yy      gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no      gipi_polbasic.renew_no%TYPE;
      v_pol_flag      gipi_polbasic.pol_flag%TYPE;
      v_ann_tsi_amt   gipi_polbasic.ann_tsi_amt%TYPE;
      v_endt_type     gipi_polbasic.endt_type%TYPE;
      v_policy_no     VARCHAR2 (3200);
      v_msg_list      cancel_msg_type;
   --v_op_switch      VARCHAR2 (1)                         := 'N';
   BEGIN
      FOR c1 IN (SELECT par_id, line_cd, iss_cd, par_type
                   FROM gipi_parlist
                  WHERE pack_par_id = p_pack_par_id AND par_status NOT IN (98, 99))
      LOOP
         FOR dt IN (SELECT TRUNC (eff_date) eff_date, line_cd, subline_cd, iss_cd, pol_seq_no, issue_yy, renew_no, pol_flag,
                           ann_tsi_amt, endt_type, booking_year, booking_mth,                            -- added by kim 01/05/05
                                                                             NVL (takeup_term, 'ST') takeup_term
                      FROM gipi_wpolbas
                     WHERE par_id = c1.par_id)
         LOOP
            v_line_cd := dt.line_cd;
            v_subline_cd := dt.subline_cd;
            v_iss_cd := dt.iss_cd;
            v_issue_yy := dt.issue_yy;
            v_pol_seq_no := dt.pol_seq_no;
            v_renew_no := dt.renew_no;
            v_pol_flag := dt.pol_flag;
            v_ann_tsi_amt := dt.ann_tsi_amt;
            --v_endt_type         := dt.endt_type;
            v_policy_no :=
                  v_line_cd
               || ' - '
               || v_subline_cd
               || ' - '
               || v_iss_cd
               || ' - '
               || TO_CHAR (v_issue_yy, '09')
               || ' - '
               || TO_CHAR (v_pol_seq_no, '0999999')
               || ' - '
               || TO_CHAR (v_renew_no, '09');
            EXIT;
         END LOOP;

         FOR d IN (SELECT a.par_type par_type, c.op_flag op_flag
                     FROM gipi_parlist a, gipi_wpolbas b, giis_subline c
                    WHERE a.par_id = b.par_id AND b.subline_cd = c.subline_cd AND b.line_cd = c.line_cd AND a.par_id = c1.par_id)
         LOOP
            v_par_type := d.par_type;
            --v_op_switch := d.op_flag;
            EXIT;
         END LOOP;

         --added by d.alcantara, 03-12-2011
         BEGIN
            SELECT DISTINCT 'A'
                       INTO v_endt_type
                       FROM gipi_winvoice
                      WHERE par_id = c1.par_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_endt_type := 'N';
         END;

         DBMS_OUTPUT.put_line (v_pol_flag || ' :: ' || v_ann_tsi_amt);

         -- edited by d.alcantara. 03-12-2012, added comparison to par_Type and endt_type
         IF v_pol_flag <> '4' AND v_ann_tsi_amt = 0 AND v_par_type = 'E' AND v_endt_type <> 'N'    /*comment out dannel 10162006*/
         THEN
            v_msg_list.msg_alert :=
                  'Effectve TSI for subpolicy '
               || v_policy_no
               || ' is zero. This will cause to change your subpolicy status as cancellation endorsement.  Continue?';
            PIPE ROW (v_msg_list);
         END IF;

         /*bdarusin, jan172003
           display a warning before cancelling a paid policy*/
         IF v_pol_flag = '4' AND v_ann_tsi_amt = 0                           /*AND v_endt_type <> 'N'comment out dannel 10162006*/
         THEN
            FOR a IN (SELECT SUM (c.total_payments) paid_amt
                        FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
                       WHERE a.line_cd = v_line_cd
                         AND a.subline_cd = v_subline_cd
                         AND a.iss_cd = v_iss_cd
                         AND a.issue_yy = v_issue_yy
                         AND a.pol_seq_no = v_pol_seq_no
                         AND a.renew_no = v_renew_no
                         AND a.pol_flag IN ('1', '2', '3')
                         AND a.policy_id = b.policy_id
                         AND b.iss_cd = c.iss_cd
                         AND b.prem_seq_no = c.prem_seq_no)
            LOOP
               IF a.paid_amt <> 0
               THEN
                  v_msg_list.msg_alert := 'Payments have been made to the policy to be cancelled. Continue?';
                  PIPE ROW (v_msg_list);
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      RETURN;
   END check_cancel_pack_par_posting;
   
   /*
   **  Created by   : John Daniel Marasigan
   **  Date Created : 06-29-2016
   **  Reference By : (GIPIS055 - POST  PAR)
   **  Description  : used in posting_package_per_par; SR-5539
   **				  updates issue year based on booking_pol_yy and pol_no issue_yy parameters
   */
   PROCEDURE get_correct_iss_yy(p_pack_par_id      gipi_parlist.pack_par_id%TYPE) --added by John Daniel; 06.29.2016; used in posting_package_per_par 
   AS   
        v_pack_par_id           gipi_pack_wpolbas.pack_par_id%TYPE;
        v_correct_iss_yy        gipi_pack_polbasic.issue_yy%TYPE;
        v_same_polno_sw         gipi_pack_wpolbas.same_polno_sw%TYPE;
        v_endt_yy               gipi_pack_wpolbas.endt_yy%TYPE;  
        v_booking_mth           gipi_pack_wpolbas.booking_mth%TYPE;
        v_booking_year          gipi_pack_wpolbas.booking_year%TYPE;
        v_incept_date           gipi_pack_wpolbas.incept_date%TYPE;
        v_issue_date            gipi_pack_wpolbas.issue_date%TYPE;  
        v_msg_out               VARCHAR2(2);             
   BEGIN   
        BEGIN 
            SELECT same_polno_sw, endt_yy, booking_mth, booking_year, incept_date, issue_date
            INTO v_same_polno_sw, v_endt_yy, v_booking_mth, v_booking_year, v_incept_date, v_issue_date
            FROM gipi_pack_wpolbas
            WHERE pack_par_id = p_pack_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Package Policy not found. PAR ID: '||v_pack_par_id);    
        END;
        
        IF v_same_polno_sw != 'Y' AND v_endt_yy = 0 THEN
            Get_Issue_Yy_Gipis002(v_booking_mth, 
                                  v_booking_year, 
                                  TO_CHAR (v_incept_date,'MM-DD-YYYY'), 
                                  TO_CHAR (v_issue_date, 'MM-DD-YYYY'), 
                                  v_correct_iss_yy, 
                                  v_msg_out);
                          
            IF NVL(v_msg_out,'N') = 'Y' THEN
                RAISE_APPLICATION_ERROR (-20010, 'Error in generating the issue year for the policy.', TRUE);
            ELSE
                UPDATE gipi_pack_wpolbas
                SET issue_yy = v_correct_iss_yy
                WHERE pack_par_id = p_pack_par_id;
                
                UPDATE gipi_wpolbas
                SET issue_yy = v_correct_iss_yy
                WHERE pack_par_id = p_pack_par_id;
            END IF;
        END IF;
   EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, SQLERRM);   
   END get_correct_iss_yy;
END package_posting_pkg;
/
