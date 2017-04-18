CREATE OR REPLACE PACKAGE BODY CPI.GICLR222E_PKG
AS

    /**
    **  Created By:     Shan Bati
    **  Date Created:   04.05.2013
    **  Referenced BY:  GICLR222E - EXPENSES PAID BORDEREAUX (PER POLICY)
    **/
    
    
    FUNCTION CF_companyFormula
        RETURN VARCHAR2
    AS
         v_name        varchar2(50);
    BEGIN
        SELECT param_value_v
          INTO v_name
          FROM giac_parameters
         WHERE param_name = 'COMPANY_NAME';
        return(v_name);
    
    RETURN NULL; EXCEPTION
        when NO_DATA_FOUND then
            return(null);
            
    END CF_companyFormula;
        
    
    FUNCTION CF_com_addressFormula
        RETURN VARCHAR2
    AS
        v_add        giis_parameters.param_value_v%TYPE;
    BEGIN
        SELECT param_value_v
          INTO v_add
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
        
        return(v_add);
    RETURN NULL; exception
        when NO_DATA_FOUND then
            return(null);
            
    END CF_com_addressFormula;
    
        
    FUNCTION REPORT_NAMEFormula
        RETURN VARCHAR2
    AS
        V_REPORT_TITLE      VARCHAR2(50);
    BEGIN
        BEGIN
            select report_title
              into v_report_title
              from giis_reports
             where report_id = 'GICLR222E';
        END;
        
        RETURN V_REPORT_TITLE;
        
    END REPORT_NAMEFormula;
    
        
    FUNCTION CF_paramdateFormula(
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
         
    END CF_paramdateFormula;
    
    
    FUNCTION CF_dateFormula(
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN VARCHAR2
    AS
        v_date        varchar2(100);
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
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN header_tab PIPELINED
    AS
        tab     header_type;
    BEGIN
        tab.company_name    := CF_companyFormula;
        tab.company_address := CF_com_addressFormula;
        tab.report_title    := REPORT_NAMEFormula;
        tab.paramdate       := CF_paramdateFormula(p_paid_date);
        tab.date_period     := CF_dateFormula(p_from_date, p_to_date);
        
        PIPE ROW(tab);
        
    END get_report_header;
    
    
    FUNCTION CF_POLICYFormula(
        p_policy_no     GICL_RES_BRDRX_EXTR.POLICY_NO%type
    ) RETURN VARCHAR2
    AS
        v_policy        VARCHAR2(60);
        v_ref_pol_no    gipi_polbasic.ref_pol_no%type;
    BEGIN
        BEGIN
            SELECT DISTINCT b.ref_pol_no -- Modified by Marlo 02172010
              INTO v_ref_pol_no
              FROM gicl_res_brdrx_extr a, gipi_polbasic b
             WHERE a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.pol_iss_cd = b.iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND b.endt_seq_no = 0 
               AND get_policy_no(b.policy_id) = p_policy_no -- Added by Marlo 02172010
               AND a.ref_pol_no IS NOT NULL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_ref_pol_no := NULL; 
        END;
          
        IF v_ref_pol_no IS NOT NULL THEN
             -- v_policy := :policy_no2||'/'||CHR(10)||v_ref_pol_no; Comment out by Marlo 02172010 changed to:
            v_policy := p_policy_no||'/'||v_ref_pol_no;
        ELSE
            v_policy := p_policy_no;
        END IF;     
        
        RETURN (v_policy);
    END CF_POLICYFormula;
    
     
    FUNCTION ITEM_TITLEFormula(
        p_claim_id             GICL_CLAIMS.claim_id%TYPE,
        p_line_cd              GICL_CLAIMS.line_cd%TYPE,
        p_item_no              gicl_accident_dtl.item_no%TYPE,
        p_grouped_item_no      gicl_accident_dtl.grouped_item_no%TYPE
    ) RETURN VARCHAR2
    AS
        v_item_title        VARCHAR2(200);
    BEGIN
        v_item_title := get_gpa_item_title(p_claim_id, p_line_cd, p_item_no, NVL(p_grouped_item_no,0));
        RETURN v_item_title;
        
    END ITEM_TITLEFormula;
    
    
    FUNCTION LOSS_CAT_DESFormula(
        p_loss_cat_cd   GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
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
        
    END LOSS_CAT_DESFormula;
    
    
    FUNCTION CF_INTM_RIFormula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type
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
                             AND a.peril_cd = p_peril_cd) 
                LOOP
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||CHR(10)||
                                 m.intm_name||CHR(10)||v_intm_ri;
                END LOOP;
            END; 
        END IF;
        
        RETURN(v_intm_ri);
    
    END CF_INTM_RIFormula;
    
        
    FUNCTION CF_INTMFormula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type    
    ) RETURN VARCHAR2
    AS
        v_intm           VARCHAR2(200);
    BEGIN
        BEGIN 
            FOR i IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                        FROM gicl_intm_itmperil a, giis_intermediary b
                       WHERE a.intm_no = b.intm_no
                         AND a.claim_id = p_claim_id
                         AND a.item_no = p_item_no
                         AND a.peril_cd = p_peril_cd) 
            LOOP
                v_intm := to_char(i.intm_no)||'/'||i.ref_intm_cd||CHR(10)||i.intm_name||CHR(10)|| v_intm;
            END LOOP;
        END;
         
        RETURN (v_intm);
        
    END CF_INTMFormula;
    
    
    FUNCTION CF_DV_NOFormula(
        p_claim_id      gicl_clm_res_hist.CLAIM_ID%type,
        p_item_no       giac_chk_disbursement.ITEM_NO%type,
        p_clm_loss_id   gicl_clm_res_hist.CLM_LOSS_ID%type,    
        p_paid_losses   GICL_RES_BRDRX_EXTR.LOSSES_PAID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    )RETURN VARCHAR2
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
                FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999'))|| ' /'||e.check_no dv_no,
                                  TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                             FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                                  giac_acctrans c, giac_reversals d,
                                  giac_chk_disbursement e
                            WHERE a.tran_id = b.gacc_tran_id
                              AND a.tran_id = d.gacc_tran_id
                              AND c.tran_id = d.reversing_tran_id 
                              AND b.gacc_tran_id = e.gacc_tran_id
                              AND e.item_no = p_item_no
                              AND a.claim_id = p_claim_id
                              AND a.clm_loss_id = p_clm_loss_id
                            GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                           HAVING SUM(NVL(a.EXPENSES_PAID,0)) > 0)
                LOOP
                    v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
                    IF var_dv_no IS NULL THEN
                        var_dv_no := v_dv_no;
                    ELSE
                        var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                    END IF;
                END LOOP;
            ELSE 
                FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999'))||' /'||e.check_no dv_no
                             FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                                  giac_direct_claim_payts c, giac_acctrans d,
                                  giac_chk_disbursement e
                            WHERE a.tran_id             = d.tran_id    
                              AND b.gacc_tran_id = c.gacc_tran_id
                              AND b.gacc_tran_id = d.tran_id
                              AND b.gacc_tran_id = e.gacc_tran_id
                              AND e.item_no = p_item_no
                              AND a.claim_id = p_claim_id 
                              AND a.clm_loss_id = p_clm_loss_id
                              AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                                  BETWEEN p_from_date AND p_to_date
                            GROUP BY b.dv_pref, b.dv_no, e.check_no
                           HAVING SUM(NVL(a.EXPENSES_PAID,0)) > 0)    
                LOOP
                    v_dv_no := v2.dv_no;
                    IF var_dv_no IS NULL THEN
                        var_dv_no := v_dv_no;
                    ELSE
                        var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                    END IF;
                END LOOP;      
            END IF;
        END LOOP;
  
        RETURN (var_dv_no);        
    
    END CF_DV_NOFormula;
    
    
    FUNCTION PERIL_NAMEFormula(
        p_peril_cd  GIIS_PERIL.PERIL_CD%type,
        p_line_cd   GIIS_PERIL.LINE_CD%type
    ) RETURN VARCHAR2
    AS
        V_PERIL_NAME           GIIS_PERIL.PERIL_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT PERIL_NAME
              INTO V_PERIL_NAME
              FROM GIIS_PERIL
             WHERE PERIL_CD    = p_peril_cd
               AND LINE_CD     = p_line_cd;
        EXCEPTION
            WHEN OTHERS THEN 
                V_PERIL_NAME  := NULL;
        END;
        RETURN V_PERIL_NAME;
        
    END PERIL_NAMEFormula;
    
    
    FUNCTION ASSD_NAMEFormula(
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
    END ASSD_NAMEFormula;
    
    
    FUNCTION get_report_details(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type, 
        p_policy_no     GICL_RES_BRDRX_EXTR.POLICY_NO%type,       
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        FOR b in (SELECT DISTINCT A.POLICY_NO, A.ASSD_NO, 
                         TRUNC(A.INCEPT_DATE) INCEPT_DATE,
                         TRUNC(A.EXPIRY_DATE) EXPIRY_DATE
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID 
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                     --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                     AND NVL(A.EXPENSES_PAID,0) > 0
                     AND A.POLICY_NO = NVL(P_POLICY_NO, A.POLICY_NO))
        LOOP
            FOR c in (SELECT A.BRDRX_RECORD_ID, A.CLAIM_ID, A.LINE_CD, A.CLAIM_NO,
                             A.POLICY_NO, A.LOSS_DATE, A.CLM_FILE_DATE, A.ITEM_NO,
                             A.GROUPED_ITEM_NO, A.PERIL_CD, A.LOSS_CAT_CD,
                             A.TSI_AMT, A.INTM_NO, A.CLM_LOSS_ID,
                             NVL(A.EXPENSES_PAID,0) PAID_LOSSES
                        FROM GICL_RES_BRDRX_EXTR A
                       WHERE A.POLICY_NO = b.POLICY_NO
                       ORDER BY A.POLICY_NO, TRUNC(A.INCEPT_DATE), TRUNC(A.EXPIRY_DATE), A.CLAIM_NO)
            LOOP
                rep.policy_no           := c.policy_no;
                rep.assd_no             := b.assd_no;
                rep.incept_date         := b.incept_date;
                rep.expiry_date         := b.expiry_date;
                rep.term                := TO_CHAR(rep.incept_date, 'MM-dd-yyyy') || '   -   '|| TO_CHAR(rep.expiry_date, 'MM-dd-yyyy');
                rep.claim_id            := c.claim_id;
                rep.line_cd             := c.line_cd;
                rep.claim_no            := c.claim_no;
                rep.loss_date           := c.loss_date;
                rep.clm_file_date       := c.clm_file_date;
                rep.clm_loss_id         := c.clm_loss_id;
                rep.item_no             := c.item_no;
                rep.grouped_item_no     := c.grouped_item_no;
                rep.peril_cd            := c.peril_cd;
                rep.loss_cat_cd         := c.loss_cat_cd;
                rep.tsi_amt             := c.tsi_amt;
                rep.intm_no             := c.intm_no;
                rep.paid_losses         := c.paid_losses;
                rep.brdrx_record_id     := c.BRDRX_RECORD_ID;
            
                rep.cf_policy           := CF_POLICYFormula(c.policy_no);
                rep.assd_name           := ASSD_NAMEFormula(b.assd_no);
                rep.item_title          := ITEM_TITLEFormula(c.claim_id, c.line_cd, c.item_no, c.grouped_item_no);
                rep.loss_cat_des        := PERIL_NAMEFormula(c.peril_cd, c.line_cd);
                --rep.peril_name          := PERIL_NAMEFormula(c.peril_cd, c.line_cd);
                rep.cf_intm             := CF_INTMFormula(c.claim_id, c.item_no, c.peril_cd);
                rep.cf_intm_ri          := CF_INTM_RIFormula(c.claim_id, c.item_no, c.peril_cd);
                rep.cf_dv_no            := CF_DV_NOFormula(c.claim_id, c.item_no, c.clm_loss_id, c.paid_losses, p_paid_date, p_from_date, p_to_date);
                
                PIPE ROW(rep);
            END LOOP;
        END LOOP;               
        
    END get_report_details;
    
    
    FUNCTION TREATY_NAMEFormula(
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
        
    END TREATY_NAMEFormula;
    
        
    FUNCTION FACUL_RI_NAMEFormula(
        p_facul_ri_cd   GIIS_REINSURER.RI_CD%type
    )RETURN VARCHAR2
    AS
        V_RI_NAME        GIIS_REINSURER.RI_NAME%TYPE;
    BEGIN
        BEGIN
            SELECT RI_SNAME
              INTO V_RI_NAME
              FROM GIIS_REINSURER
             WHERE RI_CD   = p_facul_ri_cd;
        EXCEPTION
            WHEN OTHERS THEN   
                V_RI_NAME  := NULL;
        END;
        RETURN V_RI_NAME;
  
    END FACUL_RI_NAMEFormula;
    
    
    FUNCTION get_treaty_header(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_DS_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type
    )RETURN treaty_header_tab PIPELINED
    AS
        rep     treaty_header_type;
    BEGIN
        FOR c IN (SELECT DISTINCT A.GRP_SEQ_NO, A.LINE_CD, B.POLICY_NO
                    FROM GICL_RES_BRDRX_DS_EXTR A,
                         GICL_RES_BRDRX_EXTR B
                   WHERE A.SESSION_ID = p_session_id
                     AND A.SESSION_ID = B.SESSION_ID
                     AND A.BRDRX_RECORD_ID = B.BRDRX_RECORD_ID
                     AND A.CLAIM_ID = NVL(p_claim_id, A.CLAIM_ID)
                     --AND ABS(NVL(A.EXPENSES_PAID, 0)) > 0
                     AND NVL(A.EXPENSES_PAID, 0) > 0
                     AND B.POLICY_NO = NVL(p_policy_no, B.POLICY_NO)
                   ORDER BY B.POLICY_NO, A.GRP_SEQ_NO, A.LINE_CD)
        LOOP
            rep.policy_no       := c.policy_no;
            rep.treaty_name     := TREATY_NAMEFormula(c.grp_seq_no, c.line_cd);
            rep.line_cd         := c.line_cd;
            rep.grp_seq_no      := c.grp_seq_no;
            
            PIPE ROW(rep);
        END LOOP;
        
    END get_treaty_header;
        
    
    FUNCTION get_treaty_details(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type
    ) RETURN treaty_details_tab PIPELINED
    AS
        rep     treaty_details_type;
    BEGIN
        FOR c IN (SELECT A.POLICY_NO, A.CLAIM_ID, A.BRDRX_RECORD_ID, A.PERIL_CD
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = p_session_id
                     AND A.CLAIM_ID = NVL(p_claim_id, A.CLAIM_ID)
                     --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                     AND NVL(A.EXPENSES_PAID,0) > 0 
                     AND A.POLICY_NO = NVL(p_policy_no, A.POLICY_NO)
                     AND A.BRDRX_RECORD_ID = NVL(p_brdrx_record_id, A.BRDRX_RECORD_ID)
                   ORDER BY A.POLICY_NO, A.CLAIM_NO)
        LOOP
            rep.policy_no       := c.policy_no;            
            rep.claim_id        := c.claim_id;
            
            FOR f IN (SELECT DISTINCT A.GRP_SEQ_NO, A.LINE_CD, B.POLICY_NO
                        FROM GICL_RES_BRDRX_DS_EXTR A,
                             GICL_RES_BRDRX_EXTR B
                       WHERE A.SESSION_ID = p_session_id
                         AND A.SESSION_ID = B.SESSION_ID
                         AND A.BRDRX_RECORD_ID = B.BRDRX_RECORD_ID
                         AND A.CLAIM_ID = NVL(p_claim_id, A.CLAIM_ID)
                         AND B.POLICY_NO = c.policy_no
                         --AND ABS(NVL(A.EXPENSES_PAID, 0)) > 0
                         AND NVL(A.EXPENSES_PAID, 0) > 0
                         AND A.BRDRX_RECORD_ID = c.brdrx_record_id
                       ORDER BY A.GRP_SEQ_NO)
            LOOP
                rep.treaty_name     := TREATY_NAMEFormula(f.grp_seq_no, f.line_cd);
                
                FOR h IN (SELECT A.BRDRX_RECORD_ID, A.BRDRX_DS_RECORD_ID, A.GRP_SEQ_NO,
                                 A.SHR_PCT, NVL(A.EXPENSES_PAID,0) PAID_LOSSES
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.SESSION_ID = p_session_id
                             --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                             AND NVL(A.EXPENSES_PAID,0) > 0
                             AND A.GRP_SEQ_NO = f.grp_seq_no 
                             AND A.BRDRX_RECORD_ID = c.brdrx_record_id
                           ORDER BY A.GRP_SEQ_NO )
                LOOP
                    rep.brdrx_record_id     := h.brdrx_record_id;
                    rep.brdrx_ds_record_id  := h.brdrx_ds_record_id;
                    rep.grp_seq_no          := h.grp_seq_no;
                    rep.shr_pct             := h.shr_pct;
                    rep.paid_losses         := h.paid_losses;
                        
                    PIPE ROW(rep);
                END LOOP;
            END LOOP;  
        END LOOP;
            
    END get_treaty_details;
    
    
    FUNCTION get_treaty_facul(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type
    ) RETURN treaty_details_tab PIPELINED
    AS
        rep     treaty_details_type;
    BEGIN
        FOR c IN (SELECT A.POLICY_NO, A.CLAIM_ID, A.BRDRX_RECORD_ID, A.PERIL_CD
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE A.SESSION_ID = p_session_id
                     AND A.CLAIM_ID = NVL(DECODE(p_claim_id, -1, A.CLAIM_ID, p_claim_id) ,A.CLAIM_ID)
                     --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0 
                     AND NVL(A.EXPENSES_PAID,0) > 0
                     AND A.POLICY_NO = NVL(p_policy_no, A.POLICY_NO)
                     AND A.BRDRX_RECORD_ID = NVL(DECODE(p_brdrx_record_id, -1, A.BRDRX_RECORD_ID, p_brdrx_record_id), A.BRDRX_RECORD_ID)
                   ORDER BY A.POLICY_NO, A.CLAIM_NO)
        LOOP
            rep.policy_no       := c.policy_no;            
            rep.claim_id        := c.claim_id;
            
            FOR f IN (SELECT DISTINCT A.GRP_SEQ_NO, A.LINE_CD, B.POLICY_NO
                        FROM GICL_RES_BRDRX_DS_EXTR A,
                             GICL_RES_BRDRX_EXTR B
                       WHERE A.SESSION_ID = p_session_id
                         AND A.SESSION_ID = B.SESSION_ID
                         AND A.BRDRX_RECORD_ID = B.BRDRX_RECORD_ID
                         AND A.CLAIM_ID = NVL(DECODE(p_claim_id, -1, A.CLAIM_ID, p_claim_id) ,A.CLAIM_ID)
                         AND B.POLICY_NO = c.policy_no
                         --AND ABS(NVL(A.EXPENSES_PAID, 0)) > 0
                         AND A.BRDRX_RECORD_ID = c.brdrx_record_id
                       ORDER BY A.GRP_SEQ_NO)
            LOOP
                rep.treaty_name     := TREATY_NAMEFormula(f.grp_seq_no, f.line_cd);
               
                FOR h IN (SELECT A.BRDRX_RECORD_ID, A.BRDRX_DS_RECORD_ID, A.GRP_SEQ_NO,
                                 A.SHR_PCT, NVL(A.EXPENSES_PAID,0) PAID_LOSSES
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE A.SESSION_ID = p_session_id
                             --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                             AND NVL(A.EXPENSES_PAID,0) > 0
                             AND A.GRP_SEQ_NO = f.grp_seq_no 
                             AND A.BRDRX_RECORD_ID = c.brdrx_record_id
                           ORDER BY A.GRP_SEQ_NO )
                LOOP
                    rep.brdrx_record_id     := h.brdrx_record_id;
                    rep.brdrx_ds_record_id  := h.brdrx_ds_record_id;
                    rep.grp_seq_no          := h.grp_seq_no;
                    rep.shr_pct             := h.shr_pct;
                    rep.paid_losses         := h.paid_losses;
                    
                    --PIPE ROW(rep);
                    
                    FOR i IN (SELECT A.BRDRX_DS_RECORD_ID,
                                     DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD) FACUL_RI_CD,
                                     SUM(A.SHR_RI_PCT) FACUL_SHR_RI_PCT,
                                     SUM(NVL(A.EXPENSES_PAID,0)) PAID_LOSSES2
                                FROM GICL_RES_BRDRX_RIDS_EXTR A
                               WHERE A.GRP_SEQ_NO = 999 
                                 AND A.SESSION_ID = p_session_id
                                 AND A.BRDRX_DS_RECORD_ID = h.brdrx_ds_record_id -- added
                               GROUP BY A.BRDRX_DS_RECORD_ID,
                                     DECODE(A.PRNT_RI_CD,NULL, A.RI_CD, A.PRNT_RI_CD))
                    LOOP 
                        rep.brdrx_ds_record_id  := i.brdrx_ds_record_id;
                        rep.facul_ri_cd         := i.facul_ri_cd;
                        rep.facul_shr_ri_pct    := i.facul_shr_ri_pct;
                        rep.paid_losses2        := i.paid_losses2;
                        
                        rep.facul_ri_name       := FACUL_RI_NAMEFormula(i.facul_ri_cd);
                        
                        PIPE ROW(rep);
                    END LOOP;                   
                END LOOP;
            END LOOP;  
        END LOOP;
        
    END get_treaty_facul;
    
    
    FUNCTION RI_SHRFormula(
        p_line_cd       giis_trty_panel.LINE_CD%type,  
        p_grp_seq_no    giis_trty_panel.TRTY_SEQ_NO%type,  
        p_ri_cd         giis_trty_panel.RI_CD%type         
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
        
    END RI_SHRFormula;
    
    
    FUNCTION get_treaty_ri(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type
    ) RETURN treaty_ri_tab PIPELINED
    AS
        rep     treaty_ri_type;
    BEGIN
        FOR i IN (SELECT DISTINCT C.POLICY_NO
                    FROM GICL_RES_BRDRX_RIDS_EXTR A,
                         GIIS_TRTY_PANEL B,
                         GICL_RES_BRDRX_EXTR C,
                         GICL_RES_BRDRX_DS_EXTR D
                   WHERE A.GRP_SEQ_NO <> 999
                     AND  A.SESSION_ID = P_SESSION_ID
                     AND A.SESSION_ID = C.SESSION_ID
                     AND A.SESSION_ID = D.SESSION_ID
                     AND C.BRDRX_RECORD_ID = D.BRDRX_RECORD_ID
                     AND A.BRDRX_DS_RECORD_ID = D.BRDRX_DS_RECORD_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                     AND A.LINE_CD = B.LINE_CD
                     AND A.GRP_SEQ_NO = B.TRTY_SEQ_NO
                     AND A.RI_CD = B.RI_CD
                     --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                     AND NVL(A.EXPENSES_PAID,0) > 0 
                     AND C.POLICY_NO = NVL(p_policy_no, C.POLICY_NO)
                   ORDER BY C.POLICY_NO/*, A.GRP_SEQ_NO, 
                         DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD)*/ )
        LOOP
            rep.policy_no               := i.policy_no;
            
            FOR j IN (SELECT DISTINCT A.RI_CD, A.LINE_CD, A.GRP_SEQ_NO,
                             DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD
                        FROM GICL_RES_BRDRX_RIDS_EXTR A,
                             GIIS_TRTY_PANEL B,
                             GICL_RES_BRDRX_EXTR C,
                             GICL_RES_BRDRX_DS_EXTR D
                       WHERE A.GRP_SEQ_NO <> 999
                         AND A.SESSION_ID = P_SESSION_ID
                         AND A.SESSION_ID = C.SESSION_ID
                         AND A.SESSION_ID = D.SESSION_ID
                         AND C.BRDRX_RECORD_ID = D.BRDRX_RECORD_ID
                         AND A.BRDRX_DS_RECORD_ID = D.BRDRX_DS_RECORD_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND A.LINE_CD = B.LINE_CD
                         AND A.GRP_SEQ_NO = B.TRTY_SEQ_NO
                         AND A.RI_CD = B.RI_CD
                         --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                         AND NVL(A.EXPENSES_PAID,0) > 0 
                         AND C.POLICY_NO = i.POLICY_NO
                       ORDER BY A.GRP_SEQ_NO, A.RI_CD,
                             DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD))
            LOOP
                rep.line_cd         := j.line_cd;
                rep.grp_seq_no      := j.grp_seq_no;
                rep.ri_cd           := j.ri_cd;
                rep.trty_ri_cd      := j.trty_ri_cd;
                
                rep.treaty_name     := TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                rep.ri_name         := FACUL_RI_NAMEFormula(j.ri_cd);                
                rep.trty_shr_pct    := RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);
                    
                PIPE ROW(rep);
            END LOOP;
            
        END LOOP;
        
    END get_treaty_ri;
    
    
    FUNCTION get_treaty_ri_amt(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_ri_cd             GICL_RES_BRDRX_RIDS_EXTR.RI_CD%TYPE
    ) RETURN treaty_ri_amt_tab PIPELINED
    AS
        rep             treaty_ri_amt_type;
    BEGIN
        FOR i IN (SELECT DISTINCT C.POLICY_NO
                    FROM GICL_RES_BRDRX_RIDS_EXTR A,
                         GIIS_TRTY_PANEL B,
                         GICL_RES_BRDRX_EXTR C,
                         GICL_RES_BRDRX_DS_EXTR D
                   WHERE A.GRP_SEQ_NO <> 999
                     AND  A.SESSION_ID = P_SESSION_ID
                     AND A.SESSION_ID = C.SESSION_ID
                     AND A.SESSION_ID = D.SESSION_ID
                     AND C.BRDRX_RECORD_ID = D.BRDRX_RECORD_ID
                     AND A.BRDRX_DS_RECORD_ID = D.BRDRX_DS_RECORD_ID
                     AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                     AND A.LINE_CD = B.LINE_CD
                     AND A.GRP_SEQ_NO = B.TRTY_SEQ_NO
                     AND A.RI_CD = B.RI_CD
                     --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                     AND NVL(A.EXPENSES_PAID,0) > 0  
                     AND C.POLICY_NO = NVL(p_policy_no, C.POLICY_NO)
                   ORDER BY C.POLICY_NO/*, A.GRP_SEQ_NO, 
                         DECODE(A.PRNT_RI_CD,NULL , A.RI_CD, A.PRNT_RI_CD)*/ )
        LOOP
            rep.policy_no   := i.policy_no;
            
            FOR h IN (SELECT DISTINCT treaty_name
                        FROM TABLE(GICLR222E_PKG.GET_TREATY_RI(P_SESSION_ID, P_CLAIM_ID, P_POLICY_NO))
                       WHERE RI_CD <> P_RI_CD
                         AND GRP_SEQ_NO NOT IN (SELECT GRP_SEQ_NO
                                                  FROM (SELECT DISTINCT A.RI_CD, A.LINE_CD, A.GRP_SEQ_NO,
                                                               DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD
                                                          FROM GICL_RES_BRDRX_RIDS_EXTR A,
                                                               GIIS_TRTY_PANEL B,
                                                               GICL_RES_BRDRX_EXTR C,
                                                               GICL_RES_BRDRX_DS_EXTR D
                                                         WHERE A.GRP_SEQ_NO <> 999
                                                           AND  A.SESSION_ID = P_SESSION_ID
                                                           AND A.SESSION_ID = C.SESSION_ID
                                                           AND A.SESSION_ID = D.SESSION_ID
                                                           AND C.BRDRX_RECORD_ID = D.BRDRX_RECORD_ID
                                                           AND A.BRDRX_DS_RECORD_ID = D.BRDRX_DS_RECORD_ID
                                                           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                                                           AND A.LINE_CD = B.LINE_CD
                                                           AND A.GRP_SEQ_NO = B.TRTY_SEQ_NO
                                                           AND A.RI_CD = B.RI_CD
                                                           --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                                                           AND NVL(A.EXPENSES_PAID,0) > 0 
                                                           AND C.POLICY_NO = i.POLICY_NO
                                                         MINUS
                                                        SELECT DISTINCT A.RI_CD, A.LINE_CD, A.GRP_SEQ_NO,
                                                               DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD
                                                          FROM GICL_RES_BRDRX_RIDS_EXTR A,
                                                               GIIS_TRTY_PANEL B,
                                                               GICL_RES_BRDRX_EXTR C,
                                                               GICL_RES_BRDRX_DS_EXTR D
                                                         WHERE A.GRP_SEQ_NO <> 999
                                                           AND  A.SESSION_ID = P_SESSION_ID
                                                           AND A.SESSION_ID = C.SESSION_ID
                                                           AND A.SESSION_ID = D.SESSION_ID
                                                           AND C.BRDRX_RECORD_ID = D.BRDRX_RECORD_ID
                                                           AND A.BRDRX_DS_RECORD_ID = D.BRDRX_DS_RECORD_ID
                                                           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                                                           AND A.LINE_CD = B.LINE_CD
                                                           AND A.GRP_SEQ_NO = B.TRTY_SEQ_NO
                                                           AND A.RI_CD = B.RI_CD
                                                           --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0  
                                                           AND NVL(A.EXPENSES_PAID,0) > 0
                                                           AND C.POLICY_NO = i.POLICY_NO
                                                           AND A.RI_CD <> P_RI_CD)))
            LOOP
                rep.treaty_name     := h.treaty_name;
                PIPE ROW(rep);
            END LOOP;
            
            FOR j IN (SELECT DISTINCT A.RI_CD, A.LINE_CD, A.GRP_SEQ_NO, A.BRDRX_RIDS_RECORD_ID,
                             DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD) TRTY_RI_CD
                        FROM GICL_RES_BRDRX_RIDS_EXTR A,
                             GIIS_TRTY_PANEL B,
                             GICL_RES_BRDRX_EXTR C,
                             GICL_RES_BRDRX_DS_EXTR D
                       WHERE A.GRP_SEQ_NO <> 999
                         AND  A.SESSION_ID = P_SESSION_ID
                         AND A.SESSION_ID = C.SESSION_ID
                         AND A.SESSION_ID = D.SESSION_ID
                         AND C.BRDRX_RECORD_ID = D.BRDRX_RECORD_ID
                         AND A.BRDRX_DS_RECORD_ID = D.BRDRX_DS_RECORD_ID
                         AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                         AND A.LINE_CD = B.LINE_CD
                         AND A.GRP_SEQ_NO = B.TRTY_SEQ_NO
                         AND A.RI_CD = B.RI_CD
                         --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0  
                         AND NVL(A.EXPENSES_PAID,0) > 0
                         AND C.POLICY_NO = i.POLICY_NO
                         AND A.RI_CD = NVL(P_RI_CD, A.RI_CD)
                       ORDER BY A.GRP_SEQ_NO, A.RI_CD,
                                DECODE(A.PRNT_RI_CD, NULL, A.RI_CD, A.PRNT_RI_CD),
                                A.BRDRX_RIDS_RECORD_ID) 
                LOOP
                    rep.line_cd                 := j.line_cd;
                    rep.grp_seq_no              := j.grp_seq_no;
                    rep.ri_cd                   := j.ri_cd;
                    rep.trty_ri_cd              := j.trty_ri_cd;
                    rep.BRDRX_RIDS_RECORD_ID    := j.BRDRX_RIDS_RECORD_ID;
                    
                    rep.treaty_name     := TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
                    rep.ri_name         := FACUL_RI_NAMEFormula(j.ri_cd);                
                    rep.trty_shr_pct    := RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);
                                   
                    FOR l IN (SELECT DISTINCT A.LINE_CD, A.GRP_SEQ_NO, B.POLICY_NO
                                FROM GICL_RES_BRDRX_DS_EXTR A,
                                     GICL_RES_BRDRX_EXTR B
                               WHERE A.GRP_SEQ_NO NOT IN (1,999)
                                 AND A.SESSION_ID = P_SESSION_ID
                                 AND A.SESSION_ID = B.SESSION_ID
                                 AND A.BRDRX_RECORD_ID = B.BRDRX_RECORD_ID
                                 AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                                 --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                                 AND NVL(A.EXPENSES_PAID,0) > 0 
                                 AND B.POLICY_NO = i.POLICY_NO
                               ORDER BY A.GRP_SEQ_NO)
                    LOOP            
                        FOR n IN (SELECT A.BRDRX_RIDS_RECORD_ID, A.GRP_SEQ_NO, NVL(A.EXPENSES_PAID,0) PAID_LOSSES
                                    FROM GICL_RES_BRDRX_RIDS_EXTR A
                                   WHERE A.GRP_SEQ_NO <> 999
                                     AND A.SESSION_ID = P_SESSION_ID
                                     --AND ABS(NVL(A.EXPENSES_PAID,0)) > 0
                                     AND NVL(A.EXPENSES_PAID,0) > 0 
                                     AND A.GRP_SEQ_NO = l.GRP_SEQ_NO
                                     AND A.BRDRX_RIDS_RECORD_ID = j.BRDRX_RIDS_RECORD_ID
                                   ORDER BY A.GRP_SEQ_NO, A.BRDRX_RIDS_RECORD_ID )
                        LOOP                        
                            rep.paid_losses3    := n.PAID_LOSSES;
                            
                            PIPE ROW(rep);                   
                        END LOOP;
                        
                    END LOOP; 
                                        
                END LOOP;
                
        END LOOP;
        
    END get_treaty_ri_amt;
    
    -- marco
    -- added functions below for matrix fix
    
   FUNCTION get_giclr222e_header(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN giclr222e_header_tab PIPELINED
   IS
      v_row                giclr222e_header_type;
      v_treaty_tab         treaty_tab;
      v_index              NUMBER := 0;
      v_id                 NUMBER := 0;
   BEGIN
      FOR i IN(SELECT DISTINCT a.policy_no,
                      a.assd_no,
                      TRUNC(a.incept_date) incept_date,
                      TRUNC(a.expiry_date) expiry_date,
                      a.line_cd, a.ref_pol_no
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id 
                  AND a.claim_id = NVL(p_claim_id, a.claim_id) 
                  AND NVL(A.EXPENSES_PAID,0) > 0
                ORDER BY a.policy_no)
      LOOP
         v_id := 0;
         v_index := 0;
         v_treaty_tab := treaty_tab();
         
         FOR b IN(SELECT DISTINCT a.grp_seq_no, a.line_cd, b.policy_no, c.trty_name
                    FROM GICL_RES_BRDRX_DS_EXTR a,
                         GICL_RES_BRDRX_EXTR b,
                         GIIS_DIST_SHARE c
                   WHERE a.session_id = p_session_id
                     AND a.session_id = b.session_id
                     AND a.brdrx_record_id = b.brdrx_record_id
                     AND a.claim_id = NVL(p_claim_id, a.claim_id)
                     AND NVL(A.expenses_paid, 0) > 0
                     AND c.line_cd = a.line_cd
                     AND c.share_cd = a.grp_seq_no
                     AND c.line_cd = i.line_cd
                     AND b.policy_no = i.policy_no
                   ORDER BY a.grp_seq_no)
         LOOP
            v_index := v_index + 1;
            v_treaty_tab.EXTEND;
            v_treaty_tab(v_index).grp_seq_no := b.grp_seq_no;
            v_treaty_tab(v_index).trty_name := b.trty_name;
         END LOOP;
         
         v_index := 1;
         LOOP
            v_id := v_id + 1;
            v_row := NULL;
            v_row.policy_no := i.policy_no;
            v_row.policy_no_dummy := i.policy_no || '_' || v_id;
            v_row.ref_pol_no := NULL;
            IF REGEXP_SUBSTR(i.ref_pol_no,'[0-9]{2}$') IS NOT NULL AND REGEXP_SUBSTR(i.ref_pol_no,'[0-9]{2}$') != 0 THEN --added by steve 05.19.2014
            v_row.ref_pol_no := i.ref_pol_no;
            END IF;
            v_row.assd_no := i.assd_no;
            v_row.incept_date := i.incept_date;
            v_row.expiry_date := i.expiry_date;
            v_row.term := TO_CHAR(i.incept_date, 'MM-dd-yyyy') || ' - '|| TO_CHAR(i.expiry_date, 'MM-dd-yyyy');
            
            FOR b IN(SELECT c.assd_name
                       FROM GIIS_ASSURED c
                      WHERE c.assd_no = i.assd_no)
            LOOP
               v_row.assd_name := b.assd_name;
               EXIT;
            END LOOP;
            
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
   
   FUNCTION get_giclr222e_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN giclr222e_claim_tab PIPELINED
   IS
      v_row                giclr222e_claim_type;
   BEGIN
      FOR i IN(SELECT DISTINCT a.claim_id, a.claim_no, a.policy_no, a.loss_date, a.item_no --a.brdrx_record_id, 
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id 
                  AND a.claim_id = nvl(p_claim_id,a.claim_id)
                  AND NVL(A.expenses_paid, 0) > 0
                  AND a.policy_no = p_policy_no
                ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.policy_no := i.policy_no;
         v_row.loss_date := i.loss_date;
         v_row.item_no := i.item_no;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr222e_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN giclr222e_item_main_tab PIPELINED
   IS
      v_row                giclr222e_item_main_type;
   BEGIN
      FOR i IN(SELECT DISTINCT a.claim_id, a.claim_no, a.policy_no, a.loss_date,
                      a.line_cd, a.item_no, a.grouped_item_no 
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id 
                  AND a.claim_id = nvl(p_claim_id,a.claim_id)
                  AND NVL(A.expenses_paid, 0) > 0
                  AND a.policy_no = p_policy_no
                ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.policy_no := i.policy_no;
         v_row.loss_date := i.loss_date;
         v_row.item_no := i.item_no;
         v_row.item_title := CPI.get_gpa_item_title(i.claim_id, i.line_cd, i.item_no, i.grouped_item_no);
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr222e_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr222e_item_tab PIPELINED
   IS
      v_row                giclr222e_item_type;
   BEGIN
      FOR i IN(SELECT a.brdrx_record_id, a.claim_id, a.claim_no, a.policy_no, a.loss_date,
                      a.clm_loss_id, a.tsi_amt, a.loss_cat_cd, a.intm_no, NVL(a.expenses_paid, 0) paid_losses,
                      a.line_cd, a.item_no, a.peril_cd, a.grouped_item_no
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id 
                  AND a.claim_id = nvl(p_claim_id,a.claim_id)
                  AND NVL(A.expenses_paid, 0) > 0
                  AND a.policy_no = p_policy_no
                  AND a.item_no = p_item_no
                ORDER BY a.claim_no)
      LOOP
         v_row := NULL;
         v_row.record_id := i.brdrx_record_id;
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.policy_no := i.policy_no;
         v_row.loss_date := i.loss_date;
         v_row.clm_loss_id := i.clm_loss_id;
         v_row.tsi_amt := NVL(i.tsi_amt,0); --added by steve 05.19.2014
         v_row.loss_cat_cd := i.loss_cat_cd;
         v_row.intm_no := i.intm_no;
         v_row.paid_losses := NVL(i.paid_losses,0);
         v_row.item_no := i.item_no;
         v_row.peril_cd := i.peril_cd;
         
         BEGIN
            SELECT loss_cat_des
              INTO v_row.loss_cat_desc
              FROM GIIS_LOSS_CTGRY
             WHERE loss_cat_cd  = i.loss_cat_cd
               AND line_cd = i.line_cd;
         END;
         
         v_row.dv_no := gicls202_pkg.get_voucher_check_no(i.claim_id, i.item_no, i.peril_cd, i.grouped_item_no, p_from_date, p_to_date, p_paid_date, 'E');
         v_row.intm_name := giclr222e_pkg.CF_INTM_RIFormula(i.claim_id, i.item_no, i.peril_cd);
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr222e_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN paid_losses_tab PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;
      TYPE t_table IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      cur                  ref_cursor;
      v_row                paid_losses_type;
      v_index              NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_cnt                NUMBER := 0;
      
      TYPE t_tab IS TABLE OF paid_losses_type INDEX BY PLS_INTEGER;
      v_tab                t_tab;
   BEGIN
      v_table := t_table();
      FOR i IN(SELECT policy_no, grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR222E_PKG.get_giclr222e_header(p_session_id, null, p_user_id)) --remove the p_claim_id para same dun sa pagkuha sa header::: steve 05.19.2014
                WHERE policy_no_dummy = p_policy_no)
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
               v_cnt := c;
               EXIT;
            END IF;
            
            v_index := 1;
            FOR d IN(SELECT brdrx_ds_record_id, paid_losses
                       FROM TABLE(GICLR222E_PKG.get_treaty_details(p_session_id, p_claim_id, i.policy_no, p_brdrx_record_id))
                      WHERE grp_seq_no = v_grp_seq_no)
            LOOP
               IF c = 1 THEN
                  v_tab(v_index).paid_losses1 := d.paid_losses;
               ELSIF c = 2 THEN
                  v_tab(v_index).paid_losses2 := d.paid_losses;
               ELSIF c = 3 THEN
                  v_tab(v_index).paid_losses3 := d.paid_losses;
               ELSIF c = 4 THEN
                  v_tab(v_index).paid_losses4 := d.paid_losses;
               END IF;
               v_tab(v_index).ds_record_id := d.brdrx_ds_record_id;
               v_index := v_index + 1;
            END LOOP;
         END LOOP;
      END LOOP;
      
      v_index := v_tab.FIRST;
      WHILE v_index IS NOT NULL
      LOOP
         v_row := NULL;
         IF v_cnt = 1 THEN
             v_row.paid_losses1 := v_tab(v_index).paid_losses1;--added by steve 05.19.2014
             v_row.paid_losses2 := v_tab(v_index).paid_losses2;
             v_row.paid_losses3 := v_tab(v_index).paid_losses3;
             v_row.paid_losses4 := v_tab(v_index).paid_losses4;
         ELSIF v_cnt = 2  THEN
             v_row.paid_losses1 := NVL(v_tab(v_index).paid_losses1,0);--added by steve 05.19.2014
             v_row.paid_losses2 := v_tab(v_index).paid_losses2;
             v_row.paid_losses3 := v_tab(v_index).paid_losses3;
             v_row.paid_losses4 := v_tab(v_index).paid_losses4;
         ELSIF v_cnt = 3  THEN
             v_row.paid_losses1 := NVL(v_tab(v_index).paid_losses1,0);--added by steve 05.19.2014
             v_row.paid_losses2 := NVL(v_tab(v_index).paid_losses2,0);
             v_row.paid_losses3 := v_tab(v_index).paid_losses3;
             v_row.paid_losses4 := v_tab(v_index).paid_losses4;
         ELSIF v_cnt = 4  THEN
             v_row.paid_losses1 := NVL(v_tab(v_index).paid_losses1,0);--added by steve 05.19.2014
             v_row.paid_losses2 := NVL(v_tab(v_index).paid_losses2,0);
             v_row.paid_losses3 := NVL(v_tab(v_index).paid_losses3,0);
             v_row.paid_losses4 := v_tab(v_index).paid_losses4;
         ELSE
             v_row.paid_losses1 := NVL(v_tab(v_index).paid_losses1,0);--added by steve 05.19.2014
             v_row.paid_losses2 := NVL(v_tab(v_index).paid_losses2,0);
             v_row.paid_losses3 := NVL(v_tab(v_index).paid_losses3,0);
             v_row.paid_losses4 := NVL(v_tab(v_index).paid_losses4,0);
         END IF;
--         v_row.paid_losses1 := v_tab(v_index).paid_losses1;
--         v_row.paid_losses2 := v_tab(v_index).paid_losses2;
--         v_row.paid_losses3 := v_tab(v_index).paid_losses3;
--         v_row.paid_losses4 := v_tab(v_index).paid_losses4;
         v_row.ds_record_id := v_tab(v_index).ds_record_id;
         PIPE ROW(v_row);
         v_index := v_tab.NEXT(v_index);
      END LOOP;
   END;
   
   FUNCTION get_giclr222e_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
   BEGIN
      FOR i IN(SELECT policy_no, grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR222E_PKG.get_giclr222e_header(p_session_id, p_claim_id, p_user_id))
                WHERE policy_no_dummy = p_policy_no)
      LOOP
         FOR b IN(SELECT *
                    FROM TABLE(GICLR222E_PKG.get_treaty_facul(p_session_id, p_claim_id, i.policy_no, p_brdrx_record_id))
                   WHERE grp_seq_no IN (i.grp_seq_no1, i.grp_seq_no2, i.grp_seq_no3, i.grp_seq_no4)
                     AND grp_seq_no = 999
                     AND facul_ri_cd IS NOT NULL
                     AND brdrx_ds_record_id = p_ds_record_id)
         LOOP
            v_row := NULL;
            IF p_grp_seq_no1 = 999 THEN
               v_row.ri_name1 := b.facul_ri_name;
               v_row.paid_losses1 := NVL(b.paid_losses2,0); --added by steve 05.19.2014
            ELSIF p_grp_seq_no2 = 999 THEN
               v_row.ri_name2 := b.facul_ri_name;
               v_row.paid_losses2 := NVL(b.paid_losses2,0);
            ELSIF p_grp_seq_no3 = 999 THEN
               v_row.ri_name3 := b.facul_ri_name;
               v_row.paid_losses3 := NVL(b.paid_losses2,0);
            ELSIF p_grp_seq_no4 = 999 THEN
               v_row.ri_name4 := b.facul_ri_name;
               v_row.paid_losses4 := NVL(b.paid_losses2,0);
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr222e_loss_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN NUMBER
   IS
      v_total              GICL_RES_BRDRX_EXTR.expenses_paid%TYPE;
   BEGIN
      SELECT SUM(NVL(a.expenses_paid, 0)) total_paid_losses
        INTO v_total
        FROM GICL_RES_BRDRX_EXTR a
       WHERE a.session_id = p_session_id 
         AND a.claim_id = NVL(p_claim_id, a.claim_id)
         AND NVL(A.expenses_paid, 0) > 0
         AND a.policy_no = p_policy_no
       ORDER BY a.claim_no;
       
      RETURN v_total;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN 0;
   END;
   
   FUNCTION get_giclr222e_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN paid_losses_tab_v PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;
      TYPE t_table IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      cur                  ref_cursor;
      v_row                paid_losses_type_v;
      v_index              NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
   BEGIN
      v_table := t_table();
      FOR i IN(SELECT policy_no, grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR222E_PKG.get_giclr222e_header(p_session_id, p_claim_id, p_user_id))
                WHERE policy_no_dummy = p_policy_no)
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
         
            v_loop := 'SELECT SUM(paid_losses)
                         FROM (SELECT paid_losses ' ||
                               ' FROM TABLE(GICLR222E_PKG.get_treaty_facul2(' || p_session_id || ', :A ,'''
                                                                              || i.policy_no || ''', :B))' ||
                              ' WHERE grp_seq_no = ' || v_grp_seq_no ||
                              ' GROUP BY brdrx_ds_record_id, paid_losses)';
            
            OPEN cur FOR v_loop USING -1, -1;
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
         v_row.paid_losses1 := NVL(v_table(v_index),0); --added by steve 05.19.2014
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses2 := NVL(v_table(v_index),0);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses3 := NVL(v_table(v_index),0);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses4 := NVL(v_table(v_index),0);
         v_index := v_index + 1;
      END IF;
      
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED
   AS
      rep                  treaty_ri_type2;
   BEGIN
      FOR j IN (SELECT DISTINCT a.ri_cd, a.line_cd, a.grp_seq_no,
                       DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd, policy_no
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
                   AND a.claim_id = NVL(p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.trty_seq_no
                   AND a.ri_cd = b.ri_cd
                   AND NVL(a.expenses_paid, 0) > 0 
                   AND c.policy_no = p_policy_no
                 ORDER BY a.grp_seq_no, a.ri_cd, DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         rep.policy_no := j.policy_no;
         rep.line_cd := j.line_cd;
         rep.grp_seq_no := j.grp_seq_no;
         rep.ri_cd := j.ri_cd;
         rep.trty_ri_cd := j.trty_ri_cd;
         rep.treaty_name := TREATY_NAMEFormula(j.grp_seq_no, j.line_cd);
         rep.ri_name := FACUL_RI_NAMEFormula(j.ri_cd);                
         rep.trty_shr_pct := RI_SHRFormula(j.line_cd, j.grp_seq_no, j.ri_cd);
         rep.paid_losses := 0;
                
         FOR a IN (SELECT NVL(SUM(a.expenses_paid),0) paid_losses
                     FROM GICL_RES_BRDRX_RIDS_EXTR a
                    WHERE a.grp_seq_no <> 999
                      AND a.session_id = p_session_id
                      AND NVL(a.expenses_paid, 0) > 0
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
                                                       AND NVL(a.expenses_paid, 0) > 0 
                                                       AND c.policy_no = p_policy_no)
                    ORDER BY a.grp_seq_no, a.brdrx_rids_record_id)
         LOOP
            rep.paid_losses := NVL(a.paid_losses,0);
         END LOOP;
                 
         PIPE ROW(rep);
      END LOOP;
    END get_treaty_ri2;
    
    FUNCTION get_treaty_facul2(
        p_session_id       GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
        p_claim_id         GICL_RES_BRDRX_EXTR.claim_id%TYPE,
        p_policy_no        GICL_RES_BRDRX_EXTR.policy_no%TYPE,
        p_brdrx_record_id  GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
    )
      RETURN treaty_details_tab PIPELINED
    AS
        rep                treaty_details_type;
    BEGIN
        FOR c IN (SELECT a.policy_no, a.claim_id, a.brdrx_record_id, a.peril_cd
                    FROM GICL_RES_BRDRX_EXTR A
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id) ,a.claim_id)
                     AND NVL(a.expenses_paid,0) > 0
                     AND a.policy_no = NVL(p_policy_no, a.policy_no)
                     AND a.brdrx_record_id = NVL(DECODE(p_brdrx_record_id, -1, a.brdrx_record_id, p_brdrx_record_id), a.brdrx_record_id)
                   ORDER BY a.policy_no, a.claim_no)
        LOOP
            rep.policy_no := c.policy_no;            
            rep.claim_id := c.claim_id;
            
            FOR f IN (SELECT DISTINCT a.grp_seq_no, a.line_cd, b.policy_no
                        FROM GICL_RES_BRDRX_DS_EXTR A,
                             GICL_RES_BRDRX_EXTR B
                       WHERE a.session_id = p_session_id
                         AND a.session_id = b.session_id
                         AND a.brdrx_record_id = b.brdrx_record_id
                         AND a.claim_id = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id) ,a.claim_id)
                         AND b.policy_no = c.policy_no
                         AND a.brdrx_record_id = c.brdrx_record_id
                       ORDER BY a.grp_seq_no)
            LOOP
                rep.treaty_name     := TREATY_NAMEFormula(f.grp_seq_no, f.line_cd);
               
                FOR h IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.grp_seq_no,
                                 a.shr_pct, NVL(a.expenses_paid,0) paid_losses
                            FROM GICL_RES_BRDRX_DS_EXTR A
                           WHERE a.session_id = p_session_id
                             AND NVL(a.expenses_paid,0) > 0
                             AND a.grp_seq_no = f.grp_seq_no 
                             AND a.brdrx_record_id = c.brdrx_record_id
                           ORDER BY a.grp_seq_no)
                LOOP
                    rep.brdrx_record_id := h.brdrx_record_id;
                    rep.brdrx_ds_record_id := h.brdrx_ds_record_id;
                    rep.grp_seq_no := h.grp_seq_no;
                    rep.shr_pct := h.shr_pct;
                    rep.paid_losses := h.paid_losses;
                    
                    PIPE ROW(rep);                  
                END LOOP;
            END LOOP;  
        END LOOP;
    END get_treaty_facul2;
   
END GICLR222E_PKG;
/


