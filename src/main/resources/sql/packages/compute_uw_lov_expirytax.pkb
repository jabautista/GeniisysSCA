CREATE OR REPLACE PACKAGE BODY CPI.compute_uw_LOV_expirytax AS

/** FUNCTION compute_tax CREATED BY JONGS
**  06.03.2013
*/
FUNCTION compute_tax (p_policy_id NUMBER,
                      p_iss_cd VARCHAR2,
                      p_line_cd VARCHAR2,
                      p_tax_cd number,
                      p_tax_id number,
                      p_item_no number)

RETURN NUMBER IS

  v_tax_cd         NUMBER;
  v_tax_type       VARCHAR2(1);
  v_tax_amt        NUMBER;
  v_line_cd        VARCHAR2(2);
  v_rate           NUMBER;
  v_comp_amount    NUMBER;
  v_prem_amt       NUMBER;
  v_peril          VARCHAR2(1);
  v_prem_amt2      NUMBER;
  v_vat_tag        VARCHAR2(1);
  v_count          NUMBER;
  v_count2         NUMBER;
  v_tsi_amt        NUMBER;
  v_currency       NUMBER;


BEGIN

  FOR x IN (SELECT DISTINCT currency_rt
            FROM giex_itmperil
            WHERE policy_id = p_policy_id
            order by currency_rt desc)
  LOOP
    v_currency := x.currency_rt;
  END LOOP;

    /*  Query for tax code whether it is docstamp, evat or others   */
    FOR i IN (SELECT tax_cd, tax_type, NVL(tax_amount,0) tax_amount, line_cd, NVL(rate,0) rate, peril_sw
              FROM giis_tax_charges
              WHERE line_cd = p_line_cd
              AND iss_cd = p_iss_cd
              AND tax_cd = p_tax_cd
              AND tax_id = p_tax_id)

    LOOP
      v_tax_cd   := i.tax_cd;
      v_tax_type := i.tax_type;
      v_tax_amt  := i.tax_amount;
      v_line_cd  := i.line_cd;
      v_rate     := (i.rate/100);
      v_peril    := i.peril_sw;

      /************** query for premium amount ************/
      FOR a IN (SELECT SUM(NVL(prem_amt,0)) prem_amt
                FROM giex_itmperil
                WHERE policy_id = p_policy_id)
      LOOP
        v_prem_amt := a.prem_amt;
      END LOOP;

        /***************tax code is documentary stamp *************/
       IF v_tax_cd = giacp.n('DOC_STAMPS') THEN

            /*********** query to determine if menu line code is 'AC' *********/
           FOR ii IN (
                        SELECT NVL(menu_line_cd, line_cd) line_cd
                        FROM giis_line
                        WHERE line_cd = v_line_cd
                     )
           LOOP

             IF ii.line_cd = 'AC' THEN

               /* consider COMPUTE_PA_DOC_STAMPS */
                IF giisp.v('COMPUTE_PA_DOC_STAMPS') = '1' THEN
                  v_comp_amount := v_prem_amt * v_rate;
                ELSIF giisp.v('COMPUTE_PA_DOC_STAMPS') = '2' THEN
                  v_comp_amount := CEIL(v_prem_amt/200) * 0.5;
                ELSIF giisp.v('COMPUTE_PA_DOC_STAMPS') = '3' THEN

                  /** query for total 'BASIC PERILS ONLY' tsi amount**/
                  FOR k IN (SELECT SUM(NVL(a.TSI_AMT,0)) tsi_amt
                            FROM giex_itmperil a, giis_peril b
                            WHERE policy_id = p_policy_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND b.peril_type = 'B')
                  LOOP
                    v_tsi_amt := k.tsi_amt;
                  END LOOP;

                  /* consider possibilities that tax type may not match with parameter*/
                  IF v_tax_type = 'N' THEN
                    --v_comp_amount := compute_uwtaxes.get_tax_range(v_tsi_amt,v_currency,v_line_cd,
                    --                                               p_iss_cd, p_tax_cd, p_tax_id);
                  v_comp_amount := compute_uw_LOV_expirytax.get_tax_range(v_prem_amt,v_currency,v_line_cd,
                                                                 p_iss_cd, p_tax_cd, p_tax_id);
                  ELSIF v_tax_type = 'R' THEN
                    v_comp_amount := v_prem_amt * v_rate;
                  END IF;

                END IF;

             /**** other line codes ****/
             ELSE
               /**** consider COMPUTE_OLD_DOC_STAMPS ****/
               IF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'Y' THEN
                 v_comp_amount := CEIL(v_prem_amt/4) * 0.5;
               ELSIF giisp.v('COMPUTE_OLD_DOC_STAMPS') = 'N' THEN
                 v_comp_amount := v_prem_amt * v_rate;
               END IF;

             END IF;

           END LOOP;

        /***** tax code is EVAT *****/
        ELSIF v_tax_cd = giacp.n('EVAT') THEN

          /* query for vat_tag in giis_assured */
          BEGIN
            SELECT NVL(a.vat_tag,3)
            INTO v_vat_tag
            FROM giis_assured a, giex_expiry b
            WHERE a.assd_no = b.assd_no
            AND b.policy_id = p_policy_id;
          END;

          /* vat_tag for each assured (vat exempt, zero rated, rate) */
          IF v_vat_tag = '2' THEN
            v_comp_amount := 0;
          ELSIF v_vat_tag = '3' THEN

            /*** consider peril dependent ***/
            IF v_peril = 'Y' THEN

                FOR s IN (SELECT NVL(SUM(prem_amt),0) prem_amt, NVL(SUM(tsi_amt),0) tsi_amt
                          FROM giex_itmperil
                          WHERE peril_cd IN ( SELECT peril_cd
                                              FROM giis_tax_peril
                                              WHERE line_cd = p_line_cd
                                              AND iss_cd = p_iss_cd )
                          AND policy_id = p_policy_id
                         )

                LOOP
                  v_prem_amt2 := s.prem_amt;
                END LOOP;
                  v_comp_amount := v_prem_amt2 * v_rate;



            /*** not peril dependent ***/
            ELSE
              v_comp_amount := v_prem_amt * v_rate;
            END IF;

          ELSE
            RETURN (NULL);

          END IF;

       /* tax code other than docu stamp and evat */
       ELSE

         /* consider tax type (R - Rate, A - Fixed amount, N - Range)*/
         IF v_tax_type = 'R' THEN

           /* consider peril dependent for non-evat and non-docustamps */
           IF v_peril = 'Y' THEN

                FOR ss IN (SELECT NVL(SUM(prem_amt),0) prem_amt, NVL(SUM(tsi_amt),0) tsi_amt
                          FROM giex_itmperil
                          WHERE peril_cd IN ( SELECT peril_cd
                                              FROM giis_tax_peril
                                              WHERE line_cd = p_line_cd
                                              AND iss_cd = p_iss_cd )
                          AND policy_id = p_policy_id
                         )

                LOOP
                  v_prem_amt2 := ss.prem_amt;
                END LOOP;
                  v_comp_amount := v_prem_amt2 * v_rate;

           ELSE
             v_comp_amount := v_prem_amt * v_rate;
           END IF;

         ELSIF v_tax_type = 'A' THEN
           v_comp_amount := v_tax_amt/v_currency;
         ELSIF v_tax_type = 'N' THEN
           v_comp_amount := compute_uw_LOV_expirytax.get_tax_range(v_prem_amt,v_currency,v_line_cd,
                                                                 p_iss_cd, p_tax_cd, p_tax_id);
         end IF;

       END IF;

    END LOOP;

  v_comp_amount := ROUND(v_comp_amount,2); --joanne 060214

  RETURN (v_comp_amount);

  --END LOOP;

END;


/*function for getting the tax amount base on range  --edgar nobleza*/
FUNCTION get_tax_range (p_amount NUMBER,
                        p_currency_rt NUMBER,
                        p_line_cd VARCHAR2,
                        p_iss_cd VARCHAR2,
                        p_tax_cd NUMBER,
                        p_tax_id NUMBER)
RETURN NUMBER IS

v_amount NUMBER := p_amount;
v_currency_rt NUMBER := p_currency_rt;
v_tax_amt NUMBER;

BEGIN


    SELECT tax_amount/v_currency_rt
    INTO v_tax_amt
      FROM giis_tax_range
     WHERE line_cd = p_line_cd
       AND iss_cd = p_iss_cd
       AND tax_cd = p_tax_cd
       AND tax_id = p_tax_id
       AND (v_amount*v_currency_rt) BETWEEN min_value AND max_value;

    RETURN (v_tax_amt);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO RECORDS EXIST IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).', TRUE);


END;


END compute_uw_LOV_expirytax;
/


