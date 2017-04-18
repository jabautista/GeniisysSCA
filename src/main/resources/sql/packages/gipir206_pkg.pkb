CREATE OR REPLACE PACKAGE BODY CPI.GIPIR206_PKG
AS

    FUNCTION get_gipir206_details (
       p_as_of_date     VARCHAR2,
       p_from_date      VARCHAR2,
       p_to_date        VARCHAR2,
       p_plate_ending   VARCHAR2,
       p_plate          VARCHAR2,
       p_range          VARCHAR2,
       p_reinsurance    VARCHAR2,
       p_date_basis     VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE,
       p_user_id        giis_users.user_id%TYPE,
       p_cred_branch    gipi_polbasic.cred_branch%TYPE
    )
       RETURN gipir206_tab PIPELINED
    IS
       TYPE cur_type IS REF CURSOR;

       c                   cur_type;
       v_row               gipir206_type;
       v_line_cd_mc        giis_line.line_cd%TYPE;
       v_ctpl              giis_parameters.param_value_n%TYPE;
       v_iss_cd_ri         giis_parameters.param_value_v%TYPE;
       v_company_name      giis_parameters.param_value_v%TYPE;
       v_company_address   giis_parameters.param_value_v%TYPE;
       v_coverage          VARCHAR2 (150);
       v_date              VARCHAR2 (3000);
       v_query             VARCHAR2 (32767);
       v_column            VARCHAR2 (500);
       v_policy_id         gipi_vehicle.policy_id%TYPE;
       v_item_no           gipi_vehicle.item_no%TYPE;
    BEGIN
       BEGIN
          SELECT giisp.v ('LINE_CODE_MC')
            INTO v_line_cd_mc
            FROM DUAL;
       EXCEPTION
          WHEN OTHERS
          THEN
             v_line_cd_mc := 'MC';
       END;

       BEGIN
          SELECT giisp.n ('CTPL')
            INTO v_ctpl
            FROM DUAL;
       EXCEPTION
          WHEN OTHERS
          THEN
             v_ctpl := NULL;
       END;

       BEGIN
          SELECT giisp.v ('ISS_CD_RI')
            INTO v_iss_cd_ri
            FROM DUAL;
       EXCEPTION
          WHEN OTHERS
          THEN
             v_iss_cd_ri := NULL;
       END;

       BEGIN
          SELECT giisp.v ('COMPANY_NAME')
            INTO v_company_name
            FROM DUAL;
       EXCEPTION
          WHEN OTHERS
          THEN
             v_company_name := NULL;
       END;

       BEGIN
          SELECT giisp.v ('COMPANY_ADDRESS')
            INTO v_company_address
            FROM DUAL;
       EXCEPTION
          WHEN OTHERS
          THEN
             v_company_address := NULL;
       END;

       IF v_line_cd_mc IS NULL
       THEN
          v_line_cd_mc := 'MC';
       END IF;

       IF p_range = 1
       THEN
          v_coverage :=
                'As of '
             || TO_CHAR (TO_DATE (p_as_of_date, 'mm-dd-yyyy'), 'dd Month yyyy');
       ELSE
          v_coverage :=
                'For the period of '
             || TO_CHAR (TO_DATE (p_from_date, 'mm-dd-yyyy'), 'dd Month yyyy')
             || ' to '
             || TO_CHAR (TO_DATE (p_to_date, 'mm-dd-yyyy'), 'dd Month yyyy');
       END IF;

       v_column :=
          ' SELECT a.policy_id, a.item_no
                          FROM gipi_vehicle a 
                         WHERE ';

       IF p_plate_ending IS NULL
       THEN
          v_query := ' 1 = 1 ';
       ELSE
          v_query :=
                ' SUBSTR (a.plate_no, LENGTH (a.plate_no), 1) = '''
             || p_plate_ending
             || '''';
       END IF;

       v_query :=
             v_query
          || ' AND a.policy_id IN (
                              SELECT b.policy_id
                                FROM gipi_polbasic b,  gipi_itmperil c
                               WHERE b.pol_flag IN (''1'', ''2'', ''3'', ''X'')
                                 AND b.line_cd = '''
          || v_line_cd_mc
          || '''
                                 AND b.endt_seq_no = 0
                                 AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, ''GIPIS206'', '''
          || p_user_id
          || ''') = 1 
                                 AND c.peril_cd = '
          || v_ctpl
          || '
                                 AND c.item_no = a.item_no
                                 AND b.policy_id = c.policy_id
                                 AND c.line_cd = b.line_cd ';

       IF p_date_basis = '1'
       THEN
          v_date := ' AND TRUNC (b.incept_date) ';
       ELSIF p_date_basis = '2'
       THEN
          v_date := ' AND TRUNC (b.issue_date) ';
       ELSIF p_date_basis = '3'
       THEN
          v_date := ' AND TRUNC (b.eff_date) ';
       ELSIF p_date_basis = '4'
       THEN
          v_date := ' AND TRUNC (b.expiry_date) ';
       END IF;

       IF p_range = '2'
       THEN
          v_date :=
                v_date
             || ' BETWEEN '''
             || TO_DATE (p_from_date, 'mm-dd-yyyy')
             || ''' AND '''
             || TO_DATE (p_to_date, 'mm-dd-yyyy')
             || '''';
       ELSE
          v_date :=
                v_date || ' <= ''' || TO_DATE (p_as_of_date, 'mm-dd-yyyy')
                || '''';
       END IF;

       v_query := v_query || v_date;

       IF p_reinsurance = '1'
       THEN
          v_query := v_query || ' AND b.iss_cd != ''' || v_iss_cd_ri || '''';
       ELSIF p_reinsurance = '2'
       THEN
          v_query := v_query || ' AND b.iss_cd = ''' || v_iss_cd_ri || '''';
       END IF;

       IF p_cred_branch IS NOT NULL
       THEN
          IF check_user_per_line2 (NULL, p_cred_branch, p_module_id, p_user_id) =
                                                                                1
          THEN
             v_query :=
                   v_query
                || ' AND check_user_per_line2(b.line_cd, b.cred_branch, ''GIPIS206'', '''
                || p_user_id
                || ''') = 1
                              AND b.cred_branch = '''
                || p_cred_branch
                || '''';
          ELSE
             v_query :=
                   v_query
                || ' AND check_user_per_line2(b.line_cd, b.iss_cd, ''GIPIS206'', '''
                || p_user_id
                || ''') = 1
                              AND b.cred_branch = '''
                || p_cred_branch
                || '''                
                              AND b.cred_branch IS NOT NULL ';
          END IF;
       ELSE
          v_query :=
                v_query
             || ' AND (check_user_per_line2(b.line_cd, b.iss_cd, ''GIPIS206'', '''
             || p_user_id
             || ''') = 1    
                                  OR check_user_per_line2(b.line_cd, b.cred_branch, ''GIPIS206'', '''
             || p_user_id
             || ''') = 1 )                                 
                                  AND b.cred_branch IS NOT NULL ';
       END IF;

       v_query :=
             v_column
          || v_query
          || ') ORDER BY (SELECT eff_date
                            FROM gipi_polbasic
                           WHERE gipi_polbasic.policy_id = a.policy_id) DESC';

       OPEN c FOR v_query;

       LOOP
          FETCH c
           INTO v_policy_id, v_item_no;

          EXIT WHEN c%NOTFOUND;
          v_row := NULL;
          v_row.company_name := v_company_name;
          v_row.company_address := v_company_address;
          v_row.coverage := v_coverage;
          v_row.policy_id := v_policy_id;
          v_row.policy_no := get_policy_no (v_policy_id);
          v_row.item_no := v_item_no;
          v_row.incept_date :=
                              gipir206_pkg.get_gipir206_incept_date (v_policy_id);

          FOR a IN (SELECT a.assd_name
                      FROM giis_assured a, gipi_polbasic b, gipi_parlist c
                     WHERE b.par_id = c.par_id
                       AND c.assd_no = a.assd_no
                       AND b.policy_id = v_policy_id)
          LOOP
             v_row.assd_name := a.assd_name;
             EXIT;
          END LOOP;

          FOR d IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                           renew_no
                      FROM gipi_polbasic
                     WHERE policy_id = v_policy_id)
          LOOP
             FOR f IN (SELECT MAX (a.endt_seq_no) endt_no
                         FROM gipi_polbasic a, gipi_vehicle b
                        WHERE a.line_cd = d.line_cd
                          AND a.subline_cd = d.subline_cd
                          AND a.iss_cd = d.iss_cd
                          AND a.issue_yy = d.issue_yy
                          AND a.pol_seq_no = d.pol_seq_no
                          AND a.renew_no = d.renew_no
                          AND a.policy_id = b.policy_id
                          AND b.item_no = v_item_no)
             LOOP
                DECLARE
                   v_endt_no   NUMBER;
                BEGIN
                   v_endt_no := f.endt_no;

                   FOR g IN (SELECT b.plate_no, b.serial_no
                               FROM gipi_polbasic a, gipi_vehicle b
                              WHERE a.line_cd = d.line_cd
                                AND a.subline_cd = d.subline_cd
                                AND a.iss_cd = d.iss_cd
                                AND a.issue_yy = d.issue_yy
                                AND a.pol_seq_no = d.pol_seq_no
                                AND a.renew_no = d.renew_no
                                AND a.policy_id = b.policy_id
                                AND b.item_no = v_item_no)
                   LOOP
                      FOR e IN 0 .. v_endt_no
                      LOOP
                         IF g.plate_no IS NOT NULL
                         THEN
                            v_row.plate_no := g.plate_no;
                         END IF;

                         IF g.serial_no IS NOT NULL
                         THEN
                            v_row.serial_no := g.serial_no;
                         END IF;
                      END LOOP;
                   END LOOP;

                   FOR g IN (SELECT m.car_company || ' ' || k.make co_make
                               FROM gipi_polbasic a,
                                    gipi_vehicle b,
                                    giis_mc_make k,
                                    giis_mc_car_company m
                              WHERE a.line_cd = d.line_cd
                                AND a.subline_cd = d.subline_cd
                                AND a.iss_cd = d.iss_cd
                                AND a.issue_yy = d.issue_yy
                                AND a.pol_seq_no = d.pol_seq_no
                                AND a.renew_no = d.renew_no
                                AND a.policy_id = b.policy_id
                                AND b.item_no = v_item_no
                                AND m.car_company_cd = b.car_company_cd
                                AND k.make_cd(+) = b.make_cd)
                   LOOP
                      FOR e IN REVERSE 0 .. v_endt_no
                      LOOP
                         IF g.co_make IS NOT NULL
                         THEN
                            v_row.co_make := g.co_make;
                         END IF;
                      END LOOP;
                   END LOOP;
                END;
             END LOOP;

             FOR c IN (SELECT SUM (prem_amt) ctpl_amt
                         FROM gipi_itmperil
                        WHERE item_no = v_item_no
                          AND peril_cd = v_ctpl
                          AND policy_id IN (
                                 SELECT policy_id
                                   FROM gipi_polbasic
                                  WHERE line_cd = d.line_cd
                                    AND subline_cd = d.subline_cd
                                    AND iss_cd = d.iss_cd
                                    AND issue_yy = d.issue_yy
                                    AND pol_seq_no = d.pol_seq_no
                                    AND renew_no = d.renew_no))
             LOOP
                v_row.ctpl := NVL (c.ctpl_amt, '0.00');
             END LOOP;
          END LOOP;

          PIPE ROW (v_row);
       END LOOP;
    END; 
   
   FUNCTION get_gipir206_incept_date(
      p_policy_id             GIPI_POLBASIC.policy_id%TYPE
   )
     RETURN VARCHAR2
   IS
      v_max_eff_date          DATE;
         v_incept_date           DATE;
   BEGIN
      FOR d IN(SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                 FROM GIPI_POLBASIC
                WHERE policy_id = p_policy_id)
      LOOP 
           FOR e IN(SELECT MAX(eff_date) max_date
                     FROM GIPI_POLBASIC
                    WHERE line_cd = d.line_cd
                      AND subline_cd = d.subline_cd
                      AND iss_cd = d.iss_cd
                      AND issue_yy = d.issue_yy
                      AND pol_seq_no = d.pol_seq_no
                      AND renew_no = d.renew_no)
          LOOP
                v_max_eff_date := e.max_date;
            
                FOR f IN(SELECT incept_date
                           FROM GIPI_POLBASIC
                          WHERE line_cd = d.line_cd
                         AND subline_cd = d.subline_cd
                        AND iss_cd = d.iss_cd
                        AND issue_yy = d.issue_yy
                        AND pol_seq_no = d.pol_seq_no
                        AND renew_no = d.renew_no
                        AND eff_date LIKE TO_DATE(v_max_eff_date))
            LOOP
               v_incept_date := f.incept_date;
             END LOOP;
         END LOOP;
      END LOOP;
          
      RETURN TO_CHAR(v_incept_date, 'mm-dd-yyyy');
   END;
   
END GIPIR206_PKG;
/


