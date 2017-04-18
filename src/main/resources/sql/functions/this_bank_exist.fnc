DROP FUNCTION CPI.THIS_BANK_EXIST;

CREATE OR REPLACE FUNCTION CPI.this_bank_exist(p_bank_name VARCHAR2) RETURN VARCHAR2
AS
  v_bank_exist VARCHAR2(3) DEFAULT 'No';
BEGIN
  FOR i IN (SELECT '1'
              FROM GIAC_BANKS
            WHERE bank_sname = p_bank_name)
  LOOP
    v_bank_exist := 'Yes';
  END LOOP;
  
  /*petermkaw 08312010
    workaround for demo only
    START */
  if p_bank_name is null then
    v_bank_exist := 'Yes';
  END IF;
  /* END */
  
    RETURN (v_bank_exist);
END;
/


