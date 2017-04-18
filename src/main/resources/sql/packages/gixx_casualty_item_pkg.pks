CREATE OR REPLACE PACKAGE CPI.gixx_casualty_item_pkg 
AS
    -- added by Kris 03.05.2013 for GIPIS101
    TYPE gixx_casualty_item_type IS RECORD (
        extract_id                      gixx_casualty_item.extract_id%TYPE,
        item_no                         gixx_casualty_item.item_no%TYPE,
        policy_id                       gixx_casualty_item.policy_id%TYPE,
        location                        gixx_casualty_item.location%TYPE,
        section_or_hazard_cd            gixx_casualty_item.section_or_hazard_cd%TYPE,
        section_or_hazard_info          gixx_casualty_item.section_or_hazard_info%TYPE,
        interest_on_premises            gixx_casualty_item.interest_on_premises%TYPE,
        capacity_cd                     gixx_casualty_item.capacity_cd%TYPE,
        limit_of_liability              gixx_casualty_item.limit_of_liability%TYPE,
        conveyance_info                 gixx_casualty_item.conveyance_info%TYPE,
        property_no                     gixx_casualty_item.property_no%TYPE,
        property_no_type                gixx_casualty_item.property_no_type%TYPE,
        
        item_title                      gixx_item.item_title%TYPE,
        capacity_name                   giis_position.position%TYPE,
        section_or_hazard_title         giis_section_or_hazard.section_or_hazard_title%TYPE
    );
    
    TYPE gixx_casualty_item_tab IS TABLE OF gixx_casualty_item_type;
    
    FUNCTION get_casualty_item_info (
        p_extract_id        gixx_casualty_item.extract_id%TYPE,
        p_item_no           gixx_casualty_item.item_no%TYPE
    ) RETURN gixx_casualty_item_tab PIPELINED;
    -- end 03.05.2013 for GIPIS101
    
END gixx_casualty_item_pkg;
/


