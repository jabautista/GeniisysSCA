DROP FUNCTION CPI.GET_TAX_NAME;

CREATE OR REPLACE FUNCTION CPI.Get_Tax_Name (p_tax_type
GICL_LOSS_EXP_TAX.tax_type%TYPE,
                                         p_tax_cd
GICL_LOSS_EXP_TAX.tax_cd%TYPE)
          RETURN VARCHAR2 IS
		  v_tax_name  VARCHAR2(20);
/* return tax_name, where tax_name is a non-base item.
** used in GICLS030 for sorting. Pia, 03.20.03 */
BEGIN
  IF p_tax_type = 'I' THEN
     FOR mt IN
	   (SELECT module_id id
	      FROM giac_modules
		 WHERE module_name = 'GIACS039')
	 LOOP
       FOR tax IN
	     (SELECT description name
	        FROM giac_module_entries
		   WHERE item_no = p_tax_cd
		     AND module_id = mt.id )
       LOOP
	     v_tax_name := tax.name;
	     EXIT;
	   END LOOP;
     END LOOP;
  ELSIF p_tax_type = 'W' THEN
     FOR tax IN
	   (SELECT whtax_desc name
	      FROM giac_wholding_taxes
		 WHERE whtax_id = p_tax_cd)
     LOOP
	   v_tax_name := tax.name;
	   EXIT;
	 END LOOP;
  ELSIF p_tax_type = 'O' THEN
     FOR tax IN
	   (SELECT tax_name name
	      FROM giac_taxes
		 WHERE tax_cd = p_tax_cd)
     LOOP
	   v_tax_name := tax.name;
	   EXIT;
	 END LOOP;
  END IF;
  RETURN(NVL(v_tax_name, 'INPUT VAT'));
END;
/


