CREATE OR REPLACE PACKAGE CPI.Gipi_Wcosigntry_Pkg AS

  TYPE gipi_wcosigntry_type IS RECORD
    (par_id		  		  GIPI_WCOSIGNTRY.par_id%TYPE,
	 cosign_id		  	  GIPI_WCOSIGNTRY.cosign_id%TYPE,
	 assd_no		  	  GIPI_WCOSIGNTRY.assd_no%TYPE,
	 indem_flag			  GIPI_WCOSIGNTRY.indem_flag%TYPE,
	 bonds_flag		  	  GIPI_WCOSIGNTRY.bonds_flag%TYPE,
	 bonds_ri_flag	  	  GIPI_WCOSIGNTRY.bonds_ri_flag%TYPE,
	 cosign_name		  GIIS_COSIGNOR_RES.cosign_name%TYPE,
	 designation		  GIIS_COSIGNOR_RES.designation%TYPE);
	 
  TYPE gipi_wcosigntry_tab IS TABLE OF gipi_wcosigntry_type;
  
  FUNCTION get_gipi_wcosigntry_list(p_par_id	   GIPI_WCOSIGNTRY.par_id%TYPE
  		   						   ,p_cosign_id	   GIPI_WCOSIGNTRY.cosign_id%TYPE)
	RETURN gipi_wcosigntry_tab PIPELINED;
	
  Procedure set_gipi_wcosigntry(p_par_id	   	IN GIPI_WCOSIGNTRY.par_id%TYPE
  							   ,p_cosign_id	  	IN GIPI_WCOSIGNTRY.cosign_id%TYPE
							   ,p_assd_no	   	IN GIPI_WCOSIGNTRY.assd_no%TYPE
							   ,p_indem_flag	IN GIPI_WCOSIGNTRY.indem_flag%TYPE
							   ,p_bonds_flag    IN GIPI_WCOSIGNTRY.bonds_flag%TYPE
							   ,p_bonds_ri_flag	IN GIPI_WCOSIGNTRY.bonds_ri_flag%TYPE);
							   
  Procedure delete_gipi_wcosigntry(p_par_id 	GIPI_WCOSIGNTRY.par_id%TYPE
  							      ,p_cosign_id	GIPI_WCOSIGNTRY.cosign_id%TYPE);

	Procedure del_gipi_wcosigntry (p_par_id IN GIPI_WCOSIGNTRY.par_id%TYPE);

END Gipi_Wcosigntry_Pkg;
/


