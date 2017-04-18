CREATE OR REPLACE PACKAGE CPI.gicls056_pkg
AS
   TYPE cat_type IS RECORD (
      catastrophic_cd     gicl_cat_dtl.catastrophic_cd%TYPE,
      catastrophic_desc   gicl_cat_dtl.catastrophic_desc%TYPE,
      line_cd             gicl_cat_dtl.line_cd%TYPE,
      line_name           giis_line.line_name%TYPE,
      loss_cat_cd         gicl_cat_dtl.loss_cat_cd%TYPE,
      loss_cat_des        giis_loss_ctgry.loss_cat_des%TYPE,
      start_date          gicl_cat_dtl.start_date%TYPE,
      end_date            gicl_cat_dtl.end_date%TYPE,
      LOCATION            gicl_cat_dtl.LOCATION%TYPE,
      res_amt             NUMBER,
      pd_amt              NUMBER,
      remarks             gicl_cat_dtl.remarks%TYPE,
      user_id             gicl_cat_dtl.user_id%TYPE,
      last_update         VARCHAR2 (30),
      province_cd         gicl_cat_dtl.province_cd%TYPE,
      province_desc       giis_province.province_desc%TYPE,
      city_cd             gicl_cat_dtl.city_cd%TYPE,
      city                giis_city.city%TYPE,
      district_no         gicl_cat_dtl.district_no%TYPE,
      district_desc       giis_block.district_desc%TYPE,
      block_no            giis_block.block_no%TYPE,
      block_desc          giis_block.block_desc%TYPE,
      print_sw            VARCHAR2(1)
--      cat_cd
--      cat_desc
   );

   TYPE cat_tab IS TABLE OF cat_type;

   FUNCTION get_catastrophic_event (p_user_id VARCHAR2)
      RETURN cat_tab PIPELINED;

   PROCEDURE get_dsp_amt (
      p_catastrophic_cd   IN       gicl_cat_dtl.catastrophic_cd%TYPE,
      p_res_amt           OUT      NUMBER,
      p_pd_amt            OUT      NUMBER
   );

   TYPE details_type IS RECORD (
      claim_id              gicl_claims.claim_id%TYPE,
      catastrophic_cd       gicl_claims.catastrophic_cd%TYPE,
      line_cd               gicl_claims.line_cd%TYPE,
      subline_cd            gicl_claims.subline_cd%TYPE,
      iss_cd                gicl_claims.iss_cd%TYPE,
      clm_yy                gicl_claims.clm_yy%TYPE,
      clm_seq_no            gicl_claims.clm_seq_no%TYPE,
      loss_cat_cd           gicl_claims.loss_cat_cd%TYPE,
      loss_cat_des          giis_loss_ctgry.loss_cat_des%TYPE,
      loss_date             gicl_claims.loss_date%TYPE,
      net_res_amt           NUMBER (14, 2),
      trty_res_amt          NUMBER (14, 2),
      np_trty_res_amt       NUMBER (14, 2),
      facul_res_amt         NUMBER (14, 2),
      net_pd_amt            NUMBER (14, 2),
      trty_pd_amt           NUMBER (14, 2),
      np_trty_pd_amt        NUMBER (14, 2),
      facul_pd_amt          NUMBER (14, 2),
      claim_no              VARCHAR2 (50),
      loss_cat              VARCHAR2 (50),
      policy_no             VARCHAR2 (50),
      loss_res_amt          gicl_claims.loss_res_amt%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      loss_pd_amt           gicl_claims.loss_pd_amt%TYPE,
      in_hou_adj            gicl_claims.in_hou_adj%TYPE,
      exp_res_amt           gicl_claims.exp_res_amt%TYPE,
      clm_stat              VARCHAR2 (100),
      exp_pd_amt            gicl_claims.exp_pd_amt%TYPE,
      LOCATION              VARCHAR2 (200),
      tot_net_res_amt       NUMBER (14, 2),
      tot_trty_res_amt      NUMBER (14, 2),
      tot_np_trty_res_amt   NUMBER (14, 2),
      tot_facul_res_amt     NUMBER (14, 2),
      tot_net_pd_amt        NUMBER (14, 2),
      tot_trty_pd_amt       NUMBER (14, 2),
      tot_np_trty_pd_amt    NUMBER (14, 2),
      tot_facul_pd_amt      NUMBER (14, 2)
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (
      p_catastrophic_cd   VARCHAR2,
      p_user_id           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2
   )
      RETURN details_tab PIPELINED;

   PROCEDURE populate_details_amt (
      p_claim_id          IN       gicl_claims.claim_id%TYPE,
      p_district_no       IN       VARCHAR2,
      p_block_no          IN       VARCHAR2,
      p_net_res_amt       OUT      NUMBER,
      p_trty_res_amt      OUT      NUMBER,
      p_np_trty_res_amt   OUT      NUMBER,
      p_facul_res_amt     OUT      NUMBER,
      p_net_pd_amt        OUT      NUMBER,
      p_trty_pd_amt       OUT      NUMBER,
      p_np_trty_pd_amt    OUT      NUMBER,
      p_facul_pd_amt      OUT      NUMBER
   );

   TYPE claim_list_type IS RECORD (
      claim_id        gicl_claims.claim_id%TYPE,
      claim_no        VARCHAR2 (50),
      policy_no       VARCHAR2 (50),
      assd_name       giis_assured.assd_name%TYPE,
      loss_cat        VARCHAR2 (50),
      dsp_loss_date   gicl_claims.loss_date%TYPE,
      in_hou_adj      gicl_claims.in_hou_adj%TYPE,
      clm_stat_desc   VARCHAR2 (100)
   );

   TYPE claim_list_tab IS TABLE OF claim_list_type;

   FUNCTION get_claim_list_fi (
      p_user_id       VARCHAR2,
      p_loss_cat_cd   VARCHAR2,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_location      VARCHAR2,
      p_province_cd   VARCHAR2,
      p_city_cd       VARCHAR2,
      p_district_no   VARCHAR2,
      p_block_no      VARCHAR2,
      p_search_type   VARCHAR2
   )
      RETURN claim_list_tab PIPELINED;

   FUNCTION get_claim_list (
      p_user_id       VARCHAR2,
      p_loss_cat_cd   VARCHAR2,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_location      VARCHAR2,
      p_line_cd       VARCHAR2,
      p_search_type   VARCHAR2
   )
      RETURN claim_list_tab PIPELINED;

   PROCEDURE update_details (
      p_claim_id          VARCHAR2,
      p_catastrophic_cd   VARCHAR2,
      p_action            VARCHAR2
   );

   TYPE loss_cat_lov_type IS RECORD (
      loss_cat_cd    giis_loss_ctgry.loss_cat_cd%TYPE,
      loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE
   );

   TYPE loss_cat_lov_tab IS TABLE OF loss_cat_lov_type;

   FUNCTION get_loss_cat_lov (p_line_cd VARCHAR2)
      RETURN loss_cat_lov_tab PIPELINED;

   TYPE province_lov_type IS RECORD (
      province_cd     giis_province.province_cd%TYPE,
      province_desc   giis_province.province_desc%TYPE
   );

   TYPE province_lov_tab IS TABLE OF province_lov_type;

   FUNCTION get_province_lov
      RETURN province_lov_tab PIPELINED;

   TYPE city_lov_type IS RECORD (
      city_cd   giis_city.city_cd%TYPE,
      city      giis_city.city%TYPE
   );

   TYPE city_lov_tab IS TABLE OF city_lov_type;

   FUNCTION get_city_lov (p_province_cd VARCHAR2)
      RETURN city_lov_tab PIPELINED;

   TYPE district_lov_type IS RECORD (
      district_no     giis_block.district_no%TYPE,
      district_desc   giis_block.district_desc%TYPE
   );

   TYPE district_lov_tab IS TABLE OF district_lov_type;

   FUNCTION get_district_lov (p_province_cd VARCHAR2, p_city_cd VARCHAR2)
      RETURN district_lov_tab PIPELINED;

   TYPE block_lov_type IS RECORD (
      block_no     giis_block.block_no%TYPE,
      block_desc   giis_block.block_desc%TYPE
   );

   TYPE block_lov_tab IS TABLE OF block_lov_type;

   FUNCTION get_block_lov (
      p_province_cd   VARCHAR2,
      p_city_cd       VARCHAR2,
      p_district_no   VARCHAR2
   )
      RETURN block_lov_tab PIPELINED;

   PROCEDURE save_rec (p_rec gicl_cat_dtl%ROWTYPE);

   FUNCTION val_delete (p_cat_cd VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE del_rec (p_cat_cd VARCHAR2);

   PROCEDURE update_details_all (
      p_cat_cd            VARCHAR2,
      p_user_id           VARCHAR2,
      p_loss_cat_cd       VARCHAR2,
      p_start_date        VARCHAR2,
      p_end_date          VARCHAR2,
      p_location          VARCHAR2,
      p_province_cd       VARCHAR2,
      p_city_cd           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2,
      p_line_cd           VARCHAR2,
      p_search_type       VARCHAR2
   );
   
   PROCEDURE remove_all_details(
      p_catastrophic_cd   VARCHAR2,
      p_user_id           VARCHAR2
   );
   
   TYPE line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );
   
   TYPE line_tab IS TABLE OF line_type;
   
   FUNCTION get_line_lov(
      p_module_id VARCHAR2,
      p_user_id   VARCHAR2,
      p_find_text VARCHAR2
   )
      RETURN line_tab PIPELINED;
      
   PROCEDURE val_add_rec (
      p_cat_cd    VARCHAR2,
      p_cat_desc  VARCHAR2
   );
   
--   TYPE claims_type IS RECORD (
--      claim_id gicl_claims.claim_id%TYPE
--   );
--   
--   TYPE claims_tab IS TABLE OF claims_type;
   
   FUNCTION get_claim_nos (
      p_catastrophic_cd   VARCHAR2,
      p_user_id           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2
   )
      RETURN VARCHAR2;
      
   FUNCTION get_claim_nos_list(
      p_user_id       VARCHAR2,
      p_loss_cat_cd   VARCHAR2,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_location      VARCHAR2,
      p_line_cd       VARCHAR2,
      p_search_type   VARCHAR2
   )
      RETURN VARCHAR2;
      
   FUNCTION get_claim_nos_list_fi (
      p_user_id       VARCHAR2,
      p_loss_cat_cd   VARCHAR2,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_location      VARCHAR2,
      p_province_cd   VARCHAR2,
      p_city_cd       VARCHAR2,
      p_district_no   VARCHAR2,
      p_block_no      VARCHAR2,
      p_search_type   VARCHAR2
   )
      RETURN VARCHAR2;
      
    PROCEDURE check_details (
      p_catastrophic_cd   IN VARCHAR2,
      p_user_id           IN VARCHAR2,
      p_res_amt           OUT NUMBER,
      p_pd_amt            OUT NUMBER,
      p_exists            OUT VARCHAR2
    );     
         
END;
/


