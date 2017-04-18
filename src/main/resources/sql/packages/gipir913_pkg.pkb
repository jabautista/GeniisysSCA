CREATE OR REPLACE PACKAGE BODY CPI.GIPIR913_PKG
AS
/*
**  Created by   :  Belle Bebing
**  Date Created : 12.12.2011
**  Reference By : GIPIR913 - 
**  Description  : for UCPB 
*/
FUNCTION populate_gipir913_UCPB(p_policy_id     GIPI_POLBASIC.policy_id%TYPE)
    RETURN report_tab   PIPELINED
AS
    rep         report_type;  
     
    BEGIN
        FOR i IN (SELECT pb.policy_id
                       ,pb.acct_of_cd
                       ,pb.label_tag
                       ,DECODE(ad.designation, NULL, ad.assd_name ||' '|| ad.assd_name2
                             ,ad.designation||' '||ad.assd_name ||' '|| ad.assd_name2) assd_name
                       ,pb.address1
                       ,pb.address2
                       ,pb.address3
                       ,ad.assd_tin
                       ,iv.iss_cd
                       ,iv.prem_seq_no
                       ,iv.iss_cd ||'-'|| TRIM(TO_CHAR(iv.prem_seq_no, '000000000009')) invoice_no
                       ,TO_CHAR(pb.issue_date, 'DD fmMONTH RRRR') date_issued
                       ,LN.line_name
                       ,get_policy_no(pb.policy_id) policy_no -- adpascual - 03-19-2011 - replaced the column for policy no UCPBGEN SR-09160
                       --,pb.line_cd ||'-'|| pb.subline_cd ||'-'|| pb.iss_cd ||'-'|| TRIM(to_char(pb.issue_yy, '09')) ||'-'||
                       --                          TRIM(to_char(pb.pol_seq_no, '0000009')) ||'-'|| TRIM(to_char(pb.renew_no, '09')) policy_no
                       ,pb.endt_iss_cd ||'-'|| TRIM(TO_CHAR(pb.endt_yy, '09')) ||'-'|| TRIM(TO_CHAR(pb.endt_seq_no, '0000009')) endt_no
                       ,DECODE(PB.INCEPT_TAG,'Y','T.B.A.'
                                ,DECODE(pb.endt_type, NULL, TO_CHAR(pb.incept_date, 'DD fmMONTH RRRR')
                                                          , TO_CHAR(pb.eff_date, 'DD fmMONTH RRRR'))) date_from
                       ,DECODE(PB.EXPIRY_TAG,'Y','T.B.A.'
                                ,DECODE(pb.endt_type, NULL,TO_CHAR(pb.expiry_date, 'DD fmMONTH RRRR')
                                                          ,TO_CHAR(pb.endt_expiry_date, 'DD fmMONTH RRRR')))date_to
                       ,DECODE(TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'),'12:00 AM','12:00 AM','12:00 PM','12:00 NOON',TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'))  SUBLINE_SUBLINE_TIME
                       ,pb.tsi_amt
                       ,DECODE(iv.policy_currency, 'Y', cy.short_name, GIISP.V('PESO SHORT NAME')) short_name
                       ,DECODE(iv.policy_currency, 'Y', iv.prem_amt, (iv.prem_amt * iv.currency_rt)) prem_amt
                       ,iy.intm_no ||'/'|| iy.ref_intm_cd intermediary
                       ,iv.currency_cd
                       ,iv.policy_currency
                       ,iv.currency_rt iv_currency_rt
                       ,pb.bank_ref_no
                       ,sl.subline_name
                       ,ci.intrmdry_intm_no
                       ,cy.currency_rt cy_currency_rt
                       ,DECODE(iv.policy_currency, 'Y', cy.currency_desc, (SELECT CURRENCY_DESC FROM GIIS_CURRENCY WHERE MAIN_CURRENCY_CD = 1)) currency_desc
                       ,iy.intm_name
                       ,sl.subline_name class_name
                       ,ROUND(pb.tsi_amt/iv.currency_rt, 2) sum_insured_fc
                       ,(gi.address1||' '||gi.address2||' '||gi.address3) issue_address  
                FROM gipi_polbasic pb
                    , giis_assured ad
                    , gipi_invoice iv
                    , giis_line LN
                    , giis_subline sl
                    , giis_currency cy
                    , gipi_comm_invoice ci
                    , giis_intermediary iy
                    , giis_issource gi -- added by grace   -to get the issue source address 
               WHERE pb.assd_no = ad.assd_no
                 AND pb.policy_id = iv.policy_id
               --  AND pb.policy_id = ci.policy_id  -- removed by grace 04.16.2014 to consider tax endts
                 AND pb.line_cd = LN.line_cd
                 AND pb.line_cd = sl.line_cd
                 AND pb.subline_cd = sl.subline_cd
                 AND iv.currency_cd = cy.main_currency_cd
                 AND iv.iss_cd = ci.iss_cd(+)
                 AND iv.prem_seq_no = ci.prem_seq_no(+) -- added outer join for tax endts   grace 04.16.2014
                 AND ci.intrmdry_intm_no = iy.intm_no(+) -- added outer join for tax endts  grace 04.16.2014
                 AND pb.policy_id = p_policy_id
                 --added by belle 01.24.2012 to get right no.of records
                 --AND iv.iss_cd = ci.iss_cd   -- removed by grace 04.16.2014 duplicate codes above
                 --AND iv.prem_seq_no = ci.prem_seq_no   -- removed by grace 04.16.2014 duplicate codes above
                 AND DECODE(get_iss_add_source('GIPIR913'),'P','HO',iv.iss_cd) = gi.iss_cd  -- added by grace 4.8.2014 
                                                            -- use parameter to check whether to use HO or branch addres in the invoice printout                                                                      
                 )
        LOOP
            rep.policy_id               :=  i.policy_id; 
            rep.acct_of_cd              :=  i.acct_of_cd;   
            rep.label_tag               :=  i.label_tag;
            rep.assd_name               :=  i.assd_name; 
            rep.address1                :=  i.address1; 
            rep.address2                :=  i.address2; 
            rep.address3                :=  i.address3;
            rep.assd_tin                :=  i.assd_tin; 
            rep.iss_cd                  :=  i.iss_cd;
            rep.prem_seq_no             :=  i.prem_seq_no;
            rep.invoice_no              :=  i.invoice_no; 
            rep.date_issued             :=  i.date_issued;                 
            rep.line_name               :=  i.line_name; 
            rep.policy_no               :=  i.policy_no; 
            rep.endt_no                 :=  i.endt_no; 
            rep.date_from               :=  i.date_from; 
            rep.date_to                 :=  i.date_to; 
            rep.subline_subline_time    :=  i.subline_subline_time; 
            rep.tsi_amt                 :=  i.tsi_amt; 
            rep.short_name              :=  i.short_name; 
            rep.prem_amt                :=  i.prem_amt; 
            rep.intermediary            :=  i.intermediary; 
            rep.currency_cd             :=  i.currency_cd; 
            rep.policy_currency         :=  i.policy_currency; 
            rep.iv_currency_rt          :=  i.iv_currency_rt;       
            rep.bank_ref_no             :=  i.bank_ref_no; 
            rep.subline_name            :=  i.subline_name; 
            rep.intrmdry_intm_no        :=  i.intrmdry_intm_no; 
            rep.cy_currency_rt          :=  i.cy_currency_rt; 
            rep.currency_desc           :=  i.currency_desc; 
            rep.intm_name               :=  i.intm_name; 
            rep.class_name              :=  i.class_name; 
            rep.sum_insured_fc          :=  i.sum_insured_fc; 
            rep.assd_name2              :=  GIIS_ASSURED_PKG.get_assd_name_GIPIR913(i.acct_of_cd, i.label_tag);              
            rep.cf_prem_label           :=  GIPIR913_PKG.cf_premlabelformula(i.policy_id, i.iss_cd, i.prem_seq_no);         
            rep.cf_prem_amt             :=  GIPIR913_PKG.cf_premamtformula(i.policy_id, i.iss_cd, i.prem_seq_no); 
            rep.company_tin             :=  GIISP.v('COMPANY_TIN');
            rep.cf_BIR_permit_no        :=  GIACP.v('BIR_PERMIT_NO');
            rep.issue_address           :=  i.issue_address;   -- added by grace 04.08.2014  to get the issue address from giis_issource
            PIPE ROW (rep);
        END LOOP; 
--        RETURN; 
    END populate_gipir913_UCPB;
    
FUNCTION populate_gipir913C_UCPB(p_policy_id     GIPI_POLBASIC.policy_id%TYPE)
    RETURN report_tab   PIPELINED
AS
    rep         report_type;  
     
    BEGIN
        FOR i IN (SELECT DISTINCT  pb.policy_id
                       ,pb.acct_of_cd
                       ,pb.label_tag
                       ,DECODE(ad.designation, NULL, ad.assd_name ||' '|| ad.assd_name2
                             ,ad.designation||' '||ad.assd_name ||' '|| ad.assd_name2) assd_name
                       ,pb.address1
                       ,pb.address2
                       ,pb.address3
                       ,ad.assd_tin
                       ,iv.iss_cd
                       --,iv.prem_seq_no
                       --,iv.iss_cd ||'-'|| TRIM(to_char(iv.prem_seq_no, '000000000009')) invoice_no
                       ,TO_CHAR(pb.issue_date, 'DD fmMONTH RRRR') date_issued
                       ,LN.line_name
                       ,pb.line_cd ||'-'|| pb.subline_cd ||'-'|| pb.iss_cd ||'-'|| TRIM(TO_CHAR(pb.issue_yy, '09')) ||'-'||
                                                 TRIM(TO_CHAR(pb.pol_seq_no, '0000009')) ||'-'|| TRIM(TO_CHAR(pb.renew_no, '09')) policy_no
                       ,pb.endt_iss_cd ||'-'|| TRIM(TO_CHAR(pb.endt_yy, '09')) ||'-'|| TRIM(TO_CHAR(pb.endt_seq_no, '0000009')) endt_no
                       ,DECODE(PB.INCEPT_TAG,'Y','T.B.A.'
                                ,DECODE(pb.endt_type, NULL, TO_CHAR(pb.incept_date, 'DD fmMONTH RRRR')
                                                          , TO_CHAR(pb.eff_date, 'DD fmMONTH RRRR'))) date_from
                       ,DECODE(PB.EXPIRY_TAG,'Y','T.B.A.'
                                ,DECODE(pb.endt_type, NULL,TO_CHAR(pb.expiry_date, 'DD fmMONTH RRRR')
                                                          ,TO_CHAR(pb.endt_expiry_date, 'DD fmMONTH RRRR')))date_to
                       ,DECODE(TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'),'12:00 AM','12:00 AM','12:00 PM','12:00 NOON',TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'))  SUBLINE_SUBLINE_TIME
                       ,pb.tsi_amt
                       ,DECODE(iv.policy_currency, 'Y', cy.short_name, GIISP.V('PESO SHORT NAME')) short_name
                       ,DECODE(iv.policy_currency, 'Y', iv.prem_amt, (iv.prem_amt * iv.currency_rt)) prem_amt
                       --,iy.intm_no ||'/'|| iy.ref_intm_cd intermediary
                       ,iv.currency_cd
                       ,iv.policy_currency
                       ,iv.currency_rt iv_currency_rt
                       ,pb.bank_ref_no
                       ,sl.subline_name
                       --,ci.intrmdry_intm_no
                       ,cy.currency_rt cy_currency_rt
                       ,DECODE(iv.policy_currency, 'Y', cy.currency_desc, (SELECT CURRENCY_DESC FROM GIIS_CURRENCY WHERE MAIN_CURRENCY_CD = 1)) currency_desc
                       --,iy.intm_name
                       ,sl.subline_name class_name
                       ,ROUND(pb.tsi_amt/iv.currency_rt, 2) sum_insured_fc
                       ,(gi.address1||' '||gi.address2||' '||gi.address3) issue_address  
                FROM gipi_polbasic pb
                    , giis_assured ad
                    , gipi_invoice iv
                    , giis_line LN
                    , giis_subline sl
                    , giis_currency cy
                    , gipi_comm_invoice ci
                    , giis_intermediary iy
                    , giis_issource gi 
               WHERE pb.assd_no = ad.assd_no
                 AND pb.policy_id = iv.policy_id
                 AND pb.policy_id = ci.policy_id
                 AND pb.line_cd = LN.line_cd
                 AND pb.line_cd = sl.line_cd
                 AND pb.subline_cd = sl.subline_cd
                 AND iv.currency_cd = cy.main_currency_cd
                 AND iv.iss_cd = ci.iss_cd
                 AND iv.prem_seq_no = ci.prem_seq_no
                 AND ci.intrmdry_intm_no = iy.intm_no
                 AND pb.policy_id = p_policy_id
                 AND DECODE(get_iss_add_source('GIPIR913C'),'P','HO',iv.iss_cd) = gi.iss_cd  -- added by grace 4.8.2014 
                                                            -- use parameter to check whether to use HO or branch addres in the invoice printout
                 )
        LOOP
            rep.policy_id               :=  i.policy_id; 
            rep.acct_of_cd              :=  i.acct_of_cd;   
            rep.label_tag               :=  i.label_tag;
            rep.assd_name               :=  i.assd_name; 
            rep.address1                :=  i.address1; 
            rep.address2                :=  i.address2; 
            rep.address3                :=  i.address3;
            rep.assd_tin                :=  i.assd_tin; 
            rep.iss_cd                  :=  i.iss_cd;
            --rep.prem_seq_no             :=  i.prem_seq_no;
            --rep.invoice_no              :=  i.invoice_no; 
            rep.date_issued             :=  i.date_issued;                 
            rep.line_name               :=  i.line_name; 
            rep.policy_no               :=  i.policy_no; 
            rep.endt_no                 :=  i.endt_no; 
            rep.date_from               :=  i.date_from; 
            rep.date_to                 :=  i.date_to; 
            rep.subline_subline_time    :=  i.subline_subline_time; 
            rep.tsi_amt                 :=  i.tsi_amt; 
            rep.short_name              :=  i.short_name; 
            rep.prem_amt                :=  i.prem_amt; 
            --rep.intermediary            :=  i.intermediary; 
            rep.currency_cd             :=  i.currency_cd; 
            rep.policy_currency         :=  i.policy_currency; 
            rep.iv_currency_rt          :=  i.iv_currency_rt;       
            rep.bank_ref_no             :=  i.bank_ref_no; 
            rep.subline_name            :=  i.subline_name; 
            --rep.intrmdry_intm_no        :=  i.intrmdry_intm_no; 
            rep.cy_currency_rt          :=  i.cy_currency_rt; 
            rep.currency_desc           :=  i.currency_desc; 
            --rep.intm_name               :=  i.intm_name; 
            rep.class_name              :=  i.class_name; 
            rep.sum_insured_fc          :=  i.sum_insured_fc; 
            rep.assd_name2              :=  GIIS_ASSURED_PKG.get_assd_name_GIPIR913(i.acct_of_cd, i.label_tag);              
            --rep.cf_prem_label           := GIPIR913_PKG.cf_premlabelformula(i.policy_id, i.iss_cd, i.prem_seq_no);         
            --rep.cf_prem_amt             := GIPIR913_PKG.cf_premamtformula(i.policy_id, i.iss_cd, i.prem_seq_no); 
            rep.company_tin             :=  GIISP.v('COMPANY_TIN');
            rep.cf_BIR_permit_no        :=  GIACP.v('BIR_PERMIT_NO');
            rep.issue_address           :=  i.issue_address;   -- added by grace 04.08.2014  to get the issue address from giis_issource
            PIPE ROW (rep);
        END LOOP; 
        RETURN; 
    END populate_gipir913C_UCPB;  

FUNCTION populate_gipir913D (p_policy_id     GIPI_POLBASIC.policy_id%TYPE)
    RETURN report_tab   PIPELINED
AS
    rep         report_type;  
     
    BEGIN
        FOR i IN (SELECT DISTINCT  pb.policy_id
                           ,ad.assd_no ||' - '|| DECODE(ad.designation, NULL, ad.assd_name ||' '|| ad.assd_name2 ,ad.designation||' '||ad.assd_name ||' '|| ad.assd_name2) assd_name
                           ,pb.address1
                           ,pb.address2
                           ,pb.address3
                           ,pb.line_cd ||'-'|| pb.subline_cd ||'-'|| pb.iss_cd ||'-'|| TRIM(TO_CHAR(pb.issue_yy, '09')) ||'-'||
                            TRIM(TO_CHAR(pb.pol_seq_no, '0000009')) ||'-'|| TRIM(TO_CHAR(pb.renew_no, '09')) policy_no
                           ,pb.tsi_amt
                           ,DECODE(iv.policy_currency, 'Y', cy.short_name, GIISP.V('PESO SHORT NAME')) short_name
                           ,DECODE(iv.policy_currency, 'Y', SUM(iv.prem_amt), SUM(iv.prem_amt * iv.currency_rt)) prem_amt
                           ,pb.eff_date
                     FROM gipi_polbasic pb
                         ,giis_assured ad
                         ,gipi_invoice iv
                         ,giis_line LN
                         ,giis_subline sl
                         ,giis_currency cy
                         ,gipi_comm_invoice ci
                         ,giis_intermediary iy
                    WHERE pb.assd_no = ad.assd_no
                      AND pb.policy_id = iv.policy_id
                      AND pb.policy_id = ci.policy_id
                      AND pb.line_cd = LN.line_cd
                      AND pb.line_cd = sl.line_cd
                      AND pb.subline_cd = sl.subline_cd
                      AND iv.currency_cd = cy.main_currency_cd
                      AND iv.iss_cd = ci.iss_cd
                      AND iv.prem_seq_no = ci.prem_seq_no
                      AND ci.intrmdry_intm_no = iy.intm_no
                      AND pb.policy_id = p_policy_id
                 GROUP BY pb.policy_id, ad.assd_no, ad.designation ,ad.assd_name,ad.assd_name2
                       ,pb.address1, pb.address2, pb.address3, pb.line_cd, pb.subline_cd, pb.iss_cd
                       ,pb.issue_yy, pb.pol_seq_no, pb.renew_no, pb.tsi_amt, iv.policy_currency, cy.short_name, pb.eff_date
                 )
        LOOP
            rep.policy_id               :=  i.policy_id; 
            rep.assd_name               :=  i.assd_name; 
            rep.address1                :=  i.address1; 
            rep.address2                :=  i.address2; 
            rep.address3                :=  i.address3;
            rep.policy_no               :=  i.policy_no; 
            rep.tsi_amt                 :=  i.tsi_amt; 
            rep.short_name              :=  i.short_name; 
            rep.prem_amt                :=  i.prem_amt; 
            rep.eff_date                := i.eff_date;
            
            PIPE ROW (rep);
        END LOOP; 
        RETURN; 
    END populate_gipir913D;      
    
FUNCTION cf_premlabelformula (
    p_policy_id   GIPI_POLBASIC.policy_id%TYPE,
    p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
    p_prem_seq_no GIPI_INVOICE.prem_seq_no%TYPE
    )
    RETURN VARCHAR2
IS
    v_premlabel VARCHAR2(100):='PREMIUM';
    v_count     NUMBER := 0;

    BEGIN
        FOR i IN (SELECT B.TAXABLE_PREM_AMT, DECODE(B.TAXABLE_PREM_AMT,0,DECODE(B.TAXEXEMPT_PREM_AMT,0,'PREMIUM (ZERO RATED SALES)','PREMIUM (VAT EXEMPT SALES)'),'PREMIUM (VATABLE)') PREM_LABEL, A.prem_seq_no
                    --INTO v_premlabel
                    FROM GIPI_INVOICE A, GIPI_INV_TAX B
                   WHERE 1=1
                     AND A.ISS_CD = B.ISS_CD
                     AND A.PREM_SEQ_NO = B.PREM_SEQ_NO
                     AND A.POLICY_ID = p_policy_id
                     AND B.TAX_CD = GIACP.N('EVAT')
                     AND A.ISS_CD = p_iss_cd
                     AND A.PREM_SEQ_NO = p_prem_seq_no )
        LOOP
            v_count     := v_count + 1;
            v_premlabel := i.prem_label;
        END LOOP;     
                
        IF v_count = 0 THEN
            v_premlabel := 'PREMIUM (VAT EXEMPT)';
        END IF;
            
         RETURN v_premlabel;  
    END;


FUNCTION cf_premamtformula (
    p_policy_id     GIPI_POLBASIC.policy_id%TYPE,
    p_iss_cd      GIPI_INVOICE.iss_cd%TYPE,
    p_prem_seq_no GIPI_INVOICE.prem_seq_no%TYPE
   )
    RETURN VARCHAR2
IS
    v_premamt VARCHAR2(20);
BEGIN
    FOR A IN (SELECT policy_currency, currency_rt, LTRIM(TO_CHAR(DECODE(policy_currency, 'Y', NVL(prem_amt,0), (NVL(prem_amt,0) * currency_rt)),'9,999,999,999.99')) /*LTRIM(TO_CHAR(NVL(prem_amt,0),'9,999,999,999.99'))*/ prem_amt, iss_cd,prem_seq_no --replace the old code by steven 1.24.2013; base on SR 0011965 
                FROM gipi_invoice
               WHERE policy_id = p_policy_id
                 AND iss_cd = p_iss_cd
                 AND prem_seq_no = p_prem_seq_no)
    LOOP
        v_premamt := A.prem_amt;
        FOR b IN (SELECT NVL(DECODE(TAXABLE_PREM_AMT,0,DECODE(TAXEXEMPT_PREM_AMT,0,ZERORATED_PREM_AMT,TAXEXEMPT_PREM_AMT),TAXABLE_PREM_AMT),0) PREM_AMT
                    FROM gipi_inv_tax
                   WHERE iss_cd = A.iss_cd
                     AND prem_seq_no = A.prem_seq_no
                     AND tax_cd = giacp.n('EVAT'))
        LOOP
            IF A.policy_currency = 'Y' THEN --added by steven 1.24.2013; base on SR 0011965
                v_premamt := LTRIM(TO_CHAR(b.prem_amt,'9,999,999,999.99'));
            ELSE
                v_premamt := LTRIM(TO_CHAR(b.prem_amt * A.currency_rt,'9,999,999,999.99'));
            END IF;
        END LOOP;
    END LOOP;

    RETURN v_premamt;  
END;

    /*Created by: steven
    * Date: 02.04.2013
    * Description: for GIPIR913B Package.            
    */
FUNCTION populate_pack_gipir913B(p_policy_id   GIPI_POLBASIC.policy_id%TYPE)
RETURN report_pack_tab   PIPELINED
AS
    rep        report_pack_type;
BEGIN
    FOR i IN (SELECT 1 ROWCOUNT, pb.pack_policy_id
                       ,pb.acct_of_cd
                       ,pb.label_tag
                       ,pb.assd_no
                       ,DISPLAY_ASSURED(pb.assd_no) assd_name
                       ,pb.address1
                       ,pb.address2
                       ,pb.address3
                       ,ad.assd_tin
                       ,iv.iss_cd ||'-'||TRIM(TO_CHAR(iv.prem_seq_no, '000000000009')) invoice_no
                       ,TO_CHAR(pb.issue_date, 'DD fmMONTH RRRR') date_issued
                       ,LN.line_name
                       ,pb.line_cd ||'-'|| pb.subline_cd ||'-'|| pb.iss_cd ||'-'|| TRIM(TO_CHAR(pb.issue_yy, '09')) ||'-'||
                                                 TRIM(TO_CHAR(pb.pol_seq_no, '0000009')) ||'-'|| TRIM(TO_CHAR(pb.renew_no, '09')) policy_no
                       ,pb.endt_iss_cd ||'-'|| TRIM(TO_CHAR(pb.endt_yy, '09') )||'-'|| TRIM(TO_CHAR(pb.endt_seq_no, '0000009')) endt_no
                       ,DECODE(PB.INCEPT_TAG,'Y','T.B.A.'
                                ,DECODE(pb.endt_type, NULL, TO_CHAR(pb.incept_date, 'DD fmMONTH RRRR')
                                                          , TO_CHAR(pb.eff_date, 'DD fmMONTH RRRR'))) date_from
                       ,DECODE(PB.EXPIRY_TAG,'Y','T.B.A.'
                                ,DECODE(pb.endt_type, NULL,TO_CHAR(pb.expiry_date, 'DD fmMONTH RRRR')
                                                          ,TO_CHAR(pb.endt_expiry_date, 'DD fmMONTH RRRR')))date_to
                       ,DECODE(TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'),'12:00 AM','12:00 AM','12:00 PM','12:00 noon',TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'))  SUBLINE_SUBLINE_TIME
                       ,pb.tsi_amt
                       ,DECODE(iv.policy_currency, 'Y', cy.short_name, GIISP.V('PESO SHORT NAME')) short_name
                       --,DECODE(iv.policy_currency, 'Y', iv.prem_amt, (pb.prem_amt)) prem_amt replaced by: Nica 02.14.2013
                       ,DECODE(iv.policy_currency, 'Y', iv.prem_amt, (iv.prem_amt * iv.currency_rt)) prem_amt
                       ,iy.intm_no ||'/'|| iy.ref_intm_cd intermediary
                       ,iv.currency_cd
                       ,iv.policy_currency
                       ,iv.currency_rt iv_currency_rt
                       ,pb.bank_ref_no
                       ,sl.subline_name
                       ,ci.intrmdry_intm_no
                       ,cy.currency_rt cy_currency_rt
                       ,DECODE(iv.policy_currency, 'Y', cy.currency_desc, (SELECT CURRENCY_DESC FROM GIIS_CURRENCY WHERE MAIN_CURRENCY_CD = 1)) currency_desc
                       ,iy.intm_name
                       ,sl.subline_name class_name
                       ,ROUND(pb.tsi_amt/iv.currency_rt, 2) sum_insured_fc
                       ,(SELECT GIIS_ASSURED_PKG.get_assd_name_GIPIR913(pb.acct_of_cd, pb.label_tag)
                            FROM DUAL) assd_name2
                       ,(gi.address1||' '||gi.address2||' '||gi.address3) issue_address     
                FROM gipi_pack_polbasic pb
                    , giis_assured ad
                    , gipi_pack_invoice iv
                    , giis_line LN
                    , giis_subline sl
                    , giis_currency cy
                    , gipi_comm_invoice ci
                    , giis_intermediary iy
                    , giis_issource gi
                WHERE pb.assd_no = ad.assd_no
                AND pb.pack_policy_id = iv.policy_id
                --AND pb.pack_policy_id = ci.policy_id
                AND pb.line_cd = LN.line_cd
                AND pb.line_cd = sl.line_cd
                AND pb.subline_cd = sl.subline_cd
                AND iv.currency_cd = cy.main_currency_cd
                AND iv.iss_cd = ci.iss_cd(+) -- bonok :: 9.15.2015 :: UCPB SR 20349
                AND iv.prem_seq_no = ci.prem_seq_no(+) -- bonok :: 9.15.2015 :: UCPB SR 20349
                AND ci.intrmdry_intm_no = iy.intm_no(+) -- bonok :: 9.15.2015 :: UCPB SR 20349
                AND DECODE(get_iss_add_source('GIPIR913B'),'P','HO',iv.iss_cd) = gi.iss_cd  -- added by grace 4.8.2014 
                                                            -- use parameter to check whether to use HO or branch addres in the invoice printout

                AND pb.pack_policy_id =  p_policy_id)
    LOOP
        rep.pack_policy_id          := i.pack_policy_id;
        rep.acct_of_cd              := i.acct_of_cd;
        rep.label_tag               := i.label_tag;
        rep.assd_no                   := i.assd_no;
        rep.assd_name               := i.assd_name;
        rep.address1                := i.address1;
        rep.address2                := i.address2;
        rep.address3                := i.address3;
        rep.assd_tin                    := i.assd_tin;
        rep.invoice_no              := i.invoice_no;
        rep.date_issued             := i.date_issued;
        rep.line_name               := i.line_name;
        rep.policy_no               := i.policy_no;
        rep.endt_no                 := i.endt_no;
        rep.date_from               := i.date_from;
        rep.date_to                 := i.date_to;
        rep.subline_subline_time    := i.subline_subline_time;
        rep.tsi_amt                 := i.tsi_amt;
        rep.short_name              := i.short_name;
        rep.prem_amt                := i.prem_amt;
        rep.intermediary            := i.intermediary;
        rep.currency_cd             := i.currency_cd;   
        rep.policy_currency         := i.policy_currency;
        rep.iv_currency_rt          := i.iv_currency_rt;
        rep.bank_ref_no             := i.bank_ref_no;
        rep.subline_name            := i.subline_name;
        rep.intrmdry_intm_no        := i.intrmdry_intm_no;
        rep.cy_currency_rt          := i.cy_currency_rt;
        rep.currency_desc           := i.currency_desc;
        rep.intm_name               := i.intm_name;
        rep.class_name              := i.class_name;
        rep.sum_insured_fc          := i.sum_insured_fc;
        rep.assd_name2              := i.assd_name2;
        rep.issue_address           := i.issue_address;   -- added by grace 04.08.2014  to get the issue address from giis_issource        
        PIPE ROW (rep);
    END LOOP;
END;
    
END GIPIR913_PKG; 
/

