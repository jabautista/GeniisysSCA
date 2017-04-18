CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Invoice_Pkg AS

  FUNCTION get_gixx_invoice(p_extract_id		GIXX_INVOICE.extract_id%TYPE)
    RETURN gixx_invoice_tab PIPELINED IS
	v_invoice				gixx_invoice_type;
  BEGIN
    FOR i IN (SELECT ALL invoice.extract_id extract_id2,
                	 DECODE(invoice.policy_currency,'Y',SUM(invoice.prem_amt),SUM(invoice.prem_amt * invoice.currency_rt)) invoice_prem_amt
  				FROM GIXX_INVOICE invoice,
       				 GIXX_POLBASIC pol
 			   WHERE invoice.extract_id = p_extract_id
   			   	 AND invoice.extract_id = pol.extract_id
   				 AND pol.co_insurance_sw IN (1, 3)
 			GROUP BY invoice.extract_id,invoice.policy_currency

 			   UNION

			  SELECT ALL invoice.extract_id extract_id2,
	   		  		 DECODE(inv.policy_currency,'Y',SUM(invoice.prem_amt),SUM(invoice.prem_amt * invoice.currency_rt)) invoice_prem_amt
  				FROM GIXX_ORIG_INVOICE invoice,
       				 GIXX_POLBASIC pol,
       				 GIXX_INVOICE inv
 			   WHERE invoice.extract_id = p_extract_id
   			     AND invoice.extract_id = pol.extract_id
   				 AND inv.extract_id = pol.extract_id
   				 AND pol.co_insurance_sw = 2
 			GROUP BY invoice.extract_id,inv.policy_currency

 			   UNION

			  SELECT ALL invoice.extract_id extract_id2,
	   		  		 DECODE(invoice.policy_currency,'Y',SUM(invoice.prem_amt),SUM(invoice.prem_amt * invoice.currency_rt)) invoice_prem_amt
  				FROM GIXX_INVOICE invoice,
       				 GIXX_POLBASIC pol
 			   WHERE invoice.extract_id = p_extract_id
   			     AND invoice.extract_id = pol.extract_id
   				 AND pol.co_insurance_sw = 3
 			GROUP BY invoice.extract_id,invoice.policy_currency)
	LOOP
	  v_invoice.extract_id2			:= i.extract_id2;
	  v_invoice.invoice_prem_amt	:= i.invoice_prem_amt;
	  PIPE ROW(v_invoice);
	END LOOP;
	RETURN;
  END get_gixx_invoice;

  FUNCTION get_invoice_summary(p_extract_id		GIXX_INVOICE.extract_id%TYPE)
    RETURN gixx_invoice_tab PIPELINED IS
	v_invoice				gixx_invoice_type;
  BEGIN
    FOR i IN (SELECT B450.EXTRACT_ID EXTRACT_ID20,
                	 SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) PREMIUM_AMT,
                	 SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) TAX_AMT,
        			 SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) OTHER_CHARGES,
        			 SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) +
        			 			SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) +
        			 			SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) TOTAL,
					 B450.POLICY_CURRENCY POLICY_CURRENCY
    			FROM GIXX_INVOICE B450
				   , GIXX_POLBASIC POL
               WHERE B450.EXTRACT_ID = P_EXTRACT_ID
                 AND B450.EXTRACT_ID = POL.EXTRACT_ID
      			 AND POL.CO_INSURANCE_SW = 1
			GROUP BY B450.EXTRACT_ID ,B450.POLICY_CURRENCY

			UNION

			SELECT B450.EXTRACT_ID EXTRACT_ID20,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) PREMIUM_AMT,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) TAX_AMT,
        		   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) OTHER_CHARGES,
        		   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) +
        		   			 SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) +
        					 SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) TOTAL ,B450.POLICY_CURRENCY POLICY_CURRENCY
    		  FROM GIXX_ORIG_INVOICE B450,GIXX_POLBASIC POL
			 WHERE B450.EXTRACT_ID = P_EXTRACT_ID
               AND B450.EXTRACT_ID              = POL.EXTRACT_ID
      		   AND POL.CO_INSURANCE_SW  = 2
		  GROUP BY B450.EXTRACT_ID,B450.POLICY_CURRENCY)
	LOOP
	  v_invoice.extract_id20   := i.extract_id20;
	  v_invoice.premium_amt    := i.premium_amt;
	  v_invoice.tax_amt   	   := i.tax_amt;
	  v_invoice.other_charges  := i.other_charges;
	  v_invoice.total   	   := i.total;
	  v_invoice.policy_currency := i.policy_currency;
	  PIPE ROW(v_invoice);
	END LOOP;
	RETURN;
  END get_invoice_summary;

   FUNCTION get_pol_doc_tsi(p_extract_id GIXX_INVOICE.extract_id%TYPE)
     RETURN pol_doc_tsi_tab PIPELINED IS

     v_tsi pol_doc_tsi_type;

   BEGIN
     FOR i IN (
        SELECT   tsi.extract_id extract_id3,
                 tsi.fx_name    tsi_fx_name,
                 tsi.fx_desc    tsi_fx_desc,
                 UPPER
                    (   tsi.fx_name
                     || ' '
                     || Dh_Util.spell (TRUNC (SUM (tsi.itm_tsi)))
                     || ' AND '
                     || LTRIM (  ((SUM (tsi.itm_tsi)) - (TRUNC (SUM (tsi.itm_tsi))))
                               * 100
                              )
                     || '/100 ('
                     || LTRIM (RTRIM (TO_CHAR (SUM (tsi.itm_tsi),
                                               '999,999,999,999,999.00'
                                              )
                                     )
                              )
                     || ') IN '
                     || tsi.fx_desc
                    ) tsi_spelled_tsi
            FROM (SELECT   item.extract_id extract_id,

                           /* IF POL_CURRENCY = 'Y' THEN AMOUNT IN FX, ELSIF 'N' THEN AMOUNT IN PESO
                           ** ELSE AMOUNT IN FX
                           ** CALCULATE TOTAL SUM INSURED
                           */
                           SUM (DECODE (NVL (invoice.policy_currency, 'N'),
                                        'Y', NVL (item.tsi_amt, 0),
                                        'N', NVL (item.tsi_amt, 0)
                                         * invoice.currency_rt,
                                        NVL (item.tsi_amt, 0)
                                       )
                               ) itm_tsi,

                           /* IF POL_CURRENCY = 'Y' THEN CURRENCY IN FX, ELSIF 'N' THEN CURRENCY IN PESO
                           ** ELSE CURRENCY IN FX
                           ** DEFINE CURRENCY SYMBOL
                           */
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.short_name,
                                   'N', 'PHP',
                                   fx.short_name
                                  ) fx_name,

                           /* IF POL_CURRENCY = 'Y' THEN CURRENCY IN FX, ELSIF 'N' THEN CURRENCY IN PESO
                           ** ELSE CURRENCY IN FX
                           ** DEFINE CURRENCY DESCRIPTION
                           */
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.currency_desc,
                                   'N', 'PHILIPPINE PESO',
                                   fx.currency_desc
                                  ) fx_desc,

                           /* GET CURRENCY CODE */
                           invoice.currency_cd invoice_fx_cd,

                           /* CALCULATE AVERAGE CURRENCY RATE */
                           AVG (invoice.currency_rt) avg_fx_rt
                      FROM GIXX_ITEM     item,
                           GIIS_CURRENCY fx,
                           GIXX_INVOICE  invoice,
                           GIXX_POLBASIC pol
                     WHERE (    (item.currency_cd = fx.main_currency_cd)
                            AND (item.extract_id = invoice.extract_id)
                            AND (fx.main_currency_cd = invoice.currency_cd)
                           )
                       AND item.extract_id      = p_extract_id
                       AND item.extract_id      = pol.extract_id
                       AND pol.co_insurance_sw  = 1
                  GROUP BY item.extract_id,
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.short_name,
                                   'N', 'PHP',
                                   fx.short_name
                                  ),
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.currency_desc,
                                   'N', 'PHILIPPINE PESO',
                                   fx.currency_desc
                                  ),
                           invoice.currency_cd) tsi
        GROUP BY tsi.extract_id, tsi.fx_name, tsi.fx_desc
        UNION
        SELECT   tsi.extract_id extract_id3, tsi.fx_name tsi_fx_name,
                 tsi.fx_desc tsi_fx_desc,
                 UPPER
                    (   tsi.fx_name
                     || ' '
                     || Dh_Util.spell (TRUNC (SUM (tsi.itm_tsi)))
                     || ' AND '
                     || LTRIM (  ((SUM (tsi.itm_tsi)) - (TRUNC (SUM (tsi.itm_tsi))))
                               * 100
                              )
                     || '/100 ('
                     || LTRIM (RTRIM (TO_CHAR (SUM (tsi.itm_tsi),
                                               '999,999,999,999,999.00'
                                              )
                                     )
                              )
                     || ') IN '
                     || tsi.fx_desc
                    ) tsi_spelled_tsi
            FROM (SELECT   item.extract_id extract_id,

                           /* IF POL_CURRENCY = 'Y' THEN AMOUNT IN FX, ELSIF 'N' THEN AMOUNT IN PESO
                           ** ELSE AMOUNT IN FX
                           ** CALCULATE TOTAL SUM INSURED
                           */
                           SUM (DECODE (NVL (invoice.policy_currency, 'N'),
                                        'Y', NVL (item.tsi_amt, 0),
                                        'N', NVL (item.tsi_amt, 0)
                                         * invoice.currency_rt,
                                        NVL (item.tsi_amt, 0)
                                       )
                               ) itm_tsi,

                           /* IF POL_CURRENCY = 'Y' THEN CURRENCY IN FX, ELSIF 'N' THEN CURRENCY IN PESO
                           ** ELSE CURRENCY IN FX
                           ** DEFINE CURRENCY SYMBOL
                           */
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.short_name,
                                   'N', 'PHP',
                                   fx.short_name
                                  ) fx_name,

                           /* IF POL_CURRENCY = 'Y' THEN CURRENCY IN FX, ELSIF 'N' THEN CURRENCY IN PESO
                           ** ELSE CURRENCY IN FX
                           ** DEFINE CURRENCY DESCRIPTION
                           */
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.currency_desc,
                                   'N', 'PHILIPPINE PESO',
                                   fx.currency_desc
                                  ) fx_desc,

                           /* GET CURRENCY CODE */
                           invoice.currency_cd invoice_fx_cd,

                           /* CALCULATE AVERAGE CURRENCY RATE */
                           AVG (invoice.currency_rt) avg_fx_rt
                      FROM GIXX_ITEM         item,
                           GIIS_CURRENCY     fx,
                           GIXX_ORIG_INVOICE invoice,
                           GIXX_POLBASIC     pol
                     WHERE (    (item.currency_cd = fx.main_currency_cd)
                            AND (item.extract_id = invoice.extract_id)
                            AND (fx.main_currency_cd = invoice.currency_cd)
                           )
                       AND item.extract_id      = p_extract_id
                       AND item.extract_id      = pol.extract_id
                       AND pol.co_insurance_sw  = 2
                  GROUP BY item.extract_id,
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.short_name,
                                   'N', 'PHP',
                                   fx.short_name
                                  ),
                           DECODE (NVL (invoice.policy_currency, 'N'),
                                   'Y', fx.currency_desc,
                                   'N', 'PHILIPPINE PESO',
                                   fx.currency_desc
                                  ),
                           invoice.currency_cd) tsi
        GROUP BY tsi.extract_id, tsi.fx_name, tsi.fx_desc)
     LOOP
        v_tsi.extract_id3     := i.extract_id3;
        v_tsi.tsi_fx_name     := i.tsi_fx_name;
        v_tsi.tsi_fx_desc     := i.tsi_fx_desc;
        v_tsi.tsi_spelled_tsi := i.tsi_spelled_tsi;
       PIPE ROW(v_tsi);
     END LOOP;
     RETURN;
   END get_pol_doc_tsi;

   FUNCTION get_pol_doc_quey_1 (p_extract_id GIXX_INVOICE.extract_id%TYPE)
     RETURN pol_doc_query_1_tab PIPELINED
   IS
     v_q1  pol_doc_query_1_type;
   BEGIN
     FOR i IN(
       SELECT ALL invoice.extract_id EXTRACT_ID2,
              DECODE(invoice.policy_currency,'Y',SUM(invoice.prem_amt),SUM(invoice.prem_amt * invoice.currency_rt)) INVOICE_PREM_AMT
         FROM GIXX_INVOICE invoice,
              GIXX_POLBASIC pol
        WHERE invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 1
        GROUP BY invoice.extract_id,invoice.policy_currency
        UNION
        SELECT ALL invoice.extract_id EXTRACT_ID2,
            DECODE(invoice.policy_currency,'Y',SUM(invoice.prem_amt),SUM(invoice.prem_amt * invoice.currency_rt)) INVOICE_PREM_AMT
         FROM GIXX_ORIG_INVOICE invoice,
              GIXX_POLBASIC pol
        WHERE invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 2
        GROUP BY invoice.extract_id,invoice.policy_currency)
     LOOP
        v_q1.extract_id2      := i.extract_id2;
        v_q1.invoice_prem_amt := i.invoice_prem_amt;
       PIPE ROW(v_q1);
     END LOOP;
     RETURN;
   END get_pol_doc_quey_1;

   FUNCTION get_pol_doc_query_2(p_extract_id GIXX_INVOICE.extract_id%TYPE)
     RETURN pol_doc_query_2_tab PIPELINED IS

     v_q2 pol_doc_query_2_type;

   BEGIN
     FOR i IN (
       SELECT ALL invtax.extract_id EXTRACT_ID2,
              invtax.tax_cd 	    INVTAX_TAX_CD,
              DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))	INVTAX_TAX_AMT,
              taxcharg.tax_desc    	TAXCHARG_TAX_DESC,
              taxcharg.include_tag 	TAX_CHARGE_INCLUDE_TAG,
              taxcharg.SEQUENCE	    TAX_CHARGE_SEQUENCE
         FROM GIXX_INVOICE invoice,
              GIXX_INV_TAX invtax,
              GIIS_TAX_CHARGES taxcharg,
              GIXX_POLBASIC pol,
              GIXX_PARLIST par
        WHERE (invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id) = ((taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id))
          AND invoice.extract_id = invtax.extract_id
          AND invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 1
          AND par.extract_id    = pol.extract_id
          AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
          AND invtax.item_grp = invoice.item_grp
        GROUP BY invtax.extract_id,
              invtax.tax_cd,
              taxcharg.tax_desc,
              taxcharg.include_tag,invoice.policy_currency,
              taxcharg.SEQUENCE
        UNION
       SELECT ALL invtax.extract_id  				EXTRACT_ID2,
              invtax.tax_cd 	    				INVTAX_TAX_CD,
              DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))	INVTAX_TAX_AMT,
              taxcharg.tax_desc    				TAXCHARG_TAX_DESC,
              taxcharg.include_tag 		        TAX_CHARGE_INCLUDE_TAG,
              taxcharg.SEQUENCE	                TAX_CHARGE_SEQUENCE
         FROM GIXX_ORIG_INVOICE invoice,
              GIXX_ORIG_INV_TAX invtax,
              GIIS_TAX_CHARGES taxcharg,
              GIXX_POLBASIC pol
         --   gixx_parlist par
        WHERE ( invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id ) = ( ( taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ) )
          AND invoice.extract_id = invtax.extract_id
          AND invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 2
        --AND par.extract_id    = pol.extract_id
        --AND  DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
        GROUP BY invtax.extract_id,
                 invtax.tax_cd,
                 taxcharg.tax_desc,
                 taxcharg.include_tag,invoice.policy_currency,
                 taxcharg.SEQUENCE
        ORDER BY TAX_CHARGE_SEQUENCE)
     LOOP
        v_q2.extract_id2             := i.extract_id2;
        v_q2.invtax_tax_cd           := i.invtax_tax_cd;
        v_q2.invtax_tax_amt          := i.invtax_tax_amt;
        v_q2.taxcharg_tax_desc       := i.taxcharg_tax_desc;
        v_q2.tax_charge_include_tag  := i.tax_charge_include_tag;
        v_q2.tax_charge_sequence     := i.tax_charge_sequence;
      PIPE ROW(v_q2);
     END LOOP;
     RETURN;
   END get_pol_doc_query_2;

   FUNCTION get_pol_doc_invoice (p_extract_id GIXX_INVOICE.extract_id%TYPE)
     RETURN pol_doc_invoice_tab PIPELINED IS

     v_invoice pol_doc_invoice_type;

   BEGIN
     FOR i IN (
          SELECT b450.extract_id extract_id20,
                 SUM (DECODE (NVL (b450.policy_currency, 'N'),
                              'N', (NVL (b450.prem_amt, 0) * b450.currency_rt),
                              NVL (b450.prem_amt, 0)
                             )
                     ) premium_amt,
                 SUM (DECODE (NVL (b450.policy_currency, 'N'),
                              'N', (NVL (b450.tax_amt, 0) * b450.currency_rt),
                              NVL (b450.tax_amt, 0)
                             )
                     ) tax_amt,
                 SUM (DECODE (NVL (b450.policy_currency, 'N'),
                              'N', (NVL (b450.other_charges, 0) * b450.currency_rt),
                              NVL (b450.other_charges, 0)
                             )
                     ) other_charges,
                   SUM (DECODE (NVL (b450.policy_currency, 'N'),
                                'N', (NVL (b450.prem_amt, 0) * b450.currency_rt),
                                NVL (b450.prem_amt, 0)
                               )
                       )
                 + SUM (DECODE (NVL (b450.policy_currency, 'N'),
                                'N', (NVL (b450.tax_amt, 0) * b450.currency_rt),
                                NVL (b450.tax_amt, 0)
                               )
                       )
                 + SUM (DECODE (NVL (b450.policy_currency, 'N'),
                                'N', (NVL (b450.other_charges, 0) * b450.currency_rt),
                                NVL (b450.other_charges, 0)
                               )
                       ) total,
                 b450.policy_currency policy_currency
            FROM GIXX_INVOICE b450,
                 GIXX_POLBASIC pol
           WHERE b450.extract_id = p_extract_id
             AND b450.extract_id = pol.extract_id
             AND pol.co_insurance_sw = 1
        GROUP BY b450.extract_id, b450.policy_currency
        UNION
          SELECT b450.extract_id extract_id20,
                 SUM (DECODE (NVL (b450.policy_currency, 'N'),
                              'N', (NVL (b450.prem_amt, 0) * b450.currency_rt),
                              NVL (b450.prem_amt, 0)
                             )
                     ) premium_amt,
                 SUM (DECODE (NVL (b450.policy_currency, 'N'),
                              'N', (NVL (b450.tax_amt, 0) * b450.currency_rt),
                              NVL (b450.tax_amt, 0)
                             )
                     ) tax_amt,
                 SUM (DECODE (NVL (b450.policy_currency, 'N'),
                              'N', (NVL (b450.other_charges, 0) * b450.currency_rt),
                              NVL (b450.other_charges, 0)
                             )
                     ) other_charges,
                   SUM (DECODE (NVL (b450.policy_currency, 'N'),
                                'N', (NVL (b450.prem_amt, 0) * b450.currency_rt),
                                NVL (b450.prem_amt, 0)
                               )
                       )
                 + SUM (DECODE (NVL (b450.policy_currency, 'N'),
                                'N', (NVL (b450.tax_amt, 0) * b450.currency_rt),
                                NVL (b450.tax_amt, 0)
                               )
                       )
                 + SUM (DECODE (NVL (b450.policy_currency, 'N'),
                                'N', (NVL (b450.other_charges, 0) * b450.currency_rt),
                                NVL (b450.other_charges, 0)
                               )
                       ) total,
                 b450.policy_currency policy_currency
            FROM GIXX_ORIG_INVOICE b450, GIXX_POLBASIC pol
           WHERE b450.extract_id = p_extract_id
             AND b450.extract_id = pol.extract_id
             AND pol.co_insurance_sw = 2
        GROUP BY b450.extract_id, b450.policy_currency)
     LOOP
        v_invoice.extract_id20    := i.extract_id20;
        v_invoice.premium_amt     := i.premium_amt;
        v_invoice.tax_amt         := i.tax_amt;
        v_invoice.other_charges   := i.other_charges;
        v_invoice.total           := i.total;
        v_invoice.policy_currency := i.policy_currency;
       PIPE ROW(v_invoice);
     END LOOP;
     RETURN;
   END get_pol_doc_invoice;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 04.14.2010
	**  Reference By 	: (POLICY DOCUMENTS)
	**  Description 	: Retrieves policy_currency of a record by its extract_id
	*/
	FUNCTION get_policy_currency (p_extract_id GIXX_POLBASIC.extract_id%TYPE)
	RETURN VARCHAR2
	IS
		v_policy_currency GIXX_INVOICE.policy_currency%TYPE;
	BEGIN
		FOR a IN (
			SELECT policy_currency
			  FROM GIXX_INVOICE
			 WHERE extract_id = p_extract_id)
		LOOP
			v_policy_currency := a.policy_currency;
		END LOOP;
		RETURN (v_policy_currency);
	END;

	FUNCTION get_pol_doc_tsi_amt(
		p_extract_id IN GIXX_POLBASIC.extract_id%TYPE,
		p_basic_tsi_amt IN GIXX_POLBASIC.tsi_amt%TYPE,
		p_basic_co_insurance_sw IN GIXX_POLBASIC.co_insurance_sw%TYPE)
	RETURN NUMBER
	IS
		v_extact          	GIXX_INVOICE.extract_id%TYPE;
		v_prem_amt          GIXX_INVOICE.prem_amt%TYPE;
		v_tax_amt          	GIXX_INVOICE.tax_amt%TYPE;
		v_other          	GIXX_INVOICE.other_charges%TYPE;
		v_total          	GIXX_INVOICE.prem_amt%TYPE;
		v_policy_curr       GIXX_INVOICE.policy_currency%TYPE;
		v_tsi_amt         	GIXX_INVOICE.prem_amt%TYPE;
		v_main_tsi  		GIXX_POLBASIC.tsi_amt%TYPE;
		v_co_ins_sw 		VARCHAR2(1);
		v_rate		  		GIXX_ITEM.currency_rt%TYPE := 1;
	BEGIN
		FOR X IN (
			SELECT b450.extract_id extract_id20,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.prem_amt,0) *  b450.currency_rt), NVL(b450.prem_amt,0))) premium_amt,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.tax_amt,0) * b450.currency_rt), NVL(b450.tax_amt,0))) tax_amt,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.other_charges,0) * b450.currency_rt),NVL(b450.other_charges,0))) other_charges,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.prem_amt,0) *  b450.currency_rt), NVL(b450.prem_amt,0))) +
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.tax_amt,0) * b450.currency_rt), NVL(b450.tax_amt,0))) +
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.other_charges,0) * b450.currency_rt),NVL(b450.other_charges,0))) total,
				   b450.policy_currency policy_currency
			  FROM GIXX_INVOICE b450, GIXX_POLBASIC pol
			 WHERE b450.extract_id = p_extract_id
			   AND b450.extract_id = pol.extract_id
			   AND pol.co_insurance_sw IN ('1','3')
		  GROUP BY b450.extract_id, b450.policy_currency
			 UNION
			SELECT b450.extract_id extract_id20,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.prem_amt,0) *  b450.currency_rt), NVL(b450.prem_amt,0))) premium_amt,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.tax_amt,0) * b450.currency_rt), NVL(b450.tax_amt,0))) tax_amt,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.other_charges,0) * b450.currency_rt),NVL(b450.other_charges,0))) other_charges,
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.prem_amt,0) *  b450.currency_rt), NVL(b450.prem_amt,0))) +
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.tax_amt,0) * b450.currency_rt), NVL(b450.tax_amt,0))) +
				   SUM(DECODE(NVL(b450.policy_currency,'N'),'N',( NVL(b450.other_charges,0) * b450.currency_rt),NVL(b450.other_charges,0))) total ,b450.policy_currency policy_currency
			  FROM GIXX_ORIG_INVOICE b450,GIXX_POLBASIC pol
			 WHERE b450.extract_id = p_extract_id
			   AND b450.extract_id = pol.extract_id
			   AND pol.co_insurance_sw  = '2'
		  GROUP BY b450.extract_id,b450.policy_currency)
		LOOP
			v_extact        := X.extract_ID20;
			v_prem_amt      := X.premium_amt;
			v_tax_amt       := X.tax_amt;
			v_other         := X.other_charges;
			v_total         := X.total ;
			v_policy_curr   := X.policy_currency;
		END LOOP;

		IF v_policy_curr = 'Y' THEN
			FOR b IN (
				SELECT currency_rt
				 FROM GIXX_ITEM
				 WHERE extract_id = p_extract_id)
			LOOP
				v_rate := b.currency_rt;
			END LOOP;
		END IF;

		v_main_tsi := p_basic_tsi_amt / v_rate;

		IF p_basic_co_insurance_sw = 2 THEN
			FOR a IN (
				SELECT (NVL(a.tsi_amt,0) * b.currency_rt)  tsi
				  FROM GIXX_MAIN_CO_INS a, GIXX_INVOICE b
				 WHERE a.extract_id = b.extract_id
				   AND a.extract_id = p_extract_id)
			LOOP
				v_main_tsi := a.tsi;
				EXIT;
			END LOOP;
		END IF;

		RETURN (v_main_tsi);
	END get_pol_doc_tsi_amt;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.04.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This function returns the computed prem_amt depending on its co_insurance_sw
	*/
	FUNCTION get_pol_doc_prem_amt(
		p_extract_id IN GIXX_INVOICE.extract_id%TYPE,
		p_co_insurance_sw IN GIXX_POLBASIC.co_insurance_sw%TYPE,
		p_prem_amt IN NUMBER)
	RETURN NUMBER
	IS
		v_prem_amt NUMBER(16,2) := p_prem_amt;
	BEGIN
		FOR a IN (
			SELECT DECODE(NVL(a.policy_currency,'N'),'N', NVL(b.tax_amt,0) * a.currency_rt, NVL(b.tax_amt,0)) tax_amt,
				   c.include_tag include_tag
			  FROM GIXX_INVOICE a, GIXX_INV_TAX b, GIIS_TAX_CHARGES c
			 WHERE a.extract_id = b.extract_id
			   AND a.item_grp = b.item_grp
			   AND b.line_cd = c.line_cd
			   AND b.iss_cd = c.iss_cd
			   AND b.tax_cd = c.tax_cd
			   AND a.extract_id = p_extract_id
			   AND p_co_insurance_sw = 1
			 UNION
			SELECT DECODE(NVL(a.policy_currency,'N'),'N', NVL(b.tax_amt,0) * a.currency_rt, NVL(b.tax_amt,0)) tax_amt,
				   c.include_tag include_tag
			  FROM GIXX_ORIG_INVOICE a, GIXX_ORIG_INV_TAX b, GIIS_TAX_CHARGES c
			 WHERE a.extract_id = b.extract_id
			   AND a.item_grp = b.item_grp
			   AND b.line_cd = c.line_cd
			   AND b.iss_cd = c.iss_cd
			   AND b.tax_cd = c.tax_cd
			   AND a.extract_id = p_extract_id
			   AND p_co_insurance_sw = 2)
		LOOP
			IF a.include_tag = 'Y' THEN
				v_prem_amt :=  v_prem_amt  + a.tax_amt;
			END IF;
		END LOOP;
		RETURN v_prem_amt;
	END get_pol_doc_prem_amt;

END Gixx_Invoice_Pkg;
/


