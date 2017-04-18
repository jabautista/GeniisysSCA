DROP PROCEDURE CPI.GIPIS093_DEL_ADDTL_TABLES;

CREATE OR REPLACE PROCEDURE CPI.gipis093_del_addtl_tables (
   p_par_id            gipi_wpack_line_subline.par_id%TYPE,
   p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
   p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE
)
IS
   v_line_cd         gipi_witem.pack_line_cd%TYPE;
   v_subline_cd      gipi_witem.pack_subline_cd%TYPE;
   v_exist           VARCHAR2 (1)                         := 'N';
   variable_lc_ac    giis_parameters.param_value_v%TYPE;
   variable_lc_av    giis_parameters.param_value_v%TYPE;
   variable_lc_ca    giis_parameters.param_value_v%TYPE;
   variable_lc_en    giis_parameters.param_value_v%TYPE;
   variable_lc_fi    giis_parameters.param_value_v%TYPE;
   variable_lc_hl    giis_parameters.param_value_v%TYPE;
   variable_lc_mc    giis_parameters.param_value_v%TYPE;
   variable_lc_mn    giis_parameters.param_value_v%TYPE;
   variable_sc_bbi   giis_parameters.param_value_v%TYPE;
BEGIN
   --initialize variables
   v_line_cd := p_pack_line_cd;
   v_subline_cd := p_pack_subline_cd;

   FOR a1 IN (SELECT a.param_value_v a_param_value_v,
                     b.param_value_v b_param_value_v,
                     c.param_value_v c_param_value_v,
                     d.param_value_v d_param_value_v,
                     e.param_value_v e_param_value_v,
                     f.param_value_v f_param_value_v,
                     g.param_value_v g_param_value_v,
                     h.param_value_v h_param_value_v
                FROM giis_parameters a,
                     giis_parameters b,
                     giis_parameters c,
                     giis_parameters d,
                     giis_parameters e,
                     giis_parameters f,
                     giis_parameters g,
                     giis_parameters h
               WHERE a.param_name LIKE 'LINE_CODE_AC'
                 AND b.param_name LIKE 'LINE_CODE_AV'
                 AND c.param_name LIKE 'LINE_CODE_CA'
                 AND d.param_name LIKE 'LINE_CODE_EN'
                 AND e.param_name LIKE 'LINE_CODE_FI'
                 AND f.param_name LIKE 'LINE_CODE_MH'
                 AND g.param_name LIKE 'LINE_CODE_MC'
                 AND h.param_name LIKE 'LINE_CODE_MN')
   LOOP
      variable_lc_ac := a1.a_param_value_v;
      variable_lc_av := a1.b_param_value_v;
      variable_lc_ca := a1.c_param_value_v;
      variable_lc_en := a1.d_param_value_v;
      variable_lc_fi := a1.e_param_value_v;
      variable_lc_hl := a1.f_param_value_v;
      variable_lc_mc := a1.g_param_value_v;
      variable_lc_mn := a1.h_param_value_v;
   END LOOP;

   IF v_line_cd = variable_lc_mn
   THEN
      DELETE      gipi_wves_air
            WHERE par_id = p_par_id;
   END IF;

   IF v_line_cd = variable_lc_en
   THEN
      DELETE      gipi_wengg_basic
            WHERE par_id = p_par_id;

      DELETE      gipi_wprincipal
            WHERE par_id = p_par_id;
   END IF;

   IF v_line_cd = variable_lc_ca AND v_subline_cd = variable_sc_bbi
   THEN
      DELETE      gipi_wbank_schedule
            WHERE par_id = p_par_id;
   END IF;
END gipis093_del_addtl_tables;
/


