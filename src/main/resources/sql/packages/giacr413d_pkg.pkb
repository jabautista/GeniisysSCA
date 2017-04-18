CREATE OR REPLACE PACKAGE BODY CPI.GIACR413D_PKG AS
FUNCTION populate_GIACR413D(
    p_intm_type      GIIS_INTERMEDIARY.INTM_TYPE%TYPE,
    p_tran_post      VARCHAR2,
    p_from_date      DATE,
    p_to_date        DATE,
    p_user_id        GIIS_USERS.USER_ID%TYPE
)
RETURN giacr413d_tab PIPELINED as 

    v_rec giacr413d_type;
    v_is_empty VARCHAR2(1) := 'Y';
BEGIN

    SELECT decode(p_tran_post,1,'Based on Transaction Date',2,'Based on Posting Date') post_format,
           'From '||to_char(p_from_date, 'fm Month DD, YYYY')||' to '||to_char(p_to_date, 'fm Month DD, YYYY') Period
      INTO v_rec.post_format, v_rec.period
      FROM dual;
   
    v_rec.company_name      :=  giacp.v('COMPANY_NAME');
    v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');   
      
    FOR a IN(
        SELECT              d.intm_type ,  
                            a.intm_no, 
                            d.intm_name,  
                            c.intm_desc,
                            sum(a.comm_amt) comm, 
                            sum(a.wtax_amt) wtax , 
                            sum(input_vat_amt) input_vat,
                            decode(p_tran_post,1,'Based on Transaction Date',2,'Based on Posting Date') post_format,
                            'From '||to_char(p_from_date, 'fm Month DD, YYYY')||' to '||to_char(p_to_date, 'fm Month DD, YYYY') Period
        FROM                GIAC_COMM_PAYTS a,     
                            GIAC_ACCTRANS  b,  
                            GIIS_INTM_TYPE c,   
                            GIIS_INTERMEDIARY d
        WHERE               a.gacc_tran_id = b.tran_id
        AND                 c.intm_type = d.intm_type
        AND                 a.intm_no = d.intm_no
        and                 d.intm_type = nvl(p_intm_type, d.intm_type)
        AND            (    (P_TRAN_POST = 1 AND TRUNC(b.tran_date)  between p_from_date   and p_to_date  ) 
                       OR
                            (P_TRAN_POST = 2  AND TRUNC(b.posting_date) between p_from_date   and p_to_date)
                       )
        AND                 b.tran_flag       <> 'D'
        --AND b.tran_flag <> 'CP' --mikel 12.12.2016;
        AND b.tran_class NOT IN ('CP', 'CPR') --mikel 12.12.2016; SR 5874 - excluded transactions that are processed from cancelled policies module (GIACS412) 
        --AND                 check_user_per_iss_cd_acctg2 (NULL, a.iss_cd, 'GIACS413',p_user_id) = 1 --mikel 12.12.2016;
        AND EXISTS (SELECT 'X'
                                   FROM table (security_access.get_branch_line('AC', 'GIACS413', p_user_id))
                                  WHERE branch_cd = a.iss_cd) --mikel 12.12.2016; SR 5874 - optimization 
        AND                 NOT EXISTS(SELECT   c.gacc_tran_id
                                        FROM    GIAC_REVERSALS c,
                                                GIAC_ACCTRANS  d
                                        WHERE   c.reversing_tran_id = d.tran_id
                                        AND     d.tran_flag        <> 'D'
                                        AND     c.gacc_tran_id = a.gacc_tran_id)
        group by            d.intm_type ,  
                            a.intm_no, 
                            d.intm_name, 
                            decode(p_tran_post,1,'Based on Transaction Date',2,'Based on Posting Date'),
                            c.intm_desc
        ORDER by            1, 3        
        )
        LOOP
            v_is_empty := 'N';
            v_rec.intm_desc         :=  a.intm_desc;
            v_rec.post_format       :=  a.post_format;
            v_rec.intm_type         :=  a.intm_type ;  
            v_rec.intm_no           :=  a.intm_no;
            v_rec.intm_name         :=  a.intm_name;
            v_rec.comm              :=  a.comm;  
            v_rec.wtax              :=  a.wtax;  
            v_rec.input_vat         :=  a.input_vat;  
            v_rec.period            :=  a.period;
            PIPE ROW (v_rec);
            
        END LOOP;
        
        if v_rec.company_name is null then
            v_rec.company_name      :=  giacp.v('COMPANY_NAME');
            v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');            
        end if;
        
        IF v_is_empty = 'Y' THEN
             PIPE ROW (v_rec);
        END IF;
 
END populate_GIACR413D;

END GIACR413D_PKG;
/