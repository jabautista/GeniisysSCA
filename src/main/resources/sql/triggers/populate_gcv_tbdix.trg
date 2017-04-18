DROP TRIGGER CPI.POPULATE_GCV_TBDIX;

CREATE OR REPLACE TRIGGER CPI.POPULATE_GCV_TBDIX
/* Nathan 06182001 */
/* The old trigger can be found at the end of this revision */
BEFORE INSERT OR DELETE ON CPI.GIAC_DIRECT_PREM_COLLNS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  DECLARE
	v_cv_tran_id		GIAC_COMM_VOUCHER.cv_tran_id%TYPE;
	v_net_prem		NUMBER(12,2);
	v_other_charges		NUMBER(12,2);
	v_tax_due  		GIPI_COMM_INVOICE.wholding_tax%TYPE;
	v_comm_due  		GIPI_COMM_INVOICE.commission_amt%TYPE;
	v_or_no			GIAC_ORDER_OF_PAYTS.or_no%TYPE;
	v_share_pct  		NUMBER(12,9);
	v_pctage_due  		NUMBER(12,9);
	v_tran_class		VARCHAR2(3);
	v_switch		NUMBER(1);
 	v_ref_no		GIAC_COMM_VOUCHER.ref_no%TYPE := NULL;
  CURSOR A IS
    SELECT B160.intrmdry_intm_no     	intm_no	,
	   B160.commission_amt		commission_amt,
	   B160.wholding_tax		wholding_tax	,
	   B160.share_percentage     	share_percentage,
	   GACC.gfun_fund_cd		fund_cd,
	   A995.fund_desc		fund_desc,
	   GACC.gibr_branch_cd		branch_cd,
	   GIBR.branch_name		branch_name,
	   B250.line_cd			line_cd	,
	   B250.subline_cd		subline_cd,
	   B250.iss_cd			iss_cd,
	   B250.issue_yy		issue_yy,
	   B250.pol_seq_no		pol_seq_no,
	   B250.endt_iss_cd		endt_iss_cd,
	   B250.endt_yy			endt_yy,
	   B250.endt_seq_no		endt_seq_no,
	   B250.renew_no		renew_no,
 	   B240.assd_no			assd_no ,
	   GACC.tran_flag		tran_flag,
	   GACC.tran_class		tran_class,
	   GACC.tran_date		tran_date,
	   GACC.tran_id			tran_id,
	   B140.currency_rt		currency_rt,
	   B140.prem_amt		b140_prem,
	   NVL(B140.other_charges,0)	other_charges
      FROM GIPI_POLBASIC	B250,
	   GIPI_INVOICE		B140,
  	   GIPI_PARLIST		B240,
	   GIPI_COMM_INVOICE	B160,
	   GIIS_FUNDS		A995,
	   GIAC_BRANCHES	GIBR,
	   GIAC_ACCTRANS	GACC
     WHERE GACC.tran_id NOT IN (SELECT GREV.gacc_tran_id
				  FROM GIAC_REVERSALS GREV, GIAC_ACCTRANS GACCT
				 WHERE GREV.reversing_tran_id = GACCT.tran_id
				   AND GACCT.tran_flag	     != 'D')
       AND B140.policy_id	= B250.policy_id
       AND B250.policy_id       = B160.policy_id
       AND B240.par_id		= B250.par_id
       AND B160.iss_cd		= B140.iss_cd
       AND B160.prem_seq_no	= B140.prem_seq_no
       AND GIBR.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= GIBR.gfun_fund_cd
       AND GACC.gibr_branch_cd 	= GIBR.branch_cd
       AND GACC.tran_flag      != 'D'
       AND B140.prem_seq_no	= NVL(:NEW.b140_prem_seq_no,:OLD.b140_prem_seq_no)
--comment out by totel--01/25/2008--       AND B250.iss_cd		= NVL(:NEW.b140_iss_cd,:OLD.b140_iss_cd) /* based on select from giacs007 */
       AND B140.iss_cd		= NVL(:NEW.b140_iss_cd,:OLD.b140_iss_cd) --totel--01/25/2008--tuned--PRF 1426--giacs007
       AND GACC.tran_id		= NVL(:NEW.gacc_tran_id,:OLD.gacc_tran_id);
  BEGIN
    SELECT NVL(MAX(cv_tran_id),0) + 1
      INTO v_cv_tran_id
      FROM GIAC_COMM_VOUCHER;
    IF (INSERTING) THEN
      SELECT tran_class
        INTO v_tran_class
        FROM GIAC_ACCTRANS
       WHERE tran_id = :NEW.gacc_tran_id;
      FOR rec_A IN A LOOP
        IF rec_A.other_charges = 0 OR rec_A.other_charges IS NULL THEN
          v_other_charges := 0;
          v_share_pct := 0;
        ELSE
	  v_share_pct := (rec_A.other_charges * rec_A.currency_rt)/
	                 ((rec_A.B140_prem * rec_A.currency_rt) +
 		         (rec_A.other_charges * rec_A.currency_rt));
	  v_other_charges := v_share_pct *  rec_A.other_charges * rec_A.currency_rt;
     	 END IF;
	 IF :NEW.premium_amt = 0 THEN
	   v_net_prem := 0;
     	   v_pctage_due := 0;
         ELSE
	   v_net_prem   := :NEW.premium_amt - v_other_charges;
	   v_pctage_due := v_net_prem / (rec_A.b140_prem * rec_A.currency_rt);
	 END IF;
	 v_comm_due   := v_pctage_due * rec_A.commission_amt * rec_A.currency_rt;
	 v_tax_due    := v_pctage_due * rec_A.wholding_tax * rec_A.currency_rt;
	 IF v_comm_due = 0 THEN
	   NULL;
	 ELSE
	   IF v_tran_class = 'COL' THEN
	     SELECT DECODE(or_flag, 'P', or_pref_suf||'-'||or_no, NULL)
  	       INTO v_ref_no
	       FROM GIAC_ORDER_OF_PAYTS
	      WHERE gibr_gfun_fund_cd = rec_A.fund_cd
		AND gibr_branch_cd = rec_A.branch_cd
		AND gacc_tran_id = rec_A.tran_id;
           ELSIF (v_tran_class = 'DV' OR v_tran_class = 'JV') THEN
	     v_ref_no := NULL;
           END IF;
           INSERT INTO GIAC_COMM_VOUCHER
	     (CV_TRAN_ID       , INTM_NO  	 , FUND_CD	    ,
	      FUND_DESC        , BRANCH_CD	 , BRANCH_NAME      ,
	      PREM_SEQ_NO      , LINE_CD	 , SUBLINE_CD	    ,
	      ISS_CD	       , ISSUE_YY	 , POL_SEQ_NO	    ,
	      ENDT_ISS_CD      , ENDT_YY	 , ENDT_SEQ_NO	    ,
	      RENEW_NO	       , ASSD_NO	 , INST_NO  	    ,
	      TRAN_CLASS       , TRAN_FLAG	 , TRAN_DATE 	    ,
	      REF_NO  	       , GACC_TRAN_ID    , PREMIUM_AMT      ,
	      COLLECTION_AMT   , COMMISSION_AMT  , WHOLDING_TAX     ,
	      LAST_UPDATE      , USER_ID  	     )
	   VALUES
	     (v_cv_tran_id  	      , rec_A.intm_no    , rec_A.fund_cd    ,
	      rec_A.fund_desc         , rec_A.branch_cd  , rec_A.branch_name,
	     :NEW.b140_prem_seq_no    ,	rec_A.line_cd	 , rec_A.subline_cd ,
	     :NEW.b140_iss_cd         , rec_A.issue_yy	 , rec_A.pol_seq_no ,
	      rec_A.endt_iss_cd       , rec_A.endt_yy	 , rec_A.endt_seq_no,
	      rec_A.renew_no	      , rec_A.assd_no	 , :NEW.inst_no     ,
	      rec_A.tran_class        , rec_A.tran_flag  , rec_A.tran_date  ,
	      v_ref_no  	      , :NEW.gacc_tran_id, v_net_prem	    ,
             :NEW.collection_amt      ,	v_comm_due	 , v_tax_due	    ,
	      SYSDATE   	      , USER   		 );
	 END IF;
       END LOOP;
    ELSIF (DELETING) THEN
      DELETE FROM GIAC_COMM_VOUCHER
       WHERE gacc_tran_id	= :OLD.gacc_tran_id
	 AND iss_cd		= :OLD.b140_iss_cd
	 AND prem_seq_no	= :OLD.b140_prem_seq_no;
      v_cv_tran_id := v_cv_tran_id - 1;
    END IF;
  END;
END;

/* ------------------- OLD TRIGGER -----------------------------
----------------------------------------------------------------
----------------------------------------------------------------
create or replace trigger "CPI".POPULATE_GCV_TBDIX
BEFORE INSERT OR DELETE ON GIAC_DIRECT_PREM_COLLNS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW






BEGIN
  DECLARE
	v_cv_tran_id		giac_comm_voucher.cv_tran_id%type;
	v_net_prem		NUMBER(12,2);
        v_other_charges		NUMBER(12,2);
	v_tax_due  		gipi_comm_invoice.wholding_tax%type;
	v_comm_due  		gipi_comm_invoice.commission_amt%type;
	v_or_no			giac_order_of_payts.or_no%type;
	v_share_pct  		NUMBER(12,9);
	v_pctage_due  		NUMBER(12,9);
	v_tran_class		VARCHAR2(3);
	v_switch		NUMBER(1);
  CURSOR A IS
    SELECT B160.intrmdry_intm_no     	intm_no	,
	   B160.commission_amt		commission_amt,
	   B160.wholding_tax		wholding_tax	,
	   B160.share_percentage     	share_percentage,
	   GACC.gfun_fund_cd		fund_cd,
	   A995.fund_desc		fund_desc,
	   GACC.gibr_branch_cd		branch_cd,
	   GIBR.branch_name		branch_name,
	   B250.line_cd			line_cd	,
	   B250.subline_cd		subline_cd,
	   B250.iss_cd			iss_cd,
	   B250.issue_yy		issue_yy,
	   B250.pol_seq_no		pol_seq_no,
	   B250.endt_iss_cd		endt_iss_cd,
	   B250.endt_yy			endt_yy,
	   B250.endt_seq_no		endt_seq_no,
	   B250.renew_no		renew_no,
	   B240.assd_no 		assd_no ,
	   GACC.tran_flag		tran_flag,
	   GACC.tran_class		tran_class,
	   GACC.tran_date		tran_date,
	   GACC.tran_id			tran_id,
	   DECODE(GIOP.or_flag, 'P',
		  GIOP.or_pref_suf || '-' ||
		  GIOP.or_no, null)	ref_no,
	   B140.currency_rt		currency_rt,
	   B140.prem_amt		b140_prem,
	   nvl(B140.other_charges,0)	other_charges
      FROM gipi_polbasic	B250,
	   gipi_invoice		B140,
  	   gipi_parlist		B240,
	   gipi_comm_invoice	B160,
	   giis_funds		A995,
	   giac_branches	GIBR,
	   giac_acctrans	GACC,
	   giac_order_of_payts	GIOP
     WHERE GACC.tran_id NOT IN (SELECT GREV.gacc_tran_id
				  FROM giac_reversals GREV, giac_acctrans GACCT
				 WHERE GREV.reversing_tran_id = GACCT.tran_id
				   AND GACCT.tran_flag	     != 'D')
       AND B140.policy_id	= B250.policy_id
       AND B240.par_id		= B250.par_id
       AND B160.iss_cd		= B140.iss_cd
       AND B160.prem_seq_no	= B140.prem_seq_no
       AND GIOP.gacc_tran_id	= GACC.tran_id
       AND GIBR.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= GIBR.gfun_fund_cd
       AND GACC.gibr_branch_cd 	= GIBR.branch_cd
       AND GIOP.gibr_gfun_fund_cd = GIBR.gfun_fund_cd
       AND GIOP.gibr_branch_cd 	= GIBR.branch_cd
       AND GACC.tran_flag      != 'D'
       AND B140.prem_seq_no	= NVL(:new.b140_prem_seq_no,:old.b140_prem_seq_no)
       AND B250.iss_cd		= NVL(:new.b140_iss_cd,:old.b140_iss_cd) -- based on select from giacs007
       AND GACC.tran_id		= NVL(:new.gacc_tran_id,:old.gacc_tran_id);
  CURSOR B IS
    SELECT B160.intrmdry_intm_no     	intm_no	,
	   B160.commission_amt		commission_amt,
	   B160.wholding_tax		wholding_tax	,
	   B160.share_percentage     	share_percentage,
	   GACC.gfun_fund_cd		fund_cd,
	   A995.fund_desc		fund_desc,
	   GACC.gibr_branch_cd		branch_cd,
	   GIBR.branch_name		branch_name,
	   B250.line_cd			line_cd	,
	   B250.subline_cd		subline_cd,
	   B250.iss_cd			iss_cd,
	   B250.issue_yy		issue_yy,
	   B250.pol_seq_no		pol_seq_no,
	   B250.endt_iss_cd		endt_iss_cd,
	   B250.endt_yy			endt_yy,
	   B250.endt_seq_no		endt_seq_no,
	   B250.renew_no		renew_no,
 	   B240.assd_no			assd_no ,
	   GACC.tran_flag		tran_flag,
	   GACC.tran_class		tran_class,
	   GACC.tran_date		tran_date,
	   GACC.tran_id			tran_id,
	   B140.currency_rt		currency_rt,
	   B140.prem_amt		b140_prem,
	   nvl(B140.other_charges,0)	other_charges
      FROM gipi_polbasic	B250,
	   gipi_invoice		B140,
  	   gipi_parlist		B240,
	   gipi_comm_invoice	B160,
	   giis_funds		A995,
	   giac_branches	GIBR,
	   giac_acctrans	GACC
     WHERE GACC.tran_id NOT IN (SELECT GREV.gacc_tran_id
				  FROM giac_reversals GREV, giac_acctrans GACCT
				 WHERE GREV.reversing_tran_id = GACCT.tran_id
				   AND GACCT.tran_flag	     != 'D')
       AND B140.policy_id	= B250.policy_id
       AND B250.policy_id       = B160.policy_id
       AND B240.par_id		= B250.par_id
       AND B160.iss_cd		= B140.iss_cd
       AND B160.prem_seq_no	= B140.prem_seq_no
       AND GIBR.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= GIBR.gfun_fund_cd
       AND GACC.gibr_branch_cd 	= GIBR.branch_cd
       AND GACC.tran_flag      != 'D'
       AND B140.prem_seq_no	= NVL(:new.b140_prem_seq_no,:old.b140_prem_seq_no)
       AND B250.iss_cd		= NVL(:new.b140_iss_cd,:old.b140_iss_cd) -- based on select from giacs007
       AND GACC.tran_id		= NVL(:new.gacc_tran_id,:old.gacc_tran_id);
  CURSOR C IS
    SELECT B160.intrmdry_intm_no     	intm_no	,
	   B160.commission_amt		commission_amt,
	   B160.wholding_tax		wholding_tax	,
	   B160.share_percentage     	share_percentage,
	   GACC.gfun_fund_cd		fund_cd,
	   A995.fund_desc		fund_desc,
	   GACC.GIBR_branch_cd		branch_cd,
	   GIBR.branch_name		branch_name,
	   B250.line_cd			line_cd	,
	   B250.subline_cd		subline_cd,
	   B250.iss_cd			iss_cd,
	   B250.issue_yy		issue_yy,
	   B250.pol_seq_no		pol_seq_no,
	   B250.endt_iss_cd		endt_iss_cd,
	   B250.endt_yy			endt_yy,
	   B250.endt_seq_no		endt_seq_no,
	   B250.renew_no		renew_no,
	   B240.assd_no			assd_no ,
	   GACC.tran_flag		tran_flag,
	   GACC.tran_class		tran_class,
   	   GACC.tran_class_no		tran_class_no,
	   GACC.tran_date		tran_date,
	   GACC.tran_id			tran_id,
	   B140.currency_rt		currency_rt,
	   B140.prem_amt		b140_prem,
	   nvl(B140.other_charges,0)	other_charges
      FROM gipi_polbasic	B250,
	   gipi_invoice		B140,
  	   gipi_parlist		B240,
	   gipi_comm_invoice	B160,
	   giis_funds		A995,
	   giac_branches	GIBR,
	   giac_acctrans	GACC
     WHERE GACC.tran_id NOT IN (SELECT GREV.gacc_tran_id
				  FROM giac_reversals GREV, giac_acctrans GACCT
				 WHERE GREV.reversing_tran_id = GACCT.tran_id
				   AND GACCT.tran_flag	     != 'D')
       AND B140.policy_id	= B250.policy_id
       AND B250.policy_id       = B160.policy_id
       AND B240.par_id		= B250.par_id
       AND B160.iss_cd		= B140.iss_cd
       AND B160.prem_seq_no	= B140.prem_seq_no
       AND GIBR.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= A995.fund_cd
       AND GACC.gfun_fund_cd 	= GIBR.gfun_fund_cd
       AND GACC.gibr_branch_cd 	= GIBR.branch_cd
       AND GACC.tran_flag      != 'D'
       AND B140.prem_seq_no	= NVL(:new.b140_prem_seq_no,:old.b140_prem_seq_no)
       AND B250.iss_cd		= NVL(:new.b140_iss_cd,:old.b140_iss_cd) -- based on select from giacs007
       AND GACC.tran_id		= NVL(:new.gacc_tran_id,:old.gacc_tran_id);
  BEGIN
	SELECT nvl(max(cv_tran_id),0) + 1
	  INTO v_cv_tran_id
	  FROM giac_comm_voucher;
    IF (INSERTING) THEN
      SELECT tran_class
        INTO v_tran_class
        FROM giac_acctrans
       WHERE tran_id = :new.gacc_tran_id;
      IF v_tran_class = 'COL' THEN
        FOR rec_A IN A LOOP
	   IF rec_A.other_charges = 0 THEN
   	      v_other_charges := 0;
  	      v_share_pct := 0;
    	   ELSE
	      v_share_pct := (rec_A.other_charges * rec_A.currency_rt)/
		   	     ((rec_A.B140_prem * rec_A.currency_rt) +
 			     (rec_A.other_charges * rec_A.currency_rt));
	      v_other_charges := v_share_pct *  rec_A.other_charges * rec_A.currency_rt;
     	   END IF;
	   IF :new.premium_amt = 0 THEN
	      v_net_prem := 0;
     	      v_pctage_due := 0;
           ELSE
	      v_net_prem   := :new.premium_amt - v_other_charges;
	      v_pctage_due := v_net_prem / (rec_A.b140_prem * rec_A.currency_rt);
	   END IF;
	   v_comm_due   := v_pctage_due * rec_A.commission_amt * rec_A.currency_rt;
	   v_tax_due    := v_pctage_due * rec_A.wholding_tax * rec_A.currency_rt;
	  IF v_comm_due = 0 THEN
	     NULL;
	  ELSE
	     INSERT INTO giac_comm_voucher
		(CV_TRAN_ID 	      , INTM_NO  	 , FUND_CD	    ,
		 FUND_DESC	      , BRANCH_CD	 , BRANCH_NAME      ,
		 PREM_SEQ_NO 	      , LINE_CD	         , SUBLINE_CD	    ,
		 ISS_CD		      , ISSUE_YY	 , POL_SEQ_NO	    ,
		 ENDT_ISS_CD	      , ENDT_YY	         , ENDT_SEQ_NO	    ,
		 RENEW_NO	      , ASSD_NO	         , INST_NO  	    ,
		 TRAN_CLASS 	      , TRAN_FLAG	 , TRAN_DATE 	    ,
		 REF_NO  	      , GACC_TRAN_ID     , PREMIUM_AMT      ,
		 COLLECTION_AMT       , COMMISSION_AMT   , WHOLDING_TAX     ,
		 LAST_UPDATE 	      , USER_ID  	     )
	     VALUES
		(v_cv_tran_id  	      , rec_A.intm_no    , rec_A.fund_cd    ,
		 rec_A.fund_desc      , rec_A.branch_cd  , rec_A.branch_name,
		 :new.b140_prem_seq_no,	rec_A.line_cd	 , rec_A.subline_cd ,
		 :new.b140_iss_cd     , rec_A.issue_yy	 , rec_A.pol_seq_no ,
		 rec_A.endt_iss_cd    , rec_A.endt_yy	 , rec_A.endt_seq_no,
		 rec_A.renew_no	      , rec_A.assd_no	 , :new.inst_no     ,
		 rec_A.tran_class     , rec_A.tran_flag  , rec_A.tran_date  ,
		 rec_A.ref_no	      , :new.gacc_tran_id, v_net_prem	    , 		 		 	 :new.collection_amt  ,	v_comm_due	 , v_tax_due	    ,
		 sysdate   	      , user   		 );
	  END IF;
        END LOOP;
      ELSIF v_tran_class = 'DV' THEN
        FOR rec_B IN B LOOP
	   IF rec_B.other_charges = 0 THEN
   	      v_other_charges := 0;
	      v_share_pct := 0;
           ELSE
	      v_share_pct := (rec_B.other_charges * rec_B.currency_rt)/
			     ((rec_B.B140_prem * rec_B.currency_rt) +
 			      (rec_B.other_charges * rec_B.currency_rt));
	      v_other_charges := v_share_pct *  rec_B.other_charges * rec_B.currency_rt;
	   END IF;
	   IF :new.premium_amt = 0 THEN
	      v_net_prem := 0;
	      v_pctage_due := 0;
           ELSE
	      v_net_prem   := :new.premium_amt - v_other_charges;
	      v_pctage_due := v_net_prem / (rec_B.b140_prem * rec_B.currency_rt);
	   END IF;
	   v_comm_due   := v_pctage_due * rec_B.commission_amt * rec_B.currency_rt;
	   v_tax_due    := v_pctage_due * rec_B.wholding_tax * rec_B.currency_rt;
	  IF v_comm_due = 0 THEN
	     NULL;
	  ELSE
	     INSERT INTO giac_comm_voucher
		(CV_TRAN_ID 	      , INTM_NO  	 , FUND_CD   	      ,
		 FUND_DESC	      , BRANCH_CD	 , BRANCH_NAME	      ,
		 PREM_SEQ_NO 	      , LINE_CD	  	 , SUBLINE_CD	      ,
		 ISS_CD		      , ISSUE_YY	 , POL_SEQ_NO	      ,
		 ENDT_ISS_CD	      , ENDT_YY	  	 , ENDT_SEQ_NO	      ,
		 RENEW_NO	      , ASSD_NO	  	 , INST_NO  	      ,
		 TRAN_CLASS 	      , TRAN_FLAG	 , TRAN_DATE 	      ,
		 REF_NO  	      , GACC_TRAN_ID 	 , PREMIUM_AMT        ,
		 COLLECTION_AMT       , COMMISSION_AMT   , WHOLDING_TAX       ,
		 LAST_UPDATE 	      , USER_ID  	 )
	     VALUES
		(v_cv_tran_id  	      , rec_B.intm_no    , rec_B.fund_cd      ,
		 rec_B.fund_desc      , rec_B.branch_cd  , rec_B.branch_name  ,
		 :new.b140_prem_seq_no, rec_B.line_cd	 , rec_B.subline_cd   ,
		 :new.b140_iss_cd     , rec_B.issue_yy	 , rec_B.pol_seq_no   ,
		 rec_B.endt_iss_cd    , rec_B.endt_yy	 , rec_B.endt_seq_no  ,
		 rec_B.renew_no	      , rec_B.assd_no	 , :new.inst_no       ,
		 rec_B.tran_class     , rec_B.tran_flag  , rec_B.tran_date    ,
		 NULL		      , :new.gacc_tran_id, v_net_prem	      ,
		 :new.collection_amt  , v_comm_due	 , v_tax_due	      ,
		 sysdate   	      , user		 );
	  END IF;
        END LOOP;
      ELSIF v_tran_class = 'JV' THEN
        FOR rec_C IN C LOOP
	   IF rec_C.other_charges = 0 THEN
	      v_other_charges := 0;
	      v_share_pct := 0;
	   ELSE
	      v_share_pct := (rec_C.other_charges * rec_C.currency_rt)/
		  	     ((rec_C.B140_prem * rec_C.currency_rt) +
 			      (rec_C.other_charges * rec_C.currency_rt));
	      v_other_charges := v_share_pct *  rec_C.other_charges * rec_C.currency_rt;
	   END IF;
	   IF :new.premium_amt = 0 THEN
	      v_net_prem := 0;
	      v_pctage_due := 0;
           ELSE
	      v_net_prem   := :new.premium_amt - v_other_charges;
	      v_pctage_due := v_net_prem / (rec_C.b140_prem * rec_C.currency_rt);
	   END IF;
	   v_comm_due   := v_pctage_due * rec_C.commission_amt * rec_C.currency_rt;
	   v_tax_due    := v_pctage_due * rec_C.wholding_tax * rec_C.currency_rt;
	  IF v_comm_due = 0 THEN
	     NULL;
	  ELSE
	     INSERT INTO giac_comm_voucher
		(CV_TRAN_ID 	      , INTM_NO  	 , FUND_CD	      ,
		 FUND_DESC	      , BRANCH_CD	 , BRANCH_NAME        ,
		 PREM_SEQ_NO 	      , LINE_CD	         , SUBLINE_CD	      ,
		 ISS_CD		      , ISSUE_YY	 , POL_SEQ_NO	      ,
		 ENDT_ISS_CD	      , ENDT_YY	         , ENDT_SEQ_NO        ,
		 RENEW_NO	      , ASSD_NO	   	 , INST_NO  	      ,
		 TRAN_CLASS 	      ,
		 TRAN_FLAG	      , TRAN_DATE 	 , REF_NO  	      ,
		 GACC_TRAN_ID 	      , PREMIUM_AMT      , COLLECTION_AMT     ,
		 COMMISSION_AMT       , WHOLDING_TAX     , LAST_UPDATE 	      , USER_ID  )
	     VALUES
		(v_cv_tran_id  	      , rec_C.intm_no    , rec_C.fund_cd      ,
		 rec_C.fund_desc      , rec_C.branch_cd  , rec_C.branch_name  ,
		 :new.b140_prem_seq_no,	rec_C.line_cd	 , rec_C.subline_cd   ,
		 :new.b140_iss_cd     , rec_C.issue_yy	 , rec_C.pol_seq_no   ,
		 rec_C.endt_iss_cd    , rec_C.endt_yy	 , rec_C.endt_seq_no  ,
		 rec_C.renew_no	      , rec_C.assd_no	 , :new.inst_no       ,
		 rec_C.tran_class     , rec_C.tran_flag  , rec_C.tran_date    ,
		 rec_C.tran_class || '-' || TO_CHAR(rec_C.tran_class_no),
		 :new.gacc_tran_id    , v_net_prem	 , :new.collection_amt,
		 v_comm_due	      , v_tax_due	 , sysdate   	      , user  	);
	  END IF;
	END LOOP;
      END IF;
    ELSIF (DELETING) THEN
     	DELETE FROM GIAC_COMM_VOUCHER
	 WHERE gacc_tran_id	= :old.gacc_tran_id
	   AND iss_cd		= :old.b140_iss_cd
	   AND prem_seq_no	= :old.b140_prem_seq_no;
	v_cv_tran_id := v_cv_tran_id - 1;
    END IF;
  END;
END;
*/
/


