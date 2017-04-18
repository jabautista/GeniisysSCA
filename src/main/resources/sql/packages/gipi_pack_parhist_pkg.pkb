CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Pack_Parhist_Pkg AS

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :  January 12, 2011
**  Reference By  : (GIPIS056A- Endt Package Par Creation)
**  Description   : Procedure checks if record exists in GIPI_PACK_PARHIST table
*/

PROCEDURE check_pack_parhist(p_pack_par_id      GIPI_PACK_PARHIST.pack_par_id%TYPE,
                             p_underwriter      GIPI_PACK_PARLIST.underwriter%TYPE) AS

    v_pack_par_id       GIPI_PACK_PARHIST.pack_par_id%TYPE;

    BEGIN
      SELECT pack_par_id
      INTO v_pack_par_id
      FROM GIPI_PACK_PARHIST
      WHERE pack_par_id = p_pack_par_id;

       EXCEPTION
        WHEN NO_DATA_FOUND
         THEN
          GIPI_PACK_PARHIST_PKG.set_gipi_pack_parhist(p_pack_par_id, p_underwriter, 'DB', '1');

      END check_pack_parhist;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :  January 12, 2011
**  Reference By  : (GIPIS056A- Endt Package Par Creation)
**  Description   : Procedure inserts record in GIPI_PACK_PARHIST table
*/

PROCEDURE set_gipi_pack_parhist(p_pack_par_id   GIPI_PACK_PARHIST.pack_par_id%TYPE,
                                p_user_id       GIPI_PACK_PARHIST.user_id%TYPE,
                                p_entry_source  GIPI_PACK_PARHIST.entry_source%TYPE,
                                p_parstat_cd    GIPI_PACK_PARHIST.parstat_cd%TYPE)
AS

    BEGIN
        INSERT INTO GIPI_PACK_PARHIST(pack_par_id, user_id,
                                      parstat_date, entry_source,
                                      parstat_cd)
        VALUES(p_pack_par_id, p_user_id, SYSDATE, p_entry_source, p_parstat_cd);

    END set_gipi_pack_parhist;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : WHEN-BUTTON-PRESSED trigger in post_button part 1
  */
    PROCEDURE INSERT_PACK_PARHIST(p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE) IS
    BEGIN
      INSERT INTO gipi_pack_parhist
                 (pack_par_id,user_id,parstat_date,entry_source,parstat_cd)
           VALUES(p_pack_par_id, giis_users_pkg.app_user, sysdate,
                  NULL,'10');
    END;

END Gipi_Pack_Parhist_Pkg;
/


