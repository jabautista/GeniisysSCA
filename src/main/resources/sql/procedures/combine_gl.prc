DROP PROCEDURE CPI.COMBINE_GL;

CREATE OR REPLACE PROCEDURE CPI.combine_gl AS
  SAVE_GL   NUMBER(6):=0;
--GIAC_ACCT_ENTRIES.gl_acct_id%TYPE  :=  0;
  SAVE_SL  GIAC_ACCT_ENTRIES.sl_cd%TYPE  :=  0;
  DEB_AMT  GIAC_ACCT_ENTRIES.debit_amt%TYPE  :=  0;
  CRE_AMT  GIAC_ACCT_ENTRIES.credit_amt%TYPE  :=  0;
  JV_ENTRY  GIAC_JOURNAL_ENTRIES.jv_entry_id%TYPE  :=  0;
  SAVE_TRAN_ID  GIAC_ACCTRANS.tran_id%TYPE;
  SAVE_GL_ACCT_CATEGORY   GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
  SAVE_GL_CONTROL_ACCT    GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
  SAVE_GL_SUB_ACCT_1      GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
  SAVE_GL_SUB_ACCT_2      GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
  SAVE_GL_SUB_ACCT_3      GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
  SAVE_GL_SUB_ACCT_4      GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
  SAVE_GL_SUB_ACCT_5      GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
  SAVE_GL_SUB_ACCT_6      GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
  SAVE_GL_SUB_ACCT_7      GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
BEGIN
  FOR a1 IN (SELECT TRAN_ID , GFUN_FUND_CD, GIBR_BRANCH_CD
             FROM GIAC_ACCTRANS
             WHERE JV_NO = 31) LOOP
    FOR a2 IN (SELECT ACCT_ENTRY_ID,   GL_ACCT_ID,
        GL_ACCT_CATEGORY,   GL_CONTROL_ACCT,
        GL_SUB_ACCT_1,      GL_SUB_ACCT_2,
        GL_SUB_ACCT_3,      GL_SUB_ACCT_4,
                      GL_SUB_ACCT_5,      GL_SUB_ACCT_6,
                      GL_SUB_ACCT_7,      SL_CD,
                      DEBIT_AMT,          CREDIT_AMT,
               GACC_TRAN_ID
               FROM GIAC_ACCT_ENTRIES
        WHERE GACC_TRAN_ID = a1.TRAN_ID
        AND GACC_GFUN_FUND_CD = a1.GFUN_FUND_CD
        AND GACC_GIBR_BRANCH_CD = a1.GIBR_BRANCH_CD
               ORDER BY GL_ACCT_ID, SL_CD )  LOOP
      IF SAVE_GL = 0 AND SAVE_SL = 0 THEN
         SAVE_GL_ACCT_CATEGORY := a2.gl_acct_category;
         SAVE_GL_CONTROL_ACCT  := a2.gl_control_acct;
         SAVE_GL_SUB_ACCT_1    := a2.gl_sub_acct_1;
         SAVE_GL_SUB_ACCT_2    := a2.gl_sub_acct_2;
         SAVE_GL_SUB_ACCT_3    := a2.gl_sub_acct_3;
         SAVE_GL_SUB_ACCT_4    := a2.gl_sub_acct_4;
         SAVE_GL_SUB_ACCT_5    := a2.gl_sub_acct_5;
         SAVE_GL_SUB_ACCT_6    := a2.gl_sub_acct_6;
         SAVE_GL_SUB_ACCT_7    := a2.gl_sub_acct_7;
         SAVE_GL               := a2.gl_acct_id;
         SAVE_SL               := a2.sl_cd;
         DEB_AMT  :=  DEB_AMT + a2.debit_amt;
         CRE_AMT  :=  CRE_AMT + a2.credit_amt;
      ELSIF a2.GL_ACCT_ID = SAVE_GL AND a2.SL_CD = SAVE_SL THEN
      DEB_AMT  :=  a2.DEBIT_AMT + DEB_AMT;
          CRE_AMT  :=  a2.CREDIT_AMT + CRE_AMT;
      ELSIF a2.GL_ACCT_ID <> SAVE_GL OR a2.SL_CD <> SAVE_SL THEN
         DEB_AMT :=  0;
         CRE_AMT :=  0;
         SAVE_GL_ACCT_CATEGORY := a2.gl_acct_category;
         SAVE_GL_CONTROL_ACCT  := a2.gl_control_acct;
         SAVE_GL_SUB_ACCT_1    := a2.gl_sub_acct_1;
         SAVE_GL_SUB_ACCT_2    := a2.gl_sub_acct_2;
         SAVE_GL_SUB_ACCT_3    := a2.gl_sub_acct_3;
         SAVE_GL_SUB_ACCT_4    := a2.gl_sub_acct_4;
         SAVE_GL_SUB_ACCT_5    := a2.gl_sub_acct_5;
         SAVE_GL_SUB_ACCT_6    := a2.gl_sub_acct_6;
         SAVE_GL_SUB_ACCT_7    := a2.gl_sub_acct_7;
         SAVE_GL               := a2.gl_acct_id;
         SAVE_SL               := a2.sl_cd;
         DEB_AMT  :=  DEB_AMT + a2.debit_amt;
         CRE_AMT  :=  CRE_AMT + a2.credit_amt;
      END IF;
    END LOOP;
  END LOOP;
END;
/


