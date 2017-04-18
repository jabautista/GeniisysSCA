DROP FUNCTION CPI.GET_REF_NO_OLD;

CREATE OR REPLACE FUNCTION CPI.get_ref_no_old(p_tran_id    IN giac_acctrans.tran_id%TYPE)
        RETURN varchar2 IS
  CURSOR REF(p_tran_id    IN giac_acctrans.tran_id%TYPE) IS
    SELECT gacc.tran_class,
           DECODE(gacc.tran_class,
               'COL', DECODE(giop.or_pref_suf,
                      NULL, LTRIM(TO_CHAR(giop.or_no, '0000000000')),
                      giop.or_pref_suf || '-' || LTRIM(TO_CHAR(giop.or_no, '0000000000'))),
               'DV',  DECODE(gidv.check_pref_suf,
                      NULL, LTRIM(TO_CHAR(gidv.check_no, '0000000000')),
                      gidv.check_pref_suf || '-' || LTRIM(TO_CHAR(gidv.check_no, '0000000000')),
                      LTRIM(TO_CHAR(gacc.tran_class_no, '0000000000')))
                  ) ref_no
      FROM giac_disb_vouchers gidv,
           giac_order_of_payts giop,
           giac_acctrans gacc
      WHERE gacc.tran_id = p_tran_id
      AND gacc.tran_id = giop.gacc_tran_id(+)
      AND gacc.tran_id = gidv.gacc_tran_id(+);
  v_tran_class  giac_acctrans.tran_class%TYPE;
  v_ref_no      varchar2(30);
BEGIN
  OPEN REF(p_tran_id);
  FETCH REF INTO v_tran_class, v_ref_no;
    IF REF%FOUND THEN
      CLOSE REF;
      RETURN v_ref_no;
    ELSE
      CLOSE REF;
      RETURN NULL;
    END IF;
END;
/


