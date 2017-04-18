DROP PROCEDURE CPI.PACKAGE_COMMISSION;

CREATE OR REPLACE PROCEDURE CPI.PACKAGE_COMMISSION(
    p_new_par_id    gipi_witmperl.par_id%TYPE,
    p_proc_intm_no  giis_intermediary.intm_no%TYPE,
    p_dsp_iss_cd    giis_intm_special_rate.iss_cd%TYPE,
    p_msg       OUT VARCHAR2
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : PACKAGE_COMMISSION program unit 
  */
  FOR REC IN ( SELECT DISTINCT a.pack_line_cd pack_line_cd,
                               a.pack_subline_cd pack_subline_cd,
                               a.item_grp item_grp 
                 FROM gipi_witem a, gipi_winvoice b
                WHERE a.par_id = b.par_id
                  AND a.item_grp = b.item_grp
                  AND b.par_id = p_new_par_id) 
  LOOP
      CHECK_COVERAGE(rec.pack_line_cd, rec.pack_subline_cd, p_msg);
      populate_package_perils(rec.item_grp, p_new_par_id, p_proc_intm_no, p_dsp_iss_cd, p_msg);
  END LOOP;
END;
/


