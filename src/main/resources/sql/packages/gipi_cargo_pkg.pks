CREATE OR REPLACE PACKAGE CPI.gipi_cargo_pkg
AS
   FUNCTION get_cargo_item_currency (
      p_extract_id   gixx_parlist.extract_id%TYPE,
      p_item_no      gipi_cargo.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_inv_value (
      p_extract_id   gixx_parlist.extract_id%TYPE,
      p_item_no      gipi_cargo.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_markup_rate (
      p_extract_id   gixx_parlist.extract_id%TYPE,
      p_item_no      gipi_cargo.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_inv_curr_rt (
      p_extract_id   gixx_parlist.extract_id%TYPE,
      p_item_no      gipi_cargo.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_inv_currency (
      p_extract_id   gixx_parlist.extract_id%TYPE,
      p_item_no      gipi_cargo.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_agreed_value (
      p_extract_id   gixx_parlist.extract_id%TYPE,
      p_item_no      gipi_cargo.item_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE gipi_cargo_type IS RECORD (
      policy_id              gipi_item.policy_id%TYPE,
      item_no                gipi_item.item_no%TYPE,
      rec_flag               gipi_cargo.rec_flag%TYPE,
      print_tag              gipi_cargo.print_tag%TYPE,
      vessel_cd              gipi_cargo.vessel_cd%TYPE,
      geog_cd                gipi_cargo.geog_cd%TYPE,
      cargo_class_cd         gipi_cargo.cargo_class_cd%TYPE,
      voyage_no              gipi_cargo.voyage_no%TYPE,
      bl_awb                 gipi_cargo.bl_awb%TYPE,
      origin                 gipi_cargo.origin%TYPE,
      destn                  gipi_cargo.destn%TYPE,
      etd                    gipi_cargo.etd%TYPE,
      eta                    gipi_cargo.eta%TYPE,
      cargo_type             gipi_cargo.cargo_type%TYPE,
      pack_method            gipi_cargo.pack_method%TYPE,
      tranship_origin        gipi_cargo.tranship_origin%TYPE,
      tranship_destination   gipi_cargo.tranship_destination%TYPE,
      deduct_text            gipi_cargo.deduct_text%TYPE,
      lc_no                  gipi_cargo.lc_no%TYPE,
      invoice_value          gipi_cargo.invoice_value%TYPE,
      inv_curr_cd            gipi_cargo.inv_curr_cd%TYPE,
      inv_curr_rt            gipi_cargo.inv_curr_rt%TYPE,
      markup_rate            gipi_cargo.markup_rate%TYPE
   );

   TYPE gipi_cargo_tab IS TABLE OF gipi_cargo_type;

   FUNCTION get_gipi_cargo (
      p_policy_id   gipi_cargo.policy_id%TYPE,
      p_item_no     gipi_cargo.item_no%TYPE
   )
      RETURN gipi_cargo_tab PIPELINED;

   TYPE gipi_cargo_endt_type IS RECORD (
      policy_id              gipi_cargo.policy_id%TYPE,
      item_no                gipi_cargo.item_no%TYPE,
      rec_flag               gipi_cargo.rec_flag%TYPE,
      print_tag              gipi_cargo.print_tag%TYPE,
      vessel_cd              gipi_cargo.vessel_cd%TYPE,
      geog_cd                gipi_cargo.geog_cd%TYPE,
      cargo_class_cd         gipi_cargo.cargo_class_cd%TYPE,
      cargo_class_desc       giis_cargo_class.cargo_class_desc%TYPE,
      voyage_no              gipi_cargo.voyage_no%TYPE,
      bl_awb                 gipi_cargo.bl_awb%TYPE,
      origin                 gipi_cargo.origin%TYPE,
      destn                  gipi_cargo.destn%TYPE,
      etd                    gipi_cargo.etd%TYPE,
      eta                    gipi_cargo.eta%TYPE,
      cargo_type             gipi_cargo.cargo_type%TYPE,
      deduct_text            gipi_cargo.deduct_text%TYPE,
      pack_method            gipi_cargo.pack_method%TYPE,
      tranship_origin        gipi_cargo.tranship_origin%TYPE,
      tranship_destination   gipi_cargo.tranship_destination%TYPE,
      lc_no                  gipi_cargo.lc_no%TYPE,
      cpi_rec_no             gipi_cargo.cpi_rec_no%TYPE,
      cpi_branch_cd          gipi_cargo.cpi_branch_cd%TYPE,
      invoice_value          gipi_cargo.invoice_value%TYPE,
      inv_curr_cd            gipi_cargo.inv_curr_cd%TYPE,
      inv_curr_rt            gipi_cargo.inv_curr_rt%TYPE,
      markup_rate            gipi_cargo.markup_rate%TYPE,
      cargo_type_desc        giis_cargo_type.cargo_type_desc%TYPE --robert 9.18.2012
   );

   TYPE gipi_cargo_endt_tab IS TABLE OF gipi_cargo_endt_type;

   FUNCTION get_gipi_cargos1 (
      p_policy_id   IN   gipi_cargo.policy_id%TYPE,
      p_item_no     IN   gipi_cargo.item_no%TYPE
   )
      RETURN gipi_cargo_endt_tab PIPELINED;
      
   TYPE cargo_info_type IS RECORD(
    
      policy_id               gipi_cargo.policy_id%TYPE,
      item_no                 gipi_cargo.item_no%TYPE,
      bl_awb                  gipi_cargo.bl_awb%TYPE,
      destn                   gipi_cargo.destn%TYPE,
      etd                     gipi_cargo.etd%TYPE,
      eta                     gipi_cargo.eta%TYPE,
      lc_no                   gipi_cargo.lc_no%TYPE,
      origin                  gipi_cargo.origin%TYPE,
      geog_cd                 gipi_cargo.geog_cd%TYPE,
      vessel_cd               gipi_cargo.vessel_cd%TYPE,
      voyage_no               gipi_cargo.voyage_no%TYPE,
      print_tag               gipi_cargo.print_tag%TYPE,
      cargo_type              gipi_cargo.cargo_type%TYPE,
      pack_method             gipi_cargo.pack_method%TYPE,
      inv_curr_rt             gipi_cargo.inv_curr_rt%TYPE,
      markup_rate             gipi_cargo.markup_rate%TYPE,
      deduct_text             gipi_cargo.deduct_text%TYPE,
      invoice_value           gipi_cargo.invoice_value%TYPE,
      cargo_class_cd          gipi_cargo.cargo_class_cd%TYPE,
      tranship_origin         gipi_cargo.tranship_origin%TYPE,
      tranship_destination    gipi_cargo.tranship_destination%TYPE,

      cargo_class_desc        giis_cargo_class.cargo_class_desc%TYPE,
      cargo_type_desc         giis_cargo_type.cargo_type_desc%TYPE,
      geog_desc               giis_geog_class.geog_desc%TYPE,
      short_name              giis_currency.short_name%TYPE,
      vessel_name             giis_vessel.vessel_name%TYPE,
      print_desc              cg_ref_codes.rv_meaning%TYPE,
      item_title              gipi_item.item_title%TYPE,
      multi_carrier           VARCHAR2(5)
      
       
   );
    
   TYPE cargo_info_tab IS TABLE OF cargo_info_type;
  
   FUNCTION get_cargo_info (
     p_policy_id   gipi_cargo.policy_id%TYPE,
     p_item_no     gipi_cargo.item_no%TYPE
   )
     RETURN cargo_info_tab PIPELINED;
     
END gipi_cargo_pkg;
/


