BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WCOMM_INV_PERILS_PK'
             AND table_name = 'GIPI_WCOMM_INV_PERILS')
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INV_PERILS DROP CONSTRAINT WCOMM_INV_PERILS_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WCOMM_INV_PERILS_PK for table cpi.GIPI_WCOMM_INV_PERILS.');
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WCOMM_INV_PERILS_PK'
             AND table_name = 'GIPI_WCOMM_INV_PERILS')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WCOMM_INV_PERILS_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WCOMM_INV_PERILS_PK for table cpi.GIPI_WCOMM_INV_PERILS.');
   END LOOP;    
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INV_PERILS ADD (
                      CONSTRAINT WCOMM_INV_PERILS_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,TAKEUP_SEQ_NO,INTRMDRY_INTM_NO,PERIL_CD)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WCOMM_INV_PERILS_PK for table cpi.GIPI_WCOMM_INV_PERILS.');
END;
/