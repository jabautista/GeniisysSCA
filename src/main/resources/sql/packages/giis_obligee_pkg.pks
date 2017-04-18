CREATE OR REPLACE PACKAGE CPI.GIIS_OBLIGEE_PKG AS
  TYPE giis_obligee_type IS RECORD(
    obligee_no		giis_obligee.obligee_no%TYPE,
	obligee_name	giis_obligee.obligee_name%TYPE,
	address		    VARCHAR2(4000),
    contact_person  giis_obligee.CONTACT_PERSON%TYPE,-- mkfelipe_20120925: inserted additional details of obligee to display
    designation     giis_obligee.DESIGNATION%TYPE,
    phone_no        giis_obligee.PHONE_NO%TYPE,
    remarks         giis_obligee.REMARKS%TYPE,
    cpi_rec_no      giis_obligee.CPI_REC_NO%TYPE,
    cpi_branch_cd   giis_obligee.CPI_BRANCH_CD%TYPE,
    address1        GIIS_OBLIGEE.address1%TYPE, -- marco - 05.02.2013
    address2        GIIS_OBLIGEE.address2%TYPE, --
    address3        GIIS_OBLIGEE.address3%TYPE,  --
    user_id         GIIS_OBLIGEE.user_id%TYPE,
    last_update_str     VARCHAR2(30) --GIIS_OBLIGEE.last_update%TYPE
  );
	 
  TYPE giis_obligee_tab IS TABLE OF giis_obligee_type;
  
  FUNCTION get_obligee_list(
    p_obligee_no    GIIS_OBLIGEE.OBLIGEE_NO%TYPE,
    p_obligee_name  GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
    p_address       VARCHAR2,
    p_contact_person  giis_obligee.CONTACT_PERSON%TYPE,
    p_designation     giis_obligee.DESIGNATION%TYPE,
    p_phone_no        giis_obligee.PHONE_NO%TYPE,
    p_remarks         giis_obligee.REMARKS%TYPE
  )
    RETURN giis_obligee_tab PIPELINED;
	
  FUNCTION get_obligee_name(p_obligee_no			 giis_obligee.obligee_no%TYPE)
    RETURN VARCHAR2;
  
  TYPE giis_obligee_type2 IS RECORD(
    obligee_no      giis_obligee.obligee_no%TYPE,
    obligee_name    giis_obligee.obligee_name%TYPE,
    address		    VARCHAR2(4000),
    contact_person  giis_obligee.CONTACT_PERSON%TYPE,
    designation     giis_obligee.DESIGNATION%TYPE,
    phone_no        giis_obligee.PHONE_NO%TYPE,
    remarks         giis_obligee.REMARKS%TYPE,
    cpi_rec_no      giis_obligee.CPI_REC_NO%TYPE,
    cpi_branch_cd   giis_obligee.CPI_BRANCH_CD%TYPE  
  );
  
  TYPE giis_obligee_tab2 IS TABLE OF giis_obligee_type2;
  
  FUNCTION get_obligee_list2(p_keyword    giis_obligee.obligee_name%TYPE)
    RETURN giis_obligee_tab2 PIPELINED;
    
    
  FUNCTION get_obligee_details(p_obligee_no giis_obligee.OBLIGEE_NO%TYPE)
    RETURN giis_obligee_type2;
    
  PROCEDURE set_giis_obligee (
    p_obligee_no        IN  giis_obligee.OBLIGEE_NO%TYPE,
    p_obligee_name      IN  giis_obligee.OBLIGEE_NAME%TYPE,
    p_address           IN  VARCHAR2,
    p_contact_person    IN  giis_obligee.CONTACT_PERSON%TYPE,
    p_designation       IN  giis_obligee.DESIGNATION%TYPE,
    p_phone_no          IN  giis_obligee.PHONE_NO%TYPE,
    p_remarks           IN  giis_obligee.REMARKS%TYPE,
    p_address1          IN  giis_obligee.address1%TYPE,
    p_address2          IN  giis_obligee.address2%TYPE,
    p_address3          IN  giis_obligee.address3%TYPE
  );
  
  FUNCTION val_obligee_no_on_delete (p_obligee_no  giis_obligee.OBLIGEE_NO%TYPE)
    RETURN VARCHAR2;
  
  PROCEDURE del_obligee (
    p_obligee_no        IN  giis_obligee.OBLIGEE_NO%TYPE
  );
  
  FUNCTION get_obligee_list3(
    p_obligee_no    GIIS_OBLIGEE.OBLIGEE_NO%TYPE,
    p_obligee_name  GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
    p_address       VARCHAR2,
    p_contact_person  giis_obligee.CONTACT_PERSON%TYPE,
    p_designation     giis_obligee.DESIGNATION%TYPE,
    p_phone_no        giis_obligee.PHONE_NO%TYPE,
    p_remarks         giis_obligee.REMARKS%TYPE,
    p_user_id           giis_obligee.user_id%TYPE
  ) RETURN giis_obligee_tab PIPELINED;
  
END GIIS_OBLIGEE_PKG;
/


