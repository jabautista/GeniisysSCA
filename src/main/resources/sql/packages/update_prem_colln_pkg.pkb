CREATE OR REPLACE PACKAGE BODY CPI.update_prem_colln_pkg
AS

  /* Created by  		  : Angelo Pagaduan
  ** Date Created		  :03.01.2011
  ** Reference By		  : (GIACS090 - Acknowledgment Receipt - GPDC_PREM block - update_but)
  ** Description		  : these are procedures to be used in update_but when-button-pressed trigger
  */

  PROCEDURE fetch_prem_colln_update_values(
		p_prem_seq_no	IN		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_iss_cd		IN		GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_intm_name		OUT		GIIS_INTERMEDIARY.intm_name%TYPE,
		p_policy_id		OUT		GIPI_COMM_INVOICE.policy_id%TYPE,
		p_add1			OUT		GIPI_POLBASIC.address1%TYPE,
		p_add2			OUT		GIPI_POLBASIC.address2%TYPE,
		p_add3			OUT		GIPI_POLBASIC.address3%TYPE,
		p_mail			OUT		VARCHAR2
  )

  IS

  BEGIN

	   FOR c2 IN(SELECT b.intm_name, a.policy_id
				   FROM gipi_comm_invoice a,
				   		giis_intermediary b
			      WHERE a.intrmdry_intm_no = b.intm_no
				    AND a.prem_seq_no = p_prem_seq_no
				    AND a.iss_cd = p_iss_cd)
	   LOOP
		   p_intm_name := c2.intm_name;
		   p_policy_id := c2.policy_id;
	   END LOOP;

	   FOR c3 IN (SELECT address1 add1, address2 add2, address3 add3,
					     LTRIM(RTRIM(address1||''||address2||''||address3)) mail
				    FROM gipi_polbasic
				   WHERE policy_id = p_policy_id)
	   LOOP
		   p_add1 := c3.add1;
		   p_add2 := c3.add2;
		   p_add3 := c3.add3;
		   p_mail := c3.mail;
	   END LOOP;

  END fetch_prem_colln_update_values;

  FUNCTION get_particulars_1(
  		p_apdc_id		   GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
		p_pdc_id		   GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
		p_item_no		   GIAC_APDC_PAYT_DTL.item_no%TYPE
  ) RETURN VARCHAR2

  IS
  	 v_name		   VARCHAR2(100);
	 ctr		   NUMBER := 0;
  BEGIN
  	   	FOR a IN (SELECT DISTINCT  rtrim(a.line_cd) || '-' || rtrim(a.subline_cd) || '-' || rtrim(a.iss_cd) ||
	   							   '-' || ltrim(to_char(a.issue_yy)) || '-' || ltrim(to_char(a.pol_seq_no)) ||
	   							   decode(a.endt_seq_no,0,NULL, '-' ||a.endt_iss_cd ||'-'||ltrim(to_char(a.endt_yy))||
	   							   '-' ||ltrim(to_char(a.endt_seq_no)) || '-' || rtrim(a.endt_type))||'-'||
	   							   ltrim(to_char(a.renew_no)) policy_no
          			FROM GIPI_POLBASIC a,
               			 gipi_invoice b,
	             			 giac_apdc_payt c,
	             			 giac_apdc_payt_dtl d,
               			 giac_pdc_prem_colln e
         			 WHERE a.policy_id = b.policy_id
                 	   AND b.prem_seq_no = e.prem_seq_no
                 	   AND b.iss_cd = e.ISS_CD
                 	   AND c.apdc_id = d.apdc_id
                 	   AND d.pdc_id = e.pdc_id
					   --AND c.apdc_no = :giap.apdc_no		--mod1 start/end
					   AND d.apdc_id = p_apdc_id
					   AND d.pdc_id  = p_pdc_id
					   AND d.item_no = p_item_no
				  )
		LOOP
			ctr := ctr + 1;
			IF (ctr = 1) THEN
			   v_name := a.policy_no;
			ELSE
			   v_name := v_name || '/' || a.policy_no;
			END IF;
		END LOOP;

		RETURN v_name;
  END get_particulars_1;

  FUNCTION get_particulars_2A(
  		p_apdc_id		   GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
		p_pdc_id		   GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
		p_item_no		   GIAC_APDC_PAYT_DTL.item_no%TYPE
  ) RETURN VARCHAR2

  IS
  	 v_name		   		VARCHAR2(100);
	 v_sub_part			giac_apdc_payt_dtl.particulars%TYPE;
	 v_particulars2  	giac_apdc_payt_dtl.particulars%TYPE;
     v_particulars3  	giac_apdc_payt_dtl.particulars%TYPE;
  BEGIN

	   FOR c in (SELECT SUBSTR(particulars,1,INSTR (particulars,'r', 1,3))sub_part
                  FROM giac_apdc_payt
                 --WHERE apdc_no = :giap.apdc_no)	--mod3 start
                 WHERE apdc_id = p_apdc_id)		--mod3 end
       LOOP
           v_sub_part := c.sub_part;
           v_particulars2 := UPDATE_PREM_COLLN_PKG.get_particulars_1(p_apdc_id, p_pdc_id, p_item_no);
           v_particulars3 := v_sub_part||' '||v_particulars2;
           --IF v_particulars3 = v_particulars THEN--updated previously		--mod4 start
       END LOOP;

	   RETURN v_particulars3;

  END get_particulars_2A;

  FUNCTION get_particulars_2(
  		p_apdc_id			 GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
		p_curr_particulars	 VARCHAR2
  ) RETURN VARCHAR2

  IS
  	 v_name		   		VARCHAR2(500);
	 v_sub_part			giac_apdc_payt_dtl.particulars%TYPE;
	 v_particulars2  	giac_apdc_payt_dtl.particulars%TYPE;
     v_particulars3  	giac_apdc_payt_dtl.particulars%TYPE;
  BEGIN

	   FOR c in (SELECT SUBSTR(particulars,1,INSTR (particulars,'r', 1,3))sub_part
                  FROM giac_apdc_payt
                 --WHERE apdc_no = :giap.apdc_no)	--mod3 start
                 WHERE apdc_id = p_apdc_id)		--mod3 end
       LOOP
           v_sub_part := c.sub_part;
           v_particulars2 := UPDATE_PREM_COLLN_PKG.get_particulars_1A(p_apdc_id);
           v_particulars3 := v_sub_part||' '||v_particulars2;
           --IF v_particulars3 = v_particulars THEN--updated previously		--mod4 start
       END LOOP;

	   RETURN v_particulars3;

  END get_particulars_2;

  FUNCTION get_particulars_1A(
  		p_apdc_id			 GIAC_APDC_PAYT_DTL.apdc_id%TYPE
  ) RETURN VARCHAR2

  IS
	 v_name VARCHAR2(500);
	 ctr  number := 0;

  BEGIN
  	   /* ommited DISTINCT by april as of 06/25/2009 to update the staus*/
	   FOR a IN (SELECT /*DISTINCT*/ rtrim(a.line_cd) || '-' || rtrim(a.subline_cd) || '-' || rtrim(a.iss_cd) ||
	   							 '-' || ltrim(to_char(a.issue_yy)) || '-' || ltrim(to_char(a.pol_seq_no)) ||
	   							 decode(a.endt_seq_no,0,NULL, '-' ||a.endt_iss_cd ||'-'||ltrim(to_char(a.endt_yy))||
	   							 '-' ||ltrim(to_char(a.endt_seq_no)) || '-' || rtrim(a.endt_type))||'-'||
	   							 ltrim(to_char(a.renew_no)) policy_no
          		   FROM GIPI_POLBASIC a,
               			gipi_invoice b,
	             		giac_apdc_payt c,
	             		giac_apdc_payt_dtl d,
               			giac_pdc_prem_colln e
         		  WHERE a.policy_id = b.policy_id
	                AND b.prem_seq_no = e.prem_seq_no
		            AND b.iss_cd = e.ISS_CD
		            AND c.apdc_id = d.apdc_id
		            AND d.pdc_id = e.pdc_id
				    --AND  c.apdc_no = :giap.apdc_no				--mod1 start
				 	AND  c.apdc_id = p_apdc_id					--mod1 end
				)
  	   LOOP
  		   ctr := ctr + 1;
		   IF (ctr = 1) THEN
			  v_name := a.policy_no;
		   ELSE
			  v_name := v_name || '/' || a.policy_no;
		   END IF;
  	   END LOOP;

  	   RETURN (v_name);
  END get_particulars_1A;

END;
/


