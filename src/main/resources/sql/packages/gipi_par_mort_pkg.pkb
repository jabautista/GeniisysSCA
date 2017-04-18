CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Par_Mort_Pkg AS

	FUNCTION get_gipi_par_mort (p_par_id   GIPI_WMORTGAGEE.par_id%TYPE)
	RETURN gipi_par_mort_tab PIPELINED  IS

	v_gipi_par_mort      gipi_par_mort_type;

	BEGIN
		FOR i IN (
			SELECT A.par_id,    A.iss_cd,        A.item_no,        A.mortg_cd,       b.mortg_name,       A.amount
			  FROM GIPI_WMORTGAGEE A,
				   GIIS_MORTGAGEE b
			 WHERE A.mortg_cd = b.mortg_cd
			   AND a.iss_cd   = b.iss_cd
			   AND par_id = p_par_id)
		LOOP
			v_gipi_par_mort.par_id         := i.par_id;
			v_gipi_par_mort.iss_cd           := i.iss_cd;
			v_gipi_par_mort.item_no          := i.item_no;
			v_gipi_par_mort.mortg_cd         := i.mortg_cd;
			v_gipi_par_mort.mortg_name       := i.mortg_name;
			v_gipi_par_mort.amount           := i.amount;
			PIPE ROW (v_gipi_par_mort);
		END LOOP;
		RETURN;
	END get_gipi_par_mort;

	PROCEDURE set_gipi_par_mort(p_gipi_par_mort   IN       GIPI_WMORTGAGEE%ROWTYPE)
	IS
	BEGIN
		MERGE INTO GIPI_WMORTGAGEE
		USING dual ON (par_id = p_gipi_par_mort.par_id
					AND item_no = p_gipi_par_mort.item_no
					AND mortg_cd = p_gipi_par_mort.mortg_cd)
		WHEN NOT MATCHED THEN
			INSERT (par_id,						iss_cd,						item_no,						mortg_cd,
					amount,						remarks,					last_update,					user_id   )
			VALUES (p_gipi_par_mort.par_id,		p_gipi_par_mort.iss_cd,		p_gipi_par_mort.item_no,		p_gipi_par_mort.mortg_cd,
					p_gipi_par_mort.amount,		p_gipi_par_mort.remarks,	p_gipi_par_mort.last_update,	p_gipi_par_mort.user_id  )
		WHEN MATCHED THEN
			UPDATE SET  iss_cd		   = p_gipi_par_mort.iss_cd,
						amount		   = p_gipi_par_mort.amount,
						remarks	   = p_gipi_par_mort.remarks,
						last_update   = p_gipi_par_mort.last_update,
						user_id       = p_gipi_par_mort.user_id;
		COMMIT;
	END set_gipi_par_mort;

	PROCEDURE del_gipi_par_mort_item (
		p_par_id		GIPI_WMORTGAGEE.par_id%TYPE,
		p_item_no		GIPI_WMORTGAGEE.item_no%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WMORTGAGEE
		 WHERE par_id = p_par_id
		   AND item_no  = p_item_no;
		COMMIT;
	END del_gipi_par_mort_item;

	PROCEDURE del_gipi_par_mort (p_par_id 	GIPI_WMORTGAGEE.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WMORTGAGEE
		 WHERE par_id = p_par_id;
		COMMIT;
	END del_gipi_par_mort;

END Gipi_Par_Mort_Pkg;
/


