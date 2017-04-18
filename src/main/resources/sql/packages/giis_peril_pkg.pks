CREATE OR REPLACE PACKAGE CPI.Giis_Peril_Pkg AS

/********************************** FUNCTION 1 ************************************/

  TYPE peril_list_type IS RECORD
    (item_no              GIPI_WITMPERL.item_no%TYPE,
     peril_cd             GIIS_PERIL.peril_cd%TYPE,
     peril_name           GIIS_PERIL.peril_name%TYPE,
     peril_type           VARCHAR(200),
     default_rate          GIIS_PERIL.default_rate%TYPE,
     default_tsi              GIIS_PERIL.default_tsi%TYPE,
     wc_exists            VARCHAR2(3));

  TYPE peril_list_tab IS TABLE OF peril_list_type;

  FUNCTION get_peril_list (p_line_cd  GIIS_LINE.line_cd%TYPE)
    RETURN peril_list_tab PIPELINED;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: CGFK$CV001_DSP_PERIL_NAME
***********************************************************************************/

  TYPE peril_name_list_type IS RECORD
    (peril_name           GIIS_PERIL.peril_name%TYPE,
     peril_sname          GIIS_PERIL.peril_sname%TYPE,
     peril_type           GIIS_PERIL.peril_type%TYPE,
     ri_comm_rt           GIIS_PERIL.ri_comm_rt%TYPE,
     basc_perl_cd         GIIS_PERIL.basc_perl_cd%TYPE,
     basic_peril          GIIS_PERIL.peril_sname%TYPE,
     basic_peril_name     GIIS_PERIL.peril_name%TYPE,
     intm_comm_rt         GIIS_PERIL.intm_comm_rt%TYPE,
     prt_flag             GIIS_PERIL.prt_flag%TYPE,
     line_cd              GIIS_PERIL.line_cd%TYPE,
     peril_cd             GIIS_PERIL.peril_cd%TYPE,
     wc_sw                VARCHAR2(1),
     dflt_tsi             GIIS_PERIL.dflt_tsi%TYPE,
     dflt_tag             GIIS_PERIL.dflt_tag%TYPE,
     dflt_rate            GIIS_PERIL.dflt_rate%TYPE,
     default_tag          GIIS_PERIL.default_tag%TYPE,
     default_rate         GIIS_PERIL.default_rate%TYPE,
     default_tsi          GIIS_PERIL.default_tsi%TYPE);

  TYPE peril_name_list_tab IS TABLE OF peril_name_list_type;

    TYPE peril_name_list_type1 IS RECORD (
        peril_name           giis_peril.peril_name%TYPE,
        peril_sname          giis_peril.peril_sname%TYPE,
        peril_type           giis_peril.peril_type%TYPE,
        ri_comm_rt           giis_peril.ri_comm_rt%TYPE,
        ri_comm_amt           giis_peril.ri_comm_rt%TYPE,
        basc_perl_cd         giis_peril.basc_perl_cd%TYPE,
        basic_peril          giis_peril.peril_sname%TYPE,
        basic_peril_name     giis_peril.peril_name%TYPE,
        intm_comm_rt         giis_peril.intm_comm_rt%TYPE,
        prt_flag             giis_peril.prt_flag%TYPE,
        line_cd              giis_peril.line_cd%TYPE,
        peril_cd             giis_peril.peril_cd%TYPE,
        wc_sw                VARCHAR2(1),
        tarf_cd              giis_peril_tariff.TARF_CD%TYPE,
        dflt_tsi             giis_peril.dflt_tsi%TYPE,
        dflt_tag             giis_peril.dflt_tag%TYPE,
        dflt_rate            giis_peril.dflt_rate%TYPE,
        default_tag          giis_peril.default_tag%TYPE,
        default_rate         giis_peril.default_rate%TYPE,
        default_tsi          giis_peril.default_tsi%TYPE);

    TYPE peril_name_list_tab1 IS TABLE OF peril_name_list_type1;

    TYPE peril_name_list_type2 IS RECORD (
        dsp_peril_name           giis_peril.peril_name%TYPE,
        dsp_peril_sname          giis_peril.peril_sname%TYPE,
        dsp_peril_type           giis_peril.peril_type%TYPE,
        dsp_basc_perl_cd         giis_peril.basc_perl_cd%TYPE,
        dsp_peril_sname2         giis_peril.peril_sname%TYPE,
        dsp_prt_flag             giis_peril.prt_flag%TYPE,
        line_cd                  giis_peril.line_cd%TYPE,
        peril_cd                 giis_peril.peril_cd%TYPE);

    TYPE peril_name_list_tab2 IS TABLE OF peril_name_list_type2;

  FUNCTION get_peril_name_list (p_line_cd        GIIS_PERIL.line_cd%TYPE,
                                     p_subline_cd  GIIS_SUBLINE.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED;

  FUNCTION get_peril_name_list2 (p_par_id       GIPI_PARLIST.par_id%TYPE,
                                      p_line_cd     GIIS_PERIL.line_cd%TYPE,
                                      p_subline_cd  GIIS_SUBLINE.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED;

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: CGFK$CV001_DSP_PERIL_NAME2
***********************************************************************************/

  FUNCTION get_basic_peril_list (p_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED;


/********************************** FUNCTION 4 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: PACK_BEN_CD
***********************************************************************************/

  FUNCTION get_grouped_peril_list (p_line_cd              GIIS_LINE.line_cd%TYPE,
                                        p_item_no              GIPI_WITMPERL_GROUPED.item_no%TYPE,
                                   p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                   p_grouped_item_no    GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE)
    RETURN peril_list_tab PIPELINED;


/********************************** FUNCTION 5 ************************************/

  FUNCTION get_item_peril_list (p_par_id    GIPI_WITMPERL.par_id%TYPE,
                                     p_line_cd      GIPI_WITMPERL.line_cd%TYPE,
                                   p_item_no      GIPI_WITMPERL.item_no%TYPE)
    RETURN peril_list_tab PIPELINED;


/********************************** FUNCTION 6 *************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: CGFK$B490_DSP_PERIL_NAME
***********************************************************************************/

  TYPE peril_name1_list_type IS RECORD
    (peril_name           GIIS_PERIL.peril_name%TYPE,
     peril_sname          GIIS_PERIL.peril_sname%TYPE,
     peril_type           GIIS_PERIL.peril_type%TYPE,
     basc_perl_cd         GIIS_PERIL.basc_perl_cd%TYPE,
     basic_peril          GIIS_PERIL.peril_sname%TYPE,
     prt_flag             GIIS_PERIL.prt_flag%TYPE,
      line_cd             GIIS_PERIL.line_cd%TYPE,
     peril_cd             GIIS_PERIL.peril_cd%TYPE,
     ri_comm_rt           GIIS_PERIL.ri_comm_rt%TYPE,
     wc_sw                VARCHAR2(1),
     tarf_cd              giis_peril_tariff.TARF_CD%TYPE,
     default_rate         GIIS_PERIL.default_rate%TYPE,
     default_tsi          GIIS_PERIL.default_tsi%TYPE);

  TYPE peril_name1_list_tab IS TABLE OF peril_name1_list_type;

  FUNCTION get_peril_name1_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE,
                                 p_par_id            GIPI_PARLIST.par_id%TYPE)
    RETURN peril_name1_list_tab PIPELINED;


/********************************** FUNCTION 7 *************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: ORIG_REC_GRP
***********************************************************************************/

  FUNCTION get_peril_name2_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE,
                                 p_par_id            GIPI_WITMPERL.par_id%TYPE,
                                 p_item_no            GIPI_WITMPERL.item_no%TYPE)
    RETURN peril_name1_list_tab PIPELINED;


/********************************** FUNCTION 8 *************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: CGFK$B490_DSP_PERIL_NAME2
***********************************************************************************/

  FUNCTION get_peril_name3_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name1_list_tab PIPELINED;


/********************************** FUNCTION 9 *************************************
  MODULE: GIIMM002
  RECORD GROUP NAME: RG_PERIL
***********************************************************************************/

  FUNCTION get_peril_name4_list (p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name1_list_tab PIPELINED;


/********************************** FUNCTION 10 ************************************/

  TYPE quote_peril_list IS RECORD
    (peril_cd             GIIS_PERIL.peril_cd%TYPE,
     peril_name           GIIS_PERIL.peril_name%TYPE);

  TYPE quote_peril_list_tab IS TABLE OF quote_peril_list;

  FUNCTION get_quote_peril_list (p_quote_id  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
                                 p_item_no   GIPI_QUOTE_ITMPERIL.item_no%TYPE)
    RETURN quote_peril_list_tab PIPELINED;


/********************************** FUNCTION 11 *************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: CG$DSP_PERIL_CD
***********************************************************************************/

  FUNCTION get_peril_name5_list (p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED;

  FUNCTION get_peril_name6_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name1_list_tab PIPELINED;

/********************************** FUNCTION 11 *************************************
  NOTE: Peril Deductible module uses this function - 01/25/2010 - mgcrobes
***********************************************************************************/

  FUNCTION get_witmperl_list (p_par_id    GIPI_WITMPERL.par_id%TYPE,
                                   p_line_cd      GIPI_WITMPERL.line_cd%TYPE)
    RETURN peril_list_tab PIPELINED;

/********************************** FUNCTION 12 *************************************
  NOTE: Selects the default perils for specific line_cd and subline_cd- 02/25/2010 - bjgabuluyan
***********************************************************************************/

  TYPE default_peril_list_type IS RECORD
    (peril_cd             GIIS_PERIL.peril_cd%TYPE,
     peril_name           GIIS_PERIL.peril_name%TYPE,
     line_cd              GIIS_PERIL.line_cd%TYPE,
     default_tsi          GIIS_PERIL.default_tsi%TYPE,
     default_rate          GIIS_PERIL.default_rate%TYPE,
     peril_type              GIIS_PERIL.peril_type%TYPE,
     ri_comm_rt             GIIS_PERIL.ri_comm_rt%TYPE);

  TYPE default_peril_list_tab IS TABLE OF default_peril_list_type;

  FUNCTION get_default_perils(p_line_cd            GIIS_PERIL.line_cd%TYPE,
                                   p_pack_line_cd    GIIS_PERIL.line_cd%TYPE,
                              p_nbt_subline_cd    GIIS_PERIL.subline_cd%TYPE,
                              p_pack_subline_cd GIIS_PERIL.subline_cd%TYPE)
    RETURN default_peril_list_tab PIPELINED;

  FUNCTION check_default_peril_exists(p_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                           p_line_cd         GIIS_PERIL.line_cd%TYPE)
    RETURN VARCHAR2;

  FUNCTION get_peril_name7_list (p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED;


  FUNCTION get_peril_list2 (p_line_cd  GIIS_LINE.line_cd%TYPE, p_subline_cd GIIS_SUBLINE.subline_cd%TYPE, p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN peril_list_tab PIPELINED;

  FUNCTION get_peril_name8_list (p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE,
                                 p_peril_type       GIIS_PERIL.peril_type%TYPE,
                                 p_find_text        VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED;

    FUNCTION get_peril_name_by_item_list (
        p_par_id IN gipi_witmperl.par_id%TYPE,
        p_item_no IN gipi_witmperl.item_no%TYPE,
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.subline_cd%TYPE,
        p_peril_type IN giis_peril.peril_type%TYPE,
        p_find_text IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED;


/**
* Rey Jadlocon
* 08.04.2011
* bill premium peril list
**/
TYPE peril_bill_list_type IS RECORD(
     peril_name         giis_peril.peril_name%TYPE,
     peril_cd           giis_peril.peril_cd%TYPE,
     prem_amt           gipi_polbasic.prem_amt%TYPE,
     tsi_amt            gipi_polbasic.tsi_amt%TYPE
     );

     TYPE peril_bill_list_tab IS TABLE OF peril_bill_list_type;

	FUNCTION get_peril_bill_list(
		p_policy_id    gipi_invoice.policy_id%TYPE,
		p_item_no	   gipi_item.item_no%TYPE,
		p_item_grp	   gipi_invoice.item_grp%TYPE
	)
      RETURN peril_bill_list_tab PIPELINED;

    FUNCTION get_beneficiary_peril_list (
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.line_cd%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED;

    FUNCTION get_grouped_peril_list1 (
        p_par_id IN gipi_wpolwc.par_id%TYPE,
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.line_cd%TYPE,
        p_peril_type IN giis_peril.peril_type%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED;

    FUNCTION get_peril_name9_list (
        p_line_cd       giis_peril.line_cd%TYPE,
        p_subline_cd    giis_peril.subline_cd%TYPE
    )
    RETURN peril_name_list_tab2 PIPELINED;

    FUNCTION get_itmperil_list (
      p_policy_id giex_itmperil.policy_id%TYPE, -- added by andrew - 1.11.2012
      p_item_no    giex_itmperil.item_no%TYPE)
    RETURN quote_peril_list_tab PIPELINED;

    TYPE item_peril_type IS RECORD (
        dsp_peril_name           GIIS_PERIL.peril_name%TYPE,
        dsp_peril_sname          GIIS_PERIL.peril_sname%TYPE,
        dsp_peril_type           GIIS_PERIL.peril_type%TYPE,
        dsp_basc_perl_cd         GIIS_PERIL.basc_perl_cd%TYPE,
        dsp_peril_name2          GIIS_PERIL.peril_name%TYPE,
        dsp_peril_sname2         GIIS_PERIL.peril_sname%TYPE,
        dsp_prt_flag             GIIS_PERIL.prt_flag%TYPE,
        line_cd                  GIIS_PERIL.line_cd%TYPE,
        peril_cd                 GIIS_PERIL.peril_cd%TYPE,
        default_tag              GIIS_PERIL.default_tag%TYPE,
        default_rate             GIIS_PERIL.default_rate%TYPE,
        default_tsi              GIIS_PERIL.default_tsi%TYPE,
        default_prem             NUMBER(16,2),
        warranty_flag            VARCHAR2(1)
    );
    TYPE item_peril_tab IS TABLE OF item_peril_type;

    FUNCTION get_item_peril_lov(
        p_quote_id              GIPI_QUOTE.quote_id%TYPE,
        p_line_cd               GIIS_PERIL.line_cd%TYPE,
        p_pack_line_cd          GIIS_PERIL.line_cd%TYPE,
        p_subline_cd            GIIS_PERIL.subline_cd%TYPE,
        p_pack_subline_cd       GIIS_PERIL.subline_cd%TYPE,
        p_peril_type            GIIS_PERIL.peril_type%TYPE,
        p_keyword               VARCHAR2
    )
      RETURN item_peril_tab PIPELINED;

    FUNCTION get_peril_name_list_gipis005(
        p_line_cd               GIIS_PERIL.line_cd%TYPE,
        p_subline_cd            GIIS_PERIL.subline_cd%TYPE,
        p_peril_type            GIIS_PERIL.peril_type%TYPE,
        p_find_text             VARCHAR2
    )
      RETURN peril_name_list_tab PIPELINED;

	FUNCTION get_grouped_peril_list2 (
        p_par_id IN gipi_wpolwc.par_id%TYPE,
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.line_cd%TYPE,
        p_peril_type IN giis_peril.peril_type%TYPE,
        p_peril_name IN VARCHAR2)
      RETURN peril_name_list_tab1 PIPELINED;

    /*Created by : Gzelle
    **Date : 09092014
    **Description : Retrieve Package Plan peril details
    **Reference : When-New-Form-Instance trigger
    */
    TYPE pack_plan_type IS RECORD (
       par_id   gipi_wpolbas.par_id%TYPE,
       /*item_no*/
       line_cd  giis_plan_dtl.line_cd%TYPE,
       peril_cd giis_plan_dtl.peril_cd%TYPE,
       peril_name   giis_peril.peril_name%TYPE,
       peril_type   giis_peril.peril_type%TYPE,
       tarf_cd  NUMBER,
       prem_rt  giis_plan_dtl.prem_rt%TYPE,
       tsi_amt  giis_plan_dtl.tsi_amt%TYPE,
       prem_amt giis_plan_dtl.prem_amt%TYPE,
       ann_tsi_amt  giis_plan_dtl.tsi_amt%TYPE,
       ann_prem_amt giis_plan_dtl.tsi_amt%TYPE,
       rec_flag VARCHAR2(100),
       comp_Rem VARCHAR2(100),
       discount_sw  gipi_wpolbas.discount_sw%TYPE,
       prt_flag   giis_peril.prt_flag%TYPE,
       ri_comm_rt   giis_peril.ri_comm_rt%TYPE,
       ri_comm_amt giis_plan_dtl.tsi_amt%TYPE,
       as_charge_sw VARCHAR2(100),
       surcharge_sw gipi_wpolbas.surcharge_sw%TYPE,
       no_of_days   giis_plan_dtl.no_of_days%TYPE,
       base_amt giis_plan_dtl.base_amt%TYPE,
       aggregate_sw giis_plan_dtl.aggregate_sw%TYPE,
       basc_perl_cd giis_peril.basc_perl_cd%TYPE,
       record_status NUMBER
    );
    TYPE pack_plan_tab IS TABLE OF pack_plan_type;

    FUNCTION get_pack_plan_perils(
        p_par_id gipi_wpolbas.par_id%TYPE
    )
    	RETURN pack_plan_tab PIPELINED;

    /*Created by : Gzelle
    **Date : 11242014
    **Description : Retrieve default tsi and premium amts
    **Reference : BP-001-00002 Creating a MOTORCAR policy BR-010A
    */
    FUNCTION get_default_peril_amts(
        p_par_id            gipi_wpolbas.par_id%TYPE,
        p_line_cd           giis_tariff_rates_hdr.line_cd%TYPE,
        p_subline_cd        giis_tariff_rates_hdr.subline_cd%TYPE,
        p_peril_cd          giis_tariff_rates_hdr.peril_cd%TYPE,
        p_tsi_amt           giis_tariff_rates_dtl.fixed_si%TYPE,
        p_coverage_cd       giis_tariff_rates_hdr.coverage_cd%TYPE,
        p_subline_type_cd   giis_tariff_rates_hdr.subline_type_cd%TYPE,
        p_motortype_cd      giis_tariff_rates_hdr.motortype_cd%TYPE,
        p_tariff_zone       giis_tariff_rates_hdr.tariff_zone%TYPE,
        p_tarf_cd           giis_tariff_rates_hdr.tarf_cd%TYPE,
        p_construction_cd   giis_tariff_rates_hdr.construction_cd%TYPE
    )
    	RETURN VARCHAR2;

    /*Created by : Gzelle
    **Date : 12012014
    **Description : Check if perils based on tariff exists
    **Reference : BP-001-00002 Creating a MOTORCAR policy BR-010A
    */
    FUNCTION check_tariff_peril_exists(
        p_par_id            gipi_wpolbas.par_id%TYPE,
        p_item_no           gipi_witem.item_no%TYPE,
        p_line_cd           giis_tariff_rates_hdr.line_cd%TYPE,
        p_subline_cd        giis_tariff_rates_hdr.subline_cd%TYPE
    )
    	RETURN VARCHAR2;

    /*Created by : Gzelle
    **Date : 12022014
    **Description : Delete peril information for modified item info
    **Reference : BP-001-00002 Creating a MOTORCAR policy BR-010A
    */
   PROCEDURE del_gipi_witmperl_tariff (
      p_par_id     IN   gipi_witmperl.par_id%TYPE,
      p_item_no    IN   gipi_witmperl.item_no%TYPE,
      p_line_cd    IN   gipi_witmperl.line_cd%TYPE,
      p_subline_cd IN   giis_tariff_rates_hdr.subline_cd%TYPE
   );


    /*Created by : Gzelle
    **Date : 05062015
    **Description : Checks if item peril has maintained zone type
    **Reference : BP-001-00001 Creating a FIRE policy BR-010Q BP-001-00002 Endorsement of FIRE policy BR-023N [SR4347]
    */        
    FUNCTION check_peril_zone_type(
        p_par_id    gipi_witmperl.par_id%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE,
        p_line_cd   giis_peril.line_cd%TYPE,
        p_peril_cd  giis_peril.peril_cd%TYPE
    )
    	RETURN VARCHAR2;  
    	
END Giis_Peril_Pkg;
/


