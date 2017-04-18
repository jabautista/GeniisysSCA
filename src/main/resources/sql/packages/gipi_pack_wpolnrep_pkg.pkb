CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Pack_Wpolnrep_Pkg AS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description  : This retrieves the renewal/replacement details records of the given pack_pack_par_id.
*/
  FUNCTION get_gipi_pack_wpolnrep (p_pack_par_id     GIPI_PACK_WPOLNREP.pack_par_id%TYPE)
    RETURN gipi_pack_wpolnrep_tab PIPELINED IS

  v_pack_wpolnrep   gipi_pack_wpolnrep_type;

  BEGIN
    FOR i IN (
        SELECT a.pack_par_id,   a.rec_flag,   a.old_pack_policy_id, a.ren_rep_sw,
               c.line_cd,  c.subline_cd, c.pol_seq_no,    c.iss_cd,
               c.issue_yy, c.renew_no, c.expiry_date
          FROM GIPI_PACK_WPOLNREP a
              ,GIPI_PACK_WPOLBAS  b
              ,GIPI_PACK_POLBASIC c
         WHERE a.pack_par_id        = p_pack_par_id
           AND a.pack_par_id        = b.pack_par_id
           AND a.old_pack_policy_id = c.pack_policy_id)
    LOOP
        v_pack_wpolnrep.pack_par_id     	:= i.pack_par_id;
        v_pack_wpolnrep.rec_flag        	:= i.rec_flag;
        v_pack_wpolnrep.old_pack_policy_id  := i.old_pack_policy_id;
        v_pack_wpolnrep.ren_rep_sw      	:= i.ren_rep_sw;
        v_pack_wpolnrep.line_cd         	:= i.line_cd;
        v_pack_wpolnrep.subline_cd      	:= i.subline_cd;
        v_pack_wpolnrep.pol_seq_no      	:= i.pol_seq_no;
        v_pack_wpolnrep.iss_cd          	:= i.iss_cd;
        v_pack_wpolnrep.issue_yy        	:= i.issue_yy;
        v_pack_wpolnrep.renew_no        	:= i.renew_no;
        v_pack_wpolnrep.expiry_date         := i.expiry_date;
      PIPE ROW(v_pack_wpolnrep);
    END LOOP;
    RETURN;
  END get_gipi_pack_wpolnrep;


/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description  : This inserts new record or updates record if existing.
*/
  PROCEDURE set_gipi_pack_wpolnrep(p_pack_par_id 		  IN  GIPI_PACK_WPOLNREP.pack_par_id%TYPE,          --pack_par_id to be inserted or updated
								   p_old_pack_policy_id   IN  GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE,   --old_pack_policy_id to be inserted or updated
                                   p_pol_flag        	  IN  GIPI_PACK_WPOLBAS.pol_flag%TYPE,             --pol_flag to be inserted or updated
                                   p_user_id         	  IN  GIPI_PACK_WPOLNREP.user_id%TYPE)         --application user_id to be inserted or updated
 IS
    v_par_type     GIPI_PACK_PARLIST.par_type%TYPE;
    v_policy_id    GIPI_PACK_POLBASIC.pack_policy_id%TYPE;
    v_ren_rep_sw   GIPI_PACK_WPOLNREP.ren_rep_sw%TYPE;
    v_rec_flag     GIPI_PACK_WPOLNREP.rec_flag%TYPE;

  BEGIN

    SELECT NVL(par_type,'P')
      INTO v_par_type
      FROM GIPI_PACK_PARLIST
    WHERE pack_par_id = p_pack_par_id;
    IF v_par_type = 'P' THEN
	   v_rec_flag := 'A';
    ELSE
	   v_rec_flag := 'D';
    END IF;

    IF p_pol_flag = '2' THEN
       v_ren_rep_sw := '1';
    ELSIF p_pol_flag = '3' THEN
       v_ren_rep_sw := '2';
    END IF;

    MERGE INTO gipi_pack_wpolnrep
    USING DUAL ON (pack_par_id        = p_pack_par_id
               AND old_pack_policy_id = p_old_pack_policy_id)
      WHEN NOT MATCHED THEN
        INSERT ( pack_par_id,   rec_flag,   old_pack_policy_id,   ren_rep_sw,    user_id, last_update)
        VALUES ( p_pack_par_id, v_rec_flag, p_old_pack_policy_id, v_ren_rep_sw , p_user_id, SYSDATE)
      WHEN MATCHED THEN
        UPDATE SET rec_flag    = v_rec_flag,
                   ren_rep_sw  = v_ren_rep_sw,
                   user_id     = p_user_id,
                   last_update = SYSDATE;
  END set_gipi_pack_wpolnrep;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description : This is used to delete the renewal/replacement records of the given pack_par_id.
*/

  PROCEDURE del_gipi_pack_wpolnreps (p_pack_par_id        GIPI_PACK_WPOLNREP.pack_par_id%TYPE) --pack_par_id of the records to be deleted
  IS
  BEGIN

    DELETE FROM gipi_pack_wpolnrep
     WHERE pack_par_id = p_pack_par_id;

  END del_gipi_pack_wpolnreps;


/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description : This is used to delete the renewal/replacement record.
*/
  PROCEDURE del_gipi_pack_wpolnrep (p_pack_par_id        GIPI_PACK_WPOLNREP.pack_par_id%TYPE,         --pack_par_id to limit deletion
									p_old_pack_policy_id GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE) --old_pack_policy_id to limit deletion
  IS
  BEGIN

    DELETE FROM gipi_pack_wpolnrep
     WHERE pack_par_id = p_pack_par_id
       AND old_pack_policy_id = p_old_pack_policy_id;

  END del_gipi_pack_wpolnrep;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created :  March 08, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description  : Checks if there is an existing renewing/replacing PAR.
*/
  PROCEDURE get_gipi_pack_wpolnrep_exist (
             p_pack_par_id      IN        GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
             p_exist            OUT       NUMBER)
    IS
    v_exist                    NUMBER := 0;
  BEGIN
    FOR a IN (SELECT 1
                FROM gipi_pack_wpolnrep
               WHERE pack_par_id = p_pack_par_id)
    LOOP
      v_exist := 1;
    END LOOP;
    p_exist := v_exist;
  END;

FUNCTION get_ongoing_pack_wpolnrep (p_old_pack_pol_id 		GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE,
                                    p_pack_par_id         	GIPI_PACK_WPOLNREP.pack_par_id%TYPE)
    RETURN VARCHAR2 IS

    v_result VARCHAR2(1) := 'N';
  BEGIN
    FOR CHK2 IN (
      SELECT '1'
        FROM GIPI_PACK_WPOLNREP
       WHERE old_pack_policy_id = p_old_pack_pol_id
         AND pack_par_id != p_pack_par_id)
    LOOP
      v_result := 'Y';
      EXIT;
    END LOOP;

    RETURN v_result;
END get_ongoing_pack_wpolnrep;

END gipi_pack_wpolnrep_Pkg;
/


