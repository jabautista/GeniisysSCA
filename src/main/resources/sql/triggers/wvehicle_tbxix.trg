DROP TRIGGER CPI.WVEHICLE_TBXIX;

CREATE OR REPLACE TRIGGER CPI.WVEHICLE_TBXIX
BEFORE INSERT OR UPDATE -- comment out by ging071307
ON CPI.GIPI_WVEHICLE FOR EACH ROW
DECLARE
  v_exist   BOOLEAN := FALSE;
  v_serial_no   GIPI_WVEHICLE.coc_serial_no%TYPE;
BEGIN
  IF NVL(:NEW.coc_serial_sw,'N') = 'Y' AND :NEW.coc_serial_no IS NULL THEN
     FOR A IN (SELECT y.line_cd, x.pack_line_cd
              FROM GIPI_WITEM x, GIPI_WPOLBAS y
    WHERE x.par_id = y.par_id
      AND x.par_id = :NEW.par_id
      AND item_no = :NEW.item_no)
     LOOP
        FOR b IN ( SELECT serial_no
                  FROM GIIS_COC_SERIAL_NO
                  WHERE line_cd = NVL(A.pack_line_cd, A.line_cd)
                   AND coc_type = NVL(:OLD.coc_type,nvl(:new.coc_type,'NLTO')))
        LOOP
            v_exist     := TRUE;
            v_serial_no := b.serial_no + 1;
            :NEW.coc_serial_no := v_serial_no;
        END LOOP;
       IF v_exist = TRUE THEN
            UPDATE GIIS_COC_SERIAL_NO
               SET serial_no = v_serial_no
             WHERE line_cd = NVL(A.pack_line_cd, A.line_cd)
               AND coc_type = NVL(:OLD.coc_type,nvl(:new.coc_type,'NLTO'));
          --If no record exist for the given line_cd, insert a new record with
          --the value of the COC_SERIAL_NO saved in the serial_no column.
       ELSE
            v_serial_no := 1;
            :NEW.coc_serial_no := v_serial_no;
            INSERT INTO GIIS_COC_SERIAL_NO(line_cd, serial_no, coc_type)
                               VALUES (NVL(A.pack_line_cd, A.line_cd), v_serial_no,
                                       NVL(:OLD.coc_type,nvl(:new.coc_type,'NLTO')));

       END IF;
    END LOOP;
  END IF;
END;
/


