CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wpolbas_Pkg AS
  /*
  **  Created by   :  Jerome Orio
  **  Date Created :  February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information Details)
  **  Description  : This retrieves the basic information default value. 
  */   
  FUNCTION get_gipi_wpolbas_default_value (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN gipi_wpolbas_tab PIPELINED IS
      
      v_wpolbas                             gipi_wpolbas_type;

      cg$ctrl_date_format                  VARCHAR2(50);
      variables_lc_MH                      GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_AV                      GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_MC                       GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_AC                       GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_FI                       GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_MN                       GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_CA                       GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_lc_EN                       GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_v_ri_cd                   GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_subline_bbi              GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_subline_MI                  GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_subline_MOP               GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
      variables_v_advance_booking            VARCHAR2(1);
      variables_dflt_takeup_term            GIIS_TAKEUP_TERM.takeup_term%TYPE;
      var_dflt_takeup_term_desc          GIIS_TAKEUP_TERM.takeup_term_desc%TYPE;
      variables_override_takeup_term      GIIS_PARAMETERS.param_value_v%TYPE;
      
      v_def_cred_branch                       GIIS_PARAMETERS.param_value_v%TYPE;
      var_display_def_cred_branch           GIIS_PARAMETERS.param_value_v%TYPE;
      var_v_clm_stat_cancel                 GIIS_PARAMETERS.param_value_v%TYPE;
      
      p_exist                             NUMBER;

      v_issue_yy                         GIPI_WPOLBAS.issue_yy%TYPE;
      v_issue_date                         GIPI_WPOLBAS.issue_date%TYPE := SYSDATE;
      v_issue_param                       GIIS_PARAMETERS.param_value_v%TYPE := Giisp.V('POL_NO_ISSUE_YY');
        v_char_dummy                         VARCHAR2(32000);
      
      v_assd_no                             GIPI_PARLIST.assd_no%TYPE;
      v_line_cd                             GIPI_PARLIST.line_cd%TYPE;
      v_iss_cd                             GIPI_PARLIST.iss_cd%TYPE;

      v_subline_name                     GIIS_SUBLINE.subline_name%TYPE;
  BEGIN
  /*WHEN NEW FORM INSTANCE */ 
         Initialize_Parameters_Gipis002
                 (cg$ctrl_date_format,
                variables_lc_MH,
                variables_lc_AV,
                variables_lc_MC,
                variables_lc_AC,
                variables_lc_FI,
                variables_lc_MN,
                variables_lc_CA,
                variables_lc_EN,
                variables_v_ri_cd,
                variables_subline_bbi,
                variables_subline_MI,
                variables_subline_MOP,
                variables_v_advance_booking,
                variables_dflt_takeup_term,
                var_dflt_takeup_term_desc,
                variables_override_takeup_term); 

    --TEMP
    FOR temp_a IN (SELECT assd_no, line_cd , iss_cd 
                        FROM GIPI_PARLIST
                       WHERE par_id = p_par_id)
    LOOP
        v_assd_no := temp_a.assd_no;
        v_line_cd := temp_a.line_cd;
        v_iss_cd  := temp_a.iss_cd;
    END LOOP;    

    /* WHEN CREATE RECORD TRIGGER B540 BLOCK GIPIS002*/
     When_Cre_Rec_B540_Gipis002(p_par_id, 
                                 p_exist, 
                                v_issue_yy, 
                                v_issue_param, 
                                v_issue_date, 
                                v_assd_no, 
                                v_wpolbas.assd_name,
                                v_wpolbas.address1, 
                                v_wpolbas.address2, 
                                v_wpolbas.address3, 
                                v_wpolbas.designation);
                                
     v_wpolbas.assd_no    := v_assd_no; 
     v_wpolbas.issue_date := v_issue_date;

        FOR A IN (
            SELECT  rv_low_value, rv_meaning
              FROM  CG_REF_CODES
             WHERE  rv_domain = 'GIPI_WPOLBAS.POL_FLAG'
               AND  rv_low_value = '1') LOOP
           v_wpolbas.pol_flag          := '1';
         EXIT;
        END LOOP;
        
        FOR A IN ( SELECT param_value_v 
              FROM GIIS_PARAMETERS
             WHERE param_name = 'DEFAULT_CRED_BRANCH')
         LOOP
             v_def_cred_branch := A.param_value_v;
          EXIT;
        END LOOP;
        
        When_Cre_Rec_B_B540_Gipis002(v_line_cd, 
                                     v_wpolbas.pack_pol_flag, 
                                     v_assd_no, 
                                     v_char_dummy, 
                                     v_wpolbas.industry_cd, 
                                     v_iss_cd, 
                                     v_char_dummy,
                                      v_wpolbas.region_cd, 
                                     v_char_dummy, 
                                     v_def_cred_branch, 
                                     v_char_dummy, 
                                     v_wpolbas.cred_branch, 
                                      v_wpolbas.takeup_term, 
                                     variables_dflt_takeup_term, 
                                     v_char_dummy, 
                                     v_char_dummy);
        
        v_wpolbas.manual_renew_no     := '00';
        v_wpolbas.reg_policy_sw      := 'Y';
        v_wpolbas.same_polno_sw         := 'N';
        v_wpolbas.endt_yy             := 0;
         v_wpolbas.endt_seq_no         := 0;
        v_wpolbas.par_id                := p_par_id;
        v_wpolbas.iss_cd                := v_iss_cd; --added by christian 03/15/2013
     PIPE ROW(v_wpolbas);
    RETURN;
  END get_gipi_wpolbas_default_value; 

  /*
  **  Created by   :  Jerome Orio
  **  Date Created :  February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information Details)
  **  Description  : This retrieves the basic information details records of the given par_id. 
  */ 
  FUNCTION get_gipi_wpolbas (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN gipi_wpolbas_tab PIPELINED IS
    v_wpolbas                             gipi_wpolbas_type;
    v_assd_no                              GIPI_WPOLBAS.assd_no%TYPE;
    
    -- marco - SR-23211 - 11.14.2016
    v_survey_payee_class        giis_parameters.param_value_v%TYPE := giisp.v('SURVEY_PAYEE_CLASS');
    v_settling_payee_class      giis_parameters.param_value_v%TYPE := giisp.v('SETTLING_PAYEE_CLASS');
  BEGIN
      -- edited by d.alcantara, 09-13-2011, edited query for assd_name and in account of
      FOR i IN (
        SELECT a.par_id,                    a.label_tag,        a.assd_no,                      /*b.assd_name,            
               c.assd_name in_account_of, */a.subline_cd,       a.surcharge_sw,                 a.manual_renew_no,       
               a.discount_sw,               a.pol_flag,         d.rv_meaning pol_flag_desc,     a.type_cd,               
               e.type_desc,                 a.address1,         a.address2,                     a.address3,               
               a.booking_year,              a.booking_mth,      a.takeup_term,                  f.takeup_term_desc,       
               a.incept_date,               a.expiry_date,      a.issue_date,                   a.place_cd,               
               a.incept_tag,                a.expiry_tag,       a.risk_tag,                     g.rv_meaning risk,      
               a.ref_pol_no,                a.industry_cd,      h.industry_nm,                  a.region_cd,               
               i.region_desc,               a.cred_branch,      j.iss_name,                     a.quotation_printed_sw, 
               a.covernote_printed_sw,      a.pack_pol_flag,    a.auto_renew_flag,              a.foreign_acc_sw,       
               a.reg_policy_sw,             a.prem_warr_tag,    a.prem_warr_days,               a.fleet_print_tag,       
               a.with_tariff_sw,            a.co_insurance_sw,  a.prorate_flag,                 a.comp_sw,               
               a.short_rt_percent,          a.prov_prem_tag,    a.prov_prem_pct,                a.survey_agent_cd,
               a.acct_of_cd,                a.iss_cd,           a.invoice_sw,                   m.subline_name,
               a.line_cd,                   a.renew_no,         a.issue_yy,                     a.ref_open_pol_no,
               a.same_polno_sw,             a.endt_yy,          a.endt_seq_no,                  a.mortg_name,
               a.validate_tag,              a.back_stat,        a.eff_date,                     a.endt_expiry_date,
               a.pol_seq_no,                a.cancel_type,      a.endt_expiry_tag,              a.endt_iss_cd,
               a.acct_of_cd_sw,             a.old_assd_no,      a.old_address1,                 a.old_address2,
               a.old_address3,              a.ann_tsi_amt,      a.prem_amt,                     a.tsi_amt,
               a.ann_prem_amt,                a.plan_cd,            a.plan_sw,                        a.plan_ch_tag,
               a.company_cd,                a.employee_cd,      a.bank_ref_no,                  a.banc_type_cd,
               a.bancassurance_sw,          a.area_cd,          a.branch_cd,                    a.manager_cd,
               a.designation,               a.bond_seq_no,
               DECODE(k.payee_first_name, NULL, NULL, k.payee_first_name || ' ') ||
               DECODE(k.payee_middle_name, NULL, NULL, k.payee_middle_name || ' ') || 
               k.payee_last_name survey_agent_name, a.settling_agent_cd,
               DECODE(l.payee_first_name, NULL, NULL, l.payee_first_name || ' ') ||
               DECODE(l.payee_middle_name, NULL, NULL, l.payee_middle_name || ' ') ||
               l.payee_last_name settling_agent_name
          FROM GIPI_WPOLBAS     a
             --   ,GIIS_ASSURED   b
             -- ,GIIS_ASSURED     c
              ,CG_REF_CODES     d
              ,GIIS_POLICY_TYPE e
              ,GIIS_TAKEUP_TERM f
              ,CG_REF_CODES     g
              ,GIIS_INDUSTRY    h
              ,GIIS_REGION      i
              ,GIIS_ISSOURCE    j
              ,(SELECT * 
                  FROM GIIS_PAYEES 
                 WHERE payee_class_cd = v_survey_payee_class) k
              ,(SELECT * 
                  FROM GIIS_PAYEES 
                 WHERE payee_class_cd = v_settling_payee_class) l    
              ,GIIS_SUBLINE m
         WHERE a.par_id                 = p_par_id
         --  AND a.assd_no                = b.assd_no
         --  AND c.assd_no             (+)= a.acct_of_cd  
           AND d.rv_low_value        (+)= a.pol_flag 
           AND d.rv_domain           (+)= 'GIPI_POLBASIC.POL_FLAG'
           AND e.type_cd             (+)= a.type_cd 
           AND f.takeup_term         (+)= a.takeup_term  
           AND g.rv_low_value        (+)= a.risk_tag
           AND g.rv_domain           (+)= 'GIPI_POLBASIC.RISK_TAG'
           AND h.industry_cd         (+)= a.industry_cd
           AND i.region_cd           (+)= a.region_cd 
           AND j.iss_cd              (+)= a.iss_cd 
           AND k.payee_no            (+)= a.survey_agent_cd
           AND l.payee_no            (+)= a.settling_agent_cd
           AND m.line_cd                = a.line_cd
           AND m.subline_cd             = a.subline_cd)
      LOOP
        v_wpolbas.par_id                        := i.par_id;
        v_wpolbas.label_tag                     := i.label_tag;
        v_assd_no                               := i.assd_no;
        IF i.assd_no IS NULL THEN 
            SELECT assd_no INTO v_assd_no
              FROM gipi_parlist
             WHERE par_id = i.par_id;
        END IF;
        v_wpolbas.assd_no                        := v_assd_no;
        --v_wpolbas.assd_name                     := i.assd_name;
        FOR ga IN (
            SELECT assd_name FROM giis_assured WHERE assd_no = v_assd_no
        ) LOOP
            v_wpolbas.assd_name                    := ga.assd_name;
            EXIT;
        END LOOP;
        --v_wpolbas.in_account_of                 := i.in_account_of;
        FOR g IN (
            SELECT assd_name FROM giis_assured WHERE assd_no = i.acct_of_cd
        ) LOOP
            v_wpolbas.in_account_of                 := g.assd_name;
            EXIT;
        END LOOP;
        v_wpolbas.line_cd                       := i.line_cd;
        v_wpolbas.subline_cd                    := i.subline_cd;
        v_wpolbas.surcharge_sw                  := i.surcharge_sw;
        v_wpolbas.manual_renew_no               := i.manual_renew_no;
        v_wpolbas.discount_sw                   := i.discount_sw;
        v_wpolbas.pol_flag                      := i.pol_flag;
        v_wpolbas.pol_flag_desc                 := i.pol_flag_desc;
        v_wpolbas.type_cd                       := i.type_cd;
        v_wpolbas.type_desc                     := i.type_desc;
        v_wpolbas.address1                      := i.address1;
        v_wpolbas.address2                      := i.address2;
        v_wpolbas.address3                      := i.address3;
        v_wpolbas.booking_year                  := i.booking_year;
        v_wpolbas.booking_mth                   := i.booking_mth;
        v_wpolbas.takeup_term                   := i.takeup_term;
        v_wpolbas.takeup_term_desc              := i.takeup_term_desc;
        v_wpolbas.incept_date                   := i.incept_date;
        v_wpolbas.expiry_date                   := i.expiry_date;
        v_wpolbas.issue_date                    := NVL(i.issue_date,SYSDATE);
        v_wpolbas.place_cd                      := i.place_cd;     
        v_wpolbas.incept_tag                    := i.incept_tag;
        v_wpolbas.expiry_tag                    := i.expiry_tag;
        v_wpolbas.risk_tag                      := i.risk_tag;
        v_wpolbas.risk                          := i.risk;
        v_wpolbas.ref_pol_no                    := i.ref_pol_no;
        v_wpolbas.industry_cd                   := i.industry_cd;
        v_wpolbas.industry_nm                   := i.industry_nm;     
        v_wpolbas.region_cd                     := i.region_cd;
        v_wpolbas.region_desc                   := i.region_cd;
        v_wpolbas.cred_branch                   := i.cred_branch;
        v_wpolbas.iss_name                      := i.iss_name;
        v_wpolbas.iss_cd                        := i.iss_cd;
        v_wpolbas.quotation_printed_sw          := i.quotation_printed_sw;
        v_wpolbas.covernote_printed_sw          := i.covernote_printed_sw;
        v_wpolbas.pack_pol_flag                 := i.pack_pol_flag;
        v_wpolbas.auto_renew_flag               := i.auto_renew_flag;
        v_wpolbas.foreign_acc_sw                := i.foreign_acc_sw;
        v_wpolbas.reg_policy_sw                 := i.reg_policy_sw;                                  
        v_wpolbas.prem_warr_tag                 := i.prem_warr_tag;
        v_wpolbas.prem_warr_days                := i.prem_warr_days;
        v_wpolbas.fleet_print_tag               := i.fleet_print_tag;
        v_wpolbas.with_tariff_sw                := i.with_tariff_sw;
        v_wpolbas.co_insurance_sw               := i.co_insurance_sw;
        v_wpolbas.prorate_flag                  := i.prorate_flag;
        v_wpolbas.comp_sw                       := i.comp_sw;
        v_wpolbas.short_rt_percent              := i.short_rt_percent;     
        v_wpolbas.prov_prem_tag                 := i.prov_prem_tag;                                        
        v_wpolbas.prov_prem_pct                 := i.prov_prem_pct;
        v_wpolbas.survey_agent_cd               := i.survey_agent_cd;
        v_wpolbas.survey_agent_name             := i.survey_agent_name;                                                    
        v_wpolbas.settling_agent_cd             := i.settling_agent_cd;
        v_wpolbas.settling_agent_name           := i.settling_agent_name;    
        v_wpolbas.acct_of_cd                    := i.acct_of_cd;
        v_wpolbas.invoice_sw                    := i.invoice_sw;
        v_wpolbas.renew_no                      := i.renew_no;
        v_wpolbas.issue_yy                      := i.issue_yy;
        v_wpolbas.ref_open_pol_no               := i.ref_open_pol_no;
        v_wpolbas.same_polno_sw                 := i.same_polno_sw;
        v_wpolbas.endt_yy                       := i.endt_yy;
        v_wpolbas.endt_seq_no                   := i.endt_seq_no;
        v_wpolbas.mortg_name                    := i.mortg_name;
        v_wpolbas.validate_tag                  := i.validate_tag;
        v_wpolbas.pol_seq_no                    := i.pol_seq_no;
        v_wpolbas.back_stat                     := i.back_stat;
        v_wpolbas.eff_date                      := i.eff_date;
        v_wpolbas.endt_expiry_date              := i.endt_expiry_date;
        v_wpolbas.cancel_type                   := i.cancel_type;
        v_wpolbas.endt_expiry_tag               := i.endt_expiry_tag;
        v_wpolbas.endt_iss_cd                   := i.endt_iss_cd;
        v_wpolbas.acct_of_cd_sw                 := i.acct_of_cd_sw;
        v_wpolbas.old_assd_no                   := i.old_assd_no;
        v_wpolbas.old_address1                  := i.old_address1;
        v_wpolbas.old_address2                  := i.old_address2;
        v_wpolbas.old_address3                  := i.old_address3;
        v_wpolbas.ann_tsi_amt                   := i.ann_tsi_amt;
        v_wpolbas.prem_amt                      := i.prem_amt;
        v_wpolbas.tsi_amt                       := i.tsi_amt;
        v_wpolbas.ann_prem_amt                  := i.ann_prem_amt;
        v_wpolbas.plan_cd                        := i.plan_cd;
        v_wpolbas.plan_sw                        := i.plan_sw;
        v_wpolbas.plan_ch_tag                    := i.plan_ch_tag;
        v_wpolbas.company_cd                    := i.company_cd;
        v_wpolbas.employee_cd                   := i.employee_cd;
        v_wpolbas.bank_ref_no                   := i.bank_ref_no;
        v_wpolbas.banc_type_cd                  := i.banc_type_cd;
        v_wpolbas.bancassurance_sw              := i.bancassurance_sw;
        v_wpolbas.area_cd                       := i.area_cd;
        v_wpolbas.branch_cd                     := i.branch_cd;
        v_wpolbas.manager_cd                    := i.manager_cd;
        v_wpolbas.designation                   := i.designation;
        v_wpolbas.bond_seq_no                   := i.bond_seq_no;
      END LOOP;
      PIPE ROW(v_wpolbas);
    RETURN;
  END get_gipi_wpolbas;
  
  --for GIPIS038 BRY 02.03.2010
  FUNCTION get_gipi_wpolbas1 (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN gipi_wpolbas_tab PIPELINED IS
      v_wpolbas                             gipi_wpolbas_type;
    BEGIN
      FOR i IN (
            SELECT a.subline_cd,           a.par_id,             a.line_cd,                a.iss_cd,
                 a.foreign_acc_sw,  a.invoice_sw,      a.quotation_printed_sw, a.covernote_printed_sw, 
                 a.auto_renew_flag, a.prov_prem_tag,   a.same_polno_sw,        a.reg_policy_sw, 
                 a.co_insurance_sw, a.manual_renew_no, a.prorate_flag,            a.endt_expiry_date,
                 a.eff_date,         a.short_rt_percent,a.prov_prem_pct,          
                 a.expiry_date,     a.with_tariff_sw,  NVL(a.comp_sw, 'N') comp_sw                          
          FROM   GIPI_WPOLBAS a
         WHERE   par_id  =  p_par_id)
      LOOP
          v_wpolbas.subline_cd                 := i.subline_cd;
          v_wpolbas.par_id                     := i.par_id;
          v_wpolbas.line_cd                     := i.line_cd;
          v_wpolbas.iss_cd                     := i.iss_cd;
          v_wpolbas.foreign_acc_sw            := i.foreign_acc_sw;
          v_wpolbas.invoice_sw                 := i.invoice_sw;        
          v_wpolbas.quotation_printed_sw    := i.quotation_printed_sw;
          v_wpolbas.covernote_printed_sw    := i.covernote_printed_sw;
          v_wpolbas.auto_renew_flag             := i.auto_renew_flag;
          v_wpolbas.prov_prem_tag             := i.prov_prem_tag;
          v_wpolbas.same_polno_sw             := i.same_polno_sw;
          v_wpolbas.reg_policy_sw             := i.reg_policy_sw;
          v_wpolbas.co_insurance_sw             := i.co_insurance_sw;    
          v_wpolbas.manual_renew_no             := i.manual_renew_no;    
          v_wpolbas.prorate_flag             := i.prorate_flag;    
          v_wpolbas.endt_expiry_date        := i.endt_expiry_date;
          v_wpolbas.eff_date                 := i.eff_date;
          v_wpolbas.short_rt_percent        := i.short_rt_percent;
          v_wpolbas.prov_prem_pct             := i.prov_prem_pct;
          v_wpolbas.expiry_date                 := i.expiry_date;
          v_wpolbas.with_tariff_sw             := i.with_tariff_sw;
          v_wpolbas.comp_sw                    := i.comp_sw;
          PIPE ROW(v_wpolbas);
      END LOOP;
    RETURN;
  END get_gipi_wpolbas1;

  Procedure get_gipi_wpolbas_exist (
             p_par_id          IN        GIPI_WPOLBAS.par_id%TYPE,
             p_exist            OUT        NUMBER)
    IS
    v_exist                    NUMBER := 0;
  BEGIN
    FOR a IN (SELECT 1 
                FROM GIPI_WPOLBAS
               WHERE par_id = p_par_id)
    LOOP
      v_exist := 1;
    END LOOP;
    p_exist := v_exist;
  END;

  Procedure set_gipi_wpolbas ( 
     v_par_id                   IN  GIPI_WPOLBAS.par_id%TYPE,           
     v_label_tag                IN  GIPI_WPOLBAS.label_tag%TYPE,
     v_assd_no                  IN  GIPI_WPOLBAS.assd_no%TYPE,
     v_subline_cd               IN  GIPI_WPOLBAS.subline_cd%TYPE,
     v_surcharge_sw             IN  GIPI_WPOLBAS.surcharge_sw%TYPE,
     v_manual_renew_no          IN  GIPI_WPOLBAS.manual_renew_no%TYPE,
     v_discount_sw              IN  GIPI_WPOLBAS.discount_sw%TYPE,
     v_pol_flag                 IN  GIPI_WPOLBAS.pol_flag%TYPE,
     v_type_cd                  IN  GIPI_WPOLBAS.type_cd%TYPE,
     v_address1                 IN  GIPI_WPOLBAS.address1%TYPE,
     v_address2                 IN  GIPI_WPOLBAS.address2%TYPE,
     v_address3                 IN  GIPI_WPOLBAS.address3%TYPE,
     v_booking_year             IN  GIPI_WPOLBAS.booking_year%TYPE,
     v_booking_mth              IN  GIPI_WPOLBAS.booking_mth%TYPE,
     v_takeup_term              IN  GIPI_WPOLBAS.takeup_term%TYPE,
     v_incept_date              IN  GIPI_WPOLBAS.incept_date%TYPE,
     v_expiry_date              IN  GIPI_WPOLBAS.expiry_date%TYPE,
     v_issue_date               IN  GIPI_WPOLBAS.issue_date%TYPE,
     v_place_cd                 IN  GIPI_WPOLBAS.place_cd%TYPE,     
     v_incept_tag               IN  GIPI_WPOLBAS.incept_tag%TYPE,
     v_expiry_tag               IN  GIPI_WPOLBAS.expiry_tag%TYPE,
     v_risk_tag                 IN  GIPI_WPOLBAS.risk_tag%TYPE,
     v_ref_pol_no               IN  GIPI_WPOLBAS.ref_pol_no%TYPE,
     v_industry_cd              IN  GIPI_WPOLBAS.industry_cd%TYPE,
     v_region_cd                IN  GIPI_WPOLBAS.region_cd%TYPE,
     v_cred_branch              IN  GIPI_WPOLBAS.cred_branch%TYPE,
     v_quotation_printed_sw     IN  GIPI_WPOLBAS.quotation_printed_sw%TYPE,
     v_covernote_printed_sw     IN  GIPI_WPOLBAS.covernote_printed_sw%TYPE,
     v_pack_pol_flag            IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,
     v_auto_renew_flag          IN  GIPI_WPOLBAS.auto_renew_flag%TYPE,
     v_foreign_acc_sw           IN  GIPI_WPOLBAS.foreign_acc_sw%TYPE,
     v_reg_policy_sw            IN  GIPI_WPOLBAS.reg_policy_sw%TYPE,                                  
     v_prem_warr_tag            IN  GIPI_WPOLBAS.prem_warr_tag%TYPE,
     v_prem_warr_days           IN  GIPI_WPOLBAS.prem_warr_days%TYPE,
     v_fleet_print_tag          IN  GIPI_WPOLBAS.fleet_print_tag%TYPE,
     v_with_tariff_sw           IN  GIPI_WPOLBAS.with_tariff_sw%TYPE,
     v_co_insurance_sw          IN  GIPI_WPOLBAS.co_insurance_sw%TYPE,
     v_prorate_flag             IN  GIPI_WPOLBAS.prorate_flag%TYPE,
     v_comp_sw                  IN  GIPI_WPOLBAS.comp_sw%TYPE,
     v_short_rt_percent         IN  GIPI_WPOLBAS.short_rt_percent%TYPE,     
     v_prov_prem_tag            IN  GIPI_WPOLBAS.prov_prem_tag%TYPE,                                        
     v_prov_prem_pct            IN  GIPI_WPOLBAS.prov_prem_pct%TYPE,
     v_survey_agent_cd          IN  GIPI_WPOLBAS.survey_agent_cd%TYPE,                                         
     v_settling_agent_cd        IN  GIPI_WPOLBAS.settling_agent_cd%TYPE,
     v_user_id                  IN  GIPI_WPOLBAS.user_id%TYPE,
     v_line_cd                  IN  GIPI_WPOLBAS.line_cd%TYPE,
     v_designation              IN  GIPI_WPOLBAS.designation%TYPE,
     v_acct_of_cd               IN  GIPI_WPOLBAS.acct_of_cd%TYPE,
     v_iss_cd                   IN  GIPI_WPOLBAS.iss_cd%TYPE,
     v_invoice_sw               IN  GIPI_WPOLBAS.invoice_sw%TYPE,
     v_renew_no                 IN  GIPI_WPOLBAS.renew_no%TYPE,
     v_issue_yy                 IN  GIPI_WPOLBAS.issue_yy%TYPE,
     v_ref_open_pol_no          IN  GIPI_WPOLBAS.ref_open_pol_no%TYPE,
     v_same_polno_sw            IN  GIPI_WPOLBAS.same_polno_sw%TYPE,
     v_endt_yy                  IN  GIPI_WPOLBAS.endt_yy%TYPE,
     v_endt_seq_no              IN  GIPI_WPOLBAS.endt_seq_no%TYPE,
     v_update_issue_date        IN  VARCHAR2,
     v_mortg_name               IN  GIPI_WPOLBAS.mortg_name%TYPE,
     v_validate_tag             IN  GIPI_WPOLBAS.validate_tag%TYPE,
     v_endt_expiry_date         IN  GIPI_WPOLBAS.endt_expiry_date%TYPE,
     v_company_cd               IN  GIPI_WPOLBAS.company_cd%TYPE,
     v_employee_cd              IN  GIPI_WPOLBAS.employee_cd%TYPE,
     v_bank_ref_no              IN  GIPI_WPOLBAS.bank_ref_no%TYPE,
     v_banc_type_cd             IN  GIPI_WPOLBAS.banc_type_cd%TYPE,
     v_bancassurance_sw         IN  GIPI_WPOLBAS.bancassurance_sw%TYPE,
     v_area_cd                  IN  GIPI_WPOLBAS.area_cd%TYPE,
     v_branch_cd                IN  GIPI_WPOLBAS.branch_cd%TYPE,
     v_manager_cd               IN  GIPI_WPOLBAS.manager_cd%TYPE,
     v_plan_cd                  IN  GIPI_WPOLBAS.plan_cd%TYPE,
     v_plan_sw                  IN  GIPI_WPOLBAS.plan_sw%TYPE
     ) IS
     
     v_eff_date                    GIPI_WPOLBAS.eff_date%TYPE;
     v_add_time                    NUMBER;
     NEW_DATE                      DATE;
     v_incept_date2                DATE;
     v_expiry_date2                DATE;
     v_end_of_day                  VARCHAR2(1);
     v_issue_date2                 DATE := SYSDATE;
  BEGIN

       Get_Addtl_Time_Gipis002(v_line_cd, v_subline_cd, v_add_time);
       B540_Sublcd_Wvi_B_Gipis002(v_line_cd, v_subline_cd, v_end_of_day);
       IF NVL(v_end_of_day,'N') = 'Y' THEN
         v_incept_date2 := TRUNC(v_incept_date) + 86399/86400;
         v_expiry_date2 := TRUNC(v_expiry_date) + 86399/86400;
       ELSE
         NEW_DATE       := v_incept_date + NVL((v_add_time /86400),0);
         v_incept_date2 := NEW_DATE;
         v_expiry_date2 := v_expiry_date + NVL((v_add_time /86400),0);
       END IF;
       v_eff_date     := v_incept_date2;
       
       IF v_update_issue_date = 'Y' THEN
         /*IF v_incept_date < TO_DATE('01-01-1997','MM-DD-YYYY') THEN
           v_issue_date2 := NEW_DATE;
         END IF;*/
         --replace code above niknok 11.04.11 di na daw applicable itong condition
         v_issue_date2 := SYSDATE;
       ELSE
          FOR a IN (SELECT issue_date
                      FROM GIPI_WPOLBAS
                     WHERE par_id = v_par_id)
          LOOP    
            v_issue_date2 := a.issue_date;
          END LOOP;
          
          IF giisp.v('UPDATE_ISSUE_DATE') = 'Y' THEN
            v_issue_date2 := v_issue_date;
          END IF;     
       END IF;
  
   
      MERGE INTO GIPI_WPOLBAS
       USING DUAL ON ( par_id = v_par_id )
       WHEN NOT MATCHED THEN
         INSERT (par_id,            label_tag,              assd_no,                subline_cd,
                 surcharge_sw,      manual_renew_no,        discount_sw,            pol_flag,
                 type_cd,           address1,               address2,               address3,
                 booking_year,      booking_mth,            takeup_term,            incept_date,
                 expiry_date,       issue_date,             place_cd,               incept_tag,
                 expiry_tag,        risk_tag,               ref_pol_no,             industry_cd,
                 region_cd,         cred_branch,            quotation_printed_sw,   covernote_printed_sw,
                 pack_pol_flag,     auto_renew_flag,        foreign_acc_sw,         reg_policy_sw,                              
                 prem_warr_tag,     prem_warr_days,         fleet_print_tag,        with_tariff_sw,
                 co_insurance_sw,   prorate_flag,           comp_sw,                short_rt_percent,
                 prov_prem_tag,     prov_prem_pct,          survey_agent_cd,        settling_agent_cd,
                 user_id,           line_cd,                designation,            acct_of_cd,
                 issue_yy,          eff_date,               iss_cd,                 invoice_sw,
                 renew_no,          ref_open_pol_no,        same_polno_sw,          endt_yy,
                 endt_seq_no,       mortg_name,             validate_tag,           endt_expiry_date,
                 company_cd,        employee_cd,            bank_ref_no,            banc_type_cd,
                 bancassurance_sw,  area_cd,                branch_cd,              manager_cd,
                 plan_cd,           plan_sw
                 )
         VALUES (v_par_id,          v_label_tag,            v_assd_no,              v_subline_cd,
                 v_surcharge_sw,    v_manual_renew_no,      v_discount_sw,          v_pol_flag,
                 v_type_cd,         v_address1,             v_address2,             v_address3,
                 v_booking_year,    v_booking_mth,          v_takeup_term,          v_incept_date2,
                 v_expiry_date2,    v_issue_date2,          v_place_cd,             v_incept_tag,
                 v_expiry_tag,      v_risk_tag,             v_ref_pol_no,           v_industry_cd,
                 v_region_cd,       v_cred_branch,          v_quotation_printed_sw, v_covernote_printed_sw,
                 v_pack_pol_flag,   v_auto_renew_flag,      v_foreign_acc_sw,       v_reg_policy_sw,                              
                 v_prem_warr_tag,   v_prem_warr_days,       v_fleet_print_tag,      v_with_tariff_sw,
                 v_co_insurance_sw, v_prorate_flag,         v_comp_sw,              v_short_rt_percent,
                 v_prov_prem_tag,   v_prov_prem_pct,        v_survey_agent_cd,      v_settling_agent_cd,
                 v_user_id,         v_line_cd,              v_designation,          v_acct_of_cd,
                 v_issue_yy,        v_eff_date,             v_iss_cd,               v_invoice_sw,
                 v_renew_no,        v_ref_open_pol_no,      v_same_polno_sw,        v_endt_yy,
                 v_endt_seq_no,     v_mortg_name,           v_validate_tag,         v_endt_expiry_date,
                 v_company_cd,      v_employee_cd,          v_bank_ref_no,          v_banc_type_cd,
                 v_bancassurance_sw,v_area_cd,              v_branch_cd,            v_manager_cd,
                 v_plan_cd,         v_plan_sw
                 )
       WHEN MATCHED THEN
         UPDATE SET 
                    label_tag               = v_label_tag,                
                    assd_no                 = v_assd_no,               
                    subline_cd              = v_subline_cd,
                    surcharge_sw            = v_surcharge_sw,     
                    manual_renew_no         = v_manual_renew_no,      
                    discount_sw             = v_discount_sw,            
                    pol_flag                = v_pol_flag,
                    type_cd                 = v_type_cd,            
                    address1                = v_address1,              
                    address2                = v_address2,                
                    address3                = v_address3,
                    booking_year            = v_booking_year,        
                    booking_mth             = v_booking_mth,          
                    takeup_term             = v_takeup_term,            
                    incept_date             = v_incept_date2,
                    expiry_date             = v_expiry_date2,        
                    issue_date              = v_issue_date2,                
                    place_cd                = v_place_cd,                
                    incept_tag              = v_incept_tag,
                    expiry_tag              = v_expiry_tag,        
                    risk_tag                = v_risk_tag,             
                    ref_pol_no              = v_ref_pol_no,            
                    industry_cd             = v_industry_cd,
                    region_cd               = v_region_cd,        
                    cred_branch             = v_cred_branch,          
                    quotation_printed_sw    = v_quotation_printed_sw,    
                    covernote_printed_sw    = v_covernote_printed_sw,
                    pack_pol_flag           = v_pack_pol_flag,    
                    auto_renew_flag         = v_auto_renew_flag,      
                    foreign_acc_sw          = v_foreign_acc_sw,        
                    reg_policy_sw           = v_reg_policy_sw,                              
                    prem_warr_tag           = v_prem_warr_tag,    
                    prem_warr_days          = v_prem_warr_days,            
                    fleet_print_tag         = v_fleet_print_tag,        
                    with_tariff_sw          = v_with_tariff_sw,
                    co_insurance_sw         = v_co_insurance_sw,    
                    prorate_flag            = v_prorate_flag,          
                    comp_sw                 = v_comp_sw,                
                    short_rt_percent        = v_short_rt_percent,
                    prov_prem_tag           = v_prov_prem_tag,      
                    prov_prem_pct           = v_prov_prem_pct,            
                    survey_agent_cd         = v_survey_agent_cd,        
                    settling_agent_cd       = v_settling_agent_cd,
                    user_id                 = v_user_id,            
                    line_cd                 = v_line_cd,              
                    designation             = v_designation,            
                    acct_of_cd              = v_acct_of_cd,
                    issue_yy                = v_issue_yy,
                    eff_date                = v_eff_date,
                    iss_cd                  = v_iss_cd,
                    invoice_sw              = v_invoice_sw,
                    renew_no                = v_renew_no,
                    ref_open_pol_no         = v_ref_open_pol_no,
                    same_polno_sw           = v_same_polno_sw,
                    endt_yy                 = v_endt_yy,
                    endt_seq_no             = v_endt_seq_no,
                    mortg_name              = v_mortg_name,
                    validate_tag            = v_validate_tag,
                    endt_expiry_date        = v_endt_expiry_date,
                    company_cd              = v_company_cd,
                    employee_cd             = v_employee_cd,
                    bank_ref_no             = v_bank_ref_no,
                    banc_type_cd            = v_banc_type_cd,
                    bancassurance_sw        = v_bancassurance_sw,  
                    area_cd                 = v_area_cd,                
                    branch_cd               = v_branch_cd,              
                    manager_cd              = v_manager_cd,
                    plan_cd                 = v_plan_cd,
                    plan_sw                 = v_plan_sw;
  END set_gipi_wpolbas;   
  
  Procedure set_gipi_wpolbas2( 
     v_par_id                   IN  GIPI_WPOLBAS.par_id%TYPE,           
     v_label_tag                IN  GIPI_WPOLBAS.label_tag%TYPE,
     v_assd_no                  IN  GIPI_WPOLBAS.assd_no%TYPE,
     v_subline_cd               IN  GIPI_WPOLBAS.subline_cd%TYPE,
     v_surcharge_sw             IN  GIPI_WPOLBAS.surcharge_sw%TYPE,
     v_manual_renew_no          IN  GIPI_WPOLBAS.manual_renew_no%TYPE,
     v_discount_sw              IN  GIPI_WPOLBAS.discount_sw%TYPE,
     v_pol_flag                 IN  GIPI_WPOLBAS.pol_flag%TYPE,
     v_type_cd                  IN  GIPI_WPOLBAS.type_cd%TYPE,
     v_address1                 IN  GIPI_WPOLBAS.address1%TYPE,
     v_address2                 IN  GIPI_WPOLBAS.address2%TYPE,
     v_address3                 IN  GIPI_WPOLBAS.address3%TYPE,
     v_booking_year             IN  GIPI_WPOLBAS.booking_year%TYPE,
     v_booking_mth              IN  GIPI_WPOLBAS.booking_mth%TYPE,
     v_takeup_term              IN  GIPI_WPOLBAS.takeup_term%TYPE,
     v_incept_date              IN  GIPI_WPOLBAS.incept_date%TYPE,
     v_expiry_date              IN  GIPI_WPOLBAS.expiry_date%TYPE,
     v_issue_date               IN  GIPI_WPOLBAS.issue_date%TYPE,
     v_place_cd                 IN  GIPI_WPOLBAS.place_cd%TYPE,     
     v_incept_tag               IN  GIPI_WPOLBAS.incept_tag%TYPE,
     v_expiry_tag               IN  GIPI_WPOLBAS.expiry_tag%TYPE,
     v_risk_tag                 IN  GIPI_WPOLBAS.risk_tag%TYPE,
     v_ref_pol_no               IN  GIPI_WPOLBAS.ref_pol_no%TYPE,
     v_industry_cd              IN  GIPI_WPOLBAS.industry_cd%TYPE,
     v_region_cd                IN  GIPI_WPOLBAS.region_cd%TYPE,
     v_cred_branch              IN  GIPI_WPOLBAS.cred_branch%TYPE,
     v_quotation_printed_sw     IN  GIPI_WPOLBAS.quotation_printed_sw%TYPE,
     v_covernote_printed_sw     IN  GIPI_WPOLBAS.covernote_printed_sw%TYPE,
     v_pack_pol_flag            IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,
     v_auto_renew_flag          IN  GIPI_WPOLBAS.auto_renew_flag%TYPE,
     v_foreign_acc_sw           IN  GIPI_WPOLBAS.foreign_acc_sw%TYPE,
     v_reg_policy_sw            IN  GIPI_WPOLBAS.reg_policy_sw%TYPE,                                  
     v_prem_warr_tag            IN  GIPI_WPOLBAS.prem_warr_tag%TYPE,
     v_prem_warr_days           IN  GIPI_WPOLBAS.prem_warr_days%TYPE,
     v_fleet_print_tag          IN  GIPI_WPOLBAS.fleet_print_tag%TYPE,
     v_with_tariff_sw           IN  GIPI_WPOLBAS.with_tariff_sw%TYPE,
     v_co_insurance_sw          IN  GIPI_WPOLBAS.co_insurance_sw%TYPE,
     v_prorate_flag             IN  GIPI_WPOLBAS.prorate_flag%TYPE,
     v_comp_sw                  IN  GIPI_WPOLBAS.comp_sw%TYPE,
     v_short_rt_percent         IN  GIPI_WPOLBAS.short_rt_percent%TYPE,     
     v_prov_prem_tag            IN  GIPI_WPOLBAS.prov_prem_tag%TYPE,                                        
     v_prov_prem_pct            IN  GIPI_WPOLBAS.prov_prem_pct%TYPE,
     v_survey_agent_cd          IN  GIPI_WPOLBAS.survey_agent_cd%TYPE,                                         
     v_settling_agent_cd        IN  GIPI_WPOLBAS.settling_agent_cd%TYPE,
     v_user_id                  IN  GIPI_WPOLBAS.user_id%TYPE,
     v_line_cd                  IN  GIPI_WPOLBAS.line_cd%TYPE,
     v_designation              IN  GIPI_WPOLBAS.designation%TYPE,
     v_acct_of_cd               IN  GIPI_WPOLBAS.acct_of_cd%TYPE,
     v_iss_cd                   IN  GIPI_WPOLBAS.iss_cd%TYPE,
     v_invoice_sw               IN  GIPI_WPOLBAS.invoice_sw%TYPE,
     v_renew_no                 IN  GIPI_WPOLBAS.renew_no%TYPE,
     v_issue_yy                 IN  GIPI_WPOLBAS.issue_yy%TYPE,
     v_ref_open_pol_no          IN  GIPI_WPOLBAS.ref_open_pol_no%TYPE,
     v_same_polno_sw            IN  GIPI_WPOLBAS.same_polno_sw%TYPE,
     v_endt_yy                  IN  GIPI_WPOLBAS.endt_yy%TYPE,
     v_endt_seq_no              IN  GIPI_WPOLBAS.endt_seq_no%TYPE,
     v_update_issue_date        IN  VARCHAR2,
     v_mortg_name               IN  GIPI_WPOLBAS.mortg_name%TYPE,
     v_validate_tag             IN  GIPI_WPOLBAS.validate_tag%TYPE,
     v_endt_expiry_date         IN  GIPI_WPOLBAS.endt_expiry_date%TYPE,
     v_company_cd               IN  GIPI_WPOLBAS.company_cd%TYPE,
     v_employee_cd              IN  GIPI_WPOLBAS.employee_cd%TYPE,
     v_bank_ref_no              IN  GIPI_WPOLBAS.bank_ref_no%TYPE,
     v_banc_type_cd             IN  GIPI_WPOLBAS.banc_type_cd%TYPE,
     v_bancassurance_sw         IN  GIPI_WPOLBAS.bancassurance_sw%TYPE,
     v_area_cd                  IN  GIPI_WPOLBAS.area_cd%TYPE,
     v_branch_cd                IN  GIPI_WPOLBAS.branch_cd%TYPE,
     v_manager_cd               IN  GIPI_WPOLBAS.manager_cd%TYPE,
     v_plan_cd                  IN  GIPI_WPOLBAS.plan_cd%TYPE,
     v_plan_sw                  IN  GIPI_WPOLBAS.plan_sw%TYPE,
     v_bond_seq_no                IN  GIPI_WPOLBAS.bond_seq_no%TYPE,
	 v_bond_auto_prem			IN  GIPI_WPOLBAS.bond_auto_prem%TYPE --robert GENQA SR 4828 08.25.15
     ) IS
  BEGIN
        
      MERGE INTO GIPI_WPOLBAS
       USING DUAL ON ( par_id = v_par_id )
       WHEN NOT MATCHED THEN
         INSERT (par_id,            label_tag,              assd_no,                subline_cd,
                 surcharge_sw,      manual_renew_no,        discount_sw,            pol_flag,
                 type_cd,           address1,               address2,               address3,
                 booking_year,      booking_mth,            takeup_term,            incept_date,
                 expiry_date,       issue_date,             place_cd,               incept_tag,
                 expiry_tag,        risk_tag,               ref_pol_no,             industry_cd,
                 region_cd,         cred_branch,            quotation_printed_sw,   covernote_printed_sw,
                 pack_pol_flag,     auto_renew_flag,        foreign_acc_sw,         reg_policy_sw,                              
                 prem_warr_tag,     prem_warr_days,         fleet_print_tag,        with_tariff_sw,
                 co_insurance_sw,   prorate_flag,           comp_sw,                short_rt_percent,
                 prov_prem_tag,     prov_prem_pct,          survey_agent_cd,        settling_agent_cd,
                 user_id,           line_cd,                designation,            acct_of_cd,
                 issue_yy,          eff_date,               iss_cd,                 invoice_sw,
                 renew_no,          ref_open_pol_no,        same_polno_sw,          endt_yy,
                 endt_seq_no,       mortg_name,             validate_tag,           endt_expiry_date,
                 company_cd,        employee_cd,            bank_ref_no,            banc_type_cd,
                 bancassurance_sw,  area_cd,                branch_cd,              manager_cd,
                 plan_cd,           plan_sw,                bond_seq_no,			bond_auto_prem --robert GENQA SR 4828 08.25.15
                 )
         VALUES (v_par_id,          v_label_tag,            v_assd_no,              v_subline_cd,
                 v_surcharge_sw,    v_manual_renew_no,      v_discount_sw,          v_pol_flag,
                 v_type_cd,         v_address1,             v_address2,             v_address3,
                 v_booking_year,    v_booking_mth,          v_takeup_term,          v_incept_date,
                 v_expiry_date,     v_issue_date,           v_place_cd,             v_incept_tag,
                 v_expiry_tag,      v_risk_tag,             v_ref_pol_no,           v_industry_cd,
                 v_region_cd,       v_cred_branch,          v_quotation_printed_sw, v_covernote_printed_sw,
                 v_pack_pol_flag,   v_auto_renew_flag,      v_foreign_acc_sw,       v_reg_policy_sw,                              
                 v_prem_warr_tag,   v_prem_warr_days,       v_fleet_print_tag,      v_with_tariff_sw,
                 v_co_insurance_sw, v_prorate_flag,         v_comp_sw,              v_short_rt_percent,
                 v_prov_prem_tag,   v_prov_prem_pct,        v_survey_agent_cd,      v_settling_agent_cd,
                 v_user_id,         v_line_cd,              v_designation,          v_acct_of_cd,
                 v_issue_yy,        v_incept_date,          v_iss_cd,               v_invoice_sw,
                 v_renew_no,        v_ref_open_pol_no,      v_same_polno_sw,        v_endt_yy,
                 v_endt_seq_no,     v_mortg_name,           v_validate_tag,         v_endt_expiry_date,
                 v_company_cd,      v_employee_cd,          v_bank_ref_no,          v_banc_type_cd,
                 v_bancassurance_sw,v_area_cd,              v_branch_cd,            v_manager_cd,
                 v_plan_cd,         v_plan_sw,                v_bond_seq_no,		v_bond_auto_prem --robert GENQA SR 4828 08.25.15
                 )
       WHEN MATCHED THEN
         UPDATE SET 
                    label_tag               = v_label_tag,                
                    assd_no                 = v_assd_no,               
                    subline_cd              = v_subline_cd,
                    surcharge_sw            = v_surcharge_sw,     
                    manual_renew_no         = v_manual_renew_no,      
                    discount_sw             = v_discount_sw,            
                    pol_flag                = v_pol_flag,
                    type_cd                 = v_type_cd,            
                    address1                = v_address1,              
                    address2                = v_address2,                
                    address3                = v_address3,
                    booking_year            = v_booking_year,        
                    booking_mth             = v_booking_mth,          
                    takeup_term             = v_takeup_term,            
                    incept_date             = v_incept_date,
                    expiry_date             = v_expiry_date,        
                    issue_date              = v_issue_date,                
                    place_cd                = v_place_cd,                
                    incept_tag              = v_incept_tag,
                    expiry_tag              = v_expiry_tag,        
                    risk_tag                = v_risk_tag,             
                    ref_pol_no              = v_ref_pol_no,            
                    industry_cd             = v_industry_cd,
                    region_cd               = v_region_cd,        
                    cred_branch             = v_cred_branch,          
                    quotation_printed_sw    = v_quotation_printed_sw,    
                    covernote_printed_sw    = v_covernote_printed_sw,
                    pack_pol_flag           = v_pack_pol_flag,    
                    auto_renew_flag         = v_auto_renew_flag,      
                    foreign_acc_sw          = v_foreign_acc_sw,        
                    reg_policy_sw           = v_reg_policy_sw,                              
                    prem_warr_tag           = v_prem_warr_tag,    
                    prem_warr_days          = v_prem_warr_days,            
                    fleet_print_tag         = v_fleet_print_tag,        
                    with_tariff_sw          = v_with_tariff_sw,
                    co_insurance_sw         = v_co_insurance_sw,    
                    prorate_flag            = v_prorate_flag,          
                    comp_sw                 = v_comp_sw,                
                    short_rt_percent        = v_short_rt_percent,
                    prov_prem_tag           = v_prov_prem_tag,      
                    prov_prem_pct           = v_prov_prem_pct,            
                    survey_agent_cd         = v_survey_agent_cd,        
                    settling_agent_cd       = v_settling_agent_cd,
                    user_id                 = v_user_id,            
                    line_cd                 = v_line_cd,              
                    designation             = v_designation,            
                    acct_of_cd              = v_acct_of_cd,
                    issue_yy                = v_issue_yy,
                    eff_date                = v_incept_date,
                    iss_cd                  = v_iss_cd,
                    invoice_sw              = v_invoice_sw,
                    renew_no                = v_renew_no,
                    ref_open_pol_no         = v_ref_open_pol_no,
                    same_polno_sw           = v_same_polno_sw,
                    endt_yy                 = v_endt_yy,
                    endt_seq_no             = v_endt_seq_no,
                    mortg_name              = v_mortg_name,
                    validate_tag            = v_validate_tag,
                    endt_expiry_date        = v_endt_expiry_date,
                    company_cd              = v_company_cd,
                    employee_cd             = v_employee_cd,
                    bank_ref_no             = v_bank_ref_no,
                    banc_type_cd            = v_banc_type_cd,
                    bancassurance_sw        = v_bancassurance_sw,  
                    area_cd                 = v_area_cd,                
                    branch_cd               = v_branch_cd,              
                    manager_cd              = v_manager_cd,
                    plan_cd                 = v_plan_cd,
                    plan_sw                 = v_plan_sw,
					bond_auto_prem          = v_bond_auto_prem, --robert GENQA SR 4828 08.25.15
                    bond_seq_no                = v_bond_seq_no;
  END;  
  
  FUNCTION get_gipi_wpolbas_common (p_par_id    GIPI_WPOLBAS.PAR_ID%TYPE)
    RETURN gipi_wpolbas_common_tab PIPELINED IS
    
    v_giis_wpolbas_common           gipi_wpolbas_common_type;
    
  BEGIN
  
    FOR i IN (SELECT a.par_id,     a.subline_cd,   a.line_cd,      c.line_name,   a.iss_cd,
                        a.assd_no,    b.assd_name,    a.pack_par_id,  a.pol_flag,    a.issue_yy,
                     a.pol_seq_no, a.renew_no
                FROM GIPI_WPOLBAS a,
                     GIIS_ASSURED b,
                     GIIS_LINE c
               WHERE a.assd_no = b.assd_no
                 AND a.line_cd = c.line_cd
                 AND a.par_id  = p_par_id)
    
    LOOP
    
      v_giis_wpolbas_common.par_id          := i.par_id;
      v_giis_wpolbas_common.subline_cd      := i.subline_cd;
      v_giis_wpolbas_common.line_cd          := i.line_cd;
      v_giis_wpolbas_common.line_name      := i.line_name;
      v_giis_wpolbas_common.iss_cd          := i.iss_cd;
      v_giis_wpolbas_common.assd_no          := i.assd_no;
      v_giis_wpolbas_common.assd_name      := i.assd_name;
      v_giis_wpolbas_common.pack_par_id      := i.pack_par_id;
      v_giis_wpolbas_common.pol_flag      := i.pol_flag;
      v_giis_wpolbas_common.issue_yy      := i.issue_yy;
      v_giis_wpolbas_common.pol_seq_no      := i.pol_seq_no;
      v_giis_wpolbas_common.renew_no      := i.renew_no;
    
      PIPE ROW(v_giis_wpolbas_common);
    END LOOP;
  
  RETURN;
  END;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.23.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Update GIPI_WPOLBAS no_of_items.    
    **                       This is called during the POST-FORMS-COMMIT of GIPIS010
    */
    Procedure set_gipi_wpolbas_no_of_items(p_par_id    GIPI_WPOLBAS.par_id%TYPE)
    IS    
    BEGIN
        UPDATE GIPI_WPOLBAS
           SET no_of_items = (
                SELECT COUNT(item_no) 
                  FROM GIPI_WITEM 
                WHERE par_id = p_par_id)
         WHERE par_id = p_par_id;
    END set_gipi_wpolbas_no_of_items;

/*
**  Created by        : Bryan Joseph Abuluyan
**  Date Created     : 03.05.2010
**  Reference By     : (GIPIS029 - Required Documents Submitted)
**  Description     : Gets the expiry date of a PAR
*/
  FUNCTION get_expiry_date(p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN GIPI_WPOLBAS.expiry_date%TYPE IS
    v_exp_date                GIPI_WPOLBAS.expiry_date%TYPE;             
  BEGIN
    FOR i IN (SELECT expiry_date
                  FROM GIPI_WPOLBAS
               WHERE par_id         = p_par_id)
    LOOP
      v_exp_date     := i.expiry_date;
    END LOOP;
    RETURN v_exp_date;
  END get_expiry_date;

/*
**  Created by        : Bryan Joseph Abuluyan
**  Date Created     : 03.09.2010
**  Reference By     : (GIPIS038 - Peril Information
**  Description     : Updates WPOLBASIC after saving items and peril changes
*/
  Procedure update_wpolbasic(p_par_id            GIPI_WPOLBAS.par_id%TYPE,
                                    p_tsi_amt            GIPI_WPOLBAS.tsi_amt%TYPE,
                                  p_prem_amt        GIPI_WPOLBAS.prem_amt%TYPE,
                                  p_ann_tsi_amt        GIPI_WPOLBAS.ann_tsi_amt%TYPE,
                                  p_ann_prem_amt    GIPI_WPOLBAS.ann_prem_amt%TYPE) IS
  BEGIN
    FOR A2 IN (
     SELECT   par_id
       FROM   GIPI_WPOLBAS
      WHERE   par_id  =  p_par_id
              FOR UPDATE) LOOP
        UPDATE GIPI_WPOLBAS
           SET GIPI_WPOLBAS.tsi_amt =      p_tsi_amt,
               GIPI_WPOLBAS.prem_amt =     p_prem_amt,
               GIPI_WPOLBAS.ann_tsi_amt =  p_ann_tsi_amt,
               GIPI_WPOLBAS.ann_prem_amt = p_ann_prem_amt
         WHERE GIPI_WPOLBAS.par_id = p_par_id;
        EXIT;
     END LOOP;
  END update_wpolbasic;

/*
**  Created by        : Bryan Joseph Abuluyan
**  Date Created     : 03.09.2010
**  Reference By     : (GIPIS038 - Peril Information
**  Description     : Updates WPACK_POLBASIC after saving items and peril changes
*/  
  Procedure update_pack_wpolbas(p_pack_par_id  IN  gipi_wpolbas.pack_par_id%TYPE) 
    IS
  BEGIN
    FOR A1 IN (
      SELECT SUM(NVL(tsi_amt,0)) tsi, 
             SUM(NVL(prem_amt,0)) prem, 
             SUM(NVL(ann_tsi_amt,0)) ann_tsi, 
             SUM(NVL(ann_prem_amt,0)) ann_prem
        FROM GIPI_WPOLBAS
       WHERE EXISTS (SELECT 1
                       FROM GIPI_PARLIST z
                      WHERE z.par_id = GIPI_WPOLBAS.par_id
                        AND z.par_status NOT IN (98,99)
                        AND z.pack_par_id = p_pack_par_id)) 
    LOOP
      Gipi_Pack_Wpolbas_Pkg.update_pack_polbas(p_pack_par_id, a1.tsi, a1.prem, a1.ann_tsi, a1.ann_prem);
      EXIT;
    END LOOP;
  END update_pack_wpolbas;
  
    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.03.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure is used to retrieve the par_no based on the par_id
    */
    Procedure get_gipi_wpolbas_par_no (
        p_par_id        IN GIPI_WPOLBAS.par_id%TYPE,
        p_line_cd        OUT GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd    OUT GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        OUT GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy        OUT GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    OUT GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no        OUT GIPI_WPOLBAS.renew_no%TYPE)
    IS
    BEGIN
        FOR i IN (
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id)
        LOOP
            p_line_cd        := i.line_cd;
            p_subline_cd    := i.subline_cd;
            p_iss_cd        := i.iss_cd;
            p_issue_yy        := i.issue_yy;
            p_pol_seq_no    := i.pol_seq_no;
            p_renew_no        := i.renew_no;
        END LOOP;
    END get_gipi_wpolbas_par_no;
    
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 06.21.2010 
    **  Reference By     : (GIPIS017 - Bond Basic Info) 
    **  Description     : CHECK_OLD_BOND_NO_EXIST program unit 
    */
  FUNCTION check_old_bond_no_exist(p_par_id         GIPI_WPOLBAS.par_id%TYPE,
                                   p_assd_no        GIPI_WPOLBAS.assd_no%TYPE,
                                   p_line_cd        GIPI_POLBASIC.line_cd%TYPE,
                                   p_subline_cd     GIPI_POLBASIC.subline_cd%TYPE,
                                   p_iss_cd         GIPI_POLBASIC.iss_cd%TYPE,
                                   p_issue_yy       GIPI_POLBASIC.issue_yy%TYPE,
                                   p_pol_seq_no     GIPI_POLBASIC.pol_seq_no%TYPE,
                                   p_renew_no       GIPI_POLBASIC.renew_no%TYPE,
                                   p_pol_flag       GIPI_WPOLBAS.pol_flag%TYPE)
    RETURN VARCHAR2 IS
      v_msg_alert               VARCHAR2(2000) := '';    
      v_policy_id               GIPI_POLBASIC.policy_id%TYPE;
      v_dummy                   VARCHAR2(1) := 'N';
      v_par_id                  GIPI_WPOLNREP.par_id%TYPE;
      v_valid_bond              BOOLEAN := FALSE;
      v_assd_no                 GIPI_POLBASIC.assd_no%TYPE;
      v_AUTO_RENEW_FLAG         GIPI_POLBASIC.auto_renew_flag%TYPE;
      v_exist                   VARCHAR2(1) := 'N';
      v_exist1                  VARCHAR2(1) := 'N';
      v_address1                GIPI_POLBASIC.address1%TYPE;
      v_address2                GIPI_POLBASIC.address2%TYPE;
      v_address3                GIPI_POLBASIC.address3%TYPE;
      v_ref_pol_no              GIPI_POLBASIC.ref_pol_no%TYPE;          
      v_mortg_name              GIPI_POLBASIC.mortg_name%TYPE;        
      v_pol_flag                GIPI_POLBASIC.pol_flag%TYPE;      
  BEGIN
      FOR A IN (SELECT policy_id,assd_no, AUTO_RENEW_FLAG, pol_flag
                  FROM GIPI_POLBASIC
                 WHERE line_cd    = p_line_cd  
                   AND subline_cd = p_subline_cd 
                   AND iss_cd     = p_iss_cd 
                   AND issue_yy   = p_issue_yy 
                   AND pol_seq_no = p_pol_seq_no 
                   AND renew_no   = p_renew_no   
                   --AND pol_flag  NOT IN ('4', '5')        /* not cancelled or spoiled*/  /* nok - comment ko nalang sabi kasi nila 4, 5 at X ang VALID */ 
                   AND ROWNUM  <= 1
                 ORDER BY eff_date DESC) LOOP
          v_policy_id       := a.policy_id;
          v_assd_no         := a.assd_no;
          v_AUTO_RENEW_FLAG := a.auto_renew_flag; 
          V_VALID_BOND      := TRUE;
          v_pol_flag        := a.pol_flag;
      END LOOP; 
      
      IF p_pol_flag = '2' THEN
          IF v_pol_flag IN ('4','5') THEN 
             v_msg_alert    := NVL(v_msg_alert,'Renewal of cancelled or spoiled policy is not allowed.');
             RETURN v_msg_alert;
             V_VALID_BOND   := FALSE;
          END IF;
      ELSIF p_pol_flag = '3' THEN
          IF v_pol_flag NOT IN ('4','5','X') THEN 
             v_msg_alert    := NVL(v_msg_alert,'Policy is not yet cancelled/spoiled/expired, cannot replace policy.');
             RETURN v_msg_alert;
             V_VALID_BOND   := FALSE;
          END IF;
      END IF;
      
      IF NOT v_valid_bond THEN
         v_msg_alert := NVL(v_msg_alert,'Policy number does not exist.');
         RETURN v_msg_alert;
      END IF;   
    
    /* CHECK RENEWAL FLAG*/
    
      IF V_AUTO_RENEW_FLAG = 'Y' AND p_pol_flag = '2' THEN
          v_msg_alert := 'Cannot renew policy';
          RETURN v_msg_alert;
          V_VALID_BOND := FALSE;
      END IF;
    
    /*check if assd_no of old bond is equal to present principal*/
    
      WHILE (v_assd_no != p_assd_no ) LOOP
        v_msg_alert := NVL(v_msg_alert,'Old Bond No pertains to a different Principal');
        RETURN v_msg_alert;
        V_VALID_BOND := FALSE; 
        --:b560.nbt_policy_id3 := NULL;
        --:b560.nbt_policy_id4 := NULL;
        --:b560.nbt_policy_id5 := NULL;
          --:b560.nbt_renew_no   := NULL;
        EXIT;
      END LOOP;
    
      IF V_VALID_BOND THEN
         BEGIN
             V_VALID_BOND := FALSE;
            FOR B IN (SELECT '1'
                        FROM GIPI_POLNREP a
                       WHERE old_policy_id = v_policy_id
                         AND ROWNUM <= 1
                         AND new_policy_id IN (SELECT policy_id 
                                                 FROM gipi_polbasic
                                                WHERE pol_flag NOT IN ('4', '5'))) --added by gab 03.28.2016 SR 21421
            LOOP
               v_dummy := 'Y';
               v_msg_alert := NVL(v_msg_alert,'Please enter the latest renewal/replacement number.');
               RETURN v_msg_alert;
               V_VALID_BOND := FALSE;
            END LOOP;    
            IF v_dummy = 'N' THEN
              v_valid_bond := TRUE;
            END IF;   
         END;
      END IF;
    
      IF v_valid_bond THEN
         BEGIN    
           V_VALID_BOND := FALSE;
           FOR C IN (SELECT par_id
                        FROM GIPI_WPOLNREP
                      WHERE old_policy_id = v_policy_id
                        AND ROWNUM <= 1 
                        AND par_id IN (SELECT par_id FROM gipi_parlist WHERE par_status NOT IN ('98', '99'))) --added by gab 04.21.2016 SR 21421
           LOOP
             v_par_id := c.par_id;
           END LOOP;                 
           IF p_par_id != v_par_id THEN
              v_msg_alert := NVL(v_msg_alert,'A PAR is already renewing/replacing that policy.'|| ',-de-_limit_-er-,' ||v_policy_id);
              RETURN v_msg_alert;
           ELSE
             v_valid_bond := TRUE;
           END IF;
           IF v_par_id IS NULL THEN
             v_valid_bond := TRUE;
           END IF;   
         END;
      END IF;
    
      IF v_valid_bond THEN
         BEGIN  /* CHECK IF WITH EXISTING ENDORSEMENT*/
            V_VALID_BOND := FALSE;
            FOR D IN (SELECT par_id
                        FROM GIPI_WPOLBAS a
                       WHERE a.line_cd    = p_line_cd
                         AND a.subline_cd = p_subline_cd
                         AND a.iss_cd     = p_iss_cd
                         AND a.issue_yy   = p_issue_yy
                         AND a.pol_seq_no = p_pol_seq_no
                         AND a.renew_no   = p_renew_no
                         AND a.pol_flag NOT IN ('4', '5') 
                         AND ROWNUM <=1) LOOP
               v_exist := 'Y';
               v_msg_alert := NVL(v_msg_alert,'At least one PAR is already endorsing or renewing that policy.'|| ',-de-_limit_-er-,' ||v_policy_id);
               RETURN v_msg_alert;
            END LOOP;    
            IF v_exist = 'N' THEN
                BEGIN  /* CHECK IF WITH EXISTING CLAIMS*/
                    FOR E IN (SELECT '1'
                               FROM GICL_CLAIMS a, GIIS_CLM_STAT b, GIPI_POLBASIC c
                              WHERE b.clm_stat_type = 'N'
                                AND a.pol_seq_no = c.pol_seq_no
                                AND a.issue_yy = c.issue_yy
                                AND a.iss_cd = c.iss_cd
                                AND a.subline_cd = c.subline_cd
                                AND a.line_cd = c.line_cd
                                AND a.clm_stat_cd = b.clm_stat_cd
                                AND c.policy_id = v_policy_id
                                AND ROWNUM <= 1) LOOP
                        v_exist1 := 'Y'; 
                        v_msg_alert := NVL(v_msg_alert,'That policy has an existing claim.'|| ',-de-_limit_-er-,' ||v_policy_id);
                        RETURN v_msg_alert;
                     END LOOP;
                     IF v_exist1 = 'N' THEN
                         V_VALID_BOND := TRUE;
                        --     :b560.old_policy_id := v_policy_id;
                   END IF;
                 END;
             END IF;
         END;          
       END IF;            

      IF v_valid_bond THEN
            --populate_first_screen(v_policy_id); 
          SELECT address1, address2, address3, --subline_cd, 
                   ref_pol_no, mortg_name 
            INTO v_address1, v_address2, v_address3, --v_subline_cd
                       v_ref_pol_no, v_mortg_name 
             FROM GIPI_POLBASIC
              WHERE policy_id = v_policy_id;
         v_msg_alert := NVL(v_msg_alert,v_policy_id|| ',-de-_limit_-er-,' ||v_address1|| ',-de-_limit_-er-,' 
                         ||v_address2|| ',-de-_limit_-er-,' ||v_address3|| ',-de-_limit_-er-,' 
                        ||v_ref_pol_no|| ',-de-_limit_-er-,' ||v_mortg_name);  
         END IF;

    RETURN (v_msg_alert);
  END;

     /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 06.23.2010 
    **  Reference By     : (GIPIS017 - Bond Basic Info) 
    **  Description     : to check if incept date is within the duration of the policy to be renewed. 
    */
  FUNCTION validate_renewal_duration(p_line_cd        GIPI_POLBASIC.line_cd%TYPE,
                                        p_subline_cd   GIPI_POLBASIC.subline_cd%TYPE,
                                        p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                                        p_issue_yy        GIPI_POLBASIC.issue_yy%TYPE,
                                        p_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE,
                                        p_renew_no        GIPI_POLBASIC.renew_no%TYPE,
                                     p_incept_date    GIPI_WPOLBAS.incept_date%TYPE)
    RETURN VARCHAR2 IS
      v_msg_alert            VARCHAR2(2000);    
  BEGIN
    FOR c IN (SELECT expiry_date
              FROM GIPI_POLBASIC a
             WHERE line_cd     = p_line_cd
               AND subline_cd  = p_subline_cd
               AND iss_cd      = p_iss_cd
               AND issue_yy    = p_issue_yy
               AND pol_seq_no  = p_pol_seq_no
               AND renew_no    = p_renew_no 
               AND pol_flag    <> '5'
              /* AND endt_seq_no IN (SELECT MAX(endt_seq_no) endt_seq_no
                                                         FROM GIPI_POLBASIC b
                                                             WHERE line_cd     = a.line_cd
                                                               AND subline_cd  = a.subline_cd
                                                               AND iss_cd      = a.iss_cd
                                                               AND issue_yy    = a.issue_yy
                                                               AND pol_seq_no  = a.pol_seq_no
                                                               AND renew_no    = a.renew_no)*/ -- jhing 03.11.2016 commented out REPUBLICFULLWEB 21940
                -- jhing 03.11.2016  added condition to handle non-affecting endorsements - REPUBLICFULLWEB SR#21940 
                AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_polbasic m
                                            WHERE m.line_cd         = p_line_cd
                                              AND m.subline_cd      = p_subline_cd
                                              AND m.iss_cd          = p_iss_cd
                                              AND m.issue_yy        = p_issue_yy
                                              AND m.pol_seq_no      = p_pol_seq_no
                                              AND m.renew_no        = p_renew_no
                                              AND m.pol_flag <> '5'
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2 )     
               ORDER BY a.eff_date DESC                                                                           
                                                               ) LOOP
     --bdarusin, apr242002, added the reserved word 'trunc' in the following line
      --IF :b540.pol_flag = 2 AND trunc(:b540.incept_date) < trunc(c.expiry_date) THEN
      IF TRUNC(p_incept_date) < TRUNC(c.expiry_date) THEN
         v_msg_alert := 'Incept Date is within the duration of the policy to be renewed. '||
           'Either change the policy inception or change the policy to be renewed. ';
      END IF;
      
      EXIT;   -- jhing 03.11.2016  added by jhing REPUBLICFULLWEB SR#21940 
    END LOOP;
    RETURN (v_msg_alert);
  END;
  
  /*
  ** Moved by: emman - 06.28.10
  */
  
  FUNCTION Check_Pack_Pol_Flag (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN VARCHAR2
    IS
        /*
        **  Created by        : Mark JM
        **  Date Created     : 02.17.2010
        **  Reference By     : (GIPIS010 - Item Information)
        **  Description     : Get the pack_pol_flag of a certain record
        */
        v_pack_pol_flag    GIPI_WPOLBAS.pack_pol_flag%TYPE;
    BEGIN
        FOR TEMP IN(
            SELECT pack_pol_flag
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id)
        LOOP
          v_pack_pol_flag := TEMP.pack_pol_flag;
          EXIT;
        END LOOP;
        RETURN v_pack_pol_flag;
    END Check_Pack_Pol_Flag;  


/*
**  Created by     : Menandro G.C. Robes
**  Date Created : June 29, 2010
**  Reference By : (GIPIS097 - Endt Item Peril Information)
**  Description  : Procedure to update amounts when the discount is to be deleted.
*/
  Procedure update_gipi_wpolbas_discount (p_par_id                  GIPI_WPOLBAS.par_id%TYPE,
                                          p_disc_amt                GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
                                          p_orig_pol_ann_prem_amt   GIPI_WPERIL_DISCOUNT.orig_pol_ann_prem_amt%TYPE)
  IS
  BEGIN
    UPDATE GIPI_WPOLBAS
       SET prem_amt     = prem_amt + p_disc_amt,
           ann_prem_amt = NVL(p_orig_pol_ann_prem_amt, ann_prem_amt),
           discount_sw  = 'N'
     WHERE par_id = p_par_id;    
  END update_gipi_wpolbas_discount;

/*
**  Created by     : Menandro G.C. Robes
**  Date Created : June 29, 2010
**  Reference By : (GIPIS097 - Endt Item Peril Information)
**  Description  : Procedure to update the tsi_amt, ann_tsi_amt, prem_amt and ann_prem_amt.
*/  
  Procedure update_gipi_wpolbas_amounts (p_par_id       GIPI_WPOLBAS.par_id%TYPE,
                                         p_tsi_amt      GIPI_WPOLBAS.tsi_amt%TYPE,
                                         p_ann_tsi_amt  GIPI_WPOLBAS.ann_tsi_amt%TYPE,
                                         p_prem_amt     GIPI_WPOLBAS.prem_amt%TYPE,
                                         p_ann_prem_amt GIPI_WPOLBAS.ann_prem_amt%TYPE)
  IS
  BEGIN
     UPDATE GIPI_WPOLBAS
        SET tsi_amt      = p_tsi_amt,
            prem_amt     = p_prem_amt,
            ann_tsi_amt  = p_ann_tsi_amt,
            ann_prem_amt = p_ann_prem_amt
      WHERE par_id = p_par_id;
      
  END update_gipi_wpolbas_amounts; 
  
  Procedure create_gipi_wpolbas(p_quote_id  IN NUMBER,                 
                                  p_par_id    IN NUMBER,
                                p_line_cd   IN GIIS_LINE.line_cd%TYPE, 
                                p_iss_cd    IN VARCHAR2,
                                 p_assd_no   IN NUMBER,                 
                                p_user         IN GIPI_PACK_WPOLBAS.user_id%TYPE,
                                p_out        OUT VARCHAR2)

  IS
      v_line_cd              GIPI_WPOLBAS.line_cd%TYPE;
      v_iss_cd           GIPI_WPOLBAS.iss_cd%TYPE;
      v_subline_cd          GIPI_WPOLBAS.subline_cd%TYPE;
      v_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE;
      v_pol_seq_no              GIPI_WPOLBAS.pol_seq_no%TYPE;
      v_endt_iss_cd          GIPI_WPOLBAS.endt_iss_cd%TYPE;
      v_endt_yy           GIPI_WPOLBAS.endt_yy%TYPE;
      v_endt_seq_no          GIPI_WPOLBAS.endt_seq_no%TYPE;
      v_renew_no          GIPI_WPOLBAS.renew_no%TYPE;
      v_endt_type          GIPI_WPOLBAS.endt_type%TYPE;
      v_incept_date          GIPI_WPOLBAS.incept_date%TYPE;
      v_expiry_date          GIPI_WPOLBAS.expiry_date%TYPE;
      v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
      v_issue_date          GIPI_WPOLBAS.issue_date%TYPE;
      v_pol_flag          GIPI_WPOLBAS.pol_flag%TYPE;
      v_foreign_acc_sw          GIPI_WPOLBAS.foreign_acc_sw%TYPE;
      v_assd_no           GIPI_WPOLBAS.assd_no%TYPE;
      v_designation          GIPI_WPOLBAS.designation%TYPE;
      v_address1          GIPI_WPOLBAS.address1%TYPE;
      v_address2          GIPI_WPOLBAS.address2%TYPE;
      v_address3          GIPI_WPOLBAS.address3%TYPE;
      v_mortg_name          GIPI_WPOLBAS.mortg_name%TYPE; 
      v_tsi_amt           GIPI_WPOLBAS.tsi_amt%TYPE;
      v_prem_amt          GIPI_WPOLBAS.prem_amt%TYPE;
      v_ann_tsi_amt          GIPI_WPOLBAS.ann_tsi_amt%TYPE;
      v_ann_prem_amt            GIPI_WPOLBAS.ann_prem_amt%TYPE;
      v_invoice_sw       GIPI_WPOLBAS.invoice_sw%TYPE;
      v_pool_pol_no       GIPI_WPOLBAS.pool_pol_no%TYPE;
      v_user_id        GIPI_WPOLBAS.user_id%TYPE;
      v_quotation_printed_sw  GIPI_WPOLBAS.quotation_printed_sw%TYPE; 
      v_covernote_printed_sw GIPI_WPOLBAS.covernote_printed_sw%TYPE;
      v_orig_policy_id        GIPI_WPOLBAS.orig_policy_id%TYPE;
      v_endt_expiry_date    GIPI_WPOLBAS.endt_expiry_date%TYPE;
      v_no_of_items       GIPI_WPOLBAS.no_of_items%TYPE;
      v_subline_type_cd      GIPI_WPOLBAS.subline_type_cd%TYPE;
      v_auto_renew_flag      GIPI_WPOLBAS.auto_renew_flag%TYPE;
      v_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE;
      v_short_rt_percent  GIPI_WPOLBAS.short_rt_percent%TYPE;
      v_prov_prem_tag      GIPI_WPOLBAS.prov_prem_tag%TYPE;
      v_type_cd           GIPI_WPOLBAS.type_cd%TYPE;
      v_acct_of_cd         GIPI_WPOLBAS.acct_of_cd%TYPE;
      v_prov_prem_pct      GIPI_WPOLBAS.prov_prem_pct%TYPE;
      v_same_polno_sw      GIPI_WPOLBAS.same_polno_sw%TYPE;
      v_pack_pol_flag      GIPI_WPOLBAS.pack_pol_flag%TYPE;
      v_expiry_tag         GIPI_WPOLBAS.expiry_tag%TYPE;
      v_prem_warr_tag     GIPI_WPOLBAS.prem_warr_tag%TYPE;  
      v_ref_pol_no         GIPI_WPOLBAS.ref_pol_no%TYPE;  
      v_ref_open_pol_no     GIPI_WPOLBAS.ref_open_pol_no%TYPE;  
      v_reg_policy_sw     GIPI_WPOLBAS.reg_policy_sw%TYPE;  
      v_co_insurance_sw     GIPI_WPOLBAS.co_insurance_sw%TYPE;  
      v_discount_sw          GIPI_WPOLBAS.discount_sw%TYPE;  
      v_fleet_print_tag         GIPI_WPOLBAS.fleet_print_tag%TYPE;
      v_incept_tag             GIPI_WPOLBAS.incept_tag%TYPE;
      v_comp_sw                GIPI_WPOLBAS.comp_sw%TYPE;
      v_booking_mth            GIPI_WPOLBAS.booking_mth%TYPE;
      v_endt_expiry_tag        GIPI_WPOLBAS.endt_expiry_tag%TYPE;
      v_booking_yr             GIPI_WPOLBAS.booking_year%TYPE;
      v_prod_take_up           GIAC_PARAMETERS.param_value_n%TYPE;
      v_later_date             GIPI_WPOLBAS.issue_date%TYPE;
      v_acct_of_cd_sw    GIPI_WPOLBAS.acct_of_cd_sw%TYPE; 
      v_cred_branch    GIPI_WPOLBAS.cred_branch%TYPE; 
      v_with_tariff_sw     GIPI_WPOLBAS.with_tariff_sw%TYPE; 

      CURSOR CUR_B IS SELECT SUBLINE_CD,NVL(tsi_amt,0),NVL(prem_amt,0),NVL(print_tag,'N'),
             incept_date,expiry_date, address1, address2, address3, prorate_flag, short_rt_percent, 
           comp_sw, ann_prem_amt, ann_tsi_amt,acct_of_cd,acct_of_cd_sw,cred_branch,with_tariff_sw 
                      FROM GIPI_QUOTE 
                         WHERE quote_id = p_quote_id;
  BEGIN
    v_line_cd   := p_line_cd;
    v_iss_cd   := p_iss_cd;
    v_assd_no   := p_assd_no;
    v_issue_date := SYSDATE;
    v_later_date := SYSDATE;
    SELECT param_value_n
    INTO v_prod_take_up
    FROM GIAC_PARAMETERS
    WHERE param_name = 'PROD_TAKE_UP';
  IF v_prod_take_up = 1 THEN 
     FOR A IN (SELECT booking_year, booking_mth,
                    TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1,3)||booking_year),'MM')       
                FROM GIIS_BOOKING_MONTH
                WHERE (NVL(booked_tag, 'N') != 'Y')
                AND (booking_year > TO_NUMBER(TO_CHAR(v_issue_date, 'YYYY')) 
                  OR booking_year = TO_NUMBER(TO_CHAR(v_issue_date, 'YYYY'))) AND
                      (TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1,3)||booking_year),'MM'))
                      >= TO_NUMBER(TO_CHAR(v_issue_date, 'MM')))
                ORDER BY 1, 3)LOOP
      v_booking_mth := A.booking_mth;
      v_booking_yr := A.booking_year;         
      EXIT;
     END LOOP; 
  ELSIF v_prod_take_up = 2 THEN
    FOR A IN (SELECT booking_year, booking_mth,
                    TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1,3)||booking_year),'MM')       
                FROM GIIS_BOOKING_MONTH
                WHERE (NVL(booked_tag, 'N') != 'Y')
                AND (booking_year > TO_NUMBER(TO_CHAR(v_eff_date, 'YYYY')) 
                  OR booking_year = TO_NUMBER(TO_CHAR(v_eff_date, 'YYYY'))) AND
                      (TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1,3)||booking_year),'MM'))
                      >= TO_NUMBER(TO_CHAR(v_eff_date, 'MM')))
               ORDER BY 1, 3)LOOP
       v_booking_mth := A.booking_mth;
       v_booking_yr := A.booking_year;         
       EXIT;
     END LOOP;             
  ELSIF v_prod_take_up = 3 THEN          
    IF v_issue_date > v_eff_date THEN
       v_later_date := v_issue_date;
    ELSIF v_eff_date > v_issue_date THEN
       v_later_date := v_eff_date;  
    END IF;                  
    FOR A IN (SELECT booking_year, booking_mth,
                   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1,3)||booking_year),'MM')       
               FROM GIIS_BOOKING_MONTH
               WHERE (NVL(booked_tag, 'N') != 'Y')
               AND (booking_year > TO_NUMBER(TO_CHAR(v_later_date, 'YYYY')) 
                 OR booking_year = TO_NUMBER(TO_CHAR(v_later_date, 'YYYY'))) AND
                     (TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1,3)||booking_year),'MM'))
                     >= TO_NUMBER(TO_CHAR(v_later_date, 'MM')))
             ORDER BY 1, 3)LOOP
        v_booking_mth := A.booking_mth;
        v_booking_yr := A.booking_year;         
        EXIT;
   END LOOP;             
  ELSE
     p_out := 'Wrong Parameter....Please make the necessary changes in Giac_Parameters.';
    --msg_alert('Wrong Parameter....Please make the necessary changes in Giac_Parameters.','I',TRUE);            
  END IF;               
  
  OPEN CUR_B;
  FETCH CUR_B 
  INTO V_SUBLINE_CD,v_tsi_amt,v_prem_amt,v_quotation_printed_sw,v_incept_date,v_expiry_date,v_address1,
       v_address2,v_address3,v_prorate_flag, v_short_rt_percent, v_comp_sw, v_ann_prem_amt, v_ann_tsi_amt,
    v_acct_of_cd,v_acct_of_cd_sw,v_cred_branch,v_with_tariff_sw;
 CLOSE CUR_B; 
 FOR A IN (SELECT designation
            FROM GIIS_ASSURED
            WHERE assd_no = v_assd_no) LOOP
   v_designation := A.DESIGNATION;
   EXIT;
 END LOOP;
  v_endt_iss_cd := NULL;       v_foreign_acc_sw := 'N';      v_endt_yy := 0;                 v_endt_seq_no := 0;
 v_renew_no := 0;        v_endt_type := NULL;        v_pol_flag:= 1;             v_mortg_name := NULL;
 v_invoice_sw := 'N';      v_pool_pol_no := NULL;        v_covernote_printed_sw := 'N';  v_orig_policy_id := NULL;
 v_endt_expiry_date := NULL;  v_no_of_items := NULL;        v_subline_type_cd := NULL;      v_auto_renew_flag := 'N';
 v_prov_prem_tag := 'N';   v_type_cd := NULL;      v_prov_prem_pct := NULL;     v_same_polno_sw := 'N';
   v_pack_pol_flag := 'N';   v_expiry_tag := 'N';     v_discount_sw := 'N';     v_prem_warr_tag := 'N';
    v_ref_pol_no := NULL;   v_reg_policy_sw := 'Y';    v_co_insurance_sw := 1;     v_ref_open_pol_no := NULL;
   v_incept_tag := 'N';   v_endt_expiry_tag := NULL;    v_fleet_print_tag := 'N'; 
  
  INSERT INTO GIPI_WPOLBAS
         (par_id,line_cd,subline_cd,iss_cd, issue_yy, pol_seq_no,        
          endt_iss_cd,endt_yy, endt_seq_no, renew_no, endt_type,
          incept_date, expiry_date, eff_date, issue_date,
          pol_flag, foreign_acc_sw, assd_no, designation,
          address1, address2, address3, mortg_name,
          tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,   
          invoice_sw, pool_pol_no, user_id, quotation_printed_sw,
          covernote_printed_sw, orig_policy_id, endt_expiry_date,  
          no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
          short_rt_percent, prov_prem_tag, type_cd, acct_of_cd,   
          prov_prem_pct, same_polno_sw, pack_pol_flag,  expiry_tag,
          prem_warr_tag,ref_pol_no,ref_open_pol_no,reg_policy_sw,co_insurance_sw,
          discount_sw,fleet_print_tag,incept_tag,comp_sw,booking_mth,
          endt_expiry_tag,booking_year,acct_of_cd_sw,cred_branch,with_tariff_sw)
  VALUES ( p_par_id,v_line_cd,v_subline_cd,v_iss_cd,
         TO_NUMBER(TO_CHAR(SYSDATE,'YY')), v_pol_seq_no,v_endt_iss_cd,v_endt_yy, 
         v_endt_seq_no,v_renew_no,v_endt_type,v_incept_date,v_expiry_date,v_incept_date,
         v_issue_date,v_pol_flag, v_foreign_acc_sw, v_assd_no, v_designation,
         v_address1, v_address2, v_address3, v_mortg_name,v_tsi_amt, v_prem_amt, 
         v_ann_tsi_amt, v_ann_prem_amt,v_invoice_sw, v_pool_pol_no,p_user,
         v_quotation_printed_sw,v_covernote_printed_sw,v_orig_policy_id,
         v_endt_expiry_date,v_no_of_items,v_subline_type_cd, v_auto_renew_flag,
         v_prorate_flag,v_short_rt_percent,v_prov_prem_tag,v_type_cd,v_acct_of_cd,   
         v_prov_prem_pct,v_same_polno_sw,v_pack_pol_flag,v_expiry_tag,v_prem_warr_tag,
         v_ref_pol_no,v_ref_open_pol_no,v_reg_policy_sw,v_co_insurance_sw,
         v_discount_sw,v_fleet_print_tag,v_incept_tag,v_comp_sw,v_booking_mth,
         v_endt_expiry_tag,v_booking_yr,v_acct_of_cd_sw,v_cred_branch,v_with_tariff_sw);

    UPDATE GIPI_PARLIST
       SET PAR_STATUS = 3
     WHERE PAR_ID = p_par_id;
    Delete_Workflow_Rec('', 'GIIMM001',NVL(giis_users_pkg.app_user, USER), p_quote_id); 
    COMMIT;
  END;

    PROCEDURE SET_GIPI_WPOLBAS_FROM_ENDT (
        p_par_id IN gipi_wpolbas.par_id%TYPE,
        p_line_cd IN gipi_wpolbas.line_cd%TYPE,
        p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
        p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
        p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
        p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
        p_renew_no IN gipi_wpolbas.renew_no%TYPE,
        p_endt_iss_cd IN gipi_wpolbas.endt_iss_cd%TYPE,
        p_endt_yy IN gipi_wpolbas.endt_yy%TYPE,
        p_endt_seq_no IN gipi_wpolbas.endt_seq_no%TYPE,
        p_incept_date IN gipi_wpolbas.incept_date%TYPE,
        p_incept_tag IN gipi_wpolbas.incept_tag%TYPE,
        p_expiry_date IN gipi_wpolbas.expiry_date%TYPE,
        p_expiry_tag IN gipi_wpolbas.expiry_tag%TYPE,
        p_eff_date IN gipi_wpolbas.eff_date%TYPE,
        p_endt_expiry_date IN gipi_wpolbas.endt_expiry_date%TYPE,
        p_endt_expiry_tag IN gipi_wpolbas.endt_expiry_tag%TYPE,
        p_issue_date IN gipi_wpolbas.issue_date%TYPE,
        p_invoice_sw IN gipi_wpolbas.invoice_sw%TYPE,
        p_pol_flag IN gipi_wpolbas.pol_flag%TYPE,
        p_manual_renew_no IN gipi_wpolbas.manual_renew_no%TYPE,
        p_type_cd IN gipi_wpolbas.type_cd%TYPE,
        p_address1 IN gipi_wpolbas.address1%TYPE,
        p_address2 IN gipi_wpolbas.address2%TYPE,
        p_address3 IN gipi_wpolbas.address3%TYPE,
        p_designation IN gipi_wpolbas.designation%TYPE,
        p_cred_branch IN gipi_wpolbas.cred_branch%TYPE,
        p_assd_no IN gipi_wpolbas.assd_no%TYPE,
        p_acct_of_cd IN gipi_wpolbas.acct_of_cd%TYPE,
        p_place_cd IN gipi_wpolbas.place_cd%TYPE,
        p_risk_tag IN gipi_wpolbas.risk_tag%TYPE,
        p_ref_pol_no IN gipi_wpolbas.ref_pol_no%TYPE,
        p_industy_cd IN gipi_wpolbas.industry_cd%TYPE,
        p_region_cd IN gipi_wpolbas.region_cd%TYPE,
        p_quotation_printed_sw IN gipi_wpolbas.quotation_printed_sw%TYPE,
        p_covernote_printed_sw IN gipi_wpolbas.covernote_printed_sw%TYPE,
        p_pack_pol_flag IN gipi_wpolbas.pack_pol_flag%TYPE,
        p_auto_renew_flag IN gipi_wpolbas.auto_renew_flag%TYPE,
        p_foreign_acc_sw IN gipi_wpolbas.foreign_acc_sw%TYPE,
        p_reg_policy_sw IN gipi_wpolbas.reg_policy_sw%TYPE,
        p_prem_warr_tag IN gipi_wpolbas.prem_warr_tag%TYPE,
        p_prem_warr_days IN gipi_wpolbas.prem_warr_days%TYPE,
        p_fleet_print_tag IN gipi_wpolbas.fleet_print_tag%TYPE,
        p_with_tariff_sw IN gipi_wpolbas.with_tariff_sw%TYPE,
        p_prov_prem_tag IN gipi_wpolbas.prov_prem_tag%TYPE,
        p_prov_prem_pct IN gipi_wpolbas.prov_prem_pct%TYPE,
        p_prorate_flag IN gipi_wpolbas.prorate_flag%TYPE,
        p_comp_sw IN gipi_wpolbas.comp_sw%TYPE,
        p_short_rt_percent IN gipi_wpolbas.short_rt_percent%TYPE,
        p_booking_year IN gipi_wpolbas.booking_year%TYPE,
        p_booking_mth IN gipi_wpolbas.booking_mth%TYPE,
        p_co_insurance_sw IN gipi_wpolbas.co_insurance_sw%TYPE,
        p_takeup_term IN gipi_wpolbas.takeup_term%TYPE,
        p_same_polno_sw IN gipi_wpolbas.same_polno_sw%TYPE,
        p_cancel_type IN gipi_wpolbas.cancel_type%TYPE,
        p_tsi_amt IN gipi_wpolbas.tsi_amt%TYPE,
        p_prem_amt IN gipi_wpolbas.prem_amt%TYPE,
        p_ann_tsi_amt IN gipi_wpolbas.ann_tsi_amt%TYPE,
        p_ann_prem_amt IN gipi_wpolbas.ann_prem_amt%TYPE,
        p_old_assd_no IN gipi_wpolbas.old_assd_no%TYPE,
        p_old_address1 IN gipi_wpolbas.old_address1%TYPE,
        p_old_address2 IN gipi_wpolbas.old_address2%TYPE,
        p_old_address3 IN gipi_wpolbas.old_address3%TYPE,
        p_acct_of_cd_sw IN gipi_wpolbas.acct_of_cd_sw%TYPE,
        p_user_id IN gipi_wpolbas.user_id%TYPE,
        p_back_stat IN gipi_wpolbas.back_stat%TYPE,
        p_bancassurance_sw IN gipi_wpolbas.bancassurance_sw%TYPE,
        p_survey_agent_cd IN gipi_wpolbas.survey_agent_cd%TYPE,
        p_settling_agent_cd IN gipi_wpolbas.settling_agent_cd%TYPE,
        p_cancelled_endt_id IN gipi_wpolbas.cancelled_endt_id%TYPE,
        p_label_tag IN gipi_wpolbas.label_tag%TYPE, -- bonok :: 12.18.2012
        p_banc_type_cd IN gipi_wpolbas.banc_type_cd%TYPE,
        p_branch_cd IN gipi_wpolbas.branch_cd%TYPE,
        p_manager_cd IN gipi_wpolbas.manager_cd%TYPE,
        p_area_cd IN gipi_wpolbas.area_cd%TYPE) --apollo cruz 11.06.2014 - added banca fields
    IS
        /*    Date        Author            Description
        **    ==========    ===============    ============================
        **    07.26.2010    mark jm            This procedures inserts/updates record on GIPI_WPOLBAS based on given parameters
        **    01.25.2012    mark jm            added back_stat and bancassurance_sw parameter 
        **    01.26.2012    mark jm            added survey_agent_cd and settling_agent_cd parameter
        **    08.15.2012    Irwin Tabisora     modified times of  Incept Date Time, Expiry Date Time, Endt Expiry Date Time, Issue Date Time, Effectivity Date
		**    09.10.2012    Irwin Tabisora     modified issue date to reflect sysdate time rather than the subline time.
        **    09.26.2012    Robert Virrey      added cancelled_endt_id
        **    12.20.2012    Nica			   modified so that if Endorsement effectivity date is the same as the endorsement date  of the 
        **									   latest endorsement, the time of the Endorsement effectivity date is adjusted by adding one minute
		*/        
	  
	  v_temp_incept_date        gipi_wpolbas.incept_date%TYPE;
      v_temp_expiry_date        gipi_wpolbas.expiry_date%TYPE;
      v_temp_endt_expiry_date   gipi_wpolbas.endt_expiry_date%TYPE;
      v_temp_issue_date         gipi_wpolbas.issue_date%TYPE;
      v_temp_eff_date           gipi_wpolbas.eff_date%TYPE;
      v_subline_time            giis_subline.subline_time%TYPE;
	  v_eff_date   				DATE;  -- added by: Nica 12.20.2012 field that will store the max. eff_date if there are records with same eff_date as the neterd eff_date
	
	BEGIN
		
		BEGIN
         SELECT NVL(a210.subline_time, 0)
           INTO v_subline_time
           FROM giis_subline a210
          WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
      END;
	   v_temp_incept_date :=
                  TRUNC (p_incept_date)
                + TO_NUMBER (v_subline_time) / 86400;	
       v_temp_expiry_date :=
                      TRUNC (p_expiry_date)
                      + TO_NUMBER (v_subline_time) / 86400;
       v_temp_endt_expiry_date :=
                 TRUNC (p_endt_expiry_date)
                 + TO_NUMBER (v_subline_time) / 86400;
       v_temp_issue_date :=
                       TRUNC (p_issue_date)
                       + (sysdate -  trunc(sysdate)); -- adds the current time to the issue date. -- to avoid timezon error in js - irwin
					   
					   
	IF TRUNC(p_incept_date) = TRUNC(P_EFF_DATE) then  	
        v_temp_eff_date :=
                  TRUNC (P_EFF_DATE)
                + (TO_NUMBER (v_subline_time) + 60) / 86400;
	ELSE 
		 v_temp_eff_date :=
		  TRUNC (P_EFF_DATE)
		+ TO_NUMBER (v_subline_time) / 86400;		
	END IF;
	
	-- added by: Nica 12.20.2012
	-- retrieved if there is an existing date same as the entered date
	-- for records with more than 1 record with same eff_date get the maximum date    
	FOR A IN (SELECT eff_date
				FROM gipi_polbasic
			   WHERE line_cd     = p_line_cd
				 AND subline_cd  = p_subline_cd
				 AND iss_cd      = p_iss_cd
				 AND issue_yy    = p_issue_yy
				 AND pol_seq_no  = p_pol_seq_no
				 AND renew_no    = p_renew_no
				 AND pol_flag   IN ('1','2','3')
				 AND eff_date = (SELECT MAX(eff_date)
								   FROM gipi_polbasic
								  WHERE line_cd    = p_line_cd
									AND subline_cd = p_subline_cd
									AND iss_cd     = p_iss_cd
									AND issue_yy   = p_issue_yy
									AND pol_seq_no = p_pol_seq_no
									AND renew_no   = p_renew_no
									AND pol_flag   IN ('1','2','3')                                        
								   AND TRUNC(eff_date)   = TRUNC(p_eff_date))
			ORDER BY eff_date DESC)
	LOOP
	  v_eff_date := A.eff_date;
	  EXIT;
	END LOOP;
	
	-- If Endorsement effectivity date is the same as the endorsement date   
    -- of the latest endorsement, the time of the Endorsement effectivity    
    -- date is adjusted by adding one minute. Nica 12.20.2012                                
    
	IF v_eff_date IS NOT NULL THEN        
       v_temp_eff_date := v_eff_date + (1/1440);
    END IF;				   
      		
        MERGE INTO gipi_wpolbas
        USING DUAL ON ( par_id = p_par_id )
        WHEN NOT MATCHED THEN
            INSERT (
                par_id,                    line_cd,            subline_cd,            iss_cd,             issue_yy,     
                pol_seq_no,             renew_no,            endt_iss_cd,        endt_yy,            endt_seq_no,
                incept_date,            incept_tag,         expiry_date,        expiry_tag,            eff_date,
                endt_expiry_date,        endt_expiry_tag,    issue_date,         invoice_sw,         pol_flag,
                manual_renew_no,        type_cd,            address1,            address2,            address3,
                designation,            cred_branch,        assd_no,            acct_of_cd,         place_cd,
                risk_tag,                ref_pol_no,            industry_cd,        region_cd,            quotation_printed_sw,
                covernote_printed_sw,    pack_pol_flag,        auto_renew_flag,    foreign_acc_sw,     reg_policy_sw,
                prem_warr_tag,            prem_warr_days,        fleet_print_tag,    with_tariff_sw,     prov_prem_tag,
                prov_prem_pct,            prorate_flag,        comp_sw,            short_rt_percent,    booking_year,
                booking_mth,            co_insurance_sw,    takeup_term,        same_polno_sw,        cancel_type,
                tsi_amt,                prem_amt,            ann_tsi_amt,        ann_prem_amt,        old_assd_no,
                old_address1,            old_address2,        old_address3,        acct_of_cd_sw,        user_id,
                back_stat,                bancassurance_sw,    survey_agent_cd,    settling_agent_cd,  cancelled_endt_id,
                label_tag, banc_type_cd, area_cd, branch_cd, manager_cd)
            VALUES    (
                p_par_id,                p_line_cd,                p_subline_cd,        p_iss_cd,            p_issue_yy,
                p_pol_seq_no,            p_renew_no,                p_endt_iss_cd,        p_endt_yy,            p_endt_seq_no,
                /*p_incept_date*/v_temp_incept_date ,            p_incept_tag,            /*p_expiry_date*/v_temp_expiry_date ,        p_expiry_tag,        /*p_eff_date*/v_temp_eff_date ,
                /*p_endt_expiry_date*/v_temp_endt_expiry_date ,     p_endt_expiry_tag,       v_temp_issue_date ,        p_invoice_sw,        p_pol_flag,
                p_manual_renew_no,        p_type_cd,                p_address1,            p_address2,            p_address3,
                p_designation,            p_cred_branch,            p_assd_no,            p_acct_of_cd,        p_place_cd,
                p_risk_tag,             p_ref_pol_no,            p_industy_cd,        p_region_cd,        p_quotation_printed_sw,
                p_covernote_printed_sw, p_pack_pol_flag,        p_auto_renew_flag,    p_foreign_acc_sw,    p_reg_policy_sw,
                p_prem_warr_tag,        p_prem_warr_days,        p_fleet_print_tag,    p_with_tariff_sw,    p_prov_prem_tag,
                p_prov_prem_pct,        p_prorate_flag,            p_comp_sw,            p_short_rt_percent,    p_booking_year,
                p_booking_mth,            p_co_insurance_sw,        p_takeup_term,        p_same_polno_sw,    p_cancel_type,
                p_tsi_amt,                p_prem_amt,                p_ann_tsi_amt,        p_ann_prem_amt,        p_old_assd_no,
                p_old_address1,            p_old_address2,            p_old_address3,        p_acct_of_cd_sw,    p_user_id,
                p_back_stat,            p_bancassurance_sw,        p_survey_agent_cd,    p_settling_agent_cd,   p_cancelled_endt_id,
                p_label_tag, p_banc_type_cd, p_area_cd, p_branch_cd, p_manager_cd)
        WHEN MATCHED THEN
            UPDATE SET 
                line_cd = p_line_cd,
                subline_cd = p_subline_cd,
                iss_cd = p_iss_cd,
                issue_yy = p_issue_yy,
                pol_seq_no = p_pol_seq_no,
                renew_no = p_renew_no,
                endt_iss_cd = p_endt_iss_cd,
                endt_yy = p_endt_yy,
                endt_seq_no = p_endt_seq_no,
                incept_date = /*p_incept_date*/v_temp_incept_date ,
                incept_tag = p_incept_tag,
                expiry_date = /*p_expiry_date*/ v_temp_expiry_date ,
                expiry_tag = p_expiry_tag,
                eff_date = /*p_eff_date*/v_temp_eff_date ,
                endt_expiry_date = /*p_endt_expiry_date*/ v_temp_endt_expiry_date ,   
                endt_expiry_tag = p_endt_expiry_tag,
                issue_date = v_temp_issue_date ,
                invoice_sw = p_invoice_sw,
                pol_flag = p_pol_flag,
                manual_renew_no = p_manual_renew_no,    
                type_cd = p_type_cd,
                address1 = p_address1,
                address2 = p_address2,
                address3 = p_address3,
                designation = p_designation,
                cred_branch = p_cred_branch,
                assd_no = p_assd_no,
                acct_of_cd = p_acct_of_cd,
                place_cd = p_place_cd,
                risk_tag = p_risk_tag,
                ref_pol_no = p_ref_pol_no,
                industry_cd = p_industy_cd,
                region_cd = p_region_cd,
                quotation_printed_sw = p_quotation_printed_sw,
                covernote_printed_sw = p_covernote_printed_sw,
                pack_pol_flag = p_pack_pol_flag,
                auto_renew_flag = p_auto_renew_flag,
                foreign_acc_sw = p_foreign_acc_sw,
                reg_policy_sw = p_reg_policy_sw,
                prem_warr_tag = p_prem_warr_tag,
                prem_warr_days = p_prem_warr_days,
                fleet_print_tag = p_fleet_print_tag,
                with_tariff_sw = p_with_tariff_sw,
                prov_prem_tag = p_prov_prem_tag,
                prov_prem_pct = p_prov_prem_pct,
                prorate_flag = p_prorate_flag,
                comp_sw = p_comp_sw,
                short_rt_percent = p_short_rt_percent,
                booking_year = p_booking_year,
                booking_mth = p_booking_mth,
                co_insurance_sw = p_co_insurance_sw,
                takeup_term = p_takeup_term,
                same_polno_sw = p_same_polno_sw,
                cancel_type = p_cancel_type,
                tsi_amt = p_tsi_amt,
                prem_amt = p_prem_amt,
                ann_tsi_amt = p_ann_tsi_amt,
                ann_prem_amt = p_ann_prem_amt,
                old_assd_no = p_old_assd_no,
                old_address1 = p_old_address1,
                old_address2 = p_old_address2,
                old_address3 = p_old_address3,
                acct_of_cd_sw = p_acct_of_cd_sw,
                user_id = p_user_id,
                back_stat = p_back_stat,
                bancassurance_sw = p_bancassurance_sw,
                survey_agent_cd = p_survey_agent_cd,
                settling_agent_cd = p_settling_agent_cd,
				cancelled_endt_id = p_cancelled_endt_id,
                label_tag = p_label_tag, -- bonok :: 12.18.2012
                banc_type_cd = p_banc_type_cd,
                area_cd = p_area_cd,
                branch_cd = p_branch_cd,
                manager_cd = p_manager_cd; 
    END SET_GIPI_WPOLBAS_FROM_ENDT;
    
    FUNCTION get_policy_no_for_endtpar (p_par_id    GIPI_WPOLBAS.par_id%TYPE) 
       RETURN VARCHAR2 is
       v_policy_no      VARCHAR2(50);   --replace by steven 4.30.2012: VARCHAR2(30) to VARCHAR2(50)
    BEGIN
        
        FOR i IN (SELECT (line_cd || ' - ' 
                        || subline_cd || ' - ' 
                        || iss_cd || ' - ' 
                        || to_char(issue_yy, '09') || ' - ' 
                        || to_char(pol_seq_no,'0000009')) policy_no
                  FROM gipi_wpolbas 
                  WHERE par_id = p_par_id)
        LOOP
          v_policy_no     := i.policy_no;
        END LOOP;
        RETURN v_policy_no;

    END get_policy_no_for_endtpar;
    
/*
**  Created by   : Jerome Orio 
**  Date Created : Nov. 17, 2010 
**  Reference By : (GIPIS002 - Basic Information, 
                    GIPIS017 - Bond Basic Information)
**  Description  : Procedure to generate bank reference number in gipis002, gipis017.  
*/      
    PROCEDURE generate_bank_ref_no(
        p_acct_iss_cd        IN   giis_ref_seq.acct_iss_cd%TYPE,
        p_branch_cd          IN   giis_ref_seq.branch_cd%TYPE,
        p_bank_ref_no       OUT   gipi_wpolbas.bank_ref_no%TYPE,
        p_msg_alert         OUT   VARCHAR2,
        p_par_id             IN   gipi_wpolbas.par_id%TYPE
        ) IS 
        v_ref_no        giis_ref_seq.ref_no%TYPE;
        v_dsp_mod_no    gipi_ref_no_hist.mod_no%TYPE;
    BEGIN    
        generate_ref_no (p_acct_iss_cd, p_branch_cd, v_ref_no,'GIPIS002');
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
            
          UPDATE gipi_wpolbas
             SET bank_ref_no = p_bank_ref_no
           WHERE par_id = p_par_id;
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
**  Date Created : 01-11-2011 
**  Reference By : (GIPIS002 - Basic Information, 
                    GIPIS017 - Bond Basic Information)
**  Description  : Procedure to validate issue code in bank reference number in gipis002, gipis017.  
*/ 
    FUNCTION validate_acct_iss_cd(p_acct_iss_cd VARCHAR2)
    RETURN VARCHAR2 IS
      v_acct_iss_cd NUMBER;
      v_msg_alert   VARCHAR2(2000) := '';
    BEGIN
        SELECT acct_iss_cd
          INTO v_acct_iss_cd
          FROM giis_issource
         WHERE acct_iss_cd = p_acct_iss_cd;
         RETURN nvl(v_msg_alert,'');
    EXCEPTION 
      WHEN no_data_found THEN
          v_msg_alert := 'Invalid issue code ('||p_acct_iss_cd||') selected.';
        RETURN v_msg_alert;
    END;
    
/*
**  Created by   : Jerome Orio 
**  Date Created : 01-11-2011 
**  Reference By : (GIPIS002 - Basic Information, 
                    GIPIS017 - Bond Basic Information)
**  Description  : Procedure to validate branch code in bank reference number in gipis002, gipis017.  
*/ 
    FUNCTION validate_branch_cd(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2
        ) RETURN VARCHAR2 IS
      v_number      NUMBER;
      v_msg_alert   VARCHAR2(2000) := '';
    BEGIN
        SELECT 1
        INTO v_number
        FROM gipi_ref_no_hist b
       WHERE NOT EXISTS (
               SELECT bank_ref_no
                 FROM gipi_wpolbas
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_polbasic
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_quote
                WHERE bank_ref_no = b.bank_ref_no
                UNION
               SELECT bank_ref_no
                 FROM gipi_pack_wpolbas
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_pack_polbasic
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_pack_quote
                WHERE bank_ref_no = b.bank_ref_no)
         AND branch_cd <> 0
         AND acct_iss_cd = p_acct_iss_cd
         AND branch_cd = p_branch_cd;
         RETURN nvl(v_msg_alert,'');
    EXCEPTION 
      WHEN no_data_found THEN
          v_msg_alert := 'no_data_found';
        RETURN v_msg_alert;
      WHEN too_many_rows THEN
        v_msg_alert := 'too_many_rows';
        RETURN v_msg_alert;
    END;    
    
/*
**  Created by   : Jerome Orio 
**  Date Created : 01-11-2011 
**  Reference By : (GIPIS002 - Basic Information, 
                    GIPIS017 - Bond Basic Information)
**  Description  : Procedure to validate bank reference no. in bank reference number in gipis002, gipis017.  
*/ 
    FUNCTION validate_bank_ref_no(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_ref_no        VARCHAR2,
        p_mod_no        VARCHAR2,
        p_bank_ref_no   VARCHAR2
        ) RETURN VARCHAR2 IS
      v_number      NUMBER;
      v_msg_alert   VARCHAR2(2000) := '';
    BEGIN
      SELECT 1
        INTO v_number
        FROM gipi_ref_no_hist b
       WHERE NOT EXISTS (
               SELECT bank_ref_no
                 FROM gipi_wpolbas
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_polbasic
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_quote
                WHERE bank_ref_no = b.bank_ref_no
                UNION
               SELECT bank_ref_no
                 FROM gipi_pack_wpolbas
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_pack_polbasic
                WHERE bank_ref_no = b.bank_ref_no
               UNION
               SELECT bank_ref_no
                 FROM gipi_pack_quote
                WHERE bank_ref_no = b.bank_ref_no                )
         AND branch_cd <> 0
         AND acct_iss_cd = p_acct_iss_cd
         AND branch_cd = p_branch_cd
         AND ref_no = p_ref_no
         AND mod_no = p_mod_no
         AND bank_ref_no = p_bank_ref_no;
      RETURN nvl(v_msg_alert,'');    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
      IF p_acct_iss_cd <> 01
         OR p_branch_cd <> 0
         OR p_ref_no <> 0000000
         OR p_mod_no <> 00
      THEN
        v_msg_alert := 'Invalid reference number entered. (see list of values for valid reference numbers).';
        RETURN v_msg_alert;   
      END IF;         
    END;
    
    FUNCTION get_endt_bancassurance_dtl(p_par_id    gipi_wpolbas.par_id%TYPE )
      
      RETURN endt_bancassurance_dtl_tab PIPELINED
      
    IS
       
      v_endt_bancassurance_dtl   endt_bancassurance_dtl_type;
      
   BEGIN
   
      FOR i IN (SELECT *
                  FROM (SELECT a.par_id,a.bancassurance_sw,a.banc_type_cd,a.branch_cd,
                               a.area_cd,a.manager_cd,b.banc_type_desc,
                               c.area_desc,d.branch_desc,
                               e.payee_last_name||', '
                               ||e.payee_first_name || ' ' 
                               ||e.payee_middle_name payee_full_name
                          FROM gipi_wpolbas a, 
                               giis_banc_type b, 
                               giis_banc_area c, 
                               giis_banc_branch d, 
                               giis_payees e
                         WHERE a.banc_type_cd = b.banc_type_cd
                           AND a.area_cd = c.area_cd
                           AND a.branch_cd = d.branch_cd
                           AND a.manager_cd = e.payee_no
                           AND e.payee_class_cd = giisp.v('BANK_MANAGER_PAYEE_CLASS'))
                 WHERE par_id = NVL (p_par_id, par_id))
      LOOP
         
         v_endt_bancassurance_dtl.bancassurance_sw  := i.bancassurance_sw;
         v_endt_bancassurance_dtl.banc_type_cd      := i.banc_type_cd;
         v_endt_bancassurance_dtl.area_cd           := i.area_cd;
         v_endt_bancassurance_dtl.branch_cd         := i.branch_cd;
         v_endt_bancassurance_dtl.manager_cd        := i.manager_cd;
         v_endt_bancassurance_dtl.banc_type_desc    := i.banc_type_desc;
         v_endt_bancassurance_dtl.area_desc         := i.area_desc;
         v_endt_bancassurance_dtl.branch_desc       := i.branch_desc;
         v_endt_bancassurance_dtl.full_name         := i.payee_full_name;

         PIPE ROW (v_endt_bancassurance_dtl);
         
      END LOOP;
      
   END get_endt_bancassurance_dtl; 
      
        /**
            EDITED: 08.16.2012    Irwin Tabisora     modified times of  Incept Date Time, Expiry Date Time, Endt Expiry Date Time, Issue Date Time, Effectivity Date
        */
		/**
			EDITED: 08.16.2012    Irwin Tabisora     modified times of  Incept Date Time, Expiry Date Time, Endt Expiry Date Time, Issue Date Time, Effectivity Date
		*/
      PROCEDURE set_gipi_wpolbas_endt_bond (
        p_par_id                 gipi_wpolbas.par_id%TYPE,
        p_assd_no                gipi_wpolbas.assd_no%TYPE,
        p_line_cd                gipi_wpolbas.line_cd%TYPE,
        p_subline_cd             gipi_wpolbas.subline_cd%TYPE,
        p_iss_cd                 gipi_wpolbas.iss_cd%TYPE,
        p_issue_yy               gipi_wpolbas.issue_yy%TYPE,
        p_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE,
        p_renew_no               gipi_wpolbas.renew_no%TYPE,
        p_endt_iss_cd            gipi_wpolbas.endt_iss_cd%TYPE,
        p_endt_yy                gipi_wpolbas.endt_yy%TYPE,
        p_incept_date            gipi_wpolbas.incept_date%TYPE,
        p_expiry_date            gipi_wpolbas.expiry_date%TYPE,
        p_eff_date               gipi_wpolbas.eff_date%TYPE,
        p_endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE,
        p_issue_date             gipi_wpolbas.issue_date%TYPE,
        p_ref_pol_no             gipi_wpolbas.ref_pol_no%TYPE,
        p_type_cd                gipi_wpolbas.type_cd%TYPE,
        p_region_cd              gipi_wpolbas.region_cd%TYPE,
        p_address1               gipi_wpolbas.address1%TYPE,
        p_address2               gipi_wpolbas.address2%TYPE,
        p_address3               gipi_wpolbas.address3%TYPE,
        p_mortg_name             gipi_wpolbas.mortg_name%TYPE,
        p_industry_cd            gipi_wpolbas.industry_cd%TYPE,
        p_cred_branch            gipi_wpolbas.cred_branch%TYPE,
        p_booking_mth            gipi_wpolbas.booking_mth%TYPE,
        p_booking_year           gipi_wpolbas.booking_year%TYPE,
        p_takeup_term            gipi_wpolbas.takeup_term%TYPE,
        p_incept_tag             gipi_wpolbas.incept_tag%TYPE,
        p_expiry_tag             gipi_wpolbas.expiry_tag%TYPE,
        p_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE,
        p_reg_policy_sw          gipi_wpolbas.reg_policy_sw%TYPE,
        p_foreign_acc_sw         gipi_wpolbas.foreign_acc_sw%TYPE, 
        p_invoice_sw             gipi_wpolbas.invoice_sw%TYPE, 
        p_auto_renew_flag        gipi_wpolbas.auto_renew_flag%TYPE, 
        p_prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE, 
        p_pack_pol_flag          gipi_wpolbas.pack_pol_flag%TYPE, 
        p_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE,
        p_user_id                gipi_wpolbas.user_id%TYPE,
        p_pol_flag               gipi_wpolbas.pol_flag%TYPE,
        p_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE,
        p_covernote              gipi_wpolbas.covernote_printed_sw%TYPE,
        p_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE,
        p_same_polno_sw          gipi_wpolbas.same_polno_sw%TYPE,
        p_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE,
        p_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE,
        p_bond_seq_no            gipi_wpolbas.bond_seq_no%TYPE,
		p_cancel_type			 gipi_wpolbas.cancel_type%TYPE,
		p_old_assd_no            gipi_wpolbas.old_assd_no%TYPE,		/*added by steven 8/31/2012*/
		p_old_address1           gipi_wpolbas.old_address1%TYPE,
        p_old_address2           gipi_wpolbas.old_address2%TYPE,
        p_old_address3           gipi_wpolbas.old_address3%TYPE, --additional parameters by robert GENQA SR 4825 08.03.15
		p_prorate_flag           gipi_wpolbas.prorate_flag%TYPE,
        p_comp_sw	             gipi_wpolbas.comp_sw%TYPE,
        p_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE, -- end GENQA SR 4825 08.03.15
		p_bond_auto_prem         gipi_wpolbas.bond_auto_prem%TYPE --additional parameter by robert GENQA SR 4828 08.25.15
    )
    
    IS
        v_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE;
        v_endt_flag                NUMBER(1) := 0;
		v_temp_incept_date        gipi_wpolbas.incept_date%TYPE;
        v_temp_expiry_date        gipi_wpolbas.expiry_date%TYPE;
        v_temp_endt_expiry_date   gipi_wpolbas.endt_expiry_date%TYPE;
        v_temp_issue_date         gipi_wpolbas.issue_date%TYPE;
        v_temp_eff_date           gipi_wpolbas.eff_date%TYPE;
        v_subline_time            giis_subline.subline_time%TYPE;
    BEGIN
        v_endt_seq_no := nvl(p_endt_seq_no, null);
        
        IF p_endt_seq_no = null OR p_endt_seq_no = '' THEN
            
            FOR a IN (
                SELECT endt_seq_no FROM gipi_wpolbas 
                 WHERE par_id = p_par_id
            ) LOOP
                v_endt_seq_no := a.endt_seq_no;
                v_endt_flag := 1;
            END LOOP;
            
            IF v_endt_flag <> 1 THEN
                FOR i IN (
                    SELECT MAX(endt_seq_no) endt_seq_no 
                      FROM gipi_polbasic b2501
                     WHERE b2501.line_cd    = p_line_cd
                       AND b2501.subline_cd = p_subline_cd
                       AND b2501.iss_cd     = p_iss_cd
                       AND b2501.issue_yy   = p_issue_yy
                       AND b2501.pol_seq_no = p_pol_seq_no
                       AND b2501.renew_no   = p_renew_no
                       AND b2501.pol_flag   IN ('1','2','3','X')
                ) LOOP
                    v_endt_seq_no := i.endt_seq_no;
                    v_endt_flag := 1;
                END LOOP;
                
                IF v_endt_flag <> 1 THEN
                    v_endt_seq_no := 0;
                END IF;
            END IF;
                
        END IF;
		
		BEGIN
         SELECT NVL(a210.subline_time, 0)
           INTO v_subline_time
           FROM giis_subline a210
          WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
      END;
	   v_temp_incept_date :=
                  TRUNC (p_incept_date)
                + TO_NUMBER (v_subline_time) / 86400;	
      v_temp_expiry_date :=
                      TRUNC (p_expiry_date)
                      + TO_NUMBER (v_subline_time) / 86400;
      v_temp_endt_expiry_date :=
                 TRUNC (p_endt_expiry_date)
                 + TO_NUMBER (v_subline_time) / 86400;
      v_temp_issue_date :=
                       TRUNC (p_issue_date)
                       + (sysdate -  trunc(sysdate));
					   
					   
	if TRUNC(p_incept_date) = TRUNC(P_EFF_DATE) then
	  	
      v_temp_eff_date :=
                  TRUNC (P_EFF_DATE)
                + (TO_NUMBER (v_subline_time) + 60) / 86400;
		else 
				 v_temp_eff_date :=
                  TRUNC (P_EFF_DATE)
                + TO_NUMBER (v_subline_time) / 86400;		
			end if;	
        
           BEGIN
             SELECT NVL(a210.subline_time, 0)
               INTO v_subline_time
               FROM giis_subline a210
              WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
          END;
          
          v_temp_incept_date :=
                      TRUNC (p_incept_date)
                    + TO_NUMBER (v_subline_time) / 86400;    
          v_temp_expiry_date :=
                          TRUNC (p_expiry_date)
                          + TO_NUMBER (v_subline_time) / 86400;
          v_temp_endt_expiry_date :=
                     TRUNC (p_endt_expiry_date)
                     + TO_NUMBER (v_subline_time) / 86400;
          v_temp_issue_date :=
                           TRUNC (p_issue_date)
                           + (sysdate -  trunc(sysdate));
                           
                           
        if TRUNC(p_incept_date) = TRUNC(P_EFF_DATE) then
              
          v_temp_eff_date :=
                      TRUNC (P_EFF_DATE)
                    + (TO_NUMBER (v_subline_time) + 60) / 86400;
        else 
                     v_temp_eff_date :=
                      TRUNC (P_EFF_DATE)
                    + TO_NUMBER (v_subline_time) / 86400;        
        end if;    
        
        MERGE INTO gipi_wpolbas
        USING DUAL ON (par_id = p_par_id)
        WHEN NOT MATCHED THEN
                 INSERT (par_id, assd_no, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                         incept_date, expiry_date, eff_date, endt_expiry_date, issue_date, ref_pol_no,
                         type_cd, region_cd, address1, address2, address3, mortg_name, industry_cd, cred_branch,
                         booking_mth, booking_year, takeup_term, incept_tag, expiry_tag, endt_expiry_tag, reg_policy_sw,
                         foreign_acc_sw, invoice_sw, auto_renew_flag, prov_prem_tag, pack_pol_flag, co_insurance_sw, user_id,
                         pol_flag, quotation_printed_sw, covernote_printed_sw, endt_seq_no, same_polno_sw, ann_prem_amt, ann_tsi_amt,
                         bond_seq_no, cancel_type,
						 old_assd_no,old_address1,old_address2,old_address3, /*added by steven 8/31/2012*/
						 prorate_flag, comp_sw, short_rt_percent, bond_auto_prem) --added by robert GENQA SR 4825, 4828 08.27.15
                 VALUES (p_par_id, p_assd_no, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_endt_iss_cd, p_endt_yy,
                        /*p_incept_date*/v_temp_incept_date, /*p_expiry_date*/v_temp_expiry_date , /*p_eff_date*/v_temp_eff_date, /*p_endt_expiry_date*/v_temp_endt_expiry_date, v_temp_issue_date, p_ref_pol_no,
                         p_type_cd, p_region_cd, p_address1, p_address2, p_address3, p_mortg_name, p_industry_cd, p_cred_branch,
                         p_booking_mth, p_booking_year, p_takeup_term, p_incept_tag, p_expiry_tag, p_endt_expiry_tag, p_reg_policy_sw,
                         p_foreign_acc_sw, p_invoice_sw, p_auto_renew_flag, p_prov_prem_tag, p_pack_pol_flag, p_co_insurance_sw, p_user_id,
                         p_pol_flag, p_quotation_printed_sw, p_covernote, v_endt_seq_no, p_same_polno_sw, p_ann_prem_amt, p_ann_tsi_amt,
                         p_bond_seq_no, p_cancel_type,
						 p_old_assd_no,p_old_address1,p_old_address2,p_old_address3, /*)	/*added by steven 8/31/2012*/
						 p_prorate_flag, p_comp_sw, p_short_rt_percent, p_bond_auto_prem) --added by robert GENQA SR 4825, 4828 08.27.15
        WHEN MATCHED THEN
              UPDATE SET assd_no = p_assd_no,
                         line_cd = p_line_cd,
                         subline_cd = p_subline_cd,
                         iss_cd = p_iss_cd,
                         issue_yy = p_issue_yy,
                         pol_seq_no = p_pol_seq_no,
                         renew_no = p_renew_no,
                         endt_iss_cd = p_endt_iss_cd,
                         endt_yy = p_endt_yy,
                         incept_date = /*p_incept_date*/v_temp_incept_date,
                         expiry_date = /*p_expiry_date*/ v_temp_expiry_date,
                         eff_date = /*p_eff_date*/v_temp_eff_date,
                         endt_expiry_date = /*p_endt_expiry_date*/ v_temp_endt_expiry_date ,
                         issue_date = v_temp_issue_date,
                         ref_pol_no = p_ref_pol_no,
                         type_cd = p_type_cd,
                         region_cd = p_region_cd,
                         address1 = p_address1,
                         address2 = p_address2,
                         address3 = p_address3,
                         mortg_name = p_mortg_name,
                         industry_cd = p_industry_cd,
                         cred_branch = p_cred_branch,
                         booking_mth = p_booking_mth,
                         booking_year = p_booking_year,
                         takeup_term = p_takeup_term,
                         incept_tag = p_incept_tag,
                         expiry_tag = p_expiry_tag,
                         endt_expiry_tag = p_expiry_tag,
                         reg_policy_sw = p_reg_policy_sw,
                         foreign_acc_sw = p_foreign_acc_sw, 
                         invoice_sw = p_invoice_sw, 
                         auto_renew_flag = p_auto_renew_flag, 
                         prov_prem_tag = p_prov_prem_tag, 
                         pack_pol_flag = p_pack_pol_flag, 
                         co_insurance_sw = p_co_insurance_sw,
                         pol_flag = p_pol_flag,
                         same_polno_sw = p_same_polno_sw,
                         ann_prem_amt = p_ann_prem_amt,
                         ann_tsi_amt = p_ann_tsi_amt,
                         user_id = p_user_id,
                         bond_seq_no = p_bond_seq_no,
						 cancel_type = p_cancel_type,
						 old_assd_no = p_old_assd_no,		/*added by steven 8/31/2012*/
						 old_address1 = p_old_address1,
						 old_address2 = p_old_address2,
						 old_address3 = p_old_address3, --; --added columns below by robert GENQA SR 4825 08.03.15
						 prorate_flag = p_prorate_flag,
						 comp_sw = p_comp_sw,
						 bond_auto_prem = p_bond_auto_prem, --robert GENQA SR 4828 08.25.15
						 short_rt_percent = p_short_rt_percent; --end robert GENQA SR 4825 08.03.15
     END set_gipi_wpolbas_endt_bond;
     
        FUNCTION get_par_id_by_pol_flag(p_pol_flag              GIPI_WPOLBAS.pol_flag%TYPE,
                                     p_par_id              GIPI_WPOLBAS.par_id%TYPE)
       RETURN GIPI_WPOLBAS.par_id%TYPE
     IS
       v_par_id            GIPI_WPOLBAS.par_id%TYPE := NULL;
     BEGIN
       FOR a IN (SELECT par_id        
                          FROM gipi_wpolbas
                          WHERE pol_flag = '2'
                            AND par_id = p_par_id)
         LOOP
              v_par_id := a.par_id;
       END LOOP;
       
       RETURN v_par_id;
     END get_par_id_by_pol_flag;
     
    PROCEDURE get_covernote_details(p_par_id            IN   GIPI_WPOLBAS.par_id%TYPE,
                                    p_covernote_expiry  OUT  GIPI_WPOLBAS.covernote_expiry%TYPE,
                                    p_cn_date_printed   OUT  GIPI_WPOLBAS.cn_date_printed%TYPE,
                                    p_cn_no_of_days     OUT  GIPI_WPOLBAS.cn_no_of_days%TYPE ) IS

    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : August 10, 2011
    **  Reference By : Cover Note Printing
    **  Description  : Retrieves information from gipi_wpolbas table
    **                 with regards to Cover Note.
    */

        v_expiry        GIPI_WPOLBAS.covernote_expiry%TYPE;
        v_date_printed  GIPI_WPOLBAS.cn_date_printed%TYPE;
        v_no_of_days    GIPI_WPOLBAS.cn_no_of_days%TYPE;

    BEGIN
        FOR i IN (SELECT covernote_expiry, cn_date_printed, 
                         cn_no_of_days
                  FROM GIPI_WPOLBAS
                  WHERE par_id = p_par_id)
        LOOP
            v_expiry        := i.covernote_expiry;
            v_date_printed  := i.cn_date_printed;
            v_no_of_days    := i.cn_no_of_days;
        END LOOP;
        
        p_covernote_expiry  := v_expiry;
        p_cn_date_printed   := v_date_printed;
        p_cn_no_of_days     := v_no_of_days;
        
    END;

    PROCEDURE update_covernote_details(p_par_id   IN   GIPI_WPOLBAS.par_id%TYPE,
                                       p_days     IN   NUMBER) IS

    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : August 10, 2011
    **  Reference By : Cover Note Printing
    **  Description  : Updates cover note details on gipi_wpolbas table.
    **                 
    */

        v_total_days    GIPI_WPOLBAS.covernote_expiry%TYPE;
        v_sysdate       GIPI_WPOLBAS.cn_date_printed%TYPE;

    BEGIN
        
        SELECT SYSDATE
        INTO v_sysdate
        FROM dual;
           
        v_total_days := v_sysdate + p_days;
         
        UPDATE GIPI_WPOLBAS
        SET covernote_expiry = v_total_days,
            cn_date_printed  = v_sysdate,
            cn_no_of_days    = p_days
        WHERE par_id = p_par_id;
        
    END;


    PROCEDURE update_covernote_printed_sw(p_par_id   IN   GIPI_WPOLBAS.par_id%TYPE)

    IS

    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : August 10, 2011
    **  Reference By : Cover Note Printing
    **  Description  : Updates covernote_printed_sw column on 
    **                 gipi_wpolbas table for the given par_id.
    */

    BEGIN
         
        UPDATE GIPI_WPOLBAS
        SET covernote_printed_sw = 'Y'
        WHERE par_id = p_par_id;
        
    END;  
    
/**
* Rey Jadlocon
* 11-08-2011
* change par status to 2 when assured is changed
**/
Procedure change_par_status(p_par_id            gipi_parlist.par_id%TYPE,
                            p_assd_no           gipi_parlist.assd_no%TYPE)
                IS
                  v_assd_exist  gipi_parlist.assd_no%TYPE;
   BEGIN
                    SELECT assd_no
                      INTO v_assd_exist
                      FROM gipi_parlist
                     WHERE par_id = p_par_id;
             
                IF NVL(v_assd_exist,p_assd_no) <> p_assd_no THEN 
                
                    UPDATE gipi_parlist
                       SET par_status = 2
                     WHERE par_id = p_par_id;
                        
                     DELETE FROM gipi_wbond_basic
                      WHERE par_id = p_par_id;
                      
                     DELETE FROM gipi_wcosigntry
                      WHERE par_id = p_par_id;
               END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
         NULL;
   END;

/**
* Rey Jadlocon
* 11-09-2011
* check booking date
**/
--   FUNCTION validate_booking_date2(p_booking_date_polbas          VARCHAR2,
--                                    p_incept_date                  VARCHAR2,
--                                    p_multi_booking_mm             VARCHAR2,
--                                    p_multi_booking_yy             NUMBER,
--                                    p_par_id                       NUMBER,     
--                                    p_due_date                     VARCHAR2,
--                                    p_takeup_seq_no                varchar2) 
--             RETURN VARCHAR2  
PROCEDURE validate_booking_date2(p_booking_mm_polbas           VARCHAR2, 
                                 p_booking_yy_polbas           VARCHAR2, 
                                 p_incept_date                 VARCHAR2,
                                 p_booking_mm                  VARCHAR2, 
                                 p_booking_yy                  VARCHAR2, 
                                 p_par_id                      NUMBER,     
                                 p_due_date                    VARCHAR2,
                                 p_takeup_seq_no                varchar2)                                   
           IS
                v_message               VARCHAR2(500);
                v_check                 NUMBER;
                v_date1                 VARCHAR2(50);
                v_date2                 VARCHAR2(50);
                v_date3                 VARCHAR2(50);
                v_date4                 VARCHAR2(50);
                v_date5                 VARCHAR2(50);
                v_due_date              VARCHAR2(50);
                v_due_date2             VARCHAR2(50);
                v_incept_date           VARCHAR2(50);
                v_param_val             VARCHAR2(50);
                v_temp_year             NUMBER;
                v_temp_month            VARCHAR2(50);
                v_multi_booking_yy      VARCHAR2(50);
                v_multi_booking_mm      VARCHAR2(50); 
                v_booking_yy            VARCHAR2(50);
                v_booking_mm            VARCHAR2(50);     
    BEGIN
      -- BEGIN
      FOR i IN
         (SELECT   a.booking_year, a.booking_mth, a.booked_tag,
                   TO_CHAR (TO_DATE (   '01-'
                                     || SUBSTR (a.booking_mth, 1, 3)
                                     || a.booking_year
                                    ),
                            'MM'
                           ) booking_mth_yr
              FROM giis_booking_month a, giis_parameters b
             WHERE (a.booking_year >=
                       TO_NUMBER (TO_CHAR (TO_DATE (p_incept_date,
                                                    'MM-DD-RRRR'
                                                   ),
                                           'YYYY'
                                          )
                                 )
                   )
               AND (    NVL (a.booked_tag, 'N') <> 'Y'
                    AND (TO_NUMBER
                                  (TO_CHAR (TO_DATE (   '01-'
                                                     || SUBSTR (a.booking_mth,
                                                                1,
                                                                3
                                                               )
                                                     || a.booking_year
                                                    ),
                                            'MM'
                                           )
                                  ) >=
                            TO_NUMBER
                               (TO_CHAR
                                   (DECODE (b.param_value_v,
                                            'N', TO_DATE (p_incept_date,
                                                          'MM-DD-RRRR'
                                                         ),
                                            TO_DATE (   '01-'
                                                     || SUBSTR (a.booking_mth,
                                                                1,
                                                                3
                                                               )
                                                     || a.booking_year
                                                    )
                                           ),
                                    'MM'
                                   )
                               )
                        )
                   )
               AND b.param_name = 'ALLOW_BOOKING_IN_ADVANCE'
               --AND (p_booking_date_polbas <= TO_CHAR(a.booking_year||' - '||(a.booking_mth)))
               AND (TO_DATE (   '01-'
                             || SUBSTR (p_booking_mm_polbas, 1, 3)
                             || p_booking_yy_polbas
                            ) <=
                       TO_DATE (   '01-'
                                || SUBSTR (a.booking_mth, 1, 3)
                                || a.booking_year
                               )
                   )
          GROUP BY a.booking_year,
                   a.booking_mth,
                   a.booked_tag,
                   TO_CHAR (TO_DATE (   '01-'
                                     || SUBSTR (a.booking_mth, 1, 3)
                                     || a.booking_year
                                    ),
                            'MM'
                           )
          ORDER BY 1, 4)
      LOOP
         v_temp_year := i.booking_year;
         v_temp_month := i.booking_mth;
      END LOOP;

      --v_multi_booking_mm      := UPPER(p_multi_booking_mm);
      --IF(p_multi_booking_yy IS NOT NULL AND v_multi_booking_mm IS NOT NULL) THEN
      IF (p_booking_yy IS NOT NULL AND p_booking_mm IS NOT NULL)
      THEN
         SELECT 1
           INTO v_check
           FROM giis_booking_month
          WHERE NVL (booked_tag, 'N') <> 'Y'
            AND booking_year = p_booking_yy
            AND booking_mth = UPPER (p_booking_mm);

         --AND booking_mth  = UPPER(v_multi_booking_mm);
         BEGIN
            SELECT a.incept_date,
                   a.booking_mth || ' 01, ' || a.booking_year,
                   p_booking_mm || ' 01, ' || p_booking_yy, a.expiry_date,
                   NVL (b.due_date, a.incept_date), c.param_value_v
              INTO v_date1,
                   v_date2,
                   v_date3, v_date4,
                   v_due_date, v_param_val
              FROM gipi_wpolbas a, gipi_winvoice b, giis_parameters c
             WHERE a.par_id = b.par_id
               AND a.par_id = p_par_id
               AND c.param_name = 'ALLOW_BOOKING_IN_ADVANCE'
               AND b.takeup_seq_no = p_takeup_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;  -- irwin 8.24.2012
         END;

         IF p_due_date IS NULL
         THEN
            v_due_date2 := TO_DATE (v_due_date, 'DD-MON-YY');
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Invalid Due Date.'
                                    );
         --v_message   := 'Invalid Due Date';
         END IF;

         v_incept_date := TO_CHAR (TO_DATE (v_date1, 'DD-MON-YY'), 'MM-DD-YY');
         v_date1 :=
               TO_CHAR (TO_DATE (v_date1), 'MM')
            || '-01-'
            || TO_CHAR (TO_DATE (v_date1), 'YY');
         v_date4 := TO_CHAR (TO_DATE (v_date4, 'DD-MON-YY'), 'MM-DD-YY');
         v_date5 := TO_CHAR (TO_DATE (p_due_date, 'MM-DD-YYYY'), 'MM-DD-YY');
         v_date2 := TO_CHAR (TO_DATE (v_date2, 'MONTH DD, YYYY'), 'MM-DD-YY');
         v_date3 := TO_CHAR (TO_DATE (v_date3, 'MONTH DD, YYYY'), 'MM-DD-YY');

         IF     v_param_val = 'N'
            AND (TO_DATE (v_date3, 'MM-DD-YY') < TO_DATE (v_date1, 'MM-DD_YY')
                )
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Booking month schedule must not be earlier than the inception date of the policy.'
               );
         --v_message   := 'Booking month schedule must not be earlier than the inception date of the policy.';
         ELSIF TO_DATE (v_date2, 'MM-DD-YY') > TO_DATE (v_date4, 'MM-DD-YY')
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Booking date schedule must not be later than the expiry date of the policy.'
               );
         --v_message   := 'Booking date schedule must not be later than the expiry date of the policy.';
         ELSIF TO_DATE (v_date3, 'MM-DD-YY') > TO_DATE (v_date5, 'MM-DD-YY')
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Booking date schedule must be in proper sequence.'
               );
         --v_message   := 'Booking date schedule must be in proper sequence.';
         ELSIF     v_param_val = 'N'
               AND (TO_DATE (v_date5, 'MM-DD-YY') <
                                           TO_DATE (v_incept_date, 'MM-DD-YY')
                   )
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Due date schedule must not be earlier than the inception date of the policy.'
               );
            --v_message   := 'Due date schedule must not be earlier than the inception date of the policy.'
            v_due_date2 := TO_DATE (v_due_date, 'DD-MON-YY');
         ELSIF TO_DATE (v_date5, 'MM-DD-YY') > TO_DATE (v_date4, 'MM-DD-YY')
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Due date schedule must not be earlier than the expiry date of the policy.'
               );
            --v_message   := 'Due date schedule must not be earlier than the expiry date of the policy.'
            v_due_date2 := TO_DATE (v_due_date, 'DD-MON-YY');
         ELSIF (TO_DATE (v_date3, 'MM-DD-YY') < TO_DATE (v_date2, 'MM-DD-YY'))
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Booking date schedule must not be earlier than that of Bond Basic Info.'
               );
         --v_message   := 'Booking date schedule must not be earlier than that of Bond Basic Info.';
         END IF;
      ELSE
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Invalid Booking Date.Try to use the LOV for the list of valid Booking Date.'
            );
      --v_message   := 'Invalid Booking Date.'||chr(10)||'Try to use the LOV for the list of valid Booking Date.';
      END IF;

      IF v_message IS NOT NULL
      THEN
         SELECT NVL (multi_booking_mm, v_temp_month),
                NVL (multi_booking_yy, v_temp_year)
           INTO v_multi_booking_mm,
                v_multi_booking_yy
           FROM gipi_winvoice
          WHERE par_id = p_par_id AND takeup_seq_no = p_takeup_seq_no;
      END IF;
      
      --- commented out. This triggers even when the bill premiums is just being created and can be handled by the other condition above. -- irwin 8.24.2012
   /* EXCEPTION  
        WHEN NO_DATA_FOUND THEN
                SELECT NVL(multi_booking_mm,v_temp_year),NVL(multi_booking_yy,v_temp_year)
                  INTO v_booking_mm,v_booking_yy
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id and  takeup_seq_no = p_takeup_seq_no;
                 RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid Booking Date.Try to use the LOV for the list of valid Booking Date.');*/-- v_message  := 'Invalid Booking Date.'||chr(10)||'Try to use the LOV for the list of valid Booking Date.';
    --END;
    --RETURN v_message;
   END;
  
/**
* Rey Jadlocon
* 11-14-2011
* incept date
**/
FUNCTION set_incept_date(p_par_id       gipi_wpolbas.par_id%TYPE)
        RETURN incept_date_tab PIPELINED
        IS
            v_incept_date incept_date_type;
        BEGIN 
            FOR i IN (SELECT a.incept_date, TO_DATE(a.booking_mth||'-01-'||a.booking_year,'MONTH-DD-YYYY')
                        FROM gipi_wpolbas a, gipi_winvoice b
                       WHERE a.par_id = b.par_id
                         AND a.par_id = p_par_id)
            LOOP
                v_incept_date.incept_date   := i.incept_date;
                PIPE ROW(v_incept_date);
            END LOOP;
           
                  
        END;
        
    /* Created by: Joanne
    ** Date: 10.09.13
    **Description: Check for replacements and/or renewals and compare it with the current policy.
    ** Returns 'the policy no. if there is a newer renewal or replacement and disallow cancel.
    */
    FUNCTION check_policy_renewal (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
    )
      RETURN gipi_polbasic.policy_id%TYPE
    IS
      v_currpolid   gipi_polbasic.policy_id%TYPE   := 0;
      v_oldpolid1   NUMBER;
      v_oldpolid2   NUMBER;
      v_lastpolid   NUMBER;
      v_count1      NUMBER;
      v_count2      NUMBER;
      v_count3      NUMBER;
      exit_main     CHAR (1) := 'N';

       CURSOR c1 (p_oldpolid1 NUMBER) IS
          SELECT new_policy_id
            FROM gipi_polnrep
           WHERE old_policy_id = p_oldpolid1;

       CURSOR c2 (p_oldpolid2 NUMBER) IS
          SELECT MAX (new_policy_id)
            FROM gipi_polnrep
           WHERE old_policy_id = p_oldpolid2;

       CURSOR c3 (p_newpolid3 NUMBER) IS
          SELECT old_policy_id
            FROM gipi_polnrep
           WHERE new_policy_id = p_newpolid3;
    BEGIN
      FOR a1 IN (SELECT a.policy_id
                   FROM gipi_polbasic a
                  WHERE a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no)
      LOOP
        v_currpolid := a1.policy_id;
        
         BEGIN
              SELECT old_policy_id
                INTO v_oldpolid1
                FROM gipi_polnrep
               WHERE new_policy_id = v_currpolid;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 v_oldpolid1 := v_currpolid;
           END;

           LOOP -- main LOOP 1
              FOR x IN c1 (v_oldpolid1)
              LOOP
                 SELECT COUNT (*)
                   INTO v_count1
                   FROM gipi_polnrep
                  WHERE old_policy_id = x.new_policy_id;

                 IF v_count1 > 0
                 THEN
                    OPEN c2 (x.new_policy_id);
                    FETCH c2 INTO v_oldpolid1;
                    CLOSE c2;

                    IF NVL (v_lastpolid, 0) < NVL (v_oldpolid1, x.new_policy_id)
                    THEN
                       v_lastpolid := NVL (v_oldpolid1, x.new_policy_id);
                    END IF;

                    EXIT;
                 ELSE
                    v_lastpolid := x.new_policy_id;
                    exit_main := 'Y';
                 END IF;
              END LOOP; --FOR x LOOP

              SELECT COUNT (*)
                INTO v_count2
                FROM gipi_polnrep
               WHERE old_policy_id = v_oldpolid1;

              IF exit_main = 'Y' OR v_count2 = 0
              THEN
                 EXIT;
              END IF;
           END LOOP; -- main LOOP 1

           LOOP -- LOOP 2
              SELECT COUNT (*)
                INTO v_count3
                FROM gipi_polbasic
               WHERE policy_id = v_lastpolid AND pol_flag IN ('1', '2', '3');

              IF v_count3 < 1 AND v_lastpolid IS NOT NULL
              THEN
                 OPEN c3 (v_lastpolid);
                 FETCH c3 INTO v_lastpolid;
                 CLOSE c3;
              ELSE
                 EXIT;
              END IF;
           END LOOP; -- LOOP 2
      END LOOP;

      IF NVL (v_lastpolid, 0) > v_currpolid THEN
         v_currpolid := v_currpolid;
      ELSE
         v_currpolid := 0;
      END IF; 

      RETURN v_currpolid;
    END check_policy_renewal;
    
    
    /* Created by: Joanne
    ** Date: 10.09.13
    **Description: Check for replacements and/or renewals and compare it with the current package policy.
    ** Returns 'the policy no. if there is a newer renewal or replacement and disallow cancel.
    */
    FUNCTION check_pack_policy_renewal (
      p_line_cd      IN   gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_pack_polbasic.renew_no%TYPE
    )
      RETURN gipi_pack_polbasic.pack_policy_id%TYPE
    IS
      v_currpolid   gipi_pack_polbasic.pack_policy_id%TYPE   := 0;
      v_oldpolid1   NUMBER;
      v_oldpolid2   NUMBER;
      v_lastpolid   NUMBER;
      v_count1      NUMBER;
      v_count2      NUMBER;
      v_count3      NUMBER;
      exit_main     CHAR (1) := 'N';

       CURSOR c1 (p_oldpolid1 NUMBER) IS
          SELECT new_pack_policy_id
            FROM gipi_pack_polnrep
           WHERE old_pack_policy_id = p_oldpolid1;

       CURSOR c2 (p_oldpolid2 NUMBER) IS
          SELECT MAX (new_pack_policy_id)
            FROM gipi_pack_polnrep
           WHERE old_pack_policy_id = p_oldpolid2;

       CURSOR c3 (p_newpolid3 NUMBER) IS
          SELECT old_pack_policy_id
            FROM gipi_pack_polnrep
           WHERE new_pack_policy_id = p_newpolid3;
    BEGIN
      FOR a1 IN (SELECT a.pack_policy_id
                   FROM gipi_pack_polbasic a
                  WHERE a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no)
      LOOP
        v_currpolid := a1.pack_policy_id;
        
         BEGIN
              SELECT old_pack_policy_id
                INTO v_oldpolid1
                FROM gipi_pack_polnrep
               WHERE new_pack_policy_id = v_currpolid;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 v_oldpolid1 := v_currpolid;
           END;

           LOOP -- main LOOP 1
              FOR x IN c1 (v_oldpolid1)
              LOOP
                 SELECT COUNT (*)
                   INTO v_count1
                   FROM gipi_pack_polnrep
                  WHERE old_pack_policy_id = x.new_pack_policy_id;

                 IF v_count1 > 0
                 THEN
                    OPEN c2 (x.new_pack_policy_id);
                    FETCH c2 INTO v_oldpolid1;
                    CLOSE c2;

                    IF NVL (v_lastpolid, 0) < NVL (v_oldpolid1, x.new_pack_policy_id)
                    THEN
                       v_lastpolid := NVL (v_oldpolid1, x.new_pack_policy_id);
                    END IF;

                    EXIT;
                 ELSE
                    v_lastpolid := x.new_pack_policy_id;
                    exit_main := 'Y';
                 END IF;
              END LOOP; --FOR x LOOP

              SELECT COUNT (*)
                INTO v_count2
                FROM gipi_pack_polnrep
               WHERE old_pack_policy_id = v_oldpolid1;

              IF exit_main = 'Y' OR v_count2 = 0
              THEN
                 EXIT;
              END IF;
           END LOOP; -- main LOOP 1

           LOOP -- LOOP 2
              SELECT COUNT (*)
                INTO v_count3
                FROM gipi_pack_polbasic
               WHERE pack_policy_id = v_lastpolid AND pol_flag IN ('1', '2', '3');

              IF v_count3 < 1 AND v_lastpolid IS NOT NULL
              THEN
                 OPEN c3 (v_lastpolid);
                 FETCH c3 INTO v_lastpolid;
                 CLOSE c3;
              ELSE
                 EXIT;
              END IF;
           END LOOP; -- LOOP 2
      END LOOP;

      IF NVL (v_lastpolid, 0) > v_currpolid THEN
         v_currpolid := v_currpolid;
      ELSE
         v_currpolid := 0;
      END IF; 

      RETURN v_currpolid;
    END check_pack_policy_renewal;
        
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    12.19.2011    mark jm            update discount_sw in gipi_wpolbas based on given parameters
    */
    PROCEDURE update_discount_sw (
        p_par_id IN gipi_wpolbas.par_id%TYPE,
        p_discount_sw IN gipi_wpolbas.discount_sw%TYPE)
    IS
    BEGIN
        UPDATE gipi_wpolbas
           SET discount_sw = p_discount_sw
         WHERE par_id = p_par_id;
    END update_discount_sw;
    
    /*    Date          Author             Description
    **    ==========    ===============    ============================
    **    02.08.2011    andrew robes       update the surcharge_sw depending of the gipi_wpolbas record based on par_id
    */
    PROCEDURE update_surcharge_sw (
        p_par_id IN gipi_wpolbas.par_id%TYPE,
        p_surcharge_sw IN gipi_wpolbas.surcharge_sw%TYPE)
    IS
    BEGIN
        UPDATE gipi_wpolbas
           SET surcharge_sw = p_surcharge_sw
         WHERE par_id = p_par_id;
    END update_surcharge_sw;
	
	PROCEDURE update_gipis165 (
		p_par_id 		  IN gipi_wpolbas.par_id%TYPE,
		p_dsp_bond_seq_no IN gipi_wpolbas.bond_seq_no%TYPE
	) IS
		v_bond_seq_no gipi_wpolbas.bond_seq_no%TYPE;
		v_update BOOLEAN := FALSE;
	BEGIN
		--select value of bond_seq_no in gipi_wpolbas
		FOR i IN (SELECT bond_seq_no
					FROM gipi_wpolbas
				   WHERE par_id = p_par_id)
		LOOP
			v_bond_seq_no := i.bond_seq_no;
			EXIT;
		END LOOP;
	
		--allow update if SHOW_BOND_SEQ_NO parameter is N but bond_seq_no is not null.
		IF NVL(giisp.v('SHOW_BOND_SEQ_NO'),'N') = 'N' AND v_bond_seq_no IS NOT NULL THEN
			v_update := TRUE;
		--allow update if SHOW_BOND_SEQ_NO parameter is Y but bond_seq_no is null.
		ELSIF NVL(giisp.v('SHOW_BOND_SEQ_NO'),'N') = 'Y' AND v_bond_seq_no IS NULL THEN
			v_update := TRUE;
		END IF; 
		
		IF v_update THEN
			UPDATE gipi_wpolbas
			   SET bond_seq_no = p_dsp_bond_seq_no
		 	 WHERE par_id = p_par_id;
		END IF;
	END update_gipis165;

   PROCEDURE set_default_cred_branch (p_par_id gipi_wpolbas.par_id%TYPE)
   IS
      v_assd_no giis_assured.assd_no%TYPE;
      v_line_cd giis_line.line_cd%TYPE;
      v_iss_cd giis_issource.iss_cd%TYPE;
      v_bancassurance_sw gipi_wpolbas.bancassurance_sw%TYPE;
   BEGIN
   
      IF giisp.v('DEFAULT_CRED_BRANCH') <> 'AGENT' THEN
         RETURN;
      END IF;
      
      SELECT assd_no, line_cd, bancassurance_sw
        INTO v_assd_no, v_line_cd, v_bancassurance_sw
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;
      
      IF v_bancassurance_sw = 'Y' THEN
         
         FOR i IN (SELECT intrmdry_intm_no
                     FROM gipi_wcomm_invoices
                   WHERE par_id = p_par_id
                ORDER BY share_percentage DESC, intrmdry_intm_no          
         )
         LOOP
            UPDATE gipi_wpolbas
               SET cred_branch = (SELECT iss_cd
                                    FROM giis_intermediary
                                   WHERE intm_no = i.intrmdry_intm_no)
             WHERE par_id = p_par_id;
            EXIT;
         END LOOP;
         
      ELSE
      
         BEGIN
            SELECT a.iss_cd
              INTO v_iss_cd
              FROM giis_intermediary a, giis_assured_intm b
             WHERE a.intm_no = b.intm_no
               AND b.assd_no = v_assd_no
               AND b.line_cd = v_line_cd;            
               
            UPDATE gipi_wpolbas
               SET cred_branch = v_iss_cd
             WHERE par_id = p_par_id;       
               
         EXCEPTION WHEN NO_DATA_FOUND THEN
            NULL;         
         END;
         
      END IF;
      
   END set_default_cred_branch;
   
   FUNCTION validate_pol_no (
      p_par_id       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_message VARCHAR2(200);
      v_user_id giis_users.user_id%TYPE;
   BEGIN
      BEGIN
         SELECT user_id
           INTO v_user_id
           FROM GIPI_WPOLBAS a, GIPI_PARLIST b
          WHERE a.line_cd = p_line_cd
            AND a.subline_cd = p_subline_cd
            AND a.iss_cd = p_iss_cd
            AND a.issue_yy = p_issue_yy
            AND a.pol_seq_no = p_pol_seq_no
            AND a.renew_no = p_renew_no
            AND a.par_id = b.par_id
            AND b.par_status NOT IN ('98','99')
            AND a.par_id <> p_par_id;
            
         v_message := 'Policy is currently being endorsed by ' || v_user_id || ', cannot endorse the same policy at the same time.';      
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_message := 'Y';      
      END;
      
      RETURN v_message;
   END validate_pol_no;       
  
END Gipi_Wpolbas_Pkg;
/


