CREATE OR REPLACE PACKAGE BODY CPI.giis_reports_pkg
AS
/******************************************************************************
   NAME:       GIIS_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/11/2010   Whofeih          1. Created this package body.
******************************************************************************/
   FUNCTION get_report_version (p_report_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_version   VARCHAR2 (50);
   BEGIN
      SELECT VERSION
        INTO v_version
        FROM giis_reports
       WHERE report_id = p_report_id;

      RETURN v_version;
   END;

   FUNCTION get_report_version (
      p_report_id   giis_reports.report_id%TYPE,
      p_line_cd     giis_reports.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_version   VARCHAR2 (50);
   BEGIN
      SELECT VERSION
        INTO v_version
        FROM giis_reports
       WHERE report_id = p_report_id
         AND (   line_cd = p_line_cd
              --OR line_cd = giis_line_pkg.get_menu_line_cd (p_line_cd)  modified by Gzelle 10172014 to prevent ORA-1422 when line_cd has menu_line_cd
             );
      
      IF v_version IS NULL
      THEN
        BEGIN
          SELECT VERSION
            INTO v_version
            FROM giis_reports
           WHERE report_id = p_report_id
             AND line_cd = giis_line_pkg.get_menu_line_cd (p_line_cd);        
        END;
      END IF;

      RETURN v_version;
   END;

   FUNCTION get_reports_per_line_cd (p_line_cd giis_reports.line_cd%TYPE)
      RETURN giis_reports_tab PIPELINED
   IS
      v_rep       giis_reports_type;
      v_count     NUMBER                   := 0;
                         -- mark jm 04.25.2011 @UCPBGEN menu_line_cd handling
      v_line_cd   giis_line.line_cd%TYPE;
                         -- mark jm 04.25.2011 @UCPBGEN menu_line_cd handling
   BEGIN
      -- menu_line_cd starts
      SELECT COUNT (line_cd)
        INTO v_count
        FROM giis_reports
       WHERE line_cd = p_line_cd
	     AND report_id IN ('GIPIR933', 'GIPIR913A', 'GIPIR913', 'GIPIR914',
                           'GIPIR915', 'GIPIR020', 'GIPIR025', 'GIRIR009',
                           'GIPIR102', 'GIPIR049', 'GIPIR049A', 'GIRIR120',
                           'GIPIR913B', 'GIPIR913C', 'GIPIR913D', 'GIPIR152',
                           'BONDS', 'ACK', 'AOJ', 'INDEM', 'ACCIDENT',
                           'AVIATION', 'CASUALTY', 'ENGINEERING', 'MEDICAL',
                           'FIRE', 'MARINE_CARGO', 'MARINE_HULL', 'MOTORCAR',
                           'OTHER') -- added by: Nica 08.23.2012
         OR (LINE_CD IS NULL AND report_id = 'GIPIR153'); --Dren 02.02.2016 SR-5266                         

      IF v_count = 0
      THEN
         FOR x IN (SELECT menu_line_cd
                     FROM giis_line
                    WHERE line_cd = p_line_cd
					)
         LOOP
            v_line_cd := x.menu_line_cd;
            EXIT;
         END LOOP;
      ELSE
         v_line_cd := p_line_cd;
      END IF;

      -- menu_line_cd ends
      FOR i IN (SELECT report_id, report_title, line_cd, VERSION
                  FROM giis_reports
                 WHERE line_cd = v_line_cd                    --:b250.line_cd)
                   AND report_id IN
                          ('GIPIR933', 'GIPIR913A', 'GIPIR913', 'GIPIR914',
                           'GIPIR915', 'GIPIR020', 'GIPIR025', 'GIRIR009',
                           'GIPIR102', 'GIPIR049', 'GIPIR049A', 'GIRIR120',
                           'GIPIR913B', 'GIPIR913C', 'GIPIR913D', 'GIPIR152',
                           'BONDS', 'ACK', 'AOJ', 'INDEM', 'ACCIDENT',
                           'AVIATION', 'CASUALTY', 'ENGINEERING', 'MEDICAL',
                           'FIRE', 'MARINE_CARGO', 'MARINE_HULL', 'MOTORCAR',
                           'OTHER')
                    OR (LINE_CD IS NULL AND report_id = 'GIPIR153')) --Dren 02.02.2016 SR-5266
      LOOP
         v_rep.report_id := i.report_id;
         v_rep.report_title := i.report_title;
         v_rep.line_cd := i.line_cd;
         v_rep.VERSION := i.VERSION;
         PIPE ROW (v_rep);
      END LOOP;

      RETURN;
   END get_reports_per_line_cd;

   FUNCTION get_reports_listing
      RETURN giis_reports_tab PIPELINED
   IS
      v_rep   giis_reports_type;
   BEGIN
      FOR i IN (SELECT report_id, report_title, line_cd, VERSION
                  FROM giis_reports
                 WHERE UPPER (report_id) IN
                                       ('PACKAGE', 'GIPIR913B', 'GIRIR009A', 'GIPIR153')
                UNION
                SELECT report_id, report_title, line_cd, VERSION
                  FROM giis_reports
                 WHERE line_cd = 'PK'
                       OR report_id IN ('GIPIR914', 'GIPIR915'))
      LOOP
         v_rep.report_id := i.report_id;
         v_rep.report_title := i.report_title;
         v_rep.line_cd := i.line_cd;
         v_rep.VERSION := i.VERSION;
         PIPE ROW (v_rep);
      END LOOP;

      RETURN;
   END get_reports_listing;
   
   
    
   FUNCTION get_report_desname (p_report_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_desname   VARCHAR2 (100);
   BEGIN
      null;
   END;
   
   /*
   **  Created by   : Belle Bebing
   **  Date Created : 09.29.2011
   **  Reference By : (GICLS041 - Print Claims Documents)
   **  Description  : Get report listing 
   */ 
   FUNCTION get_reports_listing2 (p_line_cd    GIIS_REPORTS.line_cd%TYPE)
    RETURN giis_reports_tab PIPELINED
  AS
    v_rep  giis_reports_type;
    
  BEGIN
    FOR i IN (SELECT report_id, report_title,line_cd, version
                FROM giis_reports
               WHERE document_tag = 'Y'
                 AND (line_cd = p_line_cd OR line_cd=(SELECT menu_line_cd FROM giis_line WHERE line_cd= p_line_cd) OR line_cd is null))
    LOOP
        v_rep.report_id    := i.report_id;
        v_rep.report_title := i.report_title;
        v_rep.line_cd      := i.line_cd;
        v_rep.version      := i.version;   
      PIPE ROW (v_rep);
    END LOOP;
   RETURN;          
  END;
  
  FUNCTION get_report_desname2 (p_report_id VARCHAR2)
  RETURN VARCHAR2
  IS
     v_path            giis_reports.desname%TYPE; 
  BEGIN
    SELECT desname
      INTO v_path
      FROM giis_reports
     WHERE report_id = p_report_id;

    RETURN v_path;
  END;
  
   FUNCTION get_giexs006_reports (p_report_title giis_reports.report_title%type)
     RETURN giexs006_reports_tab PIPELINED
   IS
     v_giexs006_reports     giexs006_reports_type;
   BEGIN
     FOR i IN(SELECT report_id, report_title
                FROM giis_reports
               WHERE module_tag = 'E'
                 AND UPPER(report_title) LIKE UPPER(NVL(p_report_title,report_title))) -- d.alcantara, uncommented this line
     LOOP
        v_giexs006_reports.report_id    := i.report_id;
        v_giexs006_reports.report_title := i.report_title;
        PIPE ROW(v_giexs006_reports);
     END LOOP;
   END;
  
END giis_reports_pkg;
/


