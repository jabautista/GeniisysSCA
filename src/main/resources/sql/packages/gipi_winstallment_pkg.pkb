CREATE OR REPLACE PACKAGE BODY CPI.gipi_winstallment_pkg
AS
   FUNCTION get_gipi_winstallment (
      p_par_id           gipi_winstallment.par_id%TYPE,
      p_item_grp         gipi_winstallment.item_grp%TYPE,
      p_takeup_seq_no    gipi_winstallment.takeup_seq_no%TYPE)
      RETURN gipi_winstallment_tab
      PIPELINED
   IS
      v_winstallment   gipi_winstallment_type;
   BEGIN
      FOR i
         IN (  SELECT par_id,
                      item_grp,
                      takeup_seq_no,
                      inst_no,
                      due_date,
                      share_pct,
                      ROUND (prem_amt, 2) prem_amt,
                      ROUND (tax_amt, 2) tax_amt,
                      ROUND (prem_amt + tax_amt) total_due,
                      ROUND (
                         SUM (share_pct) OVER (PARTITION BY par_id, item_grp),
                         2)
                         total_share_pct,
                      ROUND (
                         SUM (prem_amt) OVER (PARTITION BY par_id, item_grp),
                         2)
                         total_prem_amt,
                      ROUND (
                         SUM (tax_amt) OVER (PARTITION BY par_id, item_grp),
                         2)
                         total_tax_amt,
                      ROUND (
                         SUM (prem_amt + tax_amt)
                            OVER (PARTITION BY par_id, item_grp),
                         2)
                         total_amount_due
                 FROM gipi_winstallment
                WHERE     par_id = p_par_id
                      AND item_grp = p_item_grp
                      AND takeup_seq_no = p_takeup_seq_no
             ORDER BY due_date)
      LOOP
         v_winstallment.par_id := i.par_id;
         v_winstallment.item_grp := i.item_grp;
         v_winstallment.takeup_seq_no := i.takeup_seq_no;
         v_winstallment.inst_no := i.inst_no;
         v_winstallment.due_date := i.due_date;
         v_winstallment.share_pct := i.share_pct;
         v_winstallment.prem_amt := i.prem_amt;
         v_winstallment.tax_amt := i.tax_amt;
         v_winstallment.total_due := i.total_due;
         v_winstallment.total_share_pct := i.total_share_pct;
         v_winstallment.total_prem_amt := i.total_prem_amt;
         v_winstallment.total_tax_amt := i.total_tax_amt;
         v_winstallment.total_amount_due := i.total_amount_due;
         PIPE ROW (v_winstallment);
      END LOOP;

      RETURN;
   END get_gipi_winstallment;

   PROCEDURE set_gipi_winstallment (p_winstallment gipi_winstallment%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gipi_winstallment
           USING DUAL
              ON (    par_id = p_winstallment.par_id
                  AND item_grp = p_winstallment.item_grp
                  AND inst_no = p_winstallment.inst_no
                  AND takeup_seq_no = p_winstallment.takeup_seq_no)
      WHEN NOT MATCHED
      THEN
         INSERT     (par_id,
                     item_grp,
                     takeup_seq_no,
                     inst_no,
                     due_date,
                     share_pct,
                     prem_amt,
                     tax_amt)
             VALUES (p_winstallment.par_id,
                     p_winstallment.item_grp,
                     p_winstallment.takeup_seq_no,
                     p_winstallment.inst_no,
                     p_winstallment.due_date,
                     p_winstallment.share_pct,
                     p_winstallment.prem_amt,
                     p_winstallment.tax_amt)
      WHEN MATCHED
      THEN
         UPDATE SET            --takeup_seq_no = p_winstallment.takeup_seq_no,
                   due_date = p_winstallment.due_date,
                    share_pct = p_winstallment.share_pct,
                    prem_amt = p_winstallment.prem_amt,
                    tax_amt = p_winstallment.tax_amt;
   END set_gipi_winstallment;

   PROCEDURE del_gipi_winstallment (
      p_par_id      gipi_winstallment.par_id%TYPE,
      p_item_grp    gipi_winstallment.item_grp%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_winstallment
            WHERE par_id = p_par_id AND item_grp = p_item_grp;

      COMMIT;
   END del_gipi_winstallment;

   /*
   **  Modified by      : Mark JM
   **  Date Created  : 02.11.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Delete record by supplying the par_id only
   */
   PROCEDURE del_gipi_winstallment_1 (p_par_id gipi_winstallment.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_winstallment
            WHERE par_id = p_par_id;
   END del_gipi_winstallment_1;

   /*
   **  Created by      : Tonio
   **  Date Created  : 02.3.2011
   **  Reference By  : (GIPIS026
   **  Description   : Get all installment details
   */
   FUNCTION get_all_gipi_winstallment (
      p_par_id gipi_winstallment.par_id%TYPE)
      RETURN gipi_winstallment_tab
      PIPELINED
   IS
      v_winstallment   gipi_winstallment_type;
   BEGIN
      FOR i IN (  SELECT par_id,
                         item_grp,
                         takeup_seq_no,
                         inst_no,
                         due_date,
                         share_pct,
                         ROUND (prem_amt, 2) prem_amt,
                         ROUND (tax_amt, 2) tax_amt,
                         ROUND (prem_amt + tax_amt, 2) total_due
                    FROM gipi_winstallment
                   WHERE par_id = p_par_id
                ORDER BY due_date)
      LOOP
         v_winstallment.par_id := i.par_id;
         v_winstallment.item_grp := i.item_grp;
         v_winstallment.takeup_seq_no := i.takeup_seq_no;
         v_winstallment.inst_no := i.inst_no;
         v_winstallment.due_date := i.due_date;
         v_winstallment.share_pct := i.share_pct;
         v_winstallment.prem_amt := i.prem_amt;
         v_winstallment.tax_amt := i.tax_amt;
         v_winstallment.total_due := i.total_due;
         PIPE ROW (v_winstallment);
      END LOOP;

      RETURN;
   END get_all_gipi_winstallment;

   /*
 **  Created by      : Tonio
 **  Date Created  : 03.23.2011
 **  Reference By  : (GIPIS017B
 */

   PROCEDURE CALC_PAYMENT_SCHED_GIPIS017B (
      p_par_id      IN GIPI_PARLIST.par_id%TYPE,
      p_payt_term   IN GIIS_PAYTERM.payt_terms%TYPE,
      p_prem_amt    IN GIPI_WINVOICE.prem_amt%TYPE,
      p_tax_amt     IN GIPI_WINVOICE.tax_amt%TYPE)
   IS
      v_no_of_payt      giis_payterm.no_of_payt%TYPE := 1;
      v_payt_term       giis_payterm.payt_terms%TYPE;
      v_inst_no         gipi_winstallment.inst_no%TYPE := 0;
      v_due_date        gipi_winstallment.due_date%TYPE;
      v_share_pct       gipi_winstallment.share_pct%TYPE := 0;
      v_prem_amt        gipi_winstallment.prem_amt%TYPE := 0;
      v_tax_amt         gipi_winstallment.tax_amt%TYPE := 0;
      v_on_incept_tag   giis_payterm.on_incept_tag%TYPE;
      v_no_of_days      giis_payterm.no_of_days%TYPE;
      v_temp_inst_cur   gipi_winstallment_pkg.gipi_winstallment_cur;
   BEGIN
      FOR DATE IN (SELECT eff_date
                     FROM gipi_wpolbas
                    WHERE par_id = P_PAR_ID)
      LOOP
         FOR A IN (SELECT NVL (on_incept_tag, 'Y') on_incept_tag,
                          no_of_days,
                          c.payt_terms payt_terms,
                          c.no_of_payt no_of_payt
                     FROM giis_payterm C
                    WHERE payt_terms = p_payt_term)
         LOOP
            v_on_incept_tag := a.on_incept_tag;
            v_no_of_days := NVL (a.no_of_days, 0);
            v_payt_term := a.payt_terms;
            v_no_of_payt := a.no_of_payt;
            EXIT;
         END LOOP;

         IF v_payt_term IS NULL
         THEN
            v_payt_term := 'COD';
            v_no_of_payt := 1;
         END IF;

         IF NVL (v_on_incept_tag, 'Y') = 'Y'
         THEN
            v_due_date := DATE.eff_date;
         ELSE
            v_due_date := DATE.eff_date + NVL (v_no_of_days, 0);
         END IF;

         EXIT;
      END LOOP;

      v_share_pct := 100 / v_no_of_payt;
      v_prem_amt := p_prem_amt / v_no_of_payt;
      v_tax_amt := p_tax_amt;

      DBMS_OUTPUT.put_line (
            'inceptTag: '
         || v_on_incept_tag
         || ' no of days: '
         || v_no_of_days
         || ' payterm: '
         || v_payt_term
         || ' no payts: '
         || v_no_of_payt);
      DBMS_OUTPUT.put_line (
            'v_due_date: '
         || v_due_date
         || ' v_share_pct: '
         || v_share_pct
         || ' v_prem_amt: '
         || v_prem_amt
         || ' v_tax_amt: '
         || v_tax_amt);

      DELETE gipi_winstallment
       WHERE par_id = p_par_id;

      DBMS_OUTPUT.put_line ('HERE 4');

      FOR i IN 1 .. v_no_of_payt
      LOOP
         v_inst_no := NVL (v_inst_no, 0) + 1;

         IF v_inst_no > 1
         THEN
            v_tax_amt := 0;
            v_due_date := v_due_date + ROUND (366 / v_no_of_payt);
         END IF;

         FOR x IN (SELECT COUNT (takeup_seq_no) takeup_cnt
                     FROM gipi_winvoice
                    WHERE par_id = p_par_id)
         LOOP
            FOR y IN (SELECT takeup_seq_no, tax_amt
                        FROM gipi_winvoice
                       WHERE par_id = p_par_id)
            LOOP
               IF y.takeup_seq_no = 1
               THEN
                  INSERT INTO gipi_winstallment (par_id,
                                                 item_grp,
                                                 inst_no,
                                                 due_date,
                                                 share_pct,
                                                 prem_amt,
                                                 tax_amt,
                                                 takeup_seq_no)
                       VALUES (p_par_id,
                               1,
                               v_inst_no,
                               v_due_date,
                               v_share_pct,
                               ROUND ( (v_prem_amt / x.takeup_cnt), 2),
                               y.tax_amt,
                               y.takeup_Seq_no);
               ELSIF y.takeup_seq_no <> x.takeup_cnt
               THEN
                  INSERT INTO gipi_winstallment (par_id,
                                                 item_grp,
                                                 inst_no,
                                                 due_date,
                                                 share_pct,
                                                 prem_amt,
                                                 tax_amt,
                                                 takeup_seq_no)
                       VALUES (p_par_id,
                               1,
                               v_inst_no,
                               v_due_date,
                               v_share_pct,
                               ROUND ( (v_prem_amt / x.takeup_cnt), 2),
                               y.tax_amt,
                               y.takeup_Seq_no);
               ELSE
                  INSERT INTO gipi_winstallment (par_id,
                                                 item_grp,
                                                 inst_no,
                                                 due_date,
                                                 share_pct,
                                                 prem_amt,
                                                 tax_amt,
                                                 takeup_seq_no)
                       VALUES (
                                 p_par_id,
                                 1,
                                 v_inst_no,
                                 v_due_date,
                                 v_share_pct,
                                   v_prem_amt
                                 - (  ROUND ( (v_prem_amt / x.takeup_cnt), 2)
                                    * (x.takeup_cnt - 1)),
                                 y.tax_amt,
                                 y.takeup_Seq_no);
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;
   
      /* Removed by Irwin - 5.25.2012
       Reason: Wrong computation for due date.

       Wala naman ito sa fmb modules ng both GIPIS165B AT GIPIS017B, not sure bat andito to pero sa Par bill premiums may ganito.
       comment out by belle ay per mam vj gamitin na din ito for correct computation of due date */

       FOR i IN (SELECT to_char(due_date, 'mm-dd-yyyy') due_date
                   FROM  gipi_winvoice
                  WHERE par_id = p_par_id) 
       LOOP
          payt_term_computation(1, i.due_date, p_par_id, 'SU', v_temp_inst_cur);
       END LOOP;

   END CALC_PAYMENT_SCHED_GIPIS017B;

   /**
     Created By Irwin Tabisora
          Date: 5.25.2012
          Description: removed the deletion of gipi_winstallment and added extra condition on query of GIPI_WINVOICE
   */
   PROCEDURE CALC_PAYMENT_SCHED_GIPIS017B_2 (
      p_par_id			IN	 GIPI_PARLIST.par_id%TYPE,		
				  p_prem_amt		IN GIPI_WINVOICE.prem_amt%TYPE,  
				  p_tax_amt		    IN GIPI_WINVOICE.tax_amt%TYPE)
   IS
      v_no_of_payt      giis_payterm.no_of_payt%TYPE := 1;
      v_payt_term       giis_payterm.payt_terms%TYPE;
      v_inst_no         gipi_winstallment.inst_no%TYPE := 0;
      v_due_date        gipi_winstallment.due_date%TYPE;
      v_share_pct       gipi_winstallment.share_pct%TYPE := 0;
      v_prem_amt        gipi_winstallment.prem_amt%TYPE := 0;
      v_tax_amt         gipi_winstallment.tax_amt%TYPE := 0;
      v_on_incept_tag   giis_payterm.on_incept_tag%TYPE;
      v_no_of_days      giis_payterm.no_of_days%TYPE;
      v_temp_inst_cur   gipi_winstallment_pkg.gipi_winstallment_cur;
   BEGIN
      FOR GIPI_WINVOICE_item IN (SELECT *
                                   FROM GIPI_WINVOICE
                                  WHERE PAR_ID = p_par_id)
      LOOP
         v_inst_no := 0;

         FOR A IN (SELECT NVL (on_incept_tag, 'Y') on_incept_tag,
                          no_of_days,
                          c.payt_terms payt_terms,
                          c.no_of_payt no_of_payt
                     FROM giis_payterm C
                    WHERE payt_terms = GIPI_WINVOICE_item.payt_terms)
         LOOP
            v_on_incept_tag := a.on_incept_tag;
            v_no_of_days := NVL (a.no_of_days, 0);
            v_payt_term := a.payt_terms;
            v_no_of_payt := a.no_of_payt;
            EXIT;
         END LOOP;

         IF v_payt_term IS NULL
         THEN
            v_payt_term := 'COD';
            v_no_of_payt := 1;
         END IF;

         IF NVL (v_on_incept_tag, 'Y') = 'Y'
         THEN
            v_due_date := GIPI_WINVOICE_item.due_date;
         ELSE
            v_due_date := GIPI_WINVOICE_item.due_date + NVL (v_no_of_days, 0);
         END IF;

         v_share_pct := 100 / v_no_of_payt;
         v_prem_amt := p_prem_amt / v_no_of_payt;
         v_tax_amt := p_tax_amt;

         FOR i IN 1 .. v_no_of_payt
         LOOP
            v_inst_no := NVL (v_inst_no, 0) + 1;

            IF v_inst_no > 1
            THEN
               v_tax_amt := 0;
               v_due_date := v_due_date + ROUND (366 / v_no_of_payt);
            END IF;
			
			FOR x IN (SELECT count(takeup_seq_no) takeup_cnt
                FROM gipi_winvoice
						   WHERE par_id = p_par_id and payt_terms = v_payt_term)
				LOOP
					FOR y IN (SELECT takeup_seq_no, tax_amt
							FROM gipi_winvoice
						   WHERE par_id = p_par_id and payt_terms = v_payt_term)
				  LOOP
						IF y.takeup_seq_no = 1 THEN
						  INSERT INTO gipi_winstallment
						   (par_id,item_grp,inst_no,due_date,share_pct,
						  prem_amt,
						  tax_amt, takeup_seq_no)
						VALUES
						 (p_par_id,1,v_inst_no,v_due_date, v_share_pct,
						  ROUND((v_prem_amt / x.takeup_cnt),2),
						  y.tax_amt,y.takeup_Seq_no);
						ELSIF y.takeup_seq_no <> x.takeup_cnt THEN
							INSERT INTO gipi_winstallment
						   (par_id,item_grp,inst_no,due_date,share_pct,
						  prem_amt,
						  tax_amt, takeup_seq_no)
						VALUES
						 (p_par_id,1,v_inst_no,v_due_date, v_share_pct,
						  ROUND((v_prem_amt / x.takeup_cnt),2),
						  y.tax_amt,y.takeup_Seq_no);
						ELSE
							INSERT INTO gipi_winstallment
						   (par_id,item_grp,inst_no,due_date,share_pct,
						  prem_amt,
						  tax_amt, takeup_seq_no)
						VALUES
						 (p_par_id,1,v_inst_no,v_due_date, v_share_pct,
						  v_prem_amt - (ROUND((v_prem_amt / x.takeup_cnt),2) * (x.takeup_cnt - 1)),
						  y.tax_amt,y.takeup_Seq_no);
					  END IF;
					END LOOP; 
				END LOOP;   
         END LOOP;
      END LOOP;
   END;
END gipi_winstallment_pkg;
/


