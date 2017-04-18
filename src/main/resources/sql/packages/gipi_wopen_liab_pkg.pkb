CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wopen_Liab_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 09, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Function to retrieve cargo limits of liability records. 
*/
  FUNCTION get_gipi_wopen_liab (p_par_id IN GIPI_WOPEN_LIAB.par_id%TYPE)  --par_id to limit the query
    RETURN gipi_wopen_liab_tab PIPELINED IS
    
    v_wopen_liab  gipi_wopen_liab_type;
    
  BEGIN
    FOR i IN (
        SELECT a.par_id,        a.geog_cd,         b.geog_desc,   a.currency_cd,
               c.currency_desc, a.limit_liability, a.currency_rt, a.voy_limit,
               a.rec_flag,      NVL(a.with_invoice_tag, 'N') with_invoice_tag, b.line_cd
          FROM GIPI_WOPEN_LIAB a
              ,GIIS_GEOG_CLASS b
              ,GIIS_CURRENCY   c
              ,GIPI_PARLIST    d
         WHERE a.par_id      = p_par_id
           AND a.geog_cd     = b.geog_cd
           AND a.currency_cd = c.main_currency_cd
           AND a.par_id      = d.par_id)
    LOOP
        v_wopen_liab.par_id           := i.par_id;
        v_wopen_liab.geog_cd          := i.geog_cd;
        v_wopen_liab.geog_desc        := i.geog_desc;
        v_wopen_liab.currency_cd      := i.currency_cd;
        v_wopen_liab.currency_desc    := i.currency_desc;
        v_wopen_liab.limit_liability  := i.limit_liability;
        v_wopen_liab.currency_rt      := i.currency_rt;
        v_wopen_liab.voy_limit        := i.voy_limit;
        v_wopen_liab.rec_flag         := i.rec_flag;
        v_wopen_liab.with_invoice_tag := i.with_invoice_tag;
        v_wopen_liab.line_cd          := i.line_cd;    
      PIPE ROW(v_wopen_liab);
    END LOOP;
    RETURN;
  END get_gipi_wopen_liab;      

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 09, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to insert new limit of liability record and update existing record. 
*/
  Procedure set_gipi_wopen_liab (p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE)  --gipi_wopen_liab row type to be inserted or to be updated.
  IS
  BEGIN
    MERGE INTO GIPI_WOPEN_LIAB
    USING DUAL ON (par_id  = p_wopen_liab.par_id
               AND geog_cd = p_wopen_liab.geog_cd)
      WHEN NOT MATCHED THEN
        INSERT (par_id,      geog_cd,   currency_cd, limit_liability,
                currency_rt, voy_limit, rec_flag,    with_invoice_tag, create_user, 
                user_id, last_update)
        VALUES (p_wopen_liab.par_id,      p_wopen_liab.geog_cd,   p_wopen_liab.currency_cd, p_wopen_liab.limit_liability,
                p_wopen_liab.currency_rt, p_wopen_liab.voy_limit, p_wopen_liab.rec_flag,    p_wopen_liab.with_invoice_tag, p_wopen_liab.user_id,
                p_wopen_liab.user_id, sysdate)
      WHEN MATCHED THEN
        UPDATE SET currency_cd      = p_wopen_liab.currency_cd,
                   limit_liability  = p_wopen_liab.limit_liability,
                   currency_rt      = p_wopen_liab.currency_rt,
                   voy_limit        = p_wopen_liab.voy_limit,
                   rec_flag         = p_wopen_liab.rec_flag,
                   with_invoice_tag = p_wopen_liab.with_invoice_tag,
                   user_id          = p_wopen_liab.user_id,
                   last_update      = sysdate;
                     
  END set_gipi_wopen_liab;      

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 09, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to delete cargo limit of liability record and all dependent records. 
*/
  Procedure del_gipi_wopen_liab (p_par_id  IN GIPI_WOPEN_LIAB.par_id%TYPE,   --par_id to limit the deletion
                                 p_geog_cd IN GIPI_WOPEN_LIAB.geog_cd%TYPE)  --geog_cd to limit the deletion
  IS
  BEGIN
    Pre_Delete_Gipis005(p_par_id, p_geog_cd);
  
    DELETE FROM GIPI_WOPEN_LIAB
     WHERE par_id  = p_par_id
       AND geog_cd = p_geog_cd;
   
  END del_gipi_wopen_liab;
  
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.09.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for deleting records in GIPI_WOPEN_LIAB using the given par_id
	*/
	Procedure del_gipi_wopen_liab (p_par_id IN GIPI_WOPEN_LIAB.par_id%TYPE)
	IS
	BEGIN
		DELETE GIPI_WOPEN_LIAB
		 WHERE par_id = p_par_id;
	END del_gipi_wopen_liab;
    
    /*
    **  Created by   : Marco Paolo Rebong
    **  Date Created : November 13, 2012
    **  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
    **  Description  : gets default value of currency code and currency rate from original policy
    */
    PROCEDURE get_default_currency(
        p_line_cd       IN  GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd    IN  GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        IN  GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy      IN  GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    IN  GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no      IN  GIPI_WPOLBAS.renew_no%TYPE,
        p_currency_cd   OUT GIPI_WOPEN_LIAB.currency_cd%TYPE,
        p_currency_rt   OUT GIPI_WOPEN_LIAB.currency_rt%TYPE,
        p_currency_desc OUT GIIS_CURRENCY.currency_desc%TYPE
    )
    IS
    BEGIN
        FOR i IN(SELECT currency_cd, currency_rt
	               FROM GIPI_OPEN_LIAB
	              WHERE policy_id = (SELECT policy_id
	                                   FROM GIPI_POLBASIC
	                                  WHERE line_cd = p_line_cd
	                                    AND subline_cd = p_subline_cd
	                                    AND iss_cd = p_iss_cd
	                                    AND issue_yy = p_issue_yy
	                                    AND pol_seq_no = p_pol_seq_no
	                                    AND renew_no = p_renew_no
	                                    AND NVL(endt_seq_no, 0) = 0))
        LOOP
            p_currency_rt := i.currency_rt;
	        p_currency_cd := i.currency_cd;	    	
	        FOR d IN(SELECT currency_desc
                       FROM GIIS_CURRENCY
                      WHERE main_currency_cd = i.currency_cd)
            LOOP
                p_currency_desc	:= d.currency_desc;
                EXIT;
            END LOOP;
        END LOOP;    
    END;
    
    /*
    **  Created by   : Marco Paolo Rebong
    **  Date Created : November 13, 2012
    **  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
    **  Description  : INSERT/UPDATE with UPDATE_GIPI_WITEM program unit
    */
    PROCEDURE set_gipi_wopen_liab_endt(
        p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE
    )
    IS
        v_exist             VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN(SELECT 1
                   FROM GIPI_WOPEN_LIAB
                  WHERE par_id = p_wopen_liab.par_id
                    AND geog_cd = p_wopen_liab.geog_cd)
        LOOP
            v_exist := 'Y';
        END LOOP;
        
        IF v_exist = 'N' THEN
            INSERT INTO GIPI_WOPEN_LIAB
                   (par_id, geog_cd, currency_cd, limit_liability,
                    currency_rt, voy_limit, rec_flag, with_invoice_tag,
                    create_user, create_date)
            VALUES (p_wopen_liab.par_id, p_wopen_liab.geog_cd, p_wopen_liab.currency_cd,  p_wopen_liab.limit_liability,
                    p_wopen_liab.currency_rt, p_wopen_liab.voy_limit, p_wopen_liab.rec_flag, p_wopen_liab.with_invoice_tag,
                    p_wopen_liab.user_id, SYSDATE);
        ELSE
            UPDATE GIPI_WITEM
               SET tsi_amt = p_wopen_liab.limit_liability,
                   ann_tsi_amt = p_wopen_liab.limit_liability,
                   currency_cd = p_wopen_liab.currency_cd,
                   currency_rt = p_wopen_liab.currency_rt
             WHERE par_id = p_wopen_liab.par_id
               AND item_no = 1;
               
            UPDATE GIPI_WITMPERL
               SET tsi_amt = p_wopen_liab.limit_liability,
                   ann_tsi_amt = p_wopen_liab.limit_liability
             WHERE par_id = p_wopen_liab.par_id
               AND tsi_amt != 0;
        
            UPDATE GIPI_WOPEN_LIAB
               SET currency_cd = p_wopen_liab.currency_cd,
                   limit_liability = p_wopen_liab.limit_liability,
                   currency_rt = p_wopen_liab.currency_rt,
                   voy_limit = p_wopen_liab.voy_limit,
                   rec_flag = p_wopen_liab.rec_flag,
                   with_invoice_tag = p_wopen_liab.with_invoice_tag,
                   user_id = p_wopen_liab.user_id,
                   last_update = SYSDATE
             WHERE par_id = p_wopen_liab.par_id
               AND geog_cd = p_wopen_liab.geog_cd;
        END IF;
    END;
 
END Gipi_Wopen_Liab_Pkg;
/


