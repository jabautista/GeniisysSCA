CREATE OR REPLACE PACKAGE BODY CPI.GIXX_ACCIDENT_ITEM_PKG AS

    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  February 27, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves related accident item info 
    */
    FUNCTION get_accident_item(
        p_extract_id        gixx_accident_item.extract_id%TYPE,
        p_item_no           gixx_accident_item.item_no%TYPE
    ) RETURN accident_item_tab PIPELINED
    IS
        v_accident_item     accident_item_type;
    BEGIN
    
        FOR rec IN (SELECT extract_id, policy_id, item_no,
                           position_cd, monthly_salary, salary_grade,
                           date_of_birth, civil_status, age, 
                           sex, height, weight,
                           destination, no_of_persons
                      FROM gixx_accident_item
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no )
        LOOP
            v_accident_item.extract_id := rec.extract_id;
            v_accident_item.item_no := rec.item_no;
            v_accident_item.position_cd := rec.position_cd;
            v_accident_item.monthly_salary := rec.monthly_salary;
            v_accident_item.salary_grade := rec.salary_grade;
            v_accident_item.date_of_birth := rec.date_of_birth;
            v_accident_item.civil_status := rec.civil_status;
            v_accident_item.age := rec.age;
            v_accident_item.sex := rec.sex;
            v_accident_item.height := rec.height;
            v_accident_item.weight := rec.weight;
            v_accident_item.destination := rec.destination;
            v_accident_item.no_of_persons := rec.no_of_persons;           
            
            FOR a IN (SELECT from_date, to_date, item_title
                        FROM gixx_item
                       WHERE extract_id = p_extract_id
                         AND item_no = p_item_no)
            LOOP
                v_accident_item.travel_from_date := a.from_date;
                v_accident_item.travel_to_date := a.to_date;
                v_accident_item.item_title := a.item_title;
            END LOOP;
            
            FOR b IN (SELECT position              
                        FROM giis_position
                       WHERE position_cd = rec.position_cd)
            LOOP
                v_accident_item.position := b.position;
            END LOOP;
            
            FOR c IN (SELECT rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_low_value = rec.sex
                         AND rv_domain LIKE '%SEX%')
            LOOP
                v_accident_item.sex_desc := c.rv_meaning;
            END LOOP;
            
            FOR d IN (SELECT rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_low_value = rec.civil_status
                         AND rv_domain LIKE '%CIVIL%')
            LOOP
                v_accident_item.status := d.rv_meaning;
            END LOOP;
        
            PIPE ROW(v_accident_item);
            
        END LOOP;
        
    END get_accident_item;

END GIXX_ACCIDENT_ITEM_PKG;
/


