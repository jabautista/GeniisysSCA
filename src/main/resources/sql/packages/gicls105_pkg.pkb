CREATE OR REPLACE PACKAGE BODY CPI.GICLS105_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   10.23.2013
     ** Referenced By:  GICLS105 - Loss Category Maintenance
     **/
     
    FUNCTION get_rec_list (
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type,
        p_loss_cat_des    GIIS_LOSS_CTGRY.LOSS_CAT_DES%type,
        p_total_tag       GIIS_LOSS_CTGRY.TOTAL_TAG%type
    ) RETURN rec_tab PIPELINED
    AS
        v_rec   rec_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIIS_LOSS_CTGRY
                  WHERE UPPER(line_cd) = UPPER(p_line_cd)
                    AND UPPER(loss_cat_cd) LIKE UPPER(NVL(p_loss_cat_cd, '%'))
                    AND UPPER(loss_cat_des) LIKE UPPER(NVL(p_loss_cat_des, '%'))
                    AND UPPER(NVL(total_tag, 'N')) LIKE UPPER(NVL(p_total_tag, NVL(total_tag, 'N')))
                  ORDER BY loss_cat_cd)
        LOOP
            v_rec.line_cd           := i.line_cd;
            v_rec.loss_cat_cd       := i.loss_cat_cd;
            v_rec.loss_cat_desc     := i.loss_cat_des;
            v_rec.loss_cat_group    := i.loss_cat_group;
            v_rec.total_tag         := i.total_tag;
            v_rec.peril_cd          := i.peril_cd;
            v_rec.remarks           := i.remarks;
            v_rec.user_id           := i.user_id;
            v_rec.last_update       := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            v_rec.peril_name        := NULL;
            
            FOR j IN (SELECT peril_name
	                    FROM giis_peril
	                   WHERE line_cd = i.line_cd
	                     AND peril_cd = i.peril_cd)
            LOOP
                 v_rec.peril_name := j.peril_name;
            END LOOP;
                         
            PIPE ROW (v_rec);
        END LOOP;
    END get_rec_list;


    PROCEDURE set_rec (p_rec GIIS_LOSS_CTGRY%ROWTYPE)
    AS    
    BEGIN
        MERGE INTO GIIS_LOSS_CTGRY
         USING DUAL
         ON (line_cd = p_rec.line_cd
             AND loss_cat_cd = p_rec.loss_cat_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, loss_cat_cd, loss_cat_des, total_tag, peril_cd, remarks, user_id, last_update)
            VALUES (p_rec.line_cd, p_rec.loss_cat_cd, p_rec.loss_cat_des, p_rec.total_tag, p_rec.peril_cd, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET loss_cat_des = p_rec.loss_cat_des,
                   total_tag = p_rec.total_tag,
                   peril_cd = p_rec.peril_cd, 
                   remarks = p_rec.remarks, 
				   user_id = p_rec.user_id, 
				   last_update = SYSDATE;
    END set_rec;

    PROCEDURE del_rec (
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    )
    AS    
    BEGIN
        DELETE FROM GIIS_LOSS_CTGRY
         WHERE line_cd = p_line_cd
           AND loss_cat_cd = p_loss_cat_cd;
    END del_rec;

    PROCEDURE val_del_rec (
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    )
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
      NULL;    
    END val_del_rec;
       
    PROCEDURE val_add_rec(
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    )
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_LOSS_CTGRY a
                   WHERE a.line_cd = p_line_cd
                     AND a.loss_cat_cd = p_loss_cat_cd)
        LOOP
        v_exists := 'Y';
        EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Record already exists with the same loss_cat_cd.'
                                    );
        END IF;
    END val_add_rec;

END GICLS105_PKG;
/


