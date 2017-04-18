CREATE OR REPLACE PACKAGE CPI.GIISS105_PKG AS

    TYPE mortgagee_source_list_type IS RECORD
    (iss_cd     GIIS_ISSOURCE.iss_cd%TYPE,
     iss_name   GIIS_ISSOURCE.iss_name%TYPE
    );
    
    TYPE mortgagee_source_list_tab IS TABLE OF mortgagee_source_list_type;
    
    TYPE mortgagee_maintenance_type IS RECORD
    (iss_cd             GIIS_MORTGAGEE.iss_cd%TYPE,
     mortg_cd           GIIS_MORTGAGEE.mortg_cd%TYPE,
     mortg_name         GIIS_MORTGAGEE.mortg_name%TYPE,
     mail_addr1         GIIS_MORTGAGEE.mail_addr1%TYPE,
     mail_addr2         GIIS_MORTGAGEE.mail_addr2%TYPE,
     mail_addr3         GIIS_MORTGAGEE.mail_addr3%TYPE,
     designation        GIIS_MORTGAGEE.designation%TYPE,
     tin                GIIS_MORTGAGEE.tin%TYPE,
     contact_pers       GIIS_MORTGAGEE.contact_pers%TYPE,
     remarks            GIIS_MORTGAGEE.remarks%TYPE,
     user_id            GIIS_MORTGAGEE.user_id%TYPE,
     last_update        VARCHAR2(100),
     mortgagee_id       GIIS_MORTGAGEE.mortgagee_id%TYPE
     );
     
  TYPE mortgagee_maintenance_tab IS TABLE OF mortgagee_maintenance_type;
  
    FUNCTION get_mortgagee_source_list(
      p_user_id     giis_users.user_id%TYPE
   )
        RETURN mortgagee_source_list_tab PIPELINED;
  
    FUNCTION get_mortgagee_list_by_iss_cd(
        p_iss_cd  IN  giis_mortgagee.iss_cd%TYPE
    )
        RETURN mortgagee_maintenance_tab PIPELINED;
    
    FUNCTION  validate_delete_mortgagee(
        p_iss_cd    GIIS_MORTGAGEE.iss_cd%TYPE,
        p_mortg_cd  GIIS_MORTGAGEE.mortg_cd%TYPE
    )
        RETURN VARCHAR2;
  
    FUNCTION validate_add_mortgagee_cd (
        p_iss_cd       GIIS_MORTGAGEE.iss_cd%TYPE,	 
        p_mortg_cd	    GIIS_MORTGAGEE.mortg_cd%TYPE
    )
        RETURN VARCHAR2;

    FUNCTION validate_add_mortgagee_name (
        p_iss_cd       GIIS_MORTGAGEE.iss_cd%TYPE,
	    p_mortg_name	    GIIS_MORTGAGEE.mortg_name%TYPE
    )
        RETURN VARCHAR2;

    PROCEDURE delete_giis_mortgagee (
	    p_iss_cd       GIIS_MORTGAGEE.iss_cd%TYPE,
        p_mortg_cd	   GIIS_MORTGAGEE.mortg_cd%TYPE
    );
  
    PROCEDURE set_giis_mortgagee (
	    p_mortgagee    GIIS_MORTGAGEE%ROWTYPE
    );

END GIISS105_PKG;
/


