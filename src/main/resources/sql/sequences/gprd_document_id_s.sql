DROP SEQUENCE CPI.GPRD_DOCUMENT_ID_S;

CREATE SEQUENCE CPI.GPRD_DOCUMENT_ID_S
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  ORDER;

