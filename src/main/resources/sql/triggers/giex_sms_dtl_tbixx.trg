DROP TRIGGER CPI.GIEX_SMS_DTL_TBIXX;

CREATE OR REPLACE TRIGGER CPI.GIEX_SMS_DTL_TBIXX
BEFORE INSERT
ON CPI.GIEX_SMS_DTL REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  v_cp     GIEX_SMS_DTL.cellphone_no%TYPE := :NEW.cellphone_no;
  
BEGIN
  :NEW.user_id := USER;
  :NEW.last_update := SYSDATE;
   
  FOR rec IN (SELECT assd_name
              FROM giis_assured
              WHERE '+639' || SUBSTR(cp_no,LENGTH(cp_no)-8,LENGTH(cp_no)) = v_cp OR
                    '+639' || SUBSTR(smart_no,LENGTH(smart_no)-8,LENGTH(smart_no)) = v_cp OR
                    '+639' || SUBSTR(globe_no,LENGTH(globe_no)-8,LENGTH(globe_no)) = v_cp OR
                    '+639' || SUBSTR(sun_no,LENGTH(sun_no)-8,LENGTH(sun_no)) = v_cp)
  LOOP
    :NEW.recipient_sender := rec.assd_name;
  END LOOP;
  
  IF :NEW.recipient_sender IS NULL THEN
   FOR rec2 IN (SELECT intm_name
                FROM giis_intermediary
                WHERE '+639' || SUBSTR(cp_no,LENGTH(cp_no)-8,LENGTH(cp_no)) = v_cp OR
                      '+639' || SUBSTR(smart_no,LENGTH(smart_no)-8,LENGTH(smart_no)) = v_cp OR
                      '+639' || SUBSTR(globe_no,LENGTH(globe_no)-8,LENGTH(globe_no)) = v_cp OR
                      '+639' || SUBSTR(sun_no,LENGTH(sun_no)-8,LENGTH(sun_no)
) = v_cp)
   LOOP
    :NEW.recipient_sender := rec2.intm_name;
   END LOOP;
  END IF;
  
  IF :NEW.recipient_sender IS NULL THEN
   FOR rec3 IN (SELECT payee_last_name
                FROM giis_payees
                WHERE '+639' || SUBSTR(cp_no,LENGTH(cp_no)-8,LENGTH(cp_no)) = v_cp OR
                      '+639' || SUBSTR(smart_no,LENGTH(smart_no)-8,LENGTH(smart_no)) = v_cp OR
                      '+639' || SUBSTR(globe_no,LENGTH(globe_no)-8,LENGTH(globe_no)) = v_cp OR
                      '+639' || SUBSTR(sun_no,LENGTH(sun_no)-8,LENGTH(sun_no)) = v_cp)
   LOOP
    :NEW.recipient_sender := rec3.payee_last_name;
   END LOOP;
  END IF;
  
  IF :NEW.recipient_sender IS NULL THEN
   FOR rec4 IN (SELECT ri_name
                FROM giis_reinsurer
                WHERE '+639' || SUBSTR(cp_no,LENGTH(cp_no)-8,LENGTH(cp_no)) = v_cp OR
                      '+639' || SUBSTR(smart_no,LENGTH(smart_no)-8,LENGTH(smart_no)) = v_cp OR
                      '+639' || SUBSTR(globe_no,LENGTH(globe_no)-8,LENGTH(globe_no)) = v_cp OR
                      '+639' || SUBSTR(sun_no,LENGTH(sun_no)-8,LENGTH(sun_no)) = v_cp)
   LOOP
    :NEW.recipient_sender := rec4.ri_name;
   END LOOP;
  END IF;
END;
/


