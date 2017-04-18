DROP PROCEDURE CPI.POST_TEXT_TSI_AMT_GIPIS038;

CREATE OR REPLACE PROCEDURE CPI.POST_TEXT_TSI_AMT_GIPIS038(
  p_par_id		  IN  GIPI_PARLIST.par_id%TYPE,
  p_item_no		  IN  GIPI_WITEM.item_no%TYPE,
  p_peril_cd	  IN  GIPI_WITMPERL.peril_cd%TYPE,
  p_prem_rt		  IN  GIPI_WITMPERL.prem_rt%TYPE,
  p_tsi_amt		  IN  GIPI_WITMPERL.tsi_amt%TYPE,
  p_prem_amt	  IN  GIPI_WITMPERL.prem_amt%TYPE,
  p_ann_tsi_amt   IN  GIPI_WITMPERL.ann_tsi_amt%TYPE,
  p_ann_prem_amt  IN  GIPI_WITMPERL.ann_prem_amt%TYPE,
  i_tsi_amt       IN  GIPI_WITEM.tsi_amt%TYPE ,
  i_prem_amt      IN  GIPI_WITEM.prem_amt%TYPE,
  i_ann_tsi_amt   IN  GIPI_WITEM.ann_tsi_amt%TYPE,
  i_ann_prem_amt  IN  GIPI_WITEM.ann_prem_amt%TYPE,
  v_peril_prem_amt     OUT NUMBER,
  v_peril_ann_prem_amt OUT NUMBER,
  v_peril_ann_tsi_amt  OUT NUMBER,
  v_item_prem_amt	   OUT NUMBER,
  v_item_ann_prem_amt  OUT NUMBER,
  v_item_tsi_amt	   OUT NUMBER,
  v_item_ann_tsi_amt   OUT NUMBER,
  v_peril_tsi_amt      OUT NUMBER
  )
  IS

  tarf_sw               VARCHAR2(1) := 'N';
  v_prem_tag    		giis_tariff_rates_hdr.default_prem_tag%TYPE;
  v_tariff_cd   		giis_tariff_rates_hdr.tariff_cd%TYPE;
  v_fixed_prem  		giis_tariff_rates_dtl.fixed_premium%TYPE;
  v_nbt_tsi				NUMBER := p_tsi_amt;
  v_tsi					NUMBER := p_tsi_amt;
  v_tariff_sw			gipi_wpolbas.with_tariff_sw%TYPE;
  v_prov_prem_tag		gipi_wpolbas.prov_prem_tag%TYPE;
  v_line_cd				gipi_parlist.line_cd%TYPE;
  v_iss_cd				gipi_parlist.iss_cd%TYPE;
  v_subline_cd			gipi_wpolbas.subline_cd%TYPE;
  v_prorate_flag		gipi_wpolbas.prorate_flag%TYPE;
  v_prov_prem_pct		gipi_wpolbas.prov_prem_pct%TYPE;
  v_coverage_cd			gipi_witem.coverage_cd%TYPE;
  line_motor			giis_parameters.param_value_v%TYPE;
  line_fire				giis_parameters.param_value_v%TYPE;
  param_name1			VARCHAR2(5);


BEGIN

  BEGIN
    SELECT line_cd
	  INTO v_line_cd
	  FROM GIPI_PARLIST
	 WHERE par_id = p_par_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  BEGIN
    SELECT with_tariff_sw, prov_prem_tag, subline_cd, prorate_flag, prov_prem_pct
	  INTO v_tariff_sw, v_prov_prem_tag, v_subline_cd, v_prorate_flag, v_prov_prem_pct
	  FROM GIPI_WPOLBAS
	 WHERE par_id = p_par_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  BEGIN
    SELECT param_value_v
	  INTO line_motor
      FROM giis_parameters
     WHERE param_name = 'MOTOR CAR';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  BEGIN
    SELECT param_value_v
	  INTO line_fire
      FROM giis_parameters
     WHERE param_name = 'FIRE';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  BEGIN
    SELECT coverage_cd
	  INTO v_coverage_cd
      FROM gipi_witem
     WHERE par_id = p_par_id
	   AND item_no = p_item_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  --IF :system.record_status != 'QUERY' THEN

        IF NVL(p_prem_rt ,0) = 0 AND NVL(v_tariff_sw,'N') = 'Y'
   	       AND nvl(v_prov_prem_tag , 'N')= 'N' THEN
   	       IF v_line_cd = line_motor THEN
   	  	      FOR CHK1 IN
   	  	        ( SELECT a.default_prem_tag, a.tariff_cd
   	  	            FROM giis_tariff_rates_hdr a, gipi_wvehicle b
   	  	           WHERE a.motortype_cd          = b.mot_type
   	  	             AND a.subline_type_cd       = b.subline_type_cd
   	  	             AND NVL(a.tariff_zone,'##') = NVL(b.tariff_zone,'##')
   	  	             AND a.coverage_cd           = v_coverage_cd
   	  	             AND a.line_cd               = v_line_cd
   	  	             AND a.subline_cd            = v_subline_cd
   	  	             AND a.peril_cd              = p_peril_cd
   	  	             AND b.item_no               = p_item_no
   	  	             AND b.par_id                = p_par_id
   	  	        ) LOOP
   	  	        v_prem_tag   := chk1.default_prem_tag;
   	  	        --tarf_sw      := 'Y';
   	  	        v_tariff_cd  := chk1.tariff_cd;
   	  	      END LOOP;
   	       ELSIF v_line_cd = line_fire THEN
   	  	      FOR CHK2 IN
   	  	        ( SELECT a.default_prem_tag, a.tariff_cd
   	  	            FROM giis_tariff_rates_hdr a, gipi_wfireitm b
   	  	           WHERE NVL(a.tarf_cd,'##')       = NVL(b.tarf_cd,'##')
   	  	             AND NVL(a.construction_cd,'##') = NVL(b.construction_cd, '##')
   	  	             AND NVL(a.tariff_zone,'##')     = NVL(b.tariff_zone,'##')
   	  	             AND a.line_cd               = v_line_cd
   	  	             AND a.subline_cd            = v_subline_cd
   	  	             AND a.peril_cd              = p_peril_cd
   	  	             AND b.par_id                = p_par_id
   	  	             AND b.item_no               = p_item_no
   	  	        ) LOOP
                v_prem_tag := chk2.default_prem_tag;
                --tarf_sw    := 'Y';
                v_tariff_cd  := chk2.tariff_cd;
   	  	      END LOOP;
   	       END IF;
   	       IF v_prem_tag = '1' THEN
   	  	      tarf_sw := 'N';
   	  	      FOR FIX IN
   	  	        ( SELECT fixed_premium
   	  	            FROM giis_tariff_rates_dtl
   	  	           WHERE fixed_si   = p_tsi_amt
   	  	             AND tariff_cd  = v_tariff_cd
   	  	        ) LOOP
   	            --v_fixed_prem := NVL(fix.fixed_premium,0);
   	            tarf_sw := 'Y';
   	          END LOOP;
           END IF;
        END IF;

        IF NVL(tarf_sw,'N') = 'Y' and v_prorate_flag = '2' THEN
          COMPUTE_TARF(v_tsi, p_prem_rt, p_ann_tsi_amt, p_ann_prem_amt, i_tsi_amt,
                          i_prem_amt, i_ann_tsi_amt, i_ann_prem_amt, v_tariff_cd, v_prem_tag,
                       v_fixed_prem, p_prem_amt, p_peril_cd, p_par_id, v_peril_prem_amt, v_peril_ann_prem_amt,
                       v_peril_ann_tsi_amt, v_item_prem_amt, v_item_ann_prem_amt, v_item_tsi_amt, v_item_ann_tsi_amt
                       );
        ELSIF NVL(tarf_sw,'N') = 'Y' AND v_prorate_flag in ('1','3') THEN null;
          COMPUTE_TARF_PRORATE(v_tsi, p_prem_rt, p_ann_tsi_amt, p_ann_prem_amt, i_tsi_amt,
                          i_prem_amt, i_ann_tsi_amt, i_ann_prem_amt, v_tariff_cd, v_prem_tag,
                       v_fixed_prem, p_prem_amt, p_peril_cd, p_par_id, v_peril_prem_amt,
                       v_peril_ann_prem_amt, v_peril_ann_tsi_amt, v_item_prem_amt, v_item_ann_prem_amt, v_item_tsi_amt,
                       v_item_ann_tsi_amt
                       );
        ELSE
          COMPUTE_TSI_PERIL(v_tsi, p_prem_rt, p_ann_tsi_amt, p_ann_prem_amt, i_tsi_amt,
                        i_prem_amt, i_ann_tsi_amt, i_ann_prem_amt, v_prov_prem_pct, v_prov_prem_tag,
                        p_prem_amt, p_peril_cd, p_par_id, p_item_no, v_peril_prem_amt,
                        v_peril_ann_prem_amt, v_peril_ann_tsi_amt, v_item_prem_amt, v_item_ann_prem_amt, v_item_tsi_amt,
                        v_item_ann_tsi_amt);
        END IF;

        FOR A IN (SELECT  param_name  FROM giis_parameters
                   WHERE  param_value_v = 'RI'
                     AND  param_name    = v_iss_cd)
        LOOP
          param_name1  :=  'RI';
          EXIT;
        END LOOP;

        IF param_name1  =  'RI' THEN
           NULL;--:b490.ri_comm_amt  :=  NVL(:b490.ri_comm_rate,0) * NVL(:b490.prem_amt,0) / 100;
        END IF;

        v_peril_prem_amt     := v_peril_prem_amt;
        v_peril_ann_prem_amt := v_peril_ann_prem_amt;
        v_peril_ann_tsi_amt     := v_peril_ann_tsi_amt;
        v_item_prem_amt         := v_item_prem_amt;
        v_item_ann_prem_amt     := v_item_ann_prem_amt;
        v_item_tsi_amt         := v_item_tsi_amt;
        v_item_ann_tsi_amt     := v_item_ann_tsi_amt;
        v_peril_tsi_amt      := v_tsi;
  --END IF;
  --:parameter.tsi_sw := 'N';

END POST_TEXT_TSI_AMT_GIPIS038;
/


