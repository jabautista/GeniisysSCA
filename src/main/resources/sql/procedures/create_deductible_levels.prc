DROP PROCEDURE CPI.CREATE_DEDUCTIBLE_LEVELS;

CREATE OR REPLACE PROCEDURE CPI."CREATE_DEDUCTIBLE_LEVELS" (v_extract NUMBER)
AS
   v_extract_id     NUMBER(12)  := v_extract;
   v_total_risk     NUMBER;
   v_total_items    NUMBER;
   v_cnt NUMBER := 0;
   v_rec NUMBER := 0;
   v_risk_stored NUMBER(12) := 0;
   v_deduct VARCHAR(500) :='';
   v_deduct_level VARCHAR2(4000);
   v_final_deduct VARCHAR2(4000);
   v_deductible_text VARCHAR2(4000);
   v_risk_no NUMBER :=0;
   v_level_cd VARCHAR2(6);
   v_ded_deductible_cd VARCHAR2(5);
 /* created by: ging 071706
 ** to identify whether a deductible is a policy level,a risk level or a risk item level deductible 
 */
BEGIN
--risk count--
 SELECT count( DISTINCT e.risk_no)
   INTO v_total_risk
   FROM gixx_item e
  WHERE e.extract_id = v_extract_id;
--item count--
 SELECT count(*) item_cnt
   INTO v_total_items
   FROM gixx_item x,gixx_polbasic y
  WHERE x.extract_id = y.extract_id
    AND x.extract_id = v_extract_id;
 
IF v_total_risk <> 0 THEN   --added by: ging 091506,  to handle deductibles for open policies
  FOR v_risk_cnt IN 1..v_total_risk LOOP   -- non open policies
        --risk level loop--
     FOR rec IN (SELECT b.risk_no,a.ded_deductible_cd,a.DEDUCTIBLE_TEXT, count(*) risk_item_cnt
                   FROM GIXX_DEDUCTIBLES a,
                        gixx_item b,
                        GIIS_DEDUCTIBLE_DESC c,
                        GIIS_PERIL d
                  WHERE a.DED_DEDUCTIBLE_CD  = c.DEDUCTIBLE_CD (+)
                    AND a.ITEM_NO            = b.ITEM_NO
                    AND a.EXTRACT_ID         = b.EXTRACT_ID
                    AND a.DED_SUBLINE_CD     = c.SUBLINE_CD (+)
                    AND a.DED_LINE_CD        = c.LINE_CD (+)
                    AND a.DED_LINE_CD        = d.LINE_CD (+)
                    AND a.PERIL_CD           = d.PERIL_CD (+)
                    AND a.extract_id         = v_extract_id
               HAVING count(*) = (SELECT count(*) item_cnt
                                    FROM gixx_item x
                                   WHERE x.extract_id = v_extract_id
                                     AND x.risk_no = v_risk_cnt
                                     AND x.risk_no = b.risk_no
                                GROUP BY x.risk_no)
              GROUP BY b.risk_no,a.ded_deductible_cd,a.DEDUCTIBLE_TEXT)
    LOOP
      INSERT INTO gixx_deductible_levels(extract_id,risk_no,ded_deductible_cd,deductible_text,level_cd)
        VALUES (v_extract_id,rec.risk_no,rec.ded_deductible_cd,rec.deductible_text,'R');
    END LOOP;
     --end of risk level loop
   FOR v_item_cnt IN 1..v_total_items LOOP
      FOR rec2 IN (SELECT f.risk_no, f.item_no,f.risk_item_no,e.ded_deductible_cd, e.DEDUCTIBLE_TEXT
                            FROM GIXX_DEDUCTIBLES e,
                                 gixx_item f,
                                 GIIS_DEDUCTIBLE_DESC g,
                                 GIIS_PERIL h
                           WHERE e.DED_DEDUCTIBLE_CD  = g.DEDUCTIBLE_CD (+)
                             AND e.ITEM_NO            = f.ITEM_NO
                             AND e.EXTRACT_ID         = f.EXTRACT_ID
                             AND e.DED_SUBLINE_CD     = g.SUBLINE_CD (+)
                             AND e.DED_LINE_CD        = g.LINE_CD (+)
                             AND e.DED_LINE_CD        = h.LINE_CD (+)
                             AND e.PERIL_CD           = h.PERIL_CD (+)
                             AND e.extract_id         = v_extract_id
                             AND f.item_no            = v_item_cnt
                             AND f.risk_no            = v_risk_cnt
                             AND NOT EXISTS (SELECT b.risk_no,a.ded_deductible_cd,a.DEDUCTIBLE_TEXT, count(*) risk_item_cnt
                                               FROM GIXX_DEDUCTIBLES a,
                                                    gixx_item b,
                                                    GIIS_DEDUCTIBLE_DESC c,
                                                    GIIS_PERIL d
                                              WHERE a.DED_DEDUCTIBLE_CD  = c.DEDUCTIBLE_CD (+)
                                                AND a.ITEM_NO            = b.ITEM_NO
                                                AND a.EXTRACT_ID         = b.EXTRACT_ID
                                                AND a.DED_SUBLINE_CD     = c.SUBLINE_CD (+)
                                                AND a.DED_LINE_CD        = c.LINE_CD (+)
                                                AND a.DED_LINE_CD        = d.LINE_CD (+)
                                                AND a.PERIL_CD           = d.PERIL_CD (+)
                                                AND a.extract_id         = v_extract_id
               AND a.extract_id         = e.extract_id
                                 AND b.risk_no            = f.risk_no
                                 AND a.deductible_text    = e.deductible_text
               AND a.ded_deductible_cd  = e.ded_deductible_cd
                                             HAVING count(*) = (SELECT count(*) item_cnt
                                                                  FROM gixx_item x
                                                                 WHERE x.extract_id = v_extract_id
                                                                   AND x.risk_no = v_risk_cnt
                                                                   AND x.risk_no = b.risk_no
                                                              GROUP BY x.risk_no)
                                           GROUP BY b.risk_no,e.ded_deductible_cd,a.DEDUCTIBLE_TEXT))
        LOOP
        INSERT INTO gixx_deductible_levels(extract_id,risk_no,item_no,risk_item_no,ded_deductible_cd,deductible_text,level_cd)
                   VALUES (v_extract_id,rec2.risk_no,rec2.item_no,rec2.risk_item_no,rec2.ded_deductible_cd,rec2.deductible_text,'I');
        END LOOP;
     END LOOP;
    END LOOP;
   BEGIN
    FOR x IN (SELECT ded_deductible_cd,deductible_text,count(*) cnt
                FROM gixx_deductible_levels
               WHERE extract_id=v_extract_id
        AND level_cd='R'
              HAVING count(*) = V_TOTAL_RISK/*(SELECT count(DISTINCT risk_no) risk_cnt
                                   FROM gixx_deductible_levels k
                                  WHERE k.level_cd='R'
                              AND k.extract_id = v_extract_id)*/
     GROUP BY ded_deductible_cd,deductible_text)
    LOOP
       UPDATE gixx_deductible_levels
       SET level_cd = NULL
     WHERE deductible_text = x.deductible_text
       AND ded_deductible_cd = x.ded_deductible_cd
       AND extract_id=v_extract_id;
       INSERT INTO gixx_deductible_levels (extract_id,ded_deductible_cd,deductible_text,level_cd)
       VALUES (v_extract_id,x.ded_deductible_cd,x.deductible_text,'Z');
    END LOOP;
    END;
  ---- TO SUMMARIZE ----
  --COMMIT;
   FOR w IN (SELECT DISTINCT ded_deductible_cd,deductible_text
               FROM gixx_deductible_levels
              WHERE level_cd IN ('I','R','Z')
                AND EXTRACT_ID=v_extract_id
                AND ded_deductible_cd NOT IN ('FO','F0')
           GROUP BY ded_deductible_cd,deductible_text,level_cd)
   LOOP
        v_deductible_text :=w.deductible_text;
     v_ded_deductible_cd :=w.ded_deductible_cd;
  
     INSERT INTO GIXX_DEDUCTIBLE_LEVELS (EXTRACT_ID,DED_DEDUCTIBLE_CD,DEDUCTIBLE_TEXT,REMARKS,LEVEL_CD)
      VALUES(v_extract_id,v_ded_deductible_cd,v_deductible_text,'- Applicable to ','F');
  
  
           FOR y IN (SELECT ded_deductible_cd,deductible_text deductible_text,level_cd,risk_no,decode(level_cd,'Z','','R','Risk No. '||to_char(risk_no),'I','Risk No. '||to_char(risk_no)||' Item No. '||risk_item_no) deduct_level
                      FROM gixx_deductible_levels
                     WHERE level_cd IN('I','R','Z')
                       AND extract_id=v_extract_id
                       AND  deductible_text = w.deductible_text
              AND ded_deductible_cd = w.ded_deductible_cd
                  ORDER BY level_cd DESC, risk_no ASC,risk_item_no ASC)
          LOOP
              v_deduct  := y.deduct_level;
              v_ded_deductible_cd := y.ded_deductible_cd;
     v_deductible_text :=y.deductible_text;
              v_risk_no :=y.risk_no;
              v_level_cd:=y.level_cd;
     v_rec := v_rec+1;
   IF v_level_cd<>'Z' THEN
     IF v_rec = 1  THEN
          UPDATE GIXX_DEDUCTIBLE_LEVELS
       SET remarks=remarks||v_deduct
     WHERE extract_id=v_extract_id
       AND deductible_text=v_deductible_text
       AND ded_deductible_cd = v_ded_deductible_cd
       AND LEVEL_CD='F';
       v_risk_stored := v_risk_no;
     ELSE
        IF v_level_cd = 'R' THEN
       UPDATE GIXX_DEDUCTIBLE_LEVELS
       SET remarks=remarks||', '||v_deduct
     WHERE extract_id=v_extract_id
       AND deductible_text=v_deductible_text
       AND ded_deductible_cd = v_ded_deductible_cd
       AND LEVEL_CD='F';
     ELSE
        IF v_risk_stored <> v_risk_no THEN
        UPDATE GIXX_DEDUCTIBLE_LEVELS
        SET remarks=remarks||', '||v_deduct
      WHERE extract_id=v_extract_id
        AND deductible_text=v_deductible_text
        AND ded_deductible_cd = v_ded_deductible_cd
        AND LEVEL_CD='F';
     v_risk_stored := v_risk_no;
     ELSE
        UPDATE GIXX_DEDUCTIBLE_LEVELS
        SET remarks=remarks||', '||substr(v_deduct,length('Risk No. '||to_char(v_risk_no)||' Item No. '))
      WHERE extract_id=v_extract_id
        AND deductible_text=v_deductible_text
        AND ded_deductible_cd = v_ded_deductible_cd
        AND LEVEL_CD='F';
     v_risk_stored := v_risk_no;
        END IF;
       END IF;
     END IF;
   ELSE
       UPDATE GIXX_DEDUCTIBLE_LEVELS
    SET remarks=' '
     WHERE extract_id=v_extract_id
     AND deductible_text=v_deductible_text
     AND ded_deductible_cd=v_ded_deductible_cd
     AND LEVEL_CD='F';
     END IF;
   END LOOP;
    v_rec :=0; --reset
  
   END LOOP;
  
  DELETE FROM GIXX_DEDUCTIBLE_LEVELS
  WHERE EXTRACT_ID=v_extract_id
    AND nvl(level_cd,'I')<>'F';
   COMMIT;
ELSE --(for open policies)
   INSERT INTO GIXX_DEDUCTIBLE_LEVELS(DED_DEDUCTIBLE_CD,DEDUCTIBLE_TEXT,EXTRACT_ID,LEVEL_CD) 
               SELECT a.ded_deductible_cd,a.DEDUCTIBLE_TEXT,v_extract_id,'F'
                 FROM GIXX_DEDUCTIBLES a,
                      gixx_item b,
                      GIIS_DEDUCTIBLE_DESC c,
                      GIIS_PERIL d
                WHERE a.DED_DEDUCTIBLE_CD  = c.DEDUCTIBLE_CD (+)
                  AND a.ITEM_NO            = b.ITEM_NO
                  AND a.EXTRACT_ID         = b.EXTRACT_ID
                  AND a.DED_SUBLINE_CD     = c.SUBLINE_CD (+)
                  AND a.DED_LINE_CD        = c.LINE_CD (+)
                  AND a.DED_LINE_CD        = d.LINE_CD (+)
                  AND a.PERIL_CD           = d.PERIL_CD (+)
      AND a.extract_id         = v_extract_id
      AND a.ded_deductible_cd NOT IN ('FO','F0');
     
   COMMIT;           
END IF;  
END;
/


