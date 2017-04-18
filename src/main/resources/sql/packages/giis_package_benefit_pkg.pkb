CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PACKAGE_BENEFIT_PKG
AS

  FUNCTION giis_package_benefit_list (p_line_cd		 GIIS_PACKAGE_BENEFIT.line_cd%TYPE,
  		   							  p_subline_cd	 GIIS_PACKAGE_BENEFIT.subline_cd%TYPE)
	RETURN giis_package_benefit_tab PIPELINED IS
	v_pack_list 	giis_package_benefit_type;
  BEGIN
    FOR i IN (SELECT PACK_BEN_CD,PACKAGE_CD
  	 	  	    FROM GIIS_PACKAGE_BENEFIT
               WHERE LINE_CD = p_line_cd
                 AND SUBLINE_CD = p_subline_cd
			   ORDER BY upper(package_cd))
	LOOP
	  v_pack_list.pack_ben_cd   := i.pack_ben_cd;
	  v_pack_list.package_cd	:= i.package_cd;
	  PIPE ROW (v_pack_list);
	END LOOP;
	RETURN;
  END;

END;
/


