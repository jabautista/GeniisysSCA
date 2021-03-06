DROP FUNCTION CPI.GET_GROUP_NAME;

CREATE OR REPLACE FUNCTION CPI.get_group_name(p_fs_grp_id NUMBER)
RETURN VARCHAR2 AS
  v_grp_name giac_financial_stmt_row_groups.group_title%TYPE;
BEGIN
  FOR rec IN (
   SELECT group_title
     FROM giac_financial_stmt_row_groups
    WHERE fs_group_id = p_fs_grp_id)
  LOOP
    v_grp_name := rec.group_title;
    EXIT;
  END LOOP;
  RETURN (v_grp_name);
END;
/


