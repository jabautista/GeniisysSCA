CREATE OR REPLACE PROCEDURE CPI.POPULATE_SUMMARY_TAB(
    p_proc_expiry_date      IN  gipi_wpolbas.eff_date%TYPE,
    p_proc_assd_no          IN  gipi_wpolbas.assd_no%TYPE,
    p_proc_same_polno_sw    IN  giex_expiry.same_polno_sw%TYPE,
    p_old_pol_id            IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw       IN  giex_expiry.summary_sw%TYPE,
    p_proc_renew_flag       IN  giex_expiry.renew_flag%TYPE,
    p_new_pack_par_id       IN  gipi_parlist.pack_par_id%TYPE,
    p_user                  IN  gipi_parhist.user_id%TYPE,
    p_old_pol_id_pack       IN  gipi_wpolnrep.old_policy_id%type,
    p_line_ac               IN  gipi_polbasic.line_cd%TYPE,
    p_menu_line_cd          IN  giis_line.line_cd%TYPE,
    p_line_ca               IN  gipi_polbasic.line_cd%TYPE,
    p_line_av               IN  gipi_polbasic.line_cd%TYPE,
    p_line_fi               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mc               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mn               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mh               IN  gipi_polbasic.line_cd%TYPE,
    p_line_en               IN  gipi_polbasic.line_cd%TYPE,
    p_vessel_cd             IN  giis_vessel.vessel_cd%TYPE,
    p_subline_bpv           IN  gipi_wpolbas.subline_cd%TYPE,
    p_open_flag             IN  giis_subline.op_flag%TYPE,
    p_nbt_line_cd           IN  gipi_pack_polbasic.line_cd%TYPE,
    p_line_su               IN  gipi_polbasic.line_cd%TYPE,
    p_proc_intm_no          IN  giex_expiry.intm_no%TYPE,
    p_dsp_line_cd           IN  giis_line_subline_coverages.line_cd%TYPE,
    p_dsp_iss_cd            IN  giis_intm_special_rate.iss_cd%TYPE,
    p_proc_line_cd          IN  gipi_polbasic.line_cd%TYPE,
    p_proc_subline_cd       IN  gipi_polbasic.subline_cd%TYPE,
    p_subline_bbi           IN  gipi_wpolbas.subline_cd%TYPE,
    p_is_subpolicy          IN  VARCHAR2,
    p_message_box       IN OUT  VARCHAR2,
    p_new_par_id           OUT  gipi_witem.par_id%TYPE,
    p_msg                  OUT  VARCHAR2
)
IS
  --rg_id                      RECORDGROUP;
  rg_name                    VARCHAR2(30) := 'GROUP_POLICY';
  rg_count                   NUMBER;
  rg_count2                  NUMBER;
  rg_col                     VARCHAR2(50) := rg_name || '.policy_id';
  rg_col2                    VARCHAR2(50) := rg_name || '.endt_seq_no';
  rg_col3                    VARCHAR2(50) := rg_name || '.pol_flag';
  rg_policy_id               gipi_polbasic.policy_id%TYPE;
  rg_endt_id                 gipi_polbasic.policy_id%TYPE;
  rg_pol_flag                gipi_wpolbas.pol_flag%TYPE;
  rg_endt_seq_no             gipi_wpolbas.endt_seq_no%TYPE;
  v_line_cd1                 gipi_wpolbas.line_cd%TYPE;
  v_iss_cd1                  gipi_wpolbas.iss_cd%TYPE;
  v_eff_date                 gipi_wpolbas.eff_date%TYPE;
  v_incept_date              gipi_wpolbas.incept_date%TYPE;
  v_expiry_date              gipi_wpolbas.expiry_date%TYPE;
  v_assd_no                  gipi_wpolbas.assd_no%TYPE;
  v_acct_of_cd_sw            gipi_wpolbas.acct_of_cd_sw%TYPE;
  v_LABEL_TAG                gipi_wpolbas.LABEL_TAG%TYPE;
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
  v_start_date               gipi_wpolbas.incept_date%TYPE;
  v_issue_yy                 gipi_wpolbas.issue_yy%TYPE;   
  v_par_yy                   gipi_wpolbas.issue_yy%TYPE;   
  v_pol_seq_no               gipi_wpolbas.pol_seq_no%TYPE;
  v_renew_no                 gipi_wpolbas.renew_no%TYPE;
  --BETH 120199
  v_incept_tag               gipi_wpolbas.incept_tag%TYPE;
  v_print_fleet_tag          gipi_wpolbas.fleet_print_tag%TYPE;
  v_endt_expiry_tag          gipi_wpolbas.endt_expiry_tag%TYPE;
  v_with_tariff_sw           gipi_wpolbas.with_tariff_sw%TYPE;
  v_place_cd                 gipi_wpolbas.place_cd%TYPE;
  v_cred_branch              gipi_wpolbas.cred_branch%TYPE;
  v_region_cd                gipi_wpolbas.region_cd%TYPE;
  v_industry_cd              gipi_wpolbas.industry_cd%TYPE;
  v_risk_tag                 gipi_wpolbas.risk_tag%TYPE;
  v_inv_sw                   VARCHAR2(1) := 'N';  
  p_line_cd                  gipi_polbasic.line_cd%TYPE;
  p_subline_cd               gipi_polbasic.subline_cd%TYPE;
  p_iss_cd                   gipi_polbasic.iss_cd%TYPE;
  p_issue_yy                 gipi_polbasic.issue_yy%TYPE;
  p_pol_seq_no               gipi_polbasic.pol_seq_no%TYPE;
  p_renew_no                 gipi_polbasic.renew_no%TYPE;
  p_policy_id                gipi_polbasic.policy_id%TYPE;
  prem_seq                   giis_prem_seq.prem_seq_no%TYPE;
  var_vdate                  giac_parameters.param_value_n%TYPE;
  v_issue_cd            	gipi_parlist.iss_cd%TYPE;--vj 03.31.09
  var_iss_cred          	giis_parameters.param_value_v%TYPE:=giisp.v('CRED_BRANCH_RENEWAL'); --03.31.09  
  v_takeup_term             gipi_wpolbas.takeup_term%TYPE;  -- Queenie 1/14/11
  v_other_iss			 	giis_parameters.param_value_v%TYPE:=NVL(giisp.v('ALLOW_OTHER_BRANCH_RENEWAL'),'N'); --01.25.2012  
  v_bond_seq_no				gipi_wpolbas.bond_seq_no%TYPE; --added by MAC 05/09/2012
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_SUMMARY_TAB program unit 
  */
  
  IF NVL(var_iss_cred,'N')='Y' THEN 
    SELECT cred_branch
        INTO v_issue_cd
        FROM gipi_polbasic
       WHERE policy_id = p_old_pol_id; 
  ELSIF NVL(v_other_iss,'N')='Y' THEN 
    v_issue_cd := get_user_iss_cd(p_user);
  END IF; 
  
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
  FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        rg_policy_id   := b.policy_id;
        EXIT;
     END LOOP;
  IF rg_policy_id IS NOT NULL THEN
     FOR pol IN 
         ( SELECT line_cd,         subline_cd,   iss_cd,        issue_yy,      pol_seq_no,                     
                  assd_no,         type_cd,      ACCT_OF_CD,    ACCT_OF_CD_SW, LABEL_TAG,
                  designation ,    mortg_name,
                  address1,        address2,     address3,      pool_pol_no,   subline_type_cd,
                  auto_renew_flag, renew_flag,   pack_pol_flag, prov_prem_tag, expiry_tag,
                  foreign_acc_sw,  invoice_sw,   ref_pol_no,    prem_warr_tag, co_insurance_sw,
                  reg_policy_sw,   incept_tag,   fleet_print_tag,
                  endt_expiry_tag, incept_date,  renew_no,
                  prorate_flag,    no_of_items,  prov_prem_pct, discount_sw,   short_rt_percent,
                  comp_sw,         ann_tsi_amt,  ann_prem_amt,  manual_renew_no,
                  with_tariff_sw,  place_cd,     cred_branch,   region_cd,     industry_cd, risk_tag,
				  takeup_term, -- Queenie 1/14/11 retrieve take_up term of the policy
              	  bond_seq_no  --added by MAC 05/09/2012
              FROM gipi_polbasic
             WHERE policy_id = rg_policy_id
         ) 
     LOOP 
       v_line_cd1           :=    pol.line_cd;
       v_iss_cd1            :=    pol.iss_cd;
       p_policy_id          :=    rg_policy_id;
       v_subline_cd         :=    pol.subline_cd;
       v_eff_date           :=    p_proc_expiry_date;
       v_incept_date        :=    p_proc_expiry_date;        
       v_start_date         :=    pol.incept_date;
       v_assd_no            :=    p_proc_assd_no;  --pol.assd_no;            
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
       p_iss_cd             :=    pol.iss_cd;                     
       v_incept_tag         :=    pol.incept_tag;
       v_print_fleet_tag    :=    pol.fleet_print_tag;
       v_endt_expiry_tag    :=    pol.endt_expiry_tag;      
       v_par_yy             :=    TO_NUMBER(SUBSTR(TO_CHAR(v_eff_date,'MM-DD-YYYY'),9,2));
       v_with_tariff_sw     :=    pol.with_tariff_sw; --v_with_tariff_sw;
       v_place_cd           :=    pol.place_cd;       --v_place_cd;
       v_cred_branch        :=    pol.cred_branch;
       v_region_cd          :=    pol.region_cd;
       v_industry_cd        :=    pol.industry_cd;
       v_risk_tag           :=    pol.risk_tag;
       v_ACCT_OF_CD_SW      :=    pol.ACCT_OF_CD_SW;
       v_LABEL_TAG          :=    pol.LABEL_TAG;
	   v_takeup_term        :=    pol.takeup_term; -- Queenie 1/14/10
       v_bond_seq_no		:=    pol.bond_seq_no; --added by MAC 05/09/2012
       IF NVL(p_proc_same_polno_sw,'N') = 'Y' THEN
          v_pol_seq_no     := pol.pol_seq_no;           
          v_issue_yy       := pol.issue_yy ;
          v_issue_cd       := pol.iss_cd; --nieko 07212016 SR 22730, KB 3722
       ELSE
          v_pol_seq_no     := null;
          v_issue_yy       := TO_NUMBER(SUBSTR(TO_CHAR(v_incept_date,'MM-DD-YYYY'),9,2));--v_par_yy;
       END IF;
       v_renew_no       := NVL(pol.manual_renew_no,0) + NVL(pol.renew_no,0) + 1;
       --iris bordey 08.28.2003
      -- GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
       v_ref_pol_no         :=    pol.ref_pol_no; -- Dren 01.28.2015 SR - 0020783 : To copy ref_pol_no to PAR upon renewal.        
       IF NVL(p_proc_summary_sw,'N') = 'N' THEN
       FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                  FROM gipi_polbasic
                  WHERE line_cd     =  x_line_cd
                    AND subline_cd  =  x_subline_cd
                    AND iss_cd      =  x_iss_cd
                    AND issue_yy    =  to_char(x_issue_yy)
                    AND pol_seq_no  =  to_char(x_pol_seq_no)
                    AND renew_no    =  to_char(x_renew_no)
                    AND (endt_seq_no = 0 OR 
                        (endt_seq_no > 0 AND 
                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                    AND pol_flag In ('1','2','3')
                    AND NVL(endt_seq_no,0) = 0
                  ORDER BY eff_date, endt_seq_no)
         LOOP      
            rg_endt_id     := b.policy_id;
            rg_endt_seq_no := b.endt_seq_no;
            rg_pol_flag    := b.pol_flag;
            FOR endt IN ( SELECT assd_no,            type_cd,      ACCT_OF_CD,    ACCT_OF_CD_SW, LABEL_TAG,
                                    designation ,    mortg_name,
                                    address1,        address2,     address3,      pool_pol_no,   subline_type_cd,
                                    auto_renew_flag, renew_flag,   pack_pol_flag, prov_prem_tag, expiry_tag,
                                    foreign_acc_sw,  invoice_sw,   ref_pol_no,    prem_warr_tag, co_insurance_sw,
                                    reg_policy_sw,   incept_tag,   fleet_print_tag,
                                    endt_expiry_tag, incept_date,  with_tariff_sw, place_cd,     cred_branch,
                                    region_cd,       industry_cd,  risk_tag
                               FROM gipi_polbasic
                              WHERE policy_id = rg_endt_id)
             LOOP         
               v_subline_cd         :=    NVL(pol.subline_cd,v_subline_cd);
               IF endt.assd_no IS NOT NULL THEN
                  p_policy_id  :=    rg_endt_id;
               END IF;    
               v_start_date         :=    NVL(endt.incept_date,v_start_date);
               v_type_cd            :=    NVL(endt.type_cd,v_type_cd);            
               v_acct_of_cd         :=    NVL(endt.acct_of_cd,v_acct_of_cd);         
               v_designation        :=    NVL(endt.designation,v_designation);        
               v_mortg_name         :=    NVL(endt.mortg_name,v_mortg_name);         
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
               v_with_tariff_sw     :=    NVL(endt.with_tariff_sw, pol.with_tariff_sw);
               v_place_cd           :=    NVL(endt.place_cd, pol.place_cd);
               v_cred_branch        :=    NVL(endt.cred_branch, pol.cred_branch);
               v_region_cd          :=    NVL(endt.region_cd, pol.region_cd);
               v_industry_cd        :=    NVL(endt.industry_cd, pol.industry_cd);
               v_risk_tag           :=    NVL(endt.risk_tag, pol.risk_tag);
               v_ACCT_OF_CD_SW      :=    NVL(endt.ACCT_OF_CD_SW, pol.ACCT_OF_CD_SW);
               v_LABEL_TAG          :=    NVL(endt.LABEL_TAG, pol.LABEL_TAG);
             END LOOP;
         END LOOP;
   ELSE      
     FOR endt IN (SELECT assd_no,         type_cd,      acct_of_cd,    ACCT_OF_CD_SW, LABEL_TAG,
                         designation ,  mortg_name,
                         address1,        address2,     address3,      pool_pol_no,   subline_type_cd,
                         auto_renew_flag, renew_flag,   pack_pol_flag, prov_prem_tag, expiry_tag,
                         foreign_acc_sw,  invoice_sw,   ref_pol_no,    prem_warr_tag, co_insurance_sw,
                         reg_policy_sw,   incept_tag,   fleet_print_tag,
                         endt_expiry_tag, incept_date,  with_tariff_sw, place_cd,     cred_branch,
                         region_cd,       industry_cd,  risk_tag
                    FROM gipi_polbasic
                   WHERE line_cd    = pol.line_cd
                     AND subline_cd = pol.subline_cd
                     AND iss_cd     = pol.iss_cd
                     AND issue_yy   = pol.issue_yy
                     AND pol_seq_no = pol.pol_seq_no
                     AND renew_no   = pol.renew_no
                   ORDER BY eff_date)
     LOOP
           v_start_date         :=    NVL(endt.incept_date,v_start_date);
           v_type_cd            :=    NVL(endt.type_cd,v_type_cd);            
           v_acct_of_cd         :=    NVL(endt.acct_of_cd,v_acct_of_cd);         
           v_designation        :=    NVL(endt.designation,v_designation);        
           v_mortg_name         :=    NVL(endt.mortg_name,v_mortg_name);         
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
           v_with_tariff_sw     :=    NVL(endt.with_tariff_sw, pol.with_tariff_sw);
           v_place_cd           :=    NVL(endt.place_cd, pol.place_cd);
           v_cred_branch        :=    NVL(endt.cred_branch, pol.cred_branch);
           v_region_cd          :=    NVL(endt.region_cd, pol.region_cd);
           v_industry_cd        :=    NVL(endt.industry_cd, pol.industry_cd);
           v_risk_tag           :=    NVL(endt.risk_tag, pol.risk_tag);
           v_assd_no            :=    NVL(endt.assd_no, pol.assd_no);
           v_ACCT_OF_CD_SW      :=    NVL(endt.ACCT_OF_CD_SW, pol.ACCT_OF_CD_SW);
           v_LABEL_TAG          :=    NVL(endt.LABEL_TAG, pol.LABEL_TAG);
     END LOOP;
   END IF;
         -- added by mgc to get the correct address if policy has backward endt
         -- from here
         -- get the last endorsement sequence of the latest backward endt
     FOR Z IN (SELECT address1, address2, address3, eff_date
                 FROM gipi_polbasic b2501
                WHERE b2501.line_cd    = pol.line_cd
                  AND b2501.subline_cd = pol.subline_cd
                  AND b2501.iss_cd     = pol.iss_cd
                  AND b2501.issue_yy   = pol.issue_yy
                  AND b2501.pol_seq_no = pol.pol_seq_no
                  AND b2501.renew_no   = pol.renew_no
                  AND NVL(b2501.spld_flag,'1') <> '2'
                  AND b2501.pol_flag   IN ('1','2','3')
                  AND (address1 IS NOT NULL
                   OR address2 IS NOT NULL
                   OR address3 IS NOT NULL)
                ORDER BY eff_date desc ) LOOP
          v_address1  := Z.address1;
          v_address2  := Z.address2;
          v_address3  := Z.address3;
          FOR Z1 IN (SELECT endt_seq_no, address1, address2, address3
                       FROM gipi_polbasic b2501
                      WHERE b2501.line_cd    = pol.line_cd
                        AND b2501.subline_cd = pol.subline_cd
                        AND b2501.iss_cd     = pol.iss_cd
                        AND b2501.issue_yy   = pol.issue_yy
                        AND b2501.pol_seq_no = pol.pol_seq_no
                        AND b2501.renew_no   = pol.renew_no
                        AND b2501.pol_flag   IN ('1','2','3')
                        AND nvl(b2501.back_stat,5) = 2
                        AND (address1 IS NOT NULL
                         OR address2 IS NOT NULL
                         OR address3 IS NOT NULL)
                      ORDER BY endt_seq_no desc ) 
          LOOP
               -- get the last endorsement sequence of the policy
               FOR Z1A IN (SELECT endt_seq_no, eff_date, address1, address2, address3
                             FROM gipi_polbasic b2501
                            WHERE b2501.line_cd    = pol.line_cd
                              AND b2501.subline_cd = pol.subline_cd
                              AND b2501.iss_cd     = pol.iss_cd
                              AND b2501.issue_yy   = pol.issue_yy
                              AND b2501.pol_seq_no = pol.pol_seq_no
                              AND b2501.renew_no   = pol.renew_no
                              AND b2501.pol_flag   IN ('1','2','3')
                              AND (address1 IS NOT NULL
                               OR address2 IS NOT NULL
                               OR address3 IS NOT NULL)
                            ORDER BY endt_seq_no desc ) 
               LOOP
                  IF Z1.endt_seq_no = Z1a.endt_seq_no THEN
                     v_address1  := Z1.address1;
                     v_address2  := Z1.address2;
                     v_address3  := Z1.address3;
                  ELSE
                     IF Z1A.eff_date > Z.eff_date THEN
                         v_address1  := Z1A.address1;
                         v_address2  := Z1A.address2;
                         v_address3  := Z1A.address3;
                     ELSE
                         v_address1  := Z1.address1;
                         v_address2  := Z1.address2;
                         v_address3  := Z1.address3;
                     END IF;
                  END IF;
                  EXIT;
               END LOOP;
               EXIT;
          END LOOP;
          EXIT;
     END LOOP;
     -- to here             
     insert_into_parlist(p_policy_id, v_assd_no, v_par_yy, p_new_par_id, p_msg, p_proc_renew_flag, p_new_pack_par_id, p_user, NVL(p_proc_same_polno_sw,'N'));--nieko 07212016 SR 22730, KB 3722, same_polno added
     IF p_is_subpolicy = 'Y' THEN
             NULL;
     ELSE    
         FOR MSG IN (SELECT line_cd, iss_cd, par_yy, par_seq_no
                       FROM gipi_parlist
                      WHERE par_id = p_new_par_id
                        AND line_cd =pol.line_cd)
         LOOP
             /*recgrp_row('DISPLAY_RENEWALS',variables.old_pol_id,
                      p_ren=>msg.line_cd||'-'||
                                 msg.iss_cd||'-'||to_char(msg.par_yy,'09')||'-'||to_char(msg.par_seq_no,'0999999'),
                    p_auto=>'N');*/
           p_message_box :=   p_message_box ||'            Renewed to PAR   :'|| msg.line_cd||'-'||
                                 msg.iss_cd||'-'||to_char(msg.par_yy,'09')||'-'||to_char(msg.par_seq_no,'0999999');
         END LOOP;
       END IF;
     --CLEAR_MESSAGE;     
     --MESSAGE('Copying policy''s basic info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE; 
     --IF pol.prorate_flag = 2 THEN
     /* commented by gmi     
     ** all renewals should be on annual term basis
     ** all premium amounts are then recomputed to be on annual basis too
     ** as what missj, and mam grace approved.. 
     ** requested by fpac
     */    
     v_expiry_date := ADD_MONTHS(v_eff_date,12);
     /*ELSE 
        v_expiry_date := v_eff_date + (variables.proc_expiry_date - v_start_date);       
     END IF;*/
        /*code added by VJ 03.31.09*/
        
        /*
        ** nieko 07212016 SR 22730, KB 3722
        IF NVL(var_iss_cred,'N')='Y' THEN 
          v_issue_cd := pol.cred_branch;
        ELSIF NVL(v_other_iss,'N')='Y' THEN 
		  v_issue_cd := get_user_iss_cd(p_user);
        ELSE
          v_issue_cd := pol.iss_cd;
        END IF;*/
        
        --nieko 07212016 SR 22730, KB 3722
        IF v_issue_cd IS NULL
        THEN
           v_issue_cd := pol.iss_cd;
        END IF;
        
        IF v_issue_cd <> pol.iss_cd
        THEN
           v_place_cd := NULL;
        END IF;
        /*end, 03.31.09*/   
     IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
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
               comp_sw,               ann_prem_amt,          ann_tsi_amt,        with_tariff_sw,
               place_cd,              cred_branch,           region_cd,          industry_cd,
               risk_tag,              ACCT_OF_CD_SW,         LABEL_TAG,          REF_POL_NO) -- Dren 01.28.2016 SR - 0020783 : To copy ref_pol_no to PAR upon renewal.
        VALUES (p_new_par_id,         pol.line_cd,           pol.subline_cd,     /*pol.iss_cd*/v_issue_cd,           --vj 03.31.09
               v_issue_yy,
               v_pol_seq_no,          v_renew_no,            0,            
               '2',                   v_incept_date,         v_incept_date,      0,     
               v_expiry_date,         v_assd_no,             v_type_cd,          SYSDATE,      
               v_acct_of_cd,          v_designation,         v_mortg_name,       v_address1,        
               v_address2,            v_address3,            v_tsi_amt,          v_prem_amt,
               v_pool_pol_no,         pol.no_of_items,       pol.prov_prem_pct,  v_subline_type_cd, 
               pol.short_rt_percent,  /*pol.prorate_flag*/ '2',      v_auto_renew_flag,     
               v_pack_pol_flag,       pol.prov_prem_tag,     v_expiry_tag,       v_govt_acc_sw,
               v_invoice_sw,          pol.discount_sw,       v_reg_policy_sw,    v_prem_warr_tag,
               v_co_insurance_sw,     NVL(p_proc_same_polno_sw,'N'), 'N', 'N',         p_user ,              v_print_fleet_tag,     
               v_endt_expiry_tag,     pol.comp_sw,           pol.ann_prem_amt,   pol.ann_tsi_amt,        v_with_tariff_sw,
               v_place_cd,                        v_cred_branch,         v_region_cd,        v_industry_cd,
               v_risk_tag,            v_ACCT_OF_CD_SW,       v_LABEL_TAG,        v_ref_pol_no); -- Dren 01.28.2015 SR - 0020783 : To copy ref_pol_no to PAR upon renewal.
        --03/30/2012
        IF p_new_pack_par_id IS NOT NULL THEN 
            UPDATE gipi_wpolbas 
               SET pack_par_id = p_new_pack_par_id
             WHERE par_id = p_new_par_id;        
        END IF;
        /* code added by gmi to resolve ora-02291 */               
        IF p_old_pol_id_pack != 0 THEN
            POPULATE_PACK_LINE_SUBLINE(p_old_pol_id, p_proc_summary_sw, p_msg, p_new_par_id, p_new_pack_par_id);
        END IF;       
        populate_item_info2(p_new_par_id, p_old_pol_id);
     ELSE        
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
               comp_sw,               with_tariff_sw,        place_cd,                     cred_branch,
               region_cd,             industry_cd,
               risk_tag,              ACCT_OF_CD_SW,         LABEL_TAG,          REF_POL_NO) -- Dren 01.28.2016 SR - 0020783 : To copy ref_pol_no to PAR upon renewal.
        VALUES (p_new_par_id,         pol.line_cd,           pol.subline_cd,     /*pol.iss_cd*/v_issue_cd,           --vj 03.31.09
               v_issue_yy,
               v_pol_seq_no,          v_renew_no,            0,            
               '2',                   v_incept_date,         v_incept_date,      0,     
               v_expiry_date,         v_assd_no,             v_type_cd,          SYSDATE,      
               v_acct_of_cd,          v_designation,         v_mortg_name,       v_address1,        
               v_address2,            v_address3,            v_tsi_amt,          v_prem_amt,
               v_pool_pol_no,         0,                     NULL,               v_subline_type_cd, 
               NULL,                  '2',                   v_auto_renew_flag,     
               v_pack_pol_flag,       'N',                   v_expiry_tag,       v_govt_acc_sw,
               v_invoice_sw,          'N',                   v_reg_policy_sw,    v_prem_warr_tag,
               v_co_insurance_sw,     NVL(p_proc_same_polno_sw,'N'), 'N', 'N',         p_user ,              v_print_fleet_tag,     
               v_endt_expiry_tag,     'N',                   v_with_tariff_sw,   v_place_cd,     v_cred_branch,
               v_region_cd,           v_industry_cd,
               v_risk_tag,            v_ACCT_OF_CD_SW,       v_LABEL_TAG,        v_ref_pol_no); -- Dren 01.28.2015 SR - 0020783 : To copy ref_pol_no to PAR upon renewal.
        --03/30/2012
        IF p_new_pack_par_id IS NOT NULL THEN 
            UPDATE gipi_wpolbas 
               SET pack_par_id = p_new_pack_par_id
             WHERE par_id = p_new_par_id;        
        END IF;      
        /* code added by gmi to resolve ora-02291 */        
        IF p_old_pol_id_pack != 0 THEN
            POPULATE_PACK_LINE_SUBLINE(p_old_pol_id, p_proc_summary_sw, p_msg, p_new_par_id, p_new_pack_par_id);
        END IF;        
        POPULATE_ITEM_INFO3(p_old_pol_id, p_new_par_id); /*Added by aivhie 112201*/
     END IF;
	 --check if line_cd is SU and SHOW_BOND_SEQ_NO parameter is Y before updating its bond_seq_no by MAC 05/09/2012
     IF pol.line_cd = 'SU' AND v_bond_seq_no IS NOT NULL AND NVL(GIISP.V('SHOW_BOND_SEQ_NO'),'N') = 'Y' THEN
     		UPDATE gipi_wpolbas
     		   SET bond_seq_no = v_bond_seq_no
     		 WHERE par_id = p_new_par_id;
     END IF;
     v_bond_seq_no := NULL;
     --end of modification done by MAC 05/09/2012
     FOR C IN (SELECT PARAM_VALUE_N
                 FROM GIAC_PARAMETERS
                WHERE PARAM_NAME = 'PROD_TAKE_UP')LOOP
            VAR_VDATE := C.PARAM_VALUE_N;
       END LOOP;                        
     IF var_vdate = 1 OR (var_vdate = 3 AND SYSDATE > v_incept_date) THEN
            FOR C IN (SELECT BOOKING_YEAR, 
                        --TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'), 
                        BOOKING_MTH 
                      FROM GIIS_BOOKING_MONTH
                     WHERE  (NVL(BOOKED_TAG, 'N') != 'Y')
                       AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                        OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                            --AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))>= TO_NUMBER(TO_CHAR(SYSDATE, 'MM'))))
                            AND TO_DATE(BOOKING_MTH, 'MONTH')>= TO_DATE(TO_CHAR(SYSDATE, 'MONTH'),  'MONTH')))--joanne
                     --ORDER BY 1, 2 ) LOOP --marco - 10.15.2014 - replaced ORDER BY
                     ORDER BY TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)||'-'||BOOKING_YEAR, 'DD-MON-YYYY')) LOOP
              UPDATE gipi_wpolbas
                 SET booking_year = c.booking_year, --to_number(c.booking_year), joanne      
                   booking_mth  = c.booking_mth
             WHERE par_id = p_new_par_id;                   
            EXIT;
          END LOOP;                     
     ELSIF var_vdate = 2 OR    (var_vdate = 3 AND SYSDATE <= v_incept_date) THEN
            FOR C IN (SELECT BOOKING_YEAR, 
                         --TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'),
                         --TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)||'-'||BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'), 
                         BOOKING_MTH 
                      FROM GIIS_BOOKING_MONTH
                     WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
                       AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(v_incept_date, 'YYYY'))
                        OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(v_incept_date, 'YYYY'))
                       AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)||'-'||BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(v_incept_date, 'MM'))))
                     --ORDER BY 1, 2 ) LOOP --marco - 10.15.2014 - replaced ORDER BY
                     ORDER BY TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)||'-'||BOOKING_YEAR, 'DD-MON-YYYY')) LOOP
            UPDATE gipi_wpolbas
                 SET booking_year = to_number(c.booking_year),       
                   booking_mth  = c.booking_mth
             WHERE par_id = p_new_par_id;                    
            EXIT;
          END LOOP;                     
     END IF;     
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
     v_start_date         :=    NULL;
     v_pol_seq_no         :=    NULL;
     v_issue_yy           :=    NULL;
     v_par_yy             :=    NULL;
     v_renew_no           :=    NULL;
     v_with_tariff_sw     :=    NULL;
     v_place_cd           :=    NULL;
     v_cred_branch        :=    NULL;
     v_region_cd          :=    NULL;
     v_industry_cd        :=    NULL;
     v_risk_tag           :=    NULL;
	 v_takeup_term        :=    NULL; -- Queenie 1/14/11
     FOR OPEN_POL IN ( SELECT '1'
                         FROM giis_subline
                        WHERE line_cd = pol.line_cd
                          AND subline_cd = pol.subline_cd
                          AND open_policy_sw = 'Y') 
     LOOP 
         populate_open_policy(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
     END LOOP;
  END LOOP;
  change_item_grp(p_new_par_id, v_pack_pol_flag); 
  Populate_other_info(p_new_par_id, p_proc_summary_sw, p_old_pol_id, p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc,
                        p_line_mn, p_line_mh, p_line_en, p_user, p_vessel_cd, p_subline_bpv, p_open_flag, p_msg);
  IF (p_nbt_line_cd = p_line_en OR p_menu_line_cd = 'EN') THEN
      POPULATE_ENGG(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
  END IF;
  IF p_nbt_line_cd = p_line_su THEN
     POPULATE_BOND(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
  END IF;  
  POPULATE_POLNREP(p_new_par_id, p_old_pol_id, p_user);
  POPULATE_WARRANTIES(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);  
  POPULATE_REQDOCS(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);  
  POPULATE_MORTGAGEE(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);  
  POPULATE_POLGENIN(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg); 
  --POPULATE_REMINDER; --vin 9.23.2010 added to include reminders
  UPDATE_POLBAS_GIEXS004(p_new_par_id);
  IF p_new_pack_par_id IS NOT NULL THEN 
	update_pack_polbas(p_new_pack_par_id); -- added by: Nica 03.01.2013 updates the amounts in GIPI_PACK_WPOLBAS
  END IF;
  FOR A1 IN ( SELECT '1' 
                 FROM gipi_witem
             WHERE par_id = p_new_par_id)
  LOOP
    v_inv_sw := 'N';
    FOR A2 IN ( SELECT '1'
                  FROM gipi_witmperl
                 WHERE par_id = p_new_par_id)
      LOOP
          v_inv_sw := 'Y';
          EXIT;
      END LOOP;
  END LOOP;
  IF v_inv_sw = 'Y' THEN
     --CLEAR_MESSAGE;
     --MESSAGE('Inserting policy''s bill info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE;
     CREATE_WINVOICE(0, 0, 0, p_new_par_id,v_line_cd1,/*v_iss_cd1*/ v_issue_cd); --changed by apollo cruz 02.12.2015 from v_iss_cd1 to v_issue_cd
     cr_bill_dist.get_tsi(p_new_par_id);
     UPDATE_WINV_TAX(p_policy_id, p_new_par_id, v_issue_cd);
     --added by robert SR 5253 02.01.16
     IF p_nbt_line_cd = p_line_su OR p_menu_line_cd = 'SU' THEN
         BEGIN
            FOR wperl IN ( SELECT prem_rt, tsi_amt
                      FROM gipi_witmperl
                     WHERE par_id = p_new_par_id) 
            LOOP
                UPDATE gipi_winvoice
                      SET bond_rate = wperl.prem_rt, 
                          bond_tsi_amt = wperl.tsi_amt,
                          payt_terms = 'COD'  
                    WHERE par_id = p_new_par_id;
                EXIT;
            END LOOP;
         END;
         BEGIN
            FOR winv IN ( SELECT payt_terms, prem_amt, tax_amt
                      FROM gipi_winvoice
                     WHERE par_id = p_new_par_id)
            LOOP
                 gipi_winstallment_pkg.calc_payment_sched_gipis017b (p_new_par_id,winv.payt_terms,winv.prem_amt,winv.tax_amt); 
                EXIT;
            END LOOP;
         END;
      END IF; 
     --end of codes by robert SR 5253 02.01.16
     FOR A IN ( SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_polbasic
                 WHERE policy_id = rg_policy_id ) LOOP 
       /*
       ** The ff. commented by aivhie as this fetches wrong property whenever a policy
       ** has different item_grp in gipi_item
       ** Commented by : aivhie
       ** Date         : 112201
       */                     
       /*FOR pro IN ( SELECT property
                      FROM gipi_invoice
                     WHERE policy_id = rg_policy_id) LOOP
           UPDATE gipi_winvoice
              SET property = pro.property, 
                  prem_seq_no = prem_seq  
            WHERE par_id = variables.new_par_id;
       END LOOP;*/ 
       FOR B IN ( SELECT policy_id, endt_type
                    FROM gipi_polbasic
                   WHERE line_cd     = a.line_cd
                     AND subline_cd  = a.subline_cd
                     AND iss_cd      = a.iss_cd
                     AND issue_yy    = a.issue_yy
                     AND pol_seq_no  = a.pol_seq_no
                     AND renew_no    = a.renew_no
                     AND endt_seq_no > 0 ) LOOP
           p_policy_id := b.policy_id;
           IF b.endt_type = 'A' THEN
                 FOR C IN ( SELECT '1'
                              FROM gipi_item
                             WHERE policy_id = p_policy_id
                               AND rec_flag = 'A' ) LOOP
                     UPDATE gipi_winvoice
                        SET property = 'VARIOUS',
                            prem_seq_no = prem_seq
                      WHERE par_id = p_new_par_id;
                     EXIT;
                 END LOOP;                                                
           END IF;
       END LOOP;                
       EXIT;
     END LOOP;
--modified by bdarusin
--modified aug 21, 2000
--the if statement was inserted to exclude inserting of records in the gipi_wcomm_invoices
--table that has no intm_no, which was selected from giex_expiry in the process_post procedure    
     IF p_proc_intm_no IS NOT NULL THEN
           populate_wcomm_invoices(p_new_par_id, p_old_pol_id, p_proc_summary_sw, p_dsp_line_cd, p_proc_intm_no, p_dsp_iss_cd, p_iss_cd, p_msg);          
     END IF;
  END IF;   
  IF (p_proc_line_cd = p_line_ca OR p_menu_line_cd = 'CA') AND
     p_proc_subline_cd = p_subline_bbi THEN    
     POPULATE_BANK_SCHEDULE(p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);    
  END IF; 
END IF;
END;
/


