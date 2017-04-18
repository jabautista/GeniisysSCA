CREATE OR REPLACE PACKAGE BODY CPI.giuts026_pkg
AS
   FUNCTION get_giri_inpolbas (
      p_user_id      giis_users.user_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN giri_inpolbas_tab PIPELINED
   IS
      v_inpolbas   giri_inpolbas_type;
   BEGIN
      FOR i IN (SELECT a.*, b.accept_no, b.ref_accept_no, b.offer_date,
                       b.accept_by, b.ri_cd, b.writer_cd, b.accept_date,
                       b.ri_policy_no, b.ri_endt_no, b.ri_binder_no,
                       b.orig_tsi_amt, b.orig_prem_amt, b.remarks,
                       b.oar_print_date, b.pack_accept_no, b.offered_by,
                       b.amount_offered
                  FROM gipi_polbasic a, giri_inpolbas b
                 WHERE a.policy_id = b.policy_id
                   AND b.accept_no IS NOT NULL
                   /* benjo 08.17.2016 SR-21030 */
                   /*AND check_user_per_line2 (a.line_cd,
                                             a.iss_cd,
                                             'GIUTS026',
                                             p_user_id
                                            ) = 1
                   -- added by: Nica 05.02.2013 - to check security access
                   AND check_user_per_iss_cd2 (a.line_cd,
                                               a.iss_cd,
                                               'GIUTS026',
                                               p_user_id
                                              ) = 1*/
                   AND (a.line_cd, a.iss_cd) IN (SELECT line_cd, branch_cd
                                                   FROM TABLE (security_access.get_branch_line ('UW', 'GIUTS026', p_user_id)))
                   /* end SR-21030 */
                   AND UPPER (a.line_cd) LIKE
                                            UPPER (NVL (p_line_cd, a.line_cd))
                   AND UPPER (a.subline_cd) LIKE
                                      UPPER (NVL (p_subline_cd, a.subline_cd))
                   AND UPPER (a.iss_cd) LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
                   AND a.issue_yy LIKE NVL (p_issue_yy, a.issue_yy)
                   AND a.pol_seq_no LIKE NVL (p_pol_seq_no, a.pol_seq_no)
                   AND a.renew_no LIKE NVL (p_renew_no, a.renew_no))
      LOOP
         v_inpolbas.policy_id := i.policy_id;
         --v_inpolbas.policy_no := gipi_polbasic_pkg.get_policy_no (i.policy_id); --benjo 08.17.2016 SR-21030
         v_inpolbas.policy_no :=   i.line_cd
                                || '-'
                                || i.subline_cd
                                || '-'
                                || i.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (i.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (i.renew_no, '09')); --benjo 08.17.2016 SR-21030                   
         v_inpolbas.line_cd := i.line_cd;
         v_inpolbas.subline_cd := i.subline_cd;
         v_inpolbas.iss_cd := i.iss_cd;
         v_inpolbas.issue_yy := i.issue_yy;
         v_inpolbas.pol_seq_no := i.pol_seq_no;
         v_inpolbas.renew_no := i.renew_no;
         v_inpolbas.endt_iss_cd := i.endt_iss_cd;
         v_inpolbas.endt_yy := i.endt_yy;
         v_inpolbas.endt_seq_no := i.endt_seq_no;
         v_inpolbas.assd_no := i.assd_no;
         v_inpolbas.ri_cd := i.ri_cd;
         v_inpolbas.writer_cd := i.writer_cd;
         v_inpolbas.accept_date := i.accept_date;
         v_inpolbas.accept_no := i.accept_no;
         v_inpolbas.ref_accept_no := i.ref_accept_no;
         v_inpolbas.cpi_rec_no := i.cpi_rec_no;
         v_inpolbas.cpi_branch_cd := i.cpi_branch_cd;
         v_inpolbas.oar_print_date := i.oar_print_date;
         v_inpolbas.offer_date := i.offer_date;
         v_inpolbas.accept_by := i.accept_by;
         v_inpolbas.ri_policy_no := i.ri_policy_no;
         v_inpolbas.ri_endt_no := i.ri_endt_no;
         v_inpolbas.ri_binder_no := i.ri_binder_no;
         v_inpolbas.orig_tsi_amt := i.orig_tsi_amt;
         v_inpolbas.orig_prem_amt := i.orig_prem_amt;
         v_inpolbas.remarks := i.remarks;
         v_inpolbas.pack_accept_no := i.pack_accept_no;
         v_inpolbas.offered_by := i.offered_by;
         v_inpolbas.amount_offered := i.amount_offered;
         v_inpolbas.arc_ext_data := i.arc_ext_data;

         IF i.endt_seq_no = 0
         THEN
            v_inpolbas.endt_no := NULL;
            v_inpolbas.endt_iss_cd := NULL;
            v_inpolbas.endt_yy := NULL;
            v_inpolbas.endt_seq_no := NULL;
         ELSE
            v_inpolbas.endt_no :=
                  i.endt_iss_cd
               || ' - '
               || TO_CHAR (i.endt_yy, '09')
               || ' - '
               || TO_CHAR (i.endt_seq_no, '099999');
            v_inpolbas.endt_iss_cd := i.endt_iss_cd;
            v_inpolbas.endt_yy := TO_CHAR (i.endt_yy, '09');
            v_inpolbas.endt_seq_no := TO_CHAR (i.endt_seq_no, '099999');
         END IF;

         BEGIN
            FOR assd IN (SELECT assd_name
                           FROM giis_assured a, gipi_parlist b
                          WHERE a.assd_no = b.assd_no AND b.par_id = i.par_id)
            LOOP
               v_inpolbas.assd_name := assd.assd_name;
            END LOOP;
         END;

         BEGIN
            FOR risname IN (SELECT ri_sname
                              FROM giis_reinsurer
                             WHERE ri_cd = i.writer_cd)
            LOOP
               v_inpolbas.ri_sname := risname.ri_sname;
            END LOOP;
         END;

         BEGIN
            FOR risname2 IN (SELECT ri_sname
                               FROM giis_reinsurer
                              WHERE ri_cd = i.ri_cd)
            LOOP
               v_inpolbas.ri_sname2 := risname2.ri_sname;
            END LOOP;
         END;

         PIPE ROW (v_inpolbas);
      END LOOP;

      RETURN;
   END;

   PROCEDURE update_acceptance_no (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_ri_endt_no      giri_inpolbas.ri_endt_no%TYPE,
      p_ri_policy_no    giri_inpolbas.ri_policy_no%TYPE,
      p_ri_binder_no    giri_inpolbas.ri_binder_no%TYPE,
      p_orig_tsi_amt    giri_inpolbas.orig_tsi_amt%TYPE,
      p_orig_prem_amt   giri_inpolbas.orig_prem_amt%TYPE,
      p_remarks         giri_inpolbas.remarks%TYPE,
      p_user_id         giis_users.user_id%TYPE
   )
   IS
   BEGIN
      UPDATE giri_inpolbas
         SET ri_endt_no = p_ri_endt_no,
             ri_policy_no = p_ri_policy_no,
             ri_binder_no = p_ri_binder_no,
             orig_tsi_amt = p_orig_tsi_amt,
             orig_prem_amt = p_orig_prem_amt,
             remarks = p_remarks,
             user_id = p_user_id,
             last_update = SYSDATE
       WHERE policy_id = p_policy_id;
   END;
END;
/


