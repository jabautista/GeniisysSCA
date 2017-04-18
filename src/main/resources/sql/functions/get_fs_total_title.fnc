DROP FUNCTION CPI.GET_FS_TOTAL_TITLE;

CREATE OR REPLACE FUNCTION CPI.get_fs_total_title(p_fs_total_id NUMBER)
RETURN VARCHAR2 AS
  v_total_title giac_financial_stmt_totals.total_title%TYPE;
BEGIN
  FOR rec IN (
   SELECT total_title
     FROM giac_financial_stmt_totals
    WHERE fs_total_id = p_fs_total_id)
  LOOP
    v_total_title := rec.total_title;
    EXIT;
  END LOOP;
  RETURN (v_total_title);
END;
/


