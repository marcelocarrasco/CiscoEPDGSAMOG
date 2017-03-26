CREATE TABLE CISCO_GGSN_SAMOG_HOUR
   (  
    FECHA                                     DATE,
    EQUIPO                                    VARCHAR2(30),
    VPNNAME                                   VARCHAR2(30),
    VPNID                                     NUMBER,
    SERVNAME                                  VARCHAR2(30),
    SERVID                                    NUMBER,
    CGW_SESTAT_TOTCUR_UEACTIVE                NUMBER,
    CGW_SESTAT_TOTCUR_UESETUP                 NUMBER,
    CGW_SESTAT_TOTCUR_UERELEASED              NUMBER,
    CGW_SESTAT_TOTCUR_PDNACTIVE               NUMBER,
    CGW_SESTAT_TOTCUR_PDNSETUP                NUMBER,
    CGW_SESTAT_TOT_PDNRELEASED                NUMBER,
    CGW_SESTAT_TOT_PDNREJECTED                NUMBER,
    CGW_SESTAT_TOTCUR_PDN_IPV4                NUMBER,
    CGW_SESTAT_TOTCUR_PDN_IPV6                NUMBER,
    CGW_SESTAT_TOTCUR_PDN_IPV4V6              NUMBER,
    CGW_SESTAT_PDNSETUPTYPE_IPV4              NUMBER,
    CGW_SESTAT_PDNSETUPTYPE_IPV6              NUMBER,
    CGW_SESTAT_PDNSETUPTYPE_IPV4V6            NUMBER,
    CGW_SESTAT_PDNREL_IPV4                    NUMBER,
    CGW_SESTAT_PDNREL_IPV6                    NUMBER,
    CGW_SESTAT_PDNREL_IPV4V6                  NUMBER,
    CGW_SEST_GNU_UL_PKTS                      NUMBER,
    CGW_SEST_GNU_UL_BYTES                     NUMBER,
    CGW_SEST_GNU_UL_DROP_PKTS                 NUMBER,
    CGW_SEST_GNU_UL_DROP_BYTES                NUMBER,
    CGW_SEST_GNU_DL_PKTS                      NUMBER,
    CGW_SEST_GNU_DL_BYTES                     NUMBER,
    CGW_SEST_GNU_DL_DROP_PKTS                 NUMBER,
    CGW_SEST_GNU_DL_DROP_BYTES                NUMBER,
    CGW_SEST_DHCP_DISC_HO_RCVED               NUMBER,
    CGW_SEST_DHCP_DISC_HO_ACTED               NUMBER,
    CGW_SEST_DHCP_DISC_HO_DEN                 NUMBER,
    CGW_SEST_UPD_DEN_NO_SESSMGR               NUMBER,
    CGW_SEST_UPD_DEN_NO_MEMORY                NUMBER,
    CGW_SEST_UPD_DEN_SESMGR_RJTED             NUMBER,
    CGW_SEST_UPD_DEN_IN_QUEUE_EXC             NUMBER,
    CGW_SEST_UPD_DEN_SIM_BIND_EXC             NUMBER,
    CGW_SEST_UPD_DEN_ALLOC_FAIL               NUMBER,
    THROUGHPUT_UL                             NUMBER,
    THROUGHPUT_DL                             NUMBER
  )
  TABLESPACE DEVELOPER 
  PARTITION BY RANGE (FECHA) INTERVAL (NUMTODSINTERVAL (1,'HOUR'))  
 (
 PARTITION SAMOG_GGSN_2016121500  VALUES LESS THAN (TO_DATE(' 2016-12-15 01:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
 );
 
 ALTER TABLE CISCO_GGSN_SAMOG_HOUR ADD CONSTRAINT CISCO_GGSN_SAMOG_HOUR_PK PRIMARY KEY (FECHA, VPNID, SERVID)
USING INDEX LOCAL TABLESPACE DEVELOPER;