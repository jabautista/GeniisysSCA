CREATE OR REPLACE PACKAGE CPI.GIPI_CASUALTY_ITEM_PKG AS
	TYPE gipi_casualty_item_type IS RECORD (
		policy_id				gipi_casualty_item.policy_id%TYPE,
		item_no					gipi_casualty_item.item_no%TYPE,
		section_line_cd			gipi_casualty_item.section_line_cd%TYPE,
		section_subline_cd		gipi_casualty_item.section_subline_cd%TYPE,
		section_or_hazard_cd	gipi_casualty_item.section_or_hazard_cd%TYPE,
		capacity_cd				gipi_casualty_item.capacity_cd%TYPE,
		property_no_type        gipi_casualty_item.property_no_type%TYPE,
        property_no                gipi_casualty_item.property_no%TYPE,
        location                gipi_casualty_item.location%TYPE,
        conveyance_info            gipi_casualty_item.conveyance_info%TYPE,
        interest_on_premises    gipi_casualty_item.interest_on_premises%TYPE,
        limit_of_liability        gipi_casualty_item.limit_of_liability%TYPE,
        section_or_hazard_info    gipi_casualty_item.section_or_hazard_info%TYPE,        
        arc_ext_data            gipi_casualty_item.arc_ext_data%TYPE,
        location_cd                gipi_casualty_item.location_cd%TYPE);
    
    TYPE gipi_casualty_item_tab IS TABLE OF gipi_casualty_item_type;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 09.30.2010
    **  Reference By     : (GIPIS061 - Endt Item Information - CA)
    **  Description     : This procedure is used for retrieving records on GIPI_CASUALTY_ITEM table
    */
    FUNCTION get_gipi_casualty_item (
        p_policy_id    IN gipi_casualty_item.policy_id%TYPE,
        p_item_no    IN gipi_casualty_item.item_no%TYPE)
    RETURN gipi_casualty_item_tab PIPELINED;
    
        TYPE casualty_item_info_type IS RECORD(
    
        item_title                  gipi_item.item_title%TYPE,
        item_no                     gipi_casualty_item.item_no%TYPE,
        location                    gipi_casualty_item.location%TYPE,
        policy_id                   gipi_casualty_item.policy_id%TYPE,
        capacity_cd                 gipi_casualty_item.capacity_cd%TYPE,
        property_no                 gipi_casualty_item.property_no%TYPE,
        section_line_cd             gipi_casualty_item.section_line_cd%TYPE,
        conveyance_info             gipi_casualty_item.conveyance_info%TYPE,
        property_no_type            gipi_casualty_item.property_no_type%TYPE,
        limit_of_liability          gipi_casualty_item.limit_of_liability%TYPE,
        section_subline_cd          gipi_casualty_item.section_subline_cd%TYPE,
        interest_on_premises        gipi_casualty_item.interest_on_premises%TYPE,
        section_or_hazard_cd        gipi_casualty_item.section_or_hazard_cd%TYPE,
        section_or_hazard_info      gipi_casualty_item.section_or_hazard_info%TYPE,

        
        capacity_name               giis_position.position%TYPE,
        location_cd                 gipi_casualty_item.location_cd%TYPE,
        location_desc               giis_ca_location.location_desc%TYPE,
        section_or_hazard_title     giis_section_or_hazard.section_or_hazard_title%TYPE
        
    );
    
    TYPE casualty_item_info_tab IS TABLE OF casualty_item_info_type;
    
    /*
    **  Created by        : Moses Calma
    **  Date Created     : 06.14.2011
    **  Reference By     : (GIPIS100 - Policy Information)
    **  Description     :  Retrieves additional information of a casualty item
    */
    FUNCTION get_casualty_item_info(
       p_policy_id   gipi_casualty_item.policy_id%TYPE,
       p_item_no     gipi_casualty_item.item_no%TYPE
    )
       RETURN casualty_item_info_tab PIPELINED;
       
       
END GIPI_CASUALTY_ITEM_PKG;
/


