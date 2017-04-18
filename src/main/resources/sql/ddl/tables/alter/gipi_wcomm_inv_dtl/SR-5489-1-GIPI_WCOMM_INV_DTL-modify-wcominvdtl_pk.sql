BEGIN
   FOR cur
      IN (SELECT constraint_name
            FROM all_constraints
           WHERE owner = 'CPI'
             AND constraint_name = 'WCOMINVDTL_PK'
             AND table_name = 'GIPI_WCOMM_INV_DTL')
   LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INV_DTL DROP CONSTRAINT WCOMINVDTL_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped constraint WCOMINVDTL_PK for table cpi.GIPI_WCOMM_INV_DTL.');      
   END LOOP;
   
   FOR cur
      IN (SELECT index_name
            FROM all_indexes
           WHERE owner = 'CPI'
             AND index_name = 'WCOMINVDTL_PK'
             AND table_name = 'GIPI_WCOMM_INV_DTL')
   LOOP
      EXECUTE IMMEDIATE 'DROP INDEX CPI.WCOMINVDTL_PK';
      DBMS_OUTPUT.put_line ('Successfully droppped index WCOMINVDTL_PK for table cpi.GIPI_WCOMM_INV_DTL.');   
   END LOOP;   
   
   EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_WCOMM_INV_DTL ADD (
                      CONSTRAINT WCOMINVDTL_PK
                      PRIMARY KEY
                      (PAR_ID, ITEM_GRP,INTRMDRY_INTM_NO,TAKEUP_SEQ_NO)
                      ENABLE VALIDATE)';
   DBMS_OUTPUT.put_line ('Successfully added constraint WCOMINVDTL_PK for table cpi.GIPI_WCOMM_INV_DTL.');
END;
/