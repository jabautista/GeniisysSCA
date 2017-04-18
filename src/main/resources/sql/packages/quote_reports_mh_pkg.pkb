CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_MH_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_MH_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/28/2011   Windell Valle    Created this package body.
******************************************************************************/

FUNCTION get_curr_mh(p_quote_id NUMBER) --* Get currency short name
    RETURN mh_curr_tab PIPELINED IS

    v_mh_curr   mh_curr_type;

   BEGIN
     FOR c IN (SELECT DISTINCT
                      b.short_name
                 FROM gipi_quote_item A, giis_currency b
                WHERE 1=1
                  AND A.currency_cd = b.main_currency_cd
                  AND A.quote_id = p_quote_id
              )
     LOOP
       v_mh_curr.currency_name := c.short_name;

     END LOOP;

    PIPE ROW(v_mh_curr);
    RETURN;

   END;


  FUNCTION get_signatory_mh(p_quote_id NUMBER, p_iss_cd VARCHAR2)
  RETURN hull_signatory_tab PIPELINED IS
      v_sig    hull_signatory_type;
  BEGIN

     FOR sig IN (SELECT SIGNATORY,DESIGNATION, b.remarks, current_signatory_sw
                           FROM GIIS_SIGNATORY A,GIIS_SIGNATORY_NAMES B
                     WHERE A.REPORT_ID = 'MH_QUOTE'--NVL(A.REPORT_ID,'MH_QUOTE') = 'MH_QUOTE' removed nvl -christian 02/18/2013
                       AND nvl(A.iss_cd,p_iss_cd) = p_iss_cd --
                       --AND nvl(a.line_cd,'MH')= 'MH'         --
                       AND current_signatory_sw = 'Y'
                       AND A.signatory_id = b.signatory_id )
      LOOP
          v_sig.sig_name     := sig.signatory;
          v_sig.sig_des      := sig.designation;
          v_sig.sig_remarks  := sig.remarks;
          v_sig.sig_sw       := sig.current_signatory_sw;
      END LOOP;
    PIPE ROW(v_sig);
    RETURN;
  END;


--*--*--*--*--*--* SEICI Functions [top]--*--*--*--*--*--*--*--*--*--*--*--*Windell--*--*
FUNCTION get_quote_details_mh_seici(p_quote_id NUMBER)
    RETURN mh_quote_details_tab PIPELINED IS

    v_mh_quote_detail mh_quote_details_type;

  BEGIN
    FOR A IN (SELECT
                     line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no,
                     assd_name,
                     HEADER,
                     footer,
                     to_char(accept_dt, 'fmMonth DD, YYYY') accept_date,
                     remarks,
                     line_cd,
                     subline_cd,
                     ---
                     address1, address2, address3,
                     TO_CHAR(incept_date, 'fmMonth DD, YYYY') incept_date,
                      TO_CHAR(expiry_date, 'fmMonth DD, YYYY') expiry_date,
                     user_id
                     FROM gipi_quote
                 WHERE quote_id = p_quote_id)

    LOOP
      v_mh_quote_detail.quote_no             := A.quote_no;
      v_mh_quote_detail.assd_name            := A.assd_name;
      v_mh_quote_detail.assd_add1            := A.address1;
      v_mh_quote_detail.assd_add2            := A.address2;
      v_mh_quote_detail.assd_add3            := A.address3;
      v_mh_quote_detail.accept_dt            := A.accept_date;
      v_mh_quote_detail.incept               := A.incept_date;
      v_mh_quote_detail.expiry               := A.expiry_date;
      v_mh_quote_detail.HEADER               := A.HEADER;
      v_mh_quote_detail.footer               := A.footer;
      v_mh_quote_detail.user_id              := A.user_id;
      v_mh_quote_detail.line_cd              := A.line_cd;
      v_mh_quote_detail.subline_cd           := A.subline_cd;
      v_mh_quote_detail.remarks              := A.remarks;

      --/* subline name
    BEGIN
       SELECT subline_name
         INTO v_mh_quote_detail.subline_name
         FROM giis_subline
        WHERE line_cd = A.line_cd
          AND subline_cd = A.subline_cd;
    END;
    --/ subline name  */


    END LOOP;


      BEGIN
        SELECT param_value_v
          INTO v_mh_quote_detail.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

    PIPE ROW(v_mh_quote_detail);
    RETURN;

  END get_quote_details_mh_seici;


 FUNCTION get_vessel_mh_seici(p_quote_id NUMBER)
   RETURN mh_vessel_tab PIPELINED IS

    v_mh_quote_vessel   mh_vessel_type;

   BEGIN
     FOR v IN (SELECT A.vessel_cd, b.vessel_name
                      FROM gipi_quote_mh_item A, giis_vessel b
                     WHERE A.quote_id  = p_quote_id
                       AND A.vessel_cd = b.vessel_cd
              )
     LOOP
       v_mh_quote_vessel.vessel_name := v.vessel_name;
       PIPE ROW(v_mh_quote_vessel);
     END LOOP;

       RETURN;

   END get_vessel_mh_seici;


  FUNCTION get_tsi_mh_seici(p_quote_id NUMBER)
    RETURN mh_tsi_tab PIPELINED IS

    v_mh_tsi   mh_tsi_type;

   BEGIN
     FOR T IN (SELECT to_char(SUM(nvl(tsi_amt,0)), 'fm999,999,999,990.00') tsi_amt
                 FROM gipi_quote_item
                WHERE quote_id = p_quote_id
              )
     LOOP
       v_mh_tsi.tsi_amt := T.tsi_amt;

     END LOOP;

    PIPE ROW(v_mh_tsi);
    RETURN;

   END;


   FUNCTION get_items_mh_seici(p_quote_id NUMBER)
     RETURN mh_items_tab PIPELINED IS

     v_mh_items mh_items_type;

  BEGIN
    FOR i IN ( SELECT DISTINCT
                      item_title, item_desc
                 FROM gipi_quote_item
                WHERE quote_id = p_quote_id
             ORDER BY item_title )
    LOOP
      v_mh_items.item_title := i.item_title;

      PIPE ROW(v_mh_items);
    END LOOP;

    RETURN;

  END get_items_mh_seici;


  FUNCTION get_deductible_mh_seici(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
    RETURN mh_deductible_tab PIPELINED IS

    v_mh_deductible   mh_deductible_type;

   BEGIN
     FOR pd IN (   SELECT DISTINCT
                         A.quote_id,
                         A.peril_cd,
                         A.item_no,
                         decode(b.peril_name, NULL, NULL, b.peril_name) peril_name,
                         decode(c.deductible_text, NULL , NULL, deductible_text) deductible_text
                   FROM  gipi_quote_itmperil A, giis_peril b, gipi_quote_deductibles c
                  WHERE  A.peril_cd = b.peril_cd (+)
                    AND  A.peril_cd = c.peril_cd (+)
                    AND A.item_no  = c.item_no  (+)
                    AND A.quote_id = c.quote_id (+)
                    AND (b.subline_cd = p_subline_cd  OR b.subline_cd IS NULL)
                    AND b.line_cd = p_line_cd
                    AND A.quote_id = p_quote_id
               ORDER BY A.item_no, peril_cd
              )
     LOOP
        v_mh_deductible.peril_cd        := pd.peril_cd;
        v_mh_deductible.peril_name      := pd.peril_name;
        v_mh_deductible.deductible_text := pd.deductible_text;
        v_mh_deductible.peril_ded       := NVL(pd.peril_name || chr(10) || pd.deductible_text,' ');

        PIPE ROW(v_mh_deductible);
     END LOOP;

    RETURN;

   END;


  FUNCTION get_wc_mh_seici(p_quote_id NUMBER)
    RETURN mh_wc_tab PIPELINED IS

    v_mh_wc   mh_wc_type;

   BEGIN
     FOR wc IN (SELECT wc_title
                  FROM gipi_quote_wc
                 WHERE quote_id = p_quote_id
              )
     LOOP
       v_mh_wc.wc_title := wc.wc_title;
       PIPE ROW(v_mh_wc);
     END LOOP;

    RETURN;

   END;


  FUNCTION get_prem_mh_seici(p_quote_id NUMBER)
    RETURN mh_prem_tab PIPELINED IS

    v_mh_prem   mh_prem_type;

   BEGIN
     FOR P IN (SELECT SUM(nvl(prem_amt,0)) + SUM(nvl(tax_amt,0)) prem_amt
                 FROM gipi_quote_invoice
                WHERE quote_id = p_quote_id
              )
     LOOP
       v_mh_prem.prem_amt_chr := TO_CHAR(P.prem_amt, 'fm999,999,999,990.00');
     END LOOP;

    PIPE ROW(v_mh_prem);
    RETURN;

   END;
--*--*--*--*--*--* SEICI Functions [bottom]--*--*--*--*--*--*--*--*--*--*--*--*Windell--*--*


--*--*--*--*--*--* UCPB Functions [top]--*--*--*--*--*--*--*--*--*--*--*--*Windell--*--*
FUNCTION get_quote_details_mh_ucpb(p_quote_id NUMBER)
    RETURN mh_quote_details_tab PIPELINED IS

    v_mh_quote_detail mh_quote_details_type;

  BEGIN
    FOR A IN (SELECT
                     line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no,
                     assd_name,
                     HEADER,
                     footer,
                     to_char(accept_dt, 'fmMonth DD, YYYY') accept_date,
                     remarks,
                     iss_cd,
                     line_cd,
                     subline_cd,
                     address1, address2, address3,
                     decode(address3,NULL,decode(address2,NULL,address1,address1||chr(10)||Address2),
                                        decode(address2,NULL,address1,address1||chr(10)||Address2)||chr(10)||address3) address,
                     TO_CHAR(incept_date, 'fmMonth DD, YYYY') incept_date,
                     TO_CHAR(expiry_date, 'fmMonth DD, YYYY') expiry_date,
                     user_id
                     FROM gipi_quote
               WHERE quote_id = p_quote_id)

    LOOP
      v_mh_quote_detail.quote_no             := A.quote_no;
      v_mh_quote_detail.assd_name            := A.assd_name;
      v_mh_quote_detail.assd_add             := A.address;
      v_mh_quote_detail.assd_add1            := A.address1;
      v_mh_quote_detail.assd_add2            := A.address2;
      v_mh_quote_detail.assd_add3            := A.address3;
      v_mh_quote_detail.accept_dt            := A.accept_date;
      v_mh_quote_detail.incept               := A.incept_date;
      v_mh_quote_detail.expiry               := A.expiry_date;
      v_mh_quote_detail.HEADER               := A.HEADER;
      v_mh_quote_detail.footer               := A.footer;
      v_mh_quote_detail.user_id              := A.user_id;
      v_mh_quote_detail.iss_cd               := A.iss_cd;
      v_mh_quote_detail.line_cd              := A.line_cd;
      v_mh_quote_detail.subline_cd           := A.subline_cd;
      v_mh_quote_detail.remarks              := A.remarks;

      --/* subline name
    BEGIN
       SELECT subline_name
         INTO v_mh_quote_detail.subline_name
         FROM giis_subline
        WHERE line_cd = A.line_cd
          AND subline_cd = A.subline_cd;
    END;
    --/ subline name  */


    END LOOP;


      BEGIN
        SELECT param_value_v
          INTO v_mh_quote_detail.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

    PIPE ROW(v_mh_quote_detail);
    RETURN;

  END get_quote_details_mh_ucpb;


FUNCTION get_vessel_mh_ucpb(p_quote_id NUMBER)
   RETURN mh_vessel_tab PIPELINED IS

    v_mh_quote_vessel   mh_vessel_type;

   BEGIN
     FOR v IN (SELECT A.quote_id, A.vessel_cd, b.vessel_name, c.vestype_desc, b.year_built, b.gross_ton,
                      to_char(nvl(d.tsi_amt,0), 'fm999,999,999,990.00') tsi_amt, e.short_name -- andrew - 2.22.2013 - added currency short_name
                 FROM gipi_quote_mh_item A, giis_vessel b, giis_vestype c,
                      gipi_quote_item d,
                      giis_currency e
                WHERE A.vessel_cd  = b.vessel_cd
                  AND b.vestype_cd = c.vestype_cd
                  AND e.main_currency_cd = d.currency_cd
                  AND A.item_no    = d.item_no
                  AND A.quote_id   = d.quote_id
                  AND A.quote_id   = p_quote_id                  
             ORDER BY b.vessel_name
              )
     LOOP       
       v_mh_quote_vessel.vessel_name := v.vessel_name;
       v_mh_quote_vessel.vessel_type := v.vestype_desc;
       v_mh_quote_vessel.year_built  := v.year_built;
       v_mh_quote_vessel.gross_ton   := v.gross_ton;
       v_mh_quote_vessel.tsi_amt     := v.tsi_amt;
       v_mh_quote_vessel.short_name := v.short_name;

       PIPE ROW(v_mh_quote_vessel);
     END LOOP;

       RETURN;

   END get_vessel_mh_ucpb;


FUNCTION get_tsi_mh_ucpb(p_quote_id NUMBER)
    RETURN mh_tsi_tab PIPELINED IS

    v_mh_tsi   mh_tsi_type;
	v_the_same  	 	VARCHAR2(1); --added by steven 1.24.2013
	v_short_name_temp 	VARCHAR2(10) := NULL; --added by steven 1.24.2013
	v_tsi_amt		 	gipi_quote_item.tsi_amt%TYPE := 0; --added by steven 1.24.2013
   BEGIN
     --added by steven 1.24.2013; to check if it has different currency 
	 FOR j IN (SELECT c.short_name 
				 FROM gipi_quote_item A, giis_currency c
				WHERE A.quote_id = p_quote_id
				  AND A.currency_cd = c.main_currency_cd)
		 LOOP
			IF v_short_name_temp is NULL THEN
				v_short_name_temp := j.short_name;
				v_the_same := 'Y';
			ELSE
				IF v_short_name_temp = j.short_name THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					v_short_name_temp := 'PHP';
					v_the_same := 'N';
					EXIT;
				END IF;
			END IF;
	 END LOOP;
	 FOR T IN (SELECT SUM(nvl(tsi_amt,0)) tsi_amt,currency_rate
                 FROM gipi_quote_item
                WHERE quote_id   = p_quote_id
                GROUP BY currency_rate
              )
     LOOP
	 	IF v_the_same = 'N' THEN
			v_tsi_amt := v_tsi_amt + (T.tsi_amt * T.currency_rate);
		ELSE
			v_tsi_amt := v_tsi_amt + T.tsi_amt;
		END IF;
     END LOOP;
	 
	v_mh_tsi.tsi_amt := TO_CHAR(v_tsi_amt, 'fm999,999,999,990.00');
	v_mh_tsi.short_name := v_short_name_temp;
    PIPE ROW(v_mh_tsi);
    RETURN;

   END;

FUNCTION get_geo_lim_mh_ucpb(p_quote_id NUMBER)
    RETURN mh_geo_lim_tab PIPELINED IS

    v_mh_geo_lim   mh_geo_lim_type;

   BEGIN
     FOR T IN ( SELECT DISTINCT geog_limit
                    FROM gipi_quote_mh_item
                   WHERE quote_id = p_quote_id
                     AND geog_limit IS NOT NULL
                ORDER BY geog_limit)
     LOOP

       v_mh_geo_lim.geog_limit := T.geog_limit;
       PIPE ROW(v_mh_geo_lim);
     END LOOP;


    RETURN;

   END;


FUNCTION get_deductible_mh_ucpb(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
    RETURN mh_deductible_tab PIPELINED IS

    v_mh_deductible   mh_deductible_type;

   BEGIN
     
     FOR A IN ( SELECT DISTINCT peril_lname, A.item_no, A.peril_cd
                   FROM gipi_quote_itmperil A, giis_peril b
                  WHERE A.peril_cd = b.peril_cd
                    AND b.line_cd = p_line_cd
                    AND A.quote_id = p_quote_id
                    AND b.peril_type = 'B'
              )
     LOOP
        
        FOR pd IN ( SELECT DISTINCT decode(c.deductible_text, NULL , NULL, deductible_text) deductible_text
                      FROM gipi_quote_deductibles c
                     WHERE c.quote_id = p_quote_id
                       AND deductible_text IS NOT NULL
                       AND c.item_no = A.item_no
                       AND c.peril_cd = A.peril_cd
             )
        LOOP

          v_mh_deductible.deductible_text := pd.deductible_text;
     
        END LOOP;
        
        v_mh_deductible.peril_name := A.peril_lname;     

        PIPE ROW(v_mh_deductible);
     END LOOP;
     
     RETURN;

   END;


FUNCTION get_peril_rate_mh_ucpb(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
    RETURN mh_peril_rate_tab PIPELINED IS

    v_mh_peril_rate   mh_peril_rate_type;

   BEGIN
     FOR pr IN ( SELECT TO_CHAR(prem_rt, 'fm999.009999999') prem_rt
                   FROM gipi_quote_itmperil A, giis_peril b
                  WHERE A.peril_cd = b.peril_cd
                    AND (b.subline_cd = p_subline_cd OR b.subline_cd IS NULL)
                    AND b.line_cd = p_line_cd
                    AND A.quote_id = p_quote_id
                    AND A.peril_type = 'B'
               ORDER BY prem_rt
              )
     LOOP

        v_mh_peril_rate.peril_rate := pr.prem_rt;

        PIPE ROW(v_mh_peril_rate);
        --EXIT; -- comment out by andrew - 02.22.2013 to display all peril rates
     END LOOP;

    RETURN;

   END;


   FUNCTION get_wc_mh_ucpb(p_quote_id NUMBER)
    RETURN mh_wc_tab PIPELINED IS

    v_mh_wc   mh_wc_type;

   BEGIN
     FOR wc IN (SELECT wc_title
                  FROM gipi_quote_wc
                 WHERE quote_id = p_quote_id
              )
     LOOP
       v_mh_wc.wc_title := wc.wc_title;
       PIPE ROW(v_mh_wc);
     END LOOP;

    RETURN;

   END;


   FUNCTION get_prem_mh_ucpb(p_quote_id NUMBER)
    RETURN mh_prem_tab PIPELINED IS

    v_mh_prem   mh_prem_type;
	v_the_same  	  VARCHAR2(1); --added by steven 1.26.2013
    v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.26.2013
	v_prem_amt		  gipi_quote_invoice.prem_amt%TYPE := 0; --added by steven 1.26.2013

   BEGIN
   	--added by steven 1.24.2013; to check if it has different currency 
		 FOR j IN (SELECT c.short_name 
					 FROM gipi_quote_item A, giis_currency c
					WHERE A.quote_id = p_quote_id
					  AND A.currency_cd = c.main_currency_cd)
			 LOOP
				IF v_short_name_temp is NULL THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					IF v_short_name_temp = j.short_name THEN
						v_short_name_temp := j.short_name;
						v_the_same := 'Y';
					ELSE
						v_short_name_temp := 'PHP';
						v_the_same := 'N';
						EXIT;
					END IF;
				END IF;
		 END LOOP;
		 
     FOR P IN ( SELECT SUM(nvl(prem_amt,0)) + SUM(nvl(tax_amt,0)) prem_amt,currency_rt
                 FROM gipi_quote_invoice
                WHERE quote_id = p_quote_id
                GROUP BY currency_rt
              )
     LOOP
	 	IF v_the_same = 'N' THEN
			v_prem_amt := v_prem_amt + (P.prem_amt * P.currency_rt);
		ELSE
			v_prem_amt := v_prem_amt + P.prem_amt;
		END IF;
     END LOOP;
	 v_mh_prem.prem_amt_chr := TO_CHAR(v_prem_amt, 'fm999,999,999,990.00');
	 v_mh_prem.short_name	:= v_short_name_temp;

    PIPE ROW(v_mh_prem);
    RETURN;

   END;
--*--*--*--*--*--* UCPB Functions [bottom]--*--*--*--*--*--*--*--*--*--*--*--*Windell--*--*

END QUOTE_REPORTS_MH_PKG;
/


