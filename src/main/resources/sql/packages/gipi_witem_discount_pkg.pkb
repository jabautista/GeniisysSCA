CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Witem_Discount_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.19.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WITEM_DISCOUNT
	*/
	PROCEDURE del_gipi_witem_discount (p_par_id 	GIPI_WITEM_DISCOUNT.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WITEM_DISCOUNT
		 WHERE par_id = p_par_id;
	END del_gipi_witem_discount;

	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.02.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: item discount/surcharge
	*/
	FUNCTION get_gipi_witem_discount (p_par_id     GIPI_WITEM_DISCOUNT.par_id%TYPE)
    RETURN gipi_witem_discount_tab PIPELINED IS
       v_witem_discount		    gipi_witem_discount_type;
    BEGIN

		   FOR a IN (SELECT a.line_cd,	     a.subline_cd, 	   a.disc_rt,
	   	   	 				a.disc_amt,		 a.net_gross_tag,	   a.orig_prem_amt,
	 						a.SEQUENCE,		 a.remarks,		   a.net_prem_amt,
	 						a.surcharge_rt,	 a.surcharge_amt,	   a.par_id,
							a.item_no, 		 b.item_title
	       	 	       FROM GIPI_WITEM_DISCOUNT a, GIPI_WITEM b
				      WHERE a.par_id = p_par_id
					    AND b.par_id = a.par_id
					    AND b.item_no = a.item_no
				      ORDER BY SEQUENCE)
	   LOOP
	   	 v_witem_discount.par_id  	  	  			:= a.par_id;
	     v_witem_discount.line_cd  	  	  			:= a.line_cd;
		 v_witem_discount.item_no	  	  			:= a.item_no;
		 v_witem_discount.item_title                    := a.item_title;
         v_witem_discount.subline_cd                 := a.subline_cd;
         v_witem_discount.disc_rt                      := a.disc_rt;
         v_witem_discount.disc_amt                  := a.disc_amt;
         v_witem_discount.net_gross_tag              := a.net_gross_tag;
         v_witem_discount.orig_prem_amt              := a.orig_prem_amt;
         v_witem_discount.SEQUENCE                  := a.SEQUENCE;
         v_witem_discount.remarks                      := a.remarks;
         v_witem_discount.net_prem_amt              := a.net_prem_amt;
         v_witem_discount.surcharge_rt              := a.surcharge_rt;
         v_witem_discount.surcharge_amt              := a.surcharge_amt;

         PIPE ROW(v_witem_discount);
       END LOOP;

      RETURN;
    END get_gipi_witem_discount;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 03.02.2010
    **  Reference By     : (GIPIS143 - Discount/Surcharge)
    **  Description     : item discount/surcharge
    */
    PROCEDURE set_gipi_witem_discount (p_witem_disc IN GIPI_WITEM_DISCOUNT%ROWTYPE)
         IS
    BEGIN
       MERGE INTO GIPI_WITEM_DISCOUNT
       USING DUAL ON (par_id = p_witem_disc.par_id AND
                      SEQUENCE = p_witem_disc.SEQUENCE AND
                      item_no = p_witem_disc.item_no)
       WHEN NOT MATCHED THEN
            INSERT (line_cd,         subline_cd,        disc_rt,
                    disc_amt,         net_gross_tag,       orig_prem_amt,
                    SEQUENCE,         remarks,           net_prem_amt,
                    surcharge_rt,     surcharge_amt,       last_update,
                    par_id,             item_no)
            VALUES (p_witem_disc.line_cd,        p_witem_disc.subline_cd,          p_witem_disc.disc_rt,
                    p_witem_disc.disc_amt,       p_witem_disc.net_gross_tag,       p_witem_disc.orig_prem_amt,
                    p_witem_disc.SEQUENCE,       p_witem_disc.remarks,             p_witem_disc.net_prem_amt,
                    p_witem_disc.surcharge_rt,   p_witem_disc.surcharge_amt,       SYSDATE,
                    p_witem_disc.par_id,         p_witem_disc.item_no)
       WHEN MATCHED THEN
         UPDATE SET
                line_cd         = p_witem_disc.line_cd,
                subline_cd      = p_witem_disc.subline_cd,
                disc_rt         = p_witem_disc.disc_rt,
                disc_amt        = p_witem_disc.disc_amt,
                net_gross_tag   = p_witem_disc.net_gross_tag,
                orig_prem_amt   = p_witem_disc.orig_prem_amt,
                remarks         = p_witem_disc.remarks,
                net_prem_amt    = p_witem_disc.net_prem_amt,
                surcharge_rt    = p_witem_disc.surcharge_rt,
                surcharge_amt   = p_witem_disc.surcharge_amt,
                last_update     = SYSDATE;
    END;

  -- adapted from DELETE_OTHER_DISCOUNT in GIPIS038 (BRY 03.11.2009)
  PROCEDURE delete_other_discount(p_par_id         gipi_witem.par_id%TYPE,
                                    p_item_no     gipi_witem.item_no%TYPE)
    IS
  BEGIN
    FOR A IN(SELECT disc_amt, item_no, peril_cd,
                  orig_peril_ann_prem_amt peril_prem,
                  orig_item_ann_prem_amt item_prem,
                  orig_pol_ann_prem_amt pol_prem
             FROM gipi_wperil_discount
            WHERE par_id   = p_par_id
              AND item_no  = p_item_no) -- changed from "AND item_no != p_item_no"
    LOOP
      UPDATE gipi_witem
         SET prem_amt     = prem_amt + A.disc_amt,
             ann_prem_amt = NVL(A.item_prem,ann_prem_amt),
             discount_sw  = 'N'
       WHERE par_id   = p_par_id
         AND item_no  = A.item_no;
      UPDATE gipi_witmperl
         SET prem_amt     = prem_amt + A.disc_amt,
             ann_prem_amt = NVL(A.peril_prem,ann_prem_amt),
             discount_sw  = 'N'
       WHERE par_id   = p_par_id
         AND item_no  = A.item_no
         AND peril_cd = A.peril_cd;
    END LOOP;

    GIPI_WPOLBAS_DISCOUNT_PKG.delete_all_discounts(p_par_id);
  END;

END Gipi_Witem_Discount_Pkg;
/


