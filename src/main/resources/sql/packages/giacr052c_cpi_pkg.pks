CREATE OR REPLACE PACKAGE CPI.GIACR052C_CPI_PKG AS 

  TYPE giacr052c_record_type IS RECORD (
    payee               giac_chk_disbursement.payee%TYPE,
    amount              VARCHAR2(500),
    dv_no               VARCHAR2(500),
    amt_in_words        VARCHAR2(2000)
  );

  TYPE giacr052c_record_tab IS TABLE OF giacr052c_record_type;
  
  FUNCTION populate_giacr052c_records (
      p_tran_id             VARCHAR2,
      p_item_no             VARCHAR2
    )
    RETURN giacr052c_record_tab PIPELINED;

END GIACR052C_CPI_PKG;
/

DROP PACKAGE CPI.GIACR052C_CPI_PKG;