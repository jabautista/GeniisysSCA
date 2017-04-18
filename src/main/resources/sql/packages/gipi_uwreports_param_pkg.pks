CREATE OR REPLACE PACKAGE CPI.GIPI_UWREPORTS_PARAM_PKG AS 

    TYPE uwreports_param_type IS RECORD(
        tab_number          GIPI_UWREPORTS_PARAM.tab_number%TYPE,
        scope               GIPI_UWREPORTS_PARAM.scope%TYPE,
        param_date          GIPI_UWREPORTS_PARAM.param_date%TYPE,
        from_date           GIPI_UWREPORTS_PARAM.from_date%TYPE,
        to_date             GIPI_UWREPORTS_PARAM.to_date%TYPE,
        iss_cd              GIPI_UWREPORTS_PARAM.iss_cd%TYPE,
        line_cd             GIPI_UWREPORTS_PARAM.line_cd%TYPE,
        subline_cd          GIPI_UWREPORTS_PARAM.subline_cd%TYPE,
        iss_param           GIPI_UWREPORTS_PARAM.iss_param%TYPE,
        special_pol         GIPI_UWREPORTS_PARAM.special_pol%TYPE,
        assd_no             GIPI_UWREPORTS_PARAM.assd_no%TYPE,
        intm_no             GIPI_UWREPORTS_PARAM.intm_no%TYPE,
        user_id             GIPI_UWREPORTS_PARAM.user_id%TYPE,
        last_extract        GIPI_UWREPORTS_PARAM.last_extract%TYPE,
        ri_cd               GIPI_UWREPORTS_PARAM.ri_cd%TYPE,
        iss_name            GIIS_ISSOURCE.iss_name%TYPE,
        line_name           GIIS_LINE.line_name%TYPE,
        subline_name        GIIS_SUBLINE.subline_name%TYPE,
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        intm_type           GIIS_INTM_TYPE.intm_type%TYPE,
        intm_desc           VARCHAR2(50),
        intm_name           GIIS_INTERMEDIARY.intm_name%TYPE,
        ri_name             GIIS_REINSURER.ri_name%TYPE
    );
    TYPE uwreports_param_tab IS TABLE OF uwreports_param_type;
    
   TYPE get_ri_amounts_type IS RECORD ( --added edgar 03/05/2015
      policy_id             gipi_uwreports_dist_ext.POLICY_ID%TYPE,                
      trty_ri_comm          gipi_uwreports_dist_ext.TRTY_RI_COMM%TYPE,
      trty_ri_comm_vat      gipi_uwreports_dist_ext.TRTY_RI_COMM_VAT%TYPE
   );

   TYPE get_ri_amounts_tab IS TABLE OF get_ri_amounts_type; 
   
   TYPE get_intermediary_type IS RECORD ( --added edgar 03/05/2015
      policy_id             gipi_uwreports_dist_ext.POLICY_ID%TYPE,                
      intm_no               giac_prev_comm_inv.INTM_NO%TYPE,
      iss_cd                giac_prev_comm_inv.ISS_CD%TYPE,
      prem_seq_no           giac_prev_comm_inv.PREM_SEQ_NO%TYPE,
      comm_rec_id           giac_prev_comm_inv.comm_rec_id%TYPE
   );

   TYPE get_intermediary_tab IS TABLE OF get_intermediary_type;   
   
   -- added by jhing / benjo (06.23.2015)  for   UW-SPECS-2015-057 . Please be careful
   -- in modifying this collection types as they may affect extraction of TAB1 
   -- COLLECTION RECORDS
   TYPE gipiuwrep_ext IS RECORD (
      acct_ent_date        gipi_uwreports_ext.acct_ent_date%TYPE,
      assd_no              gipi_uwreports_ext.assd_no%TYPE,
      cancel_date          gipi_uwreports_ext.cancel_date%TYPE,
      comm_amt             gipi_uwreports_ext.comm_amt%TYPE,
      cred_branch          gipi_uwreports_ext.cred_branch%TYPE,
      cred_branch_param    gipi_uwreports_ext.cred_branch_param%TYPE,
      dist_flag            gipi_uwreports_ext.dist_flag%TYPE,
      doc_stamps           gipi_uwreports_ext.doc_stamps%TYPE,
      endt_iss_cd          gipi_uwreports_ext.endt_iss_cd%TYPE,
      endt_seq_no          gipi_uwreports_ext.endt_seq_no%TYPE,
      endt_type            gipi_uwreports_ext.endt_type%TYPE,
      endt_yy              gipi_uwreports_ext.endt_yy%TYPE,
      evatprem             gipi_uwreports_ext.evatprem%TYPE,
      expiry_date          gipi_uwreports_ext.expiry_date%TYPE,
      from_date            gipi_uwreports_ext.from_date%TYPE,
      fst                  gipi_uwreports_ext.fst%TYPE,
      incept_date          gipi_uwreports_ext.incept_date%TYPE,
      issue_date           gipi_uwreports_ext.issue_date%TYPE,
      issue_yy             gipi_uwreports_ext.issue_yy%TYPE,
      iss_cd               gipi_uwreports_ext.iss_cd%TYPE,
      item_grp             gipi_uwreports_ext.item_grp%TYPE,
      lgt                  gipi_uwreports_ext.lgt%TYPE,
      line_cd              gipi_uwreports_ext.line_cd%TYPE,
      multi_booking_mm     gipi_uwreports_ext.multi_booking_mm%TYPE,
      multi_booking_yy     gipi_uwreports_ext.multi_booking_yy%TYPE,
      no_tin_reason        gipi_uwreports_ext.no_tin_reason%TYPE,
      other_charges        gipi_uwreports_ext.other_charges%TYPE,
      other_taxes          gipi_uwreports_ext.other_taxes%TYPE,
      param_date           gipi_uwreports_ext.param_date%TYPE,
      policy_id            gipi_uwreports_ext.policy_id%TYPE,
      pol_flag             gipi_uwreports_ext.pol_flag%TYPE,
      pol_seq_no           gipi_uwreports_ext.pol_seq_no%TYPE,
      prem_seq_no          gipi_uwreports_ext.prem_seq_no%TYPE,
      prem_tax             gipi_uwreports_ext.prem_tax%TYPE,
      rec_type             gipi_uwreports_ext.rec_type%TYPE,
      ref_inv_no           gipi_uwreports_ext.ref_inv_no%TYPE,
      reg_policy_sw        gipi_uwreports_ext.reg_policy_sw%TYPE,
      reinstate_tag        gipi_uwreports_ext.reinstate_tag%TYPE,
      renew_no             gipi_uwreports_ext.renew_no%TYPE,
      SCOPE                gipi_uwreports_ext.SCOPE%TYPE,
      special_pol_param    gipi_uwreports_ext.special_pol_param%TYPE,
      spld_acct_ent_date   gipi_uwreports_ext.spld_acct_ent_date%TYPE,
      spld_date            gipi_uwreports_ext.spld_date%TYPE,
      subline_cd           gipi_uwreports_ext.subline_cd%TYPE,
      tab_number           gipi_uwreports_ext.tab_number%TYPE,
      takeup_seq_no        gipi_uwreports_ext.takeup_seq_no%TYPE,
      tin                  gipi_uwreports_ext.tin%TYPE,
      total_prem           gipi_uwreports_ext.total_prem%TYPE,
      total_tsi            gipi_uwreports_ext.total_tsi%TYPE,
      TO_DATE              gipi_uwreports_ext.TO_DATE%TYPE,
      user_id              gipi_uwreports_ext.user_id%TYPE,
      vat                  gipi_uwreports_ext.vat%TYPE,
      wholding_tax         gipi_uwreports_ext.wholding_tax%TYPE,
      currency_rt          gipi_uwreports_ext.currency_rt%TYPE,
      eff_date             gipi_uwreports_ext.eff_date%TYPE
   );

   TYPE uwreport_ext IS TABLE OF gipiuwrep_ext;

   TYPE gipiuwrep_dist_ext IS RECORD (
      acct_ent_date        gipi_uwreports_dist_ext.acct_ent_date%TYPE,
      assd_no              gipi_uwreports_dist_ext.assd_no%TYPE,
      branch_cd            gipi_uwreports_dist_ext.branch_cd%TYPE,
      comm                 gipi_uwreports_dist_ext.comm%TYPE,
      cred_branch          gipi_uwreports_dist_ext.cred_branch%TYPE,
      doc_stamps           gipi_uwreports_dist_ext.doc_stamps%TYPE,
      endt_seq_no          gipi_uwreports_dist_ext.endt_seq_no%TYPE,
      expiry_date          gipi_uwreports_dist_ext.expiry_date%TYPE,
      facultative          gipi_uwreports_dist_ext.facultative%TYPE,
      from_date            gipi_uwreports_dist_ext.from_date%TYPE,
      fst                  gipi_uwreports_dist_ext.fst%TYPE,
      incept_date          gipi_uwreports_dist_ext.incept_date%TYPE,
      issue_date           gipi_uwreports_dist_ext.issue_date%TYPE,
      issue_yy             gipi_uwreports_dist_ext.issue_yy%TYPE,
      iss_cd               gipi_uwreports_dist_ext.iss_cd%TYPE,
      item_grp             gipi_uwreports_dist_ext.item_grp%TYPE,
      last_update          gipi_uwreports_dist_ext.last_update%TYPE,
      lgt                  gipi_uwreports_dist_ext.lgt%TYPE,
      line_cd              gipi_uwreports_dist_ext.line_cd%TYPE,
      multi_booking_mm     gipi_uwreports_dist_ext.multi_booking_mm%TYPE,
      multi_booking_yy     gipi_uwreports_dist_ext.multi_booking_yy%TYPE,
      other_charges        gipi_uwreports_dist_ext.other_charges%TYPE,
      other_taxes          gipi_uwreports_dist_ext.other_taxes%TYPE,
      policy_id            gipi_uwreports_dist_ext.policy_id%TYPE,
      pol_flag             gipi_uwreports_dist_ext.pol_flag%TYPE,
      pol_seq_no           gipi_uwreports_dist_ext.pol_seq_no%TYPE,
      prem_amt             gipi_uwreports_dist_ext.prem_amt%TYPE,
      prem_seq_no          gipi_uwreports_dist_ext.prem_seq_no%TYPE,
      prem_tax             gipi_uwreports_dist_ext.prem_tax%TYPE,
      reg_policy_sw        gipi_uwreports_dist_ext.reg_policy_sw%TYPE,
      renew_no             gipi_uwreports_dist_ext.renew_no%TYPE,
      RETENTION            gipi_uwreports_dist_ext.RETENTION%TYPE,
      ri_comm              gipi_uwreports_dist_ext.ri_comm%TYPE,
      ri_comm_vat          gipi_uwreports_dist_ext.ri_comm_vat%TYPE,
      spld_acct_ent_date   gipi_uwreports_dist_ext.spld_acct_ent_date%TYPE,
      spld_date            gipi_uwreports_dist_ext.spld_date%TYPE,
      subline_cd           gipi_uwreports_dist_ext.subline_cd%TYPE,
      tab_number           gipi_uwreports_dist_ext.tab_number%TYPE,
      takeup_seq_no        gipi_uwreports_dist_ext.takeup_seq_no%TYPE,
      TO_DATE              gipi_uwreports_dist_ext.TO_DATE%TYPE,
      treaty               gipi_uwreports_dist_ext.treaty%TYPE,
      trty_ri_comm         gipi_uwreports_dist_ext.trty_ri_comm%TYPE,
      trty_ri_comm_vat     gipi_uwreports_dist_ext.trty_ri_comm_vat%TYPE,
      user_id              gipi_uwreports_dist_ext.user_id%TYPE,
      vat                  gipi_uwreports_dist_ext.vat%TYPE,
      currency_rt          gipi_uwreports_dist_ext.currency_rt%TYPE,
      eff_date             gipi_uwreports_dist_ext.eff_date%TYPE
   );

   TYPE uwreport_dist_ext IS TABLE OF gipiuwrep_dist_ext;

   TYPE gipiuwrep_dist_netret IS RECORD (
      acct_ent_date   gipi_uwreports_dist_netret.acct_ent_date%TYPE,
      acct_neg_date   gipi_uwreports_dist_netret.acct_neg_date%TYPE,
      dist_no         gipi_uwreports_dist_netret.dist_no%TYPE,
      dist_seq_no     gipi_uwreports_dist_netret.dist_seq_no%TYPE,
      item_grp        gipi_uwreports_dist_netret.item_grp%TYPE,
      line_cd         gipi_uwreports_dist_netret.line_cd%TYPE,
      peril_cd        gipi_uwreports_dist_netret.peril_cd%TYPE,
      policy_id       gipi_uwreports_dist_netret.policy_id%TYPE,
      prem_amt        gipi_uwreports_dist_netret.prem_amt%TYPE,
      rec_type        gipi_uwreports_dist_netret.rec_type%TYPE,
      SCOPE           gipi_uwreports_dist_netret.SCOPE%TYPE,
      share_cd        gipi_uwreports_dist_netret.share_cd%TYPE,
      tab_number      gipi_uwreports_dist_netret.tab_number%TYPE,
      takeup_seq_no   gipi_uwreports_dist_netret.takeup_seq_no%TYPE,
      user_id         gipi_uwreports_dist_netret.user_id%TYPE
   );

   TYPE uwreport_dist_netret IS TABLE OF gipiuwrep_dist_netret;

   TYPE gipiuwrep_dist_faculshr IS RECORD (
      acc_ent_date    gipi_uwreports_dist_faculshr.acc_ent_date%TYPE,
      acc_rev_date    gipi_uwreports_dist_faculshr.acc_rev_date%TYPE,
      dist_no         gipi_uwreports_dist_faculshr.dist_no%TYPE,
      dist_seq_no     gipi_uwreports_dist_faculshr.dist_seq_no%TYPE,
      fnl_binder_id   gipi_uwreports_dist_faculshr.fnl_binder_id%TYPE,
      frps_seq_no     gipi_uwreports_dist_faculshr.frps_seq_no%TYPE,
      frps_yy         gipi_uwreports_dist_faculshr.frps_yy%TYPE,
      item_grp        gipi_uwreports_dist_faculshr.item_grp%TYPE,
      last_update     gipi_uwreports_dist_faculshr.last_update%TYPE,
      line_cd         gipi_uwreports_dist_faculshr.line_cd%TYPE,
      peril_cd        gipi_uwreports_dist_faculshr.peril_cd%TYPE,
      policy_id       gipi_uwreports_dist_faculshr.policy_id%TYPE,
      rec_type        gipi_uwreports_dist_faculshr.rec_type%TYPE,
      ri_cd           gipi_uwreports_dist_faculshr.ri_cd%TYPE,
      ri_comm_amt     gipi_uwreports_dist_faculshr.ri_comm_amt%TYPE,
      ri_comm_vat     gipi_uwreports_dist_faculshr.ri_comm_vat%TYPE,
      ri_prem_amt     gipi_uwreports_dist_faculshr.ri_prem_amt%TYPE,
      SCOPE           gipi_uwreports_dist_faculshr.SCOPE%TYPE,
      tab_number      gipi_uwreports_dist_faculshr.tab_number%TYPE,
      takeup_seq_no   gipi_uwreports_dist_faculshr.takeup_seq_no%TYPE,
      user_id         gipi_uwreports_dist_faculshr.user_id%TYPE
   );

   TYPE uwreport_dist_faculshr IS TABLE OF gipiuwrep_dist_faculshr;

   TYPE gipi_uwrep_dist_trty IS RECORD (
      acct_ent_date   gipi_uwreports_dist_trty_cessn.acct_ent_date%TYPE,
      acct_neg_date   gipi_uwreports_dist_trty_cessn.acct_neg_date%TYPE,
      comm_amt        gipi_uwreports_dist_trty_cessn.comm_amt%TYPE,
      comm_vat        gipi_uwreports_dist_trty_cessn.comm_vat%TYPE,
      dist_no         gipi_uwreports_dist_trty_cessn.dist_no%TYPE,
      item_grp        gipi_uwreports_dist_trty_cessn.item_grp%TYPE,
      item_no         gipi_uwreports_dist_trty_cessn.item_no%TYPE,
      last_update     gipi_uwreports_dist_trty_cessn.last_update%TYPE,
      line_cd         gipi_uwreports_dist_trty_cessn.line_cd%TYPE,
      policy_id       gipi_uwreports_dist_trty_cessn.policy_id%TYPE,
      prem_amt        gipi_uwreports_dist_trty_cessn.prem_amt%TYPE,
      rec_type        gipi_uwreports_dist_trty_cessn.rec_type%TYPE,
      SCOPE           gipi_uwreports_dist_trty_cessn.SCOPE%TYPE,
      share_cd        gipi_uwreports_dist_trty_cessn.share_cd%TYPE,
      tab_number      gipi_uwreports_dist_trty_cessn.tab_number%TYPE,
      takeup_seq_no   gipi_uwreports_dist_trty_cessn.takeup_seq_no%TYPE,
      user_id         gipi_uwreports_dist_trty_cessn.user_id%TYPE
   );

   TYPE uwreport_dist_trty IS TABLE OF gipi_uwrep_dist_trty;

   TYPE gipi_uwrep_invperil IS RECORD (
      iss_cd             gipi_uwreports_invperil.iss_cd%TYPE,
      item_grp           gipi_uwreports_invperil.item_grp%TYPE,
      last_update        gipi_uwreports_invperil.last_update%TYPE,
      peril_cd           gipi_uwreports_invperil.peril_cd%TYPE,
      peril_type         gipi_uwreports_invperil.peril_type%TYPE,
      policy_id          gipi_uwreports_invperil.policy_id%TYPE,
      prem_amt           gipi_uwreports_invperil.prem_amt%TYPE,
      prem_seq_no        gipi_uwreports_invperil.prem_seq_no%TYPE,
      rec_type           gipi_uwreports_invperil.rec_type%TYPE,
      ri_comm_amt        gipi_uwreports_invperil.ri_comm_amt%TYPE,
      SCOPE              gipi_uwreports_invperil.SCOPE%TYPE,
      special_risk_tag   gipi_uwreports_invperil.special_risk_tag%TYPE,
      tab_number         gipi_uwreports_invperil.tab_number%TYPE,
      takeup_seq_no      gipi_uwreports_invperil.takeup_seq_no%TYPE,
      tsi_amt            gipi_uwreports_invperil.tsi_amt%TYPE,
      user_id            gipi_uwreports_invperil.user_id%TYPE,
      line_cd            gipi_uwreports_invperil.line_cd%type 
   );

   TYPE uwreport_invperil IS TABLE OF gipi_uwrep_invperil;

   TYPE gipi_uwrep_comminvperil IS RECORD (
      commission_amt     gipi_uwreports_comm_invperil.commission_amt%TYPE,
      intm_no            gipi_uwreports_comm_invperil.intm_no%TYPE,
      iss_cd             gipi_uwreports_comm_invperil.iss_cd%TYPE,
      item_grp           gipi_uwreports_comm_invperil.item_grp%TYPE,
      last_update        gipi_uwreports_comm_invperil.last_update%TYPE,
      peril_cd           gipi_uwreports_comm_invperil.peril_cd%TYPE,
      peril_type         gipi_uwreports_comm_invperil.peril_type%TYPE,
      policy_id          gipi_uwreports_comm_invperil.policy_id%TYPE,
      premium_amt        gipi_uwreports_comm_invperil.premium_amt%TYPE,
      prem_seq_no        gipi_uwreports_comm_invperil.prem_seq_no%TYPE,
      rec_type           gipi_uwreports_comm_invperil.rec_type%TYPE,
      SCOPE              gipi_uwreports_comm_invperil.SCOPE%TYPE,
      special_risk_tag   gipi_uwreports_comm_invperil.special_risk_tag%TYPE,
      tab_number         gipi_uwreports_comm_invperil.tab_number%TYPE,
      takeup_seq_no      gipi_uwreports_comm_invperil.takeup_seq_no%TYPE,
      user_id            gipi_uwreports_comm_invperil.user_id%TYPE,
      wholding_tax       gipi_uwreports_comm_invperil.wholding_tax%TYPE,
      line_cd            gipi_uwreports_comm_invperil.line_cd%type 
   );

   TYPE uwreport_comminvperl IS TABLE OF gipi_uwrep_comminvperil;

   TYPE gipi_uwrep_poltax IS RECORD (
      iss_cd          gipi_uwreports_polinv_tax_ext.iss_cd%TYPE,
      item_grp        gipi_uwreports_polinv_tax_ext.item_grp%TYPE,
      last_update     gipi_uwreports_polinv_tax_ext.last_update%TYPE,
      policy_id       gipi_uwreports_polinv_tax_ext.policy_id%TYPE,
      prem_seq_no     gipi_uwreports_polinv_tax_ext.prem_seq_no%TYPE,
      rec_type        gipi_uwreports_polinv_tax_ext.rec_type%TYPE,
      SCOPE           gipi_uwreports_polinv_tax_ext.SCOPE%TYPE,
      tab_number      gipi_uwreports_polinv_tax_ext.tab_number%TYPE,
      takeup_seq_no   gipi_uwreports_polinv_tax_ext.takeup_seq_no%TYPE,
      tax_amt         gipi_uwreports_polinv_tax_ext.tax_amt%TYPE,
      tax_cd          gipi_uwreports_polinv_tax_ext.tax_cd%TYPE,
      user_id         gipi_uwreports_polinv_tax_ext.user_id%TYPE
   );

   TYPE uwreport_poltax IS TABLE OF gipi_uwrep_poltax;
   -- end of added collections/variables by by jhing / benjo (06.23.2015)  for UW-SPECS-2015-057 
   
   
   
-- added collections/variables by Jhing 07.31.2015 for revised code of extract_tab5
   TYPE assdIntm_prod_type IS RECORD
   (
      ASSD_NAME           GIPI_UWREPORTS_INTM_EXT.ASSD_NAME%TYPE,
      ASSD_NO             GIPI_UWREPORTS_INTM_EXT.ASSD_NO%TYPE,
      COMM_AMT            GIPI_UWREPORTS_INTM_EXT.COMM_AMT%TYPE,
      CRED_BRANCH         GIPI_UWREPORTS_INTM_EXT.CRED_BRANCH%TYPE,
      CRED_BRANCH_PARAM   GIPI_UWREPORTS_INTM_EXT.CRED_BRANCH_PARAM%TYPE,
      DOC_STAMPS          GIPI_UWREPORTS_INTM_EXT.DOC_STAMPS%TYPE,
      ENDT_ISS_CD         GIPI_UWREPORTS_INTM_EXT.ENDT_ISS_CD%TYPE,
      ENDT_SEQ_NO         GIPI_UWREPORTS_INTM_EXT.ENDT_SEQ_NO%TYPE,
      ENDT_YY             GIPI_UWREPORTS_INTM_EXT.ENDT_YY%TYPE,
      EVATPREM            GIPI_UWREPORTS_INTM_EXT.EVATPREM%TYPE,
      EXPIRY_DATE         GIPI_UWREPORTS_INTM_EXT.EXPIRY_DATE%TYPE,
      FROM_DATE           GIPI_UWREPORTS_INTM_EXT.FROM_DATE%TYPE,
      FST                 GIPI_UWREPORTS_INTM_EXT.FST%TYPE,
      INCEPT_DATE         GIPI_UWREPORTS_INTM_EXT.INCEPT_DATE%TYPE,
      INTM_NAME           GIPI_UWREPORTS_INTM_EXT.INTM_NAME%TYPE,
      INTM_NO             GIPI_UWREPORTS_INTM_EXT.INTM_NO%TYPE,
      INTM_TYPE           GIPI_UWREPORTS_INTM_EXT.INTM_TYPE%TYPE,
      ISS_CD              GIPI_UWREPORTS_INTM_EXT.ISS_CD%TYPE,
      ISSUE_DATE          GIPI_UWREPORTS_INTM_EXT.ISSUE_DATE%TYPE,
      ISSUE_YY            GIPI_UWREPORTS_INTM_EXT.ISSUE_YY%TYPE,
      LGT                 GIPI_UWREPORTS_INTM_EXT.LGT%TYPE,
      LINE_CD             GIPI_UWREPORTS_INTM_EXT.LINE_CD%TYPE,
      LINE_NAME           GIPI_UWREPORTS_INTM_EXT.LINE_NAME%TYPE,
      OTHER_CHARGES       GIPI_UWREPORTS_INTM_EXT.OTHER_CHARGES%TYPE,
      OTHER_TAXES         GIPI_UWREPORTS_INTM_EXT.OTHER_TAXES%TYPE,
      PARAM_DATE          GIPI_UWREPORTS_INTM_EXT.PARAM_DATE%TYPE,
      POL_SEQ_NO          GIPI_UWREPORTS_INTM_EXT.POL_SEQ_NO%TYPE,
      POLICY_ID           GIPI_UWREPORTS_INTM_EXT.POLICY_ID%TYPE,
      PREM_SHARE_AMT      GIPI_UWREPORTS_INTM_EXT.PREM_SHARE_AMT%TYPE,
      RENEW_NO            GIPI_UWREPORTS_INTM_EXT.RENEW_NO%TYPE,
      SCOPE               GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
      SPECIAL_POL_PARAM   GIPI_UWREPORTS_INTM_EXT.SPECIAL_POL_PARAM%TYPE,
      SUBLINE_CD          GIPI_UWREPORTS_INTM_EXT.SUBLINE_CD%TYPE,
      SUBLINE_NAME        GIPI_UWREPORTS_INTM_EXT.SUBLINE_NAME%TYPE,
      TO_DATE             GIPI_UWREPORTS_INTM_EXT.TO_DATE%TYPE,
      TOTAL_PREM          GIPI_UWREPORTS_INTM_EXT.TOTAL_PREM%TYPE,
      TOTAL_TSI           GIPI_UWREPORTS_INTM_EXT.TOTAL_TSI%TYPE,
      USER_ID             GIPI_UWREPORTS_INTM_EXT.USER_ID%TYPE,
      WHOLDING_TAX        gipi_uwreports_intm_ext.wholding_tax%TYPE,
      rec_type            gipi_uwreports_intm_ext.rec_type%TYPE,
      VAT                 gipi_uwreports_intm_ext.VAT%TYPE,
      PREM_TAX            gipi_uwreports_intm_ext.PREM_TAX%TYPE,
      PREM_SEQ_NO         gipi_uwreports_intm_ext.prem_seq_no%TYPE,
      REF_INV_NO          gipi_uwreports_intm_ext.ref_inv_no%TYPE
   );


   TYPE assdIntm_prod_tab IS TABLE OF assdIntm_prod_type;


   TYPE assd_intm_temp_prod_type IS RECORD
   (
      policy_id            GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE,
      assd_name            GIPI_UWREPORTS_INTM_EXT.assd_name%TYPE,
      issue_date           GIPI_UWREPORTS_INTM_EXT.issue_date%TYPE,
      line_cd              GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
      subline_cd           GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
      iss_cd               GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      issue_yy             GIPI_UWREPORTS_INTM_EXT.issue_yy%TYPE,
      pol_seq_no           GIPI_UWREPORTS_INTM_EXT.pol_seq_no%TYPE,
      renew_no             GIPI_UWREPORTS_INTM_EXT.renew_no%TYPE,
      endt_iss_cd          GIPI_UWREPORTS_INTM_EXT.endt_iss_cd%TYPE,
      endt_yy              GIPI_UWREPORTS_INTM_EXT.endt_yy%TYPE,
      endt_seq_no          GIPI_UWREPORTS_INTM_EXT.endt_seq_no%TYPE,
      incept_date          GIPI_UWREPORTS_INTM_EXT.incept_date%TYPE,
      expiry_date          GIPI_UWREPORTS_INTM_EXT.expiry_date%TYPE,
      line_name            GIPI_UWREPORTS_INTM_EXT.line_name%TYPE,
      subline_name         GIPI_UWREPORTS_INTM_EXT.subline_name%TYPE,
      acct_ent_date        GIPI_POLBASIC.ACCT_ENT_DATE%TYPE,
      spld_acct_ent_date   GIPI_POLBASIC.SPLD_ACCT_ENT_DATE%TYPE,
      assd_no              GIPI_UWREPORTS_INTM_EXT.ASSD_NO%TYPE,
      cred_branch          GIPI_UWREPORTS_INTM_EXT.CRED_BRANCH%TYPE,
      target_security_br   giis_issource.iss_cd%TYPE
   );


   TYPE assd_intm_temp_prod_tab IS TABLE OF assd_intm_temp_prod_type;

   TYPE pol_per_intm_type IS RECORD
   (
      line_cd            gipi_polbasic.line_cd%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      iss_cd             gipi_invoice.iss_cd%TYPE,
      prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      ref_inv_no         gipi_invoice.ref_inv_no%TYPE,
      intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE,
      other_charges      gipi_uwreports_intm_ext.other_charges%TYPE,
      intm_name          giis_intermediary.intm_name%TYPE,
      intm_type          giis_intermediary.intm_type%TYPE,
      share_premium      gipi_uwreports_intm_ext.PREM_SHARE_AMT%TYPE,
      commission_amt     gipi_uwreports_intm_ext.comm_amt%TYPE,
      wholding_tax       gipi_uwreports_intm_ext.wholding_tax%TYPE,
      total_prem         gipi_uwreports_intm_ext.TOTAL_PREM%TYPE,
      total_tsi          gipi_uwreports_intm_ext.total_tsi%TYPE
   );


   TYPE pol_per_intm_tab IS TABLE OF pol_per_intm_type;


   TYPE tax_per_intm_type IS RECORD
   (
      policy_id     GIPI_UWREPORTS_INTM_TAX_EXT.policy_id%TYPE,
      iss_cd        GIPI_INVOICE.iss_cd%TYPE,
      prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE,
      tax_cd        GIPI_UWREPORTS_INTM_TAX_EXT.tax_cd%TYPE,
      tax_amt       GIPI_UWREPORTS_INTM_TAX_EXT.tax_amt%TYPE
   );

   TYPE tax_per_intm_tab IS TABLE OF tax_per_intm_type;

   TYPE taxIntm_prod_type IS RECORD
   (
      policy_id          GIPI_UWREPORTS_INTM_TAX_EXT.policy_id%TYPE,
      iss_cd             gipi_invoice.iss_cd%TYPE,
      prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      intrmdry_intm_no   GIPI_UWREPORTS_INTM_TAX_EXT.intm_no%TYPE,
      tax_cd             GIPI_UWREPORTS_INTM_TAX_EXT.tax_cd%TYPE,
      tax_amt            GIPI_UWREPORTS_INTM_TAX_EXT.tax_amt%TYPE,
      rec_type           GIPI_UWREPORTS_INTM_TAX_EXT.rec_type%TYPE,
      user_id            GIPI_UWREPORTS_INTM_TAX_EXT.user_id%TYPE,
      last_update        GIPI_UWREPORTS_INTM_TAX_EXT.last_update%TYPE
   );

   TYPE taxIntm_prod_tab IS TABLE OF taxIntm_prod_type;

-- end of added collections/variables for revised code of extract_Tab5    
    
    FUNCTION get_last_extract_params(
        p_user_id           GIPI_UWREPORTS_PARAM.user_id%TYPE,
        p_tab               NUMBER
    )
      RETURN uwreports_param_tab PIPELINED;         
      
      
    PROCEDURE extract_tab1(
        p_tab_number   IN   NUMBER,  -- added by benjo 06.23.2015  UW-SPECS-2015-057
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user_id      IN   VARCHAR2,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_nonaff_endt  IN   VARCHAR2,
        p_reinstated   IN   VARCHAR2, --edgar 03/05/2015
        p_withdist     IN   VARCHAR2  --edgar 03/06/2015
    );
      
    PROCEDURE Extract_Tab2(
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_tab1_scope   IN   NUMBER,--edgar 03/06/2015
        p_reinstated   IN   VARCHAR2 --edgar 03/06/2015
    );
    
    PROCEDURE extract_tab3(
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_tab1_scope   IN   NUMBER,--edgar 03/06/2015
        p_reinstated   IN   VARCHAR2 --edgar 03/06/2015
    );
    
    PROCEDURE extract_tab4(
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2
    );
    
    PROCEDURE extract_tab4_ri(
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2
    );
    
    PROCEDURE extract_tab5(
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_scope        IN   NUMBER,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_assd         IN   NUMBER,
        p_intm         IN   NUMBER,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_intm_type    IN   VARCHAR2
    );
    
    PROCEDURE extract_tab8(
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_scope        IN   NUMBER,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_ri           IN   NUMBER,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_tab1_scope   IN   NUMBER,--edgar 03/06/2015
        p_reinstated   IN   VARCHAR2 --edgar 03/06/2015
    ); 

    PROCEDURE EDST(
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_parameter    IN   NUMBER
    );
    
    PROCEDURE pol_gixx_pol_prod(
        p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
        p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_nonaff_endt  IN   VARCHAR2,
        p_reinstated   IN   VARCHAR2 --edgar 03/05/2015
    );
    
    PROCEDURE pop_uwreports_dist_ext
    (  p_scope          IN   NUMBER,
       p_param_date     IN   NUMBER,
       p_from_date      IN   DATE,
       p_to_date        IN   DATE,
       p_iss_cd         IN   VARCHAR2,
       p_line_cd        IN   VARCHAR2,
       p_subline_cd     IN   VARCHAR2,
       p_user           IN   VARCHAR2,
       p_param          IN   NUMBER
    );
    
    FUNCTION Check_Date_Dist_Peril(
        p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
        p_param_date        NUMBER,
        p_from_date         DATE,
        p_to_date           DATE
    )
        RETURN NUMBER;
        
    FUNCTION Check_Date_Policy(
        p_scope             NUMBER,
        p_param_date        NUMBER,
        p_from_date         DATE,
        p_to_date           DATE,
        p_issue_date        DATE,
        p_eff_date          DATE,
        p_acct_ent_date     DATE,
        p_spld_acct         DATE,
        p_booking_mth       GIPI_POLBASIC.booking_mth%TYPE,
        p_booking_year      GIPI_POLBASIC.booking_year%TYPE,
        p_cancel_date       GIPI_POLBASIC.cancel_date%TYPE,
        p_endt_seq_no       GIPI_POLBASIC.endt_seq_no%TYPE
    )
        RETURN NUMBER;
        
    FUNCTION check_extracted_data_dist(
        p_user_id           GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE,
        p_line_cd           GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_DIST_PERIL_EXT.scope%TYPE
    )
        RETURN VARCHAR2;
        
    FUNCTION check_extracted_data_outward(
        p_user_id           GIPI_UWREPORTS_RI_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_RI_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_RI_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_RI_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_RI_EXT.scope%TYPE
    )
        RETURN VARCHAR2;
        
    FUNCTION check_extracted_data_per_peril(
        p_user_id           GIPI_UWREPORTS_PERIL_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_PERIL_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_PERIL_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_PERIL_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_PERIL_EXT.scope%TYPE
    )
        RETURN VARCHAR2;
        
    FUNCTION check_extracted_data_per_assd(
        p_user_id           GIPI_UWREPORTS_INTM_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_INTM_EXT.scope%TYPE,
        p_assd_no           GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
        p_intm_no           GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE,
        p_intm_type         GIPI_UWREPORTS_INTM_EXT.intm_TYPE%TYPE
    )
        RETURN VARCHAR2;
        
    FUNCTION check_extracted_data_inward(
         p_user_id           GIPI_UWREPORTS_INW_RI_EXT.user_id%TYPE,
         p_iss_cd            GIPI_UWREPORTS_INW_RI_EXT.iss_cd%TYPE,
         p_line_cd           GIPI_UWREPORTS_INW_RI_EXT.line_cd%TYPE,
         p_subline_cd        GIPI_UWREPORTS_INW_RI_EXT.subline_cd%TYPE,
         p_scope             GIPI_UWREPORTS_INW_RI_EXT.scope%TYPE,
         p_ri_cd             GIPI_UWREPORTS_INW_RI_EXT.ri_cd%TYPE
    )
        RETURN VARCHAR2;
        
    FUNCTION check_extracted_data_policy(
        p_user_id           GIPI_UWREPORTS_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_EXT.subline_cd%TYPE
    )
        RETURN VARCHAR2;
        
    PROCEDURE pol_taxes2(
        p_item_grp          GIPI_INVOICE.item_grp%TYPE,
        p_takeup_seq_no     GIPI_INVOICE.takeup_seq_no%TYPE,
        p_policy_id         GIPI_INVOICE.policy_id%TYPE,
        --ADDED BY ROSE 11042009 TO AVOID ERROR IN WRONG ARGUMENTS--
        p_scope         IN  NUMBER,   -- aaron 061009
        p_param_date    IN  NUMBER,
        p_from_date     IN  DATE,
        p_to_date       IN  DATE,
        p_user          IN  VARCHAR2
    );
    
    FUNCTION get_comm_amt(
        p_prem_seq_no NUMBER,
        p_iss_cd VARCHAR2,
        -- added by rose to avoid the error in wrong type of arguments 11/04/2009--
        p_scope      NUMBER,   -- aaron 061009
        p_param_date  NUMBER,
        p_from_date    DATE,
        p_to_date      DATE,
        p_policy_id  NUMBER
    )
      RETURN NUMBER;
      
   PROCEDURE COPY_TAB1
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_user         IN   VARCHAR2);    
    
    PROCEDURE pop_uwreports_dist_ext2 (
       p_scope        IN   NUMBER,
       p_param_date   IN   NUMBER,
       p_from_date    IN   DATE,
       p_to_date      IN   DATE,
       p_iss_cd       IN   VARCHAR2,
       p_line_cd      IN   VARCHAR2,
       p_subline_cd   IN   VARCHAR2,
       p_user         IN   VARCHAR2,
       p_param        IN   NUMBER
    );      
    
   FUNCTION get_ri_amounts (
      p_param           NUMBER,
      p_param_date      NUMBER,
      p_iss_cd          VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_from_date       DATE,
      p_to_date         DATE,
      p_user            VARCHAR2
   )
      RETURN get_ri_amounts_tab PIPELINED;  
      
   FUNCTION get_intermediary (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_scope           VARCHAR2,
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE
   )
      RETURN get_intermediary_tab PIPELINED;             
END GIPI_UWREPORTS_PARAM_PKG;
/
