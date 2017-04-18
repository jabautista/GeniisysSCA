DROP FUNCTION CPI.CHK_BINDER_WITH_CLAIM_GIUTS004;

CREATE OR REPLACE FUNCTION CPI.CHK_BINDER_WITH_CLAIM_GIUTS004(
  p_line_cd       IN giis_line.line_cd%TYPE,
  p_fnl_binder_id IN giri_binder.fnl_binder_id%TYPE,
  p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
  p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
  p_dist_no       IN giri_distfrps.dist_no%TYPE)
RETURN VARCHAR2 IS
  v_with_claim VARCHAR2(5) := 'FALSE';
BEGIN
/* Created by  : Christian Santos
** Date created: 12/14/2012 
*/
  FOR binder IN (SELECT a.fnl_binder_id
                   FROM giri_binder a, giri_frps_ri b,
                        giri_distfrps c, giuw_pol_dist d, 
                        gipi_polbasic e, gicl_claims f
                  WHERE 1=1
                    AND a.fnl_binder_id  = b.fnl_binder_id
                    AND b.line_cd        = c.line_cd
                    AND b.frps_yy        = c.frps_yy
                    AND b.frps_seq_no    = c.frps_seq_no
                    AND d.dist_no        = d.dist_no
                    AND d.policy_id      = e.policy_id
                    AND e.line_cd        = f.line_cd
                    AND e.subline_cd     = f.subline_cd
                    AND e.iss_cd         = f.pol_iss_cd
                    AND e.issue_yy       = f.issue_yy
                    AND e.pol_seq_no     = f.pol_seq_no
                    AND e.renew_no       = f.renew_no
                    AND clm_stat_cd NOT IN ('CC','DN','WD') -- added by j.diago 09.17.2014
                    AND a.fnl_binder_id  = p_fnl_binder_id
                    AND f.line_cd        = p_line_cd
                    AND c.frps_yy        = p_frps_yy
                    AND c.frps_seq_no    = p_frps_seq_no
                    AND d.dist_no        = p_dist_no)
    LOOP
        v_with_claim := 'TRUE';
    END LOOP;
    
    RETURN v_with_claim;
END CHK_BINDER_WITH_CLAIM_GIUTS004;
/


