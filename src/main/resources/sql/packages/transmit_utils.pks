CREATE OR REPLACE PACKAGE CPI.transmit_utils as

  v_enable_flag    VARCHAR2(1);

  v_hist_id        NUMBER(12);

  PROCEDURE get_en_flag_val(v_en1 out VARCHAR2);

  PROCEDURE get_en_flag_val_t(v_hist_id number, v_en1 out VARCHAR2);

  PROCEDURE upd_en_flag;

  PROCEDURE upd_en_flag_n;

  PROCEDURE set_en_flag_y;

  PROCEDURE set_en_flag_n;

END;
/


DROP PACKAGE CPI.TRANSMIT_UTILS;