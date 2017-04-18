CREATE OR REPLACE PACKAGE BODY CPI.giuwr130_pkg
AS
   FUNCTION get_giuwr130_policy (
      p_dist_flag   giuw_pol_dist.dist_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giuwr130_policy_no_tab PIPELINED
   IS
      v_rec   giuwr130_policy_no_type;
      v_exist BOOLEAN := FALSE;
   BEGIN
        FOR a IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_rec.cf_company_name := a.param_value_v;
            EXIT;
        END LOOP;

        IF p_dist_flag IN ('1', '2')
        THEN
            v_rec.cf_header := 'Undistributed';
        ELSIF p_dist_flag IN ('7', '8')
        THEN
            v_rec.cf_header := 'Distributed';
        ELSE
            v_rec.cf_header := '';
        END IF;

        IF p_dist_flag IN ('1', '7')
        THEN
            v_rec.cf_header2 := 'w/o Facultative';
        ELSIF p_dist_flag IN ('2', '8')
        THEN
            v_rec.cf_header2 := 'w/ Facultative';
        ELSE
            v_rec.cf_header2 := '';
        END IF;

        IF p_dist_flag = '6'
        THEN
            v_rec.cf_header3 := 'All Undistributed';
        ELSIF p_dist_flag = '3'
        THEN
            v_rec.cf_header3 := 'All Distributed';
        ELSIF p_dist_flag = '4'
        THEN
            v_rec.cf_header3 := 'All Negated';
        ELSIF p_dist_flag = '5'
        THEN
            v_rec.cf_header3 := 'All Redistributed';
        ELSIF p_dist_flag = '9'
        THEN
            v_rec.cf_header3 := 'All';
        ELSE
            v_rec.cf_header3 := '';
        END IF;

        IF p_dist_flag IN ('6', '3', '4', '5', '9')
        THEN
            v_rec.cf_final_header := v_rec.cf_header3 || ' Policies';
        END IF;

        IF p_dist_flag IN ('1', '2', '7', '8')
        THEN
            v_rec.cf_final_header :=
                          v_rec.cf_header || ' Policies ' || v_rec.cf_header2;
        END IF;
         
        
        FOR i IN (SELECT x.policy_id,
                          x.line_cd
                       || ' - '
                       || x.subline_cd --|| RPAD (x.subline_cd, 4)
                       || ' - '
                       || x.iss_cd
                       || ' -'
                       || TO_CHAR (x.issue_yy, '09')
                       || ' -'
                       || TO_CHAR (x.pol_seq_no, '0999999')
                       || ' -'
                       || TO_CHAR (x.renew_no, '09') policy_no,
                       DECODE (x.endt_seq_no,
                               0, '',
                                  x.endt_iss_cd
                               || ' -'
                               || TO_CHAR (x.endt_yy, '09')
                               || ' -'
                               || TO_CHAR (x.endt_seq_no, '0999999')
                              ) endt_no,
                       x.expiry_date, x.eff_date, y.share_cd,
                       NVL (y.dist_tsi, 0) dist_tsi,
                       NVL (y.dist_prem, 0) dist_prem,
                       NVL (y.dist_spct, 0) dist_spct,
                       y.dist_spct1 dist_spct1, b.dist_flag,
                       TO_CHAR (y.dist_no, '0999999') dist_no,
                       TO_CHAR (y.dist_seq_no, '0999999') dist_seq_no,
                       y.line_cd, -- added new columns by robert SR 5290 01.29.2016
                       x.endt_expiry_date, b.eff_date dist_eff_date, b.expiry_date dist_exp_date
                  FROM gipi_polbasic x, giuw_pol_dist b, giuw_wpolicyds_policyds_dtl_v y --giuw_policyds_dtl y replaced by robert SR 5290 03.29.2016
                 WHERE 1 = 1
                   AND b.policy_id = x.policy_id
                   AND check_user_per_iss_cd2 (x.line_cd,   -- changed from check_user_iss_cd : shan 05.13.2014
                                               x.iss_cd,
                                               'GIPIS130'
                                               ,p_user_id
                                              ) = 1
                   AND x.pol_flag <> '5'
                   AND b.dist_no >= 0
                   AND b.dist_no = y.dist_no(+) --added (+) by robert SR 5290 03.29.2016
                   --AND y.line_cd = x.line_cd --removed by robert SR 5290  03.29.2016
                   AND EXISTS (SELECT par_id
                                 FROM gipi_parlist
                                WHERE par_id = x.par_id AND par_status = 10)
                   AND (   p_dist_flag = 1 AND b.dist_flag = '1'
                        OR (p_dist_flag = 2 AND b.dist_flag = '2')
                        OR (p_dist_flag = 3 AND b.dist_flag = '3')
                        OR (p_dist_flag = 4 AND b.dist_flag = '4')
                        OR (p_dist_flag = 5 AND b.dist_flag = '5')
                        OR (p_dist_flag = 6 AND b.dist_flag IN (1, 2))
                        OR (    p_dist_flag = 7
                            AND b.dist_flag = '3'
                            AND NOT EXISTS (
                                   SELECT dist_no
                                     FROM giri_distfrps
                                    WHERE dist_no = b.dist_no
                                      AND line_cd = x.line_cd)
                           )
                        OR (    p_dist_flag = 8
                            AND b.dist_flag = '3'
                            AND EXISTS (
                                   SELECT dist_no
                                     FROM giri_distfrps
                                    WHERE dist_no = b.dist_no
                                      AND line_cd = x.line_cd)
                           )
                        OR (p_dist_flag = 9 AND b.dist_flag = b.dist_flag)
                       )
                ORDER BY x.line_cd
                       || ' - '
                       || RPAD (x.subline_cd, 4)
                       || ' - '
                       || x.iss_cd
                       || ' -'
                       || TO_CHAR (x.issue_yy, '09')
                       || ' -'
                       || TO_CHAR (x.pol_seq_no, '0999999')
                       || ' -'
                       || TO_CHAR (x.renew_no, '09'), endt_no, dist_no, eff_date, dist_seq_no, share_cd)
      LOOP
         v_rec.policy_no := i.policy_no;
         v_rec.endt_no := i.endt_no;
         v_rec.dist_no := i.dist_no;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-RRRR');
         -- added new columns by robert SR 5290 01.29.2016
         v_rec.expiry_date := TO_CHAR (NVL(i.endt_expiry_date,i.expiry_date), 'MM-DD-RRRR');
         v_rec.dist_eff_date := TO_CHAR (i.dist_eff_date, 'MM-DD-RRRR');
         v_rec.dist_exp_date := TO_CHAR (i.dist_exp_date, 'MM-DD-RRRR');
         v_rec.policy_id := i.policy_id;
         v_rec.dist_tsi := i.dist_tsi;
         v_rec.dist_prem := i.dist_prem;
         v_rec.dist_spct := i.dist_spct;
         v_rec.dist_spct1 := i.dist_spct1;
         v_rec.dist_seq_no := i.dist_seq_no;

         FOR b IN (SELECT trty_name
                     FROM giis_dist_share
                    WHERE 1 = 1
                      AND share_cd = i.share_cd
                      AND line_cd = i.line_cd)
         LOOP
            v_rec.cf_treaty_name := b.trty_name;
            EXIT;
         END LOOP;
        
         /* moved above : shan 05.13.2014
         FOR a IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'COMPANY_NAME')
         LOOP
            v_rec.cf_company_name := a.param_value_v;
            EXIT;
         END LOOP;

         IF p_dist_flag IN ('1', '2')
         THEN
            v_rec.cf_header := 'Undistributed';
         ELSIF p_dist_flag IN ('7', '8')
         THEN
            v_rec.cf_header := 'Distributed';
         ELSE
            v_rec.cf_header := '';
         END IF;

         IF p_dist_flag IN ('1', '7')
         THEN
            v_rec.cf_header2 := 'w/o Facultative';
         ELSIF p_dist_flag IN ('2', '8')
         THEN
            v_rec.cf_header2 := 'w/ Facultative';
         ELSE
            v_rec.cf_header2 := '';
         END IF;

         IF p_dist_flag = '6'
         THEN
            v_rec.cf_header3 := 'All Undistributed';
         ELSIF p_dist_flag = '3'
         THEN
            v_rec.cf_header3 := 'All Distributed';
         ELSIF p_dist_flag = '4'
         THEN
            v_rec.cf_header3 := 'All Negated';
         ELSIF p_dist_flag = '5'
         THEN
            v_rec.cf_header3 := 'All Redistributed';
         ELSIF p_dist_flag = '9'
         THEN
            v_rec.cf_header3 := 'All';
         ELSE
            v_rec.cf_header3 := '';
         END IF;

         IF p_dist_flag IN ('6', '3', '4', '5', '9')
         THEN
            v_rec.cf_final_header := v_rec.cf_header3 || ' Policies';
         END IF;

         IF p_dist_flag IN ('1', '2', '7', '8')
         THEN
            v_rec.cf_final_header :=
                          v_rec.cf_header || ' Policies ' || v_rec.cf_header2;
         END IF; */
         
         v_rec.print_details := 'Y';    -- shan 05.13.2014
         v_exist             := TRUE;   -- shan 05.13.2014
         
         PIPE ROW (v_rec);
      END LOOP;

      -- shan 05.13.2014
      IF v_exist = FALSE THEN
          v_rec.print_details := 'N';
          PIPE ROW(v_rec);  
      END IF;
      
      RETURN;
   END get_giuwr130_policy;

   FUNCTION get_giuwr130_dist_seq_no (
      p_dist_flag   VARCHAR2,
      p_user_id     VARCHAR2,
      p_dist_no     VARCHAR2
   )
      RETURN giuwr130_dist_seq_no_tab PIPELINED
   IS
      v_rec   giuwr130_dist_seq_no_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM TABLE (giuwr130_pkg.get_giuwr130_policy (p_dist_flag,
                                                                p_user_id
                                                               )
                             )
                 WHERE dist_no = p_dist_no)
      LOOP
         v_rec.dist_seq_no := i.dist_seq_no;
         v_rec.dist_no := i.dist_no;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_giuwr130_dist_seq_no;

   FUNCTION get_giuwr130_share_cd (
      p_dist_flag     VARCHAR2,
      p_user_id       VARCHAR2,
      p_dist_no       VARCHAR2,
      p_dist_seq_no   VARCHAR2
   )
      RETURN giuwr130_share_cd_tab PIPELINED
   IS
      v_rec   giuwr130_share_cd_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM TABLE (giuwr130_pkg.get_giuwr130_policy (p_dist_flag,
                                                                p_user_id
                                                               )
                             )
                 WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
      LOOP
         v_rec.cf_treaty_name := i.cf_treaty_name;
         v_rec.dist_tsi := i.dist_tsi;
         v_rec.dist_prem := i.dist_prem;
         v_rec.dist_spct := i.dist_spct;
         v_rec.dist_spct1 := i.dist_spct1;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_giuwr130_share_cd;
END;
/


