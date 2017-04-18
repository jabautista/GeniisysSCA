CREATE OR REPLACE PACKAGE BODY CPI.GIIS_DEDUCTIBLE_DESC_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 08, 2010
**  Reference By : (GIPIS002 - Policy Deductible,
                    GIPIS169 - Item Deductible,
                    GIPIS169 - Peril Deductible)
**  Description  : This returns the deductible records of the given line_cd and subline_cd. 
*/  
  FUNCTION get_ded_deductible_list(p_line_cd        GIIS_LINE.line_cd%TYPE,        --line_cd to limit the query
                                   p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE)  --subline_cd to limit the query
    RETURN ded_deductible_list_tab PIPELINED IS
  
  v_deductible        ded_deductible_list_type;
  
  BEGIN
      FOR i IN (
        SELECT REPLACE(deductible_cd, '/', 'slash') deductible_cd, 
               deductible_title,    ded_type,       rv_meaning ded_type_desc, 
               deductible_rt,       deductible_amt, deductible_text, 
               min_amt,             max_amt,        range_sw 
          FROM GIIS_DEDUCTIBLE_DESC, CG_REF_CODES
         WHERE line_cd      = p_line_cd
           AND subline_cd   = p_subline_cd  
           AND rv_domain    = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
           AND rv_low_value = DED_TYPE
        ORDER BY deductible_title)
    LOOP
        v_deductible.deductible_cd      := i.deductible_cd;
        v_deductible.deductible_title   := i.deductible_title;
        v_deductible.ded_type           := i.ded_type;
        v_deductible.ded_type_desc      := i.ded_type_desc;
        v_deductible.deductible_rt      := i.deductible_rt;
        v_deductible.deductible_amt     := i.deductible_amt;
        v_deductible.deductible_text    := i.deductible_text;
        v_deductible.min_amt            := i.min_amt;
        v_deductible.max_amt            := i.max_amt;
        v_deductible.range_sw           := i.range_sw;                
      PIPE ROW(v_deductible);
    END LOOP;
    
    RETURN;
  END get_ded_deductible_list;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  May 14, 2010
**  Reference By : (GIPIS002 - Policy Deductible,
                    GIPIS169 - Item Deductible,
                    GIPIS169 - Peril Deductible)
**  Description  : This returns the deductible records of the given line_cd and subline_cd. 
*/  
  FUNCTION get_ded_deductible_list2(p_line_cd        GIIS_LINE.line_cd%TYPE,        --line_cd to limit the query
                                   p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE, --subline_cd to limit the query
                                   p_find_text      VARCHAR2)  
    RETURN ded_deductible_list_tab PIPELINED IS
  
  v_deductible        ded_deductible_list_type;
  
  BEGIN
      FOR i IN (
        SELECT REPLACE(deductible_cd, '/', 'slash') deductible_cd, 
               deductible_title,    ded_type,       rv_meaning ded_type_desc, 
               deductible_rt,       deductible_amt, deductible_text, 
               min_amt,             max_amt,        range_sw 
          FROM GIIS_DEDUCTIBLE_DESC, CG_REF_CODES
         WHERE line_cd      = p_line_cd
           AND subline_cd   = p_subline_cd  
           AND rv_domain    = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
           AND rv_low_value = DED_TYPE
           AND (UPPER(deductible_title) LIKE UPPER(NVL(p_find_text, '%%'))
            OR UPPER(rv_meaning) LIKE UPPER(NVL(p_find_text, '%%'))
            OR UPPER(deductible_text) LIKE UPPER(NVL(p_find_text, '%%'))
			OR UPPER(deductible_cd) LIKE UPPER(NVL(p_find_text, '%%')))
        ORDER BY deductible_title)
    LOOP
        v_deductible.deductible_cd      := i.deductible_cd;
        v_deductible.deductible_title   := i.deductible_title;
        v_deductible.ded_type           := i.ded_type;
        v_deductible.ded_type_desc      := i.ded_type_desc;
        v_deductible.deductible_rt      := i.deductible_rt;
        v_deductible.deductible_amt     := i.deductible_amt;
        v_deductible.deductible_text    := i.deductible_text;
        v_deductible.min_amt            := i.min_amt;
        v_deductible.max_amt            := i.max_amt;
        v_deductible.range_sw           := i.range_sw;                
      PIPE ROW(v_deductible);
    END LOOP;
    
    RETURN;
  END get_ded_deductible_list2;
  
  FUNCTION get_quote_deductible_list(p_line_cd        GIIS_LINE.line_cd%TYPE,
                                     p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE,
                                     p_find_text      VARCHAR2)
    RETURN ded_deductible_list_tab PIPELINED IS
    v_deductible        ded_deductible_list_type;
  BEGIN
      FOR i IN(
        SELECT deductible_cd, deductible_title, ded_type, rv_meaning ded_type_desc, 
               deductible_rt, deductible_amt, deductible_text, 
               min_amt, max_amt, range_sw 
          FROM GIIS_DEDUCTIBLE_DESC, CG_REF_CODES
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd  
           AND rv_domain = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
           AND rv_low_value = ded_type
           AND (UPPER(deductible_title) LIKE UPPER(NVL(p_find_text, '%%'))
            OR UPPER(rv_meaning) LIKE UPPER(NVL(p_find_text, '%%'))
            OR UPPER(deductible_text) LIKE UPPER(NVL(p_find_text, '%%'))
			OR UPPER(deductible_cd) LIKE UPPER(NVL(p_find_text, '%%')))
        ORDER BY deductible_title)
    LOOP
        v_deductible.deductible_cd := i.deductible_cd;
        v_deductible.deductible_title := i.deductible_title;
        v_deductible.ded_type := i.ded_type;
        v_deductible.ded_type_desc := i.ded_type_desc;
        v_deductible.deductible_rt := i.deductible_rt;
        v_deductible.deductible_amt := i.deductible_amt;
        v_deductible.deductible_text := i.deductible_text;
        v_deductible.min_amt := i.min_amt;
        v_deductible.max_amt := i.max_amt;
        v_deductible.range_sw := i.range_sw;
                        
        PIPE ROW(v_deductible);
    END LOOP;
  END get_quote_deductible_list;
  
    /* start - Gzelle 08272015 SR4851*/
    FUNCTION get_all_t_type_ded (
       p_line_cd      giis_line.line_cd%TYPE,
       p_subline_cd   giis_subline.subline_cd%TYPE,
       p_ded_type     giis_deductible_desc.ded_type%TYPE
    )
       RETURN ded_deductible_list_tab PIPELINED
    IS
       v_deductible   ded_deductible_list_type;
    BEGIN
       FOR i IN (SELECT   REPLACE (deductible_cd, '/', 'slash') deductible_cd,
                          deductible_title, ded_type, rv_meaning ded_type_desc,
                          deductible_rt, deductible_amt, deductible_text,
                          min_amt, max_amt, range_sw
                     FROM giis_deductible_desc, cg_ref_codes
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND ded_type = p_ded_type
                      AND rv_domain = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
                      AND rv_low_value = ded_type
                 ORDER BY deductible_title)
       LOOP
          v_deductible.deductible_cd    := i.deductible_cd;
          v_deductible.deductible_title := i.deductible_title;
          v_deductible.ded_type         := i.ded_type;
          v_deductible.ded_type_desc    := i.ded_type_desc;
          v_deductible.deductible_rt    := i.deductible_rt;
          v_deductible.deductible_amt   := i.deductible_amt;
          v_deductible.deductible_text  := i.deductible_text;
          v_deductible.min_amt          := i.min_amt;
          v_deductible.max_amt          := i.max_amt;
          v_deductible.range_sw         := i.range_sw;
          PIPE ROW (v_deductible);
       END LOOP;
    END;
    /* end - Gzelle 08272015 SR4851*/

END GIIS_DEDUCTIBLE_DESC_PKG;
/


