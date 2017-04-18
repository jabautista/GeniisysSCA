BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WINV_TAX_PK'
             AND table_name = 'GIPI_WINV_TAX')
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINV_TAX DROP CONSTRAINT WINV_TAX_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WINV_TAX_PK for table cpi.GIPI_WINV_TAX.');
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WINV_TAX_PK'
             AND table_name = 'GIPI_WINV_TAX')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WINV_TAX_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WINV_TAX_PK for table cpi.GIPI_WINV_TAX.');          
   END LOOP; 
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINV_TAX ADD (
                      CONSTRAINT WINV_TAX_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,TAKEUP_SEQ_NO,TAX_CD)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WINV_TAX_PK for table cpi.GIPI_WINV_TAX.');
END;
/