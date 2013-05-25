CREATE MATERIALIZED VIEW COBRA_LOTACAO
REFRESH FORCE
START WITH SYSDATE
NEXT SYSDATE + 1/24
AS
 SELECT NVL(SUBSTR(TRIM(COBRA_UTILITY.GETPIECE(HAOU.NAME,'-',1)),-5),'01000')   AS LOCAL,
        UPPER(NVL(PRLE.ATTRIBUTE2,COBRA_UTILITY.GETPIECE(PRFN.NAME,'|',2))) AS CARGO,
        COUNT(*)                                                            AS QTDADE
  FROM PER_ALL_PEOPLE_F            PAPF,
       PER_ALL_ASSIGNMENTS_F       PAAF,
       HR_ALL_ORGANIZATION_UNITS   HAOU,
       PER_ROLES                   PRLE,
       PER_JOBS                    PRJB, 
       PER_JOBS                    PRFN,
       PER_PERIODS_OF_SERVICE      PPOS
 WHERE SYSDATE BETWEEN NVL(PRFN.DATE_FROM,SYSDATE-1) AND NVL(PRFN.DATE_TO,SYSDATE + 1)
   AND PRFN.JOB_ID      (+)    = PAAF.JOB_ID
   AND SYSDATE BETWEEN NVL(PRJB.DATE_FROM,SYSDATE-1) AND NVL(PRJB.DATE_TO,SYSDATE + 1)
   AND PRJB.JOB_ID      (+)    = PRLE.JOB_ID
   AND SYSDATE BETWEEN NVL(PRLE.START_DATE,SYSDATE-1) AND NVL(PRLE.END_DATE,SYSDATE + 1)
   AND PRLE.PERSON_ID   (+)     = PAPF.PERSON_ID 
   AND HAOU.ORGANIZATION_ID     = PAAF.ORGANIZATION_ID
   AND SYSDATE BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE
   AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
   AND PAAF.PRIMARY_FLAG     = 'Y'
   AND PAAF.PERSON_ID        = PAPF.PERSON_ID
   AND PPOS.ACTUAL_TERMINATION_DATE IS NULL
   AND PPOS.PERSON_ID        = PAPF.PERSON_ID
   AND NVL(PRLE.ATTRIBUTE2,PRFN.NAME) IS NOT NULL
   AND HAOU.NAME IS NOT NULL
GROUP BY SUBSTR(TRIM(COBRA_UTILITY.GETPIECE(HAOU.NAME,'-',1)),-5),NVL(PRLE.ATTRIBUTE2,COBRA_UTILITY.GETPIECE(PRFN.NAME,'|',2))
ORDER BY 1