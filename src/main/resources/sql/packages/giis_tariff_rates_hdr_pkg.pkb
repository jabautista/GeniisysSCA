CREATE OR REPLACE PACKAGE BODY CPI.GIIS_TARIFF_RATES_HDR_PKG AS

  FUNCTION get_tariff_details_mc(p_coverage_cd           giis_tariff_rates_hdr.COVERAGE_CD%TYPE,
   	  	             			 p_line_cd               giis_tariff_rates_hdr.LINE_CD%TYPE,
   	  	             			 p_subline_cd            giis_tariff_rates_hdr.SUBLINE_CD%TYPE,
   	  	             			 p_peril_cd              giis_tariff_rates_hdr.PERIL_CD%TYPE,
   	  	             			 p_item_no               gipi_wvehicle.ITEM_NO%TYPE,
   	  	             			 p_par_id                gipi_wvehicle.par_id%TYPE)
	RETURN tariff_rates_hdr_tab PIPELINED IS
	v_tarf tariff_rates_hdr_type;
  BEGIN
    FOR i IN (SELECT a.default_prem_tag, a.tariff_cd
   	  	        FROM giis_tariff_rates_hdr a, gipi_wvehicle b
   	  	       WHERE a.motortype_cd          = b.mot_type
   	  	         AND a.subline_type_cd       = b.subline_type_cd
   	  	         AND NVL(a.tariff_zone,'##') = NVL(b.tariff_zone,'##')
   	  	         AND a.coverage_cd           = p_coverage_cd
   	  	         AND a.line_cd               = p_line_cd
   	  	         AND a.subline_cd            = p_subline_cd
   	  	         AND a.peril_cd              = p_peril_cd
   	  	         AND b.item_no               = p_item_no
   	  	         AND b.par_id                = p_par_id)
	LOOP
	  v_tarf.prem_tag     := i.default_prem_tag;
   	  v_tarf.tarf_sw      := 'Y';
   	  v_tarf.tariff_cd    := i.tariff_cd;
	  PIPE ROW(v_tarf);
	END LOOP;
	RETURN;
  END get_tariff_details_mc;

  FUNCTION get_tariff_details_fi(p_line_cd               giis_tariff_rates_hdr.LINE_CD%TYPE,
   	  	             			 p_subline_cd            giis_tariff_rates_hdr.SUBLINE_CD%TYPE,
   	  	             			 p_peril_cd              giis_tariff_rates_hdr.PERIL_CD%TYPE,
   	  	             			 p_item_no               gipi_wvehicle.ITEM_NO%TYPE,
   	  	             			 p_par_id                gipi_wvehicle.par_id%TYPE)
	RETURN tariff_rates_hdr_tab PIPELINED IS
	v_tarf tariff_rates_hdr_type;
  BEGIN
    FOR i IN (SELECT a.default_prem_tag, a.tariff_cd
   	  	            FROM giis_tariff_rates_hdr a, gipi_wfireitm b
   	  	           WHERE NVL(a.tarf_cd,'##')         = NVL(b.tarf_cd,'##')
   	  	             AND NVL(a.construction_cd,'##') = NVL(b.construction_cd, '##')
   	  	             AND NVL(a.tariff_zone,'##')     = NVL(b.tariff_zone,'##')
   	  	             AND a.line_cd               	 = p_line_cd
   	  	             AND a.subline_cd            	 = p_subline_cd
   	  	             AND a.peril_cd              	 = p_peril_cd
   	  	             AND b.par_id                	 = p_par_id
   	  	             AND b.item_no               	 = p_item_no)
	LOOP
	  v_tarf.prem_tag     := i.default_prem_tag;
   	  v_tarf.tarf_sw      := 'Y';
   	  v_tarf.tariff_cd    := i.tariff_cd;
	  PIPE ROW(v_tarf);
	END LOOP;
	RETURN;
  END get_tariff_details_fi;

END GIIS_TARIFF_RATES_HDR_PKG;
/


