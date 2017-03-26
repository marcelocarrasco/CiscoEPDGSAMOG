CREATE OR REPLACE PACKAGE G_CISCO_GGSN_EPDG_SAMOG AS

--Autor: Matias Orquera. Fecha: 18.01.2017

PROCEDURE P_CISCO_GGSN_EPDG_HOUR (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_EPDG_DAY (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_EPDG_BH (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_EPDG_ISABHW (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);

PROCEDURE P_CISCO_GGSN_SAMOG_HOUR (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_SAMOG_DAY (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_SAMOG_BH (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_SAMOG_ISABHW (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);

PROCEDURE P_CISCO_GGSN_EPDG_SAMOG_JOB_H;
PROCEDURE P_CISCO_GGSN_EPDG_SAMOG_JOB_D;
PROCEDURE P_CISCO_GGSN_EPDG_SAMOG_JOB_W;

PROCEDURE P_CISCO_GGSN_EPDG_REWORK_HOUR(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_EPDG_REWORK_DAY(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_EPDG_REWORK_BH(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_EPDG_REWORK_WEEK (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);

PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_HOUR(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_DAY(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_BH(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_WEEK (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR);
  
END G_CISCO_GGSN_EPDG_SAMOG;


CREATE OR REPLACE PACKAGE BODY G_CISCO_GGSN_EPDG_SAMOG AS

--Autor: Matias Orquera. Fecha: 18.01.2017

    -- LOG --
L_ERRORS NUMBER;
L_ERRNO  NUMBER;
L_MSG    VARCHAR2(4000);
L_IDX    NUMBER;
  -- END LOG --

LIMIT_IN PLS_INTEGER := 100;
V_N32    NUMBER      := 4294967296;
V_N64    NUMBER      := 18446744073709551616;


PROCEDURE P_CISCO_GGSN_EPDG_HOUR (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS

-- Autor: Matias Orquera. Fecha: 15.12.2016
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@
-- Actualizacion: Matias Orquera. Fecha: 05.01.2017. Motivo: Se agrega tratamiento para variables Counter MIBs incrementales de Cisco.
-- Actualizacion: Matias Orquera. Fecha: 26.01.2017. Motivo: Se modifica criterio de OUTER JOIN con tabla destino.

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);

TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_EPDG_HOUR%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
SELECT O.FECHA,
       O.EQUIPO,
       O.VPNNAME,
       O.VPNID,
       O.SERVNAME,
       O.SERVID,
       O.PDN_IPV4_ACTIVE,
       O.PDN_IPV4_SETUP,
       O.PDN_IPV4_RELEASED,
       O.PDN_IPV6_ACTIVE,
       O.PDN_IPV6_SETUP,
       O.PDN_IPV6_RELEASED,
       O.PDN_IPV4V6_ACTIVE,
       O.PDN_IPV4V6_SETUP,
       O.PDN_IPV4V6_RELEASED,
       O.NUM_GTP_BEARER_MODIFIED,
       O.NUM_GTP_DB_ACTIVE,
       O.NUM_GTP_DB_RELEASED,
       O.CURSESS,
       O.CURSES_PMIPV6_IPV4,
       O.CURSES_PMIPV6_IPV6,
       O.CURSES_PMIPV6_IPV4V6,
       O.CURSES_GTP_IPV4,
       O.TOTPMIPV6_SUCCESS,
       O.TOTPMIPV6_FAILURE,
       O.PGW_FALLBACK_ATTEMPTED,
       O.PGW_FALLBACK_SUCCEEDED,
       O.PGW_FALLBACK_FAILED,
       O.PGW_FALLBACK_NO_ALTERNATE_PGW,
       O.TOTGTP_ATTEMPT,
       O.TOTGTP_SUCCESS,
       O.TOTGTP_FAILURE,
       O.DISCONNECT_TOTAL,
       O.DISCONNECT_LOCAL,
       O.DISCONNECT_UE,
       O.DISCONNECT_PGW,
       O.DISCONNECT_REMOTE,
       O.SESS_DCON_REMOTE,
       O.SESS_DCON_ADMIN,
       O.SESS_DCON_IDLE_TIMEOUT,
       O.SESS_DCON_ABS_TIMEOUT,
       O.SESS_DCON_LONGDUR_TIMEOUT,
       O.SESS_DCON_SESSSETUP_TIMEOUT,
       O.SESS_DCON_NORESOURCE,
       O.SESS_DCON_AUTHFAIL,
       O.SESS_DCON_FLOWADD_FAILURE,
       O.SESS_DCON_INVALID_DEST,
       O.SESS_DCON_SRCADDR_VIOLATION,
       O.SESS_DCON_LMAREVOC,
       O.SESS_DCON_DUPREQ,
       O.SESS_DCON_ADDRASSIGN_FAILURE,
       O.SESS_DCON_HANDOFF,
       O.SESS_DCON_MISC,
       O.REAUTH_ATTEMPT,
       O.REAUTH_SUCCESS,
       O.REAUTH_FAILURE,
       O.REAUTHOR_ATTEMPT,
       O.REAUTHOR_SUCCESS,
       O.REAUTHOR_FAILURE,
       O.TXBYTES,
       O.TXPKTS,
       O.RXBYTES,
       O.RXPKTS,
       O.PKT_VIOLATION,
       O.EAP_RXTTLSRVRPASSTHRU,
       O.NUM_QCI1_BEARER_ACTIVE,
       O.NUM_QCI1_BEARER_SETUP,
       O.NUM_QCI1_BEARER_RELEASED,
       O.NUM_QCI2_BEARER_ACTIVE,
       O.NUM_QCI2_BEARER_SETUP,
       O.NUM_QCI2_BEARER_RELEASED,
       O.NUM_QCI3_BEARER_ACTIVE,
       O.NUM_QCI3_BEARER_SETUP,
       O.NUM_QCI3_BEARER_RELEASED,
       O.NUM_QCI4_BEARER_ACTIVE,
       O.NUM_QCI4_BEARER_SETUP,
       O.NUM_QCI4_BEARER_RELEASED,
       O.NUM_QCI5_BEARER_ACTIVE,
       O.NUM_QCI5_BEARER_SETUP,
       O.NUM_QCI5_BEARER_RELEASED,
       O.NUM_QCI6_BEARER_ACTIVE,
       O.NUM_QCI6_BEARER_SETUP,
       O.NUM_QCI6_BEARER_RELEASED,
       O.NUM_QCI7_BEARER_ACTIVE,
       O.NUM_QCI7_BEARER_SETUP,
       O.NUM_QCI7_BEARER_RELEASED,
       ROUND(DECODE(O.TOTGTP_ATTEMPT,0,0,(O.TOTGTP_SUCCESS/O.TOTGTP_ATTEMPT)*100),4)              APN_EPDG_GTPV2_SUCCESS_RATE,
       ROUND((O.TXBYTES*8)/(3600*1024*1024),4)                                                    TX_THROUGHPUT,
       ROUND((O.RXBYTES*8)/(3600*1024*1024),4)                                                    RX_THROUGHPUT,
       ROUND((O.TXBYTES+O.RXBYTES)*8/(1024*1024*3600),4)                                          APN_EPDG_SYS_THROUGHPUT
FROM
(SELECT TRUNC(T1.FECHA, 'HH24')                                                                   FECHA,
        T1.EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        AVG(PDN_IPV4_ACTIVE)                                                                      PDN_IPV4_ACTIVE,
        SUM(DECODE(L_PDN_IPV4_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_PDN_IPV4_SETUP) < PDN_IPV4_SETUP THEN
                  CASE WHEN (V_N32 + L_PDN_IPV4_SETUP - PDN_IPV4_SETUP) > 4290000000 THEN
                     0
                  ELSE
                    (V_N32 + L_PDN_IPV4_SETUP - PDN_IPV4_SETUP)
                  END
                ELSE
                 DECODE(L_PDN_IPV4_SETUP,0,0,L_PDN_IPV4_SETUP-PDN_IPV4_SETUP)
              END))                                                                               PDN_IPV4_SETUP,
        SUM(DECODE(L_PDN_IPV4_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_PDN_IPV4_RELEASED) < T1.PDN_IPV4_RELEASED THEN
                  (V_N32 + L_PDN_IPV4_RELEASED - T1.PDN_IPV4_RELEASED)
                ELSE
                 DECODE(L_PDN_IPV4_RELEASED,0,0,L_PDN_IPV4_RELEASED-T1.PDN_IPV4_RELEASED)
              END))                                                                               PDN_IPV4_RELEASED,
        AVG(T1.PDN_IPV6_ACTIVE)                                                                   PDN_IPV6_ACTIVE,
        SUM(DECODE(L_PDN_IPV6_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_PDN_IPV6_SETUP) < T1.PDN_IPV6_SETUP THEN
                  (V_N32 + L_PDN_IPV6_SETUP - T1.PDN_IPV6_SETUP)
                ELSE
                 DECODE(L_PDN_IPV6_SETUP,0,0,L_PDN_IPV6_SETUP-T1.PDN_IPV6_SETUP)
              END))                                                                               PDN_IPV6_SETUP,
        SUM(DECODE(L_PDN_IPV6_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_PDN_IPV6_RELEASED) < T1.PDN_IPV6_RELEASED THEN
                  (V_N32 + L_PDN_IPV6_RELEASED - T1.PDN_IPV6_RELEASED)
                ELSE
                 DECODE(L_PDN_IPV6_RELEASED,0,0,L_PDN_IPV6_RELEASED-T1.PDN_IPV6_RELEASED)
              END))                                                                               PDN_IPV6_RELEASED,
        AVG(T1.PDN_IPV4V6_ACTIVE)                                                                 PDN_IPV4V6_ACTIVE,
        SUM(DECODE(L_PDN_IPV4V6_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_PDN_IPV4V6_SETUP) < T1.PDN_IPV4V6_SETUP THEN
                  (V_N32 + L_PDN_IPV4V6_SETUP - T1.PDN_IPV4V6_SETUP)
                ELSE
                 DECODE(L_PDN_IPV4V6_SETUP,0,0,L_PDN_IPV4V6_SETUP-T1.PDN_IPV4V6_SETUP)
              END))                                                                               PDN_IPV4V6_SETUP,
        SUM(DECODE(L_PDN_IPV4V6_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_PDN_IPV4V6_RELEASED) < T1.PDN_IPV4V6_RELEASED THEN
                  (V_N32 + L_PDN_IPV4V6_RELEASED - T1.PDN_IPV4V6_RELEASED)
                ELSE
                 DECODE(L_PDN_IPV4V6_RELEASED,0,0,L_PDN_IPV4V6_RELEASED-T1.PDN_IPV4V6_RELEASED)
              END))                                                                               PDN_IPV4V6_RELEASED,
        SUM(DECODE(L_NUM_GTP_BEARER_MODIFIED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_GTP_BEARER_MODIFIED) < T1.NUM_GTP_BEARER_MODIFIED THEN
                  (V_N32 + L_NUM_GTP_BEARER_MODIFIED - T1.NUM_GTP_BEARER_MODIFIED)
                ELSE
                 DECODE(L_NUM_GTP_BEARER_MODIFIED,0,0,L_NUM_GTP_BEARER_MODIFIED-T1.NUM_GTP_BEARER_MODIFIED)
              END))                                                                               NUM_GTP_BEARER_MODIFIED,
        AVG(T1.NUM_GTP_DB_ACTIVE)                                                                 NUM_GTP_DB_ACTIVE,
        SUM(DECODE(L_NUM_GTP_DB_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_GTP_DB_RELEASED) < T1.NUM_GTP_DB_RELEASED THEN
                  (V_N32 + L_NUM_GTP_DB_RELEASED - T1.NUM_GTP_DB_RELEASED)
                ELSE
                 DECODE(L_NUM_GTP_DB_RELEASED,0,0,L_NUM_GTP_DB_RELEASED-T1.NUM_GTP_DB_RELEASED)
              END))                                                                               NUM_GTP_DB_RELEASED,
        AVG(T1.CURSESS)                                                        CURSESS,
        AVG(T1.CURSES_PMIPV6_IPV4)                                             CURSES_PMIPV6_IPV4,
        AVG(T1.CURSES_PMIPV6_IPV6)                                             CURSES_PMIPV6_IPV6,
        AVG(T1.CURSES_PMIPV6_IPV4V6)                                           CURSES_PMIPV6_IPV4V6,
        AVG(T1.CURSES_GTP_IPV4)                                                CURSES_GTP_IPV4,
        SUM(DECODE(L_TOTPMIPV6_SUCCESS,0,0,
              CASE
                WHEN TO_NUMBER(L_TOTPMIPV6_SUCCESS) < T1.TOTPMIPV6_SUCCESS THEN
                  (V_N32 + L_TOTPMIPV6_SUCCESS - T1.TOTPMIPV6_SUCCESS)
                ELSE
                 DECODE(L_TOTPMIPV6_SUCCESS,0,0,L_TOTPMIPV6_SUCCESS-T1.TOTPMIPV6_SUCCESS)
              END))                                                                               TOTPMIPV6_SUCCESS,
        SUM(DECODE(L_TOTPMIPV6_FAILURE,0,0,
              CASE
                WHEN TO_NUMBER(L_TOTPMIPV6_FAILURE) < T1.TOTPMIPV6_FAILURE THEN
                  (V_N32 + L_TOTPMIPV6_FAILURE - T1.TOTPMIPV6_FAILURE)
                ELSE
                 DECODE(L_TOTPMIPV6_FAILURE,0,0,L_TOTPMIPV6_FAILURE-T1.TOTPMIPV6_FAILURE)
              END))                                                                               TOTPMIPV6_FAILURE,
        SUM(DECODE(L_PGW_FALLBACK_ATTEMPTED,0,0,
              CASE
                WHEN TO_NUMBER(L_PGW_FALLBACK_ATTEMPTED) < T1.PGW_FALLBACK_ATTEMPTED THEN
                  (V_N32 + L_PGW_FALLBACK_ATTEMPTED - T1.PGW_FALLBACK_ATTEMPTED)
                ELSE
                 DECODE(L_PGW_FALLBACK_ATTEMPTED,0,0,L_PGW_FALLBACK_ATTEMPTED-T1.PGW_FALLBACK_ATTEMPTED)
              END))                                                                               PGW_FALLBACK_ATTEMPTED,
        SUM(DECODE(L_PGW_FALLBACK_SUCCEEDED,0,0,
              CASE
                WHEN TO_NUMBER(L_PGW_FALLBACK_SUCCEEDED) < T1.PGW_FALLBACK_SUCCEEDED THEN
                  (V_N32 + L_PGW_FALLBACK_SUCCEEDED - T1.PGW_FALLBACK_SUCCEEDED)
                ELSE
                 DECODE(L_PGW_FALLBACK_SUCCEEDED,0,0,L_PGW_FALLBACK_SUCCEEDED-T1.PGW_FALLBACK_SUCCEEDED)
              END))                                                                               PGW_FALLBACK_SUCCEEDED,
        SUM(DECODE(L_PGW_FALLBACK_FAILED,0,0,
              CASE
                WHEN TO_NUMBER(L_PGW_FALLBACK_FAILED) < T1.PGW_FALLBACK_FAILED THEN
                  (V_N32 + L_PGW_FALLBACK_FAILED - T1.PGW_FALLBACK_FAILED)
                ELSE
                 DECODE(L_PGW_FALLBACK_FAILED,0,0,L_PGW_FALLBACK_FAILED-T1.PGW_FALLBACK_FAILED)
              END))                                                                               PGW_FALLBACK_FAILED,
        SUM(DECODE(L_PGW_FALLB_NO_ALTERNATE_PGW,0,0,
              CASE
                WHEN TO_NUMBER(L_PGW_FALLB_NO_ALTERNATE_PGW) < T1.PGW_FALLBACK_NO_ALTERNATE_PGW THEN
                  (V_N32 + L_PGW_FALLB_NO_ALTERNATE_PGW - T1.PGW_FALLBACK_NO_ALTERNATE_PGW)
                ELSE
                 DECODE(L_PGW_FALLB_NO_ALTERNATE_PGW,0,0,L_PGW_FALLB_NO_ALTERNATE_PGW-T1.PGW_FALLBACK_NO_ALTERNATE_PGW)
              END))                                                                               PGW_FALLBACK_NO_ALTERNATE_PGW,
        SUM(DECODE(L_TOTGTP_ATTEMPT,0,0,
              CASE
                WHEN TO_NUMBER(L_TOTGTP_ATTEMPT) < T1.TOTGTP_ATTEMPT THEN
                  CASE WHEN (V_N32 + L_TOTGTP_ATTEMPT - T1.TOTGTP_ATTEMPT) > 4290000000 THEN
                     0
                  ELSE
                    (V_N32 + L_TOTGTP_ATTEMPT - T1.TOTGTP_ATTEMPT)
                  END                  
                ELSE
                 DECODE(L_TOTGTP_ATTEMPT,0,0,L_TOTGTP_ATTEMPT-T1.TOTGTP_ATTEMPT)
              END))                                                                               TOTGTP_ATTEMPT,
        SUM(DECODE(L_TOTGTP_SUCCESS,0,0,
              CASE
                WHEN TO_NUMBER(L_TOTGTP_SUCCESS) < T1.TOTGTP_SUCCESS THEN
                  CASE WHEN (V_N32 + L_TOTGTP_SUCCESS - T1.TOTGTP_SUCCESS) > 4290000000 THEN
                     0
                  ELSE
                    (V_N32 + L_TOTGTP_SUCCESS - T1.TOTGTP_SUCCESS)
                  END                  
                ELSE
                 DECODE(L_TOTGTP_SUCCESS,0,0,L_TOTGTP_SUCCESS-T1.TOTGTP_SUCCESS)
              END))                                                                               TOTGTP_SUCCESS,
        SUM(DECODE(L_TOTGTP_FAILURE,0,0,
              CASE
                WHEN TO_NUMBER(L_TOTGTP_FAILURE) < T1.TOTGTP_FAILURE THEN
                  (V_N32 + L_TOTGTP_FAILURE - T1.TOTGTP_FAILURE)
                ELSE
                 DECODE(L_TOTGTP_FAILURE,0,0,L_TOTGTP_FAILURE-T1.TOTGTP_FAILURE)
              END))                                                                               TOTGTP_FAILURE,
        SUM(DECODE(L_DISCONNECT_TOTAL,0,0,
              CASE
                WHEN TO_NUMBER(L_DISCONNECT_TOTAL) < T1.DISCONNECT_TOTAL THEN
                  (V_N32 + L_DISCONNECT_TOTAL - T1.DISCONNECT_TOTAL)
                ELSE
                 DECODE(L_DISCONNECT_TOTAL,0,0,L_DISCONNECT_TOTAL-T1.DISCONNECT_TOTAL)
              END))                                                                               DISCONNECT_TOTAL,
        SUM(DECODE(L_DISCONNECT_LOCAL,0,0,
              CASE
                WHEN TO_NUMBER(L_DISCONNECT_LOCAL) < T1.DISCONNECT_LOCAL THEN
                  (V_N32 + L_DISCONNECT_LOCAL - T1.DISCONNECT_LOCAL)
                ELSE
                 DECODE(L_DISCONNECT_LOCAL,0,0,L_DISCONNECT_LOCAL-T1.DISCONNECT_LOCAL)
              END))                                                                               DISCONNECT_LOCAL,
        SUM(DECODE(L_DISCONNECT_UE,0,0,
              CASE
                WHEN TO_NUMBER(L_DISCONNECT_UE) < T1.DISCONNECT_UE THEN
                  (V_N32 + L_DISCONNECT_UE - T1.DISCONNECT_UE)
                ELSE
                 DECODE(L_DISCONNECT_UE,0,0,L_DISCONNECT_UE-T1.DISCONNECT_UE)
              END))                                                                               DISCONNECT_UE,
        SUM(DECODE(L_DISCONNECT_PGW,0,0,
              CASE
                WHEN TO_NUMBER(L_DISCONNECT_PGW) < T1.DISCONNECT_PGW THEN
                  (V_N32 + L_DISCONNECT_PGW - T1.DISCONNECT_PGW)
                ELSE
                 DECODE(L_DISCONNECT_PGW,0,0,L_DISCONNECT_PGW-T1.DISCONNECT_PGW)
              END))                                                                               DISCONNECT_PGW,
        SUM(DECODE(L_DISCONNECT_REMOTE,0,0,
              CASE
                WHEN TO_NUMBER(L_DISCONNECT_REMOTE) < T1.DISCONNECT_REMOTE THEN
                  (V_N32 + L_DISCONNECT_REMOTE - T1.DISCONNECT_REMOTE)
                ELSE
                 DECODE(L_DISCONNECT_REMOTE,0,0,L_DISCONNECT_REMOTE-T1.DISCONNECT_REMOTE)
              END))                                                                               DISCONNECT_REMOTE,
        SUM(DECODE(L_SESS_DCON_REMOTE,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_REMOTE) < T1.SESS_DCON_REMOTE THEN
                  (V_N32 + L_SESS_DCON_REMOTE - T1.SESS_DCON_REMOTE)
                ELSE
                 DECODE(L_SESS_DCON_REMOTE,0,0,L_SESS_DCON_REMOTE-T1.SESS_DCON_REMOTE)
              END))                                                                               SESS_DCON_REMOTE,
        SUM(DECODE(L_SESS_DCON_ADMIN,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_ADMIN) < T1.SESS_DCON_ADMIN THEN
                  (V_N32 + L_SESS_DCON_ADMIN - T1.SESS_DCON_ADMIN)
                ELSE
                 DECODE(L_SESS_DCON_ADMIN,0,0,L_SESS_DCON_ADMIN-T1.SESS_DCON_ADMIN)
              END))                                                                               SESS_DCON_ADMIN,
        SUM(DECODE(L_SESS_DCON_IDLE_TIMEOUT,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_IDLE_TIMEOUT) < T1.SESS_DCON_IDLE_TIMEOUT THEN
                  (V_N32 + L_SESS_DCON_IDLE_TIMEOUT - T1.SESS_DCON_IDLE_TIMEOUT)
                ELSE
                 DECODE(L_SESS_DCON_IDLE_TIMEOUT,0,0,(L_SESS_DCON_IDLE_TIMEOUT)-T1.SESS_DCON_IDLE_TIMEOUT)
              END))                                                                               SESS_DCON_IDLE_TIMEOUT,
        SUM(DECODE(L_SESS_DCON_ABS_TIMEOUT,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_ABS_TIMEOUT) < T1.SESS_DCON_ABS_TIMEOUT THEN
                  (V_N32 + L_SESS_DCON_ABS_TIMEOUT - T1.SESS_DCON_ABS_TIMEOUT)
                ELSE
                 DECODE(L_SESS_DCON_ABS_TIMEOUT,0,0,L_SESS_DCON_ABS_TIMEOUT-T1.SESS_DCON_ABS_TIMEOUT)
              END))                                                                               SESS_DCON_ABS_TIMEOUT,
        SUM(DECODE(L_SESS_DCON_LONGDUR_TIMEOUT,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_LONGDUR_TIMEOUT) < T1.SESS_DCON_LONGDUR_TIMEOUT THEN
                  (V_N32 + L_SESS_DCON_LONGDUR_TIMEOUT - T1.SESS_DCON_LONGDUR_TIMEOUT)
                ELSE
                 DECODE(L_SESS_DCON_LONGDUR_TIMEOUT,0,0,L_SESS_DCON_LONGDUR_TIMEOUT-T1.SESS_DCON_LONGDUR_TIMEOUT)
              END))                                                                               SESS_DCON_LONGDUR_TIMEOUT,
        SUM(DECODE(L_SESS_DCON_SESSSETUP_TIMEOUT,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_SESSSETUP_TIMEOUT) < T1.SESS_DCON_SESSSETUP_TIMEOUT THEN
                  (V_N32 + L_SESS_DCON_SESSSETUP_TIMEOUT - T1.SESS_DCON_SESSSETUP_TIMEOUT)
                ELSE
                 DECODE(L_SESS_DCON_SESSSETUP_TIMEOUT,0,0,L_SESS_DCON_SESSSETUP_TIMEOUT-T1.SESS_DCON_SESSSETUP_TIMEOUT)
              END))                                                                               SESS_DCON_SESSSETUP_TIMEOUT,
        SUM(DECODE(L_SESS_DCON_NORESOURCE,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_NORESOURCE) < T1.SESS_DCON_NORESOURCE THEN
                  (V_N32 + L_SESS_DCON_NORESOURCE - T1.SESS_DCON_NORESOURCE)
                ELSE
                 DECODE(L_SESS_DCON_NORESOURCE,0,0,L_SESS_DCON_NORESOURCE-T1.SESS_DCON_NORESOURCE)
              END))                                                                               SESS_DCON_NORESOURCE,
        SUM(DECODE(L_SESS_DCON_AUTHFAIL,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_AUTHFAIL) < T1.SESS_DCON_AUTHFAIL THEN
                  (V_N32 + L_SESS_DCON_AUTHFAIL - T1.SESS_DCON_AUTHFAIL)
                ELSE
                 DECODE(L_SESS_DCON_AUTHFAIL,0,0,L_SESS_DCON_AUTHFAIL-T1.SESS_DCON_AUTHFAIL)
              END))                                                                               SESS_DCON_AUTHFAIL,
        SUM(DECODE(L_SESS_DCON_FLOWADD_FAILURE,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_FLOWADD_FAILURE) < T1.SESS_DCON_FLOWADD_FAILURE THEN
                  (V_N32 + L_SESS_DCON_FLOWADD_FAILURE - T1.SESS_DCON_FLOWADD_FAILURE)
                ELSE
                 DECODE(L_SESS_DCON_FLOWADD_FAILURE,0,0,L_SESS_DCON_FLOWADD_FAILURE-T1.SESS_DCON_FLOWADD_FAILURE)
              END))                                                                               SESS_DCON_FLOWADD_FAILURE,
        SUM(DECODE(L_SESS_DCON_INVALID_DEST,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_INVALID_DEST) < T1.SESS_DCON_INVALID_DEST THEN
                  (V_N32 + L_SESS_DCON_INVALID_DEST - T1.SESS_DCON_INVALID_DEST)
                ELSE
                 DECODE(L_SESS_DCON_INVALID_DEST,0,0,L_SESS_DCON_INVALID_DEST-T1.SESS_DCON_INVALID_DEST)
              END))                                                                               SESS_DCON_INVALID_DEST,
        SUM(DECODE(L_SESS_DCON_SRCADDR_VIOLATION,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_SRCADDR_VIOLATION) < T1.SESS_DCON_SRCADDR_VIOLATION THEN
                  (V_N32 + L_SESS_DCON_SRCADDR_VIOLATION - T1.SESS_DCON_SRCADDR_VIOLATION)
                ELSE
                 DECODE(L_SESS_DCON_SRCADDR_VIOLATION,0,0,L_SESS_DCON_SRCADDR_VIOLATION-T1.SESS_DCON_SRCADDR_VIOLATION)
              END))                                                                               SESS_DCON_SRCADDR_VIOLATION,
        SUM(DECODE(L_SESS_DCON_LMAREVOC,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_LMAREVOC) < T1.SESS_DCON_LMAREVOC THEN
                  (V_N32 + L_SESS_DCON_LMAREVOC - T1.SESS_DCON_LMAREVOC)
                ELSE
                 DECODE(L_SESS_DCON_LMAREVOC,0,0,L_SESS_DCON_LMAREVOC-T1.SESS_DCON_LMAREVOC)
              END))                                                                               SESS_DCON_LMAREVOC,
        SUM(DECODE(L_SESS_DCON_DUPREQ,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_DUPREQ) < T1.SESS_DCON_DUPREQ THEN
                  (V_N32 + L_SESS_DCON_DUPREQ - T1.SESS_DCON_DUPREQ)
                ELSE
                 DECODE(L_SESS_DCON_DUPREQ,0,0,L_SESS_DCON_DUPREQ-T1.SESS_DCON_DUPREQ)
              END))                                                                               SESS_DCON_DUPREQ,
        SUM(DECODE(L_SESS_DCON_ADDRASSIGN_FAILURE,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_ADDRASSIGN_FAILURE) < T1.SESS_DCON_ADDRASSIGN_FAILURE THEN
                  (V_N32 + L_SESS_DCON_ADDRASSIGN_FAILURE - T1.SESS_DCON_ADDRASSIGN_FAILURE)
                ELSE
                 DECODE(L_SESS_DCON_ADDRASSIGN_FAILURE,0,0,L_SESS_DCON_ADDRASSIGN_FAILURE-T1.SESS_DCON_ADDRASSIGN_FAILURE)
              END))                                                                               SESS_DCON_ADDRASSIGN_FAILURE,
        SUM(DECODE(L_SESS_DCON_HANDOFF,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_HANDOFF) < T1.SESS_DCON_HANDOFF THEN
                  (V_N32 + L_SESS_DCON_HANDOFF - T1.SESS_DCON_HANDOFF)
                ELSE
                 DECODE(L_SESS_DCON_HANDOFF,0,0,L_SESS_DCON_HANDOFF-T1.SESS_DCON_HANDOFF)
              END))                                                                               SESS_DCON_HANDOFF,
        SUM(DECODE(L_SESS_DCON_MISC,0,0,
              CASE
                WHEN TO_NUMBER(L_SESS_DCON_MISC) < T1.SESS_DCON_MISC THEN
                  (V_N32 + L_SESS_DCON_MISC - T1.SESS_DCON_MISC)
                ELSE
                 DECODE(L_SESS_DCON_MISC,0,0,L_SESS_DCON_MISC-T1.SESS_DCON_MISC)
              END))                                                                               SESS_DCON_MISC,
        SUM(DECODE(L_REAUTH_ATTEMPT,0,0,
              CASE
                WHEN TO_NUMBER(L_REAUTH_ATTEMPT) < T1.REAUTH_ATTEMPT THEN
                  (V_N32 + L_REAUTH_ATTEMPT - T1.REAUTH_ATTEMPT)
                ELSE
                 DECODE(L_REAUTH_ATTEMPT,0,0,L_REAUTH_ATTEMPT-T1.REAUTH_ATTEMPT)
              END))                                                                               REAUTH_ATTEMPT,
        SUM(DECODE(L_REAUTH_SUCCESS,0,0,
              CASE
                WHEN TO_NUMBER(L_REAUTH_SUCCESS) < T1.REAUTH_SUCCESS THEN
                  (V_N32 + L_REAUTH_SUCCESS - T1.REAUTH_SUCCESS)
                ELSE
                 DECODE(L_REAUTH_SUCCESS,0,0,L_REAUTH_SUCCESS-T1.REAUTH_SUCCESS)
              END))                                                                               REAUTH_SUCCESS,
        SUM(DECODE(L_REAUTH_FAILURE,0,0,
              CASE
                WHEN TO_NUMBER(L_REAUTH_FAILURE) < T1.REAUTH_FAILURE THEN
                  (V_N32 + L_REAUTH_FAILURE - T1.REAUTH_FAILURE)
                ELSE
                 DECODE(L_REAUTH_FAILURE,0,0,L_REAUTH_FAILURE-T1.REAUTH_FAILURE)
              END))                                                                               REAUTH_FAILURE,
        SUM(DECODE(L_REAUTHOR_ATTEMPT,0,0,
              CASE
                WHEN TO_NUMBER(L_REAUTHOR_ATTEMPT) < T1.REAUTHOR_ATTEMPT THEN
                  (V_N32 + L_REAUTHOR_ATTEMPT - T1.REAUTHOR_ATTEMPT)
                ELSE
                 DECODE(L_REAUTHOR_ATTEMPT,0,0,L_REAUTHOR_ATTEMPT-T1.REAUTHOR_ATTEMPT)
              END))                                                                               REAUTHOR_ATTEMPT,
        SUM(DECODE(L_REAUTHOR_SUCCESS,0,0,
              CASE
                WHEN TO_NUMBER(L_REAUTHOR_SUCCESS) < T1.REAUTHOR_SUCCESS THEN
                  (V_N32 + L_REAUTHOR_SUCCESS - T1.REAUTHOR_SUCCESS)
                ELSE
                 DECODE(L_REAUTHOR_SUCCESS,0,0,L_REAUTHOR_SUCCESS-T1.REAUTHOR_SUCCESS)
              END))                                                                               REAUTHOR_SUCCESS,
        SUM(DECODE(L_REAUTHOR_FAILURE,0,0,
              CASE
                WHEN TO_NUMBER(L_REAUTHOR_FAILURE) < T1.REAUTHOR_FAILURE THEN
                  (V_N32 + L_REAUTHOR_FAILURE - T1.REAUTHOR_FAILURE)
                ELSE
                 DECODE(L_REAUTHOR_FAILURE,0,0,L_REAUTHOR_FAILURE-T1.REAUTHOR_FAILURE)
              END))                                                                               REAUTHOR_FAILURE,
        SUM(DECODE(L_TXBYTES,0,0,
              CASE
                WHEN TO_NUMBER(L_TXBYTES) < T1.TXBYTES THEN
                  CASE WHEN (V_N32 + L_TXBYTES - T1.TXBYTES) > 4290000000 THEN
                     0
                  ELSE
                    (V_N32 + L_TXBYTES - T1.TXBYTES)
                  END
                ELSE
                 DECODE(L_TXBYTES,0,0,L_TXBYTES-T1.TXBYTES)
              END))                                                                               TXBYTES,
        SUM(DECODE(L_TXPKTS,0,0,
              CASE
                WHEN TO_NUMBER(L_TXPKTS) < T1.TXPKTS THEN
                  (V_N32 + L_TXPKTS - T1.TXPKTS)
                ELSE
                 DECODE(L_TXPKTS,0,0,L_TXPKTS-T1.TXPKTS)
              END))                                                                               TXPKTS,
        SUM(DECODE(L_RXBYTES,0,0,
              CASE
                WHEN TO_NUMBER(L_RXBYTES) < T1.RXBYTES THEN
                  (V_N32 + L_RXBYTES - T1.RXBYTES)
                ELSE
                 DECODE(L_RXBYTES,0,0,L_RXBYTES-T1.RXBYTES)
              END))                                                                               RXBYTES,
        SUM(DECODE(L_RXPKTS,0,0,
              CASE
                WHEN TO_NUMBER(L_RXPKTS) < T1.RXPKTS THEN
                  (V_N32 + L_RXPKTS - T1.RXPKTS)
                ELSE
                 DECODE(L_RXPKTS,0,0,L_RXPKTS-T1.RXPKTS)
              END))                                                                               RXPKTS,
        SUM(DECODE(L_PKT_VIOLATION,0,0,
              CASE
                WHEN TO_NUMBER(L_PKT_VIOLATION) < T1.PKT_VIOLATION THEN
                  (V_N32 + L_PKT_VIOLATION - T1.PKT_VIOLATION)
                ELSE
                 DECODE(L_PKT_VIOLATION,0,0,L_PKT_VIOLATION-T1.PKT_VIOLATION)
              END))                                                                               PKT_VIOLATION,
        SUM(DECODE(L_EAP_RXTTLSRVRPASSTHRU,0,0,
              CASE
                WHEN TO_NUMBER(L_EAP_RXTTLSRVRPASSTHRU) < T1.EAP_RXTTLSRVRPASSTHRU THEN
                  (V_N32 + L_EAP_RXTTLSRVRPASSTHRU - T1.EAP_RXTTLSRVRPASSTHRU)
                ELSE
                 DECODE(L_EAP_RXTTLSRVRPASSTHRU,0,0,L_EAP_RXTTLSRVRPASSTHRU-T1.EAP_RXTTLSRVRPASSTHRU)
              END))                                                                               EAP_RXTTLSRVRPASSTHRU,
        AVG(T1.NUM_QCI1_BEARER_ACTIVE)                                                            NUM_QCI1_BEARER_ACTIVE,
        SUM(DECODE(L_NUM_QCI1_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI1_BEARER_SETUP) < T1.NUM_QCI1_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI1_BEARER_SETUP - T1.NUM_QCI1_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI1_BEARER_SETUP,0,0,L_NUM_QCI1_BEARER_SETUP-T1.NUM_QCI1_BEARER_SETUP)
              END))                                                                               NUM_QCI1_BEARER_SETUP,
        SUM(DECODE(L_NUM_QCI1_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI1_BEARER_RELEASED) < T1.NUM_QCI1_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI1_BEARER_RELEASED - T1.NUM_QCI1_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI1_BEARER_RELEASED,0,0,L_NUM_QCI1_BEARER_RELEASED-T1.NUM_QCI1_BEARER_RELEASED)
              END))                                                                               NUM_QCI1_BEARER_RELEASED,
        AVG(T1.NUM_QCI2_BEARER_ACTIVE)                                                            NUM_QCI2_BEARER_ACTIVE,
                SUM(DECODE(L_NUM_QCI2_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI2_BEARER_SETUP) < T1.NUM_QCI2_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI2_BEARER_SETUP - T1.NUM_QCI2_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI2_BEARER_SETUP,0,0,L_NUM_QCI2_BEARER_SETUP-T1.NUM_QCI2_BEARER_SETUP)
              END))                                                                               NUM_QCI2_BEARER_SETUP,
                SUM(DECODE(L_NUM_QCI2_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI2_BEARER_RELEASED) < T1.NUM_QCI2_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI2_BEARER_RELEASED - T1.NUM_QCI2_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI2_BEARER_RELEASED,0,0,L_NUM_QCI2_BEARER_RELEASED-T1.NUM_QCI2_BEARER_RELEASED)
              END))                                                                               NUM_QCI2_BEARER_RELEASED,
        AVG(T1.NUM_QCI3_BEARER_ACTIVE)                                                            NUM_QCI3_BEARER_ACTIVE,
                SUM(DECODE(L_NUM_QCI3_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI3_BEARER_SETUP) < T1.NUM_QCI3_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI3_BEARER_SETUP - T1.NUM_QCI3_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI3_BEARER_SETUP,0,0,L_NUM_QCI3_BEARER_SETUP-T1.NUM_QCI3_BEARER_SETUP)
              END))                                                                               NUM_QCI3_BEARER_SETUP,
                SUM(DECODE(L_NUM_QCI3_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI3_BEARER_RELEASED) < T1.NUM_QCI3_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI3_BEARER_RELEASED - T1.NUM_QCI3_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI3_BEARER_RELEASED,0,0,L_NUM_QCI3_BEARER_RELEASED-T1.NUM_QCI3_BEARER_RELEASED)
              END))                                                                               NUM_QCI3_BEARER_RELEASED,
        AVG(T1.NUM_QCI4_BEARER_ACTIVE)                                                            NUM_QCI4_BEARER_ACTIVE,
                SUM(DECODE(L_NUM_QCI4_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI4_BEARER_SETUP) < T1.NUM_QCI4_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI4_BEARER_SETUP - T1.NUM_QCI4_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI4_BEARER_SETUP,0,0,L_NUM_QCI4_BEARER_SETUP-T1.NUM_QCI4_BEARER_SETUP)
              END))                                                                               NUM_QCI4_BEARER_SETUP,
                SUM(DECODE(L_NUM_QCI4_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI4_BEARER_RELEASED) < T1.NUM_QCI4_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI4_BEARER_RELEASED - T1.NUM_QCI4_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI4_BEARER_RELEASED,0,0,L_NUM_QCI4_BEARER_RELEASED-T1.NUM_QCI4_BEARER_RELEASED)
              END))                                                                               NUM_QCI4_BEARER_RELEASED,
        AVG(T1.NUM_QCI5_BEARER_ACTIVE)                                                            NUM_QCI5_BEARER_ACTIVE,
        SUM(DECODE(L_NUM_QCI5_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI5_BEARER_SETUP) < T1.NUM_QCI5_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI5_BEARER_SETUP - T1.NUM_QCI5_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI5_BEARER_SETUP,0,0,L_NUM_QCI5_BEARER_SETUP-T1.NUM_QCI5_BEARER_SETUP)
              END))                                                                               NUM_QCI5_BEARER_SETUP,
        SUM(DECODE(L_NUM_QCI5_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI5_BEARER_RELEASED) < T1.NUM_QCI5_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI5_BEARER_RELEASED - T1.NUM_QCI5_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI5_BEARER_RELEASED,0,0,L_NUM_QCI5_BEARER_RELEASED-T1.NUM_QCI5_BEARER_RELEASED)
              END))                                                                               NUM_QCI5_BEARER_RELEASED,
        AVG(NUM_QCI6_BEARER_ACTIVE)                                                               NUM_QCI6_BEARER_ACTIVE,
        SUM(DECODE(L_NUM_QCI6_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI6_BEARER_SETUP) < T1.NUM_QCI6_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI6_BEARER_SETUP - T1.NUM_QCI6_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI6_BEARER_SETUP,0,0,L_NUM_QCI6_BEARER_SETUP-T1.NUM_QCI6_BEARER_SETUP)
              END))                                                                               NUM_QCI6_BEARER_SETUP,
        SUM(DECODE(L_NUM_QCI6_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI6_BEARER_RELEASED) < T1.NUM_QCI6_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI6_BEARER_RELEASED - T1.NUM_QCI6_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI6_BEARER_RELEASED,0,0,L_NUM_QCI6_BEARER_RELEASED-T1.NUM_QCI6_BEARER_RELEASED)
              END))                                                                               NUM_QCI6_BEARER_RELEASED,
        AVG(NUM_QCI7_BEARER_ACTIVE)                                                               NUM_QCI7_BEARER_ACTIVE,
        SUM(DECODE(L_NUM_QCI7_BEARER_SETUP,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI7_BEARER_SETUP) < T1.NUM_QCI7_BEARER_SETUP THEN
                  (V_N32 + L_NUM_QCI7_BEARER_SETUP - T1.NUM_QCI7_BEARER_SETUP)
                ELSE
                 DECODE(L_NUM_QCI7_BEARER_SETUP,0,0,L_NUM_QCI7_BEARER_SETUP-T1.NUM_QCI7_BEARER_SETUP)
              END))                                                                               NUM_QCI7_BEARER_SETUP,
        SUM(DECODE(L_NUM_QCI7_BEARER_RELEASED,0,0,
              CASE
                WHEN TO_NUMBER(L_NUM_QCI7_BEARER_RELEASED) < T1.NUM_QCI7_BEARER_RELEASED THEN
                  (V_N32 + L_NUM_QCI7_BEARER_RELEASED - T1.NUM_QCI7_BEARER_RELEASED)
                ELSE
                 DECODE(L_NUM_QCI7_BEARER_RELEASED,0,0,L_NUM_QCI7_BEARER_RELEASED-T1.NUM_QCI7_BEARER_RELEASED)
              END))                                                                               NUM_QCI7_BEARER_RELEASED
  FROM (SELECT T1.FECHA,
               T1.EQUIPO,
               T1.VPNNAME,
               T1.VPNID,
               T1.SERVNAME,
               T1.SERVID,
             T1.PDN_IPV4_ACTIVE,
             PDN_IPV4_SETUP,
             NVL(LEAD(PDN_IPV4_SETUP)     OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PDN_IPV4_SETUP,
             PDN_IPV4_RELEASED,
             NVL(LEAD(PDN_IPV4_RELEASED) OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PDN_IPV4_RELEASED,
             T1.PDN_IPV6_ACTIVE,
             PDN_IPV6_SETUP,
             NVL(LEAD(PDN_IPV6_SETUP)     OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PDN_IPV6_SETUP,
             PDN_IPV6_RELEASED,
             NVL(LEAD(PDN_IPV6_RELEASED) OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PDN_IPV6_RELEASED,
             T1.PDN_IPV4V6_ACTIVE,
             PDN_IPV4V6_SETUP,
             NVL(LEAD(PDN_IPV4V6_SETUP) OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PDN_IPV4V6_SETUP,
             PDN_IPV4V6_RELEASED,
             NVL(LEAD(PDN_IPV4V6_RELEASED) OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PDN_IPV4V6_RELEASED,
             NUM_GTP_BEARER_MODIFIED,
             NVL(LEAD(NUM_GTP_BEARER_MODIFIED) OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_NUM_GTP_BEARER_MODIFIED,
             T1.NUM_GTP_DB_ACTIVE,
             NUM_GTP_DB_RELEASED,
             NVL(LEAD(NUM_GTP_DB_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                             T1.VPNID,
                                                             T1.SERVID ORDER BY T1.FECHA),0)             L_NUM_GTP_DB_RELEASED,
             T1.CURSESS,
             T1.CURSES_PMIPV6_IPV4,
             T1.CURSES_PMIPV6_IPV6,
             T1.CURSES_PMIPV6_IPV4V6,
             T1.CURSES_GTP_IPV4,
             TOTPMIPV6_SUCCESS,
             NVL(LEAD(TOTPMIPV6_SUCCESS) OVER(PARTITION BY T1.EQUIPO,
                                                           T1.VPNID,
                                                           T1.SERVID ORDER BY T1.FECHA),0)                L_TOTPMIPV6_SUCCESS,
             TOTPMIPV6_FAILURE,
             NVL(LEAD(TOTPMIPV6_FAILURE) OVER(PARTITION BY T1.EQUIPO,
                                                           T1.VPNID,
                                                           T1.SERVID ORDER BY T1.FECHA),0)                L_TOTPMIPV6_FAILURE,
             PGW_FALLBACK_ATTEMPTED,
             NVL(LEAD(PGW_FALLBACK_ATTEMPTED) OVER(PARTITION BY T1.EQUIPO,
                                                                T1.VPNID,
                                                                T1.SERVID ORDER BY T1.FECHA),0)           L_PGW_FALLBACK_ATTEMPTED,
             PGW_FALLBACK_SUCCEEDED,
             NVL(LEAD(PGW_FALLBACK_SUCCEEDED) OVER(PARTITION BY T1.EQUIPO,
                                                                T1.VPNID,
                                                                T1.SERVID ORDER BY T1.FECHA),0)           L_PGW_FALLBACK_SUCCEEDED,
             PGW_FALLBACK_FAILED,
             NVL(LEAD(PGW_FALLBACK_FAILED) OVER(PARTITION BY T1.EQUIPO,
                                                             T1.VPNID,
                                                             T1.SERVID ORDER BY T1.FECHA),0)              L_PGW_FALLBACK_FAILED,
             PGW_FALLBACK_NO_ALTERNATE_PGW,
             NVL(LEAD(PGW_FALLBACK_NO_ALTERNATE_PGW) OVER(PARTITION BY T1.EQUIPO, T1.VPNID, T1.SERVID
                                                              ORDER BY T1.FECHA),0)                      L_PGW_FALLB_NO_ALTERNATE_PGW,
             TOTGTP_ATTEMPT,
             NVL(LEAD(TOTGTP_ATTEMPT) OVER(PARTITION BY T1.EQUIPO,
                                                        T1.VPNID,
                                                        T1.SERVID ORDER BY T1.FECHA),0)                   L_TOTGTP_ATTEMPT,
             TOTGTP_SUCCESS,
             NVL(LEAD(TOTGTP_SUCCESS) OVER(PARTITION BY T1.EQUIPO,
                                                        T1.VPNID,
                                                        T1.SERVID ORDER BY T1.FECHA),0)                   L_TOTGTP_SUCCESS,
             TOTGTP_FAILURE,
             NVL(LEAD(TOTGTP_FAILURE) OVER(PARTITION BY T1.EQUIPO,
                                                        T1.VPNID,
                                                        T1.SERVID ORDER BY T1.FECHA),0)                   L_TOTGTP_FAILURE,
             DISCONNECT_TOTAL,
             NVL(LEAD(DISCONNECT_TOTAL) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_DISCONNECT_TOTAL,
             DISCONNECT_LOCAL,
             NVL(LEAD(DISCONNECT_LOCAL) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_DISCONNECT_LOCAL,
             DISCONNECT_UE,
             NVL(LEAD(DISCONNECT_UE)    OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_DISCONNECT_UE,
             DISCONNECT_PGW,
             NVL(LEAD(DISCONNECT_PGW)   OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_DISCONNECT_PGW,
             DISCONNECT_REMOTE,
             NVL(LEAD(DISCONNECT_REMOTE) OVER(PARTITION BY T1.EQUIPO,
                                                           T1.VPNID,
                                                           T1.SERVID ORDER BY T1.FECHA),0)                L_DISCONNECT_REMOTE,
             SESS_DCON_REMOTE,
             NVL(LEAD(SESS_DCON_REMOTE) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_REMOTE,
             SESS_DCON_ADMIN,
             NVL(LEAD(SESS_DCON_ADMIN)  OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_ADMIN,
             SESS_DCON_IDLE_TIMEOUT,
             NVL(LEAD(SESS_DCON_IDLE_TIMEOUT) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_IDLE_TIMEOUT,
             SESS_DCON_ABS_TIMEOUT,
             NVL(LEAD(SESS_DCON_ABS_TIMEOUT) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_ABS_TIMEOUT,
             SESS_DCON_LONGDUR_TIMEOUT,
             NVL(LEAD(SESS_DCON_LONGDUR_TIMEOUT) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_LONGDUR_TIMEOUT,
             SESS_DCON_SESSSETUP_TIMEOUT,
             NVL(LEAD(SESS_DCON_SESSSETUP_TIMEOUT) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_SESSSETUP_TIMEOUT,
             SESS_DCON_NORESOURCE,
             NVL(LEAD(SESS_DCON_NORESOURCE) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_NORESOURCE,
             SESS_DCON_AUTHFAIL,
             NVL(LEAD(SESS_DCON_AUTHFAIL) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_AUTHFAIL,
             SESS_DCON_FLOWADD_FAILURE,
             NVL(LEAD(SESS_DCON_FLOWADD_FAILURE) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_FLOWADD_FAILURE,
             SESS_DCON_INVALID_DEST,
             NVL(LEAD(SESS_DCON_INVALID_DEST) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_INVALID_DEST,
             SESS_DCON_SRCADDR_VIOLATION,
             NVL(LEAD(SESS_DCON_SRCADDR_VIOLATION) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_SRCADDR_VIOLATION,
             SESS_DCON_LMAREVOC,
             NVL(LEAD(SESS_DCON_LMAREVOC) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_LMAREVOC,
             SESS_DCON_DUPREQ,
             NVL(LEAD(SESS_DCON_DUPREQ) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_DUPREQ,
             SESS_DCON_ADDRASSIGN_FAILURE,
             NVL(LEAD(SESS_DCON_ADDRASSIGN_FAILURE) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_ADDRASSIGN_FAILURE,
             SESS_DCON_HANDOFF,
             NVL(LEAD(SESS_DCON_HANDOFF) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_HANDOFF,
             SESS_DCON_MISC,
             NVL(LEAD(SESS_DCON_MISC) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_SESS_DCON_MISC,
             REAUTH_ATTEMPT,
             NVL(LEAD(REAUTH_ATTEMPT)   OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_REAUTH_ATTEMPT,
             REAUTH_SUCCESS,
             NVL(LEAD(REAUTH_SUCCESS)   OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_REAUTH_SUCCESS,
             REAUTH_FAILURE,
             NVL(LEAD(REAUTH_FAILURE)   OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_REAUTH_FAILURE,
             REAUTHOR_ATTEMPT,
             NVL(LEAD(REAUTHOR_ATTEMPT) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_REAUTHOR_ATTEMPT,
             REAUTHOR_SUCCESS,
             NVL(LEAD(REAUTHOR_SUCCESS) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_REAUTHOR_SUCCESS,
             REAUTHOR_FAILURE,
             NVL(LEAD(REAUTHOR_FAILURE) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_REAUTHOR_FAILURE,
             TXBYTES,
             NVL(LEAD(TXBYTES)          OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_TXBYTES,
             TXPKTS,
             NVL(LEAD(TXPKTS)           OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_TXPKTS,
             RXBYTES,
             NVL(LEAD(RXBYTES)          OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_RXBYTES,
             RXPKTS,
             NVL(LEAD(RXPKTS)           OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_RXPKTS,
             PKT_VIOLATION,
             NVL(LEAD(PKT_VIOLATION)    OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_PKT_VIOLATION,
             EAP_RXTTLSRVRPASSTHRU,
             NVL(LEAD(EAP_RXTTLSRVRPASSTHRU) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_EAP_RXTTLSRVRPASSTHRU,
             NUM_QCI1_BEARER_ACTIVE,
             NUM_QCI1_BEARER_SETUP,
             NVL(LEAD(NUM_QCI1_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI1_BEARER_SETUP,
             NUM_QCI1_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI1_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI1_BEARER_RELEASED,
             T4.NUM_QCI2_BEARER_ACTIVE,
             NUM_QCI2_BEARER_SETUP,
             NVL(LEAD(NUM_QCI2_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI2_BEARER_SETUP,
             NUM_QCI2_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI2_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI2_BEARER_RELEASED,
             T4.NUM_QCI3_BEARER_ACTIVE,
             NUM_QCI3_BEARER_SETUP,
             NVL(LEAD(NUM_QCI3_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI3_BEARER_SETUP,
             T4.NUM_QCI3_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI3_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI3_BEARER_RELEASED,
             T4.NUM_QCI4_BEARER_ACTIVE,
             NUM_QCI4_BEARER_SETUP,
             NVL(LEAD(NUM_QCI4_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI4_BEARER_SETUP,
             NUM_QCI4_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI4_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI4_BEARER_RELEASED,
             T4.NUM_QCI5_BEARER_ACTIVE,
             NUM_QCI5_BEARER_SETUP,
             NVL(LEAD(NUM_QCI5_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI5_BEARER_SETUP,
             NUM_QCI5_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI5_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI5_BEARER_RELEASED,
             T4.NUM_QCI6_BEARER_ACTIVE,
             NUM_QCI6_BEARER_SETUP,
             NVL(LEAD(NUM_QCI6_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI6_BEARER_SETUP,
             NUM_QCI6_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI6_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI6_BEARER_RELEASED,
             NUM_QCI7_BEARER_ACTIVE,
             NUM_QCI7_BEARER_SETUP,
             NVL(LEAD(NUM_QCI7_BEARER_SETUP) OVER(PARTITION BY T1.EQUIPO,
                                                          T1.VPNID,
                                                          T1.SERVID ORDER BY T1.FECHA),0)                 L_NUM_QCI7_BEARER_SETUP,
             NUM_QCI7_BEARER_RELEASED,
             NVL(LEAD(NUM_QCI7_BEARER_RELEASED) OVER(PARTITION BY T1.EQUIPO,
                                                            T1.VPNID,
                                                            T1.SERVID ORDER BY T1.FECHA),0)               L_NUM_QCI7_BEARER_RELEASED
        FROM CISCO_GGSN_EPDG_SCH1_RAW_VW@SMART.WORLD T1,
             CISCO_GGSN_EPDG_SCH3_RAW_VW@SMART.WORLD T2,
             CISCO_GGSN_EPDG_SCH4_RAW_VW@SMART.WORLD T3,
             CISCO_GGSN_EPDG_SCH7_RAW_VW@SMART.WORLD T4
       WHERE T1.FECHA = T2.FECHA
         AND T1.VPNID = T2.VPNID
         AND T1.SERVID = T2.SERVID
         AND T1.FECHA = T3.FECHA
         AND T1.VPNID = T3.VPNID
         AND T1.SERVID = T3.SERVID
         AND T1.FECHA = T4.FECHA
         AND T1.VPNID = T4.VPNID
         AND T1.SERVID = T4.SERVID
         AND T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                          AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')
         ) T1
GROUP BY TRUNC(T1.FECHA, 'HH24'),
         T1.EQUIPO,
         T1.VPNNAME,
         T1.VPNID,
         T1.SERVNAME,
         T1.SERVID
         ) O
--         CISCO_GGSN_EPDG_HOUR D
   WHERE NOT EXISTS(SELECT 1
                      FROM CISCO_GGSN_EPDG_HOUR D
                     WHERE O.VPNID = D.VPNID
                     	 AND O.SERVID = D.SERVID
                       AND O.FECHA = D.FECHA);



 BEGIN
 OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO CISCO_GGSN_EPDG_HOUR VALUES T_ARRAY_COL (I);
    EXCEPTION
      WHEN DML_ERRORS THEN
        L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
                FOR I IN 1 .. L_ERRORS
                LOOP
                    L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                    L_MSG   := SQLERRM(-L_ERRNO);
                    L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_HOUR',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

                END LOOP;
    END;
    EXIT WHEN CUR%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_HOUR',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_EPDG_DAY (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 26.12.2016.
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@
-- Actualizacion: Matias Orquera. Fecha: 09.01.2017. Motivo: Se cambia sumarizaciones por promedios.

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);


TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_EPDG_DAY%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
 SELECT TRUNC(T1.FECHA)                                                        FECHA,
        T1.EQUIPO                                                              EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        AVG(T1.PDN_IPV4_ACTIVE)                                                PDN_IPV4_ACTIVE,
        AVG(T1.PDN_IPV4_SETUP)                                                 PDN_IPV4_SETUP,
        AVG(T1.PDN_IPV4_RELEASED)                                              PDN_IPV4_RELEASED,
        AVG(T1.PDN_IPV6_ACTIVE)                                                PDN_IPV6_ACTIVE,
        AVG(T1.PDN_IPV6_SETUP)                                                 PDN_IPV6_SETUP,
        AVG(T1.PDN_IPV6_RELEASED)                                              PDN_IPV6_RELEASED,
        AVG(T1.PDN_IPV4V6_ACTIVE)                                              PDN_IPV4V6_ACTIVE,
        AVG(T1.PDN_IPV4V6_SETUP)                                               PDN_IPV4V6_SETUP,
        AVG(T1.PDN_IPV4V6_RELEASED)                                            PDN_IPV4V6_RELEASED,
        AVG(T1.NUM_GTP_BEARER_MODIFIED)                                        NUM_GTP_BEARER_MODIFIED,
        AVG(T1.NUM_GTP_DB_ACTIVE)                                              NUM_GTP_DB_ACTIVE,
        AVG(T1.NUM_GTP_DB_RELEASED)                                            NUM_GTP_DB_RELEASED,
        AVG(T1.CURSESS)                                                        CURSESS,
        AVG(T1.CURSES_PMIPV6_IPV4)                                             CURSES_PMIPV6_IPV4,
        AVG(T1.CURSES_PMIPV6_IPV6)                                             CURSES_PMIPV6_IPV6,
        AVG(T1.CURSES_PMIPV6_IPV4V6)                                           CURSES_PMIPV6_IPV4V6,
        AVG(T1.CURSES_GTP_IPV4)                                                CURSES_GTP_IPV4,
        AVG(T1.TOTPMIPV6_SUCCESS)                                              TOTPMIPV6_SUCCESS,
        AVG(T1.TOTPMIPV6_FAILURE)                                              TOTPMIPV6_FAILURE,
        AVG(T1.PGW_FALLBACK_ATTEMPTED)                                         PGW_FALLBACK_ATTEMPTED,
        AVG(T1.PGW_FALLBACK_SUCCEEDED)                                         PGW_FALLBACK_SUCCEEDED,
        AVG(T1.PGW_FALLBACK_FAILED)                                            PGW_FALLBACK_FAILED,
        AVG(T1.PGW_FALLBACK_NO_ALTERNATE_PGW)                                  PGW_FALLBACK_NO_ALTERNATE_PGW,
        AVG(T1.TOTGTP_ATTEMPT)                                                 TOTGTP_ATTEMPT,
        AVG(T1.TOTGTP_SUCCESS)                                                 TOTGTP_SUCCESS,
        AVG(T1.TOTGTP_FAILURE)                                                 TOTGTP_FAILURE,
        AVG(T1.DISCONNECT_TOTAL)                                               DISCONNECT_TOTAL,
        AVG(T1.DISCONNECT_LOCAL)                                               DISCONNECT_LOCAL,
        AVG(T1.DISCONNECT_UE)                                                  DISCONNECT_UE,
        AVG(T1.DISCONNECT_PGW)                                                 DISCONNECT_PGW,
        AVG(T1.DISCONNECT_REMOTE)                                              DISCONNECT_REMOTE,
        AVG(T1.SESS_DCON_REMOTE)                                               SESS_DCON_REMOTE,
        AVG(T1.SESS_DCON_ADMIN)                                                SESS_DCON_ADMIN,
        AVG(T1.SESS_DCON_IDLE_TIMEOUT)                                         SESS_DCON_IDLE_TIMEOUT,
        AVG(T1.SESS_DCON_ABS_TIMEOUT)                                          SESS_DCON_ABS_TIMEOUT,
        AVG(T1.SESS_DCON_LONGDUR_TIMEOUT)                                      SESS_DCON_LONGDUR_TIMEOUT,
        AVG(T1.SESS_DCON_SESSSETUP_TIMEOUT)                                    SESS_DCON_SESSSETUP_TIMEOUT,
        AVG(T1.SESS_DCON_NORESOURCE)                                           SESS_DCON_NORESOURCE,
        AVG(T1.SESS_DCON_AUTHFAIL)                                             SESS_DCON_AUTHFAIL,
        AVG(T1.SESS_DCON_FLOWADD_FAILURE)                                      SESS_DCON_FLOWADD_FAILURE,
        AVG(T1.SESS_DCON_INVALID_DEST)                                         SESS_DCON_INVALID_DEST,
        AVG(T1.SESS_DCON_SRCADDR_VIOLATION)                                    SESS_DCON_SRCADDR_VIOLATION,
        AVG(T1.SESS_DCON_LMAREVOC)                                             SESS_DCON_LMAREVOC,
        AVG(T1.SESS_DCON_DUPREQ)                                               SESS_DCON_DUPREQ,
        AVG(T1.SESS_DCON_ADDRASSIGN_FAILURE)                                   SESS_DCON_ADDRASSIGN_FAILURE,
        AVG(T1.SESS_DCON_HANDOFF)                                              SESS_DCON_HANDOFF,
        AVG(T1.SESS_DCON_MISC)                                                 SESS_DCON_MISC,
        AVG(T1.REAUTH_ATTEMPT)                                                 REAUTH_ATTEMPT,
        AVG(T1.REAUTH_SUCCESS)                                                 REAUTH_SUCCESS,
        AVG(T1.REAUTH_FAILURE)                                                 REAUTH_FAILURE,
        AVG(T1.REAUTHOR_ATTEMPT)                                               REAUTHOR_ATTEMPT,
        AVG(T1.REAUTHOR_SUCCESS)                                               REAUTHOR_SUCCESS,
        AVG(T1.REAUTHOR_FAILURE)                                               REAUTHOR_FAILURE,
        AVG(T1.TXBYTES)                                                        TXBYTES,
        AVG(T1.TXPKTS)                                                         TXPKTS,
        AVG(T1.RXBYTES)                                                        RXBYTES,
        AVG(T1.RXPKTS)                                                         RXPKTS,
        AVG(T1.PKT_VIOLATION)                                                  PKT_VIOLATION,
        AVG(T1.EAP_RXTTLSRVRPASSTHRU)                                          EAP_RXTTLSRVRPASSTHRU,
        AVG(T1.NUM_QCI1_BEARER_ACTIVE)                                         NUM_QCI1_BEARER_ACTIVE,
        AVG(T1.NUM_QCI1_BEARER_SETUP)                                          NUM_QCI1_BEARER_SETUP,
        AVG(T1.NUM_QCI1_BEARER_RELEASED)                                       NUM_QCI1_BEARER_RELEASED,
        AVG(T1.NUM_QCI2_BEARER_ACTIVE)                                         NUM_QCI2_BEARER_ACTIVE,
        AVG(T1.NUM_QCI2_BEARER_SETUP)                                          NUM_QCI2_BEARER_SETUP,
        AVG(T1.NUM_QCI2_BEARER_RELEASED)                                       NUM_QCI2_BEARER_RELEASED,
        AVG(T1.NUM_QCI3_BEARER_ACTIVE)                                         NUM_QCI3_BEARER_ACTIVE,
        AVG(T1.NUM_QCI3_BEARER_SETUP)                                          NUM_QCI3_BEARER_SETUP,
        AVG(T1.NUM_QCI3_BEARER_RELEASED)                                       NUM_QCI3_BEARER_RELEASED,
        AVG(T1.NUM_QCI4_BEARER_ACTIVE)                                         NUM_QCI4_BEARER_ACTIVE,
        AVG(T1.NUM_QCI4_BEARER_SETUP)                                          NUM_QCI4_BEARER_SETUP,
        AVG(T1.NUM_QCI4_BEARER_RELEASED)                                       NUM_QCI4_BEARER_RELEASED,
        AVG(T1.NUM_QCI5_BEARER_ACTIVE)                                         NUM_QCI5_BEARER_ACTIVE,
        AVG(T1.NUM_QCI5_BEARER_SETUP)                                          NUM_QCI5_BEARER_SETUP,
        AVG(T1.NUM_QCI5_BEARER_RELEASED)                                       NUM_QCI5_BEARER_RELEASED,
        AVG(T1.NUM_QCI6_BEARER_ACTIVE)                                         NUM_QCI6_BEARER_ACTIVE,
        AVG(T1.NUM_QCI6_BEARER_SETUP)                                          NUM_QCI6_BEARER_SETUP,
        AVG(T1.NUM_QCI6_BEARER_RELEASED)                                       NUM_QCI6_BEARER_RELEASED,
        AVG(T1.NUM_QCI7_BEARER_ACTIVE)                                         NUM_QCI7_BEARER_ACTIVE,
        AVG(T1.NUM_QCI7_BEARER_SETUP)                                          NUM_QCI7_BEARER_SETUP,
        AVG(T1.NUM_QCI7_BEARER_RELEASED)                                       NUM_QCI7_BEARER_RELEASED,
        AVG(T1.APN_EPDG_GTPV2_SUCCESS_RATE)                                    APN_EPDG_GTPV2_SUCCESS_RATE,
        AVG(T1.TX_THROUGHPUT)                                                  TX_THROUGHPUT,
        AVG(T1.RX_THROUGHPUT)                                                  RX_THROUGHPUT,
        AVG(T1.APN_EPDG_SYS_THROUGHPUT)                                        APN_EPDG_SYS_THROUGHPUT
    FROM CISCO_GGSN_EPDG_HOUR T1
         --CISCO_GGSN_EPDG_DAY T2
   WHERE /*TRUNC(T1.FECHA) = T2.FECHA (+)
     AND T1.VPNID = T2.VPNID (+)
     AND T1.SERVID = T2.SERVID (+)
     AND */T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                      AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+86399/86400
     AND NOT EXISTS(SELECT 1
                      FROM CISCO_GGSN_EPDG_DAY T2
                     WHERE T1.VPNID = T2.VPNID
                       AND T1.SERVID = T2.SERVID
                       AND TRUNC(T1.FECHA) = T2.FECHA)
GROUP BY TRUNC(T1.FECHA),
         T1.EQUIPO,
         T1.VPNNAME,
         T1.VPNID,
         T1.SERVNAME,
         T1.SERVID;

 BEGIN
 OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO CISCO_GGSN_EPDG_DAY VALUES T_ARRAY_COL (I);
    EXCEPTION
      WHEN DML_ERRORS THEN
        L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
                FOR I IN 1 .. L_ERRORS
                LOOP
                    L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                    L_MSG   := SQLERRM(-L_ERRNO);
                    L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_DAY',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

                END LOOP;
    END;
    EXIT WHEN CUR%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_DAY',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_EPDG_BH (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 27.12.2016.
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);



TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_EPDG_BH%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
 SELECT TRUNC(T1.FECHA)                                                   FECHA,
        T1.EQUIPO                                                         EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        T1.PDN_IPV4_ACTIVE,
        T1.PDN_IPV4_SETUP,
        T1.PDN_IPV4_RELEASED,
        T1.PDN_IPV6_ACTIVE,
        T1.PDN_IPV6_SETUP,
        T1.PDN_IPV6_RELEASED,
        T1.PDN_IPV4V6_ACTIVE,
        T1.PDN_IPV4V6_SETUP,
        T1.PDN_IPV4V6_RELEASED,
        T1.NUM_GTP_BEARER_MODIFIED,
        T1.NUM_GTP_DB_ACTIVE,
        T1.NUM_GTP_DB_RELEASED,
        T1.CURSESS,
        T1.CURSES_PMIPV6_IPV4,
        T1.CURSES_PMIPV6_IPV6,
        T1.CURSES_PMIPV6_IPV4V6,
        T1.CURSES_GTP_IPV4,
        T1.TOTPMIPV6_SUCCESS,
        T1.TOTPMIPV6_FAILURE,
        T1.PGW_FALLBACK_ATTEMPTED,
        T1.PGW_FALLBACK_SUCCEEDED,
        T1.PGW_FALLBACK_FAILED,
        T1.PGW_FALLBACK_NO_ALTERNATE_PGW,
        T1.TOTGTP_ATTEMPT,
        T1.TOTGTP_SUCCESS,
        T1.TOTGTP_FAILURE,
        T1.DISCONNECT_TOTAL,
        T1.DISCONNECT_LOCAL,
        T1.DISCONNECT_UE,
        T1.DISCONNECT_PGW,
        T1.DISCONNECT_REMOTE,
        T1.SESS_DCON_REMOTE,
        T1.SESS_DCON_ADMIN,
        T1.SESS_DCON_IDLE_TIMEOUT,
        T1.SESS_DCON_ABS_TIMEOUT,
        T1.SESS_DCON_LONGDUR_TIMEOUT,
        T1.SESS_DCON_SESSSETUP_TIMEOUT,
        T1.SESS_DCON_NORESOURCE,
        T1.SESS_DCON_AUTHFAIL,
        T1.SESS_DCON_FLOWADD_FAILURE,
        T1.SESS_DCON_INVALID_DEST,
        T1.SESS_DCON_SRCADDR_VIOLATION,
        T1.SESS_DCON_LMAREVOC,
        T1.SESS_DCON_DUPREQ,
        T1.SESS_DCON_ADDRASSIGN_FAILURE,
        T1.SESS_DCON_HANDOFF,
        T1.SESS_DCON_MISC,
        T1.REAUTH_ATTEMPT,
        T1.REAUTH_SUCCESS,
        T1.REAUTH_FAILURE,
        T1.REAUTHOR_ATTEMPT,
        T1.REAUTHOR_SUCCESS,
        T1.REAUTHOR_FAILURE,
        T1.TXBYTES,
        T1.TXPKTS,
        T1.RXBYTES,
        T1.RXPKTS,
        T1.PKT_VIOLATION,
        T1.EAP_RXTTLSRVRPASSTHRU,
        T1.NUM_QCI1_BEARER_ACTIVE,
        T1.NUM_QCI1_BEARER_SETUP,
        T1.NUM_QCI1_BEARER_RELEASED,
        T1.NUM_QCI2_BEARER_ACTIVE,
        T1.NUM_QCI2_BEARER_SETUP,
        T1.NUM_QCI2_BEARER_RELEASED,
        T1.NUM_QCI3_BEARER_ACTIVE,
        T1.NUM_QCI3_BEARER_SETUP,
        T1.NUM_QCI3_BEARER_RELEASED,
        T1.NUM_QCI4_BEARER_ACTIVE,
        T1.NUM_QCI4_BEARER_SETUP,
        T1.NUM_QCI4_BEARER_RELEASED,
        T1.NUM_QCI5_BEARER_ACTIVE,
        T1.NUM_QCI5_BEARER_SETUP,
        T1.NUM_QCI5_BEARER_RELEASED,
        T1.NUM_QCI6_BEARER_ACTIVE,
        T1.NUM_QCI6_BEARER_SETUP,
        T1.NUM_QCI6_BEARER_RELEASED,
        T1.NUM_QCI7_BEARER_ACTIVE,
        T1.NUM_QCI7_BEARER_SETUP,
        T1.NUM_QCI7_BEARER_RELEASED,
        T1.APN_EPDG_GTPV2_SUCCESS_RATE,
        T1.TX_THROUGHPUT,
        T1.RX_THROUGHPUT,
        T1.APN_EPDG_SYS_THROUGHPUT
   FROM CISCO_GGSN_EPDG_HOUR T1,
        (SELECT FECHA, VPNID, SERVID, VALOR
        FROM (
              SELECT F1.FECHA,
                     F1.VPNID,
                     F1.SERVID,
                     F1.RX_THROUGHPUT VALOR,
                     ROW_NUMBER() OVER (PARTITION BY TRUNC(F1.FECHA),
                                                     F1.VPNID,
                                                     F1.SERVID
                                            ORDER BY (F1.RX_THROUGHPUT) DESC,
                                                     F1.FECHA DESC) SEQNUM
              FROM (
                     SELECT T1.FECHA, T1.VPNID, T1.SERVID, T1.RX_THROUGHPUT
                     FROM CISCO_GGSN_EPDG_HOUR T1
                     WHERE FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                                     AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + (86399 / 86400)
                   ) F1
              )
        WHERE SEQNUM = 1
       ) AUX,
       CISCO_GGSN_EPDG_BH T2
 WHERE T1.FECHA = AUX.FECHA
   AND T1.VPNID = AUX.VPNID
   AND T1.SERVID = AUX.SERVID
   AND TRUNC(T1.FECHA) = T2.FECHA (+)
   AND T1.VPNID = T2.VPNID (+)
   AND T1.SERVID = T2.SERVID (+)
   AND T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                    AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND T2.VPNID IS NULL
   AND T2.SERVID IS NULL;

BEGIN

OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
LOOP
  FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
  BEGIN
    FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
      INSERT INTO CISCO_GGSN_EPDG_BH VALUES T_ARRAY_COL (I);
  EXCEPTION
    WHEN DML_ERRORS THEN
      -- CAPTURE EXCEPTIONS TO PERFORM OPERATIONS DML
           L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
              FOR I IN 1 .. L_ERRORS
              LOOP
                  L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                  L_MSG   := SQLERRM(-L_ERRNO);
                  L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;
                  
                  G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_BH',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

              END LOOP;
  -- END --
  END;
  EXIT WHEN CUR%NOTFOUND;
END LOOP;
COMMIT;
CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_BH',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_EPDG_ISABHW (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 28.12.2016.
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);


TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_EPDG_ISABHW%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
 SELECT TRUNC(T1.FECHA,'DAY')                          FECHA,
        T1.EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        ROUND(AVG(T1.PDN_IPV4_ACTIVE)              ,4) PDN_IPV4_ACTIVE,
        ROUND(AVG(T1.PDN_IPV4_SETUP)               ,4) PDN_IPV4_SETUP,
        ROUND(AVG(T1.PDN_IPV4_RELEASED)            ,4) PDN_IPV4_RELEASED,
        ROUND(AVG(T1.PDN_IPV6_ACTIVE)              ,4) PDN_IPV6_ACTIVE,
        ROUND(AVG(T1.PDN_IPV6_SETUP)               ,4) PDN_IPV6_SETUP,
        ROUND(AVG(T1.PDN_IPV6_RELEASED)            ,4) PDN_IPV6_RELEASED,
        ROUND(AVG(T1.PDN_IPV4V6_ACTIVE)            ,4) PDN_IPV4V6_ACTIVE,
        ROUND(AVG(T1.PDN_IPV4V6_SETUP)             ,4) PDN_IPV4V6_SETUP,
        ROUND(AVG(T1.PDN_IPV4V6_RELEASED)          ,4) PDN_IPV4V6_RELEASED,
        ROUND(AVG(T1.NUM_GTP_BEARER_MODIFIED)      ,4) NUM_GTP_BEARER_MODIFIED,
        ROUND(AVG(T1.NUM_GTP_DB_ACTIVE)            ,4) NUM_GTP_DB_ACTIVE,
        ROUND(AVG(T1.NUM_GTP_DB_RELEASED)          ,4) NUM_GTP_DB_RELEASED,
        ROUND(AVG(T1.CURSESS)                      ,4) CURSESS,
        ROUND(AVG(T1.CURSES_PMIPV6_IPV4)           ,4) CURSES_PMIPV6_IPV4,
        ROUND(AVG(T1.CURSES_PMIPV6_IPV6)           ,4) CURSES_PMIPV6_IPV6,
        ROUND(AVG(T1.CURSES_PMIPV6_IPV4V6)         ,4) CURSES_PMIPV6_IPV4V6,
        ROUND(AVG(T1.CURSES_GTP_IPV4)              ,4) CURSES_GTP_IPV4,
        ROUND(AVG(T1.TOTPMIPV6_SUCCESS)            ,4) TOTPMIPV6_SUCCESS,
        ROUND(AVG(T1.TOTPMIPV6_FAILURE)            ,4) TOTPMIPV6_FAILURE,
        ROUND(AVG(T1.PGW_FALLBACK_ATTEMPTED)       ,4) PGW_FALLBACK_ATTEMPTED,
        ROUND(AVG(T1.PGW_FALLBACK_SUCCEEDED)       ,4) PGW_FALLBACK_SUCCEEDED,
        ROUND(AVG(T1.PGW_FALLBACK_FAILED)          ,4) PGW_FALLBACK_FAILED,
        ROUND(AVG(T1.PGW_FALLBACK_NO_ALTERNATE_PGW),4) PGW_FALLBACK_NO_ALTERNATE_PGW,
        ROUND(AVG(T1.TOTGTP_ATTEMPT)               ,4) TOTGTP_ATTEMPT,
        ROUND(AVG(T1.TOTGTP_SUCCESS)               ,4) TOTGTP_SUCCESS,
        ROUND(AVG(T1.TOTGTP_FAILURE)               ,4) TOTGTP_FAILURE,
        ROUND(AVG(T1.DISCONNECT_TOTAL)             ,4) DISCONNECT_TOTAL,
        ROUND(AVG(T1.DISCONNECT_LOCAL)             ,4) DISCONNECT_LOCAL,
        ROUND(AVG(T1.DISCONNECT_UE)                ,4) DISCONNECT_UE,
        ROUND(AVG(T1.DISCONNECT_PGW)               ,4) DISCONNECT_PGW,
        ROUND(AVG(T1.DISCONNECT_REMOTE)            ,4) DISCONNECT_REMOTE,
        ROUND(AVG(T1.SESS_DCON_REMOTE)             ,4) SESS_DCON_REMOTE,
        ROUND(AVG(T1.SESS_DCON_ADMIN)              ,4) SESS_DCON_ADMIN,
        ROUND(AVG(T1.SESS_DCON_IDLE_TIMEOUT)       ,4) SESS_DCON_IDLE_TIMEOUT,
        ROUND(AVG(T1.SESS_DCON_ABS_TIMEOUT)        ,4) SESS_DCON_ABS_TIMEOUT,
        ROUND(AVG(T1.SESS_DCON_LONGDUR_TIMEOUT)    ,4) SESS_DCON_LONGDUR_TIMEOUT,
        ROUND(AVG(T1.SESS_DCON_SESSSETUP_TIMEOUT)  ,4) SESS_DCON_SESSSETUP_TIMEOUT,
        ROUND(AVG(T1.SESS_DCON_NORESOURCE)         ,4) SESS_DCON_NORESOURCE,
        ROUND(AVG(T1.SESS_DCON_AUTHFAIL)           ,4) SESS_DCON_AUTHFAIL,
        ROUND(AVG(T1.SESS_DCON_FLOWADD_FAILURE)    ,4) SESS_DCON_FLOWADD_FAILURE,
        ROUND(AVG(T1.SESS_DCON_INVALID_DEST)       ,4) SESS_DCON_INVALID_DEST,
        ROUND(AVG(T1.SESS_DCON_SRCADDR_VIOLATION)  ,4) SESS_DCON_SRCADDR_VIOLATION,
        ROUND(AVG(T1.SESS_DCON_LMAREVOC)           ,4) SESS_DCON_LMAREVOC,
        ROUND(AVG(T1.SESS_DCON_DUPREQ)             ,4) SESS_DCON_DUPREQ,
        ROUND(AVG(T1.SESS_DCON_ADDRASSIGN_FAILURE) ,4) SESS_DCON_ADDRASSIGN_FAILURE,
        ROUND(AVG(T1.SESS_DCON_HANDOFF)            ,4) SESS_DCON_HANDOFF,
        ROUND(AVG(T1.SESS_DCON_MISC)               ,4) SESS_DCON_MISC,
        ROUND(AVG(T1.REAUTH_ATTEMPT)               ,4) REAUTH_ATTEMPT,
        ROUND(AVG(T1.REAUTH_SUCCESS)               ,4) REAUTH_SUCCESS,
        ROUND(AVG(T1.REAUTH_FAILURE)               ,4) REAUTH_FAILURE,
        ROUND(AVG(T1.REAUTHOR_ATTEMPT)             ,4) REAUTHOR_ATTEMPT,
        ROUND(AVG(T1.REAUTHOR_SUCCESS)             ,4) REAUTHOR_SUCCESS,
        ROUND(AVG(T1.REAUTHOR_FAILURE)             ,4) REAUTHOR_FAILURE,
        ROUND(AVG(T1.TXBYTES)                      ,4) TXBYTES,
        ROUND(AVG(T1.TXPKTS)                       ,4) TXPKTS,
        ROUND(AVG(T1.RXBYTES)                      ,4) RXBYTES,
        ROUND(AVG(T1.RXPKTS)                       ,4) RXPKTS,
        ROUND(AVG(T1.PKT_VIOLATION)                ,4) PKT_VIOLATION,
        ROUND(AVG(T1.EAP_RXTTLSRVRPASSTHRU)        ,4) EAP_RXTTLSRVRPASSTHRU,
        ROUND(AVG(T1.NUM_QCI1_BEARER_ACTIVE)       ,4) NUM_QCI1_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI1_BEARER_SETUP)        ,4) NUM_QCI1_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI1_BEARER_RELEASED)     ,4) NUM_QCI1_BEARER_RELEASED,
        ROUND(AVG(T1.NUM_QCI2_BEARER_ACTIVE)       ,4) NUM_QCI2_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI2_BEARER_SETUP)        ,4) NUM_QCI2_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI2_BEARER_RELEASED)     ,4) NUM_QCI2_BEARER_RELEASED,
        ROUND(AVG(T1.NUM_QCI3_BEARER_ACTIVE)       ,4) NUM_QCI3_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI3_BEARER_SETUP)        ,4) NUM_QCI3_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI3_BEARER_RELEASED)     ,4) NUM_QCI3_BEARER_RELEASED,
        ROUND(AVG(T1.NUM_QCI4_BEARER_ACTIVE)       ,4) NUM_QCI4_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI4_BEARER_SETUP)        ,4) NUM_QCI4_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI4_BEARER_RELEASED)     ,4) NUM_QCI4_BEARER_RELEASED,
        ROUND(AVG(T1.NUM_QCI5_BEARER_ACTIVE)       ,4) NUM_QCI5_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI5_BEARER_SETUP)        ,4) NUM_QCI5_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI5_BEARER_RELEASED)     ,4) NUM_QCI5_BEARER_RELEASED,
        ROUND(AVG(T1.NUM_QCI6_BEARER_ACTIVE)       ,4) NUM_QCI6_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI6_BEARER_SETUP)        ,4) NUM_QCI6_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI6_BEARER_RELEASED)     ,4) NUM_QCI6_BEARER_RELEASED,
        ROUND(AVG(T1.NUM_QCI7_BEARER_ACTIVE)       ,4) NUM_QCI7_BEARER_ACTIVE,
        ROUND(AVG(T1.NUM_QCI7_BEARER_SETUP)        ,4) NUM_QCI7_BEARER_SETUP,
        ROUND(AVG(T1.NUM_QCI7_BEARER_RELEASED)     ,4) NUM_QCI7_BEARER_RELEASED,
        ROUND(AVG(T1.APN_EPDG_GTPV2_SUCCESS_RATE)  ,4) APN_EPDG_GTPV2_SUCCESS_RATE,
        ROUND(AVG(T1.TX_THROUGHPUT)                ,4) TX_THROUGHPUT,
        ROUND(AVG(AUX.RX_THROUGHPUT)               ,4) RX_THROUGHPUT,
        ROUND(AVG(T1.APN_EPDG_SYS_THROUGHPUT)      ,4) APN_EPDG_SYS_THROUGHPUT
   FROM CISCO_GGSN_EPDG_BH T1,
        (
         SELECT  TRUNC(FECHA, 'DAY') FECHA,
                 VPNID,
                 SERVID,
                 ROUND(AVG(RX_THROUGHPUT),4) RX_THROUGHPUT
            FROM (
                  SELECT FECHA,
                         VPNID,
                         SERVID,
                         RX_THROUGHPUT,
                         ROW_NUMBER() OVER(PARTITION BY VPNID, SERVID ORDER BY RX_THROUGHPUT DESC, FECHA DESC NULLS LAST) ORDEN
                    FROM (

                          SELECT A.FECHA,
                                 A.VPNID,
                                 A.SERVID,
                                 A.RX_THROUGHPUT
                            FROM CISCO_GGSN_EPDG_BH A
                           WHERE FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                                           AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+86399/86400
                         )
                 )
           WHERE ORDEN <= 3
        GROUP BY TRUNC(FECHA, 'DAY'),
                 VPNID,
                 SERVID
       ) AUX,
       CISCO_GGSN_EPDG_ISABHW T2
 WHERE TRUNC(T1.FECHA,'DAY') = AUX.FECHA
   AND T1.VPNID = AUX.VPNID
   AND T1.SERVID = AUX.SERVID
   AND TRUNC(T1.FECHA,'DAY') = T2.FECHA (+)
   AND T1.VPNID = T2.VPNID (+)
   AND T1.SERVID = T2.SERVID (+)
   AND T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                    AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+86399/86400
   AND T2.VPNID IS NULL
   AND T2.SERVID IS NULL
GROUP BY TRUNC(T1.FECHA,'DAY'),
        T1.EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID;

BEGIN

OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
LOOP
  FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
  BEGIN
    FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
      INSERT INTO CISCO_GGSN_EPDG_ISABHW VALUES T_ARRAY_COL (I);
  EXCEPTION
    WHEN DML_ERRORS THEN
      -- CAPTURE EXCEPTIONS TO PERFORM OPERATIONS DML
           L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
              FOR I IN 1 .. L_ERRORS
              LOOP
                  L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                  L_MSG   := SQLERRM(-L_ERRNO);
                  L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                  G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_ISABHW',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

              END LOOP;
  -- END --
  END;
  EXIT WHEN CUR%NOTFOUND;
END LOOP;
COMMIT;
CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_EPDG_ISABHW',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_SAMOG_HOUR (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS

-- Autor: Matias Orquera. Fecha: 16.12.2016
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@
-- Actualizacion: Matias Orquera. Fecha: 06.01.2017. Motivo: Se agrega tratamiento para variables Counter MIBs incrementales de Cisco.
-- Actualizacion: Matias Orquera. Fecha: 26.01.2017. Motivo: Se modifica criterio de OUTER JOIN con tabla destino.
-- Actualizacion: Matias Orquera. Fecha: 14.02.2017. Motivo: Se cambian tratamiento de CGW_SESTAT_TOTCUR_PDN_IPV4 y CGW_SESTAT_TOTCUR_PDN_IPV6 a Gauge.

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);


TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_SAMOG_HOUR%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
SELECT O.FECHA,
  O.EQUIPO,
  O.VPNNAME,
  O.VPNID,
  O.SERVNAME,
  O.SERVID,
  O.CGW_SESTAT_TOTCUR_UEACTIVE,
  O.CGW_SESTAT_TOTCUR_UESETUP,
  O.CGW_SESTAT_TOTCUR_UERELEASED,
  O.CGW_SESTAT_TOTCUR_PDNACTIVE,
  O.CGW_SESTAT_TOTCUR_PDNSETUP,
  O.CGW_SESTAT_TOT_PDNRELEASED,
  O.CGW_SESTAT_TOT_PDNREJECTED,
  O.CGW_SESTAT_TOTCUR_PDN_IPV4,
  O.CGW_SESTAT_TOTCUR_PDN_IPV6,
  O.CGW_SESTAT_TOTCUR_PDN_IPV4V6,
  O.CGW_SESTAT_PDNSETUPTYPE_IPV4,
  O.CGW_SESTAT_PDNSETUPTYPE_IPV6,
  O.CGW_SESTAT_PDNSETUPTYPE_IPV4V6,
  O.CGW_SESTAT_PDNREL_IPV4,
  O.CGW_SESTAT_PDNREL_IPV6,
  O.CGW_SESTAT_PDNREL_IPV4V6,
  O.CGW_SEST_GNU_UL_PKTS,
  O.CGW_SEST_GNU_UL_BYTES,
  O.CGW_SEST_GNU_UL_DROP_PKTS,
  O.CGW_SEST_GNU_UL_DROP_BYTES,
  O.CGW_SEST_GNU_DL_PKTS,
  O.CGW_SEST_GNU_DL_BYTES,
  O.CGW_SEST_GNU_DL_DROP_PKTS,
  O.CGW_SEST_GNU_DL_DROP_BYTES,
  O.CGW_SEST_DHCP_DISC_HO_RCVED,
  O.CGW_SEST_DHCP_DISC_HO_ACTED,
  O.CGW_SEST_DHCP_DISC_HO_DEN,
  O.CGW_SEST_UPD_DEN_NO_SESSMGR,
  O.CGW_SEST_UPD_DEN_NO_MEMORY,
  O.CGW_SEST_UPD_DEN_SESMGR_RJTED,
  O.CGW_SEST_UPD_DEN_IN_QUEUE_EXC,
  O.CGW_SEST_UPD_DEN_SIM_BIND_EXC,
  O.CGW_SEST_UPD_DEN_ALLOC_FAIL,
  ROUND((O.CGW_SEST_GNU_UL_BYTES*8)/(3600*1024*1024),4)            THROUGHPUT_UL,
  ROUND((O.CGW_SEST_GNU_DL_BYTES*8)/(3600*1024*1024),4)            THROUGHPUT_DL
FROM (
 SELECT TRUNC(C.FECHA, 'HH24')                                                                    FECHA,
        C.EQUIPO,
        C.VPNNAME,
        C.VPNID,
        C.SERVNAME,
        C.SERVID,
        SUM(DECODE(L_CGW_SESTAT_TOTCUR_UEACTIVE,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOTCUR_UEACTIVE < CGW_SESTAT_TOTCUR_UEACTIVE THEN
                  (V_N32 + L_CGW_SESTAT_TOTCUR_UEACTIVE - CGW_SESTAT_TOTCUR_UEACTIVE)
                ELSE
                 DECODE(L_CGW_SESTAT_TOTCUR_UEACTIVE,0,0,L_CGW_SESTAT_TOTCUR_UEACTIVE-CGW_SESTAT_TOTCUR_UEACTIVE)
              END))                                                                               CGW_SESTAT_TOTCUR_UEACTIVE,
        AVG(C.CGW_SESTAT_TOTCUR_UESETUP)                                                          CGW_SESTAT_TOTCUR_UESETUP,
        AVG(C.CGW_SESTAT_TOTCUR_UERELEASED)                                                       CGW_SESTAT_TOTCUR_UERELEASED,
        SUM(DECODE(L_CGW_SESTAT_TOTCUR_PDNACTIVE,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOTCUR_PDNACTIVE < CGW_SESTAT_TOTCUR_PDNACTIVE THEN
                  (V_N32 + L_CGW_SESTAT_TOTCUR_PDNACTIVE - CGW_SESTAT_TOTCUR_PDNACTIVE)
                ELSE
                 DECODE(L_CGW_SESTAT_TOTCUR_PDNACTIVE,0,0,L_CGW_SESTAT_TOTCUR_PDNACTIVE-CGW_SESTAT_TOTCUR_PDNACTIVE)
              END))                                                                               CGW_SESTAT_TOTCUR_PDNACTIVE,
        SUM(DECODE(L_CGW_SESTAT_TOTCUR_PDNSETUP,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOTCUR_PDNSETUP < CGW_SESTAT_TOTCUR_PDNSETUP THEN
                  (V_N32 + L_CGW_SESTAT_TOTCUR_PDNSETUP - CGW_SESTAT_TOTCUR_PDNSETUP)
                ELSE
                 DECODE(L_CGW_SESTAT_TOTCUR_PDNSETUP,0,0,L_CGW_SESTAT_TOTCUR_PDNSETUP-CGW_SESTAT_TOTCUR_PDNSETUP)
              END))                                                                               CGW_SESTAT_TOTCUR_PDNSETUP,
        SUM(DECODE(L_CGW_SESTAT_TOT_PDNRELEASED,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOT_PDNRELEASED < CGW_SESTAT_TOT_PDNRELEASED THEN
                  (V_N32 + L_CGW_SESTAT_TOT_PDNRELEASED - CGW_SESTAT_TOT_PDNRELEASED)
                ELSE
                 DECODE(L_CGW_SESTAT_TOT_PDNRELEASED,0,0,L_CGW_SESTAT_TOT_PDNRELEASED-CGW_SESTAT_TOT_PDNRELEASED)
              END))                                                                               CGW_SESTAT_TOT_PDNRELEASED,
        SUM(DECODE(L_CGW_SESTAT_TOT_PDNREJECTED,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOT_PDNREJECTED < CGW_SESTAT_TOT_PDNREJECTED THEN
                  (V_N32 + L_CGW_SESTAT_TOT_PDNREJECTED - CGW_SESTAT_TOT_PDNREJECTED)
                ELSE
                 DECODE(L_CGW_SESTAT_TOT_PDNREJECTED,0,0,L_CGW_SESTAT_TOT_PDNREJECTED-CGW_SESTAT_TOT_PDNREJECTED)
              END))                                                                               CGW_SESTAT_TOT_PDNREJECTED,
        AVG(C.CGW_SESTAT_TOTCUR_PDN_IPV4)
        /*SUM(DECODE(L_CGW_SESTAT_TOTCUR_PDN_IPV4,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOTCUR_PDN_IPV4 < CGW_SESTAT_TOTCUR_PDN_IPV4 THEN
                  (V_N32 + L_CGW_SESTAT_TOTCUR_PDN_IPV4 - CGW_SESTAT_TOTCUR_PDN_IPV4)
                ELSE
                 DECODE(L_CGW_SESTAT_TOTCUR_PDN_IPV4,0,0,L_CGW_SESTAT_TOTCUR_PDN_IPV4-CGW_SESTAT_TOTCUR_PDN_IPV4)
              END))*/                                                                               CGW_SESTAT_TOTCUR_PDN_IPV4,
        AVG(C.CGW_SESTAT_TOTCUR_PDN_IPV6)
        /*SUM(DECODE(L_CGW_SESTAT_TOTCUR_PDN_IPV6,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOTCUR_PDN_IPV6 < CGW_SESTAT_TOTCUR_PDN_IPV6 THEN
                  (V_N32 + L_CGW_SESTAT_TOTCUR_PDN_IPV6 - CGW_SESTAT_TOTCUR_PDN_IPV6)
                ELSE
                 DECODE(L_CGW_SESTAT_TOTCUR_PDN_IPV6,0,0,L_CGW_SESTAT_TOTCUR_PDN_IPV6-CGW_SESTAT_TOTCUR_PDN_IPV6)
              END))*/                                                                               CGW_SESTAT_TOTCUR_PDN_IPV6,
        SUM(DECODE(L_CGW_SESTAT_TOTCUR_PDN_IPV4V6,0,0,
              CASE
                WHEN L_CGW_SESTAT_TOTCUR_PDN_IPV4V6 < CGW_SESTAT_TOTCUR_PDN_IPV4V6 THEN
                  (V_N32 + L_CGW_SESTAT_TOTCUR_PDN_IPV4V6 - CGW_SESTAT_TOTCUR_PDN_IPV4V6)
                ELSE
                 DECODE(L_CGW_SESTAT_TOTCUR_PDN_IPV4V6,0,0,L_CGW_SESTAT_TOTCUR_PDN_IPV4V6-CGW_SESTAT_TOTCUR_PDN_IPV4V6)
              END))                                                                               CGW_SESTAT_TOTCUR_PDN_IPV4V6,
        SUM(DECODE(L_CGW_SESTAT_PDNSETUPTYPE_IPV4,0,0,
              CASE
                WHEN L_CGW_SESTAT_PDNSETUPTYPE_IPV4 < CGW_SESTAT_PDNSETUPTYPE_IPV4 THEN
                  (V_N32 + L_CGW_SESTAT_PDNSETUPTYPE_IPV4 - CGW_SESTAT_PDNSETUPTYPE_IPV4)
                ELSE
                 DECODE(L_CGW_SESTAT_PDNSETUPTYPE_IPV4,0,0,L_CGW_SESTAT_PDNSETUPTYPE_IPV4-CGW_SESTAT_PDNSETUPTYPE_IPV4)
              END))                                                                               CGW_SESTAT_PDNSETUPTYPE_IPV4,
        SUM(DECODE(L_CGW_SESTAT_PDNSETUPTYPE_IPV6,0,0,
              CASE
                WHEN L_CGW_SESTAT_PDNSETUPTYPE_IPV6 < CGW_SESTAT_PDNSETUPTYPE_IPV6 THEN
                  (V_N32 + L_CGW_SESTAT_PDNSETUPTYPE_IPV6 - CGW_SESTAT_PDNSETUPTYPE_IPV6)
                ELSE
                 DECODE(L_CGW_SESTAT_PDNSETUPTYPE_IPV6,0,0,L_CGW_SESTAT_PDNSETUPTYPE_IPV6-CGW_SESTAT_PDNSETUPTYPE_IPV6)
              END))                                                                               CGW_SESTAT_PDNSETUPTYPE_IPV6,
        SUM(DECODE(L_CGW_SESTAT_PDNSTPTYPE_IPV4V6,0,0,
              CASE
                WHEN L_CGW_SESTAT_PDNSTPTYPE_IPV4V6 < CGW_SESTAT_PDNSETUPTYPE_IPV4V6 THEN
                  (V_N32 + L_CGW_SESTAT_PDNSTPTYPE_IPV4V6 - CGW_SESTAT_PDNSETUPTYPE_IPV4V6)
                ELSE
                 DECODE(L_CGW_SESTAT_PDNSTPTYPE_IPV4V6,0,0,L_CGW_SESTAT_PDNSTPTYPE_IPV4V6-CGW_SESTAT_PDNSETUPTYPE_IPV4V6)
              END))                                                                               CGW_SESTAT_PDNSETUPTYPE_IPV4V6,
        SUM(DECODE(L_CGW_SESTAT_PDNREL_IPV4,0,0,
              CASE
                WHEN L_CGW_SESTAT_PDNREL_IPV4 < CGW_SESTAT_PDNREL_IPV4 THEN
                  (V_N32 + L_CGW_SESTAT_PDNREL_IPV4 - CGW_SESTAT_PDNREL_IPV4)
                ELSE
                 DECODE(L_CGW_SESTAT_PDNREL_IPV4,0,0,L_CGW_SESTAT_PDNREL_IPV4-CGW_SESTAT_PDNREL_IPV4)
              END))                                                                               CGW_SESTAT_PDNREL_IPV4,
        SUM(DECODE(L_CGW_SESTAT_PDNREL_IPV6,0,0,
              CASE
                WHEN L_CGW_SESTAT_PDNREL_IPV6 < CGW_SESTAT_PDNREL_IPV6 THEN
                  (V_N32 + L_CGW_SESTAT_PDNREL_IPV6 - CGW_SESTAT_PDNREL_IPV6)
                ELSE
                 DECODE(L_CGW_SESTAT_PDNREL_IPV6,0,0,L_CGW_SESTAT_PDNREL_IPV6-CGW_SESTAT_PDNREL_IPV6)
              END))                                                                               CGW_SESTAT_PDNREL_IPV6,
        SUM(DECODE(L_CGW_SESTAT_PDNREL_IPV4V6,0,0,
              CASE
                WHEN L_CGW_SESTAT_PDNREL_IPV4V6 < CGW_SESTAT_PDNREL_IPV4V6 THEN
                  (V_N32 + L_CGW_SESTAT_PDNREL_IPV4V6 - CGW_SESTAT_PDNREL_IPV4V6)
                ELSE
                 DECODE(L_CGW_SESTAT_PDNREL_IPV4V6,0,0,L_CGW_SESTAT_PDNREL_IPV4V6-CGW_SESTAT_PDNREL_IPV4V6)
              END))                                                                               CGW_SESTAT_PDNREL_IPV4V6,
        SUM(DECODE(L_CGW_SEST_GNU_UL_PKTS,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_UL_PKTS < CGW_SEST_GNU_UL_PKTS THEN
                  (V_N64 + L_CGW_SEST_GNU_UL_PKTS - CGW_SEST_GNU_UL_PKTS)
                ELSE
                 DECODE(L_CGW_SEST_GNU_UL_PKTS,0,0,L_CGW_SEST_GNU_UL_PKTS-CGW_SEST_GNU_UL_PKTS)
              END))                                                                               CGW_SEST_GNU_UL_PKTS,
        SUM(DECODE(L_CGW_SEST_GNU_UL_BYTES,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_UL_BYTES < CGW_SEST_GNU_UL_BYTES THEN
                  CASE WHEN (V_N64 + L_CGW_SEST_GNU_UL_BYTES - CGW_SEST_GNU_UL_BYTES) > 18000000000000000000 THEN
                        0
                  ELSE
                    (V_N64 + L_CGW_SEST_GNU_UL_BYTES - CGW_SEST_GNU_UL_BYTES)
                  END                  
               ELSE
                 DECODE(L_CGW_SEST_GNU_UL_BYTES,0,0,L_CGW_SEST_GNU_UL_BYTES-CGW_SEST_GNU_UL_BYTES)
              END))                                                                               CGW_SEST_GNU_UL_BYTES,
        SUM(DECODE(L_CGW_SEST_GNU_UL_DROP_PKTS,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_UL_DROP_PKTS < CGW_SEST_GNU_UL_DROP_PKTS THEN
                  (V_N64 + L_CGW_SEST_GNU_UL_DROP_PKTS - CGW_SEST_GNU_UL_DROP_PKTS)
                ELSE
                 DECODE(L_CGW_SEST_GNU_UL_DROP_PKTS,0,0,L_CGW_SEST_GNU_UL_DROP_PKTS-CGW_SEST_GNU_UL_DROP_PKTS)
              END))                                                                               CGW_SEST_GNU_UL_DROP_PKTS,
        SUM(DECODE(L_CGW_SEST_GNU_UL_DROP_BYTES,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_UL_DROP_BYTES < CGW_SEST_GNU_UL_DROP_BYTES THEN
                  (V_N64 + L_CGW_SEST_GNU_UL_DROP_BYTES - CGW_SEST_GNU_UL_DROP_BYTES)
                ELSE
                 DECODE(L_CGW_SEST_GNU_UL_DROP_BYTES,0,0,L_CGW_SEST_GNU_UL_DROP_BYTES-CGW_SEST_GNU_UL_DROP_BYTES)
              END))                                                                               CGW_SEST_GNU_UL_DROP_BYTES,
        SUM(DECODE(L_CGW_SEST_GNU_DL_PKTS,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_DL_PKTS < CGW_SEST_GNU_DL_PKTS THEN
                  (V_N64 + L_CGW_SEST_GNU_DL_PKTS - CGW_SEST_GNU_DL_PKTS)
                ELSE
                 DECODE(L_CGW_SEST_GNU_DL_PKTS,0,0,L_CGW_SEST_GNU_DL_PKTS-CGW_SEST_GNU_DL_PKTS)
              END))                                                                               CGW_SEST_GNU_DL_PKTS,
        SUM(DECODE(L_CGW_SEST_GNU_DL_BYTES,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_DL_BYTES < CGW_SEST_GNU_DL_BYTES THEN
                  CASE WHEN (V_N64 + L_CGW_SEST_GNU_DL_BYTES - CGW_SEST_GNU_DL_BYTES) > 18000000000000000000 THEN
                        0
                  ELSE
                    (V_N64 + L_CGW_SEST_GNU_DL_BYTES - CGW_SEST_GNU_DL_BYTES)
                  END                  
                ELSE
                 DECODE(L_CGW_SEST_GNU_DL_BYTES,0,0,L_CGW_SEST_GNU_DL_BYTES-CGW_SEST_GNU_DL_BYTES)
              END))                                                                               CGW_SEST_GNU_DL_BYTES,
        SUM(DECODE(L_CGW_SEST_GNU_DL_DROP_PKTS,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_DL_DROP_PKTS < CGW_SEST_GNU_DL_DROP_PKTS THEN
                  (V_N64 + L_CGW_SEST_GNU_DL_DROP_PKTS - CGW_SEST_GNU_DL_DROP_PKTS)
                ELSE
                 DECODE(L_CGW_SEST_GNU_DL_DROP_PKTS,0,0,L_CGW_SEST_GNU_DL_DROP_PKTS-CGW_SEST_GNU_DL_DROP_PKTS)
              END))                                                                               CGW_SEST_GNU_DL_DROP_PKTS,
        SUM(DECODE(L_CGW_SEST_GNU_DL_DROP_BYTES,0,0,
              CASE
                WHEN L_CGW_SEST_GNU_DL_DROP_BYTES < CGW_SEST_GNU_DL_DROP_BYTES THEN
                  (V_N64 + L_CGW_SEST_GNU_DL_DROP_BYTES - CGW_SEST_GNU_DL_DROP_BYTES)
                ELSE
                 DECODE(L_CGW_SEST_GNU_DL_DROP_BYTES,0,0,L_CGW_SEST_GNU_DL_DROP_BYTES-CGW_SEST_GNU_DL_DROP_BYTES)
              END))                                                                               CGW_SEST_GNU_DL_DROP_BYTES,
        SUM(DECODE(L_CGW_SEST_DHCP_DISC_HO_RCVED,0,0,
              CASE
                WHEN L_CGW_SEST_DHCP_DISC_HO_RCVED < CGW_SEST_DHCP_DISC_HO_RCVED THEN
                  (V_N32 + L_CGW_SEST_DHCP_DISC_HO_RCVED - CGW_SEST_DHCP_DISC_HO_RCVED)
                ELSE
                 DECODE(L_CGW_SEST_DHCP_DISC_HO_RCVED,0,0,L_CGW_SEST_DHCP_DISC_HO_RCVED-CGW_SEST_DHCP_DISC_HO_RCVED)
              END))                                                                               CGW_SEST_DHCP_DISC_HO_RCVED,
        SUM(DECODE(L_CGW_SEST_DHCP_DISC_HO_ACTED,0,0,
              CASE
                WHEN L_CGW_SEST_DHCP_DISC_HO_ACTED < CGW_SEST_DHCP_DISC_HO_ACTED THEN
                  (V_N32 + L_CGW_SEST_DHCP_DISC_HO_ACTED - CGW_SEST_DHCP_DISC_HO_ACTED)
                ELSE
                 DECODE(L_CGW_SEST_DHCP_DISC_HO_ACTED,0,0,L_CGW_SEST_DHCP_DISC_HO_ACTED-CGW_SEST_DHCP_DISC_HO_ACTED)
              END))                                                                               CGW_SEST_DHCP_DISC_HO_ACTED,
        SUM(DECODE(L_CGW_SEST_DHCP_DISC_HO_DEN,0,0,
              CASE
                WHEN L_CGW_SEST_DHCP_DISC_HO_DEN < CGW_SEST_DHCP_DISC_HO_DEN THEN
                  (V_N32 + L_CGW_SEST_DHCP_DISC_HO_DEN - CGW_SEST_DHCP_DISC_HO_DEN)
                ELSE
                 DECODE(L_CGW_SEST_DHCP_DISC_HO_DEN,0,0,L_CGW_SEST_DHCP_DISC_HO_DEN-CGW_SEST_DHCP_DISC_HO_DEN)
              END))                                                                               CGW_SEST_DHCP_DISC_HO_DEN,
        SUM(DECODE(L_CGW_SEST_UPD_DEN_NO_SESSMGR,0,0,
              CASE
                WHEN L_CGW_SEST_UPD_DEN_NO_SESSMGR < CGW_SEST_UPD_DEN_NO_SESSMGR THEN
                  (V_N32 + L_CGW_SEST_UPD_DEN_NO_SESSMGR - CGW_SEST_UPD_DEN_NO_SESSMGR)
                ELSE
                 DECODE(L_CGW_SEST_UPD_DEN_NO_SESSMGR,0,0,L_CGW_SEST_UPD_DEN_NO_SESSMGR-CGW_SEST_UPD_DEN_NO_SESSMGR)
              END))                                                                               CGW_SEST_UPD_DEN_NO_SESSMGR,
        SUM(DECODE(L_CGW_SEST_UPD_DEN_NO_MEMORY,0,0,
              CASE
                WHEN L_CGW_SEST_UPD_DEN_NO_MEMORY < CGW_SEST_UPD_DEN_NO_MEMORY THEN
                  (V_N32 + L_CGW_SEST_UPD_DEN_NO_MEMORY - CGW_SEST_UPD_DEN_NO_MEMORY)
                ELSE
                 DECODE(L_CGW_SEST_UPD_DEN_NO_MEMORY,0,0,L_CGW_SEST_UPD_DEN_NO_MEMORY-CGW_SEST_UPD_DEN_NO_MEMORY)
              END))                                                                               CGW_SEST_UPD_DEN_NO_MEMORY,
        SUM(DECODE(L_CGW_SEST_UPD_DEN_SESMGR_RJ,0,0,
              CASE
                WHEN L_CGW_SEST_UPD_DEN_SESMGR_RJ < CGW_SEST_UPD_DEN_SESMGR_RJTED THEN
                  (V_N32 + L_CGW_SEST_UPD_DEN_SESMGR_RJ - CGW_SEST_UPD_DEN_SESMGR_RJTED)
                ELSE
                 DECODE(L_CGW_SEST_UPD_DEN_SESMGR_RJ,0,0,L_CGW_SEST_UPD_DEN_SESMGR_RJ-CGW_SEST_UPD_DEN_SESMGR_RJTED)
              END))                                                                               CGW_SEST_UPD_DEN_SESMGR_RJTED,
        SUM(DECODE(L_CGW_SEST_UPD_DEN_IN_Q_EXC,0,0,
              CASE
                WHEN L_CGW_SEST_UPD_DEN_IN_Q_EXC < CGW_SEST_UPD_DEN_IN_QUEUE_EXC THEN
                  (V_N32 + L_CGW_SEST_UPD_DEN_IN_Q_EXC - CGW_SEST_UPD_DEN_IN_QUEUE_EXC)
                ELSE
                 DECODE(L_CGW_SEST_UPD_DEN_IN_Q_EXC,0,0,L_CGW_SEST_UPD_DEN_IN_Q_EXC-CGW_SEST_UPD_DEN_IN_QUEUE_EXC)
              END))                                                                               CGW_SEST_UPD_DEN_IN_QUEUE_EXC,
        SUM(DECODE(L_CGW_SEST_UPD_DEN_SIM_BIND_X,0,0,
              CASE
                WHEN L_CGW_SEST_UPD_DEN_SIM_BIND_X < CGW_SEST_UPD_DEN_SIM_BIND_EXC THEN
                  (V_N32 + L_CGW_SEST_UPD_DEN_SIM_BIND_X - CGW_SEST_UPD_DEN_SIM_BIND_EXC)
                ELSE
                 DECODE(L_CGW_SEST_UPD_DEN_SIM_BIND_X,0,0,L_CGW_SEST_UPD_DEN_SIM_BIND_X-CGW_SEST_UPD_DEN_SIM_BIND_EXC)
              END))                                                                               CGW_SEST_UPD_DEN_SIM_BIND_EXC,
        SUM(DECODE(L_CGW_SEST_UPD_DEN_ALLOC_FAIL,0,0,
              CASE
                WHEN L_CGW_SEST_UPD_DEN_ALLOC_FAIL < CGW_SEST_UPD_DEN_ALLOC_FAIL THEN
                  (V_N32 + L_CGW_SEST_UPD_DEN_ALLOC_FAIL - CGW_SEST_UPD_DEN_ALLOC_FAIL)
                ELSE
                 DECODE(L_CGW_SEST_UPD_DEN_ALLOC_FAIL,0,0,L_CGW_SEST_UPD_DEN_ALLOC_FAIL-CGW_SEST_UPD_DEN_ALLOC_FAIL)
              END))                                                                               CGW_SEST_UPD_DEN_ALLOC_FAIL

  FROM (
     SELECT T1.FECHA,
            T1.EQUIPO,
            T1.VPNNAME,
            T1.VPNID,
            T1.SERVNAME,
            T1.SERVID,
            CGW_SESTAT_TOTCUR_UEACTIVE,
            NVL(LEAD(CGW_SESTAT_TOTCUR_UEACTIVE) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOTCUR_UEACTIVE,
            T1.CGW_SESTAT_TOTCUR_UESETUP                                                                      CGW_SESTAT_TOTCUR_UESETUP,
            T1.CGW_SESTAT_TOTCUR_UERELEASED                                                                   CGW_SESTAT_TOTCUR_UERELEASED,
            CGW_SESTAT_TOTCUR_PDNACTIVE,
            NVL(LEAD(CGW_SESTAT_TOTCUR_PDNACTIVE)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOTCUR_PDNACTIVE,
            CGW_SESTAT_TOTCUR_PDNSETUP,
            NVL(LEAD(CGW_SESTAT_TOTCUR_PDNSETUP) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOTCUR_PDNSETUP,
            CGW_SESTAT_TOT_PDNRELEASED,
            NVL(LEAD(CGW_SESTAT_TOT_PDNRELEASED) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOT_PDNRELEASED,
            CGW_SESTAT_TOT_PDNREJECTED,
            NVL(LEAD(CGW_SESTAT_TOT_PDNREJECTED) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOT_PDNREJECTED,
            CGW_SESTAT_TOTCUR_PDN_IPV4,
            NVL(LEAD(CGW_SESTAT_TOTCUR_PDN_IPV4) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOTCUR_PDN_IPV4,
            CGW_SESTAT_TOTCUR_PDN_IPV6,
            NVL(LEAD(CGW_SESTAT_TOTCUR_PDN_IPV6) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_TOTCUR_PDN_IPV6,
            CGW_SESTAT_TOTCUR_PDN_IPV4V6,
            NVL(LEAD(CGW_SESTAT_TOTCUR_PDN_IPV4V6) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                   ORDER BY T1.FECHA),0)                                      L_CGW_SESTAT_TOTCUR_PDN_IPV4V6,
            CGW_SESTAT_PDNSETUPTYPE_IPV4,
            NVL(LEAD(CGW_SESTAT_PDNSETUPTYPE_IPV4) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                   ORDER BY T1.FECHA),0)                                      L_CGW_SESTAT_PDNSETUPTYPE_IPV4,
            CGW_SESTAT_PDNSETUPTYPE_IPV6,
            NVL(LEAD(CGW_SESTAT_PDNSETUPTYPE_IPV6) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                   ORDER BY T1.FECHA),0)                                      L_CGW_SESTAT_PDNSETUPTYPE_IPV6,
            CGW_SESTAT_PDNSETUPTYPE_IPV4V6,
            NVL(LEAD(CGW_SESTAT_PDNSETUPTYPE_IPV4V6) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                     ORDER BY T1.FECHA),0)                                    L_CGW_SESTAT_PDNSTPTYPE_IPV4V6,
            CGW_SESTAT_PDNREL_IPV4,
            NVL(LEAD(CGW_SESTAT_PDNREL_IPV4)     OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_PDNREL_IPV4,
            CGW_SESTAT_PDNREL_IPV6,
            NVL(LEAD(CGW_SESTAT_PDNREL_IPV6)     OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_PDNREL_IPV6,
            CGW_SESTAT_PDNREL_IPV4V6,
            NVL(LEAD(CGW_SESTAT_PDNREL_IPV4V6)   OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SESTAT_PDNREL_IPV4V6,
            CGW_SEST_GNU_UL_PKTS,
            NVL(LEAD(CGW_SEST_GNU_UL_PKTS)       OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_UL_PKTS,
            CGW_SEST_GNU_UL_BYTES,
            NVL(LEAD(CGW_SEST_GNU_UL_BYTES)      OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_UL_BYTES,
            CGW_SEST_GNU_UL_DROP_PKTS,
            NVL(LEAD(CGW_SEST_GNU_UL_DROP_PKTS)  OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_UL_DROP_PKTS,
            CGW_SEST_GNU_UL_DROP_BYTES,
            NVL(LEAD(CGW_SEST_GNU_UL_DROP_BYTES) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_UL_DROP_BYTES,
            CGW_SEST_GNU_DL_PKTS,
            NVL(LEAD(CGW_SEST_GNU_DL_PKTS)       OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_DL_PKTS,
            CGW_SEST_GNU_DL_BYTES,
            NVL(LEAD(CGW_SEST_GNU_DL_BYTES)      OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_DL_BYTES,
            CGW_SEST_GNU_DL_DROP_PKTS,
            NVL(LEAD(CGW_SEST_GNU_DL_DROP_PKTS)  OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_DL_DROP_PKTS,
            CGW_SEST_GNU_DL_DROP_BYTES,
            NVL(LEAD(CGW_SEST_GNU_DL_DROP_BYTES) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_GNU_DL_DROP_BYTES,
            CGW_SEST_DHCP_DISC_HO_RCVED,
            NVL(LEAD(CGW_SEST_DHCP_DISC_HO_RCVED)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_DHCP_DISC_HO_RCVED,
            CGW_SEST_DHCP_DISC_HO_ACTED,
            NVL(LEAD(CGW_SEST_DHCP_DISC_HO_ACTED)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_DHCP_DISC_HO_ACTED,
            CGW_SEST_DHCP_DISC_HO_DEN,
            NVL(LEAD(CGW_SEST_DHCP_DISC_HO_DEN)  OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_DHCP_DISC_HO_DEN,
            CGW_SEST_UPD_DEN_NO_SESSMGR,
            NVL(LEAD(CGW_SEST_UPD_DEN_NO_SESSMGR)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_UPD_DEN_NO_SESSMGR,
            CGW_SEST_UPD_DEN_NO_MEMORY,
            NVL(LEAD(CGW_SEST_UPD_DEN_NO_MEMORY) OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_UPD_DEN_NO_MEMORY,
            CGW_SEST_UPD_DEN_SESMGR_RJTED,
            NVL(LEAD(CGW_SEST_UPD_DEN_SESMGR_RJTED)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_UPD_DEN_SESMGR_RJ,
            CGW_SEST_UPD_DEN_IN_QUEUE_EXC,
            NVL(LEAD(CGW_SEST_UPD_DEN_IN_QUEUE_EXC)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_UPD_DEN_IN_Q_EXC,
            CGW_SEST_UPD_DEN_SIM_BIND_EXC,
            NVL(LEAD(CGW_SEST_UPD_DEN_SIM_BIND_EXC)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_UPD_DEN_SIM_BIND_X,
            CGW_SEST_UPD_DEN_ALLOC_FAIL,
            NVL(LEAD(CGW_SEST_UPD_DEN_ALLOC_FAIL)OVER(PARTITION BY T1.EQUIPO, T1.VPNID,T1.SERVID
                                                 ORDER BY T1.FECHA),0)                                        L_CGW_SEST_UPD_DEN_ALLOC_FAIL
        FROM CISCO_GGSN_SAMOG_SCH1_RAW_VW@SMART.WORLD T1,
             CISCO_GGSN_SAMOG_SCH3_RAW_VW@SMART.WORLD T2

       WHERE T1.FECHA = T2.FECHA
         AND T1.VPNID = T2.VPNID
         AND T1.SERVID = T2.SERVID
         AND T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                          AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')
             ) C
  GROUP BY TRUNC(C.FECHA, 'HH24'),
           C.EQUIPO,
           C.VPNNAME,
           C.VPNID,
           C.SERVNAME,
           C.SERVID
         ) O
         --CISCO_GGSN_SAMOG_HOUR D
WHERE NOT EXISTS(SELECT 1
                   FROM CISCO_GGSN_SAMOG_HOUR D
                  WHERE O.VPNID = D.VPNID
                    AND O.SERVID = D.SERVID
                    AND O.FECHA = D.FECHA);


 BEGIN
 OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO CISCO_GGSN_SAMOG_HOUR VALUES T_ARRAY_COL (I);
    EXCEPTION
      WHEN DML_ERRORS THEN
        L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
                FOR I IN 1 .. L_ERRORS
                LOOP
                    L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                    L_MSG   := SQLERRM(-L_ERRNO);
                    L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_HOUR',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

                END LOOP;
    END;
    EXIT WHEN CUR%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_HOUR',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_SAMOG_DAY (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS

-- Autor: Matias Orquera. Fecha: 27.12.2016
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@
-- Actualizacion: Matias Orquera. Fecha: 09.01.2017. Motivo: Se cambia sumarizaciones por promedios.

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);



TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_SAMOG_DAY%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
 SELECT TRUNC(T1.FECHA)                                                        FECHA,
        T1.EQUIPO                                                              EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        AVG(T1.CGW_SESTAT_TOTCUR_UEACTIVE)                                     CGW_SESTAT_TOTCUR_UEACTIVE,
        AVG(T1.CGW_SESTAT_TOTCUR_UESETUP)                                      CGW_SESTAT_TOTCUR_UESETUP,
        AVG(T1.CGW_SESTAT_TOTCUR_UERELEASED)                                   CGW_SESTAT_TOTCUR_UERELEASED,
        AVG(T1.CGW_SESTAT_TOTCUR_PDNACTIVE)                                    CGW_SESTAT_TOTCUR_PDNACTIVE,
        AVG(T1.CGW_SESTAT_TOTCUR_PDNSETUP)                                     CGW_SESTAT_TOTCUR_PDNSETUP,
        AVG(T1.CGW_SESTAT_TOT_PDNRELEASED)                                     CGW_SESTAT_TOT_PDNRELEASED,
        AVG(T1.CGW_SESTAT_TOT_PDNREJECTED)                                     CGW_SESTAT_TOT_PDNREJECTED,
        AVG(T1.CGW_SESTAT_TOTCUR_PDN_IPV4)                                     CGW_SESTAT_TOTCUR_PDN_IPV4,
        AVG(T1.CGW_SESTAT_TOTCUR_PDN_IPV6)                                     CGW_SESTAT_TOTCUR_PDN_IPV6,
        AVG(T1.CGW_SESTAT_TOTCUR_PDN_IPV4V6)                                   CGW_SESTAT_TOTCUR_PDN_IPV4V6,
        AVG(T1.CGW_SESTAT_PDNSETUPTYPE_IPV4)                                   CGW_SESTAT_PDNSETUPTYPE_IPV4,
        AVG(T1.CGW_SESTAT_PDNSETUPTYPE_IPV6)                                   CGW_SESTAT_PDNSETUPTYPE_IPV6,
        AVG(T1.CGW_SESTAT_PDNSETUPTYPE_IPV4V6)                                 CGW_SESTAT_PDNSETUPTYPE_IPV4V6,
        AVG(T1.CGW_SESTAT_PDNREL_IPV4)                                         CGW_SESTAT_PDNREL_IPV4,
        AVG(T1.CGW_SESTAT_PDNREL_IPV6)                                         CGW_SESTAT_PDNREL_IPV6,
        AVG(T1.CGW_SESTAT_PDNREL_IPV4V6)                                       CGW_SESTAT_PDNREL_IPV4V6,
        AVG(T1.CGW_SEST_GNU_UL_PKTS)                                           CGW_SEST_GNU_UL_PKTS,
        AVG(T1.CGW_SEST_GNU_UL_BYTES)                                          CGW_SEST_GNU_UL_BYTES,
        AVG(T1.CGW_SEST_GNU_UL_DROP_PKTS)                                      CGW_SEST_GNU_UL_DROP_PKTS,
        AVG(T1.CGW_SEST_GNU_UL_DROP_BYTES)                                     CGW_SEST_GNU_UL_DROP_BYTES,
        AVG(T1.CGW_SEST_GNU_DL_PKTS)                                           CGW_SEST_GNU_DL_PKTS,
        AVG(T1.CGW_SEST_GNU_DL_BYTES)                                          CGW_SEST_GNU_DL_BYTES,
        AVG(T1.CGW_SEST_GNU_DL_DROP_PKTS)                                      CGW_SEST_GNU_DL_DROP_PKTS,
        AVG(T1.CGW_SEST_GNU_DL_DROP_BYTES)                                     CGW_SEST_GNU_DL_DROP_BYTES,
        AVG(T1.CGW_SEST_DHCP_DISC_HO_RCVED)                                    CGW_SEST_DHCP_DISC_HO_RCVED,
        AVG(T1.CGW_SEST_DHCP_DISC_HO_ACTED)                                    CGW_SEST_DHCP_DISC_HO_ACTED,
        AVG(T1.CGW_SEST_DHCP_DISC_HO_DEN)                                      CGW_SEST_DHCP_DISC_HO_DEN,
        AVG(T1.CGW_SEST_UPD_DEN_NO_SESSMGR)                                    CGW_SEST_UPD_DEN_NO_SESSMGR,
        AVG(T1.CGW_SEST_UPD_DEN_NO_MEMORY)                                     CGW_SEST_UPD_DEN_NO_MEMORY,
        AVG(T1.CGW_SEST_UPD_DEN_SESMGR_RJTED)                                  CGW_SEST_UPD_DEN_SESMGR_RJTED,
        AVG(T1.CGW_SEST_UPD_DEN_IN_QUEUE_EXC)                                  CGW_SEST_UPD_DEN_IN_QUEUE_EXC,
        AVG(T1.CGW_SEST_UPD_DEN_SIM_BIND_EXC)                                  CGW_SEST_UPD_DEN_SIM_BIND_EXC,
        AVG(T1.CGW_SEST_UPD_DEN_ALLOC_FAIL)                                    CGW_SEST_UPD_DEN_ALLOC_FAIL,
        AVG(T1.THROUGHPUT_UL)                                                  THROUGHPUT_UL,
        AVG(T1.THROUGHPUT_DL)                                                  THROUGHPUT_DL
    FROM CISCO_GGSN_SAMOG_HOUR T1
--         CISCO_GGSN_SAMOG_DAY T2
   WHERE /*TRUNC(T1.FECHA) = T2.FECHA (+)
     AND T1.VPNID = T2.VPNID (+)
     AND T1.SERVID = T2.SERVID (+)
     AND */T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                      AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+86399/86400
     AND NOT EXISTS(SELECT 1
                      FROM CISCO_GGSN_SAMOG_DAY T2
                     WHERE T1.VPNID = T2.VPNID
                       AND T1.SERVID = T2.SERVID
                       AND TRUNC(T1.FECHA) = T2.FECHA)
GROUP BY TRUNC(T1.FECHA),
         T1.EQUIPO,
         T1.VPNNAME,
         T1.VPNID,
         T1.SERVNAME,
         T1.SERVID;

 BEGIN
 OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO CISCO_GGSN_SAMOG_DAY VALUES T_ARRAY_COL (I);
    EXCEPTION
      WHEN DML_ERRORS THEN
        L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
                FOR I IN 1 .. L_ERRORS
                LOOP
                    L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                    L_MSG   := SQLERRM(-L_ERRNO);
                    L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_DAY',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

                END LOOP;
    END;
    EXIT WHEN CUR%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_DAY',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_SAMOG_BH (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 28.12.2016.
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);

TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_SAMOG_BH%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
 SELECT TRUNC(T1.FECHA)                                                        FECHA,
        T1.EQUIPO                                                              EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        T1.CGW_SESTAT_TOTCUR_UEACTIVE,
        T1.CGW_SESTAT_TOTCUR_UESETUP,
        T1.CGW_SESTAT_TOTCUR_UERELEASED,
        T1.CGW_SESTAT_TOTCUR_PDNACTIVE,
        T1.CGW_SESTAT_TOTCUR_PDNSETUP,
        T1.CGW_SESTAT_TOT_PDNRELEASED,
        T1.CGW_SESTAT_TOT_PDNREJECTED,
        T1.CGW_SESTAT_TOTCUR_PDN_IPV4,
        T1.CGW_SESTAT_TOTCUR_PDN_IPV6,
        T1.CGW_SESTAT_TOTCUR_PDN_IPV4V6,
        T1.CGW_SESTAT_PDNSETUPTYPE_IPV4,
        T1.CGW_SESTAT_PDNSETUPTYPE_IPV6,
        T1.CGW_SESTAT_PDNSETUPTYPE_IPV4V6,
        T1.CGW_SESTAT_PDNREL_IPV4,
        T1.CGW_SESTAT_PDNREL_IPV6,
        T1.CGW_SESTAT_PDNREL_IPV4V6,
        T1.CGW_SEST_GNU_UL_PKTS,
        T1.CGW_SEST_GNU_UL_BYTES,
        T1.CGW_SEST_GNU_UL_DROP_PKTS,
        T1.CGW_SEST_GNU_UL_DROP_BYTES,
        T1.CGW_SEST_GNU_DL_PKTS,
        T1.CGW_SEST_GNU_DL_BYTES,
        T1.CGW_SEST_GNU_DL_DROP_PKTS,
        T1.CGW_SEST_GNU_DL_DROP_BYTES,
        T1.CGW_SEST_DHCP_DISC_HO_RCVED,
        T1.CGW_SEST_DHCP_DISC_HO_ACTED,
        T1.CGW_SEST_DHCP_DISC_HO_DEN,
        T1.CGW_SEST_UPD_DEN_NO_SESSMGR,
        T1.CGW_SEST_UPD_DEN_NO_MEMORY,
        T1.CGW_SEST_UPD_DEN_SESMGR_RJTED,
        T1.CGW_SEST_UPD_DEN_IN_QUEUE_EXC,
        T1.CGW_SEST_UPD_DEN_SIM_BIND_EXC,
        T1.CGW_SEST_UPD_DEN_ALLOC_FAIL,
        T1.THROUGHPUT_UL                 ,
        T1.THROUGHPUT_DL
   FROM CISCO_GGSN_SAMOG_HOUR T1,
        (SELECT FECHA, VPNID, SERVID, VALOR
        FROM (
              SELECT F1.FECHA,
                     F1.VPNID,
                     F1.SERVID,
                     F1.THROUGHPUT_DL VALOR,
                     ROW_NUMBER() OVER (PARTITION BY TRUNC(F1.FECHA),
                                                     F1.VPNID,
                                                     F1.SERVID
                                            ORDER BY (F1.THROUGHPUT_DL) DESC,
                                                     F1.FECHA DESC) SEQNUM
              FROM (
                     SELECT T1.FECHA, T1.VPNID, T1.SERVID, T1.THROUGHPUT_DL
                     FROM CISCO_GGSN_SAMOG_HOUR T1
                     WHERE FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                                     AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + (86399 / 86400)
                   ) F1
              )
        WHERE SEQNUM = 1
       ) AUX,
       CISCO_GGSN_SAMOG_BH T2
 WHERE T1.FECHA = AUX.FECHA
   AND T1.VPNID = AUX.VPNID
   AND T1.SERVID = AUX.SERVID
   AND TRUNC(T1.FECHA) = T2.FECHA (+)
   AND T1.VPNID = T2.VPNID (+)
   AND T1.SERVID = T2.SERVID (+)
   AND T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                    AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND T2.VPNID IS NULL
   AND T2.SERVID IS NULL;

BEGIN

OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
LOOP
  FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
  BEGIN
    FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
      INSERT INTO CISCO_GGSN_SAMOG_BH VALUES T_ARRAY_COL (I);
  EXCEPTION
    WHEN DML_ERRORS THEN
      -- CAPTURE EXCEPTIONS TO PERFORM OPERATIONS DML
           L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
              FOR I IN 1 .. L_ERRORS
              LOOP
                  L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                  L_MSG   := SQLERRM(-L_ERRNO);
                  L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                  G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_BH',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

              END LOOP;
  -- END --
  END;
  EXIT WHEN CUR%NOTFOUND;
END LOOP;
COMMIT;
CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_BH',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_SAMOG_ISABHW (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 28.12.2016.
-- Actualizacion: Matias Orquera. Fecha: 04.01.2017. Motivo: Se modificaron los esquemas de RAW, contadores y KPIs :@

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);

TYPE T_ARRAY_TAB IS TABLE OF CISCO_GGSN_SAMOG_ISABHW%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
 SELECT TRUNC(T1.FECHA,'DAY')                                                          FECHA,
        T1.EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_UEACTIVE),4)                                    CGW_SESTAT_TOTCUR_UEACTIVE,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_UESETUP),4)                                     CGW_SESTAT_TOTCUR_UESETUP,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_UERELEASED),4)                                  CGW_SESTAT_TOTCUR_UERELEASED,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_PDNACTIVE),4)                                   CGW_SESTAT_TOTCUR_PDNACTIVE,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_PDNSETUP),4)                                    CGW_SESTAT_TOTCUR_PDNSETUP,
        ROUND(AVG(T1.CGW_SESTAT_TOT_PDNRELEASED),4)                                    CGW_SESTAT_TOT_PDNRELEASED,
        ROUND(AVG(T1.CGW_SESTAT_TOT_PDNREJECTED),4)                                    CGW_SESTAT_TOT_PDNREJECTED,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_PDN_IPV4),4)                                    CGW_SESTAT_TOTCUR_PDN_IPV4,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_PDN_IPV6),4)                                    CGW_SESTAT_TOTCUR_PDN_IPV6,
        ROUND(AVG(T1.CGW_SESTAT_TOTCUR_PDN_IPV4V6),4)                                  CGW_SESTAT_TOTCUR_PDN_IPV4V6,
        ROUND(AVG(T1.CGW_SESTAT_PDNSETUPTYPE_IPV4),4)                                  CGW_SESTAT_PDNSETUPTYPE_IPV4,
        ROUND(AVG(T1.CGW_SESTAT_PDNSETUPTYPE_IPV6),4)                                  CGW_SESTAT_PDNSETUPTYPE_IPV6,
        ROUND(AVG(T1.CGW_SESTAT_PDNSETUPTYPE_IPV4V6),4)                                CGW_SESTAT_PDNSETUPTYPE_IPV4V6,
        ROUND(AVG(T1.CGW_SESTAT_PDNREL_IPV4),4)                                        CGW_SESTAT_PDNREL_IPV4,
        ROUND(AVG(T1.CGW_SESTAT_PDNREL_IPV6),4)                                        CGW_SESTAT_PDNREL_IPV6,
        ROUND(AVG(T1.CGW_SESTAT_PDNREL_IPV4V6),4)                                      CGW_SESTAT_PDNREL_IPV4V6,
        ROUND(AVG(T1.CGW_SEST_GNU_UL_PKTS),4)                                          CGW_SEST_GNU_UL_PKTS,
        ROUND(AVG(T1.CGW_SEST_GNU_UL_BYTES),4)                                         CGW_SEST_GNU_UL_BYTES,
        ROUND(AVG(T1.CGW_SEST_GNU_UL_DROP_PKTS),4)                                     CGW_SEST_GNU_UL_DROP_PKTS,
        ROUND(AVG(T1.CGW_SEST_GNU_UL_DROP_BYTES),4)                                    CGW_SEST_GNU_UL_DROP_BYTES,
        ROUND(AVG(T1.CGW_SEST_GNU_DL_PKTS),4)                                          CGW_SEST_GNU_DL_PKTS,
        ROUND(AVG(T1.CGW_SEST_GNU_DL_BYTES),4)                                         CGW_SEST_GNU_DL_BYTES,
        ROUND(AVG(T1.CGW_SEST_GNU_DL_DROP_PKTS),4)                                     CGW_SEST_GNU_DL_DROP_PKTS,
        ROUND(AVG(T1.CGW_SEST_GNU_DL_DROP_BYTES),4)                                    CGW_SEST_GNU_DL_DROP_BYTES,
        ROUND(AVG(T1.CGW_SEST_DHCP_DISC_HO_RCVED),4)                                   CGW_SEST_DHCP_DISC_HO_RCVED,
        ROUND(AVG(T1.CGW_SEST_DHCP_DISC_HO_ACTED),4)                                   CGW_SEST_DHCP_DISC_HO_ACTED,
        ROUND(AVG(T1.CGW_SEST_DHCP_DISC_HO_DEN),4)                                     CGW_SEST_DHCP_DISC_HO_DEN,
        ROUND(AVG(T1.CGW_SEST_UPD_DEN_NO_SESSMGR),4)                                   CGW_SEST_UPD_DEN_NO_SESSMGR,
        ROUND(AVG(T1.CGW_SEST_UPD_DEN_NO_MEMORY),4)                                    CGW_SEST_UPD_DEN_NO_MEMORY,
        ROUND(AVG(T1.CGW_SEST_UPD_DEN_SESMGR_RJTED),4)                                 CGW_SEST_UPD_DEN_SESMGR_RJTED,
        ROUND(AVG(T1.CGW_SEST_UPD_DEN_IN_QUEUE_EXC),4)                                 CGW_SEST_UPD_DEN_IN_QUEUE_EXC,
        ROUND(AVG(T1.CGW_SEST_UPD_DEN_SIM_BIND_EXC),4)                                 CGW_SEST_UPD_DEN_SIM_BIND_EXC,
        ROUND(AVG(T1.CGW_SEST_UPD_DEN_ALLOC_FAIL),4)                                   CGW_SEST_UPD_DEN_ALLOC_FAIL,
        ROUND(AVG(T1.THROUGHPUT_UL),4)                                                 THROUGHPUT_UL,
        ROUND(AVG(AUX.THROUGHPUT_DL),4)                                                THROUGHPUT_DL
   FROM CISCO_GGSN_SAMOG_BH T1,
        (
         SELECT  TRUNC(FECHA, 'DAY') FECHA,
                 VPNID,
                 SERVID,
                 ROUND(AVG(THROUGHPUT_DL),4) THROUGHPUT_DL
            FROM (
                  SELECT FECHA,
                         VPNID,
                         SERVID,
                         THROUGHPUT_DL,
                         ROW_NUMBER() OVER(PARTITION BY VPNID, SERVID ORDER BY THROUGHPUT_DL DESC, FECHA DESC NULLS LAST) ORDEN
                    FROM (

                          SELECT A.FECHA,
                                 A.VPNID,
                                 A.SERVID,
                                 A.THROUGHPUT_DL
                            FROM CISCO_GGSN_SAMOG_BH A
                           WHERE FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                                           AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+86399/86400
                         )
                 )
           WHERE ORDEN <= 3
        GROUP BY TRUNC(FECHA, 'DAY'),
                 VPNID,
                 SERVID
       ) AUX,
       CISCO_GGSN_SAMOG_ISABHW T2
 WHERE TRUNC(T1.FECHA,'DAY') = AUX.FECHA
   AND T1.VPNID = AUX.VPNID
   AND T1.SERVID = AUX.SERVID
   AND TRUNC(T1.FECHA,'DAY') = T2.FECHA (+)
   AND T1.VPNID = T2.VPNID (+)
   AND T1.SERVID = T2.SERVID (+)
   AND T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                    AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+86399/86400
   AND T2.VPNID IS NULL
   AND T2.SERVID IS NULL
GROUP BY TRUNC(T1.FECHA,'DAY'),
        T1.EQUIPO,
        T1.VPNNAME,
        T1.VPNID,
        T1.SERVNAME,
        T1.SERVID;

BEGIN

OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);
LOOP
  FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
  BEGIN
    FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
      INSERT INTO CISCO_GGSN_SAMOG_ISABHW VALUES T_ARRAY_COL (I);
  EXCEPTION
    WHEN DML_ERRORS THEN
      -- CAPTURE EXCEPTIONS TO PERFORM OPERATIONS DML
           L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
              FOR I IN 1 .. L_ERRORS
              LOOP
                  L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                  L_MSG   := SQLERRM(-L_ERRNO);
                  L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;

                  G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_ISABHW',L_ERRNO,L_MSG,
                    'V_BULK_ERRORS EXCEPTION FECHA: '||
                    TO_CHAR(T_ARRAY_COL(L_IDX).FECHA)||
                    ' SERVID '||TO_CHAR(T_ARRAY_COL(L_IDX).SERVID));

              END LOOP;
  -- END --
  END;
  EXIT WHEN CUR%NOTFOUND;
END LOOP;
COMMIT;
CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    L_ERRNO := SQLCODE;
    L_MSG   := SQLERRM;
    G_ERROR_LOG_NEW.P_LOG_ERROR('P_CISCO_GGSN_SAMOG_ISABHW',L_ERRNO,L_MSG,'');
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

PROCEDURE P_CISCO_GGSN_EPDG_SAMOG_JOB_H
IS

-- Autor: Matias Orquera. Fecha: 19.01.2017.

P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24') - 5/24, 'DD.MM.YYYY HH24');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24') - 2/24, 'DD.MM.YYYY HH24');

BEGIN
   P_CISCO_GGSN_EPDG_HOUR(P_FECHA_DESDE, P_FECHA_HASTA);
   P_CISCO_GGSN_SAMOG_HOUR(P_FECHA_DESDE, P_FECHA_HASTA);
END;

PROCEDURE P_CISCO_GGSN_EPDG_SAMOG_JOB_D
IS
-- Autor: Matias Orquera. Fecha: 19.01.2017.

P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DD') -3, 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DD') -1, 'DD.MM.YYYY');

 BEGIN

 P_CISCO_GGSN_EPDG_DAY(P_FECHA_DESDE, P_FECHA_HASTA);
 P_CISCO_GGSN_EPDG_BH(P_FECHA_DESDE, P_FECHA_HASTA);
 
 P_CISCO_GGSN_SAMOG_DAY(P_FECHA_DESDE, P_FECHA_HASTA);
 P_CISCO_GGSN_SAMOG_BH(P_FECHA_DESDE, P_FECHA_HASTA);

 END;
 
PROCEDURE P_CISCO_GGSN_EPDG_SAMOG_JOB_W
IS
-- Autor: Matias Orquera. Fecha: 19.01.2017.

P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DAY') - 7, 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DAY') - 1, 'DD.MM.YYYY');


 BEGIN

 P_CISCO_GGSN_EPDG_ISABHW(P_FECHA_DESDE, P_FECHA_HASTA);

 P_CISCO_GGSN_SAMOG_ISABHW(P_FECHA_DESDE, P_FECHA_HASTA);

 END;
 
PROCEDURE P_CISCO_GGSN_EPDG_REWORK_HOUR(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 24.01.2017.

BEGIN
  G_PARTITION_MGM.P_TRUNCATE_PART_HOUR('CISCO_GGSN_EPDG_HOUR',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_EPDG_HOUR(P_FECHA_DESDE, P_FECHA_HASTA);
  --LANZA NIVEL DAY
  --P_CISCO_GGSN_EPDG_REWORK_DAY(TRUNC(TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')), TRUNC(TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')));
  --P_CISCO_GGSN_EPDG_REWORK_BH(TRUNC(TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')), TRUNC(TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')));

END;

PROCEDURE P_CISCO_GGSN_EPDG_REWORK_DAY(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 24.01.2017.

BEGIN
  G_PARTITION_MGM.P_TRUNCATE_PART_DAY('CISCO_GGSN_EPDG_DAY',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_EPDG_DAY(P_FECHA_DESDE, P_FECHA_HASTA);
END;

PROCEDURE P_CISCO_GGSN_EPDG_REWORK_BH(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 24.01.2017.

BEGIN
  G_PARTITION_MGM.P_TRUNCATE_PART_DAY('CISCO_GGSN_EPDG_BH',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_EPDG_BH(P_FECHA_DESDE, P_FECHA_HASTA);
END;

PROCEDURE P_CISCO_GGSN_EPDG_REWORK_WEEK (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 16.02.2017.

BEGIN

  G_PARTITION_MGM.P_TRUNCATE_PART_DAY('CISCO_GGSN_EPDG_ISABHW',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_EPDG_ISABHW(P_FECHA_DESDE, P_FECHA_HASTA);

END;

PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_HOUR(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 24.01.2017.

BEGIN
  G_PARTITION_MGM.P_TRUNCATE_PART_HOUR('CISCO_GGSN_SAMOG_HOUR',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_SAMOG_HOUR(P_FECHA_DESDE, P_FECHA_HASTA);
  --LANZA NIVEL DAY
  --P_CISCO_GGSN_SAMOG_REWORK_DAY(TRUNC(TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')), TRUNC(TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')));
  --P_CISCO_GGSN_SAMOG_REWORK_BH(TRUNC(TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')), TRUNC(TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')));
END; 

PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_DAY(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 24.01.2017.

BEGIN
  G_PARTITION_MGM.P_TRUNCATE_PART_DAY('CISCO_GGSN_SAMOG_DAY',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_SAMOG_DAY(P_FECHA_DESDE, P_FECHA_HASTA);
END;

PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_BH(P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 24.01.2017.

BEGIN
  G_PARTITION_MGM.P_TRUNCATE_PART_DAY('CISCO_GGSN_SAMOG_BH',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_SAMOG_BH(P_FECHA_DESDE, P_FECHA_HASTA);
END;

PROCEDURE P_CISCO_GGSN_SAMOG_REWORK_WEEK (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

-- Autor: Matias Orquera. Fecha: 16.02.2017.

BEGIN

  G_PARTITION_MGM.P_TRUNCATE_PART_DAY('CISCO_GGSN_SAMOG_ISABHW',P_FECHA_DESDE, P_FECHA_HASTA);
  P_CISCO_GGSN_SAMOG_ISABHW(P_FECHA_DESDE, P_FECHA_HASTA);

END;

END G_CISCO_GGSN_EPDG_SAMOG;
