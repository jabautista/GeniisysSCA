CREATE OR REPLACE PACKAGE CPI.GIPI_PARHIST_PKG AS

  PROCEDURE check_parhist(p_par_id		GIPI_PARHIST.par_id%TYPE,
  						  p_underwriter GIPI_PARLIST.underwriter%TYPE);
						  
  FUNCTION get_par_id (p_par_id			  GIPI_PARHIST.par_id%TYPE)
    RETURN NUMBER;

  PROCEDURE set_gipi_parhist(p_par_id	  		GIPI_PARHIST.par_id%TYPE,
  							 p_user_id	  		GIPI_PARHIST.user_id%TYPE,
							 p_entry_source 	GIPI_PARHIST.entry_source%TYPE,
							 p_parstat_cd		GIPI_PARHIST.parstat_cd%TYPE);

  PROCEDURE update_parhist(p_par_id     NUMBER,
			               p_new_par_id NUMBER,
				           p_user_id    GIIS_USERS.USER_ID%TYPE);
  
  PROCEDURE delete_parhist(p_par_id  NUMBER,
  						   p_user_id VARCHAR2);
  
  PROCEDURE save_cancel_rec_to_parhist(p_par_id GIPI_PARLIST.par_id%TYPE,
                                               p_par_status GIPI_PARLIST.par_status%TYPE);
   
END GIPI_PARHIST_PKG;
/


