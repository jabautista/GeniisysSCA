CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wbeneficiary_Pkg
AS

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.11.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Beneficiary)
    **  Description     :Get PAR record listing for BENEFICIARY
    */
  FUNCTION get_gipi_wbeneficiary (p_par_id GIPI_WBENEFICIARY.par_id%TYPE)
    RETURN gipi_wbeneficiary_tab PIPELINED IS
    v_ben      gipi_wbeneficiary_type;
  BEGIN
    FOR i IN (SELECT a.par_id,                a.item_no,                a.beneficiary_no,
                        a.beneficiary_name,    a.beneficiary_addr,        a.delete_sw,
                     a.relation,            a.remarks,                a.adult_sw,
                     a.age,                    a.civil_status,            a.date_of_birth,
                     a.position_cd,            a.sex
                     FROM GIPI_WBENEFICIARY a
               WHERE a.par_id = p_par_id)
      LOOP
      v_ben.par_id                     := i.par_id;
      v_ben.item_no                := i.item_no;
      v_ben.beneficiary_no          := i.beneficiary_no;
      v_ben.beneficiary_name      := i.beneficiary_name;
      v_ben.beneficiary_addr      := i.beneficiary_addr;
      v_ben.delete_sw              := i.delete_sw;
      v_ben.relation              := i.relation;
      v_ben.remarks                  := i.remarks;
      v_ben.adult_sw              := i.adult_sw;
      v_ben.age                      := i.age;
      v_ben.civil_status          := i.civil_status;
      v_ben.date_of_birth          := i.date_of_birth;
      v_ben.position_cd              := i.position_cd;
      v_ben.sex                      := i.sex;
      PIPE ROW(v_ben);
    END LOOP;
    RETURN;
  END get_gipi_wbeneficiary;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.12.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Beneficiary)
    **  Description     : Insert PAR record listing for BENEFICIARY
    */
  Procedure set_gipi_wbeneficiary(
              p_par_id                   GIPI_WBENEFICIARY.par_id%TYPE,
               p_item_no                  GIPI_WBENEFICIARY.item_no%TYPE,
               p_beneficiary_no          GIPI_WBENEFICIARY.beneficiary_no%TYPE,
               p_beneficiary_name          GIPI_WBENEFICIARY.beneficiary_name%TYPE,
               p_beneficiary_addr          GIPI_WBENEFICIARY.beneficiary_addr%TYPE,
            p_relation                  GIPI_WBENEFICIARY.relation%TYPE,
            p_date_of_birth                GIPI_WBENEFICIARY.date_of_birth%TYPE,
            p_age                      GIPI_WBENEFICIARY.age%TYPE,
               p_remarks                  GIPI_WBENEFICIARY.remarks%TYPE
            )
        IS
  BEGIN
      MERGE INTO GIPI_WBENEFICIARY
        USING dual ON (par_id       = p_par_id
                    AND item_no   = p_item_no
                    AND beneficiary_no = p_beneficiary_no)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                       item_no,                beneficiary_no,
                       beneficiary_name,        beneficiary_addr,      relation,
                    date_of_birth,            age,                  remarks
                   )
            VALUES (p_par_id,                   p_item_no,                p_beneficiary_no,
                       p_beneficiary_name,        p_beneficiary_addr,      p_relation,
                    p_date_of_birth,        p_age,                  p_remarks
                   )
        WHEN MATCHED THEN
            UPDATE SET
                   beneficiary_name            = p_beneficiary_name,
                   beneficiary_addr            = p_beneficiary_addr,
                   relation                    = p_relation,
                   date_of_birth            = p_date_of_birth,
                   age                        = p_age,
                   remarks                    = p_remarks;
  END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.12.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Beneficiary)
    **  Description     : Delete PAR record listing for BENEFICIARY
    */
    Procedure del_gipi_wbeneficiary(p_par_id    GIPI_WBENEFICIARY.par_id%TYPE,
                                      p_item_no   GIPI_WBENEFICIARY.item_no%TYPE)
            IS
  BEGIN
    DELETE GIPI_WBENEFICIARY
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no;
  END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.12.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Beneficiary)
    **  Description     : Delete PAR record listing for BENEFICIARY
    */
  Procedure del_gipi_wbeneficiary2(p_par_id           GIPI_WBENEFICIARY.par_id%TYPE,
                                     p_item_no          GIPI_WBENEFICIARY.item_no%TYPE,
                                   p_beneficiary_no      GIPI_WBENEFICIARY.beneficiary_no%TYPE)
            IS
  BEGIN
    DELETE GIPI_WBENEFICIARY
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND beneficiary_no = p_beneficiary_no;
  END;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id
    */
    Procedure del_gipi_wbeneficiary (p_par_id IN GIPI_WBENEFICIARY.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WBENEFICIARY
         WHERE par_id = p_par_id;
    END del_gipi_wbeneficiary;

    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    09.29.2011    mark jm            retrieve records on gipi_wbeneficiary based on given parameters (tablegrid varsion)
    **    09.30.2011    mark jm            modified sql stmt by adding nvl to table columns used in filtering
    */
    FUNCTION get_gipi_wbeneficiary_tg (
        p_par_id IN gipi_wbeneficiary.par_id%TYPE,
        p_item_no IN gipi_wbeneficiary.item_no%TYPE,
        p_beneficiary_name IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_wbeneficiary_tab PIPELINED
    IS
        v_ben gipi_wbeneficiary_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,                a.beneficiary_no,
                   a.beneficiary_name,    a.beneficiary_addr,        a.delete_sw,
                   a.relation,            a.remarks,                a.adult_sw,
                   a.age,                a.civil_status,            a.date_of_birth,
                   a.position_cd,        a.sex
              FROM gipi_wbeneficiary a
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND UPPER(NVL(a.beneficiary_name, '***')) LIKE UPPER(NVL(p_beneficiary_name, '%%'))
               AND UPPER(NVL(a.remarks, '***')) LIKE UPPER(NVL(p_remarks, '%%%')))
        LOOP
            v_ben.par_id            := i.par_id;
            v_ben.item_no            := i.item_no;
            v_ben.beneficiary_no    := i.beneficiary_no;
            v_ben.beneficiary_name    := i.beneficiary_name;
            v_ben.beneficiary_addr    := i.beneficiary_addr;
            v_ben.delete_sw            := i.delete_sw;
            v_ben.relation            := i.relation;
            v_ben.remarks            := i.remarks;
            v_ben.adult_sw            := i.adult_sw;
            v_ben.age                := i.age;
            v_ben.civil_status        := i.civil_status;
            v_ben.date_of_birth        := i.date_of_birth;
            v_ben.position_cd        := i.position_cd;
            v_ben.sex                := i.sex;

            PIPE ROW(v_ben);
        END LOOP;
        RETURN;
    END get_gipi_wbeneficiary_tg;
END;
/


