CREATE OR REPLACE PACKAGE BODY CPI.GIPIR946D_PKG AS

    FUNCTION get_header_gipir946d (
        p_scope             gipi_uwreports_peril_ext.SCOPE%TYPE,
        p_user_id           gipi_uwreports_peril_ext.user_id%TYPE
    )
        RETURN header_tab PIPELINED 
    AS
        v_report    header_type;
        
    BEGIN
        v_report.cf_company := gipir946d_pkg.cf_companyformula;
        v_report.cf_company_address := gipir946d_pkg.cf_company_addressformula;
        v_report.cf_heading3 := gipir946d_pkg.cf_heading3formula (p_user_id);
        v_report.cf_based_on := gipir946d_pkg.cf_based_onformula (p_user_id, p_scope);
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
    
    FUNCTION cf_heading3formula (p_user_id gipi_uwreports_peril_ext.user_id%TYPE)
        RETURN CHAR
    IS
        v_param_date    NUMBER(1);
        v_from_date     DATE;
        v_to_date       DATE;
        heading3        VARCHAR2(150);
    
    BEGIN
        SELECT DISTINCT param_date, from_date, to_date
          INTO v_param_date, v_from_date, v_to_date
          FROM gipi_uwreports_peril_ext  
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
        p_user_id   gipi_uwreports_peril_ext.user_id%TYPE,
        p_scope     gipi_uwreports_peril_ext.SCOPE%TYPE
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
          FROM gipi_uwreports_peril_ext
         WHERE user_id = p_user_id AND ROWNUM = 1;

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

    FUNCTION populate_gipir946d (          
        p_iss_cd            gipi_uwreports_peril_ext.iss_cd%TYPE,
        p_line_cd           gipi_uwreports_peril_ext.line_cd%TYPE,
        p_subline_cd        gipi_uwreports_peril_ext.subline_cd%TYPE,
        p_scope             gipi_uwreports_peril_ext.scope%TYPE,
        p_iss_param         NUMBER,
        p_user_id           gipi_uwreports_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
        RETURN report_tab PIPELINED 
    IS    
        v_report            report_type;          
                
        BEGIN
            FOR i IN (SELECT DECODE(p_iss_param,1,cred_branch,iss_cd) iss_cd,
                             line_cd,
                             line_name,
                             subline_cd,
                             intm_no, 
                             intm_name,
                             peril_cd, 
                             peril_name, 
                             peril_type,
                             SUM(DECODE(peril_type,'B',tsi_amt,0)) tsi_basic, 
                             SUM(tsi_amt) sum_tsi_amt,
                             SUM(prem_amt) sum_prem_amt
                        FROM gipi_uwreports_peril_ext
                       WHERE user_id = p_user_id 
                         AND iss_cd <> giacp.v('RI_ISS_CD')
                         AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
                         AND line_cd = NVL(p_line_cd, line_cd)
                         AND subline_cd = NVL(p_subline_cd, subline_cd)
                         AND ((p_scope=3 AND endt_seq_no=endt_seq_no) OR (p_scope=1 AND endt_seq_no=0) OR (p_scope=2 AND endt_seq_no>0))
                         /* added security rights control by robert 01.02.14*/
						 AND check_user_per_iss_cd2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) =1
						 AND check_user_per_line2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) = 1
						 /* robert 01.02.14 end of added code */
					   GROUP BY line_cd, subline_cd, DECODE(p_iss_param,1,cred_branch,iss_cd), 
                                line_name, peril_cd, peril_name, peril_type, intm_no, intm_name
                       ORDER BY peril_name ASC)
                             
            LOOP
                v_report.iss_cd         :=  i.iss_cd;
                v_report.iss_name       :=  gipir946d_pkg.cf_iss_nameFormula (i.iss_cd);
                v_report.line_cd        :=  i.line_cd;
                v_report.line_name      :=  i.line_name;
                v_report.subline_cd     :=  i.subline_cd;
                
                BEGIN
                    SELECT subline_name
                      INTO v_report.subline_name
                      FROM giis_subline
                     WHERE line_cd = i.line_cd
                       AND subline_cd = i.subline_cd;
                 EXCEPTION WHEN no_data_found THEN null;
                END;
                
                v_report.intm_no        :=  i.intm_no;
                v_report.intm_name      :=  i.intm_name;
                v_report.peril_cd       :=  i.peril_cd;
                v_report.peril_name     :=  i.peril_name;
                v_report.peril_type     :=  i.peril_type;
                v_report.sum_tsi_amt    :=  i.sum_tsi_amt;
                v_report.tsi_basic      :=  i.tsi_basic;
                v_report.sum_prem_amt   :=  i.sum_prem_amt;
                
                PIPE ROW(v_report);
            END LOOP;
                             
        END populate_gipir946d;
        
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

END GIPIR946D_PKG;
/


