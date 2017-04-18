DROP FUNCTION CPI.GET_DIST_TSI;

CREATE OR REPLACE FUNCTION CPI.get_dist_tsi (
	  p_line_cd     IN VARCHAR2,
	  p_subline_cd  IN VARCHAR2,
	  p_iss_cd  	IN VARCHAR2,
	  p_issue_yy  	IN NUMBER,
	  p_pol_seq_no  IN NUMBER,
   	  p_renew_no 	IN NUMBER,
   	  p_item_no  	IN NUMBER,
	  p_peril_cd	IN NUMBER,
	  p_share_cd	IN NUMBER,
	  p_dist_no     IN NUMBER)
  RETURN NUMBER IS
	v_tsi 			   giuw_itemperilds_dtl.dist_tsi%TYPE;
	v_peril_type  	   giis_peril.peril_type%TYPE;
  BEGIN
  BEGIN
  	SELECT DISTINCT g.peril_type
	  INTO v_peril_type
      FROM gipi_polbasic         a,
           gipi_fireitem         d,
           gipi_itmperil         c,
           giuw_pol_dist         e,
           giuw_itemperilds_dtl  f,
   	       giis_peril			   g
     WHERE 1=1
       AND a.policy_id   = d.policy_id
       AND a.par_id      = e.par_id
       AND e.dist_flag   = '3'
       AND a.policy_id   = c.policy_id
       AND d.item_no     = c.item_no
       AND a.line_cd     = c.line_cd
       AND e.dist_no     = f.dist_no
       AND f.dist_seq_no >= 0
       AND d.item_no     = f.item_no
       AND c.peril_cd    = f.peril_cd
       AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
   	   AND a.iss_cd      = p_iss_cd
   	   AND a.issue_yy    = p_issue_yy
   	   AND a.pol_seq_no  = p_pol_seq_no
   	   AND a.renew_no    = p_renew_no
       AND d.item_no     = p_item_no
--       AND f.share_cd    = p_share_cd
       AND g.peril_cd    = f.peril_cd
       AND g.line_cd     = a.line_cd
       AND g.peril_cd    = c.peril_cd
       AND g.zone_type   IN ('5','6','7')
	   AND g.peril_type  = 'B';
	 EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	   V_PERIL_TYPE := 'A';
	 END;

  IF V_PERIL_TYPE = 'B' THEN
	SELECT FB.DIST_TSI
      INTO V_TSI
	  FROM GIUW_ITEMPERILDS_DTL  FB,
		   GIIS_PERIL			 GB
     WHERE 1=1
	   AND FB.DIST_NO     = P_DIST_NO
	   AND GB.LINE_CD	  = P_LINE_CD
	   AND GB.PERIL_CD	  = FB.PERIL_CD
	   AND FB.PERIL_CD    = P_PERIL_CD
	   AND FB.SHARE_CD    = P_SHARE_CD
	   AND FB.ITEM_NO     = P_ITEM_NO
 	   AND GB.ZONE_TYPE   = '2'
       AND GB.PERIL_TYPE  = 'B';
  ELSE
	SELECT FA.DIST_TSI
      INTO V_TSI
	  FROM GIUW_ITEMPERILDS_DTL  FA,
		   GIIS_PERIL			 GA
     WHERE 1=1
	   AND FA.DIST_NO     = P_DIST_NO
	   AND FA.DIST_SEQ_NO >= 0
	   AND GA.LINE_CD	  = P_LINE_CD
	   AND GA.PERIL_CD	  = FA.PERIL_CD
	   AND FA.PERIL_CD    = P_PERIL_CD
	   AND FA.SHARE_CD    = P_SHARE_CD
	   AND FA.ITEM_NO	  = P_ITEM_NO
	   AND (FA.SHARE_CD, FA.DIST_TSI) IN
	       (SELECT MAX(F.SHARE_CD), F.DIST_TSI
	   	   			  	    FROM GIPI_POLBASIC         A,
                                 GIPI_FIREITEM         D,
                                 GIPI_ITMPERIL         C,
                                 GIUW_POL_DIST         E,
                                 GIUW_ITEMPERILDS_DTL  F,
                        	     GIIS_PERIL			   G
                            WHERE 1=1
                              AND A.POLICY_ID   = D.POLICY_ID
                              AND A.PAR_ID      = E.PAR_ID
                              AND E.DIST_FLAG   = '3'
                              AND A.POLICY_ID   = C.POLICY_ID
                              AND D.ITEM_NO     = C.ITEM_NO
                              AND A.LINE_CD     = C.LINE_CD
                              AND E.DIST_NO     = F.DIST_NO
                              AND F.DIST_SEQ_NO >= 0
                              AND D.ITEM_NO     = F.ITEM_NO
                              AND C.PERIL_CD    = F.PERIL_CD
                       	      AND A.LINE_CD     = P_LINE_CD
                              AND A.SUBLINE_CD  = P_SUBLINE_CD
                        	  AND A.ISS_CD      = P_ISS_CD
                        	  AND A.ISSUE_YY    = P_ISSUE_YY
                        	  AND A.POL_SEQ_NO  = P_POL_SEQ_NO
                        	  AND A.RENEW_NO    = P_RENEW_NO
                              AND D.ITEM_NO     = P_ITEM_NO
                       	      AND G.PERIL_CD    = F.PERIL_CD
                       	      AND G.LINE_CD     = A.LINE_CD
                       	      AND G.PERIL_CD    = C.PERIL_CD
       						  AND g.zone_type   IN ('5','6','7')
							  AND F.DIST_TSI IN
							    (SELECT MAX(F.DIST_TSI)
	   	   			  	    FROM GIPI_POLBASIC         A,
                                 GIPI_FIREITEM         D,
                                 GIPI_ITMPERIL         C,
                                 GIUW_POL_DIST         E,
                                 GIUW_ITEMPERILDS_DTL  F,
                        	     GIIS_PERIL			   G
                            WHERE 1=1
                              AND A.POLICY_ID   = D.POLICY_ID
                              AND A.PAR_ID      = E.PAR_ID
                              AND E.DIST_FLAG   = '3'
                              AND A.POLICY_ID   = C.POLICY_ID
                              AND D.ITEM_NO     = C.ITEM_NO
                              AND A.LINE_CD     = C.LINE_CD
                              AND E.DIST_NO     = F.DIST_NO
                              AND F.DIST_SEQ_NO >= 0
                              AND D.ITEM_NO     = F.ITEM_NO
                              AND C.PERIL_CD    = F.PERIL_CD
                       	      AND A.LINE_CD     = P_LINE_CD
                              AND A.SUBLINE_CD  = P_SUBLINE_CD
                        	  AND A.ISS_CD      = P_ISS_CD
                        	  AND A.ISSUE_YY    = P_ISSUE_YY
                        	  AND A.POL_SEQ_NO  = P_POL_SEQ_NO
                        	  AND A.RENEW_NO    = P_RENEW_NO
                              AND D.ITEM_NO     = P_ITEM_NO
                       	      AND G.PERIL_CD    = F.PERIL_CD
                       	      AND G.LINE_CD     = A.LINE_CD
                       	      AND G.PERIL_CD    = C.PERIL_CD
							  AND g.zone_type   IN ('5','6','7'))
							  GROUP BY F.DIST_TSI);
  END IF;
 RETURN(NVL(V_TSI,0));
   END;
/


