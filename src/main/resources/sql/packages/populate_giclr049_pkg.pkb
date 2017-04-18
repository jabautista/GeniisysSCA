CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr049_pkg
AS
/*
**  Created by   :  Belle Bebing
**  Date Created :  11.22.2011
**  Reference By : POPULATE_GICLR049 (GICLS041 - Print Documents) 
**  Description  : Populate GICLR049 for UCPB 
*/
FUNCTION populate_giclr049_UCPB( 
    p_claim_id                   GICL_CLAIMS.claim_id%TYPE,
    p_sel_payee_cl_cd            GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_sel_payee_cd               GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_total_stl_paid_amt         VARCHAR2,
    p_c011_paid_amt              VARCHAR2,
    p_policy_no                  VARCHAR2,
    p_loss_ctgry                 VARCHAR2,
    p_dsp_loss_date              VARCHAR2,
    p_witness1                   VARCHAR2,
    p_witness2                   VARCHAR2)

RETURN populate_reports_tab PIPELINED
AS
    vrep                         populate_reports_type;
    v_payee_class_tag            VARCHAR2(50);
    v_corp_tag                   VARCHAR2(50); 
    variables_v_payee_name       VARCHAR2(2000):= NULL;
    variables_v_payee_add        VARCHAR2(2000):= NULL;
    V_IS_CONJUGAL                VARCHAR2(50);
    v_payee_name2                VARCHAR2(200):= NULL;
    v_rep_format                 VARCHAR2(50);
    variables_v_stl_paid_amt     VARCHAR2(50);
    variables_v_currency_sn      VARCHAR2(50);
    v_location1                  VARCHAR2(200);
    v_ver_flag_1                 VARCHAR2(50);
    v_loc1                       VARCHAR2(50);
    v_loc2                       VARCHAR2(50);       
    v_loc3                       VARCHAR2(50);

    BEGIN 
        variables_v_stl_paid_amt := dh_util.check_protect(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'PHILIPPINE PESO',TRUE); -- added by JEROME.O 3-11-09
                                                                                        
            BEGIN
                SELECT distinct short_name
                  INTO variables_v_currency_sn
                  FROM giis_currency 
                 WHERE main_currency_cd = giacp.n('CURRENCY_CD');
            EXCEPTION
                when NO_DATA_FOUND then
                  null;
                when TOO_MANY_ROWS then
                  null;
            END;
            
            BEGIN    
                SELECT payee_class_tag 
                  INTO v_payee_class_tag
                  FROM GIIS_PAYEE_CLASS
                 WHERE payee_class_cd = NVL(p_sel_payee_cl_cd, p_payee_class_cd);
              
                IF v_payee_class_tag = 'S' and NVL(p_sel_payee_cl_cd, p_payee_class_cd) in ('1','3') THEN        
                    IF NVL(p_sel_payee_cl_cd, p_payee_class_cd) = '1' THEN
                        SELECT corporate_tag, DECODE(corporate_tag,'I', FIRST_NAME||' '||DECODE(MIDDLE_INITIAL, NULL,NULL,replace(MIDDLE_INITIAL,'.','')||'.')||' '||LAST_NAME,
                               'J', DECODE(ASSD_NAME2,NULL,ASSD_NAME,FIRST_NAME||' '||DECODE(MIDDLE_INITIAL, NULL,NULL,replace(MIDDLE_INITIAL,'.','')||'.')||' '||LAST_NAME||' '||ASSD_NAME2), ASSD_NAME ), 
                               DECODE(NVL(MAIL_ADDR1,'*'),'*',NULL,replace(MAIL_ADDR1,',',''))||DECODE(NVL(MAIL_ADDR2,'*'),'*',NULL,', '||replace(MAIL_ADDR2,',',''))||DECODE(NVL(MAIL_ADDR3,'*'),'*',NULL,', '||replace(MAIL_ADDR3,',','')) address
                          INTO v_corp_tag, variables_v_payee_name, variables_v_payee_add
                          FROM GIIS_ASSURED
                         WHERE assd_no = NVL(p_sel_payee_cd, p_payee_cd);
                      
                   ELSIF NVL(p_sel_payee_cl_cd, p_payee_class_cd) = '3' THEN
                        SELECT decode(corp_tag,'Y','C','I'),intm_name, DECODE(NVL(MAIL_ADDR1,'*'),'*',NULL,replace(MAIL_ADDR1,',',''))||DECODE(NVL(MAIL_ADDR2,'*'),'*',NULL,', '||replace(MAIL_ADDR2,',',''))||DECODE(NVL(MAIL_ADDR3,'*'),'*',NULL,', '||replace(MAIL_ADDR3,',','')) address
                          INTO v_corp_tag, variables_v_payee_name, variables_v_payee_add
                          FROM GIIS_INTERMEDIARY
                         WHERE INTM_NO = NVL(p_sel_payee_cd, p_payee_cd);  
                    END IF;
               ELSE
                    SELECT DECODE(payee_first_name, null, 'C', 'I'),DECODE(PAYEE_FIRST_NAME, NULL, PAYEE_LAST_NAME, PAYEE_FIRST_NAME||' '||DECODE(PAYEE_MIDDLE_NAME,NULL,NULL,SUBSTR(PAYEE_MIDDLE_NAME,1,1)||'.')||' '||PAYEE_LAST_NAME) PAYEE,
                           DECODE(NVL(MAIL_ADDR1,'*'),'*',NULL,replace(MAIL_ADDR1,',',''))||DECODE(NVL(MAIL_ADDR2,'*'),'*',NULL,', '||replace(MAIL_ADDR2,',',''))||DECODE(NVL(MAIL_ADDR3,'*'),'*',NULL,', '||replace(MAIL_ADDR3,',','')) PAYEE_ADD
                      INTO v_corp_tag, variables_v_payee_name, variables_v_payee_add/*, v_tin, v_contact_pers, v_designation*/
                      FROM GIIS_PAYEES
                     WHERE PAYEE_CLASS_CD = NVL(p_sel_payee_cl_cd, p_payee_class_cd)
                       AND PAYEE_NO = NVL(p_sel_payee_cd, p_payee_cd);
                END IF;        
              
            EXCEPTION
             WHEN NO_DATA_FOUND THEN
                NULL;
            END;
               
            -- identify what format
             BEGIN
                SELECT Decode(SIGN(instr(UPPER(variables_v_payee_name), 'AND/OR',1,1)),0, 
                              SIGN(instr(UPPER(variables_v_payee_name), '&/OR',1,1)),
                              SIGN(instr(UPPER(variables_v_payee_name), 'AND/OR',1,1)))IS_CONJ1
                  INTO V_IS_CONJUGAL
                  FROM DUAL;
                        
                IF p_witness1 IS NOT NULL AND p_witness2 IS NOT NULL THEN
                    v_is_conjugal := '1';
                ELSIF p_witness1 IS NOT NULL AND p_witness2 IS NULL THEN
                    IF v_is_conjugal != '1' THEN
                    v_is_conjugal := '2';
                    ELSE 
                        v_is_conjugal := '1';
                    END IF;
                END IF;

             END;
                     
             IF v_corp_tag = 'I' and v_is_conjugal = '2' THEN
                v_rep_format := 'SPA';
            ELSIF v_corp_tag = 'C' and v_is_conjugal != '1' THEN
                v_rep_format := 'CORP';
            ELSIF v_is_conjugal = '1' THEN
                v_rep_format := 'CONJ';

                    IF p_witness1 IS NOT NULL AND p_witness2 IS NOT NULL THEN
                        variables_v_payee_name := p_witness2;
                        v_payee_name2 := p_witness1;
                   ELSE
                        SELECT substr(UPPER(variables_v_payee_name),0,INSTR(UPPER(variables_v_payee_name),' &/OR ',1,1)-1) FIRST_NAME, 
                               substr(UPPER(variables_v_payee_name),INSTR(UPPER(variables_v_payee_name),' &/OR ',1,1)+6) SECOND_NAME 
                        INTO v_payee_name2, variables_v_payee_name
                        FROM DUAL;

                        IF v_payee_name2 = null or v_payee_name2 = '' then
                            SELECT substr(UPPER(variables_v_payee_name),0,INSTR(UPPER(variables_v_payee_name),' AND/OR ',1,1)-1) FIRST_NAME, 
                                   substr(UPPER(variables_v_payee_name),INSTR(UPPER(variables_v_payee_name),' AND/OR ',1,1)+8) SECOND_NAME
                              INTO v_payee_name2, variables_v_payee_name                   
                              FROM DUAL;
                        END IF;
                                
                    END IF;
            ELSE
                v_rep_format:= 'IND';         
             END IF;
             
            FOR ver_rec3 IN (SELECT loss_loc1, loss_loc2, loss_loc3
                               FROM gicl_claims 
                              WHERE claim_id=p_claim_id)
            LOOP
              v_ver_flag_1 := 1;
              v_loc1 := ver_rec3.loss_loc1;
              v_loc2 := ver_rec3.loss_loc2;
              v_loc3 := ver_rec3.loss_loc3;
            END LOOP;
            
              IF  v_ver_flag_1 != 1 THEN
                  v_location1 :='';
              ELSIF  v_loc1 IS NOT NULL OR v_loc2 IS NOT NULL OR v_loc3 IS NOT NULL OR v_loc1!='' OR v_loc2!='' OR v_loc3!='' THEN
                  v_location1 := ' at the '||v_loc1||' '||v_loc2||' '||v_loc3;
              ELSE
                  v_location1 :='';
              END IF;


            IF v_rep_format != 'CONJ' THEN  
                vrep.wrd_assd2 := ' ';
                vrep.wrd_role2 := ' ';
                vrep.wrd_assd1 := NVL(variables_v_payee_name,'_____________________________');
                vrep.wrd_role1 := 'Affiant';
            ELSE
                vrep.wrd_assd2 := NVL(v_payee_name2,'_____________________________');
                vrep.wrd_role2 := 'Affiant';
                vrep.wrd_assd1 := NVL(variables_v_payee_name,'_____________________________');
                vrep.wrd_role1 := 'Affiant';
            END IF;

         -- insert contact person if company or attorney if Ind
            IF  v_rep_format IN ('CORP', 'SPA')  THEN  
                vrep.wrd_label2 := 'By:';
                vrep.wrd_at     := NVL(p_witness1,'_____________________________');
            
                IF v_rep_format = 'CORP' THEN                     
                    vrep.wrd_role3 := 'Authorized Signature';  
                ELSE
                    vrep.wrd_role3 := 'Attorney-in-Fact';
                END IF; 
                          
            ELSE
                vrep.wrd_label2 := ' ';
                vrep.wrd_at     := ' ';
                vrep.wrd_role3  := ' ';
            END IF;
            
            vrep.wrd_amt         := NVL(ltrim(nvl(variables_v_stl_paid_amt,'ZERO'))||' Only ('||variables_v_currency_sn||' ' -- modified by JEROME.O 3/11/09 
                                     ||ltrim(to_char(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'fm999,999,999,999.00'))||')','___________________________');
            vrep.wrd_company     := NVL(GIISP.V('COMPANY_NAME'),'_______________________');  
            vrep.wrd_policy      := NVL(p_policy_no,'______________________');
            vrep.wrd_losscat     := NVL(p_loss_ctgry,'__________________');
            vrep.wrd_location    := NVL(to_char(to_date(p_dsp_loss_date, 'MM-DD-YYYY'),'fmDD Month, YYYY'),'_______________')||v_location1;
            vrep.wrd_witness1    := '__________________________'||chr(10)||'Witness';
            vrep.wrd_witness2    := '__________________________'||chr(10)||'Witness';
            
            PIPE ROW(vrep);

    END populate_giclr049_UCPB;    

END;
/


