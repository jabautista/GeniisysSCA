DROP TRIGGER CPI.TRG1_GIPPD;

CREATE OR REPLACE TRIGGER CPI.TRG1_GIPPD
BEFORE INSERT
ON CPI.GIIN_INTM_PROD_POL_DTL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
   p_rec    NUMBER(9);
  BEGIN
   SELECT   intm_prod_pol_dtl_s.NEXTVAL
     INTO   p_rec
     FROM   dual;
   :NEW.record_id  :=  NVL(p_rec,1);
  END;
END;
/


