DROP PROCEDURE CPI.PRE_POST_DIST_GIUWS012;

CREATE OR REPLACE PROCEDURE CPI.PRE_POST_DIST_GIUWS012(
   p_dist_no         GIUW_POL_DIST.dist_no%TYPE,
   p_policy_id       GIPI_POLBASIC.policy_id%TYPE,
   p_par_type        GIPI_PARLIST.par_type%TYPE
)
AS
   v_cnt             NUMBER;
   v_basic_exists    VARCHAR2(1);
   
   PROCEDURE val_existing_dist_rec(
      v_policy_id    GIPI_POLBASIC.policy_id%TYPE,
      v_dist_no      GIUW_POL_DIST.dist_no%TYPE
   )
   IS
      v_hdr_sw       VARCHAR2(1);
      v_dtl_sw       VARCHAR2(1);
   BEGIN
      FOR a IN(SELECT b340.item_grp, SUM(b340.prem_amt) prem, 
                      SUM(b340.tsi_amt) tsi, SUM(b340.ann_tsi_amt) ann_tsi
                 FROM GIPI_ITEM b340
                WHERE b340.policy_id = v_policy_id
                GROUP BY b340.item_grp)
      LOOP
         v_hdr_sw := 'N';
         
         FOR b IN(SELECT SUM(c110.prem_amt) prem, SUM(c110.tsi_amt) tsi,
                         SUM(c110.ann_tsi_amt) ann_tsi
                    FROM GIUW_WPOLICYDS c110
                   WHERE dist_no = v_dist_no
                     AND item_grp = a.item_grp)
         LOOP
            IF NVL(a.prem,0) = NVL(b.prem,0) AND NVL(a.tsi,0) = NVL(b.tsi,0) THEN
               v_hdr_sw := 'Y';
            END IF;
         END LOOP;
         
         IF v_hdr_sw = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
         END IF;
      END LOOP;
      
      
      IF v_hdr_sw = 'Y' THEN
         FOR seq IN(SELECT c110.dist_seq_no, c110.tsi_amt,
                           c110.ann_tsi_amt, c110.prem_amt
                      FROM GIUW_WPOLICYDS c110
                     WHERE c110.dist_no = v_dist_no)
        
         LOOP
            v_dtl_sw := 'N';
            
            FOR b IN(SELECT SUM(NVL(dist_tsi,0))  dist_tsi,
  	                         SUM(NVL(dist_prem,0)) dist_prem,
                            SUM(NVL(ann_dist_tsi,0)) ann_dist_tsi
                       FROM GIUW_WPOLICYDS_DTL c130
                      WHERE c130.dist_no = v_dist_no
                        AND c130.dist_seq_no = seq.dist_seq_no)
            LOOP
               IF NVL(seq.tsi_amt,0) = NVL(b.dist_tsi,0) AND NVL(seq.ann_tsi_amt,0) = NVL(b.ann_dist_tsi,0)
                  AND NVL(seq.prem_amt,0) = NVL(b.dist_prem,0) THEN
                  v_dtl_sw := 'Y';
               END IF;   
  	            EXIT;
            END LOOP;
            
            IF v_dtl_sw = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
            END IF;
            
            v_hdr_sw := 'N';
            FOR item IN(SELECT item_no, dist_seq_no
                          FROM GIUW_WITEMDS c040
                         WHERE c040.dist_no = v_dist_no
                           AND c040.dist_seq_no = seq.dist_seq_no)
            LOOP
               v_hdr_sw := 'Y';	
               v_dtl_sw := 'N';
               
               FOR b IN(SELECT '1'
                          FROM GIUW_WITEMDS_DTL c050
                         WHERE c050.dist_no = v_dist_no
                           AND c050.dist_seq_no = seq.dist_seq_no
                           AND c050.item_no = item.item_no)
               LOOP            
  	               v_dtl_sw := 'Y';
  	               EXIT;
               END LOOP;
               
               IF v_dtl_sw = 'N' THEN
                  raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
               END IF;
            END LOOP;
         END LOOP;
      END IF;
      
      FOR perl IN(SELECT peril_cd, item_no
                    FROM GIPI_ITMPERIL	b380
                   WHERE policy_id = v_policy_id)
      LOOP
         v_hdr_sw := 'N';
         FOR a IN(SELECT '1'
                    FROM GIUW_WITEMPERILDS c060
                   WHERE c060.dist_no = v_dist_no
                     AND c060.item_no = perl.item_no
                     AND c060.peril_cd = perl.peril_cd)
         LOOP
            v_hdr_sw := 'Y';
            v_dtl_sw := 'N';
            
            FOR b IN(SELECT '1'
                       FROM GIUW_WITEMPERILDS_DTL c070
  	                   WHERE c070.dist_no = v_dist_no
  	                     AND c070.item_no = perl.item_no
  	                     AND c070.peril_cd = perl.peril_cd)
            LOOP
               v_dtl_sw := 'Y';
  	            EXIT;
            END LOOP;
            
            IF v_dtl_sw = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
            END IF;
         END LOOP;
         
         IF v_hdr_sw = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
         END IF;
      END LOOP;
      
      IF v_hdr_sw = 'N' THEN
         raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
      END IF;
      
      FOR perl IN(SELECT DISTINCT c060.peril_cd peril_cd, c060.dist_seq_no
                    FROM GIUW_WITEMPERILDS c060
                   WHERE c060.dist_no = v_dist_no)
      LOOP
         v_hdr_sw := 'N';
         
         FOR a IN(SELECT c090.dist_no, c090.dist_seq_no, c090.peril_cd
                    FROM GIUW_WPERILDS c090
                   WHERE c090.dist_no = v_dist_no
                     AND c090.dist_seq_no = perl.dist_seq_no
                     AND c090.peril_cd = perl.peril_cd)
         LOOP
            v_hdr_sw := 'Y';
  	         v_dtl_sw := 'N';
            
            FOR b IN(SELECT '1'
  	                    FROM GIUW_WPERILDS_DTL c100
                      WHERE c100.dist_no = a.dist_no
                        AND c100.dist_seq_no = a.dist_seq_no
                        AND c100.peril_cd = a.peril_cd)
  	         LOOP
  		         v_dtl_sw := 'Y';
  		         EXIT;
            END LOOP;
            
            IF v_dtl_sw = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
  	         END IF;
         END LOOP;
         
         IF v_hdr_sw = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
         END IF;
      END LOOP;
   END;
   
   PROCEDURE val_existing_dist_rec2(
      v_policy_id    GIPI_POLBASIC.policy_id%TYPE,
      v_dist_no      GIUW_POL_DIST.dist_no%TYPE
   )
   IS
      v_hdr_sw       VARCHAR2(1);
      v_dtl_sw       VARCHAR2(1);
   BEGIN
      FOR a IN(SELECT prem_amt prem, tsi_amt tsi, ann_tsi_amt ann_tsi
                 FROM GIUW_POL_DIST
                WHERE policy_id = v_policy_id
                  AND dist_no = v_dist_no)
      LOOP
         v_hdr_sw := 'N';
         
         FOR b IN(SELECT ROUND(SUM(c110.prem_amt * b.currency_rt), 2) prem,
    							 ROUND(SUM(c110.tsi_amt * b.currency_rt), 2) tsi,
                         ROUND(SUM(c110.ann_tsi_amt * b.currency_rt), 2) ann_tsi
                    FROM GIUW_WPOLICYDS c110,
                         GIPI_INVOICE b
                   WHERE c110.dist_no = v_dist_no
			   		    AND b.policy_id = v_policy_id
			   		    AND c110.item_grp = b.item_grp)
         LOOP
            IF NVL(a.prem,0) = NVL(b.prem,0) AND NVL(a.tsi,0) = NVL(b.tsi,0) THEN
    	         v_hdr_sw := 'Y';
            END IF;
         END LOOP;
         
         IF v_hdr_sw = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                             'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
         END IF;
      END LOOP;
      
      IF v_hdr_sw = 'Y' THEN
         FOR seq IN(SELECT c110.dist_seq_no, c110.tsi_amt,
                           c110.ann_tsi_amt, c110.prem_amt
                      FROM GIUW_WPOLICYDS c110
                     WHERE c110.dist_no = v_dist_no)
         LOOP
            v_dtl_sw := 'N';
            
            FOR b IN(SELECT SUM(NVL(dist_tsi,0))  dist_tsi,
  	                         SUM(NVL(dist_prem,0)) dist_prem,
                            SUM(NVL(ann_dist_tsi,0)) ann_dist_tsi
                       FROM GIUW_WPOLICYDS_DTL c130
                      WHERE c130.dist_no = v_dist_no
                        AND c130.dist_seq_no = seq.dist_seq_no)
            LOOP
               IF NVL(seq.tsi_amt,0) = NVL(b.dist_tsi,0) AND NVL(seq.ann_tsi_amt,0) = NVL(b.ann_dist_tsi,0) AND NVL(seq.prem_amt,0) = NVL(b.dist_prem,0) THEN
                  v_dtl_sw := 'Y';
               END IF;   
  	            EXIT;
            END LOOP;
            
            IF v_dtl_sw = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
            END IF;
            
            v_hdr_sw := 'N';
            FOR item IN(SELECT item_no, dist_seq_no
                          FROM GIUW_WITEMDS c040
                         WHERE c040.dist_no = v_dist_no
                           AND c040.dist_seq_no = seq.dist_seq_no)
            LOOP
               v_hdr_sw := 'Y';	
               v_dtl_sw := 'N';
               
               FOR b IN(SELECT '1'
                          FROM GIUW_WITEMDS_DTL c050
                         WHERE c050.dist_no = v_dist_no
                           AND c050.dist_seq_no = seq.dist_seq_no
                           AND c050.item_no = item.item_no)
               LOOP            
                  v_dtl_sw := 'Y';
                  EXIT;
               END LOOP;
            
               IF v_dtl_sw = 'N' THEN
                  raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                   'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
               END IF;
            END LOOP;
         END LOOP;
      END IF;
      
      FOR perl IN(SELECT peril_cd, item_no
                    FROM GIPI_ITMPERIL	b380
                   WHERE policy_id = v_policy_id
                     AND item_no IN(SELECT item_no 
				  	  		  	 				  FROM GIUW_WITEMDS
								   			 WHERE dist_no = v_dist_no))
      LOOP
         v_hdr_sw := 'N';
         
         FOR A IN(SELECT '1'
                    FROM GIUW_WITEMPERILDS c060
                   WHERE c060.dist_no = v_dist_no
                     AND c060.item_no = perl.item_no
                     AND c060.peril_cd = perl.peril_cd)
         LOOP
            v_hdr_sw := 'Y';
            v_dtl_sw := 'N';
            
            FOR b IN(SELECT '1'
                       FROM GIUW_WITEMPERILDS_DTL c070
  	                   WHERE c070.dist_no = v_dist_no                 
                        AND c070.item_no = perl.item_no
                        AND c070.peril_cd = perl.peril_cd)
            LOOP
               v_dtl_sw := 'Y';
  	            EXIT;
            END LOOP;
            
            IF v_dtl_sw = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                   'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
            END IF;
         END LOOP;
         
         IF v_hdr_sw = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                   'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
         END IF;
      END LOOP;
      
      IF v_hdr_sw = 'N' THEN
         raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                   'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
      END IF;
      
      FOR perl IN(SELECT DISTINCT c060.peril_cd peril_cd, c060.dist_seq_no
                    FROM GIUW_WITEMPERILDS c060
                   WHERE c060.dist_no = v_dist_no)
      LOOP
         v_hdr_sw := 'N';
         
         FOR a IN(SELECT c090.dist_no, c090.dist_seq_no, c090.peril_cd
                    FROM GIUW_WPERILDS c090
                   WHERE c090.dist_no = v_dist_no
                     AND c090.dist_seq_no = perl.dist_seq_no
                     AND c090.peril_cd = perl.peril_cd)
         LOOP
            v_hdr_sw := 'Y';
  	         v_dtl_sw := 'N';
     
            FOR b IN(SELECT '1'
                       FROM GIUW_WPERILDS_DTL c100
                      WHERE c100.dist_no = a.dist_no
                        AND c100.dist_seq_no = a.dist_seq_no
                        AND c100.peril_cd = a.peril_cd)
  	         LOOP
  		         v_dtl_sw := 'Y';
  		         EXIT;
  	         END LOOP;
            
            IF v_dtl_sw = 'N' THEN
               raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                   'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
  	         END IF;
         END LOOP;
         
         IF v_hdr_sw = 'N' THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There was an error encountered in distribution records, '||
                                                   'to correct this error please recreate using Set-Up Groups For Distribution(Item).');
         END IF;
      END LOOP;
   END;
   
BEGIN
   FOR i IN(SELECT COUNT(dist_no) count
              FROM GIUW_POL_DIST
             WHERE policy_id = p_policy_id
               AND negate_date IS NULL
               AND dist_flag IN ('1','2','3'))
   LOOP
  	   v_cnt := i.count;
   END LOOP;
   IF v_cnt > 1 THEN
      val_existing_dist_rec2(p_policy_id, p_dist_no);
   ELSE    
      val_existing_dist_rec(p_policy_id, p_dist_no);
   END IF;

   /* removed by robert SR 5053  01.08.16 
   FOR i IN(SELECT dist_seq_no
              FROM GIUW_WPOLICYDS
             WHERE dist_no = p_dist_no)
   LOOP
      v_basic_exists := 'N';
   
      FOR d IN(SELECT DISTINCT b.peril_type
                 FROM GIUW_WPERILDS a,
                      GIIS_PERIL b
                WHERE a.dist_no = p_dist_no
                  AND a.dist_seq_no = i.dist_seq_no
                  AND a.line_cd = b.line_cd
                  AND a.peril_cd = b.peril_cd)
      LOOP
         IF d.peril_type = 'B' THEN
            v_basic_exists := 'Y';
            EXIT;
         END IF;
      END LOOP;
      
      IF v_basic_exists = 'N' THEN
         FOR c IN(SELECT a.tsi_amt, a.prem_amt
                    FROM GIUW_WPERILDS a
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = i.dist_seq_no)
         LOOP
            IF c.tsi_amt != 0 AND c.prem_amt = 0 THEN
               raise_application_error(-20001, 'Geniisys Exception#I#Cannot post distribution. Please distribute by group.');
            END IF;
         END LOOP;
      END IF;
   END LOOP; */

   /* IF p_par_type = 'E' THEN
      FOR i IN(SELECT a.tsi_amt, a.prem_amt, b.peril_type
                 FROM GIUW_WPERILDS a,
                      GIIS_PERIL b
                WHERE a.dist_no = p_dist_no
                  AND a.line_cd = b.line_cd
                  AND a.peril_cd = b.peril_cd)
      LOOP
         IF i.peril_type = 'A' AND i.tsi_amt != 0 AND i.prem_amt = 0 THEN
            raise_application_error(-20001, 'Geniisys Exception#I#Cannot post distribution. Please distribute by group.');
         END IF;
      END LOOP;
   END IF; */

    /* removed by robert SR 5053  01.08.16 
   FOR i IN(SELECT NVL(tsi_amt, 0) tsi_amt,
                   NVL(prem_amt, 0) prem_amt
              FROM GIPI_POLBASIC
             WHERE policy_id = p_policy_id)
   LOOP
      IF i.tsi_amt = 0 AND i.prem_amt = 0 THEN
         raise_application_error(-20001, 'Geniisys Exception#I#Cannot post distribution. Please distribute by group.');
      END IF;
   END LOOP; */
END;
/


