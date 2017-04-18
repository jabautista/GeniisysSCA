DROP PROCEDURE CPI.UPD8_GIPI_WPACK_LINE_SUBLINE1;

CREATE OR REPLACE PROCEDURE CPI.UPD8_GIPI_WPACK_LINE_SUBLINE1 (p_pack_par_id IN gipi_wpack_line_subline.pack_par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Update records on gipi_wpack_line_subline based on certain conditions
	*/
	v_count_item	NUMBER ;
	v_count_ac		NUMBER ;
	v_count_av		NUMBER ;
	v_count_ca1		NUMBER ;
	v_count_ca2		NUMBER ;
	v_count_ca3		NUMBER ;
	v_count_ca4		NUMBER ;
	v_count_fi		NUMBER ;
	v_count_en		NUMBER ;
	v_count_mn		NUMBER ;
	v_count_mh		NUMBER ;
	v_count_mc		NUMBER ;
	v_exists_ca		VARCHAR2(1) ;
    v_menu            giis_line.menu_line_cd%TYPE;
    
    v_fi    giis_parameters.param_value_v%TYPE;
    v_av    giis_parameters.param_value_v%TYPE;
    v_mh    giis_parameters.param_value_v%TYPE;
    v_ca    giis_parameters.param_value_v%TYPE;
    v_en    giis_parameters.param_value_v%TYPE;
    v_ac    giis_parameters.param_value_v%TYPE;
    v_mn    giis_parameters.param_value_v%TYPE;
    v_mc    giis_parameters.param_value_v%TYPE;
    
    CURSOR PACK IS 
        SELECT pack_line_cd,pack_subline_cd
          FROM gipi_wpack_line_subline
         WHERE pack_par_id = p_pack_par_id;
    
    CURSOR ITEM (p_pack_line_cd VARCHAR2, p_pack_subline_cd VARCHAR2) IS 
        SELECT item_no
          FROM gipi_witem a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND b.pack_par_id = p_pack_par_id
           AND pack_line_cd = p_pack_line_cd
           AND pack_subline_cd = p_pack_subline_cd;

    CURSOR AC (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_waccident_item a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id
           AND item_no = p_item_no;

    CURSOR AV (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_waviation_item a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR CA1 (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wcasualty_item a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;
           
    CURSOR CA2 (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wcasualty_personnel a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR CA3 (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wgrouped_items a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR CA4 (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wdeductibles a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR FI (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wfireitm a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR EN (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wdeductibles a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR MN (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wcargo a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR MH (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_witem_ves a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;

    CURSOR MC (p_item_no NUMBER) IS 
        SELECT '1'
          FROM gipi_wvehicle a, gipi_parlist b
         WHERE a.par_id = b.par_id
           AND pack_par_id = p_pack_par_id 
           AND item_no = p_item_no;
BEGIN
    BEGIN
        SELECT param_value_v
          INTO v_fi
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_FI';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_FI is not existing in giis_parameters.');
    END;
    BEGIN
        SELECT param_value_v
          INTO v_av
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_AV';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_AV is not existing in giis_parameters.');
    END;

    BEGIN
        SELECT param_value_v
          INTO v_mh
          FROM giis_parameters
          WHERE param_name LIKE 'LINE_CODE_MH';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_MH is not existing in giis_parameters.');
    END;

    BEGIN
        SELECT param_value_v
          INTO v_ca
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_CA';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_CA is not existing in giis_parameters.');
    END;

    BEGIN
        SELECT param_value_v
          INTO v_en
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_EN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_EN is not existing in giis_parameters.');
    END;

    BEGIN
        SELECT param_value_v
          INTO v_ac
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_AC';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_AC is not existing in giis_parameters.');
    END;

    BEGIN
        SELECT param_value_v
          INTO v_mn
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_MN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_MN is not existing in giis_parameters.');
    END;

    BEGIN
        SELECT param_value_v
          INTO v_mc
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_MC';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_MC is not existing in giis_parameters.');
    END;

    FOR PACK1 IN PACK
    LOOP
        FOR menu IN (
            SELECT menu_line_cd
              FROM giis_line
             WHERE line_cd = pack1.pack_line_cd)
        LOOP
            v_menu := menu.menu_line_cd;
            EXIT;
        END LOOP;
        
        v_count_item  := 0;
        v_count_ac    := 0;
        v_count_av    := 0;
        v_count_ca1   := 0;
        v_count_ca2   := 0;
        v_count_ca3   := 0;
        v_count_ca4   := 0;
        v_count_fi    := 0;
        v_count_en    := 0;
        v_count_mn    := 0;
        v_count_mh    := 0;
        v_count_mc    := 0;
        v_exists_ca   := 'N';
        
        FOR ITEM1 IN ITEM(PACK1.PACK_LINE_CD, PACK1.PACK_SUBLINE_CD)
        LOOP
            v_count_item := v_count_item + 1;
            
            IF PACK1.PACK_LINE_CD = v_ac OR v_menu = 'AC' THEN
                FOR AC1 IN AC(ITEM1.ITEM_NO) LOOP 
                   v_count_ac := v_count_ac + 1;
                END LOOP;
            END IF;
            
            IF PACK1.PACK_LINE_CD = v_av OR v_menu = 'AV' THEN
                FOR AV1 IN AV(ITEM1.ITEM_NO) LOOP 
                   v_count_av := v_count_av + 1;
                END LOOP;
            END IF;
            
            IF PACK1.PACK_LINE_CD = v_ca OR v_menu = 'CA' THEN      
                v_exists_ca := 'Y';
            END IF;

            IF PACK1.PACK_LINE_CD = v_fi OR v_menu = 'FI' THEN 
                FOR FI1 IN FI(ITEM1.ITEM_NO) LOOP 
                    v_count_fi := v_count_fi + 1;
                END LOOP;
            END IF;
            
            IF PACK1.PACK_LINE_CD = v_en OR v_menu = 'EN' THEN
                FOR EN1 IN EN(ITEM1.ITEM_NO) LOOP 
                    v_count_en := v_count_en + 1;
                END LOOP;
            END IF;

            IF PACK1.PACK_LINE_CD = v_mn OR v_menu = 'MN' THEN
                FOR MN1 IN MN(ITEM1.ITEM_NO) LOOP 
                    v_count_mn := v_count_mn + 1;
                END LOOP;
            END IF;

            IF PACK1.PACK_LINE_CD = v_mh OR v_menu = 'MH' THEN
                FOR MH1 IN MH(ITEM1.ITEM_NO) LOOP 
                    v_count_mh := v_count_mh + 1;
                END LOOP;
            END IF;

            IF PACK1.PACK_LINE_CD = v_mc OR v_menu = 'MC' THEN
                FOR MC1 IN MC(ITEM1.ITEM_NO) LOOP 
                    v_count_mc := v_count_mc + 1;
                END LOOP;
            END IF;
        END LOOP;
        
        IF v_count_item = v_count_ac OR    v_count_item = v_count_av OR
                v_count_item = v_count_fi OR v_count_item = v_count_en OR
                v_count_item = v_count_mn OR v_count_item = v_count_mh OR
                v_count_item = v_count_mc OR v_exists_ca = 'Y' THEN
            
            gipi_wpack_line_subline_pkg.update_item_tag(p_pack_par_id, pack1.pack_line_cd, pack1.pack_subline_cd, 'Y');
        ELSIF v_count_item != v_count_ac OR    v_count_item != v_count_av OR
                v_count_item != v_count_fi OR v_count_item != v_count_en OR
                v_count_item != v_count_mn OR v_count_item != v_count_mh OR
                v_count_item != v_count_mc OR v_exists_ca = 'N' THEN
            
            gipi_wpack_line_subline_pkg.update_item_tag(p_pack_par_id, pack1.pack_line_cd, pack1.pack_subline_cd, 'N');
        END IF;
        
        IF v_menu IS NULL AND PACK1.PACK_LINE_CD NOT IN (v_ac,
                v_av, v_ca, v_en, v_fi, v_mc, v_mh, v_mn) THEN
                
            gipi_wpack_line_subline_pkg.update_item_tag(p_pack_par_id, pack1.pack_line_cd, pack1.pack_subline_cd, 'Y');
        END IF;
    END LOOP;
    
    FOR C IN ( 
        SELECT pack_line_cd,pack_subline_cd, par_id
          FROM gipi_wpack_line_subline t1
         WHERE pack_par_id = p_pack_par_id
           AND NOT EXISTS (SELECT '1'
                             FROM gipi_witem
                            WHERE par_id = t1.par_id 
                              AND pack_line_cd = t1.pack_line_cd)
           AND NOT EXISTS (SELECT '1'
                             FROM gipi_witem
                            WHERE par_id = t1.par_id 
                              AND pack_subline_cd = t1.pack_subline_cd ))
    LOOP
        gipi_wpack_line_subline_pkg.update_item_tag(p_pack_par_id, c.pack_line_cd, c.pack_subline_cd, 'N');
        EXIT;
    END LOOP;
END UPD8_GIPI_WPACK_LINE_SUBLINE1;
/


