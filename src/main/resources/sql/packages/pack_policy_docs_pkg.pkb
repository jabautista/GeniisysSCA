CREATE OR REPLACE PACKAGE BODY CPI.PACK_POLICY_DOCS_PKG
AS  
    FUNCTION get_pack_report_details( p_extract_id    IN GIXX_PACK_POLBASIC.extract_id%TYPE,
                                      p_report_id     IN GIIS_DOCUMENT.report_id%TYPE,
                                      p_user_id       IN GIIS_USERS.user_id%TYPE)
    RETURN pack_report_tab PIPELINED
    
    IS
    
    v_pack_report       pack_report_type;
    v_return            VARCHAR2(1) := 'N';
    CURSOR main IS
           SELECT DISTINCT B240.par_status PAR_STATUS,
            -- info for policy -- 
                B540.line_cd || '-' ||B540.iss_cd || '-' ||LTRIM(TO_CHAR(B540.issue_yy, '09')) || '-' || TRIM(TO_CHAR(B540.pol_seq_no, '099999')) 
                   || '-' ||LTRIM(TO_CHAR(B540.renew_no, '09'))  || DECODE(B540.reg_policy_sw,'N',' **') PAR_SEQ_NO1 
               ,B540.extract_id    EXTRACT_ID1 
               ,B540.policy_id  PAR_ID 
               ,DECODE(B240.par_status,10,B540.line_cd,B240.line_cd) LINE_CD  
               ,DECODE(B240.par_status,10,B540.line_cd  || '-' ||b540.subline_cd || '-' ||B540.iss_cd || '-' ||LTRIM(TO_CHAR(B540.issue_yy, '09')) || '-'||LTRIM(TO_CHAR(B540.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(B540.renew_no, '09')) || DECODE(B540.reg_policy_sw,'N',' **'),B240.line_cd || '-' ||B240.iss_cd || '-' ||LTRIM(TO_CHAR(B240.par_yy, '09')) || '-' ||TRIM(TO_CHAR(B240.par_seq_no, '099999')) || '-'||LTRIM(TO_CHAR(B240.quote_seq_no, '09'))||DECODE(B540.reg_policy_sw,'N',' **')) PAR_NO  
               ,DECODE(B540.ref_pol_no,NULL,NULL,'/ '||B540.REF_POL_NO) REF_POL_NO
               ,B240.line_cd || '-' ||B240.iss_cd || '-' ||LTRIM(TO_CHAR(B240.par_yy, '09')) || '-' ||TRIM(TO_CHAR(B240.par_seq_no, '099999')) || '-'|| LTRIM(TO_CHAR(B240.quote_seq_no, '09'))  || DECODE(B540.reg_policy_sw,'N',' **') PAR_ORIG 
               ,A150.line_name    LINE_LINE_NAME 
               ,A210.subline_name SUBLINE_SUBLINE_NAME 
               ,A210.subline_cd   SUBLINE_SUBLINE_CD 
               ,A150.line_cd      SUBLINE_LINE_CD 
               ,DECODE(B540.incept_tag,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.incept_date,'FMMONTH DD, YYYY'))   BASIC_INCEPT_DATE 
               ,DECODE(B540.expiry_tag,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.EXPIRY_DATE,'FMMONTH DD, YYYY'))    BASIC_EXPIRY_DATE 
               ,B540.expiry_tag   BASIC_EXPIRY_TAG 
               ,TO_CHAR(B540.issue_date, 'FMMONTH DD, YYYY')   BASIC_ISSUE_DATE 
               ,B540.tsi_amt      BASIC_TSI_AMT 
               ,DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'))  SUBLINE_SUBLINE_TIME 
               ,B540.acct_of_cd   BASIC_ACCT_OF_CD 
               ,B540.mortg_name   BASIC_MORTG_NAME 
               ,DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)  BASIC_ASSD_NO 
               ,DECODE(A020.designation, NULL,  A020.assd_name || A020.assd_name2,A020.designation || ' ' || A020.assd_name ||  A020.assd_name2) ASSD_NAME
               ,DECODE(B240.par_type, 'E',DECODE(B540.old_address1, NULL, B240.address1, B540.old_address1), B540.address1) ADDRESS1 
               ,DECODE(B240.par_type, 'E', DECODE(B540.old_address1, NULL, B240.address2, B540.old_address2), B540.address2) ADDRESS2 
               ,DECODE(B240.par_type, 'E', DECODE(B540.old_address1, NULL, B240.address3, B540.old_address3), B540.address3) ADDRESS3 
               ,DECODE(B240.par_type, 'E',DECODE(B540.old_address1, NULL, B240.address1, B540.old_address1), B540.address1)||' '|| 
                DECODE(B240.par_type, 'E', DECODE(B540.old_address1, NULL, B240.address2, B540.old_address2), B540.address2)||' '|| 
                DECODE(B240.par_type, 'E', DECODE(B540.old_address1, NULL, B240.address3, B540.old_address3), B540.address3) BASIC_ADDR 
               ,B540.pol_flag          BASIC_POL_FLAG 
               ,B540.fleet_print_tag   FLEET_PRINT_TAG 
               ,B540.line_cd           BASIC_LINE_CD 
               ,B540.ref_pol_no        BASIC_REF_POL_NO 
               ,B540.assd_no           BASIC_ASSD_NO2 
               ,DECODE(B540.label_tag,'Y','LEASED TO','IN ACCT OF') LABEL_TAG 
               ,B540.label_tag         LABEL_TAG1
                -- end of info for policy -- 
                
                -- info for endt policy -- 
               ,DECODE(b240.par_type,'E',B540.endt_iss_cd || '-' || LTRIM(TO_CHAR(B540.endt_yy, '09')) || '-' ||LTRIM(TO_CHAR(B540.endt_seq_no, '099999'))) ENDT_NO 
               ,DECODE(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' || B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || ' - ' ||B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) POL_ENDT_NO 
               ,DECODE(B540.endt_expiry_tag,'Y','T.B.A.',TO_CHAR(B540.endt_expiry_date,'FMMONTH DD, YYYY'))  ENDT_EXPIRY_DATE 
               ,TO_CHAR(B540.eff_date, 'FMMONTH DD, YYYY')         BASIC_EFF_DATE 
               ,DECODE(b240.par_type,'E',B540.endt_expiry_tag)   ENDT_EXPIRY_TAG 
               ,B540.incept_tag        BASIC_INCEPT_TAG 
               ,B540.subline_cd        BASIC_SUBLINE_CD 
               ,B540.iss_cd            BASIC_ISS_CD 
               ,B540.issue_yy          BASIC_ISSUE_YY 
               ,B540.pol_seq_no        BASIC_POL_SEQ_NO 
               ,B540.renew_no          BASIC_RENEW_NO 
               ,DECODE(TO_CHAR(B540.eff_date,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.eff_date,'HH:MI:SS AM'))                 BASIC_EFF_TIME 
               ,DECODE(TO_CHAR(B540.endt_expiry_date,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.endt_expiry_date,'HH:MI:SS AM')) BASIC_ENDT_EXPIRY_TIME 
               -- end of info for endt policy -- 
               
               -- info for par --- 
               ,B240.par_type         PAR_PAR_TYPE 
               ,B240.par_status       PAR_PAR_STATUS 
               ,B540.co_insurance_sw  BASIC_CO_INSURANCE_SW 
               ,' * '||NVL(p_user_id, USER)||' * ' USERNAME 
               
               -- FOR INTERMEDIARY INFO -- 
               ,LTRIM(NVL2 ( PARENT.ref_intm_cd, AGENT.parent_intm_no || '-' || PARENT.ref_intm_cd , AGENT.parent_intm_no ) 
                ||' / '||    NVL2 ( AGENT.ref_intm_cd, AGENT.intm_no || '-' || AGENT.ref_intm_cd , AGENT.intm_no )) INTM_NO 
               ,LTRIM(PARENT.intm_name||' / '|| AGENT.intm_name)  INTM_NAME 
               ,PARENT.intm_name        PARENT_INTM_NAME 
               ,AGENT.intm_name         AGENT_INTM_NAME 
               ,AGENT.parent_intm_no    PARENT_INTM_NO 
               ,AGENT.intm_no           AGENT_INTM_NO
               ,A210.op_flag            SUBLINE_OPEN_POLICY 
               ,B540.tsi_amt            BASIC_TSI_AMT1
               ,B540.cred_branch        CRED_BR  
               -- END OF INFO FOR INTERMEDIARY -- 
               
               ,NVL(b540.polendt_printed_cnt,0)      BASIC_PRINTED_CNT
               ,b540.polendt_printed_date            BASIC_PRINTED_DT
               ,B540.endt_type                       ENDT_TYPE
        FROM    GIXX_PACK_POLBASIC B540 
               ,GIXX_PACK_PARLIST B240 
               ,GIIS_LINE A150 
               ,GIIS_SUBLINE A210 
               ,GIIS_ASSURED A020 
               ,GIXX_COMM_INVOICE B440 
               ,GIIS_INTERMEDIARY AGENT 
               ,GIIS_INTERMEDIARY PARENT 
        WHERE   B540.extract_id     = p_extract_id 
            AND B240.extract_id     = B540.extract_id 
            AND A150.line_cd        = B540.line_cd 
            AND A210.line_cd        = B540.line_cd 
            AND A210.subline_cd     = B540.subline_cd 
            AND A020.assd_no        = B240.assd_no 
            AND ( B540.extract_id = B440.extract_id (+) ) 
            AND ( B440.intrmdry_intm_no = AGENT.intm_no (+) ) 
            AND ( AGENT.parent_intm_no = PARENT.intm_no (+) ) ;
    
    BEGIN
        FOR i IN main
        LOOP                
            v_pack_report.par_seq_no1            := i.par_seq_no1;
            v_pack_report.extract_id1            := i.extract_id1;
            v_pack_report.line_cd                := i.line_cd; --giis_line_pkg.get_menu_line_cd(i.line_cd);
            v_pack_report.par_id                 := i.par_id;            
            v_pack_report.par_no                 := i.par_no;
            v_pack_report.par_orig               := i.par_orig;
            v_pack_report.line_line_name         := i.line_line_name;
            v_pack_report.subline_subline_name   := i.subline_subline_name;
            v_pack_report.subline_subline_cd     := i.subline_subline_cd; --giis_line_pkg.get_menu_line_cd(i.subline_subline_cd);
            v_pack_report.subline_line_cd        := i.subline_line_cd;
            v_pack_report.basic_incept_date      := i.basic_incept_date;
            v_pack_report.basic_expiry_date      := i.basic_expiry_date;
            v_pack_report.basic_expiry_tag       := i.basic_expiry_tag;
            v_pack_report.basic_issue_date       := i.basic_issue_date;
            v_pack_report.basic_tsi_amt          := i.basic_tsi_amt;
            v_pack_report.subline_subline_time   := i.subline_subline_time;
            v_pack_report.basic_acct_of_cd       := i.basic_acct_of_cd;
            v_pack_report.basic_mortg_name       := i.basic_mortg_name;
            v_pack_report.basic_assd_no          := i.basic_assd_no;
            v_pack_report.address1               := i.address1;
            v_pack_report.address2               := i.address2;
            v_pack_report.address3               := i.address3;
            v_pack_report.basic_addr             := i.basic_addr;
            v_pack_report.basic_pol_flag         := i.basic_pol_flag;
            v_pack_report.basic_line_cd          := i.basic_line_cd;
            v_pack_report.basic_ref_pol_no       := i.basic_ref_pol_no;
            v_pack_report.basic_assd_no2         := i.basic_assd_no2;
            v_pack_report.label_tag              := i.label_tag;
            v_pack_report.label_tag1             := i.label_tag1;
            -- end of pol info -- 
            v_pack_report.endt_no                := i.endt_no;
            v_pack_report.pol_endt_no            := i.pol_endt_no;
            v_pack_report.endt_expiry_date       := i.endt_expiry_date;
            v_pack_report.basic_eff_date         := i.basic_eff_date;
            v_pack_report.endt_expiry_tag        := i.endt_expiry_tag;
            v_pack_report.basic_incept_tag       := i.basic_incept_tag;
            v_pack_report.basic_subline_cd       := i.basic_subline_cd;
            v_pack_report.basic_iss_cd           := i.basic_iss_cd;
            v_pack_report.basic_issue_yy         := i.basic_issue_yy;
            v_pack_report.basic_pol_seq_no       := i.basic_pol_seq_no;
            v_pack_report.basic_renew_no         := i.basic_renew_no;
            v_pack_report.basic_eff_time         := i.basic_eff_time;
            v_pack_report.basic_endt_expiry_time := i.basic_endt_expiry_time;
            -- end of endt policy --
            v_pack_report.par_par_type           := i.par_par_type;
            v_pack_report.par_par_status         := i.par_par_status;
            v_pack_report.basic_co_insurance_sw  := i.basic_co_insurance_sw;
            v_pack_report.username               := i.username;
            v_pack_report.subline_open_policy    := i.subline_open_policy;
            v_pack_report.cred_br                := i.cred_br;
            v_pack_report.assd_name              := i.assd_name;
            v_pack_report.basic_printed_cnt      := i.basic_printed_cnt;        
            v_pack_report.basic_printed_dt       := i.basic_printed_dt;  
            v_pack_report.endt_type              := i.endt_type;  
            
            v_return := 'Y';
            --PIPE ROW(v_pack_report);
        END LOOP;
        
        /*checks if the main query has record*/
        IF v_return = 'Y' THEN
            initialize_package(p_report_id);
        ELSE
            RETURN;
        END IF;
        
        
       /* f_header */
        IF v_pack_report.par_par_status != 10 THEN
            IF v_pack_report.par_par_type = 'P' THEN
                v_pack_report.f_header := PACK_POLICY_DOCS_PKG.par_header;
            ELSE
                v_pack_report.f_header := PACK_POLICY_DOCS_PKG.endt_header;
            END IF;
        ELSE
            v_pack_report.f_header := NULL;
        END IF;
        
        /* report title*/
        IF v_pack_report.par_par_type = 'P' THEN
            IF v_pack_report.par_par_status NOT IN (10, 99) THEN
                v_pack_report.f_report_title := PACK_POLICY_DOCS_PKG.par_par;
                v_pack_report.f_dash := LPAD('-',LENGTH(PACK_POLICY_DOCS_PKG.par_par)+1,'-');
            ELSE
                v_pack_report.f_report_title := PACK_POLICY_DOCS_PKG.par_policy;
                v_pack_report.f_dash := LPAD('-',LENGTH(PACK_POLICY_DOCS_PKG.par_policy)+1,'-');
            END IF;
        ELSE            
            IF v_pack_report.par_par_status NOT IN (10, 99) THEN
                v_pack_report.f_report_title := PACK_POLICY_DOCS_PKG.endt_par;
                v_pack_report.f_dash := LPAD('-',LENGTH(PACK_POLICY_DOCS_PKG.endt_par)+1,'-');
            ELSE
                v_pack_report.f_report_title := PACK_POLICY_DOCS_PKG.endt_policy;
                v_pack_report.f_dash := LPAD('-',LENGTH(PACK_POLICY_DOCS_PKG.endt_policy)+1,'-');
            END IF;
        END IF;
        
        /* par_policy label */
        IF v_pack_report.par_par_status = 10 THEN
            v_pack_report.par_policy_label := PACK_POLICY_DOCS_PKG.POLICY;
        ELSE
            v_pack_report.par_policy_label := PACK_POLICY_DOCS_PKG.par;
        END IF;
        
        /*f_assd_name*/
        DECLARE
            --v_assd_name   GIIS_ASSURED.assd_name%TYPE;
            v_assd_name   VARCHAR2(600); -- bonok :: 12.16.2015 :: UCPB SR 21197
            
        BEGIN
            
            IF v_pack_report.label_tag1 = 'Y' AND PACK_POLICY_DOCS_PKG.LEASED_TO = 'Y' THEN    
              v_assd_name := display_assured_leased(v_pack_report.basic_acct_of_cd);                            
            ELSE
              v_assd_name := DISPLAY_ASSURED(v_pack_report.basic_assd_no);
            END IF;
            
            v_pack_report.f_assd_name :=  v_assd_name;
        END; 
        
        
        /*f_acct_of_cd*/
        DECLARE
            v_acct_of_name  GIIS_ASSURED.assd_name%TYPE;
            
        BEGIN
            
            IF v_pack_report.label_tag1 = 'Y' AND PACK_POLICY_DOCS_PKG.LEASED_TO = 'Y' THEN    
              v_acct_of_name := display_assured(v_pack_report.basic_acct_of_cd);                            
            ELSE
              v_acct_of_name := display_assured_leased(v_pack_report.basic_assd_no);
            END IF;
            
            v_pack_report.f_acct_of_cd :=  v_acct_of_name;
        END;
        
        /*show_bank_ref_no*/
        DECLARE
            v_show    VARCHAR2(1) := 'N';
        BEGIN
            
            IF NVL(giisp.v('ORA2010_SW'), 'N') = 'Y' THEN
                v_show := 'Y';
            ELSE
                v_show := 'N';
            END IF;
            
            v_pack_report.show_bank_ref_no := v_show;
        END;   
  
        
        /* show_ref_pol_no */
        DECLARE
            v_show    VARCHAR2(1) := 'N';
        BEGIN                                    
            IF PACK_POLICY_DOCS_PKG.PRINT_REF_POL_NO = 'N' OR v_pack_report.basic_ref_pol_no IS NULL OR (v_pack_report.par_par_type = 'E' AND v_pack_report.basic_co_insurance_sw = 2) THEN
                v_show := 'N';
            ELSE
                v_show := 'Y';
            END IF;    
            
            v_pack_report.show_ref_pol_no := v_show;
        END;
        
        /* v_show_polgenin_gen_info */
        DECLARE
            v_show_polgenin_gen_info     VARCHAR2(1) := 'N';
            v_gen_info001                 GIXX_PACK_POLGENIN.gen_info01%TYPE;
        BEGIN
            FOR i IN (SELECT gen_info01
                      FROM GIXX_PACK_POLGENIN
                      WHERE extract_id = p_extract_id
                      AND rownum=1)
            LOOP
                v_gen_info001 := i.gen_info01;
                EXIT;
            END LOOP;
            
            IF PACK_POLICY_DOCS_PKG.PRINT_GEN_INFO_ABOVE = 'N' THEN
                IF v_gen_info001 IS NULL OR PACK_POLICY_DOCS_PKG.PRINT_DOC_SUBTITLE3 = 'N' THEN
                    v_show_polgenin_gen_info := 'N';
                ELSE
                    v_show_polgenin_gen_info := 'Y';
                END IF;    
            ELSE
                v_show_polgenin_gen_info := 'N';
            END IF;
            
            v_pack_report.show_polgenin_gen_info := v_show_polgenin_gen_info;
        END;
        
        /*show_mortgagee*/
        DECLARE
            v_count NUMBER(20);
            v_show  VARCHAR2(1) := 'N';
        BEGIN
            
          IF PACK_POLICY_DOCS_PKG.print_null_mortgagee = 'Y' THEN
             v_show := 'Y';
          ELSE
              SELECT COUNT(*)
                INTO v_count
                FROM GIXX_MORTGAGEE
               WHERE item_no = 0
                 AND extract_id = p_extract_id;
               
               IF v_count < 1 OR PACK_POLICY_DOCS_PKG.print_mortgagee = 'N' THEN
                    v_show := 'N';
               ELSE
                    v_show := 'Y';
               END IF;
           END IF;
               v_pack_report.show_mortgagee := v_show;
        END;
        
        IF ((v_pack_report.basic_tsi_amt IS NULL OR  -- added by: Nica 02.28.2013 to retrieve sum of tsi_amt of sub-policies 
            v_pack_report.basic_tsi_amt = 0) AND     -- when tsi_amt in GIXX_PACK_POLBASIC is null OR equal to zero
            v_pack_report.par_par_status > 3) THEN
            
            FOR i IN (SELECT extract_id, 
                             SUM(tsi_amt) basic_tsi_amt
                        FROM GIXX_POLBASIC
                       WHERE extract_id = p_extract_id
                    GROUP BY extract_id)
            LOOP
                v_pack_report.basic_tsi_amt := i.basic_tsi_amt;
            END LOOP;
        END IF;
        
        /* f_tsi_amt and f_premium_amt */
        DECLARE
            v_main_tsi                  GIXX_PACK_POLBASIC.tsi_amt%TYPE;
            v_co_ins_sw                 VARCHAR2(1);
            v_rate                      GIXX_ITEM.currency_rt%TYPE := 1;
            v_show_doc_total_in_box     VARCHAR2(1) := 'N';
            
            /* for f_premium_amt */
            v_prem_amt                    NUMBER(16,2) := 0;
            v_tax_amt                     NUMBER(16,2) := 0;
            v_other_charges             NUMBER(38,2) := 0;
            v_total_tsi                 NUMBER(38,2) := 0;
            v_policy_currency             GIXX_PACK_INVOICE.policy_currency%TYPE;
            v_param_value_n              GIIS_PARAMETERS.param_value_n%TYPE;
            
            CURSOR G_EXTRACT_ID20 IS
                  SELECT B450.extract_id EXTRACT_ID,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) PREMIUM_AMT,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) TAX_AMT,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) OTHER_CHARGES,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) +
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) +
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) TOTAL,
                           B450.policy_currency POLICY_CURRENCY
                    FROM   GIXX_PACK_INVOICE B450, 
                           GIXX_PACK_POLBASIC POL
                    WHERE B450.extract_id = p_extract_id
                      AND B450.extract_id = POL.extract_id
                      AND POL.co_insurance_sw IN ('1','3')
                    GROUP BY B450.extract_id 
                          ,B450.policy_currency 
                          
                    UNION

                    SELECT B450.extract_id EXTRACT_ID,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) PREMIUM_AMT,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) TAX_AMT,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) OTHER_CHARGES,
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) +
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) +
                           SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) TOTAL 
                          ,B450.policy_currency POLICY_CURRENCY
                    FROM GIXX_PACK_INVOICE B450,
                         GIXX_PACK_POLBASIC POL
                    WHERE B450.extract_id   = p_extract_id
                      AND B450.extract_id = POL.extract_id
                      AND POL.co_insurance_sw  = '2'  
                    GROUP BY B450.extract_id
                         ,B450.policy_currency;               
        BEGIN
            FOR i IN G_EXTRACT_ID20
            LOOP
                IF i.policy_currency = 'Y' THEN
                    FOR b IN (
                        SELECT currency_rt
                          FROM GIXX_ITEM
                         WHERE extract_id = p_extract_id)
                    LOOP
                        v_rate := b.currency_rt;
                    END LOOP;
                END IF;
                
                v_main_tsi := v_pack_report.basic_tsi_amt / v_rate;
                
                IF v_pack_report.basic_co_insurance_sw = 2 THEN
                    FOR a IN (
                        SELECT (NVL(a.tsi_amt,0) * b.currency_rt)  tsi
                          FROM GIXX_MAIN_CO_INS a, GIXX_PACK_INVOICE b
                         WHERE a.extract_id = b.extract_id
                           AND a.extract_id = p_extract_id)
                    LOOP
                        v_main_tsi := a.tsi;
                        EXIT;
                    END LOOP;
                END IF;
                
                v_prem_amt              := i.premium_amt;
                v_tax_amt               := i.tax_amt;
                v_other_charges         := i.other_charges;
                v_total_tsi             := i.total;
                v_policy_currency       := i.policy_currency;
                v_show_doc_total_in_box := 'Y';
            END LOOP;              
             
            /* f_tsi_amt */
            v_pack_report.f_tsi_amt := TO_CHAR(v_main_tsi, '999999999999990.99');
            
            /* show_doc_total_in_box */
            v_pack_report.show_doc_total_in_box := v_show_doc_total_in_box;
            
            /* f_premium_amt, f_tax_amt, f_other_charges, and f_total_tsi */            
            BEGIN            
                
                v_param_value_n := GIIS_PARAMETERS_PKG.n('NEW_PREM_AMT');
                
                IF v_pack_report.PAR_PAR_STATUS = 10 AND v_pack_report.PAR_PAR_TYPE = 'E' AND v_pack_report.BASIC_CO_INSURANCE_SW = 2 THEN
                    FOR A IN (
                        SELECT b.tax_cd  tax_cd, 
                               DECODE(NVL(A.policy_currency,'N'),'Y', NVL(B.tax_amt,0) * 
                               A.currency_rt, NVL(B.tax_amt,0)) TAX_AMT
                          FROM GIXX_PACK_INVOICE A, GIXX_PACK_INV_TAX B,GIXX_PACK_POLBASIC POL
                         WHERE A.extract_id = B.extract_id
                           AND A.item_grp = B.item_grp
                           AND A.extract_id = p_extract_id
                           AND A.extract_id = pol.extract_id
                           AND POL.co_insurance_sw = 2)
                    LOOP                
                        IF v_param_value_n = A.tax_cd THEN
                            v_prem_amt := v_prem_amt + A.tax_amt;
                            v_tax_amt := v_tax_amt - A.tax_amt;
                        ELSE
                            v_prem_amt := v_prem_amt;
                            v_tax_amt := v_tax_amt;
                        END IF;             
                    END LOOP; 
                ELSE
                    FOR A IN (
                        SELECT DECODE(NVL(invoice.policy_currency, 'N'),'N',
                               SUM(invtax.tax_amt),
                               SUM(invtax.tax_amt * invoice.currency_rt))    tax_amt, 
                               taxcharg.include_tag                 include_tag
                          FROM GIXX_PACK_INVOICE invoice, 
                               GIXX_PACK_INV_TAX invtax, 
                               GIIS_TAX_CHARGES taxcharg,
                               GIXX_PACK_POLBASIC pol,
                               GIXX_PACK_PARLIST par
                         WHERE invtax.iss_cd = taxcharg.iss_cd
                           AND invtax.line_cd = taxcharg.line_cd
                           AND invtax.tax_cd = taxcharg.tax_cd
                           AND invtax.tax_id = taxcharg.tax_id 
                           AND invoice.extract_id = invtax.extract_id
                           AND invoice.extract_id = p_extract_id
                           AND invoice.extract_id = pol.extract_id
                           AND pol.co_insurance_sw = 1
                           AND par.extract_id = pol.extract_id
                           AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                           AND invtax.item_grp = invoice.item_grp
                      GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag, invoice.policy_currency 
                         UNION
                        SELECT DECODE(NVL(invoice.policy_currency, 'N'),'N',
                               SUM(invtax.tax_amt),
                               SUM(invtax.tax_amt * invoice.currency_rt))    tax_amt, 
                               taxcharg.include_tag                 include_tag
                          FROM GIXX_PACK_INVOICE invoice, 
                               GIXX_PACK_INV_TAX invtax, 
                               GIIS_TAX_CHARGES taxcharg,
                               GIXX_PACK_POLBASIC pol
                         WHERE invtax.iss_cd = taxcharg.iss_cd
                           AND invtax.line_cd = taxcharg.line_cd
                           AND invtax.tax_cd = taxcharg.tax_cd
                           AND invtax.tax_id = taxcharg.tax_id 
                           AND invoice.extract_id = invtax.extract_id
                           AND invoice.extract_id = p_extract_id
                           AND invoice.extract_id = pol.extract_id
                           AND pol.co_insurance_sw = 2
                      GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag, invoice.policy_currency)
                    LOOP                      
                        IF A.include_tag = 'Y' THEN
                            v_prem_amt := v_prem_amt + A.tax_amt;
                            v_tax_amt := v_tax_amt - A.tax_amt;
                        ELSE
                            v_prem_amt := v_prem_amt;
                            v_tax_amt := v_tax_amt;
                        END IF;             
                    END LOOP;     
                END IF;
              
                v_pack_report.f_premium_amt := v_prem_amt;
                v_pack_report.f_tax_amt := v_tax_amt;
                v_pack_report.f_other_charges := v_other_charges;
                v_pack_report.f_total_tsi := v_total_tsi;
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_pack_report.f_premium_amt := v_prem_amt;
                    v_pack_report.f_tax_amt := v_tax_amt;
                    v_pack_report.f_other_charges := v_other_charges;
                    v_pack_report.f_total_tsi := v_total_tsi;
            END;

            /* f_currency_name */
            DECLARE
                v_currency_desc   GIIS_CURRENCY.currency_desc%TYPE;
            BEGIN
                IF NVL(v_policy_currency, 'N')  = 'Y' THEN
                    FOR curr_rec IN (
                        SELECT a.currency_desc currency_desc
                          FROM GIIS_CURRENCY a,GIXX_PACK_INVOICE b
                         WHERE a.main_currency_cd = b.currency_cd
                           AND b.extract_id = p_extract_id)
                    LOOP
                        v_currency_desc := curr_rec.currency_desc; 
                        EXIT;
                    END LOOP;
                ELSE                    
                    v_currency_desc := Giis_Currency_Pkg.get_default_currency2;
                END IF;
                v_pack_report.f_currency_name := v_currency_desc;
            END;
        END;
        
        /* prem_label and prem_label_amount */
        DECLARE
            v_title_upper        VARCHAR2(25) := RPAD('PREMIUM', 18, ' ');
            v_title_initc         VARCHAR2(25) := RPAD('Premium', 18, ' ');
            v_currency            GIIS_CURRENCY.short_name%TYPE;
            v_prem_amt             NUMBER(16, 2) := 0;
            
            v_total_amt_upper   VARCHAR2(50) := RPAD('TOTAL AMOUNT DUE', 18, ' ');
            v_total_amt_initc   VARCHAR2(50) := RPAD('Total Amount Due', 18, ' ');
            v_total_ref_upper   VARCHAR2(50) := RPAD('TOTAL REFUND', 18, ' ');
            v_total_ref_initc   VARCHAR2(50) := RPAD('Total Refund', 18, ' ');
            v_taxes_cnt         NUMBER := 0;
            
        BEGIN
            SELECT COUNT(*)
            INTO v_taxes_cnt 
            FROM TABLE (PACK_POLICY_DOCS_PKG.get_pack_policy_taxes(p_extract_id, 
                                                                   v_pack_report.basic_co_insurance_sw,
                                                                   PACK_POLICY_DOCS_PKG.display_neg_amt));
                                                                           
            v_currency := Giis_Currency_Pkg.GET_ITEM_SHORT_NAME(p_extract_id);
            
            /* f_prem_title  */
            IF NVL(PACK_POLICY_DOCS_PKG.print_upper_case,'N') = 'Y' THEN
                v_pack_report.f_prem_title := v_title_upper;
                v_pack_report.f_amount_due_title := v_total_amt_upper;
            ELSE
                v_pack_report.f_prem_title := v_title_initc;
                v_pack_report.f_amount_due_title := v_total_amt_initc;                
            END IF;
            
            
            /* f_prem_title_short_name  */
            v_pack_report.f_prem_title_short_name := v_currency;
            v_pack_report.f_amount_due_short_name := v_currency;            
            
            /* currency desc */
            DECLARE
                v_currency_desc GIIS_CURRENCY.currency_desc%TYPE;
            BEGIN                
                v_currency_desc := Giis_Currency_Pkg.get_pol_doc_short_name2(p_extract_id);
                v_pack_report.f_currency := v_currency_desc;                                
            END;            
            
            /* prem_label_amount */
            FOR a IN ( 
                SELECT DECODE( NVL(a.policy_currency,'N'),'N', NVL(b.tax_amt,0) * 
                       a.currency_rt, NVL(b.tax_amt,0)) tax_amt,
                       c.include_tag include_tag
                  FROM GIXX_PACK_INVOICE a, GIXX_PACK_INV_TAX b, GIIS_TAX_CHARGES c
                 WHERE a.extract_id = b.extract_id
                   AND a.item_grp = b.item_grp
                   AND b.line_cd = c.line_cd
                   AND b.iss_cd = c.iss_cd
                   AND b.tax_cd = c.tax_cd
                   AND a.extract_id = p_extract_id
                   AND v_pack_report.basic_co_insurance_sw = 1
                 UNION
                SELECT DECODE( NVL(a.policy_currency,'N'),'N', NVL(b.tax_amt,0) * 
                       a.currency_rt, NVL(b.tax_amt,0)) tax_amt,
                       c.include_tag include_tag
                  FROM GIXX_PACK_INVOICE a, GIXX_PACK_INV_TAX b, GIIS_TAX_CHARGES c
                 WHERE a.extract_id = b.extract_id
                   AND a.item_grp = b.item_grp
                   AND b.line_cd = c.line_cd
                   AND b.iss_cd = c.iss_cd
                   AND b.tax_cd = c.tax_cd
                   AND a.extract_id = p_extract_id
                   AND v_pack_report.basic_co_insurance_sw = 2) 
            LOOP
                IF a.include_tag = 'Y' THEN
                    v_prem_amt :=  v_prem_amt  + a.tax_amt;
                END IF;
            END LOOP;
            
            IF( PACK_POLICY_DOCS_PKG.display_neg_amt = 'Y') THEN
                v_pack_report.prem_label_amount := v_prem_amt;
            ELSE
                v_pack_report.prem_label_amount := ABS(v_prem_amt);
            END IF;            
            
        END;
        
        /* f_basic_tsi_spell */
        DECLARE
            v_currency_desc         VARCHAR2(400);
            v_short_name            GIIS_CURRENCY.short_name%type;
            v_short_name2           GIIS_CURRENCY.short_name%type;
            v_tsi                   VARCHAR2(400);
            v_num                   VARCHAR2(400);
            v_tsi_spell             VARCHAR2(500);
            v_tsi_amt               NUMBER;
            v_rate                  GIXX_ITEM.currency_rt%TYPE := 1;
            v_cents                 NUMBER; 
            v_tsi_amt2              NUMBER;
            v_tsi2                  VARCHAR2(400);
            v_num2                  VARCHAR2(400);
            v_ri_pct                NUMBER;  
        BEGIN
             FOR a IN (
               SELECT DECODE(NVL(b.policy_currency, 'N'),'Y',a.currency_desc) currency_desc,
                             DECODE(NVL(b.policy_currency, 'N'),'Y',a.short_name)    short_name,
                             b.policy_currency
                 FROM GIIS_CURRENCY a,
                      GIXX_INVOICE  b 
                WHERE a.main_currency_cd = b.currency_cd
                  AND b.extract_id       = p_extract_id)
             LOOP
               v_currency_desc := 'IN '||a.currency_desc; 
               v_short_name    := a.short_name;
               IF a.policy_currency = 'Y' THEN
                    FOR b IN (
                          SELECT currency_rt
                            FROM GIXX_ITEM
                           WHERE extract_id = p_extract_id)
                        LOOP
                          v_rate := b.currency_rt;
                        END LOOP;
                  EXIT;
               END IF;       
               END LOOP;
           
             IF v_currency_desc = 'IN ' OR v_currency_desc IS NULL THEN
                  FOR b IN (
                    SELECT currency_desc,
                           short_name
                      FROM GIIS_CURRENCY
                     WHERE short_name IN ( SELECT param_value_v
                                             FROM giac_parameters
                                            WHERE param_name = 'DEFAULT_CURRENCY'))
                  LOOP
                           v_short_name    := b.short_name;
                           v_currency_desc := 'IN '||b.currency_desc;
                          EXIT;
                  END LOOP;
             END IF;         
            
            v_short_name2 := v_short_name;
         
            FOR c IN (
                SELECT a.tsi_amt,a.ann_tsi_amt
                    FROM GIXX_PACK_POLBASIC a
                     WHERE 1=1
                     AND a.extract_id = p_extract_id)
            LOOP
            
                IF ((c.tsi_amt IS NULL OR c.tsi_amt = 0 OR              -- added by: Nica 02.28.2013 to retrieve sum of tsi_amt of sub-policies
                     c.ann_tsi_amt IS NULL OR c.ann_tsi_amt = 0) AND    -- when tsi_amt in GIXX_PACK_POLBASIC is null OR tsi_amt = 0
                    v_pack_report.par_par_status > 3) THEN
                    
                    FOR i IN (SELECT extract_id, 
                                     SUM(tsi_amt) tsi_amt,
                                     SUM (ann_tsi_amt) ann_tsi_amt
                                FROM GIXX_POLBASIC
                               WHERE extract_id = p_extract_id
                            GROUP BY extract_id)
                    LOOP
                        v_tsi_amt  := i.tsi_amt;
                        v_tsi_amt2 := i.ann_tsi_amt;
                    END LOOP; 
                ELSE
                    v_tsi_amt  := c.tsi_amt;
                    v_tsi_amt2 := c.ann_tsi_amt;
                END IF;
                
             END LOOP;   

            IF v_pack_report.basic_co_insurance_sw = '2' THEN  
                FOR z IN (SELECT co_ri_shr_pct         
                                FROM GIXX_CO_INSURER
                               WHERE extract_id= p_extract_id
                                 AND co_ri_cd  = GIISP.n('CO_INSURER_DEFAULT')) 
                LOOP
                    v_ri_pct := z.co_ri_shr_pct;
                END LOOP;
                v_tsi_amt  := v_tsi_amt*100/v_ri_pct; 
                v_tsi_amt2 := v_tsi_amt2*100/v_ri_pct; 
            END IF;

            FOR c IN (
                  SELECT LTRIM (TRUNC(((v_tsi_amt/v_rate)-TRUNC (v_tsi_amt/v_rate))*100) ) cents                  
                           FROM dual)
            LOOP
                v_cents := c.cents;        
                EXIT;
            END LOOP;   
          ----------------------------
          
            IF v_cents = 0 AND NVL(PACK_POLICY_DOCS_PKG.print_cents,'N') = 'N' THEN 
                
                FOR c IN (
                           SELECT UPPER( DH_UTIL.spell ( TRUNC ( v_tsi_amt/v_rate)))||' ' tsi,
                                  DECODE(PACK_POLICY_DOCS_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( v_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                             UPPER( DH_UTIL.spell ( TRUNC ( v_tsi_amt2/v_rate)))||' ' tsi2,
                                  DECODE(PACK_POLICY_DOCS_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( v_tsi_amt2/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2     
                           FROM DUAL)
                      
                --LOOP   Commented out by PJD 09092013 in conection with SR13977 to give proper formatting for negative amount values
                   -- v_tsi  := c.tsi;
                    --v_num  := c.tsi_num;
                    --v_tsi2 := c.tsi2;
                    --v_num2 := c.tsi_num2;
                  
               --END LOOP;
                 LOOP   --Added by PJD 09092013 in conection with SR13977 to give proper formatting for negative amount values
                    v_tsi  := c.tsi;
                    --v_num  := c.tsi_num; 
                    IF v_tsi_amt < 0 THEN
                       v_num := REPLACE(c.tsi_num,'-','(')||')';
                    ELSE
                       v_num := c.tsi_num;
                    END IF;
                    v_tsi2 := c.tsi2;
                    --v_num2 := c.tsi_num2;
                    IF v_tsi_amt2 < 0 THEN
                       v_num2 := REPLACE(c.tsi_num2,'-','(')||')';
                    ELSE
                       v_num2 := c.tsi_num2;
                    END IF;
                   
                END LOOP;

            ELSE          
                FOR c IN (
                            SELECT UPPER( DH_UTIL.spell ( TRUNC ( v_tsi_amt/v_rate)  )
                                    || ' AND ' || LTRIM (trunc(((v_tsi_amt/v_rate)-TRUNC (v_tsi_amt/v_rate))*100 ))
                                  || '/100 ') tsi,
                                  DECODE(PACK_POLICY_DOCS_PKG.print_short_name,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( v_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                             UPPER( DH_UTIL.spell ( TRUNC ( v_tsi_amt2/v_rate)  )
                                    || ' AND ' || LTRIM (trunc(((v_tsi_amt2/v_rate)-TRUNC (v_tsi_amt2/v_rate))*100 ))
                                  || '/100 ') tsi2,
                                  DECODE(PACK_POLICY_DOCS_PKG.print_short_name,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( v_tsi_amt2/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2     
                           FROM DUAL)
                --LOOP    Commented out by PJD 09092013 in conection with SR13977 to give proper formatting for negative amount values
                    --v_tsi  := c.tsi;
                    --v_num  := c.tsi_num;
                    --v_tsi2 := c.tsi2;
                    --v_num2 := c.tsi_num2;
                            
                --END LOOP;  
                LOOP      --Added by PJD 09092013 in conection with SR13977 to give proper formatting for negative amount values
                    v_tsi  := c.tsi;
                    --v_num  := c.tsi_num; 
                    IF v_tsi_amt < 0 THEN
                       v_num := REPLACE(c.tsi_num,'-','(')||')';
                    ELSE
                       v_num := c.tsi_num;
                    END IF;
                    v_tsi2 := c.tsi2;
                    --v_num2 := c.tsi_num2;
                    IF v_tsi_amt2 < 0 THEN
                       v_num2 := REPLACE(c.tsi_num2,'-','(')||')';
                    ELSE
                       v_num2 := c.tsi_num2;
                    END IF;
                   
                END LOOP;
            END IF;        

                        
             IF PACK_POLICY_DOCS_PKG.display_ann_tsi = 'Y' THEN    
                     
                  IF LENGTH(v_tsi2||v_currency_desc) BETWEEN 60 AND 80 THEN 
                          IF PACK_POLICY_DOCS_PKG.PRINT_SHORT_NAME = 'N' THEN
                          --v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||CHR(10)||' ('||v_short_name||' '||v_num2||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||CHR(10)||' :'||v_short_name||' '||v_num2); 
                      ELSE
                          --v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||CHR(10)||' ('||' '||v_num2||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||CHR(10)||' :'||' '||v_num2);
                      END IF;
              
                          
                  ELSE    
                      IF PACK_POLICY_DOCS_PKG.print_short_name = 'N' THEN
                          --v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||' ('||v_short_name||' '||v_num2||')'); PJD 09092013 
                          v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||' :'||v_short_name||' '||v_num2); 
                      ELSE
                          --v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||' ('||' '||v_num2||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||' :'||' '||v_num2);
                      END IF;
                   END IF;    
                 
             ELSE
                          
                  IF LENGTH(v_tsi||v_currency_desc) BETWEEN 60 AND 80 THEN     
                      IF PACK_POLICY_DOCS_PKG.print_short_name = 'N' THEN   
                          --v_pack_report.f_basic_tsi_spell := (v_tsi||v_currency_desc||CHR(10)||'('||v_short_name||' '||v_num||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := (v_tsi||v_currency_desc||CHR(10)||' :'||v_short_name||' '||v_num);
                      ELSE
                          --v_pack_report.f_basic_tsi_spell := (v_tsi||v_currency_desc||CHR(10)||' ('||' '||v_num||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := (v_tsi||v_currency_desc||CHR(10)||' :'||' '||v_num);
                      END IF;
                          
                  ELSE     
                      IF PACK_POLICY_DOCS_PKG.print_short_name = 'N' THEN        
                          --v_pack_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' ('||v_short_name||' '||v_num||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' :'||v_short_name||' '||v_num);
                      ELSE
                          --v_pack_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' ('||' '||v_num||')'); PJD 09092013
                          v_pack_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' :'||' '||v_num);
                      END IF;
                  END IF;    
             END IF;
        END;
        
        /* f_user */
        DECLARE
            v_post_user        GIXX_POLBASIC.user_id%TYPE;
            v_create_user    GIXX_POLBASIC.user_id%TYPE;
        BEGIN

        FOR c IN(SELECT a.user_id user_id
                 FROM GIPI_PACK_PARHIST a,GIPI_PACK_POLBASIC b
                 WHERE a.pack_par_id     = b.pack_par_id
                   AND a.parstat_cd = '10'
                   AND b.pack_policy_id  = v_pack_report.par_id
            )
        LOOP
            v_post_user:=c.user_id;
        END LOOP;  
       
        FOR rec IN (SELECT b.pack_par_id,b.user_id user2,b.PARSTAT_DATE
                    FROM GIPI_PACK_POLBASIC a, GIPI_PACK_PARHIST b
                    WHERE a.pack_par_id = b.pack_par_id
                      AND a.pack_policy_id = v_pack_report.par_id 
                      AND b.PARSTAT_DATE = (SELECT MIN(b.PARSTAT_DATE) 
                                            FROM GIPI_PACK_POLBASIC a, GIPI_PACK_PARHIST b              
                                            WHERE a.pack_par_id = b.pack_par_id
                                              AND a.pack_policy_id = v_pack_report.par_id))
        LOOP
          v_create_user := rec.user2;
        
        END LOOP;
            v_pack_report.f_user := v_create_user||' / '|| v_post_user || CHR(10) ||TO_CHAR(SYSDATE,'DD-MON-RR')||' '||TO_CHAR(SYSDATE,'HH24:MI:SS');
        END;
        
        /* f_intm_no */
        DECLARE
            v_intm_no        VARCHAR2(100);
            v_parent        VARCHAR2(100);
            v_agent            VARCHAR2(100);
            v_orig_parent    VARCHAR2(100);
            v_orig_agent    VARCHAR2(100);
        BEGIN
            FOR a IN ( 
                SELECT DECODE(PARENT.ref_intm_cd,NULL,
                       TO_CHAR(a.parent_intm_no,'999999999990'),
                       TO_CHAR(a.parent_intm_no,'999999999990')||'-'||PARENT.ref_intm_cd)  parent_intm_no,
                       DECODE(agent.ref_intm_cd,NULL,
                       TO_CHAR(a.intrmdry_intm_no,'999999999990'),
                       TO_CHAR(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
                  FROM GIIS_INTERMEDIARY agent,
                       GIIS_INTERMEDIARY PARENT,
                       GIXX_COMM_INVOICE a 
                 WHERE a.parent_intm_no = PARENT.intm_no(+)
                   AND a.intrmdry_intm_no = agent.intm_no(+)
                   AND a.extract_id = p_extract_id)
            LOOP
                v_parent := a.parent_intm_no;
                v_agent  := a.agent_intm_no;
                EXIT;
            END LOOP;
            
            IF NVL(v_parent,'*') = NVL(v_agent,'**') THEN
                v_intm_no := ('/ '||LTRIM(v_agent));
            ELSE
                v_intm_no := v_parent||' / '||LTRIM(v_agent);
            END IF;
            
            IF v_parent IS NULL AND v_agent IS NULL  THEN
                FOR a IN ( 
                    SELECT DECODE(PARENT.ref_intm_cd,NULL,
                           TO_CHAR(a.parent_intm_no,'999999999990'),
                           TO_CHAR(a.parent_intm_no,'999999999990')||'-'||PARENT.ref_intm_cd)  parent_intm_no,
                           DECODE(agent.ref_intm_cd,NULL,
                           TO_CHAR(a.intrmdry_intm_no,'999999999990'),
                           TO_CHAR(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
                      FROM GIIS_INTERMEDIARY agent,
                           GIIS_INTERMEDIARY PARENT,
                           GIPI_COMM_INVOICE a 
                     WHERE a.parent_intm_no = PARENT.intm_no
                       AND a.intrmdry_intm_no = agent.intm_no
                       AND a.policy_id IN (SELECT a.policy_id 
                                             FROM GIPI_PACK_POLBASIC a, GIPI_PACK_INVOICE b
                                            WHERE a.pack_policy_id = b.policy_id
                                              AND a.line_cd= v_pack_report.subline_line_cd
                                              AND a.subline_cd  = v_pack_report.subline_subline_cd
                                              AND a.iss_cd = v_pack_report.basic_iss_cd 
                                              AND a.issue_yy = v_pack_report.basic_issue_yy
                                              AND a.pol_seq_no = v_pack_report.basic_pol_seq_no
                                              AND a.renew_no = v_pack_report.basic_renew_no
                                              AND a.endt_seq_no = 00
                                              AND a.pol_flag IN ('1','2','3')))
                LOOP
                    v_orig_parent := a.parent_intm_no;
                    v_orig_agent  := a.agent_intm_no;
                    EXIT;
                END LOOP;
                
                IF v_orig_parent = v_orig_agent THEN
                   v_intm_no := ('/ '||LTRIM(v_orig_agent));
                ELSE
                   v_intm_no := LTRIM(v_orig_parent)||' / '||LTRIM(v_orig_agent);
                END IF;
            END IF;    
            
            v_pack_report.f_intm_no := LTRIM(v_intm_no);
        END;
        
        /* f_intm_name */
        DECLARE
            v_intm_name            VARCHAR2(150);
            v_agent                GIIS_INTERMEDIARY.intm_name%TYPE;
            v_parent            GIIS_INTERMEDIARY.intm_name%TYPE;
            v_orig_agent        GIIS_INTERMEDIARY.intm_name%TYPE;
            v_orig_parent        GIIS_INTERMEDIARY.intm_name%TYPE;
        BEGIN
            FOR a IN ( 
                SELECT PARENT.intm_name parent_intm_name, 
                       agent.intm_name agent_intm_name
                  FROM GIIS_INTERMEDIARY agent,
                       GIIS_INTERMEDIARY PARENT,
                       GIXX_COMM_INVOICE a 
                 WHERE a.parent_intm_no = PARENT.intm_no
                   AND a.intrmdry_intm_no = agent.intm_no
                   AND a.extract_id = p_extract_id)
            LOOP
                v_parent := a.parent_intm_name; 
                v_agent := a.agent_intm_name;
                EXIT;
            END LOOP;
            
            IF v_parent = v_agent THEN
                v_intm_name := LTRIM('/ '||v_agent);
            ELSE
                v_intm_name := v_parent||' / '||v_agent;
            END IF;
            
            IF v_parent IS NULL AND v_agent IS NULL THEN
                FOR a IN ( 
                    SELECT PARENT.intm_name parent_intm_name, 
                           agent.intm_name agent_intm_name
                      FROM GIIS_INTERMEDIARY agent,
                           GIIS_INTERMEDIARY PARENT,
                           GIPI_COMM_INVOICE a 
                     WHERE a.parent_intm_no = PARENT.intm_no
                       AND a.intrmdry_intm_no = agent.intm_no
                       AND a.policy_id IN (SELECT a.pack_policy_id 
                                             FROM GIPI_PACK_POLBASIC a, GIPI_PACK_INVOICE b
                                            WHERE a.pack_policy_id = b.policy_id
                                              AND a.line_cd = v_pack_report.subline_line_cd
                                                AND a.subline_cd = v_pack_report.subline_subline_cd
                                                AND a.iss_cd = v_pack_report.basic_iss_cd 
                                                AND a.issue_yy = v_pack_report.basic_issue_yy
                                                AND a.pol_seq_no = v_pack_report.basic_pol_seq_no
                                                AND a.renew_no = v_pack_report.basic_renew_no
                                                AND a.endt_seq_no = 00
                                                AND a.pol_flag IN ('1','2','3')))
                LOOP
                    v_orig_parent := a.parent_intm_name;
                    v_orig_agent  := a.agent_intm_name;
                    EXIT;
                END LOOP;
                
                IF v_orig_parent = v_orig_agent THEN
                    v_intm_name := LTRIM('/ '||v_orig_agent);
                ELSE
                    v_intm_name := v_orig_parent||' / '||v_orig_agent;
                END IF;
            END IF;
            
            v_pack_report.f_intm_name := LTRIM(v_intm_name);
        END;
        
        /* f_ref_inv_no */
        DECLARE
            v_ref_inv_no    GIXX_PACK_INVOICE.ref_inv_no%TYPE;
            v_count         NUMBER(2):=1;
        BEGIN
            IF v_pack_report.basic_co_insurance_sw = 1 THEN
                FOR a IN (
                    SELECT ref_inv_no
                        FROM GIXX_PACK_INVOICE
                     WHERE extract_id = p_extract_id)
                LOOP
                    IF v_count = 1 THEN
                        v_ref_inv_no := a.ref_inv_no;
                    ELSE
                        IF a.ref_inv_no IS NOT NULL THEN
                            v_ref_inv_no := v_ref_inv_no || CHR(10) || a.ref_inv_no;
                        END IF;
                    END IF;
                    v_count := v_count + 1;
                END LOOP;
            ELSE
                FOR a IN (
                    SELECT ref_inv_no
                      FROM GIXX_PACK_INVOICE
                     WHERE extract_id = p_extract_id)
                LOOP
                    IF v_count = 1 THEN
                        v_ref_inv_no := a.ref_inv_no;
                    ELSE
                        IF a.ref_inv_no IS NOT NULL THEN
                            v_ref_inv_no := v_ref_inv_no || CHR(10) || a.ref_inv_no;
                        END IF;
                    END IF;
                    v_count := v_count + 1;
                END LOOP;
            END IF;
            v_pack_report.f_ref_inv_no := v_ref_inv_no;
        END;
        
        /* f_policy_id */
        DECLARE
            v_pol_id  GIPI_PACK_POLBASIC.pack_policy_id%TYPE;
        BEGIN
            FOR a IN (
                SELECT line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no
                  FROM GIXX_PACK_POLBASIC
                 WHERE extract_id = p_extract_id)
            LOOP
                BEGIN
                  SELECT pack_policy_id
                    INTO v_pol_id
                    FROM GIPI_PACK_POLBASIC
                   WHERE line_cd = a.line_cd
                     AND subline_cd  = a.subline_cd
                     AND iss_cd = a.iss_cd
                     AND issue_yy = a.issue_yy
                     AND pol_seq_no = a.pol_seq_no
                     AND renew_no = a.renew_no
                     AND endt_seq_no = 0;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_pol_id := 0;
                END;
            
            END LOOP;
            
            v_pack_report.f_policy_id := v_pol_id;
            
        END;
        
        /* f_signatory_text1  */
        DECLARE
            v_pol_text1            GIIS_DOCUMENT.text%TYPE;
            v_pol_text2            GIIS_DOCUMENT.text%TYPE;
            v_endt_text1        GIIS_DOCUMENT.text%TYPE;
            v_endt_text2        GIIS_DOCUMENT.text%TYPE;
            v_iss_add            VARCHAR2(150);
            v_signatory_text1     VARCHAR2(2000);
            v_signatory_text2     VARCHAR2(2000);
        BEGIN
            FOR n IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_POL1'
                   AND line_cd = Giis_Line_Pkg.get_line_cd(p_report_id)
                   AND report_id = p_report_id)
            LOOP
                v_pol_text1 := n.text;
            END LOOP;
            
            FOR n IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_POL2'
                   AND line_cd = Giis_Line_Pkg.get_line_cd(p_report_id)
                   AND report_id = p_report_id)
            LOOP
                v_pol_text2 := n.text;
            END LOOP;
            
            FOR e IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_ENDT1'
                   AND line_cd = Giis_Line_Pkg.get_line_cd(p_report_id)
                   AND report_id = p_report_id)
            LOOP
                v_endt_text1 := e.text;
            END LOOP;
            
            FOR e IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_ENDT2'
                   AND line_cd = Giis_Line_Pkg.get_line_cd(p_report_id)
                   AND report_id = p_report_id)
            LOOP
                v_endt_text2 := e.text;
            END LOOP;
            
            FOR r IN (
                SELECT address1 address
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd = v_pack_report.basic_iss_cd)
            LOOP
                v_iss_add := r.address;
            END LOOP;
            
            IF v_pack_report.par_par_type = 'P' THEN
                IF v_pol_text1 IS NOT NULL THEN
                    v_signatory_text1 := v_pol_text1 || ' ' || v_iss_add || '.';
                ELSE
                    v_signatory_text1 := NULL;
                END IF;
                
                IF v_pol_text2 IS NOT NULL THEN
                    v_signatory_text2 := v_pol_text2 || ' ' || v_iss_add || '.';
                ELSE
                    v_signatory_text2 := NULL;
                END IF;
            ELSE
                v_signatory_text1 := v_endt_text1;
                v_signatory_text2 := v_endt_text2;
            END IF;
            
            v_pack_report.f_signatory_text1 := v_signatory_text1;
            v_pack_report.f_signatory_text2 := v_signatory_text2;
        END;
        
        /* f_company */
        DECLARE
            v_company_name VARCHAR2(100);
        BEGIN
            FOR NAME IN (
                SELECT param_value_v
                  FROM GIIS_PARAMETERS
                 WHERE param_name = 'COMPANY_NAME')
            LOOP
                v_company_name := NAME.param_value_v;
            END LOOP;
            
            v_pack_report.f_company := v_company_name;
        END;
        
        /* f_signatory  */
        DECLARE
            v_signatory        VARCHAR2(50);
            v_designation    VARCHAR2(50);
            v_file_name        giis_signatory_names.file_name%TYPE; -- bonok :: 8.5.2015 :: UPCB SR 20062
        BEGIN
            FOR A IN (SELECT RTRIM(LTRIM(UPPER(signatory))) signatory, 
                            RTRIM(LTRIM(INITCAP(designation))) designation,
                            file_name -- bonok :: 8.5.2015 :: UPCB SR 20062
                            FROM GIIS_SIGNATORY_NAMES A
                                ,GIIS_SIGNATORY B
                            WHERE A.signatory_id = B.signatory_id
                             AND iss_cd IN (SELECT iss_cd
                                            FROM GIXX_PACK_POLBASIC
                                            WHERE extract_id = p_extract_id)
                              AND B.current_signatory_sw = 'Y'
                              AND b.line_cd = v_pack_report.line_cd)
                                                  
            LOOP
                v_signatory     := a.signatory;
                v_designation   := a.designation;
                v_file_name     := a.file_name; -- bonok :: 8.5.2015 :: UPCB SR 20062
            END LOOP;  
    
            v_pack_report.f_signatory   := v_signatory;
            v_pack_report.f_designation := v_designation;
            v_pack_report.f_file_name   := v_file_name; -- bonok :: 8.5.2015 :: UPCB SR 20062
        END;
        
        /** show_polwc_last **/
        
        DECLARE
            v_show_polwc_last       VARCHAR2(1) := 'N';
        BEGIN
            FOR a IN (
                    SELECT extract_id
                    FROM gixx_polwc
                    WHERE extract_id = p_extract_id
                    AND print_sw = 'Y')
            LOOP
                v_show_polwc_last := 'Y';
            END LOOP;
            
            v_pack_report.show_polwc_last := v_show_polwc_last;
            
        END;
        
              v_pack_report.rv_tax_breakdown               := PACK_POLICY_DOCS_PKG.tax_breakdown;
              v_pack_report.rv_display_policy_term         := PACK_POLICY_DOCS_PKG.display_policy_term;
              v_pack_report.rv_print_mortgagee             := PACK_POLICY_DOCS_PKG.print_mortgagee;
              v_pack_report.rv_print_item_total            := PACK_POLICY_DOCS_PKG.print_item_total;
              v_pack_report.rv_print_peril                 := PACK_POLICY_DOCS_PKG.print_peril;
              v_pack_report.rv_print_renewal_top           := PACK_POLICY_DOCS_PKG.print_renewal_top;
              v_pack_report.rv_print_doc_subtitle1         := PACK_POLICY_DOCS_PKG.print_doc_subtitle1;
              v_pack_report.rv_print_doc_subtitle2         := PACK_POLICY_DOCS_PKG.print_doc_subtitle2;
              v_pack_report.rv_print_doc_subtitle3         := PACK_POLICY_DOCS_PKG.print_doc_subtitle3;
              v_pack_report.rv_print_doc_subtitle4         := PACK_POLICY_DOCS_PKG.print_doc_subtitle4;
              v_pack_report.rv_print_deductibles           := PACK_POLICY_DOCS_PKG.print_deductibles;
              v_pack_report.rv_print_accessories_above     := PACK_POLICY_DOCS_PKG.print_accessories_above;
              v_pack_report.rv_print_all_warranties        := PACK_POLICY_DOCS_PKG.print_all_warranties;
              v_pack_report.rv_print_wrrnties_fontbig      := PACK_POLICY_DOCS_PKG.print_wrrnties_fontbig;
              v_pack_report.rv_print_last_endtxt           := PACK_POLICY_DOCS_PKG.print_last_endtxt;
              v_pack_report.rv_print_sub_info              := PACK_POLICY_DOCS_PKG.print_sub_info;
              v_pack_report.rv_doc_tax_breakdown           := PACK_POLICY_DOCS_PKG.doc_tax_breakdown;        
              v_pack_report.rv_print_ref_pol_no            := PACK_POLICY_DOCS_PKG.print_ref_pol_no;
              v_pack_report.rv_print_premium_rate          := PACK_POLICY_DOCS_PKG.print_premium_rate;        
              v_pack_report.rv_print_mort_amt              := PACK_POLICY_DOCS_PKG.print_mort_amt;
              v_pack_report.rv_print_sum_insured           := PACK_POLICY_DOCS_PKG.print_sum_insured ;
              v_pack_report.rv_print_one_item_title        := PACK_POLICY_DOCS_PKG.print_one_item_title;
              v_pack_report.rv_print_report_title          := PACK_POLICY_DOCS_PKG.print_report_title;
              v_pack_report.rv_print_intm_name             := PACK_POLICY_DOCS_PKG.print_intm_name;
              v_pack_report.rv_doc_total_in_box            := PACK_POLICY_DOCS_PKG.doc_total_in_box ; 
              v_pack_report.rv_doc_subtitle1               := PACK_POLICY_DOCS_PKG.doc_subtitle1; 
              v_pack_report.rv_doc_subtitle2               := PACK_POLICY_DOCS_PKG.doc_subtitle2; 
              v_pack_report.rv_doc_subtitle3               := PACK_POLICY_DOCS_PKG.doc_subtitle3; 
              v_pack_report.rv_doc_subtitle4               := PACK_POLICY_DOCS_PKG.doc_subtitle4; 
              v_pack_report.rv_invoice_policy_currency     := PACK_POLICY_DOCS_PKG.invoice_policy_currency;
              v_pack_report.rv_doc_subtitle4_before_wc     := PACK_POLICY_DOCS_PKG.doc_subtitle4_before_wc;
              v_pack_report.rv_print_time                  := PACK_POLICY_DOCS_PKG.print_time; 
              v_pack_report.rv_deductible_title            := PACK_POLICY_DOCS_PKG.deductible_title; 
              v_pack_report.rv_print_upper_case            := PACK_POLICY_DOCS_PKG.print_upper_case; 
              v_pack_report.rv_sum_insured_title           := PACK_POLICY_DOCS_PKG.sum_insured_title; 
              v_pack_report.rv_item_title                  := PACK_POLICY_DOCS_PKG.item_title; 
              v_pack_report.rv_peril_title                 := PACK_POLICY_DOCS_PKG.peril_title;
              v_pack_report.rv_print_peril_long_name       := PACK_POLICY_DOCS_PKG.print_peril_long_name;
              v_pack_report.rv_print_deduct_text_amt       := PACK_POLICY_DOCS_PKG.print_deduct_text_amt;
              v_pack_report.rv_grouped_item_title          := PACK_POLICY_DOCS_PKG.grouped_item_title;
              v_pack_report.rv_personnel_item_title        := PACK_POLICY_DOCS_PKG.personnel_item_title;
              v_pack_report.rv_personnel_subtitle1         := PACK_POLICY_DOCS_PKG.personnel_subtitle1;
              v_pack_report.rv_personnel_subtitle2         := PACK_POLICY_DOCS_PKG.personnel_subtitle2;
              v_pack_report.rv_grouped_subtitle            := PACK_POLICY_DOCS_PKG.grouped_subtitle;
              v_pack_report.rv_attestation_title           := PACK_POLICY_DOCS_PKG.attestation_title;
              v_pack_report.rv_print_currency_desc         := PACK_POLICY_DOCS_PKG.print_currency_desc;
              v_pack_report.rv_print_peril_name_long       := PACK_POLICY_DOCS_PKG.print_currency_desc;
              v_pack_report.rv_print_short_name            := PACK_POLICY_DOCS_PKG.print_short_name;
              v_pack_report.rv_print_null_mortgagee        := PACK_POLICY_DOCS_PKG.print_null_mortgagee;

              --------------------------------------------------------------------------------
              v_pack_report.rv_print_grouped_beneficiary   := PACK_POLICY_DOCS_PKG.print_grouped_beneficiary;
              v_pack_report.rv_beneficiary_item_title      := PACK_POLICY_DOCS_PKG.beneficiary_item_title;
              v_pack_report.rv_beneficiary_subtitle1       := PACK_POLICY_DOCS_PKG.beneficiary_subtitle1;
              v_pack_report.rv_beneficiary_subtitle2       := PACK_POLICY_DOCS_PKG.beneficiary_subtitle2;
              v_pack_report.rv_block_description           := PACK_POLICY_DOCS_PKG.block_description;
              v_pack_report.rv_boundary_title              := PACK_POLICY_DOCS_PKG.boundary_title;
              v_pack_report.rv_constr_remarks_title        := PACK_POLICY_DOCS_PKG.constr_remarks_title;
              v_pack_report.rv_construction_title          := PACK_POLICY_DOCS_PKG.construction_title;
              v_pack_report.rv_occupancy_remarks_title     := PACK_POLICY_DOCS_PKG.occupancy_remarks_title;
              v_pack_report.rv_occupancy_title             := PACK_POLICY_DOCS_PKG.occupancy_title;
              v_pack_report.rv_print_zone                  := PACK_POLICY_DOCS_PKG.print_zone;
              v_pack_report.rv_doc_attestation1            := PACK_POLICY_DOCS_PKG.doc_attestation1;
              v_pack_report.rv_doc_attestation2            := PACK_POLICY_DOCS_PKG.doc_attestation2;
              v_pack_report.rv_doc_attestation3            := PACK_POLICY_DOCS_PKG.doc_attestation3;
              v_pack_report.rv_print_tariff_zone           := PACK_POLICY_DOCS_PKG.print_tariff_zone;
              v_pack_report.rv_par_endt_header             := PACK_POLICY_DOCS_PKG.par_endt_header; 
              v_pack_report.rv_without_item_no             := PACK_POLICY_DOCS_PKG.without_item_no;  
              v_pack_report.rv_print_ded_text_peril        := PACK_POLICY_DOCS_PKG.print_ded_text_peril  ;
              v_pack_report.rv_line_hidden                 := PACK_POLICY_DOCS_PKG.line_hidden ;
              v_pack_report.rv_desc_label                  := PACK_POLICY_DOCS_PKG.desc_label;
              v_pack_report.rv_display_section             := PACK_POLICY_DOCS_PKG.display_section ;      
              v_pack_report.rv_print_cents                 := PACK_POLICY_DOCS_PKG.print_cents; 
              v_pack_report.rv_leased_to                   := PACK_POLICY_DOCS_PKG.leased_to ;
              v_pack_report.rv_print_gen_info_above        := PACK_POLICY_DOCS_PKG.print_gen_info_above;  
              v_pack_report.rv_display_ann_tsi             := PACK_POLICY_DOCS_PKG.display_ann_tsi ; 
              v_pack_report.rv_display_tsi_endt            := PACK_POLICY_DOCS_PKG.display_tsi_endt; 
           
              v_pack_report.ca_print_one_item_title        := PACK_POLICY_DOCS_PKG.ca_print_one_item_title;
              v_pack_report.ca_print_peril                 := PACK_POLICY_DOCS_PKG.ca_print_peril;   
              v_pack_report.ca_print_deduct_text_amt       := PACK_POLICY_DOCS_PKG.ca_print_deduct_text_amt;  
              v_pack_report.ca_doc_subtitle2               := PACK_POLICY_DOCS_PKG.ca_doc_subtitle2; 

              v_pack_report.en_item_title                  := PACK_POLICY_DOCS_PKG.en_item_title;
              v_pack_report.en_print_peril                 := PACK_POLICY_DOCS_PKG.en_print_peril;  
              v_pack_report.en_print_ded_text              := PACK_POLICY_DOCS_PKG.en_print_ded_text;  
              v_pack_report.en_print_tabular               := PACK_POLICY_DOCS_PKG.en_print_tabular; 
                  
              v_pack_report.pa_item_title                  := PACK_POLICY_DOCS_PKG.pa_item_title; 
              v_pack_report.pa_print_eff_exp_date          := PACK_POLICY_DOCS_PKG.pa_print_eff_exp_date;  
              v_pack_report.pa_print_ded_text_peril        := PACK_POLICY_DOCS_PKG.pa_print_ded_text_peril;
              v_pack_report.pa_print_peril                 := PACK_POLICY_DOCS_PKG.pa_print_peril; 

              v_pack_report.fi_display_district            := PACK_POLICY_DOCS_PKG.fi_display_district;  
              v_pack_report.fi_display_type                := PACK_POLICY_DOCS_PKG.fi_display_type;
              v_pack_report.fi_display_cons                := PACK_POLICY_DOCS_PKG.fi_display_cons;
              v_pack_report.fi_check_risk                  := PACK_POLICY_DOCS_PKG.fi_check_risk;      
              v_pack_report.fi_print_peril                 := PACK_POLICY_DOCS_PKG.fi_print_peril;  
              v_pack_report.fi_print_desc_below            := PACK_POLICY_DOCS_PKG.fi_print_desc_below; 
              v_pack_report.fi_curr_rt                     := PACK_POLICY_DOCS_PKG.fi_curr_rt;
                   
              v_pack_report.mn_print_mop_deductibles       := PACK_POLICY_DOCS_PKG.mn_print_mop_deductibles;
              v_pack_report.mn_print_declaration_no        := PACK_POLICY_DOCS_PKG.mn_print_declaration_no;
              v_pack_report.mn_pack_method                 := PACK_POLICY_DOCS_PKG.mn_pack_method;
              v_pack_report.mn_print_cargo_desc            := PACK_POLICY_DOCS_PKG.mn_print_cargo_desc;   
              v_pack_report.mn_print_origin_dest_above     := PACK_POLICY_DOCS_PKG.mn_print_origin_dest_above;  
              v_pack_report.mn_print_premium_rate          := PACK_POLICY_DOCS_PKG.mn_print_premium_rate; 
              v_pack_report.mn_print_peril                 := PACK_POLICY_DOCS_PKG.mn_print_peril; 
              v_pack_report.vestype_desc                   := PACK_POLICY_DOCS_PKG.vestype_desc;

              v_pack_report.rv_print_text_beside_signatory := PACK_POLICY_DOCS_PKG.print_text_beside_signatory;
              v_pack_report.rv_display_neg_amt             := PACK_POLICY_DOCS_PKG.display_neg_amt;
              v_pack_report.rv_display_item_title          := PACK_POLICY_DOCS_PKG.display_item_title;
              v_pack_report.show_item_risk_amt             := PACK_POLICY_DOCS_PKG.show_item_risk_amt;
              v_pack_report.rv_print_original              := PACK_POLICY_DOCS_PKG.print_original;
              v_pack_report.rv_print_deductible_amt        := PACK_POLICY_DOCS_PKG.print_deductible_amt;
              v_pack_report.rv_policy_siglabel             := PACK_POLICY_DOCS_PKG.policy_siglabel;
              v_pack_report.bank_ref_no_label              := PACK_POLICY_DOCS_PKG.bank_ref_no_label;
              v_pack_report.FI                             := PACK_POLICY_DOCS_PKG.FI;
              v_pack_report.EN                             := PACK_POLICY_DOCS_PKG.EN;
              v_pack_report.MC                             := PACK_POLICY_DOCS_PKG.MC;
              v_pack_report.MN                             := PACK_POLICY_DOCS_PKG.MN;
              v_pack_report.CA                             := PACK_POLICY_DOCS_PKG.CA;
              v_pack_report.AC                             := PACK_POLICY_DOCS_PKG.AC;
              
              -- marco - 02.08.2013 - ucpb specific enhancement
              v_pack_report.print_deductible_type          := GIIS_DOCUMENT_PKG.get_doc_text2(v_pack_report.basic_line_cd, p_report_id, 'PRINT_DEDUCTIBLE_LOSSTYPE');
        
        PIPE ROW(v_pack_report);
                
    END;
    

    PROCEDURE initialize_package (p_rep_id IN GIIS_REPORTS.REPORT_ID%TYPE) IS

    BEGIN
        FOR REPORT IN (SELECT TITLE,TEXT 
                       FROM giis_document    
                       WHERE report_id = p_rep_id)
        LOOP
             IF REPORT.TITLE = 'POLICY_POLICY_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.par_policy := REPORT.TEXT;
             END IF; 
             IF REPORT.TITLE = 'ENDT_PAR_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.endt_par := REPORT.TEXT;
             END IF; 
             IF REPORT.TITLE = 'ENDT_POLICY_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.endt_policy := REPORT.TEXT;
             END IF; 
             IF REPORT.TITLE = 'POLICY_PAR_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.par_par := REPORT.TEXT;
             END IF;               
             IF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
                 PACK_POLICY_DOCS_PKG.tax_breakdown := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_MORTGAGEE' THEN
                 PACK_POLICY_DOCS_PKG.print_mortgagee := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_CURRENCY_DESC' THEN
                 PACK_POLICY_DOCS_PKG.print_currency_desc := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_ITEM_TOTAL' THEN
                 PACK_POLICY_DOCS_PKG.print_item_total := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_PERIL' THEN
                 PACK_POLICY_DOCS_PKG.print_peril := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_PERIL_LONG_NAME' THEN
                 PACK_POLICY_DOCS_PKG.print_peril_name_long := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_RENEWAL_TOP' THEN
                 PACK_POLICY_DOCS_PKG.print_renewal_top := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE1' THEN
                 PACK_POLICY_DOCS_PKG.print_doc_subtitle1 := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_DEDUCTIBLES' THEN
                 PACK_POLICY_DOCS_PKG.print_deductibles := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE2' THEN
                 PACK_POLICY_DOCS_PKG.print_doc_subtitle2 := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE3' THEN
                 PACK_POLICY_DOCS_PKG.print_doc_subtitle3 := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_DOC_SUBTITLE4' THEN
                 PACK_POLICY_DOCS_PKG.print_doc_subtitle4 := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_ACCESSORIES_ABOVE' THEN
                 PACK_POLICY_DOCS_PKG.print_accessories_above := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_WARRANTIES_FONT_BIG' THEN
                 PACK_POLICY_DOCS_PKG.print_wrrnties_fontbig := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_ALL_WARRANTIES_TITLE_ABOVE' THEN
                 PACK_POLICY_DOCS_PKG.print_all_warranties := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_LAST_ENDTXT' THEN
                 PACK_POLICY_DOCS_PKG.print_last_endtxt := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_SUB_INFO' THEN
                 PACK_POLICY_DOCS_PKG.print_sub_info := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
                 PACK_POLICY_DOCS_PKG.doc_tax_breakdown := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_PREMIUM_RATE' THEN
                 PACK_POLICY_DOCS_PKG.print_premium_rate := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_MORT_AMT' THEN
                 PACK_POLICY_DOCS_PKG.print_mort_amt := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_SUM_INSURED' THEN
                 PACK_POLICY_DOCS_PKG.print_sum_insured := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_ONE_ITEM_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.print_one_item_title := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_REPORT_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.print_report_title := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_INTM_NAME' THEN
                 PACK_POLICY_DOCS_PKG.print_intm_name := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_TOTAL_IN_BOX' THEN
                 PACK_POLICY_DOCS_PKG.doc_total_in_box := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_SUBTITLE1' THEN
                 PACK_POLICY_DOCS_PKG.doc_subtitle1  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_SUBTITLE2' THEN
                 PACK_POLICY_DOCS_PKG.doc_subtitle2  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_SUBTITLE3' THEN
                 PACK_POLICY_DOCS_PKG.doc_subtitle3  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_SUBTITLE4' THEN
                 PACK_POLICY_DOCS_PKG.doc_subtitle4  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_SUBTITLE4_BEFORE_WC' THEN
                 PACK_POLICY_DOCS_PKG.doc_subtitle4_before_wc  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DEDUCTIBLE_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.deductible_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PERIL_TITLE' THEN
                PACK_POLICY_DOCS_PKG.peril_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'ITEM_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.item_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'SUM_INSURED_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.sum_insured_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_UPPER_CASE' THEN
                 PACK_POLICY_DOCS_PKG.print_upper_case  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_GROUPED_BENEFICIARY' THEN
                 PACK_POLICY_DOCS_PKG.print_grouped_beneficiary := REPORT.TEXT;
             END IF;
           
             IF REPORT.TITLE = 'PRINT_DEDUCTIBLES_TEXT_AMT' THEN
                 PACK_POLICY_DOCS_PKG.print_deduct_text_amt  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PERSONNEL_ITEM_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.personnel_item_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'GROUPED_ITEM_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.grouped_item_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PERSONNEL_SUBTITLE1' THEN
                 PACK_POLICY_DOCS_PKG.personnel_subtitle1  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PERSONNEL_SUBTITLE2' THEN
                 PACK_POLICY_DOCS_PKG.personnel_subtitle2  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'GROUPED_SUBTITLE' THEN
                 PACK_POLICY_DOCS_PKG.grouped_subtitle  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'ATTESTATION_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.attestation_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_SHORT_NAME' THEN
                 PACK_POLICY_DOCS_PKG.print_short_name  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_NULL_MORTGAGEE' THEN
                 PACK_POLICY_DOCS_PKG.print_null_mortgagee  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DISPLAY_POLICY_TERM' THEN  
                 PACK_POLICY_DOCS_PKG.display_policy_term  := REPORT.TEXT;
             END IF;
        
    -----------------------------------------------------------------------------
             IF REPORT.TITLE = 'BENEFICIARY_SUBTITLE2' THEN
                 PACK_POLICY_DOCS_PKG.beneficiary_subtitle2  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'BENEFICIARY_SUBTITLE1' THEN
                 PACK_POLICY_DOCS_PKG.beneficiary_subtitle1  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'BENEFICIARY_ITEM_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.beneficiary_item_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_GROUPED_BENEFICIARY' THEN
                 PACK_POLICY_DOCS_PKG.print_grouped_beneficiary := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_ACCESSORIES_ABOVE' THEN
                 PACK_POLICY_DOCS_PKG.print_accessories_above := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'BLOCK_DESCRIPTION' THEN
                 PACK_POLICY_DOCS_PKG.block_description  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'BOUNDARY_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.boundary_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'CONSTRUCTION_REMARKS_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.constr_remarks_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'CONSTRUCTION_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.construction_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'OCCUPANCY_REMARKS_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.occupancy_remarks_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'OCCUPANCY_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.occupancy_title  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_ZONE' THEN
                 PACK_POLICY_DOCS_PKG.print_zone  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_ATTESTATION1' THEN
                 PACK_POLICY_DOCS_PKG.doc_attestation1  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_ATTESTATION2' THEN
                 PACK_POLICY_DOCS_PKG.doc_attestation2  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'DOC_ATTESTATION3' THEN
                 PACK_POLICY_DOCS_PKG.doc_attestation3  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_PERIL_LONG_NAME' THEN
                 PACK_POLICY_DOCS_PKG.print_peril_long_name  := REPORT.TEXT;
             END IF;
             IF REPORT.TITLE = 'PRINT_TARIFF_ZONE' THEN
                 PACK_POLICY_DOCS_PKG.print_tariff_zone  := REPORT.TEXT;
             END IF;
             
    ----------------@FPAC -------------------------
    ---------------ALL LINES----------------------- 
            IF REPORT.TITLE = 'PAR_ENDT_HEADER' THEN  
                 PACK_POLICY_DOCS_PKG.par_endt_header  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'WITHOUT_ITEM_NO' THEN 
                 PACK_POLICY_DOCS_PKG.without_item_no  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'PRINT_TIME' THEN  
                 PACK_POLICY_DOCS_PKG.print_time  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'PRINT_DED_TEXT_PERIL' THEN  
                 PACK_POLICY_DOCS_PKG.print_ded_text_peril  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'PRINT_REF_POL_NO' THEN  
                 PACK_POLICY_DOCS_PKG.print_ref_pol_no  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'LINE_HIDDEN' THEN  
                 PACK_POLICY_DOCS_PKG.line_hidden  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'DESC_LABEL' THEN  
                 PACK_POLICY_DOCS_PKG.desc_label  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'DISPLAY_SECTION' THEN  
                 PACK_POLICY_DOCS_PKG.display_section  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PRINT_CENTS' THEN  
                 PACK_POLICY_DOCS_PKG.print_cents  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'LEASED_TO' THEN 
                 PACK_POLICY_DOCS_PKG.leased_to  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PRINT_GEN_INFO_ABOVE' THEN  
                 PACK_POLICY_DOCS_PKG.print_gen_info_above  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'DISPLAY_ANN_TSI' THEN  
                 PACK_POLICY_DOCS_PKG.display_ann_tsi  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'DISPLAY_TSI_ENDT' THEN  
                 PACK_POLICY_DOCS_PKG.display_tsi_endt  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PRINT_REF_POL_NO' THEN 
                 PACK_POLICY_DOCS_PKG.print_ref_pol_no  := REPORT.TEXT;
            END IF;
          
    ---------------CASUALTY------------------------
            IF REPORT.TITLE = 'CA_PRINT_ONE_ITEM_TITLE' THEN 
                 PACK_POLICY_DOCS_PKG.ca_print_one_item_title  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'CA_PRINT_PERIL' THEN  
                 PACK_POLICY_DOCS_PKG.ca_print_peril  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'CA_PRINT_DEDUCT_TEXT_AMT' THEN 
                 PACK_POLICY_DOCS_PKG.ca_print_deduct_text_amt  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'CA_DOC_SUBTITLE2' THEN  
                 PACK_POLICY_DOCS_PKG.ca_doc_subtitle2  := REPORT.TEXT;
            END IF; 
    ---------------ENGINEERING----------------------      
            IF REPORT.TITLE = 'EN_ITEM_TITLE' THEN  
                 PACK_POLICY_DOCS_PKG.en_item_title  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'EN_PRINT_PERIL' THEN  
                 PACK_POLICY_DOCS_PKG.en_print_peril  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'EN_PRINT_DED_TEXT' THEN  
                 PACK_POLICY_DOCS_PKG.en_print_ded_text  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'EN_PRINT_TABULAR' THEN  
                 PACK_POLICY_DOCS_PKG.en_print_tabular  := REPORT.TEXT;
            END IF;
          
    -----------------ACCIDENT------------------------
            IF REPORT.TITLE = 'PA_ITEM_TITLE' THEN  
                 PACK_POLICY_DOCS_PKG.pa_item_title  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PA_PRINT_EFF_EXP_DATE' THEN 
                 PACK_POLICY_DOCS_PKG.pa_print_eff_exp_date  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PA_PRINT_DED_TEXT_PERIL' THEN 
                 PACK_POLICY_DOCS_PKG.pa_print_ded_text_peril  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PA_PRINT_PERIL' THEN  
                 PACK_POLICY_DOCS_PKG.pa_print_peril  := REPORT.TEXT;
            END IF;

    ------------------FIRE----------------------------
            IF REPORT.TITLE = 'FI_DISPLAY_DISTRICT' THEN  
                 PACK_POLICY_DOCS_PKG.fi_display_district  := REPORT.TEXT;
            END IF;  
            IF REPORT.TITLE = 'FI_DISPLAY_TYPE' THEN  
                 PACK_POLICY_DOCS_PKG.fi_display_type  := REPORT.TEXT;
            END IF;  
            IF REPORT.TITLE = 'FI_DISPLAY_CONS' THEN  
                 PACK_POLICY_DOCS_PKG.fi_display_cons  := REPORT.TEXT;
            END IF;  
            IF REPORT.TITLE = 'FI_CHECK_RISK' THEN  
                 PACK_POLICY_DOCS_PKG.fi_check_risk  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'FI_PRINT_PERIL' THEN
                 PACK_POLICY_DOCS_PKG.fi_print_peril  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'FI_PRINT_DESC_BELOW' THEN 
                 PACK_POLICY_DOCS_PKG.fi_print_desc_below  := REPORT.TEXT;
            END IF; 
    ------------------MARINE CARGO----------------------      
            IF REPORT.TITLE = 'MN_PRINT_MOP_DEDUCTIBLES' THEN 
                 PACK_POLICY_DOCS_PKG.mn_print_mop_deductibles  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'MN_PRINT_DECLARATION_NO' THEN 
                 PACK_POLICY_DOCS_PKG.mn_print_declaration_no  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'MN_PACK_METHOD' THEN  
                 PACK_POLICY_DOCS_PKG.mn_pack_method  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'MN_PRINT_CARGO_DESC' THEN 
                 PACK_POLICY_DOCS_PKG.mn_print_cargo_desc  := REPORT.TEXT;
            END IF; 
            IF REPORT.TITLE = 'MN_PRINT_ORIGIN_DEST_ABOVE' THEN  
                 PACK_POLICY_DOCS_PKG.mn_print_origin_dest_above  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'MN_PRINT_PREMIUM_RATE' THEN  
                 PACK_POLICY_DOCS_PKG.mn_print_premium_rate  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'MN_PRINT_PERIL' THEN  
                 PACK_POLICY_DOCS_PKG.mn_print_peril  := REPORT.TEXT;
            END IF;
          
            IF REPORT.TITLE = 'PRINT_TEXT_BESIDE_SIGNATORY' THEN  
                 PACK_POLICY_DOCS_PKG.print_text_beside_signatory := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'DISPLAY_NEG_AMT' THEN  
                 PACK_POLICY_DOCS_PKG.display_neg_amt := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'DISPLAY_ITEM_TITLE' THEN
                 PACK_POLICY_DOCS_PKG.display_item_title := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'SHOW_ITEM_RISK_AMT' THEN  
                 PACK_POLICY_DOCS_PKG.show_item_risk_amt := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PRINT_ORIGINAL' THEN  
                 PACK_POLICY_DOCS_PKG.print_original := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'PRINT_DEDUCTIBLE_AMT' THEN 
                 PACK_POLICY_DOCS_PKG.print_deductible_amt  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'POLICY_SIGLABEL' THEN 
                 PACK_POLICY_DOCS_PKG.policy_siglabel  := REPORT.TEXT;
            END IF;
            IF REPORT.TITLE = 'BANK_REF_NO_LABEL' THEN 
                 PACK_POLICY_DOCS_PKG.bank_ref_no_label  := REPORT.TEXT;
            END IF;
            
        END LOOP;
  END initialize_package;
  
  FUNCTION get_pack_policy_taxes(  p_extract_id         IN  GIXX_PACK_POLBASIC.extract_id%TYPE,
                                   p_co_insurance_sw    IN  GIXX_PACK_POLBASIC.co_insurance_sw%TYPE,
                                   p_display_neg_amt    IN  GIIS_DOCUMENT.text%TYPE)
                                   
    RETURN pack_taxes_tab PIPELINED

    IS
        v_taxes            pack_taxes_type;
        v_ri_pct           NUMBER(16,2);
        v_full_share       NUMBER(16,2);
        v_tax_amt          NUMBER(16,2);           
        CURSOR taxes IS
            (SELECT ALL invtax.extract_id               EXTRACT_ID,
                     invtax.tax_cd                      INVTAX_TAX_CD,
                     DECODE(inv.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt)) INVTAX_TAX_AMT,
                     taxcharg.tax_name                  TAXCHARG_TAX_DESC
                FROM GIXX_PACK_INVOICE invoice,
                     GIXX_PACK_INV_TAX invtax,
                     GIAC_TAXES taxcharg,
                     GIXX_PACK_POLBASIC pol,
                     GIXX_PACK_PARLIST par,
                     (SELECT DISTINCT extract_id,policy_currency FROM GIXX_INVOICE WHERE extract_id = p_extract_id) inv
               WHERE 1=1
                 AND invoice.extract_id = invtax.extract_id
                 AND invoice.extract_id = inv.extract_id
                 AND invoice.extract_id = pol.extract_id
                 AND par.extract_id     = pol.extract_id
                 AND invtax.tax_cd      = taxcharg.tax_cd
                 AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                 AND invtax.item_grp = invoice.item_grp
                 AND invtax.tax_cd NOT IN (SELECT param_value_n
                                             FROM giis_parameters
                                           WHERE param_name IN ('EVAT','5% PREMIUM TAX')
                                             AND param_type = 'N')
                 AND 'Y' = (SELECT text
                              FROM giis_document
                             WHERE line_cd='PK'
                               AND report_id ='PACKAGE'
                               AND title='HIDE_PREMIUM_TAX')
            GROUP BY invtax.extract_id,
                     invtax.tax_cd,
                     taxcharg.tax_name,
                     inv.policy_currency
               UNION

            SELECT ALL invtax.extract_id     EXTRACT_ID,
                     3                       INVTAX_TAX_CD,
                     DECODE(inv.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))    INVTAX_TAX_AMT,
                     'VALUE ADDED TAX'         TAXCHARG_TAX_DESC
                FROM GIXX_PACK_INVOICE invoice,
                     GIXX_PACK_INV_TAX invtax,
                     GIAC_TAXES taxcharg,
                     GIXX_PACK_POLBASIC pol,
                     GIXX_PACK_PARLIST par,
                     (SELECT DISTINCT extract_id,policy_currency FROM GIXX_INVOICE WHERE extract_id = p_extract_id) inv
               WHERE 1=1
                 AND invoice.extract_id = invtax.extract_id
                 AND invoice.extract_id = inv.extract_id
                 AND invoice.extract_id = pol.extract_id
                 AND par.extract_id     = pol.extract_id
                 AND invtax.tax_cd      = taxcharg.tax_cd
                 AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                 AND invtax.item_grp = invoice.item_grp
                 AND invtax.tax_cd IN (SELECT param_value_n
                                        FROM giis_parameters
                                       WHERE param_name IN ('EVAT','5% PREMIUM TAX')
                                       AND param_type = 'N')
                 AND 'Y' = (SELECT text
                              FROM giis_document
                            WHERE line_cd='PK'
                              AND report_id ='PACKAGE'
                              AND title='HIDE_PREMIUM_TAX')
            GROUP BY invtax.extract_id,
                     inv.policy_currency
               UNION
              SELECT ALL invtax.extract_id           EXTRACT_ID,
                     invtax.tax_cd                   INVTAX_TAX_CD,
                     DECODE(inv.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))    INVTAX_TAX_AMT,
                     taxcharg.tax_name               TAXCHARG_TAX_DESC
                FROM GIXX_PACK_INVOICE invoice,
                     GIXX_PACK_INV_TAX invtax,
                     GIAC_TAXES taxcharg,
                     GIXX_PACK_POLBASIC pol,
                     GIXX_PACK_PARLIST par,
                     (SELECT DISTINCT extract_id,policy_currency FROM gixx_invoice WHERE extract_id = p_extract_id) inv
               WHERE 1=1
                 AND invoice.extract_id = invtax.extract_id
                 AND invoice.extract_id = inv.extract_id
                 AND invoice.extract_id = pol.extract_id
                 AND par.extract_id     = pol.extract_id
                 AND invtax.tax_cd      = taxcharg.tax_cd
                 AND  DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                 AND invtax.item_grp = invoice.item_grp
                 AND 'N' = (SELECT text
                              FROM giis_document
                             WHERE line_cd='PK'
                              AND report_id ='PACKAGE'
                              AND title='HIDE_PREMIUM_TAX')
            GROUP BY invtax.extract_id,
                     invtax.tax_cd,
                     taxcharg.tax_name,
                     inv.policy_currency);
     

    BEGIN
        FOR i IN taxes
        
        LOOP
            IF NVL(p_co_insurance_sw, 0) <> 2 THEN 
                v_tax_amt := i.invtax_tax_amt;
                                     
            ELSE
               FOR z IN (SELECT co_ri_shr_pct
                          FROM gixx_co_insurer
                        WHERE extract_id= p_extract_id
                          AND co_ri_cd  = giisp.n('CO_INSURER_DEFAULT'))
                                                 
               LOOP
                    v_ri_pct := z.co_ri_shr_pct;
               END LOOP;
                                    
                    v_tax_amt := i.invtax_tax_amt*100/v_ri_pct;
                                    
            END IF;
            
            IF NVL(p_display_neg_amt,'Y') = 'Y' THEN 
                v_tax_amt := v_tax_amt;
            ELSE
                v_tax_amt := ABS(v_tax_amt);
            END IF;
                           
             v_taxes.invtax_tax_amt      :=      v_tax_amt;
             v_taxes.extract_id          :=      i.extract_id;
             v_taxes.invtax_tax_cd       :=      i.invtax_tax_cd;
             v_taxes.taxcharg_tax_desc   :=      i.taxcharg_tax_desc;
             
             PIPE ROW(v_taxes);
         
             
        END LOOP;
        
    END;
    
    FUNCTION get_pack_policy(p_extract_id   GIXX_ITEM.extract_id%TYPE) 
    RETURN pack_policy_tab PIPELINED
    
    IS
        v_policy            pack_policy_type;
    
    BEGIN
        /*FOR i IN (SELECT DISTINCT extract_id,
                                  policy_id, 
                                  pack_line_cd line_cd
                  FROM GIXX_ITEM
                  WHERE extract_id = p_extract_id
                  ORDER BY line_cd, 
                           policy_id) replaced by: Nica 02.25.2013 - to sort according to item_no*/
		
		FOR i IN (SELECT MIN(itm.item_no) item_no,
					     itm.extract_id,
					     itm.policy_id,
					     pol.line_cd line_cd
				    FROM GIXX_ITEM itm,
					     GIXX_POLBASIC pol
				   WHERE itm.extract_id = p_extract_id
				     AND itm.extract_id = pol.extract_id
				     AND itm.policy_id = pol.policy_id
				GROUP BY itm.policy_id, pol.line_cd, itm.extract_id
				ORDER BY item_no)
        LOOP
			v_policy.extract_id             :=  i.extract_id;          
			v_policy.policy_id              :=  i.policy_id;  
			v_policy.line_cd                :=  i.line_cd;  
			v_policy.show_deductible_text   :=  PACK_POLICY_DOCS_PKG.check_deduct_text_display(p_extract_id, i.line_cd, i.policy_id);
			v_policy.show_warr_clause       :=  PACK_POLICY_DOCS_PKG.check_pack_pol_warr_clause(p_extract_id, i.policy_id);     
			v_policy.show_wc_remarks        :=  PACK_POLICY_DOCS_PKG.check_pack_wc_remarks(p_extract_id, i.policy_id);
			v_policy.subreport_id           :=  PACK_POLICY_DOCS_PKG.get_subreport_id(i.line_cd);
			PIPE ROW(v_policy);
        END LOOP;
        
        RETURN;
        
    END get_pack_policy;
    
    FUNCTION check_deduct_text_display(p_extract_id    GIXX_ITEM.extract_id%TYPE,
                                       p_line_cd       GIXX_ITEM.pack_line_cd%TYPE,
                                       p_policy_id     GIXX_ITEM.policy_id%TYPE)
    RETURN VARCHAR2

    IS

        v_show_deductible       VARCHAR2(1);
        v_total                 NUMBER;    
        v_cnt                   NUMBER;
    
    BEGIN
        FOR x in (SELECT COUNT(*) cnt
                   FROM GIXX_DEDUCTIBLES
                   WHERE extract_id = p_extract_id
                     AND policy_id = p_policy_id)       
        LOOP
            v_total := x.cnt;
            EXIT;
        END LOOP;
       
        IF(p_line_cd = GIISP.V('LINE_CODE_FI')) THEN
           FOR y IN (SELECT count(*)cnt
                     FROM GIXX_DEDUCTIBLES
                     WHERE extract_id = p_extract_id
                       AND policy_id = p_policy_id  
                       AND UPPER(deductible_text) IN ('F0') )
           LOOP
            v_cnt := y.cnt;
            EXIT;
           END LOOP;
            
        ELSIF (p_line_cd = GIISP.V('LINE_CODE_MC')) THEN
           FOR y IN (SELECT count(*)cnt
                     FROM GIXX_DEDUCTIBLES
                     WHERE extract_id = p_extract_id
                     AND policy_id = p_policy_id  
                     AND UPPER(deductible_text) IN ('DD0') )
           LOOP
            v_cnt := y.cnt;
            EXIT;
           END LOOP; 
        ELSE
           FOR y IN (SELECT count(*)cnt
                     FROM GIXX_DEDUCTIBLES
                     WHERE extract_id = p_extract_id
                     AND policy_id = p_policy_id  
                     AND UPPER(deductible_text) IN ('ZERO DEDUCTIBLE','NOT APPLICABLE'))
           LOOP
            v_cnt := y.cnt;
            EXIT;
           END LOOP;
        
        END IF;
        
        IF v_total = v_cnt  THEN
              v_show_deductible := 'N';
        ELSE
            v_show_deductible := 'Y';
        END IF;
        
        RETURN(v_show_deductible); 
        
    END check_deduct_text_display;
    
    FUNCTION check_pack_pol_warr_clause (p_extract_id   GIXX_ITEM.extract_id%TYPE,
                                         p_policy_id    GIXX_ITEM.policy_id%TYPE) 

    RETURN VARCHAR2 IS

    v_wc_cd     GIXX_POLWC.wc_cd%type;
    v_wc_title  GIXX_POLWC.wc_title%type;
    v_show      VARCHAR2(1);

    BEGIN    
        FOR X IN (SELECT WC.wc_cd, WC.wc_title
                          FROM GIXX_POLWC WC,
                               GIIS_WARRCLA GWC
                         WHERE GWC.main_wc_cd = wc.wc_cd
                           AND GWC.line_cd = WC.line_cd
                           AND WC.extract_id = p_extract_id
                           AND wc.policy_id = p_policy_id
                         MINUS  
                  SELECT WC.wc_cd,WC.wc_title
                          FROM GIXX_POLWC WC,
                               GIIS_WARRCLA GWC
                         WHERE GWC.main_wc_cd = WC.wc_cd
                           AND GWC.line_cd = WC.line_cd
                           AND WC.EXTRACT_ID = p_extract_id
                        HAVING COUNT(*) = (SELECT COUNT(DISTINCT policy_id) COUNT
                                             FROM GIXX_POLWC WC,
                                                  GIIS_WARRCLA GWC
                                            WHERE GWC.main_wc_cd = WC.wc_cd
                                              AND GWC.line_cd = WC.line_cd
                                              AND WC.extract_id = p_extract_id)
                      GROUP BY wc.extract_id,WC.wc_cd,WC.wc_title,WC.wc_title2)
                      
        LOOP                   
           v_wc_cd := x.wc_cd;
           v_wc_title := x.wc_title;
           exit;
        END LOOP;

        IF v_wc_cd IS NULL AND v_wc_title IS NULL THEN
            v_show := 'N';
        ELSE
            v_show := 'Y';
        END IF;
          
        RETURN v_show;
    END;
    
    FUNCTION check_pack_wc_remarks (p_extract_id   GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id    GIXX_ITEM.policy_id%TYPE) 

    RETURN VARCHAR2 IS

    v_count     NUMBER;
    v_show      VARCHAR2(1);

    BEGIN    
        FOR X IN (SELECT COUNT(wc.wc_remarks) count
                  FROM gixx_polwc wc,
                       giis_warrcla gwc
                 WHERE gwc.main_wc_cd = wc.wc_cd
                   AND gwc.line_cd = wc.line_cd
                   AND wc.wc_remarks IS NOT NULL
                   AND wc.extract_id = p_extract_id
                   AND wc.policy_id =  p_policy_id)
                      
        LOOP                   
               v_count := X.count;
        END LOOP;

        IF v_count <> 0 THEN
            v_show := 'Y';
        ELSE
            v_show := 'N';
        END IF;
          
        RETURN v_show;
    END;
    
    FUNCTION get_subreport_id(p_line_cd       GIXX_ITEM.pack_line_cd%TYPE)
    RETURN VARCHAR2
    IS
        v_subreport_id         VARCHAR2(50);

    BEGIN
            IF p_line_cd = PACK_POLICY_DOCS_PKG.FI THEN
                v_subreport_id := 'FIRE';
            ELSIF p_line_cd = PACK_POLICY_DOCS_PKG.EN THEN
                v_subreport_id := 'ENGINEERING';
            ELSIF p_line_cd = PACK_POLICY_DOCS_PKG.MC THEN
                v_subreport_id := 'MOTORCAR';
            ELSIF p_line_cd = PACK_POLICY_DOCS_PKG.MN THEN
                v_subreport_id := 'MARINE_CARGO';
            ELSIF giis_line_pkg.get_menu_line_cd(p_line_cd) = PACK_POLICY_DOCS_PKG.CA THEN
                v_subreport_id := 'CASUALTY';
            ELSIF p_line_cd = PACK_POLICY_DOCS_PKG.AC THEN
                v_subreport_id := 'ACCIDENT';
            ELSE
                v_subreport_id := 'OTHER';
            END IF;
            
            RETURN(v_subreport_id);
    END;
END;
/


