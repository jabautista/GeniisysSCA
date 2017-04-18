DROP PROCEDURE CPI.EXTRACT_SUMMARY;

CREATE OR REPLACE PROCEDURE CPI.EXTRACT_SUMMARY(
    p_is_package            IN  VARCHAR2,
    p_proc_expiry_date      IN  gipi_wpolbas.eff_date%TYPE,
    p_proc_assd_no          IN  gipi_wpolbas.assd_no%TYPE,
    p_proc_same_polno_sw    IN  giex_expiry.same_polno_sw%TYPE,
    p_old_pol_id            IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw       IN  giex_expiry.summary_sw%TYPE,
    p_proc_renew_flag       IN  giex_expiry.renew_flag%TYPE,
  --p_new_pack_par_id      OUT  gipi_parlist.pack_par_id%TYPE, replaced by: Nica 03.01.2103
	p_new_pack_par_id   IN OUT  gipi_parlist.pack_par_id%TYPE,
    p_user                  IN  gipi_parhist.user_id%TYPE,
    p_new_par_id           OUT  gipi_wpolnrep.par_id%type,
    p_old_pol_id_pack       IN  gipi_wpolnrep.old_policy_id%type,
    p_line_ac               IN  gipi_polbasic.line_cd%TYPE,
    p_menu_line_cd          IN  giis_line.line_cd%TYPE,
    p_line_ca               IN  gipi_polbasic.line_cd%TYPE,
    p_line_av               IN  gipi_polbasic.line_cd%TYPE,
    p_line_fi               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mc               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mn               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mh               IN  gipi_polbasic.line_cd%TYPE,
    p_line_en               IN  gipi_polbasic.line_cd%TYPE,
    p_vessel_cd             IN  giis_vessel.vessel_cd%TYPE,
    p_subline_bpv           IN  gipi_wpolbas.subline_cd%TYPE,
    p_open_flag             IN  giis_subline.op_flag%TYPE,
    p_nbt_line_cd           IN  gipi_pack_polbasic.line_cd%TYPE,
    p_line_su               IN  gipi_polbasic.line_cd%TYPE,
    p_proc_intm_no          IN  giex_expiry.intm_no%TYPE,
    p_dsp_line_cd           IN  giis_line_subline_coverages.line_cd%TYPE,
    p_dsp_iss_cd            IN  giis_intm_special_rate.iss_cd%TYPE,
    p_proc_line_cd          IN  gipi_polbasic.line_cd%TYPE,
    p_proc_subline_cd       IN  gipi_polbasic.subline_cd%TYPE,
    p_subline_bbi           IN  gipi_wpolbas.subline_cd%TYPE,
    p_is_subpolicy          IN  VARCHAR2,
    p_message_box       IN OUT  VARCHAR2,
    p_msg                  OUT  VARCHAR2
)
IS
   v_switch    VARCHAR2(1)  := 'N';
   v_exist     VARCHAR2(1)  := 'N';
   v_par_stats NUMBER:=0;
   v_ex_stats  NUMBER:=0;
   v_message   VARCHAR2(100);
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : EXTRACT_SUMMARY program unit 
  */
  v_message := 'E x t r a c t i n g   S u m m a r i z e   D a t a ';

  /* FOR c IN 1..(NVL(NVL(LENGTH(v_message), 0), 0))
  LOOP
  --SYNCHRONIZE_MESSAGE(SUBSTR(variables.v_message, NVL(NVL(LENGTH(variables.v_message), 0), 0) - c));
    FOR c1 IN 1..1500
    LOOP
      NULL;
    END LOOP;
  END LOOP; */ -- marco - 04.10.2013 - comment out for loop
               
  /*IF GET_VIEW_PROPERTY('warning', VISIBLE) = 'FALSE' THEN
     CURSOR_BUSY;
  END IF;
  */
  /* added by gmi 060607 
  ** to include package considerations.. hehe tama ba english? hehe
  ** basta para magkalaman ang package tables..
  */
  IF p_is_package = 'Y' THEN
      populate_summary_pack_tab(p_old_pol_id, p_proc_summary_sw, p_msg, p_proc_expiry_date, p_proc_assd_no, p_proc_same_polno_sw, p_proc_renew_flag, p_user, p_proc_intm_no, 
                            p_dsp_line_cd, p_dsp_iss_cd, p_proc_line_cd, p_line_ca, p_menu_line_cd, p_proc_subline_cd, p_subline_bbi, p_message_box, p_new_pack_par_id, p_new_par_id);      
      v_ex_stats  := 5;      
      FOR POL IN (SELECT par_id
                    FROM gipi_parlist 
                   WHERE pack_par_id = p_new_par_id) 
      LOOP
          v_par_stats := 3;
          FOR ITEM IN (SELECT '1'
                         FROM gipi_witem a
                        WHERE a.par_id = POL.par_id)
          LOOP
             v_par_stats := 4;
             EXIT;
          END LOOP;
          FOR PERL IN ( SELECT '1'
                          FROM gipi_witmperl a
                        WHERE a.par_id = POL.par_id)
          LOOP
             v_par_stats := 5;
             EXIT;
          END LOOP;  
          IF v_par_stats < v_ex_stats THEN
              v_ex_stats := v_par_stats;
          END IF;
      END LOOP;
      UPDATE gipi_pack_parlist
       SET par_status = v_ex_stats
     WHERE pack_par_id = p_new_par_id;
        --CLEAR_MESSAGE;      
  ELSE
      populate_summary_tab(p_proc_expiry_date, p_proc_assd_no, p_proc_same_polno_sw, p_old_pol_id, p_proc_summary_sw, p_proc_renew_flag, p_new_pack_par_id, p_user,p_old_pol_id_pack, 
                        p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc, p_line_mn, p_line_mh, p_line_en, p_vessel_cd, p_subline_bpv, p_open_flag, p_nbt_line_cd, 
                        p_line_su, p_proc_intm_no, p_dsp_line_cd, p_dsp_iss_cd, p_proc_line_cd, p_proc_subline_cd, p_subline_bbi, p_is_subpolicy, p_message_box, p_new_par_id, p_msg);
      UPDATE gipi_parlist
         SET par_status = 3 --:par.par_status
       WHERE par_id = p_new_par_id;
      FOR ITEM IN ( SELECT '1'
                     FROM gipi_witem
                    WHERE par_id = p_new_par_id)
      LOOP
        UPDATE gipi_parlist
           SET par_status = 4 --:par.par_status
         WHERE par_id = p_new_par_id;
         EXIT;
      END LOOP;
      FOR PERL IN ( SELECT '1'
                      FROM gipi_witmperl
                     WHERE par_id = p_new_par_id)
      LOOP
        UPDATE gipi_parlist
           SET par_status = 5 --:par.par_status
         WHERE par_id = p_new_par_id;
         EXIT;
      END LOOP;  
      --CLEAR_MESSAGE;
  END IF;  
END;
/


