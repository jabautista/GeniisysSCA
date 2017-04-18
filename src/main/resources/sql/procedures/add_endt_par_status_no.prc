DROP PROCEDURE CPI.ADD_ENDT_PAR_STATUS_NO;

CREATE OR REPLACE PROCEDURE CPI.ADD_ENDT_PAR_STATUS_NO(p_par_id     IN gipi_parlist.par_id%TYPE,
                            p_line_cd    IN gipi_parlist.line_cd%TYPE, --:b240.line_cd
							p_iss_cd	IN gipi_parlist.iss_cd%TYPE, ----:b240.iss_cd
                            p_endt_tax_sw IN OUT gipi_wendttext.endt_tax%TYPE,
							p_co_ins_sw IN VARCHAR2,							
							p_negate_item					IN VARCHAR2,
						    p_prorate_flag 				IN GIPI_WPOLBAS.prorate_flag%TYPE,
						    p_comp_sw						IN VARCHAR2,
						    p_endt_expiry_date			IN VARCHAR2,
						    p_eff_date					IN VARCHAR2,
						    p_short_rt_percent			IN GIPI_WPOLBAS.short_rt_percent%TYPE,
						    p_expiry_date					IN VARCHAR2,
						    p_message						OUT VARCHAR2) IS
  p_dist_no     giuw_pol_dist.dist_no%TYPE;
  v_exist 			VARCHAR2(1) := 'N';
BEGIN
  FOR a IN (SELECT    dist_no    
					    FROM    giuw_pol_dist
					   WHERE    par_id  =  p_par_id)
  LOOP
  	CHANGES_IN_PAR_STATUS_2(p_par_id, a.dist_no, p_line_cd, p_iss_cd, p_endt_tax_sw, p_co_ins_sw,
							p_negate_item, p_prorate_flag, p_comp_sw, p_endt_expiry_date,p_eff_date,
  										  p_short_rt_percent, p_expiry_date, p_message);
  	v_exist := 'Y';
  END LOOP;
  
  IF v_exist = 'N' THEN
  	CHANGES_IN_PAR_STATUS_2(p_par_id, p_dist_no, p_line_cd, p_iss_cd, p_endt_tax_sw, p_co_ins_sw,
							p_negate_item, p_prorate_flag, p_comp_sw, p_endt_expiry_date,p_eff_date,
  										  p_short_rt_percent, p_expiry_date, p_message);
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF p_line_cd = 'FI' THEN
       CHANGES_IN_PAR_STATUS_2(p_par_id, p_dist_no, p_line_cd, p_iss_cd, p_endt_tax_sw, p_co_ins_sw,
							p_negate_item, p_prorate_flag, p_comp_sw, p_endt_expiry_date,p_eff_date,
  										  p_short_rt_percent, p_expiry_date, p_message);
	END IF;
END;
/


