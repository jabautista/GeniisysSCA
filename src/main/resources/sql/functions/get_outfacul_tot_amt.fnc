DROP FUNCTION CPI.GET_OUTFACUL_TOT_AMT;

CREATE OR REPLACE FUNCTION CPI.Get_Outfacul_Tot_Amt    (p_line_cd       IN giis_line.line_cd%TYPE,
                     p_ri_cd         IN giis_reinsurer.ri_cd%TYPE,
           p_fnl_binder_id IN giri_binder.fnl_binder_id%TYPE,
           p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
           p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE)
RETURN NUMBER AS
  p_amt giac_outfacul_prem_payts.disbursement_amt%TYPE := 0;
BEGIN
  /*Created by Iris Bordey
  **   date    11.19.2002
  ****Function initially created to handle sorting of records for nbt items.
  */
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
    p_amt := a.disbursement_amt;
  END LOOP;
  RETURN(p_amt);
  END;
/


