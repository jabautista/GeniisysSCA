CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr041_pkg
AS

/*
**  Created by   :  Belle Bebing
**  Date Created :  11.10.2011
**  Reference By : POPULATE_GICLR041 (GICLS041 - Print Documents) 
**  Description  : Populate GICLR041 for UCPB. 
*/
FUNCTION populate_giclr041_UCPB(
    p_total_stl_paid_amt      VARCHAR2,
    p_c011_paid_amt           VARCHAR2,
    p_claim_id                GICL_CLAIMS.claim_id%TYPE,
    p_gido_place              VARCHAR2,
    p_gido_date               VARCHAR2  
    )
RETURN populate_reports_tab PIPELINED
AS
    vrep                        populate_reports_type;
    variables_v_stl_paid_amt    VARCHAR2(100);
    variables_v_currency_sn     VARCHAR2(10);
    variables_policy_no         VARCHAR2(100);
    variables_assured           VARCHAR2(100);
    variables_claim_no          VARCHAR2(100);
    variables_v_loss_cat_des    VARCHAR2(100);
    
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
            SELECT assured_name
              INTO variables_assured
              FROM gicl_claims
             WHERE claim_id = p_claim_id;
        EXCEPTION
            when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
        END;
        
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
            SELECT a.loss_cat_des
              INTO variables_v_loss_cat_des
              FROM giis_loss_ctgry a, gicl_claims b
             WHERE b.claim_id = p_claim_id
               AND b.loss_cat_cd = a.loss_cat_cd
               AND b.line_cd = a.line_cd;
        EXCEPTION
            when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
        END;         
         
       
            vrep.wrd_company_name    := NVL(GIISP.V('COMPANY_NAME'),'_________________________');
            vrep.wrd_company_address := NVL(GIISP.V('COMPANY_ADDRESS'),'_______________________');
            vrep.wrd_company_company := NVL(GIISP.V('COMPANY_NAME'),'_________________________');
            vrep.wrd_paid_amt        := NVL(ltrim(variables_v_stl_paid_amt)||' ('||variables_v_currency_sn -- modified by JEROME.O 3/11/09 
                                     ||ltrim(to_char(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'fm999,999,999,999.00'))||')','_____________________');
            vrep.wrd_policy_no       := NVL(variables_policy_no,'_________________');
            vrep.wrd_place           := NVL(p_gido_place,'________________');
            vrep.wrd_date            := NVL(to_char(to_date(p_gido_date, 'MM-DD-RRRR'),'fmddth "day of" Month RRRR'),'______________' );
            vrep.wrd_assured         := NVL(variables_assured,'___________________________');
            vrep.wrd_claim_no        := NVL(variables_claim_no,'_________________');
            vrep.wrd_item_title      := NVL(variables_v_loss_cat_des,'_____________________');
       
        PIPE ROW (vrep);
    END populate_giclr041_UCPB;       

END;
/


