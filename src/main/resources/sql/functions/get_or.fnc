DROP FUNCTION CPI.GET_OR;

CREATE OR REPLACE FUNCTION CPI.Get_Or    (p_iss_cd        IN giis_issource.iss_cd%TYPE,
                     p_prem_seq_no   IN GIIS_PREM_SEQ.prem_seq_no%TYPE,
           p_sw            IN VARCHAR2)
RETURN VARCHAR2 AS
  p_or_no          giac_order_of_payts.or_no%TYPE;
  p_or_date        giac_order_of_payts.or_date%TYPE;
  p_collection_amt giac_inwfacul_prem_collns.collection_amt%TYPE := 0;
BEGIN
  /*Created by Iris Bordey
  **   date    11.19.2002
  **Function returns either or_no or or_date or collection_amt(see giris013).
  **If p_sw = 'Y' then return or_no, if p_sw = 'N' or_date otherwise
  **return collection_amt
  */
  FOR a IN (SELECT c.or_no, c.or_date
              FROM giac_inwfacul_prem_collns a
                 , giac_acctrans b
                 , giac_order_of_payts c
             WHERE a.gacc_tran_id     = b.tran_id
               AND a.gacc_tran_id     = c.gacc_tran_id
               AND a.b140_iss_cd      = p_iss_cd
               AND a.b140_prem_seq_no = p_prem_seq_no)
  LOOP
    p_or_no   := a.or_no;
    p_or_date := a.or_date;
  END LOOP;
  --this is for collection_amt
  IF p_sw NOT IN ('Y', 'N') THEN
     FOR a IN (SELECT SUM(NVL(collection_amt,0)) collection_amt
                 FROM giac_inwfacul_prem_collns a
                      ,giac_acctrans b
                WHERE a.gacc_tran_id     = b.tran_id
                  AND a.b140_iss_cd      = p_iss_cd
                  AND a.b140_prem_seq_no = p_prem_seq_no
                GROUP BY b140_iss_cd, b140_prem_seq_no)
     LOOP
    p_collection_amt := a.collection_amt;
  END LOOP;
  END IF;
  --*--
  IF p_sw = 'Y' THEN
     RETURN(TO_CHAR(p_or_no));
  ELSIF p_sw = 'N' THEN
     RETURN(TO_CHAR(p_or_date));
  ELSE
     RETURN(TO_CHAR(p_collection_amt));
  END IF;
END;
/


