CREATE OR REPLACE PACKAGE BODY CPI.giclr546_pkg
AS
   FUNCTION get_giclr_546_report (
      p_clmstat_cd     VARCHAR2,
      p_clmstat_type   VARCHAR2,
      p_end_dt         VARCHAR2,
      p_issue_yy       NUMBER,
      p_line_cd        VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_pol_iss_cd     VARCHAR2,
      p_pol_seq_no     NUMBER,
      p_renew_no       NUMBER,
      p_start_dt       VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list     report_type;
      v_intm     VARCHAR2 (300) := NULL;
      var_intm   VARCHAR2 (300) := NULL;
      v_x        NUMBER         := 0;
      v_print    BOOLEAN := TRUE;
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
            v_list.cf_title := 'REPORTED CLAIMS PER POLICY - LOSSES';
         ELSIF p_loss_exp = 'E'
         THEN
            v_list.cf_title := 'REPORTED CLAIMS PER POLICY - EXPENSES';
         ELSE
            v_list.cf_title := 'REPORTED CLAIMS PER POLICY';
         END IF;

         IF p_loss_exp = 'L'
         THEN
            v_list.cf_clm_amt := 'Loss Amount';
         ELSIF p_loss_exp = 'E'
         THEN
            v_list.cf_clm_amt := 'Expense Amount';
         ELSE
            v_list.cf_clm_amt := 'Claim Amount';
         END IF;

         v_list.cf_date :=
               'from '
            || TO_CHAR (TO_DATE (p_start_dt, 'mm-dd-yyyy'),
                        'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (TO_DATE (p_end_dt, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      
      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
               AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd)
               AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
               AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
               AND a.renew_no = NVL (p_renew_no, a.renew_no)
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
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY b.clm_stat_desc,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no)
      LOOP
         v_print := FALSE;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number; 
          
         IF i.pol_iss_cd = 'RI'
         THEN
            FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                                  FROM gicl_claims a, giis_reinsurer b
                                 WHERE a.claim_id = i.claim_id
                                   AND a.ri_cd = b.ri_cd(+))
            LOOP
               v_intm := TO_CHAR (ri.ri_cd) || '/' || ri.ri_name;

               IF var_intm IS NULL
               THEN
                  v_list.cf_intm := v_intm;
               ELSE
                  v_list.cf_intm := v_intm || CHR (10) || var_intm;
               END IF;
            END LOOP;
         ELSE
            FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm,
                                         b.ref_intm_cd ref_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = i.claim_id)
            LOOP
               v_intm :=
                   TO_CHAR (intm.nmbr) || '/' || intm.ref_cd || '/'
                   || intm.nm;

               IF var_intm IS NULL
               THEN
                  v_list.cf_intm := v_intm;
               ELSE
                  v_list.cf_intm := v_intm || CHR (10) || var_intm;
               END IF;
            END LOOP;
         END IF;

         v_list.pol_eff_date := i.pol_eff_date;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.claim_id := i.claim_id;
         v_list.clm_stat_cd := i.clm_stat_cd; --benjo 01.06.2016 GENQA-SR-5109
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_print THEN
        v_list.v_print := 'T';
        PIPE ROW(v_list);
      END IF;
   END get_giclr_546_report;

   FUNCTION get_giclr_546_dtls (
      p_claim_id      NUMBER,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list       report_type;
      v_loss_exp   VARCHAR2 (2);
      v_exist      VARCHAR2 (1);
      v_shr_type   NUMBER;
      v_x          NUMBER       := 0;
   BEGIN
      FOR i IN (SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                           FROM giis_peril a, gicl_item_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND b.claim_id = p_claim_id)
      LOOP
         v_list.peril_name := i.peril_name;

         BEGIN
            SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
              INTO v_loss_exp
              FROM DUAL;

            v_list.cf_loss :=
               gicls540_pkg.get_loss_amt (i.claim_id,
                                          i.peril_cd,
                                          v_loss_exp,
                                          p_clm_stat_cd
                                         );
            v_list.cf_retention :=
               gicls540_pkg.amount_per_share_type (i.claim_id,
                                                   i.peril_cd,
                                                   1,
                                                   v_loss_exp,
                                                   p_clm_stat_cd
                                                  );
            v_list.cf_treaty :=
               gicls540_pkg.amount_per_share_type (i.claim_id,
                                                   i.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   p_clm_stat_cd
                                                  );
            v_list.cf_xol :=
               gicls540_pkg.amount_per_share_type
                                              (i.claim_id,
                                               i.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clm_stat_cd
                                              );
            v_list.cf_facul :=
               gicls540_pkg.amount_per_share_type
                                                 (i.claim_id,
                                                  i.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         END;

         v_list.cf_exp :=
            gicls540_pkg.get_loss_amt (i.claim_id,
                                       i.peril_cd,
                                       'E',
                                       p_clm_stat_cd
                                      );
         v_list.cf_exp_retention :=
            gicls540_pkg.amount_per_share_type (i.claim_id,
                                                i.peril_cd,
                                                1,
                                                'E',
                                                p_clm_stat_cd
                                               );
         v_list.cf_exp_treaty :=
            gicls540_pkg.amount_per_share_type (i.claim_id,
                                                i.peril_cd,
                                                giacp.v ('TRTY_SHARE_TYPE'),
                                                'E',
                                                p_clm_stat_cd
                                               );
         v_list.cf_exp_xol :=
            gicls540_pkg.amount_per_share_type
                                              (i.claim_id,
                                               i.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               'E',
                                               p_clm_stat_cd
                                              );
         v_list.cf_exp_facul :=
            gicls540_pkg.amount_per_share_type (i.claim_id,
                                                i.peril_cd,
                                                giacp.v ('FACUL_SHARE_TYPE'),
                                                'E',
                                                p_clm_stat_cd
                                               );
         PIPE ROW (v_list);
         v_x := 1;
      END LOOP;

      IF v_x = 0
      THEN
         v_list.cf_loss := 0;
         v_list.cf_retention := 0;
         v_list.cf_treaty := 0;
         v_list.cf_xol := 0;
         v_list.cf_facul := 0;
         v_list.cf_exp := 0;
         v_list.cf_exp_retention := 0;
         v_list.cf_exp_treaty := 0;
         v_list.cf_exp_xol := 0;
         v_list.cf_exp_facul := 0;
         PIPE ROW (v_list);
      END IF;
   END get_giclr_546_dtls;
END;
/


