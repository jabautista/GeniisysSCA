CREATE OR REPLACE PACKAGE BODY CPI.GIAC_CHART_OF_ACCTS_PKG
AS

      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  09.21.2010 
      **  Reference By : (GIACS039 - Direct Trans - Input Vat)   
      **  Description  :  ITEM_NO record group 
      */ 
    FUNCTION get_gl_acct_list 
    RETURN gl_acct_list_tab PIPELINED IS
        v_list          gl_acct_list_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.item_no, b.gl_acct_id,
                           b.gl_acct_category
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09')) gl_acct_cd,
                        b.gl_acct_name, b.gslt_sl_type_cd
                   FROM giac_module_entries a, giac_chart_of_accts b, giac_modules d
                  WHERE d.module_name = 'GIACS039'
                    AND a.module_id = d.module_id
                    AND a.gl_acct_category = b.gl_acct_category
                    AND a.gl_control_acct = b.gl_control_acct
                    AND a.gl_sub_acct_1 = b.gl_sub_acct_1
                    AND a.gl_sub_acct_2 = b.gl_sub_acct_2
                    AND a.gl_sub_acct_3 = b.gl_sub_acct_3
                    AND a.gl_sub_acct_4 = b.gl_sub_acct_4
                    AND a.gl_sub_acct_5 = b.gl_sub_acct_5
                    AND a.gl_sub_acct_6 = b.gl_sub_acct_6
                    AND a.gl_sub_acct_7 = b.gl_sub_acct_7
                  ORDER BY gl_acct_cd)
        LOOP
            v_list.item_no          := i.item_no;
            v_list.gl_acct_id       := i.gl_acct_id;
            v_list.gl_acct_cd       := i.gl_acct_cd;
            v_list.gl_acct_name     := i.gl_acct_name;
            v_list.gslt_sl_type_cd  := i.gslt_sl_type_cd;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;      

      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  09.22.2010 
      **  Reference By : (GIACS039 - Direct Trans - Input Vat)   
      **  Description  :  LOV_ACCOUNT_CODE record group 
      */ 
    FUNCTION get_gl_acct_list2(p_gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE) 
    RETURN gl_acct_list2_tab PIPELINED IS
      v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (SELECT gicoa.gl_acct_category, gicoa.gl_control_acct, gicoa.gl_sub_acct_1,
                         gicoa.gl_sub_acct_2, gicoa.gl_sub_acct_3, gicoa.gl_sub_acct_4,
                         gicoa.gl_sub_acct_5, gicoa.gl_sub_acct_6, gicoa.gl_sub_acct_7,
                         gicoa.gl_acct_name, gicoa.gl_acct_id, gicoa.gslt_sl_type_cd
                    FROM giac_chart_of_accts gicoa
                   WHERE leaf_tag = 'Y'
                     AND UPPER(gicoa.gl_acct_name) LIKE UPPER('%'|| p_gl_acct_name || '%')
                ORDER BY gicoa.gl_acct_category,
                         gicoa.gl_control_acct,
                         gicoa.gl_sub_acct_1,
                         gicoa.gl_sub_acct_2,
                         gicoa.gl_sub_acct_3,
                         gicoa.gl_sub_acct_4,
                         gicoa.gl_sub_acct_5,
                         gicoa.gl_sub_acct_6,
                         gicoa.gl_sub_acct_7)
        LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
            v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
        PIPE ROW(v_list);
        END LOOP;                 
    RETURN;
    END;
    
    FUNCTION get_gl_acct_list3(p_gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE) 
    RETURN gl_acct_list2_tab PIPELINED IS
      v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (SELECT gicoa.gl_acct_category, gicoa.gl_control_acct, gicoa.gl_sub_acct_1,
                         gicoa.gl_sub_acct_2, gicoa.gl_sub_acct_3, gicoa.gl_sub_acct_4,
                         gicoa.gl_sub_acct_5, gicoa.gl_sub_acct_6, gicoa.gl_sub_acct_7,
                         gicoa.gl_acct_name, gicoa.gl_acct_id, gicoa.gslt_sl_type_cd
                    FROM giac_chart_of_accts gicoa
                   WHERE leaf_tag = 'Y'
                     AND UPPER(gicoa.gl_acct_name) LIKE UPPER('%'|| p_gl_acct_name || '%')
                     OR gicoa.gl_acct_category || gicoa.gl_control_acct || gicoa.gl_sub_acct_1 ||
                        gicoa.gl_sub_acct_2 || gicoa.gl_sub_acct_3 || gicoa.gl_sub_acct_4 ||
                        gicoa.gl_sub_acct_5 || gicoa.gl_sub_acct_6 || gicoa.gl_sub_acct_7 LIKE '%' || p_gl_acct_name || '%'  
                ORDER BY gicoa.gl_acct_category,
                         gicoa.gl_control_acct,
                         gicoa.gl_sub_acct_1,
                         gicoa.gl_sub_acct_2,
                         gicoa.gl_sub_acct_3,
                         gicoa.gl_sub_acct_4,
                         gicoa.gl_sub_acct_5,
                         gicoa.gl_sub_acct_6,
                         gicoa.gl_sub_acct_7)
        LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
            v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
        PIPE ROW(v_list);
        END LOOP;                 
    RETURN;
    END;
    
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  09.23.2010 
      **  Reference By : (GIACS039 - Direct Trans - Input Vat)   
      **  Description  :  CHECK_ACCOUNT_CD program unit - validate account code 
      */ 
   FUNCTION CHECK_ACCOUNT_CD(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE)
    RETURN gl_acct_list2_tab PIPELINED IS 
      v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (SELECT gicoa.gl_acct_category, gicoa.gl_control_acct, gicoa.gl_sub_acct_1,
                         gicoa.gl_sub_acct_2, gicoa.gl_sub_acct_3, gicoa.gl_sub_acct_4,
                         gicoa.gl_sub_acct_5, gicoa.gl_sub_acct_6, gicoa.gl_sub_acct_7,
                         gicoa.gl_acct_name, gicoa.gl_acct_id, gicoa.gslt_sl_type_cd
                    FROM giac_chart_of_accts gicoa
                   WHERE leaf_tag = 'Y'
                     AND gicoa.gl_acct_category   = p_gl_acct_category
                     AND gicoa.gl_control_acct    = p_gl_control_acct
                     AND gicoa.gl_sub_acct_1      = p_gl_sub_acct_1
                     AND gicoa.gl_sub_acct_2      = p_gl_sub_acct_2
                     AND gicoa.gl_sub_acct_3      = p_gl_sub_acct_3
                     AND gicoa.gl_sub_acct_4      = p_gl_sub_acct_4
                     AND gicoa.gl_sub_acct_5      = p_gl_sub_acct_5
                     AND gicoa.gl_sub_acct_6      = p_gl_sub_acct_6 
                     AND gicoa.gl_sub_acct_7      = p_gl_sub_acct_7)
        LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
            v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
        END LOOP;   
    PIPE ROW(v_list);                  
    RETURN;
    END;
    
    /*
      **  Created by   :  D.Alcantara
      **  Date Created :  12.02.2010 
      **  Reference By : (GIACS030 - Accounting Entries)   
      **  Description  :  chart of accounts listing 
      */ 
    FUNCTION get_gl_acct_list_GIACS030(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
            p_keyword                 VARCHAR2) 
    RETURN gl_acct_list2_tab PIPELINED IS
        v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (
            SELECT  gicoa.gl_acct_category, gicoa.gl_control_acct ,gicoa.gl_sub_acct_1 ,gicoa.gl_sub_acct_2 ,
                    gicoa.gl_sub_acct_3 ,gicoa.gl_sub_acct_4 ,gicoa.gl_sub_acct_5 ,gicoa.gl_sub_acct_6 ,
                    gicoa.gl_sub_acct_7 ,gicoa.gl_acct_name,gicoa.gl_acct_id, gicoa.gslt_sl_type_cd gslt_sl_type_cd
              FROM  giac_chart_of_accts gicoa 
             WHERE /*TO_CHAR(gicoa.gl_acct_category) LIKE NVL(to_char(p_gl_acct_category),'%') AND 
                    TO_CHAR(gicoa.gl_control_acct) LIKE NVL(to_char(p_gl_control_acct),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_1) LIKE NVL(to_char(p_gl_sub_acct_1),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_2) LIKE NVL(to_char(p_gl_sub_acct_2),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_3) LIKE NVL(to_char(p_gl_sub_acct_3),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_4) LIKE NVL(to_char(p_gl_sub_acct_4),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_5) LIKE NVL(to_char(p_gl_sub_acct_5),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_6) LIKE NVL(to_char(p_gl_sub_acct_6),'%') AND 
                    TO_CHAR(gicoa.gl_sub_acct_7) LIKE NVL(to_char(p_gl_sub_acct_7),'%') AND */
                    gicoa.leaf_tag = 'Y' AND
                    gicoa.gl_acct_category = NVL(p_gl_acct_category, gicoa.gl_acct_category) AND 
                    gicoa.gl_control_acct = NVL(p_gl_control_acct, gicoa.gl_control_acct) AND 
                    gicoa.gl_sub_acct_1 = NVL(p_gl_sub_acct_1, gicoa.gl_sub_acct_1) AND 
                    gicoa.gl_sub_acct_2 = NVL(p_gl_sub_acct_2,gicoa.gl_sub_acct_2) AND 
                    gicoa.gl_sub_acct_3 = NVL(p_gl_sub_acct_3,gicoa.gl_sub_acct_3) AND 
                    gicoa.gl_sub_acct_4 = NVL(p_gl_sub_acct_4,gicoa.gl_sub_acct_4) AND 
                    gicoa.gl_sub_acct_5 = NVL(p_gl_sub_acct_5,gicoa.gl_sub_acct_5) AND 
                    gicoa.gl_sub_acct_6 = NVL(p_gl_sub_acct_6,gicoa.gl_sub_acct_6) AND 
                    gicoa.gl_sub_acct_7 = NVL(p_gl_sub_acct_7,gicoa.gl_sub_acct_7) AND( 
					LTRIM(TO_CHAR (gicoa.gl_acct_category, '09')) || 
                   	LTRIM(TO_CHAR (gicoa.gl_control_acct, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_1, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_2, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_3, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_4, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_5, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_6, '09')) ||
                    LTRIM(TO_CHAR (gicoa.gl_sub_acct_7, '09')) LIKE NVL(p_keyword, '%') OR
                    UPPER(gicoa.gl_acct_name) LIKE NVL(UPPER(p_keyword), '%') OR
					TO_CHAR(gicoa.gl_acct_id) LIKE NVL(p_keyword, '%') OR
					TO_CHAR(gicoa.gslt_sl_type_cd) LIKE NVL(p_keyword, '%'))
             ORDER BY gicoa.gl_acct_category, gicoa.gl_control_acct, gicoa.gl_sub_acct_1,
                    gicoa.gl_sub_acct_2, gicoa.gl_sub_acct_3, gicoa.gl_sub_acct_4,
                    gicoa.gl_sub_acct_5, gicoa.gl_sub_acct_6, gicoa.gl_sub_acct_7
                  /*   (TO_CHAR(gicoa.gl_acct_category) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_control_acct) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_1) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_2) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_3) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_4) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_5) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_6) LIKE UPPER ('%' || p_keyword || '%') OR 
                      TO_CHAR(gicoa.gl_sub_acct_7) LIKE UPPER ('%' || p_keyword || '%') OR*/
                      )   
        LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
            v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
            PIPE ROW(v_list);
        END LOOP;
    END get_gl_acct_list_GIACS030;
	
	
	/*
      **  Created by   :  Tonio
      **  Date Created :  12.16.2010 
      **  Reference By : (GIACS014- Unidentified Collections)   
      **  Description  :  Unidentified Collections
      */ 
    FUNCTION get_gl_acct_list4(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
			p_find					  VARCHAR2) 
    RETURN gl_acct_list2_tab PIPELINED IS
        v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (
            SELECT   gicoa.gl_acct_category,
         LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
         LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
         LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
         LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
         LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
         LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
         LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
         LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7, gicoa.gl_acct_name,
         gicoa.gslt_sl_type_cd, gicoa.gl_acct_id
    FROM giac_chart_of_accts gicoa
   WHERE gicoa.gl_acct_category =
                               NVL (p_gl_acct_category, gicoa.gl_acct_category)
     AND gicoa.gl_control_acct = NVL (p_gl_control_acct, gicoa.gl_control_acct)
     AND gicoa.gl_sub_acct_1 = NVL (p_gl_sub_acct_1, gicoa.gl_sub_acct_1)
     AND gicoa.gl_sub_acct_2 = NVL (p_gl_sub_acct_2, gicoa.gl_sub_acct_2)
     AND gicoa.gl_sub_acct_3 = NVL (p_gl_sub_acct_3, gicoa.gl_sub_acct_3)
     AND gicoa.gl_sub_acct_4 = NVL (p_gl_sub_acct_4, gicoa.gl_sub_acct_4)
     AND gicoa.gl_sub_acct_5 = NVL (p_gl_sub_acct_5, gicoa.gl_sub_acct_5)
     AND gicoa.gl_sub_acct_6 = NVL (p_gl_sub_acct_6, gicoa.gl_sub_acct_6)
     AND gicoa.gl_sub_acct_7 = NVL (p_gl_sub_acct_7, gicoa.gl_sub_acct_7)
     AND gicoa.leaf_tag = 'Y'
	 AND (gicoa.gl_acct_category LIKE NVL (p_find, '%')  
		  OR gicoa.gl_control_acct LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_1 LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_2 LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_3 LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_4 LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_5 LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_6 LIKE NVL (p_find, '%')
		  OR gicoa.gl_sub_acct_7 LIKE NVL (p_find, '%')
		  OR gicoa.gl_acct_name LIKE NVL (p_find, '%')
		  OR gicoa.gslt_sl_type_cd LIKE NVL (p_find, '%')
		  ) --added by christian 05.04.2012
ORDER BY gicoa.gl_acct_category,
         gicoa.gl_control_acct,
         gicoa.gl_sub_acct_1,
         gicoa.gl_sub_acct_2,
         gicoa.gl_sub_acct_3,
         gicoa.gl_sub_acct_4,
         gicoa.gl_sub_acct_5,
         gicoa.gl_sub_acct_6,
         gicoa.gl_sub_acct_7)
        LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
			v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
            PIPE ROW(v_list);
        END LOOP;
    END get_gl_acct_list4;
	
	
	/*
      **  Created by   :  Tonio
      **  Date Created :  1.3.2011 
      **  Reference By : (GIACS014- Unidentified Collections)   
      **  Description  :  Unidentified Collections
      */ 
    FUNCTION search_gl_acct_list(
            p_keyword varchar2) 
    RETURN gl_acct_list2_tab PIPELINED IS
        v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (
            SELECT   gicoa.gl_acct_category,
         LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
         LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
         LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
         LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
         LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
         LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
         LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
         LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7, gicoa.gl_acct_name,
         gicoa.gslt_sl_type_cd, gicoa.gl_acct_id
    FROM giac_chart_of_accts gicoa
   WHERE gicoa.leaf_tag = 'Y' AND 
   	 (gicoa.gl_acct_category like '%' || p_keyword  || '%'                               
     OR gicoa.gl_control_acct like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_1 like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_2 like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_3 like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_4 like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_5 like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_6 like '%' || p_keyword  || '%'
     OR gicoa.gl_sub_acct_7 like '%' || p_keyword  || '%')
ORDER BY gicoa.gl_acct_category,
         gicoa.gl_control_acct,
         gicoa.gl_sub_acct_1,
         gicoa.gl_sub_acct_2,
         gicoa.gl_sub_acct_3,
         gicoa.gl_sub_acct_4,
         gicoa.gl_sub_acct_5,
         gicoa.gl_sub_acct_6,
         gicoa.gl_sub_acct_7)
        LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
			v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
            PIPE ROW(v_list);
        END LOOP;
    END search_gl_acct_list;
    
      /*
      **  Created by   :  D.Alcantara
      **  Date Created :  01.19.2012
      **  Reference By : (GICLS055 - Generate Recovery Acctg. Entries)   
      **  Description  :  chart of accounts LOV on rec acctg entries modal 
      */ 
    FUNCTION get_gl_acct_listing (
        p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
        p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
        p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
        p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
        p_gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE
    ) RETURN gl_acct_list2_tab PIPELINED IS
        v_list      gl_acct_list2_type;
    BEGIN
        FOR i IN (
            SELECT GL_ACCT_CATEGORY, GL_CONTROL_ACCT, GL_SUB_ACCT_1,
                    GL_SUB_ACCT_2, GL_SUB_ACCT_3, GL_SUB_ACCT_4,
                    GL_SUB_ACCT_5, GL_SUB_ACCT_6, GL_SUB_ACCT_7, 
                    GL_ACCT_NAME, GL_ACCT_ID, GSLT_SL_TYPE_CD
              FROM GIAC_CHART_OF_ACCTS
             WHERE /*leaf_tag = 'Y'
               AND*/ gl_acct_category = NVL(p_gl_acct_category, gl_acct_category)
               AND gl_control_acct = NVL(p_gl_control_acct, gl_control_acct)
               AND gl_sub_acct_1 = NVL(p_gl_sub_acct_1, gl_sub_acct_1)
               AND gl_sub_acct_2 = NVL(p_gl_sub_acct_2, gl_sub_acct_2)
               AND gl_sub_acct_3 = NVL(p_gl_sub_acct_3, gl_sub_acct_3)
               AND gl_sub_acct_4 = NVL(p_gl_sub_acct_4, gl_sub_acct_4)
               AND gl_sub_acct_5 = NVL(p_gl_sub_acct_5, gl_sub_acct_5)
               AND gl_sub_acct_6 = NVL(p_gl_sub_acct_6, gl_sub_acct_6)
               AND gl_sub_acct_7 = NVL(p_gl_sub_acct_7, gl_sub_acct_7)
               AND UPPER(gl_acct_name) LIKE (UPPER(p_gl_acct_name)||'%')
             ORDER BY GL_ACCT_CATEGORY, GL_CONTROL_ACCT, GL_SUB_ACCT_1,
                    GL_SUB_ACCT_2, GL_SUB_ACCT_3, GL_SUB_ACCT_4,
                    GL_SUB_ACCT_5, GL_SUB_ACCT_6, GL_SUB_ACCT_7
        ) LOOP
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := i.gl_control_acct;
            v_list.gl_sub_acct_1        := i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := i.gl_sub_acct_7;
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
            v_list.gslt_sl_type_cd      := i.gslt_sl_type_cd;
            PIPE ROW(v_list);
        END LOOP;
    END get_gl_acct_listing;
    
    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 02.02.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : procedure unit AEG_Check_Chart_Of_Accts
   */ 
    PROCEDURE Check_Chart_Of_Accts_GICLS055
        (cca_gl_acct_category   IN  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         cca_gl_control_acct    IN  GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         cca_gl_sub_acct_1      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         cca_gl_sub_acct_2      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         cca_gl_sub_acct_3      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         cca_gl_sub_acct_4      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         cca_gl_sub_acct_5      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         cca_gl_sub_acct_6      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         cca_gl_sub_acct_7      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         cca_gl_acct_id   		IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
         p_mesg					OUT VARCHAR2) IS

         ws_leaf_tag	     GIAC_CHART_OF_ACCTS.leaf_tag%TYPE;

    BEGIN
      BEGIN
        SELECT DISTINCT(gl_acct_id)
          INTO cca_gl_acct_id
          FROM giac_chart_of_accts
         WHERE gl_acct_category  = cca_gl_acct_category
           AND gl_control_acct   = cca_gl_control_acct
           AND gl_sub_acct_1     = cca_gl_sub_acct_1
           AND gl_sub_acct_2     = cca_gl_sub_acct_2
           AND gl_sub_acct_3     = cca_gl_sub_acct_3
           AND gl_sub_acct_4     = cca_gl_sub_acct_4
           AND gl_sub_acct_5     = cca_gl_sub_acct_5
           AND gl_sub_acct_6     = cca_gl_sub_acct_6
           AND gl_sub_acct_7     = cca_gl_sub_acct_7;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_mesg := 'GL account code '||to_char(cca_gl_acct_category)
                    ||'-'||to_char(cca_gl_control_acct,'09') 
                    ||'-'||to_char(cca_gl_sub_acct_1,'09')
                    ||'-'||to_char(cca_gl_sub_acct_2,'09')
                    ||'-'||to_char(cca_gl_sub_acct_3,'09')
                    ||'-'||to_char(cca_gl_sub_acct_4,'09')
                    ||'-'||to_char(cca_gl_sub_acct_5,'09')
                    ||'-'||to_char(cca_gl_sub_acct_6,'09')
                    ||'-'||to_char(cca_gl_sub_acct_7,'09')
                    ||' does not exist in Chart of Accounts (Giac_Acctrans).';
      END;
     
      BEGIN
        SELECT leaf_tag
          INTO ws_leaf_tag
          FROM giac_chart_of_accts
         WHERE gl_acct_id = cca_gl_acct_id;

        IF ws_leaf_tag = 'N' THEN
           p_mesg := 'GL account code '||to_char(cca_gl_acct_category)
                     ||'-'||to_char(cca_gl_control_acct,'09') 
                     ||'-'||to_char(cca_gl_sub_acct_1,'09')
                     ||'-'||to_char(cca_gl_sub_acct_2,'09')
                     ||'-'||to_char(cca_gl_sub_acct_3,'09')
                     ||'-'||to_char(cca_gl_sub_acct_4,'09')
                     ||'-'||to_char(cca_gl_sub_acct_5,'09')
                     ||'-'||to_char(cca_gl_sub_acct_6,'09')
                     ||'-'||to_char(cca_gl_sub_acct_7,'09')
                     ||' is not a posting account.';
        END IF;    
      END;
    END Check_Chart_Of_Accts_GICLS055;
         
    
    /** Created By:     Shan Bati
     ** Date Created:   04.22.2013
     ** Referenced By:  GIACS230 - GL Account Transaction
     ** Description:    gl account LOV
     **/  
    FUNCTION get_gl_acct_list_GIACS230(
        p_gl_acct_category        VARCHAR2, --giac_chart_of_accts.gl_acct_category%TYPE,
        p_gl_control_acct         VARCHAR2, --giac_chart_of_accts.gl_control_acct%TYPE,
        p_gl_sub_acct_1           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_1%TYPE,         
        p_gl_sub_acct_2           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7           VARCHAR2 --giac_chart_of_accts.gl_sub_acct_7%TYPE
    ) RETURN gl_acct_list3_tab PIPELINED
    AS
        v_list     gl_acct_list3_type;
    BEGIN
        FOR i IN (select gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, 
                         gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, 
                         gl_sub_acct_7, gl_acct_name, gl_acct_id 
                    from giac_chart_of_accts 
                   where gl_acct_category = nvl(to_number(p_gl_acct_category), gl_acct_category) 
                     and gl_control_acct = nvl(to_number(p_gl_control_acct), gl_control_acct) 
                     and gl_sub_acct_1 = nvl(to_number(p_gl_sub_acct_1), gl_sub_acct_1) 
                     and gl_sub_acct_2 = nvl(to_number(p_gl_sub_acct_2), gl_sub_acct_2) 
                     and gl_sub_acct_3 = nvl(to_number(p_gl_sub_acct_3), gl_sub_acct_3) 
                     and gl_sub_acct_4 = nvl(to_number(p_gl_sub_acct_4), gl_sub_acct_4) 
                     and gl_sub_acct_5 = nvl(to_number(p_gl_sub_acct_5), gl_sub_acct_5) 
                     and gl_sub_acct_6 = nvl(to_number(p_gl_sub_acct_6), gl_sub_acct_6) 
                     and gl_sub_acct_7 = nvl(to_number(p_gl_sub_acct_7), gl_sub_acct_7) 
                   order by gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, 
                            gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7)
        LOOP
            
            v_list.gl_acct_category     := i.gl_acct_category;
            v_list.gl_control_acct      := to_char(i.gl_control_acct, 'FM09'); --i.gl_control_acct;
            v_list.gl_sub_acct_1        := to_char(i.gl_sub_acct_1, 'FM09') ; --i.gl_sub_acct_1;
            v_list.gl_sub_acct_2        := to_char(i.gl_sub_acct_2, 'FM09'); --i.gl_sub_acct_2;
            v_list.gl_sub_acct_3        := to_char(i.gl_sub_acct_3, 'FM09'); --i.gl_sub_acct_3;
            v_list.gl_sub_acct_4        := to_char(i.gl_sub_acct_4, 'FM09'); --i.gl_sub_acct_4;
            v_list.gl_sub_acct_5        := to_char(i.gl_sub_acct_5, 'FM09'); --i.gl_sub_acct_5;
            v_list.gl_sub_acct_6        := to_char(i.gl_sub_acct_6, 'FM09'); --i.gl_sub_acct_6;
            v_list.gl_sub_acct_7        := to_char(i.gl_sub_acct_7, 'FM09'); --i.gl_sub_acct_7;
            v_list.gl_acct_no           := to_char(i.gl_acct_category, 'FM09') || '-' || to_char(i.gl_control_acct, 'FM09') || '-' || to_char(i.gl_sub_acct_1, 'FM09') 
                                            || '-' || to_char(i.gl_sub_acct_2, 'FM09') || '-' || to_char(i.gl_sub_acct_3, 'FM09') || '-' || to_char(i.gl_sub_acct_4, 'FM09')
                                            || '-' || to_char(i.gl_sub_acct_5, 'FM09') || '-' || to_char(i.gl_sub_acct_6, 'FM09') || '-' || to_char(i.gl_sub_acct_7, 'FM09');
            v_list.gl_acct_name         := i.gl_acct_name;
            v_list.gl_acct_id           := i.gl_acct_id;
            
            IF i.gl_acct_category <> 0 AND i.gl_control_acct <> 0 AND i.gl_sub_acct_1 = 0
                AND i.gl_sub_acct_2 = 0 AND i.gl_sub_acct_3 = 0 AND i.gl_sub_acct_4 = 0
                AND i.gl_sub_acct_5 = 0 AND i.gl_sub_acct_6 = 0 AND i.gl_sub_acct_7 = 0 THEN
                v_list.gl_acct_type := 'M';
            ELSE
                v_list.gl_acct_type := 'C';
            END IF;
            
            PIPE ROW(v_list);
        END LOOP;
        
    END get_gl_acct_list_GIACS230;
    
    FUNCTION get_giacs060_gl_acct_code (
       p_gl_acct_category   VARCHAR2,
       p_gl_control_acct      VARCHAR2,
       p_gl_sub_acct_1        VARCHAR2,
       p_gl_sub_acct_2        VARCHAR2,
       p_gl_sub_acct_3        VARCHAR2,
       p_gl_sub_acct_4        VARCHAR2,
       p_gl_sub_acct_5        VARCHAR2,
       p_gl_sub_acct_6        VARCHAR2,
       p_gl_sub_acct_7        VARCHAR2,
       p_gl_acct_name         VARCHAR2
    )
       RETURN giacs060_gl_acct_code_tab PIPELINED
    IS
       v_list giacs060_gl_acct_code_type;
    BEGIN
       FOR i IN (SELECT  gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                         gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                         gl_sub_acct_7, gl_acct_name, gl_acct_id
                    FROM giac_chart_of_accts
                   WHERE gl_acct_category = NVL(p_gl_acct_category, gl_acct_category)
                     AND gl_control_acct = NVL(p_gl_control_acct, gl_control_acct)
                     AND gl_sub_acct_1 = NVL(p_gl_sub_acct_1, gl_sub_acct_1)
                     AND gl_sub_acct_2 = NVL(p_gl_sub_acct_2, gl_sub_acct_2)
                     AND gl_sub_acct_3 = NVL(p_gl_sub_acct_3, gl_sub_acct_3)
                     AND gl_sub_acct_4 = NVL(p_gl_sub_acct_4, gl_sub_acct_4)
                     AND gl_sub_acct_5 = NVL(p_gl_sub_acct_5, gl_sub_acct_5)
                     AND gl_sub_acct_6 = NVL(p_gl_sub_acct_6, gl_sub_acct_6)
                     AND gl_sub_acct_7 = NVL(p_gl_sub_acct_7, gl_sub_acct_7)
                     AND UPPER(gl_acct_name) LIKE UPPER(NVL(p_gl_acct_name, gl_acct_name))
                ORDER BY gl_acct_category,
                         gl_control_acct,
                         gl_sub_acct_1,
                         gl_sub_acct_2,
                         gl_sub_acct_3,
                         gl_sub_acct_4,
                         gl_sub_acct_5,
                         gl_sub_acct_6,
                         gl_sub_acct_7)
       LOOP
          v_list.gl_acct_category := i.gl_acct_category;
          v_list.gl_control_acct := i.gl_control_acct;
          v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
          v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
          v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
          v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
          v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
          v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
          v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
          v_list.gl_acct_name := i.gl_acct_name;
          v_list.gl_acct_id := i.gl_acct_id;
          
          PIPE ROW(v_list);
       END LOOP;
    END get_giacs060_gl_acct_code;   

FUNCTION get_gl_acct_lov (
       p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
       p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
       p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
       p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
       p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
       p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
       p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
       p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
       p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
       p_find               VARCHAR2
    )
       RETURN gl_acct_list2_tab PIPELINED
    IS
       v_list   gl_acct_list2_type;
    BEGIN
       FOR i IN (SELECT   gicoa.gl_acct_category, LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
                          LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
                          LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
                          LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
                          LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
                          LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
                          LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
                          LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7, gicoa.gl_acct_name,
                          gicoa.gslt_sl_type_cd, gicoa.gl_acct_id, b.sl_type_name
                     FROM giac_chart_of_accts gicoa
                         ,giac_sl_types b
                    WHERE gicoa.gslt_sl_type_cd = b.sl_type_cd 
                        AND gicoa.gl_acct_category   = NVL(p_gl_acct_category,gicoa.gl_acct_category)
                        AND gicoa.gl_control_acct    = NVL(p_gl_control_acct,gicoa.gl_control_acct)
                        AND gicoa.gl_sub_acct_1      = NVL(p_gl_sub_acct_1,gicoa.gl_sub_acct_1)
                        AND gicoa.gl_sub_acct_2      = NVL(p_gl_sub_acct_2,gicoa.gl_sub_acct_2)
                        AND gicoa.gl_sub_acct_3      = NVL(p_gl_sub_acct_3,gicoa.gl_sub_acct_3)
                        AND gicoa.gl_sub_acct_4      = NVL(p_gl_sub_acct_4,gicoa.gl_sub_acct_4)
                        AND gicoa.gl_sub_acct_5      = NVL(p_gl_sub_acct_5,gicoa.gl_sub_acct_5)
                        AND gicoa.gl_sub_acct_6      = NVL(p_gl_sub_acct_6,gicoa.gl_sub_acct_6) 
                        AND gicoa.gl_sub_acct_7      = NVL(p_gl_sub_acct_7,gicoa.gl_sub_acct_7)
                        AND ( gicoa.gl_acct_category LIKE NVL(p_find, '%')
                           OR gicoa.gl_control_acct LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_control_acct,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_1 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_1,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_2 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_2,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_3 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_3,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_4 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_4,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_5 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_5,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_6 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_6,2,'0') LIKE NVL(p_find, '%')
                           OR gicoa.gl_sub_acct_7 LIKE NVL(p_find, '%') OR LPAD(gicoa.gl_sub_acct_7,2,'0') LIKE NVL(p_find, '%')
                           OR UPPER(gicoa.gl_acct_name) LIKE UPPER(NVL (p_find, '%'))
                          )
                 ORDER BY gicoa.gl_acct_category,
                          gicoa.gl_control_acct,
                          gicoa.gl_sub_acct_1,
                          gicoa.gl_sub_acct_2,
                          gicoa.gl_sub_acct_3,
                          gicoa.gl_sub_acct_4,
                          gicoa.gl_sub_acct_5,
                          gicoa.gl_sub_acct_6,
                          gicoa.gl_sub_acct_7)
       LOOP
          v_list.gl_acct_category := i.gl_acct_category;
          v_list.gl_control_acct := i.gl_control_acct;
          v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
          v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
          v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
          v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
          v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
          v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
          v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
          v_list.gl_acct_name := i.gl_acct_name;
          v_list.gl_acct_id := i.gl_acct_id;
          v_list.gslt_sl_type_cd := i.gslt_sl_type_cd;
          v_list.sl_type_name := i.sl_type_name;
          PIPE ROW (v_list);
       END LOOP;
   
    END get_gl_acct_lov;

    FUNCTION get_gl_acct_lov2 (
       p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
       p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
       p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
       p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
       p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
       p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
       p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
       p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
       p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
       p_find               VARCHAR2
    )
       RETURN gl_acct_list2_tab PIPELINED
    IS
       v_list   gl_acct_list2_type;
    BEGIN
       FOR i IN (SELECT   gicoa.gl_acct_category, LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
                          LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
                          LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
                          LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
                          LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
                          LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
                          LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
                          LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7, gicoa.gl_acct_name,
                          gicoa.gslt_sl_type_cd, gicoa.gl_acct_id, b.sl_type_name
                     FROM giac_chart_of_accts gicoa
                         ,giac_sl_types b
                    WHERE gicoa.gslt_sl_type_cd = b.sl_type_cd (+)
                      AND gicoa.leaf_tag = 'Y'
                      AND (   UPPER(gicoa.gl_acct_category) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_control_acct) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_1) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_2) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_3) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_4) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_5) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_6) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_sub_acct_7) LIKE UPPER(NVL (p_find, '%'))
                           OR UPPER(gicoa.gl_acct_name) LIKE UPPER(NVL (p_find, '%'))
                          )
                 ORDER BY gicoa.gl_acct_category,
                          gicoa.gl_control_acct,
                          gicoa.gl_sub_acct_1,
                          gicoa.gl_sub_acct_2,
                          gicoa.gl_sub_acct_3,
                          gicoa.gl_sub_acct_4,
                          gicoa.gl_sub_acct_5,
                          gicoa.gl_sub_acct_6,
                          gicoa.gl_sub_acct_7)
       LOOP
          v_list.gl_acct_category := i.gl_acct_category;
          v_list.gl_control_acct := i.gl_control_acct;
          v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
          v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
          v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
          v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
          v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
          v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
          v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
          v_list.gl_acct_name := i.gl_acct_name;
          v_list.gl_acct_id := i.gl_acct_id;
          v_list.gslt_sl_type_cd := i.gslt_sl_type_cd;
          v_list.sl_type_name := i.sl_type_name;
          PIPE ROW (v_list);
       END LOOP;
   
    END get_gl_acct_lov2; 
     
END giac_chart_of_accts_pkg;
/


