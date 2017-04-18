CREATE OR REPLACE PACKAGE BODY CPI.P_Bus_Conservation AS
  PROCEDURE get_data(
    p_line_cd     IN VARCHAR2,
    p_subline_cd  IN VARCHAR2,
    p_iss_cd      IN VARCHAR2,
    p_intm_no     IN NUMBER,
	p_from_date   IN DATE,
    p_to_date     IN DATE,
	p_del_table   IN VARCHAR2)
  AS
    TYPE line_tab        IS TABLE OF gipi_polbasic.line_cd%TYPE;
	TYPE subline_tab 	 IS TABLE OF gipi_polbasic.subline_cd%TYPE;
	TYPE iss_tab      	 IS TABLE OF gipi_polbasic.iss_cd%TYPE;
	TYPE prem_tab    	 IS TABLE OF giex_ren_ratio.prem_amt%TYPE;
	TYPE policy_tab  	 IS TABLE OF giex_ren_ratio.nop%TYPE;
	TYPE renew_tab   	 IS TABLE OF giex_ren_ratio.nrp%TYPE;
	TYPE new_tab   	 	 IS TABLE OF giex_ren_ratio.nnp%TYPE; --jerome 081805
	TYPE exp_month_tab	 IS TABLE OF giex_ren_ratio.MONTH%TYPE;
	TYPE exp_year_tab	 IS TABLE OF giex_ren_ratio.YEAR%TYPE;
	TYPE region_tab		 IS TABLE OF giex_ren_ratio.region_cd%TYPE;
	vv_line_cd		 line_tab;
	vv_subline_cd	 subline_tab;
	vv_iss_cd		 iss_tab;
	vv_prem_amt	     prem_tab;
	vv_policy_cnt	 policy_tab;
	vv_renew_cnt	 renew_tab;
	vv_new_cnt		 new_tab;  -- jerome 08182005
	vv_exp_month	 exp_month_tab;
	vv_exp_year		 exp_year_tab;
	vv_region_cd	 region_tab;
	vv_renew_amt	 prem_tab;
	vv_new_amt		 prem_tab; -- jerome 08182005
	v_ri_cd		     gipi_polbasic.iss_cd%TYPE;
  BEGIN
    --dbms_profiler.start_profiler('ANY COMMENT TO IDENTIFY THIS EXECUTION');
	IF p_del_table = 'Y' THEN
	   DELETE FROM giex_ren_ratio
         WHERE user_id = USER;
  	   COMMIT;
	END IF;

    v_ri_cd := Giisp.v('ISS_CD_RI');
	IF v_ri_cd IS NULL THEN
       RAISE_APPLICATION_ERROR(2220,INITCAP('RI CODE HAS NOT BEEN SET UP IN GIIS_PARAMETERS.'));
    END IF;

	/*SELECT a.line_cd          line_cd,
  		   a.subline_cd       subline_cd,
		   a.iss_cd           iss_cd,
   	       SUM(a.prem_amt)    prem_amt,
		   get_prem_of_renew(a.line_cd,a.subline_cd,
		   				 	     a.iss_cd,a.issue_yy,
							     a.pol_seq_no) renew_prem_amt,
   	       COUNT(a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||
		                  a.pol_seq_no||a.renew_no) count_policy,
		   get_renew_pol(a.line_cd,a.subline_cd,
		   				 	 a.iss_cd,a.issue_yy,
							 a.pol_seq_no) count_renew_pol,
		   get_expiry_month (a.line_cd,a.subline_cd,
		   				 	 a.iss_cd,a.issue_yy,
							 a.pol_seq_no,a.renew_no) expiry_month,
		   get_expiry_year  (a.line_cd,a.subline_cd,
		   					 a.iss_cd,a.issue_yy,
							 a.pol_seq_no,a.renew_no) expiry_year,
		   NVL(a.region_cd,d.region_cd) region_cd
    BULK COLLECT INTO
	       vv_line_cd,
		   vv_subline_cd,
		   vv_iss_cd,
		   vv_prem_amt,
		   vv_renew_amt,
		   vv_policy_cnt,
		   vv_renew_cnt,
		   vv_exp_month,
		   vv_exp_year,
		   vv_region_cd
      FROM GIPI_POLBASIC a,
           GIIS_SUBLINE b,
		   GIPI_COMM_INVOICE c,
		   GIIS_ISSOURCE d
     WHERE 1 = 1
	   AND a.pol_flag IN ('1','2','3')
       AND a.iss_cd     <> 'RI'
       AND a.endt_seq_no = 0
       AND a.expiry_tag  = 'N'
       AND b.op_flag     = 'N'
       AND a.line_cd     = b.line_cd
	   AND a.subline_cd  = b.subline_cd
	   AND c.iss_cd		 = a.iss_cd
	   AND d.iss_cd      = a.iss_cd
	   AND c.policy_id   = a.policy_id
	   AND Check_Date(a.line_cd,
	   	   			  a.subline_cd,
					  a.iss_cd,
					  a.issue_yy,
					  a.pol_seq_no,
					  a.renew_no,
					  p_from_date,
					  p_to_date ) BETWEEN p_from_date AND p_to_date
	   AND a.line_cd     = NVL(p_line_cd,a.line_cd)
	   AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
	   AND a.iss_cd      = NVL(p_iss_cd,a.iss_cd)
	   AND c.intrmdry_intm_no = NVL(p_intm_no,c.intrmdry_intm_no)
     GROUP BY a.line_cd,a.subline_cd,a.iss_cd,
	          get_expiry_month (a.line_cd,a.subline_cd,
		   				 	    a.iss_cd,a.issue_yy,
				 			    a.pol_seq_no,a.renew_no) ,
 	  	      get_expiry_year  (a.line_cd,a.subline_cd,
		   					    a.iss_cd,a.issue_yy,
							    a.pol_seq_no,a.renew_no),
			  NVL(a.region_cd,d.region_cd),
			  get_renew_pol(a.line_cd,a.subline_cd,
		   				 	 a.iss_cd,a.issue_yy,
							 a.pol_seq_no),
  			  get_prem_of_renew(a.line_cd,a.subline_cd,
		   				 	     a.iss_cd,a.issue_yy,
							     a.pol_seq_no)
			  ;*/
    /*SELECT line_cd,
		   subline_cd,
		   iss_cd,
		   SUM(prem_amt) prem_amt,
		   SUM(DECODE(renewal_tag,'Y',prem_amt,0)) renew_amt,
		   COUNT(policy_id) cnt_pol,
		   COUNT(DECODE(renewal_tag,'Y',policy_id)) cnt_ren,
		   MONTH,
		   YEAR,
		   region_cd*/
	/* new SELECT to include number of new policies*/
	SELECT line_cd,
		   subline_cd,
		   iss_cd,
		   SUM(prem_amt) prem_amt,
		   SUM(DECODE(pol_flag,'1', prem_amt, 0)) new_amt,
		   SUM(DECODE(renewal_tag,'Y',prem_renew_amt,0)) renew_amt,
		   COUNT(policy_id) cnt_pol,
   		   COUNT(DECODE(pol_flag,'1',policy_id)) cnt_new,
		   COUNT(DECODE(renewal_tag,'Y',policy_id)) cnt_ren,
		   MONTH,
		   YEAR,
		   region_cd
 BULK COLLECT INTO
	       vv_line_cd,
		   vv_subline_cd,
		   vv_iss_cd,
		   vv_prem_amt,
		   vv_new_amt,
		   vv_renew_amt,
		   vv_policy_cnt,
		   vv_new_cnt,
		   vv_renew_cnt,
		   vv_exp_month,
		   vv_exp_year,
		   vv_region_cd
  	  FROM giex_ren_ratio_dtl
	 WHERE user_id = USER
     GROUP BY line_cd,
	       subline_cd,
	       iss_cd,YEAR,MONTH,region_cd;
	IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
	      INSERT INTO giex_ren_ratio
		    (line_cd, 			subline_cd,			  iss_cd,
			 nop,				nnp,				  nrp,
			 prem_amt,			MONTH,				  YEAR,
			 user_id,			last_update,		  prem_renew_amt,
			 prem_new_amt,       region_cd)
		  VALUES
		    (vv_line_cd(cnt),	vv_subline_cd(cnt),   vv_iss_cd(cnt),
			 vv_policy_cnt(cnt),vv_new_cnt(cnt),			  vv_renew_cnt(cnt),
			 vv_prem_amt(cnt),  vv_exp_month(cnt),	  vv_exp_year(cnt),
			 USER,				SYSDATE,			  vv_renew_amt(cnt),
			 vv_new_amt(cnt),	vv_region_cd(cnt));
	END IF;
	COMMIT;
	--get dummy data
--	IF p_del_table = 'N' THEN
  	   SELECT d.line_cd,d.subline_cd,d.iss_cd,d.YEAR
	     BULK COLLECT INTO
		     vv_line_cd,vv_subline_cd,vv_iss_cd,vv_exp_year
         FROM (SELECT DISTINCT a.line_cd,a.subline_cd,a.iss_cd,b.YEAR
                 FROM giex_ren_ratio a,(SELECT DISTINCT YEAR
				 	                      FROM giex_ren_ratio
										 WHERE user_id = USER
										 GROUP BY iss_cd,line_cd,subline_cd,YEAR) b
				WHERE a.user_id=USER) d
        WHERE NOT EXISTS ( SELECT 1
 	  	  		 	         FROM giex_ren_ratio c
					        WHERE c.line_cd = d.line_cd
					          AND c.subline_cd = d.subline_cd
					          AND c.iss_cd = d.iss_cd
					          AND c.YEAR = d.YEAR
							  AND c.user_id = USER);
		IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
	      INSERT INTO giex_ren_ratio
		    (line_cd, 			subline_cd,			  iss_cd,
			 nop,				nrp,				  prem_amt,
			 MONTH,				YEAR,				  user_id,
			 last_update,		prem_renew_amt, 	  region_cd,
			 nnp, 				prem_new_amt)
		  VALUES
		    (vv_line_cd(cnt),	vv_subline_cd(cnt),   vv_iss_cd(cnt),
			 0,					0,					  0,
			 0,					vv_exp_year(cnt),	  USER,
			 SYSDATE,			0,					  NULL,
			 0,					0);
	   END IF;
	  COMMIT;
--    END IF;
--dbms_profiler.stop_profiler;
  END;

  FUNCTION get_prem_of_renew(
  /* rollie 21 june 2004
  ** to get the prem of policy if it is renewed
  **/
  	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE)
  RETURN NUMBER AS
    v_prem_renew NUMBER(18,2) := 0;
  BEGIN
  	SELECT SUM(a.prem_amt)
	  INTO v_prem_renew
      FROM gipi_polbasic a
     WHERE EXISTS  (SELECT 1
 	   		  	    FROM gipi_polnrep b
				   WHERE b.old_policy_id = a.policy_id)
   	   AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
 	   AND a.iss_cd      = p_iss_cd
	   AND a.issue_yy    = p_issue_yy
	   AND a.pol_seq_no  = p_pol_seq_no;
	RETURN v_prem_renew;
  END;

  FUNCTION get_prem_of_new(
  /* rollie 21 june 2004
  ** to get the prem of policy if it is renewed
  **/
  	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE)
  RETURN NUMBER AS
    v_prem_new NUMBER(18,2) := 0;
  BEGIN
  	SELECT SUM(a.prem_amt)
	  INTO v_prem_new
      FROM gipi_polbasic a
     WHERE a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
 	   AND a.iss_cd      = p_iss_cd
	   AND a.issue_yy    = p_issue_yy
	   AND a.pol_seq_no  = p_pol_seq_no
	   AND a.pol_flag	 = '1';
	RETURN v_prem_new;
  END;





  FUNCTION Check_Date(
  /** rollie 18 Feb 2004
  *** date parameter of the last endorsement of policy
  *** must not be within the date given, else it will
  *** be exluded
  **/
	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no	    gipi_polbasic.renew_no%TYPE,
	p_from_date	    DATE,
	p_to_date	    DATE)
  RETURN DATE AS
  	v_check_date  DATE;
  BEGIN
	FOR a IN (
      SELECT a.expiry_date expiry_date
        FROM gipi_polbasic a
	   WHERE a.line_cd     = p_line_cd
	     AND a.subline_cd  = p_subline_cd
 	     AND a.iss_cd      = p_iss_cd
	     AND a.issue_yy    = p_issue_yy
	     AND a.pol_seq_no  = p_pol_seq_no
	     AND a.renew_no    = p_renew_no
	     AND a.endt_seq_no IN ( SELECT MAX(endt_seq_no)
		 	 			   	      FROM gipi_polbasic b
						         WHERE a.line_cd = b.line_cd
                                   AND a.subline_cd = b.subline_cd
							       AND a.iss_cd = b.iss_cd
							       AND a.issue_yy = b.issue_yy
							       AND a.pol_seq_no = b.pol_seq_no
							       AND a.renew_no  = b.renew_no))
      LOOP
  	    v_check_date := a.expiry_date;
      END LOOP;
	  RETURN v_check_date;
  END;

  FUNCTION get_renew_pol(
  /* rollie 15 June 2004
  ** get the count the number of policies that
  ** has been renewed
  */
    p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE)
  RETURN NUMBER AS
    v_renew_pol_cnt	 NUMBER(8) := 0;
  BEGIN
    SELECT COUNT(a.policy_id)
	  INTO v_renew_pol_cnt
	  FROM gipi_polbasic a
	 WHERE EXISTS (SELECT 1
	                 FROM gipi_polnrep b
					WHERE a.policy_id = b.old_policy_id)
	   AND a.line_cd     = p_line_cd
       AND a.subline_cd  = p_subline_cd
 	   AND a.iss_cd      = p_iss_cd
	   AND a.issue_yy    = p_issue_yy
	   AND a.pol_seq_no  = p_pol_seq_no;
	RETURN(v_renew_pol_cnt);
  END;

  FUNCTION get_expiry_year(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no	    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
  	v_year          NUMBER(4):=0;
  BEGIN
    FOR a IN (
	  SELECT TO_NUMBER(TO_CHAR(a.expiry_date,'YYYY')) expiry_date
	--    INTO v_year
        FROM gipi_polbasic a
	   WHERE a.line_cd     = p_line_cd
	     AND a.subline_cd  = p_subline_cd
 	     AND a.iss_cd      = p_iss_cd
	     AND a.issue_yy    = p_issue_yy
	     AND a.pol_seq_no  = p_pol_seq_no
	     AND a.renew_no    = p_renew_no
	     AND a.endt_seq_no IN ( SELECT MAX(endt_seq_no)
		 	 			   	      FROM gipi_polbasic b
						         WHERE a.line_cd = b.line_cd
                                   AND a.subline_cd = b.subline_cd
							       AND a.iss_cd = b.iss_cd
							       AND a.issue_yy = b.issue_yy
							       AND a.pol_seq_no = b.pol_seq_no
							       AND a.renew_no  = b.renew_no))
	LOOP
	  v_year := a.expiry_date;
	  EXIT;
	END LOOP;
    RETURN v_year;
  END;
  FUNCTION get_expiry_month(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no	    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
  	v_month          NUMBER(2):=0;
  BEGIN
    FOR a IN (
	  SELECT TO_NUMBER(TO_CHAR(a.expiry_date,'MM'))   expiry_date
      --  INTO v_month
	    FROM gipi_polbasic a
	   WHERE a.line_cd     = p_line_cd
	     AND a.subline_cd  = p_subline_cd
 	     AND a.iss_cd      = p_iss_cd
	     AND a.issue_yy    = p_issue_yy
	     AND a.pol_seq_no  = p_pol_seq_no
	     AND a.renew_no    = p_renew_no
	     AND a.endt_seq_no  IN ( SELECT MAX(endt_seq_no)
		 	 			   	      FROM gipi_polbasic b
						         WHERE a.line_cd = b.line_cd
                                   AND a.subline_cd = b.subline_cd
							       AND a.iss_cd = b.iss_cd
							       AND a.issue_yy = b.issue_yy
							       AND a.pol_seq_no = b.pol_seq_no
							       AND a.renew_no  = b.renew_no))
	LOOP
	  v_month := a.expiry_date;
	  EXIT;
	END LOOP;
    RETURN v_month;
  END;
  FUNCTION Get_Endt_Seq_No(
    /** rollie 02/18/04
    *** get the latest endorsement number of a policy
    **/
    p_line_cd     gipi_polbasic.line_cd%TYPE,
    p_subline_cd  gipi_polbasic.subline_cd%TYPE,
    p_iss_cd      gipi_polbasic.iss_cd%TYPE,
	p_issue_yy    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
    v_endt_seq_no gipi_polbasic.endt_seq_no%TYPE;
  BEGIN
    SELECT MAX(endt_seq_no)
      INTO v_endt_seq_no
      FROM gipi_polbasic a
     WHERE a.line_cd = p_line_cd
       AND a.subline_cd = p_subline_cd
       AND a.iss_cd = p_iss_cd
       AND a.issue_yy = p_issue_yy
       AND a.pol_seq_no = p_pol_seq_no
       AND a.renew_no  = p_renew_no;
    RETURN (v_endt_seq_no);
  END;
END;
/


DROP PACKAGE BODY CPI.P_BUS_CONSERVATION;
