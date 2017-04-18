CREATE OR REPLACE PACKAGE BODY CPI.GIPIR194_PKG
AS 
   FUNCTION get_gipir194_details(
      p_mot_type     gipi_vehicle.mot_type%TYPE,
      p_subline_cd   gipi_vehicle.subline_cd%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_type    VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   ) RETURN gipir194_tab PIPELINED AS
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
    
        v_query := 'SELECT   a.item_title, b.plate_no, b.motor_no, b.serial_no, c.assd_no,
                             NVL(a.tsi_amt,0.00) tsi_amt, NVL(a.prem_amt,0.00) prem_amt,
                             c.policy_id, b.mot_type, b.subline_cd, get_policy_no (a.policy_id) policy_no,
                             c.incept_date, c.expiry_date, d.motor_type_desc motor_type, e.assd_name
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
            
        v_query := v_query || ' ' || v_search;
        
        
        OPEN c FOR v_query;
        
        LOOP
            FETCH c    
              INTO rec.item_title, rec.plate_no, rec.motor_no, rec.serial_no, rec.assd_no,
                   rec.tsi_amt, rec.prem_amt, rec.policy_id, rec.mot_type, rec.subline_cd, rec.policy_no,
                   rec.incept_date, rec.expiry_date, rec.motor_type, rec.assd_name;
            
            EXIT WHEN c%NOTFOUND;  
            
            rec.company_name := giisp.v('COMPANY_NAME');
            rec.company_address := giisp.v('COMPANY_ADDRESS'); 
              
            PIPE ROW(rec);
        END LOOP;
        CLOSE c;
   END;              
END;
/
