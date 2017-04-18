CREATE OR REPLACE PACKAGE BODY CPI.giuw_wpolicyds_dtl_pkg
AS
   /*
   **  Created by        : Mark JM
   **  Date Created     : 02.18.2010
   **  Reference By     : (GIPIS010 - Item Information)
   **  Description     : Contains the Insert / Update / Delete procedure of the table
   */
   PROCEDURE del_giuw_wpolicyds_dtl (
      p_dist_no   giuw_wpolicyds_dtl.dist_no%TYPE
   )
   IS
   BEGIN
      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no;
   END del_giuw_wpolicyds_dtl;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 03.11.2011
   **  Reference By     : (GIUWS004 - Preliminary One-Risk Distribution)
   **  Description     : get records in giuw_wpolicyds_dtl table
   */
   FUNCTION get_giuw_wpolicyds_dtl (
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   )
      RETURN giuw_wpolicyds_dtl_tab PIPELINED
   IS
      v_list   giuw_wpolicyds_dtl_type;
   BEGIN
      FOR i IN (SELECT a.dist_no, a.dist_seq_no, a.line_cd, a.share_cd,
                       a.dist_spct, a.dist_tsi, a.dist_prem, a.ann_dist_spct,
                       a.ann_dist_tsi, a.dist_grp, a.dist_spct1,
                       a.arc_ext_data
                  FROM giuw_wpolicyds_dtl a
                 WHERE a.dist_no = p_dist_no
                       AND a.dist_seq_no = p_dist_seq_no)
      LOOP
         v_list.dist_no := i.dist_no;
         v_list.dist_seq_no := i.dist_seq_no;
         v_list.line_cd := i.line_cd;
         v_list.share_cd := i.share_cd;
         v_list.dist_spct := i.dist_spct;
         v_list.dist_tsi := i.dist_tsi;
         v_list.dist_prem := i.dist_prem;
         v_list.ann_dist_spct := i.ann_dist_spct;
         v_list.ann_dist_tsi := i.ann_dist_tsi;
         v_list.dist_grp := i.dist_grp;
         v_list.dist_spct1 := i.dist_spct1;
         v_list.arc_ext_data := i.arc_ext_data;

         FOR dsp IN (SELECT a160.trty_cd, a160.trty_name, a160.trty_sw
                       FROM giis_dist_share a160
                      WHERE a160.line_cd = i.line_cd
                        AND a160.share_cd = i.share_cd)
         LOOP
            v_list.dsp_trty_cd := dsp.trty_cd;
            v_list.dsp_trty_name := dsp.trty_name;
            v_list.dsp_trty_sw := dsp.trty_sw;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 03.23.2011
   **  Reference By     : (GIUWS004 - Preliminary One-Risk Distribution)
   **  Description     :
   */
   FUNCTION get_giuw_wpolicyds_dtl_exist (
      p_dist_no   giuw_wpolicyds_dtl.dist_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR x IN (SELECT '1'
                  FROM giuw_wpolicyds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 04.04.2011
   **  Reference By     : (GIUWS004- Preliminary One-Risk Distribution)
   **  Description     : Insert record for giuw_wpolicyds_dtl table
   */
   PROCEDURE set_giuw_wpolicyds_dtl (
      p_dist_no         giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no     giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd         giuw_wpolicyds_dtl.line_cd%TYPE,
      p_share_cd        giuw_wpolicyds_dtl.share_cd%TYPE,
      p_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE,
      p_dist_tsi        giuw_wpolicyds_dtl.dist_tsi%TYPE,
      p_dist_prem       giuw_wpolicyds_dtl.dist_prem%TYPE,
      p_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE,
      p_ann_dist_tsi    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE,
      p_dist_grp        giuw_wpolicyds_dtl.dist_grp%TYPE,
      p_dist_spct1      giuw_wpolicyds_dtl.dist_spct1%TYPE,
      p_arc_ext_data    giuw_wpolicyds_dtl.arc_ext_data%TYPE
   )
   IS
   BEGIN
      MERGE INTO giuw_wpolicyds_dtl
         USING DUAL
         ON (    dist_no = p_dist_no
             AND dist_seq_no = p_dist_seq_no
             AND line_cd = p_line_cd
             AND share_cd = p_share_cd)
         WHEN NOT MATCHED THEN
            INSERT (dist_no, dist_seq_no, line_cd, share_cd, dist_spct,
                    dist_tsi, dist_prem, ann_dist_spct, ann_dist_tsi,
                    dist_grp, dist_spct1, arc_ext_data)
            VALUES (p_dist_no, p_dist_seq_no, p_line_cd, p_share_cd,
                    p_dist_spct, p_dist_tsi, p_dist_prem, p_ann_dist_spct,
                    p_ann_dist_tsi, p_dist_grp, p_dist_spct1, p_arc_ext_data)
         WHEN MATCHED THEN
            UPDATE
               SET dist_spct = p_dist_spct, dist_tsi = p_dist_tsi,
                   dist_prem = p_dist_prem, ann_dist_spct = p_ann_dist_spct,
                   ann_dist_tsi = p_ann_dist_tsi, dist_grp = p_dist_grp,
                   dist_spct1 = p_dist_spct1, arc_ext_data = p_arc_ext_data
            ;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 04.04.2011
   **  Reference By     : (GIUWS004- Preliminary One-Risk Distribution)
   **  Description     : Delete record for giuw_wpolicyds_dtl table
   */
   PROCEDURE del_giuw_wpolicyds_dtl (
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd       giuw_wpolicyds_dtl.line_cd%TYPE,
      p_share_cd      giuw_wpolicyds_dtl.share_cd%TYPE
   )
   IS
   BEGIN
      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no
              AND dist_seq_no = p_dist_seq_no
              AND line_cd = p_line_cd
              AND share_cd = p_share_cd;
   END del_giuw_wpolicyds_dtl;

   PROCEDURE populate_wpolicyds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      v_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
   BEGIN
      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no;

      FOR c1 IN (SELECT   SUM (dist_tsi) dist_tsi, SUM (dist_prem) dist_prem,
                          SUM (ann_dist_tsi) ann_dist_tsi,
                          dist_seq_no dist_seq_no, line_cd line_cd,
                          share_cd share_cd, dist_grp dist_grp
                     FROM giuw_witemds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, line_cd, share_cd, dist_grp)
      LOOP
         FOR c2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                           dist_seq_no
                      FROM giuw_wpolicyds
                     WHERE dist_seq_no = c1.dist_seq_no
                       AND dist_no = p_dist_no)
         LOOP
            /* Divide the individual TSI with the total TSI and multiply
            ** it by 100 to arrive at the correct percentage for the
            ** breakdown. */
            IF c2.tsi_amt != 0
            THEN
               v_dist_spct := ROUND (((c1.dist_tsi / c2.tsi_amt) * 100), 9);/*ROUND (c1.dist_tsi / c2.tsi_amt, 14) * 100;*/--changed to 9 from 14 decimal places edgar 07/04/2014
            ELSIF c2.prem_amt != 0
            THEN
               v_dist_spct := ROUND (((c1.dist_prem / c2.prem_amt) * 100), 14);/*ROUND (c1.dist_prem / c2.prem_amt, 14) * 100;*/--changed to 9 from 14 decimal places edgar 07/04/2014
            ELSE
               v_dist_spct := 0;
            END IF;

            IF c2.ann_tsi_amt != 0
            THEN
               v_ann_dist_spct := ROUND (((c1.ann_dist_tsi / c2.ann_tsi_amt) * 100), 9);
                            /*ROUND (c1.ann_dist_tsi / c2.ann_tsi_amt, 14)--changed to 9 from 14 decimal places edgar 07/04/2014
                            * 100;*/
            ELSE
               v_ann_dist_spct := 0;
            END IF;

            INSERT INTO giuw_wpolicyds_dtl
                        (dist_no, dist_seq_no, line_cd, share_cd,
                         dist_spct, dist_tsi, dist_prem,
                         ann_dist_spct, ann_dist_tsi, dist_grp
                        )
                 VALUES (c2.dist_no, c2.dist_seq_no, c1.line_cd, c1.share_cd,
                         v_dist_spct, c1.dist_tsi, c1.dist_prem,
                         v_ann_dist_spct, c1.ann_dist_tsi, c1.dist_grp
                        );
         END LOOP; 
      END LOOP;
   END populate_wpolicyds_dtl;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 06.09.2011
   **  Reference By     : (GIUWS006- Preliminary  Peril Distribution by TSI/Prem)
   */
   PROCEDURE populate_wpolicyds_dtl2 (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      v_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_spct1      giuw_wpolicyds_dtl.dist_spct1%TYPE;
      v_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
   BEGIN
      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no;

      FOR c1 IN (SELECT   SUM (dist_tsi) dist_tsi, SUM (dist_prem) dist_prem,
                          SUM (ann_dist_tsi) ann_dist_tsi,
                          dist_seq_no dist_seq_no, line_cd line_cd,
                          share_cd share_cd, dist_grp dist_grp
                     FROM giuw_witemds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, line_cd, share_cd, dist_grp)
      LOOP
         FOR c2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                           dist_seq_no
                      FROM giuw_wpolicyds
                     WHERE dist_seq_no = c1.dist_seq_no
                       AND dist_no = p_dist_no)
         LOOP
            /* Divide the individual TSI with the total TSI and multiply
            ** it by 100 to arrive at the correct percentage for the
            ** breakdown. */
            IF c2.tsi_amt = 0
            THEN
               --added by bdarusin, jan082003, if tsi is zero, compute dist_spct
               --based on ann_tsi
               --v_dist_spct   := 0;
               --v_dist_spct := ROUND(((c1.ann_dist_tsi/c2.ann_tsi_amt) * 100),9) -- shan 06.10.2014 --removed by robert SR 5053 01.08.16
                            /*ROUND (c1.ann_dist_tsi / c2.ann_tsi_amt, 14)
                            * 100*/--; --removed by robert SR 5053 01.08.16
				v_dist_spct   := 0; --added by robert SR 5053 01.08.16
            ELSE
               v_dist_spct := ROUND(((c1.dist_tsi/c2.tsi_amt) * 100),9) /*ROUND (c1.dist_tsi / c2.tsi_amt, 14) * 100*/; -- shan 06.10.2014
            END IF;

            IF c2.prem_amt = 0
            THEN
               v_dist_spct1 := 0;
            ELSE
               v_dist_spct1 := ROUND(((c1.dist_prem/c2.prem_amt) * 100),9) /*ROUND (c1.dist_prem / c2.prem_amt, 14) * 100*/; -- shan 06.10.2014
            END IF;

            IF c2.ann_tsi_amt = 0
            THEN
               v_ann_dist_spct := 0;
            ELSE
               v_ann_dist_spct := ROUND(((c1.ann_dist_tsi/c2.ann_tsi_amt) * 100),9) -- shan 06.10.2014
                            /*ROUND (c1.ann_dist_tsi / c2.ann_tsi_amt, 14)
                            * 100*/;
            END IF;

            --added by robert SR 5053 01.08.16 
			IF c2.tsi_amt = 0
            THEN           
               FOR c3 IN (SELECT SUM (tsi_amt) tsi_amt, SUM (prem_amt) prem_amt
                            FROM giuw_wperilds a, giis_peril b
                           WHERE a.dist_seq_no = c2.dist_seq_no
                             AND a.dist_no = p_dist_no
                             AND a.line_cd = b.line_cd
                             AND a.peril_cd = b.peril_cd
                             AND b.peril_type = 'A')
               LOOP
                  IF c3.tsi_amt = 0 THEN
                     IF c2.prem_amt = 0 THEN
                        v_dist_spct   := 0;
                     ELSE
                        FOR c4 IN (SELECT SUM (dist_prem) dist_prem
                                      FROM giuw_wperilds_dtl a
                                     WHERE a.dist_seq_no = c2.dist_seq_no
                                       AND a.dist_no = p_dist_no
                                       AND a.share_cd = c1.share_cd)
                        LOOP
                             v_dist_spct := ROUND(((c4.dist_prem/c2.prem_amt) * 100),9);
                        END LOOP;
                     END IF;
                  ELSE
                     FOR c4 IN (SELECT SUM (dist_tsi) dist_tsi, SUM (dist_prem)
                                  FROM giuw_wperilds_dtl a, giis_peril b
                                 WHERE a.dist_seq_no = c2.dist_seq_no
                                   AND a.dist_no = p_dist_no
                                   AND a.share_cd = c1.share_cd
                                   AND a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND b.peril_type = 'A')
                     LOOP
                         v_dist_spct := ROUND(((c4.dist_tsi/c3.tsi_amt) * 100),9);
                     END LOOP;
                  END IF;
               END LOOP;
               IF v_dist_spct1 = 0 THEN
                  v_dist_spct1 := v_dist_spct;
               END IF;
               v_ann_dist_spct := v_dist_spct;
            END IF;
			--end of codes robert SR 5053 01.08.16

            INSERT INTO giuw_wpolicyds_dtl
                        (dist_no, dist_seq_no, line_cd, share_cd,
                         dist_spct, dist_tsi, dist_prem,
                         ann_dist_spct, ann_dist_tsi, dist_grp,
                         dist_spct1
                        )
                 VALUES (c2.dist_no, c2.dist_seq_no, c1.line_cd, c1.share_cd,
                         v_dist_spct, c1.dist_tsi, c1.dist_prem,
                         v_ann_dist_spct, c1.ann_dist_tsi, c1.dist_grp,
                         v_dist_spct1
                        );
         END LOOP;
      END LOOP;
   END;

   /*
   **  Created by        : Anthony Santos
   **  Date Created     : 07.21.2011
   **  Reference By     : (GIUWS013- One-Risk Distribution)
   */
   FUNCTION get_list_with_facul_share (p_dist_no giuw_pol_dist.dist_no%TYPE)
      RETURN giuw_facul_share_dtl_tab PIPELINED
   AS
   v_facul_share    giuw_facul_share_dtl_type;
   v_count			number:=0;
   BEGIN
      FOR i IN (SELECT   c1407.dist_no, c1407.dist_seq_no, c1407.dist_tsi, c1407.line_cd,
                         c1407.dist_prem, c1407.dist_spct, c1306.tsi_amt,
                         c1306.prem_amt, c080.user_id, b140.currency_cd,
                         b140.currency_rt
                    FROM giuw_wpolicyds_dtl c1407,
                         giuw_wpolicyds c1306,
                         giuw_pol_dist c080,
                         gipi_invoice b140
                   WHERE b140.item_grp = c1306.item_grp
                     AND b140.policy_id = c080.policy_id
                     AND c080.dist_no = c1306.dist_no
                     AND c1306.dist_seq_no = c1407.dist_seq_no
                     AND c1306.dist_no = c1407.dist_no
                     AND c1407.share_cd = 999
                     AND c1407.dist_no = TO_CHAR (p_dist_no)
                ORDER BY c1407.dist_seq_no)
      LOOP
	  	  v_facul_share.dist_no := i.dist_no;
	  	  v_facul_share.dist_seq_no := i.dist_seq_no;
		  v_facul_share.dist_tsi := i.dist_tsi;
		  v_facul_share.line_cd := i.line_cd;
		  v_facul_share.dist_prem := i.dist_prem;
		  v_facul_share.dist_spct := i.dist_spct;
          v_facul_share.tsi_amt := i.tsi_amt;
		  v_facul_share.prem_amt := i.prem_amt;
		  v_facul_share.user_id := i.user_id;
		  v_facul_share.currency_cd := i.currency_cd;
		  v_facul_share.currency_rt := i.currency_rt;
		  PIPE ROW(v_facul_share);
      END LOOP;
   END;
   
   /*
   **  Created by        : Anthony Santos
   **  Date Created     : 07.21.2011
   **  Reference By     : (GIUWS013- One-Risk Distribution)
   */
   FUNCTION get_list_with_facul_share2(p_policy_id GIUW_POL_DIST.policy_id%TYPE,
			 							p_dist_no	  GIUW_POL_DIST.dist_no%TYPE) 
      RETURN giuw_facul_share_dtl_tab PIPELINED
   AS
   v_facul_share    giuw_facul_share_dtl_type;
   v_count			number:=0;
   v_old_line_cd       giuw_policyds_dtl.line_cd%TYPE;
   v_old_dist_no       giuw_pol_dist.dist_no%TYPE;
   v_exist             VARCHAR2 (1)                                    := 'N';
   BEGIN
	   FOR c1 IN (SELECT dist_no_old
	               FROM giuw_distrel
	              WHERE policy_id   = p_policy_id
	                AND dist_no_new = p_dist_no)
	  LOOP
	    v_exist       := 'Y';
	    v_old_dist_no := c1.dist_no_old;
	    EXIT;
	  END LOOP;
	  IF v_exist = 'N' THEN
		 RETURN;
	  END IF;	
   
   	  FOR c1 IN (  SELECT dist_seq_no
                 FROM giuw_policyds
                WHERE dist_no = v_old_dist_no
             ORDER BY dist_seq_no DESC) LOOP

    /* Get the LINE_CD of the current 
    ** DIST_SEQ_NO for the negated distribution
    ** record to access its detail table
    ** more efficiently via primary key. */
	    FOR c2 IN (SELECT line_cd
	                 FROM giuw_perilds
	                WHERE dist_seq_no = c1.dist_seq_no
	                  AND dist_no     = v_old_dist_no)
	    LOOP
	      v_old_line_cd := c2.line_cd;
	      EXIT;
	    END LOOP;
	
	    v_exist := 'N';
   
   
      FOR i IN (SELECT C1407.dist_no, 
	  	  	   		  C1407.dist_tsi,
                      C1407.dist_prem,
                      C1407.dist_spct,
                      C1306.tsi_amt,
                      C1306.prem_amt,
                      C080.user_id,
                      B140.currency_cd,
                      B140.currency_rt
                 FROM giuw_policyds_dtl C1407,
                      giuw_policyds C1306,
                      giuw_pol_dist C080,
                      gipi_invoice B140 
                WHERE B140.item_grp     = C1306.item_grp
                  AND B140.policy_id    = C080.policy_id
                  AND B140.policy_id    = C080.dist_no 
                  AND C080.dist_no      = C1306.dist_no
                  AND C1306.dist_seq_no = C1407.dist_seq_no
                  AND C1306.dist_no     = C1407.dist_no
                  AND C1407.share_cd    = '999'
                  AND C1407.line_cd     = v_old_line_cd
                  AND C1407.dist_seq_no = c1.dist_seq_no
                  AND C1407.dist_no     = v_old_dist_no)
      LOOP
	  	  v_facul_share.dist_no := i.dist_no;
		  v_facul_share.dist_tsi := i.dist_tsi;
		  v_facul_share.dist_prem := i.dist_prem;
		  v_facul_share.dist_spct := i.dist_spct;
          v_facul_share.tsi_amt := i.tsi_amt;
		  v_facul_share.prem_amt := i.prem_amt;
		  v_facul_share.user_id := i.user_id;
		  v_facul_share.currency_cd := i.currency_cd;
		  v_facul_share.currency_rt := i.currency_rt;
		  EXIT;
      END LOOP;
	  v_facul_share.dist_seq_no := c1.dist_seq_no;
	  v_facul_share.line_cd := v_old_line_cd;
	  PIPE ROW(v_facul_share);
	 END LOOP; 
   END;
   
   /*
   **  Created by        : Emman
   **  Date Created     : 07.27.2011
   **  Reference By     : (GIUWS012- Distribution by Peril)
   */
   PROCEDURE populate_wpolicyds_dtl3 (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      v_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
   BEGIN
      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no;

      FOR c1 IN (SELECT   SUM (dist_tsi) dist_tsi, SUM (dist_prem) dist_prem,
                          SUM (ann_dist_tsi) ann_dist_tsi,
                          dist_seq_no dist_seq_no, line_cd line_cd,
                          share_cd share_cd, dist_grp dist_grp
                     FROM giuw_witemds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, line_cd, share_cd, dist_grp)
      LOOP
         FOR c2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                           dist_seq_no
                      FROM giuw_wpolicyds
                     WHERE dist_seq_no = c1.dist_seq_no
                       AND dist_no = p_dist_no)
         LOOP
              /* Divide the individual TSI with the total TSI and multiply
              ** it by 100 to arrive at the correct percentage for the
              ** breakdown. */
              IF nvl(c2.tsi_amt, 0 ) = 0 THEN
	      	    /* rollie sep192005
	      	    ** to prevent ora-01476 divisor is equal to zero
	      	    */
		      	 IF NVL(c2.prem_amt,0) = 0 THEN
		      	 	  v_dist_spct := 0;
		      	 ELSE      	 	
		      	 		v_dist_spct := ROUND(c1.dist_prem/c2.prem_amt, 14) * 100;
		      	 END IF;      	 
		      ELSE	                                                       
		      	 /* rollie sep192005
		      	 ** to prevent ora-01476 divisor is equal to zero
		      	 */
		      	 IF NVL(c2.tsi_amt,0) = 0 THEN
		      	 		v_dist_spct := 0;
		      	 ELSE
		      	 	  v_dist_spct := ROUND(c1.dist_tsi/c2.tsi_amt, 14) * 100;
		      	 END IF;      	 
		      END IF;
			  
		      IF nvl(c2.ann_tsi_amt, 0 ) = 0 THEN
		         v_ann_dist_spct := 0;
		      ELSE   
		         v_ann_dist_spct := ROUND(c1.ann_dist_tsi/c2.ann_tsi_amt, 14) * 100;
		      END IF;   
		
		      INSERT INTO  giuw_wpolicyds_dtl
		                  (dist_no         , dist_seq_no     , line_cd          ,
		                   share_cd        , dist_spct       , dist_tsi         ,
		                   dist_prem       , ann_dist_spct   , ann_dist_tsi     ,
		                   dist_grp        , dist_spct1)
		           VALUES (c2.dist_no      , c2.dist_seq_no  , c1.line_cd       ,
		                   c1.share_cd     , v_dist_spct     , c1.dist_tsi      ,
		                   c1.dist_prem    , v_ann_dist_spct , c1.ann_dist_tsi  ,
		                   c1.dist_grp     , NULL);
	      END LOOP;
      END LOOP;
   END populate_wpolicyds_dtl3;
   
   /*
    **  Created by   : Robert John Virrey 
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation 
    **  Description  : Creates a new distribution record in table GIUW_POLICYDS_DTL
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
   PROCEDURE neg_policyds_dtl (
        p_dist_no     IN  giuw_policyds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_policyds_dtl.dist_no%TYPE
    ) 
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no   , line_cd      , share_cd  , 
               dist_tsi      , dist_prem    , dist_spct ,
               ann_dist_spct , ann_dist_tsi , dist_grp
          FROM giuw_policyds_dtl
         WHERE dist_no = p_dist_no;

      v_dist_seq_no        giuw_policyds_dtl.dist_seq_no%type;
      v_line_cd            giuw_policyds_dtl.line_cd%type;
      v_share_cd           giuw_policyds_dtl.share_cd%type;
      v_dist_tsi           giuw_policyds_dtl.dist_tsi%type;
      v_dist_prem          giuw_policyds_dtl.dist_prem%type;
      v_dist_spct          giuw_policyds_dtl.dist_spct%type;
      v_ann_dist_spct      giuw_policyds_dtl.ann_dist_spct%type;
      v_ann_dist_tsi       giuw_policyds_dtl.ann_dist_tsi%type;
      v_dist_grp           giuw_policyds_dtl.dist_grp%type;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no   , v_line_cd      , v_share_cd  ,
              v_dist_tsi      , v_dist_prem    , v_dist_spct ,
              v_ann_dist_spct , v_ann_dist_tsi , v_dist_grp;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        INSERT INTO  giuw_wpolicyds_dtl
                    (dist_no           , dist_seq_no     , line_cd        , 
                     share_cd          , dist_tsi        , dist_prem      ,
                     dist_spct         , ann_dist_spct   , ann_dist_tsi   , 
                     dist_grp)
             VALUES (p_temp_distno     , v_dist_seq_no   , v_line_cd      , 
                     v_share_cd        , v_dist_tsi      , v_dist_prem    ,
                     v_dist_spct       , v_ann_dist_spct , v_ann_dist_tsi , 
                     v_dist_grp);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_policyds_dtl;   
    
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 08.05.2011   
    **  Reference By     : (GIUWS017- Distribution by TSI/Prem (Peril))   
    */    
    PROCEDURE ADJUST_POLICY_LEVEL_AMTS(p_dist_no        giuw_wpolicyds.dist_no%TYPE) IS
      v_exist			        VARCHAR2(1) := 'N';
      v_count			        NUMBER;
      v_line_cd			        gipi_parlist.line_cd%TYPE;
      v_tsi_amt			        giuw_wpolicyds.tsi_amt%TYPE;
      v_prem_amt			    giuw_wpolicyds.prem_amt%TYPE;
      v_ann_tsi_amt			    giuw_wpolicyds.ann_tsi_amt%TYPE;
      v_dist_spct               giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_spct1              giuw_wpolicyds_dtl.dist_spct1%TYPE;
      v_dist_tsi			    giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_dist_prem			    giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_ann_dist_spct       	giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
      v_sum_dist_tsi		    giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_sum_dist_prem		    giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_sum_dist_spct       	giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_sum_dist_spct1      	giuw_wpolicyds_dtl.dist_spct1%TYPE;
      v_sum_ann_dist_tsi		giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct   	giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
      v_correct_dist_tsi		giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_correct_dist_prem   	giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_correct_dist_spct		giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_correct_dist_spct1		giuw_wpolicyds_dtl.dist_spct1%TYPE;
      v_correct_ann_dist_tsi	giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct       giuw_wpolicyds_dtl.ann_dist_spct%TYPE;

    BEGIN

      /* Scan each DIST_SEQ_NO for computational floats. */
      FOR c1 IN (SELECT dist_no                                   ,
                        dist_seq_no                               ,
                        ROUND(NVL(tsi_amt    , 0), 2) tsi_amt     ,
                        ROUND(NVL(prem_amt   , 0), 2) prem_amt    ,
                        ROUND(NVL(ann_tsi_amt, 0), 2) ann_tsi_amt
                   FROM giuw_wpolicyds
                  WHERE dist_no = p_dist_no)
      LOOP
        BEGIN

          /* Get the LINE_CD for the particular DIST_SEQ_NO
          ** for use in retrieving the correct data from
          ** GIUW_WPOLICYDS_DTL. */
          FOR c2 IN (SELECT line_cd
                       FROM giuw_wperilds
                      WHERE dist_seq_no = c1.dist_seq_no
                        AND dist_no     = c1.dist_no)
          LOOP
            v_line_cd := c2.line_cd;
            EXIT;
          END LOOP;

          /* **************************** Section A **********************************
          ** Compare the amounts retrieved from the master table with the sum of its
          ** counterparts from the detail table.
          ************************************************************************* */
      
          v_tsi_amt     := c1.tsi_amt;
          v_prem_amt    := c1.prem_amt;
          v_ann_tsi_amt := c1.ann_tsi_amt;

          v_exist := 'N';
          FOR c10 IN (SELECT ROUND(SUM(NVL(dist_tsi, 0)), 2)     dist_tsi     , 
                             ROUND(SUM(NVL(dist_prem, 0)), 2)    dist_prem    ,
                             ROUND(SUM(NVL(dist_spct, 0)), 14)    dist_spct    ,
                             ROUND(SUM(NVL(dist_spct1, 0)), 14)   dist_spct1   ,
                             ROUND(SUM(NVL(ann_dist_tsi, 0)), 2) ann_dist_tsi
                        FROM giuw_wpolicyds_dtl
                       WHERE dist_seq_no = c1.dist_seq_no
                         AND dist_no     = c1.dist_no)
          LOOP 
            v_exist        := 'Y';
            v_dist_tsi     := c10.dist_tsi;
            v_dist_prem    := c10.dist_prem;
            v_dist_spct    := c10.dist_spct;
            v_dist_spct1   := c10.dist_spct1;
            v_ann_dist_tsi := c10.ann_dist_tsi;
            EXIT;
          END LOOP;
          IF v_exist = 'N' THEN
             EXIT;
          END IF;

          /*************************** End of Section A ****************************/

          /* If the amounts retrieved from the master table
          ** are not equal to the amounts retrieved from the
          ** the detail table then the procedure below shall
          ** be executed. */
          IF (100           != v_dist_spct   ) OR
             (100           != v_dist_spct1  ) OR
             (v_tsi_amt     != v_dist_tsi    ) OR 
             (v_prem_amt    != v_dist_prem   ) OR
             (v_ann_tsi_amt != v_ann_dist_tsi) THEN
             BEGIN
               v_exist := 'N';

               /*************************** Section B *******************************
               ** Adjust the value of the fields belonging to the NET RETENTION share
               ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
               ** then the NO_DATA_FOUND exception (Section C) shall handle the next
               ** few steps.
               *********************************************************************/
               
               /* Get the ROWID of the NET RETENTION share
               ** in preparation for update. */ 
               FOR c10 IN (SELECT ROWID
                             FROM giuw_wpolicyds_dtl
                            WHERE share_cd    = '1'
                              AND line_cd     = v_line_cd
                              AND dist_seq_no = c1.dist_seq_no
                              AND dist_no     = c1.dist_no)
               LOOP

                 /* Get the sum of each field for all the shares excluding the NET
                 ** RETENTION share.  The result will serve as the SUBTRAHEND in 
                 ** calculating for the values to be attained by the fields belonging
                 ** to NET RETENTION. */
                 FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi     , 
                                    ROUND(SUM(dist_prem), 2)             dist_prem    , 
                                    ROUND(SUM(dist_spct), 14)             dist_spct    , 
                                    ROUND(SUM(dist_spct1), 14)            dist_spct1   , 
                                    ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi ,
                                    ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                               FROM giuw_wpolicyds_dtl
                              WHERE share_cd   != '1'
                                AND line_cd     = v_line_cd
                                AND dist_seq_no = c1.dist_seq_no
                                AND dist_no     = c1.dist_no)
                 LOOP
                   v_exist             := 'Y';
                   v_sum_dist_tsi      := c20.dist_tsi;
                   v_sum_dist_prem     := c20.dist_prem;
                   v_sum_dist_spct     := c20.dist_spct;
                   v_sum_dist_spct1    := c20.dist_spct1;
                   v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                   v_sum_ann_dist_spct := c20.ann_dist_spct;
                   EXIT;
                 END LOOP;
                 IF v_exist = 'N' THEN
                    EXIT;
                 END IF;

                 /* Calculate for the values to be attained by the fields
                 ** belonging to the NET RETENTION share by subtracting
                 ** the values attained from the master table with the
                 ** values attained above. */
                 v_correct_dist_tsi      := ABS(v_tsi_amt)  - ABS(v_sum_dist_tsi);
                 v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                 v_correct_dist_spct     := 100 - v_sum_dist_spct;
                 v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
                 v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                 v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                 IF SIGN(v_tsi_amt) = -1 THEN
                    v_correct_dist_tsi := v_correct_dist_tsi * -1;
                 END IF;
                 IF SIGN(v_prem_amt) = -1 THEN
                    v_correct_dist_prem := v_correct_dist_prem * -1;
                 END IF;
                 IF SIGN(v_ann_tsi_amt) = -1 THEN
                    v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                 END IF;

                 /* Update the values of the fields belonging to the NET
                 ** RETENTION share to equalize the amounts attained from
                 ** the detail table with the amounts attained from the
                 ** master table. */
                 UPDATE giuw_wpolicyds_dtl 
                    SET dist_tsi      = v_correct_dist_tsi,
                        dist_prem     = v_correct_dist_prem,
                        dist_spct     = v_correct_dist_spct,
                        dist_spct1    = v_correct_dist_spct1,
                        ann_dist_tsi  = v_correct_ann_dist_tsi,
                        ann_dist_spct = v_correct_ann_dist_spct
                  WHERE ROWID         = c10.rowid;
                 EXIT;
               END LOOP;
               IF v_exist = 'N' THEN
                  RAISE NO_DATA_FOUND;
               END IF;

               /*************************** End of Section B ***************************/

             EXCEPTION
               WHEN NO_DATA_FOUND THEN  
                 BEGIN

                   /****************************** Section C ******************************
                   ** Adjust the value of the fields belonging to the share of the FIRST
                   ** RETRIEVED ROW.
                   ***********************************************************************/

                   /* Get the ROWID of the first retrieved
                   ** row in preparation for update. */ 
                   FOR c10 IN (SELECT ROWID 
                                 FROM giuw_wpolicyds_dtl
                                WHERE ROWNUM      = '1'
                                  AND dist_seq_no = c1.dist_seq_no
                                  AND dist_no     = c1.dist_no)
                   LOOP

                     /* Get the sum of each field for all the shares excluding the share
                     ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                     ** in calculating for the values to be attained by the fields belonging
                     ** to the FIRST ROW. */
                     FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi      ,
                                        ROUND(SUM(dist_prem), 2)             dist_prem     , 
                                        ROUND(SUM(dist_spct), 14)             dist_spct     ,
                                        ROUND(SUM(dist_spct1), 14)            dist_spct1    ,
                                        ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi  ,
                                        ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                                   FROM giuw_wpolicyds_dtl
                                  WHERE ROWID       != c10.rowid
                                    AND dist_seq_no  = c1.dist_seq_no
                                    AND dist_no      = c1.dist_no)
                     LOOP
                       v_sum_dist_tsi      := c20.dist_tsi;
                       v_sum_dist_prem     := c20.dist_prem;
                       v_sum_dist_spct     := c20.dist_spct;
                       v_sum_dist_spct1    := c20.dist_spct1;
                       v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                       v_sum_ann_dist_spct := c20.ann_dist_spct;
                       EXIT;
                     END LOOP;

                     /* Calculate for the values to be attained by the fields
                     ** belonging to the share of the FIRST ROW by subtracting
                     ** the values attained from the master table with the
                     ** values attained above. */
                     v_correct_dist_tsi      := ABS(v_tsi_amt) - ABS(v_sum_dist_tsi);
                     v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                     v_correct_dist_spct     := 100 - v_sum_dist_spct;
                     v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
                     v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                     v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                     IF SIGN(v_tsi_amt) = -1 THEN
                        v_correct_dist_tsi := v_correct_dist_tsi * -1;
                     END IF;
                     IF SIGN(v_prem_amt) = -1 THEN
                        v_correct_dist_prem := v_correct_dist_prem * -1;
                     END IF;
                     IF SIGN(v_ann_tsi_amt) = -1 THEN
                        v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                     END IF;

                     /* Update the values of the fields belonging to the share
                     ** of the FIRST ROW to equalize the amounts attained from
                     ** the detail table with the amounts attained from the
                     ** master table. */
                     UPDATE giuw_wpolicyds_dtl 
                        SET dist_tsi      = v_correct_dist_tsi,
                            dist_prem     = v_correct_dist_prem,
                            dist_spct     = v_correct_dist_spct,
                            dist_spct1    = v_correct_dist_spct1,
                            ann_dist_tsi  = v_correct_ann_dist_tsi,
                            ann_dist_spct = v_correct_ann_dist_spct
                      WHERE ROWID         = c10.rowid;
                     EXIT;

                   END LOOP;
                 END;
                
                 /**************************** End of Section C *************************/

             END;
          END IF;
        END;
      END LOOP;
    END;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **  Description  : Creates a new distribution record in table GIUW_WPOLICYDS_DTL
    **                 based on the values taken in by the fields of the negated
    **                 record.
    **                 NOTE:  The value of field DIST_NO was not copied, as the newly 
    **                 created distribution record has its own distribution number.
    */ 
    PROCEDURE NEG_POLICYDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_v_ratio          IN OUT NUMBER)
    IS
      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no   , line_cd      , share_cd  , 
               dist_tsi      , dist_prem    , dist_spct ,
               ann_dist_spct , ann_dist_tsi , dist_grp  , dist_spct1 --added dist_spct1 edgar 09/22/2014
          FROM giuw_policyds_dtl
         WHERE dist_no = p_var_v_neg_distno; -- marco - 07-24-2012 - modified condition
       --WHERE dist_no = p_v_ratio;

      v_dist_seq_no            giuw_policyds_dtl.dist_seq_no%type;
      v_line_cd            giuw_policyds_dtl.line_cd%type;
      v_share_cd            giuw_policyds_dtl.share_cd%type;
      v_dist_tsi            giuw_policyds_dtl.dist_tsi%type;
      v_dist_prem            giuw_policyds_dtl.dist_prem%type;
      v_dist_spct            giuw_policyds_dtl.dist_spct%type;
      v_dist_spct1            giuw_policyds_dtl.dist_spct%type; --added dist_spct1 edgar 09/22/2014
      v_ann_dist_spct        giuw_policyds_dtl.ann_dist_spct%type;
      v_ann_dist_tsi        giuw_policyds_dtl.ann_dist_tsi%type;
      v_dist_grp            giuw_policyds_dtl.dist_grp%type;
      v_dist_prem_f            giuw_policyds_dtl.dist_prem%type;
      v_dist_prem_w            giuw_policyds_dtl.dist_prem%type;
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no   , v_line_cd      , v_share_cd  ,
              v_dist_tsi      , v_dist_prem    , v_dist_spct ,
              v_ann_dist_spct , v_ann_dist_tsi , v_dist_grp  , v_dist_spct1;--added dist_spct1 edgar 09/22/2014
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        v_dist_prem_f := ROUND(v_dist_prem * p_v_ratio, 2);
        v_dist_prem_w := v_dist_prem - v_dist_prem_f; 
       /* earned portion */
       INSERT INTO  giuw_wpolicyds_dtl
                    (dist_no           , dist_seq_no     , line_cd        , 
                     share_cd          , dist_tsi        , dist_prem      ,
                     dist_spct         , ann_dist_spct   , ann_dist_tsi   , 
                     dist_grp          , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_dist_no     , v_dist_seq_no   , v_line_cd      , 
                     v_share_cd        , v_dist_tsi      , v_dist_prem_f  ,
                     v_dist_spct       , v_ann_dist_spct , v_ann_dist_tsi , 
                     v_dist_grp        , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
       /* unearned portion */
       INSERT INTO  giuw_wpolicyds_dtl
                    (dist_no           , dist_seq_no     , line_cd        , 
                     share_cd          , dist_tsi        , dist_prem      ,
                     dist_spct         , ann_dist_spct   , ann_dist_tsi   , 
                     dist_grp          , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_temp_distno , v_dist_seq_no   , v_line_cd      , 
                     v_share_cd        , v_dist_tsi      , v_dist_prem_w  ,
                     v_dist_spct       , v_ann_dist_spct , v_ann_dist_tsi , 
                     v_dist_grp        , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
                     
      END LOOP;
      CLOSE dtl_retriever_cur;  
    END NEG_POLICYDS_DTL_GIUTS021;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Used for Post batch distribution process.     
*/

    PROCEDURE POST_WPOLICYDS_DTL_GIUWS015 (p_batch_id    IN  GIUW_POL_DIST.batch_id%TYPE,
                                           p_dist_no     IN  GIUW_POL_DIST.dist_no%TYPE) IS

    BEGIN
         
        DELETE GIUW_WPOLICYDS_DTL
         WHERE dist_no = p_dist_no;

           DECLARE
            CURSOR C3 IS SELECT * 
                           FROM GIUW_WPOLICYDS
                          WHERE dist_no = p_dist_no
                       ORDER BY dist_no;
            
            v_dist_tsi       GIUW_WPOLICYDS.tsi_amt%TYPE;
            v_dist_prem      GIUW_WPOLICYDS.prem_amt%TYPE;
            v_ann_dist_tsi   GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
            v_dist_grp       CONSTANT GIUW_WPOLICYDS_DTL.dist_grp%TYPE := 1;

           BEGIN
            FOR c3_rec IN C3
                LOOP
                    DECLARE
                       CURSOR C4 IS SELECT * 
                                      FROM GIUW_DIST_BATCH_DTL
                                     WHERE batch_id = p_batch_id;

                    BEGIN
                       FOR c4_rec IN C4 LOOP
                            v_dist_tsi     := c3_rec.tsi_amt * (c4_rec.dist_spct/100);
                            v_dist_prem    := c3_rec.prem_amt * (c4_rec.dist_spct/100);
                            v_ann_dist_tsi := c3_rec.ann_tsi_amt * (c4_rec.dist_spct/100);
                            
                            INSERT INTO GIUW_WPOLICYDS_DTL(
                                       dist_no,         dist_seq_no,        line_cd,           share_cd
                                      ,dist_tsi,        dist_prem,          dist_spct,         dist_spct1
                                      ,ann_dist_tsi,    dist_grp,           ann_dist_spct) 
                              VALUES ( c3_rec.dist_no,  c3_rec.dist_seq_no, c4_rec.line_cd  ,  c4_rec.share_cd
                                      ,v_dist_tsi    ,  v_dist_prem       , c4_rec.dist_spct,  NULL
                                      ,v_ann_dist_tsi,  v_dist_grp        , c4_rec.dist_spct);
                       END LOOP;
                    END;
                    
                END LOOP;
          END;
    END;
    
END giuw_wpolicyds_dtl_pkg;
/


