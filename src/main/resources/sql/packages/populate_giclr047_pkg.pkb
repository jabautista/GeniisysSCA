CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr047_pkg
AS

/*
**  Created by   :  Belle Bebing
**  Date Created :  11.23.2011
**  Reference By : POPULATE_GICLR047 (GICLS041 - Print Documents) 
**  Description  : Populate default GICLR047 - if VERSION is NULL 
*/
FUNCTION populate_giclr047_dfault(
    p_claim_id              GICL_CLAIMS.claim_id%TYPE,
    p_total_stl_paid_amt    VARCHAR2,
    p_c011_paid_amt         VARCHAR2,
    p_payee_last_name       VARCHAR2,
    p_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE
    )
    
RETURN populate_reports_tab PIPELINED
AS
    vrep                        populate_reports_type;
    variables_v_stl_paid_amt    VARCHAR2(50);
    variables_v_currency_sn     VARCHAR2(50);
    variables_company_name      VARCHAR2(200);
    variables_cargo_desc        VARCHAR2(200);
    variables_mail_addrs        VARCHAR2(200);

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
              NULL;
            when TOO_MANY_ROWS then
              NULL;
        END;
        
        BEGIN
            SELECT a.cargo_class_desc
              INTO variables_cargo_desc
              FROM giis_cargo_class a, gicl_cargo_dtl b
             WHERE a.cargo_class_cd = b.cargo_class_cd
               AND b.claim_id = p_claim_id;
        EXCEPTION
            when NO_DATA_FOUND then
                NULL;
        END;
        
        BEGIN
            SELECT decode(mail_addr1,null,
                   decode(mail_addr2,null,
                   decode(mail_addr3,null,null,mail_addr3),
                          mail_addr2||' '||decode(mail_addr3,null,null,mail_addr3)),
                          mail_addr1||' '||decode(mail_addr2,null,
                   decode(mail_addr3,null,null,mail_addr3),
                          mail_addr2||' '||decode(mail_addr3,null,null,mail_addr3))) location
             INTO variables_mail_addrs
             FROM giis_assured a, gicl_claims b
            WHERE b.claim_id = p_claim_id 
              AND b.assd_no = a.assd_no ;
        EXCEPTION
            when NO_DATA_FOUND then
                RAISE_APPLICATION_ERROR (-200517, 'Invalid claim id.');
        END; 

        vrep.wrd_paid_amt            := NVL(ltrim(nvl(variables_v_stl_paid_amt,'ZERO'))||' ONLY ('||variables_v_currency_sn -- modified by JEROME.O 3/11/09 
                                          ||ltrim(to_char(NVL(p_total_stl_paid_amt,p_c011_paid_amt),'fm999,999,999,999.00'))||')','______________________');
        vrep.wrd_payee_last_name     := NVL(p_payee_last_name,'_____________________');
        vrep.wrd_mail_addrs          := NVL(variables_mail_addrs,'____________________');
        vrep.wrd_company_name        := NVL(variables_company_name,'_______________________');
        vrep.wrd_cargo_desc          := NVL(variables_cargo_desc,'_____________________');
        vrep.wrd_yr                  := NVL(TO_CHAR(sysdate,'YYYY'),'________');
        
        PIPE ROW (vrep);
    END;

END;
/


