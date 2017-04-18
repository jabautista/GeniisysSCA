SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giis_parameters
              WHERE param_name = 'CONFIG_DOC_PATH_POLDOC_PK')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter CONFIG_DOC_PATH_POLDOC_PK is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'CONFIG_DOC_PATH_POLDOC_PK', 'C:\GENIISYS_WEB\Configurables\policydoc_pk\',
                      'Path of package policydoc configurable documents'
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added CONFIG_DOC_PATH_POLDOC_PK in GIIS_PARAMETERS. ');
      COMMIT;
   END IF;
END;