DROP PROCEDURE CPI.COPY_POL_WCARGO_HULL_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcargo_hull_2(
    p_line          IN giis_subline.line_cd%TYPE,
    p_subline       IN giis_subline.subline_cd%TYPE,
    p_new_policy_id IN gipi_ves_air.policy_id%TYPE,
    p_old_pol_id    IN gipi_ves_air.policy_id%TYPE,
    p_line_mn       IN VARCHAR2,
    p_subline_mop   IN VARCHAR2,
    p_subline_mrn   IN VARCHAR2,
    p_line_mh       IN VARCHAR2,
    p_line_av       IN VARCHAR2
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wcargo_hull program unit 
  */
  IF p_line = p_line_mn THEN
     IF p_subline <> p_subline_mop THEN
        copy_pol_wves_air_2(p_new_policy_id, p_old_pol_id);
        copy_pol_wcargo_2(p_new_policy_id, p_old_pol_id);
       --copy_pol_wves_air;
        IF p_subline = p_subline_mrn THEN
          copy_pol_wopen_policy_2(p_new_policy_id, p_old_pol_id);
        END IF;
     ELSIF p_subline = p_subline_mop THEN
       copy_pol_wopen_liab_2(p_new_policy_id, p_old_pol_id);
       copy_pol_wopen_peril_2(p_new_policy_id, p_old_pol_id);
       copy_pol_wopen_cargo_2(p_new_policy_id, p_old_pol_id);
     END IF;   
  ELSIF p_line = p_line_mh THEN
     copy_pol_witem_ves_2(p_new_policy_id, p_old_pol_id);
  ELSIF p_line = p_line_av THEN
     copy_pol_waviation_item_2(p_new_policy_id, p_old_pol_id);
  END IF;

END;
/


