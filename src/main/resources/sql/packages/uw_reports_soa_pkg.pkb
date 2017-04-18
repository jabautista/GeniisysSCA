CREATE OR REPLACE PACKAGE BODY CPI.UW_REPORTS_SOA_PKG AS

FUNCTION get_uw_soa_flt (p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
    RETURN uw_soa_tab PIPELINED IS
    v_soa       uw_soa_type;

    v_assd_len                  NUMBER;
    v_assd_temp              VARCHAR2(600);
    v_intm                        VARCHAR2(50);
    v_bir_no                     VARCHAR2(50);
    v_prem_rt                   VARCHAR2(50);
    v_peril_name              VARCHAR2(50);
    v_currency_desc          VARCHAR2(50);
    v_tsi_amt                   NUMBER;
    v_prem_amt              NUMBER;
    v_evat_amt                  NUMBER;
    v_tax_amt                   NUMBER;
    v_tax_rate                  NUMBER;
    v_vatable_amt           NUMBER;
    v_zero_rt                   NUMBER;
    v_vat_exempt            NUMBER;

  BEGIN
   FOR A IN (SELECT B250.POLICY_ID  POLICY_ID, A150.LINE_NAME || '/' LINE_NAME, A210.SUBLINE_NAME SUBLINE_NAME
       , B250.LINE_CD || '-' || B250.SUBLINE_CD || '-' || B250.ISS_CD || '-' || LTRIM(TO_CHAR(B250.ISSUE_YY,'09')) || '-' || LTRIM(TO_CHAR(B250.POL_SEQ_NO,'0999999')) || '-' || ltrim(to_char(B250.RENEW_NO,'09')) POLICYNO
       ,B250.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B250.ENDT_YY,'09')) || '-' || LTRIM(TO_CHAR(B250.ENDT_SEQ_NO,'099999')) || B250.ENDT_TYPE ENDTNO
       ,B140.ISS_CD || '-' || LTRIM(TO_CHAR(B140.PREM_SEQ_NO,'09999999')) PREMSEQNO
       ,B250.ENDT_SEQ_NO ENDT_SEQ_NO, B140.PREM_SEQ_NO PREM_SEQ_NO
       ,A020.ASSD_NAME ASSD_NAME, A020.ASSD_NAME2 ASSD_NAME2, A020.DESIGNATION DESIGNATION
       ,LTRIM(RTRIM(A020.ASSD_TIN)) ASSD_TIN
       ,DECODE(B250.ENDT_SEQ_NO,0,B250.ADDRESS1,B240.ADDRESS1)  ADDRESS1
       ,DECODE(B250.ENDT_SEQ_NO,0,B250.ADDRESS2,B240.ADDRESS2)  ADDRESS2
       ,DECODE(B250.ENDT_SEQ_NO,0,B250.ADDRESS3,B240.ADDRESS3)  ADDRESS3
       ,B250.NO_OF_ITEMS NO_OF_ITEMS, B250.INCEPT_TAG  INCEPT_TAG, B250.EXPIRY_TAG  EXPIRY_TAG
       ,B250.ISSUE_DATE ISSUE_DATE
       ,B250.EFF_DATE EFF_DATE
       ,DECODE(B250.INCEPT_TAG, 'Y', 'T.B.A.', TO_CHAR(DECODE(B250.ENDT_SEQ_NO,0,B250.INCEPT_DATE,B250.EFF_DATE),'fmMon DD, YYYY')) P_FROMDATE
       ,DECODE(B250.EXPIRY_TAG, 'Y', 'T.B.A.',  TO_CHAR(DECODE(B250.ENDT_SEQ_NO,0,B250.EXPIRY_DATE,B250.ENDT_EXPIRY_DATE),'fmMon DD, YYYY')) P_TODATE
       ,B240.PAR_ID PAR_ID, B140.ISS_CD ISS_CD, B140.ITEM_GRP ITEM_GRP
       ,B140.REMARKS REMARKS, B140.OTHER_CHARGES OTHER_CHARGES, B140.PROPERTY PROPERTY
       ,'*' || B250.USER_ID||'/'||USER|| '* -'  USER_ID, B250.CO_INSURANCE_SW CO_INSURANCE_SW
FROM GIPI_POLBASIC B250
         ,GIPI_PARLIST B240
         ,GIPI_INVOICE B140
         ,GIIS_LINE A150
         ,GIIS_SUBLINE A210
         ,GIIS_ASSURED A020
WHERE  B250.PAR_ID = B240.PAR_ID
  AND B250.LINE_CD = A150.LINE_CD
  AND B250.LINE_CD = A210.LINE_CD
  AND B250.SUBLINE_CD = A210.SUBLINE_CD
  AND B240.ASSD_NO = A020.ASSD_NO
  AND B250.POLICY_ID = B140.POLICY_ID
  AND B250.POLICY_ID = p_policy_id)

    LOOP
      v_soa.policy_id       := A.policy_id;
      V_soa.line_name       := A.line_name;
      v_soa.subline_name    := A.subline_name;
      v_soa.policyno        := A.policyno;
      v_soa.endtno          := A.endtno;
      v_soa.premseqno       := A.premseqno;
      v_soa.endt_seq_no     := A.endt_seq_no;
      v_soa.prem_seq_no     := A.prem_seq_no;
      v_soa.item_grp        := A.item_grp;
      v_soa.assd_tin        := A.assd_tin;
      v_soa.address1        := A.address1;
      v_soa.address2        := A.address2;
      v_soa.address3        := A.address3;
      v_soa.issue_date      := A.issue_date;
      v_soa.eff_date        := A.eff_date;
      v_soa.fromdate        := A.p_fromdate;
      v_soa.todate          := A.p_todate;
      v_soa.par_id          := A.par_id;
      v_soa.iss_cd          := A.iss_cd;
      v_soa.remarks         := A.remarks;
      v_soa.other_charges   := A.other_charges;
      v_soa.property        := A.property;
      v_soa.user_id         := A.user_id;
      v_soa.co_insurance_sw := A.co_insurance_sw;

      --assd_name
      v_assd_temp           := NVL(TRIM(A.designation), '') || ' ' || NVL(TRIM(A.assd_name), '') || ' ' || NVL(TRIM(A.assd_name2), '');
      v_assd_len            := LENGTH(v_assd_temp);
      IF v_assd_len > 50 THEN
        v_soa.assd_name     := TRIM(NVL(TRIM(A.designation), '') || ' ' || NVL(TRIM(A.assd_name), '') || CHR(10) || NVL(TRIM(A.assd_name2), ''));
        ELSE
        v_soa.assd_name     := TRIM(v_assd_temp);
      END IF;

      --intermediary no
      FOR i IN (SELECT intrmdry_intm_no FROM gipi_comm_invoice
                        WHERE iss_cd = A.iss_cd
                            AND prem_seq_no = A.prem_seq_no)
        LOOP
            v_intm := v_intm ||'/ '|| TO_CHAR(i.intrmdry_intm_no);
        END LOOP;
           v_soa.intm_no    := LTRIM(v_intm,'/');

      --BIR NO
        SELECT param_value_v INTO v_bir_no FROM giac_parameters
            WHERE param_name = 'BIR_PERMIT_NO';
            v_soa.bir_no    := v_bir_no;

      --currency
      BEGIN
        SELECT DISTINCT A430.currency_desc INTO v_currency_desc
            FROM gipi_item B170, giis_currency A430
            WHERE B170.currency_cd = A430.main_currency_cd
                AND B170.policy_id = p_policy_id;
        EXCEPTION WHEN TOO_MANY_ROWS THEN
            v_currency_desc := 'various currency';
      END;
            v_soa.currency_desc     := v_currency_desc;

      IF A.co_insurance_sw = 2 THEN
        -- Prem rate (coin = 2)
        BEGIN
            SELECT DISTINCT TO_CHAR(prem_rt, '999.999999999') INTO v_prem_rt
                FROM gipi_orig_itmperil
                WHERE par_id = A.par_id;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                v_prem_rt   := 'various rates';
        END;
        -- Peril name (coin = 2)
        BEGIN
            SELECT DISTINCT A170.peril_name INTO v_peril_name
                FROM gipi_orig_itmperil B380, giis_peril A170
                WHERE B380.par_id = A.par_id
                    AND B380.peril_cd = A170.peril_cd;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                 v_peril_name := 'various risks';
        END;
         -- TSI amount  (coin = 2)
        BEGIN
        SELECT tsi_amt INTO v_tsi_amt
            FROM gipi_main_co_ins
            WHERE par_id = A.par_id;
        SELECT prem_amt INTO v_prem_amt
            FROM gipi_orig_invoice
            WHERE par_id = A.par_id;
        SELECT tax_amt, rate INTO v_evat_amt, v_tax_rate
             FROM gipi_orig_inv_tax
             WHERE par_id = A.par_id
                 AND item_grp = A.item_grp
                 AND tax_cd = GIISP.N('EVAT');
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
            IF v_evat_amt > 0 THEN
                v_vatable_amt   := (v_evat_amt/(v_tax_rate/100));
                IF v_prem_amt != v_vatable_amt THEN
                    IF abs(v_vatable_amt - v_prem_amt) <= 1 THEN
                        v_vatable_amt := v_prem_amt;
                    END IF;
                END IF;
                v_zero_rt       := 0;
                v_vat_exempt    := 0;
            ELSIF v_evat_amt = 0 OR v_evat_amt IS NULL THEN
                v_vatable_amt   := 0;
                v_zero_rt       := 0;
                v_vat_exempt    := v_prem_amt;
            END IF;
      ELSE
        -- Prem rate (coin != 2)
        BEGIN
            SELECT DISTINCT TO_CHAR(prem_rt, '999.999999999') INTO v_prem_rt
                FROM gipi_itmperil
                WHERE policy_id = p_policy_id;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                v_prem_rt   := 'various rates';
        END;
        --Peril Name (coin != 2)
        BEGIN
            SELECT DISTINCT A170.peril_name INTO v_peril_name
                FROM gipi_itmperil B180, giis_peril A170
                WHERE B180.policy_id = p_policy_id
                    AND B180.peril_cd = A170.peril_cd;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                v_peril_name := 'various risks';
        END;
        -- TSI amount  (coin != 2)
        BEGIN
        SELECT sum(tsi_amt), sum(prem_amt) INTO v_tsi_amt, v_prem_amt
            FROM gipi_item
            WHERE policy_id = A.policy_id
            AND item_grp = A.item_grp;

        SELECT tax_amt, rate INTO v_evat_amt, v_tax_rate
            FROM gipi_inv_tax
              WHERE iss_cd = A.iss_cd
                 AND prem_seq_no = A.prem_seq_no
                 AND item_grp = A.item_grp
                 AND tax_cd = GIISP.N('EVAT');
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
            IF v_evat_amt > 0 THEN
                v_vatable_amt   := (v_evat_amt/(v_tax_rate/100));
                IF v_prem_amt != v_vatable_amt THEN
                    IF abs(v_vatable_amt - v_prem_amt) <= 1 THEN
                        v_vatable_amt := v_prem_amt;
                    END IF;
                END IF;
                v_zero_rt       := 0;
                v_vat_exempt    := 0;
            ELSIF v_evat_amt = 0 OR v_evat_amt IS NULL THEN
                v_vatable_amt   := 0;
                v_zero_rt       := 0;
                v_vat_exempt    := v_prem_amt;
            END IF;
      END IF;
            v_soa.tsi_amt       := NVL(v_tsi_amt, 0);
            v_soa.prem_amt      := NVL(v_prem_amt, 0);
            v_soa.vatable_amt   := NVL(v_vatable_amt, 0);
            v_soa.zero_rated    := NVL(v_zero_rt, 0);
            v_soa.vat_exempt    := NVL(v_vat_exempt, 0);
            v_soa.prem_rt       := v_prem_rt;
            v_soa.peril_name    := v_peril_name;

      PIPE ROW(v_soa);
    END LOOP;
    RETURN;
  END get_uw_soa_flt;

FUNCTION get_uw_soa_peril_flt(p_policy_id GIPI_POLBASIC.policy_id%TYPE,
        p_prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE,
        p_iss_cd          GIPI_INVOICE.ISS_CD%TYPE,
        p_co_insurance_sw GIPI_POLBASIC.co_insurance_sw%TYPE)
    RETURN uw_soa_peril_tab PIPELINED IS

    v_soa_peril     uw_soa_peril_type;

    BEGIN

        IF p_co_insurance_sw = 2 THEN

            FOR c IN (SELECT B180.POLICY_ID POLICY_ID
                        ,SUM(NVL(B180.PREM_AMT,0)) PERIL_PREM_AMT
                        ,B340.ITEM_GRP ITEM_GRP
                        ,A170.PERIL_SNAME PERIL_SNAME
                        ,B140.PREM_SEQ_NO PREM_SEQ_NO
                        ,B140.ISS_CD ISS_CD
                      FROM GIPI_ITEM  B340
                         ,GIPI_ORIG_ITMPERIL B180
                         ,GIPI_ORIG_INVOICE B140
                         ,GIIS_PERIL A170
                      WHERE B180.PERIL_CD = A170.PERIL_CD
                         AND B180.ITEM_NO = B340.ITEM_NO
                         AND B140.ITEM_GRP = B340.ITEM_GRP
                         AND B180.LINE_CD = A170.LINE_CD
                         AND B180.POLICY_ID = B340.POLICY_ID
                         AND B140.POLICY_ID= B340.POLICY_ID
                         AND B340.POLICY_ID  = p_policy_id
                         AND B140.PREM_SEQ_NO= p_prem_seq_no
                         AND B140.ISS_CD     = p_iss_cd
                     GROUP BY B180.POLICY_ID, B340.ITEM_GRP, A170.PERIL_SNAME, B140.PREM_SEQ_NO, B140.ISS_CD
                        ORDER BY PERIL_SNAME)
            LOOP
                v_soa_peril.peril_prem_amt  := c.PERIL_PREM_AMT;
                v_soa_peril.peril_sname     := c.PERIL_SNAME;
                v_soa_peril.policy_id       := c.POLICY_ID;

                PIPE ROW(v_soa_peril);
            END LOOP;


        ELSE

            FOR d IN (SELECT B180.POLICY_ID POLICY_ID
                        ,SUM(NVL(B180.PREM_AMT,0)) PERIL_PREM_AMT
                        ,B340.ITEM_GRP ITEM_GRP
                        ,A170.PERIL_SNAME PERIL_SNAME
                        ,B140.PREM_SEQ_NO PREM_SEQ_NO
                        ,B140.ISS_CD ISS_CD
                    FROM  GIPI_ITEM  B340
                        ,GIPI_ITMPERIL B180
                        ,GIPI_INVOICE B140
                        ,GIIS_PERIL A170
                    WHERE B180.PERIL_CD = A170.PERIL_CD
                        AND B180.ITEM_NO    = B340.ITEM_NO
                        AND B140.ITEM_GRP   = B340.ITEM_GRP
                        AND B180.LINE_CD    = A170.LINE_CD
                        AND B180.POLICY_ID  = B340.POLICY_ID
                        AND B140.POLICY_ID  = B340.POLICY_ID
                        AND B340.POLICY_ID  = p_policy_id
                        AND B140.PREM_SEQ_NO= p_prem_seq_no
                        AND B140.ISS_CD     = p_iss_cd
                    GROUP BY B180.POLICY_ID, B340.ITEM_GRP, A170.PERIL_SNAME, B140.PREM_SEQ_NO, B140.ISS_CD
                      ORDER BY PERIL_SNAME)

            LOOP
                v_soa_peril.policy_id          := d.policy_id;
                v_soa_peril.item_grp           := d.item_grp;
                v_soa_peril.peril_sname        := d.peril_sname;
                v_soa_peril.peril_prem_amt     := d.peril_prem_amt;

                PIPE ROW(v_soa_peril);
            END LOOP;

        END IF;

        RETURN;
    END get_uw_soa_peril_flt;

FUNCTION get_uw_soa_tax_flt(p_policy_id GIPI_POLBASIC.policy_id%TYPE,
        p_prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE,
        p_iss_cd          GIPI_INVOICE.ISS_CD%TYPE,
        p_co_insurance_sw GIPI_POLBASIC.co_insurance_sw%TYPE)
    RETURN uw_soa_tax_tab PIPELINED IS

    v_soa_tax     uw_soa_tax_type;

    BEGIN

        IF p_co_insurance_sw = 2 THEN

            FOR f IN(SELECT B140.policy_id POLICY_ID, B140.item_grp ITEM_GRP
                        ,B330.tax_cd TAX_CD, B330.tax_amt TAX_AMT ,A230.tax_desc TAX_DESC
                                FROM gipi_orig_invoice B140,
                                     gipi_orig_inv_tax B330,
                                     giis_tax_charges A230
                             WHERE 1=1
                                 AND B140.par_id = B330.par_id
                                 AND B140.item_grp = B330.item_grp
                                 AND B330.tax_cd = A230.tax_cd
                                 AND B330.tax_id = A230.tax_id
                                 AND B330.iss_cd  = A230.iss_cd
                                 AND B330.line_cd = A230.line_cd
                                 AND B140.POLICY_ID  = p_policy_id
                                 AND B140.PREM_SEQ_NO= p_prem_seq_no
                                 AND B140.ISS_CD     = p_iss_cd
                        ORDER BY B330.item_grp, A230.sequence)

            LOOP
                v_soa_tax.policy_id     := f.POLICY_ID;
                v_soa_tax.item_grp      := f.ITEM_GRP;
                v_soa_tax.tax_desc      := f.TAX_DESC;
                v_soa_tax.tax_amt       := f.TAX_AMT;

                PIPE ROW(v_soa_tax);
            END LOOP;


        ELSE

            FOR g IN (SELECT  B140.POLICY_ID POLICY_ID
                        ,B140.ITEM_GRP ITEM_GRP
                        ,B140.PREM_SEQ_NO PREM_SEQ_NO
                        ,B140.ISS_CD ISS_CD
                        ,NVL(B330.TAX_AMT,0) TAX_AMT
                        ,A230.TAX_DESC TAX_DESC
                        ,B330.TAX_CD TAX_CD
                    FROM    GIPI_INVOICE B140
                           ,GIPI_INV_TAX B330
                           ,GIIS_TAX_CHARGES A230
                    WHERE B140.PREM_SEQ_NO = B330.PREM_SEQ_NO
                      AND B140.ISS_CD  = B330.ISS_CD
                      AND B330.ISS_CD  = A230.ISS_CD
                      AND B330.LINE_CD = A230.LINE_CD
                      AND B330.TAX_CD  = A230.TAX_CD
                      AND B330.TAX_ID  = A230.TAX_ID
                      AND B140.POLICY_ID  = p_policy_id
                      AND B140.PREM_SEQ_NO= p_prem_seq_no
                      AND B140.ISS_CD     = p_iss_cd
                    ORDER BY B140.ITEM_GRP, A230.sequence)

            LOOP
                v_soa_tax.policy_id     := g.POLICY_ID;
                v_soa_tax.item_grp      := g.ITEM_GRP;
                v_soa_tax.tax_desc      := g.TAX_DESC;
                v_soa_tax.tax_amt       := g.TAX_AMT;

                PIPE ROW(v_soa_tax);
            END LOOP;

        END IF;

        RETURN;
    END get_uw_soa_tax_flt;

FUNCTION get_uw_soa_seici (p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
    RETURN uw_soa_seici_tab PIPELINED IS
    v_soa       uw_soa_seici_type;

    v_assd_len                  NUMBER;
    v_assd_temp              VARCHAR2(600);
    v_intm                        VARCHAR2(50);
    v_bir_no                     VARCHAR2(50);
    v_prem_rt                   VARCHAR2(50);
    v_peril_name              VARCHAR2(50);
    v_currency_desc          VARCHAR2(50);
    v_tsi_amt                   NUMBER;
    v_prem_amt              NUMBER;
    v_evat_amt                  NUMBER;
    v_tax_amt                   NUMBER;
    v_tax_rate                  NUMBER;
    v_vatable_amt           NUMBER;
    v_zero_rt                   NUMBER;
    v_vat_exempt            NUMBER;

BEGIN
    FOR s IN (SELECT DISTINCT 1 rowcount
       ,b250.policy_id  policy_id
       ,b250.par_id
       ,b250.incept_tag incept_tag
       ,b250.expiry_tag expiry_tag
       ,a150.line_name line_name
       ,a210.subline_name subline_name
       ,a210.subline_time subline_time
       ,b250.no_of_items no_of_items
       ,b250.issue_date issue_date
       ,DECODE(b250.endt_seq_no,0,TO_CHAR(b250.incept_date,'MM/DD/YYYY'),TO_CHAR(b250.eff_date,'MM/DD/YYYY')) fromdate
       ,DECODE(b250.expiry_tag,'Y',ltrim('T.B.A.'),TO_CHAR(b250.expiry_date,'MM/DD/YYYY'))    todate
       ,TO_CHAR(b250.expiry_date,'fmMonth DD, YYYY') expiry_date
       ,b250.line_cd || '-' || b250.subline_cd || '-' || b250.iss_cd || '-' || LTRIM(TO_CHAR(b250.issue_yy,'09')) || '-' ||LTRIM(TO_CHAR(b250.pol_seq_no,'0999999')) || '-' || LTRIM(TO_CHAR(b250.renew_no,'09')) policyno
       ,b250.eff_date eff_date
       ,b250.endt_seq_no endt_seq_no
       ,b250.endt_iss_cd || '-' || LTRIM(TO_CHAR(b250.endt_yy,'09')) || '-' || LTRIM(TO_CHAR(b250.endt_seq_no,'099999')) || b250.endt_type endtno
       ,DECODE(a020.designation, NULL, a020.assd_name ||' ' ||a020.assd_name2
       ,a020.designation || ' ' || a020.assd_name ||' '|| a020.assd_name2) assd_name
       ,a020.assd_no assd_no
       ,b250.acct_of_cd
       ,DECODE(b250.endt_seq_no,0,b250.address1,b240.address1)  address1
       ,DECODE(b250.endt_seq_no,0,b250.address2,b240.address2)  address2
       ,DECODE(b250.endt_seq_no,0,b250.address3,b240.address3)  address3
       ,b140.prem_seq_no prem_seq_no
       ,b140.iss_cd iss_cd1
       ,b140.item_grp item_grp
       ,b140.iss_cd || '-' || LTRIM(TO_CHAR(b140.prem_seq_no,'000009999999')) premseqno
       ,NVL(b140.other_charges, 0) other_charges
       ,b140.property property
       ,b140.remarks remarks
       ,a430.currency_desc currency_desc
       ,a430.main_currency_cd currency_cd
       ,a430.short_name short_name
       ,b250.mortg_name mortg_name
       ,b250.user_id
       ,b250.line_cd  line_cd
       ,b250.subline_cd subline_cd
       ,b250.iss_cd  iss_cd
       ,b250.issue_yy  issue_yy
       ,b250.pol_seq_no  pol_seq_no
       ,b250.renew_no  renew_no
       ,b250.ref_pol_no ref_pol_no
       ,DECODE(NVL(label_tag,'N'), 'Y', 'Leased To : ', 'In Account Of : ') label_tag
       ,(LPAD(giis_issource.acct_iss_cd,2,0)||b140.prem_seq_no) acct_iss_cd
       ,NVL(b250.acct_of_cd_sw,'N') acct_of_cd_sw
       ,NVL(b250.acct_of_cd,0) acctofcd
       ,B250.CO_INSURANCE_SW CO_INSURANCE_SW
FROM   GIPI_POLBASIC b250
      ,GIPI_PARLIST b240
      ,GIPI_INVOICE b140
      ,GIPI_ITEM b170
      ,GIPI_ITMPERIL b180
      ,GIIS_LINE a150
      ,GIIS_SUBLINE a210
      ,GIIS_ASSURED a020
      ,GIIS_PERIL a170
      ,GIIS_CURRENCY a430
      ,GIIS_ISSOURCE
WHERE b250.par_id = b240.par_id
      AND b250.line_cd = b180.line_cd
      AND b250.line_cd = a170.line_cd
      AND b250.line_cd = a150.line_cd
      AND b250.line_cd = a210.line_cd
      AND b180.line_cd = a170.line_cd
      AND b180.peril_cd = a170.peril_cd
      AND b250.subline_cd = a210.subline_cd
      AND b240.assd_no = a020.assd_no
      AND b140.item_grp = b170.item_grp
      AND b170.item_no = b180.item_no
      AND b170.currency_cd = a430.main_currency_cd
      AND b250.policy_id = b140.policy_id
      AND b250.policy_id = b170.policy_id
      AND b250.policy_id = b180.policy_id
      AND b170.policy_id = b180.policy_id
      AND b250.iss_cd    = giis_issource.iss_cd
      AND b140.iss_cd    = giis_issource.iss_cd
      AND b250.policy_id = p_policy_id)

      LOOP
        v_soa.policy_id            := s.policy_id;
        v_soa.par_id            := s.par_id;
        v_soa.incept_tag        := s.incept_tag;
        v_soa.expiry_tag        := s.expiry_tag;
        v_soa.line_name            := s.line_name;
        v_soa.subline_name        := s.subline_name;
        v_soa.subline_time        := s.subline_time;
        v_soa.no_of_items        := s.no_of_items;
        v_soa.issue_date        := s.issue_date;
        v_soa.fromdate            := s.fromdate;
        v_soa.todate            := s.todate;
        v_soa.expiry_date        := s.expiry_date;
        v_soa.policyno            := s.policyno;
        v_soa.eff_date            := s.eff_date;
        v_soa.endt_seq_no        := s.endt_seq_no;
        v_soa.endtno            := s.endtno;
        v_soa.assd_name            := s.assd_name;
        v_soa.assd_no            := s.assd_no;
        v_soa.acct_of_cd        := s.acct_of_cd;
        v_soa.address1            := s.address1;
        v_soa.address2            := s.address2;
        v_soa.address3            := s.address3;
        v_soa.prem_seq_no        := s.prem_seq_no;
        v_soa.iss_cd1            := s.iss_cd1;
        v_soa.item_grp            := s.item_grp;
        v_soa.premseqno            := s.premseqno;
        v_soa.other_charges        := s.other_charges;
        v_soa.property            := s.property;
        v_soa.remarks            := s.remarks;
        v_soa.currency_desc        := s.currency_desc;
        v_soa.currency_cd        := s.currency_cd;
        v_soa.short_name        := s.short_name;
        v_soa.mortg_name        := s.mortg_name;
        v_soa.user_id            := s.user_id;
        v_soa.line_cd            := s.line_cd;
        v_soa.subline_cd        := s.subline_cd;
        v_soa.iss_cd            := s.iss_cd;
        v_soa.issue_yy            := s.issue_yy;
        v_soa.pol_seq_no        := s.pol_seq_no;
        v_soa.renew_no            := s.renew_no;
        v_soa.ref_pol_no        := s.ref_pol_no;
        v_soa.label_tag            := s.label_tag;
        v_soa.acct_iss_cd        := s.acct_iss_cd;
        v_soa.acct_of_cd_sw        := s.acct_of_cd_sw;
        v_soa.acctofcd             := s.acctofcd;
        v_soa.co_insurance_sw     := s.co_insurance_sw;

        IF s.co_insurance_sw = 2 THEN
        -- Prem rate (coin = 2)
        BEGIN
            SELECT DISTINCT TO_CHAR(prem_rt, '999.999999999') INTO v_prem_rt
                FROM gipi_orig_itmperil
                WHERE par_id = s.par_id;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                v_prem_rt   := 'various rates';
        END;
        -- Peril name (coin = 2)
        BEGIN
            SELECT DISTINCT A170.peril_name INTO v_peril_name
                FROM gipi_orig_itmperil B380, giis_peril A170
                WHERE B380.par_id = s.par_id
                    AND B380.peril_cd = A170.peril_cd;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                 v_peril_name := 'various risks';
        END;
         -- TSI amount  (coin = 2)
        BEGIN
        SELECT tsi_amt INTO v_tsi_amt
            FROM gipi_main_co_ins
            WHERE par_id = s.par_id;
        SELECT prem_amt INTO v_prem_amt
            FROM gipi_orig_invoice
            WHERE par_id = s.par_id;
        SELECT tax_amt, rate INTO v_evat_amt, v_tax_rate
             FROM gipi_orig_inv_tax
             WHERE par_id = s.par_id
                 AND item_grp = s.item_grp
                 AND tax_cd = GIISP.N('EVAT');
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
            IF v_evat_amt > 0 THEN
                v_vatable_amt   := (v_evat_amt/(v_tax_rate/100));
                IF v_prem_amt != v_vatable_amt THEN
                    IF abs(v_vatable_amt - v_prem_amt) <= 1 THEN
                        v_vatable_amt := v_prem_amt;
                    END IF;
                END IF;
                v_zero_rt       := 0;
                v_vat_exempt    := 0;
            ELSIF v_evat_amt = 0 OR v_evat_amt IS NULL THEN
                v_vatable_amt   := 0;
                v_zero_rt       := 0;
                v_vat_exempt    := v_prem_amt;
            END IF;
      ELSE
        -- Prem rate (coin != 2)
        BEGIN
            SELECT DISTINCT TO_CHAR(prem_rt, '999.999999999') INTO v_prem_rt
                FROM gipi_itmperil
                WHERE policy_id = p_policy_id;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                v_prem_rt   := 'various rates';
        END;
        --Peril Name (coin != 2)
        BEGIN
            SELECT DISTINCT A170.peril_name INTO v_peril_name
                FROM gipi_itmperil B180, giis_peril A170
                WHERE B180.policy_id = p_policy_id
                    AND B180.peril_cd = A170.peril_cd;
            EXCEPTION WHEN TOO_MANY_ROWS THEN
                v_peril_name := 'various risks';
        END;
        -- TSI amount  (coin != 2)
        BEGIN
        SELECT sum(tsi_amt), sum(prem_amt) INTO v_tsi_amt, v_prem_amt
            FROM gipi_item
            WHERE policy_id = s.policy_id
            AND item_grp = s.item_grp;

        SELECT tax_amt, rate INTO v_evat_amt, v_tax_rate
            FROM gipi_inv_tax
              WHERE iss_cd = s.iss_cd
                 AND prem_seq_no = s.prem_seq_no
                 AND item_grp = s.item_grp
                 AND tax_cd = GIISP.N('EVAT');
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
            IF v_evat_amt > 0 THEN
                v_vatable_amt   := (v_evat_amt/(v_tax_rate/100));
                IF v_prem_amt != v_vatable_amt THEN
                    IF abs(v_vatable_amt - v_prem_amt) <= 1 THEN
                        v_vatable_amt := v_prem_amt;
                    END IF;
                END IF;
                v_zero_rt       := 0;
                v_vat_exempt    := 0;
            ELSIF v_evat_amt = 0 OR v_evat_amt IS NULL THEN
                v_vatable_amt   := 0;
                v_zero_rt       := 0;
                v_vat_exempt    := v_prem_amt;
            END IF;
      END IF;

        v_soa.tsi_amt       := NVL(v_tsi_amt, 0);
        v_soa.prem_amt      := NVL(v_prem_amt, 0);
        v_soa.vatable_amt   := NVL(v_vatable_amt, 0);
        v_soa.zero_rated    := NVL(v_zero_rt, 0);
        v_soa.vat_exempt    := NVL(v_vat_exempt, 0);
        v_soa.prem_rt       := v_prem_rt;
        v_soa.peril_name    := v_peril_name;

        PIPE ROW(v_soa);

      END LOOP;

END get_uw_soa_seici;

FUNCTION get_uw_soa_peril_seici(p_policy_id       GIPI_POLBASIC.policy_id%TYPE,
                                p_prem_seq_no     GIPI_INVOICE.prem_seq_no%TYPE)
    RETURN uw_soa_seici_peril_tab PIPELINED IS

    v_soa_peril     uw_soa_seici_peril_type;

    BEGIN

    FOR p IN (SELECT b250.policy_id policy_id
                  ,b140.iss_cd iss_cd
                  ,b140.prem_seq_no prem_seq_no
                  ,b140.item_grp item_grp
                  ,a101.peril_sname peril_sname
                  ,b150.tsi_amt tsi_amt
                  ,DECODE(NVL(B140.POLICY_CURRENCY,'N'),'N',( nvl(B150.PREM_AMT,0) *  B140.CURRENCY_RT), nvl(B150.PREM_AMT,0)) prem_amt
                  ,b250.line_cd
                  ,a101.SEQUENCE SEQUENCE
                  ,a101.peril_type peril_type
                  ,a101.basc_perl_cd basc_perl_cd
                  ,a101.peril_cd peril_cd
            FROM  GIPI_POLBASIC b250,
                  GIPI_INVOICE b140,
                  GIPI_INVPERIL b150,
                  GIIS_PERIL a101
            WHERE b250.policy_id = b140.policy_id
                  AND b140.iss_cd = b150.iss_cd
                  AND b140.prem_seq_no = b150.prem_seq_no
                  AND b150.peril_cd = a101.peril_cd
                  AND b250.line_cd = a101.line_cd
                  AND B250.policy_id = p_policy_id
                  AND B140.prem_seq_no = p_prem_seq_no
            ORDER BY b140.item_grp)

            LOOP
                v_soa_peril.policy_id        :=    p.policy_id;
                v_soa_peril.iss_cd            :=    p.iss_cd;
                v_soa_peril.prem_seq_no        :=    p.prem_seq_no;
                v_soa_peril.item_grp        :=    p.item_grp;
                v_soa_peril.peril_sname        :=    p.peril_sname;
                v_soa_peril.tsi_amt            :=    p.tsi_amt;
                v_soa_peril.prem_amt        :=    p.prem_amt;
                v_soa_peril.line_cd            :=    p.line_cd;
                v_soa_peril.SEQUENCE        :=    p.SEQUENCE;
                v_soa_peril.peril_type        :=    p.peril_type;
                v_soa_peril.basc_perl_cd    :=    p.basc_perl_cd;
                v_soa_peril.peril_cd        :=    p.peril_cd;

                PIPE ROW(v_soa_peril);

            END LOOP;

    END get_uw_soa_peril_seici;

FUNCTION get_uw_soa_tax_seici(p_policy_id       GIPI_POLBASIC.policy_id%TYPE,
                              p_prem_seq_no     GIPI_INVOICE.PREM_SEQ_NO%TYPE)

    RETURN uw_soa_seici_tax_tab PIPELINED IS

    v_soa_tax     uw_soa_seici_tax_type;

    BEGIN

    FOR tax IN (SELECT b140.policy_id policy_id
                      ,b140.item_grp item_grp
                      ,b140.prem_seq_no prem_seq_no
                      ,b140.iss_cd iss_cd
                      ,b140.other_charges other_charges
                      ,DECODE(NVL(b140.policy_currency,'N'),'N',( NVL(b330.tax_amt,0) *  b140.currency_rt), NVL(b330.tax_amt,0)) tax_amt
                      ,a230.tax_desc tax_desc
                      ,b330.tax_cd tax_cd
                FROM GIPI_INVOICE b140
                      ,GIPI_INV_TAX b330
                      ,GIIS_TAX_CHARGES a230
                WHERE b140.prem_seq_no = b330.prem_seq_no
                      AND b140.iss_cd  = b330.iss_cd
                      AND b330.iss_cd  = a230.iss_cd
                      AND b330.line_cd = a230.line_cd
                      AND b330.tax_cd  = a230.tax_cd
                      AND b330.tax_id  = a230.tax_id
                      AND b140.policy_id = p_policy_id
                      AND b140.prem_seq_no = p_prem_seq_no
                ORDER BY b140.item_grp,tax_cd)
    LOOP
        v_soa_tax.policy_id     := tax.policy_id;
        v_soa_tax.item_grp        := tax.item_grp;
        v_soa_tax.prem_seq_no    := tax.prem_seq_no;
        v_soa_tax.iss_cd        := tax.iss_cd;
        v_soa_tax.other_charges    := tax.other_charges;
        v_soa_tax.tax_amt        := tax.tax_amt;
        v_soa_tax.tax_desc        := tax.tax_desc;
        v_soa_tax.tax_cd        := tax.tax_cd;

        PIPE ROW (v_soa_tax);

    END LOOP;

    END get_uw_soa_tax_seici;



END UW_REPORTS_SOA_PKG;
/


