SET SERVEROUT ON

BEGIN
   FOR cur
      IN (SELECT column_name
            FROM all_tab_cols
           WHERE     owner = 'CPI'
                 AND column_name LIKE 'TAX%'
                 AND table_name = UPPER ('GIPI_UWREPORTS_INTM_EXT'))
   LOOP
      EXECUTE IMMEDIATE
            'ALTER TABLE cpi.GIPI_UWREPORTS_INTM_EXT DROP COLUMN '
         || cur.column_name;

      DBMS_OUTPUT.put_line (
            'Successfully droppped column '
         || cur.column_name
         || ' for table cpi.GIPI_UWREPORTS_INTM_EXT.');
   END LOOP;
END;