CREATE OR REPLACE PACKAGE BODY CPI.GIACR121B_PKG AS


FUNCTION CF_col_titleFormula(
    p_col   NUMBER,
    p_rep   NUMBER
)
RETURN VARCHAR2 IS
    v_col            VARCHAR2(50);
BEGIN
    FOR rec IN (SELECT col_title
                  FROM giac_soa_title
                 WHERE col_no = p_col
                   AND rep_cd = p_rep)
  LOOP
      v_col := rec.col_title;
  END LOOP;                       
  RETURN(v_col);
END;

FUNCTION f_amt1 (
p_user  VARCHAR2,
p_ri_cd VARCHAR2,
p_comm  VARCHAR2
)
RETURN Number is
    v_amt           NUMBER(16,2);
    v_gross_amt        NUMBER(16,2);
    v_ri_comm_exp   NUMBER(16,2);
BEGIN
    FOR a IN (SELECT ri_name,
                        SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem,
                        SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm
                  FROM giac_ri_stmt_ext
                  WHERE TRUNC(cut_off_date)-TRUNC(due_date) <= 90
                  AND ri_cd = p_ri_cd
                  AND user_id = p_user
                  GROUP BY ri_name)
        LOOP
            v_gross_amt := a.gross_prem;
            v_ri_comm_exp := a.ri_comm;
        END LOOP;
     
     IF p_comm = 'C' THEN
           v_amt := v_gross_amt;
     ELSE         
           v_amt := v_gross_amt - v_ri_comm_exp;
     END IF;    
  RETURN(nvl(v_amt, 0));
END f_amt1;

FUNCTION f_comm1 (
p_user  VARCHAR2,
p_ri_cd VARCHAR2,
p_comm  VARCHAR2
)
RETURN Number is
    v_amt           NUMBER(16,2);
    v_dummy         NUMBER(16,2);    
BEGIN
    FOR a IN (SELECT ri_name,
                        SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem,
                        SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm
                  FROM giac_ri_stmt_ext
                  WHERE TRUNC(cut_off_date)-TRUNC(due_date) <= 90
                  AND ri_cd = p_ri_cd
                  AND user_id = p_user
                  GROUP BY ri_name)
        LOOP
           v_dummy := a.ri_comm;
        END LOOP;
    v_amt := NVL((v_dummy * -1),0);    
    RETURN(nvl(v_amt, 0));
END f_comm1;

FUNCTION f_amt2 (
p_user  VARCHAR2,
p_ri_cd VARCHAR2,
p_comm  VARCHAR2
)
RETURN Number is
    v_amt           NUMBER(16,2);
    v_gross_amt        NUMBER(16,2);
    v_ri_comm_exp   NUMBER(16,2);
    
BEGIN

    FOR b IN (SELECT ri_name,
                         SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem,
                         SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm
                  FROM giac_ri_stmt_ext
                  WHERE TRUNC(cut_off_date)-TRUNC(due_date) > 90
                  AND TRUNC(cut_off_date)-TRUNC(due_date) < 150
                  AND user_id = p_user
                  AND ri_cd = p_ri_cd
                  GROUP BY ri_name)
        LOOP
            v_gross_amt := b.gross_prem;
            v_ri_comm_exp := b.ri_comm;
        END LOOP;
     
     IF p_comm = 'C' THEN
           v_amt := v_gross_amt;
     ELSE         
           v_amt := v_gross_amt - v_ri_comm_exp;
     END IF;    
  RETURN(nvl(v_amt, 0));
END f_amt2;

FUNCTION f_comm2 (
p_user  VARCHAR2,
p_ri_cd VARCHAR2,
p_comm  VARCHAR2
)
RETURN Number is
    v_amt           NUMBER(16,2);
    v_dummy         NUMBER(16,2);    
BEGIN
    FOR b IN (SELECT ri_name,
                         SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem,
                         SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm
                  FROM giac_ri_stmt_ext
                  WHERE TRUNC(cut_off_date)-TRUNC(due_date) > 90
                  AND TRUNC(cut_off_date)-TRUNC(due_date) < 150
                  AND user_id = p_user
                  AND ri_cd = p_ri_cd
                  GROUP BY ri_name)
        LOOP
             v_dummy := b.ri_comm;
        END LOOP;
     v_amt   := NVL((v_dummy*-1),0);  
  RETURN(nvl(v_amt, 0));
END f_comm2;

FUNCTION f_amt3 (
p_user  VARCHAR2,
p_ri_cd VARCHAR2,
p_comm  VARCHAR2
)
RETURN Number is
    v_amt           NUMBER(16,2);
    v_gross_amt        NUMBER(16,2);
    v_ri_comm_exp   NUMBER(16,2);
    
BEGIN

    FOR c IN (SELECT ri_name,
                   SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem,
                   SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm
            FROM giac_ri_stmt_ext
            WHERE TRUNC(cut_off_date)-TRUNC(due_date) >= 150
            AND ri_cd = p_ri_cd
            AND user_id = p_user
            GROUP BY ri_name)
        LOOP
            v_gross_amt := c.gross_prem;
            v_ri_comm_exp := c.ri_comm;
        END LOOP;
     
     IF p_comm = 'C' THEN
           v_amt := v_gross_amt;
     ELSE         
           v_amt := v_gross_amt - v_ri_comm_exp;
     END IF;    
  RETURN(nvl(v_amt, 0));
END f_amt3;

FUNCTION f_comm3 (
p_user  VARCHAR2,
p_ri_cd VARCHAR2,
p_comm  VARCHAR2
)
RETURN Number is
    v_amt     NUMBER(16,2);
    v_dummy   NUMBER(16,2);
    
BEGIN

    FOR c IN (SELECT ri_name,
                   SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem,
                   SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm
            FROM giac_ri_stmt_ext
            WHERE TRUNC(cut_off_date)-TRUNC(due_date) >= 150
            AND ri_cd = p_ri_cd
            AND user_id = p_user
            GROUP BY ri_name)
        LOOP
            v_dummy := c.ri_comm;
        END LOOP;
     
    v_amt   := NVL((v_dummy*-1),0);    
  RETURN(nvl(v_amt, 0));
END f_comm3;

FUNCTION populate_giacr121b(
    p_ri_cd     VARCHAR2,
    p_line_cd   VARCHAR2,
    p_aging     VARCHAR2,
    p_comm      VARCHAR2,
    p_user      VARCHAR2,
    p_cut_off   VARCHAR2
)
RETURN giacr121b_tab PIPELINED AS

v_rec       giacr121b_type;
v_cut_off   DATE := TO_DATE(p_cut_off, 'MM/dd/YYYY');
v_not_exist   BOOLEAN        := TRUE;   

BEGIN
    v_rec.company_name      :=  giacp.v('COMPANY_NAME');
    v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
    v_rec.cut_off           :=  'As of '||to_char(v_cut_off, 'fmMonth DD, RRRR');
    
    FOR i IN (SELECT DISTINCT trunc(extract_date) ext_date
                FROM giac_ri_stmt_ext
                WHERE user_id = p_user
                ORDER BY ext_date DESC) --edited by gab 11.13.2015
    LOOP  
      v_rec.extract_date := 'Extract Date '||to_char(i.ext_date, 'FmMonth DD, RRRR');    
      EXIT; --added by gab 11.10.2015
    END LOOP;            
         
    v_rec.extract_date :=NVL( v_rec.extract_date , ' ');  -- carlo - 08102015 - SR 3932
    
    FOR i IN (SELECT ri_name,         
                     ri_cd,
                     SUM(nvl(gross_prem_amt, 0) + nvl(prem_vat, 0)) gross_prem_amt,
                     SUM(nvl(ri_comm_exp, 0) + nvl(comm_vat, 0)) ri_comm,
                     SUM(after_date_prem) after_date_prem,
                     sum(after_date_comm) after_date_comm
              FROM giac_ri_stmt_ext
              WHERE ri_cd = NVL(p_ri_cd,ri_cd)
              AND line_cd = NVL(p_line_cd,line_cd)
              AND user_id = p_user
--              AND check_user_per_line2(NVL(p_line_cd,line_cd), iss_cd, 'GIACS121', p_user) = 1                --commented out by gab 09.24.2015
--              AND check_user_per_iss_cd_acctg2(p_line_cd, iss_cd, 'GIACS121', p_user) = 1
              AND iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user)))-- added by gab 09.24.2015
              GROUP BY ri_name,ri_cd
              ORDER BY ri_name    
    )
    LOOP
        v_not_exist := FALSE;
        v_rec.ri_code			:= i.ri_cd; --added by Daniel Marasigan SR 5348
        v_rec.ri_name           := i.ri_name;
        v_rec.after_date_comm   := NVL(i.after_date_comm,0);
        v_rec.month             := 'Total as of '||to_char(v_cut_off, 'fmMonth');
        v_rec.col_title1        := CF_col_titleFormula(1,2);
        v_rec.col_title2        := CF_col_titleFormula(2,2);
        v_rec.col_title3        := CF_col_titleFormula(3,2);
        v_rec.amt_1             := f_amt1(p_user, i.ri_cd, p_comm);
        v_rec.amt_2             := f_amt2(p_user, i.ri_cd, p_comm);
        v_rec.amt_3             := f_amt3(p_user, i.ri_cd, p_comm);
        v_rec.comm_1            := f_comm1(p_user, i.ri_cd,p_comm);
        v_rec.comm_2            := f_comm2(p_user, i.ri_cd,p_comm);
        v_rec.comm_3            := f_comm3(p_user, i.ri_cd,p_comm);       
        v_rec.tot_amt           := NVL((v_rec.amt_1+v_rec.amt_2+v_rec.amt_3),0);
        v_rec.tot_comm          := NVL((v_rec.comm_1+v_rec.comm_2+v_rec.comm_3),0);
        v_rec.after_dt_amt      := NVL(i.after_date_prem,0);
        v_rec.balance           := NVL((v_rec.tot_amt - i.after_date_prem),0);    
        v_rec.bal_comm          := NVL((v_rec.tot_comm - i.after_date_comm),0);
        v_rec.after_dt_bal_prem := NVL((v_rec.tot_amt - v_rec.after_dt_amt),0);
        v_rec.after_dt_bal_comm := NVL((v_rec.tot_comm - i.after_date_comm),0);
        
        if p_comm = 'C' then
            v_rec.prem_comm     := NVL((v_rec.tot_amt + v_rec.tot_comm),0);
            v_rec.net_bal_due   := NVL((v_rec.balance + v_rec.bal_comm),0);
            v_rec.tot_net_prem  := NVL((v_rec.tot_amt + v_rec.tot_comm),0);
            v_rec.bal_aft_date  := NVL((v_rec.after_dt_bal_prem + v_rec.after_dt_bal_comm),0);
        else  
            v_rec.prem_comm     := NVL(v_rec.tot_amt,0);
            v_rec.net_bal_due   := NVL(v_rec.balance,0);
            v_rec.tot_net_prem  := NVL(v_rec.tot_amt,0);
            v_rec.bal_aft_date  := NVL(v_rec.after_dt_bal_prem,0);               
        END IF;
        
        IF p_comm = 'D' then
            v_rec.net_prem1 := NVL(v_rec.amt_1,0);
            v_rec.net_prem2 := NVL(v_rec.amt_2,0);
            v_rec.net_prem3 := NVL(v_rec.amt_3,0);
        ELSE 
            v_rec.net_prem1 := NVL((v_rec.amt_1 + v_rec.comm_1),0);
            v_rec.net_prem2 := NVL((v_rec.amt_2 + v_rec.comm_2),0);
            v_rec.net_prem3 := NVL((v_rec.amt_3 + v_rec.comm_3),0);
        END IF;
        
        PIPE ROW(v_rec);
    END LOOP;   

    IF v_not_exist
    THEN
        v_rec.v_not_exist := 'TRUE';
        PIPE ROW (v_rec);
    END IF;               
    
END populate_giacr121b;

END GIACR121B_PKG;
/


