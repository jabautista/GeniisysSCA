DROP PROCEDURE CPI.POPULATE_CASUALTY;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_CASUALTY (
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_policy.par_id%TYPE,
    p_line_ac          IN  VARCHAR2,
    p_menu_line_cd     IN  VARCHAR2,
    p_line_ca          IN  VARCHAR2,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id                     RECORDGROUP;
  rg_name                   VARCHAR2(30) := 'GROUP_POLICY';
  rg_count                  NUMBER;
  rg_count2                 NUMBER;
  rg_col                    VARCHAR2(50) := rg_name || '.policy_id';
  item_exist                VARCHAR2(1); 
  v_row                     NUMBER;
  v_policy_id               gipi_polbasic.policy_id%TYPE;
  v_endt_id                 gipi_polbasic.policy_id%TYPE;
  v_section_line_cd         gipi_wcasualty_item.section_line_cd%TYPE; 
  v_section_subline_cd      gipi_wcasualty_item.section_subline_cd%TYPE;
  v_capacity_cd             gipi_wcasualty_item.capacity_cd%TYPE;
  v_section_or_hazard_cd    gipi_wcasualty_item.section_or_hazard_cd%TYPE;
  v_property_no             gipi_wcasualty_item.property_no%TYPE;
  v_property_no_type        gipi_wcasualty_item.property_no_type%TYPE;
  v_location                gipi_wcasualty_item.location%TYPE;
  v_conveyance_info         gipi_wcasualty_item.conveyance_info%TYPE;
  v_limit_of_liability      gipi_wcasualty_item.limit_of_liability%TYPE;
  v_interest_on_premises    gipi_wcasualty_item.interest_on_premises%TYPE;
  v_section_or_hazard_info  gipi_wcasualty_item.section_or_hazard_info%TYPE;
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN    
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_CASUALTY program unit 
  */ 
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg); 
  IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
        FOR DATA2 IN ( SELECT section_line_cd,       section_subline_cd,
                              capacity_cd,           section_or_hazard_cd,
                              property_no,           property_no_type,
                              location,              conveyance_info,
                              limit_of_liability,    interest_on_premises,
                              section_or_hazard_info
                       FROM gipi_casualty_item
                      WHERE item_no = v_item_no 
                        AND policy_id = v_policy_id --v_endt_id
                   ) LOOP
                     v_section_line_cd         := NVL(data2.section_line_cd, v_section_line_cd);
                     v_section_subline_cd      := NVL(data2.section_subline_cd, v_section_subline_cd); 
                     v_capacity_cd             := NVL(data2.capacity_cd, v_capacity_cd); 
                     v_section_or_hazard_cd    := NVL(data2.section_or_hazard_cd, v_section_or_hazard_cd);
                     v_property_no             := NVL(data2.property_no, v_property_no); 
                     v_property_no_type        := NVL(data2.property_no_type, v_property_no_type);
                     v_location                := NVL(data2.location, v_location);
                     v_conveyance_info         := NVL(data2.conveyance_info, v_conveyance_info);
                     v_limit_of_liability      := NVL(data2.limit_of_liability, v_limit_of_liability);
                     v_interest_on_premises    := NVL(data2.interest_on_premises, v_interest_on_premises);
                     v_section_or_hazard_info  := NVL(data2.section_or_hazard_info, v_section_or_hazard_info);
                  END LOOP; 
     END LOOP;
  ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
        FOR DATA2 IN ( SELECT section_line_cd,       section_subline_cd,
                              capacity_cd,           section_or_hazard_cd,
                              property_no,           property_no_type,
                              location,              conveyance_info,
                              limit_of_liability,    interest_on_premises,
                              section_or_hazard_info
                       FROM gipi_casualty_item
                      WHERE item_no = v_item_no 
                        AND policy_id = v_policy_id --v_endt_id
                   ) LOOP
                     v_section_line_cd         := NVL(data2.section_line_cd, v_section_line_cd);
                     v_section_subline_cd      := NVL(data2.section_subline_cd, v_section_subline_cd); 
                     v_capacity_cd             := NVL(data2.capacity_cd, v_capacity_cd); 
                     v_section_or_hazard_cd    := NVL(data2.section_or_hazard_cd, v_section_or_hazard_cd);
                     v_property_no             := NVL(data2.property_no, v_property_no); 
                     v_property_no_type        := NVL(data2.property_no_type, v_property_no_type);
                     v_location                := NVL(data2.location, v_location);
                     v_conveyance_info         := NVL(data2.conveyance_info, v_conveyance_info);
                     v_limit_of_liability      := NVL(data2.limit_of_liability, v_limit_of_liability);
                     v_interest_on_premises    := NVL(data2.interest_on_premises, v_interest_on_premises);
                     v_section_or_hazard_info  := NVL(data2.section_or_hazard_info, v_section_or_hazard_info);
                  END LOOP;
     END LOOP;
   END IF;
 --CLEAR_MESSAGE;
 --MESSAGE('Copying casualty info ...',NO_ACKNOWLEDGE);
 --SYNCHRONIZE;  
   INSERT INTO gipi_wcasualty_item(par_id,                item_no,
                                    section_line_cd,       section_subline_cd,
                                    capacity_cd,           section_or_hazard_cd,
                                    property_no,           property_no_type,
                                    location,              conveyance_info,
                                    limit_of_liability,    interest_on_premises,
                                    section_or_hazard_info)
    VALUES( p_new_par_id,          v_item_no,
            v_section_line_cd,     v_section_subline_cd,
            v_capacity_cd,         v_section_or_hazard_cd,
            v_property_no,         v_property_no_type,
             v_location,            v_conveyance_info,
            v_limit_of_liability,  v_interest_on_premises,
            v_section_or_hazard_info);
    --POPULATE_GROUP_ITEMS(v_item_no);/*Commented by aivhie 112101*/
  POPULATE_GROUP_ITEM(v_item_no, p_old_pol_id, p_line_ac, p_menu_line_cd, p_new_par_id, p_line_ca, p_proc_summary_sw, p_msg); /*Added by aivhie 112101*/                   
    --POPULATE_PERSONNEL(v_item_no);/*Commented by aivhie 111601*/
  POPULATE_PERSONNELS(v_item_no, p_old_pol_id, p_new_par_id);/*Added by aivhie 111601*/                  
  POPULATE_BENEFICIARY(v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
  --POPULATE_GROUP_BENEFICIARY(v_item_no);
  v_section_line_cd         := NULL; 
  v_section_subline_cd      := NULL; 
  v_capacity_cd             := NULL; 
  v_section_or_hazard_cd    := NULL;
  v_property_no             := NULL; 
  v_property_no_type        := NULL;
  v_location                := NULL;
  v_conveyance_info         := NULL;
  v_limit_of_liability      := NULL;
  v_interest_on_premises    := NULL;
  v_section_or_hazard_info  := NULL;
END;
/


