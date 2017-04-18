DROP FUNCTION CPI.GET_DV;

CREATE OR REPLACE FUNCTION CPI.Get_Dv    (p_line_cd       IN giis_line.line_cd%TYPE,
                     p_ri_cd         IN giis_reinsurer.ri_cd%TYPE,
           p_fnl_binder_id IN giri_binder.fnl_binder_id%TYPE,
           p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
           p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
           p_sw            IN VARCHAR2)
RETURN VARCHAR2 AS
  p_dv_no            giac_disb_vouchers.dv_no%TYPE;
  p_dv_create_date   giac_disb_vouchers.dv_create_date%TYPE;
  p_disbursement_amt giac_outfacul_prem_payts.disbursement_amt%TYPE := 0;
BEGIN
  /*Created by Iris Bordey
  **   date    11.19.2002
  ****Function initially created to handle sorting of records for nbt items.
  **Function returns either dv_no or dv_create_date or disbursement_amt(see giris012).
  **If p_sw = 'Y' then return dv_no, if p_sw = 'N' then return dv_create_date
  **otherwise return disbursement_amt
  */
  FOR a IN (
      SELECT t4.dv_no, t4.dv_create_date
        FROM giac_outfacul_prem_payts t1
       ,giri_frps_ri t2
             ,giac_acctrans t3
    ,giac_disb_vouchers t4
       WHERE t1.d010_fnl_binder_id = t2.fnl_binder_id
         AND t1.gacc_tran_id       = t3.tran_id
         AND t1.gacc_tran_id       = t4.gacc_tran_id
         AND t3.tran_flag         != 'D'
         AND t2.line_cd            = p_line_cd
         AND t2.frps_yy            = p_frps_yy
         AND t2.frps_seq_no        = p_frps_seq_no
         AND t2.ri_cd              = p_ri_cd
         AND t2.fnl_binder_id      = p_fnl_binder_id
         AND NOT EXISTS (SELECT c.gacc_tran_id
                           FROM giac_reversals c,
                                giac_acctrans d
                          WHERE c.reversing_tran_id = d.tran_id
                            AND d.tran_flag <> 'D'
                            AND c.gacc_tran_id = t1.gacc_tran_id))
  LOOP
    p_dv_no          := a.dv_no;
 p_dv_create_date := a.dv_create_date;
  END LOOP;
  --*--
  --for computation of disbursement_amt
  IF p_sw NOT IN ('Y', 'N') THEN
     FOR a IN (SELECT SUM(NVL(disbursement_amt,0)) disbursement_amt
                 FROM giac_outfacul_prem_payts t1, giri_frps_ri t2,
                      giac_acctrans t3
                WHERE t1.d010_fnl_binder_id = t2.fnl_binder_id
                  AND t1.gacc_tran_id       = t3.tran_id
                  AND t3.tran_flag         != 'D'
                  AND t2.line_cd            = p_line_cd
                  AND t2.frps_yy            = p_frps_yy
                  AND t2.frps_seq_no        = p_frps_seq_no
                  AND t2.ri_cd              = p_ri_cd
                  AND t2.fnl_binder_id      = p_fnl_binder_id
                  AND NOT EXISTS (SELECT c.gacc_tran_id
                                    FROM giac_reversals c,
                                         giac_acctrans d
                                   WHERE c.reversing_tran_id = d.tran_id
                                     AND d.tran_flag <> 'D'
                                     AND c.gacc_tran_id = t1.gacc_tran_id)
               GROUP BY t1.d010_fnl_binder_id)
     LOOP
    p_disbursement_amt := a.disbursement_amt;
  END LOOP;
  END IF;
  --*--
  IF p_sw = 'Y' THEN
     RETURN(TO_CHAR(p_dv_no));
  ELSIF p_sw = 'N' THEN
     RETURN(TO_CHAR(p_dv_create_date));
  ELSE
     RETURN(TO_CHAR(p_disbursement_amt));
  END IF;
END;
/


