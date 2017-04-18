CREATE OR REPLACE PACKAGE BODY CPI.gipir210_pkg
AS
   FUNCTION get_gipir210_dtls_old  (  -- jhing 03.30.2016 GENQA 5047
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_a_from       DATE,
      p_a_to         DATE,
      p_e_from       DATE,
      p_e_to         DATE,
      p_i_from       DATE,
      p_i_to         DATE,
      p_f            DATE,
      p_t            DATE,
      p_user_id      VARCHAR2
   )
      RETURN gipir210_q1_tab PIPELINED
   IS
      v_rec      gipir210_q1_type;
      var_assd   giis_assured.assd_name%TYPE;
   BEGIN
      BEGIN
         FOR c IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'COMPANY_NAME')
         LOOP
            v_rec.cf_company_name := c.param_value_v;
            EXIT;
         END LOOP;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_address := '';
      END;

      BEGIN
         IF p_a_from IS NOT NULL AND p_a_to IS NOT NULL
         THEN
            v_rec.cf_date_title := 'Accounting Entry Date';
            v_rec.cf_from_to_title :=
                  'From '
               || TO_CHAR (p_a_from, 'MM-DD-RRRR')
               || ' To '
               || TO_CHAR (p_a_to, 'MM-DD-RRRR');
         ELSIF p_e_from IS NOT NULL AND p_e_to IS NOT NULL
         THEN
            v_rec.cf_date_title := 'Effectivity Date';
            v_rec.cf_from_to_title :=
                  'From '
               || TO_CHAR (p_e_from, 'MM-DD-RRRR')
               || ' To '
               || TO_CHAR (p_e_to, 'MM-DD-RRRR');
         ELSIF p_i_from IS NOT NULL AND p_i_to IS NOT NULL
         THEN
            v_rec.cf_date_title := 'Issue Date';
            v_rec.cf_from_to_title :=
                  'From '
               || TO_CHAR (p_i_from, 'MM-DD-RRRR')
               || ' To '
               || TO_CHAR (p_i_to, 'MM-DD-RRRR');
         ELSIF p_f IS NOT NULL AND p_t IS NOT NULL
         THEN
            v_rec.cf_date_title := 'Booking Date';
            v_rec.cf_from_to_title :=
                  'From '
               || TO_CHAR (p_f, 'MM-DD-RRRR')
               || ' To '
               || TO_CHAR (p_t, 'MM-DD-RRRR');
         END IF;
      END;

      FOR i IN
         (SELECT DISTINCT    a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number,
                          a.policy_id, a.assd_no, b.assd_name, a.acct_of_cd,
                          a.acct_of_cd_sw, a.eff_date, a.acct_ent_date,
                          a.issue_date,
                             a.booking_mth
                          || ' '
                          || (a.booking_year) AS "BOOKING_DATE"
                     FROM gipi_polbasic a,
                          giis_assured b,
                          gipi_grouped_items c,
                          giis_package_benefit d
                    WHERE a.assd_no = b.assd_no
                      AND a.policy_id = c.policy_id
                      AND c.pack_ben_cd = d.pack_ben_cd
                      AND d.package_cd IS NOT NULL
                      AND check_user_per_iss_cd2 (a.line_cd,
                                                  a.iss_cd,
                                                  'GIPIS212',
                                                  p_user_id
                                                 ) = 1
                      AND (   (    a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.iss_cd = p_iss_cd
                               AND a.issue_yy = p_issue_yy
                               AND a.pol_seq_no = p_pol_seq_no
                               AND a.renew_no = p_renew_no
                              )
                           OR (    (a.eff_date >= p_e_from)
                               AND (a.eff_date <= p_e_to)
                              )
                           OR (    (a.acct_ent_date >= p_a_from)
                               AND (a.acct_ent_date <= p_a_to)
                              )
                           OR (    (a.issue_date >= p_i_from)
                               AND (a.issue_date <= p_i_to)
                              )
                           OR ((TO_DATE (a.booking_mth || '-'
                                         || a.booking_year,
                                         'MM-RRRR'
                                        ) BETWEEN TO_DATE (   TO_CHAR (p_f,
                                                                       'MM'
                                                                      )
                                                           || DECODE (p_f,
                                                                      NULL, NULL,
                                                                      '-'
                                                                     )
                                                           || TO_CHAR (p_f,
                                                                       'YYYY'
                                                                      ),
                                                           'MM-RRRR'
                                                          )
                                              AND TO_DATE (   TO_CHAR (p_t,
                                                                       'MM'
                                                                      )
                                                           || DECODE (p_t,
                                                                      NULL, NULL,
                                                                      '-'
                                                                     )
                                                           || TO_CHAR (p_t,
                                                                       'YYYY'
                                                                      ),
                                                           'MM-RRRR'
                                                          )
                               )
                              )
                          ))
      LOOP
         v_rec.policy_number := i.policy_number;
         v_rec.policy_id := i.policy_id;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         v_rec.acct_of_cd := i.acct_of_cd;
         v_rec.acct_of_cd_sw := i.acct_of_cd_sw;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-RRRR');
         v_rec.acct_ent_date := TO_CHAR (i.acct_ent_date, 'MM-DD-RRRR');
         v_rec.issue_date := TO_CHAR (i.issue_date, 'MM-DD-RRRR');
         v_rec.booking_date := i.booking_date;
         v_rec.cf_policy_number := 'Policy Number   : ' || i.policy_number;

         BEGIN
            IF i.acct_of_cd IS NULL
            THEN
               v_rec.cf_assured_name := 'Assured Name   : ' || i.assd_name;
            ELSE
               IF i.acct_of_cd_sw = 'Y'
               THEN
                  SELECT DISTINCT assd_name
                             INTO var_assd
                             FROM giis_assured a, gipi_polbasic b
                            WHERE a.assd_no = i.acct_of_cd;

                  v_rec.cf_assured_name :=
                        'Assured Name : '
                     || i.assd_name
                     || ' LEASED TO '
                     || var_assd;
               ELSE
                  SELECT DISTINCT assd_name
                             INTO var_assd
                             FROM giis_assured a, gipi_polbasic b
                            WHERE a.assd_no = i.acct_of_cd;

                  v_rec.cf_assured_name :=
                        'Assured Name : '
                     || i.assd_name
                     || ' IN ACCOUNT OF '
                     || var_assd;
               END IF;
            END IF;
         END;

         FOR j IN (SELECT d.package_cd, c.control_cd,
                             a.endt_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.endt_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                                                      endt_no,
                          a.endt_yy, a.endt_seq_no, c.policy_id,
                          c.grouped_item_title, c.grouped_item_no, a.eff_date,
                          a.expiry_date, c.tsi_amt, c.prem_amt, c.delete_sw
                     FROM gipi_polbasic a,
                          giis_assured b,
                          gipi_grouped_items c,
                          giis_package_benefit d
                    WHERE a.assd_no = b.assd_no
                      AND a.policy_id = c.policy_id
                      AND c.pack_ben_cd = d.pack_ben_cd
                      AND a.policy_id = i.policy_id)
         LOOP
            v_rec.package_cd := j.package_cd;
            v_rec.control_cd := j.control_cd;
            v_rec.endt_no := j.endt_no;
            v_rec.endt_yy := j.endt_yy;
            v_rec.endt_seq_no := j.endt_seq_no;
            v_rec.policy_id := j.policy_id;
            v_rec.grouped_item_title := j.grouped_item_title;
            v_rec.grouped_item_no := j.grouped_item_no;
            v_rec.eff_date := TO_CHAR (j.eff_date, 'MM-DD-RRRR');
            v_rec.expiry_date := TO_CHAR (j.expiry_date, 'MM-DD-RRRR');
            v_rec.tsi_amt := j.tsi_amt;
            v_rec.prem_amt := j.prem_amt;
            v_rec.delete_sw := j.delete_sw;
            v_rec.cf_plan := 'Plan : ' || j.package_cd;
            v_rec.cf_total := 'Total : ' || j.package_cd;

            BEGIN
               IF j.endt_yy <> '0' AND j.endt_seq_no <> '0'
               THEN
                  v_rec.cf_endt := j.endt_no;
               ELSE
                  v_rec.cf_endt := '';
               END IF;
            END;

            IF j.delete_sw = 'Y'
            THEN
               v_rec.cf_status := 'Deleted';
            ELSE
               v_rec.cf_status := 'Active';
            END IF;

            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      PIPE ROW (v_rec);
      RETURN;
   END get_gipir210_dtls_old ;
   
   FUNCTION get_gipir210_dtls (p_line_cd       VARCHAR2,
                                p_subline_cd    VARCHAR2,
                                p_iss_cd        VARCHAR2,
                                p_issue_yy      VARCHAR2,
                                p_pol_seq_no    VARCHAR2,
                                p_renew_no      VARCHAR2,
                                p_a_from        DATE,
                                p_a_to          DATE,
                                p_e_from        DATE,
                                p_e_to          DATE,
                                p_i_from        DATE,
                                p_i_to          DATE,
                                p_f             DATE,
                                p_t             DATE,
                                p_user_id       VARCHAR2)
       RETURN gipir210_q1_tab
       PIPELINED
    IS
       v_rec      gipir210_q1_type;
       var_assd   giis_assured.assd_name%TYPE;
       TYPE v_sec_tab IS TABLE OF NUMBER index by VARCHAR2(50 );
       v_sec_tbl v_sec_tab ; 
       v_total_rec  NUMBER := 0 ; 
    BEGIN
       BEGIN
          FOR c IN (SELECT param_value_v
                      FROM giis_parameters
                     WHERE param_name = 'COMPANY_NAME')
          LOOP
             v_rec.cf_company_name := c.param_value_v;
             EXIT;
          END LOOP;
       END;

       BEGIN
          SELECT param_value_v
            INTO v_rec.cf_address
            FROM giis_parameters
           WHERE param_name = 'COMPANY_ADDRESS';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_rec.cf_address := '';
       END;

       BEGIN
          IF p_a_from IS NOT NULL AND p_a_to IS NOT NULL
          THEN
             v_rec.cf_date_title := 'Accounting Entry Date';
             v_rec.cf_from_to_title :=
                   'From '
                || TO_CHAR (p_a_from, 'MM-DD-RRRR')
                || ' To '
                || TO_CHAR (p_a_to, 'MM-DD-RRRR');
          ELSIF p_e_from IS NOT NULL AND p_e_to IS NOT NULL
          THEN
             v_rec.cf_date_title := 'Effectivity Date';
             v_rec.cf_from_to_title :=
                   'From '
                || TO_CHAR (p_e_from, 'MM-DD-RRRR')
                || ' To '
                || TO_CHAR (p_e_to, 'MM-DD-RRRR');
          ELSIF p_i_from IS NOT NULL AND p_i_to IS NOT NULL
          THEN
             v_rec.cf_date_title := 'Issue Date';
             v_rec.cf_from_to_title :=
                   'From '
                || TO_CHAR (p_i_from, 'MM-DD-RRRR')
                || ' To '
                || TO_CHAR (p_i_to, 'MM-DD-RRRR');
          ELSIF p_f IS NOT NULL AND p_t IS NOT NULL
          THEN
             v_rec.cf_date_title := 'Booking Date';
             v_rec.cf_from_to_title :=
                   'From '
                || TO_CHAR (p_f, 'MM-DD-RRRR')
                || ' To '
                || TO_CHAR (p_t, 'MM-DD-RRRR');
          END IF;
       END;

       FOR i
          IN (  SELECT    a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09'))
                          policy_number,
                       a.policy_id,
                       a.assd_no,
                       b.assd_name,
                       a.acct_of_cd,
                       a.acct_of_cd_sw,
                       a.eff_date,
                       a.acct_ent_date,
                       a.issue_date,
                       a.booking_mth || ' ' || (a.booking_year) AS "BOOKING_DATE",
                       a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,                
                       a.pol_seq_no,
                       a.renew_no
                  FROM gipi_polbasic a, giis_assured b , giis_line c 
                 WHERE     a.assd_no = b.assd_no
                       AND a.line_cd = c.line_cd
                       AND NVL(c.menu_line_cd, c.line_cd ) = 'AC' 
                       AND EXISTS
                              (SELECT 1
                                 FROM gipi_grouped_items c
                                WHERE c.policy_id = a.policy_id)
                       AND (   (    a.line_cd = p_line_cd
                                AND a.subline_cd = p_subline_cd
                                AND a.iss_cd = p_iss_cd
                                AND a.issue_yy = p_issue_yy
                                AND a.pol_seq_no = p_pol_seq_no
                                AND a.renew_no = p_renew_no)
                            OR (    (TRUNC (a.eff_date) >= p_e_from)
                                AND (TRUNC (a.eff_date) <= p_e_to))
                            OR (    (TRUNC (a.acct_ent_date) >= p_a_from)
                                AND (TRUNC (a.acct_ent_date) <= p_a_to))
                            OR (    (TRUNC (a.issue_date) >= p_i_from)
                                AND (TRUNC (a.issue_date) <= p_i_to))
                            OR ( (TO_DATE (a.booking_mth || '-' || a.booking_year,
                                           'MM-RRRR') BETWEEN TO_DATE (
                                                                    TO_CHAR (p_f,
                                                                             'MM')
                                                                 || DECODE (
                                                                       p_f,
                                                                       NULL, NULL,
                                                                       '-')
                                                                 || TO_CHAR (
                                                                       p_f,
                                                                       'YYYY'),
                                                                 'MM-RRRR')
                                                          AND TO_DATE (
                                                                    TO_CHAR (p_t,
                                                                             'MM')
                                                                 || DECODE (
                                                                       p_t,
                                                                       NULL, NULL,
                                                                       '-')
                                                                 || TO_CHAR (
                                                                       p_t,
                                                                       'YYYY'),
                                                                 'MM-RRRR'))))
              ORDER BY a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,
                       a.pol_seq_no,
                       a.renew_no,
                       a.endt_seq_no)
       LOOP
          IF NOT v_sec_tbl.exists (i.line_cd || '-' || i.iss_cd ) THEN
            v_sec_tbl(i.line_cd || '-' || i.iss_cd ) := check_user_per_iss_cd2 ( i.line_cd, i.iss_cd, 'GIPIS212', p_user_id ); 
          END IF;
          
          IF v_sec_tbl(i.line_cd || '-' || i.iss_cd ) = 1 THEN        
              v_rec.policy_number := i.policy_number;
              v_rec.policy_id := i.policy_id;
              v_rec.assd_no := i.assd_no;
              v_rec.assd_name := i.assd_name;
              v_rec.acct_of_cd := i.acct_of_cd;
              v_rec.acct_of_cd_sw := i.acct_of_cd_sw;
              v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-RRRR');
              v_rec.acct_ent_date := TO_CHAR (i.acct_ent_date, 'MM-DD-RRRR');
              v_rec.issue_date := TO_CHAR (i.issue_date, 'MM-DD-RRRR');
              v_rec.booking_date := i.booking_date;
              v_rec.cf_policy_number := 'Policy Number   : ' || i.policy_number;
              v_rec.line_cd := i.line_cd;
              v_rec.subline_cd := i.subline_cd;
              v_rec.iss_cd := i.iss_cd;
              v_rec.issue_yy := i.issue_yy;
              v_rec.pol_seq_no := i.pol_seq_no;
              v_rec.renew_no := i.renew_no;


              BEGIN
                 IF i.acct_of_cd IS NULL
                 THEN
                    v_rec.cf_assured_name := 'Assured Name   : ' || i.assd_name;
                 ELSE
                    IF i.acct_of_cd_sw = 'Y'
                    THEN
                       SELECT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;

                       v_rec.cf_assured_name :=
                             'Assured Name : '
                          || i.assd_name
                          || ' LEASED TO '
                          || var_assd;
                    ELSE
                       SELECT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;

                       v_rec.cf_assured_name :=
                             'Assured Name : '
                          || i.assd_name
                          || ' IN ACCOUNT OF '
                          || var_assd;
                    END IF;
                 END IF;
              END;

              FOR j
                 IN (SELECT d.package_cd,
                            c.control_cd,
                               a.endt_iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (a.endt_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                               endt_no,
                            a.endt_yy,
                            a.endt_seq_no,
                            c.policy_id,
                            c.grouped_item_title,
                            c.grouped_item_no,
                            a.eff_date,
                            a.expiry_date,
                            NVL (c.tsi_amt, 0) tsi_amt,
                            NVL (c.prem_amt, 0) prem_amt,
                            c.delete_sw
                       FROM gipi_polbasic a,
                            giis_assured b,
                            gipi_grouped_items c,
                            giis_package_benefit d
                      WHERE     a.assd_no = b.assd_no
                            AND a.policy_id = c.policy_id
                            AND c.pack_ben_cd = d.pack_ben_cd(+)
                            AND a.policy_id = i.policy_id)
              LOOP
                 v_rec.package_cd := j.package_cd;
                 v_rec.control_cd := j.control_cd;
                 v_rec.endt_no := j.endt_no;
                 v_rec.endt_yy := j.endt_yy;
                 v_rec.endt_seq_no := j.endt_seq_no;
                 v_rec.policy_id := j.policy_id;
                 v_rec.grouped_item_title := j.grouped_item_title;
                 v_rec.grouped_item_no := j.grouped_item_no;
                 v_rec.eff_date := TO_CHAR (j.eff_date, 'MM-DD-RRRR');
                 v_rec.expiry_date := TO_CHAR (j.expiry_date, 'MM-DD-RRRR');
                 v_rec.tsi_amt := j.tsi_amt;
                 v_rec.prem_amt := j.prem_amt;
                 v_rec.delete_sw := j.delete_sw;


                 IF j.package_cd IS NOT NULL
                 THEN
                    v_rec.cf_plan := 'Plan : ' || j.package_cd;
                 ELSE
                    v_rec.cf_plan := 'Plan :  ';
                 END IF;

                 IF j.package_cd IS NOT NULL
                 THEN
                    v_rec.cf_total := 'Total : ' || j.package_cd;
                 ELSE
                    v_rec.cf_total := 'Total : ';
                 END IF;

                 BEGIN
                    IF j.endt_yy <> '0' AND j.endt_seq_no <> '0'
                    THEN
                       v_rec.cf_endt := j.endt_no;
                    ELSE
                       v_rec.cf_endt := '';
                    END IF;
                 END;

                 IF j.delete_sw = 'Y'
                 THEN
                    v_rec.cf_status := 'Deleted';
                 ELSE
                    v_rec.cf_status := 'Active';
                 END IF;
                 v_total_rec  := NVL(v_total_rec,0) + 1 ; 
                 PIPE ROW (v_rec);
              END LOOP;
         END IF;     
       END LOOP;

       IF NVL(v_total_rec,0) = 0 THEN 
            PIPE ROW (v_rec);
       END IF; 
       RETURN;
   END get_gipir210_dtls;   
END;
/


