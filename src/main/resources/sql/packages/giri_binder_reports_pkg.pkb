CREATE OR REPLACE PACKAGE BODY CPI.GIRI_BINDER_REPORTS_PKG AS
    
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 29, 2011
**  Reference By  : GIRIR001 - Reinsurance Binder report
**  Description   : Function returns details and parameters needed for GIRIR001 
*/

/*
**  Modified by    : Gelo J. Paragas
**  Date Created  : June 19, 2013
**  Reference By  : GIRIR001 - Reinsurance Binder report
**  Description   : Added consideration for parameter 'BINDER_TITLE_TWO_LINES'.
*/
    
    FUNCTION get_giri_binder_report_details(p_line_cd          GIRI_BINDER.line_cd%TYPE,
                                            p_binder_yy        GIRI_BINDER.binder_yy%TYPE,
                                            p_binder_seq_no    GIRI_BINDER.binder_seq_no%TYPE,
                                            p_report_id        GIIS_REPORTS.REPORT_ID%TYPE)
                                            
    RETURN giri_binder_report_tab PIPELINED AS
    
    v_report         giri_binder_report_type;
    v_return         VARCHAR2(1) := 'N';
    v_remarks        VARCHAR2(4400);
    
    CURSOR main IS
           SELECT DISTINCT UPPER(A150.line_name) line_name
                   --, NVL(A150.menu_line_cd, '*') menu_line_cd
                   , A150.menu_line_cd 
                   ,DECODE(TRIM(gd.text),
                           'Y','FACULTATIVE REINSURANCE '||chr(10)||'BINDER NUMBER ' || D0107.line_cd || '-' || LTRIM(TO_CHAR(D0107.binder_yy,'09')) || '-'  || LTRIM(TO_CHAR(D0107.binder_seq_no,'09999'))                 --Modified by Gelo 6.19.2013
                           ,'FACULTATIVE REINSURANCE BINDER NUMBER ' || D0107.line_cd || '-' || LTRIM(TO_CHAR(D0107.binder_yy,'09')) || '-'  || LTRIM(TO_CHAR(D0107.binder_seq_no,'09999')) )BINDER_NO                      --Considered value of parameter
                   ,DECODE(TRIM(gd.text),                                                                                                                                                                                   --'BINDER_TITLE_TWO_LINES'                               
                           'Y','FACULTATIVE REINSURANCE ALTERATION '||chr(10)||'BINDER NUMBER ' || D0107.line_cd || '-' || LTRIM(TO_CHAR(D0107.binder_yy,'09')) || '-'  || LTRIM(TO_CHAR(D0107.binder_seq_no,'09999'))      --for printing of binder title.
                           ,'FACULTATIVE REINSURANCE ALTERATION BINDER NUMBER ' || D0107.line_cd || '-' || LTRIM(TO_CHAR(D0107.binder_yy,'09')) || '-'  || LTRIM(TO_CHAR(D0107.binder_seq_no,'09999')) )BINDER_NUMBER        
                   ,C100.short_name||' '||LTRIM(TO_CHAR(DECODE(D0107.ri_tsi_amt,0.01,0,D0107.ri_tsi_amt),'99,999,999,999,990.99')) || '  (' || LTRIM(DECODE(D0107.ri_tsi_amt,0.01,TO_CHAR(0.00,'990.9999'),TO_CHAR(D0107.ri_shr_pct,'990.9999')))|| '%)'   your_share
                   ,NVL(D0107.prem_tax,0) prem_tax
                   ,D0107.binder_date binder_date
                   ,A18011.ri_name ri_name
                   ,A18011.bill_address1 bill_address1
                   ,A18011.bill_address2 bill_address2
                   ,A18011.bill_address3 bill_address3
                   ,NVL(NVL(D0107.attention, A18011.attention),'REINSURANCE DEPARTMENT') attention
                   ,DECODE(B240.par_type,'E',B240.assd_no, B2504.assd_no) assd_no
                   ,B2504.line_cd || '-' || B2504.subline_cd || '-' || B2504.iss_cd || '-' ||  LTRIM(TO_CHAR(B2504.issue_yy,'09')) || '-' || LTRIM(TO_CHAR(B2504.pol_seq_no,'0999999'))|| '-' || LTRIM(TO_CHAR(b2504.renew_no,'09'))||DECODE(b2504.ref_pol_no,NULL,'',' / '||b2504.ref_pol_no) policy_no
                   ,D06010.loc_voy_unit
                   ,B2504.endt_iss_cd || '-' || LTRIM(TO_CHAR(B2504.endt_yy,'09')) || '-' || LTRIM(TO_CHAR(B2504.endt_seq_no,'099999')) endt_no
                   ,DECODE(B2504.incept_tag, 'Y', 'TBA', TO_CHAR(/*B2504.eff_date*/D0107.eff_date, 'Mon. DD, YYYY')) || ' to '  || DECODE(B2504.expiry_tag, 'Y', 'TBA', NVL(TO_CHAR(/*B2504.endt_expiry_date*/D0107.expiry_date, 'Mon. DD, YYYY'),TO_CHAR(/*B2504.EXPIRY_DATE*/D0107.expiry_date, 'Mon. DD, YYYY')))  ri_term --edgar 10/15/2014 changed source of dates from gipi_polbasic to giri_binder
                   ,C100.short_name || ' ' || LTRIM(TO_CHAR(DECODE(D06010.tsi_amt,0.01,0,D06010.tsi_amt),'99,999,999,999,990.99')) sum_insured
                   ,D0107.confirm_no
                   ,D0107.confirm_date
                   ,LTRIM(TO_CHAR(D06010.dist_no,'09999999')) || '-' || LTRIM(TO_CHAR(D06010.dist_seq_no,'09999')) DS_NO
                   ,D06010.dist_no dist_no
                   ,D06010.dist_seq_no dist_seq_no
                   ,LTRIM(TO_CHAR(D06010.frps_yy,'09')) || '-' || LTRIM(TO_CHAR(D06010.frps_seq_no,'099999')) || '/' || LTRIM(TO_CHAR(D06010.op_group_no,'099999')) FRPS_NO
                   ,D0809.remarks
                   ,D0809.bndr_remarks1
                   ,D0809.bndr_remarks2
                   ,D0809.bndr_remarks3
                   ,D0809.ri_accept_by
                   ,D0809.ri_as_no
                   ,D0809.ri_accept_date
                   ,D0107.fnl_binder_id fnl_binder_id
                   ,B2504.policy_id
                   ,B2504.par_id
                   ,B2504.endt_seq_no
                   ,B2504.endt_yy
                   ,B2504.endt_iss_cd
                   ,B2504.subline_cd
                   ,B2504.line_cd line_cd
                   ,B2504.iss_cd
                   ,D0809.line_cd line_cd_1
                   ,D0809.frps_yy
                   ,D0809.frps_seq_no
                   ,D0809.reverse_sw
                   ,D0107.reverse_date
                   ,D0809.other_charges other_charges
                   ,A18011.ri_cd
                   --,'* '||B2504.user_id||' *' user_id
                   ,'* '||D0107.user_id||' *' user_id
                   ,A18011.local_foreign_sw
                   ,C100.short_name, B2504.renew_no, B2504.pol_flag
            FROM    GIRI_BINDER D0107
                   ,GIIS_REINSURER A18011
                   ,GIIS_LINE A150
                   ,GIRI_FRPS_RI D0809
                   ,GIRI_DISTFRPS D06010
                   ,GIUW_POL_DIST C0803
                   ,GIPI_POLBASIC B2504
                   ,GIIS_CURRENCY C100
                   ,GIPI_PARLIST B240
                   ,GIIS_DOCUMENT GD
            WHERE B240.par_id = B2504.par_id
            AND   A18011.ri_cd = D0107.ri_cd
            AND   D0107.line_cd = A150.line_cd
            AND   D06010.frps_seq_no = D0809.frps_seq_no
            AND   C0803.dist_no = D06010.dist_no
            AND   B2504.policy_id = C0803.policy_id
            AND   D06010.currency_cd = C100.main_currency_cd
            AND   D06010.line_cd = D0809.line_cd
            AND   D06010.frps_yy = D0809.frps_yy
            AND   D0107.fnl_binder_id = D0809.fnl_binder_id
--            AND   D06010.ri_flag != 4 -- apollo cruz 08.12.2015 - SR#19929 - merging of binder reports
            AND   D0107.line_cd = p_line_cd
            AND   D0107.binder_yy = TO_NUMBER(p_binder_yy)
            AND   D0107.binder_seq_no = TO_NUMBER(p_binder_seq_no)
            AND   GD.title = TRIM('BINDER_TITLE_TWO_LINES')
            AND   d06010.frps_seq_no =
                     (SELECT MAX (b.frps_seq_no)
                        FROM giri_binder a, giri_frps_ri b
                       WHERE a.fnl_binder_id = b.fnl_binder_id
                         AND a.line_cd = p_line_cd
                         AND a.binder_yy = p_binder_yy
                         AND a.binder_seq_no = p_binder_seq_no); -- apollo cruz 08.12.2015 - SR#19929 - merging of binder reports
    
    BEGIN
        FOR i IN main
        LOOP
            v_report.line_name           := i.line_name;
            v_report.menu_line_cd        := i.menu_line_cd;
            v_report.binder_no           := i.binder_no; 
            v_report.binder_number       := i.binder_number; 
            v_report.your_share          := i.your_share; 
            v_report.prem_tax            := i.prem_tax;
            v_report.binder_date         := i.binder_date;
            v_report.ri_name             := i.ri_name; 
            v_report.bill_address1       := i.bill_address1; 
            v_report.bill_address2       := i.bill_address2; 
            v_report.bill_address3       := i.bill_address3; 
            v_report.attention           := i.attention; 
            v_report.assd_no             := i.assd_no;
            v_report.assd_name           := GIIS_ASSURED_PKG.get_assd_name(i.assd_no);
            v_report.policy_no           := i.policy_no; 
            v_report.loc_voy_unit        := i.loc_voy_unit;
            v_report.endt_no             := i.endt_no; 
            v_report.ri_term             := i.ri_term; 
            v_report.sum_insured         := i.sum_insured;  
            v_report.confirm_no          := i.confirm_no; 
            v_report.confirm_date        := i.confirm_date; 
            v_report.ds_no               := i.ds_no; 
            v_report.dist_no             := i.dist_no; 
            v_report.dist_seq_no         := i.dist_seq_no; 
            v_report.frps_no             := i.frps_no; 
            v_report.remarks             := i.remarks; 
            v_report.bndr_remarks1       := i.bndr_remarks1; 
            v_report.bndr_remarks2       := i.bndr_remarks2; 
            v_report.bndr_remarks3       := i.bndr_remarks3; 
            v_report.ri_accept_by        := i.ri_accept_by; 
            v_report.ri_as_no            := i.ri_as_no; 
            v_report.ri_accept_date      := i.ri_accept_date; 
            v_report.fnl_binder_id       := i.fnl_binder_id; 
            v_report.policy_id           := i.policy_id; 
            v_report.par_id              := i.par_id; 
            v_report.endt_seq_no         := i.endt_seq_no; 
            v_report.endt_yy             := i.endt_yy;
            v_report.endt_iss_cd         := i.endt_iss_cd; 
            v_report.subline_cd          := i.subline_cd;
            v_report.subline_name        := GIIS_SUBLINE_PKG.get_subline_name2(i.line_cd, i.subline_cd); 
            v_report.line_cd             := i.line_cd; 
            v_report.iss_cd              := i.iss_cd; 
            v_report.line_cd_1           := i.line_cd_1; 
            v_report.frps_yy             := i.frps_yy;
            v_report.frps_seq_no         := i.frps_seq_no; 
            v_report.reverse_sw          := i.reverse_sw; 
            v_report.reverse_date        := i.reverse_date; 
            v_report.other_charges       := i.other_charges; 
            v_report.ri_cd               := i.ri_cd;
            v_report.user_id             := i.user_id; 
            v_report.local_foreign_sw    := i.local_foreign_sw; 
            v_report.short_name          := i.short_name;
            v_report.pol_flag            := i.pol_flag;
            
            -- bonok :: 10.15.2014
            IF v_report.remarks IS NOT NULL THEN
               IF v_report.bndr_remarks1 IS NOT NULL OR v_report.bndr_remarks2 IS NOT NULL OR v_report.bndr_remarks3 IS NOT NULL THEN
                  v_remarks := v_report.remarks || CHR(10);
               ELSE
                  v_remarks := v_report.remarks;
               END IF;
            END IF;
            
            IF v_report.bndr_remarks1 IS NOT NULL THEN
               IF v_report.bndr_remarks2 IS NOT NULL OR v_report.bndr_remarks3 IS NOT NULL THEN
                  v_remarks := v_remarks || v_report.bndr_remarks1 || CHR(10);
               ELSE
                  v_remarks := v_remarks || v_report.bndr_remarks1;
               END IF;
            END IF;

            IF v_report.bndr_remarks2 IS NOT NULL THEN
               IF v_report.bndr_remarks3 IS NOT NULL THEN
                  v_remarks := v_remarks || v_report.bndr_remarks2 || CHR(10);
               ELSE
                  v_remarks := v_remarks || v_report.bndr_remarks2;
               END IF;
            END IF;
            
            IF v_report.bndr_remarks3 IS NOT NULL THEN
               v_remarks := v_remarks || v_report.bndr_remarks3;
            END IF;
            
            v_report.remarks := v_remarks;
            
            v_return := 'Y';
            
        END LOOP;
        
        IF giisp.v('PRINT_BNDR_USER') = 'N' THEN
            v_report.user_id := NULL;
        END IF; 
            
        /*checks if the main query has record*/
        IF v_return = 'Y' THEN
            initialize_report_variables(p_report_id);
        ELSE
            RETURN;
        END IF;
        
        
        /*for cf_property*/
        DECLARE

          v_dist_seq_no         NUMBER(5);
          v_seq_count           NUMBER(2):=0;
          v_item_count          NUMBER(2):=0;
          v_property            VARCHAR2(100);

        BEGIN

        IF  NVL(v_report.menu_line_cd, v_report.line_cd) = 'CA' AND  v_report.subline_cd = NVL(giisp.v('CA_SUBLINE_MSP'), 'MSP') THEN -- apollo cruz 08.12.2015 - SR#19929 - line and subline must not be hardcoded, menu_line_cd must be checked first.
              v_property := 'MSPR';
        ELSE
              
          SELECT COUNT(dist_seq_no)
            INTO v_seq_count
            FROM GIUW_POLICYDS
           WHERE dist_no =  v_report.dist_no;

             IF v_seq_count = 1 THEN
                FOR A IN (SELECT property
                              FROM GIPI_INVOICE
                              WHERE policy_id =  v_report.policy_id) 
                LOOP
                   v_property := A.property;
                END LOOP;

           
             ELSE
               SELECT COUNT(item_no)
                 INTO v_item_count
                 FROM GIUW_ITEMDS
                WHERE dist_no =  v_report.dist_no
                  AND dist_seq_no =  v_report.dist_seq_no;
                        
               IF v_item_count = 1 THEN
                  FOR C IN (                            
                    SELECT item_no                      
                      FROM giuw_itemds                  
                     WHERE dist_no =  v_report.dist_no
                       AND dist_seq_no =  v_report.dist_seq_no)
                  LOOP
                       FOR B IN (SELECT item_title
                              FROM GIPI_ITEM
                             WHERE policy_id =  v_report.policy_id
                               AND item_no = c.item_no) 
                       LOOP
                            v_property := B.item_title;
                            EXIT;
                       END LOOP; 
                  END LOOP;   
               ELSE
                    v_property := 'Various Items';               
               END IF;
             END IF;
        END IF;
           v_report.cf_property := v_property;
        END;
        /*end of cf_property*/
        
        /* for mop number */
        
        DECLARE
            mop     VARCHAR2(100);
        BEGIN
            FOR C IN (SELECT T1.line_cd || '-' || LTRIM(T1.op_subline_cd) || '-' ||
                     LTRIM(T1.op_iss_cd) || '-' || LTRIM(TO_CHAR(T1.op_issue_yy,'09'))
                     || '-' || LTRIM(TO_CHAR(T1.op_pol_seqno,'0999999'))||DECODE(T2.ref_pol_no,NULL,'',' / '||T2.ref_pol_no) policy_no
                     FROM GIPI_OPEN_POLICY T1, GIPI_POLBASIC T2
                     WHERE T2.policy_id = v_report.policy_id
                     AND T1.policy_id = T2.policy_id) 
            LOOP
                mop := C.policy_no;
            END LOOP;
            
            v_report.mop_number := mop;       
        END;
        
        /* for sailing date*/
        DECLARE
            v_show_sailing_date     VARCHAR2(1) := 'N';
            v_sailing_date          VARCHAR2(100);
            v_print_etd             giis_document.text%TYPE;
        BEGIN
            
            IF NVL(v_report.menu_line_cd, v_report.line_cd) ='MN' THEN -- apollo cruz 08.12.2015 - SR#19929 - line and subline must not be hardcoded, menu_line_cd must be checked first.     
     
                BEGIN
                   SELECT text
                     INTO v_print_etd
                     FROM giis_document
                    WHERE report_id = 'GIRIR001'
                      AND title = 'PRINT_ETD';
                EXCEPTION WHEN NO_DATA_FOUND THEN
                   v_print_etd := 'N';        
                END;
                
                IF /*giisp.v('PRINT_ETD')*/ v_print_etd = 'Y' THEN -- apollo cruz 08.12.2015 - SR#19929 transfered print_etd param from giis_parameters to giis_documents
                    
                    v_show_sailing_date := 'Y';
                    
                    FOR a IN (SELECT a.etd -- apollo cruz 08.12.2015 - SR#19929 item must be checked in giuw_itemds
                              FROM gipi_cargo a, giuw_itemds b
                              WHERE a.policy_id = v_report.policy_id
                                AND a.item_no = b.item_no
                                AND b.dist_no = v_report.dist_no
                                AND b.dist_seq_no = v_report.dist_seq_no                                
                           ORDER BY a.item_no
                              ) 
                    LOOP
                        v_sailing_date := TO_CHAR(a.etd,'Mon. DD, YYYY');
                        EXIT;
                    END LOOP;
                       
                END IF;
            
            ELSE
                v_show_sailing_date := 'N';
            END IF;
            
            v_report.show_sailing_date := v_show_sailing_date;
            v_report.sailing_date := v_sailing_date;
        END;
        /* end of sailing date*/
        
        /* for vat_title and prem_tax_title */
        DECLARE
            v_count1                NUMBER    := 0;
            v_count2                NUMBER    := 0;
            v_vat_title             GIIS_PARAMETERS.param_value_v%TYPE;
            v_prem_tax_title        GIIS_PARAMETERS.param_value_v%TYPE;

        BEGIN
            
            SELECT COUNT(*) INTO v_count1 
                FROM giis_parameters 
             WHERE param_name = 'VAT_TITLE';

            SELECT COUNT(*) INTO v_count2 
                FROM giis_parameters 
             WHERE param_name = 'PREM_TAX_TITLE';

            IF v_count1 != 0 THEN
              SELECT nvl(param_value_v, 'VAT') INTO v_vat_title
                  FROM GIIS_PARAMETERS
               WHERE param_name = 'VAT_TITLE' AND ROWNUM = 1;
            ELSE
                v_vat_title    := 'VAT';
            END IF;
            
            IF v_count2 != 0 THEN 
              SELECT NVL(param_value_v, 'PREM TAX') INTO v_prem_tax_title
                  FROM GIIS_PARAMETERS
               WHERE param_name = 'PREM_TAX_TITLE' AND ROWNUM = 1;
            ELSE
                v_prem_tax_title    := 'PREM TAX';
            END IF;
            
            v_report.vat_title      := v_vat_title;
            v_report.prem_tax_title := v_prem_tax_title;
            
        END;
        
        /* for showing vat and witholding vat*/
        DECLARE
            v_display_comm_inclusive_vat giis_document.text%type := 'N';
            v_foreign_sw giis_reinsurer.local_foreign_sw%type;
 
        BEGIN
            
            -- apollo cruz 08.12.2015 - SR#19929 transfered dislay_comm_inclusive_vat from giis_parameters to giis_document
            /*FOR a IN ( SELECT param_value_v
                       FROM giac_parameters
                       WHERE param_name = 'COMM_INCLUSIVE_VAT')
            LOOP
                v_param := a.param_value_v;
            END LOOP;*/
            
            -- apollo cruz 09.01.2015 sr#19929
            -- as per ma'am jhing, show_vat should only be based on DISPLAY_COMM_INCLUSIVE_VAT in giis_document
            BEGIN
               SELECT text
                 INTO v_display_comm_inclusive_vat
                 FROM giis_document
                WHERE title = 'DISPLAY_COMM_INCLUSIVE_VAT'
                  AND report_id = 'GIRIR001';
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_display_comm_inclusive_vat := 'N';                     
            END;
            
            IF v_display_comm_inclusive_vat = 'Y' THEN
               v_report.show_vat := 'N';
            ELSE
               v_report.show_vat := 'Y';
            END IF;   

            FOR b IN (SELECT local_foreign_sw
                      FROM GIIS_REINSURER
                      WHERE ri_cd = v_report.ri_cd)
            LOOP
                v_foreign_sw := b.local_foreign_sw;
            exit;
            END LOOP;       

--            IF v_display_comm_inclusive_vat = 'Y' AND v_foreign_sw != 'L' THEN    
--                v_report.show_vat := 'N';
--            ELSE
--                v_report.show_vat := 'Y';         
--            END IF;
            
            -- apollo cruz 09.01.2015 sr#19929
            -- as per ma'am jhing, show_whold_vat must be only set to Y if RI is foreign 
            IF /*v_display_comm_inclusive_vat = 'Y' OR */v_foreign_sw = 'L' THEN    
                v_report.show_whold_vat := 'N';
            ELSE
                v_report.show_whold_vat := 'Y';         
            END IF;
            
        END;
        
        /*for showing of tax*/
        
        IF v_report.local_foreign_sw != 'L' AND v_report.prem_tax > 0 THEN
            v_report.show_tax := 'Y'; 
        ELSE
            v_report.show_tax := 'N';
        END IF;
        
        /* for showing of binder_as_no*/
        DECLARE
        v_show     giis_parameters.param_value_v%TYPE;

        BEGIN
            
          FOR A IN (SELECT param_value_v
                      FROM giis_parameters
                     WHERE param_name = 'BINDER_AS_NO')
                       
          LOOP
            v_show := A.param_value_v;
          END LOOP;
          
          IF v_show = 'Y' THEN
            v_report.show_binder_as_no := 'Y';
          ELSE
            v_report.show_binder_as_no := 'N';
          END IF;   
        
        END;
        
        /* for company name */
        DECLARE
         company_nm        giis_parameters.param_value_v%TYPE;

        BEGIN
          FOR name_rec IN (
              SELECT UPPER(param_value_v) param_value_v
                     FROM giis_parameters
                     WHERE param_name = 'COMPANY_NAME')
          LOOP
              company_nm := name_rec.param_value_v;
          EXIT;
          END LOOP;
          
            v_report.company_name := company_nm;
        END;
        
        /* for signatories */
      
        DECLARE
            v_signatories                 GIIS_SIGNATORY_NAMES.file_name%TYPE;
            v_designation                 GIIS_SIGNATORY_NAMES.designation%TYPE;
            v_signatory                   GIIS_SIGNATORY_NAMES.signatory%TYPE;
        
        BEGIN
            FOR sig IN (SELECT file_name filename, designation designation, signatory signatory 
                        FROM giis_signatory_names
                        WHERE signatory_id IN (SELECT signatory_id
                                               FROM giis_signatory
                                               WHERE report_id = p_report_id
                                               AND NVL(line_cd, v_report.line_cd) = v_report.line_cd 
                                               AND NVL(iss_cd, v_report.iss_cd)  =  v_report.iss_cd 
                                               AND NVL(current_signatory_sw, 'Y') = 'Y') -- apollo cruz 08.12.2015 - SR#19929 - as per ma'am jhing, this condition must be added
                        AND ROWNUM = 1)
            LOOP
                v_signatories := sig.filename;
                v_designation := sig.designation;
                v_signatory   := sig.signatory;
            END LOOP;
            
            v_report.signatories := v_signatories;
            v_report.designation := v_designation;
            v_report.signatory   := v_signatory;
        END;
        
        
        DECLARE
            v_signatory_label             GIAC_REP_SIGNATORY.label%TYPE;
        BEGIN
            FOR lbl IN (SELECT label
                        FROM giac_rep_signatory
                        WHERE report_id = p_report_id
                        AND signatory_id IN (SELECT signatory_id
                                            FROM giis_signatory
                                            WHERE report_id = p_report_id
                                            AND NVL(line_cd, v_report.line_cd) = v_report.line_cd 
                                            AND NVL(iss_cd, v_report.iss_cd)  =  v_report.iss_cd
                                            AND NVL(current_signatory_sw, 'Y') = 'Y') -- apollo cruz 08.12.2015 - SR#19929 - as per ma'am jhing, this condition must be added
                        AND ROWNUM = 1)
            LOOP
                v_signatory_label := lbl.label;
            END LOOP;
             
            v_report.signatory_label := v_signatory_label;
        END;
        
        /*end of signatories*/
        
        /*report_variables*/
        
        v_report.rv_binder_line                 :=  GIRI_BINDER_REPORTS_PKG.binder_line;
        v_report.rv_binder_note                 :=  GIRI_BINDER_REPORTS_PKG.binder_note;
        --v_report.rv_binder_hdr                  :=  GIRI_BINDER_REPORTS_PKG.binder_hdr;
        v_report.rv_binder_ftr                  :=  GIRI_BINDER_REPORTS_PKG.binder_ftr;
        v_report.rv_binder_for                  :=  GIRI_BINDER_REPORTS_PKG.binder_for;
        v_report.rv_binder_confirmation         :=  GIRI_BINDER_REPORTS_PKG.binder_confirmation;     
        v_report.rv_frps_ret                    :=  GIRI_BINDER_REPORTS_PKG.frps_ret;     
        v_report.rv_user_id                        :=  GIRI_BINDER_REPORTS_PKG.user_id;    
        v_report.rv_hide                        :=  GIRI_BINDER_REPORTS_PKG.hide;
        v_report.rv_addressee                   :=  GIRI_BINDER_REPORTS_PKG.addressee;
        v_report.rv_addressee_confirmation      :=  GIRI_BINDER_REPORTS_PKG.addressee_confirmation;
        v_report.rv_print_line_name             :=  GIRI_BINDER_REPORTS_PKG.print_line_name;
        v_report.rv_print_auth_sig_above        :=  NVL(GIRI_BINDER_REPORTS_PKG.print_auth_sig_above,'Y'); --added nvl by robert 02.09.15        
        v_report.rv_print_sig_refdate_across    :=  GIRI_BINDER_REPORTS_PKG.print_sig_refdate_across;
        
        IF v_report.endt_seq_no <> 0 THEN
            v_report.rv_binder_hdr := GIRI_BINDER_REPORTS_PKG.binder_hdr_endt;
        --ELSIF v_report.pol_flag = 2 AND v_report.endt_seq_no = 0 THEN
        ELSIF v_report.pol_flag = '2' AND v_report.endt_seq_no = 0 THEN -- bonok :: 7.22.2015 :: UCPB SR 19886
            v_report.rv_binder_hdr := GIRI_BINDER_REPORTS_PKG.binder_hdr_ren;
        ELSE
            v_report.rv_binder_hdr :=  GIRI_BINDER_REPORTS_PKG.binder_hdr;
        END IF;
        
        /*end of report variables*/ 
        
        v_report.cf_class           := v_report.line_name || ' - ' || v_report.subline_name;
        v_report.cf_for             := v_report.rv_binder_for || ' ' || v_report.ri_name;       
        
        PIPE ROW(v_report);
    
    END get_giri_binder_report_details;
    
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 30, 2011
**  Reference By  : GIRIR001 - Reinsurance Binder report
**  Description   : Assign/Initialize values of parameters needed for GIPIR001 
*/
    
     PROCEDURE initialize_report_variables (p_report_id   GIIS_REPORTS.REPORT_ID%TYPE) IS
     
     BEGIN
        
        FOR report IN (SELECT UPPER(title) title, text text 
                  FROM GIIS_DOCUMENT    
                 WHERE report_id = p_report_id)
        LOOP
          IF report.title = 'BINDER_LINE' THEN
                GIRI_BINDER_REPORTS_PKG.binder_line := report.text;
          END IF;
          IF report.title = 'BINDER_NOTE' THEN
                GIRI_BINDER_REPORTS_PKG.binder_note := report.text;
          END IF;
          IF report.title = 'BINDER_HDR' THEN
                GIRI_BINDER_REPORTS_PKG.binder_hdr := report.text;
          END IF;
          IF report.title = 'BINDER_FTR' THEN
                GIRI_BINDER_REPORTS_PKG.binder_ftr := report.text;
          END IF;
          IF report.title = 'BINDER_FOR' THEN
                GIRI_BINDER_REPORTS_PKG.binder_for := report.text;
          END IF;
          IF report.title = 'BINDER_CONFIRMATION' THEN
                GIRI_BINDER_REPORTS_PKG.binder_confirmation := NVL(report.text, CHR(32));
          END IF;      
          IF report.title = 'FRPS_RET' THEN
                GIRI_BINDER_REPORTS_PKG.frps_ret := report.text;
          END IF;       
          IF report.title = 'USER_ID' THEN
                GIRI_BINDER_REPORTS_PKG.user_id := report.text;
          END IF;  
          IF report.title = 'HIDE' THEN
                GIRI_BINDER_REPORTS_PKG.hide := report.text;
          END IF;
          IF report.title = 'PRINT_LINE_NAME' THEN
                GIRI_BINDER_REPORTS_PKG.print_line_name := report.text;
          END IF;
          IF report.title = 'ADDRESSEE' THEN
                GIRI_BINDER_REPORTS_PKG.addressee := NVL(report.text, 'NO HEADING');
          END IF;
          IF report.title = 'ADDRESSEE_CONFIRMATION' THEN
                GIRI_BINDER_REPORTS_PKG.addressee_confirmation := NVL(report.text, 'NO HEADING');
          END IF;
          IF report.title = 'PRINT_AUTHORIZED_SIGNATURE_ABOVE' THEN
                GIRI_BINDER_REPORTS_PKG.print_auth_sig_above := report.text;
          END IF;
          IF report.title = 'PRINT_SIGNATURE_REF_DATE_ACROSS' THEN
                GIRI_BINDER_REPORTS_PKG.print_sig_refdate_across := report.text;
          END IF;
          IF report.title = 'BINDER_HDR_ENDT' THEN
                GIRI_BINDER_REPORTS_PKG.binder_hdr_endt := report.text;
          END IF;
          IF report.title = 'BINDER_HDR_REN' THEN
                GIRI_BINDER_REPORTS_PKG.binder_hdr_ren := report.text;
          END IF;
            
        END LOOP;
        
     END initialize_report_variables;
     
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : July 1, 2011
**  Reference By  : GIRIR001 - Reinsurance Binder report
**  Description   : Function returns details of binder perils.
*/
     
      FUNCTION get_giri_binder_report_perils (p_fnl_binder_id     GIRI_BINDER_PERIL.fnl_binder_id%TYPE,
                                              p_line_cd           GIRI_FRPS_RI.line_cd%TYPE,
                                              p_frps_yy           GIRI_FRPS_RI.frps_yy%TYPE,
                                              p_frps_seq_no       GIRI_FRPS_RI.frps_seq_no%TYPE,
                                              p_reverse_sw        GIRI_FRPS_RI.reverse_sw%TYPE, 
                                              p_reverse_date      GIRI_BINDER.reverse_date%TYPE,
                                              p_ri_cd               GIIS_REINSURER.ri_cd%TYPE)
                                            
     RETURN giri_binder_report_peril_tab PIPELINED IS
     
     v_ri_peril     giri_binder_report_peril_type;
     -- jhing REPUBLICFULLWEB 21773
     v_display_zero_prem_peril giis_document.text%TYPE  := 'Y' ; 
     v_cnt_printPeril   NUMBER := 0 ; 
     
     BEGIN
        -- jhing 03.30.2016  query parameter to display peril with zero premium REPUBLICFULLWEB 21773 
        FOR txt IN (  SELECT a.text
                          FROM giis_document a
                         WHERE     NVL (line_cd, '@@@@@@@') = p_line_cd
                               AND report_id = 'GIRIR001'
                               AND a.title = 'DISPLAY_ZERO_PREM_PERIL'
                        UNION
                        SELECT a.text
                          FROM giis_document a
                         WHERE     a.line_cd IS NULL
                               AND a.report_id = 'GIRIR001'
                               AND a.title = 'DISPLAY_ZERO_PREM_PERIL'
                               AND NOT EXISTS
                                          (SELECT 1
                                             FROM giis_document c
                                            WHERE     c.report_id = a.report_id
                                                  AND c.title = a.title
                                                  AND c.line_cd = p_line_cd))
        LOOP
            v_display_zero_prem_peril := txt.text; 
            EXIT;
        END LOOP;
        
        FOR peril IN(SELECT SUM(NVL(T4.prem_amt,0)) gross_prem 
                           ,SUM(NVL(T1.ri_prem_amt,0)) ri_prem_amt 
                           ,AVG(NVL(T1.ri_comm_rt,0)) ri_comm_rt 
                           ,SUM(NVL(T1.ri_comm_amt,0))  ri_comm_amt 
                           ,SUM(NVL(T1.ri_prem_amt,0) - NVL(t1.ri_comm_amt,0)) less_ri_comm_amt 
                           ,T1.fnl_binder_id fnl_binder_id 
                           ,T3.line_cd 
                           ,T3.frps_yy 
                           ,T3.frps_seq_no 
                           ,T4.peril_title 
                           ,NVL(T2.ri_prem_vat,0)  ri_prem_vat
                           ,nvl(T2.ri_comm_vat,0) ri_comm_vat
                           ,nvl(T1.ri_comm_vat,0) peril_comm_vat 
                           ,T5.sequence v_sequence 
                           ,NVL(T5.prt_flag,99) prt_flag 
                           ,(NVL(T2.ri_wholding_vat,0)*(-1)) ri_wholding_vat 
                    FROM    GIRI_BINDER_PERIL T1 
                           ,GIRI_BINDER T2 
                           ,GIRI_FRPS_RI T3 
                           ,GIRI_FRPS_PERIL_GRP T4 
                           ,GIIS_PERIL T5 
                    WHERE T1.fnl_binder_id = T2.fnl_binder_id 
                      AND T2.fnl_binder_id = T3.fnl_binder_id 
                      AND T3.line_cd       = T4.line_cd 
                      AND T3.frps_yy       = T4.frps_yy 
                      AND T3.frps_seq_no   = T4.frps_seq_no 
                      AND T1.peril_seq_no  = T4.peril_seq_no 
                      AND T5.line_cd       = T4.line_cd 
                      AND T5.peril_cd      = T4.peril_cd
                      AND T1.fnl_binder_id = p_fnl_binder_id
                      AND T3.line_cd       = p_line_cd
                      AND T3.frps_yy       = p_frps_yy
                      AND T3.frps_seq_no   = p_frps_seq_no 
                    GROUP BY T1.fnl_binder_id, 
                             T3.line_cd, 
                             T3.frps_yy, 
                             T3.frps_seq_no,
                             T4.peril_cd,
                             T4.peril_title,
                             T2.ri_prem_vat,
                             T2.ri_comm_vat, 
                             T2.ri_wholding_vat,
                             T1.ri_comm_vat,
                             T5.SEQUENCE,
                             NVL(T5.prt_flag,99) 
                    ORDER BY NVL(T5.prt_flag,99)
                            ,T5.sequence)
        LOOP
            
            IF p_reverse_sw = 'Y' OR p_reverse_date IS NOT NULL THEN
                v_ri_peril.gross_prem       := peril.gross_prem * (-1);
                v_ri_peril.ri_prem_amt      := peril.ri_prem_amt * (-1);
                v_ri_peril.ri_prem_vat      := peril.ri_prem_vat * (-1);
                v_ri_peril.less_comm_vat    := (NVL(peril.ri_prem_vat,0) - NVL(peril.ri_comm_vat,0)) * (-1);
            ELSE
                v_ri_peril.gross_prem       := peril.gross_prem;
                v_ri_peril.ri_prem_amt      := peril.ri_prem_amt;
                v_ri_peril.ri_prem_vat      := peril.ri_prem_vat;
                v_ri_peril.less_comm_vat    := NVL(peril.ri_prem_vat,0) - NVL(peril.ri_comm_vat,0);
            END IF;
            
            -- apollo cruz 09.01.2015 sr#19929
            -- modified computations based on ma'am jhing's instruction
            /*for ri_comm_amt and lcomm_amt*/
            DECLARE
              v_ri_comm_amt         NUMBER(16,2) := 0;
              v_lcomm_amt            NUMBER(16,2) := 0;
              v_comm_vat            NUMBER(16,2) := 0;
--              v_param               VARCHAR2(500);
              v_foreign_sw          VARCHAR2(1);
              v_com_vat             NUMBER(16,2);
              v_display_comm_inclusive_vat giis_document.text%TYPE;
            BEGIN
               
               /*FOR A IN ( SELECT param_value_v
                            FROM giac_parameters
                           WHERE param_name = 'COMM_INCLUSIVE_VAT')
               LOOP
                   v_param := a.param_value_v;
               END LOOP;*/
             
               BEGIN
                  SELECT text
                    INTO v_display_comm_inclusive_vat
                    FROM giis_document
                   WHERE title = 'DISPLAY_COMM_INCLUSIVE_VAT'
                     AND report_id = 'GIRIR001';
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_display_comm_inclusive_vat := 'N';
               END;    
                      
                
                /*IF v_display_comm_inclusive_vat = 'Y' THEN        
                       
                    FOR a IN(SELECT local_foreign_sw
                             FROM GIIS_REINSURER
                             WHERE ri_cd = p_ri_cd)

                    LOOP
                      v_foreign_sw := a.local_foreign_sw;
                      
                      IF v_foreign_sw != 'L' THEN    
                            
                        IF p_reverse_sw = 'Y' OR p_reverse_date IS NOT NULL THEN
                           v_ri_comm_amt := peril.ri_comm_amt * (-1) + NVL(peril.peril_comm_vat,0) ;
                           v_lcomm_amt   := peril.less_ri_comm_amt * (-1) - NVL(peril.peril_comm_vat,0);
                        ELSE
                           v_ri_comm_amt := peril.ri_comm_amt + NVL(peril.peril_comm_vat,0);
                           v_lcomm_amt   := peril.less_ri_comm_amt - NVL(peril.peril_comm_vat,0);
                        END IF;
                        
                        v_comm_vat    := 0;
                        
                      ELSE
                      
                        IF p_reverse_sw = 'Y' OR p_reverse_date IS NOT NULL THEN
                           v_ri_comm_amt := peril.ri_comm_amt * (-1);
                           v_lcomm_amt   := peril.less_ri_comm_amt * (-1);
                        ELSE
                           v_ri_comm_amt := peril.ri_comm_amt;
                           v_lcomm_amt   := peril.less_ri_comm_amt;
                        END IF;
                        
                        v_comm_vat    :=     NVL(peril.ri_comm_vat,0);  
                      
                      END IF;
                      
                    END LOOP;
                  
                ELSE
                     
                      IF p_reverse_sw = 'Y' OR p_reverse_date IS NOT NULL THEN
                         v_ri_comm_amt := peril.ri_comm_amt * (-1);
                         v_lcomm_amt   := peril.less_ri_comm_amt * (-1);
                         v_comm_vat       := NVL(peril.ri_comm_vat,0) * (-1);
                      ELSE
                         v_ri_comm_amt := peril.ri_comm_amt;
                         v_lcomm_amt   := peril.less_ri_comm_amt;
                         v_comm_vat       := NVL(peril.ri_comm_vat,0) * (-1);
                      END IF;
                  
                END IF;*/
                /* end of ri_comm_amt */
                
                
                -- apollo cruz 09.01.2015
                -- as per ma'am jhing, computation in foreign and local RI must be the same on these amounts
                IF v_display_comm_inclusive_vat = 'Y' THEN                   
                   v_ri_comm_amt := peril.ri_comm_amt + peril.peril_comm_vat;                   
                   v_ri_peril.less_comm_vat := 0;
                ELSE
                   v_ri_comm_amt := peril.ri_comm_amt;
                END IF;
                
                
                v_lcomm_amt := peril.ri_prem_amt - v_ri_comm_amt;
                v_comm_vat       := NVL(peril.ri_comm_vat,0);
                
                IF p_reverse_sw = 'Y' OR p_reverse_date IS NOT NULL THEN
                   v_ri_peril.ri_comm_amt          := v_ri_comm_amt * -1;
                   v_ri_peril.less_ri_comm_amt     := v_lcomm_amt * -1;
                   v_ri_peril.ri_comm_vat          := v_comm_vat * -1;
                ELSE
                   v_ri_peril.ri_comm_amt          := v_ri_comm_amt;
                   v_ri_peril.less_ri_comm_amt     := v_lcomm_amt;
                   v_ri_peril.ri_comm_vat          := v_comm_vat;
                END IF;
            END;
                   
            
            v_ri_peril.ri_comm_rt           := peril.ri_comm_rt;
            v_ri_peril.fnl_binder_id        := peril.fnl_binder_id;
            v_ri_peril.line_cd              := peril.line_cd;
            v_ri_peril.frps_yy              := peril.frps_yy;
            v_ri_peril.frps_seq_no          := peril.frps_seq_no;
            v_ri_peril.peril_title          := peril.peril_title;
            v_ri_peril.peril_comm_vat       := peril.peril_comm_vat;
            v_ri_peril.v_sequence           := peril.v_sequence;
            v_ri_peril.prt_flag             := peril.prt_flag;
            v_ri_peril.ri_wholding_vat      := peril.ri_wholding_vat;          
       

            -- jhing03.30.2016 REPUBLICFULLWEB 21773 
            IF v_ri_peril.gross_prem  = 0 and v_display_zero_prem_peril = 'Y' THEN
                v_ri_peril.display_peril := 'Y';
                v_ri_peril.cnt_disp_peril := 1 ; 
            ELSIF v_ri_peril.gross_prem  <> 0  THEN
                v_ri_peril.display_peril := 'Y';
                v_ri_peril.cnt_disp_peril := 1 ; 
            ELSE
                v_ri_peril.display_peril := 'N';
                v_ri_peril.cnt_disp_peril := 0 ; 
            END IF;
            
            v_ri_peril.peril_rowno := NVL(v_ri_peril.peril_rowno,0) + 1 ;
            
            PIPE ROW (v_ri_peril);
            
        END LOOP;        
        
        RETURN;
            
     END get_giri_binder_report_perils;
     
     FUNCTION get_girir002_details (
       p_line_cd           GIRI_WDISTFRPS.line_cd%TYPE,
       p_frps_yy           GIRI_WDISTFRPS.frps_yy%TYPE,
       p_frps_seq_no       GIRI_WDISTFRPS.frps_seq_no%TYPE
     )
     RETURN girir002_report_tab PIPELINED IS
       v_report             girir002_report_type;
     BEGIN
       FOR rec IN (SELECT T1.pre_binder_id,
                          T1.line_cd
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(T1.frps_yy, '09')))
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(T1.frps_seq_no, '09999999'))) frps_no,
                          'PRELIMINARY BINDER NUMBER P'
                          ||LTRIM(RTRIM(T2.line_cd))
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(binder_yy,'09')))
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(binder_seq_no,  '09999')))binder_no,
                          binder_date,
                          ri_name,
                          mail_address1,
                          mail_address2,
                          mail_address3,
                          T2.attention,
                          assd_name,
                          line_name,
                          loc_voy_unit,
                          T6.line_cd
                          ||'-'
                          ||RTRIM(T6.subline_cd)
                          ||'-'
                          ||RTRIM(T6.iss_cd)
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(T6.issue_yy, '09')))
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(T6.pol_seq_no, '0999999')))
                          ||'-'
                          ||LTRIM(RTRIM(TO_CHAR(T6.renew_no,'09'))) policy_no,
                          endt_iss_cd,
                          endt_yy,
                          endt_seq_no,
                         'P'||LTRIM(TO_CHAR(T5.tsi_amt,'99,999,999,999,990.99')) tsi_amt,
                          TO_CHAR(T2.eff_date,'MM/DD/YYYY')
                          ||' TO '
                          ||TO_CHAR(T2.expiry_date,'MM/DD/YYYY') ri_term,
                          'P'
                          ||LTRIM(TO_CHAR(T2.ri_tsi_amt, '99,999,999,999,990.99')) 
                          ||'     '
                          ||'('
                          ||LTRIM(TO_CHAR(T2.ri_shr_pct, '990.9999'))
                          ||'%)' YOUR_SHARE,
                          T2.ri_prem_amt,
                          T1.bndr_remarks1,
                          T1.bndr_remarks2,
                          T1.bndr_remarks3,
                          T2.confirm_no,
                          LTRIM(TO_CHAR(T4.dist_no,'09999999'))
                          ||'-'
                          ||LTRIM( TO_CHAR(T4.dist_seq_no,'09999'))
                          ||'/'
                          ||T8.line_cd
                          ||'-'
                          ||LTRIM(T8.iss_cd)
                          ||'-'
                          ||LTRIM(TO_CHAR(par_yy,'09'))
                          ||'-'
                          ||LTRIM(TO_CHAR(par_seq_no ,'099999'))
                          ||'-'
                          ||LTRIM(TO_CHAR(quote_seq_no,'09')) dist_par_no
                     FROM giri_wfrps_ri T1,
                          giri_wbinder T2,
                          giis_reinsurer T3,
                          giri_wdistfrps T4,
                          giuw_pol_dist T5,
                          gipi_polbasic T6,
                          giis_line T7,
                          gipi_parlist T8,
                          giis_assured T9
                    WHERE T1.pre_binder_id = T2.pre_binder_id
                      AND T2.ri_cd = T3.ri_cd
                      AND T1.line_cd = T4.line_cd
                      AND T1.frps_yy = T4.frps_yy
                      AND T1.frps_seq_no = T4.frps_seq_no
                      AND T4.dist_no = T5.dist_no
                      AND T5.policy_id = T6.policy_id
                      AND T6.line_cd = T7.line_cd
                      AND T6.par_id = T8.par_id
                      AND T6.assd_no = T9.assd_no
                      AND T4.LINE_CD = NVL(P_LINE_CD, T4.LINE_CD)
                      AND T4.FRPS_YY = NVL(P_FRPS_YY, T4.FRPS_YY)
                      AND T4.FRPS_SEQ_NO = NVL(P_FRPS_SEQ_NO, T4.FRPS_SEQ_NO))
       LOOP
         FOR peril IN (SELECT T1.PRE_BINDER_ID,
                              PERIL_TITLE,
                              TO_CHAR(T1.ri_comm_rt,'990.9999')||'%' RI_COMM_RT
                         FROM GIRI_WBINDER_PERIL T1,
                              GIRI_WBINDER T2,
                              GIRI_WFRPS_RI T3,
                              GIRI_WFRPS_PERIL_GRP T4
                        WHERE T1.PRE_BINDER_ID = T2.PRE_BINDER_ID
                          AND T2.PRE_BINDER_ID = T3.PRE_BINDER_ID
                          AND T3.LINE_CD       = T4.LINE_CD
                          AND T3.FRPS_YY       = T4.FRPS_YY
                          AND T3.FRPS_SEQ_NO   = T4.FRPS_SEQ_NO
                          AND T1.PERIL_SEQ_NO  = T4.PERIL_SEQ_NO
                          AND T1.PRE_BINDER_ID = REC.PRE_BINDER_ID) 
         LOOP
           IF v_report.peril_title IS NULL THEN
             v_report.peril_title := peril.peril_title;  
           ELSE
             v_report.peril_title := v_report.peril_title || CHR(10) || peril.peril_title;
           END IF;
           
           IF v_report.ri_comm_rt IS NULL THEN
             v_report.ri_comm_rt := peril.ri_comm_rt;
           ELSE
             v_report.ri_comm_rt := v_report.ri_comm_rt || CHR(10) || peril.ri_comm_rt;
           END IF;
         END LOOP;                 

         v_report.pre_binder_id := rec.pre_binder_id;
         v_report.frps_no := rec.frps_no;
         v_report.binder_no := rec.binder_no;
         v_report.binder_date := rec.binder_date;
         v_report.ri_name := rec.ri_name;
         v_report.mail_address1 := rec.mail_address1;
         v_report.mail_address2 := rec.mail_address2;
         v_report.mail_address3 := rec.mail_address3;
         v_report.attention := rec.attention;
         v_report.assd_name := rec.assd_name;
         v_report.line_name := rec.line_name;
         v_report.loc_voy_unit := rec.loc_voy_unit;
         v_report.policy_no := rec.policy_no;
         v_report.endt_iss_cd := rec.endt_iss_cd;
         v_report.endt_yy := rec.endt_yy;
         v_report.endt_seq_no := rec.endt_seq_no;
         v_report.tsi_amt := rec.tsi_amt;
         v_report.ri_term := rec.ri_term;
         v_report.your_share := rec.your_share;
         v_report.ri_prem_amt := rec.ri_prem_amt;
         v_report.bndr_remarks1 := rec.bndr_remarks1;
         v_report.bndr_remarks2 := rec.bndr_remarks2;
         v_report.bndr_remarks3 := rec.bndr_remarks3;
         v_report.confirm_no    := rec.confirm_no;
         v_report.dist_par_no   := rec.dist_par_no;
         
         IF v_report.endt_yy IS NOT NULL THEN
           v_report.endt_no := RTRIM(v_report.endt_iss_cd) || '-' || 
                    LTRIM(RTRIM(TO_CHAR(v_report.endt_yy,'09'))) || '-' || 
                    LTRIM(RTRIM(TO_CHAR(v_report.endt_seq_no,'099999')));
         END IF;
         
         PIPE ROW(v_report);
         
         v_report.peril_title := NULL;
         v_report.ri_comm_rt := NULL;
       END LOOP;
     END;
     
    /*
    **  Created by    : Robert Virrey
    **  Date Created  : January 13, 201
    **  Reference By  : GIRIR001A - RI BINDER REPORT
    **  Description   : Function returns details and parameters needed for GIRIR001A 
    */
    FUNCTION get_girir001a_details(
        p_line_v             GIRI_BINDER.line_cd%TYPE,
        p_binder_yy_v        GIRI_BINDER.binder_yy%TYPE,
        p_binder_seq_no_v    GIRI_BINDER.binder_seq_no%TYPE,
        p_attention          GIIS_REINSURER.attention%TYPE
    )                                   
    RETURN girir001a_report_tab PIPELINED 
    AS
    
    v_report        girir001a_report_type;
    mop                VARCHAR2(27);
    m_svu            VARCHAR2(20);
    status_v        VARCHAR2(20);
    object_v        VARCHAR2(12);
    object_v2        VARCHAR2(12);
    v_pol_flag      VARCHAR2(1);
    v_par_type      VARCHAR2(1);
    m_company_nm    giis_parameters.param_value_v%TYPE;
    
    CURSOR main IS
           SELECT DISTINCT UPPER(A150.LINE_NAME) LINE_NAME
                   ,'FACULTATIVE REINSURANCE BINDER NUMBER ' || D0107.LINE_CD || '-' || LTRIM(TO_CHAR(D0107.BINDER_YY,'09')) || '-'  || LTRIM(TO_CHAR(D0107.BINDER_SEQ_NO,'09999')) BINDER_NO
                   ,'FACULTATIVE REINSURANCE ALTERATION BINDER NUMBER ' || D0107.LINE_CD || '-' || LTRIM(TO_CHAR(D0107.BINDER_YY,'09')) || '-'  || LTRIM(TO_CHAR(D0107.BINDER_SEQ_NO,'09999')) BINDER_NUMBER
                   ,D0107.ENDT_TEXT ENDT_TEXT
                   ,D0107.BINDER_DATE BINDER_DATE5
                   ,A18011.RI_NAME RI_NAME
                   ,A18011.BILL_ADDRESS1 BILL_ADDRESS11
                   ,A18011.BILL_ADDRESS2 BILL_ADDRESS22
                   ,A18011.BILL_ADDRESS3 BILL_ADDRESS33
                   ,A18011.ATTENTION
                   ,DECODE(B240.PAR_TYPE,'E',B240.ASSD_NO,B2504.ASSD_NO) ASSD_NO
                   ,B2504.LINE_CD || '-' || B2504.SUBLINE_CD || '-' || B2504.ISS_CD || '-' ||  LTRIM(TO_CHAR(B2504.ISSUE_YY,'09'))
                      || '-' || LTRIM(TO_CHAR(B2504.POL_SEQ_NO,'0999999')) || '-' || LTRIM(TO_CHAR(b2504.renew_no,'09')) POLICY_NO
                   ,B2504.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B2504.ENDT_YY,'09')) || '-' || LTRIM(TO_CHAR(B2504.ENDT_SEQ_NO,'099999')) ENDT_NO
                  ,DECODE(B2504.INCEPT_TAG, 'Y', 'TBA', TO_CHAR(D0107.EFF_DATE, 'Mon. DD, YYYY')) || ' to '  ||
             DECODE(B2504.EXPIRY_TAG, 'Y', 'TBA', TO_CHAR(D0107.EXPIRY_DATE, 'Mon. DD, YYYY'))  RI_TERM      
            ,B2504.ENDT_SEQ_NO ENDT_SEQ_NO2
                  ,D0107.CONFIRM_NO
                  ,D0107.CONFIRM_DATE
                  ,D0107.FNL_BINDER_ID FNL_BINDER_ID2
                  ,B2504.POLICY_ID
                  ,B2504.PAR_ID
                  ,ENDT_SEQ_NO
                  ,ENDT_YY
                  ,ENDT_ISS_CD
                  ,SUBLINE_CD
                  ,B2504.LINE_CD
                  ,D0107.reverse_date     
            ,'* '||B2504.USER_ID||' *' USER_ID
            FROM    GIRI_BINDER D0107
                   ,GIIS_REINSURER A18011
                   ,GIIS_LINE A150
                   ,GIRI_ENDTTEXT C0803
                   ,GIPI_POLBASIC B2504
                   ,GIPI_PARLIST B240
            WHERE B240.PAR_ID = B2504.PAR_ID
            AND   A18011.RI_CD = D0107.RI_CD
            AND   C0803.RI_CD = D0107.RI_CD
            AND   C0803.FNL_BINDER_ID = D0107.FNL_BINDER_ID
            AND   D0107.LINE_CD = A150.LINE_CD
            AND   B2504.POLICY_ID = C0803.POLICY_ID
            AND   D0107.LINE_CD =  P_LINE_V
            AND   D0107.BINDER_YY = TO_NUMBER(P_BINDER_YY_V)
            AND   D0107.BINDER_SEQ_NO =  TO_NUMBER(P_BINDER_SEQ_NO_V);
    
    BEGIN
        FOR i IN main
        LOOP
            v_report.assd_no                := i.assd_no;
            v_report.attention              := i.attention;
            v_report.user_id                := i.user_id;
            v_report.bill_address11         := i.bill_address11;
            v_report.bill_address22         := i.bill_address22;
            v_report.bill_address33         := i.bill_address33;
            v_report.binder_date5           := i.binder_date5;
            v_report.binder_no              := i.binder_no;
            v_report.binder_no1             := i.binder_number;
            v_report.confirm_date           := i.confirm_date;
            v_report.confirm_no             := i.confirm_no;
            v_report.endt_iss_cd            := i.endt_iss_cd;
            v_report.endt_no                := i.endt_no;
            v_report.endt_seq_no            := i.endt_seq_no;
            v_report.endt_seq_no2           := i.endt_seq_no2;
            v_report.endt_text              := i.endt_text;
            v_report.endt_yy                := i.endt_yy;
            v_report.fnl_binder_id2         := i.fnl_binder_id2;
            v_report.line_cd                := i.line_cd;
            v_report.line_name              := i.line_name;
            v_report.par_id                 := i.par_id;
            v_report.policy_id              := i.policy_id;
            v_report.policy_no              := i.policy_no;
            v_report.ri_name                := i.ri_name;
            v_report.ri_term                := i.ri_term;       
            v_report.subline_cd             := i.subline_cd;
            v_report.reverse_date           := i.reverse_date;
            
        END LOOP;
        
        --CF_ASSD_NAME
        BEGIN
          FOR C IN(SELECT ASSD_NAME ASSD_NAME
                     FROM GIIS_ASSURED
                    WHERE ASSD_NO = v_report.assd_no) 
          LOOP
             v_report.assd_name := c.assd_name;
          END LOOP;     
        END;
        
        --CF_ENDT_NO
        BEGIN
          IF v_report.endt_seq_no != 0 THEN
            v_report.endt := v_report.endt_iss_cd || '-' ||LTRIM(RTRIM(TO_CHAR(v_report.endt_yy, '09'))) 
            || '-' || LTRIM(RTRIM(TO_CHAR(v_report.endt_seq_no, '099999')));
          ELSE
            v_report.endt := NULL;
          END IF;
        END;
        
        --CF_MOP_NUMBER
        BEGIN
          BEGIN
            SELECT  T1.line_cd || '-' || ltrim(op_subline_cd) || '-' ||
                ltrim(op_iss_cd) || '-' || ltrim(to_char(issue_yy,'09'))
                    || '-' || ltrim(to_char(op_pol_seqno,'0999999'))
              INTO  mop
              FROM  gipi_open_policy T1, gipi_polbasic T2
             WHERE  T2.policy_id = v_report.policy_id
               AND  T1.policy_id = T2.policy_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN NULL;
          END;
          v_report.mop    := mop;
        END;
        
        --CF_SVU
        BEGIN
          m_svu := 'Property/Item :';
          /*IF :line_cd = 'MN' THEN
             m_svu := 'Site/Voyage/Unit:';
          ELSE
                                 
             m_svu := 'Property Insured:';
          END IF;*/
          v_report.m_svu := m_svu;
        END;
        
        --FIRST_PARAGRAPH
        BEGIN
          BEGIN
            SELECT pol_flag
              INTO v_pol_flag
              FROM gipi_polbasic
             WHERE policy_id = v_report.policy_id;
            SELECT par_type
              INTO v_par_type
              FROM gipi_parlist
             WHERE par_id = v_report.par_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN NULL;
          END;
          IF (v_pol_flag = '1') OR (v_pol_flag = '2') OR (v_pol_flag = '3') 
            OR (v_pol_flag = '5')    THEN
            IF v_report.ENDT_SEQ_NO2 >0 THEN
                status_v := 'ENDORSE/ISSUE';
            ELSIF v_report.ENDT_SEQ_NO2=0 THEN
                    status_v := 'ISSUE/ENDORSE';
            END IF;
          ELSIF (v_pol_flag = '4') THEN
            status_v := 'cancel';
          END IF;
          --SRW.MESSAGE(1,v_pol_flag);
          IF (v_par_type = 'P') THEN
            object_v := 'Policy';
          ELSIF (v_par_type = 'E') THEN
                object_v := 'Policy';
          END IF; 
          IF (v_pol_flag = '2') THEN
            object_v2 := 'renewal,';
          ELSE
            IF (v_par_type = 'P') THEN
              object_v2 := 'POLICY,';
            ELSIF (v_par_type = 'E') THEN
              object_v2 := 'ENDORSEMENT,';
            END IF; 
          END IF;
          v_report.first_paragraph := 'Kindly ' || status_v || ' your Reinsurance ' || object_v || ' in accordance with our '
                  || object_v2 || ' copy(ies) of which is(are) attached herewith.'; 
        END;
        
        --HEADING
        BEGIN
          v_report.heading  := 'LINE: ' || v_report.LINE_NAME;
        END;
        
        --CF_COMP_NM
        BEGIN
          FOR name_rec IN (
              SELECT param_value_v
            FROM giis_parameters
               WHERE param_name = 'COMPANY_NAME')
          LOOP
              m_company_nm := name_rec.param_value_v;
          EXIT;
          END LOOP;
          v_report.m_company_nm     := m_company_nm;
        END;
        
        v_report.param_attn         := NVL(p_attention, 'REINSURANCE DEPARTMENT');
        
        PIPE ROW(v_report);
    
    END get_girir001a_details;
                
END GIRI_BINDER_REPORTS_PKG;
/
