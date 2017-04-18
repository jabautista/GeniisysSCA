CREATE OR REPLACE PACKAGE CPI.Giis_Modules_TRan_Pkg AS

  TYPE giis_modules_tran_type IS RECORD (
  	   module_id		 GIIS_MODULES_TRAN.module_id%TYPE,
       module_desc		 GIIS_MODULES.module_desc%TYPE,
	   tran_cd  		 GIIS_MODULES_TRAN.tran_cd%TYPE,
       tran_desc  		 GIIS_TRANSACTION.tran_desc%TYPE,
	   user_id			 GIIS_MODULES_TRAN.user_id%TYPE,
	   last_update		 GIIS_MODULES_TRAN.last_update%TYPE);
	   
  TYPE giis_modules_tran_tab IS TABLE OF giis_modules_tran_type;
  
  FUNCTION get_giis_modules_tran_list
    RETURN giis_modules_tran_tab PIPELINED;
	
END Giis_Modules_Tran_Pkg;
/


