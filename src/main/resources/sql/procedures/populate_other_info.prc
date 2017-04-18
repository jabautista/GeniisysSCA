DROP PROCEDURE CPI.POPULATE_OTHER_INFO;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_OTHER_INFO(
    p_new_par_id       IN  gipi_wpolbas.par_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_line_ac          IN  VARCHAR2,
    p_menu_line_cd     IN  VARCHAR2,
    p_line_ca          IN  VARCHAR2,
    p_line_av          IN  VARCHAR2,
    p_line_fi          IN  VARCHAR2,
    p_line_mc          IN  VARCHAR2,
    p_line_mn          IN  VARCHAR2,
    p_line_mh          IN  VARCHAR2,
    p_line_en          IN  VARCHAR2,
    p_user             IN  gipi_wmcacc.user_id%TYPE,
    p_vessel_cd        IN  giis_vessel.vessel_cd%TYPE,
    p_subline_bpv      IN  VARCHAR2,
    p_open_flag        IN  VARCHAR2,
    p_msg             OUT  VARCHAR2
) 
IS
  v_line_cd         gipi_wpolbas.line_cd%TYPE;
  v_pol_line        gipi_wpolbas.line_cd%TYPE;
  v_pol_subline     gipi_wpolbas.subline_cd%TYPE;
  v_subline_cd      gipi_wpolbas.subline_cd%TYPE;
  v_pack_flag       gipi_wpolbas.pack_pol_flag%TYPE; 
  v_other_sw        VARCHAR2(1) := 'Y';
  v_menu_line_cd    giis_line.line_cd%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_OTHER_INFO program unit 
  */
    FOR PACK IN
        ( SELECT NVL(pack_pol_flag,'N') flag, line_cd, subline_cd
            FROM gipi_wpolbas
           WHERE par_id = p_new_par_id
        )     LOOP
        v_pack_flag    := pack.flag;
        v_pol_line     := pack.line_cd;
        v_pol_subline  := pack.subline_cd;
        EXIT;
    END LOOP;        
  FOR ITEM IN
      ( SELECT item_no,pack_line_cd, pack_subline_cd
          FROM gipi_witem
         WHERE par_id = p_new_par_id
      ) LOOP
      IF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
         populate_peril(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
         FOR GRP_ITEM IN (SELECT grouped_item_no
                            FROM gipi_wgrouped_items
                           WHERE par_id = p_new_par_id
                             AND item_no = item.item_no) 
                 LOOP
                     populate_peril_grp(item.item_no, grp_item.grouped_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
                 END LOOP;    
      ELSE
         populate_peril2(item.item_no, p_old_pol_id, p_new_par_id);
         FOR GRP_ITEM IN (SELECT grouped_item_no
                                              FROM gipi_wgrouped_items
                                             WHERE par_id = p_new_par_id
                                               AND item_no = item.item_no) 
                 LOOP
                     populate_peril2_grp(item.item_no, grp_item.grouped_item_no, p_old_pol_id, p_new_par_id);
                 END LOOP;
      END IF; 
      v_other_sw  := 'N';
      FOR CHK IN
          ( SELECT SUM(tsi_amt) tsi, SUM(prem_amt) prem
              FROM gipi_witmperl
             WHERE par_id = p_new_par_id
               AND item_no = item.item_no
          ) LOOP
          IF nvl(chk.tsi,0) > 0 OR nvl(chk.prem,0) > 0 THEN
               v_other_sw := 'Y';
          ELSE               
               v_other_sw := 'N';
          END IF;
      END LOOP;    
      IF v_other_sw = 'Y' THEN
           populate_deductibles(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
         IF v_pack_flag = 'Y' THEN
              v_line_cd := item.pack_line_cd;
              v_subline_cd := item.pack_subline_cd;
         ELSE          
              v_line_cd := v_pol_line;
              v_subline_cd := v_pol_subline;
         END IF;     
         FOR menu_line IN ( SELECT menu_line_cd code
                              FROM giis_line
                             WHERE line_cd = v_line_cd )
         LOOP
             v_menu_line_cd := menu_line.code;
             EXIT;
         END LOOP;  
         IF v_line_cd = p_line_ac OR v_menu_line_cd = 'AC' THEN
            populate_accident(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_line_ac, p_menu_line_cd, p_line_ca, p_msg); 
            IF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
                 FOR GRP_ITEM IN (SELECT grouped_item_no
                                    FROM gipi_wgrouped_items
                                   WHERE par_id = p_new_par_id
                                     AND item_no = item.item_no) 
                             LOOP
                                 populate_peril_grp(item.item_no, grp_item.grouped_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
                             END LOOP;    
                  ELSE                     
                     FOR GRP_ITEM IN (SELECT grouped_item_no
                                        FROM gipi_wgrouped_items
                                       WHERE par_id = p_new_par_id
                                         AND item_no = item.item_no) 
                             LOOP
                                 populate_peril2_grp(item.item_no, grp_item.grouped_item_no, p_old_pol_id, p_new_par_id);
                             END LOOP;
                  END IF;    
         ELSIF v_line_cd = p_line_av OR v_menu_line_cd = 'AV' THEN
            populate_aviation(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);     
         ELSIF v_line_cd = p_line_ca OR v_menu_line_cd = 'CA' THEN
            populate_casualty(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_line_ac, p_menu_line_cd, p_line_ca, p_msg); 
         ELSIF v_line_cd = p_line_fi OR v_menu_line_cd = 'FI' THEN               
            populate_fire(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);  
         ELSIF v_line_cd = p_line_mc OR v_menu_line_cd = 'MC' THEN
            populate_motorcar(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);
         ELSIF v_line_cd = p_line_mn OR v_menu_line_cd = 'MN' THEN
            populate_cargo(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_vessel_cd, p_msg);
            populate_vessel(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
         ELSIF v_line_cd = p_line_mh OR v_menu_line_cd = 'MH' THEN
              populate_hull(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
              populate_vessel(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
         ELSIF v_line_cd = p_line_en OR v_menu_line_cd = 'EN' THEN
              IF v_subline_cd = p_subline_bpv THEN 
                 populate_location(item.item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
              END IF;   
         END IF;      
      ELSE
         DELETE FROM gipi_witmperl
             WHERE item_no = item.item_no
            AND par_id  = p_new_par_id;
         DELETE FROM gipi_witem
             WHERE item_no = item.item_no
            AND par_id  = p_new_par_id;
      END IF;                    
  END LOOP;
                   
  --IF v_pol_line = variables.line_mn AND
  --     v_pol_subline = variables.subline_mop THEN
  IF nvl(p_open_flag,'N') = 'Y' THEN   
       populate_open_liab(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
       populate_open_peril(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
       populate_open_cargo(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
  END IF;
END;
/


