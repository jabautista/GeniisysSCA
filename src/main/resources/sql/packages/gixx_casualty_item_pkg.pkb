CREATE OR REPLACE PACKAGE BODY CPI.gixx_casualty_item_pkg AS

     /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 5, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves casualty item information
    */
    FUNCTION get_casualty_item_info (
        p_extract_id        gixx_casualty_item.extract_id%TYPE,
        p_item_no           gixx_casualty_item.item_no%TYPE
    ) RETURN gixx_casualty_item_tab PIPELINED
    IS
        v_casualty_item     gixx_casualty_item_type;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, policy_id, section_or_hazard_cd,
                           location, section_or_hazard_info, interest_on_premises,
                           capacity_cd, limit_of_liability, conveyance_info,
                           property_no_type, property_no,
                           section_line_cd, section_subline_cd
                      FROM gixx_casualty_item
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            BEGIN
        
             SELECT item_title 
               INTO v_casualty_item.item_title 
               FROM gixx_item
              WHERE extract_id = p_extract_id 
                AND item_no = p_item_no;
              
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    v_casualty_item.item_title    := '';
            END;
        
--            IF rec.property_no_type = 'S' THEN
--                v_casualty_item.property_text := 'Serial No.';
--            ELSIF rec.property_no_type = 'M' THEN
--                v_casualty_item.property_text := 'Motor No.';
--            ELSIF rec.property_no_type = 'E' THEN
--                v_casualty_item.property_text := 'Equipment No.';
--            ELSIF rec.property_no_type = 'C' THEN
--                v_casualty_item.property_text := 'Chassis No.';
--            ELSE
--                v_casualty_item.property_text := 'Property No.';
--            END IF;
        
            FOR a IN (SELECT section_or_hazard_title
                        FROM giis_section_or_hazard
                       WHERE section_line_cd = rec.section_line_cd
                         AND section_subline_cd = rec.section_subline_cd
                         AND section_or_hazard_cd = rec.section_or_hazard_cd)
            LOOP
                v_casualty_item.section_or_hazard_title := a.section_or_hazard_title;
            END LOOP;    
            
            FOR b IN (SELECT position
                        FROM giis_position
                       WHERE position_cd = rec.capacity_cd)
            LOOP
                v_casualty_item.capacity_name := b.position;
            END LOOP;
            
            v_casualty_item.extract_id := rec.extract_id;
            v_casualty_item.item_no := rec.item_no;
            v_casualty_item.policy_id := rec.policy_id;
            v_casualty_item.section_or_hazard_cd := rec.section_or_hazard_cd;
            v_casualty_item.location := rec.location;
            v_casualty_item.section_or_hazard_info := rec.section_or_hazard_info;
            v_casualty_item.interest_on_premises := rec.interest_on_premises;
            v_casualty_item.capacity_cd := rec.capacity_cd;
            v_casualty_item.limit_of_liability := rec.limit_of_liability;
            v_casualty_item.conveyance_info := rec.conveyance_info;
            v_casualty_item.property_no_type := rec.property_no_type;
            v_casualty_item.property_no := rec.property_no;
        
            PIPE ROW(v_casualty_item);
        END LOOP;
    
    END get_casualty_item_info;

END gixx_casualty_item_pkg;
/


