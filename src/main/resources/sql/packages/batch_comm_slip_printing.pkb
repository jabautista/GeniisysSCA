CREATE OR REPLACE PACKAGE BODY CPI.batch_comm_slip_printing
AS
  FUNCTION get_last_comm_slip_pref (p_branch_cd VARCHAR2,
                                    p_user_seq_type  VARCHAR2) RETURN VARCHAR2
  IS
  BEGIN
    FOR i IN (SELECT comm_slip_pref
                FROM giac_comm_slip_ext
                  WHERE comm_slip_pref IS NOT NULL
                    AND ROWNUM = 1
                    AND DECODE(p_user_seq_type, 'Y',user_id,'N') = DECODE(p_user_seq_type, 'Y',USER,'N')
                    AND iss_cd = p_branch_cd
                      ORDER BY gacc_tran_id DESC)
    LOOP
      RETURN (i.comm_slip_pref);
      EXIT;
    END LOOP;
  END get_last_comm_slip_pref;
  PROCEDURE extract_batch_comm_slip (p_tran_ids VARCHAR2)
IS
  TYPE transaction_id IS TABLE OF giac_comm_slip_ext.gacc_tran_id%TYPE;
  TYPE issue_cd IS TABLE OF giis_issource.iss_cd%TYPE;
  TYPE premium_seq_no IS TABLE OF gipi_invoice.prem_seq_no%TYPE;
  TYPE intermediary_no IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE record_id IS TABLE OF giac_comm_slip_ext.rec_id%TYPE;
  TYPE parent_intermediary_no IS TABLE OF giac_comm_payts.parent_intm_no%TYPE;
  TYPE commission_amt IS TABLE OF giac_comm_payts.comm_amt%TYPE;
  TYPE withhtax_amt IS TABLE OF giac_comm_payts.wtax_amt%TYPE;
  TYPE input_vat_amount IS TABLE OF giac_comm_payts.input_vat_amt%TYPE;
  TYPE or_number IS TABLE OF VARCHAR2(200);
  TYPE existing IS TABLE OF VARCHAR2(1);
  vv_tran_id          transaction_id;
  vv_iss_cd           issue_cd;
  vv_prem_seq_no      premium_seq_no;
  vv_intm_no          intermediary_no;
  vv_rec_id           record_id;
  vv_pdc_exists       existing;
  v_pdc_exists        VARCHAR2(1);
  v_rec_id            GIAC_COMM_SLIP_EXT.REC_ID%TYPE;
  vv_parent_intm_no   parent_intermediary_no;
  vv_comm_amt         commission_amt;
  vv_wtax_amt         withhtax_amt;
  vv_input_vat_amt    input_vat_amount;
  vv_or_no            or_number;
BEGIN
  EXECUTE IMMEDIATE 'SELECT ''X'''||
                       'FROM giac_pdc_checks '||
                          'WHERE gacc_tran_id_new IN '||p_tran_ids
                             BULK COLLECT INTO vv_pdc_exists;
  IF vv_pdc_exists.COUNT > 0 THEN
    v_pdc_exists := 'Y';
  END IF;
  ---

  EXECUTE IMMEDIATE 'SELECT gacc_tran_id, '||
                           'iss_cd, '||
                           'prem_seq_no, '||
                           'intm_no, '||
                           'rec_id '||
                      'FROM giac_comm_slip_ext '||
                         'WHERE gacc_tran_id IN '||p_tran_ids||
                              ' MINUS '||
                    'SELECT a.gacc_tran_id, '||
                           'a.iss_cd, '||
                           'a.prem_seq_no, '||
                           'a.intm_no, '||
                           'b.rec_id '||
                      'FROM giac_comm_payts a, giac_comm_slip_ext b '||
                         'WHERE a.gacc_tran_id IN '||p_tran_ids||
                          ' AND a.gacc_tran_id = b.gacc_tran_id '||
                          ' AND a.intm_no = b.intm_no '||
                          ' AND a.iss_cd = b.iss_cd '||
                          ' AND a.prem_seq_no = b.prem_seq_no '||
                          ' AND a.gacc_tran_id > 0 '||
                          ' AND a.comm_amt = b.comm_amt '||
                          ' AND a.wtax_amt = b.wtax_amt '||
                          ' AND a.input_vat_amt = b.input_vat_amt '
       BULK COLLECT INTO vv_tran_id,
                         vv_iss_cd,
                         vv_prem_seq_no,
                         vv_intm_no,
                         vv_rec_id;

 IF vv_tran_id.COUNT > 0 THEN
    FOR indx IN vv_tran_id.FIRST..vv_tran_id.LAST
    LOOP
      DELETE FROM giac_comm_slip_ext
        WHERE gacc_tran_id = vv_tran_id(indx)
          AND iss_cd = vv_iss_cd(indx)
          AND prem_seq_no = vv_prem_seq_no(indx)
          AND intm_no = vv_intm_no(indx)
          AND rec_id = vv_rec_id(indx);
    END LOOP;
  END IF;

  --

  SELECT NVL(MAX(rec_id),0)
    INTO V_REC_ID
      FROM GIAC_COMM_SLIP_EXT;
  --
  IF v_pdc_exists IS NULL THEN
    EXECUTE IMMEDIATE 'SELECT a.gacc_tran_id, '||
                             'a.iss_cd, '||
                             'a.prem_seq_no, '||
                             'a.intm_no, '||
                             'a.parent_intm_no, '||
                             'a.comm_amt, '||
                             'a.wtax_amt, '||
                             'a.input_vat_amt, '||
                             'b.or_pref_suf||''-''||to_char(b.or_no) or_no '||
                         'FROM giac_comm_payts a, giac_order_of_payts b '||
                           'WHERE a.gacc_tran_id IN '||p_tran_ids||
                             ' AND a.gacc_tran_id=b.gacc_tran_id '||
                              ' MINUS '||
                      'SELECT a.gacc_tran_id, '||
                             'a.iss_cd, '||
                             'a.prem_seq_no, '||
                             'a.intm_no, '||
                             'a.parent_intm_no, '||
                             'a.comm_amt, '||
                             'a.wtax_amt, '||
                             'a.input_vat_amt, '||
                             'b.or_pref_suf||''-''||to_char(b.or_no) or_no '||
                         'FROM giac_comm_slip_ext a, giac_order_of_payts b, giac_comm_payts c '||
                           'WHERE a.gacc_tran_id IN '||p_tran_ids||
                            ' AND a.gacc_tran_id=b.gacc_tran_id '||
                            ' AND a.gacc_tran_id=c.gacc_tran_id '||
                            ' AND a.intm_no = c.intm_no '||
                            ' AND a.iss_cd = c.iss_cd '||
                            ' AND a.prem_seq_no = c.prem_seq_no '||
                            ' AND c.gacc_tran_id > 0 '
       BULK COLLECT INTO vv_tran_id,
                         vv_iss_cd,
                         vv_prem_seq_no,
                         vv_intm_no,
                         vv_parent_intm_no,
                         vv_comm_amt,
                         vv_wtax_amt,
                         vv_input_vat_amt,
                         vv_or_no;
  --
    IF vv_tran_id.COUNT > 0 THEN
      FOR indx2 IN vv_tran_id.FIRST..vv_tran_id.LAST
      LOOP
        INSERT INTO giac_comm_slip_ext
        (rec_id, gacc_tran_id, iss_cd, prem_seq_no, intm_no, comm_amt,
         wtax_amt, input_vat_amt, user_id, last_update, comm_slip_tag,or_no,PARENT_INTM_NO
         )
        VALUES
        ((v_rec_id+indx2), vv_tran_id(indx2), vv_iss_cd(indx2), vv_prem_seq_no(indx2), vv_intm_no(indx2), vv_comm_amt(indx2),
          vv_wtax_amt(indx2), vv_input_vat_amt(indx2), USER, SYSDATE, 'N',vv_or_no(indx2),vv_parent_intm_no(indx2)
        );
      END LOOP;
    END IF;
  ELSE
    EXECUTE IMMEDIATE 'SELECT a.gacc_tran_id, '||
                             'a.iss_cd, '||
                             'a.prem_seq_no, '||
                             'a.intm_no, '||
                             'a.parent_intm_no, '||
                             'a.comm_amt, '||
                             'a.wtax_amt, '||
                             'a.input_vat_amt, '||
                             'b.or_pref_suf||''-''||TO_CHAR(b.or_no) or_no '||
                        'FROM giac_comm_payts a, giac_order_of_payts b, GIAC_PDC_CHECKS C '||
                          'WHERE a.gacc_tran_id IN '||p_tran_ids||
                              ' AND B.gacc_tran_id = C.gacc_tran_id '||
                           ' AND a.gacc_tran_id = c.gacc_tran_id_NEW '||
                            ' MINUS '||
                       'SELECT a.gacc_tran_id, '||
                              'a.iss_cd, '||
                              'a.prem_seq_no, '||
                              'a.intm_no, '||
                              'a.parent_intm_no, '||
                              'a.comm_amt, '||
                              'a.wtax_amt, '||
                              'a.input_vat_amt,'||
                              'b.or_pref_suf||''-''||to_char(b.or_no) or_no '||
                          'FROM giac_comm_slip_ext a, giac_order_of_payts b, giac_comm_payts c, GIAC_PDC_CHECKS D '||
                            'WHERE a.gacc_tran_id IN '||p_tran_ids||
                             ' AND a.gacc_tran_id=D.gacc_tran_id_NEW '||
                            ' AND D.gacc_tran_id = B.gacc_tran_id '||
                                ' AND a.gacc_tran_id=c.gacc_tran_id '||
                             ' AND a.intm_no = c.intm_no '||
                              ' AND a.iss_cd = c.iss_cd '||
                              ' AND a.prem_seq_no = c.prem_seq_no '||
                              ' AND c.gacc_tran_id > 0 '
        BULK COLLECT INTO vv_tran_id,
                          vv_iss_cd,
                          vv_prem_seq_no,
                          vv_intm_no,
                          vv_parent_intm_no,
                          vv_comm_amt,
                          vv_wtax_amt,
                          vv_input_vat_amt,
                          vv_or_no;
    IF vv_tran_id.COUNT > 0 THEN
      FOR indx2 IN vv_tran_id.FIRST..vv_tran_id.LAST
      LOOP
      INSERT INTO giac_comm_slip_ext
        (rec_id, gacc_tran_id, iss_cd, prem_seq_no, intm_no, comm_amt,
         wtax_amt, input_vat_amt, user_id, last_update, comm_slip_tag,or_no,parent_intm_no
        )
        VALUES
        (v_rec_id+indx2, vv_tran_id(indx2), vv_iss_cd(indx2), vv_prem_seq_no(indx2), vv_intm_no(indx2), vv_comm_amt(indx2),
         vv_wtax_amt(indx2), vv_input_vat_amt(indx2), USER, SYSDATE, 'N',vv_or_no(indx2),vv_parent_intm_no(indx2)
        );
      END LOOP;
    END IF;
  END IF;
  COMMIT;
END extract_batch_comm_slip;
END;
/


