CREATE OR REPLACE PACKAGE BODY CPI.giacs610_pkg
AS
   FUNCTION populate_legend
        RETURN legend_rec_tab PIPELINED
    IS
        v_list  legend_rec_type;
    BEGIN
        FOR rec IN (
            SELECT rv_low_value || ' - ' || rv_meaning legend
              FROM cg_ref_codes
             WHERE rv_domain LIKE 'GIAC_UPLOAD_PREM_REFNO.PREM_CHK_FLAG'
        )
        LOOP
            v_list.legend := rec.legend;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
    END;
    
    FUNCTION get_giacs610_guf(
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
              FROM giac_upload_file guf
             WHERE transaction_type = 5
               AND EXISTS (
                           SELECT *
                             FROM giac_file_source gfs
                            WHERE gfs.source_cd = guf.source_cd
                                  AND NVL (atm_tag, 'N') = 'N')
                                  
               AND source_cd = p_source_cd
               AND file_no = p_file_no
        )
        LOOP
            v_list.file_no          :=   i.file_no;         
            v_list.complete_sw      :=   i.complete_sw;    
            v_list.file_name        :=   i.file_name;      
            v_list.source_cd        :=   i.source_cd;      
            v_list.payment_date     :=   i.payment_date;  
            v_list.tran_date        :=   i.tran_date;    
            v_list.dsp_jv_no        :=   get_ref_no(i.tran_id);     
            v_list.tran_id          :=   i.tran_id;     
            v_list.file_status      :=   i.file_status;   
            v_list.no_of_records    :=   i.no_of_records;  
            v_list.transaction_type :=   i.transaction_type;
            v_list.tran_class       :=   i.tran_class; 
            v_list.dsp_tran_class   :=   nvl(i.tran_class, 'COL');     
            v_list.convert_date     :=   i.convert_date;  
            v_list.nbt_or_date      :=   nvl(i.tran_date, SYSDATE);   
            v_list.upload_date      :=   i.upload_date;    
            v_list.cancel_date      :=   i.cancel_date;  
            v_list.remarks          :=   i.remarks; --Deo [10.06.2016]
            
            FOR rec IN (
                SELECT source_name
                  FROM giac_file_source
                 WHERE source_cd = p_source_cd 
            )
            LOOP
                v_list.dsp_source_name  := rec.source_name;
            END LOOP;    
        
            PIPE ROW(v_list);    
        END LOOP;
        
        RETURN;
    END;
    
    FUNCTION get_giacs610_gupr(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
    )
        RETURN gupr_tab PIPELINED
    IS
        v_list      gupr_type;
    BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_prem_refno
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            v_list.source_cd      :=  i.source_cd;     
            v_list.file_no        :=  i.file_no;          
            v_list.bank_ref_no    :=  i.bank_ref_no;    
            v_list.acct_iss_cd    :=  i.acct_iss_cd;   
            v_list.collection_amt :=  i.collection_amt;
            v_list.prem_chk_flag  :=  i.prem_chk_flag; 
            v_list.prem_amt_due   :=  i.prem_amt_due;  
            v_list.comm_amt_due   :=  i.comm_amt_due;  
            v_list.net_prem_amt   :=  i.net_prem_amt;  
            v_list.net_comm_amt   :=  i.net_comm_amt;  
            v_list.dsp_or_no      :=  GET_REF_NO(i.tran_id);    
            v_list.payor          :=  i.payor;         
            v_list.chk_remarks    :=  i.chk_remarks;   
            v_list.tran_id        :=  i.tran_id;       
            v_list.tran_date      :=  i.tran_date;     
            v_list.upload_date    :=  i.upload_date;   
            v_list.upload_sw      :=  i.upload_sw;  
            
            v_list.nbt_branch_cd  := substr(i.bank_ref_no, instr(i.bank_ref_no, '-', 1, 1) + 1, instr(i.bank_ref_no, '-', 1, 2) - 4);
            v_list.nbt_ref_no     := substr(i.bank_ref_no, instr(i.bank_ref_no, '-', 1, 2) + 1, instr(i.bank_ref_no, '-', 1, 3) - 9);
            v_list.nbt_mod_no     := substr(i.bank_ref_no, instr(i.bank_ref_no, '-', 1, 3) + 1);   
            
            PIPE ROW(v_list);
                                    
        END LOOP;
        
        RETURN;
    END;
    
   
   PROCEDURE check_data_giacs610 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2,
        p_rec_id        VARCHAR2, --Deo [10.06.2016]
        p_chk_flag  OUT VARCHAR2  --Deo [10.06.2016]
   )
   IS
        v_pol_flag          VARCHAR2 (1);
        v_reg_policy_sw     VARCHAR2 (1);
        v_prem_chk_flag     VARCHAR2 (2);
        v_prem              NUMBER;
        v_tot_comm_inv      NUMBER;
        v_comm_payments     NUMBER;
        v_comm              NUMBER;
        v_net_due           NUMBER;
        v_net_prem_amt      NUMBER;
        v_net_comm_amt      NUMBER;
        v_exists            BOOLEAN := FALSE;
        v_chk_remarks       giac_upload_prem_refno.chk_remarks%TYPE;/*VARCHAR2 (2000);*/ --Deo [10.06.2016]: replace data type source
        v_bills             VARCHAR2 (3900); --Deo [10.06.2016]: increase data length from 1900 to 3900
        v_excluded_branch   VARCHAR2 (4);
        v_hist              VARCHAR2 (1) := 'N';
        v_has_claim         BOOLEAN := FALSE;
        v_date              DATE;
        v_line_cd           gipi_polbasic.line_cd%TYPE;
        v_subline_cd        gipi_polbasic.subline_cd%TYPE;
        v_iss_cd            gipi_polbasic.iss_cd%TYPE;
        v_issue_yy          gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no          gipi_polbasic.renew_no%TYPE;
        v_tot_amt_due       giac_aging_soa_details.total_amount_due%TYPE;
        v_tot_bal_due       giac_aging_soa_details.balance_amt_due%TYPE;
   BEGIN
        v_excluded_branch := NVL (giacp.v ('BRANCH_EXCLUDED_IN_UPLOAD'), 'NONE');
        
        FOR rec IN (
            SELECT a.bank_ref_no, a.collection_amt, b.iss_cd
              FROM giac_upload_prem_refno a, giis_issource b
             WHERE a.acct_iss_cd = b.acct_iss_cd
               AND source_cd = p_source_cd
               AND file_no = p_file_no
               AND rec_id = NVL (p_rec_id, rec_id) --Deo [10.06.2016]
        )
        LOOP
            v_tot_comm_inv := 0;
            v_comm_payments := 0;
            v_prem := 0;
            v_comm := 0;
            v_net_due := 0;
            v_net_prem_amt := 0;
            v_net_comm_amt := 0;
            v_prem_chk_flag := 'OK';
            v_chk_remarks := 'This policy is valid for uploading. The collection amount is equal to the total gross amount due of the policy.';
            v_exists := TRUE;
            v_has_claim := FALSE;
            v_bills := NULL;
            v_tot_amt_due := 0;
            v_tot_bal_due := 0;
            
            BEGIN
               SELECT DISTINCT 'Y'
                 INTO v_hist
                 FROM giac_upload_prem_refno a
                WHERE a.bank_ref_no = rec.bank_ref_no
                  AND EXISTS (
                        SELECT 'x'
                          FROM gipi_ref_no_hist b
                         WHERE b.bank_ref_no = a.bank_ref_no
                  );
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_hist := 'N';                          
            END;
            
            BEGIN
                SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                                renew_no
                  INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
                       v_renew_no
                  FROM gipi_polbasic
                 WHERE bank_ref_no = rec.bank_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_exists := FALSE;                         
            END;
            
            IF v_hist = 'N' THEN
                v_prem_chk_flag := 'NE';
                v_chk_remarks := 'This policy does not exist.';
                GOTO update_table;
            ELSIF v_hist = 'Y' AND NOT v_exists THEN
                v_prem_chk_flag := 'NG';
                v_chk_remarks := 'This reference number does not have a GENIISYS policy yet.';
                GOTO update_table;
            END IF;
            
            IF v_iss_cd = v_excluded_branch THEN
                v_prem_chk_flag := 'EX';
                v_chk_remarks := 'This policy''s issuing source is ' || v_excluded_branch || '.';
                GOTO update_table;
            ELSIF v_iss_cd = 'RI' THEN
                v_prem_chk_flag := 'RI';
                v_chk_remarks := 'This is a reinsurance policy.';
                GOTO update_table;
            ELSIF check_user_per_iss_cd_acctg2 (NULL, v_iss_cd, 'GIACS007', p_user_id) = 0 THEN
                v_prem_chk_flag := 'NA';
                v_chk_remarks := 'User is not allowed to make collections for the branch of this policy.';
                GOTO update_table;
            END IF;
            
            FOR rec_a IN (
                SELECT pol_flag, reg_policy_sw
                  FROM gipi_polbasic
                 WHERE line_cd = v_line_cd
                   AND subline_cd = v_subline_cd
                   AND iss_cd = v_iss_cd
                   AND issue_yy = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no
                   AND renew_no = v_renew_no
                   AND endt_seq_no = 0
          )
          LOOP
             IF rec_a.pol_flag = '5' THEN
                v_prem_chk_flag := 'SL';                                --spoiled
                v_chk_remarks := 'This policy is already spoiled.';
                GOTO update_table;
             END IF;

             IF rec_a.pol_flag = '4' THEN
                FOR rec_d IN (
                    SELECT 'X'
                      FROM giac_cancelled_policies_v
                     WHERE line_cd = v_line_cd
                       AND subline_cd = v_subline_cd
                       AND iss_cd = v_iss_cd
                       AND issue_yy = v_issue_yy
                       AND pol_seq_no = v_pol_seq_no
                       AND renew_no = v_renew_no
                )
                LOOP
                   v_prem_chk_flag := 'CP';                           --cancelled
                   v_chk_remarks := 'This is a cancelled policy.';
                   GOTO update_table;
                END LOOP;
             END IF;

             --vfm--
             IF rec_a.reg_policy_sw = 'N' AND variables_prem_payt_for_sp <> 'Y' THEN
                v_prem_chk_flag := 'SP';                         --special policy
                v_chk_remarks := 'This is a special policy.';
                GOTO update_table;
             END IF;

             v_exists := TRUE;
             EXIT;
          END LOOP;
          
          FOR rec_b IN (
                  SELECT gasd.iss_cd, gasd.prem_seq_no, gpol.reg_policy_sw,
                         SUM (balance_amt_due) bal_amt_due, SUM (total_amount_due) tot_amt_due
                    FROM giac_aging_soa_details gasd, gipi_polbasic gpol
                   WHERE 1 = 1
                     AND gasd.policy_id = gpol.policy_id
                     AND gpol.line_cd = v_line_cd
                     AND gpol.subline_cd = v_subline_cd
                     AND gpol.iss_cd = v_iss_cd
                     AND gpol.issue_yy = v_issue_yy
                     AND gpol.pol_seq_no = v_pol_seq_no
                     AND gpol.renew_no = v_renew_no
                GROUP BY gasd.iss_cd, gasd.prem_seq_no, gpol.reg_policy_sw
          )
          LOOP
             IF rec_b.reg_policy_sw <> 'N' OR (rec_b.reg_policy_sw = 'N' AND variables_prem_payt_for_sp = 'Y') THEN
                v_bills := v_bills || ', ' || rec_b.iss_cd || '-' || rec_b.prem_seq_no;
                v_tot_amt_due := v_tot_amt_due + rec_b.tot_amt_due;
                v_tot_bal_due := v_tot_bal_due + rec_b.bal_amt_due;
             END IF;
          END LOOP; 
          
          FOR rec_c IN (
              SELECT z.iss_cd, z.prem_seq_no,
                       SUM (z.comm_amt)
                     - SUM (z.wtax_amt)
                     + SUM (z.input_vat_amt) net_comm_paid
                FROM giac_comm_payts z, giac_acctrans w, gipi_invoice x
               WHERE 1 = 1
                 AND z.gacc_tran_id = w.tran_id
                 AND w.tran_flag <> 'D'
                 AND z.iss_cd = x.iss_cd
                 AND z.prem_seq_no = x.prem_seq_no
                 AND NOT EXISTS (
                        SELECT '1'
                          FROM giac_reversals x, giac_acctrans y
                         WHERE x.gacc_tran_id = z.gacc_tran_id
                           AND x.reversing_tran_id = y.tran_id
                           AND y.tran_flag <> 'D')
                 AND x.policy_id IN (
                        SELECT c.policy_id
                          FROM gipi_polbasic c
                         WHERE c.line_cd = v_line_cd
                           AND c.subline_cd = v_subline_cd
                           AND c.iss_cd = v_iss_cd
                           AND c.issue_yy = v_issue_yy
                           AND c.pol_seq_no = v_pol_seq_no
                           AND c.renew_no = v_renew_no)
            GROUP BY z.iss_cd, z.prem_seq_no
          )
          LOOP
             v_comm_payments := rec_c.net_comm_paid;
          END LOOP; 
          
          FOR rec_d IN (
              SELECT a.iss_cd, a.prem_seq_no,
                     ROUND (SUM (NVL (b.commission_amt, a.commission_amt) * c.currency_rt
                           ), 2)
                     --- SUM (NVL (b.wholding_tax, a.wholding_tax) * c.currency_rt) --Deo [10.06.2016] comment out
                     - ROUND (SUM (  (NVL (b.commission_amt, a.commission_amt) * c.currency_rt) --Deo [10.06.2016]: wtax should be based on latest rate
                            * (NVL (e.wtax_rate, 0) / 100)
                           ), 2)
                     + ROUND (SUM (  NVL (b.commission_amt, a.commission_amt)
                            * c.currency_rt
                            * (NVL (input_vat_rate, 0) / 100) --Deo [10.06.2016]: added nvl and divide by 100
                           ), 2) comm_inv --Deo [10.06.2016]: added round for each summation
                FROM gipi_comm_invoice a,
                     gipi_comm_inv_dtl b,
                     gipi_invoice c,
                     gipi_polbasic d,
                     giis_intermediary e
               WHERE a.iss_cd = b.iss_cd(+)
                 AND a.prem_seq_no = b.prem_seq_no(+)
                 AND a.intrmdry_intm_no = b.intrmdry_intm_no(+)
                 AND a.intrmdry_intm_no = e.intm_no
                 AND a.policy_id = c.policy_id
                 AND c.policy_id = d.policy_id
                 AND d.line_cd = v_line_cd
                 AND d.subline_cd = v_subline_cd
                 AND d.iss_cd = v_iss_cd
                 AND d.issue_yy = v_issue_yy
                 AND d.pol_seq_no = v_pol_seq_no
                 AND d.renew_no = v_renew_no
               GROUP BY a.iss_cd, a.prem_seq_no
               ORDER BY 1, 2
          )
          LOOP
             v_tot_comm_inv := v_tot_comm_inv + rec_d.comm_inv;
          END LOOP;   
          
          v_comm := v_tot_comm_inv - v_comm_payments;
          v_net_due := v_tot_bal_due - v_comm;     
          
          IF v_prem_chk_flag <> 'RI' THEN
             IF v_tot_bal_due = 0 THEN
                -- no outstanding balance but with payment in file
                v_prem_chk_flag := 'FP';         
                v_chk_remarks := 'This policy is already fully paid.';
             ELSIF rec.collection_amt = v_net_due AND v_comm <> 0 THEN
                -- collection amount is equal to net due amount.
                v_prem_chk_flag := 'VN';
                v_chk_remarks := 'This policy is valid for uploading. The collection amount is equal to the amount net due of the policy.';
             ELSIF rec.collection_amt > v_tot_bal_due THEN
                --collection amount is greater than the outstanding balance.
                v_prem_chk_flag := 'OP';                           --over payment
                v_chk_remarks := 'This policy with bill nos. ' || SUBSTR (v_bills, 3) || ' has a total gross amount due of '
                   || LTRIM (TO_CHAR (v_tot_amt_due, '99,999,999,999,990.90')) || '.';
             ELSIF rec.collection_amt < v_tot_bal_due AND rec.collection_amt <> v_net_due THEN
                --collection amount is less than the oustanding balance
                v_prem_chk_flag := 'PT';      --partial payment less than ner due
                v_chk_remarks := 'This is a partial payment. The total gross amount due for bill nos. ' || SUBSTR (v_bills, 3)
                   || ' is ' || LTRIM (TO_CHAR (v_tot_amt_due, '99,999,999,999,990.90')) || '.';
             END IF;
          ELSE
             v_prem_chk_flag := 'RI';
             v_chk_remarks := 'This is a reinsurance policy.';
          END IF; 
          
          IF rec.collection_amt > v_tot_bal_due THEN
             v_net_prem_amt := v_tot_bal_due;
             v_net_comm_amt := 0;
          --ELSIF rec.collection_amt < v_net_due THEN --test Deo comment out
          ELSIF rec.collection_amt < v_tot_bal_due AND rec.collection_amt <> v_net_due --Deo [10.06.2016]
          THEN
             v_net_prem_amt := rec.collection_amt;
             v_net_comm_amt := 0;
          /*ELSIF ((rec.collection_amt > v_net_due) AND (rec.collection_amt <= v_tot_bal_due)) OR (rec.collection_amt = v_net_due) THEN
             v_comm := v_tot_bal_due - rec.collection_amt;
             v_net_prem_amt := v_tot_bal_due;
             v_net_comm_amt := v_comm;*/ --Deo [10.06.2016] comment out
          ELSIF rec.collection_amt = v_net_due THEN
             v_net_prem_amt := v_tot_bal_due;
             v_net_comm_amt := v_comm;
          END IF;
          
          FOR rec_d IN (
                SELECT 'X'
                  FROM gicl_claims a
                 WHERE 1 = 1
                   AND clm_stat_cd NOT IN ('CD', 'CC', 'DN', 'WD')
                   AND a.line_cd = v_line_cd
                   AND a.subline_cd = v_subline_cd
                   AND a.pol_iss_cd = v_iss_cd
                   AND a.issue_yy = v_issue_yy
                   AND a.pol_seq_no = v_pol_seq_no
                   AND a.renew_no = v_renew_no
          )
          LOOP
             IF v_prem_chk_flag = 'OP' THEN
                v_prem_chk_flag := 'OC';
                v_chk_remarks := v_chk_remarks || ' It also has an existing claim.';
             ELSIF v_prem_chk_flag = 'PT' THEN
                v_prem_chk_flag := 'PC';
                v_chk_remarks := v_chk_remarks || ' It also has an existing claim.';
             ELSIF v_prem_chk_flag IN ('PT')    THEN
                v_prem_chk_flag := 'PC';
                v_chk_remarks := v_chk_remarks || ' It also has an existing claim.';
             ELSIF v_prem_chk_flag = 'FP' THEN                        
                v_prem_chk_flag := 'FC';
                v_chk_remarks := v_chk_remarks || ' It also has an existing claim.';
             ELSIF v_prem_chk_flag IN ('OK') THEN
                v_prem_chk_flag := 'WC';
                v_chk_remarks := 'This policy has an existing claim.';
             ELSIF v_prem_chk_flag IN ('VN') THEN
                v_prem_chk_flag := 'VC';
                v_chk_remarks := 'This policy has an existing claim.';
             END IF;

             EXIT;
          END LOOP;
            
            <<update_table>>
            UPDATE giac_upload_prem_refno
               SET prem_chk_flag = v_prem_chk_flag,
                   chk_remarks = v_chk_remarks,
                   prem_amt_due = NVL (v_tot_bal_due, 0),
                   comm_amt_due = NVL (v_comm, 0),
                   net_prem_amt = NVL (v_net_prem_amt, 0),
                   net_comm_amt = NVL (v_net_comm_amt, 0)
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
               AND bank_ref_no = rec.bank_ref_no
               AND rec_id = NVL (p_rec_id, rec_id); --Deo [10.06.2016]
               
            p_chk_flag := v_prem_chk_flag; --Deo [10.06.2016]
        END LOOP;
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
        
        BEGIN
           SELECT branch_cd, tran_date
             INTO variables_jv_branch_cd, variables_tran_date
             FROM giac_upload_jv_payt_dtl
            WHERE source_cd = p_source_cd
              AND file_no = p_file_no;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              variables_jv_branch_cd := NULL;
              variables_tran_date := NULL;
        END;
   END;
   
    FUNCTION INVALID_CHK_FLAGS
       RETURN BOOLEAN
    IS
       v_count   NUMBER := 0;
    BEGIN
       SELECT COUNT (*)
         INTO v_count
         FROM giac_upload_prem_refno
        WHERE source_cd = variables_source_cd
          AND file_no = variables_file_no
          AND prem_chk_flag NOT IN ('OK', 'VN', 'PT', 'OP'); --Deo [10.06.2016]: added PT and OP

       IF v_count > 0 THEN
          RETURN TRUE;
       ELSE
          RETURN FALSE;
       END IF;
    END;
    
    FUNCTION generate_upload_no
       RETURN CHAR
    IS
       v_seq_no      NUMBER (4);
       v_upload_no   VARCHAR2 (12);
    BEGIN
       BEGIN
          SELECT NVL (MAX (TO_NUMBER (SUBSTR (upload_no, 9, 4))) + 1, 1)
            INTO v_seq_no
            FROM giac_upload_prem_refno
           WHERE upload_no IS NOT NULL
             AND RTRIM (LTRIM (SUBSTR (upload_no, 0, 7))) = TO_CHAR (SYSDATE, 'YYYY-MM');
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_seq_no := 1;
       END;

       v_upload_no := TO_CHAR (SYSDATE, 'YYYY-MM') || '-' || RTRIM (LTRIM (TO_CHAR (v_seq_no, '0009')));
       
       RETURN v_upload_no;
    END;
   
   PROCEDURE check_validated (
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   )
   IS
        v_check      NUMBER;
        v_list       giac_upload_file%rowtype;
        v_jv_branch  giis_user_grp_hdr.grp_iss_cd%TYPE;
   BEGIN
   
        variables_source_cd := p_source_cd;
        variables_file_no   := p_file_no;  
        variables_user_id   := p_user_id;  
        
        SELECT *
          INTO v_list
          FROM giac_upload_file
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;
           
        /*BEGIN
           SELECT a.grp_iss_cd
             INTO variables_branch_cd
             FROM giis_user_grp_hdr a, giis_users b
            WHERE a.user_grp = b.user_grp 
            AND b.user_id = variables_user_id;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#Group branch code of user was not found!');
        END;*/ --Deo [10.06.2016]: comment out, moved to a pre_upload_check procedure
        
        /*BEGIN
            SELECT BRANCH_CD
              INTO v_jv_branch
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_jv_branch := variables_branch_cd;
        END;*/ --Deo [10.06.2016]: moved to get_parameters procedure
   
        /*SELECT COUNT (*)
          INTO v_check
          FROM giac_upload_prem_refno
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no
           AND prem_chk_flag IS NOT NULL;
              
        IF v_check = 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Please perform Check Data first before uploading.');
        END IF;
        
        IF INVALID_CHK_FLAGS THEN
            raise_application_error (-20001, 'UPLOAD_LIST');
        ELSE*/ --Deo [10.06.2016]: comment out, moved to a pre_upload_check procedure
            IF variables_fund_cd IS NULL THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Parameter FUND_CD is not defined in table GIAC_PARAMETERS.');    
            END IF; 
            
            /*IF variables_branch_cd IS NULL THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Branch code of user was not found.');    
            END IF;*/ --Deo [10.06.2016]: comment out
            
            get_parameters (p_source_cd, p_file_no, p_user_id, variables_branch_cd); --Deo [10.06.2016]

            IF variables_evat_cd IS NULL THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Parameter EVAT is not defined in table GIAC_PARAMETERS.');    
            END IF;        

            IF giacp.v('TAX_ALLOCATION') = 'N' THEN
                raise_application_error (-20001, 'Geniisys Exception#E#This module was designed to uploading data only if the parameter: TAX_ALLOCATION = Y.');    
            END IF;    
                    
            IF v_list.tran_class IS NOT NULL THEN
                raise_application_error (-20001, 'Geniisys Exception#E#This file has already been uploaded.');
            END IF;

            IF v_list.file_status = 'C' THEN
                raise_application_error (-20001, 'Geniisys Exception#E#This is a cancelled file.');
            END IF;
            
            raise_application_error (-20001, 'jv branch#' || variables_jv_branch_cd || '#col branch#' ||variables_branch_cd); --Deo [10.06.2016]
            
            --raise_application_error (-20001, 'branch#' || v_jv_branch); --Deo [10.06.2016]: comment out
        --END IF; --Deo [10.06.2016]: comment out
   END;
   
   PROCEDURE get_default_bank (
        p_branch_cd            VARCHAR2,
        p_user_id              VARCHAR2,
        p_dcb_bank_cd      OUT VARCHAR2,
        p_dcb_bank_acct_cd OUT VARCHAR2,
        p_dcb_bank_name    OUT VARCHAR2,
        p_dcb_bank_acct_no OUT VARCHAR2
   )
   IS
   BEGIN
        FOR a IN (
                SELECT bank_cd, bank_acct_cd
                  FROM giac_dcb_users
                 WHERE gibr_fund_cd = variables_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND dcb_user_id = p_user_id
        )
        LOOP
            p_dcb_bank_cd       := a.bank_cd;
            p_dcb_bank_acct_cd  := a.bank_acct_cd;

          IF a.bank_cd IS NULL THEN
             FOR b IN (
                SELECT bank_cd, bank_acct_cd
                  FROM giac_branches
                 WHERE gfun_fund_cd = variables_fund_cd
                   AND branch_cd = p_branch_cd
             )
             LOOP
                p_dcb_bank_cd       := b.bank_cd;
                p_dcb_bank_acct_cd  := b.bank_acct_cd;
             END LOOP;
          END IF;
        END LOOP;
        
        IF p_dcb_bank_acct_cd IS NOT NULL THEN
          FOR rec1 IN (
            SELECT bank_name
              FROM giac_banks
             WHERE bank_cd = p_dcb_bank_cd
          )
          LOOP
             p_dcb_bank_name := rec1.bank_name;
          END LOOP;

          FOR rec2 IN (
            SELECT bank_acct_no
              FROM giac_bank_accounts
             WHERE bank_cd = p_dcb_bank_cd 
               AND bank_acct_cd = p_dcb_bank_acct_cd
          )
          LOOP
             p_dcb_bank_acct_no := rec2.bank_acct_no;
          END LOOP;

        END IF;
   END;
   
   PROCEDURE check_dcb_no (
        p_source_cd       VARCHAR2,
        p_file_no         VARCHAR2,
        p_branch_cd       VARCHAR2,
        p_user_id         VARCHAR2
   )
   IS
        v_date      DATE;
        v_exist     VARCHAR2(1) := 'N'; --Deo [10.06.2016]
   BEGIN
        BEGIN
            SELECT TRAN_DATE
              INTO v_date
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_date := SYSDATE;
        END;
        
        upload_dpc_web.set_fixed_variables(giacp.v('FUND_CD'), REGEXP_REPLACE( p_branch_cd, '\s'), giacp.n('EVAT'));
        upload_dpc_web.check_dcb_user (v_date, p_user_id);
        --upload_dpc_web.get_dcb_no (v_date, variables_dcb_no); --Deo [10.06.2016]: comment out
        
        --Deo [10.06.2016]: add start
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
        --Deo [10.06.2016]: add ends
   END;
   
   PROCEDURE gen_jv 
   IS
        the_rowcount      NUMBER;
        v_branch_cd       giac_acctrans.gibr_branch_cd%TYPE;
        v_tran_year       giac_acctrans.tran_year%TYPE;
        v_tran_month      giac_acctrans.tran_month%TYPE;
        v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
        v_tran_date       giac_acctrans.tran_date%TYPE;
        v_jv_pref_suff    giac_acctrans.jv_pref_suff%TYPE;
        v_jv_no           giac_acctrans.jv_no%TYPE;
        v_particulars     giac_acctrans.particulars%TYPE;
        v_jv_tran_tag     giac_acctrans.jv_tran_tag%TYPE;
        v_jv_tran_type    giac_acctrans.jv_tran_type%TYPE;
        v_jv_tran_mm      giac_acctrans.jv_tran_mm%TYPE;
        v_jv_tran_yy      giac_acctrans.jv_tran_yy%TYPE;
        v_tran_flag       giac_acctrans.tran_flag%TYPE;
        v_tran_class      giac_acctrans.tran_class%TYPE;
        v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
        v_tot_colln_amt   giac_upload_file.hash_collection%TYPE;
        v_gen_type        giac_modules.generation_type%TYPE;
   BEGIN
        SELECT COUNT(*)
          INTO the_rowcount
          FROM giac_upload_prem_refno
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
           
          IF the_rowcount = 0 THEN
             raise_application_error (-20001, 'Geniisys Exception#E#No records found for upload.');
          END IF;
          
          BEGIN
             SELECT branch_cd, tran_date, tran_year, tran_month,
                    jv_pref_suff, particulars, jv_tran_tag,
                    jv_tran_type, jv_tran_mm, jv_tran_yy
               INTO v_branch_cd, v_tran_date, v_tran_year, v_tran_month,
                    v_jv_pref_suff, v_particulars, v_jv_tran_tag,
                    v_jv_tran_type, v_jv_tran_mm, v_jv_tran_yy
               FROM giac_upload_jv_payt_dtl
              WHERE source_cd = variables_source_cd  
                AND file_no = variables_file_no;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                raise_application_error (-20001, 'Geniisys Exception#E#No data found in table: giac_upload_jv_payt_dtl.');
          END;
          
          SELECT acctran_tran_id_s.NEXTVAL
            INTO variables_jv_tran_id
            FROM SYS.DUAL;
            
            v_tran_flag := 'C';
            v_tran_class := 'BP';
            v_tran_class_no :=
            giac_sequence_generation (variables_fund_cd, v_branch_cd, v_tran_class, v_tran_year, v_tran_month);
            v_jv_no := v_tran_class_no;
            variables_tran_date := TO_DATE (   TO_CHAR (v_tran_date, 'MM-DD-YYYY') || ' ' || TO_CHAR (SYSDATE, 'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');      
            v_tran_seq_no := giac_sequence_generation (variables_fund_cd, /*variables_branch_cd*/ v_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month); --Deo [10.06.2016]: replace branch_cd source
            
            INSERT INTO giac_acctrans
                        (tran_id, gfun_fund_cd, gibr_branch_cd,
                         tran_flag, tran_date, tran_year, tran_month,
                         tran_class, tran_seq_no, tran_class_no, jv_pref_suff, jv_no,
                         particulars, jv_tran_tag, jv_tran_type, jv_tran_mm, jv_tran_yy,
                         ae_tag, upload_tag, user_id, last_update
                        )
                 VALUES (variables_jv_tran_id, variables_fund_cd, v_branch_cd,
                         v_tran_flag, variables_tran_date, v_tran_year, v_tran_month,
                         v_tran_class, v_tran_seq_no, v_tran_class_no, NULL, NULL,
                         v_particulars, NULL, NULL, NULL, NULL,
                         'N', 'Y', VARIABLES_USER_ID, SYSDATE
                        );
                        
                UPDATE giac_upload_jv_payt_dtl
                   SET jv_no = v_jv_no,
                       tran_seq_no = v_tran_seq_no --Deo [10.06.2016]
                 WHERE source_cd = variables_source_cd
                  AND file_no = variables_file_no;
                  
            SELECT hash_collection
              INTO v_tot_colln_amt
              FROM giac_upload_file
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no;

       BEGIN
          SELECT generation_type
            INTO v_gen_type
            FROM giac_modules
           WHERE module_name = 'GIACS610';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error (-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
       END;
       
       upload_dpc_web.aeg_create_cib_acct_entries (variables_jv_tran_id,
                                               v_branch_cd,
                                               variables_fund_cd,
                                               variables_dcb_bank_cd,
                                               variables_dcb_bank_acct_cd,
                                               ABS (v_tot_colln_amt),
                                               v_gen_type,
                                               variables_user_id
                                              );
       upload_dpc_web.aeg_parameters_misc (variables_jv_tran_id,
                                       'GIACS610',
                                       1,
                                       ABS (v_tot_colln_amt),
                                       NULL,
                                       variables_user_id
                                      );
            
   END;
   
   PROCEDURE insert_prem_deposit (
       p_collection_amt   giac_prem_deposit.collection_amt%TYPE
   )
   IS
   BEGIN
      INSERT INTO giac_prem_deposit
                  (gacc_tran_id, item_no, transaction_type, collection_amt,
                   dep_flag, currency_cd, convert_rate, foreign_curr_amt,
                   upload_tag, colln_dt, or_print_tag, or_tag, user_id,
                   last_update
                  )
           VALUES (variables_tran_id, 1, 1, p_collection_amt,
                   1, 1, 1, p_collection_amt, 'Y', 
                   TRUNC (variables_tran_date), 'N', 'N', variables_user_id,
                   SYSDATE
                  );
   END;
   
   PROCEDURE gen_prem_dep_op_text
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
                       item_amt, user_id, last_update,
                       bill_no, item_text, print_seq_no,
                       currency_cd, foreign_curr_amt
                      )
               VALUES (c_rec.gacc_tran_id, variables_gen_type, v_seq_no,
                       c_rec.item_amt, c_rec.user_id, c_rec.last_update,
                       c_rec.bill_no, c_rec.item_text, v_seq_no,
                       c_rec.currency_cd, c_rec.foreign_curr_amt
                      );

          v_seq_no := v_seq_no + 1;
       END LOOP;
   END;
   
   FUNCTION sl_type_cd_not_null (
       p_module_name   giac_modules.module_name%TYPE,
       p_item_no       giac_module_entries.item_no%TYPE
   )
        RETURN BOOLEAN
   IS
        v_ctr   NUMBER;
   BEGIN
        SELECT COUNT (sl_type_cd)
          INTO v_ctr
          FROM giac_modules a, giac_module_entries b
         WHERE a.module_id = b.module_id
           AND a.module_name = p_module_name
           AND item_no = p_item_no;

       IF v_ctr <> 0 THEN
          RETURN (TRUE);
       ELSE
          RETURN (FALSE);
       END IF;
   END;
   
    PROCEDURE with_tax_allocation
    IS
       vl_lt            NUMBER;
       v_prem           giac_direct_prem_collns.premium_amt%TYPE;
       v_name           VARCHAR2 (50) := 'PREM_TAX_PRIORITY';
       v_the_priority   VARCHAR2 (1);
    BEGIN
       v_prem := 0;
       v_the_priority := giacp.v (v_name);

       IF v_the_priority IS NULL THEN
          raise_application_error (-20001, 'Geniisys Exception#E#There is no existing ' || v_name || ' parameter in GIAC_PARAMETERS table.');
       END IF;
       
       IF v_the_priority = 'P' THEN
          IF NVL (variables_collection_amt, 0) = variables_max_collection_amt THEN
             variables_premium_amt := variables_max_premium_amt;
             variables_tax_amt := variables_max_tax_amt;
          ELSIF ABS (NVL (variables_collection_amt, 0)) <= ABS (NVL (variables_max_premium_amt, 0)) THEN
             variables_premium_amt := variables_collection_amt;
             variables_tax_amt := 0;
          ELSE
             variables_premium_amt := variables_max_premium_amt;
             variables_tax_amt := NVL (variables_collection_amt, 0) - NVL (variables_max_premium_amt, 0);
          END IF;
       ELSE
          IF NVL (variables_collection_amt, 0) = variables_max_collection_amt THEN
             variables_premium_amt := variables_max_premium_amt;
             variables_tax_amt := variables_max_tax_amt;
          ELSIF ABS (NVL (variables_collection_amt, 0)) <= ABS (variables_max_tax_amt) THEN
             variables_premium_amt := 0;
             variables_tax_amt := variables_collection_amt;
          ELSE
             variables_premium_amt := NVL (variables_collection_amt, 0) - NVL (variables_max_tax_amt, 0);
             variables_tax_amt := variables_max_tax_amt;
          END IF;
       END IF;
       
       --Deo [10.06.2016]: add start
       variables_foreign_curr_amt :=
                         NVL (variables_collection_amt, 0)
                         / variables_convert_rate;

       IF variables_tax_amt = 0
       THEN
          variables_premium_amt := variables_collection_amt;
          variables_tax_amt := 0;
       ELSE
          IF variables_transaction_type = 1
          THEN
             upload_dpc_web.tax_alloc_type1 (variables_tran_id,
                                             variables_transaction_type,
                                             variables_iss_cd,
                                             variables_prem_seq_no,
                                             variables_inst_no,
                                             variables_collection_amt,
                                             variables_premium_amt,
                                             variables_tax_amt,
                                             variables_max_premium_amt,
                                             variables_user_id,
                                             SYSDATE
                                            );
          ELSIF variables_transaction_type = 3
          THEN
             upload_dpc_web.tax_alloc_type3 (variables_tran_id,
                                             variables_transaction_type,
                                             variables_iss_cd,
                                             variables_prem_seq_no,
                                             variables_inst_no,
                                             variables_collection_amt,
                                             variables_premium_amt,
                                             variables_tax_amt,
                                             variables_max_premium_amt,
                                             variables_user_id,
                                             SYSDATE
                                            );
          END IF;
       END IF;
       --Deo [10.06.2016]: add ends
    END;
   
   PROCEDURE insert_premium_collns (
       p_bank_ref_no            giac_upload_prem_refno.bank_ref_no%TYPE,
       p_line_cd                gipi_polbasic.line_cd%TYPE,
       p_subline_cd             gipi_polbasic.subline_cd%TYPE,
       p_iss_cd                 gipi_polbasic.iss_cd%TYPE,
       p_issue_yy               gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no               gipi_polbasic.renew_no%TYPE,
       p_prem_amt_due           giac_direct_prem_collns.collection_amt%TYPE,
       p_collection_amt         giac_direct_prem_collns.collection_amt%TYPE,
       p_net_amt_due            giac_order_of_payts.collection_amt%TYPE,
       p_prem_chk_flag          giac_upload_prem.prem_chk_flag%TYPE,
       p_rem_colln_amt    OUT   giac_direct_prem_collns.collection_amt%TYPE
    )
    IS
       v_colln_amt       NUMBER                      := 0;
       v_rem_colln_amt   NUMBER                      := 0;
       v_assd_no         giis_assured.assd_no%TYPE;
       v_ins_colln_amt   NUMBER                      := 0;  
    BEGIN
       v_rem_colln_amt := p_collection_amt;
       
       FOR rec IN (
             SELECT c.iss_cd, c.prem_seq_no, c.inst_no, c.balance_amt_due,
                    c.prem_balance_due, c.tax_balance_due, b.currency_cd,
                    b.currency_rt, b.acct_ent_date, a.assd_no, a.policy_id,
                    a.par_id, a.reg_policy_sw, b.multi_booking_yy,
                    b.multi_booking_mm
               FROM gipi_installment d,
                    giac_aging_soa_details c,
                    gipi_invoice b,
                    gipi_polbasic a
              WHERE 1 = 1
                AND c.iss_cd = d.iss_cd
                AND c.prem_seq_no = d.prem_seq_no
                AND c.inst_no = d.inst_no
                AND c.balance_amt_due <> 0
                AND b.iss_cd = c.iss_cd
                AND b.prem_seq_no = c.prem_seq_no
                AND a.policy_id = b.policy_id
                AND a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
           ORDER BY 1, 2, 3
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
                      raise_application_error (-20001, 'Geniisys Exception#I#' || rec.iss_cd || '-' || TO_CHAR (rec.prem_seq_no) || ' has no assured.');
                END;
             END IF;

             --determine the tran type
             IF rec.balance_amt_due > 0 THEN
                variables_transaction_type := 1;
             ELSE
                variables_transaction_type := 3;
             END IF;

             -- rad 06172010
                 --get the amt to be used for the bill
             IF p_prem_chk_flag IN ('OK', 'WC', 'OP', 'OC', 'VN', 'VC') THEN
                v_colln_amt := rec.balance_amt_due;
             ELSIF p_prem_chk_flag IN ('PG', 'CG') THEN                                        
                v_colln_amt := p_prem_amt_due;
             ELSE
                IF v_rem_colln_amt < rec.balance_amt_due THEN
                   v_colln_amt := v_rem_colln_amt;           
                ELSE
                   v_colln_amt := rec.balance_amt_due;
                END IF;
             END IF;

             variables_iss_cd := rec.iss_cd;
             variables_prem_seq_no := rec.prem_seq_no;
             variables_inst_no := rec.inst_no;
             variables_max_collection_amt := rec.balance_amt_due;
             variables_max_premium_amt := rec.prem_balance_due;
             variables_max_tax_amt := rec.tax_balance_due;
             variables_collection_amt := v_colln_amt;
             variables_currency_cd := rec.currency_cd;
             variables_convert_rate := rec.currency_rt;
             with_tax_allocation;

             IF TO_DATE ('01-' || rec.multi_booking_mm || '-' || rec.multi_booking_yy, 'DD-MON-YYYY') > variables_tran_date
                AND rec.acct_ent_date IS NULL AND giacp.v ('ENTER_ADVANCED_PAYT') = 'Y' THEN      
                                                      
                    INSERT INTO giac_advanced_payt
                                (gacc_tran_id, policy_id, transaction_type,
                                 iss_cd, prem_seq_no, inst_no,
                                 premium_amt, tax_amt, booking_mth,
                                 booking_year, assd_no, user_id, last_update
                                )
                         VALUES (variables_tran_id, rec.policy_id, variables_transaction_type,
                                 variables_iss_cd, variables_prem_seq_no, variables_inst_no,
                                 variables_premium_amt, variables_tax_amt, rec.multi_booking_mm,
                                 rec.multi_booking_yy, NVL (rec.assd_no, v_assd_no), variables_user_id, SYSDATE
                                );
             END IF;

            INSERT INTO giac_direct_prem_collns
                    (gacc_tran_id, transaction_type, b140_iss_cd,
                     b140_prem_seq_no, inst_no,
                     collection_amt, premium_amt,
                     tax_amt, or_print_tag, currency_cd,
                     convert_rate, foreign_curr_amt, user_id, last_update
                    )
             VALUES (variables_tran_id, variables_transaction_type, variables_iss_cd,
                     variables_prem_seq_no, variables_inst_no,
                     variables_collection_amt, variables_premium_amt,
                     variables_tax_amt, 'N', variables_currency_cd,
                     variables_convert_rate, variables_foreign_curr_amt, variables_user_id, SYSDATE
                    );

             IF variables_max_colln_amt < v_colln_amt THEN
                variables_max_colln_amt := v_colln_amt;
                variables_max_iss_cd := variables_iss_cd;
                variables_max_prem_seq_no := variables_prem_seq_no;
             END IF;

             IF p_prem_chk_flag IN ('OK', 'WC', 'OP', 'OC', 'VN', 'VC') THEN
                v_ins_colln_amt := v_ins_colln_amt + v_colln_amt;
                v_rem_colln_amt := v_rem_colln_amt - v_colln_amt;
             ELSE
                v_rem_colln_amt := v_rem_colln_amt - v_colln_amt;
             END IF;
          END IF;                                    

          --exit if the collection amt has been fully distributed
          IF v_rem_colln_amt = 0 THEN
             EXIT;
          END IF;
       END LOOP;
       
       IF p_prem_chk_flag IN ('OK', 'WC', 'OP', 'OC') THEN 
          p_rem_colln_amt := v_rem_colln_amt - v_ins_colln_amt;
       ELSE
          p_rem_colln_amt := v_rem_colln_amt;
       END IF;

       p_rem_colln_amt := v_rem_colln_amt;
       
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
    
    FUNCTION get_parent_intm_no (
        p_intm_no NUMBER
    )
       RETURN NUMBER
    IS
       v_loop             BOOLEAN      := TRUE;
       v_intm_no          NUMBER;
       v_parent_intm_no   NUMBER;
       v_lic_tag          VARCHAR2 (1);
       v_sl_cd            NUMBER;
    BEGIN
        v_intm_no := p_intm_no;

       WHILE v_loop
       LOOP
          BEGIN
             SELECT a.parent_intm_no, a.lic_tag
               INTO v_parent_intm_no, v_lic_tag
               FROM giis_intermediary a, giis_intm_type b
              WHERE a.intm_type = b.intm_type AND a.intm_no = v_intm_no;

             IF v_parent_intm_no IS NULL THEN
                IF v_lic_tag = 'Y' THEN
                   v_sl_cd := v_intm_no;
                   v_loop := FALSE;
                ELSE
                   v_sl_cd := v_intm_no;
                   v_loop := FALSE;
                END IF;
             ELSE
                IF v_lic_tag = 'Y' THEN
                   v_sl_cd := v_intm_no;
                   v_loop := FALSE;
                ELSE
                   v_intm_no := v_parent_intm_no;
                   v_loop := TRUE;
                END IF;
             END IF;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Intermediary ' || TO_CHAR (v_intm_no) || ' does not exist in table giis_intermediary.');
          END;
       END LOOP;

       RETURN (v_sl_cd);
    END;
    
    PROCEDURE insert_comm_payts (
       p_prem_chk_flag         giac_upload_prem_refno.prem_chk_flag%TYPE,
       p_policy_id             gipi_polbasic.policy_id%TYPE,
       p_intm_no               giis_intermediary.intm_no%TYPE,
       p_comm_amt              giac_comm_payts.comm_amt%TYPE,
       p_whtax_amt             giac_comm_payts.wtax_amt%TYPE,
       p_invat_amt             giac_comm_payts.input_vat_amt%TYPE,
       p_rem_comm_amt    OUT   giac_comm_payts.comm_amt%TYPE,
       p_rem_whtax_amt   OUT   giac_comm_payts.comm_amt%TYPE,
       p_rem_invat_amt   OUT   giac_comm_payts.comm_amt%TYPE
    )
    IS
       v_comm_amt           giac_comm_payts.comm_amt%TYPE;
       v_whtax_amt          giac_comm_payts.wtax_amt%TYPE;
       v_invat_amt          giac_comm_payts.input_vat_amt%TYPE;
       v_tran_type          NUMBER;
       v_record_no          giac_comm_payts.record_no%TYPE;
       v_foreign_curr_amt   giac_comm_payts.foreign_curr_amt%TYPE;
       v_print_tag          giac_comm_payts.print_tag%TYPE             := 'N';
       v_inv_prem           gipi_invoice.prem_amt%TYPE;
       v_inv_comm           gipi_comm_invoice.commission_amt%TYPE;
       v_inv_whtax          gipi_comm_invoice.wholding_tax%TYPE;
       v_pd_prem            giac_direct_prem_collns.premium_amt%TYPE;
       v_pd_comm            giac_comm_payts.comm_amt%TYPE;
       v_pd_whtax           giac_comm_payts.wtax_amt%TYPE;
       v_pd_invat           giac_comm_payts.input_vat_amt%TYPE;
       v_invat_rt           NUMBER;                               -- rad 06162010
       v_prem_pct           NUMBER;
       v_def_comm_tag       VARCHAR2 (1);
       v_comm_due           giac_comm_payts.comm_amt%TYPE;
       v_whtax_due          giac_comm_payts.wtax_amt%TYPE;
       v_invat_due          giac_comm_payts.input_vat_amt%TYPE;
       v_max_invat_due      giac_comm_payts.input_vat_amt%TYPE;
       v_max_whtax_due      giac_comm_payts.wtax_amt%TYPE;
    BEGIN
        BEGIN
          SELECT input_vat_rate
            INTO v_invat_rt
            FROM giis_intermediary
           WHERE intm_no = p_intm_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error (-20001, 'Geniisys Exception#E#Intermediary does not exist in table giis_intermediary.');
       END;
       
       p_rem_comm_amt := p_comm_amt;
       p_rem_whtax_amt := p_whtax_amt;
       p_rem_invat_amt := p_invat_amt;
       
       IF p_comm_amt > 0 THEN
          v_tran_type := 1;
       ELSE
          v_tran_type := 3;
       END IF;
       
       FOR rec IN (
              SELECT gi.iss_cd, gi.prem_seq_no, gi.prem_amt,
                     NVL (gcid.commission_amt, gci.commission_amt) comm_amt,
                     NVL (gcid.wholding_tax, gci.wholding_tax) whtax_amt, gi.currency_cd,
                     gi.currency_rt, gi.multi_booking_mm, gi.multi_booking_yy
                FROM gipi_comm_inv_dtl gcid,
                     gipi_comm_invoice gci,
                     gipi_invoice gi,
                     gipi_polbasic gpol
               WHERE 1 = 1
                 AND NVL (gcid.commission_amt, gci.commission_amt) <> 0
                 AND gci.iss_cd = gcid.iss_cd(+)
                 AND gci.prem_seq_no = gcid.prem_seq_no(+)
                 AND gci.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
                 AND gci.iss_cd = gi.iss_cd
                 AND gci.prem_seq_no = gi.prem_seq_no
                 AND gci.intrmdry_intm_no = p_intm_no
                 AND gi.policy_id = gpol.policy_id
                 AND gpol.policy_id = p_policy_id
            ORDER BY 1, 2, 3
       )
       LOOP
          v_inv_comm := rec.comm_amt * rec.currency_rt;
          v_inv_whtax := rec.whtax_amt * rec.currency_rt;
          v_inv_prem := rec.prem_amt * rec.currency_rt;

          IF SIGN (p_comm_amt) <> SIGN (v_inv_comm) THEN
             raise_application_error (-20001, 'Geniisys Exception#E#Error encountered in program unit: insert_comm_payts. Inconsistent amounts detected.');
          END IF;


        SELECT NVL (SUM (a.premium_amt), 0)
          INTO v_pd_prem
          FROM giac_acctrans b, giac_direct_prem_collns a
         WHERE NOT EXISTS (
                  SELECT 'x'
                    FROM giac_reversals cc, giac_acctrans dd
                   WHERE cc.reversing_tran_id = dd.tran_id
                     AND dd.tran_flag <> 'D'
                     AND cc.gacc_tran_id = b.tran_id)
           AND b.tran_flag <> 'D'
           AND a.gacc_tran_id = b.tran_id
           AND a.b140_iss_cd = rec.iss_cd
           AND a.b140_prem_seq_no = rec.prem_seq_no;

          v_prem_pct := v_pd_prem / v_inv_prem;

            SELECT NVL (SUM (comm_amt), 0), NVL (SUM (wtax_amt), 0),
                   NVL (SUM (input_vat_amt), 0)
              INTO v_pd_comm, v_pd_whtax,
                   v_pd_invat
              FROM giac_acctrans b, giac_comm_payts a
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_flag <> 'D'
               AND NOT EXISTS (
                      SELECT 'x'
                        FROM giac_reversals cc, giac_acctrans dd
                       WHERE cc.reversing_tran_id = dd.tran_id
                         AND dd.tran_flag <> 'D'
                         AND cc.gacc_tran_id = b.tran_id)
               AND a.iss_cd = rec.iss_cd
               AND a.prem_seq_no = rec.prem_seq_no
               AND a.intm_no = p_intm_no;

          v_comm_due := v_inv_comm * v_prem_pct - v_pd_comm;

          IF v_comm_due = 0 THEN
             GOTO end_of_loop;
          END IF;

          v_max_whtax_due := v_inv_whtax - v_pd_whtax;

          IF v_prem_pct < 1 THEN
             v_whtax_due := v_comm_due * v_inv_whtax / v_inv_comm;

             IF v_max_whtax_due <> 0 AND ABS (v_whtax_due) > ABS (v_max_whtax_due) AND TRUNC ((v_whtax_due / v_max_whtax_due), 2) = 1 THEN
                v_whtax_due := v_max_whtax_due;
             END IF;
          ELSE
             v_whtax_due := v_max_whtax_due;
          END IF;

          v_invat_due := v_comm_due * NVL (v_invat_rt, 0) / 100;

          IF v_invat_due <> 0 THEN
             v_max_invat_due :=
                               v_inv_comm * NVL (v_invat_rt, 0) / 100
                               - v_pd_invat;        
             IF v_max_invat_due <> 0
                AND ABS (v_invat_due) > ABS (v_max_invat_due)
                AND TRUNC ((v_invat_due / v_max_invat_due), 2) = 1
             THEN
                v_invat_due := v_max_invat_due;
             END IF;
          END IF;

          --get the amts to be used for the bill
          IF ABS (p_rem_comm_amt) < ABS (v_comm_due) THEN
             v_comm_amt := p_rem_comm_amt;
             v_max_whtax_due := v_whtax_amt;
             v_whtax_amt := p_rem_comm_amt * v_inv_whtax / v_inv_comm;

             IF     v_max_whtax_due <> 0
                AND ABS (v_whtax_due) > ABS (v_max_whtax_due)
                AND TRUNC ((v_whtax_due / v_max_whtax_due), 2) = 1
             THEN
                v_whtax_due := v_max_whtax_due;
             END IF;

             v_invat_amt := p_rem_comm_amt * NVL (v_invat_rt, 0) / 100;
                                                       --jason 05252009: added NVL
          ELSE
             v_comm_amt := v_comm_due;
             v_whtax_amt := v_whtax_due;
             v_invat_amt := v_invat_due;
          END IF;

          IF p_prem_chk_flag IN ('PG', 'CG') THEN
             v_comm_amt := p_comm_amt;
             v_whtax_amt := p_whtax_amt;
             v_invat_amt := p_invat_amt;
          END IF;

          v_foreign_curr_amt := v_comm_amt / rec.currency_rt;
          --get def_comm_tag
          v_def_comm_tag := 'Y';

          IF v_tran_type = 1 AND v_prem_pct < 1 THEN
             v_def_comm_tag := 'N';
          END IF;

          variables_comm_tag := 'N';
          v_record_no := 0;

          IF TO_DATE ('01-' || rec.multi_booking_mm || '-' || rec.multi_booking_yy, 'DD-MON-YYYY') > variables_tran_date AND giacp.v ('ENTER_PREPAID_COMM') = 'Y' THEN                                                     -- rad 06152010
             INSERT INTO giac_prepaid_comm
                         (gacc_tran_id, policy_id, transaction_type,
                          intm_no, iss_cd, prem_seq_no, comm_amt,
                          wtax_amt, input_vat_amt, user_id, last_update,
                          booking_mth, booking_year
                         )
                  VALUES (variables_tran_id, p_policy_id, v_tran_type,
                          p_intm_no, rec.iss_cd, rec.prem_seq_no, v_comm_amt,
                          v_whtax_amt, v_invat_amt, variables_user_id, SYSDATE,
                          rec.multi_booking_mm, rec.multi_booking_yy
                         );
          END IF;

          INSERT INTO giac_comm_payts
                      (gacc_tran_id, intm_no, iss_cd, prem_seq_no,
                       comm_tag, record_no, tran_type, comm_amt,
                       wtax_amt, input_vat_amt, currency_cd,
                       convert_rate, foreign_curr_amt, def_comm_tag,
                       print_tag, parent_intm_no, user_id, last_update
                      )
               VALUES (variables_tran_id, p_intm_no, rec.iss_cd, rec.prem_seq_no,
                       variables_comm_tag, v_record_no, v_tran_type, v_comm_amt,
                       v_whtax_amt, v_invat_amt, rec.currency_cd,
                       rec.currency_rt, v_foreign_curr_amt, v_def_comm_tag,
                       v_print_tag, variables_parent_intm_no, variables_user_id, SYSDATE
                      );

          p_rem_comm_amt := p_rem_comm_amt - v_comm_amt;
          p_rem_whtax_amt := p_rem_whtax_amt - v_whtax_amt;
          p_rem_invat_amt := p_rem_invat_amt - v_invat_amt;

          IF p_rem_comm_amt = 0 THEN
             EXIT;
          END IF;

          <<end_of_loop>>
          NULL;
       END LOOP rec;
    END;
    
    PROCEDURE gen_dpc_op_text_prem2 (
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
           SET item_amt = NVL (item_amt, 0) + NVL (p_premium_amt, 0),
               foreign_curr_amt =
                    NVL (foreign_curr_amt, 0)
                    + NVL (p_premium_amt / p_convert_rate, 0)
         WHERE gacc_tran_id = variables_tran_id
           AND item_text = p_prem_text
           AND item_gen_type = variables_gen_type;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          INSERT INTO giac_op_text
                      (gacc_tran_id, item_gen_type, item_seq_no,
                       item_amt, item_text, print_seq_no, currency_cd,
                       user_id, last_update, foreign_curr_amt
                      )
               VALUES (variables_tran_id, variables_gen_type, p_seq_no,
                       p_premium_amt, p_prem_text, p_seq_no, p_currency_cd,
                       variables_user_id, SYSDATE, p_premium_amt / p_convert_rate
                      );
    END;
    
    PROCEDURE gen_dpc_op_text_tax (
       p_tax_cd         NUMBER,
       p_tax_name       VARCHAR2,
       p_tax_amt        NUMBER,
       p_currency_cd    NUMBER,
       p_convert_rate   NUMBER
    )
    IS
       v_exist   VARCHAR2 (1);
    BEGIN
       BEGIN
          SELECT 'X'
            INTO v_exist
            FROM giac_op_text
           WHERE gacc_tran_id = variables_tran_id
             AND item_gen_type = variables_gen_type
             AND SUBSTR (item_text, 1, 5) =
                       LTRIM (TO_CHAR (p_tax_cd, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (p_currency_cd, '09'));

          UPDATE giac_op_text
             SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                 foreign_curr_amt =
                    NVL (foreign_curr_amt, 0)
                    + NVL (p_tax_amt / p_convert_rate, 0)
           WHERE gacc_tran_id = variables_tran_id
             AND item_gen_type = variables_gen_type
             AND SUBSTR (item_text, 1, 5) =
                       LTRIM (TO_CHAR (p_tax_cd, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (p_currency_cd, '09'));
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             BEGIN
                variables_n_seq_no := variables_n_seq_no + 1;

                INSERT INTO giac_op_text
                            (gacc_tran_id, item_gen_type,
                             item_seq_no, item_amt,
                             item_text,
                             print_seq_no, currency_cd, user_id, last_update,
                             foreign_curr_amt
                            )
                     VALUES (variables_tran_id, variables_gen_type,
                             variables_n_seq_no, p_tax_amt,
                                LTRIM (TO_CHAR (p_tax_cd, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (p_currency_cd, '09'))
                             || '-'
                             || p_tax_name,
                             variables_n_seq_no, p_currency_cd, variables_user_id, SYSDATE,
                             p_tax_amt / p_convert_rate
                            );
             END;
       END;
    END;
    
    PROCEDURE gen_dpc_op_text_prem (
       p_iss_cd         IN   giac_direct_prem_collns.b140_iss_cd%TYPE,
       p_prem_seq_no    IN   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
       p_inst_no        IN   giac_direct_prem_collns.inst_no%TYPE,
       p_premium_amt    IN   NUMBER,
       p_currency_cd    IN   giac_direct_prem_collns.currency_cd%TYPE,
       p_convert_rate   IN   giac_direct_prem_collns.convert_rate%TYPE
    )
    IS
       v_exist             VARCHAR2 (1);
       n_seq_no            NUMBER (2);
       v_tax_name          VARCHAR2 (100);
       v_tax_cd            NUMBER (2);
       v_sub_tax_amt       NUMBER (14, 2);
       v_currency_cd       giac_direct_prem_collns.currency_cd%TYPE;
       v_convert_rate      giac_direct_prem_collns.convert_rate%TYPE;
       v_prem_type         VARCHAR2 (1) := 'E';
       v_prem_text         VARCHAR2 (25);
       v_or_curr_cd        giac_order_of_payts.currency_cd%TYPE;
       v_def_curr_cd       giac_order_of_payts.currency_cd%TYPE := NVL (giacp.n ('CURRENCY_CD'), 1);
       v_inv_tax_amt       gipi_inv_tax.tax_amt%TYPE;
       v_inv_tax_rt        gipi_inv_tax.rate%TYPE;
       v_inv_prem_amt      gipi_invoice.prem_amt%TYPE;
       v_tax_colln_amt     giac_tax_collns.tax_amt%TYPE;
       v_premium_amt       gipi_invoice.prem_amt%TYPE;
       v_exempt_prem_amt   gipi_invoice.prem_amt%TYPE;
       v_init_prem_text    VARCHAR2 (25);
    BEGIN
        v_premium_amt := p_premium_amt;

       BEGIN
            SELECT DECODE (NVL (c.tax_amt, 0), 0, 'Z', 'V') prem_type,
                   c.tax_amt inv_tax_amt, c.rate inv_tax_rt, b.prem_amt inv_prem_amt
              INTO v_prem_type,
                   v_inv_tax_amt, v_inv_tax_rt, v_inv_prem_amt
              FROM gipi_invoice b, gipi_inv_tax c
             WHERE b.iss_cd = c.iss_cd
               AND b.prem_seq_no = c.prem_seq_no
               AND c.tax_cd = variables_evat_cd
               AND c.iss_cd = p_iss_cd
               AND c.prem_seq_no = p_prem_seq_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             NULL;
       END;

       IF v_prem_type = 'V' THEN
          v_prem_text := 'PREMIUM (VATABLE)';
          n_seq_no := 1;
          
          BEGIN
              IF ABS (v_inv_prem_amt - ROUND (v_inv_tax_amt / v_inv_tax_rt * 100, 2)) * p_convert_rate > 1 THEN
                BEGIN
                   SELECT NVL (tax_amt, 0)
                     INTO v_tax_colln_amt
                     FROM giac_tax_collns
                    WHERE gacc_tran_id = variables_tran_id
                      AND b160_iss_cd = p_iss_cd
                      AND b160_prem_seq_no = p_prem_seq_no
                      AND inst_no = p_inst_no
                      AND b160_tax_cd = variables_evat_cd;
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      v_tax_colln_amt := 0;
                END;

                IF v_tax_colln_amt <> 0 THEN
                   v_premium_amt := ROUND (v_tax_colln_amt / v_inv_tax_rt * 100, 2);
                   v_exempt_prem_amt := p_premium_amt - v_premium_amt;

                   IF ABS (v_exempt_prem_amt) <= 1 THEN
                      v_premium_amt := p_premium_amt;
                      v_exempt_prem_amt := NULL;
                   END IF;
                END IF;
              END IF;
          EXCEPTION --Deo [11.24.2016]: added exception
            WHEN ZERO_DIVIDE THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Invalid tax rate. Please check VAT rate in tax charge maintenance.');
          END;
       ELSIF v_prem_type = 'Z'  THEN
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
             IF rec = 1 THEN
                v_init_prem_text := 'PREMIUM (VATABLE)';
             ELSIF rec = 2 THEN
                v_init_prem_text := 'PREMIUM (ZERO-RATED)';
             ELSE
                v_init_prem_text := 'PREMIUM (VAT-EXEMPT)';
             END IF;

             gen_dpc_op_text_prem2 (rec, 0, v_init_prem_text, v_currency_cd, v_convert_rate);
             variables_zero_prem_op_text := 'N';
          END LOOP;
       END IF;

       gen_dpc_op_text_prem2 (n_seq_no, v_premium_amt, v_prem_text, v_currency_cd, v_convert_rate);

       IF NVL (v_exempt_prem_amt, 0) <> 0
       THEN
          v_prem_text := 'PREMIUM (VAT-EXEMPT)';
          n_seq_no := 3;
          gen_dpc_op_text_prem2 (n_seq_no, v_exempt_prem_amt, v_prem_text, v_currency_cd, v_convert_rate);
       END IF;

       BEGIN
          FOR tax IN (
                SELECT b.b160_tax_cd, c.tax_name, b.tax_amt, a.currency_cd, a.convert_rate
                  FROM giac_direct_prem_collns a, giac_taxes c, giac_tax_collns b
                 WHERE 1 = 1
                   AND a.gacc_tran_id = b.gacc_tran_id
                   AND a.b140_iss_cd = b.b160_iss_cd
                   AND a.b140_prem_seq_no = b.b160_prem_seq_no
                   AND a.inst_no = b.inst_no
                   AND c.fund_cd = variables_fund_cd
                   AND b.b160_tax_cd = c.tax_cd
                   AND b.inst_no = p_inst_no
                   AND b.b160_prem_seq_no = p_prem_seq_no
                   AND b.b160_iss_cd = p_iss_cd
                   AND b.gacc_tran_id = variables_tran_id
          )
          LOOP
             v_tax_cd := tax.b160_tax_cd;
             v_tax_name := tax.tax_name;
             v_sub_tax_amt := tax.tax_amt;

             IF v_or_curr_cd = v_def_curr_cd THEN
                v_convert_rate := 1;
                v_currency_cd := v_def_curr_cd;
             ELSE
                v_convert_rate := tax.convert_rate;
                v_currency_cd := tax.currency_cd;
             END IF;

             gen_dpc_op_text_tax (v_tax_cd, v_tax_name, v_sub_tax_amt, v_currency_cd, v_convert_rate);
          END LOOP;
       END;
    END;
    
    PROCEDURE gen_dpc_op_text
    IS
       CURSOR c
       IS
          SELECT a.b140_iss_cd iss_cd, a.b140_prem_seq_no prem_seq_no, a.inst_no,
                 a.premium_amt, b.currency_cd, b.currency_rt
            FROM gipi_polbasic c, gipi_invoice b, giac_direct_prem_collns a
           WHERE a.b140_iss_cd = b.iss_cd
             AND a.b140_prem_seq_no = b.prem_seq_no
             AND b.iss_cd = c.iss_cd
             AND b.policy_id = c.policy_id
             AND gacc_tran_id = variables_tran_id;
    BEGIN
        BEGIN
          SELECT generation_type
            INTO variables_gen_type
            FROM giac_modules
           WHERE module_name = 'GIACS007';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error (-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
       END;
       
        DELETE giac_op_text
         WHERE gacc_tran_id = variables_tran_id
           AND item_gen_type = variables_gen_type;

        variables_n_seq_no := 3;
        variables_zero_prem_op_text := 'Y';
        
        FOR c_rec IN c
        LOOP
          gen_dpc_op_text_prem (c_rec.iss_cd, c_rec.prem_seq_no, c_rec.inst_no, c_rec.premium_amt, c_rec.currency_cd, c_rec.currency_rt);
        END LOOP;

       variables_zero_prem_op_text := 'N';

        DELETE giac_op_text
         WHERE gacc_tran_id = variables_tran_id
           AND NVL (item_amt, 0) = 0
           AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd FROM giac_taxes)
           AND SUBSTR (item_text, 1, 9) <> 'PREMIUM ('
           AND item_gen_type = variables_gen_type;

        UPDATE giac_op_text
           SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
         WHERE gacc_tran_id = variables_tran_id
           AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd FROM giac_taxes)
           AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
           AND item_gen_type = variables_gen_type;
    END;
    
        FUNCTION get_or_particulars (
       p_tran_id            giac_acctrans.tran_id%TYPE,
       p_acct_payable_amt   NUMBER,
       p_prem_dep_amt       NUMBER
    )
       RETURN VARCHAR2
    IS
       v_particulars           giac_order_of_payts.particulars%TYPE;
       v_or_particulars_text   giac_order_of_payts.particulars%TYPE
                                               := giacp.v ('OR_PARTICULARS_TEXT');
       v_or_text               VARCHAR2 (1)                := giacp.v ('OR_TEXT');
       v_policies              giac_order_of_payts.particulars%TYPE;
       v_policies_full         giac_order_of_payts.particulars%TYPE;
       v_policies_partial      giac_order_of_payts.particulars%TYPE;
       v_or_pol_limit          NUMBER     := giacp.n ('OR_POL_PARTICULARS_LIMIT');
       v_pol_ctr               NUMBER                                 := 0;
       v_full_partial_flag     VARCHAR2 (1);
    BEGIN
       FOR rec_a IN (
             SELECT gdpc.gacc_tran_id, gdpc.b140_iss_cd iss_cd,
                    gdpc.b140_prem_seq_no prem_seq_no,
                    SUM (gdpc.collection_amt) colln_amt,
                       RTRIM (gpol.line_cd)
                    || '-'
                    || RTRIM (gpol.subline_cd)
                    || '-'
                    || RTRIM (gpol.iss_cd)
                    || '-'
                    || LTRIM (TO_CHAR (gpol.issue_yy, '99'))
                    || '-'
                    || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                    || DECODE (gpol.endt_seq_no,
                               0, NULL,
                                  '-'
                               || gpol.endt_iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gpol.endt_seq_no, '099999'))
                               || ' '
                               || RTRIM (gpol.endt_type)
                              )
                    || '-'
                    || LTRIM (TO_CHAR (gpol.renew_no, '09')) policy_no
                FROM gipi_polbasic gpol, gipi_invoice ginv, giac_direct_prem_collns gdpc
               WHERE 1 = 1
                 AND gpol.policy_id = ginv.policy_id
                 AND gdpc.b140_iss_cd = ginv.iss_cd
                 AND gdpc.b140_prem_seq_no = ginv.prem_seq_no
                 AND gdpc.gacc_tran_id = p_tran_id
            GROUP BY gacc_tran_id,
                     b140_iss_cd,
                     b140_prem_seq_no,
                     gpol.line_cd,
                     gpol.subline_cd,
                     gpol.iss_cd,
                     gpol.issue_yy,
                     gpol.pol_seq_no,
                     gpol.renew_no,
                     gpol.endt_seq_no,
                        RTRIM (gpol.line_cd)
                     || '-'
                     || RTRIM (gpol.subline_cd)
                     || '-'
                     || RTRIM (gpol.iss_cd)
                     || '-'
                     || LTRIM (TO_CHAR (gpol.issue_yy, '99'))
                     || '-'
                     || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                     || DECODE (gpol.endt_seq_no,
                                0, NULL,
                                   '-'
                                || gpol.endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (gpol.endt_seq_no, '099999'))
                                || ' '
                                || RTRIM (gpol.endt_type)
                               )
                     || '-'
                     || LTRIM (TO_CHAR (gpol.renew_no, '09'))
            ORDER BY gpol.line_cd,
                     gpol.subline_cd,
                     gpol.iss_cd,
                     gpol.issue_yy,
                     gpol.pol_seq_no,
                     gpol.renew_no,
                     gpol.endt_seq_no
       )
       LOOP
          v_pol_ctr := v_pol_ctr + 1;

          IF v_pol_ctr > v_or_pol_limit THEN
             EXIT;
          END IF;

          IF NVL (v_or_text, 'N') = 'N' THEN
             IF NVL (giacp.v ('PREM_COLLN_PARTICULARS'), 'PN') = 'PB'
             THEN
                v_policies :=
                      v_policies
                   || rec_a.policy_no
                   || '/'
                   || rec_a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (rec_a.prem_seq_no, '99999999'))
                   || ', ';
             ELSE
                v_policies := v_policies || rec_a.policy_no || '/';
             END IF;
          ELSE
             IF NVL (giacp.v ('PREM_COLLN_PARTICULARS'), 'PN') = 'PB' THEN
                v_policies_full :=
                      v_policies_full
                   || rec_a.policy_no
                   || '/'
                   || rec_a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (rec_a.prem_seq_no, '99999999'))
                   || ', ';
             ELSE
                v_policies_full := v_policies_full || rec_a.policy_no || '/';
             END IF;
          END IF;
       END LOOP rec_a;

       IF v_pol_ctr > v_or_pol_limit
       THEN
          v_particulars := 'Representing payment of premium and taxes for various policies.';
       ELSIF v_pol_ctr BETWEEN 1 AND v_or_pol_limit
       THEN
          IF NVL (v_or_text, 'N') = 'N' THEN
             v_particulars := SUBSTR (v_policies, 1, LENGTH (RTRIM (v_policies)) - 1);
          ELSE
             v_particulars := giacp.v ('OR_PARTICULARS_TEXT') || ' ' || v_policies_full;
          END IF;
       ELSE                                                       
          IF p_prem_dep_amt <> 0 THEN
             v_particulars := 'Premium Deposit';
          ELSE
             v_particulars := 'Accounts Payable';
          END IF;
       END IF;

       RETURN (v_particulars);
    END;
    
    FUNCTION get_payment_details (
       p_line_cd      giac_upload_prem.line_cd%TYPE,
       p_subline_cd   giac_upload_prem.subline_cd%TYPE,
       p_iss_cd       giac_upload_prem.iss_cd%TYPE,
       p_issue_yy     giac_upload_prem.issue_yy%TYPE,
       p_pol_seq_no   giac_upload_prem.pol_seq_no%TYPE,
       p_renew_no     giac_upload_prem.renew_no%TYPE,
       p_payor        giac_upload_prem.payor%TYPE
    )
       RETURN VARCHAR2
    IS
       v_mean_check_class   VARCHAR2 (20)  := 'UNKNOWN CHECK CLASS';
       v_payment_details    VARCHAR2 (500);
       v_dummy_payt_dtl     VARCHAR2 (100);
    BEGIN
       FOR rec IN (
            SELECT pay_mode, check_class, check_no, check_date, bank
              FROM giac_upload_prem_dtl
             WHERE source_cd = variables_source_cd
               AND file_no = variables_file_no
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND iss_cd = NVL (p_iss_cd, iss_cd)
               AND issue_yy = NVL (p_issue_yy, issue_yy)
               AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
               AND renew_no = NVL (p_renew_no, renew_no)
               AND payor = p_payor
       )
       LOOP
          IF rec.pay_mode = 'CA' THEN
             v_dummy_payt_dtl := rec.pay_mode || '; ';
          ELSIF rec.pay_mode = 'CC' THEN
             v_dummy_payt_dtl := rec.pay_mode || ', ' || rec.bank || ', ' || rec.check_no || '; ';
          ELSIF rec.pay_mode = 'CHK' THEN
             BEGIN
                SELECT UPPER (rv_meaning)
                  INTO v_mean_check_class
                  FROM cg_ref_codes
                 WHERE rv_domain LIKE 'GIAC_COLLECTION_DTL.CHECK_CLASS'
                   AND rv_low_value = rec.check_class;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
             END;

             v_dummy_payt_dtl :=
                   rec.pay_mode
                || ', '
                || rec.bank
                || ', '
                || v_mean_check_class
                || ', '
                || rec.check_no
                || ', '
                || TO_CHAR (rec.check_date, 'MM/DD/RRRR')
                || '; ';
          ELSIF rec.pay_mode = 'CM' THEN
                SELECT rec.pay_mode
                       || ', '
                       || rec.bank
                       || DECODE (rec.check_no, NULL, NULL, ', ' || rec.check_no)
                       || DECODE (TO_CHAR (rec.check_date, 'MM/DD/RRRR'),
                                  NULL, NULL,
                                  ', ' || TO_CHAR (rec.check_date, 'MM/DD/RRRR')
                                 )
                       || '; '
                  INTO v_dummy_payt_dtl
                  FROM DUAL;
          END IF;

          IF LENGTH (v_payment_details || v_dummy_payt_dtl) <= 500 THEN
             v_payment_details := REPLACE (v_payment_details, v_dummy_payt_dtl, NULL) || v_dummy_payt_dtl;
          ELSE
             EXIT;
          END IF;
       END LOOP;

       RETURN (v_payment_details);
    END;
   
   PROCEDURE process_payments (
       p_payor         giac_order_of_payts.payor%TYPE,
       p_bank_ref_no   giac_upload_prem_refno.bank_ref_no%TYPE,
       p_check_flag    giac_upload_prem_refno.prem_chk_flag%TYPE,
       p_rec_id        giac_upload_prem_refno.rec_id%TYPE 
    )
    IS
        v_rowcount              NUMBER;
        v_bank_ref_no           giac_upload_prem_refno.bank_ref_no%TYPE;
        v_line_cd               gipi_polbasic.line_cd%TYPE;
        v_subline_cd            gipi_polbasic.subline_cd%TYPE;
        v_iss_cd                gipi_polbasic.iss_cd%TYPE;
        v_issue_yy              gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no              gipi_polbasic.renew_no%TYPE;
        v_payor                 giac_order_of_payts.payor%TYPE;
        v_payment_details       VARCHAR2 (500);
        v_prem_chk_flag         giac_upload_prem_refno.prem_chk_flag%TYPE;
        v_collection_amt        giac_upload_prem_refno.collection_amt%TYPE;
        v_prem_amt_due          giac_upload_prem_refno.prem_amt_due%TYPE;
        v_comm_amt_due          giac_upload_prem_refno.comm_amt_due%TYPE;
        v_net_prem_amt          giac_upload_prem_refno.net_prem_amt%TYPE;
        v_net_comm_amt          giac_upload_prem_refno.net_comm_amt%TYPE;
        v_net_amt_due           giac_upload_prem_refno.prem_amt_due%TYPE;
        v_op_amt                giac_upload_prem_refno.prem_amt_due%TYPE;
        v_acct_payable_min      NUMBER            := giacp.n ('ACCTS_PAYABLE_MIN');
        v_premcol_exp_max       NUMBER              := giacp.n ('PREMCOL_EXP_MAX');
        v_sl_cd                 giac_acct_entries.sl_cd%TYPE               := NULL;
        v_aeg_item_no           giac_module_entries.item_no%TYPE             := 2;
        v_prem_dep_amt          giac_upload_prem.collection_amt%TYPE         := 0;
        v_acct_payable_amt      giac_upload_prem.collection_amt%TYPE         := 0;
        v_other_income_amt      giac_upload_prem.collection_amt%TYPE         := 0;
        v_other_expense_amt     giac_upload_prem.collection_amt%TYPE         := 0;
        v_dummy_expense_amt     giac_upload_prem.collection_amt%TYPE;
        v_rem_colln_amt         giac_upload_prem.collection_amt%TYPE;
        v_dummy_prem_chk_flag   giac_upload_prem.prem_chk_flag%TYPE;
        v_ctr                   NUMBER                                       := 1;
        v_policy_ctr            NUMBER                                       := 0;
        v_assd_no               NUMBER;
        v_intm_no               giac_order_of_payts.intm_no%TYPE;
        v_particulars           giac_order_of_payts.particulars%TYPE        := '-';
        v_op_rt                 NUMBER                                       := 0;
        v_tot_netcomm           giac_comm_payts.comm_amt%TYPE;
        v_comm_amt              giac_comm_payts.comm_amt%TYPE;
        v_whtax_amt             giac_comm_payts.wtax_amt%TYPE;
        v_new_whtax_amt         giac_comm_payts.wtax_amt%TYPE;
        v_invat_amt             giac_comm_payts.input_vat_amt%TYPE;
        v_new_invat_amt         giac_comm_payts.input_vat_amt%TYPE;
        v_rem_comm_amt          giac_comm_payts.comm_amt%TYPE;
        v_rem_whtax_amt         giac_comm_payts.wtax_amt%TYPE;
        v_rem_invat_amt         giac_comm_payts.input_vat_amt%TYPE;
        v_pay_rcv_intm_amt      giac_upload_prem_comm.comm_amt%TYPE          := 0;
        v_rec_id                giac_upload_prem_refno.rec_id%TYPE;
        v_count                 NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT *
              FROM giac_upload_prem_refno
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no
               AND DECODE (variables_process_all, 'N', upload_sw, 1) = --Deo [10.06.2016]: added condition
                                  DECODE (variables_process_all,
                                          'N', 'T',
                                          1
                                         )
        )
        LOOP
            v_count := v_count + 1;
            v_payor := i.payor;
            v_bank_ref_no := i.bank_ref_no;
            v_rec_id := i.rec_id;

          /*IF p_payor = v_payor AND p_bank_ref_no = v_bank_ref_no AND p_rec_id = v_rec_id THEN                                                     
             v_ctr := v_count;
             EXIT;
          END IF;*/ --Deo [10.06.2016]: comment out
        
        
           IF p_payor = v_payor AND p_bank_ref_no = v_bank_ref_no AND p_rec_id = v_rec_id   THEN                                                      
              v_collection_amt := i.collection_amt;
              v_prem_amt_due := i.prem_amt_due;
              v_comm_amt_due := i.comm_amt_due;
              v_net_prem_amt := i.net_prem_amt;
              v_net_comm_amt := i.net_comm_amt;
              v_prem_chk_flag := i.prem_chk_flag;
              v_net_amt_due := NVL (v_net_prem_amt, 0) - NVL (v_net_comm_amt, 0);
              v_rec_id := i.rec_id;

              IF v_prem_chk_flag IN ('OP', 'OC') THEN
                 v_op_amt := NVL (v_collection_amt, 0) - NVL (v_net_amt_due, 0);
              ELSIF v_prem_chk_flag IN ('PG', 'CG') THEN                                          
                 v_op_amt := v_net_comm_amt - (v_collection_amt - (v_prem_amt_due - v_comm_amt_due));
              ELSE
                 v_op_amt := 0;
              END IF;

              BEGIN
                 SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy,
                                 pol_seq_no, renew_no
                   INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy,
                        v_pol_seq_no, v_renew_no
                   FROM gipi_polbasic
                  WHERE bank_ref_no = v_bank_ref_no;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    NULL;
              END;

              IF p_check_flag IN ('SP', 'RI', 'EX', 'NA', 'NE', 'NG', 'FP', 'FC', 'CP', 'SL') THEN                                                  
                 v_prem_dep_amt := v_prem_dep_amt + v_collection_amt;
                 insert_prem_deposit (v_prem_dep_amt);
                 upload_dpc_web.aeg_parameters_pdep (variables_tran_id, 'GIACS610', variables_user_id);
                 upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, ABS (v_collection_amt), v_sl_cd, variables_user_id);
                 v_acct_payable_amt := v_acct_payable_amt + v_collection_amt;
                 gen_prem_dep_op_text;
              ELSE                                                
                 IF v_net_amt_due < 0 AND v_prem_chk_flag IN ('OP', 'OC') THEN
                    IF v_collection_amt >= v_acct_payable_min THEN
                       v_acct_payable_amt := v_acct_payable_amt + v_collection_amt;
                       insert_prem_deposit (v_collection_amt);  --Deo [10.06.2016]: insert prem deposit record
                       v_aeg_item_no := 3;                      --Deo [10.06.2016]: prem deposit gl account
                    ELSE
                       v_other_income_amt := v_other_income_amt + v_collection_amt;
                       v_collection_amt := v_collection_amt * -1;  --Deo [10.06.2016]: convert amount
                       v_aeg_item_no := 4;                         --Deo [10.06.2016]: other exp/inc gl account
                    END IF;

                    --Deo [10.06.2016]: added codes below, insert acctg entry and or preview record
                    IF sl_type_cd_not_null ('GIACS610', v_aeg_item_no)
                    THEN
                       v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                    ELSE
                       v_sl_cd := NULL;
                    END IF;

                    gen_prem_dep_op_text;
                    upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                        'GIACS610',
                                                        v_aeg_item_no,
                                                        v_collection_amt,
                                                        v_sl_cd,
                                                        variables_user_id
                                                       );
                    v_aeg_item_no := 2;
                    v_sl_cd := NULL;
                    --Deo [10.06.2016]: add ends
            
                    upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, ABS (v_collection_amt), v_sl_cd, variables_user_id);
                 ELSIF p_check_flag IN ('OK', 'VN', 'WC', 'OP', 'OC', 'PT', 'PC', 'VC') THEN                               
                    v_dummy_prem_chk_flag := v_prem_chk_flag;
                    v_dummy_expense_amt := 0;

                    IF p_check_flag IN ('OK', 'WC', 'VN', 'VC') THEN
                       upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, ABS (v_collection_amt), v_sl_cd, variables_user_id);
                    END IF;

                    IF p_check_flag IN ('PT', 'PC')
                       AND (v_prem_amt_due - v_collection_amt <= v_premcol_exp_max)
                    THEN
                       upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, ABS (v_collection_amt), v_sl_cd, variables_user_id);
                       v_dummy_prem_chk_flag := 'OK';
                       v_dummy_expense_amt := v_prem_amt_due - v_collection_amt;
                       v_aeg_item_no := 4;


                       IF sl_type_cd_not_null ('GIACS610', v_aeg_item_no) THEN
                          v_sl_cd := giacp.n ('OTHER_EXPENSE_SL');
                       ELSE
                          v_sl_cd := NULL;
                       END IF;

                       upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, v_dummy_expense_amt, v_sl_cd, variables_user_id);
                       v_other_expense_amt := v_other_expense_amt + v_dummy_expense_amt;
                    ELSIF p_check_flag IN ('PT', 'PC') AND NOT (v_prem_amt_due - v_collection_amt <= v_premcol_exp_max) THEN                                            
                       upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, ABS (v_collection_amt), v_sl_cd, variables_user_id);
                    END IF;

                    insert_premium_collns (v_bank_ref_no,
                                           v_line_cd,
                                           v_subline_cd,
                                           v_iss_cd,
                                           v_issue_yy,
                                           v_pol_seq_no,
                                           v_renew_no,
                                           v_prem_amt_due,
                                           v_collection_amt + v_dummy_expense_amt,
                                           v_net_amt_due,
                                           p_check_flag,
                                           v_rem_colln_amt
                                          );

                    IF v_prem_chk_flag IN ('OP', 'OC') THEN                                 
                       IF v_rem_colln_amt > v_acct_payable_min THEN
                          v_acct_payable_amt := v_acct_payable_amt + v_rem_colln_amt;
                          insert_prem_deposit (v_rem_colln_amt);
                          v_aeg_item_no := 3;
                       ELSE
                          v_other_income_amt := v_other_income_amt + v_rem_colln_amt;
                          v_aeg_item_no := 4;
                          v_rem_colln_amt := v_rem_colln_amt * -1; 
                       END IF;

                       IF sl_type_cd_not_null ('GIACS610', v_aeg_item_no) THEN
                          v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                       ELSE
                          v_sl_cd := NULL;
                       END IF;

                       upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, v_rem_colln_amt, v_sl_cd, variables_user_id);
                       gen_prem_dep_op_text;
                       v_sl_cd := NULL;
                       v_aeg_item_no := 2;
                       upload_dpc_web.aeg_parameters_misc (variables_tran_id, 'GIACS610', v_aeg_item_no, ABS (v_collection_amt), v_sl_cd, variables_user_id);
                       gen_prem_dep_op_text;
                    END IF;
                 END IF;

                 v_policy_ctr := v_policy_ctr + 1;

                 IF v_policy_ctr = 1 THEN
                    FOR addr IN (
                        SELECT   address1 add1, address2 add2, address3 add3
                            FROM gipi_polbasic
                           WHERE address1 IS NOT NULL
                             AND line_cd = v_line_cd
                             AND subline_cd = v_subline_cd
                             AND iss_cd = v_iss_cd
                             AND issue_yy = v_issue_yy
                             AND pol_seq_no = v_pol_seq_no
                             AND renew_no = v_renew_no
                        ORDER BY endt_seq_no DESC
                    )
                    LOOP
                       UPDATE giac_order_of_payts
                          SET address_1 = addr.add1,
                              address_2 = addr.add2,
                              address_3 = addr.add3
                        WHERE gacc_tran_id = variables_tran_id;

                       EXIT;
                    END LOOP addr;

                    --v_assd_no := get_pol_assd_no (v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no); --Deo [10.06.2016]: comment out

                    FOR tin_rec IN (
                        SELECT assd_tin
                          FROM giis_assured
                         WHERE assd_tin IS NOT NULL 
                           AND assd_no = /*v_assd_no*/ variables_assd_no --Deo [10.06.2016]: replace assd source
                    )
                    LOOP
                       UPDATE giac_order_of_payts
                          SET tin = tin_rec.assd_tin
                        WHERE gacc_tran_id = variables_tran_id;

                       EXIT;
                    END LOOP;
                 ELSIF v_policy_ctr = 2 THEN
                    UPDATE giac_order_of_payts
                       SET address_1 = NULL,
                           address_2 = NULL,
                           address_3 = NULL
                     WHERE gacc_tran_id = variables_tran_id;
                 END IF;
              END IF;             

              IF p_check_flag IN ('VN', 'VC') THEN
                 FOR k IN (
                       SELECT gppc.policy_id, gppc.intm_no,
                             SUM (gppc.commission_due/* * gppc.commission_rt*/) comm_amt, --Deo [10.06.2016]: removed multiply by comm rate
                             SUM (gppc.wholding_tax_due) whtax_amt,
                             SUM (gppc.input_vat_due) invat_amt
                        FROM giac_paid_prem_comm_due_v gppc
                       WHERE gppc.bank_ref_no = v_bank_ref_no
                    GROUP BY gppc.intm_no, gppc.policy_id
                 )
                 LOOP
                    IF v_prem_chk_flag IN ('PG', 'CG') THEN                                  
                       SELECT   SUM (gppc.commission_due/* * gppc.commission_rt*/) --Deo [10.06.2016]: removed multiply by comm rate
                              + SUM (gppc.input_vat_due)
                              - SUM (gppc.wholding_tax_due)
                         INTO v_tot_netcomm
                         FROM giac_paid_prem_comm_due_v gppc
                        WHERE gppc.bank_ref_no = v_bank_ref_no;

                       v_op_rt := v_op_amt / v_tot_netcomm;
                       v_comm_amt := k.comm_amt * v_op_rt;
                       v_invat_amt := k.invat_amt * v_op_rt;
                       v_whtax_amt := k.whtax_amt * v_op_rt;
                    ELSE
                       v_comm_amt := k.comm_amt;
                       v_whtax_amt := k.whtax_amt;
                       v_invat_amt := k.invat_amt;
                    END IF;

                    variables_parent_intm_no := get_parent_intm_no (k.intm_no);

                    IF p_check_flag IN ('VN', 'VC') OR v_op_rt <> 0
                    THEN                                           
                       insert_comm_payts (v_prem_chk_flag,
                                          k.policy_id,
                                          k.intm_no,
                                          v_comm_amt,
                                          v_whtax_amt,
                                          v_invat_amt,
                                          v_rem_comm_amt,
                                          v_rem_whtax_amt,
                                          v_rem_invat_amt
                                         );
                    END IF;

                    IF v_rem_whtax_amt > 0
                    THEN
                       v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_whtax_amt
                                                                  * -1;
                    ELSIF v_rem_whtax_amt < 0
                    THEN
                       v_pay_rcv_intm_amt :=
                                           v_pay_rcv_intm_amt + ABS (v_rem_whtax_amt);
                    END IF;

                    IF v_rem_invat_amt > 0
                    THEN
                       v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_invat_amt;
                    ELSIF v_rem_invat_amt < 0
                    THEN
                       v_pay_rcv_intm_amt := v_pay_rcv_intm_amt + v_rem_invat_amt;
                    END IF;
                 END LOOP k;

                 upload_dpc_web.aeg_parameters_comm (variables_tran_id,
                                                 'GIACS020',
                                                 variables_sl_type_cd1,
                                                 variables_sl_type_cd2,
                                                 variables_sl_type_cd3,
                                                 variables_user_id
                                                );
              END IF;            

              upload_dpc_web.gen_dpc_acct_entries (variables_tran_id, 'GIACS007', variables_user_id);
              gen_dpc_op_text;

              IF variables_max_colln_amt <> 0 THEN
                 BEGIN
                    SELECT intrmdry_intm_no
                      INTO v_intm_no
                      FROM gipi_comm_invoice
                     WHERE prem_seq_no = variables_max_prem_seq_no
                       AND iss_cd = variables_max_iss_cd;
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       v_intm_no := NULL;
                 END;
              END IF;

              v_particulars := get_or_particulars (variables_tran_id, v_acct_payable_amt, v_prem_dep_amt);

              UPDATE giac_order_of_payts
                 SET particulars = v_particulars,
                     intm_no = v_intm_no
               WHERE gacc_tran_id = variables_tran_id;

              v_payment_details := get_payment_details (NULL, NULL, NULL, NULL, NULL, NULL, p_payor);

              UPDATE giac_collection_dtl
                 SET particulars = v_payment_details
               WHERE gacc_tran_id = variables_tran_id 
                 AND item_no = 1;
           END IF; 
        END LOOP; 
    END;
   
   PROCEDURE gen_multiple_or
   IS
        the_rowcount           NUMBER;
        v_bank_ref_no          giac_upload_prem_refno.bank_ref_no%TYPE;
        v_prem_chk_flag        giac_upload_prem_refno.prem_chk_flag%TYPE;
        --acctrans
        v_tran_flag            giac_acctrans.tran_flag%TYPE;
        v_tran_class           giac_acctrans.tran_class%TYPE;
        v_tran_class_no        giac_acctrans.tran_class_no%TYPE;
        v_tran_year            giac_acctrans.tran_year%TYPE;
        v_tran_month           giac_acctrans.tran_month%TYPE;
        v_tran_seq_no          giac_acctrans.tran_seq_no%TYPE;
        --order of payts
        v_cashier_cd           giac_order_of_payts.cashier_cd%TYPE;
        v_particulars          giac_order_of_payts.particulars%TYPE;
        v_or_colln_amt         giac_order_of_payts.collection_amt%TYPE;
        --collection dtl
        v_or_prem_amt          giac_collection_dtl.gross_amt%TYPE;
        v_or_comm_amt          giac_collection_dtl.commission_amt%TYPE;
        v_gross                giac_collection_dtl.gross_amt%TYPE;
        v_fc_gross             giac_collection_dtl.fc_gross_amt%TYPE;
        v_currency_cd          giac_collection_dtl.currency_cd%TYPE;
        v_currency_rt          giac_collection_dtl.currency_rt%TYPE;
        v_bank_cd              giac_collection_dtl.bank_cd%TYPE;
        v_pay_mode             giac_collection_dtl.pay_mode%TYPE;
        v_fc_amt               giac_collection_dtl.fcurrency_amt%TYPE;
        v_utility_tag          giac_file_source.utility_tag%TYPE;
        v_bank_sname           giac_banks.bank_sname%TYPE;
        v_uploaded             NUMBER;
        v_totalrec             NUMBER;
        v_complete_sw          VARCHAR2 (1);
        v_assured_name         giis_assured.assd_name%TYPE;
        v_rec_id               giac_upload_prem_refno.rec_id%TYPE;
        v_check_flag           giac_upload_prem_refno.prem_chk_flag%TYPE;
        v_counter              NUMBER                                      := 0;
        v_max_endt_seq_no      gipi_wpolbas.endt_seq_no%TYPE;
        v_max_endt_seq_no1     gipi_wpolbas.endt_seq_no%TYPE;
        v_endt_seq_no3         gipi_wpolbas.endt_seq_no%TYPE;
        v_endt_seq_no4         gipi_wpolbas.endt_seq_no%TYPE;
        v_latest_endt_seq_no   gipi_wpolbas.endt_seq_no%TYPE;
        v_max_eff_date         gipi_wpolbas.eff_date%TYPE;
        v_max_eff_date1        gipi_wpolbas.eff_date%TYPE;
        v_max_eff_date2        gipi_wpolbas.eff_date%TYPE;
        
        nbt_or_date            DATE;
        guf                    GIAC_UPLOAD_FILE%ROWTYPE;
   BEGIN
        SELECT *
          INTO guf
          FROM giac_upload_file
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
          
   
        SELECT COUNT(*)
          INTO the_rowcount
          FROM giac_upload_prem_refno
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
           
        IF the_rowcount = 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#E#No records found for upload.');
        END IF;
        
        variables_upload_no := generate_upload_no; --Deo [10.06.2016]: execute function to generate upload_no
        
        FOR i IN (
            SELECT *
              FROM giac_upload_prem_refno
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no
               AND DECODE (variables_process_all, 'N', upload_sw, 1) = --Deo [10.06.2016]: added condition
                                  DECODE (variables_process_all,
                                          'N', 'T',
                                          1
                                         )
        )
        LOOP
            v_bank_ref_no   := i.bank_ref_no;
            v_prem_chk_flag := i.prem_chk_flag;
            v_rec_id        := i.rec_id;
            
            FOR a IN (
                SELECT cashier_cd
                  FROM giac_dcb_users
                 WHERE dcb_user_id = /*USER*/variables_user_id --Deo [10.06.2016]: replace user_id source
                   AND gibr_fund_cd = variables_fund_cd
                   AND gibr_branch_cd = variables_branch_cd
             )
             LOOP
                v_cashier_cd := a.cashier_cd;
                EXIT;
             END LOOP;
             
             FOR i IN (
                SELECT utility_tag
                  FROM giac_file_source
                 WHERE source_cd = variables_source_cd
             )
             LOOP
                v_utility_tag := i.utility_tag;
                EXIT;
             END LOOP; 
             
             BEGIN
               --check_data_giacs610(variables_source_cd, variables_file_no, variables_user_id); --Deo [10.06.2016]: comment out
                check_data_giacs610 (variables_source_cd, variables_file_no, variables_user_id, v_rec_id, v_check_flag); --Deo [10.06.2016]
             END;
             
             v_utility_tag := NVL (v_utility_tag, 'N');
             v_bank_cd := giacp.v ('CM_UTILITY_ACCT');
             
             IF v_bank_cd IS NULL THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Parameter CM_UTILITY_ACCT is not defined in table GIAC_PARAMETERS.');
             END IF;
             
             v_tran_flag := 'O';
             v_tran_class := 'COL';
             v_tran_class_no := variables_dcb_no;
             v_pay_mode := 'CM';
             
             FOR rec_a IN (
                  SELECT payor, SUM (collection_amt) or_colln_amt, SUM (prem_amt_due) v_prem,
                         SUM (comm_amt_due) v_comm, SUM (net_prem_amt) or_prem_amt,
                         SUM (net_comm_amt) or_comm_amt, 1 currency_cd, 1 convert_rate
                    FROM giac_upload_prem_refno
                   WHERE source_cd = variables_source_cd
                     AND file_no = variables_file_no
                     AND bank_ref_no = v_bank_ref_no
                     AND rec_id = v_rec_id
                GROUP BY payor, bank_ref_no
             )
             LOOP
                v_currency_cd := rec_a.currency_cd;
                v_currency_rt := rec_a.convert_rate;
                v_fc_amt := rec_a.or_colln_amt;
                v_or_colln_amt := v_fc_amt * v_currency_rt;
                v_or_prem_amt := rec_a.or_prem_amt * v_currency_rt;
                v_or_comm_amt := rec_a.or_comm_amt * v_currency_rt;
                
                IF v_check_flag IN ('FP', 'FC', 'EX', 'RI', 'SP', 'CP', 'SL', 'NE', 'NG', 'NA', 'OP', 'OC') THEN
                   v_fc_gross := v_fc_amt + rec_a.or_comm_amt;
                ELSIF v_check_flag IN ('OK', 'WC') THEN
                   v_fc_gross := rec_a.or_colln_amt;
                ELSIF v_check_flag IN ('PG', 'CG')  THEN
                   v_fc_gross := rec_a.or_colln_amt - rec_a.v_prem + rec_a.v_comm + rec_a.or_prem_amt;
                ELSE
                   v_fc_gross := rec_a.or_prem_amt;
                END IF;
                
                v_gross := v_fc_gross * v_currency_rt;
                v_particulars := '-';
                variables_max_colln_amt := 0;
                variables_max_iss_cd := NULL;
                variables_max_prem_seq_no := NULL;
                
                SELECT acctran_tran_id_s.NEXTVAL
                  INTO variables_tran_id
                  FROM SYS.DUAL;
                
                nbt_or_date := NVL (variables_v_date, SYSDATE);
                variables_tran_date := TO_DATE (   TO_CHAR (nbt_or_date, 'MM-DD-YYYY') || ' ' || TO_CHAR (SYSDATE, 'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
                v_tran_year := TO_NUMBER (TO_CHAR (nbt_or_date, 'YYYY'));
                v_tran_month := TO_NUMBER (TO_CHAR (nbt_or_date, 'MM'));
                v_tran_seq_no := giac_sequence_generation (variables_fund_cd, variables_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
                
                IF /*v_prem_chk_flag*/ v_check_flag NOT IN ('NE', 'NG') THEN --Deo [10.06.2016]: replace v_prem_chk_flag with v_check_flag
                   FOR w IN (
                        SELECT MAX (endt_seq_no) endt_seq_no
                          FROM gipi_polbasic
                         WHERE bank_ref_no = v_bank_ref_no 
                           --AND pol_flag IN ('1', '2', '3', 'X') --Deo [10.06.2016]: comment out to include cancelled and spoiled
                   )
                   LOOP
                      v_max_endt_seq_no := w.endt_seq_no;
                      EXIT;
                   END LOOP;

                   IF v_max_endt_seq_no > 0 THEN
                      FOR g IN (
                            SELECT MAX (endt_seq_no) endt_seq_no
                              FROM gipi_polbasic
                             WHERE bank_ref_no = v_bank_ref_no
                               --AND pol_flag IN ('1', '2', '3', 'X') --Deo [10.06.2016]: comment out to include cancelled and spoiled
                               AND NVL (back_stat, 5) = 2
                      )
                      LOOP
                         v_max_endt_seq_no1 := g.endt_seq_no;
                         EXIT;
                      END LOOP;

                      IF v_max_endt_seq_no != NVL (v_max_endt_seq_no1, -1) THEN
                         FOR z IN (
                            SELECT MAX (eff_date) eff_date
                              FROM gipi_polbasic
                             WHERE bank_ref_no = v_bank_ref_no
                               --AND pol_flag IN ('1', '2', '3', 'X') --Deo [10.06.2016]: comment out to include cancelled and spoiled
                               AND NVL (back_stat, 5) = 2
                               AND endt_seq_no = v_max_endt_seq_no1
                         )
                         LOOP
                            v_max_eff_date1 := z.eff_date;
                            v_endt_seq_no3 := v_max_endt_seq_no1;
                            EXIT;
                         END LOOP;

                         FOR y IN (
                            SELECT MAX (eff_date) eff_date
                              FROM gipi_polbasic
                             WHERE bank_ref_no = v_bank_ref_no
                               --AND pol_flag IN ('1', '2', '3', 'X') --Deo [10.06.2016]: comment out to include cancelled and spoiled
                               AND endt_seq_no != 0
                               AND NVL (back_stat, 5) != 2
                         )
                         LOOP
                            SELECT MAX (endt_seq_no)
                              INTO v_endt_seq_no4
                              FROM gipi_polbasic a
                             WHERE bank_ref_no = v_bank_ref_no
                               --AND pol_flag IN ('1', '2', '3', 'X') --Deo [10.06.2016]: comment out to include cancelled and spoiled
                               AND endt_seq_no != 0
                               AND NVL (back_stat, 5) != 2
                               AND eff_date = y.eff_date;

                            v_max_eff_date2 := y.eff_date;
                            EXIT;
                         END LOOP;

                         v_max_eff_date := NVL (v_max_eff_date2, v_max_eff_date1);
                         v_latest_endt_seq_no := NVL (v_endt_seq_no4, v_endt_seq_no3);
                      ELSE               
                         FOR c IN (
                            SELECT MAX (eff_date) eff_date
                              FROM gipi_polbasic
                             WHERE bank_ref_no = v_bank_ref_no
                               --AND pol_flag IN ('1', '2', '3', 'X') --Deo [10.06.2016]: comment out to include cancelled and spoiled
                               AND NVL (back_stat, 5) = 2
                               AND endt_seq_no = v_max_endt_seq_no1
                                      )
                         LOOP
                            v_max_eff_date1 := c.eff_date;
                            EXIT;
                         END LOOP;

                         v_max_eff_date := v_max_eff_date1;
                         v_latest_endt_seq_no := v_max_endt_seq_no1;
                      END IF;

                         SELECT DISTINCT assd_name, b.assd_no --Deo [10.06.2016]: added assd_no
                           INTO v_assured_name, variables_assd_no --Deo [10.06.2016]: added variables_assd_no
                           FROM gipi_polbasic a, giis_assured b
                          WHERE a.assd_no = b.assd_no
                            AND bank_ref_no = v_bank_ref_no
                            AND a.endt_seq_no = v_latest_endt_seq_no
                            AND eff_date = v_max_eff_date;
                            --AND pol_flag IN ('1', '2', '3', 'X'); --Deo [10.06.2016]: comment out to include cancelled and spoiled
                   ELSE                                          
                      SELECT DISTINCT assd_name, b.assd_no --Deo [10.06.2016]: added assd_no
                                 INTO v_assured_name, variables_assd_no --Deo [10.06.2016]: added variables_assd_no
                                 FROM gipi_polbasic a, giis_assured b
                                WHERE a.assd_no = b.assd_no
                                  AND bank_ref_no = v_bank_ref_no
                                  AND a.endt_seq_no = 0;
                   END IF;
                ELSE
                   v_assured_name := rec_a.payor;
                END IF;
                
                INSERT INTO giac_acctrans
                            (tran_id, gfun_fund_cd, gibr_branch_cd,
                             tran_date, tran_flag, tran_year, tran_month,
                             tran_seq_no, tran_class, tran_class_no, user_id, last_update
                            )
                     VALUES (variables_tran_id, variables_fund_cd, variables_branch_cd,
                             variables_tran_date, v_tran_flag, v_tran_year, v_tran_month,
                             v_tran_seq_no, v_tran_class, v_tran_class_no, variables_user_id, SYSDATE
                            );

                INSERT INTO giac_order_of_payts
                            (gacc_tran_id, gibr_gfun_fund_cd,
                             gibr_branch_cd, payor,
                             or_date, cashier_cd, dcb_no,
                             or_flag, particulars, collection_amt, currency_cd,
                             gross_amt, gross_tag, upload_tag, user_id,
                             last_update
                            )
                     VALUES (variables_tran_id, variables_fund_cd,
                             variables_branch_cd, v_assured_name,
                             variables_tran_date, v_cashier_cd, variables_dcb_no,
                             'N', v_particulars, v_or_colln_amt, v_currency_cd,
                             v_gross, 'Y', 'Y', /*USER*/variables_user_id, --Deo [10.06.2016]: replace user_id source
                             SYSDATE
                            );

                INSERT INTO giac_collection_dtl
                            (gacc_tran_id, item_no, currency_cd, currency_rt,
                             pay_mode, amount, particulars, bank_cd,
                             fcurrency_amt, gross_amt, commission_amt,
                             fc_gross_amt, fc_comm_amt, due_dcb_no,
                             due_dcb_date, user_id, last_update,
                             check_date, dcb_bank_cd,
                             dcb_bank_acct_cd, check_class, check_no
                            )
                     VALUES (variables_tran_id, 1, v_currency_cd, v_currency_rt,
                             v_pay_mode, v_fc_amt, NULL, v_bank_cd,
                             v_or_colln_amt, v_gross, v_or_comm_amt,
                             v_fc_gross, rec_a.or_comm_amt, variables_dcb_no,
                             TRUNC (variables_tran_date), variables_user_id, SYSDATE,
                             guf.payment_date, variables_dcb_bank_cd,
                             variables_dcb_bank_acct_cd, NULL, NULL
                            );
                            
                process_payments (rec_a.payor, v_bank_ref_no, v_check_flag, v_rec_id);

                UPDATE giac_upload_prem_refno
                   SET tran_id = variables_tran_id,
                       tran_date = variables_tran_date,
                       upload_sw = 'Y',
                       upload_date = SYSDATE,
                       upload_no = variables_upload_no
                 WHERE source_cd = variables_source_cd
                   AND file_no = variables_file_no
                   AND bank_ref_no = v_bank_ref_no
                   AND rec_id = v_rec_id;    
                   
                   v_counter := v_counter + 1;
                
             END LOOP; --rec_a
             
             IF NVL (giacp.v ('AUTO_CLOSE_UPLOAD_OR'), 'N') = 'Y' THEN
                UPDATE giac_acctrans
                   SET tran_flag = 'C'
                 WHERE tran_id = variables_tran_id;
             ELSE
                UPDATE giac_acctrans
                   SET tran_flag = 'O'
                 WHERE tran_id = variables_tran_id;
             END IF;
             
        END LOOP;
        
          SELECT COUNT (*)
            INTO v_uploaded
            FROM giac_upload_prem_refno
           WHERE source_cd = variables_source_cd
             AND file_no = variables_file_no
             AND upload_sw = 'Y';

          SELECT COUNT (*)
            INTO v_totalrec
            FROM giac_upload_prem_refno
           WHERE source_cd = variables_source_cd 
             AND file_no = variables_file_no;

          IF v_uploaded / v_totalrec = 1 THEN
             v_complete_sw := 'Y';
          ELSE
             v_complete_sw := 'N';
          END IF;
          
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               complete_sw = v_complete_sw,
               tran_class = 'BP',                             
               tran_id = variables_jv_tran_id,
               tran_date = TRUNC (/*SYSDATE*/variables_tran_date) --Deo [10.06.2016]: replace sysdate with variables_tran_date
         WHERE source_cd = variables_source_cd 
           AND file_no = variables_file_no;
        
   END;
   
   PROCEDURE upload_payments (
        p_source_cd       VARCHAR2,
        p_file_no         VARCHAR2,
        p_bank_cd         VARCHAR2,
        p_bank_acct_cd    VARCHAR2,
        p_user_id         VARCHAR2,
        p_process_all     VARCHAR2, --Deo [10.06.2016]
        p_rec_id          VARCHAR2  --Deo [10.06.2016]
   )
   IS
        v_date      DATE;
        v_exist     VARCHAR2(1) := 'N'; --Deo [10.06.2016]
   BEGIN
        variables_source_cd     := p_source_cd;
        variables_file_no       := p_file_no;  
        variables_user_id       := p_user_id;
        variables_dcb_bank_cd       := p_bank_cd;  
        variables_dcb_bank_acct_cd  := p_bank_acct_cd;
        
        BEGIN
            SELECT tran_date, branch_cd
              INTO v_date, variables_branch_cd
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_date := SYSDATE;
        END;
        
        variables_branch_cd := get_user_iss_cd (variables_user_id); --Deo [10.06.2016]
        upload_dpc_web.set_fixed_variables(giacp.v('FUND_CD'), variables_branch_cd, giacp.n('EVAT'));
        /*upload_dpc_web.check_dcb_user (v_date, p_user_id);
        upload_dpc_web.get_dcb_no (v_date, variables_dcb_no);*/ --Deo [10.06.2016]: comment out
        
        --Deo [10.06.2016]: add start
        upload_dpc_web.get_dcb_no2 (v_date, variables_dcb_no, v_exist);
        variables_process_all  := p_process_all;
        
        IF v_exist = 'N'
        THEN
           FOR a IN (SELECT (NVL (MAX (dcb_no), 0) + 1) new_dcb_no
                       FROM giac_colln_batch
                      WHERE fund_cd = variables_fund_cd
                        AND branch_cd = variables_branch_cd
                        AND dcb_year =
                                TO_NUMBER (TO_CHAR (v_date, 'YYYY')))
           LOOP
              variables_dcb_no := a.new_dcb_no;
              EXIT;
           END LOOP;
            
           upload_dpc_web.create_dcb_no (variables_dcb_no,
                                         v_date,
                                         variables_fund_cd,
                                         variables_branch_cd,
                                         variables_user_id
                                        );
        END IF;
        
        IF p_process_all = 'N'
        THEN
           EXECUTE IMMEDIATE    'UPDATE giac_upload_prem_refno '
                             || 'SET upload_sw = ''T'' '
                             || 'WHERE source_cd = '''
                             || p_source_cd
                             || ''' AND file_no = '
                             || p_file_no
                             || ' AND rec_id IN ('
                             || p_rec_id
                             || ') ';
        END IF;
        --Deo [10.06.2016]: add ends
        
        variables_v_date  := v_date;
        gen_jv; 
        gen_multiple_or;
   END;
   
   --Deo [10.06.2016]: add start
   PROCEDURE validate_tran_date (
      p_date        giac_acctrans.tran_date%TYPE,
      p_branch_cd   VARCHAR2,
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   )
   IS
      v_or_ante_date   giac_parameters.param_value_n%TYPE
                                   := NVL (giacp.n ('OR_ANTE_DATE_PARAM'), 0);
   BEGIN
      IF p_date <
            (  TO_DATE (TO_CHAR (SYSDATE, 'mm-dd-yyyy'), 'mm-dd-yyyy')
             - v_or_ante_date
            )
      THEN
         raise_application_error
            (-20001,
                'Geniisys Exception#I#You are no longer allowed to create an OR for '
             || TO_CHAR (p_date, 'Month dd, yyyy')
             || '.'
            );
      END IF;

      get_parameters (p_source_cd, p_file_no, p_user_id, variables_branch_cd);
      
      IF p_branch_cd IS NOT NULL
      THEN
         variables_jv_branch_cd := p_branch_cd;
      END IF;
      
      check_tran_mm (p_date);

      IF p_date != variables_tran_date
      THEN
         raise_application_error (-20001, 'Unequal Date');
      END IF;
   END;
   
   PROCEDURE cancel_file (
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   )
   IS
   BEGIN
      UPDATE giac_upload_file
         SET file_status = 'C',
             cancel_date = SYSDATE,
             user_id = p_user_id
       WHERE source_cd = p_source_cd AND file_no = p_file_no;
   END;
   
   PROCEDURE validate_print_or (
      p_source_cd            VARCHAR2,
      p_file_no              VARCHAR2,
      p_branch_cd      OUT   VARCHAR2,
      p_fund_cd        OUT   VARCHAR2,
      p_branch_name    OUT   VARCHAR2,
      p_fund_desc      OUT   VARCHAR2,
      p_upload_query   OUT   VARCHAR2
   )
   IS
   BEGIN
      BEGIN
         SELECT a.gibr_branch_cd, a.gibr_gfun_fund_cd
           INTO p_branch_cd, p_fund_cd
           FROM giac_order_of_payts a, giac_upload_prem_refno b
          WHERE a.gacc_tran_id = b.tran_id
            AND b.source_cd = p_source_cd
            AND b.file_no = p_file_no
            AND ROWNUM = 1;

         BEGIN
            SELECT branch_name
              INTO p_branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = p_fund_cd AND branch_cd = p_branch_cd;

            SELECT fund_desc
              INTO p_fund_desc
              FROM giis_funds
             WHERE fund_cd = p_fund_cd;
         END;

         p_upload_query :=
               'SELECT tran_id '
            || 'FROM giac_upload_prem_refno '
            || 'WHERE source_cd = '''
            || p_source_cd
            || ''''
            || ' AND file_no = '
            || p_file_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#O.R. does not exist in table: GIAC_ORDER_OF_PAYTS.'
               );
      END;
   END;
   
   PROCEDURE pre_upload_check (
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   )
   IS
      v_check   NUMBER;
      v_exist   VARCHAR2 (1);
   BEGIN
      variables_source_cd := p_source_cd;
      variables_file_no := p_file_no;
      variables_user_id := p_user_id;

      SELECT COUNT (*)
        INTO v_check
        FROM giac_upload_prem_refno
       WHERE source_cd = p_source_cd
         AND file_no = p_file_no
         AND prem_chk_flag IS NOT NULL;

      IF v_check = 0
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Please perform Check Data first before uploading.'
            );
      END IF;

      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM giac_upload_jv_payt_dtl
          WHERE source_cd = p_source_cd AND file_no = p_file_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                  (-20001,
                   'Geniisys Exception#I#Please enter Payment Details first before uploading.'
                  );
      END;

      IF invalid_chk_flags
      THEN
         raise_application_error (-20001, 'UPLOAD_LIST');
      END IF;
   END;
   
   FUNCTION get_giacs610_records (
      p_source_cd        giac_upload_prem_refno.source_cd%TYPE,
      p_file_no          giac_upload_prem_refno.file_no%TYPE,
      p_bank_ref_no      giac_upload_prem_refno.bank_ref_no%TYPE,
      p_collection_amt   giac_upload_prem_refno.collection_amt%TYPE,
      p_prem_amt_due     giac_upload_prem_refno.prem_amt_due%TYPE,
      p_comm_amt_due     giac_upload_prem_refno.comm_amt_due%TYPE,
      p_prem_chk_flag    giac_upload_prem_refno.prem_chk_flag%TYPE,
      p_chk_remarks      giac_upload_prem_refno.chk_remarks%TYPE,
      p_from             NUMBER,
      p_to               NUMBER,
      p_order_by         VARCHAR2,
      p_asc_desc_flag    VARCHAR2
   )
      RETURN giacs610_rec_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   giacs610_rec_type;
      v_sql   VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
         FROM (SELECT COUNT (1) OVER () count_, outersql.*
                 FROM (SELECT ROWNUM rownum_, innersql.*
                         FROM (SELECT source_cd, file_no, bank_ref_no, payor,
                                     collection_amt, prem_amt_due, comm_amt_due,
                                     prem_chk_flag, chk_remarks, tran_date,
                                     TO_CHAR (upload_date, ''mm-dd-yyyy HH:MI:SS AM''),
                                     upload_sw, rec_id, tran_id
                                 FROM giac_upload_prem_refno
                                WHERE source_cd = :p_source_cd
                                  AND file_no = :p_file_no';

      IF p_bank_ref_no IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (bank_ref_no) LIKE UPPER ('''
            || p_bank_ref_no
            || ''')';
      END IF;

      IF p_collection_amt IS NOT NULL
      THEN
         v_sql :=
            v_sql || ' AND collection_amt = (''' || p_collection_amt || ''')';
      END IF;

      IF p_prem_chk_flag IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (prem_chk_flag) LIKE UPPER ('''
            || p_prem_chk_flag
            || ''')';
      END IF;

      IF p_prem_amt_due IS NOT NULL
      THEN
         v_sql :=
                v_sql || ' AND prem_amt_due = (''' || p_prem_amt_due || ''')';
      END IF;

      IF p_comm_amt_due IS NOT NULL
      THEN
         v_sql :=
                v_sql || ' AND comm_amt_due = (''' || p_comm_amt_due || ''')';
      END IF;

      IF p_chk_remarks IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (chk_remarks) LIKE UPPER ('''
            || p_chk_remarks
            || ''')';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'bankRefNo'
         THEN
            v_sql := v_sql || ' ORDER BY bank_ref_no ';
         ELSIF p_order_by = 'collectionAmt'
         THEN
            v_sql := v_sql || ' ORDER BY collection_amt ';
         ELSIF p_order_by = 'premChkFlag'
         THEN
            v_sql := v_sql || ' ORDER BY prem_chk_flag ';
         ELSIF p_order_by = 'premAmtDue'
         THEN
            v_sql := v_sql || ' ORDER BY prem_amt_due ';
         ELSIF p_order_by = 'commAmtDue'
         THEN
            v_sql := v_sql || ' ORDER BY comm_amt_due ';
         ELSIF p_order_by = 'chkRemarks'
         THEN
            v_sql := v_sql || ' ORDER BY chk_remarks ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql := v_sql || ' )innersql  ) outersql) mainsql';

      IF p_from IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' WHERE rownum_ BETWEEN ' || p_from || ' AND ' || p_to;
      END IF;

      OPEN c FOR v_sql USING p_source_cd, p_file_no;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.source_cd, v_rec.file_no,
               v_rec.bank_ref_no, v_rec.payor, v_rec.collection_amt,
               v_rec.prem_amt_due, v_rec.comm_amt_due, v_rec.prem_chk_flag,
               v_rec.chk_remarks, v_rec.tran_date, v_rec.upload_date,
               v_rec.upload_sw, v_rec.rec_id, v_rec.tran_id;

         IF NVL (v_rec.upload_sw, 'N') = 'Y'
         THEN
            v_rec.dsp_or_no := get_ref_no (v_rec.tran_id);
         ELSE
            v_rec.dsp_or_no := NULL;
         END IF;

         IF NVL (v_rec.prem_chk_flag, 'OK') IN ('OK', 'VN', 'PT', 'OP')
         THEN
            v_rec.valid_sw := 'Y';
         ELSE
            v_rec.valid_sw := 'N';
         END IF;

         IF v_rec.prem_chk_flag IN ('WC', 'VC', 'PC', 'OC', 'FC')
         THEN
            v_rec.claim_sw := 'Y';
         ELSE
            v_rec.claim_sw := 'N';
         END IF;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;
   
   PROCEDURE check_tran_mm (p_date giac_acctrans.tran_date%TYPE)
   IS
      v_allow_closed   giac_parameters.param_value_v%TYPE
                        := NVL (giacp.v ('ALLOW_TRAN_FOR_CLOSED_MONTH'), 'N');
   BEGIN
      FOR a1 IN (SELECT closed_tag
                   FROM giac_tran_mm
                  WHERE fund_cd = variables_fund_cd
                    AND branch_cd IN
                           (variables_branch_cd,
                            NVL (variables_jv_branch_cd, variables_branch_cd)
                           )
                    AND tran_yr = TO_NUMBER (TO_CHAR (p_date, 'YYYY'))
                    AND tran_mm = TO_NUMBER (TO_CHAR (p_date, 'MM')))
      LOOP
         IF a1.closed_tag = 'T'
         THEN
            raise_application_error
               (-20210,
                   'Geniisys Exception#I#You are no longer allowed to create a transaction for '
                || TO_CHAR (p_date, 'fmMonth')
                || ' '
                || TO_CHAR (p_date, 'RRRR')
                || '. This transaction month is temporarily closed.'
               );
         ELSIF a1.closed_tag = 'Y' AND v_allow_closed = 'N'
         THEN
            raise_application_error
               (-20210,
                   'Geniisys Exception#I#You are no longer allowed to create a transaction for '
                || TO_CHAR (p_date, 'fmMonth')
                || ' '
                || TO_CHAR (p_date, 'RRRR')
                || '. This transaction month is already closed.'
               );
         END IF;
      END LOOP;
   END;
   
   PROCEDURE set_jv_dtls (p_rec giac_upload_jv_payt_dtl%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_upload_jv_payt_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd AND file_no = p_rec.file_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, branch_cd, tran_date, jv_tran_tag,
                    jv_tran_type, jv_tran_mm, jv_tran_yy, tran_year,
                    tran_month, tran_seq_no, jv_pref_suff, jv_no,
                    particulars)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.branch_cd,
                    p_rec.tran_date, p_rec.jv_tran_tag, p_rec.jv_tran_type,
                    p_rec.jv_tran_mm, p_rec.jv_tran_yy, p_rec.tran_year,
                    p_rec.tran_month, p_rec.tran_seq_no, p_rec.jv_pref_suff,
                    p_rec.jv_no, p_rec.particulars)
         WHEN MATCHED THEN
            UPDATE
               SET branch_cd = p_rec.branch_cd, tran_date = p_rec.tran_date,
                   jv_tran_tag = p_rec.jv_tran_tag,
                   jv_tran_type = p_rec.jv_tran_type,
                   jv_tran_mm = p_rec.jv_tran_mm,
                   jv_tran_yy = p_rec.jv_tran_yy,
                   tran_year = p_rec.tran_year,
                   tran_month = p_rec.tran_month,
                   tran_seq_no = p_rec.tran_seq_no,
                   jv_pref_suff = p_rec.jv_pref_suff, jv_no = p_rec.jv_no,
                   particulars = p_rec.particulars
            ;
   END set_jv_dtls;

   PROCEDURE del_jv_dtls (
      p_source_cd   giac_upload_jv_payt_dtl.source_cd%TYPE,
      p_file_no     giac_upload_jv_payt_dtl.file_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_upload_jv_payt_dtl
            WHERE source_cd = p_source_cd AND file_no = p_file_no;
   END del_jv_dtls;
   --Deo [10.06.2016]: add ends
END; 
/

