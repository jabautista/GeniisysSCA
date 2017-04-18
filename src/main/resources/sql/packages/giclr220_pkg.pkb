CREATE OR REPLACE PACKAGE BODY CPI.giclr220_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/19/2013
**Description: GICLR220 - Biggest Claims
*/

FUNCTION populate_giclr220(
    p_col               VARCHAR2,
    p_amt               VARCHAR2,
    p_assd_no           NUMBER,
    p_date              VARCHAR2,
    p_date_as           DATE,
    p_date_fr           DATE,
    p_date_to           DATE,
    p_extract_type      VARCHAR2,
    p_intm_no           NUMBER,
    p_iss_cd            VARCHAR2,
    p_line_cd           VARCHAR2,
    p_loss_exp          VARCHAR2,
    p_session_id        NUMBER,
    p_subline_cd        VARCHAR2
)
RETURN giclr220_tab PIPELINED AS

v_rec       giclr220_type;
v_not_exist BOOLEAN := TRUE;
v_date      VARCHAR2(20);
v_count     NUMBER(10);
BEGIN
    IF p_amt = 'O' THEN
        v_rec.date_lbl  := ('As of '||to_char(p_date_as, 'fmMonth DD, YYYY'));
    ELSE
        IF p_date = 'F' THEN
            v_date := 'Claim File';
        ELSIf p_date = 'L' THEN
            v_date := 'Loss';
        ELSE
            v_date := 'Settlement';
        END IF;    

        v_rec.date_lbl  := ('For the '||v_date||' period '||to_char(p_date_fr, 'fmMonth DD, YYYY')||' to '||to_char(p_date_to, 'fmMonth DD, YYYY'));         
    END IF;
    
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giisp.v('COMPANY_ADDRESS');
    
    SELECT COUNT(a.claim_id)
    INTO v_count
    FROM gicl_clm_summary a, gicl_claims b
    WHERE a.claim_id = b.claim_id
    AND session_id = p_session_id;
    
    FOR a IN (select distinct extract_type
              from gicl_clm_summary
              where session_id = p_session_id)
    LOOP 
  
         IF a.extract_type = 'N' THEN
            v_rec.title := ('TOP '|| v_count ||' CLAIMS');
        ELSIF a.extract_type = 'L' THEN 
               v_rec.title := ('BIGGEST CLAIM - LOSS AMOUNT');
        END IF;
      EXIT;
    END LOOP;
    
    IF p_line_cd IS NOT NULL THEN
        v_rec.line_name     := ('-   '||get_line_name(p_line_cd));
    ELSE v_rec.line_name     := null;
    END IF;
    
    IF p_subline_cd IS NOT NULL THEN
        FOR c IN (SELECT ('-   '||subline_name) subline_name
                  FROM giis_subline
                  WHERE line_cd = p_line_cd
                  AND subline_cd = p_subline_cd)
        LOOP
            v_rec.subline_name := c.subline_name;
            EXIT;
        END LOOP;
    ELSE    v_rec.subline_name := null;
    END IF;
    
    IF p_iss_cd IS NOT NULL THEN
        v_rec.iss_name      := ('-   '||get_iss_name(p_iss_cd));
    ELSE v_rec.iss_name := null;
    END IF;
    
    IF p_assd_no IS NOT NULL THEN
        v_rec.assd_name     := ('-   '||get_assd_name(p_assd_no));
    ELSE v_rec.assd_name := null;
    END IF;
    
    IF p_intm_no IS NOT NULL THEN 
        FOR f IN (SELECT ('-   '||intm_name) intm_name
                  FROM giis_intermediary
                  WHERE intm_no = p_intm_no)
        LOOP
            v_rec.intm_name := f.intm_name;
            EXIT;
        END LOOP;  
    ELSE v_rec.intm_name := null;
    END IF;
    
    v_rec.v_ri_cd       := giacp.v('RI_ISS_CD');
    v_rec.dummy         := NVL(p_iss_cd,'#*');
    FOR i IN(SELECT rownum, a.claim_id, 
                    a.assd_no, a.intm_no,
                    b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy,'09'))
                            ||'-'||LTRIM(TO_CHAR(b.clm_seq_no,'0999999')) claim_number,
                    b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))
                            ||'-'||LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')) policy_number, 
                    loss_amt, expense_amt, a.clm_file_date, a.loss_date, 
                    NVL(loss_amt,0) + NVL(expense_amt,0)loss_exp_amt,
                    NVL(net_ret_loss, 0)                net_ret_loss, 
                    NVL(net_ret_exp, 0)                 net_ret_exp,
                    NVL(facul_loss, 0)                  facul_loss, 
                    NVL(facul_exp, 0)                   facul_exp, 
                    NVL(treaty_loss, 0)                 treaty_loss, 
                    NVL(treaty_exp, 0)                  treaty_exp,
                    NVL(xol_loss, 0)                    xol_loss, 
                    NVL(xol_exp, 0)                     xol_exp
             FROM gicl_clm_summary a, gicl_claims b
             WHERE a.claim_id = b.claim_id
             AND session_id = p_session_id
             ORDER BY loss_exp_amt DESC)
    
    LOOP
        v_not_exist         := FALSE;
        v_rec.claim_number  := i.claim_number;
        v_rec.policy_number := i.policy_number;
        v_rec.assd_name_det := get_assd_name(i.assd_no);
        IF p_intm_no IS NULL THEN
            FOR rec IN (SELECT intm_name, intm_no
                     FROM giis_intermediary
                    WHERE intm_no IN (SELECT DISTINCT intm_no
                                        FROM gicl_intm_itmperil
                                       WHERE claim_id = i.claim_id))
            LOOP
                v_rec.intm_name_det := rec.intm_no||'/'||rec.intm_name||chr(10);
                EXIT;        
            END LOOP;  
        END IF;
        v_rec.loss_date     := i.loss_date;
        v_rec.clm_file_date := i.clm_file_date;
        v_rec.loss_amt      := i.loss_amt;
        v_rec.expense_amt   := i.expense_amt;
        IF p_loss_exp = 'E' THEN      
            v_rec.net_ret_loss  := i.net_ret_exp;
            v_rec.facul_loss    := i.facul_exp;
            v_rec.treaty_loss   := i.treaty_exp;
            v_rec.xol_loss      := i.xol_exp;
        ELSE
            v_rec.net_ret_loss  := i.net_ret_loss;
            v_rec.facul_loss    := i.facul_loss;
            v_rec.treaty_loss   := i.treaty_loss;
            v_rec.xol_loss      := i.xol_loss;
        END IF;  
        v_rec.net_ret_exp   := i.net_ret_exp;
        v_rec.facul_exp     := i.facul_exp;
        v_rec.treaty_exp    := i.treaty_exp;
        v_rec.xol_exp       := i.xol_exp;
        v_rec.loss_exp_amt  := i.loss_exp_amt;
        PIPE ROW(v_rec); 
    END LOOP;
    
    
    IF v_not_exist THEN
        v_rec.flag      := 'T';
        PIPE ROW(v_rec);
    ELSE null;
    END IF;
END populate_giclr220;

END giclr220_pkg;
/


