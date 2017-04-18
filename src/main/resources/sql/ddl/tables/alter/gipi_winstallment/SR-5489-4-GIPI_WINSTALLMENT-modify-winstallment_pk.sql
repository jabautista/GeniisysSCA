BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WINSTALLMENT_PK'
             AND table_name = 'GIPI_WINSTALLMENT')
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINSTALLMENT DROP CONSTRAINT WINSTALLMENT_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WINSTALLMENT_PK for table cpi.GIPI_WINSTALLMENT.');
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WINSTALLMENT_PK'
             AND table_name = 'GIPI_WINSTALLMENT')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WINSTALLMENT_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WINSTALLMENT_PK for table cpi.GIPI_WINSTALLMENT.');        
   END LOOP;      
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINSTALLMENT ADD (
                      CONSTRAINT WINSTALLMENT_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,TAKEUP_SEQ_NO,INST_NO)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WINSTALLMENT_PK for table cpi.GIPI_WINSTALLMENT.');
END;
/