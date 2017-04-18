CREATE OR REPLACE PACKAGE BODY CPI.gipir211_pkg
AS
   FUNCTION get_gipir211_dtls_old (  -- jhing GENQA 5036
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
      RETURN gipir211_pkg_tab PIPELINED
   IS
      v_rec      gipir211_pkg_type;
      var_assd   giis_assured.assd_name%TYPE;
   BEGIN
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
                          a.issue_date, f.package_cd package_cd
                     FROM gipi_polbasic a,
                          giis_assured b,
                          gipi_grouped_items c,
                          gipi_itmperil_grouped d,
                          giis_peril e,
                          giis_package_benefit f,
                          giis_package_benefit_dtl g
                    WHERE a.assd_no = b.assd_no
                      AND a.policy_id = c.policy_id
                      AND c.policy_id = d.policy_id
                      AND e.peril_cd = g.peril_cd
                      AND e.line_cd = f.line_cd
                      AND c.pack_ben_cd = f.pack_ben_cd
                      AND f.pack_ben_cd = g.pack_ben_cd
                      AND c.grouped_item_title IS NOT NULL
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
                          )
                      AND a.iss_cd =
                             DECODE (check_user_per_iss_cd2 (a.line_cd,
                                                             a.iss_cd,
                                                             'GIPIS212',
                                                             p_user_id
                                                            ),
                                     1, a.iss_cd,
                                     NULL
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
         v_rec.package_cd := i.package_cd;
         v_rec.cf_policy_number := 'Policy Number   : ' || i.policy_number;
         v_rec.cf_plan := 'Plan : ' || i.package_cd;
         v_rec.cf_total := 'Total : ' || i.package_cd;

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

         FOR j IN (SELECT DISTINCT a.policy_id, c.control_cd,
                                   c.grouped_item_title, a.endt_iss_cd,
                                   a.endt_yy, a.endt_seq_no,
                                      a.endt_iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                                                      endt_no,
                                   d.item_no, a.eff_date, a.expiry_date,
                                   e.peril_sname, d.tsi_amt, d.prem_amt,
                                   c.delete_sw
                              FROM gipi_polbasic a,
                                   giis_assured b,
                                   gipi_grouped_items c,
                                   gipi_itmperil_grouped d,
                                   giis_peril e
                             WHERE a.assd_no = b.assd_no
                               AND a.policy_id = c.policy_id
                               AND c.policy_id = d.policy_id
                               AND c.grouped_item_no = d.grouped_item_no
                               AND d.peril_cd = e.peril_cd
                               AND e.line_cd = a.line_cd
                               AND a.policy_id = i.policy_id
                          ORDER BY c.control_cd, c.grouped_item_title)
         LOOP
            v_rec.control_cd := j.control_cd;
            v_rec.grouped_item_title := j.grouped_item_title;
            v_rec.endt_iss_cd := j.endt_iss_cd;
            v_rec.endt_yy := j.endt_yy;
            v_rec.endt_seq_no := j.endt_seq_no;
            v_rec.endt_no := j.endt_no;
            v_rec.item_no := j.item_no;
            v_rec.expiry_date := TO_CHAR (j.expiry_date, 'MM-DD-RRRR');
            v_rec.peril_sname := j.peril_sname;
            v_rec.tsi_amt := j.tsi_amt;
            v_rec.prem_amt := j.prem_amt;
            v_rec.delete_sw := j.delete_sw;

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
   END get_gipir211_dtls_old ;
   
   FUNCTION get_gipir211_dtls (p_line_cd       VARCHAR2,
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
       RETURN gipir211_pkg_tab
       PIPELINED
    IS
       v_rec      gipir211_pkg_type;
       var_assd   giis_assured.assd_name%TYPE;
       TYPE v_sec_tab IS TABLE OF NUMBER index by VARCHAR2(50 );
       v_sec_tbl v_sec_tab ; 
       v_total_rec  NUMBER := 0 ; 
    BEGIN
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

       FOR i
          IN (SELECT a.line_cd
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
                     c.pack_ben_cd,
                     d.peril_cd,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     c.delete_sw ,
                     c.control_cd,
                     c.grouped_item_title,
                     c.item_no,
                     c.grouped_item_no,
                     e.peril_type,
                     e.peril_sname,
                     d.tsi_amt,
                     d.prem_amt,
                     a.expiry_date,
                     a.endt_type 
                FROM gipi_polbasic a,
                     giis_assured b,
                     gipi_grouped_items c,
                     gipi_itmperil_grouped d,
                     giis_peril e ,
                     giis_line f
               WHERE     a.assd_no = b.assd_no
                     AND a.policy_id = c.policy_id
                     AND c.policy_id = d.policy_id
                     AND c.item_no = d.item_no
                     AND c.grouped_item_no = d.grouped_item_no
                     AND d.line_cd = e.line_cd
                     AND d.peril_cd = e.peril_cd
                     AND a.line_cd = f.line_cd
                     AND NVL(f.menu_line_cd, f.line_cd ) = 'AC'
                     AND c.grouped_item_title IS NOT NULL
                     AND (   (    a.line_cd = p_line_cd
                              AND a.subline_cd = p_subline_cd
                              AND a.iss_cd = p_iss_cd
                              AND a.issue_yy = p_issue_yy
                              AND a.pol_seq_no = p_pol_seq_no
                              AND a.renew_no = p_renew_no)
                          OR (    (TRUNC(a.eff_date) >= p_e_from)
                              AND (TRUNC(a.eff_date) <= p_e_to))
                          OR (    (TRUNC(a.acct_ent_date) >= p_a_from)
                              AND (TRUNC(a.acct_ent_date) <= p_a_to))
                          OR (    (TRUNC(a.issue_date) >= p_i_from)
                              AND (TRUNC(a.issue_date) <= p_i_to))
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
                      ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                                a.pol_seq_no, a.renew_no, c.item_no, c.grouped_item_no, a.endt_seq_no,
                                e.peril_sname, e.peril_cd   )
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
              v_rec.cf_policy_number := 'Policy Number   : ' || i.policy_number;


              IF i.pack_ben_cd IS NOT NULL
              THEN
                 FOR t
                    IN (SELECT x.package_cd
                          FROM giis_package_benefit x, giis_package_benefit_dtl y
                         WHERE     x.line_cd = i.line_cd
                               AND x.subline_cd = i.subline_cd
                               AND x.pack_ben_cd = y.pack_ben_cd
                               AND x.pack_ben_cd = i.pack_ben_cd
                               AND y.peril_cd = i.peril_cd)
                 LOOP
                    v_rec.package_cd := t.package_cd;
                    v_rec.cf_plan := 'Plan : ' || t.package_cd;
                    v_rec.cf_total := 'Total : ' || t.package_cd;
                    EXIT;
                 END LOOP;
              ELSE
                 v_rec.package_cd := NULL;
                 v_rec.cf_plan := ' ';
                 v_rec.cf_total := 'Total : ';
              END IF;

              BEGIN
                 IF i.acct_of_cd IS NULL
                 THEN
                    v_rec.cf_assured_name := 'Assured Name   : ' || i.assd_name;
                 ELSE
                    IF i.acct_of_cd_sw = 'Y'
                    THEN
                       SELECT DISTINCT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;

                       v_rec.cf_assured_name :=
                             'Assured Name : '
                          || i.assd_name
                          || ' LEASED TO '
                          || var_assd;
                    ELSE
                       SELECT DISTINCT assd_name
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
              
              v_rec.control_cd := i.control_cd;
              v_rec.grouped_item_title := i.grouped_item_title;
              v_rec.grouped_item_no := i.grouped_item_no; -- added by marks sr5306 12.5.2016
              v_rec.endt_iss_cd := i.endt_iss_cd;
              v_rec.endt_yy := i.endt_yy;
              v_rec.endt_seq_no := i.endt_seq_no;
             
              
              v_rec.item_no := i.item_no;
              v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
              v_rec.peril_sname := i.peril_sname;
              v_rec.tsi_amt := i.tsi_amt;
              v_rec.prem_amt := i.prem_amt;
              v_rec.delete_sw := i.delete_sw;      
                      
              BEGIN
                IF i.endt_yy <> '0' AND i.endt_seq_no <> '0'
                THEN
                   v_rec.cf_endt := i.endt_iss_cd  || '-'
                                           || LTRIM (TO_CHAR (i.endt_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (i.endt_seq_no, '0999999')) ; 
                ELSE
                   v_rec.cf_endt := '';
                END IF;
              END;            


              IF i.delete_sw = 'Y'
              THEN
                v_rec.cf_status := 'Deleted';
              ELSE
                v_rec.cf_status := 'Active';
              END IF;     
              
              v_rec.peril_type := i.peril_type ; 
              IF NVL(i.endt_type, 'A' ) = 'A' THEN 
                  IF i.peril_type = 'B'  THEN
                     v_rec.peril_comp_tsi := i.tsi_amt;
                  ELSE
                     v_rec.peril_comp_tsi := 0 ;              
                  END IF;
              ELSE
                v_rec.peril_comp_tsi := NULL ; 
              END IF;
                      
              v_total_rec  := NVL(v_total_rec,0) + 1 ; 
              PIPE ROW (v_rec);             

          END IF;     
       END LOOP;
       
       IF NVL(v_total_rec,0) = 0 THEN 
            PIPE ROW (v_rec);
       END IF; 

       RETURN;
   END get_gipir211_dtls;    
   

   FUNCTION get_gipir211_endt_dtls (
      p_policy_id            VARCHAR2,
      p_control_cd           VARCHAR2,
      p_grouped_item_title   VARCHAR2
   )
      RETURN gipir211_pkg_tab PIPELINED
   IS
      v_rec   gipir211_pkg_type;
   BEGIN
      FOR j IN (SELECT DISTINCT a.policy_id, c.control_cd,
                                c.grouped_item_title, a.endt_iss_cd,
                                a.endt_yy, a.endt_seq_no,
                                   a.endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                                                     endt_no,
                                d.item_no, a.eff_date, a.expiry_date,
                                a.eff_date AS "eff_date2", e.peril_sname,
                                d.tsi_amt, d.prem_amt, c.delete_sw
                           FROM gipi_polbasic a,
                                giis_assured b,
                                gipi_grouped_items c,
                                gipi_itmperil_grouped d,
                                giis_peril e
                          WHERE a.assd_no = b.assd_no
                            AND a.policy_id = c.policy_id
                            AND c.policy_id = d.policy_id
                            AND c.grouped_item_no = d.grouped_item_no
                            AND d.peril_cd = e.peril_cd
                            AND e.line_cd = a.line_cd
                            AND a.policy_id = p_policy_id
                            AND NVL (c.control_cd, '!@#$') =
                                   NVL (p_control_cd,
                                        NVL (c.control_cd, '!@#$')
                                       )
                            AND c.grouped_item_title = p_grouped_item_title
                       ORDER BY c.grouped_item_title)
      LOOP
         v_rec.control_cd := j.control_cd;
         v_rec.policy_id := j.policy_id;
         v_rec.grouped_item_title := j.grouped_item_title;
         v_rec.endt_iss_cd := j.endt_iss_cd;
         v_rec.endt_yy := j.endt_yy;
         v_rec.endt_seq_no := j.endt_seq_no;
         v_rec.endt_no := j.endt_no;
         v_rec.item_no := j.item_no;
         v_rec.eff_date2 := TO_CHAR (j.eff_date, 'MM-DD-RRRR');
         v_rec.expiry_date := TO_CHAR (j.expiry_date, 'MM-DD-RRRR');
         v_rec.peril_sname := j.peril_sname;
         v_rec.tsi_amt := j.tsi_amt;
         v_rec.prem_amt := j.prem_amt;
         v_rec.delete_sw := j.delete_sw;

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

      RETURN;
   END get_gipir211_endt_dtls;

   FUNCTION get_gipir211_peril_dtls (
      p_policy_id            VARCHAR2,
      p_control_cd           VARCHAR2,
      p_item_no              VARCHAR2,
      p_grouped_item_title   VARCHAR2
   )
      RETURN gipir211_pkg_tab PIPELINED
   IS
      v_rec   gipir211_pkg_type;
   BEGIN
      FOR j IN (SELECT DISTINCT a.policy_id, c.control_cd,
                                c.grouped_item_title, a.endt_iss_cd,
                                a.endt_yy, a.endt_seq_no,
                                   a.endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                                                                     endt_no,
                                d.item_no, a.eff_date, a.expiry_date,
                                a.eff_date AS "eff_date2", e.peril_sname,
                                d.tsi_amt, d.prem_amt, c.delete_sw,
                                e.peril_cd, e.peril_type
                           FROM gipi_polbasic a,
                                giis_assured b,
                                gipi_grouped_items c,
                                gipi_itmperil_grouped d,
                                giis_peril e
                          WHERE a.assd_no = b.assd_no
                            AND a.policy_id = c.policy_id
                            AND c.policy_id = d.policy_id
                            AND c.grouped_item_no = d.grouped_item_no
                            AND d.peril_cd = e.peril_cd
                            AND e.line_cd = a.line_cd
                            AND a.policy_id = p_policy_id
                            AND NVL (c.control_cd, '!@#$') =
                                   NVL (p_control_cd,
                                        NVL (c.control_cd, '!@#$')
                                       )
                            AND d.item_no = p_item_no
                            AND c.grouped_item_title = p_grouped_item_title
                       ORDER BY c.grouped_item_title, e.peril_sname)
      LOOP
         v_rec.peril_sname := j.peril_sname;
         v_rec.tsi_amt := j.tsi_amt;
         v_rec.prem_amt := j.prem_amt;
         v_rec.delete_sw := j.delete_sw;
         v_rec.grouped_item_title := j.grouped_item_title;
         v_rec.peril_type := j.peril_type;
         

         IF j.peril_type = 'B' THEN
            v_rec.peril_comp_tsi := NVL(j.tsi_amt,0);
         ELSE
            v_rec.peril_comp_tsi := 0;
         END IF; 
             

         IF j.delete_sw = 'Y'
         THEN
            v_rec.cf_status := 'Deleted';
         ELSE
            v_rec.cf_status := 'Active';
         END IF;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_gipir211_peril_dtls;
END;
/


