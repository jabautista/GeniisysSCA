CREATE OR REPLACE PACKAGE BODY CPI.GIPIR929B_PKG
AS
    FUNCTION get_gipir929b_details (
        --p_assd_no       NUMBER,
        --p_intm_no       NUMBER,
        p_iss_cd        GIPI_UWREPORTS_INW_RI_EXT.CRED_BRANCH%TYPE,
        p_iss_param     VARCHAR2,
        p_line_cd       GIPI_UWREPORTS_INW_RI_EXT.LINE_CD%TYPE,
        p_ri_cd         GIPI_UWREPORTS_INW_RI_EXT.RI_CD%TYPE,
        p_scope         NUMBER,
        p_subline_cd    GIPI_UWREPORTS_INW_RI_EXT.SUBLINE_CD%TYPE,
        p_user_id       GIPI_UWREPORTS_INW_RI_EXT.user_id%TYPE --marco - 02.04.2013 - added parameter
    
    ) RETURN gipir929b_tab PIPELINED
    IS
        v_gipir929b_tab           gipir929b_type;
    
        v_company_name            GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
        v_company_address         GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
        v_based_on                VARCHAR2(100);
        v_period_of               VARCHAR2(150);
        v_param_date              NUMBER(1);
        v_scope                   NUMBER(1);        
        v_from_date               DATE;
        v_to_date                 DATE;
        
        v_iss_name                VARCHAR2(50);
        v_policy_no               VARCHAR2(300);        
        V_ENDT_NO                 VARCHAR2(100);
        v_ref_pol_no              VARCHAR2(100):= null; 
        
    BEGIN
        --company name
        SELECT param_value_v
          INTO v_company_name
          FROM giis_parameters
         WHERE UPPER(param_name) = 'COMPANY_NAME';
         
         --company address
        BEGIN
            SELECT param_value_v
              INTO v_company_address
              FROM giis_parameters
             WHERE UPPER(param_name) = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN null;
        END;
         
        --based_on
        SELECT param_date
          INTO v_param_date
          FROM GIPI_UWREPORTS_INW_RI_EXT   --gipi_uwreports_intm_ext changed/commented by ging 052307 (corrected the table to be used, to avoid no_data_found error)
         WHERE user_id = p_user_id --marco - 02.04.2013 - changed from USER
           AND rownum = 1;
      
        IF v_param_date = 1 THEN
            v_based_on := 'Based on Issue Date';
        ELSIF v_param_date = 2 THEN
            v_based_on := 'Based on Inception Date';
        ELSIF v_param_date = 3 THEN
            v_based_on := 'Based on Booking month - year';
        ELSIF v_param_date = 4 THEN
            v_based_on := 'Based on Acctg Entry Date';
        END IF;
      
        v_scope:= p_scope;

        IF v_scope = 1 THEN
            v_based_on := v_based_on||' / '||'Policy Only';
        ELSIF v_scope = 2 THEN
            v_based_on := v_based_on||' / '||'Endorsement Only';
        ELSIF v_scope = 3 THEN
            v_based_on := v_based_on||' / '||'Policies and Endorsements';
        END IF;  	
      
        --period_of
        SELECT DISTINCT param_date, from_date, to_date 
          INTO v_param_date, v_from_date, v_to_date
          FROM gipi_uwreports_inw_ri_ext  
         WHERE user_id = p_user_id; --marco - 02.04.2013 - changed from USER
          
        IF v_param_date in (1,2,4) THEN
            IF v_from_date = v_to_date THEN
                v_period_of := 'For '||to_char(v_from_date,'fmMonth dd, yyyy');
            ELSE 
                v_period_of := 'For the period of '||to_char(v_from_date,'fmMonth dd, yyyy')||' to '
                                    ||to_char(v_to_date,'fmMonth dd, yyyy');
            END IF;
        ELSE
            IF v_from_date = v_to_date THEN
                v_period_of := 'For the month of '||to_char(v_from_date,'fmMonth, yyyy');
            ELSE 
                v_period_of := 'For the period of '||to_char(v_from_date,'fmMonth dd, yyyy')||' to '
                                    ||to_char(v_to_date,'fmMonth dd, yyyy');
            END IF;
        END IF;         
        
        
        v_gipir929b_tab.company_name    := v_company_name;
        v_gipir929b_tab.company_address := v_company_address;
        v_gipir929b_tab.based_on        := v_based_on;
        v_gipir929b_tab.period_of       := v_period_of;
        
        FOR i IN (SELECT a.ri_name, a.ri_cd, a.line_cd, a.line_name, a.subline_cd, a.subline_name, decode(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd,              
                         a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy, 
                         a.endt_seq_no, a.incept_date, a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                         a.lgt, a.doc_stamps, a.fst, a.other_taxes,    
                         a.other_charges, a.param_date, a.from_date, a.to_date, a.scope,         
                         a.user_id, a.policy_id,
                         a.total_prem+ a.evatprem+
                         a.lgt+ a.doc_stamps+ a.fst+ a.other_taxes - nvl(a.ri_comm_amt,0) - nvl(a.ri_comm_vat,0) total,
                         sum( nvl(a.ri_comm_amt,0)) commission,
                         nvl(a.ri_comm_vat,0) ri_comm_vat
                   FROM GIPI_UWREPORTS_INW_RI_EXT a--, GIPI_ITMPERIL b, gipi_invoice c
                  WHERE 1=1-- a.policy_id=b.policy_id(+)
                  --AND a.policy_id = c.policy_id
                    AND a.user_id = p_user_id --marco - 02.04.2013 - changed from USER
                    AND NVL(a.cred_branch,'x') = NVL( p_iss_cd, NVL(a.cred_branch,'x'))
                    AND a.line_cd =NVL( p_line_cd, a.line_cd)
                    AND subline_cd =NVL( p_subline_cd, subline_cd)
                    AND ri_cd = NVL(p_ri_cd, ri_cd)
                    AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                     OR  (p_scope=1 AND endt_seq_no=0)
                     OR  (p_scope=2 AND endt_seq_no>0))
					/* added security rights control by robert 01.02.14*/
			   	    AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
			        AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1
			        /* robert 01.02.14 end of added code */
                  GROUP BY a.ri_name, a.ri_cd, a.line_cd, a.line_name, a.subline_cd, a.subline_name, decode(p_iss_param,1,a.cred_branch,a.iss_cd),              
                           a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy, 
                           a.endt_seq_no, a.incept_date, a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                           a.lgt, a.doc_stamps, a.fst, a.other_taxes,    
                           a.other_charges, a.param_date, a.from_date, a.to_date, a.scope,         
                           a.user_id, a.policy_id, a.total_prem+ a.evatprem+ a.lgt+ a.doc_stamps+ a.fst+ a.other_taxes - nvl(a.ri_comm_amt,0) - nvl(a.ri_comm_vat,0), a.cred_branch, nvl(a.ri_comm_vat,0)
                  ORDER BY a.ri_cd, a.ri_name,a.line_cd, subline_cd, a.cred_branch,issue_yy, pol_seq_no,renew_no, endt_seq_no)
        LOOP          
            --iss_name
            BEGIN
                SELECT iss_name
                  INTO v_iss_name
                  FROM giis_issource
                 WHERE iss_cd = i.iss_cd;
            EXCEPTION
               WHEN no_data_found OR too_many_rows THEN
                 NULL;
            END;      
            
            
            --policy_no
            --START COMMENT: :POL_SEQ_NO1 FORMATTING. JOMARDIAGO 08/03/11
            --V_POLICY_NO := :LINE_CD1||'-'||:SUBLINE_CD1||'-'||:ISS_CD1||'-'||
                                     --LPAD(TO_CHAR(:ISSUE_YY1),2,'0')||'-'||LPAD(TO_CHAR(:POL_SEQ_NO1),7,'0')||'-'||LPAD(TO_CHAR(:RENEW_NO1),2,'0');
            --END COMMENT
            --START ADD: :POL_SEQ_NO1 FORMATTING. JOMARDIAGO 08/03/11
            v_policy_no := i.LINE_CD||'-'||i.SUBLINE_CD||'-'||i.ISS_CD||'-'||
                                     LPAD(TO_CHAR(i.ISSUE_YY),2,'0')||'-'||TO_CHAR(i.POL_SEQ_NO, 'FM0000000')||'-'||LPAD(TO_CHAR(i.RENEW_NO),2,'0');
            --END ADD
            IF i.ENDT_SEQ_NO <> 0 THEN							 
                V_ENDT_NO := i.ENDT_ISS_CD||'-'||LPAD(TO_CHAR(i.ENDT_YY),2,'0')||'-'||LPAD(TO_CHAR(i.ENDT_SEQ_NO),7,'0');
            END IF;
            
            BEGIN
                SELECT ref_pol_no
                  INTO v_ref_pol_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            EXCEPTION
                WHEN no_data_found THEN
                    NULL;
            END;
            
            IF v_ref_pol_no IS NOT NULL THEN
                v_ref_pol_no := '/'||v_ref_pol_no;
            END IF; 
            
            v_policy_no := v_policy_no||' '||V_ENDT_NO||v_ref_pol_no;
            
            
            v_gipir929b_tab.iss_cd          := i.iss_cd;
            v_gipir929b_tab.iss_name        := i.iss_cd||' - '||v_iss_name;
            v_gipir929b_tab.ri_cd           := i.ri_cd;
            v_gipir929b_tab.intm_name       := i.ri_cd||' - '||i.ri_name;
            v_gipir929b_tab.line_cd         := i.line_cd;
            v_gipir929b_tab.line_name       := i.line_name;
            v_gipir929b_tab.subline_cd      := i.subline_cd;
            v_gipir929b_tab.subline_name    := i.subline_name;
            v_gipir929b_tab.policy_no       := v_policy_no;
            v_gipir929b_tab.policy_id       := i.policy_id;
            v_gipir929b_tab.incept_date     := i.incept_date;
            v_gipir929b_tab.total_tsi       := i.total_tsi;
            v_gipir929b_tab.total_prem      := i.total_prem;
            v_gipir929b_tab.evat_prem       := i.evatprem;
            v_gipir929b_tab.lgt             := i.lgt;
            v_gipir929b_tab.doc_stamps      := i.doc_stamps;
            v_gipir929b_tab.fst             := i.fst;
            v_gipir929b_tab.other_taxes     := i.other_taxes;
            v_gipir929b_tab.total           := i.total;
            v_gipir929b_tab.comm            := i.commission;
            v_gipir929b_tab.ri_comm_vat     := i.ri_comm_vat;
            
                
            PIPE ROW(v_gipir929b_tab);
            
        END LOOP; -- end of loop
        
    END; -- end of block     
    
    
END; -- end of package body
/


