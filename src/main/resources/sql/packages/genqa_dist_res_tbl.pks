CREATE OR REPLACE PACKAGE CPI.genqa_dist_res_tbl
AS
/* ***************************************************************************************************************************************
      -- declaration of table records, types and other variables
   ************************************************************************************************************************************** */
   TYPE f_poldtl_rec_type IS RECORD (
      dist_no         giuw_policyds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_policyds_dtl.dist_seq_no%TYPE,
      line_cd         giuw_policyds_dtl.line_cd%TYPE,
      share_cd        giuw_policyds_dtl.share_cd%TYPE,
      dist_tsi        giuw_policyds_dtl.dist_tsi%TYPE,
      dist_prem       giuw_policyds_dtl.dist_prem%TYPE,
      dist_spct       giuw_policyds_dtl.dist_spct%TYPE,
      dist_spct1      giuw_policyds_dtl.dist_spct1%TYPE,
      ann_dist_spct   giuw_policyds_dtl.ann_dist_spct%TYPE,
      ann_dist_tsi    giuw_policyds_dtl.ann_dist_tsi%TYPE,
      dist_grp        giuw_policyds_dtl.dist_grp%TYPE
   );

   TYPE f_itemdtl_rec_type IS RECORD (
      dist_no         giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no         giuw_itemds_dtl.item_no%TYPE,
      line_cd         giuw_itemds_dtl.line_cd%TYPE,
      share_cd        giuw_itemds_dtl.share_cd%TYPE,
      dist_spct       giuw_itemds_dtl.dist_spct%TYPE,
      dist_spct1      giuw_itemds_dtl.dist_spct1%TYPE,
      dist_tsi        giuw_itemds_dtl.dist_tsi%TYPE,
      dist_prem       giuw_itemds_dtl.dist_prem%TYPE,
      ann_dist_spct   giuw_itemds_dtl.ann_dist_spct%TYPE,
      ann_dist_tsi    giuw_itemds_dtl.ann_dist_tsi%TYPE,
      dist_grp        giuw_itemds_dtl.dist_grp%TYPE
   );

   TYPE f_perildtl_rec_type IS RECORD (
      dist_no         giuw_perilds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_perilds_dtl.dist_seq_no%TYPE,
      peril_cd        giuw_perilds_dtl.peril_cd%TYPE,
      line_cd         giuw_perilds_dtl.line_cd%TYPE,
      share_cd        giuw_perilds_dtl.share_cd%TYPE,
      dist_tsi        giuw_perilds_dtl.dist_tsi%TYPE,
      dist_prem       giuw_perilds_dtl.dist_prem%TYPE,
      dist_spct       giuw_perilds_dtl.dist_spct%TYPE,
      dist_spct1      giuw_perilds_dtl.dist_spct1%TYPE,
      ann_dist_spct   giuw_perilds_dtl.ann_dist_spct%TYPE,
      ann_dist_tsi    giuw_perilds_dtl.ann_dist_tsi%TYPE,
      dist_grp        giuw_perilds_dtl.dist_grp%TYPE
   );

   TYPE f_itemperildtl_rec_type IS RECORD (
      dist_no         giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no         giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd        giuw_itemperilds_dtl.peril_cd%TYPE,
      line_cd         giuw_itemperilds_dtl.line_cd%TYPE,
      share_cd        giuw_itemperilds_dtl.share_cd%TYPE,
      dist_spct       giuw_itemperilds_dtl.dist_spct%TYPE,
      dist_spct1      giuw_itemperilds_dtl.dist_spct1%TYPE,
      dist_tsi        giuw_itemperilds_dtl.dist_tsi%TYPE,
      dist_prem       giuw_itemperilds_dtl.dist_prem%TYPE,
      ann_dist_spct   giuw_itemperilds_dtl.ann_dist_spct%TYPE,
      ann_dist_tsi    giuw_itemperilds_dtl.ann_dist_tsi%TYPE,
      dist_grp        giuw_itemperilds_dtl.dist_grp%TYPE
   );

   TYPE poldtl_disc_amt_rec_type IS RECORD (
      dist_no       giuw_policyds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_policyds_dtl.dist_seq_no%TYPE,
      tsi_amt       giuw_policyds.tsi_amt%TYPE,
      dist_tsi      giuw_policyds_dtl.dist_tsi%TYPE,
      prem_amt      giuw_policyds.prem_amt%TYPE,
      dist_prem     giuw_policyds_dtl.dist_prem%TYPE,
      diff_tsi      giuw_policyds.tsi_amt%TYPE,
      diff_prem     giuw_policyds.prem_amt%TYPE
   );

   TYPE itemdtl_disc_amt_rec_type IS RECORD (
      dist_no       giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no       giuw_itemds_dtl.item_no%TYPE,
      tsi_amt       giuw_itemds.tsi_amt%TYPE,
      dist_tsi      giuw_itemds_dtl.dist_tsi%TYPE,
      prem_amt      giuw_itemds.prem_amt%TYPE,
      dist_prem     giuw_itemds_dtl.dist_prem%TYPE,
      diff_tsi      giuw_itemds.tsi_amt%TYPE,
      diff_prem     giuw_itemds.prem_amt%TYPE
   );

   TYPE perildtl_disc_amt_rec_type IS RECORD (
      dist_no       giuw_perilds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_perilds_dtl.dist_seq_no%TYPE,
      peril_cd      giuw_perilds_dtl.peril_cd%TYPE,
      tsi_amt       giuw_perilds.tsi_amt%TYPE,
      dist_tsi      giuw_perilds_dtl.dist_tsi%TYPE,
      prem_amt      giuw_perilds.prem_amt%TYPE,
      dist_prem     giuw_perilds_dtl.dist_prem%TYPE,
      diff_tsi      giuw_perilds.tsi_amt%TYPE,
      diff_prem     giuw_perilds.prem_amt%TYPE
   );

   TYPE itemperildtl_disc_amt_rec_type IS RECORD (
      dist_no       giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no       giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd      giuw_itemperilds_dtl.peril_cd%TYPE,
      tsi_amt       giuw_itemperilds.tsi_amt%TYPE,
      dist_tsi      giuw_perilds_dtl.dist_tsi%TYPE,
      prem_amt      giuw_itemperilds.prem_amt%TYPE,
      dist_prem     giuw_itemperilds_dtl.dist_prem%TYPE,
      diff_tsi      giuw_itemperilds.tsi_amt%TYPE,
      diff_prem     giuw_itemperilds.prem_amt%TYPE
   );

   TYPE itmperil_itm_disc_amt_rec_type IS RECORD (
      dist_no         giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no         giuw_itemds_dtl.item_no%TYPE,
      share_cd        giuw_itemds_dtl.share_cd%TYPE,
      item_tsi        giuw_itemds.tsi_amt%TYPE,
      itmperil_tsi    giuw_itemds.tsi_amt%TYPE,
      item_prem       giuw_itemds.prem_amt%TYPE,
      itmperil_prem   giuw_itemds.prem_amt%TYPE,
      diff_tsi        giuw_itemds.tsi_amt%TYPE,
      diff_prem       giuw_itemds.prem_amt%TYPE
   );

   TYPE itmperil_peril_disc_rec_type IS RECORD (
      dist_no         giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemds_dtl.dist_seq_no%TYPE,
      peril_cd        giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd        giuw_itemds_dtl.share_cd%TYPE,
      peril_tsi       giuw_policyds.tsi_amt%TYPE,
      itmperil_tsi    giuw_policyds.tsi_amt%TYPE,
      peril_prem      giuw_policyds.prem_amt%TYPE,
      itmperil_prem   giuw_policyds.prem_amt%TYPE,
      diff_tsi        giuw_policyds.tsi_amt%TYPE,
      diff_prem       giuw_policyds.prem_amt%TYPE
   );

   TYPE pol_oth_disc_rec_type IS RECORD (
      dist_no       giuw_policyds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_policyds_dtl.dist_seq_no%TYPE,
      share_cd      giuw_policyds_dtl.share_cd%TYPE,
      policy_tsi    giuw_policyds.tsi_amt%TYPE,
      oth_tsi       giuw_policyds.tsi_amt%TYPE,
      policy_prem   giuw_policyds.prem_amt%TYPE,
      oth_prem      giuw_policyds.prem_amt%TYPE,
      diff_tsi      giuw_policyds.tsi_amt%TYPE,
      diff_prem     giuw_policyds.prem_amt%TYPE
   );

   TYPE perildtl_frps_disc_rec_type IS RECORD (
      dist_no        giuw_policyds.dist_no%TYPE,
      dist_seq_no    giuw_policyds.dist_seq_no%TYPE,
      line_cd        giri_wdistfrps.line_cd%TYPE,
      frps_yy        giri_wdistfrps.frps_yy%TYPE,
      frps_seq_no    giri_wdistfrps.frps_seq_no%TYPE,
      dist_tsi       giuw_policyds.tsi_amt%TYPE,
      dist_prem      giuw_policyds.prem_amt%TYPE,
      tot_fac_tsi    giri_wdistfrps.tot_fac_tsi%TYPE,
      tot_fac_prem   giri_wdistfrps.tot_fac_prem%TYPE,
      diff_tsi       giuw_policyds.tsi_amt%TYPE,
      diff_prem      giuw_policyds.prem_amt%TYPE
   );

   TYPE poldtl_frps_disc_rec_type IS RECORD (
      dist_no         giuw_policyds.dist_no%TYPE,
      dist_seq_no     giuw_policyds.dist_seq_no%TYPE,
      line_cd         giri_wdistfrps.line_cd%TYPE,
      frps_yy         giri_wdistfrps.frps_yy%TYPE,
      frps_seq_no     giri_wdistfrps.frps_seq_no%TYPE,
      dist_spct       giuw_policyds_dtl.dist_spct%TYPE,
      dist_spct1      giuw_policyds_dtl.dist_spct1%TYPE,
      tot_fac_spct    giri_wdistfrps.tot_fac_spct%TYPE,
      tot_fac_spct2   giri_wdistfrps.tot_fac_spct2%TYPE,
      diff_tsi        giuw_policyds.tsi_amt%TYPE,
      diff_prem       giuw_policyds.prem_amt%TYPE,
      diff_spct       giuw_policyds_dtl.dist_spct%TYPE,
      diff_spct1      giuw_policyds_dtl.dist_spct1%TYPE
   );

   TYPE f_politem_rec_type IS RECORD (
      dist_no       giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no       giuw_itemds_dtl.item_no%TYPE,
      share_cd      giuw_itemds_dtl.share_cd%TYPE,
      dist_spct     giuw_itemds_dtl.dist_spct%TYPE,
      dist_spct1    giuw_itemds_dtl.dist_spct1%TYPE
   );

   TYPE f_politemperil_rec_type IS RECORD (
      dist_no       giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no       giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd      giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd      giuw_itemperilds_dtl.share_cd%TYPE,
      dist_spct     giuw_itemperilds_dtl.dist_spct%TYPE,
      dist_spct1    giuw_itemperilds_dtl.dist_spct1%TYPE
   );

   TYPE f_polperil_rec_type IS RECORD (
      dist_no       giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemperilds_dtl.dist_seq_no%TYPE,
      peril_cd      giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd      giuw_itemperilds_dtl.share_cd%TYPE,
      dist_spct     giuw_itemperilds_dtl.dist_spct%TYPE,
      dist_spct1    giuw_itemperilds_dtl.dist_spct1%TYPE
   );

   TYPE pdist_item_rec_type IS RECORD (
      dist_no       giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no       giuw_itemds_dtl.item_no%TYPE,
      share_cd      giuw_itemds_dtl.share_cd%TYPE
   );

   TYPE pdist_itemperil_rec_type IS RECORD (
      dist_no       giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no       giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd      giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd      giuw_itemperilds_dtl.share_cd%TYPE
   );

   TYPE pdist_polperil_rec_type IS RECORD (
      dist_no       giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no   giuw_itemperilds_dtl.dist_seq_no%TYPE,
      share_cd      giuw_itemperilds_dtl.share_cd%TYPE
   );

   TYPE diff_orsk_itemdtl_rec_type IS RECORD (
      dist_no           giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no       giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no           giuw_itemds_dtl.item_no%TYPE,
      share_cd          giuw_itemds_dtl.share_cd%TYPE,
      pol_dist_spct     giuw_itemds_dtl.dist_spct%TYPE,
      pol_dist_spct1    giuw_itemds_dtl.dist_spct1%TYPE,
      item_dist_spct    giuw_itemds_dtl.dist_spct%TYPE,
      item_dist_spct1   giuw_itemds_dtl.dist_spct1%TYPE,
      diff_spct         giuw_itemds_dtl.dist_spct%TYPE,
      diff_spct1        giuw_itemds_dtl.dist_spct1%TYPE
   );

   TYPE diff_orsk_itmpldtl_rec_type IS RECORD (
      dist_no               giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no           giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no               giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd              giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd              giuw_itemperilds_dtl.share_cd%TYPE,
      pol_dist_spct         giuw_itemperilds_dtl.dist_spct%TYPE,
      pol_dist_spct1        giuw_itemperilds_dtl.dist_spct1%TYPE,
      itmperil_dist_spct    giuw_itemperilds_dtl.dist_spct%TYPE,
      itmperil_dist_spct1   giuw_itemperilds_dtl.dist_spct1%TYPE,
      diff_spct             giuw_itemperilds_dtl.dist_spct%TYPE,
      diff_spct1            giuw_itemperilds_dtl.dist_spct1%TYPE
   );

   TYPE diff_orsk_peril_rec_type IS RECORD (
      dist_no            giuw_perilds_dtl.dist_no%TYPE,
      dist_seq_no        giuw_perilds_dtl.dist_seq_no%TYPE,
      peril_cd           giuw_perilds_dtl.peril_cd%TYPE,
      share_cd           giuw_perilds_dtl.share_cd%TYPE,
      pol_dist_spct      giuw_perilds_dtl.dist_spct%TYPE,
      pol_dist_spct1     giuw_perilds_dtl.dist_spct1%TYPE,
      peril_dist_spct    giuw_perilds_dtl.dist_spct%TYPE,
      peril_dist_spct1   giuw_perilds_dtl.dist_spct1%TYPE,
      diff_spct          giuw_perilds_dtl.dist_spct%TYPE,
      diff_spct1         giuw_perilds_dtl.dist_spct1%TYPE
   );

   TYPE itmperil_peril_rec_type IS RECORD (
      dist_no         giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemperilds_dtl.dist_seq_no%TYPE,
      peril_cd        giuw_perilds_dtl.peril_cd%TYPE,
      share_cd        giuw_perilds_dtl.share_cd%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      itmperil_tsi    giuw_policyds.tsi_amt%TYPE,
      itmperil_prem   giuw_policyds.prem_amt%TYPE,
      peril_tsi       giuw_policyds.tsi_amt%TYPE,
      peril_prem      giuw_policyds.prem_amt%TYPE,
      diff_tsi        giuw_policyds.tsi_amt%TYPE,
      diff_prem       giuw_policyds.prem_amt%TYPE
   );

   TYPE itmperil_policy_rec_type IS RECORD (
      dist_no         giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemperilds_dtl.dist_seq_no%TYPE,
      share_cd        giuw_perilds_dtl.share_cd%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      itmperil_tsi    giuw_policyds.tsi_amt%TYPE,
      itmperil_prem   giuw_policyds.prem_amt%TYPE,
      policy_tsi      giuw_policyds.tsi_amt%TYPE,
      policy_prem     giuw_policyds.prem_amt%TYPE,
      diff_tsi        giuw_policyds.tsi_amt%TYPE,
      diff_prem       giuw_policyds.prem_amt%TYPE
   );

   TYPE itmperil_item_rec_type IS RECORD (
      dist_no         giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no         giuw_itemds_dtl.item_no%TYPE,
      share_cd        giuw_itemds_dtl.share_cd%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      itmperil_tsi    giuw_policyds.tsi_amt%TYPE,
      itmperil_prem   giuw_policyds.prem_amt%TYPE,
      item_tsi        giuw_policyds.tsi_amt%TYPE,
      item_prem       giuw_policyds.prem_amt%TYPE,
      diff_tsi        giuw_policyds.tsi_amt%TYPE,
      diff_prem       giuw_policyds.prem_amt%TYPE
   );

   TYPE itmperil_comp_rec_type IS RECORD (
      dist_no               giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no           giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no               giuw_itemperilds_dtl.item_no%TYPE,
      perl_cd               giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd              giuw_itemperilds_dtl.share_cd%TYPE,
      pol_dist_spct         giuw_itemperilds_dtl.dist_spct%TYPE,
      pol_dist_spct1        giuw_itemperilds_dtl.dist_spct1%TYPE,
      computed_tsi          giuw_itemperilds_dtl.dist_tsi%TYPE,
      computed_prem         giuw_itemperilds_dtl.dist_prem%TYPE,
      itmperil_dist_spct    giuw_itemperilds_dtl.dist_spct%TYPE,
      itmperil_dist_spct1   giuw_itemperilds_dtl.dist_spct1%TYPE,
      itmperil_dist_tsi     giuw_itemperilds_dtl.dist_tsi%TYPE,
      itmperil_dist_prem    giuw_itemperilds_dtl.dist_prem%TYPE,
      diff_dist_spct        giuw_itemperilds_dtl.dist_spct%TYPE,
      diff_dist_spct1       giuw_itemperilds_dtl.dist_spct1%TYPE,
      diff_tsi              giuw_itemperilds_dtl.dist_tsi%TYPE,
      diff_prem             giuw_itemperilds_dtl.dist_prem%TYPE
   );

   TYPE policyc_comp_rec_type IS RECORD (
      dist_no         giuw_policyds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_policyds_dtl.dist_seq_no%TYPE,
      share_cd        giuw_policyds_dtl.share_cd%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      dist_spct       giuw_policyds_dtl.dist_spct%TYPE,
      dist_tsi        giuw_policyds_dtl.dist_tsi%TYPE,
      dist_prem       giuw_policyds_dtl.dist_prem%TYPE,
      computed_tsi    giuw_policyds_dtl.dist_tsi%TYPE,
      computed_prem   giuw_policyds_dtl.dist_prem%TYPE,
      diff_tsi        giuw_policyds_dtl.dist_tsi%TYPE,
      diff_prem       giuw_policyds_dtl.dist_prem%TYPE,
      diff_spct       giuw_policyds_dtl.dist_spct%TYPE,
      diff_spct1      giuw_policyds_dtl.dist_spct1%TYPE
   );

   TYPE itmperil_comp_perild_rec_type IS RECORD (
      dist_no               giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no           giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no               giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd              giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd              giuw_itemperilds_dtl.share_cd%TYPE,
      itmperil_dist_spct    giuw_itemperilds_dtl.dist_spct%TYPE,
      itmperil_dist_spct1   giuw_itemperilds_dtl.dist_spct1%TYPE,
      peril_dist_spct       giuw_perilds_dtl.dist_spct%TYPE,
      peril_dist_spct1      giuw_perilds_dtl.dist_spct1%TYPE,
      itmperil_dist_tsi     giuw_itemperilds_dtl.dist_tsi%TYPE,
      itmperil_dist_prem    giuw_itemperilds_dtl.dist_prem%TYPE,
      computed_tsi          giuw_itemperilds_dtl.dist_tsi%TYPE,
      computed_prem         giuw_itemperilds_dtl.dist_prem%TYPE,
      diff_dist_spct        giuw_itemperilds_dtl.dist_spct%TYPE,
      diff_dist_spct1       giuw_itemperilds_dtl.dist_spct1%TYPE,
      diff_dist_tsi         giuw_itemperilds_dtl.dist_tsi%TYPE,
      diff_dist_prem        giuw_itemperilds_dtl.dist_prem%TYPE
   );

   TYPE pdist_comp_shr_itm_rec_type IS RECORD (
      dist_no              giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no          giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no              giuw_itemds_dtl.item_no%TYPE,
      share_cd             giuw_itemds_dtl.share_cd%TYPE,
      trty_name            giis_dist_share.trty_name%TYPE,
      computed_dist_spct   giuw_itemds_dtl.dist_spct%TYPE,
      item_dist_spct       giuw_itemds_dtl.dist_spct%TYPE,
      diff_spct            VARCHAR (20)
   );

   TYPE pdist_comp_shr_itm_rec_type2 IS RECORD (
      dist_no               giuw_itemds_dtl.dist_no%TYPE,
      dist_seq_no           giuw_itemds_dtl.dist_seq_no%TYPE,
      item_no               giuw_itemds_dtl.item_no%TYPE,
      share_cd              giuw_itemds_dtl.share_cd%TYPE,
      trty_name             giis_dist_share.trty_name%TYPE,
      computed_dist_spct1   giuw_itemds_dtl.dist_spct1%TYPE,
      item_dist_spct1       giuw_itemds_dtl.dist_spct1%TYPE,
      diff_spct1            VARCHAR (20)
   );

   TYPE pdist_comp_shr_pol_rec_type IS RECORD (
      dist_no              giuw_policyds_dtl.dist_no%TYPE,
      dist_seq_no          giuw_policyds_dtl.dist_seq_no%TYPE,
      share_cd             giuw_policyds_dtl.share_cd%TYPE,
      trty_name            giis_dist_share.trty_name%TYPE,
      computed_dist_spct   giuw_policyds_dtl.dist_spct%TYPE,
      pol_dist_spct        giuw_policyds_dtl.dist_spct%TYPE,
      diff_spct            VARCHAR (20)
   );

   TYPE pdist_comp_shr_pol_rec_type2 IS RECORD (
      dist_no               giuw_policyds_dtl.dist_no%TYPE,
      dist_seq_no           giuw_policyds_dtl.dist_seq_no%TYPE,
      share_cd              giuw_policyds_dtl.share_cd%TYPE,
      trty_name             giis_dist_share.trty_name%TYPE,
      computed_dist_spct1   giuw_policyds_dtl.dist_spct1%TYPE,
      pol_dist_spct1        giuw_policyds_dtl.dist_spct1%TYPE,
      diff_spct1            VARCHAR (20)
   );

   TYPE pcomp_perildtl_rec_type IS RECORD (
      dist_no         giuw_perilds_dtl.dist_no%TYPE,
      dist_seq_no     giuw_perilds_dtl.dist_seq_no%TYPE,
      peril_cd        giuw_perilds_dtl.peril_cd%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      dist_spct       giuw_perilds_dtl.dist_spct%TYPE,
      dist_tsi        giuw_perilds_dtl.dist_tsi%TYPE,
      dist_prem       giuw_perilds_dtl.dist_prem%TYPE,
      computed_tsi    giuw_perilds_dtl.dist_tsi%TYPE,
      computed_prem   giuw_perilds_dtl.dist_prem%TYPE,
      diff_tsi        giuw_perilds_dtl.dist_tsi%TYPE,
      diff_prem       giuw_perilds_dtl.dist_prem%TYPE
   );

   TYPE pcomp_itmperildtl_rec_type IS RECORD (
      dist_no               giuw_itemperilds_dtl.dist_no%TYPE,
      dist_seq_no           giuw_itemperilds_dtl.dist_seq_no%TYPE,
      item_no               giuw_itemperilds_dtl.item_no%TYPE,
      peril_cd              giuw_itemperilds_dtl.peril_cd%TYPE,
      share_cd              giuw_itemperilds_dtl.share_cd%TYPE,
      peril_dist_spct       giuw_perilds_dtl.dist_spct%TYPE,
      peril_dist_spct1      giuw_perilds_dtl.dist_spct1%TYPE,
      itmperil_dist_spct    giuw_itemperilds_dtl.dist_spct%TYPE,
      itmperil_dist_spct1   giuw_itemperilds_dtl.dist_spct1%TYPE,
      computed_tsi          giuw_perilds_dtl.dist_tsi%TYPE,
      computed_prem         giuw_perilds_dtl.dist_prem%TYPE,
      itmperil_dist_tsi     giuw_itemperilds_dtl.dist_tsi%TYPE,
      itmperil_dist_prem    giuw_itemperilds_dtl.dist_prem%TYPE,
      diff_tsi              giuw_itemperilds_dtl.dist_tsi%TYPE,
      diff_prem             giuw_itemperilds_dtl.dist_prem%TYPE
   );

   TYPE poldist_rec_type IS RECORD (
      dist_no           giuw_pol_dist.dist_no%TYPE,
      policy_id         giuw_pol_dist.policy_id%TYPE,
      par_id            giuw_pol_dist.par_id%TYPE,
      dist_flag         giuw_pol_dist.dist_flag%TYPE,
      post_flag         giuw_pol_dist.post_flag%TYPE,
      auto_dist         giuw_pol_dist.auto_dist%TYPE,
      special_dist_sw   giuw_pol_dist.special_dist_sw%TYPE,
      item_grp          giuw_pol_dist.item_grp%TYPE,
      takeup_seq_no     giuw_pol_dist.takeup_seq_no%TYPE
   );

   TYPE sign_itmperil_rec_type IS RECORD (
      dist_no              giuw_itemperilds.dist_no%TYPE,
      dist_seq_no          giuw_itemperilds.dist_seq_no%TYPE,
      item_no              giuw_itemperilds.item_no%TYPE,
      peril_cd             giuw_itemperilds.peril_cd%TYPE,
      share_cd             giuw_itemperilds_dtl.share_cd%TYPE,
      itmperil_tsi_amt     giuw_itemperilds.tsi_amt%TYPE,
      itmperil_dist_tsi    giuw_itemperilds_dtl.dist_tsi%TYPE,
      itmperil_prem_amt    giuw_itemperilds.prem_amt%TYPE,
      itmperil_dist_prem   giuw_itemperilds_dtl.dist_prem%TYPE
   );

   TYPE wfrps_ri_rec_type IS RECORD (
      line_cd         giri_wfrps_ri.line_cd%TYPE,
      frps_yy         giri_wfrps_ri.frps_yy%TYPE,
      frps_seq_no     giri_wfrps_ri.frps_seq_no%TYPE,
      ri_seq_no       giri_wfrps_ri.ri_seq_no%TYPE,
      ri_cd           giri_wfrps_ri.ri_cd%TYPE,
      pre_binder_id   giri_wfrps_ri.pre_binder_id%TYPE
   );

   TYPE wfrperil_rec_type IS RECORD (
      line_cd       giri_wfrperil.line_cd%TYPE,
      frps_yy       giri_wfrperil.frps_yy%TYPE,
      frps_seq_no   giri_wfrperil.frps_seq_no%TYPE,
      ri_seq_no     giri_wfrperil.ri_seq_no%TYPE,
      ri_cd         giri_wfrperil.ri_cd%TYPE,
      peril_cd      giri_wfrperil.peril_cd%TYPE
   );

   TYPE wbinder_rec_type IS RECORD (
      pre_binder_id   giri_wbinder.pre_binder_id%TYPE,
      line_cd         giri_wbinder.line_cd%TYPE,
      binder_yy       giri_wbinder.binder_yy%TYPE,
      binder_seq_no   giri_wbinder.binder_seq_no%TYPE,
      ri_cd           giri_wbinder.ri_cd%TYPE
   );

   TYPE wfrps_peril_grp_rec_type IS RECORD (
      line_cd        giri_wfrps_peril_grp.line_cd%TYPE,
      frps_yy        giri_wfrps_peril_grp.frps_yy%TYPE,
      frps_seq_no    giri_wfrps_peril_grp.frps_seq_no%TYPE,
      peril_seq_no   giri_wfrps_peril_grp.peril_seq_no%TYPE,
      peril_cd       giri_wfrps_peril_grp.peril_cd%TYPE
   );

   TYPE wbinder_peril_rec_type IS RECORD (
      pre_binder_id   giri_wbinder_peril.pre_binder_id%TYPE,
      peril_seq_no    giri_wbinder_peril.peril_seq_no%TYPE
   );

   TYPE f_poldtl_type IS TABLE OF f_poldtl_rec_type;

   TYPE f_itemdtl_type IS TABLE OF f_itemdtl_rec_type;

   TYPE f_perildtl_type IS TABLE OF f_perildtl_rec_type;

   TYPE f_itemperildtl_type IS TABLE OF f_itemperildtl_rec_type;

   TYPE poldtl_disc_amt_type IS TABLE OF poldtl_disc_amt_rec_type;

   TYPE itemdtl_disc_amt_type IS TABLE OF itemdtl_disc_amt_rec_type;

   TYPE perildtl_disc_amt_type IS TABLE OF perildtl_disc_amt_rec_type;

   TYPE itemperildtl_disc_amt_type IS TABLE OF itemperildtl_disc_amt_rec_type;

   TYPE itmperil_itm_disc_amt_type IS TABLE OF itmperil_itm_disc_amt_rec_type;

   TYPE itmperil_peril_disc_type IS TABLE OF itmperil_peril_disc_rec_type;

   TYPE pol_oth_disc_type IS TABLE OF pol_oth_disc_rec_type;

   TYPE perildtl_frps_disc_type IS TABLE OF perildtl_frps_disc_rec_type;

   TYPE poldtl_frps_disc_type IS TABLE OF poldtl_frps_disc_rec_type;

   TYPE f_politem_type IS TABLE OF f_politem_rec_type;

   TYPE f_politemperil_type IS TABLE OF f_politemperil_rec_type;

   TYPE f_polperil_type IS TABLE OF f_polperil_rec_type;

   TYPE pdist_item_type IS TABLE OF pdist_item_rec_type;

   TYPE pdist_itemperil_type IS TABLE OF pdist_itemperil_rec_type;

   TYPE pdist_polperil_type IS TABLE OF pdist_polperil_rec_type;

   TYPE diff_orsk_itemdtl_type IS TABLE OF diff_orsk_itemdtl_rec_type;

   TYPE diff_orsk_itmpldtl_type IS TABLE OF diff_orsk_itmpldtl_rec_type;

   TYPE diff_orsk_peril_type IS TABLE OF diff_orsk_peril_rec_type;

   TYPE witemds IS TABLE OF giuw_witemds%ROWTYPE;

   TYPE itmperil_peril_type IS TABLE OF itmperil_peril_rec_type;

   TYPE itmperil_policy_type IS TABLE OF itmperil_policy_rec_type;

   TYPE itmperil_item_type IS TABLE OF itmperil_item_rec_type;

   TYPE itmperil_comp_type IS TABLE OF itmperil_comp_rec_type;

   TYPE policyc_comp_type IS TABLE OF policyc_comp_rec_type;

   TYPE itmperil_comp_perild_type IS TABLE OF itmperil_comp_perild_rec_type;

   TYPE pdist_comp_shr_itm_type IS TABLE OF pdist_comp_shr_itm_rec_type;

   TYPE pdist_comp_shr_itm_type2 IS TABLE OF pdist_comp_shr_itm_rec_type2;

   TYPE pdist_comp_shr_pol_type IS TABLE OF pdist_comp_shr_pol_rec_type;

   TYPE pdist_comp_shr_pol_type2 IS TABLE OF pdist_comp_shr_pol_rec_type2;

   TYPE pcomp_perildtl_type IS TABLE OF pcomp_perildtl_rec_type;

   TYPE pcomp_itmperildtl_type IS TABLE OF pcomp_itmperildtl_rec_type;

   TYPE pexists_witemds IS TABLE OF giuw_witemds%ROWTYPE;

   TYPE pexists_witemds_dtl IS TABLE OF giuw_witemds_dtl%ROWTYPE;

   TYPE pexists_witemperilds IS TABLE OF giuw_witemperilds%ROWTYPE;

   TYPE pexists_witemperilds_dtl IS TABLE OF giuw_witemperilds_dtl%ROWTYPE;

   TYPE pexists_wperilds IS TABLE OF giuw_wperilds%ROWTYPE;

   TYPE pexists_wperilds_dtl IS TABLE OF giuw_wperilds_dtl%ROWTYPE;

   TYPE pexists_wpolicyds IS TABLE OF giuw_wpolicyds%ROWTYPE;

   TYPE pexists_wpolicyds_dtl IS TABLE OF giuw_wpolicyds_dtl%ROWTYPE;

   TYPE pexists_itemds IS TABLE OF giuw_itemds%ROWTYPE;

   TYPE pexists_itemds_dtl IS TABLE OF giuw_itemds_dtl%ROWTYPE;

   TYPE pexists_itemperilds IS TABLE OF giuw_itemperilds%ROWTYPE;

   TYPE pexists_itemperilds_dtl IS TABLE OF giuw_itemperilds_dtl%ROWTYPE;

   TYPE pexists_perilds IS TABLE OF giuw_perilds%ROWTYPE;

   TYPE pexists_perilds_dtl IS TABLE OF giuw_perilds_dtl%ROWTYPE;

   TYPE pexists_policyds IS TABLE OF giuw_policyds%ROWTYPE;

   TYPE pexists_policyds_dtl IS TABLE OF giuw_policyds_dtl%ROWTYPE;

   TYPE poldist_type IS TABLE OF poldist_rec_type;

   TYPE sign_itmperil_type IS TABLE OF sign_itmperil_rec_type;

   TYPE wfrps_ri_type IS TABLE OF wfrps_ri_rec_type;

   TYPE wfrperil_type IS TABLE OF wfrperil_rec_type;

   TYPE wbinder_peril_type IS TABLE OF wbinder_peril_rec_type;

   TYPE wbinder_type IS TABLE OF wbinder_rec_type;

   TYPE wfrps_peril_grp_type IS TABLE OF wfrps_peril_grp_rec_type;

   TYPE wdistfrps IS TABLE OF giri_wdistfrps%ROWTYPE;

   TYPE exists_policyds_dtl IS TABLE OF giuw_policyds_dtl%ROWTYPE;

   /* ***************************************************************************************************************************************
        -- checking of null/not null  dist_spct1  % - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_chk_ntnll_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED;

   FUNCTION f_chk_ntnll_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED;

   FUNCTION f_chk_ntnll_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED;

   FUNCTION f_chk_ntnll_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED;

   /* ***************************************************************************************************************************************
        -- checking of null/not null  dist_spct1  % - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_chk_ntnll_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED;

   FUNCTION f_chk_ntnll_spct1_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED;

   FUNCTION f_chk_ntnll_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED;

   FUNCTION f_chk_ntnll_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_f_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED;

   FUNCTION f_chk_null_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED;

   /* ***************************************************************************************************************************************
-- checking of existence of working  distribution records
  ************************************************************************************************************************************** */
   FUNCTION f_chk_exists_witemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds PIPELINED;

   FUNCTION f_chk_exists_witemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED;

   FUNCTION f_chk_exists_witemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds PIPELINED;

   FUNCTION f_chk_exists_witemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED;

   FUNCTION f_chk_exists_wperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds PIPELINED;

   FUNCTION f_chk_exists_wperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED;

   FUNCTION f_chk_exists_wpolicyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds PIPELINED;

   FUNCTION f_chk_exists_wpolicyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED;

   /* ***************************************************************************************************************************************
-- checking of existence of final  distribution records
 ************************************************************************************************************************************** */
   FUNCTION f_chk_exists_f_itemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds PIPELINED;

   FUNCTION f_chk_exists_f_itemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED;

   FUNCTION f_chk_exists_f_itemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds PIPELINED;

   FUNCTION f_chk_exists_f_itemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED;

   FUNCTION f_chk_exists_f_perilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds PIPELINED;

   FUNCTION f_chk_exists_f_perilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED;

   FUNCTION f_chk_exists_f_policyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds PIPELINED;

   FUNCTION f_chk_exists_f_policyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED;

   FUNCTION f_chk_exists_wfrps01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wdistfrps PIPELINED;

   FUNCTION f_chk_exists_wfrps02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN exists_policyds_dtl PIPELINED;

   /* ***************************************************************************************************************************************
--  comparison of working and final distribution records
 ************************************************************************************************************************************** */
   FUNCTION f_val_witemdsdtl_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemdtl_type PIPELINED;

   FUNCTION f_val_witmpldsdtl_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemperildtl_type PIPELINED;

   FUNCTION f_val_wperildsdtl_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_perildtl_type PIPELINED;

   FUNCTION f_val_wpoldsdtl_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_poldtl_type PIPELINED;

   /* ***************************************************************************************************************************************
        -- checking of share % - rounded off to nine decimal places - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_dtl_rndoff9_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED;

   FUNCTION f_val_dtl_rndoff9_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED;

   FUNCTION f_val_dtl_rndoff9_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED;

   FUNCTION f_val_dtl_rndoff9_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED;

   /* ***************************************************************************************************************************************
        -- checking of share % - rounded off to nine decimal places - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_dtl_rndoff9_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED;

   FUNCTION f_val_dtl_rndoff9_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED;

   FUNCTION f_val_dtl_rndoff9_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED;

   FUNCTION f_val_dtl_rndoff9_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED;

   /* ***************************************************************************************************************************************
   -- checking of zero share % - working distribution tables
************************************************************************************************************************************** */

   /* ***************************************************************************************************************************************
   -- checking of zero share % - final distribution tables
************************************************************************************************************************************** */
   FUNCTION f_chk_btsp_zerospct_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemdtl_type PIPELINED;

   FUNCTION f_chk_btsp_zerospct_f_itmpldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemperildtl_type PIPELINED;

   FUNCTION f_chk_btsp_zerospct_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED;

   FUNCTION f_chk_btsp_zerospct_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED;

/* ***************************************************************************************************************************************
      -- queries on working distribution tables   (amount )
   ************************************************************************************************************************************** */
   FUNCTION f_val_witemds_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemdtl_disc_amt_type PIPELINED;

   FUNCTION f_val_wpolds_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldtl_disc_amt_type PIPELINED;

   FUNCTION f_val_wperilds_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN perildtl_disc_amt_type PIPELINED;

   FUNCTION f_val_witmprlds_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemperildtl_disc_amt_type PIPELINED;

   FUNCTION f_val_witmprldtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_itm_disc_amt_type PIPELINED;

   FUNCTION f_val_witmprldtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_disc_type PIPELINED;

   FUNCTION f_val_wpoldsdtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED;

   FUNCTION f_val_wpoldsdtl_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED;

   FUNCTION f_val_wpoldsdtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED;

/* ***************************************************************************************************************************************
        -- queries on final distribution tables   (amount )
     ************************************************************************************************************************************** */
   FUNCTION f_val_f_itemds_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemdtl_disc_amt_type PIPELINED;

   FUNCTION f_val_f_itmprlds_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemperildtl_disc_amt_type PIPELINED;

   FUNCTION f_val_f_itmprldtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_itm_disc_amt_type PIPELINED;

   FUNCTION f_val_f_itmprldtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_disc_type PIPELINED;

   FUNCTION f_val_f_perilds_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN perildtl_disc_amt_type PIPELINED;

   FUNCTION f_val_f_polds_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldtl_disc_amt_type PIPELINED;

   FUNCTION f_val_f_poldsdtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED;

   FUNCTION f_val_f_poldsdtl_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED;

   FUNCTION f_val_f_poldsdtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED;

   FUNCTION f_val_f_perildsdtl_wdstfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN perildtl_frps_disc_type PIPELINED;

   FUNCTION f_val_f_poldsdtl_wdistfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldtl_frps_disc_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating existence of distribution tables - ONE RISK DISTRIBUTION  - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vcorsk_wpoldtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED;

   FUNCTION f_vcorsk_wpoldtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED;

   FUNCTION f_vcorsk_wpoldtl_witmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED;

   FUNCTION f_vcorsk_wpoldtl_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED;

   FUNCTION f_vcorsk_wpoldtl_wperildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED;

   FUNCTION f_vcorsk_wpoldtl_wperildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED;

/* ***************************************************************************************************************************************
       --- validating existence of distribution tables - ONE RISK DISTRIBUTION - final  distribution tables
    ************************************************************************************************************************************** */
   FUNCTION f_vcorsk_poldtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED;

   FUNCTION f_vcorsk_poldtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED;

   FUNCTION f_vcorsk_poldtl_f_itmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED;

   FUNCTION f_vcorsk_poldtl_f_itmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED;

   FUNCTION f_vcorsk_poldtl_f_perildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED;

   FUNCTION f_vcorsk_poldtl_f_perildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating existence of distribution tables - PERIL DISTRIBUTION  - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vpdist_wperildtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED;

   FUNCTION f_vpdist_wperildtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED;

   FUNCTION f_vpdist_wperildtl_witmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED;

   FUNCTION f_vpdist_wperildtl_witmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED;

   FUNCTION f_vpdist_wperildtl_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED;

   FUNCTION f_vpdist_wperildtl_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating existence of distribution tables - PERIL DISTRIBUTION  - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vpdist_perildtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED;

   FUNCTION f_vpdist_perildtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED;

   FUNCTION f_vpdist_perildtl_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED;

   FUNCTION f_vpdist_perildtl_f_itmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED;

   FUNCTION f_vpdist_perildtl_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED;

   FUNCTION f_vpdist_perildtl_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating consistency of share % in One Risk Distribution - Working Distribution
     ************************************************************************************************************************************** */
   FUNCTION f_valconst_shr_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itemdtl_type PIPELINED;

   FUNCTION f_valconst_shr_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itmpldtl_type PIPELINED;

   FUNCTION f_valconst_shr_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_peril_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating consistency of share % in One Risk Distribution - Final Distribution Table
     ************************************************************************************************************************************** */
   FUNCTION f_valconst_shr_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itemdtl_type PIPELINED;

   FUNCTION f_valconst_shr_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itmpldtl_type PIPELINED;

   FUNCTION f_valconst_shr_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_peril_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating the amounts stored in Dist Tables if based on ITEMPERILDS_DTL --> working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_compt_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_type PIPELINED;

   FUNCTION f_val_compt_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_policy_type PIPELINED;

   FUNCTION f_val_compt_wtemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_item_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating the amounts stored in Dist Tables if based on ITEMPERILDS_DTL --> final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_compt_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_item_type PIPELINED;

   FUNCTION f_val_compt_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_type PIPELINED;

   FUNCTION f_val_compt_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_policy_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating the stored amounts in the distribution table against manual computation - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_orsk_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_comp_type PIPELINED;

   FUNCTION f_valcnt_orsk_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN policyc_comp_type PIPELINED;

/* ***************************************************************************************************************************************
        --- validating the stored amounts in the distribution table against manual computation -  final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_orsk_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_comp_type PIPELINED;

   FUNCTION f_valcnt_orsk_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN policyc_comp_type PIPELINED;

/* ***************************************************************************************************************************************
        -- validating the computed share% of dist  tables (policyds / itemds ) - PERIL DISTRIBUTION - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vcomp_shr_witmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type PIPELINED;

   FUNCTION f_vcomp_shr_witmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type2 PIPELINED;

   FUNCTION f_vcomp_shr_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type PIPELINED;

   FUNCTION f_vcomp_shr_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type2 PIPELINED;

/* ***************************************************************************************************************************************
        -- validating the computed share% of dist  tables (policyds / itemds ) - PERIL DISTRIBUTION - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vcomp_shr_f_itmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type PIPELINED;

   FUNCTION f_vcomp_shr_f_itmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type2 PIPELINED;

   FUNCTION f_vcomp_shr_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type PIPELINED;

   FUNCTION f_vcomp_shr_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type2 PIPELINED;

/* ***************************************************************************************************************************************
        -- validation of distribution amounts (TSI/Prem) - Peril Distribution - Working Distribution Tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_pdist_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_perildtl_type PIPELINED;

   FUNCTION f_valcnt_pdist_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_itmperildtl_type PIPELINED;

/* ***************************************************************************************************************************************
        -- validation of distribution amounts (TSI/Prem) - Peril Distribution - Final Distribution Tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_pdist_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_perildtl_type PIPELINED;

   FUNCTION f_valcnt_pdist_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_itmperildtl_type PIPELINED;

   /* ***************************************************************************************************************************************
--  checking of zero share % but non-zero amounts
  ************************************************************************************************************************************** */
   FUNCTION f_valcnt_nzroprem_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED;

   FUNCTION f_valcnt_nzroprem_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED;

   FUNCTION f_valcnt_nzrotsi_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED;

   FUNCTION f_valcnt_nzrotsi_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED;

    /* ***************************************************************************************************************************************
--  checking of giuw_pol_dist
  ************************************************************************************************************************************** */
   FUNCTION f_val_pol_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldist_type PIPELINED;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Working Distribution Tables
** ==================================================================================================================================*/
   FUNCTION f_valcnt_sign_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN sign_itmperil_type PIPELINED;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Final Distribution Tables
** ==================================================================================================================================*/
   FUNCTION f_valcnt_sign_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN sign_itmperil_type PIPELINED;

/* ===================================================================================================================================
**  Dist Validation - Validating if there exists working binder tables
** ==================================================================================================================================*/
   FUNCTION f_wrkngbndr_wfrps_ri (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wfrps_ri_type PIPELINED;

   FUNCTION f_wrkngbndr_wfrperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wfrperil_type PIPELINED;

   FUNCTION f_wrkngbndr_wbinderperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wbinder_peril_type PIPELINED;

   FUNCTION f_wrkngbndr_wbinder (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wbinder_type PIPELINED;

   FUNCTION f_wrkngbndr_wfrps_peril_grp (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wfrps_peril_grp_type PIPELINED;
-- &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
END genqa_dist_res_tbl;
/


DROP PACKAGE CPI.GENQA_DIST_RES_TBL;