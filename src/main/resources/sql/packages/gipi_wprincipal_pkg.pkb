CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WPRINCIPAL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure del_gipi_wprincipal (p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE)
	IS
	BEGIN
		DELETE GIPI_WPRINCIPAL
		 WHERE par_id   = p_par_id;
	END del_gipi_wprincipal;

    /*
	**  Created by		: D.Alcantara
	**  Date Created 	: 11.18.2010
	**  Reference By 	: (GIPIS045 - Additional Engineering Information)
	*/
    FUNCTION get_wprincipal_list(p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE)
        RETURN wprincipal_list_tab PIPELINED IS
        v_wprincipal       wprincipal_list_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id, a.principal_cd, b.principal_name, b.principal_type, a.engg_basic_infonum, a.subcon_sw
                FROM gipi_wprincipal a, giis_eng_principal b
            WHERE par_id = p_par_id
                  AND a.principal_cd = b.principal_cd
                  AND b.principal_type ='P'
            ORDER BY principal_cd)
        LOOP
            v_wprincipal.par_id             := i.par_id;
            v_wprincipal.principal_cd       := i.principal_cd;
            v_wprincipal.principal_name     := i.principal_name;
            v_wprincipal.principal_type     := i.principal_type;
            v_wprincipal.engg_basic_infonum := i.engg_basic_infonum;
            v_wprincipal.subcon_sw          := i.subcon_sw;
            PIPE ROW(v_wprincipal);
        END LOOP;

        RETURN;
    END get_wprincipal_list;

    FUNCTION get_contractor_list(p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE)
        RETURN wprincipal_list_tab PIPELINED IS
        v_wprincipal       wprincipal_list_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id, a.principal_cd, b.principal_name, b.principal_type, a.engg_basic_infonum, a.subcon_sw
                FROM gipi_wprincipal a, giis_eng_principal b
            WHERE par_id = p_par_id
                  AND a.principal_cd = b.principal_cd
                  AND b.principal_type = 'C'
            ORDER BY principal_cd)
        LOOP
            v_wprincipal.par_id             := i.par_id;
            v_wprincipal.principal_cd       := i.principal_cd;
            v_wprincipal.principal_name     := i.principal_name;
            v_wprincipal.principal_type     := i.principal_type;
            v_wprincipal.engg_basic_infonum := i.engg_basic_infonum;
            v_wprincipal.subcon_sw          := i.subcon_sw;
            PIPE ROW(v_wprincipal);
        END LOOP;

        RETURN;
    END get_contractor_list;

    PROCEDURE set_gipi_wprincipal (p_principal IN GIPI_WPRINCIPAL%ROWTYPE)
    IS
    BEGIN
        /*MERGE INTO gipi_wprincipal
        USING dual ON (par_id = p_principal.par_id and principal_cd = p_principal.principal_cd)
            WHEN NOT MATCHED THEN
                INSERT (par_id, principal_cd, engg_basic_infonum, subcon_sw)
                VALUES (p_principal.par_id, p_principal.principal_cd, p_principal.engg_basic_infonum, p_principal.subcon_sw)
            WHEN MATCHED THEN
                UPDATE SET principal_cd = p_principal.principal_cd,
                           engg_basic_infonum = p_principal.engg_basic_infonum,
                           subcon_sw = p_principal.subcon_sw;
        */

        INSERT INTO gipi_wprincipal (par_id, principal_cd, engg_basic_infonum, subcon_sw)
               VALUES (p_principal.par_id, p_principal.principal_cd, p_principal.engg_basic_infonum, p_principal.subcon_sw);
         COMMIT;
    END set_gipi_wprincipal;

    PROCEDURE del_gipi_en_wprincipal (p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE, p_pcd IN GIPI_WPRINCIPAL.principal_cd%TYPE)
    IS
    BEGIN
        DELETE GIPI_WPRINCIPAL
		 WHERE par_id   = p_par_id and principal_cd = p_pcd
               and engg_basic_infonum = 1;
    END;
	--added by robert SR 20307 10.27.15
	FUNCTION get_addl_info_principal_list (
      p_policy_id            GIPI_PRINCIPAL.policy_id%TYPE,
      p_extract_id           GIXX_PRINCIPAL.extract_id%TYPE,
      p_principal_type       GIIS_ENG_PRINCIPAL.principal_type%TYPE,
      p_summary_sw           VARCHAR2
    )
    RETURN wprincipal_list_tab PIPELINED
    IS
        v_wprincipal       wprincipal_list_type;
    BEGIN
        IF p_summary_sw = 'Y' THEN
            FOR i IN (
                SELECT a.principal_cd, b.principal_name,  a.subcon_sw
                  FROM gixx_principal a, giis_eng_principal b
                 WHERE a.extract_id = p_extract_id
                   AND a.principal_cd = b.principal_cd
                   AND b.principal_type = p_principal_type
                ORDER BY principal_cd)
            LOOP
                v_wprincipal.principal_cd       := i.principal_cd;
                v_wprincipal.principal_name     := i.principal_name;
                v_wprincipal.subcon_sw          := i.subcon_sw;
                PIPE ROW(v_wprincipal);
            END LOOP;
        ELSE
            FOR i IN (
                SELECT a.principal_cd, b.principal_name,  a.subcon_sw
                  FROM gipi_principal a, giis_eng_principal b
                 WHERE a.policy_id = p_policy_id
                   AND a.principal_cd = b.principal_cd
                   AND b.principal_type = p_principal_type
                ORDER BY principal_cd)
            LOOP
                v_wprincipal.principal_cd       := i.principal_cd;
                v_wprincipal.principal_name     := i.principal_name;
                v_wprincipal.subcon_sw          := i.subcon_sw;
                PIPE ROW(v_wprincipal);
            END LOOP;
        END IF;

        RETURN;
    END get_addl_info_principal_list;
END GIPI_WPRINCIPAL_PKG;
/


