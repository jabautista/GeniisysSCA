CREATE OR REPLACE PACKAGE BODY CPI.GICLR222L_PKG
AS

    /**
    **  Created By:     Shan Bati
    **  Date Created:   03.19.2013
    **  Referenced BY:  GICLR222L - LOSSES PAID BORDEREAUX (PER POLICY)
    **/
    
    
    FUNCTION CF_companyFormula
        RETURN VARCHAR2
    AS
         v_name        varchar2(500); --varchar2(50) changed to varchar2(500) by Kevin 4-21-2016 SR-5366
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
        V_REPORT_TITLE      giis_reports.REPORT_TITLE%type; --varchar2(50) changed to giis_reports.REPORT_TITLE%type by Kevin 4-21-2016 SR-5366
    BEGIN
        BEGIN
            select report_title
              into v_report_title
              from giis_reports
             where report_id = 'GICLR222L';
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
    
    FUNCTION get_grand_total(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type
    ) RETURN NUMBER
    AS
      v_grand_total NUMBER;
    BEGIN
        BEGIN
            SELECT SUM (ABS (NVL (a.losses_paid, 0)))
              INTO v_grand_total
              FROM gicl_res_brdrx_extr a
             WHERE a.session_id = p_session_id AND ABS (NVL (a.losses_paid, 0)) > 0;
        EXCEPTION
            WHEN OTHERS THEN 
                v_grand_total := 0;
        END;
        RETURN v_grand_total;    
    END;
    
    
    FUNCTION get_report_header(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
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
        tab.grand_total     := get_grand_total(p_session_id);
        
        PIPE ROW(tab);        
    END get_report_header;
     
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
                            WHERE a.tran_id             = b.gacc_tran_id
                              AND a.tran_id             = d.gacc_tran_id
                              AND c.tran_id             = d.reversing_tran_id 
                              AND b.gacc_tran_id = e.gacc_tran_id
                              AND e.item_no             = p_item_no
                              AND a.claim_id         = p_claim_id
                              AND a.clm_loss_id     = p_clm_loss_id
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
            ELSE 
                FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999'))||' /'||e.check_no dv_no
                             FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                                  giac_direct_claim_payts c, giac_acctrans d,
                                  giac_chk_disbursement e
                            WHERE a.tran_id             = d.tran_id    
                              AND b.gacc_tran_id = c.gacc_tran_id
                              AND b.gacc_tran_id = d.tran_id
                              AND b.gacc_tran_id = e.gacc_tran_id
                              AND e.item_no            = p_item_no
                              AND a.claim_id       = p_claim_id 
                              AND a.clm_loss_id     = p_clm_loss_id
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
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_header_part       NUMBER
    )RETURN treaty_header_tab PIPELINED
    AS
        
        rep     treaty_header_type;
    BEGIN
        IF p_header_part = 1 THEN        
            FOR c IN (SELECT *
                      FROM (SELECT ROWNUM row_num, z.*
                              FROM (SELECT DISTINCT A.GRP_SEQ_NO, A.LINE_CD, B.POLICY_NO
                                            FROM GICL_RES_BRDRX_DS_EXTR A,
                                                 GICL_RES_BRDRX_EXTR B
                                           WHERE A.SESSION_ID = p_session_id
                                             AND A.SESSION_ID = B.SESSION_ID
                                             AND A.BRDRX_RECORD_ID = B.BRDRX_RECORD_ID
                                             AND A.CLAIM_ID = NVL(p_claim_id, A.CLAIM_ID)
                                             AND B.POLICY_NO = NVL(p_policy_no, B.POLICY_NO)
                                             AND ABS(NVL(A.LOSSES_PAID, 0)) > 0
                                           ORDER BY A.GRP_SEQ_NO
                                    ) z
                           ) 
                      WHERE row_num BETWEEN 1 AND 4
            )
            LOOP
                rep.policy_no       := c.policy_no;
                rep.treaty_name     := TREATY_NAMEFormula(c.grp_seq_no, c.line_cd);
                rep.line_cd         := c.line_cd;
                rep.grp_seq_no      := c.grp_seq_no;
                
                PIPE ROW(rep);
            END LOOP;
        ELSIF p_header_part = 2 THEN
            FOR c IN (SELECT *
                      FROM (SELECT ROWNUM row_num, z.*
                              FROM (SELECT DISTINCT A.GRP_SEQ_NO, A.LINE_CD, B.POLICY_NO
                                            FROM GICL_RES_BRDRX_DS_EXTR A,
                                                 GICL_RES_BRDRX_EXTR B
                                           WHERE A.SESSION_ID = p_session_id
                                             AND A.SESSION_ID = B.SESSION_ID
                                             AND A.BRDRX_RECORD_ID = B.BRDRX_RECORD_ID
                                             --AND A.CLAIM_ID = NVL(p_claim_id, A.CLAIM_ID)
                                             AND B.POLICY_NO = NVL(p_policy_no, B.POLICY_NO)
                                             AND ABS(NVL(A.LOSSES_PAID, 0)) > 0
                                           ORDER BY A.GRP_SEQ_NO
                                    ) z
                           ) 
                      WHERE row_num BETWEEN 5 AND 8
            )
            LOOP
                rep.policy_no       := c.policy_no;
                rep.treaty_name     := TREATY_NAMEFormula(c.grp_seq_no, c.line_cd);
                rep.line_cd         := c.line_cd;
                rep.grp_seq_no      := c.grp_seq_no;
                
                PIPE ROW(rep);
            END LOOP;        
        END IF;        
    END get_treaty_header;           
    
    FUNCTION get_treaty_ri(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type
    ) RETURN treaty_ri_tab PIPELINED
    AS
        rep     treaty_ri_type;
    BEGIN
        FOR i IN (
            SELECT   a.grp_seq_no,
                     DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd,
                     a.ri_cd, b.trty_shr_pct, c.policy_no, a.line_cd,
                     e.trty_name, f.ri_sname, SUM (NVL (a.losses_paid, 0)) paid_losses
                FROM gicl_res_brdrx_rids_extr a,
                     giis_trty_panel b,
                     gicl_res_brdrx_extr c,
                     gicl_res_brdrx_ds_extr d,
                     giis_dist_share e,
                     giis_reinsurer f
               WHERE a.grp_seq_no <> 999
                 AND a.session_id = p_session_id
                 AND a.session_id = c.session_id
                 AND a.session_id = d.session_id
                 AND c.brdrx_record_id = d.brdrx_record_id
                 AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                 AND a.line_cd = b.line_cd
                 AND a.grp_seq_no = b.trty_seq_no
                 AND a.ri_cd = b.ri_cd
                 AND NVL (a.losses_paid, 0) > 0
                 AND a.grp_seq_no = e.share_cd
                 AND a.line_cd = e.line_cd
                 AND c.policy_no = p_policy_no
                 AND f.ri_cd = a.ri_cd
            GROUP BY a.grp_seq_no,
                     DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd),
                     a.ri_cd,
                     b.trty_shr_pct,
                     c.policy_no,
                     a.line_cd,
                     e.trty_name,
                     f.ri_sname
            ORDER BY a.grp_seq_no, DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
        LOOP
            rep.policy_no       := i.policy_no;
            rep.line_cd         := i.line_cd;
            rep.grp_seq_no      := i.grp_seq_no;
            rep.ri_cd           := i.ri_cd;
            rep.trty_ri_cd      := i.trty_ri_cd;                
            rep.treaty_name     := i.trty_name;
            rep.ri_name         := i.ri_sname;
            rep.paid_losses     := i.paid_losses;                      
            rep.trty_shr_pct    := i.trty_shr_pct;
                    
            PIPE ROW(rep);
            
        END LOOP;
        
    END get_treaty_ri;
    
    FUNCTION cf_perilnameformula(p_peril_cd giis_peril.peril_cd%TYPE, p_line_cd giis_line.line_cd%TYPE)
       RETURN VARCHAR2
    IS
       v_peril_name   giis_peril.peril_name%TYPE;
    BEGIN
       BEGIN
          SELECT peril_name
            INTO v_peril_name
            FROM giis_peril
           WHERE peril_cd = p_peril_cd AND line_cd = p_line_cd;
       EXCEPTION
          WHEN OTHERS
          THEN
             v_peril_name := NULL;
       END;

       RETURN v_peril_name;
    END;         

    FUNCTION get_claims (
       p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_paid_date     NUMBER,
       p_from_date     DATE,
       p_to_date       DATE
    )
       RETURN pol_tab PIPELINED
    AS
       v_cur SYS_REFCURSOR;
       v_rec            pol_type;
       v_treaty_count   NUMBER (3);
       v_query VARCHAR2(5000);
       v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    BEGIN
       FOR i IN (
         SELECT   *
            FROM (SELECT *
                    FROM (SELECT DISTINCT a.policy_no dummy_pol_no, a.policy_no,
                                          a.assd_no, 1 header_part,
                                          TRUNC (a.incept_date) incept_date,
                                          TRUNC (a.expiry_date) expiry_date,
                                          a.claim_id, a.line_cd,
                                          a.claim_no, a.loss_date, a.clm_file_date,                                          
                                          a.ref_pol_no
                                     FROM gicl_res_brdrx_extr a
                                    WHERE a.session_id = p_session_id
                                      AND ABS (NVL (a.losses_paid, 0)) > 0
                                 ORDER BY claim_id)
                  UNION ALL
                  SELECT *
                    FROM (SELECT DISTINCT a.policy_no || '1' dummy_pol_no,
                                          a.policy_no, a.assd_no, 2 header_part,
                                          TRUNC (a.incept_date) incept_date,
                                          TRUNC (a.expiry_date) expiry_date,
                                          a.claim_id, a.line_cd,
                                          a.claim_no, a.loss_date, a.clm_file_date,
                                          a.ref_pol_no
                                     FROM gicl_res_brdrx_extr a
                                    WHERE a.session_id = p_session_id
                                      AND ABS (NVL (a.losses_paid, 0)) > 0
                                      AND (SELECT COUNT (DISTINCT y.grp_seq_no)
                                             FROM gicl_res_brdrx_ds_extr y,
                                                  gicl_res_brdrx_extr z
                                            WHERE y.session_id = a.session_id
                                              AND y.session_id = z.session_id
                                              AND y.brdrx_record_id =
                                                                     z.brdrx_record_id
                                              AND z.policy_no = a.policy_no
                                              AND ABS (NVL (y.losses_paid, 0)) > 0) >
                                                                                     4
                                 ORDER BY claim_id)
               ) ORDER BY dummy_pol_no, claim_no
       )
       LOOP
         BEGIN
            SELECT b.ref_pol_no
              INTO v_ref_pol_no
              FROM GICL_CLAIMS a, GIPI_POLBASIC b
             WHERE a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.pol_iss_cd = b.iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND b.endt_seq_no = 0
               AND a.claim_id = i.claim_id
               AND ref_pol_no IS NOT NULL;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_ref_pol_no := NULL;
         END;
         v_rec.dummy_pol_no := i.dummy_pol_no;
         v_rec.policy_no := i.policy_no;
         v_rec.assd_no := i.assd_no;
         v_rec.header_part := i.header_part;
         v_rec.incept_date := TO_CHAR(i.incept_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-YYYY');
         v_rec.claim_id := i.claim_id;
         v_rec.line_cd := i.line_cd;
         v_rec.claim_no := i.claim_no;
         v_rec.loss_date := i.loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.ref_pol_no := v_ref_pol_no;
         v_rec.assd_name := GICLR222L_PKG.ASSD_NAMEFORMULA(v_rec.assd_no);
          
         PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;
    
    FUNCTION get_items (
       p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
       p_paid_date     NUMBER,
       p_from_date     DATE,
       p_to_date       DATE
    )
       RETURN pol_tab PIPELINED
    AS
       v_rec   pol_type;
    BEGIN
       FOR i IN (SELECT DISTINCT a.item_no, a.line_cd, a.grouped_item_no
                            FROM gicl_res_brdrx_extr a
                           WHERE a.session_id = p_session_id
                             AND a.claim_id = NVL (p_claim_id, a.claim_id)
                             AND ABS (NVL (a.losses_paid, 0)) > 0
                        ORDER BY item_no)
       LOOP
          v_rec.item_no := i.item_no;
          v_rec.item_title :=
             giclr222l_pkg.item_titleformula (p_claim_id,
                                              i.line_cd,
                                              i.item_no,
                                              i.grouped_item_no
                                             );
          PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;

    FUNCTION get_perils (
       p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
       p_item_no           gicl_res_brdrx_extr.item_no%TYPE,
       p_paid_date     NUMBER,
       p_from_date     DATE,
       p_to_date       DATE
    )
       RETURN pol_tab PIPELINED
    AS
       v_rec   pol_type;
       v_count NUMBER := 0;
    BEGIN
       FOR i IN (SELECT DISTINCT a.peril_cd, a.line_cd, a.loss_cat_cd, a.tsi_amt,
                                 a.intm_no, a.clm_loss_id,
                                 NVL (a.losses_paid, 0) paid_losses,
                                 a.ref_pol_no, a.grouped_item_no, a.brdrx_record_id
                            FROM gicl_res_brdrx_extr a
                           WHERE a.session_id = p_session_id
                             AND a.claim_id = NVL (p_claim_id, a.claim_id)
                             AND ABS (NVL (a.losses_paid, 0)) > 0
                             AND a.item_no = p_item_no)
       LOOP
          v_rec.peril_cd := i.peril_cd;
          v_rec.tsi_amt := i.tsi_amt;
          v_rec.loss_cat_cd := i.loss_cat_cd;
          v_rec.paid_losses := i.paid_losses;
          v_rec.loss_cat_des := cf_perilnameformula (i.peril_cd, i.line_cd);
          v_rec.cf_intm_ri :=
              giclr222l_pkg.cf_intm_riformula (p_claim_id, p_item_no, i.peril_cd);
          v_rec.cf_dv_no := gicls202_pkg.get_voucher_check_no(p_claim_id, p_item_no, i.peril_cd, 
                                                              i.grouped_item_no, p_from_date, p_to_date, 
                                                              p_paid_date, 'L');
          v_rec.brdrx_record_id := i.brdrx_record_id;
          v_count := v_count + 1;
          PIPE ROW (v_rec);
       END LOOP;
       
           FOR i IN (SELECT DISTINCT NVL (a.losses_paid, 0) paid_losses
                                FROM gicl_res_brdrx_extr a
                               WHERE a.session_id = p_session_id
                                 AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                 AND ABS (NVL (a.losses_paid, 0)) > 0
                                 AND a.brdrx_record_id <> v_rec.brdrx_record_id)
           LOOP
              v_rec.peril_cd := '';
              v_rec.tsi_amt := '';
              v_rec.loss_cat_cd := '';
              IF v_count = 1
              THEN
                v_rec.paid_losses := i.paid_losses;
              ELSE
                v_rec.paid_losses := '';
              END IF;
              v_rec.loss_cat_des := '';
              v_rec.cf_intm_ri := '';
              v_rec.cf_dv_no := '1';
              v_rec.brdrx_record_id := '';
              PIPE ROW (v_rec);
           END LOOP;

       RETURN;
    END;
        
    FUNCTION get_treaty_details(
      p_session_id GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id GICL_RES_BRDRX_DS_EXTR.claim_id%TYPE,
      p_policy_no GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_header_part NUMBER,
      p_brdrx_record_id GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%TYPE,
      p_cf_dv_no VARCHAR2
    ) RETURN treaty_details_tab PIPELINED AS
      TYPE x IS TABLE OF treaty_details_type INDEX BY PLS_INTEGER;
      v_coll x;
      v_rec         treaty_details_type;
      v_row_count   NUMBER (1);
      v_query VARCHAR2(5000);
      v_index NUMBER;
    BEGIN
      FOR i IN(
        SELECT rownum header_row_num, grp_seq_no FROM TABLE(giclr222L_pkg.get_treaty_header(p_session_id, null, p_policy_no, p_header_part))
      )
      LOOP
        IF p_cf_dv_no = '1'
        THEN
            FOR j IN (
              SELECT  rownum row_num, a.brdrx_ds_record_id, a.grp_seq_no,
                     NVL (a.losses_paid, 0) paid_losses
                FROM gicl_res_brdrx_ds_extr a
               WHERE a.session_id = p_session_id
                 AND ABS (NVL (a.losses_paid, 0)) > 0
                 AND a.claim_id = NVL (p_claim_id, a.claim_id)
                 AND grp_seq_no = i.grp_seq_no
            )
            LOOP          
                  IF i.header_row_num = 1 THEN
                      v_coll(j.row_num).brdrx_ds_record_id1 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses1 := j.paid_losses;
                  ELSIF i.header_row_num = 2 THEN
                      v_coll(j.row_num).brdrx_ds_record_id2 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses2 := j.paid_losses;
                  ELSIF i.header_row_num = 3 THEN
                      v_coll(j.row_num).brdrx_ds_record_id3 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses3 := j.paid_losses;
                  ELSIF i.header_row_num = 4 THEN
                      v_coll(j.row_num).brdrx_ds_record_id4 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses4 := j.paid_losses;
                  END  IF;
            END LOOP;
        ELSE
            FOR j IN (
              SELECT  rownum row_num, a.brdrx_ds_record_id, a.grp_seq_no,
                     NVL (a.losses_paid, 0) paid_losses
                FROM gicl_res_brdrx_ds_extr a
               WHERE a.session_id = p_session_id
                 AND a.brdrx_record_id = p_brdrx_record_id
                 AND ABS (NVL (a.losses_paid, 0)) > 0
                 AND a.claim_id = NVL (p_claim_id, a.claim_id)
                 AND grp_seq_no = i.grp_seq_no
            )
            LOOP          
                  IF i.header_row_num = 1 THEN
                      v_coll(j.row_num).brdrx_ds_record_id1 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses1 := j.paid_losses;
                  ELSIF i.header_row_num = 2 THEN
                      v_coll(j.row_num).brdrx_ds_record_id2 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses2 := j.paid_losses;
                  ELSIF i.header_row_num = 3 THEN
                      v_coll(j.row_num).brdrx_ds_record_id3 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses3 := j.paid_losses;
                  ELSIF i.header_row_num = 4 THEN
                      v_coll(j.row_num).brdrx_ds_record_id4 := j.brdrx_ds_record_id;
                      v_coll(j.row_num).paid_losses4 := j.paid_losses;
                  END  IF;
            END LOOP;
        END IF;
      END LOOP;
      
      v_index := v_coll.FIRST;
      WHILE v_index IS NOT NULL
      LOOP
        v_rec.brdrx_ds_record_id1   := v_coll(v_index).brdrx_ds_record_id1;
        v_rec.paid_losses1          := v_coll(v_index).paid_losses1;
        v_rec.brdrx_ds_record_id2   := v_coll(v_index).brdrx_ds_record_id2;
        v_rec.paid_losses2          := v_coll(v_index).paid_losses2;
        v_rec.brdrx_ds_record_id3   := v_coll(v_index).brdrx_ds_record_id3;
        v_rec.paid_losses3          := v_coll(v_index).paid_losses3;
        v_rec.brdrx_ds_record_id4   := v_coll(v_index).brdrx_ds_record_id4;
        v_rec.paid_losses4          := v_coll(v_index).paid_losses4;
        
        PIPE ROW(v_rec);
        v_index := v_coll.NEXT(v_index);
      END LOOP;
    END;
    
    FUNCTION get_facul(
      p_session_id GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id GICL_RES_BRDRX_DS_EXTR.claim_id%TYPE,
      p_policy_no GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_header_part NUMBER,
      p_brdrx_ds_record_id GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE
    ) RETURN facul_tab PIPELINED AS
      TYPE x IS TABLE OF facul_type INDEX BY PLS_INTEGER;
      v_coll x;
      v_rec         facul_type;
      v_row_count   NUMBER (1);
      v_query VARCHAR2(5000);
      v_index NUMBER;
      v_losses_paid NUMBER;
    BEGIN
      FOR i IN(
        SELECT rownum header_row_num, grp_seq_no FROM TABLE(giclr222L_pkg.get_treaty_header(p_session_id, null, p_policy_no, p_header_part))
      )
      LOOP
        FOR j IN (
          SELECT rownum row_num, z.* 
             FROM (
              SELECT a.brdrx_ds_record_id,
                     DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) facul_ri_cd, b.ri_sname,
                     SUM (a.shr_ri_pct) facul_shr_ri_pct,
                     SUM (NVL (a.losses_paid, 0)) paid_losses
                FROM gicl_res_brdrx_rids_extr a, giis_reinsurer b
               WHERE a.grp_seq_no = 999
                 AND a.session_id = p_session_id
                 AND a.claim_id = NVL (p_claim_id, a.claim_id)
                 AND DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) = b.ri_cd
                 AND a.grp_seq_no = i.grp_seq_no
                 AND ABS (NVL (a.losses_paid, 0)) > 0
                 AND a.brdrx_ds_record_id = p_brdrx_ds_record_id
            GROUP BY a.brdrx_ds_record_id,
                     DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd), b.ri_sname
               ORDER BY a.brdrx_ds_record_id 
            ) z
        )
        LOOP          
              IF i.header_row_num = 1 THEN
                  v_coll(j.row_num).ri_sname1 := j.ri_sname;
                  v_coll(j.row_num).paid_losses1 := j.paid_losses;
              ELSIF i.header_row_num = 2 THEN
                  v_coll(j.row_num).ri_sname2 := j.ri_sname;
                  v_coll(j.row_num).paid_losses2 := j.paid_losses;
              ELSIF i.header_row_num = 3 THEN
                  v_coll(j.row_num).ri_sname3 := j.ri_sname;
                  v_coll(j.row_num).paid_losses3 := j.paid_losses;
              ELSIF i.header_row_num = 4 THEN
                  v_coll(j.row_num).ri_sname4 := j.ri_sname;
                  v_coll(j.row_num).paid_losses4 := j.paid_losses;
              END  IF;
        END LOOP;
      END LOOP;
                             
      v_index := v_coll.FIRST;
      WHILE v_index IS NOT NULL
      LOOP
        v_rec.ri_sname1   := v_coll(v_index).ri_sname1;
        v_rec.paid_losses1:= v_coll(v_index).paid_losses1;
        v_rec.ri_sname2   := v_coll(v_index).ri_sname2;
        v_rec.paid_losses2:= v_coll(v_index).paid_losses2;
        v_rec.ri_sname3   := v_coll(v_index).ri_sname3;
        v_rec.paid_losses3:= v_coll(v_index).paid_losses3;
        v_rec.ri_sname4   := v_coll(v_index).ri_sname4;
        v_rec.paid_losses4:= v_coll(v_index).paid_losses4;
        
        PIPE ROW(v_rec);
        v_index := v_coll.NEXT(v_index);
      END LOOP;
    END;    
    
END GICLR222L_PKG;
/


