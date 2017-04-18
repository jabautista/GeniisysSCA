CREATE OR REPLACE PACKAGE BODY CPI.GIACS149_PKG
AS

    PROCEDURE when_new_form_instance(
        p_update        IN      VARCHAR2,
        p_fund_cd       OUT     giac_parameters.PARAM_VALUE_V%type
    )
    AS
    BEGIN
        begin
          select param_value_v
            into p_fund_cd
            from giac_parameters
           where param_name like 'FUND_CD';
        exception
          when no_data_found then
            p_fund_cd := null;
        end;
        
        --initializes all print_tags to "N" if the O.C.V. hasn't been printed yet.
        IF p_update = 'Y' THEN
            begin
              update giac_parent_comm_voucher
                 set print_tag = 'N'
               where print_tag = 'Y'
                --and print_date is null;
                AND (NOT EXISTS (SELECT 1
                                   FROM giac_comm_payts
                                  WHERE gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id 
                                    AND intm_no = giac_parent_comm_voucher.chld_intm_no
                                    AND iss_cd = giac_parent_comm_voucher.iss_cd
                                    AND prem_seq_no = giac_parent_comm_voucher.prem_seq_no)
                      OR EXISTS (SELECT 1
                                   FROM giac_comm_payts s, giac_acctrans t
                                  WHERE 1=1 
                                    AND s.gacc_tran_id = t.tran_id
                                    AND s.gacc_tran_id > 0
                                    AND s.gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id
                                    AND s.intm_no = giac_parent_comm_voucher.chld_intm_no
                                    AND s.iss_cd = giac_parent_comm_voucher.iss_cd
                                    AND s.prem_seq_no = giac_parent_comm_voucher.prem_seq_no
                                    AND t.tran_flag <> 'D'
                                    AND NOT EXISTS(SELECT 1
                                                     FROM giac_reversals c,
                                                          giac_acctrans  d
                                                    WHERE c.reversing_tran_id = d.tran_id
                                                      AND d.tran_flag        <> 'D'
                                                      AND c.gacc_tran_id = s.gacc_tran_id)) );
            end;
        END IF;
    END when_new_form_instance;
    
    
    FUNCTION get_intm_lov(
        p_workflow_col_val  VARCHAR2,
        p_user_id           VARCHAR2,
        p_keyword           NUMBER
    ) RETURN intm_lov_tab PIPELINED
    AS
        lov     intm_lov_type;
    BEGIN       
        IF p_workflow_col_val IS NULL THEN
            FOR i IN(SELECT intm_no, intm_name, co_intm_type, iss_cd
                       FROM GIIS_INTERMEDIARY 
                      --WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(null,iss_cd,'GIACS149', p_user_id),1,iss_cd,NULL)
                        /*AND intm_no = NVL(p_keyword, intm_no)*/)
            LOOP
                lov.intm_no         := i.intm_no;
                lov.intm_name       := i.intm_name;
                lov.co_intm_type    := i.co_intm_type;
                lov.iss_cd          := i.iss_cd;
                
                BEGIN
                    SELECT branch_name
                      INTO lov.iss_name
                      FROM GIAC_BRANCHES
                     WHERE branch_cd = i.iss_cd;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        lov.iss_name    := null;
                END;
                    
                PIPE ROW(lov);
            END LOOP;
        ELSE
            FOR i IN(SELECT intm_no, intm_name, co_intm_type, iss_cd
                       FROM GIIS_INTERMEDIARY
                      /*WHERE intm_no = NVL(p_keyword, intm_no)*/)
            LOOP
                lov.intm_no         := i.intm_no;
                lov.intm_name       := i.intm_name;
                lov.co_intm_type    := i.co_intm_type;
                lov.iss_cd          := i.iss_cd;
                
                BEGIN
                    SELECT branch_name
                      INTO lov.iss_name
                      FROM GIAC_BRANCHES
                     WHERE branch_cd = i.iss_cd;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        lov.iss_name    := null;
                END;
                    
                PIPE ROW(lov);
            END LOOP;
        END IF;
    END get_intm_lov;
        
    
    FUNCTION get_fund_lov(
        p_keyword   VARCHAR2,
        p_user_id   VARCHAR2
    ) RETURN fund_lov_tab PIPELINED
    AS
        lov     fund_lov_type;
    BEGIN
        FOR i IN(SELECT fund_cd, fund_desc
                   FROM GIIS_FUNDS
                   /*WHERE (fund_cd LIKE UPPER(p_keyword) || '%'
                         OR fund_desc LIKE UPPER(p_keyword) || '%')*/)
        LOOP
            lov.fund_cd     := i.fund_cd;
            lov.fund_desc   := i.fund_desc;
            
           /*FOR j IN(SELECT branch_cd, branch_name
                       FROM GIAC_BRANCHES
                      WHERE check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS149', p_user_id) = 1
                        AND gfun_fund_cd = i.fund_cd
                      ORDER BY branch_name)
            LOOP
                lov.branch_cd     := j.branch_cd;
                lov.branch_name   := j.branch_name;
                
                PIPE ROW(lov);
            END LOOP;*/
            
            PIPE ROW(lov);
        END LOOP;
    END get_fund_lov;
    
    
    FUNCTION get_branch_lov (
        p_user_id       VARCHAR2,
        p_keyword       VARCHAR2
    ) RETURN branch_lov_tab PIPELINED
    AS
        lov     branch_lov_type;
    BEGIN
        FOR i IN(SELECT branch_cd, branch_name
                   FROM GIAC_BRANCHES
                  WHERE check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS149', p_user_id) = 1
                    AND (branch_cd LIKE UPPER(p_keyword) || '%'
                         OR branch_name LIKE UPPER(p_keyword) || '%')
                  ORDER BY branch_name)
        LOOP
            lov.branch_cd     := i.branch_cd;
            lov.branch_name   := i.branch_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_branch_lov;
    
    FUNCTION compute_var_advances(
        p_intm_no       GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_iss_cd        GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no   GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type
    ) RETURN NUMBER
    AS
        v_advances   GIAC_PARENT_COMM_VOUCHER.ADVANCES%type;
    BEGIN
        SELECT NVL (SUM (NVL(a.comm_amt,0) - NVL(a.wtax_amt,0) + NVL(a.input_vat,0)), 0) advances
          INTO v_advances
          FROM giac_ovride_comm_payts a, giac_acctrans b
         WHERE iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no
           AND a.intm_no = p_intm_no
           AND a.gacc_tran_id = b.tran_id
           AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                        FROM giac_reversals c, giac_acctrans d
                                       WHERE c.reversing_tran_id = d.tran_id
                                         AND d.tran_flag <> 'D')
           AND b.tran_flag <> 'D';
           
        RETURN v_advances;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            RETURN 0;
    END compute_var_advances;
    
    
    PROCEDURE giac_p_comm_voucher_post_query(
        p_gfun_fund_cd      IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_assd_no           IN  GIAC_PARENT_COMM_VOUCHER.ASSD_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_advances          IN  GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        p_commission_due    IN  GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type,
        p_input_vat         IN  GIAC_PARENT_COMM_VOUCHER.INPUT_VAT%type,
        p_withholding_tax   IN  GIAC_PARENT_COMM_VOUCHER.WITHHOLDING_TAX%type,
        p_premium_amt       IN  GIAC_PARENT_COMM_VOUCHER.PREMIUM_AMT%type,
        p_notarial_fee      IN  GIAC_PARENT_COMM_VOUCHER.NOTARIAL_FEE%type,
        p_other_charges     IN  GIAC_PARENT_COMM_VOUCHER.OTHER_CHARGES%type,
        p_var_advances      IN  GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        p_tran_class        IN  GIAC_PARENT_COMM_VOUCHER.TRAN_CLASS%type,
        p_tran_class_no     IN  GIAC_PARENT_COMM_VOUCHER.TRAN_CLASS_NO%type,
        p_dsp_ref_no        OUT VARCHAR2,
        p_net_comm_due      OUT NUMBER,
        p_net_comm_amt_due  OUT NUMBER,
        p_prem_minus_others OUT NUMBER,
        p_assd_name         OUT GIIS_ASSURED.ASSD_NAME%type,
        p_chld_intm_name    OUT GIIS_INTERMEDIARY.INTM_NAME%type
        --p_assd_msg          OUT VARCHAR2,
        --p_intm_msg          OUT VARCHAR2
    )
    AS
      v_ref_no                  varchar2(16); 
      v_print_flag              varchar2(1);
      v_advances		        number(12,2);
      v_net_comm_due	        number(12,2);
      v_dsp_assd_name2          giis_assured.ASSD_NAME%type;
      v_dsp_child_intm_name     giis_intermediary.INTM_NAME%type;
    BEGIN
        p_net_comm_due := ( nvl(p_commission_due,0) + nvl(p_input_vat,0) - nvl(p_advances,0) - nvl(p_withholding_tax,0)) - p_var_advances ;
        
        if p_tran_class = 'COL' then
            begin
                SELECT or_pref_suf||'-'||to_char(or_no), or_flag 
                  INTO v_ref_no, v_print_flag
                  FROM giac_order_of_payts 
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND gibr_gfun_fund_cd = p_gfun_fund_cd
                   AND gibr_branch_cd  =  p_gibr_branch_cd;
                
                IF v_print_flag = 'P' then
                    p_dsp_ref_no := v_ref_no;
                ELSE
                    p_dsp_ref_no := null;
                END IF;
            exception
                when no_data_found then
                    p_dsp_ref_no := null;
            end; 
        --elsif p_dsp_ref_no = 'DV' then
        elsif p_tran_class = 'DV' then --edited by lina
            begin
                SELECT dv_pref||'-'||to_char(dv_no), dv_flag
                  INTO v_ref_no, v_print_flag
                  FROM giac_disb_vouchers
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND gibr_gfun_fund_cd = p_gfun_fund_cd
                   AND gibr_branch_cd  =  p_gibr_branch_cd;
                
                IF v_print_flag = 'P' then
                    p_dsp_ref_no := v_ref_no;
                ELSE
                    p_dsp_ref_no := null;
                END IF;
            exception
                when no_data_found then
                    p_dsp_ref_no := null;
            end;
        --elsif p_dsp_ref_no = 'JV' then --edited by lina
        elsif p_tran_class = 'JV' then
            p_dsp_ref_no /* v_ref_no */ := p_tran_class ||'-'||to_char(p_tran_class_no);
        --added by lina
        --09012006
        --added the conditon to get the ref_no from giac_pdc_checks if tran-class = 'PDC'
        elsif p_tran_class = 'PDC' then 
            begin
                SELECT b.ref_no, or_flag 
                  INTO v_ref_no, v_print_flag
                  FROM giac_order_of_payts a, giac_pdc_checks b
                 WHERE a.gacc_tran_id = b.gacc_tran_id
                   AND b.gacc_tran_id_new = p_gacc_tran_id
                   AND a.gibr_gfun_fund_cd = p_gfun_fund_cd
                   AND a.gibr_branch_cd  =  p_gibr_branch_cd;
                
                IF v_print_flag = 'P' then
                  p_dsp_ref_no := v_ref_no;
                ELSE
                  p_dsp_ref_no := null;
                END IF;
            exception
                when no_data_found then
                    p_dsp_ref_no := null;
            end;
        -----end of modification
        end if;
        
        p_net_comm_amt_due      := p_net_comm_due;
        p_prem_minus_others     := nvl(p_premium_amt,0) - ( nvl(p_notarial_fee,0)+ nvl(p_other_charges,0));
        
        begin
            select assd_name
              into p_assd_name
              from giis_assured  c
             where c.assd_no = p_assd_no;
        exception
            when no_data_found then
              --p_assd_msg := 'Policy '|| to_char(p_assd_no) /*policy_no*/||' has no record in giis_assured.';
              p_assd_name := NULL;
        end;
        
        begin
            select intm_name
              into p_chld_intm_name
              from giis_intermediary
             where intm_no = p_chld_intm_no;
        exception
            when no_data_found then
               --p_intm_msg := 'Intm_no'|| to_char(p_chld_intm_no) ||' has no record in giis_intermediary.';
               p_chld_intm_name  := NULL;
        end;
        
        p_prem_minus_others := nvl(p_premium_amt,0)- ( nvl(p_notarial_fee,0) + nvl(p_other_charges,0)) ; 
    END giac_p_comm_voucher_post_query;
    
    
    FUNCTION get_comm_voucher_list(
        p_intm_no               GIIS_INTERMEDIARY.INTM_NO%type,
        p_gfun_fund_cd          GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd        GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_from_date             VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_to_date               VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_workflow_col_value    VARCHAR2,
        p_user_id               GIAC_PARENT_COMM_VOUCHER.USER_ID%type
    ) RETURN comm_voucher_tab PIPELINED
    AS
        v_list          comm_voucher_type;
        v_intm_no       giac_parent_comm_voucher.INTM_NO%type; 
        v_gfun_fund_cd  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type;
        v_iss_cd        GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type;        
    BEGIN
        IF p_gfun_fund_cd IS NULL THEN
            -- GET_FUND_CD prog unit
            begin
                select param_value_v
                  into v_gfun_fund_cd
                  from giac_parameters
                 where param_name = 'FUND_CD';
            exception
                when no_data_found then
                  v_gfun_fund_cd := null;
            end;
            -- end 
        ELSE
            v_gfun_fund_cd := p_gfun_fund_cd;
        END IF;
        
        BEGIN
            select fund_desc
              into v_list.fund_desc 
              from giis_funds
             where fund_Cd = v_gfun_fund_cd;
        EXCEPTION
            when no_data_found then
              v_list.fund_desc := null;
        END;
        
        /*IF p_gibr_branch_cd IS NULL THEN
            BEGIN
                SELECT iss_cd
                  INTO v_iss_cd
                  FROM GIIS_INTERMEDIARY
                 WHERE intm_no = p_intm_no
                   AND check_user_per_iss_cd_acctg2(null, iss_cd, 'GIACS149', p_user_id) = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_iss_cd := null;
            END;
        ELSE
            v_iss_cd := p_gibr_branch_cd;
        END IF;*/
        
        BEGIN
            SELECT branch_name
              INTO v_list.branch_name
              FROM GIAC_BRANCHES
             WHERE branch_cd = v_iss_cd
               AND gfun_fund_cd = v_gfun_fund_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_list.branch_name := null;
        END;
        IF p_workflow_col_value IS NOT NULL THEN
            FOR c1 IN (SELECT intm_no
                         FROM giac_parent_comm_voucher
                        WHERE iss_cd||'-'||prem_seq_no = p_workflow_col_value)
            LOOP            
                v_intm_no := c1.intm_no;       
            END LOOP;
     
            FOR i IN  ( SELECT * 
                          FROM GIAC_PARENT_COMM_VOUCHER
                         WHERE 1=1
                           AND intm_no = p_intm_no
                           AND (NOT EXISTS (SELECT 1
                                              FROM  giac_comm_payts
                                             WHERE gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id 
                                               AND intm_no = giac_parent_comm_voucher.chld_intm_no
                                               AND iss_cd = giac_parent_comm_voucher.iss_cd
                                               AND prem_seq_no = giac_parent_comm_voucher.prem_seq_no)
                                 OR EXISTS (SELECT 1
                                              FROM giac_comm_payts s, giac_acctrans t
                                             WHERE 1=1 
                                               AND s.gacc_tran_id = t.tran_id
                                               AND s.gacc_tran_id > 0
                                               AND s.gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id
                                               AND s.intm_no = giac_parent_comm_voucher.chld_intm_no
                                               AND s.iss_cd = giac_parent_comm_voucher.iss_cd
                                               AND s.prem_seq_no = giac_parent_comm_voucher.prem_seq_no
                                               AND t.tran_flag <> 'D'
                                               AND NOT EXISTS(SELECT 1
                                                                FROM giac_reversals c,
                                                                     giac_acctrans  d
                                                               WHERE c.reversing_tran_id = d.tran_id
                                                                 AND d.tran_flag        <> 'D'
                                                                 AND c.gacc_tran_id = s.gacc_tran_id))) 
                           AND iss_cd||''-''||prem_seq_no = v_intm_no
                           AND gfun_fund_cd = NVL(v_gfun_fund_cd, gfun_fund_cd)
                           AND gibr_branch_cd = NVL(v_iss_cd, gibr_branch_cd)
                           AND ((p_from_date IS NULL AND p_to_date IS NULL)
                                OR (TRUNC(tran_date) >= TO_DATE(p_from_date, 'MM-DD-RRRR')  
                                    AND TRUNC(tran_date) <= TO_DATE(p_to_date, 'MM-DD-RRRR') )                                 
                                AND print_date IS NULL )  
                           --AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIACS149', p_user_id) = 1
                           AND (EXISTS ( --added by steven 10.08.2014; to replace check_user_per_iss_cd_acctg2
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_iss_cd b2,
                                         giis_modules_tran c,
                                         giis_user_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = gibr_branch_cd
                                     AND c.module_id = 'GIACS149'
                                     AND a.user_id = b2.userid
                                     AND d.userid = a.user_id
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id)
                            OR EXISTS (
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_grp_dtl b2,
                                         giis_modules_tran c,
                                         giis_user_grp_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = gibr_branch_cd
                                     AND c.module_id = 'GIACS149'
                                     AND a.user_grp = b2.user_grp
                                     AND d.user_grp = a.user_grp
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id))
                         ORDER BY tran_date) 
            LOOP
                v_list.gfun_fund_cd     := i.gfun_fund_cd;
                v_list.gibr_branch_cd   := i.gibr_branch_cd;
                v_list.gacc_tran_id     := i.gacc_tran_id;
                v_list.policy_id        := i.policy_id;
                v_list.policy_no        := i.policy_no;
                v_list.iss_cd           := i.iss_cd;
                v_list.prem_seq_no      := i.prem_seq_no;
                v_list.inst_no          := i.inst_no;
                v_list.transaction_type := i.transaction_type;
                v_list.collection_amt   := i.collection_amt;
                v_list.premium_amt      := i.premium_amt;
                v_list.tax_amt          := i.tax_amt;
                v_list.tran_date        := i.tran_date;
                v_list.tran_class       := i.tran_class;
                --v_list.tran_class_no    := i.tran_class_no;
                v_list.intm_no          := i.intm_no;
                v_list.chld_intm_no     := i.chld_intm_no;
                v_list.assd_no          := i.assd_no;
                v_list.ref_no           := i.ref_no;
                --v_list.total_prem       := i.total_prem;
                --v_list.ratio            := i.ratio;
                v_list.commission_due   := i.commission_due;
                v_list.commission_amt   := i.commission_amt;
                v_list.print_tag        := i.print_tag;
                IF i.print_tag = 'Y' THEN
                    v_list.dsp_print_tag := 'Y';
                ELSE
                    v_list.dsp_print_tag := 'N';
                END IF;
                v_list.print_date       := TO_CHAR(i.print_date, 'MM-DD-YYYY HH:MI:SS AM');
                v_list.input_vat        := i.input_vat;
                v_list.advances         := i.advances;
                v_list.withholding_tax  := i.withholding_tax;
                v_list.ocv_no           := i.ocv_no;
                v_list.ocv_pref_suf     := i.ocv_pref_suf;
                v_list.last_update      := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
                v_list.notarial_fee     := i.notarial_fee;
                v_list.other_charges    := i.other_charges;
                v_list.user_id          := i.user_id;
                v_list.cancel_tag       := i.cancel_tag;
                --v_list.cpi_rec_no       := i.cpi_rec_no;
                --v_list.cpi_branch_cd    := i.cpi_branch_cd;
                v_list.var_advances     := compute_var_advances(i.intm_no, i.iss_cd, i.prem_seq_no); 
                
                giac_p_comm_voucher_post_query(i.gfun_fund_cd, i.gibr_branch_cd, i.gacc_tran_id, i.assd_no, i.chld_intm_no, i.advances, i.commission_due,
                                               i.input_vat, i.withholding_tax, i.premium_amt, i.notarial_fee, i.other_charges, v_list.var_advances,
                                               i.tran_class, i.tran_class_no, v_list.dsp_ref_no, v_list.net_comm_due, v_list.net_comm_amt_due,
                                               v_list.prem_minus_others, v_list.assd_name, v_list.chld_intm_name);         
                
                PIPE ROW(v_list);
            END LOOP;
        ELSE        
            FOR i IN  ( SELECT * 
                          FROM GIAC_PARENT_COMM_VOUCHER
                         WHERE 1=1
                           AND intm_no = p_intm_no
                           AND (NOT EXISTS (SELECT 1
                                              FROM  giac_comm_payts
                                             WHERE gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id 
                                               AND intm_no = giac_parent_comm_voucher.chld_intm_no
                                               AND iss_cd = giac_parent_comm_voucher.iss_cd
                                               AND prem_seq_no = giac_parent_comm_voucher.prem_seq_no)
                                 OR EXISTS (SELECT 1
                                              FROM giac_comm_payts s, giac_acctrans t
                                             WHERE 1=1 
                                               AND s.gacc_tran_id = t.tran_id
                                               AND s.gacc_tran_id > 0
                                               AND s.gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id
                                               AND s.intm_no = giac_parent_comm_voucher.chld_intm_no
                                               AND s.iss_cd = giac_parent_comm_voucher.iss_cd
                                               AND s.prem_seq_no = giac_parent_comm_voucher.prem_seq_no
                                               AND t.tran_flag <> 'D'
                                               AND NOT EXISTS(SELECT 1
                                                                FROM giac_reversals c,
                                                                     giac_acctrans  d
                                                               WHERE c.reversing_tran_id = d.tran_id
                                                                 AND d.tran_flag        <> 'D'
                                                                 AND c.gacc_tran_id = s.gacc_tran_id))) 
                           AND gfun_fund_cd = NVL(v_gfun_fund_cd, gfun_fund_cd)
                           AND gibr_branch_cd = NVL(v_iss_cd, gibr_branch_cd)
                           AND ((p_from_date IS NULL AND p_to_date IS NULL)
                                OR (TRUNC(tran_date) >= TO_DATE(p_from_date, 'MM-DD-RRRR')  
                                    AND TRUNC(tran_date) <= TO_DATE(p_to_date, 'MM-DD-RRRR') )                                 
                                AND print_date IS NULL ) 
                           --AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIACS149', p_user_id) = 1
                           AND (EXISTS ( --added by steven 10.08.2014; to replace check_user_per_iss_cd_acctg2
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_iss_cd b2,
                                         giis_modules_tran c,
                                         giis_user_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = gibr_branch_cd
                                     AND c.module_id = 'GIACS149'
                                     AND a.user_id = b2.userid
                                     AND d.userid = a.user_id
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id)
                            OR EXISTS (
                                  SELECT d.access_tag
                                    FROM giis_users a,
                                         giis_user_grp_dtl b2,
                                         giis_modules_tran c,
                                         giis_user_grp_modules d
                                   WHERE a.user_id = p_user_id
                                     AND b2.iss_cd = gibr_branch_cd
                                     AND c.module_id = 'GIACS149'
                                     AND a.user_grp = b2.user_grp
                                     AND d.user_grp = a.user_grp
                                     AND b2.tran_cd = c.tran_cd
                                     AND d.tran_cd = c.tran_cd
                                     AND d.module_id = c.module_id))
                         ORDER BY tran_date)
            LOOP
                v_list.gfun_fund_cd     := i.gfun_fund_cd;
                v_list.gibr_branch_cd   := i.gibr_branch_cd;
                v_list.gacc_tran_id     := i.gacc_tran_id;
                v_list.policy_id        := i.policy_id;
                v_list.policy_no        := i.policy_no;
                v_list.iss_cd           := i.iss_cd;
                v_list.prem_seq_no      := i.prem_seq_no;
                v_list.inst_no          := i.inst_no;
                v_list.transaction_type := i.transaction_type;
                v_list.collection_amt   := i.collection_amt;
                v_list.premium_amt      := i.premium_amt;
                v_list.tax_amt          := i.tax_amt;
                v_list.tran_date        := i.tran_date;
                v_list.tran_class       := i.tran_class;
                --v_list.tran_class_no    := i.tran_class_no;
                v_list.intm_no          := i.intm_no;
                v_list.chld_intm_no     := i.chld_intm_no;
                v_list.assd_no          := i.assd_no;
                v_list.ref_no           := i.ref_no;
                --v_list.total_prem       := i.total_prem;
                --v_list.ratio            := i.ratio;
                v_list.commission_due   := i.commission_due;
                v_list.commission_amt   := i.commission_amt;                
                v_list.print_tag        := i.print_tag;
                IF i.print_tag = 'Y' THEN
                    v_list.dsp_print_tag := 'Y';
                ELSE
                    v_list.dsp_print_tag := 'N';
                END IF;
                 v_list.print_date       := TO_CHAR(i.print_date, 'MM-DD-YYYY HH:MI:SS AM');
                v_list.input_vat        := i.input_vat;
                v_list.advances         := i.advances;
                v_list.withholding_tax  := i.withholding_tax;
                v_list.ocv_no           := i.ocv_no;
                v_list.ocv_pref_suf     := i.ocv_pref_suf;
                v_list.last_update      := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
                v_list.notarial_fee     := i.notarial_fee;
                v_list.other_charges    := i.other_charges;
                v_list.user_id          := i.user_id;
                v_list.cancel_tag       := i.cancel_tag;
                --v_list.cpi_rec_no       := i.cpi_rec_no;
                --v_list.cpi_branch_cd    := i.cpi_branch_cd;
                v_list.var_advances     := compute_var_advances(i.intm_no, i.iss_cd, i.prem_seq_no);
                
                giac_p_comm_voucher_post_query(i.gfun_fund_cd, i.gibr_branch_cd, i.gacc_tran_id, i.assd_no, i.chld_intm_no, i.advances, i.commission_due,
                                               i.input_vat, i.withholding_tax, i.premium_amt, i.notarial_fee, i.other_charges, v_list.var_advances,
                                               i.tran_class, i.tran_class_no, v_list.dsp_ref_no, v_list.net_comm_due, v_list.net_comm_amt_due,
                                               v_list.prem_minus_others, v_list.assd_name, v_list.chld_intm_name);  
                                               
                PIPE ROW(v_list);
            END LOOP;
        END IF;
    END get_comm_voucher_list;


    PROCEDURE update_input_vat_advances(
        p_gfun_fund_cd      IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN  GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_input_vat         IN  GIAC_PARENT_COMM_VOUCHER.INPUT_VAT%type,
        p_advances          IN  GIAC_PARENT_COMM_VOUCHER.ADVANCES%type,
        p_user_id           IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type
    )
    AS
    BEGIN
       /* UPDATE giac_parent_comm_voucher
           SET input_vat = p_input_vat,
               --advances = p_advances,
               last_update = SYSDATE,
               user_id = p_user_id
         WHERE gfun_fund_cd = p_gfun_fund_cd
           AND gibr_branch_cd = p_gibr_branch_cd
           AND gacc_tran_id = p_gacc_tran_id
           AND transaction_type = p_transaction_type
           AND iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no
           AND inst_no = p_inst_no
           AND intm_no = p_intm_no
           AND chld_intm_no = p_chld_intm_no;*/
        NULL;
    END update_input_vat_advances;
    
        
    PROCEDURE compute_totals(
        p_intm_no       IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_user_id       IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_tagged_prem   OUT     NUMBER,
        p_tagged_comm   OUT     NUMBER,
        p_grand_prem    OUT     NUMBER,
        p_grand_comm    OUT     NUMBER,
        p_from_date     IN      VARCHAR2,
        p_to_date       IN      VARCHAR2
    )
    AS
        v_prem_g    NUMBER := 0;
        v_comm_g    NUMBER := 0;
        v_prem_t    NUMBER := 0;
        v_comm_t    NUMBER := 0;
        v_advance   NUMBER := 0;
    BEGIN
        FOR x IN (SELECT iss_cd, prem_seq_no, intm_no, print_tag, NVL(premium_amt, 0) premium_amt, NVL(commission_due, 0) commission_due,
                         NVL(input_vat, 0) input_vat, NVL(advances, 0) advances, NVL(withholding_tax, 0) withholding_tax
                      FROM giac_parent_comm_voucher
                     WHERE 1 = 1
                       AND (   NOT EXISTS (
                                  SELECT 1
                                    FROM giac_comm_payts
                                   WHERE gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id
                                     AND intm_no = giac_parent_comm_voucher.chld_intm_no
                                     AND iss_cd = giac_parent_comm_voucher.iss_cd
                                     AND prem_seq_no = giac_parent_comm_voucher.prem_seq_no)
                            OR EXISTS (
                                  SELECT 1
                                    FROM giac_comm_payts s, giac_acctrans t
                                   WHERE 1 = 1
                                     AND s.gacc_tran_id = t.tran_id
                                     AND s.gacc_tran_id > 0
                                     AND s.gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id
                                     AND s.intm_no = giac_parent_comm_voucher.chld_intm_no
                                     AND s.iss_cd = giac_parent_comm_voucher.iss_cd
                                     AND s.prem_seq_no = giac_parent_comm_voucher.prem_seq_no
                                     AND t.tran_flag <> 'D'
                                     AND NOT EXISTS (
                                            SELECT 1
                                              FROM giac_reversals c, giac_acctrans d
                                             WHERE c.reversing_tran_id = d.tran_id
                                               AND d.tran_flag <> 'D'
                                               AND c.gacc_tran_id = s.gacc_tran_id))
                           )
                       AND intm_no = p_intm_no
                       AND ((p_from_date IS NULL AND p_to_date IS NULL)
                                OR (TRUNC(tran_date) >= TO_DATE(p_from_date, 'MM-DD-RRRR')  
                                    AND TRUNC(tran_date) <= TO_DATE(p_to_date, 'MM-DD-RRRR') )                                 
                                AND print_date IS NULL )
                       AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIACS149', p_user_id) = 1 )
        LOOP
            
            v_advance := 0;
            v_prem_g := v_prem_g + x.premium_amt;
            
            BEGIN
            SELECT NVL (SUM (NVL(a.comm_amt,0) - NVL(a.wtax_amt,0) + NVL(a.input_vat,0)), 0) advances
              INTO v_advance
              FROM   giac_ovride_comm_payts a, giac_acctrans b
             WHERE iss_cd = x.iss_cd
               AND prem_seq_no = x.prem_seq_no
               AND a.intm_no = x.intm_no
               AND a.gacc_tran_id = b.tran_id
               AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                            FROM giac_reversals c, giac_acctrans d
                                           WHERE c.reversing_tran_id = d.tran_id
                                             AND d.tran_flag <> 'D')
               AND b.tran_flag <> 'D';
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                v_advance := 0;
            END;
            
            v_comm_g := v_comm_g + (x.commission_due + x.input_vat - x.advances - x.withholding_tax - v_advance);
            IF x.print_tag <> 'N' THEN
                v_prem_t := v_prem_t  + x.premium_amt;
                v_comm_t := v_comm_t + (x.commission_due + x.input_vat - x.advances - x.withholding_tax - v_advance);
            END IF;

        END LOOP;
        
        p_tagged_prem := v_prem_t; -- premium tagged total
        p_tagged_comm := v_comm_t; -- comm tagged total
        p_grand_prem  := v_prem_g; -- premium grand total
        p_grand_comm  := v_comm_g; -- comm grand total
    END compute_totals;
    
    
    PROCEDURE check_cv_seq(
        p_gfun_fund_cd      IN   GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        /*p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN  GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_cv_no             IN  NUMBER,
        p_cv_pref           IN  VARCHAR2, */
        p_doc_name          IN  giac_doc_sequence.DOC_NAME%type,
        p_user              IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        /*p_voucher_no        OUT GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        --p_voucher_pref_suf  OUT giac_doc_sequence.DOC_PREF_SUF%type,
        p_voucher_date      OUT GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,*/
        p_found             OUT VARCHAR2,
        p_max_no            OUT NUMBER
    )
    AS
        CURSOR gion IS
            SELECT '1'
              FROM giac_doc_sequence a,
              /*AND NVL(doc_pref_suf, '-') = NVL(p_CV_pref, NVL(doc_pref_suf, '-'))
              AND branch_cd = :giac_parent_comm_voucher.gibr_branch_cd
              AND fund_cd = :giac_parent_comm_voucher.gfun_fund_cd;*/--COMMENTED BY LINA
                 --added by lina 11-9-05
                   giis_user_grp_hdr b, 
                   giis_users c 
             WHERE doc_name = p_doc_name
               AND a.branch_cd = b.grp_iss_cd
               AND a.fund_cd = p_gfun_fund_cd
               AND b.user_grp = c.user_grp
               AND c.user_id = P_USER;
               
        v_exists    VARCHAR2(1);
        v_max_no    NUMBER(10);
    BEGIN
        OPEN gion;
        FETCH gion INTO v_exists;
            IF gion%FOUND THEN
                SELECT max(doc_seq_no) + 1
                  INTO p_max_no
                  FROM giac_doc_sequence a,
                       giis_user_grp_hdr b, 
                       giis_users c 
                 WHERE doc_name = p_doc_name
                   /*         AND NVL(doc_pref_suf, '-') = NVL(p_CV_pref, NVL(doc_pref_suf, '-'))
                  AND branch_cd = :giac_parent_comm_voucher.gibr_branch_cd
                  AND fund_cd = :giac_parent_comm_voucher.gfun_fund_cd;*/--commented by lina
                  --added by lina 11-9-05
                   AND a.branch_cd = b.grp_iss_cd
                   AND a.fund_cd = p_gfun_fund_cd
                   AND b.user_grp = c.user_grp
                   AND c.user_id = P_USER;
            
                --:totals.voucher_no := v_max_no; --commented by A.R.C. 08.04.2005   
                --added by A.R.C. 08.01.2005  
                
                /* ======= done in javascript ======= 
                IF p_cv_no <> 0 THEN
                    p_voucher_no := p_cv_no;  
                    BEGIN
                        SELECT print_date
                          INTO p_voucher_date
                          FROM giac_parent_comm_voucher
                         where gacc_tran_id = p_gacc_tran_id
                           and iss_cd =p_iss_cd
                           and prem_seq_no = p_prem_seq_no
                           and inst_no = p_inst_no
                           and intm_no = p_intm_no
                           and gibr_branch_cd = p_gibr_branch_cd
                           and gfun_fund_Cd = p_gfun_fund_Cd
                           and transaction_type = p_transaction_type
                           and chld_intm_no = p_chld_intm_no;  	    
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          p_voucher_date := NULL;
                    END;
                ELSE	
                    p_voucher_no := v_max_no;
                    p_voucher_date := sysdate;
                END IF; 
            
                --:totals.voucher_pref_suf := p_doc_name; --commented by A.R.C. 08.01.2005
                p_voucher_pref_suf := p_cv_pref; --added by A.R.C. 08.01.2005 
                */ 
                p_found := 'Y';
            ELSE
               /* ======= done in javascript =======  
                p_voucher_no := 1;
                p_voucher_date := sysdate;
                --:totals.voucher_pref_suf := p_doc_name; --commented by A.R.C. 08.01.2005
                p_voucher_pref_suf := p_cv_pref;  --added by A.R.C. 08.01.2005 */
                p_found := 'N';
            END IF;
        CLOSE gion;
        
    END check_cv_seq;
    
    
    PROCEDURE update_vat(
        p_gfun_fund_cd      IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN  GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_commission_due    IN  GIAC_PARENT_COMM_VOUCHER.COMMISSION_DUE%type
    )
    AS
         v_input_vat    giac_parent_comm_voucher.input_vat%TYPE;
    BEGIN
        FOR A IN (SELECT input_vat_rate
                    FROM giis_intermediary
                   WHERE intm_no = p_intm_no)
        LOOP
            --v_input_vat := v_commission_amt * (a.input_vat_rate/100); comment out by aliza 10272011
     	    v_input_vat := p_commission_due * (a.input_vat_rate/100); --added by aliza 10272011

			UPDATE giac_parent_comm_voucher
			   SET input_vat = v_input_vat
			 WHERE 1=1
			   AND gfun_fund_cd = p_gfun_fund_cd 
			   AND gibr_branch_cd  = p_gibr_branch_cd 
			   AND gacc_tran_id = p_gacc_tran_id 
			   AND transaction_type = p_transaction_type 
			   AND iss_cd = p_iss_cd 
			   AND prem_seq_no = p_prem_seq_no
			   AND inst_no = p_inst_no 
			   AND intm_no = p_intm_no    
			   AND chld_intm_no = p_chld_intm_no;
                   			   
        END LOOP;
    END update_vat;
    
    PROCEDURE populate_cv_seq(
        p_gfun_fund_cd      IN      GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN      GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN      GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN      GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN      GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN      GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN      GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_cv_no             IN      GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_cv_pref           IN      VARCHAR2,
        p_doc_name          IN      GIAC_DOC_SEQUENCE.DOC_NAME%type,
        p_user_id           IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_voucher_no        IN OUT  NUMBER,
        p_voucher_date      OUT     GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,
        p_reprint           OUT     VARCHAR2
    )
    AS
        CURSOR gion IS
            SELECT '1'
             /* FROM giac_doc_sequence
              WHERE doc_name = p_doc_name
              AND NVL(doc_pref_suf, '-') = NVL(p_CV_pref, NVL(doc_pref_suf, '-'))
              AND branch_cd = :giac_parent_comm_voucher.gibr_branch_cd
              AND fund_cd = :giac_parent_comm_voucher.gfun_fund_cd;*/--commented by lina
              /*added by lina*/
              FROM giac_doc_sequence a,
                   giis_user_grp_hdr b, 
                   giis_users c 
             WHERE doc_name = p_doc_name
               AND a.branch_cd = b.grp_iss_cd
               AND a.fund_cd = p_gfun_fund_cd
               AND b.user_grp = c.user_grp
               AND c.user_id = P_USER_ID;
    
    v_exists        VARCHAR2(1);
    v_max_no        NUMBER(10);
    v_grp_iss_cd    varchar2(2);
    v_inserted      VARCHAR2(1) := 'N';
    BEGIN
        p_reprint := 'N';
        
        OPEN gion;
        FETCH gion INTO v_exists;
            IF gion%FOUND THEN
                --commented by A.R.C. 08.04.2005
                /*      SELECT max(doc_seq_no) + 1
                        INTO v_max_no
                        FROM giac_doc_sequence
                       WHERE doc_name = p_doc_name
                         AND NVL(doc_pref_suf, '-') = NVL(p_cv_pref, NVL(doc_pref_suf, '-'))
                         AND branch_cd = p_gibr_branch_cd
                         AND fund_cd = p_gfun_fund_cd;


                      p_voucher_no := v_max_no;
                      p_voucher_date := sysdate;


                      UPDATE GIAC_DOC_SEQUENCE
                      SET doc_seq_no = p_voucher_no
                       WHERE doc_name = p_doc_name
                         AND NVL(doc_pref_suf, '-') = NVL(p_CV_pref, NVL(doc_pref_suf, '-'))
                         AND branch_cd = p_gibr_branch_cd
                         AND fund_cd = p_gfun_fund_cd;*/
                     --added by A.R.C. 08.04.2005     
                
                IF p_cv_no <> 0 THEN
                    p_voucher_no := p_cv_no;
                    BEGIN
                        SELECT print_date
                          INTO p_voucher_date
                          FROM giac_parent_comm_voucher
                         where gacc_tran_id = p_gacc_tran_id
                           and iss_cd = p_iss_cd
                           and prem_seq_no = p_prem_seq_no
                           and inst_no = p_inst_no
                           and intm_no = p_intm_no
                           and gibr_branch_cd = p_gibr_branch_cd
                           and gfun_fund_Cd = p_gfun_fund_Cd
                           and transaction_type = p_transaction_type
                           and chld_intm_no = p_chld_intm_no;  	    
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          p_voucher_date := NULL;
                    END; 
                    p_reprint := 'Y'; --added by A.R.C. 08.04.2005
                ELSE	
                    /*SELECT max(doc_seq_no) + 1
                        INTO v_max_no
                        FROM giac_doc_sequence
                       WHERE doc_name = p_doc_name
                         AND NVL(doc_pref_suf, '-') = NVL(p_CV_pref, NVL(doc_pref_suf, '-'))
                         AND branch_cd = p_gibr_branch_cd
                         AND fund_cd = p_gfun_fund_cd;*/--COMMENTED BY LINA
                      --added by lina
                    for c in(SELECT doc_pref_suf slip_pref, doc_seq_no slip_no, b.grp_iss_cd  
                               FROM giac_doc_sequence a,
                                    giis_user_grp_hdr b, 
                                    giis_users c 
                              WHERE doc_name = p_doc_name
                                AND a.branch_cd = b.grp_iss_cd
                                AND a.fund_cd = p_gfun_fund_cd
                                AND b.user_grp = c.user_grp
                                AND c.user_id = p_user_id )
                    LOOP
                        v_max_no := c.slip_no + 1;
                        v_grp_iss_cd := c.grp_iss_cd;   
                        EXIT;
                    END LOOP;
                		 

                    p_voucher_no := v_max_no;
                    p_voucher_date := sysdate;


                    UPDATE GIAC_DOC_SEQUENCE
                       SET doc_seq_no = p_voucher_no
                     WHERE doc_name = p_doc_name
                      /* AND NVL(doc_pref_suf, '-') = NVL(p_CV_pref, NVL(doc_pref_suf, '-'))
                      AND branch_cd = :giac_parent_comm_voucher.gibr_branch_cd
                      AND fund_cd = :giac_parent_comm_voucher.gfun_fund_cd;*/--COMMENTED BY LINA
                      AND branch_cd = v_grp_iss_cd
                      AND fund_cd = p_gfun_fund_cd;
                END IF;
            ELSE
                FOR i IN (SELECT *
                            FROM GIAC_DOC_SEQUENCE
                           WHERE fund_cd = p_gfun_fund_cd
                             AND branch_cd = p_gibr_branch_cd
                             AND doc_name = p_doc_name)
                LOOP
                    v_inserted := 'Y';
                    EXIT;
                END LOOP;
            
                IF v_inserted = 'N' THEN
                    INSERT INTO giac_doc_sequence ( fund_cd, 
                                                    branch_cd,
                                                    doc_name, 
                                                    doc_seq_no,
                                                    user_id, 
                                                    last_update,
                                                    doc_pref_suf)
                                          VALUES ( p_gfun_fund_cd,
                                                   p_gibr_branch_cd,
                                                   p_doc_name, 
                                                   1, 
                                                   p_user_id,
                                                   SYSDATE,
                                                   p_cv_pref);
                END IF;
                
                p_voucher_no := 1;
                p_voucher_date := sysdate;
            END IF;
        CLOSE gion;
    END populate_cv_seq;
    
    
    FUNCTION gpcv_get(
        p_intm_no       GIAC_PARENT_COMM_VOUCHER.INTM_NO%type
    ) RETURN gpcv_tab PIPELINED
    AS
        v_list      gpcv_type;
    BEGIN
        FOR i IN(SELECT gfun_fund_cd, gibr_branch_cd, gacc_tran_id, transaction_type, iss_cd, prem_seq_no,
                        inst_no, intm_no, chld_intm_no, ref_no, ocv_no, ocv_pref_suf, last_update, user_id, print_date
                   FROM giac_parent_comm_voucher
                  WHERE print_tag <> 'N'
                   AND intm_no = p_intm_no
                   AND (NOT EXISTS (SELECT 1 --Added by carloR SR-23129 10/6/2016 start
                                   FROM giac_comm_payts
                                  WHERE gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id 
                                    AND intm_no = giac_parent_comm_voucher.chld_intm_no
                                    AND iss_cd = giac_parent_comm_voucher.iss_cd
                                    AND prem_seq_no = giac_parent_comm_voucher.prem_seq_no)
                      OR EXISTS (SELECT 1
                                   FROM giac_comm_payts s, giac_acctrans t
                                  WHERE 1=1 
                                    AND s.gacc_tran_id = t.tran_id
                                    AND s.gacc_tran_id > 0
                                    AND s.gacc_tran_id = giac_parent_comm_voucher.gacc_tran_id
                                    AND s.intm_no = giac_parent_comm_voucher.chld_intm_no
                                    AND s.iss_cd = giac_parent_comm_voucher.iss_cd
                                    AND s.prem_seq_no = giac_parent_comm_voucher.prem_seq_no
                                    AND t.tran_flag <> 'D'
                                    AND NOT EXISTS(SELECT 1
                                                     FROM giac_reversals c,
                                                          giac_acctrans  d
                                                    WHERE c.reversing_tran_id = d.tran_id
                                                      AND d.tran_flag        <> 'D'
                                                      AND c.gacc_tran_id = s.gacc_tran_id)) )) --end
        LOOP
            v_list.gfun_fund_cd     := i.gfun_fund_cd;
            v_list.gibr_branch_cd   := i.gibr_branch_cd;
            v_list.gacc_tran_id     := i.gacc_tran_id;
            v_list.transaction_type := i.transaction_type;
            v_list.iss_cd           := i.iss_cd;
            v_list.prem_seq_no      := i.prem_seq_no;
            v_list.inst_no          := i.inst_no;
            v_list.intm_no          := i.intm_no;
            v_list.chld_intm_no     := i.chld_intm_no;
            v_list.ref_no           := i.ref_no;
            v_list.ocv_no           := i.ocv_no;
            v_list.ocv_pref_suf     := i.ocv_pref_suf;
            v_list.last_update      := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM'); --i.last_update;
            v_list.user_id          := i.user_id;
            v_list.print_date       := TO_CHAR(i.print_date, 'MM-DD-RRRR HH:MI:SS AM'); --i.print_date;
            PIPE ROW(v_list);
        END LOOP;
    END gpcv_get;
    
    
    PROCEDURE update_gpcv(
        p_gfun_fund_cd      IN      GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN      GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN      GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN      GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN      GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN      GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN      GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_voucher_no        IN      GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_cv_pref           IN      VARCHAR2,
        p_user_id           IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type
    )
    AS
    BEGIN
        update giac_parent_comm_voucher
           set ref_no = GET_REF_NO(gacc_tran_id),
               ocv_no = p_voucher_no,
               ocv_pref_suf = p_cv_pref,
               last_update = sysdate,
               user_id   = p_user_id, 
               print_date = NULL
           where gacc_tran_id = p_gacc_tran_id
             and iss_cd = p_iss_cd
             and prem_seq_no = p_prem_seq_no
             and inst_no = p_inst_no
             and intm_no = p_intm_no
             and gibr_branch_cd = p_gibr_branch_cd
             and gfun_fund_Cd = p_gfun_fund_Cd
             and transaction_type = p_transaction_type
             and chld_intm_no = p_chld_intm_no;
    END update_gpcv;
    
    
    PROCEDURE delete_workflow_rec(
        p_event_desc    IN VARCHAR2,
        p_module_id     IN VARCHAR2,
        p_user          IN VARCHAR2,
        p_col_value     IN VARCHAR2
    )
    AS
        v_tran_id            gipi_user_events.tran_id%TYPE;
    BEGIN
        FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd 
                        FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                       WHERE 1=1
                         AND c.event_cd = a.event_cd
                         AND c.event_mod_cd = a.event_mod_cd
                         AND b.event_mod_cd = a.event_mod_cd
                         --AND b.userid = p_user
                         AND a.module_id = p_module_id
                         AND a.event_cd = d.event_cd
                         AND UPPER(d.event_desc) = UPPER(NVL(p_event_desc,d.event_desc)))
        LOOP
            FOR B_REC IN (SELECT b.col_value, b.tran_id , b.event_col_cd, b.event_user_mod, b.switch, b.user_id
                            FROM gipi_user_events b 
                           WHERE b.event_user_mod = a_rec.event_user_mod 
                             AND b.event_col_cd = a_rec.event_col_cd )
            LOOP
                IF b_rec.col_value = p_col_value THEN
                    BEGIN

                       INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
                            VALUES(b_rec.event_user_mod, b_rec.event_col_cd, b_rec.tran_id, b_rec.col_value, SYSDATE, P_USER, '-'); 

                       DELETE FROM gipi_user_events
                             WHERE event_user_mod = b_rec.event_user_mod
                               AND event_col_cd = b_rec.event_col_cd
                               AND tran_id = b_rec.tran_id;
                       
                    END;
                ELSE	
                    IF b_rec.switch = 'N' AND b_rec.user_id = p_user THEN
                       UPDATE gipi_user_events
                          SET switch = 'Y'
                        WHERE event_user_mod = b_rec.event_user_mod
                          AND event_col_cd = b_rec.event_col_cd
                          AND tran_id = b_rec.tran_id;
                    END IF;    	   
                END IF;  
            END LOOP;
    	  
        END LOOP;
        
    END delete_workflow_rec;
    
    
    PROCEDURE gpcv_restore(
        p_gfun_fund_cd      IN      GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN      GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type  IN      GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd            IN      GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no       IN      GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no           IN      GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_intm_no           IN      GIAC_PARENT_COMM_VOUCHER.INTM_NO%type,
        p_chld_intm_no      IN      GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type,
        p_print_date        IN      VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.PRINT_DATE%type,
        p_ocv_no            IN      GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_ocv_pref_suf      IN      GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF%type,
        p_ref_no            IN      GIAC_PARENT_COMM_VOUCHER.REF_NO%type,
        p_last_update       IN      VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.LAST_UPDATE%type,
        p_user_id           IN      GIAC_PARENT_COMM_VOUCHER.USER_ID%type,  -- record's user_id
        p_app_user          IN      VARCHAR2,                               -- app_user
        p_stat              IN      NUMBER            
    )
    AS
    BEGIN
        IF p_stat = 0 THEN   
            UPDATE giac_parent_comm_voucher
               SET ref_no = p_ref_no,
     	           ocv_no = p_ocv_no,
     	           ocv_pref_suf = p_ocv_pref_suf,
     	           last_update = TO_DATE(p_last_update, 'MM-DD-RRRR HH:MI:SS AM'), --p_last_update,
     	           user_id = p_user_id,
     	           print_date = NVL(TO_DATE(p_print_date, 'MM-DD-RRRR HH:MI:SS AM'), NULL) --p_print_date
             WHERE gfun_fund_cd = p_gfun_fund_cd
               AND gibr_branch_cd = p_gibr_branch_cd
               AND gacc_tran_id = p_gacc_tran_id
               AND transaction_type = p_transaction_type
               AND iss_cd = p_iss_cd
               AND prem_seq_no = p_prem_seq_no
               AND inst_no = p_inst_no
               AND intm_no = p_intm_no
               AND chld_intm_no = p_chld_intm_no;
        ELSIF p_stat = 1 THEN
           UPDATE giac_parent_comm_voucher
              SET print_date = sysdate
            WHERE gfun_fund_cd = p_gfun_fund_cd
              AND gibr_branch_cd = p_gibr_branch_cd
              AND gacc_tran_id = p_gacc_tran_id
              AND transaction_type = p_transaction_type
              AND iss_cd = p_iss_cd
              AND prem_seq_no = p_prem_seq_no
              AND inst_no = p_inst_no
              AND intm_no = p_intm_no
              AND chld_intm_no = p_chld_intm_no;               
        ELSIF p_stat = 2 THEN
            UPDATE giac_parent_comm_voucher
               SET ref_no = null,
                   ocv_no = null,
                   ocv_pref_suf = null,
                   last_update = sysdate,
                   user_id   = p_app_user,
                   print_date = NULL 
             WHERE gfun_fund_cd = p_gfun_fund_cd
               AND gibr_branch_cd = p_gibr_branch_cd
               AND gacc_tran_id = p_gacc_tran_id
               AND transaction_type = p_transaction_type
               AND iss_cd = p_iss_cd
               AND prem_seq_no = p_prem_seq_no
               AND inst_no = p_inst_no
               AND intm_no = p_intm_no
               AND chld_intm_no = p_chld_intm_no;  
        END IF;	
    END gpcv_restore;
    
    
    PROCEDURE update_print_tag(
        p_intm_no               IN  GIIS_INTERMEDIARY.INTM_NO%type,
        p_gfun_fund_cd          IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd        IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_from_date             IN  VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_to_date               IN  VARCHAR2, --GIAC_PARENT_COMM_VOUCHER.TRAN_DATE%type,
        p_workflow_col_value    IN  VARCHAR2,
        p_user_id               IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_dsp_print_tag         IN  VARCHAR2,
        p_ocv_no                IN  GIAC_PARENT_COMM_VOUCHER.OCV_NO%type,
        p_ocv_pref_suf          IN  GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF%type,
        p_gacc_tran_id          IN  GIAC_PARENT_COMM_VOUCHER.GACC_TRAN_ID%type,
        p_transaction_type      IN  GIAC_PARENT_COMM_VOUCHER.TRANSACTION_TYPE%type,
        p_iss_cd                IN  GIAC_PARENT_COMM_VOUCHER.ISS_CD%type,
        p_prem_seq_no           IN  GIAC_PARENT_COMM_VOUCHER.PREM_SEQ_NO%type,
        p_inst_no               IN  GIAC_PARENT_COMM_VOUCHER.INST_NO%type,
        p_chld_intm_no          IN  GIAC_PARENT_COMM_VOUCHER.CHLD_INTM_NO%type
    ) AS
    BEGIN
--        FOR i IN (SELECT * --remove by steven 10.08.2014
--                    FROM TABLE(GET_COMM_VOUCHER_LIST(p_intm_no, p_gfun_fund_cd, p_gibr_branch_cd, p_from_date, p_to_date, p_workflow_col_value, p_user_id)) )
--        LOOP
        IF (p_ocv_no IS NOT NULL AND p_ocv_pref_suf IS NOT NULL) THEN
            UPDATE GIAC_PARENT_COMM_VOUCHER
               SET print_tag = p_dsp_print_tag
             WHERE ocv_no = p_ocv_no
               AND ocv_pref_suf = p_ocv_pref_suf;
        ELSE
            UPDATE GIAC_PARENT_COMM_VOUCHER
               SET print_tag = p_dsp_print_tag
             WHERE gacc_tran_id = p_gacc_Tran_Id
               AND UPPER(transaction_type) = UPPER(p_transaction_Type)
               AND UPPER(iss_cd) = UPPER(p_iss_Cd)
               AND prem_seq_no = p_prem_Seq_No
               AND inst_no = p_inst_No
               AND chld_intm_no = p_chld_Intm_No;
        END IF;
--        END LOOP;
    END update_print_tag;
    
    /** added as per Test Case Accounting - Overriding Commission Voucher_GIACS149_v.02_TR01 */
    PROCEDURE insert_spoiled_ocv(
        p_intm_no               IN  GIIS_INTERMEDIARY.INTM_NO%type,
        p_gfun_fund_cd          IN  GIAC_PARENT_COMM_VOUCHER.GFUN_FUND_CD%type,
        p_gibr_branch_cd        IN  GIAC_PARENT_COMM_VOUCHER.GIBR_BRANCH_CD%type,
        p_user_id               IN  GIAC_PARENT_COMM_VOUCHER.USER_ID%type,
        p_voucher_no            IN  NUMBER,                                         
        p_doc_name              IN  VARCHAR2,
        p_commission_due        IN  NUMBER,
        p_net_comm_amt_due      IN  NUMBER
    )
    AS
    BEGIN
        INSERT into giac_spoiled_ocv (FUND_CD ,BRANCH_CD, INTM_NO, OCV_PREF_SUF, OCV_NO, PRINT_DATE, GROSS_COMM_AMT, 
                                      NET_COMM_AMT, LAST_UPDATE, USER_ID)
                              VALUES (p_gfun_fund_Cd, p_gibr_branch_cd,  p_intm_no, p_doc_name, p_voucher_no, sysdate, p_commission_due, 
                                      p_net_comm_amt_due, sysdate, p_user_id); 
    END insert_spoiled_ocv;
    
    
    PROCEDURE update_doc_seq_no(
        p_gfun_fund_cd      IN  VARCHAR2,
        p_doc_name          IN  VARCHAR2,
        p_ocv_pref_suf      IN  VARCHAR2,
        p_user_id           IN  VARCHAR2
    )
    AS
        v_grp_iss_cd    VARCHAR2(5);
    BEGIN
        FOR c IN(SELECT b.grp_iss_cd  
                   FROM giac_doc_sequence a,
                        giis_user_grp_hdr b, 
                        giis_users c 
                  WHERE doc_name = p_doc_name
                    AND a.branch_cd = b.grp_iss_cd
                    AND a.fund_cd = p_gfun_fund_cd
                    AND b.user_grp = c.user_grp
                    AND c.user_id = p_user_id )
        LOOP
            v_grp_iss_cd := c.grp_iss_cd;   
            EXIT;
        END LOOP;
        
        UPDATE giac_doc_sequence
           SET doc_seq_no = doc_seq_no - 1
         WHERE doc_name = p_doc_name
           AND NVL(doc_pref_suf, '-') =  NVL(p_ocv_pref_suf, NVL(doc_pref_suf, '-'))
           AND branch_cd = v_grp_iss_cd
           AND fund_cd = p_gfun_fund_cd;
           
    END update_doc_seq_no;
    
END GIACS149_PKG;
/


