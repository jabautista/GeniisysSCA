CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Item_Pkg AS

  FUNCTION get_gipi_quote_item (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_item_tab PIPELINED  IS

	v_gipi_quote_item      gipi_quote_item_type;

  BEGIN
    FOR i IN (
      SELECT quote_id,        item_no,           item_title,        item_desc,         currency_cd,         currency_rate,
             pack_line_cd,    pack_subline_cd,   tsi_amt,           prem_amt,          a.cpi_rec_no,        a.cpi_branch_cd,
             b.coverage_cd,   mc_motor_no,       mc_plate_no,       mc_serial_no,      date_from,           date_to,
             (SELECT sum((tsi_amt * (prem_rt / 100)))
			 	 FROM GIPI_QUOTE_ITMPERIL
			   WHERE quote_id = a.quote_id AND item_no = a.item_no) ann_prem_amt,     ann_tsi_amt,
			 changed_tag,       comp_sw,           discount_sw,         group_cd,
             item_desc2,      item_grp,          other_info,        pack_ben_cd,       prorate_flag,        rec_flag,
             region_cd,       short_rt_percent,  surcharge_sw,      coverage_desc,     currency_desc
        FROM GIPI_QUOTE_ITEM a,
		     giis_coverage b,
			 giis_currency c
       WHERE a.currency_cd = c.main_currency_cd
	     AND a.coverage_cd = b.coverage_cd(+)
	     AND a.quote_id    = p_quote_id
       ORDER BY item_no)
    LOOP
	  v_gipi_quote_item.quote_id         := i.quote_id;
      v_gipi_quote_item.item_no          := i.item_no;
      v_gipi_quote_item.item_title       := i.item_title;
      v_gipi_quote_item.item_desc        := i.item_desc;
      v_gipi_quote_item.currency_cd      := i.currency_cd;
      v_gipi_quote_item.currency_rate    := i.currency_rate;
      v_gipi_quote_item.pack_line_cd     := i.pack_line_cd;
      v_gipi_quote_item.pack_subline_cd  := i.pack_subline_cd;
      v_gipi_quote_item.tsi_amt          := i.tsi_amt;
      v_gipi_quote_item.prem_amt         := i.prem_amt;
      v_gipi_quote_item.cpi_rec_no       := i.cpi_rec_no;
      v_gipi_quote_item.cpi_branch_cd    := i.cpi_branch_cd;
      v_gipi_quote_item.coverage_cd      := i.coverage_cd;
      v_gipi_quote_item.mc_motor_no      := i.mc_motor_no;
      v_gipi_quote_item.mc_plate_no      := i.mc_plate_no;
      v_gipi_quote_item.mc_serial_no     := i.mc_serial_no;
      v_gipi_quote_item.date_from        := i.date_from;
      v_gipi_quote_item.date_to          := i.date_to;
      v_gipi_quote_item.ann_prem_amt     := i.ann_prem_amt;
      v_gipi_quote_item.ann_tsi_amt      := i.ann_tsi_amt;
      v_gipi_quote_item.changed_tag      := i.changed_tag;
      v_gipi_quote_item.comp_sw          := i.comp_sw;
      v_gipi_quote_item.discount_sw      := i.discount_sw;
      v_gipi_quote_item.group_cd         := i.group_cd;
      v_gipi_quote_item.item_desc2       := i.item_desc2;
      v_gipi_quote_item.item_grp         := i.item_grp;
      v_gipi_quote_item.other_info       := i.other_info;
      v_gipi_quote_item.pack_ben_cd      := i.pack_ben_cd;
      v_gipi_quote_item.prorate_flag     := i.prorate_flag;
      v_gipi_quote_item.rec_flag         := i.rec_flag;
      v_gipi_quote_item.region_cd        := i.region_cd;
      v_gipi_quote_item.short_rt_percent := i.short_rt_percent;
      v_gipi_quote_item.surcharge_sw     := i.surcharge_sw;
      v_gipi_quote_item.coverage_desc    := i.coverage_desc;
      v_gipi_quote_item.currency_desc    := i.currency_desc;
      PIPE ROW (v_gipi_quote_item);
    END LOOP;
	RETURN;
  END get_gipi_quote_item;

  PROCEDURE set_gipi_quote_item (p_gipi_quote_item          IN GIPI_QUOTE_ITEM%ROWTYPE)
  IS

  BEGIN

	MERGE INTO GIPI_QUOTE_ITEM
     USING dual ON (quote_id     = p_gipi_quote_item.quote_id
	                 AND item_no = p_gipi_quote_item.item_no)
     WHEN NOT MATCHED THEN
         INSERT VALUES p_gipi_quote_item
     WHEN MATCHED THEN
         UPDATE SET  item_title       = p_gipi_quote_item.item_title,
                     item_desc        = p_gipi_quote_item.item_desc,
                     currency_cd      = p_gipi_quote_item.currency_cd,
                     currency_rate    = p_gipi_quote_item.currency_rate,
                     pack_line_cd     = p_gipi_quote_item.pack_line_cd,
                     pack_subline_cd  = p_gipi_quote_item.pack_subline_cd,
                     tsi_amt          = p_gipi_quote_item.tsi_amt,
                     prem_amt         = p_gipi_quote_item.prem_amt,
                     cpi_rec_no       = p_gipi_quote_item.cpi_rec_no,
                     cpi_branch_cd    = p_gipi_quote_item.cpi_branch_cd,
                     coverage_cd      = p_gipi_quote_item.coverage_cd,
                     mc_motor_no      = p_gipi_quote_item.mc_motor_no,
                     mc_plate_no      = p_gipi_quote_item.mc_plate_no,
                     mc_serial_no     = p_gipi_quote_item.mc_serial_no,
                     date_from        = p_gipi_quote_item.date_from,
                     date_to          = p_gipi_quote_item.date_to,
                     ann_prem_amt     = p_gipi_quote_item.ann_prem_amt,
                     ann_tsi_amt      = p_gipi_quote_item.ann_tsi_amt,
                     changed_tag      = p_gipi_quote_item.changed_tag,
                     comp_sw          = p_gipi_quote_item.comp_sw,
                     discount_sw      = p_gipi_quote_item.discount_sw,
                     group_cd         = p_gipi_quote_item.group_cd,
                     item_desc2       = p_gipi_quote_item.item_desc2,
                     item_grp         = p_gipi_quote_item.item_grp,
                     other_info       = p_gipi_quote_item.other_info,
                     pack_ben_cd      = p_gipi_quote_item.pack_ben_cd,
                     prorate_flag     = p_gipi_quote_item.prorate_flag,
                     rec_flag         = p_gipi_quote_item.rec_flag,
                     region_cd        = p_gipi_quote_item.region_cd,
                     short_rt_percent = p_gipi_quote_item.short_rt_percent,
                     surcharge_sw     = p_gipi_quote_item.surcharge_sw;
--*	COMMIT;

  END set_gipi_quote_item;


  FUNCTION get_gipi_quote_item_by_item (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                                        p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN gipi_quote_item_tab PIPELINED  IS

	v_gipi_quote_item      gipi_quote_item_type;

  BEGIN
    FOR i IN (
      SELECT quote_id,        item_no,           item_title,        item_desc,         currency_cd,         currency_rate,
             pack_line_cd,    pack_subline_cd,   tsi_amt,           prem_amt,          a.cpi_rec_no,        a.cpi_branch_cd,
             b.coverage_cd,   mc_motor_no,       mc_plate_no,       mc_serial_no,      date_from,           date_to,
             ann_prem_amt,    ann_tsi_amt,       changed_tag,       comp_sw,           discount_sw,         group_cd,
             item_desc2,      item_grp,          other_info,        pack_ben_cd,       prorate_flag,        rec_flag,
             region_cd,       short_rt_percent,  surcharge_sw,      coverage_desc,     currency_desc
        FROM GIPI_QUOTE_ITEM a,
		     giis_coverage b,
			 giis_currency c
       WHERE a.currency_cd = c.main_currency_cd
	     AND a.coverage_cd = b.coverage_cd
	     AND a.quote_id    = p_quote_id
		 AND a.item_no     = p_item_no)
    LOOP
	  v_gipi_quote_item.quote_id         := i.quote_id;
      v_gipi_quote_item.item_no          := i.item_no;
      v_gipi_quote_item.item_title       := i.item_title;
      v_gipi_quote_item.item_desc        := i.item_desc;
      v_gipi_quote_item.currency_cd      := i.currency_cd;
      v_gipi_quote_item.currency_rate    := i.currency_rate;
      v_gipi_quote_item.pack_line_cd     := i.pack_line_cd;
      v_gipi_quote_item.pack_subline_cd  := i.pack_subline_cd;
      v_gipi_quote_item.tsi_amt          := i.tsi_amt;
      v_gipi_quote_item.prem_amt         := i.prem_amt;
      v_gipi_quote_item.cpi_rec_no       := i.cpi_rec_no;
      v_gipi_quote_item.cpi_branch_cd    := i.cpi_branch_cd;
      v_gipi_quote_item.coverage_cd      := i.coverage_cd;
      v_gipi_quote_item.mc_motor_no      := i.mc_motor_no;
      v_gipi_quote_item.mc_plate_no      := i.mc_plate_no;
      v_gipi_quote_item.mc_serial_no     := i.mc_serial_no;
      v_gipi_quote_item.date_from        := i.date_from;
      v_gipi_quote_item.date_to          := i.date_to;
      v_gipi_quote_item.ann_prem_amt     := i.ann_prem_amt;
      v_gipi_quote_item.ann_tsi_amt      := i.ann_tsi_amt;
      v_gipi_quote_item.changed_tag      := i.changed_tag;
      v_gipi_quote_item.comp_sw          := i.comp_sw;
      v_gipi_quote_item.discount_sw      := i.discount_sw;
      v_gipi_quote_item.group_cd         := i.group_cd;
      v_gipi_quote_item.item_desc2       := i.item_desc2;
      v_gipi_quote_item.item_grp         := i.item_grp;
      v_gipi_quote_item.other_info       := i.other_info;
      v_gipi_quote_item.pack_ben_cd      := i.pack_ben_cd;
      v_gipi_quote_item.prorate_flag     := i.prorate_flag;
      v_gipi_quote_item.rec_flag         := i.rec_flag;
      v_gipi_quote_item.region_cd        := i.region_cd;
      v_gipi_quote_item.short_rt_percent := i.short_rt_percent;
      v_gipi_quote_item.surcharge_sw     := i.surcharge_sw;
      PIPE ROW (v_gipi_quote_item);
    END LOOP;
	RETURN;
  END get_gipi_quote_item_by_item;


  FUNCTION get_gipi_quote_item_report (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_item_rep_tab PIPELINED  IS

	v_gipi_quote_item      gipi_quote_item_rep;

  BEGIN
    FOR i IN (
      SELECT DISTINCT DECODE(COUNT(item_no) OVER (PARTITION BY quote_id), 1, TO_CHAR(item_no), 'VARIOUS') item_no,
             DECODE(COUNT(item_title) OVER (PARTITION BY quote_id), 1, item_title, 'VARIOUS') item_title,
             DECODE(COUNT(item_desc) OVER (PARTITION BY quote_id), 1, item_desc, 'VARIOUS') item_desc,
  		     DECODE(COUNT(item_desc2) OVER (PARTITION BY quote_id), 1, item_desc2, 'VARIOUS') item_desc2,
             DECODE(COUNT(DISTINCT currency_cd) OVER (PARTITION BY quote_id), 1, TO_CHAR(currency_cd), 'VARIOUS') currency_cd,
             DECODE(COUNT(DISTINCT currency_rate) OVER (PARTITION BY quote_id), 1, TO_CHAR(currency_rate), 'VARIOUS') currency_rate,
             DECODE(COUNT(DISTINCT region_cd) OVER (PARTITION BY quote_id), 1, TO_CHAR(region_cd), 'VARIOUS') region_cd,
             DECODE(COUNT(DISTINCT coverage_cd) OVER (PARTITION BY quote_id), 1, TO_CHAR(coverage_cd), 'VARIOUS') coverage_cd
        FROM GIPI_QUOTE_ITEM
       WHERE quote_id = p_quote_id)
    LOOP
      v_gipi_quote_item.item_no          := i.item_no;
      v_gipi_quote_item.item_title       := i.item_title;
      v_gipi_quote_item.item_desc        := i.item_desc;
      v_gipi_quote_item.currency_cd      := i.currency_cd;
      v_gipi_quote_item.currency_rate    := i.currency_rate;
      v_gipi_quote_item.coverage_cd      := i.coverage_cd;
      v_gipi_quote_item.item_desc2       := i.item_desc2;
      v_gipi_quote_item.region_cd        := i.region_cd;
	  PIPE ROW (v_gipi_quote_item);
    END LOOP;
	RETURN;
  END get_gipi_quote_item_report;


  PROCEDURE del_gipi_quote_item (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                                 p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS

  BEGIN

	DELETE FROM GIPI_QUOTE_ITEM
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no;
--*	COMMIT;

  END del_gipi_quote_item;


  PROCEDURE del_gipi_quote_all_items (p_quote_id    GIPI_QUOTE.quote_id%TYPE) IS

  BEGIN

	DELETE FROM GIPI_QUOTE_ITEM
     WHERE quote_id = p_quote_id;
--*	COMMIT;

  END del_gipi_quote_all_items;


  PROCEDURE updateQuoteItemPremAmt(p_quote_id    GIPI_QUOTE.quote_id%TYPE,
  								   p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE,
								   p_prem_amt    GIPI_QUOTE.prem_amt%TYPE) IS

  BEGIN

	UPDATE GIPI_QUOTE_ITEM
	SET prem_amt = p_prem_amt
	WHERE quote_id = p_quote_id
	AND item_no = p_item_no;

  END updateQuoteItemPremAmt;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 20, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Function returns details of items under a Package Quotation
*/

FUNCTION get_gipi_quote_item_for_pack (p_pack_quote_id   GIPI_QUOTE.pack_quote_id%TYPE)
    RETURN gipi_quote_item_tab PIPELINED  IS

	v_gipi_quote_item      gipi_quote_item_type;

  BEGIN
    FOR i IN (
      SELECT quote_id,        item_no,           item_title,        item_desc,         currency_cd,         currency_rate,
			 pack_line_cd,    pack_subline_cd,   tsi_amt,           prem_amt,          a.cpi_rec_no,        a.cpi_branch_cd,
			 b.coverage_cd,   mc_motor_no,       mc_plate_no,       mc_serial_no,      date_from,           date_to,
			 changed_tag,     comp_sw,           discount_sw,       group_cd,          ann_tsi_amt,         ann_prem_amt,
			 item_desc2,      item_grp,          other_info,        pack_ben_cd,       prorate_flag,        rec_flag,
			 region_cd,       short_rt_percent,  surcharge_sw,      coverage_desc,     currency_desc
        FROM GIPI_QUOTE_ITEM a,
             GIIS_COVERAGE b,
             GIIS_CURRENCY c
       WHERE a.currency_cd = c.main_currency_cd
         AND a.coverage_cd = b.coverage_cd(+)
         AND EXISTS (SELECT 1
                     FROM GIPI_QUOTE gq
                     WHERE gq.quote_id = a.quote_id
                     AND gq.pack_quote_id = p_pack_quote_id))
    LOOP
	  v_gipi_quote_item.quote_id         := i.quote_id;
      v_gipi_quote_item.item_no          := i.item_no;
      v_gipi_quote_item.item_title       := i.item_title;
      v_gipi_quote_item.item_desc        := i.item_desc;
      v_gipi_quote_item.currency_cd      := i.currency_cd;
      v_gipi_quote_item.currency_rate    := i.currency_rate;
      v_gipi_quote_item.pack_line_cd     := i.pack_line_cd;
      v_gipi_quote_item.pack_subline_cd  := i.pack_subline_cd;
      v_gipi_quote_item.tsi_amt          := i.tsi_amt;
      v_gipi_quote_item.prem_amt         := i.prem_amt;
      v_gipi_quote_item.cpi_rec_no       := i.cpi_rec_no;
      v_gipi_quote_item.cpi_branch_cd    := i.cpi_branch_cd;
      v_gipi_quote_item.coverage_cd      := i.coverage_cd;
      v_gipi_quote_item.mc_motor_no      := i.mc_motor_no;
      v_gipi_quote_item.mc_plate_no      := i.mc_plate_no;
      v_gipi_quote_item.mc_serial_no     := i.mc_serial_no;
      v_gipi_quote_item.date_from        := i.date_from;
      v_gipi_quote_item.date_to          := i.date_to;
      v_gipi_quote_item.ann_prem_amt     := i.ann_prem_amt;
      v_gipi_quote_item.ann_tsi_amt      := i.ann_tsi_amt;
      v_gipi_quote_item.changed_tag      := i.changed_tag;
      v_gipi_quote_item.comp_sw          := i.comp_sw;
      v_gipi_quote_item.discount_sw      := i.discount_sw;
      v_gipi_quote_item.group_cd         := i.group_cd;
      v_gipi_quote_item.item_desc2       := i.item_desc2;
      v_gipi_quote_item.item_grp         := i.item_grp;
      v_gipi_quote_item.other_info       := i.other_info;
      v_gipi_quote_item.pack_ben_cd      := i.pack_ben_cd;
      v_gipi_quote_item.prorate_flag     := i.prorate_flag;
      v_gipi_quote_item.rec_flag         := i.rec_flag;
      v_gipi_quote_item.region_cd        := i.region_cd;
      v_gipi_quote_item.short_rt_percent := i.short_rt_percent;
      v_gipi_quote_item.surcharge_sw     := i.surcharge_sw;
      v_gipi_quote_item.coverage_desc    := i.coverage_desc;
      v_gipi_quote_item.currency_desc    := i.currency_desc;
      PIPE ROW (v_gipi_quote_item);
    END LOOP;
	RETURN;
END get_gipi_quote_item_for_pack;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 23, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Insert/Update details of items under a Package Quotation
*/

PROCEDURE set_gipi_quote_item2
   (p_quote_id			IN		GIPI_QUOTE_ITEM.quote_id%TYPE,
	p_item_no			IN    	GIPI_QUOTE_ITEM.item_no%TYPE,
	p_item_title		IN		GIPI_QUOTE_ITEM.item_title%TYPE,
	p_item_desc 		IN		GIPI_QUOTE_ITEM.item_desc%TYPE,
	p_item_desc2  		IN		GIPI_QUOTE_ITEM.item_desc2%TYPE,
	p_currency_cd		IN		GIPI_QUOTE_ITEM.currency_cd%TYPE,
	p_currency_rate 	IN		GIPI_QUOTE_ITEM.currency_rate%TYPE,
	p_coverage_cd		IN		GIPI_QUOTE_ITEM.coverage_cd%TYPE)

  IS

  BEGIN

	MERGE INTO GIPI_QUOTE_ITEM
     USING dual ON (quote_id     = p_quote_id
	                 AND item_no = p_item_no)
     WHEN NOT MATCHED THEN
         INSERT
		 (quote_id,  			item_no, 		item_title,
		  item_desc, 			item_desc2,  	currency_cd,
		  currency_rate, 		coverage_cd)
		 VALUES
	     (p_quote_id,  			p_item_no, 		p_item_title,
		  p_item_desc, 			p_item_desc2,  	p_currency_cd,
		  p_currency_rate, 		p_coverage_cd)
     WHEN MATCHED THEN
         UPDATE SET  item_title       = p_item_title,
					 item_desc2       = p_item_desc2,
                     item_desc        = p_item_desc,
                     currency_cd      = p_currency_cd,
                     currency_rate    = p_currency_rate,
                     coverage_cd      = p_coverage_cd;

END set_gipi_quote_item2;

    /*
    **  Created by    : Robert John Virrey
    **  Date Created  : May 25, 2012
    **  Reference By  : GIIMM002 - Enter Quotation Information
    **  Description   : Insert/Update details of quote item
    */
    PROCEDURE set_gipi_quote_item3 (
       p_quote_id          gipi_quote_item.quote_id%TYPE,
       p_item_no           gipi_quote_item.item_no%TYPE,
       p_prem_amt          gipi_quote_item.prem_amt%TYPE,
       p_tsi_amt           gipi_quote_item.tsi_amt%TYPE,
       p_item_title        gipi_quote_item.item_title%TYPE,
       p_item_desc         gipi_quote_item.item_desc%TYPE,
       p_item_desc2        gipi_quote_item.item_desc2%TYPE,
       p_currency_cd       gipi_quote_item.currency_cd%TYPE,
       p_currency_rate     gipi_quote_item.currency_rate%TYPE,
       p_coverage_cd       gipi_quote_item.coverage_cd%TYPE,
       p_pack_line_cd      gipi_quote_item.pack_line_cd%TYPE,
       p_pack_subline_cd   gipi_quote_item.pack_subline_cd%TYPE,
       p_date_from         gipi_quote_item.date_from%TYPE,
       p_date_to           gipi_quote_item.date_to%TYPE
    )
    IS
    BEGIN
       MERGE INTO gipi_quote_item
          USING DUAL
          ON (quote_id = p_quote_id AND item_no = p_item_no)
          WHEN NOT MATCHED THEN
             INSERT (quote_id, item_no, prem_amt, tsi_amt, item_title, item_desc,
                     item_desc2, currency_cd, currency_rate, coverage_cd,
                     pack_line_cd, pack_subline_cd, date_from, date_to)
             VALUES (p_quote_id, p_item_no, p_prem_amt, p_tsi_amt, p_item_title,
                     p_item_desc, p_item_desc2, p_currency_cd, p_currency_rate,
                     p_coverage_cd, p_pack_line_cd, p_pack_subline_cd,
                     p_date_from, p_date_to)
          WHEN MATCHED THEN
             UPDATE
                SET prem_amt        = p_prem_amt,
                    tsi_amt         = p_tsi_amt,
                    item_title      = p_item_title,
                    item_desc       = p_item_desc,
                    item_desc2      = p_item_desc2,
                    currency_cd     = p_currency_cd,
                    currency_rate   = p_currency_rate,
                    coverage_cd     = p_coverage_cd,
                    pack_line_cd    = p_pack_line_cd,
                    pack_subline_cd = p_pack_subline_cd,
                    date_from       = p_date_from,
                    date_to         = p_date_to
             ;
    END set_gipi_quote_item3;

    PROCEDURE post_commit_quote_item (
       p_quote_id        gipi_quote_item.quote_id%TYPE,
       p_currency_cd     gipi_quote_item.currency_cd%TYPE,
       p_currency_rate   gipi_quote_item.currency_rate%TYPE
    )
    IS
       v_tsi            gipi_quote_item.tsi_amt%TYPE;
       v_prem           gipi_quote_item.prem_amt%TYPE;
       v_prem_amt       gipi_quote_item.tsi_amt%TYPE;
       v_line_cd        gipi_quote.line_cd%TYPE;
       v_iss_cd         gipi_quote.iss_cd%TYPE;
       v_quote_inv_no   gipi_quote_invoice.quote_inv_no%TYPE;
       v_currency       NUMBER   := 0;
    BEGIN
       SELECT iss_cd, line_cd
         INTO v_iss_cd, v_line_cd
         FROM gipi_quote
        WHERE quote_id = p_quote_id;

       SELECT SUM (tsi_amt), SUM (prem_amt)
         INTO v_tsi, v_prem
         FROM gipi_quote_item
        WHERE quote_id = p_quote_id;

       UPDATE gipi_quote
          SET tsi_amt = v_tsi,
              prem_amt = v_prem
        WHERE quote_id = p_quote_id;

       FOR v IN (SELECT quote_inv_no
                   FROM gipi_quote_invoice
                  WHERE currency_cd = p_currency_cd AND quote_id = p_quote_id)
       LOOP
          v_currency := 1;
          v_quote_inv_no := v.quote_inv_no;
          EXIT;
       END LOOP;

       SELECT SUM (prem_amt)
         INTO v_prem_amt
         FROM gipi_quote_item
        WHERE currency_cd = p_currency_cd AND quote_id = p_quote_id;

       IF v_currency = 1
       THEN
          UPDATE gipi_quote_invoice
             SET prem_amt = v_prem_amt
           WHERE quote_id = p_quote_id
             AND iss_cd = v_iss_cd
             AND currency_cd = p_currency_cd
             AND quote_inv_no = v_quote_inv_no;
       ELSIF v_currency = 0
       THEN
          INSERT INTO gipi_quote_invoice
                      (quote_id, iss_cd, quote_inv_no, currency_cd, currency_rt,
                       prem_amt
                      )
               VALUES (p_quote_id, v_iss_cd, 1, p_currency_cd, p_currency_rate,
                       v_prem_amt
                      );

          create_quote_invoice (p_quote_id, v_line_cd, v_iss_cd);
       END IF;
    END;

    PROCEDURE del_quote_item_addl (
        p_quote_id        gipi_quote_item.quote_id%TYPE,
        p_item_no         gipi_quote_item.item_no%TYPE,
        p_currency_cd     gipi_quote_item.currency_cd%TYPE
    )
    IS
       v_counter      NUMBER := 0;
       v_prem_amt     gipi_quote_item.prem_amt%TYPE;
       v_tsi          gipi_quote_item.tsi_amt%TYPE;
       v_tsi_q        gipi_quote.tsi_amt%TYPE;
       v_prem_q       gipi_quote.prem_amt%TYPE;
       v_ann_tsi_q    gipi_quote.ann_tsi_amt%TYPE;
       v_ann_prem_q   gipi_quote.ann_prem_amt%TYPE;
    BEGIN
       DELETE FROM gipi_quote_itmperil g
             WHERE g.item_no = p_item_no AND g.quote_id = p_quote_id;

       DELETE FROM gipi_quote_ac_item g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

       DELETE FROM gipi_quote_ca_item g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

       DELETE FROM gipi_quote_cargo g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

       DELETE FROM gipi_quote_item_mc g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

       DELETE FROM gipi_quote_av_item g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

       DELETE FROM gipi_quote_mh_item g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

       DELETE FROM gipi_quote_en_item g
             WHERE g.quote_id = p_quote_id;

       DELETE FROM gipi_quote_fi_item g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;
             
       DELETE FROM gipi_quote_peril_discount d
             WHERE d.quote_id = p_quote_id AND d.item_no = p_item_no; 

--       FOR v IN (SELECT '1'
--                   FROM gipi_quote_item
--                  WHERE currency_cd = p_currency_cd AND quote_id = p_quote_id)
--       LOOP
--          v_counter := v_counter + 1;

--          IF v_counter > 1
--          THEN
--             EXIT;
--          END IF;
--       END LOOP;

       BEGIN
         SELECT COUNT(1)
           INTO v_counter
           FROM GIPI_QUOTE_ITEM
          WHERE quote_id = p_quote_id
            AND currency_cd = p_currency_cd;
       END;

       IF v_counter = 1
       THEN
          FOR v IN (SELECT quote_inv_no
                      FROM gipi_quote_invoice
                     WHERE quote_id = p_quote_id AND currency_cd = p_currency_cd)
          LOOP
             DELETE FROM gipi_quote_invtax
                   WHERE quote_inv_no = v.quote_inv_no;

             DELETE FROM gipi_quote_invoice
                   WHERE quote_inv_no = v.quote_inv_no;

             EXIT;
          END LOOP;
       END IF;

       SELECT SUM (tsi_amt), SUM (prem_amt)
         INTO v_tsi, v_prem_amt
         FROM gipi_quote_itmperil
        WHERE quote_id = p_quote_id;

       UPDATE gipi_quote_invoice
          SET prem_amt = v_prem_amt
        WHERE quote_id = p_quote_id;

       SELECT SUM (tsi_amt), SUM (prem_amt), SUM (ann_tsi_amt), SUM (ann_prem_amt)
         INTO v_tsi_q, v_prem_q, v_ann_tsi_q, v_ann_prem_q
         FROM gipi_quote_item
        WHERE quote_id = p_quote_id;

       UPDATE gipi_quote
          SET tsi_amt = v_tsi_q,
              prem_amt = v_prem_q,
              ann_tsi_amt = v_ann_tsi_q,
              ann_prem_amt = v_ann_prem_q
        WHERE quote_id = p_quote_id;

       DELETE FROM gipi_quote_item g
             WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;
			 
	   DELETE FROM gipi_quote_deductibles g
	         WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;
			 
	   DELETE FROM gipi_quote_mortgagee g
	         WHERE g.quote_id = p_quote_id AND g.item_no = p_item_no;

        set_giimm002_invoice(p_quote_id, p_item_no);

    END del_quote_item_addl;
    
    FUNCTION check_gipi_quote_item_exists(
        p_quote_id      GIPI_QUOTE_ITEM.quote_id%TYPE,
        p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE
    )
      RETURN VARCHAR2
    AS
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN(SELECT 'Y'
                   FROM GIPI_QUOTE_ITEM
                  WHERE quote_id = p_quote_id
                    AND item_no = p_item_no)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN v_exists;
    END;

    /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Check if quote has an item
   */
    FUNCTION quote_has_item (p_quote_id gipi_quote_item.quote_id%TYPE)
       RETURN BOOLEAN
    IS
       v_result   BOOLEAN := FALSE;
    BEGIN
       FOR a IN (SELECT item_no
                   FROM gipi_quote_item
                  WHERE quote_id = p_quote_id)
       LOOP
          v_result := TRUE;
          EXIT;
       END LOOP;

       RETURN v_result;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          NULL;
       WHEN OTHERS
       THEN
          RAISE;
    END quote_has_item;
    
    /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Return quote items without perul
   */
   FUNCTION get_quote_items_wo_peril (p_quote_id gipi_quote_item.quote_id%TYPE)
      RETURN VARCHAR2
   IS
      v_item_no   VARCHAR2 (12);
      v_items     VARCHAR2 (32767);
   BEGIN
      FOR i IN (SELECT   item_no
                    FROM gipi_quote_item
                   WHERE quote_id = p_quote_id
                     AND item_no NOT IN (SELECT item_no
                                           FROM gipi_quote_itmperil
                                          WHERE quote_id = p_quote_id)
                ORDER BY 1)
      LOOP
         v_item_no := i.item_no;
         v_items := v_items || v_item_no || ', ';
      END LOOP;

      RETURN v_items;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_quote_items_wo_peril;
   
   /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Count currencies used in quote item 
   */
   FUNCTION get_quote_items_currency_count (p_quote_id gipi_quote_item.quote_id%TYPE)
      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      SELECT COUNT (DISTINCT currency_cd)
        INTO v_count
        FROM gipi_quote_item
       WHERE quote_id = p_quote_id;

      RETURN v_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_quote_items_currency_count;
   
   /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Count currency rates used in quote item 
   */
    FUNCTION get_quote_items_curr_rt_count (p_quote_id gipi_quote_item.quote_id%TYPE)

      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      SELECT COUNT (DISTINCT currency_rate)
        INTO v_count
        FROM gipi_quote_item
       WHERE quote_id = p_quote_id;

      RETURN v_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_quote_items_curr_rt_count;
   
   /*
   **  Created by      : Nieko B.
   **  Date Created    : 02172016
   **  Reference By    : UW-SPECS-2015-086 Quotation Deductibles
   **  Description     : Check if quote has item peril
   */
   FUNCTION quote_item_has_peril (
      p_quote_id        gipi_quote_item.quote_id%TYPE,
      p_item_no         gipi_quote_item.item_no%TYPE 
   ) 
      RETURN BOOLEAN
   IS
      v_result   BOOLEAN := FALSE;
   BEGIN
      FOR a IN (SELECT peril_cd
                  FROM gipi_quote_itmperil
                 WHERE quote_id = p_quote_id AND item_no = p_item_no)
      LOOP
         v_result := TRUE;
         EXIT;
      END LOOP;

      RETURN v_result;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END quote_item_has_peril;
END Gipi_Quote_Item_Pkg;
/


