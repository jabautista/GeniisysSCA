CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wpolnrep_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description  : This retrieves the renewal/replacement details records of the given par_id. 
*/
  FUNCTION get_gipi_wpolnrep (p_par_id     GIPI_WPOLNREP.par_id%TYPE) --par_id of the records to be retrieved.
    RETURN gipi_wpolnrep_tab PIPELINED IS
  
  v_wpolnrep   gipi_wpolnrep_type;
  
  BEGIN
    FOR i IN (
        SELECT a.par_id,   a.rec_flag,   a.old_policy_id, a.ren_rep_sw,  
               c.line_cd,  c.subline_cd, c.pol_seq_no,    c.iss_cd,   
               c.issue_yy, c.renew_no
          FROM GIPI_WPOLNREP a
              ,GIPI_WPOLBAS  b
              ,GIPI_POLBASIC c
         WHERE a.par_id        = p_par_id
           AND a.par_id        = b.par_id
           AND a.old_policy_id = c.policy_id)
    LOOP
        v_wpolnrep.par_id          := i.par_id;  
        v_wpolnrep.rec_flag        := i.rec_flag;
        v_wpolnrep.old_policy_id   := i.old_policy_id;
        v_wpolnrep.ren_rep_sw      := i.ren_rep_sw;
        v_wpolnrep.line_cd         := i.line_cd;
        v_wpolnrep.subline_cd      := i.subline_cd;
        v_wpolnrep.pol_seq_no      := i.pol_seq_no;
        v_wpolnrep.iss_cd          := i.iss_cd;
        v_wpolnrep.issue_yy        := i.issue_yy;
        v_wpolnrep.renew_no        := i.renew_no;
    END LOOP;
    
    -- expiry_date; added by Halley 02.19.14
    BEGIN
        SELECT expiry_date
          INTO v_wpolnrep.expiry_date 
          FROM gipi_polbasic a
         WHERE line_cd = v_wpolnrep.line_cd
           AND subline_cd = v_wpolnrep.subline_cd
           AND iss_cd = v_wpolnrep.iss_cd
           AND issue_yy = v_wpolnrep.issue_yy
           AND pol_seq_no = v_wpolnrep.pol_seq_no
           AND renew_no = v_wpolnrep.renew_no
           AND endt_seq_no IN (
                           SELECT MAX (endt_seq_no) endt_seq_no
                             FROM gipi_polbasic b
                            WHERE line_cd = a.line_cd
                              AND subline_cd = a.subline_cd
                              AND iss_cd = a.iss_cd
                              AND issue_yy = a.issue_yy
                              AND pol_seq_no = a.pol_seq_no
                              AND renew_no = a.renew_no);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
    END;                              
        
    PIPE ROW(v_wpolnrep);
    RETURN;
  END get_gipi_wpolnrep; 


/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description  : This inserts new record or updates record if existing.  
**  Modified by  : Gzelle
**  Description  : Added user_id in Insert  
*/ 
  PROCEDURE set_gipi_wpolnrep(p_par_id          IN  GIPI_WPOLNREP.par_id%TYPE,          --par_id to be inserted or updated
                              p_old_policy_id   IN  GIPI_WPOLNREP.old_policy_id%TYPE,   --old_policy_id to be inserted or updated
                              p_pol_flag        IN  GIPI_WPOLBAS.pol_flag%TYPE,         --pol_flag to be inserted or updated
                              p_user_id         IN  GIPI_WPOLNREP.user_id%TYPE)         --application user_id to be inserted or updated 
 IS
    
    v_policy_id    GIPI_POLBASIC.policy_id%TYPE;
    v_ren_rep_sw   GIPI_WPOLNREP.ren_rep_sw%TYPE;
    v_rec_flag     GIPI_WPOLNREP.rec_flag%TYPE;
    
  BEGIN
  
    v_rec_flag := Gipi_Parlist_Pkg.GET_REC_FLAG(p_par_id);
          
    IF p_pol_flag = '2' THEN
       v_ren_rep_sw := '1';
    ELSIF p_pol_flag = '3' THEN
       v_ren_rep_sw := '2';
    END IF;      
     
    MERGE INTO GIPI_WPOLNREP
    USING DUAL ON (par_id        = p_par_id
               AND old_policy_id = p_old_policy_id)
      WHEN NOT MATCHED THEN
        INSERT ( par_id,   rec_flag,   old_policy_id,   ren_rep_sw,    create_user, user_id,   last_update)
        VALUES ( p_par_id, v_rec_flag, p_old_policy_id, v_ren_rep_sw , p_user_id,   p_user_id, SYSDATE)
      WHEN MATCHED THEN
        UPDATE SET rec_flag    = v_rec_flag,
                   ren_rep_sw  = v_ren_rep_sw,
                   user_id     = p_user_id;
    --COMMIT;                  
  END set_gipi_wpolnrep;   
    
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description : This is used to delete the renewal/replacement records of the given par_id. 
*/
  PROCEDURE del_gipi_wpolnreps (p_par_id        GIPI_WPOLNREP.par_id%TYPE) --par_id of the records to be deleted 
  IS
  BEGIN
  
    DELETE FROM GIPI_WPOLNREP
     WHERE par_id = p_par_id;
        
    --COMMIT;
  END del_gipi_wpolnreps;


/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  September 17, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description : This is used to delete the renewal/replacement record. 
*/
  PROCEDURE del_gipi_wpolnrep (p_par_id        GIPI_WPOLNREP.par_id%TYPE,         --par_id to limit deletion
                               p_old_policy_id GIPI_WPOLNREP.old_policy_id%TYPE) --old_policy_id to limit deletion 
  IS
  BEGIN
  
    DELETE FROM GIPI_WPOLNREP
     WHERE par_id = p_par_id
       AND old_policy_id = p_old_policy_id;
       
  END del_gipi_wpolnrep;
  
  
  PROCEDURE get_gipi_wpolnrep_exist (
             p_par_id          IN        GIPI_WPOLNREP.par_id%TYPE,
             p_exist            OUT        NUMBER)
    IS
    v_exist                    NUMBER := 0;
  BEGIN
    FOR a IN (SELECT 1 
                FROM GIPI_WPOLNREP
               WHERE par_id = p_par_id)
    LOOP
      v_exist := 1;
    END LOOP;
    p_exist := v_exist;
  END;
  
/*
**  Created by   : Menandro G.C. Robes
**  Date Created : July 15, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description  : Returns Y if there is an existing renewing/replacing PAR 
*/    
  FUNCTION get_ongoing_wpolnrep (p_old_policy_id GIPI_WPOLNREP.old_policy_id%TYPE,
                                 p_par_id        GIPI_WPOLNREP.par_id%TYPE)
    RETURN VARCHAR2 IS
    
    v_result VARCHAR2(1) := 'N';
  BEGIN
    FOR CHK2 IN (
      SELECT '1'
        FROM gipi_wpolnrep
       WHERE old_policy_id = p_old_policy_id
         AND par_id != p_par_id
         AND par_id NOT IN (SELECT par_id FROM gipi_parlist WHERE par_status IN (98,99))) --added by gab 05.05.2016 SR 21421
    LOOP
      v_result := 'Y';
      EXIT;
    END LOOP;    
        
    RETURN v_result;
  END get_ongoing_wpolnrep;    
  
  /*
**  Created by   : Alcantara, Darwin
**  Date Created : Sept. 12, 2012
**  Reference By : GIPIS002A
**  Description  : inserts gipi_wpolnrep records of a package par
*/   
  PROCEDURE set_wpolnrep_sublines (
    p_pack_par_id           IN  GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
    p_old_pack_policy_id   IN  GIPI_PACK_WPOLNREP.old_pack_policy_id%TYPE
  ) IS
    v_par_type     GIPI_PACK_PARLIST.par_type%TYPE;
    v_policy_id    GIPI_PACK_POLBASIC.pack_policy_id%TYPE;
    v_ren_rep_sw   GIPI_PACK_WPOLNREP.ren_rep_sw%TYPE;
    v_rec_flag     GIPI_PACK_WPOLNREP.rec_flag%TYPE;
  BEGIN
    
    FOR i IN (
        SELECT * FROM gipi_wpolbas WHERE pack_par_id = p_pack_par_id
    ) LOOP
        FOR j IN (
            SELECT * FROM gipi_polbasic 
             WHERE pack_policy_id = p_old_pack_policy_id
               AND line_cd = i.line_cd
               AND subline_cd = i.subline_cd
        ) LOOP
            --declare variables
            SELECT NVL(par_type, 'P')
              INTO v_par_type
              FROM gipi_parlist
             WHERE par_id = i.par_id;
            IF v_par_type = 'P' THEN
               v_rec_flag := 'A';
            ELSE
               v_rec_flag := 'D';
            END IF;
            
            IF i.pol_flag = '2' THEN
                v_ren_rep_sw := '1';
            ELSIF i.pol_flag = '3' THEN
                v_ren_rep_sw := '2';
            END IF;
            dbms_output.put_line(i.line_cd||' - '||i.subline_cd||' - '||i.par_id||' - '||j.policy_id);
            -- insert to gipi_wpolnrep
            --gipi_polnrep
            MERGE INTO GIPI_WPOLNREP
            USING DUAL ON (par_id        = i.par_id
                       AND old_policy_id = j.policy_id)
              WHEN NOT MATCHED THEN
                INSERT ( par_id,   rec_flag,   old_policy_id,   ren_rep_sw,    create_user, user_id, last_update)
                VALUES ( i.par_id, v_rec_flag, j.policy_id, v_ren_rep_sw , NVL(GIIS_USERS_PKG.app_user, USER),
                         NVL(GIIS_USERS_PKG.app_user, USER), SYSDATE)
              WHEN MATCHED THEN
                UPDATE SET rec_flag    = v_rec_flag,
                           ren_rep_sw  = v_ren_rep_sw,
                           user_id     = NVL(GIIS_USERS_PKG.app_user, USER),
                           last_update = SYSDATE;
            EXIT;
        END LOOP;
        
    END LOOP;
  END set_wpolnrep_sublines;
  
  FUNCTION get_gipi_wpolnrep2(
    p_par_id     GIPI_WPOLNREP.par_id%TYPE
  )
    RETURN gipi_wpolnrep_tab PIPELINED
  IS
    v_wpolnrep   gipi_wpolnrep_type;
    v_pol_flag   VARCHAR(1); -- Added by Jerome Bautista SR 19653
  BEGIN
  
    BEGIN -- Added by Jerome Bautista SR 19653
        SELECT pol_flag
          INTO v_pol_flag
          FROM GIPI_WPOLBAS
         WHERE par_id = p_par_id;
    END;
    
    IF v_pol_flag = '2' THEN
    FOR i IN(SELECT a.par_id,   a.rec_flag,   a.old_policy_id, a.ren_rep_sw,  
                    c.line_cd,  c.subline_cd, c.pol_seq_no,    c.iss_cd,   
                    c.issue_yy, c.renew_no, c.expiry_date
               FROM GIPI_WPOLNREP a,
                    GIPI_WPOLBAS  b,
                    GIPI_POLBASIC c
              WHERE a.par_id = p_par_id
                AND a.par_id = b.par_id
                AND a.old_policy_id = c.policy_id
                AND c.pol_flag IN ('1','2','3','X')
                AND (nvl(c.spld_flag, 1) <> 3 AND c.spld_date IS NULL)) -- d.alcantara 09.20.2013
    LOOP
        v_wpolnrep.par_id := i.par_id;  
        v_wpolnrep.rec_flag := i.rec_flag;
        v_wpolnrep.old_policy_id := i.old_policy_id;
        v_wpolnrep.ren_rep_sw := i.ren_rep_sw;
        v_wpolnrep.line_cd := i.line_cd;
        v_wpolnrep.subline_cd := i.subline_cd;
        v_wpolnrep.pol_seq_no := i.pol_seq_no;
        v_wpolnrep.iss_cd := i.iss_cd;
        v_wpolnrep.issue_yy := i.issue_yy;
        v_wpolnrep.renew_no := i.renew_no;
        v_wpolnrep.expiry_date := extract_expiry2(i.line_cd, i.subline_cd, i.iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no);
      PIPE ROW(v_wpolnrep);
    END LOOP;
    ELSIF v_pol_flag = '3' THEN
    FOR i IN (SELECT a.par_id, a.rec_flag, a.old_policy_id, a.ren_rep_sw,
                     c.line_cd, c.subline_cd, c.pol_seq_no, c.iss_cd,
                     c.issue_yy, c.renew_no, c.expiry_date 
                 FROM GIPI_WPOLNREP a, 
                      GIPI_WPOLBAS b, 
                      GIPI_POLBASIC c 
                WHERE a.par_id = p_par_id 
                  AND a.par_id = b.par_id 
                  AND a.old_policy_id = c.policy_id 
                  AND c.pol_flag = '5' 
                  AND (nvl(c.spld_flag, 1) = 3 
                  AND c.spld_date IS NOT NULL))
    LOOP
        v_wpolnrep.par_id := i.par_id;  
        v_wpolnrep.rec_flag := i.rec_flag;
        v_wpolnrep.old_policy_id := i.old_policy_id;
        v_wpolnrep.ren_rep_sw := i.ren_rep_sw;
        v_wpolnrep.line_cd := i.line_cd;
        v_wpolnrep.subline_cd := i.subline_cd;
        v_wpolnrep.pol_seq_no := i.pol_seq_no;
        v_wpolnrep.iss_cd := i.iss_cd;
        v_wpolnrep.issue_yy := i.issue_yy;
        v_wpolnrep.renew_no := i.renew_no;
        v_wpolnrep.expiry_date := extract_expiry2(i.line_cd, i.subline_cd, i.iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no);
      PIPE ROW(v_wpolnrep);
    END LOOP;
    END IF;
  END;
  
END Gipi_Wpolnrep_Pkg;
/


