DROP PROCEDURE CPI.VALIDATE_WCOMM_INVOICE;

CREATE OR REPLACE PROCEDURE CPI.validate_wcomm_invoice(
                       p_par_id         IN  GIPI_PARLIST.par_id%TYPE,
                  p_line_cd         IN  GIPI_PARLIST.line_cd%TYPE,
                  p_subline_cd     IN  GIPI_WPOLBAS.subline_cd%TYPE,
                  p_iss_cd         IN  GIPI_WPOLBAS.iss_cd%TYPE,
                  p_par_type     IN  GIPI_PARLIST.par_type%TYPE,
                  p_msg_alert    OUT VARCHAR2
                       )    
        IS
  X                    NUMBER;
  x2                   NUMBER;
  v_su_line_cd         GIIS_LINE.line_cd%TYPE;
  v_subline_mop           GIPI_WPOLBAS.subline_cd%TYPE := 'MOP';
  v_issue_ri            GIIS_PARAMETERS.param_value_v%TYPE :=  Giisp.v('ISS_CD_RI');
  v_surety_cd           GIIS_PARAMETERS.param_value_v%TYPE;
  v_cargo_cd           GIIS_PARAMETERS.param_value_v%TYPE;
  v_affecting           VARCHAR2(1);
  v_item_grp           VARCHAR2(200);
  v_item_cnt           NUMBER := 0;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_wcomm_invoice program unit
  */
  BEGIN
    SELECT a.param_value_v, b.param_value_v
      INTO v_surety_cd, v_cargo_cd 
      FROM GIIS_PARAMETERS a,GIIS_PARAMETERS b
     WHERE a.param_name = 'LINE_CODE_SU'
       AND b.param_name = 'LINE_CODE_MN';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
  END;
  
IF p_iss_cd  != NVL(v_issue_ri,'&&') AND
   p_line_cd  != v_cargo_cd  AND
   p_subline_cd != v_subline_mop THEN

  IF p_par_type = 'E' THEN
     BEGIN
      FOR A IN ( SELECT 1
         FROM GIPI_WINVOICE
        WHERE par_id = p_par_id) LOOP
         v_affecting  := 'A';
      END LOOP;
     END;
      IF v_affecting IS NULL THEN
            v_affecting := 'N';
      END IF;
  END IF;

  IF (p_par_type = 'P') 
     OR (NVL(v_affecting,'N') = 'A') THEN  
     /*IF :gauge.process= 'Y' THEN
        :gauge.FILE := 'Validating Commission Information...';
     ELSE
        :gauge.FILE := 'passing validate policy Commission INFO';
     END IF;
     vbx_counter;*/
 

--BETH 12/11/98 validate if Invoice Commission had been entered for all item grp.
   /*FOR su IN (
     SELECT param_value_v 
       FROM giis_parameters
      WHERE param_name = 'LINE_CODE_SU')
   LOOP*/
     v_su_line_cd := v_surety_cd;
   --END LOOP;

   FOR COMM_CUR IN (SELECT item_grp
                      FROM GIPI_WINVOICE
                     WHERE par_id = p_par_id) LOOP
       SELECT COUNT(*)
         INTO X
         FROM GIPI_WCOMM_INVOICES
        WHERE par_id  = p_par_id
          AND item_grp = comm_cur.item_grp;
       IF p_line_cd != v_su_line_cd THEN
         IF X >= 1 THEN
            SELECT COUNT(*)
            INTO x2
            FROM GIPI_WCOMM_INV_PERILS
           WHERE par_id  = p_par_id
             AND item_grp = comm_cur.item_grp;
            IF X2 < 1 THEN
            /*Modified by: Gzelle 05.13.2014 Batch Posting different message for single/multiple items*/  
              v_item_cnt := v_item_cnt + 1;
              v_item_grp := v_item_grp||TO_CHAR(comm_cur.item_grp) ||', ';
              IF v_item_cnt > 1 
              THEN 
                p_msg_alert := 'Commission Peril Information for the following Item Groups are needed: '||SUBSTR(v_item_grp,1,INSTR(v_item_grp,',',-1)-1)||'.';
              ELSE
                p_msg_alert := 'Commission Peril Information for Item Group '||SUBSTR(v_item_grp,1,INSTR(v_item_grp,',',-1)-1)||' is needed.';
              END IF;  
              --:gauge.FILE:='Commission Peril Information is needed.';
              --error_rtn;
            END IF;        
         ELSE 
         /*Modified by: Gzelle 05.13.2014 Batch Posting different message for single/multiple items*/
           v_item_cnt := v_item_cnt + 1;
           v_item_grp := v_item_grp||TO_CHAR(comm_cur.item_grp) ||', ';
           --p_msg_alert := 'Commission Information for Item Group '||TO_CHAR(comm_cur.item_grp)||' is needed.';
           IF v_item_cnt > 1 
           THEN 
            p_msg_alert := 'Commission Information for the following Item Groups are needed: '||SUBSTR(v_item_grp,1,INSTR(v_item_grp,',',-1)-1)||'.';
           ELSE
            p_msg_alert := 'Commission Information for Item Group '||SUBSTR(v_item_grp,1,INSTR(v_item_grp,',',-1)-1)||' is needed.';
           END IF;           
           --:gauge.FILE:='Commission Information is needed.';
           --error_rtn;
         END IF;
       END IF;
   END LOOP;


   END IF;
ELSE
NULL;
END IF;
END;
/


