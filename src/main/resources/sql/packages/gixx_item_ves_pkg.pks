CREATE OR REPLACE PACKAGE CPI.GIXX_ITEM_VES_PKG 
AS
  
  -- added by  Kris 03.07.2013 for GIPIS101
  TYPE item_ves_type IS RECORD (
        extract_id      gixx_item_ves.extract_id%TYPE,
        item_no         gixx_item_ves.item_no%TYPE,
        vessel_cd       gixx_item_ves.vessel_cd%TYPE,
        geog_limit      gixx_item_ves.geog_limit%TYPE,
        deduct_text     gixx_item_ves.deduct_text%TYPE,
        dry_date        gixx_item_ves.dry_date%TYPE,
        dry_place       gixx_item_ves.dry_place%TYPE,
        rec_flag        gixx_item_ves.rec_flag%TYPE,
        policy_id       gixx_item_ves.policy_id%TYPE,
        
        vessel_name     giis_vessel.vessel_name%TYPE,
        vestype_cd      giis_vessel.vestype_cd%TYPE,
        hull_type_cd    giis_vessel.hull_type_cd%TYPE,
        vess_class_cd   giis_vessel.vess_class_cd%TYPE,
        reg_owner       giis_vessel.reg_owner%TYPE,
        gross_ton       giis_vessel.gross_ton%TYPE,
        net_ton         giis_vessel.net_ton%TYPE,
        deadweight      giis_vessel.deadweight%TYPE,
        propel_sw       giis_vessel.propel_sw%TYPE,
        vessel_old_name giis_vessel.vessel_old_name%TYPE,
        reg_place       giis_vessel.reg_place%TYPE,
        crew_nat        giis_vessel.crew_nat%TYPE,
        year_built      giis_vessel.year_built%TYPE,
        no_crew         giis_vessel.no_crew%TYPE,
        vessel_breadth  giis_vessel.vessel_breadth%TYPE,
        vessel_length   giis_vessel.vessel_length%TYPE,
        vessel_depth    giis_vessel.vessel_depth%TYPE,
        
        vestype_desc    giis_vestype.vestype_desc%TYPE,
        hull_desc       giis_hull_type.hull_desc%TYPE,
        vess_class_desc giis_vess_class.vess_class_desc%TYPE        
    );
    
    TYPE item_ves_tab IS TABLE OF item_ves_type;
    
    FUNCTION get_item_ves_info(
        p_extract_id    gixx_item_ves.extract_id%TYPE,
        p_item_no       gixx_item_ves.item_no%TYPE
    ) RETURN item_ves_tab PIPELINED;
    -- end 03.07.2013 for GIPIS101

END GIXX_ITEM_VES_PKG;
/


