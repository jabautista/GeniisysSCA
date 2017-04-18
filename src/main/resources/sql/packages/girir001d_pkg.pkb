CREATE OR REPLACE PACKAGE BODY cpi.girir001d_pkg
AS
   PROCEDURE initialize_report_variables
   IS
   BEGIN
      FOR report IN (SELECT UPPER (title) title, text text
                       FROM giis_document
                      WHERE report_id = 'GIRIR001')
      LOOP
         IF report.title = 'BINDER_LINE'
         THEN
            girir001d_pkg.binder_line := report.text;
         END IF;

         IF report.title = 'BINDER_NOTE'
         THEN
            girir001d_pkg.binder_note := report.text;
         END IF;

         IF report.title = 'BINDER_HDR'
         THEN
            girir001d_pkg.binder_hdr := report.text;
         END IF;

         IF report.title = 'BINDER_FTR'
         THEN
            girir001d_pkg.binder_ftr := report.text;
         END IF;

         IF report.title = 'BINDER_FOR'
         THEN
            girir001d_pkg.binder_for := report.text;
         END IF;

         IF report.title = 'BINDER_CONFIRMATION'
         THEN
            girir001d_pkg.binder_confirmation := NVL (report.text, CHR (32));
         END IF;

         IF report.title = 'FRPS_RET'
         THEN
            girir001d_pkg.frps_ret := report.text;
         END IF;

         IF report.title = 'USER_ID'
         THEN
            girir001d_pkg.user_id := report.text;
         END IF;

         IF report.title = 'HIDE'
         THEN
            girir001d_pkg.hide := report.text;
         END IF;

         IF report.title = 'PRINT_LINE_NAME'
         THEN
            girir001d_pkg.print_line_name := report.text;
         END IF;

         IF report.title = 'ADDRESSEE'
         THEN
            girir001d_pkg.addressee := NVL (report.text, 'NO HEADING');
         END IF;

         IF report.title = 'ADDRESSEE_CONFIRMATION'
         THEN
            girir001d_pkg.addressee_confirmation :=
                                              NVL (report.text, 'NO HEADING');
         END IF;

         IF report.title = 'PRINT_AUTHORIZED_SIGNATURE_ABOVE'
         THEN
            girir001d_pkg.print_auth_sig_above := report.text;
         END IF;

         IF report.title = 'PRINT_SIGNATURE_REF_DATE_ACROSS'
         THEN
            girir001d_pkg.print_sig_refdate_across := report.text;
         END IF;

         IF report.title = 'BINDER_HDR_ENDT'
         THEN
            girir001d_pkg.binder_hdr_endt := report.text;
         END IF;

         IF report.title = 'BINDER_HDR_REN'
         THEN
            girir001d_pkg.binder_hdr_ren := report.text;
         END IF;
      END LOOP;
   END initialize_report_variables;

   FUNCTION get_main (p_pre_binder_id VARCHAR2, p_user_id VARCHAR2)
      RETURN main_tab PIPELINED
   IS
      v                              main_type;
      v_dist_no                      giuw_pol_dist.dist_no%TYPE;
      v_par_id                       gipi_parlist.par_id%TYPE;
      v_policy_id                    gipi_polbasic.policy_id%TYPE;
      v_line_cd                      giis_line.line_cd%TYPE;
      v_subline_cd                   giis_subline.subline_cd%TYPE;
      v_par_type                     gipi_parlist.par_type%TYPE;
      v_assd_no                      giis_assured.assd_no%TYPE;
      v_eff_date                     DATE;
      v_expiry_date                  DATE;
      v_incept_tag                   gipi_polbasic.incept_tag%TYPE;
      v_expiry_tag                   gipi_polbasic.expiry_tag%TYPE;
      v_currency_cd                  giis_currency.main_currency_cd%TYPE;
      v_item_grp                     giuw_pol_dist.item_grp%TYPE;
      v_dist_seq_no                  giri_distfrps.dist_seq_no%TYPE;
      v_display_comm_inclusive_vat   giis_document.text%TYPE           := 'N';

      FUNCTION get_open_policy_no (p_id NUMBER, p_type VARCHAR2)
         RETURN VARCHAR2
      IS
         v_no   VARCHAR2 (50);
      BEGIN
         BEGIN
            IF p_type = 'POLICY'
            THEN
               SELECT    line_cd
                      || '-'
                      || op_subline_cd
                      || '-'
                      || op_iss_cd
                      || '-'
                      || LTRIM (TO_CHAR (op_issue_yy, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (op_pol_seqno, '0999999'))
                      || '-'
                      || LTRIM (TO_CHAR (op_renew_no, '09'))
                 INTO v_no
                 FROM gipi_open_policy
                WHERE policy_id = p_id;
            ELSE
               SELECT    line_cd
                      || '-'
                      || op_subline_cd
                      || '-'
                      || op_iss_cd
                      || '-'
                      || LTRIM (TO_CHAR (op_issue_yy, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (op_pol_seqno, '0999999'))
                      || '-'
                      || LTRIM (TO_CHAR (op_renew_no, '09'))
                 INTO v_no
                 FROM gipi_wopen_policy
                WHERE par_id = p_id;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_no := NULL;
         END;

         RETURN v_no;
      END get_open_policy_no;
   BEGIN
      FOR i IN
         (SELECT ri_cd, address1, address2, address3, line_cd, frps_yy,
                 frps_seq_no, ri_accept_date, bndr_remarks1, bndr_remarks2,
                 bndr_remarks3, remarks, ri_as_no, ri_accept_by,
                 other_charges, reverse_sw,
                    LTRIM (TO_CHAR (DECODE (ri_tsi_amt, 0.01, 0, ri_tsi_amt),
                                    '99,999,999,999,990.99'
                                   )
                          )
                 || '  ('
                 || LTRIM (DECODE (ri_shr_pct,
                                   0.01, TO_CHAR (0.00, '990.9999'),
                                   TO_CHAR (ri_shr_pct, '990.9999')
                                  )
                          )
                 || '%)' your_share,
                 prem_tax
            FROM giri_wfrps_ri
           WHERE pre_binder_id = p_pre_binder_id)
      LOOP
         v.ri_cd := i.ri_cd;
         v.line_cd := i.line_cd;
         v.frps_seq_no := i.frps_seq_no;
         v.frps_yy := i.frps_yy;
         v.bill_address1 := i.address1;
         v.bill_address2 := i.address2;
         v.bill_address3 := i.address3;
         v.ri_accept_date := i.ri_accept_date;
         v.bndr_remarks1 := i.bndr_remarks1;
         v.bndr_remarks2 := i.bndr_remarks2;
         v.bndr_remarks3 := i.bndr_remarks3;
         v.remarks := i.remarks;
         v.ri_as_no := i.ri_as_no;
         v.ri_accept_by := i.ri_accept_by;
         v.other_charges := i.other_charges;
         v.reverse_sw := i.reverse_sw;
         v.prem_tax := i.prem_tax;

         SELECT line_name, menu_line_cd
           INTO v.line_name, v.menu_line_cd
           FROM giis_line
          WHERE line_cd = i.line_cd;

         SELECT ri_name, attention
           INTO v.ri_name, v.attention
           FROM giis_reinsurer
          WHERE ri_cd = i.ri_cd;

         v.attention := NVL (v.attention, 'REINSURANCE DEPARTMENT');

         BEGIN
            SELECT dist_no,
                      LTRIM (TO_CHAR (dist_no, '09999999'))
                   || '-'
                   || LTRIM (TO_CHAR (dist_seq_no, '09999')) ds_no,
                      LTRIM (TO_CHAR (frps_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (frps_seq_no, '099999'))
                   || '/'
                   || LTRIM (TO_CHAR (op_group_no, '099999')) frps_no,
                   currency_cd,
                   LTRIM (TO_CHAR (DECODE (tsi_amt, 0.01, 0, tsi_amt),
                                   '99,999,999,999,990.99'
                                  )
                         ) sum_insured,
                   dist_seq_no
              INTO v_dist_no,
                   v.ds_no,
                   v.frps_no,
                   v_currency_cd,
                   v.sum_insured,
                   v_dist_seq_no
              FROM giri_distfrps
             WHERE line_cd = i.line_cd
               AND frps_seq_no = i.frps_seq_no
               AND frps_yy = i.frps_yy;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               SELECT dist_no,
                         LTRIM (TO_CHAR (dist_no, '09999999'))
                      || '-'
                      || LTRIM (TO_CHAR (dist_seq_no, '09999')) ds_no,
                         LTRIM (TO_CHAR (frps_yy, '09'))
                      || '-'
                      || LTRIM (TO_CHAR (frps_seq_no, '099999'))
                      || '/'
                      || LTRIM (TO_CHAR (op_group_no, '099999')) frps_no,
                      currency_cd,
                      LTRIM (TO_CHAR (DECODE (tsi_amt, 0.01, 0, tsi_amt),
                                      '99,999,999,999,990.99'
                                     )
                            ) sum_insured,
                      dist_seq_no
                 INTO v_dist_no,
                      v.ds_no,
                      v.frps_no,
                      v_currency_cd,
                      v.sum_insured,
                      v_dist_seq_no
                 FROM giri_wdistfrps
                WHERE line_cd = i.line_cd
                  AND frps_seq_no = i.frps_seq_no
                  AND frps_yy = i.frps_yy;
         END;

         SELECT short_name
           INTO v.short_name
           FROM giis_currency
          WHERE main_currency_cd = v_currency_cd;

         v.sum_insured := v.short_name || ' ' || v.sum_insured;
         v.your_share := v.short_name || ' ' || i.your_share;

         SELECT par_id, eff_date, expiry_date, item_grp
           INTO v_par_id, v_eff_date, v_expiry_date, v_item_grp
           FROM giuw_pol_dist
          WHERE dist_no = v_dist_no;

         v.par_id := v_par_id;

         SELECT par_type, assd_no,
                   line_cd
                || '-'
                || iss_cd
                || '-'
                || LTRIM (TO_CHAR (par_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (par_seq_no, '0999999'))
           INTO v_par_type, v_assd_no,
                v.par_no
           FROM gipi_parlist
          WHERE par_id = v_par_id;

         BEGIN
            SELECT policy_id, line_cd, subline_cd,
                   DECODE (v_par_type, 'E', v_assd_no, assd_no),
                      line_cd
                   || '-'
                   || subline_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (renew_no, '09')),
                   DECODE (NVL (endt_seq_no, 0),
                           0, '',
                              endt_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (endt_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
                          ),
                   incept_tag, expiry_tag, iss_cd, pol_flag,
                   endt_seq_no
              INTO v_policy_id, v_line_cd, v_subline_cd,
                   v_assd_no,
                   v.policy_no,
                   v.endt_no,
                   v_incept_tag, v_expiry_tag, v.iss_cd, v.pol_flag,
                   v.endt_seq_no
              FROM gipi_polbasic
             WHERE par_id = v_par_id;

            v.mop_number := get_open_policy_no (v_policy_id, 'POLICY');

--            BEGIN
--               SELECT property
--                 INTO v.cf_property
--                 FROM gipi_invoice
--                WHERE policy_id = v_policy_id
--                  AND item_grp = v_item_grp;
--            EXCEPTION
--               WHEN TOO_MANY_ROWS
--               THEN
--                  v.cf_property := 'Various Items';
--            END;
            DECLARE
               v_seq_count    NUMBER (2)     := 0;
               v_item_count   NUMBER (2)     := 0;
               v_property     VARCHAR2 (100);
            BEGIN
               IF     NVL (v.menu_line_cd, v.line_cd) = 'CA'
                  AND v_subline_cd = NVL (giisp.v ('CA_SUBLINE_MSP'), 'MSP')
               THEN
                  v_property := 'MSPR';
               ELSE
                  SELECT COUNT (dist_seq_no)
                    INTO v_seq_count
                    FROM giuw_policyds
                   WHERE dist_no = v_dist_no;

                  IF v_seq_count = 1
                  THEN
                     FOR a IN (SELECT property
                                 FROM gipi_invoice
                                WHERE policy_id = v_policy_id)
                     LOOP
                        v_property := a.property;
                     END LOOP;
--
                  ELSE
                     SELECT COUNT (item_no)
                       INTO v_item_count
                       FROM giuw_itemds
                      WHERE dist_no = v_dist_no
                            AND dist_seq_no = v_dist_seq_no;

--
                     IF v_item_count = 1
                     THEN
                        FOR c IN (SELECT item_no
                                    FROM giuw_itemds
                                   WHERE dist_no = v_dist_no
                                     AND dist_seq_no = v_dist_seq_no)
                        LOOP
                           FOR b IN (SELECT item_title
                                       FROM gipi_item
                                      WHERE policy_id = v_policy_id
                                        AND item_no = c.item_no)
                           LOOP
                              v_property := b.item_title;
                              EXIT;
                           END LOOP;
                        END LOOP;
                     ELSE
                        v_property := 'Various Items';
                     END IF;
                  END IF;
               END IF;

               v.cf_property := v_property;
            END;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_policy_id := NULL;

               SELECT line_cd, subline_cd,
                      DECODE (v_par_type, 'E', v_assd_no, assd_no),
                      incept_tag, expiry_tag, iss_cd, endt_seq_no,
                      pol_flag
                 INTO v_line_cd, v_subline_cd,
                      v_assd_no,
                      v_incept_tag, v_expiry_tag, v.iss_cd, v.endt_seq_no,
                      v.pol_flag
                 FROM gipi_wpolbas
                WHERE par_id = v_par_id;

               v.mop_number := get_open_policy_no (v_par_id, 'PAR');

--               BEGIN
--                  SELECT property
--                    INTO v.cf_property
--                    FROM gipi_winvoice
--                   WHERE par_id = v_par_id;
----                     AND item_grp = v_item_grp;
--               EXCEPTION
--                  WHEN TOO_MANY_ROWS
--                  THEN
--                     v.cf_property := 'Various Items';
--               END;
               DECLARE
                  v_seq_count    NUMBER (2)     := 0;
                  v_item_count   NUMBER (2)     := 0;
                  v_property     VARCHAR2 (100);
               BEGIN
                  IF     NVL (v.menu_line_cd, v.line_cd) = 'CA'
                     AND v_subline_cd =
                                       NVL (giisp.v ('CA_SUBLINE_MSP'), 'MSP')
                  THEN
                     v_property := 'MSPR';
                  ELSE
                     SELECT COUNT (dist_seq_no)
                       INTO v_seq_count
                       FROM giuw_wpolicyds
                      WHERE dist_no = v_dist_no;

                     IF v_seq_count = 1
                     THEN
                        FOR a IN (SELECT property
                                    FROM gipi_winvoice
                                   WHERE par_id = v_par_id)
                        LOOP
                           v_property := a.property;
                        END LOOP;
--
                     ELSE
                        SELECT COUNT (item_no)
                          INTO v_item_count
                          FROM giuw_witemds
                         WHERE dist_no = v_dist_no
                           AND dist_seq_no = v_dist_seq_no;

--
                        IF v_item_count = 1
                        THEN
                           FOR c IN (SELECT item_no
                                       FROM giuw_witemds
                                      WHERE dist_no = v_dist_no
                                        AND dist_seq_no = v_dist_seq_no)
                           LOOP
                              FOR b IN (SELECT item_title
                                          FROM gipi_witem
                                         WHERE par_id = v_par_id
                                           AND item_no = c.item_no)
                              LOOP
                                 v_property := b.item_title;
                                 EXIT;
                              END LOOP;
                           END LOOP;
                        ELSE
                           v_property := 'Various Items';
                        END IF;
                     END IF;
                  END IF;

                  v.cf_property := v_property;
               END;
         END;

         IF     NVL (v.menu_line_cd, v.line_cd) = 'CA'
            AND v_subline_cd = NVL (giisp.v ('CA_SUBLINE_MSP'), 'MSP')
         THEN
            v.cf_property := 'MSPR';
         END IF;

         SELECT subline_name
           INTO v.subline_name
           FROM giis_subline
          WHERE line_cd = v.line_cd AND subline_cd = v_subline_cd;

         IF v_assd_no IS NOT NULL
         THEN
            SELECT TRIM (assd_name)
              INTO v.assd_name
              FROM giis_assured
             WHERE assd_no = v_assd_no;
         END IF;

         IF NVL (v_incept_tag, 'N') = 'Y'
         THEN
            v.ri_term := 'TBA';
         ELSE
            v.ri_term := TO_CHAR (v_eff_date, 'Mon. DD, YYYY');
         END IF;

         v.ri_term := v.ri_term || ' to ';

         IF NVL (v_expiry_tag, 'N') = 'Y'
         THEN
            v.ri_term := v.ri_term || 'TBA';
         ELSE
            v.ri_term :=
                        v.ri_term || TO_CHAR (v_expiry_date, 'Mon. DD, YYYY');
         END IF;

         initialize_report_variables;
         v.rv_binder_line := NVL (girir001d_pkg.binder_line, 'N');
         v.rv_print_line_name := NVL (girir001d_pkg.print_line_name, 'N');
         v.rv_addressee := girir001d_pkg.addressee;
         v.rv_binder_ftr := girir001d_pkg.binder_ftr;
         v.rv_frps_ret := girir001d_pkg.frps_ret;
         v.rv_addressee_confirmation := girir001d_pkg.addressee_confirmation;
         v.rv_binder_confirmation := girir001d_pkg.binder_confirmation;
         v.rv_print_sig_refdate_across :=
                                        girir001d_pkg.print_sig_refdate_across;
         v.rv_binder_for := girir001d_pkg.binder_for;
         v.cf_for := v.rv_binder_for || ' ' || v.ri_name;
         v.rv_binder_note := NVL (girir001d_pkg.binder_note, 'N');
         v.rv_user_id := NVL (girir001d_pkg.user_id, 'N');
         v.rv_print_auth_sig_above :=
                                 NVL (girir001d_pkg.print_auth_sig_above, 'N');

         IF v.endt_seq_no <> 0
         THEN
            v.rv_binder_hdr := girir001d_pkg.binder_hdr_endt;
         ELSIF v.pol_flag = 2 AND v.endt_seq_no = 0
         THEN
            v.rv_binder_hdr := girir001d_pkg.binder_hdr_ren;
         ELSE
            v.rv_binder_hdr := girir001d_pkg.binder_hdr;
         END IF;

         IF giisp.v ('PRINT_BNDR_USER') = 'N'
         THEN
            v.user_id := NULL;
         ELSE
            v.user_id := '* ' || p_user_id || ' *';
         END IF;

         DECLARE
            v_signatories   giis_signatory_names.file_name%TYPE;
            v_designation   giis_signatory_names.designation%TYPE;
            v_signatory     giis_signatory_names.signatory%TYPE;
         BEGIN
            FOR sig IN
               (SELECT file_name filename, designation designation,
                       signatory signatory
                  FROM giis_signatory_names
                 WHERE signatory_id IN (
                          SELECT signatory_id
                            FROM giis_signatory
                           WHERE report_id = 'GIRIR001'
                             AND NVL (line_cd, i.line_cd) = i.line_cd
                             AND NVL (iss_cd, v.iss_cd) = v.iss_cd
                             AND NVL (current_signatory_sw, 'Y') = 'Y')
                   AND ROWNUM = 1)
            LOOP
               v_signatories := sig.filename;
               v_designation := sig.designation;
               v_signatory := sig.signatory;
            END LOOP;

            v.signatories := v_signatories;
            v.designation := v_designation;
            v.signatory := v_signatory;
         END;

         DECLARE
            v_signatory_label   giac_rep_signatory.label%TYPE;
         BEGIN
            FOR lbl IN
               (SELECT label
                  FROM giac_rep_signatory
                 WHERE report_id = 'GIRIR001'
                   AND signatory_id IN (
                          SELECT signatory_id
                            FROM giis_signatory
                           WHERE report_id = 'GIRIR001'
                             AND NVL (line_cd, i.line_cd) = i.line_cd
                             AND NVL (iss_cd, v.iss_cd) = v.iss_cd
                             AND NVL (current_signatory_sw, 'Y') = 'Y')
                   AND ROWNUM = 1)
            LOOP
               v_signatory_label := lbl.label;
            END LOOP;

            v.signatory_label := v_signatory_label;
         END;

         SELECT local_foreign_sw
           INTO v.local_foreign_sw
           FROM giis_reinsurer
          WHERE ri_cd = i.ri_cd;

         BEGIN
            SELECT text
              INTO v_display_comm_inclusive_vat
              FROM giis_document
             WHERE title = 'DISPLAY_COMM_INCLUSIVE_VAT'
               AND report_id = 'GIRIR001';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_display_comm_inclusive_vat := 'N';
         END;

         IF v_display_comm_inclusive_vat = 'Y'
         THEN
            v.show_vat := 'N';
         ELSE
            v.show_vat := 'Y';
         END IF;

         IF v.local_foreign_sw = 'L'
         THEN
            v.show_whold_vat := 'N';
         ELSE
            v.show_whold_vat := 'Y';
         END IF;

         IF v.local_foreign_sw != 'L' AND v.prem_tax > 0
         THEN
            v.show_tax := 'Y';
         ELSE
            v.show_tax := 'N';
         END IF;

         v.cf_class := v.line_name || ' - ' || v.subline_name;

         DECLARE
            v_show_sailing_date   VARCHAR2 (1)              := 'N';
            v_sailing_date        VARCHAR2 (100);
            v_print_etd           giis_document.text%TYPE;
         BEGIN
            IF NVL (v.menu_line_cd, v.line_cd) = 'MN'
            THEN
               BEGIN
                  SELECT text
                    INTO v_print_etd
                    FROM giis_document
                   WHERE report_id = 'GIRIR001' AND title = 'PRINT_ETD';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_print_etd := 'N';
               END;

               IF v_print_etd = 'Y'
               THEN
                  v_show_sailing_date := 'Y';

                  IF v_policy_id IS NOT NULL
                  THEN
                     FOR a IN (SELECT   a.etd
                                   FROM gipi_cargo a, giuw_itemds b
                                  WHERE a.policy_id = v_policy_id
                                    AND a.item_no = b.item_no
                                    AND b.dist_no = v_dist_no
                                    AND b.dist_seq_no = v_dist_seq_no
                               ORDER BY a.item_no)
                     LOOP
                        v_sailing_date := TO_CHAR (a.etd, 'Mon. DD, YYYY');
                        EXIT;
                     END LOOP;
                  ELSE
                     FOR a IN (SELECT   a.etd
                                   FROM gipi_wcargo a, giuw_witemds b
                                  WHERE a.par_id = v_par_id
                                    AND a.item_no = b.item_no
                                    AND b.dist_no = v_dist_no
                                    AND b.dist_seq_no = v_dist_seq_no
                               ORDER BY a.item_no)
                     LOOP
                        v_sailing_date := TO_CHAR (a.etd, 'Mon. DD, YYYY');
                        EXIT;
                     END LOOP;
                  END IF;
               END IF;
            ELSE
               v_show_sailing_date := 'N';
            END IF;

            v.show_sailing_date := v_show_sailing_date;
            v.sailing_date := v_sailing_date;
         END;

         PIPE ROW (v);
      END LOOP;
   END get_main;

   FUNCTION get_report_details (
      p_pre_binder_id   giri_wfrps_ri.pre_binder_id%TYPE,
      p_line_cd         giri_frps_ri.line_cd%TYPE,
      p_frps_yy         giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no     giri_frps_ri.frps_seq_no%TYPE,
      p_reverse_sw      giri_frps_ri.reverse_sw%TYPE,
      p_ri_cd           giis_reinsurer.ri_cd%TYPE
   )
      RETURN detail_tab PIPELINED
   IS
      v   detail_type;
       -- jhing REPUBLICFULLWEB 21773
      v_display_zero_prem_peril giis_document.text%TYPE  := 'Y' ; 
      v_cnt_printPeril   NUMBER := 0 ; 
   BEGIN
   
 -- jhing 03.30.2016  query parameter to display peril with zero premium REPUBLICFULLWEB 21773 
     FOR txt IN (  SELECT a.text
                          FROM giis_document a
                         WHERE     NVL (line_cd, '@@@@@@@') = p_line_cd
                               AND report_id = 'GIRIR001'
                               AND a.title = 'DISPLAY_ZERO_PREM_PERIL'
                        UNION
                        SELECT a.text
                          FROM giis_document a
                         WHERE     a.line_cd IS NULL
                               AND a.report_id = 'GIRIR001'
                               AND a.title = 'DISPLAY_ZERO_PREM_PERIL'
                               AND NOT EXISTS
                                          (SELECT 1
                                             FROM giis_document c
                                            WHERE     c.report_id = a.report_id
                                                  AND c.title = a.title
                                                  AND c.line_cd = p_line_cd))
      LOOP
            v_display_zero_prem_peril := txt.text; 
            EXIT;
      END LOOP;  
       
      FOR peril IN (SELECT   SUM (NVL (t4.prem_amt, 0)) gross_prem,
                             SUM (NVL (t2.ri_prem_amt, 0)) ri_prem_amt,
                             AVG (NVL (t2.ri_comm_rt, 0)) ri_comm_rt,
                             SUM (NVL (t2.ri_comm_amt, 0)) ri_comm_amt,
                             SUM (  NVL (t2.ri_prem_amt, 0)
                                  - NVL (t2.ri_comm_amt, 0)
                                 ) less_ri_comm_amt,
                             t3.pre_binder_id, t3.line_cd, t3.frps_yy,
                             t3.frps_seq_no, t4.peril_title,
                             NVL (t3.ri_prem_vat, 0) ri_prem_vat,
                             NVL (t2.ri_comm_vat, 0) ri_comm_vat,
                             NVL (t2.ri_comm_vat, 0) peril_comm_vat,
                             t5.SEQUENCE v_sequence,
                             NVL (t5.prt_flag, 99) prt_flag,
                             (NVL (t3.ri_wholding_vat, 0) * (-1)
                             ) ri_wholding_vat
                        FROM giri_wfrperil t2,
                             giri_wfrps_ri t3,
                             giri_wfrps_peril_grp t4,
                             giis_peril t5
                       WHERE t3.pre_binder_id = p_pre_binder_id
                         AND t3.line_cd = t2.line_cd
                         AND t3.frps_yy = t2.frps_yy
                         AND t3.frps_seq_no = t2.frps_seq_no
                         AND t3.ri_seq_no = t2.ri_seq_no
                         AND t3.line_cd = t4.line_cd
                         AND t3.frps_yy = t4.frps_yy
                         AND t3.frps_seq_no = t4.frps_seq_no
                         AND t5.line_cd = t4.line_cd
                         AND t5.peril_cd = t4.peril_cd
                         AND t3.line_cd = p_line_cd
                         AND t3.frps_yy = p_frps_yy
                         AND t3.frps_seq_no = p_frps_seq_no
                         AND t2.peril_cd = t4.peril_cd
                         AND t2.peril_cd = t5.peril_cd
                    GROUP BY t3.pre_binder_id,
                             t3.line_cd,
                             t3.frps_yy,
                             t3.frps_seq_no,
                             t4.peril_cd,
                             t4.peril_title,
                             t3.ri_prem_vat,
                             t3.ri_comm_vat,
                             t2.ri_comm_vat,
                             t3.ri_wholding_vat,
                             t3.ri_comm_vat,
                             t5.SEQUENCE,
                             NVL (t5.prt_flag, 99)
                    ORDER BY NVL (t5.prt_flag, 99), t5.SEQUENCE)
      LOOP
         IF p_reverse_sw = 'Y'
         THEN
            v.gross_prem := peril.gross_prem * (-1);
            v.ri_prem_amt := peril.ri_prem_amt * (-1);
            v.ri_prem_vat := peril.ri_prem_vat * (-1);
            v.less_comm_vat :=
                 (NVL (peril.ri_prem_vat, 0) - NVL (peril.ri_comm_vat, 0)
                 )
               * (-1);
         ELSE
            v.gross_prem := peril.gross_prem;
            v.ri_prem_amt := peril.ri_prem_amt;
            v.ri_prem_vat := peril.ri_prem_vat;
            v.less_comm_vat :=
                       NVL (peril.ri_prem_vat, 0)
                       - NVL (peril.ri_comm_vat, 0);
         END IF;

         DECLARE
            v_ri_comm_amt                  NUMBER (16, 2)            := 0;
            v_lcomm_amt                    NUMBER (16, 2)            := 0;
            v_comm_vat                     NUMBER (16, 2)            := 0;
            v_param                        VARCHAR2 (500);
            v_foreign_sw                   VARCHAR2 (1);
            v_com_vat                      NUMBER (16, 2);
            v_display_comm_inclusive_vat   giis_document.text%TYPE;
         BEGIN
            BEGIN
               SELECT text
                 INTO v_display_comm_inclusive_vat
                 FROM giis_document
                WHERE report_id = 'GIRIR001'
                  AND title = 'DISPLAY_COMM_INCLUSIVE_VAT';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_display_comm_inclusive_vat := 'N';
            END;

            IF v_display_comm_inclusive_vat = 'Y'
            THEN
               v_ri_comm_amt := peril.ri_comm_amt + peril.peril_comm_vat;
               v.less_comm_vat := 0;
            ELSE
               v_ri_comm_amt := peril.ri_comm_amt;
            END IF;

            v_lcomm_amt := peril.ri_prem_amt - v_ri_comm_amt;
            v_comm_vat := NVL (peril.ri_comm_vat, 0);

            IF p_reverse_sw = 'Y'
            THEN
               v.ri_comm_amt := v_ri_comm_amt * -1;
               v.less_ri_comm_amt := v_lcomm_amt * -1;
               v.ri_comm_vat := v_comm_vat * -1;
            ELSE
               v.ri_comm_amt := v_ri_comm_amt;
               v.less_ri_comm_amt := v_lcomm_amt;
               v.ri_comm_vat := v_comm_vat;
            END IF;
            
            -- apollo cruz 10.15.2015 - these codes negate the codes above
            /* v.ri_comm_amt := v_ri_comm_amt;
            v.less_ri_comm_amt := v_lcomm_amt;
            v.ri_comm_vat := v_comm_vat; */
         END;

         v.ri_comm_rt := peril.ri_comm_rt;
         v.pre_binder_id := peril.pre_binder_id;
         v.line_cd := peril.line_cd;
         v.frps_yy := peril.frps_yy;
         v.frps_seq_no := peril.frps_seq_no;
         v.peril_title := peril.peril_title;
         v.peril_comm_vat := peril.peril_comm_vat;
         v.v_sequence := peril.v_sequence;
         v.prt_flag := peril.prt_flag;
         v.ri_wholding_vat := peril.ri_wholding_vat;
         
         -- jhing03.30.2016 REPUBLICFULLWEB 21773 
         IF v.gross_prem  = 0 and v_display_zero_prem_peril = 'Y' THEN
            v.display_peril := 'Y';
            v.cnt_disp_peril := 1 ; 
         ELSIF v.gross_prem  <> 0  THEN
            v.display_peril := 'Y';
            v.cnt_disp_peril := 1 ; 
         ELSE
            v.display_peril := 'N';
            v.cnt_disp_peril := 0 ; 
         END IF;
            
         v.peril_rowno := NVL(v.peril_rowno,0) + 1 ;         
         
         PIPE ROW (v);
      END LOOP;

      RETURN;
   END get_report_details;
END;