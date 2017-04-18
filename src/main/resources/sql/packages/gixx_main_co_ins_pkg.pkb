CREATE OR REPLACE PACKAGE BODY CPI.GIXX_MAIN_CO_INS_PKG 
AS
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 12, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves main co-ins information
  */
  FUNCTION get_main_co_ins_info(
        p_extract_id    gixx_main_co_ins.extract_id%TYPE
  ) RETURN main_co_ins_tab PIPELINED
  IS
    v_main_co_ins    main_co_ins_type;
  BEGIN
    FOR rec IN (SELECT extract_id, prem_amt, tsi_amt
                  FROM gixx_main_co_ins
                 WHERE extract_id = p_extract_id)
    LOOP
        v_main_co_ins.extract_id := rec.extract_id;
        v_main_co_ins.prem_amt := rec.prem_amt;
        v_main_co_ins.tsi_amt := rec.tsi_amt;
        
        PIPE ROW(v_main_co_ins);
    END LOOP;
    
  END get_main_co_ins_info;

END GIXX_MAIN_CO_INS_PKG;
/


