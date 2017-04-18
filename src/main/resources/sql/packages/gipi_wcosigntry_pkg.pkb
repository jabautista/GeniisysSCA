CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wcosigntry_Pkg AS

--Bryan
  FUNCTION get_gipi_wcosigntry_list(p_par_id	   GIPI_WCOSIGNTRY.par_id%TYPE
  		   						   ,p_cosign_id	   GIPI_WCOSIGNTRY.cosign_id%TYPE)
	RETURN gipi_wcosigntry_tab PIPELINED
	IS
	v_cosigntry				   gipi_wcosigntry_type;
  BEGIN
    FOR i IN (SELECT a.cosign_id,     a.assd_no,	 a.indem_flag,   a.bonds_flag,
		  	 		 a.bonds_ri_flag, b.cosign_name, b.designation,  a.par_id
				FROM GIPI_WCOSIGNTRY a, GIIS_COSIGNOR_RES b
			   WHERE a.par_id		= p_par_id
			     AND a.cosign_id	= NVL(p_cosign_id, a.cosign_id)
				 AND b.cosign_id	= a.cosign_id(+)
				 AND b.assd_no		= a.assd_no(+))
	LOOP
      v_cosigntry.cosign_id		  	  := i.cosign_id;
	  v_cosigntry.assd_no			  := i.assd_no;
	  v_cosigntry.indem_flag		  := i.indem_flag;
	  v_cosigntry.bonds_flag		  := i.bonds_flag;
	  v_cosigntry.bonds_ri_flag	  	  := i.bonds_ri_flag;
	  v_cosigntry.cosign_name		  := i.cosign_name;
	  v_cosigntry.designation		  := i.designation;
	  v_cosigntry.par_id			  := i.par_id;
	  PIPE ROW(v_cosigntry);
	END LOOP;
	RETURN;
  END get_gipi_wcosigntry_list;

--Bryan
  Procedure set_gipi_wcosigntry(p_par_id	   	IN GIPI_WCOSIGNTRY.par_id%TYPE
  							   ,p_cosign_id	  	IN GIPI_WCOSIGNTRY.cosign_id%TYPE
							   ,p_assd_no	   	IN GIPI_WCOSIGNTRY.assd_no%TYPE
							   ,p_indem_flag	IN GIPI_WCOSIGNTRY.indem_flag%TYPE
							   ,p_bonds_flag    IN GIPI_WCOSIGNTRY.bonds_flag%TYPE
							   ,p_bonds_ri_flag	IN GIPI_WCOSIGNTRY.bonds_ri_flag%TYPE)
    IS
  BEGIN
  	   MERGE INTO GIPI_WCOSIGNTRY
	   USING DUAL ON (par_id   		  = p_par_id
	 	   		 AND cosign_id        = p_cosign_id)
	   WHEN NOT MATCHED THEN
	   		INSERT ( par_id,         cosign_id,        assd_no,
				     indem_flag,     bonds_flag,       bonds_ri_flag)
			VALUES ( p_par_id,       p_cosign_id,      p_assd_no,
				     p_indem_flag,   p_bonds_flag,     p_bonds_ri_flag)
		WHEN MATCHED THEN
	   	  UPDATE SET assd_no  		 =	  p_assd_no,
				     indem_flag  	 =	  p_indem_flag,
					 bonds_flag	 	 =	  p_bonds_flag,
					 bonds_ri_flag   =	  p_bonds_ri_flag;
  END set_gipi_wcosigntry;

--Bryan
  Procedure delete_gipi_wcosigntry(p_par_id 	GIPI_WCOSIGNTRY.par_id%TYPE
  							      ,p_cosign_id	GIPI_WCOSIGNTRY.cosign_id%TYPE)
	IS
  BEGIN
    DELETE FROM GIPI_WCOSIGNTRY
	 WHERE par_id   		 = p_par_id
  	   AND cosign_id		 = p_cosign_id;
  END delete_gipi_wcosigntry;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure DEL_GIPI_WCOSIGNTRY (p_par_id IN GIPI_WCOSIGNTRY.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WCOSIGNTRY
		 WHERE par_id = p_par_id;
	END DEL_GIPI_WCOSIGNTRY;
END Gipi_Wcosigntry_Pkg;
/


