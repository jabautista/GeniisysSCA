CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PARHIST_PKG AS

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 12, 2010
**  Reference By : (GIPIS050 - PAR Creation)
**  Description  : This checks the existence of a PAR in the GIPI_PARHIST table.
*/
  PROCEDURE check_parhist(p_par_id		GIPI_PARHIST.par_id%TYPE,
  						  p_underwriter GIPI_PARLIST.underwriter%TYPE) IS
	v_par_id			  GIPI_PARHIST.par_id%TYPE;
  BEGIN
    SELECT PAR_ID
      INTO v_par_id
      FROM GIPI_PARHIST
     WHERE PAR_ID = p_par_id;
  EXCEPTION
      WHEN NO_DATA_FOUND
        THEN
		  set_gipi_parhist(p_par_id, p_underwriter, 'DB','1');
  END;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 15, 2010
**  Reference By : Gipi_Wopen_Policy_Pkg
**  Description  : This checks the existence of a PAR in the GIPI_PARHIST table.
*/
  FUNCTION get_par_id (p_par_id			  GIPI_PARHIST.par_id%TYPE)
    RETURN NUMBER IS
	par_id	  NUMBER := NULL;
  BEGIN
    FOR i IN (
		SELECT par_id
		  FROM GIPI_PARHIST
		 WHERE par_id     = p_par_id
		 	 )
	LOOP
		par_id			:= i.par_id;
	END LOOP;
	RETURN par_id;
  END;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 9, 2010
**  Reference By :
**  Description  : Inserts data into GIPI_PARHIST table
*/
  PROCEDURE set_gipi_parhist(p_par_id	  		GIPI_PARHIST.par_id%TYPE,
  							 p_user_id	  		GIPI_PARHIST.user_id%TYPE,
							 p_entry_source 	GIPI_PARHIST.entry_source%TYPE,
							 p_parstat_cd		GIPI_PARHIST.parstat_cd%TYPE)
    IS
  BEGIN
    INSERT INTO GIPI_PARHIST(PAR_ID, USER_ID, PARSTAT_DATE,
                                   ENTRY_SOURCE, PARSTAT_CD)
          VALUES(p_par_id, p_user_id, SYSDATE, p_entry_source,p_parstat_cd);
  END set_gipi_parhist;


  PROCEDURE  update_parhist(p_par_id     NUMBER,
			                p_new_par_id NUMBER,
				            p_user_id    GIIS_USERS.USER_ID%TYPE) IS
  BEGIN

    FOR i IN (SELECT user_id,parstat_date,entry_source,parstat_cd
			    FROM gipi_parhist
			   WHERE par_id = p_par_id) LOOP

	  IF i.parstat_cd = '3' THEN
        IF i.parstat_date = sysdate THEN
          INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
          VALUES (p_new_par_id,p_user_id, sysdate + (1/1440),'DB','3');
        ELSE
          INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
          VALUES (p_new_par_id,p_user_id, sysdate + (1/1440),'DB','3');
        END IF;
      ELSIF i.parstat_cd = '1'  THEN
        INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
        VALUES (p_new_par_id, i.user_id, i.parstat_date,'DB','1');

        INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
        VALUES (p_new_par_id, i.user_id, i.parstat_date,'DB','2');
      ELSE
        INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
        VALUES (p_new_par_id, i.user_id, i.parstat_date,'DB','4');
      END IF;

	END LOOP;

  END;

  PROCEDURE delete_parhist(p_par_id  NUMBER,
  						   p_user_id VARCHAR2) IS
  BEGIN
    INSERT INTO gipi_parhist(par_id, user_id, parstat_date, entry_source, parstat_cd)
                     VALUES (p_par_id, p_user_id, SYSDATE + 1/86400, 'DB', '5');
  END;

  PROCEDURE save_cancel_rec_to_parhist(p_par_id GIPI_PARLIST.par_id%TYPE,
                                       p_par_status GIPI_PARLIST.par_status%TYPE)
  IS

  v_par_id              GIPI_PARLIST.par_id%TYPE;
  v_underwriter         GIPI_PARLIST.underwriter%TYPE;
  v_cpi_rec_no          GIPI_PARLIST.cpi_rec_no%TYPE;
  v_cpi_branch_cd       GIPI_PARLIST.cpi_branch_cd%TYPE;

  BEGIN
            BEGIN
		     FOR a IN (SELECT par_status, par_id, cpi_rec_no, cpi_branch_cd, underwriter
		                 FROM gipi_parlist
		                WHERE par_id = p_par_id)

	         LOOP
               v_underwriter   := a.underwriter;
	  	       v_par_id        := a.par_id;
	  	       v_cpi_rec_no    := a.cpi_rec_no;
	  	       v_cpi_branch_cd := a.cpi_branch_cd;
	         END LOOP;

	     END;


	     BEGIN
	       INSERT INTO gipi_parhist(par_id, user_id, parstat_date,
	                          entry_source, parstat_cd, cpi_rec_no, cpi_branch_cd)
	            VALUES (v_par_id, v_underwriter, SYSDATE,
	                          NULL, p_par_status, v_cpi_rec_no, v_cpi_branch_cd);
	     END;

  END;

END GIPI_PARHIST_PKG;
/


