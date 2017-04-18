CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr036_pkg 
AS

/*
**  Created by   :  Belle Bebing
**  Date Created :  10.25.2011
**  Reference By : POPULATE_GICLR036_UCPB (GICLS041 - Print Documents) 
**  Description  : Populate GICLR036 for UCPB. 
*/
FUNCTION populate_giclr036_UCPB (
    p_sel_payee_cl_cd            GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_c011_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_sel_payee_cd               GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_c011_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_gido_affofdesist_wit1      VARCHAR2,
    p_gido_affofdesist_wit2      VARCHAR2,
    p_c003_claim_id              GICL_CLAIMS.claim_id%TYPE)  
    
  RETURN populate_reports_tab PIPELINED
  AS
    vrep                     populate_reports_type;   
    v_corp_tag               GIIS_ASSURED.corporate_tag%TYPE;
    v_is_conjugal            VARCHAR2(2000);
    v_payee_name2            VARCHAR2(2000):= NULL;
    variables_v_payee_name   VARCHAR2(2000):= NULL;
    variables_v_payee_add    VARCHAR2(2000):= NULL;
    variables_assured        GIIS_ASSURED.assd_name%TYPE;
    variables_location       VARCHAR2(500);
    v_payee_class_tag        VARCHAR2(50);
    v_rep_format             VARCHAR2(50);
    variables_loss_date      VARCHAR2(50);
    
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
        
        IF p_gido_affofdesist_wit1 IS NOT NULL AND p_gido_affofdesist_wit2 IS NOT NULL THEN
            v_is_conjugal := '1';
        ELSIF p_gido_affofdesist_wit1 IS NOT NULL AND p_gido_affofdesist_wit2 IS NULL THEN
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

            IF p_gido_affofdesist_wit1 IS NOT NULL AND p_gido_affofdesist_wit2 IS NOT NULL THEN
                variables_v_payee_name := p_gido_affofdesist_wit2;
                v_payee_name2 := p_gido_affofdesist_wit1;
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

     BEGIN
        SELECT decode(loss_loc1,null,
               decode(loss_loc2,null,
               decode(loss_loc3,null,null,loss_loc3),
               loss_loc2||' '||decode(loss_loc3,null,null,loss_loc3)),
               loss_loc1||' '||decode(loss_loc2,null,
               decode(loss_loc3,null,null,loss_loc3),
               loss_loc2||' '||decode(loss_loc3,null,null,loss_loc3))) location, loss_date
          INTO variables_location, variables_loss_date
          FROM gicl_claims
         WHERE claim_id = p_c003_claim_id;
     EXCEPTION
        when NO_DATA_FOUND then
        RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
     END;

 -- insert 3rd party payee name
     IF v_rep_format != 'CONJ' THEN
        vrep.wrd_tp_name := NVL(variables_v_payee_name,'_______________________');
     ELSE
        vrep.wrd_tp_name := NVL(v_payee_name2,'_______________________')||' & '||NVL(variables_v_payee_name,'_______________________');
     END IF;
    
 -- insert payee tp_name
      IF v_rep_format != 'CONJ' THEN  
        vrep.wrd_payee2 := ' ';
        vrep.wrd_role2  := ' ';
        vrep.wrd_payee1 := NVL(variables_v_payee_name,'_____________________________');
        vrep.wrd_role1  := 'Affiant';
     ELSE
        vrep.wrd_payee2 :=  NVL(v_payee_name2,'_____________________________');
        vrep.wrd_role2  := 'Affiant';
        vrep.wrd_payee1 := NVL(variables_v_payee_name,'_____________________________');
        vrep.wrd_role1  := 'Affiant';
     
      END IF;

 -- insert contact person if company or attorney if Ind
      IF  v_rep_format IN ('CORP', 'SPA')  THEN  
        vrep.wrd_label2 := 'By:';
        vrep.wrd_at     := NVL(p_gido_affofdesist_wit1,'_____________________________');
        
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

      vrep.wrd_tp_add     := NVL(variables_v_payee_add,'_______________________________');
      vrep.wrd_loss_date  := NVL(to_char(to_date(variables_loss_date),'fmDDTH MONTH RRRR'),'____________________');
      vrep.wrd_loss_loc   := NVL(variables_location,'_____________________________');
      vrep.wrd_witness1   := '______________________________'||chr(10)||'Witness';
      vrep.wrd_witness2   := '______________________________'||chr(10)||'Witness';
      vrep.wrd_yr2        := to_char(SYSDATE,'YYYY');
  
    PIPE ROW (vrep);
 END populate_giclr036_UCPB;
 
END;
/


