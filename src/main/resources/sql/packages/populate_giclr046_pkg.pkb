CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr046_pkg
AS

/*
**  Created by   :  Belle Bebing
**  Date Created :  11.15.2011
**  Reference By : POPULATE_GICLR046_CIC (GICLS041 - Print Documents) 
**  Description  : Populate GICLR046 when VERSION is null. 
*/   
FUNCTION populate_giclr046_dfault(
    p_claim_id                  GICL_CLAIMS.claim_id%TYPE,             
    p_c011_payee_last_name      VARCHAR2,
    p_total_stl_paid_amt        VARCHAR2,
    p_paid_amt                  GICL_CLM_LOSS_EXP.PAID_AMT%TYPE,
    p_gido_date                 VARCHAR2,
    p_gido_place                VARCHAR2,
    p_item_no                   VARCHAR2,
    p_grouped_item_no           VARCHAR2,
    p_gido_witness1             VARCHAR2,
    p_gido_witness2             VARCHAR2,    
    p_gido_witness3             VARCHAR2,
    p_gido_witness4             VARCHAR2
   )
   
    RETURN populate_reports_tab PIPELINED
IS 
    vrep                        populate_reports_type;
    variables_v_date            VARCHAR2(200);    
    variables_v_currency_sn     VARCHAR2(200);
    variables_v_stl_paid_amt    VARCHAR2(200);
    variables_policy_no         VARCHAR2(200);
    variables_v_date1           VARCHAR2(200);
    variables_v_time            VARCHAR2(200);
    variables_location          VARCHAR2(200);
    
    BEGIN

        variables_v_stl_paid_amt := dh_util.check_protect(NVL(p_total_stl_paid_amt,p_paid_amt),'PHILIPPINE PESO',TRUE); -- added by JEROME.O 3-11-09

        BEGIN
            SELECT TO_CHAR(TO_DATE(p_gido_date,'MM-DD-RRRR'),'fmddth') ||' day of '|| TO_CHAR(TO_DATE(p_gido_date,'MM-DD-RRRR'),'fmMonth, YYYY')  marge
              INTO variables_v_date
              FROM dual;
              
        EXCEPTION
        when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR(-200517,'Invalid claim id.');
        END;
        
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
        
        BEGIN
            SELECT to_char(loss_date,'fmMonth DD , YYYY') date1, to_char(loss_date,'HH:MI AM')  time -- aded by belle 11.15.2011
              INTO variables_v_date1, variables_v_time
              FROM gicl_clm_item
              WHERE claim_id = p_claim_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no; -- added by dexter 09/05/06
        EXCEPTION
            when NO_DATA_FOUND then
              RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
        END;
        
        BEGIN
            SELECT decode(loss_loc1,null,
                   decode(loss_loc2,null,
                   decode(loss_loc3,null,null,loss_loc3),
                   loss_loc2||' '||decode(loss_loc3,null,null,loss_loc3)),
                   loss_loc1||' '||decode(loss_loc2,null,
                   decode(loss_loc3,null,null,loss_loc3),
                   loss_loc2||' '||decode(loss_loc3,null,null,loss_loc3))) location
              INTO variables_location
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
        EXCEPTION
            when NO_DATA_FOUND then
              RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
        END;
        
        vrep.wrd_payee_last_name     := NVL(p_c011_payee_last_name,'__________________________');
        vrep.wrd_paid_amt            := NVL(ltrim(variables_v_stl_paid_amt)||' ('||variables_v_currency_sn -- modified by JEROME.O 3/11/09 
                                          ||ltrim(to_char(NVL(p_total_stl_paid_amt,p_paid_amt),'fm999,999,999,999.00'))||')','___________________________________________________');
        vrep.wrd_company_name        := NVL(GIISP.V('COMPANY_NAME'),'______________________________');
        vrep.wrd_policy_no           := NVL(variables_policy_no,'_______________________________');
        vrep.wrd_date1               := NVL(variables_v_date1,'______________________');
        vrep.wrd_time                := NVL(variables_v_time,'_________________________');
        vrep.wrd_location            := NVL(variables_location,'________________________________'); 
        vrep.wrd_date                := NVL(variables_v_date,'______________________');
        vrep.wrd_place               := NVL(p_gido_place,'________________________________');
        vrep.wrd_witness1            := NVL(p_gido_witness1,'____________________________');
        vrep.wrd_witness2            := NVL(p_gido_witness2,'____________________________');
        vrep.wrd_witness3            := NVL(p_gido_witness3,'____________________________');
        vrep.wrd_witness4            := NVL(p_gido_witness4,'____________________________');
        
        PIPE ROW(vrep);

    END populate_giclr046_dfault; 
    
END populate_giclr046_pkg;
/


