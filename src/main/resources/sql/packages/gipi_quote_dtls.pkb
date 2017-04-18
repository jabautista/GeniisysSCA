CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Dtls AS

  FUNCTION get_gipi_quote_dtls (v_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_dtl_tab PIPELINED  IS

	v_gipi_quote_dtls       gipi_quote_dtl_type;

  BEGIN
    FOR i IN (
      SELECT A.quote_id,         b.item_no,        b.item_title,      b.item_desc,         b.currency_cd,
	         d.currency_desc,    b.currency_rate,  b.coverage_cd,     e.coverage_desc,     c.peril_cd,
			 f.peril_name,       c.prem_rt,        c.tsi_amt,         c.prem_amt,          c.comp_rem,
			 d.short_name,		 c.basic_peril_cd, c.peril_type, 	  round(nvl((c.tsi_amt*(c.prem_rt / 100)),0),2) ann_prem_amt
        FROM GIPI_QUOTE A,
             GIPI_QUOTE_ITEM b,
             GIPI_QUOTE_ITMPERIL c,
	         GIIS_CURRENCY d,
             GIIS_COVERAGE e,
	         GIIS_PERIL f
       WHERE A.quote_id    = b.quote_id
         AND b.quote_id    = c.quote_id
         AND b.item_no     = c.item_no
         AND b.currency_cd = d.main_currency_cd
         AND b.coverage_cd = e.coverage_cd(+)
         AND A.line_cd     = f.line_cd
         AND c.peril_cd    = f.peril_cd
         AND A.quote_id    = v_quote_id)
    LOOP
	  v_gipi_quote_dtls.quote_id         := i.quote_id;
	  v_gipi_quote_dtls.item_no          := i.item_no;
  	  v_gipi_quote_dtls.item_title       := i.item_title;
 	  v_gipi_quote_dtls.item_desc        := i.item_desc;
  	  v_gipi_quote_dtls.currency_cd      := i.currency_cd;
  	  v_gipi_quote_dtls.currency_desc    := i.currency_desc;
 	  v_gipi_quote_dtls.currency_rate    := i.currency_rate;
  	  v_gipi_quote_dtls.coverage_cd      := i.coverage_cd;
  	  v_gipi_quote_dtls.coverage_desc    := i.coverage_desc;
 	  v_gipi_quote_dtls.peril_cd         := i.peril_cd;
  	  v_gipi_quote_dtls.peril_name       := i.peril_name;
  	  v_gipi_quote_dtls.prem_rt          := i.prem_rt;
  	  v_gipi_quote_dtls.tsi_amt          := i.tsi_amt;
  	  v_gipi_quote_dtls.prem_amt         := i.prem_amt;
  	  v_gipi_quote_dtls.comp_rem         := i.comp_rem;
  	  v_gipi_quote_dtls.short_name       := i.short_name;
	  v_gipi_quote_dtls.basic_peril_cd   := i.basic_peril_cd;
	  v_gipi_quote_dtls.peril_type       := i.peril_type;
	  v_gipi_quote_dtls.ann_prem_amt	 := i.ann_prem_amt;
      PIPE ROW (v_gipi_quote_dtls);
    END LOOP;
	RETURN;
  END get_gipi_quote_dtls;

  PROCEDURE set_gipi_quote_dtls (p_gipi_quote_dtl           IN GIPI_QUOTE_ITMPERIL%ROWTYPE )
  IS
  BEGIN
	MERGE INTO GIPI_QUOTE_ITMPERIL
     USING dual ON (quote_id     = p_gipi_quote_dtl.quote_id
	                AND item_no  = p_gipi_quote_dtl.item_no
					AND peril_cd = p_gipi_quote_dtl.peril_cd)
     WHEN NOT MATCHED THEN
         INSERT VALUES p_gipi_quote_dtl
     WHEN MATCHED THEN
         UPDATE SET prem_rt        = p_gipi_quote_dtl.prem_rt,
                    comp_rem       = p_gipi_quote_dtl.comp_rem,
                    tsi_amt        = p_gipi_quote_dtl.tsi_amt,
                    prem_amt       = p_gipi_quote_dtl.prem_amt,
                    cpi_rec_no     = p_gipi_quote_dtl.cpi_rec_no,
                    cpi_branch_cd  = p_gipi_quote_dtl.cpi_branch_cd,
                    ann_prem_amt   = p_gipi_quote_dtl.ann_prem_amt,
                    ann_tsi_amt    = p_gipi_quote_dtl.ann_tsi_amt,
                    as_charged_sw  = p_gipi_quote_dtl.as_charged_sw,
                    discount_sw    = p_gipi_quote_dtl.discount_sw,
                    line_cd        = p_gipi_quote_dtl.line_cd,
                    prt_flag       = p_gipi_quote_dtl.prt_flag,
                    rec_flag       = p_gipi_quote_dtl.rec_flag,
                    ri_comm_amt    = p_gipi_quote_dtl.ri_comm_amt,
                    ri_comm_rt     = p_gipi_quote_dtl.ri_comm_rt,
                    surcharge_sw   = p_gipi_quote_dtl.surcharge_sw,
                    tarf_cd        = p_gipi_quote_dtl.tarf_cd,
					basic_peril_cd = p_gipi_quote_dtl.basic_peril_cd,
					peril_type	   = p_gipi_quote_dtl.peril_type;
  END set_gipi_quote_dtls;

  PROCEDURE del_gipi_quote_dtls (p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                                 p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
								 p_peril_cd                 GIPI_QUOTE_ITMPERIL.peril_cd%TYPE )
  IS

  BEGIN

	DELETE FROM GIPI_QUOTE_ITMPERIL
	 WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no
	   AND peril_cd = p_peril_cd;
--*COMMIT;

  END del_gipi_quote_dtls;

  PROCEDURE del_gipi_quote_all_dtls (p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                                     p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE)
  IS

  BEGIN

	DELETE FROM GIPI_QUOTE_ITMPERIL
	 WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no;
--*COMMIT;

  END del_gipi_quote_all_dtls;

  PROCEDURE update_gipi_quote_prem(p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
  								   p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
								   p_peril_cd                   GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
								   p_peril_premAmt              GIPI_QUOTE_ITMPERIL.prem_amt%TYPE)
  IS

  BEGIN
  	  UPDATE GIPI_QUOTE_ITMPERIL
	    SET prem_amt = p_peril_premAmt
	  WHERE	quote_id = p_quote_id
	    AND item_no  = p_item_no
		AND peril_cd = p_peril_cd;

  END update_gipi_quote_prem;

	/*
	**  Created by		: D.Alcantara
	**  Date Created 	: 12.23.2010
	**  Reference By 	: (GIIMM002 - Quotation Information)
	**  Description 	: This procedure saves the item perils of a quotation
	*/
  PROCEDURE set_gipi_quote_itmperil_dtls (p_peril   IN GIPI_QUOTE_ITMPERIL%ROWTYPE)
  IS

    v_tsi GIPI_QUOTE_ITEM.TSI_AMT%TYPE;
    v_prem GIPI_QUOTE_ITEM.PREM_AMT%TYPE;
    v_currency NUMBER := 0;
    v_prem_amt GIPI_QUOTE_ITEM.PREM_AMT%TYPE;
    v_prem_amt2 GIPI_QUOTE_ITEM.PREM_AMT%TYPE; -- aaron 042607 to correct computation of require and peril dependent tax charges
    v_quote_inv_no GIPI_QUOTE_INVOICE.QUOTE_INV_NO%TYPE;
	v_quote	GIPI_QUOTE_INVOICE.quote_id%TYPE;
    v_exists VARCHAR2(1) := 'N';
    v_prorate_flag gipi_quote.prorate_flag%TYPE;
    v_comp_sw gipi_quote.comp_sw%TYPE;
    v_expiry gipi_quote.expiry_date%TYPE;
    v_incept gipi_quote.incept_date%TYPE;
    v_ann_tsi_amt gipi_quote_itmperil.ann_tsi_amt%TYPE;
    v_ann_prem_amt gipi_quote_itmperil.ann_prem_amt%TYPE;
    v_prem_rt gipi_quote_itmperil.prem_rt%TYPE;
    v_peril_cd gipi_quote_itmperil.peril_cd%TYPE;
    v_short_rt gipi_quote.short_rt_percent%TYPE;
    v_no_of_days NUMBER;
    v_ann_tsi gipi_quote_item.ann_tsi_amt%TYPE;
    v_ann_prem gipi_quote_item.ann_prem_amt%TYPE;
    v_ann_tsi_q gipi_quote.ann_tsi_amt%TYPE;
    v_ann_prem_q gipi_quote.ann_prem_amt%TYPE;
    v_denominator NUMBER;

    var_ann_tsi_amt             gipi_quote.ann_tsi_amt%TYPE;
    var_ann_prem_amt            gipi_quote.ann_prem_amt%TYPE;

	var_total_tsi_amt			gipi_quote.ann_tsi_amt%TYPE; -- rencela 2011-03-08 holds computed tsi_amount
	var_total_prem_amt			gipi_quote.ann_prem_amt%TYPE; -- rencela 2011-03-08 holds computed prem_amt

    var_total_ann_tsi_amt       NUMBER := 0; -- added by: nica 05.26.2011 holds computed ann_tsi_amt
    var_total_ann_prem_amt      NUMBER := 0; -- added by: nica 05.26.2011 holds computed ann_prem_amt

  BEGIN

    var_ann_tsi_amt := 0;
    var_ann_prem_amt := 0;

    FOR i IN (SELECT prorate_flag, comp_sw, expiry_date, incept_date, short_rt_percent
  	            FROM gipi_quote
               WHERE quote_id = p_peril.quote_id)
    LOOP
  	  v_prorate_flag := i.prorate_flag;
  	  v_comp_sw			 := i.comp_sw;
  	  v_expiry			 := i.expiry_date;
  	  v_incept			 := i.incept_date;
  	  v_short_rt		 := (i.short_rt_percent/100); --issa 11.11.2005; /100
  	  v_no_of_days   := (i.expiry_date - i.incept_date);
    END LOOP;

		v_denominator := check_duration (v_incept,v_expiry);
        v_ann_tsi_amt 	:= p_peril.tsi_amt;
        v_prem_rt				:= (p_peril.prem_rt/100); --issa 11.11.2005; /100
        IF p_peril.prem_rt = 0 AND p_peril.prem_amt != 0 THEN
             v_ann_prem_amt := p_peril.prem_amt;
        ELSE
           v_ann_prem_amt := (p_peril.tsi_amt * (p_peril.prem_rt/100)); --issa 11.11.2005; /100
        END IF;
        v_peril_cd      := p_peril.peril_cd;

        IF v_prorate_flag = '2' OR v_prorate_flag IS NULL THEN

            var_ann_tsi_amt := v_ann_tsi_amt;
            var_ann_prem_amt := v_ann_prem_amt;

        ELSIF v_prorate_flag = '1' THEN
		    IF v_comp_sw = 'Y' THEN

                var_ann_tsi_amt := v_ann_tsi_amt;
                var_ann_prem_amt := ((v_ann_prem_amt * (v_no_of_days + 1)) / v_denominator);

		    ELSIF v_comp_sw = 'M' THEN

                var_ann_tsi_amt := v_ann_tsi_amt;
                var_ann_prem_amt := ((v_ann_prem_amt * (v_no_of_days - 1)) / v_denominator);

		    ELSIF v_comp_sw NOT IN ('M','Y') OR v_comp_sw IS NULL THEN

                var_ann_tsi_amt := v_ann_tsi_amt;
                var_ann_prem_amt := ((v_ann_prem_amt * v_no_of_days) / v_denominator);

		    END IF;

        ELSIF v_prorate_flag = '3' THEN

            var_ann_tsi_amt := v_ann_tsi_amt;
            var_ann_prem_amt := (v_ann_prem_amt * v_short_rt);

	    END IF;



    MERGE INTO GIPI_QUOTE_ITMPERIL
     USING dual ON (quote_id     = p_peril.quote_id
	                AND item_no  = p_peril.item_no
					AND peril_cd = p_peril.peril_cd)
     WHEN NOT MATCHED THEN
         INSERT (quote_id, item_no, peril_cd, prem_rt, comp_rem, tsi_amt, prem_amt,
                 cpi_rec_no, cpi_branch_cd, ann_prem_amt, ann_tsi_amt, as_charged_sw,
                 discount_sw, line_cd, prt_flag, rec_flag, ri_comm_amt, ri_comm_rt,
                 surcharge_sw, tarf_cd, basic_peril_cd, peril_type)
         VALUES (p_peril.quote_id, p_peril.item_no, p_peril.peril_cd, p_peril.prem_rt,
                 p_peril.comp_rem, p_peril.tsi_amt, p_peril.prem_amt,
                 p_peril.cpi_rec_no, p_peril.cpi_branch_cd,
                 var_ann_prem_amt, var_ann_tsi_amt,
                 p_peril.as_charged_sw, p_peril.discount_sw, p_peril.line_cd,
                 p_peril.prt_flag, p_peril.rec_flag, p_peril.ri_comm_amt,
                 p_peril.ri_comm_rt, p_peril.surcharge_sw, p_peril.tarf_cd,
                 p_peril.basic_peril_cd, p_peril.peril_type)
     WHEN MATCHED THEN
         UPDATE SET prem_rt        = p_peril.prem_rt,
                    comp_rem       = p_peril.comp_rem,
                    tsi_amt        = p_peril.tsi_amt,
                    prem_amt       = p_peril.prem_amt,
                    cpi_rec_no     = p_peril.cpi_rec_no,
                    cpi_branch_cd  = p_peril.cpi_branch_cd,
                    ann_prem_amt   = var_ann_prem_amt,
                    ann_tsi_amt    = var_ann_tsi_amt,
                    as_charged_sw  = p_peril.as_charged_sw,
                    discount_sw    = p_peril.discount_sw,
                    line_cd        = p_peril.line_cd,
                    prt_flag       = p_peril.prt_flag,
                    rec_flag       = p_peril.rec_flag,
                    ri_comm_amt    = p_peril.ri_comm_amt,
                    ri_comm_rt     = p_peril.ri_comm_rt,
                    surcharge_sw   = p_peril.surcharge_sw,
                    tarf_cd        = p_peril.tarf_cd,
					basic_peril_cd = p_peril.basic_peril_cd,
					peril_type	   = p_peril.peril_type;


	    		  -- UPDATE total tsi AND total premium amount PER ITEM
				  SELECT SUM(tsi_amt)
				    INTO var_total_tsi_amt
                    FROM gipi_quote_itmperil a, giis_peril b
				    WHERE a.quote_id 	= p_peril.quote_id
                       AND a.item_no  	= p_peril.item_no
                       AND b.line_cd  	= p_peril.line_cd
                       AND a.peril_cd   = b.peril_cd
                       AND b.peril_type = 'B'; -- added condition for peril type 'B' - nica 05.26.2011

				  SELECT SUM(prem_amt)
				    INTO var_total_prem_amt
				    FROM gipi_quote_itmperil
				   WHERE quote_id = p_peril.quote_id
				     AND item_no = p_peril.item_no;

                  /**added by nica 05.26.2011*/
                  SELECT SUM(ann_prem_amt)
                    INTO var_total_ann_prem_amt
                    FROM gipi_quote_itmperil
                     WHERE quote_id = p_peril.quote_id
                       AND item_no  = p_peril.item_no;

                  	SELECT SUM(a.ann_tsi_amt)
                    INTO var_total_ann_tsi_amt
                    FROM gipi_quote_itmperil a, giis_peril b
                     WHERE a.quote_id 	= p_peril.quote_id
                       AND a.item_no  	= p_peril.item_no
                       AND b.line_cd  	= p_peril.line_cd
                       AND a.peril_cd   = b.peril_cd
                       AND b.peril_type = 'B';
                  -- nica

				  UPDATE GIPI_QUOTE_ITEM
				     SET tsi_amt=var_total_tsi_amt,
					     prem_amt=var_total_prem_amt,
                         ann_tsi_amt = var_total_ann_tsi_amt,
                         ann_prem_amt = var_total_ann_prem_amt
                     WHERE quote_id = p_peril.quote_id
				     AND item_no = p_peril.item_no;

				  --var_total_tsi_amt := 0;
				 -- var_total_prem_amt := 0;

				  -- UPDATE total tsi AND total premium amount PER QUOTE

				  /*insert into roy_test_tbl(string_col, bigdecimal_col, date_col)
	 			  		 values ('a var_total_tsi_amt', var_total_tsi_amt, sysdate);

				  insert into roy_test_tbl(string_col, bigdecimal_col, date_col)
				  		 values ('a var_total_prem_amt', var_total_prem_amt, sysdate);*/

				  SELECT SUM(tsi_amt), SUM(ann_tsi_amt) -- added by: Nica 05.26.2011
				    INTO var_total_tsi_amt, var_total_ann_tsi_amt
				    FROM gipi_quote_itmperil
				   WHERE quote_id = p_peril.quote_id;

				  SELECT SUM(prem_amt), SUM(ann_prem_amt) -- added by: Nica 05.26.2011
				    INTO var_total_prem_amt, var_total_ann_prem_amt
				    FROM gipi_quote_itmperil
				   WHERE quote_id = p_peril.quote_id;

				  /*insert into roy_test_tbl(string_col, bigdecimal_col, date_col)
	 			  		 values ('b var_total_tsi_amt', var_total_tsi_amt, sysdate);

				  insert into roy_test_tbl(string_col, bigdecimal_col, date_col)
				  		 values ('b var_total_prem_amt',var_total_prem_amt, sysdate);

				  insert into roy_test_tbl(string_col, date_col)
	 			  		 values (p_peril.line_cd, sysdate);  */

				  UPDATE GIPI_QUOTE
				     SET tsi_amt=var_total_tsi_amt,
					     prem_amt=var_total_prem_amt,
                         ann_tsi_amt = var_total_ann_tsi_amt,
                         ann_prem_amt = var_total_ann_prem_amt
				   WHERE quote_id = p_peril.quote_id
				     AND line_cd = p_peril.line_cd;
					 --AND subline_cd = p_peril.subline_cd;
	END set_gipi_quote_itmperil_dtls;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 24, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Function returns details of quote item perils
**					under a Package Quotation
*/

  FUNCTION get_quote_dtls_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_dtl_tab PIPELINED  IS

	v_gipi_quote_dtls       gipi_quote_dtl_type;

  BEGIN
    FOR i IN (
      SELECT A.quote_id,         b.item_no,        b.item_title,      b.item_desc,         b.currency_cd,
	         d.currency_desc,    b.currency_rate,  b.coverage_cd,     e.coverage_desc,     c.peril_cd,
			 f.peril_name,       c.prem_rt,        c.tsi_amt,         c.prem_amt,          c.comp_rem,
			 d.short_name,		 f.basc_perl_cd,   f.peril_type, 	  round(nvl((c.tsi_amt*(c.prem_rt / 100)),0),2) ann_prem_amt
        FROM GIPI_QUOTE A,
             GIPI_QUOTE_ITEM b,
             GIPI_QUOTE_ITMPERIL c,
	         GIIS_CURRENCY d,
             GIIS_COVERAGE e,
	         GIIS_PERIL f
       WHERE A.quote_id    = b.quote_id
         AND b.quote_id    = c.quote_id
         AND b.item_no     = c.item_no
         AND b.currency_cd = d.main_currency_cd
         AND b.coverage_cd = e.coverage_cd(+)
         AND A.line_cd     = f.line_cd
         AND c.peril_cd    = f.peril_cd
         AND A.quote_id IN (SELECT quote_id
							FROM GIPI_QUOTE
							WHERE pack_quote_id = p_pack_quote_id))
    LOOP
	  v_gipi_quote_dtls.quote_id         := i.quote_id;
	  v_gipi_quote_dtls.item_no          := i.item_no;
  	  v_gipi_quote_dtls.item_title       := i.item_title;
 	  v_gipi_quote_dtls.item_desc        := i.item_desc;
  	  v_gipi_quote_dtls.currency_cd      := i.currency_cd;
  	  v_gipi_quote_dtls.currency_desc    := i.currency_desc;
 	  v_gipi_quote_dtls.currency_rate    := i.currency_rate;
  	  v_gipi_quote_dtls.coverage_cd      := i.coverage_cd;
  	  v_gipi_quote_dtls.coverage_desc    := i.coverage_desc;
 	  v_gipi_quote_dtls.peril_cd         := i.peril_cd;
  	  v_gipi_quote_dtls.peril_name       := i.peril_name;
  	  v_gipi_quote_dtls.prem_rt          := i.prem_rt;
  	  v_gipi_quote_dtls.tsi_amt          := i.tsi_amt;
  	  v_gipi_quote_dtls.prem_amt         := i.prem_amt;
  	  v_gipi_quote_dtls.comp_rem         := i.comp_rem;
  	  v_gipi_quote_dtls.short_name       := i.short_name;
	  v_gipi_quote_dtls.basic_peril_cd   := i.basc_perl_cd;
	  v_gipi_quote_dtls.peril_type       := i.peril_type;
	  v_gipi_quote_dtls.ann_prem_amt	 := i.ann_prem_amt;
      PIPE ROW (v_gipi_quote_dtls);
    END LOOP;
	RETURN;
  END get_quote_dtls_for_pack;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 26, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Deletes peril from gipi_quote_itmperil table and
**                  updates the tsi_amt, prem_ant, ann_tsi_amt and ann_prem_amt
**					of gipi_quote and gipi_quote_item tables
*/

  PROCEDURE del_gipi_quote_itmperil_dtls(p_quote_id				    GIPI_QUOTE.quote_id%TYPE,
                                         p_item_no                  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
								         p_peril_cd                 GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
                                         p_line_cd                  GIPI_QUOTE.line_cd%TYPE)
  IS

  BEGIN
    DELETE FROM GIPI_QUOTE_ITMPERIL
	 WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no
	   AND peril_cd = p_peril_cd;

    UPDATE_QUOTE_ANN_TSI_PREM(p_quote_id, p_item_no, p_line_cd);

  END del_gipi_quote_itmperil_dtls;

END Gipi_Quote_Dtls;
/


