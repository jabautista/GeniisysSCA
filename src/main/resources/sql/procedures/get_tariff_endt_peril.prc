DROP PROCEDURE CPI.GET_TARIFF_ENDT_PERIL;

CREATE OR REPLACE PROCEDURE CPI.GET_TARIFF_ENDT_PERIL (p_par_id            IN GIPI_WITMPERL.par_id%TYPE,
                                                       p_item_no           IN GIPI_WITMPERL.item_no%TYPE,
                                                       p_peril_cd          IN GIPI_WITMPERL.peril_cd%TYPE,      
                                                       p_tsi_amt           IN OUT GIPI_WITMPERL.tsi_amt%TYPE,
                                                       p_prem_amt          IN OUT GIPI_WITMPERL.prem_amt%TYPE) 
IS
/*
**  Created by    : Menandro G.C. Robes
**  Date Created  : June 4, 2010
**  Reference By  : (GIPIS097 - Endorsement Item Peril Information)
**  Description   : Procedure to retrieve tariff value. 
*/ 
  v_prem_tag            giis_tariff_rates_hdr.default_prem_tag%TYPE;
  v_tariff_cd           giis_tariff_rates_hdr.tariff_cd%TYPE;
  v_fixed_prem          giis_tariff_rates_dtl.fixed_premium%TYPE;                            
  v_tarf_sw             VARCHAR2(1) := 'N';                      

  v2_line_cd            GIPI_WPOLBAS.line_cd%TYPE;
  v2_subline_cd         GIPI_WPOLBAS.subline_cd%TYPE;  
  v3_coverage_cd        GIPI_WITEM.coverage_cd%TYPE;
  
  var_motor_type        GIPI_VEHICLE.mot_type%TYPE;
  var_subline_type_cd   GIPI_VEHICLE.subline_type_cd%TYPE;
  var_mc_tariff_zone    GIPI_VEHICLE.tariff_zone%TYPE;
  var_fi_tariff_zone    GIPI_FIREITEM.tariff_zone%TYPE;
  var_tarf_cd           GIPI_FIREITEM.tarf_cd%TYPE;
  var_construction_cd   GIPI_FIREITEM.construction_cd%TYPE;
  var_line_motor        GIIS_PARAMETERS.param_value_v%TYPE;
  var_line_fire         GIIS_PARAMETERS.param_value_v%TYPE;
  
BEGIN
  var_line_motor    := GIIS_PARAMETERS_PKG.v('MOTOR CAR');
  var_line_fire     := GIIS_PARAMETERS_PKG.v('FIRE');    

  FOR a2 IN (
    SELECT line_cd, subline_cd, prorate_flag, prov_prem_pct, prov_prem_tag, with_tariff_sw
      FROM GIPI_WPOLBAS
     WHERE par_id = p_par_id)
  LOOP
    v2_line_cd          := a2.line_cd;
    v2_subline_cd       := a2.subline_cd;  
  END LOOP;

  FOR a3 IN (
    SELECT pack_line_cd, coverage_cd
      FROM GIPI_WITEM
     WHERE par_id  = p_par_id
       AND item_no = p_item_no)
  LOOP
    v3_coverage_cd  := a3.coverage_cd;
  END LOOP;
    
  IF v2_line_cd = var_line_motor THEN
    var_motor_type      := GIPI_VEHICLE_PKG.get_mot_type(p_par_id, p_item_no);
    var_subline_type_cd := GIPI_VEHICLE_PKG.get_subline_type_cd(p_par_id, p_item_no);
    var_mc_tariff_zone  := GIPI_VEHICLE_PKG.get_mc_tariff_zone(p_par_id, p_item_no);
        
    FOR CHK1 IN ( 
      SELECT a.default_prem_tag, a.tariff_cd
        FROM giis_tariff_rates_hdr a, 
             gipi_wvehicle b
       WHERE a.motortype_cd          = nvl(b.mot_type, var_motor_type)
         AND a.subline_type_cd       = nvl(b.subline_type_cd, var_subline_type_cd)
         AND NVL(a.tariff_zone,'##') = NVL(b.tariff_zone,NVL(var_mc_tariff_zone,'##'))
         AND a.coverage_cd           = v3_coverage_cd
         AND a.line_cd               = v2_line_cd
         AND a.subline_cd            = v2_subline_cd
         AND a.peril_cd              = p_peril_cd
         AND b.item_no               = p_item_no
         AND b.par_id                = p_par_id) 
    LOOP                           
      v_prem_tag   := chk1.default_prem_tag;
      v_tarf_sw    := 'Y';
      v_tariff_cd  := chk1.tariff_cd;
    END LOOP;
        
  ELSIF v2_line_cd = var_line_fire THEN         
    var_tarf_cd         := GIPI_FIREITEM_PKG.get_tarf_cd (p_par_id, p_item_no);
    var_construction_cd := GIPI_FIREITEM_PKG.get_construction_cd (p_par_id, p_item_no);
    var_fi_tariff_zone  := GIPI_FIREITEM_PKG.get_fi_tariff_zone (p_par_id, p_item_no);
        
    FOR CHK2 IN ( 
      SELECT a.default_prem_tag, a.tariff_cd
        FROM giis_tariff_rates_hdr a, gipi_wfireitm b
       WHERE NVL(a.tarf_cd,'##')         = NVL(b.tarf_cd,nvl(var_tarf_cd,'##'))
         AND NVL(a.construction_cd,'##') = NVL(b.construction_cd, nvl(var_construction_cd,'##'))
         AND NVL(a.tariff_zone,'##')     = NVL(b.tariff_zone,nvl(var_fi_tariff_zone,'##'))
         AND a.line_cd                   = v2_line_cd
         AND a.subline_cd                = v2_subline_cd
         AND a.peril_cd                  = p_peril_cd
         AND b.par_id                    = p_par_id
         AND b.item_no                   = p_item_no) 
    LOOP
      v_prem_tag := chk2.default_prem_tag;
      v_tarf_sw    := 'Y';
      v_tariff_cd  := chk2.tariff_cd;
    END LOOP;
  END IF;

  IF v_prem_tag = '1' THEN
    v_tarf_sw := 'N';
        
    FOR FIX IN ( 
      SELECT fixed_premium
        FROM giis_tariff_rates_dtl
       WHERE fixed_si   = p_tsi_amt
         AND tariff_cd  = v_tariff_cd) 
    LOOP
      v_fixed_prem := NVL(fix.fixed_premium,0);
      v_tarf_sw := 'Y';
    END LOOP;
  END IF; 

  IF NVL(v_tarf_sw, 'N') = 'Y' THEN  
    compute_tarf_endt_peril(p_tsi_amt, p_prem_amt, v_tariff_cd, v_prem_tag, v_fixed_prem);
  END IF;       
 
END;
/


