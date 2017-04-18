CREATE OR REPLACE PROCEDURE CPI.GIPIS085_PACK_DEFAULT_INTRMDRY (
	p_pack_par_id IN gipi_wpolbas.par_id%TYPE,
	p_intm_no OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE,
	p_dsp_intm_name OUT giis_intermediary.intm_name%TYPE,
	p_parent_intm_no OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE)
AS
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.29.2011
	**  Reference By 	: (GIPIS085 - Invoice Commission)
	**  Description 	: Retrieves the default intm for package par
	*/
BEGIN
	DECLARE
		v_intm_no gipi_wcomm_invoices.intrmdry_intm_no%TYPE;
		v_count NUMBER := 0;
		v_par_type gipi_parlist.par_type%TYPE;
	BEGIN
		FOR i IN (
			SELECT par_type
			  FROM gipi_parlist
			 WHERE pack_par_id = p_pack_par_id)
		LOOP
			v_par_type := i.par_type;
		END LOOP;
		FOR rec IN (
			SELECT assd_no, line_cd, pol_flag
			  FROM gipi_wpolbas
			 WHERE pack_par_id = p_pack_par_id)
		LOOP
			IF v_par_type = 'P' THEN
				IF rec.pol_flag  = 2 THEN
					FOR intm IN (
						SELECT a.intrmdry_intm_no intm_no, d.intm_name,d.parent_intm_no
						  FROM gipi_comm_invoice a, 
							   gipi_polbasic c, giis_intermediary d,
							   gipi_wpolnrep b
						 WHERE 1 = 1
						   AND b.par_id IN (SELECT DISTINCT par_id
								 	   			   	   FROM gipi_parlist b240
													  WHERE b240.pack_par_id = p_pack_par_id)
						   AND b.old_policy_id = c.policy_id
						   AND c.policy_id = a.policy_id
						   AND a.intrmdry_intm_no = d.intm_no)
					LOOP
						v_count := v_count + 1;
						IF v_count = 1 THEN
							p_intm_no := intm.intm_no;
							p_dsp_intm_name := intm.intm_name;
							p_parent_intm_no := intm.parent_intm_no;
						END IF;
					END LOOP;
				ELSE
					/* benjo 09.07.2016 SR-5604 */
                    /*FOR intm IN (
						SELECT a.intm_no,b.intm_name,b.parent_intm_no 
						  FROM giis_assured_intm a,giis_intermediary b
						 WHERE a.intm_no = b.intm_no 
						   AND assd_no = rec.assd_no
						   AND line_cd = rec.line_cd)
					LOOP
						v_count := v_count + 1;
						IF v_count = 1 THEN
							p_intm_no := intm.intm_no;
							p_dsp_intm_name := intm.intm_name;
							p_parent_intm_no := intm.parent_intm_no;
						END IF;
					END LOOP;*/
                    FOR gpp IN (SELECT assd_no, line_cd
                                  FROM gipi_pack_parlist
                                 WHERE pack_par_id = p_pack_par_id)
                    LOOP
                        FOR intm IN (SELECT a.intm_no, b.intm_name, b.parent_intm_no
                                      FROM giis_assured_intm a,giis_intermediary b
                                     WHERE a.intm_no = b.intm_no
                                       AND assd_no = gpp.assd_no 
                                       AND line_cd = gpp.line_cd)
                        LOOP
                            v_count := v_count + 1;
                            IF v_count = 1 THEN
                                p_intm_no := intm.intm_no;
                                p_dsp_intm_name := intm.intm_name;
                                p_parent_intm_no := intm.parent_intm_no;
                            END IF;
                        END LOOP;
                    END LOOP;
				END IF;				
			ELSE
				FOR intm IN (
					SELECT a.intrmdry_intm_no, d.intm_name,d.parent_intm_no
					  FROM gipi_comm_invoice a, 
						   gipi_wpolbas b, gipi_polbasic c, giis_intermediary d
					 WHERE b.par_id IN (SELECT DISTINCT par_id
					 	   			   	  FROM gipi_parlist b240
										 WHERE b240.pack_par_id = p_pack_par_id) 
					   AND a.intrmdry_intm_no = d.intm_no
					   AND b.line_cd = rec.line_cd 
					   AND b.subline_cd = c.subline_cd 
					   AND b.iss_cd = c.iss_cd 
					   AND b.issue_yy = c.issue_yy 
					   AND b.pol_seq_no = c.pol_seq_no
					   AND b.renew_no = c.renew_no 
					   AND c.policy_id = a.policy_id)
				LOOP
					v_count := v_count + 1;
						IF v_count = 1 THEN
							p_intm_no := intm.intrmdry_intm_no;
							p_dsp_intm_name := intm.intm_name;
							p_parent_intm_no := intm.parent_intm_no;
						END IF;
				END LOOP;
			END IF;
		END LOOP;
	END;
END GIPIS085_PACK_DEFAULT_INTRMDRY;
/


