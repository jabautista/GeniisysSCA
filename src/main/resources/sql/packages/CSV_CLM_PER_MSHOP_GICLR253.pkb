CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_PER_MSHOP_GICLR253 AS
/*
**  Created by   : Dren Niebres 
**  Date Created : 03.08.2016
**  Reference By : GICLR253 - Claim Listing per Motorshop
*/
    FUNCTION cf_company_addformula
       RETURN VARCHAR2
    IS
       v_add   giis_parameters.param_value_v%TYPE;
    BEGIN
       SELECT param_value_v
         INTO v_add
         FROM giis_parameters
        WHERE param_name = 'COMPANY_ADDRESS';

       RETURN (v_add);
       RETURN NULL;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
          RETURN (v_add);
       WHEN TOO_MANY_ROWS
       THEN
          v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
          RETURN (v_add);
    END;

    FUNCTION cf_company_nameformula
       RETURN VARCHAR2
    IS
       v_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       SELECT param_value_v
         INTO v_name
         FROM giis_parameters
        WHERE param_name = 'COMPANY_NAME';

       RETURN (v_name);
       RETURN NULL;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
          RETURN (v_name);
       WHEN TOO_MANY_ROWS
       THEN
          v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
          RETURN (v_name);
    END;

    FUNCTION cf_datetypeformula(
      P_FROM_DATE       date,
      P_TO_DATE         date,
      P_AS_OF_DATE      date,
      P_SEARCH_BY       VARCHAR2
    )
       RETURN VARCHAR2
    IS
    BEGIN
    
     IF P_SEARCH_BY = 1 THEN
        IF p_as_of_date IS NOT NULL THEN
            RETURN  ('Claim File Date As of ' || TO_CHAR (p_as_of_date, 'fmMonth DD, RRRR') );
        ELSE
            RETURN ('Claim File Date From '  || TO_CHAR (p_from_date, 'fmMonth DD, RRRR') || ' to ' || TO_CHAR (p_to_date, 'fmMonth DD, RRRR') );
        END IF;
     
     ELSIF P_SEARCH_BY = 2 THEN
        IF p_as_of_date IS NOT NULL THEN
            RETURN  ('Loss Date As of ' || TO_CHAR (p_as_of_date, 'fmMonth DD, RRRR') );
        ELSE
            RETURN ('Loss Date From '  || TO_CHAR (p_from_date, 'fmMonth DD, RRRR') || ' to ' || TO_CHAR (p_to_date, 'fmMonth DD, RRRR') );
        END IF;
     ELSE
        IF p_as_of_date IS NOT NULL THEN
            RETURN ' ';
        ELSE
            RETURN ' ';
        END IF;
     END IF;
     
    END;
    
    FUNCTION populate_giclr253 (
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_SEARCH_BY       VARCHAR2
    )
       RETURN giclr253_tab PIPELINED
    AS
       v_rec   giclr253_type;
    BEGIN
       v_rec.company_name := cf_company_nameformula;
       v_rec.company_address := cf_company_addformula;
       v_rec.date_type := cf_datetypeformula (TO_DATE(p_from_date, 'MM-DD-YYYY'), 
                                                TO_DATE(p_to_date, 'MM-DD-YYYY'), 
                                                TO_DATE(p_as_of_date, 'MM-DD-YYYY'), 
                                                P_SEARCH_BY); 
       PIPE ROW (v_rec);
       RETURN;
    END populate_giclr253;
   
    FUNCTION csv_giclr253 (
      P_PAYEE_CD        VARCHAR2,
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_SEARCH_BY       VARCHAR2
    )
       RETURN giclr253_details_tab PIPELINED
    AS
       v_rec   giclr253_details_type;
    BEGIN
       FOR i IN (SELECT DISTINCT c.payee_no || ' - ' || c.payee_last_name || NVL2(c.payee_first_name,' , ','') || c.payee_first_name motorshop,
                                 a.claim_id,
                                 b.line_cd, b.subline_cd, b.pol_iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no,
                                 b.assured_name,
                                 d.clm_stat_desc,
                                 b.issue_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (b.clm_yy2, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.loa_seq_no, '0009')) loa_number,
                                 TO_CHAR(b.dsp_loss_date, 'MM-DD-RRRR') dsp_loss_date,                                 
                                 TO_CHAR(b.clm_file_date, 'MM-DD-YYYY') clm_file_date,
                                 b.plate_no,
                                 NVL (b.loss_reserve, 0) loss_reserve,
                                 NVL (b.paid_amt, 0) paid_amt
                            FROM gicl_loss_exp_payees a,
                                 gicl_motshop_listing_v b,
                                 giis_payees c,
                                 giis_clm_stat d
                           WHERE a.payee_cd = b.payee_cd
                             AND a.claim_id = b.claim_id
                             AND a.payee_class_cd = c.payee_class_cd
                             AND b.payee_cd = c.payee_no
                             AND a.payee_class_cd IN (
                                               SELECT param_value_v
                                                 FROM giac_parameters
                                                WHERE param_name ='MC_PAYEE_CLASS')
                             AND b.clm_stat_cd = d.clm_stat_cd
                             AND a.payee_cd = NVL (p_payee_cd, a.payee_cd)
                             AND (DECODE(P_SEARCH_BY, 1, b.clm_file_date, 2,b.dsp_loss_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY')
                             AND DECODE(P_SEARCH_BY, 1, b.clm_file_date, 2,b.dsp_loss_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY')
                             OR DECODE(P_SEARCH_BY, 1, b.clm_file_date, 2,b.dsp_loss_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')
                             ))
       LOOP
          v_rec.motorshop := i.motorshop;  
          v_rec.claim_number := get_claim_number(i.claim_id);
          v_rec.policy_number := get_policy_no(get_policy_id(i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no));
          v_rec.assured := i.assured_name;
          v_rec.claim_status := i.clm_stat_desc;
          v_rec.loa_number := i.loa_number;
          v_rec.loss_date := i.dsp_loss_date;
          v_rec.file_date := i.clm_file_date;
          v_rec.plate_no := i.plate_no;
          v_rec.loss_reserve := i.loss_reserve;
          v_rec.loa_amount := i.paid_amt;
                   
          PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;
END CSV_CLM_PER_MSHOP_GICLR253;
/
