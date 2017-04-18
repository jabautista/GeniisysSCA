CREATE OR REPLACE PACKAGE BODY CPI.GICLR204F_pkg
AS 
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 08.06.2013
    **  Reference By : GICLR204F_PKG - LOSS RATIO BY PERIL
    */
    FUNCTION get_giclr204f_record(
    p_session_id NUMBER,
    p_date VARCHAR2,
    p_line VARCHAR2,
    p_subline_cd VARCHAR2,
    p_iss_cd    VARCHAR2,
    p_assd_no NUMBER,
    p_intm_no NUMBER
    )
    RETURN giclr204f_tab PIPELINED
    AS
        v_rec giclr204f_type;
        v_as_of_date  DATE := to_date(p_date, 'mm-dd-yyyy'  );
        
    BEGIN
    
                                                
              
        FOR i IN (
                SELECT a.peril_cd, a.line_cd, a.loss_ratio_date, 
                a.curr_prem_amt,
                (a.curr_prem_res) prem_res_cy, 
                (a.prev_prem_res) prem_res_py, 
                a.loss_paid_amt,
                a.curr_loss_res ,
                a.prev_loss_res,
                nvl(a.curr_prem_amt,0) + nvl(a.curr_prem_res,0) - nvl(a.prev_prem_res,0) premiums_earned, --changed formula for premiums  earned by Carlo Rubenecia 05.24.2016 SR 5394  
                nvl(a.loss_paid_amt,0) + nvl(a.curr_loss_res,0) - nvl(a.prev_loss_res,0) losses_incurred
                FROM gicl_loss_ratio_ext a
                WHERE a.session_id = p_session_id
               -- order by get_loss_ratio(a.session_id,a.line_cd,a.subline_cd,a.iss_cd, a.peril_cd, a.intm_no,a.assd_no) DESC
        )
        LOOP
            v_rec.peril_cd := i.peril_cd;
            v_rec.line_cd := i.line_cd;
            v_rec.loss_ratio_date := i.loss_ratio_date;
            v_rec.curr_prem_amt := i.curr_prem_amt;
            v_rec.prem_res_cy := i.prem_res_cy;
            v_rec.prem_res_py := i.prem_res_py;
            v_rec.loss_paid_amt := i.loss_paid_amt;
            v_rec.curr_loss_res := i.curr_loss_res;
            v_rec.prev_loss_res := i.prev_loss_res;
            v_rec.premiums_earned := i.premiums_earned;
            v_rec.losses_incurred := i.losses_incurred;
            
            FOR a IN (
                    select peril_name
              --      into v_rec.peril_name
                    from giis_peril
                    where peril_cd = i.peril_cd
                    and line_cd = i.line_cd       
                      )
            LOOP
                v_rec.peril_name := a.peril_name;
            END LOOP;
            
              if nvl(i.premiums_earned, 0) != 0 then
                v_rec.ratio := (i.losses_incurred / i.premiums_earned) * 100;
              end if;      
              
              
              v_rec.company_name := giisp.v('COMPANY_NAME');
              v_rec.address := giisp.v('COMPANY_ADDRESS');
              
                                        
              v_rec.as_of := 'As of '||to_char(v_as_of_date, 'fmMonth DD, YYYY');
              
              FOR i IN (select '-   '||line_name line_name
                          from giis_line   
                         where line_cd = p_line)
              LOOP
                 v_rec.line_name := i.line_name; 
              END LOOP;
              
              FOR i IN (
                          select '-   '||subline_name   subline_name
                          from giis_subline
                          where line_cd = nvl(p_line,null)
                          and subline_cd = nvl(p_subline_cd,null)
                        )
              LOOP
                    v_rec.subline_name := i.subline_name;
              END LOOP;    
              FOR i IN (            
                          select '-   '||iss_name iss_name
                          from giis_issource
                          where iss_cd = nvl(p_iss_cd,null) 
                        )
              LOOP
                          v_rec.iss_name := i.iss_name;                      
              END LOOP;
              
              FOR i IN (  
                          SELECT '-   '||assd_name assd_name
                          FROM giis_assured
                          WHERE assd_no = nvl(p_assd_no,null)
                        )
              LOOP
                    v_rec.assd_name := i.assd_name;
              END LOOP;
              
              FOR i IN (        
                          select '-   '||intm_name  intm_name
                          --into v_rec.intm_name
                          from giis_intermediary
                          where intm_no = nvl(p_intm_no,null)
                      )
              LOOP
                v_rec.intm_name := i.intm_name;
              END LOOP;         

        PIPE ROW(v_rec);
        END LOOP;
        
    END get_giclr204f_record;
END;
/


