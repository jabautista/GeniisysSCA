DROP PROCEDURE CPI.GET_FIRE_TARF_RATE;

CREATE OR REPLACE PROCEDURE CPI.GET_FIRE_TARF_RATE (p_par_id      IN GIPI_WFIREITM.par_id%TYPE,
                                                    p_item_no     IN GIPI_WFIREITM.item_no%TYPE,
                                                    p_tariff_rate IN OUT GIIS_TARIFF.tarf_rate%TYPE) 
IS
  /*
  **  Created by    : Menandro G.C. Robes
  **  Date Created 	: June 21, 2010
  **  Reference By 	: (GIPIS097 - Endorsement Item Peril)
  **  Description 	: Function that returns the tariff_rate. 
  */ 
BEGIN
  FOR c1 IN (
    SELECT a.tarf_rate
      FROM gipi_wfireitm b
          ,giis_tariff a
     WHERE a.tarf_cd = b.tarf_cd
       AND b.item_no = p_item_no
       AND b.par_id  = p_par_id)
  LOOP         
    p_tariff_rate := NVL(c1.tarf_rate, 0);
    EXIT;
  END LOOP;
END GET_FIRE_TARF_RATE;
/


