CREATE OR REPLACE PACKAGE CPI.Giis_Assd_Ind_Info_Pkg AS

  TYPE giis_assd_ind_info_type IS RECORD
    (assd_no				GIIS_ASSD_IND_INFO.assd_no%TYPE,
	 birthdate				GIIS_ASSD_IND_INFO.birthdate%TYPE,	
 	 sex					GIIS_ASSD_IND_INFO.sex%TYPE,
	 status					GIIS_ASSD_IND_INFO.status%TYPE,
	 spouse_assd_no			GIIS_ASSD_IND_INFO.spouse_assd_no%TYPE,
	 spouse_name			GIIS_ASSD_IND_INFO.spouse_name%TYPE,
	 citizenship			GIIS_ASSD_IND_INFO.citizenship%TYPE,
	 address1				GIIS_ASSD_IND_INFO.address1%TYPE,
	 address2				GIIS_ASSD_IND_INFO.address2%TYPE,
 	 address3				GIIS_ASSD_IND_INFO.address3%TYPE,
	 phone_no				GIIS_ASSD_IND_INFO.phone_no%TYPE,
	 home_fax				GIIS_ASSD_IND_INFO.home_fax%TYPE,
	 office_fax				GIIS_ASSD_IND_INFO.office_fax%TYPE,
	 pager_no				GIIS_ASSD_IND_INFO.pager_no%TYPE,
	 cellphone_no			GIIS_ASSD_IND_INFO.cellphone_no%TYPE,
	 email_addr				GIIS_ASSD_IND_INFO.email_addr%TYPE,
	 home_own				GIIS_ASSD_IND_INFO.home_own%TYPE,
	 home_yy				GIIS_ASSD_IND_INFO.home_yy%TYPE,
	 home_mm				GIIS_ASSD_IND_INFO.home_mm%TYPE,
	 mort_name				GIIS_ASSD_IND_INFO.mort_name%TYPE,
	 rent_amt				GIIS_ASSD_IND_INFO.rent_amt%TYPE,
	 educ_attainment		GIIS_ASSD_IND_INFO.educ_attainment%TYPE,
	 no_of_car				GIIS_ASSD_IND_INFO.no_of_car%TYPE,
	 employment				GIIS_ASSD_IND_INFO.employment%TYPE,
	 bus_nature				GIIS_ASSD_IND_INFO.bus_nature%TYPE,
	 oth_nature				GIIS_ASSD_IND_INFO.oth_nature%TYPE,
	 company_name			GIIS_ASSD_IND_INFO.company_name%TYPE,
 	 company_address1		GIIS_ASSD_IND_INFO.company_address1%TYPE,
	 position				GIIS_ASSD_IND_INFO.position%TYPE,
	 gr_ann_income			GIIS_ASSD_IND_INFO.gr_ann_income%TYPE);
	 
  TYPE giis_assd_ind_info_tab IS TABLE OF giis_assd_ind_info_type; 
   
  FUNCTION get_giis_assd_ind_info (p_assd_no	GIIS_ASSD_IND_INFO.assd_no%TYPE)
    RETURN giis_assd_ind_info_tab PIPELINED;
	
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
	 v_gr_ann_income		IN  GIIS_ASSD_IND_INFO.gr_ann_income%TYPE);
	 
  
  PROCEDURE del_giis_assd_ind_info (p_assd_no	GIIS_ASSD_IND_INFO.assd_no%TYPE);
  
  PROCEDURE copy_individual_info(
      p_assd_no             IN  GIIS_ASSD_IND_INFO.assd_no%TYPE,
      p_email_addr          IN  GIIS_ASSD_IND_INFO.email_addr%TYPE,
      p_birth_date          IN  VARCHAR2,
      p_birth_month         IN  VARCHAR2,
      p_birth_year          IN  VARCHAR2
  );
  
  PROCEDURE copy_assured_info(
      p_assd_no               IN  GIIS_ASSD_IND_INFO.assd_no%TYPE,
      p_email_addr            IN  GIIS_ASSD_IND_INFO.email_addr%TYPE,
      p_birthday              IN  GIIS_ASSD_IND_INFO.birthdate%TYPE
  );

END Giis_Assd_Ind_Info_Pkg;
/


