CREATE OR REPLACE PACKAGE CPI.GIXX_MAIN_CO_INS_PKG 
AS
  --  created by Kris 03.12.2013 for GIPIS101
  TYPE main_co_ins_type IS RECORD(
        extract_id          gixx_main_co_ins.extract_id%TYPE,
        prem_amt            gixx_main_co_ins.prem_amt%TYPE,
        tsi_amt             gixx_main_co_ins.tsi_amt%TYPE,
        par_id              gixx_main_co_ins.par_id%TYPE,
        policy_id           gixx_main_co_ins.policy_id%TYPE       
  );
      
  TYPE main_co_ins_tab IS TABLE OF main_co_ins_type;
  
  FUNCTION get_main_co_ins_info(
        p_extract_id    gixx_main_co_ins.extract_id%TYPE
  ) RETURN main_co_ins_tab PIPELINED;
  -- end 03.12.2013: for GIPIS101

END GIXX_MAIN_CO_INS_PKG;
/


