CREATE OR REPLACE PACKAGE BODY CPI.GIAC_MODULE_ENTRIES_PKG
AS
  
  /*
  **  Created by   :  Emman
  **  Date Created :  09.07.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  : Get SL Type Code of specified module ID and item no 
  */ 
  FUNCTION get_sl_type_cd (p_module_id			 GIAC_MODULE_ENTRIES.module_id%TYPE,
  		   				   p_item_no			 GIAC_MODULE_ENTRIES.item_no%TYPE)
  RETURN GIAC_MODULE_ENTRIES.sl_type_cd%TYPE
  IS
  	v_sl_type			   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
  BEGIN
  	  SELECT sl_type_cd
		  INTO v_sl_type
		  FROM GIAC_MODULE_ENTRIES
		 WHERE module_id = p_module_id
		   AND item_no   = p_item_no;
	  
	  RETURN v_sl_type;
  EXCEPTION
  	  WHEN NO_DATA_FOUND THEN
	  	   RETURN NULL;
  END get_sl_type_cd;
  
  /*
  **  Created by   :  Jerome Orio 
  **  Date Created :  09.09.2010
  **  Reference By : (GIACS008 - Inward Facul Prem Collns)
  **  Description  : get_sl_type_parameters PROGRAM UNIT 
  */   
  FUNCTION get_sl_type_parameters(p_module_name     VARCHAR2) 
    RETURN get_sl_type_parameters_tab PIPELINED IS
      v_Sl_TYPE1   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
      v_sl_TYPE2   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
      v_sl_type3   giac_module_entries.sl_type_cd%TYPE;--Vincent 01112006  
      v_sl_type4   giac_module_entries.sl_type_cd%TYPE;--Vincent 01112006  
      v_sl_type5   giac_module_entries.sl_type_cd%TYPE;--Vincent 01112006  
      v_sl_type6   giac_module_entries.sl_type_cd%TYPE;--Vincent 01112006  
      v_sl         get_sl_type_parameters_type;
      item_no      GIAC_MODULE_ENTRIES.item_no%TYPE := 1; --from variable package in GIACS008 
      item_no2     GIAC_MODULE_ENTRIES.item_no%TYPE := 2; --from variable package in GIACS008 
  BEGIN
    v_sl.variables_item_no  := item_no;
    v_sl.variables_item_no2 := item_no2;
    BEGIN
       SELECT param_value_v
         INTO v_sl.variables_assd_no
         FROM giac_parameters
        WHERE param_name = 'ASSD_SL_TYPE';
    
       SELECT param_value_v
         INTO v_sl.variables_ri_cd
         FROM giac_parameters
        WHERE param_name = 'RI_SL_TYPE';
    
       SELECT param_value_v
         INTO v_sl.variables_line_cd
         FROM giac_parameters
        WHERE param_name = 'LINE_SL_TYPE';
        
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          v_sl.v_msg_alert := 'No data found in GIAC PARAMETERS.'; 
    END;
    -- message(variables.line_cd,acknowledge);

    BEGIN
      SELECT module_id,
             generation_type
        INTO v_sl.variables_module_id,
             v_sl.variables_gen_type
        FROM giac_modules
       WHERE module_name  = p_module_name;
    EXCEPTION
      WHEN no_data_found THEN
        v_sl.v_msg_Alert := 'No data found in GIAC MODULES.';
    END;
    
    BEGIN	
      SELECT tax_name
        INTO v_sl.variables_evat_name
        FROM giac_taxes
       WHERE tax_cd = giacp.n('EVAT');
    EXCEPTION
      WHEN no_data_found THEN
        v_sl.v_msg_Alert := 'No data found in table GIAC_TAXES for EVAT.';
    END;
    
    BEGIN
       SELECT sl_type_cd
         INTO v_sl_type1
         FROM giac_module_entries
        WHERE module_id = v_sl.variables_module_id
          AND item_no = v_sl.variables_item_no;

       SELECT sl_type_cd
         INTO v_sl_type2
         FROM giac_module_entries
        WHERE module_id = v_sl.variables_module_id
          AND item_no = v_sl.variables_item_no2;

        --Vincent 01112006: added codes for sl_type of item 3 to 6
        SELECT sl_type_cd
          INTO v_sl_type3
          FROM giac_module_entries    
         WHERE module_id = v_sl.variables_module_id
           AND item_no=3;

        SELECT sl_type_cd
          INTO v_sl_type4
          FROM giac_module_entries    
         WHERE module_id = v_sl.variables_module_id
           AND item_no=4;

        SELECT sl_type_cd
          INTO v_sl_type5
          FROM giac_module_entries    
         WHERE module_id = v_sl.variables_module_id
           AND item_no=5;

        SELECT sl_type_cd
          INTO v_sl_type6
          FROM giac_module_entries    
         WHERE module_id =v_sl.variables_module_id
           AND item_no=6;
    EXCEPTION
      WHEN no_data_found THEN
        v_sl.v_msg_Alert := 'No data found in GIAC MODULE ENTRIES.';
    END;  
        --v--
        
    BEGIN
       IF v_sl_type1 = v_sl.variables_assd_no THEN
          v_sl.variables_sl_type_cd1 := 'ASSD_SL_TYPE';
       ELSIF v_sl_type1 = v_sl.variables_ri_cd THEN
          v_sl.variables_sl_type_cd1 := 'RI_SL_TYPE';
       ELSIF v_sl_type1 = v_sl.variables_line_cd THEN
          v_sl.variables_sl_type_cd1 := 'LINE_SL_TYPE';
       END IF;
    END;
    BEGIN
       IF v_sl_type2 = v_sl.variables_assd_no THEN
          v_sl.variables_sl_type_cd2 := 'ASSD_SL_TYPE';
       ELSIF v_sl_type2 = v_sl.variables_ri_cd THEN
          v_sl.variables_sl_type_cd2 := 'RI_SL_TYPE';
       ELSIF v_sl_type2 = v_sl.variables_line_cd THEN
          v_sl.variables_sl_type_cd2 := 'LINE_SL_TYPE';
       END IF;
    END;
        --Vincent 01112006: added codes for sl_type of item 3 to 6
    BEGIN
       IF v_sl_type3 = v_sl.variables_assd_no THEN
           v_sl.variables_sl_type_cd3 := 'ASSD_SL_TYPE';
       ELSIF v_sl_type3 = v_sl.variables_ri_cd THEN
           v_sl.variables_sl_type_cd3 := 'RI_SL_TYPE' ; 
       ELSIF v_sl_type3 = v_sl.variables_line_cd THEN
           v_sl.variables_sl_type_cd3 := 'LINE_SL_TYPE';
       END IF;
    END;
    BEGIN
       IF v_sl_type4 = v_sl.variables_assd_no THEN
           v_sl.variables_sl_type_cd4 := 'ASSD_SL_TYPE';
       ELSIF v_sl_type4 = v_sl.variables_ri_cd THEN
           v_sl.variables_sl_type_cd4 := 'RI_SL_TYPE' ; 
       ELSIF v_sl_type4 = v_sl.variables_line_cd THEN
           v_sl.variables_sl_type_cd4 := 'LINE_SL_TYPE';
       END IF;
    END;
    BEGIN
       IF v_sl_type5 = v_sl.variables_assd_no THEN
           v_sl.variables_sl_type_cd5 := 'ASSD_SL_TYPE';
       ELSIF v_sl_type5 = v_sl.variables_ri_cd THEN
           v_sl.variables_sl_type_cd5 := 'RI_SL_TYPE' ; 
       ELSIF v_sl_type5 = v_sl.variables_line_cd THEN
           v_sl.variables_sl_type_cd5 := 'LINE_SL_TYPE';
       END IF;
    END;
    BEGIN
       IF v_sl_type6 = v_sl.variables_assd_no THEN
           v_sl.variables_sl_type_cd6 := 'ASSD_SL_TYPE';
       ELSIF v_sl_type6 = v_sl.variables_ri_cd THEN
           v_sl.variables_sl_type_cd6 := 'RI_SL_TYPE' ; 
       ELSIF v_sl_type6 = v_sl.variables_line_cd THEN
           v_sl.variables_sl_type_cd6 := 'LINE_SL_TYPE';
       END IF;
    END;
  
    v_sl.variables_module_name := p_module_name;
    PIPE ROW(v_sl);
  RETURN;
  END;
  
END GIAC_MODULE_ENTRIES_PKG;
/


