DROP PROCEDURE CPI.CHECK_COMM_PAYTS;

CREATE OR REPLACE PROCEDURE CPI.check_comm_payts (p_gacc_tran_id IN     NUMBER,
                                                  p_iss_cd       IN     VARCHAR2,
                                                  p_prem_seq_no  IN     NUMBER,
                                                  p_bill_nos     IN OUT VARCHAR2,
                                                  p_ref_nos      IN OUT VARCHAR2) IS
-- Procedure created by Jayson 11.16.2011 --
  v_total_comm  NUMBER  := 0;
  
BEGIN
--Modified by RCD used to sum only those not cancelled transactions.
  SELECT NVL (SUM (comm_amt), 0) total_comm
     INTO v_total_comm
     FROM giac_acctrans gac, giac_comm_payts gcp
    WHERE tran_flag != 'D'
      AND gcp.iss_cd = p_iss_cd
      AND gcp.prem_seq_no = p_prem_seq_no
      AND gac.tran_id = gcp.gacc_tran_id
      --AND gac.tran_id != p_gacc_tran_id             -- comment out to include current JV 
      AND NOT EXISTS (
             SELECT 'X'
               FROM giac_reversals c, giac_acctrans d
              WHERE c.reversing_tran_id = d.tran_id
                AND d.tran_flag != 'D'
                AND c.gacc_tran_id = gac.tran_id);
            
  IF v_total_comm <> 0 THEN
    FOR rec1 IN (SELECT gacc_tran_id
                   FROM giac_acctrans gac, giac_comm_payts gcp
                  WHERE tran_flag      != 'D'
                    AND gcp.iss_cd      = p_iss_cd
                    AND gcp.prem_seq_no = p_prem_seq_no
                    AND gac.tran_id     = gcp.gacc_tran_id
                    AND GAC.TRAN_ID    != p_gacc_tran_id
                    AND NOT EXISTS (SELECT 'X'
                                      FROM giac_reversals c, giac_acctrans d
                                     WHERE c.reversing_tran_id = d.tran_id
                                       AND d.tran_flag        != 'D'
                                       AND c.gacc_tran_id      = gac.tran_id))
    LOOP          
      p_bill_nos := p_iss_cd||' - '||LPAD(p_prem_seq_no,12,0);
      p_ref_nos := p_ref_nos||Get_Ref_No(rec1.GACC_TRAN_ID)||CHR(13);
    END LOOP;
  END IF;
END;
/


