CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ACCIDENT_ITEM_PKG AS
	/*
    **  Created by		: Mark JM
    **  Date Created	: 05.05.2011
    **  Reference By	: (GIPIS065 - Endt Item Information - AC)
    **  Description     : This procedure is used for retrieving records on GIPI_ACCIDENT_ITEM table
    */
	FUNCTION get_gipi_accident_item (
		p_policy_id IN gipi_accident_item.policy_id%TYPE,
		p_item_no IN gipi_accident_item.item_no%TYPE)
	RETURN gipi_accident_item_tab PIPELINED
	IS
		v_accident gipi_accident_item_type;
	BEGIN
		FOR i IN (
			SELECT policy_id, item_no, date_of_birth, age,
				   civil_status, position_cd, monthly_salary, salary_grade,
				   no_of_persons, destination, height, weight,
				   sex, ac_class_cd, group_print_sw, cpi_rec_no, cpi_branch_cd,
				   level_cd, parent_level_cd, arc_ext_data
			  FROM gipi_accident_item
			 WHERE policy_id = p_policy_id
			   AND item_no = p_item_no)
		LOOP
			v_accident.policy_id		:= i.policy_id;
			v_accident.item_no			:= i.item_no;
			v_accident.date_of_birth	:= i.date_of_birth;
			v_accident.age				:= i.age;
			v_accident.civil_status		:= i.civil_status;
			v_accident.position_cd		:= i.position_cd;
			v_accident.monthly_salary	:= i.monthly_salary;
			v_accident.salary_grade		:= i.salary_grade;
			v_accident.no_of_persons	:= i.no_of_persons;
			v_accident.destination		:= i.destination;
			v_accident.height			:= i.height;
			v_accident.weight			:= i.weight;
			v_accident.sex				:= i.sex;
			v_accident.ac_class_cd		:= i.ac_class_cd;
			v_accident.group_print_sw	:= i.group_print_sw;
			v_accident.cpi_rec_no		:= i.cpi_rec_no;
			v_accident.cpi_branch_cd	:= i.cpi_branch_cd;
			v_accident.level_cd			:= i.level_cd;
			v_accident.parent_level_cd	:= i.parent_level_cd;
			v_accident.arc_ext_data		:= i.arc_ext_data;
			PIPE ROW(v_accident);
		END LOOP;
		RETURN;
	END get_gipi_accident_item;
    
  FUNCTION get_accident_item_info(
     p_policy_id   gipi_accident_item.policy_id%TYPE,
     p_item_no     gipi_accident_item.item_no%TYPE
  )
     RETURN accident_item_info_tab PIPELINED
  IS
    v_accident_item_info    accident_item_info_type;
    v_pack_ben_cd           gipi_item.pack_ben_cd%TYPE;
     
  BEGIN
     FOR i IN (SELECT policy_id, item_no, no_of_persons, position_cd, monthly_salary,
                      destination, salary_grade, date_of_birth, age, civil_status, sex,
                      height, weight
                 FROM gipi_accident_item
                WHERE policy_id = p_policy_id 
                  AND item_no = p_item_no)
     LOOP

        v_accident_item_info.policy_id          := i.policy_id;
        v_accident_item_info.item_no            := i.item_no;
        v_accident_item_info.height             := i.height;
        v_accident_item_info.age                := i.age;
        v_accident_item_info.sex                := i.sex;
        v_accident_item_info.weight             := i.weight;
        v_accident_item_info.position_cd        := i.position_cd;
        v_accident_item_info.civil_status       := i.civil_status;
        v_accident_item_info.no_of_persons      := i.no_of_persons;
        v_accident_item_info.monthly_salary     := i.monthly_salary;
        v_accident_item_info.date_of_birth      := i.date_of_birth;
        v_accident_item_info.salary_grade       := i.salary_grade;
        v_accident_item_info.destination        := i.destination;
        
        BEGIN
        
          SELECT item_title,payt_terms,from_date,to_date,pack_ben_cd, from_date, to_date
            INTO v_accident_item_info.item_title,
                 v_accident_item_info.payt_terms,
                 v_accident_item_info.eff_from_date,
                 v_accident_item_info.eff_to_date,
                 v_pack_ben_cd,
                 v_accident_item_info.travel_from_date,
                 v_accident_item_info.travel_to_date
            FROM gipi_item
           WHERE policy_id = i.policy_id 
             AND item_no = i.item_no;
              
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
        
          v_accident_item_info.item_title       := '';
          v_accident_item_info.payt_terms       := '';
          v_accident_item_info.eff_from_date    := '';
          v_accident_item_info.eff_to_date      := '';
          v_accident_item_info.travel_from_date := NULL;
          v_accident_item_info.travel_to_date   := NULL;
          
        END;
        
        BEGIN
        
          SELECT package_cd
            INTO v_accident_item_info.package_cd
            FROM giis_package_benefit
           WHERE pack_ben_cd = v_pack_ben_cd;
        
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
        
          v_accident_item_info.package_cd := '';
        
        END;
        
        BEGIN
            
          SELECT position
            INTO v_accident_item_info.position
            FROM giis_position
           WHERE position_cd = i.position_cd;
           
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
        
          v_accident_item_info.position := '';
        
        END;
        
        BEGIN
        
          SELECT DECODE (civil_status,
                         'D', 'Divorced',
                         'S', 'Single',
                         'M', 'Married',
                         'L', 'Legally Separated',
                         'W', 'Widow(er)'
                      ) status
            INTO v_accident_item_info.status
            FROM gipi_accident_item
           WHERE policy_id = i.policy_id 
             AND item_no = i.item_no;
        
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
        
          v_accident_item_info.status := '';
          
        
        END;
        
        BEGIN
        
          SELECT rv_meaning
            INTO v_accident_item_info.sex_desc
            FROM cg_ref_codes
           WHERE rv_low_value = i.sex 
             AND rv_domain LIKE '%SEX%';
        
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
        
          v_accident_item_info.sex_desc := '';
        
        END;
        
        PIPE ROW (v_accident_item_info);
     END LOOP;
  END get_accident_item_info;
      
END GIPI_ACCIDENT_ITEM_PKG;
/


