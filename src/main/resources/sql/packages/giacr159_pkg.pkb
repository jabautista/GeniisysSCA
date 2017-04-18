CREATE OR REPLACE PACKAGE BODY CPI.GIACR159_PKG AS
FUNCTION populate_giacr159(
    p_from_date     DATE,
    p_to_date       DATE
)
RETURN giacr159_tab PIPELINED as 

    v_rec giacr159_type;
 

    
BEGIN
    FOR a IN(
        SELECT
            e.or_pref_suf ,
            e.or_no,   
            e.or_pref_suf||'-'||e.or_no  or_pref_suf_or_no ,
            a.incept_date,
            DECODE( A.ENDT_SEQ_NO, 0,
                SUBSTR(A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                    TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO,'fm0000000' )||'-'||
                    TO_CHAR( A.RENEW_NO, 'fm00' ) , 1,37),
                SUBSTR( A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                    TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO , 'fm0000000' ) ||'-'|| A.ENDT_ISS_CD
                    ||'-'|| TO_CHAR( A.ENDT_YY) ||'-'||TO_CHAR( A.ENDT_SEQ_NO, 'fm000000' )||'-'||
                    TO_CHAR( A.RENEW_NO, 'fm00' ), 1,37)) POLICY_NO,
            c.b140_iss_cd||'-'|| c.b140_prem_seq_no bill_no, 
            c.b140_iss_cd,
            c.b140_prem_seq_no,
            c.inst_no,
            d.tran_date,
            c.collection_amt, 
            d.tran_flag,
            NVL(decode(d.tran_flag,'P',c.collection_amt),0) posted,
            NVL(decode(d.tran_flag,'P',0,c.collection_amt),0) unposted,
            d.posting_date,
            a.par_id,
            g.assd_no,
            g.assd_name
        FROM gipi_polbasic  a,
             gipi_invoice   b,
             giac_direct_prem_collns c,
             giac_acctrans  d, 
             giac_order_of_payts  e,
             gipi_parlist f,
             giis_assured g
        WHERE a.policy_id = b.policy_id
          AND b.iss_cd = c.b140_iss_cd
          AND b.prem_Seq_no = c.b140_prem_Seq_no
          AND c.gacc_tran_id = d.tran_id
          AND d.tran_id = e.gacc_tran_id
          AND a.par_id = f.par_id
          AND f.assd_no = g.assd_no
          AND a.line_cd != 'BB'
          AND trunc(d.tran_date)     >= nvl(p_from_date, trunc(d.tran_date))               
          AND trunc(d.tran_date)     <=  nvl(p_to_date , trunc(d.tran_date))            
          AND d.tran_flag != 'D'
          AND d.tran_id not in (SELECT z.gacc_tran_id
                                FROM giac_reversals z, giac_acctrans x
                                WHERE z.reversing_tran_id = x.tran_id
                                AND x.tran_flag != 'D')
        ORDER BY    e.or_pref_suf, 
                    e.or_no,  
                    a.line_cd, 
                    a.subline_cd, 
                    a.iss_Cd, 
                    a.issue_yy, 
                    a.pol_seq_no 
        
        )
        LOOP
            v_rec.company_name      :=  giacp.v('COMPANY_NAME');
            v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
            v_rec.or_pref_suf       :=  a.or_pref_suf;
            v_rec.or_no             :=  a.or_no;
            v_rec.or_pref_suf_or_no :=  a.or_pref_suf_or_no;
            v_rec.incept_date       :=  a.incept_date;
            v_rec.policy_no         :=  a.policy_no;
            v_rec.bill_no           :=  a.bill_no;
            v_rec.b140_iss_cd       :=  a.b140_iss_cd;
            v_rec.b140_prem_seq_no  :=  a.b140_prem_seq_no;
            v_rec.inst_no           :=  a.inst_no;
            v_rec.tran_date         :=  a.tran_date;
            v_rec.collection_amt    :=  a.collection_amt;
            v_rec.tran_flag         :=  a.tran_flag;
            v_rec.posted            :=  a.posted;
            v_rec.unposted          :=  a.unposted;
            v_rec.posting_date      :=  a.posting_date;
            v_rec.par_id            :=  a.par_id;
            v_rec.assd_no           :=  a.assd_no;
            v_rec.assd_name         :=  a.assd_name;
            v_rec.intm_no           := GIACR159_PKG.CF_intm_noFormula(a.b140_iss_cd,a.b140_prem_seq_no);
            PIPE ROW (v_rec);
            
        END LOOP;
 
END populate_giacr159;
function CF_intm_noFormula
    (p_b140_iss_cd  GIAC_DIRECT_PREM_COLLNS.B140_ISS_CD%TYPE,
     p_b140_prem_seq_no  GIAC_DIRECT_PREM_COLLNS.B140_PREM_SEQ_NO%TYPE
    )

return Number is
  v_intm                   gipi_comm_invoice.intrmdry_intm_no%type;
  v_share                  gipi_comm_invoice.share_percentage%type;
begin
     begin
      select max(share_percentage) 
      into v_share
      from gipi_comm_invoice
      where iss_cd = p_b140_iss_cd
       and prem_seq_no = p_b140_prem_seq_no;
     exception
      when no_data_found then
        null;
     end;
     begin

      select min(intrmdry_intm_no)
      into v_intm
      from gipi_comm_invoice 
      where iss_cd = p_b140_iss_cd
       and prem_seq_no = p_b140_prem_seq_no
       and share_percentage = v_share;

      return(v_intm);

     exception
      when no_data_found then

        select max(intrmdry_intm_no)
        into v_intm
        from gipi_comm_invoice
        where iss_cd = p_b140_iss_cd
       and prem_seq_no = p_b140_prem_seq_no;

        return(v_intm);

     end;
 end;

END GIACR159_PKG;
/


