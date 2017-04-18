DROP PROCEDURE CPI.COPY_POL_WCARGO_HULL;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcargo_hull(
	   	  		  p_line         IN  GIIS_SUBLINE.line_cd%TYPE,
                  p_subline   	 IN  GIIS_SUBLINE.subline_cd%TYPE,
				  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE,
				  p_line_cd	  	 IN  GIPI_PARLIST.line_cd%TYPE,
				  p_cargo_cd  	 IN  VARCHAR2,
				  p_hull_cd   	 IN  VARCHAR2,
				  p_aviation_cd  IN  VARCHAR2,
				  p_open_flag 	 IN  VARCHAR2,
				  p_menu_ln_cd 	 IN  VARCHAR2
				  ) 
	   IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wcargo_hull program unit
  */
  
  IF p_line = p_cargo_cd THEN
     /*IF :gauge.process='Y' THEN
       :gauge.FILE := 'Copying Marine Cargo info...';
     ELSE
       :gauge.FILE := 'passing copy policy for Marine Cargo';
     END IF;
     vbx_counter;*/
     --IF p_subline <> variables.subline_mop THEN --issa@fpac08.14.2006
     --issa@fpac08.14.2006, replacement, since FPAC has more than 1 open policy in marine
     IF (p_line_cd = 'MN' OR p_menu_ln_cd = 'MN') AND p_open_flag = 'N' THEN
        copy_pol_wves_air(p_par_id,p_policy_id);
        copy_pol_wcargo(p_par_id,p_policy_id);
       /* IF p_subline = variables.subline_mrn THEN
	         copy_pol_wopen_policy;
        END IF;
      */  
     --ELSIF p_subline = variables.subline_mop THEN --issa@fpac08.14.2006
     --issa@fpac08.14.2006, replacement, since FPAC has more than 1 open policy in marine
     ELSIF (p_line_cd = 'MN' OR p_menu_ln_cd = 'MN') AND p_open_flag = 'Y' THEN  
				copy_pol_wopen_liab(p_par_id,p_policy_id);
				copy_pol_wopen_peril(p_par_id,p_policy_id);
				copy_pol_wopen_cargo(p_par_id,p_policy_id);
     END IF;   
  ELSIF p_line = p_hull_cd THEN
     /*IF :gauge.process='Y' THEN
       :gauge.FILE := 'Copying Marine Vessel info...';
     ELSE
       :gauge.FILE := 'passing copy policy for Marine Vessel';
     END IF;
        vbx_counter;*/
	copy_pol_witem_ves(p_par_id,p_policy_id);
  ELSIF p_line = p_aviation_cd THEN
     /*IF :gauge.process='Y' THEN
       :gauge.FILE := 'Copying Aviation Item info...';
     ELSE
       :gauge.FILE := 'passing copy policy for Aviation Item';
     END IF;
     vbx_counter;*/
     copy_pol_waviation_item(p_par_id,p_policy_id);
  END IF;

END;
/


