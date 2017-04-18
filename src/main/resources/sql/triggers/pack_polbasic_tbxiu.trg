DROP TRIGGER CPI.PACK_POLBASIC_TBXIU;

CREATE OR REPLACE TRIGGER CPI.PACK_POLBASIC_TBXIU
   BEFORE INSERT OR UPDATE
   ON CPI.GIPI_PACK_POLBASIC    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
--
-- Generate the next sequence of pol_seq_no per line_cd, subline_cd,
-- iss_cd, issue_yy and renew_no or the next sequence of endt_seq_no per
-- line_cd, subline_cd, iss_cd, issue_yy, renew_no, endt_iss_cd
-- and endt_yy to be use in policy/endorsement creation. Updated the tables
-- below based on the amounts of the policy/endorsement.
--
-- TABLES AFFECTED         TRANSACTION TYPE    COLUMNS
--
-- giis_pol_seq            update/insert    pol_seq_no
--                                 user_id
--                                 last_update
--
-- giis_endt_seq            update/insert    endt_seq_no
--                                 user_id
--                                 last_update
--
-- giac_aging_totals         update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_summaries     update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_soa_summaries        update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_assd_line     update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_line_totals   update         balance_amt_due
--                        prem_balance_due
--                        tax_balance_due
--
-- giac_aging_soa_details   delete        all
--
   v_par_type      GIPI_PARLIST.par_type%TYPE;
   same_sw         VARCHAR2 (1)                         := 'N';
   p_exist         VARCHAR2 (1)                         := 'N';
   -- for policy
   p_exist1        VARCHAR2 (1)                         := 'N';
   -- for endorsement
   p_exist2        VARCHAR2 (1)                         := 'N';
   -- for assured
   p_exist3        VARCHAR2 (1)                         := 'N';
   -- for issource
   p_pol_seq_no    NUMBER                               := 9999999;
   p_endt_seq_no   NUMBER                               := 999999;
   p_year          NUMBER;
   p_mm            NUMBER;
   p_val           NUMBER;
   p_ind           VARCHAR2 (1)                         := 'N';
   p_prem          GIPI_POLBASIC.prem_amt%TYPE;
   p_tsi           GIPI_POLBASIC.tsi_amt%TYPE;
   p_yr            DATE;
   p_old_tsi       GIPI_POLBASIC.tsi_amt%TYPE           := :OLD.tsi_amt;
   p_old_prem      GIPI_POLBASIC.prem_amt%TYPE          := :OLD.prem_amt;
   p_old_flag      GIPI_POLBASIC.pol_flag%TYPE          := :OLD.pol_flag;
   v_ri            GIIS_PARAMETERS.param_value_v%TYPE;
   v_rb            GIIS_PARAMETERS.param_value_v%TYPE;
   v_gif           GIIS_PARAMETERS.param_value_v%TYPE;
   v_gr            GIIS_PARAMETERS.param_value_v%TYPE;
   v_iss_cd        GIPI_POLBASIC.iss_cd%TYPE;
   v_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE;
   v_assd_no       GIPI_PARLIST.assd_no%TYPE;
BEGIN
   p_exist := 'N';
   p_exist1 := 'N';
   same_sw := 'N';
   :NEW.user_id := NVL (giis_users_pkg.app_user, USER); -- andrew 07.20.2011 - use the application user (geniisys web), if null use the database user

   FOR a IN (SELECT par_type
               FROM GIPI_PACK_PARLIST
              WHERE pack_par_id = :NEW.pack_par_id)
   LOOP
      v_par_type := a.par_type;
      EXIT;
   END LOOP;

/* commented out by petermkaw 02012011
  IF ((v_par_type = 'P') AND (INSERTING)) THEN
    --BETH 102299 for renewal which will use same policy no
    --            by pass extract and update of pol_seq_no
    FOR renew IN (SELECT '1'
                    FROM gipi_pack_wpolbas
                   WHERE pack_par_id = :NEW.pack_par_id AND NVL (same_polno_sw, 'N') = 'Y' AND NVL (pol_flag, '1') IN ('2', '3')) LOOP
      same_sw := 'Y';
    END LOOP;

    IF same_sw = 'N' THEN
      FOR a1 IN (SELECT        pol_seq_no, ROWID
                          FROM giis_pack_pol_seq
                         WHERE line_cd = :NEW.line_cd
                           AND subline_cd = :NEW.subline_cd
                           AND iss_cd = :NEW.iss_cd
                           AND issue_yy = :NEW.issue_yy
                 -- removed 02/09/2001 by rbd
                         -- AND renew_no   =  :NEW.renew_no
                 FOR UPDATE OF pol_seq_no) LOOP
        IF a1.pol_seq_no < p_pol_seq_no THEN
          :NEW.pol_seq_no := a1.pol_seq_no + 1;

          UPDATE giis_pack_pol_seq
             SET pol_seq_no = :NEW.pol_seq_no,
                 user_id = :NEW.user_id,
                 last_update = :NEW.last_upd_date
           WHERE ROWID = a1.ROWID;

          p_exist := 'Y';
        ELSE
          :NEW.pol_seq_no := 1;

          UPDATE giis_pack_pol_seq
             SET pol_seq_no = 1,
                 user_id = :NEW.user_id,
                 last_update = :NEW.last_upd_date
           WHERE ROWID = a1.ROWID;

          p_exist := 'Y';
        END IF;
      END LOOP;

      IF p_exist = 'N' THEN
        :NEW.pol_seq_no := 1;

        INSERT INTO giis_pack_pol_seq
                    (line_cd, iss_cd, issue_yy, subline_cd, pol_seq_no, renew_no, user_id,
                     last_update
                    )
             VALUES (:NEW.line_cd, :NEW.iss_cd, :NEW.issue_yy, :NEW.subline_cd, :NEW.pol_seq_no, :NEW.renew_no, :NEW.user_id,
                     :NEW.last_upd_date
                    );
      END IF;
    END IF;
  ELSIF ((v_par_type = 'E') AND (INSERTING)) THEN
    FOR a1 IN (SELECT MAX (endt_seq_no) endt_seq_no
                 FROM giis_endt_seq
                WHERE line_cd = :NEW.line_cd
                  AND subline_cd = :NEW.subline_cd
                  AND iss_cd = :NEW.iss_cd
                  AND issue_yy = :NEW.issue_yy
                  AND pol_seq_no = :NEW.pol_seq_no
                  AND renew_no = :NEW.renew_no
                  AND endt_iss_cd = :NEW.endt_iss_cd) LOOP
      FOR a2 IN (SELECT        endt_seq_no, ROWID
                          FROM giis_endt_seq
                         WHERE line_cd = :NEW.line_cd
                           AND subline_cd = :NEW.subline_cd
                           AND iss_cd = :NEW.iss_cd
                           AND issue_yy = :NEW.issue_yy
                           AND pol_seq_no = :NEW.pol_seq_no
                           AND renew_no = :NEW.renew_no
                           AND endt_iss_cd = :NEW.endt_iss_cd
                           AND endt_yy = :NEW.endt_yy
                 FOR UPDATE OF endt_seq_no) LOOP
        --       IF A2.ENDT_SEQ_NO < p_endt_seq_no THEN
        :NEW.endt_seq_no := a1.endt_seq_no + 1;

        UPDATE giis_endt_seq
           SET endt_seq_no = :NEW.endt_seq_no,
               user_id = :NEW.user_id,
               last_update = :NEW.last_upd_date
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

      IF p_exist1 = 'N' THEN
        :NEW.endt_seq_no := NVL (a1.endt_seq_no, 0) + 1;

        INSERT INTO giis_endt_seq
                    (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                     endt_iss_cd, endt_yy, endt_seq_no, user_id, last_update
                    )
             VALUES (:NEW.line_cd, :NEW.subline_cd, :NEW.iss_cd, :NEW.issue_yy, :NEW.pol_seq_no, :NEW.renew_no,
                     :NEW.endt_iss_cd, :NEW.endt_yy, :NEW.endt_seq_no, :NEW.user_id, :NEW.last_upd_date
                    );

        p_exist1 := 'Y';
      END IF;

      EXIT;
    END LOOP;

    IF p_exist1 = 'N' THEN
      :NEW.endt_seq_no := 1;

      INSERT INTO giis_endt_seq
                  (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd,
                   endt_yy, endt_seq_no, user_id, last_update
                  )
           VALUES (:NEW.line_cd, :NEW.subline_cd, :NEW.iss_cd, :NEW.issue_yy, :NEW.pol_seq_no, :NEW.renew_no, :NEW.endt_iss_cd,
                   :NEW.endt_yy, 1, :NEW.user_id, :NEW.last_upd_date
                  );
    END IF;
  END IF;
*/

   --END comment of PETERMKAW changed to this FOR LOOP instead: 02012011
   /* if NVL (same_polno_sw, 'N') = 'Y' AND NVL (pol_flag, '1') IN ('2', '3') then
      no records will be found in the cursor, resulting to the pol_seq_no and endt_seq_no
      NOT to be derived from the temporary table.
   */
   FOR pk IN (SELECT   pol_seq_no, endt_seq_no, ROWID
                  FROM GIIS_PACK_POL_SEQ_TEMP
                 WHERE pack_par_id = :NEW.pack_par_id AND par_id = 0
              ORDER BY pol_seq_no DESC)
   LOOP
      :NEW.pol_seq_no := pk.pol_seq_no;
      :NEW.endt_seq_no := pk.endt_seq_no;
      EXIT;
   END LOOP;

   --
   IF :NEW.pol_flag = '5'
   THEN
      /* For update of giac_aging_soa_details &
      ** giac_aging_ri_soa_details
      */
      BEGIN
         FOR x IN (SELECT param_name, param_value_v
                     FROM GIIS_PARAMETERS
                    WHERE param_name IN
                             ('RI',
                              'RB',
                              'ACCTG_FOR_FUND_CODE',
                              'ACCTG_ISS_CD_GR'
                             ))
         LOOP
            IF x.param_name = 'RI'
            THEN
               v_ri := x.param_value_v;
            ELSIF x.param_name = 'RB'
            THEN
               v_rb := x.param_value_v;
            /* Parameter used to identify the fund code used for acctg
            */
            ELSIF x.param_name = 'ACCTG_FOR_FUND_CODE'
            THEN
               v_gif := x.param_value_v;
            /* Parameter used to identify specIFic accounting iss_cds
            ** for report use.
            */
            ELSIF x.param_name = 'ACCTG_ISS_CD_GR'
            THEN
               v_gr := x.param_value_v;
            END IF;
         END LOOP;

         IF v_ri IS NULL
         THEN
            RAISE_APPLICATION_ERROR
                          (-20010,
                           'PARAMETER RI DOES NOT EXIST IN GIAC PARAMETERS.',
                           TRUE
                          );
         END IF;

         IF v_rb IS NULL
         THEN
            RAISE_APPLICATION_ERROR
                          (-20010,
                           'PARAMETER RB DOES NOT EXIST IN GIAC PARAMETERS.',
                           TRUE
                          );
         END IF;

         IF v_gif IS NULL
         THEN
            RAISE_APPLICATION_ERROR
               (-20010,
                'PARAMETER ACCTG_FOR_FUND_CODE DOES NOT EXIST IN GIAC PARAMETERS.',
                TRUE
               );
         END IF;

         IF v_gr IS NULL
         THEN
            RAISE_APPLICATION_ERROR
               (-20010,
                'PARAMETER ACCTG_ISS_CD_GR DOES NOT EXIST IN GIAC PARAMETERS.',
                TRUE
               );
         END IF;
      --A.R.C. 01.15.2007
      --not needed
      /*DECLARE
        CURSOR A IS
           SELECT iss_cd, prem_seq_no
             FROM GIPI_PACK_INVOICE
            WHERE policy_id = :OLD.pack_policy_id;
        --
        CURSOR b (v_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                  v_prem_seq_no  GIPI_INVOICE.prem_seq_no%TYPE) IS
           SELECT gagp_aging_id,balance_amt_due, prem_balance_due,
                  tax_balance_due
             FROM GIAC_AGING_SOA_DETAILS
            WHERE iss_cd      = v_iss_cd
              AND prem_seq_no = v_prem_seq_no;
       BEGIN
          FOR a_rec IN A
          LOOP
            v_iss_cd      := a_rec.iss_cd;
            v_prem_seq_no := a_rec.prem_seq_no;
            IF :NEW.iss_cd IN (v_ri, v_gr, v_rb) THEN
              DELETE FROM GIAC_AGING_RI_SOA_DETAILS
              WHERE prem_seq_no = a_rec.prem_seq_no;
            ELSE
              --
              DELETE FROM GIAC_AGING_FC_SOA_DETAILS
               WHERE iss_cd      = a_rec.iss_cd
                 AND prem_seq_no = a_rec.prem_seq_no;

              DELETE FROM GIAC_AGING_SOA_DETAILS
               WHERE iss_cd      = a_rec.iss_cd
                 AND prem_seq_no = a_rec.prem_seq_no;
            END IF;
          END LOOP;
       END;*/
      END;
   END IF;
END;
/


