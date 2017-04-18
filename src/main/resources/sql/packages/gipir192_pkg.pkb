CREATE OR REPLACE PACKAGE BODY CPI.GIPIR192_PKG
AS
    /**
     ** Modified by : Gzelle  - SR5324 - to consider other report parameters
    **/
   FUNCTION get_gipir192_table(
       p_make_cd               VARCHAR2,
       p_company_cd            VARCHAR2,
       p_search_by             VARCHAR2,
       p_as_of_date            VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2,
       p_user_id               VARCHAR2,
       p_cred_branch           VARCHAR2
   )
   RETURN gipir192_table_tab PIPELINED
   IS
        TYPE cur_type IS REF CURSOR;
        
        v_list          gipir192_table_type;
        rec             cur_type;
        v_query         VARCHAR2 (32767);
        v_column        VARCHAR2 (3200);
        v_search        VARCHAR2 (32767);
   BEGIN
       v_column := 'SELECT DISTINCT b.policy_id, b.item_no, b.item_title, a.plate_no, a.motor_no, a.serial_no, c.assd_no,
                                    get_assd_name(c.assd_no) assd_name, b.tsi_amt, b.prem_amt, get_policy_no(b.policy_id),
                                    c.incept_date, c.expiry_date, make_cd ||'' - ''|| make make, d.car_company company';
                                    
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
             INTO v_list.policy_id, v_list.item_no, v_list.item_title, v_list.plate_no, v_list.motor_no, v_list.serial_no, 
                  v_list.assd_no, v_list.assd_name, v_list.tsi_amt, v_list.prem_amt, v_list.policy_no, v_list.incept_date,
                  v_list.expiry_date, v_list.make, v_list.company;
            
            EXIT WHEN rec%NOTFOUND;
            
            PIPE ROW(v_list);
        END LOOP;   
   END;
   
   FUNCTION get_gipir192_header
        RETURN gipir192_header_tab PIPELINED
    IS
        v_list gipir192_header_type;
    BEGIN
        select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
        select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
        
        PIPE ROW(v_list);
        RETURN;
    END get_gipir192_header;
END;
/


