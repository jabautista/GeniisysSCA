DROP PROCEDURE CPI.BAE_CHECK_BATCH_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.BAE_CHECK_BATCH_ENTRIES
    (cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE ,
     cca_sl_type_cd   IN OUT GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE ) IS
  cursor   check_COA
    (p_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     p_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     p_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     p_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     p_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     p_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     p_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     p_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     p_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE) is
    SELECT gl_acct_id, gslt_sl_type_cd
    FROM   giac_batch_entries
   WHERE gl_acct_category  = p_gl_acct_category
     AND gl_control_acct   = p_gl_control_acct
     AND gl_sub_acct_1     = p_gl_sub_acct_1
     AND gl_sub_acct_2     = p_gl_sub_acct_2
     AND gl_sub_acct_3     = p_gl_sub_acct_3
     AND gl_sub_acct_4     = p_gl_sub_acct_4
     AND gl_sub_acct_5     = p_gl_sub_acct_5
     AND gl_sub_acct_6     = p_gl_sub_acct_6
     AND gl_sub_acct_7     = p_gl_sub_acct_7;
  v_gl_acct_id             GIAC_BATCH_ENTRIES.gl_acct_id%TYPE;
BEGIN
  for rec in check_coa (cca_gl_acct_category, cca_gl_control_acct,
     cca_gl_sub_acct_1, cca_gl_sub_acct_2,
     cca_gl_sub_acct_3, cca_gl_sub_acct_4,
     cca_gl_sub_acct_5, cca_gl_sub_acct_6,
     cca_gl_sub_acct_7) loop
     cca_gl_acct_id   := rec.gl_acct_id;
     cca_sl_type_cd   := rec.gslt_sl_type_cd;
  end loop;
END;
/


