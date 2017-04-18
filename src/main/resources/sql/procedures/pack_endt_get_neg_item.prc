DROP PROCEDURE CPI.PACK_ENDT_GET_NEG_ITEM;

CREATE OR REPLACE PROCEDURE CPI.PACK_ENDT_GET_NEG_ITEM (
	p_par_id	IN GIPI_WITEM.par_id%TYPE,
	p_item_no 	IN GIPI_WITEM.item_no%TYPE,
	p_line_cd	IN GIPI_WPOLBAS.line_cd%TYPE)
AS
	/*
	**  Created by		: Emman
	**  Date Created 	: 03.10.2011
	**  Reference By 	: (GIPIS031A - Pack Endt Basic Information)
	**  Description 	: This procedure get the latest info of item with consideration
	**     				: of backward endt. and insert it in table gipi_witem (Original Description)
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
           AND a.pol_flag IN ('1','2','3','X')
           AND EXISTS (SELECT '1'
                         FROM GIPI_ITEM b
                        WHERE b.item_no = p_item_no
                          AND b.policy_id = a.policy_id) 	 
      ORDER BY eff_date DESC;
	  
	CURSOR B (p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
	  SELECT currency_cd, currency_rt, item_title, ann_tsi_amt, ann_prem_amt, coverage_cd,
             group_cd, pack_line_cd, pack_subline_cd, item_grp
        FROM gipi_item
       WHERE policy_id   =  p_policy_id
         AND item_no     =  p_item_no;

	CURSOR D IS
		SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM GIPI_POLBASIC a
		 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
			   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
			      FROM GIPI_WPOLBAS
				 WHERE par_id = p_par_id)
           AND a.pol_flag    IN( '1','2','3','X')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM GIPI_ITEM b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id) 	 
           AND a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                  FROM GIPI_POLBASIC c
                                 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
									   (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
										  FROM GIPI_WPOLBAS
										 WHERE par_id = p_par_id)
                                   AND pol_flag  IN( '1','2','3','X')
                                   AND NVL(c.back_stat,5) = 2
                                   AND EXISTS (SELECT '1'
                                                 FROM GIPI_ITEM d
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
		   AND pol_flag  IN( '1','2','3','X')
		   AND EXISTS (SELECT '1'
						 FROM GIPI_ITEM b
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
		   AND pol_flag  IN( '1','2','3','X')
		   AND NVL(a.back_stat,5) = 2
		   AND EXISTS (SELECT '1'
						 FROM GIPI_ITEM b
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
					Gipi_Witem_Pkg.set_gipi_witem_2(
						p_par_id,		p_item_no,		   b1.item_title,	b1.item_grp,
						NULL,			NULL,			   NULL,			NULL,
						0,				0,				   NULL,			b1.currency_cd,
						b1.currency_rt,	b1.group_cd,	   NULL,			NULL,
						b1.pack_line_cd,b1.pack_subline_cd,NULL,			b1.coverage_cd,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL);
					--GIPIS031A_CREATE_FIRE_ITEM(p_par_id, p_item_no); --removed by robert GENQA 4844 09.02.15
					GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id, p_item_no, b1.pack_line_cd); --added by robert GENQA 4844 09.02.15
				END IF;
				
				IF D1.eff_date > v_eff_date THEN
					Gipi_Witem_Pkg.set_gipi_witem_2(
						p_par_id,		p_item_no,		   b1.item_title,	b1.item_grp,
						NULL,			NULL,			   NULL,			NULL,
						0,				0,				   NULL,			b1.currency_cd,
						b1.currency_rt,	b1.group_cd,	   NULL,			NULL,
						b1.pack_line_cd,b1.pack_subline_cd,NULL,			b1.coverage_cd,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL);
					--GIPIS031A_CREATE_FIRE_ITEM(p_par_id, p_item_no); --removed by robert GENQA 4844 09.02.15
					GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id, p_item_no, b1.pack_line_cd); --added by robert GENQA 4844 09.02.15
				END IF;
			END LOOP;
			EXIT;
		END LOOP;
	ELSE
		FOR A1 IN A LOOP     
			FOR B1 IN B(A1.policy_id) LOOP
				IF v_eff_date  IS NULL THEN
					v_eff_date  :=  A1.eff_date;
					Gipi_Witem_Pkg.set_gipi_witem_2(
						p_par_id,		p_item_no,		   b1.item_title,	b1.item_grp,
						NULL,			NULL,			   NULL,			NULL,
						0,				0,				   NULL,			b1.currency_cd,
						b1.currency_rt,	b1.group_cd,	   NULL,			NULL,
						b1.pack_line_cd,b1.pack_subline_cd,NULL,			b1.coverage_cd,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL);
					--GIPIS031A_CREATE_FIRE_ITEM(p_par_id, p_item_no); --removed by robert GENQA 4844 09.02.15
					GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id, p_item_no, b1.pack_line_cd); --added by robert GENQA 4844 09.02.15
				END IF;
				IF A1.eff_date > v_eff_date THEN
					v_eff_date  :=  A1.eff_date;
					Gipi_Witem_Pkg.set_gipi_witem_2(
						p_par_id,		p_item_no,		   b1.item_title,	b1.item_grp,
						NULL,			NULL,			   NULL,			NULL,
						0,				0,				   NULL,			b1.currency_cd,
						b1.currency_rt,	b1.group_cd,	   NULL,			NULL,
						b1.pack_line_cd,b1.pack_subline_cd,NULL,			b1.coverage_cd,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL,			NULL,
						NULL,			NULL,			   NULL);
					--GIPIS031A_CREATE_FIRE_ITEM(p_par_id, p_item_no); --removed by robert GENQA 4844 09.02.15
					GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id, p_item_no, b1.pack_line_cd); --added by robert GENQA 4844 09.02.15
				END IF;
			END LOOP;
			EXIT;
		END LOOP;
	END IF;
END PACK_ENDT_GET_NEG_ITEM;
/


