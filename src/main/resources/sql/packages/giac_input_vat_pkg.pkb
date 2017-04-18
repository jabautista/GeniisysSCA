CREATE OR REPLACE PACKAGE BODY CPI.GIAC_INPUT_VAT_PKG
AS
       
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09-20-2010 
    **  Reference By : (GIACS039 - Direct Trans - Input VAT)  
    **  Description  :  get records in GIAC_INPUT_VAT table 
    */
    FUNCTION get_giac_input_vat(p_gacc_tran_id  giac_input_vat.gacc_tran_id%TYPE,
                                p_gacc_fund_cd  giac_sl_lists.fund_cd%TYPE)
    RETURN giac_input_vat_tab PIPELINED IS 
      v_vat   giac_input_vat_type;
      CURSOR c (v_payee_class_cd GIIS_PAYEES.payee_class_cd%TYPE,
                v_payee_no       GIIS_PAYEES.payee_no%TYPE)IS
          SELECT decode(A1280.PAYEE_FIRST_NAME,null,(A1280.PAYEE_LAST_NAME),(
                 A1280.PAYEE_FIRST_NAME||
                ' ' || A1280.PAYEE_MIDDLE_NAME || ' '
                 ||A1280.PAYEE_LAST_NAME)
                 ) payee_name  
           FROM GIIS_PAYEES A1280
          WHERE A1280.PAYEE_CLASS_CD = v_payee_class_cd
            AND A1280.PAYEE_NO = v_payee_no;   
    BEGIN    
        FOR a IN (SELECT giv.gacc_tran_id,      giv.transaction_type,   giv.payee_no,       giv.payee_class_cd,
                         giv.reference_no,      giv.base_amt,           giv.input_vat_amt,  giv.gl_acct_id,
                         giv.vat_gl_acct_id,    giv.item_no,            giv.sl_cd,          giv.or_print_tag,
                         giv.remarks,           giv.user_id,            giv.last_update,    giv.cpi_rec_no,
                         giv.cpi_branch_cd,     giv.vat_sl_cd 
                    FROM giac_input_vat giv
                   WHERE giv.gacc_tran_id = p_gacc_tran_id)
        LOOP           
            v_vat.vat_sl_cd                 := NULL;    -- start SR-18826 : shan 06.25.2015
            v_vat.vat_sl_name               := NULL;
            v_vat.gslt_sl_type_cd           := NULL;
            v_vat.dsp_sl_name               := NULL;    --end  SR-18826 : shan 06.25.2015
            v_vat.gacc_tran_id              := a.gacc_tran_id;      
            v_vat.transaction_type          := a.transaction_type;   
            v_vat.payee_no                  := a.payee_no;      
            v_vat.payee_class_cd            := a.payee_class_cd;
            v_vat.reference_no              := a.reference_no;      
            v_vat.base_amt                  := a.base_amt;          
            v_vat.input_vat_amt             := a.input_vat_amt; 
            v_vat.gl_acct_id                := a.gl_acct_id;
            v_vat.vat_gl_acct_id            := a.vat_gl_acct_id;    
            v_vat.item_no                   := a.item_no;           
            v_vat.sl_cd                     := a.sl_cd;          
            v_vat.or_print_tag              := a.or_print_tag;
            v_vat.remarks                   := a.remarks;           
            v_vat.user_id                   := a.user_id;  
            v_vat.last_update               := a.last_update;    
            v_vat.cpi_rec_no                := a.cpi_rec_no;
            v_vat.cpi_branch_cd             := a.cpi_branch_cd;     
            v_vat.vat_sl_cd                 := a.vat_sl_cd; 
            FOR b IN c(v_vat.payee_class_cd, v_vat.payee_no)
            LOOP
                v_vat.dsp_payee_name := b.payee_name;
            END LOOP;
            FOR sl_rec IN (SELECT DISTINCT sl_name ,sl_cd
                               FROM giac_module_entries aac,
                                    giac_chart_of_accts b,
                                    giac_sl_lists c,
                                    giac_modules d
                              WHERE d.module_name = 'GIACS039'
                                AND aac.module_id = d.module_id
                                AND aac.gl_acct_category = b.gl_acct_category
                                AND aac.gl_control_acct = b.gl_control_acct
                                AND aac.gl_sub_acct_1 = b.gl_sub_acct_1
                                AND aac.gl_sub_acct_2 = b.gl_sub_acct_2
                                AND aac.gl_sub_acct_3 = b.gl_sub_acct_3
                                AND aac.gl_sub_acct_4 = b.gl_sub_acct_4
                                AND aac.gl_sub_acct_5 = b.gl_sub_acct_5
                                AND aac.gl_sub_acct_6 = b.gl_sub_acct_6
                                AND aac.gl_sub_acct_7 = b.gl_sub_acct_7
                                AND b.gslt_sl_type_cd = c.sl_type_cd
                                AND aac.item_no = v_vat.item_no
                                AND c.sl_cd = v_vat.vat_sl_cd)
            LOOP
                v_vat.vat_sl_name := sl_rec.sl_cd ||' - '|| sl_rec.sl_name;
            END LOOP;
            FOR dd IN(SELECT aa.gl_acct_category, aa.gl_control_acct, aa.gl_sub_acct_1,
                             aa.gl_sub_acct_2,    aa.gl_sub_acct_3,   aa.gl_sub_acct_4,
                             aa.gl_sub_acct_5,    aa.gl_sub_acct_6,   aa.gl_sub_acct_7,
                             aa.gl_acct_name,     aa.gl_acct_id,      aa.gslt_sl_type_cd
                        FROM giac_chart_of_accts aa
                       WHERE leaf_tag = 'Y'
                         AND gl_acct_id = v_vat.gl_acct_id)
            LOOP      
                v_vat.gl_acct_category     := dd.gl_acct_category;
                v_vat.gl_control_acct      := dd.gl_control_acct;
                v_vat.gl_sub_acct_1        := dd.gl_sub_acct_1;
                v_vat.gl_sub_acct_2        := dd.gl_sub_acct_2;
                v_vat.gl_sub_acct_3        := dd.gl_sub_acct_3;
                v_vat.gl_sub_acct_4        := dd.gl_sub_acct_4;
                v_vat.gl_sub_acct_5        := dd.gl_sub_acct_5;
                v_vat.gl_sub_acct_6        := dd.gl_sub_acct_6;
                v_vat.gl_sub_acct_7        := dd.gl_sub_acct_7;
                v_vat.gl_acct_name         := dd.gl_acct_name;
                v_vat.gl_acct_id           := dd.gl_acct_id;
                v_vat.gslt_sl_type_cd      := dd.gslt_sl_type_cd;
            END LOOP;
            FOR ee IN (SELECT sl_name
                        FROM giac_sl_lists 
                       WHERE fund_cd = p_gacc_fund_cd
                         AND sl_cd = v_vat.sl_cd
                         AND sl_type_cd = v_vat.gslt_sl_type_cd)
            LOOP
                v_vat.dsp_sl_name := ee.sl_name;
            END LOOP;   
            FOR tran IN (SELECT substr(RV_MEANING,1,15)  RV_MEANING
                           FROM CG_REF_CODES
                          WHERE RV_DOMAIN = 'GIAC_INPUT_VAT.TRANSACTION_TYPE'
                            AND RV_LOW_VALUE = v_vat.transaction_type)
            LOOP
                v_vat.transaction_type_desc := tran.rv_meaning;
            END LOOP;   
            FOR pc IN (SELECT class_desc, payee_class_cd
                         FROM giis_payee_class
                        WHERE payee_class_cd = v_vat.payee_class_cd)
            LOOP            
                v_vat.payee_class_desc := trim(to_char(pc.payee_class_cd,'00'))||' - '||pc.class_desc;
            END LOOP;                   
        PIPE ROW(v_vat);
        END LOOP;     
      RETURN;        
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09-29-2010 
    **  Reference By : (GIACS039 - Direct Trans - Input VAT)  
    **  Description  :  delete records in GIAC_INPUT_VAT table 
    */    
    PROCEDURE del_giac_input_vat(
        p_gacc_tran_id            giac_input_vat.gacc_tran_id%TYPE,
        p_transaction_type        giac_input_vat.transaction_type%TYPE,
        p_payee_no                giac_input_vat.payee_no%TYPE,
        p_payee_class_cd          giac_input_vat.payee_class_cd%TYPE,
        p_reference_no            giac_input_vat.reference_no%TYPE
        ) IS
    BEGIN
        DELETE giac_input_vat
         WHERE gacc_tran_id = p_gacc_tran_id
           AND transaction_type = p_transaction_type
           AND payee_no = p_payee_no
           AND payee_class_cd = p_payee_class_cd
           AND reference_no = p_reference_no;
    END;
        
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09-29-2010 
    **  Reference By : (GIACS039 - Direct Trans - Input VAT)  
    **  Description  :  insert records in GIAC_INPUT_VAT table 
    */     
    PROCEDURE set_giac_input_vat(
        p_gacc_tran_id            giac_input_vat.gacc_tran_id%TYPE,
        p_transaction_type        giac_input_vat.transaction_type%TYPE,
        p_payee_no                giac_input_vat.payee_no%TYPE,
        p_payee_class_cd          giac_input_vat.payee_class_cd%TYPE,
        p_reference_no            giac_input_vat.reference_no%TYPE,
        p_base_amt                giac_input_vat.base_amt%TYPE,
        p_input_vat_amt           giac_input_vat.input_vat_amt%TYPE,
        p_gl_acct_id              giac_input_vat.gl_acct_id%TYPE,
        p_vat_gl_acct_id          giac_input_vat.vat_gl_acct_id%TYPE,
        p_item_no                 giac_input_vat.item_no%TYPE,
        p_sl_cd                   giac_input_vat.sl_cd%TYPE,
        p_or_print_tag            giac_input_vat.or_print_tag%TYPE,
        p_remarks                 giac_input_vat.remarks%TYPE,
        p_user_id                 giac_input_vat.user_id%TYPE,
        p_last_update             giac_input_vat.last_update%TYPE,
        p_cpi_rec_no              giac_input_vat.cpi_rec_no%TYPE,
        p_cpi_branch_cd           giac_input_vat.cpi_branch_cd%TYPE,
        p_vat_sl_cd               giac_input_vat.vat_sl_cd%TYPE
        ) IS 
    BEGIN
        MERGE INTO giac_input_vat
        USING dual
           ON (gacc_tran_id = p_gacc_tran_id
          AND transaction_type = p_transaction_type
          AND payee_no = p_payee_no
          AND payee_class_cd = p_payee_class_cd
          AND reference_no = p_reference_no)
           WHEN NOT MATCHED THEN
                INSERT(gacc_tran_id,      transaction_type,   payee_no,       payee_class_cd,
                       reference_no,      base_amt,           input_vat_amt,  gl_acct_id,
                       vat_gl_acct_id,    item_no,            sl_cd,          or_print_tag,
                       remarks,           user_id,            last_update,    cpi_rec_no,
                       cpi_branch_cd,     vat_sl_cd)
                VALUES(p_gacc_tran_id,      p_transaction_type,   p_payee_no,       p_payee_class_cd,
                       p_reference_no,      p_base_amt,           p_input_vat_amt,  p_gl_acct_id,
                       p_vat_gl_acct_id,    p_item_no,            p_sl_cd,          p_or_print_tag,
                       p_remarks,           p_user_id,            SYSDATE,          p_cpi_rec_no,
                       p_cpi_branch_cd,     p_vat_sl_cd)
           WHEN MATCHED THEN
                UPDATE  
                   SET base_amt             = p_base_amt,     
                       input_vat_amt        = p_input_vat_amt,  
                       gl_acct_id           = p_gl_acct_id,
                       vat_gl_acct_id       = p_vat_gl_acct_id,    
                       item_no              = p_item_no,            
                       sl_cd                = p_sl_cd,          
                       or_print_tag         = p_or_print_tag,
                       remarks              = p_remarks,           
                       user_id              = p_user_id,           
                       last_update          = SYSDATE,    
                       cpi_rec_no           = p_cpi_rec_no,
                       cpi_branch_cd        = p_cpi_branch_cd,     
                       vat_sl_cd            = p_vat_sl_cd;     
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09-30-2010 
    **  Reference By : (GIACS039 - Direct Trans - Input VAT)  
    **  Description  :  update_giac_op_text program unit 
    */   
    PROCEDURE update_giac_op_text(p_gacc_tran_id      IN   giac_input_vat.gacc_tran_id%TYPE,
                                 p_module_name        IN   giac_modules.module_name%TYPE,
                                 p_msg_alert          OUT  VARCHAR2)
        IS
    BEGIN
       DECLARE
          CURSOR c
          IS
             SELECT a.gacc_tran_id, a.user_id, a.last_update,
                    DECODE (a.transaction_type,
                            1, (a.base_amt + a.input_vat_amt) * -1,
                            2, a.base_amt + a.input_vat_amt
                           ) item_amt,
                       LTRIM (TO_CHAR (a.gl_acct_id))
                    || '-'
                    || RTRIM (TO_CHAR (sl_cd))
                    || LTRIM (TO_CHAR (a.gacc_tran_id, '09999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a.payee_no, '099999'))
                    || '-'
                    || LTRIM (a.payee_class_cd, '09')
                    || ' / '
                    || RTRIM (a.reference_no) item_text
               FROM giac_input_vat a
              WHERE a.gacc_tran_id = p_gacc_tran_id;

    --     ORDER BY A.ITEM_NO;
          ws_seq_no             giac_op_text.item_seq_no%TYPE        := 1;
          ws_gen_type           VARCHAR2 (1);
          ws_foreign_curr_amt   giac_op_text.foreign_curr_amt%TYPE;
          ws_currency_cd        giac_op_text.currency_cd%TYPE;
          v_module_id           giac_modules.module_id%TYPE;
          v_msg_alert           VARCHAR2(500) := '';
       BEGIN
          BEGIN
             SELECT module_id, generation_type
               INTO v_module_id, ws_gen_type
               FROM giac_modules
              WHERE module_name = p_module_name;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                v_msg_alert := 'No generation type in module entries.';
                goto exit;
          END;

          BEGIN
             SELECT param_value_n
               INTO ws_currency_cd
               FROM giac_parameters
              WHERE param_name = 'CURRENCY_CD';
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                ws_currency_cd := 1;
          END;

          DELETE FROM giac_op_text
                WHERE gacc_tran_id = p_gacc_tran_id
                  AND item_gen_type = ws_gen_type;

          FOR c_rec IN c
          LOOP
             INSERT INTO giac_op_text
                         (gacc_tran_id, item_seq_no, item_gen_type,
                          item_text, item_amt, user_id,
                          last_update, print_seq_no, foreign_curr_amt,
                          currency_cd
                         )
                  VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_gen_type,
                          c_rec.item_text, c_rec.item_amt, c_rec.user_id,
                          c_rec.last_update, ws_seq_no, c_rec.item_amt,
                          ws_currency_cd
                         );

             ws_seq_no := ws_seq_no + 1;
          END LOOP;
          <<exit>>
          p_msg_alert := v_msg_alert;
       END;
    END;
 
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09-30-2010 
    **  Reference By : (GIACS039 - Direct Trans - Input VAT)  
    **  Description  :  aeg_create_acct_entries program unit 
    */  
    PROCEDURE aeg_create_acct_entries (
       aeg_collection_amt   giac_bank_collns.collection_amt%TYPE,
       aeg_gen_type         giac_acct_entries.generation_type%TYPE,
       aeg_module_id        giac_modules.module_id%TYPE,
       aeg_item_no          giac_module_entries.item_no%TYPE,
       aeg_sl_cd            giac_acct_entries.sl_cd%TYPE,
       aeg_gl_acct_id       giac_acct_entries.gl_acct_id%TYPE,
       aeg_pop_gl_acct_cd   BOOLEAN,
       aeg_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE,
       p_msg_alert      OUT VARCHAR2,
       p_contra_acct        BOOLEAN,
       p_gacc_branch_cd     giac_acct_entries.GACC_GIBR_BRANCH_CD%TYPE,
       p_gacc_fund_cd       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
       p_gacc_tran_id       giac_acct_entries.gacc_tran_id%TYPE
    )
    IS
       ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
       ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
       ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
       ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
       ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
       ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
       ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
       ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
       ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
       ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
       ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
       ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
       ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
       ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
       ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
       ws_line_cd              giis_line.line_cd%TYPE;
       ws_iss_cd               gipi_polbasic.iss_cd%TYPE;
       ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
       ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
       pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
       pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
       pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
       pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
       pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
       pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
       pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
       ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
       ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
       ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
       ws_sl_cd                giac_acct_entries.sl_cd%TYPE;
    BEGIN
       /**************************************************************************
       *                                                                         *
       * Populate the GL Account Code used in every transactions.                *
       *                                                                         *
       **************************************************************************/
       IF aeg_pop_gl_acct_cd
       THEN
          BEGIN
             SELECT        gl_acct_category, gl_control_acct,
                           gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                           gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                           gl_sub_acct_7, pol_type_tag,
                           intm_type_level, old_new_acct_level,
                           dr_cr_tag, line_dependency_level
                      INTO ws_gl_acct_category, ws_gl_control_acct,
                           ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                           ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                           ws_gl_sub_acct_7, ws_pol_type_tag,
                           ws_intm_type_level, ws_old_new_acct_level,
                           ws_dr_cr_tag, ws_line_dep_level
                      FROM giac_module_entries
                     WHERE module_id = aeg_module_id AND item_no = aeg_item_no
             FOR UPDATE OF gl_sub_acct_1;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_msg_alert := 'No data found in giac_module_entries.';
                RETURN;
          END;
       ELSE
          BEGIN
             SELECT DISTINCT (dr_cr_tag)
                        INTO ws_dr_cr_tag
                        FROM giac_module_entries
                       WHERE module_id = aeg_module_id;
          EXCEPTION
             WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
             THEN
                p_msg_alert := 'No data found in giac_module_entries.';
                RETURN;
          END;
       END IF;

      /**************************************************************************
      *                                                                         *
      * Check if the acctg code exists in GIAC_CHART_OF_ACCTS TABLE.            *
      *                                                                         *
      **************************************************************************/
    /*
      AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                               ws_gl_acct_id);

      IF aeg_collection_amt > 0 THEN
         ws_debit_amt  := 0;
         ws_credit_amt := ABS(aeg_collection_amt);
      ELSE
         ws_debit_amt  := ABS(aeg_collection_amt);
         ws_credit_amt := 0;
      END IF;
    */
       IF p_contra_acct = FALSE
       THEN
          IF aeg_collection_amt > 0
          THEN
             IF ws_dr_cr_tag = 'D'
             THEN
                ws_debit_amt := aeg_collection_amt;
                ws_credit_amt := 0;
             ELSE
                ws_credit_amt := aeg_collection_amt;
                ws_debit_amt := 0;
             END IF;
          ELSIF aeg_collection_amt < 0
          THEN
             IF ws_dr_cr_tag = 'D'
             THEN
                ws_credit_amt := ABS (aeg_collection_amt);
                ws_debit_amt := 0;
             ELSE
                ws_debit_amt := ABS (aeg_collection_amt);
                ws_credit_amt := 0;
             END IF;
          END IF;
       ELSE
          IF aeg_collection_amt > 0
          THEN
             IF ws_dr_cr_tag = 'D'
             THEN
                ws_debit_amt := aeg_collection_amt;
                ws_credit_amt := 0;
             ELSE
                ws_credit_amt := aeg_collection_amt;
                ws_debit_amt := 0;
             END IF;
          ELSIF aeg_collection_amt < 0
          THEN
             IF ws_dr_cr_tag = 'D'
             THEN
                ws_credit_amt := ABS (aeg_collection_amt);
                ws_debit_amt := 0;
             ELSE
                ws_debit_amt := ABS (aeg_collection_amt);
                ws_credit_amt := 0;
             END IF;
          ELSIF aeg_collection_amt = 0
          THEN                                                    -- lina 11/22/06
             ws_debit_amt := 0;
             ws_credit_amt := 0;
          END IF;
       END IF;

       /****************************************************************************
       *                                                                           *
       * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
       * same transaction id.  Insert the record if it does not exists else update *
       * the existing record.                                                      *
       *                                                                           *
       ****************************************************************************/
       IF p_contra_acct = FALSE
       THEN
          BEGIN
             SELECT DISTINCT (gl_acct_id)
                        INTO ws_gl_acct_id
                        FROM giac_chart_of_accts
                       WHERE gl_acct_category = ws_gl_acct_category
                         AND gl_control_acct = ws_gl_control_acct
                         AND gl_sub_acct_1 = ws_gl_sub_acct_1
                         AND gl_sub_acct_2 = ws_gl_sub_acct_2
                         AND gl_sub_acct_3 = ws_gl_sub_acct_3
                         AND gl_sub_acct_4 = ws_gl_sub_acct_4
                         AND gl_sub_acct_5 = ws_gl_sub_acct_5
                         AND gl_sub_acct_6 = ws_gl_sub_acct_6
                         AND gl_sub_acct_7 = ws_gl_sub_acct_7;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_msg_alert := 'GL account code '
                        || TO_CHAR (ws_gl_acct_category)
                        || '-'
                        || TO_CHAR (ws_gl_control_acct, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_1, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_2, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_3, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_4, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_5, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_6, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_7, '09')
                        || ' does not exist in Chart of Accounts (Giac_Acctrans).';
                RETURN;
          END;

          BEGIN
             SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                    gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                    gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                    gl_acct_id
               INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                    ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                    ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                    ws_gl_acct_id
               FROM giac_chart_of_accts
              WHERE gl_acct_id = ws_gl_acct_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_msg_alert := 'GL account code '
                        || TO_CHAR (ws_gl_acct_category)
                        || '-'
                        || TO_CHAR (ws_gl_control_acct, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_1, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_2, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_3, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_4, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_5, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_6, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_7, '09')
                        || ' does not exist in Chart of Accounts (Giac_Acctrans).';
                RETURN;        
          END;
       ELSE                                                        /*contra acct*/
          BEGIN
             SELECT DISTINCT (gl_acct_id)
                        INTO ws_gl_acct_id
                        FROM giac_chart_of_accts
                       WHERE gl_acct_id = aeg_gl_acct_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_msg_alert := 'GL account code '
                        || TO_CHAR (ws_gl_acct_category)
                        || '-'
                        || TO_CHAR (ws_gl_control_acct, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_1, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_2, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_3, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_4, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_5, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_6, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_7, '09')
                        || ' does not exist in Chart of Accounts (Giac_Acctrans).';
                RETURN;        
          END;

          BEGIN
             SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                    gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                    gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                    gl_acct_id
               INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                    ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                    ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                    ws_gl_acct_id
               FROM giac_chart_of_accts
              WHERE gl_acct_id = ws_gl_acct_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_msg_alert := 'GL account code '
                        || TO_CHAR (ws_gl_acct_category)
                        || '-'
                        || TO_CHAR (ws_gl_control_acct, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_1, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_2, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_3, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_4, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_5, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_6, '09')
                        || '-'
                        || TO_CHAR (ws_gl_sub_acct_7, '09')
                        || ' does not exist in Chart of Accounts (Giac_Acctrans).';
                 RETURN;       
          END;
       END IF;

       giac_acct_entries_pkg.aeg_insert_update_acct_entries(
                  p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                  ws_gl_acct_category,  ws_gl_control_acct,
                  ws_gl_sub_acct_1,     ws_gl_sub_acct_2,
                  ws_gl_sub_acct_3,     ws_gl_sub_acct_4,
                  ws_gl_sub_acct_5,     ws_gl_sub_acct_6,
                  ws_gl_sub_acct_7,     aeg_sl_cd,      
                  aeg_sl_type_cd,       1,
                  aeg_gen_type,         ws_gl_acct_id,        
                  ws_debit_amt,         ws_credit_amt);
                  
       p_msg_alert := nvl(p_msg_alert, '');           
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09-30-2010 
    **  Reference By : (GIACS039 - Direct Trans - Input VAT)  
    **  Description  :  aeg_parameters program unit 
    */ 
    PROCEDURE aeg_parameters(
               p_gacc_tran_id     giac_acctrans.tran_id%TYPE,
               p_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
               p_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
               p_module_name      giac_modules.module_name%TYPE,
               p_vat_gl_acct_id   giac_input_vat.vat_gl_acct_id%TYPE,
               p_base_amt         giac_input_vat.base_amt%TYPE,
               p_msg_alert    OUT VARCHAR2)
            IS
       v_debit_amt     giac_acct_entries.debit_amt%TYPE;
       v_credit_amt    giac_acct_entries.credit_amt%TYPE;
       ws_sl_type_cd   giac_acct_entries.sl_type_cd%TYPE;
       v_module_id     giac_modules.module_id%TYPE; 
       v_gen_type      giac_modules.generation_type%TYPE;
       v_msg_alert     VARCHAR2(500);
       v_contra_acct   boolean := FALSE;
       
       /*  For Input Vat */
       CURSOR input_vat_cur
       IS
--          SELECT   SUM (input_vat_amt) total, item_no, vat_gl_acct_id, vat_sl_cd
--              FROM giac_input_vat
--             WHERE gacc_tran_id = p_gacc_tran_id
--          GROUP BY item_no, vat_gl_acct_id, vat_sl_cd;  -- replaced with codes below :: SR-18826 : shan 06.25.2015
          SELECT   SUM (input_vat_amt) total, item_no, vat_gl_acct_id, vat_sl_cd, gslt_sl_type_cd
              FROM giac_input_vat a, giac_chart_of_accts b
             WHERE a.vat_gl_acct_id = b.gl_acct_id
               AND a.gacc_tran_id = p_gacc_tran_id
          GROUP BY item_no, vat_gl_acct_id, vat_sl_cd, gslt_sl_type_cd;

       CURSOR contra_acct_entries_cur
       IS
          /*SELECT sum(base_amt) total_a,item_no, gl_acct_id, sl_cd
            FROM giac_input_vat
           WHERE gacc_tran_id =  aeg_tran_id
           GROUP BY item_no, gl_acct_id, sl_cd;*/
          SELECT   SUM (a.base_amt) total_a, a.gl_acct_id, a.sl_cd,
                   b.gslt_sl_type_cd
              FROM giac_input_vat a, giac_chart_of_accts b
             WHERE a.gacc_tran_id = p_gacc_tran_id AND a.gl_acct_id = b.gl_acct_id
          GROUP BY a.gl_acct_id, a.sl_cd, b.gslt_sl_type_cd;
    BEGIN
       BEGIN
          SELECT module_id, generation_type
            INTO v_module_id, v_gen_type
            FROM giac_modules
           WHERE module_name = p_module_name;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             p_msg_alert := 'No data found in GIAC MODULES.';
             RETURN;
       END;

       /*
       ** Call the deletion of accounting entry procedure.
       */
       --
       --
       giac_acct_entries_pkg.aeg_delete_acct_entries(p_gacc_tran_id, v_gen_type);
      --
      --
    /***CONTRA_ACCT:= FALSE---FOR THE ITEM_NO ENTRIES*****/
    /***CONTRA_ACCT:= TRUE ---FOR MODULE_ENTRIES ******/
       v_contra_acct := FALSE;

       FOR input_vat_rec IN input_vat_cur
       LOOP
          /*
          ** Call the accounting entry generation procedure.
          */
          BEGIN
             SELECT gslt_sl_type_cd
               INTO ws_sl_type_cd
               FROM giac_chart_of_accts
              WHERE gl_acct_id = p_vat_gl_acct_id;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                ws_sl_type_cd := NULL;
          END;

          aeg_create_acct_entries(input_vat_rec.total,
                                   v_gen_type,
                                   v_module_id,
                                   input_vat_rec.item_no,
                                   input_vat_rec.vat_sl_cd,
                                   input_vat_rec.vat_gl_acct_id,
                                   TRUE,
                                   input_vat_rec.gslt_sl_type_cd, --ws_sl_type_cd,  -- SR-18826 : shan 06.25.2015
                                   v_msg_alert,
                                   v_contra_acct,
                                   p_gacc_branch_cd,
                                   p_gacc_fund_cd,
                                   p_gacc_tran_id
                                  );
          IF p_msg_alert IS NOT NULL THEN
            p_msg_alert := v_msg_alert;
            RETURN;
          END IF;
          ws_sl_type_cd := NULL;
       END LOOP;

       v_contra_acct := TRUE;

       FOR contra_acct_entries_rec IN contra_acct_entries_cur
       LOOP
          --added by rochelle, 05282007 : not to generate acctng entries in giacs030
          --when base amount is zero
          IF p_base_amt <> 0
          THEN
             aeg_create_acct_entries (contra_acct_entries_rec.total_a,
                                      v_gen_type,
                                      v_module_id,
                                      NULL,
                                      contra_acct_entries_rec.sl_cd,
                                      contra_acct_entries_rec.gl_acct_id,
                                      FALSE,
                                      contra_acct_entries_rec.gslt_sl_type_cd,
                                      v_msg_alert,
                                      v_contra_acct,
                                      p_gacc_branch_cd,
                                      p_gacc_fund_cd,
                                      p_gacc_tran_id
                                     );
             IF p_msg_alert IS NOT NULL THEN
                p_msg_alert := v_msg_alert;
                RETURN;
             END IF;                        
          END IF;                                                            --end
       END LOOP;

       v_contra_acct := FALSE;
    END;
  
END;
/


