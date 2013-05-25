  CREATE OR REPLACE FORCE VIEW "COBRA_HIERARQUIA_DOTACAO" ("FLEX_VALUE", "DESCRIPTION", "ATTRIBUTE1", "ATTRIBUTE2", "FLEX_VALUE_ID", "ATTRIBUTE6", "ATTRIBUTE3", "BLOQUEIO", "DOTACAO") AS 
  SELECT FFV.flex_value,  FFVT.description   , FFV.attribute1, FFV.attribute2, ffv.flex_value_id, ffv.attribute6, ffv.attribute3,
               SUM(DOTA.BLOQUEIO) BLOQUEIO, SUM(DOTA.DOTACAO) DOTACAO
          --, SYS_CONNECT_BY_PATH(ch.flex_value, '/') "Caminho"
       FROM FND_FLEX_VALUES      FFV,
            FND_FLEX_VALUES_TL   FFVT,
            COBRA_DOTACAO             DOTA
       WHERE 1=1
         AND dota.flex_value_id (+)  = ffv.flex_value_id
         AND SYSDATE BETWEEN NVL(DOTA.EFFECTIVE_START_DATE,SYSDATE-1) AND NVL(DOTA.EFFECTIVE_END_DATE,SYSDATE+10)
         AND FLEX_VALUE_SET_ID   = 1003450
         AND FFV.flex_value_id   = FFVT.flex_value_id
         AND FFVT.language       = 'PTB'
         AND FFV.ENABLED_FLAG    = 'Y'
         AND SYSDATE BETWEEN NVL(START_DATE_ACTIVE,SYSDATE-1) AND NVL(END_DATE_ACTIVE,TO_DATE('31/12/4712','DD/MM/YYYY'))
       GROUP BY FFV.flex_value,  FFVT.description   , FFV.attribute1, FFV.attribute2, ffv.flex_value_id, ffv.attribute6, ffv.attribute3
  ORDER BY TO_NUMBER(FFV.flex_value);
/
CREATE OR REPLACE FORCE VIEW "COBRA_HIERARQUIA_DOTACAO_QTD" ("CAMINHO", "NIVEL", "SIGLA", "DESCRICAO", "SUM_DOTACAO", "SUM_BLOQUEIO", "SUM_LOTACAO") AS 
  SELECT SYS_CONNECT_BY_PATH(DOTA.flex_value, '.') Caminho,
       LEVEL                                   Nivel, 
       DOTA.attribute3                           Sigla,
       DOTA.description                          Descricao,
       (SELECT SUM(DOTAID.DOTACAO)
          FROM COBRA_HIERARQUIA_DOTACAO DOTAID
    START WITH DOTAID.flex_value_id = DOTA.flex_value_id
  CONNECT BY PRIOR DOTAID.flex_value_id = DOTAID.attribute6) sum_dotacao,
       (SELECT SUM(DOTAIB.BLOQUEIO)
          FROM COBRA_HIERARQUIA_DOTACAO DOTAIB
    START WITH DOTAIB.flex_value_id = DOTA.flex_value_id
  CONNECT BY PRIOR DOTAIB.flex_value_id = DOTAIB.attribute6) sum_BLOQUEIO,
        0     AS SUM_LOTACAO
        FROM COBRA_HIERARQUIA_DOTACAO     DOTA
CONNECT BY NOCYCLE PRIOR DOTA.flex_value_id = DOTA.attribute6
START WITH  DOTA.attribute6 is not null and DOTA.attribute6 = '35620' --- PRESIDÊNCIA;
 
/



SELECT SUBSTR(TRIM(COBRA_UTILITY.GETPIECE(HAOU.NAME,'-',1)),-5) AS LOCAL,
       COBRA_UTILITY.GETPIECE(PRJB.NAME,'|',2) AS CARGO,
       COBRA_UTILITY.GETPIECE(PRFN.NAME,'|',2) AS CARGO_FUNCIONAL,
       COBRA_UTILITY.GETPIECE(PP.NAME,'|',2) AS CARGO_POSICIONAL,
       COUNT(*)
  FROM PER_ALL_PEOPLE_F            PAPF,
       PER_ALL_ASSIGNMENTS_F       PAAF,
       HR_ALL_ORGANIZATION_UNITS   HAOU,
       PER_ROLES                   PRLE,
       PER_JOBS                    PRJB, 
       PER_JOBS                    PRFN,
       PER_POSITIONS               PP
 WHERE PP.POSITION_ID           = PAAF.POSITION_ID
   AND SYSDATE BETWEEN NVL(PRFN.DATE_FROM,SYSDATE-1) AND NVL(PRFN.DATE_TO,SYSDATE + 1)
   AND PRFN.JOB_ID      (+)    = PAAF.JOB_ID
   AND SYSDATE BETWEEN NVL(PRJB.DATE_FROM,SYSDATE-1) AND NVL(PRJB.DATE_TO,SYSDATE + 1)
   AND PRJB.JOB_ID      (+)    = PRLE.JOB_ID
   AND SYSDATE BETWEEN NVL(PRLE.START_DATE,SYSDATE-1) AND NVL(PRLE.END_DATE,SYSDATE + 1)
   AND PRLE.PERSON_ID   (+)     = PAPF.PERSON_ID 
   AND HAOU.ORGANIZATION_ID  = PAAF.ORGANIZATION_ID
   AND SYSDATE BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE
   AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
   AND PAAF.PRIMARY_FLAG     = 'Y'
   AND PAAF.PERSON_ID        = PAPF.PERSON_ID
   AND PAPF.EMPLOYEE_NUMBER  IN ('5664', '5149' , '103923', '105431')
GROUP BY SUBSTR(TRIM(COBRA_UTILITY.GETPIECE(HAOU.NAME,'-',1)),-5), 
         COBRA_UTILITY.GETPIECE(PRJB.NAME,'|',2),COBRA_UTILITY.GETPIECE(PRFN.NAME,'|',2),
         COBRA_UTILITY.GETPIECE(PP.NAME,'|',2)


<h:panelGroup>
                    <h:selectOneRadio id="gender" value="#{registrationController.person.gender}" 
                                      required="true" requiredMessage="#{msg.commonErrorBlankField}">
                        <f:selectItems value="#{registrationController.genders}" />
                    </h:selectOneRadio>
                    <rich:spacer />
                    <rich:message for="gender" errorLabelClass="errorLabel">
                        <f:facet name="errorMarker">
                            <h:graphicImage value="#{msg.imageExclamation}" />
                        </f:facet>
                    </rich:message>
                </h:panelGroup>

void clearMessageForComponent (final String idComponent) {
        if (idComponent != null) {
            Iterator<FacesMessage> it = FacesContext.getCurrentInstance().getMessages(idComponent);
            while(it.hasNext()){
                ((FacesMessage)it.next()).setDetail("");
            }
        }
    }



CREATE TABLE COBRADOTACAO 
    ( 
     IDDOTACAO NUMBER (15)  NOT NULL , 
     EFFECTIVE_START_DATE DATE  NOT NULL , 
     EFFECTIVE_END_DATE DATE  NOT NULL , 
     JOB_ID NUMBER (15) , 
     ORGANIZATION_ID NUMBER (15) , 
     DOTACAO NUMBER (15) , 
     BLOQUEIO NUMBER (15) , 
     DOCUMENTO VARCHAR2 (40) , 
     LAST_UPDATE_DATE DATE , 
     LAST_UPDATED_BY NUMBER (15) , 
     CREATION_DATE DATE , 
     CREATED_BY NUMBER (15) 
    ) 
;



ALTER TABLE COBRADOTACAO 
    ADD CONSTRAINT COBRADOTACAO_PK PRIMARY KEY ( IDDOTACAO, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE ) ;



CREATE SEQUENCE COBRADOTACAO_S 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER COBRADOTACAO_TRG 
BEFORE INSERT ON COBRADOTACAO 
FOR EACH ROW 
WHEN (NEW.IDDOTACAO IS NULL) 
BEGIN 
    SELECT COBRADOTACAO_S.NEXTVAL INTO :NEW.IDDOTACAO FROM DUAL; 
END;

            <a4j:status onstart="#{rich:component('popPanel')}.show()" 
                        onstop="#{rich:component('popPanel')}.hide()" />

                      <a4j:commandLink styleClass="no-decor" 
                                         render="editGrid" 
                                         execute="@this"
                                         oncomplete="#{rich:component('histPanel')}.show()">
                            
    <!--                        <a4j:param value="#{itStvr.index}" 
                                    assignTo="#{carsBean.currentCarIndex}" />
                            <f:setPropertyActionListener target="#{carsBean.editedCar}" value="#{car}" />
                            -->
                        </a4j:commandLink>

<rich:popupPanel id="popPanel" autosized="true">
                    <h:graphicImage alt="ai" 
                                    value="#{pageContext.request.contextPath}/imagens/ai.gif"  />
                    Aguarde verificando...
                </rich:popupPanel>      
                <rich:popupPanel header="#{campos.campoHistorico}" 
                                 id="histPanel" 
                                 domElementAttachment="parent" 
                                 width="400" 
                                 height="170">
                    <h:panelGrid columns="3" id="editGrid">
                        <rich:dataTable id="dTDotacaoHist" 
                                        styleClass="width: 820px; height: 520px;position: absolute;left: 19.5%;top: 5.3%;"
                                        var="dotacaoHist"
                                        columnClasses="align-center,align-left,align-left,align-left,align-center,align-center,align-center"
                                        rows="#{campos.numerolinhaDataTable}"
                                        value="#{dotacaoBean.todos}"
                                        rendered="#{loginBean.login.logado}">
                            <f:facet name="noData">
                                <h:outputLabel value="#{campos.APPHR1002}" />
                            </f:facet>
                        </rich:dataTable>
                    </h:panelGrid>
                    <a4j:commandButton value="#{campos.campoCancelar}" 
                                       onclick="#{rich:component('histPanel')}.hide();
                                               return false;" />
                </rich:popupPanel>
SELECT COBDOT.DOTACAO_ID,
  COBDOT.FLEX_VALUE_ID,
  FFVB.FLEX_VALUE  AS SCR,
  FFVB.ATTRIBUTE3  AS SCR_SIGLA,
  FFVT.DESCRIPTION AS DESCRICAO,
  COBDOT.LOOKUP_CODE,
  FLVL.MEANING,
  COBDOT.EFFECTIVE_START_DATE,
  COBDOT.EFFECTIVE_END_DATE,
  COBDOT.DOTACAO,
  COBDOT.BLOQUEIO,
  COBDOT.DOCUMENTO
FROM COBRA_DOTACAO COBDOT,
  FND_LOOKUP_VALUES_VL FLVL,
  FND_FLEX_VALUES_TL FFVT,
  FND_FLEX_VALUES FFVB
WHERE FLVL.lookup_type     = 'COB_HR_CARGOS_PCCS'
AND FLVL.LOOKUP_CODE       = COBDOT.LOOKUP_CODE
AND FFVB.FLEX_VALUE_ID     = FFVT.FLEX_VALUE_ID
AND FFVT.LANGUAGE          = 'PTB'
AND FFVB.VALUE_CATEGORY    = 'COB_GL_CENTRO'
AND FFVB.FLEX_VALUE_SET_ID = 1003450
AND FFVB.FLEX_VALUE_ID     = COBDOT.FLEX_VALUE_ID
AND DOTACAO_ID             = ?";


ALTER TABLE COBRA_DOTACAO 
    ADD CONSTRAINT COBRADOTACAO_PK PRIMARY KEY ( IDDOTACAO, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE ) ;



CREATE SEQUENCE COBRA_DOTACAO_S 
START WITH 1 
    NOCACHE 
    ORDER ;

set define off
CREATE OR REPLACE TRIGGER COBRA_DOTACAO_TRG 
BEFORE INSERT ON COBRA_DOTACAO 
FOR EACH ROW 
WHEN (NEW.DOTACAO_ID IS NULL) 
BEGIN 
    SELECT COBRA_DOTACAO_S.NEXTVAL INTO :NEW.DOTACAO_ID FROM DUAL; 
END COBRA_DOTACAO;

desc cobra_dotacao
alter table cobra_dotacao rename column iddotacao to  dotacao_id



