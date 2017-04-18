CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WLOCATION_PKG
AS
	/*
	**  Created by		: Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id
    */
    Procedure del_gipi_wlocation (p_par_id IN GIPI_WLOCATION.par_id%TYPE)
    IS
    BEGIN
        DELETE GIPI_WLOCATION
         WHERE par_id = p_par_id;
    END del_gipi_wlocation;

    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 01.11.2011
    **  Reference By     : (GIPIS004 - Engineering Item Screen)
    **  Description     :     Retrives record from gipi_wlocation based on par_id
    */
    FUNCTION get_item_wlocations (p_par_id IN GIPI_WLOCATION.par_id%TYPE) RETURN gipi_wloc_item_tab PIPELINED
    IS
        v_wloc  gipi_wloc_item_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no FROM gipi_wlocation
            WHERE par_id = p_par_id)
        LOOP
            v_wloc.par_id := i.par_id;
            v_wloc.item_no := i.item_no;
            PIPE ROW(v_wloc);
        END LOOP;
        RETURN;
    END get_item_wlocations;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.21.2011
    **  Reference By     : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve records from gipi_wlocation based on the given parameters
    */
    FUNCTION get_gipi_wlocation_pack_pol (
        p_par_id IN gipi_wlocation.par_id%TYPE,
        p_item_no IN gipi_wlocation.item_no%TYPE)
    RETURN gipi_wloc_item_tab PIPELINED
    IS
        v_loc gipi_wloc_item_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wlocation
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_loc.par_id         := i.par_id;
            v_loc.item_no        := i.item_no;

            PIPE ROW(v_loc);
        END LOOP;

        RETURN;
    END get_gipi_wlocation_pack_pol;

    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 01.13.2011
    **  Reference By     : (GIPIS004 - Engineering Item Screen)
    **  Description     : Saves records in gipi_wlocation
    */
    PROCEDURE set_gipi_wlocation (p_par_id IN GIPI_WLOCATION.par_id%TYPE,
                                  p_item_no IN GIPI_WLOCATION.item_no%TYPE,
                                  p_region_cd IN GIPI_WLOCATION.region_cd%TYPE,
                                  p_province_cd IN GIPI_WLOCATION.province_cd%TYPE)
    IS
    BEGIN
        MERGE INTO gipi_wlocation
        USING DUAL ON (par_id = p_par_id AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, region_cd, province_cd)
            VALUES (p_par_id, p_item_no, p_region_cd, p_province_cd)
        WHEN MATCHED THEN
            UPDATE
                SET region_cd = p_region_cd,
                    province_cd = p_province_cd;
    END set_gipi_wlocation;

    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 01.13.2011
    **  Reference By     : (GIPIS004 - Engineering Item Screen)
    **  Description     : Deletes a record in qipi_wlocation based on par_id and item_no
    */
    PROCEDURE del_gipi_wlocation2 (p_par_id IN GIPI_WLOCATION.par_id%TYPE, p_item_no IN GIPI_WLOCATION.item_no%TYPE)
    IS
    BEGIN
        DELETE gipi_wlocation
        WHERE par_id = p_par_id
              AND item_no = p_item_no;
    END del_gipi_wlocation2;
END GIPI_WLOCATION_PKG;
/


