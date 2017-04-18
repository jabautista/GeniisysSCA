CREATE OR REPLACE PACKAGE BODY CPI.giacr198_pkg
AS
   FUNCTION get_giacr198_title
      RETURN VARCHAR2
   IS
      v_reportnm   VARCHAR2 (75);
      v_exists     BOOLEAN       := FALSE;
   BEGIN
      FOR k IN (SELECT report_title
                  FROM giis_reports
                 WHERE report_id = 'GIACR198')
      LOOP
         v_reportnm := k.report_title;
         v_exists := TRUE;
         EXIT;
      END LOOP;

      IF v_exists
      THEN
         RETURN (v_reportnm);
      ELSE
         v_reportnm := 'No report found in GIIS_REPORTS';
         RETURN (v_reportnm);
      END IF;

      RETURN NULL;
   END get_giacr198_title;

   FUNCTION get_giacr198_as_date (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (50);
   BEGIN
      RETURN (   'From '
              || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
              || ' to '
              || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
             );
   END get_giacr198_as_date;

   FUNCTION get_giacr198_record (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_tab PIPELINED
   IS
      v_list        giacr198_type;
      v_not_exist   BOOLEAN       := TRUE;
      v_from_date   DATE          := TO_DATE (p_from_date, 'MM/dd/yyyy');
      v_to_date     DATE          := TO_DATE (p_to_date, 'MM/dd/yyyy');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.title := get_giacr198_title;
      v_list.as_date := get_giacr198_as_date (v_from_date, v_to_date);

      FOR i IN (SELECT   DECODE ('I',
                                 'I', b.iss_cd,
                                 'C', b.cred_branch
                                ) p_cred_iss,
                         g.iss_name, b.line_cd, e.line_name, b.subline_cd,
                         f.subline_name, b.policy_no,
                         DECODE (c.peril_type,
                                 'B', '*' || c.peril_sname,
                                 ' ' || c.peril_sname
                                ) peril_sname,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.nr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_nr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.tr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_tr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.fa_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_fa_dist_tsi,
                         SUM (NVL (b.nr_dist_tsi, 0) * b.currency_rt
                             ) nr_peril_tsi,
                         SUM (NVL (b.nr_dist_prem, 0) * b.currency_rt
                             ) nr_peril_prem,
                         SUM (NVL (b.tr_dist_tsi, 0) * b.currency_rt
                             ) tr_peril_tsi,
                         SUM (NVL (b.tr_dist_prem, 0) * b.currency_rt
                             ) tr_peril_prem,
                         SUM (NVL (b.fa_dist_tsi, 0) * b.currency_rt
                             ) fa_peril_tsi,
                         SUM (NVL (b.fa_dist_prem, 0) * b.currency_rt
                             ) fa_peril_prem,
                         c.peril_cd
                    FROM giac_prodrep_peril_ext b,
                         giis_peril c,
                         giis_subline f,
                         giis_dist_share d,
                         giis_issource g,
                         giis_line e
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = f.line_cd
                     AND b.subline_cd = f.subline_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.line_cd = e.line_cd
                     AND DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch) =
                                                                      g.iss_cd
                     AND DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch) =
                            NVL (UPPER (p_iss_cd),
                                 DECODE ('I',
                                         'I', b.iss_cd,
                                         'C', b.cred_branch
                                        )
                                )
                     AND b.user_id = p_user
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND (   (p_toggle = 'A' AND b.endt_seq_no = b.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                         )
                GROUP BY DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch),
                         g.iss_name,
                         b.line_cd,
                         e.line_name,
                         b.subline_cd,
                         f.subline_name,
                         b.policy_no,
                         c.peril_sname,
                         c.peril_type,
                         c.peril_cd)
      LOOP
         v_not_exist := FALSE;
         v_list.p_cred_iss := i.p_cred_iss;
         v_list.iss_name := i.iss_name;
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         v_list.policy_no := i.policy_no;
         v_list.peril_sname := i.peril_sname;
         v_list.f_nr_dist_tsi := i.f_nr_dist_tsi;
         v_list.f_tr_dist_tsi := i.f_tr_dist_tsi;
         v_list.f_fa_dist_tsi := i.f_fa_dist_tsi;
         v_list.nr_peril_tsi := i.nr_peril_tsi;
         v_list.nr_peril_prem := i.nr_peril_prem;
         v_list.tr_peril_tsi := i.tr_peril_tsi;
         v_list.tr_peril_prem := i.tr_peril_prem;
         v_list.fa_peril_tsi := i.fa_peril_tsi;
         v_list.fa_peril_prem := i.fa_peril_prem;
         v_list.peril_cd := i.peril_cd;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giacr198_record;

   FUNCTION get_giacr198_q1 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q1_tab PIPELINED
   IS
      v_list   giacr198_q1_type;
   BEGIN
      FOR i IN (SELECT   DECODE ('I',
                                 'I', b.iss_cd,
                                 'C', b.cred_branch
                                ) p_cred_iss,
                         b.line_cd, b.subline_cd, c.peril_sname peril_sname2,
                         DECODE (c.peril_type,
                                 'B', '*' || c.peril_sname,
                                 ' ' || c.peril_sname
                                ) peril_sname,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.nr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_nr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.tr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_tr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.fa_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_fa_dist_tsi,
                         SUM (NVL (b.nr_dist_tsi, 0) * b.currency_rt
                             ) nr_peril_tsi,
                         SUM (NVL (b.nr_dist_prem, 0) * b.currency_rt
                             ) nr_peril_prem,
                         SUM (NVL (b.tr_dist_tsi, 0) * b.currency_rt
                             ) tr_peril_tsi,
                         SUM (NVL (b.tr_dist_prem, 0) * b.currency_rt
                             ) tr_peril_prem,
                         SUM (NVL (b.fa_dist_tsi, 0) * b.currency_rt
                             ) fa_peril_tsi,
                         SUM (NVL (b.fa_dist_prem, 0) * b.currency_rt
                             ) fa_peril_prem,
                         c.peril_cd
                    FROM giac_prodrep_peril_ext b,
                         giis_peril c,
                         giis_dist_share d
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.user_id = p_user
                     AND DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch) =
                            NVL (UPPER (p_iss_cd),
                                 DECODE ('I',
                                         'I', b.iss_cd,
                                         'C', b.cred_branch
                                        )
                                )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND (   (p_toggle = 'A' AND b.endt_seq_no = b.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                         )
                GROUP BY DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch),
                         b.line_cd,
                         b.subline_cd,
                         c.peril_sname,
                         c.peril_type,
                         c.peril_cd)
      LOOP
         v_list.peril_sname2 := i.peril_sname2;
         v_list.p_cred_iss := i.p_cred_iss;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.peril_sname := i.peril_sname;
         v_list.f_nr_dist_tsi := i.f_nr_dist_tsi;
         v_list.f_tr_dist_tsi := i.f_tr_dist_tsi;
         v_list.f_fa_dist_tsi := i.f_fa_dist_tsi;
         v_list.nr_peril_tsi := i.nr_peril_tsi;
         v_list.nr_peril_prem := i.nr_peril_prem;
         v_list.tr_peril_tsi := i.tr_peril_tsi;
         v_list.tr_peril_prem := i.tr_peril_prem;
         v_list.fa_peril_tsi := i.fa_peril_tsi;
         v_list.fa_peril_prem := i.fa_peril_prem;
         v_list.peril_cd := i.peril_cd;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr198_q1;

   FUNCTION get_giacr198_q3 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q3_tab PIPELINED
   IS
      v_list   giacr198_q3_type;
   BEGIN
      FOR i IN (SELECT   DECODE ('I',
                                 'I', b.iss_cd,
                                 'C', b.cred_branch
                                ) p_cred_iss,
                         b.line_cd,
                         DECODE (c.peril_type,
                                 'B', '*' || c.peril_sname,
                                 ' ' || c.peril_sname
                                ) peril_sname,
                         c.peril_sname peril_sname2,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.nr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_nr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.tr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_tr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.fa_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_fa_dist_tsi,
                         SUM (NVL (b.nr_dist_tsi, 0) * b.currency_rt
                             ) nr_peril_tsi,
                         SUM (NVL (b.nr_dist_prem, 0) * b.currency_rt
                             ) nr_peril_prem,
                         SUM (NVL (b.tr_dist_tsi, 0) * b.currency_rt
                             ) tr_peril_tsi,
                         SUM (NVL (b.tr_dist_prem, 0) * b.currency_rt
                             ) tr_peril_prem,
                         SUM (NVL (b.fa_dist_tsi, 0) * b.currency_rt
                             ) fa_peril_tsi,
                         SUM (NVL (b.fa_dist_prem, 0) * b.currency_rt
                             ) fa_peril_prem,
                         c.peril_cd
                    FROM giac_prodrep_peril_ext b,
                         giis_peril c,
                         giis_dist_share d
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.user_id = p_user
                     AND DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch) =
                            NVL (UPPER (p_iss_cd),
                                 DECODE ('I',
                                         'I', b.iss_cd,
                                         'C', b.cred_branch
                                        )
                                )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND (   (p_toggle = 'A' AND b.endt_seq_no = b.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                         )
                GROUP BY DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch),
                         b.line_cd,
                         c.peril_sname,
                         c.peril_type,
                         c.peril_cd)
      LOOP
         v_list.peril_sname2 := i.peril_sname2;
         v_list.p_cred_iss := i.p_cred_iss;
         v_list.line_cd := i.line_cd;
         v_list.peril_sname := i.peril_sname;
         v_list.f_nr_dist_tsi := i.f_nr_dist_tsi;
         v_list.f_tr_dist_tsi := i.f_tr_dist_tsi;
         v_list.f_fa_dist_tsi := i.f_fa_dist_tsi;
         v_list.nr_peril_tsi := i.nr_peril_tsi;
         v_list.nr_peril_prem := i.nr_peril_prem;
         v_list.tr_peril_tsi := i.tr_peril_tsi;
         v_list.tr_peril_prem := i.tr_peril_prem;
         v_list.fa_peril_tsi := i.fa_peril_tsi;
         v_list.fa_peril_prem := i.fa_peril_prem;
         v_list.peril_cd := i.peril_cd;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr198_q3;

   FUNCTION get_giacr198_q4 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q4_tab PIPELINED
   IS
      v_list   giacr198_q4_type;
   BEGIN
      FOR i IN (SELECT   DECODE ('I',
                                 'I', b.iss_cd,
                                 'C', b.cred_branch
                                ) p_cred_iss,
                         DECODE (c.peril_type,
                                 'B', '*' || c.peril_sname,
                                 '    ' || c.peril_sname
                                ) peril_sname,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.nr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_nr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.tr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_tr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.fa_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_fa_dist_tsi,
                         SUM (NVL (b.nr_dist_tsi, 0) * b.currency_rt
                             ) nr_peril_tsi,
                         SUM (NVL (b.nr_dist_prem, 0) * b.currency_rt
                             ) nr_peril_prem,
                         SUM (NVL (b.tr_dist_tsi, 0) * b.currency_rt
                             ) tr_peril_tsi,
                         SUM (NVL (b.tr_dist_prem, 0) * b.currency_rt
                             ) tr_peril_prem,
                         SUM (NVL (b.fa_dist_tsi, 0) * b.currency_rt
                             ) fa_peril_tsi,
                         SUM (NVL (b.fa_dist_prem, 0) * b.currency_rt
                             ) fa_peril_prem
                    FROM giac_prodrep_peril_ext b,
                         giis_peril c,
                         giis_dist_share d
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.user_id = p_user
                     AND DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch) =
                            NVL (UPPER (p_iss_cd),
                                 DECODE ('I',
                                         'I', b.iss_cd,
                                         'C', b.cred_branch
                                        )
                                )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND (   (p_toggle = 'A' AND b.endt_seq_no = b.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                         )
                GROUP BY DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch),
                         c.peril_sname,
                         c.peril_type)
      LOOP
         v_list.p_cred_iss := i.p_cred_iss;
         v_list.peril_sname := i.peril_sname;
         v_list.f_nr_dist_tsi := i.f_nr_dist_tsi;
         v_list.f_tr_dist_tsi := i.f_tr_dist_tsi;
         v_list.f_fa_dist_tsi := i.f_fa_dist_tsi;
         v_list.nr_peril_tsi := i.nr_peril_tsi;
         v_list.nr_peril_prem := i.nr_peril_prem;
         v_list.tr_peril_tsi := i.tr_peril_tsi;
         v_list.tr_peril_prem := i.tr_peril_prem;
         v_list.fa_peril_tsi := i.fa_peril_tsi;
         v_list.fa_peril_prem := i.fa_peril_prem;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr198_q4;

   FUNCTION get_giacr198_q5 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q5_tab PIPELINED
   IS
      v_list   giacr198_q5_type;
   BEGIN
      FOR i IN (SELECT   DECODE (c.peril_type,
                                 'B', '*' || c.peril_sname,
                                 '    ' || c.peril_sname
                                ) peril_sname,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.nr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_nr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.tr_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_tr_dist_tsi,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.fa_dist_tsi, 0)
                                       * b.currency_rt,
                                      '0'
                                     )
                             ) f_fa_dist_tsi,
                         SUM (NVL (b.nr_dist_tsi, 0) * b.currency_rt
                             ) nr_peril_tsi,
                         SUM (NVL (b.nr_dist_prem, 0) * b.currency_rt
                             ) nr_peril_prem,
                         SUM (NVL (b.tr_dist_tsi, 0) * b.currency_rt
                             ) tr_peril_tsi,
                         SUM (NVL (b.tr_dist_prem, 0) * b.currency_rt
                             ) tr_peril_prem,
                         SUM (NVL (b.fa_dist_tsi, 0) * b.currency_rt
                             ) fa_peril_tsi,
                         SUM (NVL (b.fa_dist_prem, 0) * b.currency_rt
                             ) fa_peril_prem
                    FROM giac_prodrep_peril_ext b,
                         giis_peril c,
                         giis_dist_share d
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.user_id = p_user
                     AND DECODE ('I', 'I', b.iss_cd, 'C', b.cred_branch) =
                            NVL (UPPER (p_iss_cd),
                                 DECODE ('I',
                                         'I', b.iss_cd,
                                         'C', b.cred_branch
                                        )
                                )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND (   (p_toggle = 'A' AND b.endt_seq_no = b.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                         )
                GROUP BY c.peril_sname, c.peril_type)
      LOOP
         v_list.peril_sname := i.peril_sname;
         v_list.f_nr_dist_tsi := i.f_nr_dist_tsi;
         v_list.f_tr_dist_tsi := i.f_tr_dist_tsi;
         v_list.f_fa_dist_tsi := i.f_fa_dist_tsi;
         v_list.nr_peril_tsi := i.nr_peril_tsi;
         v_list.nr_peril_prem := i.nr_peril_prem;
         v_list.tr_peril_tsi := i.tr_peril_tsi;
         v_list.tr_peril_prem := i.tr_peril_prem;
         v_list.fa_peril_tsi := i.fa_peril_tsi;
         v_list.fa_peril_prem := i.fa_peril_prem;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr198_q5;
END;
/


