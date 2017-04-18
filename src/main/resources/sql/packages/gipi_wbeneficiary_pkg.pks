CREATE OR REPLACE PACKAGE CPI.gipi_wbeneficiary_pkg
AS
  TYPE gipi_wbeneficiary_type IS RECORD (
  	   par_id 				  GIPI_WBENEFICIARY.par_id%TYPE,
	   item_no				  GIPI_WBENEFICIARY.item_no%TYPE,
	   beneficiary_no		  GIPI_WBENEFICIARY.beneficiary_no%TYPE,
	   beneficiary_name		  GIPI_WBENEFICIARY.beneficiary_name%TYPE,
	   beneficiary_addr		  GIPI_WBENEFICIARY.beneficiary_addr%TYPE,
	   delete_sw			  GIPI_WBENEFICIARY.delete_sw%TYPE,
	   relation				  GIPI_WBENEFICIARY.relation%TYPE,
	   remarks				  GIPI_WBENEFICIARY.remarks%TYPE,
	   adult_sw				  GIPI_WBENEFICIARY.adult_sw%TYPE,
	   age					  GIPI_WBENEFICIARY.age%TYPE,
	   civil_status			  GIPI_WBENEFICIARY.civil_status%TYPE,
	   date_of_birth		  GIPI_WBENEFICIARY.date_of_birth%TYPE,
	   position_cd			  GIPI_WBENEFICIARY.position_cd%TYPE,
	   sex					  GIPI_WBENEFICIARY.sex%TYPE
 	   );
	 
  TYPE gipi_wbeneficiary_tab IS TABLE OF gipi_wbeneficiary_type;      

  FUNCTION get_gipi_wbeneficiary (p_par_id GIPI_WBENEFICIARY.par_id%TYPE)
    RETURN gipi_wbeneficiary_tab PIPELINED;
    
  Procedure set_gipi_wbeneficiary(
              p_par_id                   GIPI_WBENEFICIARY.par_id%TYPE,
               p_item_no                  GIPI_WBENEFICIARY.item_no%TYPE,
               p_beneficiary_no          GIPI_WBENEFICIARY.beneficiary_no%TYPE,
               p_beneficiary_name          GIPI_WBENEFICIARY.beneficiary_name%TYPE,
               p_beneficiary_addr          GIPI_WBENEFICIARY.beneficiary_addr%TYPE,
            p_relation                  GIPI_WBENEFICIARY.relation%TYPE,
            p_date_of_birth                GIPI_WBENEFICIARY.date_of_birth%TYPE,
            p_age                      GIPI_WBENEFICIARY.age%TYPE,
               p_remarks                  GIPI_WBENEFICIARY.remarks%TYPE
            );    
  
  Procedure del_gipi_wbeneficiary(p_par_id    GIPI_WBENEFICIARY.par_id%TYPE,
                                    p_item_no   GIPI_WBENEFICIARY.item_no%TYPE);

  Procedure del_gipi_wbeneficiary2(p_par_id           GIPI_WBENEFICIARY.par_id%TYPE,
                                     p_item_no          GIPI_WBENEFICIARY.item_no%TYPE,
                                   p_beneficiary_no      GIPI_WBENEFICIARY.beneficiary_no%TYPE);
    
    Procedure del_gipi_wbeneficiary (p_par_id IN GIPI_WBENEFICIARY.par_id%TYPE);
    
    FUNCTION get_gipi_wbeneficiary_tg (
        p_par_id IN gipi_wbeneficiary.par_id%TYPE,
        p_item_no IN gipi_wbeneficiary.item_no%TYPE,
        p_beneficiary_name IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_wbeneficiary_tab PIPELINED;
        
END;
/


