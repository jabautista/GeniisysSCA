CREATE OR REPLACE PACKAGE BODY CPI.GIAC_COMM_PAYTS_PKG
AS

  /*
  **  Created by   :  Emman
  **  Date Created :  09.07.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  : Gets GIAC Comm Payts details of specified transaction Id 
  */ 
  FUNCTION get_giac_comm_payts (
  		   p_gacc_tran_id		GIAC_COMM_PAYTS.gacc_tran_id%TYPE
		  ) RETURN giac_comm_payts_tab PIPELINED
  IS
  	v_giac_comm_payts				   giac_comm_payts_type;
	v_par_id						   GIPI_POLBASIC.par_id%TYPE;
  BEGIN
  	FOR i IN (SELECT gcop.gacc_tran_id, gcop.tran_type, gcop.iss_cd, gcop.prem_seq_no, gcop.intm_no,
                        gcop.comm_amt, gcop.input_vat_amt, gcop.wtax_amt, gcop.print_tag, gcop.def_comm_tag, 
                     gcop.particulars, gcop.currency_cd, gcur.currency_desc curr_desc, gcop.convert_rate,
                     gcop.foreign_curr_amt, gcop.parent_intm_no, gcop.user_id, gcop.last_update,
                     gcop.comm_tag, gcop.record_no, gcop.disb_comm, record_seq_no --added by robert SR 19752 07.28.15 
                  FROM giac_comm_payts gcop, giis_currency gcur
               WHERE gcop.gacc_tran_id = p_gacc_tran_id
                 AND gcop.currency_cd = gcur.main_currency_cd (+)) 
    LOOP
        v_giac_comm_payts.gacc_tran_id                          := i.gacc_tran_id;
        v_giac_comm_payts.tran_type                              := i.tran_type;
        v_giac_comm_payts.iss_cd                              := i.iss_cd;
        v_giac_comm_payts.prem_seq_no                          := i.prem_seq_no;
        v_giac_comm_payts.intm_no                              := i.intm_no;
        v_giac_comm_payts.comm_amt                              := i.comm_amt;
        v_giac_comm_payts.input_vat_amt                          := i.input_vat_amt;
        v_giac_comm_payts.wtax_amt                              := i.wtax_amt;
        v_giac_comm_payts.print_tag                              := i.print_tag;
        v_giac_comm_payts.def_comm_tag                          := i.def_comm_tag;
        v_giac_comm_payts.particulars                          := i.particulars;
        v_giac_comm_payts.currency_cd                          := i.currency_cd;
        v_giac_comm_payts.curr_desc                              := i.curr_desc;
        v_giac_comm_payts.convert_rate                          := i.convert_rate;
        v_giac_comm_payts.foreign_curr_amt                      := i.foreign_curr_amt;
        v_giac_comm_payts.parent_intm_no                      := i.parent_intm_no;
        v_giac_comm_payts.user_id                              := i.user_id;
        v_giac_comm_payts.last_update                          := i.last_update;
        v_giac_comm_payts.comm_tag                              := i.comm_tag;
        v_giac_comm_payts.record_no                              := i.record_no;
        v_giac_comm_payts.disb_comm                              := i.disb_comm;
        v_giac_comm_payts.record_seq_no                          := i.record_seq_no;  --added by robert SR 19752 07.28.15      
        v_giac_comm_payts.drv_comm_amt := NVL(i.comm_amt + i.input_vat_amt - i.wtax_amt, 0);
        
        FOR c IN (SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                       to_char(a.issue_yy)||'-'||to_char(a.pol_seq_no)||'-'||
                       to_char(a.renew_no)||'\'||a.endt_iss_cd||'-'||to_char(a.endt_yy)||
                       '-'||to_char(a.endt_seq_no) POLICY_NO
                     FROM gipi_polbasic  a, gipi_comm_invoice b
                   WHERE a.policy_id = b.policy_id
                     AND b.iss_cd      = i.iss_cd
                     AND b.prem_seq_no = i.prem_seq_no )
        LOOP
           v_giac_comm_payts.dsp_line_cd := c.policy_no;
        END LOOP;
        
        FOR d IN (SELECT a.policy_id, b.intm_name
                        ,b250.assd_no, B250.par_id
                    FROM GIPI_COMM_INVOICE a, GIIS_INTERMEDIARY b, GIPI_POLBASIC B250
                   WHERE  a.intrmdry_intm_no = v_giac_comm_payts.intm_no
                     AND  a.ISS_CD            = v_giac_comm_payts.iss_cd
                     AND  a.prem_seq_no        = v_giac_comm_payts.prem_seq_no
                     AND  b.intm_no            = a.INTRMDRY_INTM_NO
                     AND  b250.policy_id        = a.policy_id)
        LOOP
            v_giac_comm_payts.dsp_policy_id            := d.policy_id;
            v_giac_comm_payts.dsp_intm_name         := d.intm_name;
            v_giac_comm_payts.dsp_assd_no         := d.assd_no;
            v_par_id                             := d.par_id;
        END LOOP;
        
        FOR e IN (SELECT assd_no
                    FROM GIPI_PARLIST
                   WHERE par_id = v_par_id)
        LOOP
            v_giac_comm_payts.dsp_assd_no            := e.assd_no;
        END LOOP;
         
        FOR f IN (SELECT assd_name
                    FROM GIIS_ASSURED
                   WHERE assd_no = v_giac_comm_payts.dsp_assd_no)
        LOOP
            v_giac_comm_payts.dsp_assd_name           := f.assd_name;
        END LOOP;
        
        v_giac_comm_payts.bill_gacc_tran_id := NULL;
         
        FOR h IN (SELECT gacc_tran_id       -- to retrieve original gacc_tran_id of reversal bill. for comparison purposes : shan 10.03.2014
                    FROM giac_comm_payts
                   WHERE iss_cd = i.iss_cd
                     AND prem_seq_no = i.prem_seq_no
                     AND intm_no = i.intm_no
                     AND (-1 * comm_amt) = i.comm_amt)
        LOOP
            v_giac_comm_payts.bill_gacc_tran_id := h.gacc_tran_id;
        END LOOP;
            
        PIPE ROW(v_giac_comm_payts);
    END LOOP;
  END get_giac_comm_payts;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  09.08.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  : Gets the initial values of some variables to be used in the whole module
  **                   Some codes here are derived from the codes from WHEN-NEW-FORM-INSTANCE
  */ 
  PROCEDURE get_giacs020_basic_var_values (
    p_gacc_tran_id                          IN  GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
	p_user_id								IN	GIAC_USER_FUNCTIONS.user_id%TYPE,
    p_comm_payable_param                    OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_assd_no                          	OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_intm_no                          	OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_item_no                          	OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
    p_var_item_no_2                         OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
    p_var_item_no_3                         OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
    p_var_line_cd                          	OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_module_id                         OUT GIAC_MODULES.module_id%TYPE,
    p_var_gen_type                          OUT GIAC_MODULES.generation_type%TYPE,
    p_var_sl_type_cd_1                      OUT GIAC_PARAMETERS.param_name%TYPE,
    p_var_sl_type_cd_2                      OUT GIAC_PARAMETERS.param_name%TYPE,
    p_var_sl_type_cd_3                      OUT GIAC_PARAMETERS.param_name%TYPE,
    p_var_input_vat_param                  	OUT GIAC_PARAMETERS.param_value_n%TYPE,
    p_is_user_exist                         OUT VARCHAR2,
    p_tran_source_comm_tag                  OUT GIAC_COMM_PAYTS.comm_tag%TYPE,
    p_tran_type_lov                         OUT GIAC_COMM_PAYTS_PKG.tran_type_lov_cur,
    p_iss_cd_lov                          	OUT GIIS_ISSOURCE_PKG.issue_source_acctg_list_cur
  ) IS
    v_sl_type1   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    v_sl_type2   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;  
    v_sl_type3   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE; 
    v_comm_exp   VARCHAR2(1);
  BEGIN
    
    p_comm_payable_param := GIAC_PARAMETERS_PKG.v('COMM_PAYMENT');
    p_var_assd_no         := GIAC_PARAMETERS_PKG.v('ASSD_SL_TYPE');
    p_var_intm_no         := GIAC_PARAMETERS_PKG.v('INTM_SL_TYPE');
    p_var_line_cd         := GIAC_PARAMETERS_PKG.v('LINE_SL_TYPE');
    
    v_comm_exp := GIAC_PARAMETERS_PKG.v('COMM_EXP_GEN'); -- Added by Jerome 09.27.2016 SR 5664
    
    IF v_comm_exp = 'Y' THEN -- Added by Jerome 09.27.2016 SR 5664
       p_var_item_no := 6;
    ELSE
       p_var_item_no := 1;
    END IF;
    
    --p_var_item_no         := 1;
    --p_var_item_no_2         := 4; --Commented out by Jerome 09.28.2016 SR 5664 as per Ma'am Juday - exclude item no 4 in checking of sl_type
    p_var_item_no_2          := 6;
    p_var_item_no_3         := 5;
    
    BEGIN
         SELECT module_id,
                generation_type
           INTO p_var_module_id,
                p_var_gen_type
           FROM giac_modules
          WHERE module_name  = 'GIACS020';
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
               p_var_module_id := NULL;
              p_var_gen_type  := NULL;
    END;
    
    v_sl_type1  := GIAC_MODULE_ENTRIES_PKG.get_sl_type_cd(p_var_module_id, p_var_item_no);
    v_sl_type2  := GIAC_MODULE_ENTRIES_PKG.get_sl_type_cd(p_var_module_id, p_var_item_no_2);
    v_sl_type3  := GIAC_MODULE_ENTRIES_PKG.get_sl_type_cd(p_var_module_id, p_var_item_no_3);
    
    IF v_sl_type1 = p_var_assd_no then
       p_var_sl_type_cd_1 := 'ASSD_SL_TYPE';
    ELSIF v_sl_type1 = p_var_intm_no THEN
       p_var_sl_type_cd_1 := 'INTM_SL_TYPE' ; 
    ELSIF v_sl_type1 = p_var_line_cd THEN
       p_var_sl_type_cd_1 := 'LINE_SL_TYPE';
    END IF;
    
    IF v_sl_type2 = p_var_assd_no then
       p_var_sl_type_cd_2 := 'ASSD_SL_TYPE';
    ELSIF v_sl_type2 = p_var_intm_no THEN
       p_var_sl_type_cd_2 := 'INTM_SL_TYPE' ; 
    ELSIF v_sl_type2 = p_var_line_cd THEN
       p_var_sl_type_cd_2 := 'LINE_SL_TYPE';
    END IF;
    
    IF v_sl_type3 = p_var_assd_no then
       p_var_sl_type_cd_3 := 'ASSD_SL_TYPE';
    ELSIF v_sl_type3 = p_var_intm_no THEN
       p_var_sl_type_cd_3 := 'INTM_SL_TYPE' ; 
    ELSIF v_sl_type3 = p_var_line_cd THEN
       p_var_sl_type_cd_3 := 'LINE_SL_TYPE';
    END IF;
    
    p_is_user_exist := GIAC_USER_FUNCTIONS_PKG.validate_user2('MC', 'MANAGEMENT_COMP%', 'GIACS020', 'Y', p_user_id);
    
    p_var_input_vat_param := NVL(GIAC_PARAMETERS_PKG.n('INPUT_VAT_RT'), 0)/100;
    
    BEGIN
        SELECT comm_tag
          INTO p_tran_source_comm_tag
          FROM giac_payt_requests_dtl
         WHERE tran_id = p_gacc_tran_id; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_tran_source_comm_tag := 'N';
    END;
    
    OPEN p_tran_type_lov FOR
         SELECT rv_low_value, rv_meaning
           FROM cg_ref_codes
          WHERE rv_domain = 'GIAC_COMM_PAYTS.TRAN_TYPE'
       ORDER BY rv_low_value;
    
    OPEN p_iss_cd_lov FOR
         SELECT iss_cd, iss_name, user_iss_cd_access
           FROM TABLE(GIIS_ISSOURCE_PKG.get_iss_cd_for_comm_invoice('GIACS020', p_user_id));
    
  END get_giacs020_basic_var_values;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  09.29.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  :  Save (Insert/Update) GIAC Comm Payts record
  */ 
  PROCEDURE set_giac_comm_payts(p_gacc_tran_id            GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                  p_intm_no                GIAC_COMM_PAYTS.intm_no%TYPE,
                                p_iss_cd                    GIAC_COMM_PAYTS.iss_cd%TYPE,
                                p_prem_seq_no                GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                p_tran_type                GIAC_COMM_PAYTS.tran_type%TYPE,
                                p_comm_amt                GIAC_COMM_PAYTS.comm_amt%TYPE,
                                p_wtax_amt                GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                p_input_vat_amt            GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                                p_user_id                    GIAC_COMM_PAYTS.user_id%TYPE,
                                p_last_update                GIAC_COMM_PAYTS.last_update%TYPE,
                                p_particulars                GIAC_COMM_PAYTS.particulars%TYPE,
                                p_currency_cd                GIAC_COMM_PAYTS.currency_cd%TYPE,
                                p_convert_rate            GIAC_COMM_PAYTS.convert_rate%TYPE,
                                p_foreign_curr_amt        GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                                p_def_comm_tag            GIAC_COMM_PAYTS.def_comm_tag%TYPE,
                                p_print_tag                GIAC_COMM_PAYTS.print_tag%TYPE,
                                p_parent_intm_no            GIAC_COMM_PAYTS.parent_intm_no%TYPE,
                                p_comm_tag                GIAC_COMM_PAYTS.comm_tag%TYPE,
                                p_record_no                GIAC_COMM_PAYTS.record_no%TYPE,
                                p_disb_comm                GIAC_COMM_PAYTS.disb_comm%TYPE,
                                p_record_seq_no            GIAC_COMM_PAYTS.record_seq_no%TYPE) --added by robert SR 19752 07.28.15
  IS
  BEGIN
         MERGE INTO GIAC_COMM_PAYTS
       USING DUAL ON (gacc_tran_id    = p_gacc_tran_id
                      AND intm_no        = p_intm_no
                  AND iss_cd        = p_iss_cd
                  AND prem_seq_no    = p_prem_seq_no
				  AND comm_tag       = p_comm_tag  --added by robert SR 19752 07.28.15
                  AND record_no      = p_record_no  --added by robert SR 19752 07.28.15
                  AND record_seq_no = p_record_seq_no) --added by robert SR 19752 07.28.15
       WHEN NOT MATCHED THEN
                INSERT (gacc_tran_id, intm_no, iss_cd, prem_seq_no,
                      tran_type, comm_amt, wtax_amt, input_vat_amt,
                     user_id, last_update, particulars, currency_cd,
                     convert_rate, foreign_curr_amt, def_comm_tag, print_tag,
                     parent_intm_no, comm_tag, record_no, disb_comm, record_seq_no)  --added record_seq_no by robert SR 19752 07.28.15
             VALUES (p_gacc_tran_id, p_intm_no, p_iss_cd, p_prem_seq_no,
                      p_tran_type, p_comm_amt, p_wtax_amt, p_input_vat_amt,
                     p_user_id, p_last_update, p_particulars, p_currency_cd,
                     p_convert_rate, p_foreign_curr_amt, p_def_comm_tag, p_print_tag,
                     p_parent_intm_no, p_comm_tag, p_record_no, p_disb_comm, p_record_seq_no) --added record_seq_no by robert SR 19752 07.28.15
       WHEN MATCHED THEN
             UPDATE SET tran_type           = p_tran_type,
                        comm_amt           = p_comm_amt,
                     wtax_amt           = p_wtax_amt,
                     input_vat_amt       = p_input_vat_amt,
                     user_id           = p_user_id,
                     last_update       = p_last_update,
                     particulars       = p_particulars,
                     currency_cd       = p_currency_cd,
                     convert_rate       = p_convert_rate,
                     foreign_curr_amt  = p_foreign_curr_amt,
                     def_comm_tag       = p_def_comm_tag,
                     print_tag           = p_print_tag,
                     parent_intm_no       = p_parent_intm_no,
                     --comm_tag           = p_comm_tag, //removed by robert SR 19752 07.28.15
                     --record_no           = p_record_no, //removed by robert SR 19752 07.28.15
                     disb_comm           = p_disb_comm;
  END set_giac_comm_payts;
  /*
  **  Created by   :  Emman
  **  Date Created :  09.29.2010
  **  Reference By : (GIACS026 - Premium Deposit)
  **  Description  : Delete GIAC Comm Payts record
  */ 
  PROCEDURE del_giac_comm_payts(p_gacc_tran_id            GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                  p_intm_no                GIAC_COMM_PAYTS.intm_no%TYPE,
                                p_iss_cd                GIAC_COMM_PAYTS.iss_cd%TYPE,
                                p_prem_seq_no            GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                p_comm_tag                GIAC_COMM_PAYTS.comm_tag%TYPE, --added by robert SR 19752 07.28.15
                                p_record_no                GIAC_COMM_PAYTS.record_no%TYPE, --added by robert SR 19752 07.28.15
                                p_record_seq_no            GIAC_COMM_PAYTS.record_seq_no%TYPE) --added by robert SR 19752 07.28.15
  IS
  BEGIN
         DELETE
         FROM GIAC_COMM_PAYTS
        WHERE gacc_tran_id = p_gacc_tran_id
          AND intm_no = p_intm_no
          AND iss_cd = p_iss_cd
          AND prem_seq_no = p_prem_seq_no
		  AND comm_tag = p_comm_tag --added by robert SR 19752 07.28.15
          AND record_no = p_record_no --added by robert SR 19752 07.28.15
		  AND record_seq_no = p_record_seq_no; --added by robert SR 19752 07.28.15
  END;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  09.13.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  :  Gets list of bill nos
  */ 
  FUNCTION get_bill_no_list (p_tran_type      NUMBER,
                                   p_iss_cd          GIAC_COMM_PAYTS.iss_cd%TYPE,
                                   p_gacc_tran_id      GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                             p_bill_no          VARCHAR2)
   RETURN bill_no_list_tab PIPELINED
  IS
      v_bill               bill_no_list_type;
  BEGIN
      IF p_tran_type = 1 THEN
       FOR i IN (SELECT A.ISS_CD||TO_CHAR(A.PREM_SEQ_NO)||TO_CHAR(A.INTRMDRY_INTM_NO) HO_PREM,A.PREM_SEQ_NO,
                               A.ISS_CD, A.PREM_SEQ_NO BILL 
                  FROM GIPI_COMM_INVOICE A 
                 WHERE A.COMMISSION_AMT >= 0 
                   AND EXISTS (SELECT 'X' 
                                       FROM GIAC_DIRECT_PREM_COLLNS 
                                WHERE B140_ISS_CD = A.ISS_CD 
                                  AND B140_PREM_SEQ_NO = A.PREM_SEQ_NO) 
                   AND INTRMDRY_INTM_NO = (SELECT MIN(INTRMDRY_INTM_NO) 
                                                   FROM GIPI_COMM_INVOICE 
                                            WHERE ISS_CD = A.ISS_CD 
                                              AND PREM_SEQ_NO = A.PREM_SEQ_NO)
                   AND NOT EXISTS (SELECT 'X'
                                           FROM TABLE(GIAC_COMM_PAYTS_PKG.get_giac_comm_payts(p_gacc_tran_id)) gcop
                                    WHERE gcop.iss_cd = a.iss_cd
                                      AND gcop.prem_seq_no = a.prem_seq_no
                                        AND gcop.intm_no = a.intrmdry_intm_no)
                   AND A.ISS_CD = p_iss_cd
                   AND TO_CHAR(A.PREM_SEQ_NO) LIKE '%'||p_bill_no||'%'
                ORDER BY bill
       ) LOOP
              v_bill.ho_prem      := i.ho_prem;
           v_bill.prem_seq_no := i.prem_seq_no;
           v_bill.iss_cd      := i.iss_cd;
           v_bill.bill          := i.bill;
           
           PIPE ROW(v_bill);
       END LOOP;
    ELSIF p_tran_type = 2 THEN
       FOR i IN (SELECT A.ISS_CD||TO_CHAR(A.PREM_SEQ_NO)||TO_CHAR(A.INTM_NO) HO_PREM, A.PREM_SEQ_NO,
                               A.ISS_CD, A.PREM_SEQ_NO BILL 
                  FROM GIAC_COMM_PAYTS A 
                 WHERE A.TRAN_TYPE = 1 
                   AND A.GACC_TRAN_ID = (SELECT MIN(GACC_TRAN_ID) 
                                                   FROM GIAC_COMM_PAYTS 
                                          WHERE ISS_CD = A.ISS_CD 
                                            AND PREM_SEQ_NO = A.PREM_SEQ_NO)
                   AND NOT EXISTS (SELECT 'X'
                                           FROM TABLE(GIAC_COMM_PAYTS_PKG.get_giac_comm_payts(p_gacc_tran_id)) gcop
                                    WHERE gcop.iss_cd = a.iss_cd
                                      AND gcop.prem_seq_no = a.prem_seq_no
                                        AND gcop.intm_no = a.intm_no)
                   AND A.ISS_CD = p_iss_cd
                   AND TO_CHAR(A.PREM_SEQ_NO) LIKE '%'||p_bill_no||'%'
                ORDER BY bill
       ) LOOP
              v_bill.ho_prem      := i.ho_prem;
           v_bill.prem_seq_no := i.prem_seq_no;
           v_bill.iss_cd      := i.iss_cd;
           v_bill.bill          := i.bill;
           
           PIPE ROW(v_bill);
       END LOOP;
    ELSIF p_tran_type = 3 THEN
       FOR i IN (SELECT A.ISS_CD||TO_CHAR(A.PREM_SEQ_NO)||TO_CHAR(A.INTRMDRY_INTM_NO) HO_PREM, A.PREM_SEQ_NO,
                               A.ISS_CD, A.PREM_SEQ_NO BILL
                  FROM GIPI_COMM_INVOICE A 
                 WHERE A.COMMISSION_AMT < 0 
                   AND EXISTS (SELECT 'X' 
                                       FROM GIAC_DIRECT_PREM_COLLNS 
                                WHERE B140_ISS_CD = A.ISS_CD 
                                  AND B140_PREM_SEQ_NO = A.PREM_SEQ_NO) 
                                  AND INTRMDRY_INTM_NO = (SELECT MIN(INTRMDRY_INTM_NO) 
                                                                   FROM GIPI_COMM_INVOICE 
                                                           WHERE ISS_CD = A.ISS_CD 
                                                             AND PREM_SEQ_NO = A.PREM_SEQ_NO)
                   AND NOT EXISTS (SELECT 'X'
                                           FROM TABLE(GIAC_COMM_PAYTS_PKG.get_giac_comm_payts(p_gacc_tran_id)) gcop
                                    WHERE gcop.iss_cd = a.iss_cd
                                      AND gcop.prem_seq_no = a.prem_seq_no
                                        AND gcop.intm_no = a.intrmdry_intm_no)
                   AND A.ISS_CD = p_iss_cd
                   AND TO_CHAR(A.PREM_SEQ_NO) LIKE '%'||p_bill_no||'%'
                ORDER BY bill
       ) LOOP
              v_bill.ho_prem      := i.ho_prem;
           v_bill.prem_seq_no := i.prem_seq_no;
           v_bill.iss_cd      := i.iss_cd;
           v_bill.bill          := i.bill;
           
           PIPE ROW(v_bill);
       END LOOP;
    ELSIF p_tran_type = 4 THEN
       FOR i IN (SELECT A.ISS_CD||TO_CHAR(A.PREM_SEQ_NO)||TO_CHAR(A.INTM_NO) HO_PREM, A.PREM_SEQ_NO,
                               A.ISS_CD, A.PREM_SEQ_NO BILL
                  FROM GIAC_COMM_PAYTS A 
                 WHERE A.TRAN_TYPE = 3 
                   AND A.GACC_TRAN_ID = (SELECT MIN(GACC_TRAN_ID) 
                                                   FROM GIAC_COMM_PAYTS 
                                          WHERE ISS_CD = A.ISS_CD 
                                            AND PREM_SEQ_NO = A.PREM_SEQ_NO)
                    AND NOT EXISTS (SELECT 'X'
                                           FROM TABLE(GIAC_COMM_PAYTS_PKG.get_giac_comm_payts(p_gacc_tran_id)) gcop
                                    WHERE gcop.iss_cd = a.iss_cd
                                      AND gcop.prem_seq_no = a.prem_seq_no
                                        AND gcop.intm_no = a.intm_no)
                    AND A.ISS_CD = p_iss_cd
                    AND TO_CHAR(A.PREM_SEQ_NO) LIKE '%'||p_bill_no||'%'
                ORDER BY bill
       ) LOOP
              v_bill.ho_prem      := i.ho_prem;
           v_bill.prem_seq_no := i.prem_seq_no;
           v_bill.iss_cd      := i.iss_cd;
           v_bill.bill          := i.bill;
           
           PIPE ROW(v_bill);
       END LOOP;
    ELSIF p_tran_type = 5 THEN
       FOR i IN (SELECT A.ISS_CD||TO_CHAR(A.PREM_SEQ_NO)||TO_CHAR(A.INTRMDRY_INTM_NO) HO_PREM,A.PREM_SEQ_NO,
                               A.ISS_CD, A.PREM_SEQ_NO BILL 
                  FROM GIPI_COMM_INVOICE A 
                 WHERE A.COMMISSION_AMT >= 0 
                   AND EXISTS (SELECT 'X' 
                                       FROM GIAC_DIRECT_PREM_COLLNS 
                                WHERE B140_ISS_CD = A.ISS_CD 
                                  AND B140_PREM_SEQ_NO = A.PREM_SEQ_NO) 
                   AND INTRMDRY_INTM_NO = (SELECT MIN(INTRMDRY_INTM_NO) 
                                                   FROM GIPI_COMM_INVOICE 
                                            WHERE ISS_CD = A.ISS_CD 
                                              AND PREM_SEQ_NO = A.PREM_SEQ_NO)
                   AND NOT EXISTS (SELECT 'X'
                                           FROM TABLE(GIAC_COMM_PAYTS_PKG.get_giac_comm_payts(p_gacc_tran_id)) gcop
                                    WHERE gcop.iss_cd = a.iss_cd
                                      AND gcop.prem_seq_no = a.prem_seq_no
                                        AND gcop.intm_no = a.intrmdry_intm_no)
                   AND A.ISS_CD = p_iss_cd
                   AND TO_CHAR(A.PREM_SEQ_NO) LIKE '%'||p_bill_no||'%'
                ORDER BY bill
       ) LOOP
              v_bill.ho_prem      := i.ho_prem;
           v_bill.prem_seq_no := i.prem_seq_no;
           v_bill.iss_cd      := i.iss_cd;
           v_bill.bill          := i.bill;
           
           PIPE ROW(v_bill);
       END LOOP;
    END IF;
  END get_bill_no_list;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  09.14.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  : Executes procedure GET_GIPI_COMM_INVOICE of GIACS020 
  */ 
  PROCEDURE get_gipi_comm_invoice (p_iss_cd            IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                                   p_prem_seq_no        IN       GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                 p_intm_no            IN     GIAC_COMM_PAYTS.intm_no%TYPE,
                                   p_convert_rate        IN OUT GIAC_COMM_PAYTS.convert_rate%TYPE,
                                   p_currency_cd        IN OUT GIAC_COMM_PAYTS.currency_cd%TYPE,
                                 p_i_comm_amt        IN OUT GIPI_COMM_INVOICE.commission_amt%TYPE,
                                 p_i_wtax            IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
                                 p_curr_desc        IN OUT GIIS_CURRENCY.currency_desc%TYPE,
                                 p_def_fgn_curr        IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                                 p_message               OUT VARCHAR2)
    IS
      V_WTAX_RATE    NUMBER;
    BEGIN 
      -- added joanne 09.10.14, for SR 16760
      SELECT wtax_rate
          INTO V_WTAX_RATE
          FROM giis_intermediary
         WHERE intm_no = p_intm_no;  
            
      SELECT A.CURRENCY_RT,
             A.CURRENCY_CD,
             --nvl(d.commission_amt, B.COMMISSION_AMT),
             --nvl(d.WHOLDING_TAX, b.wholding_tax),
             nvl(d.commission_amt, b.commission_amt)*a.currency_rt, -- added joanne 09.10.14, for SR 16760
             nvl(d.commission_amt, b.commission_amt)*a.currency_rt*v_wtax_rate/100, --added joanne 09.10.14, for SR 16760
             C.CURRENCY_DESC
        INTO p_convert_rate,
             p_currency_cd,
             p_i_comm_amt,
             p_i_wtax,
             p_curr_desc
        FROM GIPI_INVOICE A,
             GIPI_COMM_INVOICE B, 
             GIIS_CURRENCY C,
             GIPI_COMM_INV_DTL D      
       WHERE c.main_currency_cd = a.currency_cd
         AND a.prem_seq_no      = b.prem_seq_no
         AND a.iss_cd           = b.iss_cd
         AND b.prem_seq_no      = d.prem_seq_no(+)
         AND b.iss_cd           = d.iss_cd(+)
         and b.intrmdry_intm_no = d.intrmdry_intm_no(+)
         AND b.prem_seq_no      = p_prem_seq_no
         AND b.intrmdry_intm_no = p_intm_no
         AND b.iss_cd           = p_iss_cd;
    
         p_def_fgn_curr   := p_i_comm_amt;
         --p_i_comm_amt := nvl(p_i_comm_amt* p_convert_rate,0);
         --p_i_wtax     := nvl(p_i_wtax * p_convert_rate,0);
       
       p_message := 'SUCCESS';
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN
          p_message := 'No commission invoice record for this bill and intermediary';
    END get_gipi_comm_invoice;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.15.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes procedure CHK_MODIFIED_COMM of GIACS020 
    */ 
    FUNCTION chk_modified_comm(p_prem_seq_no     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                 p_iss_cd            GIAC_COMM_PAYTS.iss_cd%TYPE)
    RETURN VARCHAR2
    IS
        v_comm_refund     NUMBER := 0;
        v_message         VARCHAR2(160) := 'SUCCESS';
    BEGIN
      FOR rec IN (SELECT a.iss_cd, a.prem_seq_no, a.intm_no, sum(comm_amt) comm_amt
                                  FROM giac_comm_payts a,
                                        giac_acctrans   b    
                                  WHERE a.prem_seq_no  = p_prem_seq_no
                                    AND a.iss_cd       = p_iss_cd
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
            FOR refund_rec IN (
                SELECT a.iss_cd, a.prem_seq_no, a.intm_no, sum(comm_amt) comm_amt
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
                v_message := 'Disbursement of commission was already made to the previous intermediary.' 
                           ||' Cancel the payments made before disbursing commission to the new intermediary.';
                EXIT;
             END IF;
        END LOOP;
        
        RETURN v_message;
    END chk_modified_comm;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.21.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes procedure CGFK$CHK_GCOP_COMM_INV_GIAC_PA of GIACS020 
    */ 
    PROCEDURE chk_gcop_comm_inv_giac_pa(
       p_intm_no                        IN        GIAC_COMM_PAYTS.intm_no%TYPE,
       p_iss_cd                            IN        GIAC_COMM_PAYTS.iss_cd%TYPE,
       p_prem_seq_no                    IN        GIAC_COMM_PAYTS.prem_seq_no%TYPE,
       p_dsp_policy_id                    IN OUT GIPI_COMM_INVOICE.policy_id%TYPE,
       p_dsp_intm_name                    IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
       p_dsp_assd_no                    IN OUT GIPI_POLBASIC.assd_no%TYPE,
       p_dsp_assd_name                    IN OUT GIIS_ASSURED.assd_name%TYPE,
       p_field_level                     IN        BOOLEAN) IS
    BEGIN
      DECLARE
        CURSOR C IS
          SELECT GIPI_COMM_INVOICE.POLICY_ID
                ,GIIS_INTERMEDIARY.INTM_NAME
                ,B250.ASSD_NO
                ,B250.par_id
          FROM   GIPI_COMM_INVOICE GIPI_COMM_INVOICE
                ,GIIS_INTERMEDIARY GIIS_INTERMEDIARY
                ,GIPI_POLBASIC B250
          WHERE  GIPI_COMM_INVOICE.INTRMDRY_INTM_NO = P_INTM_NO
          AND    GIPI_COMM_INVOICE.ISS_CD = P_ISS_CD
          AND    GIPI_COMM_INVOICE.PREM_SEQ_NO = P_PREM_SEQ_NO
          AND    GIIS_INTERMEDIARY.INTM_NO = GIPI_COMM_INVOICE.INTRMDRY_INTM_NO
          AND    B250.POLICY_ID = GIPI_COMM_INVOICE.POLICY_ID;
        
        v_par_id GIPI_POLBASIC.par_id%type;
      BEGIN
        OPEN C;
        FETCH C
        INTO   P_DSP_POLICY_ID
              ,P_DSP_INTM_NAME
              ,P_DSP_ASSD_NO
              ,v_par_id;
        IF P_DSP_ASSD_NO is null THEN
    
            SELECT assd_no
                INTO P_DSP_ASSD_NO
                FROM GIPI_PARLIST
                WHERE par_id = v_par_id;
        END IF;
    
            SELECT assd_name
            INTO P_DSP_ASSD_NAME
            FROM GIIS_ASSURED
            WHERE assd_no = P_DSP_ASSD_NO;
    
    
        IF C%NOTFOUND THEN
          RAISE NO_DATA_FOUND;
        END IF;
        CLOSE C;
      END;
    END chk_gcop_comm_inv_giac_pa;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.21.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes procedure GET_DEF_PREM_PCT of GIACS020 
    */ 
    PROCEDURE get_def_prem_pct(p_iss_cd                IN       GIAC_COMM_PAYTS.iss_cd%TYPE,
                                 p_prem_seq_no        IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                 p_var_inv_prem_amt    IN OUT GIPI_INVOICE.prem_amt%TYPE,
                                 p_var_other_charges  IN OUT GIPI_INVOICE.other_charges%TYPE,
                               p_var_notarial_fee    IN OUT GIPI_INVOICE.notarial_fee%TYPE,
                               p_var_pd_prem_amt    IN OUT GIAC_DIRECT_PREM_COLLNS.COLLECTION_AMT%TYPE,
                               p_var_c_premium_amt    IN OUT GIAC_DIRECT_PREM_COLLNS.premium_amt%type,
                               p_var_has_premium    IN OUT VARCHAR2,
                               p_var_clr_rec        IN OUT VARCHAR2,
                               p_var_pct_prem        IN OUT NUMBER,
                               p_pd_prem            IN OUT VARCHAR2,
                               p_message            IN OUT VARCHAR2)
    IS
      v_pol_flag   gipi_polbasic.pol_flag%type;
    BEGIN
        BEGIN
            SELECT prem_amt*currency_rt, other_charges*currency_rt, notarial_fee*currency_rt
              INTO p_var_inv_prem_amt, p_var_other_charges, p_var_notarial_fee
              FROM gipi_invoice
             WHERE iss_cd      = p_iss_cd
               AND prem_seq_no = p_prem_seq_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_message := 'No existing record in GIPI_INVOICE table.';
            RETURN;
      END;  
        BEGIN
            SELECT decode(sum(nvl(a.premium_amt,0)),null,0,sum(nvl(a.premium_amt,0)))
              INTO p_var_pd_prem_amt
              FROM giac_direct_prem_collns a, giac_acctrans b
             WHERE b140_iss_cd      = p_iss_cd
               AND b140_prem_seq_no = p_prem_seq_no
               AND a.gacc_tran_id = b.tran_id
               AND a.gacc_tran_id not in (SELECT c.gacc_tran_id
                                            FROM giac_reversals c, giac_acctrans d
                                           WHERE c.reversing_tran_id = d.tran_id 
                                             AND d.tran_flag <> 'D')
                 AND b.tran_flag <> 'D';
    
            IF (p_var_pd_prem_amt = 0 AND p_var_inv_prem_amt <> 0) THEN
                 --MSG_ALERT('No premium payment has been made for this policy.','I',FALSE);
                 p_pd_prem := 'N';
                 p_var_has_premium := 'N';
                 p_var_clr_rec := 'Y';
            ELSE
            p_var_has_premium := 'Y';
        END IF;
      END;
    
      IF p_var_pd_prem_amt <> 0 THEN
         p_var_pct_prem := p_var_pd_prem_amt / (p_var_inv_prem_amt + nvl((p_var_other_charges + p_var_notarial_fee),0));
      ELSIF p_var_inv_prem_amt = 0 THEN 
           p_var_pct_prem := 1;
      END IF;
    END get_def_prem_pct;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.21.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes procedure PARAM2_MGMT_GROUP of GIACS020 
    */ 
    PROCEDURE param2_mgmt_comp (p_iss_cd                    IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                                  p_prem_seq_no                IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                p_intm_no                    IN        GIAC_COMM_PAYTS.intm_no%TYPE,
                                p_comm_amt                    IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                                p_wtax_amt                    IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                p_drv_comm_amt                IN OUT NUMBER,
                                p_def_comm_amt                IN OUT NUMBER,
                                p_var_max_input_vat            IN OUT NUMBER,
                                p_var_vat_rt                IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                                p_var_clr_rec                IN OUT VARCHAR2,
                                p_valid_comm_amt            IN OUT VARCHAR2,
                                  mgmt_pd_prem_amt             IN        GIAC_DIRECT_PREM_COLLNS.premium_amt%type,
                                mgmt_tot_prem_amt             IN       GIPI_INVOICE.prem_amt%type)
    IS
      var_share_pct                GIPI_COMM_INVOICE.share_percentage%type := 0;
      var_comm_amt                GIPI_COMM_INVOICE.commission_amt%type := 0;
      var_ovr_comm                GIAC_COMM_PAYTS.comm_amt%type := 0;
      var_currency_rt         GIPI_INVOICE.currency_rt%type := 0;
      var_wholding_tax            GIPI_COMM_INVOICE.wholding_tax%type := 0;
      var_prnt_whold_tax      GIPI_COMM_INVOICE.wholding_tax%type := 0;
      var_tot_wholding_tax      GIPI_COMM_INVOICE.wholding_tax%type := 0;
      var_vat_rt              GIAC_COMM_PAYTS.input_vat_amt%type := 0;
      var_rec_comm_amt        GIAC_COMM_PAYTS.comm_amt%type := 0;
      var_prnt_comm_amt       GIPI_COMM_INVOICE.commission_amt%type := 0;
      var_rec_wtax_amt        GIAC_COMM_PAYTS.wtax_amt%type := 0; 
      var_comp_comm_amt       GIAC_COMM_PAYTS.comm_amt%type := 0;
      var_other_charges       GIPI_INVOICE.other_charges%type :=0;
      var_notarial_fee        GIPI_INVOICE.notarial_fee%type :=0;   
      v_intm                  GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
      v_parent                GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
      var_rec_input_vat_amt   GIAC_COMM_PAYTS.wtax_amt%type := 0;
    BEGIN
    
      FOR rec IN (SELECT comm_amt, wtax_amt, input_vat_amt
                      FROM giac_comm_payts a, giac_acctrans b
                     WHERE a.gacc_tran_id = b.tran_id
                     AND b.tran_flag <> 'D'
                     AND a.iss_cd = p_iss_cd
                     AND a.prem_seq_no = p_prem_seq_no
                     AND a.intm_no = p_intm_no
                     AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
                                                     FROM giac_reversals c, giac_acctrans d
                                                   WHERE c.reversing_tran_id=d.tran_id
                                                   AND d.tran_flag<>'D')) 
        LOOP   
            var_rec_comm_amt   := NVL(var_rec_comm_amt,0) + nvl(rec.comm_amt,0);
            var_rec_wtax_amt   := NVL(var_rec_wtax_amt,0) + nvl(rec.wtax_amt,0);
            var_rec_input_vat_amt := NVL(var_rec_input_vat_amt,0) + nvl(rec.input_vat_amt,0);--Vincent 050505: get value of input_vat_amount    
        END LOOP;
    
        SELECT a.share_percentage, nvl(c.commission_amt,a.commission_amt),
               currency_rt, nvl(c.wholding_tax, a.wholding_tax),
               b.other_charges, b.notarial_fee, a.intrmdry_intm_no
          INTO var_share_pct , var_comm_amt , 
               var_currency_rt, var_wholding_tax, 
               var_other_charges, var_notarial_fee, v_intm
          FROM gipi_comm_invoice a, gipi_invoice b, gipi_comm_inv_dtl c
         WHERE a.iss_cd = b.iss_cd
           AND a.prem_seq_no = b.prem_seq_no
           AND a.iss_cd = c.iss_cd(+)
           AND a.prem_seq_no = c.prem_seq_no(+)
           AND a.intrmdry_intm_no = c.intrmdry_intm_no(+)
           AND a.iss_cd = p_iss_cd
             AND a.prem_seq_no = p_prem_seq_no
           AND a.intrmdry_intm_no = p_intm_no;
    
             var_ovr_comm :=  (NVL(mgmt_pd_prem_amt,0) /(NVL(mgmt_tot_prem_amt,1)))
                 * ((nvl(var_comm_amt,0)* nvl(var_currency_rt,0))) ;
    
           var_tot_wholding_tax :=  (NVL(mgmt_pd_prem_amt,0) /NVL(mgmt_tot_prem_amt,1))
                     * ((nvl(var_wholding_tax,0)* nvl(var_currency_rt,0))) ;
      
           var_comp_comm_amt := var_ovr_comm - var_rec_comm_amt;
           
      IF var_comp_comm_amt > 0 THEN            
            p_comm_amt := var_ovr_comm - var_rec_comm_amt;
         p_wtax_amt := var_tot_wholding_tax - var_rec_wtax_amt;
         p_drv_comm_amt := nvl(var_ovr_comm,0) - (nvl(var_tot_wholding_tax,0) - nvl(var_vat_rt,0));
         p_var_max_input_vat := (var_ovr_comm *    (nvl(p_var_vat_rt,0)/100)) - var_rec_input_vat_amt;--Vincent 050505: hold max value for input_vat_amount            
          var_vat_rt := nvl(p_comm_amt,0) * (nvl(p_var_vat_rt,0)/100);    
      ELSE
         --msg_alert('No valid amount of commission for this transaction type.','I',false);   -- judyann 11122007; changed message
         p_valid_comm_amt  := 'N';    
         p_var_clr_rec := 'Y';
      END IF;
      
      p_def_comm_amt := p_comm_amt;
    END param2_mgmt_comp;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.22.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes procedure VALIDATE_COMM_AMT2 and VALIDATE_COMM_AMT3 of GIACS020
    **                   Function depends on p_param value. Can be '2' or '3'(default is 2)
    */ 
    PROCEDURE validate_comm_payts_comm_amt(p_param               IN      VARCHAR2,
                                              p_prem_seq_no       IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                              p_intm_no           IN      GIAC_COMM_PAYTS.intm_no%TYPE,
                                            p_iss_cd           IN      GIAC_COMM_PAYTS.iss_cd%TYPE,
                                            p_var_p_tran_type  IN      GIAC_COMM_PAYTS.tran_type%TYPE,
                                            p_var_p_tran_id       IN      GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                            p_var_i_comm_amt   IN      GIPI_COMM_INVOICE.commission_amt%TYPE,
                                            p_var_p_comm_amt   IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                                            p_var_r_comm_amt   IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                                            p_var_r_wtax       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                            p_var_i_wtax       IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
                                            p_var_p_wtax       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE)
    IS
    BEGIN
      SELECT  NVL(a.comm_amt,0),   
              NVL(a.wtax_amt,0)    
         INTO p_var_p_comm_amt,
              p_var_p_wtax
         FROM giac_comm_payts    a, 
              giac_acctrans      b 
       WHERE a.prem_seq_no      = p_prem_seq_no
         AND a.intm_no          = p_intm_no
         AND a.iss_cd           = p_iss_cd
         AND a.gacc_tran_id     = b.tran_id
         AND a.tran_type        = p_var_p_tran_type
         AND b.tran_id             = p_var_p_tran_id
         AND b.tran_flag       != 'D';
         
         IF p_param = '3' THEN
             p_var_r_comm_amt     := p_var_r_comm_amt + p_var_p_comm_amt;
             p_var_r_wtax         := p_var_r_wtax + p_var_p_wtax;
         ELSE
             p_var_r_comm_amt     := p_var_i_comm_amt - p_var_p_comm_amt;
             p_var_r_wtax         := p_var_i_wtax - p_var_p_wtax;
         END IF;
      EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
    END validate_comm_payts_comm_amt;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.22.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes POST-TEXT-ITEM trigger of :GCOP.INTM_NO of GIACS020
    */ 
    PROCEDURE giacs020_intm_no_post_text(p_comm_amt               IN       GIAC_COMM_PAYTS.comm_amt%TYPE,
                                           p_prem_seq_no           IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                           p_intm_no               IN      GIAC_COMM_PAYTS.intm_no%TYPE,
                                         p_iss_cd               IN      GIAC_COMM_PAYTS.iss_cd%TYPE,
                                         p_wtax_amt               IN      GIAC_COMM_PAYTS.wtax_amt%TYPE,
                                         p_def_comm_tag           IN OUT GIAC_COMM_PAYTS.def_comm_tag%TYPE,
                                         p_var_last_wtax       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE)
    IS
    BEGIN        
        IF p_comm_amt IS NULL THEN 
          FOR C IN (SELECT DEF_COMM_TAG
                    FROM giac_comm_payts a,
                         giac_acctrans   b    
             WHERE a.prem_seq_no  = p_prem_seq_no     
               AND a.intm_no      = p_intm_no 
               AND a.iss_cd       = p_iss_cd       
               AND a.gacc_tran_id = b.tran_id
               AND b.tran_flag   != 'D' ) 
          LOOP
            IF C.DEF_COMM_TAG = 'N' THEN
               p_def_comm_tag := 'N';
               EXIT;
            ELSE 
               NULL;
            END IF;
          END LOOP;
        END IF;
        
    p_var_last_wtax := p_wtax_amt;
    END;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.22.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes procedure COMP_SUMMARY of GIACS020
    */ 
    PROCEDURE giacs020_comp_summary(p_def_comm_tag        IN     GIAC_COMM_PAYTS.def_comm_tag%TYPE,
                       p_bill_gacc_tran_id         IN     GIAC_COMM_PAYTS.GACC_TRAN_ID%TYPE,   -- shan 10.02.2014
                         p_prem_seq_no           IN      GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                       p_intm_no               IN      GIAC_COMM_PAYTS.intm_no%TYPE,
                       p_iss_cd                   IN      GIAC_COMM_PAYTS.iss_cd%TYPE,
                       p_tran_type               IN      GIAC_COMM_PAYTS.tran_type%TYPE,
                       p_convert_rate           IN OUT GIAC_COMM_PAYTS.convert_rate%TYPE,
                       p_currency_cd           IN OUT GIAC_COMM_PAYTS.currency_cd%TYPE,
                       p_curr_desc               IN OUT GIIS_CURRENCY.currency_desc%TYPE,
                       p_input_vat_amt           IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                       p_comm_amt               IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_wtax_amt               IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_foreign_curr_amt       IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                       p_def_input_vat           IN OUT NUMBER,
                       p_drv_comm_amt           IN OUT NUMBER,
                       p_def_comm_amt           IN OUT NUMBER,
                       p_def_wtax_amt           IN OUT NUMBER,
                         p_var_cg_dummy           IN OUT VARCHAR2,
                         p_var_prev_comm_amt     IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_prev_wtax_amt       IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_var_prev_input_vat       IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                       p_var_p_tran_type       IN OUT GIAC_COMM_PAYTS.tran_type%TYPE,
                       p_var_p_tran_id           IN OUT GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                       p_var_r_comm_amt           IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_i_comm_amt           IN OUT GIPI_COMM_INVOICE.commission_amt%TYPE,
                       p_var_p_comm_amt          IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_r_wtax               IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_var_fdrv_comm_amt       IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_var_def_fgn_curr       IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
                       p_var_pct_prem           IN        NUMBER,
                       p_var_i_wtax               IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
                       p_var_p_wtax               IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
                       p_var_var_tran_type       IN OUT NUMBER,
                       p_var_vat_rt               IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                       p_var_input_vat_param   IN OUT NUMBER,
                       p_var_has_premium       IN OUT VARCHAR2,
                       p_var_clr_rec           IN OUT VARCHAR2,
                       p_control_v_comm_amt       IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
                       p_control_sum_inp_vat   IN OUT NUMBER,
                       p_control_v_input_vat   IN OUT NUMBER,
                       p_control_sum_comm_amt  IN OUT NUMBER,
                       p_control_sum_wtax_amt  IN OUT NUMBER,
                       p_control_v_wtax_amt       IN OUT NUMBER,
                       p_control_sum_net_comm_amt IN OUT NUMBER,
                       p_invalid_tran_type1_2     OUT VARCHAR2,
                       p_invalid_tran_type3_4     OUT VARCHAR2,
                       p_no_tran_type              OUT VARCHAR2, -- 0 if OK, otherwise, enter the transaction type number
                       p_inv_comm_fully_paid   IN OUT VARCHAR2,
                       p_message               IN OUT VARCHAR2)
    IS
    BEGIN
      p_invalid_tran_type1_2 := 'N';
      p_invalid_tran_type3_4 := 'N';
      p_no_tran_type         := '0';
      IF p_var_cg_dummy <> '1' THEN
        --VALIDATE_INTM_NO
          BEGIN
            p_var_r_comm_amt    := 0;
            p_var_r_wtax        := 0;
            p_var_fdrv_comm_amt := 0;
			
            GIAC_COMM_PAYTS_PKG.GET_GIPI_COMM_INVOICE(p_iss_cd, p_prem_seq_no, p_intm_no, p_convert_rate, p_currency_cd, p_var_i_comm_amt, p_var_i_wtax, p_curr_desc, p_var_def_fgn_curr, p_message);
			
            
            IF p_message <> 'SUCCESS' THEN
               RETURN;
            END IF;
        
            IF p_def_comm_tag = 'Y' THEN
               p_var_def_fgn_curr := p_var_def_fgn_curr * p_var_pct_prem;
               p_var_i_comm_amt   := nvl(p_var_i_comm_amt * p_var_pct_prem,0);
               p_var_i_wtax       := p_var_i_wtax * p_var_pct_prem;
            END IF;
            
            FOR C IN (SELECT tran_type, gacc_tran_id
                        FROM giac_comm_payts a,
                             giac_acctrans   b    
                       WHERE a.prem_seq_no  = p_prem_seq_no     
                         AND a.intm_no      = p_intm_no 
                         AND a.iss_cd       = p_iss_cd       
                         AND a.gacc_tran_id = b.tran_id
                         AND b.tran_flag   != 'D' 
                         AND gacc_tran_id = NVL(p_bill_gacc_tran_id, gacc_tran_id)  -- shan 10.02.2014
                         AND NOT EXISTS (SELECT x.gacc_tran_id
                                           FROM giac_reversals x,
                                                giac_acctrans y
                                          WHERE x.reversing_tran_id = y.tran_id
                                            AND y.tran_flag <> 'D'
                                            AND x.gacc_tran_id = a.gacc_tran_id))                                                                            
              LOOP
                 p_var_p_tran_type := C.TRAN_TYPE;
                 p_var_p_tran_id   := C.GACC_TRAN_ID;
        
              IF p_tran_type = 1 AND
                 (p_intm_no  <> 0 AND
                 p_intm_no   IS NOT NULL) THEN
        
                   IF p_var_p_tran_type in (3,4) THEN
                      --msg_alert('You entered an invalid transaction type!!! Only transaction type 3 or 4 is allowed!!!','I',false);
                      p_invalid_tran_type3_4 := 'Y';    
                   ELSIF p_var_p_tran_type in (1,2) THEN
                      GIAC_COMM_PAYTS_PKG.validate_comm_payts_comm_amt('2', p_prem_seq_no, p_intm_no, p_iss_cd, p_var_p_tran_type, p_var_p_tran_id, p_var_i_comm_amt, p_var_p_comm_amt, p_var_r_comm_amt, p_var_r_wtax, p_var_i_wtax, p_var_p_wtax);
                   ELSE
                         p_var_r_comm_amt := nvl(p_var_i_comm_amt,000);   
                   END IF;
        
                ELSIF p_tran_type = 2 AND  /*check previous tran_type and commission amount*/
                      (p_intm_no  <> 0 AND
                      p_intm_no   IS NOT NULL) THEN 
        
                   IF p_var_p_tran_type in (3,4) THEN
                        --message('You entered an invalid transaction type!!! Only transaction type 3 or 4 is allowed!!!');
                        p_invalid_tran_type3_4 := 'Y';    
                     ELSIF p_var_p_tran_type in (1,2) THEN
                      GIAC_COMM_PAYTS_PKG.validate_comm_payts_comm_amt('3', p_prem_seq_no, p_intm_no, p_iss_cd, p_var_p_tran_type, p_var_p_tran_id, p_var_i_comm_amt, p_var_p_comm_amt, p_var_r_comm_amt, p_var_r_wtax, p_var_i_wtax, p_var_p_wtax);
                     ELSE 
                        p_var_r_comm_amt := p_var_i_comm_amt;
                        --MSG_ALERT('No transaction type 1 for this bill and intermediary.','W',FALSE);
                        p_no_tran_type := '1';
                     END IF;  
        
                ELSIF p_tran_type = 4 AND  /*check previous tran_type and commisssion amount*/
                          (p_intm_no  <> 0 AND
                          p_intm_no   IS NOT NULL) THEN 
        
               IF p_var_p_tran_type in (1,2) THEN
                        --message('You entered an invalid transaction type!!! Only transaction type 1 or 2 is allowed!!!');
                        p_invalid_tran_type1_2 := 'Y';    
                     ELSIF p_var_p_tran_type in (3,4) THEN
                        GIAC_COMM_PAYTS_PKG.validate_comm_payts_comm_amt('3', p_prem_seq_no, p_intm_no, p_iss_cd, p_var_p_tran_type, p_var_p_tran_id, p_var_i_comm_amt, p_var_p_comm_amt, p_var_r_comm_amt, p_var_r_wtax, p_var_i_wtax, p_var_p_wtax);
                     ELSE 
                        p_var_r_comm_amt := p_var_i_comm_amt;
                        --MSG_ALERT('No transaction type 3 for this bill and intermediary.','W',FALSE);
                        p_no_tran_type := '3';
                     END IF;  
        
                ELSIF p_tran_type = 3 AND     /*check previous tran_type and commisssion amount*/
                      (p_intm_no  <> 0 AND
                        p_intm_no   IS NOT NULL) THEN 
        
                     IF p_var_p_tran_type in (1,2) THEN
                           --msg_alert ('You entered an invalid transaction type!!! Only transaction type 1 or 2 is allowed!!!','I',false);
                        p_invalid_tran_type1_2 := 'Y';    
                     ELSIF p_var_p_tran_type in (3,4) THEN
                        GIAC_COMM_PAYTS_PKG.validate_comm_payts_comm_amt('2', p_prem_seq_no, p_intm_no, p_iss_cd, p_var_p_tran_type, p_var_p_tran_id, p_var_i_comm_amt, p_var_p_comm_amt, p_var_r_comm_amt, p_var_r_wtax, p_var_i_wtax, p_var_p_wtax);
               ELSE
                        p_var_r_comm_amt := nvl(p_var_i_comm_amt,000);  
               END IF;
            
            END IF ;
            
            p_var_i_comm_amt     := p_var_r_comm_amt;
            p_var_i_wtax         := p_var_r_wtax;
            p_var_fdrv_comm_amt  := p_var_i_comm_amt - p_var_i_wtax;
        
          END LOOP;
        
            IF p_var_p_tran_type IS NULL THEN
               IF  p_tran_type = 2 THEN
                  --MSG_ALERT('No transaction type 1 for this bill and intermediary.','W',FALSE);
                  p_no_tran_type := '1';
               ELSIF  p_tran_type = 4 THEN
                  --MSG_ALERT('No transaction type 3 for this bill and intermediary.','W',FALSE);
                  p_no_tran_type := '3';
               ELSE    
                  p_var_r_comm_amt    := nvl(p_var_i_comm_amt * p_var_var_tran_type,0);
                  p_var_r_wtax        := p_var_i_wtax * p_var_var_tran_type;
                  p_var_fdrv_comm_amt := (p_var_i_comm_amt - p_var_i_wtax) * p_var_var_tran_type;
                    p_input_vat_amt     := (nvl(p_var_vat_rt,0)/100) * nvl(p_comm_amt,0);
             END IF;
            END IF;
        
            p_var_r_comm_amt := p_var_i_comm_amt * p_var_var_tran_type;
            p_var_r_wtax     := p_var_i_wtax * p_var_var_tran_type;
            p_def_input_vat  := p_var_input_vat_param * p_var_r_comm_amt;
            p_comm_amt       := nvl(p_var_r_comm_amt,0);
            p_wtax_amt       := nvl(p_var_r_wtax,0);
            p_input_vat_amt  := (nvl(p_var_vat_rt,0)/100) * nvl(p_comm_amt,0);
            p_var_fdrv_comm_amt := p_var_fdrv_comm_amt + p_def_input_vat;
            p_drv_comm_amt   := p_var_fdrv_comm_amt * p_var_var_tran_type;
            p_def_comm_amt   := p_var_r_comm_amt;
            p_def_wtax_amt   := p_var_r_wtax;
        
            p_drv_comm_amt    := nvl(p_comm_amt,0) - nvl(p_input_vat_amt,0) + nvl(p_wtax_amt,0) ;
          
            p_control_sum_inp_vat  := nvl(p_control_sum_inp_vat,0)
                                            + NVL(p_def_input_vat,0)
                                         - NVL(p_control_v_input_vat,0);
          
            p_control_sum_comm_amt := nvl(p_control_sum_comm_amt,0) 
                                            + p_var_r_comm_amt
                                            - NVL(p_control_v_comm_amt,0);
            
            p_control_sum_inp_vat  := nvl(p_control_sum_inp_vat,0) + nvl(p_input_vat_amt,0); 
          
            p_control_sum_wtax_amt := nvl(p_control_sum_wtax_amt,0) 
                                            + p_var_r_wtax
                                            - nvl(p_control_v_wtax_amt,0);
        
            p_control_sum_net_comm_amt := NVL(p_control_sum_comm_amt,0)
                                         + NVL(p_control_sum_inp_vat,0)
                                            - NVL(p_control_sum_wtax_amt,0);
                
          p_control_v_comm_amt  := nvl(p_comm_amt,0);
          p_control_v_wtax_amt  := nvl(p_wtax_amt,0);
          p_control_v_input_vat := nvl(p_input_vat_amt,0);
          p_foreign_curr_amt     := p_comm_amt / p_convert_rate;
        
        
          IF ((p_COMM_AMT = 0) AND (p_var_has_premium = 'Y')) THEN 
               --MSG_ALERT(' Invoice Commission fully paid.','I',false);
               p_inv_comm_fully_paid := 'Y';
               p_var_clr_rec := 'Y';
            END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
      END IF;
      p_var_prev_comm_amt  := nvl(p_comm_amt,0);
      p_var_prev_wtax_amt  := nvl(p_wtax_amt,0);
      p_var_prev_input_vat := nvl(p_input_vat_amt,0);
      p_var_p_tran_type    := null;
      p_control_v_comm_amt := nvl(p_comm_amt,0);
    END giacs020_comp_summary;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.29.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes PRE-INSERT trigger of GCOP block in GIACS020
    **                   Gets the PARENT_INTM_NO before record is inserted
    */ 
    PROCEDURE giacs020_pre_insert_comm_payts(p_gacc_tran_id        IN     GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
                                               p_intm_no            IN     GIAC_COMM_PAYTS.intm_no%TYPE,
                                               p_parent_intm_no    IN OUT GIAC_COMM_PAYTS.parent_intm_no%TYPE,
                                             p_comm_tag            IN       GIAC_COMM_PAYTS.comm_tag%TYPE,
                                             p_record_no        IN OUT GIAC_COMM_PAYTS.record_no%TYPE,
                                             p_message               OUT VARCHAR2)
    IS
    v_parent_intm_no   number;
    p_acct_intm_cd       number;
    p_lic_tag              varchar2(1);
    v_loop                  boolean;
    v_intm_no          number;
    p_sl_cd            number;
    l_sl_cd            number;
    p_tran_id          GIAC_ACCTRANS.tran_id%TYPE;
    BEGIN
        p_message := 'SUCCESS';
        V_LOOP := TRUE;
        V_INTM_NO := p_intm_no;
        WHILE V_LOOP LOOP
           BEGIN
                    SELECT a.parent_intm_no,b.acct_intm_cd,a.lic_tag
                 INTO   v_parent_intm_no,p_acct_intm_cd,p_lic_tag    
                    FROM   GIIS_INTERMEDIARY A, GIIS_INTM_TYPE B
                     WHERE  A.intm_type = B.intm_type
                     AND    A.intm_no   =  v_intm_no;
                 /*CHECK PARENT_INTM*/
                 IF v_parent_intm_no IS NULL THEN 
                    /*CHK_THE_LIC_TAG*/
                    IF P_LIC_TAG = 'Y' THEN
                       P_SL_CD := V_INTM_NO;
                       V_LOOP := FALSE;
                    ELSE
                       P_SL_CD := V_INTM_NO;
                       V_LOOP := FALSE;
                    END IF;
                 ELSE
                    /*IF NOT NULL FIND PARENT THAT IS LICENSED*/
                    IF P_LIC_TAG = 'Y' THEN
                       P_SL_CD := V_INTM_NO;
                       V_LOOP := FALSE;
                    ELSE
                       V_INTM_NO := v_parent_intm_no;
                       V_LOOP := TRUE;
                    END IF;
                 END IF;
            EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       p_message := 'INTERMEDIARY ' || TO_CHAR(V_INTM_NO)|| ' HAS NO RECORD IN GIIS_INTERMEDIARY.';
            END;
        END LOOP;    
        p_parent_intm_no := P_SL_CD;
      
      --added by A.R.C. 01.06.2005  
      BEGIN
           IF p_comm_tag = 'N' THEN
              p_record_no := 0;
           ELSE
             BEGIN
                 SELECT NVL(MAX(record_no),0) + 1
                   INTO p_record_no
                   FROM giac_comm_payts
                  WHERE gacc_tran_id = p_gacc_tran_id;
                END;
           END IF;  
      END;
    END;
    
    /*
   **  Created by   :  Emman
   **  Date Created :  09.30.2010
   **  Reference By : (GIACS020 - Comm Payts)
   **  Description  : Executes procedure AEG_PARAMETERS_Y on GIACS020
   */
    PROCEDURE giacs020_aeg_parameters_y(
                                      p_gacc_branch_cd              IN     GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                               p_gacc_fund_cd              IN     GIAC_ACCTRANS.gfun_fund_cd%TYPE,
                               p_gacc_tran_id              IN     GIAC_ACCTRANS.tran_id%TYPE,
                               p_iss_cd                      IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                               p_prem_seq_no              IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                               p_intm_no                  IN     GIAC_COMM_PAYTS.intm_no%TYPE,
                               p_record_no                  IN     GIAC_COMM_PAYTS.record_no%TYPE,
                               p_disb_comm                  IN     GIAC_COMM_PAYTS.disb_comm%TYPE,
                               p_drv_comm_amt                IN     NUMBER,
                               p_currency_cd              IN     GIAC_COMM_PAYTS.currency_cd%TYPE,
                               p_convert_rate              IN     GIAC_COMM_PAYTS.convert_rate%TYPE,
                                      p_var_comm_take_up          IN OUT GIAC_PARAMETERS.param_value_n%TYPE,
                                      aeg_tran_id                IN     GIAC_ACCTRANS.tran_id%TYPE,
                               aeg_module_nm              IN     GIAC_MODULES.module_name%TYPE,
                               aeg_sl_type_cd1            IN     GIAC_PARAMETERS.param_name%TYPE,
                               aeg_sl_type_cd2            IN     GIAC_PARAMETERS.param_name%TYPE,
                               aeg_sl_type_cd3            IN     GIAC_PARAMETERS.param_name%TYPE,
                               p_message                     OUT VARCHAR2) IS
      
    
    /***  For COMMISSION EXPENSE...*/
    
      CURSOR PREMIUM_CUR IS
        SELECT c.iss_cd iss_cd ,
               ROUND((y.commission_amt/w.commission_amt)*c.comm_amt,2) comm_amt,
               ROUND((y.wholding_tax/w.wholding_tax)*c.wtax_amt,2) wtax_amt,
               ROUND((y.wholding_tax/w.wholding_tax)*C.input_vat_amt,2) input_vat_amt,
               c.prem_seq_no bill_no, a.line_cd ,x.acct_line_cd,
                 c.intm_no, a.assd_no,
                 LTRIM(TO_CHAR(x.acct_line_cd,'00'))||LTRIM(TO_CHAR(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00')) lsp,
                 a.type_cd, 
               DECODE(aeg_sl_type_cd1,'ASSD_SL_TYPE', a.assd_no,
                                      'INTM_SL_TYPE', LTRIM(TO_CHAR(x.acct_line_cd,'00'))||ltrim(to_char(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00')),
                                      'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd1,
               DECODE(aeg_sl_type_cd2,'ASSD_SL_TYPE', a.assd_no,
                                      'INTM_SL_TYPE', LTRIM(TO_CHAR(x.acct_line_cd,'00'))||ltrim(to_char(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00')),
                                      'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL)sl_cd2,
               DECODE(aeg_sl_type_cd3,'ASSD_SL_TYPE', a.assd_no,
                                      'INTM_SL_TYPE', LTRIM(TO_CHAR(x.acct_line_cd,'00'))||ltrim(to_char(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00')),
                                      'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL)sl_cd3
          FROM gipi_polbasic a, gipi_invoice  b, giac_comm_payts c,
               giis_line x, gipi_comm_inv_peril y, gipi_comm_invoice w,
               giis_subline z
         WHERE a.policy_id    = b.policy_id
           AND b.iss_cd       = c.iss_cd
           AND b.prem_seq_no  = c.prem_seq_no
           AND c.tran_type   != 5
           AND a.line_cd      = x.line_cd
           AND b.iss_cd       = y.iss_cd
           AND c.gacc_tran_id = aeg_tran_id
           AND b.prem_seq_no  = y.prem_seq_no
           AND w.iss_cd       = y.iss_cd
           AND w.prem_seq_no  = y.prem_seq_no
           AND w.policy_id    = b.policy_id
           AND a.line_cd      = z.line_cd
           AND X.LINE_CD      = Z.LINE_CD
           AND A.SUBLINE_CD   = Z.SUBLINE_CD;
           ---AND a.acct_ent_date >= '30-SEP-03';
               
    
    --- Negative factor used for collection amt
     negative_one NUMBER := 1;
     w_sl_cd      GIAC_ACCT_ENTRIES.sl_cd%TYPE;
     v_intm_no    GIAC_COMM_PAYTS.intm_no%TYPE;
    
    BEGIN
    
      p_message := 'SUCCESS';
    
      /*** Call the deletion of accounting entry procedure.***/
      p_var_comm_take_up:= 6;
    
      BEGIN
        FOR PREMIUM_rec IN PREMIUM_CUR LOOP
          PREMIUM_rec.comm_amt := NVL(PREMIUM_rec.comm_amt, 0) * negative_one;
          IF PREMIUM_rec.assd_no IS NULL THEN
             FOR i IN
               (SELECT d.assd_no assd_no
                  FROM gipi_polbasic a, gipi_invoice  b, giac_comm_payts c,
                       gipi_parlist d
                 WHERE a.policy_id    = b.policy_id
                   AND b.iss_cd       = premium_rec.iss_cd
                   AND b.prem_seq_no  = premium_rec.bill_no
                   AND c.tran_type   != 5
                   AND c.gacc_tran_id = aeg_tran_id
                   AND a.par_id       = d.par_id)
             LOOP
               premium_rec.assd_no := i.assd_no;
             END LOOP;
          END IF;
    
          giacs020_comm_payable_proc_y(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id, p_var_comm_take_up,
                                        aeg_sl_type_cd1, aeg_sl_type_cd2, aeg_sl_type_cd3,
                                        premium_rec.intm_no,      premium_rec.assd_no,
                                      premium_rec.acct_line_cd, premium_rec.comm_amt, 
                                      premium_rec.wtax_amt,     premium_rec.line_cd,
                                      premium_rec.lsp,          premium_rec.input_vat_amt,
                                      premium_rec.sl_cd1,       premium_rec.sl_cd2,
                                      premium_rec.sl_cd3, p_message) ;
        END LOOP;
        giacs020_overdraft_comm_entry(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                                                            p_iss_cd, p_prem_seq_no, p_intm_no,
                                                            p_record_no, p_disb_comm, p_drv_comm_amt,
                                                            p_currency_cd, p_convert_rate, p_message);
      END;
    END giacs020_aeg_parameters_y;
    
    PROCEDURE check_gcop_inv_chk_tag (p_checked                               IN OUT VARCHAR2,
                                        p_iss_cd                               IN       GIAC_COMM_PAYTS.iss_cd%TYPE,
                                      p_prem_seq_no                        IN       GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                      p_comm_tag_displayed                 IN       VARCHAR2,
                                      p_tran_type                           IN       GIAC_COMM_PAYTS.tran_type%TYPE,
                                      p_var_comm_payable_param            IN       NUMBER,
                                      p_message                                     OUT VARCHAR2)
    IS
        v_inv_prem_amt           gipi_invoice.prem_amt%TYPE := 0;
        v_inv_tax_amt        gipi_invoice.tax_amt%TYPE  := 0;
        v_inv_curr_rt        gipi_invoice.currency_rt%TYPE;
        v_pd_prem_amt        giac_direct_prem_collns.premium_amt%TYPE := 0;
        v_pd_tax_amt        giac_direct_prem_collns.tax_amt%TYPE := 0;
        v_prem_pct            NUMBER;
    BEGIN
        p_message := 'SUCCESS';
        
        IF nvl(p_checked,'N') = 'Y' THEN
            BEGIN    
             SELECT nvl(round(prem_amt*currency_rt,2),0), nvl(round(tax_amt*currency_rt,2),0), currency_rt
               INTO v_inv_prem_amt, v_inv_tax_amt, v_inv_curr_rt
               FROM gipi_invoice
              WHERE iss_cd      = p_iss_cd
                AND prem_seq_no = p_prem_seq_no;
           EXCEPTION
             WHEN no_data_found THEN
                   p_message := 'No existing record in GIPI_INVOICE table.';
                   p_checked := 'N';
           END;
      
             IF v_inv_curr_rt <> 1 THEN
                   v_inv_tax_amt := get_loc_inv_tax_sum(p_iss_cd,p_prem_seq_no);            
             END IF;
            
             SELECT nvl(SUM(a.premium_amt),0), nvl(SUM(a.tax_amt),0)
               INTO v_pd_prem_amt, v_pd_tax_amt
               FROM giac_acctrans b,
                    giac_direct_prem_collns a
             WHERE a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                            FROM giac_reversals c, giac_acctrans d
                                           WHERE c.reversing_tran_id = d.tran_id 
                                             AND d.tran_flag <> 'D')
               AND b.tran_flag <> 'D'
               AND a.gacc_tran_id   = b.tran_id
               AND b140_iss_cd      = p_iss_cd
               AND b140_prem_seq_no = p_prem_seq_no;
    
            --check for premium payment
             IF (v_pd_prem_amt = 0 AND v_inv_prem_amt <> 0) THEN            
                  p_message := 'No premium payment has been made for this policy.';
                  p_checked := 'N';
                  RETURN;   -- added to skip checking of partial payment : shan 10.16.2014
             END IF;    
     
            --check for partial premium payment
             IF (v_inv_prem_amt + v_inv_tax_amt) - (v_pd_prem_amt + v_pd_tax_amt) <> 0 AND
                  (p_var_comm_payable_param = 2) AND (p_tran_type = 1) THEN
                   IF p_comm_tag_displayed = 'Y' THEN 
                       p_message := 'PARAM2_OVERWRITE';
                       -- sa labas, p_checked := 'N';
                  ELSE
                       p_message := 'Policy is not yet fully paid.';
                       p_checked := 'N';
                  END IF;
             END IF;
        END IF;
    END check_gcop_inv_chk_tag;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  10.08.2010
    **  Reference By : (GIACS020 - Comm Payts)
    **  Description  : Executes the KEY-DELREC trigger of GCOP block in GIACS020
    */ 
    PROCEDURE giacs020_key_delrec(p_iss_cd                        IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
                                        p_prem_seq_no              IN        GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                      p_intm_no                 IN        GIAC_COMM_PAYTS.intm_no%TYPE,
                                      p_comm_amt             IN        GIAC_COMM_PAYTS.comm_amt%TYPE,
                                      p_message                 OUT    VARCHAR2)
    IS
         commission_amount    giac_comm_payts.comm_amt%type := 0;
    BEGIN
         p_message := 'SUCCESS';
         
         FOR c in (SELECT comm_amt
                     FROM giac_comm_payts
                    WHERE iss_cd      = p_iss_cd
                      AND prem_seq_no = p_prem_seq_no
                      AND intm_no     = p_intm_no) 
         LOOP
             commission_amount := commission_amount + c.comm_amt;
         END LOOP;
         
         IF abs(commission_amount) < abs(p_comm_amt) THEN
             p_message := 'You cannot delete this record, there is an existing refund for this Bill No. and Intm. No.';
         END IF;
    END giacs020_key_delrec;

    
    FUNCTION get_commission_slip (
      
    p_intm_no    GIAC_COMM_SLIP_EXT.intm_no%TYPE,    
    p_tran_id    GIAC_COMM_SLIP_EXT.gacc_tran_id%TYPE
   )
   
      RETURN comm_slip_tab PIPELINED
   IS
      v_comm_slip   comm_slip_type;
   BEGIN
      FOR i IN (SELECT DISTINCT
                gint.intm_name intm_name, gcse.intm_no agent_cd, gcse.gacc_tran_id,
                gpol.line_cd ||'-'|| gpol.subline_cd ||'-'|| gpol.iss_cd 
                ||'-'|| LPAD(gpol.issue_yy, 2, 0) ||'-'|| LPAD(gpol.pol_seq_no, 7, 0)
                ||'-'|| LPAD(gpol.renew_no, 2, 0) ||  
                DECODE(gpol.endt_seq_no, 0, NULL, gpol.endt_iss_cd ||'-'|| 
                gpol.endt_yy ||'-'|| LPAD(gpol.endt_seq_no, 6, 0)) policy_no, 
                gcse.comm_amt comm_amt, gcse.wtax_amt wtax_amt,
                gcse.input_vat_amt vat_amt, 
                ( gcse.comm_amt  + gcse.input_vat_amt - gcse.wtax_amt) net, gcip.prem_seq_no,
                gcp.comm_amt comm_paid, gcp.input_vat_amt input_vat, 
                gcp.wtax_amt wtax, --gdpc.premium_amt, -- comment out by andrew 04.23.2012
                goop.user_id,
                gcse.iss_cd,
                gass.assd_name assd_name,
                gpol.line_cd,  
                gpol.policy_id, 
                SUM (gcip.premium_amt) prem_amt, 
                SUM (gcip.commission_amt) comm_amt_pol, 
                gci.share_percentage share_pct, 
                SUM (NVL(gpci.commission_amt,0)) ovr_comm, 
                (SUM (NVL(gcip.COMMISSION_AMT,0)) - SUM(NVL(gpci.COMMISSION_AMT,0))) total_comm,
                DECODE(goop.or_pref_suf||'-'||TO_CHAR(goop.or_no), '-', NULL, 
                goop.or_pref_suf||'-'||TO_CHAR(goop.or_no)) or_no,
                TRUNC(or_date) or_date, 
                gcse.comm_slip_date 
           FROM GIAC_COMM_SLIP_EXT gcse, 
                GIPI_COMM_INV_PERIL gcip, 
                GIIS_INTERMEDIARY gint, 
                GIPI_POLBASIC gpol, 
                /*(SELECT NVL(SUM(premium_amt),0) premium_amt, b140_iss_cd, b140_prem_seq_no, gacc_tran_id  	--comment out by andrew - 04.23.2012
                 FROM GIAC_DIRECT_PREM_COLLNS  
                 WHERE gacc_tran_id = p_tran_id
                 GROUP BY  gacc_tran_id, b140_iss_cd, b140_prem_seq_no
                ) gdpc,*/ 
                GIIS_ASSURED gass, 
                GIIS_PERIL gper, 
                GIAC_COMM_PAYTS gcp, 
                GIAC_ACCTRANS gacc, 
                GIPI_PARLIST gpar,
                GIAC_ORDER_OF_PAYTS goop, 
                GIPI_COMM_INVOICE gci,
                GIAC_PARENT_COMM_INVPRL gpci 
          WHERE gcse.iss_cd = gcip.iss_cd
                AND gcse.rec_id > 0 
                AND gci.iss_cd = gcse.iss_cd 
                AND goop.gacc_tran_id = gcp.gacc_tran_id 
                AND gcse.prem_seq_no = gcip.prem_seq_no
                AND gcse.intm_no = gci.intrmdry_intm_no 
                AND gcip.intrmdry_intm_no = gci.intrmdry_intm_no 
                AND gcip.intrmdry_intm_no = gpci.chld_intm_no (+) 
                AND gcse.intm_no = gint.intm_no
                AND gcse.prem_seq_no = gcp.prem_seq_no
                AND gcse.prem_seq_no = gci.prem_seq_no 
                AND gcip.prem_seq_no = gpci.prem_seq_no (+) 
                AND gcse.iss_cd = gcp.iss_cd
                AND gcip.iss_cd = gpci.iss_cd (+) 
                AND gcip.peril_cd = gpci.peril_cd (+) 
                AND gcp.gacc_tran_id = gacc.tran_id
                AND gcse.gacc_tran_id = gcp.gacc_tran_id
                /*AND gdpc.gacc_tran_id = gcse.gacc_tran_id  -- comment out by andrew - 04.23.2012
                AND gdpc.b140_iss_cd = gcse.iss_cd --Juday 
                AND gdpc.b140_prem_seq_no = gcp.prem_seq_no*/
                AND gacc.tran_id NOT IN (SELECT gacc_tran_id
                                       FROM GIAC_REVERSALS a, GIAC_ACCTRANS  b
                                       WHERE gacc_tran_id = tran_id
                                       AND tran_flag !='D')
                AND gcse.intm_no = gcp.intm_no
                AND gcse.intm_no = gint.intm_no
                AND gpol.par_id  = gpar.par_id
                AND gcip.policy_id = gpol.policy_id
                AND gass.assd_no = gpar.assd_no
                AND gcip.peril_cd = gper.peril_cd
                AND gpol.line_cd = gper.line_cd
                --AND gcse.comm_slip_tag = 'Y'      -commented by d.alcantara, 03-28-2011
                AND NVL(gcse.comm_slip_flag, 'N') != 'C'
                AND gcse.intm_no = p_intm_no
                AND gcse.or_no IS NOT NULL
                AND gcse.gacc_tran_id = p_tran_id
       GROUP BY gint.intm_name, gcse.intm_no, gcse.gacc_tran_id,
                gpol.line_cd ||'-'|| gpol.subline_cd ||'-'|| gpol.iss_cd 
                ||'-'|| LPAD(gpol.issue_yy, 2, 0) ||'-'|| LPAD(gpol.pol_seq_no, 7, 0)
                ||'-'|| LPAD(gpol.renew_no, 2, 0) ||  
                DECODE(gpol.endt_seq_no, 0, NULL, gpol.endt_iss_cd ||'-'|| 
                gpol.endt_yy ||'-'|| LPAD(gpol.endt_seq_no, 6, 0)), 
                gcse.comm_amt, gcse.wtax_amt,
                gcse.input_vat_amt, ( gcse.comm_amt  + gcse.input_vat_amt - gcse.wtax_amt), gcip.prem_seq_no,
                gcp.comm_amt, gcp.input_vat_amt, 
                gcp.wtax_amt, --gdpc.premium_amt, --comment out by andrew 04.23.2012
                goop.user_id, 
                gcse.iss_cd,
                gass.assd_name, 
                gpol.line_cd, 
                gpol.policy_id,
                gci.share_percentage, 
                gcse.comm_slip_date, 
                goop.or_pref_suf,
                goop.or_no,
                goop.or_date)

      LOOP
         v_comm_slip.intm_name        := i.intm_name;
         v_comm_slip.agent_cd         := i.agent_cd;
         v_comm_slip.gacc_tran_id     := i.gacc_tran_id;
         v_comm_slip.policy_no        := i.policy_no;
         v_comm_slip.comm_amt         := i.comm_amt;
         v_comm_slip.wtax_amt         := i.wtax_amt;
         v_comm_slip.vat_amt          := i.vat_amt;
         v_comm_slip.net              := i.net;
         v_comm_slip.prem_seq_no      := i.prem_seq_no;
         v_comm_slip.comm_paid        := i.comm_paid;
         v_comm_slip.input_vat        := i.input_vat;
         v_comm_slip.wtax             := i.wtax;
         --v_comm_slip.premium_amt      := i.premium_amt;
         v_comm_slip.user_id          := i.user_id;
         v_comm_slip.iss_cd           := i.iss_cd;
         v_comm_slip.assd_name        := i.assd_name;
         v_comm_slip.line_cd          := i.line_cd;
         v_comm_slip.policy_id        := i.policy_id;
         v_comm_slip.prem_amt         := i.prem_amt;
         v_comm_slip.comm_amt_pol     := i.comm_amt_pol;
         v_comm_slip.share_pct        := i.share_pct;
         v_comm_slip.ovr_comm         := i.ovr_comm;
         v_comm_slip.total_comm       := i.total_comm;
         v_comm_slip.or_no            := i.or_no;
         v_comm_slip.or_date          := i.or_date;
         v_comm_slip.comm_slip_date   := i.comm_slip_date;		 		

         PIPE ROW (v_comm_slip);
      END LOOP;

      RETURN;
   END get_commission_slip;

   FUNCTION get_comm_peril_sname (
      
        p_intm_no      GIAC_COMM_SLIP_EXT.intm_no%TYPE,    
        p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
        p_iss_cd       GIPI_COMM_INV_PERIL.iss_cd%TYPE,
        p_policy_id    GIPI_COMM_INV_PERIL.policy_id%TYPE,
        p_line_cd      GIIS_PERIL.line_cd%TYPE

   )
      RETURN comm_peril_sname_tab PIPELINED
   IS
      v_comm_peril_sname   comm_peril_sname_type;
   BEGIN
      FOR i IN (SELECT gper.peril_sname, GCIP.PREMIUM_AMT, 
                (NVL(GCIP.COMMISSION_RT,0) - NVL(GPCI.COMMISSION_RT,0)) COMM_RT, 
            (NVL(GCIP.COMMISSION_AMT,0) - NVL(GPCI.COMMISSION_AMT,0)) COMM_AMT,       
            GCIP.ISS_CD, GCIP.PREM_SEQ_NO
           FROM giis_peril gper, 
                gipi_comm_inv_peril gcip, 
                GIAC_PARENT_COMM_INVPRL GPCI
          WHERE 1 = 1 
                AND gcip.intrmdry_intm_no = p_intm_no
                AND gcip.prem_seq_no = p_prem_seq_no
                AND gcip.iss_cd = p_iss_cd
                --AND gcip.policy_id = NVL(p_policy_id, gcip.policy_id)
                AND gcip.policy_id = p_policy_id
                --AND gper.line_cd = NVL(p_line_cd, gper.line_cd)
                AND gper.line_cd = p_line_cd
                AND gper.peril_cd = gcip.peril_cd
                AND GCIP.INTRMDRY_INTM_NO = GPCI.CHLD_INTM_NO (+)
                AND GCIP.ISS_CD = GPCI.ISS_CD (+)
                AND GCIP.PREM_SEQ_NO = GPCI.PREM_SEQ_NO (+)
                AND GCIP.PERIL_CD = GPCI.PERIL_CD (+)
                ORDER BY GCIP.PERIL_CD)

      LOOP
        v_comm_peril_sname.peril_sname   := i.peril_sname;
        v_comm_peril_sname.premium_amt   := i.premium_amt;
        v_comm_peril_sname.comm_rt       := i.comm_rt;
        v_comm_peril_sname.comm_amt      := i.comm_amt;
        v_comm_peril_sname.iss_cd        := i.iss_cd;
        v_comm_peril_sname.prem_seq_no   := i.prem_seq_no;
        
        
       PIPE ROW (v_comm_peril_sname);  
       
      END LOOP;
      --PIPE ROW (v_comm_peril_sname);

      RETURN;
   END get_comm_peril_sname;


   FUNCTION get_comm_slip_sign (
          
            p_user_id      GIAC_USERS.user_id%TYPE,
            p_report_id    GIAC_DOCUMENTS.report_id%TYPE,
            p_branch_cd    GIAC_DOCUMENTS.branch_cd%TYPE       

   )
      RETURN comm_slip_sign_tab PIPELINED
   IS
      v_comm_slip_sign    comm_slip_sign_type;
   BEGIN
      FOR i IN (SELECT 0 item_no, 'Prepared by:' LABEL, user_name signatory, 
                       designation, ' ' branch_cd
                  FROM GIAC_USERS
                 WHERE user_id = p_user_id
                 UNION
                SELECT b.item_no, b.LABEL, c.signatory, c.designation, a.branch_cd
                  FROM GIAC_DOCUMENTS a, GIAC_REP_SIGNATORY b, GIIS_SIGNATORY_NAMES c 
                 WHERE a.report_no = b.report_no
                       AND a.report_id = b.report_id 
                       AND a.report_id = p_report_id
                       AND NVL(a.branch_cd,NVL(p_branch_cd,'**')) = NVL(p_branch_cd,'**')
                       AND b.signatory_id = c.signatory_id
                 MINUS
                SELECT b.item_no, b.LABEL, c.signatory, c.designation, a.branch_cd
                  FROM GIAC_DOCUMENTS a, GIAC_REP_SIGNATORY b, GIIS_SIGNATORY_NAMES c
                 WHERE a.report_no = b.report_no
                       AND a.report_id = b.report_id
                       AND a.report_id = p_report_id
                       AND a.branch_cd IS NULL 
                       AND EXISTS (SELECT 1 
                                     FROM GIAC_DOCUMENTS
                                    WHERE report_id = p_report_id
                                          AND branch_cd = p_branch_cd)  
                       AND b.signatory_id = c.signatory_id 
                       ORDER BY item_no)


      LOOP
        v_comm_slip_sign.item_no       := i.item_no;
        v_comm_slip_sign.label         := i.label;
        v_comm_slip_sign.signatory     := i.signatory;
        v_comm_slip_sign.designation   := i.designation;
        v_comm_slip_sign.branch_cd     := i.branch_cd;
       PIPE ROW (v_comm_slip_sign);
      END LOOP;

      RETURN;
   END get_comm_slip_sign;
   
   
    FUNCTION get_comm_computed_prem (p_iss_cd   giac_direct_prem_collns.b140_iss_cd%TYPE,
                                     p_prem_seq_no  giac_direct_prem_collns.b140_prem_seq_no%TYPE
                                  )   
        RETURN comm_computed_prem_tab PIPELINED
    
      IS
        v_comm_computed_prem    comm_computed_prem_type;
  
  BEGIN
               --partial premium
        FOR a IN (select nvl(sum(premium_amt),0) partial_prem
                      from giac_direct_prem_collns x
                   where b140_prem_seq_no = p_prem_seq_no
                     and b140_iss_cd = p_iss_cd
                 and exists (select 1
                               from giac_acctrans y
                              where tran_flag NOT IN ('D')
                                and tran_id = x.GACC_TRAN_ID) )
        LOOP
          v_comm_computed_prem.partial_prem := a.partial_prem;

        END LOOP;

                --premium
        FOR b IN (SELECT prem_amt
                         FROM GIPI_INVOICE
                        WHERE iss_cd = p_iss_cd
                             AND prem_seq_no = p_prem_seq_no)
        LOOP
          v_comm_computed_prem.prem_amt := b.prem_amt;
        END LOOP;


                --partial commission
        FOR c IN (select NVL(comm_amt,0) partial_comm
                      from giac_comm_slip_ext
                       where iss_cd = p_iss_cd
                         and prem_seq_no = p_prem_seq_no
                        /* and comm_slip_tag = 'Y'*/)   
        LOOP
         v_comm_computed_prem.partial_comm := c.partial_comm;
        END LOOP;                

                
                --total commission
        FOR d IN ( SELECT (SUM (NVL(gcip.COMMISSION_AMT,0)) - SUM(NVL(gpci.COMMISSION_AMT,0))) total_comm
                 FROM GIPI_COMM_INV_PERIL GCIP, GIAC_PARENT_COMM_INVPRL GPCI
                    WHERE GCIP.INTRMDRY_INTM_NO = GPCI.CHLD_INTM_NO (+)
                      AND GCIP.ISS_CD = GPCI.ISS_CD (+)
                  AND GCIP.PREM_SEQ_NO = GPCI.PREM_SEQ_NO (+)
                  AND GCIP.PERIL_CD = GPCI.PERIL_CD (+)
                  AND GCIP.ISS_CD = p_iss_cd
                  AND GCIP.PREM_SEQ_NO = p_prem_seq_no)
        LOOP
          v_comm_computed_prem.total_comm := d.total_comm;
        END LOOP;

                  
        PIPE ROW (v_comm_computed_prem);
     RETURN;
  END get_comm_computed_prem;

  FUNCTION get_comm_total_wtax    (p_intm_no      GIAC_COMM_PAYTS.intm_no%TYPE,
                                 p_iss_cd       GIAC_COMM_PAYTS.iss_cd%TYPE,
                                 p_prem_seq_no  GIAC_COMM_PAYTS.prem_seq_no%TYPE
                                )   
        RETURN comm_total_wtax_tab PIPELINED   
      IS
        v_comm_total_wtax    comm_total_wtax_type;
  
   BEGIN

        FOR c IN (SELECT SUM(NVL(x.comm_amt,0)) commpayts,
                                 SUM(NVL(x.wtax_amt,0)) s_wtax,
                                 SUM(NVL(x.input_vat_amt,0)) ivat,
                                 SUM(NVL(x.comm_amt,0) - NVL(x.wtax_amt,0) 
                                 + NVL(x.input_vat_amt,0)) net_comm
                   FROM giac_comm_payts x,
                         giac_acctrans   b
                     WHERE NOT EXISTS(SELECT 'X'
                                        FROM giac_reversals c,
                                         giac_acctrans  d
                                     WHERE c.reversing_tran_id = d.tran_id
                                         AND d.tran_flag != 'D'
                                         AND c.gacc_tran_id = x.gacc_tran_id)
                     AND x.gacc_tran_id = b.tran_id
                     AND b.tran_flag   != 'D'
                     AND x.prem_seq_no  = p_prem_seq_no
                      AND x.iss_cd       = p_iss_cd
                     AND x.intm_no      = p_intm_no
                     AND x.gacc_tran_id >= 0 )
        LOOP
          v_comm_total_wtax.commpayts := c.commpayts;
          v_comm_total_wtax.s_wtax      := c.s_wtax;
          v_comm_total_wtax.ivat      := c.ivat;
          v_comm_total_wtax.net_comm  := c.net_comm;
          PIPE ROW (v_comm_total_wtax);
        END LOOP;    
    END;
    
    
   FUNCTION get_intm_type_noFormula (
              p_intm_no     giis_intermediary.parent_intm_no%type)
      RETURN intm_type_noFormula_tab PIPELINED
   IS
      v_intm_type_noFormula      intm_type_noFormula_type;
      v_returned_string          varchar2(200);
      v_parent_intm_no           giis_intermediary.parent_intm_no%type;
      v_lic_tag                  giis_intermediary.lic_tag%type;
      v_type                     giis_intermediary.intm_type%type;
      v_ptype                     giis_intermediary.intm_type%type;

  BEGIN

  FOR i IN (SELECT intm_type, lic_tag, parent_intm_no
              FROM giis_intermediary
             WHERE intm_no = p_intm_no)
     LOOP
      v_type := i.intm_type;
      v_lic_tag := i.lic_tag;
      v_parent_intm_no := i.parent_intm_no;
     END LOOP;

     IF v_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL THEN
        FOR p IN (SELECT intm_type
                    FROM giis_intermediary
                   WHERE intm_no = v_parent_intm_no)
       LOOP
          v_ptype := p.intm_type;
       END LOOP;
        v_intm_type_noFormula.v_returned_string := (v_ptype||'-'||v_parent_intm_no||'/'||v_type||'-'||p_intm_no);
        PIPE ROW (v_intm_type_noFormula);      
       RETURN;
     ELSE
        v_intm_type_noFormula.v_returned_string := (v_type||'-'||p_intm_no);
        PIPE ROW (v_intm_type_noFormula);
       RETURN; 
     END IF;
  
   END;
   
   FUNCTION get_prem_payt_netcomm (
   p_tran_id            giac_acctrans.tran_id%TYPE,
   p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
   p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
   p_curr_cd            giac_order_of_payts.currency_cd%TYPE,
   p_curr_rt            gipi_invoice.currency_rt%TYPE)
   RETURN NUMBER
IS
   v_net_comm   NUMBER := 0;
BEGIN
   BEGIN
    SELECT --NVL(NVL(c.comm_amt,0) - NVL(c.wtax_amt,0) + NVL(c.input_vat_amt,0),0)
           DECODE(p_curr_cd, Giacp.n('CURRENCY_CD'), NVL(NVL(c.comm_amt,0) - NVL(c.wtax_amt,0) + NVL(c.input_vat_amt,0),0),
                                                       ROUND(NVL(((NVL(c.comm_amt,0) - NVL(c.wtax_amt,0) + NVL(c.input_vat_amt,0))/p_curr_rt),0),2))   
                                                       -- judyann 06172011; to display amounts in foreign currency for foreign currency payments    
      INTO v_net_comm
      FROM giac_comm_payts c
     WHERE c.gacc_tran_id= p_tran_id
       AND iss_cd = p_b140_iss_cd
       AND prem_seq_no = p_b140_prem_seq_no;
	EXCEPTION
		WHEN no_data_found THEN
		  v_net_comm := 0;
  END;

   RETURN (v_net_comm);
END get_prem_payt_netcomm;

FUNCTION get_comm_net_amt (
   p_tran_id            giac_acctrans.tran_id%TYPE,
   p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
   p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE
)
   RETURN NUMBER
IS
   v_net_comm   NUMBER := 0;
BEGIN
   BEGIN
      SELECT NVL (  NVL (c.comm_amt, 0)
                  - NVL (c.wtax_amt, 0)
                  + NVL (c.input_vat_amt, 0),
                  0
                 )
        INTO v_net_comm
        FROM giac_comm_payts c
       WHERE c.gacc_tran_id = p_tran_id
         AND iss_cd = p_b140_iss_cd
         AND prem_seq_no = p_b140_prem_seq_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_net_comm := 0;
   END;

   RETURN (v_net_comm);
END get_comm_net_amt;

FUNCTION CF_remarksFormula (
           p_tran_id            giac_acctrans.tran_id%type,
           p_tran_class         giac_acctrans.tran_class%type)
      RETURN VARCHAR2
IS
   v_remarks   VARCHAR2 (2000);
BEGIN
   IF p_tran_class = 'JV'
   THEN
      SELECT particulars
        INTO v_remarks
        FROM giac_acctrans
       WHERE tran_id = p_tran_id;
   ELSIF p_tran_class = 'COL' --OR p_tran_class = 'OR'
   THEN
      SELECT particulars
        INTO v_remarks
        FROM giac_order_of_payts
       WHERE gacc_tran_id = p_tran_id;
   ELSIF p_tran_class = 'DV'
   THEN
      SELECT particulars
        INTO v_remarks
        FROM giac_disb_vouchers
       WHERE gacc_tran_id = p_tran_id;
   ELSIF p_tran_class = 'DM' OR p_tran_class = 'CM'
   THEN
      SELECT particulars
        INTO v_remarks
        FROM giac_cm_dm
       WHERE gacc_tran_id = p_tran_id;
   ELSIF p_tran_class = 'APDC' THEN 
        SELECT particulars
          INTO v_remarks
          FROM giac_apdc_payt
         WHERE apdc_id = p_tran_id;   
   ELSIF p_tran_class = 'CFS' THEN
    BEGIN
      SELECT particulars
        INTO v_remarks
        FROM giac_payt_requests_dtl
       WHERE tran_id = p_tran_id;
    EXCEPTION
      WHEN no_data_found THEN
        v_remarks := NULL;
    END;           
       
   ELSE
      SELECT particulars
        INTO v_remarks
        FROM giac_acctrans
       WHERE tran_id = p_tran_id;
   END IF;

   RETURN (v_remarks);
END CF_remarksFormula; 

--added by steven 09.12.2014; checking of the "RELEASE_COMM_W_UNPRINTED_OR"
    PROCEDURE check_rel_comm_w_unprinted_or (
       p_gacc_tran_id         giac_comm_payts.gacc_tran_id%TYPE,
       p_iss_cd               gipi_comm_invoice.iss_cd%TYPE,
       p_prem_seq_no          gipi_comm_invoice.prem_seq_no%TYPE,
       p_ref_no         OUT   VARCHAR2,
       p_response       OUT   VARCHAR2
    )
    IS
       v_tran_flag            giac_acctrans.tran_flag%TYPE;
       v_tran_id              giac_direct_prem_collns.gacc_tran_id%TYPE;
       v_or_print_tag         giac_direct_prem_collns.or_print_tag%TYPE;
       v_tran_class           giac_acctrans.tran_class%TYPE;
       v_allow_unprinted_or   giac_parameters.param_value_v%TYPE:= NVL (giacp.v ('RELEASE_COMM_W_UNPRINTED_OR'), 'Y');
       v_ref_no               VARCHAR2 (50);
    BEGIN
       p_response := 'SUCCESS';

       FOR i IN (SELECT a.gacc_tran_id, a.or_print_tag, b.tran_flag,
                        b.tran_class
                   FROM giac_direct_prem_collns a, giac_acctrans b
                  WHERE a.gacc_tran_id = b.tran_id
                    AND b.tran_flag <> 'D'
                    AND a.gacc_tran_id NOT IN (
                           SELECT x.gacc_tran_id
                             FROM giac_reversals x, giac_acctrans y
                            WHERE x.gacc_tran_id = y.tran_id
                                  AND y.tran_flag <> 'D')
                    AND a.b140_iss_cd = p_iss_cd
                    AND a.b140_prem_seq_no = p_prem_seq_no)
       LOOP
          v_tran_flag := NVL (i.tran_flag, NULL);
          v_tran_id := NVL (i.gacc_tran_id, NULL);
          v_or_print_tag := NVL (i.or_print_tag, NULL);
          v_tran_class := NVL (i.tran_class, NULL);
          
          -- added condition : shan 10.16.2014
          IF (i.tran_class = 'COL' AND i.or_print_tag = 'Y') OR (i.tran_class <> 'COL' AND i.tran_flag IN ('C', 'P')) THEN
            EXIT;
          END IF;
       END LOOP;

       IF v_tran_id <> p_gacc_tran_id
       THEN
          IF v_tran_class = 'COL'
          THEN
             IF v_or_print_tag = 'N'
             THEN
                SELECT get_ref_no (NVL (v_tran_id, p_gacc_tran_id))
                  INTO v_ref_no
                  FROM DUAL;

                p_ref_no := v_ref_no;

                IF v_allow_unprinted_or = 'Y'
                THEN
                   p_response := 'ALLOWED';
                ELSE
                   p_response := 'NOT_ALLOWED';
                END IF;
             END IF;
          ELSE
             IF v_tran_flag = 'O'
             THEN
                SELECT get_ref_no (NVL (v_tran_id, p_gacc_tran_id))
                  INTO v_ref_no
                  FROM DUAL;

                p_ref_no := v_ref_no;

                IF v_allow_unprinted_or = 'Y'
                THEN
                   p_response := 'ALLOWED';
                ELSE
                   p_response := 'NOT_ALLOWED';
                END IF;
             END IF;
          END IF;
       END IF;
    END;
    
    /**
     ** Created By:     Shan Bati
     ** Date Created:   11.03.2014
     ** Reference By : (GIACS020 - Comm Payts)
     ** Description  : Executes procedure PARAM2_FULL_PREM_PAYT of GIACS020    
     **/
    PROCEDURE param2_full_prem_payt(
        p_iss_cd                gipi_comm_invoice.iss_cd%TYPE,
        p_prem_seq_no           gipi_comm_invoice.prem_seq_no%TYPE,
        p_intm_no               gipi_comm_invoice.INTRMDRY_INTM_NO%TYPE,
        p_comm_amt          OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
        p_wtax_amt          OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
        p_input_vat_amt     OUT GIAC_COMM_PAYTS.INPUT_VAT_AMT%TYPE,
        p_def_comm_amt      OUT NUMBER,
        p_def_input_vat     OUT NUMBER,
        p_drv_comm_amt      OUT NUMBER,
        p_var_max_input_vat OUT NUMBER,
        p_var_clr_rec       OUT VARCHAR2,
        p_var_message       OUT VARCHAR2 
    )
    AS
        var_comm_amt       			gipi_comm_invoice.commission_amt%TYPE := 0;
        var_prnt_comm_amt  			gipi_comm_invoice.commission_amt%TYPE := 0;
        var_whold_tax      			gipi_comm_invoice.wholding_tax%TYPE  := 0;
        var_prnt_whold_tax  		gipi_comm_invoice.wholding_tax%TYPE  := 0;
        var_curr_rt        			gipi_invoice.currency_rt%TYPE := 0;
        var_rec_comm_amt   			giac_comm_payts.comm_amt%TYPE := 0;
        var_rec_wtax_amt   			giac_comm_payts.wtax_amt%TYPE := 0;
        var_comp_comm_amt  			giac_comm_payts.comm_amt%TYPE := 0;
        var_comp_wtax_amt  			giac_comm_payts.wtax_amt%TYPE := 0;
        var_rec_input_vat_amt       giac_comm_payts.comm_amt%TYPE := 0;
        var_intm                    gipi_comm_invoice.intrmdry_intm_no%TYPE;
        var_prnt_intm               gipi_comm_invoice.parent_intm_no%TYPE;
        v_wtax_rate					giis_intermediary.wtax_rate%TYPE := 0;
        v_vat_rt                    giis_intermediary.input_vat_rate%TYPE := 0;
    BEGIN
        p_var_message := 'SUCCESS';
        FOR rec IN (SELECT comm_amt, wtax_amt,
                            input_vat_amt--Vincent 050505: get value of input_vat_amount
                      FROM giac_comm_payts a, giac_acctrans b
                     WHERE a.gacc_tran_id = b.tran_id
                       AND b.tran_flag <> 'D'
                       AND a.iss_cd = p_iss_cd
                       AND a.prem_seq_no = p_prem_seq_no
                       AND a.intm_no = p_intm_no
                       AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
                                                    FROM giac_reversals c, giac_acctrans d
                                                   WHERE c.reversing_tran_id = d.tran_id
                                                     AND d.tran_flag<>'D'))  
        LOOP 
            var_rec_comm_amt   := NVL(var_rec_comm_amt,0) + nvl(rec.comm_amt,0);
            var_rec_wtax_amt   := NVL(var_rec_wtax_amt,0) + nvl(rec.wtax_amt,0);
            var_rec_input_vat_amt   := NVL(var_rec_input_vat_amt,0) + nvl(rec.input_vat_amt,0);--Vincent 050505: hold value of input_vat_amount                
        END LOOP;
        
        BEGIN   
            SELECT j.commission_amt, j.wholding_tax,
                   j.currency_rt, j.intrmdry_intm_no 
              INTO var_comm_amt, var_whold_tax, 
                   var_curr_rt, var_intm
            FROM (SELECT a.commission_amt, a.wholding_tax,
                         b.currency_rt, a.intrmdry_intm_no,
                         a.iss_cd, a.prem_seq_no
                    FROM GIPI_COMM_INVOICE a, GIPI_INVOICE b, GIIS_INTERMEDIARY c -- belle 050510
                   WHERE a.iss_cd = b.iss_cd
                     AND a.prem_seq_no = b.prem_seq_no
                     -- AND a.parent_intm_no = a.intrmdry_intm_no --belle 043010 change to:
                     AND a.intrmdry_intm_no = c.intm_no 
                     AND c.lic_tag = 'Y' 
                    UNION
                   SELECT c.commission_amt, c.wholding_tax, 
                          b.currency_rt, c.intrmdry_intm_no,
                          c.iss_cd, c.prem_seq_no
                     FROM GIPI_INVOICE b, GIPI_COMM_INV_DTL c, GIIS_INTERMEDIARY d --belle 050510
                    WHERE b.iss_cd = c.iss_cd
                      AND b.prem_seq_no = c.prem_seq_no
                      AND c.intrmdry_intm_no = d.intm_no --added by belle 050510 
                      AND d.lic_tag = 'N') j
             WHERE j.iss_cd = p_iss_cd
               AND j.prem_seq_no = p_prem_seq_no
               AND j.intrmdry_intm_no = p_intm_no;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN --mikel 10.17.2012; to prevent ora-1403 - if intm is unlicensed then check if record exist in gipi_comm_inv_dtl table
                p_var_message := 'No record found in commission tables. Please check intermediary maintenance.'; 
                p_var_clr_rec := 'Y';
                RETURN;
        END;  
        
        SELECT wtax_rate, nvl(input_vat_rate,0)vat_rt
          INTO v_wtax_rate, v_vat_rt
          FROM giis_intermediary
         WHERE intm_no = p_intm_no;
	   
        var_comp_comm_amt := (nvl(var_comm_amt,0) * nvl(var_curr_rt,0))- var_rec_comm_amt;
        
        var_comp_wtax_amt := (nvl(var_comp_comm_amt,0) * NVL(v_wtax_rate, 0) / 100); -- var_rec_wtax_amt; --comment out by nieko 07162013
        
        IF var_comp_comm_amt = 0 THEN      		-- judyann 10192006; replaced previous IF statement
            param2_comm_full_paid(p_iss_cd, p_prem_seq_no, p_intm_no, p_var_clr_rec, p_var_message);             -- commission payment equal to invoice commission  		
        ELSIF var_comp_comm_amt > 0 THEN      
            p_comm_amt := var_comp_comm_amt;
            p_wtax_amt := var_comp_wtax_amt; 
            p_input_vat_amt := nvl(nvl(p_comm_amt,0) *  nvl(v_vat_rt,0)/100,0);

            p_var_max_input_vat := (var_comp_comm_amt *	(nvl(v_vat_rt,0)/100));--Vincent 050505: hold max value for input_vat_amount			  			  

            p_drv_comm_amt := p_comm_amt - (p_wtax_amt - nvl(p_input_vat_amt,0) );
        ELSE 
            p_var_message := 'No valid amount of commission for this transaction type.';
            p_var_clr_rec := 'Y';
            RETURN;
        END IF;

        p_def_comm_amt := p_comm_amt;
        p_def_input_vat := p_input_vat_amt;        
    END param2_full_prem_payt;
    
    /**
     ** Created By:     Shan Bati
     ** Date Created:   11.03.2014
     ** Reference By : (GIACS020 - Comm Payts)
     ** Description  : Executes procedure PARAM2_COMM_FULL_PAID of GIACS020    
     **/
    PROCEDURE param2_comm_full_paid(
        p_iss_cd                gipi_comm_invoice.iss_cd%TYPE,
        p_prem_seq_no           gipi_comm_invoice.prem_seq_no%TYPE,
        p_intm_no               gipi_comm_invoice.INTRMDRY_INTM_NO%TYPE,
        p_clr_rec           OUT VARCHAR2,
        p_message           OUT VARCHAR2 
    )
    AS
        var_rec_comm_amt   GIAC_COMM_PAYTS.comm_amt%type := 0;
	    var_tot_comm_amt   GIPI_COMM_INVOICE.commission_amt%type := 0;
        c_rec_comm       GIAC_COMM_PAYTS.comm_amt%type;
        c_tot_comm       GIPI_COMM_INVOICE.commission_amt%type;
        c_rem_comm       GIPI_COMM_INVOICE.commission_amt%type;
    BEGIN
        FOR REC IN (SELECT comm_amt
				      FROM giac_comm_payts a, giac_acctrans b
					 WHERE a.gacc_tran_id = b.tran_id
					   AND b.tran_flag <> 'D'
					   AND a.iss_cd = p_iss_cd
					   AND a.prem_seq_no = p_prem_seq_no
					   AND a.intm_no = p_intm_no
					   AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
													FROM giac_reversals c, giac_acctrans d
					  							   WHERE c.reversing_tran_id=d.tran_id
													 AND d.tran_flag<>'D')) 
	    LOOP
		    var_rec_comm_amt   := NVL(var_rec_comm_amt,0) +  nvl(REC.comm_amt,0);
        END LOOP;

        -- select modified by grace 07.19.2005
        -- added the table GIPI_COMM_INV_DTL to select only the commission amount
        -- of the licensed agent for policies with overriding commission	
        FOR REC2 IN (SELECT nvl(c.commission_amt,a.commission_amt) commission_amt, 
                            b.currency_rt, a.intrmdry_intm_no, a.parent_intm_no
                       FROM gipi_comm_invoice a, gipi_invoice b, gipi_comm_inv_dtl c
                      WHERE a.iss_cd = b.iss_cd
                        AND a.prem_seq_no = b.prem_seq_no
                        AND a.iss_cd = c.iss_cd(+)
                        AND a.prem_seq_no = c.prem_seq_no(+)
                        AND a.intrmdry_intm_no = c.intrmdry_intm_no(+) --added by VJ 091908 to prevent ora-01422 for policies with multi-intermediary (both has parent agent)
                        AND a.iss_cd = p_iss_cd
                        AND a.prem_seq_no = p_prem_seq_no
                        AND a.intrmdry_intm_no = p_intm_no)
        LOOP
            var_tot_comm_amt := NVL(var_tot_comm_amt,0) + (NVL(REC2.commission_amt,0) * NVL(REC2.currency_rt,0));
        END LOOP;

        c_tot_comm := NVL(var_tot_comm_amt,0); 
        c_rec_comm := NVL(var_rec_comm_amt,0);   
        c_rem_comm := NVL(c_tot_comm,0) - NVL(c_rec_comm,0); 
	
	    IF NVL(c_rem_comm,0) = 0 THEN
            p_message := ' Invoice Commission Fully Paid.';
            p_clr_rec := 'Y';
	    END IF;
    END param2_comm_full_paid;
    
    -- start : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
    FUNCTION validate_bill_no(
        p_tran_type       giac_comm_payts.tran_type%TYPE,
        p_iss_cd          giac_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_comm_payts.prem_seq_no%TYPE
    ) RETURN VARCHAR2
    AS
        v_message   VARCHAR2(100) := 'SUCCESS';
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIAC_COMM_PAYTS a,
                         GIAC_ACCTRANS B
                   WHERE A.tran_type = DECODE(p_tran_type, 1, 2, 
                                                           2, 1,
                                                           3, 4,
                                                           4, 3)
                     AND A.iss_cd = p_iss_cd
                     AND A.prem_seq_no = p_prem_seq_no
                     AND A.GACC_TRAN_ID=B.TRAN_ID
                     AND B.TRAN_FLAG = 'O'
                     AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                FROM GIAC_REVERSALS X,
                                                     GIAC_ACCTRANS Y
                                               WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                 AND Y.TRAN_FLAG !='D'))
        LOOP
            v_message := 'Commission payment transaction related to this invoice is still open.';
        END LOOP;
        
        RETURN v_message;
    END validate_bill_no;
    -- end : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
	--added by robert SR 19752 08.13.15
	PROCEDURE get_record_seq_no (
       p_gacc_tran_id    IN       giac_comm_payts.gacc_tran_id%TYPE,
       p_intm_no         IN       giac_comm_payts.intm_no%TYPE,
       p_iss_cd          IN       giac_comm_payts.iss_cd%TYPE,
       p_prem_seq_no     IN       giac_comm_payts.prem_seq_no%TYPE,
       p_comm_tag        IN       giac_comm_payts.comm_tag%TYPE,
       p_record_no       IN       giac_comm_payts.record_no%TYPE,
       p_record_seq_no   OUT      giac_comm_payts.record_seq_no%TYPE
    )
    AS
    BEGIN
       SELECT NVL (MAX (record_seq_no), 0) + 1
         INTO p_record_seq_no
         FROM giac_comm_payts
        WHERE gacc_tran_id = p_gacc_tran_id
          AND intm_no = p_intm_no
          AND iss_cd = p_iss_cd
          AND prem_seq_no = p_prem_seq_no
          AND comm_tag = p_comm_tag
          AND record_no = p_record_no;
    END;
	
	PROCEDURE renumber_comm_payts (
	   p_gacc_tran_id   giac_comm_payts.gacc_tran_id%TYPE
	)
	IS
	   v_cnt_item   NUMBER                    := 0;
	   v_old_no     gipi_witem.item_no%TYPE;
	   v_exist      VARCHAR2 (1);
	BEGIN
	   FOR cnt IN (SELECT   COUNT (*) item, gacc_tran_id, intm_no, iss_cd,
							prem_seq_no, comm_tag, record_no
					   FROM giac_comm_payts
					  WHERE gacc_tran_id = p_gacc_tran_id
				   GROUP BY gacc_tran_id,
							intm_no,
							iss_cd,
							prem_seq_no,
							comm_tag,
							record_no)
	   LOOP
		  v_cnt_item := cnt.item;
	
		  IF v_cnt_item > 1
		  THEN
			 FOR a IN 1 .. v_cnt_item
			 LOOP
				v_old_no := NULL;
				v_exist := 'N';
	
				FOR b IN (SELECT '1'
							FROM giac_comm_payts
						   WHERE gacc_tran_id = cnt.gacc_tran_id
							 AND intm_no = cnt.intm_no
							 AND iss_cd = cnt.iss_cd
							 AND prem_seq_no = cnt.prem_seq_no
							 AND comm_tag = cnt.comm_tag
							 AND record_no = cnt.record_no
							 AND record_seq_no = a)
				LOOP
				   v_exist := 'Y';
				   EXIT;
				END LOOP;
	
				IF v_exist = 'N'
				THEN
				   FOR c IN (SELECT   gacc_tran_id, intm_no, iss_cd, prem_seq_no,
									  tran_type, comm_amt, wtax_amt,
									  input_vat_amt, user_id, last_update,
									  particulars, currency_cd, convert_rate,
									  foreign_curr_amt, def_comm_tag, inst_no,
									  print_tag, or_print_tag, cpi_rec_no,
									  cpi_branch_cd, acct_tag, parent_intm_no,
									  sp_acctg, comm_tag, record_no, disb_comm,
									  record_seq_no
								 FROM giac_comm_payts
								WHERE gacc_tran_id = cnt.gacc_tran_id
								  AND intm_no = cnt.intm_no
								  AND iss_cd = cnt.iss_cd
								  AND prem_seq_no = cnt.prem_seq_no
								  AND comm_tag = cnt.comm_tag
								  AND record_no = cnt.record_no
								  AND record_seq_no > a
							 ORDER BY gacc_tran_id,
									  intm_no,
									  iss_cd,
									  prem_seq_no,
									  comm_tag,
									  record_no,
									  record_seq_no)
				   LOOP
					  v_old_no := c.record_seq_no;
	
					  INSERT INTO giac_comm_payts
								  (gacc_tran_id, intm_no, iss_cd,
								   prem_seq_no, tran_type, comm_amt,
								   wtax_amt, input_vat_amt, user_id,
								   last_update, particulars, currency_cd,
								   convert_rate, foreign_curr_amt,
								   def_comm_tag, print_tag,
								   parent_intm_no, comm_tag, record_no,
								   disb_comm, record_seq_no
								  )
						   VALUES (c.gacc_tran_id, c.intm_no, c.iss_cd,
								   c.prem_seq_no, c.tran_type, c.comm_amt,
								   c.wtax_amt, c.input_vat_amt, c.user_id,
								   c.last_update, c.particulars, c.currency_cd,
								   c.convert_rate, c.foreign_curr_amt,
								   c.def_comm_tag, c.print_tag,
								   c.parent_intm_no, c.comm_tag, c.record_no,
								   c.disb_comm, a
								  );
	
					  DELETE      giac_comm_payts
							WHERE gacc_tran_id = c.gacc_tran_id
							  AND intm_no = c.intm_no
							  AND iss_cd = c.iss_cd
							  AND prem_seq_no = c.prem_seq_no
							  AND comm_tag = c.comm_tag
							  AND record_no = c.record_no
							  AND record_seq_no = v_old_no;
	
					  EXIT;
				   END LOOP;
				END IF;
			 END LOOP;
		  END IF;
	   END LOOP;
	END;
	--end robert SR 19752 08.13.15
    
    --PROCEDURE check_if_paid_or_unpaid (
    FUNCTION check_if_paid_or_unpaid ( -- Modified by Jerome Bautista 03.04.2016 SR 21279
        p_iss_cd        giac_comm_payts.iss_cd%TYPE,
        p_prem_seq_no   giac_comm_payts.prem_seq_no%TYPE
    ) RETURN VARCHAR2 -- Added by Jerome Bautista 03.04.2016 SR 21279
    --IS
    AS
        v_gdpc_amount   NUMBER;
        v_gi_amount     NUMBER;
        v_message       VARCHAR2(100); -- Added by Jerome Bautista 03.04.2016 SR 21279
    BEGIN
--        BEGIN -- Commented by Jerome Bautista 03.04.2016 SR 21279
--            SELECT SUM(a.premium_amt + a.tax_amt)
--              INTO v_gdpc_amount
--              FROM giac_direct_prem_collns a, giac_acctrans b
--             WHERE b140_iss_cd = p_iss_cd 
--               AND b140_prem_seq_no = p_prem_seq_no
--               AND a.gacc_tran_id = b.tran_id
--               AND b.tran_flag NOT IN ('D')
--               AND NOT EXISTS (
--                      SELECT 'x'
--                        FROM giac_reversals g, giac_acctrans h
--                       WHERE g.reversing_tran_id = h.tran_id
--                         AND g.gacc_tran_id = a.gacc_tran_id
--                         AND h.tran_flag <> 'D');
--        EXCEPTION
--            WHEN NO_DATA_FOUND THEN
--                v_gdpc_amount := 0;
--        END;
        FOR a IN (SELECT SUM(a.premium_amt + a.tax_amt) gdpc_amount -- Added by Jerome Bautista 03.04.2016 SR 21279
                 FROM giac_direct_prem_collns a, giac_acctrans b
                WHERE b140_iss_cd = p_iss_cd 
                  AND b140_prem_seq_no = p_prem_seq_no
                  AND a.gacc_tran_id = b.tran_id
                  AND b.tran_flag NOT IN ('D')
                  AND NOT EXISTS (
                         SELECT 'x'
                          FROM giac_reversals g, giac_acctrans h
                         WHERE g.reversing_tran_id = h.tran_id
                           AND g.gacc_tran_id = a.gacc_tran_id
                           AND h.tran_flag <> 'D'))
        LOOP
            v_gdpc_amount := NVL(a.gdpc_amount,0);
        END LOOP;
        
        IF v_gdpc_amount = 0 THEN
            --raise_application_error (-20001, 'NO_PAYMENT'); --override AU -- Commented out by Jerome Bautista 03.04.2016 SR 21279
            v_message := 'NO PAYMENT'; -- Added by Jerome Bautista 03.04.2016 SR 21279
        END IF;
        
--        BEGIN
--            SELECT prem_amt + tax_amt
--              INTO v_gi_amount
--              FROM gipi_invoice
--             WHERE iss_cd = p_iss_cd 
--               AND prem_seq_no = p_prem_seq_no;
--        EXCEPTION
--            WHEN NO_DATA_FOUND THEN
--                v_gi_amount := 0;
--        END;
        
        FOR b IN (SELECT ((prem_amt + tax_amt) * NVL(currency_rt,1)) gi_amount -- Added by Jerome Bautista 03.04.2016 SR 21279
                    FROM gipi_invoice
                   WHERE iss_cd = p_iss_cd 
                     AND prem_seq_no = p_prem_seq_no)
        LOOP
            v_gi_amount := NVL(b.gi_amount,0);
        END LOOP;
        
        IF v_gdpc_amount < v_gi_amount THEN
            --raise_application_error (-20001, 'PARTIAL_PAYMENT'); --forward to MC -- Commented out by Jerome Bautista 03.04.2016 SR 21279
            v_message := 'PARTIAL PAYMENT'; -- Added by Jerome Bautista 03.04.2016 SR 21279
        END IF;
        
        
        RETURN (v_message); -- Added by Jerome Bautista 03.04.2016 SR 21279
    END check_if_paid_or_unpaid;
    
    -- marco - SR 21585 - 03.16.2016
    PROCEDURE check_comm_payt_status (
        p_gacc_tran_id      giac_comm_payts.gacc_tran_id%TYPE
    )
    IS
        v_payt_req_flag     giac_payt_requests_dtl.payt_req_flag%TYPE;
        v_status            cg_ref_codes.rv_meaning%TYPE;
        v_tran_class        giac_acctrans.tran_class%TYPE;
        v_tran_flag         giac_acctrans.tran_flag%TYPE;
    BEGIN
        SELECT tran_class, tran_flag
          INTO v_tran_class, v_tran_flag
          FROM giac_acctrans
         WHERE tran_id = p_gacc_tran_id;        

        IF v_tran_flag != 'O' THEN 
            v_status := cg_ref_codes_pkg.get_rv_meaning1('GIAC_ACCTRANS.TRAN_FLAG', v_tran_flag);
        
            raise_application_error(-20001, 'Geniisys Exception#E#Cannot save Commission Payments. Payment request is ' || v_status || '.');
        ELSIF v_tran_flag = 'O' THEN
            IF v_tran_class = 'DV' THEN
                SELECT payt_req_flag
                  INTO v_payt_req_flag
                  FROM giac_payt_requests_dtl
                 WHERE tran_id = p_gacc_tran_id;
                 
                IF v_payt_req_flag != 'N' THEN
                    v_status := cg_ref_codes_pkg.get_rv_meaning1('GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG', v_payt_req_flag);
                
                    raise_application_error(-20001, 'Geniisys Exception#E#Cannot save Commission Payments. Payment request is ' || v_status || '.');
                END IF;
            END IF;
        END IF;
    END;
    
END GIAC_COMM_PAYTS_PKG;
/


