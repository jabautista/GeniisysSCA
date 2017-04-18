DROP PROCEDURE CPI.INSERT_GIAC_TREATY_CESSIONS;

CREATE OR REPLACE PROCEDURE CPI.INSERT_GIAC_TREATY_CESSIONS
  (p_prod_cut_off_date            date,
   p_tran_flag                    giac_acctrans.tran_flag%type,
   p_tran_class                   giac_acctrans.tran_class%type)         IS
  v_cession_id         giac_treaty_cessions.cession_id%type;
BEGIN
  select max(nvl(cession_id,0))
  into v_cession_id
  from giac_treaty_cessions;

  FOR ja1 IN (
    select a.CESSION_ID       ,a.ISS_CD           ,a.POLICY_ID        ,a.CURRENCY_CD      ,
           a.TK_UP_TYPE       ,a.LINE_CD          ,a.SHARE_CD         ,a.ITEM_NO          ,
           a.TRTY_YY          ,a.RI_CD            ,sum(nvl(PREMIUM_AMT,0)) premium_amt ,
           sum(nvl(FC_PREM_AMT,0)) fc_prem_amt,sum(nvl(COMMISSION_AMT,0)) commission_amt,
           sum(nvl(FC_COMM_AMT,0)) fc_comm_amt,sum(nvl(TAX_AMT,0)) tax_amt        ,
           sum(nvl(FC_TAX_AMT,0))  fc_tax_amt ,b.tran_id
    from giac_treaty_batch_ext a,
         giac_acctrans         b
    where a.iss_cd = b.gibr_branch_cd
    and b.tran_flag = p_tran_flag
    and b.tran_class = p_tran_class
    and to_char(tran_date,'mm-dd-yyyy') = to_char(p_prod_cut_off_date,'mm-dd-yyyy')
    and b.posting_date is null
    group by a.CESSION_ID ,a.ISS_CD ,a.POLICY_ID ,a.CURRENCY_CD ,a.TK_UP_TYPE ,a.LINE_CD,
           a.SHARE_CD ,a.ITEM_NO ,a.TRTY_YY ,a.RI_CD , b.tran_id) loop

    v_cession_id := nvl(v_cession_id,0) + 1;
    insert into giac_treaty_cessions
      (CESSION_ID        ,BRANCH_CD      ,POLICY_ID      ,CURRENCY_CD    ,
       TAKE_UP_TYPE      ,LINE_CD        ,SHARE_CD       ,ITEM_NO        ,
       TREATY_YY         ,RI_CD          ,PREMIUM_AMT    ,FC_PREM_AMT    ,
       COMMISSION_AMT    ,FC_COMM_AMT    ,TAX_AMT        ,FC_TAX_AMT     ,
       CESSION_YEAR      ,CESSION_MM     ,GACC_TRAN_ID   )
    values
      (v_cession_id      ,ja1.ISS_CD     ,ja1.POLICY_ID  ,ja1.CURRENCY_CD,
       ja1.TK_UP_TYPE    ,ja1.LINE_CD    ,ja1.SHARE_CD   ,ja1.ITEM_NO    ,
       ja1.TRTY_YY       ,ja1.RI_CD      ,ja1.PREMIUM_AMT,ja1.FC_PREM_AMT,
       ja1.COMMISSION_AMT,ja1.FC_COMM_AMT,ja1.TAX_AMT    ,ja1.FC_TAX_AMT ,
       to_char(p_prod_cut_off_date,'yyyy'),to_char(p_prod_cut_off_date,'mm'), ja1.TRAN_ID );

  END LOOP ja1;
END;
/


