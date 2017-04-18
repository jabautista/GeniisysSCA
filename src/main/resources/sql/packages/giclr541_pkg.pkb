CREATE OR REPLACE PACKAGE BODY CPI.GICLR541_pkg
AS

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 08.13.2013
   **  Reference By : GICLR541
   **  Remarks      : reported claims report - summary
   */   

    FUNCTION get_loss_amount(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_peril_cd    giis_peril.peril_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )   
        RETURN NUMBER
    IS
        v_loss_amt   gicl_clm_res_hist.loss_reserve%TYPE := 0;
        v_loop_count NUMBER;
        v_loss_exp   VARCHAR2 (2); 
    BEGIN
        v_loss_amt := 0;
        
        SELECT DECODE(p_loss_exp, 'E', 'E', 'L'), DECODE (p_loss_exp, 'LE', 2, 1)
          INTO v_loss_exp, v_loop_count
          FROM DUAL;

        FOR i IN 1 .. v_loop_count LOOP
            v_loss_amt := v_loss_amt + gicls540_pkg.get_loss_amt(p_claim_id, p_peril_cd, v_loss_exp, p_clm_stat_cd);
            v_loss_exp := 'E'; --check Expense type if p_loss_exp is equal to LE.
        END LOOP;
        RETURN (v_loss_amt);     
    END;

    FUNCTION get_retention(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_peril_cd    giis_peril.peril_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )   
        RETURN NUMBER
    IS
        v_net_ret    gicl_reserve_ds.shr_loss_res_amt%TYPE;
        v_loop_count NUMBER; 
        v_loss_exp   VARCHAR2 (2);
        
    BEGIN
        v_net_ret := 0;
        
        SELECT DECODE(p_loss_exp, 'E', 'E', 'L'), DECODE (p_loss_exp, 'LE', 2, 1)
          INTO v_loss_exp, v_loop_count
          FROM DUAL;
        
        FOR i IN 1 .. v_loop_count LOOP
            v_net_ret  := v_net_ret + gicls540_pkg.amount_per_share_type(p_claim_id, p_peril_cd, 1, v_loss_exp, p_clm_stat_cd);
            v_loss_exp := 'E'; --check Expense type if p_loss_exp is equal to LE.
        END LOOP;
        RETURN (v_net_ret);     
    END;

    FUNCTION get_treaty(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_peril_cd    giis_peril.peril_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )   
        RETURN NUMBER
    IS
        v_trty       gicl_reserve_ds.shr_loss_res_amt%TYPE;
        v_loop_count NUMBER; 
        v_loss_exp   VARCHAR2 (2);
    BEGIN
        v_trty := 0;
        
        SELECT DECODE(p_loss_exp, 'E', 'E', 'L'), DECODE (p_loss_exp, 'LE', 2, 1)
          INTO v_loss_exp, v_loop_count
          FROM DUAL;
            
        FOR i IN 1 .. v_loop_count LOOP
            v_trty     := v_trty + gicls540_pkg.amount_per_share_type(p_claim_id, p_peril_cd, giacp.v('TRTY_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_loss_exp := 'E'; --check Expense type if p_loss_exp is equal to LE.
        END LOOP;
        RETURN (v_trty);     
    END;

    FUNCTION get_facultative(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_peril_cd    giis_peril.peril_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )   
        RETURN NUMBER
    IS
        v_facul      gicl_reserve_ds.shr_loss_res_amt%TYPE;
        v_loop_count NUMBER; 
        v_loss_exp   VARCHAR2 (2);
    BEGIN
        v_facul := 0;
        
        SELECT DECODE(p_loss_exp, 'E', 'E', 'L'), DECODE (p_loss_exp, 'LE', 2, 1)
          INTO v_loss_exp, v_loop_count
          FROM DUAL;
        
        FOR i IN 1 .. v_loop_count LOOP
            v_facul    := v_facul + gicls540_pkg.amount_per_share_type(p_claim_id, p_peril_cd, giacp.v('FACUL_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_loss_exp := 'E'; --check Expense type if p_loss_exp is equal to LE.
        END LOOP;
        RETURN (v_facul);     
    END;

    FUNCTION get_xol(
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_peril_cd    giis_peril.peril_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )   
        RETURN NUMBER
    IS
        v_xol        gicl_reserve_ds.shr_loss_res_amt%TYPE;
        v_loop_count NUMBER; 
        v_loss_exp   VARCHAR2 (2);
    BEGIN
        v_xol := 0;
        
        SELECT DECODE(p_loss_exp, 'E', 'E', 'L'), DECODE (p_loss_exp, 'LE', 2, 1)
          INTO v_loss_exp, v_loop_count
          FROM DUAL;
            
        FOR i IN 1 .. v_loop_count LOOP
            v_xol      := v_xol + gicls540_pkg.amount_per_share_type(p_claim_id, p_peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_loss_exp := 'E'; --check Expense type if p_loss_exp is equal to LE.
        END LOOP;
        RETURN (v_xol);     
    END;

    FUNCTION get_main_report(
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )
        RETURN report_tab PIPELINED
    IS
        v_rep    report_type;
        v_print  BOOLEAN := TRUE;
        v_loss_exp  VARCHAR2 (2);
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
             v_rep.cf_title := ('REPORTED CLAIMS - LOSSES');
          ELSIF UPPER(p_loss_exp) = 'E' THEN
             v_rep.cf_title := ('REPORTED CLAIMS - EXPENSES'); 
          ELSE 
            v_rep.cf_title := ('REPORTED CLAIMS');
          END IF;     
        END;

        BEGIN
            IF p_loss_exp = 'L' THEN
                v_rep.cf_clm_amt := 'Loss Amount';
            ELSIF p_loss_exp = 'E' THEN
                v_rep.cf_clm_amt := 'Expense Amount';
            ELSE                           
                v_rep.cf_clm_amt := 'Claim Amount';
            END IF;      
        END;          

        BEGIN
          v_rep.cf_date := ('from '||TO_CHAR(TO_DATE(p_start_dt,'MM-DD-YYYY'),'fmMonth DD, YYYY')||
                            ' to '||TO_CHAR(TO_DATE(p_end_dt,'MM-DD-YYYY'),'fmMonth DD, YYYY'));
        END;        

        FOR i IN(SELECT a.line_cd, DECODE(a.pol_iss_cd,'RI','ASSUMED','DIRECT') "ISSOURCE",
                        a.line_cd||'-'||a.subline_cd||'-'|| a.iss_cd
                        ||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                        LTRIM(TO_CHAR(a.clm_seq_no,'0000009')) "CLAIM_NO",
                        a.loss_date, a.clm_file_date,
                        a.assd_no, a.claim_id, a.clm_stat_cd
                   FROM gicl_claims a
                  WHERE TRUNC(a.clm_file_date) BETWEEN
                        NVL(TO_DATE(p_start_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date)) 
                    AND NVL(TO_DATE(p_end_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date))
                    AND a.line_cd = NVL(p_line_cd,a.line_cd)
                    AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)
                    AND a.iss_cd IN NVL(DECODE(p_branch_cd,
                                                'D',a.iss_cd,
                                                 giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),
                                                 p_branch_cd)
                                        ,a.iss_cd)
                    AND a.iss_cd NOT IN DECODE(p_branch_cd,
                                                'D','RI','*')
                    AND check_user_per_iss_cd2(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
               ORDER BY a.line_cd)
        LOOP
            v_print             := FALSE;
            v_rep.line_cd       := i.line_cd;
            v_rep.issource      := i.issource;
            v_rep.claim_no      := i.claim_no;
            v_rep.loss_date     := TO_CHAR(TRUNC(i.loss_date),'MM-DD-YYYY');
            v_rep.clm_file_date := TO_CHAR(TRUNC(i.clm_file_date),'MM-DD-YYYY');
            v_rep.assd_no       := i.assd_no;
            v_rep.claim_id      := i.claim_id;
            v_rep.clm_stat_cd   := i.clm_stat_cd;
                                
            BEGIN
                SELECT line_name
                  INTO v_rep.line_name
                  FROM giis_line
                 WHERE line_cd = i.line_cd;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.line_name := ' ';
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
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )      
        RETURN report_tab PIPELINED
    IS 
        v_rep    report_type;
        v_print  BOOLEAN := TRUE;
    BEGIN       
        FOR i IN(SELECT a.line_cd, DECODE(a.pol_iss_cd,'RI','ASSUMED','DIRECT') "ISSOURCE",
                        a.claim_id, a.clm_stat_cd
                   FROM gicl_claims a
                  WHERE TRUNC(a.clm_file_date) BETWEEN
                        NVL(TO_DATE(p_start_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date)) 
                    AND NVL(TO_DATE(p_end_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date))
                    AND a.line_cd = NVL(p_line_cd,a.line_cd)
                    AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)
                    AND a.iss_cd IN NVL(DECODE(p_branch_cd,
                                                'D',a.iss_cd,
                                                 giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),
                                                 p_branch_cd)
                                        ,a.iss_cd)
                    AND a.iss_cd NOT IN DECODE(p_branch_cd,
                                                'D','RI','*')
                    AND check_user_per_iss_cd2(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
               ORDER BY a.line_cd)
        LOOP
            v_rep.line_cd       := i.line_cd;
            v_rep.issource      := i.issource;
            v_rep.claim_id      := i.claim_id;
                                        
            FOR k IN(SELECT distinct c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                   FROM gicl_item_peril b, giis_peril c 
                  WHERE b.peril_cd = c.peril_cd
                    AND c.line_cd = NVL(i.line_cd,c.line_cd)
                    AND b.claim_id = i.claim_id   )
            LOOP
                v_print             := FALSE;
                v_rep.peril_cd      := k.peril_cd;
                v_rep.peril_sname   := k.peril_sname;
                v_rep.line_cd2      := k.line_cd;
                v_rep.claim_id2     := k.claim_id;
                v_rep.loss_amount   := NVL(get_loss_amount(i.claim_id, k.peril_cd, p_loss_exp, i.clm_stat_cd),0);
                v_rep.retention     := NVL(get_retention(i.claim_id, k.peril_cd, p_loss_exp, i.clm_stat_cd),0);
                v_rep.treaty        := NVL(get_treaty(i.claim_id, k.peril_cd, p_loss_exp, i.clm_stat_cd),0);
                v_rep.xol           := NVL(get_xol(i.claim_id, k.peril_cd, p_loss_exp, i.clm_stat_cd),0);
                v_rep.facultative   := NVL(get_facultative(i.claim_id, k.peril_cd, p_loss_exp, i.clm_stat_cd),0);
                PIPE ROW(v_rep);
            END LOOP;

        END LOOP;
      
        IF v_print
        THEN
            v_rep.v_print         := 'TRUE';
            v_rep.retention       := 0;
            v_rep.loss_amount     := 0;
            v_rep.treaty          := 0;
            v_rep.facultative     := 0;
            v_rep.xol             := 0; 
            PIPE ROW (v_rep);
        END IF;         
    END get_detail_report;    
       
END GICLR541_PKG;
/


