CREATE OR REPLACE PACKAGE BODY cpi.csv_uw_inquiries
AS

   FUNCTION get_gipir198 (
      p_starting_date   DATE,
      p_ending_date     DATE,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN gipir198_tab PIPELINED
   IS
      v_rec             gipir198_type;
   BEGIN
      FOR i IN (SELECT line_cd,
                          line_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || TO_CHAR (par_yy, 'fm09')
                       || '-'
                       || TO_CHAR (par_seq_no, 'fm0999999') par_number,
                       get_assd_name (assd_no) assd_name, incept_date,
                       expiry_date, covernote_expiry, tsi_amt, prem_amt
                  FROM gixx_covernote_exp
                 WHERE user_id = p_user_id
                   AND covernote_expiry BETWEEN p_starting_date AND p_ending_date
              ORDER BY line_cd)
      LOOP
         SELECT line_cd || ' - ' || line_name
           INTO v_rec.line
           FROM giis_line
          WHERE line_cd = i.line_cd;

         v_rec.par_number        := i.par_number;
         v_rec.assured_name      := i.assd_name;
         v_rec.incept_date       := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_rec.expiry_date       := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_rec.covernote_expiry  := TO_CHAR (i.covernote_expiry, 'MM-DD-RRRR');
         v_rec.tsi_amount        := NVL(i.tsi_amt,0);
         v_rec.premium_amount    := NVL(i.prem_amt,0);
         
         PIPE ROW (v_rec);
      END LOOP;
   END get_gipir198;

   FUNCTION get_gipir192 (
       p_make_cd               VARCHAR2,
       p_company_cd            VARCHAR2,
       p_search_by             VARCHAR2,
       p_as_of_date            VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2,
       p_user_id               VARCHAR2,
       p_cred_branch           VARCHAR2
   )
      RETURN gipir192_tab PIPELINED
   IS
        TYPE cur_type IS REF CURSOR;
        
        v_list           gipir192_type;
        rec             cur_type;
        v_query         VARCHAR2 (32767);
        v_column        VARCHAR2 (3200);
        v_search        VARCHAR2 (32767);
   BEGIN
       v_column := 'SELECT DISTINCT make_cd ||'' - ''|| make make, d.car_company company, get_policy_no(b.policy_id),
                                    get_assd_name(c.assd_no), c.incept_date, c.expiry_date, b.item_title, a.plate_no,
                                    a.motor_no, a.serial_no, b.tsi_amt, b.prem_amt ';
                                    
       v_query :=  '  FROM gipi_vehicle a, gipi_item b, gipi_polbasic c , giis_mc_car_company d
                     WHERE a.policy_id = b.policy_id
                       AND b.policy_id = c.policy_id
                       AND a.item_no = b.item_no
                       AND a.car_company_cd = d.car_company_cd
                       AND a.car_company_cd = '
                      || p_company_cd
                      || ' AND (DECODE('
                      || p_search_by
                      || ', 1, c.incept_date,
                                                         2, c.eff_date,
                                                         3, c.issue_date) >= TO_DATE('''
                      || p_from_date
                      || ''', ''MM-DD-YYYY'')
                                           AND DECODE('
                      || p_search_by
                      || ', 1, c.incept_date,
                                                        2, c.eff_date,
                                                        3, c.issue_date) <= TO_DATE('''
                      || p_to_date
                      || ''', ''MM-DD-YYYY'')
                                            OR DECODE('
                      || p_search_by
                      || ', 1, c.incept_date,
                                                        2, c.eff_date,
                                                        3, c.issue_date) <= TO_DATE('''
                      || p_as_of_date
                      || ''', ''MM-DD-YYYY''))';

       IF p_make_cd IS NOT NULL THEN
          v_query := v_query || ' AND make_cd = ' || p_make_cd || ' AND a.policy_id IN (SELECT policy_id 
                                                      FROM gipi_polbasic ';
       ELSE
          v_query := v_query || ' AND a.policy_id IN (SELECT policy_id 
                                                      FROM gipi_polbasic ';
       END IF;

       IF p_cred_branch IS NOT NULL THEN
          IF check_user_per_iss_cd2 (NULL, p_cred_branch, 'GIPIS192', p_user_id) = 1 THEN
             v_search :=
                   v_search || ' WHERE check_user_per_iss_cd2(LINE_CD,cred_branch,''GIPIS192'', ''' || p_user_id || ''' )=1
                                           AND cred_branch = ''' || p_cred_branch || ''' )';
          ELSE
             v_search :=
                   v_search
                || ' WHERE check_user_per_iss_cd2(LINE_CD,iss_cd,''GIPIS192'', '''
                || p_user_id
                || ''' )=1
                                           AND cred_branch = '''
                || p_cred_branch
                || '''
                                           AND cred_branch IS NOT NULL )';
          END IF;
       ELSE
          v_search :=
                v_search
             || ' WHERE (check_user_per_iss_cd2(LINE_CD,iss_cd,''GIPIS192'', '''
             || p_user_id
             || ''')=1
                                        OR (check_user_per_iss_cd2(LINE_CD,cred_branch,''GIPIS192'', '''
             || p_user_id
             || ''')=1
                                        AND cred_branch IS NOT NULL) 
                                     ))';
       END IF;

       /*Get records*/
       v_query := v_column || ' ' ||v_query || ' ' || v_search;  
       
       OPEN rec FOR v_query;

        LOOP
            FETCH rec    
             INTO v_list.make, v_list.company, v_list.policy_no, v_list.assured_name, v_list.incept_date, v_list.expiry_date, v_list.item_title, v_list.plate_no,
                  v_list.engine_no, v_list.serial_no, v_list.tsi_amount, v_list.prem_amount;
            
            EXIT WHEN rec%NOTFOUND;
            
            PIPE ROW(v_list);
        END LOOP;
   END get_gipir192;  
   
   -- Carlo Rubenecia SR-5325 06/21/2016 -START
   FUNCTION get_gipir193 (
        p_plate_no      GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_user_id       VARCHAR2    
   )
      RETURN report_tab PIPELINED
   AS
        TYPE cur_type IS REF CURSOR;
        
        rec             report_type;
        custom          cur_type;
        v_query         VARCHAR2(32767);
        v_search        VARCHAR2(32767);
        v_as_of_date    DATE;
        v_from_date     DATE;
        v_to_date       DATE;
    BEGIN
        v_as_of_date    := NVL(TO_DATE(p_as_of_date, 'MM-DD-RRRR'), null);
        v_from_date     := NVL(TO_DATE(p_from_date, 'MM-DD-RRRR'), null);
        v_to_date       := NVL(TO_DATE(p_to_date, 'MM-DD-RRRR'), null);
    
        v_query := 'SELECT b.plate_no, get_policy_no(a.policy_id) policy_no, d.assd_name, c.incept_date,
                           c.expiry_date, TO_CHAR (a.item_no, ''00009'') || ''-'' || a.item_title item_title, 
                           b.make, b.motor_no, b.serial_no, TRIM(TO_CHAR(a.tsi_amt, ''999,999,999,999,999,990.00'')), TRIM(TO_CHAR(a.prem_amt, ''999,999,999,999,999,990.00''))
                      FROM gipi_item a, 
                           gipi_vehicle b, 
                           gipi_polbasic c, 
                           giis_assured d
                     WHERE a.policy_id = b.policy_id 
                       AND c.assd_no = d.assd_no
                       AND a.item_no = b.item_no              
                       AND UPPER(b.plate_no) = ''' || UPPER(p_plate_no) || '''
                       AND a.policy_id = c.policy_id';
                                            
        
        IF p_as_of_date IS NULL AND p_from_date IS NULL AND p_to_date IS NULL THEN
            v_search    := 'AND 1=1';
        ELSE
            IF p_date_type = '1' THEN   --incept
                v_search    := 'AND (trunc(c.incept_date) >= ''' || v_from_date || '''
                                  AND trunc(c.incept_date) <= ''' || v_to_date || '''
                                  OR trunc(c.incept_date) <= ''' || v_as_of_date || ''' )';
            ELSIF p_date_type = '2' THEN    --eff
                v_search    := 'AND (trunc(c.eff_date) >= ''' || v_from_date || '''
                                  AND trunc(c.eff_date) <= ''' || v_to_date || '''
                                  OR trunc(c.eff_date) <= ''' || v_as_of_date || ''' )';
            ELSIF p_date_type = '3' THEN    --issue
                v_search    := 'AND (trunc(c.issue_date) >= ''' || v_from_date || '''
                                  AND trunc(c.issue_date) <= ''' || v_to_date || '''
                                  OR trunc(c.issue_date) <= ''' || v_as_of_date || ''' )';
            END IF;
        END IF;
        
       IF p_cred_branch IS NOT NULL THEN
          IF check_user_per_iss_cd2 (NULL, p_cred_branch, 'GIPIS193', p_user_id) = 1 THEN
             v_search :=
                   v_search || ' AND check_user_per_iss_cd2(c.line_cd, c.cred_branch,''GIPIS193'', ''' || p_user_id || ''' )=1
                                           AND c.cred_branch = ''' || p_cred_branch || '''';
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
            
        v_query := v_query || ' ' || v_search || 'ORDER BY policy_no';
        
        
        OPEN custom FOR v_query;
        
        LOOP
            FETCH custom    
              INTO rec.plate_no, rec.policy_no, rec.assd_name, rec.incept_date, rec.expiry_date,
                   rec.item, rec.make, rec.motor_no, rec.serial_no, rec.tsi_amt, rec.prem_amt;
            
            EXIT WHEN custom%NOTFOUND;   
              
            PIPE ROW(rec);
        END LOOP;
        CLOSE custom;
    END get_gipir193;
    --Carlo Rubenecia SR-5325 06/21/2016 -END
    
     --Added by Carlo Rubenecia SR-5326 06.22.2016 --start
   FUNCTION get_gipir194 (
      p_mot_type     gipi_vehicle.mot_type%TYPE,
      p_subline_cd   gipi_vehicle.subline_cd%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_type    VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN gipir194_tab PIPELINED
   AS
        TYPE cur_type IS REF CURSOR;
        
        rec             gipir194_type;
        c               cur_type;
        v_query         VARCHAR2(32767);
        v_search        VARCHAR2(32767); 
        v_as_of_date    DATE;
        v_from_date     DATE;
        v_to_date       DATE;     
   BEGIN
        v_as_of_date    := NVL(TO_DATE(p_as_of_date, 'MM-DD-RRRR'), null);
        v_from_date     := NVL(TO_DATE(p_from_date, 'MM-DD-RRRR'), null);
        v_to_date       := NVL(TO_DATE(p_to_date, 'MM-DD-RRRR'), null);
    
        v_query := 'SELECT   b.mot_type || '' - '' || d.motor_type_desc motor_type, b.subline_cd,
                             get_policy_no (a.policy_id) policy_no, e.assd_name, TO_CHAR(c.incept_date,''MM-dd-yyyy''), 
                             TO_CHAR(c.expiry_date,''MM-dd-yyyy''), a.item_title, b.plate_no, b.motor_no, b.serial_no,
                             TRIM(TO_CHAR(a.tsi_amt, ''999,999,999,999,999,990.00'')), TRIM(TO_CHAR(a.prem_amt, ''999,999,999,999,999,990.00''))
                        FROM gipi_item a,
                             gipi_vehicle b,
                             gipi_polbasic c,
                             giis_motortype d,
                             giis_assured e
                       WHERE a.policy_id = b.policy_id
                         AND a.item_no = b.item_no
                         AND a.policy_id = c.policy_id
                         AND b.policy_id = c.policy_id
                         AND b.mot_type = ''' || p_mot_type || '''
                         AND b.subline_cd = ''' || p_subline_cd || '''
                         AND b.mot_type = d.type_cd
                         AND d.subline_cd = b.subline_cd
                         AND c.assd_no = e.assd_no
                         AND check_user_per_iss_cd2(c.line_cd,c.iss_cd,''GIPIS194'', ''' || p_user_id || ''') = 1';
                                            
        
        IF p_as_of_date IS NULL AND p_from_date IS NULL AND p_to_date IS NULL THEN
            v_search    := 'AND 1=1';
        ELSE
            IF p_date_type = '1' THEN   --incept
                v_search    := 'AND (trunc(c.incept_date) >= ''' || v_from_date || '''
                                  AND trunc(c.incept_date) <= ''' || v_to_date || '''
                                  OR trunc(c.incept_date) <= ''' || v_as_of_date || ''' )';
            ELSIF p_date_type = '2' THEN    --eff
                v_search    := 'AND (trunc(c.eff_date) >= ''' || v_from_date || '''
                                  AND trunc(c.eff_date) <= ''' || v_to_date || '''
                                  OR trunc(c.eff_date) <= ''' || v_as_of_date || ''' )';
            ELSIF p_date_type = '3' THEN    --issue
                v_search    := 'AND (trunc(c.issue_date) >= ''' || v_from_date || '''
                                  AND trunc(c.issue_date) <= ''' || v_to_date || '''
                                  OR trunc(c.issue_date) <= ''' || v_as_of_date || ''' )';
            END IF;
        END IF;       
            
        v_query := v_query || ' ' || v_search || 'ORDER BY policy_no';
        
        
        OPEN c FOR v_query;
        
        LOOP
            FETCH c    
              INTO rec.motor_type, rec.subline_cd, rec.policy_no, rec.assd_name, rec.incept_date,
                   rec.expiry_date, rec.item_title, rec.plate_no, rec.motor_no, rec.serial_no, rec.tsi_amt,
                   rec.prem_amt;
            
            EXIT WHEN c%NOTFOUND;   
              
            PIPE ROW(rec);
        END LOOP;
        CLOSE c;
   END get_gipir194; 
   --Added by Carlo Rubenecia SR-5326 06.22.2016 --END
   
      --Added by Carlo Rubenecia SR-5328 06.22.2016  -- START    
   FUNCTION get_gipir206 (
      p_cred_branch        GIPI_POLBASIC.cred_branch%TYPE,
      p_as_of_date         VARCHAR2,
      p_from_date          VARCHAR2,
      p_to_date            VARCHAR2,
      p_plate_ending       VARCHAR2,
      p_date_basis         VARCHAR2,
      p_date_range         VARCHAR2,
      p_reinsurance        VARCHAR2,
      p_module_id          GIIS_MODULES.module_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
      RETURN gipir206_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
        
        c               cur_type;
      v_row          gipir206_type;
      v_line_cd_mc   giis_line.line_cd%TYPE;
      v_ctpl         giis_parameters.param_value_n%TYPE;
      v_iss_cd_ri    giis_parameters.param_value_v%TYPE;
      v_date         VARCHAR2 (3000);
      v_query        VARCHAR2 (32767);
      v_column       VARCHAR2 (500);   
      v_policy_id    gipi_vehicle.policy_id%TYPE;
      v_item_no gipi_vehicle.item_no%TYPE;
      v_plate_no gipi_vehicle.plate_no%TYPE;
      v_serial_no gipi_vehicle.serial_no%TYPE;
      v_max_eff_date       DATE;
      v_max_endt_seq_no NUMBER;
   BEGIN
          v_line_cd_mc := giisp.v ('LINE_CODE_MC');
       v_ctpl       := giisp.n ('CTPL');
       v_iss_cd_ri  := giisp.v ('ISS_CD_RI');
       
      v_column := ' SELECT a.policy_id, a.item_no, a.plate_no, a.serial_no
                      FROM gipi_vehicle a 
                     WHERE ';
      
      IF p_plate_ending IS NULL
      THEN
        v_query := ' 1 = 1 ';
      ELSE
        v_query := ' SUBSTR (a.plate_no, LENGTH (a.plate_no), 1) = ''' || p_plate_ending || '''' ;
      END IF;
      
      v_query := v_query ||
                  ' AND a.policy_id IN (
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
      
      IF p_date_range = '2'
      THEN
        v_date := v_date || ' BETWEEN ''' || TO_DATE(p_from_date, 'mm-dd-yyyy') 
                         || ''' AND '''
                         || TO_DATE(p_to_date, 'mm-dd-yyyy') || '''';
      ELSE
        v_date := v_date || ' <= ''' || TO_DATE(p_as_of_date, 'mm-dd-yyyy') || '''';
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
        IF check_user_per_line2(NULL, p_cred_branch, p_module_id, p_user_id) = 1
        THEN
          v_query := v_query ||
                        ' AND check_user_per_line2(b.line_cd, b.cred_branch, ''GIPIS206'', '''
                       || p_user_id 
                       || ''') = 1
                          AND b.cred_branch = ''' 
                       || p_cred_branch 
                       || '''';
        ELSE               
          v_query := v_query ||
                        ' AND check_user_per_line2(b.line_cd, b.iss_cd, ''GIPIS206'', '''
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
     
      v_query := v_column || v_query || ') ORDER BY (SELECT eff_date
                                                       FROM gipi_polbasic
                                                      WHERE gipi_polbasic.policy_id = a.policy_id) DESC';    
      
      OPEN c FOR v_query;
      
      LOOP
        FETCH c
          INTO v_policy_id, v_item_no, v_plate_no, v_serial_no;
          EXIT WHEN c%NOTFOUND;
          
        v_row.policy_no := get_policy_no(v_policy_id);
        
         FOR d IN (SELECT A.assd_name
                     FROM GIIS_ASSURED A,
                          GIPI_POLBASIC b,
                          GIPI_PARLIST c
                    WHERE b.par_id = c.par_id
                      AND c.assd_no = A.assd_no
                      AND b.policy_id = v_policy_id)
         LOOP
             v_row.assured := d.assd_name;
            EXIT;
         END LOOP;     
         
         FOR d IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM GIPI_POLBASIC
                    WHERE policy_id = v_policy_id)
         LOOP 
            FOR E IN (SELECT MAX(eff_date) max_date
                         FROM GIPI_POLBASIC
                        WHERE line_cd = d.line_cd
                          AND subline_cd = d.subline_cd
                          AND iss_cd = d.iss_cd
                          AND issue_yy = d.issue_yy
                          AND pol_seq_no = d.pol_seq_no
                          AND renew_no = d.renew_no)
            LOOP
                   v_max_eff_date := E.max_date;
               
                   FOR f IN (SELECT incept_date
                               FROM GIPI_POLBASIC
                              WHERE line_cd = d.line_cd
                            AND subline_cd = d.subline_cd
                            AND iss_cd = d.iss_cd
                            AND issue_yy = d.issue_yy
                            AND pol_seq_no = d.pol_seq_no
                            AND renew_no = d.renew_no
                            AND eff_date LIKE TO_DATE(v_max_eff_date))
               LOOP
                  v_row.incept_date := TO_CHAR(f.incept_date, 'mm-dd-yyyy');
                END LOOP;
                
            END LOOP;
            
            FOR f IN (SELECT MAX(A.endt_seq_no) endt_no
                        FROM GIPI_POLBASIC A,
                             GIPI_VEHICLE b
                       WHERE A.line_cd = d.line_cd
                         AND A.subline_cd = d.subline_cd
                         AND A.iss_cd = d.iss_cd
                         AND A.issue_yy = d.issue_yy
                         AND A.pol_seq_no = d.pol_seq_no
                         AND A.renew_no = d.renew_no
                         AND A.policy_id = b.policy_id
                         AND b.item_no = v_item_no)
            LOOP
            v_max_endt_seq_no := f.endt_no;
                 FOR g IN (SELECT m.car_company || ' ' || k.make co_make
                              FROM GIPI_POLBASIC a,
                                   GIPI_VEHICLE b,
                                   GIIS_MC_MAKE k,
                                   GIIS_MC_CAR_COMPANY m
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
                        FOR e IN REVERSE 0..v_max_endt_seq_no 
                        LOOP
                              IF g.co_make IS NOT NULL THEN
                                  v_row.company_make := g.co_make;
                              END IF;
                        END LOOP;
                     END LOOP;             
            END LOOP;

            
                FOR c IN (SELECT SUM(prem_amt) ctpl_amt
                        FROM GIPI_ITMPERIL A,
                             GIIS_PARAMETERS b 
                          WHERE item_no = v_item_no
                          AND A.peril_cd = b.param_value_n
                          AND b.param_name = 'CTPL'
                          AND policy_id IN (SELECT policy_id
                                             FROM GIPI_POLBASIC
                                                        WHERE line_cd = d.line_cd
                                                           AND subline_cd = d.subline_cd
                                                           AND iss_cd = d.iss_cd
                                                           AND issue_yy = d.issue_yy
                                                           AND pol_seq_no = d.pol_seq_no
                                                            AND renew_no = d.renew_no))
            LOOP
                v_row.ctpl_premium := NVL(TRIM(TO_CHAR(c.ctpl_amt,'999,999,999,999,999,990.00')),'0.00');
            END LOOP;
            
         END LOOP;    
          v_row.plate_no := v_plate_no;
      v_row.serial_no := v_serial_no;
      
         PIPE ROW(v_row);        
      END LOOP;     
      
      CLOSE c;
   END get_gipir206; 
    --Added by Carlo Rubenecia SR-5328 06.22.2016  -- END 
END;
/