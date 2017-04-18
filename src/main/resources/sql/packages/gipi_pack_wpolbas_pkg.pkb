CREATE OR REPLACE PACKAGE BODY CPI.gipi_pack_wpolbas_pkg
AS
/*
**  Created by    : Bryan Joseph Abuluyan
**  Date Created  : 03.09.2010
**  Reference By  : (GIPIS038 - Peril Information
**  Description   : Updates WPOLBASIC after saving items and peril changes for packs
*/
   PROCEDURE update_pack_polbas (
      p_pack_par_id    gipi_pack_wpolbas.pack_par_id%TYPE,
      p_tsi_amt        gipi_pack_wpolbas.tsi_amt%TYPE,
      p_prem_amt       gipi_pack_wpolbas.prem_amt%TYPE,
      p_ann_tsi_amt    gipi_pack_wpolbas.ann_tsi_amt%TYPE,
      p_ann_prem_amt   gipi_pack_wpolbas.ann_prem_amt%TYPE
   )
   IS
   BEGIN
      --added by reymon 03202013 raise user ora error
      IF p_tsi_amt > 99999999999999.99 OR
         p_ann_tsi_amt > 99999999999999.99 THEN
         raise_application_error (-20438, 'Package total sum insured amount exceeds to 999,999,999,99,999.99.');
      ELSIF p_prem_amt > 9999999999.99 OR
         p_ann_prem_amt > 9999999999.99 THEN
         raise_application_error (-20439, 'Package total premium amount exceeds to 9,999,999,999.99.');
      ELSE
          UPDATE gipi_pack_wpolbas
             SET tsi_amt = p_tsi_amt,
                 prem_amt = p_prem_amt,
                 ann_tsi_amt = p_ann_tsi_amt,
                 ann_prem_amt = p_ann_prem_amt
           WHERE pack_par_id = p_pack_par_id;
      END IF;
   END update_pack_polbas;

/**************************************/
/*
** Transfered by: whofeih
** Date - 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_gipi_pack_wpolbas (p_quote_id   IN       gipi_quote.quote_id%TYPE,
                                       p_line_cd    IN       gipi_quote.line_cd%TYPE,
                                       p_iss_cd     IN       gipi_quote.iss_cd%TYPE,
                                       p_assd_no    IN       gipi_quote.assd_no%TYPE,
                                       p_par_id     IN       gipi_parlist.par_id%TYPE,
                                       p_message    OUT      VARCHAR2,
                                       p_user_id    IN         VARCHAR2)
   IS
      v_message                VARCHAR2(100) := '';
   
      v_line_cd                gipi_wpolbas.line_cd%TYPE;
      v_iss_cd                 gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd             gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy               gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE;
      v_endt_iss_cd            gipi_wpolbas.endt_iss_cd%TYPE;
      v_endt_yy                gipi_wpolbas.endt_yy%TYPE;
      v_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE;
      v_renew_no               gipi_wpolbas.renew_no%TYPE;
      v_endt_type              gipi_wpolbas.endt_type%TYPE;
      v_incept_date            gipi_wpolbas.incept_date%TYPE;
      v_expiry_date            gipi_wpolbas.expiry_date%TYPE;
      v_eff_date               gipi_wpolbas.eff_date%TYPE;
      v_issue_date             gipi_wpolbas.issue_date%TYPE;
      v_pol_flag               gipi_wpolbas.pol_flag%TYPE;
      v_foreign_acc_sw         gipi_wpolbas.foreign_acc_sw%TYPE;
      v_assd_no                gipi_wpolbas.assd_no%TYPE;
      v_designation            gipi_wpolbas.designation%TYPE;
      v_address1               gipi_wpolbas.address1%TYPE;
      v_address2               gipi_wpolbas.address2%TYPE;
      v_address3               gipi_wpolbas.address3%TYPE;
      v_mortg_name             gipi_wpolbas.mortg_name%TYPE;
      v_tsi_amt                gipi_wpolbas.tsi_amt%TYPE;
      v_prem_amt               gipi_wpolbas.prem_amt%TYPE;
      v_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE;
      v_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE;
      v_invoice_sw             gipi_wpolbas.invoice_sw%TYPE;
      v_pool_pol_no            gipi_wpolbas.pool_pol_no%TYPE;
      v_user_id                gipi_wpolbas.user_id%TYPE;
      v_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE;
      v_covernote_printed_sw   gipi_wpolbas.covernote_printed_sw%TYPE;
      v_orig_policy_id         gipi_wpolbas.orig_policy_id%TYPE;
      v_endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE;
      v_no_of_items            gipi_wpolbas.no_of_items%TYPE;
      v_subline_type_cd        gipi_wpolbas.subline_type_cd%TYPE;
      v_auto_renew_flag        gipi_wpolbas.auto_renew_flag%TYPE;
      v_prorate_flag           gipi_wpolbas.prorate_flag%TYPE;
      v_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE;
      v_prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE;
      v_type_cd                gipi_wpolbas.type_cd%TYPE;
      v_acct_of_cd             gipi_wpolbas.acct_of_cd%TYPE;
      v_prov_prem_pct          gipi_wpolbas.prov_prem_pct%TYPE;
      v_same_polno_sw          gipi_wpolbas.same_polno_sw%TYPE;
      v_pack_pol_flag          gipi_wpolbas.pack_pol_flag%TYPE;
      v_expiry_tag             gipi_wpolbas.expiry_tag%TYPE;
      v_prem_warr_tag          gipi_wpolbas.prem_warr_tag%TYPE;
      v_ref_pol_no             gipi_wpolbas.ref_pol_no%TYPE;
      v_ref_open_pol_no        gipi_wpolbas.ref_open_pol_no%TYPE;
      v_reg_policy_sw          gipi_wpolbas.reg_policy_sw%TYPE;
      v_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE;
      v_discount_sw            gipi_wpolbas.discount_sw%TYPE;
      v_fleet_print_tag        gipi_wpolbas.fleet_print_tag%TYPE;
      --v_jacket_no             gipi_wpolbas.jacket_no%TYPE;
      v_incept_tag             gipi_wpolbas.incept_tag%TYPE;
      v_comp_sw                gipi_wpolbas.comp_sw%TYPE;
      v_booking_mth            gipi_wpolbas.booking_mth%TYPE;
      v_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE;
      v_booking_yr             gipi_wpolbas.booking_year%TYPE;
      v_prod_take_up           giac_parameters.param_value_n%TYPE;
      v_later_date             gipi_wpolbas.issue_date%TYPE;
      v_par_id                 NUMBER;

      CURSOR cur_b
      IS
         SELECT subline_cd, NVL (tsi_amt, 0), NVL (prem_amt, 0),
                NVL (print_tag, 'N'), incept_date, expiry_date, address1,
                address2, address3, prorate_flag, short_rt_percent, comp_sw,
                ann_prem_amt, ann_tsi_amt
           FROM gipi_pack_quote
          WHERE pack_quote_id = p_quote_id;
   BEGIN
   
     v_line_cd := p_line_cd;
     v_iss_cd  := p_iss_cd;
     v_assd_no := p_assd_no;
--    v_incept_date := sysdate;
     v_issue_date := sysdate;
--    v_eff_date := sysdate;
--    v_expiry_date := sysdate + 365;
     v_later_date := sysdate;
	 
	 /*Nica 06.06.2012 - added this line to assign value to v_eff_date
	   which must be equal to the incept_date of the quotation*/
	 FOR i IN cur_b LOOP
        v_eff_date := i.incept_date; 
        EXIT;
     END LOOP;
    
     SELECT param_value_n
       INTO v_prod_take_up
       FROM giac_parameters
      WHERE param_name = 'PROD_TAKE_UP';
     
     IF v_prod_take_up = 1 THEN 
       FOR A IN (SELECT booking_year, booking_mth,
                        to_char(to_date('01-'||SUBSTR(booking_mth,1,3)||booking_year, 'DD-MON-RRRR'),'MM')       
                     FROM giis_booking_month
                    WHERE (NVL(booked_tag, 'N') != 'Y')
                      AND (booking_year > to_number(to_char(v_issue_date, 'YYYY')) 
                       OR booking_year = to_number(to_char(v_issue_date, 'YYYY'))) AND
                        (to_number(to_char(to_date('01-'||SUBSTR(booking_mth,1,3)||booking_year, 'DD-MON-RRRR'),'MM'))
                         >= to_number(to_char(v_issue_date, 'MM')))
                 ORDER BY 1, 3) LOOP
               
         v_booking_mth := a.booking_mth;
         v_booking_yr  := a.booking_year;            
         EXIT;
         
       END LOOP; 
       
     ELSIF v_prod_take_up = 2 THEN
         FOR A IN (SELECT booking_year, booking_mth,
                        to_char(to_date('01-'||SUBSTR(booking_mth,1,3)||booking_year, 'DD-MON-RRRR'),'MM')       
                     FROM giis_booking_month
                    WHERE (NVL(booked_tag, 'N') != 'Y')
                      AND (booking_year > to_number(to_char(v_eff_date, 'YYYY')) 
                       OR booking_year = to_number(to_char(v_eff_date, 'YYYY'))) AND
                        (to_number(to_char(to_date('01-'||SUBSTR(booking_mth,1,3)||booking_year, 'DD-MON-RRRR'),'MM'))
                         >= to_number(to_char(v_eff_date, 'MM')))
                 ORDER BY 1, 3) LOOP
               
         v_booking_mth := a.booking_mth;
         v_booking_yr  := a.booking_year;            
         EXIT;
         
       END LOOP;                
    
    ELSIF v_prod_take_up = 3 THEN             
      IF v_issue_date > v_eff_date THEN
        v_later_date := v_issue_date;
      ELSIF v_eff_date > v_issue_date THEN
        v_later_date := v_eff_date;     
      END IF;                              
    
      FOR A IN (SELECT booking_year, booking_mth,
                       to_char(to_date('01-'||SUBSTR(booking_mth,1,3)||booking_year, 'DD-MON-RRRR'),'MM')       
                  FROM giis_booking_month
                 WHERE (NVL(booked_tag, 'N') != 'Y')
                     AND (booking_year > to_number(to_char(v_later_date, 'YYYY')) 
                      OR booking_year = to_number(to_char(v_later_date, 'YYYY'))) AND
                       (to_number(to_char(to_date('01-'||SUBSTR(booking_mth,1,3)||booking_year, 'DD-MON-RRRR'),'MM'))
                        >= to_number(to_char(v_later_date, 'MM')))
                ORDER BY 1, 3) LOOP
              
        v_booking_mth := a.booking_mth;
        v_booking_yr  := a.booking_year;            
        EXIT;
        
        END LOOP;
                      
    ELSE 
    
      p_message := 'Wrong Parameter....Please make the necessary changes in Giac_Parameters.';
      
    END IF;
    
    IF p_message IS NULL THEN
      Gipi_Pack_Parlist_Pkg.create_pack_wpolbas(p_quote_id,
                                             p_par_id,
                                             p_assd_no,
                                             p_line_cd,
                                           p_iss_cd,
                                           sysdate,
                                             p_user_id,
                                             v_booking_mth,
                                             v_booking_yr);
    END IF;
      
  END;
-- end of whofeih
/**************************************/

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 11.08.2010
**  Reference By  : (GIPIS0002A - Package PAR Basic Information)
**  Description   : Function return details for Package PAR basic information
*/

FUNCTION get_gipi_pack_wpolbas_details(p_pack_par_id   GIPI_PACK_WPOLBAS.pack_par_id%TYPE) 
RETURN gipi_pack_wpolbas_tab PIPELINED IS

v_pack_wpolbas              gipi_pack_wpolbas_type;

BEGIN
    FOR i IN (SELECT   a.pack_par_id,                 a.label_tag,              a.assd_no,                    b.assd_name,            
                       c.assd_name in_account_of,     a.subline_cd,             a.surcharge_sw,               a.manual_renew_no,       
                       a.discount_sw,                 a.pol_flag,               d.rv_meaning pol_flag_desc,   a.type_cd,               
                       e.type_desc,                   a.address1,               a.address2,                   a.address3,               
                       a.booking_year,                a.booking_mth,            a.incept_date,                a.expiry_date,       
                       a.issue_date,                  a.place_cd,               a.incept_tag,                 a.expiry_tag,        
                       a.risk_tag,                    f.rv_meaning risk,        a.ref_pol_no,                 a.industry_cd,       
                       g.industry_nm,                 a.region_cd,              h.region_desc,                a.cred_branch,       
                       i.iss_name,                    a.quotation_printed_sw,   a.covernote_printed_sw,       a.pack_pol_flag,    
                       a.auto_renew_flag,             a.foreign_acc_sw,         a.reg_policy_sw,              a.fleet_print_tag,       
                       a.with_tariff_sw,              a.co_insurance_sw,        a.prorate_flag,               a.comp_sw,               
                       a.short_rt_percent,            a.prov_prem_tag,          a.prov_prem_pct,              a.designation,
                       a.acct_of_cd,                  a.iss_cd,                 a.invoice_sw,                 j.subline_name,
                       a.line_cd,                     a.renew_no,               a.issue_yy,                   a.ref_open_pol_no,
                       a.same_polno_sw,               a.endt_yy,                a.endt_seq_no,                a.mortg_name,
                       a.validate_tag,                a.back_stat,              a.eff_date,                   a.endt_expiry_date,
                       a.pol_seq_no,                  a.endt_expiry_tag,        a.endt_iss_cd,                a.acct_of_cd_sw,               
                       a.old_assd_no,                 a.old_address1,           a.old_address2,               a.old_address3,                
                       a.ann_tsi_amt,                 a.prem_amt,               a.tsi_amt,                    a.ann_prem_amt,
                       a.plan_cd,                     a.plan_sw,                a.plan_ch_tag,                a.company_cd,       
                       a.employee_cd,                 a.bank_ref_no,            a.banc_type_cd,               a.bancassurance_sw, 
                       a.area_cd,                     a.branch_cd,              a.manager_cd,                 a.prem_warr_tag
               
          FROM  GIPI_PACK_WPOLBAS   a
               ,GIIS_ASSURED        b
               ,GIIS_ASSURED        c
               ,CG_REF_CODES        d
               ,GIIS_POLICY_TYPE    e
               ,CG_REF_CODES        f
               ,GIIS_INDUSTRY       g
               ,GIIS_REGION         h
               ,GIIS_ISSOURCE       i  
               ,GIIS_SUBLINE        j
         WHERE a.pack_par_id             =  p_pack_par_id
           AND a.assd_no                 =  b.assd_no
           AND c.assd_no                (+)= a.acct_of_cd  
           AND d.rv_low_value           (+)= a.pol_flag 
           AND d.rv_domain              (+)= 'GIPI_PACK_POLBASIC.POL_FLAG'
           AND e.type_cd                (+)= a.type_cd   
           AND f.rv_low_value           (+)= a.risk_tag
           AND f.rv_domain              (+)= 'GIPI_PACK_POLBASIC.RISK_TAG'
           AND g.industry_cd            (+)= a.industry_cd
           AND h.region_cd              (+)= a.region_cd 
           AND i.iss_cd                 (+)= a.iss_cd 
           AND j.line_cd                 = a.line_cd
           AND j.subline_cd              = a.subline_cd)
    
    LOOP
        v_pack_wpolbas.pack_par_id                  := i.pack_par_id;
        v_pack_wpolbas.label_tag                    := i.label_tag;
        v_pack_wpolbas.assd_no                      := i.assd_no;
        v_pack_wpolbas.assd_name                    := i.assd_name;
        v_pack_wpolbas.in_account_of                := i.in_account_of;
        v_pack_wpolbas.line_cd                      := i.line_cd;
        v_pack_wpolbas.subline_cd                   := i.subline_cd;
        v_pack_wpolbas.surcharge_sw                 := i.surcharge_sw;
        v_pack_wpolbas.manual_renew_no              := i.manual_renew_no;
        v_pack_wpolbas.discount_sw                  := i.discount_sw;
        v_pack_wpolbas.pol_flag                     := i.pol_flag;
        v_pack_wpolbas.pol_flag_desc                := i.pol_flag_desc;
        v_pack_wpolbas.type_cd                      := i.type_cd;
        v_pack_wpolbas.type_desc                    := i.type_desc;
        v_pack_wpolbas.address1                     := i.address1;
        v_pack_wpolbas.address2                     := i.address2;
        v_pack_wpolbas.address3                     := i.address3;
        v_pack_wpolbas.booking_year                 := i.booking_year;
        v_pack_wpolbas.booking_mth                  := i.booking_mth;
        v_pack_wpolbas.incept_date                  := i.incept_date;
        v_pack_wpolbas.expiry_date                  := i.expiry_date;
        v_pack_wpolbas.issue_date                   := NVL(i.issue_date,SYSDATE);
        v_pack_wpolbas.place_cd                     := i.place_cd;     
        v_pack_wpolbas.incept_tag                   := i.incept_tag;
        v_pack_wpolbas.expiry_tag                   := i.expiry_tag;
        v_pack_wpolbas.risk_tag                     := i.risk_tag;
        v_pack_wpolbas.risk                         := i.risk;
        v_pack_wpolbas.ref_pol_no                   := i.ref_pol_no;
        v_pack_wpolbas.industry_cd                  := i.industry_cd;
        v_pack_wpolbas.industry_nm                  := i.industry_nm;     
        v_pack_wpolbas.region_cd                    := i.region_cd;
        v_pack_wpolbas.region_desc                  := i.region_cd;
        v_pack_wpolbas.cred_branch                  := i.cred_branch;
        v_pack_wpolbas.iss_name                     := i.iss_name;
        v_pack_wpolbas.iss_cd                       := i.iss_cd;
        v_pack_wpolbas.quotation_printed_sw         := i.quotation_printed_sw;
        v_pack_wpolbas.covernote_printed_sw         := i.covernote_printed_sw;
        v_pack_wpolbas.pack_pol_flag                := i.pack_pol_flag;
        v_pack_wpolbas.auto_renew_flag              := i.auto_renew_flag;
        v_pack_wpolbas.foreign_acc_sw               := i.foreign_acc_sw;
        v_pack_wpolbas.reg_policy_sw                := i.reg_policy_sw;                                  
        v_pack_wpolbas.fleet_print_tag              := i.fleet_print_tag;
        v_pack_wpolbas.prem_warr_tag                := i.prem_warr_tag;
        v_pack_wpolbas.with_tariff_sw               := i.with_tariff_sw;
        v_pack_wpolbas.co_insurance_sw              := i.co_insurance_sw;
        v_pack_wpolbas.prorate_flag                 := i.prorate_flag;
        v_pack_wpolbas.comp_sw                      := i.comp_sw;
        v_pack_wpolbas.short_rt_percent             := i.short_rt_percent;     
        v_pack_wpolbas.prov_prem_tag                := i.prov_prem_tag;                                        
        v_pack_wpolbas.prov_prem_pct                := i.prov_prem_pct;
        v_pack_wpolbas.designation                  := i.designation;   
        v_pack_wpolbas.acct_of_cd                   := i.acct_of_cd;
        v_pack_wpolbas.invoice_sw                   := i.invoice_sw;
        v_pack_wpolbas.renew_no                     := i.renew_no;
        v_pack_wpolbas.issue_yy                     := i.issue_yy;
        v_pack_wpolbas.ref_open_pol_no              := i.ref_open_pol_no;
        v_pack_wpolbas.same_polno_sw                := i.same_polno_sw;
        v_pack_wpolbas.endt_yy                      := i.endt_yy;
        v_pack_wpolbas.endt_seq_no                  := i.endt_seq_no;
        v_pack_wpolbas.mortg_name                   := i.mortg_name;
        v_pack_wpolbas.validate_tag                 := i.validate_tag;
        v_pack_wpolbas.pol_seq_no                   := i.pol_seq_no;
        v_pack_wpolbas.back_stat                    := i.back_stat;
        v_pack_wpolbas.eff_date                     := i.eff_date;
        v_pack_wpolbas.endt_expiry_date             := i.endt_expiry_date;
        v_pack_wpolbas.endt_expiry_tag              := i.endt_expiry_tag;
        v_pack_wpolbas.endt_iss_cd                  := i.endt_iss_cd;
        v_pack_wpolbas.acct_of_cd_sw                := i.acct_of_cd_sw;
        v_pack_wpolbas.old_assd_no                  := i.old_assd_no;
        v_pack_wpolbas.old_address1                 := i.old_address1;
        v_pack_wpolbas.old_address2                 := i.old_address2;
        v_pack_wpolbas.old_address3                 := i.old_address3;
        v_pack_wpolbas.ann_tsi_amt                  := i.ann_tsi_amt;
        v_pack_wpolbas.prem_amt                     := i.prem_amt;
        v_pack_wpolbas.tsi_amt                      := i.tsi_amt;
        v_pack_wpolbas.ann_prem_amt                 := i.ann_prem_amt;
        v_pack_wpolbas.plan_cd                        := i.plan_cd;
        v_pack_wpolbas.plan_sw                        := i.plan_sw;
        v_pack_wpolbas.plan_ch_tag                    := i.plan_ch_tag;
        v_pack_wpolbas.company_cd                   := i.company_cd;
        v_pack_wpolbas.employee_cd                  := i.employee_cd;
        v_pack_wpolbas.bank_ref_no                  := i.bank_ref_no;
        v_pack_wpolbas.banc_type_cd                 := i.banc_type_cd;
        v_pack_wpolbas.bancassurance_sw             := i.bancassurance_sw;
        v_pack_wpolbas.area_cd                      := i.area_cd;
        v_pack_wpolbas.branch_cd                    := i.branch_cd;
        v_pack_wpolbas.manager_cd                   := i.manager_cd;
    
      END LOOP;
      
      PIPE ROW(v_pack_wpolbas);
      
    RETURN;
  END get_gipi_pack_wpolbas_details;
  
  /*
    **  Created by   :  Emman
    **  Date Created :  11.23.2010
    **  Reference By : (GIACS031A - Pack Endt Basic Information)
    **  Description  :  Save (Insert/Update) GIPI_PACK_WPOLBAS record
    */ 
    
  PROCEDURE set_gipi_pack_wpolbas (
             p_par_id                                   GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
           p_endt_expiry_tag                   GIPI_PACK_WPOLBAS.endt_expiry_tag%TYPE,
           p_line_cd                           GIPI_PACK_WPOLBAS.line_cd%TYPE,
           p_subline_cd                           GIPI_PACK_WPOLBAS.subline_cd%TYPE,
           p_iss_cd                               GIPI_PACK_WPOLBAS.iss_cd%TYPE,
           p_issue_yy                           GIPI_PACK_WPOLBAS.issue_yy%TYPE,
           p_pol_seq_no                           GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
           p_renew_no                           GIPI_PACK_WPOLBAS.renew_no%TYPE,
           p_assd_no                           GIPI_PACK_WPOLBAS.assd_no%TYPE,
           p_old_assd_no                       GIPI_PACK_WPOLBAS.old_assd_no%TYPE,
           p_acct_of_cd                           GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
           p_endt_iss_cd                       GIPI_PACK_WPOLBAS.endt_iss_cd%TYPE,
           p_endt_yy                           GIPI_PACK_WPOLBAS.endt_yy%TYPE,
           p_endt_seq_no                       GIPI_PACK_WPOLBAS.endt_seq_no%TYPE,
           p_incept_date                       GIPI_PACK_WPOLBAS.incept_date%TYPE,
           p_incept_tag                           GIPI_PACK_WPOLBAS.incept_tag%TYPE,
           p_expiry_date                       GIPI_PACK_WPOLBAS.expiry_date%TYPE,
           p_expiry_tag                           GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
           p_prem_warr_tag                       GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
           p_eff_date                           GIPI_PACK_WPOLBAS.eff_date%TYPE,
           p_endt_expiry_date                   GIPI_PACK_WPOLBAS.endt_expiry_date%TYPE,
           p_place_cd                           GIPI_PACK_WPOLBAS.place_cd%TYPE,
           p_issue_date                           GIPI_PACK_WPOLBAS.issue_date%TYPE,
           p_type_cd                           GIPI_PACK_WPOLBAS.type_cd%TYPE,
           p_ref_pol_no                           GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
           p_manual_renew_no                   GIPI_PACK_WPOLBAS.manual_renew_no%TYPE,
           p_pol_flag                           GIPI_PACK_WPOLBAS.pol_flag%TYPE,
           p_acct_of_cd_sw                       GIPI_PACK_WPOLBAS.acct_of_cd_sw%TYPE,
           p_region_cd                           GIPI_PACK_WPOLBAS.region_cd%TYPE,
           p_industry_cd                        GIPI_PACK_WPOLBAS.industry_cd%TYPE,
           p_address1                           GIPI_PACK_WPOLBAS.address1%TYPE,
           p_address2                           GIPI_PACK_WPOLBAS.address2%TYPE,
           p_address3                           GIPI_PACK_WPOLBAS.address3%TYPE,
           p_old_address1                       GIPI_PACK_WPOLBAS.old_address1%TYPE,
           p_old_address2                       GIPI_PACK_WPOLBAS.old_address2%TYPE,
           p_old_address3                       GIPI_PACK_WPOLBAS.old_address3%TYPE,
           p_cred_branch                       GIPI_PACK_WPOLBAS.cred_branch%TYPE,
           --p_bank_ref_no                       GIPI_PACK_WPOLBAS.bank_ref_no%TYPE, -- temporarily removed, add later
           p_booking_year                       GIPI_PACK_WPOLBAS.booking_year%TYPE,
           p_booking_mth                       GIPI_PACK_WPOLBAS.booking_mth%TYPE,
           p_covernote_printed_sw               GIPI_PACK_WPOLBAS.covernote_printed_sw%TYPE,
           p_quotation_printed_sw               GIPI_PACK_WPOLBAS.quotation_printed_sw%TYPE,
           p_foreign_acc_sw                       GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
           p_invoice_sw                           GIPI_PACK_WPOLBAS.invoice_sw%TYPE,
           p_auto_renew_flag                   GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
           p_prorate_flag                       GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
           p_comp_sw                           GIPI_PACK_WPOLBAS.comp_sw%TYPE,
           p_short_rt_percent                   GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,
           p_prov_prem_tag                       GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,
           p_fleet_print_tag                   GIPI_PACK_WPOLBAS.fleet_print_tag%TYPE,
           p_with_tariff_sw                       GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
           p_prov_prem_pct                       GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
           p_same_polno_sw                       GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
           p_ann_tsi_amt                       GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
           p_prem_amt                           GIPI_PACK_WPOLBAS.prem_amt%TYPE,
           p_tsi_amt                           GIPI_PACK_WPOLBAS.tsi_amt%TYPE,
           p_ann_prem_amt                       GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
           p_reg_policy_sw                       GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,
           p_co_insurance_sw                   GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
           p_user_id                           GIPI_PACK_WPOLBAS.user_id%TYPE,
           p_pack_pol_flag                       GIPI_PACK_WPOLBAS.pack_pol_flag%TYPE,
           p_designation                       GIPI_PACK_WPOLBAS.designation%TYPE,
           --p_back_stat                           GIPI_PACK_WPOLBAS.back_stat%TYPE,
           p_risk_tag                           GIPI_PACK_WPOLBAS.risk_tag%TYPE,
           p_label_tag                          GIPI_PACK_WPOLBAS.label_tag%TYPE -- bonok :: 05.19.2014
           --p_bancassurance_sw                   GIPI_PACK_WPOLBAS.bancassurance_sw%TYPE,
           --p_banc_type_cd                       GIPI_PACK_WPOLBAS.banc_type_cd%TYPE,
           --p_area_cd                           GIPI_PACK_WPOLBAS.area_cd%TYPE,
           --p_branch_cd                           GIPI_PACK_WPOLBAS.branch_cd%TYPE,
           --p_manager_cd                           GIPI_PACK_WPOLBAS.manager_cd%TYPE
           )
  AS
  	v_issue_date Date ;
  v_exist varchar2(1) := 'N';
  BEGIN
  	
	-- irwin 10.23.2012
  
          FOR a IN (SELECT issue_date
                      FROM GIPI_pack_WPOLBAS
                     WHERE pack_par_id =   p_par_id)
          LOOP    
          v_exist := 'Y';
            v_issue_date := a.issue_date;
          END LOOP;
          
          if v_exist =  'Y' then
              IF giisp.v('UPDATE_ISSUE_DATE') = 'Y' THEN
                v_issue_date := to_date(to_char(p_issue_date,'mm-dd-yyy' ) ||' '||to_char(sysdate, 'hh12:mi:ss PM'),'mm-dd-yyyy hh12:mi:ss PM');    
              END IF; 
              
              else
              v_issue_date := to_date(to_char(p_issue_date,'mm-dd-yyy' ) ||' '||to_char(sysdate, 'hh12:mi:ss PM'),'mm-dd-yyyy hh12:mi:ss PM');
              
          end if; 
       MERGE INTO GIPI_PACK_WPOLBAS
     USING DUAL ON (pack_par_id = p_par_id)
     WHEN NOT MATCHED THEN
           INSERT(pack_par_id,         endt_expiry_tag,    line_cd,      subline_cd,         iss_cd,
                    issue_yy,        pol_seq_no,            renew_no,      assd_no,           old_assd_no,
                    acct_of_cd,    endt_iss_cd,        endt_yy,      endt_seq_no,       incept_date,
                    incept_tag,    expiry_date,        expiry_tag,   prem_warr_tag,   eff_date,
                    endt_expiry_date, place_cd,        issue_date,      type_cd,           ref_pol_no,
                    manual_renew_no,  pol_flag,        acct_of_cd_sw,region_cd,       industry_cd,
                    address1,      address2,            address3,     old_address1,       old_address2,
                    old_address3,  cred_branch,        booking_year, booking_mth,       covernote_printed_sw,
                    quotation_printed_sw,foreign_acc_sw,invoice_sw,  auto_renew_flag, prorate_flag,
                    comp_sw,         short_rt_percent,   prov_prem_tag,fleet_print_tag, with_tariff_sw,
                    prov_prem_pct, same_polno_sw,        ann_tsi_amt,  prem_amt,           tsi_amt,
                    ann_prem_amt,  reg_policy_sw,        co_insurance_sw, user_id,       pack_pol_flag,
                    designation,   risk_tag,           label_tag)
          VALUES(p_par_id,         p_endt_expiry_tag,      p_line_cd,      p_subline_cd,         p_iss_cd,
                    p_issue_yy,    p_pol_seq_no,            p_renew_no,        p_assd_no,           p_old_assd_no,
                    p_acct_of_cd,  p_endt_iss_cd,            p_endt_yy,        p_endt_seq_no,       p_incept_date,
                    p_incept_tag,    p_expiry_date,            p_expiry_tag,   p_prem_warr_tag,   p_eff_date,
                    p_endt_expiry_date, p_place_cd,        p_issue_date,    p_type_cd,           p_ref_pol_no,
                    p_manual_renew_no,     p_pol_flag,        p_acct_of_cd_sw,p_region_cd,       p_industry_cd,
                    p_address1,    p_address2,                p_address3,     p_old_address1,       p_old_address2,
                    p_old_address3,p_cred_branch,            p_booking_year, p_booking_mth,       p_covernote_printed_sw,
                    p_quotation_printed_sw,p_foreign_acc_sw,p_invoice_sw,  p_auto_renew_flag, p_prorate_flag,
                    p_comp_sw,     p_short_rt_percent,     p_prov_prem_tag,p_fleet_print_tag, p_with_tariff_sw,
                    p_prov_prem_pct,p_same_polno_sw,        p_ann_tsi_amt,  p_prem_amt,           p_tsi_amt,
                    p_ann_prem_amt,p_reg_policy_sw,        p_co_insurance_sw, p_user_id,       p_pack_pol_flag,
                    p_designation, p_risk_tag,           p_label_tag)
     WHEN MATCHED THEN
       UPDATE SET endt_expiry_tag           =   p_endt_expiry_tag,
                  line_cd                   =   p_line_cd,
                  subline_cd               =   p_subline_cd,
                  iss_cd                   =   p_iss_cd,
                     issue_yy                   =   p_issue_yy,
                  pol_seq_no               =   p_pol_seq_no,
                  renew_no                   =   p_renew_no,
                  assd_no                   =   p_assd_no,
                  old_assd_no               =   p_old_assd_no,
                     acct_of_cd               =   p_acct_of_cd,
                  endt_iss_cd               =   p_endt_iss_cd,
                  endt_yy                   =   p_endt_yy,
                  endt_seq_no               =   p_endt_seq_no,
                  incept_date               =   p_incept_date,
                     incept_tag               =   p_incept_tag,
                  expiry_date               =   p_expiry_date,
                  expiry_tag               =   p_expiry_tag,
                  prem_warr_tag               =   p_prem_warr_tag,
                  eff_date                   =   p_eff_date,
                     endt_expiry_date           =   p_endt_expiry_date,
                  place_cd                   =   p_place_cd,
                  issue_date               =   p_issue_date,
                  type_cd                   =   p_type_cd,
                  ref_pol_no               =   p_ref_pol_no,
                     manual_renew_no           =   p_manual_renew_no,
                  pol_flag                   =   p_pol_flag,
                  acct_of_cd_sw               =   p_acct_of_cd_sw,
                  region_cd                   =   p_region_cd,
                  industry_cd               =   p_industry_cd,
                     address1                   =   p_address1,
                  address2                   =   p_address2,
                  address3                   =   p_address3,
                  old_address1               =   p_old_address1,
                  old_address2               =   p_old_address2,
                     old_address3               =   p_old_address3,
                  cred_branch               =   p_cred_branch,
                  booking_year               =   p_booking_year,
                  booking_mth               =   p_booking_mth,
                  covernote_printed_sw       =   p_covernote_printed_sw,
                     quotation_printed_sw       =   p_quotation_printed_sw,
                  foreign_acc_sw           =   p_foreign_acc_sw,
                  invoice_sw               =   p_invoice_sw,
                  auto_renew_flag           =   p_auto_renew_flag,
                  prorate_flag               =   p_prorate_flag,
                     comp_sw                   =   p_comp_sw,
                  short_rt_percent           =   p_short_rt_percent,
                  prov_prem_tag               =   p_prov_prem_tag,
                  fleet_print_tag           =   p_fleet_print_tag,
                  with_tariff_sw           =   p_with_tariff_sw,
                     prov_prem_pct               =   p_prov_prem_pct,
                  same_polno_sw               =   p_same_polno_sw,
                  ann_tsi_amt               =   p_ann_tsi_amt,
                  prem_amt                   =   p_prem_amt,
                  tsi_amt                   =   p_tsi_amt,
                     ann_prem_amt               =   p_ann_prem_amt,
                  reg_policy_sw               =   p_reg_policy_sw,
                  co_insurance_sw           =   p_co_insurance_sw,
                  user_id                   =   p_user_id,
                  pack_pol_flag               =   p_pack_pol_flag,
                     designation               =   p_designation,
                  risk_tag                      =   p_risk_tag,
                  label_tag                 =   p_label_tag;
  END set_gipi_pack_wpolbas;  
  
  /*
    **  Created by        : Emman
    **  Date Created     : 11.22.2010
    **  Reference By     : (GIPIS031A - Pack Endt Basic Information)
    **  Description     : This procedure is used to retrieve the par_no based on the pack_par_id
    */
  Procedure get_gipi_pack_wpolbas_par_no (
        p_par_id        IN  GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
        p_line_cd       OUT GIPI_PACK_WPOLBAS.line_cd%TYPE,
        p_subline_cd    OUT GIPI_PACK_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        OUT GIPI_PACK_WPOLBAS.iss_cd%TYPE,
        p_issue_yy      OUT GIPI_PACK_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    OUT GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no      OUT GIPI_PACK_WPOLBAS.renew_no%TYPE)
  IS
    BEGIN
        FOR i IN (
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
              FROM GIPI_PACK_WPOLBAS
             WHERE pack_par_id = p_par_id)
        LOOP
            p_line_cd        := i.line_cd;
            p_subline_cd    := i.subline_cd;
            p_iss_cd        := i.iss_cd;
            p_issue_yy        := i.issue_yy;
            p_pol_seq_no    := i.pol_seq_no;
            p_renew_no        := i.renew_no;
        END LOOP;
  END get_gipi_pack_wpolbas_par_no;
  
    /*
    **  Created by    : Emman
    **  Date Created  : 11.19.2010
    **  Reference By  : (GIPIS031A - Package Endt Basic Info)
    **  Description   : Executes the WHEN-NEW-FORM-INSTANCE trigger of GIPIS031A
    */
    PROCEDURE gipis031a_new_form_instance (p_par_id                        IN     GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
                                             p_b240_line_cd                IN       GIPI_PACK_PARLIST.line_cd%TYPE,
                                             p_b540_subline_cd            IN       GIPI_PACK_WPOLBAS.subline_cd%TYPE,
                                           p_b540_iss_cd                IN       GIPI_PACK_WPOLBAS.iss_cd%TYPE,
                                           p_b540_issue_yy                IN       GIPI_PACK_WPOLBAS.issue_yy%TYPE,
                                           p_b540_pol_seq_no            IN       GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
                                           p_b540_renew_no                IN       GIPI_PACK_WPOLBAS.renew_no%TYPE,
                                             p_var_lc_mc                       OUT GIIS_PARAMETERS.param_value_v%TYPE,
                                           p_var_lc_ac                       OUT GIIS_PARAMETERS.param_value_v%TYPE,
                                           p_var_lc_en                       OUT GIIS_PARAMETERS.param_value_v%TYPE,
                                           p_var_subline_mop               OUT GIIS_PARAMETERS.param_value_v%TYPE,
                                           p_var_v_advance_booking           OUT VARCHAR2,
                                           p_param_var_vdate               OUT GIAC_PARAMETERS.param_value_n%TYPE,
                                           p_req_ref_pol_no                   OUT VARCHAR2,
                                           p_banca_dtl_btn_visible           OUT VARCHAR2,                                           
                                           p_g_cancellation_type           OUT VARCHAR2,                                           
                                           p_g_cancel_tag                   OUT VARCHAR2,                                           
                                           p_c_mop_subline                   OUT VARCHAR2,                                           
                                           p_show_marine_detail_button       OUT VARCHAR2,                                           
                                           p_region_cd                       OUT VARCHAR2,                                           
                                           p_existing_claim                   OUT VARCHAR2,
                                           p_paid_amt                       OUT NUMBER,                                           
                                           p_req_survey_sett_agent           OUT VARCHAR2,
                                           p_check_line_subline               OUT NUMBER,
                                           p_check_existing_claims           OUT VARCHAR2,                               
                                           p_message                       OUT VARCHAR2
                                             )
    IS
        v_ctrl_mop_subline                   GIIS_PARAMETERS.param_value_v%TYPE;        
        v_line_cd        GIPI_PACK_WPOLBAS.line_cd%TYPE;
        v_subline_cd    GIPI_PACK_WPOLBAS.subline_cd%TYPE;
        v_iss_cd        GIPI_PACK_WPOLBAS.iss_cd%TYPE;
        v_issue_yy        GIPI_PACK_WPOLBAS.issue_yy%TYPE;
        v_pol_seq_no    GIPI_PACK_WPOLBAS.pol_seq_no%TYPE;
        v_renew_no        GIPI_PACK_WPOLBAS.renew_no%TYPE;
    BEGIN
        Gipi_Pack_Wpolbas_Pkg.get_gipi_pack_wpolbas_par_no(p_par_id, v_line_cd, v_subline_cd, 
        v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
    
        p_g_cancellation_type := NULL;
        p_g_cancel_tag := 'N';
        
        BEGIN
          BEGIN
            -- INITIALIZE_PARAMETERS procedure
            DECLARE
              v_param_value_v        giis_parameters.param_value_v%type;
            BEGIN
              FOR A1 IN (SELECT  a.param_value_v  a_param_value_v,
                                 b.param_value_v  b_param_value_v
                         FROM    giis_parameters a,
                                 giis_parameters b
                         WHERE   a.param_name LIKE 'MOTOR CAR'
                            AND  b.param_name LIKE 'LINE_CODE_AC') LOOP
                 
                 p_var_lc_MC  := a1.a_param_value_v;
                 p_var_lc_AC  := a1.b_param_value_v;
                 EXIT;
              END LOOP;
            
              FOR B IN (SELECT param_value_v
                          FROM giis_parameters
                         WHERE param_name = 'MN_SUBLINE_MOP')
              LOOP
                  p_var_subline_mop := b.param_value_v;
                p_c_mop_subline   := b.param_value_v;
              END LOOP;                
              
              p_var_v_advance_booking := 'N';
              FOR E IN (SELECT param_value_v
                          FROM giis_parameters
                         WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE')
              LOOP
                  p_var_v_advance_booking := E.param_value_v;
              END LOOP;
              
              /*
              IF p_var_v_advance_booking = 'Y' THEN
                   SET_LOV_PROPERTY('BOOKED', GROUP_NAME,'BOOKED2');
              ELSE
                 SET_LOV_PROPERTY('BOOKED', GROUP_NAME,'BOOKED');
              END IF;*/        
              
              FOR F IN (SELECT param_value_v
                          FROM giis_parameters
                         WHERE param_name = 'LINE_CODE_EN')
              LOOP
                p_var_lc_EN  := F.param_value_v;        
              END LOOP;
            END;
            -- end of INITIALIZE_PARAMETERS procedure
          EXCEPTION
            WHEN OTHERS THEN NULL;
          END;
        END;
        
        DECLARE
        v_param_value_v   VARCHAR2(200);
        v_menu_line_cd    VARCHAR2(2);
        BEGIN
            FOR X IN (
                SELECT param_value_v
                  FROM GIIS_PARAMETERS
                 WHERE param_name = 'LINE_CODE_MN')
            LOOP
                v_param_value_v := X.param_value_v;
            END LOOP;
        
            FOR y IN (
                SELECT menu_line_cd
                  FROM GIIS_LINE
                 WHERE line_cd = v_line_cd)
            LOOP
                v_menu_line_cd := y.menu_line_cd;
            END LOOP;
            
            IF (v_line_cd = v_param_value_v) OR ('MN' = v_menu_line_cd) THEN
                p_show_marine_detail_button := 'Y';
                FOR i IN (
                    SELECT param_value_v 
                      FROM GIIS_PARAMETERS
                     WHERE param_name = 'REQ_SURVEY_SETT_AGENT')
                LOOP
                    p_req_survey_sett_agent := i.param_value_v;
                END LOOP;
            ELSE
                p_show_marine_detail_button := 'N';
            END IF;
        END;
        
        DECLARE
           p_exist5          NUMBER;
           v_co_ins_sw       gipi_wpolbas.co_insurance_sw%TYPE;
           V_FLAG            GIIS_SUBLINE.OP_FLAG%TYPE;
        BEGIN
            FOR A2 IN(SELECT a760.param_value_v mop
                        FROM giis_parameters a760
                       WHERE a760.param_name = 'MN_SUBLINE_MOP')LOOP
                   v_ctrl_mop_subline := a2.mop;
                   EXIT;
            END LOOP;
        
         IF p_b540_subline_cd != v_ctrl_mop_subline THEN
           BEGIN
              FOR co IN (
                SELECT co_insurance_sw
                  FROM gipi_pack_wpolbas
                 WHERE pack_par_id = p_par_id)
              LOOP
                v_co_ins_sw := co.co_insurance_sw;
              END LOOP;
           END;
        
           IF  P_EXIST5 IS  NOT NULL THEN
             DECLARE
               v_exist1    Number;
               v_exist2    Number;
               v_exist3    Number;
               v_exist4    Number;
               v_exist5    Number;
               ri_iss_cd   giis_issource.iss_cd%TYPE;
             BEGIN    
              FOR cd IN (
                SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'RI_ISS_CD')
              LOOP
                 ri_iss_cd := cd.param_value_v;
              END LOOP;    
            SELECT distinct 1
              INTO v_exist3
              FROM gipi_witmperl b490
             WHERE EXISTS (SELECT 1 
                                 FROM gipi_parlist gp 
                                      WHERE gp.par_id = b490.par_id 
                                        AND gp.pack_par_id = p_par_id);
          END;
          END IF;
         END IF;
         END;
        
        BEGIN
            FOR C IN (SELECT PARAM_VALUE_N
                                   FROM GIAC_PARAMETERS
                                  WHERE PARAM_NAME = 'PROD_TAKE_UP')LOOP
               p_param_VAR_VDATE := C.PARAM_VALUE_N;
            END LOOP;                        
          IF p_param_VAR_VDATE > 3 THEN
                p_message := 'The parameter value ('||to_char(p_param_VAR_VDATE)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.';
                RETURN;       
          END IF;    
            FOR A IN ( SELECT param_value_v
                         FROM giis_parameters
                        WHERE param_name = 'REQUIRE_REF_POL_NO')
            LOOP
                p_req_ref_pol_no := a.param_value_v;
                EXIT;
            END LOOP;
            /*
            IF v_require = 'Y' THEN
                 set_item_property('b540.ref_pol_no', required, property_true);
            ELSE     
                 set_item_property('b540.ref_pol_no', required, property_false);
            END IF;*/     
        END;
            
        DECLARE
        v_param_value_v   VARCHAR2(200);
        v_menu_line_cd    VARCHAR2(2);
        
        BEGIN
            FOR x IN ( SELECT param_value_v
                         FROM giis_parameters
                        WHERE param_name = 'LINE_CODE_MN')
            LOOP
                v_param_value_v := x.param_value_v;
            END LOOP;
            
            FOR y IN (SELECT menu_line_cd
                          FROM giis_line
                         WHERE line_cd=p_b240_line_cd)
            LOOP
                v_menu_line_cd := y.menu_line_cd;
            END LOOP;
        END;
        
        IF giisp.v('ORA2010_SW') <> 'Y' THEN
               p_banca_dtl_btn_visible := 'N';
        ELSE  
               p_banca_dtl_btn_visible := 'Y';
        END IF;
        
        /* retrieve region_cd */
        FOR X IN (
            SELECT region_desc, region_cd
              FROM GIIS_REGION
             WHERE region_cd = (SELECT region_cd 
                                  FROM GIIS_ISSOURCE
                                 WHERE iss_cd = v_iss_cd))
        LOOP
             p_region_cd := X.region_cd;
             EXIT;
        END LOOP;
        
        /* check for pending claims */
        IF Gicl_Claims_Pkg.chk_pending_claims_for_pack(v_line_cd, v_subline_cd, 
                v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no) > 0 THEN
            p_existing_claim := 'Y';
        ELSE
            p_existing_claim := 'N';
        END IF;
        
        /* check for paid policy */
        p_paid_amt := Giac_Aging_Soa_Details_Pkg.check_pack_policy_payment(v_line_cd, v_subline_cd, 
                v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
                
        /* check_line_subline function result */
        SELECT COUNT(*)
          INTO p_check_line_subline
          FROM GIPI_WPACK_LINE_SUBLINE
         WHERE pack_par_id = p_par_id
           AND line_cd = p_b240_line_cd;
           
        -- check for existence of claims
        p_check_existing_claims := 'N';
        FOR A1 IN (SELECT b.claim_id
                      FROM gipi_pack_polbasic a,
                           gicl_claims   b
                     WHERE a.line_cd     = b.line_cd
                       AND a.subline_cd  = b.subline_cd
                       AND   a.iss_cd      = b.pol_iss_cd
                       AND  a.issue_yy    = b.issue_yy
                       AND   a.pol_seq_no  = b.pol_seq_no
                       AND   a.renew_no    = b.renew_no
                       AND   NVL(a.endt_seq_no,0) = 0
                       AND   clm_stat_cd NOT IN ('CC','DN','WD','CD')
                       AND   a.line_cd       = p_b240_line_cd
                       AND   a.subline_cd    = p_b540_subline_cd
                       AND   a.iss_cd        = p_b540_iss_cd
                       AND   a.issue_yy      = p_b540_issue_yy
                       AND   a.pol_seq_no    = p_b540_pol_seq_no
                       AND   a.renew_no      = p_b540_renew_no)
         LOOP
           p_check_existing_claims := 'Y';
           EXIT;
         END LOOP;
    END gipis031a_new_form_instance;
    
    /*
    **  Created by    : Emman
    **  Date Created  : 11.19.2010
    **  Reference By  : (GIPIS031A - Package Endt Basic Info)
    **  Description   : Executes the GET_ACCT_OF_CD of GIPIS031A
    */
    PROCEDURE get_acct_of_cd(p_line_cd                    IN     VARCHAR2,
                             p_subline_cd                 IN       VARCHAR2, 
                             p_iss_cd                     IN       VARCHAR2, 
                             p_issue_yy                   IN       NUMBER,
                             p_pol_seq_no                 IN       NUMBER,
                             p_renew_no                   IN       NUMBER,
                             p_b540_eff_date            IN       GIPI_PACK_WPOLBAS.eff_date%TYPE,
                             p_b540_acct_of_cd            IN OUT GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
                             p_b540_label_tag            IN OUT GIPI_PACK_WPOLBAS.label_tag%TYPE,
                             p_param_modal_flag            IN OUT VARCHAR2)
    IS
    BEGIN
      IF p_param_modal_flag = 'N' AND p_b540_eff_date IS NOT NULL THEN
         -- removed since unused
         /*IF p_b540_acct_of_cd IS NOT NULL THEN
            FOR rec1 IN (SELECT a020.assd_name assd_name
                           FROM giis_assured a020
                          WHERE a020.assd_no = p_b540_acct_of_cd)
            LOOP
                 :b240.drv_acct_of_cd := rec1.assd_name;  
               END LOOP;
         END IF;*/
         NULL;
      ELSE
        p_param_modal_flag := 'N';
        FOR rec IN (SELECT a.acct_of_cd acct_of_cd, a.acct_of_cd_sw acct_of_cd_sw, label_tag /*gmi 050307*/
                      FROM gipi_polbasic a
                     WHERE a.line_cd     = p_line_cd
                       AND a.subline_cd  = p_subline_cd
                       AND a.iss_cd      = p_iss_cd
                       AND a.issue_yy    = p_issue_yy
                       AND a.pol_seq_no  = p_pol_seq_no
                       AND a.renew_no    = p_renew_no
                       AND a.pol_flag IN ('1','2','3','X')
                       AND NOT EXISTS      (SELECT '1'
                                              FROM gipi_polbasic
                                             WHERE line_cd                 = a.line_cd
                                               AND subline_cd              = a.subline_cd
                                               AND iss_cd                  = a.iss_cd
                                               AND issue_yy                = a.issue_yy
                                               AND pol_seq_no              = a.pol_seq_no
                                               AND renew_no                = a.renew_no
                                               AND acct_of_cd              IS NOT NULL
                                               AND pol_flag IN ('1','2','3','X')
                                               AND endt_seq_no             > a.endt_seq_no
                                                                   AND NVL(back_stat, 5) = 2)
                       ORDER BY a.eff_date DESC)
        LOOP
            FOR rec1 IN (SELECT designation, assd_name
                           FROM giis_assured
                          WHERE assd_no = rec.acct_of_cd)
            LOOP 
                IF rec.acct_of_cd_sw = 'Y' THEN
                   p_b540_acct_of_cd     := NULL;
                   p_b540_label_tag      := 'N';
                ELSE
                  p_b540_acct_of_cd     := rec.acct_of_cd;
                  p_b540_label_tag      := rec.label_tag;
                END IF;
            END LOOP;
        EXIT;
        END LOOP; 
      END IF;
    END get_acct_of_cd;
    
/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : March 2, 2011
**  Reference By  : (GIPIS002A- Package PAR Basic Information
**  Description   : Procedure checks whether a record exist in GIPI_PACK_WPOLBAS with
**                  the given pack_par_id 
*/

    PROCEDURE get_gipi_pack_wpolbas_exist (p_pack_par_id  IN      GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
                                           p_exist        OUT     NUMBER)
    IS
        v_exist                    NUMBER := 0;
    BEGIN
        FOR a IN (SELECT 1 
                    FROM GIPI_PACK_WPOLBAS
                   WHERE pack_par_id = p_pack_par_id)
        LOOP
          v_exist := 1;
        END LOOP;
        p_exist := v_exist;
    END get_gipi_pack_wpolbas_exist;
    
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 02, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This retrieves Package PAR basic information default values. 
*/
  
FUNCTION get_gipi_pack_wpolbas_def_val (p_pack_par_id     GIPI_PACK_WPOLBAS.pack_par_id%TYPE)
    RETURN gipi_pack_wpolbas_tab PIPELINED IS
      
      v_pack_wpolbas                     gipi_pack_wpolbas_type;     

      v_issue_yy                         GIPI_PACK_WPOLBAS.issue_yy%TYPE;
      v_issue_date                       GIPI_PACK_WPOLBAS.issue_date%TYPE := SYSDATE;
      
      v_def_cred_branch                  GIIS_PARAMETERS.param_value_v%TYPE;
      var_display_def_cred_branch        GIIS_PARAMETERS.param_value_v%TYPE;
      v_issue_param                      GIIS_PARAMETERS.param_value_v%TYPE := Giisp.V('POL_NO_ISSUE_YY');
      v_char_dummy                       VARCHAR2(32000);
      
      v_assd_no                          GIPI_PACK_PARLIST.assd_no%TYPE;
      v_line_cd                          GIPI_PACK_PARLIST.line_cd%TYPE;
      v_iss_cd                           GIPI_PACK_PARLIST.iss_cd%TYPE;

      v_subline_name                     GIIS_SUBLINE.subline_name%TYPE;
  
  BEGIN
    FOR temp_a IN (SELECT assd_no, line_cd , iss_cd 
                   FROM GIPI_PACK_PARLIST
                   WHERE pack_par_id = p_pack_par_id)
    LOOP
        v_assd_no := temp_a.assd_no;
        v_line_cd := temp_a.line_cd;
        v_iss_cd  := temp_a.iss_cd;
    END LOOP;    

    /* WHEN CREATE RECORD TRIGGER B540 BLOCK GIPIS002A*/
    GIPIS002A_B540_WHEN_CREA_REC(v_issue_param,
                                 v_issue_date,
                                 v_assd_no,
                                 v_issue_yy,
                                 v_pack_wpolbas.assd_name,
                                 v_pack_wpolbas.address1,
                                 v_pack_wpolbas.address2,
                                 v_pack_wpolbas.address3,
                                 v_pack_wpolbas.designation);
                                
     v_pack_wpolbas.assd_no    := v_assd_no; 
     v_pack_wpolbas.issue_date := v_issue_date;
     v_pack_wpolbas.issue_yy   := v_issue_yy;

    FOR A IN (
        SELECT  rv_low_value, rv_meaning
          FROM  CG_REF_CODES
         WHERE  rv_domain = 'GIPI_WPOLBAS.POL_FLAG'
          AND  rv_low_value = '1') 
    LOOP
       v_pack_wpolbas.pol_flag          := '1';
       EXIT;
    END LOOP;
        
    FOR A IN ( SELECT param_value_v 
               FROM GIIS_PARAMETERS
                WHERE param_name = 'DEFAULT_CRED_BRANCH')
    LOOP
        v_def_cred_branch := A.param_value_v;
      EXIT;
    END LOOP;
    
    GIPIS002A_B540_WHEN_CREA_REC_B (v_line_cd,
                                    v_iss_cd,
                                    v_assd_no,
                                    v_def_cred_branch,
                                    v_pack_wpolbas.pack_pol_flag,
                                    v_pack_wpolbas.industry_nm,
                                    v_pack_wpolbas.industry_cd,
                                    v_pack_wpolbas.region_desc,
                                    v_pack_wpolbas.region_cd,
                                    var_display_def_cred_branch,
                                    v_char_dummy,
                                    v_pack_wpolbas.cred_branch
                                    );
        
        v_pack_wpolbas.manual_renew_no     := '00';
        v_pack_wpolbas.reg_policy_sw       := 'Y';
        v_pack_wpolbas.same_polno_sw       := 'N';
        v_pack_wpolbas.endt_yy             := 0;
        v_pack_wpolbas.endt_seq_no         := 0;
        v_pack_wpolbas.pack_par_id         := p_pack_par_id;
        
     PIPE ROW(v_pack_wpolbas);
     
    RETURN;
  END get_gipi_pack_wpolbas_def_val;
  
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 02, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This inserts or updates record to GIPI_PACK_WPOLBAS. 
*/
PROCEDURE set_gipi_pack_wpolbas2 ( 
     p_pack_par_id              IN  GIPI_PACK_WPOLBAS.pack_par_id%TYPE,           
     p_label_tag                IN  GIPI_PACK_WPOLBAS.label_tag%TYPE,
     p_assd_no                  IN  GIPI_PACK_WPOLBAS.assd_no%TYPE,
     p_subline_cd               IN  GIPI_PACK_WPOLBAS.subline_cd%TYPE,
     p_surcharge_sw             IN  GIPI_PACK_WPOLBAS.surcharge_sw%TYPE,
     p_manual_renew_no          IN  GIPI_PACK_WPOLBAS.manual_renew_no%TYPE,
     p_discount_sw              IN  GIPI_PACK_WPOLBAS.discount_sw%TYPE,
     p_pol_flag                 IN  GIPI_PACK_WPOLBAS.pol_flag%TYPE,
     p_type_cd                  IN  GIPI_PACK_WPOLBAS.type_cd%TYPE,
     p_address1                 IN  GIPI_PACK_WPOLBAS.address1%TYPE,
     p_address2                 IN  GIPI_PACK_WPOLBAS.address2%TYPE,
     p_address3                 IN  GIPI_PACK_WPOLBAS.address3%TYPE,
     p_booking_year             IN  GIPI_PACK_WPOLBAS.booking_year%TYPE,
     p_booking_mth              IN  GIPI_PACK_WPOLBAS.booking_mth%TYPE,
     p_incept_date              IN  GIPI_PACK_WPOLBAS.incept_date%TYPE,
     p_expiry_date              IN  GIPI_PACK_WPOLBAS.expiry_date%TYPE,
     p_issue_date               IN  GIPI_PACK_WPOLBAS.issue_date%TYPE,
     p_place_cd                 IN  GIPI_PACK_WPOLBAS.place_cd%TYPE,     
     p_incept_tag               IN  GIPI_PACK_WPOLBAS.incept_tag%TYPE,
     p_expiry_tag               IN  GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
     p_risk_tag                 IN  GIPI_PACK_WPOLBAS.risk_tag%TYPE,
     p_ref_pol_no               IN  GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
     p_industry_cd              IN  GIPI_PACK_WPOLBAS.industry_cd%TYPE,
     p_region_cd                IN  GIPI_PACK_WPOLBAS.region_cd%TYPE,
     p_cred_branch              IN  GIPI_PACK_WPOLBAS.cred_branch%TYPE,
     p_quotation_printed_sw     IN  GIPI_PACK_WPOLBAS.quotation_printed_sw%TYPE,
     p_covernote_printed_sw     IN  GIPI_PACK_WPOLBAS.covernote_printed_sw%TYPE,
     p_pack_pol_flag            IN  GIPI_PACK_WPOLBAS.pack_pol_flag%TYPE,
     p_auto_renew_flag          IN  GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
     p_foreign_acc_sw           IN  GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
     p_reg_policy_sw            IN  GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,                                  
     p_prem_warr_tag            IN  GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
     p_fleet_print_tag          IN  GIPI_PACK_WPOLBAS.fleet_print_tag%TYPE,
     p_with_tariff_sw           IN  GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
     p_co_insurance_sw          IN  GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
     p_prorate_flag             IN  GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
     p_comp_sw                  IN  GIPI_PACK_WPOLBAS.comp_sw%TYPE,
     p_short_rt_percent         IN  GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,     
     p_prov_prem_tag            IN  GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,                                        
     p_prov_prem_pct            IN  GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
     p_user_id                  IN  GIPI_PACK_WPOLBAS.user_id%TYPE,
     p_line_cd                  IN  GIPI_PACK_WPOLBAS.line_cd%TYPE,
     p_designation              IN  GIPI_PACK_WPOLBAS.designation%TYPE,
     p_acct_of_cd               IN  GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
     p_iss_cd                   IN  GIPI_PACK_WPOLBAS.iss_cd%TYPE,
     p_invoice_sw               IN  GIPI_PACK_WPOLBAS.invoice_sw%TYPE,
     p_renew_no                 IN  GIPI_PACK_WPOLBAS.renew_no%TYPE,
     p_issue_yy                 IN  GIPI_PACK_WPOLBAS.issue_yy%TYPE,
     p_ref_open_pol_no          IN  GIPI_PACK_WPOLBAS.ref_open_pol_no%TYPE,
     p_same_polno_sw            IN  GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
     p_endt_yy                  IN  GIPI_PACK_WPOLBAS.endt_yy%TYPE,
     p_endt_seq_no              IN  GIPI_PACK_WPOLBAS.endt_seq_no%TYPE,
     p_mortg_name               IN  GIPI_PACK_WPOLBAS.mortg_name%TYPE,
     p_validate_tag             IN  GIPI_PACK_WPOLBAS.validate_tag%TYPE,
     p_endt_expiry_date         IN  GIPI_PACK_WPOLBAS.endt_expiry_date%TYPE,
     p_company_cd               IN  GIPI_PACK_WPOLBAS.company_cd%TYPE,
     p_employee_cd              IN  GIPI_PACK_WPOLBAS.employee_cd%TYPE,
     p_bank_ref_no              IN  GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
     p_banc_type_cd             IN  GIPI_PACK_WPOLBAS.banc_type_cd%TYPE,
     p_bancassurance_sw         IN  GIPI_PACK_WPOLBAS.bancassurance_sw%TYPE,
     p_area_cd                  IN  GIPI_PACK_WPOLBAS.area_cd%TYPE,
     p_branch_cd                IN  GIPI_PACK_WPOLBAS.branch_cd%TYPE,
     p_manager_cd               IN  GIPI_PACK_WPOLBAS.manager_cd%TYPE,
     p_plan_cd                  IN  GIPI_PACK_WPOLBAS.plan_cd%TYPE,
     p_plan_sw                  IN  GIPI_PACK_WPOLBAS.plan_sw%TYPE,
     v_update_issue_date        IN  VARCHAR2
     ) IS
    
     v_eff_date                 GIPI_WPOLBAS.eff_date%TYPE;
     v_add_time                 NUMBER;
     NEW_DATE                   DATE;
     v_incept_date              DATE;
     v_expiry_date              DATE;
     v_end_of_day               VARCHAR2(1);
     v_issue_date               DATE := SYSDATE; --added default value | cherrie | 03.24.2014
     
  BEGIN
      -- to handle saving of time for incept_date, expiry_date, eff_date and issue_date
      IF TO_NUMBER(SUBSTR(TO_CHAR(p_incept_date,'MM-DD-YYYY'),9,2)) < 50 then
        v_incept_date := TO_DATE(SUBSTR(TO_CHAR(p_incept_date,'MM-DD-YYYY'),1,6)||'20'
                         ||SUBSTR(TO_CHAR(p_incept_date,'MM-DD-YYYY'),9,2),'MM-DD-YYYY');
      ELSE
        v_incept_date := TO_DATE(SUBSTR(TO_CHAR(p_incept_date,'MM-DD-YYYY'),1,6)||'19'
                         ||SUBSTR(TO_CHAR(p_incept_date,'MM-DD-YYYY'),9,2),'MM-DD-YYYY');
      END IF;

      Get_Addtl_Time_Gipis002(p_line_cd, p_subline_cd, v_add_time);
      B540_Sublcd_Wvi_B_Gipis002(p_line_cd, p_subline_cd, v_end_of_day);

      NEW_DATE      := v_incept_date + NVL((v_add_time /86400),0);
      v_incept_date := NEW_DATE;
      v_eff_date    := v_incept_date;
        
      /*
      IF v_incept_date < TO_DATE('01-01-1997','MM-DD-YYYY') THEN
         v_issue_date := NEW_DATE;
      ELSE
         v_issue_date := SYSDATE;
      END IF;*/ --replace code above irwin 11.16.11 di na daw applicable itong condition
      
       IF v_update_issue_date = 'Y' THEN
     
         v_issue_date := SYSDATE;
       ELSE
          FOR a IN (SELECT issue_date
                      FROM GIPI_pack_WPOLBAS
                     WHERE pack_par_id =  p_pack_par_id)
          LOOP    
            v_issue_date := a.issue_date;
          END LOOP;
          
          IF giisp.v('UPDATE_ISSUE_DATE') = 'Y' THEN
            v_issue_date := p_issue_date;
          END IF;     
       END IF;
       
      --end of replaced code

      IF NVL(v_end_of_day,'N') = 'Y' THEN
         v_expiry_date := TRUNC(p_expiry_date) + 86399/86400;
      ELSE
         v_expiry_date := p_expiry_date + NVL((v_add_time /86400),0);
      END IF;  -- modified by  Nica 09.05.2011 
       
      MERGE INTO GIPI_PACK_WPOLBAS
       USING DUAL ON ( pack_par_id = p_pack_par_id )
       WHEN NOT MATCHED THEN
         INSERT (pack_par_id,       label_tag,              assd_no,                subline_cd,
                 surcharge_sw,      manual_renew_no,        discount_sw,            pol_flag,
                 type_cd,           address1,               address2,               address3,
                 booking_year,      booking_mth,            incept_date,            expiry_date,       
                 issue_date,        place_cd,               incept_tag,             expiry_tag,        
                 risk_tag,          ref_pol_no,             industry_cd,            region_cd,         
                 cred_branch,       quotation_printed_sw,   covernote_printed_sw,    pack_pol_flag,     
                 auto_renew_flag,   foreign_acc_sw,         reg_policy_sw,          prem_warr_tag,                             
                 fleet_print_tag,   with_tariff_sw,         co_insurance_sw,        prorate_flag,           
                 comp_sw,           short_rt_percent,       prov_prem_tag,          prov_prem_pct,             
                 user_id,           line_cd,                designation,            acct_of_cd,                
                 issue_yy,          eff_date,               iss_cd,                 invoice_sw,                
                 renew_no,          ref_open_pol_no,        same_polno_sw,          endt_yy,                
                 endt_seq_no,       mortg_name,             validate_tag,           endt_expiry_date,        
                 company_cd,        employee_cd,            bank_ref_no,            banc_type_cd,            
                 bancassurance_sw,  area_cd,                branch_cd,              manager_cd,                
                 plan_cd,           plan_sw
                 )
         VALUES (p_pack_par_id,     p_label_tag,            p_assd_no,              p_subline_cd,
                 p_surcharge_sw,    p_manual_renew_no,      p_discount_sw,          p_pol_flag,
                 p_type_cd,         p_address1,             p_address2,             p_address3,
                 p_booking_year,    p_booking_mth,          v_incept_date,          v_expiry_date,     
                 v_issue_date,      p_place_cd,             p_incept_tag,           p_expiry_tag,      
                 p_risk_tag,        p_ref_pol_no,           p_industry_cd,          p_region_cd,       
                 p_cred_branch,     p_quotation_printed_sw, p_covernote_printed_sw, p_pack_pol_flag,   
                 p_auto_renew_flag, p_foreign_acc_sw,       p_reg_policy_sw,        p_prem_warr_tag,           
                 p_fleet_print_tag, p_with_tariff_sw,       p_co_insurance_sw,      p_prorate_flag,         
                 p_comp_sw,         p_short_rt_percent,     p_prov_prem_tag,        p_prov_prem_pct,        
                 p_user_id,         p_line_cd,              p_designation,          p_acct_of_cd,
                 p_issue_yy,        v_eff_date,             p_iss_cd,               p_invoice_sw,
                 p_renew_no,        p_ref_open_pol_no,      p_same_polno_sw,        p_endt_yy,
                 p_endt_seq_no,     p_mortg_name,           p_validate_tag,         p_endt_expiry_date,
                 p_company_cd,      p_employee_cd,          p_bank_ref_no,          p_banc_type_cd,
                 p_bancassurance_sw,p_area_cd,              p_branch_cd,            p_manager_cd,
                 p_plan_cd,         p_plan_sw
                 )
       WHEN MATCHED THEN
         UPDATE SET 
                    label_tag               = p_label_tag,                
                    assd_no                 = p_assd_no,               
                    subline_cd              = p_subline_cd,
                    surcharge_sw            = p_surcharge_sw,     
                    manual_renew_no         = p_manual_renew_no,      
                    discount_sw             = p_discount_sw,            
                    pol_flag                = p_pol_flag,
                    type_cd                 = p_type_cd,            
                    address1                = p_address1,              
                    address2                = p_address2,                
                    address3                = p_address3,
                    booking_year            = p_booking_year,        
                    booking_mth             = p_booking_mth,                      
                    incept_date             = v_incept_date,
                    expiry_date             = v_expiry_date,        
                    issue_date              = v_issue_date,                
                    place_cd                = p_place_cd,                
                    incept_tag              = p_incept_tag,
                    expiry_tag              = p_expiry_tag,        
                    risk_tag                = p_risk_tag,             
                    ref_pol_no              = p_ref_pol_no,            
                    industry_cd             = p_industry_cd,
                    region_cd               = p_region_cd,        
                    cred_branch             = p_cred_branch,          
                    quotation_printed_sw    = p_quotation_printed_sw,    
                    covernote_printed_sw    = p_covernote_printed_sw,
                    pack_pol_flag           = p_pack_pol_flag,    
                    auto_renew_flag         = p_auto_renew_flag,      
                    foreign_acc_sw          = p_foreign_acc_sw,        
                    reg_policy_sw           = p_reg_policy_sw,                              
                    prem_warr_tag           = p_prem_warr_tag,    
                    fleet_print_tag         = p_fleet_print_tag,        
                    with_tariff_sw          = p_with_tariff_sw,
                    co_insurance_sw         = p_co_insurance_sw,    
                    prorate_flag            = p_prorate_flag,          
                    comp_sw                 = p_comp_sw,                
                    short_rt_percent        = p_short_rt_percent,
                    prov_prem_tag           = p_prov_prem_tag,      
                    prov_prem_pct           = p_prov_prem_pct,            
                    user_id                 = p_user_id,            
                    line_cd                 = p_line_cd,              
                    designation             = p_designation,            
                    acct_of_cd              = p_acct_of_cd,
                    issue_yy                = p_issue_yy,
                    eff_date                = v_eff_date,
                    iss_cd                  = p_iss_cd,
                    invoice_sw              = p_invoice_sw,
                    renew_no                = p_renew_no,
                    ref_open_pol_no         = p_ref_open_pol_no,
                    same_polno_sw           = p_same_polno_sw,
                    endt_yy                 = p_endt_yy,
                    endt_seq_no             = p_endt_seq_no,
                    mortg_name              = p_mortg_name,
                    validate_tag            = p_validate_tag,
                    endt_expiry_date        = p_endt_expiry_date,
                    company_cd              = p_company_cd,
                    employee_cd             = p_employee_cd,
                    bank_ref_no             = p_bank_ref_no,
                    banc_type_cd            = p_banc_type_cd,
                    bancassurance_sw        = p_bancassurance_sw,  
                    area_cd                 = p_area_cd,                
                    branch_cd               = p_branch_cd,              
                    manager_cd              = p_manager_cd,
                    plan_cd                 = p_plan_cd,
                    plan_sw                 = p_plan_sw;
  END set_gipi_pack_wpolbas2;
  
  FUNCTION CHECK_POL_FOR_ENDT_TO_CANCEL (
        p_line_cd            IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
        p_subline_cd        IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
        p_issue_yy            IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no            IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
  RETURN VARCHAR2
  AS
        /*
        **  Created by        : Emman
        **  Date Created     : 03.08.2011
        **  Reference By     : (GIPIS031A - Package Endt Basic Information)
        **  Description     : This function checks if policy have affecting endorsement that can be cancelled    
        */
        v_endt_sw VARCHAR2(1) := 'N';
  BEGIN
        FOR A IN (
            SELECT '1' 
              FROM gipi_pack_polbasic a --A.R.C. 07.27.2006
             WHERE EXISTS (SELECT '1' 
                             FROM gipi_itmperil b, gipi_polbasic c
                            WHERE 1=1
                              AND c.pack_policy_id = a.pack_policy_id 
                              AND b.policy_id = c.policy_id 
                              AND (nvl(a.tsi_amt,0) <> 0 or nvl(a.prem_amt,0) <> 0)) 
               AND a.pol_flag in ('1','2','3') 
               AND nvl(a.endt_seq_no,0) > 0
               AND a.line_cd = p_line_cd 
               AND a.subline_cd = p_subline_cd 
               AND a.iss_cd = p_iss_cd 
               AND a.issue_yy = p_issue_yy 
               AND a.pol_seq_no = p_pol_seq_no 
               AND a.renew_no = p_renew_no)
              LOOP
                v_endt_sw := 'Y';
                EXIT;
            END LOOP;
            
            RETURN v_endt_sw;
  END CHECK_POL_FOR_ENDT_TO_CANCEL;
  
  FUNCTION check_gipi_witmperl_exists (p_par_id            IN GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2
  IS
    /*
    **  Created by        : Emman
    **  Date Created     : 03.08.2011
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : This function checks for the existence of peril of specified pack par id
    */
    v_exist           VARCHAR2(1) := 'N';
  BEGIN
      FOR A IN (SELECT '1'
                FROM gipi_witmperl
               WHERE EXISTS (SELECT 1
                               FROM gipi_parlist
                              WHERE gipi_parlist.par_id = gipi_witmperl.par_id
                                AND gipi_parlist.pack_par_id = p_par_id))
    LOOP
        v_exist := 'Y';
    END LOOP;
    
    RETURN v_exist;
  END check_gipi_witmperl_exists;

  FUNCTION check_gipi_witem_exists (p_par_id            IN GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2
  IS
    /*
    **  Created by        : Emman
    **  Date Created     : 03.09.2011
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : This function checks for the existence of item(s) of specified pack par id
    */
    v_exist           VARCHAR2(1) := 'N';
  BEGIN
      FOR A IN (SELECT '1'
                 FROM gipi_witem
                WHERE EXISTS (SELECT 1
                                FROM gipi_parlist
                               WHERE gipi_parlist.par_id = gipi_witem.par_id
                                 AND gipi_parlist.pack_par_id = p_par_id))
    LOOP
        v_exist := 'Y';
    END LOOP;
    
    RETURN v_exist;
  END check_gipi_witem_exists;
  
  FUNCTION GET_RECORDS_FOR_PACK_ENDT (
        p_line_cd        IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
        p_subline_cd    IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
        p_issue_yy        IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no        IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
    RETURN Gipis031_Ref_Cursor_Pkg.cancel_record_tab PIPELINED
    AS
        /*
        **  Created by        : Emman
        **  Date Created     : 03.09.2011
        **  Reference By     : (GIPIS031A - Pack Endt Basic Information)
        **  Description     : This function returns records
        **                  : for pack endt cancellation    
        */
        v_table Gipis031_Ref_Cursor_Pkg.gipis031_cancel_records_type;
    BEGIN
        FOR i IN (select a.endt_iss_cd||'-'||ltrim(rtrim(to_char(a.endt_yy,'09'))) ||'-'||ltrim(rtrim(to_char(a.endt_seq_no,'099999'))) endorsement, 
                            a.pack_policy_id policy_id 
                    from gipi_pack_polbasic a 
                   where exists (select '1' 
                                        from gipi_itmperil b, gipi_polbasic z 
                                  where b.policy_id = z.policy_id 
                                    and z.pack_policy_id = a.pack_policy_id 
                                    and (nvl(a.tsi_amt,0) <> 0 
                                     or nvl(a.prem_amt,0) <> 0)) 
                    and a.pol_flag in ('1','2','3') 
                    and nvl(a.endt_seq_no,0) > 0 
                    and a.line_cd = p_line_cd 
                    and a.subline_cd = p_subline_cd 
                    and a.iss_cd = p_iss_cd 
                    and a.issue_yy = p_issue_yy 
                      and a.pol_seq_no = p_pol_seq_no 
                      and a.renew_no = p_renew_no)
        LOOP
            v_table.endorsement := i.endorsement;
            v_table.policy_id := i.policy_id;
            
            PIPE ROW(v_table);
        END LOOP;
        
        RETURN;
    END GET_RECORDS_FOR_PACK_ENDT;
    
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 10, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This generates bank reference no. for Package PAR Bank Payment Details. 
**                            
*/

PROCEDURE generate_bank_ref_no_for_pack(
    p_pack_par_id        IN   gipi_pack_wpolbas.pack_par_id%TYPE,
    p_acct_iss_cd        IN   giis_ref_seq.acct_iss_cd%TYPE,
    p_branch_cd          IN   giis_ref_seq.branch_cd%TYPE,
    p_bank_ref_no       OUT   gipi_pack_wpolbas.bank_ref_no%TYPE,
    p_msg_alert         OUT   VARCHAR2
    ) IS 
        v_ref_no        giis_ref_seq.ref_no%TYPE;
        v_dsp_mod_no    gipi_ref_no_hist.mod_no%TYPE;
    BEGIN    
        generate_ref_no (p_acct_iss_cd, p_branch_cd, v_ref_no,'GIPIS002A');
        BEGIN
        SELECT mod_no
          INTO v_dsp_mod_no
          FROM gipi_ref_no_hist
         WHERE acct_iss_cd = p_acct_iss_cd
           AND branch_cd = p_branch_cd
           AND ref_no = v_ref_no;
           
           p_bank_ref_no := LPAD (p_acct_iss_cd, 2, 0)|| '-'
            || LPAD (p_branch_cd, 4, 0)|| '-'
            || LPAD (v_ref_no, 7, 0)|| '-'
            || LPAD (v_dsp_mod_no, 2, 0);
            
           UPDATE gipi_pack_wpolbas
             SET bank_ref_no = p_bank_ref_no
           WHERE pack_par_id = p_pack_par_id;
           
           UPDATE gipi_wpolbas
             SET bank_ref_no = p_bank_ref_no
           WHERE pack_par_id = p_pack_par_id;
           COMMIT;
            
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_msg_alert := 'Please double check your data in generating a bank reference number.';
            ROLLBACK;
            RETURN;
        END;   
    END;
    
  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011  
  **  Reference By : (GIPIS055a - POST PACKAGE PAR) 
  **  Description  : COPY_PACK_POL_WPOLBAS program unit 
  */  
    PROCEDURE COPY_PACK_POL_WPOLBAS(
        p_pack_par_id           IN gipi_parlist.pack_par_id%TYPE,
        p_line_cd               IN gipi_parlist.line_cd%TYPE,
        p_iss_cd                IN gipi_parlist.iss_cd%TYPE,
        p_par_type              IN gipi_parlist.par_type%TYPE,
        p_pack_policy_id       OUT VARCHAR2,
        p_msg_alert            OUT VARCHAR2,
        p_change_stat           IN VARCHAR2
        ) IS
      v_incept_dt                 gipi_pack_polbasic.incept_date%TYPE;
      v_expiry_dt                gipi_pack_polbasic.expiry_date%TYPE;
      v_expiry_tag              gipi_pack_polbasic.expiry_tag%TYPE;
      v_incept_tag              gipi_pack_polbasic.incept_tag%TYPE;
      v_eff_dt                    gipi_pack_polbasic.eff_date%TYPE;
      v_issue_dt                gipi_pack_polbasic.issue_date%TYPE;
      v_pol_flag                gipi_pack_polbasic.pol_flag%TYPE;
      v_assd_no                    gipi_pack_polbasic.assd_no%TYPE;
      v_designation                gipi_pack_polbasic.designation%TYPE;
      v_pol_addr1                gipi_pack_polbasic.address1%TYPE;
      v_pol_addr2                gipi_pack_polbasic.address2%TYPE;
      v_pol_addr3                gipi_pack_polbasic.address3%TYPE;
      v_mortg_name                gipi_pack_polbasic.mortg_name%TYPE;
      v_tsi_amt                    gipi_pack_polbasic.tsi_amt%TYPE;
      v_prem_amt                gipi_pack_polbasic.prem_amt%TYPE;
      v_ann_tsi                    gipi_pack_polbasic.ann_tsi_amt%TYPE;
      v_ann_prem                gipi_pack_polbasic.ann_prem_amt%TYPE;
      v_invoices                gipi_pack_polbasic.invoice_sw%TYPE;    
      v_user_id                    gipi_pack_polbasic.user_id%TYPE;
      v_pool_pol_no                gipi_pack_polbasic.pool_pol_no%TYPE;
      v_foreign_acc_tag         gipi_pack_polbasic.foreign_acc_sw%TYPE;
      v_policy_id                gipi_pack_polbasic.pack_policy_id%TYPE;      
      v_issue_yy                gipi_pack_polbasic.issue_yy%TYPE;
      v_renew_no                gipi_pack_polbasic.renew_no%TYPE;
      v_subline_cd                gipi_pack_polbasic.subline_cd%TYPE;
      v_auto_renew_flag            gipi_pack_polbasic.auto_renew_flag%TYPE;
      v_no_of_items                gipi_pack_polbasic.no_of_items%TYPE;
      v_endt_yy                    gipi_pack_polbasic.endt_yy%TYPE := 0;
      v_pol_seq_no                  gipi_pack_polbasic.pol_seq_no%TYPE;
      v_endt_expiry_date        gipi_pack_polbasic.endt_expiry_date%TYPE;
      v_subline_type_cd            gipi_pack_polbasic.subline_type_cd%TYPE;
      v_prorate_flag            gipi_pack_polbasic.prorate_flag%TYPE;
      v_short_rt_percent        gipi_pack_polbasic.short_rt_percent%TYPE;
      v_prov_prem_tag           gipi_pack_polbasic.prov_prem_tag%TYPE;
      v_type_cd                 gipi_pack_polbasic.type_cd%TYPE;
      v_acct_of_cd              gipi_pack_polbasic.acct_of_cd%TYPE;
      v_pack_pol_flag           gipi_pack_polbasic.pack_pol_flag%TYPE;
      v_prem_warr_tag           gipi_pack_polbasic.prem_warr_tag%TYPE;  
      v_ref_pol_no              gipi_pack_polbasic.ref_pol_no%TYPE;    
      v_reg_policy_sw           gipi_pack_polbasic.reg_policy_sw%TYPE;   
      v_co_insurance_sw          gipi_pack_polbasic.co_insurance_sw%TYPE; 
      v_discount_sw             gipi_pack_polbasic.discount_sw%TYPE;    
      v_surcharge_sw            gipi_pack_polbasic.surcharge_sw%TYPE;    
      v_ref_open_pol_no         gipi_pack_polbasic.ref_open_pol_no%TYPE; 
      v_booking_mth             gipi_pack_polbasic.booking_mth%TYPE;     
      v_booking_year            gipi_pack_polbasic.booking_mth%TYPE;     
      v_fleet_print_tag         gipi_pack_polbasic.fleet_print_tag%TYPE; 
      v_endt_expiry_tag         gipi_pack_polbasic.endt_expiry_tag%TYPE;  
      v_manual_renew_no         gipi_pack_polbasic.manual_renew_no%TYPE;  
      v_with_tariff_sw          gipi_pack_polbasic.with_tariff_sw%TYPE;   
      v_comp_sw                 gipi_pack_polbasic.comp_sw%TYPE;
      v_orig_policy_id          gipi_pack_polbasic.orig_policy_id%TYPE;
      v_prov_prem_pct           gipi_pack_polbasic.prov_prem_pct%TYPE;
      alert_button                 NUMBER;
      v_region_cd               gipi_pack_polbasic.region_cd%TYPE;
      v_industry_cd               gipi_pack_polbasic.industry_cd%TYPE;
      v_place_cd                gipi_pack_polbasic.place_cd%TYPE;
      v_actual_renew_no         gipi_pack_polbasic.actual_renew_no%TYPE;
      v_count_id                gipi_pack_polbasic.pack_policy_id%TYPE;
      v_exit_sw                 VARCHAR2(1); 
      v_acct_of_cd_sw           gipi_pack_polbasic.acct_of_cd_sw%TYPE;
      v_cred_branch             gipi_pack_polbasic.cred_branch%TYPE;
      v_old_assd_no             gipi_pack_polbasic.old_assd_no%TYPE;
      v_old_address1            gipi_pack_polbasic.old_address1%TYPE;
      v_old_address2            gipi_pack_polbasic.old_address2%TYPE;  
      v_old_address3            gipi_pack_polbasic.old_address3%TYPE;        
      v_cancel_date                gipi_pack_polbasic.cancel_date%TYPE;
      v_label_tag               gipi_pack_polbasic.label_tag%TYPE;
      v_line_cd                    gipi_pack_polbasic.line_cd%TYPE;
      v_iss_cd                    gipi_pack_polbasic.iss_cd%TYPE;
      v_risk_tag                gipi_pack_polbasic.risk_tag%TYPE;
      v_bank_ref_no                gipi_polbasic.bank_ref_no%TYPE;
      v_plan_sw                    gipi_pack_polbasic.plan_sw%TYPE;
      v_plan_cd                    gipi_pack_polbasic.plan_cd%TYPE;                
      v_plan_ch_tag                gipi_pack_polbasic.plan_ch_tag%TYPE;
      
    BEGIN
        
      BEGIN
        SELECT pack_polbasic_policy_id_s.NEXTVAL
          INTO p_pack_policy_id 
          FROM DUAL;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             p_msg_alert := 'Cannot generate new POLICY ID.';
             RETURN;
      END;

      BEGIN
        SELECT COUNT(*)
          INTO v_no_of_items
          FROM gipi_witem
         WHERE EXISTS (SELECT 1
                         FROM gipi_parlist z
                        WHERE z.par_id = gipi_witem.par_id
                          AND z.pack_par_id = p_pack_par_id);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL;
      END;
      
      SELECT issue_yy,incept_date,expiry_date,NVL(eff_date,incept_date),NVL(issue_date,TRUNC(SYSDATE)),pol_flag,
             assd_no,designation,address1,address2,address3,mortg_name,tsi_amt,prem_amt,ann_tsi_amt,
             ann_prem_amt,invoice_sw,user_id,pool_pol_no,foreign_acc_sw,renew_no,subline_cd,
             auto_renew_flag,pol_seq_no,
             endt_expiry_date,subline_type_cd,prorate_flag,short_rt_percent,
             prov_prem_tag,type_cd,acct_of_cd,pack_pol_flag, expiry_tag,
      --BETH 010799 add transfering of new fields prem_warr_tag and ref_pol_no
             prem_warr_tag, ref_pol_no, reg_policy_sw, co_insurance_sw,discount_sw,
             ref_open_pol_no, incept_tag, booking_mth, booking_year,fleet_print_tag,
             endt_expiry_tag, manual_renew_no, with_tariff_sw, --BETH
             comp_sw, orig_policy_id, prov_prem_pct, place_cd, region_cd, industry_cd,
             acct_of_cd_sw, surcharge_sw, cred_branch, old_assd_no, 
             old_address1, old_address2, old_address3, risk_tag, label_tag,line_cd,iss_cd, bank_ref_no, 
             plan_sw, plan_cd, plan_ch_tag  -- marion 06.29.2010
        INTO v_issue_yy,v_incept_dt,v_expiry_dt,
             v_eff_dt,v_issue_dt,v_pol_flag,v_assd_no,
             v_designation,v_pol_addr1,v_pol_addr2,v_pol_addr3,    
             v_mortg_name,v_tsi_amt,v_prem_amt,
             v_ann_tsi,v_ann_prem,v_invoices,
             v_user_id,v_pool_pol_no,v_foreign_acc_tag,v_renew_no,v_subline_cd,
             v_auto_renew_flag,v_pol_seq_no,
             v_endt_expiry_date,v_subline_type_cd,v_prorate_flag,v_short_rt_percent,
             v_prov_prem_tag,v_type_cd,v_acct_of_cd,v_pack_pol_flag, v_expiry_tag,
             v_prem_warr_tag, v_ref_pol_no, v_reg_policy_sw, v_co_insurance_sw, 
             v_discount_sw, v_ref_open_pol_no, v_incept_tag, v_booking_mth,
             v_booking_year, v_fleet_print_tag, v_endt_expiry_tag, v_manual_renew_no,
             v_with_tariff_sw, v_comp_sw, v_orig_policy_id, v_prov_prem_pct, v_place_cd,
             v_region_cd, v_industry_cd, v_acct_of_cd_sw, v_surcharge_sw, v_cred_branch, 
             v_old_assd_no, v_old_address1, v_old_address2, v_old_address3, 
             v_risk_tag, v_label_tag,v_line_cd,v_iss_cd,v_bank_ref_no,
             v_plan_sw, v_plan_cd, v_plan_ch_tag  --marion 06.29.2010
        FROM gipi_pack_wpolbas
       WHERE pack_par_id  = p_pack_par_id;
      -- for endorsement year value --
      IF p_par_type = 'E' THEN
         v_endt_yy    := v_issue_yy;
         gipi_pack_parlist_pkg.check_package_cancellation(v_ann_tsi, p_pack_par_id);
          
         IF p_change_stat = 'Y' AND v_ann_tsi = 0 THEN  
           v_pol_flag := 4;   
         END IF; 
         
         --BETH 041599 update pol_flag of the policy and all previous endorsement to 4 
         --            and save the current pol_flag to old_pol_flag
         IF v_pol_flag = '4' AND v_ann_tsi = 0 /*and variables.affecting <> 'N'*/ THEN   -- aaron added v_ann_tsi = 0 091807
            
            UPDATE gipi_pack_polbasic
               SET old_pol_flag =  pol_flag,
                   pol_flag     =  '4'  ,
                   eis_flag     =  'N'           
             WHERE line_cd     = p_line_cd
               AND subline_cd  = v_subline_cd
               AND iss_cd      = p_iss_cd
               AND issue_yy    = v_issue_yy
               AND pol_seq_no  = v_pol_seq_no
               AND renew_no    = v_renew_no
               AND pol_flag  IN ('1','2','3');
            v_cancel_date := SYSDATE;
         ELSIF v_pol_flag = '4' AND NVL(v_ann_tsi,0) != 0 THEN  -- added by aaron 080409
           v_pol_flag := '1'; 
         END IF;    
      --BETH 102299 for renewal/replacement policies that will use same policy no 
      --            extract the policy no of policy to be renew
      --BETH 102299 for renewal/replacement policies that will use same policy no 
      --            extract the policy no of policy to be renew
      --BETH 02062001 for renewal or replacement renew_no must accumulate
      --       regardless if it will use same policy or not
      ELSE
         FOR RENEW IN
             ( SELECT b.old_pack_policy_id id, NVL(a.same_polno_sw,'N') same_sw,
                      a.pol_flag --beth 04162001 to be use in determining value of actual_renew_no   
                 FROM gipi_pack_wpolbas a, gipi_pack_wpolnrep b
                WHERE a.pack_par_id = b.pack_par_id
                  and a.pack_par_id = p_pack_par_id
                  AND a.pol_flag in ('2','3'))
                  --BETH 02062001 comment out validation for same policy no 
                  --     so that renew no. will accumulate regardless if it will
                  --     use same policy no or not    
                  --AND NVL(a.same_polno_sw,'N') = 'Y'   
         LOOP 
           FOR OLD_DATA IN
               ( SELECT line_cd, subline_cd, iss_cd,issue_yy, pol_seq_no, renew_no, actual_renew_no,
                        manual_renew_no
                   FROM gipi_pack_polbasic
                  WHERE pack_policy_id  = renew.id)
           LOOP
             -- for policy that will use same no. copy pol_seq_no and issue_yy 
             -- from the old policy  
             IF renew.same_sw = 'Y' THEN    
                v_issue_yy   := old_data.issue_yy;
                v_pol_seq_no := old_data.pol_seq_no;
             END IF;   
             --BETH 04162001
             --     get max renew_no for the policy to be renewed 
             --     so that error for unique constraints will be eliminated 
             FOR  MAX_REN IN (SELECT renew_no, 
                                     DECODE(pack_policy_id, renew.id,manual_renew_no, 0) manual_renew_no
                                FROM gipi_pack_polbasic
                               WHERE line_cd = old_data.line_cd       
                                 AND subline_cd = old_data.subline_cd
                                 AND iss_cd = old_data.iss_cd
                                 AND issue_yy = old_data.issue_yy
                                 AND pol_seq_no = old_data.pol_seq_no
                              ORDER BY renew_no desc)
             LOOP                    
               --if old policy has an existing manual_renew_no the renew no of the 
               --new policy will be the manual_renew_no + 1 else the renew_no is the 
               --old renew_no + 1
               IF NVL(max_ren.manual_renew_no,0) > 0 THEN
                    v_renew_no   := nvl(max_ren.manual_renew_no,0) + 1;
               ELSE    
                  -- if policy is for replacement and new policy number is to be generated then 
                  -- renew number must be retained else renew number must be incremented
                  -- added by aivhie 120601
                  IF renew.pol_flag = '3' AND renew.same_sw = 'N' THEN 
                    v_renew_no   := nvl(max_ren.renew_no,0);
                  --added by iris bordey (09.18.2002)
                  --to handle a special case (for AUII) of renewing 1 policy to many/several policies.
                  --if renewing policy and nwe polict is to be generated then
                  --renew_no must be incremented from the renew_no(old_date.renew_no) of the policy to be renewed.
                  ELSIF renew.pol_flag = '2' AND renew.same_sw = 'N' THEN 
                    v_renew_no := nvl(old_data.renew_no,0) + 1;
                  ELSE
                    v_renew_no   := nvl(max_ren.renew_no,0) + 1;
                  END IF;
               END IF;   
               EXIT;
             END LOOP;    
             --BETH 04162001 for renewal populate field actual_renew_no if actual_renew_no
             --     is already existing in policy being renewd just accumulate it by 1 but if it is not yet 
             --     existing retrieved it by counting no. of renewals for the policy in gipi_polnrep for policy
             --     that is not spoiled                 
             IF renew.pol_flag = '2' THEN
                  --if actual_renew_no is already populated in the policy being renewed
                  --then add 1 to its actual renewed no     
                  IF NVL(old_data.actual_renew_no,0) > 0 THEN
                     v_actual_renew_no := old_data.actual_renew_no + 1;                    
                  ELSE
                     --if actual_renew_no of the policy being renew is null then
                     --actual_renew_no would be 1 + manual_renew_no    
                     v_actual_renew_no := NVL(old_data.manual_renew_no,0) +1;
                     v_count_id := renew.id;
                     v_exit_sw := 'Y';
                     --check history of renewal of policy and for every renewal that is 
                     --not spoiled add 1 to actual_renew_no
                     WHILE v_exit_sw = 'Y'
                     LOOP
                     v_exit_sw := 'N';   
                         FOR A IN (SELECT b610.old_pack_policy_id, 
                                          b250a.manual_renew_no
                                     FROM gipi_pack_polbasic b250, gipi_pack_polbasic b250a,
                                          gipi_pack_polnrep b610
                                    WHERE b250.pack_policy_id = b610.new_pack_policy_id
                                      AND b250a.pack_policy_id = b610.old_pack_policy_id
                                      AND b250.pol_flag NOT IN( '4','5')
                                      AND b610.new_pack_policy_id = v_count_id)
                         LOOP
                             v_actual_renew_no := v_actual_renew_no + NVL(a.manual_renew_no,0) + 1;
                             v_count_id := a.old_pack_policy_id;              
                           v_exit_sw := 'Y'; 
                           EXIT;
                         END LOOP;
                         IF v_exit_sw = 'N' THEN
                              EXIT;
                         END IF;
                     END LOOP;                  
                  END IF;     
             END IF;
           END LOOP;
         END LOOP;
      END IF;
      BEGIN
        /* Revised on 04 September 1997.
        */
        
        INSERT INTO gipi_pack_polbasic
                   (pack_policy_id,    line_cd,    subline_cd,    iss_cd,        issue_yy,
                    pol_seq_no,    endt_iss_cd,    endt_yy,    endt_seq_no,    renew_no,
                    endt_type,    pack_par_id,        incept_date,    expiry_date,    eff_date,
                    issue_date,    pol_flag,    assd_no,    designation,    address1,
                    address2,    address3,    mortg_name,    tsi_amt,    prem_amt,
                    ann_tsi_amt,    ann_prem_amt,    pool_pol_no,    foreign_acc_sw,    invoice_sw,
                    user_id,    last_upd_date,    spld_flag,    dist_flag,    endt_expiry_date,
                    no_of_items,    subline_type_cd,auto_renew_flag,prorate_flag,    short_rt_percent,
                    prov_prem_tag,    type_cd,    acct_of_cd,     pack_pol_flag,    expiry_tag,
                    prem_warr_tag,  ref_pol_no,     reg_policy_sw,  co_insurance_sw,discount_sw,
                    ref_open_pol_no,incept_tag ,    booking_mth,    endt_expiry_tag,
                    booking_year,   fleet_print_tag, manual_renew_no, with_tariff_sw,
                    comp_sw, orig_policy_id, prov_prem_pct, place_cd,
                    actual_renew_no, region_cd, industry_cd,acct_of_cd_sw,
                    surcharge_sw, cred_branch, old_assd_no, cancel_date,
                    old_address1, old_address2, old_address3, risk_tag, label_tag, bank_ref_no,
                    plan_sw, plan_cd, plan_ch_tag)  -- marion 06.29.2010
             VALUES(p_pack_policy_id,    p_line_cd,    v_subline_cd,    p_iss_cd,    v_issue_yy,
                    v_pol_seq_no,        p_iss_cd,    v_endt_yy,0,    v_renew_no,    
                    null/* null lang naman sya lage dito - nok- variables.affecting*/,    p_pack_par_id,    v_incept_dt,    v_expiry_dt,
                    v_eff_dt,        v_issue_dt,        v_pol_flag,    v_assd_no,
                    decode(v_designation, NULL, ' ', v_designation),
                    v_pol_addr1,        v_pol_addr2,    v_pol_addr3,
                    v_mortg_name,        
                    decode(v_tsi_amt, NULL, 0, v_tsi_amt),
                    decode(v_prem_amt, NULL, 0, v_prem_amt),
                    decode(v_ann_tsi, NULL, 0, v_ann_tsi),
                    decode(v_ann_prem, NULL, 0, v_ann_prem),
                    decode(v_pool_pol_no, NULL, ' ', v_pool_pol_no),
                    v_foreign_acc_tag,        v_invoices,
                    giis_users_pkg.app_user,    SYSDATE,        '1',        '1',
                    v_endt_expiry_date,    v_no_of_items,        v_subline_type_cd,
                    decode(v_auto_renew_flag, NULL, ' ', v_auto_renew_flag),
                    v_prorate_flag,        
                    decode(v_short_rt_percent,NULL, 0, v_short_rt_percent),
                    v_prov_prem_tag,    v_type_cd,v_acct_of_cd,v_pack_pol_flag,     
                    decode(v_expiry_tag, NULL, 'N', v_expiry_tag),
                    v_prem_warr_tag, v_ref_pol_no, v_reg_policy_sw, v_co_insurance_sw, 
                    v_discount_sw, v_ref_open_pol_no, v_incept_tag, v_booking_mth,
                    v_endt_expiry_tag, v_booking_year, v_fleet_print_tag,
                    v_manual_renew_no, v_with_tariff_sw, v_comp_sw, v_orig_policy_id,
                    v_prov_prem_pct, v_place_cd,
                    v_actual_renew_no, v_region_cd, v_industry_cd, v_acct_of_cd_sw, 
                    v_surcharge_sw, v_cred_branch, v_old_assd_no, v_cancel_date,
                    v_old_address1, v_old_address2, v_old_address3,v_risk_tag, v_label_tag, v_bank_ref_no,
                    v_plan_sw, v_plan_cd, v_plan_ch_tag);
      END;
    END;    
  
  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-13-2011  
  **  Reference By : (GIPIS055a - POST PACKAGE PAR) 
  **  Description  : 
  */     
    PROCEDURE del_gipi_pack_wpolbas(p_pack_par_id         gipi_pack_wpolbas.pack_par_id%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_pack_wpolbas
              WHERE pack_par_id      = p_pack_par_id;  
    END; 
      
END gipi_pack_wpolbas_pkg;
/


