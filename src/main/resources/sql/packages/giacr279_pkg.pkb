CREATE OR REPLACE PACKAGE BODY CPI.GIACR279_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   07.16.2013
     ** Referenced By:  GIACR279 - Statement of Account Losses Recoverable
     **/
    
     FUNCTION populate_report(
        p_as_of_date        VARCHAR2,
        p_cut_off_date      VARCHAR2,
        p_ri_cd             giac_loss_rec_soa_ext.RI_CD%type,
        p_line_cd           giac_loss_rec_soa_ext.LINE_CD%type,
        p_payee_type        giac_loss_rec_soa_ext.PAYEE_TYPE%type,
        p_payee_type2       giac_loss_rec_soa_ext.PAYEE_TYPE%type,
        p_user              giac_loss_rec_soa_ext.USER_ID%type
    ) RETURN report_tab PIPELINED
    AS
        rep             report_type;
        v_no_record     BOOLEAN := true;
    BEGIN
        rep.print_band  := 'N';
        
        SELECT PARAM_VALUE_V 
          INTO rep.company_name
          FROM giac_parameters
         WHERE param_name = 'COMPANY_NAME';
         
        SELECT PARAM_VALUE_V 
          INTO rep.company_address
          FROM GIAC_PARAMETERS 
         WHERE PARAM_NAME = 'COMPANY_ADDRESS'; 
         
        rep.as_of   := 'As of ' || TO_CHAR(TO_DATE(p_as_of_date, 'MM-DD-RRRR'), 'fmMonth dd, yyyy');
        rep.cut_off := 'Cut off ' || TO_CHAR(TO_DATE(p_cut_off_date, 'MM-DD-RRRR'), 'fmMonth dd, yyyy');
        
        FOR i IN  ( SELECT ri_cd, ri_name, line_cd, line_name, claim_no, fla_no,        
                           policy_no, assd_name, fla_date, as_of_date, cut_off_date, 
                           payee_type,  amount_due, --081406 rochelle       
                           currency_cd, convert_rate, orig_curr_rate,
                           assd_no --Dren 05.24.2016 SR-5349
                      FROM giac_loss_rec_soa_ext
                     WHERE 1=1
                       AND amount_due <> 0
                       AND TRUNC(as_of_date) = TO_DATE(P_AS_OF_DATE, 'MM-DD-RRRR')
                       AND TRUNC(cut_off_date) = TO_DATE(P_CUT_OFF_DATE, 'MM-DD-RRRR')
                       AND ri_cd = nvl(P_RI_CD, ri_cd) --nvl added by rochelle 07252006
                       AND line_cd = nvl(P_LINE_CD, line_cd)
                       AND user_id = P_USER         --added by rochelle 07272006
                       AND (payee_type = P_PAYEE_TYPE --added by nestor2192008
                            OR payee_type  = P_PAYEE_TYPE2) 
                     ORDER BY ri_cd, line_cd, claim_no, fla_no)
        LOOP
            v_no_record         := FALSE;
            rep.print_band      := 'Y';
            rep.ri_cd           := i.ri_cd;
            rep.ri_name         := i.ri_name;
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.claim_no        := i.claim_no;
            rep.fla_no          := i.fla_no;
            rep.policy_no       := i.policy_no;
            rep.assd_no         := i.assd_no; --Dren 05.24.2016 SR-5349
            rep.assd_name       := i.assd_name;
            rep.fla_date        := i.fla_date;
            rep.as_of_date      := i.as_of_date;
            rep.cut_off_date    := i.cut_off_date;
            rep.payee_type      := i.payee_type;
            rep.amount_due      := i.amount_due;
            rep.currency_cd     := i.currency_cd;
            rep.convert_rate    := i.convert_rate;
            rep.orig_curr_rate  := i.orig_curr_rate;
            rep.cf_amount_due   := i.amount_due;
            
            PIPE ROW (rep); 
        END LOOP;
        
        IF v_no_record THEN
            PIPE ROW(rep);
        END IF;
        
    END populate_report;    

END GIACR279_PKG;
/


