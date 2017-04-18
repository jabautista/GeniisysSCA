CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Par_Item_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WITEM
	*/
	PROCEDURE set_gipi_par_item (p_item		GIPI_WITEM%ROWTYPE)
	IS
	BEGIN
		MERGE INTO GIPI_WITEM
		USING dual ON (par_id = p_item.par_id
	                AND item_no = p_item.item_no)
		WHEN NOT MATCHED THEN
			INSERT (par_id,				item_no,			item_title,
					item_desc,			item_desc2,			currency_cd,
					currency_rt,		coverage_cd,		pack_line_cd,
					pack_subline_cd,	item_grp,			rec_flag,
					from_date,			TO_DATE)
			VALUES (p_item.par_id,			p_item.item_no,		p_item.item_title,
					p_item.item_desc,		p_item.item_desc2,	p_item.currency_cd,
					p_item.currency_rt,		p_item.coverage_cd,	p_item.pack_line_cd,
					p_item.pack_subline_cd,	p_item.item_grp,	p_item.rec_flag,
					p_item.from_date,		p_item.TO_DATE)
		WHEN MATCHED THEN
			UPDATE SET  item_title		= p_item.item_title,
						item_desc		= p_item.item_desc,
						item_desc2		= p_item.item_desc2,
						currency_cd		= p_item.currency_cd,
						currency_rt		= p_item.currency_rt,
						coverage_cd		= p_item.coverage_cd,
						pack_line_cd	= p_item.pack_line_cd,
						pack_subline_cd	= p_item.pack_subline_cd,
						item_grp		= p_item.item_grp,
						rec_flag		= p_item.rec_flag,
						from_date		= p_item.from_date,
						TO_DATE			= p_item.TO_DATE;
		COMMIT;
	END set_gipi_par_item;

	PROCEDURE pre_set_gipi_par_item (p_par_id	GIPI_WITEM.par_id%TYPE)
	IS
	BEGIN
		Gipis010_Delete_Discount(p_par_id);
	END pre_set_gipi_par_item;

	PROCEDURE del_gipi_par_item (
		p_par_id	GIPI_WITEM.par_id%TYPE,
		p_item_no	GIPI_WITEM.item_no%TYPE)
	IS
	BEGIN

		pre_del_gipi_par_item(p_par_id, p_item_no);

		DELETE
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id
		   AND item_no = p_item_no;

		DELETE
		  FROM GIPI_WVEHICLE
		 WHERE par_id = p_par_id
		   AND item_no = p_item_no;

		COMMIT;
	END del_gipi_par_item;

	PROCEDURE del_all_gipi_par_item (p_par_id		GIPI_WITEM.par_id%TYPE)
	IS
	BEGIN
		DELETE
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id;

		COMMIT;
	END del_all_gipi_par_item;

	PROCEDURE pre_del_gipi_par_item (
		p_par_id		GIPI_WITEM.par_id%TYPE,
		p_item_no	GIPI_WITEM.item_no%TYPE)
	IS
	BEGIN

		FOR D1 IN (SELECT  1
					 FROM  GIPI_WITMPERL
					WHERE  par_id  = p_par_id
					  AND  item_no = p_item_no)
		LOOP
			DELETE  GIPI_WITMPERL
			 WHERE  par_id  = p_par_id
			   AND  item_no = p_item_no;
			EXIT;
		END LOOP;

		FOR D2 IN (SELECT  1
					 FROM  GIPI_WPERIL_DISCOUNT
					WHERE  par_id  = p_par_id
					  AND  item_no = p_item_no)
		LOOP
			DELETE  GIPI_WPERIL_DISCOUNT
			 WHERE  par_id  = p_par_id
			   AND  item_no = p_item_no;
			EXIT;
		END LOOP;

		FOR D3 IN (SELECT  1
					 FROM  GIPI_WDEDUCTIBLES
					WHERE  par_id  = p_par_id
					  AND  item_no = p_item_no)
		LOOP
			DELETE  GIPI_WDEDUCTIBLES
			 WHERE  par_id  = p_par_id
			   AND  item_no = p_item_no;
			EXIT;
		END LOOP;

		FOR D3 IN (SELECT  1
					 FROM  GIPI_WMORTGAGEE
					WHERE  par_id  = p_par_id
					  AND  item_no = p_item_no)
		LOOP
			DELETE  GIPI_WMORTGAGEE
			 WHERE  par_id  = p_par_id
			   AND  item_no = p_item_no;
			EXIT;
		END LOOP;

		DELETE
		  FROM GIPI_WDEDUCTIBLES
		 WHERE PAR_ID = p_par_id
		   AND ITEM_NO = p_item_no;

		DELETE
		  FROM GIPI_WMCACC C
		 WHERE C.PAR_ID = p_par_id
		   AND C.ITEM_NO = p_item_no;

		DELETE
		  FROM GIPI_WVEHICLE G
		 WHERE G.PAR_ID = p_par_id
		   AND G.ITEM_NO = p_item_no;

	END pre_del_gipi_par_item;

	PROCEDURE post_del_gipi_par_item
	(	p_par_id 	GIPI_WITEM.par_id%TYPE,
		p_line_cd	GIPI_PARLIST.line_cd%TYPE,
		p_iss_cd	GIPI_PARLIST.iss_cd%TYPE)
	IS
		p_count_item     NUMBER:=0;
		p_count_peril    NUMBER:=0;
		CURSOR A IS
			SELECT item_no
			  FROM GIPI_WITEM
			 WHERE par_id   =  p_par_id;
		CURSOR B (p_item_no  NUMBER) IS
			SELECT DISTINCT item_no
			  FROM GIPI_WITMPERL
			 WHERE par_id   =  p_par_id
			   AND item_no  =  p_item_no;
	BEGIN
		FOR A1 IN A LOOP
			p_count_item  :=  p_count_item + 1;
			FOR B1 IN B (A1.item_no) LOOP
				p_count_peril := p_count_peril + 1;
			END LOOP;
		END LOOP;

		IF p_count_peril = p_count_item THEN
			UPDATE GIPI_PARLIST
			   SET par_status  =  5
			 WHERE par_id   =  p_par_id
			   AND line_cd  =  p_line_cd
			   AND iss_cd   =  p_iss_cd;
	   END IF;
	END post_del_gipi_par_item;
END Gipi_Par_Item_Pkg;
/


