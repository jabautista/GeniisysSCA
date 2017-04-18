CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr042B_pkg
AS
/*
**  Created by   :  Belle Bebing
**  Date Created :  11.22.2011
**  Reference By : POPULATE_GICLR042B(GICLS041 - Print Documents) 
**  Description  : Populate default GICLR042 - if VERSION is NULL 
*/
FUNCTION populate_giclr042B_dfault(
    p_claim_id              GICL_CLAIMS.claim_id%TYPE,
    p_advice_id             GICL_CLM_LOSS_EXP.advice_id%TYPE,
    p_line_cd               GICL_CLAIMS.line_cd%TYPE,
    p_total_stl_paid_amt    VARCHAR2,
    p_c011_paid_amt         VARCHAR2,
    p_payee_last_name       VARCHAR2,
    p_payee_class_cd        GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_payee_cd              GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_witness1              VARCHAR2,
    p_witness2              VARCHAR2
    )
RETURN populate_reports_tab PIPELINED
AS
    vrep                        populate_reports_type;
    variables_v_stl_paid_amt    VARCHAR2(50);
    variables_v_currency_sn     VARCHAR2(50);
    variables_v_payee_remarks   VARCHAR2(500);
    variables_company_name      VARCHAR2(200);
    variables_v_grp_item_title  VARCHAR2(50);
    variables_v_item_title      VARCHAR2(50);
    variables_v_line_name       VARCHAR2(50);
    variables_policy_no         VARCHAR2(50);
    
    BEGIN
        variables_v_stl_paid_amt := dh_util.check_protect(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'PHILIPPINE PESO',TRUE); -- added by JEROME.O 3-11-09    
        variables_company_name   := get_payee_name(p_payee_cd,p_payee_class_cd);
        
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
            SELECT payee_remarks
              INTO variables_v_payee_remarks   
              FROM gicl_advice
             WHERE claim_id = p_claim_id
               AND advice_id = p_advice_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        BEGIN
            SELECT grouped_item_title, item_title
              INTO variables_v_grp_item_title, variables_v_item_title
              FROM gicl_accident_dtl
             WHERE claim_id = p_claim_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        END;
        
        BEGIN
            SELECT line_name 
              INTO variables_v_line_name
              FROM giis_line
             WHERE line_cd = p_line_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        BEGIN
             SELECT 'Policy No. '||line_cd ||'-'||subline_cd||'-'||pol_iss_cd||'-'||
                   ltrim(to_char(issue_yy,'09'),' ')||'-'||
                   ltrim(to_char(pol_seq_no,'0000009'),' ')||'-'||
                   ltrim(to_char(renew_no,'09'),' ') policy_no
              INTO variables_policy_no
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
        EXCEPTION
            when NO_DATA_FOUND then
              RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
        END;
      
        vrep.wrd_paid_amt        := NVL(ltrim(variables_v_stl_paid_amt)||' ('||variables_v_currency_sn -- modified by JEROME.O 3/11/09 
                                 ||ltrim(to_char(NVL(p_total_stl_paid_amt, p_c011_paid_amt),'fm999,999,999,999.00'))||')','______________________');
        vrep.wrd_payee1          := NVL(p_payee_last_name,'_____________________');
        vrep.wrd_payee_remarks   := NVL(variables_v_payee_remarks,',');
        vrep.wrd_company_name1   := NVL(variables_company_name,'___________________________');
        vrep.wrd_grp_item1       := NVL(variables_v_grp_item_title, variables_v_item_title);
        vrep.wrd_line_name       := NVL(variables_v_line_name,'__________________');
        vrep.wrd_policy_no       := NVL(variables_policy_no,'_______________________');
        vrep.wrd_grp_item2       := NVL(variables_v_grp_item_title,variables_v_item_title);
        vrep.wrd_company_name2   := NVL(variables_company_name,'___________________________');
        vrep.wrd_grp_item3       := NVL(variables_v_grp_item_title, variables_v_item_title);
        vrep.wrd_grp_item4       := NVL(variables_v_grp_item_title, variables_v_item_title);
        vrep.wrd_company_name3   := NVL(variables_company_name,'___________________________');
        vrep.wrd_payee2          := NVL(p_payee_last_name||' '||variables_v_payee_remarks,'_______________________');
        vrep.wrd_witness1        := NVL(p_witness1,'______________________');
        vrep.wrd_witness2        := NVL(p_witness2,'______________________');
        vrep.wrd_yr              := NVL(TO_CHAR(SYSDATE,'YYYY'),'________');
        
        PIPE ROW (vrep);
      
    END populate_giclr042B_dfault;
    
END;
/


