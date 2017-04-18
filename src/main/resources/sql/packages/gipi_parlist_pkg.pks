CREATE OR REPLACE PACKAGE CPI.gipi_parlist_pkg
AS
   TYPE gipi_parlist_type IS RECORD (
      par_id                 gipi_parlist.par_id%TYPE,
      line_cd                gipi_parlist.line_cd%TYPE,
      line_name              giis_line.line_name%TYPE,
      subline_cd             gipi_wpolbas.subline_cd%TYPE,
      iss_cd                 gipi_parlist.iss_cd%TYPE,
      par_yy                 gipi_parlist.par_yy%TYPE, 
      par_seq_no             VARCHAR2 (10),   --GIPI_PARLIST.par_seq_no%TYPE,
      quote_seq_no           gipi_parlist.quote_seq_no%TYPE,
      assd_no                gipi_parlist.assd_no%TYPE,
      assd_name              giis_assured.assd_name%TYPE,
      underwriter            gipi_parlist.underwriter%TYPE,
      pack_pol_flag          giis_line.pack_pol_flag%TYPE,
      par_status             gipi_parlist.par_status%TYPE,
      par_type               gipi_parlist.par_type%TYPE,
      status                 cg_ref_codes.rv_meaning%TYPE,
      quote_id               gipi_parlist.quote_id%TYPE,
      assign_sw              gipi_parlist.assign_sw%TYPE,
      renew_sw               gipi_wpolbas.pol_flag%TYPE,
      with_quote             VARCHAR2 (1),
      remarks                CLOB,--gipi_parlist.remarks%TYPE,
      par_no                 VARCHAR2 (50),
      pack_par_no            VARCHAR2 (50),
      subline_name           giis_subline.subline_name%TYPE,
      pack_par_id            gipi_parlist.pack_par_id%TYPE,
      par_seq_no_c           VARCHAR2 (10),
      disc_exists            VARCHAR2 (1),
      pol_flag               gipi_wpolbas.pol_flag%TYPE,
      pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE,
      issue_yy               gipi_wpolbas.issue_yy%TYPE,
      op_flag                giis_subline.op_flag%TYPE,
      address1               gipi_parlist.address1%TYPE,
      address2               gipi_parlist.address2%TYPE,
      address3               gipi_parlist.address3%TYPE,
      endt_policy_id         gipi_polbasic.policy_id%TYPE,
                                        --for endorsement --andrew 06.07.2010
      endt_policy_no         VARCHAR2 (50),
                                        --for endorsement --andrew 06.07.2010
      incept_date            gipi_wpolbas.incept_date%TYPE,
      expiry_date            gipi_wpolbas.expiry_date%TYPE,
      eff_date               gipi_wpolbas.eff_date%TYPE,
      endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE,
      short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE,
      comp_sw                gipi_wpolbas.comp_sw%TYPE,
      prorate_flag           gipi_wpolbas.prorate_flag%TYPE,
      prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE,
      prov_prem_pct          gipi_wpolbas.prov_prem_pct%TYPE,
      bank_ref_no            gipi_wpolbas.bank_ref_no%TYPE,
      line_motor             giis_parameters.param_value_v%TYPE,
      line_fire              giis_parameters.param_value_v%TYPE,
      ctpl_cd                giis_parameters.param_value_n%TYPE,
      with_tariff_sw         gipi_wpolbas.with_tariff_sw%TYPE,
      back_endt              VARCHAR2 (1),
      endt_tax               VARCHAR2 (1),
      renew_no               gipi_wpolbas.renew_no%TYPE,
      dist_no                giuw_pol_dist.dist_no%TYPE,
      gipi_wendttext_exist   VARCHAR2 (1),
      gipi_winvoice_exist    VARCHAR2 (1),
      gipi_winv_tax_exist    VARCHAR2 (1),
      cn_date_printed        VARCHAR (50),
      binder_exist           VARCHAR(1),
	  str_expiry_date        varchar2(10),
	  str_incept_date        varchar2(10)
   );

   TYPE gipi_parlist_tab IS TABLE OF gipi_parlist_type;
   
   TYPE gipi_parlist_tg_type IS RECORD (
     par_id                 GIPI_PARLIST.par_id%TYPE,
     pack_par_id            GIPI_PARLIST.pack_par_id%TYPE,
     line_cd                GIPI_PARLIST.line_cd%TYPE,
     line_name              GIIS_LINE.line_name%TYPE,
     iss_cd                 GIPI_PARLIST.iss_cd%TYPE,
     par_yy                 GIPI_PARLIST.par_yy%TYPE,
     par_seq_no             VARCHAR2 (10),   
     quote_seq_no           GIPI_PARLIST.quote_seq_no%TYPE, 
     assd_no                GIPI_PARLIST.assd_no%TYPE,
     assd_name              GIIS_ASSURED.assd_name%TYPE,
     underwriter            GIPI_PARLIST.underwriter%TYPE, 
     pack_pol_flag          GIIS_LINE.pack_pol_flag%TYPE,
     status                 CG_REF_CODES.rv_meaning%TYPE,
     par_type               GIPI_PARLIST.par_type%TYPE,
     quote_id               GIPI_PARLIST.quote_id%TYPE,
     assign_sw              GIPI_PARLIST.assign_sw%TYPE,
     remarks                VARCHAR2 (32767), --GIPI_PARLIST.remarks%TYPE,
     par_no                 VARCHAR2 (50),
     pack_par_no            VARCHAR2 (50),
     par_status             GIPI_PARLIST.par_status%TYPE, 
     pol_flag               GIPI_WPOLBAS.pol_flag%TYPE,
     subline_cd             GIPI_WPOLBAS.subline_cd%TYPE,
     pol_seq_no             GIPI_WPOLBAS.pol_seq_no%TYPE,
     issue_yy               GIPI_WPOLBAS.issue_yy%TYPE,
     bank_ref_no            GIPI_WPOLBAS.bank_ref_no%TYPE,
     cn_date_printed        VARCHAR (50),
     address1               GIPI_PARLIST.address1%TYPE,
     address2               GIPI_PARLIST.address2%TYPE,
     address3               GIPI_PARLIST.address3%TYPE,
     op_flag                giis_subline.op_flag%TYPE,
     count_                 NUMBER,                          --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678 
     rownum_                NUMBER                           --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
  );

   TYPE gipi_parlist_tg_tab IS TABLE OF gipi_parlist_tg_type;

   TYPE parlist_security_type IS RECORD (
      line_cd   giis_line.line_name%TYPE,
      iss_cd    gipi_parlist.iss_cd%TYPE
   );

   TYPE parlist_security_tab IS TABLE OF parlist_security_type;

   FUNCTION get_gipi_parlist (
      p_line_cd     gipi_parlist.line_cd%TYPE,
      p_iss_cd      gipi_parlist.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_keyword     VARCHAR2,
      p_user_id     giis_users.user_id%TYPE,
      p_ri_switch   VARCHAR2
   )
      RETURN gipi_parlist_tab PIPELINED;

   FUNCTION get_gipi_parlist (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_line_cd       gipi_parlist.line_cd%TYPE,
      p_iss_cd        gipi_parlist.iss_cd%TYPE,
      p_module_id     giis_user_grp_modules.module_id%TYPE,
      p_underwriter   gipi_parlist.underwriter%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED;

   PROCEDURE set_gipi_parlist (
      v_par_id         IN   gipi_parlist.par_id%TYPE,
      v_line_cd        IN   gipi_parlist.line_cd%TYPE,
      v_iss_cd         IN   gipi_parlist.iss_cd%TYPE,
      v_par_yy         IN   gipi_parlist.par_yy%TYPE,
      v_quote_seq_no   IN   gipi_parlist.quote_seq_no%TYPE,
      v_assd_no        IN   gipi_parlist.assd_no%TYPE,
      v_underwriter    IN   gipi_parlist.underwriter%TYPE,
      v_par_status     IN   gipi_parlist.par_status%TYPE,
      v_par_type       IN   gipi_parlist.par_type%TYPE,
      v_quote_id       IN   gipi_parlist.quote_id%TYPE,
      v_assign_sw      IN   gipi_parlist.assign_sw%TYPE,
      v_remarks        IN   gipi_parlist.remarks%TYPE
   );

   PROCEDURE del_gipi_parlist (p_par_id gipi_parlist.par_id%TYPE);

   FUNCTION get_gipi_parlist_filtered (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_no        gipi_parlist.assd_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         cg_ref_codes.rv_meaning%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED;

   FUNCTION get_gipi_parlist (p_par_id gipi_parlist.par_id%TYPE)
      RETURN gipi_parlist_tab PIPELINED;

   FUNCTION get_gipi_parlist (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED;

   PROCEDURE save_par (p_gipi_par IN gipi_parlist%ROWTYPE);

   PROCEDURE save_parlist (p_gipi_par IN gipi_parlist%ROWTYPE);

   PROCEDURE get_par_seq_no (
      p_drv_par_seq_no   IN OUT   VARCHAR2,
      p_quote_seq_no     IN       NUMBER,
      p_par_yy           IN       NUMBER,
      p_par_seq_no       IN       NUMBER,
      p_line_cd          IN       VARCHAR2,
      p_iss_cd           IN       VARCHAR2
   );

   PROCEDURE check_unique_par (
      p_quote_seq_no            IN       NUMBER,
      p_par_seq_no              IN       NUMBER,
      p_par_yy                  IN       NUMBER,
      p_iss_cd                  IN       VARCHAR2,
      p_line_cd                 IN       VARCHAR2,
      p_field_level             IN       BOOLEAN,
      v_raise_no_data_found     OUT      VARCHAR2,
      v_cgte$other_exceptions   OUT      VARCHAR2
   );

   /*
   **  Created by        : Mark JM
   **  Date Created     : 02.15.2010
   **  Reference By     : (GIPIS010 - Item Information)
   **  Description     : Get Par No of a given par_id
   */
   FUNCTION get_par_no (p_par_id NUMBER)
      RETURN VARCHAR2;
      
   FUNCTION get_par_no_2(p_policy_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_rec_flag (p_par_id gipi_parlist.par_id%TYPE)
      RETURN gipi_parlist.par_type%TYPE;

   FUNCTION check_par_quote (p_par_id gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2;

   PROCEDURE update_status_from_quote (
      p_quote_id     gipi_parlist.quote_id%TYPE,
      p_par_status   gipi_parlist.par_status%TYPE
   );

   PROCEDURE delete_bill_details (p_par_id gipi_parlist.par_id%TYPE);

   PROCEDURE set_status_wperil (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   );

   PROCEDURE set_status_wperil (p_par_id gipi_parlist.par_id%TYPE);

   PROCEDURE update_par_status (
      p_par_id       IN   gipi_parlist.par_id%TYPE,
      p_par_status   IN   gipi_parlist.par_status%TYPE
   );

   /*Created by: Cris Castro
     Date: 04/20/2010
     for GIPIS058(Endorsement par list)
   */
   /* start cris*/
   FUNCTION get_endt_parlist (
      p_line_cd     gipi_parlist.line_cd%TYPE,
      p_iss_cd      gipi_parlist.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_keyword     VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED;

   /*end cris*/
   PROCEDURE get_line_cd_iss_cd (
      p_par_id    IN       gipi_parlist.par_id%TYPE,
      p_line_cd   OUT      gipi_parlist.line_cd%TYPE,
      p_iss_cd    OUT      gipi_parlist.iss_cd%TYPE
   );

   FUNCTION parlist_security (
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN parlist_security_tab PIPELINED;

   -- copy par list related procs
   PROCEDURE copy_parlist (
      p_par_id                 NUMBER,
      p_user_id                VARCHAR2,
      p_line_cd                giis_line.line_cd%TYPE,
      p_iss_cd                 gipi_invoice.iss_cd%TYPE,
      p_new_par_id       OUT   NUMBER,
      p_open_flag        OUT   VARCHAR2,
      p_menu_line        OUT   giis_line.menu_line_cd%TYPE,
      p_new_par_seq_no   OUT   gipi_parlist.par_seq_no%TYPE,
      p_par_no           OUT   VARCHAR2
   );

   PROCEDURE copy_wpolbas (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wpolgenin (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wopen_policy (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wlim_liab (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wpack_line_subline (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_witem (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_witmperl (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_winvoice (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_iss_cd       gipi_invoice.iss_cd%TYPE,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_winvperl (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_winstallment (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_winv_tax (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wpolbas_discount (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_witem_discount (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wperil_discount (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_co_ins (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wendttext (
      p_par_id              NUMBER,
      p_new_par_id          NUMBER,
      p_user_id             giis_users.user_id%TYPE,
      p_endt_text01   OUT   VARCHAR2,
      p_endt_text02   OUT   VARCHAR2,
      p_endt_text03   OUT   VARCHAR2,
      p_endt_text04   OUT   VARCHAR2,
      p_endt_text05   OUT   VARCHAR2,
      p_endt_text06   OUT   VARCHAR2,
      p_endt_text07   OUT   VARCHAR2,
      p_endt_text08   OUT   VARCHAR2,
      p_endt_text09   OUT   VARCHAR2,
      p_endt_text10   OUT   VARCHAR2,
      p_endt_text11   OUT   VARCHAR2,
      p_endt_text12   OUT   VARCHAR2,
      p_endt_text13   OUT   VARCHAR2,
      p_endt_text14   OUT   VARCHAR2,
      p_endt_text15   OUT   VARCHAR2,
      p_endt_text16   OUT   VARCHAR2,
      p_endt_text17   OUT   VARCHAR2
   );

   PROCEDURE copy_wcomm_invoices (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wcomm_inv_perils (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wmortgagee (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_orig_comm_invoice (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_orig_comm_inv_peril (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_orig_invoice (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_orig_invperil (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_orig_inv_tax (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_orig_itmperil (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   /** line related copy **/

   -- fire
   PROCEDURE copy_wfireitm (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- motorcar
   PROCEDURE copy_wvehicle (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wmcacc (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- accident
   PROCEDURE copy_waccident_item (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wbeneficiary (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wgrouped_items (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wgrp_items_beneficiary (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- marine hull
   PROCEDURE copy_witem_ves (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- marine cargo
   PROCEDURE copy_wcargo (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wves_air (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wves_accumulation (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wopen_liab (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wopen_cargo (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wopen_peril (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- casualty
   PROCEDURE copy_wcasualty_item (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wcasualty_personnel (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   /* execute also the following:
      copy_wgrouped_items
      copy_wgrp_items_beneficiary
   */
   PROCEDURE copy_wbank_schedule (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- engineering
   PROCEDURE copy_wengg_basic (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wlocation (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wprincipal (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- surety
   PROCEDURE copy_wbond_basic (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE,
      p_long         gipi_wendttext.endt_text%TYPE
   );

   PROCEDURE copy_wcosigntry (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- aviation
   PROCEDURE copy_waviation_item (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   /** end of line related copy **/
   PROCEDURE copy_wpolwc (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_pol_dist (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   PROCEDURE copy_wdeductibles (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   );

   -- end of copy par list related procs
   PROCEDURE save_parlist_from_endt (
      p_par_id         IN   gipi_parlist.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE,
      p_par_status     IN   gipi_parlist.par_status%TYPE,
      p_line_cd        IN   gipi_parlist.line_cd%TYPE,
      p_iss_cd         IN   gipi_parlist.iss_cd%TYPE,
      p_par_yy         IN   gipi_parlist.par_yy%TYPE,
      p_par_seq_no     IN   gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   IN   gipi_parlist.quote_seq_no%TYPE,
      p_assd_no        IN   gipi_parlist.assd_no%TYPE,
      p_address1       IN   gipi_parlist.address1%TYPE,
      p_address2       IN   gipi_parlist.address2%TYPE,
      p_address3       IN   gipi_parlist.address3%TYPE
   );

   FUNCTION get_par_status (p_par_id IN gipi_parlist.par_id%TYPE)
      RETURN gipi_parlist.par_status%TYPE;

   /************************* DELETE PAR LIST RELATED PROCS - whofeih 07.29.2010 ***************************/
   PROCEDURE delete_wpolwc (p_par_id NUMBER);

   PROCEDURE delete_fire_workfile (p_par_id NUMBER);

   PROCEDURE delete_motorcar_workfile (p_par_id NUMBER);

   PROCEDURE delete_accident_workfile (p_par_id NUMBER);

   PROCEDURE delete_cargo_workfile (p_par_id NUMBER);

   PROCEDURE delete_hull_workfile (p_par_id NUMBER);

   PROCEDURE delete_casualty_workfile (p_par_id NUMBER);

   PROCEDURE delete_engineering_workfile (p_par_id NUMBER);

   PROCEDURE delete_bonds_workfile (p_par_id NUMBER);

   PROCEDURE delete_aviation_workfile (p_par_id NUMBER);

   PROCEDURE delete_oth_workfile (p_par_id NUMBER);

   PROCEDURE delete_by_packpol_flag (p_par_id NUMBER);

   PROCEDURE delete_expiry (p_par_id NUMBER);

   PROCEDURE delete_distribution (p_par_id NUMBER);

   PROCEDURE delete_wpolbas (p_par_id NUMBER);

   PROCEDURE delete_wpolnrep (p_par_id NUMBER);

   PROCEDURE delete_ri_tables (p_dist_no NUMBER);

   /************************* END OF DELETE PAR LIST RELATED PROCS - whofeih 07.29.2010 ***************************/
   FUNCTION get_package_policy_list (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED;

   FUNCTION get_gipi_parlist (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_par_type       gipi_parlist.par_type%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         VARCHAR2,
      p_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE,
      p_ri_switch      VARCHAR2
   )
      RETURN gipi_parlist_tab PIPELINED;

   PROCEDURE update_par_remarks (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_par_remarks   gipi_parlist.remarks%TYPE
   );

   FUNCTION gipi_parlist_security (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN parlist_security_tab PIPELINED;

   FUNCTION get_gipi_parlist_policy (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_all_user_sw    VARCHAR2,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         VARCHAR2,
      p_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE,
      p_ri_switch      VARCHAR2,
      p_order_by       VARCHAR2,                  --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_asc_desc_flag  VARCHAR2,                  --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_first_row      NUMBER,                    --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_last_row       NUMBER                     --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
  
      
   )
      RETURN gipi_parlist_tg_tab PIPELINED;

   FUNCTION get_gipi_parlist_endt (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_all_user_sw    VARCHAR2,
      p_par_yy         gipi_parlist.par_yy%TYPE, 
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         VARCHAR2,
      p_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE,
      p_ri_switch      VARCHAR2,
      p_order_by       VARCHAR2,        --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678            
      p_asc_desc_flag  VARCHAR2,        --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_first_row      NUMBER,          --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_last_row       NUMBER           --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
   )
      RETURN gipi_parlist_tg_tab PIPELINED;

   PROCEDURE update_par_status_bill_prem (
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_pack_par_id     IN   gipi_pack_parlist.pack_par_id%TYPE,
      p_item_grp        IN   gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no   IN   gipi_winvoice.takeup_seq_no%TYPE
   );

   TYPE pack_item_par_list_type IS RECORD (
      par_id         gipi_parlist.par_id%TYPE,
      pack_par_id    gipi_parlist.pack_par_id%TYPE,
      par_no         VARCHAR2 (50),
      line_cd        gipi_parlist.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE,
      subline_cd     gipi_wpolbas.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE,
      iss_cd         gipi_parlist.iss_cd%TYPE,
      par_yy         gipi_parlist.par_yy%TYPE,
      op_flag        giis_subline.op_flag%TYPE,
      par_seq_no     gipi_parlist.par_seq_no%TYPE,
      par_status     gipi_parlist.par_status%TYPE,
      quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      region_cd      giis_issource.region_cd%TYPE,
      menu_line_cd     giis_line.menu_line_cd%TYPE,
      pol_flag         gipi_wpolbas.pol_flag%TYPE,
      pack_pol_flag     gipi_wpolbas.pack_pol_flag%TYPE);

   TYPE pack_item_par_list_tab IS TABLE OF pack_item_par_list_type;

   FUNCTION get_pack_item_par_list (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE,
      p_line_cd       gipi_parlist.line_cd%TYPE
   )
      RETURN pack_item_par_list_tab PIPELINED;
      
      
  FUNCTION get_all_pack_item_par (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE,
      p_line_cd       gipi_parlist.line_cd%TYPE
   )
      RETURN pack_item_par_list_tab PIPELINED;

     /*   Created By Irwin Tabisora
     GIPI_PARLIST
   */
   PROCEDURE set_gipi_parlist_pack (
      p_pack_par_id      gipi_parlist.pack_par_id%TYPE,
      p_par_id           gipi_parlist.par_id%TYPE,
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_par_type       gipi_parlist.par_type%TYPE,
      p_assign_sw      gipi_parlist.assign_sw%TYPE,
      p_par_status     gipi_parlist.par_status%TYPE,
      p_assd_no        gipi_parlist.assd_no%TYPE,
      p_quote_id       gipi_parlist.quote_id%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_remarks          gipi_parlist.remarks%TYPE
   );
   
   PROCEDURE insert_quote_to_par(p_quote_id     GIPI_PARLIST.quote_id%TYPE
                                ,p_par_id       GIPI_PARLIST.par_id%TYPE
                                ,p_line_cd      GIPI_PARLIST.line_cd%TYPE
                                ,p_iss_cd       GIPI_PARLIST.iss_cd%TYPE
                                ,p_assd_no      GIPI_PARLIST.assd_no%TYPE
                                ,p_underwriter  GIPI_PARLIST.underwriter%TYPE
                                ,p_message      OUT VARCHAR2);
                                
   FUNCTION check_parlist_dependency(p_insp_no             GIPI_INSP_DATA.insp_no%TYPE)
        RETURN VARCHAR2;
      
   TYPE assured_type IS RECORD(
  
     assd_no          gipi_parlist.assd_no%TYPE,
     assd_name        VARCHAR2(1000)
    
   );
    
   TYPE assured_tab IS TABLE OF assured_type;
  
   FUNCTION get_par_assured_list(p_keyword giis_assured.assd_name%TYPE)
  
     RETURN assured_tab PIPELINED;
     
   FUNCTION get_pack_par_status (p_pack_par_id IN gipi_parlist.pack_par_id%TYPE)
      RETURN gipi_parlist.par_status%TYPE;
      
    PROCEDURE update_assd_no (
        p_pack_par_id IN gipi_parlist.pack_par_id%TYPE,
        p_assd_no IN gipi_parlist.assd_no%TYPE);
   
   FUNCTION get_parlist_by_pack (
        p_pack_par_id   GIPI_PARLIST.pack_par_id%TYPE
   ) RETURN gipi_parlist_tab PIPELINED;      
/*
** Created by reymon 05022013
** To update insp_no
*/   
   PROCEDURE update_insp_no (
        p_par_id IN gipi_parlist.par_id%TYPE,
        p_insp_no IN gipi_parlist.insp_no%TYPE);    
    PROCEDURE check_allow_cancellation (
       p_par_id   IN       gipi_wpolbas.par_id%TYPE,
       allowed    OUT      VARCHAR2
    );                                 
END gipi_parlist_pkg;
/


