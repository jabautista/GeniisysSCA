CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_FI_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/31/2010   rencela          Created this package.
   1.1          06/02/2010  rencela          Created get_quote_details_fi_cic_items
******************************************************************************/

  FUNCTION get_quote_details_fi_cic(p_quote_id NUMBER)
    RETURN quote_fi_details_tab PIPELINED IS

    v_fi_quote_detail quote_fi_details_type;

  BEGIN
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                       TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                       TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                                  A.HEADER, A.footer, A.user_id, A.LINE_CD, A.subline_cd, A.accept_dt
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
      v_fi_quote_detail.assd_name            := A.assd_name;
      v_fi_quote_detail.assd_add1            := A.address1;
      v_fi_quote_detail.assd_add2            := A.address2;
      v_fi_quote_detail.assd_add3            := NVL(A.address3,'');
      v_fi_quote_detail.incept                := A.incept_date;
      v_fi_quote_detail.expiry                := A.expiry_date;
      v_fi_quote_detail.HEADER                := A.HEADER;
      v_fi_quote_detail.footer                := A.footer;
      v_fi_quote_detail.line_cd                := A.line_cd;
      v_fi_quote_detail.subline_cd            := A.subline_cd;
      v_fi_quote_detail.accept_dt            := TO_CHAR(A.accept_dt, 'fmMonth DD, YYYY');
    END LOOP;

 --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_fi_quote_detail.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

    PIPE ROW(v_fi_quote_detail);
    RETURN;

  END get_quote_details_fi_cic;


FUNCTION get_quote_details_fi_cic_items(p_quote_id NUMBER)
    RETURN quote_fi_item_tab PIPELINED IS

           v_ctr1       NUMBER;
           v_ctr2        NUMBER;
           v_ctr3        NUMBER;
           v_prem        NUMBER:=0;
           v_tsi       VARCHAR2(25)        := ' ';
           vCount        NUMBER:=0;
           x              NUMBER := 0;
             s            VARCHAR2(5000);
           incept       VARCHAR2(100);
           expiry       VARCHAR2(100);
           vCurrency   giis_currency.short_name%TYPE;
           v_det        quote_fi_item_details_type;
           linecd       gipi_quote.line_cd%TYPE;
           sublinecd   gipi_quote.subline_cd%TYPE;

  BEGIN
      FOR A IN (SELECT DISTINCT A.line_cd,A.subline_cd,
                             TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                       TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
         linecd := A.line_cd;
        sublinecd := A.subline_cd;
        incept := A.incept_date;
        expiry := A.expiry_date;
    END LOOP;

    FOR i IN (SELECT item_title, item_no
                FROM gipi_quote_item
               WHERE quote_id = p_quote_id)
    LOOP
        v_ctr2:=0;
        v_ctr3:=0;
        v_ctr1 := v_ctr1+1;

        FOR XD IN 1..7 LOOP --XD  7  ..

            v_det.v_title    := '';
            v_det.v_colon      := '';
            v_det.v_value      := '';
            v_det.v_amount      := '';
            v_det.v_currency := '';

            IF XD = 1 THEN
                --ITEM TITLE--    1
                v_det.v_title      := 'Property Insured Item';
                v_det.v_colon      := ':';
                v_det.v_value      := i.item_title;

                v_det.v_prem := 0;
                v_det.v_prem_currency := '';

            ELSIF XD = 2 THEN
                --LOCATION--   2

                FOR j IN (SELECT DECODE(A.loc_risk1,NULL,'',A.loc_risk1||',')||
                             DECODE(A.loc_risk2,NULL,'',chr(10)||A.loc_risk2||',')||
                             DECODE(A.loc_risk3,NULL,'',chr(10)||A.loc_risk3) LOCATION
                        FROM gipi_quote_fi_item A,
                             gipi_quote_item b
                       WHERE A.quote_id = p_quote_id
                         AND A.quote_id = b.quote_id
                         AND A.item_no = b.item_no
                         AND A.item_no = i.item_no)
                LOOP
                    v_det.v_title := 'Location of Risk';
                    v_det.v_colon := ':';
                    v_det.v_value := j.LOCATION;

                    s:=j.LOCATION;
                    x := instr(s,chr(10));
                    WHILE x > 0 LOOP
                        vCount:=vCount+1;
                        s := substr(s    ,x+1);
                        x := instr(s,chr(10));
                    END LOOP;

                    EXIT;
                END LOOP;
                --DATE--   3
            ELSIF XD = 3 THEN
                --tsi--  4
                FOR E IN (SELECT TO_CHAR(A.tsi_amt * b.currency_rt, '999,999,999,999.99') tsi_amt,
                                    (A.tsi_amt * b.currency_rt) tsi,
                                   prem_amt*currency_rate prem_amt,
                                  b.short_name
                        FROM gipi_quote_item A,
                             giis_currency b
                       WHERE quote_id = p_quote_id
                         AND A.currency_cd = b.main_currency_cd
                         AND A.item_no = i.item_no)
                LOOP
                    v_tsi       := E.tsi_amt;
                    v_det.v_prem  := v_det.v_prem + E.tsi;
                    v_prem      := v_prem+E.prem_amt;
                    vCurrency := E.short_name;
                END LOOP;


                --LIMITS OF LIABLITY --4
                v_det.v_title := 'Total Sum Insured';
                v_det.v_colon := ':';
                v_det.v_value := vCurrency||v_tsi;

    --            v_det.v_prem := v_det.v_prem + v_tsi;

            ELSIF XD = 4 THEN
                --PERIL--  5
                FOR K IN (SELECT b.peril_name peril_name,    to_char(A.tsi_amt, '999,999,999,999.99') tsi_amt
                        FROM  giis_peril b,
                              gipi_quote_itmperil A,
                              gipi_quote c,
                              gipi_quote_item d
                       WHERE A.peril_cd = b.peril_cd
                         AND A.quote_id = c.quote_id
                         AND A.quote_id = p_quote_id
                         AND b.line_cd  = c.line_cd
                         AND A.item_no = d.item_no
                         AND A.quote_id = d.quote_id
                         AND A.item_no = i.item_no
                    ORDER BY A.item_no, b.peril_name)
                LOOP
                    v_ctr2:=v_ctr2+1;

                    IF v_ctr2>1 THEN
                        v_det.v_title := ' ';
                        v_det.v_colon := ' ';
                    ELSE
                        v_det.v_title := 'Coverage';
                        v_det.v_colon := ':';
                    END IF;

                    v_det.v_value       := K.peril_name;
                    v_det.v_currency  := vCurrency;
                    v_det.v_prem_currency := vCurrency;
                    v_det.v_amount       := K.tsi_amt;


                    PIPE ROW(v_det);

                    v_det.v_title    := '';
                    v_det.v_colon      := '';
                    v_det.v_value      := '';
                    v_det.v_amount      := '';
                    v_det.v_currency := '';

                END LOOP;
            ELSIF XD = 5 THEN
                --6
                FOR l IN ( SELECT b.deductible_text ded_text,
                              A.deductible_rt ded_rate,
                              A.deductible_text,
                              LTRIM(TO_CHAR(A.deductible_amt,'999,999,999,999.99'),' ') ded_amt
                         FROM gipi_quote_deductibles A,
                              giis_deductible_desc b,
                              gipi_quote_item c
                        WHERE A.ded_deductible_cd = b.deductible_cd
                          AND A.quote_id = p_quote_id
                          AND b.line_cd = linecd
                          AND b.subline_cd = sublinecd
                          AND A.item_no = c.item_no
                          AND A.quote_id = c.quote_id
                          AND A.item_no = i.item_no)
                LOOP
                    v_ctr3 := v_ctr3+1;

                    IF v_ctr3>1 THEN
                        v_det.v_title := ' ';
                    ELSE
                        v_det.v_title := 'Deductible';
                    END IF;
                    v_det.v_colon       := ' ';
                    v_det.v_value       := l.ded_Text;

                END LOOP;
                v_det.v_prem := v_prem;

            ELSE
                  v_det.v_colon := '  ';
            END IF;

            PIPE ROW(v_det);
        END LOOP;    --XD
    END LOOP;

    v_det.v_title := 'Term of Insurance';
    v_det.v_colon := ':';
    v_det.v_value := incept ||' to '||expiry;
    v_det.v_currency := '';
    v_det.v_amount   := '';
    PIPE ROW(v_det);

    v_det.v_title := 'Premium Computation';
    v_det.v_colon := ':';
    v_det.v_value := '';
    v_det.v_currency := v_det.v_prem_currency;
    v_det.v_amount := TO_CHAR(v_prem,'999,999,999.99');
    PIPE ROW(v_det);
      --v_det.v_colon := '  ';        PIPE ROW(v_det); -- THESE TWO EMPTY PIPES CREATE A SPACE ALLOWANCE
      --v_det.v_colon := '  ';      PIPE ROW(v_det); -- BETWEEN
    RETURN;

  END get_quote_details_fi_cic_items;

  FUNCTION get_quote_details_fi_fpac(p_quote_id NUMBER)
    RETURN quote_fi_details_tab PIPELINED IS

    v_det quote_fi_details_type;

  BEGIN

    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                       TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                       TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                                  A.HEADER, A.footer, A.user_id
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
      v_det.assd_name            := A.assd_name;
      v_det.assd_add1            := A.address1;
      v_det.assd_add2            := A.address2;
      v_det.assd_add3            := A.address3;
      v_det.incept                := A.incept_date;
      v_det.expiry                := A.expiry_date;
      v_det.HEADER                := A.HEADER;
      v_det.footer                := A.footer;
    END LOOP;

    --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_det.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

    PIPE ROW(v_det);
    RETURN;
  END get_quote_details_fi_fpac;

  FUNCTION get_quote_loc_risk(p_quote_id NUMBER, p_item_no NUMBER)
   RETURN loc_risk_tab PIPELINED IS

   loc_row          loc_risk_type;
   tempo          VARCHAR(500);
  BEGIN

   FOR i IN  (SELECT DISTINCT
                   DECODE(b.loc_risk1,NULL,'',b.loc_risk1||',')||
                   DECODE(b.loc_risk2,NULL,'',b.loc_risk2||',')||
                   DECODE(b.loc_risk3,NULL,'',b.loc_risk3) loki,
                   A.QUOTE_ID quoteid
                 FROM gipi_quote_item c,gipi_quote A,gipi_quote_fi_item b
                WHERE A.quote_id = c.quote_id
                  AND A.quote_id = b.quote_id
                  AND A.quote_id = p_quote_id
                  AND c.item_no  = p_item_no)
  LOOP
       IF i.loki IS NULL OR i.loki = '' OR p_item_no = 0 THEN
            SELECT DISTINCT
               DECODE(z.address1,NULL,'',z.address1||',')||
               DECODE(z.address2,NULL,'',z.address2||',')||
               DECODE(z.address3,NULL,'',z.address3||',')
              INTO tempo
               FROM gipi_quote z
              WHERE quote_id = p_quote_id;
       END IF;

       loc_row.loc_risk := i.loki;


  END LOOP;
   PIPE ROW(loc_row);
   RETURN;-- LOCRISK;
  END;

  FUNCTION get_fire_occupancy(p_quote_id NUMBER) RETURN VARCHAR2 IS
      occupancy    VARCHAR2(100) := NULL;
  BEGIN

     FOR A IN (SELECT DISTINCT occupancy_cd
                    FROM gipi_quote_fi_item
                   WHERE  quote_id = p_quote_id)
       LOOP
               FOR b IN (SELECT occupancy_desc
                           FROM giis_fire_occupancy
                           WHERE  occupancy_cd = A.occupancy_cd )
                   LOOP
                       IF occupancy IS NULL  THEN
                            occupancy:=b.occupancy_desc;
                       ELSE
                          occupancy:=occupancy||chr(10)||b.occupancy_desc;
                       END IF;
                   END LOOP;
       END LOOP;

    RETURN(occupancy);
  END;

  FUNCTION get_warranty_text(p_quote_id NUMBER, a_line_cd VARCHAR2)
    RETURN warranty_text_tab PIPELINED IS
    txt warranty_text_type;
  BEGIN

    FOR i IN (SELECT wc_title, print_sw
                FROM gipi_quote_wc
               WHERE quote_id = p_quote_id
                 AND print_sw = 'Y'
            ORDER BY print_seq_no)
        LOOP

            FOR w IN (SELECT     A.wc_text01 a01, A.wc_text02 a02,    A.wc_text03 a03,    A.wc_text04 a04,
                                A.wc_text05 a05, A.wc_text06 a06,    A.wc_text07 a07,    A.wc_text08 a08,
                                A.wc_text09 a09, A.wc_text10 a10,    A.wc_text11 a11,    A.wc_text12 a12,
                                A.wc_text13 a13, A.wc_text14 a14,   A.wc_text15 a15,    A.wc_text16 a16,
                                A.wc_text17 a17, b.wc_title wtitle
                         FROM giis_warrcla A,
                              gipi_quote_wc b
                        WHERE b.quote_id = p_quote_id
                              AND A.line_cd = a_line_cd
                              AND A.line_cd = b.line_cd
                              AND A.main_wc_cd = b.wc_cd
                              AND b.print_sw = 'Y'
                              AND b.wc_title = i.wc_title --'ACQUIRED/AFFILIATED COMPANIES'
                     ORDER BY b.print_seq_no)
        LOOP
                txt.text1  := NVL(w.a01,' ');    txt.text2  := NVL(w.a02,' ');
                txt.text3  := NVL(w.a03,' ');    txt.text4  := NVL(w.a04,' ');
                txt.text5  := NVL(w.a05,' ');    txt.text6  := NVL(w.a06,' ');
                txt.text7  := NVL(w.a07,' ');    txt.text8  := NVL(w.a08,' ');
                txt.text9  := NVL(w.a09,' ');    txt.text10 := NVL(w.a10,' ');
                txt.text11 := NVL(w.a11,' ');    txt.text12 := NVL(w.a12,' ');
                txt.text13 := NVL(w.a13,' ');    txt.text14 := NVL(w.a14,' ');
                txt.text15 := NVL(w.a15,' ');    txt.text16 := NVL(w.a16,' ');
                txt.text17 := NVL(w.a17,' ');    txt.warranty_title := NVL(w.wtitle,'');
                PIPE ROW(txt);
            END LOOP;
        END LOOP;


    RETURN;
  END get_warranty_text;

/*****************ADDED*BY*WINDELL***********04*15*2011**************UCPB***********/
/*   Added by    : Windell Valle
**   Date Created: April 15, 2011
**   Last Revised: April 15, 2011
**   Description : Get Fire Quote Details
**   Client(s)   : UCPB,...
*/
    FUNCTION get_quote_details_fi_ucpb(p_quote_id NUMBER)
    RETURN quote_fi_details_tab PIPELINED IS

    v_ucpb      quote_fi_details_type;
    v_cnt       NUMBER;
    v_loc_cnt   NUMBER;
    v_occ_cnt   NUMBER;
	v_the_same  VARCHAR2(1); --added by steven 1.24.2013
	v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.24.2013
	v_tot_amt	NUMBER := 0; --added by steven 1.24.2013
	v_tsi_amt	NUMBER := 0; --added by steven 1.24.2013

  BEGIN
    FOR A IN (
            SELECT DISTINCT quote_id,
                   A.line_cd,
                   A.subline_cd,
                   A.iss_cd,
                   user_name, line_name,
                   A.line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||LTRIM(to_char(quotation_no,'0000009'))||'-'||LTRIM(to_char(proposal_no,'09')) quoteno,
                   nvl(decode(c.assd_name2,NULL,c.assd_name,c.assd_name||' '||c.assd_name2), A.assd_name) assd_name,
                   HEADER,footer,
                   incept_date,expiry_date,
                   incept_tag,expiry_tag,
                   accept_dt,
                   valid_date,
                   acct_of_cd,acct_of_cd_sw,
                   address1, address2, address3,
                   decode(address3,NULL,decode(address2,NULL,address1,address1||chr(10)||Address2),
                                        decode(address2,NULL,address1,address1||chr(10)||Address2)||chr(10)||address3) address,
                   A.remarks
              FROM gipi_quote A, giis_line b, giis_assured c, giis_users d
             WHERE A.quote_id = p_quote_id
               AND A.line_cd  = b.line_cd
               AND A.assd_no  = c.assd_no(+)
               AND A.user_id  = d.user_id
               AND A.line_cd  = b.line_cd
            )
  LOOP

      v_ucpb.assd_name            := A.assd_name;
      v_ucpb.assd_add1            := A.address1;
      v_ucpb.assd_add2            := A.address2;
      v_ucpb.assd_add3            := NVL(A.address3,'');
      v_ucpb.HEADER                := A.HEADER;
      v_ucpb.footer                := A.footer;
      v_ucpb.accept_dt            := TO_CHAR(A.accept_dt, 'fmMonth DD, YYYY');
      v_ucpb.line_cd            := A.line_cd;
      v_ucpb.subline_cd            := A.subline_cd;
      v_ucpb.iss_cd             := A.iss_cd;
      v_ucpb.remarks            := A.remarks;
      v_ucpb.expiry               := TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY');
      v_ucpb.incept              := TO_CHAR(A.incept_date, 'fmMonth DD, YYYY');

       BEGIN
        SELECT param_value_v
          INTO v_ucpb.logo_file
          FROM giis_parameters
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      
     FOR A IN (SELECT COUNT(DISTINCT loc_risk1||loc_risk2||loc_risk3) count,
                      COUNT(DISTINCT occupancy_cd) occ_count
                 FROM gipi_quote_fi_item A
                WHERE A.quote_id = p_quote_id)
     LOOP
       v_loc_cnt := A.count;
       v_occ_cnt := A.occ_count;
     END LOOP;
      
     --*> Location of property/risk
     FOR c IN (SELECT decode(loc_risk3,NULL,decode(loc_risk2,NULL,loc_risk1,loc_risk1||chr(10)||loc_risk2),
                                            decode(loc_risk2,NULL,loc_risk1,loc_risk1||chr(10)||loc_risk2)||chr(10)||loc_risk3) address
                 FROM GIPI_QUOTE_FI_ITEM A
                WHERE A.quote_id = p_quote_id)
     LOOP
       IF v_loc_cnt > 1 THEN
          v_ucpb.loc_add := 'Various';
       ELSE   
          v_ucpb.loc_add := c.address;
       END IF;   
     END LOOP;
     --*> Location of property/risk

     FOR c IN (SELECT b.occupancy_desc
                 FROM GIPI_QUOTE_FI_ITEM A,
                      GIIS_FIRE_OCCUPANCY b
                WHERE A.occupancy_cd (+)= b.occupancy_cd
                  AND A.quote_id = p_quote_id)
     LOOP
       IF v_occ_cnt > 1 THEN
          v_ucpb.occupancy_desc := 'Various';
       ELSE   
          v_ucpb.occupancy_desc := c.occupancy_desc;
       END IF;   
     END LOOP;



     --*> Item title
     FOR A IN (SELECT COUNT(DISTINCT item_title) count
                 FROM gipi_quote_item A
                WHERE A.quote_id = p_quote_id)
     LOOP
       v_cnt := A.count;
     END LOOP;

     IF v_cnt > 1 THEN
        v_ucpb.item_title := 'Various';
     ELSE
        FOR i IN (SELECT item_title
                 FROM gipi_quote_item A
                WHERE A.quote_id = p_quote_id)
        LOOP
            v_ucpb.item_title := i.item_title;
        END LOOP;
     END IF;
	 
	 --added by steven 1.24.2013; to check if it has different currency 
	 FOR j IN (SELECT c.short_name 
                 FROM gipi_quote_item A, gipi_quote b, giis_currency c
                WHERE A.quote_id = p_quote_id
                  AND A.quote_id = b.quote_id
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
                  
     FOR d IN (SELECT A.currency_rate, short_name, SUM(nvl(tsi_amt, 0)) tsi_amt
                    FROM gipi_quote_item A, giis_currency b
                WHERE A.quote_id = p_quote_id
                   AND A.currency_cd = b.main_currency_cd
            GROUP BY A.currency_rate, short_name)
     LOOP
	 	IF v_the_same = 'N' THEN --added by steven 1.24.2013
			 v_tsi_amt := v_tsi_amt + (d.tsi_amt * d.currency_rate);
		ELSE
			v_tsi_amt :=  v_tsi_amt + d.tsi_amt;
		END IF;
     END LOOP;
	  v_ucpb.tsi_amt := v_short_name_temp || ' ' || LTRIM(TO_CHAR(v_tsi_amt, '9,999,999,999,999,999.99'));    

     ---*> Premium + Taxes = Total Amount / Annual Premium
     FOR i IN (SELECT A.currency_rt, NVL((A.PREM_AMT+A.TAX_AMT),0) TOTAL_AMT_DUE
                 FROM gipi_quote_invoice A, gipi_quote b, giis_currency c
                WHERE A.quote_id = p_quote_id
                  AND A.quote_id = b.quote_id
                  AND A.currency_cd = c.main_currency_cd)
     LOOP
	 	IF v_the_same = 'N' THEN --added by steven 1.24.2013
			 v_tot_amt := v_tot_amt + (i.total_amt_due * i.currency_rt);
		ELSE
			v_tot_amt :=  v_tot_amt + i.total_amt_due;
		END IF;
    END LOOP;
	v_ucpb.tot_amt := v_short_name_temp||' '||ltrim(to_char(v_tot_amt,'9,999,999,999,999,999.99'));
	
  END LOOP;
    PIPE ROW(v_ucpb);
    RETURN;
  END get_quote_details_fi_ucpb;
/*****************ADDED*BY*WINDELL***********04*15*2011**************UCPB***********/



/*****************ADDED*BY*WINDELL***********04*15*2011**************UCPB***********/
/*   Added by    : Windell Valle
**   Date Created: April 15, 2011
**   Last Revised: April 15, 2011
**   Description : Get Fire Quote Signatory
**   Client(s)   : UCPB,...
*/
  FUNCTION get_fire_signatory(p_quote_id NUMBER, p_iss_cd VARCHAR2)
  RETURN fire_signatory_tab PIPELINED IS
      v_sig    fire_signatory_type;
  BEGIN

     FOR sig IN (SELECT SIGNATORY,DESIGNATION
                           FROM GIIS_SIGNATORY A,GIIS_SIGNATORY_NAMES B
                     WHERE NVL(A.REPORT_ID,'FI_QUOTE') = 'FI_QUOTE'
                       AND nvl(A.iss_cd,p_iss_cd) = p_iss_cd
                       AND current_signatory_sw = 'Y'
                       AND A.signatory_id = b.signatory_id    )
      LOOP
          v_sig.sig_name := sig.signatory;
          v_sig.sig_des := sig.designation;
      END LOOP;

    PIPE ROW(v_sig);
    RETURN;
  END;
/*****************ADDED*BY*WINDELL***********04*15*2011**************UCPB***********/

  FUNCTION get_fi_quote_itemperil(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_fi_itemperil_tab PIPELINED IS
    v_itmperl   quote_fi_itemperil_type;
  BEGIN
    FOR i IN (SELECT DISTINCT b.peril_name  peril_name, 
                     b.peril_lname peril_lname
                FROM giis_peril b,
                     gipi_quote_itmperil A,
                     gipi_quote c,
                     gipi_quote_item d
               WHERE A.peril_cd = b.peril_cd
                 AND A.quote_id = c.quote_id
                 AND A.quote_id = P_QUOTE_ID
                 AND b.line_cd  = c.line_cd
                 AND A.item_no = d.item_no
                 AND A.quote_id = d.quote_id)
    LOOP
     
      v_itmperl.peril_name               := i.peril_name;
      v_itmperl.peril_lname              := i.peril_lname;
      PIPE ROW(v_itmperl);
    END LOOP;
    RETURN; 
  END get_fi_quote_itemperil;

END QUOTE_REPORTS_FI_PKG;
/


