CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PRINTERS_PKG
AS
  /*
   * Created By:   Andrew Robes
   * Date:         12.29.2011
   * Module:       (WOFLO001 - Workflow)
   * Description:  Function to retrieve printer records
   */ 
    FUNCTION get_giis_printer_listing
      RETURN giis_printer_tab PIPELINED
    IS
      v_printer giis_printer_type;
    BEGIN
      FOR i IN(
        SELECT printer_name, printer_no
          FROM giis_printers
         ORDER BY printer_no)
      LOOP
        v_printer.printer_no := i.printer_no;
        v_printer.printer_name := i.printer_name;
        PIPE ROW(v_printer);
      END LOOP;
      RETURN;
    END get_giis_printer_listing;    
	--added by steven 02.01.2013; with user access 
	FUNCTION get_giis_printer_listing_user(p_user_id		giis_users.user_id%TYPE)
      RETURN giis_printer_tab PIPELINED
    IS
      v_printer giis_printer_type;
    BEGIN
      FOR i IN(
        SELECT printer_name, printer_no
          FROM giis_printers
		  WHERE check_user_per_iss_cd2 ('', iss_cd, 'GIACS086', p_user_id) = 1
         ORDER BY printer_no)
      LOOP
        v_printer.printer_no := i.printer_no;
        v_printer.printer_name := i.printer_name;
        PIPE ROW(v_printer);
      END LOOP;
      RETURN;
    END get_giis_printer_listing_user; 

END GIIS_PRINTERS_PKG;
/


