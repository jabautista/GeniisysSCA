CREATE OR REPLACE PACKAGE BODY CPI.GIGLR02A_pkg
AS

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created :  1/8/2014
   **  Reference By : GIGLR02A
   **  Remarks      : Chart of Accounts
   */    
  
    FUNCTION get_main_report
        RETURN main_report_tab PIPELINED
    IS
        v_rep    main_report_type;
        v_print  BOOLEAN := TRUE;
        v_header giac_parameters.param_value_v%TYPE;
    BEGIN
    
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_header         := giacp.v('SOA_HEADER');
        
        IF v_header = 'Y' THEN
            v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        ELSE
            v_rep.cf_address := NULL;
        END IF;
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'GIGLR02A';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'CHART OF ACCOUNTS';              
        END;             

        FOR i IN(SELECT get_gl_acct_no (gcoa.gl_acct_id) gl_acct_cd, gcoa.gl_acct_name gl_acct_name, 
                        gcoa.gl_acct_sname gl_acct_sname, gcoa.gslt_sl_type_cd gslt_sl_type_cd, 
                        gslt.sl_type_name sl_type_name, gcoa.leaf_tag leaf_tag
                   FROM giac_chart_of_accts gcoa, giac_sl_types gslt
                  WHERE gslt.sl_type_cd(+) = gcoa.gslt_sl_type_cd
               ORDER BY gcoa.gl_acct_category, 
                        gcoa.gl_control_acct, 
                        gcoa.gl_sub_acct_1, 
                        gcoa.gl_sub_acct_2, 
                        gcoa.gl_sub_acct_3, 
                        gcoa.gl_sub_acct_4, 
                        gcoa.gl_sub_acct_5, 
                        gcoa.gl_sub_acct_6, 
                        gcoa.gl_sub_acct_7)
        LOOP
            v_print                 := FALSE;
            v_rep.gl_acct_cd        := i.gl_acct_cd;
            v_rep.gl_acct_name      := i.gl_acct_name;
            v_rep.gl_acct_sname     := i.gl_acct_sname;
            v_rep.gslt_sl_type_cd   := i.gslt_sl_type_cd;
            v_rep.sl_type_name      := i.sl_type_name;
            v_rep.leaf_tag          := i.leaf_tag;
            PIPE ROW(v_rep);    
        END LOOP;     
              
        IF v_print
        THEN
            v_rep.v_print := 'TRUE';
            PIPE ROW (v_rep);
        END IF;
    END get_main_report;
       
END GIGLR02A_PKG;
/


