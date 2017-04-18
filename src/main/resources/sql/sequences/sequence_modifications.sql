SET serveroutput ON


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'ACCTRAN_TRAN_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE ACCTRAN_TRAN_ID_S MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'ASSD_PROD_POL_DTL_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE ASSD_PROD_POL_DTL_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'CAR_COMPANY_CAR_COMPANY_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE CAR_COMPANY_CAR_COMPANY_CD_S NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'CHART_OF_ACCTS_GL_ACCT_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE CHART_OF_ACCTS_GL_ACCT_ID_S MAXVALUE 999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'CLAIMS_ADVICE_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE CLAIMS_ADVICE_ID_S MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'CLAIMS_CLAIM_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE CLAIMS_CLAIM_ID_S MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'CLM_RECOVERY_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE CLM_RECOVERY_ID_S MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'CLM_SUMMARY_SESSION_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE CLM_SUMMARY_SESSION_ID_S MAXVALUE 999999999999999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'COSIGNOR_RES_COSIGN_ID_SEQ';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE COSIGNOR_RES_COSIGN_ID_SEQ NOCYCLE NOORDER');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'COVERAGE_COVERAGE_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE COVERAGE_COVERAGE_CD_S MAXVALUE 999999999999999999999999999 NOCYCLE NOORDER');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'DEFAULT_DIST_DEFAULT_NO_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE DEFAULT_DIST_DEFAULT_NO_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'ENDTTEXT_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE ENDTTEXT_ID_S MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'FS_GROUP_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE FS_GROUP_ID_S MAXVALUE 999999999999999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'FS_TOTAL_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE FS_TOTAL_ID_S MAXVALUE 999999999999999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'FS_TOTAL_ITEM_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE FS_TOTAL_ITEM_ID_S MAXVALUE 999999999999999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GICL_MC_EVALUATION_EVAL_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GICL_MC_EVALUATION_EVAL_ID_S NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIIS_BLOCK_BLOCK_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIIS_BLOCK_BLOCK_ID_S NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIIS_INSP_CD_SEQ';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIIS_INSP_CD_SEQ MINVALUE 1');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIIS_MC_MAKE_MAKE_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIIS_MC_MAKE_MAKE_CD_S NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIIS_XOL_ID_SEQ';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIIS_XOL_ID_SEQ MAXVALUE 999999 NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIPI_INSP_DATA_INSP_NO_SEQ';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIPI_INSP_DATA_INSP_NO_SEQ MAXVALUE 999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIPI_MC_UPLOAD_SEQ_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIPI_MC_UPLOAD_SEQ_NO MAXVALUE 999999999999 NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GISM_CLIENT_INFO_CLIENT_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GISM_CLIENT_INFO_CLIENT_ID_S MAXVALUE 999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GIXX_EXTID_SEQ';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GIXX_EXTID_SEQ MINVALUE 1 MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GPRQ_REF_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GPRQ_REF_ID_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'GPRS_REQUEST_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE GPRS_REQUEST_ID_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'INDUSTRY_INDUSTRY_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE INDUSTRY_INDUSTRY_CD_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'INTERMEDIARY_INTM_NO_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE INTERMEDIARY_INTM_NO_S MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'LOSS_RATIO_SESSION_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE LOSS_RATIO_SESSION_ID_S MAXVALUE 999999999999999999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'LOST_BID_REASON_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE LOST_BID_REASON_CD_S MAXVALUE 999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'MC_COLOR_COLOR_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE MC_COLOR_COLOR_CD_S MAXVALUE 999999999999 NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'MC_PART_COST_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE MC_PART_COST_S MAXVALUE 999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'MODULE_ID_SEQ';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE MODULE_ID_SEQ MAXVALUE 999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'POL_DIST_BATCH_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE POL_DIST_BATCH_ID_S MAXVALUE 99999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'POSITION_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE POSITION_CD_S MINVALUE 1 MAXVALUE 9999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'PRIN_SIGNTRY_PRIN_ID_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE PRIN_SIGNTRY_PRIN_ID_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'RESTORED_CHK_HIST_SEQ_NO_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE RESTORED_CHK_HIST_SEQ_NO_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'SIGNATORY_NAMES_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE SIGNATORY_NAMES_S MAXVALUE 999999999999 NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'SL_TYPE_HIST_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE SL_TYPE_HIST_S NOCYCLE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'TYPE_OF_BODY_CD_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE TYPE_OF_BODY_CD_S NOCACHE');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'UPLOAD_SEQ_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE UPLOAD_SEQ_NO MAXVALUE 999999999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_sequences
     WHERE UPPER(sequence_name) = 'WINPOLBAS_ACCEPT_NO_S';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Sequence does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER SEQUENCE WINPOLBAS_ACCEPT_NO_S MAXVALUE 999999');
        dbms_output.put_line('Sequence has been successfully altered');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;