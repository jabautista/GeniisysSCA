CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_PER_PAYEE_GICLR259
    /*
    **  Created by        : Carlo Rubenecia
    **  Date Created      : 06.23.2016
    */
AS
    FUNCTION get_giclr259_details(
        p_payee_no          GIIS_PAYEES.payee_no%TYPE,
        p_payee_class_cd    GIIS_PAYEE_CLASS.payee_class_cd%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_user_id            GIIS_USERS.user_id%TYPE
    ) RETURN giclr259_tab PIPELINED AS
        rep           giclr259_type;
        v_claim_id    gicl_claims.claim_id%TYPE := NULL;        
        v_item_no     GICL_CLM_LOSS_EXP.item_no%TYPE := NULL;
        v_peril_cd    GIIS_PERIL.peril_cd%TYPE := NULL;
    BEGIN
        FOR i IN (SELECT   a.claim_id, b.payee_class_cd||'-'||e.class_desc payee_class,
                           b.payee_no||'-'||decode(b.payee_first_name, '-', b.payee_last_name ,
                           b.payee_last_name||' '||b.payee_first_name||' '||b.payee_middle_name--modified by VJ 090605
                            /*   b.payee_first_name||' '||b.payee_middle_name||' '||b.payee_last_name*/) payee_name,        
                           a.line_cd||'-'|| a.subline_cd||'-'|| a.iss_cd ||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR( a.clm_seq_no,'0000009')) claim_number,
                           a.line_cd||'-'|| a.subline_cd||'-'|| a.pol_iss_cd ||'-'||LTRIM(TO_CHAR( a.issue_yy,'09')) || '-' ||LTRIM(TO_CHAR( a.pol_seq_no,'0000009')) || '-'||LTRIM(TO_CHAR( a.renew_no,'09')) policy_number,
                           a.assured_name,
                           c.item_no, 
                           f.peril_cd,
                           NVL(c.paid_amt,0) paid_amt, 
                           NVL(c.net_amt,0) net_amt, 
                           NVL(c.advise_amt,0) advise_amt, 
                           LTRIM(TO_CHAR( f.peril_cd, '00009'))||'-'||f.peril_name peril, 
                           c.hist_seq_no,  
                           LTRIM(TO_CHAR(d.item_no,'00009'))||'-'|| GET_GPA_ITEM_TITLE(a.claim_id,a.line_cd,d.item_no,d.grouped_item_no) item,
                           c.advice_id, a.dsp_loss_date 
                  FROM GICL_CLAIMS a, 
                       GIIS_PAYEES b,
                       GICL_CLM_LOSS_EXP c,
                       GICL_CLM_ITEM d,
                       GIIS_PAYEE_CLASS e,
                       GIIS_PERIL f
                 WHERE a.claim_id=c.claim_id 
                   AND a.claim_id= d.claim_id
                   AND b.payee_class_cd=e.payee_class_cd
                   AND b.payee_no=c.payee_cd
                   AND b.payee_class_cd=c.payee_class_cd    
                   AND b.payee_no= p_payee_no
                   AND b.payee_class_cd=p_payee_class_cd 
                   AND a.claim_id=d.claim_id
                   AND f.peril_cd=c.peril_cd
                   AND d.item_no= c.item_no
                   AND d.grouped_item_no = c.grouped_item_no
                   AND NVL(c.cancel_sw,'N') ='N'
                   AND f.line_cd= a.line_cd
                   AND CHECK_USER_PER_LINE2(a.line_cd,iss_cd,'GICLS259',p_user_id)=1
                   AND ((TRUNC(a.clm_file_date) >= TO_DATE(p_from_date,'mm/dd/yyyy')
                   AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                     OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                     OR (TRUNC(a.loss_date) >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                   AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                     OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy')))
                 ORDER BY claim_number,c.item_no,f.peril_cd,c.advice_id)
        LOOP
            rep.claim_number        := i.claim_number;
            rep.payee_class            := i.payee_class;
            rep.payee_name            := i.payee_name;
            rep.paid_amount            := TRIM(TO_CHAR(i.paid_amt,'999,999,999,999,999,990.00'));
            rep.net_amount                := TRIM(TO_CHAR(i.net_amt,'999,999,999,999,999,990.00'));
            rep.advise_amount            := TRIM(TO_CHAR(i.advise_amt,'999,999,999,999,999,990.00'));
            rep.history_seq_no            := LTRIM(TO_CHAR(i.hist_seq_no,'009'));
            rep.item_title                := i.item;
            rep.peril                := i.peril;
            IF v_claim_id = i.claim_id THEN
                rep.policy_number    := NULL;
                rep.assured_name    := NULL;
                rep.loss_date    := NULL;
                IF v_item_no = i.item_no THEN
                    rep.item_title    := NULL;
                ELSE
                    v_item_no         := i.item_no;
                END IF;
                IF v_peril_cd = i.peril_cd THEN
                    rep.peril        := NULL;
                ELSE
                    v_peril_cd         := i.peril_cd;
                END IF;
            ELSE
                v_claim_id            := i.claim_id;
                v_item_no             := i.item_no;
                v_peril_cd             := i.peril_cd;
                rep.policy_number    := i.policy_number;
                rep.assured_name    := i.assured_name;
                rep.loss_date        := TO_CHAR(i.dsp_loss_date,'MM-dd-yyyy');
            END IF;
        
            BEGIN
               SELECT line_cd||'-'||iss_cd||'-'||
                      to_char(advice_year)||'-'||LTRIM(TO_CHAR(advice_seq_no,'000009'))
                  INTO rep.advice_no
                  FROM gicl_advice
                 WHERE advice_id = i.advice_id;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   rep.advice_no := NULL;
            END;           
            PIPE ROW(rep);
        END LOOP;
    
    END;
    
END CSV_CLM_PER_PAYEE_GICLR259;
/
