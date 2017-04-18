DROP FUNCTION CPI.GET_INWFACUL_TOT_AMT;

CREATE OR REPLACE FUNCTION CPI.Get_Inwfacul_Tot_Amt    (p_iss_cd        IN giis_issource.iss_cd%TYPE,
                           p_prem_seq_no   IN giis_prem_seq.prem_seq_no%TYPE)
RETURN NUMBER AS
  p_collection_amt giac_inwfacul_prem_collns.collection_amt%TYPE := 0;
BEGIN
  /*Created by Iris Bordey
  **   date    11.19.2002
  **Function returns collection_amt(see giris013).
  */
     FOR a IN (SELECT SUM(NVL(collection_amt,0)) collection_amt
                 FROM giac_inwfacul_prem_collns a
                      ,giac_acctrans b
                WHERE a.gacc_tran_id     = b.tran_id
                  AND a.b140_iss_cd      = p_iss_cd
                  AND a.b140_prem_seq_no = p_prem_seq_no
      AND b.tran_flag       != 'D'
      AND NOT EXISTS (SELECT c.gacc_tran_id
                                    FROM giac_reversals c,
                                         giac_acctrans d
                                   WHERE c.reversing_tran_id = d.tran_id
                                     AND d.tran_flag <> 'D'
                                     AND c.gacc_tran_id = a.gacc_tran_id)
                GROUP BY b140_iss_cd, b140_prem_seq_no)
     LOOP
    p_collection_amt := a.collection_amt;
  END LOOP;
     RETURN(p_collection_amt);
END;
/


