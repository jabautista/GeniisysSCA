CREATE OR REPLACE PACKAGE BODY CPI.Giis_Section_Or_Hazard_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011
  RECORD GROUP NAME: CGFK$B720_SECTION_OR_HAZARD_CD
***********************************************************************************/

  FUNCTION get_section_or_hazard_list (p_line_cd  	  GIIS_SECTION_OR_HAZARD.section_line_cd%TYPE,
  		   					     	   p_subline_cd   GIIS_SECTION_OR_HAZARD.section_subline_cd%TYPE)
	RETURN section_or_hazard_list_tab PIPELINED IS

	v_section	section_or_hazard_list_type;

  BEGIN
    FOR i IN (
		SELECT section_or_hazard_cd, section_line_cd, section_subline_cd, section_or_hazard_title
		  FROM GIIS_SECTION_OR_HAZARD
		 WHERE section_line_cd = p_line_cd
		   AND section_subline_cd = p_subline_cd
		 ORDER BY upper(section_or_hazard_title))
	LOOP
		v_section.section_or_hazard_cd			:= i.section_or_hazard_cd;
		v_section.section_line_cd				:= i.section_line_cd;
		v_section.section_subline_cd			:= i.section_subline_cd;
		v_section.section_or_hazard_title		:= i.section_or_hazard_title;
	  PIPE ROW(v_section);
	END LOOP;

    RETURN;
  END get_section_or_hazard_list;


/********************************** FUNCTION 2 ************************************
  MODULE: GIIMM002
  RECORD GROUP NAME: SECTION_OR_HAZARD
***********************************************************************************/

  FUNCTION get_section_or_hazard2_list
	RETURN section_or_hazard_list_tab PIPELINED IS

	v_section	section_or_hazard_list_type;

  BEGIN
    FOR i IN (
		SELECT section_or_hazard_cd, section_line_cd, section_subline_cd, section_or_hazard_title
		  FROM GIIS_SECTION_OR_HAZARD
		 ORDER BY upper(section_or_hazard_title))
	LOOP
		v_section.section_or_hazard_cd			:= i.section_or_hazard_cd;
		v_section.section_line_cd				:= i.section_line_cd;
		v_section.section_subline_cd			:= i.section_subline_cd;
		v_section.section_or_hazard_title		:= i.section_or_hazard_title;
	  PIPE ROW(v_section);
	END LOOP;

    RETURN;
  END get_section_or_hazard2_list;

  /*
  **  Created by    : Robert John Virrey
  **  Date Created  : May 14, 2012
  **  Reference By  : GIIMM002 - Enter Quotation Information
  **  Description   : SECTION_OR_HAZARD LOV
  */
  FUNCTION get_section_or_hazard_lov(p_line_cd giis_section_or_hazard.section_line_cd%TYPE, --Added by Jerome 09.07.2016 SR 5644
                                     p_subline_cd giis_section_or_hazard.section_subline_cd%TYPE) --Added by Jerome 09.07.2016 SR 5644
     RETURN section_or_hazard_list_tab PIPELINED
  IS
     v_section   section_or_hazard_list_type;
  BEGIN
     FOR i IN (SELECT section_or_hazard_cd, section_line_cd,
                      section_subline_cd, section_or_hazard_title
                 FROM giis_section_or_hazard
                WHERE section_line_cd = p_line_cd
                  AND section_subline_cd = p_subline_cd)
     LOOP
        v_section.section_or_hazard_cd := i.section_or_hazard_cd;
        v_section.section_line_cd := i.section_line_cd;
        v_section.section_subline_cd := i.section_subline_cd;
        v_section.section_or_hazard_title := i.section_or_hazard_title;
        PIPE ROW (v_section);
     END LOOP;

     RETURN;
  END get_section_or_hazard_lov;

END Giis_Section_Or_Hazard_Pkg;
/


