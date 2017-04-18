CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wves_Air_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 02, 2010
**  Reference By : (GIPIS007 - Carrier Information)
**  Description  : This retrieves the carrier information of the given par_id. 
*/
  FUNCTION get_gipi_wves_air (p_par_id IN GIPI_WVES_AIR.par_id%TYPE)  --par_id to limit the query
    RETURN gipi_wves_air_tab PIPELINED IS
    
    v_wves_air  gipi_wves_air_type;
    
  BEGIN
    FOR i IN (
      SELECT a.par_id,      TRIM(a.vessel_cd) vessel_cd, b.vessel_flag,
             DECODE(b.vessel_flag, 'V', 'Vessel',
                                   'I', 'Inland',
                                   'A', 'Aircraft') vessel_type, 
             b.vessel_name, a.rec_flag
        FROM GIPI_WVES_AIR a
            ,GIIS_VESSEL   b
       WHERE a.par_id    = p_par_id
         AND a.vessel_cd = b.vessel_cd
       ORDER BY UPPER(b.vessel_name))
    LOOP    
      v_wves_air.par_id      := i.par_id;
      v_wves_air.vessel_cd   := i.vessel_cd;
      v_wves_air.vessel_flag := i.vessel_flag;
      v_wves_air.vessel_type := i.vessel_type;
      v_wves_air.vessel_name := i.vessel_name;
      v_wves_air.rec_flag    := i.rec_flag;      
      PIPE ROW(v_wves_air); 
    END LOOP;
    RETURN;     
  END get_gipi_wves_air;     
  
  procedure val_multivessel(p_par_id gipi_wves_air.par_id%TYPE)
  AS
    v_count NUMBER := 0;
    v_vessel_cd GIPI_WVES_AIR.vessel_cd%TYPE;
  begin
    SELECT COUNT(*)
      INTO v_count
      FROM GIPI_WVES_AIR
     WHERE par_id = p_par_id;
     
    IF v_count = 1 THEN
      SELECT vessel_cd
        INTO v_vessel_cd
        FROM GIPI_WVES_AIR
       WHERE par_id = p_par_id;
       
      IF v_vessel_cd = GIISP.V('VESSEL_CD_MULTI') THEN
        raise_application_error (-20001,
                                  'Geniisys Exception#I#Another Carrier/Conveyance of must exist when using MULTIVESSEL.'
                                 );
      END IF;
    END IF;
  end;
  
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 02, 2010
**  Reference By : (GIPIS007 - Carrier Information) & (GIPIS076 - Endt Carrier Information)
**  Description  : This inserts the new carrier information. 
*/
Procedure set_gipi_wves_air (p_carrier IN GIPI_WVES_AIR%ROWTYPE)  --gipi_wves_air row type to be inserted. 
IS
  v_rec_flag  GIPI_WVES_AIR.rec_flag%TYPE;
  BEGIN
    --v_rec_flag := Gipi_Parlist_Pkg.GET_REC_FLAG(p_carrier.par_id); replaced by: nica 10.29.2010 to be reused by endt carrier information
      v_rec_flag := get_rec_flag_for_gipi_wves_air(p_carrier);   
        
    INSERT INTO GIPI_WVES_AIR
           (par_id,   vessel_cd, rec_flag, create_user)
    VALUES (p_carrier.par_id, p_carrier.vessel_cd, v_rec_flag, p_carrier.user_id);            
    
  END set_gipi_wves_air;
    
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 02, 2010
**  Reference By : (GIPIS007 - Carrier Information)
**  Description  : This deletes the carrier record of the given par_id and vessel_cd. 
*/    
  Procedure del_gipi_wves_air (p_par_id    IN GIPI_WVES_AIR.par_id%TYPE,      --par_id to limit the deletion
                               p_vessel_cd IN GIPI_WVES_AIR.vessel_cd%TYPE)   --vessel_cd to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_WVES_AIR
     WHERE par_id    = p_par_id
       AND vessel_cd = p_vessel_cd;       
  END del_gipi_wves_air;     

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 02, 2010
**  Reference By : (GIPIS007 - Carrier Information)
**  Description  : This deletes all the carrier records of the given par_id. 
*/   
  Procedure del_all_gipi_wves_air (p_par_id IN GIPI_WVES_AIR.par_id%TYPE)  --par_id to limit the deletion 
  IS
  BEGIN
    DELETE FROM GIPI_WVES_AIR
     WHERE par_id = p_par_id;
       
    COMMIT;
  END del_all_gipi_wves_air;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id	
	*/
	Procedure del_gipi_wves_air(p_par_id IN GIPI_WVES_AIR.par_id%TYPE)
	IS
	BEGIN
		DELETE GIPI_WVES_AIR
		 WHERE par_id   = p_par_id;
	END del_gipi_wves_air;

END Gipi_Wves_Air_Pkg;
/


