CREATE OR REPLACE PACKAGE CPI.GIIS_PACKAGE_BENEFIT_PKG
AS

  TYPE giis_package_benefit_type IS RECORD (
  	   pack_ben_cd				 GIIS_PACKAGE_BENEFIT.pack_ben_cd%TYPE,
	   package_cd	  			 GIIS_PACKAGE_BENEFIT.package_cd%TYPE
  	   );
	   
  TYPE giis_package_benefit_tab IS TABLE OF giis_package_benefit_type;
  
  /********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS012 
  RECORD GROUP NAME: PACK_BEN_CD 
***********************************************************************************/ 
	   
  FUNCTION giis_package_benefit_list (p_line_cd		 GIIS_PACKAGE_BENEFIT.line_cd%TYPE,
  		   							  p_subline_cd	 GIIS_PACKAGE_BENEFIT.subline_cd%TYPE)
	RETURN giis_package_benefit_tab PIPELINED;
		   
END;
/


