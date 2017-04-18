CREATE OR REPLACE PACKAGE BODY CPI.giiss119_pkg
AS
/*
** Modified by    : Ildefonso Ellarina Jr
** Date modified  : August 07, 2013
** Description    : Show other details of the obligee
*/
   FUNCTION get_report_parameter_list
      RETURN giis_report_parameter_tab PIPELINED
   IS
      v_list   giis_report_parameter_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_document
                ORDER BY report_id)
      LOOP
         v_list.title := i.title;
         v_list.text := i.text;
         v_list.line_cd := i.line_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         v_list.report_id := i.report_id;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.cpi_rec_no := i.cpi_rec_no;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_report_parameter_list;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 08.14.2013
**  Reference By    : (GIISS119 - File Maintenance - System - Report Parameter Maintenance)
**  Description     : Insert or update record to giis_document
*/
   PROCEDURE set_report_parameter (
      p_title           giis_document.title%TYPE,
      p_text            giis_document.text%TYPE,
      p_line_cd         giis_document.line_cd%TYPE,
      p_remarks         giis_document.remarks%TYPE,
      p_report_id       giis_document.report_id%TYPE,
      p_cpi_branch_cd   giis_document.cpi_branch_cd%TYPE,
      p_cpi_rec_no      giis_document.cpi_rec_no%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_document
         USING DUAL
         ON (report_id = p_report_id AND title = p_title)
         WHEN NOT MATCHED THEN
            INSERT (title, text, line_cd, remarks, report_id, cpi_branch_cd,
                    cpi_rec_no)
            VALUES (p_title, p_text, p_line_cd, p_remarks, p_report_id,
                    p_cpi_branch_cd, p_cpi_rec_no)
         WHEN MATCHED THEN
            UPDATE
               SET text = p_text, line_cd = p_line_cd, remarks = p_remarks,
                   cpi_branch_cd = p_cpi_branch_cd,
                   cpi_rec_no = p_cpi_rec_no
            ;
   END set_report_parameter;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 08.14.2013
**  Reference By    : (GIISS119 - File Maintenance - System - Report Parameter Maintenance)
**  Description     : Delete record in giis_document
*/
   PROCEDURE delete_report_parameter (
      p_title       giis_document.title%TYPE,
      p_report_id   giis_document.report_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_document
            WHERE title = p_title AND report_id = p_report_id;
   END delete_report_parameter;
END giiss119_pkg;
/


