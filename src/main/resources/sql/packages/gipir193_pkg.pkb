CREATE OR REPLACE PACKAGE BODY cpi.gipir193_pkg
AS
   /** Created By:     Shan Bati
    ** Date Created:   10.11.2013
    ** Referenced By:  GIPIR193 - Policy Listing per Plate No
    **/
   FUNCTION populate_report (
      p_plate_no      gipi_vehicle.plate_no%TYPE,
      p_cred_branch   gipi_polbasic.cred_branch%TYPE,
      p_date_type     VARCHAR2,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN report_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;

      v_print        VARCHAR2 (32767) := 'FALSE';
      rec            report_type;
      custom         cur_type;
      v_query        VARCHAR2 (32767);
      v_search       VARCHAR2 (32767);
      v_as_of_date   DATE;
      v_from_date    DATE;
      v_to_date      DATE;
   BEGIN
      v_as_of_date := NVL (TO_DATE (p_as_of_date, 'MM-DD-RRRR'), NULL);
      v_from_date := NVL (TO_DATE (p_from_date, 'MM-DD-RRRR'), NULL);
      v_to_date := NVL (TO_DATE (p_to_date, 'MM-DD-RRRR'), NULL);
      v_query :=
            'SELECT b.plate_no, get_policy_no(a.policy_id) policy_no, d.assd_no, d.assd_name, c.incept_date,
                           c.expiry_date, TO_CHAR (a.item_no, ''00009'') || ''-'' || a.item_title item, 
                           b.make, b.motor_no, b.serial_no, a.tsi_amt, a.prem_amt
                      FROM gipi_item a, 
                           gipi_vehicle b, 
                           gipi_polbasic c, 
                           giis_assured d
                     WHERE a.policy_id = b.policy_id 
                       AND c.assd_no = d.assd_no
                       AND a.item_no = b.item_no              
                       AND UPPER(b.plate_no) = '''
         || UPPER (p_plate_no)
         || '''
                       AND a.policy_id = c.policy_id';

      IF p_as_of_date IS NULL AND p_from_date IS NULL AND p_to_date IS NULL
      THEN
         v_search := 'AND 1=1';
      ELSE
         IF p_date_type = '1'
         THEN                                                        --incept
            v_search :=
                  'AND (trunc(c.incept_date) >= '''
               || v_from_date
               || '''
                                  AND trunc(c.incept_date) <= '''
               || v_to_date
               || '''
                                  OR trunc(c.incept_date) <= '''
               || v_as_of_date
               || ''' )';
         ELSIF p_date_type = '2'
         THEN                                                            --eff
            v_search :=
                  'AND (trunc(c.eff_date) >= '''
               || v_from_date
               || '''
                                  AND trunc(c.eff_date) <= '''
               || v_to_date
               || '''
                                  OR trunc(c.eff_date) <= '''
               || v_as_of_date
               || ''' )';
         ELSIF p_date_type = '3'
         THEN                                                          --issue
            v_search :=
                  'AND (trunc(c.issue_date) >= '''
               || v_from_date
               || '''
                                  AND trunc(c.issue_date) <= '''
               || v_to_date
               || '''
                                  OR trunc(c.issue_date) <= '''
               || v_as_of_date
               || ''' )';
         END IF;
      END IF;

      IF p_cred_branch IS NOT NULL
      THEN
         IF check_user_per_iss_cd2 (NULL,
                                    p_cred_branch,
                                    'GIPIS193',
                                    p_user_id
                                   ) = 1
         THEN
            v_search :=
                  v_search
               || ' AND check_user_per_iss_cd2(c.line_cd, c.cred_branch,''GIPIS193'', '''
               || p_user_id
               || ''' )=1
                                           AND c.cred_branch = '''
               || p_cred_branch
               || '''';
         ELSE
            v_search :=
                  v_search
               || ' AND check_user_per_iss_cd2(c.line_cd, c.iss_cd,''GIPIS193'', '''
               || p_user_id
               || ''' )=1
                                           AND c.cred_branch = '''
               || p_cred_branch
               || '''
                                           AND c.cred_branch IS NOT NULL ';
         END IF;
      ELSE
         v_search :=
               v_search
            || ' AND (check_user_per_iss_cd2(c.line_cd,c.iss_cd,''GIPIS193'', '''
            || p_user_id
            || ''')=1
                                        OR (check_user_per_iss_cd2(c.line_cd,c.cred_branch,''GIPIS193'', '''
            || p_user_id
            || ''')=1
                                        AND c.cred_branch IS NOT NULL) 
                                     )';
      END IF;

      BEGIN
         SELECT param_value_v
           INTO rec.company_name
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rec.company_name := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO rec.company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rec.company_address := NULL;
      END;

      rec.cf_title := 'POLICY LISTING PER PLATE NO.';
      v_query := v_query || ' ' || v_search;

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO rec.plate_no, rec.policy_no, rec.assd_no, rec.assd_name,
               rec.incept_date, rec.expiry_date, rec.item, rec.make,
               rec.motor_no, rec.serial_no, rec.tsi_amt, rec.prem_amt;

         v_print := 'TRUE';
         rec.print_details := 'Y';

         IF custom%NOTFOUND
         THEN
            rec.print_details := 'N';
            EXIT;
         END IF;

         PIPE ROW (rec);
      END LOOP;
      CLOSE custom;
   END populate_report;
END gipir193_pkg;
/