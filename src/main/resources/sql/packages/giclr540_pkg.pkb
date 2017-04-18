CREATE OR REPLACE PACKAGE BODY CPI.GICLR540_pkg
AS

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 08.07.2013
   **  Reference By : GICLR540- detailed
   **  Remarks      : reported claims report
   */    
    FUNCTION cf_intm(
        p_claim_id  gicl_claims.claim_id%TYPE
    ) 
        RETURN VARCHAR2
    IS
      v_pol_iss_cd     gicl_claims.pol_iss_cd%TYPE;
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_intm_no        gicl_intm_itmperil.intm_no%TYPE;
      v_ref_intm_cd    giis_intermediary.ref_intm_cd%TYPE;
      v_ri_cd          gicl_claims.ri_cd%TYPE;
      v_ri_name        giis_reinsurer.ri_name%TYPE;    
      v_intm           VARCHAR2(300) := NULL; 
      var_intm         VARCHAR2(300) := NULL;

    BEGIN
      FOR i IN (SELECT a.pol_iss_cd
                  FROM gicl_claims a
                 WHERE a.claim_id= p_claim_id)
      LOOP
        v_pol_iss_cd := i.pol_iss_cd;
      END LOOP;
      
      IF v_pol_iss_cd = 'RI' THEN
         FOR k IN (SELECT DISTINCT g.ri_name, a.ri_cd
                     FROM gicl_claims a, giis_reinsurer g
                    where a.claim_id = p_claim_id
                      and a.ri_cd    = g.ri_cd(+))
         LOOP
           v_intm := TO_CHAR(k.ri_cd)||'/'||
                     k.ri_name;
           IF var_intm IS NULL THEN
              var_intm := v_intm;
           ELSE
              var_intm := v_intm||chr(10)||var_intm;  
           END IF;
         END LOOP;
      ELSE
         FOR j IN (SELECT DISTINCT a.intm_no, b.intm_name, b.ref_intm_cd
                    FROM gicl_intm_itmperil a, giis_intermediary b
                   WHERE a.intm_no = b.intm_no
                     AND a.claim_id = p_claim_id) 
         LOOP
           v_intm := TO_CHAR(j.intm_no)||'/'||j.ref_intm_cd||'/'||
                     j.intm_name;
           IF var_intm IS NULL THEN
              var_intm := v_intm;
           ELSE
              var_intm := v_intm||CHR(10)||var_intm;
           END IF;
         END LOOP;
      END IF;
      IF var_intm IS NULL THEN
        var_intm := null;
      END IF;
      
      RETURN (var_intm);   
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
        RETURN main_report_tab PIPELINED
    IS
        v_rep    main_report_type;
        v_print  BOOLEAN := TRUE;
        v_intm   VARCHAR2(300) := null; 
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
             v_rep.cf_title := ('REPORTED CLAIMS PER LINE - LOSSES');
          ELSIF UPPER(p_loss_exp) = 'E' THEN
             v_rep.cf_title := ('REPORTED CLAIMS PER LINE - EXPENSES'); 
          ELSE 
            v_rep.cf_title := ('REPORTED CLAIMS PER LINE');
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

        FOR i IN(SELECT a.line_cd, a.iss_cd,
                        (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0')) "CLAIM_NO",
                        a.line_cd ||'-' || a.subline_cd ||'-'|| a.pol_iss_cd ||'-'||
                        LTRIM(TO_CHAR(a.issue_yy,'00')) ||'-'|| 
                        LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))  ||'-'||
                        LTRIM(TO_CHAR(a.renew_no,'00')) "POLICY_NO",
                        a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                        a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                        a.assured_name, a.claim_id, a.clm_stat_cd, a.old_stat_cd, close_date
                   FROM gicl_claims a
                  WHERE TRUNC(a.clm_file_date) BETWEEN NVL(TO_DATE(p_start_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date))  
                    AND NVL(TO_DATE(p_end_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date))
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND iss_cd IN NVL(DECODE(p_branch_cd,'D',iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_branch_cd), iss_cd)
                    AND iss_cd NOT IN DECODE(p_branch_cd,'D','RI','*')
                    AND iss_cd = NVL(p_iss_cd, a.iss_cd) 
                    AND line_cd = NVL(p_line_cd, a.line_cd) 
                    AND check_user_per_iss_cd2(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
               ORDER BY a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0'))
        LOOP
            v_print             := FALSE;
            v_rep.line_cd       := i.line_cd;
            v_rep.iss_cd        := i.iss_cd;
            v_rep.claim_no      := i.claim_no;
            v_rep.policy_no     := i.policy_no;
            v_rep.loss_date     := TO_CHAR(TRUNC(i.dsp_loss_date),'MM-DD-YYYY');
            v_rep.clm_file_date := TO_CHAR(TRUNC(i.clm_file_date),'MM-DD-YYYY');
            v_rep.pol_eff_date  := TO_CHAR(TRUNC(i.pol_eff_date),'MM-DD-YYYY');
            v_rep.subline_cd    := i.subline_cd;
            v_rep.pol_iss_cd    := i.pol_iss_cd;
            v_rep.issue_yy      := i.issue_yy;
            v_rep.pol_seq_no    := i.pol_seq_no;
            v_rep.renew_no      := i.renew_no;
            v_rep.assured       := i.assured_name;
            v_rep.claim_id      := i.claim_id;
            v_rep.clm_stat_cd   := i.clm_stat_cd;
            v_rep.old_stat_cd   := i.old_stat_cd;
            v_rep.close_date    := i.close_date;
            v_rep.cf_intm       := cf_intm(i.claim_id);
            
            FOR e IN (SELECT clm_stat_desc
                        FROM giis_clm_stat
                       WHERE clm_stat_cd = i.clm_stat_cd)
            LOOP
                v_rep.clm_stat := e.clm_stat_desc;
                EXIT;
            END LOOP; 
                    
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
        p_claim_id    gicl_claims.claim_id%TYPE,
        p_line_cd     giis_line.line_cd%TYPE,
        p_loss_exp    VARCHAR2,
        p_clm_stat_cd gicl_claims.clm_stat_cd%TYPE
    )      
        RETURN peril_report_tab PIPELINED
    IS 
        v_rep       peril_report_type;
        v_loss_exp  VARCHAR2 (2);
        v_print  BOOLEAN := TRUE;
    BEGIN 
        FOR i IN(SELECT distinct c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                   FROM gicl_item_peril b, giis_peril c 
                  WHERE b.peril_cd = c.peril_cd
                    AND c.line_cd = nvl(p_line_cd, c.line_cd)
                    AND b.claim_id = p_claim_id)
        LOOP
            v_print             := FALSE;
            v_rep.peril_cd      := i.peril_cd;
            v_rep.peril_sname   := i.peril_sname;
            v_rep.line_cd       := i.line_cd;
            v_rep.claim_id      := i.claim_id;
            v_rep.exp_amount    := gicls540_pkg.get_loss_amt(p_claim_id, i.peril_cd, 'E', p_clm_stat_cd);
            v_rep.exp_retention := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, 1, 'E', p_clm_stat_cd);
            
            SELECT DECODE(p_loss_exp, 'E', 'E', 'L')
  	          INTO v_loss_exp
              FROM DUAL;
           
            v_rep.retention       := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, 1, v_loss_exp, p_clm_stat_cd);
            v_rep.loss_amount     := gicls540_pkg.get_loss_amt(p_claim_id, i.peril_cd, v_loss_exp, p_clm_stat_cd);
            v_rep.exp_treaty      := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'E', p_clm_stat_cd);
            v_rep.treaty          := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, giacp.v('TRTY_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_rep.exp_facultative := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'E', p_clm_stat_cd);
            v_rep.facultative     := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, giacp.v('FACUL_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
            v_rep.exp_xol         := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'E', p_clm_stat_cd);
            v_rep.xol             := gicls540_pkg.amount_per_share_type(p_claim_id, i.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), v_loss_exp, p_clm_stat_cd);
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

    FUNCTION get_line_totals(
        p_start_dt  VARCHAR2,
        p_end_dt    VARCHAR2,
        p_line_cd   VARCHAR2,
        p_branch_cd VARCHAR2,
        p_iss_cd    VARCHAR2,
        p_loss_exp  VARCHAR2,
        p_user_id   VARCHAR2
    )
        RETURN main_report_tab PIPELINED
    IS
        v_rep    main_report_type;
        v_loss_exp  VARCHAR2 (2);
    BEGIN       

        FOR i IN(SELECT a.line_cd, a.iss_cd,
                        (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0')) "CLAIM_NO",
                        a.line_cd ||'-' || a.subline_cd ||'-'|| a.pol_iss_cd ||'-'||
                        LTRIM(TO_CHAR(a.issue_yy,'00')) ||'-'|| 
                        LTRIM(TO_CHAR(a.pol_seq_no,'0000009'))  ||'-'||
                        LTRIM(TO_CHAR(a.renew_no,'00')) "POLICY_NO",
                        a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                        a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                        a.assured_name, a.claim_id, a.clm_stat_cd, a.old_stat_cd, close_date
                   FROM gicl_claims a
                  WHERE TRUNC(a.clm_file_date) BETWEEN NVL(TO_DATE(p_start_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date))  
                    AND NVL(TO_DATE(p_end_dt,'MM/DD/YYYY'), TRUNC(a.clm_file_date))
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND iss_cd IN NVL(DECODE(p_branch_cd,'D',iss_cd,giacp.v('RI_ISS_CD'),giacp.v('RI_ISS_CD'),p_branch_cd), iss_cd)
                    AND iss_cd NOT IN DECODE(p_branch_cd,'D','RI','*')
                    AND iss_cd = NVL(p_iss_cd, a.iss_cd) 
                    AND line_cd = NVL(p_line_cd, a.line_cd) 
                    AND check_user_per_iss_cd2(a.line_cd ,NVL(p_iss_cd, NULL), 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(NVL(p_line_cd, NULL) ,a.iss_cd, 'GICLS540', p_user_id) = 1
                    AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
               ORDER BY a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                        LPAD(TO_CHAR(a.clm_yy),2,'0')||'-'||
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0'))
        LOOP
            v_rep.line_cd       := i.line_cd;
            v_rep.claim_id      := i.claim_id;

            FOR k IN(SELECT distinct c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                       FROM gicl_item_peril b, giis_peril c 
                      WHERE b.peril_cd = c.peril_cd
                        AND c.line_cd = nvl(i.line_cd, c.line_cd)
                        AND b.claim_id = i.claim_id)
            LOOP
                v_rep.peril_cd      := k.peril_cd;
                v_rep.peril_sname   := k.peril_sname;
                v_rep.line_cd2      := k.line_cd;
                v_rep.claim_id2     := k.claim_id;
                v_rep.exp_amount    := NVL(gicls540_pkg.get_loss_amt(i.claim_id, k.peril_cd, 'E', i.clm_stat_cd),0);
                v_rep.exp_retention := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, 1, 'E', i.clm_stat_cd),0);
                
                SELECT DECODE(p_loss_exp, 'E', 'E', 'L')
                  INTO v_loss_exp
                  FROM DUAL;
                  
                v_rep.retention       := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, 1, v_loss_exp, i.clm_stat_cd),0);
                v_rep.loss_amount     := NVL(gicls540_pkg.get_loss_amt(i.claim_id, k.peril_cd, v_loss_exp, i.clm_stat_cd),0);
                v_rep.exp_treaty      := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd),0);
                v_rep.treaty          := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, giacp.v('TRTY_SHARE_TYPE'), v_loss_exp, i.clm_stat_cd),0);
                v_rep.exp_facultative := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'E', i.clm_stat_cd),0);
                v_rep.facultative     := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, giacp.v('FACUL_SHARE_TYPE'), v_loss_exp, i.clm_stat_cd),0);
                v_rep.exp_xol         := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd),0);
                v_rep.xol             := NVL(gicls540_pkg.amount_per_share_type(i.claim_id, k.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), v_loss_exp, i.clm_stat_cd),0);
                PIPE ROW(v_rep);
            END LOOP;          
        END LOOP;
    END get_line_totals;    
       
END GICLR540_PKG;
/


