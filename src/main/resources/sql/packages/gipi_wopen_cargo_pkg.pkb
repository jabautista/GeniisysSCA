CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wopen_Cargo_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability)
**  Description  : Function to retrieve wopen cargo records. 
*/
  FUNCTION get_gipi_wopen_cargo (p_par_id  IN GIPI_WOPEN_CARGO.par_id%TYPE,     --par_id to limit the query
                                 p_geog_cd IN GIPI_WOPEN_CARGO.geog_cd%TYPE)    --geog_cd to limit the query
    RETURN gipi_wopen_cargo_tab PIPELINED IS
    
    v_wopen_cargo        gipi_wopen_cargo_type;
    
  BEGIN
    FOR i IN (
        SELECT a.par_id, geog_cd, a.cargo_class_cd, b.cargo_class_desc, a.rec_flag
          FROM GIPI_WOPEN_CARGO a
              ,GIIS_CARGO_CLASS b
         WHERE a.par_id         = p_par_id
           AND a.geog_cd        = p_geog_cd
           AND a.cargo_class_cd = b.cargo_class_cd
         ORDER BY b.cargo_class_desc)
    LOOP
        v_wopen_cargo.par_id           := i.par_id;
        v_wopen_cargo.geog_cd          := i.geog_cd;
        v_wopen_cargo.cargo_class_cd   := i.cargo_class_cd;
        v_wopen_cargo.cargo_class_desc := i.cargo_class_desc;
        v_wopen_cargo.rec_flag         := i.rec_flag;
      PIPE ROW(v_wopen_cargo);
    END LOOP;
    RETURN;     
  END get_gipi_wopen_cargo;      

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability)
**  Description  : Procedure to insert new wopen cargo record or update existing record. 
*/    
  Procedure set_gipi_wopen_cargo (p_wopen_cargo IN GIPI_WOPEN_CARGO%ROWTYPE)    --wopen cargo row type to be inserted
  IS
    v_rec_flag GIPI_WOPEN_CARGO.rec_flag%TYPE;
  BEGIN
    v_rec_flag := 'A';
    MERGE INTO GIPI_WOPEN_CARGO
    USING DUAL ON (par_id         = p_wopen_cargo.par_id
               AND geog_cd        = p_wopen_cargo.geog_cd
               AND cargo_class_cd = p_wopen_cargo.cargo_class_cd)
     WHEN NOT MATCHED THEN
       INSERT (par_id,   geog_cd,   cargo_class_cd,   rec_flag, create_user, user_id, last_update)
       VALUES (p_wopen_cargo.par_id, p_wopen_cargo.geog_cd, p_wopen_cargo.cargo_class_cd, v_rec_flag, p_wopen_cargo.user_id, user, sysdate)
     WHEN MATCHED THEN
           UPDATE SET rec_flag       = v_rec_flag,
                      user_id        = p_wopen_cargo.user_id,
                      last_update    = sysdate;
                   
  END set_gipi_wopen_cargo;    

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability)
**  Description  : Procedure to delete wopen cargo record. 
*/     
  Procedure del_gipi_wopen_cargo (p_par_id         IN GIPI_WOPEN_CARGO.par_id%TYPE,             --par_id to limit the deletion
                                  p_geog_cd        IN GIPI_WOPEN_CARGO.geog_cd%TYPE,            --geog_cd to limit the deletion
                                  p_cargo_class_cd IN GIPI_WOPEN_CARGO.cargo_class_cd%TYPE)     --cargo_class_cd to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_WOPEN_CARGO
     WHERE par_id         = p_par_id
       AND geog_cd        = p_geog_cd
       AND cargo_class_cd = p_cargo_class_cd;

  END del_gipi_wopen_cargo;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 10, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability)
**  Description  : Procedure to delete all wopen cargo record of the given par_id and geog_cd. 
*/       
  Procedure del_all_gipi_wopen_cargo (p_par_id         IN GIPI_WOPEN_CARGO.par_id%TYPE,     --par_id to limit the deletion
                                      p_geog_cd        IN GIPI_WOPEN_CARGO.geog_cd%TYPE)    --geog_cd to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_WOPEN_CARGO
     WHERE par_id         = p_par_id
       AND geog_cd        = p_geog_cd;
     
  END del_all_gipi_wopen_cargo;                  
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.09.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for deleting records in GIPI_WOPEN_CARGO using the given par_id
	*/
	Procedure del_gipi_wopen_cargo (p_par_id IN GIPI_WOPEN_CARGO.par_id%TYPE)
	IS
	BEGIN
		DELETE GIPI_WOPEN_CARGO
		 WHERE par_id = p_par_id;
	END del_gipi_wopen_cargo;
    
	/*
    **  Created by   : Marco Paolo Rebong
    **  Date Created : November 06, 2012
    **  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
    **  Description  : save GIPI_WOPEN_CARGO for endorsement
    */
    PROCEDURE set_gipi_wopen_cargo_endt(
        p_par_id                GIPI_WOPEN_CARGO.par_id%TYPE,
        p_geog_cd               GIPI_WOPEN_CARGO.geog_cd%TYPE,
        p_cargo_class_cd        GIPI_WOPEN_CARGO.cargo_class_cd%TYPE,
        p_rec_flag              GIPI_WOPEN_CARGO.rec_flag%TYPE
    )
    IS
    BEGIN
        MERGE INTO GIPI_WOPEN_CARGO
        USING DUAL ON (par_id = p_par_id
              AND geog_cd = p_geog_cd
              AND cargo_class_cd = p_cargo_class_cd)
         WHEN NOT MATCHED THEN
              INSERT (par_id, geog_cd, cargo_class_cd, rec_flag)
              VALUES (p_par_id, p_geog_cd, p_cargo_class_cd, p_rec_flag)
         WHEN MATCHED THEN
              UPDATE SET rec_flag = p_rec_flag;
    END;
    
END Gipi_Wopen_Cargo_Pkg;
/


