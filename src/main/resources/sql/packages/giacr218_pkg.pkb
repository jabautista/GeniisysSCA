CREATE OR REPLACE PACKAGE BODY CPI.giacr218_pkg
AS
   FUNCTION get_giacr218_dtls (
      p_from_date    DATE,
      p_to_date      DATE,
      p_toggle       VARCHAR2,
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_user         giis_users.user_id%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN giacr218_dtls_tab PIPELINED
   AS
      v_list   giacr218_dtls_type;
   BEGIN
      v_list.report_title :=
                      'DISTRIBUTION REGISTER OF PREVIOUSLY TAKEN UP POLICIES';
      v_list.report_date_title :=
            'From '
         || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
         || ' To '
         || TO_CHAR (p_to_date, 'fmMonth DD, YYYY');
      v_list.cf_co_address := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         IF p_toggle = 'A'
         THEN
            v_list.cf_toggle := 'Policies and Endorsements';
         ELSIF p_toggle = 'P'
         THEN
            v_list.cf_toggle := 'Policies Only';
         ELSIF p_toggle = 'E'
         THEN
            v_list.cf_toggle := 'Endorsements Only';
         ELSE
            v_list.cf_toggle := 'Unknown toggle value';
         END IF;
      END;

      BEGIN
         SELECT DISTINCT param_value_v
                    INTO v_list.cf_co_name
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME';
      END;

      FOR i IN (SELECT DISTINCT b.iss_cd, g.iss_name, b.line_cd, e.line_name,
                                b.subline_cd, f.subline_name, b.policy_id,
                                b.policy_no
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
                            AND b.iss_cd = g.iss_cd
                            AND b.iss_cd = NVL (UPPER (p_iss_cd), b.iss_cd)
                            AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                            AND b.share_type = 2
                            AND b.user_id = p_user
                            AND (   (    p_toggle = 'A'
                                     AND b.endt_seq_no = b.endt_seq_no
                                    )
                                 OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                                 OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                                ))
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         v_list.policy_id := i.policy_id;
         v_list.policy_no := i.policy_no;
         PIPE ROW (v_list);
      END LOOP;

      PIPE ROW (v_list);
      RETURN;
   END get_giacr218_dtls;

   FUNCTION get_giacr218_trtytitle (
      p_user      giis_users.user_id%TYPE,
      p_iss_cd    giac_prodrep_peril_ext.iss_cd%TYPE,
      p_line_cd   giac_prodrep_peril_ext.line_cd%TYPE
   )
      RETURN giacr218_trtytitle_tab PIPELINED
   IS
      v_list   giacr218_trtytitle_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, line_cd, share_cd, trty_name
                           FROM giac_prodrep_peril_ext
                          WHERE share_type = 2
                            AND user_id = p_user
                            AND iss_cd = p_iss_cd
                            AND line_cd = p_line_cd)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.share_cd := i.share_cd;
         v_list.trty_name := i.trty_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr218_trtytitle;

   FUNCTION get_giacr218_polamt (
      p_user         giis_users.user_id%TYPE,
      p_iss_cd       giac_prodrep_peril_ext.iss_cd%TYPE,
      p_line_cd      giac_prodrep_peril_ext.line_cd%TYPE,
      p_subline_cd   giac_prodrep_peril_ext.subline_cd%TYPE,
      p_policy_no    giac_prodrep_peril_ext.policy_no%TYPE,
      p_toggle       VARCHAR2
   )
      RETURN giacr218_policyamt_tab PIPELINED
   IS
      v_list   giacr218_policyamt_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.line_cd, b.subline_cd,
                         DECODE (c.peril_type,
                                 'B', '*' || c.peril_sname,
                                 ' ' || c.peril_sname
                                ) peril_sname,
                         SUM (DECODE (c.peril_type,
                                      'B', NVL (b.tr_dist_tsi, 0),
                                      '0'
                                     )
                             ) f_tr_dist_tsi,
                         SUM (NVL (b.tr_dist_tsi, 0)) tr_peril_tsi,
                         SUM (NVL (b.tr_dist_prem, 0)) tr_peril_prem
                    FROM giac_prodrep_peril_ext b, giis_peril c
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND share_type = 2
                     AND b.user_id = p_user
                     AND b.iss_cd = p_iss_cd
                     AND b.line_cd = p_line_cd
                     AND b.subline_cd = p_subline_cd
                     AND b.policy_no = p_policy_no
                     AND (   (p_toggle = 'A' AND b.endt_seq_no = b.endt_seq_no
                             )
                          OR (p_toggle = 'P' AND b.endt_seq_no = 0)
                          OR (p_toggle = 'E' AND b.endt_seq_no > 0)
                         )
                GROUP BY b.iss_cd,
                         b.line_cd,
                         b.subline_cd,
                         c.peril_sname,
                         c.peril_type)
      LOOP
         FOR j IN (SELECT DISTINCT iss_cd, line_cd, share_cd, trty_name
                              FROM giac_prodrep_peril_ext
                             WHERE share_type = 2
                               AND user_id = p_user
                               AND iss_cd = i.iss_cd
                               AND line_cd = i.line_cd)
         LOOP
            v_list.trty_name := j.trty_name;
            v_list.iss_cd := i.iss_cd;
            v_list.line_cd := i.line_cd;
            v_list.subline_cd := i.subline_cd;
            v_list.peril_sname := i.peril_sname;
            v_list.f_tr_dist_tsi := i.f_tr_dist_tsi;
            v_list.tr_peril_tsi := i.tr_peril_tsi;
            v_list.tr_peril_prem := i.tr_peril_prem;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr218_polamt;
END;
/


