DROP PROCEDURE CPI.LINA;

CREATE OR REPLACE PROCEDURE CPI.lina
is
  v_comm_vat     gipi_invoice.ri_comm_vat%TYPE;
  v_comm_vat1    gipi_invoice.ri_comm_vat%TYPE;  
  v_comm_vat2    gipi_invoice.ri_comm_vat%TYPE;
BEGIN
  FOR a IN (SELECT iss_cd, prem_seq_no
              FROM gipi_invoice
             WHERE ri_comm_vat IS NULL
			 AND iss_cd = 'RI')
  LOOP
    FOR b IN (SELECT sum(comm_vat) comm_vat
                FROM giac_aging_ri_soa_details
               WHERE prem_seq_no = a.prem_seq_no)               
    LOOP
	  v_comm_vat1 := b.comm_vat;
      FOR c IN (SELECT sum(comm_vat) comm_vat
                  FROM giac_inwfacul_prem_collns gipc , giac_acctrans gacc
                 WHERE gipc.gacc_tran_id = gacc.tran_id
		           AND b140_iss_cd = a.iss_cd
				   AND b140_prem_seq_no = a.prem_seq_no 
                   AND gacc.tran_flag <> 'D'
                   AND NOT EXISTS (SELECT '1'
                                     FROM giac_acctrans x, giac_reversals y
                                    WHERE x.tran_id = y.reversing_tran_id
                                      AND y.gacc_tran_id = gipc.gacc_tran_id
                                      AND x.tran_flag <> 'D'))    
	  LOOP
		v_comm_vat2 := c.comm_vat;
	  END LOOP;      
	  v_comm_vat := NVL(v_comm_vat1,0) + NVL(v_comm_vat2,0);
      UPDATE gipi_invoice
         SET ri_comm_vat = v_comm_vat
       WHERE iss_cd = a.iss_cd
         AND prem_seq_no = a.prem_seq_no;     
    END LOOP;
  END LOOP;    
END;
/


