DROP PROCEDURE CPI.PERFORM_REVERSAL_GIUTS004;

CREATE OR REPLACE PROCEDURE CPI.perform_reversal_giuts004(
    p_line_cd           IN      giri_binder.line_cd%TYPE,
    p_reverse_sw        IN      giri_frps_ri.reverse_sw%TYPE,
    p_fnl_binder_id     IN      giri_binder.fnl_binder_id%TYPE,
    p_frps_yy           IN      giri_frps_ri.frps_yy%TYPE,
    p_frps_seq_no       IN      giri_frps_ri.frps_seq_no%TYPE,
    p_dist_no           IN      giuw_pol_dist.dist_no%TYPE,
    p_user_id           IN      VARCHAR2,      
    p_workflow_msgr     OUT     VARCHAR2,
    p_msg               OUT     VARCHAR2
) 
IS
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 08.19.2011
    **  Reference By     : (GIUTS004- Reverse Binder)
    **  Description      : If reverse_sw is checked, insert to GIRI_BINDREL,
    **                     otherwise copy record from master to working table.
    */
    v_year                NUMBER;
    v_binder_id           giri_binder.fnl_binder_id%TYPE;
    v_fbndr_seq_no        giis_fbndr_seq.fbndr_seq_no%TYPE;
    v_msg                 VARCHAR2(100);
    v_workflow_msgr       VARCHAR2(100);
BEGIN

    giis_fbndr_seq_pkg.get_parameters_giuts004(p_line_cd, v_year, v_binder_id, v_fbndr_seq_no);
         
    IF p_reverse_sw = 'Y' THEN
      UPDATE giri_frps_ri
         SET reverse_sw = 'Y'
       WHERE fnl_binder_id = p_fnl_binder_id;
      giri_bindrel_pkg.insert_to_bindrel(p_fnl_binder_id, v_binder_id, v_year, v_fbndr_seq_no);
    ELSIF p_reverse_sw = 'N' THEN
      giri_frps_ri_pkg.reverse_binder(p_fnl_binder_id, p_line_cd, p_frps_yy, p_frps_seq_no, p_dist_no);
    END IF;
           
    FOR c1 IN ( SELECT b.userid, d.event_desc  
                  FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                 WHERE 1=1
                   AND c.event_cd = a.event_cd
                   AND c.event_mod_cd = a.event_mod_cd
                   AND b.event_mod_cd = a.event_mod_cd
                   AND b.passing_userid = USER
                   AND a.module_id = 'GIUTS004'
                   AND a.event_cd = d.event_cd )
    LOOP
    create_transfer_workflow_rec(c1.event_desc,
                                 'GIUTS004',
                                 c1.userid,
                                 p_line_cd||'-'||p_frps_yy||'-'||p_frps_seq_no,
                                 c1.event_desc||' '||p_line_cd||'-'||LTRIM(TO_CHAR(p_frps_yy,'09'))||'-'||LTRIM(TO_CHAR(p_frps_seq_no,'09999999')),
                                 v_msg,
                                 v_workflow_msgr,
                                 p_user_id);
     END LOOP;
  
  p_workflow_msgr := v_workflow_msgr;
  p_msg := v_msg;
  
END perform_reversal_giuts004;
/


