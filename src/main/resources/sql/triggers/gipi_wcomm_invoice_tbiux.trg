CREATE OR REPLACE TRIGGER CPI.gipi_wcomm_invoice_tbiux
   BEFORE INSERT OR UPDATE
   ON CPI.GIPI_WCOMM_INVOICES    FOR EACH ROW
DECLARE
BEGIN
   DECLARE
      v_whtax_id   giis_intermediary.whtax_id%TYPE;
   BEGIN
     FOR A IN (SELECT whtax_id
                 FROM giis_intermediary
                WHERE intm_no IN (SELECT DECODE (lic_tag, 'Y', intm_no, parent_intm_no)
                                    FROM giis_intermediary
                                   WHERE intm_no = :NEW.intrmdry_intm_no)) LOOP
       v_whtax_id := a.whtax_id;
     END LOOP;                                       
     :NEW.whtax_id := v_whtax_id;
   END;
END;
/