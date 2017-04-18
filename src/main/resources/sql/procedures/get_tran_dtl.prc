DROP PROCEDURE CPI.GET_TRAN_DTL;

CREATE OR REPLACE PROCEDURE CPI.GET_TRAN_DTL(p_event_cd NUMBER,
                                           p_event_mod_cd NUMBER,
                                           p_event_col_cd NUMBER,
                                           p_col_value IN NUMBER,
                                           p_tran_dtl OUT VARCHAR2) IS
    v_event_col_cd  giis_events_column.event_col_cd%TYPE;
    v_event_mod_cd  giis_events_column.event_mod_cd%TYPE;
    v_user_id       gipi_user_events_hist.user_id%TYPE;
    v_date_received gipi_user_events_hist.date_received%TYPE;
    v_disp_column   VARCHAR2(3200);
    v_table         VARCHAR2(3200):=NULL;
    v_column        VARCHAR2(3200):=NULL;
    v_validation    VARCHAR2(3200);
    v_status        NUMBER := 0;    
    
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 21, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Procedure to retrieve the tran_dtl column shown in event listing 
*/     
BEGIN  
  --get table_name and column_name
  FOR A_REC IN ( SELECT a.table_name, a.column_name
                   FROM giis_events_column a
                  WHERE a.event_cd = p_event_cd
                    AND a.event_mod_cd = p_event_mod_cd)
  LOOP
    v_table := a_rec.table_name;
    v_column := a_rec.column_name;
  END LOOP;    
    
  IF p_col_value IS NULL AND v_column IS NOT NULL THEN
     v_validation := v_column||' IS NULL';
  ELSIF p_col_value IS NOT NULL AND v_column IS NOT NULL THEN               
     v_validation := v_column||' = '||''''||p_col_value||'''';
  END IF;

  --get display column
  v_disp_column := NULL;    
  FOR B IN ( SELECT b.rv_meaning, a.dsp_col_id
               FROM cg_ref_codes b,
                    giis_events_display a
              WHERE rv_domain = 'GIIS_DSP_COLUMN.DSP_COL_ID'
                AND rv_low_value = a.dsp_col_id
                AND a.event_col_cd = p_event_col_cd )
  LOOP
      IF v_disp_column IS NULL THEN
           v_disp_column := WF.GET_WORKFLOW_DISP_COLUMN(b.rv_meaning,v_table);
      ELSE
           IF b.rv_meaning IS NOT NULL THEN
              v_disp_column := v_disp_column||'||'' ''||'||WF.GET_WORKFLOW_DISP_COLUMN(b.rv_meaning,v_table);
           END IF;
      END IF;
  END LOOP;    
   
  IF v_disp_column IS NOT NULL AND v_table IS NOT NULL AND v_validation IS NOT NULL THEN
    GENERATE_TRAN_DTL(v_disp_column, v_table, v_validation, p_tran_dtl);
  END IF;           
END;
/


