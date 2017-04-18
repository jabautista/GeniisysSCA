DROP PROCEDURE CPI.POPULATE_PERSONNELS;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_PERSONNELS(
    p_item_no       IN  NUMBER,
    p_old_pol_id    IN  gipi_polbasic.policy_id%TYPE,
    p_new_par_id    IN  gipi_wcasualty_personnel.par_id%TYPE
)
IS
  v_line_cd               gipi_polbasic.line_cd%TYPE;     -- line_cd of policy/endt with certain district/block
  v_subline_cd            gipi_polbasic.subline_cd%TYPE;  -- subline_cd of policy/endt with certain district/block
  v_iss_cd                gipi_polbasic.iss_cd%TYPE;      -- iss_cd of policy/endt with certain district/block
  v_issue_yy              gipi_polbasic.issue_yy%TYPE;    -- issue_yy of policy/endt with certain district/block
  v_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE;  -- pol_seq_no of policy/endt with certain district/block
  v_renew_no              gipi_polbasic.renew_no%TYPE;    -- renew_no of policy/endt with certain district/block
  v_personnel_no          gipi_wcasualty_personnel.personnel_no%TYPE;
  v_name                  gipi_wcasualty_personnel.name%TYPE;
  v_include_tag           gipi_wcasualty_personnel.include_tag%TYPE;
  v_capacity_cd           gipi_wcasualty_personnel.capacity_cd%TYPE;
  v_amount_covered        gipi_wcasualty_personnel.amount_covered%TYPE;
  v_remarks               gipi_wcasualty_personnel.remarks%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_PERSONNELS program unit 
  */
    -- the ff. selects the line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
    -- of the policy being processed for expiry 
    FOR A IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                FROM gipi_polbasic
               WHERE policy_id = p_old_pol_id)
  LOOP
    v_line_cd       := a.line_cd;
    v_subline_cd    := a.subline_cd;
    v_iss_cd        := a.iss_cd;
    v_issue_yy      := a.issue_yy;
    v_pol_seq_no    := a.pol_seq_no;
    v_renew_no      := a.renew_no;
    --v_sw            := 'Y';
    EXIT;
  END LOOP;
  
  -- cas FOR LOOP selects all personnel_no per item_no of the above policy together 
  -- with its endorsemet/s
  FOR cas IN (SELECT DISTINCT y.personnel_no
                FROM gipi_polbasic x,
                     gipi_casualty_personnel y
               WHERE x.line_cd    = v_line_cd
                 AND x.subline_cd = v_subline_cd
                 AND x.iss_cd     = v_iss_cd
                 AND x.issue_yy   = v_issue_yy
                 AND x.pol_seq_no = v_pol_seq_no
                 AND x.renew_no   = v_renew_no
                 AND x.pol_flag IN ('1','2','3')
                 AND x.policy_id  = y.policy_id
                 AND y.item_no    = p_item_no)
  LOOP
      v_personnel_no    := cas.personnel_no;
    
    -- selects the latest grouped_item_title, include_tag, line_cd, subline_cd               
      FOR data IN (SELECT y.name  ,y.include_tag 
                   FROM gipi_polbasic x,
                        gipi_casualty_personnel y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_casualty_personnel n
                                    WHERE m.line_cd = v_line_cd
                                      AND m.subline_cd = v_subline_cd
                                      AND m.iss_cd     = v_iss_cd
                                      AND m.issue_yy   = v_issue_yy
                                      AND m.pol_seq_no = v_pol_seq_no
                                      AND m.renew_no   = v_renew_no
                                      AND m.pol_flag IN ('1','2','3')
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.personnel_no = v_personnel_no
                                      AND n.name IS NOT NULL )
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.personnel_no = v_personnel_no
                    AND y.name IS NOT NULL 
               ORDER BY x.eff_date DESC)
    LOOP
      v_name        := data.name;
      v_include_tag := data.include_tag;
      EXIT;
    END LOOP;
    
    -- selects the latest remarks
    FOR remk IN (SELECT y.remarks
                   FROM gipi_polbasic x,
                        gipi_casualty_personnel y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_casualty_personnel n
                                    WHERE m.line_cd = v_line_cd
                                      AND m.subline_cd = v_subline_cd
                                      AND m.iss_cd     = v_iss_cd
                                      AND m.issue_yy   = v_issue_yy
                                      AND m.pol_seq_no = v_pol_seq_no
                                      AND m.renew_no   = v_renew_no
                                      AND m.pol_flag IN ('1','2','3')
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.personnel_no = v_personnel_no
                                      AND n.remarks IS NOT NULL )
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.personnel_no = v_personnel_no
                    AND y.remarks IS NOT NULL 
               ORDER BY x.eff_date DESC)
    LOOP
      v_remarks := remk.remarks;
      EXIT;
    END LOOP;
    
        -- selects the latest gender
        FOR cap  IN (SELECT y.capacity_cd
                   FROM gipi_polbasic x,
                        gipi_casualty_personnel y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_casualty_personnel n
                                    WHERE m.line_cd = v_line_cd
                                      AND m.subline_cd = v_subline_cd
                                      AND m.iss_cd     = v_iss_cd
                                      AND m.issue_yy   = v_issue_yy
                                      AND m.pol_seq_no = v_pol_seq_no
                                      AND m.renew_no   = v_renew_no
                                      AND m.pol_flag IN ('1','2','3')
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.personnel_no = v_personnel_no
                                      AND n.capacity_cd IS NOT NULL )
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.personnel_no = v_personnel_no
                    AND y.capacity_cd IS NOT NULL 
               ORDER BY x.eff_date DESC)
    LOOP
      v_capacity_cd := cap.capacity_cd;
      EXIT;
    END LOOP;
    
    -- selects the sum of the amount coverage of all acceptable policy and endorsement/s
        FOR amt  IN (SELECT SUM(y.amount_covered) amt_covered
                   FROM gipi_polbasic x,
                        gipi_casualty_personnel y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_casualty_personnel n
                                    WHERE m.line_cd = v_line_cd
                                      AND m.subline_cd = v_subline_cd
                                      AND m.iss_cd     = v_iss_cd
                                      AND m.issue_yy   = v_issue_yy
                                      AND m.pol_seq_no = v_pol_seq_no
                                      AND m.renew_no   = v_renew_no
                                      AND m.pol_flag IN ('1','2','3')
                                      AND m.endt_seq_no > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id  = n.policy_id
                                      AND n.item_no    = p_item_no
                                      AND n.personnel_no = v_personnel_no)
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.personnel_no = v_personnel_no
               ORDER BY x.eff_date DESC)
    LOOP
      v_amount_covered := amt.amt_covered;
      EXIT;
    END LOOP;    
      
    --CLEAR_MESSAGE;
    --MESSAGE('Copying personnel info ...',NO_ACKNOWLEDGE);
    --SYNCHRONIZE; 
    INSERT INTO gipi_wcasualty_personnel(
                par_id,        item_no,       personnel_no,     name, 
                include_tag,   capacity_cd,   amount_covered,   remarks)
         VALUES(p_new_par_id,  p_item_no,     v_personnel_no,   v_name, 
                v_include_tag, v_capacity_cd, v_amount_covered, v_remarks);  
  
    v_capacity_cd    := NULL;
    v_remarks        := NULL;                
  END LOOP;                 
    
END;
/


