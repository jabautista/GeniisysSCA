CREATE OR REPLACE PACKAGE CPI.Gipi_Witmperl_Pkg AS

  TYPE gipi_witmperl_type IS RECORD
    (discount_sw          GIPI_WITMPERL.discount_sw%TYPE,
     surcharge_sw          GIPI_WITMPERL.surcharge_sw%TYPE,
     prt_flag              GIPI_WITMPERL.prt_flag%TYPE,
     peril_cd              GIPI_WITMPERL.peril_cd%TYPE,
     peril_name              GIIS_PERIL.peril_name%TYPE,
     prem_rt              GIPI_WITMPERL.prem_rt%TYPE,
     tsi_amt              GIPI_WITMPERL.tsi_amt%TYPE,
     prem_amt              GIPI_WITMPERL.prem_amt%TYPE,
     no_of_days              GIPI_WITMPERL.no_of_days%TYPE,
     base_amt              GIPI_WITMPERL.base_amt%TYPE,
     aggregate_sw          GIPI_WITMPERL.aggregate_sw%TYPE,
     ri_comm_rate          GIPI_WITMPERL.ri_comm_rate%TYPE,
     ri_comm_amt          GIPI_WITMPERL.ri_comm_amt%TYPE,
     par_id                  GIPI_WITMPERL.par_id%TYPE,
     item_no              GIPI_WITMPERL.item_no%TYPE,
     line_cd              GIPI_WITMPERL.line_cd%TYPE,
     ann_tsi_amt          GIPI_WITMPERL.ann_tsi_amt%TYPE,
     ann_prem_amt          GIPI_WITMPERL.ann_prem_amt%TYPE,
     peril_type              GIIS_PERIL.peril_type%TYPE,
     tarf_cd              GIPI_WITMPERL.tarf_cd%TYPE,
     comp_rem              GIPI_WITMPERL.comp_rem%TYPE,
     basc_perl_cd          GIIS_PERIL.basc_perl_cd%TYPE,
     rec_flag              GIPI_WITMPERL.rec_flag%TYPE);

  TYPE gipi_witmperl_tab IS TABLE OF gipi_witmperl_type;

    TYPE gipi_witmperl_type_all_cols IS RECORD (
        par_id            gipi_witmperl.par_id%TYPE,
        item_no            gipi_witmperl.item_no%TYPE,
        line_cd            gipi_witmperl.line_cd%TYPE,
        peril_cd        gipi_witmperl.peril_cd%TYPE,
        tarf_cd            gipi_witmperl.tarf_cd%TYPE,
        prem_rt            gipi_witmperl.prem_rt%TYPE,
        tsi_amt            gipi_witmperl.tsi_amt%TYPE,
        prem_amt        gipi_witmperl.prem_amt%TYPE,
        ann_tsi_amt        gipi_witmperl.ann_tsi_amt%TYPE,
        ann_prem_amt    gipi_witmperl.ann_prem_amt%TYPE,
        rec_flag        gipi_witmperl.rec_flag%TYPE,
        comp_rem        gipi_witmperl.comp_rem%TYPE,
        discount_sw        gipi_witmperl.discount_sw%TYPE,
        prt_flag        gipi_witmperl.prt_flag%TYPE,
        ri_comm_rate    gipi_witmperl.ri_comm_rate%TYPE,
        ri_comm_amt        gipi_witmperl.ri_comm_amt%TYPE,
        as_charge_sw    gipi_witmperl.as_charge_sw%TYPE,
        surcharge_sw    gipi_witmperl.surcharge_sw%TYPE,
        no_of_days        gipi_witmperl.no_of_days%TYPE,
        base_amt        gipi_witmperl.base_amt%TYPE,
        aggregate_sw    gipi_witmperl.aggregate_sw%TYPE);

    TYPE rc_gipi_witmperl IS REF CURSOR RETURN gipi_witmperl_type_all_cols;

  FUNCTION par_item_has_peril(p_par_id    GIPI_WPOLBAS.par_id%TYPE,
                              p_item_no   GIPI_WITMPERL.item_no%TYPE)
    RETURN BOOLEAN;

  TYPE peril_list_type IS RECORD
    (item_no    GIPI_WITMPERL.item_no%TYPE,
     peril_cd   GIIS_PERIL.peril_cd%TYPE,
     peril_name GIIS_PERIL.peril_name%TYPE,
     peril_type GIIS_PERIL.peril_type%TYPE,
     tsi_amt    GIPI_WITMPERL.tsi_amt%TYPE,
     prem_amt   GIPI_WITMPERL.prem_amt%TYPE);

  TYPE peril_list_tab IS TABLE OF peril_list_type;

  FUNCTION get_witmperl_list (p_par_id    GIPI_WITMPERL.par_id%TYPE,
                              p_line_cd   GIPI_WITMPERL.line_cd%TYPE)
    RETURN peril_list_tab PIPELINED;

  FUNCTION get_witmperl_list (p_par_id    GIPI_WITMPERL.par_id%TYPE)
    RETURN peril_list_tab PIPELINED;

  FUNCTION get_gipi_witmperl (p_par_id            GIPI_WITMPERL.par_id%TYPE,
                                   p_item_no            GIPI_WITMPERL.item_no%TYPE)
    RETURN gipi_witmperl_tab PIPELINED;

  FUNCTION get_gipi_witmperl (p_par_id            GIPI_WITMPERL.par_id%TYPE,
                                   p_item_no            GIPI_WITMPERL.item_no%TYPE,
                              p_line_cd            GIPI_WITMPERL.line_cd%TYPE)
    RETURN gipi_witmperl_tab PIPELINED;

  /*
  * emman - 060110
  * checks if item in specified par exists
  */

  FUNCTION is_exist_gipi_witmperl(p_par_id    GIPI_WITMPERL.par_id%TYPE,
                         p_item_no    GIPI_WITMPERL.item_no%TYPE)
    RETURN VARCHAR2;

  FUNCTION is_exist_par_item_peril(p_par_id    GIPI_WITMPERL.par_id%TYPE,
                         p_item_no    GIPI_WITMPERL.item_no%TYPE)
    RETURN VARCHAR2;

  Procedure set_gipi_witmperl (
     p_discount_sw          IN  GIPI_WITMPERL.discount_sw%TYPE,
     p_surcharge_sw          IN  GIPI_WITMPERL.surcharge_sw%TYPE,
     p_prt_flag              IN  GIPI_WITMPERL.prt_flag%TYPE,
     p_peril_cd              IN  GIPI_WITMPERL.peril_cd%TYPE,
     p_prem_rt              IN  GIPI_WITMPERL.prem_rt%TYPE,
     p_tsi_amt              IN  GIPI_WITMPERL.tsi_amt%TYPE,
     p_prem_amt              IN  GIPI_WITMPERL.prem_amt%TYPE,
     p_no_of_days          IN  GIPI_WITMPERL.no_of_days%TYPE,
     p_base_amt              IN  GIPI_WITMPERL.base_amt%TYPE,
     p_aggregate_sw          IN  GIPI_WITMPERL.aggregate_sw%TYPE,
     p_ri_comm_rate          IN  GIPI_WITMPERL.ri_comm_rate%TYPE,
     p_ri_comm_amt          IN  GIPI_WITMPERL.ri_comm_amt%TYPE,
     p_par_id              IN  GIPI_WITMPERL.par_id%TYPE,
     p_item_no              IN  GIPI_WITMPERL.item_no%TYPE,
     p_line_cd              IN  GIPI_WITMPERL.line_cd%TYPE,
     p_ann_tsi_amt          IN  GIPI_WITMPERL.ann_tsi_amt%TYPE,
     p_ann_prem_amt          IN  GIPI_WITMPERL.ann_prem_amt%TYPE,
     p_tarf_cd              IN  GIPI_WITMPERL.tarf_cd%TYPE,
     p_comp_rem              IN  GIPI_WITMPERL.comp_rem%TYPE);

  Procedure set_gipi_witmperl (p_witmperl    IN GIPI_WITMPERL%ROWTYPE);

  Procedure del_gipi_witmperl (    p_par_id              IN  GIPI_WITMPERL.par_id%TYPE,
                                p_item_no              IN  GIPI_WITMPERL.item_no%TYPE,
                                p_line_cd              IN  GIPI_WITMPERL.line_cd%TYPE,
                                p_peril_cd              IN  GIPI_WITMPERL.peril_cd%TYPE );

    Procedure del_gipi_witmperl_1 (p_par_id    GIPI_WITMPERL.par_id%TYPE,
        p_item_no    GIPI_WITMPERL.item_no%TYPE,
        p_line_cd    GIPI_WITMPERL.line_cd%TYPE);

  Procedure get_gipi_witmperl_exist (p_par_id  IN GIPI_WITMPERL.par_id%TYPE,
                                       p_exist   OUT NUMBER);

  FUNCTION get_gipi_witmperl_exist (p_par_id          GIPI_WITMPERL.par_id%TYPE,
                                         p_item_no        GIPI_WITMPERL.item_no%TYPE)
    RETURN VARCHAR2;

  Procedure set_delete_discount(p_par_id              IN     GIPI_WITMPERL.par_id%TYPE
                                   ,p_item_no              IN     GIPI_WITMPERL.item_no%TYPE
                                 ,p_item_prem_amt      OUT VARCHAR2--OUT     GIPI_WITEM.prem_amt%TYPE
                                 ,p_item_ann_prem_amt OUT VARCHAR2);--OUT     GIPI_WITEM.ann_prem_amt%TYPE);

  Procedure update_witem(p_par_id              IN     GIPI_WITMPERL.par_id%TYPE
                          ,p_item_no              IN     GIPI_WITMPERL.item_no%TYPE);

  Procedure create_winvoice_for_par(p_par_id      GIPI_WITMPERL.par_id%TYPE,
                                      p_line_cd      GIPI_WITMPERL.line_cd%TYPE,
                                    p_iss_cd      GIPI_PARLIST.iss_cd%TYPE);

  Procedure del_gipi_witmperl2 (p_par_id    GIPI_WITMPERL.par_id%TYPE);

  Procedure set_gipi_witmperl2(p_par_id       IN GIPI_WITMPERL.par_id%TYPE,
                               p_item_no      IN GIPI_WITMPERL.item_no%TYPE,
                               p_line_cd      IN GIPI_WITMPERL.line_cd%TYPE,
                               p_peril_cd     IN GIPI_WITMPERL.peril_cd%TYPE,
                               p_discount_sw  IN GIPI_WITMPERL.discount_sw%TYPE,
                               p_prem_rt      IN GIPI_WITMPERL.prem_rt%TYPE,
                               p_tsi_amt      IN GIPI_WITMPERL.tsi_amt%TYPE,
                               p_prem_amt     IN GIPI_WITMPERL.prem_amt%TYPE,
                               p_ann_tsi_amt  IN GIPI_WITMPERL.ann_tsi_amt%TYPE,
                               p_ann_prem_amt IN GIPI_WITMPERL.ann_prem_amt%TYPE);

  TYPE peril_details_type IS RECORD
    (prem_rt                GIPI_WITMPERL.prem_rt%TYPE,
     tsi_amt                GIPI_WITMPERL.tsi_amt%TYPE,
     prem_amt               GIPI_WITMPERL.prem_amt%TYPE,
     ann_tsi_amt            GIPI_WITMPERL.ann_tsi_amt%TYPE,
     ann_prem_amt           GIPI_WITMPERL.ann_prem_amt%TYPE,
     ri_comm_rate           GIPI_WITMPERL.ri_comm_rate%TYPE,
     ri_comm_amt            GIPI_WITMPERL.ri_comm_amt%TYPE);

  TYPE peril_details_tab IS TABLE OF peril_details_type;

  FUNCTION get_peril_details(p_par_id    GIPI_PARLIST.par_id%TYPE,
                                    p_item_no     GIPI_WITEM.item_no%TYPE,
                             p_peril_cd     GIIS_PERIL.peril_cd%TYPE,
                             p_prem_amt     GIPI_WITMPERL.prem_amt%TYPE,
                             p_comp_rem  GIPI_WITMPERL.comp_rem%TYPE)
    RETURN peril_details_tab PIPELINED;

  TYPE endt_peril_type IS RECORD (
    par_id          GIPI_WITMPERL.par_id%TYPE,
    item_no         GIPI_WITMPERL.item_no%TYPE,
    line_cd         GIPI_WITMPERL.line_cd%TYPE,
    peril_cd        GIPI_WITMPERL.peril_cd%TYPE,
    peril_name        GIIS_PERIL.peril_name%TYPE,
    prem_rt            GIPI_WITMPERL.prem_rt%TYPE,
    tsi_amt            GIPI_WITMPERL.tsi_amt%TYPE,
    prem_amt        GIPI_WITMPERL.prem_amt%TYPE,
    ann_tsi_amt        GIPI_WITMPERL.ann_tsi_amt%TYPE,
    ann_prem_amt    GIPI_WITMPERL.ann_prem_amt%TYPE,
    ri_comm_rate    GIPI_WITMPERL.ri_comm_rate%TYPE,
    ri_comm_amt        GIPI_WITMPERL.ri_comm_amt%TYPE,
    comp_rem        GIPI_WITMPERL.comp_rem%TYPE,
    rec_flag        GIPI_WITMPERL.rec_flag%TYPE,
    no_of_days        GIPI_WITMPERL.no_of_days%TYPE,
    base_amt        GIPI_WITMPERL.base_amt%TYPE,
    disc_sum        GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
    tarf_cd         GIPI_WITMPERL.tarf_cd%TYPE,
    peril_type      GIIS_PERIL.peril_type%TYPE,
	basc_perl_cd    GIIS_PERIL.basc_perl_cd%TYPE,
    endt_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE,
    endt_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE,
    base_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE
    );

  TYPE endt_peril_tab IS TABLE OF endt_peril_type;

  FUNCTION get_endt_peril(p_par_id      GIPI_WITMPERL.par_id%TYPE)
    RETURN endt_peril_tab PIPELINED;

  TYPE item_and_peril_amounts_type IS RECORD(
    peril_prem_amt     GIPI_WITMPERL.prem_amt%TYPE, --NUMBER(14,2),
    peril_ann_prem_amt GIPI_WITMPERL.ann_prem_amt%TYPE,--NUMBER(14,2),
    peril_ann_tsi_amt  GIPI_WITMPERL.ann_tsi_amt%TYPE,
    item_prem_amt       GIPI_WITEM.prem_amt%TYPE,--NUMBER(14,2),
    item_ann_prem_amt  GIPI_WITEM.ann_prem_amt%TYPE,--NUMBER(14,2),
    item_tsi_amt       GIPI_WITEM.tsi_amt%TYPE,
    item_ann_tsi_amt   GIPI_WITEM.ann_tsi_amt%TYPE,
    peril_tsi_amt     GIPI_WITMPERL.tsi_amt%TYPE    --added by Gzelle 11262014
    );

  TYPE item_and_peril_amounts_tab IS TABLE OF item_and_peril_amounts_type;

  TYPE giis_plan_dtl_type IS RECORD (
      peril_cd              GIIS_PLAN_DTL.peril_cd%TYPE,
      aggregate_sw          GIIS_PLAN_DTL.aggregate_sw%TYPE,
      base_amt              GIIS_PLAN_DTL.base_amt%TYPE,
      line_cd              GIIS_PLAN_DTL.line_cd%TYPE,
      no_of_days          GIIS_PLAN_DTL.no_of_days%TYPE,
      prem_amt              GIIS_PLAN_DTL.prem_amt%TYPE,
      prem_rt              GIIS_PLAN_DTL.prem_rt%TYPE,
      tsi_amt              GIIS_PLAN_DTL.tsi_amt%TYPE,
      peril_type          GIIS_PERIL.peril_type%TYPE,
      peril_name          GIIS_PERIL.peril_name%TYPE
   );

  TYPE giis_plan_dtl_tab IS TABLE OF giis_plan_dtl_type;

  FUNCTION get_giis_plan_dtls(
             p_par_id              GIPI_PARLIST.par_id%TYPE,
           p_pack_par_id      GIPI_PARLIST.pack_par_id%TYPE,
           p_pack_line_cd      GIPI_WITEM.pack_line_cd%TYPE,
           p_pack_subline_cd  GIPI_WITEM.pack_subline_cd%TYPE)
    RETURN giis_plan_dtl_tab PIPELINED;

  FUNCTION get_post_tsi_details(p_par_id          IN  GIPI_PARLIST.par_id%TYPE,
                                p_item_no          IN  GIPI_WITEM.item_no%TYPE,
                                p_peril_cd            IN  GIPI_WITMPERL.peril_cd%TYPE,
                                p_prem_rt          IN  GIPI_WITMPERL.prem_rt%TYPE,
                                p_tsi_amt          IN  GIPI_WITMPERL.tsi_amt%TYPE,
                                p_prem_amt            IN  GIPI_WITMPERL.prem_amt%TYPE,
                                p_ann_tsi_amt     IN  GIPI_WITMPERL.ann_tsi_amt%TYPE,
                                p_ann_prem_amt    IN  GIPI_WITMPERL.ann_prem_amt%TYPE,
                                i_tsi_amt         IN  GIPI_WITEM.tsi_amt%TYPE ,
                                i_prem_amt        IN  GIPI_WITEM.prem_amt%TYPE,
                                i_ann_tsi_amt     IN  GIPI_WITEM.ann_tsi_amt%TYPE,
                                i_ann_prem_amt    IN  GIPI_WITEM.ann_prem_amt%TYPE)
    RETURN item_and_peril_amounts_tab PIPELINED;

   Procedure update_gipi_witmperl_discount(p_par_id                  GIPI_WITMPERL.par_id%TYPE,
                                           p_item_no                 GIPI_WITMPERL.item_no%TYPE,
                                           p_peril_cd                GIPI_WITMPERL.peril_cd%TYPE,
                                           p_disc_amt                GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
                                           p_orig_peril_ann_prem_amt GIPI_WPERIL_DISCOUNT.orig_peril_ann_prem_amt%TYPE);

    FUNCTION get_gipi_witmperl_exist (p_par_id IN GIPI_WITMPERL.par_id%TYPE)
    RETURN VARCHAR2;

    /* Added by reymon 04222013
    ** for package endorsement
    */
    FUNCTION get_pack_gipi_witmperl_exist (pack_par_id IN GIPI_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2;

    FUNCTION get_negate_itmperls (
      p_par_id    gipi_witmperl.par_id%TYPE,
      p_item_no   gipi_witmperl.item_no%TYPE
   )
      RETURN gipi_witmperl_tab PIPELINED;

   FUNCTION get_witmperl_list3 (
        p_par_id    gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE
        ) RETURN peril_list_tab PIPELINED;

   FUNCTION get_witmperl_list4 (
        p_par_id    gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE
        ) RETURN peril_list_tab PIPELINED;

    FUNCTION get_gipi_witmperl_pack_pol (
        p_par_id IN gipi_witmperl.par_id%TYPE,
        p_item_no IN gipi_witmperl.item_no%TYPE)
    RETURN gipi_witmperl_tab PIPELINED;

    PROCEDURE get_prem_tsi_sum (
        p_par_id    IN  GIPI_WITMPERL.par_id%TYPE,
        p_prem      OUT GIPI_WITMPERL.prem_amt%TYPE,
        p_tsi       OUT GIPI_WITMPERL.tsi_amt%TYPE);

    FUNCTION check_peril_exist (p_par_id     GIPI_WITEM.par_id%TYPE)
    RETURN NUMBER;

    PROCEDURE del_witmperl_per_item ( p_par_id   IN  GIPI_WITMPERL.par_id%TYPE,
                                      p_item_no  IN  GIPI_WITMPERL.item_no%TYPE);

    FUNCTION get_gipi_witmperl_tg (
        p_par_id IN gipi_witmperl.par_id%TYPE,
        p_item_no IN gipi_witmperl.item_no%TYPE,
        p_peril_name IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_witmperl_tab PIPELINED;

    PROCEDURE update_change_in_assured(
        p_par_id     IN NUMBER,
        p_line_cd    IN VARCHAR2,
        p_iss_cd     IN VARCHAR2
    );

    /*FUNCTION check_peril_on_witems (
        p_par_id        IN gipi_witmperl.par_id%TYPE,
        p_pack_par_id   IN gipi_pack_parlist.pack_par_id%TYPE
    ) RETURN VARCHAR2;*/

    TYPE noperil_item_list_type IS RECORD
    (   par_id          GIPI_PARLIST.par_id%TYPE,
        par_no          VARCHAR2(100),
        item_no         GIPI_WITEM.item_no%TYPE);

    TYPE noperil_item_list_tab IS TABLE OF noperil_item_list_type;

    FUNCTION get_items_without_perils (
        p_par_id        IN gipi_witmperl.par_id%TYPE,
        p_pack_par_id   IN gipi_pack_parlist.pack_par_id%TYPE
    ) RETURN noperil_item_list_tab PIPELINED;

	FUNCTION get_peril_default_tag (
        p_line_cd       GIIS_PERIL.line_cd%TYPE,
        p_subline_cd    GIIS_PERIL.subline_cd%TYPE
    ) RETURN VARCHAR2;

	PROCEDURE SAVE_COPY_PERIL (p_witmperl IN gipi_witmperl%ROWTYPE);

	PROCEDURE SAVE_COPY_PERIL_AMT (p_par_id            GIPI_WITMPERL.par_id%TYPE,
                                   p_from_item_no            GIPI_WITMPERL.item_no%TYPE,
								   p_to_item_no            GIPI_WITMPERL.item_no%TYPE);

    PROCEDURE insert_into_gipi_witmperl(
        p_par_id            GIPI_WITMPERL.par_id%TYPE,
        p_limit_liability   GIPI_WITMPERL.tsi_amt%TYPE,
        p_line_cd           GIPI_WITMPERL.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
		p_user_id           GIPI_WPOLBAS.user_id%TYPE
    );

END Gipi_Witmperl_Pkg;
/


