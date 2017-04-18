CREATE OR REPLACE PACKAGE CPI.GIUTS007_PKG AS

/*  created by: rmanalad
**  date created : 6/21/2012 
**  reference : GIUTS007 module 
*/

  PROCEDURE copy_parlist(  
        p_in_par_id   IN        gipi_parlist.par_id%TYPE,
        p_in_user_id  IN        gipi_parlist.underwriter%TYPE,
        p_in_iss_cd   IN        gipi_parlist.iss_cd%TYPE, 
        p_copy_par_id IN OUT    gipi_parlist.par_id%TYPE,
        p_in_var_line_cd IN     gipi_parlist.line_cd%TYPE
   );

  PROCEDURE copy_co_ins(
        p_par_id        gipi_parlist.par_id%TYPE,
        p_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_par(
        p_in_par_id         gipi_parlist.par_id%TYPE,
        p_in_copy_par_id    gipi_parlist.par_id%TYPE,
        p_in_line_cd        gipi_parlist.line_cd%TYPE,
        p_in_user_id        gipi_parlist.underwriter%TYPE,
        p_in_iss_cd         gipi_parlist.iss_cd%TYPE,
        p_in_var_line_cd    gipi_parlist.line_cd%TYPE   
  );
  
  PROCEDURE copy_orig_comm_inv(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  );
    
  PROCEDURE copy_orig_cominv_per(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  );   
  
  PROCEDURE copy_orig_invoice(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  );
  
  PROCEDURE copy_orig_invperl(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  );
  
  PROCEDURE copy_orig_inv_tax (
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  );
  
  PROCEDURE copy_orig_itmperil(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  );
  
  PROCEDURE copy_pol_dist(
        p_in_par_id     gipi_parlist.par_id%TYPE,
        p_in_user_id    gipi_parlist.underwriter%TYPE,
        p_in_iss_cd     gipi_parlist.iss_cd%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE   
  );
  
  PROCEDURE copy_waccident_item(
        p_item_no IN       gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_waviation_item(
        p_item_no IN       gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );

  PROCEDURE copy_wbeneficiary(
        p_item_no IN       gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wbond_basic(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcargo(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcargo_carrier(
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcasualty_item(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcasualty_personnel(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcomm_invoices(
        p_item_grp         gipi_item.item_grp%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcomm_inv_perils(
        p_item_grp         gipi_item.item_grp%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wcosigntry(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wdeductibles(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wpolicy_deductibles(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wendttext(
        p_copy_long         IN OUT  gipi_wendttext.endt_tax%TYPE,
        p_in_par_id         IN      gipi_parlist.par_id%TYPE,
        p_in_copy_par_id    IN      gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wengg_basic(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wfireitm(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wgrouped_items(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_wgrp_items_beneficiary(
        p_item_no          gipi_item.item_no%TYPE,
        p_grouped_item_no  gipi_grp_items_beneficiary.grouped_item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_winstallment(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_winvoice(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_winvperl(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_winv_tax(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_witem(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_witemds(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_witemds_dtl(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_witemperilds(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_witemperilds_dtl(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_witem_discount(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_witem_pack(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE,
        p_item_grp         gipi_witem.item_grp%TYPE,
        p_item_no          gipi_witem.item_no%TYPE 
  );
  
  PROCEDURE copy_witem_ves(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  );
  
  PROCEDURE copy_witmperil_beneficiary(
        p_item_no          gipi_witmperl_beneficiary.item_no%TYPE,
        p_gitem_no         gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );      
  
  PROCEDURE copy_witmperl(
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE,
        p_in_line_cd       gipi_parlist.line_cd%TYPE 
  );
  
  PROCEDURE copy_witmperl_grouped(
        p_item_no          gipi_witmperl_beneficiary.item_no%TYPE,
        p_gitem_no         gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_witmperl_pack(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_line_cd       gipi_parlist.line_cd%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wlim_liab(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wline(
        p_item_no           gipi_item.item_no%TYPE,
        p_item_grp          gipi_item.item_grp%TYPE,
        p_pack_line_cd      gipi_pack_line_subline.pack_line_cd%TYPE,
        p_pack_subline_cd   gipi_pack_line_subline.pack_subline_cd%TYPE,
        p_in_par_id         gipi_parlist.par_id%TYPE,
        p_in_copy_par_id    gipi_parlist.par_id%TYPE,
        p_copy_fire_cd      gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_motor_cd     gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_accident_cd  gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_hull_cd      gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_cargo_cd     gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_casualty_cd  gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_engrng_cd    gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_surety_cd    gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_aviation_cd  gipi_pack_line_subline.pack_line_cd%TYPE
  );
  
  
  PROCEDURE copy_wvehicle(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wmcacc(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wves_accumulation(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wlocation(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wmortgagee(
        p_iss_cd           gipi_wmortgagee.iss_cd%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wopen_cargo(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wopen_liab(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wopen_peril(
        p_pack_line_cd     gipi_pack_line_subline.pack_line_cd%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wopen_policy(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wpack_line_subline(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wperilds(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wperilds_dtl(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_copy_dist_no     giuw_wperilds.dist_no%TYPE
  );
  
  PROCEDURE copy_wperil_discount(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wpictures(
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
--  PROCEDURE copy_wpictures(
--        p_item_no          gipi_witem.item_no%TYPE,
--        p_in_par_id        gipi_parlist.par_id%TYPE,
--        p_in_copy_par_id   gipi_parlist.par_id%TYPE
--  );
    
  PROCEDURE copy_wpolbas_discount(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wpolgenin(
        p_in_par_id       IN    gipi_parlist.par_id%TYPE,
        p_in_copy_par_id  IN    gipi_parlist.par_id%TYPE,
        p_copy_long       OUT   gipi_wpolgenin.gen_info%TYPE,
        p_copy_gen01      OUT   gipi_wpolgenin.gen_info01%TYPE,
        p_copy_gen02      OUT   gipi_wpolgenin.gen_info02%TYPE,
        p_copy_gen03      OUT   gipi_wpolgenin.gen_info03%TYPE,
        p_copy_gen04      OUT   gipi_wpolgenin.gen_info04%TYPE,
        p_copy_gen05      OUT   gipi_wpolgenin.gen_info05%TYPE,
        p_copy_gen06      OUT   gipi_wpolgenin.gen_info06%TYPE,
        p_copy_gen07      OUT   gipi_wpolgenin.gen_info07%TYPE,
        p_copy_gen08      OUT   gipi_wpolgenin.gen_info08%TYPE,
        p_copy_gen09      OUT   gipi_wpolgenin.gen_info09%TYPE,
        p_copy_gen10      OUT   gipi_wpolgenin.gen_info10%TYPE,
        p_copy_gen11      OUT   gipi_wpolgenin.gen_info11%TYPE,
        p_copy_gen12      OUT   gipi_wpolgenin.gen_info12%TYPE,
        p_copy_gen13      OUT   gipi_wpolgenin.gen_info13%TYPE,
        p_copy_gen14      OUT   gipi_wpolgenin.gen_info14%TYPE,
        p_copy_gen15      OUT   gipi_wpolgenin.gen_info15%TYPE,
        p_copy_gen16      OUT   gipi_wpolgenin.gen_info16%TYPE,
        p_copy_gen17      OUT   gipi_wpolgenin.gen_info17%TYPE
  );
  
  PROCEDURE copy_wpolicyds(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_copy_dist_no     giuw_wpolicyds.dist_no%TYPE
  );
  
  
  PROCEDURE copy_wpolicyds_dtl(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_copy_dist_no     giuw_wpolicyds.dist_no%TYPE
  );
  
  PROCEDURE copy_wpolnrep(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wpolwc(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wprincipal(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wves_air(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
  
  PROCEDURE copy_wpolbas(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE,
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_iss_cd        gipi_parlist.iss_cd%TYPE,
        p_in_iss_cd2       gipi_parlist.iss_cd%TYPE
  );
  
  TYPE par_list_lov_giuts007_type IS RECORD (
      
      line_cd        gipi_parlist.line_cd%TYPE,
      iss_cd         gipi_parlist.iss_cd%TYPE,
      par_yy         gipi_parlist.par_yy%TYPE,
      par_seq_no     gipi_parlist.par_seq_no%TYPE
   );
   TYPE par_list_lov_giuts007_tab IS TABLE OF par_list_lov_giuts007_type;
   
   FUNCTION get_lov_giuts007 (
            p_line_cd       gipi_parlist.line_cd%TYPE,
            p_iss_cd        gipi_parlist.iss_cd%TYPE,
            p_par_yy        gipi_parlist.par_yy%TYPE
   )
   RETURN par_list_lov_giuts007_tab PIPELINED;
   
   
   TYPE gipi_parlist_type IS RECORD (
      
      par_id            gipi_parlist.par_id%TYPE,
      par_status        gipi_parlist.par_status%TYPE,
      par_type          gipi_parlist.par_type%TYPE,
      is_pack           VARCHAR2(2) --jeffdojello 04.24.2013
   );
   TYPE gipi_parlist_tab IS TABLE OF gipi_parlist_type;
   
   FUNCTION get_par_status(
        p_line_cd       GIPI_PARLIST.line_cd%TYPE,
        p_iss_cd        GIPI_PARLIST.iss_cd%TYPE,
        p_par_yy        GIPI_PARLIST.par_yy%TYPE,
        p_par_seq_no    GIPI_PARLIST.par_seq_no%TYPE,
        p_quote_seq_no  GIPI_PARLIST.quote_seq_no%TYPE)
        
   RETURN gipi_parlist_tab PIPELINED;
   
   PROCEDURE copy_par_to_par(
        p_in_par_id      IN gipi_parlist.par_id%TYPE,
        p_in_user_id     IN gipi_parlist.underwriter%TYPE,
        p_in_iss_cd_2    IN gipi_parlist.iss_cd%TYPE,
        p_in_var_line_cd IN gipi_parlist.line_cd%TYPE,
        p_out_new_par    OUT VARCHAR2,
        p_out_old_par    OUT VARCHAR2
   );
   
    PROCEDURE update_parhist( 
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  );
   
  FUNCTION ck_user_per_ln_giuts007(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)  
  RETURN NUMBER;
   
  FUNCTION get_line_cd_per_line(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
  RETURN VARCHAR2;
  
  PROCEDURE read_into_copypar(
    p_copy_fire_cd      IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_motor_cd     IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_accident_cd  IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_hull_cd      IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_cargo_cd     IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_casualty_cd  IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_engrng_cd    IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_surety_cd    IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_aviation_cd  IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE
  
  );
  
  FUNCTION check_isscdex_per_user(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
  RETURN VARCHAR2;
  
  FUNCTION Check_User_Per_Iss_Cd_giuts007(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)  
  RETURN NUMBER;
  
   TYPE line_cd_lov_giuts007_type IS RECORD (
      
      line_cd           giis_line.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE
   );
   TYPE line_cd_lov_giuts007_tab IS TABLE OF line_cd_lov_giuts007_type;
   
   FUNCTION get_line_cd_lov (
        p_line_cd   VARCHAR2, 
        p_iss_cd    VARCHAR2,
        p_module_id VARCHAR2, 
        p_user_id   VARCHAR2
   )
   RETURN line_cd_lov_giuts007_tab PIPELINED;
   
   TYPE iss_cd_lov_giuts007_type IS RECORD (
      
      iss_cd           giis_issource.iss_cd%TYPE,
      iss_name         giis_issource.iss_name%TYPE
   );
   TYPE iss_cd_lov_giuts007_tab IS TABLE OF iss_cd_lov_giuts007_type;
   
   FUNCTION get_iss_cd_lov (
        p_line_cd   VARCHAR2, 
        p_iss_cd    VARCHAR2,
        p_module_id VARCHAR2, 
        p_user_id   VARCHAR2
   )
   RETURN iss_cd_lov_giuts007_tab PIPELINED;
    
END GIUTS007_PKG;
/
