DROP FUNCTION CPI.GET_COLUMNNAME;

CREATE OR REPLACE FUNCTION CPI.get_columnname (p_pos NUMBER, p_table VARCHAR2)
   RETURN VARCHAR
AS
   v_column   VARCHAR2 (1000);
BEGIN
   SELECT b.column_name
     INTO v_column
     FROM user_constraints a, user_cons_columns b
    WHERE a.constraint_type IN ('P' /*,'R'*/)
      AND a.constraint_name NOT LIKE 'EUL%'
      AND a.constraint_name NOT LIKE 'BIN%'
      AND a.constraint_name = b.constraint_name
      AND b.table_name = p_table
      AND POSITION = p_pos;

   RETURN v_column;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
END;
/


