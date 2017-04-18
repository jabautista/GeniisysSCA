CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Winvperl_Pkg AS

	FUNCTION get_gipi_winvperl (
		p_par_id		GIPI_WINVPERL.par_id%TYPE,
		p_item_grp		GIPI_WINVPERL.item_grp%TYPE,
		p_line_cd		GIPI_WITEM.pack_line_cd%TYPE)
	RETURN gipi_winvperl_tab PIPELINED IS

  	v_winvperl		gipi_winvperl_type;

	BEGIN
		FOR i IN (
			SELECT distinct a.peril_cd, c.peril_name, a.par_id, a.item_grp, a.takeup_seq_no, a.tsi_amt, a.prem_amt
			  FROM GIPI_WINVPERL a
				   ,GIPI_WITEM b
				   ,GIIS_PERIL c
			 WHERE a.par_id = p_par_id
			   AND a.item_grp = p_item_grp
			   AND a.par_id = b.par_id
			   AND a.peril_cd = c.peril_cd
			   --AND b.pack_line_cd  = c.line_cd) 01/29/2010comment by cris replaced with
			   AND c.line_cd = p_line_cd
			 ORDER BY a.peril_cd) --04.21.10 added by emman
		LOOP
			v_winvperl.peril_cd			:= i.peril_cd;
			v_winvperl.peril_name		:= i.peril_name;
			v_winvperl.par_id			:= i.par_id;
			v_winvperl.item_grp			:= i.item_grp;
			v_winvperl.takeup_seq_no	:= i.takeup_seq_no;
			v_winvperl.tsi_amt			:= i.tsi_amt;
			v_winvperl.prem_amt			:= i.prem_amt;
		PIPE ROW(v_winvperl);
		END LOOP;
		RETURN;
	END get_gipi_winvperl;

	FUNCTION get_gipi_winvperl2 (
		p_par_id		GIPI_WINVPERL.par_id%TYPE,
		p_line_cd		GIPI_WITEM.pack_line_cd%TYPE)
	RETURN gipi_winvperl_tab PIPELINED IS

  	v_winvperl		gipi_winvperl_type;

	BEGIN
		FOR i IN (
			SELECT distinct a.peril_cd, c.peril_name, a.par_id, a.item_grp, a.takeup_seq_no, a.tsi_amt, a.prem_amt
			  FROM GIPI_WINVPERL a
				   ,GIPI_WITEM b
				   ,GIIS_PERIL c
			 WHERE a.par_id = p_par_id
			   AND a.par_id = b.par_id
			   AND a.peril_cd = c.peril_cd
			   AND c.line_cd = p_line_cd
			 ORDER BY a.peril_cd)
		LOOP
			v_winvperl.peril_cd			:= i.peril_cd;
			v_winvperl.peril_name		:= i.peril_name;
			v_winvperl.par_id			:= i.par_id;
			v_winvperl.item_grp			:= i.item_grp;
			v_winvperl.takeup_seq_no	:= i.takeup_seq_no;
			v_winvperl.tsi_amt			:= i.tsi_amt;
			v_winvperl.prem_amt			:= i.prem_amt;
		PIPE ROW(v_winvperl);
		END LOOP;
		RETURN;
	END get_gipi_winvperl2;

	FUNCTION get_distinct_gipi_winvperl (p_par_id	GIPI_WINVPERL.par_id%TYPE)
	RETURN gipi_winvperl_tab PIPELINED
	IS

	v_winvperl	gipi_winvperl_type;

	BEGIN
		FOR i IN (
			SELECT DISTINCT
				   a.par_id,          a.item_grp,
				   a.takeup_seq_no
			  FROM GIPI_WINVPERL    a
			 WHERE a.par_id   = p_par_id)
		LOOP
			v_winvperl.par_id			:= i.par_id;
			v_winvperl.item_grp			:= i.item_grp;
			v_winvperl.takeup_seq_no	:= i.takeup_seq_no;

		PIPE ROW(v_winvperl);
		END LOOP;
		RETURN;
	END get_distinct_gipi_winvperl;

	/*
	**  Modified by		: Mark JM
	**  Date Created 	: 02.11.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete record by supplying the par_id only
	*/
	PROCEDURE del_gipi_winvperl_1(p_par_id	GIPI_WINVPERL.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WINVPERL
		 WHERE par_id = p_par_id;

	END del_gipi_winvperl_1;

    /*
    **  Created by		: Veronica V. Raymundo
    **  Date Created 	: 05.03.2011
    **  Reference By 	: (GIPIS154 - Lead Policy Information)
    **  Description 	: Get tsi_amt and prem_amt in gipi_winvperl
    **
    */

    PROCEDURE get_prem_tsi_amt
        (p_par_id    IN     GIPI_WINVPERL.par_id%TYPE,
         p_item_grp  IN     GIPI_WINVPERL.item_grp%TYPE,
         p_peril_cd  IN     GIPI_WINVPERL.peril_cd%TYPE,
         p_tsi_amt   OUT    GIPI_WINVPERL.tsi_amt%TYPE,
         p_prem_amt  OUT    GIPI_WINVPERL.prem_amt%TYPE)

    IS

    BEGIN
        FOR i IN(SELECT tsi_amt, prem_amt
                 FROM GIPI_WINVPERL
                 WHERE par_id = p_par_id
                 AND item_grp = p_item_grp
                 AND peril_cd = p_peril_cd )

        LOOP
            p_tsi_amt  := i.tsi_amt;
            p_prem_amt := i.prem_amt;
            RETURN;
        END LOOP;

    END;

END Gipi_Winvperl_Pkg;
/


