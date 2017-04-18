CREATE OR REPLACE PACKAGE BODY CPI.Giis_Warrcla_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 08, 2010
**  Reference By : (GIPIS024 - Policy - Warranties and Clauses)
**  Description  : This retrieves the warranties and clauese of the given line_cd.
*/
  FUNCTION get_warrcla_list (p_line_cd GIIS_WARRCLA.line_cd%TYPE,
                             p_find_text VARCHAR2)   --line_cd to limit the query
    RETURN warrcla_with_text_tab PIPELINED IS

    v_warranty    warrcla_with_text;

  BEGIN
    FOR i IN (
        SELECT main_wc_cd, line_cd, print_sw, wc_title,
               wc_text01, wc_text02, wc_text03, wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09, wc_text10,
               wc_text11, wc_text12, wc_text13, wc_text14, wc_text15, wc_text16, wc_text17,
               text_update_sw, DECODE(NVL(wc_sw,'W'),'W','Warranty','Clause') wc_sw, remarks
          FROM GIIS_WARRCLA
         WHERE line_cd = p_line_cd
           AND wc_title LIKE NVL(p_find_text, '%')
           AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
         ORDER BY UPPER(wc_title)) --to disregard capitalization in alphabetization BRY 12.23.2010
    LOOP
        v_warranty.line_cd         := i.line_cd;
        v_warranty.main_wc_cd      := i.main_wc_cd;
        v_warranty.wc_title        := i.wc_title;
        v_warranty.print_sw        := i.print_sw;
        /*v_warranty.wc_text         := i.wc_text01||i.wc_text02||i.wc_text03||i.wc_text04||i.wc_text05||i.wc_text06||i.wc_text07||
                                        i.wc_text08||i.wc_text09||i.wc_text10||i.wc_text11||i.wc_text12||i.wc_text13||i.wc_text14||
                                      i.wc_text15||i.wc_text16||i.wc_text17; -- added by: nica 06.16.2011*/
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
        v_warranty.text_update_sw  := i.text_update_sw;
        v_warranty.wc_sw           := i.wc_sw;
        v_warranty.remarks         := i.remarks;
      PIPE ROW(v_warranty);
    END LOOP;

    RETURN;
  END get_warrcla_list;

END Giis_Warrcla_Pkg;
/


