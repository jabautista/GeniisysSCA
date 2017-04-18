DECLARE
  CURSOR c1 (columname VARCHAR2)
  IS
     SELECT COUNT (column_name) ctr
       FROM all_tab_cols
      WHERE owner like 'CPI'
            and table_name = 'GIPI_VEHICLE' 
            AND column_name = columname;
BEGIN

  FOR x IN c1 ('REG_TYPE')
  LOOP
     IF x.ctr > 0
     THEN
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_VEHICLE DROP COLUMN REG_TYPE';
     END IF;
  END LOOP;
  
  FOR x IN c1 ('MV_TYPE')
  LOOP
     IF x.ctr > 0
     THEN
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_VEHICLE DROP COLUMN MV_TYPE';
     END IF;
  END LOOP;
  
  FOR x IN c1 ('MV_PREM_TYPE')
  LOOP
     IF x.ctr > 0
     THEN
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_VEHICLE DROP COLUMN MV_PREM_TYPE';
     END IF;
  END LOOP;
  
  FOR x IN c1 ('TAX_TYPE')
  LOOP
     IF x.ctr > 0
     THEN
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_VEHICLE DROP COLUMN TAX_TYPE';
     END IF;
  END LOOP;
  
END;