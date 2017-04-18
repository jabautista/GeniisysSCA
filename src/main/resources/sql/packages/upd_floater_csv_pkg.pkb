CREATE OR REPLACE PACKAGE BODY CPI.upd_floater_csv_pkg
AS
  PROCEDURE split_itmfloater (
    line_to_split            IN       VARCHAR2,
    record_no                OUT      NUMBER,
    item_no                  OUT      NUMBER,
    item_title               OUT      VARCHAR2,
    currency_cd              OUT      NUMBER,
    currency_rt              OUT      NUMBER,
    item_desc                OUT      VARCHAR2,
    item_desc2               OUT      VARCHAR2,
    location_cd              OUT      NUMBER,
    region_cd                OUT      NUMBER,
    LOCATION                 OUT      VARCHAR2,
    limit_of_liability       OUT      VARCHAR2,
    interest_on_premises     OUT      VARCHAR2,
    section_or_hazard_info   OUT      VARCHAR2,
    conveyance_info          OUT      VARCHAR2,
    property_no_type         OUT      VARCHAR2,
    property_no              OUT      VARCHAR2,
    ded_deductible_cd        OUT      VARCHAR2
  )
  IS
    v_line_to_split   VARCHAR2 (20000);
    v_pos             NUMBER;
    v_posq            NUMBER;
  BEGIN
    v_line_to_split := line_to_split;

    FOR i IN 1 .. 17
    LOOP
      v_pos := INSTR (v_line_to_split, ',');

      IF i = 1
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            record_no := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              record_no := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              record_no := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('record_no');
        END;
      ELSIF i = 2
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_no := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_no := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_no := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_no');
        END;
      ELSIF i = 3
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_title := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_title := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_title := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_title');
        END;
      ELSIF i = 4
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            currency_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              currency_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              currency_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('currency_cd');
        END;
      ELSIF i = 5
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            currency_rt := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              currency_rt :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              currency_rt :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('currency_rt');
        END;
      ELSIF i = 6
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_desc := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_desc := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_desc := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_desc');
        END;
      ELSIF i = 7
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_desc2 := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_desc2 := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_desc2 := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_desc2');
        END;
      ELSIF i = 8
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            location_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              location_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              location_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('location_cd');
        END;
      ELSIF i = 9
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            region_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              region_cd := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              region_cd := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('region_cd');
        END;
      ELSIF i = 10
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            LOCATION := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              LOCATION := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              LOCATION := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('location');
        END;
      ELSIF i = 11
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            limit_of_liability := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              limit_of_liability := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              limit_of_liability := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('limit_of_liability');
        END;
      ELSIF i = 12
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            interest_on_premises := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              interest_on_premises := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              interest_on_premises := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('interest_on_premises');
        END;
      ELSIF i = 13
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            section_or_hazard_info := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              section_or_hazard_info :=
                                       SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              section_or_hazard_info :=
                                       SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('section_or_hazard_info');
        END;
      ELSIF i = 14
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            conveyance_info := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              conveyance_info := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              conveyance_info := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('conveyance_info');
        END;
      ELSIF i = 15
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            property_no_type := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              property_no_type := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              property_no_type := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('property_no_type');
        END;
      ELSIF i = 16
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            property_no := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              property_no := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              property_no := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('property_no');
        END;
      ELSIF i = 17
      THEN
        BEGIN
          IF SUBSTR (v_line_to_split, 1, 1) = '"'
          THEN
            DECLARE
              v_chardummy   VARCHAR2 (20000);
            BEGIN
              v_chardummy := v_line_to_split;

              FOR i IN 1 .. 2
              LOOP
                v_posq := INSTR (v_chardummy, '"');
                v_chardummy := SUBSTR (v_chardummy, 2);
              END LOOP;
            END;

            ded_deductible_cd := SUBSTR (v_line_to_split, 2, v_posq - 1);
          ELSE
            ded_deductible_cd := v_line_to_split;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('ded_deductible_cd');
        END;
      END IF;
    END LOOP;
  END split_itmfloater;

  PROCEDURE split_perlfloater (
    line_to_split            IN       VARCHAR2,
    record_no                OUT      NUMBER,
    item_no                  OUT      NUMBER,
    item_title               OUT      VARCHAR2,
    currency_cd              OUT      NUMBER,
    currency_rt              OUT      NUMBER,
    item_desc                OUT      VARCHAR2,
    item_desc2               OUT      VARCHAR2,
    location_cd              OUT      NUMBER,
    region_cd                OUT      NUMBER,
    LOCATION                 OUT      VARCHAR2,
    limit_of_liability       OUT      VARCHAR2,
    interest_on_premises     OUT      VARCHAR2,
    section_or_hazard_info   OUT      VARCHAR2,
    conveyance_info          OUT      VARCHAR2,
    property_no_type         OUT      VARCHAR2,
    property_no              OUT      VARCHAR2,
    peril_cd                 OUT      NUMBER,
    prem_rt                  OUT      NUMBER,
    tsi_amt                  OUT      NUMBER,
    prem_amt                 OUT      NUMBER,
    aggregate_sw             OUT      VARCHAR2,
    ri_comm_rate             OUT      NUMBER,
    ri_comm_amt              OUT      NUMBER,
    ded_deductible_cd        OUT      VARCHAR2
  )
  IS
    v_line_to_split   VARCHAR2 (20000);
    v_pos             NUMBER;
    v_posq            NUMBER;
  BEGIN
    v_line_to_split := line_to_split;

    FOR i IN 1 .. 24
    LOOP
      v_pos := INSTR (v_line_to_split, ',');

      IF i = 1
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            record_no := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              record_no := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              record_no := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('record_no');
        END;
      ELSIF i = 2
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_no := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_no := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_no := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_no');
        END;
      ELSIF i = 3
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_title := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_title := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_title := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_title');
        END;
      ELSIF i = 4
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            currency_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              currency_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              currency_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('currency_cd');
        END;
      ELSIF i = 5
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            currency_rt := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              currency_rt :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              currency_rt :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('currency_rt');
        END;
      ELSIF i = 6
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_desc := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_desc := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_desc := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_desc');
        END;
      ELSIF i = 7
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            item_desc2 := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              item_desc2 := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              item_desc2 := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('item_desc2');
        END;
      ELSIF i = 8
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            location_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              location_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              location_cd :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('location_cd');
        END;
      ELSIF i = 9
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            region_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              region_cd := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              region_cd := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('region_cd');
        END;
      ELSIF i = 10
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            LOCATION := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              LOCATION := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              LOCATION := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('location');
        END;
      ELSIF i = 11
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            limit_of_liability := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              limit_of_liability := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              limit_of_liability := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('limit_of_liability');
        END;
      ELSIF i = 12
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            interest_on_premises := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              interest_on_premises := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              interest_on_premises := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('interest_on_premises');
        END;
      ELSIF i = 13
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            section_or_hazard_info := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              section_or_hazard_info :=
                                       SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              section_or_hazard_info :=
                                       SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('section_or_hazard_info');
        END;
      ELSIF i = 14
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            conveyance_info := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              conveyance_info := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              conveyance_info := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('conveyance_info');
        END;
      ELSIF i = 15
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            property_no_type := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              property_no_type := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              property_no_type := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('property_no_type');
        END;
      ELSIF i = 16
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            property_no := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              property_no := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              property_no := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('property_no');
        END;
      ELSIF i = 17
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            peril_cd := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              peril_cd := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              peril_cd := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('peril_cd');
        END;
      ELSIF i = 18
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            prem_rt := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              prem_rt := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              prem_rt := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('prem_rt');
        END;
      ELSIF i = 19
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            tsi_amt := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              tsi_amt := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              tsi_amt := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('tsi_amt');
        END;
      ELSIF i = 20
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            prem_amt := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              prem_amt := TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              prem_amt := TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('prem_amt');
        END;
      ELSIF i = 21
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            aggregate_sw := v_line_to_split;
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              aggregate_sw := SUBSTR (v_line_to_split, 2, v_posq - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              aggregate_sw := SUBSTR (v_line_to_split, 1, v_pos - 1);
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('aggregate_sw');
        END;
      ELSIF i = 22
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            ri_comm_rate := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              ri_comm_rate :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              ri_comm_rate :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('ri_comm_rate');
        END;
      ELSIF i = 23
      THEN
        BEGIN
          IF v_pos = 0
          THEN
            ri_comm_amt := TO_NUMBER (v_line_to_split);
            v_line_to_split := NULL;
          ELSE
            IF SUBSTR (v_line_to_split, 1, 1) = '"'
            THEN
              DECLARE
                v_chardummy   VARCHAR2 (20000);
              BEGIN
                v_chardummy := v_line_to_split;

                FOR i IN 1 .. 2
                LOOP
                  v_posq := INSTR (v_chardummy, '"');
                  v_chardummy := SUBSTR (v_chardummy, 2);
                END LOOP;
              END;

              ri_comm_amt :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 2, v_posq - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_posq + 3);
            ELSE
              ri_comm_amt :=
                           TO_NUMBER (SUBSTR (v_line_to_split, 1, v_pos - 1));
              v_line_to_split := SUBSTR (v_line_to_split, v_pos + 1);
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('ri_comm_amt');
        END;
      ELSIF i = 24
      THEN
        BEGIN
          IF SUBSTR (v_line_to_split, 1, 1) = '"'
          THEN
            DECLARE
              v_chardummy   VARCHAR2 (20000);
            BEGIN
              v_chardummy := v_line_to_split;

              FOR i IN 1 .. 2
              LOOP
                v_posq := INSTR (v_chardummy, '"');
                v_chardummy := SUBSTR (v_chardummy, 2);
              END LOOP;
            END;

            ded_deductible_cd := SUBSTR (v_line_to_split, 2, v_posq - 1);
          ELSE
            ded_deductible_cd := v_line_to_split;
          END IF;
        EXCEPTION
          WHEN OTHERS
          THEN
            DBMS_OUTPUT.put_line ('ded_deductible_cd');
        END;
      END IF;
    END LOOP;
  END split_perlfloater;

  PROCEDURE upd_floater_peril (
    p_filename      IN       VARCHAR2,
    p_par_id        IN       NUMBER,
    p_line_cd       IN       VARCHAR2,
    p_subline_cd    IN       VARCHAR2,
    p_upload_no     IN       NUMBER,
    upload_ctr      OUT      NUMBER,
    total_rec       OUT      NUMBER,
    duplicate_ctr   OUT      NUMBER,
    p_message       OUT      VARCHAR2
  )
  IS
    v_upload_chk               BOOLEAN           := FALSE;
    -- to check if the file has already been uloaded
    v_witem_chk                BOOLEAN           := FALSE;
    -- to check if record already existsin gipi_witem table
    v_wcasu_chk                BOOLEAN           := FALSE;
    -- to check if record already exists in gipi_wcasulaty_item table
    v_witmperl_chk             BOOLEAN           := FALSE;
    -- to check if record already exists in gipi_witmperl table
    v_wdedu_chk                BOOLEAN           := FALSE;
    -- to check if record already exists in gipi_wdeductibles table
    v_perl_type_ok             BOOLEAN           := FALSE;
    -- to check if BASIC peril is present if first peril is ALLIED
    v_duplicate_chk            BOOLEAN           := FALSE;
    -- to check if error for item is already logged in gipi_ca_error_log
    v_remarks                  VARCHAR2 (2000);
    -- remarks to be inserted in gipi_ca_error_log
    v_orig_item                BOOLEAN           := FALSE;
    -- to check if same item with different deductible or peril
    v_orig_peril               BOOLEAN           := FALSE;
    -- to check if same peril with different deductible
    v_dedu_notnull             BOOLEAN           := FALSE;
    -- to check if deductible is present to be inserted in gipi_wdeductibles
    v_insert                   BOOLEAN           := FALSE;
    -- to check if deductible is present to be inserted in gipi_wdeductibles
    v_ca_upload                BOOLEAN           := FALSE;
    -- to check if data already inserted in gipi_ca_upload
    v_records                  NUMBER (9);
    --total number of records in the excel file
    v_record_no                NUMBER (9);   --current record number
    v_item_no                  NUMBER (9);
    v_item_title               VARCHAR2 (50);
    v_currency_cd              NUMBER (2);
    v_currency_rt              NUMBER (12, 9);
    v_item_desc                VARCHAR2 (2000);
    v_item_desc2               VARCHAR2 (2000);
    v_location_cd              NUMBER (5);
    v_region_cd                NUMBER (2);
    v_location                 VARCHAR2 (150);
    v_limit_of_liability       VARCHAR2 (500);
    v_interest_on_premises     VARCHAR2 (500);
    v_section_or_hazard_info   VARCHAR2 (2000);
    v_conveyance_info          VARCHAR2 (60);
    v_property_no_type         VARCHAR2 (1);
    v_property_no              VARCHAR2 (30);
    v_peril_cd                 NUMBER (5);
    v_prem_rt                  NUMBER (12, 9);
    v_tsi_amt                  NUMBER (16, 2);
    v_prem_amt                 NUMBER (12, 2);
    v_aggregate_sw             VARCHAR2 (1);
    v_ri_comm_rate             NUMBER (12, 9);
    v_ri_comm_amt              NUMBER (14, 2);
    v_ded_deductible_cd        VARCHAR2 (5);
    v_deductible_text          VARCHAR2 (2000);
    -- variables acquired for insertion in gipi_wdeductibles
    v_deductible_amt           NUMBER (12, 2);
    -- variables acquired for insertion in gipi_wdeductibles
    v_deductible_rt            NUMBER (12, 9);
    -- variables acquired for insertion in gipi_wdeductibles
    status_width               NUMBER;   -- width of the status bar
    err_ctr                    NUMBER            := 0;
    -- counts the records uploaded in GIPI_CA_ERROR_LOG
    record_ctr                 NUMBER            := 0;
    -- counts the records
    var                        gipi_floater_type;
  BEGIN
    upload_ctr := 0;
    -- counts the records uploaded in GIPI_WITEM and GIPI_WCASUALTY_ITEM
    err_ctr := 0;   -- counts the records uploaded in GIPI_CA_ERROR_LOG
    duplicate_ctr := 0;

-- number of duplicate item with errors not inserted in GIPI_CA_ERROR_LOG (PK)
    FOR x IN (SELECT MAX (record_no) no_of_rec
                FROM gipi_perlfloater_csv)
    LOOP
      v_records := x.no_of_rec;
    END LOOP;

    IF v_records LIKE '' OR v_records LIKE ' ' OR v_records IS NULL
    THEN
      p_message := 'No record uploaded. Please doublecheck the csv file.';
    ELSE
      FOR x IN 1 .. v_records
      LOOP
        v_upload_chk := FALSE;   -- (1)
        v_witem_chk := FALSE;   -- (2)
        v_wcasu_chk := FALSE;   -- (3)
        v_witmperl_chk := FALSE;   -- (4)
        v_wdedu_chk := FALSE;   -- (5)
        v_perl_type_ok := FALSE;   -- (6)
        v_duplicate_chk := FALSE;
        -- (7) checks if error is on same item no
        v_remarks := '''Record already exist!''';
        v_orig_item := FALSE;
        -- to check if same item with different deductible or peril
        v_orig_peril := FALSE;
        -- to check if same peril with different deductible
        v_dedu_notnull := FALSE;   -- to check if deductible is present
        v_insert := FALSE;
        record_ctr := record_ctr + 1;

        SELECT item_no, item_title, currency_cd, currency_rt,
               item_desc, item_desc2, region_cd, LOCATION,
               limit_of_liability, interest_on_premises,
               section_or_hazard_info, conveyance_info,
               property_no_type, property_no, peril_cd, prem_rt,
               tsi_amt, prem_amt, aggregate_sw, ri_comm_rate,
               ri_comm_amt, ded_deductible_cd, location_cd
          INTO v_item_no, v_item_title, v_currency_cd, v_currency_rt,
               v_item_desc, v_item_desc2, v_region_cd, v_location,
               v_limit_of_liability, v_interest_on_premises,
               v_section_or_hazard_info, v_conveyance_info,
               v_property_no_type, v_property_no, v_peril_cd, v_prem_rt,
               v_tsi_amt, v_prem_amt, v_aggregate_sw, v_ri_comm_rate,
               v_ri_comm_amt, v_ded_deductible_cd, v_location_cd
          FROM gipi_perlfloater_csv
         WHERE record_no = record_ctr;

        IF v_item_no LIKE '' OR v_item_no LIKE ' ' OR v_item_no IS NULL
        THEN
          v_item_no := var.item_no;
          v_item_title := var.item_title;
          v_currency_cd := var.currency_cd;
          v_currency_rt := var.currency_rt;
          v_item_desc := var.item_desc;
          v_item_desc2 := var.item_desc2;
          v_location_cd := var.location_cd;
          v_region_cd := var.region_cd;
          v_location := var.LOCATION;
          v_limit_of_liability := var.limit_of_liability;
          v_interest_on_premises := var.interest_on_premises;
          v_section_or_hazard_info := var.section_or_hazard_info;
          v_conveyance_info := var.conveyance_info;
          v_property_no_type := var.property_no_type;
          v_property_no := var.property_no;
        ELSE
          v_orig_item := TRUE;
          var.item_no := v_item_no;
          var.item_title := v_item_title;
          var.currency_cd := v_currency_cd;
          var.currency_rt := v_currency_rt;
          var.item_desc := v_item_desc;
          var.item_desc2 := v_item_desc2;
          var.location_cd := v_location_cd;
          var.region_cd := v_region_cd;
          var.LOCATION := v_location;
          var.limit_of_liability := v_limit_of_liability;
          var.interest_on_premises := v_interest_on_premises;
          var.section_or_hazard_info := v_section_or_hazard_info;
          var.conveyance_info := v_conveyance_info;
          var.property_no_type := v_property_no_type;
          var.property_no := v_property_no;
        END IF;

        -- check if record already exist --
        -- must satisfy the following conditions: (primary key issues)
        -- (1) v_upload_check = FALSE  >file should not be uploaded yet
        -- (2) v_item_chk     = FALSE  >item should not be present in gipi_witem table
        -- (3) v_wcasu_chk    = FALSE  >item should not be present in gipi_wcasualty_item
        -- (4) v_witmperl_chk = FALSE  >item should not have duplicate perils
        -- (5) v_wdedu_chk    = FALSE  >peril should not have duplicate deductibles
        -- (6) v_perl_type_ok = TRUE   >basic peril should be added first before an allied

        -- (1)
        FOR v IN (SELECT 1
                    FROM gipi_ca_upload
                   WHERE filename LIKE p_filename AND upload_no = p_upload_no)
        LOOP
          v_upload_chk := TRUE;
        END LOOP;

        -- (2)
        FOR v IN (SELECT 1
                    FROM gipi_witem
                   WHERE item_no = v_item_no AND par_id = p_par_id)
        LOOP
          v_witem_chk := TRUE;
        END LOOP;

        -- (3)
        FOR v IN (SELECT 1
                    FROM gipi_wcasualty_item
                   WHERE item_no = v_item_no AND par_id = p_par_id)
        LOOP
          v_wcasu_chk := TRUE;
        END LOOP;

        -- acquires v_peril_code for referencing in insertion of another deductible.
        IF v_peril_cd LIKE '' OR v_peril_cd LIKE ' ' OR v_peril_cd IS NULL
        THEN
          v_peril_cd := var.peril_cd;
          v_prem_rt := var.prem_rt;
          v_tsi_amt := var.tsi_amt;
          v_prem_amt := var.prem_amt;
          v_aggregate_sw := var.aggregate_sw;
          v_ri_comm_rate := var.ri_comm_rate;
          v_ri_comm_amt := var.ri_comm_amt;
        ELSE
          var.peril_cd := v_peril_cd;
          var.prem_rt := v_prem_rt;
          var.tsi_amt := v_tsi_amt;
          var.prem_amt := v_prem_amt;
          var.aggregate_sw := v_aggregate_sw;
          var.ri_comm_rate := v_ri_comm_rate;
          var.ri_comm_amt := v_ri_comm_amt;
          v_orig_peril := TRUE;
        END IF;

        -- (4)
        FOR v IN (SELECT 1
                    FROM gipi_witmperl
                   WHERE item_no = v_item_no
                     AND par_id = p_par_id
                     AND peril_cd = v_peril_cd
                     --only the peril code will be the basis
                     AND line_cd = p_line_cd)
        LOOP
          v_witmperl_chk := TRUE;
          v_remarks :=
               '''Please doublecheck ALL peril codes in the excel file for item number '
            || v_item_no
            || '.(duplicate peril_cd''s might exist)''';
        END LOOP;

        -- 2 same peril codes with different deductible amounts is not accepted.
        -- the second peril code should be blank as agreed.

        -- (5)
        FOR v IN (SELECT 1
                    FROM gipi_wdeductibles
                   WHERE item_no = v_item_no
                     AND par_id = p_par_id
                     AND peril_cd = v_peril_cd
                     AND ded_line_cd = p_line_cd
                     AND ded_subline_cd = p_subline_cd
                     AND ded_deductible_cd = v_ded_deductible_cd)
        --to check if value is duplicate
        LOOP
          v_wdedu_chk := TRUE;
          v_remarks :=
               '''Please doublecheck ALL the deductible codes in the excel file for item number '
            || v_item_no
            || '. (duplicate deductible_cd might exist)''';
        END LOOP;

        --first get the properties of the deductible in giis_deductible_desc according to
        --the given global parameters and value of deductible_cd retrieved from the excel file.
        FOR z IN (SELECT deductible_amt, line_cd, deductible_text,
                         deductible_rt, subline_cd, deductible_cd
                    FROM giis_deductible_desc
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND deductible_cd = v_ded_deductible_cd)
        LOOP
          v_deductible_text := z.deductible_text;
          v_deductible_amt := z.deductible_amt;
          v_deductible_rt := z.deductible_rt;
          v_dedu_notnull := TRUE;
        END LOOP;

        -- (6)
        FOR x IN (SELECT peril_type
                    FROM giis_peril
                   WHERE peril_cd = v_peril_cd AND line_cd = p_line_cd)
        LOOP
          IF x.peril_type = 'A'
          THEN
            --if allied, will check if record already exist
            --user can only insert basic if no records are found.
            FOR y IN (SELECT 1
                        FROM gipi_witmperl
                       WHERE item_no = v_item_no
                         AND par_id = p_par_id
                         AND peril_cd IS NOT NULL
                         AND peril_cd <> 0)
            LOOP
              v_perl_type_ok := TRUE;
            END LOOP;
          ELSE
            v_perl_type_ok := TRUE;
          END IF;
        END LOOP;

        IF NOT v_ca_upload AND NOT v_upload_chk
        THEN
          INSERT INTO gipi_ca_upload
                      (upload_no,
                       filename,
                       upload_date, user_id, last_update
                      )
               VALUES (p_upload_no,
                       SUBSTR (p_filename, INSTR (p_filename, '\', -1) + 1),
                       SYSDATE, USER, SYSDATE
                      );

          v_ca_upload := TRUE;
        END IF;

        IF     NOT v_witem_chk
           AND NOT v_wcasu_chk
           AND NOT v_wdedu_chk
           AND NOT v_witmperl_chk
           AND v_perl_type_ok
        THEN
          INSERT INTO gipi_witem
                      (par_id, item_no, item_title, currency_cd,
                       currency_rt, item_desc, item_desc2, region_cd
                      )
               VALUES (p_par_id, v_item_no, v_item_title, v_currency_cd,
                       v_currency_rt, v_item_desc, v_item_desc2, v_region_cd
                      );

          INSERT INTO gipi_wcasualty_item
                      (par_id, item_no, location_cd, LOCATION,
                       limit_of_liability, interest_on_premises,
                       section_or_hazard_info, conveyance_info,
                       property_no_type, property_no
                      )
               VALUES (p_par_id, v_item_no, v_location_cd, v_location,
                       v_limit_of_liability, v_interest_on_premises,
                       v_section_or_hazard_info, v_conveyance_info,
                       v_property_no_type, v_property_no
                      );

          v_insert := TRUE;
        END IF;

        --check if the peril is only a duplicate for a different deductible
        IF NOT v_witmperl_chk AND v_perl_type_ok
        THEN
          INSERT INTO gipi_witmperl
                      (par_id, item_no, line_cd, peril_cd,
                       prem_rt, tsi_amt, prem_amt, aggregate_sw,
                       ri_comm_rate, ri_comm_amt
                      )
               VALUES (p_par_id, v_item_no, p_line_cd, v_peril_cd,
                       v_prem_rt, v_tsi_amt, v_prem_amt, v_aggregate_sw,
                       v_ri_comm_rate, v_ri_comm_amt
                      );

          v_insert := TRUE;
        END IF;

        --check if there is a deductible for the specified record:
        --if true, insert record into GIPI_WDEDUCTIBLES:
        IF     NOT v_witmperl_chk
           AND v_perl_type_ok
           AND v_dedu_notnull
           AND NOT v_wdedu_chk
        THEN
          INSERT INTO gipi_wdeductibles
                      (par_id, item_no, peril_cd, ded_line_cd,
                       ded_subline_cd, ded_deductible_cd, deductible_text,
                       deductible_amt, deductible_rt
                      )
               VALUES (p_par_id, v_item_no, v_peril_cd, p_line_cd,
                       p_subline_cd, v_ded_deductible_cd, v_deductible_text,
                       v_deductible_amt, v_deductible_rt
                      );

          v_insert := TRUE;
        END IF;

        IF v_insert
        THEN
          upload_ctr := upload_ctr + 1;
        ELSE
          FOR x IN (SELECT upload_no, filename, item_no
                      FROM gipi_ca_error_log
                     WHERE upload_no = p_upload_no
                       AND filename = p_filename
                       AND item_no = v_item_no)
          LOOP
            v_duplicate_chk := TRUE;
          --checks if an error is already logged for the same item.
          END LOOP;

          IF NOT v_perl_type_ok
          THEN
            v_remarks :=
                 'Please doublecheck peril code for item '
              || v_item_no
              || ' (BASIC should be added before ALLIED / peril code should be valid).';
          END IF;

          IF v_duplicate_chk
          THEN
            duplicate_ctr := duplicate_ctr + 1;
          ELSE
            INSERT INTO gipi_ca_error_log
                        (upload_no, filename, item_no, item_title,
                         currency_cd, currency_rt, item_desc,
                         item_desc2, location_cd, region_cd,
                         LOCATION, limit_of_liability,
                         interest_on_premises, section_or_hazard_info,
                         conveyance_info, property_no_type,
                         property_no, ded_deductible_cd, user_id,
                         date_uploaded, remarks
                        )
                 VALUES (p_upload_no, p_filename, v_item_no, v_item_title,
                         v_currency_cd, v_currency_rt, v_item_desc,
                         v_item_desc2, v_location_cd, v_region_cd,
                         v_location, v_limit_of_liability,
                         v_interest_on_premises, v_section_or_hazard_info,
                         v_conveyance_info, v_property_no_type,
                         v_property_no, v_ded_deductible_cd, USER,
                         SYSDATE, v_remarks
                        );

            err_ctr := err_ctr + 1;
          END IF;
        END IF;

        total_rec := duplicate_ctr + err_ctr + upload_ctr;
      END LOOP;

      p_message :=
          'Duplicate records not recorded in the error log: ' || duplicate_ctr;

      DELETE FROM gipi_perlfloater_csv
            WHERE upload_no = p_upload_no;

      COMMIT;
      upd_gipi_witem_tab (p_par_id);
    END IF;
  END upd_floater_peril;

  PROCEDURE upd_floater_item (
    p_filename      IN       VARCHAR2,
    p_par_id        IN       NUMBER,
    p_line_cd       IN       VARCHAR2,
    p_subline_cd    IN       VARCHAR2,
    p_upload_no     IN       NUMBER,
    upload_ctr      OUT      NUMBER,
    total_rec       OUT      NUMBER,
    duplicate_ctr   OUT      NUMBER,
    p_message       OUT      VARCHAR2
  )
  IS
    v_upload_chk               BOOLEAN           := FALSE;
    -- to check if the file has already been uloaded
    v_witem_chk                BOOLEAN           := FALSE;
    -- to check if record already existsin gipi_witem table
    v_wcasu_chk                BOOLEAN           := FALSE;
    -- to check if record already exists in gipi_wcasulaty_item table
    v_wdedu_chk                BOOLEAN           := FALSE;
    -- to check if record already exists in gipi_wdeductibles table
    v_duplicate_chk            BOOLEAN           := FALSE;
    -- to check if error for item is already logged in gipi_ca_error_log
    v_remarks                  VARCHAR2 (2000);
    -- remarks to be inserted in gipi_ca_error_log
    v_orig_item                BOOLEAN           := FALSE;
    -- to check if same item with different deductible or peril
    v_dedu_notnull             BOOLEAN           := FALSE;
    -- to check if deductible is present to be inserted in gipi_wdeductibles
    v_insert                   BOOLEAN           := FALSE;
    -- to check if deductible is present to be inserted in gipi_wdeductibles
    v_ca_upload                BOOLEAN           := FALSE;
    -- to check if record is already inserted in gipi_ca_upload
    v_records                  NUMBER (9);
    --total number of records in the excel file
    v_record_no                NUMBER (9);   --current record number
    v_item_no                  NUMBER (9);
    v_item_title               VARCHAR2 (50);
    v_currency_cd              NUMBER (2);
    v_currency_rt              NUMBER (12, 9);
    v_item_desc                VARCHAR2 (2000);
    v_item_desc2               VARCHAR2 (2000);
    v_location_cd              NUMBER (5);
    v_region_cd                NUMBER (2);
    v_location                 VARCHAR2 (150);
    v_limit_of_liability       VARCHAR2 (500);
    v_interest_on_premises     VARCHAR2 (500);
    v_section_or_hazard_info   VARCHAR2 (2000);
    v_conveyance_info          VARCHAR2 (60);
    v_property_no_type         VARCHAR2 (1);
    v_property_no              VARCHAR2 (30);
    v_ded_deductible_cd        VARCHAR2 (5);
    v_deductible_text          VARCHAR2 (2000);
    -- variables acquired for insertion in gipi_wdeductibles
    v_deductible_amt           NUMBER (12, 2);
    -- variables acquired for insertion in gipi_wdeductibles
    v_deductible_rt            NUMBER (12, 9);
    -- variables acquired for insertion in gipi_wdeductibles
    status_width               NUMBER;   -- width of the status bar
    err_ctr                    NUMBER            := 0;
    -- counts the records uploaded in GIPI_CA_ERROR_LOG
    record_ctr                 NUMBER            := 0;
    -- counts the records
    var                        gipi_floater_type;
  BEGIN
    upload_ctr := 0;
    -- counts the records uploaded in GIPI_WITEM and GIPI_WCASUALTY_ITEM
    err_ctr := 0;   -- counts the records uploaded in GIPI_CA_ERROR_LOG
    duplicate_ctr := 0;

-- number of duplicate item with errors not inserted in GIPI_CA_ERROR_LOG (PK)
    FOR x IN (SELECT MAX (record_no) no_of_rec
                FROM gipi_itmfloater_csv)
    LOOP
      v_records := x.no_of_rec;
    END LOOP;

    IF v_records LIKE '' OR v_records LIKE ' ' OR v_records IS NULL
    THEN
      p_message := 'No record uploaded. Please doublecheck the csv file.';
    ELSE
      FOR x IN 1 .. v_records
      LOOP
        v_upload_chk := FALSE;   -- (1)
        v_witem_chk := FALSE;    -- (2)
        v_wcasu_chk := FALSE;    -- (3)
        v_wdedu_chk := FALSE;    -- (4)
        v_duplicate_chk := FALSE;-- checks if error is on same item no
        v_remarks := '''Record already exist!''';
        v_orig_item := FALSE;
        -- to check if same item with different deductible or peril
        v_dedu_notnull := FALSE; -- to check if deductible is present
        v_insert := FALSE;
        record_ctr := record_ctr + 1;

        SELECT item_no, item_title, currency_cd, location_cd,
               currency_rt, item_desc, item_desc2, region_cd,
               LOCATION, limit_of_liability, interest_on_premises,
               section_or_hazard_info, conveyance_info,
               property_no_type, property_no, ded_deductible_cd
          INTO v_item_no, v_item_title, v_currency_cd, v_location_cd,
               v_currency_rt, v_item_desc, v_item_desc2, v_region_cd,
               v_location, v_limit_of_liability, v_interest_on_premises,
               v_section_or_hazard_info, v_conveyance_info,
               v_property_no_type, v_property_no, v_ded_deductible_cd
          FROM gipi_itmfloater_csv
         WHERE record_no = record_ctr;

        IF v_item_no LIKE '' OR v_item_no LIKE ' ' OR v_item_no IS NULL
        THEN
          v_item_no := var.item_no;
          v_item_title := var.item_title;
          v_currency_cd := var.currency_cd;
          v_currency_rt := var.currency_rt;
          v_item_desc := var.item_desc;
          v_item_desc2 := var.item_desc2;
          v_location_cd := var.location_cd;
          v_region_cd := var.region_cd;
          v_location := var.LOCATION;
          v_limit_of_liability := var.limit_of_liability;
          v_interest_on_premises := var.interest_on_premises;
          v_section_or_hazard_info := var.section_or_hazard_info;
          v_conveyance_info := var.conveyance_info;
          v_property_no_type := var.property_no_type;
          v_property_no := var.property_no;
        ELSE
          v_orig_item := TRUE;
          var.item_no := v_item_no;
          var.item_title := v_item_title;
          var.currency_cd := v_currency_cd;
          var.currency_rt := v_currency_rt;
          var.item_desc := v_item_desc;
          var.item_desc2 := v_item_desc2;
          var.location_cd := v_location_cd;
          var.region_cd := v_region_cd;
          var.LOCATION := v_location;
          var.limit_of_liability := v_limit_of_liability;
          var.interest_on_premises := v_interest_on_premises;
          var.section_or_hazard_info := v_section_or_hazard_info;
          var.conveyance_info := v_conveyance_info;
          var.property_no_type := v_property_no_type;
          var.property_no := v_property_no;
        END IF;

        -- check if record already exist --
        -- (1) v_upload_check = FALSE  >file should not be uploaded yet
        -- (2) v_item_chk     = FALSE  >item should not be present in gipi_witem table
        -- (3) v_wcasu_chk    = FALSE  >item should not be present in gipi_wcasualty_item
        -- (4) v_wdedu_chk    = FALSE  >item should not have duplicate deductibles

        -- (1)
        FOR v IN (SELECT 1
                    FROM gipi_ca_upload
                   WHERE filename LIKE p_filename AND upload_no = p_upload_no)   --petermkawx
        LOOP
          v_upload_chk := TRUE;
        END LOOP;

        -- (2)
        FOR v IN (SELECT 1
                    FROM gipi_witem
                   WHERE item_no = v_item_no AND par_id = p_par_id)
        LOOP
          v_witem_chk := TRUE;
        END LOOP;

        -- (3)
        FOR v IN (SELECT 1
                    FROM gipi_wcasualty_item
                   WHERE item_no = v_item_no AND par_id = p_par_id)
        LOOP
          v_wcasu_chk := TRUE;
        END LOOP;

        -- (4)
        FOR v IN (SELECT 1
                    FROM gipi_wdeductibles
                   WHERE item_no = v_item_no
                     AND par_id = p_par_id
                     AND peril_cd = 0
                     AND ded_line_cd = p_line_cd
                     AND ded_subline_cd = p_subline_cd
                     AND ded_deductible_cd = v_ded_deductible_cd)
        --to check if value is duplicate
        LOOP
          v_wdedu_chk := TRUE;
          v_remarks :=
               '''Please doublecheck ALL the deductible codes in the excel file for item number '
            || v_item_no
            || '. (duplicate deductible_cd might exist)''';
        END LOOP;

        --first get the properties of the deductible in giis_deductible_desc according to
        --the given global parameters and value of deductible_cd retrieved from the excel file.
        FOR z IN (SELECT deductible_amt, line_cd, deductible_text,
                         deductible_rt, subline_cd, deductible_cd
                    FROM giis_deductible_desc
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND deductible_cd = v_ded_deductible_cd)
        LOOP
          v_deductible_text := z.deductible_text;
          v_deductible_amt := z.deductible_amt;
          v_deductible_rt := z.deductible_rt;
          v_dedu_notnull := TRUE;
        END LOOP;

        -- insert into gipi_ca_upload
        IF NOT v_upload_chk AND NOT v_ca_upload
        THEN
          INSERT INTO gipi_ca_upload
                      (upload_no,
                       filename,
                       upload_date, user_id, last_update
                      )
               VALUES (p_upload_no,
                       SUBSTR (p_filename, INSTR (p_filename, '\', -1) + 1),
                       SYSDATE, USER, SYSDATE
                      );

          v_ca_upload := TRUE;
        END IF;

        IF     NOT v_witem_chk
           AND NOT v_wcasu_chk
           AND NOT v_wdedu_chk
           --AND v_dedu_notnull --commented out to accept records w/o deductibles
           --petermkaw 05192010
        THEN
          INSERT INTO gipi_witem
                      (par_id, item_no, item_title, currency_cd,
                       currency_rt, item_desc, item_desc2, region_cd
                      )
               VALUES (p_par_id, v_item_no, v_item_title, v_currency_cd,
                       v_currency_rt, v_item_desc, v_item_desc2, v_region_cd
                      );

          INSERT INTO gipi_wcasualty_item
                      (par_id, item_no, location_cd, LOCATION,
                       limit_of_liability, interest_on_premises,
                       section_or_hazard_info, conveyance_info,
                       property_no_type, property_no
                      )
               VALUES (p_par_id, v_item_no, v_location_cd, v_location,
                       v_limit_of_liability, v_interest_on_premises,
                       v_section_or_hazard_info, v_conveyance_info,
                       v_property_no_type, v_property_no
                      );

          v_insert := TRUE;
        END IF;

        --check if there is a deductible for the specified record:
        --if true, insert record into GIPI_WDEDUCTIBLES:
        IF NOT v_wdedu_chk AND v_dedu_notnull
        THEN
          INSERT INTO gipi_wdeductibles
                      (par_id, item_no, peril_cd, ded_line_cd,
                       ded_subline_cd, ded_deductible_cd, deductible_text,
                       deductible_amt, deductible_rt
                      )
               VALUES (p_par_id, v_item_no, 0, p_line_cd,
                       p_subline_cd, v_ded_deductible_cd, v_deductible_text,
                       v_deductible_amt, v_deductible_rt
                      );

          v_insert := TRUE;
        END IF;

        IF v_insert
        THEN
          upload_ctr := upload_ctr + 1;
        ELSE
          FOR x IN (SELECT upload_no, filename, item_no
                      FROM gipi_ca_error_log
                     WHERE upload_no = p_upload_no
                       AND filename = p_filename
                       AND item_no = v_item_no)
          LOOP
            v_duplicate_chk := TRUE;
          --checks if an error is already logged for the same item.
          END LOOP;

          IF v_duplicate_chk
          THEN
            duplicate_ctr := duplicate_ctr + 1;
          ELSE
            INSERT INTO gipi_ca_error_log
                        (upload_no, filename, item_no, item_title,
                         currency_cd, currency_rt, item_desc,
                         item_desc2, location_cd, region_cd,
                         LOCATION, limit_of_liability,
                         interest_on_premises, section_or_hazard_info,
                         conveyance_info, property_no_type,
                         property_no, ded_deductible_cd, user_id,
                         date_uploaded, remarks
                        )
                 VALUES (p_upload_no, p_filename, v_item_no, v_item_title,
                         v_currency_cd, v_currency_rt, v_item_desc,
                         v_item_desc2, v_location_cd, v_region_cd,
                         v_location, v_limit_of_liability,
                         v_interest_on_premises, v_section_or_hazard_info,
                         v_conveyance_info, v_property_no_type,
                         v_property_no, v_ded_deductible_cd, USER,
                         SYSDATE, v_remarks
                        );

            err_ctr := err_ctr + 1;
          END IF;
        END IF;

        total_rec := duplicate_ctr + err_ctr + upload_ctr;
      END LOOP;

      p_message :=
          'Duplicate records not recorded in the error log: ' || duplicate_ctr;

      DELETE FROM gipi_itmfloater_csv
            WHERE upload_no = p_upload_no;

      COMMIT;
    END IF;
  END upd_floater_item;

  FUNCTION check_duration (pdate1 IN DATE, pdate2 IN DATE)
    RETURN NUMBER
  IS
    v_no_of_days   NUMBER := 0;
  BEGIN
    FOR x IN TO_NUMBER (TO_CHAR (pdate1, 'YYYY')) .. TO_NUMBER
                                                            (TO_CHAR (pdate2,
                                                                      'YYYY'
                                                                     )
                                                            )
    LOOP
      IF     TO_NUMBER (TO_CHAR (LAST_DAY (TO_DATE ('01-FEB-' || TO_CHAR (x))),
                                 'DD'
                                )
                       ) = 29
         AND pdate1 <= LAST_DAY (TO_DATE ('01-FEB-' || TO_CHAR (x)))
         AND pdate2 >= LAST_DAY (TO_DATE ('01-FEB-' || TO_CHAR (x)))
      THEN
        RETURN (366);
      ELSE
        v_no_of_days := 365;
      END IF;
    END LOOP;

    RETURN (v_no_of_days);
  END check_duration;

  PROCEDURE upd_gipi_witem_tab (p_par_id IN NUMBER)
  IS
    v_prorate_flag     VARCHAR2 (1);
    v_short_rate_pct   NUMBER (12, 9);
    v_comp_sw          VARCHAR2 (1);
    v_eff_date         DATE;
    v_expiry_date      DATE;
    v_prorate          NUMBER (12, 9);
  BEGIN
    SELECT prorate_flag, short_rt_percent, comp_sw, eff_date,
           expiry_date
      INTO v_prorate_flag, v_short_rate_pct, v_comp_sw, v_eff_date,
           v_expiry_date
      FROM gipi_wpolbas
     WHERE par_id = p_par_id;

    IF v_prorate_flag = '1'
    THEN   --for prorated
      IF v_comp_sw = 'Y'
      THEN
        v_prorate :=
            ((TRUNC (v_expiry_date) - TRUNC (v_eff_date)) + 1)
          / check_duration (v_eff_date, v_expiry_date);
      ELSIF v_comp_sw = 'M'
      THEN
        v_prorate :=
            ((TRUNC (v_expiry_date) - TRUNC (v_eff_date)) - 1)
          / check_duration (v_eff_date, v_expiry_date);
      ELSE
        v_prorate :=
            (TRUNC (v_expiry_date) - TRUNC (v_eff_date))
          / check_duration (v_eff_date, v_expiry_date);
      END IF;
    ELSIF v_prorate_flag = '3'
    THEN   --for shortrated
      v_prorate := NVL (v_short_rate_pct, 1) / 100;
    ELSE
      v_prorate := 1;
    END IF;

    FOR x IN (SELECT tsi_amt, prem_amt, item_no, peril_cd
                FROM gipi_witmperl
               WHERE par_id = p_par_id)
    LOOP
      UPDATE gipi_witmperl
         SET ann_prem_amt = x.prem_amt * NVL (v_prorate, 1),
             ann_tsi_amt = x.tsi_amt
       WHERE par_id = p_par_id AND item_no = x.item_no
             AND peril_cd = x.peril_cd;
    END LOOP;

    FOR a IN (SELECT   SUM (NVL (prem_amt, 0)) prem,
                       SUM (NVL (ann_prem_amt, 0)) ann_prem, item_no
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id
              GROUP BY item_no)
    LOOP
      UPDATE gipi_witem
         SET prem_amt = a.prem,
             ann_prem_amt = a.ann_prem
       WHERE par_id = p_par_id AND item_no = a.item_no;

      UPDATE gipi_witem
         SET item_grp = 1
       WHERE par_id = p_par_id AND item_no = a.item_no AND item_grp IS NULL;
    END LOOP;

    FOR b IN (SELECT   SUM (NVL (a.tsi_amt, 0)) tsi,
                       SUM (NVL (a.ann_tsi_amt, 0)) ann_tsi, a.item_no
                  FROM gipi_witmperl a, giis_peril b
                 WHERE a.line_cd = b.line_cd
                   AND a.peril_cd = b.peril_cd
                   AND b.peril_type = 'B'
                   AND a.par_id = p_par_id
              GROUP BY a.item_no)
    LOOP
      UPDATE gipi_witem
         SET tsi_amt = b.tsi,
             ann_tsi_amt = b.ann_tsi
       WHERE par_id = p_par_id AND item_no = b.item_no;
    END LOOP;
  END upd_gipi_witem_tab;
END upd_floater_csv_pkg;
/


