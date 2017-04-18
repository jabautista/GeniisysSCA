CREATE OR REPLACE PACKAGE BODY CPI.GIXX_CO_INSURER_PKG AS

   FUNCTION get_pol_doc_co_insurance 
     RETURN pol_doc_co_insurance_tab PIPELINED IS
     
     v_co_insurance pol_doc_co_insurance_type;
     
   BEGIN
     FOR i IN (
        SELECT co.extract_id extract_id15,
               TO_CHAR(co.co_ri_tsi_amt,'999,999,990.00') coinsurer_ri_tsi_amt,
               re.ri_name   reinsurer_ri_name
          FROM GIXX_CO_INSURER CO, 
               GIIS_REINSURER RE
         WHERE co.co_ri_cd = re.ri_cd)
     LOOP
        v_co_insurance.extract_id15          := i.extract_id15;
        v_co_insurance.coinsurer_ri_tsi_amt  := i.coinsurer_ri_tsi_amt;
        v_co_insurance.reinsurer_ri_name     := i.reinsurer_ri_name;
       PIPE ROW(v_co_insurance);
     END LOOP;
     RETURN;
   END get_pol_doc_co_insurance;
   
   
   
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 12, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves co-ins list
  */
  FUNCTION get_co_ins_list(
        p_extract_id    gixx_co_insurer.extract_id%TYPE
   ) RETURN co_ins_tab PIPELINED
   IS
    v_co_ins        co_ins_type;
   BEGIN
        FOR rec IN (SELECT extract_id, co_ri_cd,
                           co_ri_shr_pct, co_ri_prem_amt, co_ri_tsi_amt
                      FROM gixx_co_insurer
                     WHERE extract_id = p_extract_id)
        LOOP
            v_co_ins.extract_id     := rec.extract_id;
            v_co_ins.co_ri_cd       := rec.co_ri_cd;
            v_co_ins.co_ri_shr_pct  := rec.co_ri_shr_pct;
            v_co_ins.co_ri_prem_amt := rec.co_ri_prem_amt;
            v_co_ins.co_ri_tsi_amt  := rec.co_ri_tsi_amt;
            
            FOR a IN (SELECT ri_sname
                        FROM giis_reinsurer
                       WHERE ri_cd = rec.co_ri_cd)
            LOOP
                v_co_ins.ri_sname := a.ri_sname;
            END LOOP;
            
            PIPE ROW(v_co_ins);
        END LOOP;
   END get_co_ins_list;

END GIXX_CO_INSURER_PKG;
/


