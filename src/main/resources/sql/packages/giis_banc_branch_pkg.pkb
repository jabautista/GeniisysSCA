CREATE OR REPLACE PACKAGE BODY CPI.giis_banc_branch_pkg
AS
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  11-17-2010 
    **  Reference By : (GIPIS002 - Basic Information)   
    **  Description  : banc_branch record group 
    */ 
    FUNCTION get_giis_banc_branch_list
    RETURN giis_banc_branch_tab PIPELINED IS
        v_list              giis_banc_branch_type;
        v_banc_payee_class  giis_parameters.param_value_v%TYPE;  
    BEGIN
    	v_banc_payee_class := giisp.v('BANK_MANAGER_PAYEE_CLASS');
        FOR i IN (SELECT branch_cd, branch_desc, manager_cd, area_cd
                    FROM giis_banc_branch
                  -- WHERE area_cd = NVL (:b540.area_cd, area_cd)
                ORDER BY branch_cd)
        LOOP
            v_list.branch_cd        := i.branch_cd;
            v_list.branch_desc      := i.branch_desc;
            v_list.manager_cd       := i.manager_cd;
            v_list.area_cd          := i.area_cd;
            FOR x in (SELECT --payee_last_name||', '||payee_first_name||' '||payee_middle_name AS payee_full_name
                             decode(payee_first_name, null, payee_last_name, 
                                    payee_last_name||', '||payee_first_name||' '||payee_middle_name) AS payee_full_name
                        FROM giis_payees
                       WHERE payee_class_cd = v_banc_payee_class
                         AND payee_no       = v_list.manager_cd) 
            LOOP
              v_list.dsp_manager_name  := x.payee_full_name;
              EXIT;
            END LOOP;
        	  
            IF v_list.manager_cd IS NULL THEN
                v_list.dsp_manager_name := 'No managers for the given area/branch.';         
            END IF;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    FUNCTION get_giuts035_banc_branch_list
      RETURN giuts035_banc_branch_tab PIPELINED
    IS
        v_row               giuts035_banc_branch_type;
    BEGIN
        FOR i IN(SELECT a.branch_cd, a.branch_desc, b.area_desc
                   FROM GIIS_BANC_BRANCH a,
                        GIIS_BANC_AREA b
                  WHERE a.area_cd = b.area_cd
                  ORDER BY a.branch_cd)
        LOOP
            v_row.branch_cd := i.branch_cd;
            v_row.branch_desc := i.branch_desc;
            v_row.area_desc := i.area_desc;
            
            PIPE ROW(v_row);
        END LOOP;
    END;    

END;
/


