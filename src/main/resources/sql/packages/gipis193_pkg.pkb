CREATE OR REPLACE PACKAGE BODY CPI.GIPIS193_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   10.10.2013
     ** Referenced By:  GIPIS193 - View Policy Listing per Plate
     **/
     
    FUNCTION get_vehicle_item_listing(
        p_plate_no      GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_user_id       VARCHAR2
    ) RETURN item_tab PIPELINED
    AS
        TYPE cur_type IS REF CURSOR;
        
        rec             item_type;
        custom          cur_type;
        v_query         VARCHAR2(32767);
        v_search        VARCHAR2(32767);
        v_as_of_date    DATE;
        v_from_date     DATE;
        v_to_date       DATE;
    BEGIN
        v_as_of_date    := NVL(TO_DATE(p_as_of_date, 'MM-DD-RRRR'), null); --SYSDATE);
        v_from_date     := NVL(TO_DATE(p_from_date, 'MM-DD-RRRR'), null);
        v_to_date       := NVL(TO_DATE(p_to_date, 'MM-DD-RRRR'), null);
    
        v_query := 'SELECT a.item_no, a.policy_id, a.item_title, a.tsi_amt, a.prem_amt, b.motor_no, b.serial_no, b.plate_no, b.make, c.line_cd, c.iss_cd,
                        c.cred_branch, c.line_cd || ''-'' || c.subline_cd || ''-'' || c.iss_cd || ''-'' || LTRIM(TO_CHAR(c.issue_yy,''09'')) || ''-'' 
                            || LTRIM(TO_CHAR(c.pol_seq_no,''0000009'')) || ''-'' || LTRIM(TO_CHAR(c.renew_no,''09''))  POLICY_NO,
                            c.assd_no, c.expiry_date, c.incept_date, c.eff_date, c.issue_date
                      FROM gipi_item a, 
                           gipi_vehicle b, gipi_polbasic c
                     WHERE a.policy_id = b.policy_id 
                       AND a.item_no = b.item_no
                       --AND b.plate_no IS NOT NULL                    
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
            
        v_query := v_query || ' ' || v_search;
        
        
        OPEN custom FOR v_query;
        
        LOOP
            FETCH custom    
              INTO rec.item_no, rec.policy_id, rec.item_title, rec.tsi_amt, rec.prem_amt, rec.motor_no, rec.serial_no, rec.plate_no, rec.make, rec.line_cd, rec.iss_cd,
              rec.cred_branch,rec.policy_no, rec.assd_no, rec.expiry_date, rec.incept_date, rec.eff_date, rec.issue_date; 
              
            rec.assd_name := NULL;

            FOR a IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = rec.assd_no)
            LOOP
              rec.assd_name := a.assd_name;
            END LOOP;
            
            EXIT WHEN custom%NOTFOUND;   
              
            PIPE ROW(rec);
        END LOOP;
        
    END get_vehicle_item_listing;
    
    
    PROCEDURE get_vehicle_item_totals(
        p_plate_no      IN  GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   IN  GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     IN  VARCHAR2,
        p_as_of_date    IN  VARCHAR2,
        p_from_date     IN  VARCHAR2,
        p_to_date       IN  VARCHAR2,
        p_user_id       IN  VARCHAR2,
        p_sum_tsi_amt   OUT NUMBER,
        p_sum_prem_amt  OUT NUMBER
    )
    AS
    BEGIN
        SELECT sum(tsi_amt), sum(prem_amt)
          INTO p_sum_tsi_amt, p_sum_prem_amt
          FROM TABLE(GIPIS193_PKG.GET_VEHICLE_ITEM_LISTING(p_plate_no, p_cred_branch, p_date_type, p_as_of_date, p_from_date, p_to_date, p_user_id));
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_sum_tsi_amt   := 0;
            p_sum_prem_amt  := 0;
    END get_vehicle_item_totals;
END GIPIS193_PKG;
/


