CREATE OR REPLACE PACKAGE CPI.GIISS039_PKG
AS
    
    TYPE vestype_lov_type IS RECORD(
        vestype_cd      GIIS_VESTYPE.VESTYPE_CD%type,
        vestype_desc    GIIS_VESTYPE.VESTYPE_DESC%type
    );
    
    TYPE vestype_lov_tab IS TABLE OF vestype_lov_type;
    
    FUNCTION get_vestype_lov
        RETURN vestype_lov_tab PIPELINED;
        
    
    TYPE vessclass_lov_type IS RECORD(
        vess_class_cd       GIIS_VESS_CLASS.VESS_CLASS_CD%type,
        vess_class_desc     GIIS_VESS_CLASS.VESS_CLASS_DESC%type
    );
    
    TYPE vessclass_lov_tab IS TABLE OF vessclass_lov_type;
    
    FUNCTION get_vess_class_lov
        RETURN vessclass_lov_tab PIPELINED;
        
    
    TYPE hulltype_lov_type IS RECORD(
        hull_type_cd        GIIS_HULL_TYPE.HULL_TYPE_CD%type,
        hull_desc           GIIS_HULL_TYPE.HULL_DESC%type
    );
    
    TYPE hulltype_lov_tab IS TABLE OF hulltype_lov_type;
    
    
    FUNCTION get_hull_type_lov
        RETURN hulltype_lov_tab PIPELINED;
        

    TYPE rec_type IS RECORD(
        vessel_cd           GIIS_VESSEL.VESSEL_CD%type,
        vessel_name         GIIS_VESSEL.VESSEL_NAME%type,
        vessel_old_name     GIIS_VESSEL.VESSEL_OLD_NAME%type,
        vessel_flag         GIIS_VESSEL.VESSEL_FLAG%type,
        vestype_cd          GIIS_VESSEL.VESTYPE_CD%type,
        vestype_desc        GIIS_VESTYPE.VESTYPE_DESC%type,
        vess_class_cd       GIIS_VESSEL.VESS_CLASS_CD%type,
        vess_class_desc     GIIS_VESS_CLASS.VESS_CLASS_DESC%type,
        hull_type_cd        GIIS_VESSEL.HULL_TYPE_CD%type,
        hull_desc           GIIS_HULL_TYPE.HULL_DESC%type,
        reg_owner           GIIS_VESSEL.REG_OWNER%type,
        reg_place           GIIS_VESSEL.REG_PLACE%type,
        year_built          GIIS_VESSEL.YEAR_BUILT%type,
        dry_date            GIIS_VESSEL.DRY_DATE%type, --VARCHAR2(30),
        dry_place           GIIS_VESSEL.DRY_PLACE%type,
        crew_nat            GIIS_VESSEL.CREW_NAT%type,
        engine_type         GIIS_VESSEL.ENGINE_TYPE%type,
        no_pass             GIIS_VESSEL.NO_PASS%type,
        gross_ton           GIIS_VESSEL.GROSS_TON%type,
        net_ton             GIIS_VESSEL.NET_TON%type,
        deadweight          GIIS_VESSEL.DEADWEIGHT%type,
        no_crew             GIIS_VESSEL.NO_CREW%type,
        rpc_no              GIIS_VESSEL.RPC_NO%type,
        vessel_length       GIIS_VESSEL.VESSEL_LENGTH%type,
        vessel_breadth      GIIS_VESSEL.VESSEL_BREADTH%type,
        vessel_depth        GIIS_VESSEL.VESSEL_DEPTH%type,
        hull_sw             GIIS_VESSEL.HULL_SW%type,
        propel_sw           GIIS_VESSEL.PROPEL_SW%type,
        remarks             GIIS_VESSEL.REMARKS%type,
        user_id             GIIS_VESSEL.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;    
    
    FUNCTION get_rec_list(
        p_vessel_cd           GIIS_VESSEL.VESSEL_CD%type,
        p_vessel_name         GIIS_VESSEL.VESSEL_NAME%type
    ) RETURN rec_tab PIPELINED;
    
    PROCEDURE set_rec (p_rec GIIS_VESSEL%ROWTYPE);

    PROCEDURE del_rec (p_vessel_cd  GIIS_VESSEL.VESSEL_CD%type);

    PROCEDURE val_del_rec (p_vessel_cd  GIIS_VESSEL.VESSEL_CD%type);
   
    PROCEDURE val_add_rec(p_vessel_cd  GIIS_VESSEL.VESSEL_CD%type);

END GIISS039_PKG;
/


