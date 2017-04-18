DROP FUNCTION CPI.CHECK_PERIL_COMM_RATE;

CREATE OR REPLACE FUNCTION CPI.check_peril_comm_rate(p_intrmdry_intm_no  giis_intermediary.intm_no%type,
		  		p_par_id gipi_wpolbas.par_id%type,
				p_item_grp gipi_winvperl.item_grp%type,
				p_takeup_seq_no gipi_winvperl.takeup_seq_no%type,
				p_line_cd giis_intm_special_rate.line_cd%type,
				p_iss_cd giis_intm_special_rate.iss_cd%type,
				p_nbt_intm_type giis_intmdry_type_rt.intm_type%type)
RETURN VARCHAR2
AS
  v_missing_perils   VARCHAR2(200);
BEGIN
   /*
   	 emman 03.15.10
	 added - check_peril_comm_rate
	 GIPIS085
   */

   DECLARE
      p_peril_name   giis_peril.peril_name%TYPE;
      p_dummy        NUMBER;
      p_sp_rt        VARCHAR2 (1);
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE;
      p_peril_list   VARCHAR2 (200)                 := NULL;
      p_peril        giis_peril.peril_name%TYPE;
   BEGIN
      v_missing_perils := NULL;

	BEGIN
      SELECT special_rate
        INTO p_sp_rt
        FROM giis_intermediary
       WHERE intm_no = p_intrmdry_intm_no;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
				p_sp_rt := 'N';
			END;

      SELECT subline_cd
        INTO p_subline_cd
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

      BEGIN
            FOR c1 IN  (SELECT peril_cd
                          FROM gipi_winvperl
                         WHERE par_id = p_intrmdry_intm_no
                           AND item_grp = p_item_grp
                           AND takeup_seq_no = p_takeup_seq_no)
            LOOP
               BEGIN
                  IF p_sp_rt = 'Y' THEN
                     BEGIN --3
                        SELECT rate
                          INTO p_dummy
                          FROM giis_intm_special_rate
                         WHERE intm_no = p_intrmdry_intm_no
                           AND line_cd = p_line_cd
                           AND iss_cd = p_iss_cd
                           AND peril_cd = c1.peril_cd
                           AND subline_cd = p_subline_cd;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           BEGIN --2
                              SELECT comm_rate
                                INTO p_dummy
                                FROM giis_intmdry_type_rt
                               WHERE intm_type = p_nbt_intm_type
                                 AND line_cd = p_line_cd
                                 AND iss_cd = p_iss_cd
                                 AND peril_cd = c1.peril_cd
                                 AND subline_cd = p_subline_cd;
                           EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                 BEGIN --1
                                    SELECT peril_name
                                      INTO p_peril
                                      FROM giis_peril
                                     WHERE peril_cd = c1.peril_cd
                                       AND line_cd = p_line_cd;

                                    IF p_peril_list IS NOT NULL THEN
                                       p_peril_list :=
                                                p_peril_list
                                             || ', '
                                             || p_peril;
                                    ELSE
                                       p_peril_list := p_peril;
                                    END IF;
                                 EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                       NULL;
                                 END; --1
                           END; --2
                     END; --3
                  ELSE --p_sp_rt = 'Y' THEN
                     BEGIN --2
                        SELECT comm_rate
                          INTO p_dummy
                          FROM giis_intmdry_type_rt
                         WHERE intm_type = p_nbt_intm_type
                           AND line_cd = p_line_cd
                           AND iss_cd = p_iss_cd
                           AND peril_cd = c1.peril_cd
                           AND subline_cd = p_subline_cd;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           BEGIN --1
                              SELECT peril_name
                                INTO p_peril
                                FROM giis_peril
                               WHERE peril_cd = c1.peril_cd
                                 AND line_cd = p_line_cd;

                              IF p_peril_list IS NOT NULL THEN
                                 p_peril_list :=
                                                p_peril_list
                                             || ', '
                                             || p_peril;
                              ELSE
                                 p_peril_list := p_peril;
                              END IF;
                           EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                 NULL;
                           END; --1
                     END; --2
                  END IF; --p_sp_rt = 'Y' THEN
               END; --loop begin
            END LOOP;

			v_missing_perils := p_peril_list;
      END;
   END;
   
   RETURN v_missing_perils;
END;
/


