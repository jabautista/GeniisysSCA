DROP PROCEDURE CPI.DELETE_ITEM_PACKAGE;

CREATE OR REPLACE PROCEDURE CPI.delete_item_package(
	   	  		  p_line_cd    IN VARCHAR2,
				  p_par_id	   IN GIPI_PARLIST.par_id%TYPE
	   	  		  )
	   IS
 v_pack				 GIPI_WPOLBAS.pack_pol_flag%TYPE;
 v_subline_cd		 GIPI_WPOLBAS.subline_cd%TYPE;
 v_cargo_cd			 GIIS_PARAMETERS.param_value_v%TYPE;
 v_accident_cd		 GIIS_PARAMETERS.param_value_v%TYPE;
 v_casualty_cd		 GIIS_PARAMETERS.param_value_v%TYPE;
 v_engrng_cd		 GIIS_PARAMETERS.param_value_v%TYPE;
 v_fire_cd			 GIIS_PARAMETERS.param_value_v%TYPE;
 v_motor_cd			 GIIS_PARAMETERS.param_value_v%TYPE;
 v_surety_cd		 GIIS_PARAMETERS.param_value_v%TYPE;
 v_hull_cd			 GIIS_PARAMETERS.param_value_v%TYPE;
 v_aviation_cd		 GIIS_PARAMETERS.param_value_v%TYPE;
 v_open_policy_sw	 GIIS_SUBLINE.open_policy_sw%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_item_package program unit 
  */ 
	 
  FOR b IN (SELECT pack_pol_flag,subline_cd
  	  	      FROM GIPI_WPOLBAS
			 WHERE par_id = p_par_id)
  LOOP
    v_pack           := b.pack_pol_flag;
	v_subline_cd     := b.subline_cd;
  END LOOP;
	 
  FOR c IN (SELECT open_policy_sw
      	      FROM GIIS_SUBLINE
             WHERE line_cd    = p_line_cd 
               AND subline_cd = v_subline_cd)
  LOOP
	 v_open_policy_sw   := c.open_policy_sw;
  END LOOP; 
  
  FOR d IN (SELECT a.param_value_v cargo, b.param_value_v acc,  c.param_value_v ca,
  	  	   		   d.param_value_v eng,	  e.param_value_v fire, f.param_value_v motor,
				   g.param_value_v su,	  h.param_value_v hull, i.param_value_v av 	
              FROM GIIS_PARAMETERS A,GIIS_PARAMETERS B,GIIS_PARAMETERS C,
			       GIIS_PARAMETERS D,GIIS_PARAMETERS E,GIIS_PARAMETERS F,
				   GIIS_PARAMETERS G,GIIS_PARAMETERS H,GIIS_PARAMETERS I
             WHERE a.param_name = 'LINE_CODE_MN'
	           AND b.param_name = 'LINE_CODE_AC'
	           AND c.param_name = 'LINE_CODE_CA'
			   AND d.param_name = 'LINE_CODE_EN'
			   AND e.param_name = 'LINE_CODE_FI'
			   AND f.param_name = 'LINE_CODE_MC'
			   AND g.param_name = 'LINE_CODE_SU'
			   AND h.param_name = 'LINE_CODE_MH'
			   AND i.param_name = 'LINE_CODE_AV')
  LOOP
    v_cargo_cd     := d.cargo;
	v_accident_cd  := d.acc;
	v_casualty_cd  := d.ca;
	v_engrng_cd	   := d.eng;
	v_fire_cd	   := d.fire;
	v_motor_cd	   := d.motor;
	v_surety_cd	   := d.su;
	v_hull_cd	   := d.hull;
	v_aviation_cd  := d.av;
  END LOOP; 
  
  IF v_pack = 'Y' THEN
    FOR A IN (SELECT   distinct pack_line_cd
                FROM   gipi_wpack_line_subline
               WHERE   par_id  =  p_par_id) LOOP
     IF A.pack_line_cd = v_casualty_cd THEN
        delete_casualty_workfile(p_par_id);
     ELSIF A.pack_line_cd = v_fire_cd THEN
        delete_fire_workfile(p_par_id);
     ELSIF A.pack_line_cd = v_hull_cd OR
        A.pack_line_cd = v_cargo_cd THEN
        delete_marav_workfile(p_par_id);
     ELSIF A.pack_line_cd = v_motor_cd THEN
        delete_motcar_workfile(p_par_id);
     ELSIF A.pack_line_cd = v_engrng_cd THEN
        delete_engineering_workfile(p_par_id);
     END IF;
     IF NVL(v_open_policy_sw,'N') = 'Y' and 
     	  A.pack_line_cd <> v_hull_cd AND
        A.pack_line_cd <> v_cargo_cd THEN
        delete_open(p_par_id);   
     END IF;   
    END LOOP;
  ELSE
     IF p_line_cd = v_casualty_cd THEN
        delete_casualty_workfile(p_par_id);   
     ELSIF p_line_cd = v_fire_cd THEN
        delete_fire_workfile(p_par_id);   
     ELSIF p_line_cd = v_hull_cd OR
        p_line_cd = v_cargo_cd THEN
        delete_marav_workfile(p_par_id);   
     ELSIF p_line_cd = v_motor_cd THEN
        delete_motcar_workfile(p_par_id);   
     ELSIF p_line_cd = v_engrng_cd THEN
        delete_engineering_workfile(p_par_id);   
     END IF;
     IF NVL(v_open_policy_sw,'N') = 'Y' and 
     	p_line_cd <> v_hull_cd AND
        p_line_cd <> v_cargo_cd THEN
        delete_open(p_par_id);     
     END IF;
  END IF;
END;
/


