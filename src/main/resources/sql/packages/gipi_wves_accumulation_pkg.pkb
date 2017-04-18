CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wves_Accumulation_Pkg AS

	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 04.19.2010
	**  Reference By 	: (GIPIS006- Marine Cargo Item Info)
	**  Description 	: Constains delete procedure on gipi_wves_accumulation based on par_id, and item_no
	*/
	Procedure del_gipi_wves_accumulation (
		p_par_id IN	gipi_wves_accumulation.par_id%TYPE,
  		p_item_no IN gipi_wves_accumulation.item_no%TYPE)
		IS
	BEGIN
		DELETE  GIPI_WVES_ACCUMULATION
		 WHERE  par_id = p_par_id
		   AND  item_no = p_item_no;
	END;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure del_gipi_wves_accumulation (p_par_id IN gipi_wves_accumulation.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM gipi_wves_accumulation
		 WHERE par_id = p_par_id;
	END del_gipi_wves_accumulation;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.11.2011
	**  Reference By 	: (GIPIS006 - Endt Basic Information)
	**  Description 	: Retrieves all records from gipi_wves_accumulation based on the given par_id
	*/
	FUNCTION get_gipi_wves_accumulation (p_par_id IN gipi_wves_accumulation.par_id%TYPE)
	RETURN gipi_wves_accumulation_tab PIPELINED
	IS
		v_gipi_wves_acc gipi_wves_accumulation_type;
	BEGIN
		FOR i IN (
			SELECT a.vessel_cd, a.par_id, 	a.item_no, 	a.eta,
				   a.etd,		a.tsi_amt,	a.rec_flag,	a.eff_date
			  FROM gipi_wves_accumulation a
			 WHERE a.par_id = p_par_id)
		LOOP
			v_gipi_wves_acc.vessel_cd 	:= i.vessel_cd;
            v_gipi_wves_acc.par_id        := i.par_id;
            v_gipi_wves_acc.item_no        := i.item_no;
            v_gipi_wves_acc.eta            := i.eta;
            v_gipi_wves_acc.etd            := i.etd;
            v_gipi_wves_acc.tsi_amt        := i.tsi_amt;
            v_gipi_wves_acc.rec_flag    := i.rec_flag;
            v_gipi_wves_acc.eff_date    := i.eff_date;

            PIPE ROW(v_gipi_wves_acc);
        END LOOP;

        RETURN;
    END get_gipi_wves_accumulation;
END Gipi_Wves_Accumulation_Pkg;
/


