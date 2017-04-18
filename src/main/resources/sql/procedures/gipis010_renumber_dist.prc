CREATE OR REPLACE PROCEDURE CPI.Gipis010_Renumber_Dist (
	p_par_id	GIUW_POL_DIST.par_id%TYPE,
	p_new_no	GIPI_WITEM.item_no%TYPE,
	p_old_no	GIPI_WITEM.item_no%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.01.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Insert record/s on GIUW_WITEMDS, GIUW_ITEMPERILDS.
	**					: Update record/s on GIUW_WITEMPERILDS_DTL.
	**					: Delete record/s on GIUW_WITEMPERILDS, GIUW_WITEMDS
	*/
BEGIN
	FOR dist IN(SELECT dist_no
				  FROM GIUW_POL_DIST
				 WHERE par_id = p_par_id
				   AND dist_flag  IN ( '1','2','3'))
	LOOP
		INSERT INTO  GIUW_WITEMDS (
			dist_no,  dist_seq_no,  item_no,
			tsi_amt,  prem_amt,     ann_tsi_amt)
		SELECT 	dist_no,  dist_seq_no,  p_new_no,
				tsi_amt,  prem_amt,     ann_tsi_amt
		  FROM GIUW_WITEMDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		UPDATE GIUW_WITEMDS_DTL
		   SET item_no = p_new_no
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		INSERT INTO  GIUW_WITEMPERILDS
			(dist_no,  dist_seq_no,  item_no,  line_cd,
			 peril_cd, tsi_amt,      prem_amt, ann_tsi_amt)
		SELECT dist_no,  dist_seq_no,  p_new_no, line_cd,
			   peril_cd, tsi_amt,      prem_amt, ann_tsi_amt
		  FROM GIUW_WITEMPERILDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		UPDATE GIUW_WITEMPERILDS_DTL
		   SET item_no = p_new_no
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		DELETE GIUW_WITEMPERILDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		DELETE GIUW_WITEMDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;  
  
  /*added by Gzelle 09152014*/
  		INSERT INTO  GIUW_ITEMDS (
			dist_no,  dist_seq_no,  item_no,
			tsi_amt,  prem_amt,     ann_tsi_amt)
		SELECT 	dist_no,  dist_seq_no,  p_new_no,
				tsi_amt,  prem_amt,     ann_tsi_amt
		  FROM GIUW_ITEMDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		UPDATE GIUW_ITEMDS_DTL
		   SET item_no = p_new_no
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		INSERT INTO  GIUW_ITEMPERILDS
			(dist_no,  dist_seq_no,  item_no,  line_cd,
			 peril_cd, tsi_amt,      prem_amt, ann_tsi_amt)
		SELECT dist_no,  dist_seq_no,  p_new_no, line_cd,
			   peril_cd, tsi_amt,      prem_amt, ann_tsi_amt
		  FROM GIUW_ITEMPERILDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		UPDATE GIUW_ITEMPERILDS_DTL
		   SET item_no = p_new_no
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		DELETE GIUW_ITEMPERILDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;
		   
		DELETE GIUW_ITEMDS
		 WHERE dist_no = dist.dist_no
		   AND item_no = p_old_no;                 
                                                              
  END LOOP;                                          
END; 
/

