CREATE OR REPLACE PACKAGE BODY CPI.GIPIR929A_PKG AS

    FUNCTION get_header_gipir929a (
        p_scope     gipi_uwreports_inw_ri_ext.SCOPE%TYPE,
        p_user_id   gipi_uwreports_inw_ri_ext.user_id%TYPE
    )
        RETURN header_tab PIPELINED 
    AS
        v_report    header_type;
        
    BEGIN
        v_report.cf_company := gipir929a_pkg.cf_companyformula;
        v_report.cf_company_address := gipir929a_pkg.cf_company_addressformula;
        v_report.cf_heading3 := gipir929a_pkg.cf_heading3formula (p_user_id);
        v_report.cf_based_on := gipir929a_pkg.cf_based_onformula (p_user_id, p_scope);
        PIPE ROW (v_report);
    END;
   
    FUNCTION cf_companyformula
        RETURN CHAR
    IS
        v_company_name   VARCHAR2 (150);
        
    BEGIN
        SELECT param_value_v
          INTO v_company_name
          FROM giis_parameters
         WHERE UPPER(param_name) = 'COMPANY_NAME';

        RETURN (v_company_name);
    END;
   
    FUNCTION cf_company_addressformula
        RETURN CHAR
    IS
        v_address   VARCHAR2 (500);
        
    BEGIN
        SELECT param_value_v
          INTO v_address
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';

        RETURN (v_address);
     EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
    END;
    
    FUNCTION cf_heading3formula (p_user_id gipi_uwreports_inw_ri_ext.user_id%TYPE)
        RETURN CHAR
    IS
        v_param_date    NUMBER(1);
        v_from_date     DATE;
        v_to_date       DATE;
        heading3        VARCHAR2(150);
    
    BEGIN
        SELECT DISTINCT param_date, from_date, to_date
          INTO v_param_date, v_from_date, v_to_date
          FROM gipi_uwreports_inw_ri_ext  
         WHERE user_id = p_user_id;

        IF v_param_date in (1,2,4) THEN
            IF v_from_date = v_to_date THEN
                heading3 := 'For '||TO_CHAR(v_from_date, 'fmMonth dd, YYYY');
            ELSE
                heading3 := 'For the period of '||TO_CHAR(v_from_date, 'fmMonth dd, YYYY')||' to '||TO_CHAR(v_to_date, 'fmMonth dd, YYYY');
            END IF;
        ELSE
            IF v_from_date = v_to_date then
              heading3 := 'For the month of '||TO_CHAR(v_from_date, 'fmMonth dd, YYYY');
            ELSE 
              heading3 := 'For the period of '||TO_CHAR(v_from_date, 'fmMonth dd, YYYY')||' to '||TO_CHAR(v_to_date, 'fmMonth dd, YYYY');
            END IF;

        END IF;
        RETURN(heading3);
    END;
    
    FUNCTION cf_based_onformula (
        p_user_id   gipi_uwreports_inw_ri_ext.user_id%TYPE,
        p_scope     gipi_uwreports_inw_ri_ext.SCOPE%TYPE
    )
        RETURN CHAR
    IS    
        v_param_date     NUMBER (1);
        v_based_on       VARCHAR2 (100);
        v_scope          NUMBER (1);
        v_policy_label   VARCHAR2 (300);
        
    BEGIN
        SELECT param_date
          INTO v_param_date
          FROM gipi_uwreports_inw_ri_ext
         WHERE user_id = p_user_id 
           AND ROWNUM = 1;

        IF v_param_date = 1 THEN
           v_based_on := 'Based on Issue Date';
        ELSIF v_param_date = 2 THEN
           v_based_on := 'Based on Inception Date';
        ELSIF v_param_date = 3 THEN
           v_based_on := 'Based on Booking month - year';
        ELSIF v_param_date = 4 THEN
           v_based_on := 'Based on Acctg Entry Date';
        END IF;

        v_scope := p_scope;

        IF v_scope = 1 THEN
            v_policy_label := v_based_on||' / '||'Policies Only';
        ELSIF v_scope = 2 THEN
            v_policy_label := v_based_on||' / '||'Endorsements Only';
        ELSIF v_scope = 3 THEN
            v_policy_label := v_based_on||' / '||'Policies and Endorsements';
        END IF;

        RETURN (v_policy_label);
    END;
    
    FUNCTION populate_gipir929a (
        p_user_id           gipi_uwreports_inw_ri_ext.user_id%TYPE,
        p_scope             gipi_uwreports_inw_ri_ext.iss_cd%TYPE,
        p_subline_cd        gipi_uwreports_inw_ri_ext.subline_cd%TYPE,
        p_line_cd           gipi_uwreports_inw_ri_ext.line_cd%TYPE,
        p_iss_cd            gipi_uwreports_inw_ri_ext.cred_branch%TYPE,
        p_ri_cd             gipi_uwreports_inw_ri_ext.ri_cd%TYPE
    )
        RETURN report_tab PIPELINED
    IS
        v_rep               report_type;
        
    BEGIN
        FOR i IN (SELECT a.ri_cd, 
                         a.ri_name, 
                         a.line_cd, 
                         a.line_name, 
                         a.subline_cd, 
                         a.subline_name, 
                         a.cred_branch iss_cd,
                         SUM(a.total_tsi) total_tsi, 
                         SUM(a.total_prem) total_prem, 
                         SUM(a.evatprem) evatprem,
                         SUM(a.lgt) lgt, 
                         SUM(a.doc_stamps) doc_stamps, 
                         SUM(a.fst) fst, 
                         SUM(a.other_taxes) other_taxes, 
                         SUM(a.other_charges) other_charges,
                         a.param_date, 
                         a.from_date, 
                         a.to_date, 
                         a.scope, 
                         a.user_id,
                         (SUM(a.total_prem)+SUM(a.evatprem)+SUM(a.lgt)+SUM(a.doc_stamps)+SUM(a.fst)+SUM(a.other_taxes)+SUM(a.other_charges)
                            - SUM(NVL(a.ri_comm_amt,0)) - SUM(NVL(a.ri_comm_vat,0))) total,
                         COUNT(a.policy_id) polcount,
                         SUM(a.ri_comm_amt) commission, 
                         SUM(a.ri_comm_vat) ri_comm_vat
                    FROM GIPI_UWREPORTS_INW_RI_EXT a
                   WHERE 1=1
                     AND a.user_id = p_user_id
                     AND a.ri_cd = NVL(p_ri_cd, a.ri_cd)
                     AND NVL(a.cred_branch,'x') = NVL(p_iss_cd, NVL(a.cred_branch,'x'))
                     AND a.line_cd = NVL(p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
                     AND ((p_scope=3 AND endt_seq_no=endt_seq_no) OR (p_scope=1 AND endt_seq_no=0) OR (p_scope=2 AND endt_seq_no>0))
                     /* added security rights control by robert 01.02.14*/
					 AND check_user_per_iss_cd2 (a.line_cd,NVL(a.cred_branch,'x'),'GIPIS901A', p_user_id) =1
                     AND check_user_per_line2 (a.line_cd,NVL(a.cred_branch,'x'),'GIPIS901A', p_user_id) = 1
					 /* robert 01.02.14 end of added code */
				   GROUP BY a.LINE_CD, a.LINE_NAME, a.SUBLINE_CD, a.SUBLINE_NAME, a.cred_branch, PARAM_DATE, a.FROM_DATE, a.TO_DATE, SCOPE, a.USER_ID,a.ri_cd, a.ri_name
                   ORDER BY iss_cd, a.ri_name, a.line_name, a.subline_name)
        LOOP
            v_rep.iss_cd := i.iss_cd;
            v_rep.iss_name := gipir929a_pkg.cf_iss_nameFormula (i.iss_cd);
            v_rep.ri_cd := i.ri_cd;
            v_rep.ri_name := i.ri_name;
            v_rep.line_cd := i.line_cd;
            v_rep.line_name := i.line_name;
            v_rep.subline_cd := i.subline_cd;
            v_rep.subline_name := i.subline_name;
            v_rep.total_tsi := i.total_tsi;
            v_rep.total_prem := i.total_prem;
            v_rep.evatprem := i.evatprem;
            v_rep.lgt := i.lgt;
            v_rep.doc_stamps := i.doc_stamps;
            v_rep.fst := i.fst;
            v_rep.other_taxes := i.other_taxes;
            v_rep.other_charges := i.other_charges;
            v_rep.param_date := i.param_date;
            v_rep.from_date := i.from_date;
            v_rep.to_date := i.to_date;
            v_rep.scope := i.scope;
            v_rep.user_id := i.user_id;
            v_rep.total := i.total;
            v_rep.polcount := i.polcount;
            v_rep.commission := i.commission;
            v_rep.ri_comm_vat := i.ri_comm_vat;
            
            PIPE ROW (v_rep);
        END LOOP;
    
    END;
    
    FUNCTION cf_iss_nameFormula (p_iss_cd giis_issource.iss_cd%TYPE) 
        RETURN CHAR 
    IS
        v_iss_name      VARCHAR2(50);
        
    BEGIN
        BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = p_iss_cd;
         EXCEPTION
              WHEN no_data_found OR too_many_rows THEN NULL;
        END;
        
        RETURN(p_iss_cd||' - '||v_iss_name);  
    END;

END GIPIR929A_PKG;
/


