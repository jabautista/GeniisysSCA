CREATE OR REPLACE PACKAGE CPI.GIIS_PRINTERS_PKG
AS

    TYPE giis_printer_type IS RECORD(
      printer_no        GIIS_PRINTERS.printer_no%TYPE,
      printer_name      GIIS_PRINTERS.printer_name%TYPE,
      cpi_rec_no        GIIS_PRINTERS.cpi_rec_no%TYPE,
      cpi_branch_cd     GIIS_PRINTERS.cpi_branch_cd%TYPE,
      iss_cd            GIIS_PRINTERS.iss_cd%TYPE,
      remarks           GIIS_PRINTERS.remarks%TYPE
    );

    TYPE giis_printer_tab IS TABLE OF giis_printer_type;
    
    FUNCTION get_giis_printer_listing
      RETURN giis_printer_tab PIPELINED;   
	  
    FUNCTION get_giis_printer_listing_user(p_user_id		giis_users.user_id%TYPE)
      RETURN giis_printer_tab PIPELINED;

END GIIS_PRINTERS_PKG;
/


