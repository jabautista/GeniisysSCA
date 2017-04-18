CREATE OR REPLACE PACKAGE BODY CPI.gipi_winv_tax_pkg
AS
   FUNCTION get_gipi_winv_tax (
      p_par_id     gipi_winv_tax.par_id%TYPE,
      p_item_grp   gipi_winv_tax.item_grp%TYPE
   )
      --  p_takeup_seq_no  GIPI_WINV_TAX.takeup_seq_no%TYPE)
   RETURN gipi_winv_tax_tab PIPELINED
   IS
      v_winv_tax   gipi_winv_tax_type;
   BEGIN
      FOR i IN
         (SELECT a.tax_id, a.tax_cd, b.tax_desc, a.tax_amt, a.par_id,
                 a.line_cd, a.iss_cd, a.item_grp, a.takeup_seq_no, a.rate,
                 b.peril_sw, a.tax_allocation, a.fixed_tax_allocation,
                 SUM (a.tax_amt) OVER (PARTITION BY a.par_id, a.item_grp)
                                                                 sum_tax_amt,
                 b.primary_sw
            FROM gipi_winv_tax a, giis_tax_charges b
           WHERE a.par_id = p_par_id
             AND a.item_grp = p_item_grp
             -- AND a.takeup_seq_no = p_takeup_seq_no
             AND (    a.tax_cd = b.tax_cd
                  AND a.iss_cd = b.iss_cd
                  AND a.line_cd = b.line_cd
                  AND a.tax_id = b.tax_id
                 )
             AND a.tax_amt != 0                       --added by cris 03/09/10 
                               )
      LOOP
         v_winv_tax.tax_id := i.tax_id;
         v_winv_tax.tax_cd := i.tax_cd;
         v_winv_tax.tax_desc := i.tax_desc;
         v_winv_tax.tax_amt := i.tax_amt;
         v_winv_tax.par_id := i.par_id;
         v_winv_tax.line_cd := i.line_cd;
         v_winv_tax.iss_cd := i.iss_cd;
         v_winv_tax.item_grp := i.item_grp;
         v_winv_tax.takeup_seq_no := i.takeup_seq_no;
         v_winv_tax.rate := i.rate;
         v_winv_tax.peril_sw := i.peril_sw;
         v_winv_tax.tax_allocation := i.tax_allocation;
         v_winv_tax.fixed_tax_allocation := i.fixed_tax_allocation;
         v_winv_tax.sum_tax_amt := i.sum_tax_amt;
         v_winv_tax.primary_sw := i.primary_sw;
         PIPE ROW (v_winv_tax);
      END LOOP;

      RETURN;
   END get_gipi_winv_tax;

   FUNCTION get_gipi_winv_tax2 (
      p_par_id          gipi_winv_tax.par_id%TYPE,
      p_item_grp        gipi_winv_tax.item_grp%TYPE,
      p_takeup_seq_no   gipi_winv_tax.takeup_seq_no%TYPE
   )
      RETURN gipi_winv_tax_tab PIPELINED
   IS
      v_winv_tax   gipi_winv_tax_type;
   BEGIN
      FOR i IN
         (SELECT a.tax_id, a.tax_cd, b.tax_desc, a.tax_amt, a.par_id,
                 a.line_cd, a.iss_cd, a.item_grp, a.takeup_seq_no, a.rate,
                 b.peril_sw, a.tax_allocation, a.fixed_tax_allocation,
                 SUM (a.tax_amt) OVER (PARTITION BY a.par_id, a.item_grp)
                                                                 sum_tax_amt,
                 b.primary_sw, b.no_rate_tag
            FROM gipi_winv_tax a, giis_tax_charges b
           WHERE a.par_id = p_par_id
             AND a.item_grp = p_item_grp
             AND a.takeup_seq_no = p_takeup_seq_no
             AND (    a.tax_cd = b.tax_cd
                  AND a.iss_cd = b.iss_cd
                  AND a.line_cd = b.line_cd
                  AND a.tax_id = b.tax_id
                 )
             --AND a.tax_amt != 0
    )
      LOOP
         v_winv_tax.tax_id := i.tax_id;
         v_winv_tax.tax_cd := i.tax_cd;
         v_winv_tax.tax_desc := ESCAPE_VALUE(i.tax_desc); --added escape_value by robert 11.21.2013
         v_winv_tax.tax_amt := i.tax_amt;
         v_winv_tax.par_id := i.par_id;
         v_winv_tax.line_cd := i.line_cd;
         v_winv_tax.iss_cd := i.iss_cd;
         v_winv_tax.item_grp := i.item_grp;
         v_winv_tax.takeup_seq_no := i.takeup_seq_no;
         v_winv_tax.rate := i.rate;
         v_winv_tax.peril_sw := i.peril_sw;
         v_winv_tax.tax_allocation := i.tax_allocation;
         v_winv_tax.fixed_tax_allocation := i.fixed_tax_allocation;
         v_winv_tax.sum_tax_amt := i.sum_tax_amt;
         v_winv_tax.primary_sw := i.primary_sw;
   v_winv_tax.no_rate_tag := i.no_rate_tag;
         PIPE ROW (v_winv_tax);
      END LOOP;

      RETURN;
   END get_gipi_winv_tax2;

   FUNCTION get_gipi_winv_tax3 (p_par_id gipi_winv_tax.par_id%TYPE)
      RETURN gipi_winv_tax_tab PIPELINED
   IS
      v_winv_tax   gipi_winv_tax_type;
   BEGIN
      FOR i IN
         (SELECT a.tax_id, a.tax_cd, b.tax_desc, a.tax_amt, a.par_id,
                 a.line_cd, a.iss_cd, a.item_grp, a.takeup_seq_no, a.rate,
                 b.peril_sw, a.tax_allocation, a.fixed_tax_allocation,
                 SUM (a.tax_amt) OVER (PARTITION BY a.par_id, a.item_grp)
                                                                 sum_tax_amt,
                 b.primary_sw, b.no_rate_tag
            FROM gipi_winv_tax a, giis_tax_charges b
           WHERE a.par_id = p_par_id
             AND (    a.tax_cd = b.tax_cd
                  AND a.iss_cd = b.iss_cd
                  AND a.line_cd = b.line_cd
                  AND a.tax_id = b.tax_id
                 )
             ---AND a.tax_amt != 0 
    order by a.tax_cd)
      LOOP
         v_winv_tax.tax_id := i.tax_id;
         v_winv_tax.tax_cd := i.tax_cd;
         v_winv_tax.tax_desc := i.tax_desc;
         v_winv_tax.tax_amt := i.tax_amt;
         v_winv_tax.par_id := i.par_id;
         v_winv_tax.line_cd := i.line_cd;
         v_winv_tax.iss_cd := i.iss_cd;
         v_winv_tax.item_grp := i.item_grp;
         v_winv_tax.takeup_seq_no := i.takeup_seq_no;
         v_winv_tax.rate := i.rate;
         v_winv_tax.peril_sw := i.peril_sw;
         v_winv_tax.tax_allocation := i.tax_allocation;
         v_winv_tax.fixed_tax_allocation := i.fixed_tax_allocation;
         v_winv_tax.sum_tax_amt := i.sum_tax_amt;
         v_winv_tax.primary_sw := i.primary_sw;
         v_winv_tax.no_rate_tag := i.no_rate_tag;
         PIPE ROW (v_winv_tax);
      END LOOP;

      RETURN;
   END get_gipi_winv_tax3;

   PROCEDURE set_gipi_winv_tax (p_winvtax gipi_winv_tax%ROWTYPE)
   IS
   v_prem_amt gipi_wpolbas.prem_amt%type;
   v_rate gipi_winv_tax.rate%type;
   v_tax_type giis_tax_charges.tax_type%TYPE;
   v_no_rate_tag giis_tax_charges.no_rate_tag%TYPE ; -- jhing 11.11.2014  ;
   v_place_cd   gipi_wpolbas.place_cd%TYPE; -- jhing 11.19.2014 
   v_alloc_tag  giis_tax_charges.allocation_tag%TYPE; --added by gab 06.02.2016 SR21333
    BEGIN
       --added by steven 10.14.2014
      /* FOR i IN (SELECT prem_amt
                   FROM gipi_wpolbas
                  WHERE par_id = p_winvtax.par_id)
       LOOP
          v_prem_amt := i.prem_amt;
       END LOOP; */ -- commented out by jhing and replaced by:
       
       FOR i IN (SELECT prem_amt
                   FROM gipi_winvoice 
                  WHERE par_id = p_winvtax.par_id
                    AND item_grp = p_winvtax.item_grp
                    AND takeup_seq_no = p_winvtax.takeup_seq_no )
       LOOP
          v_prem_amt := i.prem_amt;
       END LOOP;  
       
       -- jhing 11.19.2014 
       FOR p in (SELECT place_cd FROM gipi_wpolbas WHERE par_id = p_winvtax.par_id)
       LOOP
        v_place_cd := p.place_cd;
        EXIT;
       END LOOP;       
       
       IF v_place_cd IS NOT NULL THEN  -- grace 02.10.2016 added if condition to prevent using giis_tax_issue_place if the place_cd in basic info is NULL
          FOR x IN (SELECT a.tax_type tax_type, NVL(a.no_rate_tag,'N') no_rate_tag , NVL(b.rate, NVL(a.rate,0) ) rate,    --added by Gzelle 10292014  -- jhing 11.07.2014 added NVL , 11.19.2014 added rate
                           a.allocation_tag --added by gab 06.02.2016 SR21333
                      FROM giis_tax_charges a, giis_tax_issue_place b -- added connection to giis_tax_issue_place
                     WHERE a.iss_cd = p_winvtax.iss_cd
                       AND a.line_cd = p_winvtax.line_cd
                       AND a.tax_cd = p_winvtax.tax_cd
                       AND a.tax_id = p_winvtax.tax_id
                       AND a.tax_cd = b.tax_cd (+)
                       AND a.tax_id = b.tax_id (+)
                       AND a.line_cd = b.line_cd (+)
                       AND a.iss_cd = b.iss_cd (+)
                       AND b.place_cd (+)= v_place_cd )
          LOOP
            v_tax_type := x.tax_type;
            v_no_rate_tag := x.no_rate_tag; 
            v_rate := x.rate ;-- jhing 11.19.2014
            v_alloc_tag := x.allocation_tag; --added by gab 06.02.2016 SR21333
            EXIT;
          END LOOP;
       ELSE
          FOR x IN (SELECT a.tax_type tax_type, NVL(a.no_rate_tag,'N') no_rate_tag , NVL(a.rate,0) rate,
                           a.allocation_tag --added by gab 06.02.2016 SR21333
                      FROM giis_tax_charges a
                     WHERE a.iss_cd = p_winvtax.iss_cd
                       AND a.line_cd = p_winvtax.line_cd
                       AND a.tax_cd = p_winvtax.tax_cd
                       AND a.tax_id = p_winvtax.tax_id)
          LOOP
            v_tax_type := x.tax_type;
            v_no_rate_tag := x.no_rate_tag; 
            v_rate := x.rate ;-- jhing 11.19.2014 
            v_alloc_tag := x.allocation_tag; --added by gab 06.02.2016 SR21333
            EXIT;
          END LOOP;
       END IF; 
       
       IF v_tax_type IN ( 'A' ,'N') --automatic 0 tax rate for taxes tagged as Fixed Amount as per ma'am vj  --- jhing 11.07.2014 added range in the exception 
       THEN
          v_rate := 0;
       ELSIF v_tax_type = 'R' AND v_no_rate_tag = 'Y' THEN -- rate for zero rated or without rate taxes will be zero 
          v_rate := 0 ; 
       -- as per agreement with Ma'am VJ, Ma'am Grace, Sir JM due to the need of accounting to retain the original tax rate from maintenance, tax rate will not be recomputed 
       -- for fixed rate taxes exception are taxes tagged as without rate.
       /*  -- jhing 11.07.2014 handle zero premium 
         IF v_prem_amt = 0 THEN
            v_rate := 0 ; 
         ELSIF v_tax_type = 'R' AND v_no_rate_tag = 'Y' THEN -- rate for zero rated or without rate taxes will be zero 
            v_rate := 0 ; 
         ELSIF ABS(v_prem_amt) < ABS(p_winvtax.tax_amt) THEN 
            
            raise_application_error(-20001, 'Geniisys Exception#E#Cannot recompute tax rate for invoice whose tax amount is greater than the premium.');

         ELSE   -- jhing 11.11.2014 temporary raise an error when tax is greater than premium which may happen for long term policy. For consideration during re-engineering phase
         
            v_rate := (p_winvtax.tax_amt / v_prem_amt) * 100;            
         END IF;*/
       --added by gab 06.02.2016 SR21333 
       ELSIF v_alloc_tag = 'S' AND v_tax_type = 'R'
       THEN
       	  /* SR-23184 JET NOV-03-2016 */
          IF v_prem_amt = 0 THEN
             v_rate := 0;
          ELSE
             v_rate := (p_winvtax.tax_amt / v_prem_amt) * 100;
          END IF;
       END IF;
 
       MERGE INTO gipi_winv_tax
          USING DUAL
          ON (    par_id = p_winvtax.par_id
              AND item_grp = p_winvtax.item_grp
              AND tax_cd = p_winvtax.tax_cd
              AND iss_cd = p_winvtax.iss_cd
              AND line_cd = p_winvtax.line_cd
              AND takeup_seq_no = p_winvtax.takeup_seq_no)
          WHEN NOT MATCHED THEN
             INSERT (tax_id, tax_cd, tax_amt, par_id, line_cd, iss_cd, item_grp,
                     takeup_seq_no, rate, tax_allocation, fixed_tax_allocation)
             VALUES (p_winvtax.tax_id, p_winvtax.tax_cd, p_winvtax.tax_amt,
                     p_winvtax.par_id, p_winvtax.line_cd, p_winvtax.iss_cd,
                     p_winvtax.item_grp, p_winvtax.takeup_seq_no, v_rate,--p_winvtax.rate, --added by steven10.14.2014
                     p_winvtax.tax_allocation, p_winvtax.fixed_tax_allocation)
          WHEN MATCHED THEN
             UPDATE
                SET tax_id = p_winvtax.tax_id, tax_amt = p_winvtax.tax_amt,
                    
                    -- takeup_seq_no          = p_winvtax.takeup_seq_no,
                    rate = v_rate,   --p_winvtax.rate, --added by steven10.14.2014
                    tax_allocation = p_winvtax.tax_allocation,
                    fixed_tax_allocation = p_winvtax.fixed_tax_allocation;
    END set_gipi_winv_tax;

   PROCEDURE del_gipi_winv_tax (
      p_par_id     gipi_winv_tax.par_id%TYPE,
      p_item_grp   gipi_winv_tax.item_grp%TYPE,
      p_tax_cd     gipi_winv_tax.tax_cd%TYPE,
      p_line_cd    gipi_winv_tax.line_cd%TYPE,
      p_iss_cd     gipi_winv_tax.iss_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_winv_tax
            WHERE par_id = p_par_id
              AND item_grp = p_item_grp
              AND tax_cd = p_tax_cd
              AND iss_cd = p_iss_cd
              AND line_cd = p_line_cd;
   END del_gipi_winv_tax;

   PROCEDURE del_all_gipi_winv_tax (p_par_id gipi_winv_tax.par_id%TYPE)
   IS
--                           p_item_grp   GIPI_WINV_TAX.item_grp%TYPE) IS comment by cris
   BEGIN
      DELETE FROM gipi_winv_tax
            WHERE par_id = p_par_id;

      -- AND item_grp  = p_item_grp;
   END del_all_gipi_winv_tax;

   PROCEDURE get_gipi_winv_tax_exist (
      p_par_id   IN       gipi_winv_tax.par_id%TYPE,
      p_exist    OUT      NUMBER
   )
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_winv_tax
                 WHERE par_id = p_par_id)
      LOOP
         v_exist := 1;
      END LOOP;

      p_exist := v_exist;
   END;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (SET_LIMIT_INTO_GIPI_WITMPERL)
**  Description  : Procedure to delete winv_tax record.
*/
   PROCEDURE del_gipi_winv_tax_1 (p_par_id IN gipi_winv_tax.par_id%TYPE)
   --par_id to limit the deletion
   IS
   BEGIN
      DELETE      gipi_winv_tax
            WHERE par_id = p_par_id;
   END del_gipi_winv_tax_1;

    /*
   **  Created by   :  Anthony Santos
   **  Date Created :  Feb 7, 2011
   **  Description  : Procedure to delete specific winv_tax record.
   */
   PROCEDURE del_sel_gipi_winv_tax (
      p_par_id          gipi_winv_tax.par_id%TYPE,
      p_item_grp        gipi_winv_tax.item_grp%TYPE,
      p_tax_cd          gipi_winv_tax.tax_cd%TYPE,
      p_takeup_seq_no   gipi_winv_tax.takeup_seq_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_winv_tax
            WHERE par_id = p_par_id
              AND item_grp = p_item_grp
              AND tax_cd = p_tax_cd
              AND takeup_seq_no = p_takeup_seq_no;
   END;
   
   /*
    **  Created by  : Veronica V. Raymundo
    **  Date Created  : 05.02.2011
    **  Reference By  : (GIPIS154 - Lead Policy Information)
    **  Description  : Retrieves tax_amt of the given par_id,
    **                    item_grp and tax_cd 
    */
   
   FUNCTION get_gipi_winv_tax_amt(
      p_par_id          gipi_winv_tax.par_id%TYPE,
      p_item_grp        gipi_winv_tax.item_grp%TYPE,
      p_tax_cd          gipi_winv_tax.tax_cd%TYPE
   )
   RETURN NUMBER
     
     IS
      
     v_winv_tax_amt         NUMBER;
     
   BEGIN
     FOR i IN (SELECT a.par_id, a.item_grp, 
                      a.tax_cd, a.tax_amt
                FROM GIPI_WINV_TAX a
                WHERE a.par_id   = p_par_id
                  AND a.item_grp = p_item_grp
                  AND a.tax_cd   = p_tax_cd)
     LOOP
        v_winv_tax_amt  := i.tax_amt;
        
     END LOOP;
     
     RETURN(v_winv_tax_amt);
     
   END; 
   
   FUNCTION get_inv_tax_for_insert (
        p_par_id gipi_winv_tax.par_id%TYPE
    ) RETURN gipi_winv_tax_tab PIPELINED IS
        v_tax_alloc     gipi_winv_tax.tax_allocation%TYPE;--
        v_tax_id        gipi_winv_tax.tax_id%TYPE;--
        v_pol_flag      gipi_wpolbas.pol_flag%TYPE;
        v_cntr          NUMBER; 
        v_line_cd       gipi_wpolbas.line_cd%TYPE;
        v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
        v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
        v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
        v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
        v_renew_no      gipi_wpolbas.renew_no%TYPE;
        v_item_grp      gipi_winvoice.item_grp%TYPE;
        v_takeup_seq_no gipi_winvoice.takeup_seq_no%TYPE;
        v_par_status    gipi_parlist.par_status%TYPE;
        
        v_winv_tax      gipi_winv_tax_type;
    BEGIN
        FOR z IN (SELECT par_status
	  						FROM gipi_parlist
		 					 WHERE par_id = p_par_id) LOOP
            v_par_status := z.par_status;
            EXIT;
		END LOOP; 
    
        FOR z IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                         pol_flag, incept_date, eff_date
                    FROM gipi_wpolbas
                   WHERE par_id = p_par_id) 
        LOOP
            v_line_cd    := z.line_cd;
            v_subline_cd := z.subline_cd;
            v_iss_cd     := z.iss_cd;
            v_issue_yy   := z.issue_yy;
            v_pol_seq_no := z.pol_seq_no;
            v_renew_no   := z.renew_no;
    		
            v_pol_flag := z.pol_flag;
            
            FOR itm_grp in (SELECT item_grp, takeup_seq_no
		    	 	 					  FROM gipi_winvoice
		                   WHERE par_id = p_par_id
            ) LOOP
                v_item_grp := itm_grp.item_grp;
                v_takeup_seq_no := itm_grp.takeup_seq_no;
            
                IF v_pol_flag = '4' AND v_par_status != 6 
                    AND z.incept_date = z.eff_date THEN
        			
                    FOR i IN (
                        SELECT a.tax_cd tax_cd, c.tax_desc tax_desc, a.tax_amt,
                               a.tax_id, a.line_cd, a.iss_cd, a.item_grp,
                               b.takeup_seq_no, a.rate, c.peril_sw, a.tax_allocation,
                               a.fixed_tax_allocation, c.primary_sw,
                               SUM (a.tax_amt) OVER (PARTITION BY a.tax_cd, c.tax_desc) sum_tax_amt
                           FROM gipi_inv_tax a, gipi_invoice b, giis_tax_charges c
                          WHERE a.line_cd     = c.line_cd 
                            AND a.iss_cd      = b.iss_cd
                            AND a.iss_cd      = c.iss_cd 
                            AND a.tax_cd      = c.tax_cd
                            AND a.tax_id      = c.tax_id
                            AND a.item_grp    = b.item_grp
                            AND a.prem_seq_no = b.prem_seq_no
                            AND a.line_cd     = v_line_cd
                            AND a.iss_cd      = v_iss_cd
                            AND b.policy_id IN (
                                SELECT f.policy_id
                                          FROM gipi_polbasic f
                                               WHERE f.line_cd    = v_line_cd
                                                     AND f.subline_cd = v_subline_cd
                                                     AND f.iss_cd     = v_iss_cd
                                                     AND f.issue_yy   = v_issue_yy
                                                     AND f.pol_seq_no = v_pol_seq_no
                                                     AND f.renew_no   = v_renew_no
                                                     AND f.pol_flag  != '5')
                    ) LOOP
                        v_cntr := 0;
        				
                        v_winv_tax.tax_id := i.tax_id;
                        v_winv_tax.tax_cd := i.tax_cd;
                        v_winv_tax.tax_desc := i.tax_desc;
                        v_winv_tax.tax_amt := i.tax_amt;
                        v_winv_tax.par_id := p_par_id;
                        v_winv_tax.line_cd := i.line_cd;
                        v_winv_tax.iss_cd := i.iss_cd;
                        v_winv_tax.item_grp := v_item_grp;
                        v_winv_tax.takeup_seq_no := v_takeup_seq_no;
                        v_winv_tax.rate := i.rate;
                        v_winv_tax.peril_sw := i.peril_sw;
                        v_winv_tax.tax_allocation := i.tax_allocation;
                        v_winv_tax.fixed_tax_allocation := i.fixed_tax_allocation;
                        v_winv_tax.sum_tax_amt := i.sum_tax_amt;
                        v_winv_tax.primary_sw := i.primary_sw;
        				
                        FOR B IN (
                            SELECT tax_cd, tax_amt
                              FROM gipi_winv_tax
                             WHERE par_id = p_par_id
                        ) LOOP
                            IF i.tax_cd = b.tax_cd THEN
                                IF (i.tax_amt * -1) <> b.tax_amt THEN
                                    v_winv_tax.tax_amt := b.tax_amt * -1;
                                END IF;
                                v_cntr := 1;
                            END IF;
                        END LOOP;
                        
                        IF v_cntr = 0 THEN
                            v_winv_tax.tax_allocation := 'F';
                            v_winv_tax.fixed_tax_allocation := 'Y';
                            v_winv_tax.tax_amt := i.tax_amt * -1;
                        END IF;
        				
                        PIPE ROW(v_winv_tax);
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;

    END get_inv_tax_for_insert;
   
END gipi_winv_tax_pkg;
/


