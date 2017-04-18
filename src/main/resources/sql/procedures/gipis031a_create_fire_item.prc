DROP PROCEDURE CPI.GIPIS031A_CREATE_FIRE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031A_CREATE_FIRE_ITEM (
	p_par_id	IN GIPI_WITEM.par_id%TYPE,
	p_item_no	IN GIPI_WITEM.item_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for inserting records to GIPI_WFIREITM table
	*/
	v_eff_date           GIPI_POLBASIC.eff_date%TYPE;
	v_max_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE;
	v_max_endt_seq_no1   GIPI_POLBASIC.endt_seq_no%TYPE;
	
	CURSOR A IS
		SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM GIPI_POLBASIC a
		 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
			   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
			      FROM GIPI_WPOLBAS
				 WHERE par_id = p_par_id)
           AND a.pol_flag                IN ('1','2','3')
           AND EXISTS (SELECT '1'
                         FROM GIPI_FIREITEM b
                        WHERE b.item_no = p_item_no
                          AND b.policy_id = a.policy_id) 	 
      ORDER BY eff_date DESC;
	  
	CURSOR B (p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
		SELECT district_no, block_no, block_id, tariff_zone, tarf_cd, eq_zone, typhoon_zone, flood_zone
          FROM gipi_fireitem
         WHERE policy_id   =  p_policy_id
           AND item_no     =  p_item_no;
		   
	CURSOR D IS
		SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM GIPI_POLBASIC a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
			   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
			      FROM GIPI_WPOLBAS
				 WHERE par_id = p_par_id)
           AND a.pol_flag    IN( '1','2','3')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM GIPI_FIREITEM b
						WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id) 	 
           AND a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                  FROM GIPI_POLBASIC c
                                 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
									   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
										  FROM GIPI_WPOLBAS
										 WHERE par_id = p_par_id)
                                   AND pol_flag  IN( '1','2','3')
                                   AND NVL(c.back_stat,5) = 2
                                   AND EXISTS (SELECT '1'
                                                 FROM GIPI_FIREITEM d
                                                WHERE d.item_no = p_item_no
                                                  AND c.policy_id = d.policy_id)) 	                   
      ORDER BY   eff_date DESC;

	v_new_item   VARCHAR2(1) := 'Y'; 
    v_expired_sw   VARCHAR2(1) := 'N';
BEGIN
	FOR Z IN (
		SELECT MAX(endt_seq_no) endt_seq_no
		  FROM GIPI_POLBASIC a
		 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
			   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
				  FROM GIPI_WPOLBAS
				 WHERE par_id = p_par_id)
		   AND pol_flag  IN( '1','2','3')
		   AND EXISTS (SELECT '1'
						 FROM GIPI_FIREITEM b
						WHERE b.item_no = p_item_no
						  AND a.policy_id = b.policy_id))
	LOOP
		v_max_endt_seq_no := z.endt_seq_no;
		EXIT;
	END LOOP;
	
	FOR X IN (
		SELECT MAX(endt_seq_no) endt_seq_no
		  FROM GIPI_POLBASIC a
		 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
			   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
				  FROM GIPI_WPOLBAS
				 WHERE par_id = p_par_id)
		   AND pol_flag  IN( '1','2','3')
		   AND NVL(a.back_stat,5) = 2
		   AND EXISTS (SELECT '1'
						 FROM GIPI_FIREITEM b
						WHERE b.item_no = p_item_no
						  AND a.policy_id = b.policy_id))
	LOOP
		v_max_endt_seq_no1 := X.endt_seq_no;
		EXIT;
	END LOOP;
	
	IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                             	
		FOR D1 IN D LOOP
			FOR B1 IN B(D1.policy_id) LOOP
				IF v_eff_date  IS NULL THEN
					Gipi_Wfireitm_Pkg.set_gipi_wfireitm(
					    p_par_id,			p_item_no,					b1.district_no,	b1.eq_zone,
						b1.tarf_cd,			b1.block_no,				NULL,				NULL,
						NULL,				NULL,						b1.tariff_zone,		b1.typhoon_zone,
						NULL,				NULL,						NULL,				NULL,
						NULL,				NULL,						NULL,				NULL,
						NULL,				b1.flood_zone,				b1.block_id,		NULL);
				END IF;
				IF D1.eff_date > v_eff_date THEN
					Gipi_Wfireitm_Pkg.set_gipi_wfireitm(
					    p_par_id,			p_item_no,					b1.district_no,	b1.eq_zone,
						b1.tarf_cd,			b1.block_no,				NULL,				NULL,
						NULL,				NULL,						b1.tariff_zone,		b1.typhoon_zone,
						NULL,				NULL,						NULL,				NULL,
						NULL,				NULL,						NULL,				NULL,
						NULL,				b1.flood_zone,				b1.block_id,		NULL);
				END IF;
			END LOOP;
			EXIT;
		END LOOP;
	ELSE
		FOR A1 IN A LOOP     
			FOR B1 IN B(A1.policy_id) LOOP
				IF v_eff_date  IS NULL THEN
					v_eff_date  :=  A1.eff_date;
					Gipi_Wfireitm_Pkg.set_gipi_wfireitm(
					    p_par_id,			p_item_no,					b1.district_no,	b1.eq_zone,
						b1.tarf_cd,			b1.block_no,				NULL,				NULL,
						NULL,				NULL,						b1.tariff_zone,		b1.typhoon_zone,
						NULL,				NULL,						NULL,				NULL,
						NULL,				NULL,						NULL,				NULL,
						NULL,				b1.flood_zone,				b1.block_id,		NULL);
				END IF;
				IF A1.eff_date > v_eff_date THEN
					v_eff_date  :=  A1.eff_date;
					Gipi_Wfireitm_Pkg.set_gipi_wfireitm(
					    p_par_id,			p_item_no,					b1.district_no,	NULL,
						b1.tarf_cd,			b1.block_no,				NULL,				NULL,
						NULL,				NULL,						b1.tariff_zone,		NULL,
						NULL,				NULL,						NULL,				NULL,
						NULL,				NULL,						NULL,				NULL,
						NULL,				NULL,						b1.block_id,		NULL);
				END IF;
			END LOOP;     
			EXIT;
		END LOOP;  
	END IF;
END GIPIS031A_CREATE_FIRE_ITEM;
/


