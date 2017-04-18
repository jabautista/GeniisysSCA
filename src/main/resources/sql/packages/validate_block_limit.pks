CREATE OR REPLACE PACKAGE CPI.Validate_Block_Limit AS

PROCEDURE limit_validation(p_par_id            GIPI_PARLIST.par_id%TYPE,
                           p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
						   v_block             OUT VARCHAR2,
						   v_type_exceed       OUT VARCHAR2,
						   v_share_type        GIIS_DIST_SHARE.share_type%TYPE,
						   v_Eff_Date          GIUW_POL_DIST.eff_date%TYPE,
		                   v_dist_spct         GIUW_WPOLICYDS_DTL.dist_spct%TYPE);

FUNCTION check_override_function(p_part       VARCHAR2,
		 					     p_module     VARCHAR2,
								 p_function   VARCHAR2,
							     p_user       VARCHAR2)
  RETURN VARCHAR2;

END;
/


