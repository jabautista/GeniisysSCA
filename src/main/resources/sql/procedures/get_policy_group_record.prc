DROP PROCEDURE CPI.GET_POLICY_GROUP_RECORD;

CREATE OR REPLACE PROCEDURE CPI.GET_POLICY_GROUP_RECORD(
    p_rg_name          IN  VARCHAR2,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_line_cd         OUT  gipi_polbasic.line_cd%TYPE,
    p_subline_cd      OUT  gipi_polbasic.subline_cd%TYPE,
    p_iss_cd          OUT  gipi_polbasic.iss_cd%TYPE,
    p_issue_yy        OUT  gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no      OUT  gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no        OUT  gipi_polbasic.renew_no%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
   v_sw            VARCHAR2(1) := 'N';
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-20-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : validates if there are records in the table for the pack_policy_id
  */
  IF p_rg_name = 'GROUP_PACK_POLICY' THEN
    FOR A IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                FROM gipi_pack_polbasic
               WHERE pack_policy_id = p_old_pol_id)
      LOOP
        p_line_cd       := a.line_cd;
        p_subline_cd    := a.subline_cd;
        p_iss_cd        := a.iss_cd;
        p_issue_yy      := a.issue_yy;
        p_pol_seq_no    := a.pol_seq_no;
        p_renew_no      := a.renew_no;
        v_sw            := 'Y';
        EXIT;
      END LOOP;
      
      IF v_sw = 'N' THEN
         p_msg := 'There is no record in gipi_pack_polbasic for pack_policy_id ' || 
                    to_char(p_old_pol_id);
      END IF;
     
  ELSIF p_rg_name = 'GROUP_POLICY' THEN
     FOR A IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                FROM gipi_polbasic
               WHERE policy_id = p_old_pol_id)
      LOOP
        p_line_cd       := a.line_cd;
        p_subline_cd    := a.subline_cd;
        p_iss_cd        := a.iss_cd;
        p_issue_yy      := a.issue_yy;
        p_pol_seq_no    := a.pol_seq_no;
        p_renew_no      := a.renew_no;
        v_sw            := 'Y';
        EXIT;
      END LOOP;
      
      IF v_sw = 'N' THEN
         p_msg := 'There is no record in gipi_polbasic for policy_id ' || 
                    to_char(p_old_pol_id);
      END IF;
     
  END IF;
END;
/


