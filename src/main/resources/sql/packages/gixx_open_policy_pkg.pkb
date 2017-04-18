CREATE OR REPLACE PACKAGE BODY CPI.GIXX_OPEN_POLICY_PKG AS

  FUNCTION get_open_policy_no(p_extract_id    GIXX_OPEN_POLICY.extract_id%TYPE)
    RETURN VARCHAR2 IS
	v_pol  VARCHAR2(50);
  BEGIN
    FOR i IN (SELECT op.line_cd || '-' || op.op_subline_cd || '-' || op.op_iss_cd || '-' ||
           			 LTRIM(TO_CHAR(op.op_issue_yy,'09')) || '-' ||  
                     LTRIM(TO_CHAR(op.op_pol_seqno,'0999999'))||DECODE(gp.ref_pol_no,NULL,'',' / '||gp.ref_pol_no) policy_no
                FROM gixx_open_policy op , gipi_polbasic gp
               WHERE op.line_cd         = gp.line_cd
	             AND op.op_subline_cd   = gp.subline_cd
	             AND op.op_iss_cd       = gp.iss_cd
	             AND op.op_issue_yy     = gp.issue_yy
	             AND op.op_pol_seqno    = gp.pol_seq_no
				 AND op.extract_id 		= p_extract_id)
	LOOP
	  v_pol 	 := i.policy_no;
	END LOOP;
	RETURN (v_pol);
  END get_open_policy_no;
  
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 11, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves open policy no and other info
  */
  FUNCTION get_open_policy(
    p_extract_id    gixx_open_policy.extract_id%TYPE
  ) RETURN open_policy_tab PIPELINED
  IS
    v_open_policy   open_policy_type;
  BEGIN
    FOR rec IN (SELECT extract_id, line_cd,
                       op_subline_cd, op_iss_cd,
                       op_issue_yy, op_pol_seqno, op_renew_no,
                       decltn_no, eff_date, policy_id
                  FROM gixx_open_policy
                 WHERE extract_id = p_extract_id)
    LOOP
        v_open_policy.extract_id := rec.extract_id;
        v_open_policy.line_cd := rec.line_cd;
        v_open_policy.op_subline_cd := rec.op_subline_cd;
        v_open_policy.op_iss_cd := rec.op_iss_cd;
        v_open_policy.op_issue_yy := rec.op_issue_yy;
        v_open_policy.op_pol_seqno := rec.op_pol_seqno;
        v_open_policy.decltn_no := rec.decltn_no;
        v_open_policy.eff_date := rec.eff_date;
        v_open_policy.policy_id := rec.policy_id;
        
        BEGIN
            SELECT ref_open_pol_no 
              INTO v_open_policy.ref_open_pol_no
              FROM gipi_polbasic
             WHERE line_cd = rec.line_cd
               AND subline_cd = rec.op_subline_cd
               AND iss_cd = rec.op_iss_cd
               AND issue_yy = rec.op_issue_yy
               AND pol_seq_no = rec.op_pol_seqno
               AND renew_no = rec.op_renew_no;
        EXCEPTION
            WHEN no_data_found THEN
                v_open_policy.ref_open_pol_no := '';
        END;
        
        PIPE ROW(v_open_policy);
        
    END LOOP;
    
  END get_open_policy;

END GIXX_OPEN_POLICY_PKG;
/


