DROP SEQUENCE CPI.COMM_TRAN_ID_SEQ;

CREATE SEQUENCE CPI.COMM_TRAN_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

