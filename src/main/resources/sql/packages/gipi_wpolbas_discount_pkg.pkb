CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wpolbas_Discount_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.19.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WPOLBAS_DISCOUNT
	*/
	PROCEDURE del_gipi_wpolbas_discount (p_par_id 	GIPI_WPOLBAS_DISCOUNT.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WPOLBAS_DISCOUNT
		 WHERE par_id = p_par_id;
	END del_gipi_wpolbas_discount;

	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.02.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: policy discount/surcharge
	*/
	FUNCTION get_gipi_wpolbas_discount (p_par_id     GIPI_WPOLBAS_DISCOUNT.par_id%TYPE)
    RETURN gipi_wpolbas_discount_tab PIPELINED IS
       v_wpolbas_discount		    gipi_wpolbas_discount_type;
    BEGIN

		   FOR a IN (SELECT line_cd,	     subline_cd, 	   disc_rt,
	   	   	 				disc_amt,		 net_gross_tag,	   orig_prem_amt,
	 						SEQUENCE,		 remarks,		   net_prem_amt,
	 						surcharge_rt,	 surcharge_amt,	   par_id
	       	 	       FROM GIPI_WPOLBAS_DISCOUNT
				      WHERE par_id = p_par_id
				      ORDER BY SEQUENCE)
	   LOOP
	   	 v_wpolbas_discount.par_id  	  	  		:= a.par_id;
	     v_wpolbas_discount.line_cd  	  	  		:= a.line_cd;
		 v_wpolbas_discount.subline_cd    	 		:= a.subline_cd;
		 v_wpolbas_discount.disc_rt  				:= a.disc_rt;
		 v_wpolbas_discount.disc_amt  				:= a.disc_amt;
		 v_wpolbas_discount.net_gross_tag  			:= a.net_gross_tag;
		 v_wpolbas_discount.orig_prem_amt  			:= a.orig_prem_amt;
		 v_wpolbas_discount.SEQUENCE  				:= a.SEQUENCE;
		 v_wpolbas_discount.remarks  				:= a.remarks;
		 v_wpolbas_discount.net_prem_amt  			:= a.net_prem_amt;
		 v_wpolbas_discount.surcharge_rt  			:= a.surcharge_rt;
		 v_wpolbas_discount.surcharge_amt  			:= a.surcharge_amt;

		 PIPE ROW(v_wpolbas_discount);
	   END LOOP;

	  RETURN;
	END get_gipi_wpolbas_discount;

	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.02.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: policy discount/surcharge
	*/
	PROCEDURE set_gipi_wpolbas_discount (p_wpolbas_disc IN GIPI_WPOLBAS_DISCOUNT%ROWTYPE)
		 IS
	BEGIN
	   MERGE INTO GIPI_WPOLBAS_DISCOUNT
	   USING DUAL ON (par_id = p_wpolbas_disc.par_id AND
	 				  SEQUENCE = p_wpolbas_disc.SEQUENCE)
	   WHEN NOT MATCHED THEN
	   		INSERT (line_cd,	     subline_cd, 	   disc_rt,
	   	   	 		disc_amt,		 net_gross_tag,	   orig_prem_amt,
	 				SEQUENCE,		 remarks,		   net_prem_amt,
	 				surcharge_rt,	 surcharge_amt,	   last_update,
					par_id)
			VALUES (p_wpolbas_disc.line_cd,	     	 p_wpolbas_disc.subline_cd, 	   p_wpolbas_disc.disc_rt,
	   	   	 		p_wpolbas_disc.disc_amt,		 p_wpolbas_disc.net_gross_tag,	   p_wpolbas_disc.orig_prem_amt,
	 				p_wpolbas_disc.SEQUENCE,		 p_wpolbas_disc.remarks,		   p_wpolbas_disc.net_prem_amt,
	 				p_wpolbas_disc.surcharge_rt,	 p_wpolbas_disc.surcharge_amt,	   SYSDATE,
					p_wpolbas_disc.par_id)
	   WHEN MATCHED THEN
	     UPDATE SET
		 		line_cd 		= p_wpolbas_disc.line_cd,
				subline_cd 		= p_wpolbas_disc.subline_cd,
				disc_rt 		= p_wpolbas_disc.disc_rt,
	   	   	 	disc_amt 		= p_wpolbas_disc.disc_amt,
				net_gross_tag 	= p_wpolbas_disc.net_gross_tag,
				orig_prem_amt 	= p_wpolbas_disc.orig_prem_amt,
				remarks 		= p_wpolbas_disc.remarks,
				net_prem_amt 	= p_wpolbas_disc.net_prem_amt,
	 			surcharge_rt    = p_wpolbas_disc.surcharge_rt,
				surcharge_amt   = p_wpolbas_disc.surcharge_amt,
				last_update 	= SYSDATE;
	END;

	/*
	**  Created by		: Bryan Joseph Abuluyan
	**  Date Created 	: 11.11.2010
	**  Reference By 	: (GIPIS038 - Peril information)
	**  Description 	: deletes all discounts from policy to peril level for a certain PAR
	*/
	PROCEDURE delete_all_discounts(p_par_id	GIPI_WPOLBAS_DISCOUNT.par_id%TYPE)
	  IS
	BEGIN
	  GIPI_WPERIL_DISCOUNT_PKG.del_gipi_wperil_discount(p_par_id);
	  GIPI_WITEM_DISCOUNT_PKG.del_gipi_witem_discount(p_par_id);
	  GIPI_WPOLBAS_DISCOUNT_PKG.del_gipi_wpolbas_discount(p_par_id);
	END delete_all_discounts;

    FUNCTION validate_surcharge_amt(
        p_par_id	gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE
        ) RETURN VARCHAR2 IS
        v_msg   VARCHAR2(3200) := '';
    BEGIN
        FOR i IN (SELECT tsi_amt, prem_amt
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id
                     AND line_cd = p_line_cd)
        LOOP
            IF i.prem_amt > i.tsi_amt THEN
                v_msg := '1';
                RETURN v_msg;
            ELSIF i.prem_amt < 0 THEN
                v_msg := '2';
                RETURN v_msg;
            END IF;
        END LOOP;
    RETURN v_msg;
    END;

    FUNCTION validate_disc_surc_amt_item(
        p_par_id	gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE
        ) RETURN VARCHAR2 IS
        v_msg   VARCHAR2(3200) := '';
    BEGIN
        FOR i IN (SELECT tsi_amt, prem_amt
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id
                     AND line_cd = p_line_cd
                     AND item_no = p_item_no)
        LOOP
            IF i.prem_amt > i.tsi_amt THEN
                v_msg := '1';
                RETURN v_msg;
            ELSIF i.prem_amt < 0 THEN
                v_msg := '2';
                RETURN v_msg;
            END IF;
        END LOOP;
    RETURN v_msg;
    END;

    FUNCTION validate_disc_surc_amt_peril(
        p_par_id	gipi_witmperl.par_id%TYPE,
        p_line_cd   gipi_witmperl.line_cd%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE,
        p_peril_cd  gipi_witmperl.peril_cd%TYPE
        ) RETURN VARCHAR2 IS
        v_msg   VARCHAR2(3200) := '';
    BEGIN
        FOR i IN (SELECT tsi_amt, prem_amt
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id
                     AND line_cd = p_line_cd
                     AND item_no = p_item_no
                     AND peril_cd = p_peril_cd)
        LOOP
            IF i.prem_amt > i.tsi_amt THEN
                v_msg := '1';
                RETURN v_msg;
            ELSIF i.prem_amt < 0 THEN
                v_msg := '2';
                RETURN v_msg;
            END IF;
        END LOOP;
    RETURN v_msg;
    END;

END Gipi_Wpolbas_Discount_Pkg;
/


