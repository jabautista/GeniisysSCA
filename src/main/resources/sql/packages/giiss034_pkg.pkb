CREATE OR REPLACE PACKAGE BODY CPI.GIISS034_PKG AS

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  October 17, 2012
**  Reference By : (GIISS034 - Maintenance - Warranties and Clauses)
**  Description  : This retrieves the warranties and clauses of the given line_cd.
*/
  FUNCTION get_warrcla_list (p_line_cd GIIS_WARRCLA.line_cd%TYPE --line_cd to limit the query                           
  )   
    RETURN warrcla_with_text_tab PIPELINED IS

    v_warranty    warrcla_with_text;

  BEGIN
    FOR i IN (
        SELECT  line_cd, main_wc_cd, print_sw, wc_title, active_tag,
               wc_text01, wc_text02, wc_text03, wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09, wc_text10,
               wc_text11, wc_text12, wc_text13, wc_text14, wc_text15, wc_text16, wc_text17, remarks,
               DECODE(NVL(wc_sw,'W'),'W','Warranty','Clause') wc_sw_desc, wc_sw, user_id, TO_CHAR(last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
          FROM GIIS_WARRCLA
         WHERE line_cd = p_line_cd)
    LOOP
        v_warranty.line_cd         := i.line_cd;
        v_warranty.main_wc_cd      := i.main_wc_cd;
        v_warranty.wc_title        := i.wc_title;
        v_warranty.print_sw        := i.print_sw;
        v_warranty.wc_text01       := i.wc_text01;
        v_warranty.wc_text02       := i.wc_text02;
        v_warranty.wc_text03       := i.wc_text03;
        v_warranty.wc_text04       := i.wc_text04;
        v_warranty.wc_text05       := i.wc_text05;
        v_warranty.wc_text06       := i.wc_text06;
        v_warranty.wc_text07       := i.wc_text07;
        v_warranty.wc_text08       := i.wc_text08;
        v_warranty.wc_text09       := i.wc_text09;
        v_warranty.wc_text10       := i.wc_text10;
        v_warranty.wc_text11       := i.wc_text11;
        v_warranty.wc_text12       := i.wc_text12;
        v_warranty.wc_text13       := i.wc_text13;
        v_warranty.wc_text14       := i.wc_text14;
        v_warranty.wc_text15       := i.wc_text15;
        v_warranty.wc_text16       := i.wc_text16;
        v_warranty.wc_text17       := i.wc_text17;
        v_warranty.wc_sw           := i.wc_sw;
        v_warranty.wc_sw_desc      := i.wc_sw_desc;
        v_warranty.remarks         := i.remarks;
        v_warranty.user_id         := i.user_id;
        v_warranty.last_update     := i.last_update;
        v_warranty.active_tag      := i.active_tag; --carlo 01-26-2017 SR 5915
      PIPE ROW(v_warranty);
    END LOOP;

    RETURN;
  END get_warrcla_list;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  October 18, 2012
**  Reference By : (GIISS034 - Maintenance - Warranties and Clauses)
**  Description  : line listing from giis_line
*/
     FUNCTION get_giis_line_list(p_user_id GIIS_USERS.user_id%TYPE --added by reymon 05042013
     )
      RETURN line_list_tab PIPELINED
   IS
      v_giis_line   line_list;
  BEGIN
     FOR i IN (SELECT   line_cd, line_name
                   FROM giis_line
                 WHERE check_user_per_line2(line_cd, NULL, 'GIISS034',p_user_id) = 1 --added by reymon 05042013
               ORDER BY line_name)
     LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
     END LOOP;

      RETURN;
  END get_giis_line_list;
   
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  October 18, 2012
**  Reference By : (GIISS034 - Maintenance - Warranties and Clauses)
**  Description  : delete row in giis_warrcla
*/
    PROCEDURE delete_giis_warr_cla_row ( 
        p_line_cd  giis_warrcla.line_cd%TYPE,
        p_main_wc_cd  giis_warrcla.main_wc_cd%TYPE
    )
    IS
    BEGIN
       DELETE FROM giis_warrcla 
             WHERE line_cd = p_line_cd 
               AND main_wc_cd = p_main_wc_cd;
               
    END delete_giis_warr_cla_row;
    
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  October 18, 2012
**  Reference By : (GIISS034 - Maintenance - Warranties and Clauses)
**  Description  : update/insert 
*/   
    PROCEDURE set_giis_warr_cla_group (p_warr_cla giis_warrcla%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_warrcla
         USING DUAL
         ON (main_wc_cd = p_warr_cla.main_wc_cd
        AND line_cd = p_warr_cla.line_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, 
                    main_wc_cd, 
                    wc_title, 
                    wc_text01, 
                    wc_text02, 
                    wc_text03,
				    wc_text04, 
                    wc_text05, 
                    wc_text06, 
                    wc_text07, 
                    wc_text08, 
                    wc_text09, 
                    wc_text10, 
                    wc_text11, 
                    wc_text12, 
                    wc_text13, 
                    wc_text14, 
                    wc_text15, 
                    wc_text16, 
                    wc_text17,
                    wc_sw, 
                    print_sw, 
                    remarks,
                    user_id,
                    active_tag) --carlo 01-26-2017 SR 5915
            VALUES (p_warr_cla.line_cd, 
                    p_warr_cla.main_wc_cd, 
                    p_warr_cla.wc_title, 
                    p_warr_cla.wc_text01, 
                    p_warr_cla.wc_text02, 
                    p_warr_cla.wc_text03,
				    p_warr_cla.wc_text04, 
                    p_warr_cla.wc_text05, 
                    p_warr_cla.wc_text06, 
                    p_warr_cla.wc_text07, 
                    p_warr_cla.wc_text08, 
                    p_warr_cla.wc_text09,
                    p_warr_cla.wc_text10, 
                    p_warr_cla.wc_text11, 
                    p_warr_cla.wc_text12, 
                    p_warr_cla.wc_text13, 
                    p_warr_cla.wc_text14, 
                    p_warr_cla.wc_text15, 
                    p_warr_cla.wc_text16, 
                    p_warr_cla.wc_text17, 
                    p_warr_cla.wc_sw, 
                    p_warr_cla.print_sw, 
                    p_warr_cla.remarks,
                    p_warr_cla.user_id,
                    p_warr_cla.active_tag)
         WHEN MATCHED THEN
            UPDATE
               SET wc_title   = p_warr_cla.wc_title,
                   wc_text01  = p_warr_cla.wc_text01,
                   wc_text02  = p_warr_cla.wc_text02,
                   wc_text03  = p_warr_cla.wc_text03,
                   wc_text04  = p_warr_cla.wc_text04,
                   wc_text05  = p_warr_cla.wc_text05,
                   wc_text06  = p_warr_cla.wc_text06,
                   wc_text07  = p_warr_cla.wc_text07,
                   wc_text08  = p_warr_cla.wc_text08,
                   wc_text09  = p_warr_cla.wc_text09,
                   wc_text10  = p_warr_cla.wc_text10,
                   wc_text11  = p_warr_cla.wc_text11,
                   wc_text12  = p_warr_cla.wc_text12,
                   wc_text13  = p_warr_cla.wc_text13,
                   wc_text14  = p_warr_cla.wc_text14,
                   wc_text15  = p_warr_cla.wc_text15,
                   wc_text16  = p_warr_cla.wc_text16,
                   wc_text17  = p_warr_cla.wc_text17,
                   wc_sw      = p_warr_cla.wc_sw, 
                   print_sw   = p_warr_cla.print_sw,
                   remarks    = p_warr_cla.remarks,
                   user_id    = p_warr_cla.user_id,
                   active_tag = p_warr_cla.active_tag; --carlo 01-26-2017 SR 5915
   END set_giis_warr_cla_group;
   
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  October 18, 2012
**  Reference By : (GIISS034 - Maintenance - Warranties and Clauses)
**  Description  : validate delete 
*/ 
    FUNCTION VALIDATE_DELETE_WARR_CLA(
	    p_line_cd	GIIS_WARRCLA.line_cd%TYPE,
	    p_main_wc_cd	GIIS_WARRCLA.main_wc_cd%TYPE
    )

	RETURN VARCHAR2
    IS
        v_warr_cla       VARCHAR2 (30);
        v_warr_cla2      VARCHAR2 (30);
    BEGIN
    
    /* Deletion of GIIS_WARRCLA prevented if GIPI_WPOLWC records exist */
    /* Foreign key(s): WARRCLA_WPOLWC_FK                               */
    /* Deletion of GIIS_WARRCLA prevented if GIPI_POLWC records exist */
    /* Foreign key(s): WARRCLA_POLWC_FK                               */
    
	   SELECT
         (SELECT DISTINCT(UPPER('gipi_wpolwc'))
            FROM gipi_wpolwc
            WHERE LOWER(gipi_wpolwc.line_cd) LIKE LOWER(p_line_cd)
            AND LOWER(gipi_wpolwc.wc_cd) LIKE LOWER(p_main_wc_cd)),
         (SELECT DISTINCT(UPPER('gipi_polwc'))
            FROM gipi_polwc
            WHERE LOWER(gipi_polwc.line_cd) LIKE LOWER(p_line_cd)
            AND LOWER(gipi_polwc.wc_cd) LIKE LOWER(p_main_wc_cd))
       INTO v_warr_cla,
            v_warr_cla2
       FROM DUAL;
       
       
       IF v_warr_cla IS NOT NULL
       THEN
            RETURN v_warr_cla;
       END IF;
       
       IF v_warr_cla2 IS NOT NULL
       THEN
            RETURN v_warr_cla2;
       END IF;
	
        
    RETURN '1';
    
    END VALIDATE_DELETE_WARR_CLA;
    
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  October 18, 2012
**  Reference By : (GIISS034 - Maintenance - Warranties and Clauses)
**  Description  : validate add. prevents insertion to GIIS_WARRCLA if main_wc_cd exist
*/     
    FUNCTION VALIDATE_ADD_WARR_CLA (
	   p_main_wc_cd	GIIS_WARRCLA.main_wc_cd%TYPE,
       p_line_cd	GIIS_WARRCLA.line_cd%TYPE
    )
    
    RETURN VARCHAR2
    
    IS
        v_main_wc_cd     VARCHAR2 (2);
        
    BEGIN
        SELECT(SELECT '0'
                 FROM giis_warrcla
                 WHERE LOWER (main_wc_cd) LIKE LOWER (p_main_wc_cd)
                 AND LOWER(line_cd) LIKE LOWER (p_line_cd)
              )
        INTO v_main_wc_cd
        FROM DUAL;

        IF v_main_wc_cd IS NOT NULL
        THEN
            RETURN v_main_wc_cd;
        END IF;
   
    RETURN '1';
    END VALIDATE_ADD_WARR_CLA;
    


END GIISS034_PKG;
/


