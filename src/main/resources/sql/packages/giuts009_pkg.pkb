CREATE OR REPLACE PACKAGE BODY CPI.GIUTS009_PKG AS

    PROCEDURE populate_summary (
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no             IN  GIPI_POLBASIC.renew_no%TYPE,
        p_par_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_spld_pol_sw        IN  VARCHAR2,
        p_spld_endt_sw        IN  VARCHAR2,
        p_cancel_sw            IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
        p_par_id            OUT GIPI_POLBASIC.par_id%TYPE
    ) IS 
        v_line_cd1                 gipi_wpolbas.line_cd%TYPE;
        v_iss_cd1                  gipi_wpolbas.iss_cd%TYPE;
        v_eff_date                 gipi_wpolbas.eff_date%TYPE;
        v_incept_date              gipi_wpolbas.incept_date%TYPE;
        v_expiry_date              gipi_wpolbas.expiry_date%TYPE;
        v_assd_no                  gipi_wpolbas.assd_no%TYPE;
        v_acct_of_cd               gipi_wpolbas.acct_of_cd%TYPE;
        v_tsi_amt                  gipi_wpolbas.tsi_amt%TYPE;
        v_prem_amt                 gipi_wpolbas.prem_amt%TYPE;
        v_pol_flag                 gipi_wpolbas.pol_flag%TYPE;
        v_issue_date               gipi_wpolbas.issue_date%TYPE; 
        v_endt_type                gipi_wpolbas.endt_type%TYPE;
        v_type_cd                  gipi_wpolbas.type_cd%TYPE; 
        v_designation              gipi_wpolbas.designation%TYPE;
        v_mortg_name               gipi_wpolbas.mortg_name%TYPE;
        v_address1                 gipi_wpolbas.address1%TYPE;
        v_address2                 gipi_wpolbas.address2%TYPE; 
        v_address3                 gipi_wpolbas.address3%TYPE;  
        v_pool_pol_no              gipi_wpolbas.pool_pol_no%TYPE;
        v_no_of_items              gipi_wpolbas.no_of_items%TYPE;
        v_prov_prem_pct            gipi_wpolbas.prov_prem_pct%TYPE;
        v_subline_type_cd          gipi_wpolbas.subline_type_cd%TYPE;
        v_short_rt_percent         gipi_wpolbas.short_rt_percent%TYPE;
        v_auto_renew_flag          gipi_wpolbas.auto_renew_flag%TYPE;
        v_prorate_flag             gipi_wpolbas.prorate_flag%TYPE; 
        v_renew_flag               gipi_wpolbas.auto_renew_flag%TYPE; 
        v_pack_pol_flag            gipi_wpolbas.pack_pol_flag%TYPE;
        v_prov_prem_tag            gipi_wpolbas.prov_prem_tag%TYPE;
        v_expiry_tag               gipi_wpolbas.expiry_tag%TYPE; 
        v_govt_acc_sw              gipi_wpolbas.foreign_acc_sw%TYPE;
        v_invoice_sw               gipi_wpolbas.invoice_sw%TYPE;
        v_discount_sw              gipi_wpolbas.discount_sw%TYPE;
        v_subline_cd               gipi_wpolbas.subline_cd%TYPE;
        v_ref_pol_no               gipi_wpolbas.ref_pol_no%TYPE;
        v_prem_warr_tag            gipi_wpolbas.prem_warr_tag%TYPE;
        v_seq                      NUMBER; 
        v_co_insurance_sw          gipi_wpolbas.co_insurance_sw%TYPE;
        v_reg_policy_sw            gipi_wpolbas.reg_policy_sw%TYPE;
        v_line                     gipi_wpolbas.line_cd%TYPE;
        v_iss_cd                   gipi_wpolbas.iss_cd%TYPE;

        --BETH 120199
        v_incept_tag               gipi_wpolbas.incept_tag%TYPE;
        v_print_fleet_tag          gipi_wpolbas.fleet_print_tag%TYPE;
        v_endt_expiry_tag          gipi_wpolbas.endt_expiry_tag%TYPE;
        v_manual_renew_no          gipi_wpolbas.manual_renew_no%TYPE;
        v_with_tariff_sw           gipi_wpolbas.with_tariff_sw%TYPE;

        v_inv_sw                   VARCHAR2(1) := 'N';  

        v_place_cd                 gipi_wpolbas.place_cd%TYPE;
        v_subline_time             NUMBER;
        v_policy_id                gipi_polbasic.policy_id%TYPE;
        v_industry_cd                             gipi_wpolbas.industry_cd%TYPE;    
        v_region_cd                               gipi_wpolbas.region_cd%TYPE;    
        v_cred_branch                             gipi_wpolbas.cred_branch%TYPE;    

        --added by iRiS B.
        v_booking_mth              gipi_wpolbas.booking_mth%TYPE;
        v_booking_year             gipi_wpolbas.booking_year%TYPE;
        var_vdate                                     giis_parameters.param_value_n%TYPE;

        -- longterm --
        v_takeup_term                    gipi_polbasic.takeup_term%TYPE;
        
        v_pol_count                  NUMBER(10) := 0;
        v_var_policy_id                gipi_polbasic.policy_id%TYPE;    --:parameter.policy_id 
        v_var_iss_cd                gipi_polbasic.iss_cd%TYPE;  --:parameter.iss_cd
        
        rg_policy_id                gipi_polbasic.policy_id%TYPE;
        v_par_id                    gipi_parlist.par_id%TYPE;  -- :copy.par_id => copy_par_id
    BEGIN
    
        policy_line_cd              := p_line_cd;
        policy_subline_cd           := p_subline_cd;
        policy_iss_cd               := p_iss_cd;
        policy_issue_yy             := p_issue_yy;
        policy_pol_seq_no           := p_pol_seq_no;
        policy_renew_no             := p_renew_no;
        par_iss_cd                    := p_par_iss_cd;      
        
        GIUTS009_PKG.initialize_line_cd(
            var_line_FI, var_line_MC, var_line_AC, var_line_MH, var_line_MN,
            var_line_CA, var_line_EN, var_line_SU, var_line_AV        
        );
    
        SELECT COUNT(*) INTO v_pol_count
          FROM TABLE(GIUTS009_PKG.get_policy_group(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, 
                        p_renew_no, p_spld_pol_sw, p_spld_endt_sw, p_cancel_sw, p_expired_sw));
                        
        IF v_pol_count = 0 THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There are no records found for the option you have chosen.');
        END IF;
        
        FOR i IN (
            SELECT * 
              FROM TABLE(GIUTS009_PKG.get_policy_group(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, 
                        p_renew_no, p_spld_pol_sw, p_spld_endt_sw, p_cancel_sw, p_expired_sw))
        ) LOOP
            IF NVL(i.endt_seq_no ,0) = 0 THEN
                rg_policy_id := i.policy_id;
                EXIT;
            END IF; 
        END LOOP;
        
        FOR B IN (SELECT subline_time
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd) 
        LOOP
            v_subline_time := to_number(b.subline_time);
            EXIT;
        END LOOP; 

        FOR pol IN (
            SELECT     line_cd,         subline_cd,   iss_cd,        issue_yy,      pol_seq_no,                     
                    assd_no,         type_cd,      acct_of_cd,    designation ,  decode(p_par_iss_cd,p_iss_cd,mortg_name,null) mortg_name,
                    address1,        address2,     address3,      pool_pol_no,   subline_type_cd,
                    auto_renew_flag, renew_flag,   pack_pol_flag, prov_prem_tag, expiry_tag,
                    foreign_acc_sw,  invoice_sw,   ref_pol_no,    prem_warr_tag, co_insurance_sw,
                    reg_policy_sw,   incept_tag,   fleet_print_tag,
                    endt_expiry_tag, manual_renew_no, with_tariff_sw, place_cd, industry_cd,
                    region_cd,          cred_branch,  takeup_term,   policy_id
             FROM gipi_polbasic
            WHERE policy_id = rg_policy_id
        ) LOOP  --x
            v_line_cd1            :=    pol.line_cd;
            v_iss_cd1             :=    pol.iss_cd;
            v_var_policy_id       :=    rg_policy_id;
            v_subline_cd         :=    pol.subline_cd;
            v_eff_date           :=    TRUNC(SYSDATE) + (nvl(v_subline_time,0)/86400);           
            v_incept_date        :=    TRUNC(SYSDATE) + (nvl(v_subline_time,0)/86400);           
            v_expiry_date        :=    add_months(v_incept_date,12);        
            v_assd_no            :=    pol.assd_no;            
            v_type_cd            :=    pol.type_cd;            
            v_acct_of_cd         :=    pol.acct_of_cd;         
            v_designation        :=    pol.designation;        
            v_mortg_name         :=    pol.mortg_name;         
            v_address1           :=    pol.address1;           
            v_address2           :=    pol.address2;          
            v_address3           :=    pol.address3;           
            v_pool_pol_no        :=    pol.pool_pol_no;        
            v_subline_type_cd    :=    pol.subline_type_cd;    
            v_auto_renew_flag    :=    pol.auto_renew_flag;    
            v_renew_flag         :=    pol.renew_flag;         
            v_pack_pol_flag      :=    pol.pack_pol_flag;      
            v_expiry_tag         :=    pol.expiry_tag;          
            v_govt_acc_sw        :=    pol.foreign_acc_sw;       
            v_invoice_sw         :=    pol.invoice_sw;        
            v_prem_warr_tag      :=    pol.prem_warr_tag;                     
            v_co_insurance_sw    :=    pol.co_insurance_sw;                     
            v_reg_policy_sw      :=    pol.reg_policy_sw;                     
            v_line               :=    pol.line_cd;                     
            v_var_iss_cd         :=    pol.iss_cd;
            v_incept_tag         :=    pol.incept_tag;
            v_print_fleet_tag    :=    pol.fleet_print_tag;
            v_endt_expiry_tag    :=    pol.endt_expiry_tag;
            v_manual_renew_no    :=    pol.manual_renew_no;
            v_with_tariff_sw     :=    pol.with_tariff_sw;
            v_place_cd           :=    pol.place_cd;
            v_industry_cd        :=    pol.industry_cd;
            v_region_cd           :=    pol.region_cd;
            v_cred_branch         :=    pol.cred_branch;
            -- longterm --
            v_takeup_term         :=    pol.takeup_term;        

            FOR i IN ( 
                SELECT * 
                  FROM TABLE(GIUTS009_PKG.get_policy_group(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, 
                            p_renew_no, p_spld_pol_sw, p_spld_endt_sw, p_cancel_sw, p_expired_sw))
            ) LOOP  --y
                IF NVL(i.endt_seq_no, 0) > 0 THEN
                    IF NVL(p_spld_endt_sw ,'N') = 'N' AND
                        NVL(i.pol_flag, 1) = '5' THEN                               -- jhing 10.10.2015 GENQA  5033 modified from 5 into '5' 
                        NULL;
                    ELSIF NVL(p_cancel_sw ,'N') = 'N' AND
                        NVL(i.pol_flag, 1) = '4' THEN                               -- jhing 10.10.2015 GENQA  5033 modified from 4 into '4' 
                        NULL;      
                    ELSE
                        FOR endt IN ( 
                            SELECT     assd_no,         type_cd,      acct_of_cd,    designation ,  decode(p_par_iss_cd,p_iss_cd,mortg_name,null) mortg_name,
                                    address1,        address2,     address3,      pool_pol_no,   subline_type_cd,
                                    auto_renew_flag, renew_flag,   pack_pol_flag, prov_prem_tag, expiry_tag,
                                    foreign_acc_sw,  invoice_sw,   ref_pol_no,    prem_warr_tag, co_insurance_sw,
                                    reg_policy_sw,   incept_tag,   fleet_print_tag,
                                    endt_expiry_tag, manual_renew_no, with_tariff_sw, place_cd,
                                    industry_cd,         region_cd,    cred_branch, takeup_term, policy_id
                              FROM  gipi_polbasic
                             WHERE  policy_id = i.policy_id
                        ) LOOP         --z
                            v_subline_cd         :=    NVL(pol.subline_cd,v_subline_cd);
                            IF endt.assd_no IS NOT NULL THEN
                                v_var_policy_id  :=    endt.policy_id;
                            END IF;      
                            v_assd_no            :=    NVL(endt.assd_no,v_assd_no);            
                            v_type_cd            :=    NVL(endt.type_cd,v_type_cd);            
                            v_acct_of_cd         :=    NVL(endt.acct_of_cd,v_acct_of_cd);         
                            v_designation        :=    NVL(endt.designation,v_designation);        
                            v_mortg_name         :=    NVL(endt.mortg_name,v_mortg_name);      
                            v_place_cd           :=    NVL(endt.place_cd, v_place_cd);   
                            v_industry_cd        :=    NVL(endt.industry_cd, v_industry_cd);   
                            v_region_cd          :=    NVL(endt.region_cd, v_region_cd);   
                            v_cred_branch        :=    NVL(endt.cred_branch, v_cred_branch);                             
                            IF endt.address1 IS NOT NULL OR endt.address2 IS NOT NULL OR
                                endt.address3 IS NOT NULL THEN
                                v_address1        :=    endt.address1;           
                                v_address2        :=    endt.address2;          
                                v_address3        :=    endt.address3;
                            END IF;           
                            v_pool_pol_no        :=    NVL(endt.pool_pol_no,v_pool_pol_no);        
                            v_subline_type_cd    :=    NVL(endt.subline_type_cd,v_subline_type_cd);    
                            v_auto_renew_flag    :=    NVL(endt.auto_renew_flag,v_auto_renew_flag);    
                            v_renew_flag         :=    NVL(endt.renew_flag,v_renew_flag);         
                            v_pack_pol_flag      :=    NVL(endt.pack_pol_flag,v_pack_pol_flag);      
                            v_expiry_tag         :=    NVL(endt.expiry_tag,v_expiry_tag);          
                            v_govt_acc_sw        :=    NVL(endt.foreign_acc_sw,v_govt_acc_sw);       
                            v_invoice_sw         :=    NVL(endt.invoice_sw,v_invoice_sw);        
                            v_co_insurance_sw    :=    pol.co_insurance_sw;                     
                            v_reg_policy_sw      :=    NVL(endt.reg_policy_sw,v_reg_policy_sw);               
                            v_incept_tag         :=    NVL(endt.incept_tag,pol.incept_tag);
                            v_print_fleet_tag    :=    NVL(endt.fleet_print_tag,pol.fleet_print_tag);
                            v_endt_expiry_tag    :=    NVL(endt.endt_expiry_tag,pol.endt_expiry_tag);
                            v_manual_renew_no    :=    NVL(endt.manual_renew_no,pol.manual_renew_no);
                            v_with_tariff_sw     :=    NVL(endt.with_tariff_sw,pol.with_tariff_sw);    
                            v_takeup_term        :=    NVL(endt.takeup_term, v_takeup_term);
                        END LOOP;   --z
                    END IF;
                END IF;
            END LOOP;  ---y
            
            GIUTS009_PKG.insert_into_parlist(v_var_policy_id, p_par_iss_cd, v_par_id);
            GIUTS009_PKG.insert_into_parhist(v_par_id);
            copy_par_id := v_par_id;
            copy_par_iss_cd := p_par_iss_cd ; -- jhing 10.17.2015 GENQA 5033 
            p_par_id := v_par_id;
            
            FOR C IN (SELECT param_value_n
                               FROM giac_parameters
                                WHERE param_name = 'PROD_TAKE_UP')
            LOOP
                var_vdate := c.param_value_n;
            END LOOP;
            
            IF var_vdate > 3 THEN
                --msg_alert('The parameter value ('||to_char(var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.', 'I', FALSE);
                --exit_form;  
                raise_application_error(-20001, 'The parameter value ('||to_char(var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.');
            END IF;
            
            IF var_vdate = 1 OR
                (var_vdate = 3 AND v_issue_date > v_incept_date) THEN
                    FOR C IN (SELECT booking_year,
                                             to_char(to_date('01-'||substr(booking_mth,1, 3)|| 
                                         booking_year, 'DD-MONYYYY' ), 'MM'), booking_mth  -- jhing 10.10.2015 GENQA  5033 added date format mask 
                        FROM giis_booking_month
                         WHERE (nvl(booked_tag, 'N') != 'Y')
                         AND (booking_year > to_number(to_char(v_issue_date, 'YYYY'))
                            OR (booking_year = to_number(to_char(v_issue_date, 'YYYY'))
                           AND to_number(to_char(to_date('01-'||substr(booking_mth,1, 3)|| 
                                   booking_year, 'DD-MONYYYY'), 'MM'))>= to_number(to_char(v_issue_date, 'MM'))))   -- jhing 10.10.2015 GENQA  5033 added date format mask 
                    ORDER BY 1, 2 ) LOOP
                    v_booking_year := to_number(c.booking_year);       
                    v_booking_mth  := c.booking_mth;              
                    EXIT;
                END LOOP;                     
            ELSIF var_vdate = 2 OR
                (var_vdate = 3 AND v_issue_date <= v_incept_date) THEN
                    FOR C IN (SELECT booking_year, 
                                             to_char(to_date('01-'||substr(booking_mth,1, 3)|| 
                                         booking_year, 'DD-MONYYYY' ), 'MM'), booking_mth    -- jhing 10.10.2015 GENQA  5033 added date format mask 
                                FROM giis_booking_month
                               WHERE (nvl(booked_tag, 'N') <> 'Y')
                                 AND (booking_year > to_number(to_char(v_incept_date, 'YYYY'))
                                  OR (booking_year = to_number(to_char(v_incept_date, 'YYYY'))
                                 AND to_number(to_char(to_date('01-'||substr(booking_mth,1, 3)|| 
                                     booking_year, 'DD-MONYYYY' ), 'MM'))>= to_number(to_char(v_incept_date, 'MM'))))    -- jhing 10.10.2015 GENQA  5033 added date format mask 
                               ORDER BY 1, 2 ) LOOP
                v_booking_year := to_number(c.booking_year);       
                v_booking_mth  := c.booking_mth;              
                EXIT;
                END LOOP;                     
            END IF; 
            
            
            INSERT INTO gipi_wpolbas (
                   par_id,                line_cd,               subline_cd,         iss_cd,     
                   issue_yy,              pol_seq_no,            renew_no,           endt_yy,
                   pol_flag,              eff_date,              incept_date,        endt_seq_no,
                   expiry_date,           assd_no,               type_cd,            issue_date,    
                   acct_of_cd,            designation,           mortg_name,         address1, 
                   address2,              address3,              tsi_amt,            prem_amt,     
                   pool_pol_no,           no_of_items,           prov_prem_pct,      subline_type_cd, 
                   short_rt_percent,      prorate_flag,          auto_renew_flag,    
                   pack_pol_flag,         prov_prem_tag,         expiry_tag,         foreign_acc_sw,  
                   invoice_sw,            discount_sw,           reg_policy_sw,      prem_warr_tag,
                   co_insurance_sw,       same_polno_sw,         quotation_printed_sw,
                   covernote_printed_sw,  user_id,               fleet_print_tag,    endt_expiry_tag,        
                   manual_renew_no,       with_tariff_sw,        comp_sw,            place_cd,
                   industry_cd,           region_cd,             cred_branch,        booking_mth,
                   booking_year,
                   -- longterm --
                   takeup_term)                                
     
            VALUES ( v_par_id,          pol.line_cd,           pol.subline_cd,     pol.iss_cd,           
                    TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2)),
                    NULL,                  0,       0,            
                    '1',                   v_incept_date,         v_incept_date,      0,     
                    v_expiry_date,         v_assd_no,             v_type_cd,          SYSDATE,      
                    v_acct_of_cd,          v_designation,         v_mortg_name,       v_address1,        
                    v_address2,            v_address3,            v_tsi_amt,          v_prem_amt,
                    v_pool_pol_no,         0,                     NULL,               v_subline_type_cd, 
                    NULL,                  '2',                   v_auto_renew_flag,     
                    v_pack_pol_flag,       'N',                   v_expiry_tag,       v_govt_acc_sw,
                    v_invoice_sw,          'N',                   v_reg_policy_sw,    v_prem_warr_tag,
                    v_co_insurance_sw,     'N', 'N', 'N',         USER ,              v_print_fleet_tag,     
                    v_endt_expiry_tag,     v_manual_renew_no,     v_with_tariff_sw,   'N',
                    v_place_cd,                         v_industry_cd,         v_region_cd,        v_cred_branch,
                    v_booking_mth,         v_booking_year,
                    -- longterm --
                    v_takeup_term);
            
            v_subline_cd         :=    NULL;
            v_pol_flag           :=    NULL;
            v_eff_date           :=    NULL;
            v_endt_type          :=    NULL;
            v_assd_no            :=    NULL;
            v_type_cd            :=    NULL;
            v_acct_of_cd         :=    NULL;
            v_designation        :=    NULL;
            v_mortg_name         :=    NULL;
            v_address1           :=    NULL;
            v_address2           :=    NULL;
            v_address3           :=    NULL;
            v_tsi_amt            :=    NULL;
            v_prem_amt           :=    NULL;
            v_pool_pol_no        :=    NULL;
            v_no_of_items        :=    NULL;
            v_prov_prem_pct      :=    NULL;
            v_subline_type_cd    :=    NULL;
            v_short_rt_percent   :=    NULL;
            v_auto_renew_flag    :=    NULL;
            v_prorate_flag       :=    NULL;
            v_renew_flag         :=    NULL;
            v_pack_pol_flag      :=    NULL;
            v_prov_prem_tag      :=    NULL;
            v_expiry_tag         :=    NULL;
            v_govt_acc_sw        :=    NULL;
            v_invoice_sw         :=    NULL;
            v_discount_sw        :=    NULL;                     
            v_reg_policy_sw      :=    NULL;                     
            v_co_insurance_sw    :=    NULL;                     
            v_place_cd           :=    NULL;
            v_industry_cd        :=    NULL;
            v_region_cd          :=    NULL;
            v_cred_branch        :=    NULL;
            v_takeup_term        :=    NULL;
            
            FOR OPEN_POL IN ( SELECT '1'
                          FROM giis_subline
                         WHERE line_cd = pol.line_cd
                           AND subline_cd = pol.subline_cd
                           AND open_policy_sw = 'Y') 
            LOOP 
                GIUTS009_PKG.populate_open_policy(v_var_policy_id, v_par_id);
            END LOOP;
        END LOOP;  ---x

        GIUTS009_PKG.POPULATE_ITEM_INFO1 ( p_spld_pol_sw , p_spld_endt_sw, p_cancel_sw, p_expired_sw ) ;
        --Populate_other_info;  -- kailangan na ata ng execute batch ditooooo
               
    END populate_summary;
    
    
    FUNCTION get_policy_group (
        p_line_cd              GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd           GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd               GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy             GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no           GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no             GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw          VARCHAR2,
        p_spld_endt_sw         VARCHAR2,
        p_cancel_sw            VARCHAR2,
        p_expired_sw           VARCHAR2
    ) RETURN policy_group_tab PIPELINED IS
        v_query         VARCHAR2(2000);
        v_errors        NUMBER;
        
        TYPE cur_typ IS REF CURSOR;
        v_cur               cur_typ;
        
        v_pol                 policy_group_type;
    BEGIN
        v_query :=  'SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag, eff_date '     -- jhing 10.14.2015 added eff_date GENQA 5033
                    ||'  FROM gipi_polbasic '
                    ||' WHERE line_cd     = :p_line_cd '
                    ||'   AND subline_cd  = :p_subline_cd '
                    ||'   AND iss_cd      = :p_iss_cd '
                    ||'   AND issue_yy    = :p_issue_yy '
                    ||'   AND pol_seq_no  = :p_pol_seq_no '
                    ||'   AND renew_no    = :p_renew_no ';
                    
        IF NVL(p_expired_sw, 'N') = 'N' THEN
            v_query := v_query 
                        || '   AND DECODE(endt_seq_no,0,expiry_date,endt_expiry_date) >= SYSDATE ';
        END IF;            
        
       -- jhing 10.14.2015 commented out. Revised conditions to address different combinations of parameters. GENQA 5033  
      /*  IF NVL(p_cancel_sw,'N') = 'N' AND NVL(p_spld_endt_sw, 'N') = 'N' 
        AND NVL(p_spld_pol_sw, 'N') = 'N' AND NVL(p_expired_sw,'N') = 'N' THEN
            v_query := v_query 
                 || '   AND pol_flag IN ( ''1'',''2'',''3'')' ;
        ELSIF NVL(p_cancel_sw,'N') = 'Y' AND NVL(p_spld_endt_sw, 'N') = 'N' 
        AND NVL(p_spld_pol_sw, 'N') = 'N' THEN          
            v_query := v_query 
                 || '   AND pol_flag IN ( ''1'',''2'',''3'',''4'')' ;
        ELSIF NVL(p_cancel_sw,'N') = 'Y' AND (NVL(p_spld_endt_sw, 'N') = 'Y' 
        OR NVL(p_spld_pol_sw, 'N') = 'Y') THEN          
            v_query := v_query 
                 || '   AND pol_flag IN ( ''1'',''2'',''3'',''4'',''5'')' ;             
        ELSIF NVL(p_cancel_sw,'N') = 'N' AND (NVL(p_spld_endt_sw, 'N') = 'Y' 
        OR NVL(p_spld_pol_sw, 'N') = 'Y') THEN          
            v_query := v_query 
                 || '   AND pol_flag IN ( ''1'',''2'',''3'',''5'')' ;                          
        END IF; */
        
        -- jhing 10.14.2015 new condition 
         v_query :=    v_query
                              || '    AND (   NVL ( '''
                              || p_spld_pol_sw
                              || ''' , ''N'') = ''Y''    '
                              || '  OR endt_seq_no <> 0   '
                              || '                   OR (    NVL ( '''
                              || p_spld_pol_sw
                              || ''', ''N'') = ''N''     '
                              || '                      AND endt_seq_no = 0    '
                              || '                       AND pol_flag <> ''5''))    '
                              || '              AND (   NVL ( '''
                              || p_spld_endt_sw
                              || ''' , ''N'') = ''Y''    '
                              || '                   OR endt_seq_no = 0    '
                              || '                   OR (    NVL ( '''
                              || p_spld_endt_sw
                              || ''' , ''N'') = ''N''    '
                              || '                        AND endt_seq_no > 0    '
                              || '                        AND pol_flag <> ''5''))    '
                              || '               AND (   NVL ( '''
                              || p_cancel_sw
                              || ''' , ''N'') = ''Y''    '
                              || '                   OR (NVL ( '''
                              || p_cancel_sw
                              || ''' , ''N'') = ''N'' AND pol_flag <> ''4''))    ';
        
        -- end jhing 10.14.2015 
        
        IF NVL(p_cancel_sw,'N') = 'Y' THEN   
            v_query := v_query 
                  || ' AND endt_seq_no <> NVL( ( SELECT MAX( b.endt_seq_no) '
                  || '                        FROM gipi_polbasic b'
                  ||' WHERE b.line_cd     = :p_line_cd '
                  ||'   AND b.subline_cd  = :p_subline_cd '
                  ||'   AND b.iss_cd      = :p_iss_cd '
                  ||'   AND b.issue_yy    = :p_issue_yy '
                  ||'   AND b.pol_seq_no  = :p_pol_seq_no '
                  ||'   AND b.renew_no    = :p_renew_no '
                  ||'   AND b.ann_tsi_amt = 0 '
                  ||'   AND b.ann_prem_amt = 0 '
                  ||'   AND b.pol_flag  = ''4'' ) , -1 ) ' ;
        END IF; 
        
        v_query := v_query 
             || ' ORDER BY eff_date, endt_seq_no ';
        
        IF NVL(p_cancel_sw,'N') = 'Y' THEN   --steven 05.09.2013
            OPEN v_cur FOR v_query
            USING   p_line_cd,
                    p_subline_cd,
                    p_iss_cd,
                    p_issue_yy,
                    p_pol_seq_no,
                    p_renew_no,
                    p_line_cd, 
                    p_subline_cd,
                    p_iss_cd,
                    p_issue_yy,
                    p_pol_seq_no,
                    p_renew_no;
            LOOP
                FETCH v_cur
                 INTO v_pol;

                EXIT WHEN v_cur%NOTFOUND;
                PIPE ROW (v_pol);
             END LOOP;

             CLOSE v_cur;
        ELSE   
            OPEN v_cur FOR v_query
            USING   p_line_cd,
                    p_subline_cd,
                    p_iss_cd,
                    p_issue_yy,
                    p_pol_seq_no,
                    p_renew_no;
            LOOP
                FETCH v_cur
                 INTO v_pol;

                EXIT WHEN v_cur%NOTFOUND;
                PIPE ROW (v_pol);
             END LOOP;

             CLOSE v_cur;       
                  
        END IF; 
    END get_policy_group; 
    
    PROCEDURE insert_into_parlist (
        p_policy_id     IN  gipi_polbasic.policy_id%type,
        p_par_iss_cd    IN gipi_parlist.iss_cd%type,
        p_par_id        OUT gipi_parlist.par_id%type
    ) IS
    BEGIN
        BEGIN
            SELECT parlist_par_id_s.nextval
              INTO p_par_id
              FROM SYS.DUAL;            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                raise_application_error(-20001, 'Cannot generate new PAR ID.');
        END;
        
        FOR c1 IN (SELECT line_cd , iss_cd , issue_yy ,
                    assd_no , user
               FROM gipi_polbasic
              WHERE policy_id = p_policy_id)
        LOOP
            INSERT INTO  gipi_parlist
                        (par_id       , line_cd      , iss_cd    ,
                         par_yy       , quote_seq_no , par_type  ,
                         assd_no      ,underwriter   , assign_sw , 
                         par_status,  load_tag)
                 VALUES (p_par_id , c1.line_cd   , p_par_iss_cd ,
                         TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2)),
                         0            , 'P'       ,
                         c1.assd_no   , c1.user      , 'Y'       ,
                         2, 'S');
            EXIT;
        END LOOP;
    END insert_into_parlist;
    
    PROCEDURE insert_into_parhist (
        p_par_id    GIPI_PARLIST.par_id%TYPE
    ) IS
    BEGIN
        INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
        VALUES(p_par_id,NVL(giis_users_pkg.app_user, user),sysdate,'DB',1);
    END insert_into_parhist;
    
    PROCEDURE populate_open_policy (
        v_policy_id        GIPI_POLBASIC.policy_id%TYPE,
        v_par_id        GIPI_POLBASIC.par_id%TYPE
    ) IS
        exist               VARCHAR2(1) := 'N';
        v_line_cd           gipi_wopen_policy.line_cd%TYPE; 
        v_op_subline_cd     gipi_wopen_policy.op_subline_cd%TYPE;
        v_op_iss_cd         gipi_wopen_policy.op_iss_cd%TYPE;
        v_op_pol_seqno      gipi_wopen_policy.op_pol_seqno%TYPE;
        v_op_renew_no       gipi_wopen_policy.op_renew_no%TYPE;
        v_decltn_no         gipi_wopen_policy.decltn_no%TYPE;
        v_eff_date          gipi_wopen_policy.eff_date%TYPE;
        v_op_issue_yy       gipi_wopen_policy.op_issue_yy%TYPE;
    BEGIN
        FOR open_pol IN (
            SELECT line_cd,   op_subline_cd,  
                   op_iss_cd, op_pol_seqno,   
                   decltn_no, eff_date,       
                   op_issue_yy, op_renew_no
              FROM gipi_open_policy
             WHERE policy_id = v_policy_id)
        LOOP
            exist   := 'Y';
            v_line_cd          := NVL(open_pol.line_cd,v_line_cd);          
            v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
            v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
            v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
            v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
            v_eff_date         := NVL(open_pol.eff_date,v_eff_date);                
            v_op_issue_yy      := NVL(open_pol.op_issue_yy,v_op_issue_yy);         
            v_op_renew_no      := NVL(open_pol.op_renew_no,v_op_renew_no); 
        END LOOP;
        
        IF NVL(exist, 'N') = 'Y' THEN
            INSERT INTO gipi_wopen_policy (
                        par_id,        line_cd,        op_subline_cd,
                        op_iss_cd,     op_pol_seqno,   op_renew_no,
                        decltn_no,     eff_date,       op_issue_yy)
                 VALUES (v_par_id,     v_line_cd,      v_op_subline_cd,
                        v_op_iss_cd,   v_op_pol_seqno, v_op_renew_no,
                        v_decltn_no,   v_eff_date,     v_op_issue_yy);         
        END IF;   
    END populate_open_policy;
    
    -- jhing 10.10.2015 added parameters GENQA 5033 
    PROCEDURE POPULATE_ITEM_INFO1 (  p_spld_pol_sw        IN  VARCHAR2,
        p_spld_endt_sw        IN  VARCHAR2,
        p_cancel_sw            IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2
    ) 
      IS
        v_line_cd          gipi_polbasic.line_cd%TYPE;     -- line_cd of policy/endt with certain district/block
        v_subline_cd       gipi_polbasic.subline_cd%TYPE;  -- subline_cd of policy/endt with certain district/block
        v_iss_cd           gipi_polbasic.iss_cd%TYPE;      -- iss_cd of policy/endt with certain district/block
        v_issue_yy         gipi_polbasic.issue_yy%TYPE;    -- issue_yy of policy/endt with certain district/block
        v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;  -- pol_seq_no of policy/endt with certain district/block
        v_renew_no         gipi_polbasic.renew_no%TYPE;    -- renew_no of policy/endt with certain district/block
        v_item_no          gipi_witem.item_no%TYPE;
        v_item_title       gipi_witem.item_title%TYPE;
        v_item_desc        gipi_witem.item_desc%TYPE;
        v_item_desc2       gipi_witem.item_desc2%TYPE;
        v_currency_cd      gipi_witem.currency_cd%TYPE;
        v_currency_rt      gipi_witem.currency_rt%TYPE;
        v_group_cd         gipi_witem.group_cd%TYPE;
        v_from_date        gipi_witem.from_date%TYPE;
        v_to_date          gipi_witem.to_date%TYPE;
        v_pack_line_cd     gipi_witem.pack_line_cd%TYPE;
        v_pack_subline_cd  gipi_witem.pack_subline_cd%TYPE;
        v_other_info       gipi_witem.other_info%TYPE;
        v_coverage_cd      gipi_witem.coverage_cd%TYPE;
        v_item_grp         gipi_witem.item_grp%TYPE;
        v_risk_no           gipi_witem.risk_no%TYPE ;
        v_risk_item_no  gipi_witem.risk_item_no%TYPE ;
        v_region_cd        gipi_witem.region_cd%TYPE;
    BEGIN
      
        v_line_cd         := policy_line_cd;
        v_subline_cd      := policy_subline_cd;
        v_iss_cd          := policy_iss_cd;
        v_issue_yy        := policy_issue_yy;
        v_pol_seq_no      := policy_pol_seq_no;
        v_renew_no        := policy_renew_no;

      -- grp FOR LOOP selects all item_no of the above policy together 
      -- with its endorsemet/s
        FOR grp IN (SELECT DISTINCT item_no
                    FROM gipi_polbasic x,
                         gipi_item y
                   WHERE x.line_cd    = v_line_cd
                     AND x.subline_cd = v_subline_cd
                     AND x.iss_cd     = v_iss_cd
                     AND x.issue_yy   = v_issue_yy
                     AND x.pol_seq_no = v_pol_seq_no
                     AND x.renew_no   = v_renew_no
                    -- AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                     -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) - GENQA 5033 
                   AND (   NVL (p_expired_sw, 'N') = 'Y'
                        OR (    NVL (p_expired_sw, 'N') = 'N'
                            AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                   AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                        OR x.endt_seq_no <> 0
                        OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                            AND x.endt_seq_no = 0
                            AND x.pol_flag <> '5'))
                   AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                        OR x.endt_seq_no = 0
                        OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                            AND x.endt_seq_no > 0
                            AND x.pol_flag <> '5'))
                   AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                        OR (    NVL(p_cancel_sw,'N') = 'Y'
                            AND x.pol_flag = '4'
                            AND x.endt_seq_no <>
                                   NVL (
                                      (SELECT MAX (endt_seq_no)
                                         FROM gipi_polbasic t
                                        WHERE     t.line_cd = v_line_cd
                                              AND t.subline_cd = v_subline_cd
                                              AND t.iss_cd = v_iss_cd
                                              AND t.issue_yy = v_issue_yy
                                              AND t.pol_seq_no = v_pol_seq_no
                                              AND t.renew_no = v_renew_no
                                              AND t.pol_flag = '4'
                                              AND t.ann_tsi_amt = 0),
                                      -1)))
                     -- end of modified condition jhing 10.10.2015 
                     AND x.policy_id  = y.policy_id)
        LOOP
            v_item_no    := grp.item_no;
            
            -- selects the latest item_title, and item_grp
            FOR A IN (SELECT y.item_title  ,y.item_grp, y.policy_id
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                          --AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                          AND (   NVL (p_expired_sw, 'N') = 'Y'
                                OR (    NVL (p_expired_sw, 'N') = 'N'
                                    AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                           AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                OR x.endt_seq_no <> 0
                                OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                    AND x.endt_seq_no = 0
                                    AND x.pol_flag <> '5'))
                           AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                OR x.endt_seq_no = 0
                                OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                    AND x.endt_seq_no > 0
                                    AND x.pol_flag <> '5'))
                           AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                OR (    NVL(p_cancel_sw,'N') = 'Y'
                                    AND x.pol_flag = '4'
                                    AND x.endt_seq_no <>
                                           NVL (
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic t
                                                WHERE     t.line_cd = v_line_cd
                                                      AND t.subline_cd = v_subline_cd
                                                      AND t.iss_cd = v_iss_cd
                                                      AND t.issue_yy = v_issue_yy
                                                      AND t.pol_seq_no = v_pol_seq_no
                                                      AND t.renew_no = v_renew_no
                                                      AND t.pol_flag = '4'
                                                      AND t.ann_tsi_amt = 0),
                                              -1)))
                              -- end of added condition jhing 10.10.2015         
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no
                                              -- AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033 
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.item_title IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.item_title IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_item_title := A.item_title;
                v_item_grp   := A.item_grp;
                
                /*raise_application_error( -20001, 'TEST vars: '||v_line_cd
                                     ||'; '||v_subline_cd||'; '||v_iss_cd
                                     ||'; '||v_issue_yy||'; '||v_pol_seq_no
                                     ||', '||v_renew_no||'; '||A.item_title
                                     ||'; '||A.item_grp||'; '||A.policy_id);*/
                EXIT;
            END LOOP;
            
            -- selects the latest item_desc
              FOR item IN (SELECT y.item_desc
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                            -- AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                             -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                            AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                             AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015         
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no   
                                            --AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033 
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.item_desc IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.item_desc IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_item_desc := item.item_desc;
                EXIT;
            END LOOP;
            
            -- selects the latest item_desc2
            FOR item2 IN (SELECT y.item_desc2
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                           -- AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                              -- end of added condition jhing 10.10.2015         
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no     
                                             --AND m.pol_flag        IN ('1','2','3') -- commented out GENQA 5033 
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.item_desc2 IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.item_desc2 IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_item_desc2 := item2.item_desc2;
                EXIT;
            END LOOP;
            
            -- selects the latest currency_cd
            FOR curr IN (SELECT y.currency_cd
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015         
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no        
                                            -- AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                     
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.currency_cd IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.currency_cd IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_currency_cd := curr.currency_cd;
                EXIT;
            END LOOP;
                     
            -- selects the latest currency_rt             
            FOR curt IN (SELECT y.currency_rt
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                          -- AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                           AND (   NVL (p_expired_sw, 'N') = 'Y'
                                OR (    NVL (p_expired_sw, 'N') = 'N'
                                    AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                            AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                OR x.endt_seq_no <> 0
                                OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                    AND x.endt_seq_no = 0
                                    AND x.pol_flag <> '5'))
                            AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                OR x.endt_seq_no = 0
                                OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                    AND x.endt_seq_no > 0
                                    AND x.pol_flag <> '5'))
                            AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                OR (    NVL(p_cancel_sw,'N') = 'Y'
                                    AND x.pol_flag = '4'
                                    AND x.endt_seq_no <>
                                           NVL (
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic t
                                                WHERE     t.line_cd = v_line_cd
                                                      AND t.subline_cd = v_subline_cd
                                                      AND t.iss_cd = v_iss_cd
                                                      AND t.issue_yy = v_issue_yy
                                                      AND t.pol_seq_no = v_pol_seq_no
                                                      AND t.renew_no = v_renew_no
                                                      AND t.pol_flag = '4'
                                                      AND t.ann_tsi_amt = 0),
                                              -1)))
                              -- end of added condition jhing 10.10.2015                                    
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no    
                                             -- AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                       
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.currency_rt IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.currency_rt IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_currency_rt := curt.currency_rt;
                EXIT;
            END LOOP;             
              
            -- selects the latest group_cd
            FOR grp  IN (SELECT y.group_cd
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                         -- AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015         
                               AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no   
                                            --AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                             
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.group_cd IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.group_cd IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_group_cd := grp.group_cd;
                EXIT;
            END LOOP;
            
            -- selects the latest from_date
            FOR frm  IN (SELECT y.from_date
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                          --  AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015                               
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no    
                                           -- AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                     
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.from_date IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.from_date IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_from_date := frm.from_date;
                EXIT;
            END LOOP;
            
            -- selects the latest to_date
            FOR to_d  IN (SELECT y.to_date
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                          --  AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015                                  
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no    
                                          -- AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                             
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.from_date IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.from_date IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_to_date := to_d.to_date;
                EXIT;
            END LOOP;
            
            -- selects the latest pack_line_cd
            FOR pack IN (SELECT y.pack_line_cd
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                           --  AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015         
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no      
                                           --  AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                          
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.pack_line_cd IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.pack_line_cd IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_pack_line_cd := pack.pack_line_cd;
                EXIT;
            END LOOP;
            
            -- selects the latest pack_subline_cd
            FOR pacs IN (SELECT y.pack_subline_cd
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                           --  AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015                                   
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no   
                                             --  AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                                 
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.pack_subline_cd IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.pack_subline_cd IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_pack_subline_cd := pacs.pack_subline_cd;
                EXIT;
            END LOOP;             
            
            -- selects the latest other_info
            FOR othe IN (SELECT y.other_info
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                           --  AND x.pol_flag IN ('1','2','3') -- jhing commented out GENQA 5033 
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015                                 
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no    
                                            --  AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                              
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.other_info IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.other_info IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_other_info := othe.other_info;
                EXIT;
            END LOOP;             
            
            -- selects the latest coverage_cd
            FOR cove IN (SELECT y.coverage_cd
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                              AND (   NVL (p_expired_sw, 'N') = 'Y'
                                    OR (    NVL (p_expired_sw, 'N') = 'N'
                                        AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                               AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                    OR x.endt_seq_no <> 0
                                    OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                        AND x.endt_seq_no = 0
                                        AND x.pol_flag <> '5'))
                               AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                    OR x.endt_seq_no = 0
                                    OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                        AND x.endt_seq_no > 0
                                        AND x.pol_flag <> '5'))
                               AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                    OR (    NVL(p_cancel_sw,'N') = 'Y'
                                        AND x.pol_flag = '4'
                                        AND x.endt_seq_no <>
                                               NVL (
                                                  (SELECT MAX (endt_seq_no)
                                                     FROM gipi_polbasic t
                                                    WHERE     t.line_cd = v_line_cd
                                                          AND t.subline_cd = v_subline_cd
                                                          AND t.iss_cd = v_iss_cd
                                                          AND t.issue_yy = v_issue_yy
                                                          AND t.pol_seq_no = v_pol_seq_no
                                                          AND t.renew_no = v_renew_no
                                                          AND t.pol_flag = '4'
                                                          AND t.ann_tsi_amt = 0),
                                                  -1)))
                                  -- end of added condition jhing 10.10.2015                                   
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no  
                                             --  AND m.pol_flag        IN ('1','2','3') -- jhing commented out GENQA 5033                                        
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.coverage_cd IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.coverage_cd IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_coverage_cd := cove.coverage_cd;
                EXIT;
            END LOOP;             
            
            -- jhing 10.11.2015 added codes to retrieve risk_no and risk_item_no
             -- selects the latest risk_no
            FOR risk IN (SELECT y.risk_no
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                          AND (   NVL (p_expired_sw, 'N') = 'Y'
                                OR (    NVL (p_expired_sw, 'N') = 'N'
                                    AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                           AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                OR x.endt_seq_no <> 0
                                OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                    AND x.endt_seq_no = 0
                                    AND x.pol_flag <> '5'))
                           AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                OR x.endt_seq_no = 0
                                OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                    AND x.endt_seq_no > 0
                                    AND x.pol_flag <> '5'))
                           AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                OR (    NVL(p_cancel_sw,'N') = 'Y'
                                    AND x.pol_flag = '4'
                                    AND x.endt_seq_no <>
                                           NVL (
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic t
                                                WHERE     t.line_cd = v_line_cd
                                                      AND t.subline_cd = v_subline_cd
                                                      AND t.iss_cd = v_iss_cd
                                                      AND t.issue_yy = v_issue_yy
                                                      AND t.pol_seq_no = v_pol_seq_no
                                                      AND t.renew_no = v_renew_no
                                                      AND t.pol_flag = '4'
                                                      AND t.ann_tsi_amt = 0),
                                              -1)))
                              -- end of added condition jhing 10.10.2015                                
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no                                            
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.risk_no IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.risk_no IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_risk_no := risk.risk_no;
                EXIT;
            END LOOP;             
            
            -- selects the latest risk_item_no
            FOR riskitm IN (SELECT y.risk_item_no
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                          AND (   NVL (p_expired_sw, 'N') = 'Y'
                                OR (    NVL (p_expired_sw, 'N') = 'N'
                                    AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                           AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                OR x.endt_seq_no <> 0
                                OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                    AND x.endt_seq_no = 0
                                    AND x.pol_flag <> '5'))
                           AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                OR x.endt_seq_no = 0
                                OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                    AND x.endt_seq_no > 0
                                    AND x.pol_flag <> '5'))
                           AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                OR (    NVL(p_cancel_sw,'N') = 'Y'
                                    AND x.pol_flag = '4'
                                    AND x.endt_seq_no <>
                                           NVL (
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic t
                                                WHERE     t.line_cd = v_line_cd
                                                      AND t.subline_cd = v_subline_cd
                                                      AND t.iss_cd = v_iss_cd
                                                      AND t.issue_yy = v_issue_yy
                                                      AND t.pol_seq_no = v_pol_seq_no
                                                      AND t.renew_no = v_renew_no
                                                      AND t.pol_flag = '4'
                                                      AND t.ann_tsi_amt = 0),
                                              -1)))
                              -- end of added condition jhing 10.10.2015                                
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no                                               
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.risk_item_no IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.risk_item_no IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_risk_item_no := riskitm.risk_item_no;
                EXIT;
            END LOOP;             
            
           -- selects the latest region_cd
            FOR othe IN (SELECT y.region_cd
                           FROM gipi_polbasic x,
                                gipi_item y
                          WHERE x.line_cd    = v_line_cd
                            AND x.subline_cd = v_subline_cd
                            AND x.iss_cd     = v_iss_cd
                            AND x.issue_yy   = v_issue_yy
                            AND x.pol_seq_no = v_pol_seq_no
                            AND x.renew_no   = v_renew_no
                              -- jhing 10.10.2015 modified condition to handle different include parameters ( originally only considered pol_flag 1,2,3 regardless of what include options user chooses ) 
                          AND (   NVL (p_expired_sw, 'N') = 'Y'
                                OR (    NVL (p_expired_sw, 'N') = 'N'
                                    AND DECODE (x.endt_seq_no, 0, x.expiry_date, x.endt_expiry_date) >=   SYSDATE))
                           AND (   NVL (p_spld_pol_sw, 'N') = 'Y'
                                OR x.endt_seq_no <> 0
                                OR (    NVL (p_spld_pol_sw, 'N') = 'N'
                                    AND x.endt_seq_no = 0
                                    AND x.pol_flag <> '5'))
                           AND (   NVL (p_spld_endt_sw, 'N') = 'Y'
                                OR x.endt_seq_no = 0
                                OR (    NVL (p_spld_endt_sw, 'N') = 'N'
                                    AND x.endt_seq_no > 0
                                    AND x.pol_flag <> '5'))
                           AND (   (NVL (p_cancel_sw, 'N') = 'N' AND x.pol_flag <> '4')
                                OR (    NVL(p_cancel_sw,'N') = 'Y'
                                    AND x.pol_flag = '4'
                                    AND x.endt_seq_no <>
                                           NVL (
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic t
                                                WHERE     t.line_cd = v_line_cd
                                                      AND t.subline_cd = v_subline_cd
                                                      AND t.iss_cd = v_iss_cd
                                                      AND t.issue_yy = v_issue_yy
                                                      AND t.pol_seq_no = v_pol_seq_no
                                                      AND t.renew_no = v_renew_no
                                                      AND t.pol_flag = '4'
                                                      AND t.ann_tsi_amt = 0),
                                              -1)))
                              -- end of added condition jhing 10.10.2015                                
                            AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = v_line_cd
                                              AND m.subline_cd      = v_subline_cd
                                              AND m.iss_cd          = v_iss_cd
                                              AND m.issue_yy        = v_issue_yy
                                              AND m.pol_seq_no      = v_pol_seq_no
                                              AND m.renew_no        = v_renew_no                                               
                                              AND m.endt_seq_no      > x.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = v_item_no
                                              AND n.region_cd IS NOT NULL )
                            AND x.policy_id       = y.policy_id
                            AND y.item_no = v_item_no
                            AND y.region_cd IS NOT NULL
                       ORDER BY x.eff_date DESC)
            LOOP
                v_region_cd := othe.region_cd;
                EXIT;
            END LOOP;             
            
            
            /*raise_application_error( -20001, 'TEST: '||copy_par_id
                                     ||'; '||grp.item_no||'; '||v_item_title||'; '||
                                     v_item_desc||'; '||v_item_desc2||'; '||v_currency_cd||'; '||
                                     v_currency_rt||'; '||v_group_cd||'; '||v_from_date||'; '||  
                                     v_to_date||'; '||v_pack_line_cd||'; '||v_pack_subline_cd||'; '||
                                     v_other_info||'; '||v_coverage_cd||'; '||v_item_grp);*/
                                     
            INSERT INTO gipi_witem ( par_id,              item_no,        item_title,
                                     item_desc,           item_desc2,     currency_cd,
                                     currency_rt,         group_cd,       from_date,           
                                     to_date,             --pack_line_cd,   pack_subline_cd, -- bonok :: 11.19.2013 :: SR 591 :: solution for integrity constraint
                                     other_info,          coverage_cd,    item_grp, risk_no , risk_item_no , region_cd )
                            VALUES ( copy_par_id,          grp.item_no,   v_item_title,
                                     v_item_desc,         v_item_desc2,   v_currency_cd,
                                     v_currency_rt,       v_group_cd,     v_from_date,   
                                     v_to_date,           --v_pack_line_cd, v_pack_subline_cd, -- bonok :: 11.19.2013 :: SR 591 :: solution for integrity constraint
                                     v_other_info,        v_coverage_cd,  v_item_grp, v_risk_no, v_risk_item_no, v_region_cd ); 
                     
             v_item_desc       := NULL;
             v_item_desc2      := NULL;
             v_currency_cd     := NULL;
             v_currency_rt     := NULL;
             v_group_cd        := NULL;
             v_from_date       := NULL;
             v_to_date         := NULL;
             v_pack_line_cd    := NULL;
             v_pack_subline_cd := NULL;
             v_other_info      := NULL;
             v_coverage_cd     := NULL;
        END LOOP;                 
        
    END POPULATE_ITEM_INFO1;
    
    PROCEDURE change_item_grp(p_par_id IN gipi_parlist.par_id%TYPE) IS

       p_item_grp      gipi_witem.item_grp%TYPE := 1;
       v_pack_pol_flag gipi_wpolbas.pack_pol_flag%TYPE;
       
    BEGIN

        FOR pack_flag IN (
            SELECT pack_pol_flag
              FROM gipi_wpolbas
             WHERE par_id = p_par_id)
        LOOP
            v_pack_pol_flag := pack_flag.pack_pol_flag;
            exit;
        END LOOP;
      
        IF v_pack_pol_flag = 'Y' THEN
            FOR C1 IN  (SELECT    currency_cd, currency_rt, pack_line_cd, pack_subline_cd
                          FROM    gipi_witem
                         WHERE    par_id  =  p_par_id
                      GROUP BY    currency_cd, currency_rt, pack_line_cd, pack_subline_cd
                      ORDER BY    currency_cd, currency_rt, pack_line_cd, pack_subline_cd)   
            LOOP
                  UPDATE    gipi_witem
                     SET    item_grp        = p_item_grp
                   WHERE    currency_rt     = c1.currency_rt
                     AND    currency_cd     = c1.currency_cd
                     AND    pack_line_cd    = c1.pack_line_cd
                     AND    pack_subline_cd = c1.pack_subline_cd
                     AND    par_id      = p_par_id;
                  p_item_grp  :=  p_item_grp + 1;
            END LOOP;
        ELSE   -- jhing 10.13.2015 added else 
                    FOR C2 IN (
                        SELECT currency_cd, currency_rt
                          FROM GIPI_WITEM
                         WHERE par_id  =  p_par_id
                      GROUP BY currency_cd, currency_rt
                      ORDER BY currency_cd, currency_rt)
             LOOP
                    UPDATE GIPI_WITEM
                       SET item_grp = p_item_grp
                     WHERE currency_rt = c2.currency_rt
                       AND currency_cd = c2.currency_cd
                       AND par_id = p_par_id;
                      
                       p_item_grp  :=  p_item_grp + 1;
              END LOOP;    
        END IF;
    END change_item_grp;

    PROCEDURE initialize_line_cd (
        p_fire_cd       OUT   giis_line.line_cd%TYPE,
        p_motor_cd      OUT   giis_line.line_cd%TYPE,
        p_accident_cd   OUT   giis_line.line_cd%TYPE,
        p_hull_cd       OUT   giis_line.line_cd%TYPE,
        p_cargo_cd      OUT   giis_line.line_cd%TYPE,
        p_casualty_cd   OUT   giis_line.line_cd%TYPE,
        p_engrng_cd     OUT   giis_line.line_cd%TYPE,
        p_surety_cd     OUT   giis_line.line_cd%TYPE,
        p_aviation_cd   OUT   giis_line.line_cd%TYPE
    ) IS
        v_switch    varchar2(1) := 'N';
    BEGIN
        FOR L IN (
          SELECT a.param_value_v A, b.param_value_v B, c.param_value_v C,
                 d.param_value_v D, e.param_value_v E, f.param_value_v F,
                 g.param_value_v G, h.param_value_v H, i.param_value_v I
            FROM giis_parameters a, giis_parameters b, giis_parameters c,
                 giis_parameters d, giis_parameters e, giis_parameters f,
                 giis_parameters g, giis_parameters h, giis_parameters i
           WHERE a.param_name = 'LINE_CODE_AC'
             AND b.param_name = 'LINE_CODE_AV'
             AND c.param_name = 'LINE_CODE_CA'
             AND d.param_name = 'LINE_CODE_EN'
             AND e.param_name = 'LINE_CODE_FI'
             AND f.param_name = 'LINE_CODE_MC'
             AND g.param_name = 'LINE_CODE_MH'
             AND h.param_name = 'LINE_CODE_MN'
             AND i.param_name = 'LINE_CODE_SU')
        LOOP
            p_accident_cd          := L.A;
            p_aviation_cd          := L.B;
            p_casualty_cd          := L.C;
            p_engrng_cd          := L.D;
            p_fire_cd              := L.E;
            p_motor_cd          := L.F;
            p_hull_cd              := L.G;
            p_cargo_cd          := L.H;
            p_surety_cd          := L.I;
            v_switch            := 'Y';
        END LOOP;
       
       IF v_switch = 'N' THEN
          BEGIN
             p_accident_cd       := 'AC';
             p_aviation_cd       := 'AV';
             p_casualty_cd       := 'CA';
             p_engrng_cd           := 'EN';
             p_fire_cd           := 'FI'; 
             p_motor_cd           := 'MC';
             p_hull_cd           := 'MH';
             p_cargo_cd           := 'MN';
             p_surety_cd           := 'SU';
          END;
       END IF;
    END initialize_line_cd;
    
    PROCEDURE initialize_subline_cd(
        p_subline_CAR          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_EAR          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_MBI          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_MLOP         OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_DOS          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_BPV          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_EEI          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_PCP          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_OP           OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_BBI          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_MOP          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_OTH          OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_subline_open         OUT GIIS_PARAMETERS.param_value_v%TYPE,
        p_vessel_cd            OUT GIIS_PARAMETERS.param_value_v%TYPE
    ) IS
      v_switch    varchar2(1) := 'N';
      v_exist     varchar2(1) := 'N';
    BEGIN
        FOR L IN (
          SELECT a.param_value_v A, b.param_value_v B, c.param_value_v C,
                 d.param_value_v D, e.param_value_v E, f.param_value_v F,
                 g.param_value_v G, h.param_value_v H, i.param_value_v I,
                 j.param_value_v J, k.param_value_v K
            FROM giis_parameters a, giis_parameters b, giis_parameters c,
                 giis_parameters d, giis_parameters e, giis_parameters f,
                 giis_parameters g, giis_parameters h, giis_parameters i,
                 giis_parameters j, giis_parameters k
           WHERE a.param_name = 'CONTRACTOR_ALL_RISK'
             AND b.param_name = 'ERECTION_ALL_RISK'
             AND c.param_name = 'MACHINERY_BREAKDOWN_INSURANCE'
             AND d.param_name = 'MACHINERY_LOSS_OF_PROFIT'
             AND e.param_name = 'DETERIORATION_OF_STOCKS'
             AND f.param_name = 'BOILER_AND_PRESSURE_VESSEL'
             AND g.param_name = 'ELECTRONIC_EQUIPMENT'
             AND h.param_name = 'PRINCIPAL_CONTROL_POLICY'
             AND i.param_name = 'OPEN_POLICY'
             AND j.param_name = 'BANKERS BLANKET INSURANCE'
             AND k.param_name = 'SUBLINE_MN_MOP')
        LOOP
            p_subline_CAR  := L.A;
            p_subline_EAR  := L.B;
            p_subline_MBI  := L.C;
            p_subline_MLOP := L.D;
            p_subline_DOS  := L.E;
            p_subline_BPV  := L.F;
            p_subline_EEI  := L.G;
            p_subline_PCP  := L.H;
            p_subline_OP   := L.I;
            p_subline_BBI  := L.J;
            p_subline_MOP  := L.K;
            v_switch               := 'Y';
        END LOOP;
       
        IF v_switch = 'N' THEN
            BEGIN
                p_subline_CAR   := 'CAR';
                p_subline_EAR   := 'EAR';
                p_subline_MBI   := 'MBI';
                p_subline_MLOP  := 'MLOP';
                p_subline_DOS   := 'DOS';
                p_subline_BPV   := 'BPV'; 
                p_subline_EEI   := 'EEI';
                p_subline_PCP   := 'PCP';
                p_subline_OP    := 'OP';
                p_subline_OTH   := 'OTH';

                p_subline_BBI   := 'BBI';
                p_subline_MOP   := 'MOP';
            END;
        END IF;

        FOR op IN (
            SELECT subline_cd
              FROM giis_subline
             WHERE open_policy_sw = 'Y')
        LOOP
            v_exist                := 'Y';
            p_subline_open := op.subline_cd;
        END LOOP;
     
        IF v_exist = 'N' THEN
            p_subline_open := 'MRN';
        END IF;    

        FOR det_cd IN (
            SELECT param_value_v
              FROM giis_parameters
             WHERE param_name = 'VESSEL_CD_MULTI')
        LOOP
            p_vessel_cd := det_cd.param_value_v;
        END LOOP;

    END initialize_subline_cd;

    
    PROCEDURE POPULATE_OTHER_INFO(
        p_line_cd              IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd           IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd               IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy             IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no           IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no             IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw          IN  VARCHAR2,
        p_spld_endt_sw         IN  VARCHAR2,
        p_cancel_sw            IN  VARCHAR2,
        p_expired_sw           IN  VARCHAR2
    ) IS
        v_line_cd        gipi_wpolbas.line_cd%TYPE;
        v_pol_line       gipi_wpolbas.line_cd%TYPE;
        v_pol_subline    gipi_wpolbas.subline_cd%TYPE;
        v_subline_cd     gipi_wpolbas.subline_cd%TYPE;
        v_pack_flag      gipi_wpolbas.pack_pol_flag%TYPE; 
        v_menu_line_cd   giis_line.menu_line_cd%TYPE;
        v_other_sw       VARCHAR2(1) := 'Y';
    BEGIN
        policy_line_cd              := p_line_cd;
        policy_subline_cd           := p_subline_cd;
        policy_iss_cd               := p_iss_cd;
        policy_issue_yy             := p_issue_yy;
        policy_pol_seq_no           := p_pol_seq_no;
        policy_renew_no             := p_renew_no;
        policy_spld_pol_sw            := p_spld_pol_sw;
        policy_spld_endt_sw            := p_spld_endt_sw;
        policy_cancel_sw            := p_cancel_sw;
        policy_expired_sw            := p_expired_sw;
        
        GIUTS009_PKG.initialize_line_cd(
            var_line_FI, var_line_MC, var_line_AC, var_line_MH, var_line_MN,
            var_line_CA, var_line_EN, var_line_SU, var_line_AV        
        );
        
        GIUTS009_PKG.initialize_subline_cd(
            var_subline_CAR, var_subline_EAR, var_subline_MBI, var_subline_MLOP, var_subline_DOS, 
            var_subline_BPV, var_subline_EEI, var_subline_PCP, var_subline_OP, var_subline_BBI,
            var_subline_MOP, var_subline_oth, var_subline_open, var_vessel_cd
        );
        
        FOR PACK IN
            ( SELECT NVL(pack_pol_flag,'N') flag, line_cd, subline_cd
                FROM gipi_wpolbas
               WHERE par_id = copy_par_id
            )     LOOP
            v_pack_flag    := pack.flag;
            v_pol_line     := pack.line_cd;
            v_pol_subline  := pack.subline_cd;
            EXIT;
        END LOOP;        
      
        FOR ITEM IN ( 
            SELECT item_no,pack_line_cd, pack_subline_cd
                  FROM gipi_witem
                 WHERE par_id = copy_par_id) 
        LOOP
            populate_peril(item.item_no);
            v_other_sw  := 'N';         
                     
            FOR CHK IN ( 
                SELECT SUM(tsi_amt) tsi, SUM(prem_amt) prem
                  FROM gipi_witmperl
                 WHERE par_id = copy_par_id
                   AND item_no = item.item_no) 
            LOOP
                IF nvl(chk.tsi,0) > 0 OR nvl(chk.prem,0) > 0 THEN
                    v_other_sw := 'Y';
                ELSE               
                    v_other_sw := 'N';
                END IF;
            END LOOP;   
            
            IF v_other_sw = 'Y' THEN
                populate_deductibles(item.item_no);
                IF v_pack_flag = 'Y' THEN
                    v_line_cd := item.pack_line_cd;
                    v_subline_cd := item.pack_subline_cd;
                ELSE          
                    v_line_cd := v_pol_line;
                    v_subline_cd := v_pol_subline;
                END IF; 
                
                FOR menu_line IN (SELECT NVL( menu_line_cd, line_cd )  code   -- jhing 10.15.2015 modified condition for menu_line_cd field. Parameter will no longer be used .
                                  FROM giis_line
                                 WHERE line_cd = v_line_cd)
                LOOP
                  v_menu_line_cd := menu_line.code;
                END LOOP;
            
                IF v_menu_line_cd = 'AC' /*OR var_line_ac = v_line_cd*/ THEN  -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    GIUTS009_PKG.populate_accident(item.item_no); 
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                ELSIF v_menu_line_cd = 'AV' /*OR var_line_av = v_line_cd*/ THEN   -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    GIUTS009_PKG.populate_aviation(item.item_no);   
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);  
                ELSIF v_menu_line_cd = 'CA' /*OR var_line_ca = v_line_cd*/ THEN   -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    GIUTS009_PKG.populate_casualty(item.item_no); 
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                ELSIF v_menu_line_cd = 'FI' /*OR var_line_fi = v_line_cd*/ THEN     -- jhing 10.15.2015 modified condition. Parameter will no longer be used .           
                    GIUTS009_PKG.populate_fire(item.item_no);  
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                ELSIF v_menu_line_cd = 'MC' /*OR var_line_mc = v_line_cd*/ THEN   -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    GIUTS009_PKG.populate_motorcar(item.item_no);
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                ELSIF v_menu_line_cd = 'MN' /*OR var_line_mn = v_line_cd*/ THEN   -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    GIUTS009_PKG.populate_cargo(item.item_no);
                    GIUTS009_PKG.populate_vessel;
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                ELSIF v_menu_line_cd = 'MH' /*OR var_line_mh = v_line_cd*/ THEN    -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    GIUTS009_PKG.populate_hull(item.item_no);
                    GIUTS009_PKG.populate_vessel;
                    DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                ELSIF v_menu_line_cd = 'EN' /*OR var_line_en = v_line_cd*/ THEN   -- jhing 10.15.2015 modified condition. Parameter will no longer be used .
                    IF v_subline_cd = var_subline_bpv THEN 
                        GIUTS009_PKG.populate_location(item.item_no);
                        DBMS_OUTPUT.PUT_LINE(v_menu_line_cd);
                    END IF;   
                END IF;      
                
            ELSE
                 DELETE FROM gipi_witmperl
                    WHERE item_no = item.item_no
                    AND par_id  = copy_par_id;
                 DELETE FROM gipi_witem
                    WHERE item_no = item.item_no
                    AND par_id  = copy_par_id;
            END IF;                    
        END LOOP;
        IF (v_pol_line = var_line_mn OR v_menu_line_cd = 'MN') AND
            v_pol_subline = var_subline_mop THEN
             GIUTS009_PKG.populate_open_liab;
             GIUTS009_PKG.populate_open_peril;
             GIUTS009_PKG.populate_open_cargo;
             DBMS_OUTPUT.PUT_LINE('MN CARGO other values');
        END IF;
        
        IF policy_line_cd = var_line_en THEN
            GIUTS009_PKG.POPULATE_ENGG;
        END IF;
        IF policy_line_cd = var_line_su THEN
            GIUTS009_PKG.POPULATE_BOND;
        END IF;
		
		POPULATE_WARRANTIES;
		POPULATE_REQDOCS;
		POPULATE_MORTGAGEE;
		POPULATE_POLGENIN;
        
        GIUTS009_PKG.change_item_grp ( copy_par_id ); -- jhing 10.13.2015  GENQA 5033
          
    END POPULATE_OTHER_INFO;
    
    
    PROCEDURE POPULATE_PERIL (
        p_item_no              NUMBER
    ) IS
        v_row              NUMBER;
        item_exist         VARCHAR2(1); 
        
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_peril_cd         gipi_witmperl.peril_cd%TYPE;
        v_line_cd          gipi_witmperl.line_cd%TYPE;
        v_tarf_cd          gipi_witmperl.tarf_cd%TYPE;
        v_prem_rt          gipi_witmperl.prem_rt%TYPE;
        v_tsi_amt          gipi_witmperl.tsi_amt%TYPE;
        v_prem_amt         gipi_witmperl.prem_amt%TYPE;
        v_comp_rem         gipi_witmperl.comp_rem%TYPE;
        v_ri_comm_rate     gipi_witmperl.ri_comm_rate%TYPE;
        v_ri_comm_amt      gipi_witmperl.ri_comm_amt%TYPE;
        v_prt_flag         gipi_witmperl.prt_flag%TYPE;
        v_as_charge_sw     gipi_witmperl.as_charge_sw%TYPE;
        v_iss_cd_ri            giis_parameters.param_value_v%TYPE := giisp.v('ISS_CD_RI') ; 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;        
    BEGIN    
                        
        v_row := 1;
        FOR i IN pol 
        LOOP
            v_policy_id     := i.policy_id;
            v_row             := v_row + 1;
            
            FOR A IN ( 
                SELECT peril_cd,      prem_amt,        tsi_amt,
                       tarf_cd,       prem_rt,         comp_rem,
                       ri_comm_rate,  ri_comm_amt,     prt_flag,
                       as_charge_sw,  line_cd
                  FROM gipi_itmperil
                 WHERE item_no = p_item_no
                   AND policy_id = v_policy_id               
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN ( 
                    SELECT '1'
                       FROM gipi_witmperl
                      WHERE peril_cd = A.peril_cd
                        AND item_no  = p_item_no
                        AND par_id   = copy_par_id
                ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;
                
                IF item_exist = 'N' THEN                 
                    v_peril_cd         := A.peril_cd;
                    v_line_cd          := A.line_cd;
                    v_prem_amt         := A.prem_amt;
                    v_tsi_amt          := A.tsi_amt;
                    v_tarf_cd          := A.tarf_cd;
                    v_prem_rt          := A.prem_rt;
                    v_comp_rem         := A.comp_rem;
                    v_ri_comm_rate     := A.ri_comm_rate;
                    v_ri_comm_amt      := A.ri_comm_amt;
                    v_prt_flag         := A.prt_flag;
                    v_as_charge_sw     := A.as_charge_sw;
                    
                    FOR j IN  pol2 LOOP
                        IF J.rownum_ >= v_row THEN 
                            v_endt_id  := j.policy_id;
                            FOR DATA2 IN ( 
                                SELECT prem_amt,        tsi_amt,       as_charge_sw,
                                       tarf_cd,       prem_rt,         comp_rem,
                                       ri_comm_rate,  ri_comm_amt,     prt_flag                   
                                  FROM gipi_itmperil
                                WHERE peril_cd  = v_peril_cd
                                  AND item_no = p_item_no                         
                                  AND policy_id = v_endt_id
                            ) LOOP
                                IF v_policy_id <> v_endt_id THEN    
                                    v_prem_amt         := NVL(v_prem_amt,0) + NVL(data2.prem_amt,0);
                                    v_tsi_amt          := NVL(v_tsi_amt,0) + NVL(data2.tsi_amt,0);
                                    v_tarf_cd          := NVL(data2.tarf_cd, v_tarf_cd);
                                    IF NVL(data2.prem_rt,0) > 0 THEN
                                       v_prem_rt          := data2.prem_rt;
                                    END IF;   
                                    v_comp_rem         := NVL(data2.comp_rem, v_comp_rem);
                                    IF NVL(data2.ri_comm_rate,0) > 0 THEN
                                       v_ri_comm_rate     := data2.ri_comm_rate;
                                    END IF;   
                                    v_ri_comm_amt      := NVL(data2.ri_comm_amt,0)+ NVL(v_ri_comm_amt,0);
                                    v_prt_flag         := NVL(data2.prt_flag, v_prt_flag);
                                    v_as_charge_sw     := NVL(data2.as_charge_sw, v_as_charge_sw);
                                END IF;    
                            END LOOP;
                        END IF;
                    END LOOP;            
             
                    IF NVL(v_tsi_amt,0) > 0  THEN
                       
                       IF copy_par_iss_cd <>  v_iss_cd_ri THEN
                                  v_ri_comm_rate := NULL; 
                                  v_ri_comm_amt := NULL; 
                       END IF; 
                       
                        INSERT INTO gipi_witmperl (
                                par_id,            item_no,        peril_cd, 
                                line_cd,           tsi_amt,        prem_amt,
                                prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                tarf_cd,           comp_rem,       ri_comm_amt,
                                ri_comm_rate,      prt_flag,       as_charge_sw,
                                rec_flag)
                         VALUES(GIUTS009_PKG.copy_par_id,      p_item_no,      v_peril_cd,
                                v_line_cd,         v_tsi_amt,      v_prem_amt,
                                v_prem_rt,         v_tsi_amt,      v_prem_amt,
                                v_tarf_cd,         v_comp_rem,     v_ri_comm_amt,
                                v_ri_comm_rate,    v_prt_flag,     v_as_charge_sw,
                                'A');
                        v_peril_cd         := NULL;
                        v_line_cd          := NULL;
                        v_prem_amt         := NULL;
                        v_tsi_amt          := NULL;
                        v_tarf_cd          := NULL;
                        v_prem_rt          := NULL;
                        v_comp_rem         := NULL;
                        v_ri_comm_rate     := NULL;
                        v_ri_comm_amt      := NULL;
                        v_prt_flag         := NULL;
                        v_as_charge_sw     := NULL;  
                    END IF;                 
                ELSE
                    EXIT;             
                END IF;                        
            END LOOP;
            
        END LOOP;
      
    END POPULATE_PERIL;
    
    PROCEDURE POPULATE_DEDUCTIBLES (p_item_no              NUMBER) IS

        v_ded_line_cd           gipi_deductibles.ded_line_cd%TYPE;
        v_ded_subline_cd        gipi_deductibles.ded_subline_cd%TYPE;
        v_ded_deductible_cd     gipi_deductibles.ded_deductible_cd%TYPE;
        v_deductible_text       gipi_deductibles.deductible_text%TYPE;
        v_deductible_amt        gipi_deductibles.deductible_amt%TYPE;
        v_deductible_rt         gipi_deductibles.deductible_rt%TYPE;
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_peril_cd              gipi_deductibles.peril_cd%TYPE;
       
        exist                   VARCHAR2(1) := 'N';
        v_row                   NUMBER;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
      v_row := 1;
      FOR ROW_NO IN pol 
      LOOP
          v_policy_id      := ROW_NO.policy_id;
          v_row            := v_row + 1; 
          FOR A  IN 
              ( SELECT ded_line_cd,     ded_subline_cd,     ded_deductible_cd,
                       deductible_text, deductible_amt,     deductible_rt,
                       peril_cd
                  FROM gipi_deductibles
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no
             ) LOOP
             exist := 'N';    
             FOR CHK IN
                 ( SELECT '1'
                     FROM gipi_wdeductibles
                    WHERE ded_deductible_cd  = A.ded_deductible_cd
                      AND item_no = p_item_no
                      AND par_id  = copy_par_id
                  ) LOOP
                  exist := 'Y';
                  EXIT;
             END LOOP;
             IF exist = 'N' THEN
                    v_ded_line_cd          := A.ded_line_cd;
                    v_ded_subline_cd       := A.ded_subline_cd;
                    v_ded_deductible_cd    := A.ded_deductible_cd;
                    v_deductible_text      := A.deductible_text;  
                    v_deductible_amt       := NVL(A.deductible_amt,0);
                    v_deductible_rt        := NVL(A.deductible_rt,0);
                    v_peril_cd             := NVL(A.peril_cd,0);
                    
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN
                                 ( SELECT ded_line_cd,     ded_subline_cd,
                                        deductible_text, deductible_amt,
                                        deductible_rt,   peril_cd
                                   FROM gipi_deductibles
                                  WHERE ded_deductible_cd =  v_ded_deductible_cd
                                    AND item_no = p_item_no
                                    AND policy_id = v_endt_id
                                ) LOOP
                                    v_ded_line_cd          := NVL(data2.ded_line_cd, v_ded_line_cd);
                                    v_peril_cd             := NVL(data2.peril_cd, v_peril_cd);
                                    v_ded_subline_cd       := NVL(data2.ded_subline_cd, v_ded_subline_cd);
                                    v_deductible_text      := NVL(data2.deductible_text, v_deductible_text);  
                                    v_deductible_amt       := NVL(data2.deductible_amt,0) + v_deductible_amt;
                                    v_deductible_rt        := NVL(data2.deductible_rt,0) + v_deductible_rt;
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wdeductibles (
                            par_id,               item_no,          ded_line_cd,       ded_subline_cd,
                            ded_deductible_cd,    deductible_text,  deductible_amt,    deductible_rt,
                            peril_cd)
                    VALUES( copy_par_id,         p_item_no,         v_ded_line_cd,     v_ded_subline_cd,
                            v_ded_deductible_cd,  v_deductible_text, v_deductible_amt,  v_deductible_rt,
                            v_peril_cd);
                        v_ded_line_cd          := NULL;
                        v_peril_cd             := NULL;
                        v_ded_subline_cd       := NULL;
                        v_ded_deductible_cd    := NULL;
                        v_deductible_text      := NULL;
                        v_deductible_amt       := NULL;
                        v_deductible_rt        := NULL;
            END IF;                        
          END LOOP;
      END LOOP;           
    END POPULATE_DEDUCTIBLES;
    
    PROCEDURE populate_accident (
        p_item_no              NUMBER
    )IS

        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_date_of_birth    gipi_waccident_item.date_of_birth%TYPE;
        v_age              gipi_waccident_item.age%TYPE;
        v_civil_status     gipi_waccident_item.civil_status%TYPE;
        v_position_cd      gipi_waccident_item.position_cd%TYPE;
        v_monthly_salary   gipi_waccident_item.monthly_salary%TYPE;
        v_salary_grade     gipi_waccident_item.salary_grade%TYPE;
        v_no_of_persons    gipi_waccident_item.no_of_persons%TYPE;
        v_destination      gipi_waccident_item.destination%TYPE;
        v_height           gipi_waccident_item.height%TYPE;
        v_weight           gipi_waccident_item.weight%TYPE;
        v_sex              gipi_waccident_item.sex%TYPE;
        v_ac_class_cd      gipi_waccident_item.ac_class_cd%TYPE;
        v_group_print_sw   gipi_waccident_item.group_print_sw%TYPE;
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ; -- jhing 10.14.2015 GENQA 5033 
       
        exist                   VARCHAR2(1) := 'N';
        v_row                   NUMBER;
        item_exist              VARCHAR2(1); 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                        ORDER BY a.endt_seq_no ASC ;  -- jhing 10.14.2015 added order by 
        
        CURSOR pol2 (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no 
        IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a -- jhing 10.14.2015 added additional condition and ordering 
                               WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC; 
    BEGIN 
      v_row := 1;
      FOR ROW_NO IN pol 
      LOOP
          v_policy_id      := ROW_NO.policy_id;
          v_row            := v_row + 1; 
          v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
          
          FOR A  IN 
              ( SELECT  date_of_birth,        sex,            ac_class_cd,    
                    age,                  civil_status,   position_cd,
                    monthly_salary,       salary_grade,   no_of_persons,
                    destination,          height,         weight,
                    group_print_sw
                    FROM gipi_accident_item
                   WHERE item_no = p_item_no
                     AND policy_id = v_policy_id
             ) LOOP
             item_exist := 'N';
             FOR CHK IN
                 ( SELECT '1'
                   FROM gipi_waccident_item
                  WHERE item_no = p_item_no
                    AND par_id  = copy_par_id
                  ) LOOP
                  exist := 'Y';
                  EXIT;
             END LOOP;
             IF exist = 'N' THEN
                    v_date_of_birth    := A.date_of_birth;
                    v_age              := A.age; 
                    v_civil_status     := A.civil_status;
                    v_position_cd      := A.position_cd;
                    v_monthly_salary   := A.monthly_salary;
                    v_salary_grade     := A.salary_grade;
                    v_no_of_persons    := A.no_of_persons;
                    v_destination      := A.destination;
                    v_height           := A.height;
                    v_weight           := A.weight;
                    v_sex              := A.sex;
                    v_ac_class_cd      := A.ac_class_cd;
                    v_group_print_sw   := A.group_print_sw;
                    
                    FOR ROW_NO2 IN pol2 (v_temp_endt_no ) LOOP
                   --     IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                   --         IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN
                                 ( SELECT date_of_birth,        sex,            ac_class_cd,    
                                           age,                  civil_status,   position_cd,
                                           monthly_salary,       salary_grade,   no_of_persons,
                                           destination,          height,         weight,
                                           group_print_sw
                                      FROM gipi_accident_item
                                    WHERE item_no = p_item_no 
                                      AND policy_id = v_endt_id
                                ) LOOP
                                     v_date_of_birth    := NVL(data2.date_of_birth, v_date_of_birth);
                                     v_age              := NVL(data2.age, v_age); 
                                     v_civil_status     := NVL(data2.civil_status, v_civil_status);
                                     v_position_cd      := NVL(data2.position_cd, v_position_cd);
                                     v_monthly_salary   := NVL(data2.monthly_salary, v_monthly_salary);
                                     v_salary_grade     := NVL(data2.salary_grade, v_salary_grade);
                                     v_no_of_persons    := NVL(data2.no_of_persons, v_no_of_persons);
                                     v_destination      := NVL(data2.destination, v_destination);
                                     v_height           := NVL(data2.height, v_height);
                                     v_weight           := NVL(data2.weight, v_weight);
                                     v_sex              := NVL(data2.sex, v_sex);
                                     v_ac_class_cd      := NVL(data2.ac_class_cd, v_ac_class_cd);
                                     v_group_print_sw   := NVL(data2.group_print_sw, v_group_print_sw);
                                END LOOP;
                    --        END IF;
                    --    END IF;
                       EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_waccident_item (
                                par_id,               item_no,        date_of_birth, 
                                age,                  civil_status,   position_cd,
                                monthly_salary,       salary_grade,   no_of_persons,
                                destination,          height,         weight,
                                sex,                  ac_class_cd,    group_print_sw)
                        VALUES(copy_par_id,           p_item_no,      v_date_of_birth, 
                                v_age,                v_civil_status, v_position_cd,
                                v_monthly_salary,     v_salary_grade, v_no_of_persons,
                                v_destination,        v_height,       v_weight,
                                v_sex,                v_ac_class_cd,  v_group_print_sw);
                      GIUTS009_PKG.POPULATE_BENEFICIARY(p_item_no);
                      GIUTS009_PKG.POPULATE_GROUP_ITEMS(p_item_no);                   
                      v_date_of_birth    := NULL;
                      v_age              := NULL; 
                      v_civil_status     := NULL;
                      v_position_cd      := NULL;
                      v_monthly_salary   := NULL;
                      v_salary_grade     := NULL;
                      v_no_of_persons    := NULL;
                      v_destination      := NULL;
                      v_height           := NULL;
                      v_weight           := NULL;
                      v_sex              := NULL;
                      v_ac_class_cd      := NULL;
                      v_group_print_sw   := NULL;
            END IF;                        
          END LOOP;
      END LOOP;
      
      -- jhing 10.12.2015 added code to populate the enrollee coverage GENQA 5033 
      FOR GRP_ITEM IN (SELECT grouped_item_no
                                                          FROM gipi_wgrouped_items
                                                         WHERE par_id = copy_par_id
                                                           AND item_no = p_item_no) 
     LOOP
             GIUTS009_PKG.populate_peril_grp(p_item_no, grp_item.grouped_item_no);
                
     END LOOP;    
     
     -- update or correct the no. of persons based on enrollees (if applicable ) 
     
     FOR cur2 IN (SELECT COUNT(1) cntPerson 
                                                          FROM gipi_wgrouped_items
                                                         WHERE par_id = copy_par_id
                                                           AND item_no = p_item_no)
     LOOP
                UPDATE gipi_waccident_item 
                        SET no_of_persons = cur2.cntPerson
                        WHERE par_id = copy_par_id
                            AND item_no = p_item_no;     
     END LOOP;  
     
      -- jhing 10.17.2015 added code to update prem_rt of gipi_witmperl for items with enrollee coverage GENQA 5033 
     FOR grp IN ( SELECT DISTINCT   td.item_no FROM 
                                     gipi_witmperl_grouped tc , gipi_witem td 
                                       WHERE tc.par_id = copy_par_id
                                                    AND tc.par_id = td.par_id 
                                                    AND tc.item_no = td.item_no   )
      LOOP
           UPDATE gipi_witmperl
                    SET prem_rt = NULL 
                    WHERE par_id = copy_par_id
                          AND item_no = grp.item_no ;            
            EXIT; 
      END LOOP;     
      
   END populate_accident; 
   
    PROCEDURE POPULATE_BENEFICIARY (
        p_item_no              NUMBER
    ) IS
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        v_endt_id           gipi_polbasic.policy_id%TYPE;
        v_beneficiary_name  gipi_wbeneficiary.beneficiary_name%TYPE;
        v_beneficiary_addr  gipi_wbeneficiary.beneficiary_addr%TYPE;
        v_beneficiary_no    gipi_wbeneficiary.beneficiary_no%TYPE;
        v_relation          gipi_wbeneficiary.relation%TYPE;
        v_delete_sw         gipi_wbeneficiary.delete_sw%TYPE;
        v_remarks           gipi_wbeneficiary.remarks%TYPE;
        
        exist                   VARCHAR2(1) := 'N';
        v_row                   NUMBER;
        item_exist              VARCHAR2(1); 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR A IN 
            ( SELECT beneficiary_name,      beneficiary_addr,      relation,
                       delete_sw,             remarks,               beneficiary_no   
                  FROM gipi_beneficiary
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no
                   AND NVL(delete_sw, 'N') = 'N'
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wbeneficiary
                      WHERE beneficiary_no = a.beneficiary_no
                        AND item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                     v_beneficiary_no       :=  a.beneficiary_no;
                     v_beneficiary_name     :=  a.beneficiary_name;
                     v_beneficiary_addr     :=  a.beneficiary_addr;
                     v_relation             :=  a.relation;
                     v_delete_sw            :=  a.delete_sw;   
                     v_remarks              :=  a.remarks;
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT beneficiary_name,      beneficiary_addr,      relation,
                                         beneficiary_no,        delete_sw,             remarks   
                                    FROM gipi_beneficiary
                                   WHERE beneficiary_no = v_beneficiary_no
                                     AND item_no   = p_item_no
                                     AND policy_id = v_endt_id
                                ) LOOP
                                    v_beneficiary_name   :=  NVL(data2.beneficiary_name, v_beneficiary_name);
                                    v_beneficiary_addr   :=  NVL(data2.beneficiary_addr, v_beneficiary_addr);
                                    v_relation           :=  NVL(data2.relation, v_relation);
                                    v_delete_sw          :=  data2.delete_sw;
                                    v_remarks            :=  NVL(data2.remarks, v_remarks);
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    IF NVL(v_delete_sw, 'N') = 'N' THEN          
                        INSERT INTO gipi_wbeneficiary (
                                 par_id,             item_no,       beneficiary_no,   beneficiary_name,
                                 beneficiary_addr,   relation,      delete_sw,
                                 remarks)
                        VALUES ( copy_par_id,       p_item_no,     v_beneficiary_no, v_beneficiary_name,
                                 v_beneficiary_addr, v_relation,    v_delete_sw,
                                 v_remarks); 
                        v_beneficiary_no       :=  NULL;
                        v_beneficiary_name     :=  NULL;
                        v_beneficiary_addr     :=  NULL;
                        v_relation             :=  NULL;
                        v_delete_sw            :=  NULL;
                        v_remarks              :=  NULL;
                    END IF;       
                END IF;
                
            END LOOP;
        END LOOP;
    END POPULATE_BENEFICIARY;   
    
    PROCEDURE POPULATE_GROUP_ITEMS (
        p_item_no              NUMBER
    ) IS
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_grouped_item_no       gipi_wgrouped_items.grouped_item_no%TYPE;
        v_grouped_item_title    gipi_wgrouped_items.grouped_item_title%TYPE;
        v_amount_coverage       gipi_wgrouped_items.amount_covered%TYPE;
        v_include_tag           gipi_wgrouped_items.include_tag%TYPE;
        v_remarks               gipi_wgrouped_items.remarks%TYPE;
        v_line_cd               gipi_wgrouped_items.line_cd%TYPE;
        v_subline_cd            gipi_wgrouped_items.subline_cd%TYPE;
        v_sex                   gipi_wgrouped_items.sex%TYPE;
        v_position_cd           gipi_wgrouped_items.position_cd%TYPE;
        v_date_of_birth         gipi_wgrouped_items.date_of_birth%TYPE;
        v_age                   gipi_wgrouped_items.age%TYPE;
        v_salary                gipi_wgrouped_items.salary%TYPE;
        v_salary_grade          gipi_wgrouped_items.salary_grade%TYPE;
        v_civil_status          gipi_wgrouped_items.civil_status%TYPE;
        
        exist                   VARCHAR2(1) := 'N';
        v_row                   NUMBER;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR A IN ( 
                SELECT grouped_item_no,      grouped_item_title,
                       amount_coverage,      include_tag,
                       remarks,              line_cd,
                       subline_cd,           sex,
                       position_cd,          civil_status,
                       date_of_birth,        age, 
                       salary,               salary_grade
                  FROM gipi_grouped_items
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no
            ) LOOP
                exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wgrouped_items
                      WHERE grouped_item_no = A.grouped_item_no
                        AND item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(exist,'N') = 'N' THEN
                    v_grouped_item_no    := A.grouped_item_no;
                    v_grouped_item_title := A.grouped_item_title;
                    v_amount_coverage    := A.amount_coverage;
                    v_include_tag        := A.include_tag;
                    v_remarks            := A.remarks;
                    v_line_cd            := A.line_cd;
                    v_subline_cd         := A.subline_cd;
                    v_sex                := A.sex;
                    v_position_cd        := A.position_cd;
                    v_date_of_birth      := A.date_of_birth;
                    v_age                := A.age;
                    v_salary             := A.salary;
                    v_salary_grade       := A.salary_grade;
                    v_civil_status       := A.civil_status;
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT    grouped_item_title,
                                            amount_coverage,      include_tag,
                                            remarks,              line_cd,
                                            subline_cd,           sex,
                                            position_cd,          civil_status,
                                            date_of_birth,        age, 
                                            salary,               salary_grade        
                                       FROM gipi_grouped_items
                                      WHERE grouped_item_no =  v_grouped_item_no
                                        AND item_no = p_item_no
                                        AND policy_id = v_endt_id
                                ) LOOP
                                    v_grouped_item_title := NVL(data2.grouped_item_title, v_grouped_item_title);
                                    v_amount_coverage    := NVL(data2.amount_coverage, v_amount_coverage);
                                    v_include_tag        := NVL(data2.include_tag, v_include_tag);       
                                    v_remarks            := NVL(data2.remarks, v_remarks);
                                    v_line_cd            := NVL(data2.line_cd, v_line_cd);
                                    v_subline_cd         := NVL(data2.subline_cd, v_subline_cd);
                                    v_sex                := NVL(data2.sex, v_sex);
                                    v_position_cd        := NVL(data2.position_cd, v_position_cd);
                                    v_date_of_birth      := NVL(data2.date_of_birth, v_date_of_birth);
                                    v_age                := NVL(data2.age, v_age);
                                    v_salary             := NVL(data2.salary, v_salary);
                                    v_salary_grade       := NVL(data2.salary_grade, v_salary_grade);     
                                    v_civil_status       := NVL(data2.civil_status, v_civil_status);
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wgrouped_items (
                            par_id,               item_no,           grouped_item_no, 
                            grouped_item_title,   amount_covered,    include_tag,
                            remarks,              line_cd,           subline_cd,
                            sex,                  position_cd,       civil_status,
                            date_of_birth,        age,               salary,
                            salary_grade)
                    VALUES( copy_par_id,         p_item_no,         v_grouped_item_no, 
                            v_grouped_item_title, v_amount_coverage, v_include_tag,
                            v_remarks,            v_line_cd,         v_subline_cd,
                            v_sex,                v_position_cd,     v_civil_status,
                            v_date_of_birth,      v_age,             v_salary,
                            v_salary_grade);
                    GIUTS009_PKG.populate_grp_items_beneficiary(p_item_no, v_grouped_item_no);
                    v_grouped_item_no    := NULL;             
                    v_grouped_item_title := NULL;
                    v_amount_coverage    := NULL;
                    v_include_tag        := NULL;
                    v_remarks            := NULL;
                    v_line_cd            := NULL;
                    v_subline_cd         := NULL;
                    v_sex                := NULL;
                    v_position_cd        := NULL;
                    v_date_of_birth      := NULL;
                    v_age                := NULL;
                    v_salary             := NULL;
                    v_salary_grade       := NULL;
                    v_civil_status       := NULL;      
                END IF;
                
            END LOOP;
        END LOOP;
    END POPULATE_GROUP_ITEMS;  
    
    PROCEDURE populate_grp_items_beneficiary (
        p_item_no              NUMBER,
        p_grouped_item_no       NUMBER
    ) IS
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_grouped_item_no       gipi_wgrp_items_beneficiary.grouped_item_no%TYPE;
        v_beneficiary_no        gipi_wgrp_items_beneficiary.beneficiary_no%TYPE;
        v_beneficiary_name      gipi_wgrp_items_beneficiary.beneficiary_name%TYPE;
        v_beneficiary_addr      gipi_wgrp_items_beneficiary.beneficiary_addr%TYPE;
        v_sex                   gipi_wgrp_items_beneficiary.sex%TYPE;
        v_relation              gipi_wgrp_items_beneficiary.relation%TYPE;
        v_date_of_birth         gipi_wgrp_items_beneficiary.date_of_birth%TYPE;
        v_age                   gipi_wgrp_items_beneficiary.age%TYPE;
        v_civil_status          gipi_wgrp_items_beneficiary.civil_status%TYPE;
        
        exist                   VARCHAR2(1) := 'N';
        v_row                   NUMBER;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR A IN 
            (    SELECT grouped_item_no,      beneficiary_no,
                        beneficiary_name,     beneficiary_addr, 
                        relation,             sex,
                        civil_status,         date_of_birth,
                        age
                  FROM gipi_grp_items_beneficiary
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no
                   AND grouped_item_no = p_grouped_item_no
            ) LOOP
                exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wgrp_items_beneficiary
                      WHERE beneficiary_no = A.beneficiary_no
                        AND grouped_item_no = p_grouped_item_no
                        AND item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(exist,'N') = 'N' THEN
                    v_grouped_item_no    := A.grouped_item_no;
                    v_beneficiary_no     := A.beneficiary_no;
                    v_beneficiary_name   := A.beneficiary_name;
                    v_beneficiary_addr   := A.beneficiary_addr;
                    v_relation           := A.relation;
                    v_sex                := A.sex;
                    v_date_of_birth      := A.date_of_birth;
                    v_age                := A.age;
                    v_civil_status       := A.civil_status;
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT    grouped_item_no,      beneficiary_no,
                                            beneficiary_name,     beneficiary_addr, 
                                            relation,             sex,
                                            civil_status,         date_of_birth,
                                            age
                                       FROM gipi_grp_items_beneficiary
                                      WHERE beneficiary_no = v_beneficiary_no
                                        AND grouped_item_no =  v_grouped_item_no
                                        AND item_no = p_item_no
                                        AND policy_id = v_endt_id
                                ) LOOP
                                    v_beneficiary_name   := NVL(data2.beneficiary_name, v_beneficiary_name);
                                    v_beneficiary_addr   := NVL(data2.beneficiary_name, v_beneficiary_addr);
                                    v_relation           := NVL(data2.relation, v_relation);
                                    v_sex                := NVL(data2.sex, v_sex);
                                    v_date_of_birth      := NVL(data2.date_of_birth, v_date_of_birth);
                                    v_age                := NVL(data2.age, v_age);
                                    v_civil_status       := NVL(data2.civil_status, v_civil_status);
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wgrp_items_beneficiary (
                        par_id,               item_no,           grouped_item_no, 
                        beneficiary_no,       beneficiary_name,  beneficiary_addr,
                        relation,             sex,               civil_status,            
                        date_of_birth,        age)
                    VALUES( copy_par_id,         p_item_no,         v_grouped_item_no, 
                        v_beneficiary_no,     v_beneficiary_name,  v_beneficiary_addr,
                        v_relation,           v_sex,              v_civil_status,            
                        v_date_of_birth,      v_age);
                    v_grouped_item_no    := NULL;             
                    v_beneficiary_no     := NULL;
                    v_beneficiary_name   := NULL;
                    v_beneficiary_addr   := NULL;
                    v_relation           := NULL;
                    v_sex                := NULL;
                    v_date_of_birth      := NULL;
                    v_age                := NULL;
                    v_civil_status       := NULL;
                END IF;
                
            END LOOP;
        END LOOP;
    END populate_grp_items_beneficiary;  
    
    PROCEDURE POPULATE_AVIATION (
        p_item_no              NUMBER
    ) IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_vessel_cd        gipi_waviation_item.vessel_cd%TYPE;
        v_total_fly_time   gipi_waviation_item.total_fly_time%TYPE;
        v_qualification    gipi_waviation_item.qualification%TYPE;
        v_purpose          gipi_waviation_item.purpose%TYPE;
        v_geog_limit       gipi_waviation_item.geog_limit%TYPE;
        v_deduct_text      gipi_waviation_item.deduct_text%TYPE;
        v_fixed_wing       gipi_waviation_item.fixed_wing%TYPE;
        v_rotor            gipi_waviation_item.rotor%TYPE; 
        v_prev_util_hrs    gipi_waviation_item.prev_util_hrs%TYPE;
        v_est_util_hrs     gipi_waviation_item.est_util_hrs%TYPE;
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ; -- jhing 10.14.2015 GENQA 5033 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                         ORDER BY a.endt_seq_no ASC ;  -- jhing 10.14.2015 added order by 
        
        CURSOR pol2  (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no 
         IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                        -- jhing 10.14.2015 added additional condition and ordering 
                               WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
            
            FOR A IN 
            ( SELECT vessel_cd,     total_fly_time,  qualification, purpose,         geog_limit,
                       deduct_text,   fixed_wing,      rotor,         prev_util_hrs,   est_util_hrs
                FROM gipi_aviation_item
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_waviation_item
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_vessel_cd        := A.vessel_cd;
                    v_total_fly_time   := A.total_fly_time;
                    v_qualification    := A.qualification;
                    v_purpose          := A.purpose;
                    v_geog_limit       := A.geog_limit;
                    v_deduct_text      := A.deduct_text;
                    v_fixed_wing       := A.fixed_wing;
                    v_rotor            := A.rotor; 
                    v_prev_util_hrs    := A.prev_util_hrs;
                    v_est_util_hrs     := A.est_util_hrs;
                    FOR ROW_NO2 IN pol2  (v_temp_endt_no )  LOOP
                     --   IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                   --         IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT vessel_cd,     total_fly_time,  qualification, purpose,         geog_limit,
                                         deduct_text,   fixed_wing,      rotor,         prev_util_hrs,   est_util_hrs
                                    FROM gipi_aviation_item
                                   WHERE item_no = p_item_no 
                                     AND policy_id = v_endt_id
                                ) LOOP
                                    v_vessel_cd        := NVL(data2.vessel_cd, v_vessel_cd);
                                    v_total_fly_time   := NVL(data2.total_fly_time, v_total_fly_time);
                                    v_qualification    := NVL(data2.qualification, v_qualification);
                                    v_purpose          := NVL(data2.purpose, v_purpose);
                                    v_geog_limit       := NVL(data2.geog_limit, v_geog_limit);
                                    v_deduct_text      := NVL(data2.deduct_text, v_deduct_text);
                                    v_fixed_wing       := NVL(data2.fixed_wing, v_fixed_wing);
                                    v_rotor            := NVL(data2.rotor, v_rotor); 
                                    v_prev_util_hrs    := NVL(data2.prev_util_hrs, v_prev_util_hrs);
                                    v_est_util_hrs     := NVL(A.est_util_hrs, v_est_util_hrs);
                                END LOOP;
                   --         END IF;
                    --    END IF;
                        EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_waviation_item (
                           par_id,               item_no,         vessel_cd,
                           total_fly_time,       qualification,   purpose,
                           geog_limit,           deduct_text,     fixed_wing,
                           rotor,                prev_util_hrs,   est_util_hrs,
                           rec_flag )
                    VALUES(copy_par_id,         p_item_no,       v_vessel_cd,
                           v_total_fly_time,     v_qualification, v_purpose,
                           v_geog_limit,         v_deduct_text,   v_fixed_wing,
                           v_rotor,              v_prev_util_hrs, v_est_util_hrs,
                           'A');              
                    v_vessel_cd        := NULL;
                    v_total_fly_time   := NULL;
                    v_qualification    := NULL;
                    v_purpose          := NULL;
                    v_geog_limit       := NULL;
                    v_deduct_text      := NULL;
                    v_fixed_wing       := NULL;
                    v_rotor            := NULL; 
                    v_prev_util_hrs    := NULL;
                    v_est_util_hrs     := NULL;
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_AVIATION;     
    
    PROCEDURE POPULATE_CASUALTY (
        p_item_no              NUMBER
    ) IS
        item_exist                VARCHAR2(1); 
        v_row                     NUMBER;
        v_policy_id               gipi_polbasic.policy_id%TYPE;
        v_endt_id                 gipi_polbasic.policy_id%TYPE;
        v_section_line_cd         gipi_wcasualty_item.section_line_cd%TYPE; 
        v_section_subline_cd      gipi_wcasualty_item.section_subline_cd%TYPE;
        v_capacity_cd             gipi_wcasualty_item.capacity_cd%TYPE;
        v_section_or_hazard_cd    gipi_wcasualty_item.section_or_hazard_cd%TYPE;
        v_property_no             gipi_wcasualty_item.property_no%TYPE;
        v_property_no_type        gipi_wcasualty_item.property_no_type%TYPE;
        v_location                gipi_wcasualty_item.location%TYPE;
        v_conveyance_info         gipi_wcasualty_item.conveyance_info%TYPE;
        v_limit_of_liability      gipi_wcasualty_item.limit_of_liability%TYPE;
        v_interest_on_premises    gipi_wcasualty_item.interest_on_premises%TYPE;
        v_section_or_hazard_info  gipi_wcasualty_item.section_or_hazard_info%TYPE;
        v_location_cd                    gipi_wcasualty_item.location_cd%TYPE ; -- added by jhing 10.12.2015 GENQA 5033 
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ; -- jhing 10.14.2015 GENQA 5033 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                         ORDER BY a.endt_seq_no ASC ;  -- jhing 10.14.2015 added order by 
        
        CURSOR pol2 (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no
        IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                         -- jhing 10.14.2015 added additional condition and ordering 
                           WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC;  
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
            
            FOR A IN 
            (  SELECT section_line_cd,       section_subline_cd,
                     capacity_cd,           section_or_hazard_cd,
                     property_no,           property_no_type,
                     location,              conveyance_info,
                     limit_of_liability,    interest_on_premises,
                     section_or_hazard_info, location_cd   -- jhing 10.12.2015 added location_cd GENQA 5033 
                FROM gipi_casualty_item
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wcasualty_item
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_section_line_cd         := A.section_line_cd;
                    v_section_subline_cd      := A.section_subline_cd; 
                    v_capacity_cd             := A.capacity_cd; 
                    v_section_or_hazard_cd    := A.section_or_hazard_cd;
                    v_property_no             := A.property_no; 
                    v_property_no_type        := A.property_no_type;
                    v_location                := A.location;
                    v_conveyance_info         := A.conveyance_info;
                    v_limit_of_liability      := A.limit_of_liability;
                    v_interest_on_premises    := A.interest_on_premises;
                    v_section_or_hazard_info  := A.section_or_hazard_info;
                    v_location_cd                      := a.location_cd ;  -- jhing 10.12.2015 GENQA 5033 
                    FOR ROW_NO2 IN pol2 (v_temp_endt_no ) LOOP
                     --   IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                    --        IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT section_line_cd,       section_subline_cd,
                                         capacity_cd,           section_or_hazard_cd,
                                         property_no,           property_no_type,
                                         location,              conveyance_info,
                                         limit_of_liability,    interest_on_premises,
                                         section_or_hazard_info , location_cd  --- jhing added location_cd 10.12.2015 GENQA 5033 
                                    FROM gipi_casualty_item
                                   WHERE item_no = p_item_no 
                                     AND policy_id = v_endt_id
                                ) LOOP
                                    v_section_line_cd         := NVL(data2.section_line_cd, v_section_line_cd);
                                    v_section_subline_cd      := NVL(data2.section_subline_cd, v_section_subline_cd); 
                                    v_capacity_cd             := NVL(data2.capacity_cd, v_capacity_cd); 
                                    v_section_or_hazard_cd    := NVL(data2.section_or_hazard_cd, v_section_or_hazard_cd);
                                    v_property_no             := NVL(data2.property_no, v_property_no); 
                                    v_property_no_type        := NVL(data2.property_no_type, v_property_no_type);
                                    v_location                := NVL(data2.location, v_location);
                                    v_conveyance_info         := NVL(data2.conveyance_info, v_conveyance_info);
                                    v_limit_of_liability      := NVL(data2.limit_of_liability, v_limit_of_liability);
                                    v_interest_on_premises    := NVL(data2.interest_on_premises, v_interest_on_premises);
                                    v_section_or_hazard_info  := NVL(data2.section_or_hazard_info, v_section_or_hazard_info);
                                    v_location_cd                     := NVL(data2.location_cd, v_location_cd ); 
                                END LOOP;
                      --      END IF;
                      --  END IF;
                       EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_wcasualty_item(
                        par_id,                item_no,
                        section_line_cd,       section_subline_cd,
                        capacity_cd,           section_or_hazard_cd,
                        property_no,           property_no_type,
                        location,              conveyance_info,
                        limit_of_liability,    interest_on_premises,
                        section_or_hazard_info, location_cd )
                    VALUES( copy_par_id,          p_item_no,
                        v_section_line_cd,     v_section_subline_cd,
                        v_capacity_cd,         v_section_or_hazard_cd,
                        v_property_no,         v_property_no_type,
                        v_location,            v_conveyance_info,
                        v_limit_of_liability,  v_interest_on_premises,
                        v_section_or_hazard_info , v_location_cd );
                    GIUTS009_PKG.POPULATE_GROUP_ITEMS(p_item_no);
                    GIUTS009_PKG.POPULATE_PERSONNEL(p_item_no);         
                    v_section_line_cd         := NULL; 
                    v_section_subline_cd      := NULL; 
                    v_capacity_cd             := NULL; 
                    v_section_or_hazard_cd    := NULL;
                    v_property_no             := NULL; 
                    v_property_no_type        := NULL;
                    v_location                := NULL;
                    v_conveyance_info         := NULL;
                    v_limit_of_liability      := NULL;
                    v_interest_on_premises    := NULL;
                    v_section_or_hazard_info  := NULL;
                    v_location_cd := NULL; 
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_CASUALTY;
    
    PROCEDURE POPULATE_PERSONNEL (
        p_item_no              NUMBER
    ) IS
        v_row             NUMBER;
        item_exist        VARCHAR2(1) := 'N';
        exist             VARCHAR2(1) := 'N';
        v_name            gipi_wcasualty_personnel.name%TYPE;
        v_include_tag     gipi_wcasualty_personnel.include_tag%TYPE;
        v_capacity_cd     gipi_wcasualty_personnel.capacity_cd%TYPE;
        v_amount_covered  gipi_wcasualty_personnel.amount_covered%TYPE;
        v_remarks         gipi_wcasualty_personnel.remarks%TYPE;
        v_policy_id       gipi_polbasic.policy_id%TYPE;
        v_endt_id         gipi_polbasic.policy_id%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR A IN 
            ( SELECT personnel_no, name, include_tag,
                     capacity_cd,  NVL(amount_covered,0) amount_covered,
                     remarks
                FROM gipi_casualty_personnel
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wcasualty_personnel
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(exist,'N') = 'N' THEN
                    v_name           := a.name;
                    v_include_tag    := a.include_tag;
                    v_capacity_cd    := a.capacity_cd;
                    v_amount_covered := a.amount_covered;
                    v_remarks        := a.remarks;
                    
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT name, include_tag, capacity_cd,
                                         amount_covered, remarks
                                    FROM gipi_casualty_personnel
                                   WHERE policy_id = v_endt_id
                                     AND item_no = p_item_no
                                     AND personnel_no = a.personnel_no
                                ) LOOP
                                    v_name           := NVL(data2.name, v_name);
                                    v_include_tag    := NVL(data2.include_tag, v_include_tag);
                                    v_capacity_cd    := NVL(data2.capacity_cd, v_capacity_cd);
                                    v_amount_covered := NVL(data2.amount_covered,0) + v_amount_covered;
                                    v_remarks        := NVL(data2.remarks, v_remarks);
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wcasualty_personnel(
                         par_id,        item_no,       personnel_no,     name, 
                         include_tag,   capacity_cd,   amount_covered,   remarks)
                    VALUES( copy_par_id,  p_item_no,     a.personnel_no,   v_name, 
                         v_include_tag, v_capacity_cd, v_amount_covered, v_remarks);  
                    v_name           := NULL;
                    v_include_tag    := NULL;
                    v_capacity_cd    := NULL;
                    v_amount_covered := NULL;
                    v_remarks        := NULL;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_PERSONNEL;
    
    PROCEDURE POPULATE_FIRE (
        p_item_no              NUMBER
    ) IS
        v_row             NUMBER;
        item_exist        VARCHAR2(1) := 'N';
        exist             VARCHAR2(1) := 'N';
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_district_no           gipi_wfireitm.district_no%TYPE;
        v_eq_zone               gipi_wfireitm.eq_zone%TYPE;
        v_tarf_cd               gipi_wfireitm.tarf_cd%TYPE;
        v_block_no              gipi_wfireitm.block_no%TYPE;
        v_loc_risk1             gipi_wfireitm.loc_risk1%TYPE; 
        v_loc_risk2             gipi_wfireitm.loc_risk2%TYPE;
        v_fr_item_type          gipi_wfireitm.fr_item_type%TYPE;
        v_loc_risk3             gipi_wfireitm.loc_risk3%TYPE;
        v_tariff_zone           gipi_wfireitm.tariff_zone%TYPE;
        v_typhoon_zone          gipi_wfireitm.typhoon_zone%TYPE;
        v_front                 gipi_wfireitm.front%TYPE; 
        v_right                 gipi_wfireitm.right%TYPE;
        v_construction_cd       gipi_wfireitm.construction_cd%TYPE;
        v_left                  gipi_wfireitm.left%TYPE; 
        v_rear                  gipi_wfireitm.rear%TYPE; 
        v_construction_remarks  gipi_wfireitm.construction_remarks%TYPE;
        v_flood_zone            gipi_wfireitm.flood_zone%TYPE;
        v_occupancy_cd          gipi_wfireitm.occupancy_cd%TYPE;
        v_occupancy_remarks     gipi_wfireitm.occupancy_remarks%TYPE;
        v_assignee              gipi_wfireitm.assignee%TYPE;  
        v_block_id              gipi_wfireitm.block_id%TYPE;  
        -- jhing 10.14.2015 GENQA 5033 
        v_risk_cd                gipi_wfireitm.risk_cd%TYPE ; 
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ;
        v_latitude              gipi_wfireitm.latitude%TYPE;
        v_longitude             gipi_wfireitm.longitude%TYPE;
         
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                         ORDER BY a.endt_seq_no ASC ;  -- jhing 10.15.2015 added order by 
        
        CURSOR pol2 (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no 
        IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a  -- jhing 10.14.2015 added additional condition and ordering 
                               WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
            
            FOR A IN 
            ( SELECT district_no,       eq_zone,            tarf_cd,        block_no,
                     loc_risk1,         loc_risk2,          fr_item_type,   loc_risk3,
                     tariff_zone,       typhoon_zone,       front,          right,
                     construction_cd,   left,               rear,           construction_remarks,
                       flood_zone,        occupancy_cd,       assignee,       occupancy_remarks,
                       block_id, risk_cd,  latitude, longitude -- jhing 10.15.2015 added risk_cd  --latitude and longitude added by Jerome 11.14.2016 SR 5749
                FROM gipi_fireitem
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wfireitm
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(exist,'N') = 'N' THEN
                    v_district_no           := A.district_no;
                    v_eq_zone               := A.eq_zone;
                    v_tarf_cd               := A.tarf_cd;
                    v_block_no              := A.block_no;
                    v_loc_risk1             := A.loc_risk1; 
                    v_loc_risk2             := A.loc_risk2;
                    v_fr_item_type          := A.fr_item_type;
                    v_loc_risk3             := A.loc_risk3;
                    v_tariff_zone           := A.tariff_zone;
                    v_typhoon_zone          := A.typhoon_zone;
                    v_front                 := A.front; 
                    v_right                 := A.right;
                    v_construction_cd       := A.construction_cd;
                    v_left                  := A.left; 
                    v_rear                  := A.rear; 
                    v_construction_remarks  := A.construction_remarks;
                    v_flood_zone            := A.flood_zone;
                    v_occupancy_cd          := A.occupancy_cd;
                    v_occupancy_remarks     := A.occupancy_remarks;
                    v_assignee              := A.assignee;
                    v_block_id              := A.block_id;
                    v_risk_cd               := A.risk_cd; -- jhing 10.15.2015 GENQA 5033    
                    v_latitude              := A.latitude; --Added by Jerome 11.14.2016 SR 5749
                    v_longitude             := A.longitude; --Added by Jerome 11.14.2016 SR 5749
                 
                    FOR ROW_NO2 IN pol2 (v_temp_endt_no ) LOOP
                      --  IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                     --       IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT district_no,       eq_zone,            tarf_cd,        block_no,
                                         loc_risk1,         loc_risk2,          fr_item_type,   loc_risk3,
                                         tariff_zone,       typhoon_zone,       front,          right,
                                         construction_cd,   left,               rear,           construction_remarks,
                                         flood_zone,        occupancy_cd,       assignee,       occupancy_remarks,
                                         block_id, risk_cd, latitude, longitude -- jhing 10.15.2015 GENQA 5033 --latitude and longitude added by Jerome 11.14.2016 SR 5749
                                    FROM gipi_fireitem
                                   WHERE policy_id = v_endt_id
                                     AND item_no = p_item_no
                                ) LOOP
                                    v_district_no           := NVL(data2.district_no, v_district_no);
                                    v_eq_zone               := NVL(data2.eq_zone, v_eq_zone);
                                    v_tarf_cd               := NVL(data2.tarf_cd, v_tarf_cd);
                                    v_block_no              := NVL(data2.block_no, v_block_no);
                                    IF data2.loc_risk1 IS NOT NULL OR 
                                        data2.loc_risk2 IS NOT NULL OR
                                        data2.loc_risk3 IS NOT NULL THEN                           
                                        v_loc_risk1             := data2.loc_risk1; 
                                        v_loc_risk2             := data2.loc_risk2;
                                        v_loc_risk3             := data2.loc_risk3;
                                    END IF;
                                    
                                    v_fr_item_type          := NVL(data2.fr_item_type, v_fr_item_type);                       
                                    v_tariff_zone           := NVL(data2.tariff_zone, v_tariff_zone);
                                    v_typhoon_zone          := NVL(data2.typhoon_zone, v_typhoon_zone);
                                    v_front                 := NVL(data2.front, v_front); 
                                    v_right                 := NVL(data2.right, v_right);
                                    v_construction_cd       := NVL(data2.construction_cd, v_construction_cd);
                                    v_left                  := NVL(data2.left, v_left); 
                                    v_rear                  := NVL(data2.rear, v_rear); 
                                    v_construction_remarks  := NVL(data2.construction_remarks, v_construction_remarks);
                                    v_flood_zone            := NVL(data2.flood_zone, v_flood_zone);
                                    v_occupancy_cd          := NVL(data2.occupancy_cd, v_occupancy_cd);
                                    v_occupancy_remarks     := NVL(data2.occupancy_remarks, v_occupancy_remarks);
                                    v_assignee              := NVL(data2.assignee, v_assignee);
                                    v_block_id              := NVL(data2.block_id, v_block_id);
                                    v_risk_cd               := NVL(data2.risk_cd, v_risk_cd ) ; -- jhing 10.15.2015 GENQA 5033 
                                    v_latitude              := NVL(data2.latitude, v_latitude); --Added by Jerome 11.14.2016 SR 5749
                                    v_longitude             := NVL(data2.longitude, v_longitude); --Added by Jerome 11.14.2016 SR 5749
                                    
                                END LOOP;
                    --        END IF;
                    --    END IF;
                        EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_wfireitm (
                        par_id,               item_no,        district_no,
                        eq_zone,              tarf_cd,        block_no,
                        loc_risk1,            loc_risk2,      fr_item_type,
                        loc_risk3,            tariff_zone,    typhoon_zone,
                        front,                right,          construction_cd,
                        left,                 rear,           construction_remarks,
                        flood_zone,           occupancy_cd,   occupancy_remarks,
                        assignee,             block_id,       risk_cd,
                        latitude,             longitude)
                VALUES(copy_par_id,        p_item_no,      v_district_no,
                       v_eq_zone,          v_tarf_cd,      v_block_no,
                         v_loc_risk1,        v_loc_risk2,    v_fr_item_type,
                       v_loc_risk3,        v_tariff_zone,  v_typhoon_zone,
                       v_front,            v_right,        v_construction_cd,
                         v_left,             v_rear,         v_construction_remarks,
                       v_flood_zone,       v_occupancy_cd, v_occupancy_remarks,
                       v_assignee,         v_block_id,     v_risk_cd,
                       v_latitude,         v_longitude );
                --variables.fireitem_flag := 'N';
                v_district_no           := NULL;
                v_eq_zone               := NULL;
                v_tarf_cd               := NULL;
                v_block_no              := NULL;
                v_loc_risk1             := NULL; 
                v_loc_risk2             := NULL;
                v_fr_item_type          := NULL;
                v_loc_risk3             := NULL;
                v_tariff_zone           := NULL;
                v_typhoon_zone          := NULL;
                v_front                 := NULL; 
                v_right                 := NULL;
                v_construction_cd       := NULL;
                v_left                  := NULL; 
                v_rear                  := NULL; 
                v_construction_remarks  := NULL;
                v_flood_zone            := NULL;
                v_occupancy_cd          := NULL;
                v_occupancy_remarks     := NULL;
                v_assignee              := NULL;
                v_block_id              := NULL;
                v_risk_cd               := NULL; -- jhing 10.15.2015   
                v_latitude              := NULL;
                v_longitude             := NULL;     
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_FIRE;
    
    PROCEDURE POPULATE_MOTORCAR (
        p_item_no              NUMBER
    ) IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_subline_cd            gipi_wvehicle.subline_cd%TYPE;
        v_coc_yy                gipi_wvehicle.coc_yy%TYPE;
        v_coc_type              gipi_wvehicle.coc_type%TYPE;
        v_repair_lim            gipi_wvehicle.repair_lim%TYPE;
        v_color                 gipi_wvehicle.color%TYPE;
        v_motor_no              gipi_wvehicle.motor_no%TYPE;
        v_model_year            gipi_wvehicle.model_year%TYPE;
        v_make                  gipi_wvehicle.make%TYPE;
        v_mot_type              gipi_wvehicle.mot_type%TYPE;
        v_est_value             gipi_wvehicle.est_value%TYPE;
        v_serial_no             gipi_wvehicle.serial_no%TYPE;
        v_towing                gipi_wvehicle.towing%TYPE;
        v_assignee              gipi_wvehicle.assignee%TYPE;
        v_plate_no              gipi_wvehicle.plate_no%TYPE;
        v_no_of_pass            gipi_wvehicle.no_of_pass%TYPE;
        v_tariff_zone           gipi_wvehicle.tariff_zone%TYPE;
        v_coc_issue_date        gipi_wvehicle.coc_issue_date%TYPE;
        v_subline_type_cd       gipi_wvehicle.subline_type_cd%TYPE;
        v_ctv_tag               gipi_wvehicle.ctv_tag%TYPE;
        v_mv_file_no            gipi_wvehicle.mv_file_no%TYPE;
        v_car_company_cd        gipi_wvehicle.car_company_cd%TYPE;
        v_acquired_from         gipi_wvehicle.acquired_from%TYPE;
        v_basic_color_cd        gipi_wvehicle.basic_color_cd%TYPE;
        v_color_cd              gipi_wvehicle.color_cd%TYPE;
        v_series_cd             gipi_wvehicle.series_cd%TYPE;
        v_make_cd               gipi_wvehicle.make_cd%TYPE;
        v_unladen_wt            gipi_wvehicle.unladen_wt%TYPE;
        v_origin                gipi_wvehicle.origin%TYPE;
        v_destination           gipi_wvehicle.destination%TYPE;
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ; -- jhing 10.14.2015 GENQA 5033 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                          ORDER BY a.endt_seq_no ASC ;  -- jhing 10.14.2015 added order by 
        
        CURSOR pol2 (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no
         IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a  -- jhing 10.14.2015 added additional condition and ordering 
                               WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
            
            FOR A IN 
            ( SELECT subline_cd,
                     coc_yy,               coc_type,          repair_lim,    
                     color,                motor_no,          model_year,
                     make,                 mot_type,          est_value,      
                     serial_no,            towing,            assignee,       
                     plate_no,             no_of_pass,        tariff_zone,    
                     coc_issue_date,       subline_type_cd,   ctv_tag,
                      mv_file_no,           car_company_cd,    acquired_from,
                      basic_color_cd,       color_cd,          series_cd,
                      make_cd,              origin,             destination,
                      unladen_wt
                FROM gipi_vehicle
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wvehicle
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_subline_cd       := A.subline_cd;
                    v_coc_yy           := A.coc_yy;
                    v_coc_type         := A.coc_type; 
                    v_repair_lim       := A.repair_lim;
                    v_color            := A.color;
                    v_motor_no         := A.motor_no;
                    v_model_year       := A.model_year;
                    v_make             := A.make;
                    v_mot_type         := A.mot_type;
                    v_est_value        := A.est_value;
                    v_serial_no        := A.serial_no;
                    v_towing           := A.towing;
                    v_assignee         := A.assignee;
                    v_plate_no         := A.plate_no;
                    v_no_of_pass       := A.no_of_pass;
                    v_tariff_zone      := A.tariff_zone;
                    v_coc_issue_date   := A.coc_issue_date;       
                    v_subline_type_cd  := A.subline_type_cd;
                    v_ctv_tag          := A.ctv_tag;
                    v_mv_file_no       := A.mv_file_no;
                    v_car_company_cd   := A.car_company_cd;
                    v_acquired_from    := A.acquired_from;
                    v_basic_color_cd   := A.basic_color_cd;
                    v_color_cd         := A.color_cd;
                    v_series_cd        := A.series_cd;
                    v_make_cd          := A.make_cd;
                    v_unladen_wt       := A.unladen_wt;
                    v_origin           := A.origin;
                    v_destination      := A.destination;
                    FOR ROW_NO2 IN pol2 (v_temp_endt_no ) LOOP
                     --   IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                    --        IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT subline_cd,
                                         coc_yy,               coc_type,          repair_lim,    
                                         color,                motor_no,          model_year,
                                         make,                 mot_type,          est_value,      
                                         serial_no,            towing,            assignee,       
                                         plate_no,             no_of_pass,        tariff_zone,    
                                         coc_issue_date,       subline_type_cd,   ctv_tag,
                                         mv_file_no,           car_company_cd,    acquired_from,
                                         basic_color_cd,       color_cd,          series_cd,
                                         make_cd,              origin,            destination,
                                         unladen_wt
                                    FROM gipi_vehicle
                                   WHERE item_no = p_item_no 
                                     AND policy_id = v_endt_id
                                ) LOOP
                                    v_subline_cd       := NVL(data2.subline_cd, v_subline_cd);
                                    v_coc_yy           := NVL(data2.coc_yy, v_coc_yy);
                                    v_coc_type         := NVL(data2.coc_type, v_coc_type); 
                                    v_repair_lim       := NVL(data2.repair_lim, v_repair_lim);
                                    v_color            := NVL(data2.color, v_color);
                                    v_motor_no         := NVL(data2.motor_no,v_motor_no);
                                    v_model_year       := NVL(data2.model_year, v_model_year);
                                    v_make             := NVL(data2.make, v_make);
                                    v_mot_type         := NVL(data2.mot_type, v_mot_type);
                                    v_est_value        := NVL(data2.est_value, v_est_value);
                                    v_serial_no        := NVL(data2.serial_no, v_serial_no);
                                    v_towing           := NVL(data2.towing, v_towing);
                                    v_assignee         := NVL(data2.assignee, v_assignee);
                                    v_plate_no         := NVL(data2.plate_no, v_plate_no);
                                    v_no_of_pass       := NVL(data2.no_of_pass, v_no_of_pass);
                                    v_tariff_zone      := NVL(data2.tariff_zone, v_tariff_zone);
                                    v_coc_issue_date   := NVL(data2.coc_issue_date, v_coc_issue_date);       
                                    v_subline_type_cd  := NVL(data2.subline_type_cd, v_subline_type_cd);
                                    v_ctv_tag          := NVL(data2.ctv_tag, v_ctv_tag);
                                    v_mv_file_no       := NVL(data2.mv_file_no, v_mv_file_no);
                                    v_car_company_cd   := NVL(data2.car_company_cd, v_car_company_cd);
                                    v_acquired_from    := NVL(data2.acquired_from, v_acquired_from);
                                    v_basic_color_cd   := NVL(data2.basic_color_cd, v_basic_color_cd);
                                    v_color_cd         := NVL(data2.color_cd, v_color_cd);
                                    v_series_cd        := NVL(data2.series_cd, v_series_cd);
                                    v_make_cd          := NVL(data2.make_cd, v_make_cd);
                                    v_origin           := NVL(data2.origin, v_origin);
                                    v_destination      := NVL(data2.destination, v_destination);
                                    v_unladen_wt       := NVL(data2.unladen_wt, v_unladen_wt);
                           END LOOP;
                      --      END IF;
                       -- END IF;
                           EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_wvehicle(
                           par_id,               item_no,           subline_cd,
                           coc_yy,               coc_type,          repair_lim,    
                             color,                motor_no,          model_year,
                           make,                 mot_type,          est_value,      
                           serial_no,            towing,            assignee,       
                           plate_no,             no_of_pass,        tariff_zone,    
                              coc_issue_date,       subline_type_cd,   ctv_tag,
                            mv_file_no,           car_company_cd,    acquired_from,
                            basic_color_cd,       color_cd,          series_cd,
                            make_cd,              origin,            destination,
                            unladen_wt)          
                    VALUES(copy_par_id,          p_item_no,         v_subline_cd,
                           v_coc_yy,             v_coc_type,        v_repair_lim,   
                              v_color,              v_motor_no,        v_model_year,    
                           v_make,                  v_mot_type,        v_est_value,     
                           v_serial_no,            v_towing,          v_assignee,      
                           v_plate_no,           v_no_of_pass,      v_tariff_zone,  
                           v_coc_issue_date,     v_subline_type_cd, v_ctv_tag,
                            v_mv_file_no,         v_car_company_cd,  v_acquired_from,
                            v_basic_color_cd,     v_color_cd,        v_series_cd,
                            v_make_cd,            v_origin,          v_destination,
                            v_unladen_wt);
                    GIUTS009_PKG.POPULATE_ACCESSORY(p_item_no);        
                    v_subline_cd       := NULL;
                    v_coc_yy           := NULL;
                    v_coc_type         := NULL; 
                    v_repair_lim       := NULL;
                    v_color            := NULL;
                    v_motor_no         := NULL;
                    v_model_year       := NULL;
                    v_make             := NULL;
                    v_mot_type         := NULL;
                    v_est_value        := NULL;
                    v_serial_no        := NULL;
                    v_towing           := NULL;
                    v_assignee         := NULL;
                    v_plate_no         := NULL;
                    v_no_of_pass       := NULL;
                    v_tariff_zone      := NULL;
                    v_coc_issue_date   := NULL;       
                    v_subline_type_cd  := NULL;
                    v_ctv_tag          := NULL;
                    v_mv_file_no       := NULL;
                    v_car_company_cd   := NULL;
                    v_acquired_from    := NULL;
                    v_basic_color_cd   := NULL;
                    v_color_cd         := NULL;
                    v_series_cd        := NULL;
                    v_make_cd          := NULL;
                    v_origin           := NULL;
                    v_destination      := NULL;
                    v_unladen_wt       := NULL;
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_MOTORCAR; 
    
    PROCEDURE POPULATE_ACCESSORY (
        p_item_no              NUMBER
    ) IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_accessory_cd      gipi_mcacc.accessory_cd%TYPE;
        v_acc_amt           gipi_mcacc.acc_amt%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR A IN 
            ( SELECT accessory_cd, acc_amt
                FROM gipi_mcacc
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wmcacc
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                        AND accessory_cd = A.accessory_cd
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_acc_amt := a.acc_amt;
                    v_accessory_cd  := a.accessory_cd;
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                (  SELECT acc_amt
                                     FROM gipi_mcacc
                                    WHERE policy_id = v_endt_id
                                      AND item_no = p_item_no
                                      AND accessory_cd = v_accessory_cd
                                ) LOOP
                                    IF v_policy_id <> v_endt_id THEN    
                                        v_acc_amt := NVL(data2.acc_amt, v_acc_amt);                        
                                    END IF;  
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wmcacc( 
                            par_id,       item_no,   accessory_cd,     acc_amt, user_id, last_update)                      
                    VALUES( copy_par_id, p_item_no, v_accessory_cd,v_acc_amt, NVL(GIIS_USERS_PKG.app_user, USER), sysdate);
                    
                    v_accessory_cd := null;
                    v_acc_amt      := null; 
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_ACCESSORY;
    
    PROCEDURE POPULATE_CARGO (
        p_item_no              NUMBER
    ) IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id            gipi_polbasic.policy_id%TYPE;
        v_endt_id              gipi_polbasic.policy_id%TYPE;
        v_vessel_cd            gipi_wcargo.vessel_cd%TYPE;
        v_geog_cd              gipi_wcargo.geog_cd%TYPE;
        v_cargo_class_cd       gipi_wcargo.cargo_class_cd%TYPE;
        v_bl_awb               gipi_wcargo.bl_awb%TYPE;
        v_origin               gipi_wcargo.origin%TYPE;
        v_destn                gipi_wcargo.destn%TYPE;
        v_etd                  gipi_wcargo.etd%TYPE;
        v_eta                  gipi_wcargo.eta%TYPE;
        v_cargo_type           gipi_wcargo.cargo_type%TYPE;
        v_tranship_destination gipi_wcargo.tranship_destination%TYPE;
        v_deduct_text          gipi_wcargo.deduct_text%TYPE;
        v_pack_method          gipi_wcargo.pack_method%TYPE;
        v_print_tag            gipi_wcargo.print_tag%TYPE;
        v_tranship_origin      gipi_wcargo.tranship_origin%TYPE;
        v_voyage_no            gipi_wcargo.voyage_no%TYPE;
        v_lc_no                gipi_wcargo.lc_no%TYPE;
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ; -- jhing 10.14.2015 GENQA 5033 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                         ORDER BY a.endt_seq_no ASC ;  -- jhing 10.14.2015 added order by 
        
        CURSOR pol2 (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no 
        IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                        -- jhing 10.14.2015 added additional condition and ordering 
                               WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
            
            FOR A IN 
            ( SELECT cargo_class_cd,  bl_awb,        origin,      destn,
                     etd, eta,        cargo_type,    tranship_destination,
                     deduct_text,     pack_method,   print_tag,   tranship_origin,
                     vessel_cd,       geog_cd,       voyage_no,   lc_no
                FROM gipi_cargo
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wcargo
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_vessel_cd            := A.vessel_cd;
                    v_geog_cd              := A.geog_cd;
                    v_cargo_class_cd       := A.cargo_class_cd;
                    v_bl_awb               := A.bl_awb;  
                    v_origin               := A.origin;
                    v_destn                := A.destn;
                    v_etd                  := A.etd;
                    v_eta                  := A.eta;
                    v_cargo_type           := A.cargo_type;
                    v_tranship_destination := A.tranship_destination;
                    v_deduct_text          := A.deduct_text;
                    v_pack_method          := A.pack_method;
                    v_print_tag            := A.print_tag;
                    v_tranship_origin      := A.tranship_origin;
                    v_voyage_no            := A.voyage_no;
                    v_lc_no                := A.lc_no;
                    FOR ROW_NO2 IN pol2  (v_temp_endt_no ) LOOP
                     --   IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                     --       IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT cargo_class_cd,   bl_awb,        origin,      destn,
                                         etd, eta,         cargo_type,    tranship_destination,
                                         deduct_text,      pack_method,   print_tag,   tranship_origin,
                                         vessel_cd,        geog_cd,       voyage_no,   lc_no
                                    FROM gipi_cargo
                                   WHERE item_no = p_item_no 
                                     AND policy_id = v_endt_id
                                ) LOOP
                                     v_vessel_cd            := NVL(data2.vessel_cd, v_vessel_cd);
                                     v_geog_cd              := NVL(data2.geog_cd, v_geog_cd);
                                     v_cargo_class_cd       := NVL(data2.cargo_class_cd, v_cargo_class_cd);
                                     v_bl_awb               := NVL(data2.bl_awb, v_bl_awb);  
                                     v_origin               := NVL(data2.origin, v_origin);
                                     v_destn                := NVL(data2.destn, v_destn);
                                     v_etd                  := NVL(data2.etd, v_etd);
                                     v_eta                  := NVL(data2.eta, v_eta);
                                     v_cargo_type           := NVL(data2.cargo_type, v_cargo_type);
                                     v_tranship_destination := NVL(data2.tranship_destination, v_tranship_destination);
                                     v_deduct_text          := NVL(data2.deduct_text, v_deduct_text);
                                     v_pack_method          := NVL(data2.pack_method, v_pack_method);
                                     v_print_tag            := NVL(data2.print_tag, v_print_tag);
                                     v_tranship_origin      := NVL(data2.tranship_origin, v_tranship_origin);
                                     v_lc_no                := NVL(data2.lc_no, v_lc_no);
                                END LOOP;
                     --       END IF;
                     --   END IF;
                       EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_wcargo (
                             par_id,               item_no,       vessel_cd,   geog_cd,
                             cargo_class_cd,       bl_awb,        origin,      destn,
                             etd, eta,             cargo_type,    tranship_destination,
                             deduct_text,          pack_method,   print_tag,   tranship_origin,
                             voyage_no,            rec_flag,      lc_no) 
                    VALUES(  copy_par_id,          p_item_no,     v_vessel_cd, v_geog_cd,
                             v_cargo_class_cd,     v_bl_awb,      v_origin,    v_destn,
                             v_etd, v_eta,         v_cargo_type,  v_tranship_destination,
                             v_deduct_text,        v_pack_method, v_print_tag, v_tranship_origin,
                             v_voyage_no,          'A',           v_lc_no);        
                             
                    IF A.vessel_cd = v_vessel_cd THEN
                        GIUTS009_PKG.populate_carrier(p_item_no);
                    END IF;                         
                    
                    v_vessel_cd            := NULL;
                    v_geog_cd              := NULL;
                    v_cargo_class_cd       := NULL;
                    v_bl_awb               := NULL;  
                    v_origin               := NULL;
                    v_destn                := NULL;
                    v_etd                  := NULL;
                    v_eta                  := NULL;
                    v_cargo_type           := NULL;
                    v_tranship_destination := NULL;
                    v_deduct_text          := NULL;
                    v_pack_method          := NULL;
                    v_print_tag            := NULL;
                    v_tranship_origin      := NULL;
                    v_voyage_no            := NULL;
                    v_lc_no                := NULL;
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_CARGO;
    
    PROCEDURE POPULATE_CARRIER (
        p_item_no              NUMBER
    ) IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_vessel_cd                gipi_wcargo_carrier.vessel_cd%TYPE;
        v_voy_limit                gipi_wcargo_carrier.voy_limit%TYPE;
        v_vessel_limit_of_liab     gipi_wcargo_carrier.vessel_limit_of_liab%TYPE;
        v_eta                      gipi_wcargo_carrier.eta%TYPE;
        v_etd                      gipi_wcargo_carrier.etd%TYPE;
        v_origin                   gipi_wcargo_carrier.origin%TYPE;
        v_destn                    gipi_wcargo_carrier.destn%TYPE; 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR A IN 
            (  SELECT vessel_cd,    voy_limit,     vessel_limit_of_liab,
                     eta,          etd,           origin,
                     destn                  
                FROM gipi_cargo_carrier
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wcargo_carrier
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                        AND vessel_cd = A.vessel_cd
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_vessel_cd                := A.vessel_cd;
                    v_voy_limit                := A.voy_limit;
                    v_vessel_limit_of_liab     := A.vessel_limit_of_liab;
                    v_eta                      := A.eta;
                    v_etd                      := A.etd;
                    v_origin                   := A.origin;
                    v_destn                    := A.destn;  
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT vessel_cd,    voy_limit,     vessel_limit_of_liab,
                                         eta,          etd,           origin,  destn                  
                                    FROM gipi_cargo_carrier
                                   WHERE vessel_cd = v_vessel_cd 
                                     AND item_no = p_item_no 
                                     AND policy_id = v_endt_id
                                ) LOOP
                                    v_voy_limit                := NVL(data2.voy_limit, v_voy_limit);
                                    v_vessel_limit_of_liab     := NVL(data2.vessel_limit_of_liab, v_vessel_limit_of_liab);
                                    v_eta                      := NVL(data2.eta, v_eta);
                                    v_etd                      := NVL(data2.etd, v_etd);
                                    v_origin                   := NVL(data2.origin, v_origin);
                                    v_destn                    := NVL(data2.destn, v_destn);   
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wcargo_carrier
                           ( par_id,        item_no,    vessel_cd,   last_update,  user_id,
                             voy_limit,     vessel_limit_of_liab,    eta,          etd,
                             origin,        destn)
                       VALUES ( copy_par_id,  p_item_no,  v_vessel_cd, sysdate,      NVL(GIIS_USERS_PKG.app_user, USER),
                             v_voy_limit,   v_vessel_limit_of_liab,  v_eta,        v_etd,
                             v_origin,      v_destn);
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_CARRIER;
    
    PROCEDURE POPULATE_VESSEL IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;       
                
        
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR ves IN 
            ( SELECT vessel_cd,   vescon,   voy_limit
                FROM gipi_ves_air
               WHERE policy_id = v_policy_id   
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wves_air
                      WHERE par_id = copy_par_id
                            AND vessel_cd = ves.vessel_cd -- added by jhing 10.15.2015 GENQA 5033 
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    INSERT INTO gipi_wves_air( 
                         par_id,         vessel_cd,       vescon,      
                         voy_limit,      rec_flag)                      
                    VALUES(copy_par_id,   ves.vessel_cd,   ves.vescon,
                         ves.voy_limit,  'A');   
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_VESSEL;
    
    PROCEDURE POPULATE_HULL (
        p_item_no          GIPI_WITEM.item_no%TYPE
    ) IS
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_vessel_cd             gipi_witem_ves.vessel_cd%TYPE;
        v_geog_limit            gipi_witem_ves.geog_limit%TYPE;
        v_deduct_text           gipi_witem_ves.deduct_text%TYPE; 
        v_dry_date              gipi_witem_ves.dry_date%TYPE;
        v_dry_place             gipi_witem_ves.dry_place%TYPE;
        v_temp_endt_no      GIPI_POLBASIC.endt_seq_no%TYPE ; -- jhing 10.14.2015 GENQA 5033 
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a
                         ORDER BY a.endt_seq_no ASC ;  -- jhing 10.14.2015 added order by 
        
        CURSOR pol2  (p_temp_endt_seq_no GIPI_POLBASIC.endt_seq_no%TYPE )   -- jhing 10.14.2015 added parameter p_temp_endt_seq_no 
        IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a  -- jhing 10.14.2015 added additional condition and ordering 
                               WHERE a.endt_seq_no > p_temp_endt_seq_no
                                   AND NOT EXISTS(SELECT 'X'
                                             FROM gipi_polbasic m,
                                                  gipi_item  n
                                            WHERE m.line_cd         = policy_line_cd
                                              AND m.subline_cd      = policy_subline_cd
                                              AND m.iss_cd          = policy_iss_cd
                                              AND m.issue_yy        = policy_issue_yy
                                              AND m.pol_seq_no      = policy_pol_seq_no
                                              AND m.renew_no        = policy_renew_no
                                              AND m.endt_seq_no      > a.endt_seq_no
                                              AND NVL(m.back_stat,5) = 2
                                              AND m.policy_id        = n.policy_id
                                              AND n.item_no  = p_item_no )
                                              ORDER BY a.eff_date DESC; 
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            v_temp_endt_no := ROW_NO.endt_seq_no;  -- jhing 10.14.2015 GENQA 5033 
            
            FOR A IN 
            ( SELECT vessel_cd,    geog_limit,   deduct_text,    dry_date,   dry_place
                FROM gipi_item_ves
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_witem_ves
                      WHERE item_no = p_item_no
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_vessel_cd       := a.vessel_cd;
                    v_geog_limit      := a.geog_limit; 
                    v_deduct_text     := a.deduct_text;
                    v_dry_date        := a.dry_date;
                    v_dry_place       := a.dry_place; 
                    FOR ROW_NO2 IN pol2  (v_temp_endt_no )  LOOP
                      --  IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                      --      IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN       
                                ( SELECT vessel_cd,    geog_limit,   deduct_text,    dry_date,   dry_place
                                    FROM gipi_item_ves
                                   WHERE item_no = p_item_no 
                                     AND policy_id = v_endt_id
                                ) LOOP
                                    v_vessel_cd       := NVL(data2.vessel_cd, v_vessel_cd);
                                    v_geog_limit      := NVL(data2.geog_limit, v_geog_limit); 
                                    v_deduct_text     := NVL(data2.deduct_text, v_deduct_text);
                                    v_dry_date        := NVL(data2.dry_date, v_dry_date);
                                    v_dry_place       := NVL(data2.dry_place, v_dry_place); 
                                END LOOP;
                       --     END IF;
                     --   END IF;
                       EXIT; -- jhing 10.14.2015 GENQA 5033  
                    END LOOP;
                    
                    INSERT INTO gipi_witem_ves(
                            par_id,         item_no,    vessel_cd,    geog_limit,
                            deduct_text,    dry_date,   dry_place,    rec_flag)
                    VALUES(copy_par_id,    p_item_no,  v_vessel_cd,  v_geog_limit,
                            v_deduct_text,  v_dry_date, v_dry_place,  'A' ); 
                    v_vessel_cd       := NULL;
                    v_geog_limit      := NULL; 
                    v_deduct_text     := NULL;
                    v_dry_date        := NULL;
                    v_dry_place       := NULL; 
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_HULL;
    
    PROCEDURE POPULATE_LOCATION (
        p_item_no              NUMBER
    ) IS
        exist               VARCHAR2(1) := 'N';
        v_row               NUMBER;
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        v_region_cd         gipi_wlocation.region_cd%TYPE;
        v_province_cd       gipi_wlocation.province_cd%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR loc IN 
            ( SELECT  region_cd,   province_cd
                FROM gipi_location
               WHERE item_no = p_item_no
                 AND policy_id = v_policy_id    
            ) LOOP
                exist    := 'Y';
                v_region_cd    := NVL(loc.region_cd, v_region_cd);
                v_province_cd  := NVL(loc.province_cd, v_province_cd); 
            END LOOP;
        END LOOP;
        
        IF exist = 'Y' THEN 
            INSERT INTO gipi_wlocation( 
                      par_id,       item_no,   region_cd,    province_cd)                      
              VALUES( copy_par_id, p_item_no, v_region_cd,  v_province_cd);
        END IF; 
    END POPULATE_LOCATION;
    
    PROCEDURE POPULATE_OPEN_LIAB  IS
        exist                 VARCHAR2(1) := 'N';
        v_row                 NUMBER;
        v_policy_id           gipi_polbasic.policy_id%TYPE;
        v_limit_liability     gipi_wopen_liab.limit_liability%TYPE;
        v_voy_limit           gipi_wopen_liab.voy_limit%TYPE;
        v_prem_tag            gipi_wopen_liab.prem_tag%TYPE;
        v_with_invoice_tag    gipi_wopen_liab.with_invoice_tag%TYPE;
        v_currency_cd         gipi_wopen_liab.currency_cd%TYPE;
        v_currency_rt         gipi_wopen_liab.currency_rt%TYPE;
        v_geog_cd             gipi_wopen_liab.geog_cd%TYPE;
        v_multi_geog_tag      gipi_wopen_liab.multi_geog_tag%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR open_liab IN 
                ( SELECT limit_liability,       voy_limit,       prem_tag,
                         with_invoice_tag,      currency_cd,     currency_rt, 
                         geog_cd,               multi_geog_tag
                    FROM gipi_open_liab
                   WHERE policy_id = v_policy_id
                ) LOOP     
                    exist := 'Y';
                    v_limit_liability  := NVL(open_liab.limit_liability,0) +  NVL(v_limit_liability,0);
                    v_voy_limit        := NVL(open_liab.voy_limit, v_voy_limit);
                    v_prem_tag         := NVL(open_liab.prem_tag, v_prem_tag);
                    v_with_invoice_tag := NVL(open_liab.with_invoice_tag, v_with_invoice_tag);
                    v_currency_cd      := NVL(open_liab.currency_cd, v_currency_cd);
                    v_currency_rt      := NVL(open_liab.currency_rt, v_currency_rt);
                    v_geog_cd          := NVL(open_liab.geog_cd, v_geog_cd);
                    v_multi_geog_tag   := NVL(open_liab.multi_geog_tag, v_multi_geog_tag);
            END LOOP;   
        END LOOP;
        
        IF NVL(exist, 'N') = 'Y' THEN
            INSERT INTO gipi_wopen_liab( 
                 par_id,                geog_cd,        rec_flag,
                 limit_liability,       voy_limit,      prem_tag,
                 with_invoice_tag,      currency_cd,    currency_rt,
                 multi_geog_tag)                      
            VALUES( copy_par_id,          v_geog_cd,     'A',
                 v_limit_liability,     v_voy_limit,    v_prem_tag,
                 v_with_invoice_tag,    v_currency_cd,  v_currency_rt,
                 v_multi_geog_tag);      
            v_limit_liability  := NULL;
            v_voy_limit        := NULL;
            v_prem_tag         := NULL;
            v_with_invoice_tag := NULL;
            v_currency_cd      := NULL;
            v_currency_rt      := NULL;
            v_geog_cd          := NULL;
            v_multi_geog_tag   := NULL;
        END IF; 
    END POPULATE_OPEN_LIAB;
    
    PROCEDURE POPULATE_OPEN_PERIL IS
        item_exist                 VARCHAR2(1) := 'N';
        v_row               NUMBER;
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        v_endt_id           gipi_polbasic.policy_id%TYPE;
        v_peril_cd          gipi_wopen_peril.peril_cd%TYPE;
        v_line_cd           gipi_wopen_peril.line_cd%TYPE;
        v_prem_rate         gipi_wopen_peril.prem_rate%TYPE;
        v_remarks           gipi_wopen_peril.remarks%TYPE;
        v_with_invoice_tag  gipi_wopen_peril.with_invoice_tag%TYPE;
        v_geog_cd           gipi_wopen_peril.geog_cd%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR geog IN 
            ( SELECT geog_cd
                FROM gipi_wopen_liab
               WHERE par_id = copy_par_id
            ) LOOP
                 FOR DATA IN
                ( SELECT peril_cd,      prem_rate,      line_cd,
                         remarks,       with_invoice_tag
                    FROM gipi_open_peril
                   WHERE policy_id = v_policy_id  
                ) LOOP
                    item_exist := 'N';
                    FOR CHK_ITEM IN
                        ( SELECT '1'
                           FROM gipi_wopen_peril
                          WHERE peril_cd = data.peril_cd
                            AND par_id   = copy_par_id
                        ) LOOP
                        item_exist := 'Y';
                        EXIT;
                    END LOOP;
            
                    IF item_exist = 'N' THEN
                        v_peril_cd          := data.peril_cd;
                        v_line_cd           := data.line_cd;
                        v_prem_rate         := data.prem_rate;
                        v_remarks           := data.remarks;
                        v_with_invoice_tag  := data.with_invoice_tag;
                        
                        FOR ROW_NO2 IN pol2 LOOP
                            IF row_no.rownum_ >= v_row THEN
                                v_endt_id := row_no2.policy_id;
                                IF v_endt_id <> v_policy_id THEN
                                    FOR DATA2 IN       
                                    ( SELECT peril_cd,      prem_rate,      line_cd
                                             remarks,       with_invoice_tag
                                        FROM gipi_open_peril
                                       WHERE peril_cd  = v_peril_cd
                                         AND policy_id = v_endt_id
                                    ) LOOP
                                        IF v_policy_id <> v_endt_id THEN    
                                            IF NVL(data2.prem_rate,0) > 0 THEN
                                               v_prem_rate          := data2.prem_rate;
                                            END IF;   
                                            v_remarks           := NVL(data2.remarks, v_remarks);
                                            v_with_invoice_tag  := NVL(data2.with_invoice_tag, v_with_invoice_tag);
                                        END IF;  
                                    END LOOP;
                                END IF;
                            END IF;
                        END LOOP;
                        
                        INSERT INTO gipi_wopen_peril (
                            par_id,              peril_cd,      line_cd,
                            prem_rate,           remarks,       geog_cd,                             
                            with_invoice_tag,    rec_flag)
                        VALUES(copy_par_id,      v_peril_cd,    v_line_cd,
                            v_prem_rate,         v_remarks,     geog.geog_cd, 
                            v_with_invoice_tag,  'A');
                        v_peril_cd          := NULL;
                        v_line_cd           := NULL;
                        v_prem_rate         := NULL;
                        v_remarks           := NULL;
                        v_with_invoice_tag  := NULL;  
                    END IF;
                END LOOP;
            END LOOP;    
        END LOOP;
    END POPULATE_OPEN_PERIL;
    
    PROCEDURE POPULATE_OPEN_CARGO  IS
        exist               VARCHAR2(1) := 'N';
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        v_geog_cd           gipi_wopen_cargo.geog_cd%TYPE;
        v_cargo_class_cd    gipi_wopen_cargo.cargo_class_cd%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        FOR geog IN (SELECT geog_cd
                 FROM gipi_wopen_liab
                WHERE par_id = copy_par_id )
        LOOP
            FOR ROW_NO IN pol 
            LOOP
                v_policy_id      := ROW_NO.policy_id;
                
                FOR cargo IN 
                    ( SELECT cargo_class_cd
                        FROM gipi_open_cargo
                       WHERE policy_id = v_policy_id
                    ) LOOP     
                        exist   := 'Y';
                        FOR chk IN( SELECT '1'
                                       FROM gipi_wopen_cargo
                                      WHERE par_id = copy_par_id
                                        AND cargo_class_cd = cargo.cargo_class_cd)
                        LOOP
                            exist := 'Y';
                        END LOOP;
                        
                        IF NVL(exist, 'N') = 'N' THEN
                            INSERT INTO gipi_wopen_cargo( 
                                par_id,       geog_cd,       cargo_class_cd,       rec_flag)                      
                            VALUES( copy_par_id, geog.geog_cd,  cargo.cargo_class_cd,  'A');      
                        END IF;
                END LOOP;   
            END LOOP;
        END LOOP;
    END POPULATE_OPEN_CARGO;
    
    PROCEDURE POPULATE_OPEN_POLICY  IS
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        item_exist          VARCHAR2(1) := 'N';
        exist               VARCHAR2(1) := 'N';
        v_line_cd           gipi_wopen_policy.line_cd%TYPE; 
        v_op_subline_cd     gipi_wopen_policy.op_subline_cd%TYPE;
        v_op_iss_cd         gipi_wopen_policy.op_iss_cd%TYPE;
        v_op_pol_seqno      gipi_wopen_policy.op_pol_seqno%TYPE;
        v_op_renew_no       gipi_wopen_policy.op_renew_no%TYPE;
        v_decltn_no         gipi_wopen_policy.decltn_no%TYPE;
        v_eff_date          gipi_wopen_policy.eff_date%TYPE;
        v_op_issue_yy       gipi_wopen_policy.op_issue_yy%TYPE;
        v_row               NUMBER;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR open_pol IN 
                (  SELECT line_cd,   op_subline_cd,  
                          op_iss_cd, op_pol_seqno,   
                          decltn_no, eff_date,       
                          op_issue_yy, op_renew_no
                     FROM gipi_open_policy
                    WHERE policy_id = v_policy_id
                ) LOOP     
                    exist   := 'Y';
                    v_line_cd          := NVL(open_pol.line_cd,v_line_cd);          
                    v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
                    v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
                    v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
                    v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
                    v_eff_date         := NVL(open_pol.eff_date,v_eff_date);                
                    v_op_issue_yy      := NVL(open_pol.op_issue_yy,v_op_issue_yy);         
                    v_op_renew_no      := NVL(open_pol.op_renew_no,v_op_renew_no); 
            END LOOP;   
        END LOOP;
        
        IF NVL(exist, 'N') = 'Y' THEN
            INSERT INTO gipi_wopen_policy (
                   par_id,        line_cd,        op_subline_cd,
                   op_iss_cd,     op_pol_seqno,   op_renew_no,
                   decltn_no,     eff_date,       op_issue_yy)
            VALUES (copy_par_id,  v_line_cd,      v_op_subline_cd,
                   v_op_iss_cd,   v_op_pol_seqno, v_op_renew_no,
                   v_decltn_no,   v_eff_date,     v_op_issue_yy);
        END IF; 
    END POPULATE_OPEN_POLICY;
    
    PROCEDURE POPULATE_ENGG IS
        item_exist                  VARCHAR2(1) := 'N';
        exist1                      VARCHAR2(1) := 'N';
        
        v_policy_id                 gipi_polbasic.policy_id%TYPE;
        v_engg_basic_infonum        gipi_engg_basic.engg_basic_infonum%TYPE;                 
        v_contract_proj_buss_title  gipi_engg_basic.contract_proj_buss_title%TYPE;           
        v_site_location             gipi_engg_basic.site_location%TYPE;                      
        v_construct_start_date      gipi_engg_basic.construct_start_date%TYPE;               
        v_construct_end_date        gipi_engg_basic.construct_end_date%TYPE;                 
        v_maintain_start_date       gipi_engg_basic.maintain_start_date%TYPE;                
        v_maintain_end_date         gipi_engg_basic.maintain_end_date%TYPE;                  
        v_testing_start_date        gipi_engg_basic.testing_start_date%TYPE;                
        v_testing_end_date          gipi_engg_basic.testing_end_date%TYPE;                  
        v_weeks_test                gipi_engg_basic.weeks_test%TYPE;                         
        v_time_excess               gipi_engg_basic.time_excess%TYPE;                        
        v_mbi_policy_no             gipi_engg_basic.mbi_policy_no%TYPE;   
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            
            FOR engg IN (
                SELECT engg_basic_infonum, contract_proj_buss_title,       
                       site_location,      construct_start_date,           
                       construct_end_date, maintain_start_date,            
                       maintain_end_date,  weeks_test,                     
                       time_excess,        mbi_policy_no,
                       testing_end_date,   testing_start_date                  
                  FROM gipi_engg_basic
                 WHERE policy_id = v_policy_id)
            LOOP
                exist1 := 'Y';
                v_engg_basic_infonum        := NVL(engg.engg_basic_infonum,v_engg_basic_infonum);                 
                v_contract_proj_buss_title  := NVL(engg.contract_proj_buss_title,v_contract_proj_buss_title);           
                v_site_location             := NVL(engg.site_location,v_site_location);                      
                v_construct_start_date      := NVL(engg.construct_start_date,v_construct_start_date);               
                v_construct_end_date        := NVL(engg.construct_end_date,v_construct_end_date);                 
                v_maintain_start_date       := NVL(engg.maintain_start_date,v_maintain_start_date);            
                v_maintain_end_date         := NVL(engg.maintain_end_date,v_maintain_end_date);                      
                v_testing_end_date          := NVL(engg.testing_end_date,v_testing_end_date);                  
                v_testing_start_date        := NVL(engg.testing_start_date,v_testing_start_date);                
                v_weeks_test                := NVL(engg.weeks_test,v_weeks_test);                         
                v_time_excess               := NVL(engg.time_excess,v_time_excess);                        
                v_mbi_policy_no             := NVL(engg.mbi_policy_no,v_mbi_policy_no);                  
            END LOOP;  
        END LOOP;
        
        IF NVL(exist1, 'N') = 'Y' THEN
            INSERT INTO gipi_wengg_basic(
                     engg_basic_infonum,   contract_proj_buss_title,       
                     site_location,        construct_start_date,
                     construct_end_date,   maintain_start_date,
                     maintain_end_date,    weeks_test,
                     time_excess,          mbi_policy_no,
                     par_id,               testing_start_date,
                     testing_end_date) 
            VALUES( v_engg_basic_infonum, v_contract_proj_buss_title,       
                     v_site_location,      v_construct_start_date,
                     v_construct_end_date, v_maintain_start_date,
                     v_maintain_end_date,  v_weeks_test,
                     v_time_excess,        v_mbi_policy_no,
                     copy_par_id,         v_testing_start_date,
                     v_testing_end_date) ;
        END IF; 
    END POPULATE_ENGG;
    
    PROCEDURE populate_bond IS
        
        exist                   VARCHAR2(1) := 'N';
        exist2                  VARCHAR2(1) := 'N';
        v_policy_id             gipi_bond_basic.policy_id%TYPE;
        v_obligee_no            gipi_bond_basic.obligee_no%TYPE;
        v_prin_id               gipi_bond_basic.prin_id%TYPE;
        v_coll_flag             gipi_bond_basic.coll_flag%TYPE;
        v_clause_type           gipi_bond_basic.clause_type%TYPE;
        v_val_period_unit       gipi_bond_basic.val_period_unit%TYPE;
        v_val_period            gipi_bond_basic.val_period%TYPE;
        v_np_no                 gipi_bond_basic.np_no%TYPE;
        v_contract_dtl          gipi_bond_basic.contract_dtl%TYPE;
        v_contract_date         gipi_bond_basic.contract_date%TYPE;
        v_co_prin_sw            gipi_bond_basic.co_prin_sw%TYPE;
        v_waiver_limit          gipi_bond_basic.waiver_limit%TYPE;
        v_indemnity_text        gipi_bond_basic.indemnity_text%TYPE;
        v_bond_dtl              gipi_bond_basic.bond_dtl%TYPE;
        v_endt_eff_date         gipi_bond_basic.endt_eff_date%TYPE;
        v_remarks               gipi_bond_basic.remarks%TYPE;
        -- jhing 10.13.2015 added plaintiff, defendant and civil case no. - GENQA 5033 
        v_defendant_dtl     gipi_bond_basic.defendant_dtl%TYPE;
        v_plaintiff_dtl        gipi_bond_basic.plaintiff_dtl%TYPE;
        v_civil_case_no     gipi_bond_basic.civil_case_no%TYPE; 
        item_exist              VARCHAR2(1) := 'N';
        exist1                  VARCHAR2(1) := 'N';
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            
            FOR bond IN (
                SELECT obligee_no,      prin_id,       coll_flag,
                       clause_type,    val_period_unit, val_period,    np_no,
                       contract_dtl,   contract_date,   co_prin_sw,    waiver_limit,
                       indemnity_text, bond_dtl,        endt_eff_date, remarks,
                       defendant_dtl, plaintiff_dtl, civil_case_no  -- jhing 10.13.2015 added defendant, plaintiff, civil case no.  GENQA 5033
                 FROM gipi_bond_basic
                WHERE policy_id = V_policy_id)
            LOOP
                exist := 'Y';
                v_obligee_no         := NVL(bond.obligee_no,v_obligee_no);
                v_prin_id            := NVL(bond.prin_id,v_prin_id);
                v_coll_flag          := NVL(bond.coll_flag,v_coll_flag);
                v_clause_type        := NVL(bond.clause_type,v_clause_type);
                v_val_period_unit    := NVL(bond.val_period_unit,v_val_period_unit);
                v_val_period         := NVL(bond.val_period,v_val_period);
                v_np_no              := NVL(bond.np_no,v_contract_dtl);
                v_contract_dtl       := NVL(bond.contract_dtl,v_contract_dtl);
                v_contract_date      := NVL(bond.contract_date,v_contract_date);
                v_co_prin_sw         := NVL(bond.co_prin_sw,v_co_prin_sw);
                v_waiver_limit       := NVL(bond.waiver_limit,v_waiver_limit);
                v_indemnity_text     := NVL(bond.indemnity_text,v_indemnity_text);
                v_bond_dtl           := NVL(bond.bond_dtl,v_bond_dtl);
                v_endt_eff_date      := NVL(bond.endt_eff_date,v_endt_eff_date);
                v_remarks            := NVL(bond.remarks,v_remarks);
                v_defendant_dtl := NVL(bond.defendant_dtl, v_defendant_dtl );
                v_plaintiff_dtl := NVL(bond.plaintiff_dtl , v_plaintiff_dtl ) ; 
                v_civil_case_no := NVL(bond.civil_case_no , v_civil_case_no ); 
            END LOOP;
        END LOOP;
        
        IF NVL(exist, 'N') = 'Y' THEN
            INSERT INTO gipi_wbond_basic(
                 par_id,           obligee_no,    prin_id,    
                 coll_flag,        clause_type,   val_period_unit, 
                 val_period,       np_no,         contract_dtl,       
                 contract_date,    co_prin_sw,    waiver_limit,       
                 indemnity_text,   bond_dtl,      endt_eff_date,      
                 remarks, plaintiff_dtl, defendant_dtl, civil_case_no ) 
            VALUES( copy_par_id,     v_obligee_no,  v_prin_id,    
                 v_coll_flag,      v_clause_type, v_val_period_unit, 
                 v_val_period,     v_np_no,       v_contract_dtl,       
                 v_contract_date,  v_co_prin_sw,  v_waiver_limit,       
                 v_indemnity_text, v_bond_dtl,    v_endt_eff_date,      
                 v_remarks, v_plaintiff_dtl, v_defendant_dtl , v_civil_case_no );
        END IF; 
    END populate_bond;
    
    PROCEDURE POPULATE_WARRANTIES IS
        
        item_exist          VARCHAR2(1) := 'N';
        exist1              VARCHAR2(1) := 'N';
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        v_endt_id           gipi_polbasic.policy_id%TYPE;
        v_row               NUMBER;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
                        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR wc IN (
                 SELECT line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title,
                        wc_text01,wc_text02,wc_text03,wc_text04,
                        wc_text05,wc_text06,wc_text07,wc_text08,
                        wc_text09,wc_text10,wc_text11,wc_text12,
                        wc_text13,wc_text14,wc_text15,wc_text16,
                        wc_text17,wc_remarks, change_tag, print_sw
                   FROM gipi_polwc
                  WHERE policy_id = v_policy_id
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                        FROM gipi_wpolwc
                       WHERE par_id = copy_par_id 
                         AND line_cd = wc.line_cd
                         AND wc_cd  = wc.wc_cd
                         AND swc_seq_no = wc.swc_seq_no
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                
                                FOR wc2 IN ( 
                                    SELECT print_seq_no, wc_title,
                                          wc_text01,wc_text02,wc_text03,wc_text04,
                                          wc_text05,wc_text06,wc_text07,wc_text08,
                                          wc_text09,wc_text10,wc_text11,wc_text12,
                                          wc_text13,wc_text14,wc_text15,wc_text16,
                                          wc_text17,wc_remarks, change_tag, print_sw
                                     FROM gipi_polwc
                                    WHERE policy_id = v_endt_id
                                      AND line_cd = wc.line_cd
                                        AND wc_cd  = wc.wc_cd
                                        AND swc_seq_no = wc.swc_seq_no)
                                LOOP
                                    wc.change_tag := wc2.change_tag;
                                    wc.wc_title   := wc2.wc_title; 
                                    wc.wc_text01  := wc2.wc_text01;
                                    wc.wc_text02  := wc2.wc_text02;
                                    wc.wc_text03  := wc2.wc_text03;
                                    wc.wc_text04  := wc2.wc_text04;
                                    wc.wc_text05  := wc2.wc_text05;
                                    wc.wc_text06  := wc2.wc_text06;
                                    wc.wc_text07  := wc2.wc_text07;
                                    wc.wc_text08  := wc2.wc_text08;
                                    wc.wc_text09  := wc2.wc_text09;
                                    wc.wc_text10  := wc2.wc_text10;
                                    wc.wc_text11  := wc2.wc_text11;
                                    wc.wc_text12  := wc2.wc_text12;
                                    wc.wc_text13  := wc2.wc_text13;
                                    wc.wc_text14  := wc2.wc_text14;
                                    wc.wc_text15  := wc2.wc_text15;
                                    wc.wc_text16  := wc2.wc_text16;
                                    wc.wc_text17  := wc2.wc_text17;
                                    wc.wc_remarks := NVL(wc2.wc_remarks, wc.wc_remarks);
                                    wc.print_sw   := wc2.print_sw;
                                END LOOP;
                                
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wpolwc(
                           par_id,                 line_cd,   
                           swc_seq_no,             print_seq_no,
                           wc_title,               wc_text01, 
                           wc_text02,              wc_text03,
                           wc_text04,              wc_text05,
                           wc_text06,              wc_text07,
                           wc_text08,              wc_text09,
                           wc_text10,              wc_text11,
                           wc_text12,              wc_text13,
                           wc_text14,              wc_text15,
                           wc_text16,              wc_text17,
                           wc_remarks,             wc_cd,
                           change_tag,             print_sw)        
                    VALUES( copy_par_id,           wc.line_cd, 
                           wc.swc_seq_no,          wc.print_seq_no,
                           wc.wc_title,            wc.wc_text01,
                           wc.wc_text02,           wc.wc_text03,
                           wc.wc_text04,           wc.wc_text05, 
                           wc.wc_text06,           wc.wc_text07,
                           wc.wc_text08,           wc.wc_text09, 
                           wc.wc_text10,           wc.wc_text11,
                           wc.wc_text12,           wc.wc_text13, 
                           wc.wc_text14,           wc.wc_text15,
                           wc.wc_text16,           wc.wc_text17, 
                           wc.wc_remarks,          wc.wc_cd,
                           wc.change_tag,          wc.print_sw);
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_WARRANTIES;
    
    PROCEDURE POPULATE_REQDOCS IS
        
        item_exist              VARCHAR2(1); 
        v_row                   NUMBER;
        v_policy_id             gipi_polbasic.policy_id%TYPE;
        v_endt_id               gipi_polbasic.policy_id%TYPE;
        v_doc_cd                gipi_wreqdocs.doc_cd%TYPE;
        v_doc_sw                gipi_wreqdocs.doc_sw%TYPE;
        v_line_cd               gipi_wreqdocs.line_cd%TYPE;
        v_date_submitted        gipi_wreqdocs.date_submitted%TYPE;
        v_remarks               gipi_wreqdocs.remarks%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
                        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR docs IN (
                  SELECT doc_cd, doc_sw, line_cd, date_submitted, remarks
                    FROM gipi_reqdocs
                   WHERE policy_id = v_policy_id    
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wreqdocs
                      WHERE doc_cd  = docs.doc_cd
                        AND par_id  = copy_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_doc_cd         := docs.doc_cd;
                    v_doc_sw         := docs.doc_sw;
                    v_line_cd        := docs.line_cd;
                    v_date_submitted := docs.date_submitted;
                    v_remarks        := docs.remarks;
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                
                                FOR docs2 IN ( 
                                    SELECT doc_sw, line_cd, date_submitted, remarks
                                      FROM gipi_reqdocs
                                     WHERE doc_cd    = v_doc_cd
                                       AND policy_id = v_endt_id)
                                LOOP
                                    v_doc_sw         := NVL(docs2.doc_sw, v_doc_sw);
                                    v_line_cd        := NVL(docs2.line_cd, v_line_cd);
                                    v_date_submitted := NVL(docs2.date_submitted, v_date_submitted);
                                    v_remarks        := NVL(docs2.remarks, v_remarks);
                                END LOOP;
                                
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO gipi_wreqdocs(
                            par_id,         doc_cd,       doc_sw,       date_submitted,
                            line_cd,        remarks,      user_id,      last_update)
                    VALUES(copy_par_id,    v_doc_cd,     v_doc_sw,     v_date_submitted,
                            v_line_cd,      v_remarks,    NVL(GIIS_USERS_PKG.app_user, USER), sysdate); 
                         v_doc_cd         := NULL;
                         v_doc_sw         := NULL;
                         v_line_cd        := NULL;
                         v_date_submitted := NULL;
                         v_remarks        := NULL;
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_REQDOCS;
    
    PROCEDURE POPULATE_MORTGAGEE IS
        item_exist         VARCHAR2(1); 
        insert_sw          VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_iss_cd           gipi_wmortgagee.iss_cd%TYPE;
        v_mortg_cd         gipi_wmortgagee.mortg_cd%TYPE;
        v_item_no          gipi_wmortgagee.item_no%TYPE;  
        v_amount           gipi_wmortgagee.amount%TYPE;
        v_remarks          gipi_wmortgagee.remarks%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
                        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR mort IN (
                SELECT NVL(item_no,0) item_no,  mortg_cd, amount,
                       remarks,      iss_cd
                  FROM gipi_mortgagee
                 WHERE (NVL(item_no,0) = 0 
                    OR item_no  in ( SELECT item_no
                                       FROM gipi_witem
                                      WHERE par_id = copy_par_id))
                   AND policy_id = v_policy_id
                   AND iss_cd    = policy_iss_cd  
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wmortgagee
                      WHERE mortg_cd = mort.mortg_cd
                        AND item_no  = mort.item_no
                        AND par_id   = copy_par_id
                        AND iss_cd   = policy_iss_cd
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;    

                IF NVL(item_exist,'N') = 'N' THEN
                    v_mortg_cd         := mort.mortg_cd;
                    v_item_no          := mort.item_no;
                    v_amount           := nvl(mort.amount,0);
                    v_remarks          := mort.remarks;             
                    v_iss_cd           := mort.iss_cd;
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                            v_endt_id := row_no2.policy_id;
                            IF v_endt_id <> v_policy_id THEN
                                
                                FOR mort2 IN ( 
                                    SELECT remarks, amount, iss_cd
                                      FROM gipi_mortgagee
                                    WHERE mortg_cd       = v_mortg_cd
                                      AND nvl(item_no,0) = nvl(v_item_no,0)                     
                                      AND policy_id      = v_endt_id
                                      AND iss_cd         = policy_iss_cd
                                ) LOOP
                                    IF v_policy_id <> v_endt_id THEN    
                                        v_amount         := NVL(v_amount,0) + NVL(mort2.amount,0);
                                        v_remarks        := NVL(mort2.remarks, v_remarks);
                                        v_iss_cd         := NVL(mort2.iss_cd, v_iss_cd);
                                    END IF;
                                END LOOP;
                                
                            END IF;
                        END IF;
                    END LOOP;
                    
                    insert_sw := 'Y';
                    IF NVL(v_item_no,0) > 0 THEN
                        insert_sw := 'N';
                        FOR CHK_VALID IN
                          ( SELECT '1'
                              FROM gipi_witem
                             WHERE item_no = v_item_no
                               AND par_id  = copy_par_id
                           ) LOOP  
                            insert_sw := 'Y';
                        END LOOP;          
                    END IF;
                    
                    IF NVL(insert_sw, 'Y') = 'Y' THEN  --if1
                        IF v_amount = 0 THEN
                            v_amount := NULL;
                        END IF;
                        
                        INSERT INTO gipi_wmortgagee (
                                par_id,            iss_cd,         mortg_cd,
                                item_no,           amount,         remarks,
                                last_update,       user_id)
                         VALUES(copy_par_id,      v_iss_cd,       v_mortg_cd,
                                v_item_no,         v_amount,       v_remarks,
                                sysdate,           NVL(GIIS_USERS_PKG.app_user, USER));
                    END IF;  --/if1
                    
                    v_mortg_cd         := NULL;
                    v_iss_cd           := NULL;
                    v_amount           := NULL;
                    v_item_no          := NULL;
                    v_remarks          := NULL;
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END POPULATE_MORTGAGEE;
    
    PROCEDURE POPULATE_POLGENIN IS
        
        v_policy_id         gipi_polbasic.policy_id%TYPE;
        v_gen_info          gipi_polgenin.gen_info%TYPE;
        v_first_info        gipi_wpolgenin.first_info%TYPE;  
        exist               VARCHAR2(1) := 'N';
        v_initial_info01       gipi_wpolgenin.initial_info01%TYPE;
        v_initial_info02     gipi_wpolgenin.initial_info02%TYPE;
        v_initial_info03     gipi_wpolgenin.initial_info03%TYPE;
        v_initial_info04       gipi_wpolgenin.initial_info04%TYPE;
        v_initial_info05        gipi_wpolgenin.initial_info05%TYPE;
        v_initial_info06     gipi_wpolgenin.initial_info06%TYPE;
        v_initial_info07        gipi_wpolgenin.initial_info07%TYPE;
        v_initial_info08     gipi_wpolgenin.initial_info08%TYPE;
        v_initial_info09     gipi_wpolgenin.initial_info09%TYPE;
        v_initial_info10     gipi_wpolgenin.initial_info10%TYPE;
        v_initial_info11     gipi_wpolgenin.initial_info11%TYPE;
        v_initial_info12     gipi_wpolgenin.initial_info12%TYPE;
        v_initial_info13     gipi_wpolgenin.initial_info13%TYPE;
        v_initial_info14     gipi_wpolgenin.initial_info14%TYPE;
        v_initial_info15     gipi_wpolgenin.initial_info15%TYPE;
        v_initial_info16     gipi_wpolgenin.initial_info16%TYPE;
        v_initial_info17     gipi_wpolgenin.initial_info17%TYPE;
        
        v_long              gipi_wpolgenin.gen_info%TYPE;
        v_long2              gipi_wpolgenin.gen_info%TYPE;
        v_gen01             gipi_wpolgenin.gen_info01%TYPE;
        v_gen02             gipi_wpolgenin.gen_info01%TYPE; 
        v_gen03              gipi_wpolgenin.gen_info01%TYPE;
        v_gen04             gipi_wpolgenin.gen_info01%TYPE;
        v_gen05              gipi_wpolgenin.gen_info01%TYPE;
        v_gen06              gipi_wpolgenin.gen_info01%TYPE;
        v_gen07              gipi_wpolgenin.gen_info01%TYPE;
        v_gen08              gipi_wpolgenin.gen_info01%TYPE;
        v_gen09             gipi_wpolgenin.gen_info01%TYPE;
        v_gen10              gipi_wpolgenin.gen_info01%TYPE;
        v_gen11              gipi_wpolgenin.gen_info01%TYPE;
        v_gen12              gipi_wpolgenin.gen_info01%TYPE;
        v_gen13              gipi_wpolgenin.gen_info01%TYPE;
        v_gen14             gipi_wpolgenin.gen_info01%TYPE;
        v_gen15              gipi_wpolgenin.gen_info01%TYPE;
        v_gen16              gipi_wpolgenin.gen_info01%TYPE;
        v_gen17              gipi_wpolgenin.gen_info01%TYPE;
        
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            
            FOR INFO IN (
                SELECT first_info
                  FROM gipi_polgenin
                 WHERE policy_id = v_policy_id
            ) LOOP
                v_long2 := null;
                SELECT gen_info, gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, 
                     gen_info06, gen_info07, gen_info08, gen_info09, gen_info10, gen_info11,
                     gen_info12, gen_info13, gen_info14, gen_info15, gen_info16, gen_info17,
                     first_info, 
                     initial_info01, initial_info02,
                     initial_info03, initial_info04, initial_info05, initial_info06, 
                     initial_info07, initial_info08, initial_info09, initial_info10, 
                     initial_info11, initial_info12, initial_info13, initial_info14, 
                     initial_info15, initial_info16, initial_info17
                 INTO v_long,  v_gen01, v_gen02, v_gen03, v_gen04,
                     v_gen05, v_gen06, v_gen07, v_gen08, v_gen09,
                     v_gen10, v_gen11, v_gen12, v_gen13, v_gen14,
                     v_gen15, v_gen16, v_gen17, v_first_info, 
                     v_initial_info01, v_initial_info02,
                     v_initial_info03, v_initial_info04, v_initial_info05, v_initial_info06, 
                     v_initial_info07, v_initial_info08, v_initial_info09, v_initial_info10, 
                     v_initial_info11, v_initial_info12, v_initial_info13, v_initial_info14, 
                     v_initial_info15, v_initial_info16, v_initial_info17 
                 FROM gipi_polgenin
                WHERE policy_id = v_policy_id;
                
                v_first_info := NVL(info.first_info, v_first_info);
                v_long := NVL(v_long2, v_long);
                exist := 'Y';
            END LOOP;
        END LOOP;
        
        IF NVL(exist, 'N') = 'Y' THEN
            INSERT INTO gipi_wpolgenin(par_id,gen_info,gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,
                                gen_info06,gen_info07,gen_info08,gen_info09,gen_info10,gen_info11,
                                gen_info12,gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
                                first_info, initial_info01, initial_info02,  
                                initial_info03, initial_info04, initial_info05, initial_info06, 
                                initial_info07, initial_info08, initial_info09, initial_info10, 
                                initial_info11, initial_info12, initial_info13, initial_info14, 
                                initial_info15, initial_info16, initial_info17,user_id,last_update)
            VALUES(copy_par_id,v_long,  v_gen01, v_gen02, 
                v_gen03, v_gen04, v_gen05, v_gen06, 
                v_gen07, v_gen08, v_gen09, v_gen10, 
                v_gen11, v_gen12, v_gen13, v_gen14, 
                v_gen15, v_gen16, v_gen17,v_first_info, v_initial_info01, v_initial_info02, 
                v_initial_info03, v_initial_info04, v_initial_info05, v_initial_info06,
                v_initial_info07, v_initial_info08, v_initial_info09, v_initial_info10, 
                v_initial_info11, v_initial_info12, v_initial_info13, v_initial_info14, 
                v_initial_info15, v_initial_info16, v_initial_info17,user,sysdate);
        END IF; 
    END POPULATE_POLGENIN;
	
	PROCEDURE update_polbas (
		p_par_id 	    gipi_parlist.par_id%TYPE
	) IS
		v_no_itm        gipi_wpolbas.no_of_items%TYPE;
		v_tsi_amt       gipi_wpolbas.tsi_amt%TYPE;
		v_prem_amt      gipi_wpolbas.prem_amt%TYPE;
		v_ann_tsi_amt   gipi_wpolbas.ann_tsi_amt%TYPE;
		v_tsi_amt1      gipi_wpolbas.tsi_amt%TYPE;
		v_prem_amt1     gipi_wpolbas.prem_amt%TYPE;
		v_ann_tsi_amt1  gipi_wpolbas.ann_tsi_amt%TYPE;
	BEGIN
		copy_par_id := p_par_id;
		
		FOR item IN 
			( SELECT item_no, currency_rt
			    FROM gipi_witem
			   WHERE par_id = copy_par_id
			   ORDER BY item_no
		) LOOP
			v_prem_amt1 := 0;
			v_tsi_amt1  := 0;	
			v_ann_tsi_amt1 := 0;
			FOR peril IN
				( SELECT a.item_no, a.tsi_amt, a.prem_amt, b.peril_type
					FROM gipi_witmperl a, giis_peril b
				   WHERE a.line_cd  = b.line_cd
					 AND a.peril_cd = b.peril_cd
					 AND a.item_no  = item.item_no
					 AND par_id     = copy_par_id
				) LOOP	     	    
				v_prem_amt1 := NVL(v_prem_amt1,0) + peril.prem_amt;
				IF peril.peril_type = 'B' THEN
					v_tsi_amt1      := NVL(v_tsi_amt1,0)  + peril.tsi_amt;
					v_ann_tsi_amt1  := NVL(v_ann_tsi_amt1,0)  + peril.tsi_amt;
			  END IF;
			END LOOP;
			
			UPDATE gipi_witem 
			   SET prem_amt     = v_prem_amt1,
				   ann_prem_amt = v_prem_amt1,
				   tsi_amt      = v_tsi_amt1,
				   ann_tsi_amt  = v_ann_tsi_amt1
			 WHERE item_no = item.item_no
			   AND par_id  = copy_par_id;   
			v_no_itm      := NVL(v_no_itm,0)   + 1;
			v_prem_amt    := NVL(v_prem_amt,0) + (v_prem_amt1 * item.currency_rt);
			v_tsi_amt     := NVL(v_tsi_amt,0) + (v_tsi_amt1 * item.currency_rt);
			v_ann_tsi_amt := NVL(v_ann_tsi_amt,0) + (v_ann_tsi_amt1 * item.currency_rt);
		END LOOP; 
				 
		UPDATE gipi_wpolbas
		   SET prem_amt     = v_prem_amt,
				tsi_amt      = v_tsi_amt,
				no_of_items  = v_no_itm, 
				ann_tsi_amt  = v_ann_tsi_amt,
				ann_prem_amt = v_prem_amt
		 WHERE par_id  = copy_par_id;
	END update_polbas;
    
     PROCEDURE continue_summary (
        p_line_cd              IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd           IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd               IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy             IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no           IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_par_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
        p_par_id            IN GIPI_PARLIST.par_id%TYPE
    ) IS
        v_policy_id             GIPI_POLBASIC.policy_id%TYPE;
        v_inv_sw                VARCHAR2(1) := 'N';
    BEGIN
        policy_line_cd              := p_line_cd;
        policy_subline_cd           := p_subline_cd;
        policy_iss_cd               := p_iss_cd;
        policy_issue_yy             := p_issue_yy;
        policy_pol_seq_no           := p_pol_seq_no;
        policy_renew_no             := p_renew_no;
        copy_par_id                 := p_par_id;     

        GIUTS009_PKG.initialize_line_cd(
            var_line_FI, var_line_MC, var_line_AC, var_line_MH, var_line_MN,
            var_line_CA, var_line_EN, var_line_SU, var_line_AV        
        );        
        
        GIUTS009_PKG.initialize_subline_cd(
            var_subline_CAR, var_subline_EAR, var_subline_MBI, var_subline_MLOP, var_subline_DOS, 
            var_subline_BPV, var_subline_EEI, var_subline_PCP, var_subline_OP, var_subline_BBI,
            var_subline_MOP, var_subline_oth, var_subline_open, var_vessel_cd
        );
        
        FOR pol IN (SELECT policy_id 
                FROM gipi_polbasic
               WHERE line_cd     = p_line_cd
                 AND subline_cd  = p_subline_cd
                 AND iss_cd      = p_iss_cd
                 AND issue_yy    = p_issue_yy
                 AND pol_seq_no  = p_pol_seq_no
                 AND renew_no    = p_renew_no
                 AND endt_seq_no = 0)
        LOOP
            v_policy_id := pol.policy_id;
            EXIT;
        END LOOP;        

        IF v_inv_sw = 'Y' THEN      
            CREATE_WINVOICE(0,0,0,copy_par_id,policy_line_cd,p_par_iss_cd);
            cr_bill_dist.get_tsi(copy_par_id);
        END IF;
        
        IF policy_line_cd = var_line_CA AND
            policy_subline_cd = var_subline_BBI THEN    
            POPULATE_BANK_SCHEDULE;
        END IF;
    END continue_summary;
    
    PROCEDURE populate_bank_schedule IS
        
        item_exist         VARCHAR2(1); 
        v_row              NUMBER;
        v_policy_id        gipi_polbasic.policy_id%TYPE;
        v_endt_id          gipi_polbasic.policy_id%TYPE;
        v_bank_item_no     gipi_wbank_schedule.bank_item_no%TYPE;
        v_bank             gipi_wbank_schedule.bank%TYPE;
        v_bank_address     gipi_wbank_schedule.bank_address%TYPE;
        v_include_tag      gipi_wbank_schedule.include_tag%TYPE;
        v_cash_in_vault    gipi_wbank_schedule.cash_in_vault%TYPE;
        v_cash_in_transit  gipi_wbank_schedule.cash_in_transit%TYPE;
        v_remarks          gipi_wbank_schedule.remarks%TYPE;
            
        CURSOR pol IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
                        
        CURSOR pol2 IS
            SELECT rownum rownum_, a.* 
              FROM TABLE(GIUTS009_PKG.get_policy_group(policy_line_cd, policy_subline_cd, policy_iss_cd, policy_issue_yy, 
                        policy_pol_seq_no, policy_renew_no, policy_spld_pol_sw, policy_spld_endt_sw, 
                        policy_cancel_sw, policy_expired_sw)) a;
    BEGIN 
        v_row := 1;
        
        FOR ROW_NO IN pol 
        LOOP
            v_policy_id      := ROW_NO.policy_id;
            v_row            := v_row + 1; 
            
            FOR bank IN (
                 SELECT  bank_item_no,        bank,                 
                    include_tag,         bank_address,           
                    cash_in_vault,       cash_in_transit,
                    remarks
                   FROM gipi_bank_schedule
                  WHERE policy_id = v_policy_id
            ) LOOP
                item_exist := 'N';
                FOR CHK_ITEM IN
                ( 
                     SELECT '1'
                       FROM gipi_wbank_schedule
                      WHERE bank_item_no = bank.bank_item_no
                        AND par_id   = copy_par_id
                ) LOOP
                    item_exist := 'Y';
                    EXIT;
                END LOOP;

                IF NVL(item_exist,'N') = 'N' THEN
                    v_bank_item_no        := bank.bank_item_no;          
                    v_bank                := bank.bank;
                    v_include_tag         := bank.include_tag;
                    v_bank_address        := bank.bank_address;         
                    v_cash_in_vault       := nvl(bank.cash_in_vault,0);         
                    v_cash_in_transit     := nvl(bank.cash_in_transit,0);   
                    FOR ROW_NO2 IN pol2 LOOP
                        IF row_no.rownum_ >= v_row THEN
                        
                            v_endt_id := row_no2.policy_id;
                            
                            IF v_endt_id <> v_policy_id THEN
                                FOR bank2 IN ( 
                                    SELECT bank,                remarks, 
                                           include_tag,         bank_address,           
                                           cash_in_vault,       cash_in_transit
                                     FROM gipi_bank_schedule
                                    WHERE bank_item_no = v_bank_item_no
                                      AND policy_id = v_endt_id)
                                LOOP
                                    IF v_policy_id <> v_endt_id THEN    
                                        v_bank                := NVL(bank2.bank, v_bank);
                                        v_include_tag         := NVL(bank2.include_tag, v_include_tag);
                                        v_bank_address        := NVL(bank2.bank_address, v_bank_address);         
                                        IF nvl(bank2.cash_in_vault,0) > 0 THEN
                                           v_cash_in_vault       := nvl(bank2.cash_in_vault,0); 
                                        END IF;
                                        IF nvl(bank2.cash_in_transit,0) > 0 THEN
                                           v_cash_in_transit     := nvl(bank2.cash_in_transit,0);         
                                        END IF;   
                                    END IF;    
                                END LOOP;
                                
                            END IF;
                        END IF;
                    END LOOP;
                    
                    INSERT INTO GIPI_WBANK_SCHEDULE(
                         par_id,             bank_item_no,          
                         bank,               remarks,
                         include_tag,        bank_address,           
                         cash_in_vault,      cash_in_transit       )
                    VALUES( copy_par_id,       v_bank_item_no,          
                         v_bank,              v_remarks,
                         v_include_tag,       v_bank_address,           
                         v_cash_in_vault,     v_cash_in_transit    );            
                    v_bank_item_no       := null;         
                    v_bank               := null;           
                    v_include_tag        := null;         
                    v_bank_address       := null;               
                    v_cash_in_vault      := null;         
                    v_cash_in_transit    := null;           
                    v_remarks            := null;
                ELSE
                    EXIT;               
                END IF;
            END LOOP;
        END LOOP;
    END populate_bank_schedule;
    
    PROCEDURE update_summarized_par (
        p_par_id            IN    GIPI_PARLIST.par_id%TYPE,
        p_par_seq_no        OUT GIPI_PARLIST.par_seq_no%TYPE,
        p_quote_seq_no        OUT GIPI_PARLIST.quote_seq_no%TYPE
    ) IS
        v_inv_sw VARCHAR2(1) := 'N'; --  jhing 10.13.2015 GENQA 5033 
        v_iss_cd    gipi_parlist.iss_cd%TYPE ;
        v_line_cd  gipi_parlist.line_cd%TYPE ; 
    BEGIN

        FOR a2 IN (SELECT par_seq_no,quote_seq_no, line_cd, iss_cd
                 FROM gipi_parlist
                WHERE par_id = p_par_id) LOOP
            p_par_seq_no   := a2.par_seq_no;
            p_quote_seq_no := a2.quote_seq_no;
            v_iss_cd             := a2.iss_cd;
            v_line_cd           := a2.line_cd; 
        END LOOP;
        
        UPDATE gipi_parlist
           SET par_status = 3 
         WHERE par_id = p_par_id;
        
        FOR ITEM IN ( SELECT '1'
                    FROM gipi_witem
                   WHERE par_id = p_par_id )
        LOOP
            UPDATE gipi_parlist
               SET par_status = 4 
             WHERE par_id = p_par_id;                             
            EXIT;
        END LOOP;
        
        FOR PERL IN ( SELECT '1'
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id )
        LOOP
           UPDATE gipi_parlist
              SET par_status = 5 --:par.par_status
            WHERE par_id = p_par_id;                             
            EXIT;
        END LOOP;
        
        GIUTS009_PKG.update_polbas(p_par_id);
        
        -- jhing 10.13.2015 added condition to ensure invoice is created if all items have corresponding perils. - GENQA 5033 
        v_inv_sw := 'Y' ; 
        FOR cur1 IN (SELECT 1 
                                    FROM gipi_witem a
                                            WHERE a.par_id = p_par_id
                                                AND NOT EXISTS (
                                                    SELECT 1 
                                                        FROM gipi_witmperl t
                                                            WHERE t.par_id = a.par_id
                                                                AND t.item_no = a.item_no 
                                            ))
        LOOP
            v_inv_sw := 'N'; 
            EXIT; 
        END LOOP;
        

        IF v_inv_sw = 'Y' THEN      
            CREATE_WINVOICE(0,0,0,p_par_id,v_line_cd,v_iss_cd );
            cr_bill_dist.get_tsi(p_par_id);
        END IF;     
        
        GIUTS009_PKG.update_bond_invoice (p_par_id);   
        
    END update_summarized_par;
	
	PROCEDURE check_policy(
		p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2
    ) IS
        v_pol_flag     gipi_wpolbas.pol_flag%TYPE;
        v_expiry      gipi_wpolbas.expiry_date%TYPE;
    BEGIN
        BEGIN
            SELECT pol_flag, expiry_date
              INTO v_pol_flag, v_expiry
              FROM gipi_polbasic
             WHERE line_cd     = p_line_cd
                 AND subline_cd  = p_subline_cd
                 AND iss_cd      = p_iss_cd
                 AND issue_yy    = p_issue_yy
                 AND pol_seq_no  = p_pol_seq_no
                 AND renew_no    = p_renew_no
                 AND NVL(endt_seq_no, 0) = 0;
            IF NVL(p_cancel_sw,'N') = 'N' AND v_pol_flag = '4' THEN
                raise_application_error(-20002, 'Geniisys Exception#I#This policy is already cancelled, please check the option for cancelled policy if' ||
                       ' you want to summarize this policy.');
            ELSIF NVL(p_spld_pol_sw,'N') = 'N' AND v_pol_flag = '5' THEN
                raise_application_error(-20003, 'Geniisys Exception#I#This policy is already spoiled, please check the option for spoiled policy if' ||
                           ' you want to summarize this policy.');
            ELSIF NVL(p_expired_sw,'N') = 'N' AND v_expiry < sysdate  THEN
                raise_application_error(-20004, 'Geniisys Exception#I#This policy is already expired, please check the option for expired policy if' ||
                       ' you want to summarize this policy.');
            END IF;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                raise_application_error(-20001, 'Geniisys Exception#I#Policy is not existing.');
        END;
    END check_policy;
    
    PROCEDURE validate_line (
        p_line_cd              IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd           IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd               IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy             IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no           IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
        p_user_id            IN     GIIS_USERS.user_id%TYPE
    ) IS
        v_exist1            VARCHAR2(1) := 'N';
        v_exist                 VARCHAR2(1) := 'N';
        v_temp                 varchar2(1);
    BEGIN
        FOR B IN (SELECT line_cd
                    FROM giis_line
                   WHERE line_cd = p_line_cd)
        LOOP
               v_exist1 := 'Y';
               EXIT;
        END LOOP;
        
        IF v_exist1 = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#Line code entered is not valid. ');
        ELSE
            IF check_user_per_line2(p_line_cd,p_ISS_CD,'GIUTS009',p_user_id)=1 THEN
                v_exist := 'Y';
            END IF;
            
            IF v_exist = 'N' THEN
                raise_application_error(-20001, 'Geniisys Exception#I#You are not authorized to use this line. ');
            END IF;
            
            IF p_line_cd IS NULL OR p_subline_cd IS NULL OR p_iss_cd IS NULL OR 
               p_issue_yy IS NULL OR p_pol_seq_no IS NULL OR p_renew_no IS NULL THEN
                GIUTS009_PKG.check_if_policy_exists(p_line_cd, p_subline_Cd, p_iss_cd, 
                    p_issue_yy, p_pol_seq_no, p_renew_no);    
            ELSE
                GIUTS009_PKG.check_policy(p_line_cd, p_subline_Cd, p_iss_cd, p_issue_yy, p_pol_seq_no,
                    p_renew_no, p_spld_pol_sw, p_spld_endt_sw, p_cancel_sw, p_expired_sw);
            END IF;
           
            
        END IF;
    END validate_line;
    
    PROCEDURE check_if_policy_exists(
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE
    ) IS
        v_temp    varchar2(1) := 'N';
        v_flag    VARCHAR2(1) := 'N'; --added by reymon 11132013
        v_id      gipi_polbasic.pack_policy_id%TYPE := NULL; --added by reymon 11132013
    BEGIN
        FOR A1 IN( SELECT pack_pol_flag, pack_policy_id
                     FROM gipi_polbasic
                    WHERE line_cd     = NVL(p_line_cd,line_cd)
                      AND subline_cd  = NVL(p_subline_cd, subline_cd)
                      AND iss_cd      = NVL(p_iss_cd, iss_cd)
                      AND issue_yy    = NVL(p_issue_yy, issue_yy)
                      AND pol_seq_no  = NVL(p_pol_seq_no, pol_seq_no)
                      AND renew_no    = NVL(p_renew_no, renew_no))
        LOOP
            v_temp := 'Y';
            v_flag := a1.pack_pol_flag; --added by reymon 11132013
            v_id   := a1.pack_policy_id; --added by reymon 11132013
            EXIT;
        END LOOP;
        IF v_temp = 'N' THEN
           raise_application_error(-20001, 'Geniisys Exception#I#Record does not exist. ');
        ELSIF v_temp = 'Y' AND v_flag = 'Y' AND v_id IS NOT NULL AND (p_pol_seq_no IS NOT NULL OR p_renew_no IS NOT NULL) THEN --added by reymon 11132013
           raise_application_error(-20001, 'Geniisys Exception#E#Subpolicy of a package policy is not allowed to be copied. '); --added by reymon 11132013
        END IF;
    END check_if_policy_exists;
    
    PROCEDURE validate_iss_cd (
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   		IN  GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     		IN  GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   		IN  GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_POLBASIC.renew_no%TYPE,
        p_spld_pol_sw       IN  VARCHAR2,
        p_spld_endt_sw      IN  VARCHAR2,
        p_cancel_sw         IN  VARCHAR2,
        p_expired_sw        IN  VARCHAR2,
		p_user_id			IN 	GIIS_USERS.user_id%TYPE
    ) IS
    BEGIN
        IF p_line_cd IS NULL OR p_subline_cd IS NULL OR p_iss_cd IS NULL OR 
               p_issue_yy IS NULL OR p_pol_seq_no IS NULL OR p_renew_no IS NULL THEN
                GIUTS009_PKG.check_if_policy_exists(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
            ELSE
                GIUTS009_PKG.check_policy(p_line_cd, p_subline_Cd, p_iss_cd, p_issue_yy, p_pol_seq_no,
                    p_renew_no, p_spld_pol_sw, p_spld_endt_sw, p_cancel_sw, p_expired_sw);
            END IF;
       
        IF check_user_per_iss_cd2(p_line_cd, p_iss_cd, 'GIUTS009', NVL(p_user_id, USER)) != 1 THEN
            raise_application_error(-20001, 'Geniisys Exception#I#Issue Code entered is not allowed for the current user. ');
        END IF;
    END validate_iss_cd;
    
    PROCEDURE validate_par_iss_cd ( 
        p_line_cd      		IN  GIPI_POLBASIC.line_cd%TYPE,
        p_par_iss_cd       		IN  GIPI_POLBASIC.iss_cd%TYPE,
		p_user_id			IN 	GIIS_USERS.user_id%TYPE
    ) IS
        v_exist    VARCHAR2(1) := 'N';
        v_exist1   VARCHAR2(1) := 'N';
    BEGIN
        FOR B IN (SELECT iss_cd
                  FROM giis_issource 
                   WHERE iss_cd = p_par_iss_cd) 
        LOOP         
            v_exist1 := 'Y';
            EXIT;
        END LOOP;
        IF v_exist1 = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#Issue Code entered is not valid.');
	      
        ELSE                              
            IF check_user_per_iss_cd2(p_line_cd,p_par_iss_cd,'GIUTS009',p_user_id)=1 THEN
                v_exist := 'Y';
            END IF;
            
            IF v_exist = 'N' THEN
                raise_application_error(-20001, 'Geniisys Exception#I#Issue Code entered is not allowed for the current user.');
            END IF;
        END IF;
    END validate_par_iss_cd;

    PROCEDURE populate_peril_grp (
       p_item_no            gipi_wgrouped_items.item_no%TYPE,
       p_grouped_item_no    gipi_wgrouped_items.grouped_item_no%TYPE)
    IS
       v_policy_id      gipi_polbasic.policy_id%TYPE;
       v_endt_id        gipi_polbasic.policy_id%TYPE;
       v_peril_cd       giis_peril.peril_cd%TYPE;
       v_line_cd        gipi_witmperl_grouped.line_cd%TYPE;
       v_prem_rt        gipi_witmperl_grouped.prem_rt%TYPE;
       v_tsi_amt        gipi_witmperl_grouped.tsi_amt%TYPE;
       v_prem_amt       gipi_witmperl_grouped.prem_amt%TYPE;

       v_no_of_days     gipi_witmperl_grouped.no_of_days%TYPE;
       v_ann_tsi_amt    gipi_witmperl_grouped.ann_tsi_amt%TYPE;
       v_ann_prem_amt   gipi_witmperl_grouped.ann_prem_amt%TYPE;
       v_aggregate_sw   gipi_witmperl_grouped.aggregate_sw%TYPE;
       v_base_amt       gipi_witmperl_grouped.base_amt%TYPE;
       v_ri_comm_rate   gipi_witmperl_grouped.ri_comm_rate%TYPE;
       v_ri_comm_amt    gipi_witmperl_grouped.ri_comm_amt%TYPE;
       v_iss_cd_ri            giis_parameters.param_value_v%TYPE := giisp.v('ISS_CD_RI') ; 


       exist            VARCHAR2 (1) := 'N';
       v_row            NUMBER;

       CURSOR pol
       IS
          SELECT ROWNUM rownum_, a.*
            FROM TABLE (giuts009_pkg.get_policy_group (policy_line_cd,
                                                       policy_subline_cd,
                                                       policy_iss_cd,
                                                       policy_issue_yy,
                                                       policy_pol_seq_no,
                                                       policy_renew_no,
                                                       policy_spld_pol_sw,
                                                       policy_spld_endt_sw,
                                                       policy_cancel_sw,
                                                       policy_expired_sw)) a;

       CURSOR pol2
       IS
          SELECT ROWNUM rownum_, a.*
            FROM TABLE (giuts009_pkg.get_policy_group (policy_line_cd,
                                                       policy_subline_cd,
                                                       policy_iss_cd,
                                                       policy_issue_yy,
                                                       policy_pol_seq_no,
                                                       policy_renew_no,
                                                       policy_spld_pol_sw,
                                                       policy_spld_endt_sw,
                                                       policy_cancel_sw,
                                                       policy_expired_sw)) a;

    BEGIN
       v_row := 1;

       FOR row_no IN pol
       LOOP
          v_policy_id := row_no.policy_id;
          v_row := v_row + 1;

          FOR data
             IN (SELECT peril_cd,
                        no_of_days,
                        prem_rt,
                        ann_prem_amt prem_amt,
                        ann_tsi_amt,
                        ann_prem_amt,
                        aggregate_sw,
                        base_amt,
                        ri_comm_rate,
                        ri_comm_amt,
                        line_cd,
                        tsi_amt
                   FROM gipi_itmperil_grouped
                  WHERE     item_no = p_item_no
                        AND grouped_item_no = p_grouped_item_no
                        AND policy_id = v_policy_id)
          LOOP
             exist := 'N';

             FOR chk_item
                IN (SELECT 1
                      FROM gipi_witmperl_grouped
                     WHERE     item_no = p_item_no
                           AND grouped_item_no = p_grouped_item_no
                           AND peril_cd = data.peril_cd
                           AND par_id = copy_par_id)
             LOOP
                exist := 'Y';
                EXIT;
             END LOOP;

             IF NVL (exist, 'N') = 'N'
             THEN
                v_peril_cd := data.peril_cd;
                v_line_cd := data.line_cd;
                v_prem_amt := data.prem_amt;
                v_tsi_amt := data.tsi_amt;
                v_prem_rt := data.prem_rt;
                v_no_of_days := data.no_of_days;
                v_ann_tsi_amt := data.ann_tsi_amt;
                v_ann_prem_amt := data.ann_prem_amt;
                v_aggregate_sw := data.aggregate_sw;
                v_base_amt := data.base_amt;
                v_ri_comm_rate := data.ri_comm_rate;
                v_ri_comm_amt := data.ri_comm_amt;

                FOR row_no2 IN pol2
                LOOP
                   IF row_no.rownum_ >= v_row
                   THEN
                      v_endt_id := row_no2.policy_id;

                      IF v_endt_id <> v_policy_id
                      THEN
                         FOR data2
                            IN (SELECT prem_amt,
                                       tsi_amt,
                                       prem_rt,
                                       ri_comm_rate,
                                       ri_comm_amt
                                  FROM gipi_itmperil_grouped
                                 WHERE     peril_cd = v_peril_cd
                                       AND item_no = p_item_no
                                       AND grouped_item_no = p_grouped_item_no
                                       AND policy_id = v_endt_id)
                         LOOP
                            v_prem_amt :=
                               NVL (v_prem_amt, 0) + NVL (data2.prem_amt, 0);
                            v_tsi_amt :=
                               NVL (v_tsi_amt, 0) + NVL (data2.tsi_amt, 0);

                            IF NVL (data2.prem_rt, 0) > 0
                            THEN
                               v_prem_rt := data2.prem_rt;
                            END IF;
                         END LOOP;
                      END IF;
                   END IF;
                END LOOP;


                IF NVL (v_tsi_amt, 0) > 0
                THEN
                
                   IF copy_par_iss_cd <> v_iss_cd_ri THEN
                          v_ri_comm_rate := NULL; 
                          v_ri_comm_amt := NULL; 
                   END IF; 
                
                   INSERT INTO gipi_witmperl_grouped (par_id,
                                                      item_no,
                                                      grouped_item_no,
                                                      line_cd,
                                                      peril_cd,
                                                      rec_flag,
                                                      no_of_days,
                                                      prem_rt,
                                                      tsi_amt,
                                                      prem_amt,
                                                      ann_tsi_amt,
                                                      ann_prem_amt,
                                                      aggregate_sw,
                                                      base_amt,
                                                      ri_comm_rate,
                                                      ri_comm_amt)
                        VALUES (copy_par_id,
                                p_item_no,
                                p_grouped_item_no,
                                v_line_cd,
                                v_peril_cd,
                                'A',
                                v_no_of_days,
                                v_prem_rt,
                                v_tsi_amt,
                                v_prem_amt,
                                v_ann_tsi_amt,
                                v_ann_prem_amt,
                                v_aggregate_sw,
                                v_base_amt,
                                v_ri_comm_rate,
                                v_ri_comm_amt);
                END IF;
             END IF;

             v_peril_cd := NULL;
             v_line_cd := NULL;
             v_prem_amt := NULL;
             v_tsi_amt := NULL;
             v_prem_rt := NULL;

             v_no_of_days := NULL;
             v_ann_tsi_amt := NULL;
             v_ann_prem_amt := NULL;
             v_aggregate_sw := NULL;
             v_base_amt := NULL;
             v_ri_comm_rate := NULL;
             v_ri_comm_amt := NULL;
          END LOOP;
       END LOOP;
       
       -- update or correct the amount covered based on sum of basic perils 
         FOR z IN (SELECT   a.item_no, a.grouped_item_no, SUM (DECODE (b.peril_type, 'B', tsi_amt, 0)) tsi_amt,
                         SUM (prem_amt) prem_amt
                    FROM gipi_witmperl_grouped a, giis_peril b
                   WHERE a.par_id  = copy_par_id
                     AND a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                GROUP BY a.item_no, a.grouped_item_no)
      LOOP
         UPDATE gipi_wgrouped_items
            SET amount_covered = z.tsi_amt ,
                tsi_amt = z.tsi_amt,
                prem_amt = z.prem_amt,
                ann_tsi_amt = z.tsi_amt,
                ann_prem_amt = z.prem_amt
          WHERE par_id = copy_par_id
            AND item_no = z.item_no
            AND grouped_item_no = z.grouped_item_no;
      END LOOP;
      
      -- rate should be NULL 
    END populate_peril_grp;

  PROCEDURE update_bond_invoice  (
        p_par_id            IN    GIPI_PARLIST.par_id%TYPE
  )
  IS
    v_mnu_line_cd giis_line.line_cd%TYPE;
    v_prem_rt   GIPI_WINVOICE.bond_rate%TYPE;
    v_tsi_amt   GIPI_WINVOICE.bond_tsi_amt%TYPE;
  BEGIN
  
    FOR t in ( SELECT nvl(a.menu_line_cd, a.line_cd) menu_line_cd
                        FROM giis_line a, gipi_parlist b 
                               WHERE a.line_cd = b.line_cd
                                 AND b.par_id = p_par_id  )
    LOOP
        v_mnu_line_cd := t.menu_line_cd; 
        EXIT;
    END LOOP;
  
    IF v_mnu_line_cd = 'SU' THEN
        BEGIN
              SELECT prem_rt, tsi_amt
                  INTO v_prem_rt, v_tsi_amt
                  FROM GIPI_WITMPERL
               WHERE par_id = p_par_id;
                 
              UPDATE GIPI_WINVOICE
                  SET bond_rate = v_prem_rt,
                      bond_tsi_amt = v_tsi_amt
               WHERE par_id = p_par_id;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                     NULL;    
        END ;
            
    END IF; 
  END ;     
END GIUTS009_PKG;
/


