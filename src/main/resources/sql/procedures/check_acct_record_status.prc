CREATE OR REPLACE PROCEDURE CPI.check_acct_record_status (
    p_tran_id       giac_order_of_payts.gacc_tran_id%TYPE,
    p_module_id     giis_modules.module_id%TYPE
)
IS
    v_or_flag       giac_order_of_payts.or_flag%TYPE;
    v_tran_flag     giac_acctrans.tran_flag%TYPE;
    v_tran_class    giac_acctrans.tran_class%TYPE;
    v_ref_id        giac_payt_requests.ref_id%TYPE;
    v_with_dv       giac_payt_requests.with_dv%TYPE;
    v_payt_req_flag giac_payt_requests_dtl.payt_req_flag%TYPE;
    v_memo_status   giac_cm_dm.memo_status%TYPE;
    v_or_tag        giac_order_of_payts.or_tag%TYPE;       --Deo [02.10.2017]: SR-5932
BEGIN
    IF p_module_id = 'GIACS001' THEN
        BEGIN
            SELECT or_flag, or_tag, tran_flag              --Deo [02.10.2017]: added or_tag and tran_flag (SR-5932)
              INTO v_or_flag, v_or_tag, v_tran_flag        --Deo [02.10.2017]: added v_or_tag and v_tran_flag (SR-5932)
              FROM giac_order_of_payts a, giac_acctrans b  --Deo [02.10.2017]: added giac_acctrans (SR-5932)
             WHERE gacc_tran_id = p_tran_id
               AND gacc_tran_id = tran_id;                 --Deo [02.10.2017]: added join condition (SR-5932)
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN;
        END;
        
        IF v_or_tag = '*' AND v_tran_flag = 'O'            --Deo [02.10.2017]: add start (SR-5932)
        THEN
           RETURN;
        END IF;
            
        IF v_or_flag = 'C' OR v_or_flag = 'P' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#O.R. is already ' || cg_ref_codes_pkg.get_rv_meaning('GIAC_ORDER_OF_PAYTS.OR_FLAG', v_or_flag) || '.');
        END IF;
    ELSIF p_module_id IN ('GIACS003', 'GIACS007', 'GIACS020', 'GIACS030', 'GIACS008', 'GIACS017', 'GIACS018', 'GIACS019', 'GIACS022', 'GIACS039', 'GIACS009', 'GIACS010', 'GIACS026', 'GIACS040') THEN
        BEGIN
            SELECT tran_class, tran_flag
              INTO v_tran_class, v_tran_flag
              FROM giac_acctrans
             WHERE tran_id = p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN;
        END;
            
        IF v_tran_class = 'DV' THEN
            BEGIN
                SELECT gprq_ref_id, payt_req_flag
                  INTO v_ref_id, v_payt_req_flag
                  FROM giac_payt_requests_dtl
                 WHERE tran_id = p_tran_id;
                     
                SELECT with_dv
                  INTO v_with_dv
                  FROM giac_payt_requests
                 WHERE ref_id = v_ref_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RETURN;
            END;
                 
            IF v_with_dv = 'Y' THEN
                raise_application_error(-20001, 'Geniisys Exception#E#Transaction is with DV.');
            ELSIF v_with_dv = 'N' THEN
                IF v_payt_req_flag = 'C' OR v_payt_req_flag = 'X' THEN
                    raise_application_error(-20001, 'Geniisys Exception#E#Transaction is already ' || cg_ref_codes_pkg.get_rv_meaning('GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG', v_payt_req_flag) || '.');
                END IF;
            END IF;
        ELSE
            IF v_tran_flag = 'C' OR v_tran_flag = 'D' OR v_tran_flag = 'P' THEN
                raise_application_error(-20001, 'Geniisys Exception#E#Transaction is already ' || cg_ref_codes_pkg.get_rv_meaning('GIAC_ACCTRANS.TRAN_FLAG', v_tran_flag) || '.');
            END IF;
        END IF;
    ELSIF p_module_id = 'GIACS016' THEN
        BEGIN
            SELECT payt_req_flag
              INTO v_payt_req_flag
              FROM giac_payt_requests_dtl
             WHERE tran_id = p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN;
        END;
             
        IF v_payt_req_flag = 'C' OR v_payt_req_flag = 'X' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Transaction is already ' || cg_ref_codes_pkg.get_rv_meaning('GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG', v_payt_req_flag) || '.');
        END IF;
    ELSIF p_module_id = 'GIACS071' THEN
        BEGIN
            SELECT memo_status
              INTO v_memo_status
              FROM giac_cm_dm
             WHERE gacc_tran_id = p_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
            
        IF v_memo_status = 'P' OR v_memo_status = 'C' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Transaction is already ' || cg_ref_codes_pkg.get_rv_meaning('GIAC_CM_DM.MEMO_STATUS', v_memo_status) || '.');
        END IF;
    END IF;
END;
/
