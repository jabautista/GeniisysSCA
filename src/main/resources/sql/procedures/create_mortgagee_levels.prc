DROP PROCEDURE CPI.CREATE_MORTGAGEE_LEVELS;

CREATE OR REPLACE PROCEDURE CPI."CREATE_MORTGAGEE_LEVELS" (v_extract NUMBER) AS
   v_extract_id  NUMBER(12)  := v_extract;
   v_total_risk  NUMBER;
   v_total_items NUMBER;
   v_cnt         NUMBER := 0;
   v_rec         NUMBER := 0;
   v_mortg       VARCHAR(500) :='';
   v_mortg_level VARCHAR2(500);
   v_final_mortg VARCHAR2(500);
/*created by: ging 071706
              to create mortgagee levels
 */
BEGIN
--risk count--
 SELECT count(DISTINCT e.risk_no)
   INTO v_total_risk
   FROM gixx_item e
  WHERE e.extract_id = v_extract_id;
--item count--
 SELECT count(*) item_cnt
   INTO v_total_items
   FROM gixx_item x,gixx_polbasic y
  WHERE x.extract_id = y.extract_id
    AND x.extract_id = v_extract_id;
  FOR v_risk_cnt IN 1..v_total_risk LOOP
     FOR rec IN (SELECT b.risk_no, c.mortg_name, a.amount,b.currency_cd,b.currency_rt, count(*) mortg_cnt
                   FROM GIXX_MORTGAGEE a,
                        gixx_item b,
                        giis_mortgagee c,
                        gixx_polbasic d
                  WHERE a.item_no = b.item_no
                    AND a.extract_id = b.extract_id
                    AND a.extract_id =v_extract_id
                    AND a.mortg_cd = c.mortg_cd
                    AND c.iss_cd = d.iss_cd
                    AND d.extract_id = a.extract_id
              HAVING count(*) = (SELECT nvl(count(*),0) item_cnt
                                   FROM gixx_item x
                                  WHERE x.extract_id = v_extract_id
                                    AND x.risk_no = v_risk_cnt
                                    AND x.risk_no = b.risk_no
                               GROUP BY x.risk_no)
               GROUP BY b.risk_no, c.mortg_name, a.amount,b.currency_cd,b.currency_rt)
   LOOP
       INSERT INTO GIXX_MORTGAGEE_LEVELS(extract_id,risk_no,mortg_name,amount,currency_cd,currency_rt,level_cd)
      VALUES (v_extract_id,rec.risk_no,rec.mortg_name,rec.amount,rec.currency_cd,rec.currency_rt,'R');
   END LOOP;
 FOR v_item_cnt IN 1..v_total_items LOOP
   FOR rec2 IN (SELECT r.risk_no,r.risk_item_no, s.mortg_name, q.amount,r.item_no,r.currency_cd,r.currency_rt
                     FROM GIXX_MORTGAGEE q,
                          gixx_item r,
                          giis_mortgagee s,
                          gixx_polbasic t
                    WHERE q.item_no=r.item_no
                      AND q.extract_id=r.extract_id
                      AND q.extract_id=v_extract_id
                      AND q.mortg_cd=s.mortg_cd
                      AND s.iss_cd =t.iss_cd
                      AND t.extract_id=q.extract_id
                      AND r.item_no = v_item_cnt
                      AND r.risk_no = v_risk_cnt
                      AND NOT EXISTS (SELECT b.risk_no, c.mortg_name, a.amount,b.currency_cd,b.currency_rt, count(*) mortg_cnt
                                        FROM GIXX_MORTGAGEE a,
                                             gixx_item b,
                                             giis_mortgagee c,
                                             gixx_polbasic d
                                       WHERE a.item_no = b.item_no
                                         AND a.extract_id = b.extract_id
                                         AND a.extract_id =v_extract_id
                                         AND a.mortg_cd = c.mortg_cd
                                         AND c.iss_cd = d.iss_cd
                                         AND d.extract_id = a.extract_id
                                         AND a.extract_id =  r.extract_id
                                         AND b.risk_no = r.risk_no
                                         AND c.mortg_name = s.mortg_name
           AND b.currency_cd = r.currency_cd
           AND b.currency_rt = r.currency_rt
                                      HAVING count(*) = (SELECT nvl(count(*),0) item_cnt
                                                           FROM gixx_item x
                                                          WHERE x.extract_id = v_extract_id
                                                            AND x.risk_no = v_risk_cnt
                                                            AND x.risk_no = b.risk_no
                                                       GROUP BY x.risk_no)
                                    GROUP BY b.risk_no, c.mortg_name, a.amount,b.currency_cd,b.currency_rt))
     LOOP
     INSERT INTO GIXX_MORTGAGEE_LEVELS(extract_id,risk_no,risk_item_no,item_no,mortg_name,amount,currency_cd,currency_rt,level_cd)
     VALUES (v_extract_id,rec2.risk_no,rec2.risk_item_no,rec2.item_no,rec2.mortg_name,rec2.amount,rec2.currency_cd,rec2.currency_rt,'I');
     END LOOP;
   END LOOP;
  END LOOP;
  COMMIT;
--to summarize
BEGIN
FOR w IN(SELECT mortg_name,amount,currency_cd,currency_rt,count(*) cnt
           FROM GIXX_MORTGAGEE_LEVELS
          WHERE extract_id = v_extract_id
       GROUP BY mortg_name, amount,currency_cd,currency_rt)
LOOP
   v_cnt := w.cnt;
   IF v_cnt > 1 THEN
        FOR y IN (SELECT mortg_name,amount,currency_cd,currency_rt,decode(level_cd,'R',
                         ' - Applicable to Risk '||risk_no,'I',' - Applicable to '
                         ||'Risk No. '||risk_no||' Item No. '||risk_item_no) mortg_level
                    FROM GIXX_MORTGAGEE_LEVELS
                   WHERE mortg_name = w.mortg_name
                     AND amount = w.amount
      AND currency_cd = w.currency_cd
      AND currency_rt = w.currency_rt
                     AND extract_id = v_extract_id
                ORDER BY level_cd DESC, risk_no ASC,risk_item_no ASC)
        LOOP
              v_rec := v_rec + 1;
              IF v_rec = 1 THEN
                 v_mortg := y.mortg_level;
              ELSIF v_rec > 1 THEN
                 v_mortg := v_mortg||', '||substr(y.mortg_level,length(' - Applicable to '));
              END IF;
        END LOOP;
              v_mortg_level := v_mortg;
              v_final_mortg := v_mortg_level;
      -- DBMS_OUTPUT.PUT_LINE(w.mortg_name||' '||w.amount||' '||v_final_mortg);
     INSERT INTO GIXX_MORTGAGEE_LEVELS(extract_id,mortg_name,amount,currency_cd,currency_rt,remarks)
          VALUES (v_extract_id,w.mortg_name,w.amount,w.currency_cd,w.currency_rt,v_final_mortg);
              v_rec := 0; ---reset values
              v_mortg := NULL;
   ELSIF v_cnt = 1 THEN
        FOR y IN (SELECT mortg_name,amount,currency_cd,currency_rt,decode(level_cd,'R',' - Applicable to Risk '||risk_no,'I',' - Applicable to '
                         ||'Risk No. '||risk_no||' Item No. '||risk_item_no) mortg_level
                    FROM GIXX_MORTGAGEE_LEVELS
                   WHERE mortg_name = w.mortg_name
                     AND amount = w.amount
      AND currency_cd = w.currency_cd
      AND currency_rt = w.currency_rt
                     AND extract_id = v_extract_id
                ORDER BY level_cd DESC, risk_no ASC,risk_item_no ASC)
        LOOP
              v_mortg_level := y.mortg_level;
        END LOOP;
              v_final_mortg := v_mortg_level;
       -- DBMS_OUTPUT.PUT_LINE(w.mortg_name||' '||w.amount||' '||v_final_mortg);
      INSERT INTO GIXX_MORTGAGEE_LEVELS(extract_id,mortg_name,amount,currency_cd,currency_rt,remarks)
          VALUES (v_extract_id,w.mortg_name,w.amount,w.currency_cd,w.currency_rt,v_final_mortg);
  END IF;
END LOOP;
      DELETE
        FROM GIXX_MORTGAGEE_LEVELS
       WHERE extract_id = v_extract_id
         AND remarks IS NULL;
  COMMIT;
END;
END;
/


