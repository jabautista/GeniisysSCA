DROP PROCEDURE CPI.POPULATE_GROUP_ITEM;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_GROUP_ITEM (
    P_ITEM_NO           IN  NUMBER,
    p_old_pol_id        IN  gipi_polbasic.policy_id%TYPE,
    p_line_ac           IN  VARCHAR2,
    p_menu_line_cd      IN  VARCHAR2,
    p_new_par_id        IN  gipi_wgrouped_items.par_id%TYPE,
    p_line_ca           IN  VARCHAR2,
    p_proc_summary_sw   IN  VARCHAR2,
    p_msg              OUT  VARCHAR2
)
IS
  v_line_cd               gipi_polbasic.line_cd%TYPE;     -- line_cd of policy/endt with certain district/block
  v_subline_cd            gipi_polbasic.subline_cd%TYPE;  -- subline_cd of policy/endt with certain district/block
  v_iss_cd                gipi_polbasic.iss_cd%TYPE;      -- iss_cd of policy/endt with certain district/block
  v_issue_yy              gipi_polbasic.issue_yy%TYPE;    -- issue_yy of policy/endt with certain district/block
  v_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE;  -- pol_seq_no of policy/endt with certain district/block
  v_renew_no              gipi_polbasic.renew_no%TYPE;    -- renew_no of policy/endt with certain district/block
  v_grouped_item_no       gipi_wgrouped_items.grouped_item_no%TYPE;
  v_grouped_item_title    gipi_wgrouped_items.grouped_item_title%TYPE;
  v_amount_coverage       gipi_wgrouped_items.amount_covered%TYPE;
  v_include_tag           gipi_wgrouped_items.include_tag%TYPE;
  v_remarks               gipi_wgrouped_items.remarks%TYPE;
  v_sex                   gipi_wgrouped_items.sex%TYPE;
  v_position_cd           gipi_wgrouped_items.position_cd%TYPE;
  v_civil_status          gipi_wgrouped_items.civil_status%TYPE;
  v_date_of_birth         gipi_wgrouped_items.date_of_birth%TYPE;
  v_age                   gipi_wgrouped_items.age%TYPE;
  v_salary                gipi_wgrouped_items.salary%TYPE;
  v_salary_grade          gipi_wgrouped_items.salary_grade%TYPE;
  v_group_cd              gipi_wgrouped_items.group_cd%TYPE;
  v_delete_sw             gipi_wgrouped_items.delete_sw%TYPE;                            
  
  /*added by gmi.. new columns for gipi_grouped_items*/
  v_FROM_DATE             gipi_wgrouped_items.FROM_DATE%TYPE;
  v_TO_DATE               gipi_wgrouped_items.TO_DATE%TYPE;
  v_PAYT_TERMS            gipi_wgrouped_items.PAYT_TERMS%TYPE;                    
  v_PACK_BEN_CD           gipi_wgrouped_items.PACK_BEN_CD%TYPE;            
  v_ANN_TSI_AMT           gipi_wgrouped_items.ANN_TSI_AMT%TYPE;            
  v_ANN_PREM_AMT          gipi_wgrouped_items.ANN_PREM_AMT%TYPE;            
  v_CONTROL_CD            gipi_wgrouped_items.CONTROL_CD%TYPE;
  v_CONTROL_TYPE_CD       gipi_wgrouped_items.CONTROL_TYPE_CD%TYPE;            
  v_TSI_AMT               gipi_wgrouped_items.TSI_AMT%TYPE;    
  v_PREM_AMT              gipi_wgrouped_items.PREM_AMT%TYPE;                    
  v_PRINCIPAL_CD          gipi_wgrouped_items.PRINCIPAL_CD%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_GROUP_ITEM program unit 
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
  -- grp FOR LOOP selects all grouped_item_no per item_no of the above policy together 
  -- with its endorsemet/s
  FOR grp IN (SELECT DISTINCT y.grouped_item_no
                FROM gipi_polbasic x,
                     gipi_grouped_items y
               WHERE x.line_cd    = v_line_cd
                 AND x.subline_cd = v_subline_cd
                 AND x.iss_cd     = v_iss_cd
                 AND x.issue_yy   = v_issue_yy
                 AND x.pol_seq_no = v_pol_seq_no
                 AND x.renew_no   = v_renew_no                 
                 AND x.pol_flag IN ('1','2','3')
                 AND x.policy_id  = y.policy_id
                 AND y.item_no    = p_item_no
                 AND nvl(y.delete_sw,'N') != 'Y'
                 AND (x.endt_seq_no = 0 OR 
                                         (x.endt_seq_no > 0 AND 
                                          TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                        )-- added by gmi
                                )
  LOOP
      v_grouped_item_no    := grp.grouped_item_no;
      /*--modified by bdarusin, 021302
        --added FOR del loop to get the latest delete_sw of the item
        --if delete_sw = 'Y', it should no be included in the new PAR
      */
      FOR del IN (SELECT y.delete_sw
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
                                    WHERE m.line_cd         = v_line_cd
                                      AND m.subline_cd      = v_subline_cd
                                      AND m.iss_cd          = v_iss_cd
                                      AND m.issue_yy        = v_issue_yy
                                      AND m.pol_seq_no      = v_pol_seq_no
                                      AND m.renew_no        = v_renew_no
                                      AND m.pol_flag        IN ('1','2','3')
                                      AND m.endt_seq_no      > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id        = n.policy_id
                                      AND n.item_no          = p_item_no
                                      AND n.grouped_item_no  = v_grouped_item_no
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                )
                                      AND n.grouped_item_title IS NOT NULL)
                    AND x.policy_id       = y.policy_id
                    AND y.item_no         = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.grouped_item_title IS NOT NULL
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
          v_delete_sw := del.delete_sw;
          exit;
    END LOOP;
    
    IF nvl(v_delete_sw, 'N') = 'N' THEN-- if del sw
    -- selects the latest grouped_item_title, include_tag, line_cd, subline_cd               
      FOR data IN (SELECT y.grouped_item_title  ,y.include_tag,  x.line_cd,
                        x.subline_cd           
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
                                    WHERE m.line_cd         = v_line_cd
                                      AND m.subline_cd      = v_subline_cd
                                      AND m.iss_cd          = v_iss_cd
                                      AND m.issue_yy        = v_issue_yy
                                      AND m.pol_seq_no      = v_pol_seq_no
                                      AND m.renew_no        = v_renew_no
                                      AND m.pol_flag        IN ('1','2','3')
                                      AND m.endt_seq_no      > x.endt_seq_no
                                      AND NVL(m.back_stat,5) = 2
                                      AND m.policy_id        = n.policy_id
                                      AND n.item_no          = p_item_no
                                      AND n.grouped_item_no  = v_grouped_item_no
                                      AND n.grouped_item_title IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id       = y.policy_id
                    AND y.item_no         = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.grouped_item_title IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_grouped_item_title := data.grouped_item_title;
      v_include_tag        := data.include_tag;
      v_line_cd            := data.line_cd;
      v_subline_cd         := data.subline_cd;
      EXIT;
    END LOOP;
    
    -- selects the latest remarks
    FOR remk IN (SELECT y.remarks
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.remarks IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.remarks IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_remarks := remk.remarks;
      EXIT;
    END LOOP;    
    
        IF v_line_cd = p_line_ac OR p_menu_line_cd = 'AC' THEN
        -- selects the latest gender
        FOR sex  IN (SELECT y.sex
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.sex IS NOT NULL
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.sex IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_sex := sex.sex;
      EXIT;
    END LOOP;    
    
    -- selects the latest position_cd
    FOR pos  IN (SELECT y.position_cd
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.position_cd IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.position_cd IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_position_cd := pos.position_cd;
      EXIT;
    END LOOP;    
    
    -- selects the latest civil_status
    FOR stat IN (SELECT y.civil_status
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.civil_status IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.civil_status IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_civil_status := stat.civil_status;
      EXIT;
    END LOOP;
    
    -- selects the latest b-day
    FOR bday IN (SELECT y.date_of_birth
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.date_of_birth IS NOT NULL
                                      AND nvl(n.delete_sw,'N') != 'Y' 
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.date_of_birth IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_date_of_birth := bday.date_of_birth;
      EXIT;
    END LOOP;    
        
        -- selects the latest age
        FOR age  IN (SELECT y.age, y.date_of_birth
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.age IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.age IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_age :=  trunc(to_number(months_between(sysdate,age.date_of_birth))/12);
      EXIT;
    END LOOP;    
    
    -- selects the latest salary grade
    FOR salg IN (SELECT y.salary_grade
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.salary_grade IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.salary_grade IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_salary_grade := salg.salary_grade;
      EXIT;
    END LOOP;
    
    -- selects the latest salary
    FOR sal  IN (SELECT y.salary
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.salary IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.salary IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_salary := sal.salary;
      EXIT;
    END LOOP;
   
    END IF;   
    
    -- selects the latest group_cd
    FOR grpc IN (SELECT y.group_cd
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.group_cd IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.group_cd IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_group_cd := grpc.group_cd;
      EXIT;
    END LOOP;    
        
        -- selects the sum of the amount coverage of all acceptable policy and endorsement/s
        FOR amt  IN (SELECT SUM(y.amount_coverage) amt_covered,
                                                SUM(y.tsi_amt) tsi_amt,
                                                SUM(y.prem_amt) prem_amt,
                                                SUM(y.ann_tsi_amt) ann_tsi_amt,
                                                SUM(y.ann_prem_amt) ann_prem_amt
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
                  ORDER BY x.eff_date DESC)
    LOOP
      v_amount_coverage := amt.amt_covered;
      v_tsi_amt                 := amt.tsi_amt;
      v_prem_amt                 := amt.prem_amt;
      v_ann_tsi_amt         := amt.ann_tsi_amt;
      v_ann_prem_amt         := amt.ann_prem_amt;
      EXIT;
    END LOOP;    
    
    -- selects the latest [new columns added to gipi_grouped_items table]
    FOR addtl IN (SELECT y.FROM_DATE,          y.TO_DATE,         y.PAYT_TERMS, 
                        y.PACK_BEN_CD,        y.CONTROL_CD,      y.CONTROL_TYPE_CD,
                        y.PRINCIPAL_CD
                   FROM gipi_polbasic x,
                        gipi_grouped_items y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_grouped_items  n
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
                                      AND n.grouped_item_no = v_grouped_item_no
                                      AND n.group_cd IS NOT NULL 
                                      AND nvl(n.delete_sw,'N') != 'Y'
                                      AND (m.endt_seq_no = 0 OR 
                                                                                 (m.endt_seq_no > 0 AND 
                                                                                  TRUNC(NVL(n.to_date,m.endt_expiry_date)) >= TRUNC(m.expiry_date))
                                                                                ))
                    AND x.policy_id  = y.policy_id
                    AND y.item_no    = p_item_no
                    AND y.grouped_item_no = v_grouped_item_no
                    AND y.group_cd IS NOT NULL
                    AND nvl(y.delete_sw,'N') != 'Y'
                    AND (x.endt_seq_no = 0 OR 
                                             (x.endt_seq_no > 0 AND 
                                              TRUNC(NVL(y.to_date,x.endt_expiry_date)) >= TRUNC(x.expiry_date))
                                            )
               ORDER BY x.eff_date DESC)
    LOOP
      v_FROM_DATE          := addtl.from_date;
          v_TO_DATE                         := addtl.to_date;
          v_PAYT_TERMS         := addtl.payt_terms;
          v_PACK_BEN_CD                 := addtl.pack_ben_cd;          
          v_CONTROL_CD                 := addtl.control_cd;
          v_CONTROL_TYPE_CD         := addtl.control_type_cd;          
          v_PRINCIPAL_CD             := addtl.principal_cd;
      EXIT;
    END LOOP;
    
      
    --CLEAR_MESSAGE;
    --MESSAGE('Copying grouped items ...',NO_ACKNOWLEDGE);
    --SYNCHRONIZE; 
    INSERT INTO gipi_wgrouped_items (
                par_id,               item_no,           grouped_item_no, 
                grouped_item_title,   amount_covered,    include_tag,
                remarks,              line_cd,           subline_cd,
                sex,                             position_cd,       civil_status,
                date_of_birth,        age,                       salary,                             
                salary_grade,                    group_cd,
                /* added by gmi.. new columns for this table */
                FROM_DATE,            TO_DATE,           PAYT_TERMS, 
                PACK_BEN_CD,          ANN_TSI_AMT,       ANN_PREM_AMT, 
                CONTROL_CD,           CONTROL_TYPE_CD,   TSI_AMT, 
                PREM_AMT,             PRINCIPAL_CD         )
         VALUES(p_new_par_id, p_item_no,         v_grouped_item_no, 
                v_grouped_item_title, v_amount_coverage, v_include_tag,
                v_remarks,            v_line_cd,         v_subline_cd,
                v_sex,                       v_position_cd,     v_civil_status,
                v_date_of_birth,      v_age,                     v_salary,                             
                v_salary_grade,                v_group_cd,
                /* added by gmi.. new columns for this table */
                v_FROM_DATE,          v_TO_DATE,         v_PAYT_TERMS, 
                v_PACK_BEN_CD,        v_ANN_TSI_AMT,     v_ANN_PREM_AMT, 
                v_CONTROL_CD,         v_CONTROL_TYPE_CD, v_TSI_AMT, 
                v_PREM_AMT,           v_PRINCIPAL_CD         );
           v_remarks            := NULL;
              v_group_cd           := NULL;                
              v_sex                                := NULL;
              v_position_cd        := NULL;
              v_civil_status       := NULL;
              v_date_of_birth      := NULL;
              v_age                := NULL;
              v_salary             := NULL;
              v_salary_grade       := NULL;
           IF (v_line_cd = p_line_ac OR p_menu_line_cd = 'AC')
                  or (v_line_cd = p_line_ca OR p_menu_line_cd = 'CA') THEN
                               populate_group_beneficiary(p_item_no, v_grouped_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
             END IF;
          
END IF;--del                               
END LOOP;                 

END;
/


