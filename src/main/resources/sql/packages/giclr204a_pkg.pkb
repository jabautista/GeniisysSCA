CREATE OR REPLACE PACKAGE BODY CPI.GICLR204A_PKG AS
FUNCTION populate_items(
    p_session_id NUMBER,
    p_date       DATE,
    p_line_cd   GIIS_LINE.LINE_CD%TYPE,
    p_subline_cd GIIS_SUBLINE.SUBLINE_CD%TYPE,
    p_intm_no   GIIS_INTERMEDIARY.intm_no%TYPE,
    p_iss_cd    GIIS_ISSOURCE.iss_CD%TYPE,
    p_ASSD_NO    GIIS_assured.ASSD_NO%TYPE
)
RETURN GICLR204A_tab PIPELINED as 

    v_rec GICLR204A_type;
    v_as_of_date    VARCHAR2(100);
 
BEGIN
    FOR a IN(
         SELECT 
                a.line_cd, 
                a.loss_ratio_date, 
                a.curr_prem_amt,
                (a.curr_prem_res) prem_res_cy, 
                (a.prev_prem_res) prem_res_py, 
                NVL(a.loss_paid_amt,0) loss_paid_amt,
                NVL(a.curr_loss_res,0) curr_loss_res,
                NVL(a.prev_loss_res,0) prev_loss_res,
                GICLR204A_PKG.GET_LINE_NAME(a.line_cd) line_name,
                GICLR204A_PKG.GET_SUBLINE_NAME(p_subline_cd) subline_name,
                GICLR204A_PKG.GET_INTM_NAME(p_intm_no) intm_name,
                GICLR204A_PKG.GET_ISS_NAME(p_iss_cd) iss_name,
                GICLR204A_PKG.GET_ASSD_NAME(p_ASSD_NO) ASSD_name,
                nvl(a.curr_prem_amt,0) + nvl(a.prev_prem_res,0) - nvl(a.curr_prem_res,0) premiums_earned,
                nvl(a.loss_paid_amt,0) + nvl(a.curr_loss_res,0) - nvl(a.prev_loss_res,0) losses_incurred,
                'As of '||to_char(p_date, 'fmMonth DD, YYYY') as_of_date
        FROM    gicl_loss_ratio_ext a
        WHERE   a.session_id =p_session_id
        order by get_loss_ratio(a.session_id,a.line_cd,a.subline_cd,a.iss_cd,a.peril_cd,a.intm_no,a.assd_no) DESC
     )
        LOOP
                v_rec.company_name      :=  giacp.v('COMPANY_NAME');
                v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
                v_rec.line_cd           :=  a.line_cd;
                v_rec.loss_ratio_date   :=  a.loss_ratio_date;
                v_rec.curr_prem_amt     :=  NVL(a.curr_prem_amt, 0);  
                v_rec.prem_res_cy       :=  a.prem_res_cy;
                v_rec.prem_res_py       :=  a.prem_res_py;
                v_rec.loss_paid_amt     :=  a.loss_paid_amt;
                v_rec.curr_loss_res     :=  a.curr_loss_res;
                v_rec.prev_loss_res     :=  a.prev_loss_res;  
                v_rec.premiums_earned   :=  a.premiums_earned; 
                v_rec.losses_incurred   :=  a.losses_incurred;
                v_rec.as_of_date        :=  a.as_of_date;
                v_rec.line_name         :=  a.line_name;
                v_rec.subline_name      :=  a.subline_name;
                v_rec.intm_name         :=  a.intm_name;
                v_rec.iss_name          :=  a.iss_name;
                v_rec.assd_name          :=  a.assd_name;
                
                
                if nvl(a.premiums_earned, 0) != 0 then
                  v_rec.loss_ratio := (a.losses_incurred / a.premiums_earned) * 100;
                else
                  v_rec.loss_ratio := 0;
                end if;
  
                              
            PIPE ROW (v_rec);
            
        END LOOP;
        
        if v_rec.company_name is null then
        
            select
                'As of '||to_char(p_date, 'fmMonth DD, YYYY') as_of_date into v_as_of_date
            from dual;
            
           v_rec.company_name      :=  giacp.v('COMPANY_NAME');
           v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
           v_rec.as_of_date        :=  v_as_of_date;
            PIPE ROW (v_rec);
        end if;
        
 
END populate_items;




FUNCTION get_line_name(
    p_line_cd       GIIS_LINE.LINE_CD%TYPE
   )
RETURN VARCHAR2 as 
    v_line_name       GIIS_LINE.LINE_NAME%TYPE;
BEGIN
    SELECT  line_name
    INTO    V_LINE_NAME 
    FROM    GIIS_LINE
    where   line_cd = p_line_cd; 
    
    return v_line_name;      
END;
FUNCTION GET_SUBLINE_NAME(
    p_subline_cd       GIIS_SUBLINE.SUBLINE_CD%TYPE
  )
RETURN VARCHAR2 as
    v_subline_name       GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    
BEGIN
    SELECT  subline_name
    INTO    V_SUBLINE_NAME 
    FROM    GIIS_SUBLINE
    where   subline_cd = p_subline_cd; 
    
return v_subline_name;      
END GET_SUBLINE_NAME;

FUNCTION GET_ISS_NAME(
    p_iss_cd       GIIS_ISSOURCE.iss_CD%TYPE
  )
RETURN VARCHAR2 as
    v_iss_name       GIIS_ISSOURCE.ISS_NAME%TYPE;
    
BEGIN
    SELECT  iss_name
    INTO    V_iss_NAME 
    FROM    GIIS_ISSOURCE
    where   iss_cd = p_iss_cd; 
    
return v_iss_name;      
END GET_ISS_NAME;

FUNCTION GET_INTM_NAME(
    p_intm_no       GIIS_INTERMEDIARY.intm_no%TYPE
  )
RETURN VARCHAR2 as
    v_intm_name       GIIS_INTERMEDIARY.intm_NAME%TYPE;
    
BEGIN
    SELECT  intm_name
    INTO    V_INTM_NAME 
    FROM    GIIS_INTERMEDIARY
    where   intm_no = p_intm_no; 
    
return v_INTM_name;      
END GET_INTM_NAME;

FUNCTION GET_assD_NAME(
    p_ASSD_no       GIIS_assured.ASSD_no%TYPE
  )
RETURN VARCHAR2 as
    v_ASSD_name       GIIS_asSURED.ASSD_NAME%TYPE;
    
BEGIN
    SELECT  ASSD_name
    INTO    V_ASSD_NAME 
    FROM    GIIS_assured
    where   ASSD_no = p_ASSD_no; 
    
return v_ASSD_name;      
END GET_ASSD_NAME;
END GICLR204A_PKG;
/


