CREATE OR REPLACE PACKAGE BODY CPI.GICLR258_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.07.2013
    **  Reference By      : GICLR258 - CLAIM LISTING PER RECOVERY TYPE
    */
AS
    FUNCTION get_giclr258_details(
        p_rec_type_cd       giis_recovery_type.rec_type_cd%TYPE,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_user_id           VARCHAR2 -- added by: Nica 5.27.2013
    ) RETURN giclr258_tab PIPELINED AS
        res                 giclr258_type;
        v_comp_name         VARCHAR2(500);
        v_comp_add          VARCHAR2(1000);
    BEGIN
         BEGIN
             SELECT param_value_v
               INTO v_comp_add
               FROM giis_parameters
              WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_comp_add := NULL;
         END;
          
         BEGIN
             SELECT param_value_v
               INTO  v_comp_name
               FROM giis_parameters
              WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_comp_name := NULL;
         END;
        FOR i IN (SELECT b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LPAD(b.clm_yy,2,'0')||'-'||LPAD(clm_seq_no,7,'0') claim_no,
                         b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LPAD(b.issue_yy,2,'0')||'-'||LPAD(pol_seq_no,7,'0')||'-'||LPAD(renew_no,2,'0') policy_no,
                         b.assured_name, b.dsp_loss_date, b.clm_file_date,
                         c.line_cd||'-'||c.iss_cd||'-'||c.rec_year||'-'||LPAD(c.rec_seq_no,3,'0') rec_no,
                         c.recoverable_amt, c.recovered_amt, d.rec_type_cd||' - '||d.rec_type_desc rec_type,
                         DECODE(c.cancel_tag, 'CD', 'CLOSED', 'CC', 'CANCELLED', 'WO', 'WRITTEN OFF', 'IN PROGRESS') rec_status
                    FROM gicl_recovery_payor a, gicl_claims b, gicl_clm_recovery c, giis_recovery_type d
                   WHERE d.rec_type_cd = UPPER(p_rec_type_cd)
                     AND b.claim_id    = c.claim_id   
                     AND b.claim_id    = a.claim_id
                     AND b.line_cd     = c.line_cd
                     AND c.rec_type_cd = d.rec_type_cd
                     AND a.recovery_id = c.recovery_id
                     --AND check_user_per_line(b.line_cd,b.iss_cd,'GICLS258') = 1 replaced by: Nica 05.27.2013
                     --AND check_user_per_line2(b.line_cd,b.iss_cd,'GICLS258', p_user_id) = 1  --commented by MarkS 11.24.2016 SR5845 optimization
                     AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS258',p_user_id))
                            WHERE LINE_CD= b.line_cd and BRANCH_CD = b.iss_cd) --added by MarkS 11.24.2016 SR5845 optimization
--added by MarkS 11.24.2016 SR5845 optimization
-----------------------------------------------
                     AND(
                            (DECODE(p_search_by,1,TRUNC(b.clm_file_date),
                                                3,TRUNC(b.dsp_loss_date)
                                
                                )<= TRUNC(TO_DATE(p_as_of_date, 'MM/DD/YYYY'))   
                        
                            ) OR (DECODE(p_search_by,2,TRUNC(b.clm_file_date),
                                                     6,TRUNC(b.dsp_loss_date)
                                        ) BETWEEN TRUNC(TO_DATE (p_from_date, 'MM-DD-YYYY')) AND TRUNC(TO_DATE (p_to_date, 'MM-DD-YYYY'))
                                 )
                        )
-----------------------------------------------
--END by MarkS 11.18.2016 SR5845 optimization  
--                     AND b.claim_id IN (SELECT DECODE(p_search_by, 1, (SELECT gc1.claim_id
--                                                                         FROM gicl_claims gc1
--                                                                        WHERE gc1.claim_id = gc.claim_id
--                                                                          AND TRUNC(gc1.clm_file_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM/DD/YYYY'))), --added by steven 06.05.2013; '<='
--                                                                   2, (SELECT gc1.claim_id
--                                                                         FROM gicl_claims gc1
--                                                                        WHERE gc1.claim_id = gc.claim_id
--                                                                          --AND gc1.clm_file_date BETWEEN TO_DATE(p_from_date, 'mm/dd/yyyy') AND TO_DATE(p_to_date, 'mm/dd/yyyy')),
--                                                                          AND (TRUNC(gc1.clm_file_date) >= TRUNC(TO_DATE (p_from_date, 'MM-DD-YYYY')) AND TRUNC(gc1.clm_file_date)  <= TRUNC(TO_DATE (p_to_date, 'MM-DD-YYYY'))) ), --added by steven 06.05.2013; comment-out the code above. 
--                                                                   3, (SELECT gc1.claim_id
--                                                                         FROM gicl_claims gc1
--                                                                        WHERE gc1.claim_id = gc.claim_id
--                                                                          AND TRUNC(gc1.dsp_loss_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM/DD/YYYY'))), --added by steven 06.05.2013; '<='
--                                                                   6, (SELECT gc1.claim_id
--                                                                         FROM gicl_claims gc1
--                                                                        WHERE gc1.claim_id = gc.claim_id
--                                                                          --AND gc1.dsp_loss_date BETWEEN TO_DATE(p_from_date, 'mm/dd/yyyy') AND TO_DATE(p_to_date, 'mm/dd/yyyy')))
--                                                                          AND (TRUNC(gc1.dsp_loss_date) >= TRUNC(TO_DATE (p_from_date, 'MM-DD-YYYY')) AND TRUNC(gc1.dsp_loss_date)  <= TRUNC(TO_DATE (p_to_date, 'MM-DD-YYYY'))) )) --added by steven 06.05.2013; comment-out the code above. 
--                                          FROM gicl_claims gc) 
-- commented out  by MarkS 11.24.2016 SR5845 optimization
                                         ORDER BY CLAIM_NO)
        LOOP
            res.rec_type        := i.rec_type;
            res.claim_no        := i.claim_no;
            res.policy_no       := i.policy_no;
            res.assured_name    := i.assured_name;
            res.dsp_loss_date   := i.dsp_loss_date;
            res.clm_file_date   := i.clm_file_date;
            res.rec_no          := i.rec_no;
            res.rec_status      := i.rec_status;
            res.recoverable_amt := i.recoverable_amt;
            res.recovered_amt   := i.recovered_amt;
            res.company_name    := v_comp_name; --added by MarkS 11.24.2016 SR5845 optimization
            res.company_address := v_comp_add; --added by MarkS 11.24.2016 SR5845 optimization
--commented out MarkS SR5845 11.24.2016 OPTIMIZATION            
--            FOR m IN (SELECT param_value_v 
--                        FROM giis_parameters
--                       WHERE UPPER(param_name) = 'COMPANY_NAME')
--            LOOP
--                res.company_name := m.param_value_v;
--            END LOOP;
--     
--            FOR n IN (SELECT param_value_v 
--                        FROM giis_parameters
--                       WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
--            LOOP
--                res.company_address := n.param_value_v;
--            END LOOP; --commented out MarkS SR5845 11.24.2016 OPTIMIZATION
            
            IF p_search_by IN (1,3) THEN
                  IF p_search_by IN (1) THEN
                      res.date_type :='Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
                  ELSE 
                      res.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
                  END IF;
            ELSIF p_search_by IN (2,6) THEN
                  IF p_search_by IN (2) THEN    
                      res.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
                  ELSE
                      res.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
                  END IF;
            END IF;
                        
            PIPE ROW(res);
        END LOOP;
    
    END;
    
END GICLR258_PKG;
/
