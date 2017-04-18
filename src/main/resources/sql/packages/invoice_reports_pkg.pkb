CREATE OR REPLACE PACKAGE BODY CPI.INVOICE_REPORTS_PKG AS

    FUNCTION get_girir009_records (p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
      RETURN girir009_rec_tab PIPELINED IS
        v_rec       girir009_rec_type;
    BEGIN
      FOR i IN (
        SELECT pb.policy_id policy_id
               ,pb.acct_of_cd acct_of_cd
               ,pb.label_tag label_tag
               ,decode(ad.designation, NULL, ad.assd_name ||' '|| ad.assd_name2
                     ,ad.designation||' '||ad.assd_name ||' '|| ad.assd_name2) assd_name
               ,pb.address1 address1
               ,pb.address2 address2
               ,pb.address3 address3
               ,ad.assd_tin assd_tin
               ,iv.iss_cd ||'-'|| to_char(iv.prem_seq_no, '000000000009') invoice_no
               ,to_char(pb.issue_date, 'DD fmMONTH RRRR') date_issued
               ,ln.line_name line_name
               /*,pb.line_cd ||'-'|| pb.subline_cd ||'-'|| pb.iss_cd ||'-'|| to_char(pb.issue_yy, '09') ||'-'||
                                         to_char(pb.pol_seq_no, '0000009') ||'-'|| to_char(pb.renew_no, '09') policy_no*/
               --,get_policy_no(pb.policy_id) policy_no
               ,pb.endt_iss_cd ||'-'|| to_char(pb.endt_yy, '09') ||'-'|| to_char(pb.endt_seq_no, '0000009') endt_no
               ,DECODE(PB.INCEPT_TAG,'Y','T.B.A.'
                        ,DECODE(pb.endt_type, NULL, TO_CHAR(pb.incept_date, 'DD fmMONTH RRRR')
                                                  , TO_CHAR(pb.eff_date, 'DD fmMONTH RRRR'))) date_from
               ,DECODE(PB.EXPIRY_TAG,'Y','T.B.A.'
                        ,DECODE(pb.endt_type, NULL,TO_CHAR(pb.expiry_date, 'DD fmMONTH RRRR')
                                                  ,TO_CHAR(pb.endt_expiry_date, 'DD fmMONTH RRRR')))date_to
               ,DECODE(TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'),'12:00 AM','12:00 AM','12:00 PM','12:00 noon',TO_CHAR(TO_DATE(sl.subline_time,'SSSSS'),'HH:MI AM'))  SUBLINE_SUBLINE_TIME
               ,pb.tsi_amt
               ,DECODE(iv.policy_currency, NULL, 'PHP', cy.short_name) short_name
               ,DECODE(iv.policy_currency, NULL, iv.prem_amt * iv.currency_rt, iv.prem_amt) prem_amt
               ,iv.currency_cd
               ,iv.policy_currency
               ,iv.currency_rt
               ,pb.bank_ref_no
               ,sl.subline_name
               ,ci.intrmdry_intm_no
               ,DECODE(iv.policy_currency, NULL, 'PHILIPPINE PESO', cy.currency_desc) currency_desc
               ,(ln.line_name || ' - ' || sl.subline_name) class_name
               /*,(SELECT GIIS_ASSURED_PKG.get_assd_name_GIPIR913(pb.acct_of_cd, pb.label_tag)
                    FROM DUAL) assd_name2*/
               , DECODE(iv.policy_currency, NULL, iv.ri_comm_amt * iv.currency_rt, iv.ri_comm_amt) ri_comm_amt1
               , DECODE(iv.policy_currency, NULL, iv.ri_comm_vat * iv.currency_rt, NVL(iv.ri_comm_vat,0)) ri_comm_vat1
               , ri.ri_name
               , iv.ri_comm_amt
               , iv.ri_comm_vat
        FROM gipi_polbasic pb
            , giis_assured ad
            , gipi_invoice iv
            , giis_line ln
            , giis_subline sl
            , giis_currency cy
            , gipi_comm_invoice ci
            , giri_inpolbas ip
            , giis_reinsurer ri
        WHERE pb.assd_no = ad.assd_no
        AND pb.policy_id = iv.policy_id
        AND pb.line_cd = ln.line_cd
        AND pb.line_cd = sl.line_cd
        AND pb.subline_cd = sl.subline_cd
        AND iv.currency_cd = cy.main_currency_cd
        AND iv.iss_cd = ci.iss_cd(+)
        AND iv.prem_seq_no = ci.prem_seq_no(+)
        AND pb.policy_id = ip.policy_id
        AND ip.ri_cd = ri.ri_cd
        AND pb.policy_id = p_policy_id
      ) LOOP
        v_rec.policy_id     := i.policy_id;
        v_rec.acct_of_cd    := i.acct_of_cd;
        v_rec.label_tag     := i.label_tag;
        v_rec.assd_name        := i.assd_name;
        v_rec.address1        := i.address1;
        v_rec.address2        := i.address2;
        v_rec.address3        := i.address3;
        v_rec.assd_tin        := i.assd_tin;
        v_rec.invoice_no    := i.invoice_no;
        v_rec.date_issued    := i.date_issued;
        v_rec.line_name        := i.line_name;
        v_rec.policy_no        := get_policy_no(p_policy_id);
        v_rec.endt_no        := i.endt_no;
        v_rec.date_from        := i.date_from;
        v_rec.date_to        := i.date_to;
        v_rec.subline_subline_time := i.subline_subline_time;
        v_rec.tsi_amt        := i.tsi_amt;
        v_rec.short_name    := i.short_name;
        v_rec.prem_amt        := i.prem_amt;
        v_rec.currency_cd   := i.currency_cd;
        v_rec.policy_currency := i.policy_currency;
        v_rec.currency_rt    := i.currency_rt;
        v_rec.bank_ref_no    := i.bank_ref_no;
        v_rec.subline_name    := i.subline_name;
        v_rec.intrmdry_intm_no    := i.intrmdry_intm_no;
        v_rec.currency_desc    := i.currency_desc;
        v_rec.class_name    := i.class_name;
        v_rec.assd_name2    := GIIS_ASSURED_PKG.get_assd_name_GIPIR913(i.acct_of_cd, i.label_tag);
        v_rec.ri_comm_amt   := NVL(i.ri_comm_amt1, 0);
        v_rec.ri_comm_vat    := NVL(i.ri_comm_vat1, 0);
        v_rec.ri_name        := i.ri_name;

        PIPE ROW(v_rec);
      END LOOP;
    END get_girir009_records;

END INVOICE_REPORTS_PKG;
/


