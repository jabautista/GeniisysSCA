CREATE OR REPLACE PACKAGE BODY CPI.giacs318_pkg
AS
   FUNCTION get_whtax_list (
      p_fund_cd        giac_wholding_taxes.gibr_gfun_fund_cd%TYPE,
      p_branch_cd      giac_wholding_taxes.gibr_branch_cd%TYPE,
      p_ind_corp_tag   giac_wholding_taxes.ind_corp_tag%TYPE,
      p_whtax_code     giac_wholding_taxes.whtax_code%TYPE,
      p_whtax_desc     giac_wholding_taxes.whtax_desc%TYPE,
      p_bir_tax_cd     giac_wholding_taxes.bir_tax_cd%TYPE,
      p_percent_rate   giac_wholding_taxes.percent_rate%TYPE
   )
      RETURN whtax_tab PIPELINED
   IS
      v_rec   whtax_type;
   BEGIN
      FOR i IN
         (SELECT a.whtax_id, a.gibr_gfun_fund_cd, a.gibr_branch_cd,
                 a.whtax_code, a.whtax_desc, a.remarks, a.ind_corp_tag,
                 a.user_id, a.last_update, a.bir_tax_cd, a.percent_rate,
                 a.start_dt, a.end_dt, a.sl_type_cd, a.gl_acct_id,
                 b.sl_type_name, c.gl_acct_category, c.gl_control_acct,
                 c.gl_sub_acct_1, c.gl_sub_acct_2, c.gl_sub_acct_3,
                 c.gl_sub_acct_4, c.gl_sub_acct_5, c.gl_sub_acct_6,
                 c.gl_sub_acct_7, c.gl_acct_name
            FROM giac_wholding_taxes a,
                 giac_sl_types b,
                 giac_chart_of_accts c
           WHERE a.gibr_gfun_fund_cd = p_fund_cd
             AND a.gibr_branch_cd = p_branch_cd
             AND a.sl_type_cd = b.sl_type_cd(+) --marco - 10.14.2014 - @FGIC added (+)
             AND a.gl_acct_id = c.gl_acct_id
             AND UPPER (a.whtax_desc) LIKE UPPER (NVL (p_whtax_desc, '%'))
             AND UPPER (a.whtax_code) = NVL (p_whtax_code, a.whtax_code)
             AND UPPER (a.ind_corp_tag) LIKE UPPER (NVL (p_ind_corp_tag, '%'))
             AND UPPER (a.bir_tax_cd) LIKE UPPER (NVL (p_bir_tax_cd, '%'))
             AND a.percent_rate = NVL (p_percent_rate, a.percent_rate))
      LOOP
         v_rec.whtax_id := i.whtax_id;
         v_rec.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_rec.gibr_branch_cd := i.gibr_branch_cd;
         v_rec.whtax_code := i.whtax_code;
         v_rec.whtax_desc := i.whtax_desc;
         v_rec.remarks := i.remarks;
         v_rec.ind_corp_tag := i.ind_corp_tag;
         v_rec.user_id := i.user_id;
         v_rec.bir_tax_cd := i.bir_tax_cd;
         v_rec.percent_rate := i.percent_rate;
         v_rec.start_dt := TO_CHAR (i.start_dt, 'MM-DD-YYYY');
         v_rec.end_dt := TO_CHAR (i.end_dt, 'MM-DD-YYYY');
         v_rec.sl_type_cd := i.sl_type_cd;
         v_rec.gl_acct_id := i.gl_acct_id;
         v_rec.dsp_sl_type_name := i.sl_type_name;
         v_rec.dsp_gl_acct_category := i.gl_acct_category;
         v_rec.dsp_gl_control_acct := i.gl_control_acct;
         v_rec.dsp_gl_sub_acct_1 := i.gl_sub_acct_1;
         v_rec.dsp_gl_sub_acct_2 := i.gl_sub_acct_2;
         v_rec.dsp_gl_sub_acct_3 := i.gl_sub_acct_3;
         v_rec.dsp_gl_sub_acct_4 := i.gl_sub_acct_4;
         v_rec.dsp_gl_sub_acct_5 := i.gl_sub_acct_5;
         v_rec.dsp_gl_sub_acct_6 := i.gl_sub_acct_6;
         v_rec.dsp_gl_sub_acct_7 := i.gl_sub_acct_7;
         v_rec.dsp_gl_acct_name := i.gl_acct_name;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_whtax (p_rec giac_wholding_taxes%ROWTYPE)
   IS
      v_whtax_id   giac_wholding_taxes.whtax_id%TYPE;
   BEGIN
      IF p_rec.whtax_id IS NULL
      THEN
         SELECT whtax_id_s.NEXTVAL
           INTO v_whtax_id
           FROM DUAL;
      END IF;

      MERGE INTO giac_wholding_taxes
         USING DUAL
         ON (whtax_id = p_rec.whtax_id)
         WHEN NOT MATCHED THEN
            INSERT (whtax_id, gibr_gfun_fund_cd, gibr_branch_cd, whtax_code,
                    whtax_desc, ind_corp_tag, percent_rate, bir_tax_cd,
                    start_dt, end_dt, gl_acct_id, remarks, user_id,
                    last_update, sl_type_cd)
            VALUES (v_whtax_id, p_rec.gibr_gfun_fund_cd, p_rec.gibr_branch_cd,
                    p_rec.whtax_code, p_rec.whtax_desc, p_rec.ind_corp_tag,
                    p_rec.percent_rate, p_rec.bir_tax_cd, p_rec.start_dt,
                    p_rec.end_dt, p_rec.gl_acct_id, p_rec.remarks,
                    p_rec.user_id, SYSDATE, p_rec.sl_type_cd)
         WHEN MATCHED THEN
            UPDATE
               SET whtax_code = p_rec.whtax_code,
                   whtax_desc = p_rec.whtax_desc,
                   bir_tax_cd = p_rec.bir_tax_cd,
                   ind_corp_tag = p_rec.ind_corp_tag,
                   percent_rate = p_rec.percent_rate,
                   start_dt = p_rec.start_dt, end_dt = p_rec.end_dt,
                   gl_acct_id = p_rec.gl_acct_id, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE,
                   sl_type_cd = p_rec.sl_type_cd
            ;
   END;

   PROCEDURE del_whtax (p_whtax_id giac_wholding_taxes.whtax_id%TYPE)
   AS
   BEGIN
      DELETE FROM giac_wholding_taxes
            WHERE whtax_id = p_whtax_id;
   END;

   PROCEDURE val_del_whtax (p_whtax_id giac_wholding_taxes.whtax_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_taxes_wheld g
                 WHERE g.gwtx_whtax_id = p_whtax_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete GIAC_WHOLDING_TAXES while dependent GIAC_TAXES_WHELD exists.'
            );
      END IF;
   END;

   FUNCTION validate_gl_account_code (
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN VARCHAR2
   IS
      v_temp_x   VARCHAR2 (1);
   BEGIN
      SELECT (SELECT DISTINCT 'X'
                         FROM giac_chart_of_accts
                        WHERE gl_acct_category =
                                    NVL (p_gl_acct_category, gl_acct_category)
                          AND gl_control_acct =
                                      NVL (p_gl_control_acct, gl_control_acct)
                          AND gl_sub_acct_1 =
                                          NVL (p_gl_sub_acct_1, gl_sub_acct_1)
                          AND gl_sub_acct_2 =
                                          NVL (p_gl_sub_acct_2, gl_sub_acct_2)
                          AND gl_sub_acct_3 =
                                          NVL (p_gl_sub_acct_3, gl_sub_acct_3)
                          AND gl_sub_acct_4 =
                                          NVL (p_gl_sub_acct_4, gl_sub_acct_4)
                          AND gl_sub_acct_5 =
                                          NVL (p_gl_sub_acct_5, gl_sub_acct_5)
                          AND gl_sub_acct_6 =
                                          NVL (p_gl_sub_acct_6, gl_sub_acct_6)
                          AND gl_sub_acct_7 =
                                          NVL (p_gl_sub_acct_7, gl_sub_acct_7))
        INTO v_temp_x
        FROM DUAL;

      IF v_temp_x IS NOT NULL
      THEN
         RETURN '1';
      ELSE
         RETURN '0';
      END IF;
   END;

   FUNCTION get_gl_acct_lov (p_find VARCHAR2)
      RETURN gl_acct_list_tab PIPELINED
   IS
      v_list   gl_acct_list_type;
   BEGIN
      FOR i IN
         (SELECT   gicoa.gl_acct_category,
                   LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
                   LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
                   LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
                   LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
                   LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
                   LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
                   LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
                   LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7,
                   gicoa.gl_acct_name, gicoa.gslt_sl_type_cd,
                   gicoa.gl_acct_id, b.sl_type_name
              FROM giac_chart_of_accts gicoa, giac_sl_types b
             WHERE gicoa.gslt_sl_type_cd = b.sl_type_cd(+)
               AND gicoa.leaf_tag = 'Y'
               AND (      gicoa.gl_acct_category
                       || LPAD (gicoa.gl_control_acct, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_1, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_2, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_3, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_4, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_5, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_6, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_7, 2, '0') LIKE
                                                       NVL (p_find, '%')     
					   OR gicoa.gl_acct_name LIKE NVL (p_find, '%')   -- added by robert 12.18.14 							   
                   )
          ORDER BY gicoa.gl_acct_category,
                   gicoa.gl_control_acct,
                   gicoa.gl_sub_acct_1,
                   gicoa.gl_sub_acct_2,
                   gicoa.gl_sub_acct_3,
                   gicoa.gl_sub_acct_4,
                   gicoa.gl_sub_acct_5,
                   gicoa.gl_sub_acct_6,
                   gicoa.gl_sub_acct_7)
      LOOP
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gslt_sl_type_cd := i.gslt_sl_type_cd;
         v_list.sl_type_name := i.sl_type_name;
         PIPE ROW (v_list);
      END LOOP;
   END;
END;
/


