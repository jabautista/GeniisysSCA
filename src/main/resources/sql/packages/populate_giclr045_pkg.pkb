CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr045_pkg
AS

   /*
   **  Created by   :  Belle Bebing
   **  Date Created :  11.14.2011
   **  Reference By : POPULATE_GICLR045_CIC (GICLS041 - Print Documents) 
   **  Description  : Populate GICLR045 when VERSION is null. 
   */
FUNCTION populate_giclr045_dfault(
    p_claim_id                  GICL_CLAIMS.claim_id%TYPE,
    p_gido_date                 VARCHAR2,
    p_c007_item_no              GICL_ITEM_PERIL.item_no%TYPE,
    p_c007_grouped_item_no      GICL_ITEM_PERIL.grouped_item_no%TYPE,
    p_total_stl_paid_amt        VARCHAR2,
    p_c011_paid_amt             GICL_CLM_LOSS_EXP.PAID_AMT%TYPE,
    p_gido_witness1             VARCHAR2,
    p_gido_witness2             VARCHAR2,    
    p_gido_witness3             VARCHAR2,
    p_gido_witness4             VARCHAR2
     )
    RETURN populate_reports_tab PIPELINED
IS 
    vrep                        populate_reports_type;
    variables_v_currency_sn     VARCHAR2(100); 
    variables_policy_no         VARCHAR2(100);
    variables_assured           VARCHAR2(100);
    variables_claim_no          VARCHAR2(100);
    variables_v_date2           VARCHAR2(100);
    variables_v_stl_paid_amt    VARCHAR2(100);
    variables_v_date1           VARCHAR2(100);

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
        SELECT TO_CHAR(TO_DATE(p_gido_date,'MM-DD-RRRR'),'fmMonth DD, YYYY') marge
          INTO variables_v_date2
          FROM dual;
    EXCEPTION
        when NO_DATA_FOUND then
       RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
    END;
    
    BEGIN
        SELECT to_char(loss_date,'fmMonth DD , YYYY') 
          INTO variables_v_date1
          FROM gicl_clm_item
          WHERE claim_id = p_claim_id
           AND item_no = p_c007_item_no
           AND grouped_item_no = p_c007_grouped_item_no; -- added by dexter 09/05/06
    EXCEPTION
        when NO_DATA_FOUND then
          RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
    END;
     
    vrep.wrd_company_name    := NVL(GIISP.V('COMPANY_NAME'),'_______________________');
    vrep.wrd_company_address := NVL(GIISP.V('COMPANY_ADDRESS'),'________________________________________');
    vrep.wrd_paid_amt        := NVL(variables_v_currency_sn -- modified by JEROME.O 3/11/09 
                               ||ltrim(to_char(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'fm999,999,999,999.00')),'___________________________________________________');
    vrep.wrd_date            := NVL(variables_v_date2,'______________________');
    vrep.wrd_claim_no        := NVL(variables_claim_no,'______________________________');
    vrep.wrd_paid_amt1       := NVL(variables_v_stl_paid_amt,'___________________');
    vrep.wrd_policy_no       := NVL(variables_policy_no,'____________________________');
    vrep.wrd_date2           := NVL(variables_v_date1,'___________________');
    vrep.wrd_assured         := nvl(variables_assured,'____________________________');
    vrep.wrd_witness1        := nvl(p_gido_witness1,'____________________________');
    vrep.wrd_witness2        := nvl(p_gido_witness2,'____________________________');
    vrep.wrd_witness3        := nvl(p_gido_witness3,'____________________________');
    vrep.wrd_witness4        := nvl(p_gido_witness4,'____________________________');
    
    PIPE ROW(vrep);
  
END populate_giclr045_dfault;

END;
/


