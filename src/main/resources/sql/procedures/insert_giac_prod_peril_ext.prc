DROP PROCEDURE CPI.INSERT_GIAC_PROD_PERIL_EXT;

CREATE OR REPLACE PROCEDURE CPI.insert_giac_prod_peril_ext
  (PARAM_DATE              DATE )
is
  /* created by   := janet ang
  ** added   on   := august 31, 2000
  **    for use in DISTRIBUTION REGISTER
  **    mainly form GIACS123.fmb and reports GIACR122, GIACR123, GIACR124
  **    this picks up distributions taken up already by accounting
  */
  var                      number;
begin
  begin
    select distinct 1
	into var
	from giac_production_peril_ext
	where TRUNC(TAKE_UP_DATE) = trunc(param_date);
	  delete from giac_production_peril_ext
        where trunc(take_up_date) = trunc(param_date);
	  delete from giac_production_dist_ext
        where trunc(take_up_date) = trunc(param_date);
  exception
    when no_data_found then
	  null;
  end;
  for cur in (
    SELECT POLICY_ID, POLICY_NO, LINE_CD, SUBLINE_CD, ISS_CD, ISSUE_YY, POL_SEQ_NO, RENEW_NO,
	  ENDT_ISS_CD, ENDT_YY, ENDT_SEQ_NO, SHARE_CD, SHARE_TYPE, ITEM_NO, DIST_NO, DIST_SEQ_NO,
      PERIL_CD, PERIL_TYPE, CURRENCY_RT, ACCT_ENT_DATE, ACCT_NEG_DATE,
      SUM(DECODE(TRUNC(ACCT_ENT_DATE), TRUNC(PARAM_DATE), NR_DIST_TSI, NR_DIST_TSI * -1)) NR_DIST_TSI,
      SUM(DECODE(TRUNC(ACCT_ENT_DATE), TRUNC(PARAM_DATE), NR_DIST_PREM, NR_DIST_PREM * -1)) NR_DIST_PREM,
      SUM(DECODE(TRUNC(ACCT_ENT_DATE), TRUNC(PARAM_DATE), TR_DIST_TSI, TR_DIST_TSI *-1)) TR_DIST_TSI,
      SUM(DECODE(TRUNC(ACCT_ENT_DATE), TRUNC(PARAM_DATE), TR_DIST_PREM, TR_DIST_PREM*-1)) TR_DIST_PREM,
      SUM(DECODE(TRUNC(ACCT_ENT_DATE), TRUNC(PARAM_DATE), FA_DIST_TSI, FA_DIST_TSI*-1)) FA_DIST_TSI,
      SUM(DECODE(TRUNC(ACCT_ENT_DATE), TRUNC(PARAM_DATE), FA_DIST_PREM, FA_DIST_PREM*-1)) FA_DIST_PREM
    FROM (SELECT A.POLICY_ID, A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||A.ISSUE_YY||'-'||
          A.POL_SEQ_NO||'-'||A.RENEW_NO||'-'||A.ENDT_ISS_CD||'-'||A.ENDT_YY||'-'||A.ENDT_SEQ_NO POLICY_NO,
          A.LINE_CD, A.SUBLINE_CD, A.ISS_CD, A.ISSUE_YY, A.POL_SEQ_NO, A.RENEW_NO, A.ENDT_ISS_CD, A.ENDT_YY,
		  A.ENDT_SEQ_NO, D.SHARE_CD, F.SHARE_TYPE, D.ITEM_NO, D.DIST_NO, D.DIST_SEQ_NO,
          D.PERIL_CD, E.PERIL_TYPE, C.CURRENCY_RT, B.ACCT_ENT_DATE, B.ACCT_NEG_DATE,
--          DECODE(E.PERIL_TYPE, 'A',0,DECODE(F.SHARE_TYPE, '1', NVL(D.DIST_TSI,0) * NVL(C.CURRENCY_RT,1), 0))  NR_DIST_TSI,
          DECODE(F.SHARE_TYPE, '1', NVL(D.DIST_TSI,0) * NVL(C.CURRENCY_RT,1), 0)  NR_DIST_TSI,
          DECODE(F.SHARE_TYPE, '1', NVL(D.DIST_PREM,0) * NVL(C.CURRENCY_RT,1),0) NR_DIST_PREM,
--          DECODE(E.PERIL_TYPE, 'A',0,DECODE(F.SHARE_TYPE, '2', NVL(D.DIST_TSI,0) * NVL(C.CURRENCY_RT,1), 0))  TR_DIST_TSI,
          DECODE(F.SHARE_TYPE, '2', NVL(D.DIST_TSI,0) * NVL(C.CURRENCY_RT,1), 0)  TR_DIST_TSI,
          DECODE(F.SHARE_TYPE, '2', NVL(D.DIST_PREM,0) * NVL(C.CURRENCY_RT,1),0) TR_DIST_PREM,
--          DECODE(E.PERIL_TYPE, 'A',0,DECODE(F.SHARE_TYPE, '3', NVL(D.DIST_TSI,0) * NVL(C.CURRENCY_RT,1), 0))  FA_DIST_TSI,
          DECODE(F.SHARE_TYPE, '3', NVL(D.DIST_TSI,0) * NVL(C.CURRENCY_RT,1), 0)  FA_DIST_TSI,
          DECODE(F.SHARE_TYPE, '3', NVL(D.DIST_PREM,0) * NVL(C.CURRENCY_RT,1),0) FA_DIST_PREM
          FROM GIPI_POLBASIC A,
          GIUW_POL_DIST B,
	      GIPI_ITEM     C,
	      GIUW_ITEMPERILDS_DTL D,
	      GIIS_PERIL    E,
	      GIIS_DIST_SHARE F
          WHERE A.POLICY_ID = B.POLICY_ID
          AND A.POLICY_ID = C.POLICY_ID
          AND B.DIST_NO = D.DIST_NO
          AND C.ITEM_NO = D.ITEM_NO
          AND D.LINE_CD = E.LINE_CD
          AND D.PERIL_CD = E.PERIL_CD
          AND F.LINE_CD = D.LINE_CD
          AND F.SHARE_CD = D.SHARE_CD
          AND (TRUNC(B.ACCT_ENT_DATE) = TRUNC(PARAM_DATE)
            OR TRUNC(B.ACCT_NEG_DATE) = TRUNC(PARAM_DATE)) )
    GROUP BY POLICY_ID, POLICY_NO, LINE_CD, SUBLINE_CD, ISS_CD, ISSUE_YY, POL_SEQ_NO, RENEW_NO,
	  ENDT_ISS_CD, ENDT_YY, ENDT_SEQ_NO, SHARE_CD, SHARE_TYPE, ITEM_NO, DIST_NO, DIST_SEQ_NO,
      PERIL_CD, PERIL_TYPE, CURRENCY_RT, ACCT_ENT_DATE, ACCT_NEG_DATE ) loop
dbms_output.put_line(' dist_no and sharecd  :  '|| to_char(cur.dist_no)||'---'|| to_char(cur.share_cd) );
dbms_output.put_line(' net ret amount entered       :  '|| to_char(cur.nr_dist_prem));
dbms_output.put_line(' treaty  amount entered       :  '|| to_char(cur.tr_dist_prem));
dbms_output.put_line(' facul   amount entered       :  '|| to_char(cur.fa_dist_prem));
    insert into giac_production_peril_ext
	       (POLICY_ID      ,  POLICY_NO    ,   LINE_CD        ,   SUBLINE_CD   ,
            SHARE_CD       ,  SHARE_TYPE   ,   DIST_NO        ,   DIST_SEQ_NO  ,
            PERIL_CD       ,  PERIL_TYPE   ,   NR_DIST_TSI    ,   NR_DIST_PREM ,
            NR_DIST_SPCT   ,  TR_DIST_TSI  ,   TR_DIST_PREM   ,   TR_DIST_SPCT ,
            FA_DIST_TSI    ,  FA_DIST_PREM ,   FA_DIST_SPCT   ,   CURRENCY_RT  ,
            ACCT_ENT_DATE  ,  ITEM_NO      ,   ISS_CD         ,   ISSUE_YY     ,
			POL_SEQ_NO     ,  RENEW_NO     ,   ENDT_ISS_CD    ,   ENDT_YY      ,
			ENDT_SEQ_NO    ,  TAKE_UP_DATE )
    values (cur.POLICY_ID  ,  cur.POLICY_NO,   cur.LINE_CD    ,   cur.SUBLINE_CD,
            cur.SHARE_CD   ,  cur.SHARE_TYPE,  cur.DIST_NO    ,   cur.DIST_SEQ_NO,
            cur.PERIL_CD   ,  cur.PERIL_TYPE,  cur.NR_DIST_TSI,   cur.NR_DIST_PREM,
            0              , cur.TR_DIST_TSI,  cur.TR_DIST_PREM,  0 ,
            cur.FA_DIST_TSI,  cur.FA_DIST_PREM, 0 ,  cur.CURRENCY_RT ,
            cur.ACCT_ENT_DATE,cur.ITEM_NO  ,   cur.ISS_CD     ,   cur.ISSUE_YY ,
			cur.POL_SEQ_NO ,  cur.RENEW_NO ,   cur.ENDT_ISS_CD,   cur.ENDT_YY  ,
			cur.ENDT_SEQ_NO,  PARAM_DATE    );
  end loop;
  for rec in (select b.policy_id, b.policy_no, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
        b.pol_Seq_no, b.renew_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no,b.dist_no,
        b.dist_seq_no, b.share_cd, b.share_type, b.currency_rt, b.acct_ent_date,
		b.acct_neg_date, nvl(a.prem_amt,0) prem_amt, nvl(a.tsi_amt,0) tsi_amt,
		sum(decode(b.peril_type,'A',0,nvl(b.nr_dist_tsi,0))) nr_dist_tsi,
		sum(nvl(b.nr_dist_prem,0)) nr_dist_prem,
		sum(decode(b.peril_type,'A',0,nvl(b.tr_dist_tsi,0))) tr_dist_tsi,
		sum(nvl(b.tr_dist_prem,0)) tr_dist_prem,
		sum(decode(b.peril_type,'A',0,nvl(b.fa_dist_tsi,0))) fa_dist_tsi,
		sum(nvl(b.fa_dist_prem,0)) fa_dist_prem
		from gipi_polbasic a, giac_production_peril_ext b
		where a.policy_Id = b.policy_id
		and trunc(b.take_up_date) = trunc(param_date)
        group by b.policy_id, b.policy_no, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
        b.pol_Seq_no, b.renew_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no, b.dist_no,
        b.dist_seq_no, b.share_cd, b.share_type, b.currency_rt, b.acct_ent_date,
		b.acct_neg_date, a.prem_amt, a.tsi_amt ) loop
    insert into giac_production_dist_ext
       (POLICY_ID    , 	LINE_CD      , 	SUBLINE_CD   ,  DIST_NO     ,  DIST_SEQ_NO  ,
		SHARE_CD     ,  SHARE_TYPE   ,	NR_DIST_TSI  ,  NR_DIST_PREM,  TR_DIST_TSI  ,
		TR_DIST_PREM ,  FA_DIST_TSI  ,  FA_DIST_PREM ,	CURRENCY_RT ,  ACCT_ENT_DATE,
		POLICY_NO    ,	POLBASIC_TSI ,  POLBASIC_PREM,  ACCT_NEG_DATE, ISS_CD       ,
        ISSUE_YY     ,  POL_SEQ_NO   ,  RENEW_NO     ,  ENDT_ISS_CD ,  ENDT_YY      ,
		ENDT_SEQ_NO  ,  TAKE_UP_DATE )
    VALUES
	   (rec.POLICY_ID   ,rec.LINE_CD     , rec.SUBLINE_CD  , rec.DIST_NO     ,rec.DIST_SEQ_NO ,
        rec.SHARE_CD    ,rec.SHARE_TYPE  , rec.NR_DIST_TSI , rec.NR_DIST_PREM,rec.TR_DIST_TSI ,
		rec.TR_DIST_PREM,rec.FA_DIST_TSI , rec.FA_DIST_PREM, rec.CURRENCY_RT ,rec.ACCT_ENT_DATE,
		rec.POLICY_NO   ,rec.TSI_AMT     , rec.PREM_AMT    , rec.ACCT_NEG_DATE, rec.ISS_CD    ,
        rec.ISSUE_YY    ,rec.POL_SEQ_NO  , rec.RENEW_NO    , rec.ENDT_ISS_CD ,rec.ENDT_YY      ,
		rec.ENDT_SEQ_NO ,PARAM_DATE  );
  end loop;
end;
/


