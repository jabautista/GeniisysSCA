CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_AH_PKG AS

   FUNCTION get_ah_quote(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_ah_tab PIPELINED
    IS

    v_quote                         quote_ah_type;

  BEGIN
    FOR d IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no,
										 a.assd_name assd_name, nvl(a.address1,' ') address1,
                                         nvl(a.address2, ' ') address2,
                                         nvl(a.address3, ' ') address3,
										 --comment out by rochelle, 030507 : bcoz if incept_tag Y are equal to 'Y', return 'TBA'
 	                   DECODE (a.incept_tag,'Y','TBA',TO_CHAR(a.incept_date, 'fmMonth DD, YYYY')) incept_date1,
 	                   DECODE (a.expiry_tag,'Y','TBA',TO_CHAR(a.expiry_date, 'fmMonth DD, YYYY')) expiry_date1,
 	                   TO_CHAR(a.incept_date, 'fmMonth DD, YYYY') incept_date,
 	                   TO_CHAR(a.expiry_date, 'fmMonth DD, YYYY') expiry_date,
 	                   a.header, a.footer,a.accept_dt,a.incept_tag,a.expiry_tag, to_char(nvl(a.tsi_amt,0),'fm999,999,999,999.90')tsi_amt,
 	                   a.remarks, a.line_cd, a.subline_cd
 	              FROM gipi_quote a
 	             WHERE quote_id = p_quote_id)
 	  LOOP
 	  	v_quote.quote_no		:= d.quote_no;
 	  	v_quote.assd_name		:= d.assd_name;
 	  	v_quote.address1		:= d.address1;
 	  	v_quote.address2		:= d.address2;
 	  	v_quote.address3		:= d.address3;
 	  	v_quote.incept_date		:= d.incept_date;
 	  	v_quote.incept_date1    := d.incept_date1;
 	  	v_quote.expiry_date1    := d.expiry_date1;
 	  	v_quote.expiry_date	    := d.expiry_date;
 	  	v_quote.header   		:= d.header;
 	  	v_quote.footer  		:= d.footer;
 	  	v_quote.accept_dt		:= d.accept_dt;
 	  	v_quote.incept_tag 		:= d.incept_tag;
 	  	v_quote.expiry_tag		:= d.expiry_tag;
 	  	v_quote.tsi_amt  		:= d.tsi_amt;
 	  	v_quote.remarks         := d.remarks;
 	  	v_quote.line_cd     	:= d.line_cd;
 	  	v_quote.subline_cd      := d.subline_cd;
        v_quote.title           := 'Attention';
        v_quote.title1          := 'Occupation';
        v_quote.title2          := 'Itinerary(Travel Only)';
        v_quote.title3          := 'No. of persons covered';
        v_quote.title4	    	:= 'Period of Insurance';



        FOR c IN (SELECT no_of_persons, destination, position
  				    FROM gipi_quote_ac_item a,
       					 giis_position b
 				   WHERE a.position_cd = b.position_cd
   						 AND quote_id = p_quote_id)
          LOOP
		      v_quote.position       := c.position;
		      v_quote.destination    := c.destination;
		      v_quote.no_of_persons  := c.no_of_persons;

         END LOOP;

       FOR A IN (SELECT nvl(prem_amt,0) prem
 	  					FROM gipi_quote_item
 	  					WHERE  quote_id = p_quote_id)
 	     LOOP

          v_quote.prem_amt:=a.prem;
 	     END LOOP;

       FOR b IN (SELECT to_char((sum(nvl(prem_amt,0))+sum(nvl(tax_amt,0))),'fm999,999,999,999.90') total
 	  					FROM gipi_quote_invoice
 	  					WHERE  quote_id = p_quote_id )
 	  	 LOOP
 	  		v_quote.total := b.total;
         END LOOP;

       FOR p IN (SELECT wc_title
 	  					FROM gipi_quote_wc
 	  					WHERE  quote_id = p_quote_id )
 	  			LOOP
 	  			v_quote.wc_title:=p.wc_title;
 	            END LOOP;

       PIPE ROW (v_quote);

 	  END LOOP;


  END;

   FUNCTION get_ah_quote_invtax(p_quote_id  GIPI_QUOTE.quote_id%TYPE)
     RETURN ah_quote_invtax_tab PIPELINED IS
	v_ah_tax  ah_quote_invtax_type;

   BEGIN
    FOR i IN(SELECT e.tax_desc , b.tax_amt tax_amt_num,
                    to_char((SUM(DISTINCT b.tax_amt)), 'fm999,999,999,999.90') tax_amt
               FROM gipi_quote_invoice a,
                    gipi_quote_invtax b,
                    gipi_quote_item c,
                    gipi_quote d,
                    giis_tax_charges e
              WHERE c.currency_cd = a.currency_cd
                AND d.quote_id = p_quote_id
                AND a.quote_inv_no = b.quote_inv_no
                AND a.quote_id = c.quote_id
                AND a.quote_id = d.quote_id
                AND b.iss_cd = a.iss_cd
                AND b.iss_cd = e.iss_cd
                AND b.line_cd = e.line_cd
                AND b.tax_cd = e.tax_cd
                AND e.line_cd = 'AH'
          GROUP BY  b.tax_cd, e.tax_desc, b.tax_amt)

       LOOP

        	if v_ah_tax.tax_desc  is null  then
 	      	   v_ah_tax.tax_desc :=i.tax_desc;
 	  		else
 	  		   v_ah_tax.tax_desc := v_ah_tax.tax_desc ||chr(10)||i.tax_desc;
 	  		end if;

            if v_ah_tax.tax_amt  is null  then
 	  	       v_ah_tax.tax_amt :=i.tax_amt;
 	        else
 	      	   v_ah_tax.tax_amt := v_ah_tax.tax_amt ||chr(10)||i.tax_amt;
 	  		end if;
           --v_ah_tax.tax_desc   := i.tax_desc;
           v_ah_tax.tax_amt_num   := i.tax_amt_num;
           PIPE ROW (v_ah_tax);
       END LOOP;
   END;

   FUNCTION get_ah_quote_perils(p_quote_id		GIPI_QUOTE.quote_id%TYPE)
    RETURN ah_quote_perils_tab PIPELINED IS
	v_ah_perils  ah_quote_perils_type;

    BEGIN
    FOR i IN(SELECT b.peril_name PERIL_NAME,
                    to_char(nvl(a.tsi_amt,0), 'fm999,999,999,999.90') tsi

               FROM giis_peril b,
                    gipi_quote_itmperil a,
                    gipi_quote c,
                    gipi_quote_item d
              WHERE a.peril_cd = b.peril_cd
                AND a.quote_id = c.quote_id
                AND a.quote_id = p_quote_id
                AND b.line_cd  = c.line_cd
                AND a.item_no = d.item_no
                AND a.quote_id = d.quote_id
           ORDER BY a.item_no, b.peril_name)

     LOOP

        	if v_ah_perils.peril_name  is null  then
 	      	   v_ah_perils.peril_name :=i.peril_name;
 	  		else
 	  		   v_ah_perils.peril_name := v_ah_perils.peril_name ||chr(10)||i.peril_name;
 	  		end if;

            if v_ah_perils.tsi_amt  is null  then
 	  	       v_ah_perils.tsi_amt :=i.tsi;
 	        else
 	      	   v_ah_perils.tsi_amt := v_ah_perils.tsi_amt ||chr(10)||i.tsi;
 	  		end if;
        --v_ah_perils.peril_name    := i.peril_name;
        --v_ah_perils.tsi_amt       := i.tsi_amt;
        PIPE ROW (v_ah_perils);
     END LOOP;
    END;

  FUNCTION get_ah_quote_warranty(p_quote_id    GIPI_QUOTE.quote_id%TYPE)
  RETURN ah_quote_warranty_tab PIPELINED IS

    v_war  ah_quote_warranty_type;
    text VARCHAR2(5000);
  BEGIN
    --warranty
     FOR warr IN ( SELECT wc_title, print_sw
                 FROM gipi_quote_wc
                WHERE quote_id = p_quote_id
               ORDER BY	print_seq_no)
     LOOP

       v_war.print_sw := warr.print_sw;
       v_war.wc_title := warr.wc_title;
        IF v_war.print_sw = 'Y' THEN
           v_war.wc_title := warr.wc_title;
        ELSE
           v_war.wc_title := '';
        END IF;


      PIPE ROW(v_war);
     END LOOP;


     RETURN;
   END;

END QUOTE_REPORTS_AH_PKG;
/


