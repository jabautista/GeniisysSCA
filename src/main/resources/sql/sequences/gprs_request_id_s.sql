DROP SEQUENCE CPI.GPRS_REQUEST_ID_S;

CREATE SEQUENCE CPI.GPRS_REQUEST_ID_S
  START WITH 1
  MAXVALUE 999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

