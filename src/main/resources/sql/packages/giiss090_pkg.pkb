CREATE OR REPLACE PACKAGE BODY CPI.giiss090_pkg
AS
   FUNCTION get_rec_list (
      p_report_id     giis_reports.report_id%TYPE,
      p_report_title   giis_reports.report_title%TYPE
   )  RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.report_id, a.report_title, a.remarks, a.user_id, a.last_update,
                       line_cd, subline_cd, report_type, report_desc, destype, desname, desformat, 
                       paramform, copies, report_mode, orientation, background, 
                       generation_frequency, eis_tag, doc_type, module_tag, document_tag,
                       version, bir_tag, bir_form_type, bir_freq_tag, 
                       pagesize, add_source, bir_with_report, disable_file_sw, csv_file_sw
                  FROM giis_reports a
                 WHERE UPPER(a.report_id) LIKE UPPER(NVL (p_report_id, '%'))
                   AND UPPER(NVL(a.report_title, '%')) LIKE UPPER (NVL (p_report_title, '%'))
                 ORDER BY a.report_id
                   )                   
      LOOP
         v_rec.report_id := i.report_id;
         v_rec.report_title := i.report_title;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.report_type := i.report_type;
         v_rec.report_desc := i.report_desc;
         v_rec.destype := i.destype;
         v_rec.desname := i.desname;
         v_rec.desformat := i.desformat;         
         v_rec.paramform := i.paramform;
         v_rec.copies := i.copies;
         v_rec.report_mode := i.report_mode;
         v_rec.orientation := i.orientation;
         v_rec.background := i.background;         
         v_rec.generation_frequency := i.generation_frequency;
         v_rec.eis_tag := i.eis_tag;
         v_rec.doc_type := i.doc_type;
         v_rec.module_tag := i.module_tag;
         v_rec.document_tag := i.document_tag;         
         v_rec.version := i.version;
         v_rec.bir_tag := i.bir_tag;
         v_rec.bir_form_type := i.bir_form_type;
         v_rec.bir_freq_tag := i.bir_freq_tag;
         v_rec.pagesize := i.pagesize;         
         v_rec.add_source := i.add_source;
         v_rec.bir_with_report := i.bir_with_report;
         v_rec.disable_file_sw := i.disable_file_sw;
         v_rec.csv_file_sw := i.csv_file_sw;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_reports%ROWTYPE, p_prev_line_cd VARCHAR2)
   IS
   BEGIN
      MERGE INTO giis_reports
         USING DUAL
         ON (report_id = p_rec.report_id
         AND NVL(line_cd, '*') = NVL(p_prev_line_cd, '*')) -- revised; John Daniel SR-21868 04.18.2016
         
         WHEN NOT MATCHED THEN
            INSERT (report_id,              report_title,           remarks, 
                    user_id,                last_update,
                    report_desc,            report_type,            line_cd,                subline_cd,
                    desname,                desformat,              copies,          
                    generation_frequency,   version,
                    paramform,              background,             disable_file_sw,        csv_file_sw,
                    orientation,            add_source,             report_mode,            destype)
            VALUES (p_rec.report_id,        p_rec.report_title,     p_rec.remarks,
                    p_rec.user_id,          SYSDATE,
                    p_rec.report_desc,      p_rec.report_type,      p_rec.line_cd,          p_rec.subline_cd,
                    p_rec.desname,          p_rec.desformat,        p_rec.copies,    
                    p_rec.generation_frequency, p_rec.version,
                    p_rec.paramform,        p_rec.background,       p_rec.disable_file_sw,  p_rec.csv_file_sw,
                    p_rec.orientation,      p_rec.add_source,       p_rec.report_mode,      p_rec.destype) --replaced reporT_mode to report_mode to insert record properly; John Daniel 04.08.2016
         WHEN MATCHED THEN
            UPDATE
               SET report_title         = p_rec.report_title,
                   remarks              = p_rec.remarks, 
                   user_id              = p_rec.user_id, 
                   last_update          = SYSDATE,
                   report_desc          = p_rec.report_desc,
                   report_type          = p_rec.report_type,
                   --line_cd              = p_rec.line_Cd,  --removed for line_cd validation (ORA-38104)
                   subline_cd           = p_rec.subline_cd, --replaced subline_Cd with subline_cd; John Daniel 04.07.2016 to update column properly
                   desname              = p_rec.desname,
                   desformat            = p_rec.desformat,
                   copies               = p_rec.copies, 
                   generation_frequency = p_rec.generation_frequency,
                   version              = p_rec.version,
                   paramform            = p_rec.paramform,
                   background           = p_rec.background,
                   disable_file_sw      = p_rec.disable_file_sw,
                   csv_file_sw          = p_rec.csv_file_sw,
                   orientation          = p_rec.orientation,
                   add_source           = p_rec.add_source,
                   report_mode          = p_rec.report_mode,
                   destype              = p_rec.destype;

       IF NVL(p_prev_line_cd, '*') != NVL(p_rec.line_cd, '*') --  John Daniel 04.18.2016; workaround to update line cd; revised
       THEN
            UPDATE giis_reports
            SET line_cd = p_rec.line_cd
            WHERE report_id = p_rec.report_id
            AND NVL(line_cd, '*') = NVL(p_prev_line_cd, '*');
       END IF;
   END;

   PROCEDURE del_rec (p_report_id giis_reports.report_id%TYPE)
   AS
   BEGIN   
        NULL;
--      DELETE FROM giis_reports
--            WHERE report_id = p_report_id;
   END;

   PROCEDURE val_del_rec (p_report_id giis_reports.report_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
      
      Dummy_Define CHAR(1);
      CURSOR GIIS_REPORT_AGING_cur IS      
             SELECT 1 
               FROM GIIS_REPORT_AGING G     
              WHERE G.REPORT_ID = P_REPORT_ID;
      
      CURSOR GIIS_REPORT_cur IS      
             SELECT 1 
               FROM GIIS_REPORTS R     
              WHERE R.REPORT_ID = P_REPORT_ID;
   BEGIN
   
      OPEN GIIS_REPORT_cur; 
          
      FETCH GIIS_REPORT_cur INTO Dummy_Define;     
      
      IF ( GIIS_REPORT_cur%found ) THEN
      
        raise_application_error (-20001, 'Geniisys Exception#I#You cannot delete this record.');
             
      END IF;
      
      CLOSE GIIS_REPORT_cur;   
   
      /*OPEN GIIS_REPORT_AGING_cur; 
          
      FETCH GIIS_REPORT_AGING_cur INTO Dummy_Define;     
      
      IF ( GIIS_REPORT_AGING_cur%found ) THEN
      
        raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from giis_reports while dependent record(s) in giis_report_aging exists.');
             
      END IF;
      
      CLOSE GIIS_REPORT_AGING_cur;*/
      
   END;

   PROCEDURE val_add_rec (
    p_report_id giis_reports.report_id%TYPE,
    p_line_cd giis_reports.line_cd%TYPE --John Daniel 04.08.2016; replaced: p_report_title giis_reports.report_title%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_reports a
                 WHERE a.report_id = p_report_id
				 AND NVL(line_cd, '*') = NVL(p_line_cd, '*')) --John Daniel 04.18.2016; revised
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with same report_id.'
                                 );
      END IF;
      
   END;
   
   
   -- for GIIS_REPORT_AGING
   FUNCTION get_rec_aging_list(
      p_report_id       giis_report_aging.reporT_id%TYPE,
      p_user_id         VARCHAR2
   ) RETURN rec_aging_tab PIPELINED
   IS
        v_rec   rec_aging_type;
   BEGIN
   
        FOR i IN (SELECT report_id, branch_Cd, column_no, column_title,
                         min_days, max_days, useR_id, last_update
                    FROM giis_report_aging
                   WHERE report_id = p_report_id
                     AND check_user_per_iss_cd2(null, branch_cd, 'GIISS090', p_user_id)=1)
        LOOP
            v_rec.report_id     := i.report_id;
            v_rec.branch_cd     := i.branch_Cd;
            v_rec.column_no     := i.column_no;
            v_rec.column_title  := i.column_title;
            v_rec.min_days      := i.min_days;
            v_rec.max_days      := i.max_days;
            v_rec.user_id       := i.useR_id;
            v_rec.last_update   := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            FOR a IN (SELECT iss_name FROM giis_issource WHERE iss_cd = i.branch_cd)
            LOOP
                v_rec.branch_name := a.iss_name;
                EXIT;
            END LOOP;
            
            PIPE ROW(v_rec);
        END LOOP;
        
   END get_rec_aging_list;
   
   
   PROCEDURE set_rec_aging (p_rec giis_report_aging%ROWTYPE)
   IS
   BEGIN
        MERGE INTO giis_report_aging
         USING DUAL
         ON (       report_id = p_rec.report_id 
                AND column_no = p_rec.column_no
                AND branch_cd = p_rec.branch_cd)
         WHEN NOT MATCHED THEN
            INSERT (report_id,          branch_cd,           column_no,       column_title,
                    min_days,           max_days,            user_id,         last_update)
            VALUES (p_rec.report_id,    p_rec.branch_cd,     p_rec.column_no, p_rec.column_title,
                    p_rec.min_days,     p_rec.max_days,      p_rec.user_id,   SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET --branch_cd            = p_rec.branch_cd,
                   column_title         = p_rec.column_title,
                   min_days             = p_rec.min_days,
                   max_days             = p_rec.max_days,
                   user_id              = p_rec.user_id, 
                   last_update          = SYSDATE                   
            ;
   END set_rec_aging;

   PROCEDURE del_rec_aging (p_rec giis_report_aging%ROWTYPE)
   IS
   BEGIN
         DELETE FROM giis_report_aging
          WHERE report_id = p_rec.report_id
            AND column_no = p_rec.column_no
--            AND column_title = p_rec.column_title
--            AND min_days = p_rec.min_days
--            AND max_days = p_rec.max_days
            AND branch_cd = p_rec.branch_cd;
   END del_rec_aging;
   
   PROCEDURE val_add_rec_aging (
        p_report_id giis_report_aging.report_id%TYPE,
        p_branch_cd giis_report_aging.branch_cd%TYPE,
        p_column_no giis_report_aging.column_no%TYPE)
   IS
        v_exists    VARCHAR2(1);
   BEGIN
    
      FOR i IN (SELECT '1'
                  FROM giis_report_aging a
                 WHERE a.report_id = p_report_id
                   AND a.branch_cd = p_branch_cd
                   AND a.column_no = p_column_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with same report_id, branch_cd, and column_no.'
                                 );
      END IF;
   END;
   
   PROCEDURE val_del_rec_aging (p_report_id giis_reports.report_id%TYPE)
   IS
   BEGIN
    NULL;
   END;
   
END;
/


