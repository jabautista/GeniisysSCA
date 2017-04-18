CREATE OR REPLACE PACKAGE BODY CPI.GIISS039_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.02.2013
     ** Referenced By:  GIISS039 - Maintain Vessel
     **/
     
    FUNCTION get_vestype_lov
        RETURN vestype_lov_tab PIPELINED
    AS
        lov     vestype_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_VESTYPE)
        LOOP
            lov.vestype_cd      := i.vestype_cd;
            lov.vestype_desc    := i.vestype_desc;
            
            PIPE ROW(lov);
        END LOOP;
    END get_vestype_lov;
    
    
    FUNCTION get_vess_class_lov
        RETURN vessclass_lov_tab PIPELINED
    AS
        lov     vessclass_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_VESS_CLASS)
        LOOP
            lov.vess_class_cd      := i.vess_class_cd;
            lov.vess_class_desc    := i.vess_class_desc;
            
            PIPE ROW(lov);
        END LOOP;
    END get_vess_class_lov;
    
    
    FUNCTION get_hull_type_lov
        RETURN hulltype_lov_tab PIPELINED
    AS
        lov     hulltype_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_HULL_TYPE)
        LOOP
            lov.hull_type_cd    := i.hull_type_cd;
            lov.hull_desc       := i.hull_desc;
            
            PIPE ROW(lov);
        END LOOP;
    END get_hull_type_lov;
        
        
    FUNCTION get_rec_list(
        p_vessel_cd           GIIS_VESSEL.VESSEL_CD%type,
        p_vessel_name         GIIS_VESSEL.VESSEL_NAME%type
    ) RETURN rec_tab PIPELINED
    AS
        rec             rec_type;
        v_dt_format     VARCHAR2(30);
    BEGIN
        SELECT param_value_v 
          INTO v_dt_format
          FROM giis_parameters 
         WHERE param_name = 'DATE_FORMAT';
         
        FOR i IN (SELECT *
                    FROM GIIS_VESSEL
                   WHERE vessel_flag = 'V'
                     /*AND (vestype_cd IS NOT NULL
                           OR vess_class_cd IS NOT NULL
                           OR hull_type_cd IS NOT NULL)*/
                     AND UPPER(vessel_cd) LIKE UPPER(NVL(p_vessel_cd, '%'))
                     AND UPPER(vessel_name) LIKE UPPER(NVL(p_vessel_name, '%'))
                   ORDER BY vessel_cd)
        LOOP
            rec.vessel_cd           := i.VESSEL_CD;
            rec.vessel_name         := i.VESSEL_NAME;
            rec.vessel_old_name     := i.VESSEL_OLD_NAME;
            rec.vestype_cd          := i.VESTYPE_CD;
            rec.vess_class_cd       := i.VESS_CLASS_CD;
            rec.hull_type_cd        := i.HULL_TYPE_CD;
            rec.reg_owner           := i.REG_OWNER;
            rec.reg_place           := i.REG_PLACE;
            rec.year_built          := i.YEAR_BUILT;
            rec.dry_date            := i.dry_date; --TO_CHAR(i.dry_date, v_dt_format);
            rec.dry_place           := i.DRY_PLACE;
            rec.crew_nat            := i.CREW_NAT;
            rec.engine_type         := i.ENGINE_TYPE;
            rec.no_pass             := i.NO_PASS;
            rec.gross_ton           := i.GROSS_TON;
            rec.net_ton             := i.NET_TON;
            rec.deadweight          := i.DEADWEIGHT;
            rec.no_crew             := i.NO_CREW;
            rec.vessel_flag         := i.VESSEL_FLAG;
            rec.rpc_no              := i.RPC_NO;
            rec.vessel_length       := i.VESSEL_LENGTH;
            rec.vessel_breadth      := i.VESSEL_BREADTH;
            rec.vessel_depth        := i.VESSEL_DEPTH;
            rec.hull_sw             := i.HULL_SW;
            rec.propel_sw           := i.PROPEL_SW;
            rec.remarks             := i.REMARKS;
            rec.user_id             := i.USER_ID;
            rec.last_update         := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            BEGIN
                SELECT vestype_desc
                  INTO rec.vestype_desc
                  FROM giis_vestype
                 WHERE vestype_cd = i.vestype_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.vestype_desc := null;
            END;
            
            BEGIN
                SELECT vess_class_desc
                  INTO rec.vess_class_desc
                  FROM giis_vess_class
                 WHERE vess_class_cd = i.vess_class_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.vess_class_desc := null;
            END;
            
            BEGIN
                SELECT hull_desc
                  INTO rec.hull_desc
                  FROM giis_hull_type
                 WHERE hull_type_cd = i.hull_type_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.hull_desc := null;
            END;
            
            PIPE ROW(rec);
        END LOOP;
    END get_rec_list;
    
    
    PROCEDURE set_rec (p_rec GIIS_VESSEL%ROWTYPE)
    IS
    BEGIN
        MERGE INTO GIIS_VESSEL
        USING DUAL
           ON (vessel_cd = p_rec.vessel_cd)
         WHEN NOT MATCHED THEN
            INSERT (vessel_cd, vessel_name, vessel_old_name, hull_sw, propel_sw, vestype_cd, vess_class_cd, hull_type_cd,
                    reg_owner, reg_place, year_built, dry_date, dry_place, crew_nat, engine_type, no_pass, no_crew,
                    gross_ton, net_ton, deadweight, vessel_flag, rpc_no, vessel_breadth, vessel_length, vessel_depth,
                    remarks, user_id, last_update)
            VALUES (p_rec.vessel_cd, p_rec.vessel_name, p_rec.vessel_old_name, p_rec.hull_sw, p_rec.propel_sw, p_rec.vestype_cd, 
                    p_rec.vess_class_cd, p_rec.hull_type_cd, p_rec.reg_owner, p_rec.reg_place, p_rec.year_built, p_rec.dry_date, 
                    p_rec.dry_place, p_rec.crew_nat, p_rec.engine_type, p_rec.no_pass, p_rec.no_crew, p_rec.gross_ton, p_rec.net_ton, 
                    p_rec.deadweight, p_rec.vessel_flag, p_rec.rpc_no, p_rec.vessel_breadth, p_rec.vessel_length, p_rec.vessel_depth, 
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET  hull_sw			= p_rec.hull_sw,
 			        propel_sw		= p_rec.propel_sw,
                    vessel_name 	= p_rec.vessel_name,
                    vessel_old_name	= p_rec.vessel_old_name,
                    vestype_cd		= p_rec.vestype_cd,
                    vess_class_cd	= p_rec.vess_class_cd,
                    hull_type_cd	= p_rec.hull_type_cd, 			
                    reg_owner 		= p_rec.reg_owner,
                    reg_place		= p_rec.reg_place,
                    year_built		= p_rec.year_built,
                    dry_date		= p_rec.dry_date,
                    dry_place		= p_rec.dry_place,
                    crew_nat		= p_rec.crew_nat,
                    engine_type		= p_rec.engine_type,
                    no_pass			= p_rec.no_pass,
                    no_crew			= p_rec.no_crew,
                    gross_ton		= p_rec.gross_ton,
                    net_ton			= p_rec.net_ton,
                    deadweight		= p_rec.deadweight,
                    vessel_flag		= p_rec.vessel_flag,
                    rpc_no			= p_rec.rpc_no,
                    vessel_breadth	= p_rec.vessel_breadth,
                    vessel_length	= p_rec.vessel_length,
                    vessel_depth	= p_rec.vessel_depth, 
                    remarks         = p_rec.remarks, 
                    user_id         = p_rec.user_id, 
                    last_update     = SYSDATE
            ;
    END;

    PROCEDURE del_rec (p_vessel_cd  GIIS_VESSEL.VESSEL_CD%type)
    AS
    BEGIN
        DELETE FROM GIIS_VESSEL
         WHERE vessel_cd = p_vessel_cd;
    END;

    PROCEDURE val_del_rec (p_vessel_cd  GIIS_VESSEL.VESSEL_CD%type)
    AS
        v_exists    VARCHAR2 (1);
    BEGIN
        /** IN_USE_MARINE program unit **/
        FOR a IN (SELECT 'Y'
	                FROM gipi_cargo_carrier
	   	           WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_CARGO_CARRIER exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_wcargo_carrier
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WCARGO_CARRIER exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_item_ves
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_ITEM_VES exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_witem_ves
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WITEM_VES exists.'
                                    );
        END IF;
        
        FOR a IN ( SELECT 'Y'
                    FROM gipi_ves_accumulation
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_VES_ACCUMULATION exists.'
                                    );
        END IF;
        
        FOR a IN ( SELECT 'Y'
                    FROM gipi_wves_accumulation
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WVES_ACCUMULATION exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_ves_air
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_VES_AIR exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_wves_air
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WVES_AIR exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_aviation_item
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_AVIATION_ITEM exists.'
                                    );
        END IF;
        
        FOR a IN (SELECT 'Y'
                    FROM gipi_waviation_item
                   WHERE vessel_cd = p_vessel_cd)
	    LOOP
            v_exists := 'Y';
		    EXIT;
	    END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WAVIATION_ITEM exists.'
                                    );
        END IF;
    END;

    PROCEDURE val_add_rec (p_vessel_cd  GIIS_VESSEL.VESSEL_CD%type)
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_VESSEL a
                   WHERE a.vessel_cd = p_vessel_cd)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Record already exists with the same vessel_cd.'
                                    );
        END IF;
    END;

END GIISS039_PKG;
/


