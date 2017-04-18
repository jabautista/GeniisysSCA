CREATE OR REPLACE PACKAGE CPI.GIPI_WPRINCIPAL_PKG
AS

    TYPE wprincipal_list_type IS RECORD
    ( par_id               GIPI_WPRINCIPAL.par_id%TYPE,
      principal_cd         GIPI_WPRINCIPAL.principal_cd%TYPE,
      engg_basic_infonum   GIPI_WPRINCIPAL.engg_basic_infonum%TYPE,
      subcon_sw            GIPI_WPRINCIPAL.subcon_sw%TYPE,
      principal_name       GIIS_ENG_PRINCIPAL.principal_name%TYPE,
      principal_type       GIIS_ENG_PRINCIPAL.principal_type%TYPE);

    TYPE wprincipal_list_tab IS TABLE OF wprincipal_list_type;
    
    FUNCTION get_wprincipal_list(p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE) 
        RETURN wprincipal_list_tab PIPELINED;
    
    FUNCTION get_contractor_list(p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE) 
        RETURN wprincipal_list_tab PIPELINED;

	PROCEDURE del_gipi_wprincipal (p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE);
    
    PROCEDURE set_gipi_wprincipal (p_principal IN GIPI_WPRINCIPAL%ROWTYPE);
    
    PROCEDURE del_gipi_en_wprincipal (p_par_id IN GIPI_WPRINCIPAL.par_id%TYPE, p_pcd IN GIPI_WPRINCIPAL.principal_cd%TYPE);
	--added by robert SR 20307 10.27.15
	FUNCTION get_addl_info_principal_list (
      p_policy_id            GIPI_PRINCIPAL.policy_id%TYPE,
      p_extract_id           GIXX_PRINCIPAL.extract_id%TYPE,
      p_principal_type       GIIS_ENG_PRINCIPAL.principal_type%TYPE,
      p_summary_sw           VARCHAR2
    )
    RETURN wprincipal_list_tab PIPELINED;
END GIPI_WPRINCIPAL_PKG;
/


