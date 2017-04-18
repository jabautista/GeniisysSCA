CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_POLNREP_PKG AS

  FUNCTION get_pack_polnrep_count (p_pack_policy_id     GIPI_PACK_POLBASIC.pack_policy_id%TYPE)
    RETURN NUMBER IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : March 09, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description  : Returns the count of Package policy renewal/replacement.
*/
    v_count NUMBER(1) := 0;

  BEGIN
    SELECT count(*)
      INTO v_count
      FROM gipi_pack_polnrep a,
           gipi_pack_polbasic b
      WHERE a.new_pack_policy_id = b.pack_policy_id
        AND a.old_pack_policy_id = p_pack_policy_id;

    RETURN v_count;
  END get_pack_polnrep_count;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : COPY_PACK_POL_WPOLNREP program unit
  */
    PROCEDURE COPY_PACK_POL_WPOLNREP(
        p_pack_par_id           gipi_parlist.pack_par_id%TYPE,
        p_pack_policy_id        gipi_pack_polgenin.pack_policy_id%TYPE
        ) IS
    BEGIN
        INSERT INTO gipi_pack_polnrep
            (PACK_POLICY_ID,   OLD_PACK_POLICY_ID,   NEW_PACK_POLICY_ID,
             REC_FLAG, REN_REP_SW, USER_ID, LAST_UPDATE)
        SELECT p_pack_policy_id,old_pack_policy_id,p_pack_policy_id,--:postpar.policy_id,
               rec_flag,ren_rep_sw,user_id, SYSDATE
          FROM gipi_pack_wpolnrep
         WHERE pack_par_id  =  p_pack_par_id;
    END;

END GIPI_PACK_POLNREP_PKG;
/


