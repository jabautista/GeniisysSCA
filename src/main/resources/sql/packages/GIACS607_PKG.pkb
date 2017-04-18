CREATE OR REPLACE PACKAGE BODY CPI.GIACS607_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.06.2015
     ** Referenced By:  GIACS607 - PROCESS PREMIUMS AND COMMISSIONS
     **/   
    
    PROCEDURE get_parameters(
        p_user_id               IN  VARCHAR2,
        p_fund_cd               OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_fund_desc             OUT giis_funds.fund_desc%TYPE,
        p_branch_cd             OUT giis_user_grp_hdr.grp_iss_cd%type,
        p_branch_name           OUT giac_branches.branch_name%type,
        p_evat_cd               OUT NUMBER,
        p_tax_allocation        OUT giac_parameters.param_value_v%TYPE,
        p_mgmt_comp             OUT VARCHAR2,
        p_comm_exp_gen          OUT giac_parameters.param_value_v%TYPE,
        p_comm_payable_take_up  OUT giac_parameters.param_value_v%TYPE,
        p_prem_payt_for_sp      OUT giac_parameters.param_value_v%TYPE,
        p_stale_check           OUT giac_parameters.param_value_v%TYPE,
        p_stale_days            OUT giac_parameters.param_value_v%TYPE,
        p_stale_mgr_chk         OUT giac_parameters.param_value_v%TYPE,        
        p_sl_type_cd1           OUT giac_parameters.param_name%TYPE,
        p_sl_type_cd2           OUT giac_parameters.param_name%TYPE,
        p_sl_type_cd3           OUT giac_parameters.param_name%TYPE,
        p_dflt_dcb_bank_cd      OUT giac_dcb_users.BANK_CD%TYPE,
        p_dflt_dcb_bank_name    OUT giac_banks.BANK_NAME%TYPE,
        p_dflt_dcb_bank_acct_cd OUT giac_dcb_users.BANK_ACCT_CD%TYPE,
        p_dflt_dcb_bank_acct_no OUT giac_bank_accounts.BANK_ACCT_NO%TYPE,    
        p_jv_tran_type          OUT giac_jv_trans.JV_TRAN_CD%type,
        p_jv_tran_desc          OUT giac_jv_trans.JV_TRAN_DESC%type,  
        p_dflt_currency_cd      OUT giac_parameters.param_value_v%type,
        p_dflt_currency_sname   OUT giis_currency.short_name%type,
        p_dflt_currency_rt      OUT giis_currency.currency_rt%type
    )
    AS
        v_sl_type1              giac_module_entries.sl_type_cd%TYPE;
        v_sl_type2              giac_module_entries.sl_type_cd%TYPE;  
        v_sl_type3              giac_module_entries.sl_type_cd%TYPE; 
        v_assd_no                giis_assured.assd_no%TYPE;
        v_intm_no                giis_intermediary.intm_no%TYPE;
        v_line_cd                giis_line.line_cd%TYPE;
        v_module_id             giac_modules.module_id%TYPE;
        v_item_no               giac_module_entries.item_no%TYPE := 1;
        v_item_no2              giac_module_entries.item_no%TYPE := 4;
        v_item_no3              giac_module_entries.item_no%TYPE := 5;  
    BEGIN
        p_fund_cd               := giacp.v('FUND_CD');
        p_evat_cd               := giacp.n('EVAT');
        p_prem_payt_for_sp      := nvl(giacp.v('PREM_PAYT_FOR_SPECIAL'),'N');
        p_tax_allocation        := giacp.v('TAX_ALLOCATION');
        p_comm_exp_gen          := giacp.v('COMM_EXP_GEN');
        p_comm_payable_take_up  := nvl(giacp.n('COMM_PAYABLE_TAKE_UP'),3);
        p_stale_check             := giacp.n('STALE_CHECK');
        p_stale_days            := giacp.n('STALE_DAYS');
        p_stale_mgr_chk            := giacp.n('STALE_MGR_CHK');
        p_dflt_currency_cd      := nvl(giacp.n('CURRENCY_CD'),1);
        p_mgmt_comp             := 'N';
                
        BEGIN
            SELECT fund_desc
              INTO p_fund_desc
              FROM giis_funds
             WHERE fund_cd = p_fund_cd;     
        EXCEPTION
            WHEN no_data_found THEN
                p_fund_desc := NULL;
        END;
        
        BEGIN
            SELECT a.grp_iss_cd
              INTO p_branch_cd
              FROM giis_user_grp_hdr a,
                   giis_users b
             WHERE a.user_grp = b.user_grp
               AND b.user_id = P_USER_ID;      
        EXCEPTION
            WHEN no_data_found THEN
                p_branch_cd := NULL;
        END;
        
        BEGIN
            SELECT branch_name
              INTO p_branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = p_fund_cd
               AND branch_cd = p_branch_cd; 
        EXCEPTION
            WHEN no_data_found THEN
              p_branch_name := NULL;
        END; 
        
        --- CHECK_MGMT_COMP prog unit
        --to process commission payments for policies that not yet fully paid
--        FOR rec IN (SELECT 'x'
--                  FROM giac_modules a, giac_functions b, giac_user_functions c
--                 WHERE a.module_id = b.module_id
--                   AND a.module_name = 'GIACS020' 
--                   AND b.function_code = 'MC'
--                   AND b.function_name LIKE 'MANAGEMENT_COMP%'
--                   AND c.user_id = p_user_id
--                   AND c.function_code = b.function_code
--                   AND c.module_id = b.module_id
--                   AND c.valid_tag = 'Y'
--                   AND c.validity_dt <= SYSDATE
--                   AND (c.termination_dt > SYSDATE OR
--                         c.termination_dt IS NULL))
--        LOOP
--            p_mgmt_comp := 'Y';
--            EXIT;
--        END LOOP;
        
        p_mgmt_comp := 'Y';
        
        -- start GET_SL_TYPE_PARAMETERS prog unit
        BEGIN
            BEGIN 
                SELECT param_value_v
                  INTO v_assd_no 
                  FROM giac_parameters
                 WHERE param_name = 'ASSD_SL_TYPE';
            EXCEPTION
                  WHEN no_data_found THEN
                      v_assd_no := NULL;
            END; 

            BEGIN
                SELECT param_value_v
                  INTO v_intm_no
                  FROM giac_parameters
                 WHERE param_name = 'INTM_SL_TYPE';
            EXCEPTION
              WHEN no_data_found THEN
                  v_intm_no := null;
            END;

            BEGIN
                SELECT param_value_v
                  INTO v_line_cd 
                  FROM giac_parameters
                 WHERE param_name = 'LINE_SL_TYPE';
            EXCEPTION
                WHEN no_data_found THEN
                    v_line_cd := null;
            END;

            BEGIN
                SELECT module_id
                  INTO v_module_id
                  FROM giac_modules
                 WHERE module_name  = 'GIACS020';
            EXCEPTION
                WHEN no_data_found THEN
                    v_module_id := null;
            END;
                 
            BEGIN
                SELECT sl_type_cd
                  INTO v_sl_type1
                  FROM giac_module_entries    
                 WHERE module_id = v_module_id
                   AND item_no = v_item_no;
            EXCEPTION
                WHEN no_data_found THEN
                    v_sl_type1 := null;
            END; 

            BEGIN
                SELECT sl_type_cd
                  INTO v_sl_type2
                  FROM giac_module_entries    
                 WHERE module_id = v_module_id
                   AND item_no = v_item_no2;
            EXCEPTION
                WHEN no_data_found THEN
                    v_sl_type2 := null;
            END;
                 
            BEGIN
                SELECT sl_type_cd
                  INTO v_sl_type3
                  FROM giac_module_entries    
                 WHERE module_id = v_module_id
                   AND item_no = v_item_no3;
            EXCEPTION
                WHEN no_data_found THEN
                    v_sl_type3 := null;
            END;
                 
            BEGIN 
                IF v_sl_type1 = v_assd_no THEN
                    p_sl_type_cd1 := 'ASSD_SL_TYPE';
                ELSIF v_sl_type1 = v_intm_no THEN
                    p_sl_type_cd1 := 'INTM_SL_TYPE' ; 
                ELSIF v_sl_type1 = v_line_cd THEN
                    p_sl_type_cd1:= 'LINE_SL_TYPE';
                END IF;
            END;

            BEGIN
                IF v_sl_type2 = v_assd_no THEN
                    p_sl_type_cd2 := 'ASSD_SL_TYPE';
                ELSIF v_sl_type2 = v_intm_no THEN
                    p_sl_type_cd2 := 'INTM_SL_TYPE' ; 
                ELSIF v_sl_type2 = v_line_cd THEN
                    p_sl_type_cd2 := 'LINE_SL_TYPE';
                END IF;
            END;

            BEGIN
                IF v_sl_type3 = v_assd_no THEN
                    p_sl_type_cd3 := 'ASSD_SL_TYPE';
                ELSIF v_sl_type3 = v_intm_no THEN
                    p_sl_type_cd3 := 'INTM_SL_TYPE' ; 
                ELSIF v_sl_type3 = v_line_cd THEN
                    p_sl_type_cd3 := 'LINE_SL_TYPE';
                END IF;
            END;
        END;
        -- end GET_SL_TYPE_PARAMETERS 
        
        -- start GET_DFLT_BANK_ACCT prog unit
        FOR a IN (SELECT bank_cd, bank_acct_cd
                    FROM giac_dcb_users
                   WHERE gibr_fund_cd = p_fund_cd
                     AND gibr_branch_cd = p_branch_cd
                     AND dcb_user_id = P_USER_ID)
        LOOP     
            p_dflt_dcb_bank_cd := a.bank_cd;
            p_dflt_dcb_bank_acct_cd := a.bank_acct_cd;
            
            IF a.bank_cd IS NULL THEN
                    FOR b IN (SELECT bank_cd, bank_acct_cd
                              FROM giac_branches
                             WHERE gfun_fund_cd = p_fund_cd
                               AND branch_cd = p_branch_cd)
                  LOOP     
                    p_dflt_dcb_bank_cd := b.bank_cd;
                    p_dflt_dcb_bank_acct_cd := b.bank_acct_cd;
                END LOOP;         
            END IF;
        END LOOP;

        IF p_dflt_dcb_bank_cd IS NOT NULL THEN
            FOR rec1 IN (SELECT bank_name
                           FROM giac_banks
                          WHERE bank_cd = p_dflt_dcb_bank_cd)
            LOOP
                p_dflt_dcb_bank_name := rec1.bank_name;
            END LOOP;
            
            FOR rec2 IN (SELECT bank_acct_no
                           FROM giac_bank_accounts
                          WHERE bank_cd = p_dflt_dcb_bank_cd
                            AND bank_acct_cd = p_dflt_dcb_bank_acct_cd)
            LOOP
                p_dflt_dcb_bank_acct_no := rec2.bank_acct_no;
            END LOOP;
        END IF;    
        -- end GET_DFLT_BANK_ACCT
        
        FOR c IN (SELECT jv_tran_cd, jv_tran_desc
                    FROM giac_jv_trans
                   WHERE jv_tran_tag = 'NC') 
        LOOP
            p_jv_tran_type := c.jv_tran_cd;
            p_jv_tran_desc := c.jv_tran_desc;
            EXIT;
        END LOOP;
        
        BEGIN
            SELECT currency_rt, short_name 
              INTO p_dflt_currency_rt, p_dflt_currency_sname
              FROM giis_currency
             WHERE main_currency_cd = p_dflt_currency_cd;
        EXCEPTION
            WHEN no_data_found THEN
                p_dflt_currency_rt := NULL;
                p_dflt_currency_sname := NULL;
        END;    
    END get_parameters;  
    
    FUNCTION get_legend(
        p_rv_domain     cg_ref_codes.RV_DOMAIN%TYPE
    ) RETURN VARCHAR2
    AS
        v_legend        VARCHAR2(32767);
    BEGIN
        FOR i IN (SELECT rv_low_value||' - '||rv_meaning legend
                    FROM cg_ref_codes
                   WHERE rv_domain LIKE p_rv_domain)
        LOOP
            IF v_legend IS NULL THEN
                v_legend := i.legend;
            ELSE
                v_legend := v_legend||chr(10)||i.legend;
            END IF;
        END LOOP;
        
        RETURN v_legend;
    END get_legend;
    

    FUNCTION get_guf_details(
        p_source_cd         giac_upload_file.SOURCE_CD%TYPE,
        p_file_no           giac_upload_file.FILE_NO%TYPE
    ) RETURN guf_tab PIPELINED
    AS
        rec         guf_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM giac_upload_file
                   WHERE transaction_type = 2
                     AND source_cd = p_source_cd
                     AND file_no = p_file_no)
        LOOP
            rec.source_cd           := i.SOURCE_CD;
            rec.file_no             := i.FILE_NO;
            rec.file_name           := i.FILE_NAME;
            rec.intm_no             := i.INTM_NO;
            rec.tran_date           := i.TRAN_DATE;
            rec.tran_id             := i.TRAN_ID;
            rec.file_status         := i.FILE_STATUS;
            rec.tran_class          := i.TRAN_CLASS;
            rec.convert_date        := i.CONVERT_DATE;
            rec.upload_date         := i.UPLOAD_DATE;
            rec.gross_tag           := i.GROSS_TAG;
            rec.cancel_date         := i.CANCEL_DATE;
            rec.remarks             := i.REMARKS;
            rec.no_of_records       := i.NO_OF_RECORDS; 
        
           --get source_name and or_tag
            BEGIN
                SELECT source_name, nvl(or_tag,'G')
                  INTO rec.nbt_source_name, rec.nbt_or_tag
                  FROM giac_file_source
                 WHERE source_cd = i.source_cd; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  rec.nbt_source_name := NULL;
                  rec.nbt_or_tag := 'G';
            END;
            
            --get intm details
            BEGIN
                SELECT intm_type, ref_intm_cd, intm_name, input_vat_rate
                  INTO rec.nbt_intm_type, rec.nbt_ref_intm_cd, rec.nbt_intm_name, rec.nbt_input_vat_rate
                  FROM giis_intermediary
                 WHERE intm_no = rec.intm_no; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  rec.nbt_intm_type         := NULL;
                  rec.nbt_ref_intm_cd       := NULL;
                  rec.nbt_input_vat_rate    := NULL;
            END;
            
            IF rec.tran_id IS NOT NULL THEN
                BEGIN
                    IF rec.tran_class = 'COL' AND rec.nbt_or_tag = 'G' THEN
                        SELECT giop.or_pref_suf||'-'||giop.or_no
                          INTO rec.nbt_or_req_jv_no
                          FROM giac_order_of_payts giop
                         WHERE giop.gacc_tran_id = rec.tran_id;
                    ELSIF rec.tran_class = 'DV' THEN
                        SELECT gprq.document_cd||'-'||gprq.branch_cd||'-'||gprq.doc_year||'-'||gprq.doc_mm||'-'||gprq.doc_seq_no
                          INTO rec.nbt_or_req_jv_no
                          FROM giac_payt_requests gprq, giac_payt_requests_dtl gprqd
                         WHERE gprq.ref_id = gprqd.gprq_ref_id
                           AND gprqd.tran_id = rec.tran_id
                           AND gprqd.gprq_ref_id >= 1;
                    ELSIF rec.tran_class = 'JV' THEN
                        SELECT gacc.jv_pref_suff||'-'||gacc.jv_no
                          INTO rec.nbt_or_req_jv_no
                          FROM giac_acctrans gacc
                         WHERE tran_id = rec.tran_id;
                    END IF;    
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        rec.nbt_or_req_jv_no := NULL;
                END;
                 
                IF rec.nbt_or_req_jv_no = '-' THEN
                    rec.nbt_or_req_jv_no := NULL;
                END IF;    
            END    IF;
            
            rec.nbt_tran_class := nvl(rec.tran_class, 'COL');
            rec.nbt_gross_tag := nvl(rec.gross_tag, 'Y');          
            rec.nbt_or_date := nvl(rec.tran_date, SYSDATE);
            
            PIPE ROW(rec);
        END LOOP;
    END get_guf_details;
    
    
    FUNCTION get_gupc_records(
        p_source_cd         GIAC_UPLOAD_PREM_COMM.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_PREM_COMM.FILE_NO%TYPE,
        p_policy_no         VARCHAR2,
        p_endt_no           VARCHAR2,
        p_gross_prem_amt    GIAC_UPLOAD_PREM_COMM.GROSS_PREM_AMT%TYPE,
        p_comm_amt          GIAC_UPLOAD_PREM_COMM.COMM_AMT%TYPE,
        p_whtax_amt         GIAC_UPLOAD_PREM_COMM.WHTAX_AMT%TYPE,
        p_input_vat_amt     GIAC_UPLOAD_PREM_COMM.INPUT_VAT_AMT%type,
        p_net_amt_due       GIAC_UPLOAD_PREM_COMM.NET_AMT_DUE%TYPE
    ) RETURN gupc_tab PIPELINED
    AS
        rec             gupc_type;
        v_tran_class    giac_upload_file.TRAN_CLASS%TYPE;
        v_or_tag        giac_file_source.OR_TAG%TYPE;
        v_rate          NUMBER(12,9); --jason 04/15/2008
        v_gross_amt     NUMBER(18,2);
        v_comm_amt        NUMBER(18,2);
        v_whtax_amt        NUMBER(18,2);
        v_invat_amt     NUMBER(18,2);
        v_net_amt        NUMBER(18,2);
    BEGIN
        BEGIN
            SELECT nbt_tran_class, nbt_or_tag
              INTO v_tran_class, v_or_tag
              FROM TABLE(get_guf_details(p_source_cd, p_file_no));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tran_class    := NULL;
                v_or_tag        := NULL;
        END;
        
        FOR i IN (SELECT a.*, line_cd
                                || '-'
                                || subline_cd
                                || '-'
                                || iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (renew_no, '09')) policy_no,
                             endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (endt_seq_no, '099999')) endt_no
                    FROM GIAC_UPLOAD_PREM_COMM a
                   WHERE source_cd = p_source_cd
                     AND file_no = p_file_no
                     AND gross_prem_amt = NVL(p_gross_prem_amt, gross_prem_amt)
                     AND comm_amt = NVL(p_comm_amt, comm_amt)
                     AND whtax_amt = NVL(p_whtax_amt, whtax_amt)
                     AND input_vat_amt = NVL(p_input_vat_amt, input_vat_amt)
                     AND net_amt_due = NVL(p_net_amt_due, net_amt_due)
                     AND line_cd
                                || '-'
                                || subline_cd
                                || '-'
                                || iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (renew_no, '09')) LIKE UPPER(NVL(p_policy_no, '%'))
                     AND endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (endt_seq_no, '099999')) LIKE UPPER(NVL(p_endt_no, '%'))
                   ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no)
        LOOP
            rec.source_cd           := i.SOURCE_CD;
            rec.file_no             := i.FILE_NO;
            rec.prem_chk_flag       := i.PREM_CHK_FLAG;
            rec.comm_chk_flag       := i.COMM_CHK_FLAG;
            rec.line_cd             := i.LINE_CD;
            rec.subline_cd          := i.SUBLINE_CD;
            rec.iss_cd              := i.ISS_CD;
            rec.issue_yy            := i.ISSUE_YY;
            rec.pol_seq_no          := i.POL_SEQ_NO;
            rec.renew_no            := i.RENEW_NO;
            rec.endt_iss_cd         := i.ENDT_ISS_CD;
            rec.endt_yy             := i.ENDT_YY;
            rec.endt_seq_no         := i.ENDT_SEQ_NO;
            rec.gross_prem_amt      := i.GROSS_PREM_AMT;
            rec.comm_amt            := i.COMM_AMT;
            rec.whtax_amt           := i.WHTAX_AMT;
            rec.input_vat_amt       := i.INPUT_VAT_AMT;
            rec.net_amt_due         := i.NET_AMT_DUE;
            rec.chk_remarks         := i.CHK_REMARKS;
            rec.payor               := i.PAYOR;
            rec.gross_tag           := i.GROSS_TAG;
            rec.gprem_amt_due       := i.GPREM_AMT_DUE;
            rec.comm_amt_due        := i.COMM_AMT_DUE;
            rec.whtax_amt_due       := i.WHTAX_AMT_DUE;
            rec.invat_amt_due       := i.INVAT_AMT_DUE;
            rec.tran_id             := i.TRAN_ID;
            rec.currency_cd         := i.CURRENCY_CD;
            rec.convert_rate        := i.CONVERT_RATE;
            rec.fgross_prem_amt     := i.FGROSS_PREM_AMT;
            rec.fcomm_amt           := i.FCOMM_AMT;
            rec.fwhtax_amt          := i.FWHTAX_AMT;
            rec.finput_vat_amt      := i.FINPUT_VAT_AMT;
            rec.fnet_amt_due        := i.FNET_AMT_DUE;
            
            rec.policy_no           :=  i.policy_no;
            rec.endt_no             := i.endt_no;
            
            rec.nbt_policy_id := NULL;
            rec.nbt_assd_no     := NULL;
            
            FOR j IN (SELECT assd_no, par_id, policy_id
                          FROM gipi_polbasic
                         WHERE 1=1
                           AND line_cd     = i.line_cd
                           AND subline_cd  = i.subline_cd
                           AND iss_cd      = i.iss_cd
                           AND issue_yy    = i.issue_yy
                           AND pol_seq_no  = i.pol_seq_no
                           AND renew_no    = i.renew_no
                           AND endt_iss_cd = i.endt_iss_cd
                           AND endt_yy     = i.endt_yy
                           AND endt_seq_no = i.endt_seq_no)
            LOOP    
                rec.nbt_policy_id   := j.policy_id;
                rec.nbt_assd_no     := j.assd_no;
                
                IF j.assd_no IS NULL THEN
                    FOR k IN (SELECT assd_no
                                FROM gipi_parlist
                               WHERE par_id = j.par_id)
                    LOOP
                        rec.nbt_assd_no := k.assd_no;
                    END LOOP;
                END IF;
                EXIT;
            END LOOP;
            
            IF i.chk_remarks IS NOT NULL THEN --jason 04/15/2008: added the condition 
                --get the amount differences
                rec.nbt_gprem_diff := i.gprem_amt_due - i.gross_prem_amt;
                rec.nbt_comm_diff  := i.comm_amt_due - i.comm_amt;
                rec.nbt_whtax_diff := i.whtax_amt_due - i.whtax_amt;
                rec.nbt_input_vat_diff := i.invat_amt_due - i.input_vat_amt;
                rec.nbt_net_due_diff := i.gprem_amt_due - (i.comm_amt_due - i.whtax_amt_due + i.invat_amt_due) - i.net_amt_due;
            END IF;
            
            IF v_tran_class = 'COL' AND v_or_tag = 'I' THEN
                FOR j IN (SELECT giop.or_pref_suf||'-'||giop.or_no or_no
                              FROM giac_order_of_payts giop
                             WHERE giop.gacc_tran_id = i.tran_id)
                LOOP    
                    rec.nbt_or_no := j.or_no;
                    IF j.or_no = '-' THEN
                        rec.nbt_or_no := NULL;
                    END IF;    
                END LOOP;
            END IF;
            
            FOR j IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = i.currency_cd)
            LOOP
                rec.nbt_currency_desc := j.currency_desc;
            END LOOP;
            
            IF i.chk_remarks IS NOT NULL THEN
                FOR j IN (SELECT c.currency_rt AS rate 
                        FROM GIPI_POLBASIC b, GIPI_INVOICE c
                       WHERE b.policy_id = c.policy_id
                         AND b.line_cd = i.line_cd
                         AND b.subline_cd = i.subline_cd
                         AND b.iss_cd = i.iss_cd
                         AND b.issue_yy = i.issue_yy
                         AND b.pol_seq_no = i.pol_seq_no
                         AND b.renew_no = i.renew_no) 
                LOOP
                    v_rate := j.rate;
                    EXIT;
                END LOOP;
                
                --get the differences
                v_gross_amt := i.gprem_amt_due/v_rate;
                v_comm_amt    := i.comm_amt_due/v_rate;
                v_whtax_amt    := i.whtax_amt_due/v_rate;
                v_invat_amt := i.invat_amt_due/v_rate;
                v_net_amt        := i.net_amt_due/v_rate;
                          
                rec.nbt_fgprem_diff := v_gross_amt - i.fgross_prem_amt;
                rec.nbt_fcomm_diff := v_comm_amt - i.fcomm_amt;
                rec.nbt_fwhtax_diff := v_whtax_amt -i.fwhtax_amt;
                rec.nbt_finput_vat_diff := v_invat_amt - i.finput_vat_amt;
                rec.nbt_fnet_due_diff := v_net_amt - i.fnet_amt_due;
            END IF;
            
            PIPE ROW(rec);
        END LOOP;
    END get_gupc_records;
    
    
    --= ======= start: DV Payment Details =========== 
    
    FUNCTION get_gudv_details(
        p_source_cd         giac_upload_dv_payt_dtl.SOURCE_CD%TYPE,
        p_file_no           giac_upload_dv_payt_dtl.FILE_NO%TYPE
    ) RETURN gudv_tab PIPELINED
    AS
        rec         gudv_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM giac_upload_dv_payt_dtl
                   WHERE source_cd = p_source_cd
                     AND file_no = p_file_no)
        LOOP
            rec.source_cd               := i.SOURCE_CD;
            rec.file_no                 := i.FILE_NO;
            rec.document_cd             := i.DOCUMENT_CD;
            rec.branch_cd               := i.BRANCH_CD;
            rec.line_cd                 := i.LINE_CD;
            rec.doc_year                := i.DOC_YEAR;
            rec.doc_mm                  := i.DOC_MM;
            rec.doc_seq_no              := i.DOC_SEQ_NO;
            rec.gouc_ouc_id             := i.GOUC_OUC_ID;
            rec.request_date            := i.REQUEST_DATE;
            rec.payee_class_cd          := i.PAYEE_CLASS_CD;
            rec.payee_cd                := i.PAYEE_CD;
            rec.payee                   := i.PAYEE;
            rec.particulars             := i.PARTICULARS;
            rec.currency_cd             := i.CURRENCY_CD;
            rec.currency_rt             := i.CURRENCY_RT;
            rec.dv_fcurrency_amt        := i.DV_FCURRENCY_AMT;
            rec.payt_amt                := i.PAYT_AMT;
            
            BEGIN    
                SELECT ouc_cd, ouc_name
                  INTO rec.nbt_ouc_cd, rec.nbt_ouc_name
                  FROM giac_oucs
                 WHERE ouc_id = i.gouc_ouc_id;
            EXCEPTION
                WHEN no_data_found THEN
                    rec.nbt_ouc_cd := null;
                    rec.nbt_ouc_name := null;
            END; 
            
            BEGIN    
                SELECT short_name
                  INTO rec.nbt_fshort_name
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN no_data_found THEN
                    rec.nbt_fshort_name := null;
            END;            
            
            rec.nbt_short_name  := giacp.v('DEFAULT_CURRENCY');
        
            PIPE ROW(rec);
        END LOOP;
    END get_gudv_details;
    
    
    FUNCTION get_document_lov (
        p_fund_cd        GIAC_PAYT_REQ_DOCS.GIBR_GFUN_FUND_CD%TYPE,
        p_branch_cd      GIAC_PAYT_REQ_DOCS.GIBR_BRANCH_CD%TYPE,
        p_keyword       VARCHAR2
    ) RETURN document_lov_tab PIPELINED
    AS
        rec     document_lov_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM giac_payt_req_docs  
                   WHERE gibr_gfun_fund_cd = p_fund_cd 
                     AND gibr_branch_cd = p_branch_cd 
                     AND (UPPER(document_cd) LIKE NVL(UPPER(p_keyword), '%')
                          OR UPPER(document_name) LIKE NVL(UPPER(p_keyword), '%'))
                     AND document_cd NOT IN (SELECT param_value_v 
                                               FROM giac_parameters 
                                               WHERE param_name IN ('CLM_PAYT_REQ_DOC', 'FACUL_RI_PREM_PAYT_DOC', 'COMM_PAYT_DOC','BATCH_CSR_DOC'))
                   ORDER BY document_cd)
        LOOP
            rec.fund_cd         := i.gibr_gfun_fund_cd;
            rec.branch_cd       := i.gibr_branch_cd;
            rec.document_cd     := i.document_cd;
            rec.document_name   := i.document_name;
            rec.line_cd_tag     := i.line_cd_tag;
            rec.yy_tag          := i.yy_tag;
            rec.mm_tag          := i.mm_tag;
            
            PIPE ROW(rec);
        END LOOP;
    END get_document_lov;
    
    
    FUNCTION get_dv_branch_lov(
        p_user_id       VARCHAR2,
        p_keyword       VARCHAR2,
        p_fund_cd       VARCHAR2,
        p_doc_cd        VARCHAR2,
        p_ouc_id        VARCHAR2
    ) RETURN branch_lov_tab PIPELINED
    AS
        rec             branch_lov_type;
    BEGIN
        FOR i IN (SELECT branch_cd, branch_name
                    FROM giac_branches
                   WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,
                                                                         branch_cd,
                                                                         'GIACS016',
                                                                         p_user_id
                                                                        ),
                                             1, branch_cd, NULL)
                      AND (UPPER(branch_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(branch_name) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY branch_cd)
        LOOP
            rec.branch_cd   := i.branch_cd;
            rec.branch_name := i.branch_name;
            
            rec.doc_cd_exists := 'N';
            
            FOR j IN (SELECT 'x'
                          FROM giac_payt_req_docs gprd 
                         WHERE gprd.gibr_gfun_fund_cd = p_fund_cd 
                           AND gprd.gibr_branch_cd = i.branch_cd 
                           AND gprd.document_cd = p_doc_cd 
                           AND gprd.document_cd NOT IN (SELECT param_value_v 
                                                          FROM giac_parameters 
                                                         WHERE param_name IN ('CLM_PAYT_REQ_DOC', 'FACUL_RI_PREM_PAYT_DOC', 'COMM_PAYT_DOC','BATCH_CSR_DOC')))
            LOOP
                rec.doc_cd_exists := 'Y';
                EXIT;
            END LOOP;
            
            rec.ouc_id_exists := 'N';
            
            FOR j IN (SELECT 'x'
                          FROM giac_oucs gouc 
                         WHERE gouc.gibr_gfun_fund_cd = p_fund_cd 
                           AND gouc.gibr_branch_cd = i.branch_cd
                           AND gouc.ouc_id = p_ouc_id)
            LOOP
                rec.ouc_id_exists := 'Y';
                EXIT;
            END LOOP;    
            
            PIPE ROW(rec);
        END LOOP;
    END get_dv_branch_lov;
    
    
    FUNCTION get_line_lov(
        p_keyword       VARCHAR2
    ) RETURN line_lov_tab PIPELINED
    AS
        rec     line_lov_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM giis_line
                   WHERE (UPPER(line_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(line_name) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY line_cd)
        LOOP
            rec.line_cd   := i.line_cd;
            rec.line_name := i.line_name;
            
            PIPE ROW(rec);
        END LOOP;
    END get_line_lov;
    
     FUNCTION get_ouc_lov(
        p_fund_cd       VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_keyword       VARCHAR2
    ) RETURN ouc_lov_tab PIPELINED
    AS
        rec     ouc_lov_type;
    BEGIN
        FOR i IN (SELECT ouc_cd, ouc_id, ouc_name 
                    FROM giac_oucs 
                   WHERE gibr_gfun_fund_cd = p_fund_cd 
                     AND gibr_branch_cd = p_branch_cd
                     AND (UPPER(ouc_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(ouc_name) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY ouc_cd)
        LOOP
            rec.ouc_cd   := i.ouc_cd;
            rec.ouc_id   := i.ouc_id;
            rec.ouc_name := i.ouc_name;
            
            PIPE ROW(rec);
        END LOOP;
    END get_ouc_lov;
    
    
    FUNCTION get_payee_class_lov(
        p_keyword   VARCHAR2
    ) RETURN payee_class_lov_tab PIPELINED
    AS
        rec     payee_class_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.payee_class_cd, b.class_desc 
                    FROM giis_payees a, 
                         giis_payee_class b
                   WHERE a.payee_class_cd = b.payee_class_cd 
                     AND (UPPER(a.payee_class_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(b.class_desc) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY a.payee_class_cd)
        LOOP
            rec.payee_class_cd  := i.payee_class_cd;
            rec.class_desc      := i.class_desc;
            
            PIPE ROW(rec);
        END LOOP;
    END get_payee_class_lov;
    
    
    FUNCTION get_payee_lov(
        p_payee_class_cd        GIIS_PAYEES.PAYEE_CLASS_CD%TYPE,
        p_keyword               VARCHAR2
    ) RETURN payee_lov_tab PIPELINED
    AS
        rec     payee_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.payee_no, a.payee_last_name, a.payee_first_name, a.payee_middle_name  
                    FROM giis_payees a, 
                         giis_payee_class b
                   WHERE a.payee_class_cd = b.payee_class_cd
                     AND a.PAYEE_CLASS_CD = p_payee_class_cd 
                     AND (UPPER(a.payee_no) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(payee_last_name) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(payee_first_name) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(payee_middle_name) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY a.payee_class_cd)
        LOOP
            rec.payee_no            := i.payee_no;
            rec.payee_first_name    := i.payee_first_name;
            rec.payee_middle_name   := i.payee_middle_name;
            rec.payee_last_name     := i.payee_last_name;
            
            rec.nbt_derive_payee    := NULL;
            
            BEGIN
                SELECT TRIM(DECODE(i.payee_first_name, NULL, i.payee_last_name,
                                RTRIM(i.payee_first_name)||' '||RTRIM(i.payee_middle_name) ||' ' || RTRIM(i.payee_last_name)))
                  INTO rec.nbt_derive_payee              
                  FROM sys.dual;   
            END;
            
            PIPE ROW(rec);
        END LOOP;
    END get_payee_lov;
    
    
    FUNCTION get_currency_lov(
        p_keyword       VARCHAR2
    )RETURN currency_lov_tab PIPELINED
    AS
        rec     currency_lov_type;
    BEGIN
        FOR i IN (SELECT short_name, currency_desc, main_currency_cd, currency_rt
                    FROM giis_currency
                   WHERE (UPPER(main_currency_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(short_name) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(currency_desc) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY main_currency_cd)
        LOOP
            rec.short_name          := i.short_name;
            rec.currency_desc       := i.currency_desc;
            rec.main_currency_cd    := i.main_currency_cd;
            rec.currency_rt         := i.currency_rt;
            
            PIPE ROW(rec);
        END LOOP;
    END get_currency_lov;
    
    
    PROCEDURE del_gudv(
        p_source_cd     IN  giac_upload_dv_payt_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_dv_payt_dtl.FILE_NO%TYPE
    )
    AS
    BEGIN
        DELETE FROM giac_upload_dv_payt_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
    END del_gudv;
    
    PROCEDURE set_gudv(
        p_rec       giac_upload_dv_payt_dtl%ROWTYPE
    )
    AS
    BEGIN
        MERGE INTO giac_upload_dv_payt_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd
             AND file_no = p_rec.file_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, document_cd, branch_cd, line_cd, doc_year, doc_mm, doc_seq_no, 
                    gouc_ouc_id, request_date, payee_class_cd, payee_cd, payee, particulars, 
                    dv_fcurrency_amt, currency_rt, payt_amt, currency_cd)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.document_cd, p_rec.branch_cd, p_rec.line_cd, p_rec.doc_year, p_rec.doc_mm, p_rec.doc_seq_no, 
                    p_rec.gouc_ouc_id, p_rec.request_date, p_rec.payee_class_cd, p_rec.payee_cd, p_rec.payee, p_rec.particulars, 
                    p_rec.dv_fcurrency_amt, p_rec.currency_rt, p_rec.payt_amt, p_rec.currency_cd)
         WHEN MATCHED THEN
            UPDATE
               SET payee_class_cd   = p_rec.payee_class_cd,
                   payee_cd         = p_rec.payee_cd,
                   payee            = p_rec.payee,
                   particulars      = p_rec.particulars,
                   dv_fcurrency_amt = p_rec.dv_fcurrency_amt,
                   currency_rt      = p_rec.currency_rt,
                   payt_amt         = p_rec.payt_amt,
                   currency_cd      = p_rec.currency_cd;
    END set_gudv;
    
    --= ======= end: DV Payment Details =========== 
    
    --= ======= start: JV Payment Details =========== 
    
    FUNCTION get_gujv_details(
        p_source_cd         GIAC_UPLOAD_JV_PAYT_DTL.SOURCE_CD%type,
        p_file_no           GIAC_UPLOAD_JV_PAYT_DTL.FILE_NO%type
    ) RETURN gujv_tab PIPELINED
    AS
        rec         gujv_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_UPLOAD_JV_PAYT_DTL
                   WHERE source_cd = p_source_cd
                     AND file_no = p_file_no)
        LOOP
            rec.source_cd           := i.SOURCE_CD;
            rec.file_no             := i.FILE_NO;
            rec.branch_cd           := i.BRANCH_CD;
            rec.tran_year           := i.TRAN_YEAR;
            rec.tran_month          := i.TRAN_MONTH;
            rec.tran_seq_no         := i.TRAN_SEQ_NO;
            rec.tran_date           := i.TRAN_DATE;
            rec.jv_pref_suff        := i.JV_PREF_SUFF;
            rec.jv_no               := i.JV_NO;
            rec.particulars         := i.PARTICULARS;
            rec.jv_tran_tag         := i.JV_TRAN_TAG;
            rec.jv_tran_type        := i.JV_TRAN_TYPE;
            rec.jv_tran_mm          := i.JV_TRAN_MM;
            rec.jv_tran_yy          := i.JV_TRAN_YY;
            
            rec.nbt_branch_name     := null;
            rec.nbt_jv_tran_desc    := null;
            
            BEGIN
                SELECT branch_name
                  INTO rec.nbt_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = giacp.v('FUND_CD')
                   AND branch_cd = i.branch_cd; 
            EXCEPTION
                WHEN no_data_found THEN
                    rec.nbt_branch_name := NULL;
            END;  
            
            FOR c IN (SELECT jv_tran_cd, jv_tran_desc
                        FROM giac_jv_trans
                       WHERE jv_tran_cd = i.jv_tran_type) 
            LOOP
                rec.nbt_jv_tran_desc := c.jv_tran_desc;
                EXIT;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_gujv_details;
    
    
    FUNCTION get_jv_branch_lov(
        p_user_id       VARCHAR2,
        p_keyword       VARCHAR2
    ) RETURN branch_lov_tab PIPELINED
    AS
        rec             branch_lov_type;
    BEGIN
        FOR i IN (SELECT branch_cd, branch_name
                    FROM giac_branches
                   WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,
                                                                         branch_cd,
                                                                         'GIACS003',
                                                                         p_user_id
                                                                        ),
                                             1, branch_cd, NULL)
                      AND (UPPER(branch_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(branch_name) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY branch_cd)
        LOOP
            rec.branch_cd   := i.branch_cd;
            rec.branch_name := i.branch_name;
            
            PIPE ROW(rec);
        END LOOP;
    END get_jv_branch_lov;
    
    
    FUNCTION get_jv_tran_type_lov(
        p_jv_tran_tag       GIAC_JV_TRANS.JV_TRAN_TAG%type,
        p_keyword           VARCHAR2,
        p_row_num           NUMBER
    ) RETURN jv_tran_type_tab PIPELINED
    AS
        rec     jv_tran_type_type;
    BEGIN
        FOR i IN (SELECT jv_tran_cd, jv_tran_desc
                    FROM GIAC_JV_TRANS
                   WHERE jv_tran_tag = p_jv_tran_tag
                     AND (UPPER(jv_tran_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(jv_tran_desc) LIKE NVL(UPPER(p_keyword), '%'))
                     AND rownum <= DECODE(p_row_num, null, rownum, p_row_num))
        LOOP
            rec.jv_tran_type    := i.jv_tran_cd;
            rec.jv_tran_desc    := i.jv_tran_desc;    
        
            PIPE ROW(rec);
        END LOOP;
    END get_jv_tran_type_lov;
    
    PROCEDURE del_gujv(
        p_source_cd     IN  giac_upload_jv_payt_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_jv_payt_dtl.FILE_NO%TYPE
    )
    AS
    BEGIN
        DELETE FROM giac_upload_jv_payt_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
    END del_gujv;
    
    PROCEDURE set_gujv(
        p_rec       giac_upload_jv_payt_dtl%ROWTYPE
    )
    AS
    BEGIN
        MERGE INTO giac_upload_jv_payt_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd
             AND file_no = p_rec.file_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, branch_cd, tran_year, tran_month, tran_seq_no, tran_date, 
                    jv_pref_suff, jv_no, particulars, jv_tran_tag, jv_tran_type, jv_tran_mm, jv_tran_yy)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.branch_cd, p_rec.tran_year, p_rec.tran_month, p_rec.tran_seq_no, p_rec.tran_date, 
                    p_rec.jv_pref_suff, p_rec.jv_no, p_rec.particulars, p_rec.jv_tran_tag, p_rec.jv_tran_type, p_rec.jv_tran_mm, p_rec.jv_tran_yy)
         WHEN MATCHED THEN
            UPDATE
               SET branch_cd        = p_rec.branch_cd,
                   tran_year        = p_rec.tran_year,
                   tran_month       = p_rec.tran_month,
                   tran_seq_no      = p_rec.tran_seq_no,
                   tran_date        = p_rec.tran_date,
                   jv_pref_suff     = p_rec.jv_pref_suff,
                   jv_no            = p_rec.jv_no,
                   particulars      = p_rec.particulars,
                   jv_tran_tag      = p_rec.jv_tran_tag,
                   jv_tran_type     = p_rec.jv_tran_type,
                   jv_tran_mm       = p_rec.jv_tran_mm,
                   jv_tran_yy       = p_rec.jv_tran_yy;
    END set_gujv;
    
    --= ======= end: JV Payment Details =========== 
    
     --= ======= start: Collection Details =========== 
    FUNCTION get_gucd_records(
        p_source_cd             GIAC_UPLOAD_COLLN_DTL.SOURCE_CD%type,
        p_file_no               GIAC_UPLOAD_COLLN_DTL.FILE_NO%type,
        p_item_no               GIAC_UPLOAD_COLLN_DTL.ITEM_NO%type,
        p_pay_mode              GIAC_UPLOAD_COLLN_DTL.PAY_MODE%type,
        p_check_class           GIAC_UPLOAD_COLLN_DTL.CHECK_CLASS%type,
        p_check_no              GIAC_UPLOAD_COLLN_DTL.CHECK_NO%type,
        p_check_date            VARCHAR2,
        p_amount                GIAC_UPLOAD_COLLN_DTL.AMOUNT%type,
        p_gross_amt             GIAC_UPLOAD_COLLN_DTL.GROSS_AMT%type,
        p_comm_amt              GIAC_UPLOAD_COLLN_DTL.COMMISSION_AMT%type,
        p_vat_amt               GIAC_UPLOAD_COLLN_DTL.VAT_AMT%type
    ) RETURN gucd_tab PIPELINED
    AS
        rec         gucd_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_UPLOAD_COLLN_DTL
                   WHERE source_cd = p_source_cd
                     AND file_no = p_file_no
                     AND item_no = NVL(p_item_no, item_no)
                     AND UPPER(pay_mode) LIKE UPPER(NVL(p_pay_mode, '%'))
                     AND UPPER(NVL(check_class, '*')) LIKE UPPER(NVL(p_check_class, '%'))
                     AND UPPER(NVL(check_no, '*')) LIKE UPPER(NVL(p_check_no, '%'))
                     AND TRUNC(NVL(check_date, SYSDATE)) = TRUNC(NVL(TO_DATE(p_check_date, 'MM-DD-RRRR'), NVL(check_date, SYSDATE)))
                     AND NVL(amount,0) = NVL(p_amount, NVL(amount,0))
                     AND NVL(gross_amt,0) = NVL(p_gross_amt, NVL(gross_amt,0))
                     AND NVL(commission_amt,0) = NVL(p_comm_amt, NVL(commission_amt,0))
                     AND NVL(vat_amt,0) = NVL(p_vat_amt, NVL(vat_amt,0))
                   ORDER BY item_no)
        LOOP
            rec.source_cd               := i.SOURCE_CD;
            rec.file_no                 := i.FILE_NO;
            rec.item_no                 := i.ITEM_NO;
            rec.pay_mode                := i.PAY_MODE;
            rec.bank_cd                 := i.BANK_CD;
            rec.check_class             := i.CHECK_CLASS;
            rec.check_no                := i.CHECK_NO;
            rec.check_date              := i.CHECK_DATE;
            rec.amount                  := i.AMOUNT;
            rec.currency_cd             := i.CURRENCY_CD;
            rec.currency_rt             := i.CURRENCY_RT;
            rec.dcb_bank_cd             := i.DCB_BANK_CD;
            rec.dcb_bank_acct_cd        := i.DCB_BANK_ACCT_CD;
            rec.particulars             := i.PARTICULARS;
            rec.gross_amt               := i.GROSS_AMT;
            rec.commission_amt          := i.COMMISSION_AMT;
            rec.vat_amt                 := i.VAT_AMT;
            rec.fc_gross_amt            := i.FC_GROSS_AMT;
            rec.fc_comm_amt             := i.FC_COMM_AMT;
            rec.fc_vat_amt              := i.FC_VAT_AMT;
            rec.nbt_fc_net_amt          := nvl(i.fc_gross_amt,0) - nvl(i.fc_comm_amt,0) - nvl(i.fc_vat_amt,0);
            
            BEGIN
                SELECT bank_sname
                  INTO rec.nbt_bank_sname
                  FROM giac_banks
                 WHERE bank_cd = i.bank_cd;
            EXCEPTION
                WHEN no_data_found THEN 
                    rec.nbt_bank_sname := NULL;
            END;
            
            BEGIN
                SELECT short_name
                  INTO rec.nbt_short_name
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN no_data_found THEN 
                    rec.nbt_short_name := NULL;
            END;
            
            rec.nbt_dcb_bank_name := NULL;
            
            FOR c IN (SELECT bank_name
                        FROM giac_banks
                       WHERE bank_cd = i.dcb_bank_cd) 
            LOOP
                rec.nbt_dcb_bank_name := c.bank_name;
                EXIT;
            END LOOP;
            
            rec.nbt_dcb_bank_acct_no := NULL;
            
            FOR d IN (SELECT bank_acct_no
                        FROM giac_bank_accounts
                       WHERE bank_cd = i.dcb_bank_cd
                         AND bank_acct_cd = i.dcb_bank_acct_cd) 
            LOOP
                rec.nbt_dcb_bank_acct_no := d.bank_acct_no;
                EXIT;
            END LOOP;
    
            PIPE ROW(rec);
        END LOOP;
    END get_gucd_records;
    
    FUNCTION get_bank_lov(
        p_keyword       VARCHAR2
    )RETURN bank_lov_tab PIPELINED
    AS
        rec     bank_lov_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM giac_banks
                   WHERE (UPPER(bank_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(bank_name) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(bank_sname) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY bank_sname)
        LOOP
            rec.bank_name   := i.bank_name;
            rec.bank_sname  := i.bank_sname;
            rec.bank_cd     := i.bank_cd;
            
            PIPE ROW(rec);
        END LOOP;
    END get_bank_lov;
    
    
    FUNCTION get_dcb_bank_lov(
        p_keyword       VARCHAR2
    )RETURN bank_lov_tab PIPELINED
    AS
        rec     bank_lov_type;
    BEGIN
        FOR i IN (SELECT DISTINCT gbac.bank_cd, gban.bank_name 
                    FROM giac_bank_accounts gbac, 
                         giac_banks gban 
                   WHERE gbac.bank_cd = gban.bank_cd 
                     AND gbac.bank_account_flag = 'A' 
                     AND gbac.opening_date < SYSDATE 
                     AND NVL(gbac.closing_date,SYSDATE+1) > SYSDATE
                     AND (UPPER(gbac.bank_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(gban.bank_name) LIKE NVL(UPPER(p_keyword), '%'))
                   ORDER BY gban.bank_name)
        LOOP
            rec.bank_name   := i.bank_name;
            rec.bank_cd     := i.bank_cd;
            
            PIPE ROW(rec);
        END LOOP;
    END get_dcb_bank_lov;
    
    
    FUNCTION get_dcb_bank_acct_lov(
        p_dcb_bank_cd   giac_bank_accounts.BANK_CD%type,
        p_keyword       VARCHAR2
    ) RETURN dcb_bank_acct_lov_tab PIPELINED
    AS
        rec     dcb_bank_acct_lov_type;
    BEGIN
        FOR i IN (SELECT bank_acct_cd, bank_acct_no, bank_acct_type, branch_cd 
                    FROM giac_bank_accounts 
                   WHERE bank_account_flag = 'A' 
                     AND bank_cd = p_dcb_bank_cd 
                     AND opening_date < SYSDATE 
                     AND NVL(closing_date,SYSDATE + 1) > SYSDATE
                     AND (UPPER(bank_acct_cd) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(bank_acct_no) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(bank_acct_type) LIKE NVL(UPPER(p_keyword), '%')
                            OR UPPER(branch_cd) LIKE NVL(UPPER(p_keyword), '%')))
        LOOP 
            rec.bank_acct_cd    := i.bank_acct_cd;
            rec.bank_acct_no    := i.bank_acct_no;
            rec.bank_acct_type  := i.bank_acct_type;
            rec.branch_cd       := i.branch_cd;    
        
            PIPE ROW(rec);
        END LOOP;
    END get_dcb_bank_acct_lov;
    
    
    PROCEDURE del_gucd(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE,
        p_item_no       IN  giac_upload_colln_dtl.ITEM_NO%type
    )
    AS
    BEGIN
        DELETE FROM giac_upload_colln_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no
           AND item_no = p_item_no;
    END del_gucd;
    
    PROCEDURE set_gucd(
        p_rec       giac_upload_colln_dtl%ROWTYPE
    )
    AS
    BEGIN
        MERGE INTO giac_upload_colln_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd
             AND file_no = p_rec.file_no
             AND item_no = p_rec.item_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, item_no, pay_mode, amount, gross_amt, commission_amt, vat_amt,
                    check_class, check_date, check_no, particulars, bank_cd, currency_cd, currency_rt, 
                    dcb_bank_cd, dcb_bank_acct_cd, fc_comm_amt, fc_vat_amt, fc_gross_amt)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.item_no, p_rec.pay_mode, p_rec.amount, p_rec.gross_amt, p_rec.commission_amt, p_rec.vat_amt,
                    p_rec.check_class, p_rec.check_date, p_rec.check_no, p_rec.particulars, p_rec.bank_cd, p_rec.currency_cd, p_rec.currency_rt, 
                    p_rec.dcb_bank_cd, p_rec.dcb_bank_acct_cd, p_rec.fc_comm_amt, p_rec.fc_vat_amt, p_rec.fc_gross_amt)
         WHEN MATCHED THEN
            UPDATE
               SET pay_mode         = p_rec.pay_mode,
                   amount           = p_rec.amount,
                   gross_amt        = p_rec.gross_amt,
                   commission_amt   = p_rec.commission_amt,
                   vat_amt          = p_rec.vat_amt,
                   check_class      = p_rec.check_class,
                   check_date       = p_rec.check_date,
                   check_no         = p_rec.check_no,
                   particulars      = p_rec.particulars,
                   bank_cd          = p_rec.bank_cd,
                   currency_cd      = p_rec.currency_cd,
                   currency_rt      = p_rec.currency_rt,
                   dcb_bank_cd      = p_rec.dcb_bank_cd,
                   dcb_bank_acct_cd = p_rec.dcb_bank_acct_cd,
                   fc_comm_amt      = p_rec.fc_comm_amt,
                   fc_vat_amt       = p_rec.fc_vat_amt,
                   fc_gross_amt     = p_rec.fc_gross_amt;
    END set_gucd;
    
    
    PROCEDURE check_net_colln(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE
    )
    AS
        v_gross_prem_amt     NUMBER;
        v_net_comm_amt        NUMBER;
        v_net_amt_due       NUMBER;
        
        v_tot_amount        NUMBER;
        v_tot_gross_amt     NUMBER;
        v_tot_comm_amt      NUMBER;
        v_tot_vat_amt       NUMBER;
    BEGIN
        SELECT NVL(SUM(gross_prem_amt),0), NVL(SUM(comm_amt-whtax_amt+input_vat_amt),0),  NVL(SUM(net_amt_due),0) 
          INTO v_gross_prem_amt, v_net_comm_amt, v_net_amt_due
          FROM giac_upload_prem_comm
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        SELECT NVL(SUM(amount),0), NVL(SUM(gross_amt),0), NVL(SUM(commission_amt),0), NVL(SUM(vat_amt),0)
          INTO v_tot_amount, v_tot_gross_amt, v_tot_comm_amt, v_tot_vat_amt
          FROM TABLE(GIACS607_PKG.GET_GUCD_RECORDS(p_source_cd, p_file_no, null, null, null, null, null, null, null, null, null));
          
        IF v_tot_amount <> 0 THEN
            IF v_net_amt_due <> v_tot_amount THEN
                raise_application_error (-20001, 'Geniisys Exception#I#Total Local Currency Amount should be equal to the total Net Amount Due.');
            ELSIF v_gross_prem_amt <> v_tot_gross_amt THEN
                raise_application_error (-20001, 'Geniisys Exception#I#Total Gross Amount should be equal to the total Gross Premium.');    
            ELSIF v_net_comm_amt <> v_tot_comm_amt + v_tot_vat_amt THEN
                raise_application_error (-20001, 'Geniisys Exception#I#Total Commission Amount + total VAT Amount should be equal to the total Net Commission Amount.');
            END IF;    
        END IF;       
    END check_net_colln;
    
    --= ======= end: Collection Details =========== 
    
    PROCEDURE validate_before_upload(
        p_user_id       VARCHAR2,
        p_source_cd     giac_upload_file.SOURCE_CD%TYPE,
        p_file_no       giac_upload_file.FILE_NO%TYPE,
        p_tran_class    giac_upload_file.TRAN_CLASS%TYPE
    )
    AS
        v_fund_cd                giac_acct_entries.gacc_gfun_fund_cd%TYPE;
        v_fund_desc              giis_funds.fund_desc%TYPE;
        v_branch_cd              giis_user_grp_hdr.grp_iss_cd%type;
        v_branch_name            giac_branches.branch_name%type;
        v_evat_cd                NUMBER;
        v_tax_allocation         giac_parameters.param_value_v%TYPE;
        v_mgmt_comp              VARCHAR2(1);
        v_comp_exp_gen           giac_parameters.param_value_v%TYPE;
        v_comm_payable_take_up   giac_parameters.param_value_v%TYPE;
        v_prem_payt_for_sp       giac_parameters.param_value_v%TYPE;
        v_stale_check            giac_parameters.param_value_v%TYPE;
        v_stale_days             giac_parameters.param_value_v%TYPE;
        v_stale_mgr_chk          giac_parameters.param_value_v%TYPE;        
        v_sl_type_cd1            giac_parameters.param_name%TYPE;
        v_sl_type_cd2            giac_parameters.param_name%TYPE;
        v_sl_type_cd3            giac_parameters.param_name%TYPE;
        v_dflt_dcb_bank_cd       giac_dcb_users.BANK_CD%TYPE;
        v_dflt_dcb_bank_name     giac_banks.BANK_NAME%TYPE;
        v_dflt_dcb_bank_acct_cd  giac_dcb_users.BANK_ACCT_CD%TYPE;
        v_dflt_dcb_bank_acct_no  giac_bank_accounts.BANK_ACCT_NO%TYPE;   
        v_jv_tran_type           giac_jv_trans.JV_TRAN_CD%type;
        v_jv_tran_desc           giac_jv_trans.JV_TRAN_DESC%type;  
        v_dflt_currency_cd       giac_parameters.param_value_v%type;
        v_dflt_currency_sname    giis_currency.short_name%type;
        v_dflt_currency_rt       giis_currency.currency_rt%type;
        
        v_tot_net_amt_due       NUMBER(20,2);
        
        v_exists                NUMBER;
    BEGIN
        GIACS607_PKG.GET_PARAMETERS(p_user_id, v_fund_cd, v_fund_desc, v_branch_cd, v_branch_name, v_evat_cd, v_tax_allocation, v_mgmt_comp,
                                    v_comp_exp_gen, v_comm_payable_take_up, v_prem_payt_for_sp, v_stale_check, v_stale_days, v_stale_mgr_chk,
                                    v_sl_type_cd1, v_sl_type_cd2, v_sl_type_cd3, v_dflt_dcb_bank_cd, v_dflt_dcb_bank_name, v_dflt_dcb_bank_acct_cd,
                                    v_dflt_dcb_bank_acct_no, v_jv_tran_type, v_jv_tran_desc, v_dflt_currency_cd, v_dflt_currency_sname, v_dflt_currency_rt);
        
        IF v_fund_cd IS NULL THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Parameter FUND_CD is not defined in table GIAC_PARAMETERS.');
            END IF;
        
        IF v_branch_cd IS NULL THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Branch code of user was not found.');
        END IF;
        
        IF v_evat_cd IS NULL THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Parameter EVAT is not defined in table GIAC_PARAMETERS.');
        END IF;
        
        IF v_tax_allocation = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#This module was designed to upload data only if the parameter: TAX_ALLOCATION = Y.');
        END IF;
        
        -- nieko Accounting Uploading
        IF p_tran_class = 'COL' THEN
            SELECT COUNT(*)
              INTO v_exists
              FROM giac_upload_colln_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;
                   
             IF v_exists = 0 THEN
                raise_application_error(-20001, 'Geniisys Exception#I#No saved Collection Payment Details yet.');
             END IF;
        ELSIF  p_tran_class = 'DV' THEN
            SELECT COUNT(*)
              INTO v_exists
              FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;    
             
             IF v_exists = 0 THEN
                raise_application_error(-20001, 'Geniisys Exception#I#No saved DV Payment Details yet.');
             END IF;  
        ELSIF  p_tran_class = 'JV' THEN     
            SELECT COUNT(*)
              INTO v_exists
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;    
             
             IF v_exists = 0 THEN
                raise_application_error(-20001, 'Geniisys Exception#I#No saved JV Payment Details yet.');
             END IF;
        END IF;
        --nieko end 
        
        FOR guf IN (SELECT *
                    FROM giac_upload_file
                   WHERE source_cd = p_source_cd
                     AND file_no = p_file_no)
        LOOP
            IF guf.tran_class IS NOT NULL THEN
                raise_application_error(-20001, 'Geniisys Exception#E#This file has already been uploaded.');
            END IF;
            
            IF guf.file_status = 'C' THEN
                raise_application_error(-20001, 'Geniisys Exception#E#This is a cancelled file.');
            END IF;
        END LOOP;
                
        SELECT SUM(net_amt_due)
          INTO v_tot_net_amt_due
          FROM GIAC_UPLOAD_PREM_COMM 
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        IF v_tot_net_amt_due < 0 THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Total Net Amount Due must be greater than zero.');
        END IF;
        
        IF v_mgmt_comp = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#User is not allowed to process commission payments for policies that are not yet fully paid.');
        END IF;
        
        IF v_comp_exp_gen = 'Y' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#This module was designed to upload data only if the parameter: COMM_EXP_GEN <> Y.');
        END IF;
        
        IF v_comm_payable_take_up NOT IN (1, 2) THEN
            raise_application_error(-20001, 'Geniisys Exception#E#This module was designed to upload data only if the parameter: COMM_PAYABLE_TAKE_UP = 1 or 2.');
        END IF;
        
    END validate_before_upload;  
    
    
    FUNCTION chk_modified_comm (
        p_iss_cd        gipi_invoice.iss_cd%TYPE, 
        p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE
    ) RETURN BOOLEAN
    AS
        v_comm_refund    NUMBER := 0;
        v_modified        BOOLEAN := FALSE;
    BEGIN
        FOR rec IN (SELECT a.iss_cd, a.prem_seq_no, a.intm_no, sum(comm_amt) comm_amt
                      FROM giac_comm_payts a,
                           giac_acctrans   b    
                     WHERE 1=1
                     AND a.iss_cd       = p_iss_cd       
                     AND a.prem_seq_no  = p_prem_seq_no     
                     AND a.gacc_tran_id = b.tran_id
                     AND b.tran_flag   != 'D' 
                     AND a.intm_no > 0
                     AND a.gacc_tran_id > 0
                     AND a.tran_type IN (1,3)
                     AND NOT EXISTS (SELECT x.gacc_tran_id
                                       FROM giac_reversals x,
                                            giac_acctrans y
                                      WHERE x.reversing_tran_id = y.tran_id
                                        AND y.tran_flag <> 'D'
                                        AND x.gacc_tran_id = a.gacc_tran_id)
                     AND NOT EXISTS (SELECT 'x'
                                       FROM gipi_comm_invoice c
                                      WHERE c.iss_cd = a.iss_cd
                                        AND c.prem_seq_no = a.prem_seq_no
                                        AND c.intrmdry_intm_no = a.intm_no)
                     GROUP BY a.iss_cd, a.prem_seq_no, a.intm_no)
        LOOP
            FOR refund_rec IN (SELECT a.iss_cd, a.prem_seq_no, a.intm_no, sum(comm_amt) comm_amt
                                 FROM giac_comm_payts a,
                                      giac_acctrans   b    
                                WHERE a.iss_cd       = rec.iss_cd
                                  AND a.prem_seq_no  = rec.prem_seq_no     
                                  AND a.intm_no      = rec.intm_no       
                                  AND a.gacc_tran_id = b.tran_id
                                  AND b.tran_flag   != 'D' 
                                  AND a.intm_no > 0
                                  AND a.gacc_tran_id > 0
                                  AND a.tran_type IN (2,4)
                                  AND NOT EXISTS (SELECT x.gacc_tran_id
                                                    FROM giac_reversals x,
                                                         giac_acctrans y
                                                   WHERE x.reversing_tran_id = y.tran_id
                                                     AND y.tran_flag <> 'D'
                                                     AND x.gacc_tran_id = a.gacc_tran_id)
                                GROUP BY a.iss_cd, a.prem_seq_no, a.intm_no)
            LOOP
              v_comm_refund := refund_rec.comm_amt;
            END LOOP;
             
            IF rec.comm_amt + v_comm_refund <> 0 THEN        
                v_modified := TRUE;
                EXIT;
            END IF;
        END LOOP;
        
        RETURN(v_modified);
    END chk_modified_comm;
    
        
    PROCEDURE with_tax_allocation(
        p_get_prem_pd_tag       IN  VARCHAR2,     
        p_user_id               IN  VARCHAR2
    )AS
        vl_lt            NUMBER;
        v_prem           giac_direct_prem_collns.premium_amt%TYPE;
        v_name           VARCHAR2 (50) := 'PREM_TAX_PRIORITY';
        v_the_priority   VARCHAR2 (1);
    BEGIN
        v_prem := 0;
        /* Determine which is the priority between premium and tax amount
        ** in which the collection will be allocated.
        */
        v_the_priority := giacp.v(v_name);
        IF v_the_priority IS NULL THEN
            raise_application_error (-20001, 'Geniisys Exception#E#There is no existing '|| v_name|| ' parameter in GIAC_PARAMETERS table.');
        END IF;
        
        /* Recompute premium amount and tax amount based on the collection amount entered */
        IF v_the_priority = 'P' THEN
            /*
            ** Premium amount has higher priority than tax amount
            */
            IF nvl(GIACS607_PKG.v_collection_amt, 0) = GIACS607_PKG.v_max_collection_amt THEN
                GIACS607_PKG.v_premium_amt := GIACS607_PKG.v_max_premium_amt;
                GIACS607_PKG.v_tax_amt     := GIACS607_PKG.v_max_tax_amt;
            ELSIF abs(nvl(GIACS607_PKG.v_collection_amt, 0)) <= abs(nvl(GIACS607_PKG.v_max_premium_amt, 0)) THEN
                GIACS607_PKG.v_premium_amt := GIACS607_PKG.v_collection_amt;
                GIACS607_PKG.v_tax_amt     := 0;
            ELSE
                GIACS607_PKG.v_premium_amt := GIACS607_PKG.v_max_premium_amt;
                GIACS607_PKG.v_tax_amt     := nvl(GIACS607_PKG.v_collection_amt,0) - nvl(GIACS607_PKG.v_max_premium_amt,0);
            END IF;
        ELSE
            /*
            ** Tax amount has higher priority than premium amount
            */
            IF nvl(GIACS607_PKG.v_collection_amt, 0) = GIACS607_PKG.v_max_collection_amt THEN
                    GIACS607_PKG.v_premium_amt := GIACS607_PKG.v_max_premium_amt;
                    GIACS607_PKG.v_tax_amt     := GIACS607_PKG.v_max_tax_amt;
                ELSIF abs(nvl(GIACS607_PKG.v_collection_amt, 0)) <= abs(GIACS607_PKG.v_max_tax_amt) THEN
                    GIACS607_PKG.v_premium_amt := 0;
                    GIACS607_PKG.v_tax_amt     := GIACS607_PKG.v_collection_amt;
                ELSE
                    GIACS607_PKG.v_premium_amt := nvl(GIACS607_PKG.v_collection_amt, 0) - nvl(GIACS607_PKG.v_max_tax_amt, 0);
                    GIACS607_PKG.v_tax_amt     := GIACS607_PKG.v_max_tax_amt;
            END IF;
        END IF;
         
        GIACS607_PKG.v_foreign_curr_amt := nvl(GIACS607_PKG.v_collection_amt,0) / GIACS607_PKG.v_convert_rate;

        -- Call procedure for the tax breakdown --
        IF GIACS607_PKG.v_tax_amt = 0 THEN
            GIACS607_PKG.v_premium_amt := GIACS607_PKG.v_collection_amt;
            GIACS607_PKG.v_tax_amt     := 0;
        ELSE 
            IF p_get_prem_pd_tag = 'N' THEN
                IF GIACS607_PKG.v_transaction_type = 1 THEN
                    upload_dpc_web.tax_alloc_type1( GIACS607_PKG.v_tran_id,
                                                GIACS607_PKG.v_transaction_type,
                                                GIACS607_PKG.v_iss_cd,
                                                GIACS607_PKG.v_prem_seq_no,
                                                GIACS607_PKG.v_inst_no,
                                                GIACS607_PKG.v_collection_amt,
                                                GIACS607_PKG.v_premium_amt,
                                                GIACS607_PKG.v_tax_amt,
                                                GIACS607_PKG.v_max_premium_amt,
                                                p_user_id,
                                                SYSDATE
                                        );
                ELSIF GIACS607_PKG.v_transaction_type = 3 THEN 
                    upload_dpc_web.tax_alloc_type3( GIACS607_PKG.v_tran_id,
                                                GIACS607_PKG.v_transaction_type,
                                                GIACS607_PKG.v_iss_cd,
                                                GIACS607_PKG.v_prem_seq_no,
                                                GIACS607_PKG.v_inst_no,
                                                GIACS607_PKG.v_collection_amt,
                                                GIACS607_PKG.v_premium_amt,
                                                GIACS607_PKG.v_tax_amt,
                                                GIACS607_PKG.v_max_premium_amt,
                                                p_user_id,
                                                SYSDATE
                                        );
                END IF;
            ELSE
                IF GIACS607_PKG.v_transaction_type = 1 THEN
                    upload_dpc_web.prem_to_be_pd_type1(GIACS607_PKG.v_tran_id,
                                                    GIACS607_PKG.v_transaction_type,
                                                    GIACS607_PKG.v_iss_cd,
                                                    GIACS607_PKG.v_prem_seq_no,
                                                    GIACS607_PKG.v_inst_no,
                                                    GIACS607_PKG.v_collection_amt,
                                                    GIACS607_PKG.v_premium_amt,
                                                    GIACS607_PKG.v_tax_amt,
                                                    GIACS607_PKG.v_max_premium_amt,
                                                    p_user_id,
                                                    SYSDATE
                                                );
                ELSIF GIACS607_PKG.v_transaction_type = 3 THEN 
                    upload_dpc_web.prem_to_be_pd_type3( GIACS607_PKG.v_tran_id,
                                                    GIACS607_PKG.v_transaction_type,
                                                    GIACS607_PKG.v_iss_cd,
                                                    GIACS607_PKG.v_prem_seq_no,
                                                    GIACS607_PKG.v_inst_no,
                                                    GIACS607_PKG.v_collection_amt,
                                                    GIACS607_PKG.v_premium_amt,
                                                    GIACS607_PKG.v_tax_amt,
                                                    GIACS607_PKG.v_max_premium_amt,
                                                    p_user_id,
                                                    SYSDATE
                                                );
                END IF;
            END IF;
        END IF;
    END with_tax_allocation;
    
    
    FUNCTION get_prem_to_be_paid (
        p_iss_cd                giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no            giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_gross_prem_amt        giac_upload_prem_comm.gross_prem_amt%TYPE,
        p_user_id               VARCHAR2,
        p_get_prem_pd_tag       VARCHAR2
    ) RETURN NUMBER
    AS
        v_colln_amt            NUMBER := 0;
        v_rem_colln_amt        NUMBER := 0;
        v_ins_prem_amt      NUMBER := 0;
    BEGIN
        v_rem_colln_amt := p_gross_prem_amt;
        
        --get the bills of the policy where the collection will be distributed
        FOR rec IN (SELECT c.iss_cd, c.prem_seq_no, c.inst_no, c.balance_amt_due, c.prem_balance_due,
                           c.tax_balance_due, b.currency_cd, b.currency_rt
                      FROM gipi_installment        d,
                           giac_aging_soa_details  c,
                           gipi_invoice            b
                     WHERE 1=1
                       AND c.iss_cd           = d.iss_cd
                       AND c.prem_seq_no      = d.prem_seq_no
                       AND c.inst_no          = d.inst_no
                       AND c.balance_amt_due <> 0
                       AND b.iss_cd           = c.iss_cd
                       AND b.prem_seq_no      = c.prem_seq_no
                       AND b.iss_cd           = p_iss_cd
                       AND b.prem_seq_no      = p_prem_seq_no
                     ORDER BY 1,2,3)
        LOOP
            --determine the tran type
            IF rec.balance_amt_due > 0 THEN
                GIACS607_PKG.v_transaction_type := 1;
            ELSIF rec.balance_amt_due < 0 THEN
                GIACS607_PKG.v_transaction_type := 3;
            ELSE
                RETURN (0);
            END IF;

            --get the amt to be used for the bill
            IF GIACS607_PKG.v_transaction_type = 1 THEN
                IF v_rem_colln_amt < rec.balance_amt_due THEN
                    v_colln_amt := v_rem_colln_amt;
                ELSE
                    v_colln_amt := rec.balance_amt_due;
                END IF;                
            ELSE
                IF v_rem_colln_amt > 0 THEN
                    RETURN (0);
                END IF;
                IF v_rem_colln_amt > rec.balance_amt_due THEN
                    v_colln_amt := v_rem_colln_amt;
                ELSE
                    v_colln_amt := rec.balance_amt_due;
                END IF;                
            END IF;


            --initialize the variables
            GIACS607_PKG.v_tran_id       := -1;
            GIACS607_PKG.v_iss_cd        := rec.iss_cd;
            GIACS607_PKG.v_prem_seq_no   := rec.prem_seq_no;
            GIACS607_PKG.v_inst_no       := rec.inst_no;    
                
            GIACS607_PKG.v_max_collection_amt    := rec.balance_amt_due;
            GIACS607_PKG.v_max_premium_amt       := rec.prem_balance_due;
            GIACS607_PKG.v_max_tax_amt            := rec.tax_balance_due;

            GIACS607_PKG.v_collection_amt := v_colln_amt;
            GIACS607_PKG.v_currency_cd    := rec.currency_cd;
            GIACS607_PKG.v_convert_rate   := rec.currency_rt;
            
            --derive the premium and tax amts from the collection amt
            GIACS607_PKG.WITH_TAX_ALLOCATION(p_get_prem_pd_tag, p_user_id);

            v_ins_prem_amt := v_ins_prem_amt + GIACS607_PKG.v_premium_amt;

            v_rem_colln_amt := v_rem_colln_amt - v_colln_amt;

            --exit if the collection amt has been fully distributed
            IF v_rem_colln_amt = 0 THEN
                EXIT;
            END IF;    
        END LOOP;
        
        RETURN v_ins_prem_amt;
        
    END get_prem_to_be_paid;
    
    
    PROCEDURE validate_policy(
        p_source_cd             IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no               IN  giac_upload_colln_dtl.FILE_NO%TYPE,
        p_user_id               IN  VARCHAR2,
        p_get_prem_pd_tag       OUT VARCHAR2
    )
    AS
        v_prem_payt_for_sp      GIAC_PARAMETERS.param_value_v%TYPE := nvl(giacp.v('PREM_PAYT_FOR_SPECIAL'),'N');
        v_message               VARCHAR2(32767);
        
        v_excluded_branch        VARCHAR2(4);
        v_prem_chk_flag            VARCHAR2(2);
        v_prem_chk_remarks        VARCHAR2(2000);
        v_comm_chk_flag            VARCHAR2(2);
        v_comm_chk_remarks        VARCHAR2(2000);
        v_chk_remarks            VARCHAR2(2000);
        v_tot_gprem_amt_due        giac_aging_soa_details.balance_amt_due%TYPE;
        v_tot_comm_amt_due        gipi_comm_invoice.commission_amt%TYPE;
        v_policy_id                gipi_polbasic.policy_id%TYPE;
        v_reg_policy_sw            gipi_polbasic.reg_policy_sw%TYPE;
        v_ri_iss_cd             giis_issource.iss_cd%TYPE := giacp.v ('RI_ISS_CD');
        v_bills                    VARCHAR2(200);
            
        v_rem_gprem_payt        giac_aging_soa_details.balance_amt_due%TYPE;
        v_inv_sign                NUMBER;
        v_inv_comm_sign            NUMBER;
        v_comm_bills            VARCHAR2(200);
        v_tot_prem_amt_due        giac_aging_soa_details.balance_amt_due%TYPE;
        v_tot_soa_amt_due        giac_aging_soa_details.total_amount_due%TYPE;
                
        v_inv_gprem                giac_aging_soa_details.balance_amt_due%TYPE;
        v_inv_gprem_due            giac_aging_soa_details.balance_amt_due%TYPE;
        v_inv_prem                giac_aging_soa_details.prem_balance_due%TYPE;
        v_inv_prem_due            giac_aging_soa_details.prem_balance_due%TYPE;
        v_inv_pd_comm            giac_comm_payts.comm_amt%TYPE;
        v_inv_comm                gipi_comm_invoice.commission_amt%TYPE;
        v_inv_whtax                gipi_comm_invoice.wholding_tax%TYPE;
        v_inv_comm_due            gipi_comm_invoice.commission_amt%TYPE;
        v_inv_dummy_gprem_payt    giac_aging_soa_details.balance_amt_due%TYPE;
        v_inv_prem_payt            giac_aging_soa_details.prem_balance_due%TYPE;

        v_inv_pd_whtax            giac_comm_payts.wtax_amt%TYPE;
        v_inv_whtax_due            gipi_comm_invoice.wholding_tax%TYPE;
        v_tot_whtax_amt_due        gipi_comm_invoice.wholding_tax%TYPE;
        v_inv_pd_invat            giac_comm_payts.input_vat_amt%TYPE;
        v_inv_invat_due            giac_comm_payts.input_vat_amt%TYPE;
        v_tot_invat_amt_due        giac_comm_payts.input_vat_amt%TYPE;
        v_max_inv_invat            giac_comm_payts.input_vat_amt%TYPE;
        v_max_inv_whtax            giac_comm_payts.wtax_amt%TYPE;
            
        v_fail_trigger          BOOLEAN := FALSE;
    
    BEGIN
        v_excluded_branch := nvl(giacp.v('BRANCH_EXCLUDED_IN_UPLOAD'),'NONE');
        
        p_get_prem_pd_tag := 'Y';
        
        FOR guf IN (SELECT *
                    FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))
        LOOP
            FOR rec IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no, 
                                gross_prem_amt, comm_amt, whtax_amt, input_vat_amt, net_amt_due 
                          FROM giac_upload_prem_comm
                         WHERE source_cd = guf.source_cd
                           AND file_no = guf.file_no)
            LOOP
                --set/reset variables
                v_prem_chk_flag    := 'OK';
                v_prem_chk_remarks := 'The premium payment for this policy is valid for uploading.';
                v_comm_chk_flag         := 'OK';
                v_comm_chk_remarks := 'The commission payment for this policy is valid for uploading.';
                v_chk_remarks         := 'This policy is valid for uploading.';
                v_tot_gprem_amt_due := 0;
                v_tot_comm_amt_due := 0;
                v_policy_id := NULL;
                v_bills := NULL;
                v_rem_gprem_payt := 0;
                v_inv_sign             := NULL;
                v_inv_comm_sign     := NULL;
                v_comm_bills     := NULL;
                v_tot_prem_amt_due := 0;
                v_tot_soa_amt_due := 0;
                v_tot_whtax_amt_due := 0;
                v_tot_invat_amt_due := 0;
                    
                --check the gross premium
                IF rec.gross_prem_amt = 0 THEN
                    v_message := ('#E#Error in data checking. Zero gross premium found.');
                    v_fail_trigger := TRUE;
                    GOTO trigger_has_failed;
                END IF;    

                --validations for both premium and commission--
                IF rec.iss_cd = v_excluded_branch THEN
                    v_prem_chk_flag := 'EX';
                    v_comm_chk_flag    := 'EX';
                    v_chk_remarks   := 'This policy''s issuing source is '||v_excluded_branch||'.';
                    GOTO update_table;
                ELSIF rec.iss_cd = v_ri_iss_cd THEN
                    v_prem_chk_flag := 'RI';
                    v_comm_chk_flag    := 'RI';
                    v_chk_remarks   := 'This is a reinsurance policy.';
                    GOTO update_table;
                ELSIF check_user_per_iss_cd_acctg2(NULL,rec.iss_cd,'GIACS007', p_user_id) = 0 OR 
                        check_user_per_iss_cd_acctg2(NULL,rec.iss_cd,'GIACS020', p_user_id) = 0 THEN
                    v_prem_chk_flag := 'NA';
                    v_comm_chk_flag    := 'NA';
                    v_chk_remarks   := 'User is not allowed to make collections for the branch of this policy.';
                    GOTO update_table;    
                END IF;       

                FOR rec_a IN (SELECT pol_flag, reg_policy_sw, policy_id
                                FROM gipi_polbasic
                               WHERE line_cd     = rec.line_cd
                                 AND subline_cd  = rec.subline_cd
                                 AND iss_cd      = rec.iss_cd
                                 AND issue_yy    = rec.issue_yy
                                 AND pol_seq_no  = rec.pol_seq_no
                                 AND renew_no    = rec.renew_no
                                 AND endt_iss_cd = rec.endt_iss_cd
                                 AND endt_yy     = rec.endt_yy
                                 AND endt_seq_no = rec.endt_seq_no)                   
                LOOP    
                    --check if policy is spoiled
                    IF rec_a.pol_flag = '5' THEN
                        v_prem_chk_flag := 'SL';--spoiled
                        v_comm_chk_flag    := 'SL';--spoiled
                        v_chk_remarks   := 'This policy is already spoiled.';
                        GOTO update_table;
                    END IF;            
                            
                    --check for flat cancelled policy
                    IF rec_a.pol_flag = '4' THEN
                        FOR rec_flat IN (SELECT 'x'
                                           FROM giac_cancelled_policies_v
                                          WHERE line_cd = rec.line_cd
                                            AND subline_cd = rec.subline_cd
                                            AND iss_cd = rec.iss_cd
                                            AND issue_yy = rec.issue_yy
                                            AND pol_seq_no = rec.pol_seq_no
                                            AND renew_no = rec.renew_no)
                        LOOP
                            v_prem_chk_flag := 'CP';--cancelled
                            v_comm_chk_flag    := 'CP';--cancelled
                            v_chk_remarks   := 'This is a cancelled policy.';
                            GOTO update_table;
                        END LOOP rec_flat;    
                    END IF;        
                                
                    --check if special policy
                    IF rec_a.reg_policy_sw = 'N' AND v_prem_payt_for_sp <> 'Y' THEN
                        v_prem_chk_flag := 'SP';--special policy
                        v_comm_chk_flag    := 'SP';--special policy
                        v_chk_remarks   := 'This is a special policy.';
                        GOTO update_table;
                    END IF;
                    
                    --check if policy is valid for the intm
                    FOR rec_valid IN (SELECT 'x'
                                        FROM gipi_comm_invoice
                                       WHERE policy_id = rec_a.policy_id
                                         AND intrmdry_intm_no = guf.intm_no)
                    LOOP
                        v_policy_id := rec_a.policy_id;
                        v_reg_policy_sw := rec_a.reg_policy_sw;
                        EXIT;
                    END LOOP rec_valid;
                END LOOP rec_a;

                IF v_policy_id IS NULL THEN
                    v_prem_chk_flag := 'IP';--invalid policy
                    v_comm_chk_flag    := 'IP';--invalid policy
                    v_chk_remarks   := 'This policy is not a policy of this intermediary.';
                    GOTO update_table;
                END IF;            

                --validations for premium only--
                --get the bills and total amount due
                FOR rec_prem IN (SELECT gasd.iss_cd, gasd.prem_seq_no, SUM(balance_amt_due) gprem_amt_due, SUM(prem_balance_due) prem_amt_due, 
                                        SUM(total_amount_due) soa_amt_due
                                   FROM giac_aging_soa_details gasd, gipi_invoice ginv
                                  WHERE 1=1
                                    AND ginv.prem_seq_no = gasd.prem_seq_no
                                    AND ginv.iss_cd      = gasd.iss_cd
                                    AND ginv.policy_id   = v_policy_id
                               GROUP BY gasd.iss_cd, gasd.prem_seq_no
                               ORDER BY 1,2 )
                LOOP
                    IF v_reg_policy_sw <> 'N' OR (v_reg_policy_sw = 'N' AND v_prem_payt_for_sp = 'Y') THEN        
                        IF chk_modified_comm (rec_prem.iss_cd,rec_prem.prem_seq_no) THEN
                            v_message := ('#E#Disbursement of commission was already made to the previous intermediary of bill no. '||rec_prem.iss_cd||'-'||rec_prem.prem_seq_no||'.' 
                                    ||' Cancel the payments made before disbursing commission to the new intermediary.');
                            v_fail_trigger := TRUE;
                            GOTO trigger_has_failed;        
                        END IF;                                               
                        
                        v_bills := v_bills||', '||rec_prem.iss_cd||'-'||rec_prem.prem_seq_no;
                        v_tot_gprem_amt_due := v_tot_gprem_amt_due + rec_prem.gprem_amt_due;
                        v_tot_prem_amt_due  := v_tot_prem_amt_due + rec_prem.prem_amt_due;
                        v_tot_soa_amt_due   := v_tot_soa_amt_due + rec_prem.soa_amt_due;
                        END IF;
                END LOOP rec_prem;
                
                v_inv_sign := sign(v_tot_soa_amt_due);
                    
                IF v_inv_sign = 1 AND rec.gross_prem_amt < 0 THEN
                    v_prem_chk_flag := 'NP';--negative on positive
                    v_comm_chk_flag := 'NP';--negative on positive
                    v_chk_remarks := 'This policy has positive premium and commission due.';
                    GOTO update_table;                
                END IF;
                    
                IF v_tot_gprem_amt_due = 0 THEN
                    v_prem_chk_flag := 'FP';--fully paid
                    v_prem_chk_remarks := 'This policy is already fully paid.';
                ELSIF rec.gross_prem_amt > 0 THEN
                    IF rec.gross_prem_amt > v_tot_gprem_amt_due THEN
                        v_prem_chk_flag := 'OP';--overpayment
                        v_prem_chk_remarks := 'This policy has an overpayment on premium. The policy with bill nos. '||substr(v_bills,3)||' has a total balance amount due of '||ltrim(to_char(v_tot_gprem_amt_due, '999,999,999,990.90'))||'.';
                    ELSIF    rec.gross_prem_amt < v_tot_gprem_amt_due THEN
                        v_prem_chk_flag := 'PT';--partial payment
                        v_prem_chk_remarks := 'This is a partial premium payment. The total balance amount due for bill nos. '||substr(v_bills,3)||' is '||ltrim(to_char(v_tot_gprem_amt_due, '999,999,999,990.90'))||'.';
                    END IF;
                ELSIF rec.gross_prem_amt < 0 THEN
                    IF v_tot_gprem_amt_due < 0 THEN
                        IF rec.gross_prem_amt > v_tot_gprem_amt_due THEN
                            v_prem_chk_flag := 'PT';--partial payment
                            v_prem_chk_remarks := 'This is a partial premium payment. The total balance amount due for bill nos. '||substr(v_bills,3)||' is '||ltrim(to_char(v_tot_gprem_amt_due, '999,999,999,990.90'))||'.';
                        ELSIF    rec.gross_prem_amt < v_tot_gprem_amt_due THEN
                            v_prem_chk_flag := 'ON';--overpayment on negative
                            v_prem_chk_remarks := 'This is an overpayment on negative endorsement. The total balance amount due for bill nos. '||substr(v_bills,3)||' is '||ltrim(to_char(v_tot_gprem_amt_due, '999,999,999,990.90'))||'.';
                        END IF;
                    END IF;
                END IF;    
                                
                --check if policy has existing claim records
                FOR rec_claim IN (SELECT 'X'
                                    FROM gicl_claims a 
                                   WHERE 1=1
                                     AND clm_stat_cd NOT IN ('CD','CC','DN','WD')
                                     AND a.line_cd      = rec.line_cd
                                     AND a.subline_cd   = rec.subline_cd
                                     AND a.pol_iss_cd   = rec.iss_cd
                                     AND a.issue_yy     = rec.issue_yy
                                     AND a.pol_seq_no   = rec.pol_seq_no
                                     AND a.renew_no     = rec.renew_no)
                LOOP
                    IF v_prem_chk_flag = 'OK' THEN
                        v_prem_chk_flag := 'WC';
                        v_prem_chk_remarks := 'This policy has an existing claim.';
                    ELSE
                        IF v_prem_chk_flag = 'FP' THEN
                            v_prem_chk_flag := 'FC';
                        ELSIF v_prem_chk_flag = 'OP' THEN
                            v_prem_chk_flag := 'OC';
                        ELSIF v_prem_chk_flag = 'PT' THEN
                            v_prem_chk_flag := 'PC';
                        ELSIF v_prem_chk_flag = 'ON' THEN
                            v_prem_chk_flag := 'CO';
                        END IF;
                        v_prem_chk_remarks := v_prem_chk_remarks||' It also has an existing claim.';
                    END IF;    
                    EXIT;
                END LOOP rec_claim; 


                --validations for commission only--
                SELECT sign(SUM(nvl(gcid.commission_amt, gci.commission_amt) * gi.currency_rt))
                  INTO v_inv_comm_sign
                  FROM gipi_comm_inv_dtl gcid, gipi_comm_invoice gci, gipi_invoice gi
                 WHERE 1=1
                   AND gci.iss_cd = gcid.iss_cd(+)
                   AND gci.prem_seq_no = gcid.prem_seq_no(+)
                   AND gci.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
                   AND gci.intrmdry_intm_no = guf.intm_no
                   AND gci.iss_cd = gi.iss_cd
                   AND gci.prem_seq_no = gi.prem_seq_no
                   AND gi.policy_id = v_policy_id;

                IF v_inv_comm_sign = 0 THEN
                    v_comm_chk_flag    := 'NC';--no commission set-up
                    v_comm_chk_remarks := 'There is no commission set-up for this policy.';
                    v_chk_remarks := '(P) '||v_prem_chk_remarks||chr(10)||'(C) '||v_comm_chk_remarks;
                    GOTO update_table;
                END IF;
                                    
                v_rem_gprem_payt := rec.gross_prem_amt;

                FOR inv_rec IN (SELECT gasd.iss_cd, gasd.prem_seq_no, gasd.gprem_due, gasd.prem_due, 
                                        nvl(ginv.prem_amt,0) inv_prem, 
                                        nvl(ginv.tax_amt,0) inv_tax, 
                                          ginv.currency_rt 
                                  FROM (SELECT iss_cd, prem_seq_no, sum(balance_amt_due) gprem_due, sum(prem_balance_due) prem_due
                                          FROM giac_aging_soa_details
                                         GROUP BY iss_cd, prem_seq_no) gasd, 
                                        gipi_invoice ginv
                                  WHERE 1=1
                                    AND ginv.prem_seq_no = gasd.prem_seq_no
                                    AND ginv.iss_cd      = gasd.iss_cd
                                    AND ginv.policy_id   = v_policy_id
                               ORDER BY 1,2 )
                LOOP
                    v_inv_gprem_due := inv_rec.gprem_due;
                    v_inv_prem_due    := inv_rec.prem_due;

                    --Utilize the DB function get_loc_inv_tax_sum if currency_rt <> 1 to get the correct 
                    --value of the converted tax amt that will match the sum in giac_tax_collns
                    IF inv_rec.currency_rt <> 1 THEN
                        v_inv_prem  := inv_rec.inv_prem * inv_rec.currency_rt;
                        v_inv_gprem := v_inv_prem + get_loc_inv_tax_sum(inv_rec.iss_cd,inv_rec.prem_seq_no);
                    ELSE
                        v_inv_prem  := inv_rec.inv_prem;
                        v_inv_gprem := v_inv_prem + inv_rec.inv_tax;
                    END IF;
                            
                    v_inv_comm          := 0;
                    v_inv_whtax         := 0;
                    v_inv_pd_comm        := 0;
                    v_inv_pd_whtax    := 0;
                    v_inv_pd_invat    := 0;        
                        
                    FOR gci_rec IN (SELECT nvl(gcid.commission_amt, gci.commission_amt) * gi.currency_rt comm_amt,
                                           nvl(gcid.wholding_tax, gci.wholding_tax) * gi.currency_rt whtax_amt
                                      FROM gipi_comm_inv_dtl gcid, gipi_comm_invoice gci, gipi_invoice gi
                                     WHERE 1=1
                                       AND gci.iss_cd = gcid.iss_cd(+)
                                       AND gci.prem_seq_no = gcid.prem_seq_no(+)
                                       AND gci.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
                                       AND gci.intrmdry_intm_no = guf.intm_no
                                       AND gci.iss_cd = gi.iss_cd
                                       AND gci.prem_seq_no = gi.prem_seq_no
                                       AND gi.iss_cd = inv_rec.iss_cd
                                       AND gi.prem_seq_no = inv_rec.prem_seq_no)
                    LOOP
                        v_inv_comm  := gci_rec.comm_amt;
                        v_inv_whtax := gci_rec.whtax_amt;

                        IF v_inv_comm <> 0 THEN
                            v_comm_bills := v_comm_bills||', '||inv_rec.iss_cd||'-'||inv_rec.prem_seq_no;
                        END IF;    

                        SELECT nvl(sum(comm_amt),0), nvl(sum(wtax_amt),0), nvl(sum(input_vat_amt),0)
                          INTO v_inv_pd_comm, v_inv_pd_whtax, v_inv_pd_invat
                          FROM giac_acctrans b, giac_comm_payts a 
                         WHERE a.gacc_tran_id = b.tran_id
                           AND b.tran_flag <> 'D'
                           AND NOT EXISTS(SELECT 'x' 
                                            FROM giac_reversals cc, giac_acctrans dd 
                                           WHERE cc.reversing_tran_id = dd.tran_id 
                                             AND dd.tran_flag <> 'D' 
                                             AND cc.gacc_tran_id = b.tran_id)
                           AND a.iss_cd = inv_rec.iss_cd
                           AND a.prem_seq_no = inv_rec.prem_seq_no
                           AND a.intm_no = guf.intm_no;
                    END LOOP gci_rec;

                    --get the comm amount due
                    v_inv_comm_due  := v_inv_comm - v_inv_pd_comm;
                    v_inv_whtax_due := v_inv_whtax - v_inv_pd_whtax;
                    v_max_inv_whtax := v_inv_whtax_due;
                        
                    IF v_inv_prem_due = 0 OR (v_inv_comm_due = 0 AND v_inv_comm <> 0) THEN
                        NULL;
                    ELSIF    v_inv_comm = 0 THEN
                        v_inv_comm_due  := 0;
                        v_inv_whtax_due := 0;
                        IF abs(v_rem_gprem_payt) >= abs(v_inv_gprem_due) THEN
                            v_rem_gprem_payt := v_rem_gprem_payt - v_inv_gprem_due;
                        ELSE    
                            v_rem_gprem_payt := 0;
                        END IF;    
                    ELSE
                        IF v_inv_comm_sign = 1 THEN
                            IF v_rem_gprem_payt >= v_inv_gprem_due THEN
                                v_inv_dummy_gprem_payt := v_inv_gprem_due;
                                v_rem_gprem_payt := v_rem_gprem_payt - v_inv_dummy_gprem_payt;
                            ELSE    
                                v_inv_dummy_gprem_payt := v_rem_gprem_payt;
                                v_rem_gprem_payt := 0;
                            END IF;    
                        ELSIF v_inv_comm_sign = -1 THEN
                            IF sign(v_rem_gprem_payt) = 1 THEN
                                v_inv_dummy_gprem_payt := 0;
                            ELSE
                                IF v_rem_gprem_payt <= v_inv_gprem_due THEN
                                    v_inv_dummy_gprem_payt := v_inv_gprem_due;
                                    v_rem_gprem_payt := v_rem_gprem_payt - v_inv_dummy_gprem_payt;
                                ELSE    
                                    v_inv_dummy_gprem_payt := v_rem_gprem_payt;
                                    v_rem_gprem_payt := 0;
                                END IF;    
                            END IF;
                        END IF;

                        --v_inv_prem_payt := GET_PREM_TO_BE_PAID(inv_rec.iss_cd, inv_rec.prem_seq_no, v_inv_dummy_gprem_payt);
                        
                        v_inv_prem_payt := GIACS607_PKG.GET_PREM_TO_BE_PAID(inv_rec.iss_cd, inv_rec.prem_seq_no, v_inv_dummy_gprem_payt, 
                                                                            p_user_id, p_get_prem_pd_tag);

                        IF (v_inv_prem - v_inv_prem_due + v_inv_prem_payt)/v_inv_prem < 1 THEN
                            v_inv_comm_due := (v_inv_prem - v_inv_prem_due + v_inv_prem_payt)/v_inv_prem * v_inv_comm - v_inv_pd_comm;
                            v_inv_whtax_due := v_inv_comm_due * (v_inv_whtax/v_inv_comm);
                            --check if v_inv_whtax_due exceeds v_max_inv_whtax due to 
                            --rounding if there are multiple payments for the comm invoice
                            IF v_max_inv_whtax <> 0 AND abs(v_inv_whtax_due) > abs(v_max_inv_whtax) AND trunc((v_inv_whtax_due/v_max_inv_whtax),2) = 1 THEN
                                v_inv_whtax_due := v_max_inv_whtax;
                            END IF;    
                        END IF;    
                    END IF;    
                    
                    v_inv_invat_due := v_inv_comm_due * NVL(guf.nbt_input_vat_rate,0)/100; --jason 05252009: added NVL to :guf.nbt_invat_rt
                    --check if v_inv_invat_due exceeds v_max_inv_invat due to 
                    --rounding if there are multiple payments for the comm invoice
                    IF v_inv_invat_due <> 0 THEN
                        v_max_inv_invat := round(v_inv_comm * NVL(guf.nbt_input_vat_rate,0)/100,2) - v_inv_pd_invat; --jason 05252009: added NVL to :guf.nbt_invat_rt
                        IF v_max_inv_invat <> 0 AND abs(v_inv_invat_due) > abs(v_max_inv_invat) AND trunc((v_inv_invat_due/v_max_inv_invat),2) = 1 THEN
                            v_inv_invat_due := v_max_inv_invat;
                        END IF;
                    END IF;    

                    v_tot_comm_amt_due := v_tot_comm_amt_due + v_inv_comm_due;
                    v_tot_whtax_amt_due := v_tot_whtax_amt_due + v_inv_whtax_due;
                    v_tot_invat_amt_due := v_tot_invat_amt_due + v_inv_invat_due;
                END LOOP inv_rec;

                IF rec.comm_amt = 0 THEN
                    v_comm_chk_flag    := 'ZC';--zero commission
                    v_comm_chk_remarks := 'There is a commission set-up for this policy.';
                ELSIF v_tot_comm_amt_due = 0 AND v_tot_prem_amt_due = 0 THEN
                    v_comm_chk_flag := 'FP';--fully paid
                    v_comm_chk_remarks := 'This policy is already fully paid.';
                ELSIF rec.comm_amt > 0 THEN
                    IF rec.comm_amt > v_tot_comm_amt_due THEN
                        v_comm_chk_flag := 'OP';--over payment
                        v_comm_chk_remarks := 'This policy has an overpayment on commission. The policy with bill nos. '||substr(v_comm_bills,3)||' has a commission amount due of '||ltrim(to_char(v_tot_comm_amt_due, '999,999,999,990.90'))||'.';
                    ELSIF    rec.comm_amt < v_tot_comm_amt_due THEN
                        v_comm_chk_flag := 'PT';--partial payment
                        v_comm_chk_remarks := 'This is a partial commission payment. The commission amount due for bill nos. '||substr(v_comm_bills,3)||' is '||ltrim(to_char(v_tot_comm_amt_due, '999,999,999,990.90'))||'.';
                    END IF;
                ELSIF rec.comm_amt < 0 THEN
                    IF v_tot_comm_amt_due < 0 THEN
                        IF rec.comm_amt > v_tot_comm_amt_due THEN
                            v_comm_chk_flag := 'PT';--partial payment
                            v_comm_chk_remarks := 'This is a partial commission payment. The commission amount due for bill nos. '||substr(v_comm_bills,3)||' is '||ltrim(to_char(v_tot_comm_amt_due, '999,999,999,990.90'))||'.';
                        ELSIF    rec.comm_amt < v_tot_comm_amt_due THEN
                            v_comm_chk_flag := 'ON';--overpayment on negative
                            v_comm_chk_remarks := 'This is an overpayment on negative commission. The total balance amount due for bill nos. '||substr(v_comm_bills,3)||' is '||ltrim(to_char(v_tot_comm_amt_due, '999,999,999,990.90'))||'.';            
                        END IF;
                    END IF;    
                END IF;

                IF v_comm_chk_flag  = 'OK' THEN
                    --check the withholding tax
                    IF v_tot_whtax_amt_due <> rec.whtax_amt THEN
                        v_comm_chk_flag := 'WW';
                        v_comm_chk_remarks := 'The withholding tax amount does not correspond to the withholding tax rate set for this intermediary.';
                    END IF;    

                    --check the input vat
                    IF v_tot_invat_amt_due <> rec.input_vat_amt THEN
                        IF v_comm_chk_flag = 'WW' THEN
                            v_comm_chk_flag := 'WT';
                            v_comm_chk_remarks := 'Both the withholding tax and input vat amounts do not correspond to the tax rates set for this intermediary.';
                        ELSE
                            v_comm_chk_flag := 'WV';
                            v_comm_chk_remarks := 'The input vat amount does not correspond to the input vat rate set for this intermediary.';
                        END IF;    
                    END IF;    
                END IF;            

                IF v_prem_chk_flag = 'OK' AND v_comm_chk_flag = 'OK' THEN
                    GOTO update_table;                    
                ELSIF v_prem_chk_flag IN ('FP','FC') AND v_comm_chk_flag = 'FP' THEN
                    v_chk_remarks := v_prem_chk_remarks;
                    GOTO update_table;                    
                ELSIF v_prem_chk_flag = 'WC' AND v_comm_chk_flag = 'OK' THEN            
                    v_chk_remarks := v_prem_chk_remarks;
                    GOTO update_table;                    
                ELSE 
                    v_chk_remarks := '(P) '||v_prem_chk_remarks||chr(10)||'(C) '||v_comm_chk_remarks;
                    GOTO update_table;
                END IF;            

                <<update_table>>
                --set amounts due to NULL
                IF v_prem_chk_flag IN ('EX','RI','NA','SL','CP','SP','IP','NP') THEN
                    v_tot_gprem_amt_due := NULL;
                    v_tot_comm_amt_due  := NULL;
                    v_tot_whtax_amt_due := NULL;
                    v_tot_invat_amt_due := NULL;
                END IF;
                    
                UPDATE giac_upload_prem_comm
                   SET prem_chk_flag = v_prem_chk_flag,
                       comm_chk_flag = v_comm_chk_flag,
                       chk_remarks     = v_chk_remarks,
                       gprem_amt_due = v_tot_gprem_amt_due,
                       comm_amt_due  = v_tot_comm_amt_due,
                       whtax_amt_due = v_tot_whtax_amt_due,
                       invat_amt_due = v_tot_invat_amt_due
                 WHERE source_cd   = guf.source_cd
                   AND file_no     = guf.file_no
                   AND line_cd     = rec.line_cd
                   AND subline_cd  = rec.subline_cd
                   AND iss_cd      = rec.iss_cd
                   AND issue_yy    = rec.issue_yy
                   AND pol_seq_no  = rec.pol_seq_no
                   AND renew_no    = rec.renew_no
                   AND endt_iss_cd = rec.endt_iss_cd
                   AND endt_yy     = rec.endt_yy
                   AND endt_seq_no = rec.endt_seq_no;
            END LOOP rec;            
        END LOOP;
            
        <<trigger_has_failed>>
        p_get_prem_pd_tag := 'N';

        IF v_fail_trigger THEN
            raise_application_error (-20001, 'Geniisys Exception'||v_message);
        ELSE
            COMMIT;
        END IF;    
        
    END validate_policy;
    
    FUNCTION check_user_branch_access(
        p_source_cd     GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no       GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_module_id     VARCHAR2,
        p_user_id       VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_branch_cd     GIAC_UPLOAD_JV_PAYT_DTL.BRANCH_CD%TYPE;
        
        TYPE cur_type IS REF CURSOR;
        c               cur_type;
        v_sql           VARCHAR2(10000);
        v_msg           VARCHAR2(1000);
    BEGIN      
        v_sql   := 'SELECT branch_cd FROM ';  
        IF p_module_id = 'GIACS003' THEN
            v_sql   := v_sql || ' giac_upload_jv_payt_dtl ';
            v_msg   :=  'Geniisys Exception#E#You are not allowed to create a JV transaction for '; 
        ELSIF p_module_id = 'GIACS016' THEN
            v_sql := v_sql || ' giac_upload_dv_payt_dtl ';
            v_msg   :=  'Geniisys Exception#E#You are not allowed to create a Disbursement Request for ';
        END IF;
        
        v_sql := v_sql || ' WHERE source_cd = :p_source_cd  AND file_no = :p_file_no ';
        
        OPEN c FOR v_sql USING p_source_cd, p_file_no;
        LOOP
            FETCH c INTO v_branch_cd;
            
            IF check_user_per_iss_cd_acctg2(NULL, v_branch_cd, p_module_id, p_user_id) = 0 THEN
                v_msg := v_msg || v_branch_cd || ' branch.';
                raise_application_error (-20001, v_msg);    
            END IF;
        
            EXIT WHEN c%NOTFOUND;  
        END LOOP;
        
        CLOSE c;
        
        RETURN v_branch_cd;
    END check_user_branch_access;
    
    
    PROCEDURE check_payment_before_upload(
        p_source_cd             GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no               GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_dsp_tran_class        VARCHAR2,
        p_user_id                   VARCHAR2,
        p_dcb_no            OUT giac_colln_batch.dcb_no%TYPE
    )
    AS
        v_stale_check             giac_parameters.param_value_v%TYPE := giacp.n('STALE_CHECK');
        v_stale_mgr_chk            giac_parameters.param_value_v%TYPE := giacp.n('STALE_MGR_CHK');
        
        v_branch_cd             giac_parameters.param_value_v%TYPE;
        v_gross_prem_amt       NUMBER;
        v_net_comm_amt         NUMBER;
        v_net_amt_due          NUMBER;
        
        v_gross_colln_amt      NUMBER;
        v_net_comm_colln_amt   NUMBER;
        v_colln_amt            NUMBER;
        v_stale_date           DATE;
        
        v_list                 guf_tab;
    BEGIN
        BEGIN
            SELECT a.grp_iss_cd
              INTO v_branch_cd
              FROM giis_user_grp_hdr a,
                   giis_users b
             WHERE a.user_grp = b.user_grp
               AND b.user_id = P_USER_ID;      
        EXCEPTION
            WHEN no_data_found THEN
                v_branch_cd := NULL;
        END;
        
        upload_dpc_web.SET_FIXED_VARIABLES(giacp.v('FUND_CD'), v_branch_cd, giacp.n('EVAT'));
        
        SELECT *
          BULK COLLECT INTO v_list
          FROM TABLE (giacs607_pkg.get_guf_details (p_source_cd, p_file_no));
          
        FOR guf IN 1 .. v_list.COUNT 
        LOOP
            IF p_dsp_tran_class = 'COL' THEN
                -- CHECK_COLLN_DTL prog unit
                IF v_list(guf).nbt_gross_tag IS NULL AND v_list(guf).nbt_or_tag = 'G' THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#Gross tag cannot be null.');
                END IF;
                    
                SELECT nvl(sum(gross_prem_amt),0), nvl(sum(comm_amt-whtax_amt+input_vat_amt),0), nvl(sum(net_amt_due),0) 
                  INTO v_gross_prem_amt, v_net_comm_amt, v_net_amt_due
                  FROM giac_upload_prem_comm
                 WHERE source_cd = v_list(guf).source_cd
                   AND file_no = v_list(guf).file_no;
                         
                SELECT nvl(sum(nvl(gross_amt,0)),0), nvl(sum(nvl(commission_amt,0)+ nvl(vat_amt,0)),0), nvl(sum(nvl(amount,0)),0)
                  INTO v_gross_colln_amt, v_net_comm_colln_amt, v_colln_amt
                  FROM giac_upload_colln_dtl
                 WHERE source_cd = v_list(guf).source_cd
                   AND file_no = v_list(guf).file_no;
                       
                --check the net amount for each OR to be created
                IF v_list(guf).nbt_or_tag = 'I' THEN
                    FOR payor_rec IN (SELECT payor, nvl(sum(net_amt_due),0) amount, gross_tag
                                        FROM giac_upload_prem_comm
                                       WHERE source_cd = v_list(guf).source_cd
                                         AND file_no = v_list(guf).file_no
                                       GROUP BY payor, gross_tag)
                      LOOP
                            IF payor_rec.amount <= 0 THEN
                                raise_application_error (-20001, 'Geniisys Exception#I#Net amount for payor: '||payor_rec.payor||' must be greater than zero.');
                            END IF;    
                      END LOOP;
                END IF;
                    
                    --check the amounts
                IF v_net_amt_due <> v_colln_amt THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#Total Local Currency Amount in the Collection Details should be equal to the total Net Amount Due.');
                ELSIF v_gross_prem_amt <> v_gross_colln_amt THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#Total Gross Amount in the Collection Details should be equal to the total Gross Premium.');    
                ELSIF v_net_comm_amt <> v_net_comm_colln_amt THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#Total Commission Amount + total VAT Amount in the Collection Details should be equal to the total Net Commission Amount.');
                END IF;    
                    
                --validate the checks
                FOR rec IN (SELECT pay_mode, check_date, check_no, check_class
                              FROM giac_upload_colln_dtl
                             WHERE source_cd = v_list(guf).source_cd
                               AND file_no = v_list(guf).file_no
                             ORDER BY item_no)
                LOOP
                    IF rec.pay_mode = 'CHK' THEN
                        IF rec.check_date IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Please enter check date for check no. '||rec.check_no||' in the Collection Details.');
                        ELSE
                            IF rec.check_date > v_list(guf).nbt_or_date THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Check no. '||rec.check_no||' in the Collection Details is post-dated.');
                            END IF;

                            IF rec.check_class = 'M' THEN
                                v_stale_date := to_date(to_char(add_months(trunc(v_list(guf).nbt_or_date), (-1 * v_stale_mgr_chk)), 'MM-DD-YYYY'),'MM-DD-YYYY');
                            ELSE    
                                v_stale_date := to_date(to_char(add_months(trunc(v_list(guf).nbt_or_date), (-1 * v_stale_check)), 'MM-DD-YYYY'),'MM-DD-YYYY');
                            END IF;
                                    
                            IF trunc(rec.check_date) <=  trunc(v_stale_date) THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Check no. '||rec.check_no||' in the Collection Details is a stale check.');
                            END IF;
                        END IF;
                    END IF;    
                END LOOP;
               
                /*
                ** nieko Accounting Uploading move dcb check in uploading
                upload_dpc_web.check_tran_mm(v_list(guf).nbt_or_date);
                upload_dpc_web.check_dcb_user(v_list(guf).nbt_or_date, p_user_id);
                upload_dpc_web.get_dcb_no(v_list(guf).nbt_or_date, p_dcb_no);*/
                    
            ELSIF p_dsp_tran_class IN ('DV', 'JV') THEN
                IF p_dsp_tran_class = 'DV' THEN
                    FOR gudv IN (SELECT *
                                   FROM TABLE(GIACS607_PKG.GET_GUDV_DETAILS(v_list(guf).source_cd, v_list(guf).file_No))  )
                    LOOP
                        -- CHECK_PAYMENT_DETAILS prog unit
                        IF gudv.request_date IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Request date in the Payment Request Details is null.');
                        ELSIF gudv.gouc_ouc_id IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Department in the Payment Request Details is null.');
                        ELSIF gudv.document_cd IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Document code in the Payment Request Details is null.');
                        ELSIF gudv.branch_cd IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the Payment Request Details is null.');
                        ELSIF gudv.doc_year IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Document year in the Payment Request Details is null.');
                        ELSIF gudv.doc_mm IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Document month in the Payment Request Details is null.');
                        ELSIF gudv.payee_class_cd IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Payee class code in the Payment Request Details is null.');
                        ELSIF gudv.payee_cd IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Payee code in the Payment Request Details is null.');
                        ELSIF gudv.payee IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Payee in the Payment Request Details is null.');
                        ELSIF gudv.currency_cd IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Currency code in the Payment Request Details is null.');
                        ELSIF gudv.currency_rt IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Currency rate in the Payment Request Details is null.');
                        ELSIF gudv.dv_fcurrency_amt IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
                        ELSIF gudv.payt_amt IS NULL THEN
                            raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
                        ELSIF gudv.particulars    IS NULL THEN                               
                            raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the Payment Request Details is null.');
                        END IF;  
                        
                        upload_dpc_web.check_tran_mm(gudv.request_date);
                    END LOOP;
                    
                ELSE -- JV
                    FOR gujv IN (SELECT *
                                   FROM TABLE(GIACS607_PKG.GET_GUJV_DETAILS(v_list(guf).source_cd, v_list(guf).file_No))  )
                    LOOP
                        -- CHECK_PAYMENT_DETAILS prog unit
                        IF gujv.tran_date IS NULL THEN 
                                raise_application_error (-20001, 'Geniisys Exception#E#Transaction date in the JV Details is null.');
                        ELSIF gujv.branch_cd    IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the JV Details is null.');
                        ELSIF gujv.tran_year    IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Transaction year in the JV Details is null.');
                        ELSIF gujv.tran_month IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Transaction month in the JV Details is null.');
                        ELSIF gujv.jv_pref_suff IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#JV prefix in the JV Details is null.');
                        ELSIF gujv.particulars IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the JV Details is null.');      
                        ELSIF gujv.jv_tran_tag IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran tag in the JV Details is null.');      
                        ELSIF gujv.jv_tran_type IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran type in the JV Details is null.');      
                        ELSIF gujv.particulars IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the JV Details is null.');      
                        ELSIF gujv.jv_tran_tag = 'C' THEN
                            IF gujv.jv_tran_mm IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran month in the JV Details is null.');      
                            ELSIF gujv.jv_tran_yy IS NULL THEN
                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran year in the JV Details is null.');      
                            END IF;
                        END IF; 
                        
                        upload_dpc_web.check_tran_mm(gujv.tran_date);
                    END LOOP;
                END IF;
            END IF;
        END LOOP;

--        FOR guf IN (SELECT *
--                    FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))
--        LOOP
--            IF p_dsp_tran_class = 'COL' THEN
                -- CHECK_COLLN_DTL prog unit
--                IF guf.gross_tag IS NULL AND guf.nbt_or_tag = 'G' THEN
--                    raise_application_error (-20001, 'Geniisys Exception#I#Gross tag cannot be null.');
--                END IF;
--                    
--                SELECT nvl(sum(gross_prem_amt),0), nvl(sum(comm_amt-whtax_amt+input_vat_amt),0), nvl(sum(net_amt_due),0) 
--                  INTO v_gross_prem_amt, v_net_comm_amt, v_net_amt_due
--                  FROM giac_upload_prem_comm
--                 WHERE source_cd = guf.source_cd
--                   AND file_no = guf.file_no;
--                         
--                SELECT nvl(sum(nvl(gross_amt,0)),0), nvl(sum(nvl(commission_amt,0)+ nvl(vat_amt,0)),0), nvl(sum(nvl(amount,0)),0)
--                  INTO v_gross_colln_amt, v_net_comm_colln_amt, v_colln_amt
--                  FROM giac_upload_colln_dtl
--                 WHERE source_cd = guf.source_cd
--                   AND file_no = guf.file_no;
--                       
--                --check the net amount for each OR to be created
--                IF guf.nbt_or_tag = 'I' THEN
--                    FOR payor_rec IN (SELECT payor, nvl(sum(net_amt_due),0) amount, gross_tag
--                                        FROM giac_upload_prem_comm
--                                       WHERE source_cd = guf.source_cd
--                                         AND file_no = guf.file_no
--                                       GROUP BY payor, gross_tag)
--                      LOOP
--                            IF payor_rec.amount <= 0 THEN
--                                raise_application_error (-20001, 'Geniisys Exception#I#Net amount for payor: '||payor_rec.payor||' must be greater than zero.');
--                            END IF;    
--                      END LOOP;
--                END IF;
--                    
--                    --check the amounts
--                IF v_net_amt_due <> v_colln_amt THEN
--                    raise_application_error (-20001, 'Geniisys Exception#I#Total Local Currency Amount in the Collection Details should be equal to the total Net Amount Due.');
--                ELSIF v_gross_prem_amt <> v_gross_colln_amt THEN
--                    raise_application_error (-20001, 'Geniisys Exception#I#Total Gross Amount in the Collection Details should be equal to the total Gross Premium.');    
--                ELSIF v_net_comm_amt <> v_net_comm_colln_amt THEN
--                    raise_application_error (-20001, 'Geniisys Exception#I#Total Commission Amount + total VAT Amount in the Collection Details should be equal to the total Net Commission Amount.');
--                END IF;    
--                    
--                --validate the checks
--                FOR rec IN (SELECT pay_mode, check_date, check_no, check_class
--                              FROM giac_upload_colln_dtl
--                             WHERE source_cd = guf.source_cd
--                               AND file_no = guf.file_no
--                             ORDER BY item_no)
--                LOOP
--                    IF rec.pay_mode = 'CHK' THEN
--                        IF rec.check_date IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Please enter check date for check no. '||rec.check_no||' in the Collection Details.');
--                        ELSE
--                            IF rec.check_date > guf.nbt_or_date THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Check no. '||rec.check_no||' in the Collection Details is post-dated.');
--                            END IF;

--                            IF rec.check_class = 'M' THEN
--                                v_stale_date := to_date(to_char(add_months(trunc(guf.nbt_or_date), (-1 * v_stale_mgr_chk)), 'MM-DD-YYYY'),'MM-DD-YYYY');
--                            ELSE    
--                                v_stale_date := to_date(to_char(add_months(trunc(guf.nbt_or_date), (-1 * v_stale_check)), 'MM-DD-YYYY'),'MM-DD-YYYY');
--                            END IF;
--                                    
--                            IF trunc(rec.check_date) <=  trunc(v_stale_date) THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Check no. '||rec.check_no||' in the Collection Details is a stale check.');
--                            END IF;
--                        END IF;
--                    END IF;    
--                END LOOP;
--               
--                
--                upload_dpc_web.check_tran_mm(guf.nbt_or_date);
--                upload_dpc_web.check_dcb_user(guf.nbt_or_date, p_user_id);
--                upload_dpc_web.get_dcb_no(guf.nbt_or_date, p_dcb_no);
--                    
--            ELSIF p_dsp_tran_class IN ('DV', 'JV') THEN
--                IF p_dsp_tran_class = 'DV' THEN
--                    FOR gudv IN (SELECT *
--                                   FROM TABLE(GIACS607_PKG.GET_GUDV_DETAILS(guf.source_cd, guf.file_No))  )
--                    LOOP
--                        -- CHECK_PAYMENT_DETAILS prog unit
--                        IF gudv.request_date IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Request date in the Payment Request Details is null.');
--                        ELSIF gudv.gouc_ouc_id IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Department in the Payment Request Details is null.');
--                        ELSIF gudv.document_cd IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Document code in the Payment Request Details is null.');
--                        ELSIF gudv.branch_cd IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the Payment Request Details is null.');
--                        ELSIF gudv.doc_year IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Document year in the Payment Request Details is null.');
--                        ELSIF gudv.doc_mm IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Document month in the Payment Request Details is null.');
--                        ELSIF gudv.payee_class_cd IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Payee class code in the Payment Request Details is null.');
--                        ELSIF gudv.payee_cd IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Payee code in the Payment Request Details is null.');
--                        ELSIF gudv.payee IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Payee in the Payment Request Details is null.');
--                        ELSIF gudv.currency_cd IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Currency code in the Payment Request Details is null.');
--                        ELSIF gudv.currency_rt IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Currency rate in the Payment Request Details is null.');
--                        ELSIF gudv.dv_fcurrency_amt IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
--                        ELSIF gudv.payt_amt IS NULL THEN
--                            raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
--                        ELSIF gudv.particulars    IS NULL THEN                               
--                            raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the Payment Request Details is null.');
--                        END IF;  
--                        
--                        upload_dpc_web.check_tran_mm(gudv.request_date);
--                    END LOOP;
--                    
--                ELSE -- JV
--                    FOR gujv IN (SELECT *
--                                   FROM TABLE(GIACS607_PKG.GET_GUJV_DETAILS(guf.source_cd, guf.file_No))  )
--                    LOOP
--                        -- CHECK_PAYMENT_DETAILS prog unit
--                        IF gujv.tran_date IS NULL THEN 
--                                raise_application_error (-20001, 'Geniisys Exception#E#Transaction date in the JV Details is null.');
--                        ELSIF gujv.branch_cd    IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the JV Details is null.');
--                        ELSIF gujv.tran_year    IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Transaction year in the JV Details is null.');
--                        ELSIF gujv.tran_month IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Transaction month in the JV Details is null.');
--                        ELSIF gujv.jv_pref_suff IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#JV prefix in the JV Details is null.');
--                        ELSIF gujv.particulars IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the JV Details is null.');      
--                        ELSIF gujv.jv_tran_tag IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran tag in the JV Details is null.');      
--                        ELSIF gujv.jv_tran_type IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran type in the JV Details is null.');      
--                        ELSIF gujv.particulars IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the JV Details is null.');      
--                        ELSIF gujv.jv_tran_tag = 'C' THEN
--                            IF gujv.jv_tran_mm IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran month in the JV Details is null.');      
--                            ELSIF gujv.jv_tran_yy IS NULL THEN
--                                raise_application_error (-20001, 'Geniisys Exception#E#JV tran year in the JV Details is null.');      
--                            END IF;
--                        END IF; 
--                        
--                        upload_dpc_web.check_tran_mm(gujv.tran_date);
--                    END LOOP;
--                END IF;
--            END IF;
--        END LOOP;
    END check_payment_before_upload;
    
    
    PROCEDURE check_claim_and_override(
        p_source_cd                 GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no                   GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_user_id                   VARCHAR2,
        p_c_override            OUT VARCHAR2,
        p_access_cc_giacs007    OUT VARCHAR2,
        p_o_override            OUT VARCHAR2,
        p_access_ua_giacs607    OUT VARCHAR2
    )
    AS
    BEGIN
        -- CHECK_FOR_CLAIM
        FOR i IN (SELECT *
                    FROM TABLE(GIACS607_PKG.GET_GUPC_RECORDS(p_source_Cd, p_file_No, null, null, null, null, null, null, null)))
        LOOP
            IF i.prem_chk_flag IN ('WC','PC','FC','OC','CO') THEN
                p_c_override := 'Y';
                EXIT;
            END IF; 
        END LOOP;
        
        p_access_cc_giacs007 := giac_validate_user_fn(p_user_id,'CC','GIACS007');        
        -- end CHECK_FOR_CLAIM
        
        
        -- CHECK_FOR_OVERRIDE
        FOR i IN (SELECT *
                    FROM TABLE(GIACS607_PKG.GET_GUPC_RECORDS(p_source_Cd, p_file_No, null, null, null, null, null, null, null)))
        LOOP
            IF i.prem_chk_flag <> 'OK' OR i.comm_chk_flag <> 'OK' THEN
                p_o_override := 'Y';
                EXIT;
            END IF; 
        END LOOP;
        
        p_access_ua_giacs607 := giac_validate_user_fn(p_user_id,'UA','GIACS607');        
        -- end CHECK_FOR_OVERRIDE
        
    END check_claim_and_override;


    PROCEDURE update_acct_assd_rg(
        p_assd_no         giis_assured.assd_no%TYPE,
        p_pay_rcv_amt     giac_upload_prem_comm.gross_prem_amt%TYPE
    )
    AS
        v_exists    BOOLEAN := FALSE;
    BEGIN
        FOR i IN 1..v_acct_assd_list.COUNT 
        LOOP
            IF v_acct_assd_list(i).assd_no = p_assd_no THEN
                v_acct_assd_list(i).pay_rcv_amt := p_pay_rcv_amt;
                v_exists := TRUE;
            END IF;
        END LOOP;
            
        IF NOT v_exists OR v_acct_assd_list.COUNT = 0 THEN
            v_acct_assd_list.EXTEND;
             v_acct_assd_list(v_acct_assd_list.LAST).assd_no     := p_assd_no;
             v_acct_assd_list(v_acct_assd_list.LAST).pay_rcv_amt := p_pay_rcv_amt;
        END IF;
    END update_acct_assd_rg;   
     
    
    FUNCTION get_or_particulars 
        RETURN VARCHAR2
    AS
        v_particulars                giac_order_of_payts.particulars%TYPE;
        v_or_particulars_text         giac_order_of_payts.particulars%TYPE := giacp.v('OR_PARTICULARS_TEXT');
        v_or_text                    VARCHAR2(1) := giacp.v('OR_TEXT');
        v_policies                    giac_order_of_payts.particulars%TYPE;
        v_policies_full                giac_order_of_payts.particulars%TYPE;
        v_policies_partial            giac_order_of_payts.particulars%TYPE;
        v_or_pol_limit              NUMBER := giacp.n('OR_POL_PARTICULARS_LIMIT');
        v_pol_ctr                    NUMBER := 0;
        v_full_partial_flag         VARCHAR2(1);
        v_pdep_exists                BOOLEAN := FALSE;
    BEGIN
        FOR gdpc_rec IN ( SELECT gdpc.b140_iss_cd iss_cd, gdpc.b140_prem_seq_no prem_seq_no, sum(gdpc.collection_amt) colln_amt, 
                                 rtrim(gpol.line_cd) || '-' || 
                                 rtrim(gpol.subline_cd) || '-' || 
                                 rtrim(gpol.iss_cd) || '-' || 
                                 ltrim(to_char(gpol.issue_yy,'99')) || '-' || 
                                 ltrim(to_char(gpol.pol_seq_no,'0999999')) || 
                                 decode(gpol.endt_seq_no,0,NULL, 
                                 '-' ||gpol.endt_iss_cd||'-'||ltrim(to_char(gpol.endt_yy,'09'))||'-' 
                                 ||ltrim(to_char(gpol.endt_seq_no,'099999')) || ' ' || 
                                 rtrim(gpol.endt_type))||'-'||ltrim(to_char(gpol.renew_no, '09')) policy_no 
                            FROM gipi_polbasic gpol, gipi_invoice ginv, giac_direct_prem_collns gdpc 
                           WHERE 1=1 
                             AND gpol.policy_id = ginv.policy_id
                             AND gdpc.b140_iss_cd = ginv.iss_cd
                             AND gdpc.b140_prem_seq_no = ginv.prem_seq_no
                             AND gdpc.gacc_tran_id = GIACS607_PKG.v_tran_id
                           GROUP BY gpol.line_cd, gpol.subline_cd, gpol.iss_cd, gpol.issue_yy, 
                                 gpol.pol_seq_no, gpol.renew_no, gpol.endt_iss_cd, gpol.endt_yy, 
                                 gpol.endt_seq_no, gpol.endt_type, b140_iss_cd, b140_prem_seq_no)
        LOOP
            v_pol_ctr := v_pol_ctr + 1;

            IF v_pol_ctr > v_or_pol_limit THEN
                EXIT;
            END IF;
                                
            IF nvl(v_or_text,'N') = 'N' THEN
                IF nvl(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PB' THEN
                    v_policies := v_policies||gdpc_rec.policy_no||'/'||gdpc_rec.iss_cd||'-'||ltrim(to_char(gdpc_rec.prem_seq_no,'99999999'))||', ';
                ELSE
                    v_policies := v_policies||gdpc_rec.policy_no||'/';
                END IF;
            ELSE
                v_full_partial_flag := 'F';                

                FOR rec_b IN ( SELECT decode(sum(balance_amt_due), 0, 'F', 'P') full_partial
                                FROM giac_aging_soa_details
                               WHERE iss_cd = gdpc_rec.iss_cd
                                 AND prem_seq_no = gdpc_rec.prem_seq_no
                               GROUP BY iss_cd, prem_seq_no)
                LOOP
                    v_full_partial_flag := rec_b.full_partial;
                    EXIT;
                END LOOP rec_b;    

                IF v_full_partial_flag = 'F' THEN
                    IF nvl(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PB' THEN
                        v_policies_full := v_policies_full||gdpc_rec.policy_no||'/'||gdpc_rec.iss_cd||'-'||ltrim(to_char(gdpc_rec.prem_seq_no,'99999999'))||', ';
                    ELSE
                        v_policies_full := v_policies_full||gdpc_rec.policy_no||'/';
                    END IF;
                ELSE
                    IF nvl(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PB' THEN
                        v_policies_partial := v_policies_partial||gdpc_rec.policy_no||'/'||gdpc_rec.iss_cd||'-'||ltrim(to_char(gdpc_rec.prem_seq_no,'99999999'))||', ';
                    ELSE
                        v_policies_partial := v_policies_partial||gdpc_rec.policy_no||'/';
                    END IF;
                END IF;                    
            END IF;        
        END LOOP gdpc_rec;
                        
        IF v_pol_ctr > v_or_pol_limit THEN
            v_particulars := 'Representing payment of premium and taxes for various policies.';
        ELSIF v_pol_ctr BETWEEN 1 AND v_or_pol_limit THEN
            IF nvl(v_or_text,'N') = 'N' THEN
                v_particulars := substr(v_policies, 1, length(rtrim(v_policies))-1);            
            ELSE            
                IF v_policies_full IS NOT NULL AND v_policies_partial IS NOT NULL THEN
                    v_policies_full := substr(v_policies_full, 1, length(rtrim(v_policies_full))-1);
                    v_policies_partial := substr(v_policies_partial, 1, length(rtrim(v_policies_partial))-1);
                    v_particulars := giacp.v('OR_PARTICULARS_FULL')||' '||v_policies_full||', '
                             ||giacp.v('OR_PARTICULARS_TEXT2')||' '||v_policies_partial;
                ELSIF v_policies_full IS NOT NULL THEN
                    v_policies_full := substr(v_policies_full, 1, length(rtrim(v_policies_full))-1);
                    v_particulars := giacp.v('OR_PARTICULARS_FULL')||' '||v_policies_full;
                ELSIF v_policies_partial IS NOT NULL THEN
                    v_policies_partial := substr(v_policies_partial, 1, length(rtrim(v_policies_partial))-1);
                    v_particulars := giacp.v('OR_PARTICULARS_PARTIAL')||' '||v_policies_partial;
                END IF;
            END IF;
        ELSE --v_pol_ctr=0
            FOR pdep_rec IN    ( SELECT 'x'
                                FROM giac_prem_deposit
                               WHERE gacc_tran_id = GIACS607_PKG.v_tran_id)
            LOOP
                v_pdep_exists := TRUE;
                EXIT;
            END LOOP;        
                            
            IF v_pdep_exists THEN
                v_particulars := 'Premium Deposit';
            ELSE
                v_particulars := 'Accounts Payable';
            END IF;
        END IF;        
                        
        RETURN(v_particulars);
    END get_or_particulars;
    
    
    PROCEDURE gen_misc_op_text (
        p_item_text     giac_op_text.item_text%TYPE,
        p_item_amt        giac_op_text.item_amt%TYPE,
        p_user_id       giac_op_text.USER_ID%TYPE
    )
    AS
        v_seq_no        giac_op_text.item_seq_no%TYPE;
    BEGIN
        BEGIN
            SELECT generation_type
              INTO GIACS607_PKG.v_gen_type
              FROM giac_modules
             WHERE module_name = 'GIACS607';
        EXCEPTION
            WHEN no_data_found THEN
               GIACS607_PKG.v_gen_type := NULL;
        END;
        
        SELECT nvl(max(item_seq_no),0) + 1
          INTO v_seq_no
          FROM giac_op_text
         WHERE gacc_tran_id  = GIACS607_PKG.v_tran_id
           AND item_gen_type = GIACS607_PKG.v_gen_type;

          INSERT INTO giac_op_text
                    (gacc_tran_id, 
                     item_seq_no, 
                     print_seq_no, 
                     item_amt, 
                     item_gen_type, 
                     item_text, 
                     currency_cd, 
                     foreign_curr_amt,
                     user_id, 
                     last_update)
                VALUES
                    (GIACS607_PKG.v_tran_id, 
                     v_seq_no, 
                     v_seq_no, 
                     p_item_amt, 
                     GIACS607_PKG.v_gen_type, 
                     p_item_text, 
                     1, 
                     p_item_amt,
                     p_user_id, 
                     SYSDATE);
    END gen_misc_op_text;
    
    
    PROCEDURE gen_comm_op_text(
        p_user_id       giac_op_text.USER_ID%TYPE
    )
    AS
        CURSOR C IS
            SELECT SUM(((a.comm_amt+a.input_vat_amt-a.wtax_amt) * (-1))) item_amt
                  ,SUM(((a.comm_amt+a.input_vat_amt-a.wtax_amt)/nvl(a.convert_rate,1) * (-1))) foreign_curr_amt
                  ,nvl(a.currency_cd,1) currency_cd
              FROM giac_comm_payts a, gipi_invoice b, gipi_polbasic c
             WHERE a.iss_cd      = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND b.iss_cd      = c.iss_cd
               AND b.policy_id   = c.policy_id
               AND gacc_tran_id  = GIACS607_PKG.v_tran_id
               AND a.print_tag   = 'Y'
               GROUP BY a.currency_cd;

        ws_seq_no              giac_op_text.item_seq_no%TYPE := 1;  
        ws_gen_type            VARCHAR2(1) := 'N';
        v_or_curr_cd           giac_order_of_payts.currency_cd%TYPE;--stores the currency_cd in the O.R.
        v_def_curr_cd                     giac_order_of_payts.currency_cd%TYPE := nvl(giacp.n('CURRENCY_CD'),1);--stores the default currency_cd
        v_currency_cd          giac_direct_prem_collns.currency_cd%TYPE;--stores currency_cd to be inserted
        v_foreign_curr_amt         giac_op_text.foreign_curr_amt%TYPE;--stores the foreign currency amt to be inserted
    BEGIN
         DELETE FROM giac_op_text
          WHERE gacc_tran_id  = GIACS607_PKG.v_tran_id
            AND item_gen_type = ws_gen_type;

        --get the currency_cd in the O.R.
        FOR b1 IN (SELECT currency_cd
                     FROM giac_order_of_payts
                    WHERE gacc_tran_id = GIACS607_PKG.v_tran_id)
        LOOP
            v_or_curr_cd := b1.currency_cd;
            EXIT;
        END LOOP;

        FOR c_rec IN c LOOP               
            --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
            --should also be in the default    currency regardless of what currency_cd is in the invoice
            IF v_or_curr_cd = v_def_curr_cd THEN
                v_foreign_curr_amt := c_rec.item_amt;
                v_currency_cd  := v_def_curr_cd;                
            ELSE
                v_foreign_curr_amt := c_rec.foreign_curr_amt;
                v_currency_cd  := c_rec.currency_cd;                
            END IF;

            INSERT INTO giac_op_text
                    (gacc_tran_id, 
                     item_seq_no, 
                     item_gen_type, 
                     item_text,
                     item_amt, 
                     user_id, 
                     last_update, 
                     print_seq_no, 
                     currency_cd, 
                     foreign_curr_amt)
                VALUES
                    (GIACS607_PKG.v_tran_id, 
                     ws_seq_no, 
                     ws_gen_type, 
                     'COMMISSION',
                     c_rec.item_amt, 
                     p_user_id, 
                     SYSDATE, 
                     ws_seq_no, 
                     v_currency_cd, 
                     v_foreign_curr_amt);

            ws_seq_no := ws_seq_no + 1;
        END LOOP;
    END gen_comm_op_text;
    
    
    PROCEDURE gen_prem_dep_op_text(
        p_user_id       giac_op_text.USER_ID%TYPE
    )AS
        CURSOR c IS
            SELECT sum(collection_amt) item_amt, 
                   sum(foreign_curr_amt) foreign_curr_amt,
                   currency_cd, 
                   b140_iss_cd||'-'||ltrim(to_char(b140_prem_seq_no,'09999999')) bill_no,
                     'Premium Deposit' item_text
              FROM giac_prem_deposit
             WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
             GROUP BY currency_cd, b140_iss_cd, b140_prem_seq_no;

        v_seq_no      giac_op_text.item_seq_no%TYPE := 1;
    BEGIN
        BEGIN
            SELECT generation_type
              INTO GIACS607_PKG.v_gen_type
              FROM giac_modules
             WHERE module_name = 'GIACS026';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               GIACS607_PKG.v_gen_type := NULL;
        END;

        /* Remove first whatever records in giac_op_text. */
        DELETE 
          FROM giac_op_text
         WHERE gacc_tran_id  = GIACS607_PKG.v_tran_id
           AND item_gen_type = GIACS607_PKG.v_gen_type;

        FOR c_rec IN C 
        LOOP
            INSERT INTO giac_op_text
                        (gacc_tran_id,      item_gen_type,      item_seq_no,   item_amt, 
                         user_id,           last_update,        bill_no,       item_text, 
                         print_seq_no,      currency_cd,        foreign_curr_amt)
                 VALUES (GIACS607_PKG.v_tran_id,         GIACS607_PKG.v_gen_type,         v_seq_no,      c_rec.item_amt, 
                         p_user_id,         SYSDATE,            c_rec.bill_no, c_rec.item_text, 
                         v_seq_no,          c_rec.currency_cd , c_rec.foreign_curr_amt);
        END LOOP;
    END gen_prem_dep_op_text;
    
    
    PROCEDURE gen_dpc_op_text_prem (
        p_iss_cd                IN  giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no            IN  giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no                IN  giac_direct_prem_collns.inst_no%TYPE,
        p_premium_amt            IN  NUMBER,
        p_currency_cd             IN  giac_direct_prem_collns.currency_cd%TYPE,
        p_convert_rate             IN  giac_direct_prem_collns.convert_rate%TYPE,
        p_user_id               IN  VARCHAR2,
        p_zero_prem_op_text     IN OUT  VARCHAR2 
    )AS
        v_exist                 VARCHAR2(1);
        n_seq_no                NUMBER(2);
        v_tax_name              VARCHAR2(100);
        v_tax_cd                NUMBER(2);
        v_sub_tax_amt           NUMBER(14,2);
        v_currency_cd           giac_direct_prem_collns.currency_cd%TYPE;
        v_convert_rate          giac_direct_prem_collns.convert_rate%TYPE;    
        v_prem_type             VARCHAR2(1) := 'E';  
        v_prem_text                VARCHAR2(25);
        v_or_curr_cd            giac_order_of_payts.currency_cd%TYPE;
        v_def_curr_cd            giac_order_of_payts.currency_cd%TYPE := nvl(giacp.n('CURRENCY_CD'),1);
            
        --added the ff. variables
        v_inv_tax_amt            gipi_inv_tax.tax_amt%TYPE;
        v_inv_tax_rt            gipi_inv_tax.rate%TYPE;
        v_inv_prem_amt            gipi_invoice.prem_amt%TYPE;
        v_tax_colln_amt            giac_tax_collns.tax_amt%TYPE;
        v_premium_amt            gipi_invoice.prem_amt%TYPE;
        v_exempt_prem_amt        gipi_invoice.prem_amt%TYPE;
        v_init_prem_text        VARCHAR2(25);
        
        v_fund_cd               giac_acct_entries.gacc_gfun_fund_cd%TYPE := giacp.v('FUND_CD');
        v_evat_cd                NUMBER := giacp.n('EVAT');
    BEGIN
        v_premium_amt := p_premium_amt;
        
        BEGIN
            SELECT decode(nvl(c.tax_amt,0), 0, 'Z', 'V') prem_type, 
                   c.tax_amt inv_tax_amt, 
                   c.rate inv_tax_rt, 
                   b.prem_amt inv_prem_amt 
              INTO v_prem_type,
                   v_inv_tax_amt,
                   v_inv_tax_rt,
                   v_inv_prem_amt
              FROM gipi_invoice b,                  
                   gipi_inv_tax c
             WHERE b.iss_cd = c.iss_cd
               AND b.prem_seq_no = c.prem_seq_no
               AND c.tax_cd = v_evat_cd
               AND c.iss_cd = p_iss_cd
               AND c.prem_seq_no = p_prem_seq_no;
        EXCEPTION
            WHEN no_data_found THEN
                 NULL;
        END;
        
        IF v_prem_type = 'V' THEN
            v_prem_text := 'PREMIUM (VATABLE)'; 
            n_seq_no := 1;
            --separate the vatable and vat-exempt premiums for cases where the evat is peril dependent. 
            --Note the 1 peso variance, as per Ms. J. If the difference is <= 1 then all the amt should 
            --be for the vatable premium
            IF abs(v_inv_prem_amt - round(v_inv_tax_amt/v_inv_tax_rt*100,2))*p_convert_rate > 1 THEN
                BEGIN
                    SELECT nvl(tax_amt,0)
                      INTO v_tax_colln_amt
                      FROM giac_tax_collns
                     WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
                         AND b160_iss_cd = p_iss_cd
                         AND b160_prem_seq_no = p_prem_seq_no
                         AND inst_no = p_inst_no
                         AND b160_tax_cd = v_evat_cd;
                EXCEPTION
                    WHEN no_data_found THEN
                         v_tax_colln_amt := 0;
                END;
                    
                IF v_tax_colln_amt <> 0 THEN
                    v_premium_amt := round(v_tax_colln_amt/v_inv_tax_rt*100,2);
                    v_exempt_prem_amt := p_premium_amt - v_premium_amt;
                    
                    IF abs(v_exempt_prem_amt) <= 1 THEN
                        v_premium_amt := p_premium_amt;
                        v_exempt_prem_amt := NULL;
                    END IF;                      
                END IF;    
            END IF;    
        ELSIF v_prem_type = 'Z' THEN    
            v_prem_text := 'PREMIUM (ZERO-RATED)'; 
            n_seq_no := 2;
        ELSE
            v_prem_text := 'PREMIUM (VAT-EXEMPT)'; 
            n_seq_no := 3;
        END IF;
        
        --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
        --should also be in the default    currency regardless of what currency_cd is in the invoice
        FOR b1 IN (SELECT currency_cd
                     FROM giac_order_of_payts
                    WHERE gacc_tran_id = GIACS607_PKG.v_tran_id)
        LOOP
            v_or_curr_cd := b1.currency_cd;
            EXIT;
        END LOOP;
                         
        IF v_or_curr_cd = v_def_curr_cd THEN
            v_convert_rate := 1;
            v_currency_cd  := v_def_curr_cd;
        ELSE
            v_convert_rate := p_convert_rate;
            v_currency_cd  := p_currency_cd;                
        END IF;

        --insert the zero amts for the three types of premium
        IF p_zero_prem_op_text = 'Y' THEN
            FOR rec IN 1..3
            LOOP
                IF rec = 1 THEN
                    v_init_prem_text := 'PREMIUM (VATABLE)'; 
                ELSIF rec = 2 THEN    
                    v_init_prem_text := 'PREMIUM (ZERO-RATED)'; 
                ELSE
                    v_init_prem_text := 'PREMIUM (VAT-EXEMPT)'; 
                END IF;
                
                GIACS607_PKG.gen_dpc_op_text_prem2(rec,0,v_init_prem_text,v_currency_cd,v_convert_rate, p_user_id);         
                p_zero_prem_op_text := 'N';
            END LOOP;
        END IF;
            
        GIACS607_PKG.gen_dpc_op_text_prem2(n_seq_no,v_premium_amt,v_prem_text,v_currency_cd,v_convert_rate, p_user_id); 

        --insert the vat-exempt premium
        IF nvl(v_exempt_prem_amt,0) <> 0 THEN
            v_prem_text := 'PREMIUM (VAT-EXEMPT)'; 
            n_seq_no := 3;
            GIACS607_PKG.gen_dpc_op_text_prem2(n_seq_no,v_exempt_prem_amt,v_prem_text,v_currency_cd,v_convert_rate, p_user_id); 
        END IF;

        BEGIN
            FOR tax IN (SELECT b.b160_tax_cd, c.tax_name, b.tax_amt, a.currency_cd, a.convert_rate
                          FROM giac_direct_prem_collns a, giac_taxes c, giac_tax_collns b
                         WHERE 1=1                                   
                           AND a.gacc_tran_id = b.gacc_tran_id
                           AND a.b140_iss_cd = b.b160_iss_cd
                           AND a.b140_prem_seq_no = b.b160_prem_seq_no
                           AND a.inst_no = b.inst_no
                           AND c.fund_cd = v_fund_cd
                           AND b.b160_tax_cd = c.tax_cd
                           AND b.inst_no = p_inst_no
                           AND b.b160_prem_seq_no = p_prem_seq_no
                           AND b.b160_iss_cd = p_iss_cd
                           AND b.gacc_tran_id = GIACS607_PKG.v_tran_id
                                         )
            LOOP
                v_tax_cd := tax.b160_tax_cd;
                v_tax_name := tax.tax_name;
                v_sub_tax_amt := tax.tax_amt;

                --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
                --should also be in the default    currency regardless of what currency_cd is in the invoice
                IF v_or_curr_cd = v_def_curr_cd THEN
                    v_convert_rate := 1;
                    v_currency_cd  := v_def_curr_cd;
                ELSE
                    v_convert_rate := tax.convert_rate;
                    v_currency_cd  := tax.currency_cd;                
                END IF;
                    
                GIACS607_PKG.gen_dpc_op_text_tax(v_tax_cd, v_tax_name, v_sub_tax_amt, v_currency_cd, v_convert_rate, p_user_id);
            END LOOP;
        END;
    END gen_dpc_op_text_prem;
            
    
    PROCEDURE gen_dpc_op_text_tax(
        p_tax_cd            NUMBER,
        p_tax_name            VARCHAR2,
        p_tax_amt             NUMBER,
        p_currency_cd         NUMBER,
        p_convert_rate         NUMBER,
        p_user_id           VARCHAR2
    )
    AS
        v_exist       VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'X'
              INTO v_exist
              FROM giac_op_text
             WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
               AND item_gen_type = GIACS607_PKG.v_gen_type
               AND substr(item_text, 1, 5) = ltrim(to_char(p_tax_cd,'09'))||'-'||
                                         ltrim(to_char(p_currency_cd,'09'));

            UPDATE giac_op_text
               SET item_amt = nvl(item_amt,0) + nvl(p_tax_amt,0),
                   foreign_curr_amt = nvl(foreign_curr_amt,0) + nvl(p_tax_amt/p_convert_rate,0)
             WHERE gacc_tran_id= GIACS607_PKG.v_tran_id
               AND item_gen_type = GIACS607_PKG.v_gen_type
               AND substr(item_text, 1, 5) = ltrim(to_char(p_tax_cd,'09'))||'-'|| ltrim(to_char(p_currency_cd,'09'));
        EXCEPTION
            WHEN no_data_found THEN
                BEGIN
                    GIACS607_PKG.v_n_seq_no := GIACS607_PKG.v_n_seq_no + 1;
                    
                    INSERT INTO giac_op_text
                        (gacc_tran_id,
                         item_gen_type,
                         item_seq_no, 
                         item_amt,
                         item_text,
                         print_seq_no,
                         currency_cd,
                         user_id,
                         last_update,
                         foreign_curr_amt)
                    VALUES 
                        (GIACS607_PKG.v_tran_id,
                         GIACS607_PKG.v_gen_type,
                         GIACS607_PKG.v_n_seq_no, 
                         p_tax_amt,
                         ltrim(to_char(p_tax_cd,'09'))||'-'||ltrim(to_char(p_currency_cd,'09'))||'-'||p_tax_name,
                         GIACS607_PKG.v_n_seq_no,
                         p_currency_cd,
                         p_user_id,
                         SYSDATE,
                         p_tax_amt/p_convert_rate);
                END;
        END;          
    END gen_dpc_op_text_tax;
    
    
    PROCEDURE gen_dpc_op_text_prem2 ( 
        p_seq_no            NUMBER,
        p_premium_amt        gipi_invoice.prem_amt%TYPE,
        p_prem_text            VARCHAR2,
        p_currency_cd         giac_direct_prem_collns.currency_cd%TYPE,
        p_convert_rate        giac_direct_prem_collns.convert_rate%TYPE,
        p_user_id           VARCHAR2
    )
    AS
        v_exist             VARCHAR2(1);
    BEGIN
        SELECT 'X'
          INTO v_exist
          FROM giac_op_text
         WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
           AND item_gen_type  =  GIACS607_PKG.v_gen_type
           AND item_text = p_prem_text;    

        UPDATE giac_op_text
           SET item_amt= nvl(item_amt,0) + nvl(p_premium_amt,0),
                foreign_curr_amt = nvl(foreign_curr_amt,0) + nvl(p_premium_amt/p_convert_rate,0)
         WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
           AND item_text = p_prem_text
           AND item_gen_type = GIACS607_PKG.v_gen_type; 
    EXCEPTION
        WHEN no_data_found THEN
            INSERT INTO giac_op_text
                (gacc_tran_id,
                 item_gen_type,
                 item_seq_no,
                 item_amt, 
                 item_text,
                 print_seq_no,
                 currency_cd,
                 user_id,
                 last_update,
                 foreign_curr_amt)
            VALUES
                (GIACS607_PKG.v_tran_id,
                 GIACS607_PKG.v_gen_type,
                 p_seq_no,
                 p_premium_amt,
                 p_prem_text,
                 p_seq_no,
                 p_currency_cd,
                 p_user_id,
                 SYSDATE,
                 p_premium_amt/p_convert_rate);           
    END gen_dpc_op_text_prem2;
    
    
    PROCEDURE gen_dpc_op_text(
        p_user_id           VARCHAR2
    )
    AS
        CURSOR c IS
            SELECT a.b140_iss_cd iss_cd,
                   a.b140_prem_seq_no prem_seq_no,
                   a.inst_no, 
                   a.premium_amt,
                   b.currency_cd,
                   b.currency_rt
              FROM gipi_polbasic c, 
                   gipi_invoice b, 
                   giac_direct_prem_collns a 
             WHERE a.b140_iss_cd      = b.iss_cd
               AND a.b140_prem_seq_no = b.prem_seq_no
               AND b.iss_cd           = c.iss_cd
               AND b.policy_id        = c.policy_id
               AND gacc_tran_id       = GIACS607_PKG.v_tran_id;
               
        v_zero_prem_op_text        VARCHAR2(1) := 'N'; 
    BEGIN
        BEGIN
            SELECT generation_type
              INTO GIACS607_PKG.v_gen_type
              FROM giac_modules
             WHERE module_name = 'GIACS007';
        EXCEPTION
            WHEN no_data_found THEN
                GIACS607_PKG.v_gen_type := NULL;
        END;
          
        DELETE giac_op_text
         WHERE gacc_tran_id  = GIACS607_PKG.v_tran_id
           AND item_gen_type = GIACS607_PKG.v_gen_type;

        GIACS607_PKG.v_n_seq_no := 3;
        v_zero_prem_op_text := 'Y';

        FOR c_rec IN c 
        LOOP        
            GIACS607_PKG.gen_dpc_op_text_prem(c_rec.iss_cd, 
                                              c_rec.prem_seq_no,
                                              c_rec.inst_no,
                                              c_rec.premium_amt, 
                                              c_rec.currency_cd, 
                                              c_rec.currency_rt,
                                              p_user_id,
                                              v_zero_prem_op_text);
        END LOOP;

        v_zero_prem_op_text := 'N';    
            
        DELETE giac_op_text
         WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
           AND nvl(item_amt,0) = 0
           AND ltrim(substr(item_text,1,2),'0') IN (SELECT tax_cd
                                                      FROM giac_taxes)
           AND substr(item_text,1,9) <> 'PREMIUM ('
           AND item_gen_type = GIACS607_PKG.v_gen_type;

        /*
        ** update giac_op_text
        ** where item_text = Taxes 
        */
        UPDATE giac_op_text
           SET item_text = substr(item_text, 7, nvl(LENGTH(item_text), 0))
         WHERE gacc_tran_id = GIACS607_PKG.v_tran_id
           AND ltrim(substr(item_text,1,2),'0') IN (SELECT tax_cd
                                                     FROM giac_taxes)
           AND substr(item_text,1,2) NOT IN ('CO', 'PR')
           AND item_gen_type = GIACS607_PKG.v_gen_type;  
    END gen_dpc_op_text;
    
    
    PROCEDURE create_acct_assd_entries (
        p_user_id           VARCHAR2,
        p_pay_rcv_amt OUT   giac_upload_prem_comm.gross_prem_amt%TYPE
    )
    AS
        v_sl_cd                    NUMBER;
        v_aeg_item_no             NUMBER;
        v_dummy_pay_rcv_amt     giac_upload_prem_comm.gross_prem_amt%TYPE;
    BEGIN
        p_pay_rcv_amt := 0;
        
        FOR i IN 1..v_acct_assd_list.COUNT
        LOOP
            v_dummy_pay_rcv_amt := v_acct_assd_list(i).pay_rcv_amt;
            
            IF v_dummy_pay_rcv_amt <> 0 THEN
                v_sl_cd := v_acct_assd_list(i).assd_no;
                
                IF v_dummy_pay_rcv_amt > 0 THEN
                    --accounts payable
                    v_aeg_item_no := 1;
                ELSE
                    --accounts receivable
                    v_aeg_item_no := 11;
                END IF;    
                
                upload_dpc_web.aeg_parameters_misc(GIACS607_PKG.v_tran_id, 'GIACS607', v_aeg_item_no, abs(v_dummy_pay_rcv_amt), v_sl_cd, p_user_id);
                p_pay_rcv_amt := p_pay_rcv_amt + v_dummy_pay_rcv_amt;
            END IF;
        END LOOP;
    END create_acct_assd_entries;
    
        
    PROCEDURE insert_prem_deposit(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_assd_no            giis_assured.assd_no%TYPE,
        p_line_cd              gipi_polbasic.line_cd%TYPE,
        p_subline_cd           gipi_polbasic.subline_cd%TYPE,
        p_iss_cd               gipi_polbasic.iss_cd%TYPE,
        p_issue_yy             gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no             gipi_polbasic.renew_no%TYPE,
        p_endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,                             
        p_endt_yy            gipi_polbasic.endt_yy%TYPE,
        p_endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
        p_prem_dep_amt      giac_prem_deposit.collection_amt%TYPE,
        p_prem_dep_comm_amt giac_prem_deposit.collection_amt%TYPE,
        p_user_id           VARCHAR2    
    )
    AS
        v_tran_type     NUMBER;
        v_item_no        NUMBER;
        v_line_cd       gipi_polbasic.line_cd%TYPE;
        v_subline_cd    gipi_polbasic.subline_cd%TYPE;
        v_iss_cd        gipi_polbasic.iss_cd%TYPE;
        v_issue_yy      gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no      gipi_polbasic.renew_no%TYPE;
        v_assd_no        giis_assured.assd_no%TYPE;
        v_remarks        VARCHAR2(100);    
    BEGIN
        --premium deposit for premiums
        SELECT nvl(max(item_no),0) + 1
          INTO v_item_no
          FROM giac_prem_deposit
         WHERE gacc_tran_id = GIACS607_PKG.v_tran_id;
            
        IF p_prem_dep_amt > 0 THEN
            v_tran_type := 1;
        ELSE
            v_tran_type := 3;
        END IF;    
        
        IF p_policy_id IS NOT NULL THEN
            v_assd_no        := p_assd_no;
            v_line_cd        := p_line_cd;
            v_subline_cd    := p_subline_cd;
            v_iss_cd        := p_iss_cd;    
            v_issue_yy         := p_issue_yy;
            v_pol_seq_no     := p_pol_seq_no;
            v_renew_no        := p_renew_no;
            
            IF p_endt_seq_no <> 0 THEN
                v_remarks := p_endt_iss_cd||'-'||ltrim(to_char(p_endt_yy,'09'))||'-'||ltrim(to_char(p_endt_seq_no,'099999'));
            END IF;     
                        
        ELSE
            FOR rec IN (SELECT policy_id, assd_no, par_id
                          FROM gipi_polbasic
                         WHERE line_cd     = p_line_cd
                           AND subline_cd  = p_subline_cd
                           AND iss_cd      = p_iss_cd
                           AND issue_yy    = p_issue_yy
                           AND pol_seq_no  = p_pol_seq_no
                           AND renew_no    = p_renew_no
                           AND endt_iss_cd = p_endt_iss_cd
                           AND endt_yy     = p_endt_yy
                           AND endt_seq_no = p_endt_seq_no
                           AND p_iss_cd   <> 'RI')                   
            LOOP
                v_assd_no := rec.assd_no;
                
                IF v_assd_no IS NULL THEN
                    FOR rec2 IN (SELECT assd_no
                                   FROM gipi_parlist
                                  WHERE par_id = rec.par_id)
                    LOOP
                        v_assd_no := rec2.assd_no;
                    END LOOP;
                END IF;        
                    
                v_line_cd        := p_line_cd;
                v_subline_cd    := p_subline_cd;
                v_iss_cd        := p_iss_cd;    
                v_issue_yy         := p_issue_yy;
                v_pol_seq_no     := p_pol_seq_no;
                v_renew_no        := p_renew_no;
                
                IF p_endt_seq_no <> 0 THEN
                    v_remarks := p_endt_iss_cd||'-'||ltrim(to_char(p_endt_yy,'09'))||'-'||ltrim(to_char(p_endt_seq_no,'099999'));
                END IF;                 
            END LOOP;                    

            IF v_assd_no IS NULL THEN
                v_remarks := p_line_cd||'-'||p_subline_cd||'-'||p_iss_cd||'-'||ltrim(to_char(p_issue_yy,'99'))
                             ||'-'||ltrim(to_char(p_pol_seq_no,'0999999'))||'-'||ltrim(to_char(p_renew_no, '09'));
                IF p_endt_seq_no <> 0 THEN
                    v_remarks := v_remarks||'/'||p_endt_iss_cd||'-'||ltrim(to_char(p_endt_yy,'09'))
                                 ||'-'||ltrim(to_char(p_endt_seq_no,'099999'));
                END IF;                 
            END IF;
        END IF;
        
        INSERT INTO giac_prem_deposit
                    (gacc_tran_id,                item_no,                            transaction_type,    collection_amt,
                     dep_flag,                    currency_cd,                        convert_rate,        foreign_curr_amt,
                     upload_tag,                colln_dt,                           or_print_tag,       or_tag,  
                     line_cd,                   subline_cd,                         iss_cd,             issue_yy,
                     pol_seq_no,                renew_no,                            assd_no,            remarks,
                     user_id,                   last_update)
             VALUES
                    (GIACS607_PKG.v_tran_id,    v_item_no,                          v_tran_type,        p_prem_dep_amt,
                     1,                         1,                                     1,                  p_prem_dep_amt,
                     'Y',                        trunc(GIACS607_PKG.v_tran_date),    'N',                'N',
                     v_line_cd,                 v_subline_cd,                       v_iss_cd,           v_issue_yy,
                     v_pol_seq_no,              v_renew_no,                            v_assd_no,          v_remarks,
                     p_user_id,                 SYSDATE);
                     
        --premium deposit for commission
        IF p_prem_dep_comm_amt <> 0 THEN
            SELECT nvl(max(item_no),0) + 1
              INTO v_item_no
              FROM giac_prem_deposit
             WHERE gacc_tran_id = GIACS607_PKG.v_tran_id;
            
            IF p_prem_dep_comm_amt > 0 THEN
                v_tran_type := 1;
            ELSE
                v_tran_type := 3;
            END IF;    
            
            INSERT INTO giac_prem_deposit
                        (gacc_tran_id,                item_no,                            transaction_type,    collection_amt,
                         dep_flag,                    currency_cd,                        convert_rate,        foreign_curr_amt,
                         upload_tag,                colln_dt,                            or_print_tag,       or_tag,  
                         line_cd,                   subline_cd,                         iss_cd,             issue_yy,
                         pol_seq_no,                renew_no,                            assd_no,            remarks,
                         user_id,                   last_update)
                VALUES
                        (GIACS607_PKG.v_tran_id,    v_item_no,                          v_tran_type,        p_prem_dep_comm_amt,
                         1,                         1,                                     1,                  p_prem_dep_comm_amt,
                         'Y',                        trunc(GIACS607_PKG.v_tran_date),    'N',                'N',
                         v_line_cd,                 v_subline_cd,                       v_iss_cd,           v_issue_yy,
                         v_pol_seq_no,              v_renew_no,                            v_assd_no,          v_remarks,
                         p_user_id,                 SYSDATE);
        END IF;

    END insert_prem_deposit;
    
    
    FUNCTION get_parent_intm_no(
        p_intm_no               giac_upload_file.INTM_NO%type
    ) RETURN NUMBER
    AS
        v_loop                BOOLEAN := TRUE;
        v_intm_no           NUMBER  := p_intm_no;
        v_parent_intm_no    NUMBER;
        v_lic_tag               VARCHAR2(1);
        v_sl_cd             NUMBER;
    BEGIN
        WHILE v_loop LOOP
            BEGIN
                SELECT a.parent_intm_no, a.lic_tag
                  INTO v_parent_intm_no, v_lic_tag    
                  FROM giis_intermediary a, giis_intm_type b
                 WHERE a.intm_type = b.intm_type
                   AND a.intm_no   = v_intm_no;
                
                --check parent_intm
                IF v_parent_intm_no IS NULL THEN 
                    --chk_the_lic_tag
                    IF v_lic_tag = 'Y' THEN
                        v_sl_cd := v_intm_no;
                        v_loop     := FALSE;
                    ELSE
                        v_sl_cd := v_intm_no;
                        v_loop     := FALSE;
                    END IF;
                ELSE
                    --if not null find parent that is licensed
                    IF v_lic_tag = 'Y' THEN
                        v_sl_cd := v_intm_no;
                        v_loop     := FALSE;
                    ELSE
                        v_intm_no := v_parent_intm_no;
                        v_loop         := TRUE;
                    END IF;
                END IF;
            EXCEPTION
                WHEN no_data_found THEN
                    raise_application_error (-20001, 'Geniisys Exception#I#Intermediary '||to_char(v_intm_no)||' does not exist in table giis_intermediary.');
            END;
        END LOOP;    
        
        v_parent_intm_no := v_sl_cd;
        
        RETURN v_parent_intm_no;
    END get_parent_intm_no;
    
    
    PROCEDURE insert_comm_payts (
        p_policy_id              gipi_polbasic.policy_id%TYPE,
        p_comm_amt              giac_comm_payts.comm_amt%TYPE,
        p_whtax_amt                 giac_comm_payts.wtax_amt%TYPE,
        p_invat_amt                 giac_comm_payts.input_vat_amt%TYPE,    
        p_intm_no               giac_upload_file.INTM_NO%TYPE,
        p_parent_intm_no        giis_intermediary.PARENT_INTM_NO%type,
        p_nbt_tran_class        giac_upload_file.TRAN_CLASS%TYPE,
        p_gross_tag             giac_upload_file.GROSS_TAG%TYPE,
        p_nbt_invat_rt          NUMBER,
        p_comm_tag              VARCHAR2,
        p_user_id               giac_upload_file.USER_ID%type,        
        p_rem_comm_amt      OUT  giac_comm_payts.comm_amt%TYPE,
        p_rem_whtax_amt     OUT  giac_comm_payts.comm_amt%TYPE,
        p_rem_invat_amt     OUT  giac_comm_payts.comm_amt%TYPE
    )
    AS
        v_comm_amt          giac_comm_payts.comm_amt%TYPE;
        v_whtax_amt             giac_comm_payts.wtax_amt%TYPE;
        v_invat_amt             giac_comm_payts.input_vat_amt%TYPE;
        v_tran_type            NUMBER;
        v_record_no            giac_comm_payts.record_no%TYPE;
        v_foreign_curr_amt  giac_comm_payts.foreign_curr_amt%TYPE;
        v_print_tag            giac_comm_payts.print_tag%TYPE;

        v_inv_prem            gipi_invoice.prem_amt%TYPE;
        v_inv_comm            gipi_comm_invoice.commission_amt%TYPE;
        v_inv_whtax            gipi_comm_invoice.wholding_tax%TYPE;

        v_pd_prem            giac_direct_prem_collns.premium_amt%TYPE;
        v_pd_comm            giac_comm_payts.comm_amt%TYPE;
        v_pd_whtax            giac_comm_payts.wtax_amt%TYPE;
        v_pd_invat            giac_comm_payts.input_vat_amt%TYPE;

        v_prem_pct            NUMBER;
        v_def_comm_tag        VARCHAR2(1);
        
        v_comm_due            giac_comm_payts.comm_amt%TYPE;
        v_whtax_due            giac_comm_payts.wtax_amt%TYPE;
        v_invat_due            giac_comm_payts.input_vat_amt%TYPE;
        v_max_invat_due        giac_comm_payts.input_vat_amt%TYPE;
        v_max_whtax_due        giac_comm_payts.wtax_amt%TYPE;
    BEGIN
        --initialize values
        p_rem_comm_amt     := p_comm_amt;
        p_rem_whtax_amt := p_whtax_amt;
        p_rem_invat_amt := p_invat_amt;

        --determine the tran type
        IF p_comm_amt > 0 THEN
            v_tran_type := 1;
        ELSE
            v_tran_type := 3;
        END IF;

        --get the print_tag
        v_print_tag := 'Y';
        IF p_nbt_tran_class = 'COL' THEN
        --IF :guf.nbt_or_tag = 'G'    
            IF p_gross_tag = 'Y' THEN
                v_print_tag := 'N';
            END IF;
        END IF;
        
        --get the bills of the policy where the commission will be distributed
        FOR rec IN (SELECT gi.iss_cd, gi.prem_seq_no, gi.prem_amt,
                            nvl(gcid.commission_amt, gci.commission_amt) comm_amt,
                            nvl(gcid.wholding_tax, gci.wholding_tax) whtax_amt,
                            gi.currency_cd,
                            gi.currency_rt
                      FROM gipi_comm_inv_dtl gcid, 
                           gipi_comm_invoice gci, 
                           gipi_invoice gi,
                           gipi_polbasic gpol
                     WHERE 1=1
                       AND nvl(gcid.commission_amt, gci.commission_amt) <> 0
                       AND gci.iss_cd           = gcid.iss_cd(+)
                       AND gci.prem_seq_no      = gcid.prem_seq_no(+)
                       AND gci.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
                       AND gci.iss_cd           = gi.iss_cd
                       AND gci.prem_seq_no      = gi.prem_seq_no
                       AND gci.intrmdry_intm_no = p_intm_no
                       AND gi.policy_id         = gpol.policy_id
                       AND gpol.policy_id       = p_policy_id
                      ORDER BY 1,2,3)
        LOOP
            v_inv_comm    := rec.comm_amt * rec.currency_rt;
            v_inv_whtax    := rec.whtax_amt * rec.currency_rt;
            v_inv_prem  := rec.prem_amt * rec.currency_rt;

            --check consistency of amounts
            IF sign(p_comm_amt) <> sign(v_inv_comm) THEN
                raise_application_error (20001,'Geniisys Exception#E#Error encountered in program unit: insert_comm_payts. Inconsistent amounts detected.');
            END IF;

            --get the paid premium
            SELECT nvl(sum(a.premium_amt),0)
              INTO v_pd_prem
              FROM giac_acctrans b,
                   giac_direct_prem_collns a
             WHERE NOT EXISTS(SELECT 'x' 
                                FROM giac_reversals cc, giac_acctrans dd 
                               WHERE cc.reversing_tran_id = dd.tran_id 
                                 AND dd.tran_flag <> 'D' 
                                 AND cc.gacc_tran_id = b.tran_id)
               AND b.tran_flag <> 'D'
               AND a.gacc_tran_id   = b.tran_id
               AND a.b140_iss_cd = rec.iss_cd
               AND a.b140_prem_seq_no = rec.prem_seq_no;

            --get the percentage of premium paid
            v_prem_pct := v_pd_prem/v_inv_prem;

            --get the paid comm, whtax, invat
            SELECT nvl(sum(comm_amt),0), nvl(sum(wtax_amt),0), nvl(sum(input_vat_amt),0)
              INTO v_pd_comm, v_pd_whtax, v_pd_invat
              FROM giac_acctrans b,
                   giac_comm_payts a 
             WHERE a.gacc_tran_id = b.tran_id
                 AND b.tran_flag <> 'D'
                 AND NOT EXISTS(SELECT 'x' 
                                  FROM giac_reversals cc, giac_acctrans dd 
                                 WHERE cc.reversing_tran_id = dd.tran_id 
                                   AND dd.tran_flag <> 'D' 
                                   AND cc.gacc_tran_id = b.tran_id)
                 AND a.iss_cd = rec.iss_cd
                 AND a.prem_seq_no = rec.prem_seq_no
                 AND a.intm_no = p_intm_no;

            --get the comm due and check if bill is to be processed
            v_comm_due    := v_inv_comm * v_prem_pct - v_pd_comm;
            
            IF v_comm_due = 0 THEN
                GOTO end_of_loop;
            END IF;    

            v_max_whtax_due    := v_inv_whtax - v_pd_whtax;

            IF v_prem_pct < 1 THEN
                v_whtax_due    := v_comm_due * v_inv_whtax/v_inv_comm;
                --check if v_whtax_due exceeds v_max_whtax_due due to 
                --rounding if there are multiple payments for the comm invoice
                IF v_max_whtax_due <> 0 AND abs(v_whtax_due) > abs(v_max_whtax_due) AND trunc((v_whtax_due/v_max_whtax_due),2) = 1 THEN
                    v_whtax_due := v_max_whtax_due;
                END IF;    
            ELSE
                v_whtax_due := v_max_whtax_due;
            END IF;    
                
            v_invat_due := v_comm_due * NVL(p_nbt_invat_rt,0)/100; --jason 05252009: added NVL
            
            --check if v_invat_due exceeds v_max_invat_due due to 
            --rounding if there are multiple payments for the comm invoice
            IF v_invat_due <> 0 THEN
                v_max_invat_due := v_inv_comm * NVL(p_nbt_invat_rt,0)/100 - v_pd_invat; --jason 05252009: added NVL
                
                IF v_max_invat_due <> 0 AND abs(v_invat_due) > abs(v_max_invat_due) AND trunc((v_invat_due/v_max_invat_due),2) = 1 THEN
                    v_invat_due := v_max_invat_due;
                END IF;
            END IF;    

            --get the amts to be used for the bill        
            IF abs(p_rem_comm_amt) < abs(v_comm_due) THEN
                v_comm_amt     := p_rem_comm_amt;
                v_max_whtax_due := v_whtax_amt;
                v_whtax_amt    := p_rem_comm_amt * v_inv_whtax/v_inv_comm;
                IF v_max_whtax_due <> 0 AND abs(v_whtax_due) > abs(v_max_whtax_due) AND trunc((v_whtax_due/v_max_whtax_due),2) = 1 THEN
                    v_whtax_due := v_max_whtax_due;
                END IF;    
                v_invat_amt    := p_rem_comm_amt * NVL(p_nbt_invat_rt,0)/100; --jason 05252009: added NVL
            ELSE
                v_comm_amt     := v_comm_due;
                v_whtax_amt    := v_whtax_due;
                v_invat_amt    := v_invat_due;
            END IF;                

            v_foreign_curr_amt := v_comm_amt/rec.currency_rt;

            --get def_comm_tag
            v_def_comm_tag := 'Y';
            IF v_tran_type = 1 AND v_prem_pct < 1 THEN
                v_def_comm_tag := 'N';
            END IF;

            --get record_no
            IF p_comm_tag = 'N' THEN
                v_record_no := 0;
            ELSE
                SELECT nvl(MAX(record_no),0) + 1
                  INTO v_record_no
                  FROM giac_comm_payts
                 WHERE gacc_tran_id = GIACS607_PKG.v_tran_id;
            END IF;  

            INSERT INTO giac_comm_payts
                            (gacc_tran_id,          intm_no,         iss_cd,           prem_seq_no,
                             comm_tag,              record_no,       tran_type,        comm_amt, 
                             wtax_amt,              input_vat_amt,   currency_cd,      convert_rate, 
                             foreign_curr_amt,      def_comm_tag,    print_tag,        parent_intm_no, 
                             user_id,               last_update,     record_seq_no)                            
                 VALUES
                        (GIACS607_PKG.v_tran_id,    p_intm_no,        rec.iss_cd,       rec.prem_seq_no,  
                         p_comm_tag,                v_record_no,      v_tran_type,      v_comm_amt,
                         v_whtax_amt,               v_invat_amt,      rec.currency_cd,  rec.currency_rt,
                         v_foreign_curr_amt,        v_def_comm_tag,   v_print_tag,      p_parent_intm_no,
                         p_user_id,                 SYSDATE,          1);                 

            p_rem_comm_amt  := p_rem_comm_amt  - v_comm_amt;
            p_rem_whtax_amt := p_rem_whtax_amt - v_whtax_amt;
            p_rem_invat_amt := p_rem_invat_amt - v_invat_amt;

            IF p_rem_comm_amt = 0 THEN
                EXIT;
            END IF;    

            <<end_of_loop>>
            NULL;
        END LOOP rec;
    END insert_comm_payts;
    
    
    PROCEDURE insert_premium_collns (
        p_policy_id             gipi_polbasic.policy_id%TYPE,
        p_assd_no               giis_assured.assd_no%TYPE,
        p_collection_amt        giac_direct_prem_collns.collection_amt%TYPE,
        p_user_id               VARCHAR2,
        p_rem_colln_amt     OUT giac_direct_prem_collns.collection_amt%TYPE
    )
    AS
        v_colln_amt            NUMBER := 0;
    BEGIN
            p_rem_colln_amt := p_collection_amt;

        --determine the tran type
        IF p_collection_amt > 0 THEN
            GIACS607_PKG.v_transaction_type := 1;
        ELSE 
            GIACS607_PKG.v_transaction_type := 3;
        END IF;
        
        --get the bills of the policy where the collection will be distributed
        FOR rec IN ( SELECT c.iss_cd, 
                             c.prem_seq_no, 
                             c.inst_no, 
                             c.balance_amt_due,
                             c.prem_balance_due,
                             c.tax_balance_due,
                             b.currency_cd,
                             b.currency_rt,
                             --a.booking_mth, --comment by alfie 11-16-2009
                             --a.booking_year,
                             b.multi_booking_mm, --added by alfie 11-16-2009 to be able to generate premium deposit
                             b.multi_booking_yy, --end
                             a.acct_ent_date,
                             a.par_id,
                             a.reg_policy_sw
                        FROM gipi_installment        d,
                             giac_aging_soa_details  c,
                             gipi_invoice            b,
                             gipi_polbasic           a
                       WHERE 1=1
                         AND c.iss_cd           = d.iss_cd
                         AND c.prem_seq_no      = d.prem_seq_no
                         AND c.inst_no          = d.inst_no
                         AND c.balance_amt_due <> 0
                         AND b.iss_cd           = c.iss_cd
                         AND b.prem_seq_no      = c.prem_seq_no
                         AND a.policy_id        = b.policy_id
                         AND a.policy_id        = p_policy_id
                       ORDER BY 1,2,3)
        LOOP
            IF rec.reg_policy_sw <> 'N' OR (rec.reg_policy_sw = 'N' AND nvl(giacp.v('PREM_PAYT_FOR_SPECIAL'),'N') = 'Y') THEN                        
                --check consistency of amounts
                IF sign(rec.balance_amt_due) <> sign(p_collection_amt) THEN
                    raise_application_error (-20001,'Geniisys Exception#E#Error encountered in program unit: insert_premium_collns. ' || 
                                                    'Inconsistent amounts detected.');
                END IF;

                --get the amt to be used for the bill        
                IF abs(p_rem_colln_amt) < abs(rec.balance_amt_due) THEN
                    v_colln_amt := p_rem_colln_amt;
                ELSE
                    v_colln_amt := rec.balance_amt_due;
                END IF;                
        
                --initialize the variables
                GIACS607_PKG.v_iss_cd      := rec.iss_cd;
                GIACS607_PKG.v_prem_seq_no := rec.prem_seq_no;
                GIACS607_PKG.v_inst_no     := rec.inst_no;    
                
                GIACS607_PKG.v_max_collection_amt := rec.balance_amt_due;
                GIACS607_PKG.v_max_premium_amt         := rec.prem_balance_due;
                GIACS607_PKG.v_max_tax_amt                 := rec.tax_balance_due;
        
                GIACS607_PKG.v_collection_amt := v_colln_amt;
                GIACS607_PKG.v_currency_cd    := rec.currency_cd;
                GIACS607_PKG.v_convert_rate   := rec.currency_rt;
                
                --derive the premium and tax amts from the collection amt
                --variables.get_prem_pd_tag := 'N';
                GIACS607_PKG.with_tax_allocation('N', p_user_id);
                
                --if it is an advanced payment, insert record in giac_advanced_payt
                --IF to_date('01-'||rec.booking_mth||'-'||rec.booking_year,'DD-MON-YYYY') > variables.tran_date AND
                IF to_date('01-'||rec.multi_booking_mm||'-'||rec.multi_booking_yy,'DD-MON-YYYY') > GIACS607_PKG.v_tran_date AND
                   rec.acct_ent_date IS NULL THEN
                
                INSERT INTO giac_advanced_payt
                            (gacc_tran_id,           policy_id,          transaction_type,            iss_cd, 
                             prem_seq_no,            inst_no,            premium_amt,                 tax_amt, 
                             booking_mth,            booking_year,       assd_no,                     user_id,
                             last_update)
                     VALUES
                            (GIACS607_PKG.v_tran_id,      p_policy_id,              GIACS607_PKG.v_transaction_type,  GIACS607_PKG.v_iss_cd, 
                             GIACS607_PKG.v_prem_seq_no,  GIACS607_PKG.v_inst_no,  GIACS607_PKG.v_premium_amt,       GIACS607_PKG.v_tax_amt, 
                             /*rec.booking_mth */rec.multi_booking_mm, /*rec.booking_year*/ rec.multi_booking_yy,   p_assd_no,  p_user_id, --modified the by alfie, use multi_booking_mm and multi_booking_yy 11162009
                             SYSDATE);
                END IF;   
        
                INSERT INTO giac_direct_prem_collns
                            (gacc_tran_id,            transaction_type,            b140_iss_cd,             b140_prem_seq_no,
                             inst_no,                         collection_amt,              premium_amt,             tax_amt,
                             or_print_tag,       currency_cd,                 convert_rate,            foreign_curr_amt,
                             user_id,            last_update)
                     VALUES
                            (GIACS607_PKG.v_tran_id,  GIACS607_PKG.v_transaction_type,  GIACS607_PKG.v_iss_cd,        GIACS607_PKG.v_prem_seq_no,  
                             GIACS607_PKG.v_inst_no,  GIACS607_PKG.v_collection_amt,    GIACS607_PKG.v_premium_amt,   GIACS607_PKG.v_tax_amt, 
                             'N',                GIACS607_PKG.v_currency_cd,       GIACS607_PKG.v_convert_rate,  GIACS607_PKG.v_foreign_curr_amt,
                             p_user_id,               SYSDATE);
                    
                p_rem_colln_amt := p_rem_colln_amt - v_colln_amt;
            END IF; --rec.reg_policy_sw <> 'N'...

            --exit if the collection amt has been fully distributed
            IF p_rem_colln_amt = 0 THEN            
                EXIT;
            END IF;    
        END LOOP;
    END insert_premium_collns;
    
    
    PROCEDURE process_payments (
        p_source_cd                 GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no                   GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_payor                        giac_order_of_payts.payor%TYPE,
        p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
        p_sl_type_cd1               giac_parameters.param_name%TYPE,
        p_sl_type_cd2               giac_parameters.param_name%TYPE,
        p_sl_type_cd3               giac_parameters.param_name%TYPE,
        p_user_id                   giac_op_text.USER_ID%TYPE
    )
    AS        
        v_line_cd                  gipi_polbasic.line_cd%TYPE;
        v_subline_cd               gipi_polbasic.subline_cd%TYPE;
        v_iss_cd                   gipi_polbasic.iss_cd%TYPE;
        v_issue_yy                 gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no               gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no                 gipi_polbasic.renew_no%TYPE;
        v_endt_iss_cd            gipi_polbasic.endt_iss_cd%TYPE;                             
        v_endt_yy                gipi_polbasic.endt_yy%TYPE;
        v_endt_seq_no            gipi_polbasic.endt_seq_no%TYPE;
        v_payor                    giac_order_of_payts.payor%TYPE;    
        v_gross_prem_amt        giac_upload_prem_comm.gross_prem_amt%TYPE;
        v_comm_amt                giac_upload_prem_comm.comm_amt%TYPE;
        v_whtax_amt                giac_upload_prem_comm.whtax_amt%TYPE;
        v_invat_amt                giac_upload_prem_comm.input_vat_amt%TYPE;
        v_net_amt_due            giac_upload_prem_comm.net_amt_due%TYPE;
        v_gross_tag                giac_upload_prem_comm.gross_tag%TYPE;
        v_gprem_amt_due            giac_upload_prem_comm.gprem_amt_due%TYPE;
        v_comm_amt_due            giac_upload_prem_comm.comm_amt_due%TYPE;
        v_prem_chk_flag            giac_upload_prem_comm.prem_chk_flag%TYPE;
        v_comm_chk_flag            giac_upload_prem_comm.comm_chk_flag%TYPE;
        v_policy_id                gipi_polbasic.policy_id%TYPE;
        v_assd_no                giis_assured.assd_no%TYPE;

        --others, premium
        v_prem_dep_amt            giac_upload_prem_comm.gross_prem_amt%TYPE;
        v_prem_dep_amt_comm     giac_upload_prem_comm.gross_prem_amt%TYPE;
        v_prem_dep_comm_tot     giac_upload_prem_comm.gross_prem_amt%TYPE := 0;
        v_rem_gprem_amt          giac_upload_prem_comm.gross_prem_amt%TYPE;
        v_rem_comm_amt          giac_comm_payts.comm_amt%TYPE;
        v_rem_whtax_amt             giac_comm_payts.wtax_amt%TYPE;
        v_rem_invat_amt             giac_comm_payts.input_vat_amt%TYPE;


        --misc acct entries
        v_acct_payable_min      NUMBER := giacp.n('ACCTS_PAYABLE_MIN');
        v_premcol_exp_max       NUMBER := giacp.n('PREMCOL_EXP_MAX');
        v_commpayt_exp_max      NUMBER := giacp.n('COMMPAYT_EXP_MAX');
        v_aeg_item_no           giac_module_entries.item_no%TYPE;
        v_sl_cd                    giac_acct_entries.sl_cd%TYPE;
        v_pay_rcv_assd_amt      giac_upload_prem_comm.gross_prem_amt%TYPE := 0;
        v_dummy_exp_inc_amt     giac_upload_prem_comm.gross_prem_amt%TYPE;
        v_other_income_amt      giac_upload_prem_comm.gross_prem_amt%TYPE := 0;
        v_other_expense_amt     giac_upload_prem_comm.gross_prem_amt%TYPE := 0;
        v_other_exp_inc_amt     giac_upload_prem_comm.gross_prem_amt%TYPE := 0;
        v_other_exp_inc_tot     giac_upload_prem_comm.gross_prem_amt%TYPE := 0;
        v_pay_rcv_intm_amt      giac_upload_prem_comm.comm_amt%TYPE := 0;
        v_other_exp_comm_amt    giac_upload_prem_comm.comm_amt%TYPE := 0;
            
        --variables used for update of giac_order_of_payts
        v_policy_ctr             NUMBER := 0;
        v_address1                giac_order_of_payts.address_1%TYPE;
        v_address2                giac_order_of_payts.address_2%TYPE;
        v_address3                giac_order_of_payts.address_3%TYPE;
        v_tin                    giac_order_of_payts.tin%TYPE;
        v_particulars           giac_order_of_payts.particulars%TYPE;
            
        v_payment_flag          NUMBER := 0; --reymon 02072012
        
        v_parent_intm_no        giis_intermediary.parent_intm_no%TYPE;
    BEGIN
        FOR guf IN (SELECT *
                      FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))
        LOOP            
            v_parent_intm_no := GIACS607_PKG.GET_PARENT_INTM_NO(guf.intm_no);
        
            FOR gupc IN (SELECT *
                           FROM TABLE(GIACS607_PKG.GET_GUPC_RECORDS(guf.source_Cd, guf.file_No, null, null, null, null, null, null, null)))
            LOOP
                v_payor     := gupc.payor;
                v_gross_tag := gupc.gross_tag;
                  --check the payor
                IF p_payor IS NULL
                     OR (p_payor IS NOT NULL AND v_payor = p_payor AND v_gross_tag = p_gross_tag AND NVL (giacp.v ('NET_ENDT_PAYT'), 'N') = 'N')
                     OR (NVL (giacp.v ('NET_ENDT_PAYT'), 'N') = 'Y' AND v_gross_tag = p_gross_tag) THEN
                     --initialize variables
                    v_prem_dep_amt := 0;
                    v_prem_dep_amt_comm := 0;
                     
                    --transfer values in record group to the variables                     
                    v_line_cd           := gupc.line_cd;
                    v_subline_cd        := gupc.subline_cd;
                    v_iss_cd            := gupc.iss_cd;
                    v_issue_yy          := gupc.issue_yy;
                    v_pol_seq_no        := gupc.pol_seq_no;
                    v_renew_no          := gupc.renew_no;
                    v_endt_iss_cd       := gupc.endt_iss_cd;
                    v_endt_yy           := gupc.endt_yy;
                    v_endt_seq_no       := gupc.endt_seq_no;
                    v_gross_prem_amt    := gupc.gross_prem_amt;
                    v_comm_amt          := gupc.comm_amt;
                    v_whtax_amt         := gupc.whtax_amt;
                    v_invat_amt         := gupc.input_vat_amt;
                    v_net_amt_due       := gupc.net_amt_due;
                    v_gprem_amt_due     := gupc.gprem_amt_due;
                    v_comm_amt_due      := gupc.comm_amt_due;
                    v_prem_chk_flag     := gupc.prem_chk_flag;
                    v_comm_chk_flag     := gupc.comm_chk_flag;
                    v_policy_id         := gupc.nbt_policy_id;
                    v_assd_no           := gupc.nbt_assd_no;
                    
                    IF NVL (giacp.v ('NET_ENDT_PAYT'), 'N') = 'Y' AND v_gross_tag = p_gross_tag THEN
                        v_payment_flag := 0;
                        FOR pol IN (SELECT (SELECT payor
                                              FROM giac_upload_prem_comm a
                                             WHERE a.source_cd = guf.source_cd
                                               AND a.file_no = guf.file_no
                                               AND b.line_cd = a.line_cd
                                               AND b.subline_cd = a.subline_cd
                                               AND b.iss_cd = a.iss_cd
                                               AND b.issue_yy = a.issue_yy
                                               AND b.pol_seq_no = a.pol_seq_no
                                               AND b.renew_no = a.renew_no
                                               AND b.endt_iss_cd = a.endt_iss_cd
                                               AND b.endt_yy = a.endt_yy
                                               AND b.endt_seq_no = a.endt_seq_no
                                               ) payor,
                                           b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no,
                                           b.gross_tag, b.currency_cd, b.convert_rate, b.endt_iss_cd, b.endt_yy, b.endt_seq_no
                                      FROM (SELECT DISTINCT x.line_cd, x.subline_cd, x.iss_cd, x.issue_yy, x.pol_seq_no,
                                                   x.renew_no, x.gross_tag, x.currency_cd, x.convert_rate, 
                                                   x.endt_iss_cd, x.endt_yy, x.endt_seq_no
                                              FROM giac_upload_prem_comm x
                                             WHERE x.source_cd = guf.source_cd
                                               AND x.file_no = guf.file_no) b)
                        LOOP
                           IF  p_payor = pol.payor 
                                AND p_gross_tag = pol.gross_tag AND gupc.line_cd = pol.line_cd
                                AND v_subline_cd = pol.subline_cd AND v_iss_cd = pol.iss_cd
                                AND v_issue_yy = pol.issue_yy AND v_pol_seq_no = pol.pol_seq_no
                                AND v_renew_no = pol.renew_no AND v_endt_iss_cd = pol.endt_iss_cd
                                AND v_endt_yy = pol.endt_yy  AND v_endt_seq_no = pol.endt_seq_no THEN
                              v_payment_flag := 1;
                              EXIT;
                           END IF;
                        END LOOP;
                    ELSE
                        v_payment_flag := 1;
                    END IF; 

                    --*PREMIUM*--
                    --determine where the payment should be applied: prem_deposit or prem_colln
                    
                    IF v_payment_flag = 1 THEN                                                                                                                                                    --reymon 02072012
                        IF v_prem_chk_flag IN ('SP', 'RI', 'EX', 'NA', 'IP') THEN                                                                                                                 --premium deposit
                           v_prem_dep_amt := v_gross_prem_amt;
                        ELSE                                                                                                                                                                    --premium collection
                            IF v_gprem_amt_due < 0 AND v_gross_prem_amt > 0 AND v_prem_chk_flag IN ('OP', 'OC') THEN                                                           --positive(excel) on negative(system)
                                IF v_gross_prem_amt >= v_acct_payable_min THEN
                                    --accounts payable
                                    GIACS607_PKG.update_acct_assd_rg (v_assd_no, v_gross_prem_amt);
                                ELSE
                                    --other income
                                    v_other_income_amt := v_other_income_amt + v_gross_prem_amt;
                                END IF;
                            ELSIF v_prem_chk_flag IN ('OK', 'WC', 'PT', 'PC', 'OP', 'OC', 'ON', 'CO') THEN
                                v_dummy_exp_inc_amt := 0;

                                --if partial payt and the diff is <= v_premcol_exp_max then pay the full amt and generate other expense/income
                                IF v_prem_chk_flag IN ('PT', 'PC') AND (ABS (v_gprem_amt_due - v_gross_prem_amt) <= v_premcol_exp_max) THEN
                                    v_dummy_exp_inc_amt := v_gprem_amt_due - v_gross_prem_amt;

                                    IF v_gross_prem_amt > 0 THEN
                                        --other expense
                                        v_other_expense_amt := v_other_expense_amt + v_dummy_exp_inc_amt;
                                    ELSE
                                        --other income
                                        v_other_income_amt := v_other_income_amt + ABS (v_dummy_exp_inc_amt);
                                    END IF;
                                END IF;
                                
                                --insert the payment for the bills of the policy in giac_direct_prem_collns
                                GIACS607_PKG.insert_premium_collns (v_policy_id, v_assd_no, v_gross_prem_amt + v_dummy_exp_inc_amt, p_user_id, v_rem_gprem_amt);

                                --determine the acct entry to be generated for the remaining amount
                                IF v_prem_chk_flag IN ('OP', 'OC') THEN
                                    IF v_rem_gprem_amt >= v_acct_payable_min THEN
                                        --accounts payable
                                        GIACS607_PKG.update_acct_assd_rg (v_assd_no, v_rem_gprem_amt);
                                    ELSE
                                        --other income
                                        v_other_income_amt := v_other_income_amt + v_rem_gprem_amt;
                                    END IF;
                                ELSIF v_prem_chk_flag IN ('ON', 'CO') THEN
                                    IF ABS (v_rem_gprem_amt) > v_premcol_exp_max THEN
                                        --accounts receivable
                                        GIACS607_PKG.update_acct_assd_rg (v_assd_no, v_rem_gprem_amt);
                                    ELSE
                                        --other expense
                                        v_other_expense_amt := v_other_expense_amt + ABS (v_rem_gprem_amt);
                                    END IF;
                                END IF;
                            ELSIF v_prem_chk_flag IN ('FP', 'FC', 'CP', 'SL', 'NP') THEN
                                GIACS607_PKG.update_acct_assd_rg (v_assd_no, v_gross_prem_amt);
                            END IF;                                                                                                                                --v_gprem_amt_due < 0 AND v_gross_prem_amt > 0 ...

                            --get the address and tin to use in update of giac_order_of_payts (for individual ORs only)
                            v_policy_ctr := v_policy_ctr + 1;

                            IF p_nbt_tran_class = 'COL' AND guf.nbt_or_tag = 'I' AND v_policy_ctr = 1 THEN
                                FOR addr_rec IN (SELECT address1, address2, address3
                                                   FROM gipi_polbasic
                                                  WHERE address1 IS NOT NULL 
                                                    AND policy_id = v_policy_id)
                                LOOP
                                    v_address1 := addr_rec.address1;
                                    v_address2 := addr_rec.address2;
                                    v_address3 := addr_rec.address3;
                                END LOOP addr_rec;

                                FOR tin_rec IN (SELECT assd_tin
                                                  FROM giis_assured
                                                 WHERE assd_no = v_assd_no)
                                LOOP
                                    v_tin := tin_rec.assd_tin;
                                END LOOP;
                            END IF;                                                                                                                                                  --:guf.dsp_tran_class = 'COL'...
                        END IF;                                                                                                                                      --v_prem_chk_flag IN ('SP','RI','EX','NA','IP')

                        --*COMMISSION*--
                        IF v_comm_chk_flag <> 'ZC' THEN                                                                                                                                            --v_comm_amt <> 0
                           IF v_comm_chk_flag IN ('SP', 'RI', 'EX', 'NA', 'IP') THEN                                                                                                              --premium deposit
                              v_prem_dep_amt_comm := v_comm_amt - v_whtax_amt + v_invat_amt;
                              v_prem_dep_comm_tot := v_prem_dep_comm_tot + v_prem_dep_amt_comm;
                           ELSE                                                                                                                                                                         --comm payts
                              IF v_comm_amt_due < 0 AND v_comm_amt > 0 AND v_comm_chk_flag = 'OP' THEN                                                                        --positive(excel) on negative(system)
                                 IF v_comm_amt > v_commpayt_exp_max THEN
                                    --accounts receivable intm
                                    v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + (v_comm_amt - v_whtax_amt + v_invat_amt);
                                 ELSE
                                    --other expense comm
                                    v_other_exp_comm_amt := v_other_exp_comm_amt + (v_comm_amt - v_whtax_amt + v_invat_amt);
                                 END IF;
                              ELSIF v_comm_chk_flag IN ('OK', 'PT', 'OP', 'ON', 'WW', 'WV', 'WT') THEN
                                 GIACS607_PKG.insert_comm_payts (v_policy_id, v_comm_amt, v_whtax_amt, v_invat_amt, 
                                                                 guf.intm_no, v_parent_intm_no, p_nbt_tran_class, guf.gross_tag,
                                                                 guf.nbt_input_vat_rate, 'N', p_user_id,
                                                                 v_rem_comm_amt, v_rem_whtax_amt, v_rem_invat_amt);

                                 IF v_comm_chk_flag = 'OP' THEN
                                    IF v_rem_comm_amt > v_commpayt_exp_max THEN
                                       --accounts receivable intm
                                       v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_comm_amt;
                                    ELSE
                                       --other expense comm
                                       v_other_exp_comm_amt := v_other_exp_comm_amt + v_rem_comm_amt;
                                    END IF;
                                 ELSIF v_comm_chk_flag = 'ON' THEN
                                    --accounts payable intm
                                    v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_comm_amt;
                                 END IF;

                                 IF v_rem_whtax_amt > 0 THEN
                                    --accounts payable intm
                                    v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_whtax_amt * -1;
                                 ELSIF v_rem_whtax_amt < 0 THEN
                                    --accounts receivable intm
                                    v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + ABS (v_rem_whtax_amt);
                                 END IF;

                                 IF v_rem_invat_amt > 0 THEN
                                    --accounts receivable intm
                                    v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_invat_amt;
                                 ELSIF v_rem_invat_amt < 0 THEN
                                    --accounts payable intm
                                    v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_invat_amt;
                                 END IF;
                              ELSIF v_comm_chk_flag IN ('NC', 'FP', 'CP', 'SL', 'NP') THEN
                                 v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + (v_comm_amt - v_whtax_amt + v_invat_amt);
                              END IF;                                                                                                                                        --v_comm_amt_due < 0 AND v_comm_amt > 0
                           END IF;                                                                                                                                   --v_comm_chk_flag IN ('SP','RI','EX','NA','IP')
                        END IF;                                                                                                                                                            --v_comm_chk_flag <> 'ZC'

                        --*PREMIUM DEPOSIT (premium and commission)*--
                        IF v_prem_dep_amt <> 0 THEN
                            GIACS607_PKG.insert_prem_deposit (v_policy_id,
                                                                v_assd_no,
                                                                v_line_cd,
                                                                v_subline_cd,
                                                                v_iss_cd,
                                                                v_issue_yy,
                                                                v_pol_seq_no,
                                                                v_renew_no,
                                                                v_endt_iss_cd,
                                                                v_endt_yy,
                                                                v_endt_seq_no,
                                                                v_prem_dep_amt,
                                                                v_prem_dep_amt_comm * -1,
                                                                p_user_id
                                                               );
                                NULL;
                        END IF;
                    END IF;                                                                                                                                                                       --reymon 02072012
                END IF;
            END LOOP gupc;
            
               --*Premiums*--
            --generate the acct entries for the premium collns
            upload_dpc_web.gen_dpc_acct_entries (GIACS607_PKG.v_tran_id, 'GIACS007', p_user_id);

            --generate the op_text for the premium collns
            IF p_nbt_tran_class = 'COL' THEN
                GIACS607_PKG.gen_dpc_op_text(p_user_id);
            END IF;

            --generate the acct entries for the accounts payable/accounts receivable from the premium collns
            GIACS607_PKG.create_acct_assd_entries (p_user_id, v_pay_rcv_assd_amt);

            --generate the op_text for the accounts payable/accounts receivable
            IF p_nbt_tran_class = 'COL' THEN
                IF v_pay_rcv_assd_amt > 0 THEN
                    GIACS607_PKG.gen_misc_op_text ('ACCOUNTS PAYABLE - ASSURED', v_pay_rcv_assd_amt, p_user_id);
                ELSIF v_pay_rcv_assd_amt < 0 THEN
                    GIACS607_PKG.gen_misc_op_text ('ACCOUNTS RECEIVABLE - ASSURED', v_pay_rcv_assd_amt, p_user_id);
                END IF;
            END IF;

            --get the value for other income/expense
            v_other_exp_inc_amt := v_other_income_amt - v_other_expense_amt;                                                                                                                        --for op_text
            v_other_exp_inc_tot := v_other_income_amt - v_other_expense_amt - v_other_exp_comm_amt;                                                                                            --for acct_entries
            --*Commission*--
            --generate the acct entries for the commission
            upload_dpc_web.aeg_parameters_comm (GIACS607_PKG.v_tran_id, 'GIACS020', p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3, p_user_id);

            --generate the acct entries for the accounts payable/accounts receivable for the intermediary
            IF v_pay_rcv_intm_amt <> 0 THEN
                v_sl_cd := guf.intm_no;

                IF v_pay_rcv_intm_amt > 0 THEN
                    --accounts receivable intm
                    v_aeg_item_no := 22;
                ELSE
                    --accounts payable intm
                    v_aeg_item_no := 32;
                END IF;

                upload_dpc_web.aeg_parameters_misc (GIACS607_PKG.v_tran_id, 'GIACS607', v_aeg_item_no, ABS (v_pay_rcv_intm_amt), v_sl_cd, p_user_id);
            END IF;

            IF p_nbt_tran_class = 'COL' THEN
                IF (guf.nbt_or_tag = 'G' AND guf.gross_tag = 'N') OR (guf.nbt_or_tag = 'I' AND p_gross_tag = 'N') THEN
                    --generate the op_text for the commission
                    GIACS607_PKG.gen_comm_op_text(p_user_id);

                    --generate the op_text for the accounts payable/accounts receivable - intm
                    IF v_pay_rcv_intm_amt > 0 THEN
                        GIACS607_PKG.gen_misc_op_text ('ACCOUNTS RECEIVABLE - INTERMEDIARIES', v_pay_rcv_intm_amt * -1, p_user_id);
                    ELSIF v_pay_rcv_intm_amt < 0 THEN
                        GIACS607_PKG.gen_misc_op_text ('ACCOUNTS PAYABLE - INTERMEDIARIES', v_pay_rcv_intm_amt * -1, p_user_id);
                    END IF;

                    --update value for other income/expense
                    v_other_exp_inc_amt := v_other_exp_inc_amt - v_other_exp_comm_amt;                                                                                                                --for op_text
                END IF;
            END IF;

            --*Premium and Commission*--
            --generate the acct entries for other expense/income from the premium collns and commission
            IF v_other_exp_inc_tot <> 0 THEN
                IF v_other_exp_inc_tot > 0 THEN
                    v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                    v_aeg_item_no := 2;
                ELSE
                    v_sl_cd := giacp.n ('OTHER_EXPENSE_SL');
                    v_aeg_item_no := 12;
                END IF;

                upload_dpc_web.aeg_parameters_misc (GIACS607_PKG.v_tran_id, 'GIACS607', v_aeg_item_no, ABS (v_other_exp_inc_tot), v_sl_cd, p_user_id);
            END IF;

            --generate the op_text for other expense/income from the premium collns and commission
            IF p_nbt_tran_class = 'COL' THEN
                IF v_other_exp_inc_amt > 0 THEN
                    GIACS607_PKG.gen_misc_op_text ('OTHER INCOME', v_other_exp_inc_amt, p_user_id);
                ELSIF v_other_exp_inc_amt < 0 THEN
                    GIACS607_PKG.gen_misc_op_text ('OTHER EXPENSE', v_other_exp_inc_amt, p_user_id);
                END IF;
            END IF;

            --*Premium Deposit*--
            --generate the acct entries and op_text for premium deposit
            upload_dpc_web.aeg_parameters_pdep (GIACS607_PKG.v_tran_id, 'GIACS026', p_user_id);

            IF p_nbt_tran_class = 'COL' THEN
                GIACS607_PKG.gen_prem_dep_op_text(p_user_id);

                IF (guf.nbt_or_tag = 'G' AND guf.gross_tag = 'Y') OR (guf.nbt_or_tag = 'I' AND p_gross_tag = 'Y') THEN
                    UPDATE giac_op_text
                       SET foreign_curr_amt = foreign_curr_amt + v_prem_dep_comm_tot,
                           item_amt = item_amt + v_prem_dep_comm_tot
                     WHERE gacc_tran_id = GIACS607_PKG.v_tran_id 
                       AND item_gen_type = GIACS607_PKG.v_gen_type;
                END IF;
            END IF;

            --update giac_order_of_payts (individual ORs only)
            IF p_nbt_tran_class = 'COL' AND guf.nbt_or_tag = 'I' THEN
                v_particulars := GIACS607_PKG.get_or_particulars;

                UPDATE giac_order_of_payts
                   SET address_1 = v_address1,
                       address_2 = v_address2,
                       address_3 = v_address3,
                       tin = v_tin,
                       particulars = v_particulars
                WHERE gacc_tran_id = GIACS607_PKG.v_tran_id;
            END IF;
        END LOOP guf;
    END process_payments;
    
    
    PROCEDURE gen_group_or(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_dcb_no            GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE
    )
    AS
        --acctrans
        v_tran_flag     giac_acctrans.tran_flag%TYPE;
        v_tran_year     giac_acctrans.tran_year%TYPE;
        v_tran_month    giac_acctrans.tran_month%TYPE; 
        v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
        v_tran_class      giac_acctrans.tran_class%TYPE;  
        v_tran_class_no giac_acctrans.tran_class_no%TYPE;  

        --order of payts
        v_cashier_cd    giac_order_of_payts.cashier_cd%TYPE;
        v_address1        giac_order_of_payts.address_1%TYPE;
        v_address2        giac_order_of_payts.address_2%TYPE;
        v_address3        giac_order_of_payts.address_3%TYPE;
        v_tin            giac_order_of_payts.tin%TYPE;
        v_particulars    giac_order_of_payts.particulars%TYPE;
        v_or_colln_amt  giac_order_of_payts.collection_amt%TYPE;
        v_or_gross_amt  giac_order_of_payts.collection_amt%TYPE;

        --collection dtl
        v_currency_cd    giac_collection_dtl.currency_cd%TYPE;
        v_currency_rt    giac_collection_dtl.currency_rt%TYPE;      
        
    BEGIN
        --*insert in giac_acctrans*--
        SELECT acctran_tran_id_s.NEXTVAL
          INTO GIACS607_PKG.v_tran_id
          FROM sys.dual;
        
        FOR guf IN (SELECT *
                      FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))
        LOOP          
            GIACS607_PKG.v_tran_date := to_date(to_char(guf.nbt_or_date, 'MM-DD-YYYY')||' '||to_char(SYSDATE,'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
            
            v_tran_flag   := 'O';
            v_tran_year   := to_number(to_char(guf.nbt_or_date,'YYYY'));
            v_tran_month  := to_number(to_char(guf.nbt_or_date,'MM'));
            
            v_tran_seq_no := giac_sequence_generation(p_fund_cd, p_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
            v_tran_class      := 'COL';
            v_tran_class_no := p_dcb_no;

            INSERT INTO giac_acctrans
                        (tran_id,                   gfun_fund_cd,       gibr_branch_cd, 
                         tran_date,                 tran_flag,          tran_year, 
                         tran_month,                tran_seq_no,        tran_class, 
                         tran_class_no,             user_id,            last_update)
                 VALUES
                        (GIACS607_PKG.v_tran_id,    p_fund_cd,          p_branch_cd, 
                         GIACS607_PKG.v_tran_date,  v_tran_flag,        v_tran_year,
                         v_tran_month,              v_tran_seq_no,        v_tran_class,       
                         v_tran_class_no,           p_user_id,             SYSDATE);


            --*insert in giac_order_of_payts*--
            v_currency_cd := 1; 
            v_currency_rt := 1; 
            v_particulars := 'Representing payment of premium and taxes for various policies.';
            
                    --get the cashier_cd
            FOR a IN (SELECT cashier_cd
                        FROM giac_dcb_users
                       WHERE dcb_user_id    = p_user_id
                         AND gibr_fund_cd   = p_fund_cd 
                         AND gibr_branch_cd = p_branch_cd)
            LOOP
                v_cashier_cd := a.cashier_cd;
                EXIT;
            END LOOP;    
            
            --get the address and tin
            BEGIN
                SELECT mail_addr1, mail_addr2, mail_addr3, tin
                  INTO v_address1, v_address2, v_address3, v_tin
                  FROM giis_intermediary
                 WHERE intm_no = guf.intm_no; 
            EXCEPTION
                WHEN no_data_found THEN
                    raise_application_error (-20001,'Geniisys Exception#E#Intermediary does not exist in table giis_intermediary.');
            END;        

            --get the amounts
            SELECT nvl(sum(net_amt_due),0), nvl(sum(gross_prem_amt),0)
              INTO v_or_colln_amt, v_or_gross_amt
              FROM giac_upload_prem_comm
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no;

            INSERT INTO giac_order_of_payts
                        (gacc_tran_id,         gibr_gfun_fund_cd,   gibr_branch_cd,         payor, 
                         or_date,              cashier_cd,          dcb_no,                 or_flag, 
                         intm_no,              address_1,           address_2,              address_3,
                         tin,                  particulars,         collection_amt,         currency_cd,
                         gross_amt,            gross_tag,           upload_tag,             user_id,
                         last_update)
                 VALUES
                        (GIACS607_PKG.v_tran_id,    p_fund_cd,          p_branch_cd,        guf.nbt_intm_name,
                         GIACS607_PKG.v_tran_date,  v_cashier_cd,       p_dcb_no,           'N', 
                         guf.intm_no,               v_address1,         v_address2,         v_address3,
                         v_tin,                     v_particulars,      v_or_colln_amt,     v_currency_cd,
                         v_or_gross_amt,            guf.gross_tag,     'Y',                 p_user_id,
                         SYSDATE);
                         
                    --*insert in giac_collection_dtl*--
            FOR colln_rec IN (SELECT item_no, pay_mode, amount, gross_amt, 
                                     commission_amt, vat_amt, check_class, check_date, 
                                     check_no, particulars, bank_cd, dcb_bank_cd, dcb_bank_acct_cd,
                                     amount/currency_rt fcurr_amt, fc_gross_amt, fc_comm_amt, fc_vat_amt, --jason 04/18/2008
                                     currency_cd, currency_rt --jason 04/18/2008
                                FROM giac_upload_colln_dtl 
                               WHERE source_cd= guf.source_cd 
                                 AND file_no = guf.file_no 
                               ORDER BY item_no)
            LOOP                       
                INSERT INTO giac_collection_dtl
                            (gacc_tran_id,            item_no,                currency_cd,            currency_rt,
                             pay_mode,                  amount,                 gross_amt,              commission_amt,
                             vat_amt,                fcurrency_amt,          fc_gross_amt,           fc_comm_amt,
                             fc_tax_amt,             check_class,            check_date,             check_no, 
                             particulars,            bank_cd,                due_dcb_no,             due_dcb_date,
                             user_id,                last_update,            dcb_bank_cd,            dcb_bank_acct_cd)
                      VALUES
                            (GIACS607_PKG.v_tran_id,    colln_rec.item_no,      colln_rec.currency_cd,  colln_rec.currency_rt,  
                             colln_rec.pay_mode,        colln_rec.amount,       colln_rec.gross_amt,    colln_rec.commission_amt,
                             colln_rec.vat_amt,         colln_rec.fcurr_amt,    colln_rec.fc_gross_amt, colln_rec.fc_comm_amt,
                             colln_rec.fc_vat_amt,      colln_rec.check_class,  colln_rec.check_date,   colln_rec.check_no, 
                             colln_rec.particulars,     colln_rec.bank_cd,      p_dcb_no,               trunc(GIACS607_PKG.v_tran_date),
                             p_user_id,                    SYSDATE,                colln_rec.dcb_bank_cd,  colln_rec.dcb_bank_acct_cd);
            END LOOP;
            
            --*generate acct entries for the O.R.*--
            upload_dpc_web.aeg_parameters(GIACS607_PKG.v_tran_id, p_branch_cd, p_fund_cd, 'GIACS001', p_user_id);

                     
            --Process the payments for premium collns, commission, prem deposit, etc.
            GIACS607_PKG.process_payments(guf.source_cd, guf.file_no, p_nbt_tran_class, NULL, NULL, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3, p_user_id);

            --delete record from table giac_upload_dv_payt_dtl and 
            --giac_upload_jv_payt_dtl since OR was created
            DELETE FROM giac_upload_dv_payt_dtl
             WHERE source_cd = guf.source_cd
               AND file_no = guf.file_no;
             
            DELETE FROM giac_upload_jv_payt_dtl
             WHERE source_cd = guf.source_cd
               AND file_no = guf.file_no;

            --update the table giac_upload_prem_comm
            UPDATE giac_upload_prem_comm
               SET tran_id   = GIACS607_PKG.v_tran_id,
                   tran_date = GIACS607_PKG.v_tran_date
             WHERE source_cd = guf.source_cd
               AND file_no   = guf.file_no;                                  

            --update the table giac_upload_file
            UPDATE giac_upload_file
               SET upload_date = SYSDATE,
                   file_status = '2',
                   tran_class  = v_tran_class,
                   tran_id     = GIACS607_PKG.v_tran_id,
                   tran_date   = GIACS607_PKG.v_tran_date
             WHERE source_cd = guf.source_cd
               AND file_no   = guf.file_no;
        END LOOP;
    END gen_group_or;
    
    
    PROCEDURE create_or_colln_dtl(    
        p_source_cd             GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no               GIAC_UPLOAD_FILE.FILE_NO%TYPE,        
        p_gross_amt                giac_upload_colln_dtl.gross_amt%TYPE,
        p_comm_amt                 giac_upload_colln_dtl.commission_amt%TYPE,    
        p_amount                giac_upload_colln_dtl.amount%TYPE,
        p_vat_amt                giac_upload_colln_dtl.vat_amt%TYPE, --jason 04/18/2008
        p_fc_gross_amt            giac_upload_colln_dtl.fc_gross_amt%TYPE, --jason 04/18/2008
        p_fc_comm_amt            giac_upload_colln_dtl.fc_comm_amt%TYPE, --jason 04/18/2008
        p_fc_vat_amt            giac_upload_colln_dtl.fc_vat_amt%TYPE
    )
    AS       
        v_item_no                  giac_upload_colln_dtl.item_no%TYPE;
        v_gross_amt                giac_upload_colln_dtl.gross_amt%TYPE;
        v_comm_amt                giac_upload_colln_dtl.commission_amt%TYPE;
        v_amount                giac_upload_colln_dtl.amount%TYPE;
        --jason 04/18/2008: added the following variables
        v_vat_amt                 giac_upload_colln_dtl.vat_amt%TYPE; 
        v_fc_gross_amt             giac_upload_colln_dtl.fc_gross_amt%TYPE; 
        v_fc_comm_amt             giac_upload_colln_dtl.fc_comm_amt%TYPE; 
        v_fc_vat_amt             giac_upload_colln_dtl.fc_vat_amt%TYPE; 
            
        v_rem_gross_amt            giac_upload_colln_dtl.gross_amt%TYPE;
        v_rem_comm_amt            giac_upload_colln_dtl.commission_amt%TYPE;
        v_rem_amount             giac_upload_colln_dtl.amount%TYPE;
        --jason 04/18/2008: added the following variables
        v_rem_vat_amt            giac_upload_colln_dtl.vat_amt%TYPE; 
        v_rem_fc_gross_amt      giac_upload_colln_dtl.fc_gross_amt%TYPE; 
        v_rem_fc_comm_amt        giac_upload_colln_dtl.fc_comm_amt%TYPE; 
        v_rem_fc_vat_amt        giac_upload_colln_dtl.fc_vat_amt%TYPE;

        v_ins_gross_amt            giac_upload_colln_dtl.gross_amt%TYPE;
        v_ins_comm_amt            giac_upload_colln_dtl.commission_amt%TYPE;
        v_ins_amount            giac_upload_colln_dtl.amount%TYPE;
        --jason 04/18/2008: added the following variables
        v_ins_vat_amt            giac_upload_colln_dtl.vat_amt%TYPE;
        v_ins_fc_gross_amt      giac_upload_colln_dtl.fc_gross_amt%TYPE;
        v_ins_fc_comm_amt        giac_upload_colln_dtl.fc_comm_amt%TYPE;
        v_ins_fc_vat_amt        giac_upload_colln_dtl.fc_vat_amt%TYPE;
          
        v_exists                BOOLEAN := FALSE;
        v_dum_exists            BOOLEAN := FALSE;
            
        v_dum_gross_amt            giac_upload_colln_dtl.gross_amt%TYPE;
        v_dum_comm_amt            giac_upload_colln_dtl.commission_amt%TYPE;
        v_dum_amount            giac_upload_colln_dtl.amount%TYPE;
        --jason 04/18/2008: added the following variables
        v_dum_vat_amt            giac_upload_colln_dtl.vat_amt%TYPE; 
        v_dum_fc_gross_amt      giac_upload_colln_dtl.fc_gross_amt%TYPE; 
        v_dum_fc_comm_amt        giac_upload_colln_dtl.fc_comm_amt%TYPE; 
        v_dum_fc_vat_amt        giac_upload_colln_dtl.fc_vat_amt%TYPE; 
        
        TYPE temp_rg_type IS RECORD (
            item_no                 GIAC_UPLOAD_COLLN_DTL.ITEM_NO%type,
            amount                  GIAC_UPLOAD_COLLN_DTL.AMOUNT%type,
            gross_amt               GIAC_UPLOAD_COLLN_DTL.GROSS_AMT%type,
            comm_amt                GIAC_UPLOAD_COLLN_DTL.COMMISSION_AMT%type,
            vat_amt                 GIAC_UPLOAD_COLLN_DTL.VAT_AMT%type,
            fc_gross_amt            GIAC_UPLOAD_COLLN_DTL.FC_GROSS_AMT%type,
            fc_comm_amt             GIAC_UPLOAD_COLLN_DTL.FC_COMM_AMT%type,
            fc_vat_amt              GIAC_UPLOAD_COLLN_DTL.FC_VAT_AMT%type
        );
        
        TYPE temp_rg_tab IS TABLE OF temp_rg_type;
        v_temp_rg_list           temp_rg_tab := temp_rg_tab();
        
    BEGIN
        SELECT item_no, pay_mode, bank_cd, check_class, check_no, check_date,
                currency_cd, currency_rt, particulars,
                nvl(amount,0) amount, nvl(gross_amt,0) gross_amt,
                -(nvl(commission_amt,0) + nvl(vat_amt,0)) comm_amt, --alfie 04092010
--                nvl(commission_amt,0) comm_amt,
                nvl(vat_amt,0) vat_amt ,                     
                fc_gross_amt, fc_comm_amt, fc_vat_amt
          BULK COLLECT INTO v_gucd_rg_list
          FROM giac_upload_colln_dtl 
         WHERE source_cd= p_source_cd 
           AND file_no = p_file_no 
        ORDER BY item_no;
        
        v_rem_gross_amt            := p_gross_amt;
        v_rem_comm_amt            := p_comm_amt;
        v_rem_amount            := p_amount;
          
        --jason 04/18/2008: added the code below
        v_rem_vat_amt            := p_vat_amt; 
        v_rem_fc_gross_amt      := p_fc_gross_amt; 
        v_rem_fc_comm_amt        := p_fc_comm_amt; 
        v_rem_fc_vat_amt        := p_fc_vat_amt; 
        
        --transfer the records to be processed (1st time)
        FOR rec IN 1..v_gucd_rg_list.COUNT
        LOOP
            v_exists        := FALSE;
            v_item_no       := v_gucd_rg_list(rec).item_no;
            v_gross_amt     := v_gucd_rg_list(rec).gross_amt;
            v_comm_amt      := v_gucd_rg_list(rec).comm_amt;
            v_amount        := v_gucd_rg_list(rec).amount;
            
            --jason 04/18/2008: added the following code
            v_vat_amt            := v_gucd_rg_list(rec).vat_amt; 
            v_fc_gross_amt        := v_gucd_rg_list(rec).fc_gross_amt; 
            v_fc_comm_amt         := v_gucd_rg_list(rec).fc_comm_amt; 
            v_fc_vat_amt        := v_gucd_rg_list(rec).fc_vat_amt; 
            --   v_curr_cd                := get_group_number_cell('gucd_rg.currency_cd', rec);
            --   v_curr_rt                := get_group_number_cell('gucd_rg.currency_rt', rec);

            IF v_amount <> 0 THEN
                --IF p_comm_amt = 0 AND v_comm_amt = 0 THEN --commented by alfie to allow uploading transaction even if p_comm_amt is 0 or v_comm_amt is 0    05212010
                v_exists := TRUE;
                --ELSIF    p_comm_amt <> 0 AND v_comm_amt <> 0 THEN
                --    v_exists := TRUE;
                --END IF;    
            END IF;

            IF v_exists THEN
                v_temp_rg_list.EXTEND;
                                       
                v_temp_rg_list(v_temp_rg_list.LAST).item_no := v_item_no;
                v_temp_rg_list(v_temp_rg_list.LAST).gross_amt := v_gross_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).comm_amt := v_comm_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).amount := v_amount;
                            
                --jason 04/18/2008: added the following code
                v_temp_rg_list(v_temp_rg_list.LAST).vat_amt := v_vat_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_gross_amt := v_fc_gross_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_comm_amt := v_fc_comm_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_vat_amt := v_fc_vat_amt;
                            
                v_gucd_rg_list(rec).gross_amt := 0;
                v_gucd_rg_list(rec).comm_amt := 0;
                v_gucd_rg_list(rec).amount := 0;
                            
                --jason 04/18/2008: added the following code
                v_gucd_rg_list(rec).vat_amt := 0;
                v_gucd_rg_list(rec).fc_gross_amt := 0;
                v_gucd_rg_list(rec).fc_comm_amt := 0;
                v_gucd_rg_list(rec).fc_vat_amt := 0;                        
            END IF;
        END LOOP rec;
          
        --initialize variables
        --process the records (1st time)
        LOOP
            v_dum_exists := FALSE;
            
            FOR a1 IN 1..v_temp_rg_list.COUNT
            LOOP            
                v_dum_exists := FALSE;
                v_exists := FALSE;
                
                v_item_no   := v_temp_rg_list(a1).item_no;
                v_gross_amt := v_temp_rg_list(a1).gross_amt;
                v_comm_amt  := v_temp_rg_list(a1).comm_amt;
                v_amount    := v_temp_rg_list(a1).amount;
                          
                --jason 04/18/2008: added the following code
                v_vat_amt            := v_temp_rg_list(a1).vat_amt; 
                v_fc_gross_amt        := v_temp_rg_list(a1).fc_gross_amt; 
                v_fc_comm_amt         := v_temp_rg_list(a1).fc_comm_amt; 
                v_fc_vat_amt        := v_temp_rg_list(a1).fc_vat_amt;
                
                IF v_amount <> 0 AND v_rem_amount <> 0 THEN
                    IF p_comm_amt <> 0 THEN                
                        IF (v_rem_gross_amt > v_gross_amt AND v_rem_comm_amt >= v_comm_amt AND v_rem_amount > v_amount) OR 
                             (v_rem_gross_amt = v_gross_amt AND v_rem_comm_amt = v_comm_amt AND v_rem_amount = v_amount) THEN
                            v_ins_gross_amt    := v_gross_amt;
                            v_ins_comm_amt    := v_comm_amt;
                            v_dum_exists    := TRUE;
                                         
                            --jason 04/18/2008: added the following code
                            v_ins_vat_amt      := v_vat_amt;
                            v_ins_fc_gross_amt := v_fc_gross_amt;
                            v_ins_fc_comm_amt  := v_fc_comm_amt;
                            v_ins_fc_vat_amt   := v_fc_vat_amt;
                                        
                        ELSIF (v_rem_gross_amt <= /* < */v_gross_amt AND v_rem_comm_amt <= v_comm_amt AND v_rem_amount <= /* < */ v_amount) THEN --modified by alfie 04092010: to make it sure that every first record uploaded go in this way
                            v_ins_gross_amt    := v_rem_gross_amt;
                            v_ins_comm_amt    := v_rem_comm_amt;
                            v_dum_exists := TRUE;
                                        
                            --jason 04/18/2008: added the following code
                            v_ins_vat_amt      := v_rem_vat_amt;
                            v_ins_fc_gross_amt := v_rem_fc_gross_amt;
                            v_ins_fc_comm_amt  := v_rem_fc_comm_amt;
                            v_ins_fc_vat_amt   := v_rem_fc_vat_amt;
                        END IF;            
                    ELSIF p_comm_amt = 0 THEN                
                        IF v_rem_gross_amt >= v_gross_amt THEN
                            v_ins_gross_amt := v_gross_amt;
                            v_ins_comm_amt    := 0;
                            v_dum_exists := TRUE;
                                            
                            --jason 04/18/2008: added the following code
                            v_ins_vat_amt      := v_vat_amt;
                            v_ins_fc_gross_amt := v_fc_gross_amt;
                            v_ins_fc_comm_amt  := 0;
                            v_ins_fc_vat_amt   := v_fc_vat_amt;
                                        
                        ELSE --v_rem_gross_amt < v_gross_amt                
                            v_ins_gross_amt := v_rem_gross_amt;
                            v_ins_comm_amt    := 0;
                            v_dum_exists := TRUE;    
                                        
                            --jason 04/18/2008: added the following code
                            v_ins_vat_amt      := v_rem_vat_amt;
                            v_ins_fc_gross_amt := v_rem_fc_gross_amt;
                            v_ins_fc_comm_amt  := 0;
                            v_ins_fc_vat_amt   := v_rem_fc_vat_amt;
                        END IF;
                    END IF;            
                END IF;

                IF v_dum_exists THEN
                    --v_ins_amount := v_ins_gross_amt - v_ins_comm_amt - v_ins_vat_amt; --jason 04/18/2008: subtract v_ins_vat_amt
                    v_ins_amount := v_ins_gross_amt - (v_ins_comm_amt + v_ins_vat_amt); --modified by alfie 04092010: since gucd_rg recordgroup's select was modified, v_ins_amount must have the right formula/computation to avoid unneccessary error
                        
                    FOR a2 IN 1..v_colln_dtl_rg_list.COUNT
                    LOOP
                        IF v_item_no = v_colln_dtl_rg_list(a2).item_no THEN
                            v_exists := TRUE;
                            v_colln_dtl_rg_list(a2).gross_amt       := v_colln_dtl_rg_list(a2).gross_amt + v_ins_gross_amt;
                            v_colln_dtl_rg_list(a2).comm_amt        := v_colln_dtl_rg_list(a2).comm_amt + v_ins_comm_amt;
                            v_colln_dtl_rg_list(a2).amount          := v_colln_dtl_rg_list(a2).amount + v_ins_amount;
                                                   
                            --jason 04/18/2008: added the following code
                            v_colln_dtl_rg_list(a2).vat_amt         := v_colln_dtl_rg_list(a2).vat_amt + v_ins_vat_amt; 
                            v_colln_dtl_rg_list(a2).fc_gross_amt    := v_colln_dtl_rg_list(a2).fc_gross_amt + v_ins_fc_gross_amt;   
                            v_colln_dtl_rg_list(a2).fc_comm_amt     := v_colln_dtl_rg_list(a2).fc_comm_amt + v_ins_fc_comm_amt;                                        
                            v_colln_dtl_rg_list(a2).fc_vat_amt      := v_colln_dtl_rg_list(a2).fc_vat_amt + v_ins_fc_vat_amt;                     
                                                              
                            EXIT;
                        END IF;
                    END LOOP a2;
                    
                    IF NOT v_exists THEN
                        v_colln_dtl_rg_list.EXTEND;           
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).item_no       := v_item_no;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).gross_amt     := v_ins_gross_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).comm_amt      := v_ins_comm_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).amount        := v_ins_amount;
                                    
                        --jason 04/18/2008: added the following code
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).vat_amt       := v_ins_vat_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_gross_amt  := v_ins_fc_gross_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_comm_amt   := v_ins_fc_comm_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_vat_amt    := v_ins_fc_vat_amt;
                    END IF;              
                        
                    v_temp_rg_list(a1).gross_amt    := v_gross_amt - v_ins_gross_amt;
                    v_temp_rg_list(a1).comm_amt     := v_comm_amt - v_ins_comm_amt;
                    v_temp_rg_list(a1).amount       := v_amount - v_ins_amount;
                                
                    --jason 04/18/2008: added the following code
                    v_temp_rg_list(v_temp_rg_list.LAST).vat_amt      := v_vat_amt - v_ins_vat_amt;
                    v_temp_rg_list(v_temp_rg_list.LAST).fc_gross_amt := v_fc_gross_amt - v_ins_fc_gross_amt;
                    v_temp_rg_list(v_temp_rg_list.LAST).fc_comm_amt  := v_fc_comm_amt - v_ins_fc_comm_amt;
                    v_temp_rg_list(v_temp_rg_list.LAST).fc_vat_amt   := v_fc_vat_amt - v_ins_fc_vat_amt;
                        
                    v_rem_gross_amt    := v_rem_gross_amt - v_ins_gross_amt;
                    v_rem_comm_amt    := v_rem_comm_amt - v_ins_comm_amt;
                    v_rem_amount    := v_rem_amount - v_ins_amount;
                                
                    --jason 04/18/2008: added the following code
                    v_rem_vat_amt        := v_rem_vat_amt - v_ins_vat_amt;
                    v_rem_fc_gross_amt  := v_rem_fc_gross_amt - v_ins_fc_gross_amt;
                    v_rem_fc_comm_amt   := v_rem_fc_comm_amt - v_ins_fc_comm_amt;
                    v_rem_fc_vat_amt    := v_rem_fc_vat_amt - v_ins_fc_vat_amt;                                
                END IF;
            END LOOP a1;
            
            EXIT WHEN 
                NOT v_dum_exists OR v_rem_amount = 0;
        END LOOP;
        
        --return the remaining amounts into the original record group (1st time)
        IF v_temp_rg_list.COUNT <> 0 THEN        
            FOR b1 IN 1..v_gucd_rg_list.COUNT
            LOOP
                v_item_no   := v_gucd_rg_list(b1).item_no;
                
                FOR b2 IN 1..v_temp_rg_list.COUNT
                LOOP
                    IF v_item_no = v_temp_rg_list(b2).item_no THEN
                        v_exists := TRUE;
                        v_gucd_rg_list(b1).gross_amt    := v_gucd_rg_list(b1).gross_amt + v_temp_rg_list(b2).gross_amt;
                        v_gucd_rg_list(b1).comm_amt     := v_gucd_rg_list(b1).comm_amt + v_temp_rg_list(b2).comm_amt;
                        v_gucd_rg_list(b1).amount       := v_gucd_rg_list(b1).amount + v_temp_rg_list(b2).amount;
                                
                        --jason 04/18/2008: added the following code                    
                        v_gucd_rg_list(b1).vat_amt      := v_gucd_rg_list(b1).vat_amt + v_temp_rg_list(b2).vat_amt;
                        v_gucd_rg_list(b1).fc_gross_amt := v_gucd_rg_list(b1).fc_gross_amt + v_temp_rg_list(b2).fc_gross_amt;
                        v_gucd_rg_list(b1).fc_comm_amt  := v_gucd_rg_list(b1).fc_comm_amt + v_temp_rg_list(b2).fc_comm_amt;                      
                        v_gucd_rg_list(b1).fc_vat_amt   := v_gucd_rg_list(b1).fc_vat_amt + v_temp_rg_list(b2).fc_vat_amt; 
                        EXIT;
                    END IF;
                END LOOP b2;
            END LOOP b1;
        END IF;
        
        v_temp_rg_list.DELETE(1, v_temp_rg_list.COUNT);
        
        IF v_rem_amount = 0 THEN
            GOTO end_of_proc;
        END IF;    
        
        --get the records to be processed (2nd time)
        FOR rec IN 1..v_gucd_rg_list.COUNT
        LOOP
            v_exists    := FALSE;
            v_item_no   := v_gucd_rg_list(rec).item_no;
            v_gross_amt := v_gucd_rg_list(rec).gross_amt;
            v_comm_amt  := v_gucd_rg_list(rec).comm_amt;
            v_amount    := v_gucd_rg_list(rec).amount;
                  
            --jason 04/18/2008: added the following code
            v_vat_amt       := v_gucd_rg_list(rec).vat_amt; 
            v_fc_gross_amt    := v_gucd_rg_list(rec).fc_gross_amt; 
            v_fc_comm_amt    := v_gucd_rg_list(rec).fc_comm_amt; 
            v_fc_vat_amt    := v_gucd_rg_list(rec).fc_vat_amt; 
            --v_curr_cd                := get_group_number_cell('gucd_rg.currency_cd;
            --v_curr_rt                := get_group_number_cell('gucd_rg.currency_rt;


            IF v_amount <> 0 THEN
                IF p_comm_amt = 0 AND (v_gross_amt - v_comm_amt)/2 >= 0.01 THEN
                    v_dum_gross_amt := (v_gross_amt - v_comm_amt)/2 + v_comm_amt;
                    v_dum_comm_amt  := v_comm_amt;
                    v_dum_vat_amt   := v_vat_amt; --jason 04/18/2008
                    --v_dum_amount    := v_dum_gross_amt - v_dum_comm_amt - v_dum_vat_amt; --jason 04/18/2008: subtract v_dum_vat_amt
                    v_dum_amount    := v_dum_gross_amt - (v_dum_comm_amt + v_dum_vat_amt); --modified by alfie 04092010: since gucd_rg recordgroup's select was modified, v_dum_amount must have the right formula/computation to avoid unneccessary error
                    v_exists := TRUE;
                            
                    --jason 04/18/2008: added the following code
                    v_dum_fc_gross_amt := (v_fc_gross_amt - v_fc_comm_amt)/2 + v_fc_comm_amt;
                    v_dum_fc_comm_amt  := v_fc_comm_amt;
                    v_dum_fc_vat_amt   := v_fc_vat_amt;
                            
                ELSIF    p_comm_amt <> 0 AND v_comm_amt <> 0 AND (v_gross_amt - v_comm_amt)/2 >= 0.01 THEN
                    v_dum_gross_amt := (v_gross_amt - v_comm_amt)/2;
                    v_dum_comm_amt := 0;
                    v_dum_vat_amt   := v_vat_amt; --jason 04/18/2008
                    --v_dum_amount := v_dum_gross_amt - v_dum_comm_amt - v_dum_vat_amt; --jason 04/18/2008: subtract v_dum_vat_amt
                    v_dum_amount := v_dum_gross_amt - (v_dum_comm_amt + v_dum_vat_amt); ----modified by alfie 04092010: since gucd_rg recordgroup's select was modified, v_dum_amount must have the right formula/computation to avoid unneccessary error
                    v_exists := TRUE;
                            
                    --jason 04/18/2008: added the following code
                    v_dum_fc_gross_amt := (v_fc_gross_amt - v_fc_comm_amt)/2;
                    v_dum_fc_comm_amt  := 0;
                    v_dum_fc_vat_amt   := v_fc_vat_amt;
                END IF;    
            END IF;

            IF v_exists THEN
                v_temp_rg_list.EXTEND;
                                      
                v_temp_rg_list(v_temp_rg_list.LAST).item_no     := v_item_no;
                v_temp_rg_list(v_temp_rg_list.LAST).gross_amt   := v_gross_amt - v_dum_gross_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).comm_amt    := v_comm_amt - v_dum_comm_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).amount      := v_amount - v_dum_amount;
                        
                --jason 04/18/2008: added the following code
                v_temp_rg_list(v_temp_rg_list.LAST).vat_amt         := v_dum_vat_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_gross_amt    := v_dum_fc_gross_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_comm_amt     := v_dum_fc_comm_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_vat_amt      := v_dum_fc_vat_amt;
                        
                        
                v_gucd_rg_list(rec).gross_amt   := v_dum_gross_amt;
                v_gucd_rg_list(rec).comm_amt    := v_dum_comm_amt;
                v_gucd_rg_list(rec).amount      := v_dum_amount;
                
                --jason 04/18/2008: added the following code
                v_gucd_rg_list(rec).vat_amt         := v_dum_vat_amt;
                v_gucd_rg_list(rec).fc_gross_amt    := v_dum_fc_gross_amt;
                v_gucd_rg_list(rec).fc_comm_amt     := v_dum_fc_comm_amt;
                v_gucd_rg_list(rec).fc_vat_amt  := v_dum_fc_vat_amt;    
            END IF;
        END LOOP rec;
        
        --process the records (2nd time)
        LOOP
            v_dum_exists := FALSE;
            
            FOR c1 IN 1..v_temp_rg_list.COUNT
            LOOP
                v_dum_exists := FALSE;
                v_exists := FALSE;
                
                v_item_no   := v_temp_rg_list(c1).item_no;
                v_gross_amt := v_temp_rg_list(c1).gross_amt;
                v_comm_amt  := v_temp_rg_list(c1).comm_amt;
                v_amount    := v_temp_rg_list(c1).amount;
                              
                --jason 04/18/2008: added the following code
                v_vat_amt        := v_temp_rg_list(c1).vat_amt; 
                v_fc_gross_amt  := v_temp_rg_list(c1).fc_gross_amt; 
                v_fc_comm_amt    := v_temp_rg_list(c1).fc_comm_amt; 
                v_fc_vat_amt    := v_temp_rg_list(c1).fc_vat_amt;

                IF v_amount <> 0 AND v_rem_amount <> 0 THEN
                    IF v_comm_amt = 0 AND v_rem_comm_amt = 0 THEN
                        v_ins_comm_amt := 0;
                        v_ins_fc_comm_amt := 0; --jason 04/18/2008
                        
                        IF v_rem_gross_amt >= v_gross_amt THEN
                            v_ins_gross_amt    := v_gross_amt;
                            v_ins_fc_gross_amt := v_fc_gross_amt; --jason 04/18/2008
                        ELSE
                            v_ins_gross_amt    := v_rem_gross_amt;
                            v_ins_fc_gross_amt := v_rem_fc_gross_amt; --jason 04/18/2008
                        END IF;        
                        
                        v_dum_exists := TRUE;
                
                    ELSIF v_rem_comm_amt <> 0 THEN
                    
                        IF v_rem_comm_amt >= v_comm_amt THEN 
                            v_ins_comm_amt := v_comm_amt;
                            v_ins_fc_comm_amt := v_fc_comm_amt; --jason 04/18/2008
                        
                            IF v_rem_gross_amt >= v_gross_amt THEN
                                v_ins_gross_amt    := v_gross_amt;
                                v_ins_fc_gross_amt := v_fc_gross_amt; --jason 04/18/2008
                            ELSE
                                v_ins_gross_amt    := v_rem_gross_amt;
                                v_ins_fc_gross_amt := v_rem_fc_gross_amt; --jason 04/18/2008
                            END IF;    
                            v_dum_exists := TRUE;
                    
                        ELSIF    v_rem_comm_amt < v_comm_amt THEN                            
                            v_ins_comm_amt := v_rem_comm_amt;
                            v_ins_fc_comm_amt := v_rem_fc_comm_amt; --jason 04/18/2008
                        
                            IF v_rem_gross_amt >= v_gross_amt - (v_comm_amt - v_ins_comm_amt + 0.01) THEN
                                v_ins_gross_amt    := v_gross_amt - (v_comm_amt - v_ins_comm_amt + 0.01);
                                v_ins_fc_gross_amt := v_fc_gross_amt - (v_fc_comm_amt - v_ins_fc_comm_amt + 0.01); --jason 04/18/2008
                            ELSE
                                v_ins_gross_amt    := v_rem_gross_amt;
                                v_ins_fc_gross_amt := v_rem_fc_gross_amt; --jason 04/18/2008
                            END IF;    
                            v_dum_exists := TRUE;
                        END IF;                
                    END IF;    
                END IF;
                
                IF v_dum_exists THEN
                    --v_ins_amount := v_ins_gross_amt - v_ins_comm_amt;
                    v_ins_amount := v_ins_gross_amt - (v_ins_comm_amt + v_vat_amt); --modified by alfie 04092010: since gucd_rg recordgroup's select was modified, v_ins_amount must have the right formula/computation to avoid unneccessary error         
                    
                    FOR c2 IN 1..v_colln_dtl_rg_list.COUNT
                    LOOP
                        IF v_item_no = v_colln_dtl_rg_list(c2).item_no THEN
                            v_exists := TRUE;
                            v_colln_dtl_rg_list(c2).gross_amt   := v_colln_dtl_rg_list(c2).gross_amt  + v_ins_gross_amt;
                            v_colln_dtl_rg_list(c2).comm_amt    := v_colln_dtl_rg_list(c2).comm_amt + v_ins_comm_amt;
                            v_colln_dtl_rg_list(c2).amount      := v_colln_dtl_rg_list(c2).amount + v_ins_amount;
                          
                          --jason 04/18/2008: added the following code
                            v_colln_dtl_rg_list(c2).vat_amt         := v_colln_dtl_rg_list(c2).vat_amt + v_ins_vat_amt; 
                            v_colln_dtl_rg_list(c2).fc_gross_amt    := v_colln_dtl_rg_list(c2).fc_gross_amt + v_ins_fc_gross_amt;   
                            v_colln_dtl_rg_list(c2).fc_comm_amt     := v_colln_dtl_rg_list(c2).fc_comm_amt + v_ins_fc_comm_amt;                                        
                            v_colln_dtl_rg_list(c2).fc_vat_amt      := v_colln_dtl_rg_list(c2).fc_vat_amt + v_ins_fc_vat_amt;    
                            EXIT;
                        END IF;
                    END LOOP c2;
                    
                    IF NOT v_exists THEN
                        v_colln_dtl_rg_list.EXTEND;
                                    
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).item_no   := v_item_no;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).gross_amt := v_ins_gross_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).comm_amt  := v_ins_comm_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).amount    := v_ins_amount;
                        
                        --jason 04/18/2008: added the following code
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).vat_amt       := v_ins_vat_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_gross_amt  := v_ins_fc_gross_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_comm_amt   := v_ins_fc_comm_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_vat_amt    := v_ins_fc_vat_amt;
                    END IF;              
                
                    v_temp_rg_list(c1).gross_amt := v_gross_amt - v_ins_gross_amt;
                    v_temp_rg_list(c1).comm_amt := v_comm_amt - v_ins_comm_amt;
                    v_temp_rg_list(c1).amount := v_amount - v_ins_amount;
                    
                    --jason 04/18/2008: added the following code
                    v_temp_rg_list(v_temp_rg_list.LAST).vat_amt := v_vat_amt - v_ins_vat_amt;
                    v_temp_rg_list(v_temp_rg_list.LAST).fc_gross_amt := v_fc_gross_amt - v_ins_fc_gross_amt;
                    v_temp_rg_list(v_temp_rg_list.LAST).fc_comm_amt := v_fc_comm_amt - v_ins_fc_comm_amt;
                    v_temp_rg_list(v_temp_rg_list.LAST).fc_vat_amt := v_fc_vat_amt - v_ins_fc_vat_amt;
            
                    v_rem_gross_amt    := v_rem_gross_amt - v_ins_gross_amt;
                    v_rem_comm_amt    := v_rem_comm_amt - v_ins_comm_amt;
                    v_rem_amount    := v_rem_amount - v_ins_amount;
                    
                    --jason 04/18/2008: added the following code
                    v_rem_vat_amt        := v_rem_vat_amt - v_ins_vat_amt;
                    v_rem_fc_gross_amt  := v_rem_fc_gross_amt - v_ins_fc_gross_amt;
                    v_rem_fc_comm_amt   := v_rem_fc_comm_amt - v_ins_fc_comm_amt;
                    v_rem_fc_vat_amt    := v_rem_fc_vat_amt - v_ins_fc_vat_amt;
                END IF;
            END LOOP c1;
            
            IF v_rem_comm_amt <> 0 THEN
                raise_application_error (-20001, 'Geniisys Exception#I#Error encountered in distribution of commission for collection details.');
            END IF;    
            
            EXIT WHEN 
                NOT v_dum_exists OR v_rem_amount = 0;
        END LOOP;
        
        --return the remaining amounts into the original record group (2nd time)
        IF v_temp_rg_list.COUNT <> 0 THEN 
            FOR b1 IN 1..v_gucd_rg_list.COUNT
            LOOP
                v_item_no   := v_gucd_rg_list(b1).item_no;
                
                FOR b2 IN 1..v_temp_rg_list.COUNT
                LOOP
                    IF v_item_no = v_temp_rg_list(b2).item_no THEN
                        v_exists := TRUE;
                        v_gucd_rg_list(b1).gross_amt    := v_gucd_rg_list(b1).gross_amt + v_temp_rg_list(b2).gross_amt;
                        v_gucd_rg_list(b1).comm_amt     := v_gucd_rg_list(b1).comm_amt +  v_temp_rg_list(b2).comm_amt;
                        v_gucd_rg_list(b1).amount       := v_gucd_rg_list(b1).amount + v_temp_rg_list(b2).amount;
                                              
                      --jason 04/18/2008: added the following code                    
                        v_gucd_rg_list(b1).vat_amt      := v_gucd_rg_list(b1).vat_amt + v_temp_rg_list(b2).vat_amt;
                        v_gucd_rg_list(b1).fc_gross_amt := v_gucd_rg_list(b1).fc_gross_amt + v_temp_rg_list(b2).fc_gross_amt;
                        v_gucd_rg_list(b1).fc_comm_amt  := v_gucd_rg_list(b1).fc_comm_amt + v_temp_rg_list(b2).fc_comm_amt;                      
                        v_gucd_rg_list(b1).fc_vat_amt   := v_gucd_rg_list(b1).fc_vat_amt + v_temp_rg_list(b2).fc_vat_amt;                           
                                              
                        EXIT;
                    END IF;
                END LOOP b2;
            END LOOP b1;
        END IF;
        
        v_temp_rg_list.DELETE(1, v_temp_rg_list.COUNT);
        
        IF v_rem_amount = 0 THEN
            GOTO end_of_proc;
        END IF;   
        
        <<final_loop>>
        --get the records to be processed for the last time (3rd time)        
        FOR rec IN 1..v_gucd_rg_list.COUNT
        LOOP
            v_exists        := FALSE;
            v_item_no       := v_gucd_rg_list(rec).item_no;
            v_gross_amt     := v_gucd_rg_list(rec).gross_amt;
            v_comm_amt      := v_gucd_rg_list(rec).comm_amt;
            v_amount        := v_gucd_rg_list(rec).amount;
                      
            --jason 04/18/2008: added the following code
            v_vat_amt       := v_gucd_rg_list(rec).vat_amt; 
            v_fc_gross_amt  := v_gucd_rg_list(rec).fc_gross_amt; 
            v_fc_comm_amt   := v_gucd_rg_list(rec).fc_comm_amt; 
            v_fc_vat_amt    := v_gucd_rg_list(rec).fc_vat_amt; 
            --v_curr_cd                := get_group_number_cell('gucd_rg.currency_cd', rec);
            --v_curr_rt                := get_group_number_cell('gucd_rg.currency_rt', rec);

            IF v_amount <> 0 THEN
                IF v_comm_amt = 0 THEN
                    v_dum_gross_amt := 0;
                    v_dum_comm_amt := 0;
                    v_dum_amount := 0;
                    v_exists := TRUE;
                    
                    --jason 04/18/2008: added the following code
                    v_dum_vat_amt := 0;
                    v_dum_fc_gross_amt := 0; 
                    v_dum_fc_comm_amt := 0;
                    v_dum_fc_vat_amt := 0;
                    
                ELSIF    v_comm_amt <> 0 AND (v_gross_amt - v_comm_amt)/2 >= 0.01 THEN
                    v_dum_gross_amt := (v_gross_amt - v_comm_amt)/2;
                    v_dum_comm_amt := 0;
                    v_dum_vat_amt := v_vat_amt; --jason 04/18/2008
                    --v_dum_amount := v_dum_gross_amt - v_dum_comm_amt - v_dum_vat_amt; --jason 04/18/2008: subtract v_dum_vat_amt
                    v_dum_amount := v_dum_gross_amt - v_dum_comm_amt + v_dum_vat_amt; --modified by alfie 04092010: since gucd_rg recordgroup's select was modified, v_dum_amount must have the right formula/computation to avoid unneccessary error
                    v_exists := TRUE;
                    
                    --jason 04/18/2008: added the following code
                    v_dum_fc_gross_amt := (v_fc_gross_amt - v_fc_comm_amt)/2; 
                    v_dum_fc_comm_amt := 0;
                    v_dum_fc_vat_amt := v_fc_vat_amt;
                END IF;    
            END IF;

            IF v_exists THEN
                v_temp_rg_list.EXTEND;
                
                v_temp_rg_list(v_temp_rg_list.LAST).item_no     := v_item_no;
                v_temp_rg_list(v_temp_rg_list.LAST).gross_amt   := v_gross_amt - v_dum_gross_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).comm_amt    := v_comm_amt - v_dum_comm_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).amount      := v_amount - v_dum_amount;
                
                --jason 04/18/2008: added the following code
                v_temp_rg_list(v_temp_rg_list.LAST).vat_amt         := v_dum_vat_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_gross_amt    := v_dum_fc_gross_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_comm_amt     := v_dum_fc_comm_amt;
                v_temp_rg_list(v_temp_rg_list.LAST).fc_vat_amt      := v_dum_fc_vat_amt;
                
                
                v_gucd_rg_list(rec).gross_amt   := v_dum_gross_amt;
                v_gucd_rg_list(rec).comm_amt    := v_dum_comm_amt;
                v_gucd_rg_list(rec).amount      := v_dum_amount;
        
                --jason 04/18/2008: added the following code
                v_gucd_rg_list(rec).vat_amt         := v_dum_vat_amt;
                v_gucd_rg_list(rec).fc_gross_amt    := v_dum_fc_gross_amt;
                v_gucd_rg_list(rec).fc_comm_amt     := v_dum_fc_comm_amt;
                v_gucd_rg_list(rec).fc_vat_amt      := v_dum_fc_vat_amt; 
            END IF;
        END LOOP rec;
        
        --process the records for the last time (3rd time)
        LOOP
            v_dum_exists := FALSE;        
            FOR c1 IN 1..v_temp_rg_list.COUNT
            LOOP
                v_dum_exists    := FALSE;
                v_exists        := FALSE;
                
                v_item_no       := v_temp_rg_list(c1).item_no;
                v_gross_amt     := v_temp_rg_list(c1).gross_amt;
                v_comm_amt      := v_temp_rg_list(c1).comm_amt;
                v_amount        := v_temp_rg_list(c1).amount;
                              
                --jason 04/18/2008: added the following code
                v_vat_amt       := v_temp_rg_list(c1).vat_amt; 
                v_fc_gross_amt  := v_temp_rg_list(c1).fc_gross_amt; 
                v_fc_comm_amt   := v_temp_rg_list(c1).fc_comm_amt; 
                v_fc_vat_amt    := v_temp_rg_list(c1).fc_vat_amt;
                
                IF v_amount <> 0 AND v_rem_amount <> 0 THEN
                    v_ins_comm_amt := 0;
                    v_ins_fc_comm_amt := 0; --jason 04/18/2008
                    IF v_rem_gross_amt >= v_gross_amt THEN
                        v_ins_gross_amt    := v_gross_amt;
                        v_ins_fc_gross_amt := v_fc_gross_amt; --jason 04/18/2008
                    ELSE
                        v_ins_gross_amt    := v_rem_gross_amt;
                        v_ins_fc_gross_amt := v_rem_fc_gross_amt; --jason 04/18/2008
                    END IF;                        
                    v_dum_exists := TRUE;
                END IF;
                
                IF v_dum_exists THEN
                    --v_ins_amount := v_ins_gross_amt - v_ins_comm_amt;        
                    v_ins_amount := v_ins_gross_amt - (v_ins_comm_amt + v_ins_vat_amt); --modified by alfie 04092010: since gucd_rg recordgroup's select was modified, v_ins_amount must have the right formula/computation to avoid unneccessary error
                    
                    FOR c2 IN 1..v_colln_dtl_rg_list.COUNT
                    LOOP
                        IF v_item_no = v_colln_dtl_rg_list(c2).item_no THEN
                            v_exists := TRUE;
                            v_colln_dtl_rg_list(c2).gross_amt   := v_colln_dtl_rg_list(c2).gross_amt + v_ins_gross_amt;
                            v_colln_dtl_rg_list(c2).comm_amt    := v_colln_dtl_rg_list(c2).comm_amt + v_ins_comm_amt;
                            v_colln_dtl_rg_list(c2).amount      := v_colln_dtl_rg_list(c2).amount + v_ins_amount;
                                                  
                            --jason 04/18/2008: added the following code
                            v_colln_dtl_rg_list(c2).vat_amt         := v_colln_dtl_rg_list(c2).vat_amt + v_ins_vat_amt; 
                            v_colln_dtl_rg_list(c2).fc_gross_amt    := v_colln_dtl_rg_list(c2).fc_gross_amt + v_ins_fc_gross_amt;   
                            v_colln_dtl_rg_list(c2).fc_comm_amt     := v_colln_dtl_rg_list(c2).fc_comm_amt + v_ins_fc_comm_amt;                                        
                            v_colln_dtl_rg_list(c2).fc_vat_amt      := v_colln_dtl_rg_list(c2).fc_vat_amt + v_ins_fc_vat_amt;
                                                                        
                            EXIT;
                        END IF;
                    END LOOP c2;
                    
                    IF NOT v_exists THEN
                        v_colln_dtl_rg_list.EXTEND;
                                  
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).item_no   := v_item_no;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).gross_amt := v_ins_gross_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).comm_amt  := v_ins_comm_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).amount    := v_ins_amount;
                        
                        --jason 04/18/2008: added the following code
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).vat_amt       := v_ins_vat_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_gross_amt  := v_ins_fc_gross_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_comm_amt   := v_ins_fc_comm_amt;
                        v_colln_dtl_rg_list(v_colln_dtl_rg_list.LAST).fc_vat_amt    := v_ins_fc_vat_amt;
                    END IF;              
            
                    v_temp_rg_list(c1).gross_amt    := v_gross_amt - v_ins_gross_amt;
                    v_temp_rg_list(c1).comm_amt     := v_comm_amt - v_ins_comm_amt;
                    v_temp_rg_list(c1).amount       := v_amount - v_ins_amount;
                    
                    --jason 04/18/2008: added the following code
                    v_temp_rg_list(c1).vat_amt      := v_vat_amt - v_ins_vat_amt;
                    v_temp_rg_list(c1).fc_gross_amt := v_fc_gross_amt - v_ins_fc_gross_amt;
                    v_temp_rg_list(c1).fc_comm_amt  := v_fc_comm_amt - v_ins_fc_comm_amt;
                    v_temp_rg_list(c1).fc_vat_amt   := v_fc_vat_amt - v_ins_fc_vat_amt;
            
                    v_rem_gross_amt     := v_rem_gross_amt - v_ins_gross_amt;
                    v_rem_comm_amt      := v_rem_comm_amt - v_ins_comm_amt;
                    v_rem_amount        := v_rem_amount - v_ins_amount;
                    
                    --jason 04/18/2008: added the following code
                    v_rem_vat_amt       := v_rem_vat_amt - v_ins_vat_amt;
                    v_rem_fc_gross_amt  := v_rem_fc_gross_amt - v_ins_fc_gross_amt;
                    v_rem_fc_comm_amt   := v_rem_fc_comm_amt - v_ins_fc_comm_amt;
                    v_rem_fc_vat_amt    := v_rem_fc_vat_amt - v_ins_fc_vat_amt;
                END IF;
            END LOOP c1;
            
            EXIT WHEN 
                NOT v_dum_exists OR v_rem_amount = 0;
        END LOOP;
        
        --return the remaining amounts into the original record group (3rd time)
        IF v_temp_rg_list.COUNT <> 0 THEN        
            FOR b1 IN 1..v_gucd_rg_list.COUNT
            LOOP
                v_item_no   := v_gucd_rg_list(b1).item_no;
                
                FOR b2 IN 1..v_temp_rg_list.COUNT
                LOOP
                    IF v_item_no = v_temp_rg_list(b2).item_no THEN
                        v_exists := TRUE;
                        v_gucd_rg_list(b1).gross_amt    := v_gucd_rg_list(b1).gross_amt + v_temp_rg_list(b2).gross_amt;
                        v_gucd_rg_list(b1).comm_amt     := v_gucd_rg_list(b1).comm_amt + v_temp_rg_list(b2).comm_amt;
                        v_gucd_rg_list(b1).amount       := v_gucd_rg_list(b1).amount + v_temp_rg_list(b2).amount;
                                              
                        --jason 04/18/2008: added the following code                    
                        v_gucd_rg_list(b1).vat_amt      := v_gucd_rg_list(b1).vat_amt + v_temp_rg_list(b2).vat_amt;
                        v_gucd_rg_list(b1).fc_gross_amt := v_gucd_rg_list(b1).fc_gross_amt + v_temp_rg_list(b2).fc_gross_amt;
                        v_gucd_rg_list(b1).fc_comm_amt  := v_gucd_rg_list(b1).fc_comm_amt + v_temp_rg_list(b2).fc_comm_amt;                      
                        v_gucd_rg_list(b1).fc_vat_amt   := v_gucd_rg_list(b1).fc_vat_amt + v_temp_rg_list(b2).fc_vat_amt;                            
                        EXIT;
                    END IF;
                END LOOP b2;
            END LOOP b1;
        END IF;
        
        v_temp_rg_list.DELETE(1, v_temp_rg_list.COUNT);
        
        IF v_rem_amount = 0 THEN
            GOTO end_of_proc;
        ELSE
            GOTO final_loop;
        END IF; 
        
        <<end_of_proc>>
        FOR b1 IN 1..v_gucd_rg_list.COUNT
        LOOP
            v_item_no   := v_gucd_rg_list(b1).item_no;
            
            FOR b2 IN 1..v_colln_dtl_rg_list.COUNT
            LOOP
                IF v_item_no = v_colln_dtl_rg_list(b2).item_no THEN
                    v_colln_dtl_rg_list(b2).pay_mode        := v_gucd_rg_list(b1).pay_mode;        
                    v_colln_dtl_rg_list(b2).check_class     := v_gucd_rg_list(b1).check_class;        
                    v_colln_dtl_rg_list(b2).check_date      := v_gucd_rg_list(b1).check_date;                        
                    v_colln_dtl_rg_list(b2).check_no        := v_gucd_rg_list(b1).check_no;
                    v_colln_dtl_rg_list(b2).particulars     := v_gucd_rg_list(b1).particulars;
                    v_colln_dtl_rg_list(b2).bank_cd         := v_gucd_rg_list(b1).bank_cd;
                    --set_group_char_cell('colln_dtl_rg.currency_cd := v_gucd_rg_list(b1).currency_cd;   --modified by alfie
                    --set_group_char_cell('colln_dtl_rg.convert_rt := v_gucd_rg_list(b1).currency_rt;    --user get_group_number_cell instead of
                    v_colln_dtl_rg_list(b2).currency_cd     := v_gucd_rg_list(b1).currency_cd; --get_group_char_cell to avoid
                    v_colln_dtl_rg_list(b2).convert_rate    := v_gucd_rg_list(b1).currency_rt;--error 04062010
                    EXIT;
                END IF;
            END LOOP b2;
        END LOOP b1;
    END create_or_colln_dtl;
    
    
    PROCEDURE gen_individual_or(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class    GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_dcb_no            GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE,
        p_or_date           giac_order_of_payts.or_date%TYPE
    )
    AS
        v_exists                BOOLEAN := FALSE;

        --acctrans
        v_tran_flag             giac_acctrans.tran_flag%TYPE;
        v_tran_year             giac_acctrans.tran_year%TYPE;
        v_tran_month            giac_acctrans.tran_month%TYPE; 
        v_tran_seq_no           giac_acctrans.tran_seq_no%TYPE;
        v_tran_class              giac_acctrans.tran_class%TYPE;  
        v_tran_class_no         giac_acctrans.tran_class_no%TYPE;  

        --order of payts
        v_cashier_cd             giac_order_of_payts.cashier_cd%TYPE;

        --collection dtl
        v_item_no                  giac_upload_colln_dtl.item_no%TYPE;
        v_currency_cd            giac_collection_dtl.currency_cd%TYPE;
        v_currency_rt            giac_collection_dtl.currency_rt%TYPE;
        v_pay_mode                giac_collection_dtl.pay_mode%TYPE;
        v_amount                giac_collection_dtl.amount%TYPE;
        v_gross_amt                giac_collection_dtl.gross_amt%TYPE;
        v_comm_amt                giac_collection_dtl.commission_amt%TYPE;
        v_check_class            giac_collection_dtl.check_class%TYPE;
        v_check_date            giac_collection_dtl.check_date%TYPE;
        v_check_no                giac_collection_dtl.check_no%TYPE;
        v_particulars            giac_collection_dtl.particulars%TYPE;
        v_bank_cd                giac_collection_dtl.bank_cd%TYPE;
        v_dcb_bank_cd           giac_collection_dtl.DCB_BANK_CD%type;
        v_dcb_bank_acct_cd      giac_collection_dtl.DCB_BANK_ACCT_CD%type;
            
        --jason 04/18/2008: added the following variables
        v_curr_cd                giac_collection_dtl.currency_cd%TYPE;
        v_curr_rt                giac_collection_dtl.currency_rt%TYPE;
        v_fc_gross_amt          giac_collection_dtl.fc_gross_amt%TYPE;
        v_fc_comm_amt            giac_collection_dtl.fc_comm_amt%TYPE;
        v_fc_vat_amt            giac_collection_dtl.fc_tax_amt%TYPE;
        v_vat_amt                giac_collection_dtl.vat_amt%TYPE;
        v_fcurrency_amt            giac_collection_dtl.fcurrency_amt%TYPE;
        
        --john 9.16.2016: for checking of amount, gross_amt, and comm_amt
        v_check_amount          giac_collection_dtl.amount%TYPE;
        v_check_gross_amt       giac_collection_dtl.gross_amt%TYPE;
        v_check_comm_amt        giac_collection_dtl.commission_amt%TYPE;
        
        v_list          guf_tab;
        check_counter           NUMBER := 0;
        
        TYPE giac_upload_colln_dtl_tab     IS TABLE OF giac_upload_colln_dtl%ROWTYPE;
        v_list_gucd     giac_upload_colln_dtl_tab;
        
        TYPE giac_upload_prem_comm_tab IS TABLE OF giac_upload_prem_comm%ROWTYPE;
        v_list_gupc   giac_upload_prem_comm_tab;
        
        v_counter       NUMBER := 0;
        v_comm       giac_collection_dtl.amount%TYPE;
    BEGIN
        --get the cashier_cd
        FOR a IN (SELECT cashier_cd
                      FROM giac_dcb_users
                     WHERE dcb_user_id       = p_user_id
                         AND gibr_fund_cd   = p_fund_cd 
                         AND gibr_branch_cd = p_branch_cd)
        LOOP
            v_cashier_cd := a.cashier_cd;
            EXIT;
        END LOOP;
        
        SELECT *
          BULK COLLECT INTO v_list
          FROM TABLE (GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No));
        
--        FOR guf IN (SELECT *
--                      FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))

        SELECT *
          BULK COLLECT INTO v_list_gucd
          FROM giac_upload_colln_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        SELECT *
          BULK COLLECT INTO v_list_gupc
          FROM giac_upload_prem_comm
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
          
        

        FOR guf IN 1..v_list.COUNT
        LOOP
            v_counter := 0;
            --initialize variables for giac_acctrans
            v_tran_flag     := 'O';
            v_tran_year     := to_number(to_char(p_or_date,'YYYY'));
            v_tran_month    := to_number(to_char(p_or_date,'MM'));
            v_tran_class      := 'COL';
            v_tran_class_no := p_dcb_no;
            
            dbms_session.set_identifier(v_list(guf).source_cd||'-'||v_list(guf).file_no);
            
            --LOOP FOR DISTRIBUTION OF PAYMENT DETAILS
            FOR i IN 1..v_list_gupc.COUNT
            LOOP
               v_counter := 1;
               v_currency_cd := v_list_gupc(i).currency_cd; 
               v_currency_rt := v_list_gupc(i).convert_rate;
               
                SELECT acctran_tran_id_s.NEXTVAL
                  INTO GIACS607_PKG.v_tran_id
                  FROM sys.dual;
                      
                      
                GIACS607_PKG.v_tran_date := to_date(to_char(p_or_date, 'MM-DD-YYYY')||' '||to_char(SYSDATE,'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
                    
                v_tran_seq_no := giac_sequence_generation(p_fund_cd, p_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
                        
                        
                INSERT INTO giac_acctrans
                            (tran_id,               gfun_fund_cd,       gibr_branch_cd, 
                             tran_date,             tran_flag,          tran_year, 
                             tran_month,            tran_seq_no,        tran_class, 
                             tran_class_no,         user_id,            last_update)
                     VALUES
                            (GIACS607_PKG.v_tran_id,      p_fund_cd,      p_branch_cd, 
                             GIACS607_PKG.v_tran_date,  v_tran_flag,        v_tran_year,
                             v_tran_month,               v_tran_seq_no,    v_tran_class,       
                             v_tran_class_no,            p_user_id,         SYSDATE);
                        
                --*insert in giac_order_of_payts*--   
                INSERT INTO giac_order_of_payts
                            (gacc_tran_id,              gibr_gfun_fund_cd,  gibr_branch_cd,       payor, 
                             or_date,                   cashier_cd,         dcb_no,               or_flag, 
                             intm_no,                   collection_amt,     currency_cd,          gross_amt,
                             gross_tag,                 upload_tag,         user_id,              last_update)
                    VALUES
                            (GIACS607_PKG.v_tran_id,    p_fund_cd,          p_branch_cd,        v_list_gupc(i).payor,
                             GIACS607_PKG.v_tran_date,  v_cashier_cd,       p_dcb_no,           'N', 
                             v_list(guf).intm_no,       v_list_gupc(i).net_amt_due,   v_currency_cd, v_list_gupc(i).gross_prem_amt,  
                             v_list_gupc(i).gross_tag,       'Y',                p_user_id,          SYSDATE);
            
               v_comm := (v_list_gupc(i).comm_amt - v_list_gupc(i).whtax_amt) + v_list_gupc(i).input_vat_amt;
               IF v_list_gupc(i).net_amt_due = 0 THEN
                 EXIT;
               END IF; 
               
               FOR j IN 1..v_list_gucd.COUNT
               LOOP
                  IF v_list_gucd(j).amount = 0 THEN
                    --CONTINUE;
                    GOTO next_v_list1;
                  END IF;
                  
                  IF v_list_gupc(i).net_amt_due = 0 THEN
                     --CONTINUE;
                    GOTO next_v_list1;
                  END IF;
                  
                  IF v_list_gupc(i).net_amt_due >= v_list_gucd(j).amount THEN
                     v_amount := v_list_gucd(j).amount;
                     v_list_gupc(i).net_amt_due := v_list_gupc(i).net_amt_due - v_list_gucd(j).amount;
                     v_list_gucd(j).amount := 0;
                  
                  ELSE
                     v_amount := v_list_gupc(i).net_amt_due;
                     v_list_gucd(j).amount := v_list_gucd(j).amount - v_list_gupc(i).net_amt_due;
                     v_list_gupc(i).net_amt_due := 0;
                  END IF;
                  
                  IF v_comm >= v_list_gucd(j).commission_amt THEN
                     v_comm_amt := v_list_gucd(j).commission_amt;
                     v_comm := v_comm - v_list_gucd(j).commission_amt;
                     v_list_gucd(j).commission_amt := 0;
                  
                  ELSE
                     v_comm_amt := v_comm;
                     v_list_gucd(j).commission_amt := v_list_gucd(j).commission_amt - v_comm;
                     v_comm := 0;
                  END IF;
                  
                  v_pay_mode      := v_list_gucd(j).pay_mode;
                  v_check_class   := v_list_gucd(j).check_class;        
                  v_check_date    := v_list_gucd(j).check_date;                
                  v_check_no      := v_list_gucd(j).check_no;
                  v_particulars   := v_list_gucd(j).particulars;
                  v_bank_cd       := v_list_gucd(j).bank_cd;
                  v_curr_cd       := v_list_gucd(j).currency_cd;  
                  v_curr_rt       := v_list_gucd(j).currency_rt; 
                  
                  v_item_no       := v_list_gucd(j).item_no;
                  v_gross_amt     := v_amount + v_comm_amt;
                  v_vat_amt       := v_list_gucd(j).vat_amt; 
                  v_fc_gross_amt  := NVL(ROUND(v_gross_amt/v_curr_rt,2),0);  
                  v_fc_comm_amt   := NVL(ROUND(v_comm_amt/v_curr_rt,2),0);      
                  v_fc_vat_amt    := NVL(ROUND(v_vat_amt/v_curr_rt,2),0);  
                  v_fcurrency_amt := NVL(ROUND(v_amount/v_curr_rt,2),0);
                  
                  
                  v_dcb_bank_cd       := NULL;
                  v_dcb_bank_acct_cd  := NULL;
                      
                  FOR gucd IN (SELECT *
                                 FROM GIAC_UPLOAD_COLLN_DTL
                                WHERE source_cd = v_list(guf).source_cd
                                  AND file_no = v_list(guf).file_no
                                  AND item_no = v_item_no)
                  LOOP     
                      v_dcb_bank_cd       := gucd.dcb_bank_cd;
                      v_dcb_bank_acct_cd  := gucd.dcb_bank_acct_cd;
                      EXIT;
                  END LOOP;
                  
                  --insert here
                    INSERT INTO giac_collection_dtl
                                (gacc_tran_id, item_no, currency_cd, currency_rt,
                                 pay_mode, amount, gross_amt, commission_amt, vat_amt,
                                 fcurrency_amt, fc_gross_amt, fc_comm_amt, fc_tax_amt,
                                 check_class, check_date, check_no, particulars,
                                 bank_cd, due_dcb_no, due_dcb_date,
                                 user_id, last_update, dcb_bank_cd, dcb_bank_acct_cd
                                )
                         VALUES (giacs607_pkg.v_tran_id, v_counter, v_currency_cd, v_currency_rt,
                                 v_pay_mode, v_amount, v_gross_amt, v_comm_amt, v_vat_amt,
                                 v_fcurrency_amt, v_fc_gross_amt, v_fc_comm_amt, v_fc_vat_amt,
                                 v_check_class, v_check_date, v_check_no, v_particulars,
                                 v_bank_cd, p_dcb_no, TRUNC (giacs607_pkg.v_tran_date),
                                 p_user_id, SYSDATE, v_dcb_bank_cd, v_dcb_bank_acct_cd
                                );
                                
                   v_counter := v_counter + 1;
                   
               <<next_v_list1>>
               NULL;    
               END LOOP;
               
               --*generate acct entries for the O.R.*--
                upload_dpc_web.aeg_parameters(GIACS607_PKG.v_tran_id, p_branch_cd, p_fund_cd, 'GIACS001', p_user_id);
                                    
                --Process the payments for premium collns, commission, prem deposit, etc.
                --delete_group_row(rg_id2, ALL_ROWS);
                v_acct_assd_list.DELETE(1, v_acct_assd_list.COUNT);
                
                --nieko Accounting Uploading
                --GIACS607_PKG.process_payments (v_list(guf).source_cd, v_list(guf).file_no, p_nbt_tran_class, v_list_gupc(i).payor, v_list_gupc(i).gross_tag, 
                --                                p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3, p_user_id);
                giacs607_pkg.process_payments2 (v_list (guf).source_cd,
                                               v_list (guf).file_no,
                                               p_nbt_tran_class,
                                               v_list_gupc (i).payor,
                                               v_list_gupc (i).gross_tag,
                                               p_sl_type_cd1,
                                               p_sl_type_cd2,
                                               p_sl_type_cd3,
                                               p_user_id,
                                               v_list_gupc (i).line_cd,
                                               v_list_gupc (i).subline_cd,
                                               v_list_gupc (i).iss_cd,
                                               v_list_gupc (i).issue_yy,
                                               v_list_gupc (i).pol_seq_no,
                                               v_list_gupc (i).renew_no,
                                               v_list_gupc (i).endt_iss_cd,
                                               v_list_gupc (i).endt_yy,
                                               v_list_gupc (i).endt_seq_no
                                              );
                
                --nieko end
                
                --update the table giac_upload_prem_comm
                UPDATE giac_upload_prem_comm
                   SET tran_id   = GIACS607_PKG.v_tran_id,
                       tran_date = GIACS607_PKG.v_tran_date
                 WHERE source_cd =  v_list(guf).source_cd
                   AND file_no   =  v_list(guf).file_no
                   AND payor     = v_list_gupc(i).payor
                   AND gross_tag = v_list_gupc(i).gross_tag
                   AND line_cd      =   v_list_gupc (i).line_cd
                   AND subline_cd   =   v_list_gupc (i).subline_cd
                   AND iss_cd       =   v_list_gupc (i).iss_cd
                   AND issue_yy     =   v_list_gupc (i).issue_yy
                   AND pol_seq_no   =   v_list_gupc (i).pol_seq_no
                   AND renew_no     =   v_list_gupc (i).renew_no
                   AND endt_iss_cd  =   v_list_gupc (i).endt_iss_cd
                   AND endt_yy      =   v_list_gupc (i).endt_yy
                   AND endt_seq_no  =   v_list_gupc (i).endt_seq_no;
               
            END LOOP;
            
            v_check_amount      := 0;
            v_check_gross_amt   := 0;
            v_check_comm_amt    := 0;
            
            --check the record group gucd_rg if there is a remaining amount
            
            SELECT item_no, pay_mode, bank_cd, check_class, check_no, check_date,
                currency_cd, currency_rt, particulars,
                nvl(amount,0) amount, nvl(gross_amt,0) gross_amt,
                --(nvl(commission_amt,0) + nvl(vat_amt,0)) comm_amt, --alfie 04092010
                nvl(commission_amt,0) comm_amt,
                nvl(vat_amt,0) vat_amt ,                     
                fc_gross_amt, fc_comm_amt, fc_vat_amt
              BULK COLLECT INTO v_gucd_rg_list
              FROM giac_upload_colln_dtl 
             WHERE source_cd= p_source_cd 
               AND file_no = p_file_no 
            ORDER BY item_no;
            
            FOR gucd_rg_rec IN 1..v_gucd_rg_list.COUNT
            LOOP
                v_check_amount      := v_check_amount + v_gucd_rg_list(gucd_rg_rec).amount;
                v_check_gross_amt   := v_check_gross_amt + v_gucd_rg_list(gucd_rg_rec).gross_amt;
                v_check_comm_amt    := v_check_comm_amt + v_gucd_rg_list(gucd_rg_rec).comm_amt;
            END LOOP;
            
            FOR i IN (
                SELECT SUM(comm_amt + input_vat_amt - whtax_amt) COMM_AMT, SUM(NET_AMT_DUE) AMOUNT, SUM(GROSS_PREM_AMT) GROSS_AMT
                  FROM giac_upload_prem_comm
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no
            )
            LOOP
               IF v_check_amount <> i.amount OR v_check_gross_amt <> i.gross_amt OR v_check_comm_amt <> i.comm_amt THEN
                   v_exists := TRUE;
               END IF;
                
            END LOOP;

            IF v_exists THEN
                raise_application_error (-20001,'Geniisys Exception#E#Collection detail amounts were not fully distributed.');
            END IF;    

          --delete record from table giac_upload_dv_payt_dtl and 
          --giac_upload_jv_payt_dtl since OR was created
            DELETE FROM giac_upload_dv_payt_dtl
             WHERE source_cd = v_list(guf).source_cd
               AND file_no = v_list(guf).file_no;
                   
            DELETE FROM giac_upload_jv_payt_dtl
             WHERE source_cd = v_list(guf).source_cd
               AND file_no = v_list(guf).file_no;

            --update the table giac_upload_file
            UPDATE giac_upload_file
               SET upload_date = SYSDATE,
                   file_status = '2',
                   tran_class  = v_tran_class,
                   tran_date   = trunc(GIACS607_PKG.v_tran_date)
             WHERE source_cd = v_list(guf).source_cd
               AND file_no   = v_list(guf).file_no;
        END LOOP guf;
    END gen_individual_or;
    
    
    PROCEDURE gen_dv(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class    GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE
    )
    AS
        --acctrans
        v_tran_flag         giac_acctrans.tran_flag%TYPE;
        v_tran_class          giac_acctrans.tran_class%TYPE;  

        --giac_payt_requests
        v_gouc_ouc_id        giac_payt_requests.gouc_ouc_id%TYPE;
        v_ref_id            giac_payt_requests.ref_id%TYPE;
        v_document_cd       giac_payt_requests.document_cd%TYPE;
        v_branch_cd         giac_payt_requests.branch_cd%TYPE;
        v_doc_seq_no        giac_payt_requests.doc_seq_no%TYPE;    
        v_request_date      giac_payt_requests.request_date%TYPE;
        v_dv_line_cd        giac_payt_requests.line_cd%TYPE;
        v_doc_year            giac_payt_requests.doc_year%TYPE;
        v_doc_mm            giac_payt_requests.doc_mm%TYPE;
                
        --giac_payt_requests_dtl
        v_req_dtl_no            giac_payt_requests_dtl.req_dtl_no%TYPE := 1;
        v_payee_class_cd        giac_payt_requests_dtl.payee_class_cd%TYPE;
        v_payee_cd                giac_payt_requests_dtl.payee_cd%TYPE;
        v_payee                    giac_payt_requests_dtl.payee%TYPE;
        v_currency_cd            giac_payt_requests_dtl.currency_cd%TYPE;
        v_currency_rt            giac_payt_requests_dtl.currency_rt%TYPE;
        v_dv_fcurrency_amt        giac_payt_requests_dtl.payt_amt%TYPE;
        v_payt_amt                giac_payt_requests_dtl.payt_amt%TYPE;
        v_particulars            giac_payt_requests_dtl.particulars%TYPE;
        
        v_count                 NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO v_count
          FROM GIAC_UPLOAD_PREM_COMM
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        IF v_count = 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No records found for upload.');
        END IF;
        
        --get the values to be used
        BEGIN
            SELECT request_date,            gouc_ouc_id,        document_cd,        branch_cd,
                   line_cd,             doc_year,              doc_mm,                    payee_class_cd,         
                   payee_cd,            payee,                    currency_cd,        currency_rt,
                   dv_fcurrency_amt,    payt_amt,                particulars                         
              INTO v_request_date,      v_gouc_ouc_id,  v_document_cd,    v_branch_cd, 
                   v_dv_line_cd,        v_doc_year,            v_doc_mm,              v_payee_class_cd,  
                   v_payee_cd,          v_payee,                v_currency_cd,    v_currency_rt,         
                   v_dv_fcurrency_amt,  v_payt_amt,            v_particulars                         
                FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd
                  AND file_no = p_file_no;
        EXCEPTION
            WHEN no_data_found THEN
                raise_application_error (-20001, 'Geniisys Exception#E#No data found in table: giac_upload_dv_payt_dtl.');
           END;    
        
                --*insert in giac_acctrans*--
        SELECT acctran_tran_id_s.NEXTVAL
          INTO GIACS607_PKG.v_tran_id
          FROM sys.dual;
                
        v_tran_flag  := 'O';
        v_tran_class := 'DV';
        GIACS607_PKG.v_tran_date := v_request_date;
            
        INSERT INTO giac_acctrans
                    (tran_id,                   gfun_fund_cd,   gibr_branch_cd, tran_flag,
                     tran_date,                 tran_class,     user_id,        last_update)
             VALUES
                    (GIACS607_PKG.v_tran_id,    p_fund_cd,      v_branch_cd,    v_tran_flag,
                     GIACS607_PKG.v_tran_date,  v_tran_class,   p_user_id,         SYSDATE);
                     
        --*insert in giac_payt_requests*--
        SELECT gprq_ref_id_s.NEXTVAL
          INTO v_ref_id
          FROM sys.dual;

        INSERT INTO giac_payt_requests
                    (gouc_ouc_id,    ref_id,          fund_cd,          branch_cd,       
                     document_cd,    request_date,    line_cd,          doc_year,
                     doc_mm,         with_dv,         upload_tag,       create_by,
                     user_id,        last_update)
             VALUES
                    (v_gouc_ouc_id,  v_ref_id,        p_fund_cd,        v_branch_cd,  
                     v_document_cd,  v_request_date,  v_dv_line_cd,     v_doc_year,
                     v_doc_mm,       'N',             'Y',                p_user_id,               
                     p_user_id,      SYSDATE);
                     
                --*insert in giac_payt_requests_dtl*--
        INSERT INTO giac_payt_requests_dtl
                    (req_dtl_no,          gprq_ref_id,  payee_class_cd,         payt_req_flag,
                     payee_cd,            payee,        currency_cd,            currency_rt,
                     dv_fcurrency_amt,    payt_amt,      tran_id,                particulars,  
                     user_id,             last_update)
            VALUES
                    (v_req_dtl_no,        v_ref_id,     v_payee_class_cd,       'N',  
                     v_payee_cd,          v_payee,      v_currency_cd,          v_currency_rt,
                     v_dv_fcurrency_amt,  v_payt_amt,   GIACS607_PKG.v_tran_id,  v_particulars,
                     p_user_id,           SYSDATE);
                     
        BEGIN
            SELECT doc_seq_no 
              INTO v_doc_seq_no
              FROM giac_payt_requests
             WHERE ref_id = v_ref_id;
        EXCEPTION
            WHEN OTHERS THEN
                raise_application_error (-20001, 'Geniisys Exception#I#Error retrieving DOC_SEQ_NO.');
        END;    

        -- jenny vi lim 12062005  to set the branch_cd based on the chosen branch of the user.        
        upload_dpc_web.set_fixed_variables(p_fund_cd, v_branch_cd, giacp.n('EVAT'));

        --*Process the payments for premium collns, commission, prem deposit, etc.*--
        GIACS607_PKG.process_payments(p_source_cd, p_file_no, p_nbt_tran_class, null, null, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3, p_user_id);

        --update the table giac_upload_dv_payt_dtl
        UPDATE giac_upload_dv_payt_dtl
           SET doc_seq_no = v_doc_seq_no
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;

        --delete records from table giac_upload_colln_dtl and 
        --giac_upload_jv_payt_dtl since DV request was created
        DELETE FROM giac_upload_colln_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
        
        DELETE FROM giac_upload_jv_payt_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;

                        
        --update the table giac_upload_prem_comm
        UPDATE giac_upload_prem_comm
           SET tran_id = GIACS607_PKG.v_tran_id,
               tran_date = GIACS607_PKG.v_tran_date
         WHERE source_cd  = p_source_cd
           AND file_no    = p_file_no;                                  

        --update the table giac_upload_file
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = '2',
               tran_class  = v_tran_class,
               tran_id     = GIACS607_PKG.v_tran_id,
               tran_date   = GIACS607_PKG.v_tran_date,
               gross_tag   = NULL
        WHERE source_cd = p_source_cd
          AND file_no   = p_file_no;
          
    END gen_dv;
    
    
    PROCEDURE gen_jv(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class    GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE
    )
    AS
        --acctrans
        v_branch_cd      giac_acctrans.gibr_branch_cd%TYPE;
        v_tran_year      giac_acctrans.tran_year%TYPE;
        v_tran_month     giac_acctrans.tran_month%TYPE;
        v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
        v_tran_date      giac_acctrans.tran_date%TYPE;
        v_jv_pref_suff     giac_acctrans.jv_pref_suff%TYPE;  
        v_jv_no             giac_acctrans.jv_no%TYPE;  
        v_particulars        giac_acctrans.particulars%TYPE;
        v_jv_tran_tag     giac_acctrans.jv_tran_tag%TYPE;
        v_jv_tran_type   giac_acctrans.jv_tran_type%TYPE;
        v_jv_tran_mm     giac_acctrans.jv_tran_mm%TYPE;
        v_jv_tran_yy     giac_acctrans.jv_tran_yy%TYPE;
        v_tran_flag      giac_acctrans.tran_flag%TYPE;
        v_tran_class       giac_acctrans.tran_class%TYPE;  
        v_tran_class_no  giac_acctrans.tran_class_no%TYPE;
        
        v_count          NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO v_count
          FROM GIAC_UPLOAD_PREM_COMM
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        IF v_count = 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No records found for upload.');
        END IF;
        
                --get the values to be used
        BEGIN
            SELECT branch_cd,       tran_date,      tran_year,      tran_month, 
                   jv_pref_suff,    particulars,    jv_tran_tag,    jv_tran_type,
                   jv_tran_mm,      jv_tran_yy
              INTO v_branch_cd,     v_tran_date,    v_tran_year,    v_tran_month, 
                   v_jv_pref_suff,  v_particulars,  v_jv_tran_tag,  v_jv_tran_type,
                   v_jv_tran_mm,    v_jv_tran_yy
                FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd
                  AND file_no = p_file_no;
        EXCEPTION
            WHEN no_data_found THEN
                raise_application_error (-20001, 'Geniisys Exception#E#No data found in table: giac_upload_jv_payt_dtl.');
           END;        

        --*insert in giac_acctrans*--
        SELECT acctran_tran_id_s.NEXTVAL
          INTO GIACS607_PKG.v_tran_id
          FROM sys.dual;
          
        v_tran_flag     := 'O';
        v_tran_class    := 'JV';
        v_tran_class_no := giac_sequence_generation(p_fund_cd, v_branch_cd, v_tran_class, v_tran_year, v_tran_month);
        v_jv_no            := v_tran_class_no;    
        GIACS607_PKG.v_tran_date := v_tran_date;

        INSERT INTO giac_acctrans
                    (tran_id,                   gfun_fund_cd,       gibr_branch_cd, tran_flag,
                     tran_date,                 tran_year,          tran_month,     tran_class,                
                     tran_class_no,             jv_pref_suff,        jv_no,          particulars,
                     jv_tran_tag,                jv_tran_type,       jv_tran_mm,     jv_tran_yy,
                     ae_tag,                    upload_tag,         user_id,        last_update)
             VALUES
                    (GIACS607_PKG.v_tran_id,    p_fund_cd,          v_branch_cd,    v_tran_flag,
                     v_tran_date,               v_tran_year,        v_tran_month,   v_tran_class,                    
                     v_tran_class_no,           v_jv_pref_suff,     v_jv_no,        v_particulars,
                     v_jv_tran_tag,                v_jv_tran_type,     v_jv_tran_mm,   v_jv_tran_yy,
                     'N',                       'Y',                p_user_id,      SYSDATE);

        -- jenny vi lim 12062005  to set the branch_cd based on the chosen branch of the user.        
        upload_dpc_web.set_fixed_variables(p_fund_cd, v_branch_cd, giacp.n('EVAT'));

        --*Process the payments for premium collns, commission, prem deposit, etc.*--
        GIACS607_PKG.process_payments(p_source_cd, p_file_no, p_nbt_tran_class, null, null, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3, p_user_id);

        --update the table giac_upload_jv_payt_dtl
        UPDATE giac_upload_jv_payt_dtl
           SET jv_no = v_jv_no
         WHERE source_cd = p_source_cd
              AND file_no = p_file_no;

        --delete records from table giac_upload_colln_dtl and 
        --giac_upload_jv_payt_dtl since DV request was created
        DELETE FROM giac_upload_colln_dtl
         WHERE source_cd = p_source_cd
              AND file_no = p_file_no;
         
        DELETE FROM giac_upload_dv_payt_dtl
         WHERE source_cd = p_source_cd
              AND file_no = p_file_no;
        
        --update the table giac_upload_prem_comm
        UPDATE giac_upload_prem_comm
           SET tran_id = GIACS607_PKG.v_tran_id,
               tran_date = GIACS607_PKG.v_tran_date
         WHERE source_cd  = p_source_cd
              AND file_no    = p_file_no;                                  

        --update the table giac_upload_file
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = '2',
               tran_class  = v_tran_class,
               tran_id     = GIACS607_PKG.v_tran_id,
               tran_date   = GIACS607_PKG.v_tran_date,
               gross_tag   = NULL
         WHERE source_cd = p_source_cd
              AND file_no   = p_file_no;
    
    END gen_jv;
    
    PROCEDURE upload_payments(
        p_source_cd                 GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no                   GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_dcb_no                    GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_sl_type_cd1               giac_parameters.param_name%TYPE,
        p_sl_type_cd2               giac_parameters.param_name%TYPE,
        p_sl_type_cd3               giac_parameters.param_name%TYPE,
        p_user_id                   VARCHAR2,
        p_or_date                   VARCHAR2
    )
    AS
        v_fund_cd       giac_acct_entries.gacc_gfun_fund_cd%TYPE := giacp.v('FUND_CD');
        v_branch_cd     giac_acct_entries.gacc_gibr_branch_cd%TYPE;
        
        v_list          guf_tab;
        
        v_exist     VARCHAR2(1);
        v_dcb_no    GIAC_COLLN_BATCH.dcb_no%TYPE;
    BEGIN        
        BEGIN
            SELECT a.grp_iss_cd
              INTO v_branch_cd
              FROM giis_user_grp_hdr a,
                   giis_users b
             WHERE a.user_grp = b.user_grp
               AND b.user_id = P_USER_ID;      
        EXCEPTION
            WHEN no_data_found THEN
                v_branch_cd := NULL;
        END;
        
        SELECT *
          BULK COLLECT INTO v_list
          FROM TABLE (GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No));
        
        FOR guf IN 1 .. v_list.COUNT 
--        FOR guf IN (SELECT *
--                      FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))
        LOOP
            IF p_nbt_tran_class = 'COL' THEN
                
                upload_dpc_web.check_tran_mm (TO_DATE(p_or_date,'MM-DD-YYYY'));
                upload_dpc_web.get_dcb_no2 (TO_DATE(p_or_date,'MM-DD-YYYY'), v_dcb_no, v_exist);
                
                giacs607_pkg.v_tran_date :=
                TO_DATE (   TO_CHAR (TO_DATE(p_or_date,'MM-DD-YYYY'), 'MM-DD-YYYY')
                         || ' '
                         || TO_CHAR (SYSDATE, 'HH:MI:SS AM'),
                         'MM-DD-YYYY HH:MI:SS AM'
                        );
            
                IF v_exist = 'N'
                THEN
                   FOR a IN (SELECT (NVL (MAX (dcb_no), 0) + 1) new_dcb_no
                               FROM giac_colln_batch
                              WHERE fund_cd = v_fund_cd
                                AND branch_cd = v_branch_cd
                                AND dcb_year =
                                        TO_NUMBER (TO_CHAR (TO_DATE(p_or_date,'MM-DD-YYYY'), 'YYYY')))
                   LOOP
                      v_dcb_no := a.new_dcb_no;
                      EXIT;
                   END LOOP;
                    
                   upload_dpc_web.create_dcb_no (v_dcb_no,
                                                 giacs607_pkg.v_tran_date,
                                                 v_fund_cd,
                                                 v_branch_cd,
                                                 p_user_id
                                                );
                END IF;
            
                IF v_list(guf).nbt_or_tag = 'G' THEN
                    GIACS607_PKG.gen_group_or2(v_list(guf).source_cd, v_list(guf).file_no, p_nbt_tran_class, v_dcb_no, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3,
                                                v_fund_cd, v_branch_cd, p_user_id, TO_DATE(p_or_date,'MM-DD-YYYY'));
                ELSE
                    GIACS607_PKG.gen_individual_or(v_list(guf).source_cd, v_list(guf).file_no, p_nbt_tran_class, v_dcb_no, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3,
                                                    v_fund_cd, v_branch_cd, p_user_id, TO_DATE(p_or_date,'MM-DD-YYYY'));
--                    raise_application_error (-20001,  v_list(guf).file_no || '-' || p_dcb_no );
                END IF;
            ELSIF p_nbt_tran_class = 'DV' THEN
                GIACS607_PKG.gen_dv(v_list(guf).source_cd, v_list(guf).file_no, p_nbt_tran_class, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3,
                                    v_fund_cd, v_branch_cd, p_user_id);
            ELSIF p_nbt_tran_class = 'JV' THEN
                GIACS607_PKG.gen_jv(v_list(guf).source_cd, v_list(guf).file_no, p_nbt_tran_class, p_sl_type_cd1, p_sl_type_cd2, p_sl_type_cd3,
                                    v_fund_cd, v_branch_cd, p_user_id);
            END IF;
        END LOOP;
        
    END upload_payments;
    
        
    PROCEDURE validate_on_print_btn(
        p_source_cd         IN  GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           IN  GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_user_id           IN  GIAC_UPLOAD_FILE.USER_ID%TYPE,
        p_branch_cd         OUT giac_upload_dv_payt_dtl.BRANCH_CD%TYPE,
        p_branch_name       OUT giac_branches.BRANCH_NAME%TYPE,
        p_gacc_tran_id      OUT giac_upload_colln_dtl.TRAN_ID%TYPE,
        p_doc_cd            OUT giac_upload_dv_payt_dtl.DOCUMENT_CD%TYPE,
        p_gprq_ref_id       OUT giac_payt_requests_dtl.gprq_ref_id%TYPE,
        p_upload_query      OUT VARCHAR2
        
    )
    AS
    BEGIN
        FOR guf IN (SELECT *
                      FROM TABLE(GIACS607_PKG.GET_GUF_DETAILS(p_source_Cd, p_file_No)))
        LOOP
            IF guf.tran_class = 'COL' THEN
                BEGIN
                    SELECT c.gibr_branch_cd, c.gacc_tran_id
                      INTO p_branch_cd, p_gacc_tran_id
                      FROM giac_order_of_payts c, giac_upload_prem_comm b, giac_upload_file a  
                     WHERE 1=1
                       AND b.tran_id = c.gacc_tran_id
                       AND a.source_cd = b.source_cd
                       AND a.file_no = b.file_no 
                       AND a.source_cd = guf.source_cd
                       AND a.file_no = guf.file_no
                       AND ROWNUM = 1;
                EXCEPTION 
                    WHEN no_data_found THEN
                      raise_application_error (-20001, 'Geniisys Exception#E#O.R. does not exist in table: giac_order_of_payts.');
                END;   
                
                --nieko Accounting Uploading
                p_upload_query :=
                    'SELECT c.gacc_tran_id '
                 || 'FROM giac_order_of_payts c, giac_upload_prem_comm b, giac_upload_file a '
                 || 'WHERE 1 = 1 '
                 || 'AND b.tran_id = c.gacc_tran_id '
                 || 'AND a.source_cd = b.source_cd '
                 || 'AND a.file_no = b.file_no '
                 || 'AND a.source_cd = '''
                 || guf.source_cd
                 || ''''
                 || 'AND a.file_no = '
                 || guf.file_no;
                
            ELSIF guf.tran_class = 'DV' THEN
                FOR gudv IN (SELECT *
                               FROM TABLE(GIACS607_PKG.GET_GUDV_DETAILS(p_source_Cd, p_file_No)) )
                LOOP
                    IF check_user_per_iss_cd_acctg2(NULL,gudv.branch_cd,'GIACS016', p_user_id) = 0 THEN
                        raise_application_error (-20001, 'Geniisys Exception#E#You are not allowed to access disbursement requests for '||gudv.branch_cd||' branch.');
                    END IF;
                    
                    BEGIN
                        SELECT gprq_ref_id
                          INTO p_gprq_ref_id
                          FROM giac_payt_requests_dtl
                         WHERE tran_id = guf.tran_id
                           AND ROWNUM = 1;
                    EXCEPTION 
                        WHEN no_data_found THEN
                          raise_application_error (-20001, 'Geniisys Exception#E#Request does not exist in table: giac_payt_requests.');
                    END;   
                    
                    p_branch_cd := gudv.branch_cd;
                    p_doc_cd    := gudv.document_cd;
                END LOOP;
                
            ELSIF guf.tran_class = 'JV' THEN
                FOR gudv IN (SELECT *
                               FROM TABLE(GIACS607_PKG.GET_GUJV_DETAILS(p_source_Cd, p_file_No)) )
                LOOP                    
                    p_branch_cd := gudv.branch_cd;
                END LOOP;
            END IF;
            
            BEGIN
                SELECT branch_name
                  INTO p_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = giacp.v('FUND_CD')
                   AND branch_cd = p_branch_cd; 
            EXCEPTION
                WHEN no_data_found THEN
                  p_branch_name := NULL;
            END; 
        END LOOP;
    END validate_on_print_btn;
    
    --nieko Accounting Uploading
    PROCEDURE process_payments2 (
       p_source_cd        giac_upload_file.source_cd%TYPE,
       p_file_no          giac_upload_file.file_no%TYPE,
       p_nbt_tran_class   giac_upload_file.tran_class%TYPE,
       p_payor            giac_order_of_payts.payor%TYPE,
       p_gross_tag        giac_order_of_payts.gross_tag%TYPE,
       p_sl_type_cd1      giac_parameters.param_name%TYPE,
       p_sl_type_cd2      giac_parameters.param_name%TYPE,
       p_sl_type_cd3      giac_parameters.param_name%TYPE,
       p_user_id          giac_op_text.user_id%TYPE,
       p_line_cd          giac_upload_prem_comm.line_cd%TYPE,
       p_subline_cd       giac_upload_prem_comm.subline_cd%TYPE,
       p_iss_cd           giac_upload_prem_comm.iss_cd%TYPE,
       p_issue_yy         giac_upload_prem_comm.issue_yy%TYPE,
       p_pol_seq_no       giac_upload_prem_comm.pol_seq_no%TYPE,
       p_renew_no         giac_upload_prem_comm.renew_no%TYPE,
       p_endt_iss_cd      giac_upload_prem_comm.endt_iss_cd%TYPE,
       p_endt_yy          giac_upload_prem_comm.endt_yy%TYPE,
       p_endt_seq_no      giac_upload_prem_comm.endt_seq_no%TYPE
    )
    AS
       v_line_cd              gipi_polbasic.line_cd%TYPE;
       v_subline_cd           gipi_polbasic.subline_cd%TYPE;
       v_iss_cd               gipi_polbasic.iss_cd%TYPE;
       v_issue_yy             gipi_polbasic.issue_yy%TYPE;
       v_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE;
       v_renew_no             gipi_polbasic.renew_no%TYPE;
       v_endt_iss_cd          gipi_polbasic.endt_iss_cd%TYPE;
       v_endt_yy              gipi_polbasic.endt_yy%TYPE;
       v_endt_seq_no          gipi_polbasic.endt_seq_no%TYPE;
       v_payor                giac_order_of_payts.payor%TYPE;
       v_gross_prem_amt       giac_upload_prem_comm.gross_prem_amt%TYPE;
       v_comm_amt             giac_upload_prem_comm.comm_amt%TYPE;
       v_whtax_amt            giac_upload_prem_comm.whtax_amt%TYPE;
       v_invat_amt            giac_upload_prem_comm.input_vat_amt%TYPE;
       v_net_amt_due          giac_upload_prem_comm.net_amt_due%TYPE;
       v_gross_tag            giac_upload_prem_comm.gross_tag%TYPE;
       v_gprem_amt_due        giac_upload_prem_comm.gprem_amt_due%TYPE;
       v_comm_amt_due         giac_upload_prem_comm.comm_amt_due%TYPE;
       v_prem_chk_flag        giac_upload_prem_comm.prem_chk_flag%TYPE;
       v_comm_chk_flag        giac_upload_prem_comm.comm_chk_flag%TYPE;
       v_policy_id            gipi_polbasic.policy_id%TYPE;
       v_assd_no              giis_assured.assd_no%TYPE;
       --others, premium
       v_prem_dep_amt         giac_upload_prem_comm.gross_prem_amt%TYPE;
       v_prem_dep_amt_comm    giac_upload_prem_comm.gross_prem_amt%TYPE;
       v_prem_dep_comm_tot    giac_upload_prem_comm.gross_prem_amt%TYPE   := 0;
       v_rem_gprem_amt        giac_upload_prem_comm.gross_prem_amt%TYPE;
       v_rem_comm_amt         giac_comm_payts.comm_amt%TYPE;
       v_rem_whtax_amt        giac_comm_payts.wtax_amt%TYPE;
       v_rem_invat_amt        giac_comm_payts.input_vat_amt%TYPE;
       --misc acct entries
       v_acct_payable_min     NUMBER             := giacp.n ('ACCTS_PAYABLE_MIN');
       v_premcol_exp_max      NUMBER               := giacp.n ('PREMCOL_EXP_MAX');
       v_commpayt_exp_max     NUMBER              := giacp.n ('COMMPAYT_EXP_MAX');
       v_aeg_item_no          giac_module_entries.item_no%TYPE;
       v_sl_cd                giac_acct_entries.sl_cd%TYPE;
       v_pay_rcv_assd_amt     giac_upload_prem_comm.gross_prem_amt%TYPE   := 0;
       v_dummy_exp_inc_amt    giac_upload_prem_comm.gross_prem_amt%TYPE;
       v_other_income_amt     giac_upload_prem_comm.gross_prem_amt%TYPE   := 0;
       v_other_expense_amt    giac_upload_prem_comm.gross_prem_amt%TYPE   := 0;
       v_other_exp_inc_amt    giac_upload_prem_comm.gross_prem_amt%TYPE   := 0;
       v_other_exp_inc_tot    giac_upload_prem_comm.gross_prem_amt%TYPE   := 0;
       v_pay_rcv_intm_amt     giac_upload_prem_comm.comm_amt%TYPE         := 0;
       v_other_exp_comm_amt   giac_upload_prem_comm.comm_amt%TYPE         := 0;
       --variables used for update of giac_order_of_payts
       v_policy_ctr           NUMBER                                      := 0;
       v_address1             giac_order_of_payts.address_1%TYPE;
       v_address2             giac_order_of_payts.address_2%TYPE;
       v_address3             giac_order_of_payts.address_3%TYPE;
       v_tin                  giac_order_of_payts.tin%TYPE;
       v_particulars          giac_order_of_payts.particulars%TYPE;
       v_payment_flag         NUMBER                                      := 0;
       --reymon 02072012
       v_parent_intm_no       giis_intermediary.parent_intm_no%TYPE;
    BEGIN
       FOR guf IN (SELECT *
                     FROM TABLE (giacs607_pkg.get_guf_details (p_source_cd,
                                                               p_file_no
                                                              )
                                ))
       LOOP
          v_parent_intm_no := giacs607_pkg.get_parent_intm_no (guf.intm_no);

          FOR gupc IN
             (SELECT *
                FROM TABLE (giacs607_pkg.get_gupc_records (guf.source_cd,
                                                           guf.file_no,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           NULL
                                                          )
                           ))
          LOOP
             v_payor := gupc.payor;
             v_gross_tag := gupc.gross_tag;
             v_line_cd := gupc.line_cd;
             v_subline_cd := gupc.subline_cd;
             v_iss_cd := gupc.iss_cd;
             v_issue_yy := gupc.issue_yy;
             v_pol_seq_no := gupc.pol_seq_no;
             v_renew_no := gupc.renew_no;
             v_endt_iss_cd := gupc.endt_iss_cd;
             v_endt_yy := gupc.endt_yy;
             v_endt_seq_no := gupc.endt_seq_no;

             --check the payor
             IF    ((NVL (p_payor, v_payor) = v_payor) AND (guf.nbt_or_tag = 'G')
                   )
                OR (    (    (NVL (p_line_cd, v_line_cd) = v_line_cd)
                         AND (NVL (p_subline_cd, v_subline_cd) = v_subline_cd)
                         AND (NVL (p_iss_cd, v_iss_cd) = v_iss_cd)
                         AND (NVL (p_issue_yy, v_issue_yy) = v_issue_yy)
                         AND (NVL (p_pol_seq_no, v_pol_seq_no) = v_pol_seq_no)
                         AND (NVL (p_renew_no, v_renew_no) = v_renew_no)
                         AND (NVL (p_endt_iss_cd, v_endt_iss_cd) = v_endt_iss_cd)
                         AND (NVL (p_endt_yy, v_endt_yy) = v_endt_yy)
                         AND (NVL (p_endt_seq_no, v_endt_seq_no) = v_endt_seq_no)
                        )
                    AND (guf.nbt_or_tag = 'I')
                   )
             THEN
                --initialize variables
                v_prem_dep_amt := 0;
                v_prem_dep_amt_comm := 0;
                --transfer values in record group to the variables
                v_gross_prem_amt := gupc.gross_prem_amt;
                v_comm_amt := gupc.comm_amt;
                v_whtax_amt := gupc.whtax_amt;
                v_invat_amt := gupc.input_vat_amt;
                v_net_amt_due := gupc.net_amt_due;
                v_gprem_amt_due := gupc.gprem_amt_due;
                v_comm_amt_due := gupc.comm_amt_due;
                v_prem_chk_flag := gupc.prem_chk_flag;
                v_comm_chk_flag := gupc.comm_chk_flag;
                v_policy_id := gupc.nbt_policy_id;
                v_assd_no := gupc.nbt_assd_no;

                --*PREMIUM*--
                --determine where the payment should be applied: prem_deposit or prem_colln
                IF v_prem_chk_flag IN ('SP', 'RI', 'EX', 'NA', 'IP')
                THEN                                            --premium deposit
                   v_prem_dep_amt := v_gross_prem_amt;
                ELSE                                          --premium collection
                   IF     v_gprem_amt_due < 0
                      AND v_gross_prem_amt > 0
                      AND v_prem_chk_flag IN ('OP', 'OC')
                   THEN                      --positive(excel) on negative(system)
                      IF v_gross_prem_amt >= v_acct_payable_min
                      THEN
                         --accounts payable
                         giacs607_pkg.update_acct_assd_rg (v_assd_no,
                                                           v_gross_prem_amt
                                                          );
                      ELSE
                         --other income
                         v_other_income_amt :=
                                            v_other_income_amt + v_gross_prem_amt;
                      END IF;
                   ELSIF v_prem_chk_flag IN
                                 ('OK', 'WC', 'PT', 'PC', 'OP', 'OC', 'ON', 'CO')
                   THEN
                      v_dummy_exp_inc_amt := 0;

                      --if partial payt and the diff is <= v_premcol_exp_max then pay the full amt and generate other expense/income
                      IF     v_prem_chk_flag IN ('PT', 'PC')
                         AND (ABS (v_gprem_amt_due - v_gross_prem_amt) <=
                                                                 v_premcol_exp_max
                             )
                      THEN
                         v_dummy_exp_inc_amt :=
                                               v_gprem_amt_due - v_gross_prem_amt;

                         IF v_gross_prem_amt > 0
                         THEN
                            --other expense
                            v_other_expense_amt :=
                                        v_other_expense_amt + v_dummy_exp_inc_amt;
                         ELSE
                            --other income
                            v_other_income_amt :=
                                   v_other_income_amt + ABS (v_dummy_exp_inc_amt);
                         END IF;
                      END IF;

                      --insert the payment for the bills of the policy in giac_direct_prem_collns
                      giacs607_pkg.insert_premium_collns (v_policy_id,
                                                          v_assd_no,
                                                            v_gross_prem_amt
                                                          + v_dummy_exp_inc_amt,
                                                          p_user_id,
                                                          v_rem_gprem_amt
                                                         );

                      --determine the acct entry to be generated for the remaining amount
                      IF v_prem_chk_flag IN ('OP', 'OC')
                      THEN
                         IF v_rem_gprem_amt >= v_acct_payable_min
                         THEN
                            --accounts payable
                            giacs607_pkg.update_acct_assd_rg (v_assd_no,
                                                              v_rem_gprem_amt
                                                             );
                         ELSE
                            --other income
                            v_other_income_amt :=
                                             v_other_income_amt + v_rem_gprem_amt;
                         END IF;
                      ELSIF v_prem_chk_flag IN ('ON', 'CO')
                      THEN
                         IF ABS (v_rem_gprem_amt) > v_premcol_exp_max
                         THEN
                            --accounts receivable
                            giacs607_pkg.update_acct_assd_rg (v_assd_no,
                                                              v_rem_gprem_amt
                                                             );
                         ELSE
                            --other expense
                            v_other_expense_amt :=
                                      v_other_expense_amt + ABS (v_rem_gprem_amt);
                         END IF;
                      END IF;
                   ELSIF v_prem_chk_flag IN ('FP', 'FC', 'CP', 'SL', 'NP')
                   THEN
                      giacs607_pkg.update_acct_assd_rg (v_assd_no,
                                                        v_gross_prem_amt
                                                       );
                   END IF;      --v_gprem_amt_due < 0 AND v_gross_prem_amt > 0 ...

                   --get the address and tin to use in update of giac_order_of_payts (for individual ORs only)
                   v_policy_ctr := v_policy_ctr + 1;

                   IF     p_nbt_tran_class = 'COL'
                      AND guf.nbt_or_tag = 'I'
                      AND v_policy_ctr = 1
                   THEN
                      FOR addr_rec IN (SELECT address1, address2, address3
                                         FROM gipi_polbasic
                                        WHERE address1 IS NOT NULL
                                          AND policy_id = v_policy_id)
                      LOOP
                         v_address1 := addr_rec.address1;
                         v_address2 := addr_rec.address2;
                         v_address3 := addr_rec.address3;
                      END LOOP addr_rec;

                      FOR tin_rec IN (SELECT assd_tin
                                        FROM giis_assured
                                       WHERE assd_no = v_assd_no)
                      LOOP
                         v_tin := tin_rec.assd_tin;
                      END LOOP;
                   END IF;                        --:guf.dsp_tran_class = 'COL'...
                END IF;            --v_prem_chk_flag IN ('SP','RI','EX','NA','IP')

                --*COMMISSION*--
                IF v_comm_chk_flag <> 'ZC'
                THEN                                             --v_comm_amt <> 0
                   IF v_comm_chk_flag IN ('SP', 'RI', 'EX', 'NA', 'IP')
                   THEN                                         --premium deposit
                      v_prem_dep_amt_comm :=
                                           v_comm_amt - v_whtax_amt + v_invat_amt;
                      v_prem_dep_comm_tot :=
                                        v_prem_dep_comm_tot + v_prem_dep_amt_comm;
                   ELSE                                               --comm payts
                      IF     v_comm_amt_due < 0
                         AND v_comm_amt > 0
                         AND v_comm_chk_flag = 'OP'
                      THEN                   --positive(excel) on negative(system)
                         IF v_comm_amt > v_commpayt_exp_max
                         THEN
                            --accounts receivable intm
                            v_pay_rcv_intm_amt :=
                                 v_pay_rcv_intm_amt
                               + (v_comm_amt - v_whtax_amt + v_invat_amt);
                         ELSE
                            --other expense comm
                            v_other_exp_comm_amt :=
                                 v_other_exp_comm_amt
                               + (v_comm_amt - v_whtax_amt + v_invat_amt);
                         END IF;
                      ELSIF v_comm_chk_flag IN
                                       ('OK', 'PT', 'OP', 'ON', 'WW', 'WV', 'WT')
                      THEN
                         giacs607_pkg.insert_comm_payts (v_policy_id,
                                                         v_comm_amt,
                                                         v_whtax_amt,
                                                         v_invat_amt,
                                                         guf.intm_no,
                                                         v_parent_intm_no,
                                                         p_nbt_tran_class,
                                                         guf.gross_tag,
                                                         guf.nbt_input_vat_rate,
                                                         'N',
                                                         p_user_id,
                                                         v_rem_comm_amt,
                                                         v_rem_whtax_amt,
                                                         v_rem_invat_amt
                                                        );

                         IF v_comm_chk_flag = 'OP'
                         THEN
                            IF v_rem_comm_amt > v_commpayt_exp_max
                            THEN
                               --accounts receivable intm
                               v_pay_rcv_intm_amt :=
                                              v_pay_rcv_intm_amt + v_rem_comm_amt;
                            ELSE
                               --other expense comm
                               v_other_exp_comm_amt :=
                                            v_other_exp_comm_amt + v_rem_comm_amt;
                            END IF;
                         ELSIF v_comm_chk_flag = 'ON'
                         THEN
                            --accounts payable intm
                            v_pay_rcv_intm_amt :=
                                              v_pay_rcv_intm_amt + v_rem_comm_amt;
                         END IF;

                         IF v_rem_whtax_amt > 0
                         THEN
                            --accounts payable intm
                            v_pay_rcv_intm_amt :=
                                         v_pay_rcv_intm_amt + v_rem_whtax_amt
                                                              * -1;
                         ELSIF v_rem_whtax_amt < 0
                         THEN
                            --accounts receivable intm
                            v_pay_rcv_intm_amt :=
                                       v_pay_rcv_intm_amt + ABS (v_rem_whtax_amt);
                         END IF;

                         IF v_rem_invat_amt > 0
                         THEN
                            --accounts receivable intm
                            v_pay_rcv_intm_amt :=
                                             v_pay_rcv_intm_amt + v_rem_invat_amt;
                         ELSIF v_rem_invat_amt < 0
                         THEN
                            --accounts payable intm
                            v_pay_rcv_intm_amt :=
                                             v_pay_rcv_intm_amt + v_rem_invat_amt;
                         END IF;
                      ELSIF v_comm_chk_flag IN ('NC', 'FP', 'CP', 'SL', 'NP')
                      THEN
                         v_pay_rcv_intm_amt :=
                              v_pay_rcv_intm_amt
                            + (v_comm_amt - v_whtax_amt + v_invat_amt);
                      END IF;              --v_comm_amt_due < 0 AND v_comm_amt > 0
                   END IF;         --v_comm_chk_flag IN ('SP','RI','EX','NA','IP')
                END IF;                                  --v_comm_chk_flag <> 'ZC'

                --*PREMIUM DEPOSIT (premium and commission)*--
                IF v_prem_dep_amt <> 0
                THEN
                   giacs607_pkg.insert_prem_deposit (v_policy_id,
                                                     v_assd_no,
                                                     v_line_cd,
                                                     v_subline_cd,
                                                     v_iss_cd,
                                                     v_issue_yy,
                                                     v_pol_seq_no,
                                                     v_renew_no,
                                                     v_endt_iss_cd,
                                                     v_endt_yy,
                                                     v_endt_seq_no,
                                                     v_prem_dep_amt,
                                                     v_prem_dep_amt_comm * -1,
                                                     p_user_id
                                                    );
                   NULL;
                END IF;
             END IF;
          END LOOP gupc;

             --*Premiums*--
          --generate the acct entries for the premium collns
          upload_dpc_web.gen_dpc_acct_entries (giacs607_pkg.v_tran_id,
                                               'GIACS007',
                                               p_user_id
                                              );

          --generate the op_text for the premium collns
          IF p_nbt_tran_class = 'COL'
          THEN
             giacs607_pkg.gen_dpc_op_text (p_user_id);
          END IF;

          --generate the acct entries for the accounts payable/accounts receivable from the premium collns
          giacs607_pkg.create_acct_assd_entries (p_user_id, v_pay_rcv_assd_amt);

          --generate the op_text for the accounts payable/accounts receivable
          IF p_nbt_tran_class = 'COL'
          THEN
             IF v_pay_rcv_assd_amt > 0
             THEN
                giacs607_pkg.gen_misc_op_text ('ACCOUNTS PAYABLE - ASSURED',
                                               v_pay_rcv_assd_amt,
                                               p_user_id
                                              );
             ELSIF v_pay_rcv_assd_amt < 0
             THEN
                giacs607_pkg.gen_misc_op_text ('ACCOUNTS RECEIVABLE - ASSURED',
                                               v_pay_rcv_assd_amt,
                                               p_user_id
                                              );
             END IF;
          END IF;

          --get the value for other income/expense
          v_other_exp_inc_amt := v_other_income_amt - v_other_expense_amt;
          --for op_text
          v_other_exp_inc_tot :=
                   v_other_income_amt - v_other_expense_amt - v_other_exp_comm_amt;
                                                                --for acct_entries
          --*Commission*--
          --generate the acct entries for the commission
          upload_dpc_web.aeg_parameters_comm (giacs607_pkg.v_tran_id,
                                              'GIACS020',
                                              p_sl_type_cd1,
                                              p_sl_type_cd2,
                                              p_sl_type_cd3,
                                              p_user_id
                                             );

          --generate the acct entries for the accounts payable/accounts receivable for the intermediary
          IF v_pay_rcv_intm_amt <> 0
          THEN
             v_sl_cd := guf.intm_no;

             IF v_pay_rcv_intm_amt > 0
             THEN
                --accounts receivable intm
                v_aeg_item_no := 22;
             ELSE
                --accounts payable intm
                v_aeg_item_no := 32;
             END IF;

             upload_dpc_web.aeg_parameters_misc (giacs607_pkg.v_tran_id,
                                                 'GIACS607',
                                                 v_aeg_item_no,
                                                 ABS (v_pay_rcv_intm_amt),
                                                 v_sl_cd,
                                                 p_user_id
                                                );
          END IF;

          IF p_nbt_tran_class = 'COL'
          THEN
             --generate the op_text for the commission
             giacs607_pkg.gen_comm_op_text (p_user_id);
             
             IF    (guf.nbt_or_tag = 'G' AND p_gross_tag = 'N')
                OR (guf.nbt_or_tag = 'I' AND p_gross_tag = 'N')
             THEN
             
                --generate the op_text for the accounts payable/accounts receivable - intm
                IF v_pay_rcv_intm_amt > 0
                THEN
                   giacs607_pkg.gen_misc_op_text
                                         ('ACCOUNTS RECEIVABLE - INTERMEDIARIES',
                                          v_pay_rcv_intm_amt * -1,
                                          p_user_id
                                         );
                ELSIF v_pay_rcv_intm_amt < 0
                THEN
                   giacs607_pkg.gen_misc_op_text
                                            ('ACCOUNTS PAYABLE - INTERMEDIARIES',
                                             v_pay_rcv_intm_amt * -1,
                                             p_user_id
                                            );
                END IF;

                --update value for other income/expense
                v_other_exp_inc_amt := v_other_exp_inc_amt - v_other_exp_comm_amt;
             --for op_text
             END IF;
          END IF;

          --*Premium and Commission*--
          --generate the acct entries for other expense/income from the premium collns and commission
          IF v_other_exp_inc_tot <> 0
          THEN
             IF v_other_exp_inc_tot > 0
             THEN
                v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                v_aeg_item_no := 2;
             ELSE
                v_sl_cd := giacp.n ('OTHER_EXPENSE_SL');
                v_aeg_item_no := 12;
             END IF;

             upload_dpc_web.aeg_parameters_misc (giacs607_pkg.v_tran_id,
                                                 'GIACS607',
                                                 v_aeg_item_no,
                                                 ABS (v_other_exp_inc_tot),
                                                 v_sl_cd,
                                                 p_user_id
                                                );
          END IF;

          --generate the op_text for other expense/income from the premium collns and commission
          IF p_nbt_tran_class = 'COL'
          THEN
             IF v_other_exp_inc_amt > 0
             THEN
                giacs607_pkg.gen_misc_op_text ('OTHER INCOME',
                                               v_other_exp_inc_amt,
                                               p_user_id
                                              );
             ELSIF v_other_exp_inc_amt < 0
             THEN
                giacs607_pkg.gen_misc_op_text ('OTHER EXPENSE',
                                               v_other_exp_inc_amt,
                                               p_user_id
                                              );
             END IF;
          END IF;

          --*Premium Deposit*--
          --generate the acct entries and op_text for premium deposit
          upload_dpc_web.aeg_parameters_pdep (giacs607_pkg.v_tran_id,
                                              'GIACS026',
                                              p_user_id
                                             );

          IF p_nbt_tran_class = 'COL'
          THEN
             giacs607_pkg.gen_prem_dep_op_text (p_user_id);

             IF    (guf.nbt_or_tag = 'G' AND guf.gross_tag = 'Y')
                OR (guf.nbt_or_tag = 'I' AND p_gross_tag = 'Y')
             THEN
                UPDATE giac_op_text
                   SET foreign_curr_amt = foreign_curr_amt + v_prem_dep_comm_tot,
                       item_amt = item_amt + v_prem_dep_comm_tot
                 WHERE gacc_tran_id = giacs607_pkg.v_tran_id
                   AND item_gen_type = giacs607_pkg.v_gen_type;
             END IF;
          END IF;

          --update giac_order_of_payts (individual ORs only)
          IF p_nbt_tran_class = 'COL' AND guf.nbt_or_tag = 'I'
          THEN
             v_particulars := giacs607_pkg.get_or_particulars;

             UPDATE giac_order_of_payts
                SET address_1 = v_address1,
                    address_2 = v_address2,
                    address_3 = v_address3,
                    tin = v_tin,
                    particulars = v_particulars
              WHERE gacc_tran_id = giacs607_pkg.v_tran_id;
          END IF;
       END LOOP guf;
    END process_payments2;    
    
    PROCEDURE gen_group_or2 (
       p_source_cd        giac_upload_file.source_cd%TYPE,
       p_file_no          giac_upload_file.file_no%TYPE,
       p_nbt_tran_class   giac_upload_file.tran_class%TYPE,
       p_dcb_no           giac_colln_batch.dcb_no%TYPE,
       p_sl_type_cd1      giac_parameters.param_name%TYPE,
       p_sl_type_cd2      giac_parameters.param_name%TYPE,
       p_sl_type_cd3      giac_parameters.param_name%TYPE,
       p_fund_cd          giac_acct_entries.gacc_gfun_fund_cd%TYPE,
       p_branch_cd        giac_acct_entries.gacc_gibr_branch_cd%TYPE,
       p_user_id          giac_op_text.user_id%TYPE,
       p_or_date          giac_order_of_payts.or_date%TYPE
    )
    AS
       --acctrans
       v_tran_flag          giac_acctrans.tran_flag%TYPE;
       v_tran_year          giac_acctrans.tran_year%TYPE;
       v_tran_month         giac_acctrans.tran_month%TYPE;
       v_tran_seq_no        giac_acctrans.tran_seq_no%TYPE;
       v_tran_class         giac_acctrans.tran_class%TYPE;
       v_tran_class_no      giac_acctrans.tran_class_no%TYPE;
       --order of payts
       v_cashier_cd         giac_order_of_payts.cashier_cd%TYPE;
       v_address1           giac_order_of_payts.address_1%TYPE;
       v_address2           giac_order_of_payts.address_2%TYPE;
       v_address3           giac_order_of_payts.address_3%TYPE;
       v_tin                giac_order_of_payts.tin%TYPE;
       v_particulars        giac_order_of_payts.particulars%TYPE;
       v_or_colln_amt       giac_order_of_payts.collection_amt%TYPE;
       v_or_gross_amt       giac_order_of_payts.collection_amt%TYPE;
       --collection dtl
       v_item_no            giac_upload_colln_dtl.item_no%TYPE;
       v_currency_cd        giac_collection_dtl.currency_cd%TYPE;
       v_currency_rt        giac_collection_dtl.currency_rt%TYPE;
       v_pay_mode           giac_collection_dtl.pay_mode%TYPE;
       v_amount             giac_collection_dtl.amount%TYPE;
       v_gross_amt          giac_collection_dtl.gross_amt%TYPE;
       v_comm_amt           giac_collection_dtl.commission_amt%TYPE;
       v_check_class        giac_collection_dtl.check_class%TYPE;
       v_check_date         giac_collection_dtl.check_date%TYPE;
       v_check_no           giac_collection_dtl.check_no%TYPE;
       v_bank_cd            giac_collection_dtl.bank_cd%TYPE;
       v_dcb_bank_cd        giac_collection_dtl.dcb_bank_cd%TYPE;
       v_dcb_bank_acct_cd   giac_collection_dtl.dcb_bank_acct_cd%TYPE;
       v_curr_cd            giac_collection_dtl.currency_cd%TYPE;
       v_curr_rt            giac_collection_dtl.currency_rt%TYPE;
       v_fc_gross_amt       giac_collection_dtl.fc_gross_amt%TYPE;
       v_fc_comm_amt        giac_collection_dtl.fc_comm_amt%TYPE;
       v_fc_vat_amt         giac_collection_dtl.fc_tax_amt%TYPE;
       v_vat_amt            giac_collection_dtl.vat_amt%TYPE;
       v_fcurrency_amt      giac_collection_dtl.fcurrency_amt%TYPE;

       TYPE giac_upload_colln_dtl_tab IS TABLE OF giac_upload_colln_dtl%ROWTYPE;

       v_list_gucd          giac_upload_colln_dtl_tab;
       v_counter            NUMBER                                      := 1;
       v_comm               giac_collection_dtl.amount%TYPE;
       v_check_amount       giac_collection_dtl.amount%TYPE;
       v_check_gross_amt    giac_collection_dtl.gross_amt%TYPE;
       v_check_comm_amt     giac_collection_dtl.commission_amt%TYPE;
       
       v_gross_tag          giac_order_of_payts.gross_tag%TYPE;
    BEGIN
       DBMS_SESSION.set_identifier (p_source_cd || '-' || p_file_no);

       SELECT *
       BULK COLLECT INTO v_list_gucd
         FROM giac_upload_colln_dtl
        WHERE source_cd = p_source_cd AND file_no = p_file_no;

       FOR guf IN (SELECT *
                     FROM TABLE (giacs607_pkg.get_guf_details (p_source_cd,
                                                               p_file_no
                                                              )
                                ))
       LOOP
          FOR payor_rec IN (SELECT payor, v_or_colln_amt, v_or_gross_amt,
                                   v_or_comm_amt, v_or_whtax_amt,
                                   v_or_input_vat_amt, currency_cd, convert_rate
                              FROM giac_upload_prem_comm_v)
          LOOP
             --*insert in giac_acctrans*--
             SELECT acctran_tran_id_s.NEXTVAL
               INTO giacs607_pkg.v_tran_id
               FROM SYS.DUAL;

             giacs607_pkg.v_tran_date :=
                TO_DATE (   TO_CHAR (p_or_date, 'MM-DD-YYYY')
                         || ' '
                         || TO_CHAR (SYSDATE, 'HH:MI:SS AM'),
                         'MM-DD-YYYY HH:MI:SS AM'
                        );
             v_tran_flag := 'O';
             v_tran_year := TO_NUMBER (TO_CHAR (p_or_date, 'YYYY'));
             v_tran_month := TO_NUMBER (TO_CHAR (p_or_date, 'MM'));
             v_tran_seq_no :=
                giac_sequence_generation (p_fund_cd,
                                          p_branch_cd,
                                          'ACCTRAN_TRAN_SEQ_NO',
                                          v_tran_year,
                                          v_tran_month
                                         );
             v_tran_class := 'COL';
             v_tran_class_no := p_dcb_no;

             INSERT INTO giac_acctrans
                         (tran_id, gfun_fund_cd, gibr_branch_cd,
                          tran_date, tran_flag, tran_year,
                          tran_month, tran_seq_no, tran_class,
                          tran_class_no, user_id, last_update
                         )
                  VALUES (giacs607_pkg.v_tran_id, p_fund_cd, p_branch_cd,
                          giacs607_pkg.v_tran_date, v_tran_flag, v_tran_year,
                          v_tran_month, v_tran_seq_no, v_tran_class,
                          v_tran_class_no, p_user_id, SYSDATE
                         );

             --*insert in giac_order_of_payts*--
             v_currency_cd := 1;
             v_currency_rt := 1;
             v_particulars :=
                 'Representing payment of premium and taxes for various policies.';

             --get the cashier_cd
             FOR a IN (SELECT cashier_cd
                         FROM giac_dcb_users
                        WHERE dcb_user_id = p_user_id
                          AND gibr_fund_cd = p_fund_cd
                          AND gibr_branch_cd = p_branch_cd)
             LOOP
                v_cashier_cd := a.cashier_cd;
                EXIT;
             END LOOP;

             --get the address and tin
             BEGIN
                SELECT mail_addr1, mail_addr2, mail_addr3, tin
                  INTO v_address1, v_address2, v_address3, v_tin
                  FROM giis_intermediary
                 WHERE intm_no = guf.intm_no;
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   raise_application_error
                      (-20001,
                       'Geniisys Exception#E#Intermediary does not exist in table giis_intermediary.'
                      );
             END;
    
             --get the gross_tag
             FOR a IN (SELECT gross_tag
                         FROM giac_upload_prem_comm
                        WHERE source_cd = p_source_cd
                          AND file_no = p_file_no
                          AND payor = payor_rec.payor)
             LOOP
                v_gross_tag := a.gross_tag;
                EXIT;
             END LOOP;

             INSERT INTO giac_order_of_payts
                         (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                          payor, or_date,
                          cashier_cd, dcb_no, or_flag, intm_no, address_1,
                          address_2, address_3, tin, particulars,
                          collection_amt, currency_cd,
                          gross_amt, gross_tag, upload_tag,
                          user_id, last_update
                         )
                  VALUES (giacs607_pkg.v_tran_id, p_fund_cd, p_branch_cd,
                          payor_rec.payor, giacs607_pkg.v_tran_date,
                          v_cashier_cd, p_dcb_no, 'N', guf.intm_no, v_address1,
                          v_address2, v_address3, v_tin, v_particulars,
                          payor_rec.v_or_colln_amt, v_currency_cd,
                          payor_rec.v_or_gross_amt, v_gross_tag, 'Y',
                          p_user_id, SYSDATE
                         );

             --collection dtl
             v_comm :=
                  (payor_rec.v_or_comm_amt - payor_rec.v_or_whtax_amt)
                + payor_rec.v_or_input_vat_amt;

             IF payor_rec.v_or_colln_amt = 0
             THEN
                EXIT;
             END IF;
                  
             v_counter := 1;  
          
             FOR j IN 1 .. v_list_gucd.COUNT
             LOOP
                IF v_list_gucd (j).amount = 0
                THEN
                   --CONTINUE;
                   GOTO next_v_list2;
                END IF;

                IF payor_rec.v_or_colln_amt = 0
                THEN
                   --CONTINUE;
                   GOTO next_v_list2;
                END IF;

                IF payor_rec.v_or_colln_amt >= v_list_gucd (j).amount
                THEN
                   v_amount := v_list_gucd (j).amount;
                   payor_rec.v_or_colln_amt :=
                                payor_rec.v_or_colln_amt - v_list_gucd (j).amount;
                   v_list_gucd (j).amount := 0;
                ELSE
                   v_amount := payor_rec.v_or_colln_amt;
                   v_list_gucd (j).amount :=
                                v_list_gucd (j).amount - payor_rec.v_or_colln_amt;
                   payor_rec.v_or_colln_amt := 0;
                END IF;

                IF v_comm >= v_list_gucd (j).commission_amt
                THEN
                   v_comm_amt := v_list_gucd (j).commission_amt;
                   v_comm := v_comm - v_list_gucd (j).commission_amt;
                   v_list_gucd (j).commission_amt := 0;
                ELSE
                   v_comm_amt := v_comm;
                   v_list_gucd (j).commission_amt :=
                                          v_list_gucd (j).commission_amt - v_comm;
                   v_comm := 0;
                END IF;

                v_pay_mode := v_list_gucd (j).pay_mode;
                v_check_class := v_list_gucd (j).check_class;
                v_check_date := v_list_gucd (j).check_date;
                v_check_no := v_list_gucd (j).check_no;
                v_particulars := v_list_gucd (j).particulars;
                v_bank_cd := v_list_gucd (j).bank_cd;
                v_curr_cd := v_list_gucd (j).currency_cd;
                v_curr_rt := v_list_gucd (j).currency_rt;
                v_item_no := v_list_gucd (j).item_no;
                v_gross_amt := v_amount + v_comm_amt;
                v_vat_amt := v_list_gucd (j).vat_amt;
                v_fc_gross_amt := NVL (ROUND (v_gross_amt / v_curr_rt, 2), 0);
                v_fc_comm_amt := NVL (ROUND (v_comm_amt / v_curr_rt, 2), 0);
                v_fc_vat_amt := NVL (ROUND (v_vat_amt / v_curr_rt, 2), 0);
                v_fcurrency_amt := NVL (ROUND (v_amount / v_curr_rt, 2), 0);
                v_dcb_bank_cd := NULL;
                v_dcb_bank_acct_cd := NULL;

                FOR gucd IN (SELECT *
                               FROM giac_upload_colln_dtl
                              WHERE source_cd = guf.source_cd
                                AND file_no = guf.file_no
                                AND item_no = v_item_no)
                LOOP
                   v_dcb_bank_cd := gucd.dcb_bank_cd;
                   v_dcb_bank_acct_cd := gucd.dcb_bank_acct_cd;
                   EXIT;
                END LOOP;

                --insert here
                INSERT INTO giac_collection_dtl
                            (gacc_tran_id, item_no, currency_cd,
                             currency_rt, pay_mode, amount, gross_amt,
                             commission_amt, vat_amt, fcurrency_amt,
                             fc_gross_amt, fc_comm_amt, fc_tax_amt,
                             check_class, check_date, check_no,
                             particulars, bank_cd, due_dcb_no,
                             due_dcb_date, user_id,
                             last_update, dcb_bank_cd, dcb_bank_acct_cd
                            )
                     VALUES (giacs607_pkg.v_tran_id, v_counter, v_currency_cd,
                             v_currency_rt, v_pay_mode, v_amount, v_gross_amt,
                             v_comm_amt, v_vat_amt, v_fcurrency_amt,
                             v_fc_gross_amt, v_fc_comm_amt, v_fc_vat_amt,
                             v_check_class, v_check_date, v_check_no,
                             v_particulars, v_bank_cd, p_dcb_no,
                             TRUNC (giacs607_pkg.v_tran_date), p_user_id,
                             SYSDATE, v_dcb_bank_cd, v_dcb_bank_acct_cd
                            );

                v_counter := v_counter + 1;
                
                <<next_v_list2>>
                NULL;
             END LOOP;

             --collection dtl end

             --*generate acct entries for the O.R.*--
             upload_dpc_web.aeg_parameters (giacs607_pkg.v_tran_id,
                                            p_branch_cd,
                                            p_fund_cd,
                                            'GIACS001',
                                            p_user_id
                                           );
             --Process the payments for premium collns, commission, prem deposit, etc.
             giacs607_pkg.process_payments2 (guf.source_cd,
                                             guf.file_no,
                                             p_nbt_tran_class,
                                             payor_rec.payor,
                                             v_gross_tag,
                                             p_sl_type_cd1,
                                             p_sl_type_cd2,
                                             p_sl_type_cd3,
                                             p_user_id,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL
                                            );
                                            
            --update the table giac_upload_prem_comm
            UPDATE giac_upload_prem_comm
               SET tran_id = giacs607_pkg.v_tran_id,
                   tran_date = giacs607_pkg.v_tran_date
             WHERE source_cd = guf.source_cd 
               AND file_no = guf.file_no
               AND payor = payor_rec.payor; 
                                             
          END LOOP payor_rec;

          --delete record from table giac_upload_dv_payt_dtl and
          --giac_upload_jv_payt_dtl since OR was created
          DELETE FROM giac_upload_dv_payt_dtl
                WHERE source_cd = guf.source_cd AND file_no = guf.file_no;

          DELETE FROM giac_upload_jv_payt_dtl
                WHERE source_cd = guf.source_cd AND file_no = guf.file_no;

          --update the table giac_upload_file
          UPDATE giac_upload_file
             SET upload_date = SYSDATE,
                 file_status = '2',
                 tran_class = v_tran_class,
                 tran_id = giacs607_pkg.v_tran_id,
                 tran_date = giacs607_pkg.v_tran_date
           WHERE source_cd = guf.source_cd AND file_no = guf.file_no;
       END LOOP;
    END gen_group_or2;
    
    PROCEDURE check_dcb_no (
       p_branch_cd   VARCHAR2,
       p_user_id     VARCHAR2,
       p_or_date     VARCHAR2
    )
    IS
       v_date    DATE;
       v_exist   VARCHAR2 (1) := 'N';
       v_dcb_no  giac_colln_batch.dcb_no%TYPE;
    BEGIN
       v_date := TO_DATE (p_or_date, 'MM-DD-YYYY');
       upload_dpc_web.set_fixed_variables (giacp.v ('FUND_CD'),
                                           REGEXP_REPLACE (p_branch_cd, '\s'),
                                           giacp.n ('EVAT')
                                          );
       upload_dpc_web.check_dcb_user (v_date, p_user_id);
       upload_dpc_web.get_dcb_no2 (v_date, v_dcb_no, v_exist);

       IF v_exist = 'N'
       THEN
          raise_application_error (-20001,
                                      '#'
                                   || 'There is no open DCB No. dated '
                                   || TO_CHAR (v_date, 'fmMonth DD, YYYY')
                                   || ' for this company/branch ('
                                   || giacp.v ('FUND_CD')
                                   || '/'
                                   || p_branch_cd
                                   || ').'
                                  );
       END IF;
    END check_dcb_no;
    --nieko end
END GIACS607_PKG;
/
