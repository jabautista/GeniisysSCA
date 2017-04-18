CREATE OR REPLACE PACKAGE CPI.GIPI_ITEM_VES_PKG AS

  TYPE marine_hulls_type IS RECORD(  
    vessel_name         giis_vessel.vessel_name%TYPE,
    vessel_cd           gipi_item_ves.vessel_cd%TYPE,
    policy_id           gipi_polbasic.policy_id%TYPE,
    policy_no           VARCHAR2(50)
  );
  
  TYPE marine_hulls_tab IS TABLE OF marine_hulls_type;
  
  FUNCTION get_marine_hulls  
    RETURN marine_hulls_tab PIPELINED;
    
   TYPE gipi_item_ves_par_type IS RECORD (
      policy_id                gipi_item.policy_id%TYPE,
      item_no                  gipi_item.item_no%TYPE,
      vessel_cd                gipi_item_ves.vessel_cd%TYPE,
      vessel_flag              giis_vessel.vessel_flag%TYPE,
      vessel_name              giis_vessel.vessel_name%TYPE,
      vessel_old_name          giis_vessel.vessel_old_name%TYPE,
      vestype_desc             giis_vestype.vestype_desc%TYPE,
      propel_sw                giis_vessel.propel_sw%TYPE,
      vess_class_desc          giis_vess_class.vess_class_desc%TYPE,
      hull_desc                giis_hull_type.hull_desc%TYPE,
      reg_owner                giis_vessel.reg_owner%TYPE,
      reg_place                giis_vessel.reg_place%TYPE,
      gross_ton                giis_vessel.gross_ton%TYPE,
      year_built               giis_vessel.year_built%TYPE,
      net_ton                  giis_vessel.net_ton%TYPE,
      no_crew                  giis_vessel.no_crew%TYPE,
      deadweight               giis_vessel.deadweight%TYPE,
      crew_nat                 giis_vessel.crew_nat%TYPE,
      vessel_length            giis_vessel.vessel_length%TYPE,
      vessel_breadth           giis_vessel.vessel_breadth%TYPE,
      vessel_depth             giis_vessel.vessel_depth%TYPE,
      dry_place                giis_vessel.dry_place%TYPE,
      dry_date                 VARCHAR2(10),    --GIIS_VESSEL.dry_date%TYPE,
      rec_flag                 gipi_item_ves.rec_flag%TYPE,
      deduct_text              gipi_item_ves.deduct_text%TYPE,
      geog_limit               gipi_item_ves.geog_limit%TYPE
   );

   TYPE gipi_item_ves_par_tab IS TABLE OF gipi_item_ves_par_type;    
   
   FUNCTION get_gipi_item_ves(p_policy_id    GIPI_ITEM.policy_id%TYPE,
                              p_item_no   GIPI_ITEM.item_no %TYPE)
   RETURN gipi_item_ves_par_tab PIPELINED;    
   
       TYPE item_ves_info_type IS RECORD(
    
        policy_id           gipi_item_ves.policy_id%TYPE,
        item_no             gipi_item_ves.item_no%TYPE,
        dry_date            gipi_item_ves.dry_date%TYPE,
        rec_flag            gipi_item_ves.rec_flag%TYPE,
        dry_place           gipi_item_ves.dry_place%TYPE,
        vessel_cd           gipi_item_ves.vessel_cd%TYPE,
        geog_limit          gipi_item_ves.geog_limit%TYPE,
        deduct_text         gipi_item_ves.deduct_text%TYPE,

        vestype_desc        giis_vestype.vestype_desc%TYPE,
        vessel_name         giis_vessel.vessel_name%TYPE,
        reg_owner           giis_vessel.reg_owner%TYPE,
        gross_ton           giis_vessel.gross_ton%TYPE,
        net_ton             giis_vessel.net_ton%TYPE,
        deadweight          giis_vessel.deadweight%TYPE,
        hull_desc           giis_hull_type.hull_desc%TYPE,
        vessel_length       giis_vessel.vessel_length%TYPE,
        vessel_old_name     giis_vessel.vessel_old_name%TYPE,
        vess_class_desc     giis_vess_class.vess_class_desc%TYPE,
        vessel_breadth      giis_vessel.vessel_breadth%TYPE,
        vessel_depth        giis_vessel.vessel_depth%TYPE,
        year_built          giis_vessel.year_built%TYPE,
        reg_place           giis_vessel.reg_place%TYPE,
        no_crew             giis_vessel.no_crew%TYPE,
        crew_nat            giis_vessel.crew_nat%TYPE,
        item_title          gipi_item.item_title%TYPE,
        propel_sw_desc      VARCHAR2(15)
        
    );
    
    TYPE item_ves_info_tab IS TABLE OF item_ves_info_type;
    
    FUNCTION get_item_ves_info(
       p_policy_id   gipi_item_ves.policy_id%TYPE,
       p_item_no     gipi_item_ves.item_no%TYPE
    )
       RETURN item_ves_info_tab PIPELINED;
       
END GIPI_ITEM_VES_PKG;
/


