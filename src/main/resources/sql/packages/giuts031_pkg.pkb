CREATE OR REPLACE PACKAGE BODY CPI.giuts031_pkg
AS
   /*
   ** Created By : J. Diago
   ** Date Created : 08.08.2013
   ** Remarks : Referenced by GIUTS031 Extract Expiring Covernote
   */
   FUNCTION get_line_lov (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN giuts031_line_lov_tab PIPELINED
   AS
      v_list   giuts031_line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name, pack_pol_flag
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               'GIUTS031',
                                               p_user_id
                                              ) = 1
                     AND pack_pol_flag != 'Y'
                     AND (   UPPER (line_cd) LIKE
                                      NVL (UPPER (p_keyword), UPPER (line_cd))
                          OR UPPER (line_name) LIKE
                                    NVL (UPPER (p_keyword), UPPER (line_name))
                         )
                ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.pack_pol_flag := i.pack_pol_flag;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_line_lov;

   FUNCTION get_subline_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN giuts031_subline_lov_tab PIPELINED
   AS
      v_list   giuts031_subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = p_line_cd
                   AND (   UPPER (subline_cd) LIKE
                                   NVL (UPPER (p_keyword), UPPER (subline_cd))
                        OR UPPER (subline_name) LIKE
                                 NVL (UPPER (p_keyword), UPPER (subline_name))
                       ))
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_subline_lov;

   FUNCTION when_new_form_instance (p_user_id giis_users.user_id%TYPE)
      RETURN giuts031_newforminstance_tab PIPELINED
   AS
      v_list     giuts031_newforminstance_type;
      ho_cd      VARCHAR2 (2);
      v_iss_cd   giis_issource.iss_cd%TYPE;
   BEGIN
      FOR iss IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_iss_cd := iss.param_value_v;
      END LOOP;

      SELECT param_value_v
        INTO ho_cd
        FROM giis_parameters
       WHERE param_name = 'ISS_CD_HO';

      BEGIN
         SELECT b.grp_iss_cd
           INTO v_list.iss_cd
           FROM giis_user_grp_hdr b, giis_users a
          WHERE b.user_grp = a.user_grp
            AND a.user_id = NVL (p_user_id, USER)
            AND b.grp_iss_cd = ho_cd;

         PIPE ROW (v_list);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               FOR a IN (SELECT b.grp_iss_cd grp_iss_cd
                           FROM giis_user_grp_hdr b, giis_users a
                          WHERE b.user_grp = a.user_grp
                            AND a.user_id = NVL (p_user_id, USER))
               LOOP
                  v_list.iss_cd := a.grp_iss_cd;
                  PIPE ROW (v_list);
               END LOOP;

               RETURN;
            END;
      END;

      RETURN;
   END when_new_form_instance;

   FUNCTION get_issue_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN giuts031_issue_lov_tab PIPELINED
   AS
      v_list   giuts031_issue_lov_type;
   BEGIN
      IF p_line_cd IS NOT NULL
      THEN
         FOR i IN (SELECT   iss_cd iss_cd, iss_name iss_name
                       FROM giis_issource
                      WHERE check_user_per_iss_cd_acctg2 (p_line_cd,
                                                          iss_cd,
                                                          'GIUTS031',
                                                          p_user_id
                                                         ) = 1
                        AND check_user_per_line2 (p_line_cd,
                                                  iss_cd,
                                                  'GIUTS031',
                                                  p_user_id
                                                 ) = 1
                        AND (   UPPER (iss_cd) LIKE
                                       NVL (UPPER (p_keyword), UPPER (iss_cd))
                             OR UPPER (iss_name) LIKE
                                     NVL (UPPER (p_keyword), UPPER (iss_name))
                            )
                        AND iss_cd != 'RI'
                        AND NVL (claim_tag, 'N') != 'Y'
                   ORDER BY iss_cd)
         LOOP
            v_list.iss_cd := i.iss_cd;
            v_list.iss_name := i.iss_name;
            PIPE ROW (v_list);
         END LOOP;
      ELSE
         FOR i IN (SELECT   iss_cd iss_cd, iss_name iss_name
                       FROM giis_issource
                      WHERE check_user_per_iss_cd_acctg2 (p_line_cd,
                                                          iss_cd,
                                                          'GIUTS031',
                                                          p_user_id
                                                         ) = 1
                        AND (   UPPER (iss_cd) LIKE
                                       NVL (UPPER (p_keyword), UPPER (iss_cd))
                             OR UPPER (iss_name) LIKE
                                     NVL (UPPER (p_keyword), UPPER (iss_name))
                            )
                        AND iss_cd != 'RI'
                        AND NVL (claim_tag, 'N') != 'Y'
                   ORDER BY iss_cd)
         LOOP
            v_list.iss_cd := i.iss_cd;
            v_list.iss_name := i.iss_name;
            PIPE ROW (v_list);
         END LOOP;
      END IF;

      RETURN;
   END get_issue_lov;

   PROCEDURE extract_giuts031 (
      p_user_id             IN       giis_users.user_id%TYPE,
      p_param_type          IN       VARCHAR2,
      p_from_date           IN       DATE,
      p_to_date             IN       DATE,
      p_from_month          IN       VARCHAR2,
      p_from_year           IN       VARCHAR2,
      p_to_month            IN       VARCHAR2,
      p_to_year             IN       VARCHAR2,
      p_line_cd             IN       giis_line.line_cd%TYPE,
      p_subline_cd          IN       giis_subline.subline_cd%TYPE,
      p_iss_cd              IN       giis_issource.iss_cd%TYPE,
      p_cred_branch_param   IN       VARCHAR2,
      p_exists              OUT      NUMBER,
      p_from                OUT      VARCHAR2,
      p_to                  OUT      VARCHAR2
   )
   IS
      v_from   DATE;
      v_to     DATE;
   BEGIN
      DELETE FROM gixx_covernote_exp
            WHERE user_id = p_user_id;

      IF p_param_type = 'D'
      THEN
         v_from := p_from_date;
         v_to := p_to_date;
      ELSE
         v_from :=
            TO_DATE ((p_from_month || '/01' || '/' || p_from_year),
                     'MM-DD-YYYY'
                    );
         v_to :=
            LAST_DAY (TO_DATE ((p_to_month || '/01' || '/' || p_to_year),
                               'MM-DD-YYYY'
                              )
                     );
      END IF;

      INSERT INTO gixx_covernote_exp
                  (par_id, line_cd, iss_cd, cred_branch, par_yy, par_seq_no,
                   quote_seq_no, assign_sw, assd_no, incept_date, expiry_date,
                   covernote_expiry, tsi_amt, prem_amt, cred_branch_param,
                   user_id, last_update, p_param_type, p_from_date, p_to_date,
                   p_from_month, p_from_year, p_to_month, p_to_year,
                   p_line_cd, p_subline_cd, p_iss_cd)
         SELECT a.par_id, a.line_cd, a.iss_cd iss_cd, a.cred_branch, b.par_yy,
                b.par_seq_no, b.quote_seq_no, b.assign_sw, a.assd_no,
                a.incept_date, a.expiry_date, a.covernote_expiry, a.tsi_amt,
                a.prem_amt, p_cred_branch_param, p_user_id, SYSDATE,
                p_param_type, p_from_date, p_to_date, p_from_month,
                p_from_year, p_to_month, p_to_year, p_line_cd, p_subline_cd,
                p_iss_cd
           FROM gipi_wpolbas a, gipi_parlist b
          WHERE 1 = 1
            AND TRUNC (a.covernote_expiry) BETWEEN v_from AND v_to
            AND a.line_cd = NVL (p_line_cd, a.line_cd)
            AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
            AND NVL (DECODE (p_cred_branch_param,
                             '1', a.iss_cd,
                             '2', a.cred_branch
                            ),
                     '!@'
                    ) =
                   NVL (NVL (p_iss_cd,
                             DECODE (p_cred_branch_param,
                                     '1', a.iss_cd,
                                     '2', a.cred_branch
                                    )
                            ),
                        '!@'
                       )
            AND a.par_id = b.par_id
            AND b.par_status NOT IN (98, 99);

      BEGIN
         SELECT COUNT (*), TO_CHAR (v_from, 'MM-DD-RRRR'),
                TO_CHAR (v_to, 'MM-DD-RRRR')
           INTO p_exists, p_from,
                p_to
           FROM gixx_covernote_exp
          WHERE user_id = p_user_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_exists := 0;
         WHEN TOO_MANY_ROWS
         THEN
            p_exists := 1;
      END;
   END extract_giuts031;

   FUNCTION validate_extract_params (p_user_id VARCHAR2)
      RETURN validate_extract_params_tab PIPELINED
   IS
      v_row   validate_extract_params_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gixx_covernote_exp
                 WHERE user_id = p_user_id
                   AND check_user_per_iss_cd2 (p_line_cd,
                                               p_iss_cd,
                                               'GIUTS031',
                                               p_user_id
                                              ) = 1)
      LOOP
         v_row.p_user_id := i.user_id;
         v_row.p_param_type := i.p_param_type;
         v_row.p_from_date := TO_CHAR (i.p_from_date, 'MM-DD-RRRR');
         v_row.p_to_date := TO_CHAR (i.p_to_date, 'MM-DD-RRRR');
         v_row.p_from_month := i.p_from_month;
         v_row.p_from_year := i.p_from_year;
         v_row.p_to_month := i.p_to_month;
         v_row.p_to_year := i.p_to_year;
         v_row.p_line_cd := i.p_line_cd;
         v_row.p_subline_cd := i.p_subline_cd;
         v_row.p_iss_cd := i.p_iss_cd;
         v_row.p_cred_branch_param := i.cred_branch_param;

         BEGIN
            SELECT DISTINCT line_name
                       INTO v_row.p_line_name
                       FROM giis_line
                      WHERE line_cd = i.p_line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_row.p_line_name := '';
         END;

         BEGIN
            SELECT DISTINCT subline_name
                       INTO v_row.p_subline_name
                       FROM giis_subline
                      WHERE subline_cd = i.p_subline_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_row.p_subline_name := '';
         END;

         BEGIN
            SELECT DISTINCT iss_name
                       INTO v_row.p_iss_name
                       FROM giis_issource
                      WHERE iss_cd = i.p_iss_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_row.p_iss_name := '';
         END;

         IF i.p_param_type = 'D'
         THEN
            v_row.p_from := TO_CHAR (i.p_from_date, 'MM-DD-RRRR');
            v_row.p_to := TO_CHAR (i.p_to_date, 'MM-DD-RRRR');
         ELSE
            v_row.p_from :=
               TO_CHAR(TO_DATE ((i.p_from_month || '/01' || '/' || i.p_from_year), --marco - 07.29.2014 - added to_char
                        'MM-DD-YYYY'
                       ), 'MM-DD-YYYY');
            v_row.p_to :=
               TO_CHAR(LAST_DAY (TO_DATE ((i.p_to_month || '/01' || '/' || i.p_to_year --marco - 07.29.2014 - added to_char
                                  ),
                                  'MM-DD-YYYY'
                                 )
                        ), 'MM-DD-YYYY');
         END IF;

         PIPE ROW (v_row);
         EXIT;
      END LOOP;

      RETURN;
   END;
END;
/


