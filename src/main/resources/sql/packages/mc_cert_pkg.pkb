CREATE OR REPLACE PACKAGE BODY CPI.mc_cert_pkg
AS
   FUNCTION get_mc_cert_record (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN mc_cert_tab PIPELINED
   IS
      v_list          mc_cert_type;
      v_mortg_count   NUMBER       := 0;
   BEGIN
      FOR i IN
         (SELECT DISTINCT    a.address1
                          || ' , '
                          || a.address2
                          || ' , '
                          || a.address3 branch_add,
                          a.tel_no, a.branch_fax_no, a.branch_website,
                          c.assd_name, c.assd_name2,
                             d.address1
                          || ', '
                          || d.address2
                          || ', '
                          || d.address3 assd_add,
                             d.line_cd
                          || '-'
                          || d.subline_cd
                          || '-'
                          || d.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (d.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (d.pol_seq_no, '0999999'))
                          || '-'
                          || LTRIM (TO_CHAR (d.renew_no, '09'))
                          || DECODE (NVL (d.endt_seq_no, 0),
                                     0, '',
                                        ' / '
                                     || d.endt_iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (d.endt_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (d.endt_seq_no,
                                                        '0999999'
                                                       )
                                              )
                                    ) POLICY,
                          d.incept_date, d.expiry_date, e.motor_no,
                          e.serial_no, e.plate_no, e.assignee, f.report_id,
                          d.policy_id, g.item_no
                     FROM giis_issource a,
                          gipi_invoice b,
                          giis_assured c,
                          gipi_polbasic d,
                          gipi_vehicle e,
                          giis_signatory f,
                          gipi_item g
                    WHERE a.iss_cd = b.iss_cd
                      AND c.assd_no = d.assd_no
                      AND a.iss_cd = d.iss_cd
                      AND d.policy_id = b.policy_id
                      AND e.policy_id = d.policy_id
                      AND d.line_cd = f.line_cd
                      AND a.iss_cd = f.iss_cd
                      AND b.iss_cd = d.iss_cd
                      AND f.iss_cd = d.iss_cd
                      AND e.policy_id = b.policy_id
                      AND e.subline_cd = d.subline_cd
                      AND f.report_id = 'MC_CERT'
                      AND g.policy_id = d.policy_id
                      AND g.item_no = e.item_no
                      AND d.policy_id = p_policy_id)
      LOOP
         SELECT    a.model_year
                || ' '
                || b.car_company
                || ' '
                || c.make
                || ' '
                || d.engine_series
                || ' '
                || e.type_of_body vehicle
           INTO v_list.vehicle
           FROM gipi_vehicle a,
                gipi_polbasic f,
                giis_mc_car_company b,
                giis_mc_make c,
                giis_mc_eng_series d,
                giis_type_of_body e
          WHERE a.policy_id = f.policy_id
            AND a.car_company_cd = b.car_company_cd(+)
            AND a.car_company_cd = c.car_company_cd(+)
            AND a.make_cd = c.make_cd(+)
            AND a.car_company_cd = d.car_company_cd(+)
            AND a.make_cd = d.make_cd(+)
            AND a.series_cd = d.series_cd(+)
            AND a.type_of_body_cd = e.type_of_body_cd(+)
            AND a.item_no = i.item_no
            AND a.policy_id = p_policy_id;

         SELECT c.basic_color || ' ' || d.color
           INTO v_list.color
           FROM (SELECT DISTINCT a.basic_color, b.basic_color_cd basic_cd
                            FROM giis_mc_color a, gipi_vehicle b
                           WHERE b.basic_color_cd = a.basic_color_cd
                             AND b.item_no = i.item_no
                             AND b.policy_id = p_policy_id) c,
                (SELECT a.color, b.basic_color_cd basic_cd
                   FROM giis_mc_color a, gipi_vehicle b
                  WHERE b.basic_color_cd = a.basic_color_cd(+)
                    AND b.color_cd = a.color_cd(+)
                    AND b.item_no = i.item_no
                    AND b.policy_id = p_policy_id) d
          WHERE c.basic_cd = d.basic_cd;

         --raise_application_error (-20001,'fromdate-todate = '|| to_number(i.fromdate - i.todate));
         v_list.logo_file := giisp.v ('LOGO_FILE');
         v_list.comp_name := giisp.v ('COMPANY_NAME');
         v_list.branch_add := i.branch_add;
         v_list.tel_no := i.tel_no;
         v_list.branch_fax_no := i.branch_fax_no;
         v_list.branch_website := i.branch_website;
         v_list.sys_date :=
                          (TO_CHAR (SYSDATE, 'fmDdth  "day of" Month, YYYY')
                          );
         v_list.POLICY := i.POLICY;
         v_list.assd_add := i.assd_add;
         v_list.incept_date := (TO_CHAR (i.incept_date, 'fmMonth DD, YYYY'));
         v_list.expiry_date := (TO_CHAR (i.expiry_date, 'fmMonth DD, YYYY'));
         v_list.assignee := i.assignee;
         v_list.motor_no := i.motor_no;
         v_list.serial_no := i.serial_no;
         v_list.plate_no := i.plate_no;
         v_list.report_id := i.report_id;
         v_list.policy_id := i.policy_id;
         v_list.assd_name := i.assd_name;
         v_list.assd_name2 := i.assd_name2;
         v_list.item_no := i.item_no;

         IF i.assd_name2 IS NOT NULL
         THEN
            v_list.prin_name2 := (i.assd_name || ' ' || i.assd_name2);
         ELSE
            v_list.prin_name2 := i.assd_name;
         END IF;

         SELECT COUNT (*)
           INTO v_mortg_count
           FROM gipi_mortgagee
          WHERE policy_id = p_policy_id;

         IF v_mortg_count > 1 OR v_mortg_count = 0
         THEN
            SELECT DISTINCT    a.assd_name
                            || ' '
                            || a.assd_name2
                            || CHR (10)
                            || b.address1
                            || ', '
                            || b.address2
                            || ', '
                            || b.address3 assd_add
                       INTO v_list.mortg_name
                       FROM giis_assured a, gipi_polbasic b
                      WHERE a.assd_no = b.assd_no
                            AND b.policy_id = p_policy_id;
         ELSIF v_mortg_count = 1
         THEN
            SELECT DISTINCT b.mortg_name
                       INTO v_list.mortg_name
                       FROM gipi_mortgagee a,
                            giis_mortgagee b,
                            gipi_polbasic c,
                            gipi_item d
                      WHERE a.mortg_cd = b.mortg_cd
                        AND a.policy_id = p_policy_id
                        AND a.policy_id = c.policy_id
                        AND a.item_no = d.item_no
                        AND a.item_no = 0;
         END IF;

         v_list.text :=
            (   ' ;;;;;;   This is to confirm that Motor Car Policy No. '
             || '<b>'
             || v_list.POLICY
             || '</b>'
             || ' issued under the name of '
             || '<b>'
             || v_list.prin_name2
             || '</b>'
             || ' is in full force and effect in accordance with the terms and conditions of this policy.'
            );
         v_list.text2 := (v_list.incept_date || ' to ' || v_list.expiry_date);
         v_list.text3 :=
            (   '     This confirmation is being issued this '
             || v_list.sys_date
             || ' at the request of our client for whatever legal purpose it may serve, despite the non-presentation of company''s official receipt. '
            );

         FOR k IN (SELECT DECODE (label_tag,
                                  'Y', 'Leased To :',
                                  'FAO :'
                                 ) label_tag,
                          a.assd_name, a.assd_name2, b.acct_of_cd
                     FROM giis_assured a, gipi_polbasic b
                    WHERE a.assd_no = b.acct_of_cd
                      AND b.policy_id = p_policy_id)
         LOOP
            IF k.acct_of_cd IS NOT NULL AND k.assd_name2 IS NOT NULL
            THEN
               v_list.prin_name3 :=
                  (k.label_tag || ' ' || k.assd_name || ' ' || k.assd_name2
                  );
            ELSIF k.acct_of_cd IS NOT NULL AND k.assd_name2 IS NULL
            THEN
               v_list.prin_name3 := (k.label_tag || ' ' || k.assd_name);
            ELSIF k.acct_of_cd IS NULL
            THEN
               v_list.prin_name3 := ' ';
            END IF;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END get_mc_cert_record;

   FUNCTION get_ann_tsi_peril (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_peril_cd    giis_peril.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_tsi   gipi_itmperil.tsi_amt%TYPE;
   BEGIN
      SELECT SUM (tsi_amt) sum_tsi
        INTO v_sum_tsi
        FROM gipi_itmperil
       WHERE policy_id = p_policy_id AND peril_cd = p_peril_cd;

      RETURN (v_sum_tsi);
   END get_ann_tsi_peril;

   FUNCTION get_ann_tsi_peril_name (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN ann_tsi_peril_name_tab PIPELINED
   IS
      v_list          ann_tsi_peril_name_type;
      v_line_cd       gipi_polbasic.line_cd%TYPE;
      v_subline_cd    gipi_polbasic.subline_cd%TYPE;
      v_iss_cd        gipi_polbasic.iss_cd%TYPE;
      v_issue_yy      gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no      gipi_polbasic.renew_no%TYPE;
      v_item_no       gipi_item.item_no%TYPE;
      v_expiry_date   gipi_polbasic.expiry_date%TYPE;
      v_eff_date      gipi_polbasic.eff_date%TYPE;
   BEGIN
      FOR item IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.iss_cd,
                                   a.issue_yy, a.pol_seq_no, a.renew_no,
                                   b.item_no, a.eff_date, a.expiry_date
                              FROM gipi_polbasic a, gipi_item b
                             WHERE a.policy_id = p_policy_id
                               AND a.policy_id = b.policy_id
                               AND b.item_no = p_item_no)
      LOOP
         FOR i IN (SELECT DISTINCT c.peril_cd, d.peril_name
                              FROM gipi_polbasic a,
                                   gipi_item b,
                                   gipi_itmperil c,
                                   giis_peril d
                             WHERE a.line_cd = item.line_cd
                               AND a.subline_cd = item.subline_cd
                               AND a.iss_cd = item.iss_cd
                               AND a.issue_yy = item.issue_yy
                               AND a.pol_seq_no = item.pol_seq_no
                               AND a.renew_no = item.renew_no
                               AND b.item_no = item.item_no
                               AND a.pol_flag NOT IN ('4', '5')
                               AND a.policy_id = b.policy_id
                               AND b.policy_id = c.policy_id
                               AND b.item_no = c.item_no
                               AND c.line_cd = d.line_cd
                               AND c.peril_cd = d.peril_cd
                               AND a.policy_id = p_policy_id
                               AND b.item_no = item.item_no
                               AND c.item_no = p_item_no
                               AND TRUNC (item.eff_date)
                                      BETWEEN TRUNC (NVL (from_date, eff_date))
                                          AND TRUNC
                                                (DECODE
                                                    (NVL (a.endt_expiry_date,
                                                          a.expiry_date
                                                         ),
                                                     a.expiry_date, item.expiry_date,
                                                     a.endt_expiry_date, a.endt_expiry_date
                                                    )
                                                ))
         LOOP
            v_list.peril_cd := i.peril_cd;
            v_list.peril_name := i.peril_name;
            v_list.tsi_sum :=
                      mc_cert_pkg.get_ann_tsi_peril (p_policy_id, i.peril_cd);
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END get_ann_tsi_peril_name;

   FUNCTION get_mc_cert_deductible (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN mc_cert_deductible_tab PIPELINED
   IS
      v_list          mc_cert_deductible_type;
      v_line_cd       gipi_polbasic.line_cd%TYPE;
      v_subline_cd    gipi_polbasic.subline_cd%TYPE;
      v_iss_cd        gipi_polbasic.iss_cd%TYPE;
      v_issue_yy      gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no      gipi_polbasic.renew_no%TYPE;
      v_item_no       gipi_item.item_no%TYPE;
      v_expiry_date   gipi_polbasic.expiry_date%TYPE;
      v_eff_date      gipi_polbasic.eff_date%TYPE;
   BEGIN
      FOR k IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.iss_cd,
                                a.issue_yy, a.pol_seq_no, a.renew_no,
                                b.item_no, a.eff_date, a.expiry_date
                           INTO v_line_cd, v_subline_cd, v_iss_cd,
                                v_issue_yy, v_pol_seq_no, v_renew_no,
                                v_item_no, v_eff_date, v_expiry_date
                           FROM gipi_polbasic a, gipi_item b
                          WHERE a.policy_id = p_policy_id
                            AND a.policy_id = b.policy_id
                            AND b.item_no = p_item_no)
      LOOP
         FOR i IN (SELECT SUM (b.deductible_amt) deductible_amt
                     FROM gipi_deductibles b, gipi_polbasic a, gipi_item c
                    WHERE b.item_no = k.item_no
                      AND a.line_cd = k.line_cd
                      AND a.subline_cd = k.subline_cd
                      AND a.iss_cd = k.iss_cd
                      AND a.issue_yy = k.issue_yy
                      AND a.pol_seq_no = k.pol_seq_no
                      AND a.renew_no = k.renew_no
                      AND a.policy_id = b.policy_id
                      AND a.policy_id = c.policy_id
                      AND b.policy_id = c.policy_id
                      AND a.policy_id = p_policy_id
                      AND c.item_no = p_item_no
                      AND b.item_no = k.item_no
                      AND b.ded_line_cd = a.line_cd
                      AND b.ded_subline_cd = a.subline_cd
                      AND pol_flag NOT IN ('4', '5')
                      AND TRUNC (k.eff_date) BETWEEN TRUNC (NVL (from_date,
                                                                 eff_date
                                                                )
                                                           )
                                                 AND TRUNC
                                                       (DECODE
                                                           (NVL
                                                               (a.endt_expiry_date,
                                                                a.expiry_date
                                                               ),
                                                            a.expiry_date, k.expiry_date,
                                                            a.endt_expiry_date, a.endt_expiry_date
                                                           )
                                                       ))
         LOOP
            v_list.deductible_amt := i.deductible_amt;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END get_mc_cert_deductible;

   FUNCTION get_mc_cert_signatory (p_report_id giis_signatory.report_id%TYPE)
      RETURN mc_cert_signatory_tab PIPELINED
   IS
      v_list        mc_cert_signatory_type;
      v_not_exist   BOOLEAN                := TRUE;
   BEGIN
      v_list.signatory :=
            '____________________________________'
         || CHR (10)
         || 'AUTHORIZED SIGNATURE';

      FOR i IN (SELECT DISTINCT b.signatory
                           FROM giis_signatory a,
                                giis_signatory_names b,
                                gipi_polbasic c
                          WHERE 1 = 1
                            AND a.line_cd = c.line_cd
                            AND a.report_id = 'MC_CERT'
                            AND a.iss_cd = c.iss_cd
                            AND a.signatory_id = b.signatory_id
                            AND current_signatory_sw = 'Y'
                            AND b.status = 1
                            AND a.report_id = p_report_id)
      LOOP
         v_not_exist := FALSE;
         v_list.signatory := i.signatory;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_mc_cert_signatory;
END;
/


