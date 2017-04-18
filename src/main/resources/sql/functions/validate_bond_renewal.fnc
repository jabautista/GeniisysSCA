DROP FUNCTION CPI.VALIDATE_BOND_RENEWAL;

CREATE OR REPLACE FUNCTION CPI.validate_bond_renewal (p_line_cd VARCHAR2, p_binder_yy NUMBER, p_binder_seq_no NUMBER,
                                                  p_valid OUT VARCHAR2, p_old_fnl_binder_id OUT NUMBER, p_fnl_binder_id OUT NUMBER)
RETURN NUMBER IS

/* created by: Paul 4.12.11
   function Returns VALID = 'Y' and the original and endorsement Binder ID when binder has an endorsement 
   and both the number of days between incept to expiry and effective to endorsement expiry is equal.
   (return 1 when data found else return 0)
*/    

v_line_cd           VARCHAR2(20);
v_frps_yy           NUMBER(2);
v_frps_seq_no       NUMBER(10);
v_ri_cd             NUMBER(5);  -- added: 4.18.11

v_dist_no           NUMBER(10);

v_subline_cd        VARCHAR2(20);
v_iss_cd            VARCHAR2(20);
v_issue_yy          NUMBER(2);
v_pol_seq_no        NUMBER(10);
v_renew_no          NUMBER(2); -- added: 4.19.11

v_incept_date       DATE;
v_expiry_date       DATE;
v_eff_date          DATE;
v_endt_expiry_date  DATE;
v_endt_seq_no       NUMBER(10);

v_orig_policy_id    NUMBER(10);
v_endt_policy_id    NUMBER(10);

v_orig_binder_id    NUMBER(10); -- added: 4.19.11
v_endt_binder_id    NUMBER(10); -- added: 4.19.11

TYPE va_number IS varray(2) of NUMBER(10);   -- type of array
v_policy_ids        va_number;               -- array of policy_ids

v_valid             CHAR;
v_binder_ids        va_number;               -- array of binders

BEGIN
    -- check if binder has values
    SELECT b.line_cd, b.frps_yy, b.frps_seq_no, b.ri_cd, a.fnl_binder_id
      INTO v_line_cd, v_frps_yy, v_frps_seq_no, v_ri_cd, v_endt_binder_id -- ri_cd, binder_id: 4.19.11
      FROM giri_binder a,
           giri_frps_ri b
     WHERE a.fnl_binder_id  = b.fnl_binder_id
       AND a.line_cd        = p_line_cd
       AND a.binder_yy      = p_binder_yy
       AND a.binder_seq_no  = p_binder_seq_no;
       
     IF v_line_cd IS NOT NULL AND v_frps_yy IS NOT NULL and v_frps_seq_no IS NOT NULL THEN
        -- get dist_no of binder based on binder values
        SELECT dist_no
          INTO v_dist_no
          FROM giri_distfrps a,
               giri_frps_ri b
         WHERE a.line_cd = b.line_cd
           AND a.frps_yy = b.frps_yy
           AND a.frps_seq_no = b.frps_seq_no
           AND b.line_cd = v_line_cd
           AND b.frps_yy = v_frps_yy
           AND b.frps_seq_no = v_frps_seq_no
           AND b.ri_cd = v_ri_cd                    -- 4.18.11
         GROUP BY dist_no;
      
           IF v_dist_no IS NOT NULL THEN
            -- get policy no of binder and check binder validity based on no. of days
            SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no, b.incept_date, b.expiry_date, b.eff_date, b.endt_expiry_date, b.endt_seq_no
              INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_incept_date, v_expiry_date, v_eff_date, v_endt_expiry_date, v_endt_seq_no
              FROM giuw_pol_dist a,
                   gipi_polbasic b
             WHERE a.policy_id = b.policy_id
               AND a.dist_no = v_dist_no;
     
             IF (v_expiry_date - v_incept_date) = (v_endt_expiry_date - v_eff_date) AND v_expiry_date = v_eff_date THEN
 
                 IF v_line_cd IS NOT NULL AND v_subline_cd IS NOT NULL and v_iss_cd IS NOT NULL AND v_issue_yy IS NOT NULL AND 
                    v_pol_seq_no IS NOT NULL AND v_renew_no IS NOT NULL THEN  -- added renew no 4.19.11
                   
                    --get policy_id of the original
                    SELECT policy_id
                      INTO v_orig_policy_id
                      FROM gipi_polbasic
                     WHERE line_cd      = v_line_cd
                       AND subline_cd   = v_subline_cd
                       AND iss_cd       = v_iss_cd
                       AND issue_yy     = v_issue_yy
                       AND pol_seq_no   = v_pol_seq_no
                       AND renew_no     = v_renew_no
                       AND endt_seq_no  = 0;            -- original policy
 
                    -- get Distribution No of original policy
                    SELECT dist_no
                      INTO v_dist_no
                      FROM giuw_pol_dist a,
                           gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND b.policy_id = v_orig_policy_id;
                           
                    -- get line_cd, frps_yy, frps_seq_no, of original policy
                    SELECT line_cd, frps_yy, frps_seq_no
                      INTO v_line_cd, v_frps_yy, v_frps_seq_no
                      FROM giri_distfrps a,
                           giuw_pol_dist b
                     WHERE a.dist_no = b.dist_no
                       AND b.dist_no = v_dist_no;                           
                           
                    -- get final binder id of original policy
                    SELECT a.fnl_binder_id
                      INTO v_orig_binder_id
                      FROM giri_binder a,
                           giri_frps_ri b
                     WHERE a.fnl_binder_id = b.fnl_binder_id
                       AND b.ri_cd = v_ri_cd                    -- variable ri_cd : 4.18.11
                       AND b.line_cd = v_line_cd
                       AND b.frps_yy = v_frps_yy
                       AND b.frps_seq_no = v_frps_seq_no;
                
                    p_valid := 'Y';
                    p_old_fnl_binder_id := v_orig_binder_id; -- original binder id
                    p_fnl_binder_id     := v_endt_binder_id; -- endorsement binder id
                    
                 END IF;
                  
             ELSE
                 p_valid := 'N'; 
                 p_old_fnl_binder_id := 0;
                 p_fnl_binder_id     := 0; 
             END IF;
           
           ELSE
            p_valid := 'N';
            p_old_fnl_binder_id := 0;
            p_fnl_binder_id     := 0;             
           END IF;
           
     ELSE
     p_valid := 'N';
     p_old_fnl_binder_id := 0;
     p_fnl_binder_id     := 0; 
     
     END IF;
    
    return 1;
    
EXCEPTION WHEN no_data_found THEN
    p_valid := 'N';
    p_old_fnl_binder_id := 0;
    p_fnl_binder_id     := 0;      
    return 0;

END;
/


