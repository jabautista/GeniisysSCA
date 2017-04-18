CREATE OR REPLACE PACKAGE BODY CPI.gipir923e_pkg
AS
/*
   **  Created by   :  Jasmin G. Balingit
   **  Date Created : 05.08.2012
   */
   FUNCTION populate_gipir923e (
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE, 
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      -- p_from_date    gipi_uwreports_ext.from_date%TYPE,
      -- p_to_date      gipi_uwreports_ext.TO_DATE%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN report_tab PIPELINED
   AS
      rep   report_type;
   BEGIN
      FOR i IN (SELECT   DECODE (spld_date,
                                 NULL, DECODE (dist_flag, 3, 'D', 'U'),
                                 'S'
                                ) "DIST_FLAG",
                         line_cd, subline_cd, iss_cd,
                         DECODE (p_iss_param,
                                 1, cred_branch,
                                 iss_cd
                                ) iss_cd_header,
                         issue_yy, pol_seq_no, renew_no, endt_iss_cd,
                         endt_yy, endt_seq_no, issue_date, incept_date,
                         expiry_date, total_tsi, total_prem
                                                           /*
                                                           ,evatprem
                                                           ,lgt
                                                           ,fst
                                                           ,doc_stamps
                                                           ,other_taxes
                                                           */
                         ,
                           NVL (total_prem, 0)
                         + NVL (tax1, 0)
                         + NVL (tax2, 0)
                         + NVL (tax3, 0)
                         + NVL (tax4, 0)
                         + NVL (tax5, 0)
                         + NVL (tax6, 0)
                         + NVL (tax7, 0)
                         + NVL (tax8, 0)
                         + NVL (tax9, 0)
                         + NVL (tax10, 0)
                         + NVL (tax11, 0)
                         + NVL (tax12, 0)
                         + NVL (tax13, 0)
                         + NVL (tax14, 0)
                         + NVL (tax15, 0) "TOTAL_CHARGES"
                                                         --,(total_prem + evatprem + lgt + doc_stamps + fst + other_taxes)  "TOTAL CHARGES"
                         ,
                           NVL (tax1, 0)
                         + NVL (tax2, 0)
                         + NVL (tax3, 0)
                         + NVL (tax4, 0)
                         + NVL (tax5, 0)
                         + NVL (tax6, 0)
                         + NVL (tax7, 0)
                         + NVL (tax8, 0)
                         + NVL (tax9, 0)
                         + NVL (tax10, 0)
                         + NVL (tax11, 0)
                         + NVL (tax12, 0)
                         + NVL (tax13, 0)
                         + NVL (tax14, 0)
                         + NVL (tax15, 0) total_taxes
                                                     --,(evatprem + lgt + doc_stamps + fst + other_taxes) TOTAL_TAXES
                         ,
                         param_date, from_date, TO_DATE, SCOPE, user_id,
                         policy_id, assd_no, spld_date,
                         DECODE (spld_date, NULL, 1, 1) pol_count, evatprem , lgt , doc_stamps , fst , other_taxes, other_charges
                    FROM gipi_uwreports_ext
                   WHERE user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param, 1, cred_branch, iss_cd)
                                )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (p_scope = 4 AND pol_flag = '5')
                ORDER BY iss_cd,
                        line_cd,
                         subline_cd,                       
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         endt_seq_no)
      LOOP
         rep.line_cd := i.line_cd;
         rep.subline_cd := i.subline_cd;
         rep.iss_cd_header := i.iss_cd_header;
         rep.total_charges := i.total_charges;
         rep.total_taxes := i.total_taxes;
         rep.dist_flag := i.dist_flag;
         rep.pol_count := i.pol_count;
         rep.spld_date := TO_CHAR(i.spld_date, 'MM-DD-YYYY');
         rep.assd_no := i.assd_no;
         rep.issue_yy := i.issue_yy;
         rep.pol_seq_no := i.pol_seq_no;
         rep.renew_no := i.renew_no;
         rep.endt_iss_cd := i.endt_iss_cd;
         rep.endt_yy := i.endt_yy;
         rep.endt_seq_no := i.endt_seq_no;
         rep.issue_date := i.issue_date;
         rep.incept_date := i.incept_date;
         rep.expiry_date := i.expiry_date;
         rep.total_tsi := i.total_tsi;
         rep.total_prem := i.total_prem;
         rep.param_date := i.param_date;
         rep.from_date := i.from_date;
         rep.TO_DATE := i.TO_DATE;
         rep.SCOPE := i.SCOPE;
         rep.user_id := i.user_id;
         rep.policy_id := i.policy_id;
         rep.cf_iss_title := gipir923e_pkg.cf_iss_title (p_iss_param);
         rep.cf_iss_name := gipir923e_pkg.cf_iss_name (i.iss_cd);
         rep.cf_line_name := gipir923e_pkg.cf_line_name (i.line_cd);
         rep.cf_subline_name :=
                      gipir923e_pkg.cf_subline_name (i.subline_cd, i.line_cd);
         rep.cf_assd_name := gipir923e_pkg.cf_assd_name (i.assd_no);
         rep.cf_policy_no :=
            gipir923e_pkg.cf_policy_no (i.line_cd,
                                        i.subline_cd,
                                        i.iss_cd,
                                        i.issue_yy,
                                        i.pol_seq_no,
                                        i.renew_no,
                                        i.endt_seq_no,
                                        i.endt_iss_cd,
                                        i.endt_yy,
                                        i.policy_id
                                       );
         rep.cf_based_on := gipir923e_pkg.cf_based_on (i.user_id, p_scope);
         rep.cf_company := gipir923e_pkg.cf_company (i.user_id, p_scope);
         rep.cf_company_address :=
                         gipir923e_pkg.cf_company_address (i.user_id, p_scope);
         rep.cf_heading3 := gipir923e_pkg.cf_heading3 (i.user_id);
         rep.cf_1 :=
            gipir923e_pkg.cf_1 (i.user_id,
                                p_iss_param,
                                i.iss_cd,
                                i.line_cd,
                                i.subline_cd,
                                p_scope
                               );
         rep.cf_spoiled :=
            gipir923e_pkg.cf_spoiled (i.user_id,
                                      p_iss_param,
                                      i.iss_cd,
                                      p_scope
                                     );
         rep.cf_distributed_total := 0;
         rep.cf_undistributed_total := 0;
         rep.cf_count_distributed_total := 0;
         rep.cf_count_undistributed_total := 0;
         rep.cf_sysdate := SYSDATE;
         rep.evatprem := i.evatprem;
         rep.lgt := i.lgt;
         rep.doc_stamps := i.doc_stamps;
         rep.fst := i.fst;
         rep.other_taxes := i.other_taxes;
         rep.other_charges := i.other_charges;

         FOR x IN (SELECT giacp.v ('SHOW_TOTAL_TAXES') param_v
                     FROM DUAL)
         LOOP
            rep.cf_param_v := x.param_v;
         END LOOP;

         
         PIPE ROW (rep);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_iss_title (p_iss_param gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR
   IS
   BEGIN
      IF p_iss_param = 2
      THEN
         RETURN ('Issue Source     :');
      ELSE
         RETURN ('Crediting Branch :');
      END IF;
   END;

   FUNCTION cf_iss_name (p_iss_cd gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (200);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (p_iss_cd || ' - ' || v_iss_name);
   END;

   FUNCTION cf_line_name (p_line_cd giis_line.line_cd%TYPE)
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         RETURN (c.line_name);
      END LOOP;
   END;

   --This is to select line_name from table giis_line.
--03/13/02 Jeanette Tan
   FUNCTION cf_subline_name (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         RETURN (c.subline_name);
      END LOOP;
   END;

   --This is to select subline_name from table giis_subline.
--03/13/02 Jeanette Tan
   FUNCTION cf_assd_name (p_assd_no giis_assured.assd_no%TYPE)
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT assd_name
                  FROM giis_assured
                 WHERE assd_no = p_assd_no)
      LOOP
         RETURN (c.assd_name);
      END LOOP;
   END;

   --This is to select assd_name from table giis_assured.
--03/13/02 Jeanette Tan
   FUNCTION cf_policy_no (
      p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
      p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
      p_issue_yy      gipi_uwreports_ext.issue_yy%TYPE,
      p_pol_seq_no    gipi_uwreports_ext.pol_seq_no%TYPE,
      p_renew_no      gipi_uwreports_ext.renew_no%TYPE,
      p_endt_seq_no   gipi_uwreports_ext.endt_seq_no%TYPE,
      p_endt_iss_cd   gipi_uwreports_ext.endt_iss_cd%TYPE,
      p_endt_yy       gipi_uwreports_ext.endt_yy%TYPE,
      p_policy_id     gipi_uwreports_ext.policy_id%TYPE
   )
      RETURN CHAR
   IS
      v_policy_no    VARCHAR2 (100);
      v_endt_no      VARCHAR2 (30);
      v_ref_pol_no   VARCHAR2 (35)  := NULL;
   BEGIN
      v_policy_no :=
            p_line_cd
         || '-'
         || p_subline_cd
         || '-'
         || LTRIM (p_iss_cd)
         || '-'
         || LTRIM (TO_CHAR (p_issue_yy, '09'))
         || '-'
         || LTRIM (TO_CHAR (p_pol_seq_no))
         || '-'
         || LTRIM (TO_CHAR (p_renew_no, '09'));

      IF p_endt_seq_no <> 0
      THEN
         v_endt_no :=
               p_endt_iss_cd
            || '-'
            || LTRIM (TO_CHAR (p_endt_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (p_endt_seq_no));
      END IF;

      BEGIN
         SELECT ref_pol_no
           INTO v_ref_pol_no
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL
      THEN
         v_ref_pol_no := '/' || v_ref_pol_no;
      END IF;

      RETURN (v_policy_no || ' ' || v_endt_no || v_ref_pol_no);
   END;

   FUNCTION cf_based_on (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR
   IS
      v_param_date     NUMBER (1);
      v_based_on       VARCHAR2 (100);
      v_scope          NUMBER (1);
      v_policy_label   VARCHAR2 (300);
   BEGIN
      SELECT param_date
        INTO v_param_date
        FROM gipi_uwreports_ext
       WHERE user_id = p_user_id AND ROWNUM = 1;

      IF v_param_date = 1
      THEN
         v_based_on := 'Based on Issue Date';
      ELSIF v_param_date = 2
      THEN
         v_based_on := 'Based on Inception Date';
      ELSIF v_param_date = 3
      THEN
         v_based_on := 'Based on Booking month - year';
      ELSIF v_param_date = 4
      THEN
         v_based_on := 'Based on Acctg Entry Date';
      END IF;

      v_scope := p_scope;

      IF v_scope = 1
      THEN
         v_policy_label := v_based_on || '/' || 'Policies Only';
      ELSIF v_scope = 2
      THEN
         v_policy_label := v_based_on || '/' || 'Endorsements Only';
      ELSIF v_scope = 3
      THEN
         v_policy_label := v_based_on || '/' || 'Policies and Endorsements';
      END IF;

      RETURN (v_policy_label);
   END;

   FUNCTION cf_company (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR
   IS
      v_company_name   VARCHAR2 (150);
   BEGIN
      SELECT param_value_v
        INTO v_company_name
        FROM giis_parameters
       WHERE UPPER (param_name) = 'COMPANY_NAME';

      RETURN (v_company_name);
   END;

   FUNCTION cf_company_address (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   FUNCTION cf_heading3 (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR
   IS
      v_param_date   NUMBER (1);
      v_from_date    DATE;
      v_to_date      DATE;
      heading3       VARCHAR2 (150);
   BEGIN
      SELECT DISTINCT param_date, from_date, TO_DATE
                 INTO v_param_date, v_from_date, v_to_date
                 FROM gipi_uwreports_ext
                WHERE user_id = p_user_id;

      IF v_param_date IN (1, 2, 4)
      THEN
         IF v_from_date = v_to_date
         THEN
            heading3 := 'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      ELSE
         IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
         THEN
            heading3 :=
                'For the Month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      END IF;

      RETURN (heading3);
   END;

   FUNCTION cf_1 (
      p_user_id      gipi_uwreports_ext.user_id%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN NUMBER
   IS
      v_total   NUMBER (18, 2);
   BEGIN
      BEGIN
         SELECT SUM (total_prem)
           INTO v_total
           FROM gipi_uwreports_ext a
          WHERE a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND (p_scope = 4 AND pol_flag = '5')
            AND spld_date IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_total := 0;
      END;

      RETURN (v_total);
   END;

   FUNCTION cf_spoiled (
      p_user_id     gipi_uwreports_ext.user_id%TYPE,
      p_iss_param   gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_scope       gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN NUMBER
   IS
      count_spoiled   NUMBER (30);
   BEGIN
      BEGIN
         SELECT COUNT (policy_id)
           INTO count_spoiled
           FROM gipi_uwreports_ext a
          WHERE a.user_id = p_user_id
            AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                       )
            AND (p_scope = 4 AND pol_flag = '5')
            AND spld_date IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            count_spoiled := 0;
      END;

      RETURN (count_spoiled);
   END;
END gipir923e_pkg;
/


