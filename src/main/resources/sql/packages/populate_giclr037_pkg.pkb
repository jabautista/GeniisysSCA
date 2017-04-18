CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr037_pkg
AS 

/*
**  Created by   :  Belle Bebing
**  Date Created :  11.09.2011
**  Reference By : POPULATE_GICLR037_UCPB (GICLS041 - Print Documents) 
**  Description  : Release of Claim Motor Car for UCPB General Insurance Co., Inc. 
*/
FUNCTION populate_giclr037_UCPB(
    p_sel_payee_cl_cd            GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_c011_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_sel_payee_cd               GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_c011_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_witness1                   VARCHAR2,
    p_witness2                   VARCHAR2,
    p_claim_id                   GICL_CLAIMS.claim_id%TYPE,
    p_c007_item_no               GICL_ITEM_PERIL.item_no%TYPE,
    p_c007_grouped_item_no       GICL_ITEM_PERIL.grouped_item_no%TYPE,
    p_total_stl_paid_amt         GICL_CLM_LOSS_EXP.paid_amt%TYPE,
    p_c011_paid_amt              GICL_CLM_LOSS_EXP.paid_amt%TYPE
    )
RETURN populate_reports_tab PIPELINED
AS
    vrep                        populate_reports_type;
    v_payee_class_tag           VARCHAR2(50);
    v_corp_tag                  GIIS_ASSURED.corporate_tag%TYPE;
    variables_v_payee_name      VARCHAR2(2000):= NULL;
    variables_v_payee_add       VARCHAR2(2000):= NULL;
    v_is_conjugal               NUMBER;
    v_rep_format                VARCHAR2(2000);
    v_payee_name2               VARCHAR2(2000):= NULL;
    v_pdamt                     VARCHAR2(2000);
    v_short_name                VARCHAR2(2000);
    variables_claim_no          VARCHAR2(50);
    variables_policy_number     VARCHAR2(50);
    variables_v_date1           VARCHAR2(50);
    v_company_name              VARCHAR2(2000) := giisp.v('COMPANY_NAME');

    BEGIN    
        BEGIN    
            SELECT payee_class_tag 
              INTO v_payee_class_tag
              FROM GIIS_PAYEE_CLASS
             WHERE payee_class_cd = NVL(p_sel_payee_cl_cd, p_c011_payee_class_cd);
      
            IF v_payee_class_tag = 'S' and NVL(p_sel_payee_cl_cd, p_c011_payee_class_cd) in ('1','3') THEN        
                IF NVL(p_sel_payee_cl_cd, p_c011_payee_class_cd) = '1' THEN
                    SELECT corporate_tag, DECODE(corporate_tag,'I', FIRST_NAME||' '||DECODE(MIDDLE_INITIAL, NULL,NULL,replace(MIDDLE_INITIAL,'.','')||'.')||' '||LAST_NAME,
                           'J', DECODE(ASSD_NAME2,NULL,ASSD_NAME,FIRST_NAME||' '||DECODE(MIDDLE_INITIAL, NULL,NULL,replace(MIDDLE_INITIAL,'.','')||'.')||' '||LAST_NAME||' '||ASSD_NAME2), ASSD_NAME ), 
                           DECODE(NVL(MAIL_ADDR1,'*'),'*',NULL,replace(MAIL_ADDR1,',',''))||DECODE(NVL(MAIL_ADDR2,'*'),'*',NULL,', '||replace(MAIL_ADDR2,',',''))||DECODE(NVL(MAIL_ADDR3,'*'),'*',NULL,', '||replace(MAIL_ADDR3,',','')) address
                      INTO v_corp_tag, variables_v_payee_name, variables_v_payee_add
                      FROM GIIS_ASSURED
                     WHERE assd_no = NVL(p_sel_payee_cd, p_c011_payee_cd);
              
               ELSIF NVL(p_sel_payee_cl_cd, p_c011_payee_class_cd) = '3' THEN
                    SELECT decode(corp_tag,'Y','C','I'),intm_name, DECODE(NVL(MAIL_ADDR1,'*'),'*',NULL,replace(MAIL_ADDR1,',',''))||DECODE(NVL(MAIL_ADDR2,'*'),'*',NULL,', '||replace(MAIL_ADDR2,',',''))||DECODE(NVL(MAIL_ADDR3,'*'),'*',NULL,', '||replace(MAIL_ADDR3,',','')) address
                      INTO v_corp_tag, variables_v_payee_name, variables_v_payee_add
                      FROM GIIS_INTERMEDIARY
                     WHERE INTM_NO = NVL(p_sel_payee_cd, p_c011_payee_cd);  
                END IF;
           ELSE
                SELECT DECODE(payee_first_name, null, 'C', 'I'),DECODE(PAYEE_FIRST_NAME, NULL, PAYEE_LAST_NAME, PAYEE_FIRST_NAME||' '||DECODE(PAYEE_MIDDLE_NAME,NULL,NULL,SUBSTR(PAYEE_MIDDLE_NAME,1,1)||'.')||' '||PAYEE_LAST_NAME) PAYEE,
                       DECODE(NVL(MAIL_ADDR1,'*'),'*',NULL,replace(MAIL_ADDR1,',',''))||DECODE(NVL(MAIL_ADDR2,'*'),'*',NULL,', '||replace(MAIL_ADDR2,',',''))||DECODE(NVL(MAIL_ADDR3,'*'),'*',NULL,', '||replace(MAIL_ADDR3,',','')) PAYEE_ADD
                  INTO v_corp_tag, variables_v_payee_name, variables_v_payee_add/*, v_tin, v_contact_pers, v_designation*/
                  FROM GIIS_PAYEES
                 WHERE PAYEE_CLASS_CD = NVL(p_sel_payee_cl_cd, p_c011_payee_class_cd)
                   AND PAYEE_NO = NVL(p_sel_payee_cd, p_c011_payee_cd);
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

    -- extract loss date
        SELECT to_char(loss_date,'MM-DD-YYYY') 
          INTO variables_v_date1
          FROM gicl_clm_item
          WHERE claim_id = p_claim_id
           AND item_no = p_c007_item_no
           AND grouped_item_no = p_c007_grouped_item_no;

        IF p_total_stl_paid_amt is not null or p_c011_paid_amt is not null or p_total_stl_paid_amt != 0 or p_c011_paid_amt != 0 THEN
             v_pdamt := TO_CHAR(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'fm999,999,999,999.00');
        END IF;
     
    -- short name
         FOR rec IN
            (SELECT short_name 
               FROM giis_currency                      
              WHERE main_currency_cd = (SELECT currency_cd 
                                          FROM GICL_CLM_LOSS_EXP 
                                         WHERE claim_id = p_claim_id
                                           AND rownum=1))                 
         LOOP
           v_short_name := rec.short_name;    
           EXIT;
         END LOOP;
         
         BEGIN
            SELECT line_cd ||'-'||subline_cd||'-'||iss_cd||'-'||
                   ltrim(to_char(clm_yy,'09'),' ')||'-'||
                   ltrim(to_char(clm_seq_no,'0000009'),' ') claim_no
              INTO variables_claim_no
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
         EXCEPTION
            when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
         END; 
         
         BEGIN
            SELECT line_cd ||'-'||subline_cd||'-'||pol_iss_cd||'-'||
                   ltrim(to_char(issue_yy,'09'),' ')||'-'||
                   ltrim(to_char(pol_seq_no,'0000009'),' ')||'-'||
                   ltrim(to_char(renew_no,'09'),' ') policy_no
              INTO variables_policy_number
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
         EXCEPTION
            when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');   
         END;

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

        vrep.wrd_claim_no    := variables_claim_no;
        vrep.wrd_cur         := NVL(v_short_name,'___________________');
        vrep.wrd_paid_amt    := NVL(v_pdamt,'___________________');
        vrep.wrd_company     := NVL(v_company_name,'_____________________________');
        vrep.wrd_loss_date   := variables_v_date1;
        vrep.wrd_policy_no   := variables_policy_number;
        vrep.wrd_assd2       := ' ';
        vrep.wrd_role2       := ' ';
        vrep.wrd_assd1       := NVL(variables_v_payee_name,'_____________________________');
        vrep.wrd_role1       := 'Affiant';
        vrep.wrd_assd2       := NVL(v_payee_name2,'_____________________________');
        vrep.wrd_role2       := 'Affiant';
        vrep.wrd_assd1       := NVL(variables_v_payee_name,'_____________________________');
        vrep.wrd_role1       := 'Affiant';
        vrep.wrd_witness1    := '______________________________'||chr(10)||'Witness';
        vrep.wrd_witness2    := '______________________________'||chr(10)||'Witness';
        vrep.wrd_yr          := NVL(TO_CHAR(sysdate,'YYYY'),'________');
        
       PIPE ROW (vrep);
    END populate_giclr037_UCPB;

END;
/


