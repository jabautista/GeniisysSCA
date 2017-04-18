DROP PROCEDURE CPI.POPULATE_ITEM_INFO3;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ITEM_INFO3(
    p_old_pol_id    gipi_polbasic.policy_id%TYPE,
    p_new_par_id    gipi_witem.par_id%TYPE
) 
IS
  v_line_cd          gipi_polbasic.line_cd%TYPE;     -- line_cd of policy/endt with certain district/block
  v_subline_cd       gipi_polbasic.subline_cd%TYPE;  -- subline_cd of policy/endt with certain district/block
  v_iss_cd           gipi_polbasic.iss_cd%TYPE;      -- iss_cd of policy/endt with certain district/block
  v_issue_yy         gipi_polbasic.issue_yy%TYPE;    -- issue_yy of policy/endt with certain district/block
  v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;  -- pol_seq_no of policy/endt with certain district/block
  v_renew_no         gipi_polbasic.renew_no%TYPE;    -- renew_no of policy/endt with certain district/block
  v_item_no          gipi_witem.item_no%TYPE;
  v_item_title       gipi_witem.item_title%TYPE;
  v_item_desc        gipi_witem.item_desc%TYPE;
  v_item_desc2       gipi_witem.item_desc2%TYPE;
  v_currency_cd      gipi_witem.currency_cd%TYPE;
  v_currency_rt      gipi_witem.currency_rt%TYPE;
  v_group_cd         gipi_witem.group_cd%TYPE;
  v_from_date        gipi_witem.from_date%TYPE;
  v_to_date          gipi_witem.to_date%TYPE;
  v_pack_line_cd     gipi_witem.pack_line_cd%TYPE;
  v_pack_subline_cd  gipi_witem.pack_subline_cd%TYPE;
  v_other_info       gipi_witem.other_info%TYPE;
  v_coverage_cd      gipi_witem.coverage_cd%TYPE;
  v_item_grp         gipi_witem.item_grp%TYPE;
  v_region_cd        gipi_witem.region_cd%TYPE;
  v_changed_tag      gipi_witem.changed_tag%TYPE;
  v_risk_no              gipi_witem.risk_no%TYPE;
  v_risk_item_no     gipi_witem.risk_item_no%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_ITEM_INFO3 program unit 
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
    EXIT;
  END LOOP;
  
  -- grp FOR LOOP selects all item_no of the above policy together 
  -- with its endorsemet/s
  FOR grp IN (SELECT DISTINCT item_no
                FROM gipi_polbasic x,
                     gipi_item y
               WHERE x.line_cd    = v_line_cd
                 AND x.subline_cd = v_subline_cd
                 AND x.iss_cd     = v_iss_cd
                 AND x.issue_yy   = v_issue_yy
                 AND x.pol_seq_no = v_pol_seq_no
                 AND x.renew_no   = v_renew_no
                 AND x.pol_flag IN ('1','2','3')
                 AND x.policy_id  = y.policy_id)
  LOOP
      v_item_no    := grp.item_no;
    
    -- selects the latest item_title, and item_grp
    FOR data IN (SELECT y.item_title  ,y.item_grp
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.item_title IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.item_title IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_item_title := data.item_title;
      v_item_grp   := data.item_grp;
      EXIT;
    END LOOP;
    
    -- selects the latest item_desc
      FOR item IN (SELECT y.item_desc
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.item_desc IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.item_desc IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_item_desc := item.item_desc;
      EXIT;
    END LOOP;
    
    -- selects the latest item_desc2
    FOR item2 IN (SELECT y.item_desc2
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.item_desc2 IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.item_desc2 IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_item_desc2 := item2.item_desc2;
      EXIT;
    END LOOP;
    
    -- selects the latest currency_cd
    FOR curr IN (SELECT y.currency_cd
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.currency_cd IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.currency_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_currency_cd := curr.currency_cd;
      EXIT;
    END LOOP;
             
    -- selects the latest currency_rt             
    FOR curt IN (SELECT y.currency_rt
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.currency_rt IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.currency_rt IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_currency_rt := curt.currency_rt;
      EXIT;
    END LOOP;             
      
    -- selects the latest group_cd
    FOR grp  IN (SELECT y.group_cd
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.group_cd IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.group_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_group_cd := grp.group_cd;
      EXIT;
    END LOOP;
    
    -- selects the latest from_date
    /*FOR frm  IN (SELECT y.from_date
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.from_date IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.from_date IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_from_date := frm.from_date;
      EXIT;
    END LOOP;*/
    
    -- selects the latest to_date
    /*FOR to_d  IN (SELECT y.to_date
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.from_date IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.from_date IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_to_date := to_d.to_date;
      EXIT;
    END LOOP;*/
    
    -- selects the latest pack_line_cd
    FOR pack IN (SELECT y.pack_line_cd
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.pack_line_cd IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.pack_line_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_pack_line_cd := pack.pack_line_cd;
      EXIT;
    END LOOP;
    
    -- selects the latest pack_subline_cd
    FOR pacs IN (SELECT y.pack_subline_cd
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.pack_subline_cd IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.pack_subline_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_pack_subline_cd := pacs.pack_subline_cd;
      EXIT;
    END LOOP;             
    
    -- selects the latest other_info
    FOR othe IN (SELECT y.other_info
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.other_info IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.other_info IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_other_info := othe.other_info;
      EXIT;
    END LOOP;             
    
    -- selects the latest coverage_cd
    FOR cove IN (SELECT y.coverage_cd
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.coverage_cd IS NOT NULL )
                    AND x.policy_id       = y.policy_id
                    AND y.item_no = v_item_no
                    AND y.coverage_cd IS NOT NULL
               ORDER BY x.eff_date DESC)
    LOOP
      v_coverage_cd := cove.coverage_cd;
      EXIT;
    END LOOP;             
    -- selects the latest region_cd
    FOR reg IN  (SELECT y.region_cd
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.region_cd IS NOT NULL )
                    AND x.policy_id = y.policy_id
                    AND y.item_no   = v_item_no
                    AND y.region_cd IS NOT NULL
               ORDER BY x.eff_date  DESC)
    LOOP
      v_region_cd := reg.region_cd;
      EXIT;
    END LOOP;             
    
    -- selects the latest risk_no
    FOR risk1 IN  (SELECT y.risk_no
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.risk_no IS NOT NULL )
                    AND x.policy_id = y.policy_id
                    AND y.item_no   = v_item_no
                    AND y.risk_no IS NOT NULL
               ORDER BY x.eff_date  DESC)
    LOOP
      v_risk_no := risk1.risk_no;
      EXIT;
    END LOOP;
    
    -- selects the latest risk_item_no
    FOR risk2 IN  (SELECT y.risk_item_no
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.risk_item_no IS NOT NULL )
                    AND x.policy_id = y.policy_id
                    AND y.item_no   = v_item_no
                    AND y.risk_item_no IS NOT NULL
               ORDER BY x.eff_date  DESC)
    LOOP
      v_risk_item_no := risk2.risk_item_no;
      EXIT;
    END LOOP;
          
    -- selects the latest changed_tag
    FOR cha IN  (SELECT y.changed_tag
                   FROM gipi_polbasic x,
                        gipi_item y
                  WHERE x.line_cd    = v_line_cd
                    AND x.subline_cd = v_subline_cd
                    AND x.iss_cd     = v_iss_cd
                    AND x.issue_yy   = v_issue_yy
                    AND x.pol_seq_no = v_pol_seq_no
                    AND x.renew_no   = v_renew_no
                    AND x.pol_flag IN ('1','2','3')
                    AND NOT EXISTS(SELECT 'X'
                                     FROM gipi_polbasic m,
                                          gipi_item  n
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
                                      AND n.item_no  = v_item_no
                                      AND n.changed_tag IS NOT NULL )
                    AND x.policy_id = y.policy_id
                    AND y.item_no   = v_item_no
                    AND y.changed_tag IS NOT NULL
               ORDER BY x.eff_date  DESC)
    LOOP
      v_changed_tag := cha.changed_tag;
      EXIT;
    END LOOP;             

    --CLEAR_MESSAGE;
    --MESSAGE('Copying item info ...',NO_ACKNOWLEDGE);
    --SYNCHRONIZE; 
    INSERT INTO gipi_witem ( par_id,              item_no,        item_title,
                             item_desc,           item_desc2,     currency_cd,
                             currency_rt,         group_cd,       
                             --from_date,           to_date,             
                             pack_line_cd,        pack_subline_cd,     
                             other_info,          coverage_cd,    item_grp,
                             region_cd,           changed_tag,
                             risk_no,             risk_item_no)
                    VALUES ( p_new_par_id,        grp.item_no,    v_item_title,
                             v_item_desc,         v_item_desc2,   v_currency_cd,
                             v_currency_rt,       v_group_cd,     
                             --v_from_date,         v_to_date,           
                             v_pack_line_cd,      v_pack_subline_cd,
                             v_other_info,        v_coverage_cd,  v_item_grp,
                             v_region_cd,         v_changed_tag,
                             v_risk_no,           v_risk_item_no); 
             
     v_item_desc       := NULL;
     v_item_desc2      := NULL;
     v_currency_cd     := NULL;
     v_currency_rt     := NULL;
     v_group_cd        := NULL;
     v_from_date       := NULL;
     v_to_date         := NULL;
     v_pack_line_cd    := NULL;
     v_pack_subline_cd := NULL;
     v_other_info      := NULL;
     v_coverage_cd     := NULL;
     v_region_cd       := NULL;
     v_changed_tag     := NULL;
     v_risk_no         := NULL;
     v_risk_item_no    := NULL;
  END LOOP;                 
    
END;
/


