DROP PROCEDURE CPI.CHECK_WOPEN_PERIL;

CREATE OR REPLACE PROCEDURE CPI.CHECK_WOPEN_PERIL (p_par_id          IN GIPI_PARLIST.par_id%TYPE,
                                               p_geog_cd         IN GIPI_WOPEN_LIAB.geog_cd%TYPE,
                                               p_line_cd         IN GIPI_WOPEN_PERIL.line_cd%TYPE,
                                               p_peril_cd        IN GIPI_WOPEN_PERIL.peril_cd%TYPE,
                                               p_message         IN OUT VARCHAR2)
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 23, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to check peril validity. 
*/                                                 
IS
  v_peril_name   giis_peril.peril_name%TYPE;
  v_basc_perl    giis_peril.basc_perl_cd%TYPE;
  v_peril_cd     gipi_wopen_peril.peril_cd%TYPE;
  v_peril_type   giis_peril.peril_type%TYPE;
  p_exist1       NUMBER;
BEGIN
  p_message := 'SUCCESS';
  
  SELECT peril_name
    INTO v_peril_name
    FROM GIIS_PERIL
   WHERE peril_cd = p_peril_cd
     AND line_cd  = p_line_cd;
         
  BEGIN
    SELECT basc_perl_cd,
           peril_type
      INTO v_basc_perl,
           v_peril_type
      FROM giis_peril
     WHERE peril_cd = p_peril_cd
       AND line_cd  = p_line_cd;
         
    IF ((v_basc_perl IS NOT NULL) AND (v_peril_type = 'A')) THEN
       SELECT peril_cd
         INTO v_peril_cd
         FROM GIPI_WOPEN_PERIL
        WHERE par_id   = p_par_id
          AND peril_cd = v_basc_perl;
    ELSIF ((v_basc_perl IS NULL) AND (v_peril_type = 'A')) THEN
      BEGIN
        SELECT distinct 1
          INTO p_exist1
          FROM GIPI_WOPEN_PERIL a, 
               GIIS_PERIL b
         WHERE a.par_id     = p_par_id
           AND a.geog_cd    = p_geog_cd
           AND a.line_cd    = p_line_cd
           AND a.peril_cd   = b.peril_cd
           AND b.peril_type = 'B';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_message := 'A basic peril should first be added before this allied peril.';
      END;
    END IF;
         
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT peril_name
        INTO v_peril_name
        FROM GIIS_PERIL
       WHERE peril_cd = v_basc_perl
         AND line_cd  = p_line_cd;
      p_message := 'The basic peril ( '||v_peril_name||' ) should first be added before ' || 'this allied peril.';
  END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_message := 'No such peril exists in the maintenance table.';
END;
/


