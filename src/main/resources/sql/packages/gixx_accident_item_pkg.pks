CREATE OR REPLACE PACKAGE CPI.GIXX_ACCIDENT_ITEM_PKG AS

    TYPE accident_item_type IS RECORD(
        extract_id          gixx_accident_item.extract_id%TYPE,
        item_no             gixx_accident_item.item_no%TYPE,
        date_of_birth       gixx_accident_item.date_of_birth%TYPE,
        age                 gixx_accident_item.age%TYPE,
        civil_status        gixx_accident_item.civil_status%TYPE,
        position_cd         gixx_accident_item.position_cd%TYPE,
        monthly_salary      gixx_accident_item.monthly_salary%TYPE,
        salary_grade        gixx_accident_item.salary_grade%TYPE,
        no_of_persons       gixx_accident_item.no_of_persons%TYPE,
        destination         gixx_accident_item.destination%TYPE,
        height              gixx_accident_item.height%TYPE,
        weight              gixx_accident_item.weight%TYPE,
        sex                 gixx_accident_item.sex%TYPE,
        policy_id           gixx_accident_item.policy_id%TYPE,
                
        position            giis_position.position%TYPE,
        sex_desc            cg_ref_codes.rv_meaning%TYPE,
        status              cg_ref_codes.rv_meaning%TYPE,
        travel_from_date    gixx_item.from_date%TYPE,
        travel_to_date      gixx_item.to_date%TYPE,
        item_title          gixx_item.item_title%TYPE
    );
    
    TYPE accident_item_tab IS TABLE OF accident_item_type;
    
    FUNCTION get_accident_item(
        p_extract_id        gixx_accident_item.extract_id%TYPE,
        p_item_no           gixx_accident_item.item_no%TYPE
    ) RETURN accident_item_tab PIPELINED;
    
END GIXX_ACCIDENT_ITEM_PKG;
/


