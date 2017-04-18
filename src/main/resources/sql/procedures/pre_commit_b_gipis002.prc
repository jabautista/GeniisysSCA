DROP PROCEDURE CPI.PRE_COMMIT_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Pre_Commit_B_Gipis002
   (v_line_cd IN VARCHAR2,
    v_op_subline_cd IN VARCHAR2,
    v_op_iss_cd IN VARCHAR2,
    v_op_issue_yy IN NUMBER,
    v_op_pol_seqno IN NUMBER,
    v_op_renew_no IN NUMBER,
    v_eff_date IN DATE,
    v_expiry_date OUT DATE,
    v_incept_date OUT DATE) IS    
BEGIN
  FOR z1 IN (SELECT endt_seq_no, expiry_date, incept_date
           FROM GIPI_POLBASIC b2501
          WHERE b2501.line_cd    = v_line_cd
           AND b2501.subline_cd = v_op_subline_cd
           AND b2501.iss_cd     = v_op_iss_cd
           AND b2501.issue_yy   = v_op_issue_yy
           AND b2501.pol_seq_no = v_op_pol_seqno
           AND b2501.renew_no   = v_op_renew_no
           AND b2501.pol_flag   IN ('1','2','3')
           AND NVL(b2501.back_stat,5) = 2
           AND b2501.pack_policy_id IS NULL
           AND (
             b2501.endt_seq_no = 0 OR
             (b2501.endt_seq_no > 0 AND
                                                    TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
                                                    )
                                        ORDER BY endt_seq_no DESC )
                LOOP
                    -- get the last endorsement sequence of the policy
                    FOR z1a IN (SELECT endt_seq_no, eff_date, expiry_date, incept_date
                                                FROM GIPI_POLBASIC b2501
                                             WHERE b2501.line_cd    = v_line_cd
                                                 AND b2501.subline_cd = v_op_subline_cd
                                                 AND b2501.iss_cd     = v_op_iss_cd
                                                 AND b2501.issue_yy   = v_op_issue_yy
                                                 AND b2501.pol_seq_no = v_op_pol_seqno
                                                 AND b2501.renew_no   = v_op_renew_no
                                                 AND b2501.pol_flag   IN ('1','2','3')
                                                 AND b2501.pack_policy_id IS NULL
                                                 AND (
                                                            b2501.endt_seq_no = 0 OR
                                                            (b2501.endt_seq_no > 0 AND
                                                            TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
                                                            )
                                                ORDER BY endt_seq_no DESC )
                    LOOP
                        IF z1.endt_seq_no = z1a.endt_seq_no THEN
                            v_expiry_date  := z1.expiry_date;
                            v_incept_date  := z1.incept_date;
                        ELSE
             IF z1a.eff_date > v_eff_date THEN
        v_expiry_date  := z1a.expiry_date;
        v_incept_date  := z1a.incept_date;
       ELSE
        v_expiry_date  := z1.expiry_date;
        v_incept_date  := z1.incept_date;
       END IF;
      END IF;      
      EXIT;
     END LOOP;
     EXIT;
    END LOOP;
END;
/


