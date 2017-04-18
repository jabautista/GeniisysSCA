DROP FUNCTION CPI.GIPIS081_CREATE_DIST_ITEM;

CREATE OR REPLACE FUNCTION CPI.gipis081_create_dist_item (
   p_par_id    IN   NUMBER
)
   RETURN VARCHAR2
IS
   dist_cnt 			 NUMBER:=0;
   dist_max 			 giuw_pol_dist.dist_no%TYPE; 
   p_dist_no   			 NUMBER := 0;
   p_message   VARCHAR2 (200) := '0';
BEGIN
 
   BEGIN
     SELECT dist_no
	   INTO p_dist_no
              FROM giuw_pol_dist
             WHERE par_id = p_par_id;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN NULL;
   END;

   FOR a IN (SELECT   SUM (tsi_amt * currency_rt) tsi_amt,
                      SUM (ann_tsi_amt * currency_rt) ann_tsi_amt,
                      SUM (prem_amt * currency_rt) prem_amt, item_grp
                 FROM gipi_witem
                WHERE par_id = p_par_id
             GROUP BY item_grp)
   LOOP
      BEGIN
         BEGIN
            SELECT COUNT (dist_no), MAX (dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE par_id = p_par_id
               AND NVL (item_grp, a.item_grp) = a.item_grp;
         END;

      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            --HIDE_VIEW('WARNING');
            --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
            --SHOW_VIEW('CG$STACKED_HEADER_1');
            p_message := '9';
                 /* 'There are too many distribution numbers assigned for this item. '
               || 'Please call your administrator to rectify the matter. Check '
               || 'records in the policy table with par_id = '
               || TO_CHAR (p_par_id)
               || '.'; */
         WHEN NO_DATA_FOUND
         THEN
            -- :RCODEGMI030308 --
            NULL;
      END;
   END LOOP;

   RETURN p_message;
END;
/


