DROP PROCEDURE CPI.CREATE_WINVOICE_102708;

CREATE OR REPLACE PROCEDURE CPI.Create_Winvoice_102708(p_policy_id  IN NUMBER,
                                            p_pol_id_n   IN NUMBER,
                                            p_old_par_id IN NUMBER,
                                            p_par_id     IN NUMBER,
                                            p_line_cd    IN VARCHAR2,
                                            p_iss_cd     IN VARCHAR2) IS
/*
** parameter p_policy_id, p_pol_id_n and p_old_par_id added so as to handle fetching of the proper tax_cd
** of the old policy or old par per item grouping(s)
** added by : aivhie
** date     : 112301
*/
/* last modified by bdarusin, 12022002
** all codes re validation of doc stamps parameter were added,
** as compared with old create winvoice
*/
/*
** modified by gmi to handle LONG TERM policies
** default due dates for gipi_winvoice are now included for LONG TERM policies
** SINGLE TAKE-UP retains the original process
*/
--
-- used by item-peril module to create an initial value for invoice module.
-- taxes selection from maintenace tables are also performed.
--

/* Modified By:  Jason  9/3/2008
** Modification:  Handling of taxes allocation per takeup
*/

/* modified by aaron
** modified on 100608
** remarks:  added the parameter v_peril_sw2. this parameter will check if the tax_cd is required
**           AND peril-dependent.  If the required peril is in gipi_witmperil, the tax_Cd will be inserted
**           in gipi_winv_tax. Otherwise, it will not be inserted.
*/



  CURSOR a1 IS
    SELECT NVL(eff_date,incept_date) eff_date, issue_date, place_cd,
           endt_expiry_date, expiry_date, takeup_term, --added by gmi 120607 --
           BOOKING_MTH, BOOKING_YEAR
      FROM GIPI_WPOLBAS
     WHERE par_id  =  p_par_id;

  CURSOR c1 IS
    SELECT b.item_grp,     A.peril_cd,
           b.currency_cd,  b.currency_rt,
           SUM(NVL(A.prem_amt,0)) prem_amt,
           SUM(NVL(A.tsi_amt,0)) tsi_amt,
           SUM(NVL(A.ri_comm_amt,0)) ri_comm_amt,
           DECODE(SUM(NVL(A.prem_amt,0)), 0,
           AVG(A.ri_comm_rate),
           (SUM(NVL(A.prem_amt,0) * NVL(A.ri_comm_rate,0) / 100)/SUM(NVL(A.prem_amt,0)) * 100)) ri_comm_rt
      FROM GIPI_WITMPERL A, GIPI_WITEM b
     WHERE A.par_id  = p_par_id
       AND A.par_id  = b.par_id
       AND A.item_no = b.item_no
     GROUP BY b.par_id,      b.item_grp,   A.peril_cd,
              b.currency_cd, b.currency_rt
     ORDER BY b.item_grp;

  CURSOR d1 IS --added by bdarusin, copied from old create_winvoice
    SELECT param_value_n
      FROM GIAC_PARAMETERS
     WHERE param_name = 'DOC_STAMPS';

  CURSOR e1 IS
    SELECT param_value_v
      FROM GIIS_PARAMETERS
     WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS';

  p_doc_stamps        GIIS_TAX_CHARGES.tax_cd%TYPE;
  v_param_old_doc     GIIS_PARAMETERS.param_value_v%TYPE; --end of added codes, bdarusin, 12022002
  comm_amt_per_group  GIPI_WINVOICE.ri_comm_amt%TYPE;
  prem_amt_per_peril  GIPI_WINVOICE.prem_amt%TYPE;
  prem_amt_per_group  GIPI_WINVOICE.prem_amt%TYPE;
  tax_amt_per_peril   GIPI_WINVOICE.tax_amt%TYPE;
  tax_amt_per_group1  REAL;
  tax_amt_per_group2  REAL;
  p_tax_amt           REAL;
  v_prem_amt          REAL; --added by bdarusin, copied from old create_winvoice
  prev_item_grp       GIPI_WINVOICE.item_grp%TYPE;
  prev_currency_cd    GIPI_WINVOICE.currency_cd%TYPE;
  prev_currency_rt    GIPI_WINVOICE.currency_rt%TYPE;
  p_assd_name         GIIS_ASSURED.assd_name%TYPE;
  dummy               VARCHAR2(1);
  p_issue_date        GIPI_WPOLBAS.issue_date%TYPE;
  p_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
  p_place_cd          GIPI_WPOLBAS.place_cd%TYPE;
  p_pack              GIPI_WPOLBAS.pack_pol_flag%TYPE;
  -- LONGTERM VARIABLES --
  prem_amt_per_group_last GIPI_WINVOICE.PREM_AMT%TYPE;
  tax_amt_per_group_last  GIPI_WINVOICE.TAX_AMT%TYPE;
  comm_amt_per_group_last GIPI_WINVOICE.RI_COMM_AMT%TYPE;
  p_no_of_takeup          GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
  p_yearly_tag            GIIS_TAKEUP_TERM.yearly_tag%TYPE;
  p_takeup_term           GIPI_WPOLBAS.takeup_term%TYPE;
  v_expiry_date           GIPI_WPOLBAS.EXPIRY_DATE%TYPE;
  v_incept_date           GIPI_WPOLBAS.incept_DATE%TYPE;

  v_policy_days           NUMBER:=0;
  v_policy_months         NUMBER:=0;
  v_no_of_payment         NUMBER:=1;
  v_due_date              DATE;
  v_booking_date          DATE;
  v_days_interval         NUMBER:=0;

  v_booking_mth        GIPI_WINVOICE.MULTI_BOOKING_MM%TYPE;
  v_booking_year       GIPI_WINVOICE.MULTI_BOOKING_YY%TYPE;

  v_polbas_book_mm        GIPI_WPOLBAS.BOOKING_MTH%TYPE;
  v_polbas_book_yy        GIPI_WPOLBAS.BOOKING_YEAR%TYPE;

  v_prodtakeup            GIAC_PARAMETERS.param_value_n%TYPE;--added by VJ 061608, in order to consider parameter for production takeup.
  V_prodtakeupdate        DATE;

  --added by jason 8/21/2008
  v_evat_cd           NUMBER := Giacp.n('EVAT');  --to avoid calling the giacp.n function repeatedly

BEGIN
  --added by gmi: LONGTERM --

  FOR FL_110 IN a1
  LOOP
    p_eff_date       := FL_110.eff_date;
    p_issue_date     := FL_110.issue_date;
    p_place_cd       := FL_110.place_cd;
  p_takeup_term    := FL_110.takeup_term;
  v_polbas_book_mm := FL_110.BOOKING_MTH;
  v_polbas_book_yy := FL_110.BOOKING_YEAR;
    -- If record is an endt then consider expiry date of endorsement.

 IF FL_110.endt_expiry_date IS NULL THEN
      v_expiry_date := FL_110.expiry_date;
      v_incept_date := FL_110.eff_date;
    ELSE
      v_expiry_date := FL_110.endt_expiry_date;
      v_incept_date := FL_110.eff_date;
    END IF;
    EXIT;
  END LOOP;

  IF TRUNC(v_expiry_date - v_incept_date) = 31 THEN
    v_policy_days      := 30;
  ELSE
   v_policy_days      := TRUNC(v_expiry_date - v_incept_date);
  END IF;

  v_policy_months     := CEIL(MONTHS_BETWEEN(v_expiry_date,v_incept_date));

  FOR b1 IN (SELECT no_of_takeup, yearly_tag
               FROM GIIS_TAKEUP_TERM
              WHERE takeup_term = p_takeup_term)
  LOOP
    p_no_of_takeup := b1.no_of_takeup;
    p_yearly_tag   := b1.yearly_tag;

  END LOOP;

  ------- LONG TERM PROCESS get payment divisions--------------
  /*
  ** p_yearly_tag: Y = adjust no of payment to the total policy days duration
  **               example: 2 years duration with monthly take up is divided into 24 no of payments --
  **                        8 months duration with monthly take up is divided into 8 no of payments --
  ** p_yearly_tag: N = no of payment will follow the value of NO_OF_TAKEUP in giis_takeup_term table --
  **               example: 2 years duration with monthly take up is divided into 12 no of payments --
  **                        8 months duration with monthly take up is divided into 12 no of payments --
  */
  IF p_yearly_tag = 'Y' THEN
    IF TRUNC((v_policy_days)/365,2) * p_no_of_takeup >
       TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) THEN
         v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) + 1;
    ELSE
         v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup);
    END IF;
  ELSE
    IF v_policy_days < p_no_of_takeup THEN
      v_no_of_payment := v_policy_days;
   ELSE
      v_no_of_payment := p_no_of_takeup;
    END IF;

  END IF;

  IF NVL(v_no_of_payment,0) < 1 THEN
    v_no_of_payment := 1;
  END IF;

  v_days_interval := ROUND(v_policy_days/v_no_of_payment);

  --added by gmi: LONGTERM --

   OPEN d1; --added by bdarusin, copied from old create_winvoice
  FETCH d1
   INTO p_doc_stamps;
  CLOSE d1;

   OPEN e1;
  FETCH e1
   INTO v_param_old_doc;
  CLOSE e1; --end of added codes, bdarusin, 12022002

  DELETE FROM GIPI_WINSTALLMENT
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WCOMM_INV_PERILS
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WCOMM_INVOICES
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WINVPERL
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WPACKAGE_INV_TAX
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WINV_TAX
   WHERE par_id = p_par_id;
  DELETE FROM GIPI_WINVOICE
   WHERE par_id = p_par_id;

  BEGIN
    FOR a1 IN (
      SELECT SUBSTR(b.assd_name,1,30) assd_name
        FROM GIPI_PARLIST A, GIIS_ASSURED b
       WHERE A.assd_no    =  b.assd_no
         AND A.par_id     =  p_par_id
         AND A.line_cd    =  p_line_cd)
    LOOP
      p_assd_name  := a1.assd_name;
    END LOOP;

    IF p_assd_name IS NULL THEN
      p_assd_name:='NULL';
    END IF;
  END;

  FOR A IN (
    SELECT pack_pol_flag
      FROM GIPI_WPOLBAS
     WHERE par_id  =  p_par_id)
  LOOP
    p_pack  :=  A.pack_pol_flag;
    EXIT;
  END LOOP;

  FOR c1_rec IN c1
  LOOP
    BEGIN
     IF NVL(prev_item_grp,c1_rec.item_grp) != c1_rec.item_grp THEN
       BEGIN
          DECLARE
            CURSOR c2 IS
               SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate, b.tax_id
                 FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b
                WHERE b.line_cd    = p_line_cd
                  AND b.iss_cd  (+)= p_iss_cd
                  AND b.primary_sw = 'Y'
                  AND b.peril_sw   = 'N'
                  -- peril switch equal to 'n' suggests that the
                  -- specified tax does not need any tax peril
                  AND b.eff_start_date < p_issue_date
                  AND b.eff_end_date > p_issue_date
                  -- the tax fetched should have been in effect before the
                  -- par has been created. (loth 032200)
                 AND NVL(b.issue_date_tag,'N') = 'Y';

   CURSOR d1 IS
              SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate,b.tax_id
                FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
               WHERE b.line_cd    = p_line_cd
                 AND b.iss_cd  (+)= p_iss_cd
                 AND b.iss_cd = C.iss_cd(+)
                 AND b.line_cd = C.line_cd(+)
                 AND b.tax_cd = C.tax_cd(+)
                 AND C.place_cd(+) = p_place_cd
                 AND b.primary_sw = 'Y'
                 AND b.peril_sw   = 'N'
                 AND b.eff_start_date < p_issue_date
                 AND b.eff_end_date > p_issue_date
                 AND NVL(b.issue_date_tag,'N') = 'Y';
        -- if issue_date_tag = 'y', tax will be considered based
        -- on issue_date else on eff_date (loth 032200)

   CURSOR c2a IS
              SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate, b.tax_id
                FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b
               WHERE b.line_cd    = p_line_cd
                 AND b.iss_cd  (+)= p_iss_cd
                 AND b.primary_sw = 'Y'
                 AND b.peril_sw   = 'N'
                 -- peril switch equal to 'n' suggests that the
                 -- specified tax does not need any tax peril
                 AND b.eff_start_date < p_eff_date
                 AND b.eff_end_date > p_eff_date
                 -- the tax fetched should have been in effect before the
                 -- par has been created. (loth 032200)
                 AND NVL(b.issue_date_tag,'N') = 'N';

   CURSOR d2 IS
              SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate, b.tax_id
                FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
               WHERE b.line_cd     = p_line_cd
                 AND b.iss_cd   (+)= p_iss_cd
                 AND b.iss_cd      = C.iss_cd(+)
                 AND b.line_cd     = C.line_cd(+)
                 AND b.tax_cd      = C.tax_cd(+)
                 AND C.place_cd (+)= p_place_cd
                 AND b.primary_sw  = 'Y'
                 AND b.peril_sw    = 'N'
                 AND b.eff_start_date < p_eff_date
                 AND b.eff_end_date > p_eff_date
                 AND NVL(b.issue_date_tag,'N') = 'N';
        -- if issue_date_tag = 'y', tax will be considered based
        -- on issue_date else on eff_date (loth 032200)
          BEGIN
            IF p_place_cd IS NOT NULL THEN
              FOR d1_rec IN d1
              LOOP
       BEGIN
                  p_tax_amt          := NVL(prem_amt_per_group,0) * NVL(d1_rec.rate,0)/100;
            IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from old create_winvoice
                    IF prem_amt_per_group > 0 THEN
                    p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
              ELSE
                   p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
              END IF;
                  END IF;                                 --end of added codes, bdarusin, 12022002

           --  A.R.C. 04.10.2007
             --add code to consider VAT_TAG
              IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                    FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                 FROM GIIS_ASSURED b,
                                      GIPI_WPOLBAS a
                                WHERE b.assd_no = a.assd_no
                                  AND a.par_id = p_par_id)
                    LOOP
                      IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                 p_tax_amt := 0;
               END IF;
              END LOOP;
                  END IF; --end of code 04.10.2007
                  tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
    END;
              END LOOP;

        FOR d2_rec IN d2
              LOOP
                BEGIN
                  p_tax_amt          := NVL(prem_amt_per_group,0) * NVL(d2_rec.rate,0)/100;
                  IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                    IF prem_amt_per_group > 0 THEN
                   p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
              ELSE
                   p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
              END IF;
                  END IF;
                 --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
              IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                    FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                 FROM GIIS_ASSURED b,
                                      GIPI_WPOLBAS a
                                WHERE b.assd_no = a.assd_no
                                  AND a.par_id = p_par_id)
                    LOOP
                 IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
               END IF;
              END LOOP;
                  END IF; --end of code 04.10.2007
                 tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
                END;
              END LOOP;

   ELSE
              FOR c2_rec IN c2
              LOOP
       BEGIN
                  p_tax_amt          := NVL(prem_amt_per_group,0) * NVL(c2_rec.rate,0)/100;
                  IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                    IF prem_amt_per_group > 0 THEN
                p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
          ELSE
              p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
                    END IF;
                  END IF;
                --  A.R.C. 04.10.2007
            -- add code to consider VAT_TAG
            IF c2_rec.tax_cd =  v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                    FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                 FROM GIIS_ASSURED b,
                                      GIPI_WPOLBAS a
                                WHERE b.assd_no = a.assd_no
                                  AND a.par_id = p_par_id)
                    LOOP
              IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
               p_tax_amt := 0;
               END IF;
                    END LOOP;
                  END IF; --end of code 04.10.2007
                  tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
                END;
              END LOOP;

              FOR c2a_rec IN c2a
              LOOP
       BEGIN
                  p_tax_amt          := NVL(prem_amt_per_group,0) * NVL(c2a_rec.rate,0)/100;
                  IF c2a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                    IF prem_amt_per_group > 0 THEN
                      p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
           ELSE
              p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
          END IF;
                  END IF;
                --  A.R.C. 04.10.2007
            -- add code to consider VAT_TAG
            IF c2a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                    FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                 FROM GIIS_ASSURED b,
                                      GIPI_WPOLBAS a
                                WHERE b.assd_no = a.assd_no
                                  AND a.par_id = p_par_id)
                    LOOP
              IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
               p_tax_amt := 0;
                      END IF;
                    END LOOP;
                  END IF; --end of code 04.10.2007
                  tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
                END;
              END LOOP;
      END IF;

   IF v_no_of_payment = 1 THEN
      /*added statements below in order to consider prodtakeup parameter and insert duedate; prevents null value for due date at gipis026 when changing payterm
              **vj 061808
              */
              FOR gp IN (SELECT PARAM_VALUE_N,remarks
                           FROM GIAC_PARAMETERS
                          WHERE PARAM_NAME = 'PROD_TAKE_UP')
              LOOP
                v_prodtakeup := gp.param_value_n;
              END LOOP;
              IF v_prodtakeup = 1 OR
               (v_prodtakeup = 3 AND p_issue_date > v_incept_date) OR
               (v_prodtakeup = 4 AND p_issue_date < v_incept_date) THEN
                   v_prodtakeupdate:= p_issue_date;
              ELSIF v_prodtakeup = 2 OR
                (v_prodtakeup = 3 AND p_issue_date <= v_incept_date) OR
                (v_prodtakeup = 4 AND p_issue_date >= v_incept_date) THEN
                    v_prodtakeupdate:= v_incept_date;
              END IF;


             INSERT INTO  GIPI_WINVOICE
                   (par_id,              item_grp,
                    payt_terms,          prem_seq_no,
                    prem_amt,            tax_amt,
                    property,            insured,
                    due_date,            notarial_fee,
                    ri_comm_amt,         currency_cd,
                    currency_rt,
                  --LONG TERM COLUMNS --
                  MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
                  NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
                 VALUES
                   (p_par_id,            prev_item_grp,
                    NULL,                NULL,
                    prem_amt_per_group,  NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0),
                    NULL,                p_assd_name,
                    /*NULL*/v_prodtakeupdate,                0,
                    comm_amt_per_group,  prev_currency_cd,
                    prev_currency_rt,
                  --LONG TERM COLUMNS --
                  v_polbas_book_mm,    v_polbas_book_yy,
                  1,                   1);
            ELSE

              prem_amt_per_group_last := 0;
            tax_amt_per_group_last  := 0;
            comm_amt_per_group_last := 0;
              v_due_date              := NULL;
              v_booking_date          := NULL;

     /*added by VJ 061608; consider parameter for production takeup*/
              FOR gp IN (
       SELECT PARAM_VALUE_N,remarks
                  FROM GIAC_PARAMETERS
                 WHERE PARAM_NAME = 'PROD_TAKE_UP')
              LOOP
                v_prodtakeup := gp.param_value_n;
              END LOOP;

     FOR takeup_val IN 1.. v_no_of_payment LOOP
                IF v_due_date IS NULL THEN
                  IF v_prodtakeup = 1 OR
                   (v_prodtakeup = 3 AND p_issue_date > v_incept_date) OR
                   (v_prodtakeup = 4 AND p_issue_date < v_incept_date) THEN
                       v_prodtakeupdate:= p_issue_date;
                  ELSIF v_prodtakeup = 2 OR
                    (v_prodtakeup = 3 AND p_issue_date <= v_incept_date) OR
                    (v_prodtakeup = 4 AND p_issue_date >= v_incept_date) THEN
                        v_prodtakeupdate:= v_incept_date;
                  END IF;

                  v_due_date := /*trunc(p_eff_date)*/TRUNC(v_prodtakeupdate);
              /*end mod by VJ 061608*/
                ELSE
                  v_due_date := TRUNC(v_due_date + v_days_interval);
                END IF;

            IF v_booking_date IS NULL THEN
                  v_booking_date := TRUNC(v_due_date);
               ELSE
                  --v_booking_date := ADD_MONTHS(v_booking_date, (v_policy_months / v_no_of_payment));
              v_booking_date := ADD_MONTHS(v_due_date, (v_policy_months / v_no_of_payment));
               END IF;


             BEGIN
                  /*SELECT BOOKING_YEAR, BOOKING_MTH
                INTO v_booking_year, v_booking_mth
              FROM GIIS_BOOKING_MONTH
              WHERE NVL(BOOKED_TAG, 'N') <> 'Y'
                  AND BOOKING_YEAR = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
                AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))
                   = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM'));*/
      SELECT booking_year, booking_mth
        INTO v_booking_year, v_booking_mth
       FROM ( SELECT BOOKING_YEAR,
                      TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'),
                   BOOKING_MTH
                             FROM GIIS_BOOKING_MONTH
               WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
                  AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
          OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
                  AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))>= TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM'))))
               ORDER BY 1, 2) a
        WHERE ROWNUM = 1;

                EXCEPTION
           WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20631,'CANNOT GENERATE BOOKING DATE: '||TO_CHAR(v_booking_date,'MONTH YYYY')||'. PLEASE CHECK MAINTENANCE TABLE');
            END;

         IF takeup_val = v_no_of_payment THEN

                INSERT INTO  GIPI_WINVOICE
                   (par_id,              item_grp,
                    payt_terms,          prem_seq_no,
                    prem_amt,
                 tax_amt,         ri_comm_amt,
                    property,            insured,
                    due_date,            notarial_fee,
                    currency_cd,
                    currency_rt,
             --LONG TERM COLUMNS --
                 MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
                 NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
                VALUES
                   (p_par_id,            prev_item_grp,
                    NULL,                NULL,
                    prem_amt_per_group - prem_amt_per_group_last,
           --((NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)) - tax_amt_per_group_last),
               0,
                 comm_amt_per_group - comm_amt_per_group_last,
                    NULL,                p_assd_name,
                    v_due_date,          0,
                    prev_currency_cd,
                    prev_currency_rt,
           --LONG TERM COLUMNS --
                 v_booking_mth,        v_booking_year,
                 v_no_of_payment,      takeup_val);
             ELSIF takeup_val = 1 THEN

            INSERT INTO  GIPI_WINVOICE
                   (par_id,              item_grp,
                    payt_terms,          prem_seq_no,
                    prem_amt,
           tax_amt,
           ri_comm_amt,
                    property,            insured,
                    due_date,            notarial_fee,
                    currency_cd,
                    currency_rt,
           --LONG TERM COLUMNS --
           MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
           NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
                  VALUES
                   (p_par_id,            prev_item_grp,
                    NULL,                NULL,
                    (prem_amt_per_group / v_no_of_payment),
           (NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)),
           (comm_amt_per_group / v_no_of_payment),
                    NULL,                p_assd_name,
                    v_due_date,          0,
                    prev_currency_cd,
                    prev_currency_rt,
           --LONG TERM COLUMNS --
           v_booking_mth,        v_booking_year,
           v_no_of_payment,      takeup_val);

    ELSE


      INSERT INTO  GIPI_WINVOICE
                   (par_id,              item_grp,
                    payt_terms,          prem_seq_no,
                    prem_amt,
           tax_amt,
           ri_comm_amt,
                    property,            insured,
                    due_date,            notarial_fee,
                    currency_cd,
                    currency_rt,
           --LONG TERM COLUMNS --
           MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
           NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
                  VALUES
                   (p_par_id,            prev_item_grp,
                    NULL,                NULL,
                    (prem_amt_per_group / v_no_of_payment),
           --((NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)) / v_no_of_payment),
     0,
           (comm_amt_per_group / v_no_of_payment),
                    NULL,                p_assd_name,
                    v_due_date,          0,
                    prev_currency_cd,
                    prev_currency_rt,
           --LONG TERM COLUMNS --
           v_booking_mth,        v_booking_year,
           v_no_of_payment,      takeup_val);

     prem_amt_per_group_last := prem_amt_per_group_last + (prem_amt_per_group / v_no_of_payment);
         tax_amt_per_group_last  := tax_amt_per_group_last + ((NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)) / v_no_of_payment);
         comm_amt_per_group_last := comm_amt_per_group_last + (comm_amt_per_group / v_no_of_payment);


    END IF;
              END LOOP;
   END IF;

        p_tax_amt          := 0;
       prem_amt_per_group := 0;
       tax_amt_per_group1 := 0;
       tax_amt_per_group2 := 0;
       comm_amt_per_group := 0;
          END;
        END;
      END IF;
      prev_item_grp      := c1_rec.item_grp;
      prev_currency_cd   := c1_rec.currency_cd;
      prev_currency_rt   := c1_rec.currency_rt;
      prem_amt_per_group := NVL(prem_amt_per_group,0) + c1_rec.prem_amt;
      comm_amt_per_group := NVL(comm_amt_per_group,0) + c1_rec.ri_comm_amt;

      DECLARE
        CURSOR c2 IS
          SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate
            FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b
           WHERE A.line_cd    = p_line_cd
             AND A.iss_cd  (+)= p_iss_cd
             AND A.line_cd    = b.line_cd
             AND A.iss_cd  (+)= b.iss_cd
             AND A.tax_cd     = b.tax_cd
             -- the tax fetched should have been in effect before the
             -- par has been created. (loth 032200)
             AND b.eff_start_date < p_issue_date
             AND b.eff_end_date > p_issue_date
             -- if issue_date_tag = 'y', TAX WILL BE CONSIDERED BASED
             -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
             AND NVL(b.issue_date_tag,'N') = 'Y'
             AND b.primary_sw = 'Y'
             AND b.peril_sw   = 'Y'
             AND A.peril_cd IN ( SELECT peril_cd
                                   FROM GIPI_WITMPERL
                                  WHERE par_id = p_par_id)
             AND A.peril_cd   = c1_rec.peril_cd;

  CURSOR d1 IS
          SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate
            FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
           WHERE A.line_cd    = p_line_cd
             AND A.iss_cd  (+)= p_iss_cd
             AND A.line_cd    = b.line_cd
             AND A.iss_cd  (+)= b.iss_cd
             AND A.tax_cd     = b.tax_cd
             AND A.iss_cd     = C.iss_cd(+)
             AND A.line_cd    = C.line_cd(+)
             AND A.tax_cd     = C.tax_cd(+)
             AND C.place_cd  (+)= p_place_cd
             AND b.eff_start_date < p_issue_date
             AND b.eff_end_date > p_issue_date
             AND NVL(b.issue_date_tag,'N') = 'Y'
             AND b.primary_sw = 'Y'
             AND b.peril_sw   = 'Y'
             AND A.peril_cd IN ( SELECT peril_cd
                                   FROM GIPI_WITMPERL
                                  WHERE par_id = p_par_id)
             AND A.peril_cd   = c1_rec.peril_cd;

  CURSOR c2a IS
          SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate
            FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b
           WHERE A.line_cd    = p_line_cd
             AND A.iss_cd  (+)= p_iss_cd
             AND A.line_cd    = b.line_cd
             AND A.iss_cd  (+)= b.iss_cd
             AND A.tax_cd     = b.tax_cd
             -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
             -- PAR HAS BEEN CREATED. (LOTH 032200)
             AND b.eff_start_date < p_eff_date
             AND b.eff_end_date > p_eff_date
             -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
             -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
             AND NVL(b.issue_date_tag,'N') = 'N'
             AND b.primary_sw = 'Y'
             AND b.peril_sw   = 'Y'
             AND A.peril_cd IN ( SELECT peril_cd
                                   FROM GIPI_WITMPERL
                                  WHERE par_id = p_par_id)
             AND A.peril_cd   = c1_rec.peril_cd;

  CURSOR d2 IS
          SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate
            FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
           WHERE A.line_cd    = p_line_cd
             AND A.iss_cd  (+)= p_iss_cd
             AND A.line_cd    = b.line_cd
             AND A.iss_cd  (+)= b.iss_cd
             AND A.tax_cd     = b.tax_cd
             AND A.iss_cd     = C.iss_cd(+)
             AND A.line_cd    = C.line_cd(+)
             AND A.tax_cd     = C.tax_cd(+)
             AND C.place_cd(+)= p_place_cd
             AND b.eff_start_date < p_eff_date
             AND b.eff_end_date > p_eff_date
             AND NVL(b.issue_date_tag,'N') = 'N'
             AND b.primary_sw = 'Y'
             AND b.peril_sw   = 'Y'
             AND A.peril_cd IN ( SELECT peril_cd
                                   FROM GIPI_WITMPERL
                                  WHERE par_id = p_par_id)
             AND A.peril_cd   = c1_rec.peril_cd;

   BEGIN
     IF p_place_cd IS NOT NULL THEN
          FOR d1_rec IN d1
          LOOP

            BEGIN
              p_tax_amt          := NVL(c1_rec.prem_amt,0) * NVL(d1_rec.rate,0)/ 100;
              IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                IF c1_rec.prem_amt > 0 THEN
                  p_tax_amt := CEIL(c1_rec.prem_amt / 4) * (0.5);
         ELSE
             p_tax_amt := FLOOR(c1_rec.prem_amt / 4) * (0.5);
         END IF;
              END IF;
              --  A.R.C. 04.10.2007
          -- add code to consider VAT_TAG
           IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM GIIS_ASSURED b,
                                  GIPI_WPOLBAS a
                            WHERE b.assd_no = a.assd_no
                              AND a.par_id = p_par_id)
         LOOP
            IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
              p_tax_amt := 0;
                  END IF;
         END LOOP;
              END IF; --end of code 04.10.2007
              tax_amt_per_peril  := NVL(tax_amt_per_peril,0) + NVL(p_tax_amt,0);
              tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;


            END;
          END LOOP;

    FOR d2_rec IN d2
    LOOP

            BEGIN
              p_tax_amt          := NVL(c1_rec.prem_amt,0) * NVL(d2_rec.rate,0)/ 100;
              IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                IF c1_rec.prem_amt > 0 THEN
               p_tax_amt := CEIL(c1_rec.prem_amt / 4) * (0.5);
                ELSE
             p_tax_amt := FLOOR(c1_rec.prem_amt / 4) * (0.5);
         END IF;
              END IF;
              --  A.R.C. 04.10.2007
          -- add code to consider VAT_TAG
           IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM GIIS_ASSURED b,
                                  GIPI_WPOLBAS a
                            WHERE b.assd_no = a.assd_no
                              AND a.par_id = p_par_id)
                LOOP
            IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
              p_tax_amt := 0;
                  END IF;
                END LOOP;
              END IF; --end of code 04.10.2007
              tax_amt_per_peril  := NVL(tax_amt_per_peril,0) + NVL(p_tax_amt,0);
              tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
            END;
          END LOOP;
  ELSE

    FOR c2_rec IN c2
          LOOP

            BEGIN
              p_tax_amt          := NVL(c1_rec.prem_amt,0) * NVL(c2_rec.rate,0)/ 100;
              IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                IF c1_rec.prem_amt > 0 THEN
               p_tax_amt := CEIL(c1_rec.prem_amt / 4) * (0.5);
         ELSE
             p_tax_amt := FLOOR(c1_rec.prem_amt / 4) * (0.5);
         END IF;
              END IF;
              --  A.R.C. 04.10.2007
          -- add code to consider VAT_TAG
           IF c2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM GIIS_ASSURED b,
                                  GIPI_WPOLBAS a
                            WHERE b.assd_no = a.assd_no
                              AND a.par_id = p_par_id)
                LOOP
            IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
              p_tax_amt := 0;
          END IF;
         END LOOP;
              END IF; --end of code 04.10.2007
              tax_amt_per_peril  := NVL(tax_amt_per_peril,0) + NVL(p_tax_amt,0);
              tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
            END;
          END LOOP;

          FOR c2a_rec IN c2a
          LOOP

            BEGIN
              p_tax_amt          := NVL(c1_rec.prem_amt,0) * NVL(c2a_rec.rate,0)/ 100;
              IF c2a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                IF c1_rec.prem_amt > 0 THEN
               p_tax_amt := CEIL(c1_rec.prem_amt / 4) * (0.5);
         ELSE
             p_tax_amt := FLOOR(c1_rec.prem_amt / 4) * (0.5);
         END IF;
              END IF;
              --  A.R.C. 04.10.2007
          -- add code to consider VAT_TAG
           IF c2a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM GIIS_ASSURED b,
                                  GIPI_WPOLBAS a
                            WHERE b.assd_no = a.assd_no
                              AND a.par_id = p_par_id)
                LOOP
            IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
              p_tax_amt := 0;
             END IF;
                END LOOP;
              END IF; --end of code 04.10.2007
              tax_amt_per_peril  := NVL(tax_amt_per_peril,0) + NVL(p_tax_amt,0);
              tax_amt_per_group2 := tax_amt_per_peril; --NVL(TAX_AMT_PER_GROUP2,0) + TAX_AMT_PER_PERIL;
            END;
          END LOOP;
        END IF;

      END;
    END;
  END LOOP;
---------------------------------------------------------------------------

  DECLARE
    CURSOR c2 IS
      SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate
        FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b
       WHERE b.line_cd = p_line_cd
         AND b.iss_cd (+)      = p_iss_cd
         AND b.primary_sw      = 'Y'
         AND b.peril_sw        = 'N'
         -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
         -- PAR HAS BEEN CREATED. (LOTH 032200)
         AND b.eff_start_date <= p_issue_date
         AND b.eff_end_date   >= p_issue_date
         -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
         -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
         AND NVL(b.issue_date_tag, 'N') = 'Y';

 CURSOR d1 IS
      SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate
        FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
       WHERE b.line_cd         = p_line_cd
         AND b.iss_cd (+)      = p_iss_cd
         AND b.iss_cd          = C.iss_cd(+)
         AND b.line_cd         = C.line_cd(+)
         AND b.tax_cd          = C.tax_cd(+)
         AND b.primary_sw      = 'Y'
         AND b.peril_sw        = 'N'
         AND C.place_cd     (+)= p_place_cd
         AND b.eff_start_date <= p_issue_date
         AND b.eff_end_date   >= p_issue_date
         AND NVL(b.issue_date_tag, 'N') = 'Y';

 CURSOR c2a IS
      SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate
        FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b
       WHERE b.line_cd = p_line_cd
         AND b.iss_cd (+)      = p_iss_cd
         AND b.primary_sw      = 'Y'
         AND b.peril_sw        = 'N'
         -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
         -- PAR HAS BEEN CREATED. (LOTH 032200)
         AND b.eff_start_date <= p_eff_date
         AND b.eff_end_date   >= p_eff_date
         -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
         -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
         AND NVL(b.issue_date_tag, 'N') = 'N';

 CURSOR d2 IS
      SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate
        FROM GIIS_TAX_PERIL A, GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
       WHERE b.line_cd     = p_line_cd
         AND b.iss_cd   (+)= p_iss_cd
         AND b.iss_cd      = C.iss_cd(+)
         AND b.line_cd     = C.line_cd(+)
         AND b.tax_cd      = C.tax_cd(+)
         AND C.place_cd (+)= p_place_cd
         AND b.primary_sw  = 'Y'
         AND b.peril_sw    = 'N'
         AND b.eff_start_date <= p_eff_date
         AND b.eff_end_date   >= p_eff_date
         AND NVL(b.issue_date_tag, 'N') = 'N';

  BEGIN
    IF p_place_cd IS NOT NULL THEN
      FOR d1_rec IN d1
      LOOP
        BEGIN
          p_tax_amt := NVL(prem_amt_per_group,0) * NVL(d1_rec.rate,0)/100;
          IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
            IF prem_amt_per_group > 0 THEN
              p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
         ELSE
             p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
         END IF;
          END IF;
          --  A.R.C. 04.10.2007
        -- add code to consider VAT_TAG
         IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
            FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                         FROM GIIS_ASSURED b,
                              GIPI_WPOLBAS a
                        WHERE b.assd_no = a.assd_no
                          AND a.par_id = p_par_id)
            LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
            p_tax_amt := 0;
        END IF;
            END LOOP;
          END IF; --end of code 04.10.2007
          tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
        END;
      END LOOP;

      FOR d2_rec IN d2
      LOOP

        BEGIN
          p_tax_amt := NVL(prem_amt_per_group,0) * NVL(d2_rec.rate,0)/100;
          IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y'  THEN
            IF prem_amt_per_group > 0 THEN
              p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
            ELSE
              p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
            END IF;
          END IF;
          --  A.R.C. 04.10.2007
        -- add code to consider VAT_TAG
         IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
            FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                         FROM GIIS_ASSURED b,
                              GIPI_WPOLBAS a
                        WHERE b.assd_no = a.assd_no
                          AND a.par_id = p_par_id)
            LOOP
              IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                p_tax_amt := 0;
           END IF;
            END LOOP;
          END IF; --end of code 04.10.2007
          tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
        END;
      END LOOP;
    ELSE

      FOR c2_rec IN c2
      LOOP

        BEGIN
          p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c2_rec.rate,0)/100;
          IF c2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
            IF prem_amt_per_group > 0 THEN
              p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
      ELSE
              p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
      END IF;
          END IF;
          --  A.R.C. 04.10.2007
        -- add code to consider VAT_TAG
         IF c2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
            FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                         FROM GIIS_ASSURED b,
                              GIPI_WPOLBAS a
                        WHERE b.assd_no = a.assd_no
                          AND a.par_id = p_par_id)
            LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
            p_tax_amt := 0;
        END IF;
            END LOOP;
          END IF; --end of code 04.10.2007
          tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
        END;
      END LOOP;

      FOR c2a_rec IN c2a
      LOOP

        BEGIN
          p_tax_amt := NVL(prem_amt_per_group,0) * NVL(c2a_rec.rate,0)/100;
          IF c2a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
            IF prem_amt_per_group > 0 THEN
              p_tax_amt := CEIL(prem_amt_per_group / 4) * (0.5);
         ELSE
            p_tax_amt := FLOOR(prem_amt_per_group / 4) * (0.5);
            END IF;
          END IF;
          --  A.R.C. 04.10.2007
        -- add code to consider VAT_TAG
         IF c2a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
            FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                         FROM GIIS_ASSURED b,
                              GIPI_WPOLBAS a
                        WHERE b.assd_no = a.assd_no
                          AND a.par_id = p_par_id)
            LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
            p_tax_amt := 0;
        END IF;
            END LOOP;
          END IF; --end of code 04.10.2007
          tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + NVL(p_tax_amt,0);
        END;
      END LOOP;
    END IF;


    IF v_no_of_payment = 1 THEN

    /*added statements below in order to consider prodatkeup parameter and insert duedate; prevents null value for due date at gipis026 when changing payterm
    **vj 061808
    */
              FOR gp IN (SELECT PARAM_VALUE_N,remarks
                           FROM GIAC_PARAMETERS
                          WHERE PARAM_NAME = 'PROD_TAKE_UP')
              LOOP
                v_prodtakeup := gp.param_value_n;
              END LOOP;
              IF v_prodtakeup = 1 OR
               (v_prodtakeup = 3 AND p_issue_date > v_incept_date) OR
               (v_prodtakeup = 4 AND p_issue_date < v_incept_date) THEN
                   v_prodtakeupdate:= p_issue_date;
              ELSIF v_prodtakeup = 2 OR
                (v_prodtakeup = 3 AND p_issue_date <= v_incept_date) OR
                (v_prodtakeup = 4 AND p_issue_date >= v_incept_date) THEN
                    v_prodtakeupdate:= v_incept_date;
              END IF;


   INSERT INTO  GIPI_WINVOICE
       (par_id,              item_grp,
        payt_terms,          prem_seq_no,
        prem_amt,            tax_amt,
        property,            insured,
        due_date,            notarial_fee,
        ri_comm_amt,         currency_cd,
        currency_rt,
        --LONG TERM COLUMNS --
        MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
        NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
      VALUES
       (p_par_id,            prev_item_grp,
        NULL,                NULL,
        prem_amt_per_group,  NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0),
        NULL,                p_assd_name,
        /*NULL*/v_prodtakeupdate,                0,
        comm_amt_per_group,  prev_currency_cd,
        prev_currency_rt,
        --LONG TERM COLUMNS --
        v_polbas_book_mm,    v_polbas_book_yy,
        1,                   1);
    ELSE

      prem_amt_per_group_last := 0;
      tax_amt_per_group_last  := 0;
      comm_amt_per_group_last := 0;
      v_due_date      := NULL;
      v_booking_date     := NULL;
      --added by gly 061608; copy changes made by ms.VJ */
      FOR gp IN (
  SELECT PARAM_VALUE_N,remarks
          FROM GIAC_PARAMETERS
         WHERE PARAM_NAME = 'PROD_TAKE_UP')
      LOOP
        v_prodtakeup := gp.param_value_n;
      END LOOP;

   FOR takeup_val IN 1.. v_no_of_payment LOOP
        IF v_due_date IS NULL THEN
          IF v_prodtakeup = 1 OR
            (v_prodtakeup = 3 AND p_issue_date > v_incept_date) OR
            (v_prodtakeup = 4 AND p_issue_date < v_incept_date) THEN
              v_prodtakeupdate:= p_issue_date;
          ELSIF v_prodtakeup = 2 OR
            (v_prodtakeup = 3 AND p_issue_date <= v_incept_date) OR
            (v_prodtakeup = 4 AND p_issue_date >= v_incept_date) THEN
              v_prodtakeupdate:= v_incept_date;
          END IF;

          v_due_date := /*trunc(p_eff_date)*/TRUNC(v_prodtakeupdate);

        ELSE
          v_due_date := TRUNC(v_due_date + v_days_interval);
     END IF;

  IF v_booking_date IS NULL THEN
          v_booking_date := TRUNC(v_due_date);
     ELSE
          --v_booking_date := ADD_MONTHS(v_booking_date, v_policy_months / v_no_of_payment);
    v_booking_date := ADD_MONTHS(v_due_date, (v_policy_months / v_no_of_payment));
     END IF;

  BEGIN
          /*SELECT BOOKING_YEAR, BOOKING_MTH
            INTO v_booking_year, v_booking_mth
            FROM GIIS_BOOKING_MONTH
           WHERE NVL(BOOKED_TAG, 'N') <> 'Y'
             AND BOOKING_YEAR = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
             AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))
               = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM'));*/
    SELECT booking_year, booking_mth
      INTO v_booking_year, v_booking_mth
     FROM ( SELECT BOOKING_YEAR,
                 TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'),
                 BOOKING_MTH
                     FROM GIIS_BOOKING_MONTH
             WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
                AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
        OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
                AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))>= TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM'))))
             ORDER BY 1, 2)
      WHERE ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20631,'CANNOT GENERATE BOOKING DATE: '||TO_CHAR(v_booking_date,'MONTH YYYY')||'. PLEASE CHECK MAINTENANCE TABLE');
        END;

  IF takeup_val = v_no_of_payment THEN

          INSERT INTO  GIPI_WINVOICE
           (par_id,              item_grp,
            payt_terms,          prem_seq_no,
            prem_amt,
         tax_amt,
         ri_comm_amt,
            property,            insured,
            due_date,            notarial_fee,
            currency_cd,
            currency_rt,
         --LONG TERM COLUMNS --
         MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
         NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
          VALUES
           (p_par_id,            prev_item_grp,
            NULL,                NULL,
            prem_amt_per_group - prem_amt_per_group_last,
         --((NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)) - tax_amt_per_group_last),
   0,
         comm_amt_per_group - comm_amt_per_group_last,
            NULL,                p_assd_name,
            v_due_date,          0,
            prev_currency_cd,
            prev_currency_rt,
         --LONG TERM COLUMNS --
         v_booking_mth,        v_booking_year,
         v_no_of_payment,      takeup_val);
        ELSIF takeup_val = 1 THEN


    INSERT INTO  GIPI_WINVOICE
           (par_id,              item_grp,
            payt_terms,          prem_seq_no,
            prem_amt,
   tax_amt,
   ri_comm_amt,
            property,            insured,
            due_date,            notarial_fee,
            currency_cd,
            currency_rt,
   --LONG TERM COLUMNS --
   MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
   NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
          VALUES
           (p_par_id,            prev_item_grp,
            NULL,                NULL,
            (prem_amt_per_group / v_no_of_payment),
   (NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)),
   (comm_amt_per_group / v_no_of_payment),
            NULL,                p_assd_name,
            v_due_date,          0,
            prev_currency_cd,
            prev_currency_rt,
   --LONG TERM COLUMNS --
   v_booking_mth,        v_booking_year,
   v_no_of_payment,      takeup_val);

  ELSE


          INSERT INTO  GIPI_WINVOICE
           (par_id,              item_grp,
            payt_terms,          prem_seq_no,
            prem_amt,
         tax_amt,
         ri_comm_amt,
            property,            insured,
            due_date,            notarial_fee,
            currency_cd,
            currency_rt,
         --LONG TERM COLUMNS --
         MULTI_BOOKING_MM,    MULTI_BOOKING_YY,
         NO_OF_TAKEUP,        TAKEUP_SEQ_NO)
          VALUES
           (p_par_id,            prev_item_grp,
            NULL,                NULL,
            (prem_amt_per_group / v_no_of_payment),
         --((NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)) / v_no_of_payment),
   0,
         (comm_amt_per_group / v_no_of_payment),
            NULL,                p_assd_name,
            v_due_date,          0,
            prev_currency_cd,
            prev_currency_rt,
         --LONG TERM COLUMNS --
         v_booking_mth,        v_booking_year,
         v_no_of_payment,      takeup_val);

   prem_amt_per_group_last := prem_amt_per_group_last + (prem_amt_per_group / v_no_of_payment);
       tax_amt_per_group_last  := tax_amt_per_group_last + ((NVL(tax_amt_per_group1,0) + NVL(tax_amt_per_group2,0)) / v_no_of_payment);
       comm_amt_per_group_last := comm_amt_per_group_last + (comm_amt_per_group / v_no_of_payment);
        END IF;
      END LOOP;
    END IF;
  END;
  tax_amt_per_group1 := 0;
-----------------------------------------------------------------------***---

  DECLARE
    p_tax_id      GIIS_TAX_CHARGES.tax_id%TYPE;
    v_line_cd     GIPI_POLBASIC.line_cd%TYPE;
  v_subline_cd  GIPI_POLBASIC.subline_cd%TYPE;
 v_iss_cd      GIPI_POLBASIC.iss_cd%TYPE;
  v_issue_yy    GIPI_POLBASIC.issue_yy%TYPE;
  v_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE;
  v_renew_no    GIPI_POLBASIC.renew_no%TYPE;

    /*Modified by Iris Bordey 12.09.2003
  **Problem : ORA-02291 on table gipi_winv_tax (parent rec, from gipi_winvoice not found)
  **Resolution : Since at this point necessary insert/update were made already to
  **           : to gipi_winvoice and since it is "non-existing" item_grp from gipi_winvoice
    **           : that causes the ora error, query for item_grp will come from gipi_winvoice.
  **Note       : ORA-02291 error on table gipi_winvperl will be handled.
  */
  CURSOR c4 IS
      SELECT item_grp, takeup_seq_no
        FROM GIPI_WINVOICE A
       WHERE par_id = p_par_id
         AND ((NVL(p_pack,'N') = 'Y'
               AND EXISTS (SELECT '1'
                             FROM GIPI_WITMPERL b, GIPI_WITEM C
                            WHERE C.par_id   = A.par_id
                AND C.item_grp = A.item_grp
                AND b.par_id   = C.par_id
                              AND b.item_no  = C.item_no))
               OR (NVL(p_pack,'N') = 'N'));

 /*Modified by Iris Bordey 09.30.03
  **To resolve ora-02291 on gipi_winvperl for package policies.
  **Checks if item_grp (from gipi_witem) has corresponding peril on
  **gipi_witmperl*/
  /*CURSOR c4 IS
      SELECT DISTINCT a.item_grp
        FROM gipi_witem a
       WHERE a.par_id   = p_par_id
         AND ((NVL(p_pack,'N') = 'Y'
               AND EXISTS (SELECT '1'
                             FROM gipi_witmperl b
                            WHERE b.par_id = a.par_id
                              AND b.item_no = a.item_no))
               OR (NVL(p_pack,'N') = 'N'));*/
    /*CURSOR c4 IS
      SELECT DISTINCT item_grp
        FROM gipi_witem
       WHERE par_id   = p_par_id;*/
       --AND ITEM_GRP = PREV_ITEM_GRP;--AIVHIE 120601
       --REQUIRED TAX MUST BE INSERTED
       --PER ITEM_GRP AND NOT JUST ON THE
       --LAST ITEM_GRP

  --moved the cursors here to avoid repeated declaration:  jason 9/4/2008
    CURSOR c3 (p_item_grp GIPI_WITEM.ITEM_GRP%TYPE)
      IS
      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
             SUM(NVL(A.tsi_amt,0)) tsi_amt
        FROM GIPI_WITMPERL A, GIPI_WITEM b
       WHERE A.par_id   = p_par_id
         AND A.par_id   = b.par_id
         AND A.item_no  = b.item_no
         AND b.item_grp = p_item_grp --c4_rec.item_grp
       GROUP BY b.item_grp, A.peril_cd;

    CURSOR c5 (p_item_grp GIPI_WITEM.item_grp%TYPE
              ,p_tax_cd   GIIS_TAX_PERIL.tax_cd%TYPE)
      IS
      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
             SUM(NVL(A.tsi_amt,0)) tsi_amt
        FROM GIPI_WITMPERL A, GIPI_WITEM b
       WHERE A.par_id   = p_par_id
         AND A.par_id   = b.par_id
         AND A.item_no  = b.item_no
         AND b.item_grp = p_item_grp  --c4_rec.item_grp
         AND A.peril_cd IN (SELECT peril_cd
                              FROM GIIS_TAX_PERIL
                             WHERE line_cd = p_line_cd
                               AND iss_cd  = p_iss_cd
                               AND tax_cd  = p_tax_cd)  --d1_rec.tax_cd)
       GROUP BY b.item_grp, A.peril_cd;

  BEGIN
    IF p_policy_id  = 0 AND
    p_pol_id_n   = 0 AND
    p_old_par_id = 0 THEN -- CONDITION ADDED BY AIVHIE 120301

   FOR c4_rec IN c4
      LOOP

        BEGIN
          DECLARE
            CURSOR c1 IS
              SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate, b.peril_sw,
                     b.tax_id,
                     DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                     DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
      ,takeup_alloc_tag  --jason 9/3/2008
                FROM --GIIS_TAX_PERIL A,
                     GIIS_TAX_CHARGES b
               WHERE b.line_cd         = p_line_cd
                 AND b.iss_cd  (+)     = p_iss_cd
                 AND b.primary_sw      = 'Y'
                 -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
                 -- PAR HAS BEEN CREATED. (LOTH 032200)
                 AND b.eff_start_date  <= p_issue_date
                 AND b.eff_end_date    >= p_issue_date
                 -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
                 -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
                 AND NVL(b.issue_date_tag, 'N') = 'Y';

   CURSOR d1 IS
              SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate, b.tax_id, b.peril_sw,
                     DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                     DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
      ,takeup_alloc_tag  --jason 9/3/2008
                FROM GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
               WHERE b.line_cd         = p_line_cd
                 AND b.iss_cd       (+)= p_iss_cd
                 AND b.iss_cd          = C.iss_cd(+)
                 AND b.line_cd         = C.line_cd(+)
                 AND b.tax_cd          = C.tax_cd(+)
                 AND C.place_cd     (+)= p_place_cd
                 AND b.primary_sw      = 'Y'
                 AND b.eff_start_date <= p_issue_date
                 AND b.eff_end_date   >= p_issue_date
                 AND NVL(b.issue_date_tag, 'N') = 'Y';

   CURSOR c1a IS
              SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate, b.peril_sw,
                     b.tax_id,
                     DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                     DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
      ,takeup_alloc_tag  --jason 9/3/2008
                FROM --GIIS_TAX_PERIL A,
                     GIIS_TAX_CHARGES b
               WHERE b.line_cd         = p_line_cd
                 AND b.iss_cd  (+)     = p_iss_cd
                 AND b.primary_sw      = 'Y'
                 -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
                 -- PAR HAS BEEN CREATED. (LOTH 032200)
                 AND b.eff_start_date <= p_eff_date
                 AND b.eff_end_date   >= p_eff_date
                 -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
                 -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
                 AND NVL(b.issue_date_tag, 'N') = 'N';

      CURSOR d2 IS
              SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate, b.peril_sw,b.tax_id,
                     DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                     DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
      ,takeup_alloc_tag  --jason 9/3/2008
                FROM GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
               WHERE b.line_cd         = p_line_cd
                 AND b.iss_cd       (+)= p_iss_cd
                 AND b.iss_cd          = C.iss_cd(+)
                 AND b.line_cd         = C.line_cd(+)
                 AND b.tax_cd          = C.tax_cd(+)
                 AND C.place_cd     (+)= p_place_cd
                 AND b.primary_sw      = 'Y'
                 AND b.eff_start_date <= p_eff_date
                 AND b.eff_end_date   >= p_eff_date
                 AND NVL(b.issue_date_tag, 'N') = 'N';

    BEGIN
            IF p_place_cd IS NOT NULL THEN
              FOR d1_rec IN d1
              LOOP
                BEGIN
                  /*DECLARE
                    CURSOR c3 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                       GROUP BY b.item_grp, A.peril_cd;

     CURSOR c5 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                         AND A.peril_cd IN (SELECT peril_cd
                                              FROM GIIS_TAX_PERIL
                                             WHERE line_cd = p_line_cd
                                               AND iss_cd  = p_iss_cd
                                               AND tax_cd  = d1_rec.tax_cd)
                       GROUP BY b.item_grp, A.peril_cd; */ --moved by jason 9/4/2008
                  BEGIN
                    p_tax_id   :=  d1_rec.tax_id;
                    IF d1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP

                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * NVL(d1_rec.rate,0) / 100;
                            IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                              IF c3_rec.prem_amt > 0 THEN
                          p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
                     ELSE
                           p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
                     END IF;
                            END IF;
                   --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
               IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                           FROM GIIS_ASSURED b,
                                                GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                         AND a.par_id = p_par_id)
                              LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
                                END IF;
                END LOOP;
                            END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                    ELSE

       BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,d1_rec.tax_cd)
                        LOOP

                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * NVL(d1_rec.rate,0) / 100;
                            IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                              IF c5_rec.prem_amt > 0 THEN
                         p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
                     ELSE
                           p_tax_amt := FLOOR(c5_rec.prem_amt / 4) * (0.5);
                     END IF;
                            END IF;
                   --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
               IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                        FROM GIIS_ASSURED b,
                                                GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                            AND a.par_id = p_par_id)
                LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
              END IF;
                   END LOOP;
                   END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
    --A.R.C. 04.10.2007
          --replace code to consider VAT_TAG
                   /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                    VALUES
                     (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          d1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          d1_rec.tax_alloc,
                      d1_rec.fixed_tax_alloc);*/

     --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
    /*  IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
         tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
      ELSE
         tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
      END IF;
     */
    IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
             FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                                   FROM GIIS_ASSURED b,
                                        GIPI_WPOLBAS a
                                  WHERE b.assd_no = a.assd_no
                                    AND a.par_id = p_par_id)
                      LOOP
                IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
        --IF c4_rec.takeup_seq_no = 1 THEN  --replaced the condition by jason: 9/3/2008
        IF (c4_rec.takeup_seq_no = 1 AND d1_rec.takeup_alloc_tag = 'F') OR
           (c4_rec.takeup_seq_no = p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup : jason 9/3/2008

       INSERT INTO GIPI_WINV_TAX
                             (par_id,                 item_grp,          tax_cd,
                              line_cd,                iss_cd,            rate,
                              tax_amt,                tax_id,            tax_allocation,
                              fixed_tax_allocation,   takeup_seq_no)
                            VALUES
                             (p_par_id,               c4_rec.item_grp,   d1_rec.tax_cd,
                              p_line_cd,              p_iss_cd,          d1_rec.rate,
                              tax_amt_per_group1,     p_tax_id,          d1_rec.tax_alloc,
                              d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

        ELSIF (c4_rec.takeup_seq_no <> 1 AND d1_rec.takeup_alloc_tag = 'F') OR
              (c4_rec.takeup_seq_no <> p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN --tax allocated on first or last takeup: jason 9/3/2008

          INSERT INTO GIPI_WINV_TAX
                             (par_id,                 item_grp,          tax_cd,
                              line_cd,                iss_cd,            rate,
                              tax_amt,                tax_id,            tax_allocation,
                              fixed_tax_allocation,   takeup_seq_no)
                            VALUES
                             (p_par_id,               c4_rec.item_grp,   d1_rec.tax_cd,
                              p_line_cd,              p_iss_cd,          0,
                              0,                      p_tax_id,          d1_rec.tax_alloc,
                              d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);


        ELSIF d1_rec.takeup_alloc_tag = 'S' THEN --tax is spread on all takeups: jason 9/3/2008
          INSERT INTO GIPI_WINV_TAX
                             (par_id,                 item_grp,          tax_cd,
                              line_cd,                iss_cd,            rate,
                              tax_amt,                tax_id,            tax_allocation,
                              fixed_tax_allocation,   takeup_seq_no)
                            VALUES
                             (p_par_id,               c4_rec.item_grp,   d1_rec.tax_cd,
                              p_line_cd,              p_iss_cd,          d1_rec.rate,
                              (tax_amt_per_group1/p_no_of_takeup),     p_tax_id,          d1_rec.tax_alloc,
                              d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
        END IF;
                        END IF;
                      END LOOP;
          ELSE --not EVAT
       --IF c4_rec.takeup_seq_no = 1 THEN  --replaced the condition by jason: 9/3/2008
       IF (c4_rec.takeup_seq_no = 1 AND d1_rec.takeup_alloc_tag = 'F') OR   --tax allocated on first or last takeup: jason 9/3/2008
                         (c4_rec.takeup_seq_no = p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L')  THEN
      INSERT INTO GIPI_WINV_TAX
                         (par_id,                 item_grp,          tax_cd,
                          line_cd,                iss_cd,            rate,
                          tax_amt,                tax_id,            tax_allocation,
                          fixed_tax_allocation,   takeup_seq_no)
                        VALUES
                         (p_par_id,               c4_rec.item_grp,   d1_rec.tax_cd,
                          p_line_cd,              p_iss_cd,          d1_rec.rate,
                          tax_amt_per_group1,     p_tax_id,          d1_rec.tax_alloc,
                          d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

       ELSIF (c4_rec.takeup_seq_no <> 1 AND d1_rec.takeup_alloc_tag = 'F') OR
          (c4_rec.takeup_seq_no <> p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN --tax allocated on first or last takeup: jason 9/3/2008

         INSERT INTO GIPI_WINV_TAX
                         (par_id,                 item_grp,          tax_cd,
                          line_cd,                iss_cd,            rate,
                          tax_amt,                tax_id,            tax_allocation,
                          fixed_tax_allocation,   takeup_seq_no)
                        VALUES
                         (p_par_id,               c4_rec.item_grp,   d1_rec.tax_cd,
                          p_line_cd,              p_iss_cd,          0,
                          0,                      p_tax_id,          d1_rec.tax_alloc,
                          d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

       ELSIF d1_rec.takeup_alloc_tag = 'S' THEN --tax is spread on all takeups: jason 9/3/2008
         INSERT INTO GIPI_WINV_TAX
                         (par_id,                 item_grp,          tax_cd,
                          line_cd,                iss_cd,            rate,
                          tax_amt,                tax_id,            tax_allocation,
                          fixed_tax_allocation,   takeup_seq_no)
                        VALUES
                         (p_par_id,                              c4_rec.item_grp,   d1_rec.tax_cd,
                          p_line_cd,                             p_iss_cd,          d1_rec.rate,
                          (tax_amt_per_group1/p_no_of_takeup),   p_tax_id,          d1_rec.tax_alloc,
                          d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
       END IF;
          END IF;  --end 04.10.2007
                  END;
                  p_tax_amt          := 0;
                  tax_amt_per_group1 := 0;
                END;
              END LOOP;

     FOR d2_rec IN d2
              LOOP
                BEGIN
                  /*DECLARE
                    CURSOR c3 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                       GROUP BY b.item_grp, A.peril_cd;

     CURSOR c5 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                         AND A.peril_cd IN (SELECT peril_cd
                                              FROM GIIS_TAX_PERIL
                                             WHERE line_cd = p_line_cd
                                               AND iss_cd  = p_iss_cd
                                               AND tax_cd  = d2_rec.tax_cd)
                       GROUP BY b.item_grp, A.peril_cd; */
                  BEGIN
                    p_tax_id   :=  d2_rec.tax_id;
                    IF d2_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * NVL(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                              IF c3_rec.prem_amt > 0 THEN
                         p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
                     ELSE
                          p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
                     END IF;
                            END IF;
                   --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
               IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                          FROM GIIS_ASSURED b,
                                               GIPI_WPOLBAS a
                                     WHERE b.assd_no = a.assd_no
                                            AND a.par_id = p_par_id)
                              LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
              END IF;
                   END LOOP;
                   END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                    ELSE

       BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,d2_rec.tax_cd)
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * NVL(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                              IF c5_rec.prem_amt > 0 THEN
                                p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
                              ELSE
                                p_tax_amt := FLOOR(c5_rec.prem_amt / 4) * (0.5);
                     END IF;
                     tax_amt_per_group1 := p_tax_amt;
                            END IF;
                   --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
               IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                        FROM GIIS_ASSURED b,
                                             GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                         AND a.par_id = p_par_id)
                              LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
                END IF;
                END LOOP;
                            END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                       END LOOP;
                      END;
                    END IF;
           --A.R.C. 04.10.2007
           --replace code to consider VAT_TAG
                    /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                    VALUES
                     (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          d2_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
                      d2_rec.fixed_tax_alloc);*/
         --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
        /*  IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
             tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
          ELSE
             tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
          END IF;
            */
     IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
             FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                                   FROM GIIS_ASSURED b,
                                        GIPI_WPOLBAS a
                                  WHERE b.assd_no = a.assd_no
                                    AND a.par_id = p_par_id)
                      LOOP
                IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0)THEN
                          --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
        IF (c4_rec.takeup_seq_no = 1 AND d2_rec.takeup_alloc_tag = 'F') OR
           (c4_rec.takeup_seq_no = p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or Last takeup: jason 9/3/2008

          INSERT INTO GIPI_WINV_TAX
                            (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                            tax_amt,             tax_id,            tax_allocation,
                            fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                            p_line_cd,            p_iss_cd,          d2_rec.rate,
                            tax_amt_per_group1,   p_tax_id,          d2_rec.tax_alloc,
                            d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

        ELSIF (c4_rec.takeup_seq_no <> 1 AND d2_rec.takeup_alloc_tag = 'F') OR
              (c4_rec.takeup_seq_no <> p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or Last takeup: jason 9/3/2008

          INSERT INTO GIPI_WINV_TAX
                            (par_id,             item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                            tax_amt,             tax_id,            tax_allocation,
                            fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,           c4_rec.item_grp,   d2_rec.tax_cd,
                            p_line_cd,           p_iss_cd,          0,
                            0,                   p_tax_id,          d2_rec.tax_alloc,
                            d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

        ELSIF  d2_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
             INSERT INTO GIPI_WINV_TAX
                            (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                            tax_amt,             tax_id,            tax_allocation,
                            fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,                              c4_rec.item_grp,   d2_rec.tax_cd,
                            p_line_cd,                              p_iss_cd,          d2_rec.rate,
                            (tax_amt_per_group1/p_no_of_takeup),    p_tax_id,          d2_rec.tax_alloc,
                            d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

                          END IF;
      END IF;
                      END LOOP;
                    ELSE --not EVAT
       --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
       IF (c4_rec.takeup_seq_no = 1 AND d2_rec.takeup_alloc_tag = 'F') OR
       (c4_rec.takeup_seq_no = p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or Last takeup: jason 9/3/2008

                        INSERT INTO GIPI_WINV_TAX
                        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                        VALUES
                        (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          d2_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
                        d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

       ELSIF (c4_rec.takeup_seq_no <> 1 AND d2_rec.takeup_alloc_tag = 'F') OR
          (c4_rec.takeup_seq_no <> p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on last takeup

      INSERT INTO GIPI_WINV_TAX
                        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                        VALUES
                        (p_par_id,           c4_rec.item_grp,   d2_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          0,
                        0,                   p_tax_id,          d2_rec.tax_alloc,
                        d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

       ELSIF  d2_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
         INSERT INTO GIPI_WINV_TAX
                        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                        VALUES
                        (p_par_id,                          c4_rec.item_grp,   d2_rec.tax_cd,
                        p_line_cd,                          p_iss_cd,          d2_rec.rate,
                        tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          d2_rec.tax_alloc,
                        d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
       END IF;
                    END IF;  --end 04.10.2007
                  END;
                  p_tax_amt          := 0;
                  tax_amt_per_group1 := 0;
                END;
              END LOOP;
            ELSE

     FOR c1_rec IN c1
              LOOP

				BEGIN


				  /*DECLARE
                    CURSOR c3 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                       GROUP BY b.item_grp, A.peril_cd;

     CURSOR c5 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                         AND A.peril_cd IN (SELECT peril_cd
                                              FROM GIIS_TAX_PERIL
                                             WHERE line_cd = p_line_cd
                                               AND iss_cd  = p_iss_cd
                                               AND tax_cd  = c1_rec.tax_cd)
                       GROUP BY b.item_grp, A.peril_cd;*/  --commented by jason: 9/4/2008: duplicate declaration
                  BEGIN
                    p_tax_id   :=  c1_rec.tax_id;
                    IF c1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * c1_rec.rate / 100;
                            IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                              IF c3_rec.prem_amt > 0 THEN
                         p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
                     ELSE
                         p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
                     END IF;
                            END IF;
                   --  A.R.C. 04.10.2007
             -- add code to consider VAT_TAG
               IF c1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                           FROM GIIS_ASSURED b,
                                                GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                            AND a.par_id = p_par_id)
                              LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
              END IF;
                END LOOP;
                            END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                    ELSE

       BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,c1_rec.tax_cd)
                        LOOP

						  BEGIN
                            p_tax_amt := c5_rec.prem_amt * c1_rec.rate / 100;
                            IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                     IF c5_rec.prem_amt > 0 THEN
                         p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
                     ELSE
                                p_tax_amt := FLOOR(c5_rec.prem_amt / 4) * (0.5);
                     END IF;
                            END IF;
                   --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
               IF c1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                           FROM GIIS_ASSURED b,
                                                GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                            AND a.par_id = p_par_id)
                LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
              END IF;
                END LOOP;
                            END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                    END IF;
     --IF TAX_AMT_PER_GROUP1 != 0 THEN
                   --A.R.C. 04.10.2007
          --replace code to consider VAT_TAG
                   /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                    VALUES
                     (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                      c1_rec.fixed_tax_alloc);*/
         --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
         /* IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
             tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
          ELSE
             tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
          END IF;
                */
     IF c1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
             FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                                   FROM GIIS_ASSURED b,
                                        GIPI_WPOLBAS a
                                  WHERE b.assd_no = a.assd_no
                                    AND a.par_id = p_par_id)
                      LOOP
                IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
                          --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
                          IF (c4_rec.takeup_seq_no = 1 AND c1_rec.takeup_alloc_tag = 'F') OR
           (c4_rec.takeup_seq_no = p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008



	   INSERT INTO GIPI_WINV_TAX
                            (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                          tax_amt,             tax_id,            tax_allocation,
                          fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                            p_line_cd,           p_iss_cd,          c1_rec.rate,
                          tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                          c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);


        ELSIF (c4_rec.takeup_seq_no <> 1 AND c1_rec.takeup_alloc_tag = 'F') OR
           (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008


		   INSERT INTO GIPI_WINV_TAX
                            (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                          tax_amt,             tax_id,            tax_allocation,
                          fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,           c4_rec.item_grp,   c1_rec.tax_cd,
                            p_line_cd,           p_iss_cd,          0,
                          0,                   p_tax_id,          c1_rec.tax_alloc,
                          c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);


        ELSIF  c1_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008


	   INSERT INTO GIPI_WINV_TAX
                            (par_id,             item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                          tax_amt,             tax_id,            tax_allocation,
                          fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,                            c4_rec.item_grp,   c1_rec.tax_cd,
                            p_line_cd,                            p_iss_cd,          c1_rec.rate,
                          (tax_amt_per_group1/p_no_of_takeup),  p_tax_id,          c1_rec.tax_alloc,
                          c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

		END IF;
                        END IF;
                      END LOOP;
                    ELSE --not EVAT
       --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
                      IF (c4_rec.takeup_seq_no = 1 AND c1_rec.takeup_alloc_tag = 'F') OR
       (c4_rec.takeup_seq_no = p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

      INSERT INTO GIPI_WINV_TAX
                        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                        VALUES
                        (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          c1_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                        c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);


       ELSIF (c4_rec.takeup_seq_no <> 1 AND c1_rec.takeup_alloc_tag = 'F') OR
          (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008


	  INSERT INTO GIPI_WINV_TAX
                        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                        VALUES
                        (p_par_id,           c4_rec.item_grp,   c1_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          0,
                        0,                   p_tax_id,          c1_rec.tax_alloc,
                        c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

       ELSIF  c1_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008

	  INSERT INTO GIPI_WINV_TAX
                        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                        VALUES
                        (p_par_id,                            c4_rec.item_grp,   c1_rec.tax_cd,
                        p_line_cd,                            p_iss_cd,          c1_rec.rate,
                        (tax_amt_per_group1/p_no_of_takeup),  p_tax_id,          c1_rec.tax_alloc,
                        c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

       END IF;
                    END IF;  --end 04.10.2007
        --END IF;
                  END;
                  p_tax_amt          := 0;
                  tax_amt_per_group1 := 0;
                END;
              END LOOP;

     FOR c1a_rec IN c1a
              LOOP
                BEGIN
                  DECLARE
				    v_peril_sw2 VARCHAR2(2) := 'N'; --aaron
				  /*DECLARE
                    CURSOR c3 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                       GROUP BY b.item_grp, A.peril_cd;

     CURSOR c5 IS
                      SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                             SUM(NVL(A.tsi_amt,0)) tsi_amt
                        FROM GIPI_WITMPERL A, GIPI_WITEM b
                       WHERE A.par_id   = p_par_id
                         AND A.par_id   = b.par_id
                         AND A.item_no  = b.item_no
                         AND b.item_grp = c4_rec.item_grp
                         AND A.peril_cd IN (SELECT peril_cd
                                              FROM GIIS_TAX_PERIL
                                             WHERE line_cd = p_line_cd
                                               AND iss_cd  = p_iss_cd
                                               AND tax_cd  = c1a_rec.tax_cd)
                       GROUP BY b.item_grp, A.peril_cd;*/  --commented by jason: 9/4/2008: duplicate declaration
                  BEGIN
                    p_tax_id   :=  c1a_rec.tax_id;
                    IF c1a_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            v_prem_amt := c3_rec.prem_amt + NVL(v_prem_amt,0); ----ADDED BY BDARUSIN, COPIED FROM OLD CREATE_WINVOICE
                            p_tax_amt  := c3_rec.prem_amt * c1a_rec.rate / 100;
                   --  A.R.C. 04.10.2007
              --add code to consider VAT_TAG

       IF c1a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                          FROM GIIS_ASSURED b,
                                             GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                            AND a.par_id = p_par_id)
                              LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                     p_tax_amt := 0;
                 END IF;
                END LOOP;
                            END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                    ELSE

       BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,c1a_rec.tax_cd)
                        LOOP
                          v_peril_sw2 := 'Y';
						  BEGIN
                            v_prem_amt := c5_rec.prem_amt + NVL(v_prem_amt,0); --B
                            p_tax_amt  := c5_rec.prem_amt * c1a_rec.rate / 100;
                   --  A.R.C. 04.10.2007
              -- add code to consider VAT_TAG
               IF c1a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                       FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                        FROM GIIS_ASSURED b,
                                             GIPI_WPOLBAS a
                                          WHERE b.assd_no = a.assd_no
                                            AND a.par_id = p_par_id)
                              LOOP
                    IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
                  p_tax_amt := 0;
              END IF;
                END LOOP;
                   END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                    END IF;

     IF c1a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                      IF v_prem_amt > 0 THEN
                 tax_amt_per_group1 := CEIL(v_prem_amt / 4) * (0.5);
                      ELSE
                 tax_amt_per_group1 := FLOOR(v_prem_amt / 4) * (0.5);
             END IF;
                    END IF;
     --IF TAX_AMT_PER_GROUP1 != 0 THEN
                   --A.R.C. 04.10.2007
          --replace code to consider VAT_TAG
                    /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                    VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1a_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc);*/
           --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
        /*  IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
             tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
          ELSE
             tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
          END IF;
             */
     IF c1a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
             FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                                   FROM GIIS_ASSURED b,
                                        GIPI_WPOLBAS a
                                  WHERE b.assd_no = a.assd_no
                                    AND a.par_id = p_par_id)
                      LOOP
                IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
                        --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
                          IF (c4_rec.takeup_seq_no = 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
           (c4_rec.takeup_seq_no = p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008  INSERT INTO GIPI_WINV_TAX

          IF (c1a_rec.peril_sw = 'N') OR (c1a_rec.peril_sw = 'Y' AND v_peril_sw2 = 'Y') THEN --aaron
		  INSERT INTO GIPI_WINV_TAX
          (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                            tax_amt,             tax_id,            tax_allocation,
                            fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                            p_line_cd,           p_iss_cd,          c1a_rec.rate,
                          tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                          c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
			END IF;

        ELSIF (c4_rec.takeup_seq_no <> 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
              (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008  INSERT INTO GIPI_WINV_TAX
           IF (c1a_rec.peril_sw = 'N') OR (c1a_rec.peril_sw = 'Y' AND v_peril_sw2 = 'Y') THEN --aaron
          INSERT INTO GIPI_WINV_TAX
                            (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                            tax_amt,             tax_id,            tax_allocation,
                            fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                            p_line_cd,           p_iss_cd,          0,
                          0,  p_tax_id,          c1a_rec.tax_alloc,
                          c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
         END IF;
        ELSIF  c1a_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
       IF (c1a_rec.peril_sw = 'N') OR (c1a_rec.peril_sw = 'Y' AND v_peril_sw2 = 'Y') THEN --aaron
	   INSERT INTO GIPI_WINV_TAX
                            (par_id,              item_grp,          tax_cd,
                            line_cd,             iss_cd,            rate,
                            tax_amt,             tax_id,            tax_allocation,
                            fixed_tax_allocation, takeup_seq_no)
                            VALUES
                            (p_par_id,                            c4_rec.item_grp,   c1a_rec.tax_cd,
                            p_line_cd,                            p_iss_cd,          c1a_rec.rate,
                          (tax_amt_per_group1/p_no_of_takeup),  p_tax_id,          c1a_rec.tax_alloc,
                          c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

        END IF;
        END IF;
                        END IF;
             END LOOP;
          ELSE --not EVAT
                     --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
                     IF (c4_rec.takeup_seq_no = 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
      (c4_rec.takeup_seq_no = p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008  INSERT INTO GIPI_WINV_TAX

        IF (c1a_rec.peril_sw = 'N') OR (c1a_rec.peril_sw = 'Y' AND v_peril_sw2 = 'Y') THEN --aaron
		INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                       VALUES
                        (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                         p_line_cd,           p_iss_cd,          c1a_rec.rate,
                         tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                         c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
		END IF;

      ELSIF (c4_rec.takeup_seq_no <> 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
        (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008  INSERT INTO GIPI_WINV_TAX

        IF (c1a_rec.peril_sw = 'N') OR (c1a_rec.peril_sw = 'Y' AND v_peril_sw2 = 'Y') THEN --aaron
		INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                       VALUES
                       (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          0,
                       0,  p_tax_id,          c1a_rec.tax_alloc,
                       c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
         END IF;
      ELSIF  c1a_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
        IF (c1a_rec.peril_sw = 'N') OR (c1a_rec.peril_sw = 'Y' AND v_peril_sw2 = 'Y') THEN --aaron
		INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                       VALUES
                        (p_par_id,                            c4_rec.item_grp,   c1a_rec.tax_cd,
                         p_line_cd,                           p_iss_cd,          c1a_rec.rate,
                        (tax_amt_per_group1/p_no_of_takeup),  p_tax_id,          c1a_rec.tax_alloc,
                         c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
        END IF;
	  END IF;
                    END IF;  --end 04.10.2007
         --END IF;
                  END;
                  p_tax_amt          := 0;
                  tax_amt_per_group1 := 0;
          v_prem_amt         := 0; --bdarusin 12022002
                END;
              END LOOP;
            END IF;
          END;
        END;
      END LOOP;
---***---
    ELSE
---***---
      DECLARE
        p_tax_id      GIIS_TAX_CHARGES.tax_id%TYPE;
        v_line_cd     GIPI_POLBASIC.line_cd%TYPE;
   v_subline_cd  GIPI_POLBASIC.subline_cd%TYPE;
   v_iss_cd      GIPI_POLBASIC.iss_cd%TYPE;
   v_issue_yy    GIPI_POLBASIC.issue_yy%TYPE;
   v_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE;
   v_renew_no    GIPI_POLBASIC.renew_no%TYPE;

  /*Modified by Iris Bordey 12.09.2003
   **Problem : ORA-02291 on table gipi_winv_tax (parent rec, from gipi_winvoice not found)
   **Resolution : Since at this point necessary insert/update were made already to
   **           : to gipi_winvoice and since it is "non-existing" item_grp from gipi_winvoice
     **           : that causes the ora error, query for item_grp will come from gipi_winvoice.
   **Note       : ORA-02291 error on table gipi_winvperl will be handled.
   */
   CURSOR c4 IS
         SELECT item_grp, takeup_seq_no
            FROM GIPI_WINVOICE A
           WHERE par_id = p_par_id
             AND ((NVL(p_pack,'N') = 'Y'
                   AND EXISTS (SELECT '1'
                                 FROM GIPI_WITMPERL b, GIPI_WITEM C
                                WHERE C.par_id   = A.par_id
                 AND C.item_grp = A.item_grp
                 AND b.par_id   = C.par_id
                                 AND b.item_no  = C.item_no))
                   OR (NVL(p_pack,'N') = 'N'));
        /** Modified by : Iris Bordey 09.30.03
      To resolve ora-02291 on gipi_winvperil for package policies.
    Checks if item_grp (from gipi_witem) has corresponding peril on
    gipi_witemperil**/
     /*CURSOR c4 IS
       SELECT DISTINCT a.item_grp
            FROM gipi_witem a
           WHERE a.par_id = p_par_id
             AND (NVL(p_pack,'N') = 'Y'
          AND EXISTS (SELECT '1'
                           FROM gipi_witmperl b
               WHERE b.par_id = a.par_id
                   AND b.item_no = a.item_no))
       OR (NVL(p_pack,'N') = 'N');*/
        /*SELECT DISTINCT item_grp
          FROM gipi_witem
         WHERE par_id = p_par_id;**/
        -- AND ITEM_GRP = PREV_ITEM_GRP; -- COMMENTED BY : AIVHIE 112301
                                         -- IF NOT COMMENTED WILL INSERT ONLY ONE ITEM_GRP
                    -- TO GIPI_INV_TAX


  --moved the cursors here to avoid repeated declaration:  jason 9/4/2008
      CURSOR c3 (p_item_grp GIPI_WITEM.ITEM_GRP%TYPE)
        IS
        SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
               SUM(NVL(A.tsi_amt,0)) tsi_amt
          FROM GIPI_WITMPERL A, GIPI_WITEM b
         WHERE A.par_id   = p_par_id
           AND A.par_id   = b.par_id
           AND A.item_no  = b.item_no
           AND b.item_grp = p_item_grp --c4_rec.item_grp
         GROUP BY b.item_grp, A.peril_cd;

      CURSOR c5 (p_item_grp GIPI_WITEM.item_grp%TYPE
                ,p_tax_cd   GIIS_TAX_PERIL.tax_cd%TYPE)
        IS
        SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
               SUM(NVL(A.tsi_amt,0)) tsi_amt
          FROM GIPI_WITMPERL A, GIPI_WITEM b
         WHERE A.par_id   = p_par_id
           AND A.par_id   = b.par_id
           AND A.item_no  = b.item_no
           AND b.item_grp = p_item_grp  --c4_rec.item_grp
           AND A.peril_cd IN (SELECT peril_cd
                                FROM GIIS_TAX_PERIL
                               WHERE line_cd = p_line_cd
                                 AND iss_cd  = p_iss_cd
                                 AND tax_cd  = p_tax_cd)  --d1_rec.tax_cd)
         GROUP BY b.item_grp, A.peril_cd;

      BEGIN
   /*
   ** ADDED BY : AIVHIE 112401
   ** TO HANDLE POLICY SUMMARY DETAILS
   */
      FOR pol IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                      FROM GIPI_POLBASIC
          WHERE policy_id = p_policy_id)
        LOOP
          v_line_cd    := pol.line_cd;
         v_subline_cd := pol.subline_cd;
       v_iss_cd     := pol.iss_cd;
       v_issue_yy   := pol.issue_yy;
       v_pol_seq_no := pol.pol_seq_no;
       v_renew_no   := pol.renew_no;
       EXIT;
        END LOOP;

  FOR c4_rec IN c4
     LOOP
       BEGIN
            DECLARE
              CURSOR c1 IS
                SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate, b.peril_sw,
                       b.tax_id,
                       DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                       DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
        ,takeup_alloc_tag  --jason 9/3/2008
                  FROM --GIIS_TAX_PERIL A,
                       GIIS_TAX_CHARGES b
                 WHERE b.line_cd         = p_line_cd
                   AND b.iss_cd  (+)     = p_iss_cd
                   --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
                                           -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
                       -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
                       -- TAX_CD (WHICH ARE OPTIONAL)
                       -- FROM THE COPIED POLICY OR PAR
                         -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
                         -- PAR HAS BEEN CREATED. (LOTH 032200)
                   AND b.eff_start_date  <= p_issue_date
                 AND b.eff_end_date    >= p_issue_date
                   -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
            -- PER ITEM_GRP.
            -- ADDED BY : AIVHIE 112301
          AND b.tax_cd IN (SELECT tax_cd
                                FROM GIPI_INV_TAX
                    WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                                --08222002
                                          --FOR OPTIMIZATION PURPOSES
                     AND item_grp = c4_rec.item_grp
                        AND prem_seq_no IN (SELECT prem_seq_no
                                                             FROM GIPI_INVOICE
                                WHERE policy_id IN (SELECT policy_id
                                                                 FROM GIPI_POLBASIC
                                     WHERE line_cd    = v_line_cd
                                         AND subline_cd = v_subline_cd
                                      AND iss_cd     = v_iss_cd
                                      AND issue_yy   = v_issue_yy
                                      AND pol_seq_no = v_pol_seq_no
                                      AND renew_no   = v_renew_no))
                UNION
           SELECT tax_cd
                  FROM GIPI_INV_TAX
                 WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                     --08222002
                                     --FOR OPTIMIZATION PURPOSES
                   AND item_grp = c4_rec.item_grp
                   AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id = p_pol_id_n)
          UNION
            SELECT tax_cd
                       FROM GIPI_WINV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND par_id   = p_old_par_id)
               -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
               -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
             AND NVL(b.issue_date_tag, 'N') = 'Y';
         CURSOR d1 IS
             SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate, b.tax_id, b.peril_sw,
                    DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
     ,takeup_alloc_tag  --jason 9/3/2008
               FROM GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd       (+)= p_iss_cd
                AND b.iss_cd          = C.iss_cd(+)
                AND b.line_cd         = C.line_cd(+)
                AND b.tax_cd          = C.tax_cd(+)
                AND C.place_cd     (+)= p_place_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
                                  -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
             -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
             -- TAX_CD (WHICH ARE OPTIONAL)
             -- FROM THE COPIED POLICY OR PAR
                AND b.eff_start_date <= p_issue_date
             AND b.eff_end_date   >= p_issue_date
               -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
      -- PER ITEM_GRP.
      -- ADDED BY : AIVHIE 112301
    AND b.tax_cd IN (SELECT tax_cd
                       FROM GIPI_INV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id IN (SELECT policy_id
                                     FROM GIPI_POLBASIC
                     WHERE line_cd    = v_line_cd
                       AND subline_cd = v_subline_cd
                    AND iss_cd     = v_iss_cd
                    AND issue_yy   = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND renew_no   = v_renew_no))
                   UNION
         SELECT tax_cd
                       FROM GIPI_INV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id = p_pol_id_n)
          UNION
            SELECT tax_cd
                       FROM GIPI_WINV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND par_id   = p_old_par_id)
             AND NVL(b.issue_date_tag, 'N') = 'Y';
          CURSOR c1a IS
             SELECT DISTINCT b.tax_cd, NVL(b.rate,0) rate, b.peril_sw,
                    b.tax_id,
                    DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
     ,takeup_alloc_tag  --jason 9/3/2008
               FROM --GIIS_TAX_PERIL A,
                   GIIS_TAX_CHARGES b
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd  (+)     = p_iss_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
                                  -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
             -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
             -- TAX_CD (WHICH ARE OPTIONAL)
             -- FROM THE COPIED POLICY OR PAR
               -- THE TAX FETCHED SHOULD HAVE BEEN IN EFFECT BEFORE THE
               -- PAR HAS BEEN CREATED. (LOTH 032200)
             AND b.eff_start_date <= p_eff_date
             AND b.eff_end_date   >= p_eff_date
               -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
      -- PER ITEM_GRP.
      -- ADDED BY : AIVHIE 112301
    AND b.tax_cd IN (SELECT tax_cd
                       FROM GIPI_INV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id IN (SELECT policy_id
                                     FROM GIPI_POLBASIC
                     WHERE line_cd    = v_line_cd
                       AND subline_cd = v_subline_cd
                    AND iss_cd     = v_iss_cd
                    AND issue_yy   = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND renew_no   = v_renew_no))
             UNION
         SELECT tax_cd
                       FROM GIPI_INV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id = p_pol_id_n)
          UNION
            SELECT tax_cd
                       FROM GIPI_WINV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND par_id   = p_old_par_id)
               -- IF ISSUE_DATE_TAG = 'y', TAX WILL BE CONSIDERED BASED
               -- ON ISSUE_DATE ELSE ON EFF_DATE (LOTH 032200)
             AND NVL(b.issue_date_tag, 'N') = 'N';
         CURSOR d2 IS
             SELECT DISTINCT b.tax_cd, NVL(NVL(C.rate, b.rate),0) rate, b.peril_sw,b.tax_id,
                    DECODE(b.allocation_tag,'F','F','N','F','L','L','S','S','F') tax_alloc,
                    DECODE(b.allocation_tag,'N','N','Y') fixed_tax_alloc
     ,takeup_alloc_tag  --jason 9/3/2008
               FROM GIIS_TAX_CHARGES b, GIIS_TAX_ISSUE_PLACE C
              WHERE b.line_cd         = p_line_cd
                AND b.iss_cd       (+)= p_iss_cd
                AND b.iss_cd          = C.iss_cd(+)
                AND b.line_cd         = C.line_cd(+)
                AND b.tax_cd          = C.tax_cd(+)
                AND C.place_cd     (+)= p_place_cd
                --AND B.PRIMARY_SW      = 'y' -- COMMENTED BY AIVHIE 112301
                                  -- IF NOT COMMENTED WILL ONLY SELECT REQUIRED
             -- TAX_CD,THUS, WILL NOT BE ABLE TO FETCH OTHER
             -- TAX_CD (WHICH ARE OPTIONAL)
             -- FROM THE COPIED POLICY OR PAR
                AND b.eff_start_date <= p_eff_date
             AND b.eff_end_date   >= p_eff_date
               -- THE FF. CONDITION ADDED TO FILTER THE TAX_CD TO BE INSERTED
      -- PER ITEM_GRP.
      -- ADDED BY : AIVHIE 112301
    AND b.tax_cd IN (SELECT tax_cd
                       FROM GIPI_INV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id IN (SELECT policy_id
                                     FROM GIPI_POLBASIC
                     WHERE line_cd    = v_line_cd
                       AND subline_cd = v_subline_cd
                    AND iss_cd     = v_iss_cd
                    AND issue_yy   = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND renew_no   = v_renew_no))
             UNION
         SELECT tax_cd
                       FROM GIPI_INV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND prem_seq_no IN (SELECT prem_seq_no
                                     FROM GIPI_INVOICE
                      WHERE policy_id = p_pol_id_n)
          UNION
            SELECT tax_cd
                       FROM GIPI_WINV_TAX
             WHERE iss_cd = b.iss_cd --THIS LINE IS ADDED BY BDARUSIN
                                  --08222002
                                  --FOR OPTIMIZATION PURPOSES
            AND item_grp = c4_rec.item_grp
               AND par_id   = p_old_par_id)
             AND NVL(b.issue_date_tag, 'N') = 'N';
       BEGIN
         IF p_place_cd IS NOT NULL THEN
            FOR d1_rec IN d1
             LOOP
               BEGIN
                 /*DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                        SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM GIIS_TAX_PERIL
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = d1_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;*/ --moved by jason 9/4/2008: to avoid multiple declaration
                 BEGIN
                   p_tax_id   :=  d1_rec.tax_id;
                   IF d1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * NVL(d1_rec.rate,0) / 100;
                IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                       IF c3_rec.prem_amt > 0 THEN
              p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
          ELSE
                p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
          END IF;
                            END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,d1_rec.tax_cd)
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * NVL(d1_rec.rate,0) / 100;
       IF d1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                       IF c5_rec.prem_amt > 0 THEN
             p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
          ELSE
                p_tax_amt := FLOOR(c5_rec.prem_amt / 4) * (0.5);
          END IF;
                   END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                  END IF;
                  /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          d1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          d1_rec.tax_alloc,
                      d1_rec.fixed_tax_alloc);*/
       --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
/*      IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
       tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
      ELSE
       tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
      END IF;
*/                 IF d1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
        FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                              FROM GIIS_ASSURED b,
                                   GIPI_WPOLBAS a
                             WHERE b.assd_no = a.assd_no
                               AND a.par_id = p_par_id)
        LOOP
         IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
    --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
            IF (c4_rec.takeup_seq_no = 1 AND d1_rec.takeup_alloc_tag = 'F') OR
      (c4_rec.takeup_seq_no = p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

     INSERT INTO GIPI_WINV_TAX
                (par_id,              item_grp,          tax_cd,
                 line_cd,             iss_cd,            rate,
                 tax_amt,             tax_id,            tax_allocation,
                 fixed_tax_allocation, takeup_seq_no)
              VALUES
                (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
                 p_line_cd,           p_iss_cd,          d1_rec.rate,
                 tax_amt_per_group1,  p_tax_id,          d1_rec.tax_alloc,
                 d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

   ELSIF (c4_rec.takeup_seq_no <> 1 AND d1_rec.takeup_alloc_tag = 'F') OR
         (c4_rec.takeup_seq_no <> p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

     INSERT INTO GIPI_WINV_TAX
                (par_id,              item_grp,          tax_cd,
                 line_cd,             iss_cd,            rate,
                 tax_amt,             tax_id,            tax_allocation,
                 fixed_tax_allocation, takeup_seq_no)
              VALUES
                (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
                 p_line_cd,           p_iss_cd,          0,
                 0,                   p_tax_id,          d1_rec.tax_alloc,
                 d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

            ELSIF  d1_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
     INSERT INTO GIPI_WINV_TAX
                (par_id,              item_grp,          tax_cd,
                 line_cd,             iss_cd,            rate,
                 tax_amt,             tax_id,            tax_allocation,
                 fixed_tax_allocation, takeup_seq_no)
              VALUES
                (p_par_id,                           c4_rec.item_grp,   d1_rec.tax_cd,
                 p_line_cd,                          p_iss_cd,          d1_rec.rate,
                 tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          d1_rec.tax_alloc,
                 d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

   END IF;
         END IF;
        END LOOP;
      ELSE --not EVAT
     IF (c4_rec.takeup_seq_no = 1 AND d1_rec.takeup_alloc_tag = 'F') OR
     (c4_rec.takeup_seq_no = p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

    INSERT INTO GIPI_WINV_TAX
            (par_id,              item_grp,          tax_cd,
             line_cd,             iss_cd,            rate,
             tax_amt,             tax_id,            tax_allocation,
             fixed_tax_allocation, takeup_seq_no)
          VALUES
            (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
             p_line_cd,           p_iss_cd,          d1_rec.rate,
             tax_amt_per_group1,  p_tax_id,          d1_rec.tax_alloc,
             d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  ELSIF (c4_rec.takeup_seq_no <> 1 AND d1_rec.takeup_alloc_tag = 'F') OR
     (c4_rec.takeup_seq_no <> p_no_of_takeup AND d1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

    INSERT INTO GIPI_WINV_TAX
            (par_id,              item_grp,          tax_cd,
             line_cd,             iss_cd,            rate,
             tax_amt,             tax_id,            tax_allocation,
             fixed_tax_allocation, takeup_seq_no)
          VALUES
            (p_par_id,            c4_rec.item_grp,   d1_rec.tax_cd,
             p_line_cd,           p_iss_cd,          0,
             0,                   p_tax_id,          d1_rec.tax_alloc,
             d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  ELSIF  d1_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
    INSERT INTO GIPI_WINV_TAX
            (par_id,              item_grp,          tax_cd,
             line_cd,             iss_cd,            rate,
             tax_amt,             tax_id,            tax_allocation,
             fixed_tax_allocation, takeup_seq_no)
          VALUES
            (p_par_id,                           c4_rec.item_grp,   d1_rec.tax_cd,
             p_line_cd,                          p_iss_cd,          d1_rec.rate,
             tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          d1_rec.tax_alloc,
             d1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
  END IF;
      END IF;  --end 04.10.2007
    END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
             FOR d2_rec IN d2
             LOOP
               BEGIN
                 /*DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM GIIS_TAX_PERIL
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = d2_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;*/ --commented by jason 9/2/2008: duplicate declaration
                 BEGIN
                   p_tax_id   :=  d2_rec.tax_id;
                   IF d2_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * NVL(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                           IF c3_rec.prem_amt > 0 THEN
             p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
          ELSE
             p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
          END IF;
                            END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5 (c4_rec.item_grp,d2_rec.tax_cd)
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * NVL(d2_rec.rate,0) / 100;
                            IF d2_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                           IF c5_rec.prem_amt > 0 THEN
              p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
          ELSE
                p_tax_amt := FLOOR(c5_rec.prem_amt / 4) * (0.5);
          END IF;
                         END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                      END LOOP;
                    END;
                   END IF;
       --A.R.C. 04.10.2007
       --replace code to consider VAT_TAG
                   /*INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          d2_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
                        d2_rec.fixed_tax_alloc);*/
     --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
/*      IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
       tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
      ELSE
       tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
      END IF;
*/                 IF d2_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
        FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                              FROM GIIS_ASSURED b,
                                   GIPI_WPOLBAS a
                             WHERE b.assd_no = a.assd_no
                               AND a.par_id = p_par_id)
        LOOP
         IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
    --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
            IF (c4_rec.takeup_seq_no = 1 AND d2_rec.takeup_alloc_tag = 'F') OR
      (c4_rec.takeup_seq_no = p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

    INSERT INTO GIPI_WINV_TAX
                  (par_id,              item_grp,          tax_cd,
                   line_cd,             iss_cd,            rate,
                   tax_amt,             tax_id,            tax_allocation,
                   fixed_tax_allocation)
                VALUES
                  (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                   p_line_cd,           p_iss_cd,          d2_rec.rate,
                   tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
                   d2_rec.fixed_tax_alloc);

   ELSIF (c4_rec.takeup_seq_no <> 1 AND d2_rec.takeup_alloc_tag = 'F') OR
         (c4_rec.takeup_seq_no <> p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

    INSERT INTO GIPI_WINV_TAX
                  (par_id,              item_grp,          tax_cd,
                   line_cd,             iss_cd,            rate,
                   tax_amt,             tax_id,            tax_allocation,
                   fixed_tax_allocation)
                VALUES
                  (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
                   p_line_cd,           p_iss_cd,          0,
                   0,                   p_tax_id,          d2_rec.tax_alloc,
                   d2_rec.fixed_tax_alloc);

   ELSIF  d2_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
      INSERT INTO GIPI_WINV_TAX
                  (par_id,              item_grp,          tax_cd,
                   line_cd,             iss_cd,            rate,
                   tax_amt,             tax_id,            tax_allocation,
                   fixed_tax_allocation)
                VALUES
                  (p_par_id,                           c4_rec.item_grp,   d2_rec.tax_cd,
                   p_line_cd,                          p_iss_cd,          d2_rec.rate,
                   tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          d2_rec.tax_alloc,
                   d2_rec.fixed_tax_alloc);

   END IF;
         END IF;
        END LOOP;
      ELSE --not EVAT
     --IF c4_rec.takeup_seq_no = 1 THEN
        IF (c4_rec.takeup_seq_no = 1 AND d2_rec.takeup_alloc_tag = 'F') OR
     (c4_rec.takeup_seq_no = p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

   INSERT INTO GIPI_WINV_TAX
              (par_id,              item_grp,          tax_cd,
               line_cd,             iss_cd,            rate,
               tax_amt,             tax_id,            tax_allocation,
               fixed_tax_allocation, takeup_seq_no)
            VALUES
              (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
               p_line_cd,           p_iss_cd,          d2_rec.rate,
               tax_amt_per_group1,  p_tax_id,          d2_rec.tax_alloc,
               d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  ELSIF (c4_rec.takeup_seq_no <> 1 AND d2_rec.takeup_alloc_tag = 'F') OR
        (c4_rec.takeup_seq_no <> p_no_of_takeup AND d2_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

     INSERT INTO GIPI_WINV_TAX
             (par_id,              item_grp,          tax_cd,
              line_cd,             iss_cd,            rate,
              tax_amt,             tax_id,            tax_allocation,
              fixed_tax_allocation, takeup_seq_no)
           VALUES
             (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
              p_line_cd,           p_iss_cd,          0,
              0,                   p_tax_id,          d2_rec.tax_alloc,
              d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  ELSIF  d2_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
   INSERT INTO GIPI_WINV_TAX
              (par_id,              item_grp,          tax_cd,
               line_cd,             iss_cd,            rate,
               tax_amt,             tax_id,            tax_allocation,
               fixed_tax_allocation, takeup_seq_no)
            VALUES
              (p_par_id,            c4_rec.item_grp,   d2_rec.tax_cd,
               p_line_cd,           p_iss_cd,          d2_rec.rate,
               tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          d2_rec.tax_alloc,
               d2_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
  END IF;
      END IF;  --end 04.10.2007
                   END;
                   p_tax_amt          := 0;
                   tax_amt_per_group1 := 0;
                 END;
               END LOOP;
           ELSE
            FOR c1_rec IN c1
             LOOP
               BEGIN
                 /*DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM GIIS_TAX_PERIL
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = c1_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;*/ --commented by jason: 9/4/2008: duplicate declaration
                 BEGIN
                   p_tax_id   :=  c1_rec.tax_id;
                   IF c1_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * c1_rec.rate / 100;
       IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                            IF c3_rec.prem_amt > 0 THEN
             p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
          ELSE
                p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
          END IF;
                       END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF c1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,c1_rec.tax_cd)
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * c1_rec.rate / 100;
                            IF c1_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c5_rec.prem_amt > 0 THEN
             p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
          ELSE
             p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
          END IF;
                         END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF c1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
--                IF TAX_AMT_PER_GROUP1 != 0 THEN
                  --A.R.C. 04.10.2007
      --replace code to consider VAT_TAG
                  /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                      c1_rec.fixed_tax_alloc);*/
    --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
/*      IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
       tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
      ELSE
       tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
      END IF;
*/                IF c1_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
       FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM GIIS_ASSURED b,
                                  GIPI_WPOLBAS a
                            WHERE b.assd_no = a.assd_no
                              AND a.par_id = p_par_id)
       LOOP
        IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
           --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
           IF (c4_rec.takeup_seq_no = 1 AND c1_rec.takeup_alloc_tag = 'F') OR
     (c4_rec.takeup_seq_no = p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

     INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          c1_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                        c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

     ELSIF (c4_rec.takeup_seq_no <> 1 AND c1_rec.takeup_alloc_tag = 'F') OR
        (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

         INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          0,
                        0,                   p_tax_id,          c1_rec.tax_alloc,
                        c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

     ELSIF  c1_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008

     INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                     VALUES
                       (p_par_id,                           c4_rec.item_grp,   c1_rec.tax_cd,
                        p_line_cd,                          p_iss_cd,          c1_rec.rate,
                        tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          c1_rec.tax_alloc,
                        c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
     END IF;
        END IF;
       END LOOP;
     ELSE --not EVAT
    --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
        IF (c4_rec.takeup_seq_no = 1 AND c1_rec.takeup_alloc_tag = 'F') OR
     (c4_rec.takeup_seq_no = p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

                   INSERT INTO GIPI_WINV_TAX
                      (par_id,              item_grp,          tax_cd,
                       line_cd,             iss_cd,            rate,
                       tax_amt,             tax_id,            tax_allocation,
                       fixed_tax_allocation, takeup_seq_no)
                    VALUES
                      (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                       p_line_cd,           p_iss_cd,          c1_rec.rate,
                       tax_amt_per_group1,  p_tax_id,          c1_rec.tax_alloc,
                       c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  ELSIF (c4_rec.takeup_seq_no <> 1 AND c1_rec.takeup_alloc_tag = 'F') OR
        (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008

                INSERT INTO GIPI_WINV_TAX
                      (par_id,              item_grp,          tax_cd,
                       line_cd,             iss_cd,            rate,
                       tax_amt,             tax_id,            tax_allocation,
                       fixed_tax_allocation, takeup_seq_no)
                    VALUES
                      (p_par_id,            c4_rec.item_grp,   c1_rec.tax_cd,
                       p_line_cd,           p_iss_cd,          0,
                       0,                   p_tax_id,          c1_rec.tax_alloc,
                       c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  ELSIF  c1_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
    INSERT INTO GIPI_WINV_TAX
                      (par_id,              item_grp,          tax_cd,
                       line_cd,             iss_cd,            rate,
                       tax_amt,             tax_id,            tax_allocation,
                       fixed_tax_allocation, takeup_seq_no)
                    VALUES
                      (p_par_id,                           c4_rec.item_grp,   c1_rec.tax_cd,
                       p_line_cd,                          p_iss_cd,          c1_rec.rate,
                       tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          c1_rec.tax_alloc,
                       c1_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

  END IF;
     END IF;  --end 04.10.2007
   --                END IF;
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
             FOR c1a_rec IN c1a
             LOOP
               BEGIN
                 /*DECLARE
                   CURSOR c3 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                      GROUP BY b.item_grp, A.peril_cd;
                   CURSOR c5 IS
                     SELECT b.item_grp, A.peril_cd, SUM(NVL(A.prem_amt,0)) prem_amt,
                            SUM(NVL(A.tsi_amt,0)) tsi_amt
                       FROM GIPI_WITMPERL A, GIPI_WITEM b
                      WHERE A.par_id   = p_par_id
                        AND A.par_id   = b.par_id
                        AND A.item_no  = b.item_no
                        AND b.item_grp = c4_rec.item_grp
                        AND A.peril_cd IN (SELECT peril_cd
                                             FROM GIIS_TAX_PERIL
                                            WHERE line_cd = p_line_cd
                                              AND iss_cd  = p_iss_cd
                                              AND tax_cd  = c1a_rec.tax_cd)
                      GROUP BY b.item_grp, A.peril_cd;*/  --commeneted by jason 9/4/2008: duplicate declaration
                 BEGIN
                   p_tax_id   :=  c1a_rec.tax_id;
                   IF c1a_rec.peril_sw = 'N' THEN
                      BEGIN
                        FOR c3_rec IN c3(c4_rec.item_grp)
                        LOOP
                          BEGIN
                            p_tax_amt          := c3_rec.prem_amt * c1a_rec.rate / 100;
       IF c1a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                               IF c3_rec.prem_amt > 0 THEN
             p_tax_amt := CEIL(c3_rec.prem_amt / 4) * (0.5);
          ELSE
             p_tax_amt := FLOOR(c3_rec.prem_amt / 4) * (0.5);
          END IF;
                     END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF c1a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   ELSE
                      BEGIN
                        FOR c5_rec IN c5(c4_rec.item_grp,c1a_rec.tax_cd)
                        LOOP
                          BEGIN
                            p_tax_amt := c5_rec.prem_amt * c1a_rec.rate / 100;
       IF c1a_rec.tax_cd = p_doc_stamps AND v_param_old_doc  = 'Y' THEN
                            IF c5_rec.prem_amt > 0 THEN
             p_tax_amt := CEIL(c5_rec.prem_amt / 4) * (0.5);
          ELSE
             p_tax_amt := FLOOR(c5_rec.prem_amt / 4) * (0.5);
          END IF;
                       END IF;
               --  A.R.C. 04.10.2007
         --add code to consider VAT_TAG
          IF c1a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
                  FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                                  FROM GIIS_ASSURED b,
                                       GIPI_WPOLBAS a
                                 WHERE b.assd_no = a.assd_no
                                   AND a.par_id = p_par_id)
         LOOP
           IF v1.vat_tag IN (1,2) AND p_tax_amt > 0 THEN
          p_tax_amt := 0;
        END IF;
         END LOOP;
                END IF; --end of code 04.10.2007
                            tax_amt_per_group1 := NVL(tax_amt_per_group1,0) + p_tax_amt;
                          END;
                        END LOOP;
                      END;
                   END IF;
--                IF TAX_AMT_PER_GROUP1 != 0 THEN
                  --A.R.C. 04.10.2007
      --replace code to consider VAT_TAG
                  /*INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1a_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc);*/
    --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
/*      IF c4_rec.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
       tax_amt_per_group1 := tax_amt_per_group1 - (ROUND((tax_amt_per_group1 / v_no_of_payment),2) * (v_no_of_payment - 1));
      ELSE
       tax_amt_per_group1 := ROUND((tax_amt_per_group1 / v_no_of_payment),2);
      END IF;
*/                IF c1a_rec.tax_cd = v_evat_cd THEN --giacp.n('EVAT') THEN --EVAT
       FOR v2 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM GIIS_ASSURED b,
                                  GIPI_WPOLBAS a
                            WHERE b.assd_no = a.assd_no
                              AND a.par_id = p_par_id)
       LOOP
        IF v2.vat_tag IN (2,3) OR (v2.vat_tag = 1 AND tax_amt_per_group1 < 0) THEN
      --IF c4_rec.takeup_seq_no = 1 THEN  --replace by jason 9/3/2008
            IF (c4_rec.takeup_seq_no = 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
      (c4_rec.takeup_seq_no = p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008     INSERT INTO GIPI_WINV_TAX

      INSERT INTO GIPI_WINV_TAX
        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          c1a_rec.rate,
                        tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                        c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

    ELSIF (c4_rec.takeup_seq_no <> 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
          (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008     INSERT INTO GIPI_WINV_TAX

         INSERT INTO GIPI_WINV_TAX
                       (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                     VALUES
                       (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                        p_line_cd,           p_iss_cd,          0,
                        0,                   p_tax_id,          c1a_rec.tax_alloc,
                        c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

   ELSIF  c1a_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
     INSERT INTO GIPI_WINV_TAX
        (par_id,              item_grp,          tax_cd,
                        line_cd,             iss_cd,            rate,
                        tax_amt,             tax_id,            tax_allocation,
                        fixed_tax_allocation, takeup_seq_no)
                     VALUES
                       (p_par_id,                           c4_rec.item_grp,   c1a_rec.tax_cd,
                        p_line_cd,                          p_iss_cd,          c1a_rec.rate,
                        tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          c1a_rec.tax_alloc,
                        c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);
   END IF;
        END IF;
       END LOOP;
     ELSE --not EVAT
     --IF c4_rec.takeup_seq_no = 1 THEN
  IF (c4_rec.takeup_seq_no = 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
   (c4_rec.takeup_seq_no = p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008     INSERT INTO GIPI_WINV_TAX

                  INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation, takeup_seq_no)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1a_rec.rate,
                      tax_amt_per_group1,  p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

   ELSIF (c4_rec.takeup_seq_no <> 1 AND c1a_rec.takeup_alloc_tag = 'F') OR
      (c4_rec.takeup_seq_no <> p_no_of_takeup AND c1a_rec.takeup_alloc_tag = 'L') THEN  --tax allocated on first or last takeup: jason 9/3/2008     INSERT INTO GIPI_WINV_TAX

             INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation, takeup_seq_no)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          0,
                      0,                   p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

   ELSIF  c1a_rec.takeup_alloc_tag = 'S' THEN   --tax is spread on all takeups: jason 9/3/2008
            INSERT INTO GIPI_WINV_TAX
                     (par_id,              item_grp,          tax_cd,
                      line_cd,             iss_cd,            rate,
                      tax_amt,             tax_id,            tax_allocation,
                      fixed_tax_allocation, takeup_seq_no)
                   VALUES
                     (p_par_id,            c4_rec.item_grp,   c1a_rec.tax_cd,
                      p_line_cd,           p_iss_cd,          c1a_rec.rate,
                      tax_amt_per_group1/p_no_of_takeup,  p_tax_id,          c1a_rec.tax_alloc,
                      c1a_rec.fixed_tax_alloc, c4_rec.takeup_seq_no);

   END IF;
     END IF;  --end 04.10.2007
     --               END IF;
                 END;
                 p_tax_amt          := 0;
                 tax_amt_per_group1 := 0;
               END;
             END LOOP;
          END IF;
        END;
      END;
    END LOOP;
  END;
  END IF;
  END;
---***---
  FOR c1_rec IN c1
  LOOP
    DECLARE
  v_rec_tsi_amt     GIPI_WINVPERL.tsi_amt%TYPE;
  v_rec_prem_amt    GIPI_WINVPERL.prem_amt%TYPE;
  v_rec_ri_comm_amt GIPI_WINVPERL.ri_comm_amt%TYPE;
  v_sum_prem_amt    GIPI_WINVPERL.prem_amt%TYPE; --issa04.10.2008
    BEGIN
  FOR longterm IN (SELECT takeup_seq_no
                     FROM GIPI_WINVOICE a
        WHERE a.par_id   = p_par_id
          AND a.item_grp = c1_rec.item_grp)
  LOOP
  --added by gmi to divide tax_amt by the no of payment set by LONGTERM "take-ups"
   IF longterm.takeup_seq_no = v_no_of_payment THEN -- LAST RECORD
   v_rec_tsi_amt     := c1_rec.tsi_amt - (ROUND((c1_rec.tsi_amt / v_no_of_payment),2) * (v_no_of_payment - 1));
   v_rec_prem_amt    := c1_rec.prem_amt - (ROUND((c1_rec.prem_amt / v_no_of_payment),2) * (v_no_of_payment - 1));
   v_rec_ri_comm_amt := c1_rec.ri_comm_amt - (ROUND((c1_rec.ri_comm_amt / v_no_of_payment),2) * (v_no_of_payment - 1));
   ELSE
   v_rec_tsi_amt     := ROUND((c1_rec.tsi_amt / v_no_of_payment),2);
   v_rec_prem_amt    := ROUND((c1_rec.prem_amt / v_no_of_payment),2);
   v_rec_ri_comm_amt := ROUND((c1_rec.ri_comm_amt / v_no_of_payment),2);
   END IF;
   INSERT INTO GIPI_WINVPERL
             (par_id,         peril_cd,          item_grp,
              tsi_amt,        prem_amt,          ri_comm_amt,
              ri_comm_rt,
         takeup_seq_no)
        VALUES
             (p_par_id,       c1_rec.peril_cd,   c1_rec.item_grp,
              v_rec_tsi_amt,  v_rec_prem_amt,    v_rec_ri_comm_amt,
              DECODE(v_rec_prem_amt,0,0,c1_rec.ri_comm_rt),
         longterm.takeup_seq_no);

  /*  added by issa04.10.2008 to update prem_amt in gipi_winvoice based on
  **  the sum of prem_amt per peril per takeup (before it is based on the total prem_amt per takeup)
  **  to prevent discrepancy in comm invoice and batch processing accdg. to ms. juday
  */
        FOR i IN (SELECT SUM(prem_amt) prem_amt
                    FROM GIPI_WINVPERL
                   WHERE par_id = p_par_id
                     AND takeup_seq_no = longterm.takeup_seq_no
                     AND item_grp = c1_rec.item_grp
                   GROUP BY takeup_seq_no)
            LOOP
      v_sum_prem_amt := i.prem_amt;
   END LOOP;

     UPDATE GIPI_WINVOICE
          SET prem_amt   = v_sum_prem_amt
             WHERE par_id   = p_par_id
          AND takeup_seq_no = longterm.takeup_seq_no
      AND item_grp      = c1_rec.item_grp;
  --end issa--
    END LOOP;
    END;
  END LOOP;
  FOR C IN (
    SELECT  pack_pol_flag
      FROM  GIPI_WPOLBAS
     WHERE  par_id        =  p_par_id
       AND  pack_pol_flag = 'Y')
  LOOP
    FOR d IN (
      SELECT DISTINCT item_grp
 FROM GIPI_WINVOICE
       WHERE par_id = p_par_id)
    LOOP
    FOR A IN (
      SELECT  par_id,  prem_seq_no,   prem_amt,
              tax_amt, other_charges, item_grp
        FROM  GIPI_WINVOICE
       WHERE  par_id  =  p_par_id
  AND  item_grp =  d.item_grp)
    LOOP
      FOR b IN (
        SELECT  DISTINCT pack_line_cd
          FROM  GIPI_WITEM
         WHERE  par_id   =  p_par_id
           AND  item_grp =  A.item_grp)
      LOOP
        INSERT INTO GIPI_WPACKAGE_INV_TAX
             (par_id,     item_grp,   line_cd,        prem_seq_no,
              prem_amt,   tax_amt,    other_charges)
        VALUES
             (A.par_id,   d.item_grp, b.pack_line_cd, A.prem_seq_no,
              A.prem_amt, A.tax_amt,  A.other_charges);
        END LOOP;
     END LOOP;
    END LOOP;
     EXIT;
  END LOOP;
  --06.14.2006
  --for processsing of package
  FOR c1 IN (SELECT b.pack_par_id, b.line_cd
               FROM GIPI_PACK_PARLIST b,
           GIPI_PARLIST A
     WHERE b.pack_par_id = A.pack_par_id
       AND A.pack_par_id IS NOT NULL
       AND A.par_id = p_par_id)
  LOOP
   --to refresh the value of GIPI_PACK_WINV_TAX, GIPI_PACK_WINVPERL, GIPI_PACK_WINSTALLMENT, GIPI_PACK_WINVOICE
   DELETE FROM GIPI_PACK_WINV_TAX
    WHERE pack_par_id = c1.pack_par_id;
   DELETE FROM GIPI_PACK_WINVPERL
    WHERE pack_par_id = c1.pack_par_id;
   DELETE FROM GIPI_PACK_WINSTALLMENT
    WHERE pack_par_id = c1.pack_par_id;
   DELETE FROM GIPI_PACK_WINVOICE
    WHERE pack_par_id = c1.pack_par_id;
--A.R.C. 09.22.2006
-- to avoid ORA-00001 error
--      INSERT INTO GIPI_PACK_WINVOICE(pack_par_id, item_grp, /*payt_terms,*/ prem_seq_no, prem_amt, tax_amt, property, insured, /*due_date,*/ notarial_fee, ri_comm_amt, currency_cd, currency_rt, remarks, other_charges, ref_inv_no, policy_currency, bond_rate, bond_tsi_amt, /*pay_type,*/ card_name, card_no, approval_cd, expiry_date, ri_comm_vat)
--    SELECT c1.pack_par_id, item_grp, /*payt_terms,*/ prem_seq_no, SUM(prem_amt), SUM(tax_amt), 'VARIOUS' property, insured, /*due_date,*/ notarial_fee, SUM(ri_comm_amt), currency_cd, currency_rt, remarks, SUM(other_charges), ref_inv_no, policy_currency, bond_rate, SUM(bond_tsi_amt), /*pay_type,*/ card_name, card_no, approval_cd, expiry_date, SUM(ri_comm_vat)
--   FROM GIPI_WINVOICE A
--  WHERE EXISTS (SELECT 1
--                  FROM GIPI_PARLIST gp
--        WHERE gp.par_id = A.par_id
--       AND gp.pack_par_id = c1.pack_par_id)
--     GROUP BY c1.pack_par_id, item_grp, /*payt_terms,*/ prem_seq_no, /*property,*/ insured, /*due_date,*/ notarial_fee, currency_cd, currency_rt, remarks, ref_inv_no, policy_currency, bond_rate, /*pay_type,*/ card_name, card_no, approval_cd, expiry_date;

     INSERT INTO GIPI_PACK_WINVOICE(pack_par_id, item_grp, prem_amt, tax_amt, ri_comm_amt, other_charges, bond_tsi_amt, ri_comm_vat)
          SELECT c1.pack_par_id, item_grp, SUM(prem_amt), SUM(tax_amt), SUM(ri_comm_amt), SUM(other_charges), SUM(bond_tsi_amt), SUM(ri_comm_vat)
      FROM GIPI_WINVOICE A
     WHERE EXISTS (SELECT 1
                     FROM GIPI_PARLIST gp
              WHERE gp.par_id = A.par_id
          AND gp.pack_par_id = c1.pack_par_id)
         GROUP BY c1.pack_par_id, item_grp;
 FOR gw IN (SELECT item_grp, payt_terms, prem_seq_no, 'VARIOUS' property, insured, due_date, notarial_fee, currency_cd, currency_rt, remarks, ref_inv_no, policy_currency, bond_rate, pay_type, card_name, card_no, approval_cd, expiry_date
              FROM GIPI_WINVOICE A
    WHERE EXISTS (SELECT 1
                    FROM GIPI_PARLIST gp
          WHERE gp.par_id = A.par_id
         AND gp.pack_par_id = c1.pack_par_id) )
 LOOP
   UPDATE GIPI_PACK_WINVOICE
      SET payt_terms = gw.payt_terms,
       prem_seq_no = gw.prem_seq_no,
    property = gw.property,
    insured = gw.insured,
    due_date = gw.due_date,
    notarial_fee = gw.notarial_fee,
    currency_cd = gw.currency_cd,
    currency_rt = gw.currency_rt,
    remarks = gw.remarks,
    ref_inv_no = gw.ref_inv_no,
    policy_currency = gw.policy_currency,
    bond_rate = gw.bond_rate,
    pay_type = gw.pay_type,
    card_name = gw.card_name,
    card_no = gw.card_no,
    approval_cd = gw.approval_cd,
    expiry_date = gw.expiry_date
    WHERE pack_par_id = c1.pack_par_id
      AND item_grp = gw.item_grp;
 END LOOP;
      INSERT INTO GIPI_PACK_WINSTALLMENT(pack_par_id, item_grp, inst_no, share_pct, prem_amt, tax_amt, due_date)
   SELECT c1.pack_par_id, item_grp, inst_no, share_pct, SUM(prem_amt), SUM(tax_amt), due_date
  FROM GIPI_WINSTALLMENT A
 WHERE EXISTS (SELECT 1
                 FROM GIPI_PARLIST gp
       WHERE gp.par_id = A.par_id
      AND gp.pack_par_id = c1.pack_par_id)
    GROUP BY c1.pack_par_id, item_grp, inst_no, share_pct, due_date;
      INSERT INTO GIPI_PACK_WINVPERL(pack_par_id, line_cd, peril_cd, item_grp, tsi_amt, prem_amt, ri_comm_amt, ri_comm_rt)
   SELECT c1.pack_par_id, pack_line_cd, peril_cd, item_grp, SUM(tsi_amt), SUM(prem_amt), SUM(ri_comm_amt), SUM(ri_comm_rt)
  FROM GIPI_WINVPERL A,
       GIPI_WPACK_LINE_SUBLINE B
 WHERE A.par_id = b.par_id
   AND EXISTS (SELECT 1
                 FROM GIPI_PARLIST gp
       WHERE gp.par_id = A.par_id
      AND gp.pack_par_id = c1.pack_par_id)
    GROUP BY c1.pack_par_id, pack_line_cd, peril_cd, item_grp;
 FOR gwt1 IN (SELECT item_grp, tax_cd, SUM(tax_amt) tax_amt, SUM(rate) rate
            FROM GIPI_WINV_TAX A
      WHERE EXISTS (SELECT 1
                   FROM GIPI_PARLIST gp
             WHERE gp.par_id = A.par_id
           AND gp.pack_par_id = c1.pack_par_id)
      GROUP BY item_grp, tax_cd)
 LOOP
   FOR gwt2 IN (SELECT line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_id
                FROM GIPI_WINV_TAX A
              WHERE EXISTS (SELECT 1
                              FROM GIPI_PARLIST gp
                    WHERE gp.par_id = A.par_id
                   AND gp.pack_par_id = c1.pack_par_id)
       AND A.item_grp = gwt1.item_grp
       AND A.tax_cd = gwt1.tax_cd)
   LOOP
     INSERT INTO GIPI_PACK_WINV_TAX(pack_par_id, item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_amt, tax_id, rate)
                          VALUES(c1.pack_par_id, gwt1.item_grp, gwt1.tax_cd, c1.line_cd, gwt2.tax_allocation, gwt2.fixed_tax_allocation, gwt2.iss_cd, gwt1.tax_amt, gwt2.tax_id, gwt1.rate);
     EXIT;
   END LOOP;
 END LOOP;
  END LOOP;
  /* added by gmi:121207 :
  ** updates gipi_winvoice.DUE_DATE, to set default value before enter of gipis026 module:
  ** due dates of an multi-takeup term POLICY, are set here:
  ** originaly, the due dates are left NULL during gipi_winvoice insert :
  */
/*  BEGIN
  FOR L IN (SELECT eff_date, endt_expiry_date, expiry_date
     FROM gipi_wpolbas
       WHERE par_id = p_par_id)
  LOOP
   --If record is an endt then consider expiry date of endorsement.
   IF l.endt_expiry_date IS NULL THEN
    v_expiry_date := l.expiry_date;
    v_incept_date := l.eff_date;
   ELSE
    v_expiry_date := l.endt_expiry_date;
    v_incept_date := l.eff_date;
   END IF;
   EXIT;
  END LOOP;
  v_duration      := 0;
  v_no_of_payment := 0;
  FOR takeup_ctr IN 1.. v_no_of_payment LOOP
   v_duration      := months_between(v_expiry_date, v_incept_date);
   --if v_duration is not a whole number then always round up
         IF v_duration > TRUNC(v_duration) THEN
           v_duration := TRUNC(v_duration) + 1;
         END IF;

   IF TRUNC(v_expiry_date - v_incept_date) = 31 THEN
          v_policy_days      := 30;
         ELSE
          v_policy_days      := TRUNC(v_expiry_date - v_incept_date);
         END IF;



   UPDATE gipi_winvoice
      SET due_date = var_due_date
    WHERE pari_id = p_par_id
      AND takeup_seq_no = takeup_ctr;
  END LOOP;


  END;*/
  /* gmi upto here 121207 */
END;
/


