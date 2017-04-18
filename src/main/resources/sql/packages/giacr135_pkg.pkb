CREATE OR REPLACE PACKAGE BODY CPI.giacr135_pkg
AS
  
 FUNCTION get_giacr135_company_name 
     RETURN VARCHAR2 
 IS
v_company_name varchar2(100);
BEGIN
  select param_value_v
  into v_company_name
  from giis_parameters
  where param_name='COMPANY_NAME';
  return(v_company_name);
RETURN NULL; exception
  when no_data_found then return(null);

   END get_giacr135_company_name;

   
FUNCTION get_giacr135_company_address return VARCHAR2 IS 
v_company_address  giac_parameters.param_value_v%type;

BEGIN
  begin
    select param_value_v
      into v_company_address
      from giac_parameters
     where param_name = 'COMPANY_ADDRESS';
  exception
    when no_data_found then
      v_company_address := ' ';
  end;
  return(v_company_address);
   END get_giacr135_company_address;


function get_giacr135_top_date (
v_begin_date         DATE,
v_end_date           DATE
)
return VARCHAR2 is
  v_date               varchar2(100);
  
begin
  if v_begin_date = v_end_date then
     v_date:=to_char(v_begin_date,'fmMONTH DD, YYYY');
  else
     v_date := 'For the Period of '||to_char(v_begin_date, 'fmMonth DD, YYYY')
                ||' to '|| to_char(v_end_date, 'fmMonth DD, YYYY'); 
  end if;
  return (v_date);
end get_giacr135_TOP_DATE;

function get_giacr135_DISB_MODE_TYPE (
p_disb_mode               CHARACTER
)
return Char is
	mode_type				Char(20);
    
begin
  IF p_disb_mode = 'B' THEN
  	--mode_type := 'Bank Transfer'; commented out by Reymon 03162012
  	mode_type := 'BANK TRANSFER'; --modified by Reymon 03162012
  ELSE
  	--mode_type := 'Check';  commented out by Reymon 03162012
  	mode_type := 'CHECK DISBURSEMENT'; --modified by Reymon 03162012
  END IF;
  	
  RETURN mode_type;	
end get_giacr135_DISB_MODE_TYPE;




FUNCTION get_giacr135_COUNT_SPOILED  (
p_particulars       VARCHAR2,
p_disb_mode         CHARACTER
)
return Number is 
  COUNT_SPOILED      NUMBER ;
  
begin
  IF P_PARTICULARS = 'SPOILED' AND P_DISB_MODE <> 'B' THEN
	COUNT_SPOILED:=1;
  ELSE
	COUNT_SPOILED:=0;
  END IF;
  RETURN(COUNT_SPOILED);
end get_giacr135_COUNT_SPOILED;

FUNCTION get_giacr135_count_cancelled (
p_particulars      VARCHAR2,
p_disb_mode        CHARACTER
)
return Number is
count_cancelled    number;
 
begin
  if P_PARTICULARS like '%CANCELLED%' AND P_DISB_MODE <> 'B' then
	count_cancelled:=1;
  else
	count_cancelled:=0;
  end if;
  return(count_cancelled);
end get_giacr135_count_cancelled;




function get_giacr135_COUNT_VALID_BT(
P_DISB_MODE varchar2,
p_dv_flag   varchar2
) return Number is
COUNT_VALID_BT     NUMBER;

begin
  IF P_DISB_MODE = 'B' AND p_dv_flag = 'P' THEN
  	COUNT_VALID_BT := 1;
  ELSE
  	COUNT_VALID_BT := 0;
  END IF;
 RETURN(COUNT_VALID_BT);
end get_giacr135_COUNT_VALID_BT;


function get_giacr135_COUNT_CANCEL_BT (
p_disb_mode          CHARACTER,
p_dv_flag            CHARACTER
)
return Number is
COUNT_CANCEL_BT     NUMBER;

begin
  IF p_disb_mode = 'B' AND p_dv_flag = 'C' THEN
  	COUNT_CANCEL_BT := 1;
  ELSE
  	COUNT_CANCEL_BT := 0;
  END IF;
 RETURN(COUNT_CANCEL_BT);
end get_giacr135_COUNT_CANCEL_BT;


function get_giacr135_COUNT_CHECK (
P_PARTICULARS VARCHAR2,
P_DISB_MODE   VARCHAR2
)
return Number is
COUNT_CHECK NUMBER ;
begin
  IF ((P_PARTICULARS <> 'SPOILED' AND P_PARTICULARS NOT LIKE '%CANCELLED%') OR P_PARTICULARS = 'SPOILED' OR P_PARTICULARS LIKE '%CANCELLED%') --modified by jongs 06.10.2013
  	AND P_DISB_MODE <> 'B' THEN
	COUNT_CHECK := 1;
  ELSE
	COUNT_CHECK := 0;
  END IF;
  RETURN(COUNT_CHECK);
end get_giacr135_COUNT_CHECK;

function get_giacr135_currency (
p_currency_cd       NUMBER
)
return Char is
	v_short_name	VARCHAR2(3);
begin
  FOR rec IN (SELECT short_name
  			FROM giis_currency
 			WHERE main_currency_cd = p_currency_cd)
 	LOOP
 		v_short_name := nvl(rec.short_name, ' ');
 	END LOOP;
 	
 	RETURN(v_short_name);
end get_giacr135_currency;

function get_giacr135_F_AMT_VALID (
P_PARTICULARS VARCHAR2,
P_DISB_MODE   VARCHAR2,
p_check_amt   NUMBER
)
return Number is
	v_tot_valid	NUMBER;
begin 
 IF P_PARTICULARS NOT LIKE '%CANCELLED%' AND P_PARTICULARS NOT LIKE '%SPOILED%' AND P_DISB_MODE <> 'B' THEN
  	--v_tot_valid := 0;
  	v_tot_valid := p_check_amt;
  ELSE
  	--v_tot_valid := :check_amt;
  	v_tot_valid := 0;
  END IF;
  
  RETURN(v_tot_valid);
end get_giacr135_F_AMT_VALID;

function get_giacr135_AMT_SPOILED (
P_PARTICULARS VARCHAR2,
P_DISB_MODE   VARCHAR2,
p_check_amt   NUMBER
)
return Number is
	v_tot_spoiled		NUMBER;
begin
  IF P_PARTICULARS LIKE '%SPOILED%' AND P_DISB_MODE <> 'B' THEN
  	v_tot_spoiled := p_check_amt;
  ELSE
  	v_tot_spoiled := 0;
  END IF;
  
  RETURN(v_tot_spoiled);
end get_giacr135_AMT_SPOILED;

function get_giacr135_AMT_CANCELLED (
P_PARTICULARS VARCHAR2,
P_DISB_MODE   VARCHAR2,
p_check_amt   NUMBER
)
return Number is
	v_tot_cancelled		NUMBER;
begin
  IF P_PARTICULARS LIKE '%CANCELLED%' AND P_DISB_MODE <> 'B' THEN
  	v_tot_cancelled := p_check_amt;
  ELSE
  	v_tot_cancelled := 0;
  END IF;
  
  RETURN(v_tot_cancelled);
end get_giacr135_AMT_CANCELLED;

function get_giacr135_BT_AMT_VALID (
P_DISB_MODE   VARCHAR2,
p_check_amt   NUMBER,
p_dv_flag     CHARACTER
)
return Number is
	v_bt_amt_valid	NUMBER;
begin 
 IF P_DISB_MODE = 'B' AND p_dv_flag = 'P' THEN
  	--v_tot_valid := 0;
  	v_bt_amt_valid := p_check_amt;
  ELSE
  	--v_tot_valid := :check_amt;
  	v_bt_amt_valid := 0;
  END IF;
  
  RETURN(v_bt_amt_valid);
end get_giacr135_BT_AMT_VALID;

function get_giacr135_BT_AMT_CANCEL (
P_DISB_MODE   VARCHAR2,
p_check_amt   NUMBER,
p_dv_flag     CHARACTER
)
return Number is
	v_bt_amt_cancel	NUMBER;
begin 
 IF P_DISB_MODE = 'B' AND p_dv_flag = 'C' THEN
  	--v_tot_valid := 0;
  	v_bt_amt_cancel := p_check_amt;
  ELSE
  	--v_tot_valid := :check_amt;
  	v_bt_amt_cancel := 0;
  END IF;
  
  RETURN(v_bt_amt_cancel);
end get_giacr135_BT_AMT_CANCEL;

 FUNCTION get_giacr135_records (
      i_e_particulars      VARCHAR2,
      orderby              VARCHAR2,
      p_bank_acct_no       VARCHAR2,
      p_bank_cd            VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_post_tran_toggle   VARCHAR2,
      p_sort_item          VARCHAR2,
      v_begin_date         DATE,
      v_end_date           DATE,
      p_user_id            VARCHAR2    
   )
      RETURN giacr135_record_tab PIPELINED
   IS
      v_list   giacr135_record_type;
   BEGIN
      FOR i IN
      (
         SELECT   gdv.currency_cd,
                   DECODE
                         (gcd.check_stat,
                          2, DECODE (gcri.check_released_by, NULL, amount, 0),
                          3, DECODE (ga.tran_flag,
                                     'P', DECODE (p_post_tran_toggle,
                                                  'P', amount,
                                                  0
                                                 ),
                                     0
                                    )
                         ) unreleased_amt,
                   DECODE (gcd.check_stat,
                           2, amount,
                           3, DECODE (ga.tran_flag,
                                      'P', DECODE (p_post_tran_toggle,
                                                   'P', amount,
                                                   0
                                                  ),
                                      0
                                     )
                          ) check_amt,
                   gdv.dv_date dv_date, gdv.gibr_gfun_fund_cd,
                   gdv.gibr_branch_cd, gb.branch_name, gcd.bank_cd,
                   gba.bank_name, gcd.bank_acct_cd, gbac.bank_acct_no,
                   gcd.check_date check_date,
                   TO_CHAR (gcd.check_date, 'MM-DD-YYYY') view_check_date,
                      DECODE (gcd.check_pref_suf,
                              NULL, NULL,
                              gcd.check_pref_suf || '-'
                             )
                   || gcd.check_no dsp_check_no,
                      gcd.check_pref_suf
                   || '-'
                   || TO_CHAR (gcd.check_no, '0000000000') view_check_no,
                      DECODE (gdv.dv_pref,
                              NULL, NULL,
                              gdv.dv_pref || '-'
                             )
                   || LPAD (gdv.dv_no, 10, 0) dv_no,
                                     /* dv_no modified by jongs 06.11.2013 */
                   gdv.ref_no ref_no,
                      gdv.dv_pref
                   || '-'
                   || TO_CHAR (gdv.dv_no, '0000000000') view_dv_no,
                   ga.posting_date posting_date,
                   DECODE (gdv.dv_flag,
                           'C', 0,
                           DECODE (gcd.item_no,
                                   1, gdv.dv_amt,
                                   DECODE (ga.tran_flag, 'P', gdv.dv_amt, 0)
                                  )
                          ) dv_amt,
                   DECODE
                      (gcd.check_stat,
                       2, gcd.payee,
                       3, DECODE (ga.tran_flag,
                                  'P', DECODE (p_post_tran_toggle,
                                               'P', gcd.payee
                                                || '*** CANCELLED '
                                                || TO_CHAR (gprd.cancel_date,
                                                            'MM-DD-YYYY'
                                                           )
                                                || '***',
                                               'CANCELLED'
                                              ),
                                  'CANCELLED'
                                 )
                      ) particulars,
                   gcri.check_release_date release_date,
                   gcri.check_released_by released_by, gdv.dv_flag,
                   gcd.check_pref_suf, gcd.check_no, ga.tran_id,
                   gcd.batch_tag, NVL (gcd.disb_mode, 'C') disb_mode,
         /*Cherrie - 08/04/2011- query disp_mode from giac_chk_disbursement*/
                   gdv.particulars gdv_particulars
                              --reymon 02282012 to display the DV particulars
              FROM giac_disb_vouchers gdv,
                   giac_acctrans ga,
                   giac_branches gb,
                   giac_chk_disbursement gcd,
                   giac_banks gba,
                   giac_bank_accounts gbac,
                   giac_chk_release_info gcri,
                   giac_payt_requests_dtl gprd
             WHERE gcd.check_stat IN (2, 3)
               AND gcd.item_no = gcri.item_no(+)
               AND gdv.gacc_tran_id = ga.tran_id
               AND gdv.gacc_tran_id = gprd.tran_id
               AND gdv.gacc_tran_id = gcd.gacc_tran_id
               AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
               AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
               AND gdv.gibr_branch_cd = gb.branch_cd
               AND gcd.bank_cd = gba.bank_cd(+)
               AND gcd.bank_acct_cd = gbac.bank_acct_cd
               AND gba.bank_cd = gbac.bank_cd
--     AND gdv.gibr_branch_cd = NVL (:p_branch, gdv.gibr_branch_cd)
               AND ga.gibr_branch_cd =
                      DECODE
                         (check_user_per_iss_cd_acctg2 
                                                     (NULL,
                                                      NVL (p_branch,
                                                           gdv.gibr_branch_cd
                                                          ),
                                                      UPPER (p_module_id),
                                                      p_user_id
                                                     ),
                          1, NVL (p_branch, gdv.gibr_branch_cd),
                          NULL
                         )       --RCDatu 08.28.2012 limit to allowable branch
               AND (   (    TRUNC (ga.posting_date) BETWEEN v_begin_date
                                                        AND v_end_date
                        AND p_post_tran_toggle = 'P'
                       )
                    OR (    TRUNC (gcd.check_date) BETWEEN v_begin_date
                                                       AND v_end_date
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND gcd.bank_cd = NVL (p_bank_cd, gcd.bank_cd)
               AND gbac.bank_acct_no LIKE
                         '%'
                      || NVL (p_bank_acct_no, gbac.bank_acct_no)
                      || '%'                   /* modified by jongs 06.4.13 */
          UNION
          SELECT   gdv.currency_cd, 0 unreleased_amt, 0 check_amt,
                   gdv.dv_date dv_date, ga.gfun_fund_cd, ga.gibr_branch_cd,
                   gb.branch_name, gsc.bank_cd, gba.bank_name,
                   gsc.bank_acct_cd, gbac.bank_acct_no,
                   gsc.check_date check_date,
                   TO_CHAR (gsc.check_date, 'MM-DD-YYYY') view_check_date,
                      DECODE (gsc.check_pref_suf,
                              NULL, NULL,
                              gsc.check_pref_suf || '-'
                             )
                   || gsc.check_no dsp_check_no,
                      gsc.check_pref_suf
                   || '-'
                   || TO_CHAR (gsc.check_no, '0000000000') view_check_no,
                   gdv.dv_pref || '-' || LPAD (gdv.dv_no, 10, 0) dv_no,
                                      /* dv_no modified by jongs 06.11.2013 */
                   gdv.ref_no ref_no,
                      gdv.dv_pref
                   || '-'
                   || TO_CHAR (gdv.dv_no, '0000000000') view_dv_no,
                   ga.posting_date posting_date, 0 dv_amt,
                   DECODE (   gsc.check_pref_suf
                           || gsc.check_no
                           || TO_CHAR (gsc.gacc_tran_id),
                              gcd.check_pref_suf
                           || gcd.check_no
                           || TO_CHAR (gdv.gacc_tran_id), 'CANCELLED',
                           'SPOILED'
                          ) particulars,
                   TO_DATE ('01-JAN-00') release_date, 'DUMMY' released_by,
                   gdv.dv_flag, gsc.check_pref_suf, gsc.check_no, ga.tran_id,
                   gcd.batch_tag, NVL (gcd.disb_mode, 'C') disb_mode,
          /*Cherrie - 08/04/2011- query disp_mode from giac_chk_disbursement*/
                   gdv.particulars gdv_particulars
                               --reymon 02282012 to display the DV particulars
              FROM giac_disb_vouchers gdv,
                   giac_acctrans ga,
                   giac_spoiled_check gsc,
                   giac_branches gb,
                   giac_chk_disbursement gcd,
                   giac_banks gba,
                   giac_bank_accounts gbac
             WHERE gsc.gacc_tran_id = ga.tran_id
               AND gsc.gacc_tran_id = gdv.gacc_tran_id
               AND gcd.gacc_tran_id = gdv.gacc_tran_id
               AND ga.gfun_fund_cd = gb.gfun_fund_cd
               AND ga.gibr_branch_cd = gb.branch_cd
               AND gsc.bank_cd = gba.bank_cd
               AND gsc.bank_acct_cd = gbac.bank_acct_cd
               AND gba.bank_cd = gbac.bank_cd
--     AND ga.gibr_branch_cd = NVL (:p_branch, ga.gibr_branch_cd)
               AND ga.gibr_branch_cd =
                      DECODE
                         (check_user_per_iss_cd_acctg2
                                                     (NULL,
                                                      NVL (p_branch,
                                                           gdv.gibr_branch_cd
                                                          ),
                                                      UPPER (p_module_id),
                                                      p_user_id
                                                     ),
                          1, NVL (p_branch, gdv.gibr_branch_cd),
                          NULL
                         )       --RCDatu 08.28.2012 limit to allowable branch
               AND (   (    TRUNC (ga.posting_date) BETWEEN v_begin_date
                                                        AND v_end_date
                        AND p_post_tran_toggle = 'P'
                       )
                    OR (    TRUNC (gsc.check_date) BETWEEN v_begin_date
                                                       AND v_end_date
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND gsc.bank_cd = NVL (p_bank_cd, gsc.bank_cd)
               AND gbac.bank_acct_no LIKE
                         '%'
                      || NVL (p_bank_acct_no, gbac.bank_acct_no)
                      || '%'                   
          ORDER BY GIBR_BRANCH_CD, BANK_CD, BANK_ACCT_NO, DISB_MODE
          )
          
          
      LOOP
         v_list.currency_cd         := i.currency_cd;
         v_list.check_released_by   := i.released_by;      
         v_list.dv_date             := i.dv_date;
         v_list.gibr_gfun_fund_cd   := i.gibr_gfun_fund_cd;
         v_list.gibr_branch_cd      := i.gibr_branch_cd;
         v_list.branch_name         := i.branch_name;
         v_list.bank_cd             := i.bank_cd;
         v_list.bank_name           := i.bank_name;
         v_list.bank_acct_cd        := i.bank_acct_cd;
         v_list.bank_acct_no        := i.bank_acct_no;
         v_list.check_date          := i.check_date;
         v_list.check_pref_suf      := i.check_pref_suf;
         v_list.check_no            := i.dsp_check_no;       
         v_list.dv_no               := i.dv_no;
         v_list.ref_no              := i.ref_no;
         v_list.posting_date        := i.posting_date;
         v_list.dv_flag             := i.dv_flag;        
         v_list.dv_amt              := i.dv_amt;
         v_list.check_release_date  := i.release_date;
         v_list.tran_id             := i.tran_id;
         v_list.batch_tag           := i.batch_tag;
         v_list.disb_mode           := i.disb_mode;
         v_list.particulars         := i.particulars;
         v_list.gacc_tran_id        := i.tran_id;
         v_list.company_name        :=get_giacr135_company_name;
         v_list.company_address     := get_giacr135_company_address;
         v_list.top_date            := get_giacr135_top_date(v_begin_date, v_end_date);
         v_list.disb_mode_type      := get_giacr135_disb_mode_type(i.disb_mode);
         v_list.check_amt           := i.check_amt;
         v_list.unreleased_amt      := i.unreleased_amt;
         v_list.gdv_particulars     :=i.gdv_particulars;        
         v_list.COUNT_SPOILED       :=get_giacr135_COUNT_SPOILED(i.particulars, i.disb_mode);
         v_list.count_cancelled     :=get_giacr135_count_cancelled(i.particulars,i.disb_mode);
         v_list.COUNT_VALID_BT      := get_giacr135_COUNT_VALID_BT(i.disb_mode, i.dv_flag);
         v_list.COUNT_CANCEL_BT     := get_giacr135_COUNT_CANCEL_BT(i.disb_mode ,i.dv_flag);
         v_list.COUNT_CHECK         := get_giacr135_COUNT_CHECK(i.particulars, i.disb_mode);
         v_list.currency            :=  get_giacr135_currency(i.currency_cd);
         v_list.F_AMT_VALID         := get_giacr135_F_AMT_VALID(i.particulars, i.disb_mode, i.check_amt);
         v_list.AMT_SPOILED         := get_giacr135_AMT_SPOILED(i.particulars, i.disb_mode, i.check_amt);
         v_list.AMT_CANCELLED       := get_giacr135_AMT_CANCELLED (i.particulars, i.disb_mode, i.check_amt);
         v_list.BT_AMT_VALID        := get_giacr135_BT_AMT_VALID (i.disb_mode, i.check_amt, i.dv_flag);
         v_list.BT_AMT_CANCEL       := get_giacr135_BT_AMT_CANCEL(i.disb_mode, i.check_amt, i.dv_flag);
          
          
         PIPE ROW (v_list);
      END LOOP;
   --RETURN;
   END get_giacr135_records;
   
   
   FUNCTION get_details_in_order(
      i_e_particulars      VARCHAR2,
      orderby              VARCHAR2,
      p_bank_acct_no       VARCHAR2,
      p_bank_cd            VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_post_tran_toggle   VARCHAR2,
      p_sort_item          VARCHAR2,
      v_begin_date         VARCHAR2, --DATE,
      v_end_date           VARCHAR2, --DATE,
      p_user_id            VARCHAR2
   ) RETURN giacr135_record_tab PIPELINED
   IS
      TYPE v_type IS RECORD (
          currency_cd           NUMBER(2),
          unreleased_amt        NUMBER,
          check_amt             NUMBER,
          dv_date               DATE,
          gibr_gfun_fund_cd     VARCHAR2(3),
          gibr_branch_cd        VARCHAR2(2),
          branch_name           VARCHAR2(50),
          bank_cd               VARCHAR2(3),
          bank_name             VARCHAR2(100),
          bank_acct_cd          VARCHAR2(4),
          bank_acct_no          VARCHAR2(30),
          check_date            DATE,
          view_check_date       varchar2(1000),
          dsp_check_no          varchar2(1000),
          view_check_no         varchar2(1000),
          dv_no                 VARCHAR2(200),
          ref_no                VARCHAR2(15),
          view_dv_no            varchar2(1000),
          posting_date          DATE,
          dv_amt                NUMBER(12,2),
          particulars           VARCHAR2(2000),
          release_date          DATE,
          released_by           VARCHAR2(30),
          dv_flag               CHARACTER(1),
          check_pref_suf        VARCHAR2(5),
          check_no              VARCHAR2(200),     
          tran_id               NUMBER(12),
          batch_tag             CHARACTER(1),
          disb_mode             CHARACTER(1),
          gdv_particulars       VARCHAR2(2000)
      );
      TYPE v_tab IS TABLE OF v_type;
      
      v_list_tab    v_tab;
      v_list        giacr135_record_type;
      v_select      VARCHAR2(32767);
      v_order       VARCHAR2(100);
      v_begin_dt    DATE := to_date(v_begin_date, 'MM-DD-YYYY');
      v_end_dt      DATE := to_Date(v_end_date, 'MM-DD-YYYY');
   BEGIN
       v_order := nvl(orderby, 'CHECK_DATE');
       
       v_select := 'SELECT   gdv.currency_cd,
                   DECODE
                         (gcd.check_stat,
                          2, DECODE (gcri.check_released_by, NULL, amount, 0),
                          3, DECODE (ga.tran_flag,
                                     ''P'', DECODE ('''||p_post_tran_toggle||''',
                                                  ''P'', amount,
                                                  0
                                                 ),
                                     0
                                    )
                         ) unreleased_amt,
                   DECODE (gcd.check_stat,
                           2, amount,
                           3, DECODE (ga.tran_flag,
                                      ''P'', DECODE ('''||p_post_tran_toggle||''',
                                                   ''P'', amount,
                                                   0
                                                  ),
                                      0
                                     )
                          ) check_amt,
                   gdv.dv_date dv_date, gdv.gibr_gfun_fund_cd,
                   gdv.gibr_branch_cd, gb.branch_name, gcd.bank_cd,
                   gba.bank_name, gcd.bank_acct_cd, gbac.bank_acct_no,
                   gcd.check_date check_date,
                   TO_CHAR (gcd.check_date, ''MM-DD-YYYY'') view_check_date,
                      DECODE (gcd.check_pref_suf,
                              NULL, NULL,
                              gcd.check_pref_suf || ''-''
                             )
                   || gcd.check_no dsp_check_no,
                      gcd.check_pref_suf
                   || ''-''
                   || TO_CHAR (gcd.check_no, ''0000000000'') view_check_no,
                      DECODE (gdv.dv_pref,
                              NULL, NULL,
                              gdv.dv_pref || ''-''
                             )
                   || LPAD (gdv.dv_no, 10, 0) dv_no,
                   gdv.ref_no ref_no,
                      gdv.dv_pref
                   || ''-''
                   || TO_CHAR (gdv.dv_no, ''0000000000'') view_dv_no,
                   ga.posting_date posting_date,
                   DECODE (gdv.dv_flag,
                           ''C'', 0,
                           DECODE (gcd.item_no,
                                   1, gdv.dv_amt,
                                   DECODE (ga.tran_flag, ''P'', gdv.dv_amt, 0)
                                  )
                          ) dv_amt,
                   DECODE
                      (gcd.check_stat,
                       2, gcd.payee,
                       3, DECODE (ga.tran_flag,
                                  ''P'', DECODE ('''||p_post_tran_toggle||''',
                                               ''P'', gcd.payee
                                                || ''*** CANCELLED ''
                                                || TO_CHAR (gprd.cancel_date,
                                                            ''MM-DD-YYYY''
                                                           )
                                                || ''***'',
                                               ''CANCELLED''
                                              ),
                                  ''CANCELLED''
                                 )
                      ) particulars,
                   gcri.check_release_date release_date,
                   gcri.check_released_by released_by, gdv.dv_flag,
                   gcd.check_pref_suf, gcd.check_no, ga.tran_id,
                   gcd.batch_tag, NVL (gcd.disb_mode, ''C'') disb_mode,
                   gdv.particulars gdv_particulars
              FROM giac_disb_vouchers gdv,
                   giac_acctrans ga,
                   giac_branches gb,
                   giac_chk_disbursement gcd,
                   giac_banks gba,
                   giac_bank_accounts gbac,
                   giac_chk_release_info gcri,
                   giac_payt_requests_dtl gprd
             WHERE gcd.check_stat IN (2, 3)
               AND gcd.item_no = gcri.item_no(+)
               AND gdv.gacc_tran_id = ga.tran_id
               AND gdv.gacc_tran_id = gprd.tran_id
               AND gdv.gacc_tran_id = gcd.gacc_tran_id
               AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
               AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
               AND gdv.gibr_branch_cd = gb.branch_cd
               AND gcd.bank_cd = gba.bank_cd(+)
               AND gcd.bank_acct_cd = gbac.bank_acct_cd
               AND gba.bank_cd = gbac.bank_cd
               AND ga.gibr_branch_cd =
                      DECODE
                         (check_user_per_iss_cd_acctg2 
                                                     (NULL,
                                                      NVL ('''||p_branch||''',
                                                           gdv.gibr_branch_cd
                                                          ),
                                                      UPPER ('''||p_module_id||'''),
                                                      '''||p_user_id||'''
                                                     ),
                          1, NVL ('''||p_branch||''', gdv.gibr_branch_cd),
                          NULL
                         )
               AND (   (    trunc(ga.posting_date) BETWEEN to_date('''||v_begin_date||''', ''MM-DD-YYYY'')
                                                        AND to_date('''||v_end_date||''', ''MM-DD-YYYY'')
                        AND '''||p_post_tran_toggle||''' = ''P''
                       )
                    OR (    trunc(gcd.check_date) BETWEEN to_date('''||v_begin_date||''', ''MM-DD-YYYY'')
                                                       AND to_date('''||v_end_date||''', ''MM-DD-YYYY'')
                        AND '''||p_post_tran_toggle||''' = ''T''
                       )
                   )
               AND gcd.bank_cd = NVL ('''||p_bank_cd||''', gcd.bank_cd)
               AND gbac.bank_acct_no LIKE
                         ''%''
                      || NVL ('''||p_bank_acct_no||''', gbac.bank_acct_no)
                      || ''%''                 
          UNION
          SELECT   gdv.currency_cd, 0 unreleased_amt, 0 check_amt,
                   gdv.dv_date dv_date, ga.gfun_fund_cd, ga.gibr_branch_cd,
                   gb.branch_name, gsc.bank_cd, gba.bank_name,
                   gsc.bank_acct_cd, gbac.bank_acct_no,
                   gsc.check_date check_date,
                   TO_CHAR (gsc.check_date, ''MM-DD-YYYY'') view_check_date,
                      DECODE (gsc.check_pref_suf,
                              NULL, NULL,
                              gsc.check_pref_suf || ''-''
                             )
                   || gsc.check_no dsp_check_no,
                      gsc.check_pref_suf
                   || ''-''
                   || TO_CHAR (gsc.check_no, ''0000000000'') view_check_no,
                   gdv.dv_pref || ''-'' || LPAD (gdv.dv_no, 10, 0) dv_no,
                   gdv.ref_no ref_no,
                      gdv.dv_pref
                   || ''-''
                   || TO_CHAR (gdv.dv_no, ''0000000000'') view_dv_no,
                   ga.posting_date posting_date, 0 dv_amt,
                   DECODE (   gsc.check_pref_suf
                           || gsc.check_no
                           || TO_CHAR (gsc.gacc_tran_id),
                              gcd.check_pref_suf
                           || gcd.check_no
                           || TO_CHAR (gdv.gacc_tran_id), ''CANCELLED'',
                           ''SPOILED''
                          ) particulars,
                   TO_DATE(''01-01-2000'', ''MM-DD-YYYY'') release_date, '-- Edited By MArkS 05.04.2016 SR-5197 error in changing when inserting the record into the table_type
                   ||'''DUMMY'' released_by,
                   gdv.dv_flag, gsc.check_pref_suf, gsc.check_no, ga.tran_id,
                   gcd.batch_tag, NVL (gcd.disb_mode, ''C'') disb_mode,
                   gdv.particulars gdv_particulars
              FROM giac_disb_vouchers gdv,
                   giac_acctrans ga,
                   giac_spoiled_check gsc,
                   giac_branches gb,
                   giac_chk_disbursement gcd,
                   giac_banks gba,
                   giac_bank_accounts gbac
             WHERE gsc.gacc_tran_id = ga.tran_id
               AND gsc.gacc_tran_id = gdv.gacc_tran_id
               AND gcd.gacc_tran_id = gdv.gacc_tran_id
               AND ga.gfun_fund_cd = gb.gfun_fund_cd
               AND ga.gibr_branch_cd = gb.branch_cd
               AND gsc.bank_cd = gba.bank_cd
               AND gsc.bank_acct_cd = gbac.bank_acct_cd
               AND gba.bank_cd = gbac.bank_cd
               AND ga.gibr_branch_cd =
                      DECODE
                         (check_user_per_iss_cd_acctg2
                                                     (NULL,
                                                      NVL ('''||p_branch||''',
                                                           gdv.gibr_branch_cd
                                                          ),
                                                      UPPER ('''||p_module_id||'''),
                                                      '''||p_user_id||'''
                                                     ),
                          1, NVL ('''||p_branch||''', gdv.gibr_branch_cd),
                          NULL
                         )
               AND (   (    trunc(ga.posting_date) BETWEEN to_date('''||v_begin_date||''', ''MM-DD-YYYY'')
                                                        AND to_date('''||v_end_date||''', ''MM-DD-YYYY'')
                        AND '''||p_post_tran_toggle||''' = ''P''
                       )
                    OR (    trunc (gsc.check_date) BETWEEN to_date('''||v_begin_date||''', ''MM-DD-YYYY'')
                                                       AND to_date('''||v_end_date||''', ''MM-DD-YYYY'')
                        AND '''||p_post_tran_toggle||''' = ''T''
                       )
                   )
               AND gsc.bank_cd = NVL ('''||p_bank_cd||''', gsc.bank_cd)
               AND gbac.bank_acct_no LIKE
                         ''%''
                      || NVL ('''||p_bank_acct_no||''', gbac.bank_acct_no)
                      || ''%''                   
          ORDER BY GIBR_BRANCH_CD, BANK_CD, BANK_ACCT_NO, DISB_MODE, '|| v_order ;
        
       EXECUTE IMMEDIATE v_select BULK COLLECT INTO v_list_tab;
       
       IF v_list_tab.LAST > 0 THEN
       
            FOR i IN v_list_tab.FIRST .. v_list_tab.LAST
            LOOP
                 v_list.currency_cd         := v_list_tab(i).currency_cd;
                 v_list.unreleased_amt      := v_list_tab(i).unreleased_amt;
                 v_list.check_amt           := v_list_tab(i).check_amt;
                 v_list.dv_date             := v_list_tab(i).dv_date;
                 v_list.gibr_gfun_fund_cd   := v_list_tab(i).gibr_gfun_fund_cd;
                 v_list.gibr_branch_cd      := v_list_tab(i).gibr_branch_cd;
                 v_list.branch_name         := v_list_tab(i).branch_name;
                 v_list.bank_cd             := v_list_tab(i).bank_cd;
                 v_list.bank_name           := v_list_tab(i).bank_name;
                 v_list.bank_acct_cd        := v_list_tab(i).bank_acct_cd;
                 v_list.bank_acct_no        := v_list_tab(i).bank_acct_no;
                 v_list.check_date          := v_list_tab(i).check_date;
                 v_list.view_check_date     := v_list_tab(i).view_check_date;
                 v_list.dsp_check_no        := v_list_tab(i).dsp_check_no;    
                 v_list.view_check_no       := v_list_tab(i).view_check_no;
                 v_list.dv_no               := v_list_tab(i).dv_no;
                 v_list.ref_no              := v_list_tab(i).ref_no;
                 v_list.view_dv_no          := v_list_tab(i).view_dv_no;
                 v_list.posting_date        := v_list_tab(i).posting_date;
                 v_list.dv_amt              := v_list_tab(i).dv_amt;
                 v_list.particulars         := v_list_tab(i).particulars;
                 v_list.check_release_date  := v_list_tab(i).release_date;
                 v_list.check_released_by   := v_list_tab(i).released_by; 
                 v_list.dv_flag             := v_list_tab(i).dv_flag; 
                 v_list.check_pref_suf      := v_list_tab(i).check_pref_suf;
                 v_list.check_no            := v_list_tab(i).check_no;     
                 v_list.tran_id             := v_list_tab(i).tran_id;
                 v_list.batch_tag           := v_list_tab(i).batch_tag;
                 v_list.disb_mode           := v_list_tab(i).disb_mode;
                 v_list.gdv_particulars     := v_list_tab(i).gdv_particulars;                 
                 -- added by robert SR 5197 02.02.16       
                 IF  v_list.check_amt  = 0
				 THEN
					v_list.check_release_date:= NULL;
				 ELSE
					v_list.check_release_date  := v_list_tab(i).release_date;
				 END IF;
                 ----
                 v_list.company_name        := get_giacr135_company_name;
                 v_list.company_address     := get_giacr135_company_address;
                 v_list.top_date            := get_giacr135_top_date(v_begin_dt, v_end_dt);
                 v_list.disb_mode_type      := get_giacr135_disb_mode_type(v_list_tab(i).disb_mode);                 
                 v_list.COUNT_SPOILED       := get_giacr135_COUNT_SPOILED(v_list_tab(i).particulars, v_list_tab(i).disb_mode);
                 v_list.count_cancelled     := get_giacr135_count_cancelled(v_list_tab(i).particulars,v_list_tab(i).disb_mode);
                 v_list.COUNT_VALID_BT      := get_giacr135_COUNT_VALID_BT(v_list_tab(i).disb_mode, v_list_tab(i).dv_flag);
                 v_list.COUNT_CANCEL_BT     := get_giacr135_COUNT_CANCEL_BT(v_list_tab(i).disb_mode ,v_list_tab(i).dv_flag);
                 v_list.COUNT_CHECK         := get_giacr135_COUNT_CHECK(v_list_tab(i).particulars, v_list_tab(i).disb_mode);
                 v_list.currency            := get_giacr135_currency(v_list_tab(i).currency_cd);
                 v_list.F_AMT_VALID         := get_giacr135_F_AMT_VALID(v_list_tab(i).particulars, v_list_tab(i).disb_mode, v_list_tab(i).check_amt);
                 v_list.AMT_SPOILED         := get_giacr135_AMT_SPOILED(v_list_tab(i).particulars, v_list_tab(i).disb_mode, v_list_tab(i).check_amt);
                 v_list.AMT_CANCELLED       := get_giacr135_AMT_CANCELLED (v_list_tab(i).particulars, v_list_tab(i).disb_mode, v_list_tab(i).check_amt);
                 v_list.BT_AMT_VALID        := get_giacr135_BT_AMT_VALID (v_list_tab(i).disb_mode, v_list_tab(i).check_amt, v_list_tab(i).dv_flag);
                 v_list.BT_AMT_CANCEL       := get_giacr135_BT_AMT_CANCEL(v_list_tab(i).disb_mode, v_list_tab(i).check_amt, v_list_tab(i).dv_flag);
            
                 PIPE ROW(v_list);
            END LOOP;
       
       ELSE
             v_list.company_name        := get_giacr135_company_name;
             v_list.company_address     := get_giacr135_company_address;
             v_list.top_date            := get_giacr135_top_date(v_begin_dt, v_end_dt);
             PIPE ROW(v_list);
       END IF;
   END;
   
END;
/


