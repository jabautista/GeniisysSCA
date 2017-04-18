CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wopen_Peril_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Function to retrieve wopen peril records. 
*/
  FUNCTION get_gipi_wopen_peril (p_par_id  IN GIPI_WOPEN_PERIL.par_id%TYPE,     --par_id to limit the query
                                 p_geog_cd IN GIPI_WOPEN_PERIL.geog_cd%TYPE,    --geog_cd to limit the query
                                 p_line_cd IN GIPI_WOPEN_PERIL.line_cd%TYPE)    --line_cd to limit the query
    RETURN gipi_wopen_peril_tab PIPELINED IS
    
    v_wopen_peril         gipi_wopen_peril_type;
    
  BEGIN
    FOR i IN (
        SELECT a.par_id,  a.peril_cd, b.peril_name, a.prem_rate,
               a.remarks, a.geog_cd,  a.line_cd,    b.peril_type, a.rec_flag, b.basc_perl_cd 
          FROM GIPI_WOPEN_PERIL a
              ,GIIS_PERIL       b
         WHERE a.par_id   = p_par_id
           AND a.geog_cd  = p_geog_cd
           AND a.peril_cd = b.peril_cd
           AND a.line_cd  = b.line_cd)
    LOOP
        v_wopen_peril.par_id        := i.par_id;
        v_wopen_peril.geog_cd       := i.geog_cd;
        v_wopen_peril.peril_cd      := i.peril_cd;
        v_wopen_peril.peril_name    := i.peril_name;
        v_wopen_peril.prem_rate     := i.prem_rate;
        v_wopen_peril.remarks       := i.remarks;
        v_wopen_peril.rec_flag      := i.rec_flag;
        v_wopen_peril.basc_perl_cd  := i.basc_perl_cd;
		v_wopen_peril.peril_type    := i.peril_type;
      PIPE ROW(v_wopen_peril);
    END LOOP;
    RETURN;    
  END get_gipi_wopen_peril;    

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to insert new wopen peril record or update existing record. 
*/
  Procedure set_gipi_wopen_peril (p_wopen_peril IN GIPI_WOPEN_PERIL%ROWTYPE)    --wopen_peril row type to be inserted or to be updated.
  IS 
    v_rec_flag GIPI_WOPEN_PERIL.rec_flag%TYPE;
  BEGIN
    v_rec_flag := 'A'; 
    MERGE INTO GIPI_WOPEN_PERIL
    USING DUAL ON (par_id   = p_wopen_peril.par_id
               AND geog_cd  = p_wopen_peril.geog_cd
               AND peril_cd = p_wopen_peril.peril_cd
               AND line_cd  = p_wopen_peril.line_cd)
      WHEN NOT MATCHED THEN
        INSERT (par_id,    peril_cd,   prem_rate,   remarks, 
                geog_cd,   line_cd,    rec_flag, create_user)
        VALUES (p_wopen_peril.par_id,  p_wopen_peril.peril_cd, p_wopen_peril.prem_rate, p_wopen_peril.remarks, 
                p_wopen_peril.geog_cd, p_wopen_peril.line_cd,  v_rec_flag, p_wopen_peril.user_id)
      WHEN MATCHED THEN
             UPDATE SET prem_rate = p_wopen_peril.prem_rate,
                        remarks   = p_wopen_peril.remarks,
                        rec_flag  = v_rec_flag,
                        user_id   = p_wopen_peril.user_id;
               
  END set_gipi_wopen_peril;        
  
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to delete wopen peril record. 
*/
  Procedure del_gipi_wopen_peril (p_par_id   IN GIPI_WOPEN_PERIL.par_id%TYPE,       --par_id to limit the deletion
                                  p_geog_cd  IN GIPI_WOPEN_PERIL.geog_cd%TYPE,      --geog_cd to limit the deletion
                                  p_line_cd  IN GIPI_WOPEN_PERIL.line_cd%TYPE,      --line_cd to limit the deletion
                                  p_peril_cd IN GIPI_WOPEN_PERIL.peril_cd%TYPE)     --peril_cd to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_WOPEN_PERIL
     WHERE par_id   = p_par_id
       AND geog_cd  = p_geog_cd
       AND peril_cd = p_peril_cd
       AND line_cd  = p_line_cd;
   
  END del_gipi_wopen_peril;        

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to delete all wopen peril record of the given par_id, geog_cd and line_cd. 
*/  
  Procedure del_all_gipi_wopen_peril (p_par_id  IN GIPI_WOPEN_PERIL.par_id%TYPE,    --par_id to limit the deletion.
                                      p_geog_cd IN GIPI_WOPEN_PERIL.geog_cd%TYPE,   --geog_cd to limit the deletion.
                                      p_line_cd IN GIPI_WOPEN_PERIL.line_cd%TYPE)   --line_cd to limit the deletion.
  IS
  BEGIN
    DELETE FROM GIPI_WOPEN_PERIL
     WHERE par_id  = p_par_id
       AND geog_cd = p_geog_cd
       AND line_cd = p_line_cd;
    
  END del_all_gipi_wopen_peril; 

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to delete all wopen peril record of the given par_id and geog_cd. 
*/    
  Procedure del_all_gipi_wopen_peril (p_par_id  IN GIPI_WOPEN_PERIL.par_id%TYPE,    --par_id to limit the deletion
                                      p_geog_cd IN GIPI_WOPEN_PERIL.geog_cd%TYPE)   --geog_cd to limit the deletion.
  IS
  BEGIN
    DELETE FROM GIPI_WOPEN_PERIL
     WHERE par_id  = p_par_id
       AND geog_cd = p_geog_cd;
    
  END del_all_gipi_wopen_peril;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.09.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for deleting records in GIPI_WOPEN_PERIL using the given par_id
	*/
	Procedure del_gipi_wopen_peril (p_par_id IN GIPI_WOPEN_PERIL.par_id%TYPE)
	IS
	BEGIN
		DELETE GIPI_WOPEN_PERIL
		 WHERE par_id = p_par_id;
	END del_gipi_wopen_peril;
  
END Gipi_Wopen_Peril_Pkg;
/


