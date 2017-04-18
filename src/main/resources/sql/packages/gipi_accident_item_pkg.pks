CREATE OR REPLACE PACKAGE CPI.GIPI_ACCIDENT_ITEM_PKG
AS
	TYPE gipi_accident_item_type IS RECORD (
		policy_id		gipi_accident_item.policy_id%TYPE,
		item_no			gipi_accident_item.item_no%TYPE,
		date_of_birth	gipi_accident_item.date_of_birth%TYPE,
		age				gipi_accident_item.age%TYPE,
		civil_status	gipi_accident_item.civil_status%TYPE,
		position_cd		gipi_accident_item.position_cd%TYPE,
		monthly_salary	gipi_accident_item.monthly_salary%TYPE,
		salary_grade	gipi_accident_item.salary_grade%TYPE,
		no_of_persons	gipi_accident_item.no_of_persons%TYPE,
		destination		gipi_accident_item.destination%TYPE,
		height			gipi_accident_item.height%TYPE,
		weight			gipi_accident_item.weight%TYPE,
		sex				gipi_accident_item.sex%TYPE,
		ac_class_cd		gipi_accident_item.ac_class_cd%TYPE,
		group_print_sw	gipi_accident_item.group_print_sw%TYPE,
		cpi_rec_no		gipi_accident_item.cpi_rec_no%TYPE,
		cpi_branch_cd	gipi_accident_item.cpi_branch_cd%TYPE,
		level_cd		gipi_accident_item.level_cd%TYPE,
		parent_level_cd	gipi_accident_item.parent_level_cd%TYPE,
		arc_ext_data	gipi_accident_item.arc_ext_data%TYPE);
	TYPE gipi_accident_item_tab IS TABLE OF gipi_accident_item_type;
	FUNCTION get_gipi_accident_item (
		p_policy_id IN gipi_accident_item.policy_id%TYPE,
		p_item_no IN gipi_accident_item.item_no%TYPE)
	RETURN gipi_accident_item_tab PIPELINED;
    
    TYPE accident_item_info_type IS RECORD(
        
        policy_id           gipi_accident_item.policy_id%TYPE,
        item_no             gipi_accident_item.item_no%TYPE,
        height              gipi_accident_item.height%TYPE,
        age                 gipi_accident_item.age%TYPE,
        sex                 gipi_accident_item.sex%TYPE,
        weight              gipi_accident_item.weight%TYPE,
        position_cd         gipi_accident_item.position_cd%TYPE,
        civil_status        gipi_accident_item.civil_status%TYPE,
        no_of_persons       gipi_accident_item.no_of_persons%TYPE,
        monthly_salary      gipi_accident_item.monthly_salary%TYPE,
        date_of_birth       gipi_accident_item.date_of_birth%TYPE,
        salary_grade        gipi_accident_item.salary_grade%TYPE,
        destination         gipi_accident_item.destination%TYPE,
        
        sex_desc            cg_ref_codes.rv_meaning%TYPE,
        position            giis_position.position%TYPE,
        status              VARCHAR2(20),

        travel_from_date    gipi_item.from_date%TYPE,
        travel_to_date      gipi_item.to_date%TYPE,

        item_title          gipi_item.item_title%TYPE,                                                                   
        payt_terms          gipi_item.payt_terms%TYPE,
        eff_from_date       gipi_item.from_date %TYPE,
        eff_to_date         gipi_item.to_date%TYPE,
        package_cd          giis_package_benefit.package_cd%TYPE       
            
    );
        
    TYPE accident_item_info_tab IS TABLE OF accident_item_info_type;
     
      FUNCTION get_accident_item_info(
         p_policy_id   gipi_accident_item.policy_id%TYPE,
         p_item_no     gipi_accident_item.item_no%TYPE
      )
         RETURN accident_item_info_tab PIPELINED;
         
END GIPI_ACCIDENT_ITEM_PKG;
/


