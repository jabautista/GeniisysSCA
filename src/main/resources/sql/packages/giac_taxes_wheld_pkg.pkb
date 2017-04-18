CREATE OR REPLACE PACKAGE BODY CPI.GIAC_TAXES_WHELD_PKG
AS

  /*
  **  Created by    : Emman
  **  Date Created     : 12.01.2010
  **  Reference By     : (GIACS022 - Other Trans Withholding Tax)
  **  Description     : Gets the list of GIAC_TAXES_WHELD records of specified tran Id 
  */
  FUNCTION get_giac_taxes_wheld (p_gacc_tran_id        GIAC_TAXES_WHELD.gacc_tran_id%TYPE)
    RETURN giac_taxes_wheld_tab PIPELINED
  IS
    v_taxes_wheld                giac_taxes_wheld_type;
	v_class_desc				 GIIS_PAYEE_CLASS.class_desc%TYPE;	
  BEGIN
    FOR i IN (SELECT gtwh.gacc_tran_id,      gtwh.or_print_tag,   gtwh.item_no,
                    gtwh.payee_class_cd, gtwh.payee_cd,                   gtwh.sl_cd,
                    gtwh.income_amt,     gtwh.wholding_tax_amt,   gtwh.remarks,
                    gtwh.gen_type,         gtwh.gwtx_whtax_id,        gtwh.user_id,
                    gtwh.last_update,     gtwh.sl_type_cd,
                    gwta.whtax_code dsp_whtax_code,         gwta.bir_tax_cd dsp_bir_tax_cd,
                    gwta.percent_rate dsp_percent_rate,     gwta.whtax_desc dsp_whtax_desc
               FROM GIAC_TAXES_WHELD gtwh, GIAC_WHOLDING_TAXES gwta
              WHERE gtwh.gacc_tran_id = p_gacc_tran_id
                AND gwta.whtax_id (+) = gtwh.gwtx_whtax_id)
    LOOP
       v_taxes_wheld.gacc_tran_id                    := i.gacc_tran_id;
       v_taxes_wheld.or_print_tag                   := i.or_print_tag;
       v_taxes_wheld.item_no                       := i.item_no;
       v_taxes_wheld.payee_class_cd                   := i.payee_class_cd;
       v_taxes_wheld.payee_cd                       := i.payee_cd;
       v_taxes_wheld.sl_cd                           := i.sl_cd;
       v_taxes_wheld.income_amt                       := i.income_amt;
       v_taxes_wheld.wholding_tax_amt               := i.wholding_tax_amt;
       v_taxes_wheld.remarks                       := i.remarks;
       v_taxes_wheld.gen_type                       := i.gen_type;
       v_taxes_wheld.gwtx_whtax_id                   := i.gwtx_whtax_id;
       v_taxes_wheld.user_id                       := i.user_id;
       v_taxes_wheld.last_update                   := i.last_update;
       v_taxes_wheld.sl_type_cd                       := i.sl_type_cd;       
       v_taxes_wheld.dsp_whtax_code                   := i.dsp_whtax_code;
       v_taxes_wheld.dsp_bir_tax_cd                   := i.dsp_bir_tax_cd;
       v_taxes_wheld.dsp_percent_rate               := i.dsp_percent_rate;
       v_taxes_wheld.dsp_whtax_desc                 := i.dsp_whtax_desc;
	    
		--added by steven 06.08.2012
		SELECT  class_desc
			INTO v_class_desc
        		FROM giis_payee_class
					WHERE payee_class_cd=i.payee_class_cd;
                
       v_taxes_wheld.class_desc						:=v_class_desc;
       GIIS_PAYEES_PKG.get_payee_name(v_taxes_wheld.payee_class_cd,
                                      v_taxes_wheld.payee_cd,
                                      v_taxes_wheld.dsp_payee_first_name,
                                      v_taxes_wheld.dsp_payee_middle_name,
                                      v_taxes_wheld.dsp_payee_last_name);
         
       IF v_taxes_wheld.dsp_payee_first_name IS NULL THEN
             v_taxes_wheld.drv_payee_cd := v_taxes_wheld.dsp_payee_last_name;
       ELSE
              v_taxes_wheld.drv_payee_cd := rtrim(v_taxes_wheld.dsp_payee_first_name) || ' ' ||
                             rtrim(v_taxes_wheld.dsp_payee_middle_name) || ' ' ||
                             rtrim(v_taxes_wheld.dsp_payee_last_name);
       END IF;
       
       v_taxes_wheld.sl_name   := GIAC_SL_LISTS_PKG.get_sl_name(v_taxes_wheld.sl_type_cd, v_taxes_wheld.sl_cd);
       
       PIPE ROW(v_taxes_wheld);
    END LOOP;
  END get_giac_taxes_wheld;
  
  /*
  **  Created by    : Emman
  **  Date Created     : 12.06.2010
  **  Reference By     : (GIACS022 - Other Trans Withholding Tax)
  **  Description     : Save (Insert/Update) GIAC Taxes Wheld record
  */
  PROCEDURE set_giac_taxes_wheld(p_gacc_tran_id            GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
                                   p_item_no                GIAC_TAXES_WHELD.item_no%TYPE,
                                 p_payee_class_cd        GIAC_TAXES_WHELD.payee_class_cd%TYPE,
                                 p_payee_cd                GIAC_TAXES_WHELD.payee_cd%TYPE,
                                 p_sl_cd                GIAC_TAXES_WHELD.sl_cd%TYPE,
                                 p_income_amt            GIAC_TAXES_WHELD.income_amt%TYPE,
                                 p_wholding_tax_amt        GIAC_TAXES_WHELD.wholding_tax_amt%TYPE,
                                 p_remarks                GIAC_TAXES_WHELD.remarks%TYPE,
                                 p_gwtx_whtax_id        GIAC_TAXES_WHELD.gwtx_whtax_id%TYPE,
                                 p_sl_type_cd            GIAC_TAXES_WHELD.sl_type_cd%TYPE,
                                 p_or_print_tag            GIAC_TAXES_WHELD.or_print_tag%TYPE,
                                 p_gen_type                GIAC_TAXES_WHELD.gen_type%TYPE,
                                 p_user_id                GIAC_TAXES_WHELD.user_id%TYPE,
                                 p_last_update            GIAC_TAXES_WHELD.last_update%TYPE)
  IS
  BEGIN
         MERGE INTO GIAC_TAXES_WHELD
       USING DUAL ON (gacc_tran_id        = p_gacc_tran_id
                     AND  item_no            = p_item_no
                 AND  payee_class_cd    = p_payee_class_cd
                 AND  payee_cd            = p_payee_cd)
       WHEN NOT MATCHED THEN
               INSERT (gacc_tran_id,        item_no,           payee_class_cd,            payee_cd,
                    sl_cd,                income_amt,          wholding_tax_amt,            remarks,
                    gwtx_whtax_id,        sl_type_cd,          or_print_tag,                gen_type,
                    user_id,            last_update)
            VALUES (p_gacc_tran_id,        p_item_no,           p_payee_class_cd,            p_payee_cd,
                    p_sl_cd,            p_income_amt,      p_wholding_tax_amt,        p_remarks,
                    p_gwtx_whtax_id,    p_sl_type_cd,      p_or_print_tag,            p_gen_type,
                    p_user_id,            p_last_update)
       WHEN MATCHED THEN
           UPDATE SET  sl_cd                = p_sl_cd,
                    income_amt            = p_income_amt,
                    wholding_tax_amt    = p_wholding_tax_amt,
                    remarks                = p_remarks,
                    gwtx_whtax_id        = p_gwtx_whtax_id,
                    sl_type_cd            = p_sl_type_cd,
                    or_print_tag        = p_or_print_tag,
                    gen_type            = p_gen_type,
                    user_id                = p_user_id,
                    last_update            = p_last_update;
  END set_giac_taxes_wheld;
  
  /*
  **  Created by    : Emman
  **  Date Created     : 12.06.2010
  **  Reference By     : (GIACS022 - Other Trans Withholding Tax)
  **  Description     : Deletes GIAC Taxes Wheld record
  */
  PROCEDURE del_giac_taxes_wheld(p_gacc_tran_id            GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
                                   p_item_no                GIAC_TAXES_WHELD.item_no%TYPE,
                                 p_payee_class_cd        GIAC_TAXES_WHELD.payee_class_cd%TYPE,
                                 p_payee_cd                GIAC_TAXES_WHELD.payee_cd%TYPE)
  IS
  BEGIN
         DELETE
         FROM GIAC_TAXES_WHELD
        WHERE gacc_tran_id        = p_gacc_tran_id
            AND item_no            = p_item_no
          AND payee_class_cd    = p_payee_class_cd
          AND payee_cd            = p_payee_cd;
  END del_giac_taxes_wheld;
  
  /*
  **  Created by    : Emman
  **  Date Created     : 12.07.2010
  **  Reference By     : (GIACS022 - Other Trans Withholding Tax)
  **  Description     : Executes the POST-FORMS-COMMIT trigger of GIACS022
  */
    PROCEDURE giacs022_post_forms_commit(p_gacc_tran_id        IN       GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
                                         p_gacc_branch_cd   IN       GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                                         p_gacc_fund_cd     IN        GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                                                p_var_module_name    IN       GIAC_MODULES.module_name%TYPE,
                                         p_tran_source        IN       VARCHAR2,
                                         p_or_flag            IN       VARCHAR2,
                                                p_message               OUT VARCHAR2)
    IS
    BEGIN
      p_message := 'SUCCESS';
      
      if p_tran_source IN ('OP','OR') then
        IF p_or_flag = 'P' THEN
          NULL;
        ELSE
          GIAC_OP_TEXT_PKG.update_giac_op_text_giacs022(p_gacc_tran_id);
        END IF;
      elsif p_tran_source = 'DV' then
        GIAC_DV_TEXT_PKG.update_giac_dv_text_giacs022(p_gacc_tran_id);
      end if;
    
      /* Creation of accounting entries...*/
      BEGIN
        GIAC_ACCT_ENTRIES_PKG.aeg_parameters_giacs022(
                                    p_gacc_tran_id,
                                    p_gacc_branch_cd,
                                    p_gacc_fund_cd,
                                           p_var_module_name,
                                           p_message);
      END;  
    END giacs022_post_forms_commit;

END GIAC_TAXES_WHELD_PKG;
/


