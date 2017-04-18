CREATE OR REPLACE PACKAGE BODY CPI.BONDS_ENDT_PKG
AS
    
  FUNCTION  get_report_details(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE,
    p_report_id    GIIS_DOCUMENT.report_id%TYPE)
  RETURN report_tab PIPELINED
  IS
     v_report           report_type;
     v_return           VARCHAR2(1) := 'N';
     v_num_temp1        NUMBER(12,2);
     v_num_temp2        NUMBER(12,2);
     v_tax_sum          NUMBER(16,2);
     --V_PARAM_VALUE_N    GIIS_PARAMETERS.PARAM_VALUE_N%type;
     CURSOR main_report IS 
       SELECT   B540.LINE_CD || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999'))
                        || '-' ||LTRIM(TO_CHAR(B540.renew_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_SEQ_NO1,
                B540.extract_id EXTRACT_ID1, B540.policy_id PAR_ID,
                B540.LINE_CD || '-' || b540.subline_cd || '-' || B540.ISS_CD || '-' || LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999'))
                        || '-' || LTRIM(TO_CHAR(B540.renew_NO, '09')) POLICY_NUMBER,
                DECODE(B240.PAR_STATUS,10, B540.LINE_CD  || '-' ||b540.subline_cd || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-'|| LTRIM(TO_CHAR(B540.POL_SEQ_NO, '0999999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || DECODE(B540.REG_POLICY_SW,'N',' **'),             B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **')) PAR_NO,
                B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-'|| LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **')PAR_ORIG,
                A150.LINE_NAME    LINE_LINE_NAME,
                A210.SUBLINE_NAME SUBLINE_SUBLINE_NAME,
                A210.SUBLINE_CD   SUBLINE_SUBLINE_CD,
                A210.LINE_CD      SUBLINE_LINE_CD,
                DECODE(B540.INCEPT_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.INCEPT_DATE,'FMMonth DD, YYYY'))   BASIC_INCEPT_DATE,
                DECODE(B540.EXPIRY_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.EXPIRY_DATE,'FMMonth DD, YYYY'))    BASIC_EXPIRY_DATE,
                B540.EXPIRY_TAG   BASIC_EXPIRY_TAG,
                TO_CHAR(B540.ISSUE_DATE, 'FMMonth DD, YYYY')   BASIC_ISSUE_DATE,
                B540.TSI_AMT      BASIC_TSI_AMT,
                DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'))  SUBLINE_SUBLINE_TIME,
                B540.ACCT_OF_CD   BASIC_ACCT_OF_CD,
                B540.MORTG_NAME   BASIC_MORTG_NAME,
                DECODE(B240.PAR_TYPE, 'E',DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1) ADDRESS1,
                DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2), B540.ADDRESS2) ADDRESS2,
                DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) ADDRESS3,
                DECODE(B240.PAR_TYPE, 'E',DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1)||' '||
                        DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2), B540.ADDRESS2)||' '||
                        DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) basic_addr,
                B540.POL_FLAG          BASIC_POL_FLAG,
                B540.FLEET_PRINT_TAG   FLEET_PRINT_TAG,
                B540.LINE_CD           BASIC_LINE_CD,
                B540.REF_POL_NO        BASIC_REF_POL_NO,
                DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no) BASIC_ASSD_NO,
                DECODE(B540.LABEL_TAG,'Y','Leased to   :','In acct of  :') Label_Tag,
                DECODE(b240.par_type,'E',B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) ENDT_NO,
                --DECODE(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' || B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || ' - ' ||B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) POL_ENDT_NO,  --remove by steve 9/3/2012
				DECODE(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' || B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09'))) POL_ENDT_NO,
                DECODE(B540.ENDT_EXPIRY_TAG,'Y','T.B.A.',TO_CHAR(B540.ENDT_EXPIRY_DATE,'FMMonth DD, YYYY'))  ENDT_EXPIRY_DATE,
                TO_CHAR(B540.EFF_DATE, 'FMMonth DD, YYYY')         BASIC_EFF_DATE,
                decode(b240.par_type,'E',B540.ENDT_EXPIRY_TAG)   ENDT_EXPIRY_TAG,
                B540.INCEPT_TAG        BASIC_INCEPT_TAG,
                B540.SUBLINE_CD        BASIC_SUBLINE_CD,
                B540.ISS_CD            BASIC_ISS_CD,
                B540.ISSUE_YY          BASIC_ISSUE_YY,
                B540.POL_SEQ_NO        BASIC_POL_SEQ_NO,
                B540.RENEW_NO          BASIC_RENEW_NO,
                DECODE(TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM')) BASIC_EFF_TIME,
                DECODE(TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM')) BASIC_ENDT_EXPIRY_TIME,
                B240.PAR_TYPE       PAR_PAR_TYPE,
                B240.PAR_STATUS     PAR_PAR_STATUS,
                B540.CO_INSURANCE_SW BASIC_CO_INSURANCE_SW,
                A210.OP_FLAG        SUBLINE_OPEN_POLICY,
                B540.TSI_AMT    BASIC_TSI_AMT_1,
                b540.cred_branch  cred_br
            FROM gixx_polbasic B540,
                    gixx_parlist B240,
                    giis_line A150,
                    giis_subline A210,
                    giis_assured A020  --,GIIS_DOCUMENT GD
            WHERE B540.extract_ID     = p_extract_id
            AND   B240.EXTRACT_ID     = B540.EXTRACT_ID
            AND   A150.LINE_CD        = B540.LINE_CD
            AND   A210.LINE_CD        = B540.LINE_CD
            AND   A210.SUBLINE_CD     = B540.SUBLINE_CD
            AND   A020.ASSD_NO        = B240.ASSD_NO
            AND ROWNUM <2;
    CURSOR q_1 IS 
        SELECT DECODE(invoice.policy_currency,'Y',sum(invoice.prem_amt),sum(invoice.prem_amt * invoice.currency_rt)) INVOICE_PREM_AMT      
         FROM gixx_invoice invoice, gixx_polbasic pol
        WHERE invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 1
        GROUP BY invoice.extract_id,invoice.policy_currency                                
        UNION
        SELECT DECODE(invoice.policy_currency,'Y',sum(invoice.prem_amt),sum(invoice.prem_amt * invoice.currency_rt)) INVOICE_PREM_AMT      
         FROM gixx_orig_invoice invoice, gixx_polbasic pol
        WHERE invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 2
        GROUP BY invoice.extract_id,invoice.policy_currency;          
            
    CURSOR q_tsi IS 
        SELECT TSI.FX_NAME TSI_FX_NAME, TSI.FX_DESC TSI_FX_DESC,   
               UPPER( TSI.FX_NAME|| ' ' || DH_UTIL.SPELL ( TRUNC ( SUM(TSI.ITM_TSI) ) ) || ' AND ' || LTRIM ( (( SUM(TSI.ITM_TSI) )-( TRUNC ( SUM(TSI.ITM_TSI) ) ) )*100)
                         || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( SUM(TSI.ITM_TSI), '999,999,999,999,999.00' ) ) ) || ') IN ' || TSI.FX_DESC ) TSI_SPELLED_TSI
                  FROM (SELECT ITEM.EXTRACT_ID EXTRACT_ID,
                           SUM(DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', NVL(ITEM.TSI_AMT, 0), 'N', NVL(ITEM.TSI_AMT, 0) * INVOICE.CURRENCY_RT, NVL(ITEM.TSI_AMT, 0))) ITM_TSI,  
                           DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME, 'N', 'PHP', FX.SHORT_NAME) FX_NAME,  
                           DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC, 'N', 'PHILIPPINE PESO', FX.CURRENCY_DESC ) FX_DESC,  
                           INVOICE.CURRENCY_CD INVOICE_FX_CD,      
                           AVG(INVOICE.CURRENCY_RT) AVG_FX_RT           
                   FROM  GIXX_ITEM ITEM,  GIIS_CURRENCY FX,  GIXX_INVOICE  INVOICE,GIXX_POLBASIC POL
                  WHERE (( ITEM.CURRENCY_CD= FX.MAIN_CURRENCY_CD)
                    AND ( ITEM.EXTRACT_ID= INVOICE.EXTRACT_ID)
                    AND ( FX.MAIN_CURRENCY_CD= INVOICE.CURRENCY_CD))
                    AND ITEM.EXTRACT_ID = p_extract_id
                    AND ITEM.EXTRACT_ID = POL.EXTRACT_ID
                    AND POL.CO_INSURANCE_SW = 1
                  GROUP BY ITEM.EXTRACT_ID, 
                          DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME, 'N', 'PHP', FX.SHORT_NAME),
                        DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC, 'N', 'PHILIPPINE PESO', FX.CURRENCY_DESC ),  
                        INVOICE.CURRENCY_CD) TSI
                GROUP BY TSI.EXTRACT_ID, TSI.FX_NAME, TSI.FX_DESC   
                   UNION
                 SELECT TSI.FX_NAME TSI_FX_NAME, 
                       TSI.FX_DESC TSI_FX_DESC,   
                       UPPER( TSI.FX_NAME|| ' ' || DH_UTIL.SPELL ( TRUNC ( SUM(TSI.ITM_TSI) ) )
                                 || ' AND ' || LTRIM ( (( SUM(TSI.ITM_TSI) )-( TRUNC ( SUM(TSI.ITM_TSI) ) ) )*100)
                                 || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( SUM(TSI.ITM_TSI), '999,999,999,999,999.00' ) ) )
                               || ') IN ' || TSI.FX_DESC ) TSI_SPELLED_TSI
                  FROM (SELECT ITEM.EXTRACT_ID EXTRACT_ID,
                           SUM(DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', NVL(ITEM.TSI_AMT, 0), 'N', NVL(ITEM.TSI_AMT, 0) * INVOICE.CURRENCY_RT,
                                       NVL(ITEM.TSI_AMT, 0))) ITM_TSI,  
                           DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME, 'N', 'PHP', FX.SHORT_NAME) FX_NAME,  
                           DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC, 'N', 'PHILIPPINE PESO', FX.CURRENCY_DESC ) FX_DESC,  
                           INVOICE.CURRENCY_CD INVOICE_FX_CD, 
                           AVG(INVOICE.CURRENCY_RT) AVG_FX_RT           
                   FROM  GIXX_ITEM ITEM,  GIIS_CURRENCY FX,  GIXX_ORIG_INVOICE  INVOICE,GIXX_POLBASIC POL
                  WHERE (( ITEM.CURRENCY_CD= FX.MAIN_CURRENCY_CD)
                    AND ( ITEM.EXTRACT_ID= INVOICE.EXTRACT_ID)
                    AND ( FX.MAIN_CURRENCY_CD= INVOICE.CURRENCY_CD))
                    AND ITEM.EXTRACT_ID = p_extract_id
                    AND ITEM.EXTRACT_ID = POL.EXTRACT_ID
                    AND POL.CO_INSURANCE_SW = 2
                  GROUP BY ITEM.EXTRACT_ID, 
                        DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME, 'N', 'PHP', FX.SHORT_NAME),
                        DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC,'N', 'PHILIPPINE PESO',    FX.CURRENCY_DESC ),  
                        INVOICE.CURRENCY_CD) TSI
                  GROUP BY TSI.EXTRACT_ID, TSI.FX_NAME, TSI.FX_DESC;     
    
    CURSOR q_invoice IS 
        SELECT SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) PREMIUM_AMT,
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) TAX_AMT,
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) OTHER_CHARGES,
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) +
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) +
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) TOTAL,
               B450.POLICY_CURRENCY POLICY_CURRENCY
          FROM GIXX_INVOICE B450, GIXX_POLBASIC POL
        WHERE B450.EXTRACT_ID = p_extract_id
              AND B450.EXTRACT_ID = POL.EXTRACT_ID
              AND POL.CO_INSURANCE_SW = 1
        GROUP BY B450.EXTRACT_ID ,B450.POLICY_CURRENCY 
        UNION
        SELECT SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) PREMIUM_AMT,
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) TAX_AMT,
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) OTHER_CHARGES,
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) +
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) +
               SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) TOTAL ,B450.POLICY_CURRENCY POLICY_CURRENCY
          FROM GIXX_ORIG_INVOICE B450,GIXX_POLBASIC POL
         WHERE B450.EXTRACT_ID              = p_extract_id
           AND B450.EXTRACT_ID              = POL.EXTRACT_ID
           AND POL.CO_INSURANCE_SW  = 2
         GROUP BY B450.EXTRACT_ID,B450.POLICY_CURRENCY;
  BEGIN
     FOR i IN main_report
     LOOP
        v_report.par_seq_no1 := i.par_seq_no1;
        v_report.extract_id1 := i.extract_id1;
        v_report.par_id := i.par_id;
        v_report.policy_number := i.policy_number;
        v_report.par_no := i.par_no;
        v_report.par_orig := i.par_orig;
        v_report.line_line_name := i.line_line_name;
        v_report.subline_subline_name := i.subline_subline_name;
        v_report.subline_subline_cd := i.subline_subline_cd;
        v_report.subline_line_cd := i.subline_line_cd;
        v_report.basic_incept_date := i.basic_incept_date;
        v_report.basic_expiry_date := i.basic_expiry_date;
        v_report.basic_expiry_tag := i.basic_expiry_tag;
        v_report.basic_issue_date := i.basic_issue_date;
        v_report.basic_tsi_amt := i.basic_tsi_amt;
        v_report.subline_subline_time := i.subline_subline_time;
        v_report.basic_acct_of_cd := i.basic_acct_of_cd;
        v_report.basic_mortg_name := i.basic_mortg_name;
        v_report.address1 := i.address1;
        v_report.address2 := i.address2;
        v_report.address3 := i.address3;
        v_report.basic_addr := i.basic_addr;
        v_report.basic_pol_flag := i.basic_pol_flag;
        v_report.fleet_print_tag := i.fleet_print_tag;
        v_report.basic_line_cd := i.basic_line_cd;
        v_report.basic_ref_pol_no := i.basic_ref_pol_no;
        v_report.basic_assd_no := i.basic_assd_no;
        v_report.label_tag := i.label_tag;
        v_report.endt_no := i.endt_no;
        v_report.pol_endt_no := i.pol_endt_no;
        v_report.endt_expiry_date := i.endt_expiry_date;
        v_report.basic_eff_date := i.basic_eff_date;
        v_report.endt_expiry_tag := i.endt_expiry_tag;
        v_report.basic_incept_tag := i.basic_incept_tag;
        v_report.basic_subline_cd := i.basic_subline_cd;
        v_report.basic_iss_cd := i.basic_iss_cd;
        v_report.basic_issue_yy := i.basic_issue_yy;
        v_report.basic_pol_seq_no := i.basic_pol_seq_no;
        v_report.basic_renew_no := i.basic_renew_no;
        v_report.basic_eff_time := i.basic_eff_time;
        v_report.basic_endt_expiry_time := i.basic_endt_expiry_time;
        v_report.par_par_type := i.par_par_type;
        v_report.par_par_status := i.par_par_status;
        v_report.basic_co_insurance_sw := i.basic_co_insurance_sw;
        v_report.subline_open_policy := i.subline_open_policy;
        v_report.basic_tsi_amt_1 := i.basic_tsi_amt_1;
        v_report.cred_br := i.cred_br;
        
        v_return := 'Y';
        
     END LOOP;
     
     IF v_return = 'Y' THEN 
        initialize_variables(p_report_id);
     ELSE
        RETURN;
     END IF;   
        
     IF v_report.par_par_type = 'P' THEN
        IF v_report.par_par_status NOT IN (10,99) THEN
        
            v_report.cf_header_1 := 'Var No.';
            v_report.cf_report_title := v_report.rt_par_par;
        ELSE
            v_report.cf_header_1 := 'Policy No.';
            v_report.cf_report_title := v_report.rt_par_policy;
        END IF;
        v_report.cf_header_2 := v_report.par_no;
        v_report.cf_header_3 := '';
        v_report.cf_header_4 := '';
     ELSE 
        v_report.cf_header_1 := 'Endt. No.';
        IF v_report.par_par_status = 10 THEN 
            v_report.cf_header_2 := v_report.endt_no;
            v_report.cf_report_title := v_report.rt_endt_par;
        ELSE
            v_report.cf_header_2 := v_report.par_no;
            v_report.cf_report_title := v_report.rt_endt_policy;
        END IF;
        v_report.cf_header_3 := 'of Policy No.';
        v_report.cf_header_4 := v_report.par_no;
     END IF;
     
     v_report.rt_par_par                    := bonds_endt_pkg.par_par;
     v_report.rt_par_policy                 := bonds_endt_pkg.par_policy;
     v_report.rt_endt_par                   := bonds_endt_pkg.endt_par;
     v_report.rt_endt_policy                := bonds_endt_pkg.endt_policy;
     v_report.rt_par                        := bonds_endt_pkg.par;
     v_report.rt_policy                     := bonds_endt_pkg.policy;
     v_report.rt_par_header                 := bonds_endt_pkg.par_header;
     v_report.rt_endt_header                := bonds_endt_pkg.endt_header;
     v_report.rt_tax_breakdown              := bonds_endt_pkg.tax_breakdown;
     v_report.rt_print_mortgagee            := bonds_endt_pkg.print_mortgagee;
     v_report.rt_print_item_total           := bonds_endt_pkg.print_item_total;
     v_report.rt_print_peril                := bonds_endt_pkg.print_peril;
     v_report.rt_print_renewal_top          := bonds_endt_pkg.print_renewal_top;
     v_report.rt_print_doc_subtitle1        := bonds_endt_pkg.print_doc_subtitle1;
     v_report.rt_print_doc_subtitle2        := bonds_endt_pkg.print_doc_subtitle2;
     v_report.rt_print_doc_subtitle3        := bonds_endt_pkg.print_doc_subtitle3;
     v_report.rt_print_doc_subtitle4        := bonds_endt_pkg.print_doc_subtitle4;
     v_report.rt_print_deductibles          := bonds_endt_pkg.print_deductibles;
     v_report.rt_print_accessories_above    := bonds_endt_pkg.print_accessories_above;
     v_report.rt_print_all_warranties       := bonds_endt_pkg.print_all_warranties;
     v_report.rt_print_wrrnties_fontbig     := bonds_endt_pkg.print_wrrnties_fontbig;
     v_report.rt_print_last_endtxt          := bonds_endt_pkg.print_last_endtxt;
     v_report.rt_print_sub_info             := bonds_endt_pkg.print_sub_info;
     v_report.rt_doc_tax_breakdown          := bonds_endt_pkg.doc_tax_breakdown;
     v_report.rt_print_premium_rate         := bonds_endt_pkg.print_premium_rate;
     v_report.rt_print_mort_amt             := bonds_endt_pkg.print_mort_amt;
     v_report.rt_print_sum_insured          := /*NVL(*/bonds_endt_pkg.print_sum_insured;--, 'N'); --- added by royencela 09/21/2011
     v_report.rt_print_one_item_title       := bonds_endt_pkg.print_one_item_title;
     v_report.rt_print_report_title         := bonds_endt_pkg.print_report_title;
     v_report.rt_print_intm_name            := bonds_endt_pkg.print_intm_name;
     v_report.rt_doc_total_in_box           := bonds_endt_pkg.doc_total_in_box; 
     v_report.rt_doc_subtitle1              := bonds_endt_pkg.doc_subtitle1;
     v_report.rt_doc_subtitle2              := bonds_endt_pkg.doc_subtitle2;
     v_report.rt_doc_subtitle3              := bonds_endt_pkg.doc_subtitle3;
     v_report.rt_doc_subtitle4              := bonds_endt_pkg.doc_subtitle4;
     v_report.rt_invoice_policy_currency    := bonds_endt_pkg.invoice_policy_currency;
     v_report.rt_doc_subtitle4_before_wc    := bonds_endt_pkg.doc_subtitle4_before_wc;
     v_report.rt_print_time                 := bonds_endt_pkg.print_time;
     v_report.rt_deductible_title           := bonds_endt_pkg.deductible_title;
     v_report.rt_print_upper_case           := bonds_endt_pkg.print_upper_case;
     v_report.rt_sum_insured_title          := bonds_endt_pkg.sum_insured_title;
     v_report.rt_item_title                 := bonds_endt_pkg.item_title;
     v_report.rt_peril_title                := bonds_endt_pkg.peril_title;
     v_report.rt_doc_attestation1           := bonds_endt_pkg.doc_attestation1;
     v_report.rt_doc_attestation2           := bonds_endt_pkg.doc_attestation2;
     v_report.rt_attestation_title          := bonds_endt_pkg.attestation_title;
     v_report.rt_print_ref_pol_no           := bonds_endt_pkg.print_ref_pol_no;
     v_report.rt_print_currency_desc        := bonds_endt_pkg.print_currency_desc;
     v_report.rt_print_short_name           := bonds_endt_pkg.print_short_name;
     v_report.rt_print_null_mortgagee       := bonds_endt_pkg.print_null_mortgagee;
     v_report.rt_display_policy_term        := bonds_endt_pkg.display_policy_term;
     v_report.rt_print_lower_dtls           := bonds_endt_pkg.print_lower_dtls;
     v_report.rt_print_polno_endt           := bonds_endt_pkg.print_polno_endt;
     v_report.rt_print_cents                := bonds_endt_pkg.print_cents;
     v_report.rt_display_ann_tsi            := bonds_endt_pkg.display_ann_tsi;
     
     IF v_report.par_par_status = 10 THEN
        v_report.cf_label := bonds_endt_pkg.policy; 
     ELSE
        v_report.cf_label := bonds_endt_pkg.par;
     END IF;
     
     v_report.rt_invoice_policy_currency := policy_currency(
                    p_extract_id, v_report.basic_co_insurance_sw );
     
     v_report.v_count := 0;
     
     FOR DX IN ( 
      SELECT COUNT(extract_id) ctr
        FROM gixx_polwc
       WHERE extract_id = p_extract_id)
     LOOP
        v_report.v_count := DX.ctr;
      END LOOP;         
     
     SELECT DECODE(designation, NULL, assd_name||assd_name2, designation ||' '||assd_name||assd_name2)
      INTO v_report.cf_assd_name
      FROM giis_assured
     WHERE assd_no = v_report.basic_assd_no;
     
     FOR F1 IN( SELECT A.ASSD_NAME  ASSD_NAME
                  FROM GIIS_ASSURED A,GIxx_POLBASic B
                 WHERE B.ACCT_OF_CD > 0
                   AND B.ACCT_OF_CD = v_report.basic_acct_of_cd
                   AND A.ASSD_NO = B.ACCT_OF_CD) 
     LOOP
         v_report.cf_acct_of_cd   :=  F1.ASSD_NAME;                   
        EXIT;
     END LOOP;
     
     IF policy_currency(p_extract_id, v_report.basic_co_insurance_sw)  = 'Y' THEN
        FOR curr_rec IN (SELECT a.short_name currency_desc
                           FROM giis_currency a,gixx_invoice b
                          WHERE a.main_currency_cd = b.currency_cd
                            AND b.extract_id = p_extract_id)
        LOOP
          v_report.short_name := curr_rec.currency_desc; 
          EXIT;
        END LOOP;
     ELSE
        v_report.short_name := giisp.v('PESO SHORT NAME');                                     
     END IF;
    
      
     v_report.cf_prem_amt := bonds_endt_pkg.get_bonds_endt_premium_amt( 
                p_extract_id,            v_report.par_par_type, 
                v_report.par_par_status, v_report.basic_co_insurance_sw, v_report); 
      
     IF NVL(bonds_endt_pkg.print_upper_case,'N') = 'Y' THEN
         v_report.cf_prem_title := 'PREMIUM             : ' || v_report.short_name;
     ELSE
         v_report.cf_prem_title := 'Premium             : ' || v_report.short_name;
     END IF;
     
     IF policy_currency(p_extract_id, v_report.basic_co_insurance_sw)  = 'Y' THEN
        FOR curr_rec IN (SELECT a.currency_desc currency_desc
                           FROM giis_currency a,gixx_invoice b
                          WHERE a.main_currency_cd = b.currency_cd
                            AND b.extract_id = p_extract_id)
        LOOP
          v_report.cf_currency := curr_rec.currency_desc; 
          EXIT;
        END LOOP;
     ELSE
        FOR def_rec IN (SELECT currency_desc
                          FROM giis_currency
                         WHERE short_name IN (SELECT param_value_v
                                                FROM giac_parameters
                                               WHERE param_name = 'DEFAULT_CURRENCY'))
        LOOP
            v_report.cf_currency := def_rec.currency_desc;
        END LOOP;                           
     END IF;
     
     initialize_variables_m_17(p_extract_id, p_report_id,
       v_report.par_id, v_report.par_par_status, v_report.cf_renewal);
     
     FOR i IN q_1
     LOOP
        v_report.invoice_prem_amt   := i.invoice_prem_amt;
     END LOOP;
     
     FOR i IN q_tsi
     LOOP
           v_report.tsi_fx_name         := i.tsi_fx_name;
           v_report.tsi_fx_desc         := i.tsi_fx_desc;
           v_report.tsi_spelled_tsi     := i.tsi_spelled_tsi;
     END LOOP;
     
     FOR i IN q_invoice
     LOOP
        v_report.premium_amt       := i.premium_amt;
        v_report.tax_amt           := i.tax_amt;
        v_report.other_charges     := i.other_charges;
        v_report.total             := i.total;
        --v_report.policy_currency   := i.policy_currency;
     END LOOP;
     
     SELECT SUM(DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))) 
       INTO v_tax_sum
       FROM gixx_invoice invoice, 
            gixx_inv_tax invtax, 
            giis_tax_charges taxcharg,
            gixx_polbasic pol,
            gixx_parlist par
     WHERE ( invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id ) =( ( taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ) )
       AND invoice.extract_id = invtax.extract_id
       AND invoice.extract_id = p_extract_id
       AND invoice.extract_id = pol.extract_id
       AND (pol.co_insurance_sw = 1 OR pol.co_insurance_sw = 2)
       AND par.extract_id    = pol.extract_id
       AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
       AND invtax.item_grp = invoice.item_grp
     GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag,invoice.policy_currency;    
     
     v_report.cf_tax_amt := v_tax_sum;
     
     v_report.cf_amt_due := v_report.premium_amt + v_tax_sum;
     
     get_surety_details(p_extract_id, v_report.su_obligee_name, v_report.su_bond_detail,
        v_report.su_indemnity, v_report.su_np_name, v_report.su_clause_desc,
        v_report.su_coll_flag, v_report.su_coll_desc, v_report.su_waiver_limit, 
        v_report.su_contract_date, v_report.su_contract_dtl
     );
      
     initialize_variables_m_20( p_extract_id, p_report_id, v_report.basic_co_insurance_sw,
            v_report.subline_subline_cd, v_report.subline_line_cd, v_report.basic_iss_cd,
            v_report.basic_issue_yy, v_report.basic_pol_seq_no, v_report.basic_renew_no,
            v_report.par_id, v_report.par_par_status, v_report.cf_user,
            v_report.cf_intm_no, v_report.cf_intm_name, v_report.cf_ref_inv_no,
            v_report.cf_signatory, v_report.cf_designation, v_report.cf_company
     );
    
    SELECT count(extract_id)
      INTO v_report.v_mort_count
      FROM gixx_mortgagee
     WHERE extract_id = p_extract_id;
     
    get_endt_text(
        p_extract_id,
        v_report.endttext01,
        v_report.endttext02,
        v_report.endttext03,
        v_report.endttext04,
        v_report.endttext05,
        v_report.endttext06,
        v_report.endttext07,
        v_report.endttext08,
        v_report.endttext09,
        v_report.endttext10,
        v_report.endttext11,
        v_report.endttext12,
        v_report.endttext13,
        v_report.endttext14,
        v_report.endttext15,
        v_report.endttext16,
        v_report.endttext17
    ); 
     
    PIPE ROW(v_report);
  RETURN;
  END get_report_details;
  
  PROCEDURE initialize_variables (p_report_id IN giis_document.report_id%TYPE)
  IS
  BEGIN
    FOR REPORT IN (
        SELECT TITLE,TEXT 
          FROM giis_document    
         WHERE report_id =p_report_id
    )LOOP
         IF REPORT.TITLE = 'POLICY_PAR_TITLE' THEN
             bonds_endt_pkg.PAR_PAR := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'POLICY_POLICY_TITLE' THEN
             bonds_endt_pkg.PAR_POLICY := REPORT.TEXT;
         END IF; 
         IF REPORT.TITLE = 'ENDT_PAR_TITLE' THEN
             bonds_endt_pkg.ENDT_PAR := REPORT.TEXT;
         END IF; 
         IF REPORT.TITLE = 'ENDT_POLICY_TITLE' THEN
             bonds_endt_pkg.ENDT_POLICY := REPORT.TEXT;
         END IF; 
         IF REPORT.TITLE = 'PRINT_CURRENCY_DESC' THEN
             bonds_endt_pkg.PRINT_CURRENCY_DESC := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
             bonds_endt_pkg.TAX_BREAKDOWN := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_REF_POL_NO' THEN
             bonds_endt_pkg.PRINT_REF_POL_NO := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_MORTGAGEE' THEN
             bonds_endt_pkg.PRINT_MORTGAGEE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_ITEM_TOTAL' THEN
             bonds_endt_pkg.PRINT_ITEM_TOTAL := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_PERIL' THEN
             bonds_endt_pkg.PRINT_PERIL := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_RENEWAL_TOP' THEN
             bonds_endt_pkg.PRINT_RENEWAL_TOP := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE1' THEN
             bonds_endt_pkg.PRINT_DOC_SUBTITLE1 := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_DEDUCTIBLES' THEN
             bonds_endt_pkg.PRINT_DEDUCTIBLES := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE2' THEN
             bonds_endt_pkg.PRINT_DOC_SUBTITLE2 := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE3' THEN
             bonds_endt_pkg.PRINT_DOC_SUBTITLE3 := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE4' THEN
             bonds_endt_pkg.PRINT_DOC_SUBTITLE4 := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_ACCESSORIES_ABOVE' THEN
             bonds_endt_pkg.PRINT_ACCESSORIES_ABOVE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_WARRANTIES_FONT_BIG' THEN
             bonds_endt_pkg.PRINT_WRRNTIES_FONTBIG := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_ALL_WARRANTIES_TITLE_ABOVE' THEN
             bonds_endt_pkg.PRINT_ALL_WARRANTIES := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_LAST_ENDTXT' THEN
             bonds_endt_pkg.PRINT_LAST_ENDTXT := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_SUB_INFO' THEN
             bonds_endt_pkg.PRINT_SUB_INFO := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
             bonds_endt_pkg.DOC_TAX_BREAKDOWN := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_PREMIUM_RATE' THEN
             bonds_endt_pkg.PRINT_PREMIUM_RATE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_MORT_AMT' THEN
             bonds_endt_pkg.PRINT_MORT_AMT := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_SUM_INSURED' THEN
             bonds_endt_pkg.PRINT_SUM_INSURED := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_ONE_ITEM_TITLE' THEN
             bonds_endt_pkg.PRINT_ONE_ITEM_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_REPORT_TITLE' THEN
             bonds_endt_pkg.PRINT_REPORT_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_INTM_NAME' THEN
             bonds_endt_pkg.PRINT_INTM_NAME := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_TOTAL_IN_BOX' THEN
             bonds_endt_pkg.DOC_TOTAL_IN_BOX := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_SUBTITLE1' THEN
             bonds_endt_pkg.DOC_SUBTITLE1  := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_SUBTITLE2' THEN
             bonds_endt_pkg.DOC_SUBTITLE2  := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_SUBTITLE3' THEN
             bonds_endt_pkg.DOC_SUBTITLE3  := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_SUBTITLE4' THEN
             bonds_endt_pkg.DOC_SUBTITLE4  := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_SUBTITLE4_BEFORE_WC' THEN
             bonds_endt_pkg.DOC_SUBTITLE4_BEFORE_WC  := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DEDUCTIBLE_TITLE' THEN
             bonds_endt_pkg.DEDUCTIBLE_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PERIL_TITLE' THEN
             bonds_endt_pkg.PERIL_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'ITEM_TITLE' THEN
             bonds_endt_pkg.ITEM_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'SUM_INSURED_TITLE' THEN
             bonds_endt_pkg.SUM_INSURED_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_UPPER_CASE' THEN
             bonds_endt_pkg.PRINT_UPPER_CASE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_ATTESTATION1' THEN
             bonds_endt_pkg.DOC_ATTESTATION1 := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DOC_ATTESTATION2' THEN
             bonds_endt_pkg.DOC_ATTESTATION2 := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'ATTESTATION_TITLE' THEN
             bonds_endt_pkg.ATTESTATION_TITLE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_SHORT_NAME' THEN
             bonds_endt_pkg.PRINT_SHORT_NAME := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_NULL_MORTGAGEE' THEN
             bonds_endt_pkg.PRINT_NULL_MORTGAGEE := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'DISPLAY_POLICY_TERM' THEN
             bonds_endt_pkg.DISPLAY_POLICY_TERM := REPORT.TEXT;
         END IF;       
         IF REPORT.TITLE = 'PRINT_CENTS' THEN
             bonds_endt_pkg.PRINT_CENTS := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_LOWER_DTLS' THEN
             bonds_endt_pkg.PRINT_LOWER_DTLS := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'PRINT_POLNO_ENDT' THEN
             bonds_endt_pkg.PRINT_POLNO_ENDT := REPORT.TEXT;
         END IF;
         IF REPORT.TITLE = 'BOND_POLICY_TITLE' THEN
             bonds_endt_pkg.POLICY := Initcap(REPORT.TEXT);
         END IF;
    END LOOP;
  END initialize_variables;
  
  FUNCTION policy_currency(
     p_extract_id               gixx_polbasic.extract_id%TYPE, 
     p_basic_co_insurance_sw    gixx_polbasic.co_insurance_sw%TYPE
  ) RETURN VARCHAR2 IS
    v_policy_currency        gixx_invoice.policy_currency%type;
  BEGIN
      IF p_basic_co_insurance_sw = 1 THEN
         FOR a IN (
           SELECT policy_currency
             FROM gixx_invoice
            WHERE extract_id = p_extract_id)
         LOOP
           v_policy_currency := a.policy_currency;
         END LOOP;
      ELSE
         FOR a IN (
           SELECT policy_currency
             FROM gixx_orig_invoice
            WHERE extract_id = p_extract_id)
         LOOP
           v_policy_currency := a.policy_currency;
         END LOOP;        
      END IF;
      RETURN (v_policy_currency);
    END;
  
  FUNCTION get_bonds_endt_q2(
    p_extract_id               gixx_polbasic.extract_id%TYPE
  )RETURN q2_tab PIPELINED IS
    q2_row      q2_type;
  BEGIN
    FOR i IN (SELECT invtax.tax_cd                         INVTAX_TAX_CD, 
                   DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))    INVTAX_TAX_AMT, 
                   taxcharg.tax_desc                    TAXCHARG_TAX_DESC,
                   taxcharg.include_tag                 TAX_CHARGE_INCLUDE_TAG
            FROM gixx_invoice invoice, 
                 gixx_inv_tax invtax, 
                 giis_tax_charges taxcharg,
                 gixx_polbasic pol,
                 gixx_parlist par
            WHERE ( invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id ) =( ( taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ) )
            AND invoice.extract_id = invtax.extract_id
            AND invoice.extract_id = p_extract_id
            AND invoice.extract_id = pol.extract_id
            AND pol.co_insurance_sw = 1
            AND par.extract_id    = pol.extract_id
            AND  DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
            AND invtax.item_grp = invoice.item_grp
            GROUP BY invtax.extract_id, 
                   invtax.tax_cd,  
                   taxcharg.tax_desc,
                   taxcharg.include_tag,invoice.policy_currency
                  UNION
            SELECT invtax.tax_cd                         INVTAX_TAX_CD, 
                   DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))    INVTAX_TAX_AMT, 
                   taxcharg.tax_desc                    TAXCHARG_TAX_DESC,
                              taxcharg.include_tag                 TAX_CHARGE_INCLUDE_TAG
            FROM gixx_orig_invoice invoice, 
                 gixx_orig_inv_tax invtax, 
                 giis_tax_charges taxcharg,
                            gixx_polbasic pol
            WHERE          ( invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id ) =
                     ( ( taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ) )
            AND invoice.extract_id = invtax.extract_id
            AND invoice.extract_id = p_extract_id
            AND invoice.extract_id = pol.extract_id
            AND pol.co_insurance_sw = 2
            GROUP BY invtax.extract_id, 
                   invtax.tax_cd,  
                   taxcharg.tax_desc,
                   taxcharg.include_tag,invoice.policy_currency
            ORDER BY INVTAX_TAX_AMT DESC  )
     LOOP
        q2_row.invtax_tax_cd            := i.invtax_tax_cd;
        q2_row.invtax_tax_amt           := i.invtax_tax_amt;
        q2_row.taxcharg_tax_desc        := i.taxcharg_tax_desc;
        q2_row.tax_charge_include_tag   := i.tax_charge_include_tag;
        PIPE ROW(q2_row);
     END LOOP;
  END;
  
  FUNCTION get_bonds_endt_premium_amt(  
      p_extract_id               gixx_polbasic.extract_id%TYPE,
      p_par_par_type             gixx_parlist.par_type%TYPE,
      p_par_par_status           gixx_parlist.par_status%TYPE,
      p_basic_co_insurance_sw    gixx_polbasic.co_insurance_sw%TYPE,
      p_report                   report_type
  )RETURN NUMBER IS
      v_prem_amt  NUMBER(16,2) := p_report.premium_amt;--:PREMIUM_AMT;
      v_param_value_n  giis_parameters.param_value_n%TYPE;
  BEGIN
    SELECT PARAM_VALUE_N
      INTO V_PARAM_VALUE_N
      FROM GIIS_PARAMETERS
     WHERE PARAM_NAME LIKE 'NEW_PREM_AMT';
    
    IF p_par_par_status = 10 AND p_par_par_type = 'E' AND p_basic_co_insurance_sw = 2 THEN
        FOR A IN ( SELECT B.TAX_CD  TAX_CD, 
                   DECODE(nvl(A.POLICY_CURRENCY,'N'),'Y', NVL(B.TAX_AMT,0) * A.CURRENCY_RT, NVL(B.TAX_AMT,0)) TAX_AMT
                   FROM GIXX_ORIG_INVOICE A, GIXX_ORIG_INV_TAX B,GIXX_POLBASIC POL
                  WHERE A.EXTRACT_ID = B.EXTRACT_ID
                    AND A.ITEM_GRP = B.ITEM_GRP
                    AND A.EXTRACT_ID = p_extract_id
                    AND A.EXTRACT_ID = POL.EXTRACT_ID
                    AND POL.CO_INSURANCE_SW = 2
        )LOOP
             IF V_PARAM_VALUE_N = A.TAX_CD THEN
                  V_PREM_AMT := V_PREM_AMT + A.TAX_AMT;
             ELSE
                  V_PREM_AMT := V_PREM_AMT;
             END IF;          
             
      END LOOP;
    ELSE
      FOR A IN ( SELECT DECODE(invoice.policy_currency,'Y', SUM(invtax.tax_amt), 
                            SUM(invtax.tax_amt * invoice.currency_rt)) tax_amt, 
                          taxcharg.include_tag                 include_tag
                   FROM gixx_invoice invoice, gixx_inv_tax invtax, giis_tax_charges taxcharg, gixx_polbasic pol, gixx_parlist par
                  WHERE invtax.iss_cd = taxcharg.iss_cd AND invtax.line_cd = taxcharg.line_cd
                    AND invtax.tax_cd = taxcharg.tax_cd AND invtax.tax_id = taxcharg.tax_id 
                    AND invoice.extract_id = invtax.extract_id AND invoice.extract_id = p_extract_id
                    AND invoice.extract_id = pol.extract_id AND pol.co_insurance_sw = 1
                    AND par.extract_id = pol.extract_id
                    AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                    AND invtax.item_grp = invoice.item_grp
                  GROUP BY invtax.extract_id,  invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag, invoice.policy_currency 
              UNION
                 SELECT DECODE(invoice.policy_currency,'Y', SUM(invtax.tax_amt), SUM(invtax.tax_amt * invoice.currency_rt))    tax_amt, taxcharg.include_tag include_tag
                  FROM gixx_orig_invoice invoice, gixx_orig_inv_tax invtax, giis_tax_charges taxcharg, gixx_polbasic pol
                 WHERE invtax.iss_cd = taxcharg.iss_cd AND invtax.line_cd = taxcharg.line_cd
                   AND invtax.tax_cd = taxcharg.tax_cd AND invtax.tax_id = taxcharg.tax_id 
                   AND invoice.extract_id = invtax.extract_id AND invoice.extract_id = p_extract_id
                   AND invoice.extract_id = pol.extract_id AND pol.co_insurance_sw = 2
                 GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag, invoice.policy_currency) 
        LOOP
                      
             IF A.INCLUDE_TAG = 'Y' THEN
                  V_PREM_AMT := V_PREM_AMT + A.TAX_AMT;
             ELSE
                  V_PREM_AMT := V_PREM_AMT;
             END IF;
             
        END LOOP;  
    END IF;  
    
    RETURN (V_PREM_AMT);
  
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN (p_report.premium_amt);
  END;
  
  PROCEDURE initialize_variables_m_20(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_report_id             IN  giis_document.report_id%TYPE,
    p_basic_co_insurance_sw IN  gixx_polbasic.co_insurance_sw%TYPE,
    p_subline_subline_cd    IN  giis_subline.subline_cd%TYPE,
    p_subline_line_cd       IN  giis_subline.line_cd%TYPE,
    p_basic_iss_cd          IN  gixx_polbasic.iss_cd%TYPE,
    p_basic_issue_yy        IN  gixx_polbasic.issue_yy%TYPE,
    p_basic_pol_seq_no      IN  gixx_polbasic.pol_seq_no%TYPE,
    p_basic_renew_no        IN  gixx_polbasic.renew_no%TYPE,
    p_par_id                IN  gixx_parlist.par_id%TYPE, -- or number (10)
    p_par_par_status        IN  gixx_parlist.par_status%TYPE,
    p_cf_user               OUT VARCHAR2, --gixx_polbasic.user_id%TYPE, 9 + 40+
    p_cf_intm_no            OUT VARCHAR2, -- 400
    p_cf_intm_name          OUT VARCHAR2, -- 100
    p_cf_ref_inv_no         OUT gixx_invoice.ref_inv_no%TYPE,
    p_cf_signatory          OUT VARCHAR2, -- 50
    p_cf_designation        OUT VARCHAR2, -- 50
    p_cf_company            OUT giis_parameters.param_value_v%TYPE
  )
  IS
    --for cf_ref_inv_no
    v_count             NUMBER(2):=1;
    --FOR INTM_NAME
    v_agent                giis_intermediary.intm_name%type; -- declared as varchar2(400) in intm_no, might cause errors
    v_parent            giis_intermediary.intm_name%type; -- 
    v_orig_agent        giis_intermediary.intm_name%type; --
    v_orig_parent        giis_intermediary.intm_name%type; --
    -- FOR CF_USER
    v_user              gixx_polbasic.user_id%TYPE;
    v_user_create       gixx_polbasic.user_id%TYPE;
  BEGIN
    -- CF_USER
    IF p_par_par_status = 10 THEN
        FOR c IN(
          SELECT a.user_id user_id
            FROM gipi_parhist a,gipi_polbasic b
             WHERE a.par_id     = b.par_id
               AND a.parstat_cd = '10'
               AND b.policy_id  = p_par_id)
        LOOP
            v_user:=c.user_id;
        END LOOP; 
        
      FOR a IN (
        SELECT b.par_id,b.user_id user2,b.PARSTAT_DATE
          FROM gipi_polbasic a, gipi_parhist b
         WHERE a.par_id = b.par_id
           AND a.policy_id = p_par_id
           AND b.PARSTAT_DATE = (SELECT MIN(b.PARSTAT_DATE) 
                                   FROM gipi_polbasic a, gipi_parhist b              
                                  WHERE a.par_id = b.par_id
                                    AND a.policy_id = p_par_id))
      LOOP
        v_user_create := a.user2;
      END LOOP;
    ELSE 
        FOR c IN(
          SELECT a.user_id user_id
            FROM gipi_parhist a,gipi_parlist b
           WHERE a.par_id     = b.par_id
             AND a.parstat_cd = '10'
             AND b.par_id  = p_par_id)
        LOOP
            v_user:=c.user_id;
        END LOOP;  
      
      FOR a IN(
        SELECT b.par_id,b.user_id user2,b.PARSTAT_DATE
          FROM gipi_parlist a, gipi_parhist b
         WHERE a.par_id = b.par_id
           AND a.par_id = p_par_id
           AND b.PARSTAT_DATE = (SELECT MIN(b.PARSTAT_DATE) 
                                   FROM gipi_parlist a, gipi_parhist b              
                                  WHERE a.par_id = b.par_id
                                    AND a.par_id = p_par_id))
      LOOP
        v_user_create := a.user2;
      END LOOP;
    END IF;
  
    p_cf_user := v_user_create||/*' / '|| v_USER ||*/ chr(10) ||TO_CHAR(SYSDATE,'DD-MON-RR')||' '||TO_CHAR(SYSDATE,'HH24:MI:SS');
  
    -- CF_INTM_NO
       FOR a IN ( 
          SELECT DECODE(parent.ref_intm_cd,NULL, TO_CHAR(a.parent_intm_no,'999999999990'), TO_CHAR(a.parent_intm_no,'999999999990')||'-'||parent.ref_intm_cd)  parent_intm_no,
                 DECODE(agent.ref_intm_cd,NULL, TO_CHAR(a.intrmdry_intm_no,'999999999990'), TO_CHAR(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
            FROM giis_intermediary agent, giis_intermediary parent, gixx_comm_invoice a 
           WHERE a.parent_intm_no   = parent.intm_no
             AND a.intrmdry_intm_no = agent.intm_no
             AND a.extract_id       = p_extract_id)
        LOOP
            v_parent := a.parent_intm_no;
            v_agent  := a.agent_intm_no;
            EXIT;
        END LOOP;
        
        IF v_parent = v_agent THEN
            p_cf_intm_no := ('/ '||LTRIM(v_agent));
        ELSE
            p_cf_intm_no := LTRIM(v_parent)||' / '||LTRIM(v_agent);
        END IF;
      
        IF v_parent IS NULL AND v_agent IS NULL  THEN
        FOR a IN ( 
          SELECT DECODE(parent.ref_intm_cd,NULL, TO_CHAR(a.parent_intm_no,'999999999990'), TO_CHAR(a.parent_intm_no,'999999999990')||'-'||parent.ref_intm_cd)  parent_intm_no,
                 DECODE(agent.ref_intm_cd,NULL, TO_CHAR(a.intrmdry_intm_no,'999999999990'), TO_CHAR(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
            FROM giis_intermediary agent, giis_intermediary parent, gipi_comm_invoice a 
           WHERE a.parent_intm_no   = parent.intm_no
             AND a.intrmdry_intm_no = agent.intm_no
             AND a.policy_id  IN (SELECT a.policy_id 
                                    FROM gipi_polbasic a, gipi_invoice b
                                   WHERE a.policy_id   = b.policy_id
                                     AND a.line_cd     = p_subline_line_cd
                                     AND a.subline_cd  = p_subline_subline_cd
                                     AND a.iss_cd      = p_basic_iss_cd 
                                     AND a.issue_yy    = p_basic_issue_yy
                                     AND a.pol_seq_no  = p_basic_pol_seq_no
                                     AND a.renew_no    = p_basic_renew_no
                                     AND a.endt_seq_no = 00
                                     AND a.pol_flag IN ('1','2','3')))
            LOOP
                v_orig_parent := a.parent_intm_no;
                v_orig_agent  := a.agent_intm_no;
                EXIT;
            END LOOP;
            IF v_orig_parent = v_orig_agent THEN
               p_cf_intm_no := ('/ '||LTRIM(v_orig_agent));
            ELSE
               p_cf_intm_no := LTRIM(v_orig_parent)||' / '||LTRIM(v_orig_agent);
            END IF;
      END IF;
      p_cf_intm_no := LTRIM(p_cf_intm_no);
      
    -- CF_INTM_NAME
    FOR a in ( 
        SELECT PARENT.intm_name parent_intm_name, agent.intm_name agent_intm_name
          FROM giis_intermediary agent, giis_intermediary PARENT, gixx_comm_invoice a 
        WHERE a.parent_intm_no   = PARENT.intm_no
            AND a.intrmdry_intm_no = agent.intm_no
            AND a.extract_id       = p_extract_id)
     LOOP
        v_parent := a.parent_intm_name; 
        v_agent := a.agent_intm_name;
        EXIT;
     END LOOP;
    
      IF v_parent = v_agent THEN
        p_cf_intm_name := LTRIM('/ '||v_agent);
      ELSE
        p_cf_intm_name := v_parent||' / '||v_agent;
      END IF;
    
      IF v_parent IS NULL AND v_agent IS NULL THEN
        FOR a in ( 
          SELECT PARENT.intm_name parent_intm_name, agent.intm_name agent_intm_name
                  FROM giis_intermediary agent, giis_intermediary parent, gipi_comm_invoice a 
                 WHERE a.parent_intm_no   = parent.intm_no
                 AND a.intrmdry_intm_no = agent.intm_no
                 AND a.policy_id  IN (SELECT a.policy_id 
                                        FROM gipi_polbasic a, gipi_invoice b
                                       WHERE a.policy_id   = b.policy_id             AND a.line_cd     = p_subline_line_cd
                                         AND a.subline_cd  = p_subline_subline_cd    AND a.iss_cd      = p_basic_iss_cd 
                                         AND a.issue_yy    = p_basic_issue_yy        AND a.pol_seq_no  = p_basic_pol_seq_no
                                         AND a.renew_no    = p_basic_renew_no        AND a.endt_seq_no = 00
                                         AND a.pol_flag IN ('1','2','3')))
            LOOP
                v_orig_parent := a.parent_intm_name;
                v_orig_agent  := a.agent_intm_name;
                EXIT;
            END LOOP;
            IF v_orig_parent = v_orig_agent THEN
               p_cf_intm_name := LTRIM('/ '||v_orig_agent);
            ELSE
               p_cf_intm_name := v_orig_parent||' / '||v_orig_agent;
            END IF;
      END IF;
      p_cf_intm_name := LTRIM(p_cf_intm_name);
  
    -- CF_REf_INv_NO ****************
        IF p_basic_co_insurance_sw = 1 THEN
            FOR a IN (
                 SELECT ref_inv_no
                 FROM gixx_invoice
                   WHERE extract_id = p_extract_id)
            LOOP
                IF v_count = 1 THEN
                     p_cf_ref_inv_no := a.ref_inv_no;
                ELSE
                     p_cf_ref_inv_no := p_cf_ref_inv_no || chr(10) || a.ref_inv_no;
                END IF;
            END LOOP;
    ELSE
          FOR a IN (
               SELECT ref_inv_no
                 FROM gixx_invoice
                   WHERE extract_id = p_extract_id)
            LOOP
                IF v_count = 1 THEN
                     p_cf_ref_inv_no := a.ref_inv_no;
                ELSE
                     p_cf_ref_inv_no := p_cf_ref_inv_no || chr(10) || a.ref_inv_no;
                END IF;
            END LOOP;
    END IF;
  
    -- CF_SIGNATORY / CF_DESIGNATION  *************
    FOR c IN(SELECT signatory, designation
               FROM giis_signatory_names a,giis_signatory b
              WHERE a.signatory_id=b.signatory_id
                AND iss_cd = (SELECT DISTINCT /* distinct added by roy 20110916*/iss_cd
                                   FROM gixx_polbasic
                               WHERE extract_id = p_extract_id)         
                 AND b.current_signatory_sw='Y'
                AND    b.line_cd in (SELECT param_value_v
                                     FROM giis_parameters
                                   WHERE param_name= 'LINE_CODE_SU')
                AND b.report_id = 'BONDS')
    LOOP
        p_cf_signatory    :=  C.signatory;
        p_cf_designation  :=  C.designation;
    END LOOP;
   
    -- CF_COMPANY ****************
    FOR name IN (
      SELECT param_value_v
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME')
    LOOP
       p_cf_company := name.param_value_v;
    END LOOP;
  END initialize_variables_m_20;
  
  PROCEDURE initialize_variables_m_17(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_report_id             IN  giis_document.report_id%TYPE,
    p_par_id                IN  gixx_parlist.par_id%TYPE, -- or number (10)
    p_par_par_status        IN  gixx_parlist.par_status%TYPE,
    p_cf_renewal            OUT VARCHAR2
  )IS
  BEGIN
    -- CF_RENEWAL
    IF p_par_par_status = 10 THEN
         FOR a in (
            SELECT a.line_cd || '-' || a.subline_cd || '-' ||a.iss_cd || '-' ||
                   LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||LTRIM(TO_CHAR(a.pol_seq_no, '099999')) || '-' || 
                     LTRIM(TO_CHAR(a.renew_no, '09')) policy_no 
              FROM gipi_polbasic a, gipi_polnrep b
             WHERE b.new_policy_id = p_par_id
               AND a.policy_id     = b.old_policy_id)
         LOOP
             IF p_cf_renewal IS NULL THEN
                 p_cf_renewal := a.policy_no;
             ELSE
                 p_cf_renewal := p_cf_renewal || chr(10) || a.policy_no;
             END IF;
         END LOOP;
      ELSE
         FOR a IN (
           SELECT a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' ||
                       LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||
                       LTRIM(TO_CHAR(a.pol_seq_no, '099999')) || '-' || 
                    LTRIM(TO_CHAR(a.renew_no, '09')) policy_no 
             FROM gipi_polbasic a, gipi_wpolnrep b
            WHERE b.par_id    = p_extract_id
              AND a.policy_id = b.old_policy_id) 
         LOOP
             IF p_cf_renewal IS NULL THEN
                 p_cf_renewal := a.policy_no;
             ELSE
                 p_cf_renewal := p_cf_renewal || chr(10) || a.policy_no;
             END IF;
         END LOOP;
      END IF;
  END initialize_variables_m_17;


  /**
  * UNFINISHED
  */
  PROCEDURE initialize_variables_m_08(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_print_null_mortgagee  IN  giis_document.text%TYPE,
    p_cf_mortgagee_title    OUT VARCHAR2
  )IS
    v_count    NUMBER:=0;
  BEGIN
    -- CF_MORTGAGEE_TITLE
      SELECT count(extract_id)
        INTO v_count
        FROM gixx_mortgagee
       WHERE extract_id = p_extract_id;
         
      IF p_print_null_mortgagee = 'Y'  OR v_count = 0 THEN
          p_cf_mortgagee_title := 'Mortgagee   : None';
      ELSE
          p_cf_mortgagee_title := 'Mortgagee   :';
      END IF;
      
     -- CF_MORTGAGEE_NAME
     
  END initialize_variables_m_08;
  
  PROCEDURE init_vars_q_warranties(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_wc_wc_title           OUT gixx_polwc.wc_title%TYPE,
    p_polwc_wc_text01       OUT VARCHAR2, --2000
    p_polwc_wc_text02       OUT VARCHAR2,    p_polwc_wc_text03       OUT VARCHAR2, 
    p_polwc_wc_text04       OUT VARCHAR2,    p_polwc_wc_text05       OUT VARCHAR2, 
    p_polwc_wc_text06       OUT VARCHAR2,    p_polwc_wc_text07       OUT VARCHAR2, 
    p_polwc_wc_text08       OUT VARCHAR2,    p_polwc_wc_text09       OUT VARCHAR2, 
    p_polwc_wc_text10       OUT VARCHAR2,    p_polwc_wc_text11       OUT VARCHAR2, 
    p_polwc_wc_text12       OUT VARCHAR2,    p_polwc_wc_text13       OUT VARCHAR2, 
    p_polwc_wc_text14       OUT VARCHAR2,    p_polwc_wc_text15       OUT VARCHAR2, 
    p_polwc_wc_text16       OUT VARCHAR2,    p_polwc_wc_text17       OUT VARCHAR2, 
    p_warrc_wc_text01       OUT VARCHAR2, --2000              
    p_warrc_wc_text02       OUT VARCHAR2,    p_warrc_wc_text03       OUT VARCHAR2,
    p_warrc_wc_text04       OUT VARCHAR2,    p_warrc_wc_text05       OUT VARCHAR2,
    p_warrc_wc_text06       OUT VARCHAR2,    p_warrc_wc_text07       OUT VARCHAR2,
    p_warrc_wc_text08       OUT VARCHAR2,    p_warrc_wc_text09       OUT VARCHAR2,
    p_warrc_wc_text10       OUT VARCHAR2,    p_warrc_wc_text11       OUT VARCHAR2,
    p_warrc_wc_text12       OUT VARCHAR2,    p_warrc_wc_text13       OUT VARCHAR2,
    p_warrc_wc_text14       OUT VARCHAR2,    p_warrc_wc_text15       OUT VARCHAR2,
    p_warrc_wc_text16       OUT VARCHAR2,    p_warrc_wc_text17       OUT VARCHAR2,
    p_polwc_change_tag    OUT VARCHAR2, -- 1
    p_wc_wc_cd            OUT VARCHAR2, -- 4 
    p_wc_print_sw         OUT VARCHAR2
  )IS 
  BEGIN 
    SELECT      NVL(WC.WC_TITLE,' '),  NVL(WC.WC_TEXT01,' '),     NVL(WC.WC_TEXT02,' '),       NVL(WC.WC_TEXT03,' '),     
                NVL(WC.WC_TEXT04,' '),     NVL(WC.WC_TEXT05,' '),  NVL(WC.WC_TEXT06,' '),  NVL(WC.WC_TEXT07,' '),     
                NVL(WC.WC_TEXT08,' '),     NVL(WC.WC_TEXT09,' '),  NVL(WC.WC_TEXT10,' '),  NVL(WC.WC_TEXT11,' '),     
                NVL(WC.WC_TEXT12,' '),     NVL(WC.WC_TEXT13,' '),  NVL(WC.WC_TEXT14,' '),  NVL(WC.WC_TEXT15,' '),     
                NVL(WC.WC_TEXT16,' '),     NVL(WC.WC_TEXT17,' '),                      
                NVL(GWC.WC_TEXT01,' '),  NVL(GWC.WC_TEXT02,' '),  NVL(GWC.WC_TEXT03,' '),  NVL(GWC.WC_TEXT04,' '),
                NVL(GWC.WC_TEXT05,' '),  NVL(GWC.WC_TEXT06,' '),  NVL(GWC.WC_TEXT07,' '),  NVL(GWC.WC_TEXT08,' '),
                NVL(GWC.WC_TEXT09,' '),  NVL(GWC.WC_TEXT10,' '),  NVL(GWC.WC_TEXT11,' '),  NVL(GWC.WC_TEXT12,' '),
                NVL(GWC.WC_TEXT13,' '),  NVL(GWC.WC_TEXT14,' '),  NVL(GWC.WC_TEXT15,' '),  NVL(GWC.WC_TEXT16,' '),
                NVL(GWC.WC_TEXT17,' '),
                WC.CHANGE_TAG,--1
                WC.WC_CD, --4  
                WC.PRINT_SW
      INTO p_wc_wc_title,      
           p_polwc_wc_text01,   p_polwc_wc_text02,  p_polwc_wc_text03,   p_polwc_wc_text04,
           p_polwc_wc_text05,   p_polwc_wc_text06,  p_polwc_wc_text07,   p_polwc_wc_text08,
           p_polwc_wc_text09,   p_polwc_wc_text10,  p_polwc_wc_text11,   p_polwc_wc_text12,
           p_polwc_wc_text13,   p_polwc_wc_text14,  p_polwc_wc_text15,   p_polwc_wc_text16,
           p_polwc_wc_text17,                      
           p_warrc_wc_text01,   p_warrc_wc_text02,  p_warrc_wc_text03,   p_warrc_wc_text04,
           p_warrc_wc_text05,   p_warrc_wc_text06,  p_warrc_wc_text07,   p_warrc_wc_text08,
           p_warrc_wc_text09,   p_warrc_wc_text10,  p_warrc_wc_text11,   p_warrc_wc_text12,
           p_warrc_wc_text13,   p_warrc_wc_text14,  p_warrc_wc_text15,   p_warrc_wc_text16,
           p_warrc_wc_text17,
           p_polwc_change_tag, p_wc_wc_cd, p_wc_print_sw
      FROM     GIXX_POLWC WC,
               GIIS_WARRCLA GWC
     WHERE GWC.MAIN_WC_CD = WC.WC_CD
       AND GWC.LINE_CD = WC.LINE_CD
       AND WC.EXTRACT_ID = p_extract_id;
  END init_vars_q_warranties;
  
  
  FUNCTION get_bonds_endt_q_mortgagee(
    p_extract_id   gixx_polbasic.extract_id%TYPE
  )RETURN q_mortgagee_tab PIPELINED IS
    v_mort q_mortgagee_type;
    CURSOR q_mortgagee IS 
        SELECT DISTINCT A.ISS_CD MORTGAGEE_ISS_CD,
               B.MORTG_NAME MORTGAGEE_NAME ,
               A. ITEM_NO MORTGAGEE_ITEM_NO, 
               A.AMOUNT MORTGAGEE_AMOUNT
          FROM    gixx_mortgagee A,giis_mortgagee B,gixx_polbasic C
         WHERE A.EXTRACT_ID = C.EXTRACT_ID
           AND A.ISS_CD    = B.ISS_CD
           AND A.MORTG_CD  = B.MORTG_CD
           AND a.extract_id = p_extract_id;
  BEGIN
    FOR i IN q_mortgagee
    LOOP
        v_mort.q_mortgagee_iss_cd := i.mortgagee_iss_cd;
        v_mort.q_mortgagee_name   := i.mortgagee_name;
        v_mort.q_mortgagee_item_no:= i.mortgagee_item_no;
        v_mort.q_mortgagee_amount := i.mortgagee_amount;
        PIPE ROW(v_mort);
    END LOOP;
  END get_bonds_endt_q_mortgagee;
  
  FUNCTION get_q_coinsurance(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN q_coinsurance_tab PIPELINED IS
    q_co q_coinsurance_type;
    CURSOR looper IS
        SELECT CO.CO_RI_TSI_AMT   COINSURER_RI_TSI_AMT,
               RE.RI_NAME         REINSURER_RI_NAME
          FROM GIXX_CO_INSURER CO, GIIS_REINSURER RE
         WHERE  CO.CO_RI_CD =  RE.RI_CD  
           AND CO.extract_id = p_extract_id;
  BEGIN
    FOR i IN looper
    LOOP
        q_co.coinsurer_ri_tsi_amt   := i.coinsurer_ri_tsi_amt;
        q_co.reinsurer_ri_name      := i.reinsurer_ri_name;
        PIPE ROW(q_co);
    END LOOP;
  END get_q_coinsurance;  
  
  PROCEDURE init_vars_m_15(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_basic_co_insurance_sw IN  gixx_polbasic.co_insurance_sw%TYPE,
    p_print_cents           IN  giis_document.text%TYPE, 
    p_display_ann_tsi       IN  giis_document.text%TYPE,
    p_print_short_name      IN  giis_document.text%TYPE,
    p_short_name            IN  VARCHAR2,        
    p_cf_spell_tsi          OUT VARCHAR2,
    p_cf_basic_tsi_spell    OUT VARCHAR2
  ) IS 
    v_currency_desc        VARCHAR2(400);
    v_short_name        giis_currency.short_name%type;
    v_short_name2        giis_currency.short_name%type;
    v_tsi                 VARCHAR2(400);
    v_num2                 VARCHAR2(400);
    v_tsi2                 VARCHAR2(400);
    v_num                 VARCHAR2(400);
    v_tsi_spell            VARCHAR2(500);
    v_rate                gixx_item.currency_rt%TYPE := 1;
    v_cents             NUMBER;
    v_temp_return       VARCHAR(1000);
  BEGIN
    FOR a IN (
       SELECT DECODE(nvl(b.policy_currency, 'N'),'Y',a.currency_desc) currency_desc,
              DECODE(nvl(b.policy_currency, 'N'),'Y',a.short_name) short_name,
              b.policy_currency
         FROM giis_currency a,
              gixx_invoice b
        WHERE a.main_currency_cd = b.currency_cd
          AND b.extract_id = p_extract_id)
     LOOP
       v_currency_desc := ' IN '||a.currency_desc; 
       v_short_name    := a.short_name;
       IF a.policy_currency = 'Y' THEN
            FOR b IN (
               SELECT currency_rt
                 FROM gixx_item
                WHERE extract_id = p_extract_id)
            LOOP
                v_rate := b.currency_rt;
            END LOOP;
          EXIT;
       END IF;       
     END LOOP;
              
     IF v_currency_desc = ' IN ' OR v_currency_desc IS NULL THEN
          FOR b IN (
            SELECT currency_desc,
                   short_name
              FROM giis_currency
             WHERE short_name IN ( SELECT param_value_v
                                     FROM giac_parameters
                                    WHERE param_name = 'DEFAULT_CURRENCY'))
          LOOP
               v_short_name    := b.short_name;
               v_currency_desc := ' IN '||b.currency_desc;
               EXIT;
          END LOOP;
     END IF;
    
    v_short_name2 := p_short_name;
  
    IF p_basic_co_insurance_sw <> 2 THEN            
        FOR c IN (
           SELECT LTRIM (trunc(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100) ) cents                  
               FROM gixx_polbasic a
            WHERE a.extract_id = p_extract_id)
        LOOP
            v_cents := c.cents;        
            EXIT;
        END LOOP;   
        
        IF v_cents = 0 AND NVL(p_PRINT_CENTS,'N') = 'N' THEN 
          FOR c IN (
              SELECT UPPER( dh_util.spell ( TRUNC ( a.tsi_amt/v_rate)  )    ) tsi,
                     DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                     UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)  )    ) tsi2,
                     DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2    
                   FROM gixx_polbasic a
               WHERE a.extract_id = p_extract_id)
          LOOP
            v_tsi  := c.tsi;
            v_num  := c.tsi_num;
            v_tsi2 := c.tsi2;
            v_num2 := c.tsi_num2;
            EXIT;
          END LOOP;    
        ELSIF NVL(p_PRINT_CENTS,'N') = 'Y' THEN 
            FOR c IN (
                SELECT UPPER( dh_util.spell(TRUNC( a.tsi_amt/v_rate)) || ' AND '|| 
                       LTRIM (round(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100 ' ) tsi,
                       DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')|| LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                       UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate))|| ' AND '|| LTRIM (round(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100 ' ) tsi2,
                       DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')|| LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
                  FROM gixx_polbasic a
                 WHERE a.extract_id = p_extract_id)
                LOOP
                    v_tsi  := c.tsi;
                    v_num  := c.tsi_num;    
                    v_tsi2 := c.tsi2;
                    v_num2 := c.tsi_num2;
                    EXIT;
                END LOOP;    
            ELSE
              FOR c IN (
                SELECT UPPER( dh_util.spell(TRUNC(a.tsi_amt/v_rate)) || DECODE(LTRIM (round(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)),0,'',
                        ' AND '|| LTRIM (round(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100')) tsi,
                        DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM (RTRIM(TO_CHAR(a.tsi_amt/v_rate, '999,999,999,999,990.00'))) tsi_num,
                        UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)) || DECODE(LTRIM (round(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)),0,'',
                        ' AND '|| LTRIM (round(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100' )) tsi2,
                        DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM(RTRIM(TO_CHAR ( a.ann_tsi_amt/v_rate, '999,999,999,999,990.00'))) tsi_num2
                  FROM gixx_polbasic a
                 WHERE a.extract_id = p_extract_id)
              LOOP
                v_tsi  := c.tsi;
                v_num  := c.tsi_num;    
                v_tsi2 := c.tsi2;
                v_num2 := c.tsi_num2;
                EXIT;
              END LOOP;
        END IF;    

        IF p_DISPLAY_ANN_TSI = 'Y' THEN    
             v_temp_return := v_tsi2||v_currency_desc||' ('||v_short_name||' '||v_num2||')';
        ELSE
            v_temp_return := v_tsi||v_currency_desc||' ('||v_short_name||' '||v_num||')';
        END IF;    
    ELSE
    FOR x IN (SELECT ltrim(trunc((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))  
                   - trunc(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100)) cents
              FROM gixx_co_insurer co, giis_reinsurer re,gixx_invoice c,gixx_polbasic d
             WHERE co.co_ri_cd   = re.ri_cd
               AND c.extract_id  = co.extract_id
               AND co.extract_id = p_extract_id 
                 AND co.extract_id = d.extract_id)          
    LOOP
        v_cents := x.cents;
        EXIT;
    END LOOP;            
    IF v_cents = 0 AND NVL(p_PRINT_CENTS,'N') = 'N' THEN 
       FOR y IN (SELECT UPPER(dh_util.spell(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) tsi,
                                  DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM (TO_CHAR (SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)), '999,999,999,999,990.00' ))) tsi_num
                             FROM gixx_co_insurer co, giis_reinsurer re,gixx_invoice c,gixx_polbasic d
                WHERE co.co_ri_cd   = re.ri_cd
                  AND c.extract_id  = co.extract_id
                  AND co.extract_id = p_extract_id 
                    AND co.extract_id = d.extract_id)
       LOOP             
                v_tsi  := y.tsi;
                v_num  := y.tsi_num;    
                EXIT;
       END LOOP;
     ELSIF NVL(p_PRINT_CENTS,'N') = 'Y' THEN 
         FOR c IN (
            SELECT UPPER( dh_util.spell ( TRUNC ( a.tsi_amt/v_rate)) ||    ' AND '|| LTRIM (round(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100 ' ) tsi,
                      DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                      UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate))||' AND '|| LTRIM (round(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100 ' ) tsi2,
                      DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
                 FROM gixx_polbasic a
             WHERE a.extract_id = p_extract_id)
         LOOP
            v_tsi  := c.tsi;
            v_num  := c.tsi_num;    
            v_tsi2 := c.tsi2;
            v_num2 := c.tsi_num2;
            EXIT;
        END LOOP;    
     ELSE
        FOR y IN (SELECT dh_util.spell(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))) 
                       || DECODE(LTRIM (ROUND((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))
                        - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100) ),0,'',
                        ' AND '|| LTRIM (ROUND((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)) 
                        - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100) ||'/100' )) tsi,
                       DECODE(p_PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM (TO_CHAR (SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)), '999,999,999,999,990.00' ))) tsi_num
                    FROM gixx_co_insurer co, giis_reinsurer re,gixx_invoice c,gixx_polbasic d 
                   WHERE co.co_ri_cd   = re.ri_cd 
                     AND c.extract_id  = co.extract_id 
                     AND co.extract_id = p_extract_id 
                     AND co.extract_id = d.extract_id)
        LOOP
            v_tsi  := y.tsi;
            v_num  := y.tsi_num;                    
            EXIT;
        END LOOP;      
     END IF; 
     v_temp_return := v_tsi||v_currency_desc||' ('||' '||v_short_name||' '||v_num||')';
    END IF;
  END init_vars_m_15;
  
  PROCEDURE get_endt_text(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_endttext01            OUT GIXX_ENDTTEXT.ENDT_TEXT01%TYPE,
    p_endttext02            OUT GIXX_ENDTTEXT.ENDT_TEXT02%TYPE,
    p_endttext03            OUT GIXX_ENDTTEXT.ENDT_TEXT03%TYPE,
    p_endttext04            OUT GIXX_ENDTTEXT.ENDT_TEXT04%TYPE,
    p_endttext05            OUT GIXX_ENDTTEXT.ENDT_TEXT05%TYPE,
    p_endttext06            OUT GIXX_ENDTTEXT.ENDT_TEXT06%TYPE,
    p_endttext07            OUT GIXX_ENDTTEXT.ENDT_TEXT07%TYPE,
    p_endttext08            OUT GIXX_ENDTTEXT.ENDT_TEXT08%TYPE,
    p_endttext09            OUT GIXX_ENDTTEXT.ENDT_TEXT09%TYPE,
    p_endttext10            OUT GIXX_ENDTTEXT.ENDT_TEXT10%TYPE,
    p_endttext11            OUT GIXX_ENDTTEXT.ENDT_TEXT11%TYPE,
    p_endttext12            OUT GIXX_ENDTTEXT.ENDT_TEXT12%TYPE,
    p_endttext13            OUT GIXX_ENDTTEXT.ENDT_TEXT13%TYPE,
    p_endttext14            OUT GIXX_ENDTTEXT.ENDT_TEXT14%TYPE,
    p_endttext15            OUT GIXX_ENDTTEXT.ENDT_TEXT15%TYPE,
    p_endttext16            OUT GIXX_ENDTTEXT.ENDT_TEXT16%TYPE,
    p_endttext17            OUT GIXX_ENDTTEXT.ENDT_TEXT17%TYPE
  ) IS 
  
  BEGIN
      SELECT endt_text01, endt_text02, endt_text03, endt_text04,
           endt_text05, endt_text06, endt_text07, endt_text08,
           endt_text09, endt_text10, endt_text11, endt_text12,
           endt_text13, endt_text14, endt_text15, endt_text16,
           endt_text17
      INTO p_endttext01, p_endttext02, p_endttext03, p_endttext04,
           p_endttext05, p_endttext06, p_endttext07, p_endttext08,
           p_endttext09, p_endttext10, p_endttext11, p_endttext12,
           p_endttext13, p_endttext14, p_endttext15, p_endttext16,
           p_endttext17
      FROM GIXX_ENDTTEXT
      WHERE extract_id = p_extract_id;
  END get_endt_text; 
  
  FUNCTION get_bondendt_q_warranties(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN q_warranties_tab PIPELINED IS
    qwa     q_warranties_type;
    CURSOR looper IS
        SELECT WC.WC_TITLE WC_WC_TITLE, 
               WC.WC_TEXT01  POLWC_WC_TEXT01,WC.WC_TEXT02  POLWC_WC_TEXT02,
               WC.WC_TEXT03  POLWC_WC_TEXT03,WC.WC_TEXT04  POLWC_WC_TEXT04,WC.WC_TEXT05  POLWC_WC_TEXT05,WC.WC_TEXT06  POLWC_WC_TEXT06,
               WC.WC_TEXT07  POLWC_WC_TEXT07,WC.WC_TEXT08  POLWC_WC_TEXT08,WC.WC_TEXT09  POLWC_WC_TEXT09,WC.WC_TEXT10  POLWC_WC_TEXT10,
               WC.WC_TEXT11  POLWC_WC_TEXT11,WC.WC_TEXT12  POLWC_WC_TEXT12,WC.WC_TEXT13  POLWC_WC_TEXT13,WC.WC_TEXT14  POLWC_WC_TEXT14,
               WC.WC_TEXT15  POLWC_WC_TEXT15,WC.WC_TEXT16  POLWC_WC_TEXT16,WC.WC_TEXT17  POLWC_WC_TEXT17,                  
               GWC.WC_TEXT01 WARRC_WC_TEXT01,GWC.WC_TEXT02 WARRC_WC_TEXT02,GWC.WC_TEXT03 WARRC_WC_TEXT03,GWC.WC_TEXT04 WARRC_WC_TEXT04,
               GWC.WC_TEXT05 WARRC_WC_TEXT05,GWC.WC_TEXT06 WARRC_WC_TEXT06,GWC.WC_TEXT07 WARRC_WC_TEXT07,GWC.WC_TEXT08 WARRC_WC_TEXT08,
               GWC.WC_TEXT09 WARRC_WC_TEXT09,GWC.WC_TEXT10 WARRC_WC_TEXT10,GWC.WC_TEXT11 WARRC_WC_TEXT11,GWC.WC_TEXT12 WARRC_WC_TEXT12,
               GWC.WC_TEXT13 WARRC_WC_TEXT13,GWC.WC_TEXT14 WARRC_WC_TEXT14,GWC.WC_TEXT15 WARRC_WC_TEXT15,GWC.WC_TEXT16 WARRC_WC_TEXT16,
               GWC.WC_TEXT17 WARRC_WC_TEXT17,
               WC.CHANGE_TAG POLWC_CHANGE_TAG,
               WC.WC_CD        WC_WC_CD, 
               WC.PRINT_SW        WC_PRINT_SW
          FROM GIXX_POLWC WC,
               GIIS_WARRCLA GWC
         WHERE GWC.MAIN_WC_CD = WC.WC_CD
           AND GWC.LINE_CD = WC.LINE_CD
           AND wc.extract_id = p_extract_id;
  BEGIN
    FOR i IN looper
    LOOP
        qwa.wc_wc_title     :=    i.wc_wc_title; 
        qwa.polwc_wc_text01 :=    NVL(i.polwc_wc_text01,' '); 
        qwa.polwc_wc_text02 :=    NVL(i.polwc_wc_text02,' '); 
        qwa.polwc_wc_text03 :=    NVL(i.polwc_wc_text03,' ');     
        qwa.polwc_wc_text04 :=    NVL(i.polwc_wc_text04,' ');
        qwa.polwc_wc_text05 :=    NVL(i.polwc_wc_text05,' ');
        qwa.polwc_wc_text06 :=    NVL(i.polwc_wc_text06,' ');
        qwa.polwc_wc_text07 :=    NVL(i.polwc_wc_text07,' ');
        qwa.polwc_wc_text08 :=    NVL(i.polwc_wc_text08,' ');
        qwa.polwc_wc_text09 :=    NVL(i.polwc_wc_text09,' ');
        qwa.polwc_wc_text10 :=    NVL(i.polwc_wc_text10,' ');
        qwa.polwc_wc_text11 :=    NVL(i.polwc_wc_text11,' ');
        qwa.polwc_wc_text12 :=    NVL(i.polwc_wc_text12,' ');
        qwa.polwc_wc_text13 :=    NVL(i.polwc_wc_text13,' ');
        qwa.polwc_wc_text14 :=    NVL(i.polwc_wc_text14,' ');
        qwa.polwc_wc_text15 :=    NVL(i.polwc_wc_text15,' ');
        qwa.polwc_wc_text16 :=    NVL(i.polwc_wc_text16,' ');
        qwa.polwc_wc_text17 :=    NVL(i.polwc_wc_text17,' ');
       
        qwa.warrc_wc_text01    :=    NVL(i.warrc_wc_text01,' ');
        qwa.warrc_wc_text02    :=    NVL(i.warrc_wc_text02,' ');
        qwa.warrc_wc_text03    :=    NVL(i.warrc_wc_text03,' ');
        qwa.warrc_wc_text04    :=    NVL(i.warrc_wc_text04,' ');
        qwa.warrc_wc_text05    :=    NVL(i.warrc_wc_text05,' ');
        qwa.warrc_wc_text06    :=    NVL(i.warrc_wc_text06,' ');
        qwa.warrc_wc_text07    :=    NVL(i.warrc_wc_text07,' ');
        qwa.warrc_wc_text08    :=    NVL(i.warrc_wc_text08,' ');
        qwa.warrc_wc_text09    :=    NVL(i.warrc_wc_text09,' '); 
        qwa.warrc_wc_text10    :=    NVL(i.warrc_wc_text10,' ');
        qwa.warrc_wc_text11    :=    NVL(i.warrc_wc_text11,' ');
        qwa.warrc_wc_text12    :=    NVL(i.warrc_wc_text12,' ');
        qwa.warrc_wc_text13    :=    NVL(i.warrc_wc_text13,' ');
        qwa.warrc_wc_text14    :=    NVL(i.warrc_wc_text14,' ');
        qwa.warrc_wc_text15    :=    NVL(i.warrc_wc_text15,' ');
        qwa.warrc_wc_text16 :=    NVL(i.warrc_wc_text16,' ');
        qwa.warrc_wc_text17    :=    NVL(i.warrc_wc_text17,' ');
        qwa.polwc_change_tag:=    i.polwc_change_tag;
        qwa.wc_wc_cd        :=    i.wc_wc_cd;
        qwa.wc_print_sw        :=    i.wc_print_sw;
        
        IF i.polwc_wc_text01 = null     AND i.polwc_wc_text02 = null    AND i.polwc_wc_text03 = null    AND i.polwc_wc_text04 = null
            AND i.polwc_wc_text05 = null    AND i.polwc_wc_text06 = null    AND i.polwc_wc_text07 = null    AND i.polwc_wc_text08 = null
            AND i.polwc_wc_text09 = null    AND i.polwc_wc_text10 = null    AND i.polwc_wc_text11 = null    AND i.polwc_wc_text12 = null
            AND i.polwc_wc_text13 = null    AND i.polwc_wc_text14 = null    AND i.polwc_wc_text15 = null    AND i.polwc_wc_text16 = null
            AND i.polwc_wc_text17 = null 
        THEN
            qwa.polwc_allnull_flag := 'Y';
        ELSE
            qwa.polwc_allnull_flag := 'N';
        END IF;
        
        IF i.warrc_wc_text01 = null     AND i.warrc_wc_text02 = null    AND i.warrc_wc_text03 = null    AND i.warrc_wc_text04 = null
            AND i.warrc_wc_text05 = null    AND i.warrc_wc_text06 = null    AND i.warrc_wc_text07 = null    AND i.warrc_wc_text08 = null
            AND i.warrc_wc_text09 = null    AND i.warrc_wc_text10 = null    AND i.warrc_wc_text11 = null    AND i.warrc_wc_text12 = null
            AND i.warrc_wc_text13 = null    AND i.warrc_wc_text14 = null    AND i.warrc_wc_text15 = null    AND i.warrc_wc_text16 = null
            AND i.warrc_wc_text17 = null 
        THEN
            qwa.warrc_allnull_flag := 'Y';
        ELSE
            qwa.warrc_allnull_flag := 'N';
        END IF;    
        
        PIPE ROW(qwa);
    END LOOP;
  END get_bondendt_q_warranties;
  
  FUNCTION get_bondendt_polgenin(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN polgenin_tab PIPELINED IS
    pols    polgenin_type;
    CURSOR looper IS 
           SELECT NVL(gen_info01, ' ') gen_info01, NVL(gen_info02, ' ') gen_info02, NVL(gen_info03, ' ') gen_info03, NVL(gen_info04, ' ') gen_info04, 
                  NVL(gen_info05, ' ') gen_info05, NVL(gen_info06, ' ') gen_info06, NVL(gen_info07, ' ') gen_info07, NVL(gen_info08, ' ') gen_info08, 
                  NVL(gen_info09, ' ') gen_info09, NVL(gen_info10, ' ') gen_info10, NVL(gen_info11, ' ') gen_info11, NVL(gen_info12, ' ') gen_info12, 
                  NVL(gen_info13, ' ') gen_info13, NVL(gen_info14, ' ') gen_info14, NVL(gen_info15, ' ') gen_info15, NVL(gen_info16, ' ') gen_info16, 
                  NVL(gen_info17 ,' ') gen_info17, 
                  NVL(initial_info01, ' ') initial_info01, NVL(initial_info02, ' ') initial_info02, NVL(initial_info03, ' ') initial_info03, NVL(initial_info04, ' ') initial_info04, 
                  NVL(initial_info05, ' ') initial_info05, NVL(initial_info06, ' ') initial_info06, NVL(initial_info07, ' ') initial_info07, NVL(initial_info08, ' ') initial_info08, 
                  NVL(initial_info09, ' ') initial_info09, NVL(initial_info10, ' ') initial_info10, NVL(initial_info11, ' ') initial_info11, NVL(initial_info12, ' ') initial_info12, 
                  NVL(initial_info13, ' ') initial_info13, NVL(initial_info14, ' ') initial_info14, NVL(initial_info15, ' ') initial_info15, NVL(initial_info16, ' ') initial_info16, 
                  NVL(initial_info17, ' ') initial_info17
             FROM GIXX_POLGENIN
            WHERE extract_id = p_extract_id;
  BEGIN
    FOR i IN looper
    LOOP
        pols.gen_info01  :=  i.gen_info01;    pols.gen_info02     :=  i.gen_info02;
        pols.gen_info03  :=  i.gen_info03;    pols.gen_info04     :=  i.gen_info04;
        pols.gen_info05  :=  i.gen_info05;    pols.gen_info06     :=  i.gen_info06;
        pols.gen_info07  :=  i.gen_info07;    pols.gen_info08     :=  i.gen_info08;
        pols.gen_info09  :=  i.gen_info09;    pols.gen_info10     :=  i.gen_info10;
        pols.gen_info11  :=  i.gen_info11;    pols.gen_info12     :=  i.gen_info12;
        pols.gen_info13  :=  i.gen_info13;    pols.gen_info14     :=  i.gen_info14;
        pols.gen_info15  :=  i.gen_info15;    pols.gen_info16     :=  i.gen_info16;
        pols.gen_info17  :=  i.gen_info17;
        pols.initial_info01 :=  i.initial_info01;   pols.initial_info02    :=  i.initial_info02;
        pols.initial_info03 :=  i.initial_info03;   pols.initial_info04    :=  i.initial_info04;
        pols.initial_info05 :=  i.initial_info05;   pols.initial_info06    :=  i.initial_info06;
        pols.initial_info07 :=  i.initial_info07;   pols.initial_info08    :=  i.initial_info08;
        pols.initial_info09 :=  i.initial_info09;   pols.initial_info10    :=  i.initial_info10;
        pols.initial_info11 :=  i.initial_info11;   pols.initial_info12    :=  i.initial_info12;
        pols.initial_info13 :=  i.initial_info13;   pols.initial_info14    :=  i.initial_info14;
        pols.initial_info15 :=  i.initial_info15;   pols.initial_info16    :=  i.initial_info16;
        pols.initial_info17 :=  i.initial_info17;
        PIPE ROW(pols);
        
    END LOOP;
  END get_bondendt_polgenin;
  
  PROCEDURE get_surety_details(
    p_extract_id        IN  gixx_polbasic.extract_id%TYPE,
    p_su_obligee_name   OUT giis_obligee.obligee_name%TYPE,
    p_su_bond_detail    OUT gixx_bond_basic.bond_dtl%TYPE,
    p_su_indemnity         OUT gixx_bond_basic.indemnity_text%TYPE,
    p_su_np_name        OUT giis_notary_public.np_name%TYPE,
    p_su_clause_desc    OUT giis_bond_class_clause.clause_desc%TYPE,
    p_su_coll_flag      OUT gixx_bond_basic.coll_flag%TYPE,
    p_su_coll_desc      OUT VARCHAR2,
    p_su_waiver_limit   OUT gixx_bond_basic.waiver_limit%TYPE,
    p_su_contract_date  OUT gixx_bond_basic.contract_date%TYPE,
    p_su_contract_dtl   OUT gixx_bond_basic.contract_dtl%TYPE
  )IS
     CURSOR su IS
        SELECT C.OBLIGEE_NAME SU_OBLIGEE_NAME, 
               A.BOND_DTL      SU_BOND_DETAIL,
               A.INDEMNITY_TEXT SU_INDEMNITY,       
               B.NP_NAME        SU_NP_NAME,
               D.CLAUSE_DESC SU_CLAUSE_DESC,
               A.COLL_FLAG SU_COLL_FLAG,
               A.WAIVER_LIMIT    SU_WAIVER_LIMIT,
               A.CONTRACT_DATE SU_CONTRACT_DATE,
               A.CONTRACT_DTL SU_CONTRACT_DTL
        FROM GIXX_BOND_BASIC A,
             GIIS_NOTARY_PUBLIC B,
             GIIS_OBLIGEE C,
             GIIS_BOND_CLASS_CLAUSE D
        WHERE A.NP_NO = B.NP_NO(+)
          AND A.OBLIGEE_NO = C.OBLIGEE_NO(+)
          AND A.CLAUSE_TYPE = D.CLAUSE_TYPE(+)
          AND A.extract_id = p_extract_id;
  BEGIN
    FOR i IN su
    LOOP
        p_su_obligee_name   := i.su_obligee_name;
        p_su_bond_detail    := i.su_bond_detail;
        p_su_indemnity      := i.su_indemnity;
        p_su_np_name        := i.su_np_name;
        p_su_clause_desc    := i.su_clause_desc;
        p_su_coll_flag      := i.su_coll_flag;
        p_su_waiver_limit   := i.su_waiver_limit;
        p_su_contract_date  := i.su_contract_date;
        p_su_contract_dtl   := i.su_contract_dtl;
    END LOOP;
    
    FOR a IN (SELECT ltrim(rtrim(rv_meaning)) rv_meaning
                FROM cg_ref_codes
               WHERE rv_domain = 'GIPI_BOND_BASIC.COLL_FLAG'
                 AND rv_low_value = p_su_coll_flag)
    LOOP
       p_su_coll_desc := a.rv_meaning;
    END LOOP;
  END get_surety_details;
  
END bonds_endt_pkg;
/


