CREATE OR REPLACE PACKAGE BODY CPI.giac_sl_lists_pkg
AS
   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.21.2010
   **  Reference By : (GIACS039 - Direct Trans - Input Vat)
   **  Description  : VAT_SL_CD record groups
   */
   FUNCTION get_vat_sl_list
      RETURN vat_sl_list_tab PIPELINED
   IS
      v_list   vat_sl_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT sl_cd, sl_name, item_no
                           FROM giac_module_entries a,
                                giac_chart_of_accts b,
                                giac_sl_lists c,
                                giac_modules d
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
                            AND b.gslt_sl_type_cd = c.sl_type_cd
                       --AND a.item_no = :gvat.item_no
                ORDER BY        UPPER (sl_name))
      LOOP
         v_list.sl_cd := i.sl_cd;
         v_list.sl_name := i.sl_name;
         v_list.item_no := i.item_no;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.21.2010
   **  Reference By : (GIACS039 - Direct Trans - Input Vat)
   **  Description  : CGFK$GCBA_SL_CD record groups
   */
   FUNCTION get_sl_list (
      p_gslt_sl_type_cd   giac_sl_lists.sl_type_cd%TYPE,
      p_sl_name           giac_sl_lists.sl_name%TYPE
   )
      RETURN vat_sl_list_tab PIPELINED
   IS
      v_list   vat_sl_list_type;
   BEGIN
      FOR i IN (SELECT   sl_cd, sl_name, sl_type_cd
                    FROM giac_sl_lists
                   WHERE sl_type_cd = p_gslt_sl_type_cd
                     AND UPPER (sl_name) LIKE UPPER ('%' || p_sl_name || '%')
                ORDER BY UPPER (sl_name))
      LOOP
         v_list.sl_cd := i.sl_cd;
         v_list.sl_name := i.sl_name;
         v_list.sl_type_cd := i.sl_type_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  11.30.2010
   **  Reference By : (GIACS022 - Other Trans - Wholding Tax)
   **  Description  : Gets the SL Name of specified sl_type_cd and sl_cd
   */
   FUNCTION get_sl_name (
      p_sl_type_cd   giac_sl_lists.sl_type_cd%TYPE,
      p_sl_cd        giac_sl_lists.sl_cd%TYPE
   )
      RETURN giac_sl_lists.sl_name%TYPE
   IS
      v_sl_name   giac_sl_lists.sl_name%TYPE;
   BEGIN
      FOR i IN (SELECT sl_name
                  FROM giac_sl_lists
                 WHERE sl_type_cd = p_sl_type_cd AND sl_cd = p_sl_cd)
      LOOP
         v_sl_name := i.sl_name;
         EXIT;
      END LOOP;

      RETURN v_sl_name;
   END get_sl_name;

   /*
   **  Created by   :  Emman
   **  Date Created :  12.02.2010
   **  Reference By : (GIACS022 - Other Trans - Wholding Tax)
   **  Description  : Gets the SL List of specified whtax_id
   */
   FUNCTION get_sl_list_by_whtax_id (
      p_whtax_id   giac_wholding_taxes.whtax_id%TYPE,
      p_keyword    VARCHAR2
   )
      RETURN vat_sl_list_tab PIPELINED
   IS
      v_sl_list   vat_sl_list_type;
   BEGIN
      FOR i IN (SELECT   b.sl_cd, b.sl_name, b.sl_type_cd
                    FROM giac_wholding_taxes a, giac_sl_lists b
                   WHERE a.sl_type_cd = b.sl_type_cd
                     AND a.whtax_id = p_whtax_id
                     AND (   b.sl_cd LIKE '%' || p_keyword || '%' 
                         OR UPPER(b.sl_name) LIKE NVL('%' || UPPER(p_keyword) || '%', '%%')  /*modified by: karen 04/30/2014 */                   
                         )
                ORDER BY b.sl_cd)
      LOOP
         v_sl_list.sl_cd := i.sl_cd;
         v_sl_list.sl_name := i.sl_name;
         v_sl_list.sl_type_cd := i.sl_type_cd;
         PIPE ROW (v_sl_list);
      END LOOP;
   END get_sl_list_by_whtax_id;

   FUNCTION get_sl_name_list_by_sltype (
      p_sl_type_cd   giac_sl_lists.sl_type_cd%TYPE,
      p_fund_cd      giac_sl_lists.fund_cd%TYPE
   )
      RETURN vat_sl_list_tab PIPELINED
   IS
    v_sl_list vat_sl_list_type;
   BEGIN
      FOR i IN (SELECT   sl_cd, sl_name
                    FROM giac_sl_lists
                   WHERE fund_cd = p_fund_cd AND sl_type_cd = p_sl_type_cd
                ORDER BY sl_name)
      LOOP
         v_sl_list.sl_name := i.sl_name;
		 v_sl_list.sl_cd := i.sl_cd;
		 PIPE ROW(v_sl_list);
      END LOOP;
   END;
   
   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  104.25.2011
   **  Reference By : (GIACS030 - Accounting Entries)
   **  Description  : Gets the SL List for selected GL
   */
   FUNCTION get_sl_list_GIACS030 (
        p_sl_type_cd    GIAC_SL_LISTS.sl_type_cd%TYPE,
        p_find          GIAC_SL_LISTS.sl_name%TYPE)
    RETURN vat_sl_list_tab PIPELINED
   IS
        v_sl_list vat_sl_list_type;
   BEGIN
        FOR i IN (
            SELECT sl_cd, sl_name, sl_type_cd 
                FROM giac_sl_lists 
            WHERE sl_type_cd = p_sl_type_cd
                    AND (	UPPER(sl_name) like NVL(UPPER(p_find), '%')
						 OR sl_cd LIKE NVL(p_find, '%'))
                ORDER BY sl_name
        )
        LOOP
         v_sl_list.sl_name := i.sl_name;
		 v_sl_list.sl_cd := i.sl_cd;
         v_sl_list.sl_type_cd := i.sl_type_cd;
		 PIPE ROW(v_sl_list);
      END LOOP;
   END get_sl_list_GIACS030;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GIAC_SL_LISTS records
    **                  for tax_type = 'W'
    */ 

    FUNCTION get_sl_list_for_tax_type_W(p_tax_cd IN GIIS_LOSS_TAXES.tax_cd%TYPE)
      RETURN vat_sl_list_tab PIPELINED AS

      sl_list vat_sl_list_type;
      
    BEGIN
        FOR i IN (SELECT a.sl_type_cd, a.sl_cd, a.sl_name
                    FROM GIAC_SL_LISTS a, GIAC_WHOLDING_TAXES b
                   WHERE a.sl_type_cd = b.sl_type_cd
                     AND b.whtax_id = TO_CHAR(p_tax_cd)
                  ORDER BY a.sl_cd)
        LOOP
            sl_list.sl_type_cd := i.sl_type_cd;
            sl_list.sl_cd      := i.sl_cd;
            sl_list.sl_name    := i.sl_name;
            PIPE ROW(sl_list);
        
        END LOOP;
                
    END get_sl_list_for_tax_type_W;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GIAC_SL_LISTS records
    **                  for tax_type = 'I'
    */ 

    FUNCTION get_sl_list_for_tax_type_I(p_tax_cd IN GIIS_LOSS_TAXES.tax_cd%TYPE,
										p_find_text IN VARCHAR2) --added by steven 11.20.2012
      RETURN vat_sl_list_tab PIPELINED AS

      sl_list vat_sl_list_type;
      
    BEGIN
        FOR i IN (SELECT a.sl_type_cd, a.sl_cd, a.sl_name
                    FROM GIAC_SL_LISTS a, GIAC_CHART_OF_ACCTS b,
                         GIAC_MODULE_ENTRIES c 
                   WHERE a.sl_type_cd = b.gslt_sl_type_cd
                     AND c.item_no = TO_CHAR(p_tax_cd)
                     AND c.module_id IN (SELECT e.module_id
                                           FROM GIAC_MODULES e
                                          WHERE e.module_name = 'GIACS039') 
                     AND c.gl_acct_category = b.gl_acct_category 
                     AND c.gl_control_acct  = b.gl_control_acct 
                     AND c.gl_sub_acct_1    = b.gl_sub_acct_1 
                     AND c.gl_sub_acct_2    = b.gl_sub_acct_2 
                     AND c.gl_sub_acct_3    = b.gl_sub_acct_3
                     AND c.gl_sub_acct_4    = b.gl_sub_acct_4 
                     AND c.gl_sub_acct_5    = b.gl_sub_acct_5
                     AND c.gl_sub_acct_6    = b.gl_sub_acct_6
                     AND c.gl_sub_acct_7    = b.gl_sub_acct_7
					 AND (a.sl_cd LIKE NVL(p_find_text,a.sl_cd) --added by steven 11.20.2012
					 	  OR UPPER(a.sl_name) LIKE UPPER(NVL(p_find_text,a.sl_name)))
                   ORDER BY a.sl_cd)
        LOOP
            sl_list.sl_type_cd := i.sl_type_cd;
            sl_list.sl_cd      := i.sl_cd;
            sl_list.sl_name    := i.sl_name;
            PIPE ROW(sl_list);
        
        END LOOP;
                
    END get_sl_list_for_tax_type_I;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GIAC_SL_LISTS records
    **                  for tax_type = 'O'
    */ 

    FUNCTION get_sl_list_for_tax_type_O(p_tax_cd IN GIIS_LOSS_TAXES.tax_cd%TYPE)
      RETURN vat_sl_list_tab PIPELINED AS

      sl_list vat_sl_list_type;
      
    BEGIN
        FOR i IN (SELECT a.sl_type_cd, a.sl_cd, a.sl_name
                    FROM GIAC_SL_LISTS a, GIAC_CHART_OF_ACCTS b, GIAC_TAXES c 
                   WHERE a.sl_type_cd = b.gslt_sl_type_cd
                     AND c.tax_cd = TO_CHAR(p_tax_cd)
                     AND b.gl_acct_id = c.gl_acct_id
                ORDER BY a.sl_cd)
        LOOP
            sl_list.sl_type_cd := i.sl_type_cd;
            sl_list.sl_cd      := i.sl_cd;
            sl_list.sl_name    := i.sl_name;
            PIPE ROW(sl_list);
        
        END LOOP;
                
    END get_sl_list_for_tax_type_O;
    
    FUNCTION get_sl_code_list(
      p_gl_acct_id            GIAC_SL_TYPE_HIST.gl_acct_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN vat_sl_list_tab PIPELINED
   IS
      v_row                   vat_sl_list_type;
   BEGIN
      FOR i IN(SELECT gsll.sl_cd, gsll.sl_name, gsll.sl_type_cd
                 FROM GIAC_SL_LISTS gsll
                WHERE gsll.sl_type_cd IN (SELECT DISTINCT gsth.sl_type_cd
                                            FROM GIAC_SL_TYPE_HIST gsth
                                           WHERE gsth.sl_type_cd IS NOT NULL
                                             AND gsth.gl_acct_id = p_gl_acct_id)
                  AND (TO_CHAR(gsll.sl_cd) LIKE NVL(p_find_text, TO_CHAR(gsll.sl_cd))
                   OR UPPER(gsll.sl_name) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(gsll.sl_type_cd) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.sl_cd := i.sl_cd;
         v_row.sl_name := i.sl_name;
         v_row.sl_type_cd := i.sl_type_cd;
         PIPE ROW(v_row);
      END LOOP;
   END;
END;
/


