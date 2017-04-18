CREATE OR REPLACE PACKAGE BODY CPI.Giis_Modules_Tran_Pkg AS

  FUNCTION get_giis_modules_tran_list
    RETURN giis_modules_tran_tab PIPELINED IS

	v_giis_module_tran			giis_modules_tran_type;

  BEGIN
    FOR i IN (SELECT b.module_id,  a.module_desc, b.tran_cd, c.tran_desc, b.user_id, b.last_update
				FROM GIIS_MODULES a,
				     GIIS_MODULES_TRAN b,
                     GIIS_TRANSACTION c
			   WHERE a.module_id = b.module_id
                 and b.tran_cd   = c.tran_cd
            ORDER BY tran_desc, module_id)
	LOOP
	  v_giis_module_tran.module_id		 := i.module_id;
	  v_giis_module_tran.module_desc	 := i.module_desc;
      v_giis_module_tran.tran_cd	     := i.tran_cd;
      v_giis_module_tran.tran_desc	     := i.tran_desc;
	  v_giis_module_tran.user_id		 := i.user_id;
	  v_giis_module_tran.last_update	 := i.last_update;
	  PIPE ROW(v_giis_module_tran);
	END LOOP;

	RETURN;
  END;

END Giis_Modules_Tran_Pkg;
/


