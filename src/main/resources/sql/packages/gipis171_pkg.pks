CREATE OR REPLACE PACKAGE CPI.gipis171_pkg
AS
   TYPE gipi_polbasic_type IS RECORD (
      --Added by MarkS SR5769 10.18.2016 OPTIMIZATION
      count_                NUMBER,
      rownum_               NUMBER,
      --END
      par_id        gipi_polbasic.par_id%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      renew_no      gipi_polbasic.renew_no%TYPE,
      endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy       gipi_polbasic.endt_yy%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      eff_date      gipi_polbasic.eff_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      assd_no       gipi_polbasic.assd_no%TYPE,
      assd_name     giis_assured.assd_name%TYPE,
      dist_no       giuw_pol_dist.dist_no%TYPE,
      dist_flag     gipi_polbasic.dist_flag%TYPE,
      policy_id     gipi_polbasic.policy_id%TYPE,
      ref_pol_no    gipi_polbasic.ref_pol_no%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE,
      renew_flag    gipi_polbasic.renew_flag%TYPE,
      policy_no     VARCHAR2 (100),
      endt_no       VARCHAR2 (100),
      par_no        VARCHAR2 (100),
      par_line_cd   gipi_parlist.line_cd%TYPE,
      par_issue_cd  gipi_parlist.iss_cd%TYPE,
      par_yy        gipi_parlist.par_yy%TYPE,
      par_seq_no    gipi_parlist.par_seq_no%TYPE,
      quote_seq_no  gipi_parlist.quote_seq_no%TYPE
   );

   TYPE gipi_polbasic_tab IS TABLE OF gipi_polbasic_type;
   
   TYPE gipi_polwc_type IS RECORD (
      policy_id     gipi_polbasic.policy_id%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      wc_cd         gipi_polwc.wc_cd%TYPE,
      print_seq_no  gipi_polwc.print_seq_no%TYPE,
      wc_title      gipi_polwc.wc_title%TYPE,
      wc_text01     gipi_polwc.wc_text01%TYPE,
      wc_text02     gipi_polwc.wc_text01%TYPE,
      wc_text03     gipi_polwc.wc_text01%TYPE,
      wc_text04     gipi_polwc.wc_text01%TYPE,
      wc_text05     gipi_polwc.wc_text01%TYPE,
      wc_text06     gipi_polwc.wc_text01%TYPE,
      wc_text07     gipi_polwc.wc_text01%TYPE,
      wc_text08     gipi_polwc.wc_text01%TYPE,
      wc_text09     gipi_polwc.wc_text01%TYPE,
      wc_text10     gipi_polwc.wc_text01%TYPE,
      wc_text11     gipi_polwc.wc_text01%TYPE,
      wc_text12     gipi_polwc.wc_text01%TYPE,
      wc_text13     gipi_polwc.wc_text01%TYPE,
      wc_text14     gipi_polwc.wc_text01%TYPE,
      wc_text15     gipi_polwc.wc_text01%TYPE,
      wc_text16     gipi_polwc.wc_text01%TYPE,
      wc_text17     gipi_polwc.wc_text01%TYPE,
      wc_remarks    gipi_polwc.wc_remarks%TYPE,
      print_sw      gipi_polwc.print_sw%TYPE,
      change_tag    gipi_polwc.change_tag%TYPE,
      wc_title2     gipi_polwc.wc_title2%TYPE,
      wc_sw         VARCHAR2(20)
      
   );

   TYPE gipi_polwc_tab IS TABLE OF gipi_polwc_type;
   
   TYPE warrcla_with_text IS RECORD
    (line_cd           GIIS_WARRCLA.line_cd%TYPE,
     main_wc_cd        GIIS_WARRCLA.main_wc_cd%TYPE,
     print_sw          GIIS_WARRCLA.print_sw%TYPE,
     wc_title          GIIS_WARRCLA.wc_title%TYPE,
     wc_text           VARCHAR2(32767),
     wc_text01         GIIS_WARRCLA.wc_text01%TYPE,
     wc_text02         GIIS_WARRCLA.wc_text02%TYPE,
     wc_text03         GIIS_WARRCLA.wc_text03%TYPE,
     wc_text04         GIIS_WARRCLA.wc_text04%TYPE,
     wc_text05         GIIS_WARRCLA.wc_text05%TYPE,
     wc_text06         GIIS_WARRCLA.wc_text06%TYPE,
     wc_text07         GIIS_WARRCLA.wc_text07%TYPE,
     wc_text08         GIIS_WARRCLA.wc_text08%TYPE,
     wc_text09         GIIS_WARRCLA.wc_text09%TYPE,
     wc_text10         GIIS_WARRCLA.wc_text10%TYPE,
     wc_text11         GIIS_WARRCLA.wc_text11%TYPE,
     wc_text12         GIIS_WARRCLA.wc_text12%TYPE,
     wc_text13         GIIS_WARRCLA.wc_text13%TYPE,
     wc_text14         GIIS_WARRCLA.wc_text14%TYPE,
     wc_text15         GIIS_WARRCLA.wc_text15%TYPE,
     wc_text16         GIIS_WARRCLA.wc_text16%TYPE,
     wc_text17         GIIS_WARRCLA.wc_text17%TYPE,
     text_update_sw    GIIS_WARRCLA.text_update_sw%TYPE,
     wc_sw             VARCHAR2(20),
     remarks           giis_warrcla.remarks%TYPE );

  TYPE warrcla_with_text_tab IS TABLE OF warrcla_with_text;


   FUNCTION get_gipis171_policies (
     /* Created function by Edison
     ** Get all the policies to change its warranties and clauses. */
      p_user_id      giis_users.user_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_par_line_cd  gipi_parlist.line_cd%TYPE,
      p_par_issue_cd gipi_parlist.iss_cd%TYPE,
      p_par_yy       gipi_parlist.par_yy%TYPE,
      p_par_seq_no   gipi_parlist.par_seq_no%TYPE,
      p_par_quote_seq_no  gipi_parlist.quote_seq_no%TYPE,
      --Added by MarkS SR5769 10.18.2016 OPTIMIZATION
     p_policy_no        VARCHAR2,
     p_endt_no          VARCHAR2,
     p_par_no           VARCHAR2,
     p_order_by          VARCHAR2,
     p_asc_desc_flag    VARCHAR2,
     p_from              NUMBER,
     p_to                NUMBER
     --END
   )
      RETURN gipi_polbasic_tab PIPELINED;
      
   FUNCTION get_gipis171_warrcla (
     /* Created function by Edison
     ** To get the warranties and clauses of the selected policy. */
      p_policy_id    gipi_polbasic.policy_id%TYPE,
      p_print_seq_no gipi_polwc.print_seq_no%TYPE,
      p_warr_title   gipi_polwc.wc_title%TYPE                                                                                                                         
   )
      RETURN gipi_polwc_tab PIPELINED;
  PROCEDURE set_gipi_polwc (p_polwc           GIPI_POLWC%ROWTYPE);
  /* Procedure created by Edison
  ** To delete warranties or clauses of the selected policy. */
      
  
  PROCEDURE del_gipi_polwc (p_line_cd          GIPI_POLWC.line_cd%TYPE,
                             p_policy_id        GIPI_POLWC.policy_id%TYPE,
                             p_wc_cd            GIPI_POLWC.wc_cd%TYPE); 
  /* Procedure created by Edison
  ** To add or update the warranties or clauses of the selected policy. */
  
  FUNCTION get_warrcla_list_lov (p_line_cd GIIS_WARRCLA.line_cd%TYPE,
                                  p_wc_title GIIS_WARRCLA.wc_title%TYPE)
    RETURN warrcla_with_text_tab PIPELINED;
    
  FUNCTION validate_warrcla (p_wc_title GIIS_WARRCLA.wc_title%TYPE)
    RETURN VARCHAR2;    
END;
/
