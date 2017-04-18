CREATE OR REPLACE PACKAGE BODY CPI.GIACS214_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.04.2013
     ** Referenced By:  GIACS214 - Policy / Endt Nos. For a Given Assured (Direct Premium Collections)
     **/
    
    FUNCTION get_polbasic_list(
        p_assd_no       GIPI_POLBASIC.ASSD_NO%type,
        p_user_id       VARCHAR2
    ) RETURN polbasic_tab PIPELINED
    AS
        rec     polbasic_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_POLBASIC
                   WHERE ISS_CD <> 'RI'
                     AND assd_no = p_assd_no
                     AND check_user_per_iss_cd_acctg2(NULL,iss_cd,'GIACS214',NVL (p_user_id,USER)) = 1
                   ORDER BY LINE_CD, SUBLINE_CD, ISS_CD, ISSUE_YY, POL_SEQ_NO,
                            ENDT_ISS_CD, ENDT_YY, ENDT_SEQ_NO)
        LOOP
            rec.policy_id       := i.policy_id;
            rec.line_cd         := i.line_cd;
            rec.subline_cd      := i.subline_cd;
            rec.iss_cd          := i.iss_cd;
            rec.issue_yy        := i.issue_yy;
            rec.pol_seq_no      := i.pol_seq_no;
            rec.endt_iss_cd     := i.endt_iss_cd;
            rec.endt_yy         := i.endt_yy;
            rec.endt_seq_no     := i.endt_seq_no;
            rec.endt_type       := i.endt_type;
            rec.ref_pol_no      := i.ref_pol_no;
            rec.assd_no         := i.assd_no;
            
            BEGIN
                SELECT assd_name
                  INTO rec.assd_name
                  FROM giis_assured
                 WHERE assd_no = i.ASSD_NO;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.assd_name := null;
            END;
            
            PIPE ROW(rec);
        END LOOP;
    END get_polbasic_list;
    
    
    FUNCTION get_invoice_list(
        p_policy_id     GIPI_INVOICE.POLICY_ID%type
    ) RETURN invoice_tab PIPELINED
    AS
        rec     invoice_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_INVOICE
                   WHERE policy_id = p_policy_id)
        LOOP
            rec.policy_id       := i.policy_id;
            rec.iss_cd          := i.iss_cd;
            rec.prem_seq_no     := i.prem_seq_no;
            
            rec.dsp_balance_amt_due     := null;
            rec.dsp_prem_balance_due    := null;
            rec.dsp_tax_balance_due     := null;
            rec.dsp_currency            := null;
            rec.dsp_currency_rt         := null;
            
            /** GET_SOA_BALANCE_DUE **/
            FOR j IN  ( SELECT balance_amt_due, prem_balance_due, tax_balance_due
                          FROM giac_aging_soa_details
                         WHERE iss_cd = i.ISS_CD
                           AND prem_seq_no = i.PREM_SEQ_NO)
            LOOP
                rec.dsp_balance_amt_due     := j.balance_amt_due;
                rec.dsp_prem_balance_due    := j.prem_balance_due;
                rec.dsp_tax_balance_due     := j.tax_balance_due;
                EXIT;
            END LOOP;
            
            
            FOR j IN  ( SELECT A.CURRENCY_DESC, A.CURRENCY_RT
                          FROM GIIS_CURRENCY A,
                               GIPI_INVOICE  B,
                               GIPI_ITEM     C
                         WHERE B.PREM_SEQ_NO = i.PREM_SEQ_NO
                           AND B.ISS_CD = i.ISS_CD
                           AND B.POLICY_ID = C.POLICY_ID
                           AND A.MAIN_CURRENCY_CD = C.CURRENCY_CD
                           AND B.ITEM_GRP = C.ITEM_GRP)
            LOOP
                rec.dsp_currency        := j.currency_desc;
                rec.dsp_currency_rt     := j.currency_rt;
            END LOOP;
            
            
            BEGIN
                SELECT ISS_CD || '-' || TO_CHAR(PREM_SEQ_NO)
                  INTO REC.DSP_ISS_PREM_SEQ
                  FROM GIPI_INVOICE
                 WHERE ISS_CD = i.ISS_CD
                  AND PREM_SEQ_NO = i.PREM_SEQ_NO;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    rec.dsp_iss_prem_seq    := null;
            END;
            
            BEGIN
               SELECT rtrim(B250.LINE_CD) || '-' || rtrim(B250.SUBLINE_CD) || '-' || rtrim(B250.ISS_CD) || '-' ||
                        ltrim(to_char(B250.ISSUE_YY,'99')) || '-' ||ltrim(to_char(B250.POL_SEQ_NO,'0999999')) || '   ' ||
                        decode(B250.ENDT_SEQ_NO,0,null,ltrim(to_char(B250.ENDT_SEQ_NO,'099999')) || ' ' || rtrim(B250.ENDT_TYPE)) 
                      ,A020.ASSD_NAME
                 INTO rec.nbt_policy_no, rec.dsp_assd_name
                 FROM GIPI_INVOICE B140,
                      GIPI_POLBASIC B250,
                      GIIS_ASSURED A020
                WHERE B140.ISS_CD = i.ISS_CD
                  AND B140.PREM_SEQ_NO = i.PREM_SEQ_NO
                  AND B250.POLICY_ID = B140.POLICY_ID
                  AND A020.ASSD_NO = B250.ASSD_NO;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.nbt_policy_no   := null;
                    rec.dsp_assd_name   := null;
            END;
            
            
            PIPE ROW(rec);
        END LOOP;
    END get_invoice_list;
    
    
    FUNCTION get_aging_soa_details(
        p_assd_no           GIPI_POLBASIC.ASSD_NO%type
    ) RETURN aging_soa_tab PIPELINED
    AS
        rec     aging_soa_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM GIAC_AGING_SOA_DETAILS
                   WHERE a020_assd_no = p_assd_no
                   ORDER BY prem_seq_no, inst_no)
        LOOP
            rec.a020_assd_no        := i.a020_assd_no;
            rec.iss_cd              := i.iss_cd;
            rec.prem_seq_no         := i.prem_seq_no;
            rec.inst_no             := i.inst_no;
            rec.total_amount_due    := i.total_amount_due;
            rec.total_payments      := i.total_payments;
            rec.tax_balance_due     := i.tax_balance_due;
            rec.balance_amt_due     := i.balance_amt_due;
            rec.prem_balance_due    := i.prem_balance_due;    
            /*rec.dsp_iss_prem_seq    := null;
            rec.dsp_currency        := null;
            rec.dsp_currency_rt     := null;*/
            
            BEGIN
                SELECT ISS_CD || '-' || TO_CHAR(PREM_SEQ_NO) iss_prem_seq
                  INTO rec.dsp_iss_prem_seq
                  FROM GIAC_AGING_SOA_DETAILS
                 WHERE ISS_CD = i.ISS_CD
                   AND PREM_SEQ_NO = i.PREM_SEQ_NO;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    rec.dsp_iss_prem_seq := null;                
            END ;
            
            FOR j IN( SELECT A.CURRENCY_DESC, A.CURRENCY_RT
                        FROM GIIS_CURRENCY A,
                             GIPI_INVOICE  B,
                             GIPI_ITEM     C
                       WHERE B.PREM_SEQ_NO = i.PREM_SEQ_NO
                         AND B.ISS_CD = i.ISS_CD
                         AND B.POLICY_ID = C.POLICY_ID
                         AND A.MAIN_CURRENCY_CD = C.CURRENCY_CD
                         AND B.ITEM_GRP = C.ITEM_GRP)
            LOOP
                rec.dsp_currency    := j.currency_desc;
                rec.dsp_currency_rt := j.currency_rt;
                EXIT;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_aging_soa_details;

END GIACS214_PKG;
/


