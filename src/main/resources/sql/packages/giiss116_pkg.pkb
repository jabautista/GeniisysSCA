CREATE OR REPLACE PACKAGE BODY CPI.giiss116_pkg
AS
   FUNCTION get_report_signatory(
    p_user_id           GIIS_USERS.user_id%TYPE --marco - 05.27.2013 - added parameter for check user functions
   )
      RETURN giis_report_signatory_tab PIPELINED
   IS
      v_report_signatory   giis_report_signatory_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.report_id, b.report_title, a.iss_cd,
                                c.iss_name, a.line_cd, d.line_name
                           FROM giis_signatory a,
                                giis_reports b,
                                giis_issource c,
                                giis_line d
                          WHERE a.report_id = b.report_id
                            AND a.iss_cd = c.iss_cd
                            AND a.line_cd = d.line_cd
                            AND check_user_per_line2(a.line_cd,
                                                     a.iss_cd,
                                                     'GIISS116',
                                                     p_user_id
                                                    ) = 1
                            AND check_user_per_iss_cd2(a.line_cd,
                                                       a.iss_cd,
                                                       'GIISS116',
                                                       p_user_id
                                                      ) = 1)
      LOOP
         v_report_signatory.report_id := i.report_id;
         v_report_signatory.report_title := i.report_title;
         v_report_signatory.iss_cd := i.iss_cd;
         v_report_signatory.iss_name := i.iss_name;
         v_report_signatory.line_cd := i.line_cd;
         v_report_signatory.line_name := i.line_name;
         PIPE ROW (v_report_signatory);
      END LOOP;

      RETURN;
   END get_report_signatory;

   FUNCTION get_report_signatory_details (
      p_report_id   giis_signatory.report_id%TYPE,
      p_iss_cd      giis_signatory.iss_cd%TYPE,
      p_line_cd     giis_signatory.line_cd%TYPE
   )
      RETURN giis_report_signatory_dtl_tab PIPELINED
   IS
      v_giis_signatory_details   giis_report_signatory_dtl_type;
   BEGIN
      FOR i IN (SELECT a.report_id, a.iss_cd, a.line_cd,
                       a.current_signatory_sw, a.signatory_id, b.signatory,
                       b.file_name, a.remarks, a.user_id, a.last_update,
                       b.status
                  FROM giis_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND a.report_id = p_report_id
                   AND a.iss_cd = p_iss_cd
                   AND a.line_cd = p_line_cd)
      LOOP
         v_giis_signatory_details.report_id := i.report_id;
         v_giis_signatory_details.iss_cd := i.iss_cd;
         v_giis_signatory_details.line_cd := i.line_cd;
         v_giis_signatory_details.current_signatory_sw :=
                                                       i.current_signatory_sw;
         v_giis_signatory_details.signatory_id := i.signatory_id;
         v_giis_signatory_details.signatory := i.signatory;
         v_giis_signatory_details.file_name := i.file_name;
         v_giis_signatory_details.remarks := i.remarks;
         v_giis_signatory_details.user_id := i.user_id;
         v_giis_signatory_details.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_giis_signatory_details.status := i.status; --marco - 05.27.2013
         PIPE ROW (v_giis_signatory_details);
      END LOOP;

      RETURN;
   END get_report_signatory_details;

   FUNCTION get_report_listing
      RETURN giis_report_tab PIPELINED
   IS
      v_giis_report   giis_report_type;
   BEGIN
   	  /* Modified by   : robert
      ** Date modified : 01.02.2014
      ** Modifications : added distinct and order by
      */
      FOR i IN (SELECT  DISTINCT a.report_id, a.report_title
                  FROM giis_reports a
                  ORDER BY 1)
      LOOP
         v_giis_report.report_id := i.report_id;
         v_giis_report.report_title := i.report_title;
         PIPE ROW (v_giis_report);
      END LOOP;

      RETURN;
   END get_report_listing;

   FUNCTION get_issource_listing(p_user_id VARCHAR2, p_line_cd VARCHAR2)
      RETURN giis_issource_tab PIPELINED
   IS
      v_giis_issource   giis_issource_type;
   BEGIN
      IF p_line_cd IS NULL THEN
         FOR i IN(SELECT a.iss_cd, a.iss_name
                    FROM giis_issource a
                   WHERE check_user_per_iss_cd_acctg2(p_line_cd,a.iss_cd,'GIISS116',p_user_id)=1
                 )
         LOOP
           v_giis_issource.iss_cd := i.iss_cd;
           v_giis_issource.iss_name := i.iss_name;
           PIPE ROW (v_giis_issource);
         END LOOP;
      ELSE
         FOR i IN(SELECT a.iss_cd, a.iss_name
                    FROM giis_issource a
                   WHERE check_user_per_iss_cd2(p_line_cd,a.iss_cd,'GIISS116',p_user_id)=1
                 )
         LOOP
           v_giis_issource.iss_cd := i.iss_cd;
           v_giis_issource.iss_name := i.iss_name;
           PIPE ROW (v_giis_issource);
         END LOOP;  
      END IF;
      
      RETURN;
   END get_issource_listing;

   FUNCTION get_line_listing(p_user_id VARCHAR2, p_iss_cd VARCHAR2)
      RETURN giis_line_tab PIPELINED
   IS
      v_giis_line   giis_line_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.line_name
                  FROM giis_line a
                 WHERE check_user_per_line2(a.line_cd,p_iss_cd,'GIISS116',p_user_id)=1)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_line_listing;

   FUNCTION get_signatory_listing
      RETURN giis_signatory_tab PIPELINED
   IS
      v_giis_signatory   giis_signatory_type;
   BEGIN
      FOR i IN (SELECT a.signatory_id, a.signatory, a.file_name, a.status
                  FROM giis_signatory_names a
                 ORDER BY 1)
      LOOP
         v_giis_signatory.signatory_id := i.signatory_id;
         v_giis_signatory.signatory := i.signatory;
         v_giis_signatory.file_name := i.file_name;
         v_giis_signatory.status := i.status;
         PIPE ROW (v_giis_signatory);
      END LOOP;

      RETURN;
   END get_signatory_listing;

   PROCEDURE val_signatory_report (
      p_report_id   IN       giis_signatory.report_id%TYPE,
      p_iss_cd      IN       giis_signatory.iss_cd%TYPE,
      p_line_cd     IN       giis_signatory.line_cd%TYPE,
      RESULT        OUT      NUMBER
   )
   IS
   BEGIN
      RESULT := 0;

      BEGIN
         SELECT DISTINCT 1
                    INTO RESULT
                    FROM giis_signatory a
                   WHERE a.report_id = p_report_id
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            RESULT := 0;
      END;
   END val_signatory_report;

   PROCEDURE set_giis_signatory (p_signatory giis_report_signatory_dtl_type)
   IS
   BEGIN
      MERGE INTO giis_signatory
         USING DUAL
         ON (    report_id = p_signatory.report_id
             AND iss_cd = p_signatory.iss_cd
             AND line_cd = p_signatory.line_cd
             AND signatory_id = p_signatory.signatory_id)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, signatory_id, current_signatory_sw, iss_cd,
                    remarks, report_id)
            VALUES (p_signatory.line_cd, p_signatory.signatory_id,
                    p_signatory.current_signatory_sw, p_signatory.iss_cd,
                    p_signatory.remarks, p_signatory.report_id)
         WHEN MATCHED THEN
            UPDATE
               SET current_signatory_sw = p_signatory.current_signatory_sw,
                   remarks = p_signatory.remarks
            ;
   END set_giis_signatory;

   PROCEDURE delete_giis_signatory (
      p_report_id      giis_signatory.report_id%TYPE,
      p_iss_cd         giis_signatory.iss_cd%TYPE,
      p_line_cd        giis_signatory.line_cd%TYPE,
      p_signatory_id   giis_signatory.signatory_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_signatory
            WHERE report_id = p_report_id
              AND iss_cd = p_iss_cd
              AND line_cd = p_line_cd
              AND signatory_id = p_signatory_id;
   END delete_giis_signatory;

   PROCEDURE set_signatory_file_name (
      p_signatory_id   giis_signatory_names.signatory_id%TYPE,
      p_file_name      giis_signatory_names.file_name%TYPE
   )
   IS
   BEGIN
       UPDATE giis_signatory_names
          SET file_name = p_file_name
        WHERE signatory_id = p_signatory_id;
   END set_signatory_file_name;
   
   FUNCTION get_report_signatory2(
    p_user_id           GIIS_USERS.user_id%TYPE
   )
      RETURN giis_report_signatory_tab PIPELINED
   IS
      v_report_signatory   giis_report_signatory_type;
   BEGIN
      FOR i IN ( SELECT DISTINCT report_id, iss_cd, line_cd
                   FROM giis_signatory
                  WHERE 1 = 1
                    AND check_user_per_line2 (line_cd,
                                              iss_cd,
                                              'GIISS116',
                                              p_user_id
                                             ) = 1
                    AND check_user_per_iss_cd2 (line_cd,
                                                iss_cd,
                                                'GIISS116',
                                                p_user_id
                                               ) = 1)
      LOOP
         v_report_signatory.report_id := i.report_id;
         v_report_signatory.iss_cd := i.iss_cd;
         v_report_signatory.line_cd := i.line_cd;
         
         --report_title--
        FOR x IN (SELECT distinct report_title
                    FROM giis_reports
                   WHERE report_id LIKE i.report_id)
        LOOP
            v_report_signatory.report_title := x.report_title;
        END LOOP;
    	
        --iss_name--
        FOR y IN (SELECT iss_name
                    FROM giis_issource
                   WHERE iss_cd LIKE i.iss_cd)
        LOOP
            v_report_signatory.iss_name := y.iss_name;
        END LOOP;
    	
        --line_name--
        FOR z IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd LIKE i.line_cd)
        LOOP
            v_report_signatory.line_name := z.line_name;
        END LOOP;
         PIPE ROW (v_report_signatory);
      END LOOP;

      RETURN;
   END get_report_signatory2;
   
   FUNCTION get_used_signatories (
      p_report_id VARCHAR2,
      p_iss_cd VARCHAR2,
      p_line_cd VARCHAR2
   ) RETURN VARCHAR2
   IS
      v_temp VARCHAR2(32767);
   BEGIN
      FOR i IN (SELECT b.signatory_id
                  FROM giis_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND a.report_id = p_report_id
                   AND a.iss_cd = p_iss_cd
                   AND a.line_cd = p_line_cd)
      LOOP
         IF v_temp IS NULL THEN
            v_temp := i.signatory_id;
         ELSE   
            v_temp := v_temp || ',' || i.signatory_id;
         END IF;   
      END LOOP;
      RETURN v_temp;
   END;
   
END giiss116_pkg;
/


