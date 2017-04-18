CREATE OR REPLACE PACKAGE BODY CPI.GIAC_TAX_PAYMENTS_PKG
AS

    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: retrieve list of tax payments
    */
    FUNCTION get_giac_tax_payments(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE
    )
      RETURN giac_tax_payments_tab PIPELINED
    IS
        v_row                   giac_tax_payments_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIAC_TAX_PAYMENTS
                  WHERE gacc_tran_id = p_gacc_tran_id
                  ORDER BY item_no)
        LOOP
            v_row := NULL;
            v_row.gacc_tran_id := i.gacc_tran_id;
            v_row.item_no := i.item_no;
            v_row.transaction_type := i.transaction_type;
            v_row.fund_cd := i.fund_cd;
            v_row.tax_cd := i.tax_cd;
            v_row.branch_cd := i.branch_cd;
            v_row.tax_amt := i.tax_amt;
            v_row.or_print_tag := i.or_print_tag;
            v_row.remarks := i.remarks;
            v_row.user_id := i.user_id;
            v_row.last_update := i.last_update;
            v_row.cpi_rec_no := i.cpi_rec_no;
            v_row.cpi_branch_cd := i.cpi_branch_cd;
            v_row.sl_cd := i.sl_cd;
            v_row.sl_type_cd := i.sl_type_cd;
            
            FOR a IN(SELECT sl_name
                       FROM GIAC_SL_LISTS
                      WHERE fund_cd = i.fund_cd
                        AND sl_cd = i.sl_cd
                        AND sl_type_cd = i.sl_type_cd)
            LOOP
                v_row.sl_name := a.sl_name;
                EXIT;
            END LOOP;
            
            FOR b IN(SELECT tax_name
                       FROM GIAC_TAXES
                      WHERE fund_cd = i.fund_cd
                        AND tax_cd = i.tax_cd)
            LOOP
                v_row.tax_name := b.tax_name;
                EXIT;
            END LOOP;
            
            FOR c IN(SELECT SUBSTR(rv_meaning, 1, 25)  rv_meaning
                       FROM CG_REF_CODES
                      WHERE rv_domain = 'GIAC_TAX_PAYMENTS.TRANSACTION_TYPE'
                        AND rv_low_value = i.transaction_type)
            LOOP
                v_row.transaction_desc := c.rv_meaning;
                EXIT;
            END LOOP;
            
            FOR d IN(SELECT branch_name
                       FROM GIAC_BRANCHES
                      WHERE gfun_fund_cd = i.fund_cd
                        AND branch_cd = i.branch_cd)
            LOOP
                v_row.branch_name := d.branch_name;
                EXIT;
            END LOOP;
            
            FOR e IN(SELECT fund_desc
                       FROM GIIS_FUNDS
                      WHERE fund_cd = i.fund_cd)
            LOOP
                v_row.fund_desc := e.fund_desc;
                EXIT;
            END LOOP;
            
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: populate giacs021 module variables
    */
    FUNCTION get_giacs021_variables(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE
    )
      RETURN giacs021_variables_table PIPELINED
    IS
        v_row                   giacs021_variables_type;
    BEGIN
        BEGIN
            SELECT SUM(tax_amt)
              INTO v_row.total_tax
              FROM GIAC_TAX_PAYMENTS
             WHERE gacc_tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_row.total_tax := 0;
        END;
        
        BEGIN
            SELECT NVL(MAX(item_no),1)
              INTO v_row.max_item
              FROM GIAC_TAX_PAYMENTS
             WHERE gacc_tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_row.max_item := 1;
        END;
        
        PIPE ROW(v_row);
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: retrieve list of added tax payment items
    */
    FUNCTION get_giacs021_item_list(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE
    )
      RETURN item_list_tab PIPELINED
    IS
        v_row                   item_list_type;
    BEGIN
        FOR i IN(SELECT item_no
                   FROM GIAC_TAX_PAYMENTS
                  WHERE gacc_tran_id = p_gacc_tran_id
                  ORDER BY item_no)
        LOOP
            v_row.item_no := i.item_no;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: tax LOV
    */
    FUNCTION get_taxes(
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE
    )
      RETURN giac_taxes_table PIPELINED
    IS
        v_row                   giac_taxes_type;
    BEGIN
        FOR i IN(SELECT gl_acct_id ,tax_cd, tax_name
                   from GIAC_TAXES
                  where fund_cd = p_fund_cd)
        LOOP
            v_row := NULL;
            v_row.gl_acct_id := i.gl_acct_id;
            v_row.tax_cd := i.tax_cd;
            v_row.tax_name := i.tax_name;
            
            FOR a IN(SELECT gslt_sl_type_cd
                       FROM GIAC_CHART_OF_ACCTS
                      WHERE gl_acct_id = i.gl_acct_id)
            LOOP
                v_row.sl_type_cd := a.gslt_sl_type_cd;
                EXIT;
            END LOOP;   
            
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: SL LOV
    */
    FUNCTION get_sl_list(
        p_sl_type_cd            GIAC_SL_LISTS.sl_type_cd%TYPE,
        p_find                  GIAC_SL_LISTS.sl_name%TYPE
    )
      RETURN sl_list_tab PIPELINED
    IS
        v_row                   sl_list_type;
    BEGIN
        FOR i IN(SELECT sl_cd, sl_name, sl_type_cd 
                   FROM GIAC_SL_LISTS 
                  WHERE sl_type_cd = p_sl_type_cd
                    AND (UPPER(sl_name) like NVL(UPPER(p_find), '%')
				     OR sl_cd LIKE NVL(p_find, '%'))
                  ORDER BY sl_cd)
        LOOP
            v_row.sl_name := i.sl_name;
            v_row.sl_cd := i.sl_cd;
            v_row.sl_type_cd := i.sl_type_cd;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: delete tax payment
    */
    PROCEDURE delete_giac_tax_payment(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE,
        p_item_no               GIAC_TAX_PAYMENTS.item_no%TYPE
    )
    IS
    BEGIN
        DELETE GIAC_TAX_PAYMENTS
         WHERE gacc_tran_id = p_gacc_tran_id
           AND item_no = p_item_no;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: insert new tax payment
    */
    PROCEDURE insert_giac_tax_payment(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE,
        p_item_no               GIAC_TAX_PAYMENTS.item_no%TYPE,
        p_transaction_type      GIAC_TAX_PAYMENTS.transaction_type%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_tax_cd                GIAC_TAX_PAYMENTS.tax_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_tax_amt               GIAC_TAX_PAYMENTS.tax_amt%TYPE,
        p_or_print_tag          GIAC_TAX_PAYMENTS.or_print_tag%TYPE,
        p_remarks               GIAC_TAX_PAYMENTS.remarks%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE,
        p_sl_cd                 GIAC_TAX_PAYMENTS.sl_cd%TYPE,
        p_sl_type_cd            GIAC_TAX_PAYMENTS.sl_type_cd%TYPE
    )
    IS
    BEGIN
        INSERT INTO GIAC_TAX_PAYMENTS
               (gacc_tran_id, item_no, transaction_type, fund_cd, tax_cd, branch_cd,
               tax_amt, or_print_tag, remarks, user_id, last_update, sl_cd, sl_type_cd)
        VALUES (p_gacc_tran_id, p_item_no, p_transaction_type, p_fund_cd, p_tax_cd, p_branch_cd,
               p_tax_amt, p_or_print_tag, p_remarks, p_user_id, SYSDATE, p_sl_cd, p_sl_type_cd);
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: aeg_parameters program unit
    */
    PROCEDURE aeg_parameters_giacs021(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE
    )
    IS
        v_dummy                 VARCHAR2(1);
        v_credit_amt            NUMBER;
        v_debit_amt             NUMBER;
        v_module_id             GIAC_MODULES.module_id%TYPE;
        v_gen_type              GIAC_MODULES.generation_type%TYPE;
    BEGIN
        BEGIN
            SELECT module_id,
                   generation_type
              INTO v_module_id,
                   v_gen_type
              FROM GIAC_MODULES
             WHERE module_name  = 'GIACS021';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
        END;
        
        GIAC_TAX_PAYMENTS_PKG.delete_acct_entries_giacs021(p_gacc_tran_id, v_gen_type);
        
        FOR rec IN(SELECT fund_cd, tax_cd, branch_cd, tax_amt, sl_cd, sl_type_cd
	                 FROM GIAC_TAX_PAYMENTS
	                WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
            FOR gt_rec2 IN(SELECT gl_acct_category, gl_control_acct, gl_acct_id, 
		                          gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
		                          gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
		                          gl_sub_acct_7
                             FROM GIAC_TAXES
		                    WHERE fund_cd = rec.fund_cd
		                      AND tax_cd = rec.tax_cd )
            LOOP
                BEGIN
                    IF SIGN(rec.tax_amt) = -1 THEN
                        v_credit_amt :=	ABS(NVL(rec.tax_amt,0));
                        v_debit_amt := 0;
                    ELSIF SIGN(rec.tax_amt) = 1 THEN
                        v_credit_amt :=	0;
                        v_debit_amt := ABS(NVL(rec.tax_amt,0));
           	        END IF;
                
                    UPDATE GIAC_ACCT_ENTRIES
			           SET credit_amt = NVL(credit_amt, 0) + NVL(v_credit_amt, 0),
       			           debit_amt = NVL(debit_amt, 0)  + NVL(v_debit_amt, 0)
			         WHERE gacc_tran_id	= p_gacc_tran_id
			           AND gacc_gfun_fund_cd = p_fund_cd
			           AND gacc_gibr_branch_cd	= p_branch_cd
			           AND gl_acct_id = gt_rec2.gl_acct_id
		  	           AND NVL(sl_cd, 1) = NVL(rec.sl_cd, 1)
	                   AND NVL(sl_type_cd, 'x') = NVL(rec.sl_type_cd, 'x');
                       
                    IF SQL%FOUND THEN
	                    NULL;
                    ELSE
                        GIAC_TAX_PAYMENTS_PKG.create_acct_entries_giacs021(p_gacc_tran_id, p_fund_cd, p_branch_cd, p_user_id,
                                                                           v_module_id, 1, v_gen_type, gt_rec2.gl_acct_category, 
                                                                           gt_rec2.gl_control_acct, gt_rec2.gl_sub_acct_1, gt_rec2.gl_sub_acct_2,
                                                                           gt_rec2.gl_sub_acct_3, gt_rec2.gl_sub_acct_4, gt_rec2.gl_sub_acct_5,
                                                                           gt_rec2.gl_sub_acct_6, gt_rec2.gl_sub_acct_7, gt_rec2.gl_acct_id,
                                                                           rec.tax_amt, rec.sl_cd, rec.sl_type_cd);
                    END IF;
                END;
            END LOOP;
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: AEG_Delete_Acct_Entries program unit
    */
    PROCEDURE delete_acct_entries_giacs021(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_gen_type              GIAC_MODULES.generation_type%TYPE
    )
    IS
        CURSOR ae IS
            SELECT '1'
              FROM GIAC_ACCT_ENTRIES
             WHERE gacc_tran_id = p_gacc_tran_id
               AND generation_type = p_gen_type;
        dummy                   VARCHAR2(1);
    BEGIN
        OPEN ae;
        FETCH ae INTO dummy;
        
        IF SQL%FOUND THEN
            DELETE FROM GIAC_ACCT_ENTRIES
             WHERE gacc_tran_id = p_gacc_tran_id
               AND generation_type = p_gen_type;
        END IF;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: AEG_Create_Acct_Entries program unit
    */
    PROCEDURE create_acct_entries_giacs021(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE,
        p_module_id             GIAC_MODULE_ENTRIES.module_id%TYPE,
        p_item_no               GIAC_MODULE_ENTRIES.item_no%TYPE,
        p_gen_type              GIAC_ACCT_ENTRIES.generation_type%TYPE,
        p_gl_acct_category      GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        p_gl_control_acct       GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        p_gl_sub_acct_1         GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        p_gl_sub_acct_2   	    GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3	        GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4         GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5   	    GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6	        GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7   	    GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        p_gl_acct_id 	        GIAC_ACCT_ENTRIES.gl_acct_id%TYPE,
        p_acct_amt              GIAC_TAX_PAYMENTS.tax_amt%TYPE,
        p_sl_cd                 GIAC_TAX_PAYMENTS.sl_cd%TYPE,
        p_sl_type_cd            GIAC_TAX_PAYMENTS.sl_type_cd%TYPE
    )
    IS
        ws_gl_acct_category     GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
        ws_gl_control_acct      GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
        ws_gl_sub_acct_1        GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
        ws_gl_sub_acct_2        GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        ws_gl_sub_acct_3        GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
        ws_gl_sub_acct_4        GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
        ws_gl_sub_acct_5        GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
        ws_gl_sub_acct_6        GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
        ws_gl_sub_acct_7        GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
        ws_pol_type_tag         GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
        ws_intm_type_level      GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
        ws_old_new_acct_level   GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
        ws_line_dep_level       GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
        ws_dr_cr_tag            GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
        ws_acct_intm_cd         GIIS_INTM_TYPE.acct_intm_cd%TYPE;
        ws_line_cd              GIIS_LINE.line_cd%TYPE;
        ws_iss_cd               GIPI_POLBASIC.iss_cd%TYPE;
        ws_old_acct_cd          GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        ws_new_acct_cd          GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        pt_gl_sub_acct_1        GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
        pt_gl_sub_acct_2        GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        pt_gl_sub_acct_3        GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
        pt_gl_sub_acct_4        GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
        pt_gl_sub_acct_5        GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
        pt_gl_sub_acct_6        GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
        pt_gl_sub_acct_7        GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
        ws_debit_amt            GIAC_ACCT_ENTRIES.debit_amt%TYPE;
        ws_credit_amt           GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
        ws_gl_acct_id           GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
    BEGIN
        ws_gl_acct_id := p_gl_acct_id;
        
        GIAC_TAX_PAYMENTS_PKG.check_chart_of_account(p_gl_acct_category, p_gl_control_acct, p_gl_sub_acct_1, p_gl_sub_acct_2,
                                                     p_gl_sub_acct_3, p_gl_sub_acct_4, p_gl_sub_acct_5, p_gl_sub_acct_6, 
                                                     p_gl_sub_acct_7, ws_gl_acct_id);
    
        IF SIGN(p_acct_amt) = -1 THEN
	        ws_credit_amt := ABS(NVL(p_acct_amt,0));
            ws_debit_amt := 0;
        ELSIF SIGN(p_acct_amt) = 1 THEN
            ws_credit_amt := 0;
            ws_debit_amt := ABS(NVL(p_acct_amt,0));
        END IF;
    
        GIAC_TAX_PAYMENTS_PKG.insert_update_acct_entries(p_gacc_tran_id, p_fund_cd, p_branch_cd, p_user_id,
                                                         p_gl_acct_category, p_gl_control_acct, p_gl_sub_acct_1,
                                                         p_gl_sub_acct_2, p_gl_sub_acct_3  , p_gl_sub_acct_4,
                                                         p_gl_sub_acct_5, p_gl_sub_acct_6  , p_gl_sub_acct_7,
                                                         p_gen_type, ws_gl_acct_id,        
                                                         ws_debit_amt, ws_credit_amt,
                                                         p_sl_cd, p_sl_type_cd);
    
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: AEG_Check_Chart_Of_Accts program unit
    */
    PROCEDURE check_chart_of_account(
        cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE 
    )
    IS
    BEGIN
        SELECT DISTINCT(gl_acct_id)
          INTO cca_gl_acct_id
          FROM GIAC_CHART_OF_ACCTS
         WHERE gl_acct_category = cca_gl_acct_category
           AND gl_control_acct = cca_gl_control_acct
           AND gl_sub_acct_1 = cca_gl_sub_acct_1
           AND gl_sub_acct_2 = cca_gl_sub_acct_2
           AND gl_sub_acct_3 = cca_gl_sub_acct_3
           AND gl_sub_acct_4 = cca_gl_sub_acct_4
           AND gl_sub_acct_5 = cca_gl_sub_acct_5
           AND gl_sub_acct_6 = cca_gl_sub_acct_6
           AND gl_sub_acct_7 = cca_gl_sub_acct_7;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#GL account code '||TO_CHAR(cca_gl_acct_category)
                ||'-'||TO_CHAR(cca_gl_control_acct,'09') 
                ||'-'||TO_CHAR(cca_gl_sub_acct_1,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_2,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_3,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_4,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_5,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_6,'09')
                ||'-'||TO_CHAR(cca_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans).');
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.11.2013
    **  Reference By: GIACS021 - Tax Payments
    **  Description: AEG_Insert_Update_Acct_Entries program unit
    */
    PROCEDURE insert_update_acct_entries(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE,
        iuae_gl_acct_category   GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        iuae_gl_control_acct    GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        iuae_gl_sub_acct_1      GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        iuae_gl_sub_acct_2      GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        iuae_gl_sub_acct_3      GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        iuae_gl_sub_acct_4      GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        iuae_gl_sub_acct_5      GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        iuae_gl_sub_acct_6      GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        iuae_gl_sub_acct_7      GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        iuae_generation_type    GIAC_ACCT_ENTRIES.generation_type%TYPE,
        iuae_gl_acct_id         GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
        iuae_debit_amt          GIAC_ACCT_ENTRIES.debit_amt%TYPE,
        iuae_credit_amt         GIAC_ACCT_ENTRIES.credit_amt%TYPE,
        iuae_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE ,
        iuae_sl_type_cd         GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    )
    IS
        iuae_acct_entry_id      GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
    BEGIN
        SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
          INTO iuae_acct_entry_id
          FROM GIAC_ACCT_ENTRIES
         WHERE gacc_gibr_branch_cd = p_branch_cd
           AND gacc_gfun_fund_cd = p_fund_cd
           AND gacc_tran_id = p_gacc_tran_id
           AND gl_acct_id = iuae_gl_acct_id
           AND gl_acct_category = iuae_gl_acct_category
           AND gl_control_acct = iuae_gl_control_acct  
           AND gl_sub_acct_1 = iuae_gl_sub_acct_1    
           AND gl_sub_acct_2 = iuae_gl_sub_acct_2    
           AND gl_sub_acct_3 = iuae_gl_sub_acct_3    
           AND gl_sub_acct_4 = iuae_gl_sub_acct_4    
           AND gl_sub_acct_5 = iuae_gl_sub_acct_5    
           AND gl_sub_acct_6 = iuae_gl_sub_acct_6    
           AND gl_sub_acct_7 = iuae_gl_sub_acct_7
           AND NVL(sl_cd, 1) = NVL(iuae_sl_cd, 1)
           AND NVL(sl_type_cd,'x') = NVL(iuae_sl_type_cd, 'x') ;
           
        IF NVL(iuae_acct_entry_id,0) = 0 THEN
            iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
            
            INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
                                          gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1,
                                          gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                                          gl_sub_acct_6, gl_sub_acct_7, debit_amt, credit_amt, 
                                          generation_type, sl_cd, sl_type_cd, sl_source_cd, 
                                          user_id, last_update)
            VALUES (p_gacc_tran_id, p_fund_cd, p_branch_cd, iuae_acct_entry_id,
                    iuae_gl_acct_id, iuae_gl_acct_category, iuae_gl_control_acct, iuae_gl_sub_acct_1,
                    iuae_gl_sub_acct_2, iuae_gl_sub_acct_3, iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                    iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_debit_amt, iuae_credit_amt, 
                    iuae_generation_type, iuae_sl_cd, iuae_sl_type_cd, '1',
                    p_user_id, SYSDATE);
        ELSE
            UPDATE GIAC_ACCT_ENTRIES
               SET debit_amt = debit_amt + iuae_debit_amt,
                   credit_amt = credit_amt + iuae_credit_amt
             WHERE generation_type = iuae_generation_type
               AND gl_acct_id = iuae_gl_acct_id
               AND gacc_gibr_branch_cd = p_branch_cd
               AND gacc_gfun_fund_cd = p_fund_cd
               AND gacc_tran_id = p_gacc_tran_id;
        END IF;
    END;
END;
/


