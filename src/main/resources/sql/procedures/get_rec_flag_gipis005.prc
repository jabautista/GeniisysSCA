DROP PROCEDURE CPI.GET_REC_FLAG_GIPIS005;

CREATE OR REPLACE PROCEDURE CPI.GET_REC_FLAG_GIPIS005 (p_par_id          IN GIPI_PARLIST.par_id%TYPE,
                                                      p_par_type        IN GIPI_PARLIST.par_type%TYPE,
                                                      p_geog_cd         IN GIPI_WOPEN_LIAB.geog_cd%TYPE,
                                                      p_line_cd         IN GIPI_WPOLBAS.line_cd%TYPE,
                                                      p_subline_cd      IN GIPI_WPOLBAS.subline_cd%TYPE,
                                                      p_iss_cd          IN GIPI_WPOLBAS.iss_cd%TYPE,
                                                      p_issue_yy        IN GIPI_WPOLBAS.issue_yy%TYPE,
                                                      p_pol_seq_no      IN GIPI_WPOLBAS.pol_seq_no%TYPE,
                                                      p_limit_liability IN GIPI_WOPEN_LIAB.limit_liability%TYPE,
                                                      p_user_id         IN GIPI_WOPEN_LIAB.user_id%TYPE,
                                                      p_rec_flag        IN OUT GIPI_WOPEN_LIAB.rec_flag%TYPE,
                                                      p_message         IN OUT VARCHAR2)
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 23, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to get the record flag. 
*/                                               
IS
  v_eff_date       DATE;
  v_eta            DATE;
  v_policy_id      NUMBER(8);
  v_rec_flag       VARCHAR2(1);
  v_cargo_class_cd NUMBER(2);
  v_peril_cd       NUMBER(2);      
BEGIN
  IF p_par_type = 'P' THEN
     p_rec_flag := 'A';   
  ELSIF p_par_type = 'E' THEN
    BEGIN
      SELECT MAX(a.eff_date),
                 a.rec_flag
        INTO v_eff_date,
             v_rec_flag
        FROM gipi_open_liab_v a
       WHERE a.geog_cd    = p_geog_cd
         AND a.line_cd    = p_line_cd
         AND a.subline_cd = p_subline_cd
         AND a.iss_cd     = p_iss_cd
         AND a.issue_yy   = p_issue_yy
         AND a.pol_seq_no = p_pol_seq_no    
       GROUP BY a.rec_flag;
           
      IF V_EFF_DATE IS NULL THEN 
         p_rec_flag := 'A';            
      ELSE           
        IF v_rec_flag='D' THEN  
           p_rec_flag :='A';   
        ELSIF (v_rec_flag='A' OR v_rec_flag='C') AND (p_limit_liability>0) THEN
           p_rec_flag :='C';
        ELSIF (v_rec_flag='A' OR v_rec_flag='C') AND (p_limit_liability=0) THEN                    
           p_rec_flag :='D';  
            BEGIN
              SELECT a.eta
                INTO v_eta
                FROM gipi_open_policy_v2 a
               WHERE a.eta>=v_eff_date 
                 AND a.rec_flag      <>'D'
                 AND a.geog_cd       = p_geog_cd
                 AND a.line_cd       = p_line_cd
                 AND a.op_subline_cd = p_subline_cd
                 AND a.op_iss_cd     = p_iss_cd                      
                 AND a.op_pol_seqno  = p_pol_seq_no;     
              IF SQL%FOUND THEN
                p_message := 'There is an existing Risk Note using this Limit of Liability';
              ELSE 
                p_message := 'SUCCESS';
              END IF;                 
                         
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
              WHEN TOO_MANY_ROWS THEN
                NULL;
            END;                                                                                                     
                         
            BEGIN                  
              DECLARE
                CURSOR c1 IS             
                  SELECT MAX(a.eff_date),
                         a.cargo_class_cd 
                    FROM gipi_open_cargo_v a
                   WHERE a.geog_cd    = p_geog_cd
                     AND a.line_cd    = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd     = p_iss_cd
                     AND a.issue_yy   = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                GROUP BY a.cargo_class_cd;
                 
              BEGIN                                          
                FOR c1_rec IN c1 LOOP                         
                  GIPI_WOPEN_CARGO_PKG.del_all_gipi_wopen_cargo(p_par_id, p_geog_cd);                  
                END LOOP;
                 
                FOR c1_rec in C1 LOOP
                   DECLARE
                     wopen_cargo GIPI_WOPEN_CARGO%ROWTYPE;
                   BEGIN
                     wopen_cargo.par_id         := p_par_id;
                     wopen_cargo.geog_cd        := p_geog_cd;
                     wopen_cargo.cargo_class_cd := c1_rec.cargo_class_cd;
                     wopen_cargo.rec_flag       := v_rec_flag;
                     wopen_cargo.user_id        := p_user_id;
                                 
                     GIPI_WOPEN_CARGO_PKG.set_gipi_wopen_cargo(wopen_cargo);
                   END;                                                    
                END LOOP;
              END;
           
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
              WHEN TOO_MANY_ROWS THEN
                NULL;
            END;                                                                               
        END IF;    
      END IF;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_rec_flag :='A';   
      WHEN TOO_MANY_ROWS THEN
        NULL;
    END;                   
  END IF;
  
END GET_REC_FLAG_GIPIS005;
/


