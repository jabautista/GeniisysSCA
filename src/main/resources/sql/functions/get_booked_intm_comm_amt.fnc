DROP FUNCTION CPI.GET_BOOKED_INTM_COMM_AMT;

CREATE OR REPLACE FUNCTION CPI.Get_Booked_Intm_Comm_Amt
/* judyann 10132009; to get the intermediary commission booked at month-end */
  (p_iss_cd      VARCHAR2,
   p_prem_seq_no NUMBER,
   p_intm_no     NUMBER,
   p_from_date   DATE,
   p_to_date     DATE)
  RETURN NUMBER IS
    v_commission_amt NUMBER(12,2);
    v_comm_amt       NUMBER(12,2);
    v_total_comm     NUMBER(16,2) := 0;
  BEGIN
    FOR c IN (SELECT  b.iss_cd, b.prem_seq_no, b.intrmdry_intm_no,
	                  b.commission_amt, c.currency_rt
                FROM GIPI_COMM_INVOICE  b,
                     GIPI_INVOICE c,
                     GIPI_POLBASIC a
               WHERE b.iss_cd = c.iss_cd
                 AND b.prem_seq_no = c.prem_seq_no
                 AND a.policy_id = c.policy_id
                 AND b.iss_cd = NVL(p_iss_cd, b.iss_cd)
                 AND b.prem_seq_no = NVL(p_prem_seq_no, b.prem_seq_no)
                 AND b.intrmdry_intm_no = NVL(p_intm_no, b.intrmdry_intm_no)
                 AND (TRUNC(c.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR TRUNC(c.spoiled_acct_ent_date) BETWEEN p_from_date AND p_to_date)
               )
  LOOP
    v_commission_amt := c.commission_amt;
    FOR c1 IN (SELECT commission_amt
                 FROM GIAC_PREV_COMM_INV
                WHERE comm_rec_id = (SELECT MIN(COMM_REC_ID)
                                       FROM GIAC_NEW_COMM_INV n, GIPI_INVOICE i
                                      WHERE n.iss_cd = i.iss_cd
                                        AND n.prem_seq_no = i.prem_seq_no
                                        AND n.tran_flag          = 'P'
                                        AND NVL(n.delete_sw,'N') = 'N'
                                        AND n.acct_ent_date > i.acct_ent_date
                                        AND n.iss_cd = c.iss_cd
                                        AND n.prem_seq_no = c.prem_seq_no
                                        AND n.intm_no = c.intrmdry_intm_no)
                  AND intm_no = c.intrmdry_intm_no
                  AND acct_ent_date BETWEEN p_from_date AND p_to_date)
    LOOP
      v_commission_amt := c1.commission_amt;
    END LOOP;
    v_comm_amt := NVL(v_commission_amt * c.currency_rt,0);
    v_total_comm := v_total_comm + v_comm_amt;
  END LOOP;
  RETURN(v_total_comm);
END Get_Booked_Intm_Comm_Amt;
/


