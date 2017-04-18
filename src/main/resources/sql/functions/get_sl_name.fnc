DROP FUNCTION CPI.GET_SL_NAME;

CREATE OR REPLACE FUNCTION CPI.get_sl_name(p_sl_cd        IN giac_acct_entries.sl_cd%TYPE,
                                       p_sl_type_cd   IN giac_acct_entries.sl_type_cd%TYPE,
                                       p_sl_source_cd IN giac_acct_entries.sl_source_cd%TYPE)
        RETURN VARCHAR2 IS
  CURSOR sn(p_sl_cd        IN giac_acct_entries.sl_cd%TYPE,
            p_sl_type_cd   IN giac_acct_entries.sl_type_cd%TYPE,
            p_sl_source_cd IN giac_acct_entries.sl_source_cd%TYPE) IS
    SELECT sl_name
      FROM giac_sl_name_v
      WHERE sl_cd = p_sl_cd
      AND sl_type_cd = p_sl_type_cd
      AND source_table = DECODE(p_sl_source_cd, '1', '1',
                                                '2', '2',
                                                NULL, '1');
  v_sl_name   VARCHAR2(900); -- john dolon 7/18/2013 *some sl name needs larger data size
BEGIN
  OPEN sn(p_sl_cd, p_sl_type_cd, p_sl_source_cd);
  FETCH sn INTO v_sl_name;
    IF sn%FOUND THEN
      CLOSE sn;
      RETURN v_sl_name;
    ELSE
      CLOSE sn;
      RETURN NULL;
    END IF;
END;
/


