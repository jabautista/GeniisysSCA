DROP SEQUENCE CPI.GISM_ERROR_MESSAGE_TRAN_ID_S;

CREATE SEQUENCE CPI.GISM_ERROR_MESSAGE_TRAN_ID_S
  START WITH 1
  MAXVALUE 10000000000000000
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

