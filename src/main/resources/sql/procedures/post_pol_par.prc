DROP PROCEDURE CPI.POST_POL_PAR;

CREATE OR REPLACE PROCEDURE CPI.post_pol_par(
                       p_par_id             IN  GIPI_PARLIST.par_id%TYPE,
                  p_line_cd            IN  GIPI_PARLIST.line_cd%TYPE,
                  p_iss_cd          IN  GIPI_PARLIST.iss_cd%TYPE,
                  p_user_id         IN  VARCHAR2,
                  p_change_stat     IN OUT VARCHAR2,    
                  p_policy_id       OUT GIPI_POLBASIC.policy_id%TYPE,
                  p_pack_policy_id  IN  VARCHAR2,
                  p_msg_alert       OUT VARCHAR2,
                  p_out_user_id     OUT VARCHAR2,
                  p_prem_seq_no     OUT VARCHAR2,
                  p_module_id       GIIS_MODULES.module_id%TYPE DEFAULT NULL
                       )
        IS
 v_menu_ln_cd        GIIS_LINE.menu_line_cd%TYPE;
 v_policy_id         GIPI_POLBASIC.policy_id%TYPE;
 v_msg_alert         VARCHAR2(2000);
 v_par_type          GIPI_PARLIST.par_type%TYPE;
 v_issue_ri          GIIS_PARAMETERS.param_value_v%TYPE :=  Giisp.v('ISS_CD_RI');
 v_pack              GIPI_WPOLBAS.pack_pol_flag%TYPE;
 v_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE;
 v_cargo_cd          GIIS_PARAMETERS.param_value_v%TYPE;
 v_accident_cd       GIIS_PARAMETERS.param_value_v%TYPE;
 v_casualty_cd       GIIS_PARAMETERS.param_value_v%TYPE;
 v_engrng_cd         GIIS_PARAMETERS.param_value_v%TYPE;
 v_fire_cd           GIIS_PARAMETERS.param_value_v%TYPE;
 v_motor_cd          GIIS_PARAMETERS.param_value_v%TYPE;
 v_surety_cd         GIIS_PARAMETERS.param_value_v%TYPE;
 v_hull_cd           GIIS_PARAMETERS.param_value_v%TYPE;
 v_aviation_cd       GIIS_PARAMETERS.param_value_v%TYPE;
 v_open_flag         GIIS_SUBLINE.op_flag%TYPE;
 v_open_policy_sw    GIIS_SUBLINE.open_policy_sw%TYPE;
 v_bpv               GIIS_PARAMETERS.param_name%TYPE := 'BOILER_AND_PRESSURE_VESSEL';
 v_subline_bpv       GIIS_PARAMETERS.param_value_v%TYPE;
 v_change_stat       VARCHAR2(200) := p_change_stat;
 v_prem_seq_no       VARCHAR2(32000);
BEGIN
  FOR a IN (SELECT par_type
                  FROM GIPI_PARLIST
             WHERE par_id = p_par_id)
  LOOP
    v_par_type := a.par_type;
  END LOOP;
  
  FOR b IN (SELECT pack_pol_flag,subline_cd
                  FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id)
  LOOP
    v_pack           := b.pack_pol_flag;
    v_subline_cd     := b.subline_cd;
  END LOOP;
  
  FOR c IN (SELECT op_flag,open_policy_sw
                FROM GIIS_SUBLINE
             WHERE line_cd    = p_line_cd 
               AND subline_cd = v_subline_cd)
  LOOP
     v_open_flag        := c.op_flag;
     v_open_policy_sw   := c.open_policy_sw;
  END LOOP; 
  
  FOR d IN (SELECT a.param_value_v cargo, b.param_value_v acc,  c.param_value_v ca,
                          d.param_value_v eng,      e.param_value_v fire, f.param_value_v motor,
                   g.param_value_v su,      h.param_value_v hull, i.param_value_v av     
              FROM GIIS_PARAMETERS A,GIIS_PARAMETERS B,GIIS_PARAMETERS C,
                   GIIS_PARAMETERS D,GIIS_PARAMETERS E,GIIS_PARAMETERS F,
                   GIIS_PARAMETERS G,GIIS_PARAMETERS H,GIIS_PARAMETERS I
             WHERE a.param_name = 'LINE_CODE_MN'
               AND b.param_name = 'LINE_CODE_AC'
               AND c.param_name = 'LINE_CODE_CA'
               AND d.param_name = 'LINE_CODE_EN'
               AND e.param_name = 'LINE_CODE_FI'
               AND f.param_name = 'LINE_CODE_MC'
               AND g.param_name = 'LINE_CODE_SU'
               AND h.param_name = 'LINE_CODE_MH'
               AND i.param_name = 'LINE_CODE_AV')
  LOOP
    v_cargo_cd     := d.cargo;
    v_accident_cd  := d.acc;
    v_casualty_cd  := d.ca;
    v_engrng_cd    := d.eng;
    v_fire_cd      := d.fire;
    v_motor_cd     := d.motor;
    v_surety_cd    := d.su;
    v_hull_cd      := d.hull;
    v_aviation_cd  := d.av;
  END LOOP; 
  
  IF v_msg_alert IS NULL THEN
    v_change_stat := p_change_stat;
    Copy_Pol_Wpolbas(p_par_id,p_line_cd,p_iss_cd,v_par_type,p_user_id,v_policy_id, p_pack_policy_id,v_change_stat,v_msg_alert);
    p_change_stat := v_change_stat; 
  END IF; 
  IF v_msg_alert IS NULL THEN
    Copy_Pol_Wpolgenin(p_par_id,v_policy_id,v_msg_alert);
  END IF;
  Copy_Pol_Wpolnrep(p_par_id,v_policy_id);
  UPDATE_GIRI_BINDER_POLICYID(p_par_id,v_policy_id); --Added by clperello | 04.01.14
  
 -- msg_alert(:postpar.iss_cd||' - '||variables.issue_ri||' - '||variables.open_flag,'I',TRUE);
  IF p_iss_cd = v_issue_ri THEN
     Copy_Pol_Winpolbas(p_par_id,v_policy_id);
  END IF;
  IF v_pack = 'Y' THEN
     Copy_Pol_Wpack_Line_Subline(p_par_id,v_policy_id);
  END IF;  
  IF v_pack = 'Y' THEN
    FOR A IN (SELECT   a.pack_line_cd line_cd, a.pack_subline_cd subline_cd,
                       b.item_no
                FROM   GIPI_WPACK_LINE_SUBLINE a, GIPI_WITEM b
               WHERE   a.pack_subline_cd = b.pack_subline_cd
                 AND   a.pack_line_cd    = b.pack_line_cd
                 AND   a.par_id          = b.par_id
                 AND   a.par_id          =  p_par_id) LOOP
          v_menu_ln_cd := NULL;           
          FOR menu_line IN ( SELECT menu_line_cd code
                               FROM GIIS_LINE
                              WHERE line_cd = A.line_cd )
          LOOP
                v_menu_ln_cd := menu_line.code;
                --variables.v_menu_ln_cd  := menu_line.code; --issa@fpac08.14.2006 --4 package
          END LOOP;                     
      IF (v_menu_ln_cd = 'MN' OR A.line_cd = v_cargo_cd)AND v_open_flag = 'Y' THEN
         NULL;
      ELSE
         IF A.line_cd != v_accident_cd THEN
--           copy_pol_winspection; -- 081699 Commented by loth table has been dropped
           Copy_Pol_Wlim_Liab(p_par_id,v_policy_id);
         END IF;        
         Copy_Pol_Witem2(A.line_cd,A.subline_cd,p_par_id,v_policy_id);
      END IF;
      IF (v_menu_ln_cd = 'AC' OR A.line_cd = v_accident_cd) THEN
         Copy_Pol_Wbeneficiary(p_par_id,v_policy_id);
         Copy_Pol_Waccident_Item(p_par_id,v_policy_id);  -- ramil 09/03/96
         Copy_Pol_Wgroup_Pack_Item(a.item_no,p_par_id,v_policy_id);     -- beth 11/05/98 loth 080499
         Copy_Pol_Wgrp_Pack_Item_Ben(a.item_no,p_par_id,v_policy_id);   -- grace 05/15/00
         Copy_Pol_Witmperl_Pack_Grouped(a.item_no,p_par_id,v_policy_id); --gmi 09/20/05
         Copy_Pol_Witmperl_Pack_Ben(a.item_no,p_par_id,v_policy_id); --gmi 09/20/05
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);
      ELSIF (v_menu_ln_cd = 'CA' OR A.line_cd = v_casualty_cd) THEN
         Copy_Pol_Wbank_Sched(p_par_id,v_policy_id);
         Copy_Pol_Wcasualty_Item(p_par_id,v_policy_id);
         Copy_Pol_Wcasualty_Personnel(p_par_id,v_policy_id);
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);
         Copy_Pol_Wgroup_Pack_Item(a.item_no,p_par_id,v_policy_id);     -- beth 11/05/98 loth 080499
         Copy_Pol_Wgrp_Pack_Item_Ben(a.item_no,p_par_id,v_policy_id);   -- grace 05/15/00
         Copy_Pol_Witmperl_Pack_Grouped(a.item_no,p_par_id,v_policy_id); --gmi 09/20/05
         Copy_Pol_Witmperl_Pack_Ben(a.item_no,p_par_id,v_policy_id); --gmi 09/20/05
      ELSIF (v_menu_ln_cd = 'EN' OR A.line_cd = v_engrng_cd) THEN
         Copy_Pol_Wengg_Basic(p_par_id,v_policy_id);
         Copy_Pol_Wprincipal(p_par_id,v_policy_id);
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);
         BEGIN
           SELECT param_value_v
             INTO v_subline_bpv
             FROM GIIS_PARAMETERS
            WHERE param_name = v_bpv;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --gipis207_pkg.pre_post_error2(p_par_id, 'No record in giis_parameters for engrng. subline '||v_subline_cd,p_module_id);
                --p_msg_alert := 'No record in giis_parameters for engrng. subline '||v_subline_cd; replaced by Kenenth L. 02.17.2014
                IF p_module_id = 'GIPIS207'
                THEN
                   gipis207_pkg.pre_post_error2(p_par_id, 'No record in giis_parameters for engrng. subline '||v_subline_cd,p_module_id);   
                   p_msg_alert := 'Y';  
                ELSE
                   p_msg_alert := 'No record in giis_parameters for engrng. subline '||v_subline_cd;
                END IF;
         END;
         IF A.subline_cd = v_subline_bpv THEN
            Copy_Pol_Wlocation(p_par_id,v_policy_id);
         END IF;
      ELSIF (v_menu_ln_cd = 'FI' OR A.line_cd = v_fire_cd) THEN
         IF v_msg_alert IS NULL THEN
           Check_Zone_Type(p_par_id,p_line_cd,v_msg_alert); -- Grace 02/13/2001
         END IF;
         Copy_Pol_Wfire(p_par_id,v_policy_id);
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);
      ELSIF (v_menu_ln_cd = 'MC' OR A.line_cd = v_motor_cd) THEN
         Copy_Pol_Wvehicle(p_par_id,v_policy_id);
         Copy_Pol_Wmcacc(p_par_id,v_policy_id);
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);     -- beth 11/05/98
      ELSIF (v_menu_ln_cd = 'SU' OR A.line_cd = v_surety_cd)  THEN
         Copy_Pol_Wbond_Basic(p_par_id,v_policy_id);
         Copy_Pol_Wcosigntry(p_par_id,v_policy_id);
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);
         Update_Collateral_Par(p_par_id,v_policy_id);
      ELSIF v_menu_ln_cd IN ('MH','MN','AV') OR (A.line_cd IN
           (v_hull_cd,v_cargo_cd,v_aviation_cd)) THEN
         Copy_Pol_Wcargo_Hull(A.line_cd,A.subline_cd,p_par_id,v_policy_id,p_line_cd,v_cargo_cd,v_hull_cd,v_aviation_cd,v_open_flag,v_menu_ln_cd);
         IF A.line_cd = v_cargo_cd THEN
            Copy_Pol_Wves_Accumulation(p_par_id,v_policy_id,p_line_cd,v_subline_cd,p_iss_cd);            
         END IF;
         Copy_Pol_Pack_Wdeductibles(a.item_no,p_par_id,v_policy_id);
     END IF;
  END LOOP;

  --BETH 01-06-2000 
  FOR CHK_OPEN IN
      ( SELECT '1'
          FROM GIIS_SUBLINE
         WHERE line_cd = p_line_cd
           AND subline_cd = v_subline_cd
           AND NVL(open_policy_sw,'N') = 'Y'
      ) LOOP
       Copy_Pol_Wopen_Policy(p_par_id,v_policy_id);
 END LOOP;          
  IF v_msg_alert IS NULL THEN 
    Copy_Pol_Wreqdocs(p_par_id,v_policy_id,p_user_id,v_msg_alert);
  END IF;
  Copy_Pol_Wpolwc(p_par_id,v_policy_id);
  Copy_Pol_Wmortgagee(p_par_id,v_policy_id);
  copy_pol_wpictures(p_par_id, v_policy_id, p_user_id); -- MARCO - 12.04.2015 - UCPB SR 21061
  IF v_msg_alert IS NULL THEN 
    Copy_Pol_Winvoice(p_par_id,v_policy_id,p_iss_cd,p_user_id,v_pack, v_prem_seq_no, v_msg_alert);
  END IF;
  Update_Co_Ins(p_par_id,v_policy_id); --BETH 020699  
ELSE       
      v_menu_ln_cd := NULL;         
      FOR menu_line IN ( SELECT menu_line_cd code
                         FROM GIIS_LINE
                        WHERE line_cd = p_line_cd )
      LOOP
          v_menu_ln_cd := menu_line.code;
          --variables.v_menu_ln_cd  := menu_line.code; --issa07.10.2007 4 non-package
      END LOOP;                          
      IF (v_menu_ln_cd = 'MN' OR p_line_cd = v_cargo_cd )
            AND v_open_flag = 'Y' THEN 
         Copy_Pol_Witem(p_par_id,v_policy_id);   --BETH   transfer data from gipi_witem and gipi_witmperl to
         Copy_Pol_Witmperl(p_par_id,v_policy_id,p_line_cd);--011399 its final table
         IF v_msg_alert IS NULL THEN
           Copy_Pol_Winvoice(p_par_id,v_policy_id,p_iss_cd,p_user_id,v_pack,v_prem_seq_no,v_msg_alert);--032999 loth
         END IF;
         Update_Co_Ins(p_par_id,v_policy_id);  -- aaron 052609 prf 3000
      ELSE
         IF p_line_cd != v_accident_cd THEN
--           copy_pol_winspection; -- 081699 Commented by loth table has been dropped
           Copy_Pol_Wlim_Liab(p_par_id,v_policy_id);
         END IF;
         --BETH 01-06-2000 
         FOR CHK_OPEN IN
            ( SELECT '1'
                FROM GIIS_SUBLINE
               WHERE line_cd = p_line_cd
                 AND subline_cd = v_subline_cd
                 AND NVL(open_policy_sw,'N') = 'Y'
             ) LOOP
             Copy_Pol_Wopen_Policy(p_par_id,v_policy_id);
         END LOOP;    
         IF v_open_flag = 'Y' THEN
               Copy_Pol_Wopen_Liab(p_par_id,v_policy_id);
               Copy_Pol_Wopen_Peril(p_par_id,v_policy_id);
         END IF;
         IF v_msg_alert IS NULL THEN
           Copy_Pol_Wreqdocs(p_par_id,v_policy_id,p_user_id,v_msg_alert);
         END IF;
         Copy_Pol_Witem(p_par_id,v_policy_id); 
         Copy_Pol_Witmperl(p_par_id,v_policy_id,p_line_cd);
         IF v_msg_alert IS NULL THEN
           Copy_Pol_Winvoice(p_par_id,v_policy_id,p_iss_cd,p_user_id,v_pack,v_prem_seq_no,v_msg_alert);
         END IF;
         Update_Co_Ins(p_par_id,v_policy_id); --BETH 020699
         Copy_Pol_Wmortgagee(p_par_id,v_policy_id);
      END IF;      
      Copy_Pol_Wpolwc(p_par_id,v_policy_id);
      IF (v_menu_ln_cd = 'AC' OR p_line_cd = v_accident_cd) THEN
         Copy_Pol_Wbeneficiary(p_par_id,v_policy_id);
         Copy_Pol_Waccident_Item(p_par_id,v_policy_id);  -- ramil 09/03/96
         Copy_Pol_Wgroup_Item(p_par_id,v_policy_id);     -- beth 11/05/98
         Copy_Pol_Wgrp_Items_Ben(p_par_id,v_policy_id);  -- grace 05/15/00
         Copy_Pol_Witmperl_Grouped(p_par_id,v_policy_id); -- gmi 09/21/05
         Copy_Pol_Witmperl_Beneficiary(p_par_id,v_policy_id); --gmi 09/21/05
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
      ELSIF (v_menu_ln_cd = 'CA' OR p_line_cd = v_casualty_cd) THEN
         Copy_Pol_Wbank_Sched(p_par_id,v_policy_id);
         Copy_Pol_Wcasualty_Item(p_par_id,v_policy_id);
         Copy_Pol_Wcasualty_Personnel(p_par_id,v_policy_id);
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
         Copy_Pol_Wgroup_Item(p_par_id,v_policy_id);     -- beth 11/05/98
         Copy_Pol_Wgrp_Items_Ben(p_par_id,v_policy_id);  -- grace 05/15/00
         Copy_Pol_Witmperl_Grouped(p_par_id,v_policy_id); -- gmi 09/21/05
         Copy_Pol_Witmperl_Beneficiary(p_par_id,v_policy_id); --gmi 09/21/05    
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04      
      ELSIF (v_menu_ln_cd = 'EN' OR p_line_cd = v_engrng_cd) THEN
         Copy_Pol_Wengg_Basic(p_par_id,v_policy_id);
         Copy_Pol_Wprincipal(p_par_id,v_policy_id);
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04
         BEGIN
           SELECT param_value_v
             INTO v_subline_bpv
             FROM GIIS_PARAMETERS
            WHERE param_name = v_bpv;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              --gipis207_pkg.pre_post_error2(p_par_id, 'No record in giis_parameters for engrng. subline '||v_subline_cd,p_module_id);
              --p_msg_alert := 'No record in giis_parameters for engrng. subline '||v_subline_cd; replaced by Kenenth L. 02.17.2014
              IF p_module_id = 'GIPIS207'
              THEN
                 gipis207_pkg.pre_post_error2(p_par_id, 'No record in giis_parameters for engrng. subline '||v_subline_cd,p_module_id);
                 p_msg_alert := 'Y';     
              ELSE
               p_msg_alert := 'No record in giis_parameters for engrng. subline '||v_subline_cd;
              END IF;
         END;
         IF v_subline_cd = v_subline_bpv THEN
            Copy_Pol_Wlocation(p_par_id,v_policy_id);
         END IF;
      ELSIF (v_menu_ln_cd = 'FI' OR p_line_cd = v_fire_cd) THEN
         IF v_msg_alert IS NULL THEN
           Check_Zone_Type(p_par_id,v_policy_id,v_msg_alert);          -- Grace 02/13/2001
         END IF; 
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04
         Copy_Pol_Wfire(p_par_id,v_policy_id);
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
      ELSIF (v_menu_ln_cd = 'MC' OR p_line_cd = v_motor_cd) THEN
         Copy_Pol_Wvehicle(p_par_id,v_policy_id);
         Copy_Pol_Wmcacc(p_par_id,v_policy_id);
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);    -- beth 11/05/98
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04
      ELSIF (v_menu_ln_cd = 'SU' OR p_line_cd = v_surety_cd) THEN
         Copy_Pol_Wbond_Basic(p_par_id,v_policy_id);
         Copy_Pol_Wcosigntry(p_par_id,v_policy_id);
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
         Update_Collateral_Par(p_par_id,v_policy_id);
      ELSIF v_menu_ln_cd IN ('MN','MH','AV') OR (p_line_cd IN
           (v_hull_cd,v_cargo_cd,v_aviation_cd)) THEN
         Copy_Pol_Wcargo_Hull(p_line_cd,v_subline_cd,p_par_id,v_policy_id,
                               p_line_cd,v_cargo_cd,v_hull_cd,v_aviation_cd,
                              v_open_flag,v_menu_ln_cd);
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04
         IF NVL(v_menu_ln_cd,p_line_cd) = v_cargo_cd THEN
            Copy_Pol_Wves_Accumulation(p_par_id,v_policy_id,p_line_cd,v_subline_cd,p_iss_cd);
         END IF;
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
     ELSE 
         Copy_Pol_Wbeneficiary(p_par_id,v_policy_id);
         Copy_Pol_Wdeductibles(p_par_id,v_policy_id);
         Copy_Pol_Wpictures(p_par_id,v_policy_id,p_user_id);       -- rolandmm 01/16/04
     END IF;
  END IF; 
  --gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);
  --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  IF p_module_id = 'GIPIS207'
  THEN
     gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);  
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  ELSE
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  END IF;
  p_policy_id := v_policy_id;
  p_prem_seq_no := v_prem_seq_no;
  FOR i IN (
    SELECT user_id
      FROM gipi_polbasic
     WHERE policy_id = v_policy_id)
  LOOP
    p_out_user_id := i.user_id;
  END LOOP;
END;
/


