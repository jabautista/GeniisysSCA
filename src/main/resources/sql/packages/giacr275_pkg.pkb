CREATE OR REPLACE PACKAGE BODY CPI.giacr275_pkg
AS
   FUNCTION get_giacr_275_report (
      p_date_param   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_intm_no      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd,
                         DECODE (iss_param,
                                 1, 'Crediting Branch :',
                                 'Issuing Source :'
                                ) iss_cd_title,
                         d.intm_type,
                            d.intm_type
                         || '-'
                         || a.intm_cd
                         || '/'
                         || d.ref_intm_cd AS agent_code,
                         a.intm_cd intm_cd, a.intm_name,
                         a.iss_cd || ' - ' || b.iss_name iss_name, a.line_cd,
                         c.line_name, a.share_type, f.share_name,
                         a.acct_trty_type, a.prem_amt, a.iss_param,
                         a.user_id
                    FROM gixx_intm_prod_ext a,
                         giis_issource b,
                         giis_line c,
                         giis_intermediary d,
                         (SELECT DISTINCT b.trty_lname share_name,
                                          share_type share_type,
                                          acct_trty_type
                                     FROM giis_dist_share a,
                                          giis_ca_trty_type b
                                    WHERE a.acct_trty_type = b.ca_trty_type
                                      AND share_type = '2'
                          UNION ALL
                          SELECT UPPER (rv_meaning) share_name,
                                 rv_low_value share_type, NULL
                            FROM cg_ref_codes
                           WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                             AND rv_low_value <> '2') f
                   WHERE UPPER (a.user_id) = UPPER (p_user_id)
                     AND a.iss_cd = b.iss_cd
                     AND a.line_cd = c.line_cd
                     AND f.share_type = a.share_type
                     AND NVL (a.acct_trty_type, 1) =
                            DECODE (a.share_type,
                                    '2', f.acct_trty_type,
                                    NVL (a.acct_trty_type, 1)
                                   )
                     AND a.intm_cd = NVL (p_intm_no, a.intm_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.intm_cd = d.intm_no
                ORDER BY iss_name,
                         intm_name,
                         line_name,
                         share_type,
                         acct_trty_type,
                         share_name)
      LOOP
         FOR c IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'COMPANY_NAME')
         LOOP
            v_list.company_name := c.param_value_v;
         END LOOP;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         v_list.iss_title := i.iss_cd_title;
         v_list.iss_title1 := i.iss_name;
         v_list.prem_amt := i.prem_amt;
         v_list.intm_type := i.intm_type;
         v_list.intm_name := i.intm_name;
         v_list.line_name := i.line_name;
         v_list.prem_amt := i.prem_amt;
         v_list.agent_code := i.agent_code;
         v_list.intm_no := i.intm_cd;
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.share_type := i.share_type;
         v_list.share_name := i.share_name;

         FOR c IN (SELECT DECODE (p_date_param,
                                  1, 'Issue Date',
                                  2, 'Incept Date ',
                                  3, 'Booking Date',
                                  4, 'Accounting Entry Date'
                                 ) AS date_param
                     FROM DUAL)
         LOOP
            v_list.date_parameter := 'Based on ' || c.date_param;
         END LOOP;

         IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
         THEN
            v_list.from_to_date :=
                  'From '
               || TO_CHAR (TO_DATE (p_from_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_list.date_parameter IS NULL THEN
         FOR c IN (SELECT DECODE (p_date_param,
                                  1, 'Issue Date',
                                  2, 'Incept Date ',
                                  3, 'Booking Date',
                                  4, 'Accounting Entry Date'
                                 ) AS date_param
                     FROM DUAL)
         LOOP
            v_list.date_parameter := 'Based on ' || c.date_param;
         END LOOP;

         IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
         THEN
            v_list.from_to_date :=
                  'From '
               || TO_CHAR (TO_DATE (p_from_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_date, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          );
         END IF;
         
         v_list.iss_title := ' ';
         v_list.iss_title1 := ' ';

         PIPE ROW (v_list);
      END IF;
      
   END get_giacr_275_report;

   FUNCTION get_giacr_275_dtls
      RETURN giacr275_tab PIPELINED
   IS
      v_list   giacr275_type;
   BEGIN
      FOR i IN (SELECT DISTINCT INITCAP (b.trty_lname) share_name_title,
                                share_type share_type_title, ca_trty_type
                           FROM giis_dist_share a, giis_ca_trty_type b
                          WHERE a.acct_trty_type = b.ca_trty_type
                            AND share_type <> '4'
                UNION ALL
                SELECT   INITCAP (rv_meaning) share_name_title,
                         rv_low_value share_type_title, NULL ca_trty_type
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                     AND rv_low_value <> '2'
                ORDER BY share_type_title, ca_trty_type, share_name_title)
      LOOP
         v_list.share_name_title := i.share_name_title;
         v_list.ca_trty_type := i.ca_trty_type;
         v_list.share_type_title := i.share_type_title;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_275_dtls;

   FUNCTION get_giacr_275_agent (
      p_intm_no      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_user_id      VARCHAR2,
      p_share_type   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd line_iss_cd, a.share_type line_share_type,
                         f.share_name line_share_name,
                         a.acct_trty_type line_acct_trty_type,
                         intm_cd line_intm_no, SUM (a.prem_amt)
                                                               line_prem_amt,
                         a.line_cd
                    FROM gixx_intm_prod_ext a,
                         giis_issource b,
                         giis_line c,
                         (SELECT DISTINCT b.trty_lname share_name,
                                          share_type share_type,
                                          acct_trty_type, ca_trty_type
                                     FROM giis_dist_share a,
                                          giis_ca_trty_type b
                                    WHERE a.acct_trty_type = b.ca_trty_type
                                      AND share_type = '2'
                          UNION ALL
                          SELECT UPPER (rv_meaning) share_name,
                                 rv_low_value share_type, NULL, NULL
                            FROM cg_ref_codes
                           WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                             AND rv_low_value <> '2') f
                   WHERE UPPER (a.user_id) = UPPER (p_user_id)
                     AND a.iss_cd = b.iss_cd
                     AND a.line_cd = c.line_cd
                     AND f.share_type = a.share_type
                     AND NVL (a.acct_trty_type, 1) =
                            DECODE (a.share_type,
                                    '2', f.acct_trty_type,
                                    NVL (a.acct_trty_type, 1)
                                   )
                     AND a.intm_cd = NVL (p_intm_no, a.intm_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.share_type = NVL (p_share_type, a.share_type)
                GROUP BY a.share_type,
                         ca_trty_type,
                         a.acct_trty_type,
                         f.share_name,
                         a.intm_cd,
                         a.iss_cd,
                         a.line_cd
                ORDER BY a.share_type, ca_trty_type)
      LOOP
         v_list.line_prem_amt := NVL (i.line_prem_amt, 0);
         v_list.line_iss_cd := i.line_iss_cd;
         v_list.line_share_type := i.line_share_type;
         v_list.line_share_name := i.line_share_name;
         v_list.line_intm_no := i.line_intm_no;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_275_agent;
END;
/


