CREATE OR REPLACE PACKAGE BODY CPI.gipir802_pkg
AS
    /*
   **  Created by   :  Steven
   **  Date Created : 12.13.2013
   **  Report Id : GIPIR802- List of Lines
   */
   FUNCTION get_gipir802_record (p_user_id giis_users.user_id%TYPE)
      RETURN gipir802_record_tab PIPELINED
   IS
      v_rec         gipir802_record_type;
      v_not_exist   BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      FOR i IN (SELECT ALL giis_line.line_cd code, giis_line.line_name line,
                           DECODE (giis_line.pack_pol_flag,
                                   'Y', 'Yes',
                                   'No'
                                  ) PACKAGE
                      FROM cpi.giis_line
                     WHERE check_user_per_line2 (giis_line.line_cd,
                                                 NULL,
                                                 'GIISS001',
                                                 p_user_id
                                                ) = 1)
      LOOP
         v_not_exist := FALSE;
         v_rec.code := i.code;
         v_rec.line := i.line;
         v_rec.PACKAGE := i.PACKAGE;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
   END get_gipir802_record;
END gipir802_pkg;
/


