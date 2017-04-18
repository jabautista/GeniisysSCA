DROP FUNCTION CPI.CF_OR_TYPE;

CREATE OR REPLACE FUNCTION CPI.CF_OR_TYPE(  --Added by Alfred 03/09/2011
       p_or_pref_suf          GIAC_ORDER_OF_PAYTS.OR_PREF_SUF%TYPE,
       p_branch_cd           GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE,
       p_fund_cd               GIAC_ORDER_OF_PAYTS.GIBR_GFUN_FUND_CD%TYPE
       )
      RETURN Char IS
            v_or_type  giac_or_pref.or_type%TYPE;
      BEGIN
           FOR A IN (SELECT or_type
                             FROM giac_or_pref
                           WHERE or_pref_suf = p_or_pref_suf
                               AND branch_cd = p_branch_cd
                               AND fund_cd = p_fund_cd)
           LOOP
                v_or_type := A.or_type;
           END LOOP;
           
                        IF v_or_type = 'N' THEN
               RETURN ('TOTAL VAT EXEMPT SALES:');
                   ELSIF v_or_type = 'V' THEN
               RETURN ('TOTAL        :');
                    ELSE
               RETURN ('TOTAL        :');
               END IF;
      END;
/


