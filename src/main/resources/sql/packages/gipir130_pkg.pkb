CREATE OR REPLACE PACKAGE BODY CPI.gipir130_pkg
AS
   FUNCTION get_group_one (p_dist_no VARCHAR2)
      RETURN group_one_tab PIPELINED
   IS
      v   group_one_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_name, b.subline_name, c.line_cd,
                                c.subline_cd, c.iss_cd, c.issue_yy,
                                c.pol_seq_no, c.renew_no, c.endt_iss_cd,
                                c.endt_yy, c.endt_seq_no, d.assd_name,
                                e.eff_date, e.expiry_date, e.dist_no
                           FROM giis_line a,
                                giis_subline b,
                                gipi_polbasic c,
                                giis_assured d,
                                giuw_pol_dist e,
                                giuw_policyds_dtl f
                          WHERE e.dist_no = p_dist_no
                            AND c.line_cd = a.line_cd
                            AND c.subline_cd = b.subline_cd
                            AND c.assd_no = d.assd_no
                            AND e.dist_no = f.dist_no
                            AND f.line_cd = b.line_cd
                            AND e.policy_id = c.policy_id)
      LOOP
         v.line_name := i.line_name;
         v.subline_name := i.subline_name;
         v.line_cd := i.line_cd;
         v.subline_cd := i.subline_cd;
         v.iss_cd := i.iss_cd;
         v.issue_yy := i.issue_yy;
         v.pol_seq_no := i.pol_seq_no;
         v.renew_no := i.renew_no;
         v.endt_iss_cd := i.endt_iss_cd;
         v.endt_yy := i.endt_yy;
         v.endt_seq_no := i.endt_seq_no;
         v.assd_name := i.assd_name;
         v.eff_date := i.eff_date;
         v.expiry_date := i.expiry_date;
         v.dist_no := i.dist_no;
         v.policy_no :=
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || i.iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '09'));
         v.duration :=
               'FROM '
            || TO_CHAR (i.eff_date, 'FMMonth dd, yyyy')
            || ' TO '
            || TO_CHAR (i.expiry_date, 'FMMonth dd, yyyy');
            
          IF i.endt_seq_no <> 0
          THEN
          v.endt_no :=
               i.endt_iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.endt_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.endt_seq_no, '0999999'));
          ELSE
          v.endt_no := null;  
            
          END IF;
            
            
         PIPE ROW (v);
      END LOOP;
   END get_group_one;

   FUNCTION get_group_two (p_dist_no VARCHAR2)
      RETURN group_two_tab PIPELINED
   IS
      v   group_two_type;
   BEGIN
      BEGIN
         SELECT text
           INTO v.display_peril_breakdown
           FROM giis_document
          WHERE report_id = 'GIPIR130' AND title = 'DISPLAY_PERIL_BREAKDOWN';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v.display_peril_breakdown := 'Y';
      END;

      FOR i IN (SELECT   a.dist_seq_no, a.tsi_amt, b.currency_desc,
                         a.prem_amt
                    FROM giuw_policyds a,
                         giis_currency b,
                         gipi_polbasic c,
                         gipi_invoice d,
                         giuw_pol_dist e
                   WHERE e.policy_id = c.policy_id
                     AND a.dist_no = e.dist_no
                     AND a.item_grp = d.item_grp
                     AND c.policy_id = d.policy_id
                     AND d.currency_cd = b.main_currency_cd
                     AND nvl(d.takeup_seq_no,1) = NVL(e.takeup_seq_no,1) 
                     AND DECODE ( e.item_grp, NULL, d.item_grp, e.item_grp) = d.item_grp
                     AND a.dist_no = p_dist_no
                     
                ORDER BY a.dist_seq_no)
      LOOP
         v.dist_seq_no := i.dist_seq_no;
         v.tsi_amt := i.tsi_amt;
         v.currency := i.currency_desc;
         v.prem_amt := i.prem_amt;
         PIPE ROW (v);
      END LOOP;
   END get_group_two;

   FUNCTION get_group_three (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN group_three_tab PIPELINED
   IS
      v   group_three_type;
   BEGIN
      FOR i IN (SELECT   a.trty_name, b.dist_spct, b.dist_spct1, b.dist_prem,
                         b.dist_tsi
                    FROM giis_dist_share a, giuw_policyds_dtl b
                   WHERE a.line_cd = b.line_cd
                     AND a.share_cd = b.share_cd
                     AND b.dist_no = p_dist_no
                     AND b.dist_seq_no = p_dist_seq_no
                ORDER BY b.dist_seq_no)
      LOOP
         v.trty_name := i.trty_name;
         v.dist_spct := i.dist_spct;
         v.dist_spct1 := i.dist_spct1;
         v.dist_prem := i.dist_prem;
         v.dist_tsi := i.dist_tsi;
         PIPE ROW (v);
      END LOOP;
   END get_group_three;

   FUNCTION get_group_four (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN group_four_tab PIPELINED
   IS
      v   group_four_type;
   BEGIN
      FOR i IN (SELECT   b.ri_sname, a.line_cd, a.binder_yy, a.binder_seq_no,
                         c.ri_shr_pct, c.ri_tsi_amt, c.ri_shr_pct2,
                         c.ri_prem_amt, c.ri_comm_rt, c.ri_comm_amt,
                         c.ri_comm_vat
                    FROM giri_binder a,
                         giis_reinsurer b,
                         giri_frps_ri c,
                         giuw_pol_dist d,
                         giuw_policyds e,
                         giri_distfrps f
                   WHERE d.dist_no = e.dist_no
                     AND e.dist_no = f.dist_no
                     AND e.dist_seq_no = f.dist_seq_no
                     AND f.line_cd = c.line_cd
                     AND f.frps_yy = c.frps_yy
                     AND f.frps_seq_no = c.frps_seq_no
                     AND c.fnl_binder_id = a.fnl_binder_id
                     AND NVL (c.reverse_sw, 'N') = 'N'
                     AND a.reverse_date IS NULL
                     AND c.ri_cd = b.ri_cd
                     AND d.dist_no = p_dist_no
                     AND e.dist_seq_no = p_dist_seq_no
                ORDER BY e.dist_seq_no)
      LOOP
         v.ri_sname := i.ri_sname;
         v.line_cd := i.line_cd;
         v.binder_yy := i.binder_yy;
         v.binder_seq_no := i.binder_seq_no;
         v.ri_shr_pct := i.ri_shr_pct;
         v.ri_tsi_amt := i.ri_tsi_amt;
         v.ri_shr_pct2 := i.ri_shr_pct2;
         v.ri_prem_amt := i.ri_prem_amt;
         v.ri_comm_rt := i.ri_comm_rt;
         v.ri_comm_amt := i.ri_comm_amt;
         v.ri_comm_vat := i.ri_comm_vat;
         v.binder_no :=
               i.line_cd
            || '-'
            || LTRIM (TO_CHAR (i.binder_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.binder_seq_no, '09999'));
         v.net_due := (i.ri_prem_amt - i.ri_comm_amt - i.ri_comm_vat);
         PIPE ROW (v);
      END LOOP;
   END get_group_four;

   FUNCTION get_group_five (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN group_five_tab PIPELINED
   IS
      v             group_five_type;
      v_tsi         NUMBER;
      v_prem        NUMBER;
      v_count       NUMBER          := 1;
      v_row_count   NUMBER          := 1;
      v_peril       VARCHAR2 (500);
      cursor group_five IS
      
      SELECT DISTINCT b.trty_name, b.share_cd
                              FROM giis_peril a,
                                   giis_dist_share b,
                                   giuw_perilds_dtl c
                             WHERE c.peril_cd = a.peril_cd
                               AND c.line_cd = b.line_cd
                               AND c.share_cd = b.share_cd
                               AND c.dist_no = p_dist_no
                               AND c.dist_seq_no = p_dist_seq_no
                          ORDER BY b.share_cd;
   BEGIN
      FOR i IN (SELECT   a.peril_sname, b.share_cd, b.trty_name, c.dist_tsi, a.peril_type,
                         c.dist_prem
                    FROM giis_peril a,
                         giis_dist_share b,
                         giuw_perilds_dtl c
                   WHERE  c.peril_cd = a.peril_cd
                     AND c.line_cd = b.line_cd
                     AND c.share_cd = b.share_cd
                     AND c.dist_no = p_dist_no
                     AND c.dist_seq_no = p_dist_seq_no
                     AND a.line_cd = b.line_cd
                ORDER BY c.peril_cd, c.share_cd)
      LOOP
         FOR j IN group_five  
         LOOP
            IF v.peril_sname <> i.peril_sname
            THEN
               PIPE ROW (v);
               v.row_count := 1;
               v_count := 1;
               v.dist_tsi1 := 0;
               v.dist_tsi2 := 0;
               v.dist_tsi3 := 0;
               v.dist_tsi4 := 0;
               v.dist_prem1 := 0;
               v.dist_prem2 := 0;
               v.dist_prem3 := 0;
               v.dist_prem4 := 0;
            END IF;

            v.peril_sname := i.peril_sname;

            IF i.share_cd = j.share_cd
            THEN
               v_tsi := i.dist_tsi;
               v_prem := i.dist_prem;
               EXIT;
            ELSE
               v_tsi := 0;
               v_prem := 0;
            END IF;
         END LOOP;

         IF v_count = 1
         THEN
            v.dist_tsi1 := v_tsi;
            v.dist_prem1 := v_prem;
            IF i.peril_type = 'B'
            THEN
            v.dist_total_tsi1 := NVL(v.dist_total_tsi1,0) + v.dist_tsi1;
            END IF;
         ELSIF v_count = 2
         THEN
            v.dist_tsi2 := v_tsi;
            v.dist_prem2 := v_prem;
            IF i.peril_type = 'B'
            THEN
            v.dist_total_tsi2 := NVL(v.dist_total_tsi2,0) + v.dist_tsi2;
            END IF;
         ELSIF v_count = 3
         THEN
            v.dist_tsi3 := v_tsi;
            v.dist_prem3 := v_prem;
            IF i.peril_type = 'B'
            THEN
            v.dist_total_tsi3 := NVL(v.dist_total_tsi3,0) + v.dist_tsi3;
            END IF;
         ELSIF v_count = 4
         THEN
            v.dist_tsi4 := v_tsi;
            v.dist_prem4 := v_prem;
            IF i.peril_type = 'B'
            THEN
            v.dist_total_tsi4 := NVL(v.dist_total_tsi4,0) + v.dist_tsi4;
            END IF;
            PIPE ROW (v);
            v.row_count := v.row_count + 1;
            v_count := 0;
            v.dist_tsi1 := 0;
            v.dist_tsi2 := 0;
            v.dist_tsi3 := 0;
            v.dist_tsi4 := 0;
            v.dist_prem1 := 0;
            v.dist_prem2 := 0;
            v.dist_prem3 := 0;
            v.dist_prem4 := 0;
         END IF;

         v_count := v_count + 1;
      END LOOP;

      IF v_count <> 1
      THEN
         PIPE ROW (v);
      END IF;
   END get_group_five;

   FUNCTION get_col_tab (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN col_tab PIPELINED
   IS
      v                   col_type;
      v_col_count         NUMBER        := 1;
      v_report_paramter   VARCHAR2 (50);
   BEGIN
      FOR i IN (SELECT DISTINCT b.trty_name, b.share_cd
                           FROM giis_peril a,
                                giis_dist_share b,
                                giuw_perilds_dtl c
                          WHERE  c.peril_cd = a.peril_cd
                            AND c.line_cd = b.line_cd
                            AND c.share_cd = b.share_cd
                            AND c.dist_no = p_dist_no
                            AND c.dist_seq_no = p_dist_seq_no
                       ORDER BY b.share_cd)
      LOOP
         IF v_col_count = 1
         THEN
            v.trty_name1 := i.trty_name;
            v.share_cd1 := i.share_cd;
         ELSIF v_col_count = 2
         THEN
            v.trty_name2 := i.trty_name;
            v.share_cd2 := i.share_cd;
         ELSIF v_col_count = 3
         THEN
            v.trty_name3 := i.trty_name;
            v.share_cd3 := i.share_cd;
         ELSIF v_col_count = 4
         THEN
            v.trty_name4 := i.trty_name;
            v.share_cd4 := i.share_cd;
            PIPE ROW (v);
            v.row_count := v.row_count + 1;
            v.trty_name1 := NULL;
            v.trty_name2 := NULL;
            v.trty_name3 := NULL;
            v.trty_name4 := NULL;
            v.share_cd1 := NULL;
            v.share_cd2 := NULL;
            v.share_cd3 := NULL;
            v.share_cd4 := NULL;
            v_col_count := 0;
         END IF;

         v_col_count := v_col_count + 1;
      END LOOP;

      IF v_col_count <> 1
      THEN
         PIPE ROW (v);
      END IF;
   END get_col_tab;
END;
/
