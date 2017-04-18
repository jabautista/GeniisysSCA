CREATE OR REPLACE PACKAGE BODY CPI.Giis_Assd_Ind_Info_Pkg AS

  FUNCTION get_giis_assd_ind_info (p_assd_no	GIIS_ASSD_IND_INFO.assd_no%TYPE)
    RETURN giis_assd_ind_info_tab PIPELINED IS
	
	v_info 		giis_assd_ind_info_type;
	
  BEGIN
  	FOR i IN (
		SELECT assd_no,     birthdate, 		 sex,              status,     spouse_assd_no, 
			   spouse_name, citizenship, 	 address1, 		   address2,   address3, 
			   phone_no,  	home_fax, 		 office_fax, 	   pager_no,   cellphone_no, 
			   email_addr,  home_own, 		 home_yy, 		   home_mm,    mort_name, 
			   rent_amt, 	educ_attainment, no_of_car, 	   employment, bus_nature, 
			   oth_nature,  company_name, 	 company_address1, position,   gr_ann_income
		  FROM GIIS_ASSD_IND_INFO
		 WHERE assd_no = p_assd_no)
	LOOP
		v_info.assd_no				:= i.assd_no;
	 	v_info.birthdate			:= i.birthdate;	
 	 	v_info.sex					:= i.sex;
	 	v_info.status				:= i.status;
	 	v_info.spouse_assd_no		:= i.spouse_assd_no;
	 	v_info.spouse_name			:= i.spouse_name;
	 	v_info.citizenship			:= i.citizenship;
	 	v_info.address1				:= i.address1;
	 	v_info.address2				:= i.address2;
 	 	v_info.address3				:= i.address3;
	 	v_info.phone_no				:= i.phone_no;
	 	v_info.home_fax				:= i.home_fax;
	 	v_info.office_fax			:= i.office_fax;
	 	v_info.pager_no				:= i.pager_no;
	 	v_info.cellphone_no			:= i.cellphone_no;
	 	v_info.email_addr			:= i.email_addr;
		v_info.home_own				:= i.home_own;
	 	v_info.home_yy				:= i.home_yy;
	 	v_info.home_mm				:= i.home_mm;
	 	v_info.mort_name			:= i.mort_name;
	 	v_info.rent_amt				:= i.rent_amt;
	 	v_info.educ_attainment		:= i.educ_attainment;
	 	v_info.no_of_car			:= i.no_of_car;
	 	v_info.employment			:= i.employment;
	 	v_info.bus_nature			:= i.bus_nature;
	 	v_info.oth_nature			:= i.oth_nature;
	 	v_info.company_name			:= i.company_name;
 	 	v_info.company_address1		:= i.company_address1;
	 	v_info.position				:= i.position;
	 	v_info.gr_ann_income		:= i.gr_ann_income;
	  PIPE ROW(v_info);
	END LOOP;
  
    RETURN;
  END get_giis_assd_ind_info;
  
  PROCEDURE set_giis_assd_ind_info (
  	 v_assd_no				IN  GIIS_ASSD_IND_INFO.assd_no%TYPE,
	 v_birthdate			IN  GIIS_ASSD_IND_INFO.birthdate%TYPE,	
 	 v_sex					IN  GIIS_ASSD_IND_INFO.sex%TYPE,
	 v_status				IN  GIIS_ASSD_IND_INFO.status%TYPE,
	 v_spouse_assd_no		IN  GIIS_ASSD_IND_INFO.spouse_assd_no%TYPE,
	 v_spouse_name			IN  GIIS_ASSD_IND_INFO.spouse_name%TYPE,
	 v_citizenship			IN  GIIS_ASSD_IND_INFO.citizenship%TYPE,
	 v_address1				IN  GIIS_ASSD_IND_INFO.address1%TYPE,
	 v_address2				IN  GIIS_ASSD_IND_INFO.address2%TYPE,
 	 v_address3				IN  GIIS_ASSD_IND_INFO.address3%TYPE,
	 v_phone_no				IN  GIIS_ASSD_IND_INFO.phone_no%TYPE,
	 v_home_fax				IN  GIIS_ASSD_IND_INFO.home_fax%TYPE,
	 v_office_fax			IN  GIIS_ASSD_IND_INFO.office_fax%TYPE,
	 v_pager_no				IN  GIIS_ASSD_IND_INFO.pager_no%TYPE,
	 v_cellphone_no			IN  GIIS_ASSD_IND_INFO.cellphone_no%TYPE,
	 v_email_addr			IN  GIIS_ASSD_IND_INFO.email_addr%TYPE,
	 v_home_own				IN  GIIS_ASSD_IND_INFO.home_own%TYPE,
	 v_home_yy				IN  GIIS_ASSD_IND_INFO.home_yy%TYPE,
	 v_home_mm				IN  GIIS_ASSD_IND_INFO.home_mm%TYPE,
	 v_mort_name			IN  GIIS_ASSD_IND_INFO.mort_name%TYPE,
	 v_rent_amt				IN  GIIS_ASSD_IND_INFO.rent_amt%TYPE,
	 v_educ_attainment		IN  GIIS_ASSD_IND_INFO.educ_attainment%TYPE,
	 v_no_of_car			IN  GIIS_ASSD_IND_INFO.no_of_car%TYPE,
	 v_employment			IN  GIIS_ASSD_IND_INFO.employment%TYPE,
	 v_bus_nature			IN  GIIS_ASSD_IND_INFO.bus_nature%TYPE,
	 v_oth_nature			IN  GIIS_ASSD_IND_INFO.oth_nature%TYPE,
	 v_company_name			IN  GIIS_ASSD_IND_INFO.company_name%TYPE,
 	 v_company_address1		IN  GIIS_ASSD_IND_INFO.company_address1%TYPE,
	 v_position				IN  GIIS_ASSD_IND_INFO.position%TYPE,
	 v_gr_ann_income		IN  GIIS_ASSD_IND_INFO.gr_ann_income%TYPE) IS

	 BEGIN
	 
	   MERGE INTO GIIS_ASSD_IND_INFO
	   USING DUAL ON (assd_no = v_assd_no)
	    WHEN MATCHED THEN
	   	  	 UPDATE SET birthdate			= v_birthdate,	
			  	 		sex					= v_sex,
			 	 		status				= v_status,
	 			 		spouse_assd_no		= v_spouse_assd_no,
	 			 		spouse_name			= v_spouse_name,
	 			 		citizenship			= v_citizenship,
	 			 		address1			= v_address1,
	 			 		address2			= v_address2,
 	 			 		address3			= v_address3,
	 			 		phone_no			= v_phone_no,
	 			 		home_fax			= v_home_fax,
	 			 		office_fax			= v_office_fax,
	 			 		pager_no			= v_pager_no,
	 			 		cellphone_no		= v_cellphone_no,
	 			 		email_addr			= v_email_addr,
	 			 		home_own			= v_home_own,
	 			 		home_yy				= v_home_yy,
	 			 		home_mm				= v_home_mm,
	 			 		mort_name			= v_mort_name,
	 			 		rent_amt			= v_rent_amt,
				 		educ_attainment	    = v_educ_attainment,
	 			 		no_of_car			= v_no_of_car,
	 			 		employment			= v_employment,
	 			 		bus_nature			= v_bus_nature,
	 			 		oth_nature			= v_oth_nature,
	 			 		company_name		= v_company_name,
 				 		company_address1	= v_company_address1,
	 			 		position			= v_position,
	 			 		gr_ann_income		= v_gr_ann_income
		WHEN NOT MATCHED THEN	   
	   	  	 INSERT (assd_no, 		 birthdate,        sex,   		    status,  			spouse_assd_no,      spouse_name, 
					 citizenship, 	 address1, 		   address2, 		address3, 			phone_no, 			 home_fax, 
					 office_fax, 	 pager_no, 		   cellphone_no, 	email_addr,			home_own, 			 home_yy, 
					 home_mm, 		 mort_name, 	   rent_amt,		educ_attainment, 	no_of_car, 			 employment,
	 		   		 bus_nature, 	 oth_nature, 	   company_name, 	company_address1, 	position, 			 gr_ann_income)
		  	 VALUES (v_assd_no,      v_birthdate, 	   v_sex, 		    v_status,           v_spouse_assd_no,    v_spouse_name, 
			   		 v_citizenship,  v_address1,  	   v_address2, 		v_address3, 		v_phone_no, 		 v_home_fax, 
					 v_office_fax,   v_pager_no,  	   v_cellphone_no, 	v_email_addr, 		v_home_own, 		 v_home_yy,
					 v_home_mm, 	 v_mort_name, 	   v_rent_amt, 		v_educ_attainment, 	v_no_of_car, 		 v_employment,
	 		   		 v_bus_nature,   v_oth_nature,     v_company_name, 	v_company_address1, v_position, 		 v_gr_ann_income);
					 
	   --COMMIT; commented by: Nica 06.04.2012					
  END set_giis_assd_ind_info;
	 
  
  PROCEDURE del_giis_assd_ind_info (p_assd_no	GIIS_ASSD_IND_INFO.assd_no%TYPE) IS
  BEGIN
  
    DELETE FROM giis_assd_ind_info
	 WHERE assd_no = p_assd_no;
	   
    --COMMIT; commented by: Nica 06.04.2012
  END del_giis_assd_ind_info;	 

    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : 02.01.2013
    ** Referenced by : (GIISS006B - Maintain Assured)
    ** Description   : Copy information to GIIS_ASSD_IND_INFO (UCPB Assured Maintenance Enhancement)
    */  
    PROCEDURE copy_individual_info(
        p_assd_no             IN  GIIS_ASSD_IND_INFO.assd_no%TYPE,
        p_email_addr          IN  GIIS_ASSD_IND_INFO.email_addr%TYPE,
        p_birth_date          IN  VARCHAR2,
        p_birth_month         IN  VARCHAR2,
        p_birth_year          IN  VARCHAR2
    )
    IS
        v_birthday                VARCHAR2(50) := NULL;
    BEGIN
        IF p_birth_date IS NOT NULL AND p_birth_month IS NOT NULL AND p_birth_year IS NOT NULL THEN
            v_birthday := TO_CHAR(TO_DATE(p_birth_month, 'MM'), 'MM') || '/' || p_birth_date || '/' || p_birth_year;
        END IF;
    
        MERGE INTO GIIS_ASSD_IND_INFO
        USING DUAL ON (assd_no = p_assd_no)
         WHEN MATCHED THEN
              UPDATE SET email_addr = p_email_addr,
                         birthdate = TO_DATE(v_birthday, 'mm/dd/yyyy')
         WHEN NOT MATCHED THEN
              INSERT (assd_no, email_addr, birthdate)
              VALUES (p_assd_no, p_email_addr, TO_DATE(v_birthday, 'mm/dd/yyyy'));
    END;
      
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : 02.04.2013
    ** Referenced by : (GIISS006B - Maintain Assured)
    ** Description   : Copy Information to GIIS_ASSURED (UCPB Assured Maintenance Enhancement)
    */
    PROCEDURE copy_assured_info(
        p_assd_no               IN  GIIS_ASSD_IND_INFO.assd_no%TYPE,
        p_email_addr            IN  GIIS_ASSD_IND_INFO.email_addr%TYPE,
        p_birthday              IN  GIIS_ASSD_IND_INFO.birthdate%TYPE
    )
    IS
        v_birth_date                VARCHAR2(2);
        v_birth_month               VARCHAR2(20);
        v_birth_year                VARCHAR2(4);
    BEGIN
        BEGIN
            SELECT TRIM(TO_CHAR(p_birthday, 'DD')),
                   TRIM(TO_CHAR(p_birthday, 'Month')),
                   TRIM(TO_CHAR(p_birthday, 'YYYY'))
              INTO v_birth_date,
                   v_birth_month,
                   v_birth_year
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS THEN
                v_birth_date := NULL;
                v_birth_month := NULL;
                v_birth_year := NULL;
        END;
    
        UPDATE GIIS_ASSURED
           SET email_address = p_email_addr,
               birth_date = v_birth_date,
               birth_month = v_birth_month,
               birth_year = v_birth_year
         WHERE assd_no = p_assd_no;
    END;

END Giis_Assd_Ind_Info_Pkg;
/


