CREATE OR REPLACE PACKAGE BODY CPI.GICLR547_pkg
AS

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 08.15.2013
   **  Reference By : GICLR547
   **  Remarks      : Reported Claims Per Enrollee - Detailed
   */  
    FUNCTION cf_intm(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE
    )
        RETURN CHAR 
    IS
        v_intm          VARCHAR2(300) := NULL;
        var_intm        VARCHAR2(300) := null;

    BEGIN
        IF p_pol_iss_cd = 'RI' THEN
            FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                         FROM gicl_claims a, giis_reinsurer b
                        WHERE a.claim_id = p_claim_id
                          AND a.ri_cd    = b.ri_cd(+))
            LOOP
                v_intm := TO_CHAR(ri.ri_cd)||'/'||ri.ri_name;
                IF var_intm IS NULL THEN
                    var_intm := v_intm;
                ELSE
                    var_intm := v_intm||chr(10)||var_intm;  
                END IF;
            END LOOP;
        ELSE
            FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm, b.ref_intm_cd ref_cd
                           FROM gicl_intm_itmperil a, giis_intermediary b
                          WHERE a.intm_no  = b.intm_no
                            AND a.claim_id = p_claim_id) 
            LOOP
                v_intm := TO_CHAR(intm.nmbr)||'/'||intm.ref_cd||'/'|| intm.nm;
                IF var_intm IS NULL THEN
                    var_intm := v_intm;
                ELSE
                    var_intm := v_intm||CHR(10)||var_intm;
                END IF;
            END LOOP;
        END IF;
        RETURN (var_intm);
    END cf_intm;

    FUNCTION get_main_report(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_loss_exp           VARCHAR2,
        p_user_id            VARCHAR2
    )
        RETURN report_tab PIPELINED
    IS
        v_rep               report_type;
        v_print             BOOLEAN := TRUE;
        v_intm              VARCHAR2(300) := null; 
        v_loss_exp          VARCHAR2 (2);
    BEGIN
    
        BEGIN 
            SELECT param_value_v
              INTO v_rep.cf_company
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                v_rep.cf_company := NULL;
        END; 
        
        BEGIN 
            SELECT param_value_v
              INTO v_rep.cf_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_address := NULL;
        END; 
        
        BEGIN
          IF UPPER(p_loss_exp) = 'L' THEN
             v_rep.cf_title := ('REPORTED CLAIMS PER ENROLLEE - LOSSES');
          ELSIF UPPER(p_loss_exp) = 'E' THEN
             v_rep.cf_title := ('REPORTED CLAIMS PER ENROLLEE - EXPENSES'); 
          ELSE 
            v_rep.cf_title := ('REPORTED CLAIMS PER ENROLLEE');
          END IF;     
        END;

        BEGIN
          v_rep.cf_date := ('From '||TO_CHAR(TO_DATE(p_start_dt,'MM-DD-YYYY'),'fmMonth DD, YYYY')||
                            ' to '||TO_CHAR(TO_DATE(p_end_dt,'MM-DD-YYYY'),'fmMonth DD, YYYY'));
        END;        

        FOR i IN(SELECT a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.pol_iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                     a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                     a.dsp_loss_date, a.clm_file_date, c.grouped_item_title, c.control_cd,
                     c.control_type_cd,
                     c.item_no 
                FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
               WHERE a.clm_stat_cd = b.clm_stat_cd
                 AND a.claim_id = c.claim_id
                 AND c.grouped_item_title IS NOT NULL          
                 AND NVL (c.grouped_item_title, '!@#') LIKE NVL (p_grouped_item_title, NVL (c.grouped_item_title, '!@#'))
                 AND NVL (c.control_cd, '!@#') LIKE NVL (p_control_cd, NVL (c.control_cd, '!@#'))
                 AND NVL (c.control_type_cd, 1234) LIKE NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
                 AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE(p_start_dt,'MM/DD/YYYY'), a.clm_file_date) AND NVL (TO_DATE(p_end_dt,'MM/DD/YYYY'), a.clm_file_date)
                 AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
            ORDER BY b.clm_stat_desc,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.clm_yy,
                     a.clm_seq_no)
        LOOP
            v_print                  := FALSE;
            v_rep.clm_stat_cd        := i.clm_stat_cd;
            v_rep.clm_stat_desc      := i.clm_stat_desc;
            v_rep.claim_id           := i.claim_id;
            v_rep.claim_no           := i.claim_number;
            v_rep.policy_no          := i.policy_number;
            v_rep.assured            := i.assured_name;
            v_rep.intm_no            := i.intm_no;
            v_rep.pol_iss_cd         := i.pol_iss_cd;
            v_rep.pol_eff_date       := TO_CHAR(TRUNC(i.pol_eff_date),'MM-DD-YYYY');
            v_rep.loss_date          := TO_CHAR(TRUNC(i.dsp_loss_date),'MM-DD-YYYY');
            v_rep.clm_file_date      := TO_CHAR(TRUNC(i.clm_file_date),'MM-DD-YYYY');
            v_rep.grouped_item_title := i.grouped_item_title;
            v_rep.control_cd         := i.control_cd;
            v_rep.control_type_cd    := i.control_type_cd;
            v_rep.item_no            := i.item_no;
            v_rep.cf_intm            := cf_intm(i.claim_id, i.pol_iss_cd);
                            
            BEGIN
              IF p_loss_exp = 'L' THEN
                 v_rep.cf_clm_amt := 'Loss Amount';
              ELSIF p_loss_exp = 'E' THEN
                 v_rep.cf_clm_amt := 'Expense Amount';
              ELSE                           
                v_rep.cf_clm_amt := 'Claim Amount';
              END IF;      

            END;    
            PIPE ROW(v_rep);    
        END LOOP;
      
        IF v_print
        THEN
            v_rep.v_print := 'TRUE';
            PIPE ROW (v_rep);
        END IF;
    END get_main_report;

    FUNCTION get_detail_report(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_item_no     gicl_accident_dtl.item_no%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )      
        RETURN report_tab PIPELINED
    IS 
        v_rep       report_type;
        v_loss_exp  VARCHAR2 (2);
        v_print     BOOLEAN := TRUE;
    BEGIN 
        FOR i IN(SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                   FROM giis_peril a, gicl_item_peril b
                  WHERE a.line_cd  = b.line_cd
                    AND a.peril_cd = b.peril_cd
                    AND b.claim_id = p_claim_id)
        LOOP
            v_print             := FALSE;
            v_rep.peril_cd      := i.peril_cd;
            v_rep.peril_name    := i.peril_name;
            v_rep.claim_id2     := i.claim_id;
            
            SELECT DECODE(p_loss_exp, 'E', 'E', 'L')
                INTO v_loss_exp
              FROM DUAL;
           
            v_rep.loss_amount     := gicls540_pkg.get_loss_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, v_loss_exp, p_clm_stat_cd);
            v_rep.exp_amount      := gicls540_pkg.get_loss_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, 'E', p_clm_stat_cd);
            v_rep.retention       := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, 1, v_loss_exp, p_clm_stat_cd);
            v_rep.exp_retention   := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, 1, 'E', p_clm_stat_cd);
            v_rep.treaty          := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, giacp.v('TRTY_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_rep.exp_treaty      := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'E', p_clm_stat_cd);
            v_rep.facultative     := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, giacp.v('FACUL_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_rep.exp_facultative := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'E', p_clm_stat_cd);
            v_rep.xol             := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_rep.exp_xol         := gicls540_pkg.get_amount_per_item_peril(p_claim_id, p_item_no, i.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'E', p_clm_stat_cd);
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_print
        THEN
            v_rep.exp_amount      := 0;
            v_rep.exp_retention   := 0;        
            v_rep.retention       := 0;
            v_rep.loss_amount     := 0;
            v_rep.exp_treaty      := 0;
            v_rep.treaty          := 0;
            v_rep.exp_facultative := 0;
            v_rep.facultative     := 0;
            v_rep.exp_xol         := 0;
            v_rep.xol             := 0;            
            PIPE ROW (v_rep);
        END IF;        
    END get_detail_report;    

    FUNCTION get_totals(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_loss_exp           VARCHAR2,
        p_user_id            VARCHAR2
    )
      RETURN report_tab PIPELINED
    IS
        v_rep    report_type;
        v_loss_exp  VARCHAR2 (2);
        v_print     BOOLEAN := TRUE;
    BEGIN       

        FOR i IN(SELECT a.clm_stat_cd, a.claim_id, c.grouped_item_title, c.item_no 
                FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
               WHERE a.clm_stat_cd = b.clm_stat_cd
                 AND a.claim_id = c.claim_id
                 AND c.grouped_item_title IS NOT NULL          
                 AND NVL (c.grouped_item_title, '!@#') LIKE NVL (p_grouped_item_title, NVL (c.grouped_item_title, '!@#'))
                 AND NVL (c.control_cd, '!@#') LIKE NVL (p_control_cd, NVL (c.control_cd, '!@#'))
                 AND NVL (c.control_type_cd, 1234) LIKE NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
                 AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE(p_start_dt,'MM/DD/YYYY'), a.clm_file_date) AND NVL (TO_DATE(p_end_dt,'MM/DD/YYYY'), a.clm_file_date)
                 AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
            ORDER BY b.clm_stat_desc,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.clm_yy,
                     a.clm_seq_no)
        
        LOOP
            v_rep.grouped_item_title := i.grouped_item_title;
            v_rep.claim_id           := i.claim_id;

            FOR k IN(SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                       FROM giis_peril a, gicl_item_peril b
                      WHERE a.line_cd  = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.claim_id = i.claim_id)
            LOOP
                v_print             := FALSE;
                v_rep.peril_cd      := k.peril_cd;
                v_rep.peril_name    := k.peril_name;
                v_rep.claim_id2     := k.claim_id;
                
                SELECT DECODE(p_loss_exp, 'E', 'E', 'L')
                    INTO v_loss_exp
                  FROM DUAL;
               
                v_rep.loss_amount     := gicls540_pkg.get_loss_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, v_loss_exp, i.clm_stat_cd);
                v_rep.exp_amount      := gicls540_pkg.get_loss_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, 'E', i.clm_stat_cd);
                v_rep.retention       := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, 1, v_loss_exp, i.clm_stat_cd);
                v_rep.exp_retention   := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, 1, 'E', i.clm_stat_cd);
                v_rep.treaty          := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, giacp.v('TRTY_SHARE_TYPE'), v_loss_exp, i.clm_stat_cd);
                v_rep.exp_treaty      := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd);
                v_rep.facultative     := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, giacp.v('FACUL_SHARE_TYPE'), v_loss_exp, i.clm_stat_cd);
                v_rep.exp_facultative := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'E', i.clm_stat_cd);
                v_rep.xol             := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), v_loss_exp, i.clm_stat_cd);
                v_rep.exp_xol         := gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, k.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd);
                PIPE ROW(v_rep);
            END LOOP;
            
            IF v_print
            THEN
                v_rep.exp_amount      := 0;
                v_rep.exp_retention   := 0;        
                v_rep.retention       := 0;
                v_rep.loss_amount     := 0;
                v_rep.exp_treaty      := 0;
                v_rep.treaty          := 0;
                v_rep.exp_facultative := 0;
                v_rep.facultative     := 0;
                v_rep.exp_xol         := 0;
                v_rep.xol             := 0;            
                PIPE ROW (v_rep);
            END IF;           
        END LOOP;
    END get_totals;    
       
END GICLR547_PKG;
/


