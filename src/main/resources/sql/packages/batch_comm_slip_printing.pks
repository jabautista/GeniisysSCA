CREATE OR REPLACE PACKAGE CPI.batch_comm_slip_printing
AS
  FUNCTION get_last_comm_slip_pref (p_branch_cd VARCHAR2,
                                   p_user_seq_type  VARCHAR2) RETURN VARCHAR2;
  PROCEDURE extract_batch_comm_slip (p_tran_ids VARCHAR2);
END;
/


