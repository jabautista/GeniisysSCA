DROP SEQUENCE CPI.RESTORED_OR_HIST_SEQ_NO_S;

CREATE SEQUENCE CPI.RESTORED_OR_HIST_SEQ_NO_S
  START WITH 1
  MAXVALUE 999999
  MINVALUE 1
  CYCLE
  NOCACHE
  NOORDER;

