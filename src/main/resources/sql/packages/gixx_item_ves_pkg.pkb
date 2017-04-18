CREATE OR REPLACE PACKAGE BODY CPI.GIXX_ITEM_VES_PKG 
AS
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 7, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves item vessel information
  */
  FUNCTION get_item_ves_info(
        p_extract_id    gixx_item_ves.extract_id%TYPE,
        p_item_no       gixx_item_ves.item_no%TYPE
    ) RETURN item_ves_tab PIPELINED
    IS
        v_vessel            item_ves_type;
        v_vestype_cd        giis_vessel.vestype_cd%TYPE;
        v_hull_type_cd        giis_vessel.hull_type_cd%TYPE;
        v_vess_class_cd     giis_vessel.vess_class_cd%TYPE;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, vessel_cd,
                           geog_limit, deduct_text, 
                           dry_date,
                           dry_place, rec_flag, policy_id
                      FROM gixx_item_ves
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)        
        LOOP
            v_vessel.extract_id := rec.extract_id;
            v_vessel.item_no := rec.item_no;
            v_vessel.vessel_cd := rec.vessel_cd;
            v_vessel.geog_limit := rec.geog_limit;
            v_vessel.deduct_text := rec.deduct_text;
            v_vessel.dry_date := TRUNC(rec.dry_date);
            v_vessel.dry_place := rec.dry_place;
            v_vessel.rec_flag := rec.rec_flag;
            v_vessel.policy_id := rec.policy_id;
            
            FOR a IN (SELECT vessel_name, vestype_cd,
                             hull_type_cd, vess_class_cd,
                             reg_owner, gross_ton,
                             net_ton, deadweight,
                             propel_sw, vessel_old_name,
                             reg_place, crew_nat,
                             year_built, no_crew,
                             vessel_breadth, vessel_length, vessel_depth
                        FROM giis_vessel
                       WHERE vessel_cd = rec.vessel_cd)
            LOOP
--                v_vestype_cd := a.vestype_cd;
--                v_hull_type_cd := a.hull_type_cd;
--                v_vess_class_cd := a.vess_class_cd;

                v_vessel.vestype_cd := a.vestype_cd;
                v_vessel.hull_type_cd := a.hull_type_cd;
                v_vessel.vess_class_cd := a.vess_class_cd;
                v_vessel.vessel_name := a.vessel_name;
                v_vessel.reg_owner := a.reg_owner;
                v_vessel.gross_ton := a.gross_ton;
                v_vessel.net_ton := a.net_ton;
                v_vessel.deadweight := a.deadweight;
                v_vessel.propel_sw := a.propel_sw;
                v_vessel.vessel_old_name := a.vessel_old_name;
                v_vessel.reg_place := a.reg_place;
                v_vessel.crew_nat := a.crew_nat;
                v_vessel.year_built := a.year_built;
                v_vessel.no_crew := a.no_crew;
                v_vessel.vessel_breadth := a.vessel_breadth;
                v_vessel.vessel_length := a.vessel_length;
                v_vessel.vessel_depth := a.vessel_depth;
                
            END LOOP;
            
            FOR b IN (SELECT vestype_desc
                        FROM giis_vestype
                       WHERE vestype_cd = v_vessel.vestype_cd)
            LOOP
              v_vessel.vestype_desc := b.vestype_desc;              
            END LOOP;

            FOR c IN (SELECT hull_desc
                        FROM giis_hull_type
                       WHERE hull_type_cd = v_vessel.hull_type_cd)
            LOOP
              v_vessel.hull_desc := c.hull_desc;
            END LOOP;
   
            FOR d IN (SELECT vess_class_desc
                        FROM giis_vess_class
                       WHERE vess_class_cd = v_vessel.vess_class_cd)
            LOOP
              v_vessel.vess_class_desc := d.vess_class_desc;
            END LOOP;
            
            PIPE ROW(v_vessel);
            
        END LOOP;
    END get_item_ves_info;

END GIXX_ITEM_VES_PKG;
/


