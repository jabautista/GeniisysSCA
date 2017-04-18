BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WINVOICE_PK'
             AND table_name = 'GIPI_WINVOICE')
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINVOICE DROP CONSTRAINT WINVOICE_PK CASCADE';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WINVOICE_PK for table cpi.GIPI_WINVOICE.');               
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WINVOICE_PK'
             AND table_name = 'GIPI_WINVOICE')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WINVOICE_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WINVOICE_PK for table cpi.GIPI_WINVOICE.');         
   END LOOP;   
   
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINVOICE ADD (
                      CONSTRAINT WINVOICE_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,TAKEUP_SEQ_NO)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WINVOICE_PK for table cpi.GIPI_WINVOICE.');

   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINSTALLMENT ADD (
                      CONSTRAINT WINVOICE_WINSTALLMENT_FK 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO) 
                      REFERENCES CPI.GIPI_WINVOICE (PAR_ID,ITEM_GRP, TAKEUP_SEQ_NO)
                      ON DELETE CASCADE
                      ENABLE VALIDATE)';

   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINVPERL ADD (
                      CONSTRAINT WINVOICE_WINVPERL_FK 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO) 
                      REFERENCES CPI.GIPI_WINVOICE (PAR_ID,ITEM_GRP, TAKEUP_SEQ_NO)
                      ON DELETE CASCADE
                      ENABLE VALIDATE)';

   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINV_TAX ADD (
                      CONSTRAINT WINVOICE_WINV_TAX_FK 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO) 
                      REFERENCES CPI.GIPI_WINVOICE (PAR_ID,ITEM_GRP,TAKEUP_SEQ_NO)
                      ON DELETE CASCADE
                      ENABLE VALIDATE)';

   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WPACKAGE_INV_TAX ADD (
                      CONSTRAINT WINVOICE_WPACK_INV_TAX_FK 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO) 
                      REFERENCES CPI.GIPI_WINVOICE (PAR_ID,ITEM_GRP,TAKEUP_SEQ_NO)
                      ENABLE VALIDATE)';

   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INVOICES ADD (
                      CONSTRAINT WCOMINV_B450_FK 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO) 
                      REFERENCES CPI.GIPI_WINVOICE (PAR_ID,ITEM_GRP,TAKEUP_SEQ_NO)
                      ENABLE VALIDATE)';
END;
/