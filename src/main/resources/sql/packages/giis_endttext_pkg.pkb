CREATE OR REPLACE PACKAGE BODY CPI.giis_endttext_Pkg AS   
	/*	Date		Author            Description
    **	==========	===============	============================
    **	05.06.2011	Grace Miralles	ENDORSEMENT TEXT record group 
	**								Reference By  : (GIPIS031 - Endt Basic Information)
	**	01.05.2012	mark jm			added escape_value_clob
    */
    FUNCTION get_endttext_list (p_keyword        VARCHAR2)
      RETURN giis_endttext_tab PIPELINED IS
      v_list   giis_endttext_type;
    BEGIN
        FOR i IN (
             SELECT endt_cd,  endt_title, endt_text 
               FROM giis_endttext
              WHERE endt_text IS NOT NULL
                AND (UPPER(endt_cd) LIKE UPPER(NVL(p_keyword,'%')) 
				 OR UPPER(endt_title) LIKE UPPER(NVL(p_keyword,'%')) 
				 OR UPPER(endt_text) LIKE UPPER(NVL(p_keyword,'%')))
                AND active_tag = 'A') --added by carlo SR 5915 01-25-2017
			    /*AND (endt_cd LIKE NVL('%'||p_keyword||'%','%')
                 OR endt_title LIKE NVL('%'||p_keyword||'%','%')
                 OR endt_text LIKE NVL('%'||p_keyword||'%','%')))*/
        LOOP
            v_list.endt_cd         := i.endt_cd;
            v_list.endt_title      := i.endt_title;                          
            v_list.endt_text       := i.endt_text;
			/*v_list.endt_title      := ESCAPE_VALUE_CLOB(i.endt_title);                          
            v_list.endt_text       := ESCAPE_VALUE_CLOB(i.endt_text);*/
          
          PIPE ROW(v_list);
        END LOOP;
    END;   
   
    
END giis_endttext_Pkg;
/


