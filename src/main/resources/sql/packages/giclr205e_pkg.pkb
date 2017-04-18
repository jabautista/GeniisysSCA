CREATE OR REPLACE PACKAGE BODY CPI.GICLR205E_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   04.17.2013
     ** Referenced By:  GICLR205E - OUTSTANDING BORDEREAUX (EXPENSES)
     **/
     
    FUNCTION CF_companyFormula
    RETURN VARCHAR2
    AS
         v_name		varchar2(50);
    BEGIN
        SELECT param_value_v
          INTO v_name
          FROM giac_parameters
         WHERE param_name = 'COMPANY_NAME';
       
        return(v_name);
        
    RETURN NULL; exception
        when NO_DATA_FOUND then
            return(null);
    END CF_companyFormula;
        
      
    FUNCTION CF_COM_ADDRESSFormula
        RETURN VARCHAR2
    AS
        v_add		giis_parameters.param_value_v%TYPE;  
    BEGIN
        SELECT param_value_v
          INTO v_add
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
        
        return(v_add);
        
    RETURN NULL; exception
        when NO_DATA_FOUND then
            return(null);     
    END CF_COM_ADDRESSFormula;
        
        
    FUNCTION CF_REPORT_NAMEFormula
        RETURN VARCHAR2
    AS
        V_REPORT_TITLE      VARCHAR2(50);     
    BEGIN
        BEGIN
            select report_title
              into v_report_title
              from giis_reports
             where report_id = 'GICLR205E';
        END;
        
        RETURN V_REPORT_TITLE;     
    END CF_REPORT_NAMEFormula;
        
        
    FUNCTION CF_PARAMDATEFormula(
        p_os_date   NUMBER
    ) RETURN VARCHAR2
    AS
        v_param    varchar2(100);     
    BEGIN
        BEGIN
            SELECT DECODE(p_os_date,1,'Loss Date',2,'Claim File Date',3,'Booking Month')  
              INTO v_param
              FROM dual;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_param := NULL;
        END;
        
        RETURN('(Based on '||v_param||')');       
    END CF_PARAMDATEFormula;
    
    
    FUNCTION CF_DATEFormula(
        p_date_option   NUMBER,
        p_from_date     DATE,
        p_to_date       DATE,
        p_as_of_date    DATE
    ) RETURN VARCHAR2
    AS
        v_date		varchar2(100);     
    BEGIN
        if p_date_option = 1 then
            begin
              select 'from '|| to_char(p_from_date,'fmMonth DD, YYYY')||
                     ' to '||to_char(p_to_date,'fmMonth DD, YYYY')
                into v_date
                from dual; 
            exception
              when no_data_found then
                v_date := null;
            end;
        elsif p_date_option = 2 then
            begin
              select 'as of '|| to_char(p_as_of_date,'fmMonth DD, YYYY')
                into v_date
                from dual; 
            exception
              when no_data_found then
                v_date := null;
            end;       
        end if;
        
        return(v_date);
    END CF_DATEFormula;
    
    
    FUNCTION get_report_header(
        p_date_option   NUMBER,
        p_from_date     DATE,
        p_to_date       DATE,
        p_as_of_date    DATE,
        p_os_date       NUMBER        
    ) RETURN header_tab PIPELINED
    AS
        rep     header_type;
    BEGIN
        rep.cf_company          := CF_COMPANYFormula;
        rep.cf_com_address      := CF_COM_ADDRESSFormula;
        rep.cf_report_title     := CF_REPORT_NAMEFormula;
        rep.cf_paramdate        := CF_PARAMDATEFormula(p_os_date);
        rep.cf_date             := CF_DATEFormula(p_date_option, p_from_date, p_to_date, p_as_of_date);
        
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
                         A.ISS_CD,A.BUSS_SOURCE, A.LINE_CD,A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                   ORDER BY 2, 1, 4, 3, 5, 6, 7)
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
            
            BEGIN
                SELECT DISTINCT 'X'
                  INTO rep.V_EXIST
                  FROM GICL_RES_BRDRX_EXTR A
                 WHERE A.SESSION_ID = P_SESSION_ID 
                   AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                   AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0;
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
    
    
    FUNCTION CF_PERIL_NAMEFormula(
        p_peril_cd      GIIS_PERIL.peril_cd%TYPE,
        p_line_cd       GIIS_PERIL.line_cd%type
    ) RETURN VARCHAR2
    AS
        V_PERIL_NAME           GIIS_PERIL.PERIL_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT PERIL_NAME
              INTO V_PERIL_NAME
              FROM GIIS_PERIL
             WHERE PERIL_CD    = P_PERIL_CD
               AND LINE_CD     = P_LINE_CD;
        EXCEPTION
            WHEN OTHERS THEN 
              V_PERIL_NAME  := NULL;
        END;
          
        RETURN V_PERIL_NAME;
    END CF_PERIL_NAMEFormula;
    
    
    FUNCTION CF_LOSS_CAT_DESFormula(
        p_loss_cat_cd       GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    ) RETURN VARCHAR2
    AS
        V_LOSS_CAT_DES      GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE;
    BEGIN
        BEGIN
            SELECT LOSS_CAT_DES
              INTO V_LOSS_CAT_DES
              FROM GIIS_LOSS_CTGRY
             WHERE LOSS_CAT_CD  = P_LOSS_CAT_CD;
        EXCEPTION
            WHEN OTHERS THEN
              V_LOSS_CAT_DES  := NULL;
        END;
          
        RETURN V_LOSS_CAT_DES;
    END CF_LOSS_CAT_DESFormula;
    
    
    FUNCTION CF_INTMFormula(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_item_no           gicl_res_brdrx_extr.ITEM_NO%type,
        p_peril_cd          gicl_res_brdrx_extr.PERIL_CD%type,
        p_intm_no           gicl_res_brdrx_extr.INTM_NO%type,
        p_intm_break        NUMBER    
    ) RETURN VARCHAR2
    AS
        v_intm           VARCHAR2(200);
    BEGIN
        IF p_intm_break = 1 THEN
            BEGIN
              FOR c IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                          FROM gicl_res_brdrx_extr a, giis_intermediary b
                         WHERE a.intm_no = b.intm_no
                           AND a.session_id = p_session_id 
                           AND a.claim_id = p_claim_id
                           AND a.item_no = p_item_no
                           AND a.peril_cd = p_peril_cd
                           AND a.intm_no = p_intm_no ) 
              LOOP
                v_intm := to_char(c.intm_no)||'/'||c.ref_intm_cd||CHR(10)|| c.intm_name;
              END LOOP;
            END;
        ELSIF p_intm_break = 0 THEN
            BEGIN 
              FOR i IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                          FROM gicl_intm_itmperil a, giis_intermediary b
                         WHERE a.intm_no = b.intm_no
                           AND a.claim_id = p_claim_id
                           AND a.item_no = p_item_no
                           AND a.peril_cd = p_peril_cd) 
              LOOP
                v_intm := to_char(i.intm_no)||'/'||i.ref_intm_cd||CHR(10)|| i.intm_name||CHR(10)|| v_intm;
              END LOOP;
            END; 
        END IF;
        
        RETURN (v_intm);
    END CF_INTMFormula;
    
    
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
    
    
    FUNCTION get_report_details(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
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
                         A.ISS_CD,A.BUSS_SOURCE, A.LINE_CD,A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD) 
                     AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY 2, 1, 4, 3, 5, 6, 7)
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
            
            FOR h IN (SELECT A.BRDRX_RECORD_ID, A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_ID, A.ASSD_NO,
                             A.CLAIM_NO, A.POLICY_NO, A.INCEPT_DATE, A.EXPIRY_DATE,
                             A.LOSS_DATE, A.CLM_FILE_DATE,  A.ITEM_NO, a.grouped_item_no, --EMCY da042506te
                             A.PERIL_CD, A.LOSS_CAT_CD, A.TSI_AMT, A.INTM_NO,
                             (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS
                        FROM GICL_RES_BRDRX_EXTR A
                       WHERE A.SESSION_ID = P_SESSION_ID 
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0  
                         AND A.BUSS_SOURCE = i.BUSS_SOURCE
                         AND A.ISS_CD = i.ISS_CD
                         AND A.LINE_CD = i.LINE_CD
                         AND A.SUBLINE_CD = i.SUBLINE_CD
                         AND A.LOSS_YEAR = i.LOSS_YEAR
                       ORDER BY A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_NO)
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
                rep.outstanding_loss        := h.outstanding_loss;
                
                rep.cf_policy               := CF_POLICYFormula(h.claim_id, h.policy_no);
                rep.cf_assd_name            := CF_ASSD_NAMEFormula(h.assd_no);
                rep.cf_item_title           := CF_ITEM_TITLEFormula(h.claim_id, h.line_cd, h.item_no, h.grouped_item_no);
                rep.cf_peril_name           := CF_PERIL_NAMEFormula(h.peril_cd, h.line_cd);
                rep.cf_loss_cat_des         := CF_LOSS_CAT_DESFormula(h.loss_cat_cd);
                rep.cf_intm                 := CF_INTMFormula(p_session_id, h.claim_id, h.item_no, h.peril_cd, h.intm_no, p_intm_break);
                rep.cf_intm_ri              := CF_INTM_RIFormula(p_session_id, h.claim_id, h.item_no, h.peril_cd, h.intm_no, p_intm_break);
                
                PIPE ROW(rep);
            END LOOP;
        END LOOP;
    END get_report_details;
    
    
    FUNCTION CF_TREATY_NAMEFormula(
        p_grp_seq_no        GIIS_DIST_SHARE.SHARE_CD%TYPE,
        p_line_cd           GIIS_DIST_SHARE.LINE_CD%TYPE
    ) RETURN VARCHAR2
    AS
        V_TRTY_NAME     GIIS_DIST_SHARE.TRTY_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT TRTY_NAME
              INTO V_TRTY_NAME
              FROM GIIS_DIST_SHARE
             WHERE SHARE_CD = P_GRP_SEQ_NO
               AND LINE_CD = P_LINE_CD;
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
                   ORDER BY A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO)
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
        FOR d IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
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
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                     AND A.BRDRX_RECORD_ID = P_BRDRX_RECORD_ID
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
        
        
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD,A.BUSS_SOURCE, A.LINE_CD,A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD) 
                     AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY 2, 1, 4, 3, 5, 6, 7)
        LOOP
            FOR h IN (SELECT A.BRDRX_RECORD_ID, A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_ID, A.ASSD_NO,
                             A.CLAIM_NO, A.POLICY_NO, A.INCEPT_DATE, A.EXPIRY_DATE,
                             A.LOSS_DATE, A.CLM_FILE_DATE,  A.ITEM_NO, a.grouped_item_no, --EMCY da042506te
                             A.PERIL_CD, A.LOSS_CAT_CD, A.TSI_AMT, A.INTM_NO,
                             (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS
                        FROM GICL_RES_BRDRX_EXTR A
                       WHERE A.SESSION_ID = P_SESSION_ID 
                         --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0 
                         AND A.BRDRX_RECORD_ID = NVL(p_brdrx_record_id, A.BRDRX_RECORD_ID) 
                         AND A.BUSS_SOURCE = i.BUSS_SOURCE
                         AND A.ISS_CD = i.ISS_CD
                         AND A.LINE_CD = i.LINE_CD
                         AND A.SUBLINE_CD = i.SUBLINE_CD
                         AND A.LOSS_YEAR = i.LOSS_YEAR
                       ORDER BY A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_NO)
            LOOP
                rep.claim_id        := h.claim_id;
                rep.buss_source     := h.buss_source;
                rep.iss_cd          := h.iss_cd;
                rep.line_cd         := h.line_cd;
                rep.subline_cd      := h.subline_cd;
                rep.loss_year       := h.loss_year;
                
                FOR j IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                                 A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.SESSION_ID = P_SESSION_ID
                             AND A.CLAIM_ID = h.CLAIM_ID 
                             AND A.BUSS_SOURCE = h.BUSS_SOURCE
                             AND A.ISS_CD = h.ISS_CD
                             AND A.LINE_CD = h.LINE_CD
                             AND A.SUBLINE_CD = h.SUBLINE_CD
                             AND A.LOSS_YEAR = h.LOSS_YEAR
                           ORDER BY A.GRP_SEQ_NO)
                LOOP
                    rep.grp_seq_no      := j.grp_seq_no;
                    rep.treaty_name     := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                
                    FOR k IN (SELECT A.BRDRX_RECORD_ID, A.BRDRX_DS_RECORD_ID, A.GRP_SEQ_NO, A.SHR_PCT,
                                     (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS2
                                FROM GICL_RES_BRDRX_DS_EXTR A
                               WHERE A.SESSION_ID = P_SESSION_ID
                                 AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                                 AND A.BRDRX_RECORD_ID = h.BRDRX_RECORD_ID
                                 AND A.GRP_SEQ_NO = j.GRP_SEQ_NO )
                    LOOP
                        rep.brdrx_record_id     := k.brdrx_record_id;
                        rep.brdrx_ds_record_id  := k.brdrx_ds_record_id;
                        rep.shr_pct             := k.shr_pct;
                        rep.outstanding_loss2   := k.outstanding_loss2;
                        rep.print_flg           := 'Y';
                            
                        PIPE ROW(rep);                        
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;    
    END get_treaty_details;
    
    
    FUNCTION CF_RI_NAMEFormula(
        p_ri_cd     GIIS_REINSURER.RI_CD%TYPE
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
    END CF_RI_NAMEFormula;
    
    
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
        FOR j IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                    AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                    AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                    AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                    AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                    AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO)
        LOOP
            rep.buss_source     := j.buss_source;
            rep.iss_cd          := j.iss_cd;
            rep.line_cd         := j.line_cd;
            rep.subline_cd      := j.subline_cd;
            rep.loss_year       := j.loss_year;
            rep.grp_seq_no      := j.grp_seq_no;
            rep.treaty_name     := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
            PIPE ROW(rep);        
        END LOOP;
        
        
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD,A.BUSS_SOURCE, A.LINE_CD,A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                     AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id), a.claim_id) 
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD) 
                     AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY 2, 1, 4, 3, 5, 6, 7)
        LOOP
            FOR h IN (SELECT A.BRDRX_RECORD_ID, A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD,
                             A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_ID, A.ASSD_NO,
                             A.CLAIM_NO, A.POLICY_NO, A.INCEPT_DATE, A.EXPIRY_DATE,
                             A.LOSS_DATE, A.CLM_FILE_DATE,  A.ITEM_NO, a.grouped_item_no, --EMCY da042506te
                             A.PERIL_CD, A.LOSS_CAT_CD, A.TSI_AMT, A.INTM_NO,
                             (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS
                        FROM GICL_RES_BRDRX_EXTR A
                       WHERE A.SESSION_ID = P_SESSION_ID 
                         --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                         AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0 
                         --AND A.BRDRX_RECORD_ID = NVL(p_brdrx_record_id, A.BRDRX_RECORD_ID)
                         AND a.brdrx_record_id = NVL(DECODE(p_brdrx_record_id, -1, a.brdrx_record_id, p_brdrx_record_id),a.brdrx_record_id) 
                         AND A.BUSS_SOURCE = i.BUSS_SOURCE
                         AND A.ISS_CD = i.ISS_CD
                         AND A.LINE_CD = i.LINE_CD
                         AND A.SUBLINE_CD = i.SUBLINE_CD
                         AND A.LOSS_YEAR = i.LOSS_YEAR
                       ORDER BY A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD, A.SUBLINE_CD, A.LOSS_YEAR, A.CLAIM_NO)
            LOOP
                rep.claim_id        := h.claim_id;
                rep.buss_source     := h.buss_source;
                rep.iss_cd          := h.iss_cd;
                rep.line_cd         := h.line_cd;
                rep.subline_cd      := h.subline_cd;
                rep.loss_year       := h.loss_year;
                
                FOR j IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                                 A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.SESSION_ID = P_SESSION_ID
                             AND A.CLAIM_ID = h.CLAIM_ID 
                             AND A.BUSS_SOURCE = h.BUSS_SOURCE
                             AND A.ISS_CD = h.ISS_CD
                             AND A.LINE_CD = h.LINE_CD
                             AND A.SUBLINE_CD = h.SUBLINE_CD
                             AND A.LOSS_YEAR = h.LOSS_YEAR
                           ORDER BY A.GRP_SEQ_NO)
                LOOP
                    rep.grp_seq_no      := j.grp_seq_no;
                    rep.treaty_name     := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                
                    FOR k IN (SELECT A.BRDRX_RECORD_ID, A.BRDRX_DS_RECORD_ID, A.GRP_SEQ_NO, A.SHR_PCT,
                                     (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS2
                                FROM GICL_RES_BRDRX_DS_EXTR A
                               WHERE A.SESSION_ID = P_SESSION_ID
                                 AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                                 AND A.BRDRX_RECORD_ID = h.BRDRX_RECORD_ID
                                 AND A.GRP_SEQ_NO = j.GRP_SEQ_NO )
                    LOOP
                        rep.brdrx_record_id     := k.brdrx_record_id;
                        rep.brdrx_ds_record_id  := k.brdrx_ds_record_id;
                        rep.shr_pct             := k.shr_pct;
                        rep.outstanding_loss2   := k.outstanding_loss2;
                        rep.print_flg           := 'Y';
                        PIPE ROW(rep);
                            
                        FOR l IN (SELECT A.BRDRX_DS_RECORD_ID,
                                         DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD) FACUL_RI_CD,
                                         SUM(A.SHR_RI_PCT) FACUL_SHR_RI_PCT,
                                         SUM(NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS3
                                    FROM GICL_RES_BRDRX_RIDS_EXTR A
                                   WHERE A.GRP_SEQ_NO = 999 
                                     AND A.SESSION_ID = P_SESSION_ID
                                     AND A.BRDRX_DS_RECORD_ID = k.BRDRX_DS_RECORD_ID
                                   GROUP BY A.BRDRX_DS_RECORD_ID,
                                            DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD))
                        LOOP
                            rep.facul_ri_cd             := l.facul_ri_cd;
                            rep.facul_ri_name           := CF_RI_NAMEFormula(l.facul_ri_cd);
                            rep.facul_shr_ri_pct        := l.facul_shr_ri_pct;
                            rep.facul_outstanding_loss3 := l.outstanding_loss3;
                        
                            PIPE ROW(rep);
                        END LOOP;                       
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;    
        
        RETURN;
    END get_treaty_facul;
    
    
    FUNCTION CF_SUM_RI_SHAREFormula(
        p_grp_seq_no    giis_trty_panel.TRTY_SEQ_NO%type,
        p_line_cd       giis_trty_panel.LINE_CD%type
    ) RETURN NUMBER
    AS
        v_shr_pct     number:=0;
    BEGIN
        FOR shr IN (SELECT sum(nvl(trty_shr_pct,0)) trty_shr_pct
                      FROM giis_trty_panel
                     WHERE line_cd = p_line_cd
                       AND trty_seq_no = p_grp_seq_no
                 /*AND ri_cd = :ri_cd*/)
        LOOP
            v_shr_pct := shr.trty_shr_pct;
            --srw.message(3,v_shr_pct);
        END LOOP;
        RETURN (nvl(v_shr_pct,0));   
    END CF_sum_ri_shareFormula;
    
    
    FUNCTION CF_ri_shrFormula(
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
    END CF_ri_shrFormula;
    
    
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
                         A.ISS_CD,A.BUSS_SOURCE, A.LINE_CD,A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD) 
                     AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY 2, 1, 4, 3, 5, 6, 7)
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
                             DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD,
                             A.RI_CD, A.SHR_RI_PCT
                        FROM GICL_RES_BRDRX_RIDS_EXTR A
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                         AND a.BUSS_SOURCE = i.buss_source
                         AND a.ISS_CD = i.iss_cd
                         AND a.LINE_CD = i.line_cd
                         AND a.SUBLINE_CD = i.subline_cd
                         AND a.LOSS_YEAR = i.loss_year
                       ORDER BY A.GRP_SEQ_NO,
                                DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD))
            LOOP
                rep.grp_seq_no              := j.grp_seq_no;
                rep.cf_treaty_name          := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                rep.trty_ri_cd              := j.trty_ri_cd;
                rep.cf_trty_ri_name         := CF_RI_NAMEFormula(j.trty_ri_cd);
                rep.ri_cd                   := j.ri_cd;
                rep.cf_ri_name              := CF_RI_NAMEFormula(j.ri_cd);
                rep.cf_ri_shr               := CF_RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);
                rep.shr_ri_pct              := j.shr_ri_pct;
                rep.cf_sum_ri_shr           := CF_SUM_RI_SHAREFormula(j.grp_seq_no, j.line_cd);
                rep.brdrx_rids_record_id    := j.brdrx_rids_record_id;                    
            
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
    ) RETURN treaty_ri_tab PIPELINED
    AS
        rep     treaty_ri_type;
    BEGIN
        FOR d IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                         A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.GRP_SEQ_NO NOT IN (1,999)
                     AND A.SESSION_ID = P_SESSION_ID
                     --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)                     
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(p_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(p_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(p_SUBLINE_CD, A.SUBLINE_CD)
                     AND A.LOSS_YEAR = NVL(p_LOSS_YEAR, A.LOSS_YEAR) )
        LOOP
            rep.iss_cd              := d.iss_cd;
            rep.buss_source         := d.buss_source;
            rep.line_cd             := d.line_cd;
            rep.subline_cd          := d.subline_cd;
            rep.loss_year           := d.loss_year;    
            rep.grp_seq_no          := d.grp_seq_no;
            rep.cf_treaty_name      := CF_TREATY_NAMEFormula(d.grp_seq_no, d.line_cd);
            
            FOR e IN (SELECT A.RI_CD
                        FROM GICL_RES_BRDRX_RIDS_EXTR A
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                         AND A.RI_CD = NVL(p_ri_cd, A.RI_CD)
                         AND a.BUSS_SOURCE = d.buss_source
                         AND a.ISS_CD = d.iss_cd
                         AND a.LINE_CD = d.line_cd
                         AND a.SUBLINE_CD = d.subline_cd
                         AND a.LOSS_YEAR = d.loss_year
                       ORDER BY A.GRP_SEQ_NO,
                                DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD) )
            LOOP
                rep.ri_cd   := e.ri_cd;
                
                PIPE ROW(rep);
            END LOOP;            
        END LOOP;
        
        
        FOR i IN (SELECT DISTINCT 
                         DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                         DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,                 
                         A.ISS_CD,A.BUSS_SOURCE, A.LINE_CD,A.SUBLINE_CD, A.LOSS_YEAR
                    FROM GICL_RES_BRDRX_EXTR A,
                         GIIS_INTERMEDIARY B
                   WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                     AND A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                     AND A.SUBLINE_CD = NVL(P_SUBLINE_CD, A.SUBLINE_CD) 
                     AND A.LOSS_YEAR = NVL(P_LOSS_YEAR, A.LOSS_YEAR)
                   ORDER BY 2, 1, 4, 3, 5, 6, 7)
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
                             DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD,
                             A.RI_CD, A.SHR_RI_PCT
                        FROM GICL_RES_BRDRX_RIDS_EXTR A
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                         AND A.RI_CD = NVL(p_ri_cd, A.RI_CD)
                         AND a.BUSS_SOURCE = i.buss_source
                         AND a.ISS_CD = i.iss_cd
                         AND a.LINE_CD = i.line_cd
                         AND a.SUBLINE_CD = i.subline_cd
                         AND a.LOSS_YEAR = i.loss_year
                       ORDER BY A.GRP_SEQ_NO,
                                DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD))
            LOOP
                rep.grp_seq_no              := j.grp_seq_no;
                rep.cf_treaty_name          := CF_TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                rep.trty_ri_cd              := j.trty_ri_cd;
                rep.cf_trty_ri_name         := CF_RI_NAMEFormula(j.trty_ri_cd);
                rep.ri_cd                   := j.ri_cd;
                rep.cf_ri_name              := CF_RI_NAMEFormula(j.ri_cd);
                rep.cf_ri_shr               := CF_RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);
                rep.shr_ri_pct              := j.shr_ri_pct;
                rep.cf_sum_ri_shr           := CF_SUM_RI_SHAREFormula(j.grp_seq_no, j.line_cd);
                rep.brdrx_rids_record_id    := j.brdrx_rids_record_id;                    
            
                FOR k IN (SELECT DISTINCT A.ISS_CD, A.BUSS_SOURCE, A.LINE_CD,
                                 A.SUBLINE_CD, A.LOSS_YEAR, A.GRP_SEQ_NO
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.GRP_SEQ_NO NOT IN (1,999)
                             AND A.SESSION_ID = P_SESSION_ID
                             AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                             AND a.BUSS_SOURCE = j.buss_source
                             AND a.ISS_CD = j.iss_cd
                             AND a.LINE_CD = j.line_cd
                             AND a.SUBLINE_CD = j.subline_cd
                             AND a.LOSS_YEAR = j.loss_year
                           ORDER BY A.GRP_SEQ_NO)
                LOOP
                    FOR l IN (SELECT A.BRDRX_RIDS_RECORD_ID, A.GRP_SEQ_NO,
                                     (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS4
                                FROM GICL_RES_BRDRX_RIDS_EXTR A
                               WHERE A.GRP_SEQ_NO <> 999
                                 AND A.SESSION_ID = P_SESSION_ID
                                 AND A.BRDRX_RIDS_RECORD_ID = j.BRDRX_RIDS_RECORD_ID
                                 AND A.GRP_SEQ_NO = k.GRP_SEQ_NO
                                 AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0)
                    LOOP
                        rep.ri_outstanding_loss4    := l.outstanding_loss4;
                        
                        PIPE ROW(rep);
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END get_treaty_ri_amt;
    
    
    FUNCTION get_trty_per_line(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type
    ) RETURN trty_tab PIPELINED
    AS
        rep     trty_type;
    BEGIN
        FOR i IN (SELECT A.LINE_CD, SUM((NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0))) OUTSTANDING_LOSS,
                         B.TRTY_NAME, A.ISS_CD, A.GRP_SEQ_NO, A.BUSS_SOURCE
                    FROM GICL_RES_BRDRX_DS_EXTR A, 
                         GIIS_DIST_SHARE B
                   WHERE (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.SESSION_ID = P_SESSION_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND A.LINE_CD=B.LINE_CD
                     AND A.GRP_SEQ_NO = B.SHARE_CD
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                     AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
                   GROUP BY A.LINE_CD, A.ISS_CD, B.TRTY_NAME, A.GRP_SEQ_NO,A.BUSS_SOURCE
                   ORDER BY A.BUSS_SOURCE, A.ISS_CD, A.LINE_CD, A.GRP_SEQ_NO)
        LOOP
            rep.line_cd             := i.line_cd;
            rep.iss_cd              := i.iss_cd;
            rep.buss_source         := i.buss_source;
            rep.outstanding_loss5   := i.outstanding_loss;
            rep.grp_seq_no          := i.grp_seq_no;
            rep.trty_name           := i.trty_name;   
            
            PIPE ROW(rep);
        END LOOP;
    END get_trty_per_line;
    
    
    FUNCTION get_trty_per_iss(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type
    ) RETURN trty_tab PIPELINED
    AS
        rep     trty_type;
    BEGIN
        FOR i IN (SELECT SUM((NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0))) OUTSTANDING_LOSS, 
                         B.TRTY_NAME, A.ISS_CD,A.GRP_SEQ_NO,A.BUSS_SOURCE
                    FROM GICL_RES_BRDRX_DS_EXTR A, 
                         GIIS_DIST_SHARE B
                   WHERE (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.SESSION_ID = P_SESSION_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND A.LINE_CD=B.LINE_CD
                     AND A.GRP_SEQ_NO = B.SHARE_CD
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                     AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
                   GROUP BY A.ISS_CD, B.TRTY_NAME, A.GRP_SEQ_NO,A.BUSS_SOURCE
                   ORDER BY A.GRP_SEQ_NO )
        LOOP
            rep.iss_cd              := i.iss_cd;
            rep.buss_source         := i.buss_source;
            rep.outstanding_loss5   := i.outstanding_loss;
            rep.grp_seq_no          := i.grp_seq_no;
            rep.trty_name           := i.trty_name;   
            
            PIPE ROW(rep);        
        END LOOP;
    END get_trty_per_iss;
    
    
    FUNCTION get_trty_per_buss_source(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type
    ) RETURN trty_tab PIPELINED
    AS
        rep     trty_type;
    BEGIN
        FOR i IN (SELECT A.BUSS_SOURCE, SUM((NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0))) OUTSTANDING_LOSS, 
                         B.TRTY_NAME,A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A, 
                         GIIS_DIST_SHARE B
                   WHERE (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.SESSION_ID = P_SESSION_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND A.LINE_CD=B.LINE_CD
                    AND A.GRP_SEQ_NO = B.SHARE_CD
                     AND A.BUSS_SOURCE = NVL(p_buss_source, A.BUSS_SOURCE)
                   GROUP BY A.BUSS_SOURCE, B.TRTY_NAME, A.GRP_SEQ_NO
                   ORDER BY A.GRP_SEQ_NO )
        LOOP
            rep.buss_source         := i.buss_source;
            rep.outstanding_loss5   := i.outstanding_loss;
            rep.grp_seq_no          := i.grp_seq_no;
            rep.trty_name           := i.trty_name;   
            
            PIPE ROW(rep);        
        END LOOP;
    END get_trty_per_buss_source;
    
    
    FUNCTION get_trty_per_buss_type(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source_type  VARCHAR2
    ) RETURN trty_tab PIPELINED
    AS
        rep     trty_type;
    BEGIN
        FOR i IN   (SELECT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                           DECODE(A.ISS_CD,'RI','RI',D.INTM_TYPE) BUSS_SOURCE_TYPE,
                           SUM(NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS, C.TRTY_NAME  
                      FROM GICL_RES_BRDRX_DS_EXTR A, 
                           GIIS_DIST_SHARE C, 
                           GIIS_INTERMEDIARY D
                     WHERE (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                       AND A.SESSION_ID = P_SESSION_ID 
                       AND A.CLAIM_ID =  NVL(P_CLAIM_ID,A.CLAIM_ID) 
                       AND C.LINE_CD=A.LINE_CD
                       AND C.SHARE_CD=A.GRP_SEQ_NO
                       AND A.BUSS_SOURCE = D.INTM_NO(+)
                       AND DECODE(A.ISS_CD,'RI','RI',D.INTM_TYPE) = P_BUSS_SOURCE_TYPE
                     GROUP BY DECODE(A.ISS_CD,'RI','RI','DI'), DECODE(A.ISS_CD,'RI','RI',D.INTM_TYPE), C.TRTY_NAME, A.GRP_SEQ_NO    
                     ORDER BY A.GRP_SEQ_NO )
        LOOP
            rep.buss_source_type    := i.buss_source_type;
            rep.iss_type            := i.iss_type;
            rep.outstanding_loss5   := i.outstanding_loss;
            rep.trty_name           := i.trty_name;   
            
            PIPE ROW(rep);        
        END LOOP;
    END get_trty_per_buss_type;
    
    
    FUNCTION get_trty_per_session_id(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type
    ) RETURN trty_tab PIPELINED 
    AS
        rep     trty_type;
    BEGIN
        FOR i IN (SELECT SUM((NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0))) OUTSTANDING_LOSS, 
                         B.TRTY_NAME, A.GRP_SEQ_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A, 
                         GIIS_DIST_SHARE B
                   WHERE (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
                     AND A.SESSION_ID = P_SESSION_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     AND A.LINE_CD=B.LINE_CD
                     AND A.GRP_SEQ_NO = B.SHARE_CD
                   GROUP BY B.TRTY_NAME, A.GRP_SEQ_NO
                   ORDER BY A.GRP_SEQ_NO)
        LOOP
            rep.outstanding_loss5   := i.outstanding_loss;
            rep.trty_name           := i.trty_name;  
            rep.grp_seq_no          := i.grp_seq_no; 
            
            PIPE ROW(rep); 
        END LOOP;
    END get_trty_per_session_id;  
    
    FUNCTION CF_INTM_RIFormula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type,
        p_intm_no    gicl_intm_itmperil.intm_no%TYPE
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
            BEGIN 
                FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                            FROM gicl_intm_itmperil a, giis_intermediary b
                           WHERE a.intm_no = b.intm_no
                             AND a.claim_id = p_claim_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = p_peril_cd
                             AND a.intm_no = p_intm_no) -- Added by carlo
                LOOP
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||CHR(10)||
                                 m.intm_name; --||CHR(10)||v_intm_ri; comment out by carlo
                END LOOP;
            END; 
        END IF;
        
        RETURN(v_intm_ri);
    
    END CF_INTM_RIFormula;
    
   /* Handle running multipage column 03.04.2014 - J. Diago */
   FUNCTION get_giclr205e_parent(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
     RETURN giclr205e_parent_tab PIPELINED
   IS
      v_row                giclr205e_parent_type;
      v_treaty_tab         treaty_tab;
      v_index              NUMBER := 0;
      v_id                 NUMBER := 0;
   BEGIN
      FOR buss_source_type IN (SELECT DISTINCT 
                                      DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                      DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                                      a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year
                                 FROM gicl_res_brdrx_extr a, giis_intermediary b
                                WHERE a.buss_source = b.intm_no(+)
                                  AND a.session_id = p_session_id
                                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                  AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                                ORDER BY buss_source_type)
      LOOP
         v_id := 0;
         v_index := 0;
         v_treaty_tab := treaty_tab();
         
         FOR treaty IN (SELECT DISTINCT 
                               a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                               a.grp_seq_no, b.trty_name
                          FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                         WHERE a.line_cd = b.line_cd
                           AND a.grp_seq_no = b.share_cd
                           AND b.line_cd = buss_source_type.line_cd
                           AND a.session_id = p_session_id
                           AND a.claim_id = NVL (p_claim_id, a.claim_id)
                           AND a.buss_source = buss_source_type.buss_source
                           AND a.iss_cd = buss_source_type.iss_cd
                           AND a.line_cd = buss_source_type.line_cd
                           AND a.subline_cd = buss_source_type.subline_cd
                           AND a.loss_year = buss_source_type.loss_year
                         ORDER BY a.grp_seq_no)
         LOOP
            v_index := v_index + 1;
            v_treaty_tab.EXTEND;
            v_treaty_tab(v_index).grp_seq_no := treaty.grp_seq_no;
            v_treaty_tab(v_index).trty_name := treaty.trty_name;
         END LOOP;
         
         v_index := 1;
         
         LOOP
           v_id := v_id + 1;
           v_row := NULL;
           
           v_row.buss_source_type := buss_source_type.buss_source_type;
           BEGIN
              SELECT intm_desc
                INTO v_row.buss_source_type_name
                FROM giis_intm_type
               WHERE intm_type = buss_source_type.buss_source_type;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_row.buss_source_type_name := 'REINSURER ';    
              WHEN OTHERS THEN
                 v_row.buss_source_type_name := '';
           END;
           
           v_row.buss_source := buss_source_type.buss_source;
           IF buss_source_type.iss_type = 'RI' THEN
              BEGIN
                 SELECT ri_name
                   INTO v_row.buss_source_name
                   FROM giis_reinsurer
                  WHERE ri_cd  = buss_source_type.buss_source;
              EXCEPTION
                 WHEN OTHERS THEN
                    v_row.buss_source_name := '';
              END;
           ELSE
              BEGIN
                 SELECT intm_name
                   INTO v_row.buss_source_name
                   FROM giis_intermediary
                  WHERE intm_no  = buss_source_type.buss_source;
              EXCEPTION
                 WHEN OTHERS THEN
                    v_row.buss_source_name := '';
              END;
           END IF;
           
           v_row.iss_cd := buss_source_type.iss_cd;
           BEGIN
              SELECT iss_name
                INTO v_row.iss_name
                FROM giis_issource
               WHERE iss_cd  = buss_source_type.iss_cd;
           EXCEPTION
              WHEN OTHERS THEN
                 v_row.iss_name := '';
           END;
           
           v_row.subline_cd := buss_source_type.subline_cd;
           BEGIN
              SELECT subline_name
                INTO v_row.subline_name
                FROM giis_subline
               WHERE subline_cd = buss_source_type.subline_cd
                 AND line_cd    = buss_source_type.line_cd;
           EXCEPTION
              WHEN OTHERS THEN 
                 v_row.subline_name := '';
           END;
           
           v_row.line_cd := buss_source_type.line_cd;
           BEGIN
              SELECT line_name
                INTO v_row.line_name
                FROM giis_line
               WHERE line_cd = buss_source_type.line_cd;
           EXCEPTION
              WHEN OTHERS THEN 
                 v_row.line_name := '';
           END;
           
           v_row.loss_year := buss_source_type.loss_year;
           v_row.loss_year_dummy := TO_CHAR(v_row.loss_year || '_' || v_id);
           
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
   
   FUNCTION get_giclr205e_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205e_claim_tab PIPELINED
   IS
      v_row                giclr205e_claim_type;
   BEGIN
      FOR claim IN (SELECT a.claim_id, a.claim_no, a.policy_no, b.assd_name,
                           a.incept_date, a.expiry_date, a.loss_date, a.item_no
                      FROM gicl_res_brdrx_extr a, giis_assured b
                     WHERE a.assd_no = b.assd_no
                       AND a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                       AND a.buss_source = p_buss_source
                       AND a.line_cd = p_line_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.iss_cd = p_iss_cd
                     GROUP BY a.claim_id, a.claim_no, a.policy_no, b.assd_name, --added by carlo
                           a.incept_date, a.expiry_date, a.loss_date, a.item_no
                     ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := claim.claim_id;
         v_row.claim_no := claim.claim_no;
         v_row.policy_no := claim.policy_no;
         v_row.assd_name := claim.assd_name;
         v_row.incept_date := claim.incept_date;
         v_row.expiry_date := claim.expiry_date;
         v_row.loss_date := claim.loss_date;
         v_row.item_no := claim.item_no;
        
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205e_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205e_item_main_tab PIPELINED
   IS
      v_row                giclr205e_item_main_type;
   BEGIN
      FOR item_name IN (SELECT a.claim_id, a.claim_no, a.policy_no, 
                               a.item_no, a.line_cd, a.grouped_item_no,
                               a.tsi_amt, a.peril_cd --Added by carlo
                          FROM gicl_res_brdrx_extr a, giis_assured b
                         WHERE a.assd_no = b.assd_no
                           AND a.session_id = p_session_id
                           AND a.claim_id = NVL (p_claim_id, a.claim_id)
                           AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                           AND a.buss_source = p_buss_source
                           AND a.line_cd = p_line_cd
                           AND a.subline_cd = p_subline_cd
                           AND a.iss_cd = p_iss_cd
                         GROUP BY a.claim_id, a.claim_no, a.policy_no, --Added by carlo
                                a.item_no, a.line_cd, a.grouped_item_no,
                                a.tsi_amt, a.peril_cd
                         ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := item_name.claim_id;
         v_row.claim_no := item_name.claim_no;
         v_row.policy_no := item_name.policy_no;
         v_row.item_no := item_name.item_no;
         v_row.tsi_amt := item_name.tsi_amt;
         v_row.item_title := CPI.get_gpa_item_title(item_name.claim_id, 
                                                   item_name.line_cd, 
                                                   item_name.item_no, 
                                                   item_name.grouped_item_no);
         
         BEGIN --Added by carlo
            SELECT peril_name
              INTO v_row.peril_name
              FROM giis_peril
             WHERE peril_cd = item_name.peril_cd AND line_cd = item_name.line_cd;
         END;
        
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205e_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr205e_item_tab PIPELINED
   IS
      v_row                giclr205e_item_type;
   BEGIN
      FOR item IN (SELECT   a.claim_id, a.claim_no, a.policy_no, a.item_no, a.tsi_amt, a.intm_no, --added intm_no by carlo
                            a.loss_cat_cd, a.line_cd, a.peril_cd, a.clm_loss_id, a.brdrx_record_id,
                            (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_loss
                     FROM gicl_res_brdrx_extr a
                    WHERE a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                      AND a.buss_source = p_buss_source
                      AND a.item_no = p_item_no
                    ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := item.claim_id;
         v_row.claim_no := item.claim_no;
         v_row.policy_no := item.policy_no;
         v_row.item_no := item.item_no;
         --v_row.tsi_amt := item.tsi_amt; comment out by carlo
         v_row.outstanding_loss := item.outstanding_loss;
         v_row.brdrx_record_id := item.brdrx_record_id;
         v_row.intm_no := item.intm_no; --carlo
         
         BEGIN
           SELECT peril_name
             INTO v_row.peril_name
             FROM giis_peril
            WHERE peril_cd  = item.peril_cd
              AND line_cd = item.line_cd;
         END;
         
         v_row.intm_name := GICLR205E_PKG.CF_INTM_RIFormula(item.claim_id, item.item_no, item.peril_cd, item.intm_no);
         
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205e_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   )
     RETURN outstanding_loss_tab_v PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;
      TYPE t_table  IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      cur                  ref_cursor;
      v_row                outstanding_loss_type_v;
      v_index              NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_claim_id           NUMBER(12);
   BEGIN
      v_table  := t_table();
      
      IF p_claim_id IS NULL THEN
         v_claim_id := -1;
      ELSE
         v_claim_id := p_claim_id;
      END IF;
      
      FOR buss_source IN (SELECT buss_source, iss_cd, line_cd, subline_cd, loss_year, 
                                 grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                            FROM TABLE (giclr205e_pkg.get_giclr205e_parent(p_session_id, p_claim_id))
                           WHERE buss_source = p_buss_source
                             AND loss_year_dummy = p_loss_year_dummy)
      LOOP
         FOR treaty IN 1 .. 4
         LOOP
            IF treaty = 1 THEN
               v_grp_seq_no := buss_source.grp_seq_no1;
            ELSIF treaty = 2 THEN
               v_grp_seq_no := buss_source.grp_seq_no2;
            ELSIF treaty = 3 THEN
               v_grp_seq_no := buss_source.grp_seq_no3;
            ELSIF treaty = 4 THEN
               v_grp_seq_no := buss_source.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NULL THEN
               EXIT;
            END IF;
            
            v_loop := 'SELECT outstanding_loss2
                        FROM TABLE (giclr205e_pkg.get_treaty_details ('||p_session_id||',
                                                '||v_claim_id||',
                                                '||p_brdrx_record_id||',
                                                '||buss_source.buss_source||',
                                                '''||buss_source.iss_cd||''',
                                                '''||buss_source.line_cd||''',
                                                '''||buss_source.subline_cd||''',
                                                '||buss_source.loss_year||'
                                               )
                                   )
                       WHERE grp_seq_no = '||v_grp_seq_no;
            
            v_temp := NULL;
            OPEN cur FOR v_loop;
            LOOP
               v_cur := NULL;
               FETCH cur INTO v_cur;
               
               BEGIN
                  IF v_temp IS NOT NULL THEN
                     v_temp := v_temp || CHR(10);
                  END IF;
            
                  SELECT v_temp || DECODE(SUBSTR(TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')), 1, 1), '.',
                         '0' || TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')),
                         TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')))
                    INTO v_temp
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS THEN
                     v_temp := NULL;
               END;
               
               EXIT WHEN cur%NOTFOUND;
            END LOOP;
            
            v_table.EXTEND;
            v_table(v_index) := v_temp;
            v_index := v_index + 1;
            CLOSE cur;
         END LOOP;
      END LOOP;
      
      v_index := 1;
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss1 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss2 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss3 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss4 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      PIPE ROW(v_row);
      
      RETURN;
   END;
   
   FUNCTION get_giclr205e_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
   BEGIN
      FOR buss_source IN (SELECT buss_source, iss_cd, line_cd, subline_cd, loss_year, 
                                 grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                            FROM TABLE (giclr205e_pkg.get_giclr205e_parent(p_session_id, p_claim_id))
                           WHERE buss_source = p_buss_source
                             AND loss_year_dummy = p_loss_year_dummy)
      LOOP
         FOR facul IN (SELECT *
                         FROM TABLE(giclr205e_pkg.get_treaty_facul(p_session_id,p_claim_id,p_brdrx_record_id,buss_source.buss_source
                                    ,buss_source.iss_cd,buss_source.line_cd,buss_source.subline_cd,buss_source.loss_year))
                        WHERE grp_seq_no IN (907, 999, NULL, NULL)
                          AND grp_seq_no = 999
                          AND facul_ri_name IS NOT NULL)
         LOOP
            v_row := NULL;
            IF p_grp_seq_no1 = 999 THEN
               v_row.ri_name1 := facul.facul_ri_name;
               v_row.outstanding_loss1 := facul.facul_outstanding_loss3;
            ELSIF p_grp_seq_no2 = 999 THEN
               v_row.ri_name2 := facul.facul_ri_name;
               v_row.outstanding_loss2 := facul.facul_outstanding_loss3;
            ELSIF p_grp_seq_no3 = 999 THEN
               v_row.ri_name3 := facul.facul_ri_name;
               v_row.outstanding_loss3 := facul.facul_outstanding_loss3;
            ELSIF p_grp_seq_no4 = 999 THEN
               v_row.ri_name4 := facul.facul_ri_name;
               v_row.outstanding_loss4 := facul.facul_outstanding_loss3;
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr205e_os_total(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
     p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE
   )
     RETURN total_os_loss_tab PIPELINED
   IS
      v_total              total_os_loss_type;
   BEGIN
      FOR total IN (SELECT SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) total_os_loss
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                       AND a.buss_source = p_buss_source
                       AND a.line_cd = p_line_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.iss_cd = p_iss_cd
                     ORDER BY a.claim_no)
      LOOP
         v_total.total_os_loss := total.total_os_loss;
         PIPE ROW(v_total);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205e_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE
   )
     RETURN outstanding_loss_tab_v PIPELINED
   IS  
      TYPE ref_cursor IS REF CURSOR;
      TYPE t_table  IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      cur                  ref_cursor;
      v_row                outstanding_loss_type_v;
      v_index              NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_claim_id           NUMBER(12) := -1;
      v_brdrx_record_id    NUMBER(12) := -1;
   BEGIN
      v_table  := t_table();
      
      FOR buss_source IN (SELECT buss_source, iss_cd, line_cd, subline_cd, loss_year, 
                                 grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                            FROM TABLE (giclr205e_pkg.get_giclr205e_parent(p_session_id, p_claim_id))
                           WHERE buss_source = p_buss_source
                             AND loss_year_dummy = p_loss_year_dummy
                             AND iss_cd = p_iss_cd
                             AND line_cd = p_line_cd
                             AND subline_cd = p_subline_cd
                         )
      LOOP
         FOR treaty IN 1 .. 4
         LOOP
            IF treaty = 1 THEN
               v_grp_seq_no := buss_source.grp_seq_no1;
            ELSIF treaty = 2 THEN
               v_grp_seq_no := buss_source.grp_seq_no2;
            ELSIF treaty = 3 THEN
               v_grp_seq_no := buss_source.grp_seq_no3;
            ELSIF treaty = 4 THEN
               v_grp_seq_no := buss_source.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NULL THEN
               EXIT;
            END IF;
            
            v_loop := 'SELECT SUM (outstanding_loss2)
                        FROM (SELECT outstanding_loss2
                                FROM TABLE (giclr205e_pkg.get_treaty_facul ('||p_session_id||',
                                                                            '||v_claim_id||',
                                                                            '||v_brdrx_record_id||',
                                                                            '||p_buss_source||',
                                                                            '''||buss_source.iss_cd||''',
                                                                            '''||buss_source.line_cd||''',
                                                                            '''||buss_source.subline_cd||''',
                                                                            '||buss_source.loss_year||'
                                                                           )
                                           )
                       WHERE grp_seq_no = '||v_grp_seq_no||'
                       GROUP BY brdrx_record_id, outstanding_loss2)';         
                       
            OPEN cur FOR v_loop;
            LOOP
               FETCH cur INTO v_temp;
               EXIT WHEN cur%NOTFOUND;
            END LOOP;
            
            v_table.EXTEND;
            v_table(v_index) := v_temp;
            v_index := v_index + 1;
            
            CLOSE cur;
         END LOOP;
      END LOOP;
      
      v_index := 1;
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss1 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss2 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss3 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_loss4 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      PIPE ROW(v_row);
      
      RETURN;
   END;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED
   AS
      rep                  treaty_ri_type2;
   BEGIN
      FOR j IN (SELECT DISTINCT a.ri_cd, a.line_cd, a.grp_seq_no,
                       DECODE(a.prnt_ri_cd, null, a.ri_cd, a.prnt_ri_cd) trty_ri_cd, policy_no
                  FROM GICL_RES_BRDRX_RIDS_EXTR a,
                       GIIS_TRTY_PANEL b,
                       GICL_RES_BRDRX_EXTR c,
                       GICL_RES_BRDRX_DS_EXTR d
                 WHERE 1 = 1
                   AND a.grp_seq_no <> 999
                   AND a.session_id = p_session_id
                   AND a.session_id = c.session_id
                   AND a.session_id = d.session_id
                   AND c.brdrx_record_id = d.brdrx_record_id
                   AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                   AND a.claim_id = nvl(p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.trty_seq_no
                   AND a.ri_cd = b.ri_cd
                   AND (nvl(a.expense_reserve,0) - nvl(a.expenses_paid,0)) > 0
                   AND c.buss_source = p_buss_source 
                   AND c.loss_year = p_loss_year
                   AND c.iss_cd = p_iss_cd
                   AND c.line_cd = p_line_cd
                   AND c.subline_cd = p_subline_cd
                 ORDER BY a.grp_seq_no, a.ri_cd, DECODE(a.prnt_ri_cd, null, a.ri_cd, a.prnt_ri_cd))
      LOOP
         rep.policy_no := j.policy_no;
         rep.line_cd := j.line_cd;
         rep.grp_seq_no := j.grp_seq_no;
         rep.ri_cd := j.ri_cd;
         rep.trty_ri_cd := j.trty_ri_cd;
         
         BEGIN
            SELECT trty_name
              INTO rep.treaty_name
              FROM giis_dist_share
             WHERE share_cd = j.grp_seq_no AND line_cd = j.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.treaty_name := NULL;
         END;
         
         BEGIN
            SELECT ri_sname
              INTO rep.ri_name
              FROM giis_reinsurer
             WHERE ri_cd = j.ri_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
               rep.ri_name := NULL;
         END;
         
         BEGIN
            FOR shr IN (SELECT trty_shr_pct
                          FROM giis_trty_panel
                         WHERE line_cd = j.line_cd
                           AND trty_seq_no = j.grp_seq_no
                           AND ri_cd = j.ri_cd)
            LOOP
               rep.trty_shr_pct := shr.trty_shr_pct;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.trty_shr_pct := NULL;
         END;
         
         FOR a IN (SELECT (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss
                     FROM GICL_RES_BRDRX_RIDS_EXTR a
                    WHERE a.grp_seq_no <> 999
                      AND a.session_id = p_session_id
                      AND (nvl(a.expense_reserve,0) - nvl(a.expenses_paid,0)) > 0
                      AND a.grp_seq_no = j.grp_seq_no
                      AND a.ri_cd = j.ri_cd
                      AND a.brdrx_rids_record_id IN(SELECT a.brdrx_rids_record_id
                                                      FROM GICL_RES_BRDRX_RIDS_EXTR a,
                                                           GIIS_TRTY_PANEL b,
                                                           GICL_RES_BRDRX_EXTR c,
                                                           GICL_RES_BRDRX_DS_EXTR d
                                                     WHERE a.grp_seq_no <> 999
                                                       AND a.session_id = p_session_id
                                                       AND a.session_id = c.session_id
                                                       AND a.session_id = d.session_id
                                                       AND c.brdrx_record_id = d.brdrx_record_id
                                                       AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                                                       AND a.claim_id = nvl(p_claim_id, a.claim_id)
                                                       AND a.line_cd = b.line_cd
                                                       AND a.grp_seq_no = b.trty_seq_no
                                                       AND a.ri_cd = b.ri_cd
                                                       AND (nvl(a.expense_reserve,0) - nvl(a.expenses_paid,0)) > 0
                                                       AND c.buss_source = p_buss_source 
                                                       AND c.loss_year = p_loss_year
                                                       AND c.iss_cd = p_iss_cd
                                                       AND c.line_cd = p_line_cd
                                                       AND c.subline_cd = p_subline_cd)
                    ORDER BY a.grp_seq_no, a.brdrx_rids_record_id)
         LOOP
            rep.outstanding_loss := a.outstanding_loss;
            PIPE ROW(rep);
         END LOOP;
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_treaty_summary_line(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED
   IS
      v_row               summary_treaty_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source,
                       SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                 WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                   AND a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.share_cd
                   AND a.buss_source = p_buss_source 
                   AND a.iss_cd = p_iss_cd
                   AND a.line_cd = p_line_cd
                 GROUP BY a.line_cd, a.iss_cd, b.trty_name, a.grp_seq_no, a.buss_source
                 ORDER BY a.grp_seq_no)
      LOOP
         v_row.outstanding_loss := i.outstanding_loss;
         v_row.trty_name := i.trty_name;
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_treaty_summary_iss_source(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED
   IS
      v_row               summary_treaty_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source,
                       SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                 WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                   AND a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.share_cd
                   AND a.buss_source = p_buss_source 
                   AND a.iss_cd = p_iss_cd
                 GROUP BY a.line_cd, a.iss_cd, b.trty_name, a.grp_seq_no, a.buss_source
                 ORDER BY a.grp_seq_no)
      LOOP
         v_row.outstanding_loss := i.outstanding_loss;
         v_row.trty_name := i.trty_name;
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_treaty_summary_buss_source(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED
   IS
      v_row               summary_treaty_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source,
                       SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                 WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                   AND a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.share_cd
                   AND a.buss_source = p_buss_source 
                 GROUP BY a.line_cd, a.iss_cd, b.trty_name, a.grp_seq_no, a.buss_source
                 ORDER BY a.grp_seq_no)
      LOOP
         v_row.outstanding_loss := i.outstanding_loss;
         v_row.trty_name := i.trty_name;
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_treaty_summary_buss_type(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source_type   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED
   IS
      v_row               summary_treaty_type;
   BEGIN
      FOR i IN (SELECT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                       DECODE (a.iss_cd, 'RI', 'RI', d.intm_type) buss_source_type,
                       SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_loss,
                       c.trty_name
                  FROM gicl_res_brdrx_ds_extr a, giis_dist_share c, giis_intermediary d
                 WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                   AND a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND c.line_cd = a.line_cd
                   AND c.share_cd = a.grp_seq_no
                   AND a.buss_source = d.intm_no(+)
                   AND DECODE (a.iss_cd, 'RI', 'RI', d.intm_type) = p_buss_source_type
                 GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                          DECODE (a.iss_cd, 'RI', 'RI', d.intm_type),
                          c.trty_name,
                          a.grp_seq_no
                 ORDER BY a.grp_seq_no)
      LOOP
         v_row.outstanding_loss := i.outstanding_loss;
         v_row.trty_name := i.trty_name;
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_treaty_summary_grand(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED
   IS
      v_row               summary_treaty_type;
   BEGIN
      FOR i IN (SELECT SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) outstanding_loss,
                       b.trty_name, a.grp_seq_no
                  FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                 WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                   AND a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.share_cd
                 GROUP BY b.trty_name, a.grp_seq_no
                 ORDER BY a.grp_seq_no)
      LOOP
         v_row.outstanding_loss := i.outstanding_loss;
         v_row.trty_name := i.trty_name;
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
END GICLR205E_PKG;
/


