CREATE OR REPLACE PACKAGE BODY CPI.giclr542b_pkg
AS
   FUNCTION get_giclr_542b_report (
      p_assd_no    NUMBER,
      p_assured    VARCHAR2,
      p_end_dt     VARCHAR2,
      p_iss_cd     VARCHAR2,
      p_line_cd    VARCHAR2,
      p_loss_exp   VARCHAR2,
      p_start_dt   VARCHAR2,
      p_user_id    VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list          report_type;
      v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
      v_intm_name     giis_intermediary.intm_name%TYPE;
      v_intm_no       gicl_intm_itmperil.intm_no%TYPE;
      v_ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE;
      v_ri_cd         gicl_claims.ri_cd%TYPE;
      v_ri_name       giis_reinsurer.ri_name%TYPE;
      v_intm          VARCHAR2 (300)                       := NULL;
      var_intm        VARCHAR2 (300)                       := NULL;
      v_exist         VARCHAR2 (1);
      v_loss_exp      VARCHAR2 (2);
      v_shr_type      NUMBER;
      v_loop_count    NUMBER;
      v_x             NUMBER                               := 0;
      v_print         BOOLEAN                              := TRUE;
   BEGIN
         BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := '';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         IF p_loss_exp = 'L'
         THEN
            v_list.cf_title := 'REPORTED CLAIMS PER ASSURED - LOSSES';
         ELSIF p_loss_exp = 'E'
         THEN
            v_list.cf_title := 'REPORTED CLAIMS PER ASSURED - EXPENSES';
         ELSE
            v_list.cf_title := 'REPORTED CLAIMS PER ASSURED';
         END IF;

         v_list.cf_date :=
               'from '
            || TO_CHAR (TO_DATE (p_start_dt, 'mm-dd-yyyy'),
                        'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (TO_DATE (p_end_dt, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');

         IF p_loss_exp = 'L'
         THEN
            v_list.clm_amt := 'Loss Amount';
         ELSIF p_loss_exp = 'E'
         THEN
            v_list.clm_amt := 'Expense Amount';
         ELSE
            v_list.clm_amt := 'Claim Amount';
         END IF;
            
      FOR i IN
         (SELECT   a.line_cd, a.iss_cd,
                   (   a.line_cd
                    || '-'
                    || a.subline_cd
                    || '-'
                    || a.iss_cd
                    || '-'
                    || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                    || '-'
                    || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                   ) "CLAIM_NO",
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '00'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '00')) "POLICY_NO",
                   a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                   a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                   a.renew_no, a.assd_no, b.assd_name, a.claim_id,
                   a.clm_stat_cd, a.old_stat_cd, close_date
              FROM gicl_claims a, giis_assured b
             WHERE a.assd_no = b.assd_no
               AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE (p_start_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
                                               AND NVL (TO_DATE (p_end_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
               AND a.assd_no = NVL (p_assd_no, a.assd_no)
               AND iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND line_cd = NVL (p_line_cd, a.line_cd)
               AND check_user_per_iss_cd2 (a.line_cd,
                                           NVL (p_iss_cd, NULL),
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
               AND check_user_per_iss_cd2 (NVL (p_line_cd, NULL),
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'))
      LOOP
         v_print := FALSE;
         IF p_assd_no IS NOT NULL
         THEN
            v_list.p_assured :=
                     'Assured : ' || TO_CHAR (p_assd_no) || ' - '
                     || p_assured;
         ELSE
            v_list.p_assured := NULL;
         END IF;

         v_list.assd_no := i.assd_no;
         v_list.claim_id := i.claim_id;
         v_list.line_cd := i.line_cd;

         IF p_assd_no IS NOT NULL
         THEN
            v_list.cf_assured := TO_CHAR (i.assd_no) || ' - ' || i.assd_name;
         ELSE
            v_list.cf_assured := TO_CHAR (i.assd_no) || ' - ' || i.assd_name;
         END IF;

         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;

         BEGIN
            FOR x IN (SELECT a.pol_iss_cd
                        FROM gicl_claims a
                       WHERE a.claim_id = i.claim_id)
            LOOP
               v_pol_iss_cd := x.pol_iss_cd;
            END LOOP;

            IF v_pol_iss_cd = 'RI'
            THEN
               FOR k IN (SELECT DISTINCT g.ri_name, a.ri_cd
                                    FROM gicl_claims a, giis_reinsurer g
                                   WHERE a.claim_id = i.claim_id
                                     AND a.ri_cd = g.ri_cd(+))
               LOOP
                  v_intm := TO_CHAR (k.ri_cd) || '/' || k.ri_name;

                  IF var_intm IS NULL
                  THEN
                     v_list.cf_intm := v_intm;
                  ELSE
                     v_list.cf_intm := v_intm || CHR (10) || var_intm;
                  END IF;
               END LOOP;
            ELSE
               FOR j IN (SELECT DISTINCT a.intm_no, b.intm_name,
                                         b.ref_intm_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = i.claim_id)
               LOOP
                  v_intm :=
                        TO_CHAR (j.intm_no)
                     || '/'
                     || j.ref_intm_cd
                     || '/'
                     || j.intm_name;

                  IF var_intm IS NULL
                  THEN
                     v_list.cf_intm := v_intm;
                  ELSE
                     v_list.cf_intm := v_intm || CHR (10) || var_intm;
                  END IF;
               END LOOP;
            END IF;
         END;

         v_list.eff_date := i.pol_eff_date;
         v_list.loss_date := i.dsp_loss_date;
         v_list.file_date := i.clm_file_date;

         BEGIN
            FOR q IN (SELECT clm_stat_desc
                        FROM giis_clm_stat
                       WHERE clm_stat_cd = i.clm_stat_cd)
            LOOP
               v_list.cf_clm_stat := q.clm_stat_desc;
            END LOOP;
         END;

         v_x := 0;--for claim id not exist in 2nd loop

         BEGIN
            FOR j IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname,
                                      b.claim_id, c.line_cd
                                 FROM gicl_item_peril b, giis_peril c
                                WHERE b.peril_cd = c.peril_cd
                                  AND c.line_cd = NVL (i.line_cd, c.line_cd)
                                  AND b.claim_id = i.claim_id
                             ORDER BY c.peril_cd,
                                      c.peril_sname,
                                      b.claim_id,
                                      c.line_cd)
            LOOP
               v_list.peril_sname := j.peril_sname;
               v_list.peril_cd := j.peril_cd;
               v_list.claim_id := j.claim_id;
               v_list.line_cd := j.line_cd;

               BEGIN
                  SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
                         DECODE (p_loss_exp, 'LE', 2, 1)
                    INTO v_loss_exp,
                         v_loop_count
                    FROM DUAL;

                  v_list.loss_amt := 0;

                  FOR t IN 1 .. v_loop_count
                  LOOP
                     v_list.loss_amt :=
                          v_list.loss_amt
                        + gicls540_pkg.get_loss_amt (j.claim_id,
                                                     j.peril_cd,
                                                     v_loss_exp,
                                                     i.clm_stat_cd
                                                    );
                     v_loss_exp := 'E';
                  END LOOP;
               END;

               BEGIN
                  SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
                         DECODE (p_loss_exp, 'LE', 2, 1)
                    INTO v_loss_exp,
                         v_loop_count
                    FROM DUAL;

                  v_list.RETENTION := 0;

                  FOR t IN 1 .. v_loop_count
                  LOOP
                     v_list.RETENTION :=
                          v_list.RETENTION
                        + gicls540_pkg.amount_per_share_type (j.claim_id,
                                                              j.peril_cd,
                                                              1,
                                                              v_loss_exp,
                                                              i.clm_stat_cd
                                                             );
                     v_loss_exp := 'E';
                  END LOOP;
               END;

               BEGIN
                  SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
                         DECODE (p_loss_exp, 'LE', 2, 1)
                    INTO v_loss_exp,
                         v_loop_count
                    FROM DUAL;

                  v_list.treaty := 0;

                  FOR t IN 1 .. v_loop_count
                  LOOP
                     v_list.treaty :=
                          v_list.treaty
                        + gicls540_pkg.amount_per_share_type
                                                  (j.claim_id,
                                                   j.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   i.clm_stat_cd
                                                  );
                     v_loss_exp := 'E';
                  END LOOP;
               END;

               BEGIN
                  SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
                         DECODE (p_loss_exp, 'LE', 2, 1)
                    INTO v_loss_exp,
                         v_loop_count
                    FROM DUAL;

                  v_list.facultative := 0;

                  FOR t IN 1 .. v_loop_count
                  LOOP
                     v_list.facultative :=
                          v_list.facultative
                        + gicls540_pkg.amount_per_share_type
                                                 (j.claim_id,
                                                  j.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  i.clm_stat_cd
                                                 );
                     v_loss_exp := 'E';
                  END LOOP;
               END;

               BEGIN
                  SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
                         DECODE (p_loss_exp, 'LE', 2, 1)
                    INTO v_loss_exp,
                         v_loop_count
                    FROM DUAL;

                  v_list.xol := 0;

                  FOR t IN 1 .. v_loop_count
                  LOOP
                     v_list.xol :=
                          v_list.xol
                        + gicls540_pkg.amount_per_share_type
                                              (j.claim_id,
                                               j.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               i.clm_stat_cd
                                              );
                     v_loss_exp := 'E';
                  END LOOP;
               END;

               PIPE ROW (v_list);
               v_x := 1;
            END LOOP;
         END;

         IF v_x = 0
         THEN
            v_list.loss_amt := 0;
            v_list.RETENTION := 0;
            v_list.treaty := 0;
            v_list.xol := 0;
            v_list.facultative := 0;
            PIPE ROW (v_list);
         END IF;
      END LOOP;

      IF v_print THEN
        v_list.v_print := 'TRUE';
        PIPE ROW (v_list);
      END IF;      
   END get_giclr_542b_report;
END;
/


