DROP FUNCTION CPI.GET_GPA_ITEM_TITLE;

CREATE OR REPLACE FUNCTION CPI.Get_Gpa_Item_Title
/* beth  01052006
** get item_title which includes group item title
** for records with grouped item no > 0
*/
(
  p_claim_id             GICL_CLAIMS.claim_id%TYPE,
  p_line_cd              GICL_CLAIMS.line_cd%TYPE,
  p_item_no              gicl_accident_dtl.item_no%TYPE,
  p_grouped_item_no      gicl_accident_dtl.grouped_item_no%TYPE
)
RETURN VARCHAR2
IS
  v_item_title     VARCHAR2(200);
  v_line_cd		   GIIS_LINE.MENU_LINE_CD%TYPE;
BEGIN
  FOR Get_Item_Title IN (SELECT a.item_title
  	  				 	   FROM gicl_clm_item a
					      WHERE a.item_no = p_item_no
          				    AND a.claim_id = p_claim_id)
  LOOP
    v_item_title := INITCAP(Get_Item_Title.item_title);
  END LOOP;--end of get_item_title loop

  FOR i IN (SELECT menu_line_cd
              FROM giis_line
			 WHERE line_cd = p_line_cd)
  LOOP
    v_line_cd := i.menu_line_cd;
  END LOOP;


  IF p_grouped_item_no > 0 THEN
     IF nvl(v_line_cd,p_line_cd) = Giisp.v('LINE_CODE_AC') OR nvl(v_line_cd,p_line_cd) = 'AC' THEN
        FOR get_grp_title IN (SELECT a.grouped_item_title
              			  	    FROM gicl_accident_dtl a
              				   WHERE a.item_no= p_item_no
							     AND a.grouped_item_no= p_grouped_item_no
                				 AND a.claim_id=p_claim_id)
        LOOP
          v_item_title := v_item_title ||'-'||INITCAP(get_grp_title.grouped_item_title);
        END LOOP;--end of get_grp_title loop
  	 ELSIF nvl(v_line_cd,p_line_cd) = Giisp.v('LINE_CODE_CA') OR nvl(v_line_cd,p_line_cd) = 'CA'THEN
        FOR get_grp_title IN (SELECT a.grouped_item_title
             		   	        FROM gicl_casualty_dtl a
              				   WHERE a.item_no= p_item_no
             				     AND a.grouped_item_no= p_grouped_item_no
                			  	 AND a.claim_id=p_claim_id)
        LOOP
       	  v_item_title := v_item_title ||'-'||INITCAP(get_grp_title.grouped_item_title);
     	END LOOP;--end of get_grp_title loop
     END IF;
  END IF;
  RETURN (v_item_title);
END;
/


