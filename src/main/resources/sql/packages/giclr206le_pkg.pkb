CREATE OR REPLACE PACKAGE BODY CPI.GICLR206LE_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   04.09.2013
     ** Referenced By:  GICLR206LE - LOSSES and EXPENSES PAID BORDEREAUX
     **/
     
    FUNCTION CF_COMPANYFormula
        RETURN VARCHAR2
    AS
        v_name      giac_parameters.param_value_v%type;
    BEGIN
        SELECT param_value_v
          INTO v_name
          FROM giac_parameters
         WHERE param_name = 'COMPANY_NAME';
        
        RETURN (v_name);
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN (null);    
    END CF_COMPANYFormula;
        
        
    FUNCTION CF_COM_ADDRESSFormula
        RETURN VARCHAR2
    AS
        v_add 	giis_parameters.param_value_v%TYPE; 
    BEGIN
        SELECT param_value_v
          INTO v_add
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
        
        RETURN (v_add);
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN (null);
    END CF_COM_ADDRESSFormula;
        
    
    FUNCTION CF_REPORT_TITLEFormula
        RETURN VARCHAR2
    AS
        v_report_title        giis_reports.report_title%type; 
    BEGIN
        BEGIN
            SELECT report_title
              INTO v_report_title
              FROM giis_reports
             WHERE report_id = 'GICLR206LE';
        END;
        
        RETURN V_REPORT_TITLE; 
    END CF_REPORT_TITLEFormula;
        
        
    FUNCTION CF_PARAMDATEFormula (
        p_paid_date     NUMBER
    ) RETURN VARCHAR2
    AS
        v_param    varchar2(100);  
    BEGIN
        BEGIN
            SELECT DECODE(p_paid_date,1,'Transaction Date',2,'Posting Date')  
              INTO v_param
              FROM dual;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_param := NULL;
        END;
        
        RETURN('(Based on '||v_param||')'); 
    END CF_PARAMDATEFormula;
    
    
    FUNCTION CF_dateFormula(
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN VARCHAR2
    AS
        v_date		varchar2(100); 
    BEGIN
        begin
            select 'from '|| to_char(p_from_date,'fmMonth DD, YYYY')||
                    ' to '||to_char(p_to_date,'fmMonth DD, YYYY')
              into v_date
              from dual; 
        exception
            when no_data_found then
            v_date := null;
        end;
        return(v_date); 
    END CF_dateFormula;
    
    
    FUNCTION get_report_header(
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE    
    ) RETURN header_tab PIPELINED
    AS
        rep     header_type;
    BEGIN
        rep.cf_company          := CF_COMPANYFormula;
        rep.cf_com_address      := CF_COM_ADDRESSFormula;
        rep.cf_report_title     := CF_REPORT_TITLEFormula;
        rep.cf_paramdate        := CF_PARAMDATEFormula(p_paid_date);
        rep.cf_date             := CF_dateFormula(p_from_date, p_to_date);
        
        PIPE ROW(rep);        
    END get_report_header;   
        
    
    FUNCTION CF_BUSS_SOURCE_NAMEFormula (
        p_buss_source_type      GIIS_INTM_TYPE.INTM_TYPE%TYPE
    ) RETURN VARCHAR2
    AS
        V_SOURCE_TYPE_DESC          GIIS_INTM_TYPE.INTM_DESC%TYPE;
    BEGIN
        BEGIN
            SELECT INTM_DESC
              INTO V_SOURCE_TYPE_DESC
              FROM GIIS_INTM_TYPE
             WHERE INTM_TYPE = P_BUSS_SOURCE_TYPE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_SOURCE_TYPE_DESC  := 'REINSURER ';    
            WHEN OTHERS THEN
              V_SOURCE_TYPE_DESC  := NULL;
        END;
        
        RETURN V_SOURCE_TYPE_DESC;
    END CF_BUSS_SOURCE_NAMEFormula;
    
    
    FUNCTION CF_SOURCE_NAMEFormula(
        p_iss_type      VARCHAR2,
        p_buss_source   GIIS_REINSURER.RI_CD%TYPE
    ) RETURN VARCHAR2
    AS
        V_SOURCE_NAME         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    BEGIN
        IF p_iss_type = 'RI' THEN
            BEGIN
              SELECT RI_NAME
                INTO V_SOURCE_NAME
                FROM GIIS_REINSURER
               WHERE RI_CD = p_buss_source;
            EXCEPTION
              WHEN OTHERS THEN 
                V_SOURCE_NAME  := NULL;
            END;
        ELSE
            BEGIN
              SELECT INTM_NAME
                INTO V_SOURCE_NAME
                FROM GIIS_INTERMEDIARY
               WHERE INTM_NO = p_buss_source;
            EXCEPTION
              WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
            END;
        END IF;
        
        RETURN V_SOURCE_NAME;
    END CF_SOURCE_NAMEFormula;
    
    
    FUNCTION CF_ISS_NAMEFormula (
        p_iss_cd        GIIS_ISSOURCE.ISS_CD%TYPE
    ) RETURN VARCHAR2
    AS
        V_ISS_NAME     GIIS_ISSOURCE.ISS_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT ISS_NAME
              INTO V_ISS_NAME
              FROM GIIS_ISSOURCE
             WHERE ISS_CD = p_iss_cd;
        EXCEPTION
            WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
        END;
        
        RETURN V_ISS_NAME;
    END CF_ISS_NAMEFormula;
    
    
    FUNCTION CF_LINE_NAMEFormula (
        p_line_cd       GIIS_LINE.LINE_CD%TYPE
    ) RETURN VARCHAR2
    AS
        V_LINE_NAME        GIIS_LINE.LINE_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT LINE_NAME
              INTO V_LINE_NAME
              FROM GIIS_LINE
             WHERE LINE_CD = p_line_cd;
        EXCEPTION
            WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
        END;
        
        RETURN V_LINE_NAME;
    END CF_LINE_NAMEFormula;
    
    
    FUNCTION CF_SUBLINE_NAMEFormula(
        p_line_cd       GIIS_SUBLINE.LINE_CD%type,
        p_subline_cd    GIIS_SUBLINE.SUBLINE_CD%TYPE
    ) RETURN VARCHAR2
    AS
        V_SUBLINE_NAME      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT SUBLINE_NAME
              INTO V_SUBLINE_NAME
              FROM GIIS_SUBLINE
             WHERE SUBLINE_CD = p_subline_cd
               AND LINE_CD    = p_line_cd;
        EXCEPTION
            WHEN OTHERS THEN 
              V_SUBLINE_NAME  := NULL;
        END;
      
        RETURN V_SUBLINE_NAME;
    END CF_SUBLINE_NAMEFormula;
    
    
    FUNCTION CF_LABELFormula
        RETURN VARCHAR2
    AS
    BEGIN
        IF NVL(giisp.v('ORA2010_SW'), 'N') = 'Y' THEN
            return('Claim Number'||chr(10)||'Policy Number'||chr(10)||'Assured'||chr(10)||'Assignee/Enrollee');
        ELSE
            return(chr(10)||'Claim Number'||chr(10)||'Policy Number'||chr(10)||'Assured');
        END IF;
    END CF_LABELFormula;
    
    
    FUNCTION get_report_parent(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type    
    ) RETURN report_parent_tab PIPELINED
    AS
        rep     report_parent_type;
    BEGIN
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                  WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                    AND A.SESSION_ID = P_SESSION_ID 
                    AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                    AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0)
                  ORDER BY DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE), DECODE(A.ISS_CD,'RI','RI','DI'), 
                           A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR )
        LOOP
            rep.iss_type            := i.iss_type;
            rep.buss_source_type    := i.buss_source_type;
            rep.iss_cd              := i.iss_cd;
            rep.buss_source         := i.buss_source;
            rep.line_cd             := i.line_cd;
            rep.subline_cd          := i.subline_cd;
            rep.loss_year           := i.loss_year;
                
            rep.cf_buss_source_name     := CF_BUSS_SOURCE_NAMEFormula(i.buss_source_type);
            rep.cf_source_name          := CF_SOURCE_NAMEFormula(i.iss_type, i.buss_source);
            rep.cf_iss_name             := CF_ISS_NAMEFormula(i.iss_cd);
            rep.cf_line_name            := CF_LINE_NAMEFormula(i.line_cd);
            rep.cf_subline_name         := CF_SUBLINE_NAMEFormula(i.line_cd, i.subline_cd);
            rep.cf_label                := CF_LABELFormula;
            
            BEGIN
                SELECT DISTINCT 'X'
                  INTO rep.v_exist
                  FROM GICL_RES_BRDRX_EXTR A
                 WHERE A.SESSION_ID = P_SESSION_ID 
                   AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                   AND NVL(A.LOSSES_PAID,0) <> 0 ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   rep.v_exist := NULL;
            END;
            
            PIPE ROW(rep);
        END LOOP;
        
    END get_report_parent;
    
    
    FUNCTION CF_POLICYFormula (
        p_claim_id      gicl_claims.CLAIM_ID%type,
        p_policy_no     GICL_RES_BRDRX_EXTR.POLICY_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_policy		VARCHAR2(60);
        v_ref_pol_no    gipi_polbasic.ref_pol_no%type;
    BEGIN
        BEGIN

            SELECT b.ref_pol_no
              INTO v_ref_pol_no
              FROM gicl_claims a, 
                   gipi_polbasic b
             WHERE a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.pol_iss_cd = b.iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND b.endt_seq_no = 0
               AND a.claim_id = p_claim_id
               AND ref_pol_no IS NOT NULL;
                       
        EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_ref_pol_no := NULL; 
        END;

        IF v_ref_pol_no IS NOT NULL THEN
             v_policy := p_policy_no||'/'||CHR(10)||v_ref_pol_no;
        ELSE
             v_policy := p_policy_no;
        END IF;	 

        RETURN (v_policy);
    END CF_POLICYFormula;
    
    
    FUNCTION CF_ASSD_NAMEFormula(
        p_assd_no       GIIS_ASSURED.ASSD_NO%type
    ) RETURN VARCHAR2
    AS
        V_ASSD_NAME       GIIS_ASSURED.ASSD_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT ASSD_NAME
              INTO V_ASSD_NAME
              FROM GIIS_ASSURED
             WHERE ASSD_NO  = p_assd_no;
        EXCEPTION
            WHEN OTHERS THEN
              V_ASSD_NAME  := NULL;
        END;
        
        RETURN V_ASSD_NAME; 
    END CF_ASSD_NAMEFormula;
    
    
    FUNCTION CF_ASSIGNEEFormula(
        p_claim_id      GICL_MOTOR_CAR_DTL.CLAIM_ID%type,
        p_line_cd       GIIS_LINE.LINE_CD%type,
        p_item_no       GICL_MOTOR_CAR_DTL.ITEM_NO%type
    ) RETURN VARCHAR2
    AS
        V_ASSIGNEE GICL_MOTOR_CAR_DTL.ASSIGNEE%TYPE;
        V_LINE		 GIIS_LINE.MENU_LINE_CD%TYPE;
    BEGIN
        FOR I IN (SELECT MENU_LINE_CD 
                    FROM GIIS_LINE
                   WHERE LINE_CD = p_line_cd)
        LOOP
            V_LINE := I.MENU_LINE_CD;
        END LOOP;
    	
        --IF NVL(V_LINE, :LINE_CD1) = GIISP.V('LINE_CODE_MC') THEN comment out by Marlo 11082010 changed to:
        IF p_line_cd = GIISP.V('LINE_CODE_MC') OR V_LINE = 'MC' THEN
            BEGIN
                SELECT ASSIGNEE 
                  INTO V_ASSIGNEE
                  FROM GICL_MOTOR_CAR_DTL
                 WHERE CLAIM_ID = p_claim_id
                   AND ITEM_NO = p_item_no;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                  V_ASSIGNEE := NULL;
            END;
      
        --ELSIF NVL(V_LINE, :LINE_CD1) = GIISP.V('LINE_CODE_AC') THEN comment out by Marlo 11082010 changed to:
        ELSIF p_line_cd = GIISP.V('LINE_CODE_AC') OR V_LINE = 'AC' THEN
            BEGIN
                SELECT GROUPED_ITEM_TITLE 
                  INTO V_ASSIGNEE
                  FROM GICL_ACCIDENT_DTL
                 WHERE CLAIM_ID = p_claim_id
                   AND ITEM_NO = p_item_no;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                  V_ASSIGNEE := NULL;
            END;
      	  
        ELSE
            V_ASSIGNEE := NULL;
        END IF;
        
        RETURN V_ASSIGNEE;
    END CF_ASSIGNEEFormula;
    
    
    FUNCTION CF_ITEM_TITLEFormula(
        p_claim_id             GICL_CLAIMS.claim_id%TYPE,
        p_line_cd              GICL_CLAIMS.line_cd%TYPE,
        p_item_no              gicl_accident_dtl.item_no%TYPE,
        p_grouped_item_no      gicl_accident_dtl.grouped_item_no%TYPE
    ) RETURN VARCHAR2
    AS
        V_ITEM_TITLE        VARCHAR2(200);
    BEGIN
        v_item_title := get_gpa_item_title(p_claim_id, p_line_cd, p_item_no,NVL(p_grouped_item_no,0)); 
        RETURN V_ITEM_TITLE;
    END CF_ITEM_TITLEFormula;
    
    
    FUNCTION CF_LOSS_CAT_DESFormula(
        p_loss_cat_cd       GIIS_LOSS_CTGRY.LOSS_CAT_CD%type,
        p_line_cd           GIIS_LOSS_CTGRY.LINE_CD%type
    ) RETURN VARCHAR2
    AS
        V_LOSS_CAT_DES      GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE;
    BEGIN
        BEGIN
            SELECT LOSS_CAT_DES
              INTO V_LOSS_CAT_DES
              FROM GIIS_LOSS_CTGRY
             WHERE LOSS_CAT_CD  = p_loss_cat_cd
               AND LINE_CD = p_line_cd;
        EXCEPTION
            WHEN OTHERS THEN
              V_LOSS_CAT_DES  := NULL;
        END;
        RETURN V_LOSS_CAT_DES;
    END CF_LOSS_CAT_DESFormula;
    
    
    FUNCTION CF_INTM_RIFormula(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_item_no           gicl_res_brdrx_extr.ITEM_NO%type,
        p_peril_cd          gicl_res_brdrx_extr.PERIL_CD%type,
        p_intm_no           gicl_res_brdrx_extr.INTM_NO%type,
        p_intm_break        NUMBER        
    ) RETURN VARCHAR2
    AS
        v_pol_iss_cd     gicl_claims.pol_iss_cd%type; 
        v_intm_ri        VARCHAR2(1000);
    BEGIN
        BEGIN
            SELECT pol_iss_cd
              INTO v_pol_iss_cd 
              FROM gicl_claims
             WHERE claim_id = p_claim_id;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_pol_iss_cd := NULL; 
        END;
           
        IF v_pol_iss_cd = GIACP.V('RI_ISS_CD') THEN
             BEGIN 
               FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                           FROM gicl_claims a, giis_reinsurer b
                          WHERE a.ri_cd = b.ri_cd
                            AND a.claim_id = p_claim_id)
               LOOP
                 v_intm_ri := TO_CHAR(r.ri_cd)||CHR(10)||r.ri_name;
               END LOOP;
             END;
        ELSE            
            IF p_intm_break = 1 THEN
                BEGIN
                     FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name, 
                                      b.ref_intm_cd ref_intm_cd
                                 FROM gicl_res_brdrx_extr a, giis_intermediary b
                                WHERE a.intm_no = b.intm_no
                                  AND a.session_id = p_session_id 
                                  AND a.claim_id = p_claim_id
                                  AND a.item_no = p_item_no
                                  AND a.peril_cd = p_peril_cd
                                  AND a.intm_no = p_intm_no) 
                     LOOP
                       v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||CHR(10)||i.intm_name;
                     END LOOP;
                END;    
            ELSIF p_intm_break = 0 THEN
                BEGIN 
                     FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                                FROM gicl_intm_itmperil a, giis_intermediary b
                               WHERE a.intm_no = b.intm_no
                                 AND a.claim_id = p_claim_id
                                 AND a.item_no = p_item_no
                                 AND a.peril_cd = p_peril_cd) 
                     LOOP
                       v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||CHR(10)||m.intm_name||CHR(10)||v_intm_ri;
                     END LOOP;
                END; 
            END IF;
        END IF;
        
        RETURN(v_intm_ri);
    END CF_INTM_RIFormula;
    
    
    FUNCTION CF_DV_NO_LOSSFormula(
        p_claim_id          gicl_clm_res_hist.CLAIM_ID%type,
        p_clm_loss_id       gicl_clm_res_hist.CLM_LOSS_ID%type,
        p_item_no           giac_chk_disbursement.ITEM_NO%type,   
        p_iss_cd            VARCHAR2, 
        p_paid_losses       GICL_RES_BRDRX_EXTR.LOSSES_PAID%type,
        p_paid_date         NUMBER,
        p_from_date         DATE,
        p_to_date           DATE        
    ) RETURN VARCHAR2
    AS
        v_dv_no          varchar2(100);
        var_dv_no        varchar2(500);
        v_cancel_date    gicl_clm_res_hist.cancel_date%type; 
        v_loss           number; 
    BEGIN
        FOR a IN (SELECT SIGN(p_paid_losses) losses_paid
                    FROM dual)
        LOOP   
            v_loss := a.losses_paid;
            IF v_loss < 1 THEN  
               FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999')) ||' /'||e.check_no dv_no,
                                 TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                            FROM gicl_clm_res_hist a, 
                                 giac_disb_vouchers b, 
                                 giac_acctrans c, 
                                 giac_reversals d, 
                                 giac_chk_disbursement e
                           WHERE a.tran_id 			= b.gacc_tran_id
                             AND a.tran_id 			= d.gacc_tran_id
                             AND c.tran_id 			= d.reversing_tran_id 
                             AND b.gacc_tran_id     = e.gacc_tran_id
                             AND e.item_no 			= p_item_no
                             AND a.claim_id 		= p_claim_id
                             AND a.clm_loss_id      = p_clm_loss_id
                           GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                          HAVING SUM(NVL(a.losses_paid,0)) > 0)
               LOOP
                     v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
                     IF var_dv_no IS NULL THEN
                        var_dv_no := v_dv_no;
                     ELSE
                        var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                     END IF;
               END LOOP;
            ELSE --added by Edison 04.19.2012, to get the check_no of the DV if the claim is in RI branch
                IF p_iss_cd = 'RI' THEN
                    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999')) ||' /'||e.check_no dv_no
                                 FROM gicl_clm_res_hist a, 
                                      giac_disb_vouchers b,
                                      giac_inw_claim_payts c, 
                                      giac_acctrans d,
                                      giac_chk_disbursement e
                                WHERE a.tran_id = d.tran_id    
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.tran_id
                                  AND b.gacc_tran_id = e.gacc_tran_id
                                  AND e.item_no      = p_item_no
                                  AND a.claim_id 	 = p_claim_id 
                                  AND a.clm_loss_id  = p_clm_loss_id
                                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                                      BETWEEN p_from_date AND p_to_date
                                GROUP BY b.dv_pref, b.dv_no, e.check_no
                               HAVING SUM(NVL(a.losses_paid,0)) > 0)    
                    LOOP
                        v_dv_no := v2.dv_no;
                        IF var_dv_no IS NULL THEN
                            var_dv_no := v_dv_no;
                        ELSE
                            var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                        END IF;
                    END LOOP; 
                ELSE --end of added code 04.19.2012
                    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999')) ||' /'||e.check_no dv_no
                                 FROM gicl_clm_res_hist a, 
                                      giac_disb_vouchers b,
                                      giac_direct_claim_payts c, 
                                      giac_acctrans d,
                                      giac_chk_disbursement e
                                WHERE a.tran_id = d.tran_id    
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.tran_id
                                  AND b.gacc_tran_id = e.gacc_tran_id
                                  AND e.item_no      = p_item_no
                                  AND a.claim_id 	 = p_claim_id 
                                  AND a.clm_loss_id  = p_clm_loss_id
                                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                                      BETWEEN p_from_date AND p_to_date
                                GROUP BY b.dv_pref, b.dv_no, e.check_no
                               HAVING SUM(NVL(a.losses_paid,0)) > 0)    
                    LOOP
                        v_dv_no := v2.dv_no;
                        IF var_dv_no IS NULL THEN
                            var_dv_no := v_dv_no;
                        ELSE
                            var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                        END IF;
                    END LOOP;		
                END IF;
            END IF;
        END LOOP;
        
        RETURN (var_dv_no);
    END CF_DV_NO_LOSSFormula;
    
    
    FUNCTION CF_DV_NO_EXPENSEFormula(
        p_claim_id          gicl_clm_res_hist.CLAIM_ID%type,
        p_clm_loss_id       gicl_clm_res_hist.CLM_LOSS_ID%type,
        p_item_no           giac_chk_disbursement.ITEM_NO%type,   
        p_iss_cd            VARCHAR2,     
        p_paid_expenses     GICL_RES_BRDRX_EXTR.EXPENSES_PAID%type,
        p_paid_date         NUMBER,
        p_from_date         DATE,
        p_to_date           DATE   
    ) RETURN VARCHAR2
    AS
        v_dv_no          varchar2(100);
        var_dv_no        varchar2(500);
        v_cancel_date    gicl_clm_res_hist.cancel_date%type; 
        v_loss           number; 
    BEGIN
        FOR a IN (SELECT SIGN(p_paid_EXPENSES) losses_paid
                    FROM dual)
        LOOP   
            v_loss := a.losses_paid;
            IF v_loss < 1 THEN  
               FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999'))|| ' /'||e.check_no dv_no,
                                 TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                            FROM gicl_clm_res_hist a, 
                                 giac_disb_vouchers b, 
                                 giac_acctrans c, 
                                 giac_reversals d,
                                 giac_chk_disbursement e
                           WHERE a.tran_id 			= b.gacc_tran_id
                             AND a.tran_id 			= d.gacc_tran_id
                             AND c.tran_id 			= d.reversing_tran_id 
                             AND b.gacc_tran_id     = e.gacc_tran_id
                             AND e.item_no 			= p_item_no
                             AND a.claim_id 		= p_claim_id
                             AND a.clm_loss_id 	    = p_clm_loss_id
                           GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                          HAVING SUM(NVL(a.expenses_paid,0)) > 0)
               LOOP
                 v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
                 IF var_dv_no IS NULL THEN
                    var_dv_no := v_dv_no;
                 ELSE
                    var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                 END IF;
               END LOOP;
            ELSE --added by Edison 04.19.2012, to get the check_no of the DV if the claim is in RI branch
                IF p_iss_cd = 'RI' THEN  	
                    FOR v2 IN (SELECT DISTINCT b.dv_pref|| '-' || LTRIM (TO_CHAR (b.dv_no, '0999999999')) || ' /' || e.check_no dv_no
                                 FROM gicl_clm_res_hist a,
                                      giac_disb_vouchers b,
                                      giac_inw_claim_payts c,
                                      giac_acctrans d,
                                      giac_chk_disbursement e
                                WHERE a.tran_id = d.tran_id
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.tran_id 
                                  AND b.gacc_tran_id = e.gacc_tran_id 
                                  AND e.item_no      = p_item_no
                                  AND a.claim_id     = p_claim_id
                                  AND a.clm_loss_id  = p_clm_loss_id
                                  AND DECODE (p_paid_date, 1, TRUNC (a.date_paid), 2, TRUNC (d.posting_date) ) 
                                      BETWEEN p_from_date AND p_to_date
                                GROUP BY b.dv_pref, b.dv_no, e.check_no
                               HAVING SUM (NVL (a.expenses_paid, 0)) > 0)    
                    LOOP
                        v_dv_no := v2.dv_no;
                        IF var_dv_no IS NULL THEN
                            var_dv_no := v_dv_no;
                        ELSE
                            var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                        END IF;
                    END LOOP;  
                ELSE --end of added code 04.19.2012
                    FOR v2 IN (SELECT DISTINCT b.dv_pref|| '-' || LTRIM (TO_CHAR (b.dv_no, '0999999999')) || ' /' || e.check_no dv_no
                                 FROM gicl_clm_res_hist a,
                                      giac_disb_vouchers b,
                                      giac_direct_claim_payts c,
                                      giac_acctrans d,
                                      giac_chk_disbursement e
                                WHERE a.tran_id = d.tran_id
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.tran_id 
                                  AND b.gacc_tran_id = e.gacc_tran_id 
                                  AND e.item_no      = p_item_no
                                  AND a.claim_id     = p_claim_id
                                  AND a.clm_loss_id  = p_clm_loss_id
                                  AND DECODE (p_paid_date, 1, TRUNC (a.date_paid), 2, TRUNC (d.posting_date) ) 
                                      BETWEEN p_from_date AND p_to_date
                                GROUP BY b.dv_pref, b.dv_no, e.check_no
                               HAVING SUM (NVL (a.expenses_paid, 0)) > 0)    
                    LOOP
                        v_dv_no := v2.dv_no;
                        IF var_dv_no IS NULL THEN
                            var_dv_no := v_dv_no;
                        ELSE
                            var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                        END IF;
                    END LOOP;  
                END IF;
            END IF;
        END LOOP;
        
        RETURN (var_dv_no);
  
    END CF_DV_NO_EXPENSEFormula;
    
    
    FUNCTION CF_LOSSESFormula (
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type
    ) RETURN NUMBER
    AS
        v_losses_paid NUMBER(38,2) := 0;
    BEGIN
        FOR i IN (SELECT NVL(A.LOSSES_PAID,0) PAID_LOSSES
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = P_CLAIM_ID
                     AND NVL(A.LOSSES_PAID,0) <> 0
                   ORDER BY A.CLAIM_NO)
	    LOOP
		    v_losses_paid := v_losses_paid + i.paid_losses;
	    END LOOP;
	    
        return(v_losses_paid);
        
    END CF_LOSSESFormula;
    
    
    FUNCTION CF_EXPENSESFormula (
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type
    ) RETURN NUMBER
    AS
        v_expenses_paid NUMBER(38,2) := 0;
    BEGIN
        FOR i IN (SELECT NVL(A.EXPENSES_PAID,0) PAID_EXPENSES
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = P_CLAIM_ID
                     AND NVL(A.EXPENSES_PAID,0) <> 0
                   ORDER BY A.CLAIM_NO)
        LOOP
            v_expenses_paid := v_expenses_paid + i.paid_expenses;
        END LOOP;
        
        return(v_expenses_paid);
        
    END CF_EXPENSESFormula;
     
     
    FUNCTION get_report_details(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE,
        p_intm_break    NUMBER,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                  WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                    AND A.SESSION_ID = P_SESSION_ID 
                    AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                    AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0)
                    AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                    AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                    AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                    AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD)
                    AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                  ORDER BY DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE), DECODE(A.ISS_CD,'RI','RI','DI'), 
                           A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR )
        LOOP
            rep.iss_type                := i.iss_type;
            rep.buss_source_type        := i.buss_source_type;
            rep.buss_source             := i.buss_source;
            rep.iss_cd                  := i.iss_cd;
            rep.line_cd                 := i.line_cd;
            rep.subline_cd              := i.subline_cd;
            rep.loss_year               := i.loss_year;
            
            FOR h IN (SELECT A.BRDRX_RECORD_ID, A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_ID, A.ASSD_NO,
                             A.CLAIM_NO, A.POLICY_NO, A.INCEPT_DATE, A.EXPIRY_DATE,
                             A.LOSS_DATE, A.CLM_FILE_DATE, A.ITEM_NO, A.GROUPED_ITEM_NO, 
                             A.PERIL_CD, A.LOSS_CAT_CD, A.TSI_AMT, A.INTM_NO,
                             A.CLM_LOSS_ID, NVL(A.LOSSES_PAID,0) PAID_LOSSES, NVL(A.EXPENSES_PAID,0) PAID_EXPENSES
                        FROM GICL_RES_BRDRX_EXTR A
                       WHERE A.SESSION_ID = P_SESSION_ID 
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID, A.CLAIM_ID)
                         AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 ) 
                         AND A.BUSS_SOURCE = i.BUSS_SOURCE
                         AND A.ISS_CD = i.ISS_CD
                         AND A.LINE_CD = i.LINE_CD
                         AND A.SUBLINE_CD = i.SUBLINE_CD
                         AND A.LOSS_YEAR = i.LOSS_YEAR
                       ORDER BY/* A.CLAIM_NO*/  
                               A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_NO)
            LOOP
                rep.brdrx_record_id         := h.brdrx_record_id;
                rep.claim_id                := h.claim_id;
                rep.assd_no                 := h.assd_no;
                rep.claim_no                := h.claim_no;
                rep.policy_no               := h.policy_no;
                rep.incept_date             := TO_CHAR(h.incept_date, 'MM-DD-RRRR');
                rep.expiry_date             := TO_CHAR(h.expiry_date, 'MM-DD-RRRR');
                rep.loss_date               := TO_CHAR(h.loss_date, 'MM-DD-RRRR');
                rep.clm_file_date           := TO_CHAR(h.clm_file_date, 'MM-DD-RRRR');
                rep.item_no                 := h.item_no;
                rep.grouped_item_no         := h.grouped_item_no;
                rep.peril_cd                := h.peril_cd;
                rep.loss_cat_cd             := h.loss_cat_cd;
                rep.tsi_amt                 := h.tsi_amt;
                rep.intm_no                 := h.intm_no;
                rep.clm_loss_id             := h.clm_loss_id;
                rep.paid_losses             := h.paid_losses;
                rep.paid_expenses           := h.paid_expenses;
                    
                rep.cf_policy               := CF_POLICYFormula(h.claim_id, h.policy_no);
                rep.cf_assd_name            := CF_ASSD_NAMEFormula(h.assd_no);
                rep.cf_assignee             := CF_ASSIGNEEFormula(h.claim_id, h.line_cd, h.item_no);
                rep.cf_item_title           := CF_ITEM_TITLEFormula(h.claim_id, i.line_cd, h.item_no, h.grouped_item_no);
                rep.cf_loss_cat_des         := CF_LOSS_CAT_DESFormula(h.loss_cat_cd, h.line_cd);
                rep.cf_intm_ri              := CF_INTM_RIFormula(p_session_id, h.claim_id, h.item_no, h.peril_cd, h.intm_no, p_intm_break);
                rep.cf_dv_no_loss           := CF_DV_NO_LOSSFormula(h.claim_id, h.clm_loss_id, h.item_no, h.iss_cd, 
                                                                    h.paid_losses, p_paid_date, p_from_date, p_to_date);
                rep.cf_dv_no_expense        := CF_DV_NO_EXPENSEFormula(h.claim_id, h.clm_loss_id, h.item_no, h.iss_cd, 
                                                                       h.paid_expenses, p_paid_date, p_from_date, p_to_date);
                --rep.cf_losses               := CF_LOSSESFormula(p_session_id, h.claim_id);
                --rep.cf_expenses             := CF_EXPENSESFormula(p_session_id, h.claim_id);
                                                                       
                PIPE ROW(rep);
            END LOOP;
            
        END LOOP;
        
    END get_report_details;
    
    
     FUNCTION CF_TREATY_NAMEFormula (
        p_grp_seq_no    GIIS_DIST_SHARE.SHARE_CD%type,
        p_line_cd       GIIS_DIST_SHARE.LINE_CD%type
    ) RETURN VARCHAR2
    AS
        V_TRTY_NAME     GIIS_DIST_SHARE.TRTY_NAME%TYPE;
    BEGIN 
        BEGIN
            SELECT TRTY_NAME
              INTO V_TRTY_NAME
              FROM GIIS_DIST_SHARE
             WHERE SHARE_CD = p_grp_seq_no
               AND LINE_CD = p_line_cd;
        EXCEPTION
            WHEN OTHERS THEN
              V_TRTY_NAME  := NULL;
        END;
        
        RETURN V_TRTY_NAME;
    END CF_TREATY_NAMEFormula;
    
    
    FUNCTION get_treaty_header(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type
    ) RETURN treaty_header_tab PIPELINED
    AS
        rep     treaty_header_type;
    BEGIN
        FOR i IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY A.GRP_SEQ_NO, A.LINE_CD )
        LOOP
            rep.iss_cd      := i.iss_cd;
            rep.buss_source := i.buss_source;
            rep.line_cd     := i.line_cd;
            rep.subline_cd  := i.subline_cd;
            rep.loss_year   := i.loss_year;
            rep.grp_seq_no  := i.grp_seq_no;
            rep.treaty_name := CF_TREATY_NAMEFormula(i.grp_seq_no, i.line_cd);
            
            PIPE ROW(rep);
        END LOOP;
        
    END get_treaty_header;
    
    
    FUNCTION get_treaty_details(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type
    ) RETURN treaty_details_tab PIPELINED
    AS
        rep     treaty_details_type;
    BEGIN
        FOR d IN (SELECT DISTINCT ISS_CD, BUSS_SOURCE, LINE_CD,
                         SUBLINE_CD, LOSS_YEAR, GRP_SEQ_NO
                    FROM TABLE(GICLR206LE_PKG.GET_TREATY_HEADER(P_SESSION_ID, P_CLAIM_ID, P_BUSS_SOURCE, P_ISS_CD, P_LINE_CD, P_SUBLINE_CD, P_LOSS_YEAR) )
                   WHERE GRP_SEQ_NO NOT IN (SELECT DISTINCT GRP_SEQ_NO
                                                FROM (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                                                              A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                                                        FROM GICL_RES_BRDRX_DS_EXTR A
                                                       WHERE A.SESSION_ID = P_SESSION_ID
                                                         AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 )
                                                         AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                                                         AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                                                         AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                                                         AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                                                         AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR) 
                                                       MINUS
                                                       SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                                                              A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                                                        FROM GICL_RES_BRDRX_DS_EXTR A
                                                       WHERE A.SESSION_ID = P_SESSION_ID
                                                         AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 )
                                                         AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                                                         AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                                                         AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                                                         AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                                                         AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR) 
                                                         AND A.BRDRX_RECORD_ID <> P_BRDRX_RECORD_ID  ) )
                   ORDER BY GRP_SEQ_NO)
        LOOP
            rep.buss_source     := d.buss_source;
            rep.iss_cd          := d.iss_cd;
            rep.line_cd         := d.line_cd;
            rep.subline_cd      := d.subline_cd;
            rep.loss_year       := d.loss_year;
            rep.grp_seq_no      := d.grp_seq_no;
            rep.treaty_name     := CF_TREATY_NAMEFormula(d.grp_seq_no, d.line_cd);
                
            PIPE ROW(rep);
        END LOOP;
    
    
        FOR i IN (SELECT A.BRDRX_RECORD_ID, A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_ID
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID, A.CLAIM_ID)
                     AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 ) 
                     AND A.BRDRX_RECORD_ID = NVL(p_brdrx_record_id, A.BRDRX_RECORD_ID)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY/* A.CLAIM_NO*/  
                           A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR)
        LOOP
            rep.claim_id        := i.claim_id;
            rep.buss_source     := i.buss_source;
            rep.iss_cd          := i.iss_cd;
            rep.line_cd         := i.line_cd;
            rep.subline_cd      := i.subline_cd;
            rep.loss_year       := i.loss_year;
            
            
            FOR h IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                        FROM GICL_RES_BRDRX_DS_EXTR A
                       WHERE A.SESSION_ID = P_SESSION_ID
                         --AND A.CLAIM_ID = i.CLAIM_ID
                         AND A.BUSS_SOURCE = i.BUSS_SOURCE
                         AND A.ISS_CD = i.ISS_CD
                         AND A.LINE_CD = i.LINE_CD
                         AND A.SUBLINE_CD =i.SUBLINE_CD
                         AND A.LOSS_YEAR = i.LOSS_YEAR
                       ORDER BY A.GRP_SEQ_NO)
            LOOP
                rep.grp_seq_no      := h.grp_seq_no;
                rep.treaty_name     := CF_TREATY_NAMEFormula(h.grp_seq_no, h.line_cd);
                      
                FOR j IN (SELECT A.BRDRX_RECORD_ID, A.BRDRX_DS_RECORD_ID, A.GRP_SEQ_NO, A.SHR_PCT,
                                 NVL(A.LOSSES_PAID,0) PAID_LOSSES, NVL(A.EXPENSES_PAID,0) PAID_EXPENSES
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.SESSION_ID = P_SESSION_ID
                             AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 )
                             AND A.GRP_SEQ_NO = h.GRP_SEQ_NO
                             AND A.BRDRX_RECORD_ID = i.BRDRX_RECORD_ID
                           ORDER BY A.GRP_SEQ_NO )
                LOOP
                    rep.brdrx_record_id     := j.brdrx_record_id;
                    rep.brdrx_ds_record_id  := j.brdrx_ds_record_id;
                    rep.shr_pct             := j.shr_pct;
                    rep.paid_losses         := j.paid_losses;
                    rep.paid_expenses       := j.paid_expenses;
                    rep.print_flg           := 'Y';
                    
                    PIPE ROW(rep);
                END LOOP;
            END LOOP;
        END LOOP;
        
    END get_treaty_details;
    
    
    FUNCTION CF_FACUL_RI_NAMEFormula (
        p_ri_cd     GIIS_REINSURER.RI_CD%type
    ) RETURN VARCHAR2
    AS
        V_RI_NAME        GIIS_REINSURER.RI_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT RI_SNAME
              INTO V_RI_NAME
              FROM GIIS_REINSURER
             WHERE RI_CD   = P_RI_CD;
        EXCEPTION
            WHEN OTHERS THEN   
              V_RI_NAME  := NULL;
        END;
        
        RETURN V_RI_NAME;
    END CF_FACUL_RI_NAMEFormula;
    
    
    FUNCTION get_treaty_facul(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,        
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type        
    ) RETURN treaty_details_tab PIPELINED
    AS
        rep     treaty_details_type;
    BEGIN
        
        FOR d IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     --AND A.CLAIM_ID = i.CLAIM_ID
                    AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                    AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                    AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                    AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                    AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                  ORDER BY A.GRP_SEQ_NO)
        LOOP
            rep.buss_source     := d.buss_source;
            rep.iss_cd          := d.iss_cd;
            rep.line_cd         := d.line_cd;
            rep.subline_cd      := d.subline_cd;
            rep.loss_year       := d.loss_year;
            rep.grp_seq_no      := d.grp_seq_no;
            rep.treaty_name     := CF_TREATY_NAMEFormula(d.grp_seq_no, d.line_cd);
                
            PIPE ROW(rep);
        END LOOP;
    
    
        FOR i IN (SELECT A.BRDRX_RECORD_ID, A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_ID
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID, A.CLAIM_ID)
                     AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 ) 
                     AND A.BRDRX_RECORD_ID = NVL(p_brdrx_record_id, A.BRDRX_RECORD_ID)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY/* A.CLAIM_NO*/  
                           A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR)
        LOOP
            rep.claim_id        := i.claim_id;
            rep.buss_source     := i.buss_source;
            rep.iss_cd          := i.iss_cd;
            rep.line_cd         := i.line_cd;
            rep.subline_cd      := i.subline_cd;
            rep.loss_year       := i.loss_year;
            
            
            FOR h IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                        FROM GICL_RES_BRDRX_DS_EXTR A
                       WHERE A.SESSION_ID = P_SESSION_ID
                         --AND A.CLAIM_ID = i.CLAIM_ID
                         AND A.BUSS_SOURCE = i.BUSS_SOURCE
                         AND A.ISS_CD = i.ISS_CD
                         AND A.LINE_CD = i.LINE_CD
                         AND A.SUBLINE_CD =i.SUBLINE_CD
                         AND A.LOSS_YEAR = i.LOSS_YEAR
                       ORDER BY A.GRP_SEQ_NO)
            LOOP
                rep.grp_seq_no      := h.grp_seq_no;
                rep.treaty_name     := CF_TREATY_NAMEFormula(h.grp_seq_no, h.line_cd);
                                
                FOR j IN (SELECT A.BRDRX_RECORD_ID, A.BRDRX_DS_RECORD_ID, A.GRP_SEQ_NO, A.SHR_PCT,
                                 NVL(A.LOSSES_PAID,0) PAID_LOSSES, NVL(A.EXPENSES_PAID,0) PAID_EXPENSES
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.SESSION_ID = P_SESSION_ID
                             AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0 )
                             AND A.GRP_SEQ_NO = h.GRP_SEQ_NO
                             AND A.BRDRX_RECORD_ID = i.BRDRX_RECORD_ID
                           ORDER BY A.GRP_SEQ_NO )
                LOOP
                    rep.brdrx_record_id     := j.brdrx_record_id;
                    rep.brdrx_ds_record_id  := j.brdrx_ds_record_id;
                    rep.shr_pct             := j.shr_pct;
                    rep.paid_losses         := j.paid_losses;
                    rep.paid_expenses       := j.paid_expenses;
                    
                    FOR k in (SELECT A.BRDRX_DS_RECORD_ID,
                                     DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) FACUL_RI_CD,
                                     SUM(A.SHR_RI_PCT) FACUL_SHR_RI_PCT,
                                     SUM(NVL(A.LOSSES_PAID,0)) PAID_LOSSES2,
                                     SUM(NVL(A.EXPENSES_PAID,0)) PAID_EXPENSES2
                                FROM GICL_RES_BRDRX_RIDS_EXTR A
                               WHERE A.GRP_SEQ_NO = 999 
                                 AND A.SESSION_ID = P_SESSION_ID
                                 AND A.BRDRX_DS_RECORD_ID = j.brdrx_ds_record_id
                               GROUP BY A.BRDRX_DS_RECORD_ID,
                                      DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD) )
                    LOOP
                        rep.facul_ri_cd             := k.facul_ri_cd;
                        rep.facul_ri_name           := CF_FACUL_RI_NAMEFormula(k.facul_ri_cd);
                        rep.facul_shr_ri_pct        := k.facul_shr_ri_pct;
                        rep.facul_paid_losses2      := k.paid_losses2;
                        rep.facul_paid_expenses2    := k.paid_expenses2;
                        
                        PIPE ROW(rep);
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END get_treaty_facul;
    
    
    FUNCTION CF_RI_SHRFormula(
        p_line_cd           giis_trty_panel.LINE_CD%TYPE,
        p_grp_seq_no        giis_trty_panel.TRTY_SEQ_NO%TYPE,
        p_ri_cd             giis_trty_panel.RI_CD%TYPE
    ) RETURN NUMBER
    AS
        v_shr_pct     giis_trty_panel.trty_shr_pct%type;
    BEGIN
        FOR shr IN (SELECT trty_shr_pct
                     FROM giis_trty_panel
                    WHERE line_cd = p_line_cd
                      AND trty_seq_no = p_grp_seq_no
                      AND ri_cd = p_ri_cd)
        LOOP
            v_shr_pct := shr.trty_shr_pct;
        END LOOP;
        
        RETURN (v_shr_pct); 
    END CF_RI_SHRFormula;
    
    
    FUNCTION get_treaty_ri(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type
    ) RETURN treaty_ri_tab PIPELINED
    AS
        rep     treaty_ri_type;
    BEGIN
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE), DECODE(A.ISS_CD,'RI','RI','DI'), 
                            A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR )
        LOOP
            rep.iss_type            := i.iss_type;
            rep.buss_source_type    := i.buss_source_type;
            rep.iss_cd              := i.iss_cd;
            rep.buss_source         := i.buss_source;
            rep.line_cd             := i.line_cd;
            rep.subline_cd          := i.subline_cd;
            rep.loss_year           := i.loss_year;
            
            FOR j IN (SELECT DISTINCT /*A.BRDRX_RIDS_RECORD_ID,*/ A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO,
                             DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD,
                             A.RI_CD, A.SHR_RI_PCT, b.trty_shr_pct
                        FROM GICL_RES_BRDRX_RIDS_EXTR A,
                             GIIS_TRTY_PANEL b
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND a.line_cd = b.line_cd
                         AND a.grp_seq_no = b.trty_seq_no
                         AND a.ri_cd = b.ri_cd
                         AND (NVL(A.LOSSES_PAID,0) <> 0 OR  NVL(A.EXPENSES_PAID,0) <> 0)
                         AND a.BUSS_SOURCE = i.buss_source
                         AND a.ISS_CD = i.iss_cd
                         AND a.LINE_CD = i.line_cd
                         AND a.SUBLINE_CD = i.subline_cd
                         AND a.LOSS_YEAR = i.loss_year
                       ORDER BY A.GRP_SEQ_NO, A.RI_CD,
                             DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD))
            LOOP
                --rep.brdrx_rids_record_id    := j.brdrx_rids_record_id;
                rep.trty_ri_cd              := j.trty_ri_cd;
                rep.grp_seq_no              := j.grp_seq_no;
                rep.treaty_name             := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                rep.ri_cd                   := j.ri_cd;
                rep.ri_name                 := CF_FACUL_RI_NAMEFormula(j.ri_cd);
                rep.shr_ri_pct              := j.shr_ri_pct;
                rep.trty_shr_ri_pct         := CF_RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);    
            
                PIPE ROW(rep);
            END LOOP;
        END LOOP;
        
    END get_treaty_ri;
    
    
    FUNCTION get_treaty_ri_amt(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type,
        p_ri_cd         GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type
    ) RETURN treaty_ri_amt_tab PIPELINED
    AS
        rep     treaty_ri_amt_type;
    BEGIN
        FOR g IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.GRP_SEQ_NO NOT IN (1,999)
                     AND A.SESSION_ID = P_SESSION_ID
                     --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY A.GRP_SEQ_NO)
        LOOP
            rep.iss_cd              := g.iss_cd;
            rep.buss_source         := g.buss_source;
            rep.line_cd             := g.line_cd;
            rep.subline_cd          := g.subline_cd;
            rep.loss_year           := g.loss_year;    
            rep.grp_seq_no          := g.grp_seq_no;
            rep.treaty_name         := CF_TREATY_NAMEFormula(g.grp_seq_no, g.line_cd);
            
             FOR h IN (SELECT A.RI_CD
                        FROM GICL_RES_BRDRX_RIDS_EXTR A,
                             GIIS_TRTY_PANEL b
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND a.line_cd = b.line_cd
                         AND a.grp_seq_no = b.trty_seq_no
                         AND a.ri_cd = b.ri_cd
                         AND (NVL(A.LOSSES_PAID,0) <> 0 OR  NVL(A.EXPENSES_PAID,0) <> 0)
                         AND A.RI_CD = NVL(p_ri_cd, A.RI_CD)
                         AND a.BUSS_SOURCE = g.buss_source
                         AND a.ISS_CD = g.iss_cd
                         AND a.LINE_CD = g.line_cd
                         AND a.SUBLINE_CD = g.subline_cd
                         AND a.LOSS_YEAR = g.loss_year
                       ORDER BY A.GRP_SEQ_NO, A.RI_CD,
                             DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD))
            LOOP
                rep.ri_cd   := h.ri_cd;      
            
                PIPE ROW(rep);
            END LOOP;
        END LOOP;
        
        
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE), DECODE(A.ISS_CD,'RI','RI','DI'), 
                            A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR )
        LOOP
            rep.iss_type            := i.iss_type;
            rep.buss_source_type    := i.buss_source_type;
            rep.iss_cd              := i.iss_cd;
            rep.buss_source         := i.buss_source;
            rep.line_cd             := i.line_cd;
            rep.subline_cd          := i.subline_cd;
            rep.loss_year           := i.loss_year;
            
            FOR j IN (SELECT A.BRDRX_RIDS_RECORD_ID, A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO,
                             DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD,
                             A.RI_CD, A.SHR_RI_PCT, b.trty_shr_pct
                        FROM GICL_RES_BRDRX_RIDS_EXTR A,
                             GIIS_TRTY_PANEL b
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND a.line_cd = b.line_cd
                         AND a.grp_seq_no = b.trty_seq_no
                         AND a.ri_cd = b.ri_cd
                         AND (NVL(A.LOSSES_PAID,0) <> 0 OR  NVL(A.EXPENSES_PAID,0) <> 0)
                         AND A.RI_CD = NVL(p_ri_cd, A.RI_CD)
                         AND a.BUSS_SOURCE = i.buss_source
                         AND a.ISS_CD = i.iss_cd
                         AND a.LINE_CD = i.line_cd
                         AND a.SUBLINE_CD = i.subline_cd
                         AND a.LOSS_YEAR = i.loss_year
                       ORDER BY A.GRP_SEQ_NO, A.RI_CD,
                             DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD))
            LOOP
                rep.trty_ri_cd      := j.trty_ri_cd;
                rep.treaty_name     := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                rep.ri_cd           := j.ri_cd;
                rep.ri_name         := CF_FACUL_RI_NAMEFormula(j.ri_cd);
                rep.shr_ri_pct      := j.shr_ri_pct;
                rep.trty_shr_ri_pct := CF_RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);      
            
                FOR k IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                                 A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.GRP_SEQ_NO NOT IN (1,999)
                             AND A.SESSION_ID = P_SESSION_ID
                             AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                             AND A.ISS_CD = j.iss_cd
                             AND A.BUSS_SOURCE = j.buss_source
                             AND A.LINE_CD = j.line_cd
                             AND A.SUBLINE_CD = j.subline_cd
                             AND A.LOSS_YEAR = j.loss_year
                             AND A.GRP_SEQ_NO = j.grp_seq_no
                           ORDER BY A.GRP_SEQ_NO)
                LOOP
                    FOR l IN (SELECT A.BRDRX_RIDS_RECORD_ID, A.GRP_SEQ_NO,
                                     NVL(A.LOSSES_PAID,0) PAID_LOSSES3,
                                     NVL(A.EXPENSES_PAID,0) PAID_EXPENSES3
                                FROM GICL_RES_BRDRX_RIDS_EXTR A
                               WHERE A.GRP_SEQ_NO <> 999
                                 AND A.SESSION_ID = P_SESSION_ID
                                 AND A.BRDRX_RIDS_RECORD_ID = j.brdrx_rids_record_id
                                 AND A.GRP_SEQ_NO = j.grp_seq_no
                                 AND (NVL(A.LOSSES_PAID,0) <> 0 OR NVL(A.EXPENSES_PAID,0) <> 0))
                    LOOP
                        rep.brdrx_rids_record_id    := l.brdrx_rids_record_id;
                        rep.grp_seq_no              := l.grp_seq_no;
                        rep.ri_paid_losses3         := l.paid_losses3;
                        rep.ri_paid_expenses3       := l.paid_expenses3;    
                    
                        PIPE ROW(rep);
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END get_treaty_ri_amt;
    
    -- marco
    -- added functions below for matrix
    
   FUNCTION get_assignee(
      p_line_cd            gicl_res_brdrx_extr.line_cd%TYPE,
      p_menu_line_cd       gicl_res_brdrx_extr.line_cd%TYPE,
      p_line_cd_mc         gicl_res_brdrx_extr.line_cd%TYPE,
      p_line_cd_ac         gicl_res_brdrx_extr.line_cd%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_assignee           gicl_motor_car_dtl.assignee%TYPE;
   BEGIN
      IF p_line_cd = p_line_cd_mc OR p_menu_line_cd = 'MC' THEN
         BEGIN
            SELECT assignee 
              INTO v_assignee
              FROM gicl_motor_car_dtl
             WHERE claim_id = p_claim_id;
         EXCEPTION 
            WHEN OTHERS THEN 
               v_assignee := NULL;
         END;
      ELSIF p_line_cd = p_line_cd_ac OR p_menu_line_cd = 'AC' THEN
         BEGIN
            SELECT grouped_item_title 
              INTO v_assignee
              FROM gicl_accident_dtl
             WHERE claim_id = p_claim_id;
         EXCEPTION 
            WHEN OTHERS THEN
               v_assignee := NULL;
         END;
      ELSE
         v_assignee := NULL;
      END IF;
      
      RETURN v_assignee;
   END;
    
    FUNCTION get_giclr206le_main(
      p_paid_date          NUMBER,
      p_session_id         gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      p_amt                VARCHAR2,
      p_intm_break         NUMBER,
      p_iss_break          NUMBER,
      p_subline_break      NUMBER
   )
      RETURN giclr206le_main_tab PIPELINED
   IS
      v_row                giclr206le_main_type;
      v_treaty_tab         treaty_tab;
      v_index              NUMBER;
      v_id                 NUMBER;
      v_header_label       VARCHAR2(500);
   BEGIN
      IF NVL(giisp.v('ORA2010_SW'), 'N') = 'Y' THEN
         v_header_label := 'Claim Number'||chr(10)||'Policy Number'||chr(10)||'Assured'||chr(10)||'Assignee/Enrollee';
     ELSE
         v_header_label := chr(10)||'Claim Number'||chr(10)||'Policy Number'||chr(10)||'Assured';
     END IF;
   
      FOR i IN (SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year
                           FROM GICL_RES_BRDRX_EXTR a,
                                GIIS_INTERMEDIARY b
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND (NVL(a.losses_paid, 0) <> 0 OR NVL(a.expenses_paid, 0) <> 0)
                            AND a.buss_source IS NOT NULL
                          ORDER BY DECODE (a.iss_cd, 'RI', 'RI', b.intm_type), a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.loss_year)
      LOOP
         v_row := NULL;
         v_row.header_label := v_header_label;
         v_row.iss_type := i.iss_type;
         v_row.buss_source_type := i.buss_source_type;
         v_row.iss_cd := i.iss_cd;
         v_row.buss_source := i.buss_source;
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.loss_year := i.loss_year;
         
         BEGIN
            SELECT intm_desc
              INTO v_row.buss_source_name
              FROM giis_intm_type
             WHERE intm_type = i.buss_source_type;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_row.buss_source_name := 'REINSURER ';
            WHEN OTHERS THEN
               v_row.buss_source_name := NULL;
         END;

         IF i.iss_type = 'RI' THEN
            BEGIN
               SELECT ri_name
                 INTO v_row.source_name
                 FROM GIIS_REINSURER
                WHERE ri_cd = i.buss_source;
            EXCEPTION
               WHEN OTHERS THEN
                  v_row.source_name := NULL;
            END;
         ELSE
            BEGIN
               SELECT intm_name
                 INTO v_row.source_name
                 FROM GIIS_INTERMEDIARY
                WHERE intm_no = i.buss_source;
            EXCEPTION
               WHEN OTHERS THEN
                  v_row.source_name := NULL;
            END;
         END IF;

         BEGIN
            SELECT iss_name
              INTO v_row.iss_name
              FROM GIIS_ISSOURCE
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.iss_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_row.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.line_name := NULL;
         END;

         BEGIN
            SELECT subline_name
              INTO v_row.subline_name
              FROM giis_subline
             WHERE subline_cd = i.subline_cd
             AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_row.subline_name := NULL;
         END;
         
         v_id := 0;
         v_index := 0;
         v_treaty_tab := treaty_tab();
         FOR s IN(SELECT DISTINCT grp_seq_no, b.trty_name
                    FROM GICL_RES_BRDRX_DS_EXTR a,
                         GIIS_DIST_SHARE b
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL(p_claim_id, a.claim_id)
                     AND a.buss_source = i.buss_source
                     AND a.iss_cd = i.iss_cd
                     AND a.line_cd = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND a.loss_year = i.loss_year
                     AND a.line_cd = b.line_cd
                     AND a.grp_seq_no = b.share_cd
                     AND (NVL(a.losses_paid, 0) <> 0 OR NVL(a.expenses_paid, 0) <> 0)
                   ORDER BY A.grp_seq_no)
         LOOP
            v_index := v_index + 1;
            v_treaty_tab.EXTEND;
            v_treaty_tab(v_index).grp_seq_no := s.grp_seq_no;
            v_treaty_tab(v_index).trty_name := s.trty_name;
         END LOOP;
         
         v_index := 1;
         LOOP
            v_id := v_id + 1;
            v_row.dummy := v_id;
            v_row.treaty1 := NULL;
            v_row.treaty2 := NULL;
            v_row.treaty3 := NULL;
            v_row.treaty4 := NULL;
            v_row.grp_seq_no1 := NULL;
            v_row.grp_seq_no2 := NULL;
            v_row.grp_seq_no3 := NULL;
            v_row.grp_seq_no4 := NULL;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no1 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty1 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no2 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty2 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no3 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty3 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no4 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty4 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            PIPE ROW(v_row);
            
            EXIT WHEN v_index > v_treaty_tab.COUNT;
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_detail(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN giclr206le_detail_tab PIPELINED
   IS
      v_row                giclr206le_detail_type;
      v_line_cd_mc         GICL_RES_BRDRX_EXTR.line_cd%TYPE;
      v_line_cd_ac         GICL_RES_BRDRX_EXTR.line_cd%TYPE;
      v_menu_line_cd       GICL_RES_BRDRX_EXTR.line_cd%TYPE;
   BEGIN
      v_line_cd_mc := GIISP.v('LINE_CODE_MC');
      v_line_cd_ac := GIISP.v('LINE_CODE_AC');
      
      FOR i IN(SELECT menu_line_cd
                 FROM GIIS_LINE
                WHERE line_cd = p_line_cd)
      LOOP
         v_menu_line_cd := i.menu_line_cd;
         EXIT;
      END LOOP;
   
      FOR i IN(SELECT DISTINCT claim_id, claim_no, policy_no, ref_pol_no,
                      incept_date, expiry_date, loss_date, assd_no
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id 
                  AND a.claim_id = NVL(p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND (NVL(a.losses_paid, 0) <> 0 OR NVL(a.expenses_paid, 0) <> 0) 
                ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.policy_no := i.policy_no;
         v_row.ref_pol_no := i.ref_pol_no;
         v_row.incept_date := TO_CHAR(i.incept_date, 'mm-dd-yyyy');
         v_row.expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy');
         v_row.loss_date := TO_CHAR(i.loss_date, 'mm-dd-yyyy');
         v_row.assd_no := i.assd_no;
         v_row.assignee := GICLR206LE_PKG.get_assignee(p_line_cd, v_menu_line_cd, v_line_cd_mc, v_line_cd_ac, i.claim_id);
         
         BEGIN
            SELECT assd_name
              INTO v_row.assd_name
              FROM GIIS_ASSURED
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.assd_name := NULL;
         END;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE
   )
     RETURN giclr206le_item_tab PIPELINED
   IS
      v_row                giclr206le_item_type;
   BEGIN
      FOR i IN(SELECT DISTINCT policy_no, claim_id, claim_no, item_no, grouped_item_no, line_cd
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.claim_no = p_claim_no
                  AND (NVL(a.losses_paid, 0) <> 0 OR NVL(a.expenses_paid, 0) <> 0) 
                ORDER BY a.claim_no)
      LOOP
         v_row.policy_no := i.policy_no;
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.item_no := i.item_no;
         v_row.grouped_item_no := i.grouped_item_no;
         v_row.item_title :=  CPI.get_gpa_item_title(i.claim_id, i.line_cd, i.item_no, NVL(i.grouped_item_no, 0));
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_peril(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_grouped_item_no    GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE,
      p_intm_break         NUMBER,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE
   )
     RETURN giclr206le_peril_tab PIPELINED
   IS
      v_row                giclr206le_peril_type;
   BEGIN
      FOR i IN(SELECT a.tsi_amt, a.peril_cd, b.peril_name, a.intm_no,
                      SUM(NVL(c.losses_paid,0)) paid_losses,
			             SUM(NVL(c.expenses_paid,0)) paid_expenses
                         , a.brdrx_record_id --added by gab 03.21.2016 SR 21796
                 FROM GICL_RES_BRDRX_EXTR a,
                      GIIS_PERIL b, GICL_RES_BRDRX_DS_EXTR c
                WHERE a.session_id = p_session_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.claim_no = p_claim_no
                  AND a.item_no = p_item_no
                  AND (NVL(c.losses_paid, 0) <> 0 or NVL(c.expenses_paid, 0) <> 0)
                  AND a.line_cd = b.line_cd
                  AND a.peril_cd = b.peril_cd
                  AND a.session_id = c.session_id
                  AND a.brdrx_record_id = c.brdrx_record_id
                  GROUP BY a.tsi_amt, a.peril_cd, b.peril_name, a.intm_no
                     ,a.brdrx_record_id --added by gab 03.21.2016 SR 21796
                ORDER BY a.claim_no)
      LOOP
         v_row.tsi_amt := i.tsi_amt;
         v_row.peril_cd := i.peril_cd;
         v_row.peril_name := i.peril_name;
         v_row.intm_cedant := GICLR206E_PKG.intm_ri_formula(p_claim_id, p_session_id, p_item_no, i.peril_cd, i.intm_no, p_intm_break);
         v_row.loss_dv_no := GICLS202_PKG.get_voucher_check_no(p_claim_id, p_item_no, i.peril_cd, p_grouped_item_no, p_from_date, p_to_date, p_paid_date, 'L');
         v_row.expense_dv_no := GICLS202_PKG.get_voucher_check_no(p_claim_id, p_item_no, i.peril_cd, p_grouped_item_no, p_from_date, p_to_date, p_paid_date, 'E');
         v_row.paid_losses := i.paid_losses;
         v_row.paid_expenses := i.paid_expenses;
         v_row.brdx_id := i.brdrx_record_id; --added by gab 03.21.2016 SR 21796
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_treaty(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      p_loss_exp           VARCHAR2,
      p_brdrx_id    VARCHAR2 --added by gab 03.21.2016 SR 21796 
   )
     RETURN paid_losses_tab PIPELINED
   IS
      TYPE t_tab IS TABLE OF paid_losses_type INDEX BY PLS_INTEGER;
      v_row                paid_losses_type;
      v_tab                t_tab;
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_index              NUMBER := 0;
      v_paid_losses        GICL_RES_BRDRX_DS_EXTR.losses_paid%TYPE;
   BEGIN
      FOR i IN(SELECT grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR206LE_PKG.get_giclr206le_main(NULL, p_session_id, NULL, NULL, NULL, NULL, NULL))
                WHERE dummy = p_dummy
                  AND buss_source = p_buss_source
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND loss_year = p_loss_year)
      LOOP
         FOR c IN 1 .. 4
         LOOP
            IF c = 1 THEN
               v_grp_seq_no := i.grp_seq_no1;
            ELSIF c = 2 THEN
               v_grp_seq_no := i.grp_seq_no2;
            ELSIF c = 3 THEN
               v_grp_seq_no := i.grp_seq_no3;
            ELSIF c = 4 THEN
               v_grp_seq_no := i.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NULL THEN
               EXIT;
            END IF;
            
            v_index := 1;
            FOR d IN(SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.grp_seq_no, a.shr_pct,
                            NVL(a.losses_paid, 0) paid_losses,
                            NVL(a.expenses_paid, 0) paid_expenses
                       FROM GICL_RES_BRDRX_DS_EXTR a
                      WHERE a.session_id = p_session_id
                        AND (NVL(a.losses_paid, 0) <> 0 or NVL(a.expenses_paid, 0) <> 0)
                        AND a.buss_source = p_buss_source
                        AND a.iss_cd = p_iss_cd
                        AND a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.loss_year = p_loss_year
                        AND a.claim_id = p_claim_id
                        AND a.item_no = p_item_no
                        AND a.brdrx_record_id = p_brdrx_id --added by gab 03.21.2016 SR 21796
                        AND a.grp_seq_no = v_grp_seq_no
                        AND a.peril_cd = p_peril_cd)
            LOOP
               IF p_loss_exp = 'L' THEN
                  v_paid_losses := d.paid_losses;
               ELSIF p_loss_exp = 'E' THEN
                  v_paid_losses := d.paid_expenses;
               END IF;
            
               IF c = 1 THEN
                  v_tab(v_index).paid_losses1 := v_paid_losses;
               ELSIF c = 2 THEN
                  v_tab(v_index).paid_losses2 := v_paid_losses;
               ELSIF c = 3 THEN
                  v_tab(v_index).paid_losses3 := v_paid_losses;
               ELSIF c = 4 THEN
                  v_tab(v_index).paid_losses4 := v_paid_losses;
               END IF;
               v_tab(v_index).ds_record_id := d.brdrx_ds_record_id;
               v_index := v_index + 1;
            END LOOP;
         END LOOP;
      END LOOP;
      
      v_index := v_tab.FIRST;
      
      IF v_index IS NULL THEN
         v_row.paid_losses1 := 0.00;
         v_row.paid_losses2 := 0.00;
         v_row.paid_losses3 := 0.00;
         v_row.paid_losses4 := 0.00;
         PIPE ROW(v_row);
      END IF;
      
      WHILE v_index IS NOT NULL
      LOOP
         v_row := NULL;
         v_row.paid_losses1 := NVL(v_tab(v_index).paid_losses1, 0.00);
         v_row.paid_losses2 := NVL(v_tab(v_index).paid_losses2, 0.00);
         v_row.paid_losses3 := NVL(v_tab(v_index).paid_losses3, 0.00);
         v_row.paid_losses4 := NVL(v_tab(v_index).paid_losses4, 0.00);
         v_row.ds_record_id := v_tab(v_index).ds_record_id;
         PIPE ROW(v_row);
         v_index := v_tab.NEXT(v_index);
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_facul(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_RIDS_EXTR.brdrx_ds_record_id%TYPE,
      p_loss_exp           VARCHAR2
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
      v_ri_sname           GIIS_REINSURER.ri_sname%TYPE;
   BEGIN
      FOR i IN(SELECT grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR206LE_PKG.get_giclr206le_main(NULL, p_session_id, NULL, NULL, NULL, NULL, NULL))
                WHERE dummy = p_dummy
                  AND buss_source = p_buss_source
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND loss_year = p_loss_year)
      LOOP
         FOR f IN(SELECT a.brdrx_ds_record_id,
                         DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) facul_ri_cd,
                         SUM(a.shr_ri_pct) facul_shr_ri_pct,
                         SUM(NVL(DECODE(p_loss_exp, 'L', a.losses_paid, a.expenses_paid), 0)) paid_losses
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no IN (i.grp_seq_no1, i.grp_seq_no2, i.grp_seq_no3, i.grp_seq_no4)
                     AND NVL(DECODE(p_loss_exp, 'L', a.losses_paid, a.expenses_paid), 0) <> 0
                     AND a.grp_seq_no = 999
                     AND a.session_id = p_session_id
                     AND a.brdrx_ds_record_id = p_ds_record_id
                   GROUP BY a.brdrx_ds_record_id, DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
         LOOP
            v_row := NULL;
            
            FOR n IN(SELECT ri_sname
                       FROM GIIS_REINSURER
                      WHERE f.facul_ri_cd = ri_cd)
            LOOP
               v_ri_sname := n.ri_sname;
               EXIT;
            END LOOP;
            
            IF i.grp_seq_no1 = 999 THEN
               v_row.ri_name1 := v_ri_sname;
               v_row.paid_losses1 := f.paid_losses;
            ELSIF i.grp_seq_no2 = 999 THEN
               v_row.ri_name2 := v_ri_sname;
               v_row.paid_losses2 := f.paid_losses;
            ELSIF i.grp_seq_no3 = 999 THEN
               v_row.ri_name3 := v_ri_sname;
               v_row.paid_losses3 := f.paid_losses;
            ELSIF i.grp_seq_no4 = 999 THEN
               v_row.ri_name4 :=v_ri_sname;
               v_row.paid_losses4 := f.paid_losses;
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_treaty_total(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN treaty_total_tab PIPELINED
   IS
      v_row                treaty_total_type;
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_query              VARCHAR2(5000);
   BEGIN
      FOR i IN 1 .. 4
      LOOP
         IF i = 1 THEN
            v_grp_seq_no := p_grp_seq_no1;
         ELSIF i = 2 THEN
            v_grp_seq_no := p_grp_seq_no2;
         ELSIF i = 3 THEN
            v_grp_seq_no := p_grp_seq_no3;
         ELSIF i = 4 THEN
            v_grp_seq_no := p_grp_seq_no4;
         END IF;
      
         FOR s IN(SELECT SUM(NVL(a.losses_paid,0)) paid_losses,
                         SUM(NVL(a.expenses_paid,0)) paid_expenses
                    FROM GICL_RES_BRDRX_DS_EXTR a
                   WHERE a.session_id = p_session_id
                     AND (NVL(a.losses_paid, 0) <> 0 or NVL(a.expenses_paid, 0) <> 0) 
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.loss_year = p_loss_year
                     AND a.grp_seq_no = v_grp_seq_no)
         LOOP
            IF i = 1 THEN
               v_row.paid_losses1 := s.paid_losses;
               v_row.paid_expenses1 := s.paid_expenses;
            ELSIF i = 2 THEN
               v_row.paid_losses2 := s.paid_losses;
               v_row.paid_expenses2 := s.paid_expenses;
            ELSIF i = 3 THEN
               v_row.paid_losses3 := s.paid_losses;
               v_row.paid_expenses3 := s.paid_expenses;
            ELSIF i = 4 THEN
               v_row.paid_losses4 := s.paid_losses;
               v_row.paid_expenses4 := s.paid_expenses;
            END IF;
         END LOOP;
      END LOOP;
      
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_giclr206le_treaty_ri(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED
   IS
      v_row                treaty_ri_type2;
   BEGIN
      FOR i IN(SELECT a.brdrx_rids_record_id, a.iss_cd, a.buss_source, a.line_cd,
                      a.subline_cd, a.loss_year, a.grp_seq_no,
                      DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd,
                      a.ri_cd, a.shr_ri_pct, b.trty_shr_pct,
                      NVL(a.losses_paid, 0) paid_losses,
                      NVL(a.expenses_paid, 0) paid_expenses
                 FROM GICL_RES_BRDRX_RIDS_EXTR a,
                      GIIS_TRTY_PANEL b
                WHERE a.grp_seq_no <> 999
                  AND a.session_id = p_session_id
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.line_cd = b.line_cd
                  AND a.grp_seq_no = b.trty_seq_no
                  AND a.ri_cd = b.ri_cd
                  AND (NVL(a.losses_paid, 0) <> 0 or NVL(a.expenses_paid, 0) <> 0)
                ORDER BY a.grp_seq_no, DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         v_row.trty_shr_pct := i.trty_shr_pct;
         v_row.paid_losses := i.paid_losses;
         v_row.paid_expenses := i.paid_expenses;
         v_row.grp_seq_no := i.grp_seq_no;
         v_row.ri_cd := i.ri_cd;
         
         BEGIN
            SELECT trty_name
              INTO v_row.treaty_name
              FROM GIIS_DIST_SHARE
             WHERE share_cd = i.grp_seq_no
               AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.treaty_name := NULL;
         END;
         
         BEGIN
            SELECT ri_sname
              INTO v_row.ri_name
              FROM GIIS_REINSURER
             WHERE ri_cd = i.ri_cd ;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.ri_name := NULL;
         END;
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206le_totals(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN total_tab PIPELINED
   IS
      v_row                total_type;
   BEGIN
      /*FOR i IN(SELECT SUM(NVL(a.losses_paid, 0)) paid_losses, 
                      SUM(NVL(a.expenses_paid, 0)) paid_expenses*/  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
      FOR i IN(SELECT SUM(NVL(c.losses_paid, 0)) paid_losses, 
                      SUM(NVL(c.expenses_paid, 0)) paid_expenses                      
                 FROM GICL_RES_BRDRX_EXTR a,
                      GIIS_INTERMEDIARY b,
                      GICL_RES_BRDRX_DS_EXTR c --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                WHERE a.buss_source = b.intm_no(+)
                  AND a.session_id = p_session_id
                  AND ((DECODE(a.iss_cd, 'RI', 'RI', b.intm_type) IS NULL)
                   OR (DECODE(a.iss_cd, 'RI', 'RI', b.intm_type) LIKE NVL(p_buss_source_type, '%')))
                  AND a.buss_source LIKE NVL(p_buss_source, '%')
                  AND a.iss_cd LIKE NVL(p_iss_cd, '%')
                  AND a.line_cd LIKE NVL(p_line_cd, '%')
                  AND a.brdrx_record_id = c.brdrx_record_id --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                  AND a.session_id = c.session_id           --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.                       
                  AND (NVL(a.losses_paid, 0) <> 0 or NVL(a.expenses_paid, 0) <> 0))
      LOOP
         v_row.paid_losses := i.paid_losses;
         v_row.paid_expenses := i.paid_expenses;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
    
END GICLR206LE_PKG;
/


