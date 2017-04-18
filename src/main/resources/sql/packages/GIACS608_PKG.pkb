CREATE OR REPLACE PACKAGE BODY CPI.giacs608_pkg
AS
   FUNCTION populate_legend
        RETURN legend_rec_tab PIPELINED
    IS
        v_list  legend_rec_type;
    BEGIN
        FOR rec IN (
            SELECT rv_low_value || ' - ' || rv_meaning leg_name
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_UPLOAD_INWFACUL_PREM.PREM_CHK_FLAG'
        )
        LOOP
            v_list.legend := rec.leg_name;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
    END;
    
    FUNCTION get_giacs608_guf(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
    )
        RETURN guf_tab PIPELINED
    IS
        v_list      guf_type;
    BEGIN
        FOR i IN (
            SELECT *
              FROM giac_upload_file
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            v_list.tran_id          :=   i.tran_id;          
            v_list.file_no          :=   i.file_no;         
            v_list.file_name        :=   i.file_name;       
            v_list.file_status      :=   i.file_status;     
            v_list.source_cd        :=   i.source_cd;       
            v_list.transaction_type :=   i.transaction_type;
            v_list.convert_date     :=   i.convert_date;    
            v_list.ri_cd            :=   i.ri_cd;           
            v_list.tran_date        :=   i.tran_date;       
            v_list.tran_class       :=   i.tran_class;      
            v_list.upload_date      :=   i.upload_date;
            v_list.cancel_date      :=   i.cancel_date;
            v_list.no_of_records    :=   i.no_of_records;
            v_list.remarks          :=   i.remarks;
            
            FOR rec IN (
                SELECT source_name
                  FROM giac_file_source
                 WHERE source_cd = p_source_cd 
            )
            LOOP
                v_list.dsp_source_name  := rec.source_name;
            END LOOP;    
        
            FOR ri IN (
                SELECT ri_name
                  FROM giis_reinsurer
                 WHERE ri_cd = i.ri_cd
            )
            LOOP
                v_list.dsp_ri  := ri.ri_name;
            END LOOP;
            
            BEGIN
               SELECT a.grp_iss_cd
                 INTO v_list.branch_cd
                 FROM giis_user_grp_hdr a, giis_users b
                WHERE a.user_grp = b.user_grp 
                  AND b.user_id = p_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  raise_application_error (-20001, 'Geniisys Exception#E#Group branch code of user was not found!');
            END;    
            
            v_list.dsp_tran_class := NVL(v_list.dsp_tran_class, 'O');
            v_list.dsp_or_date := SYSDATE;
            
            IF v_list.tran_class = 'JV' THEN
                v_list.dsp_tran_class := 'J';
            ELSIF v_list.tran_class = 'DV' THEN
                v_list.dsp_tran_class := 'D';
            ELSE
                v_list.dsp_tran_class := 'O';
            END IF;
            
            PIPE ROW(v_list);    
        END LOOP;
        
        RETURN;
    END;
    
    FUNCTION get_giacs608_giup(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
    )
        RETURN giup_tab PIPELINED
    IS
        v_list      giup_type;
    BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_inwfacul_prem
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
        )
        LOOP
            v_list.tran_date        :=  i.tran_date;      
            v_list.source_cd        :=  i.source_cd;          
            v_list.file_no          :=  i.file_no;          
            v_list.line_cd          :=  i.line_cd;        
            v_list.subline_cd       :=  i.subline_cd;     
            v_list.iss_cd           :=  i.iss_cd;         
            v_list.issue_yy         :=  i.issue_yy;       
            v_list.pol_seq_no       :=  i.pol_seq_no;     
            v_list.lprem_amt        :=  i.lprem_amt;      
            v_list.ltax_amt         :=  i.ltax_amt;       
            v_list.renew_no         :=  i.renew_no;       
            v_list.lcomm_amt        :=  i.lcomm_amt;
            v_list.lcomm_vat        :=  i.lcomm_vat;      
            v_list.lcollection_amt  :=  i.lcollection_amt;
            v_list.prem_chk_flag    :=  i.prem_chk_flag;  
            v_list.assured          :=  i.assured;        
            v_list.chk_remarks      :=  i.chk_remarks;    
            v_list.prem_amt_due     :=  i.prem_amt_due;
            v_list.tax_amt_due      :=  i.tax_amt_due;    
            v_list.comm_amt_due     :=  i.comm_amt_due;
            v_list.comm_vat_due     :=  i.comm_vat_due;   
            v_list.currency_cd      :=  i.currency_cd;    
            v_list.convert_rate     :=  i.convert_rate;
            v_list.fprem_amt        :=  i.fprem_amt;       
            v_list.ftax_amt         :=  i.ftax_amt;       
            v_list.fcomm_amt        :=  i.fcomm_amt;       
            v_list.fcomm_vat        :=  i.fcomm_vat;       
            v_list.fcollection_amt  :=  i.fcollection_amt;
            
            FOR curr IN (
                SELECT currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd
            )
            LOOP
                v_list.dsp_currency := curr.currency_desc;  
            END LOOP;
            
                 
            v_list.nbt_policy_id     := null;
            v_list.nbt_assd_no         := null;
            
            IF i.chk_remarks IS NOT NULL THEN  
              IF nvl(i.prem_amt_due, 0) IS NOT NULL AND nvl(i.tax_amt_due, 0) IS NOT NULL AND
                   nvl(i.comm_amt_due, 0) IS NOT NULL AND nvl(i.comm_vat_due, 0) IS NOT NULL THEN
                  v_list.dsp_diff_prem := nvl(abs(i.prem_amt_due), 0) - i.lprem_amt;  
                  v_list.dsp_prem_vat  := nvl(abs(i.tax_amt_due), 0) - i.ltax_amt;  
                  v_list.dsp_comm_diff := nvl(abs(i.comm_amt_due), 0) - i.lcomm_amt;  
                  v_list.dsp_comm_vat  := nvl(abs(i.comm_vat_due), 0) - i.lcomm_vat;
              ELSE
                  v_list.dsp_diff_prem := null; 
                  v_list.dsp_prem_vat  := null;
                  v_list.dsp_comm_diff := null;
                  v_list.dsp_comm_vat  := null;
              END IF;
              
                v_list.dsp_fprem_diff   := v_list.dsp_diff_prem / i.convert_rate;
                v_list.dsp_ftax_diff    := v_list.dsp_prem_vat / i.convert_rate;
                v_list.dsp_fcomm_diff   := v_list.dsp_comm_diff / i.convert_rate;
                v_list.dsp_fvat_diff    := v_list.dsp_comm_vat / i.convert_rate;
                v_list.dsp_fcollect_diff := (v_list.dsp_fprem_diff + v_list.dsp_ftax_diff) - (v_list.dsp_fcomm_diff + v_list.dsp_fvat_diff);
                 
            END IF;
            
            FOR assd_rec IN (
                SELECT assd_no, par_id
                  FROM gipi_polbasic
                 WHERE 1 = 1
                   AND line_cd = i.line_cd
                   AND subline_cd = i.subline_cd
                   AND iss_cd = i.iss_cd
                   AND issue_yy = i.issue_yy
                   AND pol_seq_no = i.pol_seq_no
                   AND renew_no = i.renew_no
                   AND endt_seq_no = 0
            )
            LOOP    
                v_list.nbt_assd_no := assd_rec.assd_no;
                IF v_list.nbt_assd_no IS NULL THEN
                    FOR assd_rec2 IN (
                        SELECT assd_no
                          FROM gipi_parlist
                         WHERE par_id = assd_rec.par_id
                    )
                    LOOP
                        v_list.nbt_assd_no := assd_rec2.assd_no;
                    END LOOP;
                END IF;
                EXIT;
            END LOOP;
            
            v_list.dsp_or_date    := nvl(i.tran_date, SYSDATE);
            v_list.policy_no := v_list.line_cd || '-' || v_list.subline_cd || '-' || v_list.iss_cd || '-' || LTRIM (TO_CHAR (v_list.issue_yy, '09'))  
                               || '-' || LTRIM (TO_CHAR (v_list.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (v_list.renew_no, '09'));
            
            PIPE ROW(v_list);
                                    
        END LOOP;
        
        RETURN;
    END;
    
    PROCEDURE get_giacs608_giup_totals(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2,
        dsp_tot_prem           OUT  giac_upload_inwfacul_prem.lprem_amt%TYPE,
        dsp_tot_tax            OUT  giac_upload_inwfacul_prem.ltax_amt%TYPE,
        dsp_tot_comm           OUT  giac_upload_inwfacul_prem.lcomm_amt%TYPE,
        dsp_tot_vat            OUT  giac_upload_inwfacul_prem.lcomm_vat%TYPE,
        dsp_tot_collection     OUT  giac_upload_inwfacul_prem.lcollection_amt%TYPE,
        dsp_diff_prem_tot      OUT  giac_upload_inwfacul_prem.lprem_amt%TYPE,
        dsp_diff_prem_vat_tot  OUT  giac_upload_inwfacul_prem.ltax_amt%TYPE,
        dsp_diff_comm_tot      OUT  giac_upload_inwfacul_prem.lcomm_amt%TYPE,
        dsp_comm_vat_diff_tot  OUT  giac_upload_inwfacul_prem.lcomm_vat%TYPE
   )
   IS
   BEGIN
        SELECT SUM (lprem_amt), SUM (ltax_amt), SUM (lcomm_amt), SUM (lcomm_vat),
               SUM (lcollection_amt), SUM (dsp_diff_prem), SUM (dsp_prem_vat),
               SUM (dsp_comm_diff), SUM (dsp_comm_vat)
          INTO dsp_tot_prem,         
               dsp_tot_tax,         
               dsp_tot_comm,         
               dsp_tot_vat,          
               dsp_tot_collection,   
               dsp_diff_prem_tot,    
               dsp_diff_prem_vat_tot,
               dsp_diff_comm_tot,    
               dsp_comm_vat_diff_tot
          FROM TABLE (giacs608_pkg.get_giacs608_giup (p_source_cd, p_file_no, p_user_id));
   END;
   
   
   FUNCTION get_giacs608_gucd(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
   )
        RETURN gucd_tab PIPELINED
   IS
        v_list  gucd_type;
   BEGIN
        FOR i IN (
                SELECT *
                  FROM GIAC_UPLOAD_COLLN_DTL
                 WHERE source_cd = p_source_cd
                  AND file_no = p_file_no
        )
        LOOP    
            v_list.source_cd           :=  i.source_cd;           
            v_list.file_no             :=  i.file_no;                 
            v_list.item_no             :=  i.item_no;               
            v_list.pay_mode            :=  i.pay_mode;
            v_list.bank_cd             :=  i.bank_cd;             
            v_list.check_class         :=  i.check_class;         
            v_list.check_no            :=  i.check_no;            
            v_list.check_date          :=  i.check_date;          
            v_list.amount              :=  i.amount;              
            v_list.fc_gross_amt        :=  i.fc_gross_amt;        
            v_list.currency_cd         :=  i.currency_cd;         
            v_list.dcb_bank_cd         :=  i.dcb_bank_cd;         
            v_list.dcb_bank_acct_cd    :=  i.dcb_bank_acct_cd;    
            v_list.particulars         :=  i.particulars;         
            v_list.gross_amt           :=  i.gross_amt;           
            v_list.commission_amt      :=  i.commission_amt;      
            v_list.vat_amt             :=  i.vat_amt;             
            v_list.currency_rt         :=  i.currency_rt;
            
            
            BEGIN
               SELECT bank_sname
                 INTO v_list.dsp_bank 
                 FROM giac_banks
                WHERE bank_cd = i.bank_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_bank := '';
            END;   
            
            BEGIN
               SELECT short_name
                 INTO v_list.dsp_currency 
                 FROM giis_currency
                WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_list.dsp_currency  := '';
            END; 
            
            FOR c IN (
                SELECT bank_name
                  FROM giac_banks
                 WHERE bank_cd = i.dcb_bank_cd
            ) 
            LOOP
              v_list.dsp_dcb_bank_name  := c.bank_name;
              EXIT;
            END LOOP;
            
            FOR d IN (
                SELECT bank_acct_no
                  FROM giac_bank_accounts
                 WHERE bank_cd = i.dcb_bank_cd
                   AND bank_acct_cd = i.dcb_bank_acct_cd
            ) 
            LOOP
              v_list.dsp_dcb_bank_acct_no :=  d.bank_acct_no;
              EXIT;
            END LOOP;
            
            PIPE ROW(v_list);
            
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE del_gucd(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE,
        p_item_no       IN  giac_upload_colln_dtl.ITEM_NO%TYPE
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
        --nieko Accounting Uploading GIACS608
        MERGE INTO giac_upload_colln_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd
             AND file_no = p_rec.file_no
             AND item_no = p_rec.item_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, item_no, pay_mode, gross_amt, fc_gross_amt,
                    check_class, check_date, check_no, particulars, bank_cd, currency_cd, currency_rt, 
                    dcb_bank_cd, dcb_bank_acct_cd, amount)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.item_no, p_rec.pay_mode, p_rec.gross_amt, p_rec.fc_gross_amt,
                    p_rec.check_class, p_rec.check_date, p_rec.check_no, p_rec.particulars, p_rec.bank_cd, p_rec.currency_cd, p_rec.currency_rt, 
                    p_rec.dcb_bank_cd, p_rec.dcb_bank_acct_cd, p_rec.amount)
         WHEN MATCHED THEN
            UPDATE
               SET pay_mode         = p_rec.pay_mode,
                   gross_amt        = p_rec.gross_amt,
                   check_class      = p_rec.check_class,
                   check_date       = p_rec.check_date,
                   check_no         = p_rec.check_no,
                   particulars      = p_rec.particulars,
                   bank_cd          = p_rec.bank_cd,
                   currency_cd      = p_rec.currency_cd,
                   currency_rt      = p_rec.currency_rt,
                   dcb_bank_cd      = p_rec.dcb_bank_cd,
                   dcb_bank_acct_cd = p_rec.dcb_bank_acct_cd,
                   fc_gross_amt     = p_rec.fc_gross_amt,
                   amount           = p_rec.amount;
    END set_gucd;
    
    FUNCTION get_giac_upload_dv_payt_dtl(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
     RETURN giac_upload_dv_payt_dtl_tab PIPELINED
   IS
     v_list giac_upload_dv_payt_dtl_type;
     v_exist    VARCHAR2(1) := 'N';
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            v_exist := 'Y';
            v_list.source_cd           :=   i.source_cd;    
            v_list.file_no             :=   i.file_no;
            v_list.document_cd         :=   i.document_cd;
            v_list.branch_cd           :=   i.branch_cd;
            v_list.line_cd             :=   i.line_cd;
            v_list.doc_year            :=   i.doc_year;
            v_list.doc_mm              :=   i.doc_mm;
            v_list.doc_seq_no          :=   i.doc_seq_no;
            v_list.gouc_ouc_id         :=   i.gouc_ouc_id;
            v_list.request_date        :=   i.request_date;
            v_list.payee_class_cd      :=   i.payee_class_cd;
            v_list.payee_cd            :=   i.payee_cd;
            v_list.payee               :=   i.payee;
            v_list.particulars         :=   i.particulars;
            v_list.dv_fcurrency_amt    :=   i.dv_fcurrency_amt;
            v_list.currency_rt         :=   i.currency_rt;
            v_list.payt_amt            :=   i.payt_amt;
            v_list.currency_cd         :=   i.currency_cd;


            BEGIN
               SELECT ouc_cd, ouc_name
                 INTO v_list.dsp_dept_cd, v_list.dsp_ouc_name 
                 FROM giac_oucs
                WHERE ouc_id = i.gouc_ouc_id;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_dept_cd    := '';
                  v_list.dsp_ouc_name   := '';
            END;
            
            BEGIN
                SELECT short_name
                  INTO v_list.dsp_fshort_name
                  FROM giis_currency 
                 WHERE main_currency_cd =  i.currency_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_fshort_name    := '';
            END;
            
            BEGIN
               SELECT param_value_v
                 INTO v_list.dsp_short_name 
                 FROM giac_parameters
                WHERE param_name LIKE 'DEFAULT_CURRENCY';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_short_name     := '';
            END;
            
            BEGIN
                SELECT payee_last_name, payee_first_name, payee_middle_name
                  INTO v_list.payee_last_name, v_list.payee_first_name, v_list.payee_middle_name
                  FROM giis_payees
                 WHERE payee_class_cd = i.payee_class_cd
                   AND payee_no = i.payee_cd;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                  v_list.payee_last_name    := '';
                  v_list.payee_first_name   := '';
                  v_list.payee_middle_name  := '';
            END;
            
            BEGIN
                SELECT document_name, line_cd_tag, yy_tag, mm_tag
                  INTO v_list.document_name, v_list.line_cd_tag, v_list.yy_tag, v_list.mm_tag
                  FROM giac_payt_req_docs
                 WHERE gibr_gfun_fund_cd = giacp.v('FUND_CD')
                   AND gibr_branch_cd = i.branch_cd
                   AND document_cd = i.document_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.document_name  := '';  
                  v_list.line_cd_tag    := '';
                  v_list.yy_tag         := '';
                  v_list.mm_tag         := '';
            END;
        
            PIPE ROW(v_list);
        END LOOP;
        
        IF v_exist = 'N' THEN
            BEGIN
               SELECT a.grp_iss_cd
                 INTO v_list.branch_cd
                 FROM giis_user_grp_hdr a, giis_users b
                WHERE a.user_grp = b.user_grp AND b.user_id = p_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.branch_cd := '';
            END;
            
            BEGIN
                SELECT param_value_v
                  INTO v_list.dsp_short_name
                  FROM giac_parameters
                 WHERE param_name LIKE 'DEFAULT_CURRENCY';
            END;
            
            v_list.source_cd           :=   p_source_cd; 
            v_list.file_no             :=   p_file_no;  
            
            v_list.v_exists := v_exist;
            
            PIPE ROW(v_list);
        END IF;
        RETURN;
   END;
   
   FUNCTION get_giac_upload_jv_payt_dtl(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
     RETURN giac_upload_jv_payt_dtl_tab PIPELINED
   IS
        v_list  giac_upload_jv_payt_dtl_type;
        v_exists    VARCHAR2(1) := 'N';
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            v_exists        := 'Y';
            v_list.source_cd        :=  i.source_cd;      
            v_list.file_no          :=  i.file_no;        
            v_list.branch_cd        :=  i.branch_cd;      
            v_list.tran_date        :=  i.tran_date;      
            v_list.jv_tran_tag      :=  i.jv_tran_tag;    
            v_list.jv_tran_type     :=  i.jv_tran_type;   
            v_list.jv_tran_mm       :=  i.jv_tran_mm;     
            v_list.jv_tran_yy       :=  i.jv_tran_yy;     
            v_list.tran_year        :=  i.tran_year;      
            v_list.tran_month       :=  i.tran_month;
            v_list.tran_seq_no      :=  i.tran_seq_no;    
            v_list.jv_pref_suff     :=  i.jv_pref_suff;   
            v_list.jv_no            :=  i.jv_no;          
            v_list.particulars      :=  i.particulars;    
            
            
            BEGIN
                SELECT branch_name
                  INTO v_list.dsp_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = giacp.v ('FUND_CD') 
                   AND branch_cd = i.branch_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_branch_name := NULL;
            END;
            
            FOR c IN (
                SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans
                 WHERE jv_tran_cd = i.jv_tran_type
            ) 
            LOOP
                v_list.dsp_tran_desc := c.jv_tran_desc;
                EXIT;
            END LOOP;
            
            PIPE ROW (v_list);
        END LOOP;
        
        IF v_exists != 'Y' THEN
            v_list.v_exists := 'N';
            v_list.source_cd        :=  p_source_cd;      
            v_list.file_no          :=  p_file_no;  
            
            BEGIN
                SELECT a.grp_iss_cd 
                  INTO v_list.branch_cd
                  FROM giis_user_grp_hdr a, giis_users b
                 WHERE a.user_grp = b.user_grp 
                   AND b.user_id = p_user_id;
                   
                SELECT branch_name
                  INTO v_list.dsp_branch_name
                  FROM giac_branches
                 WHERE branch_cd = v_list.branch_cd
                   AND gfun_fund_cd = giacp.v ('FUND_CD');
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_list.branch_cd := '';
                    v_list.dsp_branch_name := '';
            END;
            
            PIPE ROW (v_list);
        END IF;
        
        RETURN;
   END;
   
   PROCEDURE check_data_giacs608 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
   IS
        v_ri_iss_cd                giac_parameters.param_value_v%TYPE;
        v_pol_flag                gipi_polbasic.pol_flag%TYPE;
        v_reg_policy_sw            gipi_polbasic.reg_policy_sw%TYPE;
        v_iss_cd                gipi_polbasic.iss_cd%TYPE;
        v_policy_id                gipi_polbasic.policy_id%TYPE;
        v_prem_chk_flag            giac_upload_inwfacul_prem.prem_chk_flag%TYPE;
        v_chk_remarks            giac_upload_inwfacul_prem.chk_remarks%TYPE;
        v_exist                    VARCHAR2(1) := 'N';
        v_bills                    VARCHAR2(2000);
        v_tot_amnt                NUMBER;
        v_prem_amt                NUMBER;
        v_tax_amt                NUMBER;
        v_comm_amt                NUMBER;
        v_comm_vat                NUMBER;
        v_amt_sign                NUMBER;
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_inwfacul_prem
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
        )
        LOOP
            v_prem_chk_flag := null;
            v_chk_remarks := null;
            v_exist := 'N';
            v_tot_amnt := 0;
            v_prem_amt := 0;
            v_tax_amt  := 0;
            v_comm_amt := 0;
            v_comm_vat := 0;
            v_iss_cd   := i.iss_cd;
            
            IF check_user_per_iss_cd_acctg2(NULL,i.iss_cd,'GIACS008', p_user_id)    = 0 THEN
                v_prem_chk_flag := 'NA';
                v_chk_remarks   := 'User is not allowed to make collections for the branch of this policy.';
--                GOTO final;
            END IF;    
            
            BEGIN
               SELECT param_value_v
                 INTO v_ri_iss_cd
                 FROM giac_parameters
                WHERE param_name = 'RI_ISS_CD';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_ri_iss_cd := NULL;
            END;
            
            IF v_iss_cd <> v_ri_iss_cd THEN 
                v_prem_chk_flag     := 'DI';
                v_chk_remarks        := 'This is not a reinsurance policy.'; 
              GOTO final;
            ELSE
                v_prem_chk_flag     := 'OK';
                v_chk_remarks            := 'This policy is valid for uploading.';
            END IF;
            
            
            -- nieko Accounting Uploading GIACS608, allow records with different ri_cd
            BEGIN
                SELECT a.pol_flag, a.reg_policy_sw, a.policy_id
                  INTO v_pol_flag, v_reg_policy_sw, v_policy_id
                  FROM gipi_polbasic a, giri_inpolbas b
                 WHERE a.policy_id = b.policy_id
                   /*AND b.ri_cd IN (SELECT ri_cd
                                     FROM giac_upload_file
                                    WHERE source_cd = p_source_cd AND file_no = p_file_no)*/
                   AND a.line_cd = i.line_cd
                   AND a.subline_cd = i.subline_cd
                   AND a.iss_cd = i.iss_cd
                   AND a.issue_yy = i.issue_yy
                   AND a.pol_seq_no = i.pol_seq_no
                   AND a.renew_no = i.renew_no;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_prem_chk_flag := 'IP';
                  v_chk_remarks := 'This policy is not a policy of this ceding company.';
                  GOTO FINAL;
               WHEN TOO_MANY_ROWS THEN
                  NULL;
            END;
            
            
            IF v_pol_flag = '4' THEN
                BEGIN
                   SELECT 'Y'
                     INTO v_exist
                     FROM giac_cancelled_policies_v
                    WHERE line_cd = i.line_cd
                      AND subline_cd = i.subline_cd
                      AND iss_cd = i.iss_cd
                      AND issue_yy = i.issue_yy
                      AND pol_seq_no = i.pol_seq_no
                      AND renew_no = i.renew_no;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      v_exist := 'N';
                   WHEN TOO_MANY_ROWS THEN
                      v_exist := 'Y';
                END;
                    
                IF v_exist = 'Y' THEN
                    v_exist := 'N';
                    v_prem_chk_flag     := 'CP';
                    v_chk_remarks        := 'This is a cancelled policy.'; 
                    GOTO final;
                END IF;    
                
            END IF;
            
            IF v_pol_flag = '5' THEN
                v_prem_chk_flag     := 'SL';
                v_chk_remarks        := 'This policy is already spoiled.'; 
                GOTO final;
            END IF;
            
            IF v_reg_policy_sw = 'N' AND variables_prem_payt_for_sp <> 'Y' THEN
                v_prem_chk_flag     := 'SP';
                v_chk_remarks        := 'This is a special policy.'; 
                GOTO final;
            END IF;
            
            -- nieko Accounting Uploading GIACS608, allow records with different ri_cd
            FOR amnt IN (SELECT b.iss_cd, a.prem_seq_no, SUM(balance_due) bal_due, 
                                SUM(prem_balance_due) prem_amt, 
                                SUM(tax_amount) tax_amt,
                                SUM(comm_balance_due) comm_amt, 
                                SUM(comm_vat) vat_amt,
                                c.reg_policy_sw
                           FROM giac_aging_ri_soa_details a, gipi_invoice b, gipi_polbasic c
                          WHERE a.prem_seq_no = b.prem_seq_no
                            AND b.iss_cd = c.iss_cd
                            AND b.policy_id = c.policy_id
                            AND c.line_cd = i.line_cd
                            AND c.subline_cd = i.subline_cd
                            AND c.iss_cd = i.iss_cd
                            AND c.issue_yy = i.issue_yy
                            AND c.pol_seq_no = i.pol_seq_no
                            AND c.renew_no = i.renew_no
                            /*AND a.a180_ri_cd IN (SELECT ri_cd
                                             FROM giac_upload_file
                                            WHERE source_cd = p_source_cd 
                                              AND file_no = p_file_no)*/
                         GROUP BY b.iss_cd, a.prem_seq_no, c.reg_policy_sw)
            LOOP
                IF amnt.reg_policy_sw <> 'N' OR (amnt.reg_policy_sw = 'N' AND variables_prem_payt_for_sp = 'Y') THEN
                    v_bills := v_bills||', '||amnt.iss_cd||'-'||amnt.prem_seq_no;
                    v_tot_amnt := nvl(v_tot_amnt, 0) + amnt.bal_due;     
                    v_prem_amt := nvl(v_prem_amt, 0) + amnt.prem_amt;
                    v_tax_amt  := nvl(v_tax_amt, 0)  + amnt.tax_amt;
                    v_comm_amt := nvl(v_comm_amt, 0) + amnt.comm_amt;
                    v_comm_vat := nvl(v_comm_vat, 0) + amnt.vat_amt;
                END IF;    
            END LOOP;
            
            v_amt_sign := sign(v_tot_amnt);
            
            IF v_amt_sign = 1 AND i.lcollection_amt < 0 THEN
                v_prem_chk_flag := 'NP';
                v_chk_remarks := 'This policy has positive premium due.';
                GOTO final;
            END IF;    
            
            IF nvl(v_tot_amnt, 0) = 0 THEN
                v_prem_chk_flag := 'FP';
                v_chk_remarks     := 'This policy is already fully paid.';
            ELSIF i.lcollection_amt > 0 THEN 
                IF i.lcollection_amt > v_tot_amnt THEN
                    v_prem_chk_flag := 'OP';
                    v_chk_remarks   := 'This policy with bill nos. '||substr(v_bills, 3)||
                                       ' has a total balance amount due of '||
                                       ltrim(to_char(v_tot_amnt, '999,999,999,990.90'))||'.';
                ELSIF i.lcollection_amt < v_tot_amnt THEN
                    v_prem_chk_flag := 'PT';
                    v_chk_remarks   := 'This is a partial payment. The total balance amount due for bill nos. '||
                                       substr(v_bills, 3)||' is '||ltrim(to_char(v_tot_amnt, '999,999,999,990.90'))||'.';
                END IF;    
            ELSIF i.lcollection_amt < 0 THEN      
                IF v_tot_amnt < 0 THEN
                    IF i.lcollection_amt > v_tot_amnt THEN
                        v_prem_chk_flag := 'PT';
                        v_chk_remarks   := 'This is a partial payment. The total balance amount due for bill nos. '||
                                         substr(v_bills, 3)||' is '||ltrim(to_char(v_tot_amnt, '999,999,999,990.90'))||'.';
                    ELSIF i.lcollection_amt < v_tot_amnt THEN                      
                        v_prem_chk_flag := 'ON';--overpayment on negative
                        v_chk_remarks := 'This is an overpayment on negative endorsement. The total balance amount due for bill nos. '||substr(v_bills,3)||' is '||ltrim(to_char(v_tot_amnt, '999,999,999,990.90'))||'.';
                    END IF;    
                END IF;            
            END IF;
            
            <<final>>
            UPDATE giac_upload_inwfacul_prem
               SET prem_chk_flag     = v_prem_chk_flag,
                   chk_remarks         = v_chk_remarks,
                   prem_amt_due   = v_prem_amt,
                   tax_amt_due         = v_tax_amt,
                   comm_amt_due        = v_comm_amt,
                   comm_vat_due        = v_comm_vat,
                   tot_amt_due        = v_tot_amnt
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
               AND line_cd = i.line_cd
               AND subline_cd = i.subline_cd
               AND iss_cd = i.iss_cd
               AND issue_yy = i.issue_yy
               AND pol_seq_no = i.pol_seq_no
               AND renew_no = i.renew_no;
            
            
        END LOOP;
   END;
   
   PROCEDURE check_collection_amount(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2
   )
   IS
        v_collection_amt        NUMBER;
        v_collection            NUMBER;
        v_gross                 NUMBER;
        v_comm                  NUMBER;
        v_stale_date            DATE;
   BEGIN
        FOR rec IN (
              SELECT pay_mode, check_date, check_no, check_class, tran_id
                FROM giac_upload_colln_dtl
               WHERE source_cd = p_source_cd
                 AND file_no = p_file_no
            ORDER BY item_no
        )
        LOOP
            IF rec.pay_mode = 'CHK' THEN
                IF rec.check_date IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Please enter check date for check no. '||rec.check_no||' in the Collection Details.');
                ELSE
                    IF rec.check_date > sysdate THEN
                        raise_application_error (-20001, 'Geniisys Exception#E#Check no. '||rec.check_no||' in the Collection Details is post-dated.');
                    END IF;

                    IF rec.check_class = 'M' THEN
                        v_stale_date := TO_DATE(TO_CHAR(ADD_MONTHS(TRUNC(sysdate), (-1 * variables_stale_mgr_chk)), 'MM-DD-YYYY'),'MM-DD-YYYY');
                    ELSE    
                        v_stale_date := TO_DATE(TO_CHAR(ADD_MONTHS(TRUNC(sysdate), (-1 * variables_stale_check)), 'MM-DD-YYYY'),'MM-DD-YYYY');
                    END IF;
                    
                    IF TRUNC(rec.check_date) <=  TRUNC(v_stale_date) THEN
                        raise_application_error (-20001, 'Geniisys Exception#E#Check no. '||rec.check_no||' in the Collection Details is a stale check.');
                    END IF;
                END IF;
            END IF;
            
            IF rec.tran_id IS NOT NULL THEN
                raise_application_error (-20001, 'tranId ' || rec.tran_id);
            END IF;
        END LOOP;  
        
        check_net_colln (p_source_cd, p_file_no);        
   END;
   
   PROCEDURE check_payment_details(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_tran_class    VARCHAR2
   )
   IS
   BEGIN
        --nieko Accounting Uploading GIACS608, added checking of OR payment details
        IF  p_tran_class = 'OR' THEN
            FOR i IN (
                SELECT *
                  FROM giac_upload_colln_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no
            )
            LOOP
                IF i.item_no IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Item Number in the Collection Details is null.');
                ELSIF i.pay_mode IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payment Mode in the Collection Details is null.');
                ELSIF i.amount IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Amount in the Collection Details is null.');
                ELSIF i.currency_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Currency Code in the Collection Details is null.');
                ELSIF i.currency_rt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Currency Rate in the Collection Details is null.');
                ELSIF i.dcb_bank_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Bank Code in the Collection Details is null.');
                ELSIF i.dcb_bank_acct_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Bank Account Code in the Collection Details is null.');      
                END IF;
            END LOOP;
            
            check_collection_amount(p_source_cd, p_file_no);
        ELSIF p_tran_class = 'DV' THEN
            FOR i IN (
                SELECT *
                  FROM giac_upload_dv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no
            )
            LOOP
                IF i.request_date IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Request date in the Payment Request Details is null.');
                ELSIF i.gouc_ouc_id IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Department in the Payment Request Details is null.');
                ELSIF i.document_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Document code in the Payment Request Details is null.');
                ELSIF i.branch_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the Payment Request Details is null.');
                ELSIF i.doc_year IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Document year in the Payment Request Details is null.');
                ELSIF i.doc_mm IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Document month in the Payment Request Details is null.');
                ELSIF i.payee_class_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payee class code in the Payment Request Details is null.');
                ELSIF i.payee_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payee code in the Payment Request Details is null.');
                ELSIF i.payee IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payee in the Payment Request Details is null.');
                ELSIF i.currency_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Currency code in the Payment Request Details is null.');
                ELSIF i.currency_rt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Currency rate in the Payment Request Details is null.');
                ELSIF i.dv_fcurrency_amt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
                ELSIF i.payt_amt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
                ELSIF i.particulars IS NULL THEN                               
                    raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the Payment Request Details is null.');
                ELSIF i.tran_id IS NOT NULL THEN
                    raise_application_error (-20001, 'tranId ' || i.tran_id);
                END IF;
                
            END LOOP;
        
        ELSIF p_tran_class = 'JV' THEN
            FOR i IN (
                SELECT *
                  FROM giac_upload_jv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no
            )
            LOOP
                IF i.tran_date IS NULL THEN 
                    raise_application_error (-20001, 'Geniisys Exception#E#Transaction date in the JV Details is null.');
                ELSIF i.branch_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the JV Details is null.');
                ELSIF i.tran_year IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Transaction year in the JV Details is null.');
                ELSIF i.tran_month IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Transaction month in the JV Details is null.');
                ELSIF i.jv_pref_suff IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#JV prefix in the JV Details is null.');
                ELSIF i.particulars IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the JV Details is null.');      
                ELSIF i.jv_tran_tag IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#JV tran tag in the JV Details is null.');      
                ELSIF i.jv_tran_type IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#JV tran type in the JV Details is null.');      
                ELSIF i.particulars IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the JV Details is null.');      
                ELSIF i.jv_tran_tag = 'C' THEN
                    IF i.jv_tran_mm IS NULL THEN
                        raise_application_error (-20001, 'Geniisys Exception#E#JV tran month in the JV Details is null.');      
                    ELSIF i.jv_tran_yy IS NULL THEN
                        raise_application_error (-20001, 'Geniisys Exception#E#JV tran year in the JV Details is null.');      
                    END IF;
                ELSIF i.tran_id IS NOT NULL THEN
                    raise_application_error (-20001, 'tranId ' || i.tran_id);
                END IF; 
                
            END LOOP;
        
        END IF; 
   END;
   
   PROCEDURE get_parameters(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2,
        p_branch_cd            OUT  VARCHAR2
   )
   IS
   BEGIN
        BEGIN
           SELECT a.grp_iss_cd
             INTO p_branch_cd
             FROM giis_user_grp_hdr a, giis_users b
            WHERE a.user_grp = b.user_grp 
              AND b.user_id = p_user_id;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#Group branch code of user was not found!');
        END;
   END;
   
   PROCEDURE proceed_upload(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2,
        p_tran_class                VARCHAR2,
        p_override                  VARCHAR2,
        p_or_date                   VARCHAR2
   )
   IS
        v_exist     VARCHAR2(1);
   BEGIN
        giacs608_pkg.get_parameters(p_source_cd, p_file_no, p_user_id, variables_branch_cd);
        upload_dpc_web.set_fixed_variables(variables_fund_cd, variables_branch_cd, variables_evat_cd);
        --upload_dpc_web.check_tran_mm(TRUNC(SYSDATE));
        --upload_dpc_web.check_dcb_user(TRUNC(SYSDATE), P_USER_ID);
        --upload_dpc_web.get_dcb_no(TRUNC(SYSDATE), variables_dcb_no);
        variables_upload_tag := 'Y';
        variables_tran_class := p_tran_class;
        variables_user_id := p_user_id;
        variables_tran_date := TO_DATE(p_or_date,'MM-DD-YYYY HH:MI:SS AM');
        
        giacs608_pkg.check_data_giacs608(p_source_cd, p_file_no, p_user_id);
        
        IF variables_tran_class = 'OR' THEN
            upload_dpc_web.check_tran_mm (TO_DATE(p_or_date,'MM-DD-YYYY'));
            upload_dpc_web.get_dcb_no2 (TO_DATE(p_or_date,'MM-DD-YYYY'), variables_dcb_no, v_exist);
        
            IF v_exist = 'N'
            THEN
               FOR a IN (SELECT (NVL (MAX (dcb_no), 0) + 1) new_dcb_no
                           FROM giac_colln_batch
                          WHERE fund_cd = variables_fund_cd
                            AND branch_cd = variables_branch_cd
                            AND dcb_year =
                                    TO_NUMBER (TO_CHAR (TO_DATE(p_or_date,'MM-DD-YYYY'), 'YYYY')))
               LOOP
                  variables_dcb_no := a.new_dcb_no;
                  EXIT;
               END LOOP;
                
               upload_dpc_web.create_dcb_no (variables_dcb_no,
                                             TO_DATE(p_or_date,'MM-DD-YYYY'),
                                             variables_fund_cd,
                                             variables_branch_cd,
                                             variables_user_id
                                            );
            END IF;        
        END IF;
        
        FOR i IN(
            SELECT *
              FROM giac_upload_inwfacul_prem
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
        )
        LOOP
            IF i.prem_chk_flag <> 'OK' THEN
                v_exist := 'Y';
                EXIT;
            END IF;
        END LOOP;
        
        IF p_override = 'Y' THEN
            v_exist := 'N';
        END IF;
        
        IF v_exist = 'Y' THEN
            IF giac_validate_user_fn(p_user_id, 'UA', 'GIACS608') = 'FALSE' THEN
                raise_application_error (-20001, 'Geniisys Exception#E#override');
            ELSE
                giacs608_pkg.upload_giacs608(p_source_cd, p_file_no, p_user_id);
            END IF;
        
        ELSE    
            giacs608_pkg.upload_giacs608(p_source_cd, p_file_no, p_user_id);
        END IF;
   END;
   
   PROCEDURE get_sl_cd (
        p_module_name giac_modules.module_name%TYPE
   )
   IS
        v_sl_TYPE1   giac_module_entries.sl_type_cd%TYPE;
        v_sl_TYPE2   giac_module_entries.sl_type_cd%TYPE;
        v_sl_type3   giac_module_entries.sl_type_cd%TYPE;
        v_sl_type4   giac_module_entries.sl_type_cd%TYPE;
        v_sl_type5   giac_module_entries.sl_type_cd%TYPE;
        v_sl_type6   giac_module_entries.sl_type_cd%TYPE;
   BEGIN
        BEGIN
            SELECT param_value_v
              INTO variables_assd_no
              FROM giac_parameters
             WHERE param_name = 'ASSD_SL_TYPE'; 
        END;
        
        BEGIN
            SELECT param_value_v
              INTO variables_ri_cd
              FROM giac_parameters
             WHERE param_name = 'RI_SL_TYPE'; 
        END;
        
        BEGIN
            SELECT param_value_v
              INTO variables_line_cd
              FROM giac_parameters
             WHERE param_name = 'LINE_SL_TYPE'; 
        END;
        
        BEGIN
           SELECT module_id, generation_type
             INTO variables_module_id, variables_gen_type
             FROM giac_modules
            WHERE module_name = p_module_name;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#No data found in GIAC MODULES.');
        END;
        
        BEGIN
           SELECT sl_type_cd
             INTO v_sl_type1
             FROM giac_module_entries
            WHERE module_id = variables_module_id 
              AND item_no = 1;
        END;

        BEGIN
           SELECT sl_type_cd
             INTO v_sl_type2
             FROM giac_module_entries
            WHERE module_id = variables_module_id 
              AND item_no = 2;
        END;

        BEGIN
           SELECT sl_type_cd
             INTO v_sl_type3
             FROM giac_module_entries
            WHERE module_id = variables_module_id 
              AND item_no = 3;
        END;

        BEGIN
           SELECT sl_type_cd
             INTO v_sl_type4
             FROM giac_module_entries
            WHERE module_id = variables_module_id 
              AND item_no = 4;
        END;

        BEGIN
           SELECT sl_type_cd
             INTO v_sl_type5
             FROM giac_module_entries
            WHERE module_id = variables_module_id  
              AND item_no = 5;
        END;

        BEGIN
           SELECT sl_type_cd
             INTO v_sl_type6
             FROM giac_module_entries
            WHERE module_id = variables_module_id  
              AND item_no = 6;
        END;

        BEGIN
           IF v_sl_type1 = variables_assd_no
           THEN
              variables_sl_type_cd1 := 'ASSD_SL_TYPE';
           ELSIF v_sl_type1 = variables_ri_cd
           THEN
              variables_sl_type_cd1 := 'RI_SL_TYPE';
           ELSIF v_sl_type1 = variables_line_cd
           THEN
              variables_sl_type_cd1 := 'LINE_SL_TYPE';
           END IF;
        END;

        BEGIN
           IF v_sl_type2 = variables_assd_no
           THEN
              variables_sl_type_cd2 := 'ASSD_SL_TYPE';
           ELSIF v_sl_type2 = variables_ri_cd
           THEN
              variables_sl_type_cd2 := 'RI_SL_TYPE';
           ELSIF v_sl_type2 = variables_line_cd
           THEN
              variables_sl_type_cd2 := 'LINE_SL_TYPE';
           END IF;
        END;

        BEGIN
           IF v_sl_type3 = variables_assd_no
           THEN
              variables_sl_type_cd3 := 'ASSD_SL_TYPE';
           ELSIF v_sl_type3 = variables_ri_cd
           THEN
              variables_sl_type_cd3 := 'RI_SL_TYPE';
           ELSIF v_sl_type3 = variables_line_cd
           THEN
              variables_sl_type_cd3 := 'LINE_SL_TYPE';
           END IF;
        END;

        BEGIN
           IF v_sl_type4 = variables_assd_no
           THEN
              variables_sl_type_cd4 := 'ASSD_SL_TYPE';
           ELSIF v_sl_type4 = variables_ri_cd
           THEN
              variables_sl_type_cd4 := 'RI_SL_TYPE';
           ELSIF v_sl_type4 = variables_line_cd
           THEN
              variables_sl_type_cd4 := 'LINE_SL_TYPE';
           END IF;
        END;

        BEGIN
           IF v_sl_type5 = variables_assd_no
           THEN
              variables_sl_type_cd5 := 'ASSD_SL_TYPE';
           ELSIF v_sl_type5 = variables_ri_cd
           THEN
              variables_sl_type_cd5 := 'RI_SL_TYPE';
           ELSIF v_sl_type5 = variables_line_cd
           THEN
              variables_sl_type_cd5 := 'LINE_SL_TYPE';
           END IF;
        END;

        BEGIN
           IF v_sl_type6 = variables_assd_no
           THEN
              variables_sl_type_cd6 := 'ASSD_SL_TYPE';
           ELSIF v_sl_type6 = variables_ri_cd
           THEN
              variables_sl_type_cd6 := 'RI_SL_TYPE';
           ELSIF v_sl_type6 = variables_line_cd
           THEN
              variables_sl_type_cd6 := 'LINE_SL_TYPE';
           END IF;
        END;
   END;
   
    FUNCTION get_pol_assd_no (
       p_line_cd      gipi_polbasic.line_cd%TYPE,
       p_subline_cd   gipi_polbasic.subline_cd%TYPE,
       p_iss_cd       gipi_polbasic.iss_cd%TYPE,
       p_issue_yy     gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no     gipi_polbasic.renew_no%TYPE
    )
       RETURN NUMBER
    IS
       v_assd_no   giis_assured.assd_no%TYPE;
    BEGIN
       FOR assd_rec IN (
            SELECT assd_no, par_id
              FROM gipi_polbasic
             WHERE 1 = 1
               AND line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND issue_yy = p_issue_yy
               AND pol_seq_no = p_pol_seq_no
               AND renew_no = p_renew_no
               AND endt_seq_no = 0
       )
       LOOP
          v_assd_no := assd_rec.assd_no;

          IF v_assd_no IS NULL THEN
             FOR assd_rec2 IN (
                SELECT assd_no
                  FROM gipi_parlist
                 WHERE par_id = assd_rec.par_id
             )
             LOOP
                v_assd_no := assd_rec2.assd_no;
             END LOOP;
          END IF;

          EXIT;
       END LOOP;

       RETURN (v_assd_no);
    END;
    
    PROCEDURE allocate_collection (
        p_collection_amt   giac_upload_inwfacul_prem.lcollection_amt%TYPE,
        p_prem_amt         giac_upload_inwfacul_prem.lprem_amt%TYPE,
        p_tax              giac_upload_inwfacul_prem.ltax_amt%TYPE,
        p_comm_amt         giac_upload_inwfacul_prem.lcomm_amt%TYPE,
        p_comm_vat         giac_upload_inwfacul_prem.lcomm_vat%TYPE
    )
    IS
        v_collection       giac_upload_inwfacul_prem.lcollection_amt%TYPE;
        v_inst_no          gipi_installment.inst_no%TYPE;
        v_inv_comm_vat     gipi_invoice.ri_comm_vat%TYPE;
        v_colln_pct        NUMBER                                            := 0;
        v_collection_amt   giac_aging_ri_soa_details.balance_due%TYPE;
        v_prem_amt         giac_aging_ri_soa_details.prem_balance_due%TYPE;
        v_prem_tax         NUMBER (16, 2);
        v_wtax             giac_aging_ri_soa_details.wholding_tax_bal%TYPE;
        v_comm             giac_aging_ri_soa_details.comm_balance_due%TYPE;
        v_tax              giac_aging_ri_soa_details.tax_amount%TYPE;
        v_vat              giac_aging_ri_soa_details.comm_vat%TYPE;
        v_comm_rt          NUMBER                                            := 0;
        v_comm_vat_rt      NUMBER                                            := 0;
        v_prem             NUMBER                                            := 0;
        v_tax_amt          NUMBER                                            := 0;
        v_comm_amt         NUMBER                                            := 0;
        v_comm_vat         NUMBER                                            := 0;
    BEGIN
        v_collection := p_collection_amt;
        v_prem := p_prem_amt;
        v_tax_amt := p_tax;
        v_comm_amt := p_comm_amt;
        v_comm_vat := p_comm_vat;
        
        BEGIN
           SELECT NVL (balance_due, 0), NVL (prem_balance_due, 0) prem_amt,
                  NVL (prem_balance_due + tax_amount, 0) prem_tax,
                  NVL (wholding_tax_bal, 0), NVL (comm_balance_due, 0),
                  NVL (tax_amount, 0)
             INTO v_collection_amt, v_prem_amt,
                  v_prem_tax,
                  v_wtax, v_comm,
                  v_tax
             FROM giac_aging_ri_soa_details
            WHERE a180_ri_cd = variables_ri_cd
              AND prem_seq_no = variables_prem_seq_no
              AND inst_no = variables_inst_no;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#This installment/refund does not exist.');
        END;
        
        BEGIN
           SELECT NVL (ri_comm_vat, 0) comm_vat
             INTO v_inv_comm_vat
             FROM gipi_invoice
            WHERE iss_cd = 'RI' 
              AND prem_seq_no = variables_prem_seq_no;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_inv_comm_vat := 0;
        END;
        
        BEGIN
           SELECT MAX (inst_no) inst_no
             INTO v_inst_no
             FROM gipi_installment
            WHERE iss_cd = 'RI' 
              AND prem_seq_no = variables_prem_seq_no;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_inst_no := 0;
        END;
        
        v_vat := ROUND (v_inv_comm_vat / v_inst_no, 2);
        
        IF NVL (giacp.v ('TAX_ALLOCATION'), 'Y') = 'Y' THEN
            v_colln_pct := ROUND (v_collection / v_collection_amt, 9);
            variables_prem_amt := ROUND (v_prem_amt * v_colln_pct, 2);
            variables_tax_amt := ROUND (v_tax * v_colln_pct, 2);
            variables_comm_vat := ROUND (v_vat * v_colln_pct, 2);
            variables_comm_amt := ROUND (v_comm * v_colln_pct, 2);
        ELSIF NVL (giacp.v ('TAX_ALLOCATION'), 'Y') = 'N' THEN
            IF NVL (v_collection, 0) = v_collection_amt THEN
                variables_prem_amt := v_prem_amt;
                variables_tax_amt := v_tax;
                variables_comm_amt := v_comm;
                variables_comm_vat := v_vat;
            ELSIF ABS (NVL (v_collection_amt, 0)) <= ABS (v_tax) THEN
                variables_prem_amt := 0;
                variables_tax_amt := v_collection_amt;
                variables_comm_amt := 0;
                variables_comm_vat := 0;
            ELSE
                IF v_prem_amt <> 0 THEN
                    v_comm_rt := v_comm_amt / v_prem_amt;

                    IF v_comm_rt <> 0 THEN
                       v_comm_vat_rt := v_vat / v_comm;
                    END IF;
                END IF;

             variables_tax_amt := v_tax;
             variables_prem_amt := ROUND ((v_collection - v_tax_amt) / (1 - v_comm_rt - (v_comm_rt * v_comm_vat_rt)), 2);
             variables_comm_amt := ROUND (v_prem * v_comm_rt, 2);
             variables_comm_vat := ROUND (v_prem * v_comm_rt * v_comm_vat_rt, 2);
            END IF;
        END IF;
        
        variables_wtax := v_wtax;
        variables_fcurrency_amt := NVL (v_collection_amt, 0) / variables_currency_rt;
        variables_collection_amt := v_collection;
        
        IF ROUND (v_prem, 2) + ROUND (v_tax_amt, 2) - ROUND (v_comm_amt, 2) - ROUND (v_comm_vat, 2) <> v_collection THEN
            IF ABS(v_collection - ROUND (v_prem, 2) - ROUND (v_tax_amt, 2) + ROUND (v_comm_amt, 2) + ROUND (v_comm_vat, 2)) = 0.01 THEN
             v_prem := v_prem + (  v_collection - ROUND (v_prem, 2) - ROUND (v_tax_amt, 2) + ROUND (v_comm_amt, 2) + ROUND (v_comm_vat, 2));
            END IF;
        END IF;
        
        UPDATE giac_aging_ri_soa_details
           SET total_payments = total_payments + variables_collection_amt,
               temp_payments = temp_payments + variables_collection_amt,
               balance_due = balance_due - variables_collection_amt,
               prem_balance_due = prem_balance_due - variables_prem_amt,
               comm_balance_due = comm_balance_due - variables_comm_amt,
               wholding_tax_bal = wholding_tax_bal - variables_wtax,
               tax_amount = tax_amount - variables_tax_amt,
               comm_vat = NVL (comm_vat, 0) - variables_comm_vat
         WHERE a180_ri_cd = variables_ri_cd
           AND prem_seq_no = variables_prem_seq_no
           AND inst_no = variables_inst_no;
    END;
    
    
    PROCEDURE insert_into_inwfacul_prem_coll (
           p_line_cd                giac_upload_inwfacul_prem.line_cd%TYPE,
           p_subline_cd             giac_upload_inwfacul_prem.subline_cd%TYPE,
           p_iss_cd                 giac_upload_inwfacul_prem.iss_cd%TYPE,
           p_issue_yy               giac_upload_inwfacul_prem.issue_yy%TYPE,
           p_pol_seq_no             giac_upload_inwfacul_prem.pol_seq_no%TYPE,
           p_renew_no               giac_upload_inwfacul_prem.renew_no%TYPE,
           p_collection_amt         giac_inwfacul_prem_collns.collection_amt%TYPE,
           p_prem_chk_flag          giac_upload_inwfacul_prem.prem_chk_flag%TYPE,
           p_prem_amt               giac_upload_inwfacul_prem.lprem_amt%TYPE,
           p_tax_amt                giac_upload_inwfacul_prem.ltax_amt%TYPE,
           p_comm_amt               giac_upload_inwfacul_prem.lcomm_amt%TYPE,
           p_comm_vat               giac_upload_inwfacul_prem.lcomm_vat%TYPE,
           p_prem_colln       OUT   giac_inwfacul_prem_collns.collection_amt%TYPE
   )
   IS
        v_assd_no         gipi_parlist.assd_no%TYPE;
        v_prem            NUMBER                      := 0;
        v_tax             NUMBER                      := 0;
        v_comm_amt        NUMBER                      := 0;
        v_comm_vat        NUMBER                      := 0;
        v_colln_amt       NUMBER                      := 0;
        v_prem_colln      NUMBER                      := 0;
        v_ins_colln_amt   NUMBER                      := 0;
   BEGIN
        v_prem_colln := p_collection_amt;
        v_prem := p_prem_amt;
        v_tax := p_tax_amt;
        v_comm_vat := p_comm_vat;
        v_comm_amt := p_comm_amt;
--        raise_application_error (-20001, 'Geniisys Exception#E#m1');
        FOR rec IN (
                  SELECT a.prem_seq_no, e.inst_no, b.line_cd pol_line_cd,
                         b.subline_cd pol_subline_cd, b.iss_cd pol_iss_cd,
                         b.issue_yy pol_issue_yy, b.pol_seq_no pol_seq_no,
                         b.renew_no pol_renew_no,
                         DECODE (b.endt_seq_no, 0, NULL, b.endt_iss_cd) endt_iss_cd,
                         DECODE (b.endt_seq_no, 0, NULL, b.endt_yy) endt_yy,
                         DECODE (b.endt_seq_no, 0, NULL, b.endt_seq_no) endt_seq_no,
                         DECODE (b.endt_seq_no, 0, NULL, b.endt_type) endt_type,
                         b.reg_policy_sw, b.incept_date, b.expiry_date, c.ri_cd,
                         c.ri_policy_no, c.ri_endt_no, c.ri_binder_no, b.assd_no, d.assd_name,
                         a.prem_amt, e.balance_due, e.prem_balance_due, e.tax_amount,
                         a.currency_cd, a.currency_rt, b.acct_ent_date, b.booking_mth,
                         b.booking_year, b.policy_id, b.par_id
                    FROM giis_assured d,
                         gipi_polbasic b,
                         giac_aging_ri_soa_details e,
                         giri_inpolbas c,
                         gipi_invoice a
                   WHERE d.assd_no = b.assd_no
                     AND b.policy_id = a.policy_id
                     AND e.prem_seq_no = a.prem_seq_no
                     AND c.policy_id = a.policy_id
                     AND e.balance_due <> 0
                     AND b.line_cd = p_line_cd
                     AND b.subline_cd = p_subline_cd
                     AND b.iss_cd = p_iss_cd
                     AND b.issue_yy = p_issue_yy
                     AND b.pol_seq_no = p_pol_seq_no
                     AND b.renew_no = p_renew_no
                   ORDER BY a.iss_cd, a.prem_seq_no, e.inst_no
           )
           LOOP
              IF rec.reg_policy_sw <> 'N' OR (rec.reg_policy_sw = 'N' AND variables_prem_payt_for_sp = 'Y') THEN
                 IF rec.assd_no IS NULL THEN
                    BEGIN
                       SELECT assd_no
                         INTO v_assd_no
                         FROM gipi_parlist
                        WHERE par_id = rec.par_id;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          raise_application_error (-20001, 'Geniisys Exception#E#' || rec.pol_iss_cd || '-' || TO_CHAR (rec.prem_seq_no) || ' has no assured.');
                    END;
                 END IF;

                IF rec.balance_due > 0 THEN
                    variables_transaction_type := 1;
                ELSE
                    variables_transaction_type := 3;
                END IF;

                IF p_prem_chk_flag IN ('OK', 'OP') THEN
                   v_colln_amt := rec.balance_due;
                ELSE
                    IF NVL (v_prem_colln, 0) < rec.balance_due THEN
                       v_colln_amt := v_prem_colln;
                    ELSE
                       v_colln_amt := rec.balance_due;
                    END IF;
                END IF;

                 variables_ri_cd := rec.ri_cd;
                 variables_prem_seq_no := rec.prem_seq_no;
                 variables_inst_no := rec.inst_no;
                 variables_currency_rt := rec.currency_rt;
                 variables_currency_cd := rec.currency_cd;
                 allocate_collection (v_colln_amt, v_prem, v_tax, v_comm_amt, v_comm_vat);

                 INSERT INTO giac_inwfacul_prem_collns
                             (gacc_tran_id, transaction_type,
                              a180_ri_cd, b140_iss_cd, b140_prem_seq_no,
                              inst_no, premium_amt,
                              comm_amt, wholding_tax,
                              currency_cd, convert_rate,
                              foreign_curr_amt, collection_amt, or_print_tag,
                              user_id, last_update, tax_amount, comm_vat
                             )
                      VALUES (variables_tran_id, variables_transaction_type,
                              variables_ri_cd, rec.pol_iss_cd, variables_prem_seq_no,
                              variables_inst_no, variables_prem_amt,
                              variables_comm_amt, variables_wtax,
                              variables_currency_cd, variables_currency_rt,
                              variables_fcurrency_amt, variables_collection_amt, 'N',
                              variables_user_id, SYSDATE, variables_tax_amt, variables_comm_vat
                             );

                 IF variables_tran_class = 'OR' AND variables_max_colln_amt < v_colln_amt THEN
                    variables_max_colln_amt := v_colln_amt;
                    variables_max_iss_cd := variables_iss_cd;
                    variables_max_prem_seq_no := variables_prem_seq_no;
                 END IF;

                 IF p_prem_chk_flag IN ('OK', 'OP')
                 THEN
                    v_ins_colln_amt := v_ins_colln_amt + v_colln_amt;
                 ELSE
                    v_prem_colln := v_prem_colln - v_colln_amt;
                 END IF;
              END IF;

              IF v_prem_colln = 0 THEN
                 EXIT;
              END IF;
           END LOOP;

           IF p_prem_chk_flag IN ('OK', 'OP')
           THEN
              p_prem_colln := v_prem_colln - v_ins_colln_amt;
           ELSE
              p_prem_colln := v_prem_colln;
           END IF;
--   raise_application_error (-20001, 'Geniisys Exception#E#m2');        
   END; 
   
    PROCEDURE create_acct_assd_entries (
       p_pay_rcv_amt   OUT   giac_upload_inwfacul_prem.lcollection_amt%TYPE
    )
    IS
        the_rowcount          NUMBER;
        v_sl_cd               NUMBER;
        v_aeg_item_no         NUMBER;
        v_dummy_pay_rcv_amt   giac_upload_inwfacul_prem.lcollection_amt%TYPE;
    BEGIN
       p_pay_rcv_amt := 0;
       the_rowcount := rg_id.COUNT;

       FOR i IN 1 .. rg_id.COUNT
       LOOP
          v_dummy_pay_rcv_amt := rg_id(i).pay_rcv_amt; 

          IF v_dummy_pay_rcv_amt <> 0 THEN
             v_sl_cd := rg_id(i).assd_no;

             IF v_dummy_pay_rcv_amt > 0 THEN
                v_aeg_item_no := 7;
             ELSE
                v_aeg_item_no := 14;
             END IF;

             upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS008', v_aeg_item_no, ABS (v_dummy_pay_rcv_amt), v_sl_cd, variables_user_id);
             p_pay_rcv_amt := p_pay_rcv_amt + v_dummy_pay_rcv_amt;
          END IF;
       END LOOP;
    END;
    
    PROCEDURE update_assured_rg (
       p_assd_no       giis_assured.assd_no%TYPE,
       p_pay_rcv_amt   giac_upload_inwfacul_prem.lcollection_amt%TYPE
    )
    IS
        new_row      NUMBER;
        total_rows   NUMBER;
        v_exists     BOOLEAN     := FALSE;
    BEGIN
       FOR i IN 1 .. rg_id.COUNT
       LOOP
          IF rg_id(i).assd_no = p_assd_no THEN
             rg_id(i).pay_rcv_amt := rg_id(i).pay_rcv_amt + p_pay_rcv_amt;
             v_exists := TRUE;
          END IF;
       END LOOP;
               
       IF NOT v_exists THEN
          rg_id.extend;
          rg_id(rg_id.count).assd_no := p_assd_no;
          rg_id(rg_id.count).pay_rcv_amt := p_pay_rcv_amt;
       END IF;
    END;
    
    PROCEDURE ins_update_giac_op_text (
       p_seq_no         NUMBER,
       p_premium_amt    gipi_invoice.prem_amt%TYPE,
       p_prem_text      VARCHAR2,
       p_currency_cd    giac_direct_prem_collns.currency_cd%TYPE,
       p_convert_rate   giac_direct_prem_collns.convert_rate%TYPE
    )
    IS
       v_exist   VARCHAR2 (1);
    BEGIN
       SELECT 'X'
         INTO v_exist
         FROM giac_op_text
        WHERE gacc_tran_id = variables_tran_id
          AND item_gen_type = variables_gen_type
          AND item_text = p_prem_text;

       UPDATE giac_op_text
          SET item_amt = NVL (p_premium_amt, 0) + NVL (item_amt, 0),
              foreign_curr_amt = NVL (p_premium_amt / p_convert_rate, 0) + NVL (foreign_curr_amt, 0)
        WHERE gacc_tran_id = variables_tran_id
          AND item_text = p_prem_text
          AND item_gen_type = variables_gen_type;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          INSERT INTO giac_op_text
                      (gacc_tran_id, item_seq_no, item_gen_type,
                       item_text, item_amt, currency_cd,
                       foreign_curr_amt, print_seq_no, user_id, last_update
                      )
               VALUES (variables_tran_id, p_seq_no, variables_gen_type,
                       p_prem_text, p_premium_amt, p_currency_cd,
                       p_premium_amt / p_convert_rate, p_seq_no, USER, SYSDATE
                      );
    END;
    
   PROCEDURE insert_update_giac_op_text (
       p_iss_cd         IN   giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
       p_prem_seq_no    IN   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
       p_premium_amt    IN   giac_inwfacul_prem_collns.premium_amt%TYPE,
       p_tax_amount     IN   giac_inwfacul_prem_collns.tax_amount%TYPE,
       p_comm_amt       IN   giac_inwfacul_prem_collns.comm_amt%TYPE,
       p_comm_vat       IN   giac_inwfacul_prem_collns.comm_vat%TYPE,
       p_currency_cd    IN   giac_inwfacul_prem_collns.currency_cd%TYPE,
       p_convert_rate   IN   giac_inwfacul_prem_collns.convert_rate%TYPE
    )
    IS
       v_tax_colln_amt        giac_tax_collns.tax_amt%TYPE;
       v_premium_amt          gipi_invoice.prem_amt%TYPE;
       n_seq_no               NUMBER (2);
       v_prem_type            VARCHAR2 (1)                                := 'E';
       v_prem_text            VARCHAR2 (25);
       v_inv_tax_amt          gipi_inv_tax.tax_amt%TYPE;
       v_inv_tax_rt           gipi_inv_tax.rate%TYPE;
       v_inv_prem_amt         gipi_invoice.prem_amt%TYPE;
       v_exempt_prem_amt      gipi_invoice.prem_amt%TYPE;
       v_init_prem_text       VARCHAR2 (25);
       v_currency_cd          giac_direct_prem_collns.currency_cd%TYPE;
       v_convert_rate         giac_direct_prem_collns.convert_rate%TYPE;
       v_or_curr_cd           giac_order_of_payts.currency_cd%TYPE;
       v_def_curr_cd          giac_order_of_payts.currency_cd%TYPE := NVL (giacp.n ('CURRENCY_CD'), 1);
       v_exist                VARCHAR2 (1);
       v_separate_vat_comm    VARCHAR2 (1);
       v_comm_inclusive_vat   VARCHAR2 (1);
       v_local_foreign_sw     VARCHAR2 (1);
       v_tot_comm             NUMBER;
    BEGIN
        v_premium_amt := p_premium_amt;
        v_tax_colln_amt := p_tax_amount;
                
        BEGIN
           SELECT DECODE (NVL (c.tax_amt, 0), 0, 'Z', 'V') prem_type,
                  c.tax_amt inv_tax_amt, c.rate inv_tax_rt, b.prem_amt inv_prem_amt
             INTO v_prem_type, v_inv_tax_amt, v_inv_tax_rt, v_inv_prem_amt
             FROM gipi_invoice b, gipi_inv_tax c
            WHERE b.iss_cd = c.iss_cd
              AND b.prem_seq_no = c.prem_seq_no
              AND c.tax_cd = giacp.n ('EVAT')
              AND c.iss_cd = p_iss_cd
              AND c.prem_seq_no = p_prem_seq_no;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              NULL;
        END;
        
        IF v_prem_type = 'V' THEN
          v_prem_text := 'PREMIUM (VATABLE)';
          n_seq_no := 1;

          IF ABS (v_inv_prem_amt - ROUND (v_inv_tax_amt / v_inv_tax_rt * 100, 2) ) * p_convert_rate > 1 THEN
             IF v_tax_colln_amt <> 0 THEN
                v_premium_amt := ROUND (v_tax_colln_amt / v_inv_tax_rt * 100, 2);
                v_exempt_prem_amt := p_premium_amt - v_premium_amt;

                IF ABS (v_exempt_prem_amt) <= 1 THEN
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
        
        FOR b1 IN (
            SELECT currency_cd
              FROM giac_order_of_payts
             WHERE gacc_tran_id = variables_tran_id
       )
       LOOP
          v_or_curr_cd := b1.currency_cd;
          EXIT;
       END LOOP;
       
       IF v_or_curr_cd = v_def_curr_cd THEN
          v_convert_rate := 1;
          v_currency_cd := v_def_curr_cd;
       ELSE
          v_convert_rate := p_convert_rate;
          v_currency_cd := p_currency_cd;
       END IF;
       
       IF variables_zero_prem_op_text = 'Y' THEN
          FOR rec IN 1 .. 3
          LOOP
             IF rec = 1
             THEN
                v_init_prem_text := 'PREMIUM (VATABLE)';
             ELSIF rec = 2
             THEN
                v_init_prem_text := 'PREMIUM (ZERO-RATED)';
             ELSE
                v_init_prem_text := 'PREMIUM (VAT-EXEMPT)';
             END IF;

             ins_update_giac_op_text (rec, 0, v_init_prem_text, v_currency_cd, v_convert_rate);
             variables_zero_prem_op_text := 'N';
          END LOOP;
       END IF;
       
       ins_update_giac_op_text (n_seq_no, v_premium_amt, v_prem_text, v_currency_cd, v_convert_rate);
       
       IF NVL (v_exempt_prem_amt, 0) <> 0 THEN
          v_prem_text := 'PREMIUM (VAT-EXEMPT)';
          n_seq_no := 3;
          ins_update_giac_op_text (n_seq_no, v_exempt_prem_amt, v_prem_text, v_currency_cd, v_convert_rate);
       END IF;
       
       IF v_prem_type = 'V' THEN
          BEGIN
             SELECT 'X'
               INTO v_exist
               FROM giac_op_text
              WHERE gacc_tran_id = variables_tran_id
                AND item_gen_type = variables_gen_type
                AND item_text = variables_evat_name;

             UPDATE giac_op_text
                SET item_amt = NVL (p_tax_amount, 0) + NVL (item_amt, 0),
                    foreign_curr_amt = NVL (p_tax_amount / v_convert_rate, 0) + NVL (foreign_curr_amt, 0)
              WHERE gacc_tran_id = variables_tran_id
                AND item_text = variables_evat_name
                AND item_gen_type = variables_gen_type;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                n_seq_no := 4;

                INSERT INTO giac_op_text
                            (gacc_tran_id, item_seq_no, item_gen_type,
                             item_text, item_amt, currency_cd,
                             foreign_curr_amt, print_seq_no, user_id,
                             last_update
                            )
                     VALUES (variables_tran_id, n_seq_no, variables_gen_type,
                             variables_evat_name, p_tax_amount, v_currency_cd,
                             p_tax_amount / v_convert_rate, n_seq_no, variables_user_id,
                             SYSDATE
                            );
          END;
       END IF;
       
       BEGIN
          SELECT param_value_v
            INTO v_separate_vat_comm
            FROM giac_parameters
           WHERE param_name LIKE 'SEPARATE_GIOT_VAT_COMM';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_separate_vat_comm := 'N';
       END;

       BEGIN
          SELECT param_value_v
            INTO v_comm_inclusive_vat
            FROM giac_parameters
           WHERE param_name LIKE 'COMM_INCLUSIVE_VAT';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_comm_inclusive_vat := 'N';
       END;
       
       IF v_separate_vat_comm = 'N' THEN
          BEGIN
             v_tot_comm := -1 * (p_comm_amt + p_comm_vat);

             SELECT 'X'
               INTO v_exist
               FROM giac_op_text
              WHERE gacc_tran_id = variables_tran_id
                AND item_gen_type = variables_gen_type
                AND item_text = 'RI COMMISSION';

             UPDATE giac_op_text
                SET item_amt = NVL (v_tot_comm, 0) + NVL (item_amt, 0),
                    foreign_curr_amt = NVL (v_tot_comm / v_convert_rate, 0) + NVL (foreign_curr_amt, 0)
              WHERE gacc_tran_id = variables_tran_id
                AND item_text = 'RI COMMISSION'
                AND item_gen_type = variables_gen_type;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                n_seq_no := 5;

                INSERT INTO giac_op_text
                            (gacc_tran_id, item_seq_no, item_gen_type,
                             item_text, item_amt, currency_cd,
                             foreign_curr_amt, print_seq_no, user_id, last_update
                            )
                     VALUES (variables_tran_id, n_seq_no, variables_gen_type,
                             'RI COMMISSION', v_tot_comm, v_currency_cd,
                             v_tot_comm / v_convert_rate, n_seq_no, variables_user_id, SYSDATE
                            );
          END;
       ELSE
          IF v_comm_inclusive_vat = 'Y' THEN
             SELECT local_foreign_sw
               INTO v_local_foreign_sw
               FROM giis_reinsurer a
              WHERE a.ri_cd = variables_ri_cd;

             IF v_local_foreign_sw = 'L' THEN
                BEGIN
                   SELECT 'X'
                     INTO v_exist
                     FROM giac_op_text
                    WHERE gacc_tran_id = variables_tran_id
                      AND item_gen_type = variables_gen_type
                      AND item_text = 'RI COMMISSION';

                   UPDATE giac_op_text
                      SET item_amt = NVL (p_comm_amt, 0) * -1 + NVL (item_amt, 0),
                          foreign_curr_amt =
                                 NVL (p_comm_amt / v_convert_rate, 0)
                               * -1
                             + NVL (foreign_curr_amt, 0)
                    WHERE gacc_tran_id = variables_tran_id
                      AND item_text = 'RI COMMISSION'
                      AND item_gen_type = variables_gen_type;
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      n_seq_no := 5;

                      INSERT INTO giac_op_text
                                  (gacc_tran_id, item_seq_no, item_gen_type,
                                   item_text, item_amt,
                                   currency_cd,
                                   foreign_curr_amt, print_seq_no,
                                   user_id, last_update
                                  )
                           VALUES (variables_tran_id, n_seq_no, variables_gen_type,
                                   'RI COMMISSION', p_comm_amt * -1,
                                   v_currency_cd,
                                   (p_comm_amt * -1) / v_convert_rate, n_seq_no,
                                   USER, SYSDATE
                                  );
                END;
             
                BEGIN
                   SELECT 'X'
                     INTO v_exist
                     FROM giac_op_text
                    WHERE gacc_tran_id = variables_tran_id
                      AND item_gen_type = variables_gen_type
                      AND item_text = 'RI VAT ON COMMISSION';

                   UPDATE giac_op_text
                      SET item_amt = NVL (p_comm_vat, 0) * -1 + NVL (item_amt, 0),
                          foreign_curr_amt =
                               NVL (p_comm_vat / v_convert_rate, 0) * -1
                             + NVL (foreign_curr_amt, 0)
                    WHERE gacc_tran_id = variables_tran_id
                      AND item_text = 'RI VAT ON COMMISSION'
                      AND item_gen_type = variables_gen_type;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      n_seq_no := 6;

                      INSERT INTO giac_op_text
                                  (gacc_tran_id, item_seq_no,
                                   item_gen_type, item_text,
                                   item_amt, currency_cd,
                                   foreign_curr_amt, print_seq_no,
                                   user_id, last_update
                                  )
                           VALUES (variables_tran_id, n_seq_no,
                                   variables_gen_type, 'RI VAT ON COMMISSION',
                                   p_comm_vat * -1, v_currency_cd,
                                   (p_comm_vat * -1
                                   ) / v_convert_rate, n_seq_no,
                                   variables_user_id, SYSDATE
                                  );
                END;
             ELSE
                BEGIN
                   v_tot_comm := -1 * (p_comm_amt + p_comm_vat);

                   SELECT 'X'
                     INTO v_exist
                     FROM giac_op_text
                    WHERE gacc_tran_id = variables_tran_id
                      AND item_gen_type = variables_gen_type
                      AND item_text = 'RI COMMISSION';

                   UPDATE giac_op_text
                      SET item_amt = NVL (v_tot_comm, 0) + NVL (item_amt, 0),
                          foreign_curr_amt = NVL (v_tot_comm / v_convert_rate, 0) + NVL (foreign_curr_amt, 0)
                    WHERE gacc_tran_id = variables_tran_id
                      AND item_text = 'RI COMMISSION'
                      AND item_gen_type = variables_gen_type;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      n_seq_no := 5;

                      INSERT INTO giac_op_text
                                  (gacc_tran_id, item_seq_no,
                                   item_gen_type, item_text,
                                   item_amt, currency_cd,
                                   foreign_curr_amt, print_seq_no, user_id,
                                   last_update
                                  )
                           VALUES (variables_tran_id, n_seq_no,
                                   variables_gen_type, 'RI COMMISSION',
                                   v_tot_comm, v_currency_cd,
                                   v_tot_comm / v_convert_rate, n_seq_no, variables_user_id,
                                   SYSDATE
                                  );
                END;
             END IF;
          END IF;
       END IF;
    END;
    
   PROCEDURE generate_op_text
   IS
        CURSOR c
           IS
              SELECT a.b140_iss_cd iss_cd, a.b140_prem_seq_no prem_seq_no,
                     a.premium_amt, a.tax_amount, a.comm_amt, a.comm_vat,
                     a.currency_cd, a.convert_rate
                FROM gipi_polbasic c, gipi_invoice b, giac_inwfacul_prem_collns a
               WHERE b.policy_id = c.policy_id
                 AND a.b140_iss_cd = b.iss_cd
                 AND a.b140_prem_seq_no = b.prem_seq_no
                 AND gacc_tran_id = variables_tran_id;

        v_last_rec       NUMBER;
        v_counter        NUMBER  := 1;
        v_cursor_exist   BOOLEAN;
   BEGIN
        BEGIN
           SELECT tax_name
             INTO variables_evat_name
             FROM giac_taxes
            WHERE tax_cd = giacp.n ('EVAT');
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#No data found in table GIAC_TAXES for EVAT.');
        END;
        
        DELETE FROM giac_op_text
         WHERE gacc_tran_id = variables_tran_id
           AND item_gen_type = variables_gen_type;

        variables_zero_prem_op_text := 'Y';
        
        FOR c_rec IN c
        LOOP
              insert_update_giac_op_text (c_rec.iss_cd,
                                          c_rec.prem_seq_no,
                                          c_rec.premium_amt,
                                          c_rec.tax_amount,
                                          c_rec.comm_amt,
                                          c_rec.comm_vat,
                                          c_rec.currency_cd,
                                          c_rec.convert_rate
                                         );
              v_cursor_exist := TRUE;
        END LOOP;
        
        variables_zero_prem_op_text := 'N';

         DELETE giac_op_text
          WHERE gacc_tran_id = variables_tran_id
            AND NVL (item_amt, 0) = 0
            AND SUBSTR (item_text, 1, 9) <> ('PREMIUM (')
            AND item_gen_type = variables_gen_type;
   END;
   
   
   --NEED TO CHECK
   PROCEDURE generate_dep_op_text
   IS
    CURSOR c
       IS
        SELECT DISTINCT a.gacc_tran_id, a.collection_amt item_amt,
                           a.b140_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999')) bill_no,
                        a.user_id, a.last_update, 'Premium Deposit' item_text,
                        a.currency_cd, a.foreign_curr_amt
                   FROM giac_prem_deposit a
                  WHERE gacc_tran_id = variables_tran_id;

        v_seq_no   giac_op_text.item_seq_no%TYPE   := 1;
   BEGIN
        BEGIN
           SELECT generation_type
             INTO variables_gen_type
             FROM giac_modules
            WHERE module_name = 'GIACS026';
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
        END;
        
        DELETE FROM giac_op_text
         WHERE gacc_tran_id = variables_tran_id
           AND item_gen_type = variables_gen_type;
           
        FOR c_rec IN c
        LOOP
            INSERT INTO giac_op_text
                        (gacc_tran_id, item_gen_type, item_seq_no,
                         item_amt, user_id, last_update, bill_no,
                         item_text, print_seq_no, currency_cd,
                         foreign_curr_amt
                        )
                 VALUES (c_rec.gacc_tran_id, variables_gen_type, v_seq_no,
                         c_rec.item_amt, c_rec.user_id, c_rec.last_update, c_rec.bill_no,
                         c_rec.item_text, v_seq_no, c_rec.currency_cd,
                         c_rec.foreign_curr_amt
                        );

          v_seq_no := v_seq_no + 1;
        END LOOP;
   END;
   
    PROCEDURE generate_misc_op_text (
       p_item_text   giac_op_text.item_text%TYPE,
       p_item_amt    giac_op_text.item_amt%TYPE
    )
    IS
       v_seq_no   giac_op_text.item_seq_no%TYPE;
    BEGIN
       BEGIN
          SELECT generation_type
            INTO variables_gen_type
            FROM giac_modules
           WHERE module_name = 'GIACS608';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error (-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
       END;
       
       BEGIN
          SELECT NVL (MAX (item_seq_no), 0) + 1
            INTO v_seq_no
            FROM giac_op_text
           WHERE gacc_tran_id = variables_tran_id
             AND item_gen_type = variables_gen_type;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_seq_no := 1;
       END;
       
        INSERT INTO giac_op_text
                    (gacc_tran_id, item_seq_no, print_seq_no, item_amt,
                     item_gen_type, item_text, currency_cd,
                     foreign_curr_amt, user_id, last_update
                    )
             VALUES (variables_tran_id, v_seq_no, v_seq_no, p_item_amt,
                     variables_gen_type, p_item_text, variables_currency_cd,
                     p_item_amt, variables_user_id, SYSDATE
                    );
    END;
        
   
   PROCEDURE process_payments (
        p_reinsurer giis_reinsurer.ri_name%TYPE
   )
   IS
        v_line_cd               giac_upload_inwfacul_prem.line_cd%TYPE;
        v_subline_cd            giac_upload_inwfacul_prem.subline_cd%TYPE;
        v_iss_cd                giac_upload_inwfacul_prem.iss_cd%TYPE;
        v_issue_yy              giac_upload_inwfacul_prem.issue_yy%TYPE;
        v_pol_seq_no            giac_upload_inwfacul_prem.pol_seq_no%TYPE;
        v_renew_no              giac_upload_inwfacul_prem.renew_no%TYPE;
        v_prem_chk_flag         giac_upload_inwfacul_prem.prem_chk_flag%TYPE;
        v_collection_amt        giac_upload_inwfacul_prem.lcollection_amt%TYPE;
        v_prem_amt              giac_upload_inwfacul_prem.lprem_amt%TYPE;
        v_tax_amt               giac_upload_inwfacul_prem.ltax_amt%TYPE;
        v_comm_amt              giac_upload_inwfacul_prem.lcomm_amt%TYPE;
        v_comm_vat              giac_upload_inwfacul_prem.lcomm_vat%TYPE;
        v_prem_dep              giac_upload_inwfacul_prem.lcollection_amt%TYPE := 0;
        v_tot_amt_due           giac_upload_inwfacul_prem.tot_amt_due%TYPE;
        v_acct_payable_amt      giac_upload_inwfacul_prem.lcollection_amt%TYPE;
        v_other_income_amt      giac_upload_inwfacul_prem.lcollection_amt%TYPE := 0;
        v_acct_payable_min      NUMBER := giacp.n('ACCTS_PAYABLE_MIN');
        v_premcol_exp_max       NUMBER := giacp.n('PREMCOL_EXP_MAX');
        v_sl_cd                 giac_acct_entries.sl_cd%TYPE;
        v_aeg_item_no           giac_module_entries.item_no%TYPE;
        v_dummy_prem_chk_flag   giac_upload_inwfacul_prem.prem_chk_flag%TYPE;
        v_dummy_expense_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE;
        v_other_expense_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE := 0;
        v_prem_colln            giac_upload_inwfacul_prem.lcollection_amt%TYPE;
        v_pay_amt               giac_upload_inwfacul_prem.lcollection_amt%TYPE;
        v_other_exp_inc_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE := 0;
        v_other_exp_inc_tot     giac_upload_inwfacul_prem.lcollection_amt%TYPE := 0;
        v_assd_no               giis_assured.assd_no%TYPE;
        v_pay_rcv_assd_amt      giac_upload_inwfacul_prem.lcollection_amt%TYPE := 0;
        v_dummy_exp_inc_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE;
   BEGIN
       FOR i IN(
            SELECT *
              FROM giac_upload_inwfacul_prem
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no
       )
       LOOP
            rg_id           := assured_rg_tab ();
            v_line_cd       := i.line_cd;
            v_subline_cd    := i.subline_cd;
            v_iss_cd        := i.iss_cd;
            v_issue_yy      := i.issue_yy;
            v_pol_seq_no    := i.pol_seq_no;
            v_renew_no      := i.renew_no;
            v_prem_chk_flag := i.prem_chk_flag;
            v_collection_amt := i.lcollection_amt;
            v_prem_amt      := i.lprem_amt;
            v_tax_amt       := i.ltax_amt;
            v_comm_amt      := i.lcomm_amt;
            v_comm_vat      := i.lcomm_vat;
            v_tot_amt_due   := i.tot_amt_due;
            
            FOR assd_rec IN (
                SELECT assd_no, par_id
                  FROM gipi_polbasic
                 WHERE 1 = 1
                   AND line_cd = i.line_cd
                   AND subline_cd = i.subline_cd
                   AND iss_cd = i.iss_cd
                   AND issue_yy = i.issue_yy
                   AND pol_seq_no = i.pol_seq_no
                   AND renew_no = i.renew_no
                   AND endt_seq_no = 0
            )
            LOOP    
                v_assd_no := assd_rec.assd_no;
                IF v_assd_no IS NULL THEN
                    FOR assd_rec2 IN (
                        SELECT assd_no
                          FROM gipi_parlist
                         WHERE par_id = assd_rec.par_id
                    )
                    LOOP
                        v_assd_no := assd_rec2.assd_no;
                    END LOOP;
                END IF;
                EXIT;
            END LOOP;
            
            get_sl_cd('GIACS008');
            IF v_prem_chk_flag IN ('SP', 'NA', 'IP', 'DI') THEN
                v_prem_dep := nvl(v_prem_dep, 0) + v_collection_amt;                
            ELSE
                IF v_tot_amt_due < 0 AND v_collection_amt > 0 AND v_prem_chk_flag = 'OP' THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#nn4');
                    IF v_collection_amt >= v_acct_payable_min THEN
                        update_assured_rg(v_assd_no, v_collection_amt);
                    ELSE
                        v_sl_cd := giacp.n('OTHER_INCOME_SL');
                        v_aeg_item_no := 8;
                        v_other_income_amt := nvl(v_other_income_amt, 0) + v_collection_amt;
                        upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS008', v_aeg_item_no, v_collection_amt, v_sl_cd, variables_user_id);
                    END IF; 
                    
                ELSIF v_prem_chk_flag IN ('OK', 'PT', 'OP', 'ON') THEN
                    v_dummy_prem_chk_flag    := v_prem_chk_flag;
                    v_dummy_expense_amt := 0;
                    
                    IF v_prem_chk_flag = 'PT' AND (abs(v_tot_amt_due - v_collection_amt) <= v_premcol_exp_max) THEN
                        v_dummy_prem_chk_flag := 'OK';
                        v_dummy_expense_amt := v_tot_amt_due - v_collection_amt;
                        IF v_collection_amt > 0 THEN
                            v_sl_cd := get_pol_assd_no(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no);
                            v_aeg_item_no := 11;
                            v_other_expense_amt := nvl(v_other_expense_amt, 0) + v_dummy_expense_amt;
                        ELSE
                            v_sl_cd := get_pol_assd_no(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no);
                            v_aeg_item_no := 16;
                            v_other_income_amt := nvl(v_other_income_amt, 0) + abs(v_dummy_expense_amt);
                        END IF;    
                        upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS008', v_aeg_item_no, abs(v_dummy_expense_amt), v_sl_cd, variables_user_id);
                    END IF;
                    insert_into_inwfacul_prem_coll (v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, 
                                                    v_renew_no, v_collection_amt + v_dummy_expense_amt, v_prem_chk_flag, 
                                                    v_prem_amt, v_tax_amt, v_comm_amt, v_comm_vat, v_prem_colln);                              
                    IF v_prem_chk_flag = 'OP' THEN
                        IF v_prem_colln >= v_acct_payable_min THEN
                            update_assured_rg(v_assd_no, v_prem_colln);
                        ELSE
                            v_sl_cd := giacp.n('OTHER_INCOME_SL');
                            v_aeg_item_no := 8;
                            v_other_income_amt := nvl(v_other_income_amt, 0) + v_prem_colln;
                            upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS008', v_aeg_item_no, v_prem_colln, v_sl_cd, variables_user_id);
                        END IF;
                                                    
                    ELSIF v_prem_chk_flag = 'ON' THEN
                        IF abs(v_prem_colln) > v_premcol_exp_max THEN 
                            v_sl_cd := get_pol_assd_no(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no);
                            v_aeg_item_no := 14;        
                            v_other_expense_amt := nvl(v_other_expense_amt, 0) + abs(v_prem_colln);
                            update_assured_rg(v_assd_no, v_prem_colln);
                        ELSE
                            v_sl_cd := get_pol_assd_no(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no);
                            v_aeg_item_no := 13;        
                            v_other_income_amt := nvl(v_other_income_amt, 0) + abs(v_prem_colln);
                        END IF;
                        
                        upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS008', v_aeg_item_no, abs(v_prem_colln), v_sl_cd, variables_user_id);
                    END IF; 
                    
                ELSIF v_prem_chk_flag IN ('FP', 'CP', 'SL', 'NP') THEN 
                    update_assured_rg(v_assd_no, v_collection_amt);
                END IF;
                
            END IF;
       END LOOP;
       create_acct_assd_entries(v_pay_rcv_assd_amt);
       v_other_exp_inc_amt := v_other_income_amt - v_other_expense_amt;
       v_other_exp_inc_tot := v_other_income_amt - v_other_expense_amt;
       IF v_prem_dep <> 0 THEN
          INSERT INTO giac_prem_deposit
                      (gacc_tran_id, item_no, transaction_type, collection_amt,
                       dep_flag, currency_cd,
                       convert_rate, foreign_curr_amt, upload_tag,
                       colln_dt, or_print_tag, or_tag, user_id, last_update
                      )
               VALUES (variables_tran_id, 1, 1, v_prem_dep,
                       1, variables_currency_cd,
                       variables_convert_rate, v_prem_dep, 'Y',
                       TRUNC (variables_tran_date), 'N', 'N', variables_user_id, SYSDATE
                      );

          upload_dpc_web.aeg_parameters_pdep (variables_tran_id, 'GIACS026', variables_user_id);
       END IF;
       
       upload_dpc_web.aeg_parameters_inwfacul (variables_tran_id, 'GIACS008', variables_sl_type_cd1, variables_sl_type_cd2, variables_user_id);
       generate_op_text;
       IF v_prem_dep <> 0 THEN
          generate_dep_op_text;
       END IF;
       
       IF variables_tran_class = 'OR' THEN
          IF v_pay_rcv_assd_amt > 0 THEN
             generate_misc_op_text ('ACCOUNTS PAYABLE - REINSURER', v_pay_rcv_assd_amt);
          ELSIF v_pay_rcv_assd_amt < 0 THEN
             generate_misc_op_text ('ACCOUNTS RECEIVABLE - REINSURER', v_pay_rcv_assd_amt);
          END IF;
       END IF;
       
       IF v_other_income_amt <> 0 THEN
          generate_misc_op_text ('OTHER INCOME', v_other_income_amt);
       END IF;

       IF v_other_expense_amt <> 0 THEN
          generate_misc_op_text ('OTHER EXPENSE', v_other_expense_amt * -1);
       END IF;
   END;
   
   PROCEDURE generate_or
   IS
        v_count           NUMBER := 0;
        v_tran_year       giac_acctrans.tran_year%TYPE;
        v_tran_month      giac_acctrans.tran_month%TYPE;
        v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
        v_tin             giis_reinsurer.ri_tin%TYPE;
        v_add1            giis_reinsurer.mail_address1%TYPE;
        v_add2            giis_reinsurer.mail_address2%TYPE;
        v_add3            giis_reinsurer.mail_address3%TYPE;
        v_cashier         giac_dcb_users.cashier_cd%TYPE;
        v_particulars     giac_order_of_payts.particulars%TYPE;
        v_fcurrency       giac_collection_dtl.fcurrency_amt%TYPE;
        v_ri_cd           NUMBER;
        v_dsp_collection_amt    NUMBER;
        v_currency_cd     giac_upload_inwfacul_prem.currency_cd%TYPE;
        v_exist            VARCHAR2(1) := 'N';
        
    BEGIN
       SELECT COUNT (*)
         INTO v_count
         FROM giac_upload_inwfacul_prem
        WHERE source_cd = variables_source_cd 
          AND file_no = variables_file_no;
          
        SELECT SUM (lcollection_amt)
          INTO v_dsp_collection_amt
          FROM giac_upload_inwfacul_prem
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
           
        FOR i IN(
            SELECT *
              FROM giac_upload_inwfacul_prem
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no
        )
        LOOP
            i.currency_cd := v_currency_cd;
            EXIT;
        END LOOP;
           
        
          
       BEGIN 
        SELECT ri_cd
          INTO v_ri_cd
          FROM giac_upload_file
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
        
       END;

       IF v_count = 0 THEN
          raise_application_error (-20001, 'Geniisys Exception#E#No records to be uploaded.');
       END IF;
       
       BEGIN
           SELECT 'Y'
             INTO v_exist
             FROM giac_upload_colln_dtl
            WHERE source_cd = variables_source_cd 
              AND file_no = variables_file_no; 
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_exist := 'N';
           WHEN TOO_MANY_ROWS THEN
              v_exist := 'Y';     
       END;
            
       IF nvl(v_exist, 'N') = 'N' THEN
          raise_application_error (-20001, 'Geniisys Exception#E#Please provide Collection Payment details.');
       END IF;
       
        SELECT acctran_tran_id_s.NEXTVAL
          INTO variables_tran_id
          FROM SYS.DUAL;
          
       BEGIN
          SELECT ri_tin, mail_address1, mail_address2, mail_address3
            INTO v_tin, v_add1, v_add2, v_add3
            FROM giis_reinsurer
           WHERE ri_cd = v_ri_cd; 
       EXCEPTION
            WHEN no_data_found THEN
              null;
       END;   
       
        BEGIN
           SELECT cashier_cd
             INTO v_cashier
             FROM giac_dcb_users
            WHERE dcb_user_id = variables_user_id
              AND gibr_fund_cd = variables_fund_cd
              AND gibr_branch_cd = variables_branch_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              NULL;
        END;
        
        BEGIN
           FOR ri IN (
                SELECT ri_name
                  FROM giis_reinsurer
                 WHERE ri_cd = v_ri_cd
           )
           LOOP
              variables_reinsurer := ri.ri_name;
           END LOOP;
        END;    
        
        v_particulars       := 'Representing payment of premium and taxes for various policies.';    
        variables_tran_date := to_date(to_char(SYSDATE, 'MM-DD-YYYY')||' '||to_char(SYSDATE,'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
        v_tran_month        := to_number(to_char(variables_tran_date, 'MM'));
        v_tran_year         := to_number(to_char(variables_tran_date, 'YYYY'));
        v_tran_seq_no       := giac_sequence_generation(variables_fund_cd, variables_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month); 
        
        
        INSERT INTO giac_acctrans
                    (tran_id, gfun_fund_cd, gibr_branch_cd,
                     tran_date, tran_flag, tran_class, tran_class_no, particulars,
                     tran_year, tran_month, tran_seq_no, user_id, last_update
                    )
             VALUES (variables_tran_id, variables_fund_cd, variables_branch_cd,
                     variables_tran_date, 'O', 'COL', variables_dcb_no, NULL,
                     v_tran_year, v_tran_month, v_tran_seq_no, variables_user_id, SYSDATE
                    );  
                    
        INSERT INTO giac_order_of_payts
                    (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                     payor, collection_amt,
                     cashier_cd, address_1, address_2, address_3, particulars,
                     or_flag, dcb_no, gross_amt,
                     currency_cd, gross_tag, user_id, last_update, tin, upload_tag,
                     or_date
                    )
             VALUES (variables_tran_id, variables_fund_cd, variables_branch_cd,
                     variables_reinsurer, v_dsp_collection_amt,
                     v_cashier, v_add1, v_add2, v_add3, v_particulars,
                     'N', variables_dcb_no, v_dsp_collection_amt,
                     v_currency_cd, 'Y', variables_user_id, SYSDATE, v_tin, 'Y',
                     variables_tran_date
                    );
                    
        FOR rec IN (
            SELECT item_no, pay_mode, amount, gross_amt, commission_amt, vat_amt,
                   check_class, check_date, check_no, particulars, bank_cd, currency_cd,
                   currency_rt, fc_gross_amt, dcb_bank_cd, dcb_bank_acct_cd
              FROM giac_upload_colln_dtl
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no
        )
        LOOP                                          
          v_fcurrency := ROUND(rec.amount / rec.currency_rt, 2);

            INSERT INTO giac_collection_dtl
                        (gacc_tran_id, item_no, currency_cd,
                         currency_rt, pay_mode, amount, check_date,
                         check_no, particulars, bank_cd, check_class,
                         fcurrency_amt, gross_amt, commission_amt, vat_amt,
                         fc_gross_amt, user_id, last_update, due_dcb_no,
                         due_dcb_date, dcb_bank_cd,
                         dcb_bank_acct_cd
                        )
                 VALUES (variables_tran_id, rec.item_no, rec.currency_cd,
                         rec.currency_rt, rec.pay_mode, rec.amount, rec.check_date,
                         rec.check_no, rec.particulars, rec.bank_cd, rec.check_class,
                         v_fcurrency, rec.gross_amt, rec.commission_amt, rec.vat_amt,
                         rec.fc_gross_amt, variables_user_id, SYSDATE, variables_dcb_no,
                         TRUNC (variables_tran_date), rec.dcb_bank_cd,
                         rec.dcb_bank_acct_cd
                        );                                                                                              
        END LOOP;  
        
        upload_dpc_web.aeg_parameters(variables_tran_id, variables_branch_cd, variables_fund_cd, 'GIACS001', variables_user_id);
        process_payments(NULL); 

        UPDATE giac_upload_inwfacul_prem
           SET tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no;  
               
        DELETE FROM giac_upload_dv_payt_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no; 
              
        DELETE FROM giac_upload_jv_payt_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no; 

        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               tran_class = 'COL',
               tran_id = variables_tran_id,
               tran_date = TRUNC (variables_tran_date)
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no; 
          
          
    END;
   
   PROCEDURE generate_dv
   IS
        v_exist            VARCHAR2(1) := 'N';
        v_tran_flag     giac_acctrans.tran_flag%TYPE;
        v_tran_class    giac_acctrans.tran_class%TYPE;
        v_doc_seq_no    giac_payt_requests.doc_seq_no%TYPE;
        v_ref_id        NUMBER;
        v_list          giac_upload_dv_payt_dtl%ROWTYPE;
   BEGIN
        BEGIN
           SELECT 'Y'
             INTO v_exist
             FROM giac_upload_dv_payt_dtl
            WHERE source_cd = variables_source_cd 
              AND file_no = variables_file_no; 
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_exist := 'N';
           WHEN TOO_MANY_ROWS THEN
              v_exist := 'Y';
        END;
            
        IF nvl(v_exist, 'N') = 'N' THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Please provide DV Payment details.');
        END IF;    
        
        SELECT *
          INTO v_list
          FROM giac_upload_dv_payt_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
        
        SELECT acctran_tran_id_s.NEXTVAL
            INTO variables_tran_id
            FROM sys.dual;
            
        v_tran_flag  := 'O';
        v_tran_class := 'DV';
        variables_tran_date := v_list.request_date;
        
        INSERT INTO giac_acctrans
                (tran_id, gfun_fund_cd, gibr_branch_cd,
                 tran_flag, tran_date, tran_class,
                 user_id, last_update
                )
         VALUES (variables_tran_id, variables_fund_cd, v_list.branch_cd,
                 v_tran_flag, variables_tran_date, v_tran_class,
                 variables_user_id, SYSDATE
                );
                
        SELECT gprq_ref_id_s.NEXTVAL
          INTO v_ref_id
          FROM SYS.DUAL;
          
        INSERT INTO giac_payt_requests
                    (gouc_ouc_id, ref_id, fund_cd,
                     branch_cd, document_cd, request_date,
                     line_cd, doc_year, doc_mm, user_id,
                     last_update, with_dv, upload_tag, create_by
                    )
             VALUES (v_list.gouc_ouc_id, v_ref_id, variables_fund_cd,
                     v_list.branch_cd, v_list.document_cd, v_list.request_date,
                     v_list.line_cd, v_list.doc_year, v_list.doc_mm, variables_user_id,
                     SYSDATE, 'N', 'Y', variables_user_id
                    );
                    
        INSERT INTO giac_payt_requests_dtl
                    (req_dtl_no, gprq_ref_id, payee_class_cd, payt_req_flag,
                     payee_cd, payee, currency_cd,
                     payt_amt, tran_id, particulars,
                     user_id, last_update, dv_fcurrency_amt, currency_rt
                    )
             VALUES (1, v_ref_id, v_list.payee_class_cd, 'N',
                     v_list.payee_cd, v_list.payee, v_list.currency_cd,
                     v_list.payt_amt, variables_tran_id, v_list.particulars,
                     variables_user_id, SYSDATE, v_list.dv_fcurrency_amt, v_list.currency_rt
                    );
                    
        BEGIN
           SELECT doc_seq_no
             INTO v_doc_seq_no
             FROM giac_payt_requests
            WHERE ref_id = v_ref_id;
        EXCEPTION
           WHEN OTHERS THEN
              raise_application_error (-20001, 'Geniisys Exception#E#Error retrieving DOC_SEQ_NO.');
        END; 
        
        upload_dpc_web.set_fixed_variables(variables_fund_cd, v_list.branch_cd, null);
        
        process_payments (NULL);

        UPDATE giac_upload_dv_payt_dtl
           SET doc_seq_no = v_doc_seq_no
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
                 
        DELETE FROM giac_upload_jv_payt_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
                      
        DELETE FROM giac_upload_colln_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;      
                      
        UPDATE giac_upload_inwfacul_prem
           SET tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
                 
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               tran_id = variables_tran_id,
               tran_class = v_tran_class,
               tran_date = TRUNC (variables_tran_date)
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
                
   END;
   
   
   PROCEDURE generate_jv
   IS
        v_exist                VARCHAR2(1) := 'N';
        v_tran_year          giac_acctrans.tran_year%TYPE;
        v_tran_month         giac_acctrans.tran_month%TYPE;
        v_tran_seq_no        giac_acctrans.tran_seq_no%TYPE;
        v_tran_date          giac_acctrans.tran_date%TYPE;
        v_jv_pref_suff         giac_acctrans.jv_pref_suff%TYPE;  
        v_jv_no                giac_acctrans.jv_no%TYPE;  
        v_particulars        giac_acctrans.particulars%TYPE;
        v_jv_tran_tag        giac_acctrans.jv_tran_tag%TYPE;
        v_jv_tran_type       giac_acctrans.jv_tran_type%TYPE;
        v_jv_tran_mm         giac_acctrans.jv_tran_mm%TYPE;
        v_jv_tran_yy         giac_acctrans.jv_tran_yy%TYPE;
        v_tran_flag          giac_acctrans.tran_flag%TYPE;
        v_tran_class           giac_acctrans.tran_class%TYPE;  
        v_tran_class_no      giac_acctrans.tran_class_no%TYPE;
        v_list              giac_upload_jv_payt_dtl%ROWTYPE;
   BEGIN
        BEGIN
           SELECT 'Y'
             INTO v_exist
             FROM giac_upload_jv_payt_dtl
            WHERE source_cd = variables_source_cd 
              AND file_no = variables_file_no;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_exist := 'N';
           WHEN TOO_MANY_ROWS THEN
              v_exist := 'Y';
        END;
            
        IF nvl(v_exist, 'N') = 'N' THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Please provide JV Request details.');
        END IF;    
        
        SELECT acctran_tran_id_s.NEXTVAL
          INTO variables_tran_id
          FROM sys.dual;
          
        SELECT *
          INTO v_list
          FROM giac_upload_jv_payt_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
          
        v_tran_flag     := 'O';
        v_tran_class      := 'JV';
        v_tran_class_no := giac_sequence_generation(variables_fund_cd, v_list.branch_cd, v_tran_class, v_list.tran_year, v_list.tran_month);
        v_jv_no         := v_tran_class_no;
        variables_tran_date := v_list.tran_date;
        
        INSERT INTO giac_acctrans
                    (tran_id, gfun_fund_cd, gibr_branch_cd,
                     tran_flag, tran_date, tran_year,
                     tran_month, tran_class, tran_class_no,
                     jv_pref_suff, jv_no, particulars,
                     jv_tran_tag, jv_tran_type,
                     jv_tran_mm, jv_tran_yy, ae_tag, upload_tag, user_id, last_update
                    )
             VALUES (variables_tran_id, variables_fund_cd, v_list.branch_cd,
                     v_tran_flag, v_list.tran_date, v_list.tran_year,
                     v_list.tran_month, v_tran_class, v_tran_class_no,
                     v_list.jv_pref_suff, v_jv_no, v_list.particulars,
                     v_list.jv_tran_tag, v_list.jv_tran_type,
                     v_list.jv_tran_mm, v_list.jv_tran_yy, 'N', 'Y', variables_user_id, SYSDATE
                    );
                    
        upload_dpc_web.set_fixed_variables(variables_fund_cd, v_list.branch_cd, null);
        process_payments (NULL);
        
        UPDATE giac_upload_jv_payt_dtl
           SET jv_no = v_jv_no
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;

        DELETE FROM giac_upload_dv_payt_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;

        DELETE FROM giac_upload_colln_dtl
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;

        UPDATE giac_upload_inwfacul_prem
           SET tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;

        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               tran_class = v_tran_class,
               tran_id = variables_tran_id,
               tran_date = TRUNC (variables_tran_date)
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;   
   END;
   
   PROCEDURE upload_payments
   IS
       v_list          guf_tab2; 
   BEGIN
       variables_upload_payt_tag := 'Y';
       
       SELECT *
          BULK COLLECT INTO v_list
          FROM TABLE (GIACS608_PKG.GET_GUF_DETAILS(variables_source_cd, variables_file_no));
       
       IF variables_tran_class = 'OR' THEN
          FOR guf IN 1 .. v_list.COUNT
          LOOP
              IF v_list(guf).nbt_or_tag = 'I' THEN
                gen_individual_or;
              ELSE
                gen_group_or;
              END IF;
          END LOOP;
          --generate_or;            --nieko Accounting Uploading GIACS608
       ELSIF variables_tran_class = 'DV' THEN
          generate_dv;
       ELSIF variables_tran_class = 'JV' THEN
          generate_jv;
       END IF;

       variables_upload_payt_tag := 'N';
   END;
   
   PROCEDURE upload_giacs608(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2
   )
   IS
        v_tran_id           NUMBER;
        v_tran_date         DATE;
        v_branch_cd         VARCHAR2(2);
        v_request_date      DATE;
   BEGIN
        variables_file_no       := p_file_no;
        variables_source_cd     := p_source_cd;
        
        IF variables_tran_class = 'OR' THEN
            BEGIN
                SELECT tran_id
                  INTO v_tran_id
                  FROM giac_upload_colln_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no
              GROUP BY tran_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_tran_id := NULL;
            END;
            
            IF v_tran_id IS NULL THEN
                upload_payments;
            ELSE
                /*BEGIN
                   SELECT due_dcb_date
                     INTO variables_tran_date
                     FROM giac_collection_dtl
                    WHERE gacc_tran_id = v_tran_id;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      variables_tran_date := NULL;
                END;*/
                
                variables_tran_id := v_tran_id;
                process_payments(null);
                
                UPDATE giac_upload_inwfacul_prem
                   SET tran_id = variables_tran_id,
                       tran_date = variables_tran_date
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
                   
                DELETE FROM giac_upload_dv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
                   
                DELETE FROM giac_upload_jv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
                   
                UPDATE giac_upload_file
                   SET upload_date = SYSDATE,
                       file_status = 2,
                       tran_class = 'COL',
                       tran_id = variables_tran_id,
                       tran_date = TRUNC (variables_tran_date)
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;

            
            END IF;
              
        ELSIF variables_tran_class = 'JV' THEN           
            BEGIN
                SELECT tran_id, tran_date, branch_cd
                  INTO v_tran_id, v_tran_date, v_branch_cd
                  FROM giac_upload_jv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_tran_id := NULL;
            END;
            
            IF v_tran_id IS NULL THEN
                upload_payments;    
            ELSE
                BEGIN
                   SELECT gfun_fund_cd
                     INTO variables_fund_cd
                     FROM giac_acctrans
                    WHERE tran_id = v_tran_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        variables_fund_cd := giacp.v('FUND_CD');
                END;
                
                variables_tran_id := v_tran_id;
                variables_tran_date := v_tran_date;
                upload_dpc_web.check_tran_mm (variables_tran_date);
                upload_dpc_web.set_fixed_variables(variables_fund_cd, v_branch_cd, null);
                process_payments(null);

                DELETE FROM giac_upload_dv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;

                DELETE FROM giac_upload_colln_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;

                UPDATE giac_upload_inwfacul_prem
                   SET tran_id = variables_tran_id,
                       tran_date = variables_tran_date
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
                   
                UPDATE giac_upload_file
                   SET upload_date = SYSDATE,
                       file_status = 2,
                       tran_class = 'JV',
                       tran_id = variables_tran_id,
                       tran_date = TRUNC (variables_tran_date)
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
            
            END IF;
        ELSIF variables_tran_class = 'DV' THEN   
            BEGIN
                SELECT tran_id, request_date, branch_cd
                  INTO v_tran_id, v_request_date, v_branch_cd
                  FROM giac_upload_dv_payt_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_tran_id := NULL;
            END;
            
            IF v_tran_id IS NULL THEN 
                upload_payments;    
            ELSE  
                BEGIN
                   SELECT gfun_fund_cd
                     INTO variables_fund_cd
                     FROM giac_acctrans
                    WHERE tran_id = v_tran_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        variables_fund_cd := giacp.v('FUND_CD');
                END;
                
                variables_tran_id := v_tran_id;
                variables_tran_date := v_request_date;
                upload_dpc_web.check_tran_mm (variables_tran_date);
                upload_dpc_web.set_fixed_variables(variables_fund_cd,v_branch_cd,null);
                process_payments(null);

                DELETE FROM giac_upload_jv_payt_dtl
                 WHERE source_cd = p_source_cd 
                       AND file_no = p_file_no;
                        
                DELETE FROM giac_upload_colln_dtl
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no;     
                  
                UPDATE giac_upload_inwfacul_prem
                   SET tran_id = variables_tran_id,
                       tran_date = variables_tran_date
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no; 
             
                UPDATE giac_upload_file
                   SET upload_date = SYSDATE,
                       file_status = 2,
                       tran_id = variables_tran_id,
                       tran_class = 'DV',
                       tran_date = TRUNC (variables_tran_date)
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no; 
                
            END IF;
        END IF;
   END;
   
   --nieko Accounting Uploading GIACS608
    PROCEDURE validate_print_or (
        p_source_cd           VARCHAR2,
        p_file_no             VARCHAR2,
        p_branch_cd     OUT   VARCHAR2,
        p_fund_cd       OUT   VARCHAR2,
        p_branch_name   OUT   VARCHAR2,
        p_fund_desc     OUT   VARCHAR2,
        p_tran_id       OUT   NUMBER,
        p_upload_query  OUT   VARCHAR2
    )
    IS
    BEGIN
        BEGIN
           SELECT c.gibr_branch_cd, c.gibr_gfun_fund_cd, c.gacc_tran_id
             INTO p_branch_cd, p_fund_cd, p_tran_id
             FROM giac_order_of_payts c, giac_upload_inwfacul_prem b, giac_upload_file a
            WHERE 1 = 1
              AND b.tran_id = c.gacc_tran_id
              AND a.source_cd = b.source_cd
              AND a.file_no = b.file_no
              AND a.source_cd = p_source_cd
              AND a.file_no = p_file_no
              AND ROWNUM = 1;
              
            BEGIN
                SELECT branch_name
                  INTO p_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = p_fund_cd 
                   AND branch_cd = p_branch_cd;
                
                SELECT fund_desc
                  INTO p_fund_desc
                  FROM giis_funds
                 WHERE fund_cd = p_fund_cd;
            END;
            
            p_upload_query :=
                'SELECT c.gacc_tran_id '
             || 'FROM giac_order_of_payts c, giac_upload_inwfacul_prem b, giac_upload_file a '
             || 'WHERE 1 = 1 '
             || 'AND b.tran_id = c.gacc_tran_id '
             || 'AND a.source_cd = b.source_cd '
             || 'AND a.file_no = b.file_no '
             || 'AND a.source_cd = '''
             || p_source_cd
             || ''''
             || 'AND a.file_no = '
             || p_file_no;   
                 
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#O.R. does not exist in table: GIAC_ORDER_OF_PAYTS.');  	
        END;
        
    END;
    
    FUNCTION get_guf_details(
        p_source_cd         giac_upload_file.SOURCE_CD%TYPE,
        p_file_no           giac_upload_file.FILE_NO%TYPE
    ) RETURN guf_tab2 PIPELINED
    AS
        rec         guf_type2;
    BEGIN
        FOR i IN (SELECT *
                    FROM giac_upload_file
                   WHERE transaction_type = 3
                     AND source_cd = p_source_cd
                     AND file_no = p_file_no)
        LOOP
            rec.source_cd           := i.SOURCE_CD;
            rec.file_no             := i.FILE_NO;
            rec.file_name           := i.FILE_NAME;
            rec.tran_date           := i.TRAN_DATE;
            rec.tran_id             := i.TRAN_ID;
            rec.file_status         := i.FILE_STATUS;
            rec.tran_class          := i.TRAN_CLASS;
            rec.convert_date        := i.CONVERT_DATE;
            rec.upload_date         := i.UPLOAD_DATE;
            rec.gross_tag           := i.GROSS_TAG;
            rec.cancel_date         := i.CANCEL_DATE; 
        
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
    
    PROCEDURE gen_individual_or
    IS
       v_count                NUMBER                                       := 0;
       v_tran_year            giac_acctrans.tran_year%TYPE;
       v_tran_month           giac_acctrans.tran_month%TYPE;
       v_tran_seq_no          giac_acctrans.tran_seq_no%TYPE;
       v_tin                  giis_reinsurer.ri_tin%TYPE;
       v_add1                 giis_reinsurer.mail_address1%TYPE;
       v_add2                 giis_reinsurer.mail_address2%TYPE;
       v_add3                 giis_reinsurer.mail_address3%TYPE;
       v_cashier              giac_dcb_users.cashier_cd%TYPE;
       v_particulars          giac_order_of_payts.particulars%TYPE;
       v_fcurrency            giac_collection_dtl.fcurrency_amt%TYPE;
       v_ri_cd                NUMBER;
       v_dsp_collection_amt   NUMBER;
       v_currency_cd          giac_upload_inwfacul_prem.currency_cd%TYPE;
       v_exist                VARCHAR2 (1)                                 := 'N';
    
       v_list_gucd            gucd_tab2;
       v_gucd_cnt             NUMBER                                      := 1;
       v_gucd_cnt2            NUMBER;
       v_gucd_itm_no          NUMBER                                      := 1;
       v_remain_colln_amt     NUMBER;
      
       --collection dtl
       v_item_no                 giac_upload_colln_dtl.item_no%TYPE;
       v_curr_cd                 giac_collection_dtl.currency_cd%TYPE;
       v_curr_rt                 giac_collection_dtl.currency_rt%TYPE;
       v_pay_mode                giac_collection_dtl.pay_mode%TYPE;
       v_amount                  giac_collection_dtl.amount%TYPE;
       v_gross_amt               giac_collection_dtl.gross_amt%TYPE;
       v_comm_amt                giac_collection_dtl.commission_amt%TYPE;
       v_fc_gross_amt            giac_collection_dtl.fc_gross_amt%TYPE;
       v_vat_amt                 giac_collection_dtl.vat_amt%TYPE;
       v_check_class             giac_collection_dtl.check_class%TYPE;
       v_check_date              giac_collection_dtl.check_date%TYPE;
       v_check_no                giac_collection_dtl.check_no%TYPE;
       v_colln_part              giac_collection_dtl.particulars%TYPE;
       v_bank_cd                 giac_collection_dtl.bank_cd%TYPE;
       v_dcb_bank_cd             giac_collection_dtl.DCB_BANK_CD%type;
       v_dcb_bank_acct_cd        giac_collection_dtl.DCB_BANK_ACCT_CD%type;
    
    BEGIN
       BEGIN
             SELECT 'Y'
               INTO v_exist
               FROM giac_upload_colln_dtl
              WHERE source_cd = variables_source_cd
                    AND file_no = variables_file_no;
       EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := 'N';
            WHEN TOO_MANY_ROWS
            THEN
               v_exist := 'Y';
       END;

      IF NVL (v_exist, 'N') = 'N'
      THEN
       raise_application_error
          (-20001,
           'Geniisys Exception#E#Please provide Collection Payment details.'
          );
      END IF;
          
      SELECT *
          BULK COLLECT INTO v_list_gucd
          FROM TABLE (giacs608_pkg.get_giacs608_gucd2 (variables_source_cd, variables_file_no));
    
       FOR rec IN (SELECT *
                     FROM giac_upload_inwfacul_prem
                    WHERE source_cd = variables_source_cd
                      AND file_no = variables_file_no)
       LOOP
          SELECT acctran_tran_id_s.NEXTVAL
            INTO variables_tran_id
            FROM SYS.DUAL;

          BEGIN
             SELECT cashier_cd
               INTO v_cashier
               FROM giac_dcb_users
              WHERE dcb_user_id = variables_user_id
                AND gibr_fund_cd = variables_fund_cd
                AND gibr_branch_cd = variables_branch_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                NULL;
          END;

          v_ri_cd := rec.ri_cd;

          BEGIN
             SELECT ri_tin, mail_address1, mail_address2, mail_address3
               INTO v_tin, v_add1, v_add2, v_add3
               FROM giis_reinsurer
              WHERE ri_cd = v_ri_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                NULL;
          END;

          BEGIN
             FOR ri IN (SELECT ri_name
                          FROM giis_reinsurer
                         WHERE ri_cd = v_ri_cd)
             LOOP
                variables_reinsurer := ri.ri_name;
             END LOOP;
          END;

          v_particulars :=
                 'Representing payment of premium and taxes for various policies.';
          /*variables_tran_date :=
             TO_DATE (   TO_CHAR (SYSDATE, 'MM-DD-YYYY')
                      || ' '
                      || TO_CHAR (SYSDATE, 'HH:MI:SS AM'),
                      'MM-DD-YYYY HH:MI:SS AM'
                     );*/
          v_tran_month := TO_NUMBER (TO_CHAR (variables_tran_date, 'MM'));
          v_tran_year := TO_NUMBER (TO_CHAR (variables_tran_date, 'YYYY'));
          v_tran_seq_no :=
             giac_sequence_generation (variables_fund_cd,
                                       variables_branch_cd,
                                       'ACCTRAN_TRAN_SEQ_NO',
                                       v_tran_year,
                                       v_tran_month
                                      );
                                      
          v_dsp_collection_amt :=   rec.lcollection_amt; 
          v_currency_cd        :=   rec.currency_cd;                        

          INSERT INTO giac_acctrans
                      (tran_id, gfun_fund_cd, gibr_branch_cd,
                       tran_date, tran_flag, tran_class, tran_class_no,
                       particulars, tran_year, tran_month, tran_seq_no,
                       user_id, last_update
                      )
               VALUES (variables_tran_id, variables_fund_cd, variables_branch_cd,
                       variables_tran_date, 'O', 'COL', variables_dcb_no,
                       NULL, v_tran_year, v_tran_month, v_tran_seq_no,
                       variables_user_id, SYSDATE
                      );

          INSERT INTO giac_order_of_payts
                      (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                       payor, collection_amt, cashier_cd,
                       address_1, address_2, address_3, particulars, or_flag,
                       dcb_no, gross_amt, currency_cd,
                       gross_tag, user_id, last_update, tin, upload_tag,
                       or_date
                      )
               VALUES (variables_tran_id, variables_fund_cd, variables_branch_cd,
                       variables_reinsurer, v_dsp_collection_amt, v_cashier,
                       v_add1, v_add2, v_add3, v_particulars, 'N',
                       variables_dcb_no, v_dsp_collection_amt, v_currency_cd,
                       'Y', variables_user_id, SYSDATE, v_tin, 'Y',
                       variables_tran_date
                      );
          
            --GIAC_COLLECTION_DTL spread
            v_remain_colln_amt := v_dsp_collection_amt;
            v_gucd_itm_no      := 1;
                             
            WHILE v_remain_colln_amt > 0
            LOOP
                 IF v_list_gucd(v_gucd_cnt).current_amt = v_remain_colln_amt THEN
                                        
                    v_gucd_cnt2 := v_gucd_cnt;
                    v_fcurrency := ROUND (v_remain_colln_amt / v_list_gucd(v_gucd_cnt).currency_rt, 2);                
                                        
                    v_amount               :=   v_remain_colln_amt;
                    v_gross_amt            :=   v_remain_colln_amt;
                    v_comm_amt             :=   v_list_gucd(v_gucd_cnt).commission_amt;                
                    v_fc_gross_amt         :=   v_list_gucd(v_gucd_cnt).fc_gross_amt;
                    v_vat_amt              :=   v_list_gucd(v_gucd_cnt).vat_amt;
                                       
                    v_list_gucd(v_gucd_cnt).current_amt := 0;
                    v_gucd_cnt := v_gucd_cnt + 1;
                    v_remain_colln_amt := 0;
                                     
                 ELSIF v_list_gucd(v_gucd_cnt).current_amt > v_remain_colln_amt THEN
                                     
                    v_gucd_cnt2 := v_gucd_cnt;
                    v_fcurrency := ROUND (v_remain_colln_amt / v_list_gucd(v_gucd_cnt).currency_rt, 2);                
                                   
                    v_amount               :=   v_remain_colln_amt;
                    v_gross_amt            :=   v_remain_colln_amt;
                    v_comm_amt             :=   v_list_gucd(v_gucd_cnt).commission_amt;                
                    v_fc_gross_amt         :=   v_list_gucd(v_gucd_cnt).fc_gross_amt;
                    v_vat_amt              :=   v_list_gucd(v_gucd_cnt).vat_amt;
                                       
                    v_list_gucd(v_gucd_cnt).current_amt := v_list_gucd(v_gucd_cnt).current_amt - v_remain_colln_amt;
                    v_remain_colln_amt := 0;   
                                     
                 ELSIF v_list_gucd(v_gucd_cnt).current_amt < v_remain_colln_amt THEN
                                     
                    v_gucd_cnt2 := v_gucd_cnt;
                    v_fcurrency := ROUND (v_list_gucd(v_gucd_cnt).current_amt / v_list_gucd(v_gucd_cnt).currency_rt, 2);                
                                        
                    v_amount               :=   v_list_gucd(v_gucd_cnt).current_amt;
                    v_gross_amt            :=   v_list_gucd(v_gucd_cnt).current_amt;
                    v_comm_amt             :=   v_list_gucd(v_gucd_cnt).commission_amt;                
                    v_fc_gross_amt         :=   v_list_gucd(v_gucd_cnt).fc_gross_amt;
                    v_vat_amt              :=   v_list_gucd(v_gucd_cnt).vat_amt;
                                         
                    v_remain_colln_amt := v_remain_colln_amt - v_list_gucd(v_gucd_cnt).current_amt;    
                    v_list_gucd(v_gucd_cnt).current_amt := 0;
                    v_gucd_cnt := v_gucd_cnt + 1;
                                     
                 END IF;
                                 
                 v_item_no              :=   v_gucd_itm_no;
                 v_curr_cd              :=   v_list_gucd(v_gucd_cnt2).currency_cd;
                 v_curr_rt              :=   v_list_gucd(v_gucd_cnt2).currency_rt;
                 v_pay_mode             :=   v_list_gucd(v_gucd_cnt2).pay_mode;
                 v_check_class          :=   v_list_gucd(v_gucd_cnt2).check_class;
                 v_check_date           :=   v_list_gucd(v_gucd_cnt2).check_date;
                 v_check_no             :=   v_list_gucd(v_gucd_cnt2).check_no;
                 v_colln_part           :=   v_list_gucd(v_gucd_cnt2).particulars;
                 v_bank_cd              :=   v_list_gucd(v_gucd_cnt2).bank_cd;
                 v_dcb_bank_cd          :=   v_list_gucd(v_gucd_cnt2).dcb_bank_cd;
                 v_dcb_bank_acct_cd     :=   v_list_gucd(v_gucd_cnt2).dcb_bank_acct_cd;
                                     
                 INSERT INTO giac_collection_dtl
                             (gacc_tran_id, item_no, currency_cd,
                              currency_rt, pay_mode, amount,
                              check_date, check_no, particulars,
                              bank_cd, check_class, fcurrency_amt,
                              gross_amt, commission_amt, vat_amt,
                              fc_gross_amt, user_id, last_update,
                              due_dcb_no, due_dcb_date,
                              dcb_bank_cd, dcb_bank_acct_cd
                             )
                      VALUES (variables_tran_id, v_item_no, v_curr_cd,
                              v_curr_rt, v_pay_mode, v_amount,
                              v_check_date, v_check_no, v_colln_part,
                              v_bank_cd, v_check_class, v_fcurrency,
                              v_gross_amt, v_comm_amt, v_vat_amt,
                              v_fc_gross_amt, variables_user_id, SYSDATE,
                              variables_dcb_no, TRUNC (variables_tran_date),
                              v_dcb_bank_cd, v_dcb_bank_acct_cd
                             );
                                     
                 v_gucd_itm_no := v_gucd_itm_no + 1;
            END LOOP;
            --GIAC_COLLECTION_DTL end


          upload_dpc_web.aeg_parameters (variables_tran_id,
                                         variables_branch_cd,
                                         variables_fund_cd,
                                         'GIACS001',
                                         variables_user_id
                                        );
          process_payments2 (rec.line_cd,
                             rec.subline_cd,
                             rec.iss_cd,
                             rec.issue_yy,
                             rec.pol_seq_no,
                             rec.renew_no,
                             null,
                             'I'
                            );

          --after upload
          UPDATE giac_upload_inwfacul_prem
             SET tran_id = variables_tran_id,
                 tran_date = variables_tran_date
           WHERE source_cd = variables_source_cd 
             AND file_no = variables_file_no
             AND line_cd = rec.line_cd
             AND subline_cd = rec.subline_cd
             AND iss_cd = rec.iss_cd
             and issue_yy = rec.issue_yy
             and pol_seq_no = rec.pol_seq_no
             and renew_no = rec.renew_no;

          DELETE FROM giac_upload_dv_payt_dtl
                WHERE source_cd = variables_source_cd
                  AND file_no = variables_file_no;

          DELETE FROM giac_upload_jv_payt_dtl
                WHERE source_cd = variables_source_cd
                  AND file_no = variables_file_no;

          UPDATE giac_upload_file
             SET upload_date = SYSDATE,
                 file_status = 2,
                 tran_class = 'COL',
--                 tran_id = variables_tran_id,
                 tran_date = TRUNC (variables_tran_date)
           WHERE source_cd = variables_source_cd AND file_no = variables_file_no;
       END LOOP;
    END gen_individual_or;
    
    PROCEDURE gen_group_or
    IS
       v_count                NUMBER                                       := 0;
       v_tran_year            giac_acctrans.tran_year%TYPE;
       v_tran_month           giac_acctrans.tran_month%TYPE;
       v_tran_seq_no          giac_acctrans.tran_seq_no%TYPE;
       v_tin                  giis_reinsurer.ri_tin%TYPE;
       v_add1                 giis_reinsurer.mail_address1%TYPE;
       v_add2                 giis_reinsurer.mail_address2%TYPE;
       v_add3                 giis_reinsurer.mail_address3%TYPE;
       v_cashier              giac_dcb_users.cashier_cd%TYPE;
       v_particulars          giac_order_of_payts.particulars%TYPE;
       v_fcurrency            giac_collection_dtl.fcurrency_amt%TYPE;
       v_ri_cd                NUMBER;
       v_dsp_collection_amt   NUMBER;
       v_currency_cd          giac_upload_inwfacul_prem.currency_cd%TYPE;
       v_exist                VARCHAR2 (1)                                 := 'N';
       v_list                 guf_tab2;
       
       v_list_gucd            gucd_tab2;
       v_gucd_cnt             NUMBER                                      := 1;
       v_gucd_cnt2            NUMBER;
       v_gucd_itm_no          NUMBER                                      := 1;
       v_remain_colln_amt     NUMBER;
      
       --collection dtl
       v_item_no                 giac_upload_colln_dtl.item_no%TYPE;
       v_curr_cd                 giac_collection_dtl.currency_cd%TYPE;
       v_curr_rt                 giac_collection_dtl.currency_rt%TYPE;
       v_pay_mode                giac_collection_dtl.pay_mode%TYPE;
       v_amount                  giac_collection_dtl.amount%TYPE;
       v_gross_amt               giac_collection_dtl.gross_amt%TYPE;
       v_comm_amt                giac_collection_dtl.commission_amt%TYPE;
       v_fc_gross_amt            giac_collection_dtl.fc_gross_amt%TYPE;
       v_vat_amt                 giac_collection_dtl.vat_amt%TYPE;
       v_check_class             giac_collection_dtl.check_class%TYPE;
       v_check_date              giac_collection_dtl.check_date%TYPE;
       v_check_no                giac_collection_dtl.check_no%TYPE;
       v_colln_part              giac_collection_dtl.particulars%TYPE;
       v_bank_cd                 giac_collection_dtl.bank_cd%TYPE;
       v_dcb_bank_cd             giac_collection_dtl.DCB_BANK_CD%type;
       v_dcb_bank_acct_cd        giac_collection_dtl.DCB_BANK_ACCT_CD%type;
    
    BEGIN
       BEGIN
          SELECT cashier_cd
            INTO v_cashier
            FROM giac_dcb_users
           WHERE dcb_user_id = variables_user_id
             AND gibr_fund_cd = variables_fund_cd
             AND gibr_branch_cd = variables_branch_cd;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             NULL;
       END;
       
       BEGIN
           SELECT 'Y'
             INTO v_exist
             FROM giac_upload_colln_dtl
            WHERE source_cd = variables_source_cd 
              AND file_no = variables_file_no; 
       EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_exist := 'N';
           WHEN TOO_MANY_ROWS THEN
              v_exist := 'Y';     
       END;
                    
       IF nvl(v_exist, 'N') = 'N' THEN
          raise_application_error (-20001, 'Geniisys Exception#E#Please provide Collection Payment details.');
       END IF;
       
       SELECT *
          BULK COLLECT INTO v_list_gucd
          FROM TABLE (giacs608_pkg.get_giacs608_gucd2 (variables_source_cd, variables_file_no));
       
       SELECT *
       BULK COLLECT INTO v_list
         FROM TABLE (giacs608_pkg.get_guf_details (variables_source_cd,
                                                   variables_file_no
                                                  )
                    );

       FOR guf IN 1 .. v_list.COUNT
       LOOP
          v_particulars :=
                'Representing payment of premium and taxes for various policies.';
          /*variables_tran_date :=
             TO_DATE (   TO_CHAR (SYSDATE, 'MM-DD-YYYY')
                      || ' '
                      || TO_CHAR (SYSDATE, 'HH:MI:SS AM'),
                      'MM-DD-YYYY HH:MI:SS AM'
                     );*/
          v_tran_month := TO_NUMBER (TO_CHAR (variables_tran_date, 'MM'));
          v_tran_year := TO_NUMBER (TO_CHAR (variables_tran_date, 'YYYY'));
          DBMS_SESSION.set_identifier (   v_list (guf).source_cd
                                       || '-'
                                       || v_list (guf).file_no
                                      );

          FOR ri_cd_rec IN (SELECT ri_cd, lcollection_amt, currency_cd,
                                   convert_rate
                              FROM giac_upload_inwfacul_prem_v)
          LOOP
             SELECT acctran_tran_id_s.NEXTVAL
               INTO variables_tran_id
               FROM SYS.DUAL;

             v_tran_seq_no :=
                giac_sequence_generation (variables_fund_cd,
                                          variables_branch_cd,
                                          'ACCTRAN_TRAN_SEQ_NO',
                                          v_tran_year,
                                          v_tran_month
                                         );

             BEGIN
                SELECT ri_tin, mail_address1, mail_address2, mail_address3
                  INTO v_tin, v_add1, v_add2, v_add3
                  FROM giis_reinsurer
                 WHERE ri_cd = ri_cd_rec.ri_cd;
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   NULL;
             END;

             BEGIN
                FOR ri IN (SELECT ri_name
                             FROM giis_reinsurer
                            WHERE ri_cd = ri_cd_rec.ri_cd)
                LOOP
                   variables_reinsurer := ri.ri_name;
                END LOOP;
             END;

             v_dsp_collection_amt := ri_cd_rec.lcollection_amt;
             v_currency_cd := ri_cd_rec.currency_cd;
             
             INSERT INTO giac_acctrans
                         (tran_id, gfun_fund_cd,
                          gibr_branch_cd, tran_date, tran_flag, tran_class,
                          tran_class_no, particulars, tran_year, tran_month,
                          tran_seq_no, user_id, last_update
                         )
                  VALUES (variables_tran_id, variables_fund_cd,
                          variables_branch_cd, variables_tran_date, 'O', 'COL',
                          variables_dcb_no, NULL, v_tran_year, v_tran_month,
                          v_tran_seq_no, variables_user_id, SYSDATE
                         );

             INSERT INTO giac_order_of_payts
                         (gacc_tran_id, gibr_gfun_fund_cd,
                          gibr_branch_cd, payor,
                          collection_amt, cashier_cd, address_1, address_2,
                          address_3, particulars, or_flag, dcb_no,
                          gross_amt, currency_cd, gross_tag,
                          user_id, last_update, tin, upload_tag,
                          or_date
                         )
                  VALUES (variables_tran_id, variables_fund_cd,
                          variables_branch_cd, variables_reinsurer,
                          v_dsp_collection_amt, v_cashier, v_add1, v_add2,
                          v_add3, v_particulars, 'N', variables_dcb_no,
                          v_dsp_collection_amt, v_currency_cd, 'Y',
                          variables_user_id, SYSDATE, v_tin, 'Y',
                          variables_tran_date
                         );
             
             --GIAC_COLLECTION_DTL spread
             v_remain_colln_amt := v_dsp_collection_amt;
             v_gucd_itm_no      := 1;
                                                                                 
             WHILE v_remain_colln_amt > 0
             LOOP
                 IF v_list_gucd(v_gucd_cnt).current_amt = v_remain_colln_amt THEN
                                                                                            
                    v_gucd_cnt2 := v_gucd_cnt;
                    v_fcurrency := ROUND (v_remain_colln_amt / v_list_gucd(v_gucd_cnt).currency_rt, 2);                
                                                                                            
                    v_amount               :=   v_remain_colln_amt;
                    v_gross_amt            :=   v_remain_colln_amt;
                    v_comm_amt             :=   v_list_gucd(v_gucd_cnt).commission_amt;                
                    v_fc_gross_amt         :=   v_list_gucd(v_gucd_cnt).fc_gross_amt;
                    v_vat_amt              :=   v_list_gucd(v_gucd_cnt).vat_amt;
                                                                                           
                    v_list_gucd(v_gucd_cnt).current_amt := 0;
                    v_gucd_cnt := v_gucd_cnt + 1;
                    v_remain_colln_amt := 0;
                                                                                         
                 ELSIF v_list_gucd(v_gucd_cnt).current_amt > v_remain_colln_amt THEN
                                                                                         
                    v_gucd_cnt2 := v_gucd_cnt;
                    v_fcurrency := ROUND (v_remain_colln_amt / v_list_gucd(v_gucd_cnt).currency_rt, 2);                
                                                                                       
                    v_amount               :=   v_remain_colln_amt;
                    v_gross_amt            :=   v_remain_colln_amt;
                    v_comm_amt             :=   v_list_gucd(v_gucd_cnt).commission_amt;                
                    v_fc_gross_amt         :=   v_list_gucd(v_gucd_cnt).fc_gross_amt;
                    v_vat_amt              :=   v_list_gucd(v_gucd_cnt).vat_amt;
                                                                                           
                    v_list_gucd(v_gucd_cnt).current_amt := v_list_gucd(v_gucd_cnt).current_amt - v_remain_colln_amt;
                    v_remain_colln_amt := 0;   
                                                                                         
                 ELSIF v_list_gucd(v_gucd_cnt).current_amt < v_remain_colln_amt THEN
                                                                                         
                    v_gucd_cnt2 := v_gucd_cnt;
                    v_fcurrency := ROUND (v_list_gucd(v_gucd_cnt).current_amt / v_list_gucd(v_gucd_cnt).currency_rt, 2);                
                                                                                            
                    v_amount               :=   v_list_gucd(v_gucd_cnt).current_amt;
                    v_gross_amt            :=   v_list_gucd(v_gucd_cnt).current_amt;
                    v_comm_amt             :=   v_list_gucd(v_gucd_cnt).commission_amt;                
                    v_fc_gross_amt         :=   v_list_gucd(v_gucd_cnt).fc_gross_amt;
                    v_vat_amt              :=   v_list_gucd(v_gucd_cnt).vat_amt;
                                                                                             
                    v_remain_colln_amt := v_remain_colln_amt - v_list_gucd(v_gucd_cnt).current_amt;    
                    v_list_gucd(v_gucd_cnt).current_amt := 0;
                    v_gucd_cnt := v_gucd_cnt + 1;
                                                                                         
                 END IF;
                                                                                     
                 v_item_no              :=   v_gucd_itm_no;
                 v_curr_cd              :=   v_list_gucd(v_gucd_cnt2).currency_cd;
                 v_curr_rt              :=   v_list_gucd(v_gucd_cnt2).currency_rt;
                 v_pay_mode             :=   v_list_gucd(v_gucd_cnt2).pay_mode;
                 v_check_class          :=   v_list_gucd(v_gucd_cnt2).check_class;
                 v_check_date           :=   v_list_gucd(v_gucd_cnt2).check_date;
                 v_check_no             :=   v_list_gucd(v_gucd_cnt2).check_no;
                 v_colln_part           :=   v_list_gucd(v_gucd_cnt2).particulars;
                 v_bank_cd              :=   v_list_gucd(v_gucd_cnt2).bank_cd;
                 v_dcb_bank_cd          :=   v_list_gucd(v_gucd_cnt2).dcb_bank_cd;
                 v_dcb_bank_acct_cd     :=   v_list_gucd(v_gucd_cnt2).dcb_bank_acct_cd;
                                                                                         
                 INSERT INTO giac_collection_dtl
                             (gacc_tran_id, item_no, currency_cd,
                              currency_rt, pay_mode, amount,
                              check_date, check_no, particulars,
                              bank_cd, check_class, fcurrency_amt,
                              gross_amt, commission_amt, vat_amt,
                              fc_gross_amt, user_id, last_update,
                              due_dcb_no, due_dcb_date,
                              dcb_bank_cd, dcb_bank_acct_cd
                             )
                      VALUES (variables_tran_id, v_item_no, v_curr_cd,
                              v_curr_rt, v_pay_mode, v_amount,
                              v_check_date, v_check_no, v_colln_part,
                              v_bank_cd, v_check_class, v_fcurrency,
                              v_gross_amt, v_comm_amt, v_vat_amt,
                              v_fc_gross_amt, variables_user_id, SYSDATE,
                              variables_dcb_no, TRUNC (variables_tran_date),
                              v_dcb_bank_cd, v_dcb_bank_acct_cd
                             );
                                                                                         
                 v_gucd_itm_no := v_gucd_itm_no + 1;
             END LOOP;
             --GIAC_COLLECTION_DTL end
             
             upload_dpc_web.aeg_parameters (variables_tran_id,
                                            variables_branch_cd,
                                            variables_fund_cd,
                                            'GIACS001',
                                            variables_user_id
                                           );
             process_payments2 (NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                ri_cd_rec.ri_cd,
                                'G'
                               );

             --after upload
             UPDATE giac_upload_inwfacul_prem
                SET tran_id = variables_tran_id,
                    tran_date = variables_tran_date
              WHERE source_cd = variables_source_cd
                AND file_no = variables_file_no
                AND ri_cd = ri_cd_rec.ri_cd;
          END LOOP;

          DELETE FROM giac_upload_dv_payt_dtl
                WHERE source_cd = variables_source_cd
                  AND file_no = variables_file_no;

          DELETE FROM giac_upload_jv_payt_dtl
                WHERE source_cd = variables_source_cd
                  AND file_no = variables_file_no;

          UPDATE giac_upload_file
             SET upload_date = SYSDATE,
                 file_status = 2,
                 tran_class = 'COL',
                 --                 tran_id = variables_tran_id,
                 tran_date = TRUNC (variables_tran_date)
           WHERE source_cd = variables_source_cd AND file_no = variables_file_no;
       END LOOP;
    END gen_group_or;
    
    PROCEDURE process_payments2 (
       p_line_cd      giac_upload_inwfacul_prem.line_cd%TYPE,
       p_subline_cd   giac_upload_inwfacul_prem.subline_cd%TYPE,
       p_iss_cd       giac_upload_inwfacul_prem.iss_cd%TYPE,
       p_issue_yy     giac_upload_inwfacul_prem.issue_yy%TYPE,
       p_pol_seq_no   giac_upload_inwfacul_prem.pol_seq_no%TYPE,
       p_renew_no     giac_upload_inwfacul_prem.renew_no%TYPE,
       p_ri_cd        giac_upload_inwfacul_prem.ri_cd%TYPE,
       p_nbt_or_tag   giac_file_source.or_tag%TYPE
    )
    IS
       v_line_cd               giac_upload_inwfacul_prem.line_cd%TYPE;
       v_subline_cd            giac_upload_inwfacul_prem.subline_cd%TYPE;
       v_iss_cd                giac_upload_inwfacul_prem.iss_cd%TYPE;
       v_issue_yy              giac_upload_inwfacul_prem.issue_yy%TYPE;
       v_pol_seq_no            giac_upload_inwfacul_prem.pol_seq_no%TYPE;
       v_renew_no              giac_upload_inwfacul_prem.renew_no%TYPE;
       v_ri_cd                 giac_upload_inwfacul_prem.ri_cd%TYPE;
       v_prem_chk_flag         giac_upload_inwfacul_prem.prem_chk_flag%TYPE;
       v_collection_amt        giac_upload_inwfacul_prem.lcollection_amt%TYPE;
       v_prem_amt              giac_upload_inwfacul_prem.lprem_amt%TYPE;
       v_tax_amt               giac_upload_inwfacul_prem.ltax_amt%TYPE;
       v_comm_amt              giac_upload_inwfacul_prem.lcomm_amt%TYPE;
       v_comm_vat              giac_upload_inwfacul_prem.lcomm_vat%TYPE;
       v_prem_dep              giac_upload_inwfacul_prem.lcollection_amt%TYPE
                                                                             := 0;
       v_tot_amt_due           giac_upload_inwfacul_prem.tot_amt_due%TYPE;
       v_acct_payable_amt      giac_upload_inwfacul_prem.lcollection_amt%TYPE;
       v_other_income_amt      giac_upload_inwfacul_prem.lcollection_amt%TYPE
                                                                             := 0;
       v_acct_payable_min      NUMBER            := giacp.n ('ACCTS_PAYABLE_MIN');
       v_premcol_exp_max       NUMBER              := giacp.n ('PREMCOL_EXP_MAX');
       v_sl_cd                 giac_acct_entries.sl_cd%TYPE;
       v_aeg_item_no           giac_module_entries.item_no%TYPE;
       v_dummy_prem_chk_flag   giac_upload_inwfacul_prem.prem_chk_flag%TYPE;
       v_dummy_expense_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE;
       v_other_expense_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE
                                                                             := 0;
       v_prem_colln            giac_upload_inwfacul_prem.lcollection_amt%TYPE;
       v_pay_amt               giac_upload_inwfacul_prem.lcollection_amt%TYPE;
       v_other_exp_inc_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE
                                                                             := 0;
       v_other_exp_inc_tot     giac_upload_inwfacul_prem.lcollection_amt%TYPE
                                                                             := 0;
       v_assd_no               giis_assured.assd_no%TYPE;
       v_pay_rcv_assd_amt      giac_upload_inwfacul_prem.lcollection_amt%TYPE
                                                                             := 0;
       v_dummy_exp_inc_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE;
    BEGIN
       FOR i IN (SELECT *
                   FROM giac_upload_inwfacul_prem
                  WHERE source_cd = variables_source_cd
                    AND file_no = variables_file_no)
       LOOP
          v_ri_cd := i.ri_cd;
          v_line_cd := i.line_cd;
          v_subline_cd := i.subline_cd;
          v_iss_cd := i.iss_cd;
          v_issue_yy := i.issue_yy;
          v_pol_seq_no := i.pol_seq_no;
          v_renew_no := i.renew_no;

          IF    ((NVL (p_ri_cd, v_ri_cd) = v_ri_cd) AND (p_nbt_or_tag = 'G'))
             OR (    (    (NVL (p_line_cd, v_line_cd) = v_line_cd)
                      AND (NVL (p_subline_cd, v_subline_cd) = v_subline_cd)
                      AND (NVL (p_iss_cd, v_iss_cd) = v_iss_cd)
                      AND (NVL (p_issue_yy, v_issue_yy) = v_issue_yy)
                      AND (NVL (p_pol_seq_no, v_pol_seq_no) = v_pol_seq_no)
                      AND (NVL (p_renew_no, v_renew_no) = v_renew_no)
                     )
                 AND (p_nbt_or_tag = 'I')
                )
          THEN
             rg_id := assured_rg_tab ();
             v_prem_chk_flag := i.prem_chk_flag;
             v_collection_amt := i.lcollection_amt;
             v_prem_amt := i.lprem_amt;
             v_tax_amt := i.ltax_amt;
             v_comm_amt := i.lcomm_amt;
             v_comm_vat := i.lcomm_vat;
             v_tot_amt_due := i.tot_amt_due;

             FOR assd_rec IN (SELECT assd_no, par_id
                                FROM gipi_polbasic
                               WHERE 1 = 1
                                 AND line_cd = i.line_cd
                                 AND subline_cd = i.subline_cd
                                 AND iss_cd = i.iss_cd
                                 AND issue_yy = i.issue_yy
                                 AND pol_seq_no = i.pol_seq_no
                                 AND renew_no = i.renew_no
                                 AND endt_seq_no = 0)
             LOOP
                v_assd_no := assd_rec.assd_no;

                IF v_assd_no IS NULL
                THEN
                   FOR assd_rec2 IN (SELECT assd_no
                                       FROM gipi_parlist
                                      WHERE par_id = assd_rec.par_id)
                   LOOP
                      v_assd_no := assd_rec2.assd_no;
                   END LOOP;
                END IF;

                EXIT;
             END LOOP;

             get_sl_cd ('GIACS008');

             IF v_prem_chk_flag IN ('SP', 'NA', 'IP', 'DI')
             THEN
                v_prem_dep := NVL (v_prem_dep, 0) + v_collection_amt;
             ELSE
                IF     v_tot_amt_due < 0
                   AND v_collection_amt > 0
                   AND v_prem_chk_flag = 'OP'
                THEN
                   raise_application_error (-20001, 'Geniisys Exception#E#nn4');

                   IF v_collection_amt >= v_acct_payable_min
                   THEN
                      update_assured_rg (v_assd_no, v_collection_amt);
                   ELSE
                      v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                      v_aeg_item_no := 8;
                      v_other_income_amt :=
                                    NVL (v_other_income_amt, 0)
                                    + v_collection_amt;
                      upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                          'GIACS008',
                                                          v_aeg_item_no,
                                                          v_collection_amt,
                                                          v_sl_cd,
                                                          variables_user_id
                                                         );
                   END IF;
                ELSIF v_prem_chk_flag IN ('OK', 'PT', 'OP', 'ON')
                THEN
                   v_dummy_prem_chk_flag := v_prem_chk_flag;
                   v_dummy_expense_amt := 0;

                   IF     v_prem_chk_flag = 'PT'
                      AND (ABS (v_tot_amt_due - v_collection_amt) <=
                                                                 v_premcol_exp_max
                          )
                   THEN
                      v_dummy_prem_chk_flag := 'OK';
                      v_dummy_expense_amt := v_tot_amt_due - v_collection_amt;

                      IF v_collection_amt > 0
                      THEN
                         v_sl_cd :=
                            get_pol_assd_no (v_line_cd,
                                             v_subline_cd,
                                             v_iss_cd,
                                             v_issue_yy,
                                             v_pol_seq_no,
                                             v_renew_no
                                            );
                         v_aeg_item_no := 11;
                         v_other_expense_amt :=
                                 NVL (v_other_expense_amt, 0)
                                 + v_dummy_expense_amt;
                      ELSE
                         v_sl_cd :=
                            get_pol_assd_no (v_line_cd,
                                             v_subline_cd,
                                             v_iss_cd,
                                             v_issue_yy,
                                             v_pol_seq_no,
                                             v_renew_no
                                            );
                         v_aeg_item_no := 16;
                         v_other_income_amt :=
                            NVL (v_other_income_amt, 0)
                            + ABS (v_dummy_expense_amt);
                      END IF;

                      upload_dpc_web.aeg_parameters_misc
                                                        (variables_tran_id,
                                                         'GIACS008',
                                                         v_aeg_item_no,
                                                         ABS (v_dummy_expense_amt),
                                                         v_sl_cd,
                                                         variables_user_id
                                                        );
                   END IF;

                   insert_into_inwfacul_prem_coll (v_line_cd,
                                                   v_subline_cd,
                                                   v_iss_cd,
                                                   v_issue_yy,
                                                   v_pol_seq_no,
                                                   v_renew_no,
                                                     v_collection_amt
                                                   + v_dummy_expense_amt,
                                                   v_prem_chk_flag,
                                                   v_prem_amt,
                                                   v_tax_amt,
                                                   v_comm_amt,
                                                   v_comm_vat,
                                                   v_prem_colln
                                                  );

                   IF v_prem_chk_flag = 'OP'
                   THEN
                      IF v_prem_colln >= v_acct_payable_min
                      THEN
                         update_assured_rg (v_assd_no, v_prem_colln);
                      ELSE
                         v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                         v_aeg_item_no := 8;
                         v_other_income_amt :=
                                        NVL (v_other_income_amt, 0)
                                        + v_prem_colln;
                         upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                             'GIACS008',
                                                             v_aeg_item_no,
                                                             v_prem_colln,
                                                             v_sl_cd,
                                                             variables_user_id
                                                            );
                      END IF;
                   ELSIF v_prem_chk_flag = 'ON'
                   THEN
                      IF ABS (v_prem_colln) > v_premcol_exp_max
                      THEN
                         v_sl_cd :=
                            get_pol_assd_no (v_line_cd,
                                             v_subline_cd,
                                             v_iss_cd,
                                             v_issue_yy,
                                             v_pol_seq_no,
                                             v_renew_no
                                            );
                         v_aeg_item_no := 14;
                         v_other_expense_amt :=
                                  NVL (v_other_expense_amt, 0)
                                  + ABS (v_prem_colln);
                         update_assured_rg (v_assd_no, v_prem_colln);
                      ELSE
                         v_sl_cd :=
                            get_pol_assd_no (v_line_cd,
                                             v_subline_cd,
                                             v_iss_cd,
                                             v_issue_yy,
                                             v_pol_seq_no,
                                             v_renew_no
                                            );
                         v_aeg_item_no := 13;
                         v_other_income_amt :=
                                   NVL (v_other_income_amt, 0)
                                   + ABS (v_prem_colln);
                      END IF;

                      upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                          'GIACS008',
                                                          v_aeg_item_no,
                                                          ABS (v_prem_colln),
                                                          v_sl_cd,
                                                          variables_user_id
                                                         );
                   END IF;
                ELSIF v_prem_chk_flag IN ('FP', 'CP', 'SL', 'NP')
                THEN
                   update_assured_rg (v_assd_no, v_collection_amt);
                END IF;
             END IF;
          END IF;
       END LOOP;

       create_acct_assd_entries (v_pay_rcv_assd_amt);
       v_other_exp_inc_amt := v_other_income_amt - v_other_expense_amt;
       v_other_exp_inc_tot := v_other_income_amt - v_other_expense_amt;

       IF v_prem_dep <> 0
       THEN
          INSERT INTO giac_prem_deposit
                      (gacc_tran_id, item_no, transaction_type, collection_amt,
                       dep_flag, currency_cd, convert_rate,
                       foreign_curr_amt, upload_tag, colln_dt, or_print_tag,
                       or_tag, user_id, last_update
                      )
               VALUES (variables_tran_id, 1, 1, v_prem_dep,
                       1, variables_currency_cd, variables_convert_rate,
                       v_prem_dep, 'Y', TRUNC (variables_tran_date), 'N',
                       'N', variables_user_id, SYSDATE
                      );

          upload_dpc_web.aeg_parameters_pdep (variables_tran_id,
                                              'GIACS026',
                                              variables_user_id
                                             );
       END IF;

       upload_dpc_web.aeg_parameters_inwfacul (variables_tran_id,
                                               'GIACS008',
                                               variables_sl_type_cd1,
                                               variables_sl_type_cd2,
                                               variables_user_id
                                              );
       generate_op_text;

       IF v_prem_dep <> 0
       THEN
          generate_dep_op_text;
       END IF;

       IF variables_tran_class = 'OR'
       THEN
          IF v_pay_rcv_assd_amt > 0
          THEN
             generate_misc_op_text ('ACCOUNTS PAYABLE - REINSURER',
                                    v_pay_rcv_assd_amt
                                   );
          ELSIF v_pay_rcv_assd_amt < 0
          THEN
             generate_misc_op_text ('ACCOUNTS RECEIVABLE - REINSURER',
                                    v_pay_rcv_assd_amt
                                   );
          END IF;
       END IF;

       IF v_other_income_amt <> 0
       THEN
          generate_misc_op_text ('OTHER INCOME', v_other_income_amt);
       END IF;

       IF v_other_expense_amt <> 0
       THEN
          generate_misc_op_text ('OTHER EXPENSE', v_other_expense_amt * -1);
       END IF;
    END process_payments2;
    
    
    FUNCTION get_giacs608_gucd2 (p_source_cd VARCHAR2, p_file_no VARCHAR2)
       RETURN gucd_tab2 PIPELINED
    IS
       v_list   gucd_type2;
    BEGIN
       FOR i IN (SELECT *
                   FROM giac_upload_colln_dtl
                  WHERE source_cd = p_source_cd AND file_no = p_file_no)
       LOOP
          v_list.source_cd := i.source_cd;
          v_list.file_no := i.file_no;
          v_list.item_no := i.item_no;
          v_list.pay_mode := i.pay_mode;
          v_list.amount := i.amount;
          v_list.gross_amt := i.gross_amt;
          v_list.commission_amt := i.commission_amt;
          v_list.vat_amt := i.vat_amt;
          v_list.pay_mode := i.pay_mode;
          v_list.check_class := i.check_class;
          v_list.check_date := i.check_date;
          v_list.check_no := i.check_no;
          v_list.particulars := i.particulars;
          v_list.bank_cd := i.bank_cd;
          v_list.currency_cd := i.currency_cd;
          v_list.currency_rt := i.currency_rt;
          v_list.dcb_bank_cd := i.dcb_bank_cd;
          v_list.dcb_bank_acct_cd := i.dcb_bank_acct_cd;
          v_list.fc_comm_amt := i.fc_comm_amt;
          v_list.fc_vat_amt := i.fc_vat_amt;
          v_list.tran_id := i.tran_id;
          v_list.current_amt := i.amount;
          PIPE ROW (v_list);
       END LOOP;

       RETURN;
    END get_giacs608_gucd2;
    
    PROCEDURE check_dcb_no (
       p_branch_cd   VARCHAR2,
       p_user_id     VARCHAR2,
       p_or_date     VARCHAR2
    )
    IS
       v_date    DATE;
       v_exist   VARCHAR2 (1) := 'N';
    BEGIN
       v_date := TO_DATE (p_or_date, 'MM-DD-YYYY');
       upload_dpc_web.set_fixed_variables (giacp.v ('FUND_CD'),
                                           REGEXP_REPLACE (p_branch_cd, '\s'),
                                           giacp.n ('EVAT')
                                          );
       upload_dpc_web.check_dcb_user (v_date, p_user_id);
       upload_dpc_web.get_dcb_no2 (v_date, variables_dcb_no, v_exist);

       IF v_exist = 'N'
       THEN
          raise_application_error (-20001,
                                      '#'
                                   || 'There is no open DCB No. dated '
                                   || TO_CHAR (v_date, 'fmMonth DD, YYYY')
                                   || ' for this company/branch ('
                                   || variables_fund_cd
                                   || '/'
                                   || variables_branch_cd
                                   || ').'
                                  );
       END IF;
    END check_dcb_no;
    
    PROCEDURE check_net_colln (
       p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
       p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE
    )
    AS
       v_gross_amt    NUMBER;
       v_tot_amount   NUMBER;
    BEGIN
       SELECT NVL (SUM (lcollection_amt), 0)
         INTO v_tot_amount
         FROM giac_upload_inwfacul_prem
        WHERE source_cd = p_source_cd AND file_no = p_file_no;

       SELECT NVL (SUM (gross_amt), 0)
         INTO v_gross_amt
         FROM giac_upload_colln_dtl
        WHERE source_cd = p_source_cd AND file_no = p_file_no;

       IF v_gross_amt <> 0
       THEN
          IF v_gross_amt <> v_tot_amount
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#I#Total Local Currency Amount should be equal to the total Net Amount Due.'
                );
          END IF;
       END IF;
    END check_net_colln;
    --nieko end
END; 
/

