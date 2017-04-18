CREATE OR REPLACE PACKAGE BODY CPI.giacr296d_pkg
AS
   FUNCTION get_giacr296d_company_name
      RETURN CHAR
   IS
      v_comp_name   VARCHAR2 (100);
   BEGIN
      FOR rec IN (SELECT UPPER (param_value_v) param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_comp_name := rec.param_value_v;
         EXIT;
      END LOOP;

      RETURN (v_comp_name);
   END get_giacr296d_company_name;

   FUNCTION get_giacr296d_company_address
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      FOR rec IN (SELECT UPPER (param_value_v) address
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_ADDRESS')
      LOOP
         v_address := rec.address;
         EXIT;
      END LOOP;

      RETURN (v_address);
   END get_giacr296d_company_address;

   FUNCTION get_giacr296d_as_of_cut_off (p_as_of_date DATE, p_cut_off_date DATE)
      RETURN CHAR
   IS
      v_var   VARCHAR2 (100);
   BEGIN
      v_var := 'As of ' || TO_CHAR (p_as_of_date, 'fmMonth DD,') || ' Cut-off ' || TO_CHAR (p_cut_off_date, 'fmMonth DD, YYYY');
      RETURN (v_var);
   END get_giacr296d_as_of_cut_off;

   --edited by shan 01.13.2014
    FUNCTION get_giacr296d_records (p_as_of_date VARCHAR2, p_cut_off_date VARCHAR2, p_line_cd VARCHAR2, p_paid VARCHAR2, p_partpaid VARCHAR2, p_ri_cd VARCHAR2, p_unpaid VARCHAR2, p_user_id VARCHAR2)
        RETURN giacr296d_record_tab PIPELINED
    IS
        v_list           giacr296d_record_type;
        v_as_of_date     DATE                  := TO_DATE (p_as_of_date, 'MM/DD/RRRR');
        v_cut_off_date   DATE                  := TO_DATE (p_cut_off_date, 'MM/DD/RRRR');
        v_print          BOOLEAN               := FALSE;
        v_counter       NUMBER := 1;
        v_row_count     NUMBER := 1;
        v_user_branch    giis_issource.iss_cd%TYPE ;     -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
    BEGIN
         v_list.company_name := get_giacr296d_company_name;
         v_list.company_address := get_giacr296d_company_address;
         v_list.as_of_cut_off := get_giacr296d_as_of_cut_off (v_as_of_date, v_cut_off_date);
         
          -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
         FOR tx IN(SELECT b.grp_iss_cd
                          FROM giis_users a, giis_user_grp_hdr b
                         WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
         LOOP
         
            v_user_branch := tx.grp_iss_cd; 
         END LOOP;          
         
         
        FOR k IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no, a.lprem_amt, a.lprem_vat, a.lcomm_amt, a.lcomm_vat, a.lwholding_vat,
                         a.lnet_due, a.policy_id, a.fnl_binder_id, a.assd_name, a.prem_bal, a.loss_tag, a.intm_name, a.ppw
                    FROM giis_line b,
                         giac_outfacul_soa_ext a,
                         (SELECT   policy_id, SUM (NVL ((prem_amt + tax_amt) * currency_rt, 0)) ptax_amt
            -- jhing 06/08/2011 -- added a group by to get sum of amounts (tax amount) for policies with multiple invocies and to prevent the report in displaying more than one record for policies of this type which causes other discrepancy
                          FROM     gipi_invoice
                          GROUP BY policy_id) c
                   WHERE a.line_cd = b.line_cd
                     AND a.cut_off_date = v_cut_off_date
                     AND a.as_of_date = v_as_of_date
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND c.policy_id = a.policy_id
                     AND (   a.prem_bal = DECODE (p_paid, 'Y', 0)
                          OR (a.prem_bal != DECODE (p_unpaid, 'Y', 0) AND a.prem_bal = DECODE (p_unpaid, 'Y', c.ptax_amt))
                          OR (a.prem_bal != DECODE (p_partpaid, 'Y', 0) AND a.prem_bal != DECODE (p_partpaid, 'Y', c.ptax_amt))
                         )
                     AND a.lnet_due <> 0
                     AND a.user_id = p_user_id
                ORDER BY a.ri_name, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no)
        LOOP
            v_print     := TRUE;
            v_list.print_details := 'Y';
            v_list.ri_name := k.ri_name;
            v_list.line_cd := k.line_cd;
            v_list.ri_cd := k.ri_cd;
            v_list.line_name := k.line_name;
            v_list.eff_date := k.eff_date;
            v_list.booking_date := k.booking_date;
            v_list.binder_no := k.binder_no;
            v_list.policy_no := k.policy_no;
            v_list.lprem_amt := k.lprem_amt;
            v_list.lprem_vat := k.lprem_vat;
            v_list.lcomm_amt := k.lcomm_amt;
            v_list.lcomm_vat := k.lcomm_vat;
            v_list.lwholding_vat := k.lwholding_vat;
            v_list.lnet_due := k.lnet_due;
            v_list.policy_id := k.policy_id;
            v_list.fnl_binder_id := k.fnl_binder_id;
            v_list.assd_name := k.assd_name;
            v_list.prem_bal := k.prem_bal;
            v_list.loss_tag := k.loss_tag;
            v_list.intm_name := k.intm_name;
            v_list.ppw := k.ppw;            
            /*v_list.company_name := get_giacr296d_company_name;
            v_list.company_address := get_giacr296d_company_address;
            v_list.as_of_cut_off := get_giacr296d_as_of_cut_off (v_as_of_date, v_cut_off_date);* /
            PIPE ROW (v_list);*/
            
            v_counter := 1;
            v_row_count := 1;
            
            FOR j IN (SELECT column_no, column_title
                        FROM giis_report_aging
                       WHERE report_id = 'GIACR296'
                        AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0))
                       ORDER BY column_no ASC)
            LOOP
                IF v_counter = 1 THEN
                    v_list.col_no1 := j.column_no;
                    v_list.col1 := j.column_title;
                    v_counter := v_counter + 1;
                ELSIF v_counter = 2 THEN
                    v_list.col_no2 := j.column_no;
                    v_list.col2 := j.column_title;
                    v_counter := v_counter + 1;              
                ELSIF v_counter = 3 THEN
                    v_list.col_no3 := j.column_no;
                    v_list.col3 := j.column_title;
                    v_counter := v_counter + 1;
                ELSIF v_counter = 4 THEN
                    v_list.col_no4 := j.column_no;
                    v_list.col4 := j.column_title;
                    v_counter := v_counter + 1;
                END IF;
                
                IF v_counter = 5 THEN
                    v_list.policy_id_dummy      := k.policy_id || '_' || v_row_count;
                    v_list.fnl_binder_id_dummy  := k.fnl_binder_id || '_' || v_row_count;
                    v_list.row_num              := v_row_count;
                    PIPE ROW(v_list);
                     
                    v_list.col1 := NULL;
                    v_list.col2 := NULL;
                    v_list.col3 := NULL;
                    v_list.col4 := NULL;
                    v_list.col_no1 := NULL;
                    v_list.col_no2 := NULL;
                    v_list.col_no3 := NULL;
                    v_list.col_no4 := NULL;
                    v_counter := 1;            
                    v_row_count := v_row_count + 1;    
                END IF;
            END LOOP;
            
            IF v_counter != 5 THEN
                v_list.policy_id_dummy      := k.policy_id || '_' || v_row_count;
                v_list.fnl_binder_id_dummy  := k.fnl_binder_id || '_' || v_row_count;
                v_list.row_num              := v_row_count;
                PIPE ROW(v_list);
                     
                v_list.col1 := NULL;
                v_list.col2 := NULL;
                v_list.col3 := NULL; 
                v_list.col4 := NULL; 
                v_list.col_no1 := NULL;
                v_list.col_no2 := NULL;
                v_list.col_no3 := NULL;
                v_list.col_no4 := NULL;
            END IF;
        END LOOP;
        
        IF v_print = FALSE THEN
            v_list.print_details := 'N';
            PIPE ROW(v_list);
        END IF;
    END get_giacr296d_records;

   FUNCTION get_giacr296d_matrix_details (
      p_as_of_date      VARCHAR2,
      p_cut_off_date    VARCHAR2,
      p_line_cd         VARCHAR2,
      p_paid            VARCHAR2,
      p_partpaid        VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_unpaid          VARCHAR2,
      p_user_id         VARCHAR2,
      p_policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      p_fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      p_row_num         NUMBER
   )
      RETURN giacr296d_matrix_details_tab PIPELINED
   IS
      v_list           get_giacr296d_matrix_details_t;
      v_as_of_date     DATE                           := TO_DATE (p_as_of_date, 'MM/DD/RRRR');
      v_cut_off_date   DATE                           := TO_DATE (p_cut_off_date, 'MM/DD/RRRR');
      v_user_branch    giis_issource.iss_cd%TYPE ;     
   BEGIN
     
     -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101  
     FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
     LOOP
     
        v_user_branch := tx.grp_iss_cd; 
     END LOOP;    
   
   
      FOR k IN (/*SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no, a.lprem_amt, a.lprem_vat, a.lcomm_amt, a.lcomm_vat, a.lwholding_vat,
                         a.lnet_due, a.policy_id, a.fnl_binder_id, a.assd_name, a.prem_bal, a.loss_tag, a.intm_name, a.ppw
                    FROM giis_line b,
                         giac_outfacul_soa_ext a,
                         (SELECT   policy_id, SUM (NVL ((prem_amt + tax_amt) * currency_rt, 0)) ptax_amt
                              FROM gipi_invoice
                          GROUP BY policy_id) c
                   WHERE a.line_cd = b.line_cd
                     AND a.cut_off_date = v_cut_off_date
                     AND a.as_of_date = v_as_of_date
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND c.policy_id = a.policy_id
                     AND (   a.prem_bal = DECODE (p_paid, 'Y', 0)
                          OR (a.prem_bal != DECODE (p_unpaid, 'Y', 0) AND a.prem_bal = DECODE (p_unpaid, 'Y', c.ptax_amt))
                          OR (a.prem_bal != DECODE (p_partpaid, 'Y', 0) AND a.prem_bal != DECODE (p_partpaid, 'Y', c.ptax_amt))
                         )
                     AND a.lnet_due <> 0
                     AND a.user_id = p_user_id*/
               SELECT * 
                 FROM TABLE(GET_GIACR296D_RECORDS(p_as_of_date, p_cut_off_date, p_line_cd, p_paid, p_partpaid, p_ri_cd, p_unpaid, p_user_id)) a
                WHERE a.fnl_binder_id = NVL (p_fnl_binder_id, a.fnl_binder_id)
                  AND a.policy_id = NVL (p_policy_id, a.policy_id)
                  AND a.row_num = p_row_num
                ORDER BY a.ri_name, a.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no)
      LOOP
         FOR j IN (SELECT   column_no, column_title
                       FROM giis_report_aging
                      WHERE report_id = 'GIACR296'
                        AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)    -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0))
                   ORDER BY column_no ASC)
         LOOP
            IF j.column_no = k.col_no1 OR j.column_no = k.col_no2 OR j.column_no = k.col_no3 OR j.column_no = k.col_no4 THEN
                v_list.column_no := j.column_no;

                FOR i IN (SELECT a.ri_cd, a.line_cd, a.policy_id, a.fnl_binder_id, a.lnet_due, c.column_no
                            FROM giis_report_aging c, giac_outfacul_soa_ext a
                           WHERE 1 = 1
                             AND c.report_id = 'GIACR296'
                             AND c.column_no = a.column_no
                             AND a.cut_off_date = v_cut_off_date
                             AND a.as_of_date = v_as_of_date
                             AND a.ri_cd = k.ri_cd
                             AND a.line_cd = k.line_cd
                             AND a.lnet_due <> 0
                             AND a.user_id = p_user_id
                             AND a.policy_id = k.policy_id
                             AND a.fnl_binder_id = k.fnl_binder_id
                             AND a.lnet_due = k.lnet_due
                             AND (   (c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)   -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
                                OR (    c.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0)) )
                LOOP
                   IF j.column_no = i.column_no THEN
                      v_list.lnet_due := i.lnet_due;
                   ELSE
                      v_list.lnet_due := NULL;
                   END IF;

                   v_list.ri_cd := k.ri_cd;
                   v_list.line_cd := k.line_cd;
                   v_list.policy_id := k.policy_id;
                   v_list.fnl_binder_id := k.fnl_binder_id;
                   PIPE ROW (v_list);
                END LOOP;
            END IF;
         END LOOP;
      END LOOP;
   END get_giacr296d_matrix_details;

   FUNCTION get_giacr296d_matrix_header
      RETURN giacr296d_matrix_header_tab PIPELINED
   AS
      v_list   giacr296d_matrix_header_type;
   BEGIN
      FOR i IN (SELECT   column_no, column_title
                    FROM giis_report_aging
                   WHERE report_id = 'GIACR296'
                ORDER BY column_no ASC)
      LOOP
         v_list.column_no := i.column_no;
         v_list.column_title := i.column_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr296d_matrix_header;
   
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
                   WHERE owner = 'CPI'
                      AND package_name = 'CSV_SOA'
                      AND object_name = 'CSV_GIACR296D'
                      AND in_out = 'OUT'
                      AND argument_name IS NOT NULL
               ORDER BY position)
      LOOP
         
         
         IF i.argument_name = 'RI_CD' THEN
            v_list.col_name := 'RI CODE';
         ELSIF i.argument_name = 'RI_NAME' THEN
            v_list.col_name := 'REINSURER';
         ELSIF i.argument_name = 'LINE_CD' THEN
            v_list.col_name := 'LINE CODE';
         ELSIF i.argument_name = 'LINE_NAME' THEN
            v_list.col_name := 'LINE';
         ELSIF i.argument_name = 'EFF_DATE' THEN
            v_list.col_name := 'EFF DATE';
         ELSIF i.argument_name = 'BOOKING_DATE' THEN
            v_list.col_name := 'BOOKING DATE';
         ELSIF i.argument_name = 'BINDER_NO' THEN
            v_list.col_name := 'BINDER NUMBER';
         ELSIF i.argument_name = 'POLICY_NO' THEN
            v_list.col_name := 'POLICY NUMBER';
         ELSIF i.argument_name = 'ASSD_NAME' THEN
            v_list.col_name := 'ASSURED NAME';
         ELSIF i.argument_name = 'LPREM_AMT' THEN
            v_list.col_name := 'PREMIUM AMT';
         ELSIF i.argument_name = 'LPREM_VAT' THEN
            v_list.col_name := 'VAT ON PREM';
         ELSIF i.argument_name = 'LCOMM_AMT' THEN
            v_list.col_name := 'COMMISSION AMT';
         ELSIF i.argument_name = 'LCOMM_VAT' THEN
            v_list.col_name := 'VAT ON COMM';
         ELSIF i.argument_name = 'LWHOLDING_VAT' THEN
            v_list.col_name := 'WHOLDING VAT';
         ELSIF i.argument_name = 'LNET_DUE' THEN
            v_list.col_name := 'NET DUE';
         ELSIF i.argument_name = 'POLICY_ID' THEN
            v_list.col_name := 'POLICY ID';
         ELSIF i.argument_name = 'FNL_BINDER_ID' THEN
            v_list.col_name := 'FNL BINDER ID';
         ELSIF i.argument_name = 'PREM_BAL' THEN
            v_list.col_name := 'DIRECT PREMIUM BALANCE';
         ELSIF i.argument_name = 'LOSS_TAG' THEN
            v_list.col_name := 'LOSS TAG';
         ELSIF i.argument_name = 'INTM_NAME' THEN
            v_list.col_name := 'INTERMEDIARY NAME';
         ELSIF i.argument_name = 'COLUMN_NO' THEN
            v_list.col_name := 'COLUMN NUMBER';
         ELSIF i.argument_name = 'COLUMN_TITLE' THEN
            v_list.col_name := 'COLUMN TITLE';     
         ELSE
            v_list.col_name := i.argument_name;
         END IF;   
         
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;
   
   FUNCTION get_giacr296d_summary_details (
      p_as_of_date      VARCHAR2,
      p_cut_off_date    VARCHAR2,
      p_line_cd         VARCHAR2,
      p_paid            VARCHAR2,
      p_partpaid        VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_unpaid          VARCHAR2,
      p_user_id         VARCHAR2,
      p_policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      p_fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE
   )
      RETURN giacr296d_matrix_details_tab PIPELINED
   IS
      v_list           get_giacr296d_matrix_details_t;
      v_as_of_date     DATE                           := TO_DATE (p_as_of_date, 'MM/DD/RRRR');
      v_cut_off_date   DATE                           := TO_DATE (p_cut_off_date, 'MM/DD/RRRR');
   BEGIN
      FOR k IN (
               SELECT * 
                 FROM TABLE(GET_GIACR296D_RECORDS(p_as_of_date, p_cut_off_date, p_line_cd, p_paid, p_partpaid, p_ri_cd, p_unpaid, p_user_id)) a
                WHERE a.fnl_binder_id = NVL (p_fnl_binder_id, a.fnl_binder_id)
                  AND a.policy_id = NVL (p_policy_id, a.policy_id)
                ORDER BY a.ri_name, a.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no)
      LOOP
         FOR j IN (SELECT   column_no, column_title
                       FROM giis_report_aging
                      WHERE report_id = 'GIACR296'
                   ORDER BY column_no ASC)
         LOOP
            IF j.column_no = k.col_no1 OR j.column_no = k.col_no2 OR j.column_no = k.col_no3 OR j.column_no = k.col_no4 THEN
                v_list.column_no := j.column_no;

                FOR i IN (SELECT a.ri_cd, a.line_cd, a.policy_id, a.fnl_binder_id, a.lnet_due, c.column_no
                            FROM giis_report_aging c, giac_outfacul_soa_ext a
                           WHERE 1 = 1
                             AND c.report_id = 'GIACR296'
                             AND c.column_no = a.column_no
                             AND a.cut_off_date = v_cut_off_date
                             AND a.as_of_date = v_as_of_date
                             AND a.ri_cd = k.ri_cd
                             AND a.line_cd = k.line_cd
                             AND a.lnet_due <> 0
                             AND a.user_id = p_user_id
                             AND a.policy_id = k.policy_id
                             AND a.fnl_binder_id = k.fnl_binder_id
                             AND a.lnet_due = k.lnet_due)
                LOOP
                   IF j.column_no = i.column_no THEN
                      v_list.lnet_due := i.lnet_due;
                   ELSE
                      v_list.lnet_due := NULL;
                   END IF;

                   v_list.ri_cd := k.ri_cd;
                   v_list.line_cd := k.line_cd;
                   v_list.policy_id := k.policy_id;
                   v_list.fnl_binder_id := k.fnl_binder_id;
                   PIPE ROW (v_list);
                END LOOP;
            END IF;
         END LOOP;
      END LOOP;
   END get_giacr296d_summary_details;
   
   -- SR-3883 : shan 08.10.2015
   FUNCTION GET_COLUMN_HEADER ( p_user_id VARCHAR2 ) --jhing --  added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
        RETURN column_header_tab PIPELINED
    AS
        rep     column_header_type;
        v_no_of_col_allowed     NUMBER := 4;
        v_dummy     NUMBER := 0;
        v_count     NUMBER := 0;
        v_title_tab     title_tab;
        v_index     NUMBER := 0;
        v_id        NUMBER := 0;
        v_user_branch    giis_issource.iss_cd%TYPE ;    -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
    BEGIN
        v_title_tab := title_tab ();
        
        -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
        FOR tx IN(SELECT b.grp_iss_cd
                          FROM giis_users a, giis_user_grp_hdr b
                         WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
        LOOP
         
            v_user_branch := tx.grp_iss_cd; 
        END LOOP;          

        FOR t IN (SELECT column_no col_no, column_title col_title
                    FROM giis_report_aging
                   WHERE report_id = 'GIACR296'
                    AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)    -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0)) 
                   ORDER BY column_no ASC)
        LOOP
            v_index := v_index + 1;
            v_title_tab.EXTEND;
            v_title_tab (v_index).col_title := t.col_title;
            v_title_tab (v_index).col_no := t.col_no;
        END LOOP;

        v_index := 1;
        
        rep.no_of_dummy := 1;

          IF v_title_tab.COUNT > v_no_of_col_allowed
          THEN
             rep.no_of_dummy :=
                                  TRUNC (v_title_tab.COUNT / v_no_of_col_allowed);

             IF MOD (v_title_tab.COUNT, v_no_of_col_allowed) > 0
             THEN
                rep.no_of_dummy := rep.no_of_dummy + 1;
             END IF;
          END IF;
                                       
        LOOP
            v_id := v_id + 1;
            rep.dummy := v_id;            
            
            rep.col_title1 := NULL;
            rep.col_no1 := NULL;
            rep.col_title2 := NULL;
            rep.col_no2 := NULL;
            rep.col_title3 := NULL;
            rep.col_no3 := NULL;
            rep.col_title4 := NULL;
            rep.col_no4 := NULL;
            rep.row1 := NULL; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
            rep.row2 := NULL;
            rep.row3 := NULL;
            rep.row4 := NULL;
            
             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title1 := v_title_tab (v_index).col_title;
                rep.col_no1 := v_title_tab (v_index).col_no;
                rep.row1 := v_index; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title2 := v_title_tab (v_index).col_title;
                rep.col_no2 := v_title_tab (v_index).col_no;
                rep.row2 := v_index; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title3 := v_title_tab (v_index).col_title;
                rep.col_no3 := v_title_tab (v_index).col_no;
                rep.row3 := v_index; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title4 := v_title_tab (v_index).col_title;
                rep.col_no4 := v_title_tab (v_index).col_no;
                rep.row4 := v_index; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                v_index := v_index + 1;
             END IF;

             PIPE ROW (rep);
             EXIT WHEN v_index > v_title_tab.COUNT;
        END LOOP;
         
    END GET_COLUMN_HEADER;
    
    
    FUNCTION get_report_details (
        p_as_of_date    VARCHAR2, 
        p_cut_off_date  VARCHAR2, 
        p_ri_cd         VARCHAR2, 
        p_line_cd       VARCHAR2,  
        p_paid          VARCHAR2, 
        p_partpaid      VARCHAR2,
        p_unpaid        VARCHAR2, 
        p_user_id       VARCHAR2
    ) RETURN report_tab PIPELINED
    AS
        v_list           report_type;
        v_as_of_date     DATE                  := TO_DATE (p_as_of_date, 'MM/DD/RRRR');
        v_cut_off_date   DATE                  := TO_DATE (p_cut_off_date, 'MM/DD/RRRR');
        v_print          BOOLEAN               := FALSE;
        v_counter       NUMBER := 1;
        v_row_count     NUMBER := 1;
        v_user_branch    giis_issource.iss_cd%TYPE ;    -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
    BEGIN
        v_list.company_name     := get_giacr296d_company_name;
        v_list.company_address  := get_giacr296d_company_address;
        v_list.as_of_cut_off    := get_giacr296d_as_of_cut_off (v_as_of_date, v_cut_off_date);
        
         -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
        FOR tx IN(SELECT b.grp_iss_cd
                          FROM giis_users a, giis_user_grp_hdr b
                         WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
        LOOP
         
            v_user_branch := tx.grp_iss_cd; 
        END LOOP;         
        
         
        FOR k IN (SELECT a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no, a.lprem_amt, a.lprem_vat, a.lcomm_amt, a.lcomm_vat, a.lwholding_vat,
                         a.lnet_due, a.policy_id, a.fnl_binder_id, a.assd_name, a.prem_bal, a.loss_tag, a.intm_name, a.ppw,
                         COUNT(DISTINCT a.line_cd) OVER (PARTITION BY a.ri_cd) line_count, -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
                         SUM(a.prem_bal) OVER (PARTITION BY 1) grand_prem_bal,
                         SUM(a.lprem_amt) OVER (PARTITION BY 1) grand_lprem_amt,
                         SUM(a.lprem_vat) OVER (PARTITION BY 1) grand_lprem_vat,
                         SUM(a.lcomm_amt) OVER (PARTITION BY 1) grand_lcomm_amt,
                         SUM(a.lcomm_vat) OVER (PARTITION BY 1) grand_lcomm_vat,
                         SUM(a.lwholding_vat) OVER (PARTITION BY 1) grand_lwholding_vat,
                         SUM(a.lnet_due) OVER (PARTITION BY 1) grand_lnet_due,
                         MAX(a.ri_name) OVER (ORDER BY a.ri_name DESC) max_ri_name,
                         MAX(a.line_cd) OVER (PARTITION BY a.ri_name ORDER BY a.ri_name DESC, a.line_cd DESC) max_line_cd -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 end
                    FROM giis_line b,
                         giac_outfacul_soa_ext a,
                         (SELECT   policy_id, SUM (NVL ((prem_amt + tax_amt) * currency_rt, 0)) ptax_amt
            -- jhing 06/08/2011 -- added a group by to get sum of amounts (tax amount) for policies with multiple invocies and to prevent the report in displaying more than one record for policies of this type which causes other discrepancy
                          FROM     gipi_invoice
                          GROUP BY policy_id) c
                   WHERE a.line_cd = b.line_cd
                     AND a.cut_off_date = v_cut_off_date
                     AND a.as_of_date = v_as_of_date
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND c.policy_id = a.policy_id
                     AND (   a.prem_bal = DECODE (p_paid, 'Y', 0)
                          OR (a.prem_bal != DECODE (p_unpaid, 'Y', 0) AND a.prem_bal = DECODE (p_unpaid, 'Y', c.ptax_amt))
                          OR (a.prem_bal != DECODE (p_partpaid, 'Y', 0) AND a.prem_bal != DECODE (p_partpaid, 'Y', c.ptax_amt))
                         )
                     AND a.lnet_due <> 0
                     AND a.user_id = p_user_id
                ORDER BY a.ri_name, b.line_name, a.eff_date, a.booking_date, a.binder_no, a.policy_no)
        LOOP
            v_print     := TRUE;
            v_list.print_details := 'Y';
            v_list.ri_name := k.ri_name;
            v_list.line_cd := k.line_cd;
            v_list.ri_cd := k.ri_cd;
            v_list.line_name := k.line_name;
            v_list.eff_date := k.eff_date;
            v_list.booking_date := k.booking_date;
            v_list.binder_no := k.binder_no;
            v_list.policy_no := k.policy_no;
            v_list.lprem_amt := k.lprem_amt;
            v_list.lprem_vat := k.lprem_vat;
            v_list.lcomm_amt := k.lcomm_amt;
            v_list.lcomm_vat := k.lcomm_vat;
            v_list.lwholding_vat := k.lwholding_vat;
            v_list.lnet_due := k.lnet_due;
            v_list.policy_id := k.policy_id;
            v_list.fnl_binder_id := k.fnl_binder_id;
            v_list.assd_name := k.assd_name;
            v_list.prem_bal := k.prem_bal;
            v_list.loss_tag := k.loss_tag;
            v_list.intm_name := k.intm_name;
            v_list.ppw := k.ppw;
            v_list.line_count := k.line_count; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
            v_list.grand_prem_bal := k.grand_prem_bal;
            v_list.grand_lprem_amt := k.grand_lprem_amt;
            v_list.grand_lprem_vat := k.grand_lprem_vat;   
            v_list.grand_lcomm_amt := k.grand_lcomm_amt;  
            v_list.grand_lcomm_vat := k.grand_lcomm_vat;   
            v_list.grand_lwholding_vat := k.grand_lwholding_vat;
            v_list.grand_lnet_due := k.grand_lnet_due;
            v_list.max_ri_name := k.max_ri_name;
            v_list.max_line_cd := k.max_line_cd; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 end
            
            v_counter := 1;
            v_row_count := 1;            
                         
            v_list.col1 := NULL;
            v_list.col_no1 := NULL;
            v_list.col2 := NULL;
            v_list.col_no2 := NULL;
            v_list.col3 := NULL;
            v_list.col_no3 := NULL;
            v_list.col4 := NULL;
            v_list.col_no4 := NULL;
            
            FOR j IN (SELECT *
                        FROM TABLE(GIACR296D_PKG.get_column_header (p_user_id ) ))
            LOOP
                v_list.ri_cd_dummy      :=  v_list.ri_cd || '_' || j.dummy;
                v_list.dummy            := j.dummy;
                                             
                v_list.no_of_dummy     := j.no_of_dummy;
                v_list.col1            := j.col_title1;
                v_list.col_no1         := j.col_no1;
                v_list.col2            := j.col_title2;
                v_list.col_no2         := j.col_no2;
                v_list.col3            := j.col_title3;
                v_list.col_no3         := j.col_no3;
                v_list.col4            := j.col_title4;
                v_list.col_no4         := j.col_no4;
             
                IF j.col_no1 IS NOT NULL THEN
                     v_list.lnet_due1 := 0;
                ELSE
                     v_list.lnet_due1 := NULL;
                END IF;
                
                IF j.col_no2 IS NOT NULL THEN
                     v_list.lnet_due2 := 0;
                ELSE
                     v_list.lnet_due2 := NULL;
                END IF;
                
                IF j.col_no3 IS NOT NULL THEN
                     v_list.lnet_due3 := 0;
                ELSE
                     v_list.lnet_due3 := NULL;
                END IF;
                
                IF j.col_no4 IS NOT NULL THEN
                     v_list.lnet_due4 := 0;
                ELSE
                     v_list.lnet_due4 := NULL;
                END IF;
                
                FOR l IN (SELECT a.ri_cd,
                                 a.line_cd, 
                                 a.policy_id,
                                 a.fnl_binder_id,
                                 a.lnet_due,
                                 c.column_no
                            FROM giis_report_aging c, giac_outfacul_soa_ext a 
                           WHERE 1=1
                             AND c.report_id = 'GIACR296'
                             AND c.column_no = a.column_no
                             AND a.cut_off_date = v_cut_off_date
                             AND a.as_of_date = v_as_of_date
                             AND a.ri_cd = k.ri_cd
                             AND a.line_cd = k.line_cd
                             AND a.lnet_due <> 0
                             AND a.user_id = p_user_id
                             AND a.policy_id = k.policy_id
                             AND a.fnl_binder_id = k.fnl_binder_id
                             AND c.column_no IN (j.col_no1, j.col_no2, j.col_no3, j.col_no4)
                             AND (   (c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                                OR (    c.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id =  'GIACR296') =
                                           0)))
                LOOP
                    IF j.col_no1 = l.column_no THEN
                         v_list.lnet_due1 := NVL(l.lnet_due,0);
                         v_list.column_no1 := j.row1; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                    ELSIF j.col_no2 = l.column_no THEN
                         v_list.lnet_due2 := NVL(l.lnet_due,0);
                         v_list.column_no2 := j.row2; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                    ELSIF j.col_no3 = l.column_no THEN
                         v_list.lnet_due3 := NVL(l.lnet_due,0);
                         v_list.column_no3 := j.row3; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                    ELSIF j.col_no4 = l.column_no THEN
                         v_list.lnet_due4 := NVL(l.lnet_due,0);
                         v_list.column_no4 := j.row4; -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
                    END IF;
                END LOOP;
                
                PIPE ROW(v_list);
            END LOOP;
            
            
        END LOOP;
        
        IF v_print = FALSE THEN
            v_list.print_details := 'N';
            PIPE ROW(v_list);
        END IF;
    
    END get_report_details;
   
   FUNCTION GET_SUMMARY_COLUMN_HEADER   ( p_user_id VARCHAR2 )  -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
        RETURN summary_column_header_tab PIPELINED
    AS
        rep     summary_column_header_type;
        v_no_of_col_allowed     NUMBER := 7;
        v_dummy     NUMBER := 0;
        v_count     NUMBER := 0;
        v_title_tab     title_tab;
        v_index     NUMBER := 0;
        v_id        NUMBER := 0;
        v_user_branch    giis_issource.iss_cd%TYPE ;       -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
    BEGIN
        v_title_tab := title_tab ();
         -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
       FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
       LOOP
         
        v_user_branch := tx.grp_iss_cd; 
       END LOOP;   

        FOR t IN (SELECT column_no col_no, column_title col_title
                    FROM giis_report_aging
                   WHERE report_id = 'GIACR296'
                    AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id =  'GIACR296') =
                                           0)) 
                   ORDER BY column_no ASC)
        LOOP
            v_index := v_index + 1;
            v_title_tab.EXTEND;
            v_title_tab (v_index).col_title := t.col_title;
            v_title_tab (v_index).col_no := t.col_no;
        END LOOP;

        v_index := 1;
        
        rep.no_of_dummy := 1;

          IF v_title_tab.COUNT > v_no_of_col_allowed
          THEN
             rep.no_of_dummy :=
                                  TRUNC (v_title_tab.COUNT / v_no_of_col_allowed);

             IF MOD (v_title_tab.COUNT, v_no_of_col_allowed) > 0
             THEN
                rep.no_of_dummy := rep.no_of_dummy + 1;
             END IF;
          END IF;
                                       
        LOOP
            v_id := v_id + 1;
            rep.dummy := v_id;            
            
            rep.col_title1 := NULL;
            rep.col_no1 := NULL;
            rep.col_title2 := NULL;
            rep.col_no2 := NULL;
            rep.col_title3 := NULL;
            rep.col_no3 := NULL;
            rep.col_title4 := NULL;
            rep.col_no4 := NULL;
            rep.col_title5 := NULL;
            rep.col_no5 := NULL;
            rep.col_title6 := NULL;
            rep.col_no6 := NULL;
            rep.col_title7 := NULL;
            rep.col_no7 := NULL;
            
             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title1 := v_title_tab (v_index).col_title;
                rep.col_no1 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title2 := v_title_tab (v_index).col_title;
                rep.col_no2 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title3 := v_title_tab (v_index).col_title;
                rep.col_no3 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title4 := v_title_tab (v_index).col_title;
                rep.col_no4 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title5 := v_title_tab (v_index).col_title;
                rep.col_no5 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title6 := v_title_tab (v_index).col_title;
                rep.col_no6 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title7 := v_title_tab (v_index).col_title;
                rep.col_no7 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             PIPE ROW (rep);
             EXIT WHEN v_index > v_title_tab.COUNT;
        END LOOP;
         
    END GET_SUMMARY_COLUMN_HEADER;
    
    FUNCTION get_report_summary_details (
        p_as_of_date    VARCHAR2, 
        p_cut_off_date  VARCHAR2,  
        p_ri_cd         VARCHAR2, 
        p_line_cd       VARCHAR2, 
        p_paid          VARCHAR2, 
        p_partpaid      VARCHAR2,
        p_unpaid        VARCHAR2, 
        p_user_id       VARCHAR2
    ) RETURN summary_report_tab PIPELINED
    AS
        v_list           summary_report_type;
        v_user_branch    giis_issource.iss_cd%TYPE ;    
    BEGIN
     -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
     FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
     LOOP
     
        v_user_branch := tx.grp_iss_cd; 
     END LOOP;      
    
    
        FOR i IN (SELECT a.ri_cd, a.ri_name, SUM(a.prem_bal) prem_bal, SUM(a.lprem_amt) lprem_amt, SUM(a.lprem_vat) lprem_vat, SUM(a.lcomm_amt) lcomm_amt,  
                         SUM(a.lcomm_vat) lcomm_vat, SUM(a.lwholding_vat) lwholding_vat, SUM(a.lnet_due) lnet_due
                    FROM giis_line b,
                         giac_outfacul_soa_ext a,
                         (SELECT   policy_id, SUM (NVL ((prem_amt + tax_amt) * currency_rt, 0)) ptax_amt
            -- jhing 06/08/2011 -- added a group by to get sum of amounts (tax amount) for policies with multiple invocies and to prevent the report in displaying more than one record for policies of this type which causes other discrepancy
                          FROM     gipi_invoice
                          GROUP BY policy_id) c
                   WHERE a.line_cd = b.line_cd
                     AND a.cut_off_date = TO_DATE(p_cut_off_date, 'MM-DD-RRRR')
                     AND a.as_of_date = TO_DATE(p_as_of_date, 'MM-DD-RRRR')
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND c.policy_id = a.policy_id
                     AND (   a.prem_bal = DECODE (p_paid, 'Y', 0)
                          OR (a.prem_bal != DECODE (p_unpaid, 'Y', 0) AND a.prem_bal = DECODE (p_unpaid, 'Y', c.ptax_amt))
                          OR (a.prem_bal != DECODE (p_partpaid, 'Y', 0) AND a.prem_bal != DECODE (p_partpaid, 'Y', c.ptax_amt))
                         )
                     AND a.lnet_due <> 0
                     AND a.user_id = p_user_id
                   GROUP BY a.ri_cd, a.ri_name
                   ORDER BY a.ri_name)
        LOOP
            v_list.ri_cd            := i.ri_cd;
            v_list.ri_name          := i.ri_name;
            v_list.prem_bal         := i.prem_bal;
            v_list.lprem_amt        := i.lprem_amt;
            v_list.lprem_vat        := i.lprem_vat;
            v_list.lcomm_amt        := i.lcomm_amt;
            v_list.lcomm_vat        := i.lcomm_vat; 
            v_list.lwholding_vat    := i.lwholding_vat;
            v_list.lnet_due         := i.lnet_due;
            
            
            v_list.col1 := NULL;
            v_list.col_no1 := NULL;
            v_list.col2 := NULL;
            v_list.col_no2 := NULL;
            v_list.col3 := NULL;
            v_list.col_no3 := NULL;
            v_list.col4 := NULL;
            v_list.col_no4 := NULL;
            v_list.col5 := NULL;
            v_list.col_no5 := NULL;
            v_list.col6 := NULL;
            v_list.col_no6 := NULL;
            v_list.col7 := NULL;
            v_list.col_no7 := NULL;
            
            FOR j IN (SELECT *
                        FROM TABLE(GIACR296D_PKG.get_summary_column_header (p_user_id ) ))
            LOOP
                v_list.ri_cd_dummy      :=  v_list.ri_cd || '_' || j.dummy;
                v_list.dummy            := j.dummy;
                                             
                v_list.no_of_dummy     := j.no_of_dummy;
                v_list.col1            := j.col_title1;
                v_list.col_no1         := j.col_no1;
                v_list.col2            := j.col_title2;
                v_list.col_no2         := j.col_no2;
                v_list.col3            := j.col_title3;
                v_list.col_no3         := j.col_no3;
                v_list.col4            := j.col_title4;
                v_list.col_no4         := j.col_no4;
                v_list.col5            := j.col_title5;
                v_list.col_no5         := j.col_no5;
                v_list.col6            := j.col_title6;
                v_list.col_no6         := j.col_no6;
                v_list.col7            := j.col_title7;
                v_list.col_no7         := j.col_no7;
             
                IF j.col_no1 IS NOT NULL THEN
                     v_list.lnet_due1 := 0;
                ELSE
                     v_list.lnet_due1 := NULL;
                END IF;
                
                IF j.col_no2 IS NOT NULL THEN
                     v_list.lnet_due2 := 0;
                ELSE
                     v_list.lnet_due2 := NULL;
                END IF;
                
                IF j.col_no3 IS NOT NULL THEN
                     v_list.lnet_due3 := 0;
                ELSE
                     v_list.lnet_due3 := NULL;
                END IF;
                
                IF j.col_no4 IS NOT NULL THEN
                     v_list.lnet_due4 := 0;
                ELSE
                     v_list.lnet_due4 := NULL;
                END IF;
                
                IF j.col_no5 IS NOT NULL THEN
                     v_list.lnet_due5 := 0;
                ELSE
                     v_list.lnet_due5 := NULL;
                END IF;
                
                IF j.col_no6 IS NOT NULL THEN
                     v_list.lnet_due6 := 0;
                ELSE
                     v_list.lnet_due6 := NULL;
                END IF;
                
                IF j.col_no7 IS NOT NULL THEN
                     v_list.lnet_due7 := 0;
                ELSE
                     v_list.lnet_due7 := NULL;
                END IF;
                
                FOR k IN (SELECT a.ri_cd, c.column_no, SUM(a.lnet_due) lnet_due
                            FROM giis_report_aging c, giac_outfacul_soa_ext a 
                           WHERE 1=1
                             AND c.report_id = 'GIACR296'
                             AND c.column_no = a.column_no
                             AND a.cut_off_date = TO_DATE(p_cut_off_date, 'MM-DD-RRRR')
                             AND a.as_of_date = TO_DATE(p_as_of_date, 'MM-DD-RRRR')
                             AND a.ri_cd = i.ri_cd
                             --AND a.line_cd = i.line_cd
                             AND a.lnet_due <> 0
                             AND a.user_id = p_user_id
                             --AND a.policy_id = i.policy_id
                             --AND a.fnl_binder_id = i.fnl_binder_id
                             AND c.column_no IN (j.col_no1, j.col_no2, j.col_no3, j.col_no4, j.col_no5, j.col_no6, j.col_no7)
                             AND (   (c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                                OR (    c.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id =  'GIACR296') =
                                           0))
                           GROUP BY a.ri_cd, c.column_no)
                LOOP
                    IF j.col_no1 = k.column_no THEN
                         v_list.lnet_due1 := NVL(k.lnet_due,0);
                    ELSIF j.col_no2 = k.column_no THEN
                         v_list.lnet_due2 := NVL(k.lnet_due,0);
                    ELSIF j.col_no3 = k.column_no THEN
                         v_list.lnet_due3 := NVL(k.lnet_due,0);
                    ELSIF j.col_no4 = k.column_no THEN
                         v_list.lnet_due4 := NVL(k.lnet_due,0);
                    ELSIF j.col_no5 = k.column_no THEN
                         v_list.lnet_due5 := NVL(k.lnet_due,0);
                    ELSIF j.col_no6 = k.column_no THEN
                         v_list.lnet_due6 := NVL(k.lnet_due,0);
                    ELSIF j.col_no7 = k.column_no THEN
                         v_list.lnet_due7 := NVL(k.lnet_due,0);
                    END IF;
                END LOOP;
        
                PIPE ROW(v_list);
            END LOOP j;
            
        END LOOP i;
        
    END get_report_summary_details;
   -- end SR-3883
   
END giacr296d_pkg;
/


