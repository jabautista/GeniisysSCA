BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WCOMINV_PK'
             AND table_name = 'GIPI_WCOMM_INVOICES') 
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INVOICES DROP CONSTRAINT WCOMINV_PK CASCADE';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WCOMINV_PK for table cpi.GIPI_WCOMM_INVOICES.');
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WCOMINV_PK'
             AND table_name = 'GIPI_WCOMM_INVOICES')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WCOMINV_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WCOMINV_PK for table cpi.GIPI_WCOMM_INVOICES.');     
   END LOOP;     
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INVOICES ADD (
                      CONSTRAINT WCOMINV_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,TAKEUP_SEQ_NO,INTRMDRY_INTM_NO)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WCOMINV_PK for table cpi.GIPI_WCOMM_INVOICES.');

   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INV_PERILS ADD (
                      CONSTRAINT WCOMMINV_WCOMMINVPERIL_FK 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO, INTRMDRY_INTM_NO) 
                      REFERENCES CPI.GIPI_WCOMM_INVOICES (PAR_ID,ITEM_GRP,TAKEUP_SEQ_NO,INTRMDRY_INTM_NO)
                      ENABLE NOVALIDATE)';
END;
/