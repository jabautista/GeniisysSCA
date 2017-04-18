DROP TRIGGER CPI.GIAC_OUCS_TAXDX;

CREATE OR REPLACE TRIGGER CPI."GIAC_OUCS_TAXDX"
   AFTER DELETE
   ON cpi.giac_oucs
   FOR EACH ROW
DECLARE
BEGIN
   DECLARE
      ws_fund_cd      giac_sl_lists.fund_cd%TYPE;
      ws_sl_type_cd   giac_sl_lists.sl_type_cd%TYPE;
      ws_sl_cd        giac_sl_lists.sl_cd%TYPE         := NVL (:NEW.ouc_id, :OLD.ouc_id);
   BEGIN
      --
      -- Get fund code...
      --
      BEGIN
         SELECT param_value_v
           INTO ws_fund_cd
           FROM giac_parameters
          WHERE param_name = 'FUND_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20012, 'Geniisys Exception#E#NO RECORDS IN PARAMETERS TABLE.'   );
      END;

      --
      -- Get sl type code
      --
      BEGIN
         SELECT param_value_v giac_oucs
           INTO ws_sl_type_cd
           FROM giac_parameters
          WHERE param_name = 'GOUC_DEPT_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20012, 'Geniisys Exception#E#NO RECORDS IN PARAMETERS TABLE.'   );
      END;

      --
      --
      DELETE FROM giac_sl_lists
            WHERE fund_cd = ws_fund_cd
              AND sl_type_cd = ws_sl_type_cd
              AND sl_cd = ws_sl_cd;
   END;
END;
/


