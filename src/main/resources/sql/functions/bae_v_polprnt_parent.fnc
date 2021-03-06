DROP FUNCTION CPI.BAE_V_POLPRNT_PARENT;

CREATE OR REPLACE FUNCTION CPI.bae_v_polprnt_parent
   (p_policy_id   gipi_polbasic.policy_id%TYPE,
    p_line_cd     gipi_polbasic.line_cd%TYPE,
 p_subline_cd  gipi_polbasic.subline_cd%TYPE,
 p_iss_cd      gipi_polbasic.iss_cd%TYPE,
 p_issue_yy    gipi_polbasic.issue_yy%TYPE,
 p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
 p_renew_no    gipi_polbasic.renew_no%TYPE) RETURN NUMBER AS
 v_parent_intm giis_intermediary.parent_intm_no%TYPE;
 v_exs         BOOLEAN := FALSE;
BEGIN
/*
  Created By: Michaell
  Created On: Nov. 18, 2002
  Remarks   : This function was created to handle the non-existence of tax endt records
              in gipi_comm_invoice and gipi_comm_inv_peril. It returns

  (Most recent modifications should precede the old modifications
  Modified By:
  Modified On:
  Remarks    :
*/
   FOR c IN (SELECT a.policy_id, a.iss_cd, a.parent_intm_no,
                    b.intm_type, c.acct_intm_cd
               FROM gipi_comm_invoice a,
                    giis_intermediary b,
                    giis_intm_type    c
              WHERE a.parent_intm_no = b.intm_no
                AND b.intm_type = c.intm_type
                AND a.policy_id = p_policy_id)
   LOOP
      v_parent_intm := c.parent_intm_no;
   v_exs         := TRUE;
   END LOOP;
   IF v_exs = FALSE THEN
      /*This is probably a tax endorsement, so get the parent intm from the orig policy*/
   FOR te IN (SELECT a.parent_intm_no
                FROM gipi_comm_invoice a, gipi_polbasic b
      WHERE 1=1
        AND a.policy_id = b.policy_id
     AND b.line_cd = p_line_cd
     AND b.subline_cd = p_subline_cd
     AND b.iss_cd = p_iss_cd
     AND b.issue_yy = p_issue_yy
     AND b.pol_seq_no = p_pol_seq_no
     AND b.renew_no = p_renew_no
     AND b.endt_seq_no = 0)
      LOOP
      v_parent_intm := te.parent_intm_no;
   EXIT;
   END LOOP;
   END IF;
   IF v_parent_intm IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'ERROR IN BAE_VIEW_PARENT FUNCTION, NO PARENT INTM FOUND');
   ELSE
      RETURN(v_parent_intm);
   END IF;
END;
/


