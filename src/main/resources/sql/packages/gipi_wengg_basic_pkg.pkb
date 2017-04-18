CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wengg_Basic_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure DEL_GIPI_WENGG_BASIC (p_par_id IN GIPI_WENGG_BASIC.par_id%TYPE)
	IS
	BEGIN
		DELETE GIPI_WENGG_BASIC
		 WHERE par_id = p_par_id;
	END del_gipi_wengg_basic;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure inserts/updates record on	GIPI_WENGG_BASIC (complete columns)
	*/
	Procedure set_gipi_wengg_basic(
		 p_par_id 					IN GIPI_WENGG_BASIC.par_id%TYPE,
		 p_engg_basic_infonum		IN GIPI_WENGG_BASIC.engg_basic_infonum%TYPE,
		 p_contract_proj_buss_title	IN GIPI_WENGG_BASIC.contract_proj_buss_title%TYPE,
		 p_site_location 			IN GIPI_WENGG_BASIC.site_location%TYPE,
		 p_construct_start_date		IN GIPI_WENGG_BASIC.construct_start_date%TYPE,
		 p_construct_end_date		IN GIPI_WENGG_BASIC.construct_end_date%TYPE,
		 p_maintain_start_date		IN GIPI_WENGG_BASIC.maintain_start_date%TYPE,
		 p_maintain_end_date		IN GIPI_WENGG_BASIC.maintain_end_date%TYPE,
		 p_testing_start_date		IN GIPI_WENGG_BASIC.testing_start_date%TYPE,
		 p_testing_end_date			IN GIPI_WENGG_BASIC.testing_end_date%TYPE,
		 p_weeks_test				IN GIPI_WENGG_BASIC.weeks_test%TYPE,
		 p_time_excess				IN GIPI_WENGG_BASIC.time_excess%TYPE,
		 p_mbi_policy_no			IN GIPI_WENGG_BASIC.mbi_policy_no%TYPE)
	IS
	BEGIN
		MERGE INTO GIPI_WENGG_BASIC
		USING dual ON (par_id = p_par_id)
		WHEN NOT MATCHED THEN
			INSERT (
				   par_id, 	 	  			engg_basic_infonum, contract_proj_buss_title,	site_location,
		 		   construct_start_date, 	construct_end_date, maintain_start_date, 		maintain_end_date,
		 		   testing_start_date,		testing_end_date,	weeks_test, 				time_excess,
		 		   mbi_policy_no)
			VALUES (
				   p_par_id,	  			p_engg_basic_infonum,  p_contract_proj_buss_title,	p_site_location,
		 		   p_construct_start_date, 	p_construct_end_date,  p_maintain_start_date, 		p_maintain_end_date,
		 		   p_testing_start_date, 	p_testing_end_date, 	p_weeks_test, 				p_time_excess,
		 		   p_mbi_policy_no)
		WHEN MATCHED THEN
			UPDATE SET
				   engg_basic_infonum		=	p_engg_basic_infonum,
				   contract_proj_buss_title	=	p_contract_proj_buss_title,
		 		   site_location			=  p_site_location,
				   construct_start_date		=  p_construct_start_date,
				   construct_end_date		=  p_construct_end_date,
				   maintain_start_date		=  p_maintain_start_date,
		 		   maintain_end_date		=  p_maintain_end_date,
				   testing_start_date		=  p_testing_start_date,
				   testing_end_date			=  p_testing_end_date,
				   weeks_test				=  p_weeks_test,
		 		   time_excess				=  p_time_excess,
				   mbi_policy_no			=  p_mbi_policy_no;
	END set_gipi_wengg_basic;

    /*
	**  Created by		: D. Alcantara
	**  Date Created 	: 11.02.2010
	**  Reference By 	: (GIPIS045 - Engineering Additional Information)
	*/
    FUNCTION get_gipi_wengg_basic (p_par_id IN GIPI_WENGG_BASIC.par_id%TYPE)
        RETURN gipi_wengg_basic_list_tab PIPELINED IS

        v_wengg_basic   gipi_wengg_basic_list_type;
    BEGIN
        FOR i IN(
            SELECT *
            FROM gipi_wengg_basic
             WHERE par_id = p_par_id)
        LOOP
            v_wengg_basic.par_id                   := i.par_id;
            v_wengg_basic.engg_basic_infonum       := i.engg_basic_infonum;
            v_wengg_basic.contract_proj_buss_title := i.contract_proj_buss_title;
            v_wengg_basic.site_location            := i.site_location;
            v_wengg_basic.construct_start_date      := i.construct_start_date;
            v_wengg_basic.construct_end_date        := i.construct_end_date;
            v_wengg_basic.maintain_start_date      := i.maintain_start_date;
            v_wengg_basic.maintain_end_date        := i.maintain_end_date;
            v_wengg_basic.testing_start_date       := i.testing_start_date;
            v_wengg_basic.testing_end_date         := i.testing_end_date;
            v_wengg_basic.weeks_test               := i.weeks_test;
            v_wengg_basic.time_excess              := i.time_excess;
            v_wengg_basic.mbi_policy_no            := i.mbi_policy_no;
            PIPE ROW(v_wengg_basic);
        END LOOP;

        RETURN;
    END get_gipi_wengg_basic;
END Gipi_Wengg_Basic_Pkg;
/


