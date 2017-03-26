CREATE OR REPLACE PACKAGE G_PARTITION_MGMT AS

--Autor: Matias Orquera. Fecha: 21.02.2017

--HOUR
PROCEDURE P_TRUNCATE_PARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_TRUNCATE_SUBPARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR);
PROCEDURE P_DROP_PARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_DROP_SUBPARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR);

--DAY
PROCEDURE P_TRUNCATE_PARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_TRUNCATE_SUBPARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR);
PROCEDURE P_DROP_PARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_DROP_SUBPARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR);

PROCEDURE P_DROP_INTERVAL_PARTITION (P_TABLE IN CHAR, P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);

END G_PARTITION_MGMT;
/


CREATE OR REPLACE PACKAGE BODY G_PARTITION_MGMT AS

--Autor: Matias Orquera. Fecha: 21.02.2017.

-- LOG --
L_ERRNO  NUMBER;
L_MSG    VARCHAR2(4000);
  -- END LOG --

V_LINEA VARCHAR2(200);

PROCEDURE P_TRUNCATE_PARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

--Autor: Matias Orquera. Fecha: 18.01.2017

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY')||' '||HORA FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24');

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' TRUNCATE PARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY HH24''))';

      DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;
      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_PARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_PARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_TRUNCATE_SUBPARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR)
IS

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY')||' '||HORA FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24');

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' TRUNCATE SUBPARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY HH24''),'''||P_SUBPART||''')';

      --DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;

      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_SUBPARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_SUBPARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
END;


PROCEDURE P_DROP_PARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

--Autor: Matias Orquera. Fecha: 18.01.2017

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY')||' '||HORA FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24');

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' DROP PARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY HH24''))';

      --DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;
      EXECUTE IMMEDIATE V_LINEA;
      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_PARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_PARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_DROP_SUBPARTITION_HOUR(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR)
IS

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY')||' '||HORA FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24');

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' DROP SUBPARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY HH24''),'''||P_SUBPART||''')';

      --DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;
      EXECUTE IMMEDIATE V_LINEA;
      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_SUBPARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_SUBPARTITION_HOUR',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_TRUNCATE_PARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

--Autor: Matias Orquera. Fecha: 18.01.2017

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY') FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY')
  AND HORA = '00';

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' TRUNCATE PARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY''))';

      --DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;
      EXECUTE IMMEDIATE V_LINEA;
      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_PARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;


  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_PARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_TRUNCATE_SUBPARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR)
IS

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY') FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY')
  AND HORA = '00';

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' TRUNCATE SUBPARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY HH24''),'''||P_SUBPART||''')';

      --DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;

      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_SUBPARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_TRUNCATE_SUBPARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_DROP_PARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

--Autor: Matias Orquera. Fecha: 18.01.2017

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY') FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY')
  AND HORA = '00';

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' DROP PARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY''))';

      DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;
      EXECUTE IMMEDIATE V_LINEA;
      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_PARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_PARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_DROP_SUBPARTITION_DAY(P_TABLA VARCHAR2,P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SUBPART IN CHAR)
IS

CURSOR FECHAS IS
SELECT TO_CHAR(DIA,'DD.MM.YYYY') FECHA
FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY')
  AND HORA = '00';

BEGIN

  FOR TR IN FECHAS LOOP
    BEGIN
      V_LINEA := 'ALTER TABLE '||P_TABLA||' TRUNCATE SUBPARTITION FOR(TO_DATE('''||TR.FECHA||''',''DD.MM.YYYY HH24''),'''||P_SUBPART||''')';

      --DBMS_OUTPUT.PUT_LINE(V_LINEA);
      EXECUTE IMMEDIATE V_LINEA;

      EXCEPTION
      WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        L_ERRNO := SQLCODE;
        L_MSG := SQLERRM;
        G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_SUBPARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
    END;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE(SQLERRM);
      L_ERRNO := SQLCODE;
      L_MSG := SQLERRM;
      G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_SUBPARTITION_DAY',L_ERRNO,L_MSG, V_LINEA);
END;

PROCEDURE P_DROP_INTERVAL_PARTITION (P_TABLE IN CHAR, P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS

--Autor: Matias Orquera. Fecha: 17.01.2017
-- Procedure experimental USAR LOS OTROS DEL PAQUETE.
CURSOR V_CUR IS
    SELECT PARTITION_NAME,
           HIGH_VALUE
      FROM USER_TAB_PARTITIONS
     WHERE TABLE_NAME = P_TABLE
       AND INTERVAL = 'YES';

V_HIGH_VALUE TIMESTAMP;
V_LINEA VARCHAR2(200);

BEGIN
  FOR V_REC IN V_CUR LOOP
    EXECUTE IMMEDIATE 'BEGIN :1 := ' || V_REC.HIGH_VALUE || '; END;'
      USING OUT V_HIGH_VALUE;
    IF V_HIGH_VALUE BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24') AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')
      THEN
        
        V_LINEA := 'ALTER TABLE '||P_TABLE||' DROP PARTITION ' || V_REC.PARTITION_NAME;
        DBMS_OUTPUT.PUT_LINE(V_LINEA || ';');
                
        EXECUTE IMMEDIATE V_LINEA;
        
    END IF;
  END LOOP;
  
  EXCEPTION
  WHEN OTHERS THEN  
    L_ERRNO := SQLCODE;
    L_MSG := SUBSTR(SQLERRM, 1, 350);
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_DROP_INTERVAL_PARTITION',L_ERRNO,L_MSG, V_LINEA);
  
END;

END G_PARTITION_MGMT;
/
