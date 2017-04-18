CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Ves_Air_Pkg AS

/*
**  Created by   :  Grace Miralles
**  Date Created :  March 04, 2011
**  Reference By : (GIIMM009 - Carrier Information)
**  Description  : This retrieves the carrier information of the given quote_id.
*/
  FUNCTION get_gipi_quote_ves_air (p_quote_id IN GIPI_QUOTE_VES_AIR.quote_id%TYPE)  --quote_id to limit the query
    RETURN gipi_quote_ves_air_tab PIPELINED IS

    v_wves_air  gipi_quote_ves_air_type;

  BEGIN
    FOR i IN (
      SELECT a.quote_id,      TRIM(a.vessel_cd) vessel_cd, b.vessel_flag,
             DECODE(b.vessel_flag, 'V', 'Vessel',
                                   'I', 'Inland',
                                   'A', 'Aircraft') vessel_type,
             b.vessel_name, a.rec_flag
        FROM GIPI_QUOTE_VES_AIR a
            ,GIIS_VESSEL   b
       WHERE a.quote_id    = p_quote_id
         AND a.vessel_cd = b.vessel_cd
       ORDER BY UPPER(b.vessel_name))
    LOOP
      v_wves_air.quote_id      := i.quote_id;
      v_wves_air.vessel_cd   := i.vessel_cd;
      v_wves_air.vessel_flag := i.vessel_flag;
      v_wves_air.vessel_type := i.vessel_type;
      v_wves_air.vessel_name := i.vessel_name;
      v_wves_air.rec_flag    := i.rec_flag;

      PIPE ROW(v_wves_air);
    END LOOP;
    RETURN;
  END get_gipi_quote_ves_air;

/*
**  Created by   :  Grace Miralles
**  Date Created :  March 04, 2011
**  Reference By : (GIIMM009 - Carrier Information)
**  Description  : This inserts the new carrier information.
*/
Procedure set_gipi_quote_ves_air (p_carrier IN GIPI_QUOTE_VES_AIR%ROWTYPE)  --gipi_quote_ves_air row type to be inserted.
IS
  v_rec_flag  GIPI_QUOTE_VES_AIR.rec_flag%TYPE;
  BEGIN

    INSERT INTO GIPI_QUOTE_VES_AIR
           (quote_id,   vessel_cd, rec_flag)
    VALUES (p_carrier.quote_id, p_carrier.vessel_cd, 'C');

    COMMIT;
  END set_gipi_quote_ves_air;

/*
**  Created by   :  Grace Miralles
**  Date Created :  March 04, 2011
**  Reference By : (GIIMM007 - Carrier Information)
**  Description  : This deletes the carrier record of the given quote_id and vessel_cd.
*/
  Procedure del_gipi_quote_ves_air (p_quote_id    IN GIPI_QUOTE_VES_AIR.quote_id%TYPE,      --quote_id to limit the deletion
                                    p_vessel_cd   IN GIPI_QUOTE_VES_AIR.vessel_cd%TYPE)   --vessel_cd to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_QUOTE_VES_AIR
     WHERE quote_id    = p_quote_id
       AND vessel_cd = p_vessel_cd;

    COMMIT;
  END del_gipi_quote_ves_air;

/*
**  Created by   :  Grace  Miralles
**  Date Created :  March 04, 2011
**  Reference By : (GIIMM009 - Carrier Information)
**  Description  : This deletes all the carrier records of the given quote_id.
*/
  Procedure del_all_gipi_quote_ves_air (p_quote_id IN GIPI_QUOTE_VES_AIR.quote_id%TYPE)  --quote_id to limit the deletion
  IS
  BEGIN
    DELETE FROM GIPI_QUOTE_VES_AIR
     WHERE quote_id = p_quote_id;

    COMMIT;
  END del_all_gipi_quote_ves_air;


/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  June 14, 2011
**  Reference By : GIIMM002 - Quotation Information
**  Description  : This detemines if carrier records exists for the given quote_id.
*/
   PROCEDURE check_if_quote_ves_air_exist(p_quote_id    IN  GIPI_QUOTE_VES_AIR.quote_id%TYPE,
                                          p_exist       OUT VARCHAR2)

   AS

   v_exist  VARCHAR2(1) := 'N';

   BEGIN
      FOR i IN (SELECT '1'
                FROM GIPI_QUOTE_VES_AIR
                WHERE quote_id = p_quote_id)
      LOOP
       v_exist := 'Y';
      END LOOP;

      p_exist := v_exist;

   END;

END Gipi_Quote_ves_Air_Pkg;
/


