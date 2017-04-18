DROP PROCEDURE CPI.GET_C20_DTL;

CREATE OR REPLACE PROCEDURE CPI.GET_C20_DTL(
    p_par_id    NUMBER,
    p_policy_id NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT item_no, plate_no, motor_no,
               make, psc_case_no, delete_sw
          FROM gipi_wc20_dtl
         WHERE par_id = p_par_id)
    LOOP
        INSERT
          INTO gipi_c20_dtl
               (policy_id, item_no, plate_no, motor_no, make,
                psc_case_no, delete_sw)
        VALUES (p_policy_id, rec.item_no, rec.plate_no, rec.motor_no, rec.make,
                rec.psc_case_no, rec.delete_sw);
    END LOOP;
END get_c20_dtl;
/


