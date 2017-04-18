CREATE OR REPLACE PACKAGE CPI.GIPI_WCASUALTY_PERSONNEL_PKG
AS
	TYPE gipi_wcasualty_personnel_type IS RECORD (
		par_id			gipi_wcasualty_personnel.par_id%TYPE,
		item_no			gipi_wcasualty_personnel.item_no%TYPE,
		personnel_no	gipi_wcasualty_personnel.personnel_no%TYPE,
		name			gipi_wcasualty_personnel.name%TYPE,
		include_tag		gipi_wcasualty_personnel.include_tag%TYPE,
		capacity_cd		gipi_wcasualty_personnel.capacity_cd%TYPE,
		amount_covered	gipi_wcasualty_personnel.amount_covered%TYPE,
		remarks			gipi_wcasualty_personnel.remarks%TYPE, -- changed back to remarks by robert 09232013 -- mark jm 12.14.2011 change data type to clob
        delete_sw        gipi_wcasualty_personnel.delete_sw%TYPE,
        capacity_desc    giis_position.position%TYPE);
      
    TYPE gipi_wcasualty_personnel_tab IS TABLE OF gipi_wcasualty_personnel_type;

    FUNCTION get_gipi_wcasualty_personnels(p_par_id IN GIPI_WCASUALTY_PERSONNEL.par_id%TYPE)
    RETURN gipi_wcasualty_personnel_tab PIPELINED;    
    
  PROCEDURE set_gipi_wcasualty_personnels(
              p_par_id                GIPI_WCASUALTY_PERSONNEL.par_id%TYPE,
            p_item_no                GIPI_WCASUALTY_PERSONNEL.item_no%TYPE,
            p_personnel_no            GIPI_WCASUALTY_PERSONNEL.personnel_no%TYPE,
            p_name                    GIPI_WCASUALTY_PERSONNEL.name%TYPE,
            p_include_tag            GIPI_WCASUALTY_PERSONNEL.include_tag%TYPE,
            p_capacity_cd            GIPI_WCASUALTY_PERSONNEL.capacity_cd%TYPE,
            p_amount_covered        GIPI_WCASUALTY_PERSONNEL.amount_covered%TYPE,
            p_remarks                GIPI_WCASUALTY_PERSONNEL.remarks%TYPE
              );    

  PROCEDURE del_gipi_wcasualty_personnel(p_par_id    GIPI_WCASUALTY_PERSONNEL.par_id%TYPE,
                                           p_item_no   GIPI_WCASUALTY_PERSONNEL.item_no%TYPE);  

    FUNCTION get_gipi_wcas_prsnnel_pack_pol (
        p_par_id IN gipi_wcasualty_personnel.par_id%TYPE,
        p_item_no IN gipi_wcasualty_personnel.item_no%TYPE)
    RETURN gipi_wcasualty_personnel_tab PIPELINED;
    
    FUNCTION get_gipi_wcas_pers_tg(
        p_par_id IN gipi_wcasualty_personnel.par_id%TYPE,
        p_item_no IN gipi_wcasualty_personnel.item_no%TYPE,
        p_name IN VARCHAR2,
        p_position IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_wcasualty_personnel_tab PIPELINED;
    
    PROCEDURE del_gipi_wcasualty_personnel2(
        p_par_id IN gipi_wcasualty_personnel.par_id%TYPE,
        p_item_no IN gipi_wcasualty_personnel.item_no%TYPE,
        p_personnel_no IN gipi_wcasualty_personnel.personnel_no%TYPE);
END;
/


