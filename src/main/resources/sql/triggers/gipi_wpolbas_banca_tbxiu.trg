DROP TRIGGER CPI.GIPI_WPOLBAS_BANCA_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_WPOLBAS_BANCA_TBXIU
   BEFORE INSERT OR UPDATE OF bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd
   ON CPI.GIPI_WPOLBAS    FOR EACH ROW
DECLARE
BEGIN      
  FOR A IN (
    SELECT bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd     
      FROM GIPI_PACK_WPOLBAS
     WHERE pack_par_id  =  :NEW.pack_par_id)
  LOOP
    :NEW.bancassurance_sw   := A.bancassurance_sw;
    :NEW.area_cd            := A.area_cd;
    :NEW.branch_cd          := A.branch_cd;
    :NEW.manager_cd         := A.manager_cd;
    :NEW.banc_type_cd       := A.banc_type_cd;
    EXIT;
  END LOOP;             
END;
/


