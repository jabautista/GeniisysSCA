DROP PROCEDURE CPI.CO_INSURANCE_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.co_insurance_gipis002(
    p_par_id         IN gipi_parlist.par_id%TYPE,
    p_stat          OUT gipi_parlist.par_status%TYPE,
    p_cnt           OUT NUMBER,
    p_cnt1          OUT NUMBER,
    p_cnt2          OUT NUMBER
    ) IS 
BEGIN
  FOR STAT IN(SELECT par_status
                FROM gipi_parlist
               WHERE par_id = p_par_id )
  LOOP
    p_stat    := stat.par_status;
    EXIT;
  END LOOP;  
                       
  FOR exist IN (SELECT count (*) cnt
                  FROM gipi_main_co_ins
                 WHERE par_id = p_par_id)
  LOOP
    p_cnt := exist.cnt;
  END LOOP;

  FOR exist IN (SELECT count(*) cnt
                  FROM gipi_orig_comm_invoice
                 WHERE par_id = p_par_id)
  LOOP
    p_cnt1 := exist.cnt;
  END LOOP;

  FOR exist IN (SELECT count(*) cnt
                  FROM gipi_wcomm_invoices
                 WHERE par_id = p_par_id )
  LOOP
    p_cnt2 := exist.cnt;
  END LOOP;
  
END;
/


