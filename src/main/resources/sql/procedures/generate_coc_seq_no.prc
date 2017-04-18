DROP PROCEDURE CPI.GENERATE_COC_SEQ_NO;

CREATE OR REPLACE PROCEDURE CPI.GENERATE_COC_SEQ_NO(
    p_policy_id      IN     NUMBER,
    p_item_no        IN     NUMBER,
    p_coc_type       IN OUT VARCHAR2,   
    p_coc_serial_no  IN OUT NUMBER,
    p_coc_seq_no     IN OUT NUMBER,
    p_coc_yy         IN     NUMBER
)
IS
/* If GIPI_VEHCILE.COC_TYPE = 'LTO', the system must generate GIPI_VEHICLE.coc_serial_no
** and set GIPI_VEHILCE.coc_yy to the system year.
** NLTO COC number = COC_SEQ_NO || COC_YY while LTO_COC number=COC_SERIAL_NO||COC_YY
*/
      v_exist     NUMBER;
      v_seq_no    number;
      v_check     varchar2(1) := 'N';
      v_ctpl      varchar2(5);
      v_line_cd   varchar2(2);
      v_lto       varchar2(9);
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : GENERATE_COC_SEQ_NO program unit 
  */
    FOR A1 IN (
       SELECT   a.param_value_v  param_a,
                b.param_value_v  param_b,
                c.param_value_v  param_c
         FROM   giis_parameters A,giis_parameters B,
                giis_parameters C
        WHERE   a.param_name = 'COMPULSORY DEATH/BI'
          AND   b.param_name = 'MOTOR CAR LINE CODE'
          AND   c.param_name = 'LAND TRANS. OFFICE') LOOP
          v_ctpl    :=  A1.param_a;
          v_line_cd :=  A1.param_b;
          v_lto     :=  A1.param_c;
          EXIT;
    END LOOP;
    FOR C1 IN (
        SELECT   1
         FROM   gipi_itmperil a, giis_peril b
        WHERE   a.policy_id = p_policy_id
          AND   a.item_no = p_item_no
          AND   a.peril_cd = b.peril_cd
          AND   b.peril_sname = v_ctpl) 
    LOOP
       v_check  :=  'Y';
       EXIT;
    END LOOP;
    FOR D IN (
     SELECT   coc_seq_no, rowid
       FROM   giis_coc_seq
      WHERE   coc_yy     =    p_coc_yy
              FOR UPDATE of coc_seq_no) 
      LOOP
               v_seq_no  :=  D.coc_seq_no + 1;
               v_exist   :=  1;
                UPDATE   giis_coc_seq
                   SET   coc_seq_no = v_seq_no
                 WHERE   rowid  =  D.rowid;
                EXIT;
      END LOOP;
    IF p_coc_type = v_lto then
        p_coc_serial_no := v_seq_no;
    ELSE   
        p_coc_seq_no := v_seq_no;
    END IF;
    IF v_exist IS NULL THEN
      IF v_check = 'Y' then
          INSERT INTO giis_coc_seq (coc_yy, coc_seq_no)
                  VALUES (p_coc_yy, 1);
          IF p_coc_type = v_lto then
              p_coc_serial_no := v_seq_no;
          ELSE   
              p_coc_seq_no := v_seq_no;
          END IF;
      END IF;
    END IF;
END;
/


