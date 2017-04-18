CREATE OR REPLACE PACKAGE BODY CPI.GIPIS192_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.16.2013
 * Reference By: GIPIS192 - Policy Listing per Make
 * Modified By : Gzelle 07112014 - get_gipis192_table
*/
   FUNCTION get_make_lov(
        p_make_cd       VARCHAR2,
        p_company_cd    VARCHAR2
   )
    RETURN make_lov_tab PIPELINED
   IS
      v_list   make_lov_type;
   BEGIN
    IF p_make_cd IS NULL THEN
      FOR i IN (
         SELECT DISTINCT a.make, a.make_cd,b.car_company_cd,b.car_company
           FROM gipi_vehicle a, giis_mc_car_company b
          WHERE a.car_company_cd = b.car_company_cd
            AND b.car_company_cd = NVL(p_company_cd,b.car_company_cd)
          ORDER BY make_cd
      )
      LOOP
         v_list.make_cd         := i.make_cd;       
         v_list.make            := i.make;          
         v_list.car_company_cd  := i.car_company_cd;
         v_list.car_company     := i.car_company;
         
         PIPE ROW (v_list);
      END LOOP;
      
    ELSE   
      FOR i IN (
         SELECT DISTINCT a.make, a.make_cd,b.car_company_cd,b.car_company
           FROM gipi_vehicle a, giis_mc_car_company b
          WHERE a.car_company_cd = b.car_company_cd
            AND b.car_company_cd = NVL(p_company_cd,b.car_company_cd)
            AND a.make_cd = NVL(p_make_cd, a.make_cd)
          ORDER BY make_cd
      )
      LOOP
         v_list.make_cd         := i.make_cd;       
         v_list.make            := i.make;          
         v_list.car_company_cd  := i.car_company_cd;
         v_list.car_company     := i.car_company;   
         
         PIPE ROW (v_list);
      END LOOP;
      
    END IF;
      RETURN;
   END get_make_lov;
   
   FUNCTION get_company_lov
    RETURN company_lov_tab PIPELINED
    IS
      v_list   company_lov_type;
    BEGIN
      FOR i IN (
         SELECT DISTINCT car_company_cd, car_company
           FROM  giis_mc_car_company 
          ORDER BY car_company_cd
      )
      LOOP
         v_list.car_company_cd  := i.car_company_cd;
         v_list.car_company     := i.car_company;
         
         PIPE ROW (v_list);
      END LOOP;
      
      RETURN;
   END get_company_lov;

   PROCEDURE validate_gipis192_make_cd(
       p_make_cd    IN OUT VARCHAR2,
       p_make       IN OUT VARCHAR2,
       p_company_cd IN OUT VARCHAR2,
       p_company    IN OUT VARCHAR2
   )
   IS
   BEGIN
       SELECT DISTINCT a.make_cd, a.make ,b.car_company_cd,b.car_company
         INTO p_make_cd, p_make, p_company_cd, p_company
         FROM gipi_vehicle a, giis_mc_car_company b
        WHERE a.car_company_cd = b.car_company_cd
          AND UPPER(a.make_cd) LIKE UPPER(p_make_cd);
   EXCEPTION
         WHEN OTHERS THEN
           p_make       := NULL;
           p_make_cd    := NULL;
           p_company_cd :=NULL;
           p_company    :=NULL;
   END;
   
   PROCEDURE validate_gipis192_company_cd(
       p_company_cd IN OUT VARCHAR2,
       p_company    IN OUT VARCHAR2
   )
   IS
   BEGIN
         SELECT DISTINCT car_company_cd, car_company
           INTO p_company_cd, p_company
           FROM  giis_mc_car_company 
          WHERE UPPER(car_company) LIKE UPPER(p_company);          
   EXCEPTION
         WHEN OTHERS THEN
           p_company_cd :=NULL;
           p_company    :=NULL;
   END;
    
   
   FUNCTION get_gipis192_table(
       p_make_cd               VARCHAR2,
       p_company_cd            VARCHAR2,
       p_search_by             VARCHAR2,
       p_as_of_date            VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2,
       p_user                  VARCHAR2,
       p_cred_branch           VARCHAR2
   )
   RETURN gipis192_table_tab PIPELINED
   IS
        TYPE cur_type IS REF CURSOR;
        TYPE tot_type IS REF CURSOR;
        
        v_list          gipis192_table_type;
        rec             cur_type;
        total           tot_type;
        v_query         VARCHAR2 (32767);
        v_tot_query     VARCHAR2 (32767);
        v_column        VARCHAR2 (3200);
        v_search        VARCHAR2 (32767);
        v_temp_prem     NUMBER := 0;
        v_temp_tsi      NUMBER := 0;
   BEGIN
       v_column := 'SELECT DISTINCT b.item_no, b.policy_id, b.item_title, b.tsi_amt,b.prem_amt, a.motor_no, a.serial_no, a.plate_no,
                                    c.assd_no, c.incept_date, c.eff_date, c.expiry_date, c.issue_date, a.make_cd, a.car_company_cd ';
                                    
       v_query :=  '  FROM gipi_vehicle a, gipi_item b, GIPI_POLBASIC c 
                     WHERE a.policy_id = b.policy_id
                       AND b.policy_id = c.policy_id
                       AND a.item_no = b.item_no
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
          IF check_user_per_iss_cd2 (NULL, p_cred_branch, 'GIPIS192', p_user) = 1 THEN
             v_search :=
                   v_search || ' WHERE check_user_per_iss_cd2(LINE_CD,cred_branch,''GIPIS192'', ''' || p_user || ''' )=1
                                           AND cred_branch = ''' || p_cred_branch || ''' )';
          ELSE
             v_search :=
                   v_search
                || ' WHERE check_user_per_iss_cd2(LINE_CD,iss_cd,''GIPIS192'', '''
                || p_user
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
             || p_user
             || ''')=1
                                        OR (check_user_per_iss_cd2(LINE_CD,cred_branch,''GIPIS192'', '''
             || p_user
             || ''')=1
                                        AND cred_branch IS NOT NULL) 
                                     ))';
       END IF;
       
       /*Get total TSI and Premium amounts*/
       v_tot_query := 'SELECT DISTINCT SUM(b.tsi_amt) total_tsi_amt, SUM(b.prem_amt) total_prem_amt ' ||v_query || ' ' || v_search;
       
       OPEN total FOR v_tot_query;
       
       LOOP
            FETCH total
             INTO v_temp_tsi, v_temp_prem;
            
            EXIT WHEN total%NOTFOUND;
       END LOOP;

       /*Get records*/
       v_query := v_column || ' ' ||v_query || ' ' || v_search;  
       
       OPEN rec FOR v_query;

        LOOP
            FETCH rec    
             INTO v_list.item_no, v_list.policy_id, v_list.item_title, v_list.tsi_amt, v_list.prem_amt, v_list.motor_no, v_list.serial_no, v_list.plate_no,
                  v_list.assd_no, v_list.incept_date, v_list.eff_date, v_list.expiry_date, v_list.issue_date, v_list.make_cd, v_list.company_cd;
                 
            FOR j IN (
                    SELECT DISTINCT  cred_branch
                      FROM gipi_polbasic a, gipi_vehicle b 
                     WHERE a.policy_id = b.policy_id
                       AND iss_cd IS NOT NULL
                       AND b.policy_id = v_list.policy_id
                 )
             LOOP
                v_list.iss_cd       := j.cred_branch;
             END LOOP;
             
            v_list.assd_name      := GET_ASSD_NAME(v_list.assd_no); 
            v_list.policy_no      := GET_POLICY_NO(v_list.policy_id);
            v_list.total_tsi_amt  := v_temp_tsi;
            v_list.total_prem_amt := v_temp_prem;
            
            EXIT WHEN rec%NOTFOUND;
            
            PIPE ROW(v_list);
        END LOOP;       
   
       /* IF p_make_cd IS NOT NULL THEN     commented out by Gzelle 07112014 replaced with codes above
              FOR i IN (SELECT DISTINCT b.policy_id, b.item_no, b.item_title, a.plate_no, a.motor_no, a.serial_no, b.tsi_amt,b.prem_amt,
                                         c.assd_no, c.incept_date, c.eff_date, c.expiry_date, c.issue_date,
                                         a.make, a.make_cd, a.car_company_cd
                          FROM gipi_vehicle a, gipi_item b, GIPI_POLBASIC c
                         WHERE a.policy_id = b.policy_id
                           AND b.policy_id = c.policy_id
                           AND a.policy_id IN (SELECT policy_id FROM gipi_polbasic where check_user_per_iss_cd2(line_cd, iss_cd, 'GIPIS192',p_user)=1 OR check_user_per_iss_cd2(line_cd, cred_branch, 'GIPIS192',p_user)=1)
                           AND a.item_no = b.item_no
                           AND a.make_cd = p_make_cd
                           AND a.car_company_cd = p_company_cd
                           AND (DECODE(p_search_by, 1, c.incept_date,
                                                    2, c.eff_date,
                                                    3, c.issue_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY')
                                AND DECODE(p_search_by, 1, c.incept_date,
                                                         2, c.eff_date,
                                                         3, c.issue_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY')
                                OR DECODE(p_search_by, 1, c.incept_date,
                                                        2, c.eff_date,
                                                        3, c.issue_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                       )
              LOOP
                 v_list.policy_id      := i.policy_id;
                 v_list.policy_no      := GET_POLICY_NO(i.policy_id);
                 v_list.item_no        := i.item_no;
                 v_list.item_title     := i.item_title; 
                 v_list.plate_no       := i.plate_no;
                 v_list.motor_no       := i.motor_no;
                 v_list.serial_no      := i.serial_no;
                 v_list.tsi_amt        := i.tsi_amt; 
                 v_list.prem_amt       := i.prem_amt;
                 v_list.assd_no        := i.assd_no;
                 v_list.assd_name      := GET_ASSD_NAME(i.assd_no); 
                 v_list.incept_date    := i.incept_date;
                 v_list.eff_date       := i.eff_date;
                 v_list.expiry_date    := i.expiry_date;
                 v_list.issue_date     := i.issue_date;
                 v_list.make_cd        := i.make_cd;
                 v_list.company_cd     := i.car_company_cd;

                 FOR j IN (
                    SELECT distinct  cred_branch
                      FROM gipi_polbasic a, gipi_vehicle b 
                     WHERE a.policy_id = b.policy_id
                       AND iss_cd IS NOT NULL
                       AND b.policy_id = i.policy_id
                 )
                 LOOP
                    v_list.iss_cd       := j.cred_branch;
                    
                 END LOOP;   
                    
                PIPE ROW (v_list);
              END LOOP;
              
       ELSE
              FOR i IN (SELECT DISTINCT b.policy_id, b.item_no, b.item_title, a.plate_no, a.motor_no, a.serial_no, b.tsi_amt,b.prem_amt,
                                         c.assd_no, c.incept_date, c.eff_date, c.expiry_date, c.issue_date,
                                         a.make, a.make_cd, a.car_company_cd
                          FROM gipi_vehicle a, gipi_item b, GIPI_POLBASIC c
                         WHERE a.policy_id = b.policy_id
                           AND b.policy_id = c.policy_id 
                           AND a.item_no = b.item_no
                           AND a.policy_id IN (SELECT policy_id FROM gipi_polbasic where check_user_per_iss_cd2(line_cd, iss_cd, 'GIPIS192',p_user)=1 OR check_user_per_iss_cd2(line_cd, cred_branch, 'GIPIS192',p_user)=1)
                           AND a.car_company_cd = p_company_cd
                           AND a.make_cd IS NULL
                           AND (DECODE(p_search_by, 1, c.incept_date,
                                                    2, c.eff_date,
                                                    3, c.issue_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY')
                                AND DECODE(p_search_by, 1, c.incept_date,
                                                         2, c.eff_date,
                                                         3, c.issue_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY')
                                OR DECODE(p_search_by, 1, c.incept_date,
                                                        2, c.eff_date,
                                                        3, c.issue_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                       )
              LOOP
                 v_list.policy_id      := i.policy_id;
                 v_list.policy_no      := GET_POLICY_NO(i.policy_id);
                 v_list.item_no        := i.item_no;
                 v_list.item_title     := i.item_title; 
                 v_list.plate_no       := i.plate_no;
                 v_list.motor_no       := i.motor_no;
                 v_list.serial_no      := i.serial_no;
                 v_list.tsi_amt        := i.tsi_amt; 
                 v_list.prem_amt       := i.prem_amt;
                 v_list.assd_no        := i.assd_no;
                 v_list.assd_name      := GET_ASSD_NAME(i.assd_no); 
                 v_list.incept_date    := i.incept_date;
                 v_list.eff_date       := i.eff_date;
                 v_list.expiry_date    := i.expiry_date;
                 v_list.issue_date     := i.issue_date;
                 
                 FOR j IN (
                    SELECT distinct  cred_branch
                      FROM gipi_polbasic a, gipi_vehicle b 
                     WHERE a.policy_id = b.policy_id
                       AND iss_cd IS NOT NULL
                       AND b.policy_id = i.policy_id
                 )
                 LOOP
                    v_list.iss_cd       := j.cred_branch;
                    
                 END LOOP;

                PIPE ROW (v_list);
              END LOOP;
       END IF;
      RETURN; */
   END;
END;
/


