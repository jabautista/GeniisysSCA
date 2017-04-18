BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WINVPERL_PK'
             AND table_name = 'GIPI_WINVPERL')
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINVPERL DROP CONSTRAINT WINVPERL_PK CASCADE';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WINVPERL_PK for table cpi.GIPI_WINVPERL.');
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WINVPERL_PK'
             AND table_name = 'GIPI_WINVPERL')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WINVPERL_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WINVPERL_PK for table cpi.GIPI_WINVPERL.');            
   END LOOP; 
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WINVPERL ADD (
                      CONSTRAINT WINVPERL_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,TAKEUP_SEQ_NO,PERIL_CD)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WINVPERL_PK for table cpi.GIPI_WINVPERL.');
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INV_PERILS ADD (
                      CONSTRAINT WINV_PERL_WCOMM_INV_PERILS 
                      FOREIGN KEY (PAR_ID, ITEM_GRP, TAKEUP_SEQ_NO, PERIL_CD) 
                      REFERENCES CPI.GIPI_WINVPERL (PAR_ID,ITEM_GRP, TAKEUP_SEQ_NO, PERIL_CD)
                      ENABLE VALIDATE)';
END;
/